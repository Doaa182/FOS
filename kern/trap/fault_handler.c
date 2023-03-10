/*
 * fault_handler.c
 *
 *  Created on: Oct 12, 2022
 *      Author: HP
 */

#include "trap.h"
#include <kern/proc/user_environment.h>
#include "../cpu/sched.h"
#include "../disk/pagefile_manager.h"
#include "../mem/memory_manager.h"

//2014 Test Free(): Set it to bypass the PAGE FAULT on an instruction with this length and continue executing the next one
// 0 means don't bypass the PAGE FAULT
uint8 bypassInstrLength = 0;

//===============================
// REPLACEMENT STRATEGIES
//===============================
//2020
void setPageReplacmentAlgorithmLRU(int LRU_TYPE) {
	assert(
			LRU_TYPE == PG_REP_LRU_TIME_APPROX || LRU_TYPE == PG_REP_LRU_LISTS_APPROX);
	_PageRepAlgoType = LRU_TYPE;
}
void setPageReplacmentAlgorithmCLOCK() {
	_PageRepAlgoType = PG_REP_CLOCK;
}
void setPageReplacmentAlgorithmFIFO() {
	_PageRepAlgoType = PG_REP_FIFO;
}
void setPageReplacmentAlgorithmModifiedCLOCK() {
	_PageRepAlgoType = PG_REP_MODIFIEDCLOCK;
}
/*2018*/void setPageReplacmentAlgorithmDynamicLocal() {
	_PageRepAlgoType = PG_REP_DYNAMIC_LOCAL;
}
/*2021*/void setPageReplacmentAlgorithmNchanceCLOCK(int PageWSMaxSweeps) {
	_PageRepAlgoType = PG_REP_NchanceCLOCK;
	page_WS_max_sweeps = PageWSMaxSweeps;
}

//2020
uint32 isPageReplacmentAlgorithmLRU(int LRU_TYPE) {
	return _PageRepAlgoType == LRU_TYPE ? 1 : 0;
}
uint32 isPageReplacmentAlgorithmCLOCK() {
	if (_PageRepAlgoType == PG_REP_CLOCK)
		return 1;
	return 0;
}
uint32 isPageReplacmentAlgorithmFIFO() {
	if (_PageRepAlgoType == PG_REP_FIFO)
		return 1;
	return 0;
}
uint32 isPageReplacmentAlgorithmModifiedCLOCK() {
	if (_PageRepAlgoType == PG_REP_MODIFIEDCLOCK)
		return 1;
	return 0;
}
/*2018*/uint32 isPageReplacmentAlgorithmDynamicLocal() {
	if (_PageRepAlgoType == PG_REP_DYNAMIC_LOCAL)
		return 1;
	return 0;
}
/*2021*/uint32 isPageReplacmentAlgorithmNchanceCLOCK() {
	if (_PageRepAlgoType == PG_REP_NchanceCLOCK)
		return 1;
	return 0;
}

//===============================
// PAGE BUFFERING
//===============================
void enableModifiedBuffer(uint32 enableIt) {
	_EnableModifiedBuffer = enableIt;
}
uint8 isModifiedBufferEnabled() {
	return _EnableModifiedBuffer;
}

void enableBuffering(uint32 enableIt) {
	_EnableBuffering = enableIt;
}
uint8 isBufferingEnabled() {
	return _EnableBuffering;
}

void setModifiedBufferLength(uint32 length) {
	_ModifiedBufferLength = length;
}
uint32 getModifiedBufferLength() {
	return _ModifiedBufferLength;
}

//===============================
// FAULT HANDLERS
//===============================

//Handle the table fault
void table_fault_handler(struct Env * curenv, uint32 fault_va) {
	//panic("table_fault_handler() is not implemented yet...!!");
	//Check if it's a stack page
	uint32* ptr_table;
#if USE_KHEAP
	{
		ptr_table = create_page_table(curenv->env_page_directory,
				(uint32) fault_va);
	}
#else
	{
		__static_cpt(curenv->env_page_directory, (uint32)fault_va, &ptr_table);
	}
#endif
}

//Handle the page fault

void page_fault_handler(struct Env * curenv, uint32 fault_va) {
	//TODO: [PROJECT MS3] [page_fault_handler] page_fault_handler

	// Write your code here, remove the panic and write your code
	//panic("page_fault_handler() is not implemented yet...!!");

	fault_va = ROUNDDOWN(fault_va,PAGE_SIZE);
	struct FrameInfo *ptr_frame_info = NULL;
	uint32 *ptr_page_table = NULL;
	uint32 *ptr_page_table2 = NULL;
	uint32* page_directory = curenv->env_page_directory;
	uint32 perm;
	int isModified=-1;
	int isUsed=-1;
	uint32 empty;

	if ((env_page_ws_get_size(curenv)) == (curenv->page_WS_max_size))
	{

		uint32 va=0;
		while (1)
		{
			va = env_page_ws_get_virtual_address(curenv,curenv->page_last_WS_index);
			get_page_table(page_directory, va, (&ptr_page_table2));
			ptr_frame_info = get_frame_info(page_directory, va,
					&ptr_page_table2);

			perm = pt_get_page_permissions(page_directory, va);
			isModified = ((perm & PERM_MODIFIED) ? 1 : 0);
			isUsed = ((perm & PERM_USED) ? 1 : 0);

			if (isUsed == 0)
			{

				if (isModified == 1)
				{
					int update = pf_update_env_page(curenv, va, ptr_frame_info);
					unmap_frame(page_directory, va);
					env_page_ws_clear_entry(curenv,curenv->page_last_WS_index);
						break;

				} else if (isModified == 0)
				{

					unmap_frame(page_directory, va);
					env_page_ws_clear_entry(curenv, curenv->page_last_WS_index);
					break;
				}
			}
			else if (isUsed == 1)
			{
				pt_set_page_permissions(page_directory, va, 0, PERM_USED);

			}
			curenv->page_last_WS_index = (curenv->page_last_WS_index + 1)% (curenv->page_WS_max_size);
		}
	}

	if ((env_page_ws_get_size(curenv)) < (curenv->page_WS_max_size))
	{
		get_page_table(page_directory, fault_va, (&ptr_page_table));

		//	allocate
		allocate_frame(&ptr_frame_info);
		map_frame(page_directory, ptr_frame_info, fault_va,PERM_USER | PERM_WRITEABLE);

		//	read
		int read = pf_read_env_page(curenv, (void*)fault_va);

		//page ! exist
		if (read == E_PAGE_NOT_EXIST_IN_PF)
		{
			//if    not stack or heap

			if (!((USER_HEAP_START <= fault_va && fault_va<USER_HEAP_MAX)|| (USTACKTOP > fault_va && fault_va>=USTACKBOTTOM)))
			{
				unmap_frame(page_directory, fault_va);
				panic("ILLEGAL MEMORY ACCESS");
			}

		}

		while (1) {
			empty = env_page_ws_is_entry_empty(curenv,
					curenv->page_last_WS_index);

			if (empty == 1) {
				env_page_ws_set_entry(curenv, curenv->page_last_WS_index,fault_va);
				curenv->page_last_WS_index = (curenv->page_last_WS_index + 1)% (curenv->page_WS_max_size);
				break;
			}
			curenv->page_last_WS_index = (curenv->page_last_WS_index + 1)% (curenv->page_WS_max_size);

		}
	}

	//refer to the project presentation and documentation for details
}

void __page_fault_handler_with_buffering(struct Env * curenv, uint32 fault_va) {
	// Write your code here, remove the panic and write your code
	panic("__page_fault_handler_with_buffering() is not implemented yet...!!");

}
