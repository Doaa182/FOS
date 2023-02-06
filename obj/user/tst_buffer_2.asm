
obj/user/tst_buffer_2:     file format elf32-i386


Disassembly of section .text:

00800020 <_start>:
// starts us running when we are initially loaded into a new environment.
.text
.globl _start
_start:
	// See if we were started with arguments on the stack
	mov $0, %eax
  800020:	b8 00 00 00 00       	mov    $0x0,%eax
	cmpl $USTACKTOP, %esp
  800025:	81 fc 00 e0 bf ee    	cmp    $0xeebfe000,%esp
	jne args_exist
  80002b:	75 04                	jne    800031 <args_exist>

	// If not, push dummy argc/argv arguments.
	// This happens when we are loaded by the kernel,
	// because the kernel does not know about passing arguments.
	pushl $0
  80002d:	6a 00                	push   $0x0
	pushl $0
  80002f:	6a 00                	push   $0x0

00800031 <args_exist>:

args_exist:
	call libmain
  800031:	e8 26 09 00 00       	call   80095c <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
/*SHOULD be on User DATA not on the STACK*/
char arr[PAGE_SIZE*1024*14 + PAGE_SIZE];
//=========================================

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	83 ec 6c             	sub    $0x6c,%esp



	/*[1] CHECK INITIAL WORKING SET*/
	{
		if( ROUNDDOWN(myEnv->__uptr_pws[0].virtual_address,PAGE_SIZE) !=   0x200000)  	panic("INITIAL PAGE WS entry checking failed! Review sizes of the two WS's..!!");
  800041:	a1 20 30 80 00       	mov    0x803020,%eax
  800046:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  80004c:	8b 00                	mov    (%eax),%eax
  80004e:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800051:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800054:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800059:	3d 00 00 20 00       	cmp    $0x200000,%eax
  80005e:	74 14                	je     800074 <_main+0x3c>
  800060:	83 ec 04             	sub    $0x4,%esp
  800063:	68 60 24 80 00       	push   $0x802460
  800068:	6a 17                	push   $0x17
  80006a:	68 a8 24 80 00       	push   $0x8024a8
  80006f:	e8 24 0a 00 00       	call   800a98 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[1].virtual_address,PAGE_SIZE) !=   0x201000)  panic("INITIAL PAGE WS entry checking failed! Review sizes of the two WS's..!!");
  800074:	a1 20 30 80 00       	mov    0x803020,%eax
  800079:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  80007f:	83 c0 18             	add    $0x18,%eax
  800082:	8b 00                	mov    (%eax),%eax
  800084:	89 45 d8             	mov    %eax,-0x28(%ebp)
  800087:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80008a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80008f:	3d 00 10 20 00       	cmp    $0x201000,%eax
  800094:	74 14                	je     8000aa <_main+0x72>
  800096:	83 ec 04             	sub    $0x4,%esp
  800099:	68 60 24 80 00       	push   $0x802460
  80009e:	6a 18                	push   $0x18
  8000a0:	68 a8 24 80 00       	push   $0x8024a8
  8000a5:	e8 ee 09 00 00       	call   800a98 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[2].virtual_address,PAGE_SIZE) !=   0x202000)  panic("INITIAL PAGE WS entry checking failed! Review sizes of the two WS's..!!");
  8000aa:	a1 20 30 80 00       	mov    0x803020,%eax
  8000af:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  8000b5:	83 c0 30             	add    $0x30,%eax
  8000b8:	8b 00                	mov    (%eax),%eax
  8000ba:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8000bd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8000c0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8000c5:	3d 00 20 20 00       	cmp    $0x202000,%eax
  8000ca:	74 14                	je     8000e0 <_main+0xa8>
  8000cc:	83 ec 04             	sub    $0x4,%esp
  8000cf:	68 60 24 80 00       	push   $0x802460
  8000d4:	6a 19                	push   $0x19
  8000d6:	68 a8 24 80 00       	push   $0x8024a8
  8000db:	e8 b8 09 00 00       	call   800a98 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[3].virtual_address,PAGE_SIZE) !=   0x203000)  panic("INITIAL PAGE WS entry checking failed! Review sizes of the two WS's..!!");
  8000e0:	a1 20 30 80 00       	mov    0x803020,%eax
  8000e5:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  8000eb:	83 c0 48             	add    $0x48,%eax
  8000ee:	8b 00                	mov    (%eax),%eax
  8000f0:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8000f3:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8000f6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8000fb:	3d 00 30 20 00       	cmp    $0x203000,%eax
  800100:	74 14                	je     800116 <_main+0xde>
  800102:	83 ec 04             	sub    $0x4,%esp
  800105:	68 60 24 80 00       	push   $0x802460
  80010a:	6a 1a                	push   $0x1a
  80010c:	68 a8 24 80 00       	push   $0x8024a8
  800111:	e8 82 09 00 00       	call   800a98 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[4].virtual_address,PAGE_SIZE) !=   0x204000)  panic("INITIAL PAGE WS entry checking failed! Review sizes of the two WS's..!!");
  800116:	a1 20 30 80 00       	mov    0x803020,%eax
  80011b:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800121:	83 c0 60             	add    $0x60,%eax
  800124:	8b 00                	mov    (%eax),%eax
  800126:	89 45 cc             	mov    %eax,-0x34(%ebp)
  800129:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80012c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800131:	3d 00 40 20 00       	cmp    $0x204000,%eax
  800136:	74 14                	je     80014c <_main+0x114>
  800138:	83 ec 04             	sub    $0x4,%esp
  80013b:	68 60 24 80 00       	push   $0x802460
  800140:	6a 1b                	push   $0x1b
  800142:	68 a8 24 80 00       	push   $0x8024a8
  800147:	e8 4c 09 00 00       	call   800a98 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[5].virtual_address,PAGE_SIZE) !=   0x205000)  panic("INITIAL PAGE WS entry checking failed! Review sizes of the two WS's..!!");
  80014c:	a1 20 30 80 00       	mov    0x803020,%eax
  800151:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800157:	83 c0 78             	add    $0x78,%eax
  80015a:	8b 00                	mov    (%eax),%eax
  80015c:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80015f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800162:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800167:	3d 00 50 20 00       	cmp    $0x205000,%eax
  80016c:	74 14                	je     800182 <_main+0x14a>
  80016e:	83 ec 04             	sub    $0x4,%esp
  800171:	68 60 24 80 00       	push   $0x802460
  800176:	6a 1c                	push   $0x1c
  800178:	68 a8 24 80 00       	push   $0x8024a8
  80017d:	e8 16 09 00 00       	call   800a98 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[6].virtual_address,PAGE_SIZE) !=   0x800000)  panic("INITIAL PAGE WS entry checking failed! Review sizes of the two WS's..!!");
  800182:	a1 20 30 80 00       	mov    0x803020,%eax
  800187:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  80018d:	05 90 00 00 00       	add    $0x90,%eax
  800192:	8b 00                	mov    (%eax),%eax
  800194:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  800197:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80019a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80019f:	3d 00 00 80 00       	cmp    $0x800000,%eax
  8001a4:	74 14                	je     8001ba <_main+0x182>
  8001a6:	83 ec 04             	sub    $0x4,%esp
  8001a9:	68 60 24 80 00       	push   $0x802460
  8001ae:	6a 1d                	push   $0x1d
  8001b0:	68 a8 24 80 00       	push   $0x8024a8
  8001b5:	e8 de 08 00 00       	call   800a98 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[7].virtual_address,PAGE_SIZE) !=   0x801000)  panic("INITIAL PAGE WS entry checking failed! Review sizes of the two WS's..!!");
  8001ba:	a1 20 30 80 00       	mov    0x803020,%eax
  8001bf:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  8001c5:	05 a8 00 00 00       	add    $0xa8,%eax
  8001ca:	8b 00                	mov    (%eax),%eax
  8001cc:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8001cf:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8001d2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001d7:	3d 00 10 80 00       	cmp    $0x801000,%eax
  8001dc:	74 14                	je     8001f2 <_main+0x1ba>
  8001de:	83 ec 04             	sub    $0x4,%esp
  8001e1:	68 60 24 80 00       	push   $0x802460
  8001e6:	6a 1e                	push   $0x1e
  8001e8:	68 a8 24 80 00       	push   $0x8024a8
  8001ed:	e8 a6 08 00 00       	call   800a98 <_panic>
		//if( ROUNDDOWN(myEnv->__uptr_pws[7].virtual_address,PAGE_SIZE) !=   0x802000)  panic("INITIAL PAGE WS entry checking failed! Review sizes of the two WS's..!!");
		if( ROUNDDOWN(myEnv->__uptr_pws[8].virtual_address,PAGE_SIZE) !=   0x802000)  panic("INITIAL PAGE WS entry checking failed! Review sizes of the two WS's..!!");
  8001f2:	a1 20 30 80 00       	mov    0x803020,%eax
  8001f7:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  8001fd:	05 c0 00 00 00       	add    $0xc0,%eax
  800202:	8b 00                	mov    (%eax),%eax
  800204:	89 45 bc             	mov    %eax,-0x44(%ebp)
  800207:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80020a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80020f:	3d 00 20 80 00       	cmp    $0x802000,%eax
  800214:	74 14                	je     80022a <_main+0x1f2>
  800216:	83 ec 04             	sub    $0x4,%esp
  800219:	68 60 24 80 00       	push   $0x802460
  80021e:	6a 20                	push   $0x20
  800220:	68 a8 24 80 00       	push   $0x8024a8
  800225:	e8 6e 08 00 00       	call   800a98 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[9].virtual_address,PAGE_SIZE) !=   0x803000)  panic("INITIAL PAGE WS entry checking failed! Review sizes of the two WS's..!!");
  80022a:	a1 20 30 80 00       	mov    0x803020,%eax
  80022f:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800235:	05 d8 00 00 00       	add    $0xd8,%eax
  80023a:	8b 00                	mov    (%eax),%eax
  80023c:	89 45 b8             	mov    %eax,-0x48(%ebp)
  80023f:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800242:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800247:	3d 00 30 80 00       	cmp    $0x803000,%eax
  80024c:	74 14                	je     800262 <_main+0x22a>
  80024e:	83 ec 04             	sub    $0x4,%esp
  800251:	68 60 24 80 00       	push   $0x802460
  800256:	6a 21                	push   $0x21
  800258:	68 a8 24 80 00       	push   $0x8024a8
  80025d:	e8 36 08 00 00       	call   800a98 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[10].virtual_address,PAGE_SIZE) !=   0xeebfd000)  panic("INITIAL PAGE WS entry checking failed! Review sizes of the two WS's..!!");
  800262:	a1 20 30 80 00       	mov    0x803020,%eax
  800267:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  80026d:	05 f0 00 00 00       	add    $0xf0,%eax
  800272:	8b 00                	mov    (%eax),%eax
  800274:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  800277:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80027a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80027f:	3d 00 d0 bf ee       	cmp    $0xeebfd000,%eax
  800284:	74 14                	je     80029a <_main+0x262>
  800286:	83 ec 04             	sub    $0x4,%esp
  800289:	68 60 24 80 00       	push   $0x802460
  80028e:	6a 22                	push   $0x22
  800290:	68 a8 24 80 00       	push   $0x8024a8
  800295:	e8 fe 07 00 00       	call   800a98 <_panic>
		if( myEnv->page_last_WS_index !=  0)  										panic("INITIAL PAGE WS last index checking failed! Review sizes of the two WS's..!!");
  80029a:	a1 20 30 80 00       	mov    0x803020,%eax
  80029f:	8b 80 2c 05 00 00    	mov    0x52c(%eax),%eax
  8002a5:	85 c0                	test   %eax,%eax
  8002a7:	74 14                	je     8002bd <_main+0x285>
  8002a9:	83 ec 04             	sub    $0x4,%esp
  8002ac:	68 bc 24 80 00       	push   $0x8024bc
  8002b1:	6a 23                	push   $0x23
  8002b3:	68 a8 24 80 00       	push   $0x8024a8
  8002b8:	e8 db 07 00 00       	call   800a98 <_panic>

	/*[2] RUN THE SLAVE PROGRAM*/

	//****************************************************************************************************************
	//IMP: program name is placed statically on the stack to avoid PAGE FAULT on it during the sys call inside the Kernel
	char slaveProgName[10] = "tpb2slave";
  8002bd:	8d 45 92             	lea    -0x6e(%ebp),%eax
  8002c0:	bb 43 28 80 00       	mov    $0x802843,%ebx
  8002c5:	ba 0a 00 00 00       	mov    $0xa,%edx
  8002ca:	89 c7                	mov    %eax,%edi
  8002cc:	89 de                	mov    %ebx,%esi
  8002ce:	89 d1                	mov    %edx,%ecx
  8002d0:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
	//****************************************************************************************************************

	int32 envIdSlave = sys_create_env(slaveProgName, (myEnv->page_WS_max_size),(myEnv->SecondListSize), (myEnv->percentage_of_WS_pages_to_be_removed));
  8002d2:	a1 20 30 80 00       	mov    0x803020,%eax
  8002d7:	8b 90 a0 05 00 00    	mov    0x5a0(%eax),%edx
  8002dd:	a1 20 30 80 00       	mov    0x803020,%eax
  8002e2:	8b 80 ec 05 00 00    	mov    0x5ec(%eax),%eax
  8002e8:	89 c1                	mov    %eax,%ecx
  8002ea:	a1 20 30 80 00       	mov    0x803020,%eax
  8002ef:	8b 40 74             	mov    0x74(%eax),%eax
  8002f2:	52                   	push   %edx
  8002f3:	51                   	push   %ecx
  8002f4:	50                   	push   %eax
  8002f5:	8d 45 92             	lea    -0x6e(%ebp),%eax
  8002f8:	50                   	push   %eax
  8002f9:	e8 36 1b 00 00       	call   801e34 <sys_create_env>
  8002fe:	83 c4 10             	add    $0x10,%esp
  800301:	89 45 b0             	mov    %eax,-0x50(%ebp)
	int initModBufCnt = sys_calculate_modified_frames();
  800304:	e8 d2 18 00 00       	call   801bdb <sys_calculate_modified_frames>
  800309:	89 45 ac             	mov    %eax,-0x54(%ebp)
	sys_run_env(envIdSlave);
  80030c:	83 ec 0c             	sub    $0xc,%esp
  80030f:	ff 75 b0             	pushl  -0x50(%ebp)
  800312:	e8 3b 1b 00 00       	call   801e52 <sys_run_env>
  800317:	83 c4 10             	add    $0x10,%esp

	/*[3] BUSY-WAIT FOR A WHILE TILL FINISHING IT*/
	env_sleep(5000);
  80031a:	83 ec 0c             	sub    $0xc,%esp
  80031d:	68 88 13 00 00       	push   $0x1388
  800322:	e8 0d 1e 00 00       	call   802134 <env_sleep>
  800327:	83 c4 10             	add    $0x10,%esp


	//NOW: modified list contains 7 pages from the slave program
	if (sys_calculate_modified_frames() - initModBufCnt  != 7)  panic("Error in BUFFERING/RESTORING of modified frames of the slave ... WRONG number of buffered pages in MODIFIED frame list");
  80032a:	e8 ac 18 00 00       	call   801bdb <sys_calculate_modified_frames>
  80032f:	89 c2                	mov    %eax,%edx
  800331:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800334:	29 c2                	sub    %eax,%edx
  800336:	89 d0                	mov    %edx,%eax
  800338:	83 f8 07             	cmp    $0x7,%eax
  80033b:	74 14                	je     800351 <_main+0x319>
  80033d:	83 ec 04             	sub    $0x4,%esp
  800340:	68 0c 25 80 00       	push   $0x80250c
  800345:	6a 36                	push   $0x36
  800347:	68 a8 24 80 00       	push   $0x8024a8
  80034c:	e8 47 07 00 00       	call   800a98 <_panic>


	/*START OF TST_BUFFER_2*/
	int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800351:	e8 0c 19 00 00       	call   801c62 <sys_pf_calculate_allocated_pages>
  800356:	89 45 a8             	mov    %eax,-0x58(%ebp)
	int freePages = sys_calculate_free_frames();
  800359:	e8 64 18 00 00       	call   801bc2 <sys_calculate_free_frames>
  80035e:	89 45 a4             	mov    %eax,-0x5c(%ebp)
	initModBufCnt = sys_calculate_modified_frames();
  800361:	e8 75 18 00 00       	call   801bdb <sys_calculate_modified_frames>
  800366:	89 45 ac             	mov    %eax,-0x54(%ebp)
	int initFreeBufCnt = sys_calculate_notmod_frames();
  800369:	e8 86 18 00 00       	call   801bf4 <sys_calculate_notmod_frames>
  80036e:	89 45 a0             	mov    %eax,-0x60(%ebp)
	int dummy = 0;
  800371:	c7 45 9c 00 00 00 00 	movl   $0x0,-0x64(%ebp)
	//Fault #1
	int i=0;
  800378:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for(;i<1;i++)
  80037f:	eb 0e                	jmp    80038f <_main+0x357>
	{
		arr[i] = -1;
  800381:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800384:	05 60 30 80 00       	add    $0x803060,%eax
  800389:	c6 00 ff             	movb   $0xff,(%eax)
	initModBufCnt = sys_calculate_modified_frames();
	int initFreeBufCnt = sys_calculate_notmod_frames();
	int dummy = 0;
	//Fault #1
	int i=0;
	for(;i<1;i++)
  80038c:	ff 45 e4             	incl   -0x1c(%ebp)
  80038f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800393:	7e ec                	jle    800381 <_main+0x349>
	{
		arr[i] = -1;
	}
	dummy = sys_calculate_notmod_frames() + myEnv->env_id;	//Always use page #: 800000, 801000, 803000
  800395:	e8 5a 18 00 00       	call   801bf4 <sys_calculate_notmod_frames>
  80039a:	89 c2                	mov    %eax,%edx
  80039c:	a1 20 30 80 00       	mov    0x803020,%eax
  8003a1:	8b 40 4c             	mov    0x4c(%eax),%eax
  8003a4:	01 d0                	add    %edx,%eax
  8003a6:	89 45 9c             	mov    %eax,-0x64(%ebp)

	//Fault #2
	i=PAGE_SIZE*1024;
  8003a9:	c7 45 e4 00 00 40 00 	movl   $0x400000,-0x1c(%ebp)
	for(;i<PAGE_SIZE*1024+1;i++)
  8003b0:	eb 0e                	jmp    8003c0 <_main+0x388>
	{
		arr[i] = -1;
  8003b2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003b5:	05 60 30 80 00       	add    $0x803060,%eax
  8003ba:	c6 00 ff             	movb   $0xff,(%eax)
	}
	dummy = sys_calculate_notmod_frames() + myEnv->env_id;	//Always use page #: 800000, 801000, 803000

	//Fault #2
	i=PAGE_SIZE*1024;
	for(;i<PAGE_SIZE*1024+1;i++)
  8003bd:	ff 45 e4             	incl   -0x1c(%ebp)
  8003c0:	81 7d e4 00 00 40 00 	cmpl   $0x400000,-0x1c(%ebp)
  8003c7:	7e e9                	jle    8003b2 <_main+0x37a>
	{
		arr[i] = -1;
	}
	dummy = sys_calculate_notmod_frames() + myEnv->env_id;	//Always use page #: 800000, 801000, 803000
  8003c9:	e8 26 18 00 00       	call   801bf4 <sys_calculate_notmod_frames>
  8003ce:	89 c2                	mov    %eax,%edx
  8003d0:	a1 20 30 80 00       	mov    0x803020,%eax
  8003d5:	8b 40 4c             	mov    0x4c(%eax),%eax
  8003d8:	01 d0                	add    %edx,%eax
  8003da:	89 45 9c             	mov    %eax,-0x64(%ebp)

	//Fault #3
	i=PAGE_SIZE*1024*2;
  8003dd:	c7 45 e4 00 00 80 00 	movl   $0x800000,-0x1c(%ebp)
	for(;i<PAGE_SIZE*1024*2+1;i++)
  8003e4:	eb 0e                	jmp    8003f4 <_main+0x3bc>
	{
		arr[i] = -1;
  8003e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8003e9:	05 60 30 80 00       	add    $0x803060,%eax
  8003ee:	c6 00 ff             	movb   $0xff,(%eax)
	}
	dummy = sys_calculate_notmod_frames() + myEnv->env_id;	//Always use page #: 800000, 801000, 803000

	//Fault #3
	i=PAGE_SIZE*1024*2;
	for(;i<PAGE_SIZE*1024*2+1;i++)
  8003f1:	ff 45 e4             	incl   -0x1c(%ebp)
  8003f4:	81 7d e4 00 00 80 00 	cmpl   $0x800000,-0x1c(%ebp)
  8003fb:	7e e9                	jle    8003e6 <_main+0x3ae>
	{
		arr[i] = -1;
	}
	dummy = sys_calculate_notmod_frames() + myEnv->env_id;	//Always use page #: 800000, 801000, 803000
  8003fd:	e8 f2 17 00 00       	call   801bf4 <sys_calculate_notmod_frames>
  800402:	89 c2                	mov    %eax,%edx
  800404:	a1 20 30 80 00       	mov    0x803020,%eax
  800409:	8b 40 4c             	mov    0x4c(%eax),%eax
  80040c:	01 d0                	add    %edx,%eax
  80040e:	89 45 9c             	mov    %eax,-0x64(%ebp)

	//Fault #4
	i=PAGE_SIZE*1024*3;
  800411:	c7 45 e4 00 00 c0 00 	movl   $0xc00000,-0x1c(%ebp)
	for(;i<PAGE_SIZE*1024*3+1;i++)
  800418:	eb 0e                	jmp    800428 <_main+0x3f0>
	{
		arr[i] = -1;
  80041a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80041d:	05 60 30 80 00       	add    $0x803060,%eax
  800422:	c6 00 ff             	movb   $0xff,(%eax)
	}
	dummy = sys_calculate_notmod_frames() + myEnv->env_id;	//Always use page #: 800000, 801000, 803000

	//Fault #4
	i=PAGE_SIZE*1024*3;
	for(;i<PAGE_SIZE*1024*3+1;i++)
  800425:	ff 45 e4             	incl   -0x1c(%ebp)
  800428:	81 7d e4 00 00 c0 00 	cmpl   $0xc00000,-0x1c(%ebp)
  80042f:	7e e9                	jle    80041a <_main+0x3e2>
	{
		arr[i] = -1;
	}
	dummy = sys_calculate_notmod_frames() + myEnv->env_id;	//Always use page #: 800000, 801000, 803000
  800431:	e8 be 17 00 00       	call   801bf4 <sys_calculate_notmod_frames>
  800436:	89 c2                	mov    %eax,%edx
  800438:	a1 20 30 80 00       	mov    0x803020,%eax
  80043d:	8b 40 4c             	mov    0x4c(%eax),%eax
  800440:	01 d0                	add    %edx,%eax
  800442:	89 45 9c             	mov    %eax,-0x64(%ebp)

	//Fault #5
	i=PAGE_SIZE*1024*4;
  800445:	c7 45 e4 00 00 00 01 	movl   $0x1000000,-0x1c(%ebp)
	for(;i<PAGE_SIZE*1024*4+1;i++)
  80044c:	eb 0e                	jmp    80045c <_main+0x424>
	{
		arr[i] = -1;
  80044e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800451:	05 60 30 80 00       	add    $0x803060,%eax
  800456:	c6 00 ff             	movb   $0xff,(%eax)
	}
	dummy = sys_calculate_notmod_frames() + myEnv->env_id;	//Always use page #: 800000, 801000, 803000

	//Fault #5
	i=PAGE_SIZE*1024*4;
	for(;i<PAGE_SIZE*1024*4+1;i++)
  800459:	ff 45 e4             	incl   -0x1c(%ebp)
  80045c:	81 7d e4 00 00 00 01 	cmpl   $0x1000000,-0x1c(%ebp)
  800463:	7e e9                	jle    80044e <_main+0x416>
	{
		arr[i] = -1;
	}
	dummy = sys_calculate_notmod_frames() + myEnv->env_id;	//Always use page #: 800000, 801000, 803000
  800465:	e8 8a 17 00 00       	call   801bf4 <sys_calculate_notmod_frames>
  80046a:	89 c2                	mov    %eax,%edx
  80046c:	a1 20 30 80 00       	mov    0x803020,%eax
  800471:	8b 40 4c             	mov    0x4c(%eax),%eax
  800474:	01 d0                	add    %edx,%eax
  800476:	89 45 9c             	mov    %eax,-0x64(%ebp)

	//Fault #6
	i=PAGE_SIZE*1024*5;
  800479:	c7 45 e4 00 00 40 01 	movl   $0x1400000,-0x1c(%ebp)
	for(;i<PAGE_SIZE*1024*5+1;i++)
  800480:	eb 0e                	jmp    800490 <_main+0x458>
	{
		arr[i] = -1;
  800482:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800485:	05 60 30 80 00       	add    $0x803060,%eax
  80048a:	c6 00 ff             	movb   $0xff,(%eax)
	}
	dummy = sys_calculate_notmod_frames() + myEnv->env_id;	//Always use page #: 800000, 801000, 803000

	//Fault #6
	i=PAGE_SIZE*1024*5;
	for(;i<PAGE_SIZE*1024*5+1;i++)
  80048d:	ff 45 e4             	incl   -0x1c(%ebp)
  800490:	81 7d e4 00 00 40 01 	cmpl   $0x1400000,-0x1c(%ebp)
  800497:	7e e9                	jle    800482 <_main+0x44a>
	{
		arr[i] = -1;
	}
	dummy = sys_calculate_notmod_frames() + myEnv->env_id;	//Always use page #: 800000, 801000, 803000
  800499:	e8 56 17 00 00       	call   801bf4 <sys_calculate_notmod_frames>
  80049e:	89 c2                	mov    %eax,%edx
  8004a0:	a1 20 30 80 00       	mov    0x803020,%eax
  8004a5:	8b 40 4c             	mov    0x4c(%eax),%eax
  8004a8:	01 d0                	add    %edx,%eax
  8004aa:	89 45 9c             	mov    %eax,-0x64(%ebp)

	//Fault #7
	i=PAGE_SIZE*1024*6;
  8004ad:	c7 45 e4 00 00 80 01 	movl   $0x1800000,-0x1c(%ebp)
	for(;i<PAGE_SIZE*1024*6+1;i++)
  8004b4:	eb 0e                	jmp    8004c4 <_main+0x48c>
	{
		arr[i] = -1;
  8004b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8004b9:	05 60 30 80 00       	add    $0x803060,%eax
  8004be:	c6 00 ff             	movb   $0xff,(%eax)
	}
	dummy = sys_calculate_notmod_frames() + myEnv->env_id;	//Always use page #: 800000, 801000, 803000

	//Fault #7
	i=PAGE_SIZE*1024*6;
	for(;i<PAGE_SIZE*1024*6+1;i++)
  8004c1:	ff 45 e4             	incl   -0x1c(%ebp)
  8004c4:	81 7d e4 00 00 80 01 	cmpl   $0x1800000,-0x1c(%ebp)
  8004cb:	7e e9                	jle    8004b6 <_main+0x47e>
	{
		arr[i] = -1;
	}
	dummy = sys_calculate_notmod_frames() + myEnv->env_id;	//Always use page #: 800000, 801000, 803000
  8004cd:	e8 22 17 00 00       	call   801bf4 <sys_calculate_notmod_frames>
  8004d2:	89 c2                	mov    %eax,%edx
  8004d4:	a1 20 30 80 00       	mov    0x803020,%eax
  8004d9:	8b 40 4c             	mov    0x4c(%eax),%eax
  8004dc:	01 d0                	add    %edx,%eax
  8004de:	89 45 9c             	mov    %eax,-0x64(%ebp)

	//Fault #8
	i=PAGE_SIZE*1024*7;
  8004e1:	c7 45 e4 00 00 c0 01 	movl   $0x1c00000,-0x1c(%ebp)
	for(;i<PAGE_SIZE*1024*7+1;i++)
  8004e8:	eb 0e                	jmp    8004f8 <_main+0x4c0>
	{
		arr[i] = -1;
  8004ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8004ed:	05 60 30 80 00       	add    $0x803060,%eax
  8004f2:	c6 00 ff             	movb   $0xff,(%eax)
	}
	dummy = sys_calculate_notmod_frames() + myEnv->env_id;	//Always use page #: 800000, 801000, 803000

	//Fault #8
	i=PAGE_SIZE*1024*7;
	for(;i<PAGE_SIZE*1024*7+1;i++)
  8004f5:	ff 45 e4             	incl   -0x1c(%ebp)
  8004f8:	81 7d e4 00 00 c0 01 	cmpl   $0x1c00000,-0x1c(%ebp)
  8004ff:	7e e9                	jle    8004ea <_main+0x4b2>
	{
		arr[i] = -1;
	}
	dummy = sys_calculate_notmod_frames() + myEnv->env_id;	//Always use page #: 800000, 801000, 803000
  800501:	e8 ee 16 00 00       	call   801bf4 <sys_calculate_notmod_frames>
  800506:	89 c2                	mov    %eax,%edx
  800508:	a1 20 30 80 00       	mov    0x803020,%eax
  80050d:	8b 40 4c             	mov    0x4c(%eax),%eax
  800510:	01 d0                	add    %edx,%eax
  800512:	89 45 9c             	mov    %eax,-0x64(%ebp)

	//TILL NOW: 8 pages were brought into MEM and be modified (7 unmodified should be buffered)
	if (sys_calculate_notmod_frames()  - initFreeBufCnt != 7)
  800515:	e8 da 16 00 00       	call   801bf4 <sys_calculate_notmod_frames>
  80051a:	89 c2                	mov    %eax,%edx
  80051c:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80051f:	29 c2                	sub    %eax,%edx
  800521:	89 d0                	mov    %edx,%eax
  800523:	83 f8 07             	cmp    $0x7,%eax
  800526:	74 31                	je     800559 <_main+0x521>
	{
		sys_destroy_env(envIdSlave);
  800528:	83 ec 0c             	sub    $0xc,%esp
  80052b:	ff 75 b0             	pushl  -0x50(%ebp)
  80052e:	e8 3b 19 00 00       	call   801e6e <sys_destroy_env>
  800533:	83 c4 10             	add    $0x10,%esp
		panic("Error in BUFFERING/RESTORING of free frames... WRONG number of buffered pages in FREE frame list %d",sys_calculate_notmod_frames()  - initFreeBufCnt);
  800536:	e8 b9 16 00 00       	call   801bf4 <sys_calculate_notmod_frames>
  80053b:	89 c2                	mov    %eax,%edx
  80053d:	8b 45 a0             	mov    -0x60(%ebp),%eax
  800540:	29 c2                	sub    %eax,%edx
  800542:	89 d0                	mov    %edx,%eax
  800544:	50                   	push   %eax
  800545:	68 84 25 80 00       	push   $0x802584
  80054a:	68 83 00 00 00       	push   $0x83
  80054f:	68 a8 24 80 00       	push   $0x8024a8
  800554:	e8 3f 05 00 00       	call   800a98 <_panic>
	}
	if (sys_calculate_modified_frames() - initModBufCnt  != 0)
  800559:	e8 7d 16 00 00       	call   801bdb <sys_calculate_modified_frames>
  80055e:	89 c2                	mov    %eax,%edx
  800560:	8b 45 ac             	mov    -0x54(%ebp),%eax
  800563:	39 c2                	cmp    %eax,%edx
  800565:	74 25                	je     80058c <_main+0x554>
	{
		sys_destroy_env(envIdSlave);
  800567:	83 ec 0c             	sub    $0xc,%esp
  80056a:	ff 75 b0             	pushl  -0x50(%ebp)
  80056d:	e8 fc 18 00 00       	call   801e6e <sys_destroy_env>
  800572:	83 c4 10             	add    $0x10,%esp
		panic("Error in BUFFERING/RESTORING of modified frames... WRONG number of buffered pages in MODIFIED frame list");
  800575:	83 ec 04             	sub    $0x4,%esp
  800578:	68 e8 25 80 00       	push   $0x8025e8
  80057d:	68 88 00 00 00       	push   $0x88
  800582:	68 a8 24 80 00       	push   $0x8024a8
  800587:	e8 0c 05 00 00       	call   800a98 <_panic>
	}

	initFreeBufCnt = sys_calculate_notmod_frames();
  80058c:	e8 63 16 00 00       	call   801bf4 <sys_calculate_notmod_frames>
  800591:	89 45 a0             	mov    %eax,-0x60(%ebp)

	//The following 7 faults should victimize the 7 previously modified pages
	//(i.e. the modified list should be freed after 3 faults... then, two modified frames will be added to it again)
	//Fault #7
	i=PAGE_SIZE*1024*8;
  800594:	c7 45 e4 00 00 00 02 	movl   $0x2000000,-0x1c(%ebp)
	int s = 0;
  80059b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	for(;i<PAGE_SIZE*1024*8+1;i++)
  8005a2:	eb 13                	jmp    8005b7 <_main+0x57f>
	{
		s += arr[i] ;
  8005a4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8005a7:	05 60 30 80 00       	add    $0x803060,%eax
  8005ac:	8a 00                	mov    (%eax),%al
  8005ae:	0f be c0             	movsbl %al,%eax
  8005b1:	01 45 e0             	add    %eax,-0x20(%ebp)
	//The following 7 faults should victimize the 7 previously modified pages
	//(i.e. the modified list should be freed after 3 faults... then, two modified frames will be added to it again)
	//Fault #7
	i=PAGE_SIZE*1024*8;
	int s = 0;
	for(;i<PAGE_SIZE*1024*8+1;i++)
  8005b4:	ff 45 e4             	incl   -0x1c(%ebp)
  8005b7:	81 7d e4 00 00 00 02 	cmpl   $0x2000000,-0x1c(%ebp)
  8005be:	7e e4                	jle    8005a4 <_main+0x56c>
	{
		s += arr[i] ;
	}
	dummy = sys_calculate_notmod_frames() + myEnv->env_id;	//Always use page #: 800000, 801000, 803000
  8005c0:	e8 2f 16 00 00       	call   801bf4 <sys_calculate_notmod_frames>
  8005c5:	89 c2                	mov    %eax,%edx
  8005c7:	a1 20 30 80 00       	mov    0x803020,%eax
  8005cc:	8b 40 4c             	mov    0x4c(%eax),%eax
  8005cf:	01 d0                	add    %edx,%eax
  8005d1:	89 45 9c             	mov    %eax,-0x64(%ebp)

	//Fault #8
	i=PAGE_SIZE*1024*9;
  8005d4:	c7 45 e4 00 00 40 02 	movl   $0x2400000,-0x1c(%ebp)
	for(;i<PAGE_SIZE*1024*9+1;i++)
  8005db:	eb 13                	jmp    8005f0 <_main+0x5b8>
	{
		s += arr[i] ;
  8005dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8005e0:	05 60 30 80 00       	add    $0x803060,%eax
  8005e5:	8a 00                	mov    (%eax),%al
  8005e7:	0f be c0             	movsbl %al,%eax
  8005ea:	01 45 e0             	add    %eax,-0x20(%ebp)
	}
	dummy = sys_calculate_notmod_frames() + myEnv->env_id;	//Always use page #: 800000, 801000, 803000

	//Fault #8
	i=PAGE_SIZE*1024*9;
	for(;i<PAGE_SIZE*1024*9+1;i++)
  8005ed:	ff 45 e4             	incl   -0x1c(%ebp)
  8005f0:	81 7d e4 00 00 40 02 	cmpl   $0x2400000,-0x1c(%ebp)
  8005f7:	7e e4                	jle    8005dd <_main+0x5a5>
	{
		s += arr[i] ;
	}
	dummy = sys_calculate_notmod_frames() + myEnv->env_id;	//Always use page #: 800000, 801000, 803000
  8005f9:	e8 f6 15 00 00       	call   801bf4 <sys_calculate_notmod_frames>
  8005fe:	89 c2                	mov    %eax,%edx
  800600:	a1 20 30 80 00       	mov    0x803020,%eax
  800605:	8b 40 4c             	mov    0x4c(%eax),%eax
  800608:	01 d0                	add    %edx,%eax
  80060a:	89 45 9c             	mov    %eax,-0x64(%ebp)

	//Fault #9
	i=PAGE_SIZE*1024*10;
  80060d:	c7 45 e4 00 00 80 02 	movl   $0x2800000,-0x1c(%ebp)
	for(;i<PAGE_SIZE*1024*10+1;i++)
  800614:	eb 13                	jmp    800629 <_main+0x5f1>
	{
		s += arr[i] ;
  800616:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800619:	05 60 30 80 00       	add    $0x803060,%eax
  80061e:	8a 00                	mov    (%eax),%al
  800620:	0f be c0             	movsbl %al,%eax
  800623:	01 45 e0             	add    %eax,-0x20(%ebp)
	}
	dummy = sys_calculate_notmod_frames() + myEnv->env_id;	//Always use page #: 800000, 801000, 803000

	//Fault #9
	i=PAGE_SIZE*1024*10;
	for(;i<PAGE_SIZE*1024*10+1;i++)
  800626:	ff 45 e4             	incl   -0x1c(%ebp)
  800629:	81 7d e4 00 00 80 02 	cmpl   $0x2800000,-0x1c(%ebp)
  800630:	7e e4                	jle    800616 <_main+0x5de>
	{
		s += arr[i] ;
	}

	dummy = sys_calculate_notmod_frames() + myEnv->env_id;	//Always use page #: 800000, 801000, 803000
  800632:	e8 bd 15 00 00       	call   801bf4 <sys_calculate_notmod_frames>
  800637:	89 c2                	mov    %eax,%edx
  800639:	a1 20 30 80 00       	mov    0x803020,%eax
  80063e:	8b 40 4c             	mov    0x4c(%eax),%eax
  800641:	01 d0                	add    %edx,%eax
  800643:	89 45 9c             	mov    %eax,-0x64(%ebp)

	//HERE: modified list should be freed
	if (sys_calculate_modified_frames() != 0)
  800646:	e8 90 15 00 00       	call   801bdb <sys_calculate_modified_frames>
  80064b:	85 c0                	test   %eax,%eax
  80064d:	74 25                	je     800674 <_main+0x63c>
	{
		sys_destroy_env(envIdSlave);
  80064f:	83 ec 0c             	sub    $0xc,%esp
  800652:	ff 75 b0             	pushl  -0x50(%ebp)
  800655:	e8 14 18 00 00       	call   801e6e <sys_destroy_env>
  80065a:	83 c4 10             	add    $0x10,%esp
		panic("Modified frames not removed from list (or not updated) correctly when the modified list reaches MAX");
  80065d:	83 ec 04             	sub    $0x4,%esp
  800660:	68 54 26 80 00       	push   $0x802654
  800665:	68 ad 00 00 00       	push   $0xad
  80066a:	68 a8 24 80 00       	push   $0x8024a8
  80066f:	e8 24 04 00 00       	call   800a98 <_panic>
	}
	if ((sys_calculate_notmod_frames() - initFreeBufCnt) != 10)
  800674:	e8 7b 15 00 00       	call   801bf4 <sys_calculate_notmod_frames>
  800679:	89 c2                	mov    %eax,%edx
  80067b:	8b 45 a0             	mov    -0x60(%ebp),%eax
  80067e:	29 c2                	sub    %eax,%edx
  800680:	89 d0                	mov    %edx,%eax
  800682:	83 f8 0a             	cmp    $0xa,%eax
  800685:	74 25                	je     8006ac <_main+0x674>
	{
		sys_destroy_env(envIdSlave);
  800687:	83 ec 0c             	sub    $0xc,%esp
  80068a:	ff 75 b0             	pushl  -0x50(%ebp)
  80068d:	e8 dc 17 00 00       	call   801e6e <sys_destroy_env>
  800692:	83 c4 10             	add    $0x10,%esp
		panic("Modified frames not added to free frame list as BUFFERED when the modified list reaches MAX");
  800695:	83 ec 04             	sub    $0x4,%esp
  800698:	68 b8 26 80 00       	push   $0x8026b8
  80069d:	68 b2 00 00 00       	push   $0xb2
  8006a2:	68 a8 24 80 00       	push   $0x8024a8
  8006a7:	e8 ec 03 00 00       	call   800a98 <_panic>
	}

	//Three additional fault (i.e. three modified page will be added to modified list)
	//Fault #10
	i = PAGE_SIZE * 1024 * 11;
  8006ac:	c7 45 e4 00 00 c0 02 	movl   $0x2c00000,-0x1c(%ebp)
	for (; i < PAGE_SIZE * 1024*11 + 1; i++) {
  8006b3:	eb 13                	jmp    8006c8 <_main+0x690>
		s += arr[i] ;
  8006b5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006b8:	05 60 30 80 00       	add    $0x803060,%eax
  8006bd:	8a 00                	mov    (%eax),%al
  8006bf:	0f be c0             	movsbl %al,%eax
  8006c2:	01 45 e0             	add    %eax,-0x20(%ebp)
	}

	//Three additional fault (i.e. three modified page will be added to modified list)
	//Fault #10
	i = PAGE_SIZE * 1024 * 11;
	for (; i < PAGE_SIZE * 1024*11 + 1; i++) {
  8006c5:	ff 45 e4             	incl   -0x1c(%ebp)
  8006c8:	81 7d e4 00 00 c0 02 	cmpl   $0x2c00000,-0x1c(%ebp)
  8006cf:	7e e4                	jle    8006b5 <_main+0x67d>
		s += arr[i] ;
	}
	dummy = sys_calculate_notmod_frames() + myEnv->env_id;	//Always use page #: 800000, 801000, 803000
  8006d1:	e8 1e 15 00 00       	call   801bf4 <sys_calculate_notmod_frames>
  8006d6:	89 c2                	mov    %eax,%edx
  8006d8:	a1 20 30 80 00       	mov    0x803020,%eax
  8006dd:	8b 40 4c             	mov    0x4c(%eax),%eax
  8006e0:	01 d0                	add    %edx,%eax
  8006e2:	89 45 9c             	mov    %eax,-0x64(%ebp)

	//Fault #11
	i = PAGE_SIZE * 1024 * 12;
  8006e5:	c7 45 e4 00 00 00 03 	movl   $0x3000000,-0x1c(%ebp)
	for (; i < PAGE_SIZE * 1024*12 + 1; i++) {
  8006ec:	eb 13                	jmp    800701 <_main+0x6c9>
		s += arr[i] ;
  8006ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006f1:	05 60 30 80 00       	add    $0x803060,%eax
  8006f6:	8a 00                	mov    (%eax),%al
  8006f8:	0f be c0             	movsbl %al,%eax
  8006fb:	01 45 e0             	add    %eax,-0x20(%ebp)
	}
	dummy = sys_calculate_notmod_frames() + myEnv->env_id;	//Always use page #: 800000, 801000, 803000

	//Fault #11
	i = PAGE_SIZE * 1024 * 12;
	for (; i < PAGE_SIZE * 1024*12 + 1; i++) {
  8006fe:	ff 45 e4             	incl   -0x1c(%ebp)
  800701:	81 7d e4 00 00 00 03 	cmpl   $0x3000000,-0x1c(%ebp)
  800708:	7e e4                	jle    8006ee <_main+0x6b6>
		s += arr[i] ;
	}
	dummy = sys_calculate_notmod_frames() + myEnv->env_id;	//Always use page #: 800000, 801000, 803000
  80070a:	e8 e5 14 00 00       	call   801bf4 <sys_calculate_notmod_frames>
  80070f:	89 c2                	mov    %eax,%edx
  800711:	a1 20 30 80 00       	mov    0x803020,%eax
  800716:	8b 40 4c             	mov    0x4c(%eax),%eax
  800719:	01 d0                	add    %edx,%eax
  80071b:	89 45 9c             	mov    %eax,-0x64(%ebp)

	//Fault #12
	i = PAGE_SIZE * 1024 * 13;
  80071e:	c7 45 e4 00 00 40 03 	movl   $0x3400000,-0x1c(%ebp)
	for (; i < PAGE_SIZE * 1024*13 + 1; i++) {
  800725:	eb 13                	jmp    80073a <_main+0x702>
		s += arr[i] ;
  800727:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80072a:	05 60 30 80 00       	add    $0x803060,%eax
  80072f:	8a 00                	mov    (%eax),%al
  800731:	0f be c0             	movsbl %al,%eax
  800734:	01 45 e0             	add    %eax,-0x20(%ebp)
	}
	dummy = sys_calculate_notmod_frames() + myEnv->env_id;	//Always use page #: 800000, 801000, 803000

	//Fault #12
	i = PAGE_SIZE * 1024 * 13;
	for (; i < PAGE_SIZE * 1024*13 + 1; i++) {
  800737:	ff 45 e4             	incl   -0x1c(%ebp)
  80073a:	81 7d e4 00 00 40 03 	cmpl   $0x3400000,-0x1c(%ebp)
  800741:	7e e4                	jle    800727 <_main+0x6ef>
		s += arr[i] ;
	}
	dummy = sys_calculate_notmod_frames() + myEnv->env_id;	//Always use page #: 800000, 801000, 803000
  800743:	e8 ac 14 00 00       	call   801bf4 <sys_calculate_notmod_frames>
  800748:	89 c2                	mov    %eax,%edx
  80074a:	a1 20 30 80 00       	mov    0x803020,%eax
  80074f:	8b 40 4c             	mov    0x4c(%eax),%eax
  800752:	01 d0                	add    %edx,%eax
  800754:	89 45 9c             	mov    %eax,-0x64(%ebp)

	//cprintf("testing...\n");
	{
		if (sys_calculate_modified_frames() != 3)
  800757:	e8 7f 14 00 00       	call   801bdb <sys_calculate_modified_frames>
  80075c:	83 f8 03             	cmp    $0x3,%eax
  80075f:	74 25                	je     800786 <_main+0x74e>
		{
			sys_destroy_env(envIdSlave);
  800761:	83 ec 0c             	sub    $0xc,%esp
  800764:	ff 75 b0             	pushl  -0x50(%ebp)
  800767:	e8 02 17 00 00       	call   801e6e <sys_destroy_env>
  80076c:	83 c4 10             	add    $0x10,%esp
			panic("Modified frames not removed from list (or not updated) correctly when the modified list reaches MAX");
  80076f:	83 ec 04             	sub    $0x4,%esp
  800772:	68 54 26 80 00       	push   $0x802654
  800777:	68 d0 00 00 00       	push   $0xd0
  80077c:	68 a8 24 80 00       	push   $0x8024a8
  800781:	e8 12 03 00 00       	call   800a98 <_panic>
		}

		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0)
  800786:	e8 d7 14 00 00       	call   801c62 <sys_pf_calculate_allocated_pages>
  80078b:	3b 45 a8             	cmp    -0x58(%ebp),%eax
  80078e:	74 25                	je     8007b5 <_main+0x77d>
		{
			sys_destroy_env(envIdSlave);
  800790:	83 ec 0c             	sub    $0xc,%esp
  800793:	ff 75 b0             	pushl  -0x50(%ebp)
  800796:	e8 d3 16 00 00       	call   801e6e <sys_destroy_env>
  80079b:	83 c4 10             	add    $0x10,%esp
			panic("Unexpected extra/less pages have been added to page file.. NOT Expected to add new pages to the page file");
  80079e:	83 ec 04             	sub    $0x4,%esp
  8007a1:	68 14 27 80 00       	push   $0x802714
  8007a6:	68 d6 00 00 00       	push   $0xd6
  8007ab:	68 a8 24 80 00       	push   $0x8024a8
  8007b0:	e8 e3 02 00 00       	call   800a98 <_panic>
		}

		if( arr[0] != -1) 						{sys_destroy_env(envIdSlave);panic("modified page not updated on page file OR not reclaimed correctly");}
  8007b5:	a0 60 30 80 00       	mov    0x803060,%al
  8007ba:	3c ff                	cmp    $0xff,%al
  8007bc:	74 25                	je     8007e3 <_main+0x7ab>
  8007be:	83 ec 0c             	sub    $0xc,%esp
  8007c1:	ff 75 b0             	pushl  -0x50(%ebp)
  8007c4:	e8 a5 16 00 00       	call   801e6e <sys_destroy_env>
  8007c9:	83 c4 10             	add    $0x10,%esp
  8007cc:	83 ec 04             	sub    $0x4,%esp
  8007cf:	68 80 27 80 00       	push   $0x802780
  8007d4:	68 d9 00 00 00       	push   $0xd9
  8007d9:	68 a8 24 80 00       	push   $0x8024a8
  8007de:	e8 b5 02 00 00       	call   800a98 <_panic>
		if( arr[PAGE_SIZE * 1024 * 1] != -1) 	{sys_destroy_env(envIdSlave);panic("modified page not updated on page file OR not reclaimed correctly");}
  8007e3:	a0 60 30 c0 00       	mov    0xc03060,%al
  8007e8:	3c ff                	cmp    $0xff,%al
  8007ea:	74 25                	je     800811 <_main+0x7d9>
  8007ec:	83 ec 0c             	sub    $0xc,%esp
  8007ef:	ff 75 b0             	pushl  -0x50(%ebp)
  8007f2:	e8 77 16 00 00       	call   801e6e <sys_destroy_env>
  8007f7:	83 c4 10             	add    $0x10,%esp
  8007fa:	83 ec 04             	sub    $0x4,%esp
  8007fd:	68 80 27 80 00       	push   $0x802780
  800802:	68 da 00 00 00       	push   $0xda
  800807:	68 a8 24 80 00       	push   $0x8024a8
  80080c:	e8 87 02 00 00       	call   800a98 <_panic>
		if( arr[PAGE_SIZE * 1024 * 2] != -1) 	{sys_destroy_env(envIdSlave);panic("modified page not updated on page file OR not reclaimed correctly");}
  800811:	a0 60 30 00 01       	mov    0x1003060,%al
  800816:	3c ff                	cmp    $0xff,%al
  800818:	74 25                	je     80083f <_main+0x807>
  80081a:	83 ec 0c             	sub    $0xc,%esp
  80081d:	ff 75 b0             	pushl  -0x50(%ebp)
  800820:	e8 49 16 00 00       	call   801e6e <sys_destroy_env>
  800825:	83 c4 10             	add    $0x10,%esp
  800828:	83 ec 04             	sub    $0x4,%esp
  80082b:	68 80 27 80 00       	push   $0x802780
  800830:	68 db 00 00 00       	push   $0xdb
  800835:	68 a8 24 80 00       	push   $0x8024a8
  80083a:	e8 59 02 00 00       	call   800a98 <_panic>
		if( arr[PAGE_SIZE * 1024 * 3] != -1) 	{sys_destroy_env(envIdSlave);panic("modified page not updated on page file OR not reclaimed correctly");}
  80083f:	a0 60 30 40 01       	mov    0x1403060,%al
  800844:	3c ff                	cmp    $0xff,%al
  800846:	74 25                	je     80086d <_main+0x835>
  800848:	83 ec 0c             	sub    $0xc,%esp
  80084b:	ff 75 b0             	pushl  -0x50(%ebp)
  80084e:	e8 1b 16 00 00       	call   801e6e <sys_destroy_env>
  800853:	83 c4 10             	add    $0x10,%esp
  800856:	83 ec 04             	sub    $0x4,%esp
  800859:	68 80 27 80 00       	push   $0x802780
  80085e:	68 dc 00 00 00       	push   $0xdc
  800863:	68 a8 24 80 00       	push   $0x8024a8
  800868:	e8 2b 02 00 00       	call   800a98 <_panic>
		if( arr[PAGE_SIZE * 1024 * 4] != -1) 	{sys_destroy_env(envIdSlave);panic("modified page not updated on page file OR not reclaimed correctly");}
  80086d:	a0 60 30 80 01       	mov    0x1803060,%al
  800872:	3c ff                	cmp    $0xff,%al
  800874:	74 25                	je     80089b <_main+0x863>
  800876:	83 ec 0c             	sub    $0xc,%esp
  800879:	ff 75 b0             	pushl  -0x50(%ebp)
  80087c:	e8 ed 15 00 00       	call   801e6e <sys_destroy_env>
  800881:	83 c4 10             	add    $0x10,%esp
  800884:	83 ec 04             	sub    $0x4,%esp
  800887:	68 80 27 80 00       	push   $0x802780
  80088c:	68 dd 00 00 00       	push   $0xdd
  800891:	68 a8 24 80 00       	push   $0x8024a8
  800896:	e8 fd 01 00 00       	call   800a98 <_panic>
		if( arr[PAGE_SIZE * 1024 * 5] != -1) 	{sys_destroy_env(envIdSlave);panic("modified page not updated on page file OR not reclaimed correctly");}
  80089b:	a0 60 30 c0 01       	mov    0x1c03060,%al
  8008a0:	3c ff                	cmp    $0xff,%al
  8008a2:	74 25                	je     8008c9 <_main+0x891>
  8008a4:	83 ec 0c             	sub    $0xc,%esp
  8008a7:	ff 75 b0             	pushl  -0x50(%ebp)
  8008aa:	e8 bf 15 00 00       	call   801e6e <sys_destroy_env>
  8008af:	83 c4 10             	add    $0x10,%esp
  8008b2:	83 ec 04             	sub    $0x4,%esp
  8008b5:	68 80 27 80 00       	push   $0x802780
  8008ba:	68 de 00 00 00       	push   $0xde
  8008bf:	68 a8 24 80 00       	push   $0x8024a8
  8008c4:	e8 cf 01 00 00       	call   800a98 <_panic>
		if( arr[PAGE_SIZE * 1024 * 6] != -1) 	{sys_destroy_env(envIdSlave);panic("modified page not updated on page file OR not reclaimed correctly");}
  8008c9:	a0 60 30 00 02       	mov    0x2003060,%al
  8008ce:	3c ff                	cmp    $0xff,%al
  8008d0:	74 25                	je     8008f7 <_main+0x8bf>
  8008d2:	83 ec 0c             	sub    $0xc,%esp
  8008d5:	ff 75 b0             	pushl  -0x50(%ebp)
  8008d8:	e8 91 15 00 00       	call   801e6e <sys_destroy_env>
  8008dd:	83 c4 10             	add    $0x10,%esp
  8008e0:	83 ec 04             	sub    $0x4,%esp
  8008e3:	68 80 27 80 00       	push   $0x802780
  8008e8:	68 df 00 00 00       	push   $0xdf
  8008ed:	68 a8 24 80 00       	push   $0x8024a8
  8008f2:	e8 a1 01 00 00       	call   800a98 <_panic>
		if( arr[PAGE_SIZE * 1024 * 7] != -1) 	{sys_destroy_env(envIdSlave);panic("modified page not updated on page file OR not reclaimed correctly");}
  8008f7:	a0 60 30 40 02       	mov    0x2403060,%al
  8008fc:	3c ff                	cmp    $0xff,%al
  8008fe:	74 25                	je     800925 <_main+0x8ed>
  800900:	83 ec 0c             	sub    $0xc,%esp
  800903:	ff 75 b0             	pushl  -0x50(%ebp)
  800906:	e8 63 15 00 00       	call   801e6e <sys_destroy_env>
  80090b:	83 c4 10             	add    $0x10,%esp
  80090e:	83 ec 04             	sub    $0x4,%esp
  800911:	68 80 27 80 00       	push   $0x802780
  800916:	68 e0 00 00 00       	push   $0xe0
  80091b:	68 a8 24 80 00       	push   $0x8024a8
  800920:	e8 73 01 00 00       	call   800a98 <_panic>

		if (sys_calculate_modified_frames() != 0) {sys_destroy_env(envIdSlave);panic("Modified frames not removed from list (or isModified/modified bit is not updated) correctly when the modified list reaches MAX");}
  800925:	e8 b1 12 00 00       	call   801bdb <sys_calculate_modified_frames>
  80092a:	85 c0                	test   %eax,%eax
  80092c:	74 25                	je     800953 <_main+0x91b>
  80092e:	83 ec 0c             	sub    $0xc,%esp
  800931:	ff 75 b0             	pushl  -0x50(%ebp)
  800934:	e8 35 15 00 00       	call   801e6e <sys_destroy_env>
  800939:	83 c4 10             	add    $0x10,%esp
  80093c:	83 ec 04             	sub    $0x4,%esp
  80093f:	68 c4 27 80 00       	push   $0x8027c4
  800944:	68 e2 00 00 00       	push   $0xe2
  800949:	68 a8 24 80 00       	push   $0x8024a8
  80094e:	e8 45 01 00 00       	call   800a98 <_panic>
	}

	return;
  800953:	90                   	nop
}
  800954:	8d 65 f4             	lea    -0xc(%ebp),%esp
  800957:	5b                   	pop    %ebx
  800958:	5e                   	pop    %esi
  800959:	5f                   	pop    %edi
  80095a:	5d                   	pop    %ebp
  80095b:	c3                   	ret    

0080095c <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  80095c:	55                   	push   %ebp
  80095d:	89 e5                	mov    %esp,%ebp
  80095f:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  800962:	e8 3b 15 00 00       	call   801ea2 <sys_getenvindex>
  800967:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  80096a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80096d:	89 d0                	mov    %edx,%eax
  80096f:	c1 e0 03             	shl    $0x3,%eax
  800972:	01 d0                	add    %edx,%eax
  800974:	01 c0                	add    %eax,%eax
  800976:	01 d0                	add    %edx,%eax
  800978:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80097f:	01 d0                	add    %edx,%eax
  800981:	c1 e0 04             	shl    $0x4,%eax
  800984:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  800989:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  80098e:	a1 20 30 80 00       	mov    0x803020,%eax
  800993:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800999:	84 c0                	test   %al,%al
  80099b:	74 0f                	je     8009ac <libmain+0x50>
		binaryname = myEnv->prog_name;
  80099d:	a1 20 30 80 00       	mov    0x803020,%eax
  8009a2:	05 5c 05 00 00       	add    $0x55c,%eax
  8009a7:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8009ac:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8009b0:	7e 0a                	jle    8009bc <libmain+0x60>
		binaryname = argv[0];
  8009b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009b5:	8b 00                	mov    (%eax),%eax
  8009b7:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8009bc:	83 ec 08             	sub    $0x8,%esp
  8009bf:	ff 75 0c             	pushl  0xc(%ebp)
  8009c2:	ff 75 08             	pushl  0x8(%ebp)
  8009c5:	e8 6e f6 ff ff       	call   800038 <_main>
  8009ca:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8009cd:	e8 dd 12 00 00       	call   801caf <sys_disable_interrupt>
	cprintf("**************************************\n");
  8009d2:	83 ec 0c             	sub    $0xc,%esp
  8009d5:	68 68 28 80 00       	push   $0x802868
  8009da:	e8 6d 03 00 00       	call   800d4c <cprintf>
  8009df:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8009e2:	a1 20 30 80 00       	mov    0x803020,%eax
  8009e7:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  8009ed:	a1 20 30 80 00       	mov    0x803020,%eax
  8009f2:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  8009f8:	83 ec 04             	sub    $0x4,%esp
  8009fb:	52                   	push   %edx
  8009fc:	50                   	push   %eax
  8009fd:	68 90 28 80 00       	push   $0x802890
  800a02:	e8 45 03 00 00       	call   800d4c <cprintf>
  800a07:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800a0a:	a1 20 30 80 00       	mov    0x803020,%eax
  800a0f:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800a15:	a1 20 30 80 00       	mov    0x803020,%eax
  800a1a:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800a20:	a1 20 30 80 00       	mov    0x803020,%eax
  800a25:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800a2b:	51                   	push   %ecx
  800a2c:	52                   	push   %edx
  800a2d:	50                   	push   %eax
  800a2e:	68 b8 28 80 00       	push   $0x8028b8
  800a33:	e8 14 03 00 00       	call   800d4c <cprintf>
  800a38:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800a3b:	a1 20 30 80 00       	mov    0x803020,%eax
  800a40:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800a46:	83 ec 08             	sub    $0x8,%esp
  800a49:	50                   	push   %eax
  800a4a:	68 10 29 80 00       	push   $0x802910
  800a4f:	e8 f8 02 00 00       	call   800d4c <cprintf>
  800a54:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800a57:	83 ec 0c             	sub    $0xc,%esp
  800a5a:	68 68 28 80 00       	push   $0x802868
  800a5f:	e8 e8 02 00 00       	call   800d4c <cprintf>
  800a64:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800a67:	e8 5d 12 00 00       	call   801cc9 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800a6c:	e8 19 00 00 00       	call   800a8a <exit>
}
  800a71:	90                   	nop
  800a72:	c9                   	leave  
  800a73:	c3                   	ret    

00800a74 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  800a74:	55                   	push   %ebp
  800a75:	89 e5                	mov    %esp,%ebp
  800a77:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800a7a:	83 ec 0c             	sub    $0xc,%esp
  800a7d:	6a 00                	push   $0x0
  800a7f:	e8 ea 13 00 00       	call   801e6e <sys_destroy_env>
  800a84:	83 c4 10             	add    $0x10,%esp
}
  800a87:	90                   	nop
  800a88:	c9                   	leave  
  800a89:	c3                   	ret    

00800a8a <exit>:

void
exit(void)
{
  800a8a:	55                   	push   %ebp
  800a8b:	89 e5                	mov    %esp,%ebp
  800a8d:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800a90:	e8 3f 14 00 00       	call   801ed4 <sys_exit_env>
}
  800a95:	90                   	nop
  800a96:	c9                   	leave  
  800a97:	c3                   	ret    

00800a98 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800a98:	55                   	push   %ebp
  800a99:	89 e5                	mov    %esp,%ebp
  800a9b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800a9e:	8d 45 10             	lea    0x10(%ebp),%eax
  800aa1:	83 c0 04             	add    $0x4,%eax
  800aa4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800aa7:	a1 5c 41 00 04       	mov    0x400415c,%eax
  800aac:	85 c0                	test   %eax,%eax
  800aae:	74 16                	je     800ac6 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800ab0:	a1 5c 41 00 04       	mov    0x400415c,%eax
  800ab5:	83 ec 08             	sub    $0x8,%esp
  800ab8:	50                   	push   %eax
  800ab9:	68 24 29 80 00       	push   $0x802924
  800abe:	e8 89 02 00 00       	call   800d4c <cprintf>
  800ac3:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800ac6:	a1 00 30 80 00       	mov    0x803000,%eax
  800acb:	ff 75 0c             	pushl  0xc(%ebp)
  800ace:	ff 75 08             	pushl  0x8(%ebp)
  800ad1:	50                   	push   %eax
  800ad2:	68 29 29 80 00       	push   $0x802929
  800ad7:	e8 70 02 00 00       	call   800d4c <cprintf>
  800adc:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800adf:	8b 45 10             	mov    0x10(%ebp),%eax
  800ae2:	83 ec 08             	sub    $0x8,%esp
  800ae5:	ff 75 f4             	pushl  -0xc(%ebp)
  800ae8:	50                   	push   %eax
  800ae9:	e8 f3 01 00 00       	call   800ce1 <vcprintf>
  800aee:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800af1:	83 ec 08             	sub    $0x8,%esp
  800af4:	6a 00                	push   $0x0
  800af6:	68 45 29 80 00       	push   $0x802945
  800afb:	e8 e1 01 00 00       	call   800ce1 <vcprintf>
  800b00:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800b03:	e8 82 ff ff ff       	call   800a8a <exit>

	// should not return here
	while (1) ;
  800b08:	eb fe                	jmp    800b08 <_panic+0x70>

00800b0a <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800b0a:	55                   	push   %ebp
  800b0b:	89 e5                	mov    %esp,%ebp
  800b0d:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800b10:	a1 20 30 80 00       	mov    0x803020,%eax
  800b15:	8b 50 74             	mov    0x74(%eax),%edx
  800b18:	8b 45 0c             	mov    0xc(%ebp),%eax
  800b1b:	39 c2                	cmp    %eax,%edx
  800b1d:	74 14                	je     800b33 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800b1f:	83 ec 04             	sub    $0x4,%esp
  800b22:	68 48 29 80 00       	push   $0x802948
  800b27:	6a 26                	push   $0x26
  800b29:	68 94 29 80 00       	push   $0x802994
  800b2e:	e8 65 ff ff ff       	call   800a98 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800b33:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800b3a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800b41:	e9 c2 00 00 00       	jmp    800c08 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800b46:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b49:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800b50:	8b 45 08             	mov    0x8(%ebp),%eax
  800b53:	01 d0                	add    %edx,%eax
  800b55:	8b 00                	mov    (%eax),%eax
  800b57:	85 c0                	test   %eax,%eax
  800b59:	75 08                	jne    800b63 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800b5b:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800b5e:	e9 a2 00 00 00       	jmp    800c05 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  800b63:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800b6a:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800b71:	eb 69                	jmp    800bdc <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  800b73:	a1 20 30 80 00       	mov    0x803020,%eax
  800b78:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800b7e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800b81:	89 d0                	mov    %edx,%eax
  800b83:	01 c0                	add    %eax,%eax
  800b85:	01 d0                	add    %edx,%eax
  800b87:	c1 e0 03             	shl    $0x3,%eax
  800b8a:	01 c8                	add    %ecx,%eax
  800b8c:	8a 40 04             	mov    0x4(%eax),%al
  800b8f:	84 c0                	test   %al,%al
  800b91:	75 46                	jne    800bd9 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800b93:	a1 20 30 80 00       	mov    0x803020,%eax
  800b98:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800b9e:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800ba1:	89 d0                	mov    %edx,%eax
  800ba3:	01 c0                	add    %eax,%eax
  800ba5:	01 d0                	add    %edx,%eax
  800ba7:	c1 e0 03             	shl    $0x3,%eax
  800baa:	01 c8                	add    %ecx,%eax
  800bac:	8b 00                	mov    (%eax),%eax
  800bae:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800bb1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800bb4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800bb9:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800bbb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bbe:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800bc5:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc8:	01 c8                	add    %ecx,%eax
  800bca:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800bcc:	39 c2                	cmp    %eax,%edx
  800bce:	75 09                	jne    800bd9 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800bd0:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800bd7:	eb 12                	jmp    800beb <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800bd9:	ff 45 e8             	incl   -0x18(%ebp)
  800bdc:	a1 20 30 80 00       	mov    0x803020,%eax
  800be1:	8b 50 74             	mov    0x74(%eax),%edx
  800be4:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800be7:	39 c2                	cmp    %eax,%edx
  800be9:	77 88                	ja     800b73 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800beb:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800bef:	75 14                	jne    800c05 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800bf1:	83 ec 04             	sub    $0x4,%esp
  800bf4:	68 a0 29 80 00       	push   $0x8029a0
  800bf9:	6a 3a                	push   $0x3a
  800bfb:	68 94 29 80 00       	push   $0x802994
  800c00:	e8 93 fe ff ff       	call   800a98 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800c05:	ff 45 f0             	incl   -0x10(%ebp)
  800c08:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c0b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800c0e:	0f 8c 32 ff ff ff    	jl     800b46 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800c14:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800c1b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800c22:	eb 26                	jmp    800c4a <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800c24:	a1 20 30 80 00       	mov    0x803020,%eax
  800c29:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800c2f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c32:	89 d0                	mov    %edx,%eax
  800c34:	01 c0                	add    %eax,%eax
  800c36:	01 d0                	add    %edx,%eax
  800c38:	c1 e0 03             	shl    $0x3,%eax
  800c3b:	01 c8                	add    %ecx,%eax
  800c3d:	8a 40 04             	mov    0x4(%eax),%al
  800c40:	3c 01                	cmp    $0x1,%al
  800c42:	75 03                	jne    800c47 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800c44:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800c47:	ff 45 e0             	incl   -0x20(%ebp)
  800c4a:	a1 20 30 80 00       	mov    0x803020,%eax
  800c4f:	8b 50 74             	mov    0x74(%eax),%edx
  800c52:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c55:	39 c2                	cmp    %eax,%edx
  800c57:	77 cb                	ja     800c24 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800c59:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800c5c:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  800c5f:	74 14                	je     800c75 <CheckWSWithoutLastIndex+0x16b>
		panic(
  800c61:	83 ec 04             	sub    $0x4,%esp
  800c64:	68 f4 29 80 00       	push   $0x8029f4
  800c69:	6a 44                	push   $0x44
  800c6b:	68 94 29 80 00       	push   $0x802994
  800c70:	e8 23 fe ff ff       	call   800a98 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800c75:	90                   	nop
  800c76:	c9                   	leave  
  800c77:	c3                   	ret    

00800c78 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800c78:	55                   	push   %ebp
  800c79:	89 e5                	mov    %esp,%ebp
  800c7b:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800c7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c81:	8b 00                	mov    (%eax),%eax
  800c83:	8d 48 01             	lea    0x1(%eax),%ecx
  800c86:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c89:	89 0a                	mov    %ecx,(%edx)
  800c8b:	8b 55 08             	mov    0x8(%ebp),%edx
  800c8e:	88 d1                	mov    %dl,%cl
  800c90:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c93:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800c97:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c9a:	8b 00                	mov    (%eax),%eax
  800c9c:	3d ff 00 00 00       	cmp    $0xff,%eax
  800ca1:	75 2c                	jne    800ccf <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800ca3:	a0 24 30 80 00       	mov    0x803024,%al
  800ca8:	0f b6 c0             	movzbl %al,%eax
  800cab:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cae:	8b 12                	mov    (%edx),%edx
  800cb0:	89 d1                	mov    %edx,%ecx
  800cb2:	8b 55 0c             	mov    0xc(%ebp),%edx
  800cb5:	83 c2 08             	add    $0x8,%edx
  800cb8:	83 ec 04             	sub    $0x4,%esp
  800cbb:	50                   	push   %eax
  800cbc:	51                   	push   %ecx
  800cbd:	52                   	push   %edx
  800cbe:	e8 3e 0e 00 00       	call   801b01 <sys_cputs>
  800cc3:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800cc6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cc9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800ccf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cd2:	8b 40 04             	mov    0x4(%eax),%eax
  800cd5:	8d 50 01             	lea    0x1(%eax),%edx
  800cd8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cdb:	89 50 04             	mov    %edx,0x4(%eax)
}
  800cde:	90                   	nop
  800cdf:	c9                   	leave  
  800ce0:	c3                   	ret    

00800ce1 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800ce1:	55                   	push   %ebp
  800ce2:	89 e5                	mov    %esp,%ebp
  800ce4:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800cea:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800cf1:	00 00 00 
	b.cnt = 0;
  800cf4:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800cfb:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800cfe:	ff 75 0c             	pushl  0xc(%ebp)
  800d01:	ff 75 08             	pushl  0x8(%ebp)
  800d04:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800d0a:	50                   	push   %eax
  800d0b:	68 78 0c 80 00       	push   $0x800c78
  800d10:	e8 11 02 00 00       	call   800f26 <vprintfmt>
  800d15:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800d18:	a0 24 30 80 00       	mov    0x803024,%al
  800d1d:	0f b6 c0             	movzbl %al,%eax
  800d20:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800d26:	83 ec 04             	sub    $0x4,%esp
  800d29:	50                   	push   %eax
  800d2a:	52                   	push   %edx
  800d2b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800d31:	83 c0 08             	add    $0x8,%eax
  800d34:	50                   	push   %eax
  800d35:	e8 c7 0d 00 00       	call   801b01 <sys_cputs>
  800d3a:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800d3d:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  800d44:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800d4a:	c9                   	leave  
  800d4b:	c3                   	ret    

00800d4c <cprintf>:

int cprintf(const char *fmt, ...) {
  800d4c:	55                   	push   %ebp
  800d4d:	89 e5                	mov    %esp,%ebp
  800d4f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  800d52:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  800d59:	8d 45 0c             	lea    0xc(%ebp),%eax
  800d5c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800d5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d62:	83 ec 08             	sub    $0x8,%esp
  800d65:	ff 75 f4             	pushl  -0xc(%ebp)
  800d68:	50                   	push   %eax
  800d69:	e8 73 ff ff ff       	call   800ce1 <vcprintf>
  800d6e:	83 c4 10             	add    $0x10,%esp
  800d71:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  800d74:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d77:	c9                   	leave  
  800d78:	c3                   	ret    

00800d79 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800d79:	55                   	push   %ebp
  800d7a:	89 e5                	mov    %esp,%ebp
  800d7c:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800d7f:	e8 2b 0f 00 00       	call   801caf <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  800d84:	8d 45 0c             	lea    0xc(%ebp),%eax
  800d87:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800d8a:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8d:	83 ec 08             	sub    $0x8,%esp
  800d90:	ff 75 f4             	pushl  -0xc(%ebp)
  800d93:	50                   	push   %eax
  800d94:	e8 48 ff ff ff       	call   800ce1 <vcprintf>
  800d99:	83 c4 10             	add    $0x10,%esp
  800d9c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800d9f:	e8 25 0f 00 00       	call   801cc9 <sys_enable_interrupt>
	return cnt;
  800da4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800da7:	c9                   	leave  
  800da8:	c3                   	ret    

00800da9 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800da9:	55                   	push   %ebp
  800daa:	89 e5                	mov    %esp,%ebp
  800dac:	53                   	push   %ebx
  800dad:	83 ec 14             	sub    $0x14,%esp
  800db0:	8b 45 10             	mov    0x10(%ebp),%eax
  800db3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800db6:	8b 45 14             	mov    0x14(%ebp),%eax
  800db9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800dbc:	8b 45 18             	mov    0x18(%ebp),%eax
  800dbf:	ba 00 00 00 00       	mov    $0x0,%edx
  800dc4:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800dc7:	77 55                	ja     800e1e <printnum+0x75>
  800dc9:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800dcc:	72 05                	jb     800dd3 <printnum+0x2a>
  800dce:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800dd1:	77 4b                	ja     800e1e <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800dd3:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800dd6:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800dd9:	8b 45 18             	mov    0x18(%ebp),%eax
  800ddc:	ba 00 00 00 00       	mov    $0x0,%edx
  800de1:	52                   	push   %edx
  800de2:	50                   	push   %eax
  800de3:	ff 75 f4             	pushl  -0xc(%ebp)
  800de6:	ff 75 f0             	pushl  -0x10(%ebp)
  800de9:	e8 fa 13 00 00       	call   8021e8 <__udivdi3>
  800dee:	83 c4 10             	add    $0x10,%esp
  800df1:	83 ec 04             	sub    $0x4,%esp
  800df4:	ff 75 20             	pushl  0x20(%ebp)
  800df7:	53                   	push   %ebx
  800df8:	ff 75 18             	pushl  0x18(%ebp)
  800dfb:	52                   	push   %edx
  800dfc:	50                   	push   %eax
  800dfd:	ff 75 0c             	pushl  0xc(%ebp)
  800e00:	ff 75 08             	pushl  0x8(%ebp)
  800e03:	e8 a1 ff ff ff       	call   800da9 <printnum>
  800e08:	83 c4 20             	add    $0x20,%esp
  800e0b:	eb 1a                	jmp    800e27 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800e0d:	83 ec 08             	sub    $0x8,%esp
  800e10:	ff 75 0c             	pushl  0xc(%ebp)
  800e13:	ff 75 20             	pushl  0x20(%ebp)
  800e16:	8b 45 08             	mov    0x8(%ebp),%eax
  800e19:	ff d0                	call   *%eax
  800e1b:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800e1e:	ff 4d 1c             	decl   0x1c(%ebp)
  800e21:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800e25:	7f e6                	jg     800e0d <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800e27:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800e2a:	bb 00 00 00 00       	mov    $0x0,%ebx
  800e2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e32:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e35:	53                   	push   %ebx
  800e36:	51                   	push   %ecx
  800e37:	52                   	push   %edx
  800e38:	50                   	push   %eax
  800e39:	e8 ba 14 00 00       	call   8022f8 <__umoddi3>
  800e3e:	83 c4 10             	add    $0x10,%esp
  800e41:	05 54 2c 80 00       	add    $0x802c54,%eax
  800e46:	8a 00                	mov    (%eax),%al
  800e48:	0f be c0             	movsbl %al,%eax
  800e4b:	83 ec 08             	sub    $0x8,%esp
  800e4e:	ff 75 0c             	pushl  0xc(%ebp)
  800e51:	50                   	push   %eax
  800e52:	8b 45 08             	mov    0x8(%ebp),%eax
  800e55:	ff d0                	call   *%eax
  800e57:	83 c4 10             	add    $0x10,%esp
}
  800e5a:	90                   	nop
  800e5b:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800e5e:	c9                   	leave  
  800e5f:	c3                   	ret    

00800e60 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800e60:	55                   	push   %ebp
  800e61:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800e63:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800e67:	7e 1c                	jle    800e85 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800e69:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6c:	8b 00                	mov    (%eax),%eax
  800e6e:	8d 50 08             	lea    0x8(%eax),%edx
  800e71:	8b 45 08             	mov    0x8(%ebp),%eax
  800e74:	89 10                	mov    %edx,(%eax)
  800e76:	8b 45 08             	mov    0x8(%ebp),%eax
  800e79:	8b 00                	mov    (%eax),%eax
  800e7b:	83 e8 08             	sub    $0x8,%eax
  800e7e:	8b 50 04             	mov    0x4(%eax),%edx
  800e81:	8b 00                	mov    (%eax),%eax
  800e83:	eb 40                	jmp    800ec5 <getuint+0x65>
	else if (lflag)
  800e85:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e89:	74 1e                	je     800ea9 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800e8b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8e:	8b 00                	mov    (%eax),%eax
  800e90:	8d 50 04             	lea    0x4(%eax),%edx
  800e93:	8b 45 08             	mov    0x8(%ebp),%eax
  800e96:	89 10                	mov    %edx,(%eax)
  800e98:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9b:	8b 00                	mov    (%eax),%eax
  800e9d:	83 e8 04             	sub    $0x4,%eax
  800ea0:	8b 00                	mov    (%eax),%eax
  800ea2:	ba 00 00 00 00       	mov    $0x0,%edx
  800ea7:	eb 1c                	jmp    800ec5 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800ea9:	8b 45 08             	mov    0x8(%ebp),%eax
  800eac:	8b 00                	mov    (%eax),%eax
  800eae:	8d 50 04             	lea    0x4(%eax),%edx
  800eb1:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb4:	89 10                	mov    %edx,(%eax)
  800eb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb9:	8b 00                	mov    (%eax),%eax
  800ebb:	83 e8 04             	sub    $0x4,%eax
  800ebe:	8b 00                	mov    (%eax),%eax
  800ec0:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800ec5:	5d                   	pop    %ebp
  800ec6:	c3                   	ret    

00800ec7 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800ec7:	55                   	push   %ebp
  800ec8:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800eca:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800ece:	7e 1c                	jle    800eec <getint+0x25>
		return va_arg(*ap, long long);
  800ed0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed3:	8b 00                	mov    (%eax),%eax
  800ed5:	8d 50 08             	lea    0x8(%eax),%edx
  800ed8:	8b 45 08             	mov    0x8(%ebp),%eax
  800edb:	89 10                	mov    %edx,(%eax)
  800edd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee0:	8b 00                	mov    (%eax),%eax
  800ee2:	83 e8 08             	sub    $0x8,%eax
  800ee5:	8b 50 04             	mov    0x4(%eax),%edx
  800ee8:	8b 00                	mov    (%eax),%eax
  800eea:	eb 38                	jmp    800f24 <getint+0x5d>
	else if (lflag)
  800eec:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ef0:	74 1a                	je     800f0c <getint+0x45>
		return va_arg(*ap, long);
  800ef2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef5:	8b 00                	mov    (%eax),%eax
  800ef7:	8d 50 04             	lea    0x4(%eax),%edx
  800efa:	8b 45 08             	mov    0x8(%ebp),%eax
  800efd:	89 10                	mov    %edx,(%eax)
  800eff:	8b 45 08             	mov    0x8(%ebp),%eax
  800f02:	8b 00                	mov    (%eax),%eax
  800f04:	83 e8 04             	sub    $0x4,%eax
  800f07:	8b 00                	mov    (%eax),%eax
  800f09:	99                   	cltd   
  800f0a:	eb 18                	jmp    800f24 <getint+0x5d>
	else
		return va_arg(*ap, int);
  800f0c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0f:	8b 00                	mov    (%eax),%eax
  800f11:	8d 50 04             	lea    0x4(%eax),%edx
  800f14:	8b 45 08             	mov    0x8(%ebp),%eax
  800f17:	89 10                	mov    %edx,(%eax)
  800f19:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1c:	8b 00                	mov    (%eax),%eax
  800f1e:	83 e8 04             	sub    $0x4,%eax
  800f21:	8b 00                	mov    (%eax),%eax
  800f23:	99                   	cltd   
}
  800f24:	5d                   	pop    %ebp
  800f25:	c3                   	ret    

00800f26 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800f26:	55                   	push   %ebp
  800f27:	89 e5                	mov    %esp,%ebp
  800f29:	56                   	push   %esi
  800f2a:	53                   	push   %ebx
  800f2b:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800f2e:	eb 17                	jmp    800f47 <vprintfmt+0x21>
			if (ch == '\0')
  800f30:	85 db                	test   %ebx,%ebx
  800f32:	0f 84 af 03 00 00    	je     8012e7 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800f38:	83 ec 08             	sub    $0x8,%esp
  800f3b:	ff 75 0c             	pushl  0xc(%ebp)
  800f3e:	53                   	push   %ebx
  800f3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f42:	ff d0                	call   *%eax
  800f44:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800f47:	8b 45 10             	mov    0x10(%ebp),%eax
  800f4a:	8d 50 01             	lea    0x1(%eax),%edx
  800f4d:	89 55 10             	mov    %edx,0x10(%ebp)
  800f50:	8a 00                	mov    (%eax),%al
  800f52:	0f b6 d8             	movzbl %al,%ebx
  800f55:	83 fb 25             	cmp    $0x25,%ebx
  800f58:	75 d6                	jne    800f30 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800f5a:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800f5e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800f65:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800f6c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800f73:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800f7a:	8b 45 10             	mov    0x10(%ebp),%eax
  800f7d:	8d 50 01             	lea    0x1(%eax),%edx
  800f80:	89 55 10             	mov    %edx,0x10(%ebp)
  800f83:	8a 00                	mov    (%eax),%al
  800f85:	0f b6 d8             	movzbl %al,%ebx
  800f88:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800f8b:	83 f8 55             	cmp    $0x55,%eax
  800f8e:	0f 87 2b 03 00 00    	ja     8012bf <vprintfmt+0x399>
  800f94:	8b 04 85 78 2c 80 00 	mov    0x802c78(,%eax,4),%eax
  800f9b:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800f9d:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800fa1:	eb d7                	jmp    800f7a <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800fa3:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800fa7:	eb d1                	jmp    800f7a <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800fa9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800fb0:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800fb3:	89 d0                	mov    %edx,%eax
  800fb5:	c1 e0 02             	shl    $0x2,%eax
  800fb8:	01 d0                	add    %edx,%eax
  800fba:	01 c0                	add    %eax,%eax
  800fbc:	01 d8                	add    %ebx,%eax
  800fbe:	83 e8 30             	sub    $0x30,%eax
  800fc1:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800fc4:	8b 45 10             	mov    0x10(%ebp),%eax
  800fc7:	8a 00                	mov    (%eax),%al
  800fc9:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800fcc:	83 fb 2f             	cmp    $0x2f,%ebx
  800fcf:	7e 3e                	jle    80100f <vprintfmt+0xe9>
  800fd1:	83 fb 39             	cmp    $0x39,%ebx
  800fd4:	7f 39                	jg     80100f <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800fd6:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800fd9:	eb d5                	jmp    800fb0 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800fdb:	8b 45 14             	mov    0x14(%ebp),%eax
  800fde:	83 c0 04             	add    $0x4,%eax
  800fe1:	89 45 14             	mov    %eax,0x14(%ebp)
  800fe4:	8b 45 14             	mov    0x14(%ebp),%eax
  800fe7:	83 e8 04             	sub    $0x4,%eax
  800fea:	8b 00                	mov    (%eax),%eax
  800fec:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800fef:	eb 1f                	jmp    801010 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800ff1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ff5:	79 83                	jns    800f7a <vprintfmt+0x54>
				width = 0;
  800ff7:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800ffe:	e9 77 ff ff ff       	jmp    800f7a <vprintfmt+0x54>

		case '#':
			altflag = 1;
  801003:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80100a:	e9 6b ff ff ff       	jmp    800f7a <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  80100f:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  801010:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801014:	0f 89 60 ff ff ff    	jns    800f7a <vprintfmt+0x54>
				width = precision, precision = -1;
  80101a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80101d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801020:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  801027:	e9 4e ff ff ff       	jmp    800f7a <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80102c:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  80102f:	e9 46 ff ff ff       	jmp    800f7a <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  801034:	8b 45 14             	mov    0x14(%ebp),%eax
  801037:	83 c0 04             	add    $0x4,%eax
  80103a:	89 45 14             	mov    %eax,0x14(%ebp)
  80103d:	8b 45 14             	mov    0x14(%ebp),%eax
  801040:	83 e8 04             	sub    $0x4,%eax
  801043:	8b 00                	mov    (%eax),%eax
  801045:	83 ec 08             	sub    $0x8,%esp
  801048:	ff 75 0c             	pushl  0xc(%ebp)
  80104b:	50                   	push   %eax
  80104c:	8b 45 08             	mov    0x8(%ebp),%eax
  80104f:	ff d0                	call   *%eax
  801051:	83 c4 10             	add    $0x10,%esp
			break;
  801054:	e9 89 02 00 00       	jmp    8012e2 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  801059:	8b 45 14             	mov    0x14(%ebp),%eax
  80105c:	83 c0 04             	add    $0x4,%eax
  80105f:	89 45 14             	mov    %eax,0x14(%ebp)
  801062:	8b 45 14             	mov    0x14(%ebp),%eax
  801065:	83 e8 04             	sub    $0x4,%eax
  801068:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  80106a:	85 db                	test   %ebx,%ebx
  80106c:	79 02                	jns    801070 <vprintfmt+0x14a>
				err = -err;
  80106e:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  801070:	83 fb 64             	cmp    $0x64,%ebx
  801073:	7f 0b                	jg     801080 <vprintfmt+0x15a>
  801075:	8b 34 9d c0 2a 80 00 	mov    0x802ac0(,%ebx,4),%esi
  80107c:	85 f6                	test   %esi,%esi
  80107e:	75 19                	jne    801099 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  801080:	53                   	push   %ebx
  801081:	68 65 2c 80 00       	push   $0x802c65
  801086:	ff 75 0c             	pushl  0xc(%ebp)
  801089:	ff 75 08             	pushl  0x8(%ebp)
  80108c:	e8 5e 02 00 00       	call   8012ef <printfmt>
  801091:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  801094:	e9 49 02 00 00       	jmp    8012e2 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  801099:	56                   	push   %esi
  80109a:	68 6e 2c 80 00       	push   $0x802c6e
  80109f:	ff 75 0c             	pushl  0xc(%ebp)
  8010a2:	ff 75 08             	pushl  0x8(%ebp)
  8010a5:	e8 45 02 00 00       	call   8012ef <printfmt>
  8010aa:	83 c4 10             	add    $0x10,%esp
			break;
  8010ad:	e9 30 02 00 00       	jmp    8012e2 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  8010b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8010b5:	83 c0 04             	add    $0x4,%eax
  8010b8:	89 45 14             	mov    %eax,0x14(%ebp)
  8010bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8010be:	83 e8 04             	sub    $0x4,%eax
  8010c1:	8b 30                	mov    (%eax),%esi
  8010c3:	85 f6                	test   %esi,%esi
  8010c5:	75 05                	jne    8010cc <vprintfmt+0x1a6>
				p = "(null)";
  8010c7:	be 71 2c 80 00       	mov    $0x802c71,%esi
			if (width > 0 && padc != '-')
  8010cc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8010d0:	7e 6d                	jle    80113f <vprintfmt+0x219>
  8010d2:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8010d6:	74 67                	je     80113f <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  8010d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8010db:	83 ec 08             	sub    $0x8,%esp
  8010de:	50                   	push   %eax
  8010df:	56                   	push   %esi
  8010e0:	e8 0c 03 00 00       	call   8013f1 <strnlen>
  8010e5:	83 c4 10             	add    $0x10,%esp
  8010e8:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  8010eb:	eb 16                	jmp    801103 <vprintfmt+0x1dd>
					putch(padc, putdat);
  8010ed:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8010f1:	83 ec 08             	sub    $0x8,%esp
  8010f4:	ff 75 0c             	pushl  0xc(%ebp)
  8010f7:	50                   	push   %eax
  8010f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fb:	ff d0                	call   *%eax
  8010fd:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  801100:	ff 4d e4             	decl   -0x1c(%ebp)
  801103:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801107:	7f e4                	jg     8010ed <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  801109:	eb 34                	jmp    80113f <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  80110b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  80110f:	74 1c                	je     80112d <vprintfmt+0x207>
  801111:	83 fb 1f             	cmp    $0x1f,%ebx
  801114:	7e 05                	jle    80111b <vprintfmt+0x1f5>
  801116:	83 fb 7e             	cmp    $0x7e,%ebx
  801119:	7e 12                	jle    80112d <vprintfmt+0x207>
					putch('?', putdat);
  80111b:	83 ec 08             	sub    $0x8,%esp
  80111e:	ff 75 0c             	pushl  0xc(%ebp)
  801121:	6a 3f                	push   $0x3f
  801123:	8b 45 08             	mov    0x8(%ebp),%eax
  801126:	ff d0                	call   *%eax
  801128:	83 c4 10             	add    $0x10,%esp
  80112b:	eb 0f                	jmp    80113c <vprintfmt+0x216>
				else
					putch(ch, putdat);
  80112d:	83 ec 08             	sub    $0x8,%esp
  801130:	ff 75 0c             	pushl  0xc(%ebp)
  801133:	53                   	push   %ebx
  801134:	8b 45 08             	mov    0x8(%ebp),%eax
  801137:	ff d0                	call   *%eax
  801139:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  80113c:	ff 4d e4             	decl   -0x1c(%ebp)
  80113f:	89 f0                	mov    %esi,%eax
  801141:	8d 70 01             	lea    0x1(%eax),%esi
  801144:	8a 00                	mov    (%eax),%al
  801146:	0f be d8             	movsbl %al,%ebx
  801149:	85 db                	test   %ebx,%ebx
  80114b:	74 24                	je     801171 <vprintfmt+0x24b>
  80114d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  801151:	78 b8                	js     80110b <vprintfmt+0x1e5>
  801153:	ff 4d e0             	decl   -0x20(%ebp)
  801156:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  80115a:	79 af                	jns    80110b <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80115c:	eb 13                	jmp    801171 <vprintfmt+0x24b>
				putch(' ', putdat);
  80115e:	83 ec 08             	sub    $0x8,%esp
  801161:	ff 75 0c             	pushl  0xc(%ebp)
  801164:	6a 20                	push   $0x20
  801166:	8b 45 08             	mov    0x8(%ebp),%eax
  801169:	ff d0                	call   *%eax
  80116b:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  80116e:	ff 4d e4             	decl   -0x1c(%ebp)
  801171:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  801175:	7f e7                	jg     80115e <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  801177:	e9 66 01 00 00       	jmp    8012e2 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  80117c:	83 ec 08             	sub    $0x8,%esp
  80117f:	ff 75 e8             	pushl  -0x18(%ebp)
  801182:	8d 45 14             	lea    0x14(%ebp),%eax
  801185:	50                   	push   %eax
  801186:	e8 3c fd ff ff       	call   800ec7 <getint>
  80118b:	83 c4 10             	add    $0x10,%esp
  80118e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801191:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  801194:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801197:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80119a:	85 d2                	test   %edx,%edx
  80119c:	79 23                	jns    8011c1 <vprintfmt+0x29b>
				putch('-', putdat);
  80119e:	83 ec 08             	sub    $0x8,%esp
  8011a1:	ff 75 0c             	pushl  0xc(%ebp)
  8011a4:	6a 2d                	push   $0x2d
  8011a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a9:	ff d0                	call   *%eax
  8011ab:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  8011ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011b1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8011b4:	f7 d8                	neg    %eax
  8011b6:	83 d2 00             	adc    $0x0,%edx
  8011b9:	f7 da                	neg    %edx
  8011bb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011be:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  8011c1:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8011c8:	e9 bc 00 00 00       	jmp    801289 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  8011cd:	83 ec 08             	sub    $0x8,%esp
  8011d0:	ff 75 e8             	pushl  -0x18(%ebp)
  8011d3:	8d 45 14             	lea    0x14(%ebp),%eax
  8011d6:	50                   	push   %eax
  8011d7:	e8 84 fc ff ff       	call   800e60 <getuint>
  8011dc:	83 c4 10             	add    $0x10,%esp
  8011df:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8011e2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  8011e5:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  8011ec:	e9 98 00 00 00       	jmp    801289 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  8011f1:	83 ec 08             	sub    $0x8,%esp
  8011f4:	ff 75 0c             	pushl  0xc(%ebp)
  8011f7:	6a 58                	push   $0x58
  8011f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fc:	ff d0                	call   *%eax
  8011fe:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801201:	83 ec 08             	sub    $0x8,%esp
  801204:	ff 75 0c             	pushl  0xc(%ebp)
  801207:	6a 58                	push   $0x58
  801209:	8b 45 08             	mov    0x8(%ebp),%eax
  80120c:	ff d0                	call   *%eax
  80120e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  801211:	83 ec 08             	sub    $0x8,%esp
  801214:	ff 75 0c             	pushl  0xc(%ebp)
  801217:	6a 58                	push   $0x58
  801219:	8b 45 08             	mov    0x8(%ebp),%eax
  80121c:	ff d0                	call   *%eax
  80121e:	83 c4 10             	add    $0x10,%esp
			break;
  801221:	e9 bc 00 00 00       	jmp    8012e2 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  801226:	83 ec 08             	sub    $0x8,%esp
  801229:	ff 75 0c             	pushl  0xc(%ebp)
  80122c:	6a 30                	push   $0x30
  80122e:	8b 45 08             	mov    0x8(%ebp),%eax
  801231:	ff d0                	call   *%eax
  801233:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  801236:	83 ec 08             	sub    $0x8,%esp
  801239:	ff 75 0c             	pushl  0xc(%ebp)
  80123c:	6a 78                	push   $0x78
  80123e:	8b 45 08             	mov    0x8(%ebp),%eax
  801241:	ff d0                	call   *%eax
  801243:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  801246:	8b 45 14             	mov    0x14(%ebp),%eax
  801249:	83 c0 04             	add    $0x4,%eax
  80124c:	89 45 14             	mov    %eax,0x14(%ebp)
  80124f:	8b 45 14             	mov    0x14(%ebp),%eax
  801252:	83 e8 04             	sub    $0x4,%eax
  801255:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  801257:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80125a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  801261:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  801268:	eb 1f                	jmp    801289 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  80126a:	83 ec 08             	sub    $0x8,%esp
  80126d:	ff 75 e8             	pushl  -0x18(%ebp)
  801270:	8d 45 14             	lea    0x14(%ebp),%eax
  801273:	50                   	push   %eax
  801274:	e8 e7 fb ff ff       	call   800e60 <getuint>
  801279:	83 c4 10             	add    $0x10,%esp
  80127c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80127f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  801282:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  801289:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  80128d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801290:	83 ec 04             	sub    $0x4,%esp
  801293:	52                   	push   %edx
  801294:	ff 75 e4             	pushl  -0x1c(%ebp)
  801297:	50                   	push   %eax
  801298:	ff 75 f4             	pushl  -0xc(%ebp)
  80129b:	ff 75 f0             	pushl  -0x10(%ebp)
  80129e:	ff 75 0c             	pushl  0xc(%ebp)
  8012a1:	ff 75 08             	pushl  0x8(%ebp)
  8012a4:	e8 00 fb ff ff       	call   800da9 <printnum>
  8012a9:	83 c4 20             	add    $0x20,%esp
			break;
  8012ac:	eb 34                	jmp    8012e2 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  8012ae:	83 ec 08             	sub    $0x8,%esp
  8012b1:	ff 75 0c             	pushl  0xc(%ebp)
  8012b4:	53                   	push   %ebx
  8012b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8012b8:	ff d0                	call   *%eax
  8012ba:	83 c4 10             	add    $0x10,%esp
			break;
  8012bd:	eb 23                	jmp    8012e2 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  8012bf:	83 ec 08             	sub    $0x8,%esp
  8012c2:	ff 75 0c             	pushl  0xc(%ebp)
  8012c5:	6a 25                	push   $0x25
  8012c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ca:	ff d0                	call   *%eax
  8012cc:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  8012cf:	ff 4d 10             	decl   0x10(%ebp)
  8012d2:	eb 03                	jmp    8012d7 <vprintfmt+0x3b1>
  8012d4:	ff 4d 10             	decl   0x10(%ebp)
  8012d7:	8b 45 10             	mov    0x10(%ebp),%eax
  8012da:	48                   	dec    %eax
  8012db:	8a 00                	mov    (%eax),%al
  8012dd:	3c 25                	cmp    $0x25,%al
  8012df:	75 f3                	jne    8012d4 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  8012e1:	90                   	nop
		}
	}
  8012e2:	e9 47 fc ff ff       	jmp    800f2e <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  8012e7:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  8012e8:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8012eb:	5b                   	pop    %ebx
  8012ec:	5e                   	pop    %esi
  8012ed:	5d                   	pop    %ebp
  8012ee:	c3                   	ret    

008012ef <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  8012ef:	55                   	push   %ebp
  8012f0:	89 e5                	mov    %esp,%ebp
  8012f2:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  8012f5:	8d 45 10             	lea    0x10(%ebp),%eax
  8012f8:	83 c0 04             	add    $0x4,%eax
  8012fb:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  8012fe:	8b 45 10             	mov    0x10(%ebp),%eax
  801301:	ff 75 f4             	pushl  -0xc(%ebp)
  801304:	50                   	push   %eax
  801305:	ff 75 0c             	pushl  0xc(%ebp)
  801308:	ff 75 08             	pushl  0x8(%ebp)
  80130b:	e8 16 fc ff ff       	call   800f26 <vprintfmt>
  801310:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  801313:	90                   	nop
  801314:	c9                   	leave  
  801315:	c3                   	ret    

00801316 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  801316:	55                   	push   %ebp
  801317:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  801319:	8b 45 0c             	mov    0xc(%ebp),%eax
  80131c:	8b 40 08             	mov    0x8(%eax),%eax
  80131f:	8d 50 01             	lea    0x1(%eax),%edx
  801322:	8b 45 0c             	mov    0xc(%ebp),%eax
  801325:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  801328:	8b 45 0c             	mov    0xc(%ebp),%eax
  80132b:	8b 10                	mov    (%eax),%edx
  80132d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801330:	8b 40 04             	mov    0x4(%eax),%eax
  801333:	39 c2                	cmp    %eax,%edx
  801335:	73 12                	jae    801349 <sprintputch+0x33>
		*b->buf++ = ch;
  801337:	8b 45 0c             	mov    0xc(%ebp),%eax
  80133a:	8b 00                	mov    (%eax),%eax
  80133c:	8d 48 01             	lea    0x1(%eax),%ecx
  80133f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801342:	89 0a                	mov    %ecx,(%edx)
  801344:	8b 55 08             	mov    0x8(%ebp),%edx
  801347:	88 10                	mov    %dl,(%eax)
}
  801349:	90                   	nop
  80134a:	5d                   	pop    %ebp
  80134b:	c3                   	ret    

0080134c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  80134c:	55                   	push   %ebp
  80134d:	89 e5                	mov    %esp,%ebp
  80134f:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  801352:	8b 45 08             	mov    0x8(%ebp),%eax
  801355:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801358:	8b 45 0c             	mov    0xc(%ebp),%eax
  80135b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80135e:	8b 45 08             	mov    0x8(%ebp),%eax
  801361:	01 d0                	add    %edx,%eax
  801363:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801366:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  80136d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801371:	74 06                	je     801379 <vsnprintf+0x2d>
  801373:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801377:	7f 07                	jg     801380 <vsnprintf+0x34>
		return -E_INVAL;
  801379:	b8 03 00 00 00       	mov    $0x3,%eax
  80137e:	eb 20                	jmp    8013a0 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  801380:	ff 75 14             	pushl  0x14(%ebp)
  801383:	ff 75 10             	pushl  0x10(%ebp)
  801386:	8d 45 ec             	lea    -0x14(%ebp),%eax
  801389:	50                   	push   %eax
  80138a:	68 16 13 80 00       	push   $0x801316
  80138f:	e8 92 fb ff ff       	call   800f26 <vprintfmt>
  801394:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801397:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80139a:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  80139d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8013a0:	c9                   	leave  
  8013a1:	c3                   	ret    

008013a2 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  8013a2:	55                   	push   %ebp
  8013a3:	89 e5                	mov    %esp,%ebp
  8013a5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  8013a8:	8d 45 10             	lea    0x10(%ebp),%eax
  8013ab:	83 c0 04             	add    $0x4,%eax
  8013ae:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  8013b1:	8b 45 10             	mov    0x10(%ebp),%eax
  8013b4:	ff 75 f4             	pushl  -0xc(%ebp)
  8013b7:	50                   	push   %eax
  8013b8:	ff 75 0c             	pushl  0xc(%ebp)
  8013bb:	ff 75 08             	pushl  0x8(%ebp)
  8013be:	e8 89 ff ff ff       	call   80134c <vsnprintf>
  8013c3:	83 c4 10             	add    $0x10,%esp
  8013c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  8013c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8013cc:	c9                   	leave  
  8013cd:	c3                   	ret    

008013ce <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  8013ce:	55                   	push   %ebp
  8013cf:	89 e5                	mov    %esp,%ebp
  8013d1:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  8013d4:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013db:	eb 06                	jmp    8013e3 <strlen+0x15>
		n++;
  8013dd:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  8013e0:	ff 45 08             	incl   0x8(%ebp)
  8013e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e6:	8a 00                	mov    (%eax),%al
  8013e8:	84 c0                	test   %al,%al
  8013ea:	75 f1                	jne    8013dd <strlen+0xf>
		n++;
	return n;
  8013ec:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8013ef:	c9                   	leave  
  8013f0:	c3                   	ret    

008013f1 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  8013f1:	55                   	push   %ebp
  8013f2:	89 e5                	mov    %esp,%ebp
  8013f4:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  8013f7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013fe:	eb 09                	jmp    801409 <strnlen+0x18>
		n++;
  801400:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801403:	ff 45 08             	incl   0x8(%ebp)
  801406:	ff 4d 0c             	decl   0xc(%ebp)
  801409:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80140d:	74 09                	je     801418 <strnlen+0x27>
  80140f:	8b 45 08             	mov    0x8(%ebp),%eax
  801412:	8a 00                	mov    (%eax),%al
  801414:	84 c0                	test   %al,%al
  801416:	75 e8                	jne    801400 <strnlen+0xf>
		n++;
	return n;
  801418:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80141b:	c9                   	leave  
  80141c:	c3                   	ret    

0080141d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  80141d:	55                   	push   %ebp
  80141e:	89 e5                	mov    %esp,%ebp
  801420:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  801423:	8b 45 08             	mov    0x8(%ebp),%eax
  801426:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801429:	90                   	nop
  80142a:	8b 45 08             	mov    0x8(%ebp),%eax
  80142d:	8d 50 01             	lea    0x1(%eax),%edx
  801430:	89 55 08             	mov    %edx,0x8(%ebp)
  801433:	8b 55 0c             	mov    0xc(%ebp),%edx
  801436:	8d 4a 01             	lea    0x1(%edx),%ecx
  801439:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80143c:	8a 12                	mov    (%edx),%dl
  80143e:	88 10                	mov    %dl,(%eax)
  801440:	8a 00                	mov    (%eax),%al
  801442:	84 c0                	test   %al,%al
  801444:	75 e4                	jne    80142a <strcpy+0xd>
		/* do nothing */;
	return ret;
  801446:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801449:	c9                   	leave  
  80144a:	c3                   	ret    

0080144b <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  80144b:	55                   	push   %ebp
  80144c:	89 e5                	mov    %esp,%ebp
  80144e:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  801451:	8b 45 08             	mov    0x8(%ebp),%eax
  801454:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  801457:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80145e:	eb 1f                	jmp    80147f <strncpy+0x34>
		*dst++ = *src;
  801460:	8b 45 08             	mov    0x8(%ebp),%eax
  801463:	8d 50 01             	lea    0x1(%eax),%edx
  801466:	89 55 08             	mov    %edx,0x8(%ebp)
  801469:	8b 55 0c             	mov    0xc(%ebp),%edx
  80146c:	8a 12                	mov    (%edx),%dl
  80146e:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  801470:	8b 45 0c             	mov    0xc(%ebp),%eax
  801473:	8a 00                	mov    (%eax),%al
  801475:	84 c0                	test   %al,%al
  801477:	74 03                	je     80147c <strncpy+0x31>
			src++;
  801479:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  80147c:	ff 45 fc             	incl   -0x4(%ebp)
  80147f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801482:	3b 45 10             	cmp    0x10(%ebp),%eax
  801485:	72 d9                	jb     801460 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  801487:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80148a:	c9                   	leave  
  80148b:	c3                   	ret    

0080148c <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  80148c:	55                   	push   %ebp
  80148d:	89 e5                	mov    %esp,%ebp
  80148f:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  801492:	8b 45 08             	mov    0x8(%ebp),%eax
  801495:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801498:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80149c:	74 30                	je     8014ce <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  80149e:	eb 16                	jmp    8014b6 <strlcpy+0x2a>
			*dst++ = *src++;
  8014a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a3:	8d 50 01             	lea    0x1(%eax),%edx
  8014a6:	89 55 08             	mov    %edx,0x8(%ebp)
  8014a9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014ac:	8d 4a 01             	lea    0x1(%edx),%ecx
  8014af:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8014b2:	8a 12                	mov    (%edx),%dl
  8014b4:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  8014b6:	ff 4d 10             	decl   0x10(%ebp)
  8014b9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014bd:	74 09                	je     8014c8 <strlcpy+0x3c>
  8014bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014c2:	8a 00                	mov    (%eax),%al
  8014c4:	84 c0                	test   %al,%al
  8014c6:	75 d8                	jne    8014a0 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  8014c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014cb:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  8014ce:	8b 55 08             	mov    0x8(%ebp),%edx
  8014d1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8014d4:	29 c2                	sub    %eax,%edx
  8014d6:	89 d0                	mov    %edx,%eax
}
  8014d8:	c9                   	leave  
  8014d9:	c3                   	ret    

008014da <strcmp>:

int
strcmp(const char *p, const char *q)
{
  8014da:	55                   	push   %ebp
  8014db:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  8014dd:	eb 06                	jmp    8014e5 <strcmp+0xb>
		p++, q++;
  8014df:	ff 45 08             	incl   0x8(%ebp)
  8014e2:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  8014e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e8:	8a 00                	mov    (%eax),%al
  8014ea:	84 c0                	test   %al,%al
  8014ec:	74 0e                	je     8014fc <strcmp+0x22>
  8014ee:	8b 45 08             	mov    0x8(%ebp),%eax
  8014f1:	8a 10                	mov    (%eax),%dl
  8014f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014f6:	8a 00                	mov    (%eax),%al
  8014f8:	38 c2                	cmp    %al,%dl
  8014fa:	74 e3                	je     8014df <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  8014fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ff:	8a 00                	mov    (%eax),%al
  801501:	0f b6 d0             	movzbl %al,%edx
  801504:	8b 45 0c             	mov    0xc(%ebp),%eax
  801507:	8a 00                	mov    (%eax),%al
  801509:	0f b6 c0             	movzbl %al,%eax
  80150c:	29 c2                	sub    %eax,%edx
  80150e:	89 d0                	mov    %edx,%eax
}
  801510:	5d                   	pop    %ebp
  801511:	c3                   	ret    

00801512 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  801512:	55                   	push   %ebp
  801513:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801515:	eb 09                	jmp    801520 <strncmp+0xe>
		n--, p++, q++;
  801517:	ff 4d 10             	decl   0x10(%ebp)
  80151a:	ff 45 08             	incl   0x8(%ebp)
  80151d:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  801520:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801524:	74 17                	je     80153d <strncmp+0x2b>
  801526:	8b 45 08             	mov    0x8(%ebp),%eax
  801529:	8a 00                	mov    (%eax),%al
  80152b:	84 c0                	test   %al,%al
  80152d:	74 0e                	je     80153d <strncmp+0x2b>
  80152f:	8b 45 08             	mov    0x8(%ebp),%eax
  801532:	8a 10                	mov    (%eax),%dl
  801534:	8b 45 0c             	mov    0xc(%ebp),%eax
  801537:	8a 00                	mov    (%eax),%al
  801539:	38 c2                	cmp    %al,%dl
  80153b:	74 da                	je     801517 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  80153d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801541:	75 07                	jne    80154a <strncmp+0x38>
		return 0;
  801543:	b8 00 00 00 00       	mov    $0x0,%eax
  801548:	eb 14                	jmp    80155e <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  80154a:	8b 45 08             	mov    0x8(%ebp),%eax
  80154d:	8a 00                	mov    (%eax),%al
  80154f:	0f b6 d0             	movzbl %al,%edx
  801552:	8b 45 0c             	mov    0xc(%ebp),%eax
  801555:	8a 00                	mov    (%eax),%al
  801557:	0f b6 c0             	movzbl %al,%eax
  80155a:	29 c2                	sub    %eax,%edx
  80155c:	89 d0                	mov    %edx,%eax
}
  80155e:	5d                   	pop    %ebp
  80155f:	c3                   	ret    

00801560 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  801560:	55                   	push   %ebp
  801561:	89 e5                	mov    %esp,%ebp
  801563:	83 ec 04             	sub    $0x4,%esp
  801566:	8b 45 0c             	mov    0xc(%ebp),%eax
  801569:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80156c:	eb 12                	jmp    801580 <strchr+0x20>
		if (*s == c)
  80156e:	8b 45 08             	mov    0x8(%ebp),%eax
  801571:	8a 00                	mov    (%eax),%al
  801573:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801576:	75 05                	jne    80157d <strchr+0x1d>
			return (char *) s;
  801578:	8b 45 08             	mov    0x8(%ebp),%eax
  80157b:	eb 11                	jmp    80158e <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  80157d:	ff 45 08             	incl   0x8(%ebp)
  801580:	8b 45 08             	mov    0x8(%ebp),%eax
  801583:	8a 00                	mov    (%eax),%al
  801585:	84 c0                	test   %al,%al
  801587:	75 e5                	jne    80156e <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  801589:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80158e:	c9                   	leave  
  80158f:	c3                   	ret    

00801590 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801590:	55                   	push   %ebp
  801591:	89 e5                	mov    %esp,%ebp
  801593:	83 ec 04             	sub    $0x4,%esp
  801596:	8b 45 0c             	mov    0xc(%ebp),%eax
  801599:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  80159c:	eb 0d                	jmp    8015ab <strfind+0x1b>
		if (*s == c)
  80159e:	8b 45 08             	mov    0x8(%ebp),%eax
  8015a1:	8a 00                	mov    (%eax),%al
  8015a3:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8015a6:	74 0e                	je     8015b6 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  8015a8:	ff 45 08             	incl   0x8(%ebp)
  8015ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ae:	8a 00                	mov    (%eax),%al
  8015b0:	84 c0                	test   %al,%al
  8015b2:	75 ea                	jne    80159e <strfind+0xe>
  8015b4:	eb 01                	jmp    8015b7 <strfind+0x27>
		if (*s == c)
			break;
  8015b6:	90                   	nop
	return (char *) s;
  8015b7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015ba:	c9                   	leave  
  8015bb:	c3                   	ret    

008015bc <memset>:


void *
memset(void *v, int c, uint32 n)
{
  8015bc:	55                   	push   %ebp
  8015bd:	89 e5                	mov    %esp,%ebp
  8015bf:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  8015c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  8015c8:	8b 45 10             	mov    0x10(%ebp),%eax
  8015cb:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  8015ce:	eb 0e                	jmp    8015de <memset+0x22>
		*p++ = c;
  8015d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8015d3:	8d 50 01             	lea    0x1(%eax),%edx
  8015d6:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8015d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015dc:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  8015de:	ff 4d f8             	decl   -0x8(%ebp)
  8015e1:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  8015e5:	79 e9                	jns    8015d0 <memset+0x14>
		*p++ = c;

	return v;
  8015e7:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8015ea:	c9                   	leave  
  8015eb:	c3                   	ret    

008015ec <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  8015ec:	55                   	push   %ebp
  8015ed:	89 e5                	mov    %esp,%ebp
  8015ef:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8015f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015f5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8015f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fb:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  8015fe:	eb 16                	jmp    801616 <memcpy+0x2a>
		*d++ = *s++;
  801600:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801603:	8d 50 01             	lea    0x1(%eax),%edx
  801606:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801609:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80160c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80160f:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801612:	8a 12                	mov    (%edx),%dl
  801614:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801616:	8b 45 10             	mov    0x10(%ebp),%eax
  801619:	8d 50 ff             	lea    -0x1(%eax),%edx
  80161c:	89 55 10             	mov    %edx,0x10(%ebp)
  80161f:	85 c0                	test   %eax,%eax
  801621:	75 dd                	jne    801600 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801623:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801626:	c9                   	leave  
  801627:	c3                   	ret    

00801628 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801628:	55                   	push   %ebp
  801629:	89 e5                	mov    %esp,%ebp
  80162b:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80162e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801631:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801634:	8b 45 08             	mov    0x8(%ebp),%eax
  801637:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80163a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80163d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801640:	73 50                	jae    801692 <memmove+0x6a>
  801642:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801645:	8b 45 10             	mov    0x10(%ebp),%eax
  801648:	01 d0                	add    %edx,%eax
  80164a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80164d:	76 43                	jbe    801692 <memmove+0x6a>
		s += n;
  80164f:	8b 45 10             	mov    0x10(%ebp),%eax
  801652:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801655:	8b 45 10             	mov    0x10(%ebp),%eax
  801658:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  80165b:	eb 10                	jmp    80166d <memmove+0x45>
			*--d = *--s;
  80165d:	ff 4d f8             	decl   -0x8(%ebp)
  801660:	ff 4d fc             	decl   -0x4(%ebp)
  801663:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801666:	8a 10                	mov    (%eax),%dl
  801668:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80166b:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  80166d:	8b 45 10             	mov    0x10(%ebp),%eax
  801670:	8d 50 ff             	lea    -0x1(%eax),%edx
  801673:	89 55 10             	mov    %edx,0x10(%ebp)
  801676:	85 c0                	test   %eax,%eax
  801678:	75 e3                	jne    80165d <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  80167a:	eb 23                	jmp    80169f <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  80167c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80167f:	8d 50 01             	lea    0x1(%eax),%edx
  801682:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801685:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801688:	8d 4a 01             	lea    0x1(%edx),%ecx
  80168b:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80168e:	8a 12                	mov    (%edx),%dl
  801690:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801692:	8b 45 10             	mov    0x10(%ebp),%eax
  801695:	8d 50 ff             	lea    -0x1(%eax),%edx
  801698:	89 55 10             	mov    %edx,0x10(%ebp)
  80169b:	85 c0                	test   %eax,%eax
  80169d:	75 dd                	jne    80167c <memmove+0x54>
			*d++ = *s++;

	return dst;
  80169f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8016a2:	c9                   	leave  
  8016a3:	c3                   	ret    

008016a4 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8016a4:	55                   	push   %ebp
  8016a5:	89 e5                	mov    %esp,%ebp
  8016a7:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8016aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ad:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8016b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016b3:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8016b6:	eb 2a                	jmp    8016e2 <memcmp+0x3e>
		if (*s1 != *s2)
  8016b8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016bb:	8a 10                	mov    (%eax),%dl
  8016bd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016c0:	8a 00                	mov    (%eax),%al
  8016c2:	38 c2                	cmp    %al,%dl
  8016c4:	74 16                	je     8016dc <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8016c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8016c9:	8a 00                	mov    (%eax),%al
  8016cb:	0f b6 d0             	movzbl %al,%edx
  8016ce:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016d1:	8a 00                	mov    (%eax),%al
  8016d3:	0f b6 c0             	movzbl %al,%eax
  8016d6:	29 c2                	sub    %eax,%edx
  8016d8:	89 d0                	mov    %edx,%eax
  8016da:	eb 18                	jmp    8016f4 <memcmp+0x50>
		s1++, s2++;
  8016dc:	ff 45 fc             	incl   -0x4(%ebp)
  8016df:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8016e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8016e5:	8d 50 ff             	lea    -0x1(%eax),%edx
  8016e8:	89 55 10             	mov    %edx,0x10(%ebp)
  8016eb:	85 c0                	test   %eax,%eax
  8016ed:	75 c9                	jne    8016b8 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  8016ef:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8016f4:	c9                   	leave  
  8016f5:	c3                   	ret    

008016f6 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  8016f6:	55                   	push   %ebp
  8016f7:	89 e5                	mov    %esp,%ebp
  8016f9:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  8016fc:	8b 55 08             	mov    0x8(%ebp),%edx
  8016ff:	8b 45 10             	mov    0x10(%ebp),%eax
  801702:	01 d0                	add    %edx,%eax
  801704:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801707:	eb 15                	jmp    80171e <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801709:	8b 45 08             	mov    0x8(%ebp),%eax
  80170c:	8a 00                	mov    (%eax),%al
  80170e:	0f b6 d0             	movzbl %al,%edx
  801711:	8b 45 0c             	mov    0xc(%ebp),%eax
  801714:	0f b6 c0             	movzbl %al,%eax
  801717:	39 c2                	cmp    %eax,%edx
  801719:	74 0d                	je     801728 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80171b:	ff 45 08             	incl   0x8(%ebp)
  80171e:	8b 45 08             	mov    0x8(%ebp),%eax
  801721:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801724:	72 e3                	jb     801709 <memfind+0x13>
  801726:	eb 01                	jmp    801729 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801728:	90                   	nop
	return (void *) s;
  801729:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80172c:	c9                   	leave  
  80172d:	c3                   	ret    

0080172e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80172e:	55                   	push   %ebp
  80172f:	89 e5                	mov    %esp,%ebp
  801731:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801734:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80173b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801742:	eb 03                	jmp    801747 <strtol+0x19>
		s++;
  801744:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801747:	8b 45 08             	mov    0x8(%ebp),%eax
  80174a:	8a 00                	mov    (%eax),%al
  80174c:	3c 20                	cmp    $0x20,%al
  80174e:	74 f4                	je     801744 <strtol+0x16>
  801750:	8b 45 08             	mov    0x8(%ebp),%eax
  801753:	8a 00                	mov    (%eax),%al
  801755:	3c 09                	cmp    $0x9,%al
  801757:	74 eb                	je     801744 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801759:	8b 45 08             	mov    0x8(%ebp),%eax
  80175c:	8a 00                	mov    (%eax),%al
  80175e:	3c 2b                	cmp    $0x2b,%al
  801760:	75 05                	jne    801767 <strtol+0x39>
		s++;
  801762:	ff 45 08             	incl   0x8(%ebp)
  801765:	eb 13                	jmp    80177a <strtol+0x4c>
	else if (*s == '-')
  801767:	8b 45 08             	mov    0x8(%ebp),%eax
  80176a:	8a 00                	mov    (%eax),%al
  80176c:	3c 2d                	cmp    $0x2d,%al
  80176e:	75 0a                	jne    80177a <strtol+0x4c>
		s++, neg = 1;
  801770:	ff 45 08             	incl   0x8(%ebp)
  801773:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  80177a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80177e:	74 06                	je     801786 <strtol+0x58>
  801780:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  801784:	75 20                	jne    8017a6 <strtol+0x78>
  801786:	8b 45 08             	mov    0x8(%ebp),%eax
  801789:	8a 00                	mov    (%eax),%al
  80178b:	3c 30                	cmp    $0x30,%al
  80178d:	75 17                	jne    8017a6 <strtol+0x78>
  80178f:	8b 45 08             	mov    0x8(%ebp),%eax
  801792:	40                   	inc    %eax
  801793:	8a 00                	mov    (%eax),%al
  801795:	3c 78                	cmp    $0x78,%al
  801797:	75 0d                	jne    8017a6 <strtol+0x78>
		s += 2, base = 16;
  801799:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  80179d:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8017a4:	eb 28                	jmp    8017ce <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8017a6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017aa:	75 15                	jne    8017c1 <strtol+0x93>
  8017ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8017af:	8a 00                	mov    (%eax),%al
  8017b1:	3c 30                	cmp    $0x30,%al
  8017b3:	75 0c                	jne    8017c1 <strtol+0x93>
		s++, base = 8;
  8017b5:	ff 45 08             	incl   0x8(%ebp)
  8017b8:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8017bf:	eb 0d                	jmp    8017ce <strtol+0xa0>
	else if (base == 0)
  8017c1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8017c5:	75 07                	jne    8017ce <strtol+0xa0>
		base = 10;
  8017c7:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8017ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d1:	8a 00                	mov    (%eax),%al
  8017d3:	3c 2f                	cmp    $0x2f,%al
  8017d5:	7e 19                	jle    8017f0 <strtol+0xc2>
  8017d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8017da:	8a 00                	mov    (%eax),%al
  8017dc:	3c 39                	cmp    $0x39,%al
  8017de:	7f 10                	jg     8017f0 <strtol+0xc2>
			dig = *s - '0';
  8017e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e3:	8a 00                	mov    (%eax),%al
  8017e5:	0f be c0             	movsbl %al,%eax
  8017e8:	83 e8 30             	sub    $0x30,%eax
  8017eb:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8017ee:	eb 42                	jmp    801832 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  8017f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017f3:	8a 00                	mov    (%eax),%al
  8017f5:	3c 60                	cmp    $0x60,%al
  8017f7:	7e 19                	jle    801812 <strtol+0xe4>
  8017f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fc:	8a 00                	mov    (%eax),%al
  8017fe:	3c 7a                	cmp    $0x7a,%al
  801800:	7f 10                	jg     801812 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801802:	8b 45 08             	mov    0x8(%ebp),%eax
  801805:	8a 00                	mov    (%eax),%al
  801807:	0f be c0             	movsbl %al,%eax
  80180a:	83 e8 57             	sub    $0x57,%eax
  80180d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801810:	eb 20                	jmp    801832 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801812:	8b 45 08             	mov    0x8(%ebp),%eax
  801815:	8a 00                	mov    (%eax),%al
  801817:	3c 40                	cmp    $0x40,%al
  801819:	7e 39                	jle    801854 <strtol+0x126>
  80181b:	8b 45 08             	mov    0x8(%ebp),%eax
  80181e:	8a 00                	mov    (%eax),%al
  801820:	3c 5a                	cmp    $0x5a,%al
  801822:	7f 30                	jg     801854 <strtol+0x126>
			dig = *s - 'A' + 10;
  801824:	8b 45 08             	mov    0x8(%ebp),%eax
  801827:	8a 00                	mov    (%eax),%al
  801829:	0f be c0             	movsbl %al,%eax
  80182c:	83 e8 37             	sub    $0x37,%eax
  80182f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801832:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801835:	3b 45 10             	cmp    0x10(%ebp),%eax
  801838:	7d 19                	jge    801853 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80183a:	ff 45 08             	incl   0x8(%ebp)
  80183d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801840:	0f af 45 10          	imul   0x10(%ebp),%eax
  801844:	89 c2                	mov    %eax,%edx
  801846:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801849:	01 d0                	add    %edx,%eax
  80184b:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80184e:	e9 7b ff ff ff       	jmp    8017ce <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  801853:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  801854:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801858:	74 08                	je     801862 <strtol+0x134>
		*endptr = (char *) s;
  80185a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80185d:	8b 55 08             	mov    0x8(%ebp),%edx
  801860:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  801862:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801866:	74 07                	je     80186f <strtol+0x141>
  801868:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80186b:	f7 d8                	neg    %eax
  80186d:	eb 03                	jmp    801872 <strtol+0x144>
  80186f:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  801872:	c9                   	leave  
  801873:	c3                   	ret    

00801874 <ltostr>:

void
ltostr(long value, char *str)
{
  801874:	55                   	push   %ebp
  801875:	89 e5                	mov    %esp,%ebp
  801877:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  80187a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801881:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  801888:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80188c:	79 13                	jns    8018a1 <ltostr+0x2d>
	{
		neg = 1;
  80188e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801895:	8b 45 0c             	mov    0xc(%ebp),%eax
  801898:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  80189b:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  80189e:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8018a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a4:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8018a9:	99                   	cltd   
  8018aa:	f7 f9                	idiv   %ecx
  8018ac:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8018af:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8018b2:	8d 50 01             	lea    0x1(%eax),%edx
  8018b5:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8018b8:	89 c2                	mov    %eax,%edx
  8018ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8018bd:	01 d0                	add    %edx,%eax
  8018bf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8018c2:	83 c2 30             	add    $0x30,%edx
  8018c5:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8018c7:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018ca:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8018cf:	f7 e9                	imul   %ecx
  8018d1:	c1 fa 02             	sar    $0x2,%edx
  8018d4:	89 c8                	mov    %ecx,%eax
  8018d6:	c1 f8 1f             	sar    $0x1f,%eax
  8018d9:	29 c2                	sub    %eax,%edx
  8018db:	89 d0                	mov    %edx,%eax
  8018dd:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8018e0:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8018e3:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8018e8:	f7 e9                	imul   %ecx
  8018ea:	c1 fa 02             	sar    $0x2,%edx
  8018ed:	89 c8                	mov    %ecx,%eax
  8018ef:	c1 f8 1f             	sar    $0x1f,%eax
  8018f2:	29 c2                	sub    %eax,%edx
  8018f4:	89 d0                	mov    %edx,%eax
  8018f6:	c1 e0 02             	shl    $0x2,%eax
  8018f9:	01 d0                	add    %edx,%eax
  8018fb:	01 c0                	add    %eax,%eax
  8018fd:	29 c1                	sub    %eax,%ecx
  8018ff:	89 ca                	mov    %ecx,%edx
  801901:	85 d2                	test   %edx,%edx
  801903:	75 9c                	jne    8018a1 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801905:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80190c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80190f:	48                   	dec    %eax
  801910:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801913:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801917:	74 3d                	je     801956 <ltostr+0xe2>
		start = 1 ;
  801919:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801920:	eb 34                	jmp    801956 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801922:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801925:	8b 45 0c             	mov    0xc(%ebp),%eax
  801928:	01 d0                	add    %edx,%eax
  80192a:	8a 00                	mov    (%eax),%al
  80192c:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80192f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801932:	8b 45 0c             	mov    0xc(%ebp),%eax
  801935:	01 c2                	add    %eax,%edx
  801937:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80193a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80193d:	01 c8                	add    %ecx,%eax
  80193f:	8a 00                	mov    (%eax),%al
  801941:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801943:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801946:	8b 45 0c             	mov    0xc(%ebp),%eax
  801949:	01 c2                	add    %eax,%edx
  80194b:	8a 45 eb             	mov    -0x15(%ebp),%al
  80194e:	88 02                	mov    %al,(%edx)
		start++ ;
  801950:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  801953:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801956:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801959:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80195c:	7c c4                	jl     801922 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  80195e:	8b 55 f8             	mov    -0x8(%ebp),%edx
  801961:	8b 45 0c             	mov    0xc(%ebp),%eax
  801964:	01 d0                	add    %edx,%eax
  801966:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801969:	90                   	nop
  80196a:	c9                   	leave  
  80196b:	c3                   	ret    

0080196c <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  80196c:	55                   	push   %ebp
  80196d:	89 e5                	mov    %esp,%ebp
  80196f:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  801972:	ff 75 08             	pushl  0x8(%ebp)
  801975:	e8 54 fa ff ff       	call   8013ce <strlen>
  80197a:	83 c4 04             	add    $0x4,%esp
  80197d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801980:	ff 75 0c             	pushl  0xc(%ebp)
  801983:	e8 46 fa ff ff       	call   8013ce <strlen>
  801988:	83 c4 04             	add    $0x4,%esp
  80198b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  80198e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801995:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  80199c:	eb 17                	jmp    8019b5 <strcconcat+0x49>
		final[s] = str1[s] ;
  80199e:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019a1:	8b 45 10             	mov    0x10(%ebp),%eax
  8019a4:	01 c2                	add    %eax,%edx
  8019a6:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8019a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ac:	01 c8                	add    %ecx,%eax
  8019ae:	8a 00                	mov    (%eax),%al
  8019b0:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8019b2:	ff 45 fc             	incl   -0x4(%ebp)
  8019b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019b8:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8019bb:	7c e1                	jl     80199e <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8019bd:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8019c4:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8019cb:	eb 1f                	jmp    8019ec <strcconcat+0x80>
		final[s++] = str2[i] ;
  8019cd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8019d0:	8d 50 01             	lea    0x1(%eax),%edx
  8019d3:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8019d6:	89 c2                	mov    %eax,%edx
  8019d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8019db:	01 c2                	add    %eax,%edx
  8019dd:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8019e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8019e3:	01 c8                	add    %ecx,%eax
  8019e5:	8a 00                	mov    (%eax),%al
  8019e7:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  8019e9:	ff 45 f8             	incl   -0x8(%ebp)
  8019ec:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8019ef:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8019f2:	7c d9                	jl     8019cd <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  8019f4:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8019f7:	8b 45 10             	mov    0x10(%ebp),%eax
  8019fa:	01 d0                	add    %edx,%eax
  8019fc:	c6 00 00             	movb   $0x0,(%eax)
}
  8019ff:	90                   	nop
  801a00:	c9                   	leave  
  801a01:	c3                   	ret    

00801a02 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801a02:	55                   	push   %ebp
  801a03:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801a05:	8b 45 14             	mov    0x14(%ebp),%eax
  801a08:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801a0e:	8b 45 14             	mov    0x14(%ebp),%eax
  801a11:	8b 00                	mov    (%eax),%eax
  801a13:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a1a:	8b 45 10             	mov    0x10(%ebp),%eax
  801a1d:	01 d0                	add    %edx,%eax
  801a1f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a25:	eb 0c                	jmp    801a33 <strsplit+0x31>
			*string++ = 0;
  801a27:	8b 45 08             	mov    0x8(%ebp),%eax
  801a2a:	8d 50 01             	lea    0x1(%eax),%edx
  801a2d:	89 55 08             	mov    %edx,0x8(%ebp)
  801a30:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801a33:	8b 45 08             	mov    0x8(%ebp),%eax
  801a36:	8a 00                	mov    (%eax),%al
  801a38:	84 c0                	test   %al,%al
  801a3a:	74 18                	je     801a54 <strsplit+0x52>
  801a3c:	8b 45 08             	mov    0x8(%ebp),%eax
  801a3f:	8a 00                	mov    (%eax),%al
  801a41:	0f be c0             	movsbl %al,%eax
  801a44:	50                   	push   %eax
  801a45:	ff 75 0c             	pushl  0xc(%ebp)
  801a48:	e8 13 fb ff ff       	call   801560 <strchr>
  801a4d:	83 c4 08             	add    $0x8,%esp
  801a50:	85 c0                	test   %eax,%eax
  801a52:	75 d3                	jne    801a27 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  801a54:	8b 45 08             	mov    0x8(%ebp),%eax
  801a57:	8a 00                	mov    (%eax),%al
  801a59:	84 c0                	test   %al,%al
  801a5b:	74 5a                	je     801ab7 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801a5d:	8b 45 14             	mov    0x14(%ebp),%eax
  801a60:	8b 00                	mov    (%eax),%eax
  801a62:	83 f8 0f             	cmp    $0xf,%eax
  801a65:	75 07                	jne    801a6e <strsplit+0x6c>
		{
			return 0;
  801a67:	b8 00 00 00 00       	mov    $0x0,%eax
  801a6c:	eb 66                	jmp    801ad4 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801a6e:	8b 45 14             	mov    0x14(%ebp),%eax
  801a71:	8b 00                	mov    (%eax),%eax
  801a73:	8d 48 01             	lea    0x1(%eax),%ecx
  801a76:	8b 55 14             	mov    0x14(%ebp),%edx
  801a79:	89 0a                	mov    %ecx,(%edx)
  801a7b:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a82:	8b 45 10             	mov    0x10(%ebp),%eax
  801a85:	01 c2                	add    %eax,%edx
  801a87:	8b 45 08             	mov    0x8(%ebp),%eax
  801a8a:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a8c:	eb 03                	jmp    801a91 <strsplit+0x8f>
			string++;
  801a8e:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801a91:	8b 45 08             	mov    0x8(%ebp),%eax
  801a94:	8a 00                	mov    (%eax),%al
  801a96:	84 c0                	test   %al,%al
  801a98:	74 8b                	je     801a25 <strsplit+0x23>
  801a9a:	8b 45 08             	mov    0x8(%ebp),%eax
  801a9d:	8a 00                	mov    (%eax),%al
  801a9f:	0f be c0             	movsbl %al,%eax
  801aa2:	50                   	push   %eax
  801aa3:	ff 75 0c             	pushl  0xc(%ebp)
  801aa6:	e8 b5 fa ff ff       	call   801560 <strchr>
  801aab:	83 c4 08             	add    $0x8,%esp
  801aae:	85 c0                	test   %eax,%eax
  801ab0:	74 dc                	je     801a8e <strsplit+0x8c>
			string++;
	}
  801ab2:	e9 6e ff ff ff       	jmp    801a25 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801ab7:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801ab8:	8b 45 14             	mov    0x14(%ebp),%eax
  801abb:	8b 00                	mov    (%eax),%eax
  801abd:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801ac4:	8b 45 10             	mov    0x10(%ebp),%eax
  801ac7:	01 d0                	add    %edx,%eax
  801ac9:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801acf:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801ad4:	c9                   	leave  
  801ad5:	c3                   	ret    

00801ad6 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801ad6:	55                   	push   %ebp
  801ad7:	89 e5                	mov    %esp,%ebp
  801ad9:	57                   	push   %edi
  801ada:	56                   	push   %esi
  801adb:	53                   	push   %ebx
  801adc:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801adf:	8b 45 08             	mov    0x8(%ebp),%eax
  801ae2:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ae5:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801ae8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801aeb:	8b 7d 18             	mov    0x18(%ebp),%edi
  801aee:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801af1:	cd 30                	int    $0x30
  801af3:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801af6:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801af9:	83 c4 10             	add    $0x10,%esp
  801afc:	5b                   	pop    %ebx
  801afd:	5e                   	pop    %esi
  801afe:	5f                   	pop    %edi
  801aff:	5d                   	pop    %ebp
  801b00:	c3                   	ret    

00801b01 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801b01:	55                   	push   %ebp
  801b02:	89 e5                	mov    %esp,%ebp
  801b04:	83 ec 04             	sub    $0x4,%esp
  801b07:	8b 45 10             	mov    0x10(%ebp),%eax
  801b0a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801b0d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801b11:	8b 45 08             	mov    0x8(%ebp),%eax
  801b14:	6a 00                	push   $0x0
  801b16:	6a 00                	push   $0x0
  801b18:	52                   	push   %edx
  801b19:	ff 75 0c             	pushl  0xc(%ebp)
  801b1c:	50                   	push   %eax
  801b1d:	6a 00                	push   $0x0
  801b1f:	e8 b2 ff ff ff       	call   801ad6 <syscall>
  801b24:	83 c4 18             	add    $0x18,%esp
}
  801b27:	90                   	nop
  801b28:	c9                   	leave  
  801b29:	c3                   	ret    

00801b2a <sys_cgetc>:

int
sys_cgetc(void)
{
  801b2a:	55                   	push   %ebp
  801b2b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801b2d:	6a 00                	push   $0x0
  801b2f:	6a 00                	push   $0x0
  801b31:	6a 00                	push   $0x0
  801b33:	6a 00                	push   $0x0
  801b35:	6a 00                	push   $0x0
  801b37:	6a 01                	push   $0x1
  801b39:	e8 98 ff ff ff       	call   801ad6 <syscall>
  801b3e:	83 c4 18             	add    $0x18,%esp
}
  801b41:	c9                   	leave  
  801b42:	c3                   	ret    

00801b43 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801b43:	55                   	push   %ebp
  801b44:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801b46:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b49:	8b 45 08             	mov    0x8(%ebp),%eax
  801b4c:	6a 00                	push   $0x0
  801b4e:	6a 00                	push   $0x0
  801b50:	6a 00                	push   $0x0
  801b52:	52                   	push   %edx
  801b53:	50                   	push   %eax
  801b54:	6a 05                	push   $0x5
  801b56:	e8 7b ff ff ff       	call   801ad6 <syscall>
  801b5b:	83 c4 18             	add    $0x18,%esp
}
  801b5e:	c9                   	leave  
  801b5f:	c3                   	ret    

00801b60 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  801b60:	55                   	push   %ebp
  801b61:	89 e5                	mov    %esp,%ebp
  801b63:	56                   	push   %esi
  801b64:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801b65:	8b 75 18             	mov    0x18(%ebp),%esi
  801b68:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b6b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b6e:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b71:	8b 45 08             	mov    0x8(%ebp),%eax
  801b74:	56                   	push   %esi
  801b75:	53                   	push   %ebx
  801b76:	51                   	push   %ecx
  801b77:	52                   	push   %edx
  801b78:	50                   	push   %eax
  801b79:	6a 06                	push   $0x6
  801b7b:	e8 56 ff ff ff       	call   801ad6 <syscall>
  801b80:	83 c4 18             	add    $0x18,%esp
}
  801b83:	8d 65 f8             	lea    -0x8(%ebp),%esp
  801b86:	5b                   	pop    %ebx
  801b87:	5e                   	pop    %esi
  801b88:	5d                   	pop    %ebp
  801b89:	c3                   	ret    

00801b8a <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801b8a:	55                   	push   %ebp
  801b8b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801b8d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b90:	8b 45 08             	mov    0x8(%ebp),%eax
  801b93:	6a 00                	push   $0x0
  801b95:	6a 00                	push   $0x0
  801b97:	6a 00                	push   $0x0
  801b99:	52                   	push   %edx
  801b9a:	50                   	push   %eax
  801b9b:	6a 07                	push   $0x7
  801b9d:	e8 34 ff ff ff       	call   801ad6 <syscall>
  801ba2:	83 c4 18             	add    $0x18,%esp
}
  801ba5:	c9                   	leave  
  801ba6:	c3                   	ret    

00801ba7 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801ba7:	55                   	push   %ebp
  801ba8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801baa:	6a 00                	push   $0x0
  801bac:	6a 00                	push   $0x0
  801bae:	6a 00                	push   $0x0
  801bb0:	ff 75 0c             	pushl  0xc(%ebp)
  801bb3:	ff 75 08             	pushl  0x8(%ebp)
  801bb6:	6a 08                	push   $0x8
  801bb8:	e8 19 ff ff ff       	call   801ad6 <syscall>
  801bbd:	83 c4 18             	add    $0x18,%esp
}
  801bc0:	c9                   	leave  
  801bc1:	c3                   	ret    

00801bc2 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801bc2:	55                   	push   %ebp
  801bc3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801bc5:	6a 00                	push   $0x0
  801bc7:	6a 00                	push   $0x0
  801bc9:	6a 00                	push   $0x0
  801bcb:	6a 00                	push   $0x0
  801bcd:	6a 00                	push   $0x0
  801bcf:	6a 09                	push   $0x9
  801bd1:	e8 00 ff ff ff       	call   801ad6 <syscall>
  801bd6:	83 c4 18             	add    $0x18,%esp
}
  801bd9:	c9                   	leave  
  801bda:	c3                   	ret    

00801bdb <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801bdb:	55                   	push   %ebp
  801bdc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801bde:	6a 00                	push   $0x0
  801be0:	6a 00                	push   $0x0
  801be2:	6a 00                	push   $0x0
  801be4:	6a 00                	push   $0x0
  801be6:	6a 00                	push   $0x0
  801be8:	6a 0a                	push   $0xa
  801bea:	e8 e7 fe ff ff       	call   801ad6 <syscall>
  801bef:	83 c4 18             	add    $0x18,%esp
}
  801bf2:	c9                   	leave  
  801bf3:	c3                   	ret    

00801bf4 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801bf4:	55                   	push   %ebp
  801bf5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801bf7:	6a 00                	push   $0x0
  801bf9:	6a 00                	push   $0x0
  801bfb:	6a 00                	push   $0x0
  801bfd:	6a 00                	push   $0x0
  801bff:	6a 00                	push   $0x0
  801c01:	6a 0b                	push   $0xb
  801c03:	e8 ce fe ff ff       	call   801ad6 <syscall>
  801c08:	83 c4 18             	add    $0x18,%esp
}
  801c0b:	c9                   	leave  
  801c0c:	c3                   	ret    

00801c0d <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801c0d:	55                   	push   %ebp
  801c0e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801c10:	6a 00                	push   $0x0
  801c12:	6a 00                	push   $0x0
  801c14:	6a 00                	push   $0x0
  801c16:	ff 75 0c             	pushl  0xc(%ebp)
  801c19:	ff 75 08             	pushl  0x8(%ebp)
  801c1c:	6a 0f                	push   $0xf
  801c1e:	e8 b3 fe ff ff       	call   801ad6 <syscall>
  801c23:	83 c4 18             	add    $0x18,%esp
	return;
  801c26:	90                   	nop
}
  801c27:	c9                   	leave  
  801c28:	c3                   	ret    

00801c29 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801c29:	55                   	push   %ebp
  801c2a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801c2c:	6a 00                	push   $0x0
  801c2e:	6a 00                	push   $0x0
  801c30:	6a 00                	push   $0x0
  801c32:	ff 75 0c             	pushl  0xc(%ebp)
  801c35:	ff 75 08             	pushl  0x8(%ebp)
  801c38:	6a 10                	push   $0x10
  801c3a:	e8 97 fe ff ff       	call   801ad6 <syscall>
  801c3f:	83 c4 18             	add    $0x18,%esp
	return ;
  801c42:	90                   	nop
}
  801c43:	c9                   	leave  
  801c44:	c3                   	ret    

00801c45 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801c45:	55                   	push   %ebp
  801c46:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801c48:	6a 00                	push   $0x0
  801c4a:	6a 00                	push   $0x0
  801c4c:	ff 75 10             	pushl  0x10(%ebp)
  801c4f:	ff 75 0c             	pushl  0xc(%ebp)
  801c52:	ff 75 08             	pushl  0x8(%ebp)
  801c55:	6a 11                	push   $0x11
  801c57:	e8 7a fe ff ff       	call   801ad6 <syscall>
  801c5c:	83 c4 18             	add    $0x18,%esp
	return ;
  801c5f:	90                   	nop
}
  801c60:	c9                   	leave  
  801c61:	c3                   	ret    

00801c62 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  801c62:	55                   	push   %ebp
  801c63:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801c65:	6a 00                	push   $0x0
  801c67:	6a 00                	push   $0x0
  801c69:	6a 00                	push   $0x0
  801c6b:	6a 00                	push   $0x0
  801c6d:	6a 00                	push   $0x0
  801c6f:	6a 0c                	push   $0xc
  801c71:	e8 60 fe ff ff       	call   801ad6 <syscall>
  801c76:	83 c4 18             	add    $0x18,%esp
}
  801c79:	c9                   	leave  
  801c7a:	c3                   	ret    

00801c7b <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801c7b:	55                   	push   %ebp
  801c7c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801c7e:	6a 00                	push   $0x0
  801c80:	6a 00                	push   $0x0
  801c82:	6a 00                	push   $0x0
  801c84:	6a 00                	push   $0x0
  801c86:	ff 75 08             	pushl  0x8(%ebp)
  801c89:	6a 0d                	push   $0xd
  801c8b:	e8 46 fe ff ff       	call   801ad6 <syscall>
  801c90:	83 c4 18             	add    $0x18,%esp
}
  801c93:	c9                   	leave  
  801c94:	c3                   	ret    

00801c95 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801c95:	55                   	push   %ebp
  801c96:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801c98:	6a 00                	push   $0x0
  801c9a:	6a 00                	push   $0x0
  801c9c:	6a 00                	push   $0x0
  801c9e:	6a 00                	push   $0x0
  801ca0:	6a 00                	push   $0x0
  801ca2:	6a 0e                	push   $0xe
  801ca4:	e8 2d fe ff ff       	call   801ad6 <syscall>
  801ca9:	83 c4 18             	add    $0x18,%esp
}
  801cac:	90                   	nop
  801cad:	c9                   	leave  
  801cae:	c3                   	ret    

00801caf <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801caf:	55                   	push   %ebp
  801cb0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801cb2:	6a 00                	push   $0x0
  801cb4:	6a 00                	push   $0x0
  801cb6:	6a 00                	push   $0x0
  801cb8:	6a 00                	push   $0x0
  801cba:	6a 00                	push   $0x0
  801cbc:	6a 13                	push   $0x13
  801cbe:	e8 13 fe ff ff       	call   801ad6 <syscall>
  801cc3:	83 c4 18             	add    $0x18,%esp
}
  801cc6:	90                   	nop
  801cc7:	c9                   	leave  
  801cc8:	c3                   	ret    

00801cc9 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801cc9:	55                   	push   %ebp
  801cca:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801ccc:	6a 00                	push   $0x0
  801cce:	6a 00                	push   $0x0
  801cd0:	6a 00                	push   $0x0
  801cd2:	6a 00                	push   $0x0
  801cd4:	6a 00                	push   $0x0
  801cd6:	6a 14                	push   $0x14
  801cd8:	e8 f9 fd ff ff       	call   801ad6 <syscall>
  801cdd:	83 c4 18             	add    $0x18,%esp
}
  801ce0:	90                   	nop
  801ce1:	c9                   	leave  
  801ce2:	c3                   	ret    

00801ce3 <sys_cputc>:


void
sys_cputc(const char c)
{
  801ce3:	55                   	push   %ebp
  801ce4:	89 e5                	mov    %esp,%ebp
  801ce6:	83 ec 04             	sub    $0x4,%esp
  801ce9:	8b 45 08             	mov    0x8(%ebp),%eax
  801cec:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801cef:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801cf3:	6a 00                	push   $0x0
  801cf5:	6a 00                	push   $0x0
  801cf7:	6a 00                	push   $0x0
  801cf9:	6a 00                	push   $0x0
  801cfb:	50                   	push   %eax
  801cfc:	6a 15                	push   $0x15
  801cfe:	e8 d3 fd ff ff       	call   801ad6 <syscall>
  801d03:	83 c4 18             	add    $0x18,%esp
}
  801d06:	90                   	nop
  801d07:	c9                   	leave  
  801d08:	c3                   	ret    

00801d09 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801d09:	55                   	push   %ebp
  801d0a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801d0c:	6a 00                	push   $0x0
  801d0e:	6a 00                	push   $0x0
  801d10:	6a 00                	push   $0x0
  801d12:	6a 00                	push   $0x0
  801d14:	6a 00                	push   $0x0
  801d16:	6a 16                	push   $0x16
  801d18:	e8 b9 fd ff ff       	call   801ad6 <syscall>
  801d1d:	83 c4 18             	add    $0x18,%esp
}
  801d20:	90                   	nop
  801d21:	c9                   	leave  
  801d22:	c3                   	ret    

00801d23 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801d23:	55                   	push   %ebp
  801d24:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801d26:	8b 45 08             	mov    0x8(%ebp),%eax
  801d29:	6a 00                	push   $0x0
  801d2b:	6a 00                	push   $0x0
  801d2d:	6a 00                	push   $0x0
  801d2f:	ff 75 0c             	pushl  0xc(%ebp)
  801d32:	50                   	push   %eax
  801d33:	6a 17                	push   $0x17
  801d35:	e8 9c fd ff ff       	call   801ad6 <syscall>
  801d3a:	83 c4 18             	add    $0x18,%esp
}
  801d3d:	c9                   	leave  
  801d3e:	c3                   	ret    

00801d3f <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801d3f:	55                   	push   %ebp
  801d40:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d42:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d45:	8b 45 08             	mov    0x8(%ebp),%eax
  801d48:	6a 00                	push   $0x0
  801d4a:	6a 00                	push   $0x0
  801d4c:	6a 00                	push   $0x0
  801d4e:	52                   	push   %edx
  801d4f:	50                   	push   %eax
  801d50:	6a 1a                	push   $0x1a
  801d52:	e8 7f fd ff ff       	call   801ad6 <syscall>
  801d57:	83 c4 18             	add    $0x18,%esp
}
  801d5a:	c9                   	leave  
  801d5b:	c3                   	ret    

00801d5c <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801d5c:	55                   	push   %ebp
  801d5d:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d5f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d62:	8b 45 08             	mov    0x8(%ebp),%eax
  801d65:	6a 00                	push   $0x0
  801d67:	6a 00                	push   $0x0
  801d69:	6a 00                	push   $0x0
  801d6b:	52                   	push   %edx
  801d6c:	50                   	push   %eax
  801d6d:	6a 18                	push   $0x18
  801d6f:	e8 62 fd ff ff       	call   801ad6 <syscall>
  801d74:	83 c4 18             	add    $0x18,%esp
}
  801d77:	90                   	nop
  801d78:	c9                   	leave  
  801d79:	c3                   	ret    

00801d7a <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801d7a:	55                   	push   %ebp
  801d7b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801d7d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d80:	8b 45 08             	mov    0x8(%ebp),%eax
  801d83:	6a 00                	push   $0x0
  801d85:	6a 00                	push   $0x0
  801d87:	6a 00                	push   $0x0
  801d89:	52                   	push   %edx
  801d8a:	50                   	push   %eax
  801d8b:	6a 19                	push   $0x19
  801d8d:	e8 44 fd ff ff       	call   801ad6 <syscall>
  801d92:	83 c4 18             	add    $0x18,%esp
}
  801d95:	90                   	nop
  801d96:	c9                   	leave  
  801d97:	c3                   	ret    

00801d98 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801d98:	55                   	push   %ebp
  801d99:	89 e5                	mov    %esp,%ebp
  801d9b:	83 ec 04             	sub    $0x4,%esp
  801d9e:	8b 45 10             	mov    0x10(%ebp),%eax
  801da1:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801da4:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801da7:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801dab:	8b 45 08             	mov    0x8(%ebp),%eax
  801dae:	6a 00                	push   $0x0
  801db0:	51                   	push   %ecx
  801db1:	52                   	push   %edx
  801db2:	ff 75 0c             	pushl  0xc(%ebp)
  801db5:	50                   	push   %eax
  801db6:	6a 1b                	push   $0x1b
  801db8:	e8 19 fd ff ff       	call   801ad6 <syscall>
  801dbd:	83 c4 18             	add    $0x18,%esp
}
  801dc0:	c9                   	leave  
  801dc1:	c3                   	ret    

00801dc2 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801dc2:	55                   	push   %ebp
  801dc3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801dc5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801dc8:	8b 45 08             	mov    0x8(%ebp),%eax
  801dcb:	6a 00                	push   $0x0
  801dcd:	6a 00                	push   $0x0
  801dcf:	6a 00                	push   $0x0
  801dd1:	52                   	push   %edx
  801dd2:	50                   	push   %eax
  801dd3:	6a 1c                	push   $0x1c
  801dd5:	e8 fc fc ff ff       	call   801ad6 <syscall>
  801dda:	83 c4 18             	add    $0x18,%esp
}
  801ddd:	c9                   	leave  
  801dde:	c3                   	ret    

00801ddf <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801ddf:	55                   	push   %ebp
  801de0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801de2:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801de5:	8b 55 0c             	mov    0xc(%ebp),%edx
  801de8:	8b 45 08             	mov    0x8(%ebp),%eax
  801deb:	6a 00                	push   $0x0
  801ded:	6a 00                	push   $0x0
  801def:	51                   	push   %ecx
  801df0:	52                   	push   %edx
  801df1:	50                   	push   %eax
  801df2:	6a 1d                	push   $0x1d
  801df4:	e8 dd fc ff ff       	call   801ad6 <syscall>
  801df9:	83 c4 18             	add    $0x18,%esp
}
  801dfc:	c9                   	leave  
  801dfd:	c3                   	ret    

00801dfe <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801dfe:	55                   	push   %ebp
  801dff:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801e01:	8b 55 0c             	mov    0xc(%ebp),%edx
  801e04:	8b 45 08             	mov    0x8(%ebp),%eax
  801e07:	6a 00                	push   $0x0
  801e09:	6a 00                	push   $0x0
  801e0b:	6a 00                	push   $0x0
  801e0d:	52                   	push   %edx
  801e0e:	50                   	push   %eax
  801e0f:	6a 1e                	push   $0x1e
  801e11:	e8 c0 fc ff ff       	call   801ad6 <syscall>
  801e16:	83 c4 18             	add    $0x18,%esp
}
  801e19:	c9                   	leave  
  801e1a:	c3                   	ret    

00801e1b <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801e1b:	55                   	push   %ebp
  801e1c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801e1e:	6a 00                	push   $0x0
  801e20:	6a 00                	push   $0x0
  801e22:	6a 00                	push   $0x0
  801e24:	6a 00                	push   $0x0
  801e26:	6a 00                	push   $0x0
  801e28:	6a 1f                	push   $0x1f
  801e2a:	e8 a7 fc ff ff       	call   801ad6 <syscall>
  801e2f:	83 c4 18             	add    $0x18,%esp
}
  801e32:	c9                   	leave  
  801e33:	c3                   	ret    

00801e34 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801e34:	55                   	push   %ebp
  801e35:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801e37:	8b 45 08             	mov    0x8(%ebp),%eax
  801e3a:	6a 00                	push   $0x0
  801e3c:	ff 75 14             	pushl  0x14(%ebp)
  801e3f:	ff 75 10             	pushl  0x10(%ebp)
  801e42:	ff 75 0c             	pushl  0xc(%ebp)
  801e45:	50                   	push   %eax
  801e46:	6a 20                	push   $0x20
  801e48:	e8 89 fc ff ff       	call   801ad6 <syscall>
  801e4d:	83 c4 18             	add    $0x18,%esp
}
  801e50:	c9                   	leave  
  801e51:	c3                   	ret    

00801e52 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801e52:	55                   	push   %ebp
  801e53:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801e55:	8b 45 08             	mov    0x8(%ebp),%eax
  801e58:	6a 00                	push   $0x0
  801e5a:	6a 00                	push   $0x0
  801e5c:	6a 00                	push   $0x0
  801e5e:	6a 00                	push   $0x0
  801e60:	50                   	push   %eax
  801e61:	6a 21                	push   $0x21
  801e63:	e8 6e fc ff ff       	call   801ad6 <syscall>
  801e68:	83 c4 18             	add    $0x18,%esp
}
  801e6b:	90                   	nop
  801e6c:	c9                   	leave  
  801e6d:	c3                   	ret    

00801e6e <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801e6e:	55                   	push   %ebp
  801e6f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801e71:	8b 45 08             	mov    0x8(%ebp),%eax
  801e74:	6a 00                	push   $0x0
  801e76:	6a 00                	push   $0x0
  801e78:	6a 00                	push   $0x0
  801e7a:	6a 00                	push   $0x0
  801e7c:	50                   	push   %eax
  801e7d:	6a 22                	push   $0x22
  801e7f:	e8 52 fc ff ff       	call   801ad6 <syscall>
  801e84:	83 c4 18             	add    $0x18,%esp
}
  801e87:	c9                   	leave  
  801e88:	c3                   	ret    

00801e89 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801e89:	55                   	push   %ebp
  801e8a:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801e8c:	6a 00                	push   $0x0
  801e8e:	6a 00                	push   $0x0
  801e90:	6a 00                	push   $0x0
  801e92:	6a 00                	push   $0x0
  801e94:	6a 00                	push   $0x0
  801e96:	6a 02                	push   $0x2
  801e98:	e8 39 fc ff ff       	call   801ad6 <syscall>
  801e9d:	83 c4 18             	add    $0x18,%esp
}
  801ea0:	c9                   	leave  
  801ea1:	c3                   	ret    

00801ea2 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801ea2:	55                   	push   %ebp
  801ea3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801ea5:	6a 00                	push   $0x0
  801ea7:	6a 00                	push   $0x0
  801ea9:	6a 00                	push   $0x0
  801eab:	6a 00                	push   $0x0
  801ead:	6a 00                	push   $0x0
  801eaf:	6a 03                	push   $0x3
  801eb1:	e8 20 fc ff ff       	call   801ad6 <syscall>
  801eb6:	83 c4 18             	add    $0x18,%esp
}
  801eb9:	c9                   	leave  
  801eba:	c3                   	ret    

00801ebb <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801ebb:	55                   	push   %ebp
  801ebc:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801ebe:	6a 00                	push   $0x0
  801ec0:	6a 00                	push   $0x0
  801ec2:	6a 00                	push   $0x0
  801ec4:	6a 00                	push   $0x0
  801ec6:	6a 00                	push   $0x0
  801ec8:	6a 04                	push   $0x4
  801eca:	e8 07 fc ff ff       	call   801ad6 <syscall>
  801ecf:	83 c4 18             	add    $0x18,%esp
}
  801ed2:	c9                   	leave  
  801ed3:	c3                   	ret    

00801ed4 <sys_exit_env>:


void sys_exit_env(void)
{
  801ed4:	55                   	push   %ebp
  801ed5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801ed7:	6a 00                	push   $0x0
  801ed9:	6a 00                	push   $0x0
  801edb:	6a 00                	push   $0x0
  801edd:	6a 00                	push   $0x0
  801edf:	6a 00                	push   $0x0
  801ee1:	6a 23                	push   $0x23
  801ee3:	e8 ee fb ff ff       	call   801ad6 <syscall>
  801ee8:	83 c4 18             	add    $0x18,%esp
}
  801eeb:	90                   	nop
  801eec:	c9                   	leave  
  801eed:	c3                   	ret    

00801eee <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801eee:	55                   	push   %ebp
  801eef:	89 e5                	mov    %esp,%ebp
  801ef1:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801ef4:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801ef7:	8d 50 04             	lea    0x4(%eax),%edx
  801efa:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801efd:	6a 00                	push   $0x0
  801eff:	6a 00                	push   $0x0
  801f01:	6a 00                	push   $0x0
  801f03:	52                   	push   %edx
  801f04:	50                   	push   %eax
  801f05:	6a 24                	push   $0x24
  801f07:	e8 ca fb ff ff       	call   801ad6 <syscall>
  801f0c:	83 c4 18             	add    $0x18,%esp
	return result;
  801f0f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801f12:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801f15:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801f18:	89 01                	mov    %eax,(%ecx)
  801f1a:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801f1d:	8b 45 08             	mov    0x8(%ebp),%eax
  801f20:	c9                   	leave  
  801f21:	c2 04 00             	ret    $0x4

00801f24 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801f24:	55                   	push   %ebp
  801f25:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801f27:	6a 00                	push   $0x0
  801f29:	6a 00                	push   $0x0
  801f2b:	ff 75 10             	pushl  0x10(%ebp)
  801f2e:	ff 75 0c             	pushl  0xc(%ebp)
  801f31:	ff 75 08             	pushl  0x8(%ebp)
  801f34:	6a 12                	push   $0x12
  801f36:	e8 9b fb ff ff       	call   801ad6 <syscall>
  801f3b:	83 c4 18             	add    $0x18,%esp
	return ;
  801f3e:	90                   	nop
}
  801f3f:	c9                   	leave  
  801f40:	c3                   	ret    

00801f41 <sys_rcr2>:
uint32 sys_rcr2()
{
  801f41:	55                   	push   %ebp
  801f42:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801f44:	6a 00                	push   $0x0
  801f46:	6a 00                	push   $0x0
  801f48:	6a 00                	push   $0x0
  801f4a:	6a 00                	push   $0x0
  801f4c:	6a 00                	push   $0x0
  801f4e:	6a 25                	push   $0x25
  801f50:	e8 81 fb ff ff       	call   801ad6 <syscall>
  801f55:	83 c4 18             	add    $0x18,%esp
}
  801f58:	c9                   	leave  
  801f59:	c3                   	ret    

00801f5a <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801f5a:	55                   	push   %ebp
  801f5b:	89 e5                	mov    %esp,%ebp
  801f5d:	83 ec 04             	sub    $0x4,%esp
  801f60:	8b 45 08             	mov    0x8(%ebp),%eax
  801f63:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801f66:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801f6a:	6a 00                	push   $0x0
  801f6c:	6a 00                	push   $0x0
  801f6e:	6a 00                	push   $0x0
  801f70:	6a 00                	push   $0x0
  801f72:	50                   	push   %eax
  801f73:	6a 26                	push   $0x26
  801f75:	e8 5c fb ff ff       	call   801ad6 <syscall>
  801f7a:	83 c4 18             	add    $0x18,%esp
	return ;
  801f7d:	90                   	nop
}
  801f7e:	c9                   	leave  
  801f7f:	c3                   	ret    

00801f80 <rsttst>:
void rsttst()
{
  801f80:	55                   	push   %ebp
  801f81:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801f83:	6a 00                	push   $0x0
  801f85:	6a 00                	push   $0x0
  801f87:	6a 00                	push   $0x0
  801f89:	6a 00                	push   $0x0
  801f8b:	6a 00                	push   $0x0
  801f8d:	6a 28                	push   $0x28
  801f8f:	e8 42 fb ff ff       	call   801ad6 <syscall>
  801f94:	83 c4 18             	add    $0x18,%esp
	return ;
  801f97:	90                   	nop
}
  801f98:	c9                   	leave  
  801f99:	c3                   	ret    

00801f9a <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801f9a:	55                   	push   %ebp
  801f9b:	89 e5                	mov    %esp,%ebp
  801f9d:	83 ec 04             	sub    $0x4,%esp
  801fa0:	8b 45 14             	mov    0x14(%ebp),%eax
  801fa3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801fa6:	8b 55 18             	mov    0x18(%ebp),%edx
  801fa9:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801fad:	52                   	push   %edx
  801fae:	50                   	push   %eax
  801faf:	ff 75 10             	pushl  0x10(%ebp)
  801fb2:	ff 75 0c             	pushl  0xc(%ebp)
  801fb5:	ff 75 08             	pushl  0x8(%ebp)
  801fb8:	6a 27                	push   $0x27
  801fba:	e8 17 fb ff ff       	call   801ad6 <syscall>
  801fbf:	83 c4 18             	add    $0x18,%esp
	return ;
  801fc2:	90                   	nop
}
  801fc3:	c9                   	leave  
  801fc4:	c3                   	ret    

00801fc5 <chktst>:
void chktst(uint32 n)
{
  801fc5:	55                   	push   %ebp
  801fc6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801fc8:	6a 00                	push   $0x0
  801fca:	6a 00                	push   $0x0
  801fcc:	6a 00                	push   $0x0
  801fce:	6a 00                	push   $0x0
  801fd0:	ff 75 08             	pushl  0x8(%ebp)
  801fd3:	6a 29                	push   $0x29
  801fd5:	e8 fc fa ff ff       	call   801ad6 <syscall>
  801fda:	83 c4 18             	add    $0x18,%esp
	return ;
  801fdd:	90                   	nop
}
  801fde:	c9                   	leave  
  801fdf:	c3                   	ret    

00801fe0 <inctst>:

void inctst()
{
  801fe0:	55                   	push   %ebp
  801fe1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801fe3:	6a 00                	push   $0x0
  801fe5:	6a 00                	push   $0x0
  801fe7:	6a 00                	push   $0x0
  801fe9:	6a 00                	push   $0x0
  801feb:	6a 00                	push   $0x0
  801fed:	6a 2a                	push   $0x2a
  801fef:	e8 e2 fa ff ff       	call   801ad6 <syscall>
  801ff4:	83 c4 18             	add    $0x18,%esp
	return ;
  801ff7:	90                   	nop
}
  801ff8:	c9                   	leave  
  801ff9:	c3                   	ret    

00801ffa <gettst>:
uint32 gettst()
{
  801ffa:	55                   	push   %ebp
  801ffb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801ffd:	6a 00                	push   $0x0
  801fff:	6a 00                	push   $0x0
  802001:	6a 00                	push   $0x0
  802003:	6a 00                	push   $0x0
  802005:	6a 00                	push   $0x0
  802007:	6a 2b                	push   $0x2b
  802009:	e8 c8 fa ff ff       	call   801ad6 <syscall>
  80200e:	83 c4 18             	add    $0x18,%esp
}
  802011:	c9                   	leave  
  802012:	c3                   	ret    

00802013 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  802013:	55                   	push   %ebp
  802014:	89 e5                	mov    %esp,%ebp
  802016:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  802019:	6a 00                	push   $0x0
  80201b:	6a 00                	push   $0x0
  80201d:	6a 00                	push   $0x0
  80201f:	6a 00                	push   $0x0
  802021:	6a 00                	push   $0x0
  802023:	6a 2c                	push   $0x2c
  802025:	e8 ac fa ff ff       	call   801ad6 <syscall>
  80202a:	83 c4 18             	add    $0x18,%esp
  80202d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  802030:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  802034:	75 07                	jne    80203d <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  802036:	b8 01 00 00 00       	mov    $0x1,%eax
  80203b:	eb 05                	jmp    802042 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80203d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802042:	c9                   	leave  
  802043:	c3                   	ret    

00802044 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  802044:	55                   	push   %ebp
  802045:	89 e5                	mov    %esp,%ebp
  802047:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80204a:	6a 00                	push   $0x0
  80204c:	6a 00                	push   $0x0
  80204e:	6a 00                	push   $0x0
  802050:	6a 00                	push   $0x0
  802052:	6a 00                	push   $0x0
  802054:	6a 2c                	push   $0x2c
  802056:	e8 7b fa ff ff       	call   801ad6 <syscall>
  80205b:	83 c4 18             	add    $0x18,%esp
  80205e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  802061:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  802065:	75 07                	jne    80206e <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  802067:	b8 01 00 00 00       	mov    $0x1,%eax
  80206c:	eb 05                	jmp    802073 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  80206e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  802073:	c9                   	leave  
  802074:	c3                   	ret    

00802075 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  802075:	55                   	push   %ebp
  802076:	89 e5                	mov    %esp,%ebp
  802078:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80207b:	6a 00                	push   $0x0
  80207d:	6a 00                	push   $0x0
  80207f:	6a 00                	push   $0x0
  802081:	6a 00                	push   $0x0
  802083:	6a 00                	push   $0x0
  802085:	6a 2c                	push   $0x2c
  802087:	e8 4a fa ff ff       	call   801ad6 <syscall>
  80208c:	83 c4 18             	add    $0x18,%esp
  80208f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  802092:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  802096:	75 07                	jne    80209f <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  802098:	b8 01 00 00 00       	mov    $0x1,%eax
  80209d:	eb 05                	jmp    8020a4 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  80209f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020a4:	c9                   	leave  
  8020a5:	c3                   	ret    

008020a6 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8020a6:	55                   	push   %ebp
  8020a7:	89 e5                	mov    %esp,%ebp
  8020a9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8020ac:	6a 00                	push   $0x0
  8020ae:	6a 00                	push   $0x0
  8020b0:	6a 00                	push   $0x0
  8020b2:	6a 00                	push   $0x0
  8020b4:	6a 00                	push   $0x0
  8020b6:	6a 2c                	push   $0x2c
  8020b8:	e8 19 fa ff ff       	call   801ad6 <syscall>
  8020bd:	83 c4 18             	add    $0x18,%esp
  8020c0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  8020c3:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  8020c7:	75 07                	jne    8020d0 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  8020c9:	b8 01 00 00 00       	mov    $0x1,%eax
  8020ce:	eb 05                	jmp    8020d5 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  8020d0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8020d5:	c9                   	leave  
  8020d6:	c3                   	ret    

008020d7 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  8020d7:	55                   	push   %ebp
  8020d8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  8020da:	6a 00                	push   $0x0
  8020dc:	6a 00                	push   $0x0
  8020de:	6a 00                	push   $0x0
  8020e0:	6a 00                	push   $0x0
  8020e2:	ff 75 08             	pushl  0x8(%ebp)
  8020e5:	6a 2d                	push   $0x2d
  8020e7:	e8 ea f9 ff ff       	call   801ad6 <syscall>
  8020ec:	83 c4 18             	add    $0x18,%esp
	return ;
  8020ef:	90                   	nop
}
  8020f0:	c9                   	leave  
  8020f1:	c3                   	ret    

008020f2 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  8020f2:	55                   	push   %ebp
  8020f3:	89 e5                	mov    %esp,%ebp
  8020f5:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  8020f6:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8020f9:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8020fc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8020ff:	8b 45 08             	mov    0x8(%ebp),%eax
  802102:	6a 00                	push   $0x0
  802104:	53                   	push   %ebx
  802105:	51                   	push   %ecx
  802106:	52                   	push   %edx
  802107:	50                   	push   %eax
  802108:	6a 2e                	push   $0x2e
  80210a:	e8 c7 f9 ff ff       	call   801ad6 <syscall>
  80210f:	83 c4 18             	add    $0x18,%esp
}
  802112:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  802115:	c9                   	leave  
  802116:	c3                   	ret    

00802117 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  802117:	55                   	push   %ebp
  802118:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  80211a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80211d:	8b 45 08             	mov    0x8(%ebp),%eax
  802120:	6a 00                	push   $0x0
  802122:	6a 00                	push   $0x0
  802124:	6a 00                	push   $0x0
  802126:	52                   	push   %edx
  802127:	50                   	push   %eax
  802128:	6a 2f                	push   $0x2f
  80212a:	e8 a7 f9 ff ff       	call   801ad6 <syscall>
  80212f:	83 c4 18             	add    $0x18,%esp
}
  802132:	c9                   	leave  
  802133:	c3                   	ret    

00802134 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  802134:	55                   	push   %ebp
  802135:	89 e5                	mov    %esp,%ebp
  802137:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  80213a:	8b 55 08             	mov    0x8(%ebp),%edx
  80213d:	89 d0                	mov    %edx,%eax
  80213f:	c1 e0 02             	shl    $0x2,%eax
  802142:	01 d0                	add    %edx,%eax
  802144:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80214b:	01 d0                	add    %edx,%eax
  80214d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  802154:	01 d0                	add    %edx,%eax
  802156:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80215d:	01 d0                	add    %edx,%eax
  80215f:	c1 e0 04             	shl    $0x4,%eax
  802162:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  802165:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  80216c:	8d 45 e8             	lea    -0x18(%ebp),%eax
  80216f:	83 ec 0c             	sub    $0xc,%esp
  802172:	50                   	push   %eax
  802173:	e8 76 fd ff ff       	call   801eee <sys_get_virtual_time>
  802178:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  80217b:	eb 41                	jmp    8021be <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  80217d:	8d 45 e0             	lea    -0x20(%ebp),%eax
  802180:	83 ec 0c             	sub    $0xc,%esp
  802183:	50                   	push   %eax
  802184:	e8 65 fd ff ff       	call   801eee <sys_get_virtual_time>
  802189:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  80218c:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80218f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  802192:	29 c2                	sub    %eax,%edx
  802194:	89 d0                	mov    %edx,%eax
  802196:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  802199:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80219c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80219f:	89 d1                	mov    %edx,%ecx
  8021a1:	29 c1                	sub    %eax,%ecx
  8021a3:	8b 55 d8             	mov    -0x28(%ebp),%edx
  8021a6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8021a9:	39 c2                	cmp    %eax,%edx
  8021ab:	0f 97 c0             	seta   %al
  8021ae:	0f b6 c0             	movzbl %al,%eax
  8021b1:	29 c1                	sub    %eax,%ecx
  8021b3:	89 c8                	mov    %ecx,%eax
  8021b5:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  8021b8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8021bb:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  8021be:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8021c1:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8021c4:	72 b7                	jb     80217d <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  8021c6:	90                   	nop
  8021c7:	c9                   	leave  
  8021c8:	c3                   	ret    

008021c9 <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  8021c9:	55                   	push   %ebp
  8021ca:	89 e5                	mov    %esp,%ebp
  8021cc:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  8021cf:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  8021d6:	eb 03                	jmp    8021db <busy_wait+0x12>
  8021d8:	ff 45 fc             	incl   -0x4(%ebp)
  8021db:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8021de:	3b 45 08             	cmp    0x8(%ebp),%eax
  8021e1:	72 f5                	jb     8021d8 <busy_wait+0xf>
	return i;
  8021e3:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8021e6:	c9                   	leave  
  8021e7:	c3                   	ret    

008021e8 <__udivdi3>:
  8021e8:	55                   	push   %ebp
  8021e9:	57                   	push   %edi
  8021ea:	56                   	push   %esi
  8021eb:	53                   	push   %ebx
  8021ec:	83 ec 1c             	sub    $0x1c,%esp
  8021ef:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  8021f3:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  8021f7:	8b 7c 24 38          	mov    0x38(%esp),%edi
  8021fb:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  8021ff:	89 ca                	mov    %ecx,%edx
  802201:	89 f8                	mov    %edi,%eax
  802203:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  802207:	85 f6                	test   %esi,%esi
  802209:	75 2d                	jne    802238 <__udivdi3+0x50>
  80220b:	39 cf                	cmp    %ecx,%edi
  80220d:	77 65                	ja     802274 <__udivdi3+0x8c>
  80220f:	89 fd                	mov    %edi,%ebp
  802211:	85 ff                	test   %edi,%edi
  802213:	75 0b                	jne    802220 <__udivdi3+0x38>
  802215:	b8 01 00 00 00       	mov    $0x1,%eax
  80221a:	31 d2                	xor    %edx,%edx
  80221c:	f7 f7                	div    %edi
  80221e:	89 c5                	mov    %eax,%ebp
  802220:	31 d2                	xor    %edx,%edx
  802222:	89 c8                	mov    %ecx,%eax
  802224:	f7 f5                	div    %ebp
  802226:	89 c1                	mov    %eax,%ecx
  802228:	89 d8                	mov    %ebx,%eax
  80222a:	f7 f5                	div    %ebp
  80222c:	89 cf                	mov    %ecx,%edi
  80222e:	89 fa                	mov    %edi,%edx
  802230:	83 c4 1c             	add    $0x1c,%esp
  802233:	5b                   	pop    %ebx
  802234:	5e                   	pop    %esi
  802235:	5f                   	pop    %edi
  802236:	5d                   	pop    %ebp
  802237:	c3                   	ret    
  802238:	39 ce                	cmp    %ecx,%esi
  80223a:	77 28                	ja     802264 <__udivdi3+0x7c>
  80223c:	0f bd fe             	bsr    %esi,%edi
  80223f:	83 f7 1f             	xor    $0x1f,%edi
  802242:	75 40                	jne    802284 <__udivdi3+0x9c>
  802244:	39 ce                	cmp    %ecx,%esi
  802246:	72 0a                	jb     802252 <__udivdi3+0x6a>
  802248:	3b 44 24 08          	cmp    0x8(%esp),%eax
  80224c:	0f 87 9e 00 00 00    	ja     8022f0 <__udivdi3+0x108>
  802252:	b8 01 00 00 00       	mov    $0x1,%eax
  802257:	89 fa                	mov    %edi,%edx
  802259:	83 c4 1c             	add    $0x1c,%esp
  80225c:	5b                   	pop    %ebx
  80225d:	5e                   	pop    %esi
  80225e:	5f                   	pop    %edi
  80225f:	5d                   	pop    %ebp
  802260:	c3                   	ret    
  802261:	8d 76 00             	lea    0x0(%esi),%esi
  802264:	31 ff                	xor    %edi,%edi
  802266:	31 c0                	xor    %eax,%eax
  802268:	89 fa                	mov    %edi,%edx
  80226a:	83 c4 1c             	add    $0x1c,%esp
  80226d:	5b                   	pop    %ebx
  80226e:	5e                   	pop    %esi
  80226f:	5f                   	pop    %edi
  802270:	5d                   	pop    %ebp
  802271:	c3                   	ret    
  802272:	66 90                	xchg   %ax,%ax
  802274:	89 d8                	mov    %ebx,%eax
  802276:	f7 f7                	div    %edi
  802278:	31 ff                	xor    %edi,%edi
  80227a:	89 fa                	mov    %edi,%edx
  80227c:	83 c4 1c             	add    $0x1c,%esp
  80227f:	5b                   	pop    %ebx
  802280:	5e                   	pop    %esi
  802281:	5f                   	pop    %edi
  802282:	5d                   	pop    %ebp
  802283:	c3                   	ret    
  802284:	bd 20 00 00 00       	mov    $0x20,%ebp
  802289:	89 eb                	mov    %ebp,%ebx
  80228b:	29 fb                	sub    %edi,%ebx
  80228d:	89 f9                	mov    %edi,%ecx
  80228f:	d3 e6                	shl    %cl,%esi
  802291:	89 c5                	mov    %eax,%ebp
  802293:	88 d9                	mov    %bl,%cl
  802295:	d3 ed                	shr    %cl,%ebp
  802297:	89 e9                	mov    %ebp,%ecx
  802299:	09 f1                	or     %esi,%ecx
  80229b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  80229f:	89 f9                	mov    %edi,%ecx
  8022a1:	d3 e0                	shl    %cl,%eax
  8022a3:	89 c5                	mov    %eax,%ebp
  8022a5:	89 d6                	mov    %edx,%esi
  8022a7:	88 d9                	mov    %bl,%cl
  8022a9:	d3 ee                	shr    %cl,%esi
  8022ab:	89 f9                	mov    %edi,%ecx
  8022ad:	d3 e2                	shl    %cl,%edx
  8022af:	8b 44 24 08          	mov    0x8(%esp),%eax
  8022b3:	88 d9                	mov    %bl,%cl
  8022b5:	d3 e8                	shr    %cl,%eax
  8022b7:	09 c2                	or     %eax,%edx
  8022b9:	89 d0                	mov    %edx,%eax
  8022bb:	89 f2                	mov    %esi,%edx
  8022bd:	f7 74 24 0c          	divl   0xc(%esp)
  8022c1:	89 d6                	mov    %edx,%esi
  8022c3:	89 c3                	mov    %eax,%ebx
  8022c5:	f7 e5                	mul    %ebp
  8022c7:	39 d6                	cmp    %edx,%esi
  8022c9:	72 19                	jb     8022e4 <__udivdi3+0xfc>
  8022cb:	74 0b                	je     8022d8 <__udivdi3+0xf0>
  8022cd:	89 d8                	mov    %ebx,%eax
  8022cf:	31 ff                	xor    %edi,%edi
  8022d1:	e9 58 ff ff ff       	jmp    80222e <__udivdi3+0x46>
  8022d6:	66 90                	xchg   %ax,%ax
  8022d8:	8b 54 24 08          	mov    0x8(%esp),%edx
  8022dc:	89 f9                	mov    %edi,%ecx
  8022de:	d3 e2                	shl    %cl,%edx
  8022e0:	39 c2                	cmp    %eax,%edx
  8022e2:	73 e9                	jae    8022cd <__udivdi3+0xe5>
  8022e4:	8d 43 ff             	lea    -0x1(%ebx),%eax
  8022e7:	31 ff                	xor    %edi,%edi
  8022e9:	e9 40 ff ff ff       	jmp    80222e <__udivdi3+0x46>
  8022ee:	66 90                	xchg   %ax,%ax
  8022f0:	31 c0                	xor    %eax,%eax
  8022f2:	e9 37 ff ff ff       	jmp    80222e <__udivdi3+0x46>
  8022f7:	90                   	nop

008022f8 <__umoddi3>:
  8022f8:	55                   	push   %ebp
  8022f9:	57                   	push   %edi
  8022fa:	56                   	push   %esi
  8022fb:	53                   	push   %ebx
  8022fc:	83 ec 1c             	sub    $0x1c,%esp
  8022ff:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  802303:	8b 74 24 34          	mov    0x34(%esp),%esi
  802307:	8b 7c 24 38          	mov    0x38(%esp),%edi
  80230b:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  80230f:	89 44 24 0c          	mov    %eax,0xc(%esp)
  802313:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  802317:	89 f3                	mov    %esi,%ebx
  802319:	89 fa                	mov    %edi,%edx
  80231b:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80231f:	89 34 24             	mov    %esi,(%esp)
  802322:	85 c0                	test   %eax,%eax
  802324:	75 1a                	jne    802340 <__umoddi3+0x48>
  802326:	39 f7                	cmp    %esi,%edi
  802328:	0f 86 a2 00 00 00    	jbe    8023d0 <__umoddi3+0xd8>
  80232e:	89 c8                	mov    %ecx,%eax
  802330:	89 f2                	mov    %esi,%edx
  802332:	f7 f7                	div    %edi
  802334:	89 d0                	mov    %edx,%eax
  802336:	31 d2                	xor    %edx,%edx
  802338:	83 c4 1c             	add    $0x1c,%esp
  80233b:	5b                   	pop    %ebx
  80233c:	5e                   	pop    %esi
  80233d:	5f                   	pop    %edi
  80233e:	5d                   	pop    %ebp
  80233f:	c3                   	ret    
  802340:	39 f0                	cmp    %esi,%eax
  802342:	0f 87 ac 00 00 00    	ja     8023f4 <__umoddi3+0xfc>
  802348:	0f bd e8             	bsr    %eax,%ebp
  80234b:	83 f5 1f             	xor    $0x1f,%ebp
  80234e:	0f 84 ac 00 00 00    	je     802400 <__umoddi3+0x108>
  802354:	bf 20 00 00 00       	mov    $0x20,%edi
  802359:	29 ef                	sub    %ebp,%edi
  80235b:	89 fe                	mov    %edi,%esi
  80235d:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  802361:	89 e9                	mov    %ebp,%ecx
  802363:	d3 e0                	shl    %cl,%eax
  802365:	89 d7                	mov    %edx,%edi
  802367:	89 f1                	mov    %esi,%ecx
  802369:	d3 ef                	shr    %cl,%edi
  80236b:	09 c7                	or     %eax,%edi
  80236d:	89 e9                	mov    %ebp,%ecx
  80236f:	d3 e2                	shl    %cl,%edx
  802371:	89 14 24             	mov    %edx,(%esp)
  802374:	89 d8                	mov    %ebx,%eax
  802376:	d3 e0                	shl    %cl,%eax
  802378:	89 c2                	mov    %eax,%edx
  80237a:	8b 44 24 08          	mov    0x8(%esp),%eax
  80237e:	d3 e0                	shl    %cl,%eax
  802380:	89 44 24 04          	mov    %eax,0x4(%esp)
  802384:	8b 44 24 08          	mov    0x8(%esp),%eax
  802388:	89 f1                	mov    %esi,%ecx
  80238a:	d3 e8                	shr    %cl,%eax
  80238c:	09 d0                	or     %edx,%eax
  80238e:	d3 eb                	shr    %cl,%ebx
  802390:	89 da                	mov    %ebx,%edx
  802392:	f7 f7                	div    %edi
  802394:	89 d3                	mov    %edx,%ebx
  802396:	f7 24 24             	mull   (%esp)
  802399:	89 c6                	mov    %eax,%esi
  80239b:	89 d1                	mov    %edx,%ecx
  80239d:	39 d3                	cmp    %edx,%ebx
  80239f:	0f 82 87 00 00 00    	jb     80242c <__umoddi3+0x134>
  8023a5:	0f 84 91 00 00 00    	je     80243c <__umoddi3+0x144>
  8023ab:	8b 54 24 04          	mov    0x4(%esp),%edx
  8023af:	29 f2                	sub    %esi,%edx
  8023b1:	19 cb                	sbb    %ecx,%ebx
  8023b3:	89 d8                	mov    %ebx,%eax
  8023b5:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  8023b9:	d3 e0                	shl    %cl,%eax
  8023bb:	89 e9                	mov    %ebp,%ecx
  8023bd:	d3 ea                	shr    %cl,%edx
  8023bf:	09 d0                	or     %edx,%eax
  8023c1:	89 e9                	mov    %ebp,%ecx
  8023c3:	d3 eb                	shr    %cl,%ebx
  8023c5:	89 da                	mov    %ebx,%edx
  8023c7:	83 c4 1c             	add    $0x1c,%esp
  8023ca:	5b                   	pop    %ebx
  8023cb:	5e                   	pop    %esi
  8023cc:	5f                   	pop    %edi
  8023cd:	5d                   	pop    %ebp
  8023ce:	c3                   	ret    
  8023cf:	90                   	nop
  8023d0:	89 fd                	mov    %edi,%ebp
  8023d2:	85 ff                	test   %edi,%edi
  8023d4:	75 0b                	jne    8023e1 <__umoddi3+0xe9>
  8023d6:	b8 01 00 00 00       	mov    $0x1,%eax
  8023db:	31 d2                	xor    %edx,%edx
  8023dd:	f7 f7                	div    %edi
  8023df:	89 c5                	mov    %eax,%ebp
  8023e1:	89 f0                	mov    %esi,%eax
  8023e3:	31 d2                	xor    %edx,%edx
  8023e5:	f7 f5                	div    %ebp
  8023e7:	89 c8                	mov    %ecx,%eax
  8023e9:	f7 f5                	div    %ebp
  8023eb:	89 d0                	mov    %edx,%eax
  8023ed:	e9 44 ff ff ff       	jmp    802336 <__umoddi3+0x3e>
  8023f2:	66 90                	xchg   %ax,%ax
  8023f4:	89 c8                	mov    %ecx,%eax
  8023f6:	89 f2                	mov    %esi,%edx
  8023f8:	83 c4 1c             	add    $0x1c,%esp
  8023fb:	5b                   	pop    %ebx
  8023fc:	5e                   	pop    %esi
  8023fd:	5f                   	pop    %edi
  8023fe:	5d                   	pop    %ebp
  8023ff:	c3                   	ret    
  802400:	3b 04 24             	cmp    (%esp),%eax
  802403:	72 06                	jb     80240b <__umoddi3+0x113>
  802405:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  802409:	77 0f                	ja     80241a <__umoddi3+0x122>
  80240b:	89 f2                	mov    %esi,%edx
  80240d:	29 f9                	sub    %edi,%ecx
  80240f:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  802413:	89 14 24             	mov    %edx,(%esp)
  802416:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  80241a:	8b 44 24 04          	mov    0x4(%esp),%eax
  80241e:	8b 14 24             	mov    (%esp),%edx
  802421:	83 c4 1c             	add    $0x1c,%esp
  802424:	5b                   	pop    %ebx
  802425:	5e                   	pop    %esi
  802426:	5f                   	pop    %edi
  802427:	5d                   	pop    %ebp
  802428:	c3                   	ret    
  802429:	8d 76 00             	lea    0x0(%esi),%esi
  80242c:	2b 04 24             	sub    (%esp),%eax
  80242f:	19 fa                	sbb    %edi,%edx
  802431:	89 d1                	mov    %edx,%ecx
  802433:	89 c6                	mov    %eax,%esi
  802435:	e9 71 ff ff ff       	jmp    8023ab <__umoddi3+0xb3>
  80243a:	66 90                	xchg   %ax,%ax
  80243c:	39 44 24 04          	cmp    %eax,0x4(%esp)
  802440:	72 ea                	jb     80242c <__umoddi3+0x134>
  802442:	89 d9                	mov    %ebx,%ecx
  802444:	e9 62 ff ff ff       	jmp    8023ab <__umoddi3+0xb3>
