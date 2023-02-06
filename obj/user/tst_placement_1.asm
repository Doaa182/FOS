
obj/user/tst_placement_1:     file format elf32-i386


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
  800031:	e8 41 03 00 00       	call   800377 <libmain>
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

	//	cprintf("envID = %d\n",envID);
	char arr[PAGE_SIZE*1024*4];

	uint32 actual_active_list[17] = {0xedbfdb78,0xeebfd000,0x803000,0x802000,0x801000,0x800000,0x205000,0x204000,0x203000,0x202000,0x201000,0x200000};
  800043:	8d 95 9c ff ff fe    	lea    -0x1000064(%ebp),%edx
  800049:	b9 11 00 00 00       	mov    $0x11,%ecx
  80004e:	b8 00 00 00 00       	mov    $0x0,%eax
  800053:	89 d7                	mov    %edx,%edi
  800055:	f3 ab                	rep stos %eax,%es:(%edi)
  800057:	c7 85 9c ff ff fe 78 	movl   $0xedbfdb78,-0x1000064(%ebp)
  80005e:	db bf ed 
  800061:	c7 85 a0 ff ff fe 00 	movl   $0xeebfd000,-0x1000060(%ebp)
  800068:	d0 bf ee 
  80006b:	c7 85 a4 ff ff fe 00 	movl   $0x803000,-0x100005c(%ebp)
  800072:	30 80 00 
  800075:	c7 85 a8 ff ff fe 00 	movl   $0x802000,-0x1000058(%ebp)
  80007c:	20 80 00 
  80007f:	c7 85 ac ff ff fe 00 	movl   $0x801000,-0x1000054(%ebp)
  800086:	10 80 00 
  800089:	c7 85 b0 ff ff fe 00 	movl   $0x800000,-0x1000050(%ebp)
  800090:	00 80 00 
  800093:	c7 85 b4 ff ff fe 00 	movl   $0x205000,-0x100004c(%ebp)
  80009a:	50 20 00 
  80009d:	c7 85 b8 ff ff fe 00 	movl   $0x204000,-0x1000048(%ebp)
  8000a4:	40 20 00 
  8000a7:	c7 85 bc ff ff fe 00 	movl   $0x203000,-0x1000044(%ebp)
  8000ae:	30 20 00 
  8000b1:	c7 85 c0 ff ff fe 00 	movl   $0x202000,-0x1000040(%ebp)
  8000b8:	20 20 00 
  8000bb:	c7 85 c4 ff ff fe 00 	movl   $0x201000,-0x100003c(%ebp)
  8000c2:	10 20 00 
  8000c5:	c7 85 c8 ff ff fe 00 	movl   $0x200000,-0x1000038(%ebp)
  8000cc:	00 20 00 
	uint32 actual_second_list[2] = {};
  8000cf:	c7 85 94 ff ff fe 00 	movl   $0x0,-0x100006c(%ebp)
  8000d6:	00 00 00 
  8000d9:	c7 85 98 ff ff fe 00 	movl   $0x0,-0x1000068(%ebp)
  8000e0:	00 00 00 
	("STEP 0: checking Initial LRU lists entries ...\n");
	{
		int check = sys_check_LRU_lists(actual_active_list, actual_second_list, 12, 0);
  8000e3:	6a 00                	push   $0x0
  8000e5:	6a 0c                	push   $0xc
  8000e7:	8d 85 94 ff ff fe    	lea    -0x100006c(%ebp),%eax
  8000ed:	50                   	push   %eax
  8000ee:	8d 85 9c ff ff fe    	lea    -0x1000064(%ebp),%eax
  8000f4:	50                   	push   %eax
  8000f5:	e8 13 1a 00 00       	call   801b0d <sys_check_LRU_lists>
  8000fa:	83 c4 10             	add    $0x10,%esp
  8000fd:	89 45 ec             	mov    %eax,-0x14(%ebp)
		if(check == 0)
  800100:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800104:	75 14                	jne    80011a <_main+0xe2>
			panic("INITIAL PAGE LRU LISTs entry checking failed! Review size of the LRU lists..!!");
  800106:	83 ec 04             	sub    $0x4,%esp
  800109:	68 c0 1d 80 00       	push   $0x801dc0
  80010e:	6a 15                	push   $0x15
  800110:	68 0f 1e 80 00       	push   $0x801e0f
  800115:	e8 99 03 00 00       	call   8004b3 <_panic>
	}

	int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80011a:	e8 5e 15 00 00       	call   80167d <sys_pf_calculate_allocated_pages>
  80011f:	89 45 e8             	mov    %eax,-0x18(%ebp)
	int freePages = sys_calculate_free_frames();
  800122:	e8 b6 14 00 00       	call   8015dd <sys_calculate_free_frames>
  800127:	89 45 e4             	mov    %eax,-0x1c(%ebp)

	int i=0;
  80012a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for(;i<=PAGE_SIZE;i++)
  800131:	eb 11                	jmp    800144 <_main+0x10c>
	{
		arr[i] = -1;
  800133:	8d 95 e0 ff ff fe    	lea    -0x1000020(%ebp),%edx
  800139:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80013c:	01 d0                	add    %edx,%eax
  80013e:	c6 00 ff             	movb   $0xff,(%eax)

	int usedDiskPages = sys_pf_calculate_allocated_pages() ;
	int freePages = sys_calculate_free_frames();

	int i=0;
	for(;i<=PAGE_SIZE;i++)
  800141:	ff 45 f4             	incl   -0xc(%ebp)
  800144:	81 7d f4 00 10 00 00 	cmpl   $0x1000,-0xc(%ebp)
  80014b:	7e e6                	jle    800133 <_main+0xfb>
	{
		arr[i] = -1;
	}

	i=PAGE_SIZE*1024;
  80014d:	c7 45 f4 00 00 40 00 	movl   $0x400000,-0xc(%ebp)
	for(;i<=(PAGE_SIZE*1024 + PAGE_SIZE);i++)
  800154:	eb 11                	jmp    800167 <_main+0x12f>
	{
		arr[i] = -1;
  800156:	8d 95 e0 ff ff fe    	lea    -0x1000020(%ebp),%edx
  80015c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80015f:	01 d0                	add    %edx,%eax
  800161:	c6 00 ff             	movb   $0xff,(%eax)
	{
		arr[i] = -1;
	}

	i=PAGE_SIZE*1024;
	for(;i<=(PAGE_SIZE*1024 + PAGE_SIZE);i++)
  800164:	ff 45 f4             	incl   -0xc(%ebp)
  800167:	81 7d f4 00 10 40 00 	cmpl   $0x401000,-0xc(%ebp)
  80016e:	7e e6                	jle    800156 <_main+0x11e>
	{
		arr[i] = -1;
	}

	i=PAGE_SIZE*1024*2;
  800170:	c7 45 f4 00 00 80 00 	movl   $0x800000,-0xc(%ebp)
	for(;i<=(PAGE_SIZE*1024*2 + PAGE_SIZE);i++)
  800177:	eb 11                	jmp    80018a <_main+0x152>
	{
		arr[i] = -1;
  800179:	8d 95 e0 ff ff fe    	lea    -0x1000020(%ebp),%edx
  80017f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800182:	01 d0                	add    %edx,%eax
  800184:	c6 00 ff             	movb   $0xff,(%eax)
	{
		arr[i] = -1;
	}

	i=PAGE_SIZE*1024*2;
	for(;i<=(PAGE_SIZE*1024*2 + PAGE_SIZE);i++)
  800187:	ff 45 f4             	incl   -0xc(%ebp)
  80018a:	81 7d f4 00 10 80 00 	cmpl   $0x801000,-0xc(%ebp)
  800191:	7e e6                	jle    800179 <_main+0x141>
		arr[i] = -1;
	}



	cprintf("STEP A: checking PLACEMENT fault handling ... \n");
  800193:	83 ec 0c             	sub    $0xc,%esp
  800196:	68 28 1e 80 00       	push   $0x801e28
  80019b:	e8 c7 05 00 00       	call   800767 <cprintf>
  8001a0:	83 c4 10             	add    $0x10,%esp
	{
		if( arr[0] !=  -1)  panic("PLACEMENT of stack page failed");
  8001a3:	8a 85 e0 ff ff fe    	mov    -0x1000020(%ebp),%al
  8001a9:	3c ff                	cmp    $0xff,%al
  8001ab:	74 14                	je     8001c1 <_main+0x189>
  8001ad:	83 ec 04             	sub    $0x4,%esp
  8001b0:	68 58 1e 80 00       	push   $0x801e58
  8001b5:	6a 31                	push   $0x31
  8001b7:	68 0f 1e 80 00       	push   $0x801e0f
  8001bc:	e8 f2 02 00 00       	call   8004b3 <_panic>
		if( arr[PAGE_SIZE] !=  -1)  panic("PLACEMENT of stack page failed");
  8001c1:	8a 85 e0 0f 00 ff    	mov    -0xfff020(%ebp),%al
  8001c7:	3c ff                	cmp    $0xff,%al
  8001c9:	74 14                	je     8001df <_main+0x1a7>
  8001cb:	83 ec 04             	sub    $0x4,%esp
  8001ce:	68 58 1e 80 00       	push   $0x801e58
  8001d3:	6a 32                	push   $0x32
  8001d5:	68 0f 1e 80 00       	push   $0x801e0f
  8001da:	e8 d4 02 00 00       	call   8004b3 <_panic>

		if( arr[PAGE_SIZE*1024] !=  -1)  panic("PLACEMENT of stack page failed");
  8001df:	8a 85 e0 ff 3f ff    	mov    -0xc00020(%ebp),%al
  8001e5:	3c ff                	cmp    $0xff,%al
  8001e7:	74 14                	je     8001fd <_main+0x1c5>
  8001e9:	83 ec 04             	sub    $0x4,%esp
  8001ec:	68 58 1e 80 00       	push   $0x801e58
  8001f1:	6a 34                	push   $0x34
  8001f3:	68 0f 1e 80 00       	push   $0x801e0f
  8001f8:	e8 b6 02 00 00       	call   8004b3 <_panic>
		if( arr[PAGE_SIZE*1025] !=  -1)  panic("PLACEMENT of stack page failed");
  8001fd:	8a 85 e0 0f 40 ff    	mov    -0xbff020(%ebp),%al
  800203:	3c ff                	cmp    $0xff,%al
  800205:	74 14                	je     80021b <_main+0x1e3>
  800207:	83 ec 04             	sub    $0x4,%esp
  80020a:	68 58 1e 80 00       	push   $0x801e58
  80020f:	6a 35                	push   $0x35
  800211:	68 0f 1e 80 00       	push   $0x801e0f
  800216:	e8 98 02 00 00       	call   8004b3 <_panic>

		if( arr[PAGE_SIZE*1024*2] !=  -1)  panic("PLACEMENT of stack page failed");
  80021b:	8a 85 e0 ff 7f ff    	mov    -0x800020(%ebp),%al
  800221:	3c ff                	cmp    $0xff,%al
  800223:	74 14                	je     800239 <_main+0x201>
  800225:	83 ec 04             	sub    $0x4,%esp
  800228:	68 58 1e 80 00       	push   $0x801e58
  80022d:	6a 37                	push   $0x37
  80022f:	68 0f 1e 80 00       	push   $0x801e0f
  800234:	e8 7a 02 00 00       	call   8004b3 <_panic>
		if( arr[PAGE_SIZE*1024*2 + PAGE_SIZE] !=  -1)  panic("PLACEMENT of stack page failed");
  800239:	8a 85 e0 0f 80 ff    	mov    -0x7ff020(%ebp),%al
  80023f:	3c ff                	cmp    $0xff,%al
  800241:	74 14                	je     800257 <_main+0x21f>
  800243:	83 ec 04             	sub    $0x4,%esp
  800246:	68 58 1e 80 00       	push   $0x801e58
  80024b:	6a 38                	push   $0x38
  80024d:	68 0f 1e 80 00       	push   $0x801e0f
  800252:	e8 5c 02 00 00       	call   8004b3 <_panic>

		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  5) panic("new stack pages are not written to Page File");
  800257:	e8 21 14 00 00       	call   80167d <sys_pf_calculate_allocated_pages>
  80025c:	2b 45 e8             	sub    -0x18(%ebp),%eax
  80025f:	83 f8 05             	cmp    $0x5,%eax
  800262:	74 14                	je     800278 <_main+0x240>
  800264:	83 ec 04             	sub    $0x4,%esp
  800267:	68 78 1e 80 00       	push   $0x801e78
  80026c:	6a 3a                	push   $0x3a
  80026e:	68 0f 1e 80 00       	push   $0x801e0f
  800273:	e8 3b 02 00 00       	call   8004b3 <_panic>

		if( (freePages - sys_calculate_free_frames() ) != 9 ) panic("allocated memory size incorrect");
  800278:	8b 5d e4             	mov    -0x1c(%ebp),%ebx
  80027b:	e8 5d 13 00 00       	call   8015dd <sys_calculate_free_frames>
  800280:	29 c3                	sub    %eax,%ebx
  800282:	89 d8                	mov    %ebx,%eax
  800284:	83 f8 09             	cmp    $0x9,%eax
  800287:	74 14                	je     80029d <_main+0x265>
  800289:	83 ec 04             	sub    $0x4,%esp
  80028c:	68 a8 1e 80 00       	push   $0x801ea8
  800291:	6a 3c                	push   $0x3c
  800293:	68 0f 1e 80 00       	push   $0x801e0f
  800298:	e8 16 02 00 00       	call   8004b3 <_panic>
	}
	cprintf("STEP A passed: PLACEMENT fault handling works!\n\n\n");
  80029d:	83 ec 0c             	sub    $0xc,%esp
  8002a0:	68 c8 1e 80 00       	push   $0x801ec8
  8002a5:	e8 bd 04 00 00       	call   800767 <cprintf>
  8002aa:	83 c4 10             	add    $0x10,%esp

	for (int i=16;i>4;i--)
  8002ad:	c7 45 f0 10 00 00 00 	movl   $0x10,-0x10(%ebp)
  8002b4:	eb 1a                	jmp    8002d0 <_main+0x298>
		actual_active_list[i]=actual_active_list[i-5];
  8002b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002b9:	83 e8 05             	sub    $0x5,%eax
  8002bc:	8b 94 85 9c ff ff fe 	mov    -0x1000064(%ebp,%eax,4),%edx
  8002c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002c6:	89 94 85 9c ff ff fe 	mov    %edx,-0x1000064(%ebp,%eax,4)

		if( (freePages - sys_calculate_free_frames() ) != 9 ) panic("allocated memory size incorrect");
	}
	cprintf("STEP A passed: PLACEMENT fault handling works!\n\n\n");

	for (int i=16;i>4;i--)
  8002cd:	ff 4d f0             	decl   -0x10(%ebp)
  8002d0:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
  8002d4:	7f e0                	jg     8002b6 <_main+0x27e>
		actual_active_list[i]=actual_active_list[i-5];

	actual_active_list[0]=0xee3fe000;
  8002d6:	c7 85 9c ff ff fe 00 	movl   $0xee3fe000,-0x1000064(%ebp)
  8002dd:	e0 3f ee 
	actual_active_list[1]=0xee3fdfa4;
  8002e0:	c7 85 a0 ff ff fe a4 	movl   $0xee3fdfa4,-0x1000060(%ebp)
  8002e7:	df 3f ee 
	actual_active_list[2]=0xedffe000;
  8002ea:	c7 85 a4 ff ff fe 00 	movl   $0xedffe000,-0x100005c(%ebp)
  8002f1:	e0 ff ed 
	actual_active_list[3]=0xedffdfa4;
  8002f4:	c7 85 a8 ff ff fe a4 	movl   $0xedffdfa4,-0x1000058(%ebp)
  8002fb:	df ff ed 
	actual_active_list[4]=0xedbfe000;
  8002fe:	c7 85 ac ff ff fe 00 	movl   $0xedbfe000,-0x1000054(%ebp)
  800305:	e0 bf ed 

	cprintf("STEP B: checking LRU lists entries ...\n");
  800308:	83 ec 0c             	sub    $0xc,%esp
  80030b:	68 fc 1e 80 00       	push   $0x801efc
  800310:	e8 52 04 00 00       	call   800767 <cprintf>
  800315:	83 c4 10             	add    $0x10,%esp
	{
		int check = sys_check_LRU_lists(actual_active_list, actual_second_list, 17, 0);
  800318:	6a 00                	push   $0x0
  80031a:	6a 11                	push   $0x11
  80031c:	8d 85 94 ff ff fe    	lea    -0x100006c(%ebp),%eax
  800322:	50                   	push   %eax
  800323:	8d 85 9c ff ff fe    	lea    -0x1000064(%ebp),%eax
  800329:	50                   	push   %eax
  80032a:	e8 de 17 00 00       	call   801b0d <sys_check_LRU_lists>
  80032f:	83 c4 10             	add    $0x10,%esp
  800332:	89 45 e0             	mov    %eax,-0x20(%ebp)
			if(check == 0)
  800335:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800339:	75 14                	jne    80034f <_main+0x317>
				panic("LRU lists entries are not correct, check your logic again!!");
  80033b:	83 ec 04             	sub    $0x4,%esp
  80033e:	68 24 1f 80 00       	push   $0x801f24
  800343:	6a 4d                	push   $0x4d
  800345:	68 0f 1e 80 00       	push   $0x801e0f
  80034a:	e8 64 01 00 00       	call   8004b3 <_panic>
	}
	cprintf("STEP B passed: LRU lists entries test are correct\n\n\n");
  80034f:	83 ec 0c             	sub    $0xc,%esp
  800352:	68 60 1f 80 00       	push   $0x801f60
  800357:	e8 0b 04 00 00       	call   800767 <cprintf>
  80035c:	83 c4 10             	add    $0x10,%esp

	cprintf("Congratulations!! Test of PAGE PLACEMENT FIRST SCENARIO completed successfully!!\n\n\n");
  80035f:	83 ec 0c             	sub    $0xc,%esp
  800362:	68 98 1f 80 00       	push   $0x801f98
  800367:	e8 fb 03 00 00       	call   800767 <cprintf>
  80036c:	83 c4 10             	add    $0x10,%esp
	return;
  80036f:	90                   	nop
}
  800370:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800373:	5b                   	pop    %ebx
  800374:	5f                   	pop    %edi
  800375:	5d                   	pop    %ebp
  800376:	c3                   	ret    

00800377 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  800377:	55                   	push   %ebp
  800378:	89 e5                	mov    %esp,%ebp
  80037a:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  80037d:	e8 3b 15 00 00       	call   8018bd <sys_getenvindex>
  800382:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  800385:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800388:	89 d0                	mov    %edx,%eax
  80038a:	c1 e0 03             	shl    $0x3,%eax
  80038d:	01 d0                	add    %edx,%eax
  80038f:	01 c0                	add    %eax,%eax
  800391:	01 d0                	add    %edx,%eax
  800393:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80039a:	01 d0                	add    %edx,%eax
  80039c:	c1 e0 04             	shl    $0x4,%eax
  80039f:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8003a4:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8003a9:	a1 20 30 80 00       	mov    0x803020,%eax
  8003ae:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8003b4:	84 c0                	test   %al,%al
  8003b6:	74 0f                	je     8003c7 <libmain+0x50>
		binaryname = myEnv->prog_name;
  8003b8:	a1 20 30 80 00       	mov    0x803020,%eax
  8003bd:	05 5c 05 00 00       	add    $0x55c,%eax
  8003c2:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8003c7:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8003cb:	7e 0a                	jle    8003d7 <libmain+0x60>
		binaryname = argv[0];
  8003cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003d0:	8b 00                	mov    (%eax),%eax
  8003d2:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  8003d7:	83 ec 08             	sub    $0x8,%esp
  8003da:	ff 75 0c             	pushl  0xc(%ebp)
  8003dd:	ff 75 08             	pushl  0x8(%ebp)
  8003e0:	e8 53 fc ff ff       	call   800038 <_main>
  8003e5:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  8003e8:	e8 dd 12 00 00       	call   8016ca <sys_disable_interrupt>
	cprintf("**************************************\n");
  8003ed:	83 ec 0c             	sub    $0xc,%esp
  8003f0:	68 04 20 80 00       	push   $0x802004
  8003f5:	e8 6d 03 00 00       	call   800767 <cprintf>
  8003fa:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  8003fd:	a1 20 30 80 00       	mov    0x803020,%eax
  800402:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800408:	a1 20 30 80 00       	mov    0x803020,%eax
  80040d:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800413:	83 ec 04             	sub    $0x4,%esp
  800416:	52                   	push   %edx
  800417:	50                   	push   %eax
  800418:	68 2c 20 80 00       	push   $0x80202c
  80041d:	e8 45 03 00 00       	call   800767 <cprintf>
  800422:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800425:	a1 20 30 80 00       	mov    0x803020,%eax
  80042a:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800430:	a1 20 30 80 00       	mov    0x803020,%eax
  800435:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  80043b:	a1 20 30 80 00       	mov    0x803020,%eax
  800440:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800446:	51                   	push   %ecx
  800447:	52                   	push   %edx
  800448:	50                   	push   %eax
  800449:	68 54 20 80 00       	push   $0x802054
  80044e:	e8 14 03 00 00       	call   800767 <cprintf>
  800453:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  800456:	a1 20 30 80 00       	mov    0x803020,%eax
  80045b:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800461:	83 ec 08             	sub    $0x8,%esp
  800464:	50                   	push   %eax
  800465:	68 ac 20 80 00       	push   $0x8020ac
  80046a:	e8 f8 02 00 00       	call   800767 <cprintf>
  80046f:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  800472:	83 ec 0c             	sub    $0xc,%esp
  800475:	68 04 20 80 00       	push   $0x802004
  80047a:	e8 e8 02 00 00       	call   800767 <cprintf>
  80047f:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  800482:	e8 5d 12 00 00       	call   8016e4 <sys_enable_interrupt>

	// exit gracefully
	exit();
  800487:	e8 19 00 00 00       	call   8004a5 <exit>
}
  80048c:	90                   	nop
  80048d:	c9                   	leave  
  80048e:	c3                   	ret    

0080048f <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  80048f:	55                   	push   %ebp
  800490:	89 e5                	mov    %esp,%ebp
  800492:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  800495:	83 ec 0c             	sub    $0xc,%esp
  800498:	6a 00                	push   $0x0
  80049a:	e8 ea 13 00 00       	call   801889 <sys_destroy_env>
  80049f:	83 c4 10             	add    $0x10,%esp
}
  8004a2:	90                   	nop
  8004a3:	c9                   	leave  
  8004a4:	c3                   	ret    

008004a5 <exit>:

void
exit(void)
{
  8004a5:	55                   	push   %ebp
  8004a6:	89 e5                	mov    %esp,%ebp
  8004a8:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8004ab:	e8 3f 14 00 00       	call   8018ef <sys_exit_env>
}
  8004b0:	90                   	nop
  8004b1:	c9                   	leave  
  8004b2:	c3                   	ret    

008004b3 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8004b3:	55                   	push   %ebp
  8004b4:	89 e5                	mov    %esp,%ebp
  8004b6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8004b9:	8d 45 10             	lea    0x10(%ebp),%eax
  8004bc:	83 c0 04             	add    $0x4,%eax
  8004bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8004c2:	a1 5c 31 80 00       	mov    0x80315c,%eax
  8004c7:	85 c0                	test   %eax,%eax
  8004c9:	74 16                	je     8004e1 <_panic+0x2e>
		cprintf("%s: ", argv0);
  8004cb:	a1 5c 31 80 00       	mov    0x80315c,%eax
  8004d0:	83 ec 08             	sub    $0x8,%esp
  8004d3:	50                   	push   %eax
  8004d4:	68 c0 20 80 00       	push   $0x8020c0
  8004d9:	e8 89 02 00 00       	call   800767 <cprintf>
  8004de:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  8004e1:	a1 00 30 80 00       	mov    0x803000,%eax
  8004e6:	ff 75 0c             	pushl  0xc(%ebp)
  8004e9:	ff 75 08             	pushl  0x8(%ebp)
  8004ec:	50                   	push   %eax
  8004ed:	68 c5 20 80 00       	push   $0x8020c5
  8004f2:	e8 70 02 00 00       	call   800767 <cprintf>
  8004f7:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  8004fa:	8b 45 10             	mov    0x10(%ebp),%eax
  8004fd:	83 ec 08             	sub    $0x8,%esp
  800500:	ff 75 f4             	pushl  -0xc(%ebp)
  800503:	50                   	push   %eax
  800504:	e8 f3 01 00 00       	call   8006fc <vcprintf>
  800509:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80050c:	83 ec 08             	sub    $0x8,%esp
  80050f:	6a 00                	push   $0x0
  800511:	68 e1 20 80 00       	push   $0x8020e1
  800516:	e8 e1 01 00 00       	call   8006fc <vcprintf>
  80051b:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80051e:	e8 82 ff ff ff       	call   8004a5 <exit>

	// should not return here
	while (1) ;
  800523:	eb fe                	jmp    800523 <_panic+0x70>

00800525 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800525:	55                   	push   %ebp
  800526:	89 e5                	mov    %esp,%ebp
  800528:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80052b:	a1 20 30 80 00       	mov    0x803020,%eax
  800530:	8b 50 74             	mov    0x74(%eax),%edx
  800533:	8b 45 0c             	mov    0xc(%ebp),%eax
  800536:	39 c2                	cmp    %eax,%edx
  800538:	74 14                	je     80054e <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80053a:	83 ec 04             	sub    $0x4,%esp
  80053d:	68 e4 20 80 00       	push   $0x8020e4
  800542:	6a 26                	push   $0x26
  800544:	68 30 21 80 00       	push   $0x802130
  800549:	e8 65 ff ff ff       	call   8004b3 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80054e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  800555:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  80055c:	e9 c2 00 00 00       	jmp    800623 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800561:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800564:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80056b:	8b 45 08             	mov    0x8(%ebp),%eax
  80056e:	01 d0                	add    %edx,%eax
  800570:	8b 00                	mov    (%eax),%eax
  800572:	85 c0                	test   %eax,%eax
  800574:	75 08                	jne    80057e <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  800576:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  800579:	e9 a2 00 00 00       	jmp    800620 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  80057e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800585:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  80058c:	eb 69                	jmp    8005f7 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  80058e:	a1 20 30 80 00       	mov    0x803020,%eax
  800593:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800599:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80059c:	89 d0                	mov    %edx,%eax
  80059e:	01 c0                	add    %eax,%eax
  8005a0:	01 d0                	add    %edx,%eax
  8005a2:	c1 e0 03             	shl    $0x3,%eax
  8005a5:	01 c8                	add    %ecx,%eax
  8005a7:	8a 40 04             	mov    0x4(%eax),%al
  8005aa:	84 c0                	test   %al,%al
  8005ac:	75 46                	jne    8005f4 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005ae:	a1 20 30 80 00       	mov    0x803020,%eax
  8005b3:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8005b9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005bc:	89 d0                	mov    %edx,%eax
  8005be:	01 c0                	add    %eax,%eax
  8005c0:	01 d0                	add    %edx,%eax
  8005c2:	c1 e0 03             	shl    $0x3,%eax
  8005c5:	01 c8                	add    %ecx,%eax
  8005c7:	8b 00                	mov    (%eax),%eax
  8005c9:	89 45 dc             	mov    %eax,-0x24(%ebp)
  8005cc:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005cf:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8005d4:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  8005d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8005d9:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  8005e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e3:	01 c8                	add    %ecx,%eax
  8005e5:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005e7:	39 c2                	cmp    %eax,%edx
  8005e9:	75 09                	jne    8005f4 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  8005eb:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  8005f2:	eb 12                	jmp    800606 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005f4:	ff 45 e8             	incl   -0x18(%ebp)
  8005f7:	a1 20 30 80 00       	mov    0x803020,%eax
  8005fc:	8b 50 74             	mov    0x74(%eax),%edx
  8005ff:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800602:	39 c2                	cmp    %eax,%edx
  800604:	77 88                	ja     80058e <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800606:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80060a:	75 14                	jne    800620 <CheckWSWithoutLastIndex+0xfb>
			panic(
  80060c:	83 ec 04             	sub    $0x4,%esp
  80060f:	68 3c 21 80 00       	push   $0x80213c
  800614:	6a 3a                	push   $0x3a
  800616:	68 30 21 80 00       	push   $0x802130
  80061b:	e8 93 fe ff ff       	call   8004b3 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800620:	ff 45 f0             	incl   -0x10(%ebp)
  800623:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800626:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800629:	0f 8c 32 ff ff ff    	jl     800561 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80062f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800636:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80063d:	eb 26                	jmp    800665 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80063f:	a1 20 30 80 00       	mov    0x803020,%eax
  800644:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80064a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80064d:	89 d0                	mov    %edx,%eax
  80064f:	01 c0                	add    %eax,%eax
  800651:	01 d0                	add    %edx,%eax
  800653:	c1 e0 03             	shl    $0x3,%eax
  800656:	01 c8                	add    %ecx,%eax
  800658:	8a 40 04             	mov    0x4(%eax),%al
  80065b:	3c 01                	cmp    $0x1,%al
  80065d:	75 03                	jne    800662 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  80065f:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800662:	ff 45 e0             	incl   -0x20(%ebp)
  800665:	a1 20 30 80 00       	mov    0x803020,%eax
  80066a:	8b 50 74             	mov    0x74(%eax),%edx
  80066d:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800670:	39 c2                	cmp    %eax,%edx
  800672:	77 cb                	ja     80063f <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  800674:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800677:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  80067a:	74 14                	je     800690 <CheckWSWithoutLastIndex+0x16b>
		panic(
  80067c:	83 ec 04             	sub    $0x4,%esp
  80067f:	68 90 21 80 00       	push   $0x802190
  800684:	6a 44                	push   $0x44
  800686:	68 30 21 80 00       	push   $0x802130
  80068b:	e8 23 fe ff ff       	call   8004b3 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  800690:	90                   	nop
  800691:	c9                   	leave  
  800692:	c3                   	ret    

00800693 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  800693:	55                   	push   %ebp
  800694:	89 e5                	mov    %esp,%ebp
  800696:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  800699:	8b 45 0c             	mov    0xc(%ebp),%eax
  80069c:	8b 00                	mov    (%eax),%eax
  80069e:	8d 48 01             	lea    0x1(%eax),%ecx
  8006a1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006a4:	89 0a                	mov    %ecx,(%edx)
  8006a6:	8b 55 08             	mov    0x8(%ebp),%edx
  8006a9:	88 d1                	mov    %dl,%cl
  8006ab:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006ae:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8006b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006b5:	8b 00                	mov    (%eax),%eax
  8006b7:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006bc:	75 2c                	jne    8006ea <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8006be:	a0 24 30 80 00       	mov    0x803024,%al
  8006c3:	0f b6 c0             	movzbl %al,%eax
  8006c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006c9:	8b 12                	mov    (%edx),%edx
  8006cb:	89 d1                	mov    %edx,%ecx
  8006cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006d0:	83 c2 08             	add    $0x8,%edx
  8006d3:	83 ec 04             	sub    $0x4,%esp
  8006d6:	50                   	push   %eax
  8006d7:	51                   	push   %ecx
  8006d8:	52                   	push   %edx
  8006d9:	e8 3e 0e 00 00       	call   80151c <sys_cputs>
  8006de:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  8006e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006e4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  8006ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006ed:	8b 40 04             	mov    0x4(%eax),%eax
  8006f0:	8d 50 01             	lea    0x1(%eax),%edx
  8006f3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006f6:	89 50 04             	mov    %edx,0x4(%eax)
}
  8006f9:	90                   	nop
  8006fa:	c9                   	leave  
  8006fb:	c3                   	ret    

008006fc <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  8006fc:	55                   	push   %ebp
  8006fd:	89 e5                	mov    %esp,%ebp
  8006ff:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800705:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80070c:	00 00 00 
	b.cnt = 0;
  80070f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800716:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800719:	ff 75 0c             	pushl  0xc(%ebp)
  80071c:	ff 75 08             	pushl  0x8(%ebp)
  80071f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800725:	50                   	push   %eax
  800726:	68 93 06 80 00       	push   $0x800693
  80072b:	e8 11 02 00 00       	call   800941 <vprintfmt>
  800730:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800733:	a0 24 30 80 00       	mov    0x803024,%al
  800738:	0f b6 c0             	movzbl %al,%eax
  80073b:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800741:	83 ec 04             	sub    $0x4,%esp
  800744:	50                   	push   %eax
  800745:	52                   	push   %edx
  800746:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80074c:	83 c0 08             	add    $0x8,%eax
  80074f:	50                   	push   %eax
  800750:	e8 c7 0d 00 00       	call   80151c <sys_cputs>
  800755:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  800758:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  80075f:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  800765:	c9                   	leave  
  800766:	c3                   	ret    

00800767 <cprintf>:

int cprintf(const char *fmt, ...) {
  800767:	55                   	push   %ebp
  800768:	89 e5                	mov    %esp,%ebp
  80076a:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  80076d:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  800774:	8d 45 0c             	lea    0xc(%ebp),%eax
  800777:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  80077a:	8b 45 08             	mov    0x8(%ebp),%eax
  80077d:	83 ec 08             	sub    $0x8,%esp
  800780:	ff 75 f4             	pushl  -0xc(%ebp)
  800783:	50                   	push   %eax
  800784:	e8 73 ff ff ff       	call   8006fc <vcprintf>
  800789:	83 c4 10             	add    $0x10,%esp
  80078c:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  80078f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800792:	c9                   	leave  
  800793:	c3                   	ret    

00800794 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  800794:	55                   	push   %ebp
  800795:	89 e5                	mov    %esp,%ebp
  800797:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  80079a:	e8 2b 0f 00 00       	call   8016ca <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  80079f:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007a2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a8:	83 ec 08             	sub    $0x8,%esp
  8007ab:	ff 75 f4             	pushl  -0xc(%ebp)
  8007ae:	50                   	push   %eax
  8007af:	e8 48 ff ff ff       	call   8006fc <vcprintf>
  8007b4:	83 c4 10             	add    $0x10,%esp
  8007b7:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8007ba:	e8 25 0f 00 00       	call   8016e4 <sys_enable_interrupt>
	return cnt;
  8007bf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007c2:	c9                   	leave  
  8007c3:	c3                   	ret    

008007c4 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007c4:	55                   	push   %ebp
  8007c5:	89 e5                	mov    %esp,%ebp
  8007c7:	53                   	push   %ebx
  8007c8:	83 ec 14             	sub    $0x14,%esp
  8007cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8007ce:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8007d1:	8b 45 14             	mov    0x14(%ebp),%eax
  8007d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  8007d7:	8b 45 18             	mov    0x18(%ebp),%eax
  8007da:	ba 00 00 00 00       	mov    $0x0,%edx
  8007df:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007e2:	77 55                	ja     800839 <printnum+0x75>
  8007e4:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  8007e7:	72 05                	jb     8007ee <printnum+0x2a>
  8007e9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8007ec:	77 4b                	ja     800839 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  8007ee:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8007f1:	8d 58 ff             	lea    -0x1(%eax),%ebx
  8007f4:	8b 45 18             	mov    0x18(%ebp),%eax
  8007f7:	ba 00 00 00 00       	mov    $0x0,%edx
  8007fc:	52                   	push   %edx
  8007fd:	50                   	push   %eax
  8007fe:	ff 75 f4             	pushl  -0xc(%ebp)
  800801:	ff 75 f0             	pushl  -0x10(%ebp)
  800804:	e8 47 13 00 00       	call   801b50 <__udivdi3>
  800809:	83 c4 10             	add    $0x10,%esp
  80080c:	83 ec 04             	sub    $0x4,%esp
  80080f:	ff 75 20             	pushl  0x20(%ebp)
  800812:	53                   	push   %ebx
  800813:	ff 75 18             	pushl  0x18(%ebp)
  800816:	52                   	push   %edx
  800817:	50                   	push   %eax
  800818:	ff 75 0c             	pushl  0xc(%ebp)
  80081b:	ff 75 08             	pushl  0x8(%ebp)
  80081e:	e8 a1 ff ff ff       	call   8007c4 <printnum>
  800823:	83 c4 20             	add    $0x20,%esp
  800826:	eb 1a                	jmp    800842 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800828:	83 ec 08             	sub    $0x8,%esp
  80082b:	ff 75 0c             	pushl  0xc(%ebp)
  80082e:	ff 75 20             	pushl  0x20(%ebp)
  800831:	8b 45 08             	mov    0x8(%ebp),%eax
  800834:	ff d0                	call   *%eax
  800836:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800839:	ff 4d 1c             	decl   0x1c(%ebp)
  80083c:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800840:	7f e6                	jg     800828 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800842:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800845:	bb 00 00 00 00       	mov    $0x0,%ebx
  80084a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80084d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800850:	53                   	push   %ebx
  800851:	51                   	push   %ecx
  800852:	52                   	push   %edx
  800853:	50                   	push   %eax
  800854:	e8 07 14 00 00       	call   801c60 <__umoddi3>
  800859:	83 c4 10             	add    $0x10,%esp
  80085c:	05 f4 23 80 00       	add    $0x8023f4,%eax
  800861:	8a 00                	mov    (%eax),%al
  800863:	0f be c0             	movsbl %al,%eax
  800866:	83 ec 08             	sub    $0x8,%esp
  800869:	ff 75 0c             	pushl  0xc(%ebp)
  80086c:	50                   	push   %eax
  80086d:	8b 45 08             	mov    0x8(%ebp),%eax
  800870:	ff d0                	call   *%eax
  800872:	83 c4 10             	add    $0x10,%esp
}
  800875:	90                   	nop
  800876:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800879:	c9                   	leave  
  80087a:	c3                   	ret    

0080087b <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  80087b:	55                   	push   %ebp
  80087c:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80087e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800882:	7e 1c                	jle    8008a0 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800884:	8b 45 08             	mov    0x8(%ebp),%eax
  800887:	8b 00                	mov    (%eax),%eax
  800889:	8d 50 08             	lea    0x8(%eax),%edx
  80088c:	8b 45 08             	mov    0x8(%ebp),%eax
  80088f:	89 10                	mov    %edx,(%eax)
  800891:	8b 45 08             	mov    0x8(%ebp),%eax
  800894:	8b 00                	mov    (%eax),%eax
  800896:	83 e8 08             	sub    $0x8,%eax
  800899:	8b 50 04             	mov    0x4(%eax),%edx
  80089c:	8b 00                	mov    (%eax),%eax
  80089e:	eb 40                	jmp    8008e0 <getuint+0x65>
	else if (lflag)
  8008a0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008a4:	74 1e                	je     8008c4 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8008a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a9:	8b 00                	mov    (%eax),%eax
  8008ab:	8d 50 04             	lea    0x4(%eax),%edx
  8008ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b1:	89 10                	mov    %edx,(%eax)
  8008b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b6:	8b 00                	mov    (%eax),%eax
  8008b8:	83 e8 04             	sub    $0x4,%eax
  8008bb:	8b 00                	mov    (%eax),%eax
  8008bd:	ba 00 00 00 00       	mov    $0x0,%edx
  8008c2:	eb 1c                	jmp    8008e0 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8008c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c7:	8b 00                	mov    (%eax),%eax
  8008c9:	8d 50 04             	lea    0x4(%eax),%edx
  8008cc:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cf:	89 10                	mov    %edx,(%eax)
  8008d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d4:	8b 00                	mov    (%eax),%eax
  8008d6:	83 e8 04             	sub    $0x4,%eax
  8008d9:	8b 00                	mov    (%eax),%eax
  8008db:	ba 00 00 00 00       	mov    $0x0,%edx
}
  8008e0:	5d                   	pop    %ebp
  8008e1:	c3                   	ret    

008008e2 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  8008e2:	55                   	push   %ebp
  8008e3:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008e5:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008e9:	7e 1c                	jle    800907 <getint+0x25>
		return va_arg(*ap, long long);
  8008eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8008ee:	8b 00                	mov    (%eax),%eax
  8008f0:	8d 50 08             	lea    0x8(%eax),%edx
  8008f3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f6:	89 10                	mov    %edx,(%eax)
  8008f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fb:	8b 00                	mov    (%eax),%eax
  8008fd:	83 e8 08             	sub    $0x8,%eax
  800900:	8b 50 04             	mov    0x4(%eax),%edx
  800903:	8b 00                	mov    (%eax),%eax
  800905:	eb 38                	jmp    80093f <getint+0x5d>
	else if (lflag)
  800907:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80090b:	74 1a                	je     800927 <getint+0x45>
		return va_arg(*ap, long);
  80090d:	8b 45 08             	mov    0x8(%ebp),%eax
  800910:	8b 00                	mov    (%eax),%eax
  800912:	8d 50 04             	lea    0x4(%eax),%edx
  800915:	8b 45 08             	mov    0x8(%ebp),%eax
  800918:	89 10                	mov    %edx,(%eax)
  80091a:	8b 45 08             	mov    0x8(%ebp),%eax
  80091d:	8b 00                	mov    (%eax),%eax
  80091f:	83 e8 04             	sub    $0x4,%eax
  800922:	8b 00                	mov    (%eax),%eax
  800924:	99                   	cltd   
  800925:	eb 18                	jmp    80093f <getint+0x5d>
	else
		return va_arg(*ap, int);
  800927:	8b 45 08             	mov    0x8(%ebp),%eax
  80092a:	8b 00                	mov    (%eax),%eax
  80092c:	8d 50 04             	lea    0x4(%eax),%edx
  80092f:	8b 45 08             	mov    0x8(%ebp),%eax
  800932:	89 10                	mov    %edx,(%eax)
  800934:	8b 45 08             	mov    0x8(%ebp),%eax
  800937:	8b 00                	mov    (%eax),%eax
  800939:	83 e8 04             	sub    $0x4,%eax
  80093c:	8b 00                	mov    (%eax),%eax
  80093e:	99                   	cltd   
}
  80093f:	5d                   	pop    %ebp
  800940:	c3                   	ret    

00800941 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800941:	55                   	push   %ebp
  800942:	89 e5                	mov    %esp,%ebp
  800944:	56                   	push   %esi
  800945:	53                   	push   %ebx
  800946:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800949:	eb 17                	jmp    800962 <vprintfmt+0x21>
			if (ch == '\0')
  80094b:	85 db                	test   %ebx,%ebx
  80094d:	0f 84 af 03 00 00    	je     800d02 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800953:	83 ec 08             	sub    $0x8,%esp
  800956:	ff 75 0c             	pushl  0xc(%ebp)
  800959:	53                   	push   %ebx
  80095a:	8b 45 08             	mov    0x8(%ebp),%eax
  80095d:	ff d0                	call   *%eax
  80095f:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800962:	8b 45 10             	mov    0x10(%ebp),%eax
  800965:	8d 50 01             	lea    0x1(%eax),%edx
  800968:	89 55 10             	mov    %edx,0x10(%ebp)
  80096b:	8a 00                	mov    (%eax),%al
  80096d:	0f b6 d8             	movzbl %al,%ebx
  800970:	83 fb 25             	cmp    $0x25,%ebx
  800973:	75 d6                	jne    80094b <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800975:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800979:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800980:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800987:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  80098e:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800995:	8b 45 10             	mov    0x10(%ebp),%eax
  800998:	8d 50 01             	lea    0x1(%eax),%edx
  80099b:	89 55 10             	mov    %edx,0x10(%ebp)
  80099e:	8a 00                	mov    (%eax),%al
  8009a0:	0f b6 d8             	movzbl %al,%ebx
  8009a3:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8009a6:	83 f8 55             	cmp    $0x55,%eax
  8009a9:	0f 87 2b 03 00 00    	ja     800cda <vprintfmt+0x399>
  8009af:	8b 04 85 18 24 80 00 	mov    0x802418(,%eax,4),%eax
  8009b6:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8009b8:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8009bc:	eb d7                	jmp    800995 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009be:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8009c2:	eb d1                	jmp    800995 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009c4:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  8009cb:	8b 55 e0             	mov    -0x20(%ebp),%edx
  8009ce:	89 d0                	mov    %edx,%eax
  8009d0:	c1 e0 02             	shl    $0x2,%eax
  8009d3:	01 d0                	add    %edx,%eax
  8009d5:	01 c0                	add    %eax,%eax
  8009d7:	01 d8                	add    %ebx,%eax
  8009d9:	83 e8 30             	sub    $0x30,%eax
  8009dc:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  8009df:	8b 45 10             	mov    0x10(%ebp),%eax
  8009e2:	8a 00                	mov    (%eax),%al
  8009e4:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  8009e7:	83 fb 2f             	cmp    $0x2f,%ebx
  8009ea:	7e 3e                	jle    800a2a <vprintfmt+0xe9>
  8009ec:	83 fb 39             	cmp    $0x39,%ebx
  8009ef:	7f 39                	jg     800a2a <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009f1:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  8009f4:	eb d5                	jmp    8009cb <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  8009f6:	8b 45 14             	mov    0x14(%ebp),%eax
  8009f9:	83 c0 04             	add    $0x4,%eax
  8009fc:	89 45 14             	mov    %eax,0x14(%ebp)
  8009ff:	8b 45 14             	mov    0x14(%ebp),%eax
  800a02:	83 e8 04             	sub    $0x4,%eax
  800a05:	8b 00                	mov    (%eax),%eax
  800a07:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a0a:	eb 1f                	jmp    800a2b <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a0c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a10:	79 83                	jns    800995 <vprintfmt+0x54>
				width = 0;
  800a12:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a19:	e9 77 ff ff ff       	jmp    800995 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a1e:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a25:	e9 6b ff ff ff       	jmp    800995 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a2a:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a2b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a2f:	0f 89 60 ff ff ff    	jns    800995 <vprintfmt+0x54>
				width = precision, precision = -1;
  800a35:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a38:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a3b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a42:	e9 4e ff ff ff       	jmp    800995 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a47:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a4a:	e9 46 ff ff ff       	jmp    800995 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a4f:	8b 45 14             	mov    0x14(%ebp),%eax
  800a52:	83 c0 04             	add    $0x4,%eax
  800a55:	89 45 14             	mov    %eax,0x14(%ebp)
  800a58:	8b 45 14             	mov    0x14(%ebp),%eax
  800a5b:	83 e8 04             	sub    $0x4,%eax
  800a5e:	8b 00                	mov    (%eax),%eax
  800a60:	83 ec 08             	sub    $0x8,%esp
  800a63:	ff 75 0c             	pushl  0xc(%ebp)
  800a66:	50                   	push   %eax
  800a67:	8b 45 08             	mov    0x8(%ebp),%eax
  800a6a:	ff d0                	call   *%eax
  800a6c:	83 c4 10             	add    $0x10,%esp
			break;
  800a6f:	e9 89 02 00 00       	jmp    800cfd <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800a74:	8b 45 14             	mov    0x14(%ebp),%eax
  800a77:	83 c0 04             	add    $0x4,%eax
  800a7a:	89 45 14             	mov    %eax,0x14(%ebp)
  800a7d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a80:	83 e8 04             	sub    $0x4,%eax
  800a83:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800a85:	85 db                	test   %ebx,%ebx
  800a87:	79 02                	jns    800a8b <vprintfmt+0x14a>
				err = -err;
  800a89:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800a8b:	83 fb 64             	cmp    $0x64,%ebx
  800a8e:	7f 0b                	jg     800a9b <vprintfmt+0x15a>
  800a90:	8b 34 9d 60 22 80 00 	mov    0x802260(,%ebx,4),%esi
  800a97:	85 f6                	test   %esi,%esi
  800a99:	75 19                	jne    800ab4 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800a9b:	53                   	push   %ebx
  800a9c:	68 05 24 80 00       	push   $0x802405
  800aa1:	ff 75 0c             	pushl  0xc(%ebp)
  800aa4:	ff 75 08             	pushl  0x8(%ebp)
  800aa7:	e8 5e 02 00 00       	call   800d0a <printfmt>
  800aac:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800aaf:	e9 49 02 00 00       	jmp    800cfd <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800ab4:	56                   	push   %esi
  800ab5:	68 0e 24 80 00       	push   $0x80240e
  800aba:	ff 75 0c             	pushl  0xc(%ebp)
  800abd:	ff 75 08             	pushl  0x8(%ebp)
  800ac0:	e8 45 02 00 00       	call   800d0a <printfmt>
  800ac5:	83 c4 10             	add    $0x10,%esp
			break;
  800ac8:	e9 30 02 00 00       	jmp    800cfd <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800acd:	8b 45 14             	mov    0x14(%ebp),%eax
  800ad0:	83 c0 04             	add    $0x4,%eax
  800ad3:	89 45 14             	mov    %eax,0x14(%ebp)
  800ad6:	8b 45 14             	mov    0x14(%ebp),%eax
  800ad9:	83 e8 04             	sub    $0x4,%eax
  800adc:	8b 30                	mov    (%eax),%esi
  800ade:	85 f6                	test   %esi,%esi
  800ae0:	75 05                	jne    800ae7 <vprintfmt+0x1a6>
				p = "(null)";
  800ae2:	be 11 24 80 00       	mov    $0x802411,%esi
			if (width > 0 && padc != '-')
  800ae7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800aeb:	7e 6d                	jle    800b5a <vprintfmt+0x219>
  800aed:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800af1:	74 67                	je     800b5a <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800af3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800af6:	83 ec 08             	sub    $0x8,%esp
  800af9:	50                   	push   %eax
  800afa:	56                   	push   %esi
  800afb:	e8 0c 03 00 00       	call   800e0c <strnlen>
  800b00:	83 c4 10             	add    $0x10,%esp
  800b03:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b06:	eb 16                	jmp    800b1e <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b08:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b0c:	83 ec 08             	sub    $0x8,%esp
  800b0f:	ff 75 0c             	pushl  0xc(%ebp)
  800b12:	50                   	push   %eax
  800b13:	8b 45 08             	mov    0x8(%ebp),%eax
  800b16:	ff d0                	call   *%eax
  800b18:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b1b:	ff 4d e4             	decl   -0x1c(%ebp)
  800b1e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b22:	7f e4                	jg     800b08 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b24:	eb 34                	jmp    800b5a <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b26:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b2a:	74 1c                	je     800b48 <vprintfmt+0x207>
  800b2c:	83 fb 1f             	cmp    $0x1f,%ebx
  800b2f:	7e 05                	jle    800b36 <vprintfmt+0x1f5>
  800b31:	83 fb 7e             	cmp    $0x7e,%ebx
  800b34:	7e 12                	jle    800b48 <vprintfmt+0x207>
					putch('?', putdat);
  800b36:	83 ec 08             	sub    $0x8,%esp
  800b39:	ff 75 0c             	pushl  0xc(%ebp)
  800b3c:	6a 3f                	push   $0x3f
  800b3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800b41:	ff d0                	call   *%eax
  800b43:	83 c4 10             	add    $0x10,%esp
  800b46:	eb 0f                	jmp    800b57 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b48:	83 ec 08             	sub    $0x8,%esp
  800b4b:	ff 75 0c             	pushl  0xc(%ebp)
  800b4e:	53                   	push   %ebx
  800b4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b52:	ff d0                	call   *%eax
  800b54:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b57:	ff 4d e4             	decl   -0x1c(%ebp)
  800b5a:	89 f0                	mov    %esi,%eax
  800b5c:	8d 70 01             	lea    0x1(%eax),%esi
  800b5f:	8a 00                	mov    (%eax),%al
  800b61:	0f be d8             	movsbl %al,%ebx
  800b64:	85 db                	test   %ebx,%ebx
  800b66:	74 24                	je     800b8c <vprintfmt+0x24b>
  800b68:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b6c:	78 b8                	js     800b26 <vprintfmt+0x1e5>
  800b6e:	ff 4d e0             	decl   -0x20(%ebp)
  800b71:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800b75:	79 af                	jns    800b26 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b77:	eb 13                	jmp    800b8c <vprintfmt+0x24b>
				putch(' ', putdat);
  800b79:	83 ec 08             	sub    $0x8,%esp
  800b7c:	ff 75 0c             	pushl  0xc(%ebp)
  800b7f:	6a 20                	push   $0x20
  800b81:	8b 45 08             	mov    0x8(%ebp),%eax
  800b84:	ff d0                	call   *%eax
  800b86:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800b89:	ff 4d e4             	decl   -0x1c(%ebp)
  800b8c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b90:	7f e7                	jg     800b79 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800b92:	e9 66 01 00 00       	jmp    800cfd <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800b97:	83 ec 08             	sub    $0x8,%esp
  800b9a:	ff 75 e8             	pushl  -0x18(%ebp)
  800b9d:	8d 45 14             	lea    0x14(%ebp),%eax
  800ba0:	50                   	push   %eax
  800ba1:	e8 3c fd ff ff       	call   8008e2 <getint>
  800ba6:	83 c4 10             	add    $0x10,%esp
  800ba9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bac:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800baf:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bb2:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bb5:	85 d2                	test   %edx,%edx
  800bb7:	79 23                	jns    800bdc <vprintfmt+0x29b>
				putch('-', putdat);
  800bb9:	83 ec 08             	sub    $0x8,%esp
  800bbc:	ff 75 0c             	pushl  0xc(%ebp)
  800bbf:	6a 2d                	push   $0x2d
  800bc1:	8b 45 08             	mov    0x8(%ebp),%eax
  800bc4:	ff d0                	call   *%eax
  800bc6:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800bc9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800bcc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bcf:	f7 d8                	neg    %eax
  800bd1:	83 d2 00             	adc    $0x0,%edx
  800bd4:	f7 da                	neg    %edx
  800bd6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bd9:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800bdc:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800be3:	e9 bc 00 00 00       	jmp    800ca4 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800be8:	83 ec 08             	sub    $0x8,%esp
  800beb:	ff 75 e8             	pushl  -0x18(%ebp)
  800bee:	8d 45 14             	lea    0x14(%ebp),%eax
  800bf1:	50                   	push   %eax
  800bf2:	e8 84 fc ff ff       	call   80087b <getuint>
  800bf7:	83 c4 10             	add    $0x10,%esp
  800bfa:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bfd:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c00:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c07:	e9 98 00 00 00       	jmp    800ca4 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c0c:	83 ec 08             	sub    $0x8,%esp
  800c0f:	ff 75 0c             	pushl  0xc(%ebp)
  800c12:	6a 58                	push   $0x58
  800c14:	8b 45 08             	mov    0x8(%ebp),%eax
  800c17:	ff d0                	call   *%eax
  800c19:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c1c:	83 ec 08             	sub    $0x8,%esp
  800c1f:	ff 75 0c             	pushl  0xc(%ebp)
  800c22:	6a 58                	push   $0x58
  800c24:	8b 45 08             	mov    0x8(%ebp),%eax
  800c27:	ff d0                	call   *%eax
  800c29:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c2c:	83 ec 08             	sub    $0x8,%esp
  800c2f:	ff 75 0c             	pushl  0xc(%ebp)
  800c32:	6a 58                	push   $0x58
  800c34:	8b 45 08             	mov    0x8(%ebp),%eax
  800c37:	ff d0                	call   *%eax
  800c39:	83 c4 10             	add    $0x10,%esp
			break;
  800c3c:	e9 bc 00 00 00       	jmp    800cfd <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800c41:	83 ec 08             	sub    $0x8,%esp
  800c44:	ff 75 0c             	pushl  0xc(%ebp)
  800c47:	6a 30                	push   $0x30
  800c49:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4c:	ff d0                	call   *%eax
  800c4e:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c51:	83 ec 08             	sub    $0x8,%esp
  800c54:	ff 75 0c             	pushl  0xc(%ebp)
  800c57:	6a 78                	push   $0x78
  800c59:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5c:	ff d0                	call   *%eax
  800c5e:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c61:	8b 45 14             	mov    0x14(%ebp),%eax
  800c64:	83 c0 04             	add    $0x4,%eax
  800c67:	89 45 14             	mov    %eax,0x14(%ebp)
  800c6a:	8b 45 14             	mov    0x14(%ebp),%eax
  800c6d:	83 e8 04             	sub    $0x4,%eax
  800c70:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800c72:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c75:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800c7c:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800c83:	eb 1f                	jmp    800ca4 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800c85:	83 ec 08             	sub    $0x8,%esp
  800c88:	ff 75 e8             	pushl  -0x18(%ebp)
  800c8b:	8d 45 14             	lea    0x14(%ebp),%eax
  800c8e:	50                   	push   %eax
  800c8f:	e8 e7 fb ff ff       	call   80087b <getuint>
  800c94:	83 c4 10             	add    $0x10,%esp
  800c97:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c9a:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800c9d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ca4:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ca8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cab:	83 ec 04             	sub    $0x4,%esp
  800cae:	52                   	push   %edx
  800caf:	ff 75 e4             	pushl  -0x1c(%ebp)
  800cb2:	50                   	push   %eax
  800cb3:	ff 75 f4             	pushl  -0xc(%ebp)
  800cb6:	ff 75 f0             	pushl  -0x10(%ebp)
  800cb9:	ff 75 0c             	pushl  0xc(%ebp)
  800cbc:	ff 75 08             	pushl  0x8(%ebp)
  800cbf:	e8 00 fb ff ff       	call   8007c4 <printnum>
  800cc4:	83 c4 20             	add    $0x20,%esp
			break;
  800cc7:	eb 34                	jmp    800cfd <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800cc9:	83 ec 08             	sub    $0x8,%esp
  800ccc:	ff 75 0c             	pushl  0xc(%ebp)
  800ccf:	53                   	push   %ebx
  800cd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd3:	ff d0                	call   *%eax
  800cd5:	83 c4 10             	add    $0x10,%esp
			break;
  800cd8:	eb 23                	jmp    800cfd <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800cda:	83 ec 08             	sub    $0x8,%esp
  800cdd:	ff 75 0c             	pushl  0xc(%ebp)
  800ce0:	6a 25                	push   $0x25
  800ce2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce5:	ff d0                	call   *%eax
  800ce7:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800cea:	ff 4d 10             	decl   0x10(%ebp)
  800ced:	eb 03                	jmp    800cf2 <vprintfmt+0x3b1>
  800cef:	ff 4d 10             	decl   0x10(%ebp)
  800cf2:	8b 45 10             	mov    0x10(%ebp),%eax
  800cf5:	48                   	dec    %eax
  800cf6:	8a 00                	mov    (%eax),%al
  800cf8:	3c 25                	cmp    $0x25,%al
  800cfa:	75 f3                	jne    800cef <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800cfc:	90                   	nop
		}
	}
  800cfd:	e9 47 fc ff ff       	jmp    800949 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d02:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d03:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d06:	5b                   	pop    %ebx
  800d07:	5e                   	pop    %esi
  800d08:	5d                   	pop    %ebp
  800d09:	c3                   	ret    

00800d0a <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d0a:	55                   	push   %ebp
  800d0b:	89 e5                	mov    %esp,%ebp
  800d0d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d10:	8d 45 10             	lea    0x10(%ebp),%eax
  800d13:	83 c0 04             	add    $0x4,%eax
  800d16:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d19:	8b 45 10             	mov    0x10(%ebp),%eax
  800d1c:	ff 75 f4             	pushl  -0xc(%ebp)
  800d1f:	50                   	push   %eax
  800d20:	ff 75 0c             	pushl  0xc(%ebp)
  800d23:	ff 75 08             	pushl  0x8(%ebp)
  800d26:	e8 16 fc ff ff       	call   800941 <vprintfmt>
  800d2b:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d2e:	90                   	nop
  800d2f:	c9                   	leave  
  800d30:	c3                   	ret    

00800d31 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d31:	55                   	push   %ebp
  800d32:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d34:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d37:	8b 40 08             	mov    0x8(%eax),%eax
  800d3a:	8d 50 01             	lea    0x1(%eax),%edx
  800d3d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d40:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d43:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d46:	8b 10                	mov    (%eax),%edx
  800d48:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d4b:	8b 40 04             	mov    0x4(%eax),%eax
  800d4e:	39 c2                	cmp    %eax,%edx
  800d50:	73 12                	jae    800d64 <sprintputch+0x33>
		*b->buf++ = ch;
  800d52:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d55:	8b 00                	mov    (%eax),%eax
  800d57:	8d 48 01             	lea    0x1(%eax),%ecx
  800d5a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d5d:	89 0a                	mov    %ecx,(%edx)
  800d5f:	8b 55 08             	mov    0x8(%ebp),%edx
  800d62:	88 10                	mov    %dl,(%eax)
}
  800d64:	90                   	nop
  800d65:	5d                   	pop    %ebp
  800d66:	c3                   	ret    

00800d67 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d67:	55                   	push   %ebp
  800d68:	89 e5                	mov    %esp,%ebp
  800d6a:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800d6d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d70:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800d73:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d76:	8d 50 ff             	lea    -0x1(%eax),%edx
  800d79:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7c:	01 d0                	add    %edx,%eax
  800d7e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800d81:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800d88:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800d8c:	74 06                	je     800d94 <vsnprintf+0x2d>
  800d8e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d92:	7f 07                	jg     800d9b <vsnprintf+0x34>
		return -E_INVAL;
  800d94:	b8 03 00 00 00       	mov    $0x3,%eax
  800d99:	eb 20                	jmp    800dbb <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800d9b:	ff 75 14             	pushl  0x14(%ebp)
  800d9e:	ff 75 10             	pushl  0x10(%ebp)
  800da1:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800da4:	50                   	push   %eax
  800da5:	68 31 0d 80 00       	push   $0x800d31
  800daa:	e8 92 fb ff ff       	call   800941 <vprintfmt>
  800daf:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800db2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800db5:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800db8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800dbb:	c9                   	leave  
  800dbc:	c3                   	ret    

00800dbd <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800dbd:	55                   	push   %ebp
  800dbe:	89 e5                	mov    %esp,%ebp
  800dc0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800dc3:	8d 45 10             	lea    0x10(%ebp),%eax
  800dc6:	83 c0 04             	add    $0x4,%eax
  800dc9:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800dcc:	8b 45 10             	mov    0x10(%ebp),%eax
  800dcf:	ff 75 f4             	pushl  -0xc(%ebp)
  800dd2:	50                   	push   %eax
  800dd3:	ff 75 0c             	pushl  0xc(%ebp)
  800dd6:	ff 75 08             	pushl  0x8(%ebp)
  800dd9:	e8 89 ff ff ff       	call   800d67 <vsnprintf>
  800dde:	83 c4 10             	add    $0x10,%esp
  800de1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800de4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800de7:	c9                   	leave  
  800de8:	c3                   	ret    

00800de9 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800de9:	55                   	push   %ebp
  800dea:	89 e5                	mov    %esp,%ebp
  800dec:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800def:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800df6:	eb 06                	jmp    800dfe <strlen+0x15>
		n++;
  800df8:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800dfb:	ff 45 08             	incl   0x8(%ebp)
  800dfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800e01:	8a 00                	mov    (%eax),%al
  800e03:	84 c0                	test   %al,%al
  800e05:	75 f1                	jne    800df8 <strlen+0xf>
		n++;
	return n;
  800e07:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e0a:	c9                   	leave  
  800e0b:	c3                   	ret    

00800e0c <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e0c:	55                   	push   %ebp
  800e0d:	89 e5                	mov    %esp,%ebp
  800e0f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e12:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e19:	eb 09                	jmp    800e24 <strnlen+0x18>
		n++;
  800e1b:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e1e:	ff 45 08             	incl   0x8(%ebp)
  800e21:	ff 4d 0c             	decl   0xc(%ebp)
  800e24:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e28:	74 09                	je     800e33 <strnlen+0x27>
  800e2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2d:	8a 00                	mov    (%eax),%al
  800e2f:	84 c0                	test   %al,%al
  800e31:	75 e8                	jne    800e1b <strnlen+0xf>
		n++;
	return n;
  800e33:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e36:	c9                   	leave  
  800e37:	c3                   	ret    

00800e38 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e38:	55                   	push   %ebp
  800e39:	89 e5                	mov    %esp,%ebp
  800e3b:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e41:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e44:	90                   	nop
  800e45:	8b 45 08             	mov    0x8(%ebp),%eax
  800e48:	8d 50 01             	lea    0x1(%eax),%edx
  800e4b:	89 55 08             	mov    %edx,0x8(%ebp)
  800e4e:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e51:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e54:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e57:	8a 12                	mov    (%edx),%dl
  800e59:	88 10                	mov    %dl,(%eax)
  800e5b:	8a 00                	mov    (%eax),%al
  800e5d:	84 c0                	test   %al,%al
  800e5f:	75 e4                	jne    800e45 <strcpy+0xd>
		/* do nothing */;
	return ret;
  800e61:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e64:	c9                   	leave  
  800e65:	c3                   	ret    

00800e66 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800e66:	55                   	push   %ebp
  800e67:	89 e5                	mov    %esp,%ebp
  800e69:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800e6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800e6f:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800e72:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e79:	eb 1f                	jmp    800e9a <strncpy+0x34>
		*dst++ = *src;
  800e7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7e:	8d 50 01             	lea    0x1(%eax),%edx
  800e81:	89 55 08             	mov    %edx,0x8(%ebp)
  800e84:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e87:	8a 12                	mov    (%edx),%dl
  800e89:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800e8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e8e:	8a 00                	mov    (%eax),%al
  800e90:	84 c0                	test   %al,%al
  800e92:	74 03                	je     800e97 <strncpy+0x31>
			src++;
  800e94:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800e97:	ff 45 fc             	incl   -0x4(%ebp)
  800e9a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e9d:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ea0:	72 d9                	jb     800e7b <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ea2:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ea5:	c9                   	leave  
  800ea6:	c3                   	ret    

00800ea7 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800ea7:	55                   	push   %ebp
  800ea8:	89 e5                	mov    %esp,%ebp
  800eaa:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ead:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800eb3:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eb7:	74 30                	je     800ee9 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800eb9:	eb 16                	jmp    800ed1 <strlcpy+0x2a>
			*dst++ = *src++;
  800ebb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebe:	8d 50 01             	lea    0x1(%eax),%edx
  800ec1:	89 55 08             	mov    %edx,0x8(%ebp)
  800ec4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ec7:	8d 4a 01             	lea    0x1(%edx),%ecx
  800eca:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800ecd:	8a 12                	mov    (%edx),%dl
  800ecf:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800ed1:	ff 4d 10             	decl   0x10(%ebp)
  800ed4:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ed8:	74 09                	je     800ee3 <strlcpy+0x3c>
  800eda:	8b 45 0c             	mov    0xc(%ebp),%eax
  800edd:	8a 00                	mov    (%eax),%al
  800edf:	84 c0                	test   %al,%al
  800ee1:	75 d8                	jne    800ebb <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800ee3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee6:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800ee9:	8b 55 08             	mov    0x8(%ebp),%edx
  800eec:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800eef:	29 c2                	sub    %eax,%edx
  800ef1:	89 d0                	mov    %edx,%eax
}
  800ef3:	c9                   	leave  
  800ef4:	c3                   	ret    

00800ef5 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800ef5:	55                   	push   %ebp
  800ef6:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800ef8:	eb 06                	jmp    800f00 <strcmp+0xb>
		p++, q++;
  800efa:	ff 45 08             	incl   0x8(%ebp)
  800efd:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f00:	8b 45 08             	mov    0x8(%ebp),%eax
  800f03:	8a 00                	mov    (%eax),%al
  800f05:	84 c0                	test   %al,%al
  800f07:	74 0e                	je     800f17 <strcmp+0x22>
  800f09:	8b 45 08             	mov    0x8(%ebp),%eax
  800f0c:	8a 10                	mov    (%eax),%dl
  800f0e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f11:	8a 00                	mov    (%eax),%al
  800f13:	38 c2                	cmp    %al,%dl
  800f15:	74 e3                	je     800efa <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f17:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1a:	8a 00                	mov    (%eax),%al
  800f1c:	0f b6 d0             	movzbl %al,%edx
  800f1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f22:	8a 00                	mov    (%eax),%al
  800f24:	0f b6 c0             	movzbl %al,%eax
  800f27:	29 c2                	sub    %eax,%edx
  800f29:	89 d0                	mov    %edx,%eax
}
  800f2b:	5d                   	pop    %ebp
  800f2c:	c3                   	ret    

00800f2d <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f2d:	55                   	push   %ebp
  800f2e:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f30:	eb 09                	jmp    800f3b <strncmp+0xe>
		n--, p++, q++;
  800f32:	ff 4d 10             	decl   0x10(%ebp)
  800f35:	ff 45 08             	incl   0x8(%ebp)
  800f38:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f3b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f3f:	74 17                	je     800f58 <strncmp+0x2b>
  800f41:	8b 45 08             	mov    0x8(%ebp),%eax
  800f44:	8a 00                	mov    (%eax),%al
  800f46:	84 c0                	test   %al,%al
  800f48:	74 0e                	je     800f58 <strncmp+0x2b>
  800f4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4d:	8a 10                	mov    (%eax),%dl
  800f4f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f52:	8a 00                	mov    (%eax),%al
  800f54:	38 c2                	cmp    %al,%dl
  800f56:	74 da                	je     800f32 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f58:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f5c:	75 07                	jne    800f65 <strncmp+0x38>
		return 0;
  800f5e:	b8 00 00 00 00       	mov    $0x0,%eax
  800f63:	eb 14                	jmp    800f79 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800f65:	8b 45 08             	mov    0x8(%ebp),%eax
  800f68:	8a 00                	mov    (%eax),%al
  800f6a:	0f b6 d0             	movzbl %al,%edx
  800f6d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f70:	8a 00                	mov    (%eax),%al
  800f72:	0f b6 c0             	movzbl %al,%eax
  800f75:	29 c2                	sub    %eax,%edx
  800f77:	89 d0                	mov    %edx,%eax
}
  800f79:	5d                   	pop    %ebp
  800f7a:	c3                   	ret    

00800f7b <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800f7b:	55                   	push   %ebp
  800f7c:	89 e5                	mov    %esp,%ebp
  800f7e:	83 ec 04             	sub    $0x4,%esp
  800f81:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f84:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800f87:	eb 12                	jmp    800f9b <strchr+0x20>
		if (*s == c)
  800f89:	8b 45 08             	mov    0x8(%ebp),%eax
  800f8c:	8a 00                	mov    (%eax),%al
  800f8e:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800f91:	75 05                	jne    800f98 <strchr+0x1d>
			return (char *) s;
  800f93:	8b 45 08             	mov    0x8(%ebp),%eax
  800f96:	eb 11                	jmp    800fa9 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800f98:	ff 45 08             	incl   0x8(%ebp)
  800f9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9e:	8a 00                	mov    (%eax),%al
  800fa0:	84 c0                	test   %al,%al
  800fa2:	75 e5                	jne    800f89 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800fa4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fa9:	c9                   	leave  
  800faa:	c3                   	ret    

00800fab <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800fab:	55                   	push   %ebp
  800fac:	89 e5                	mov    %esp,%ebp
  800fae:	83 ec 04             	sub    $0x4,%esp
  800fb1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb4:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fb7:	eb 0d                	jmp    800fc6 <strfind+0x1b>
		if (*s == c)
  800fb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbc:	8a 00                	mov    (%eax),%al
  800fbe:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fc1:	74 0e                	je     800fd1 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800fc3:	ff 45 08             	incl   0x8(%ebp)
  800fc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc9:	8a 00                	mov    (%eax),%al
  800fcb:	84 c0                	test   %al,%al
  800fcd:	75 ea                	jne    800fb9 <strfind+0xe>
  800fcf:	eb 01                	jmp    800fd2 <strfind+0x27>
		if (*s == c)
			break;
  800fd1:	90                   	nop
	return (char *) s;
  800fd2:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800fd5:	c9                   	leave  
  800fd6:	c3                   	ret    

00800fd7 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800fd7:	55                   	push   %ebp
  800fd8:	89 e5                	mov    %esp,%ebp
  800fda:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800fdd:	8b 45 08             	mov    0x8(%ebp),%eax
  800fe0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800fe3:	8b 45 10             	mov    0x10(%ebp),%eax
  800fe6:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800fe9:	eb 0e                	jmp    800ff9 <memset+0x22>
		*p++ = c;
  800feb:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fee:	8d 50 01             	lea    0x1(%eax),%edx
  800ff1:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800ff4:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ff7:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800ff9:	ff 4d f8             	decl   -0x8(%ebp)
  800ffc:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801000:	79 e9                	jns    800feb <memset+0x14>
		*p++ = c;

	return v;
  801002:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801005:	c9                   	leave  
  801006:	c3                   	ret    

00801007 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801007:	55                   	push   %ebp
  801008:	89 e5                	mov    %esp,%ebp
  80100a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80100d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801010:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801013:	8b 45 08             	mov    0x8(%ebp),%eax
  801016:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801019:	eb 16                	jmp    801031 <memcpy+0x2a>
		*d++ = *s++;
  80101b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80101e:	8d 50 01             	lea    0x1(%eax),%edx
  801021:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801024:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801027:	8d 4a 01             	lea    0x1(%edx),%ecx
  80102a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80102d:	8a 12                	mov    (%edx),%dl
  80102f:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801031:	8b 45 10             	mov    0x10(%ebp),%eax
  801034:	8d 50 ff             	lea    -0x1(%eax),%edx
  801037:	89 55 10             	mov    %edx,0x10(%ebp)
  80103a:	85 c0                	test   %eax,%eax
  80103c:	75 dd                	jne    80101b <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80103e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801041:	c9                   	leave  
  801042:	c3                   	ret    

00801043 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801043:	55                   	push   %ebp
  801044:	89 e5                	mov    %esp,%ebp
  801046:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801049:	8b 45 0c             	mov    0xc(%ebp),%eax
  80104c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80104f:	8b 45 08             	mov    0x8(%ebp),%eax
  801052:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  801055:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801058:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80105b:	73 50                	jae    8010ad <memmove+0x6a>
  80105d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801060:	8b 45 10             	mov    0x10(%ebp),%eax
  801063:	01 d0                	add    %edx,%eax
  801065:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801068:	76 43                	jbe    8010ad <memmove+0x6a>
		s += n;
  80106a:	8b 45 10             	mov    0x10(%ebp),%eax
  80106d:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  801070:	8b 45 10             	mov    0x10(%ebp),%eax
  801073:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  801076:	eb 10                	jmp    801088 <memmove+0x45>
			*--d = *--s;
  801078:	ff 4d f8             	decl   -0x8(%ebp)
  80107b:	ff 4d fc             	decl   -0x4(%ebp)
  80107e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801081:	8a 10                	mov    (%eax),%dl
  801083:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801086:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  801088:	8b 45 10             	mov    0x10(%ebp),%eax
  80108b:	8d 50 ff             	lea    -0x1(%eax),%edx
  80108e:	89 55 10             	mov    %edx,0x10(%ebp)
  801091:	85 c0                	test   %eax,%eax
  801093:	75 e3                	jne    801078 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  801095:	eb 23                	jmp    8010ba <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  801097:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80109a:	8d 50 01             	lea    0x1(%eax),%edx
  80109d:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010a0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010a3:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010a6:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8010a9:	8a 12                	mov    (%edx),%dl
  8010ab:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8010ad:	8b 45 10             	mov    0x10(%ebp),%eax
  8010b0:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010b3:	89 55 10             	mov    %edx,0x10(%ebp)
  8010b6:	85 c0                	test   %eax,%eax
  8010b8:	75 dd                	jne    801097 <memmove+0x54>
			*d++ = *s++;

	return dst;
  8010ba:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010bd:	c9                   	leave  
  8010be:	c3                   	ret    

008010bf <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8010bf:	55                   	push   %ebp
  8010c0:	89 e5                	mov    %esp,%ebp
  8010c2:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8010c5:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c8:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  8010cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ce:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  8010d1:	eb 2a                	jmp    8010fd <memcmp+0x3e>
		if (*s1 != *s2)
  8010d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010d6:	8a 10                	mov    (%eax),%dl
  8010d8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010db:	8a 00                	mov    (%eax),%al
  8010dd:	38 c2                	cmp    %al,%dl
  8010df:	74 16                	je     8010f7 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  8010e1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010e4:	8a 00                	mov    (%eax),%al
  8010e6:	0f b6 d0             	movzbl %al,%edx
  8010e9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010ec:	8a 00                	mov    (%eax),%al
  8010ee:	0f b6 c0             	movzbl %al,%eax
  8010f1:	29 c2                	sub    %eax,%edx
  8010f3:	89 d0                	mov    %edx,%eax
  8010f5:	eb 18                	jmp    80110f <memcmp+0x50>
		s1++, s2++;
  8010f7:	ff 45 fc             	incl   -0x4(%ebp)
  8010fa:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  8010fd:	8b 45 10             	mov    0x10(%ebp),%eax
  801100:	8d 50 ff             	lea    -0x1(%eax),%edx
  801103:	89 55 10             	mov    %edx,0x10(%ebp)
  801106:	85 c0                	test   %eax,%eax
  801108:	75 c9                	jne    8010d3 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80110a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80110f:	c9                   	leave  
  801110:	c3                   	ret    

00801111 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801111:	55                   	push   %ebp
  801112:	89 e5                	mov    %esp,%ebp
  801114:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801117:	8b 55 08             	mov    0x8(%ebp),%edx
  80111a:	8b 45 10             	mov    0x10(%ebp),%eax
  80111d:	01 d0                	add    %edx,%eax
  80111f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801122:	eb 15                	jmp    801139 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801124:	8b 45 08             	mov    0x8(%ebp),%eax
  801127:	8a 00                	mov    (%eax),%al
  801129:	0f b6 d0             	movzbl %al,%edx
  80112c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80112f:	0f b6 c0             	movzbl %al,%eax
  801132:	39 c2                	cmp    %eax,%edx
  801134:	74 0d                	je     801143 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801136:	ff 45 08             	incl   0x8(%ebp)
  801139:	8b 45 08             	mov    0x8(%ebp),%eax
  80113c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80113f:	72 e3                	jb     801124 <memfind+0x13>
  801141:	eb 01                	jmp    801144 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801143:	90                   	nop
	return (void *) s;
  801144:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801147:	c9                   	leave  
  801148:	c3                   	ret    

00801149 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801149:	55                   	push   %ebp
  80114a:	89 e5                	mov    %esp,%ebp
  80114c:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80114f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  801156:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  80115d:	eb 03                	jmp    801162 <strtol+0x19>
		s++;
  80115f:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801162:	8b 45 08             	mov    0x8(%ebp),%eax
  801165:	8a 00                	mov    (%eax),%al
  801167:	3c 20                	cmp    $0x20,%al
  801169:	74 f4                	je     80115f <strtol+0x16>
  80116b:	8b 45 08             	mov    0x8(%ebp),%eax
  80116e:	8a 00                	mov    (%eax),%al
  801170:	3c 09                	cmp    $0x9,%al
  801172:	74 eb                	je     80115f <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  801174:	8b 45 08             	mov    0x8(%ebp),%eax
  801177:	8a 00                	mov    (%eax),%al
  801179:	3c 2b                	cmp    $0x2b,%al
  80117b:	75 05                	jne    801182 <strtol+0x39>
		s++;
  80117d:	ff 45 08             	incl   0x8(%ebp)
  801180:	eb 13                	jmp    801195 <strtol+0x4c>
	else if (*s == '-')
  801182:	8b 45 08             	mov    0x8(%ebp),%eax
  801185:	8a 00                	mov    (%eax),%al
  801187:	3c 2d                	cmp    $0x2d,%al
  801189:	75 0a                	jne    801195 <strtol+0x4c>
		s++, neg = 1;
  80118b:	ff 45 08             	incl   0x8(%ebp)
  80118e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  801195:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801199:	74 06                	je     8011a1 <strtol+0x58>
  80119b:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  80119f:	75 20                	jne    8011c1 <strtol+0x78>
  8011a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a4:	8a 00                	mov    (%eax),%al
  8011a6:	3c 30                	cmp    $0x30,%al
  8011a8:	75 17                	jne    8011c1 <strtol+0x78>
  8011aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ad:	40                   	inc    %eax
  8011ae:	8a 00                	mov    (%eax),%al
  8011b0:	3c 78                	cmp    $0x78,%al
  8011b2:	75 0d                	jne    8011c1 <strtol+0x78>
		s += 2, base = 16;
  8011b4:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8011b8:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8011bf:	eb 28                	jmp    8011e9 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8011c1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011c5:	75 15                	jne    8011dc <strtol+0x93>
  8011c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ca:	8a 00                	mov    (%eax),%al
  8011cc:	3c 30                	cmp    $0x30,%al
  8011ce:	75 0c                	jne    8011dc <strtol+0x93>
		s++, base = 8;
  8011d0:	ff 45 08             	incl   0x8(%ebp)
  8011d3:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  8011da:	eb 0d                	jmp    8011e9 <strtol+0xa0>
	else if (base == 0)
  8011dc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011e0:	75 07                	jne    8011e9 <strtol+0xa0>
		base = 10;
  8011e2:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  8011e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ec:	8a 00                	mov    (%eax),%al
  8011ee:	3c 2f                	cmp    $0x2f,%al
  8011f0:	7e 19                	jle    80120b <strtol+0xc2>
  8011f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f5:	8a 00                	mov    (%eax),%al
  8011f7:	3c 39                	cmp    $0x39,%al
  8011f9:	7f 10                	jg     80120b <strtol+0xc2>
			dig = *s - '0';
  8011fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011fe:	8a 00                	mov    (%eax),%al
  801200:	0f be c0             	movsbl %al,%eax
  801203:	83 e8 30             	sub    $0x30,%eax
  801206:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801209:	eb 42                	jmp    80124d <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80120b:	8b 45 08             	mov    0x8(%ebp),%eax
  80120e:	8a 00                	mov    (%eax),%al
  801210:	3c 60                	cmp    $0x60,%al
  801212:	7e 19                	jle    80122d <strtol+0xe4>
  801214:	8b 45 08             	mov    0x8(%ebp),%eax
  801217:	8a 00                	mov    (%eax),%al
  801219:	3c 7a                	cmp    $0x7a,%al
  80121b:	7f 10                	jg     80122d <strtol+0xe4>
			dig = *s - 'a' + 10;
  80121d:	8b 45 08             	mov    0x8(%ebp),%eax
  801220:	8a 00                	mov    (%eax),%al
  801222:	0f be c0             	movsbl %al,%eax
  801225:	83 e8 57             	sub    $0x57,%eax
  801228:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80122b:	eb 20                	jmp    80124d <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80122d:	8b 45 08             	mov    0x8(%ebp),%eax
  801230:	8a 00                	mov    (%eax),%al
  801232:	3c 40                	cmp    $0x40,%al
  801234:	7e 39                	jle    80126f <strtol+0x126>
  801236:	8b 45 08             	mov    0x8(%ebp),%eax
  801239:	8a 00                	mov    (%eax),%al
  80123b:	3c 5a                	cmp    $0x5a,%al
  80123d:	7f 30                	jg     80126f <strtol+0x126>
			dig = *s - 'A' + 10;
  80123f:	8b 45 08             	mov    0x8(%ebp),%eax
  801242:	8a 00                	mov    (%eax),%al
  801244:	0f be c0             	movsbl %al,%eax
  801247:	83 e8 37             	sub    $0x37,%eax
  80124a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80124d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801250:	3b 45 10             	cmp    0x10(%ebp),%eax
  801253:	7d 19                	jge    80126e <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  801255:	ff 45 08             	incl   0x8(%ebp)
  801258:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80125b:	0f af 45 10          	imul   0x10(%ebp),%eax
  80125f:	89 c2                	mov    %eax,%edx
  801261:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801264:	01 d0                	add    %edx,%eax
  801266:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  801269:	e9 7b ff ff ff       	jmp    8011e9 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  80126e:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  80126f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801273:	74 08                	je     80127d <strtol+0x134>
		*endptr = (char *) s;
  801275:	8b 45 0c             	mov    0xc(%ebp),%eax
  801278:	8b 55 08             	mov    0x8(%ebp),%edx
  80127b:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  80127d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801281:	74 07                	je     80128a <strtol+0x141>
  801283:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801286:	f7 d8                	neg    %eax
  801288:	eb 03                	jmp    80128d <strtol+0x144>
  80128a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  80128d:	c9                   	leave  
  80128e:	c3                   	ret    

0080128f <ltostr>:

void
ltostr(long value, char *str)
{
  80128f:	55                   	push   %ebp
  801290:	89 e5                	mov    %esp,%ebp
  801292:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  801295:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  80129c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8012a3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012a7:	79 13                	jns    8012bc <ltostr+0x2d>
	{
		neg = 1;
  8012a9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8012b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b3:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8012b6:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8012b9:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8012bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8012bf:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8012c4:	99                   	cltd   
  8012c5:	f7 f9                	idiv   %ecx
  8012c7:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8012ca:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012cd:	8d 50 01             	lea    0x1(%eax),%edx
  8012d0:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012d3:	89 c2                	mov    %eax,%edx
  8012d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012d8:	01 d0                	add    %edx,%eax
  8012da:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8012dd:	83 c2 30             	add    $0x30,%edx
  8012e0:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  8012e2:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012e5:	b8 67 66 66 66       	mov    $0x66666667,%eax
  8012ea:	f7 e9                	imul   %ecx
  8012ec:	c1 fa 02             	sar    $0x2,%edx
  8012ef:	89 c8                	mov    %ecx,%eax
  8012f1:	c1 f8 1f             	sar    $0x1f,%eax
  8012f4:	29 c2                	sub    %eax,%edx
  8012f6:	89 d0                	mov    %edx,%eax
  8012f8:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  8012fb:	8b 4d 08             	mov    0x8(%ebp),%ecx
  8012fe:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801303:	f7 e9                	imul   %ecx
  801305:	c1 fa 02             	sar    $0x2,%edx
  801308:	89 c8                	mov    %ecx,%eax
  80130a:	c1 f8 1f             	sar    $0x1f,%eax
  80130d:	29 c2                	sub    %eax,%edx
  80130f:	89 d0                	mov    %edx,%eax
  801311:	c1 e0 02             	shl    $0x2,%eax
  801314:	01 d0                	add    %edx,%eax
  801316:	01 c0                	add    %eax,%eax
  801318:	29 c1                	sub    %eax,%ecx
  80131a:	89 ca                	mov    %ecx,%edx
  80131c:	85 d2                	test   %edx,%edx
  80131e:	75 9c                	jne    8012bc <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801320:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801327:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80132a:	48                   	dec    %eax
  80132b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80132e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801332:	74 3d                	je     801371 <ltostr+0xe2>
		start = 1 ;
  801334:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80133b:	eb 34                	jmp    801371 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80133d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801340:	8b 45 0c             	mov    0xc(%ebp),%eax
  801343:	01 d0                	add    %edx,%eax
  801345:	8a 00                	mov    (%eax),%al
  801347:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80134a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80134d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801350:	01 c2                	add    %eax,%edx
  801352:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  801355:	8b 45 0c             	mov    0xc(%ebp),%eax
  801358:	01 c8                	add    %ecx,%eax
  80135a:	8a 00                	mov    (%eax),%al
  80135c:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  80135e:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801361:	8b 45 0c             	mov    0xc(%ebp),%eax
  801364:	01 c2                	add    %eax,%edx
  801366:	8a 45 eb             	mov    -0x15(%ebp),%al
  801369:	88 02                	mov    %al,(%edx)
		start++ ;
  80136b:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  80136e:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  801371:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801374:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801377:	7c c4                	jl     80133d <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  801379:	8b 55 f8             	mov    -0x8(%ebp),%edx
  80137c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80137f:	01 d0                	add    %edx,%eax
  801381:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  801384:	90                   	nop
  801385:	c9                   	leave  
  801386:	c3                   	ret    

00801387 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  801387:	55                   	push   %ebp
  801388:	89 e5                	mov    %esp,%ebp
  80138a:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  80138d:	ff 75 08             	pushl  0x8(%ebp)
  801390:	e8 54 fa ff ff       	call   800de9 <strlen>
  801395:	83 c4 04             	add    $0x4,%esp
  801398:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  80139b:	ff 75 0c             	pushl  0xc(%ebp)
  80139e:	e8 46 fa ff ff       	call   800de9 <strlen>
  8013a3:	83 c4 04             	add    $0x4,%esp
  8013a6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8013a9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8013b0:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013b7:	eb 17                	jmp    8013d0 <strcconcat+0x49>
		final[s] = str1[s] ;
  8013b9:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8013bf:	01 c2                	add    %eax,%edx
  8013c1:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8013c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c7:	01 c8                	add    %ecx,%eax
  8013c9:	8a 00                	mov    (%eax),%al
  8013cb:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  8013cd:	ff 45 fc             	incl   -0x4(%ebp)
  8013d0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013d3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8013d6:	7c e1                	jl     8013b9 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  8013d8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  8013df:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  8013e6:	eb 1f                	jmp    801407 <strcconcat+0x80>
		final[s++] = str2[i] ;
  8013e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013eb:	8d 50 01             	lea    0x1(%eax),%edx
  8013ee:	89 55 fc             	mov    %edx,-0x4(%ebp)
  8013f1:	89 c2                	mov    %eax,%edx
  8013f3:	8b 45 10             	mov    0x10(%ebp),%eax
  8013f6:	01 c2                	add    %eax,%edx
  8013f8:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  8013fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013fe:	01 c8                	add    %ecx,%eax
  801400:	8a 00                	mov    (%eax),%al
  801402:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801404:	ff 45 f8             	incl   -0x8(%ebp)
  801407:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80140a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80140d:	7c d9                	jl     8013e8 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80140f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801412:	8b 45 10             	mov    0x10(%ebp),%eax
  801415:	01 d0                	add    %edx,%eax
  801417:	c6 00 00             	movb   $0x0,(%eax)
}
  80141a:	90                   	nop
  80141b:	c9                   	leave  
  80141c:	c3                   	ret    

0080141d <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80141d:	55                   	push   %ebp
  80141e:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801420:	8b 45 14             	mov    0x14(%ebp),%eax
  801423:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801429:	8b 45 14             	mov    0x14(%ebp),%eax
  80142c:	8b 00                	mov    (%eax),%eax
  80142e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801435:	8b 45 10             	mov    0x10(%ebp),%eax
  801438:	01 d0                	add    %edx,%eax
  80143a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801440:	eb 0c                	jmp    80144e <strsplit+0x31>
			*string++ = 0;
  801442:	8b 45 08             	mov    0x8(%ebp),%eax
  801445:	8d 50 01             	lea    0x1(%eax),%edx
  801448:	89 55 08             	mov    %edx,0x8(%ebp)
  80144b:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80144e:	8b 45 08             	mov    0x8(%ebp),%eax
  801451:	8a 00                	mov    (%eax),%al
  801453:	84 c0                	test   %al,%al
  801455:	74 18                	je     80146f <strsplit+0x52>
  801457:	8b 45 08             	mov    0x8(%ebp),%eax
  80145a:	8a 00                	mov    (%eax),%al
  80145c:	0f be c0             	movsbl %al,%eax
  80145f:	50                   	push   %eax
  801460:	ff 75 0c             	pushl  0xc(%ebp)
  801463:	e8 13 fb ff ff       	call   800f7b <strchr>
  801468:	83 c4 08             	add    $0x8,%esp
  80146b:	85 c0                	test   %eax,%eax
  80146d:	75 d3                	jne    801442 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  80146f:	8b 45 08             	mov    0x8(%ebp),%eax
  801472:	8a 00                	mov    (%eax),%al
  801474:	84 c0                	test   %al,%al
  801476:	74 5a                	je     8014d2 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  801478:	8b 45 14             	mov    0x14(%ebp),%eax
  80147b:	8b 00                	mov    (%eax),%eax
  80147d:	83 f8 0f             	cmp    $0xf,%eax
  801480:	75 07                	jne    801489 <strsplit+0x6c>
		{
			return 0;
  801482:	b8 00 00 00 00       	mov    $0x0,%eax
  801487:	eb 66                	jmp    8014ef <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  801489:	8b 45 14             	mov    0x14(%ebp),%eax
  80148c:	8b 00                	mov    (%eax),%eax
  80148e:	8d 48 01             	lea    0x1(%eax),%ecx
  801491:	8b 55 14             	mov    0x14(%ebp),%edx
  801494:	89 0a                	mov    %ecx,(%edx)
  801496:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80149d:	8b 45 10             	mov    0x10(%ebp),%eax
  8014a0:	01 c2                	add    %eax,%edx
  8014a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a5:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014a7:	eb 03                	jmp    8014ac <strsplit+0x8f>
			string++;
  8014a9:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014ac:	8b 45 08             	mov    0x8(%ebp),%eax
  8014af:	8a 00                	mov    (%eax),%al
  8014b1:	84 c0                	test   %al,%al
  8014b3:	74 8b                	je     801440 <strsplit+0x23>
  8014b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8014b8:	8a 00                	mov    (%eax),%al
  8014ba:	0f be c0             	movsbl %al,%eax
  8014bd:	50                   	push   %eax
  8014be:	ff 75 0c             	pushl  0xc(%ebp)
  8014c1:	e8 b5 fa ff ff       	call   800f7b <strchr>
  8014c6:	83 c4 08             	add    $0x8,%esp
  8014c9:	85 c0                	test   %eax,%eax
  8014cb:	74 dc                	je     8014a9 <strsplit+0x8c>
			string++;
	}
  8014cd:	e9 6e ff ff ff       	jmp    801440 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  8014d2:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  8014d3:	8b 45 14             	mov    0x14(%ebp),%eax
  8014d6:	8b 00                	mov    (%eax),%eax
  8014d8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014df:	8b 45 10             	mov    0x10(%ebp),%eax
  8014e2:	01 d0                	add    %edx,%eax
  8014e4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  8014ea:	b8 01 00 00 00       	mov    $0x1,%eax
}
  8014ef:	c9                   	leave  
  8014f0:	c3                   	ret    

008014f1 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  8014f1:	55                   	push   %ebp
  8014f2:	89 e5                	mov    %esp,%ebp
  8014f4:	57                   	push   %edi
  8014f5:	56                   	push   %esi
  8014f6:	53                   	push   %ebx
  8014f7:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  8014fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fd:	8b 55 0c             	mov    0xc(%ebp),%edx
  801500:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801503:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801506:	8b 7d 18             	mov    0x18(%ebp),%edi
  801509:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80150c:	cd 30                	int    $0x30
  80150e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801511:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801514:	83 c4 10             	add    $0x10,%esp
  801517:	5b                   	pop    %ebx
  801518:	5e                   	pop    %esi
  801519:	5f                   	pop    %edi
  80151a:	5d                   	pop    %ebp
  80151b:	c3                   	ret    

0080151c <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80151c:	55                   	push   %ebp
  80151d:	89 e5                	mov    %esp,%ebp
  80151f:	83 ec 04             	sub    $0x4,%esp
  801522:	8b 45 10             	mov    0x10(%ebp),%eax
  801525:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801528:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80152c:	8b 45 08             	mov    0x8(%ebp),%eax
  80152f:	6a 00                	push   $0x0
  801531:	6a 00                	push   $0x0
  801533:	52                   	push   %edx
  801534:	ff 75 0c             	pushl  0xc(%ebp)
  801537:	50                   	push   %eax
  801538:	6a 00                	push   $0x0
  80153a:	e8 b2 ff ff ff       	call   8014f1 <syscall>
  80153f:	83 c4 18             	add    $0x18,%esp
}
  801542:	90                   	nop
  801543:	c9                   	leave  
  801544:	c3                   	ret    

00801545 <sys_cgetc>:

int
sys_cgetc(void)
{
  801545:	55                   	push   %ebp
  801546:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801548:	6a 00                	push   $0x0
  80154a:	6a 00                	push   $0x0
  80154c:	6a 00                	push   $0x0
  80154e:	6a 00                	push   $0x0
  801550:	6a 00                	push   $0x0
  801552:	6a 01                	push   $0x1
  801554:	e8 98 ff ff ff       	call   8014f1 <syscall>
  801559:	83 c4 18             	add    $0x18,%esp
}
  80155c:	c9                   	leave  
  80155d:	c3                   	ret    

0080155e <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  80155e:	55                   	push   %ebp
  80155f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801561:	8b 55 0c             	mov    0xc(%ebp),%edx
  801564:	8b 45 08             	mov    0x8(%ebp),%eax
  801567:	6a 00                	push   $0x0
  801569:	6a 00                	push   $0x0
  80156b:	6a 00                	push   $0x0
  80156d:	52                   	push   %edx
  80156e:	50                   	push   %eax
  80156f:	6a 05                	push   $0x5
  801571:	e8 7b ff ff ff       	call   8014f1 <syscall>
  801576:	83 c4 18             	add    $0x18,%esp
}
  801579:	c9                   	leave  
  80157a:	c3                   	ret    

0080157b <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  80157b:	55                   	push   %ebp
  80157c:	89 e5                	mov    %esp,%ebp
  80157e:	56                   	push   %esi
  80157f:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  801580:	8b 75 18             	mov    0x18(%ebp),%esi
  801583:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801586:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801589:	8b 55 0c             	mov    0xc(%ebp),%edx
  80158c:	8b 45 08             	mov    0x8(%ebp),%eax
  80158f:	56                   	push   %esi
  801590:	53                   	push   %ebx
  801591:	51                   	push   %ecx
  801592:	52                   	push   %edx
  801593:	50                   	push   %eax
  801594:	6a 06                	push   $0x6
  801596:	e8 56 ff ff ff       	call   8014f1 <syscall>
  80159b:	83 c4 18             	add    $0x18,%esp
}
  80159e:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015a1:	5b                   	pop    %ebx
  8015a2:	5e                   	pop    %esi
  8015a3:	5d                   	pop    %ebp
  8015a4:	c3                   	ret    

008015a5 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8015a5:	55                   	push   %ebp
  8015a6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8015a8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015ab:	8b 45 08             	mov    0x8(%ebp),%eax
  8015ae:	6a 00                	push   $0x0
  8015b0:	6a 00                	push   $0x0
  8015b2:	6a 00                	push   $0x0
  8015b4:	52                   	push   %edx
  8015b5:	50                   	push   %eax
  8015b6:	6a 07                	push   $0x7
  8015b8:	e8 34 ff ff ff       	call   8014f1 <syscall>
  8015bd:	83 c4 18             	add    $0x18,%esp
}
  8015c0:	c9                   	leave  
  8015c1:	c3                   	ret    

008015c2 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8015c2:	55                   	push   %ebp
  8015c3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8015c5:	6a 00                	push   $0x0
  8015c7:	6a 00                	push   $0x0
  8015c9:	6a 00                	push   $0x0
  8015cb:	ff 75 0c             	pushl  0xc(%ebp)
  8015ce:	ff 75 08             	pushl  0x8(%ebp)
  8015d1:	6a 08                	push   $0x8
  8015d3:	e8 19 ff ff ff       	call   8014f1 <syscall>
  8015d8:	83 c4 18             	add    $0x18,%esp
}
  8015db:	c9                   	leave  
  8015dc:	c3                   	ret    

008015dd <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  8015dd:	55                   	push   %ebp
  8015de:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  8015e0:	6a 00                	push   $0x0
  8015e2:	6a 00                	push   $0x0
  8015e4:	6a 00                	push   $0x0
  8015e6:	6a 00                	push   $0x0
  8015e8:	6a 00                	push   $0x0
  8015ea:	6a 09                	push   $0x9
  8015ec:	e8 00 ff ff ff       	call   8014f1 <syscall>
  8015f1:	83 c4 18             	add    $0x18,%esp
}
  8015f4:	c9                   	leave  
  8015f5:	c3                   	ret    

008015f6 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  8015f6:	55                   	push   %ebp
  8015f7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  8015f9:	6a 00                	push   $0x0
  8015fb:	6a 00                	push   $0x0
  8015fd:	6a 00                	push   $0x0
  8015ff:	6a 00                	push   $0x0
  801601:	6a 00                	push   $0x0
  801603:	6a 0a                	push   $0xa
  801605:	e8 e7 fe ff ff       	call   8014f1 <syscall>
  80160a:	83 c4 18             	add    $0x18,%esp
}
  80160d:	c9                   	leave  
  80160e:	c3                   	ret    

0080160f <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80160f:	55                   	push   %ebp
  801610:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801612:	6a 00                	push   $0x0
  801614:	6a 00                	push   $0x0
  801616:	6a 00                	push   $0x0
  801618:	6a 00                	push   $0x0
  80161a:	6a 00                	push   $0x0
  80161c:	6a 0b                	push   $0xb
  80161e:	e8 ce fe ff ff       	call   8014f1 <syscall>
  801623:	83 c4 18             	add    $0x18,%esp
}
  801626:	c9                   	leave  
  801627:	c3                   	ret    

00801628 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801628:	55                   	push   %ebp
  801629:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80162b:	6a 00                	push   $0x0
  80162d:	6a 00                	push   $0x0
  80162f:	6a 00                	push   $0x0
  801631:	ff 75 0c             	pushl  0xc(%ebp)
  801634:	ff 75 08             	pushl  0x8(%ebp)
  801637:	6a 0f                	push   $0xf
  801639:	e8 b3 fe ff ff       	call   8014f1 <syscall>
  80163e:	83 c4 18             	add    $0x18,%esp
	return;
  801641:	90                   	nop
}
  801642:	c9                   	leave  
  801643:	c3                   	ret    

00801644 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801644:	55                   	push   %ebp
  801645:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801647:	6a 00                	push   $0x0
  801649:	6a 00                	push   $0x0
  80164b:	6a 00                	push   $0x0
  80164d:	ff 75 0c             	pushl  0xc(%ebp)
  801650:	ff 75 08             	pushl  0x8(%ebp)
  801653:	6a 10                	push   $0x10
  801655:	e8 97 fe ff ff       	call   8014f1 <syscall>
  80165a:	83 c4 18             	add    $0x18,%esp
	return ;
  80165d:	90                   	nop
}
  80165e:	c9                   	leave  
  80165f:	c3                   	ret    

00801660 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801660:	55                   	push   %ebp
  801661:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801663:	6a 00                	push   $0x0
  801665:	6a 00                	push   $0x0
  801667:	ff 75 10             	pushl  0x10(%ebp)
  80166a:	ff 75 0c             	pushl  0xc(%ebp)
  80166d:	ff 75 08             	pushl  0x8(%ebp)
  801670:	6a 11                	push   $0x11
  801672:	e8 7a fe ff ff       	call   8014f1 <syscall>
  801677:	83 c4 18             	add    $0x18,%esp
	return ;
  80167a:	90                   	nop
}
  80167b:	c9                   	leave  
  80167c:	c3                   	ret    

0080167d <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  80167d:	55                   	push   %ebp
  80167e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  801680:	6a 00                	push   $0x0
  801682:	6a 00                	push   $0x0
  801684:	6a 00                	push   $0x0
  801686:	6a 00                	push   $0x0
  801688:	6a 00                	push   $0x0
  80168a:	6a 0c                	push   $0xc
  80168c:	e8 60 fe ff ff       	call   8014f1 <syscall>
  801691:	83 c4 18             	add    $0x18,%esp
}
  801694:	c9                   	leave  
  801695:	c3                   	ret    

00801696 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  801696:	55                   	push   %ebp
  801697:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  801699:	6a 00                	push   $0x0
  80169b:	6a 00                	push   $0x0
  80169d:	6a 00                	push   $0x0
  80169f:	6a 00                	push   $0x0
  8016a1:	ff 75 08             	pushl  0x8(%ebp)
  8016a4:	6a 0d                	push   $0xd
  8016a6:	e8 46 fe ff ff       	call   8014f1 <syscall>
  8016ab:	83 c4 18             	add    $0x18,%esp
}
  8016ae:	c9                   	leave  
  8016af:	c3                   	ret    

008016b0 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8016b0:	55                   	push   %ebp
  8016b1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8016b3:	6a 00                	push   $0x0
  8016b5:	6a 00                	push   $0x0
  8016b7:	6a 00                	push   $0x0
  8016b9:	6a 00                	push   $0x0
  8016bb:	6a 00                	push   $0x0
  8016bd:	6a 0e                	push   $0xe
  8016bf:	e8 2d fe ff ff       	call   8014f1 <syscall>
  8016c4:	83 c4 18             	add    $0x18,%esp
}
  8016c7:	90                   	nop
  8016c8:	c9                   	leave  
  8016c9:	c3                   	ret    

008016ca <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8016ca:	55                   	push   %ebp
  8016cb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  8016cd:	6a 00                	push   $0x0
  8016cf:	6a 00                	push   $0x0
  8016d1:	6a 00                	push   $0x0
  8016d3:	6a 00                	push   $0x0
  8016d5:	6a 00                	push   $0x0
  8016d7:	6a 13                	push   $0x13
  8016d9:	e8 13 fe ff ff       	call   8014f1 <syscall>
  8016de:	83 c4 18             	add    $0x18,%esp
}
  8016e1:	90                   	nop
  8016e2:	c9                   	leave  
  8016e3:	c3                   	ret    

008016e4 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  8016e4:	55                   	push   %ebp
  8016e5:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  8016e7:	6a 00                	push   $0x0
  8016e9:	6a 00                	push   $0x0
  8016eb:	6a 00                	push   $0x0
  8016ed:	6a 00                	push   $0x0
  8016ef:	6a 00                	push   $0x0
  8016f1:	6a 14                	push   $0x14
  8016f3:	e8 f9 fd ff ff       	call   8014f1 <syscall>
  8016f8:	83 c4 18             	add    $0x18,%esp
}
  8016fb:	90                   	nop
  8016fc:	c9                   	leave  
  8016fd:	c3                   	ret    

008016fe <sys_cputc>:


void
sys_cputc(const char c)
{
  8016fe:	55                   	push   %ebp
  8016ff:	89 e5                	mov    %esp,%ebp
  801701:	83 ec 04             	sub    $0x4,%esp
  801704:	8b 45 08             	mov    0x8(%ebp),%eax
  801707:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80170a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80170e:	6a 00                	push   $0x0
  801710:	6a 00                	push   $0x0
  801712:	6a 00                	push   $0x0
  801714:	6a 00                	push   $0x0
  801716:	50                   	push   %eax
  801717:	6a 15                	push   $0x15
  801719:	e8 d3 fd ff ff       	call   8014f1 <syscall>
  80171e:	83 c4 18             	add    $0x18,%esp
}
  801721:	90                   	nop
  801722:	c9                   	leave  
  801723:	c3                   	ret    

00801724 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801724:	55                   	push   %ebp
  801725:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801727:	6a 00                	push   $0x0
  801729:	6a 00                	push   $0x0
  80172b:	6a 00                	push   $0x0
  80172d:	6a 00                	push   $0x0
  80172f:	6a 00                	push   $0x0
  801731:	6a 16                	push   $0x16
  801733:	e8 b9 fd ff ff       	call   8014f1 <syscall>
  801738:	83 c4 18             	add    $0x18,%esp
}
  80173b:	90                   	nop
  80173c:	c9                   	leave  
  80173d:	c3                   	ret    

0080173e <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80173e:	55                   	push   %ebp
  80173f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801741:	8b 45 08             	mov    0x8(%ebp),%eax
  801744:	6a 00                	push   $0x0
  801746:	6a 00                	push   $0x0
  801748:	6a 00                	push   $0x0
  80174a:	ff 75 0c             	pushl  0xc(%ebp)
  80174d:	50                   	push   %eax
  80174e:	6a 17                	push   $0x17
  801750:	e8 9c fd ff ff       	call   8014f1 <syscall>
  801755:	83 c4 18             	add    $0x18,%esp
}
  801758:	c9                   	leave  
  801759:	c3                   	ret    

0080175a <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80175a:	55                   	push   %ebp
  80175b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80175d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801760:	8b 45 08             	mov    0x8(%ebp),%eax
  801763:	6a 00                	push   $0x0
  801765:	6a 00                	push   $0x0
  801767:	6a 00                	push   $0x0
  801769:	52                   	push   %edx
  80176a:	50                   	push   %eax
  80176b:	6a 1a                	push   $0x1a
  80176d:	e8 7f fd ff ff       	call   8014f1 <syscall>
  801772:	83 c4 18             	add    $0x18,%esp
}
  801775:	c9                   	leave  
  801776:	c3                   	ret    

00801777 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801777:	55                   	push   %ebp
  801778:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  80177a:	8b 55 0c             	mov    0xc(%ebp),%edx
  80177d:	8b 45 08             	mov    0x8(%ebp),%eax
  801780:	6a 00                	push   $0x0
  801782:	6a 00                	push   $0x0
  801784:	6a 00                	push   $0x0
  801786:	52                   	push   %edx
  801787:	50                   	push   %eax
  801788:	6a 18                	push   $0x18
  80178a:	e8 62 fd ff ff       	call   8014f1 <syscall>
  80178f:	83 c4 18             	add    $0x18,%esp
}
  801792:	90                   	nop
  801793:	c9                   	leave  
  801794:	c3                   	ret    

00801795 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  801795:	55                   	push   %ebp
  801796:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801798:	8b 55 0c             	mov    0xc(%ebp),%edx
  80179b:	8b 45 08             	mov    0x8(%ebp),%eax
  80179e:	6a 00                	push   $0x0
  8017a0:	6a 00                	push   $0x0
  8017a2:	6a 00                	push   $0x0
  8017a4:	52                   	push   %edx
  8017a5:	50                   	push   %eax
  8017a6:	6a 19                	push   $0x19
  8017a8:	e8 44 fd ff ff       	call   8014f1 <syscall>
  8017ad:	83 c4 18             	add    $0x18,%esp
}
  8017b0:	90                   	nop
  8017b1:	c9                   	leave  
  8017b2:	c3                   	ret    

008017b3 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8017b3:	55                   	push   %ebp
  8017b4:	89 e5                	mov    %esp,%ebp
  8017b6:	83 ec 04             	sub    $0x4,%esp
  8017b9:	8b 45 10             	mov    0x10(%ebp),%eax
  8017bc:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8017bf:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8017c2:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8017c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c9:	6a 00                	push   $0x0
  8017cb:	51                   	push   %ecx
  8017cc:	52                   	push   %edx
  8017cd:	ff 75 0c             	pushl  0xc(%ebp)
  8017d0:	50                   	push   %eax
  8017d1:	6a 1b                	push   $0x1b
  8017d3:	e8 19 fd ff ff       	call   8014f1 <syscall>
  8017d8:	83 c4 18             	add    $0x18,%esp
}
  8017db:	c9                   	leave  
  8017dc:	c3                   	ret    

008017dd <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  8017dd:	55                   	push   %ebp
  8017de:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  8017e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8017e6:	6a 00                	push   $0x0
  8017e8:	6a 00                	push   $0x0
  8017ea:	6a 00                	push   $0x0
  8017ec:	52                   	push   %edx
  8017ed:	50                   	push   %eax
  8017ee:	6a 1c                	push   $0x1c
  8017f0:	e8 fc fc ff ff       	call   8014f1 <syscall>
  8017f5:	83 c4 18             	add    $0x18,%esp
}
  8017f8:	c9                   	leave  
  8017f9:	c3                   	ret    

008017fa <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  8017fa:	55                   	push   %ebp
  8017fb:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  8017fd:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801800:	8b 55 0c             	mov    0xc(%ebp),%edx
  801803:	8b 45 08             	mov    0x8(%ebp),%eax
  801806:	6a 00                	push   $0x0
  801808:	6a 00                	push   $0x0
  80180a:	51                   	push   %ecx
  80180b:	52                   	push   %edx
  80180c:	50                   	push   %eax
  80180d:	6a 1d                	push   $0x1d
  80180f:	e8 dd fc ff ff       	call   8014f1 <syscall>
  801814:	83 c4 18             	add    $0x18,%esp
}
  801817:	c9                   	leave  
  801818:	c3                   	ret    

00801819 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801819:	55                   	push   %ebp
  80181a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  80181c:	8b 55 0c             	mov    0xc(%ebp),%edx
  80181f:	8b 45 08             	mov    0x8(%ebp),%eax
  801822:	6a 00                	push   $0x0
  801824:	6a 00                	push   $0x0
  801826:	6a 00                	push   $0x0
  801828:	52                   	push   %edx
  801829:	50                   	push   %eax
  80182a:	6a 1e                	push   $0x1e
  80182c:	e8 c0 fc ff ff       	call   8014f1 <syscall>
  801831:	83 c4 18             	add    $0x18,%esp
}
  801834:	c9                   	leave  
  801835:	c3                   	ret    

00801836 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801836:	55                   	push   %ebp
  801837:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801839:	6a 00                	push   $0x0
  80183b:	6a 00                	push   $0x0
  80183d:	6a 00                	push   $0x0
  80183f:	6a 00                	push   $0x0
  801841:	6a 00                	push   $0x0
  801843:	6a 1f                	push   $0x1f
  801845:	e8 a7 fc ff ff       	call   8014f1 <syscall>
  80184a:	83 c4 18             	add    $0x18,%esp
}
  80184d:	c9                   	leave  
  80184e:	c3                   	ret    

0080184f <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  80184f:	55                   	push   %ebp
  801850:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801852:	8b 45 08             	mov    0x8(%ebp),%eax
  801855:	6a 00                	push   $0x0
  801857:	ff 75 14             	pushl  0x14(%ebp)
  80185a:	ff 75 10             	pushl  0x10(%ebp)
  80185d:	ff 75 0c             	pushl  0xc(%ebp)
  801860:	50                   	push   %eax
  801861:	6a 20                	push   $0x20
  801863:	e8 89 fc ff ff       	call   8014f1 <syscall>
  801868:	83 c4 18             	add    $0x18,%esp
}
  80186b:	c9                   	leave  
  80186c:	c3                   	ret    

0080186d <sys_run_env>:

void
sys_run_env(int32 envId)
{
  80186d:	55                   	push   %ebp
  80186e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801870:	8b 45 08             	mov    0x8(%ebp),%eax
  801873:	6a 00                	push   $0x0
  801875:	6a 00                	push   $0x0
  801877:	6a 00                	push   $0x0
  801879:	6a 00                	push   $0x0
  80187b:	50                   	push   %eax
  80187c:	6a 21                	push   $0x21
  80187e:	e8 6e fc ff ff       	call   8014f1 <syscall>
  801883:	83 c4 18             	add    $0x18,%esp
}
  801886:	90                   	nop
  801887:	c9                   	leave  
  801888:	c3                   	ret    

00801889 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801889:	55                   	push   %ebp
  80188a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  80188c:	8b 45 08             	mov    0x8(%ebp),%eax
  80188f:	6a 00                	push   $0x0
  801891:	6a 00                	push   $0x0
  801893:	6a 00                	push   $0x0
  801895:	6a 00                	push   $0x0
  801897:	50                   	push   %eax
  801898:	6a 22                	push   $0x22
  80189a:	e8 52 fc ff ff       	call   8014f1 <syscall>
  80189f:	83 c4 18             	add    $0x18,%esp
}
  8018a2:	c9                   	leave  
  8018a3:	c3                   	ret    

008018a4 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8018a4:	55                   	push   %ebp
  8018a5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8018a7:	6a 00                	push   $0x0
  8018a9:	6a 00                	push   $0x0
  8018ab:	6a 00                	push   $0x0
  8018ad:	6a 00                	push   $0x0
  8018af:	6a 00                	push   $0x0
  8018b1:	6a 02                	push   $0x2
  8018b3:	e8 39 fc ff ff       	call   8014f1 <syscall>
  8018b8:	83 c4 18             	add    $0x18,%esp
}
  8018bb:	c9                   	leave  
  8018bc:	c3                   	ret    

008018bd <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8018bd:	55                   	push   %ebp
  8018be:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8018c0:	6a 00                	push   $0x0
  8018c2:	6a 00                	push   $0x0
  8018c4:	6a 00                	push   $0x0
  8018c6:	6a 00                	push   $0x0
  8018c8:	6a 00                	push   $0x0
  8018ca:	6a 03                	push   $0x3
  8018cc:	e8 20 fc ff ff       	call   8014f1 <syscall>
  8018d1:	83 c4 18             	add    $0x18,%esp
}
  8018d4:	c9                   	leave  
  8018d5:	c3                   	ret    

008018d6 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  8018d6:	55                   	push   %ebp
  8018d7:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  8018d9:	6a 00                	push   $0x0
  8018db:	6a 00                	push   $0x0
  8018dd:	6a 00                	push   $0x0
  8018df:	6a 00                	push   $0x0
  8018e1:	6a 00                	push   $0x0
  8018e3:	6a 04                	push   $0x4
  8018e5:	e8 07 fc ff ff       	call   8014f1 <syscall>
  8018ea:	83 c4 18             	add    $0x18,%esp
}
  8018ed:	c9                   	leave  
  8018ee:	c3                   	ret    

008018ef <sys_exit_env>:


void sys_exit_env(void)
{
  8018ef:	55                   	push   %ebp
  8018f0:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  8018f2:	6a 00                	push   $0x0
  8018f4:	6a 00                	push   $0x0
  8018f6:	6a 00                	push   $0x0
  8018f8:	6a 00                	push   $0x0
  8018fa:	6a 00                	push   $0x0
  8018fc:	6a 23                	push   $0x23
  8018fe:	e8 ee fb ff ff       	call   8014f1 <syscall>
  801903:	83 c4 18             	add    $0x18,%esp
}
  801906:	90                   	nop
  801907:	c9                   	leave  
  801908:	c3                   	ret    

00801909 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801909:	55                   	push   %ebp
  80190a:	89 e5                	mov    %esp,%ebp
  80190c:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  80190f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801912:	8d 50 04             	lea    0x4(%eax),%edx
  801915:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801918:	6a 00                	push   $0x0
  80191a:	6a 00                	push   $0x0
  80191c:	6a 00                	push   $0x0
  80191e:	52                   	push   %edx
  80191f:	50                   	push   %eax
  801920:	6a 24                	push   $0x24
  801922:	e8 ca fb ff ff       	call   8014f1 <syscall>
  801927:	83 c4 18             	add    $0x18,%esp
	return result;
  80192a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80192d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801930:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801933:	89 01                	mov    %eax,(%ecx)
  801935:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801938:	8b 45 08             	mov    0x8(%ebp),%eax
  80193b:	c9                   	leave  
  80193c:	c2 04 00             	ret    $0x4

0080193f <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  80193f:	55                   	push   %ebp
  801940:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801942:	6a 00                	push   $0x0
  801944:	6a 00                	push   $0x0
  801946:	ff 75 10             	pushl  0x10(%ebp)
  801949:	ff 75 0c             	pushl  0xc(%ebp)
  80194c:	ff 75 08             	pushl  0x8(%ebp)
  80194f:	6a 12                	push   $0x12
  801951:	e8 9b fb ff ff       	call   8014f1 <syscall>
  801956:	83 c4 18             	add    $0x18,%esp
	return ;
  801959:	90                   	nop
}
  80195a:	c9                   	leave  
  80195b:	c3                   	ret    

0080195c <sys_rcr2>:
uint32 sys_rcr2()
{
  80195c:	55                   	push   %ebp
  80195d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  80195f:	6a 00                	push   $0x0
  801961:	6a 00                	push   $0x0
  801963:	6a 00                	push   $0x0
  801965:	6a 00                	push   $0x0
  801967:	6a 00                	push   $0x0
  801969:	6a 25                	push   $0x25
  80196b:	e8 81 fb ff ff       	call   8014f1 <syscall>
  801970:	83 c4 18             	add    $0x18,%esp
}
  801973:	c9                   	leave  
  801974:	c3                   	ret    

00801975 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801975:	55                   	push   %ebp
  801976:	89 e5                	mov    %esp,%ebp
  801978:	83 ec 04             	sub    $0x4,%esp
  80197b:	8b 45 08             	mov    0x8(%ebp),%eax
  80197e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801981:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801985:	6a 00                	push   $0x0
  801987:	6a 00                	push   $0x0
  801989:	6a 00                	push   $0x0
  80198b:	6a 00                	push   $0x0
  80198d:	50                   	push   %eax
  80198e:	6a 26                	push   $0x26
  801990:	e8 5c fb ff ff       	call   8014f1 <syscall>
  801995:	83 c4 18             	add    $0x18,%esp
	return ;
  801998:	90                   	nop
}
  801999:	c9                   	leave  
  80199a:	c3                   	ret    

0080199b <rsttst>:
void rsttst()
{
  80199b:	55                   	push   %ebp
  80199c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  80199e:	6a 00                	push   $0x0
  8019a0:	6a 00                	push   $0x0
  8019a2:	6a 00                	push   $0x0
  8019a4:	6a 00                	push   $0x0
  8019a6:	6a 00                	push   $0x0
  8019a8:	6a 28                	push   $0x28
  8019aa:	e8 42 fb ff ff       	call   8014f1 <syscall>
  8019af:	83 c4 18             	add    $0x18,%esp
	return ;
  8019b2:	90                   	nop
}
  8019b3:	c9                   	leave  
  8019b4:	c3                   	ret    

008019b5 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8019b5:	55                   	push   %ebp
  8019b6:	89 e5                	mov    %esp,%ebp
  8019b8:	83 ec 04             	sub    $0x4,%esp
  8019bb:	8b 45 14             	mov    0x14(%ebp),%eax
  8019be:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8019c1:	8b 55 18             	mov    0x18(%ebp),%edx
  8019c4:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8019c8:	52                   	push   %edx
  8019c9:	50                   	push   %eax
  8019ca:	ff 75 10             	pushl  0x10(%ebp)
  8019cd:	ff 75 0c             	pushl  0xc(%ebp)
  8019d0:	ff 75 08             	pushl  0x8(%ebp)
  8019d3:	6a 27                	push   $0x27
  8019d5:	e8 17 fb ff ff       	call   8014f1 <syscall>
  8019da:	83 c4 18             	add    $0x18,%esp
	return ;
  8019dd:	90                   	nop
}
  8019de:	c9                   	leave  
  8019df:	c3                   	ret    

008019e0 <chktst>:
void chktst(uint32 n)
{
  8019e0:	55                   	push   %ebp
  8019e1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  8019e3:	6a 00                	push   $0x0
  8019e5:	6a 00                	push   $0x0
  8019e7:	6a 00                	push   $0x0
  8019e9:	6a 00                	push   $0x0
  8019eb:	ff 75 08             	pushl  0x8(%ebp)
  8019ee:	6a 29                	push   $0x29
  8019f0:	e8 fc fa ff ff       	call   8014f1 <syscall>
  8019f5:	83 c4 18             	add    $0x18,%esp
	return ;
  8019f8:	90                   	nop
}
  8019f9:	c9                   	leave  
  8019fa:	c3                   	ret    

008019fb <inctst>:

void inctst()
{
  8019fb:	55                   	push   %ebp
  8019fc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  8019fe:	6a 00                	push   $0x0
  801a00:	6a 00                	push   $0x0
  801a02:	6a 00                	push   $0x0
  801a04:	6a 00                	push   $0x0
  801a06:	6a 00                	push   $0x0
  801a08:	6a 2a                	push   $0x2a
  801a0a:	e8 e2 fa ff ff       	call   8014f1 <syscall>
  801a0f:	83 c4 18             	add    $0x18,%esp
	return ;
  801a12:	90                   	nop
}
  801a13:	c9                   	leave  
  801a14:	c3                   	ret    

00801a15 <gettst>:
uint32 gettst()
{
  801a15:	55                   	push   %ebp
  801a16:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801a18:	6a 00                	push   $0x0
  801a1a:	6a 00                	push   $0x0
  801a1c:	6a 00                	push   $0x0
  801a1e:	6a 00                	push   $0x0
  801a20:	6a 00                	push   $0x0
  801a22:	6a 2b                	push   $0x2b
  801a24:	e8 c8 fa ff ff       	call   8014f1 <syscall>
  801a29:	83 c4 18             	add    $0x18,%esp
}
  801a2c:	c9                   	leave  
  801a2d:	c3                   	ret    

00801a2e <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801a2e:	55                   	push   %ebp
  801a2f:	89 e5                	mov    %esp,%ebp
  801a31:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a34:	6a 00                	push   $0x0
  801a36:	6a 00                	push   $0x0
  801a38:	6a 00                	push   $0x0
  801a3a:	6a 00                	push   $0x0
  801a3c:	6a 00                	push   $0x0
  801a3e:	6a 2c                	push   $0x2c
  801a40:	e8 ac fa ff ff       	call   8014f1 <syscall>
  801a45:	83 c4 18             	add    $0x18,%esp
  801a48:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801a4b:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801a4f:	75 07                	jne    801a58 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801a51:	b8 01 00 00 00       	mov    $0x1,%eax
  801a56:	eb 05                	jmp    801a5d <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801a58:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a5d:	c9                   	leave  
  801a5e:	c3                   	ret    

00801a5f <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801a5f:	55                   	push   %ebp
  801a60:	89 e5                	mov    %esp,%ebp
  801a62:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a65:	6a 00                	push   $0x0
  801a67:	6a 00                	push   $0x0
  801a69:	6a 00                	push   $0x0
  801a6b:	6a 00                	push   $0x0
  801a6d:	6a 00                	push   $0x0
  801a6f:	6a 2c                	push   $0x2c
  801a71:	e8 7b fa ff ff       	call   8014f1 <syscall>
  801a76:	83 c4 18             	add    $0x18,%esp
  801a79:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801a7c:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801a80:	75 07                	jne    801a89 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801a82:	b8 01 00 00 00       	mov    $0x1,%eax
  801a87:	eb 05                	jmp    801a8e <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801a89:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a8e:	c9                   	leave  
  801a8f:	c3                   	ret    

00801a90 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801a90:	55                   	push   %ebp
  801a91:	89 e5                	mov    %esp,%ebp
  801a93:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a96:	6a 00                	push   $0x0
  801a98:	6a 00                	push   $0x0
  801a9a:	6a 00                	push   $0x0
  801a9c:	6a 00                	push   $0x0
  801a9e:	6a 00                	push   $0x0
  801aa0:	6a 2c                	push   $0x2c
  801aa2:	e8 4a fa ff ff       	call   8014f1 <syscall>
  801aa7:	83 c4 18             	add    $0x18,%esp
  801aaa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801aad:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801ab1:	75 07                	jne    801aba <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801ab3:	b8 01 00 00 00       	mov    $0x1,%eax
  801ab8:	eb 05                	jmp    801abf <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801aba:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801abf:	c9                   	leave  
  801ac0:	c3                   	ret    

00801ac1 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801ac1:	55                   	push   %ebp
  801ac2:	89 e5                	mov    %esp,%ebp
  801ac4:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ac7:	6a 00                	push   $0x0
  801ac9:	6a 00                	push   $0x0
  801acb:	6a 00                	push   $0x0
  801acd:	6a 00                	push   $0x0
  801acf:	6a 00                	push   $0x0
  801ad1:	6a 2c                	push   $0x2c
  801ad3:	e8 19 fa ff ff       	call   8014f1 <syscall>
  801ad8:	83 c4 18             	add    $0x18,%esp
  801adb:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801ade:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801ae2:	75 07                	jne    801aeb <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801ae4:	b8 01 00 00 00       	mov    $0x1,%eax
  801ae9:	eb 05                	jmp    801af0 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801aeb:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801af0:	c9                   	leave  
  801af1:	c3                   	ret    

00801af2 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801af2:	55                   	push   %ebp
  801af3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801af5:	6a 00                	push   $0x0
  801af7:	6a 00                	push   $0x0
  801af9:	6a 00                	push   $0x0
  801afb:	6a 00                	push   $0x0
  801afd:	ff 75 08             	pushl  0x8(%ebp)
  801b00:	6a 2d                	push   $0x2d
  801b02:	e8 ea f9 ff ff       	call   8014f1 <syscall>
  801b07:	83 c4 18             	add    $0x18,%esp
	return ;
  801b0a:	90                   	nop
}
  801b0b:	c9                   	leave  
  801b0c:	c3                   	ret    

00801b0d <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801b0d:	55                   	push   %ebp
  801b0e:	89 e5                	mov    %esp,%ebp
  801b10:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801b11:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b14:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b17:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b1a:	8b 45 08             	mov    0x8(%ebp),%eax
  801b1d:	6a 00                	push   $0x0
  801b1f:	53                   	push   %ebx
  801b20:	51                   	push   %ecx
  801b21:	52                   	push   %edx
  801b22:	50                   	push   %eax
  801b23:	6a 2e                	push   $0x2e
  801b25:	e8 c7 f9 ff ff       	call   8014f1 <syscall>
  801b2a:	83 c4 18             	add    $0x18,%esp
}
  801b2d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b30:	c9                   	leave  
  801b31:	c3                   	ret    

00801b32 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801b32:	55                   	push   %ebp
  801b33:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801b35:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b38:	8b 45 08             	mov    0x8(%ebp),%eax
  801b3b:	6a 00                	push   $0x0
  801b3d:	6a 00                	push   $0x0
  801b3f:	6a 00                	push   $0x0
  801b41:	52                   	push   %edx
  801b42:	50                   	push   %eax
  801b43:	6a 2f                	push   $0x2f
  801b45:	e8 a7 f9 ff ff       	call   8014f1 <syscall>
  801b4a:	83 c4 18             	add    $0x18,%esp
}
  801b4d:	c9                   	leave  
  801b4e:	c3                   	ret    
  801b4f:	90                   	nop

00801b50 <__udivdi3>:
  801b50:	55                   	push   %ebp
  801b51:	57                   	push   %edi
  801b52:	56                   	push   %esi
  801b53:	53                   	push   %ebx
  801b54:	83 ec 1c             	sub    $0x1c,%esp
  801b57:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801b5b:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801b5f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b63:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801b67:	89 ca                	mov    %ecx,%edx
  801b69:	89 f8                	mov    %edi,%eax
  801b6b:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801b6f:	85 f6                	test   %esi,%esi
  801b71:	75 2d                	jne    801ba0 <__udivdi3+0x50>
  801b73:	39 cf                	cmp    %ecx,%edi
  801b75:	77 65                	ja     801bdc <__udivdi3+0x8c>
  801b77:	89 fd                	mov    %edi,%ebp
  801b79:	85 ff                	test   %edi,%edi
  801b7b:	75 0b                	jne    801b88 <__udivdi3+0x38>
  801b7d:	b8 01 00 00 00       	mov    $0x1,%eax
  801b82:	31 d2                	xor    %edx,%edx
  801b84:	f7 f7                	div    %edi
  801b86:	89 c5                	mov    %eax,%ebp
  801b88:	31 d2                	xor    %edx,%edx
  801b8a:	89 c8                	mov    %ecx,%eax
  801b8c:	f7 f5                	div    %ebp
  801b8e:	89 c1                	mov    %eax,%ecx
  801b90:	89 d8                	mov    %ebx,%eax
  801b92:	f7 f5                	div    %ebp
  801b94:	89 cf                	mov    %ecx,%edi
  801b96:	89 fa                	mov    %edi,%edx
  801b98:	83 c4 1c             	add    $0x1c,%esp
  801b9b:	5b                   	pop    %ebx
  801b9c:	5e                   	pop    %esi
  801b9d:	5f                   	pop    %edi
  801b9e:	5d                   	pop    %ebp
  801b9f:	c3                   	ret    
  801ba0:	39 ce                	cmp    %ecx,%esi
  801ba2:	77 28                	ja     801bcc <__udivdi3+0x7c>
  801ba4:	0f bd fe             	bsr    %esi,%edi
  801ba7:	83 f7 1f             	xor    $0x1f,%edi
  801baa:	75 40                	jne    801bec <__udivdi3+0x9c>
  801bac:	39 ce                	cmp    %ecx,%esi
  801bae:	72 0a                	jb     801bba <__udivdi3+0x6a>
  801bb0:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801bb4:	0f 87 9e 00 00 00    	ja     801c58 <__udivdi3+0x108>
  801bba:	b8 01 00 00 00       	mov    $0x1,%eax
  801bbf:	89 fa                	mov    %edi,%edx
  801bc1:	83 c4 1c             	add    $0x1c,%esp
  801bc4:	5b                   	pop    %ebx
  801bc5:	5e                   	pop    %esi
  801bc6:	5f                   	pop    %edi
  801bc7:	5d                   	pop    %ebp
  801bc8:	c3                   	ret    
  801bc9:	8d 76 00             	lea    0x0(%esi),%esi
  801bcc:	31 ff                	xor    %edi,%edi
  801bce:	31 c0                	xor    %eax,%eax
  801bd0:	89 fa                	mov    %edi,%edx
  801bd2:	83 c4 1c             	add    $0x1c,%esp
  801bd5:	5b                   	pop    %ebx
  801bd6:	5e                   	pop    %esi
  801bd7:	5f                   	pop    %edi
  801bd8:	5d                   	pop    %ebp
  801bd9:	c3                   	ret    
  801bda:	66 90                	xchg   %ax,%ax
  801bdc:	89 d8                	mov    %ebx,%eax
  801bde:	f7 f7                	div    %edi
  801be0:	31 ff                	xor    %edi,%edi
  801be2:	89 fa                	mov    %edi,%edx
  801be4:	83 c4 1c             	add    $0x1c,%esp
  801be7:	5b                   	pop    %ebx
  801be8:	5e                   	pop    %esi
  801be9:	5f                   	pop    %edi
  801bea:	5d                   	pop    %ebp
  801beb:	c3                   	ret    
  801bec:	bd 20 00 00 00       	mov    $0x20,%ebp
  801bf1:	89 eb                	mov    %ebp,%ebx
  801bf3:	29 fb                	sub    %edi,%ebx
  801bf5:	89 f9                	mov    %edi,%ecx
  801bf7:	d3 e6                	shl    %cl,%esi
  801bf9:	89 c5                	mov    %eax,%ebp
  801bfb:	88 d9                	mov    %bl,%cl
  801bfd:	d3 ed                	shr    %cl,%ebp
  801bff:	89 e9                	mov    %ebp,%ecx
  801c01:	09 f1                	or     %esi,%ecx
  801c03:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801c07:	89 f9                	mov    %edi,%ecx
  801c09:	d3 e0                	shl    %cl,%eax
  801c0b:	89 c5                	mov    %eax,%ebp
  801c0d:	89 d6                	mov    %edx,%esi
  801c0f:	88 d9                	mov    %bl,%cl
  801c11:	d3 ee                	shr    %cl,%esi
  801c13:	89 f9                	mov    %edi,%ecx
  801c15:	d3 e2                	shl    %cl,%edx
  801c17:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c1b:	88 d9                	mov    %bl,%cl
  801c1d:	d3 e8                	shr    %cl,%eax
  801c1f:	09 c2                	or     %eax,%edx
  801c21:	89 d0                	mov    %edx,%eax
  801c23:	89 f2                	mov    %esi,%edx
  801c25:	f7 74 24 0c          	divl   0xc(%esp)
  801c29:	89 d6                	mov    %edx,%esi
  801c2b:	89 c3                	mov    %eax,%ebx
  801c2d:	f7 e5                	mul    %ebp
  801c2f:	39 d6                	cmp    %edx,%esi
  801c31:	72 19                	jb     801c4c <__udivdi3+0xfc>
  801c33:	74 0b                	je     801c40 <__udivdi3+0xf0>
  801c35:	89 d8                	mov    %ebx,%eax
  801c37:	31 ff                	xor    %edi,%edi
  801c39:	e9 58 ff ff ff       	jmp    801b96 <__udivdi3+0x46>
  801c3e:	66 90                	xchg   %ax,%ax
  801c40:	8b 54 24 08          	mov    0x8(%esp),%edx
  801c44:	89 f9                	mov    %edi,%ecx
  801c46:	d3 e2                	shl    %cl,%edx
  801c48:	39 c2                	cmp    %eax,%edx
  801c4a:	73 e9                	jae    801c35 <__udivdi3+0xe5>
  801c4c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801c4f:	31 ff                	xor    %edi,%edi
  801c51:	e9 40 ff ff ff       	jmp    801b96 <__udivdi3+0x46>
  801c56:	66 90                	xchg   %ax,%ax
  801c58:	31 c0                	xor    %eax,%eax
  801c5a:	e9 37 ff ff ff       	jmp    801b96 <__udivdi3+0x46>
  801c5f:	90                   	nop

00801c60 <__umoddi3>:
  801c60:	55                   	push   %ebp
  801c61:	57                   	push   %edi
  801c62:	56                   	push   %esi
  801c63:	53                   	push   %ebx
  801c64:	83 ec 1c             	sub    $0x1c,%esp
  801c67:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801c6b:	8b 74 24 34          	mov    0x34(%esp),%esi
  801c6f:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801c73:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801c77:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801c7b:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801c7f:	89 f3                	mov    %esi,%ebx
  801c81:	89 fa                	mov    %edi,%edx
  801c83:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c87:	89 34 24             	mov    %esi,(%esp)
  801c8a:	85 c0                	test   %eax,%eax
  801c8c:	75 1a                	jne    801ca8 <__umoddi3+0x48>
  801c8e:	39 f7                	cmp    %esi,%edi
  801c90:	0f 86 a2 00 00 00    	jbe    801d38 <__umoddi3+0xd8>
  801c96:	89 c8                	mov    %ecx,%eax
  801c98:	89 f2                	mov    %esi,%edx
  801c9a:	f7 f7                	div    %edi
  801c9c:	89 d0                	mov    %edx,%eax
  801c9e:	31 d2                	xor    %edx,%edx
  801ca0:	83 c4 1c             	add    $0x1c,%esp
  801ca3:	5b                   	pop    %ebx
  801ca4:	5e                   	pop    %esi
  801ca5:	5f                   	pop    %edi
  801ca6:	5d                   	pop    %ebp
  801ca7:	c3                   	ret    
  801ca8:	39 f0                	cmp    %esi,%eax
  801caa:	0f 87 ac 00 00 00    	ja     801d5c <__umoddi3+0xfc>
  801cb0:	0f bd e8             	bsr    %eax,%ebp
  801cb3:	83 f5 1f             	xor    $0x1f,%ebp
  801cb6:	0f 84 ac 00 00 00    	je     801d68 <__umoddi3+0x108>
  801cbc:	bf 20 00 00 00       	mov    $0x20,%edi
  801cc1:	29 ef                	sub    %ebp,%edi
  801cc3:	89 fe                	mov    %edi,%esi
  801cc5:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801cc9:	89 e9                	mov    %ebp,%ecx
  801ccb:	d3 e0                	shl    %cl,%eax
  801ccd:	89 d7                	mov    %edx,%edi
  801ccf:	89 f1                	mov    %esi,%ecx
  801cd1:	d3 ef                	shr    %cl,%edi
  801cd3:	09 c7                	or     %eax,%edi
  801cd5:	89 e9                	mov    %ebp,%ecx
  801cd7:	d3 e2                	shl    %cl,%edx
  801cd9:	89 14 24             	mov    %edx,(%esp)
  801cdc:	89 d8                	mov    %ebx,%eax
  801cde:	d3 e0                	shl    %cl,%eax
  801ce0:	89 c2                	mov    %eax,%edx
  801ce2:	8b 44 24 08          	mov    0x8(%esp),%eax
  801ce6:	d3 e0                	shl    %cl,%eax
  801ce8:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cec:	8b 44 24 08          	mov    0x8(%esp),%eax
  801cf0:	89 f1                	mov    %esi,%ecx
  801cf2:	d3 e8                	shr    %cl,%eax
  801cf4:	09 d0                	or     %edx,%eax
  801cf6:	d3 eb                	shr    %cl,%ebx
  801cf8:	89 da                	mov    %ebx,%edx
  801cfa:	f7 f7                	div    %edi
  801cfc:	89 d3                	mov    %edx,%ebx
  801cfe:	f7 24 24             	mull   (%esp)
  801d01:	89 c6                	mov    %eax,%esi
  801d03:	89 d1                	mov    %edx,%ecx
  801d05:	39 d3                	cmp    %edx,%ebx
  801d07:	0f 82 87 00 00 00    	jb     801d94 <__umoddi3+0x134>
  801d0d:	0f 84 91 00 00 00    	je     801da4 <__umoddi3+0x144>
  801d13:	8b 54 24 04          	mov    0x4(%esp),%edx
  801d17:	29 f2                	sub    %esi,%edx
  801d19:	19 cb                	sbb    %ecx,%ebx
  801d1b:	89 d8                	mov    %ebx,%eax
  801d1d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801d21:	d3 e0                	shl    %cl,%eax
  801d23:	89 e9                	mov    %ebp,%ecx
  801d25:	d3 ea                	shr    %cl,%edx
  801d27:	09 d0                	or     %edx,%eax
  801d29:	89 e9                	mov    %ebp,%ecx
  801d2b:	d3 eb                	shr    %cl,%ebx
  801d2d:	89 da                	mov    %ebx,%edx
  801d2f:	83 c4 1c             	add    $0x1c,%esp
  801d32:	5b                   	pop    %ebx
  801d33:	5e                   	pop    %esi
  801d34:	5f                   	pop    %edi
  801d35:	5d                   	pop    %ebp
  801d36:	c3                   	ret    
  801d37:	90                   	nop
  801d38:	89 fd                	mov    %edi,%ebp
  801d3a:	85 ff                	test   %edi,%edi
  801d3c:	75 0b                	jne    801d49 <__umoddi3+0xe9>
  801d3e:	b8 01 00 00 00       	mov    $0x1,%eax
  801d43:	31 d2                	xor    %edx,%edx
  801d45:	f7 f7                	div    %edi
  801d47:	89 c5                	mov    %eax,%ebp
  801d49:	89 f0                	mov    %esi,%eax
  801d4b:	31 d2                	xor    %edx,%edx
  801d4d:	f7 f5                	div    %ebp
  801d4f:	89 c8                	mov    %ecx,%eax
  801d51:	f7 f5                	div    %ebp
  801d53:	89 d0                	mov    %edx,%eax
  801d55:	e9 44 ff ff ff       	jmp    801c9e <__umoddi3+0x3e>
  801d5a:	66 90                	xchg   %ax,%ax
  801d5c:	89 c8                	mov    %ecx,%eax
  801d5e:	89 f2                	mov    %esi,%edx
  801d60:	83 c4 1c             	add    $0x1c,%esp
  801d63:	5b                   	pop    %ebx
  801d64:	5e                   	pop    %esi
  801d65:	5f                   	pop    %edi
  801d66:	5d                   	pop    %ebp
  801d67:	c3                   	ret    
  801d68:	3b 04 24             	cmp    (%esp),%eax
  801d6b:	72 06                	jb     801d73 <__umoddi3+0x113>
  801d6d:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801d71:	77 0f                	ja     801d82 <__umoddi3+0x122>
  801d73:	89 f2                	mov    %esi,%edx
  801d75:	29 f9                	sub    %edi,%ecx
  801d77:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801d7b:	89 14 24             	mov    %edx,(%esp)
  801d7e:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d82:	8b 44 24 04          	mov    0x4(%esp),%eax
  801d86:	8b 14 24             	mov    (%esp),%edx
  801d89:	83 c4 1c             	add    $0x1c,%esp
  801d8c:	5b                   	pop    %ebx
  801d8d:	5e                   	pop    %esi
  801d8e:	5f                   	pop    %edi
  801d8f:	5d                   	pop    %ebp
  801d90:	c3                   	ret    
  801d91:	8d 76 00             	lea    0x0(%esi),%esi
  801d94:	2b 04 24             	sub    (%esp),%eax
  801d97:	19 fa                	sbb    %edi,%edx
  801d99:	89 d1                	mov    %edx,%ecx
  801d9b:	89 c6                	mov    %eax,%esi
  801d9d:	e9 71 ff ff ff       	jmp    801d13 <__umoddi3+0xb3>
  801da2:	66 90                	xchg   %ax,%ax
  801da4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801da8:	72 ea                	jb     801d94 <__umoddi3+0x134>
  801daa:	89 d9                	mov    %ebx,%ecx
  801dac:	e9 62 ff ff ff       	jmp    801d13 <__umoddi3+0xb3>
