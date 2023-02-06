
obj/user/tst_placement_3:     file format elf32-i386


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
  800031:	e8 ac 03 00 00       	call   8003e2 <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:
/* *********************************************************** */

#include <inc/lib.h>

void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	57                   	push   %edi
  80003c:	53                   	push   %ebx
  80003d:	81 ec 70 00 00 01    	sub    $0x1000070,%esp

	char arr[PAGE_SIZE*1024*4];
	int x = 0;
  800043:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	uint32 actual_active_list[13] = {0xedbfdb78,0xeebfd000,0x803000,0x802000,0x801000,0x800000,0x205000,0x204000,0x203000,0x202000,0x201000,0x200000};
  80004a:	8d 95 a4 ff ff fe    	lea    -0x100005c(%ebp),%edx
  800050:	b9 0d 00 00 00       	mov    $0xd,%ecx
  800055:	b8 00 00 00 00       	mov    $0x0,%eax
  80005a:	89 d7                	mov    %edx,%edi
  80005c:	f3 ab                	rep stos %eax,%es:(%edi)
  80005e:	c7 85 a4 ff ff fe 78 	movl   $0xedbfdb78,-0x100005c(%ebp)
  800065:	db bf ed 
  800068:	c7 85 a8 ff ff fe 00 	movl   $0xeebfd000,-0x1000058(%ebp)
  80006f:	d0 bf ee 
  800072:	c7 85 ac ff ff fe 00 	movl   $0x803000,-0x1000054(%ebp)
  800079:	30 80 00 
  80007c:	c7 85 b0 ff ff fe 00 	movl   $0x802000,-0x1000050(%ebp)
  800083:	20 80 00 
  800086:	c7 85 b4 ff ff fe 00 	movl   $0x801000,-0x100004c(%ebp)
  80008d:	10 80 00 
  800090:	c7 85 b8 ff ff fe 00 	movl   $0x800000,-0x1000048(%ebp)
  800097:	00 80 00 
  80009a:	c7 85 bc ff ff fe 00 	movl   $0x205000,-0x1000044(%ebp)
  8000a1:	50 20 00 
  8000a4:	c7 85 c0 ff ff fe 00 	movl   $0x204000,-0x1000040(%ebp)
  8000ab:	40 20 00 
  8000ae:	c7 85 c4 ff ff fe 00 	movl   $0x203000,-0x100003c(%ebp)
  8000b5:	30 20 00 
  8000b8:	c7 85 c8 ff ff fe 00 	movl   $0x202000,-0x1000038(%ebp)
  8000bf:	20 20 00 
  8000c2:	c7 85 cc ff ff fe 00 	movl   $0x201000,-0x1000034(%ebp)
  8000c9:	10 20 00 
  8000cc:	c7 85 d0 ff ff fe 00 	movl   $0x200000,-0x1000030(%ebp)
  8000d3:	00 20 00 
	uint32 actual_second_list[7] = {};
  8000d6:	8d 95 88 ff ff fe    	lea    -0x1000078(%ebp),%edx
  8000dc:	b9 07 00 00 00       	mov    $0x7,%ecx
  8000e1:	b8 00 00 00 00       	mov    $0x0,%eax
  8000e6:	89 d7                	mov    %edx,%edi
  8000e8:	f3 ab                	rep stos %eax,%es:(%edi)
	("STEP 0: checking Initial LRU lists entries ...\n");
	{
		int check = sys_check_LRU_lists(actual_active_list, actual_second_list, 12, 0);
  8000ea:	6a 00                	push   $0x0
  8000ec:	6a 0c                	push   $0xc
  8000ee:	8d 85 88 ff ff fe    	lea    -0x1000078(%ebp),%eax
  8000f4:	50                   	push   %eax
  8000f5:	8d 85 a4 ff ff fe    	lea    -0x100005c(%ebp),%eax
  8000fb:	50                   	push   %eax
  8000fc:	e8 77 1a 00 00       	call   801b78 <sys_check_LRU_lists>
  800101:	83 c4 10             	add    $0x10,%esp
  800104:	89 45 e8             	mov    %eax,-0x18(%ebp)
		if(check == 0)
  800107:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80010b:	75 14                	jne    800121 <_main+0xe9>
			panic("INITIAL PAGE LRU LISTs entry checking failed! Review size of the LRU lists..!!");
  80010d:	83 ec 04             	sub    $0x4,%esp
  800110:	68 20 1e 80 00       	push   $0x801e20
  800115:	6a 14                	push   $0x14
  800117:	68 6f 1e 80 00       	push   $0x801e6f
  80011c:	e8 fd 03 00 00       	call   80051e <_panic>
	}

	int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800121:	e8 c2 15 00 00       	call   8016e8 <sys_pf_calculate_allocated_pages>
  800126:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	int freePages = sys_calculate_free_frames();
  800129:	e8 1a 15 00 00       	call   801648 <sys_calculate_free_frames>
  80012e:	89 45 e0             	mov    %eax,-0x20(%ebp)

	int i=0;
  800131:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for(;i<=PAGE_SIZE;i++)
  800138:	eb 11                	jmp    80014b <_main+0x113>
	{
		arr[i] = -1;
  80013a:	8d 95 d8 ff ff fe    	lea    -0x1000028(%ebp),%edx
  800140:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800143:	01 d0                	add    %edx,%eax
  800145:	c6 00 ff             	movb   $0xff,(%eax)

	int usedDiskPages = sys_pf_calculate_allocated_pages() ;
	int freePages = sys_calculate_free_frames();

	int i=0;
	for(;i<=PAGE_SIZE;i++)
  800148:	ff 45 f4             	incl   -0xc(%ebp)
  80014b:	81 7d f4 00 10 00 00 	cmpl   $0x1000,-0xc(%ebp)
  800152:	7e e6                	jle    80013a <_main+0x102>
	{
		arr[i] = -1;
	}

	i=PAGE_SIZE*1024;
  800154:	c7 45 f4 00 00 40 00 	movl   $0x400000,-0xc(%ebp)
	for(;i<=(PAGE_SIZE*1024 + PAGE_SIZE);i++)
  80015b:	eb 11                	jmp    80016e <_main+0x136>
	{
		arr[i] = -1;
  80015d:	8d 95 d8 ff ff fe    	lea    -0x1000028(%ebp),%edx
  800163:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800166:	01 d0                	add    %edx,%eax
  800168:	c6 00 ff             	movb   $0xff,(%eax)
	{
		arr[i] = -1;
	}

	i=PAGE_SIZE*1024;
	for(;i<=(PAGE_SIZE*1024 + PAGE_SIZE);i++)
  80016b:	ff 45 f4             	incl   -0xc(%ebp)
  80016e:	81 7d f4 00 10 40 00 	cmpl   $0x401000,-0xc(%ebp)
  800175:	7e e6                	jle    80015d <_main+0x125>
	{
		arr[i] = -1;
	}

	i=PAGE_SIZE*1024*2;
  800177:	c7 45 f4 00 00 80 00 	movl   $0x800000,-0xc(%ebp)
	for(;i<=(PAGE_SIZE*1024*2 + PAGE_SIZE);i++)
  80017e:	eb 11                	jmp    800191 <_main+0x159>
	{
		arr[i] = -1;
  800180:	8d 95 d8 ff ff fe    	lea    -0x1000028(%ebp),%edx
  800186:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800189:	01 d0                	add    %edx,%eax
  80018b:	c6 00 ff             	movb   $0xff,(%eax)
	{
		arr[i] = -1;
	}

	i=PAGE_SIZE*1024*2;
	for(;i<=(PAGE_SIZE*1024*2 + PAGE_SIZE);i++)
  80018e:	ff 45 f4             	incl   -0xc(%ebp)
  800191:	81 7d f4 00 10 80 00 	cmpl   $0x801000,-0xc(%ebp)
  800198:	7e e6                	jle    800180 <_main+0x148>
	{
		arr[i] = -1;
	}

	uint32* secondlistVA= (uint32*)0x200000;
  80019a:	c7 45 dc 00 00 20 00 	movl   $0x200000,-0x24(%ebp)
	x = x + *secondlistVA;
  8001a1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001a4:	8b 10                	mov    (%eax),%edx
  8001a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001a9:	01 d0                	add    %edx,%eax
  8001ab:	89 45 ec             	mov    %eax,-0x14(%ebp)
	secondlistVA = (uint32*) 0x202000;
  8001ae:	c7 45 dc 00 20 20 00 	movl   $0x202000,-0x24(%ebp)
	x = x + *secondlistVA;
  8001b5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8001b8:	8b 10                	mov    (%eax),%edx
  8001ba:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8001bd:	01 d0                	add    %edx,%eax
  8001bf:	89 45 ec             	mov    %eax,-0x14(%ebp)

	actual_second_list[0]=0X205000;
  8001c2:	c7 85 88 ff ff fe 00 	movl   $0x205000,-0x1000078(%ebp)
  8001c9:	50 20 00 
	actual_second_list[1]=0X204000;
  8001cc:	c7 85 8c ff ff fe 00 	movl   $0x204000,-0x1000074(%ebp)
  8001d3:	40 20 00 
	actual_second_list[2]=0x203000;
  8001d6:	c7 85 90 ff ff fe 00 	movl   $0x203000,-0x1000070(%ebp)
  8001dd:	30 20 00 
	actual_second_list[3]=0x201000;
  8001e0:	c7 85 94 ff ff fe 00 	movl   $0x201000,-0x100006c(%ebp)
  8001e7:	10 20 00 
	for (int i=12;i>6;i--)
  8001ea:	c7 45 f0 0c 00 00 00 	movl   $0xc,-0x10(%ebp)
  8001f1:	eb 1a                	jmp    80020d <_main+0x1d5>
		actual_active_list[i]=actual_active_list[i-7];
  8001f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8001f6:	83 e8 07             	sub    $0x7,%eax
  8001f9:	8b 94 85 a4 ff ff fe 	mov    -0x100005c(%ebp,%eax,4),%edx
  800200:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800203:	89 94 85 a4 ff ff fe 	mov    %edx,-0x100005c(%ebp,%eax,4)

	actual_second_list[0]=0X205000;
	actual_second_list[1]=0X204000;
	actual_second_list[2]=0x203000;
	actual_second_list[3]=0x201000;
	for (int i=12;i>6;i--)
  80020a:	ff 4d f0             	decl   -0x10(%ebp)
  80020d:	83 7d f0 06          	cmpl   $0x6,-0x10(%ebp)
  800211:	7f e0                	jg     8001f3 <_main+0x1bb>
		actual_active_list[i]=actual_active_list[i-7];

	actual_active_list[0]=0x202000;
  800213:	c7 85 a4 ff ff fe 00 	movl   $0x202000,-0x100005c(%ebp)
  80021a:	20 20 00 
	actual_active_list[1]=0x200000;
  80021d:	c7 85 a8 ff ff fe 00 	movl   $0x200000,-0x1000058(%ebp)
  800224:	00 20 00 
	actual_active_list[2]=0xee3fe000;
  800227:	c7 85 ac ff ff fe 00 	movl   $0xee3fe000,-0x1000054(%ebp)
  80022e:	e0 3f ee 
	actual_active_list[3]=0xee3fdfa0;
  800231:	c7 85 b0 ff ff fe a0 	movl   $0xee3fdfa0,-0x1000050(%ebp)
  800238:	df 3f ee 
	actual_active_list[4]=0xedffe000;
  80023b:	c7 85 b4 ff ff fe 00 	movl   $0xedffe000,-0x100004c(%ebp)
  800242:	e0 ff ed 
	actual_active_list[5]=0xedffdfa0;
  800245:	c7 85 b8 ff ff fe a0 	movl   $0xedffdfa0,-0x1000048(%ebp)
  80024c:	df ff ed 
	actual_active_list[6]=0xedbfe000;
  80024f:	c7 85 bc ff ff fe 00 	movl   $0xedbfe000,-0x1000044(%ebp)
  800256:	e0 bf ed 

	cprintf("STEP A: checking PLACEMENT fault handling ... \n");
  800259:	83 ec 0c             	sub    $0xc,%esp
  80025c:	68 88 1e 80 00       	push   $0x801e88
  800261:	e8 6c 05 00 00       	call   8007d2 <cprintf>
  800266:	83 c4 10             	add    $0x10,%esp
	{
		if( arr[0] !=  -1)  panic("PLACEMENT of stack page failed");
  800269:	8a 85 d8 ff ff fe    	mov    -0x1000028(%ebp),%al
  80026f:	3c ff                	cmp    $0xff,%al
  800271:	74 14                	je     800287 <_main+0x24f>
  800273:	83 ec 04             	sub    $0x4,%esp
  800276:	68 b8 1e 80 00       	push   $0x801eb8
  80027b:	6a 42                	push   $0x42
  80027d:	68 6f 1e 80 00       	push   $0x801e6f
  800282:	e8 97 02 00 00       	call   80051e <_panic>
		if( arr[PAGE_SIZE] !=  -1)  panic("PLACEMENT of stack page failed");
  800287:	8a 85 d8 0f 00 ff    	mov    -0xfff028(%ebp),%al
  80028d:	3c ff                	cmp    $0xff,%al
  80028f:	74 14                	je     8002a5 <_main+0x26d>
  800291:	83 ec 04             	sub    $0x4,%esp
  800294:	68 b8 1e 80 00       	push   $0x801eb8
  800299:	6a 43                	push   $0x43
  80029b:	68 6f 1e 80 00       	push   $0x801e6f
  8002a0:	e8 79 02 00 00       	call   80051e <_panic>

		if( arr[PAGE_SIZE*1024] !=  -1)  panic("PLACEMENT of stack page failed");
  8002a5:	8a 85 d8 ff 3f ff    	mov    -0xc00028(%ebp),%al
  8002ab:	3c ff                	cmp    $0xff,%al
  8002ad:	74 14                	je     8002c3 <_main+0x28b>
  8002af:	83 ec 04             	sub    $0x4,%esp
  8002b2:	68 b8 1e 80 00       	push   $0x801eb8
  8002b7:	6a 45                	push   $0x45
  8002b9:	68 6f 1e 80 00       	push   $0x801e6f
  8002be:	e8 5b 02 00 00       	call   80051e <_panic>
		if( arr[PAGE_SIZE*1025] !=  -1)  panic("PLACEMENT of stack page failed");
  8002c3:	8a 85 d8 0f 40 ff    	mov    -0xbff028(%ebp),%al
  8002c9:	3c ff                	cmp    $0xff,%al
  8002cb:	74 14                	je     8002e1 <_main+0x2a9>
  8002cd:	83 ec 04             	sub    $0x4,%esp
  8002d0:	68 b8 1e 80 00       	push   $0x801eb8
  8002d5:	6a 46                	push   $0x46
  8002d7:	68 6f 1e 80 00       	push   $0x801e6f
  8002dc:	e8 3d 02 00 00       	call   80051e <_panic>

		if( arr[PAGE_SIZE*1024*2] !=  -1)  panic("PLACEMENT of stack page failed");
  8002e1:	8a 85 d8 ff 7f ff    	mov    -0x800028(%ebp),%al
  8002e7:	3c ff                	cmp    $0xff,%al
  8002e9:	74 14                	je     8002ff <_main+0x2c7>
  8002eb:	83 ec 04             	sub    $0x4,%esp
  8002ee:	68 b8 1e 80 00       	push   $0x801eb8
  8002f3:	6a 48                	push   $0x48
  8002f5:	68 6f 1e 80 00       	push   $0x801e6f
  8002fa:	e8 1f 02 00 00       	call   80051e <_panic>
		if( arr[PAGE_SIZE*1024*2 + PAGE_SIZE] !=  -1)  panic("PLACEMENT of stack page failed");
  8002ff:	8a 85 d8 0f 80 ff    	mov    -0x7ff028(%ebp),%al
  800305:	3c ff                	cmp    $0xff,%al
  800307:	74 14                	je     80031d <_main+0x2e5>
  800309:	83 ec 04             	sub    $0x4,%esp
  80030c:	68 b8 1e 80 00       	push   $0x801eb8
  800311:	6a 49                	push   $0x49
  800313:	68 6f 1e 80 00       	push   $0x801e6f
  800318:	e8 01 02 00 00       	call   80051e <_panic>

		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  5) panic("new stack pages are not written to Page File");
  80031d:	e8 c6 13 00 00       	call   8016e8 <sys_pf_calculate_allocated_pages>
  800322:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  800325:	83 f8 05             	cmp    $0x5,%eax
  800328:	74 14                	je     80033e <_main+0x306>
  80032a:	83 ec 04             	sub    $0x4,%esp
  80032d:	68 d8 1e 80 00       	push   $0x801ed8
  800332:	6a 4b                	push   $0x4b
  800334:	68 6f 1e 80 00       	push   $0x801e6f
  800339:	e8 e0 01 00 00       	call   80051e <_panic>

		if( (freePages - sys_calculate_free_frames() ) != 9 ) panic("allocated memory size incorrect");
  80033e:	8b 5d e0             	mov    -0x20(%ebp),%ebx
  800341:	e8 02 13 00 00       	call   801648 <sys_calculate_free_frames>
  800346:	29 c3                	sub    %eax,%ebx
  800348:	89 d8                	mov    %ebx,%eax
  80034a:	83 f8 09             	cmp    $0x9,%eax
  80034d:	74 14                	je     800363 <_main+0x32b>
  80034f:	83 ec 04             	sub    $0x4,%esp
  800352:	68 08 1f 80 00       	push   $0x801f08
  800357:	6a 4d                	push   $0x4d
  800359:	68 6f 1e 80 00       	push   $0x801e6f
  80035e:	e8 bb 01 00 00       	call   80051e <_panic>
	}
	cprintf("STEP A passed: PLACEMENT fault handling works!\n\n\n");
  800363:	83 ec 0c             	sub    $0xc,%esp
  800366:	68 28 1f 80 00       	push   $0x801f28
  80036b:	e8 62 04 00 00       	call   8007d2 <cprintf>
  800370:	83 c4 10             	add    $0x10,%esp

	cprintf("STEP B: checking LRU lists entries After Required PAGES IN SECOND LIST...\n");
  800373:	83 ec 0c             	sub    $0xc,%esp
  800376:	68 5c 1f 80 00       	push   $0x801f5c
  80037b:	e8 52 04 00 00       	call   8007d2 <cprintf>
  800380:	83 c4 10             	add    $0x10,%esp
	{
		int check = sys_check_LRU_lists(actual_active_list, actual_second_list, 13, 4);
  800383:	6a 04                	push   $0x4
  800385:	6a 0d                	push   $0xd
  800387:	8d 85 88 ff ff fe    	lea    -0x1000078(%ebp),%eax
  80038d:	50                   	push   %eax
  80038e:	8d 85 a4 ff ff fe    	lea    -0x100005c(%ebp),%eax
  800394:	50                   	push   %eax
  800395:	e8 de 17 00 00       	call   801b78 <sys_check_LRU_lists>
  80039a:	83 c4 10             	add    $0x10,%esp
  80039d:	89 45 d8             	mov    %eax,-0x28(%ebp)
			if(check == 0)
  8003a0:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  8003a4:	75 14                	jne    8003ba <_main+0x382>
				panic("LRU lists entries are not correct, check your logic again!!");
  8003a6:	83 ec 04             	sub    $0x4,%esp
  8003a9:	68 a8 1f 80 00       	push   $0x801fa8
  8003ae:	6a 55                	push   $0x55
  8003b0:	68 6f 1e 80 00       	push   $0x801e6f
  8003b5:	e8 64 01 00 00       	call   80051e <_panic>
	}
	cprintf("STEP B passed: checking LRU lists entries After Required PAGES IN SECOND LIST test are correct\n\n\n");
  8003ba:	83 ec 0c             	sub    $0xc,%esp
  8003bd:	68 e4 1f 80 00       	push   $0x801fe4
  8003c2:	e8 0b 04 00 00       	call   8007d2 <cprintf>
  8003c7:	83 c4 10             	add    $0x10,%esp
	cprintf("Congratulations!! Test of PAGE PLACEMENT THIRD SCENARIO completed successfully!!\n\n\n");
  8003ca:	83 ec 0c             	sub    $0xc,%esp
  8003cd:	68 48 20 80 00       	push   $0x802048
  8003d2:	e8 fb 03 00 00       	call   8007d2 <cprintf>
  8003d7:	83 c4 10             	add    $0x10,%esp
	return;
  8003da:	90                   	nop
}
  8003db:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8003de:	5b                   	pop    %ebx
  8003df:	5f                   	pop    %edi
  8003e0:	5d                   	pop    %ebp
  8003e1:	c3                   	ret    

008003e2 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8003e2:	55                   	push   %ebp
  8003e3:	89 e5                	mov    %esp,%ebp
  8003e5:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8003e8:	e8 3b 15 00 00       	call   801928 <sys_getenvindex>
  8003ed:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8003f0:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8003f3:	89 d0                	mov    %edx,%eax
  8003f5:	c1 e0 03             	shl    $0x3,%eax
  8003f8:	01 d0                	add    %edx,%eax
  8003fa:	01 c0                	add    %eax,%eax
  8003fc:	01 d0                	add    %edx,%eax
  8003fe:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  800405:	01 d0                	add    %edx,%eax
  800407:	c1 e0 04             	shl    $0x4,%eax
  80040a:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  80040f:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  800414:	a1 20 30 80 00       	mov    0x803020,%eax
  800419:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  80041f:	84 c0                	test   %al,%al
  800421:	74 0f                	je     800432 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800423:	a1 20 30 80 00       	mov    0x803020,%eax
  800428:	05 5c 05 00 00       	add    $0x55c,%eax
  80042d:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800432:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800436:	7e 0a                	jle    800442 <libmain+0x60>
		binaryname = argv[0];
  800438:	8b 45 0c             	mov    0xc(%ebp),%eax
  80043b:	8b 00                	mov    (%eax),%eax
  80043d:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800442:	83 ec 08             	sub    $0x8,%esp
  800445:	ff 75 0c             	pushl  0xc(%ebp)
  800448:	ff 75 08             	pushl  0x8(%ebp)
  80044b:	e8 e8 fb ff ff       	call   800038 <_main>
  800450:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800453:	e8 dd 12 00 00       	call   801735 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800458:	83 ec 0c             	sub    $0xc,%esp
  80045b:	68 b4 20 80 00       	push   $0x8020b4
  800460:	e8 6d 03 00 00       	call   8007d2 <cprintf>
  800465:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800468:	a1 20 30 80 00       	mov    0x803020,%eax
  80046d:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800473:	a1 20 30 80 00       	mov    0x803020,%eax
  800478:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  80047e:	83 ec 04             	sub    $0x4,%esp
  800481:	52                   	push   %edx
  800482:	50                   	push   %eax
  800483:	68 dc 20 80 00       	push   $0x8020dc
  800488:	e8 45 03 00 00       	call   8007d2 <cprintf>
  80048d:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800490:	a1 20 30 80 00       	mov    0x803020,%eax
  800495:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  80049b:	a1 20 30 80 00       	mov    0x803020,%eax
  8004a0:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  8004a6:	a1 20 30 80 00       	mov    0x803020,%eax
  8004ab:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  8004b1:	51                   	push   %ecx
  8004b2:	52                   	push   %edx
  8004b3:	50                   	push   %eax
  8004b4:	68 04 21 80 00       	push   $0x802104
  8004b9:	e8 14 03 00 00       	call   8007d2 <cprintf>
  8004be:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8004c1:	a1 20 30 80 00       	mov    0x803020,%eax
  8004c6:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8004cc:	83 ec 08             	sub    $0x8,%esp
  8004cf:	50                   	push   %eax
  8004d0:	68 5c 21 80 00       	push   $0x80215c
  8004d5:	e8 f8 02 00 00       	call   8007d2 <cprintf>
  8004da:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8004dd:	83 ec 0c             	sub    $0xc,%esp
  8004e0:	68 b4 20 80 00       	push   $0x8020b4
  8004e5:	e8 e8 02 00 00       	call   8007d2 <cprintf>
  8004ea:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8004ed:	e8 5d 12 00 00       	call   80174f <sys_enable_interrupt>

	// exit gracefully
	exit();
  8004f2:	e8 19 00 00 00       	call   800510 <exit>
}
  8004f7:	90                   	nop
  8004f8:	c9                   	leave  
  8004f9:	c3                   	ret    

008004fa <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8004fa:	55                   	push   %ebp
  8004fb:	89 e5                	mov    %esp,%ebp
  8004fd:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800500:	83 ec 0c             	sub    $0xc,%esp
  800503:	6a 00                	push   $0x0
  800505:	e8 ea 13 00 00       	call   8018f4 <sys_destroy_env>
  80050a:	83 c4 10             	add    $0x10,%esp
}
  80050d:	90                   	nop
  80050e:	c9                   	leave  
  80050f:	c3                   	ret    

00800510 <exit>:

void
exit(void)
{
  800510:	55                   	push   %ebp
  800511:	89 e5                	mov    %esp,%ebp
  800513:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  800516:	e8 3f 14 00 00       	call   80195a <sys_exit_env>
}
  80051b:	90                   	nop
  80051c:	c9                   	leave  
  80051d:	c3                   	ret    

0080051e <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  80051e:	55                   	push   %ebp
  80051f:	89 e5                	mov    %esp,%ebp
  800521:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800524:	8d 45 10             	lea    0x10(%ebp),%eax
  800527:	83 c0 04             	add    $0x4,%eax
  80052a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  80052d:	a1 5c 31 80 00       	mov    0x80315c,%eax
  800532:	85 c0                	test   %eax,%eax
  800534:	74 16                	je     80054c <_panic+0x2e>
		cprintf("%s: ", argv0);
  800536:	a1 5c 31 80 00       	mov    0x80315c,%eax
  80053b:	83 ec 08             	sub    $0x8,%esp
  80053e:	50                   	push   %eax
  80053f:	68 70 21 80 00       	push   $0x802170
  800544:	e8 89 02 00 00       	call   8007d2 <cprintf>
  800549:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  80054c:	a1 00 30 80 00       	mov    0x803000,%eax
  800551:	ff 75 0c             	pushl  0xc(%ebp)
  800554:	ff 75 08             	pushl  0x8(%ebp)
  800557:	50                   	push   %eax
  800558:	68 75 21 80 00       	push   $0x802175
  80055d:	e8 70 02 00 00       	call   8007d2 <cprintf>
  800562:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800565:	8b 45 10             	mov    0x10(%ebp),%eax
  800568:	83 ec 08             	sub    $0x8,%esp
  80056b:	ff 75 f4             	pushl  -0xc(%ebp)
  80056e:	50                   	push   %eax
  80056f:	e8 f3 01 00 00       	call   800767 <vcprintf>
  800574:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800577:	83 ec 08             	sub    $0x8,%esp
  80057a:	6a 00                	push   $0x0
  80057c:	68 91 21 80 00       	push   $0x802191
  800581:	e8 e1 01 00 00       	call   800767 <vcprintf>
  800586:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800589:	e8 82 ff ff ff       	call   800510 <exit>

	// should not return here
	while (1) ;
  80058e:	eb fe                	jmp    80058e <_panic+0x70>

00800590 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800590:	55                   	push   %ebp
  800591:	89 e5                	mov    %esp,%ebp
  800593:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800596:	a1 20 30 80 00       	mov    0x803020,%eax
  80059b:	8b 50 74             	mov    0x74(%eax),%edx
  80059e:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005a1:	39 c2                	cmp    %eax,%edx
  8005a3:	74 14                	je     8005b9 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  8005a5:	83 ec 04             	sub    $0x4,%esp
  8005a8:	68 94 21 80 00       	push   $0x802194
  8005ad:	6a 26                	push   $0x26
  8005af:	68 e0 21 80 00       	push   $0x8021e0
  8005b4:	e8 65 ff ff ff       	call   80051e <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  8005b9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8005c0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8005c7:	e9 c2 00 00 00       	jmp    80068e <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8005cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005cf:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d9:	01 d0                	add    %edx,%eax
  8005db:	8b 00                	mov    (%eax),%eax
  8005dd:	85 c0                	test   %eax,%eax
  8005df:	75 08                	jne    8005e9 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8005e1:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8005e4:	e9 a2 00 00 00       	jmp    80068b <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8005e9:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005f0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8005f7:	eb 69                	jmp    800662 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8005f9:	a1 20 30 80 00       	mov    0x803020,%eax
  8005fe:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800604:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800607:	89 d0                	mov    %edx,%eax
  800609:	01 c0                	add    %eax,%eax
  80060b:	01 d0                	add    %edx,%eax
  80060d:	c1 e0 03             	shl    $0x3,%eax
  800610:	01 c8                	add    %ecx,%eax
  800612:	8a 40 04             	mov    0x4(%eax),%al
  800615:	84 c0                	test   %al,%al
  800617:	75 46                	jne    80065f <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800619:	a1 20 30 80 00       	mov    0x803020,%eax
  80061e:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800624:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800627:	89 d0                	mov    %edx,%eax
  800629:	01 c0                	add    %eax,%eax
  80062b:	01 d0                	add    %edx,%eax
  80062d:	c1 e0 03             	shl    $0x3,%eax
  800630:	01 c8                	add    %ecx,%eax
  800632:	8b 00                	mov    (%eax),%eax
  800634:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800637:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80063a:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80063f:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800641:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800644:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  80064b:	8b 45 08             	mov    0x8(%ebp),%eax
  80064e:	01 c8                	add    %ecx,%eax
  800650:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800652:	39 c2                	cmp    %eax,%edx
  800654:	75 09                	jne    80065f <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800656:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  80065d:	eb 12                	jmp    800671 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80065f:	ff 45 e8             	incl   -0x18(%ebp)
  800662:	a1 20 30 80 00       	mov    0x803020,%eax
  800667:	8b 50 74             	mov    0x74(%eax),%edx
  80066a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80066d:	39 c2                	cmp    %eax,%edx
  80066f:	77 88                	ja     8005f9 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800671:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800675:	75 14                	jne    80068b <CheckWSWithoutLastIndex+0xfb>
			panic(
  800677:	83 ec 04             	sub    $0x4,%esp
  80067a:	68 ec 21 80 00       	push   $0x8021ec
  80067f:	6a 3a                	push   $0x3a
  800681:	68 e0 21 80 00       	push   $0x8021e0
  800686:	e8 93 fe ff ff       	call   80051e <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  80068b:	ff 45 f0             	incl   -0x10(%ebp)
  80068e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800691:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800694:	0f 8c 32 ff ff ff    	jl     8005cc <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80069a:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8006a1:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  8006a8:	eb 26                	jmp    8006d0 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  8006aa:	a1 20 30 80 00       	mov    0x803020,%eax
  8006af:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8006b5:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8006b8:	89 d0                	mov    %edx,%eax
  8006ba:	01 c0                	add    %eax,%eax
  8006bc:	01 d0                	add    %edx,%eax
  8006be:	c1 e0 03             	shl    $0x3,%eax
  8006c1:	01 c8                	add    %ecx,%eax
  8006c3:	8a 40 04             	mov    0x4(%eax),%al
  8006c6:	3c 01                	cmp    $0x1,%al
  8006c8:	75 03                	jne    8006cd <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8006ca:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8006cd:	ff 45 e0             	incl   -0x20(%ebp)
  8006d0:	a1 20 30 80 00       	mov    0x803020,%eax
  8006d5:	8b 50 74             	mov    0x74(%eax),%edx
  8006d8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006db:	39 c2                	cmp    %eax,%edx
  8006dd:	77 cb                	ja     8006aa <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8006df:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006e2:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8006e5:	74 14                	je     8006fb <CheckWSWithoutLastIndex+0x16b>
		panic(
  8006e7:	83 ec 04             	sub    $0x4,%esp
  8006ea:	68 40 22 80 00       	push   $0x802240
  8006ef:	6a 44                	push   $0x44
  8006f1:	68 e0 21 80 00       	push   $0x8021e0
  8006f6:	e8 23 fe ff ff       	call   80051e <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8006fb:	90                   	nop
  8006fc:	c9                   	leave  
  8006fd:	c3                   	ret    

008006fe <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8006fe:	55                   	push   %ebp
  8006ff:	89 e5                	mov    %esp,%ebp
  800701:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800704:	8b 45 0c             	mov    0xc(%ebp),%eax
  800707:	8b 00                	mov    (%eax),%eax
  800709:	8d 48 01             	lea    0x1(%eax),%ecx
  80070c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80070f:	89 0a                	mov    %ecx,(%edx)
  800711:	8b 55 08             	mov    0x8(%ebp),%edx
  800714:	88 d1                	mov    %dl,%cl
  800716:	8b 55 0c             	mov    0xc(%ebp),%edx
  800719:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  80071d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800720:	8b 00                	mov    (%eax),%eax
  800722:	3d ff 00 00 00       	cmp    $0xff,%eax
  800727:	75 2c                	jne    800755 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  800729:	a0 24 30 80 00       	mov    0x803024,%al
  80072e:	0f b6 c0             	movzbl %al,%eax
  800731:	8b 55 0c             	mov    0xc(%ebp),%edx
  800734:	8b 12                	mov    (%edx),%edx
  800736:	89 d1                	mov    %edx,%ecx
  800738:	8b 55 0c             	mov    0xc(%ebp),%edx
  80073b:	83 c2 08             	add    $0x8,%edx
  80073e:	83 ec 04             	sub    $0x4,%esp
  800741:	50                   	push   %eax
  800742:	51                   	push   %ecx
  800743:	52                   	push   %edx
  800744:	e8 3e 0e 00 00       	call   801587 <sys_cputs>
  800749:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  80074c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80074f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800755:	8b 45 0c             	mov    0xc(%ebp),%eax
  800758:	8b 40 04             	mov    0x4(%eax),%eax
  80075b:	8d 50 01             	lea    0x1(%eax),%edx
  80075e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800761:	89 50 04             	mov    %edx,0x4(%eax)
}
  800764:	90                   	nop
  800765:	c9                   	leave  
  800766:	c3                   	ret    

00800767 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800767:	55                   	push   %ebp
  800768:	89 e5                	mov    %esp,%ebp
  80076a:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800770:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800777:	00 00 00 
	b.cnt = 0;
  80077a:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800781:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800784:	ff 75 0c             	pushl  0xc(%ebp)
  800787:	ff 75 08             	pushl  0x8(%ebp)
  80078a:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800790:	50                   	push   %eax
  800791:	68 fe 06 80 00       	push   $0x8006fe
  800796:	e8 11 02 00 00       	call   8009ac <vprintfmt>
  80079b:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  80079e:	a0 24 30 80 00       	mov    0x803024,%al
  8007a3:	0f b6 c0             	movzbl %al,%eax
  8007a6:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  8007ac:	83 ec 04             	sub    $0x4,%esp
  8007af:	50                   	push   %eax
  8007b0:	52                   	push   %edx
  8007b1:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  8007b7:	83 c0 08             	add    $0x8,%eax
  8007ba:	50                   	push   %eax
  8007bb:	e8 c7 0d 00 00       	call   801587 <sys_cputs>
  8007c0:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8007c3:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  8007ca:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8007d0:	c9                   	leave  
  8007d1:	c3                   	ret    

008007d2 <cprintf>:

int cprintf(const char *fmt, ...) {
  8007d2:	55                   	push   %ebp
  8007d3:	89 e5                	mov    %esp,%ebp
  8007d5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8007d8:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  8007df:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007e2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e8:	83 ec 08             	sub    $0x8,%esp
  8007eb:	ff 75 f4             	pushl  -0xc(%ebp)
  8007ee:	50                   	push   %eax
  8007ef:	e8 73 ff ff ff       	call   800767 <vcprintf>
  8007f4:	83 c4 10             	add    $0x10,%esp
  8007f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8007fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007fd:	c9                   	leave  
  8007fe:	c3                   	ret    

008007ff <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8007ff:	55                   	push   %ebp
  800800:	89 e5                	mov    %esp,%ebp
  800802:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  800805:	e8 2b 0f 00 00       	call   801735 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80080a:	8d 45 0c             	lea    0xc(%ebp),%eax
  80080d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  800810:	8b 45 08             	mov    0x8(%ebp),%eax
  800813:	83 ec 08             	sub    $0x8,%esp
  800816:	ff 75 f4             	pushl  -0xc(%ebp)
  800819:	50                   	push   %eax
  80081a:	e8 48 ff ff ff       	call   800767 <vcprintf>
  80081f:	83 c4 10             	add    $0x10,%esp
  800822:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800825:	e8 25 0f 00 00       	call   80174f <sys_enable_interrupt>
	return cnt;
  80082a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80082d:	c9                   	leave  
  80082e:	c3                   	ret    

0080082f <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  80082f:	55                   	push   %ebp
  800830:	89 e5                	mov    %esp,%ebp
  800832:	53                   	push   %ebx
  800833:	83 ec 14             	sub    $0x14,%esp
  800836:	8b 45 10             	mov    0x10(%ebp),%eax
  800839:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80083c:	8b 45 14             	mov    0x14(%ebp),%eax
  80083f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800842:	8b 45 18             	mov    0x18(%ebp),%eax
  800845:	ba 00 00 00 00       	mov    $0x0,%edx
  80084a:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80084d:	77 55                	ja     8008a4 <printnum+0x75>
  80084f:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800852:	72 05                	jb     800859 <printnum+0x2a>
  800854:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800857:	77 4b                	ja     8008a4 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800859:	8b 45 1c             	mov    0x1c(%ebp),%eax
  80085c:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80085f:	8b 45 18             	mov    0x18(%ebp),%eax
  800862:	ba 00 00 00 00       	mov    $0x0,%edx
  800867:	52                   	push   %edx
  800868:	50                   	push   %eax
  800869:	ff 75 f4             	pushl  -0xc(%ebp)
  80086c:	ff 75 f0             	pushl  -0x10(%ebp)
  80086f:	e8 48 13 00 00       	call   801bbc <__udivdi3>
  800874:	83 c4 10             	add    $0x10,%esp
  800877:	83 ec 04             	sub    $0x4,%esp
  80087a:	ff 75 20             	pushl  0x20(%ebp)
  80087d:	53                   	push   %ebx
  80087e:	ff 75 18             	pushl  0x18(%ebp)
  800881:	52                   	push   %edx
  800882:	50                   	push   %eax
  800883:	ff 75 0c             	pushl  0xc(%ebp)
  800886:	ff 75 08             	pushl  0x8(%ebp)
  800889:	e8 a1 ff ff ff       	call   80082f <printnum>
  80088e:	83 c4 20             	add    $0x20,%esp
  800891:	eb 1a                	jmp    8008ad <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800893:	83 ec 08             	sub    $0x8,%esp
  800896:	ff 75 0c             	pushl  0xc(%ebp)
  800899:	ff 75 20             	pushl  0x20(%ebp)
  80089c:	8b 45 08             	mov    0x8(%ebp),%eax
  80089f:	ff d0                	call   *%eax
  8008a1:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  8008a4:	ff 4d 1c             	decl   0x1c(%ebp)
  8008a7:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8008ab:	7f e6                	jg     800893 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  8008ad:	8b 4d 18             	mov    0x18(%ebp),%ecx
  8008b0:	bb 00 00 00 00       	mov    $0x0,%ebx
  8008b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008bb:	53                   	push   %ebx
  8008bc:	51                   	push   %ecx
  8008bd:	52                   	push   %edx
  8008be:	50                   	push   %eax
  8008bf:	e8 08 14 00 00       	call   801ccc <__umoddi3>
  8008c4:	83 c4 10             	add    $0x10,%esp
  8008c7:	05 b4 24 80 00       	add    $0x8024b4,%eax
  8008cc:	8a 00                	mov    (%eax),%al
  8008ce:	0f be c0             	movsbl %al,%eax
  8008d1:	83 ec 08             	sub    $0x8,%esp
  8008d4:	ff 75 0c             	pushl  0xc(%ebp)
  8008d7:	50                   	push   %eax
  8008d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008db:	ff d0                	call   *%eax
  8008dd:	83 c4 10             	add    $0x10,%esp
}
  8008e0:	90                   	nop
  8008e1:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008e4:	c9                   	leave  
  8008e5:	c3                   	ret    

008008e6 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008e6:	55                   	push   %ebp
  8008e7:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008e9:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008ed:	7e 1c                	jle    80090b <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8008ef:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f2:	8b 00                	mov    (%eax),%eax
  8008f4:	8d 50 08             	lea    0x8(%eax),%edx
  8008f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fa:	89 10                	mov    %edx,(%eax)
  8008fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ff:	8b 00                	mov    (%eax),%eax
  800901:	83 e8 08             	sub    $0x8,%eax
  800904:	8b 50 04             	mov    0x4(%eax),%edx
  800907:	8b 00                	mov    (%eax),%eax
  800909:	eb 40                	jmp    80094b <getuint+0x65>
	else if (lflag)
  80090b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80090f:	74 1e                	je     80092f <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800911:	8b 45 08             	mov    0x8(%ebp),%eax
  800914:	8b 00                	mov    (%eax),%eax
  800916:	8d 50 04             	lea    0x4(%eax),%edx
  800919:	8b 45 08             	mov    0x8(%ebp),%eax
  80091c:	89 10                	mov    %edx,(%eax)
  80091e:	8b 45 08             	mov    0x8(%ebp),%eax
  800921:	8b 00                	mov    (%eax),%eax
  800923:	83 e8 04             	sub    $0x4,%eax
  800926:	8b 00                	mov    (%eax),%eax
  800928:	ba 00 00 00 00       	mov    $0x0,%edx
  80092d:	eb 1c                	jmp    80094b <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  80092f:	8b 45 08             	mov    0x8(%ebp),%eax
  800932:	8b 00                	mov    (%eax),%eax
  800934:	8d 50 04             	lea    0x4(%eax),%edx
  800937:	8b 45 08             	mov    0x8(%ebp),%eax
  80093a:	89 10                	mov    %edx,(%eax)
  80093c:	8b 45 08             	mov    0x8(%ebp),%eax
  80093f:	8b 00                	mov    (%eax),%eax
  800941:	83 e8 04             	sub    $0x4,%eax
  800944:	8b 00                	mov    (%eax),%eax
  800946:	ba 00 00 00 00       	mov    $0x0,%edx
}
  80094b:	5d                   	pop    %ebp
  80094c:	c3                   	ret    

0080094d <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  80094d:	55                   	push   %ebp
  80094e:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800950:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800954:	7e 1c                	jle    800972 <getint+0x25>
		return va_arg(*ap, long long);
  800956:	8b 45 08             	mov    0x8(%ebp),%eax
  800959:	8b 00                	mov    (%eax),%eax
  80095b:	8d 50 08             	lea    0x8(%eax),%edx
  80095e:	8b 45 08             	mov    0x8(%ebp),%eax
  800961:	89 10                	mov    %edx,(%eax)
  800963:	8b 45 08             	mov    0x8(%ebp),%eax
  800966:	8b 00                	mov    (%eax),%eax
  800968:	83 e8 08             	sub    $0x8,%eax
  80096b:	8b 50 04             	mov    0x4(%eax),%edx
  80096e:	8b 00                	mov    (%eax),%eax
  800970:	eb 38                	jmp    8009aa <getint+0x5d>
	else if (lflag)
  800972:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800976:	74 1a                	je     800992 <getint+0x45>
		return va_arg(*ap, long);
  800978:	8b 45 08             	mov    0x8(%ebp),%eax
  80097b:	8b 00                	mov    (%eax),%eax
  80097d:	8d 50 04             	lea    0x4(%eax),%edx
  800980:	8b 45 08             	mov    0x8(%ebp),%eax
  800983:	89 10                	mov    %edx,(%eax)
  800985:	8b 45 08             	mov    0x8(%ebp),%eax
  800988:	8b 00                	mov    (%eax),%eax
  80098a:	83 e8 04             	sub    $0x4,%eax
  80098d:	8b 00                	mov    (%eax),%eax
  80098f:	99                   	cltd   
  800990:	eb 18                	jmp    8009aa <getint+0x5d>
	else
		return va_arg(*ap, int);
  800992:	8b 45 08             	mov    0x8(%ebp),%eax
  800995:	8b 00                	mov    (%eax),%eax
  800997:	8d 50 04             	lea    0x4(%eax),%edx
  80099a:	8b 45 08             	mov    0x8(%ebp),%eax
  80099d:	89 10                	mov    %edx,(%eax)
  80099f:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a2:	8b 00                	mov    (%eax),%eax
  8009a4:	83 e8 04             	sub    $0x4,%eax
  8009a7:	8b 00                	mov    (%eax),%eax
  8009a9:	99                   	cltd   
}
  8009aa:	5d                   	pop    %ebp
  8009ab:	c3                   	ret    

008009ac <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  8009ac:	55                   	push   %ebp
  8009ad:	89 e5                	mov    %esp,%ebp
  8009af:	56                   	push   %esi
  8009b0:	53                   	push   %ebx
  8009b1:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009b4:	eb 17                	jmp    8009cd <vprintfmt+0x21>
			if (ch == '\0')
  8009b6:	85 db                	test   %ebx,%ebx
  8009b8:	0f 84 af 03 00 00    	je     800d6d <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  8009be:	83 ec 08             	sub    $0x8,%esp
  8009c1:	ff 75 0c             	pushl  0xc(%ebp)
  8009c4:	53                   	push   %ebx
  8009c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c8:	ff d0                	call   *%eax
  8009ca:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  8009cd:	8b 45 10             	mov    0x10(%ebp),%eax
  8009d0:	8d 50 01             	lea    0x1(%eax),%edx
  8009d3:	89 55 10             	mov    %edx,0x10(%ebp)
  8009d6:	8a 00                	mov    (%eax),%al
  8009d8:	0f b6 d8             	movzbl %al,%ebx
  8009db:	83 fb 25             	cmp    $0x25,%ebx
  8009de:	75 d6                	jne    8009b6 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8009e0:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8009e4:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8009eb:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8009f2:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8009f9:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800a00:	8b 45 10             	mov    0x10(%ebp),%eax
  800a03:	8d 50 01             	lea    0x1(%eax),%edx
  800a06:	89 55 10             	mov    %edx,0x10(%ebp)
  800a09:	8a 00                	mov    (%eax),%al
  800a0b:	0f b6 d8             	movzbl %al,%ebx
  800a0e:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800a11:	83 f8 55             	cmp    $0x55,%eax
  800a14:	0f 87 2b 03 00 00    	ja     800d45 <vprintfmt+0x399>
  800a1a:	8b 04 85 d8 24 80 00 	mov    0x8024d8(,%eax,4),%eax
  800a21:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800a23:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800a27:	eb d7                	jmp    800a00 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800a29:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800a2d:	eb d1                	jmp    800a00 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a2f:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800a36:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a39:	89 d0                	mov    %edx,%eax
  800a3b:	c1 e0 02             	shl    $0x2,%eax
  800a3e:	01 d0                	add    %edx,%eax
  800a40:	01 c0                	add    %eax,%eax
  800a42:	01 d8                	add    %ebx,%eax
  800a44:	83 e8 30             	sub    $0x30,%eax
  800a47:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a4a:	8b 45 10             	mov    0x10(%ebp),%eax
  800a4d:	8a 00                	mov    (%eax),%al
  800a4f:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a52:	83 fb 2f             	cmp    $0x2f,%ebx
  800a55:	7e 3e                	jle    800a95 <vprintfmt+0xe9>
  800a57:	83 fb 39             	cmp    $0x39,%ebx
  800a5a:	7f 39                	jg     800a95 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a5c:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a5f:	eb d5                	jmp    800a36 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a61:	8b 45 14             	mov    0x14(%ebp),%eax
  800a64:	83 c0 04             	add    $0x4,%eax
  800a67:	89 45 14             	mov    %eax,0x14(%ebp)
  800a6a:	8b 45 14             	mov    0x14(%ebp),%eax
  800a6d:	83 e8 04             	sub    $0x4,%eax
  800a70:	8b 00                	mov    (%eax),%eax
  800a72:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a75:	eb 1f                	jmp    800a96 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a77:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a7b:	79 83                	jns    800a00 <vprintfmt+0x54>
				width = 0;
  800a7d:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a84:	e9 77 ff ff ff       	jmp    800a00 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a89:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a90:	e9 6b ff ff ff       	jmp    800a00 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a95:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a96:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a9a:	0f 89 60 ff ff ff    	jns    800a00 <vprintfmt+0x54>
				width = precision, precision = -1;
  800aa0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800aa3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800aa6:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800aad:	e9 4e ff ff ff       	jmp    800a00 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800ab2:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800ab5:	e9 46 ff ff ff       	jmp    800a00 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800aba:	8b 45 14             	mov    0x14(%ebp),%eax
  800abd:	83 c0 04             	add    $0x4,%eax
  800ac0:	89 45 14             	mov    %eax,0x14(%ebp)
  800ac3:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac6:	83 e8 04             	sub    $0x4,%eax
  800ac9:	8b 00                	mov    (%eax),%eax
  800acb:	83 ec 08             	sub    $0x8,%esp
  800ace:	ff 75 0c             	pushl  0xc(%ebp)
  800ad1:	50                   	push   %eax
  800ad2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad5:	ff d0                	call   *%eax
  800ad7:	83 c4 10             	add    $0x10,%esp
			break;
  800ada:	e9 89 02 00 00       	jmp    800d68 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800adf:	8b 45 14             	mov    0x14(%ebp),%eax
  800ae2:	83 c0 04             	add    $0x4,%eax
  800ae5:	89 45 14             	mov    %eax,0x14(%ebp)
  800ae8:	8b 45 14             	mov    0x14(%ebp),%eax
  800aeb:	83 e8 04             	sub    $0x4,%eax
  800aee:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800af0:	85 db                	test   %ebx,%ebx
  800af2:	79 02                	jns    800af6 <vprintfmt+0x14a>
				err = -err;
  800af4:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800af6:	83 fb 64             	cmp    $0x64,%ebx
  800af9:	7f 0b                	jg     800b06 <vprintfmt+0x15a>
  800afb:	8b 34 9d 20 23 80 00 	mov    0x802320(,%ebx,4),%esi
  800b02:	85 f6                	test   %esi,%esi
  800b04:	75 19                	jne    800b1f <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800b06:	53                   	push   %ebx
  800b07:	68 c5 24 80 00       	push   $0x8024c5
  800b0c:	ff 75 0c             	pushl  0xc(%ebp)
  800b0f:	ff 75 08             	pushl  0x8(%ebp)
  800b12:	e8 5e 02 00 00       	call   800d75 <printfmt>
  800b17:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800b1a:	e9 49 02 00 00       	jmp    800d68 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800b1f:	56                   	push   %esi
  800b20:	68 ce 24 80 00       	push   $0x8024ce
  800b25:	ff 75 0c             	pushl  0xc(%ebp)
  800b28:	ff 75 08             	pushl  0x8(%ebp)
  800b2b:	e8 45 02 00 00       	call   800d75 <printfmt>
  800b30:	83 c4 10             	add    $0x10,%esp
			break;
  800b33:	e9 30 02 00 00       	jmp    800d68 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800b38:	8b 45 14             	mov    0x14(%ebp),%eax
  800b3b:	83 c0 04             	add    $0x4,%eax
  800b3e:	89 45 14             	mov    %eax,0x14(%ebp)
  800b41:	8b 45 14             	mov    0x14(%ebp),%eax
  800b44:	83 e8 04             	sub    $0x4,%eax
  800b47:	8b 30                	mov    (%eax),%esi
  800b49:	85 f6                	test   %esi,%esi
  800b4b:	75 05                	jne    800b52 <vprintfmt+0x1a6>
				p = "(null)";
  800b4d:	be d1 24 80 00       	mov    $0x8024d1,%esi
			if (width > 0 && padc != '-')
  800b52:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b56:	7e 6d                	jle    800bc5 <vprintfmt+0x219>
  800b58:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b5c:	74 67                	je     800bc5 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b5e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b61:	83 ec 08             	sub    $0x8,%esp
  800b64:	50                   	push   %eax
  800b65:	56                   	push   %esi
  800b66:	e8 0c 03 00 00       	call   800e77 <strnlen>
  800b6b:	83 c4 10             	add    $0x10,%esp
  800b6e:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b71:	eb 16                	jmp    800b89 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b73:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b77:	83 ec 08             	sub    $0x8,%esp
  800b7a:	ff 75 0c             	pushl  0xc(%ebp)
  800b7d:	50                   	push   %eax
  800b7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b81:	ff d0                	call   *%eax
  800b83:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b86:	ff 4d e4             	decl   -0x1c(%ebp)
  800b89:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b8d:	7f e4                	jg     800b73 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b8f:	eb 34                	jmp    800bc5 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b91:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b95:	74 1c                	je     800bb3 <vprintfmt+0x207>
  800b97:	83 fb 1f             	cmp    $0x1f,%ebx
  800b9a:	7e 05                	jle    800ba1 <vprintfmt+0x1f5>
  800b9c:	83 fb 7e             	cmp    $0x7e,%ebx
  800b9f:	7e 12                	jle    800bb3 <vprintfmt+0x207>
					putch('?', putdat);
  800ba1:	83 ec 08             	sub    $0x8,%esp
  800ba4:	ff 75 0c             	pushl  0xc(%ebp)
  800ba7:	6a 3f                	push   $0x3f
  800ba9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bac:	ff d0                	call   *%eax
  800bae:	83 c4 10             	add    $0x10,%esp
  800bb1:	eb 0f                	jmp    800bc2 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800bb3:	83 ec 08             	sub    $0x8,%esp
  800bb6:	ff 75 0c             	pushl  0xc(%ebp)
  800bb9:	53                   	push   %ebx
  800bba:	8b 45 08             	mov    0x8(%ebp),%eax
  800bbd:	ff d0                	call   *%eax
  800bbf:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800bc2:	ff 4d e4             	decl   -0x1c(%ebp)
  800bc5:	89 f0                	mov    %esi,%eax
  800bc7:	8d 70 01             	lea    0x1(%eax),%esi
  800bca:	8a 00                	mov    (%eax),%al
  800bcc:	0f be d8             	movsbl %al,%ebx
  800bcf:	85 db                	test   %ebx,%ebx
  800bd1:	74 24                	je     800bf7 <vprintfmt+0x24b>
  800bd3:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800bd7:	78 b8                	js     800b91 <vprintfmt+0x1e5>
  800bd9:	ff 4d e0             	decl   -0x20(%ebp)
  800bdc:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800be0:	79 af                	jns    800b91 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800be2:	eb 13                	jmp    800bf7 <vprintfmt+0x24b>
				putch(' ', putdat);
  800be4:	83 ec 08             	sub    $0x8,%esp
  800be7:	ff 75 0c             	pushl  0xc(%ebp)
  800bea:	6a 20                	push   $0x20
  800bec:	8b 45 08             	mov    0x8(%ebp),%eax
  800bef:	ff d0                	call   *%eax
  800bf1:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bf4:	ff 4d e4             	decl   -0x1c(%ebp)
  800bf7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bfb:	7f e7                	jg     800be4 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800bfd:	e9 66 01 00 00       	jmp    800d68 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800c02:	83 ec 08             	sub    $0x8,%esp
  800c05:	ff 75 e8             	pushl  -0x18(%ebp)
  800c08:	8d 45 14             	lea    0x14(%ebp),%eax
  800c0b:	50                   	push   %eax
  800c0c:	e8 3c fd ff ff       	call   80094d <getint>
  800c11:	83 c4 10             	add    $0x10,%esp
  800c14:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c17:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800c1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c1d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c20:	85 d2                	test   %edx,%edx
  800c22:	79 23                	jns    800c47 <vprintfmt+0x29b>
				putch('-', putdat);
  800c24:	83 ec 08             	sub    $0x8,%esp
  800c27:	ff 75 0c             	pushl  0xc(%ebp)
  800c2a:	6a 2d                	push   $0x2d
  800c2c:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2f:	ff d0                	call   *%eax
  800c31:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800c34:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c37:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c3a:	f7 d8                	neg    %eax
  800c3c:	83 d2 00             	adc    $0x0,%edx
  800c3f:	f7 da                	neg    %edx
  800c41:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c44:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800c47:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c4e:	e9 bc 00 00 00       	jmp    800d0f <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c53:	83 ec 08             	sub    $0x8,%esp
  800c56:	ff 75 e8             	pushl  -0x18(%ebp)
  800c59:	8d 45 14             	lea    0x14(%ebp),%eax
  800c5c:	50                   	push   %eax
  800c5d:	e8 84 fc ff ff       	call   8008e6 <getuint>
  800c62:	83 c4 10             	add    $0x10,%esp
  800c65:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c68:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c6b:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c72:	e9 98 00 00 00       	jmp    800d0f <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c77:	83 ec 08             	sub    $0x8,%esp
  800c7a:	ff 75 0c             	pushl  0xc(%ebp)
  800c7d:	6a 58                	push   $0x58
  800c7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c82:	ff d0                	call   *%eax
  800c84:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c87:	83 ec 08             	sub    $0x8,%esp
  800c8a:	ff 75 0c             	pushl  0xc(%ebp)
  800c8d:	6a 58                	push   $0x58
  800c8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800c92:	ff d0                	call   *%eax
  800c94:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c97:	83 ec 08             	sub    $0x8,%esp
  800c9a:	ff 75 0c             	pushl  0xc(%ebp)
  800c9d:	6a 58                	push   $0x58
  800c9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca2:	ff d0                	call   *%eax
  800ca4:	83 c4 10             	add    $0x10,%esp
			break;
  800ca7:	e9 bc 00 00 00       	jmp    800d68 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800cac:	83 ec 08             	sub    $0x8,%esp
  800caf:	ff 75 0c             	pushl  0xc(%ebp)
  800cb2:	6a 30                	push   $0x30
  800cb4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb7:	ff d0                	call   *%eax
  800cb9:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800cbc:	83 ec 08             	sub    $0x8,%esp
  800cbf:	ff 75 0c             	pushl  0xc(%ebp)
  800cc2:	6a 78                	push   $0x78
  800cc4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc7:	ff d0                	call   *%eax
  800cc9:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800ccc:	8b 45 14             	mov    0x14(%ebp),%eax
  800ccf:	83 c0 04             	add    $0x4,%eax
  800cd2:	89 45 14             	mov    %eax,0x14(%ebp)
  800cd5:	8b 45 14             	mov    0x14(%ebp),%eax
  800cd8:	83 e8 04             	sub    $0x4,%eax
  800cdb:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800cdd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ce0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800ce7:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800cee:	eb 1f                	jmp    800d0f <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800cf0:	83 ec 08             	sub    $0x8,%esp
  800cf3:	ff 75 e8             	pushl  -0x18(%ebp)
  800cf6:	8d 45 14             	lea    0x14(%ebp),%eax
  800cf9:	50                   	push   %eax
  800cfa:	e8 e7 fb ff ff       	call   8008e6 <getuint>
  800cff:	83 c4 10             	add    $0x10,%esp
  800d02:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d05:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800d08:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800d0f:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800d13:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800d16:	83 ec 04             	sub    $0x4,%esp
  800d19:	52                   	push   %edx
  800d1a:	ff 75 e4             	pushl  -0x1c(%ebp)
  800d1d:	50                   	push   %eax
  800d1e:	ff 75 f4             	pushl  -0xc(%ebp)
  800d21:	ff 75 f0             	pushl  -0x10(%ebp)
  800d24:	ff 75 0c             	pushl  0xc(%ebp)
  800d27:	ff 75 08             	pushl  0x8(%ebp)
  800d2a:	e8 00 fb ff ff       	call   80082f <printnum>
  800d2f:	83 c4 20             	add    $0x20,%esp
			break;
  800d32:	eb 34                	jmp    800d68 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800d34:	83 ec 08             	sub    $0x8,%esp
  800d37:	ff 75 0c             	pushl  0xc(%ebp)
  800d3a:	53                   	push   %ebx
  800d3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3e:	ff d0                	call   *%eax
  800d40:	83 c4 10             	add    $0x10,%esp
			break;
  800d43:	eb 23                	jmp    800d68 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d45:	83 ec 08             	sub    $0x8,%esp
  800d48:	ff 75 0c             	pushl  0xc(%ebp)
  800d4b:	6a 25                	push   $0x25
  800d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d50:	ff d0                	call   *%eax
  800d52:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d55:	ff 4d 10             	decl   0x10(%ebp)
  800d58:	eb 03                	jmp    800d5d <vprintfmt+0x3b1>
  800d5a:	ff 4d 10             	decl   0x10(%ebp)
  800d5d:	8b 45 10             	mov    0x10(%ebp),%eax
  800d60:	48                   	dec    %eax
  800d61:	8a 00                	mov    (%eax),%al
  800d63:	3c 25                	cmp    $0x25,%al
  800d65:	75 f3                	jne    800d5a <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800d67:	90                   	nop
		}
	}
  800d68:	e9 47 fc ff ff       	jmp    8009b4 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d6d:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d6e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d71:	5b                   	pop    %ebx
  800d72:	5e                   	pop    %esi
  800d73:	5d                   	pop    %ebp
  800d74:	c3                   	ret    

00800d75 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d75:	55                   	push   %ebp
  800d76:	89 e5                	mov    %esp,%ebp
  800d78:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d7b:	8d 45 10             	lea    0x10(%ebp),%eax
  800d7e:	83 c0 04             	add    $0x4,%eax
  800d81:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d84:	8b 45 10             	mov    0x10(%ebp),%eax
  800d87:	ff 75 f4             	pushl  -0xc(%ebp)
  800d8a:	50                   	push   %eax
  800d8b:	ff 75 0c             	pushl  0xc(%ebp)
  800d8e:	ff 75 08             	pushl  0x8(%ebp)
  800d91:	e8 16 fc ff ff       	call   8009ac <vprintfmt>
  800d96:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d99:	90                   	nop
  800d9a:	c9                   	leave  
  800d9b:	c3                   	ret    

00800d9c <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d9c:	55                   	push   %ebp
  800d9d:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800da2:	8b 40 08             	mov    0x8(%eax),%eax
  800da5:	8d 50 01             	lea    0x1(%eax),%edx
  800da8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dab:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800dae:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db1:	8b 10                	mov    (%eax),%edx
  800db3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800db6:	8b 40 04             	mov    0x4(%eax),%eax
  800db9:	39 c2                	cmp    %eax,%edx
  800dbb:	73 12                	jae    800dcf <sprintputch+0x33>
		*b->buf++ = ch;
  800dbd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc0:	8b 00                	mov    (%eax),%eax
  800dc2:	8d 48 01             	lea    0x1(%eax),%ecx
  800dc5:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dc8:	89 0a                	mov    %ecx,(%edx)
  800dca:	8b 55 08             	mov    0x8(%ebp),%edx
  800dcd:	88 10                	mov    %dl,(%eax)
}
  800dcf:	90                   	nop
  800dd0:	5d                   	pop    %ebp
  800dd1:	c3                   	ret    

00800dd2 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800dd2:	55                   	push   %ebp
  800dd3:	89 e5                	mov    %esp,%ebp
  800dd5:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800dd8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ddb:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800dde:	8b 45 0c             	mov    0xc(%ebp),%eax
  800de1:	8d 50 ff             	lea    -0x1(%eax),%edx
  800de4:	8b 45 08             	mov    0x8(%ebp),%eax
  800de7:	01 d0                	add    %edx,%eax
  800de9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dec:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800df3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800df7:	74 06                	je     800dff <vsnprintf+0x2d>
  800df9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dfd:	7f 07                	jg     800e06 <vsnprintf+0x34>
		return -E_INVAL;
  800dff:	b8 03 00 00 00       	mov    $0x3,%eax
  800e04:	eb 20                	jmp    800e26 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800e06:	ff 75 14             	pushl  0x14(%ebp)
  800e09:	ff 75 10             	pushl  0x10(%ebp)
  800e0c:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800e0f:	50                   	push   %eax
  800e10:	68 9c 0d 80 00       	push   $0x800d9c
  800e15:	e8 92 fb ff ff       	call   8009ac <vprintfmt>
  800e1a:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800e1d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800e20:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800e23:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800e26:	c9                   	leave  
  800e27:	c3                   	ret    

00800e28 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800e28:	55                   	push   %ebp
  800e29:	89 e5                	mov    %esp,%ebp
  800e2b:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800e2e:	8d 45 10             	lea    0x10(%ebp),%eax
  800e31:	83 c0 04             	add    $0x4,%eax
  800e34:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800e37:	8b 45 10             	mov    0x10(%ebp),%eax
  800e3a:	ff 75 f4             	pushl  -0xc(%ebp)
  800e3d:	50                   	push   %eax
  800e3e:	ff 75 0c             	pushl  0xc(%ebp)
  800e41:	ff 75 08             	pushl  0x8(%ebp)
  800e44:	e8 89 ff ff ff       	call   800dd2 <vsnprintf>
  800e49:	83 c4 10             	add    $0x10,%esp
  800e4c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e4f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e52:	c9                   	leave  
  800e53:	c3                   	ret    

00800e54 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800e54:	55                   	push   %ebp
  800e55:	89 e5                	mov    %esp,%ebp
  800e57:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e5a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e61:	eb 06                	jmp    800e69 <strlen+0x15>
		n++;
  800e63:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e66:	ff 45 08             	incl   0x8(%ebp)
  800e69:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6c:	8a 00                	mov    (%eax),%al
  800e6e:	84 c0                	test   %al,%al
  800e70:	75 f1                	jne    800e63 <strlen+0xf>
		n++;
	return n;
  800e72:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e75:	c9                   	leave  
  800e76:	c3                   	ret    

00800e77 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e77:	55                   	push   %ebp
  800e78:	89 e5                	mov    %esp,%ebp
  800e7a:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e7d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e84:	eb 09                	jmp    800e8f <strnlen+0x18>
		n++;
  800e86:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e89:	ff 45 08             	incl   0x8(%ebp)
  800e8c:	ff 4d 0c             	decl   0xc(%ebp)
  800e8f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e93:	74 09                	je     800e9e <strnlen+0x27>
  800e95:	8b 45 08             	mov    0x8(%ebp),%eax
  800e98:	8a 00                	mov    (%eax),%al
  800e9a:	84 c0                	test   %al,%al
  800e9c:	75 e8                	jne    800e86 <strnlen+0xf>
		n++;
	return n;
  800e9e:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ea1:	c9                   	leave  
  800ea2:	c3                   	ret    

00800ea3 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800ea3:	55                   	push   %ebp
  800ea4:	89 e5                	mov    %esp,%ebp
  800ea6:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800ea9:	8b 45 08             	mov    0x8(%ebp),%eax
  800eac:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800eaf:	90                   	nop
  800eb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb3:	8d 50 01             	lea    0x1(%eax),%edx
  800eb6:	89 55 08             	mov    %edx,0x8(%ebp)
  800eb9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ebc:	8d 4a 01             	lea    0x1(%edx),%ecx
  800ebf:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ec2:	8a 12                	mov    (%edx),%dl
  800ec4:	88 10                	mov    %dl,(%eax)
  800ec6:	8a 00                	mov    (%eax),%al
  800ec8:	84 c0                	test   %al,%al
  800eca:	75 e4                	jne    800eb0 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800ecc:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800ecf:	c9                   	leave  
  800ed0:	c3                   	ret    

00800ed1 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800ed1:	55                   	push   %ebp
  800ed2:	89 e5                	mov    %esp,%ebp
  800ed4:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800ed7:	8b 45 08             	mov    0x8(%ebp),%eax
  800eda:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800edd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800ee4:	eb 1f                	jmp    800f05 <strncpy+0x34>
		*dst++ = *src;
  800ee6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee9:	8d 50 01             	lea    0x1(%eax),%edx
  800eec:	89 55 08             	mov    %edx,0x8(%ebp)
  800eef:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ef2:	8a 12                	mov    (%edx),%dl
  800ef4:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800ef6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ef9:	8a 00                	mov    (%eax),%al
  800efb:	84 c0                	test   %al,%al
  800efd:	74 03                	je     800f02 <strncpy+0x31>
			src++;
  800eff:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800f02:	ff 45 fc             	incl   -0x4(%ebp)
  800f05:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f08:	3b 45 10             	cmp    0x10(%ebp),%eax
  800f0b:	72 d9                	jb     800ee6 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800f0d:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f10:	c9                   	leave  
  800f11:	c3                   	ret    

00800f12 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800f12:	55                   	push   %ebp
  800f13:	89 e5                	mov    %esp,%ebp
  800f15:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800f18:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800f1e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f22:	74 30                	je     800f54 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800f24:	eb 16                	jmp    800f3c <strlcpy+0x2a>
			*dst++ = *src++;
  800f26:	8b 45 08             	mov    0x8(%ebp),%eax
  800f29:	8d 50 01             	lea    0x1(%eax),%edx
  800f2c:	89 55 08             	mov    %edx,0x8(%ebp)
  800f2f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f32:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f35:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f38:	8a 12                	mov    (%edx),%dl
  800f3a:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f3c:	ff 4d 10             	decl   0x10(%ebp)
  800f3f:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f43:	74 09                	je     800f4e <strlcpy+0x3c>
  800f45:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f48:	8a 00                	mov    (%eax),%al
  800f4a:	84 c0                	test   %al,%al
  800f4c:	75 d8                	jne    800f26 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f51:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f54:	8b 55 08             	mov    0x8(%ebp),%edx
  800f57:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f5a:	29 c2                	sub    %eax,%edx
  800f5c:	89 d0                	mov    %edx,%eax
}
  800f5e:	c9                   	leave  
  800f5f:	c3                   	ret    

00800f60 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f60:	55                   	push   %ebp
  800f61:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f63:	eb 06                	jmp    800f6b <strcmp+0xb>
		p++, q++;
  800f65:	ff 45 08             	incl   0x8(%ebp)
  800f68:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f6b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6e:	8a 00                	mov    (%eax),%al
  800f70:	84 c0                	test   %al,%al
  800f72:	74 0e                	je     800f82 <strcmp+0x22>
  800f74:	8b 45 08             	mov    0x8(%ebp),%eax
  800f77:	8a 10                	mov    (%eax),%dl
  800f79:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f7c:	8a 00                	mov    (%eax),%al
  800f7e:	38 c2                	cmp    %al,%dl
  800f80:	74 e3                	je     800f65 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f82:	8b 45 08             	mov    0x8(%ebp),%eax
  800f85:	8a 00                	mov    (%eax),%al
  800f87:	0f b6 d0             	movzbl %al,%edx
  800f8a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f8d:	8a 00                	mov    (%eax),%al
  800f8f:	0f b6 c0             	movzbl %al,%eax
  800f92:	29 c2                	sub    %eax,%edx
  800f94:	89 d0                	mov    %edx,%eax
}
  800f96:	5d                   	pop    %ebp
  800f97:	c3                   	ret    

00800f98 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f98:	55                   	push   %ebp
  800f99:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f9b:	eb 09                	jmp    800fa6 <strncmp+0xe>
		n--, p++, q++;
  800f9d:	ff 4d 10             	decl   0x10(%ebp)
  800fa0:	ff 45 08             	incl   0x8(%ebp)
  800fa3:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800fa6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800faa:	74 17                	je     800fc3 <strncmp+0x2b>
  800fac:	8b 45 08             	mov    0x8(%ebp),%eax
  800faf:	8a 00                	mov    (%eax),%al
  800fb1:	84 c0                	test   %al,%al
  800fb3:	74 0e                	je     800fc3 <strncmp+0x2b>
  800fb5:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb8:	8a 10                	mov    (%eax),%dl
  800fba:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fbd:	8a 00                	mov    (%eax),%al
  800fbf:	38 c2                	cmp    %al,%dl
  800fc1:	74 da                	je     800f9d <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800fc3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800fc7:	75 07                	jne    800fd0 <strncmp+0x38>
		return 0;
  800fc9:	b8 00 00 00 00       	mov    $0x0,%eax
  800fce:	eb 14                	jmp    800fe4 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800fd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd3:	8a 00                	mov    (%eax),%al
  800fd5:	0f b6 d0             	movzbl %al,%edx
  800fd8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fdb:	8a 00                	mov    (%eax),%al
  800fdd:	0f b6 c0             	movzbl %al,%eax
  800fe0:	29 c2                	sub    %eax,%edx
  800fe2:	89 d0                	mov    %edx,%eax
}
  800fe4:	5d                   	pop    %ebp
  800fe5:	c3                   	ret    

00800fe6 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800fe6:	55                   	push   %ebp
  800fe7:	89 e5                	mov    %esp,%ebp
  800fe9:	83 ec 04             	sub    $0x4,%esp
  800fec:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fef:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ff2:	eb 12                	jmp    801006 <strchr+0x20>
		if (*s == c)
  800ff4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff7:	8a 00                	mov    (%eax),%al
  800ff9:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ffc:	75 05                	jne    801003 <strchr+0x1d>
			return (char *) s;
  800ffe:	8b 45 08             	mov    0x8(%ebp),%eax
  801001:	eb 11                	jmp    801014 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  801003:	ff 45 08             	incl   0x8(%ebp)
  801006:	8b 45 08             	mov    0x8(%ebp),%eax
  801009:	8a 00                	mov    (%eax),%al
  80100b:	84 c0                	test   %al,%al
  80100d:	75 e5                	jne    800ff4 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  80100f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801014:	c9                   	leave  
  801015:	c3                   	ret    

00801016 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  801016:	55                   	push   %ebp
  801017:	89 e5                	mov    %esp,%ebp
  801019:	83 ec 04             	sub    $0x4,%esp
  80101c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80101f:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801022:	eb 0d                	jmp    801031 <strfind+0x1b>
		if (*s == c)
  801024:	8b 45 08             	mov    0x8(%ebp),%eax
  801027:	8a 00                	mov    (%eax),%al
  801029:	3a 45 fc             	cmp    -0x4(%ebp),%al
  80102c:	74 0e                	je     80103c <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  80102e:	ff 45 08             	incl   0x8(%ebp)
  801031:	8b 45 08             	mov    0x8(%ebp),%eax
  801034:	8a 00                	mov    (%eax),%al
  801036:	84 c0                	test   %al,%al
  801038:	75 ea                	jne    801024 <strfind+0xe>
  80103a:	eb 01                	jmp    80103d <strfind+0x27>
		if (*s == c)
			break;
  80103c:	90                   	nop
	return (char *) s;
  80103d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801040:	c9                   	leave  
  801041:	c3                   	ret    

00801042 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801042:	55                   	push   %ebp
  801043:	89 e5                	mov    %esp,%ebp
  801045:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801048:	8b 45 08             	mov    0x8(%ebp),%eax
  80104b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  80104e:	8b 45 10             	mov    0x10(%ebp),%eax
  801051:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801054:	eb 0e                	jmp    801064 <memset+0x22>
		*p++ = c;
  801056:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801059:	8d 50 01             	lea    0x1(%eax),%edx
  80105c:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80105f:	8b 55 0c             	mov    0xc(%ebp),%edx
  801062:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801064:	ff 4d f8             	decl   -0x8(%ebp)
  801067:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80106b:	79 e9                	jns    801056 <memset+0x14>
		*p++ = c;

	return v;
  80106d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801070:	c9                   	leave  
  801071:	c3                   	ret    

00801072 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801072:	55                   	push   %ebp
  801073:	89 e5                	mov    %esp,%ebp
  801075:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801078:	8b 45 0c             	mov    0xc(%ebp),%eax
  80107b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80107e:	8b 45 08             	mov    0x8(%ebp),%eax
  801081:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801084:	eb 16                	jmp    80109c <memcpy+0x2a>
		*d++ = *s++;
  801086:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801089:	8d 50 01             	lea    0x1(%eax),%edx
  80108c:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80108f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801092:	8d 4a 01             	lea    0x1(%edx),%ecx
  801095:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801098:	8a 12                	mov    (%edx),%dl
  80109a:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  80109c:	8b 45 10             	mov    0x10(%ebp),%eax
  80109f:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010a2:	89 55 10             	mov    %edx,0x10(%ebp)
  8010a5:	85 c0                	test   %eax,%eax
  8010a7:	75 dd                	jne    801086 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  8010a9:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010ac:	c9                   	leave  
  8010ad:	c3                   	ret    

008010ae <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  8010ae:	55                   	push   %ebp
  8010af:	89 e5                	mov    %esp,%ebp
  8010b1:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  8010b4:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b7:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  8010ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bd:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8010c0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010c3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8010c6:	73 50                	jae    801118 <memmove+0x6a>
  8010c8:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8010ce:	01 d0                	add    %edx,%eax
  8010d0:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8010d3:	76 43                	jbe    801118 <memmove+0x6a>
		s += n;
  8010d5:	8b 45 10             	mov    0x10(%ebp),%eax
  8010d8:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8010db:	8b 45 10             	mov    0x10(%ebp),%eax
  8010de:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8010e1:	eb 10                	jmp    8010f3 <memmove+0x45>
			*--d = *--s;
  8010e3:	ff 4d f8             	decl   -0x8(%ebp)
  8010e6:	ff 4d fc             	decl   -0x4(%ebp)
  8010e9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010ec:	8a 10                	mov    (%eax),%dl
  8010ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010f1:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8010f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8010f6:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010f9:	89 55 10             	mov    %edx,0x10(%ebp)
  8010fc:	85 c0                	test   %eax,%eax
  8010fe:	75 e3                	jne    8010e3 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801100:	eb 23                	jmp    801125 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801102:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801105:	8d 50 01             	lea    0x1(%eax),%edx
  801108:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80110b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80110e:	8d 4a 01             	lea    0x1(%edx),%ecx
  801111:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801114:	8a 12                	mov    (%edx),%dl
  801116:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  801118:	8b 45 10             	mov    0x10(%ebp),%eax
  80111b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80111e:	89 55 10             	mov    %edx,0x10(%ebp)
  801121:	85 c0                	test   %eax,%eax
  801123:	75 dd                	jne    801102 <memmove+0x54>
			*d++ = *s++;

	return dst;
  801125:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801128:	c9                   	leave  
  801129:	c3                   	ret    

0080112a <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80112a:	55                   	push   %ebp
  80112b:	89 e5                	mov    %esp,%ebp
  80112d:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801130:	8b 45 08             	mov    0x8(%ebp),%eax
  801133:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801136:	8b 45 0c             	mov    0xc(%ebp),%eax
  801139:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  80113c:	eb 2a                	jmp    801168 <memcmp+0x3e>
		if (*s1 != *s2)
  80113e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801141:	8a 10                	mov    (%eax),%dl
  801143:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801146:	8a 00                	mov    (%eax),%al
  801148:	38 c2                	cmp    %al,%dl
  80114a:	74 16                	je     801162 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  80114c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80114f:	8a 00                	mov    (%eax),%al
  801151:	0f b6 d0             	movzbl %al,%edx
  801154:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801157:	8a 00                	mov    (%eax),%al
  801159:	0f b6 c0             	movzbl %al,%eax
  80115c:	29 c2                	sub    %eax,%edx
  80115e:	89 d0                	mov    %edx,%eax
  801160:	eb 18                	jmp    80117a <memcmp+0x50>
		s1++, s2++;
  801162:	ff 45 fc             	incl   -0x4(%ebp)
  801165:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801168:	8b 45 10             	mov    0x10(%ebp),%eax
  80116b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80116e:	89 55 10             	mov    %edx,0x10(%ebp)
  801171:	85 c0                	test   %eax,%eax
  801173:	75 c9                	jne    80113e <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801175:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80117a:	c9                   	leave  
  80117b:	c3                   	ret    

0080117c <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  80117c:	55                   	push   %ebp
  80117d:	89 e5                	mov    %esp,%ebp
  80117f:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801182:	8b 55 08             	mov    0x8(%ebp),%edx
  801185:	8b 45 10             	mov    0x10(%ebp),%eax
  801188:	01 d0                	add    %edx,%eax
  80118a:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  80118d:	eb 15                	jmp    8011a4 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80118f:	8b 45 08             	mov    0x8(%ebp),%eax
  801192:	8a 00                	mov    (%eax),%al
  801194:	0f b6 d0             	movzbl %al,%edx
  801197:	8b 45 0c             	mov    0xc(%ebp),%eax
  80119a:	0f b6 c0             	movzbl %al,%eax
  80119d:	39 c2                	cmp    %eax,%edx
  80119f:	74 0d                	je     8011ae <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  8011a1:	ff 45 08             	incl   0x8(%ebp)
  8011a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a7:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  8011aa:	72 e3                	jb     80118f <memfind+0x13>
  8011ac:	eb 01                	jmp    8011af <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  8011ae:	90                   	nop
	return (void *) s;
  8011af:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8011b2:	c9                   	leave  
  8011b3:	c3                   	ret    

008011b4 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  8011b4:	55                   	push   %ebp
  8011b5:	89 e5                	mov    %esp,%ebp
  8011b7:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  8011ba:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8011c1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011c8:	eb 03                	jmp    8011cd <strtol+0x19>
		s++;
  8011ca:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8011cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d0:	8a 00                	mov    (%eax),%al
  8011d2:	3c 20                	cmp    $0x20,%al
  8011d4:	74 f4                	je     8011ca <strtol+0x16>
  8011d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d9:	8a 00                	mov    (%eax),%al
  8011db:	3c 09                	cmp    $0x9,%al
  8011dd:	74 eb                	je     8011ca <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8011df:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e2:	8a 00                	mov    (%eax),%al
  8011e4:	3c 2b                	cmp    $0x2b,%al
  8011e6:	75 05                	jne    8011ed <strtol+0x39>
		s++;
  8011e8:	ff 45 08             	incl   0x8(%ebp)
  8011eb:	eb 13                	jmp    801200 <strtol+0x4c>
	else if (*s == '-')
  8011ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f0:	8a 00                	mov    (%eax),%al
  8011f2:	3c 2d                	cmp    $0x2d,%al
  8011f4:	75 0a                	jne    801200 <strtol+0x4c>
		s++, neg = 1;
  8011f6:	ff 45 08             	incl   0x8(%ebp)
  8011f9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801200:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801204:	74 06                	je     80120c <strtol+0x58>
  801206:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80120a:	75 20                	jne    80122c <strtol+0x78>
  80120c:	8b 45 08             	mov    0x8(%ebp),%eax
  80120f:	8a 00                	mov    (%eax),%al
  801211:	3c 30                	cmp    $0x30,%al
  801213:	75 17                	jne    80122c <strtol+0x78>
  801215:	8b 45 08             	mov    0x8(%ebp),%eax
  801218:	40                   	inc    %eax
  801219:	8a 00                	mov    (%eax),%al
  80121b:	3c 78                	cmp    $0x78,%al
  80121d:	75 0d                	jne    80122c <strtol+0x78>
		s += 2, base = 16;
  80121f:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801223:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80122a:	eb 28                	jmp    801254 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  80122c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801230:	75 15                	jne    801247 <strtol+0x93>
  801232:	8b 45 08             	mov    0x8(%ebp),%eax
  801235:	8a 00                	mov    (%eax),%al
  801237:	3c 30                	cmp    $0x30,%al
  801239:	75 0c                	jne    801247 <strtol+0x93>
		s++, base = 8;
  80123b:	ff 45 08             	incl   0x8(%ebp)
  80123e:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801245:	eb 0d                	jmp    801254 <strtol+0xa0>
	else if (base == 0)
  801247:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80124b:	75 07                	jne    801254 <strtol+0xa0>
		base = 10;
  80124d:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801254:	8b 45 08             	mov    0x8(%ebp),%eax
  801257:	8a 00                	mov    (%eax),%al
  801259:	3c 2f                	cmp    $0x2f,%al
  80125b:	7e 19                	jle    801276 <strtol+0xc2>
  80125d:	8b 45 08             	mov    0x8(%ebp),%eax
  801260:	8a 00                	mov    (%eax),%al
  801262:	3c 39                	cmp    $0x39,%al
  801264:	7f 10                	jg     801276 <strtol+0xc2>
			dig = *s - '0';
  801266:	8b 45 08             	mov    0x8(%ebp),%eax
  801269:	8a 00                	mov    (%eax),%al
  80126b:	0f be c0             	movsbl %al,%eax
  80126e:	83 e8 30             	sub    $0x30,%eax
  801271:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801274:	eb 42                	jmp    8012b8 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801276:	8b 45 08             	mov    0x8(%ebp),%eax
  801279:	8a 00                	mov    (%eax),%al
  80127b:	3c 60                	cmp    $0x60,%al
  80127d:	7e 19                	jle    801298 <strtol+0xe4>
  80127f:	8b 45 08             	mov    0x8(%ebp),%eax
  801282:	8a 00                	mov    (%eax),%al
  801284:	3c 7a                	cmp    $0x7a,%al
  801286:	7f 10                	jg     801298 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801288:	8b 45 08             	mov    0x8(%ebp),%eax
  80128b:	8a 00                	mov    (%eax),%al
  80128d:	0f be c0             	movsbl %al,%eax
  801290:	83 e8 57             	sub    $0x57,%eax
  801293:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801296:	eb 20                	jmp    8012b8 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801298:	8b 45 08             	mov    0x8(%ebp),%eax
  80129b:	8a 00                	mov    (%eax),%al
  80129d:	3c 40                	cmp    $0x40,%al
  80129f:	7e 39                	jle    8012da <strtol+0x126>
  8012a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a4:	8a 00                	mov    (%eax),%al
  8012a6:	3c 5a                	cmp    $0x5a,%al
  8012a8:	7f 30                	jg     8012da <strtol+0x126>
			dig = *s - 'A' + 10;
  8012aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8012ad:	8a 00                	mov    (%eax),%al
  8012af:	0f be c0             	movsbl %al,%eax
  8012b2:	83 e8 37             	sub    $0x37,%eax
  8012b5:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  8012b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012bb:	3b 45 10             	cmp    0x10(%ebp),%eax
  8012be:	7d 19                	jge    8012d9 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8012c0:	ff 45 08             	incl   0x8(%ebp)
  8012c3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012c6:	0f af 45 10          	imul   0x10(%ebp),%eax
  8012ca:	89 c2                	mov    %eax,%edx
  8012cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012cf:	01 d0                	add    %edx,%eax
  8012d1:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8012d4:	e9 7b ff ff ff       	jmp    801254 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8012d9:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8012da:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8012de:	74 08                	je     8012e8 <strtol+0x134>
		*endptr = (char *) s;
  8012e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012e3:	8b 55 08             	mov    0x8(%ebp),%edx
  8012e6:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8012e8:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8012ec:	74 07                	je     8012f5 <strtol+0x141>
  8012ee:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012f1:	f7 d8                	neg    %eax
  8012f3:	eb 03                	jmp    8012f8 <strtol+0x144>
  8012f5:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8012f8:	c9                   	leave  
  8012f9:	c3                   	ret    

008012fa <ltostr>:

void
ltostr(long value, char *str)
{
  8012fa:	55                   	push   %ebp
  8012fb:	89 e5                	mov    %esp,%ebp
  8012fd:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801300:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  801307:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  80130e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801312:	79 13                	jns    801327 <ltostr+0x2d>
	{
		neg = 1;
  801314:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  80131b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80131e:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801321:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801324:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  801327:	8b 45 08             	mov    0x8(%ebp),%eax
  80132a:	b9 0a 00 00 00       	mov    $0xa,%ecx
  80132f:	99                   	cltd   
  801330:	f7 f9                	idiv   %ecx
  801332:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801335:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801338:	8d 50 01             	lea    0x1(%eax),%edx
  80133b:	89 55 f8             	mov    %edx,-0x8(%ebp)
  80133e:	89 c2                	mov    %eax,%edx
  801340:	8b 45 0c             	mov    0xc(%ebp),%eax
  801343:	01 d0                	add    %edx,%eax
  801345:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801348:	83 c2 30             	add    $0x30,%edx
  80134b:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  80134d:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801350:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801355:	f7 e9                	imul   %ecx
  801357:	c1 fa 02             	sar    $0x2,%edx
  80135a:	89 c8                	mov    %ecx,%eax
  80135c:	c1 f8 1f             	sar    $0x1f,%eax
  80135f:	29 c2                	sub    %eax,%edx
  801361:	89 d0                	mov    %edx,%eax
  801363:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801366:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801369:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80136e:	f7 e9                	imul   %ecx
  801370:	c1 fa 02             	sar    $0x2,%edx
  801373:	89 c8                	mov    %ecx,%eax
  801375:	c1 f8 1f             	sar    $0x1f,%eax
  801378:	29 c2                	sub    %eax,%edx
  80137a:	89 d0                	mov    %edx,%eax
  80137c:	c1 e0 02             	shl    $0x2,%eax
  80137f:	01 d0                	add    %edx,%eax
  801381:	01 c0                	add    %eax,%eax
  801383:	29 c1                	sub    %eax,%ecx
  801385:	89 ca                	mov    %ecx,%edx
  801387:	85 d2                	test   %edx,%edx
  801389:	75 9c                	jne    801327 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  80138b:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801392:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801395:	48                   	dec    %eax
  801396:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801399:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  80139d:	74 3d                	je     8013dc <ltostr+0xe2>
		start = 1 ;
  80139f:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  8013a6:	eb 34                	jmp    8013dc <ltostr+0xe2>
	{
		char tmp = str[start] ;
  8013a8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ae:	01 d0                	add    %edx,%eax
  8013b0:	8a 00                	mov    (%eax),%al
  8013b2:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  8013b5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8013b8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013bb:	01 c2                	add    %eax,%edx
  8013bd:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8013c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013c3:	01 c8                	add    %ecx,%eax
  8013c5:	8a 00                	mov    (%eax),%al
  8013c7:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8013c9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8013cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013cf:	01 c2                	add    %eax,%edx
  8013d1:	8a 45 eb             	mov    -0x15(%ebp),%al
  8013d4:	88 02                	mov    %al,(%edx)
		start++ ;
  8013d6:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8013d9:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8013dc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013df:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8013e2:	7c c4                	jl     8013a8 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8013e4:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8013e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013ea:	01 d0                	add    %edx,%eax
  8013ec:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8013ef:	90                   	nop
  8013f0:	c9                   	leave  
  8013f1:	c3                   	ret    

008013f2 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8013f2:	55                   	push   %ebp
  8013f3:	89 e5                	mov    %esp,%ebp
  8013f5:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8013f8:	ff 75 08             	pushl  0x8(%ebp)
  8013fb:	e8 54 fa ff ff       	call   800e54 <strlen>
  801400:	83 c4 04             	add    $0x4,%esp
  801403:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  801406:	ff 75 0c             	pushl  0xc(%ebp)
  801409:	e8 46 fa ff ff       	call   800e54 <strlen>
  80140e:	83 c4 04             	add    $0x4,%esp
  801411:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  801414:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  80141b:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801422:	eb 17                	jmp    80143b <strcconcat+0x49>
		final[s] = str1[s] ;
  801424:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801427:	8b 45 10             	mov    0x10(%ebp),%eax
  80142a:	01 c2                	add    %eax,%edx
  80142c:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  80142f:	8b 45 08             	mov    0x8(%ebp),%eax
  801432:	01 c8                	add    %ecx,%eax
  801434:	8a 00                	mov    (%eax),%al
  801436:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801438:	ff 45 fc             	incl   -0x4(%ebp)
  80143b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80143e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801441:	7c e1                	jl     801424 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801443:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80144a:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801451:	eb 1f                	jmp    801472 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801453:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801456:	8d 50 01             	lea    0x1(%eax),%edx
  801459:	89 55 fc             	mov    %edx,-0x4(%ebp)
  80145c:	89 c2                	mov    %eax,%edx
  80145e:	8b 45 10             	mov    0x10(%ebp),%eax
  801461:	01 c2                	add    %eax,%edx
  801463:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801466:	8b 45 0c             	mov    0xc(%ebp),%eax
  801469:	01 c8                	add    %ecx,%eax
  80146b:	8a 00                	mov    (%eax),%al
  80146d:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80146f:	ff 45 f8             	incl   -0x8(%ebp)
  801472:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801475:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801478:	7c d9                	jl     801453 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80147a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80147d:	8b 45 10             	mov    0x10(%ebp),%eax
  801480:	01 d0                	add    %edx,%eax
  801482:	c6 00 00             	movb   $0x0,(%eax)
}
  801485:	90                   	nop
  801486:	c9                   	leave  
  801487:	c3                   	ret    

00801488 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801488:	55                   	push   %ebp
  801489:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  80148b:	8b 45 14             	mov    0x14(%ebp),%eax
  80148e:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801494:	8b 45 14             	mov    0x14(%ebp),%eax
  801497:	8b 00                	mov    (%eax),%eax
  801499:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014a0:	8b 45 10             	mov    0x10(%ebp),%eax
  8014a3:	01 d0                	add    %edx,%eax
  8014a5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014ab:	eb 0c                	jmp    8014b9 <strsplit+0x31>
			*string++ = 0;
  8014ad:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b0:	8d 50 01             	lea    0x1(%eax),%edx
  8014b3:	89 55 08             	mov    %edx,0x8(%ebp)
  8014b6:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  8014b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8014bc:	8a 00                	mov    (%eax),%al
  8014be:	84 c0                	test   %al,%al
  8014c0:	74 18                	je     8014da <strsplit+0x52>
  8014c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c5:	8a 00                	mov    (%eax),%al
  8014c7:	0f be c0             	movsbl %al,%eax
  8014ca:	50                   	push   %eax
  8014cb:	ff 75 0c             	pushl  0xc(%ebp)
  8014ce:	e8 13 fb ff ff       	call   800fe6 <strchr>
  8014d3:	83 c4 08             	add    $0x8,%esp
  8014d6:	85 c0                	test   %eax,%eax
  8014d8:	75 d3                	jne    8014ad <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8014da:	8b 45 08             	mov    0x8(%ebp),%eax
  8014dd:	8a 00                	mov    (%eax),%al
  8014df:	84 c0                	test   %al,%al
  8014e1:	74 5a                	je     80153d <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8014e3:	8b 45 14             	mov    0x14(%ebp),%eax
  8014e6:	8b 00                	mov    (%eax),%eax
  8014e8:	83 f8 0f             	cmp    $0xf,%eax
  8014eb:	75 07                	jne    8014f4 <strsplit+0x6c>
		{
			return 0;
  8014ed:	b8 00 00 00 00       	mov    $0x0,%eax
  8014f2:	eb 66                	jmp    80155a <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8014f4:	8b 45 14             	mov    0x14(%ebp),%eax
  8014f7:	8b 00                	mov    (%eax),%eax
  8014f9:	8d 48 01             	lea    0x1(%eax),%ecx
  8014fc:	8b 55 14             	mov    0x14(%ebp),%edx
  8014ff:	89 0a                	mov    %ecx,(%edx)
  801501:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801508:	8b 45 10             	mov    0x10(%ebp),%eax
  80150b:	01 c2                	add    %eax,%edx
  80150d:	8b 45 08             	mov    0x8(%ebp),%eax
  801510:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  801512:	eb 03                	jmp    801517 <strsplit+0x8f>
			string++;
  801514:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  801517:	8b 45 08             	mov    0x8(%ebp),%eax
  80151a:	8a 00                	mov    (%eax),%al
  80151c:	84 c0                	test   %al,%al
  80151e:	74 8b                	je     8014ab <strsplit+0x23>
  801520:	8b 45 08             	mov    0x8(%ebp),%eax
  801523:	8a 00                	mov    (%eax),%al
  801525:	0f be c0             	movsbl %al,%eax
  801528:	50                   	push   %eax
  801529:	ff 75 0c             	pushl  0xc(%ebp)
  80152c:	e8 b5 fa ff ff       	call   800fe6 <strchr>
  801531:	83 c4 08             	add    $0x8,%esp
  801534:	85 c0                	test   %eax,%eax
  801536:	74 dc                	je     801514 <strsplit+0x8c>
			string++;
	}
  801538:	e9 6e ff ff ff       	jmp    8014ab <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  80153d:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  80153e:	8b 45 14             	mov    0x14(%ebp),%eax
  801541:	8b 00                	mov    (%eax),%eax
  801543:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80154a:	8b 45 10             	mov    0x10(%ebp),%eax
  80154d:	01 d0                	add    %edx,%eax
  80154f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801555:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80155a:	c9                   	leave  
  80155b:	c3                   	ret    

0080155c <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  80155c:	55                   	push   %ebp
  80155d:	89 e5                	mov    %esp,%ebp
  80155f:	57                   	push   %edi
  801560:	56                   	push   %esi
  801561:	53                   	push   %ebx
  801562:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801565:	8b 45 08             	mov    0x8(%ebp),%eax
  801568:	8b 55 0c             	mov    0xc(%ebp),%edx
  80156b:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80156e:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801571:	8b 7d 18             	mov    0x18(%ebp),%edi
  801574:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801577:	cd 30                	int    $0x30
  801579:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  80157c:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80157f:	83 c4 10             	add    $0x10,%esp
  801582:	5b                   	pop    %ebx
  801583:	5e                   	pop    %esi
  801584:	5f                   	pop    %edi
  801585:	5d                   	pop    %ebp
  801586:	c3                   	ret    

00801587 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801587:	55                   	push   %ebp
  801588:	89 e5                	mov    %esp,%ebp
  80158a:	83 ec 04             	sub    $0x4,%esp
  80158d:	8b 45 10             	mov    0x10(%ebp),%eax
  801590:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801593:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801597:	8b 45 08             	mov    0x8(%ebp),%eax
  80159a:	6a 00                	push   $0x0
  80159c:	6a 00                	push   $0x0
  80159e:	52                   	push   %edx
  80159f:	ff 75 0c             	pushl  0xc(%ebp)
  8015a2:	50                   	push   %eax
  8015a3:	6a 00                	push   $0x0
  8015a5:	e8 b2 ff ff ff       	call   80155c <syscall>
  8015aa:	83 c4 18             	add    $0x18,%esp
}
  8015ad:	90                   	nop
  8015ae:	c9                   	leave  
  8015af:	c3                   	ret    

008015b0 <sys_cgetc>:

int
sys_cgetc(void)
{
  8015b0:	55                   	push   %ebp
  8015b1:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  8015b3:	6a 00                	push   $0x0
  8015b5:	6a 00                	push   $0x0
  8015b7:	6a 00                	push   $0x0
  8015b9:	6a 00                	push   $0x0
  8015bb:	6a 00                	push   $0x0
  8015bd:	6a 01                	push   $0x1
  8015bf:	e8 98 ff ff ff       	call   80155c <syscall>
  8015c4:	83 c4 18             	add    $0x18,%esp
}
  8015c7:	c9                   	leave  
  8015c8:	c3                   	ret    

008015c9 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8015c9:	55                   	push   %ebp
  8015ca:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8015cc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8015d2:	6a 00                	push   $0x0
  8015d4:	6a 00                	push   $0x0
  8015d6:	6a 00                	push   $0x0
  8015d8:	52                   	push   %edx
  8015d9:	50                   	push   %eax
  8015da:	6a 05                	push   $0x5
  8015dc:	e8 7b ff ff ff       	call   80155c <syscall>
  8015e1:	83 c4 18             	add    $0x18,%esp
}
  8015e4:	c9                   	leave  
  8015e5:	c3                   	ret    

008015e6 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8015e6:	55                   	push   %ebp
  8015e7:	89 e5                	mov    %esp,%ebp
  8015e9:	56                   	push   %esi
  8015ea:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8015eb:	8b 75 18             	mov    0x18(%ebp),%esi
  8015ee:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8015f1:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015f4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fa:	56                   	push   %esi
  8015fb:	53                   	push   %ebx
  8015fc:	51                   	push   %ecx
  8015fd:	52                   	push   %edx
  8015fe:	50                   	push   %eax
  8015ff:	6a 06                	push   $0x6
  801601:	e8 56 ff ff ff       	call   80155c <syscall>
  801606:	83 c4 18             	add    $0x18,%esp
}
  801609:	8d 65 f8             	lea    -0x8(%ebp),%esp
  80160c:	5b                   	pop    %ebx
  80160d:	5e                   	pop    %esi
  80160e:	5d                   	pop    %ebp
  80160f:	c3                   	ret    

00801610 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  801610:	55                   	push   %ebp
  801611:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  801613:	8b 55 0c             	mov    0xc(%ebp),%edx
  801616:	8b 45 08             	mov    0x8(%ebp),%eax
  801619:	6a 00                	push   $0x0
  80161b:	6a 00                	push   $0x0
  80161d:	6a 00                	push   $0x0
  80161f:	52                   	push   %edx
  801620:	50                   	push   %eax
  801621:	6a 07                	push   $0x7
  801623:	e8 34 ff ff ff       	call   80155c <syscall>
  801628:	83 c4 18             	add    $0x18,%esp
}
  80162b:	c9                   	leave  
  80162c:	c3                   	ret    

0080162d <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  80162d:	55                   	push   %ebp
  80162e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801630:	6a 00                	push   $0x0
  801632:	6a 00                	push   $0x0
  801634:	6a 00                	push   $0x0
  801636:	ff 75 0c             	pushl  0xc(%ebp)
  801639:	ff 75 08             	pushl  0x8(%ebp)
  80163c:	6a 08                	push   $0x8
  80163e:	e8 19 ff ff ff       	call   80155c <syscall>
  801643:	83 c4 18             	add    $0x18,%esp
}
  801646:	c9                   	leave  
  801647:	c3                   	ret    

00801648 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801648:	55                   	push   %ebp
  801649:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  80164b:	6a 00                	push   $0x0
  80164d:	6a 00                	push   $0x0
  80164f:	6a 00                	push   $0x0
  801651:	6a 00                	push   $0x0
  801653:	6a 00                	push   $0x0
  801655:	6a 09                	push   $0x9
  801657:	e8 00 ff ff ff       	call   80155c <syscall>
  80165c:	83 c4 18             	add    $0x18,%esp
}
  80165f:	c9                   	leave  
  801660:	c3                   	ret    

00801661 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801661:	55                   	push   %ebp
  801662:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801664:	6a 00                	push   $0x0
  801666:	6a 00                	push   $0x0
  801668:	6a 00                	push   $0x0
  80166a:	6a 00                	push   $0x0
  80166c:	6a 00                	push   $0x0
  80166e:	6a 0a                	push   $0xa
  801670:	e8 e7 fe ff ff       	call   80155c <syscall>
  801675:	83 c4 18             	add    $0x18,%esp
}
  801678:	c9                   	leave  
  801679:	c3                   	ret    

0080167a <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80167a:	55                   	push   %ebp
  80167b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  80167d:	6a 00                	push   $0x0
  80167f:	6a 00                	push   $0x0
  801681:	6a 00                	push   $0x0
  801683:	6a 00                	push   $0x0
  801685:	6a 00                	push   $0x0
  801687:	6a 0b                	push   $0xb
  801689:	e8 ce fe ff ff       	call   80155c <syscall>
  80168e:	83 c4 18             	add    $0x18,%esp
}
  801691:	c9                   	leave  
  801692:	c3                   	ret    

00801693 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801693:	55                   	push   %ebp
  801694:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801696:	6a 00                	push   $0x0
  801698:	6a 00                	push   $0x0
  80169a:	6a 00                	push   $0x0
  80169c:	ff 75 0c             	pushl  0xc(%ebp)
  80169f:	ff 75 08             	pushl  0x8(%ebp)
  8016a2:	6a 0f                	push   $0xf
  8016a4:	e8 b3 fe ff ff       	call   80155c <syscall>
  8016a9:	83 c4 18             	add    $0x18,%esp
	return;
  8016ac:	90                   	nop
}
  8016ad:	c9                   	leave  
  8016ae:	c3                   	ret    

008016af <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  8016af:	55                   	push   %ebp
  8016b0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  8016b2:	6a 00                	push   $0x0
  8016b4:	6a 00                	push   $0x0
  8016b6:	6a 00                	push   $0x0
  8016b8:	ff 75 0c             	pushl  0xc(%ebp)
  8016bb:	ff 75 08             	pushl  0x8(%ebp)
  8016be:	6a 10                	push   $0x10
  8016c0:	e8 97 fe ff ff       	call   80155c <syscall>
  8016c5:	83 c4 18             	add    $0x18,%esp
	return ;
  8016c8:	90                   	nop
}
  8016c9:	c9                   	leave  
  8016ca:	c3                   	ret    

008016cb <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8016cb:	55                   	push   %ebp
  8016cc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8016ce:	6a 00                	push   $0x0
  8016d0:	6a 00                	push   $0x0
  8016d2:	ff 75 10             	pushl  0x10(%ebp)
  8016d5:	ff 75 0c             	pushl  0xc(%ebp)
  8016d8:	ff 75 08             	pushl  0x8(%ebp)
  8016db:	6a 11                	push   $0x11
  8016dd:	e8 7a fe ff ff       	call   80155c <syscall>
  8016e2:	83 c4 18             	add    $0x18,%esp
	return ;
  8016e5:	90                   	nop
}
  8016e6:	c9                   	leave  
  8016e7:	c3                   	ret    

008016e8 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8016e8:	55                   	push   %ebp
  8016e9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8016eb:	6a 00                	push   $0x0
  8016ed:	6a 00                	push   $0x0
  8016ef:	6a 00                	push   $0x0
  8016f1:	6a 00                	push   $0x0
  8016f3:	6a 00                	push   $0x0
  8016f5:	6a 0c                	push   $0xc
  8016f7:	e8 60 fe ff ff       	call   80155c <syscall>
  8016fc:	83 c4 18             	add    $0x18,%esp
}
  8016ff:	c9                   	leave  
  801700:	c3                   	ret    

00801701 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801701:	55                   	push   %ebp
  801702:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801704:	6a 00                	push   $0x0
  801706:	6a 00                	push   $0x0
  801708:	6a 00                	push   $0x0
  80170a:	6a 00                	push   $0x0
  80170c:	ff 75 08             	pushl  0x8(%ebp)
  80170f:	6a 0d                	push   $0xd
  801711:	e8 46 fe ff ff       	call   80155c <syscall>
  801716:	83 c4 18             	add    $0x18,%esp
}
  801719:	c9                   	leave  
  80171a:	c3                   	ret    

0080171b <sys_scarce_memory>:

void sys_scarce_memory()
{
  80171b:	55                   	push   %ebp
  80171c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  80171e:	6a 00                	push   $0x0
  801720:	6a 00                	push   $0x0
  801722:	6a 00                	push   $0x0
  801724:	6a 00                	push   $0x0
  801726:	6a 00                	push   $0x0
  801728:	6a 0e                	push   $0xe
  80172a:	e8 2d fe ff ff       	call   80155c <syscall>
  80172f:	83 c4 18             	add    $0x18,%esp
}
  801732:	90                   	nop
  801733:	c9                   	leave  
  801734:	c3                   	ret    

00801735 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801735:	55                   	push   %ebp
  801736:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801738:	6a 00                	push   $0x0
  80173a:	6a 00                	push   $0x0
  80173c:	6a 00                	push   $0x0
  80173e:	6a 00                	push   $0x0
  801740:	6a 00                	push   $0x0
  801742:	6a 13                	push   $0x13
  801744:	e8 13 fe ff ff       	call   80155c <syscall>
  801749:	83 c4 18             	add    $0x18,%esp
}
  80174c:	90                   	nop
  80174d:	c9                   	leave  
  80174e:	c3                   	ret    

0080174f <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80174f:	55                   	push   %ebp
  801750:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801752:	6a 00                	push   $0x0
  801754:	6a 00                	push   $0x0
  801756:	6a 00                	push   $0x0
  801758:	6a 00                	push   $0x0
  80175a:	6a 00                	push   $0x0
  80175c:	6a 14                	push   $0x14
  80175e:	e8 f9 fd ff ff       	call   80155c <syscall>
  801763:	83 c4 18             	add    $0x18,%esp
}
  801766:	90                   	nop
  801767:	c9                   	leave  
  801768:	c3                   	ret    

00801769 <sys_cputc>:


void
sys_cputc(const char c)
{
  801769:	55                   	push   %ebp
  80176a:	89 e5                	mov    %esp,%ebp
  80176c:	83 ec 04             	sub    $0x4,%esp
  80176f:	8b 45 08             	mov    0x8(%ebp),%eax
  801772:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801775:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801779:	6a 00                	push   $0x0
  80177b:	6a 00                	push   $0x0
  80177d:	6a 00                	push   $0x0
  80177f:	6a 00                	push   $0x0
  801781:	50                   	push   %eax
  801782:	6a 15                	push   $0x15
  801784:	e8 d3 fd ff ff       	call   80155c <syscall>
  801789:	83 c4 18             	add    $0x18,%esp
}
  80178c:	90                   	nop
  80178d:	c9                   	leave  
  80178e:	c3                   	ret    

0080178f <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80178f:	55                   	push   %ebp
  801790:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801792:	6a 00                	push   $0x0
  801794:	6a 00                	push   $0x0
  801796:	6a 00                	push   $0x0
  801798:	6a 00                	push   $0x0
  80179a:	6a 00                	push   $0x0
  80179c:	6a 16                	push   $0x16
  80179e:	e8 b9 fd ff ff       	call   80155c <syscall>
  8017a3:	83 c4 18             	add    $0x18,%esp
}
  8017a6:	90                   	nop
  8017a7:	c9                   	leave  
  8017a8:	c3                   	ret    

008017a9 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  8017a9:	55                   	push   %ebp
  8017aa:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  8017ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8017af:	6a 00                	push   $0x0
  8017b1:	6a 00                	push   $0x0
  8017b3:	6a 00                	push   $0x0
  8017b5:	ff 75 0c             	pushl  0xc(%ebp)
  8017b8:	50                   	push   %eax
  8017b9:	6a 17                	push   $0x17
  8017bb:	e8 9c fd ff ff       	call   80155c <syscall>
  8017c0:	83 c4 18             	add    $0x18,%esp
}
  8017c3:	c9                   	leave  
  8017c4:	c3                   	ret    

008017c5 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8017c5:	55                   	push   %ebp
  8017c6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8017c8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ce:	6a 00                	push   $0x0
  8017d0:	6a 00                	push   $0x0
  8017d2:	6a 00                	push   $0x0
  8017d4:	52                   	push   %edx
  8017d5:	50                   	push   %eax
  8017d6:	6a 1a                	push   $0x1a
  8017d8:	e8 7f fd ff ff       	call   80155c <syscall>
  8017dd:	83 c4 18             	add    $0x18,%esp
}
  8017e0:	c9                   	leave  
  8017e1:	c3                   	ret    

008017e2 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8017e2:	55                   	push   %ebp
  8017e3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8017e5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8017eb:	6a 00                	push   $0x0
  8017ed:	6a 00                	push   $0x0
  8017ef:	6a 00                	push   $0x0
  8017f1:	52                   	push   %edx
  8017f2:	50                   	push   %eax
  8017f3:	6a 18                	push   $0x18
  8017f5:	e8 62 fd ff ff       	call   80155c <syscall>
  8017fa:	83 c4 18             	add    $0x18,%esp
}
  8017fd:	90                   	nop
  8017fe:	c9                   	leave  
  8017ff:	c3                   	ret    

00801800 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801800:	55                   	push   %ebp
  801801:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801803:	8b 55 0c             	mov    0xc(%ebp),%edx
  801806:	8b 45 08             	mov    0x8(%ebp),%eax
  801809:	6a 00                	push   $0x0
  80180b:	6a 00                	push   $0x0
  80180d:	6a 00                	push   $0x0
  80180f:	52                   	push   %edx
  801810:	50                   	push   %eax
  801811:	6a 19                	push   $0x19
  801813:	e8 44 fd ff ff       	call   80155c <syscall>
  801818:	83 c4 18             	add    $0x18,%esp
}
  80181b:	90                   	nop
  80181c:	c9                   	leave  
  80181d:	c3                   	ret    

0080181e <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  80181e:	55                   	push   %ebp
  80181f:	89 e5                	mov    %esp,%ebp
  801821:	83 ec 04             	sub    $0x4,%esp
  801824:	8b 45 10             	mov    0x10(%ebp),%eax
  801827:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  80182a:	8b 4d 14             	mov    0x14(%ebp),%ecx
  80182d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801831:	8b 45 08             	mov    0x8(%ebp),%eax
  801834:	6a 00                	push   $0x0
  801836:	51                   	push   %ecx
  801837:	52                   	push   %edx
  801838:	ff 75 0c             	pushl  0xc(%ebp)
  80183b:	50                   	push   %eax
  80183c:	6a 1b                	push   $0x1b
  80183e:	e8 19 fd ff ff       	call   80155c <syscall>
  801843:	83 c4 18             	add    $0x18,%esp
}
  801846:	c9                   	leave  
  801847:	c3                   	ret    

00801848 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801848:	55                   	push   %ebp
  801849:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  80184b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80184e:	8b 45 08             	mov    0x8(%ebp),%eax
  801851:	6a 00                	push   $0x0
  801853:	6a 00                	push   $0x0
  801855:	6a 00                	push   $0x0
  801857:	52                   	push   %edx
  801858:	50                   	push   %eax
  801859:	6a 1c                	push   $0x1c
  80185b:	e8 fc fc ff ff       	call   80155c <syscall>
  801860:	83 c4 18             	add    $0x18,%esp
}
  801863:	c9                   	leave  
  801864:	c3                   	ret    

00801865 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801865:	55                   	push   %ebp
  801866:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801868:	8b 4d 10             	mov    0x10(%ebp),%ecx
  80186b:	8b 55 0c             	mov    0xc(%ebp),%edx
  80186e:	8b 45 08             	mov    0x8(%ebp),%eax
  801871:	6a 00                	push   $0x0
  801873:	6a 00                	push   $0x0
  801875:	51                   	push   %ecx
  801876:	52                   	push   %edx
  801877:	50                   	push   %eax
  801878:	6a 1d                	push   $0x1d
  80187a:	e8 dd fc ff ff       	call   80155c <syscall>
  80187f:	83 c4 18             	add    $0x18,%esp
}
  801882:	c9                   	leave  
  801883:	c3                   	ret    

00801884 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801884:	55                   	push   %ebp
  801885:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801887:	8b 55 0c             	mov    0xc(%ebp),%edx
  80188a:	8b 45 08             	mov    0x8(%ebp),%eax
  80188d:	6a 00                	push   $0x0
  80188f:	6a 00                	push   $0x0
  801891:	6a 00                	push   $0x0
  801893:	52                   	push   %edx
  801894:	50                   	push   %eax
  801895:	6a 1e                	push   $0x1e
  801897:	e8 c0 fc ff ff       	call   80155c <syscall>
  80189c:	83 c4 18             	add    $0x18,%esp
}
  80189f:	c9                   	leave  
  8018a0:	c3                   	ret    

008018a1 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  8018a1:	55                   	push   %ebp
  8018a2:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  8018a4:	6a 00                	push   $0x0
  8018a6:	6a 00                	push   $0x0
  8018a8:	6a 00                	push   $0x0
  8018aa:	6a 00                	push   $0x0
  8018ac:	6a 00                	push   $0x0
  8018ae:	6a 1f                	push   $0x1f
  8018b0:	e8 a7 fc ff ff       	call   80155c <syscall>
  8018b5:	83 c4 18             	add    $0x18,%esp
}
  8018b8:	c9                   	leave  
  8018b9:	c3                   	ret    

008018ba <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  8018ba:	55                   	push   %ebp
  8018bb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  8018bd:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c0:	6a 00                	push   $0x0
  8018c2:	ff 75 14             	pushl  0x14(%ebp)
  8018c5:	ff 75 10             	pushl  0x10(%ebp)
  8018c8:	ff 75 0c             	pushl  0xc(%ebp)
  8018cb:	50                   	push   %eax
  8018cc:	6a 20                	push   $0x20
  8018ce:	e8 89 fc ff ff       	call   80155c <syscall>
  8018d3:	83 c4 18             	add    $0x18,%esp
}
  8018d6:	c9                   	leave  
  8018d7:	c3                   	ret    

008018d8 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8018d8:	55                   	push   %ebp
  8018d9:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8018db:	8b 45 08             	mov    0x8(%ebp),%eax
  8018de:	6a 00                	push   $0x0
  8018e0:	6a 00                	push   $0x0
  8018e2:	6a 00                	push   $0x0
  8018e4:	6a 00                	push   $0x0
  8018e6:	50                   	push   %eax
  8018e7:	6a 21                	push   $0x21
  8018e9:	e8 6e fc ff ff       	call   80155c <syscall>
  8018ee:	83 c4 18             	add    $0x18,%esp
}
  8018f1:	90                   	nop
  8018f2:	c9                   	leave  
  8018f3:	c3                   	ret    

008018f4 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8018f4:	55                   	push   %ebp
  8018f5:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8018f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8018fa:	6a 00                	push   $0x0
  8018fc:	6a 00                	push   $0x0
  8018fe:	6a 00                	push   $0x0
  801900:	6a 00                	push   $0x0
  801902:	50                   	push   %eax
  801903:	6a 22                	push   $0x22
  801905:	e8 52 fc ff ff       	call   80155c <syscall>
  80190a:	83 c4 18             	add    $0x18,%esp
}
  80190d:	c9                   	leave  
  80190e:	c3                   	ret    

0080190f <sys_getenvid>:

int32 sys_getenvid(void)
{
  80190f:	55                   	push   %ebp
  801910:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801912:	6a 00                	push   $0x0
  801914:	6a 00                	push   $0x0
  801916:	6a 00                	push   $0x0
  801918:	6a 00                	push   $0x0
  80191a:	6a 00                	push   $0x0
  80191c:	6a 02                	push   $0x2
  80191e:	e8 39 fc ff ff       	call   80155c <syscall>
  801923:	83 c4 18             	add    $0x18,%esp
}
  801926:	c9                   	leave  
  801927:	c3                   	ret    

00801928 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801928:	55                   	push   %ebp
  801929:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  80192b:	6a 00                	push   $0x0
  80192d:	6a 00                	push   $0x0
  80192f:	6a 00                	push   $0x0
  801931:	6a 00                	push   $0x0
  801933:	6a 00                	push   $0x0
  801935:	6a 03                	push   $0x3
  801937:	e8 20 fc ff ff       	call   80155c <syscall>
  80193c:	83 c4 18             	add    $0x18,%esp
}
  80193f:	c9                   	leave  
  801940:	c3                   	ret    

00801941 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801941:	55                   	push   %ebp
  801942:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801944:	6a 00                	push   $0x0
  801946:	6a 00                	push   $0x0
  801948:	6a 00                	push   $0x0
  80194a:	6a 00                	push   $0x0
  80194c:	6a 00                	push   $0x0
  80194e:	6a 04                	push   $0x4
  801950:	e8 07 fc ff ff       	call   80155c <syscall>
  801955:	83 c4 18             	add    $0x18,%esp
}
  801958:	c9                   	leave  
  801959:	c3                   	ret    

0080195a <sys_exit_env>:


void sys_exit_env(void)
{
  80195a:	55                   	push   %ebp
  80195b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  80195d:	6a 00                	push   $0x0
  80195f:	6a 00                	push   $0x0
  801961:	6a 00                	push   $0x0
  801963:	6a 00                	push   $0x0
  801965:	6a 00                	push   $0x0
  801967:	6a 23                	push   $0x23
  801969:	e8 ee fb ff ff       	call   80155c <syscall>
  80196e:	83 c4 18             	add    $0x18,%esp
}
  801971:	90                   	nop
  801972:	c9                   	leave  
  801973:	c3                   	ret    

00801974 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801974:	55                   	push   %ebp
  801975:	89 e5                	mov    %esp,%ebp
  801977:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80197a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80197d:	8d 50 04             	lea    0x4(%eax),%edx
  801980:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801983:	6a 00                	push   $0x0
  801985:	6a 00                	push   $0x0
  801987:	6a 00                	push   $0x0
  801989:	52                   	push   %edx
  80198a:	50                   	push   %eax
  80198b:	6a 24                	push   $0x24
  80198d:	e8 ca fb ff ff       	call   80155c <syscall>
  801992:	83 c4 18             	add    $0x18,%esp
	return result;
  801995:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801998:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80199b:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80199e:	89 01                	mov    %eax,(%ecx)
  8019a0:	89 51 04             	mov    %edx,0x4(%ecx)
}
  8019a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8019a6:	c9                   	leave  
  8019a7:	c2 04 00             	ret    $0x4

008019aa <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  8019aa:	55                   	push   %ebp
  8019ab:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  8019ad:	6a 00                	push   $0x0
  8019af:	6a 00                	push   $0x0
  8019b1:	ff 75 10             	pushl  0x10(%ebp)
  8019b4:	ff 75 0c             	pushl  0xc(%ebp)
  8019b7:	ff 75 08             	pushl  0x8(%ebp)
  8019ba:	6a 12                	push   $0x12
  8019bc:	e8 9b fb ff ff       	call   80155c <syscall>
  8019c1:	83 c4 18             	add    $0x18,%esp
	return ;
  8019c4:	90                   	nop
}
  8019c5:	c9                   	leave  
  8019c6:	c3                   	ret    

008019c7 <sys_rcr2>:
uint32 sys_rcr2()
{
  8019c7:	55                   	push   %ebp
  8019c8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  8019ca:	6a 00                	push   $0x0
  8019cc:	6a 00                	push   $0x0
  8019ce:	6a 00                	push   $0x0
  8019d0:	6a 00                	push   $0x0
  8019d2:	6a 00                	push   $0x0
  8019d4:	6a 25                	push   $0x25
  8019d6:	e8 81 fb ff ff       	call   80155c <syscall>
  8019db:	83 c4 18             	add    $0x18,%esp
}
  8019de:	c9                   	leave  
  8019df:	c3                   	ret    

008019e0 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8019e0:	55                   	push   %ebp
  8019e1:	89 e5                	mov    %esp,%ebp
  8019e3:	83 ec 04             	sub    $0x4,%esp
  8019e6:	8b 45 08             	mov    0x8(%ebp),%eax
  8019e9:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8019ec:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8019f0:	6a 00                	push   $0x0
  8019f2:	6a 00                	push   $0x0
  8019f4:	6a 00                	push   $0x0
  8019f6:	6a 00                	push   $0x0
  8019f8:	50                   	push   %eax
  8019f9:	6a 26                	push   $0x26
  8019fb:	e8 5c fb ff ff       	call   80155c <syscall>
  801a00:	83 c4 18             	add    $0x18,%esp
	return ;
  801a03:	90                   	nop
}
  801a04:	c9                   	leave  
  801a05:	c3                   	ret    

00801a06 <rsttst>:
void rsttst()
{
  801a06:	55                   	push   %ebp
  801a07:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801a09:	6a 00                	push   $0x0
  801a0b:	6a 00                	push   $0x0
  801a0d:	6a 00                	push   $0x0
  801a0f:	6a 00                	push   $0x0
  801a11:	6a 00                	push   $0x0
  801a13:	6a 28                	push   $0x28
  801a15:	e8 42 fb ff ff       	call   80155c <syscall>
  801a1a:	83 c4 18             	add    $0x18,%esp
	return ;
  801a1d:	90                   	nop
}
  801a1e:	c9                   	leave  
  801a1f:	c3                   	ret    

00801a20 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801a20:	55                   	push   %ebp
  801a21:	89 e5                	mov    %esp,%ebp
  801a23:	83 ec 04             	sub    $0x4,%esp
  801a26:	8b 45 14             	mov    0x14(%ebp),%eax
  801a29:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801a2c:	8b 55 18             	mov    0x18(%ebp),%edx
  801a2f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801a33:	52                   	push   %edx
  801a34:	50                   	push   %eax
  801a35:	ff 75 10             	pushl  0x10(%ebp)
  801a38:	ff 75 0c             	pushl  0xc(%ebp)
  801a3b:	ff 75 08             	pushl  0x8(%ebp)
  801a3e:	6a 27                	push   $0x27
  801a40:	e8 17 fb ff ff       	call   80155c <syscall>
  801a45:	83 c4 18             	add    $0x18,%esp
	return ;
  801a48:	90                   	nop
}
  801a49:	c9                   	leave  
  801a4a:	c3                   	ret    

00801a4b <chktst>:
void chktst(uint32 n)
{
  801a4b:	55                   	push   %ebp
  801a4c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801a4e:	6a 00                	push   $0x0
  801a50:	6a 00                	push   $0x0
  801a52:	6a 00                	push   $0x0
  801a54:	6a 00                	push   $0x0
  801a56:	ff 75 08             	pushl  0x8(%ebp)
  801a59:	6a 29                	push   $0x29
  801a5b:	e8 fc fa ff ff       	call   80155c <syscall>
  801a60:	83 c4 18             	add    $0x18,%esp
	return ;
  801a63:	90                   	nop
}
  801a64:	c9                   	leave  
  801a65:	c3                   	ret    

00801a66 <inctst>:

void inctst()
{
  801a66:	55                   	push   %ebp
  801a67:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801a69:	6a 00                	push   $0x0
  801a6b:	6a 00                	push   $0x0
  801a6d:	6a 00                	push   $0x0
  801a6f:	6a 00                	push   $0x0
  801a71:	6a 00                	push   $0x0
  801a73:	6a 2a                	push   $0x2a
  801a75:	e8 e2 fa ff ff       	call   80155c <syscall>
  801a7a:	83 c4 18             	add    $0x18,%esp
	return ;
  801a7d:	90                   	nop
}
  801a7e:	c9                   	leave  
  801a7f:	c3                   	ret    

00801a80 <gettst>:
uint32 gettst()
{
  801a80:	55                   	push   %ebp
  801a81:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801a83:	6a 00                	push   $0x0
  801a85:	6a 00                	push   $0x0
  801a87:	6a 00                	push   $0x0
  801a89:	6a 00                	push   $0x0
  801a8b:	6a 00                	push   $0x0
  801a8d:	6a 2b                	push   $0x2b
  801a8f:	e8 c8 fa ff ff       	call   80155c <syscall>
  801a94:	83 c4 18             	add    $0x18,%esp
}
  801a97:	c9                   	leave  
  801a98:	c3                   	ret    

00801a99 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801a99:	55                   	push   %ebp
  801a9a:	89 e5                	mov    %esp,%ebp
  801a9c:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a9f:	6a 00                	push   $0x0
  801aa1:	6a 00                	push   $0x0
  801aa3:	6a 00                	push   $0x0
  801aa5:	6a 00                	push   $0x0
  801aa7:	6a 00                	push   $0x0
  801aa9:	6a 2c                	push   $0x2c
  801aab:	e8 ac fa ff ff       	call   80155c <syscall>
  801ab0:	83 c4 18             	add    $0x18,%esp
  801ab3:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801ab6:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801aba:	75 07                	jne    801ac3 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801abc:	b8 01 00 00 00       	mov    $0x1,%eax
  801ac1:	eb 05                	jmp    801ac8 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801ac3:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ac8:	c9                   	leave  
  801ac9:	c3                   	ret    

00801aca <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801aca:	55                   	push   %ebp
  801acb:	89 e5                	mov    %esp,%ebp
  801acd:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ad0:	6a 00                	push   $0x0
  801ad2:	6a 00                	push   $0x0
  801ad4:	6a 00                	push   $0x0
  801ad6:	6a 00                	push   $0x0
  801ad8:	6a 00                	push   $0x0
  801ada:	6a 2c                	push   $0x2c
  801adc:	e8 7b fa ff ff       	call   80155c <syscall>
  801ae1:	83 c4 18             	add    $0x18,%esp
  801ae4:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801ae7:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801aeb:	75 07                	jne    801af4 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801aed:	b8 01 00 00 00       	mov    $0x1,%eax
  801af2:	eb 05                	jmp    801af9 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801af4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801af9:	c9                   	leave  
  801afa:	c3                   	ret    

00801afb <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801afb:	55                   	push   %ebp
  801afc:	89 e5                	mov    %esp,%ebp
  801afe:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b01:	6a 00                	push   $0x0
  801b03:	6a 00                	push   $0x0
  801b05:	6a 00                	push   $0x0
  801b07:	6a 00                	push   $0x0
  801b09:	6a 00                	push   $0x0
  801b0b:	6a 2c                	push   $0x2c
  801b0d:	e8 4a fa ff ff       	call   80155c <syscall>
  801b12:	83 c4 18             	add    $0x18,%esp
  801b15:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801b18:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801b1c:	75 07                	jne    801b25 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801b1e:	b8 01 00 00 00       	mov    $0x1,%eax
  801b23:	eb 05                	jmp    801b2a <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801b25:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b2a:	c9                   	leave  
  801b2b:	c3                   	ret    

00801b2c <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801b2c:	55                   	push   %ebp
  801b2d:	89 e5                	mov    %esp,%ebp
  801b2f:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801b32:	6a 00                	push   $0x0
  801b34:	6a 00                	push   $0x0
  801b36:	6a 00                	push   $0x0
  801b38:	6a 00                	push   $0x0
  801b3a:	6a 00                	push   $0x0
  801b3c:	6a 2c                	push   $0x2c
  801b3e:	e8 19 fa ff ff       	call   80155c <syscall>
  801b43:	83 c4 18             	add    $0x18,%esp
  801b46:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801b49:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801b4d:	75 07                	jne    801b56 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801b4f:	b8 01 00 00 00       	mov    $0x1,%eax
  801b54:	eb 05                	jmp    801b5b <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801b56:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b5b:	c9                   	leave  
  801b5c:	c3                   	ret    

00801b5d <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801b5d:	55                   	push   %ebp
  801b5e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801b60:	6a 00                	push   $0x0
  801b62:	6a 00                	push   $0x0
  801b64:	6a 00                	push   $0x0
  801b66:	6a 00                	push   $0x0
  801b68:	ff 75 08             	pushl  0x8(%ebp)
  801b6b:	6a 2d                	push   $0x2d
  801b6d:	e8 ea f9 ff ff       	call   80155c <syscall>
  801b72:	83 c4 18             	add    $0x18,%esp
	return ;
  801b75:	90                   	nop
}
  801b76:	c9                   	leave  
  801b77:	c3                   	ret    

00801b78 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801b78:	55                   	push   %ebp
  801b79:	89 e5                	mov    %esp,%ebp
  801b7b:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801b7c:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b7f:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b82:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b85:	8b 45 08             	mov    0x8(%ebp),%eax
  801b88:	6a 00                	push   $0x0
  801b8a:	53                   	push   %ebx
  801b8b:	51                   	push   %ecx
  801b8c:	52                   	push   %edx
  801b8d:	50                   	push   %eax
  801b8e:	6a 2e                	push   $0x2e
  801b90:	e8 c7 f9 ff ff       	call   80155c <syscall>
  801b95:	83 c4 18             	add    $0x18,%esp
}
  801b98:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b9b:	c9                   	leave  
  801b9c:	c3                   	ret    

00801b9d <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801b9d:	55                   	push   %ebp
  801b9e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801ba0:	8b 55 0c             	mov    0xc(%ebp),%edx
  801ba3:	8b 45 08             	mov    0x8(%ebp),%eax
  801ba6:	6a 00                	push   $0x0
  801ba8:	6a 00                	push   $0x0
  801baa:	6a 00                	push   $0x0
  801bac:	52                   	push   %edx
  801bad:	50                   	push   %eax
  801bae:	6a 2f                	push   $0x2f
  801bb0:	e8 a7 f9 ff ff       	call   80155c <syscall>
  801bb5:	83 c4 18             	add    $0x18,%esp
}
  801bb8:	c9                   	leave  
  801bb9:	c3                   	ret    
  801bba:	66 90                	xchg   %ax,%ax

00801bbc <__udivdi3>:
  801bbc:	55                   	push   %ebp
  801bbd:	57                   	push   %edi
  801bbe:	56                   	push   %esi
  801bbf:	53                   	push   %ebx
  801bc0:	83 ec 1c             	sub    $0x1c,%esp
  801bc3:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801bc7:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801bcb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801bcf:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801bd3:	89 ca                	mov    %ecx,%edx
  801bd5:	89 f8                	mov    %edi,%eax
  801bd7:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801bdb:	85 f6                	test   %esi,%esi
  801bdd:	75 2d                	jne    801c0c <__udivdi3+0x50>
  801bdf:	39 cf                	cmp    %ecx,%edi
  801be1:	77 65                	ja     801c48 <__udivdi3+0x8c>
  801be3:	89 fd                	mov    %edi,%ebp
  801be5:	85 ff                	test   %edi,%edi
  801be7:	75 0b                	jne    801bf4 <__udivdi3+0x38>
  801be9:	b8 01 00 00 00       	mov    $0x1,%eax
  801bee:	31 d2                	xor    %edx,%edx
  801bf0:	f7 f7                	div    %edi
  801bf2:	89 c5                	mov    %eax,%ebp
  801bf4:	31 d2                	xor    %edx,%edx
  801bf6:	89 c8                	mov    %ecx,%eax
  801bf8:	f7 f5                	div    %ebp
  801bfa:	89 c1                	mov    %eax,%ecx
  801bfc:	89 d8                	mov    %ebx,%eax
  801bfe:	f7 f5                	div    %ebp
  801c00:	89 cf                	mov    %ecx,%edi
  801c02:	89 fa                	mov    %edi,%edx
  801c04:	83 c4 1c             	add    $0x1c,%esp
  801c07:	5b                   	pop    %ebx
  801c08:	5e                   	pop    %esi
  801c09:	5f                   	pop    %edi
  801c0a:	5d                   	pop    %ebp
  801c0b:	c3                   	ret    
  801c0c:	39 ce                	cmp    %ecx,%esi
  801c0e:	77 28                	ja     801c38 <__udivdi3+0x7c>
  801c10:	0f bd fe             	bsr    %esi,%edi
  801c13:	83 f7 1f             	xor    $0x1f,%edi
  801c16:	75 40                	jne    801c58 <__udivdi3+0x9c>
  801c18:	39 ce                	cmp    %ecx,%esi
  801c1a:	72 0a                	jb     801c26 <__udivdi3+0x6a>
  801c1c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801c20:	0f 87 9e 00 00 00    	ja     801cc4 <__udivdi3+0x108>
  801c26:	b8 01 00 00 00       	mov    $0x1,%eax
  801c2b:	89 fa                	mov    %edi,%edx
  801c2d:	83 c4 1c             	add    $0x1c,%esp
  801c30:	5b                   	pop    %ebx
  801c31:	5e                   	pop    %esi
  801c32:	5f                   	pop    %edi
  801c33:	5d                   	pop    %ebp
  801c34:	c3                   	ret    
  801c35:	8d 76 00             	lea    0x0(%esi),%esi
  801c38:	31 ff                	xor    %edi,%edi
  801c3a:	31 c0                	xor    %eax,%eax
  801c3c:	89 fa                	mov    %edi,%edx
  801c3e:	83 c4 1c             	add    $0x1c,%esp
  801c41:	5b                   	pop    %ebx
  801c42:	5e                   	pop    %esi
  801c43:	5f                   	pop    %edi
  801c44:	5d                   	pop    %ebp
  801c45:	c3                   	ret    
  801c46:	66 90                	xchg   %ax,%ax
  801c48:	89 d8                	mov    %ebx,%eax
  801c4a:	f7 f7                	div    %edi
  801c4c:	31 ff                	xor    %edi,%edi
  801c4e:	89 fa                	mov    %edi,%edx
  801c50:	83 c4 1c             	add    $0x1c,%esp
  801c53:	5b                   	pop    %ebx
  801c54:	5e                   	pop    %esi
  801c55:	5f                   	pop    %edi
  801c56:	5d                   	pop    %ebp
  801c57:	c3                   	ret    
  801c58:	bd 20 00 00 00       	mov    $0x20,%ebp
  801c5d:	89 eb                	mov    %ebp,%ebx
  801c5f:	29 fb                	sub    %edi,%ebx
  801c61:	89 f9                	mov    %edi,%ecx
  801c63:	d3 e6                	shl    %cl,%esi
  801c65:	89 c5                	mov    %eax,%ebp
  801c67:	88 d9                	mov    %bl,%cl
  801c69:	d3 ed                	shr    %cl,%ebp
  801c6b:	89 e9                	mov    %ebp,%ecx
  801c6d:	09 f1                	or     %esi,%ecx
  801c6f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801c73:	89 f9                	mov    %edi,%ecx
  801c75:	d3 e0                	shl    %cl,%eax
  801c77:	89 c5                	mov    %eax,%ebp
  801c79:	89 d6                	mov    %edx,%esi
  801c7b:	88 d9                	mov    %bl,%cl
  801c7d:	d3 ee                	shr    %cl,%esi
  801c7f:	89 f9                	mov    %edi,%ecx
  801c81:	d3 e2                	shl    %cl,%edx
  801c83:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c87:	88 d9                	mov    %bl,%cl
  801c89:	d3 e8                	shr    %cl,%eax
  801c8b:	09 c2                	or     %eax,%edx
  801c8d:	89 d0                	mov    %edx,%eax
  801c8f:	89 f2                	mov    %esi,%edx
  801c91:	f7 74 24 0c          	divl   0xc(%esp)
  801c95:	89 d6                	mov    %edx,%esi
  801c97:	89 c3                	mov    %eax,%ebx
  801c99:	f7 e5                	mul    %ebp
  801c9b:	39 d6                	cmp    %edx,%esi
  801c9d:	72 19                	jb     801cb8 <__udivdi3+0xfc>
  801c9f:	74 0b                	je     801cac <__udivdi3+0xf0>
  801ca1:	89 d8                	mov    %ebx,%eax
  801ca3:	31 ff                	xor    %edi,%edi
  801ca5:	e9 58 ff ff ff       	jmp    801c02 <__udivdi3+0x46>
  801caa:	66 90                	xchg   %ax,%ax
  801cac:	8b 54 24 08          	mov    0x8(%esp),%edx
  801cb0:	89 f9                	mov    %edi,%ecx
  801cb2:	d3 e2                	shl    %cl,%edx
  801cb4:	39 c2                	cmp    %eax,%edx
  801cb6:	73 e9                	jae    801ca1 <__udivdi3+0xe5>
  801cb8:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801cbb:	31 ff                	xor    %edi,%edi
  801cbd:	e9 40 ff ff ff       	jmp    801c02 <__udivdi3+0x46>
  801cc2:	66 90                	xchg   %ax,%ax
  801cc4:	31 c0                	xor    %eax,%eax
  801cc6:	e9 37 ff ff ff       	jmp    801c02 <__udivdi3+0x46>
  801ccb:	90                   	nop

00801ccc <__umoddi3>:
  801ccc:	55                   	push   %ebp
  801ccd:	57                   	push   %edi
  801cce:	56                   	push   %esi
  801ccf:	53                   	push   %ebx
  801cd0:	83 ec 1c             	sub    $0x1c,%esp
  801cd3:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801cd7:	8b 74 24 34          	mov    0x34(%esp),%esi
  801cdb:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801cdf:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801ce3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801ce7:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801ceb:	89 f3                	mov    %esi,%ebx
  801ced:	89 fa                	mov    %edi,%edx
  801cef:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801cf3:	89 34 24             	mov    %esi,(%esp)
  801cf6:	85 c0                	test   %eax,%eax
  801cf8:	75 1a                	jne    801d14 <__umoddi3+0x48>
  801cfa:	39 f7                	cmp    %esi,%edi
  801cfc:	0f 86 a2 00 00 00    	jbe    801da4 <__umoddi3+0xd8>
  801d02:	89 c8                	mov    %ecx,%eax
  801d04:	89 f2                	mov    %esi,%edx
  801d06:	f7 f7                	div    %edi
  801d08:	89 d0                	mov    %edx,%eax
  801d0a:	31 d2                	xor    %edx,%edx
  801d0c:	83 c4 1c             	add    $0x1c,%esp
  801d0f:	5b                   	pop    %ebx
  801d10:	5e                   	pop    %esi
  801d11:	5f                   	pop    %edi
  801d12:	5d                   	pop    %ebp
  801d13:	c3                   	ret    
  801d14:	39 f0                	cmp    %esi,%eax
  801d16:	0f 87 ac 00 00 00    	ja     801dc8 <__umoddi3+0xfc>
  801d1c:	0f bd e8             	bsr    %eax,%ebp
  801d1f:	83 f5 1f             	xor    $0x1f,%ebp
  801d22:	0f 84 ac 00 00 00    	je     801dd4 <__umoddi3+0x108>
  801d28:	bf 20 00 00 00       	mov    $0x20,%edi
  801d2d:	29 ef                	sub    %ebp,%edi
  801d2f:	89 fe                	mov    %edi,%esi
  801d31:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801d35:	89 e9                	mov    %ebp,%ecx
  801d37:	d3 e0                	shl    %cl,%eax
  801d39:	89 d7                	mov    %edx,%edi
  801d3b:	89 f1                	mov    %esi,%ecx
  801d3d:	d3 ef                	shr    %cl,%edi
  801d3f:	09 c7                	or     %eax,%edi
  801d41:	89 e9                	mov    %ebp,%ecx
  801d43:	d3 e2                	shl    %cl,%edx
  801d45:	89 14 24             	mov    %edx,(%esp)
  801d48:	89 d8                	mov    %ebx,%eax
  801d4a:	d3 e0                	shl    %cl,%eax
  801d4c:	89 c2                	mov    %eax,%edx
  801d4e:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d52:	d3 e0                	shl    %cl,%eax
  801d54:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d58:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d5c:	89 f1                	mov    %esi,%ecx
  801d5e:	d3 e8                	shr    %cl,%eax
  801d60:	09 d0                	or     %edx,%eax
  801d62:	d3 eb                	shr    %cl,%ebx
  801d64:	89 da                	mov    %ebx,%edx
  801d66:	f7 f7                	div    %edi
  801d68:	89 d3                	mov    %edx,%ebx
  801d6a:	f7 24 24             	mull   (%esp)
  801d6d:	89 c6                	mov    %eax,%esi
  801d6f:	89 d1                	mov    %edx,%ecx
  801d71:	39 d3                	cmp    %edx,%ebx
  801d73:	0f 82 87 00 00 00    	jb     801e00 <__umoddi3+0x134>
  801d79:	0f 84 91 00 00 00    	je     801e10 <__umoddi3+0x144>
  801d7f:	8b 54 24 04          	mov    0x4(%esp),%edx
  801d83:	29 f2                	sub    %esi,%edx
  801d85:	19 cb                	sbb    %ecx,%ebx
  801d87:	89 d8                	mov    %ebx,%eax
  801d89:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801d8d:	d3 e0                	shl    %cl,%eax
  801d8f:	89 e9                	mov    %ebp,%ecx
  801d91:	d3 ea                	shr    %cl,%edx
  801d93:	09 d0                	or     %edx,%eax
  801d95:	89 e9                	mov    %ebp,%ecx
  801d97:	d3 eb                	shr    %cl,%ebx
  801d99:	89 da                	mov    %ebx,%edx
  801d9b:	83 c4 1c             	add    $0x1c,%esp
  801d9e:	5b                   	pop    %ebx
  801d9f:	5e                   	pop    %esi
  801da0:	5f                   	pop    %edi
  801da1:	5d                   	pop    %ebp
  801da2:	c3                   	ret    
  801da3:	90                   	nop
  801da4:	89 fd                	mov    %edi,%ebp
  801da6:	85 ff                	test   %edi,%edi
  801da8:	75 0b                	jne    801db5 <__umoddi3+0xe9>
  801daa:	b8 01 00 00 00       	mov    $0x1,%eax
  801daf:	31 d2                	xor    %edx,%edx
  801db1:	f7 f7                	div    %edi
  801db3:	89 c5                	mov    %eax,%ebp
  801db5:	89 f0                	mov    %esi,%eax
  801db7:	31 d2                	xor    %edx,%edx
  801db9:	f7 f5                	div    %ebp
  801dbb:	89 c8                	mov    %ecx,%eax
  801dbd:	f7 f5                	div    %ebp
  801dbf:	89 d0                	mov    %edx,%eax
  801dc1:	e9 44 ff ff ff       	jmp    801d0a <__umoddi3+0x3e>
  801dc6:	66 90                	xchg   %ax,%ax
  801dc8:	89 c8                	mov    %ecx,%eax
  801dca:	89 f2                	mov    %esi,%edx
  801dcc:	83 c4 1c             	add    $0x1c,%esp
  801dcf:	5b                   	pop    %ebx
  801dd0:	5e                   	pop    %esi
  801dd1:	5f                   	pop    %edi
  801dd2:	5d                   	pop    %ebp
  801dd3:	c3                   	ret    
  801dd4:	3b 04 24             	cmp    (%esp),%eax
  801dd7:	72 06                	jb     801ddf <__umoddi3+0x113>
  801dd9:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801ddd:	77 0f                	ja     801dee <__umoddi3+0x122>
  801ddf:	89 f2                	mov    %esi,%edx
  801de1:	29 f9                	sub    %edi,%ecx
  801de3:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801de7:	89 14 24             	mov    %edx,(%esp)
  801dea:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801dee:	8b 44 24 04          	mov    0x4(%esp),%eax
  801df2:	8b 14 24             	mov    (%esp),%edx
  801df5:	83 c4 1c             	add    $0x1c,%esp
  801df8:	5b                   	pop    %ebx
  801df9:	5e                   	pop    %esi
  801dfa:	5f                   	pop    %edi
  801dfb:	5d                   	pop    %ebp
  801dfc:	c3                   	ret    
  801dfd:	8d 76 00             	lea    0x0(%esi),%esi
  801e00:	2b 04 24             	sub    (%esp),%eax
  801e03:	19 fa                	sbb    %edi,%edx
  801e05:	89 d1                	mov    %edx,%ecx
  801e07:	89 c6                	mov    %eax,%esi
  801e09:	e9 71 ff ff ff       	jmp    801d7f <__umoddi3+0xb3>
  801e0e:	66 90                	xchg   %ax,%ax
  801e10:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801e14:	72 ea                	jb     801e00 <__umoddi3+0x134>
  801e16:	89 d9                	mov    %ebx,%ecx
  801e18:	e9 62 ff ff ff       	jmp    801d7f <__umoddi3+0xb3>
