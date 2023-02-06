
obj/user/tst_placement:     file format elf32-i386


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
  800031:	e8 91 05 00 00       	call   8005c7 <libmain>
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
  80003c:	56                   	push   %esi
  80003d:	53                   	push   %ebx
  80003e:	81 ec ac 00 00 01    	sub    $0x10000ac,%esp

	char arr[PAGE_SIZE*1024*4];

	//("STEP 0: checking Initial WS entries ...\n");
	{
		if( ROUNDDOWN(myEnv->__uptr_pws[0].virtual_address,PAGE_SIZE) !=   0x200000)  	panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800044:	a1 20 30 80 00       	mov    0x803020,%eax
  800049:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  80004f:	8b 00                	mov    (%eax),%eax
  800051:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800054:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800057:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80005c:	3d 00 00 20 00       	cmp    $0x200000,%eax
  800061:	74 14                	je     800077 <_main+0x3f>
  800063:	83 ec 04             	sub    $0x4,%esp
  800066:	68 20 20 80 00       	push   $0x802020
  80006b:	6a 10                	push   $0x10
  80006d:	68 61 20 80 00       	push   $0x802061
  800072:	e8 8c 06 00 00       	call   800703 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[1].virtual_address,PAGE_SIZE) !=   0x201000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800077:	a1 20 30 80 00       	mov    0x803020,%eax
  80007c:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800082:	83 c0 18             	add    $0x18,%eax
  800085:	8b 00                	mov    (%eax),%eax
  800087:	89 45 d8             	mov    %eax,-0x28(%ebp)
  80008a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80008d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800092:	3d 00 10 20 00       	cmp    $0x201000,%eax
  800097:	74 14                	je     8000ad <_main+0x75>
  800099:	83 ec 04             	sub    $0x4,%esp
  80009c:	68 20 20 80 00       	push   $0x802020
  8000a1:	6a 11                	push   $0x11
  8000a3:	68 61 20 80 00       	push   $0x802061
  8000a8:	e8 56 06 00 00       	call   800703 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[2].virtual_address,PAGE_SIZE) !=   0x202000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8000ad:	a1 20 30 80 00       	mov    0x803020,%eax
  8000b2:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  8000b8:	83 c0 30             	add    $0x30,%eax
  8000bb:	8b 00                	mov    (%eax),%eax
  8000bd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  8000c0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8000c3:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8000c8:	3d 00 20 20 00       	cmp    $0x202000,%eax
  8000cd:	74 14                	je     8000e3 <_main+0xab>
  8000cf:	83 ec 04             	sub    $0x4,%esp
  8000d2:	68 20 20 80 00       	push   $0x802020
  8000d7:	6a 12                	push   $0x12
  8000d9:	68 61 20 80 00       	push   $0x802061
  8000de:	e8 20 06 00 00       	call   800703 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[3].virtual_address,PAGE_SIZE) !=   0x203000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8000e3:	a1 20 30 80 00       	mov    0x803020,%eax
  8000e8:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  8000ee:	83 c0 48             	add    $0x48,%eax
  8000f1:	8b 00                	mov    (%eax),%eax
  8000f3:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8000f6:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8000f9:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8000fe:	3d 00 30 20 00       	cmp    $0x203000,%eax
  800103:	74 14                	je     800119 <_main+0xe1>
  800105:	83 ec 04             	sub    $0x4,%esp
  800108:	68 20 20 80 00       	push   $0x802020
  80010d:	6a 13                	push   $0x13
  80010f:	68 61 20 80 00       	push   $0x802061
  800114:	e8 ea 05 00 00       	call   800703 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[4].virtual_address,PAGE_SIZE) !=   0x204000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800119:	a1 20 30 80 00       	mov    0x803020,%eax
  80011e:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800124:	83 c0 60             	add    $0x60,%eax
  800127:	8b 00                	mov    (%eax),%eax
  800129:	89 45 cc             	mov    %eax,-0x34(%ebp)
  80012c:	8b 45 cc             	mov    -0x34(%ebp),%eax
  80012f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800134:	3d 00 40 20 00       	cmp    $0x204000,%eax
  800139:	74 14                	je     80014f <_main+0x117>
  80013b:	83 ec 04             	sub    $0x4,%esp
  80013e:	68 20 20 80 00       	push   $0x802020
  800143:	6a 14                	push   $0x14
  800145:	68 61 20 80 00       	push   $0x802061
  80014a:	e8 b4 05 00 00       	call   800703 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[5].virtual_address,PAGE_SIZE) !=   0x205000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  80014f:	a1 20 30 80 00       	mov    0x803020,%eax
  800154:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  80015a:	83 c0 78             	add    $0x78,%eax
  80015d:	8b 00                	mov    (%eax),%eax
  80015f:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800162:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800165:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80016a:	3d 00 50 20 00       	cmp    $0x205000,%eax
  80016f:	74 14                	je     800185 <_main+0x14d>
  800171:	83 ec 04             	sub    $0x4,%esp
  800174:	68 20 20 80 00       	push   $0x802020
  800179:	6a 15                	push   $0x15
  80017b:	68 61 20 80 00       	push   $0x802061
  800180:	e8 7e 05 00 00       	call   800703 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[6].virtual_address,PAGE_SIZE) !=   0x206000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800185:	a1 20 30 80 00       	mov    0x803020,%eax
  80018a:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800190:	05 90 00 00 00       	add    $0x90,%eax
  800195:	8b 00                	mov    (%eax),%eax
  800197:	89 45 c4             	mov    %eax,-0x3c(%ebp)
  80019a:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  80019d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001a2:	3d 00 60 20 00       	cmp    $0x206000,%eax
  8001a7:	74 14                	je     8001bd <_main+0x185>
  8001a9:	83 ec 04             	sub    $0x4,%esp
  8001ac:	68 20 20 80 00       	push   $0x802020
  8001b1:	6a 16                	push   $0x16
  8001b3:	68 61 20 80 00       	push   $0x802061
  8001b8:	e8 46 05 00 00       	call   800703 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[7].virtual_address,PAGE_SIZE) !=   0x207000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8001bd:	a1 20 30 80 00       	mov    0x803020,%eax
  8001c2:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  8001c8:	05 a8 00 00 00       	add    $0xa8,%eax
  8001cd:	8b 00                	mov    (%eax),%eax
  8001cf:	89 45 c0             	mov    %eax,-0x40(%ebp)
  8001d2:	8b 45 c0             	mov    -0x40(%ebp),%eax
  8001d5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8001da:	3d 00 70 20 00       	cmp    $0x207000,%eax
  8001df:	74 14                	je     8001f5 <_main+0x1bd>
  8001e1:	83 ec 04             	sub    $0x4,%esp
  8001e4:	68 20 20 80 00       	push   $0x802020
  8001e9:	6a 17                	push   $0x17
  8001eb:	68 61 20 80 00       	push   $0x802061
  8001f0:	e8 0e 05 00 00       	call   800703 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[8].virtual_address,PAGE_SIZE) !=   0x800000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8001f5:	a1 20 30 80 00       	mov    0x803020,%eax
  8001fa:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800200:	05 c0 00 00 00       	add    $0xc0,%eax
  800205:	8b 00                	mov    (%eax),%eax
  800207:	89 45 bc             	mov    %eax,-0x44(%ebp)
  80020a:	8b 45 bc             	mov    -0x44(%ebp),%eax
  80020d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800212:	3d 00 00 80 00       	cmp    $0x800000,%eax
  800217:	74 14                	je     80022d <_main+0x1f5>
  800219:	83 ec 04             	sub    $0x4,%esp
  80021c:	68 20 20 80 00       	push   $0x802020
  800221:	6a 18                	push   $0x18
  800223:	68 61 20 80 00       	push   $0x802061
  800228:	e8 d6 04 00 00       	call   800703 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[9].virtual_address,PAGE_SIZE) !=   0x801000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  80022d:	a1 20 30 80 00       	mov    0x803020,%eax
  800232:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800238:	05 d8 00 00 00       	add    $0xd8,%eax
  80023d:	8b 00                	mov    (%eax),%eax
  80023f:	89 45 b8             	mov    %eax,-0x48(%ebp)
  800242:	8b 45 b8             	mov    -0x48(%ebp),%eax
  800245:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80024a:	3d 00 10 80 00       	cmp    $0x801000,%eax
  80024f:	74 14                	je     800265 <_main+0x22d>
  800251:	83 ec 04             	sub    $0x4,%esp
  800254:	68 20 20 80 00       	push   $0x802020
  800259:	6a 19                	push   $0x19
  80025b:	68 61 20 80 00       	push   $0x802061
  800260:	e8 9e 04 00 00       	call   800703 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[10].virtual_address,PAGE_SIZE) !=   0x802000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800265:	a1 20 30 80 00       	mov    0x803020,%eax
  80026a:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  800270:	05 f0 00 00 00       	add    $0xf0,%eax
  800275:	8b 00                	mov    (%eax),%eax
  800277:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  80027a:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  80027d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800282:	3d 00 20 80 00       	cmp    $0x802000,%eax
  800287:	74 14                	je     80029d <_main+0x265>
  800289:	83 ec 04             	sub    $0x4,%esp
  80028c:	68 20 20 80 00       	push   $0x802020
  800291:	6a 1a                	push   $0x1a
  800293:	68 61 20 80 00       	push   $0x802061
  800298:	e8 66 04 00 00       	call   800703 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[11].virtual_address,PAGE_SIZE) !=   0x803000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  80029d:	a1 20 30 80 00       	mov    0x803020,%eax
  8002a2:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  8002a8:	05 08 01 00 00       	add    $0x108,%eax
  8002ad:	8b 00                	mov    (%eax),%eax
  8002af:	89 45 b0             	mov    %eax,-0x50(%ebp)
  8002b2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  8002b5:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8002ba:	3d 00 30 80 00       	cmp    $0x803000,%eax
  8002bf:	74 14                	je     8002d5 <_main+0x29d>
  8002c1:	83 ec 04             	sub    $0x4,%esp
  8002c4:	68 20 20 80 00       	push   $0x802020
  8002c9:	6a 1b                	push   $0x1b
  8002cb:	68 61 20 80 00       	push   $0x802061
  8002d0:	e8 2e 04 00 00       	call   800703 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[12].virtual_address,PAGE_SIZE) !=   0xeebfd000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  8002d5:	a1 20 30 80 00       	mov    0x803020,%eax
  8002da:	8b 80 9c 05 00 00    	mov    0x59c(%eax),%eax
  8002e0:	05 20 01 00 00       	add    $0x120,%eax
  8002e5:	8b 00                	mov    (%eax),%eax
  8002e7:	89 45 ac             	mov    %eax,-0x54(%ebp)
  8002ea:	8b 45 ac             	mov    -0x54(%ebp),%eax
  8002ed:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  8002f2:	3d 00 d0 bf ee       	cmp    $0xeebfd000,%eax
  8002f7:	74 14                	je     80030d <_main+0x2d5>
  8002f9:	83 ec 04             	sub    $0x4,%esp
  8002fc:	68 20 20 80 00       	push   $0x802020
  800301:	6a 1c                	push   $0x1c
  800303:	68 61 20 80 00       	push   $0x802061
  800308:	e8 f6 03 00 00       	call   800703 <_panic>

		for (int k = 13; k < 20; k++)
  80030d:	c7 45 e4 0d 00 00 00 	movl   $0xd,-0x1c(%ebp)
  800314:	eb 37                	jmp    80034d <_main+0x315>
			if( myEnv->__uptr_pws[k].empty !=  1)
  800316:	a1 20 30 80 00       	mov    0x803020,%eax
  80031b:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800321:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800324:	89 d0                	mov    %edx,%eax
  800326:	01 c0                	add    %eax,%eax
  800328:	01 d0                	add    %edx,%eax
  80032a:	c1 e0 03             	shl    $0x3,%eax
  80032d:	01 c8                	add    %ecx,%eax
  80032f:	8a 40 04             	mov    0x4(%eax),%al
  800332:	3c 01                	cmp    $0x1,%al
  800334:	74 14                	je     80034a <_main+0x312>
				panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
  800336:	83 ec 04             	sub    $0x4,%esp
  800339:	68 20 20 80 00       	push   $0x802020
  80033e:	6a 20                	push   $0x20
  800340:	68 61 20 80 00       	push   $0x802061
  800345:	e8 b9 03 00 00       	call   800703 <_panic>
		if( ROUNDDOWN(myEnv->__uptr_pws[9].virtual_address,PAGE_SIZE) !=   0x801000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
		if( ROUNDDOWN(myEnv->__uptr_pws[10].virtual_address,PAGE_SIZE) !=   0x802000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
		if( ROUNDDOWN(myEnv->__uptr_pws[11].virtual_address,PAGE_SIZE) !=   0x803000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");
		if( ROUNDDOWN(myEnv->__uptr_pws[12].virtual_address,PAGE_SIZE) !=   0xeebfd000)  panic("INITIAL PAGE WS entry checking failed! Review size of the WS..!!");

		for (int k = 13; k < 20; k++)
  80034a:	ff 45 e4             	incl   -0x1c(%ebp)
  80034d:	83 7d e4 13          	cmpl   $0x13,-0x1c(%ebp)
  800351:	7e c3                	jle    800316 <_main+0x2de>
		/*NO NEED FOR THIS AS WE WORK ON "LRU"*/
		//if( myEnv->page_last_WS_index !=  12)  											panic("INITIAL PAGE last index checking failed! Review size of the WS..!!");
		/*====================================*/
	}

	int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  800353:	e8 75 15 00 00       	call   8018cd <sys_pf_calculate_allocated_pages>
  800358:	89 45 a8             	mov    %eax,-0x58(%ebp)
	int freePages = sys_calculate_free_frames();
  80035b:	e8 cd 14 00 00       	call   80182d <sys_calculate_free_frames>
  800360:	89 45 a4             	mov    %eax,-0x5c(%ebp)
	int i=0;
  800363:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
	for(;i<=PAGE_SIZE;i++)
  80036a:	eb 11                	jmp    80037d <_main+0x345>
	{
		arr[i] = -1;
  80036c:	8d 95 a4 ff ff fe    	lea    -0x100005c(%ebp),%edx
  800372:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800375:	01 d0                	add    %edx,%eax
  800377:	c6 00 ff             	movb   $0xff,(%eax)
	}

	int usedDiskPages = sys_pf_calculate_allocated_pages() ;
	int freePages = sys_calculate_free_frames();
	int i=0;
	for(;i<=PAGE_SIZE;i++)
  80037a:	ff 45 e0             	incl   -0x20(%ebp)
  80037d:	81 7d e0 00 10 00 00 	cmpl   $0x1000,-0x20(%ebp)
  800384:	7e e6                	jle    80036c <_main+0x334>
	{
		arr[i] = -1;
	}

	i=PAGE_SIZE*1024;
  800386:	c7 45 e0 00 00 40 00 	movl   $0x400000,-0x20(%ebp)
	for(;i<=(PAGE_SIZE*1024 + PAGE_SIZE);i++)
  80038d:	eb 11                	jmp    8003a0 <_main+0x368>
	{
		arr[i] = -1;
  80038f:	8d 95 a4 ff ff fe    	lea    -0x100005c(%ebp),%edx
  800395:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800398:	01 d0                	add    %edx,%eax
  80039a:	c6 00 ff             	movb   $0xff,(%eax)
	{
		arr[i] = -1;
	}

	i=PAGE_SIZE*1024;
	for(;i<=(PAGE_SIZE*1024 + PAGE_SIZE);i++)
  80039d:	ff 45 e0             	incl   -0x20(%ebp)
  8003a0:	81 7d e0 00 10 40 00 	cmpl   $0x401000,-0x20(%ebp)
  8003a7:	7e e6                	jle    80038f <_main+0x357>
	{
		arr[i] = -1;
	}

	i=PAGE_SIZE*1024*2;
  8003a9:	c7 45 e0 00 00 80 00 	movl   $0x800000,-0x20(%ebp)
	for(;i<=(PAGE_SIZE*1024*2 + PAGE_SIZE);i++)
  8003b0:	eb 11                	jmp    8003c3 <_main+0x38b>
	{
		arr[i] = -1;
  8003b2:	8d 95 a4 ff ff fe    	lea    -0x100005c(%ebp),%edx
  8003b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8003bb:	01 d0                	add    %edx,%eax
  8003bd:	c6 00 ff             	movb   $0xff,(%eax)
	{
		arr[i] = -1;
	}

	i=PAGE_SIZE*1024*2;
	for(;i<=(PAGE_SIZE*1024*2 + PAGE_SIZE);i++)
  8003c0:	ff 45 e0             	incl   -0x20(%ebp)
  8003c3:	81 7d e0 00 10 80 00 	cmpl   $0x801000,-0x20(%ebp)
  8003ca:	7e e6                	jle    8003b2 <_main+0x37a>
	{
		arr[i] = -1;
	}

	cprintf("STEP A: checking PLACEMENT fault handling ... \n");
  8003cc:	83 ec 0c             	sub    $0xc,%esp
  8003cf:	68 78 20 80 00       	push   $0x802078
  8003d4:	e8 de 05 00 00       	call   8009b7 <cprintf>
  8003d9:	83 c4 10             	add    $0x10,%esp
	{
		if( arr[0] !=  -1)  panic("PLACEMENT of stack page failed");
  8003dc:	8a 85 a4 ff ff fe    	mov    -0x100005c(%ebp),%al
  8003e2:	3c ff                	cmp    $0xff,%al
  8003e4:	74 14                	je     8003fa <_main+0x3c2>
  8003e6:	83 ec 04             	sub    $0x4,%esp
  8003e9:	68 a8 20 80 00       	push   $0x8020a8
  8003ee:	6a 3d                	push   $0x3d
  8003f0:	68 61 20 80 00       	push   $0x802061
  8003f5:	e8 09 03 00 00       	call   800703 <_panic>
		if( arr[PAGE_SIZE] !=  -1)  panic("PLACEMENT of stack page failed");
  8003fa:	8a 85 a4 0f 00 ff    	mov    -0xfff05c(%ebp),%al
  800400:	3c ff                	cmp    $0xff,%al
  800402:	74 14                	je     800418 <_main+0x3e0>
  800404:	83 ec 04             	sub    $0x4,%esp
  800407:	68 a8 20 80 00       	push   $0x8020a8
  80040c:	6a 3e                	push   $0x3e
  80040e:	68 61 20 80 00       	push   $0x802061
  800413:	e8 eb 02 00 00       	call   800703 <_panic>

		if( arr[PAGE_SIZE*1024] !=  -1)  panic("PLACEMENT of stack page failed");
  800418:	8a 85 a4 ff 3f ff    	mov    -0xc0005c(%ebp),%al
  80041e:	3c ff                	cmp    $0xff,%al
  800420:	74 14                	je     800436 <_main+0x3fe>
  800422:	83 ec 04             	sub    $0x4,%esp
  800425:	68 a8 20 80 00       	push   $0x8020a8
  80042a:	6a 40                	push   $0x40
  80042c:	68 61 20 80 00       	push   $0x802061
  800431:	e8 cd 02 00 00       	call   800703 <_panic>
		if( arr[PAGE_SIZE*1025] !=  -1)  panic("PLACEMENT of stack page failed");
  800436:	8a 85 a4 0f 40 ff    	mov    -0xbff05c(%ebp),%al
  80043c:	3c ff                	cmp    $0xff,%al
  80043e:	74 14                	je     800454 <_main+0x41c>
  800440:	83 ec 04             	sub    $0x4,%esp
  800443:	68 a8 20 80 00       	push   $0x8020a8
  800448:	6a 41                	push   $0x41
  80044a:	68 61 20 80 00       	push   $0x802061
  80044f:	e8 af 02 00 00       	call   800703 <_panic>

		if( arr[PAGE_SIZE*1024*2] !=  -1)  panic("PLACEMENT of stack page failed");
  800454:	8a 85 a4 ff 7f ff    	mov    -0x80005c(%ebp),%al
  80045a:	3c ff                	cmp    $0xff,%al
  80045c:	74 14                	je     800472 <_main+0x43a>
  80045e:	83 ec 04             	sub    $0x4,%esp
  800461:	68 a8 20 80 00       	push   $0x8020a8
  800466:	6a 43                	push   $0x43
  800468:	68 61 20 80 00       	push   $0x802061
  80046d:	e8 91 02 00 00       	call   800703 <_panic>
		if( arr[PAGE_SIZE*1024*2 + PAGE_SIZE] !=  -1)  panic("PLACEMENT of stack page failed");
  800472:	8a 85 a4 0f 80 ff    	mov    -0x7ff05c(%ebp),%al
  800478:	3c ff                	cmp    $0xff,%al
  80047a:	74 14                	je     800490 <_main+0x458>
  80047c:	83 ec 04             	sub    $0x4,%esp
  80047f:	68 a8 20 80 00       	push   $0x8020a8
  800484:	6a 44                	push   $0x44
  800486:	68 61 20 80 00       	push   $0x802061
  80048b:	e8 73 02 00 00       	call   800703 <_panic>


		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  0) panic("new stack pages are not written to Page File");
  800490:	e8 38 14 00 00       	call   8018cd <sys_pf_calculate_allocated_pages>
  800495:	3b 45 a8             	cmp    -0x58(%ebp),%eax
  800498:	74 14                	je     8004ae <_main+0x476>
  80049a:	83 ec 04             	sub    $0x4,%esp
  80049d:	68 c8 20 80 00       	push   $0x8020c8
  8004a2:	6a 47                	push   $0x47
  8004a4:	68 61 20 80 00       	push   $0x802061
  8004a9:	e8 55 02 00 00       	call   800703 <_panic>

		if( (freePages - sys_calculate_free_frames() ) != 7 ) panic("allocated memory size incorrect");
  8004ae:	8b 5d a4             	mov    -0x5c(%ebp),%ebx
  8004b1:	e8 77 13 00 00       	call   80182d <sys_calculate_free_frames>
  8004b6:	29 c3                	sub    %eax,%ebx
  8004b8:	89 d8                	mov    %ebx,%eax
  8004ba:	83 f8 07             	cmp    $0x7,%eax
  8004bd:	74 14                	je     8004d3 <_main+0x49b>
  8004bf:	83 ec 04             	sub    $0x4,%esp
  8004c2:	68 f8 20 80 00       	push   $0x8020f8
  8004c7:	6a 49                	push   $0x49
  8004c9:	68 61 20 80 00       	push   $0x802061
  8004ce:	e8 30 02 00 00       	call   800703 <_panic>
	}
	cprintf("STEP A passed: PLACEMENT fault handling works!\n\n\n");
  8004d3:	83 ec 0c             	sub    $0xc,%esp
  8004d6:	68 18 21 80 00       	push   $0x802118
  8004db:	e8 d7 04 00 00       	call   8009b7 <cprintf>
  8004e0:	83 c4 10             	add    $0x10,%esp


	uint32 expectedPages[20] = {0x200000,0x201000,0x202000,0x203000,0x204000,0x205000,0x206000,0x207000,0x800000,0x801000,0x802000,0x803000,0xeebfd000,0xedbfd000,0xedbfe000,0xedffd000,0xedffe000,0xee3fd000,0xee3fe000,0};
  8004e3:	8d 85 54 ff ff fe    	lea    -0x10000ac(%ebp),%eax
  8004e9:	bb 40 22 80 00       	mov    $0x802240,%ebx
  8004ee:	ba 14 00 00 00       	mov    $0x14,%edx
  8004f3:	89 c7                	mov    %eax,%edi
  8004f5:	89 de                	mov    %ebx,%esi
  8004f7:	89 d1                	mov    %edx,%ecx
  8004f9:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)

	cprintf("STEP B: checking WS entries ...\n");
  8004fb:	83 ec 0c             	sub    $0xc,%esp
  8004fe:	68 4c 21 80 00       	push   $0x80214c
  800503:	e8 af 04 00 00       	call   8009b7 <cprintf>
  800508:	83 c4 10             	add    $0x10,%esp
	{
		CheckWSWithoutLastIndex(expectedPages, 20);
  80050b:	83 ec 08             	sub    $0x8,%esp
  80050e:	6a 14                	push   $0x14
  800510:	8d 85 54 ff ff fe    	lea    -0x10000ac(%ebp),%eax
  800516:	50                   	push   %eax
  800517:	e8 59 02 00 00       	call   800775 <CheckWSWithoutLastIndex>
  80051c:	83 c4 10             	add    $0x10,%esp
	//		if( ROUNDDOWN(myEnv->__uptr_pws[14].virtual_address,PAGE_SIZE) !=  0xedffd000)  panic("PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	//		if( ROUNDDOWN(myEnv->__uptr_pws[15].virtual_address,PAGE_SIZE) !=  0xedffe000)  panic("PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	//		if( ROUNDDOWN(myEnv->__uptr_pws[16].virtual_address,PAGE_SIZE) !=  0xee3fd000)  panic("PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	//		if( ROUNDDOWN(myEnv->__uptr_pws[17].virtual_address,PAGE_SIZE) !=  0xee3fe000)  panic("PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	cprintf("STEP B passed: WS entries test are correct\n\n\n");
  80051f:	83 ec 0c             	sub    $0xc,%esp
  800522:	68 70 21 80 00       	push   $0x802170
  800527:	e8 8b 04 00 00       	call   8009b7 <cprintf>
  80052c:	83 c4 10             	add    $0x10,%esp

	cprintf("STEP C: checking working sets WHEN BECOMES FULL...\n");
  80052f:	83 ec 0c             	sub    $0xc,%esp
  800532:	68 a0 21 80 00       	push   $0x8021a0
  800537:	e8 7b 04 00 00       	call   8009b7 <cprintf>
  80053c:	83 c4 10             	add    $0x10,%esp
	{
		/*NO NEED FOR THIS AS WE WORK ON "LRU"*/
		//if(myEnv->page_last_WS_index != 18) panic("wrong PAGE WS pointer location... trace it by printing page WS before & after fault");

		i=PAGE_SIZE*1024*3;
  80053f:	c7 45 e0 00 00 c0 00 	movl   $0xc00000,-0x20(%ebp)
		for(;i<=(PAGE_SIZE*1024*3);i++)
  800546:	eb 11                	jmp    800559 <_main+0x521>
		{
			arr[i] = -1;
  800548:	8d 95 a4 ff ff fe    	lea    -0x100005c(%ebp),%edx
  80054e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800551:	01 d0                	add    %edx,%eax
  800553:	c6 00 ff             	movb   $0xff,(%eax)
	{
		/*NO NEED FOR THIS AS WE WORK ON "LRU"*/
		//if(myEnv->page_last_WS_index != 18) panic("wrong PAGE WS pointer location... trace it by printing page WS before & after fault");

		i=PAGE_SIZE*1024*3;
		for(;i<=(PAGE_SIZE*1024*3);i++)
  800556:	ff 45 e0             	incl   -0x20(%ebp)
  800559:	81 7d e0 00 00 c0 00 	cmpl   $0xc00000,-0x20(%ebp)
  800560:	7e e6                	jle    800548 <_main+0x510>
		{
			arr[i] = -1;
		}

		if( arr[PAGE_SIZE*1024*3] !=  -1)  panic("PLACEMENT of stack page failed");
  800562:	8a 85 a4 ff bf ff    	mov    -0x40005c(%ebp),%al
  800568:	3c ff                	cmp    $0xff,%al
  80056a:	74 14                	je     800580 <_main+0x548>
  80056c:	83 ec 04             	sub    $0x4,%esp
  80056f:	68 a8 20 80 00       	push   $0x8020a8
  800574:	6a 72                	push   $0x72
  800576:	68 61 20 80 00       	push   $0x802061
  80057b:	e8 83 01 00 00       	call   800703 <_panic>
//		if( arr[PAGE_SIZE*1024*3 + PAGE_SIZE] !=  -1)  panic("PLACEMENT of stack page failed");

		//expectedPages[18] = 0xee7fd000;
		expectedPages[19] = 0xee7fd000;
  800580:	c7 85 a0 ff ff fe 00 	movl   $0xee7fd000,-0x1000060(%ebp)
  800587:	d0 7f ee 
//		expectedPages[0] = 0xee7fe000;
		CheckWSWithoutLastIndex(expectedPages, 20);
  80058a:	83 ec 08             	sub    $0x8,%esp
  80058d:	6a 14                	push   $0x14
  80058f:	8d 85 54 ff ff fe    	lea    -0x10000ac(%ebp),%eax
  800595:	50                   	push   %eax
  800596:	e8 da 01 00 00       	call   800775 <CheckWSWithoutLastIndex>
  80059b:	83 c4 10             	add    $0x10,%esp

		/*NO NEED FOR THIS AS WE WORK ON "LRU"*/
		//if(myEnv->page_last_WS_index != 0) panic("wrong PAGE WS pointer location... trace it by printing page WS before & after fault");

	}
	cprintf("STEP C passed: WS is FULL now\n\n\n");
  80059e:	83 ec 0c             	sub    $0xc,%esp
  8005a1:	68 d4 21 80 00       	push   $0x8021d4
  8005a6:	e8 0c 04 00 00       	call   8009b7 <cprintf>
  8005ab:	83 c4 10             	add    $0x10,%esp

	cprintf("Congratulations!! Test of PAGE PLACEMENT completed successfully!!\n\n\n");
  8005ae:	83 ec 0c             	sub    $0xc,%esp
  8005b1:	68 f8 21 80 00       	push   $0x8021f8
  8005b6:	e8 fc 03 00 00       	call   8009b7 <cprintf>
  8005bb:	83 c4 10             	add    $0x10,%esp
	return;
  8005be:	90                   	nop
}
  8005bf:	8d 65 f4             	lea    -0xc(%ebp),%esp
  8005c2:	5b                   	pop    %ebx
  8005c3:	5e                   	pop    %esi
  8005c4:	5f                   	pop    %edi
  8005c5:	5d                   	pop    %ebp
  8005c6:	c3                   	ret    

008005c7 <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8005c7:	55                   	push   %ebp
  8005c8:	89 e5                	mov    %esp,%ebp
  8005ca:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8005cd:	e8 3b 15 00 00       	call   801b0d <sys_getenvindex>
  8005d2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8005d5:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8005d8:	89 d0                	mov    %edx,%eax
  8005da:	c1 e0 03             	shl    $0x3,%eax
  8005dd:	01 d0                	add    %edx,%eax
  8005df:	01 c0                	add    %eax,%eax
  8005e1:	01 d0                	add    %edx,%eax
  8005e3:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005ea:	01 d0                	add    %edx,%eax
  8005ec:	c1 e0 04             	shl    $0x4,%eax
  8005ef:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8005f4:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8005f9:	a1 20 30 80 00       	mov    0x803020,%eax
  8005fe:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  800604:	84 c0                	test   %al,%al
  800606:	74 0f                	je     800617 <libmain+0x50>
		binaryname = myEnv->prog_name;
  800608:	a1 20 30 80 00       	mov    0x803020,%eax
  80060d:	05 5c 05 00 00       	add    $0x55c,%eax
  800612:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  800617:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  80061b:	7e 0a                	jle    800627 <libmain+0x60>
		binaryname = argv[0];
  80061d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800620:	8b 00                	mov    (%eax),%eax
  800622:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  800627:	83 ec 08             	sub    $0x8,%esp
  80062a:	ff 75 0c             	pushl  0xc(%ebp)
  80062d:	ff 75 08             	pushl  0x8(%ebp)
  800630:	e8 03 fa ff ff       	call   800038 <_main>
  800635:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  800638:	e8 dd 12 00 00       	call   80191a <sys_disable_interrupt>
	cprintf("**************************************\n");
  80063d:	83 ec 0c             	sub    $0xc,%esp
  800640:	68 a8 22 80 00       	push   $0x8022a8
  800645:	e8 6d 03 00 00       	call   8009b7 <cprintf>
  80064a:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  80064d:	a1 20 30 80 00       	mov    0x803020,%eax
  800652:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  800658:	a1 20 30 80 00       	mov    0x803020,%eax
  80065d:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800663:	83 ec 04             	sub    $0x4,%esp
  800666:	52                   	push   %edx
  800667:	50                   	push   %eax
  800668:	68 d0 22 80 00       	push   $0x8022d0
  80066d:	e8 45 03 00 00       	call   8009b7 <cprintf>
  800672:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  800675:	a1 20 30 80 00       	mov    0x803020,%eax
  80067a:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800680:	a1 20 30 80 00       	mov    0x803020,%eax
  800685:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  80068b:	a1 20 30 80 00       	mov    0x803020,%eax
  800690:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  800696:	51                   	push   %ecx
  800697:	52                   	push   %edx
  800698:	50                   	push   %eax
  800699:	68 f8 22 80 00       	push   $0x8022f8
  80069e:	e8 14 03 00 00       	call   8009b7 <cprintf>
  8006a3:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  8006a6:	a1 20 30 80 00       	mov    0x803020,%eax
  8006ab:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  8006b1:	83 ec 08             	sub    $0x8,%esp
  8006b4:	50                   	push   %eax
  8006b5:	68 50 23 80 00       	push   $0x802350
  8006ba:	e8 f8 02 00 00       	call   8009b7 <cprintf>
  8006bf:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8006c2:	83 ec 0c             	sub    $0xc,%esp
  8006c5:	68 a8 22 80 00       	push   $0x8022a8
  8006ca:	e8 e8 02 00 00       	call   8009b7 <cprintf>
  8006cf:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8006d2:	e8 5d 12 00 00       	call   801934 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8006d7:	e8 19 00 00 00       	call   8006f5 <exit>
}
  8006dc:	90                   	nop
  8006dd:	c9                   	leave  
  8006de:	c3                   	ret    

008006df <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8006df:	55                   	push   %ebp
  8006e0:	89 e5                	mov    %esp,%ebp
  8006e2:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8006e5:	83 ec 0c             	sub    $0xc,%esp
  8006e8:	6a 00                	push   $0x0
  8006ea:	e8 ea 13 00 00       	call   801ad9 <sys_destroy_env>
  8006ef:	83 c4 10             	add    $0x10,%esp
}
  8006f2:	90                   	nop
  8006f3:	c9                   	leave  
  8006f4:	c3                   	ret    

008006f5 <exit>:

void
exit(void)
{
  8006f5:	55                   	push   %ebp
  8006f6:	89 e5                	mov    %esp,%ebp
  8006f8:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8006fb:	e8 3f 14 00 00       	call   801b3f <sys_exit_env>
}
  800700:	90                   	nop
  800701:	c9                   	leave  
  800702:	c3                   	ret    

00800703 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  800703:	55                   	push   %ebp
  800704:	89 e5                	mov    %esp,%ebp
  800706:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  800709:	8d 45 10             	lea    0x10(%ebp),%eax
  80070c:	83 c0 04             	add    $0x4,%eax
  80070f:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  800712:	a1 5c 31 80 00       	mov    0x80315c,%eax
  800717:	85 c0                	test   %eax,%eax
  800719:	74 16                	je     800731 <_panic+0x2e>
		cprintf("%s: ", argv0);
  80071b:	a1 5c 31 80 00       	mov    0x80315c,%eax
  800720:	83 ec 08             	sub    $0x8,%esp
  800723:	50                   	push   %eax
  800724:	68 64 23 80 00       	push   $0x802364
  800729:	e8 89 02 00 00       	call   8009b7 <cprintf>
  80072e:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800731:	a1 00 30 80 00       	mov    0x803000,%eax
  800736:	ff 75 0c             	pushl  0xc(%ebp)
  800739:	ff 75 08             	pushl  0x8(%ebp)
  80073c:	50                   	push   %eax
  80073d:	68 69 23 80 00       	push   $0x802369
  800742:	e8 70 02 00 00       	call   8009b7 <cprintf>
  800747:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80074a:	8b 45 10             	mov    0x10(%ebp),%eax
  80074d:	83 ec 08             	sub    $0x8,%esp
  800750:	ff 75 f4             	pushl  -0xc(%ebp)
  800753:	50                   	push   %eax
  800754:	e8 f3 01 00 00       	call   80094c <vcprintf>
  800759:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  80075c:	83 ec 08             	sub    $0x8,%esp
  80075f:	6a 00                	push   $0x0
  800761:	68 85 23 80 00       	push   $0x802385
  800766:	e8 e1 01 00 00       	call   80094c <vcprintf>
  80076b:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  80076e:	e8 82 ff ff ff       	call   8006f5 <exit>

	// should not return here
	while (1) ;
  800773:	eb fe                	jmp    800773 <_panic+0x70>

00800775 <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  800775:	55                   	push   %ebp
  800776:	89 e5                	mov    %esp,%ebp
  800778:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  80077b:	a1 20 30 80 00       	mov    0x803020,%eax
  800780:	8b 50 74             	mov    0x74(%eax),%edx
  800783:	8b 45 0c             	mov    0xc(%ebp),%eax
  800786:	39 c2                	cmp    %eax,%edx
  800788:	74 14                	je     80079e <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80078a:	83 ec 04             	sub    $0x4,%esp
  80078d:	68 88 23 80 00       	push   $0x802388
  800792:	6a 26                	push   $0x26
  800794:	68 d4 23 80 00       	push   $0x8023d4
  800799:	e8 65 ff ff ff       	call   800703 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  80079e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  8007a5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8007ac:	e9 c2 00 00 00       	jmp    800873 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  8007b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8007b4:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8007bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8007be:	01 d0                	add    %edx,%eax
  8007c0:	8b 00                	mov    (%eax),%eax
  8007c2:	85 c0                	test   %eax,%eax
  8007c4:	75 08                	jne    8007ce <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8007c6:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8007c9:	e9 a2 00 00 00       	jmp    800870 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8007ce:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8007d5:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8007dc:	eb 69                	jmp    800847 <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8007de:	a1 20 30 80 00       	mov    0x803020,%eax
  8007e3:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8007e9:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8007ec:	89 d0                	mov    %edx,%eax
  8007ee:	01 c0                	add    %eax,%eax
  8007f0:	01 d0                	add    %edx,%eax
  8007f2:	c1 e0 03             	shl    $0x3,%eax
  8007f5:	01 c8                	add    %ecx,%eax
  8007f7:	8a 40 04             	mov    0x4(%eax),%al
  8007fa:	84 c0                	test   %al,%al
  8007fc:	75 46                	jne    800844 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8007fe:	a1 20 30 80 00       	mov    0x803020,%eax
  800803:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800809:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80080c:	89 d0                	mov    %edx,%eax
  80080e:	01 c0                	add    %eax,%eax
  800810:	01 d0                	add    %edx,%eax
  800812:	c1 e0 03             	shl    $0x3,%eax
  800815:	01 c8                	add    %ecx,%eax
  800817:	8b 00                	mov    (%eax),%eax
  800819:	89 45 dc             	mov    %eax,-0x24(%ebp)
  80081c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80081f:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800824:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  800826:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800829:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800830:	8b 45 08             	mov    0x8(%ebp),%eax
  800833:	01 c8                	add    %ecx,%eax
  800835:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  800837:	39 c2                	cmp    %eax,%edx
  800839:	75 09                	jne    800844 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  80083b:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800842:	eb 12                	jmp    800856 <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800844:	ff 45 e8             	incl   -0x18(%ebp)
  800847:	a1 20 30 80 00       	mov    0x803020,%eax
  80084c:	8b 50 74             	mov    0x74(%eax),%edx
  80084f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800852:	39 c2                	cmp    %eax,%edx
  800854:	77 88                	ja     8007de <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  800856:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80085a:	75 14                	jne    800870 <CheckWSWithoutLastIndex+0xfb>
			panic(
  80085c:	83 ec 04             	sub    $0x4,%esp
  80085f:	68 e0 23 80 00       	push   $0x8023e0
  800864:	6a 3a                	push   $0x3a
  800866:	68 d4 23 80 00       	push   $0x8023d4
  80086b:	e8 93 fe ff ff       	call   800703 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800870:	ff 45 f0             	incl   -0x10(%ebp)
  800873:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800876:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800879:	0f 8c 32 ff ff ff    	jl     8007b1 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  80087f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800886:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  80088d:	eb 26                	jmp    8008b5 <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  80088f:	a1 20 30 80 00       	mov    0x803020,%eax
  800894:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80089a:	8b 55 e0             	mov    -0x20(%ebp),%edx
  80089d:	89 d0                	mov    %edx,%eax
  80089f:	01 c0                	add    %eax,%eax
  8008a1:	01 d0                	add    %edx,%eax
  8008a3:	c1 e0 03             	shl    $0x3,%eax
  8008a6:	01 c8                	add    %ecx,%eax
  8008a8:	8a 40 04             	mov    0x4(%eax),%al
  8008ab:	3c 01                	cmp    $0x1,%al
  8008ad:	75 03                	jne    8008b2 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  8008af:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8008b2:	ff 45 e0             	incl   -0x20(%ebp)
  8008b5:	a1 20 30 80 00       	mov    0x803020,%eax
  8008ba:	8b 50 74             	mov    0x74(%eax),%edx
  8008bd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008c0:	39 c2                	cmp    %eax,%edx
  8008c2:	77 cb                	ja     80088f <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8008c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8008c7:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8008ca:	74 14                	je     8008e0 <CheckWSWithoutLastIndex+0x16b>
		panic(
  8008cc:	83 ec 04             	sub    $0x4,%esp
  8008cf:	68 34 24 80 00       	push   $0x802434
  8008d4:	6a 44                	push   $0x44
  8008d6:	68 d4 23 80 00       	push   $0x8023d4
  8008db:	e8 23 fe ff ff       	call   800703 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8008e0:	90                   	nop
  8008e1:	c9                   	leave  
  8008e2:	c3                   	ret    

008008e3 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8008e3:	55                   	push   %ebp
  8008e4:	89 e5                	mov    %esp,%ebp
  8008e6:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8008e9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008ec:	8b 00                	mov    (%eax),%eax
  8008ee:	8d 48 01             	lea    0x1(%eax),%ecx
  8008f1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008f4:	89 0a                	mov    %ecx,(%edx)
  8008f6:	8b 55 08             	mov    0x8(%ebp),%edx
  8008f9:	88 d1                	mov    %dl,%cl
  8008fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8008fe:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  800902:	8b 45 0c             	mov    0xc(%ebp),%eax
  800905:	8b 00                	mov    (%eax),%eax
  800907:	3d ff 00 00 00       	cmp    $0xff,%eax
  80090c:	75 2c                	jne    80093a <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  80090e:	a0 24 30 80 00       	mov    0x803024,%al
  800913:	0f b6 c0             	movzbl %al,%eax
  800916:	8b 55 0c             	mov    0xc(%ebp),%edx
  800919:	8b 12                	mov    (%edx),%edx
  80091b:	89 d1                	mov    %edx,%ecx
  80091d:	8b 55 0c             	mov    0xc(%ebp),%edx
  800920:	83 c2 08             	add    $0x8,%edx
  800923:	83 ec 04             	sub    $0x4,%esp
  800926:	50                   	push   %eax
  800927:	51                   	push   %ecx
  800928:	52                   	push   %edx
  800929:	e8 3e 0e 00 00       	call   80176c <sys_cputs>
  80092e:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800931:	8b 45 0c             	mov    0xc(%ebp),%eax
  800934:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80093a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80093d:	8b 40 04             	mov    0x4(%eax),%eax
  800940:	8d 50 01             	lea    0x1(%eax),%edx
  800943:	8b 45 0c             	mov    0xc(%ebp),%eax
  800946:	89 50 04             	mov    %edx,0x4(%eax)
}
  800949:	90                   	nop
  80094a:	c9                   	leave  
  80094b:	c3                   	ret    

0080094c <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  80094c:	55                   	push   %ebp
  80094d:	89 e5                	mov    %esp,%ebp
  80094f:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  800955:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  80095c:	00 00 00 
	b.cnt = 0;
  80095f:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  800966:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  800969:	ff 75 0c             	pushl  0xc(%ebp)
  80096c:	ff 75 08             	pushl  0x8(%ebp)
  80096f:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800975:	50                   	push   %eax
  800976:	68 e3 08 80 00       	push   $0x8008e3
  80097b:	e8 11 02 00 00       	call   800b91 <vprintfmt>
  800980:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800983:	a0 24 30 80 00       	mov    0x803024,%al
  800988:	0f b6 c0             	movzbl %al,%eax
  80098b:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800991:	83 ec 04             	sub    $0x4,%esp
  800994:	50                   	push   %eax
  800995:	52                   	push   %edx
  800996:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80099c:	83 c0 08             	add    $0x8,%eax
  80099f:	50                   	push   %eax
  8009a0:	e8 c7 0d 00 00       	call   80176c <sys_cputs>
  8009a5:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  8009a8:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  8009af:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  8009b5:	c9                   	leave  
  8009b6:	c3                   	ret    

008009b7 <cprintf>:

int cprintf(const char *fmt, ...) {
  8009b7:	55                   	push   %ebp
  8009b8:	89 e5                	mov    %esp,%ebp
  8009ba:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8009bd:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  8009c4:	8d 45 0c             	lea    0xc(%ebp),%eax
  8009c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8009ca:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cd:	83 ec 08             	sub    $0x8,%esp
  8009d0:	ff 75 f4             	pushl  -0xc(%ebp)
  8009d3:	50                   	push   %eax
  8009d4:	e8 73 ff ff ff       	call   80094c <vcprintf>
  8009d9:	83 c4 10             	add    $0x10,%esp
  8009dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8009df:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8009e2:	c9                   	leave  
  8009e3:	c3                   	ret    

008009e4 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8009e4:	55                   	push   %ebp
  8009e5:	89 e5                	mov    %esp,%ebp
  8009e7:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8009ea:	e8 2b 0f 00 00       	call   80191a <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8009ef:	8d 45 0c             	lea    0xc(%ebp),%eax
  8009f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8009f5:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f8:	83 ec 08             	sub    $0x8,%esp
  8009fb:	ff 75 f4             	pushl  -0xc(%ebp)
  8009fe:	50                   	push   %eax
  8009ff:	e8 48 ff ff ff       	call   80094c <vcprintf>
  800a04:	83 c4 10             	add    $0x10,%esp
  800a07:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  800a0a:	e8 25 0f 00 00       	call   801934 <sys_enable_interrupt>
	return cnt;
  800a0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800a12:	c9                   	leave  
  800a13:	c3                   	ret    

00800a14 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  800a14:	55                   	push   %ebp
  800a15:	89 e5                	mov    %esp,%ebp
  800a17:	53                   	push   %ebx
  800a18:	83 ec 14             	sub    $0x14,%esp
  800a1b:	8b 45 10             	mov    0x10(%ebp),%eax
  800a1e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a21:	8b 45 14             	mov    0x14(%ebp),%eax
  800a24:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  800a27:	8b 45 18             	mov    0x18(%ebp),%eax
  800a2a:	ba 00 00 00 00       	mov    $0x0,%edx
  800a2f:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a32:	77 55                	ja     800a89 <printnum+0x75>
  800a34:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800a37:	72 05                	jb     800a3e <printnum+0x2a>
  800a39:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800a3c:	77 4b                	ja     800a89 <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800a3e:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800a41:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800a44:	8b 45 18             	mov    0x18(%ebp),%eax
  800a47:	ba 00 00 00 00       	mov    $0x0,%edx
  800a4c:	52                   	push   %edx
  800a4d:	50                   	push   %eax
  800a4e:	ff 75 f4             	pushl  -0xc(%ebp)
  800a51:	ff 75 f0             	pushl  -0x10(%ebp)
  800a54:	e8 47 13 00 00       	call   801da0 <__udivdi3>
  800a59:	83 c4 10             	add    $0x10,%esp
  800a5c:	83 ec 04             	sub    $0x4,%esp
  800a5f:	ff 75 20             	pushl  0x20(%ebp)
  800a62:	53                   	push   %ebx
  800a63:	ff 75 18             	pushl  0x18(%ebp)
  800a66:	52                   	push   %edx
  800a67:	50                   	push   %eax
  800a68:	ff 75 0c             	pushl  0xc(%ebp)
  800a6b:	ff 75 08             	pushl  0x8(%ebp)
  800a6e:	e8 a1 ff ff ff       	call   800a14 <printnum>
  800a73:	83 c4 20             	add    $0x20,%esp
  800a76:	eb 1a                	jmp    800a92 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  800a78:	83 ec 08             	sub    $0x8,%esp
  800a7b:	ff 75 0c             	pushl  0xc(%ebp)
  800a7e:	ff 75 20             	pushl  0x20(%ebp)
  800a81:	8b 45 08             	mov    0x8(%ebp),%eax
  800a84:	ff d0                	call   *%eax
  800a86:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  800a89:	ff 4d 1c             	decl   0x1c(%ebp)
  800a8c:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800a90:	7f e6                	jg     800a78 <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800a92:	8b 4d 18             	mov    0x18(%ebp),%ecx
  800a95:	bb 00 00 00 00       	mov    $0x0,%ebx
  800a9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a9d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800aa0:	53                   	push   %ebx
  800aa1:	51                   	push   %ecx
  800aa2:	52                   	push   %edx
  800aa3:	50                   	push   %eax
  800aa4:	e8 07 14 00 00       	call   801eb0 <__umoddi3>
  800aa9:	83 c4 10             	add    $0x10,%esp
  800aac:	05 94 26 80 00       	add    $0x802694,%eax
  800ab1:	8a 00                	mov    (%eax),%al
  800ab3:	0f be c0             	movsbl %al,%eax
  800ab6:	83 ec 08             	sub    $0x8,%esp
  800ab9:	ff 75 0c             	pushl  0xc(%ebp)
  800abc:	50                   	push   %eax
  800abd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ac0:	ff d0                	call   *%eax
  800ac2:	83 c4 10             	add    $0x10,%esp
}
  800ac5:	90                   	nop
  800ac6:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  800ac9:	c9                   	leave  
  800aca:	c3                   	ret    

00800acb <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  800acb:	55                   	push   %ebp
  800acc:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800ace:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800ad2:	7e 1c                	jle    800af0 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  800ad4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ad7:	8b 00                	mov    (%eax),%eax
  800ad9:	8d 50 08             	lea    0x8(%eax),%edx
  800adc:	8b 45 08             	mov    0x8(%ebp),%eax
  800adf:	89 10                	mov    %edx,(%eax)
  800ae1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ae4:	8b 00                	mov    (%eax),%eax
  800ae6:	83 e8 08             	sub    $0x8,%eax
  800ae9:	8b 50 04             	mov    0x4(%eax),%edx
  800aec:	8b 00                	mov    (%eax),%eax
  800aee:	eb 40                	jmp    800b30 <getuint+0x65>
	else if (lflag)
  800af0:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800af4:	74 1e                	je     800b14 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  800af6:	8b 45 08             	mov    0x8(%ebp),%eax
  800af9:	8b 00                	mov    (%eax),%eax
  800afb:	8d 50 04             	lea    0x4(%eax),%edx
  800afe:	8b 45 08             	mov    0x8(%ebp),%eax
  800b01:	89 10                	mov    %edx,(%eax)
  800b03:	8b 45 08             	mov    0x8(%ebp),%eax
  800b06:	8b 00                	mov    (%eax),%eax
  800b08:	83 e8 04             	sub    $0x4,%eax
  800b0b:	8b 00                	mov    (%eax),%eax
  800b0d:	ba 00 00 00 00       	mov    $0x0,%edx
  800b12:	eb 1c                	jmp    800b30 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  800b14:	8b 45 08             	mov    0x8(%ebp),%eax
  800b17:	8b 00                	mov    (%eax),%eax
  800b19:	8d 50 04             	lea    0x4(%eax),%edx
  800b1c:	8b 45 08             	mov    0x8(%ebp),%eax
  800b1f:	89 10                	mov    %edx,(%eax)
  800b21:	8b 45 08             	mov    0x8(%ebp),%eax
  800b24:	8b 00                	mov    (%eax),%eax
  800b26:	83 e8 04             	sub    $0x4,%eax
  800b29:	8b 00                	mov    (%eax),%eax
  800b2b:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800b30:	5d                   	pop    %ebp
  800b31:	c3                   	ret    

00800b32 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800b32:	55                   	push   %ebp
  800b33:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  800b35:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800b39:	7e 1c                	jle    800b57 <getint+0x25>
		return va_arg(*ap, long long);
  800b3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800b3e:	8b 00                	mov    (%eax),%eax
  800b40:	8d 50 08             	lea    0x8(%eax),%edx
  800b43:	8b 45 08             	mov    0x8(%ebp),%eax
  800b46:	89 10                	mov    %edx,(%eax)
  800b48:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4b:	8b 00                	mov    (%eax),%eax
  800b4d:	83 e8 08             	sub    $0x8,%eax
  800b50:	8b 50 04             	mov    0x4(%eax),%edx
  800b53:	8b 00                	mov    (%eax),%eax
  800b55:	eb 38                	jmp    800b8f <getint+0x5d>
	else if (lflag)
  800b57:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800b5b:	74 1a                	je     800b77 <getint+0x45>
		return va_arg(*ap, long);
  800b5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800b60:	8b 00                	mov    (%eax),%eax
  800b62:	8d 50 04             	lea    0x4(%eax),%edx
  800b65:	8b 45 08             	mov    0x8(%ebp),%eax
  800b68:	89 10                	mov    %edx,(%eax)
  800b6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6d:	8b 00                	mov    (%eax),%eax
  800b6f:	83 e8 04             	sub    $0x4,%eax
  800b72:	8b 00                	mov    (%eax),%eax
  800b74:	99                   	cltd   
  800b75:	eb 18                	jmp    800b8f <getint+0x5d>
	else
		return va_arg(*ap, int);
  800b77:	8b 45 08             	mov    0x8(%ebp),%eax
  800b7a:	8b 00                	mov    (%eax),%eax
  800b7c:	8d 50 04             	lea    0x4(%eax),%edx
  800b7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b82:	89 10                	mov    %edx,(%eax)
  800b84:	8b 45 08             	mov    0x8(%ebp),%eax
  800b87:	8b 00                	mov    (%eax),%eax
  800b89:	83 e8 04             	sub    $0x4,%eax
  800b8c:	8b 00                	mov    (%eax),%eax
  800b8e:	99                   	cltd   
}
  800b8f:	5d                   	pop    %ebp
  800b90:	c3                   	ret    

00800b91 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800b91:	55                   	push   %ebp
  800b92:	89 e5                	mov    %esp,%ebp
  800b94:	56                   	push   %esi
  800b95:	53                   	push   %ebx
  800b96:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800b99:	eb 17                	jmp    800bb2 <vprintfmt+0x21>
			if (ch == '\0')
  800b9b:	85 db                	test   %ebx,%ebx
  800b9d:	0f 84 af 03 00 00    	je     800f52 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800ba3:	83 ec 08             	sub    $0x8,%esp
  800ba6:	ff 75 0c             	pushl  0xc(%ebp)
  800ba9:	53                   	push   %ebx
  800baa:	8b 45 08             	mov    0x8(%ebp),%eax
  800bad:	ff d0                	call   *%eax
  800baf:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800bb2:	8b 45 10             	mov    0x10(%ebp),%eax
  800bb5:	8d 50 01             	lea    0x1(%eax),%edx
  800bb8:	89 55 10             	mov    %edx,0x10(%ebp)
  800bbb:	8a 00                	mov    (%eax),%al
  800bbd:	0f b6 d8             	movzbl %al,%ebx
  800bc0:	83 fb 25             	cmp    $0x25,%ebx
  800bc3:	75 d6                	jne    800b9b <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  800bc5:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  800bc9:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  800bd0:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  800bd7:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  800bde:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  800be5:	8b 45 10             	mov    0x10(%ebp),%eax
  800be8:	8d 50 01             	lea    0x1(%eax),%edx
  800beb:	89 55 10             	mov    %edx,0x10(%ebp)
  800bee:	8a 00                	mov    (%eax),%al
  800bf0:	0f b6 d8             	movzbl %al,%ebx
  800bf3:	8d 43 dd             	lea    -0x23(%ebx),%eax
  800bf6:	83 f8 55             	cmp    $0x55,%eax
  800bf9:	0f 87 2b 03 00 00    	ja     800f2a <vprintfmt+0x399>
  800bff:	8b 04 85 b8 26 80 00 	mov    0x8026b8(,%eax,4),%eax
  800c06:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  800c08:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  800c0c:	eb d7                	jmp    800be5 <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  800c0e:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  800c12:	eb d1                	jmp    800be5 <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c14:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800c1b:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800c1e:	89 d0                	mov    %edx,%eax
  800c20:	c1 e0 02             	shl    $0x2,%eax
  800c23:	01 d0                	add    %edx,%eax
  800c25:	01 c0                	add    %eax,%eax
  800c27:	01 d8                	add    %ebx,%eax
  800c29:	83 e8 30             	sub    $0x30,%eax
  800c2c:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800c2f:	8b 45 10             	mov    0x10(%ebp),%eax
  800c32:	8a 00                	mov    (%eax),%al
  800c34:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800c37:	83 fb 2f             	cmp    $0x2f,%ebx
  800c3a:	7e 3e                	jle    800c7a <vprintfmt+0xe9>
  800c3c:	83 fb 39             	cmp    $0x39,%ebx
  800c3f:	7f 39                	jg     800c7a <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800c41:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800c44:	eb d5                	jmp    800c1b <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800c46:	8b 45 14             	mov    0x14(%ebp),%eax
  800c49:	83 c0 04             	add    $0x4,%eax
  800c4c:	89 45 14             	mov    %eax,0x14(%ebp)
  800c4f:	8b 45 14             	mov    0x14(%ebp),%eax
  800c52:	83 e8 04             	sub    $0x4,%eax
  800c55:	8b 00                	mov    (%eax),%eax
  800c57:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800c5a:	eb 1f                	jmp    800c7b <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800c5c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c60:	79 83                	jns    800be5 <vprintfmt+0x54>
				width = 0;
  800c62:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800c69:	e9 77 ff ff ff       	jmp    800be5 <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800c6e:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800c75:	e9 6b ff ff ff       	jmp    800be5 <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800c7a:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800c7b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800c7f:	0f 89 60 ff ff ff    	jns    800be5 <vprintfmt+0x54>
				width = precision, precision = -1;
  800c85:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800c88:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800c8b:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800c92:	e9 4e ff ff ff       	jmp    800be5 <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800c97:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800c9a:	e9 46 ff ff ff       	jmp    800be5 <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800c9f:	8b 45 14             	mov    0x14(%ebp),%eax
  800ca2:	83 c0 04             	add    $0x4,%eax
  800ca5:	89 45 14             	mov    %eax,0x14(%ebp)
  800ca8:	8b 45 14             	mov    0x14(%ebp),%eax
  800cab:	83 e8 04             	sub    $0x4,%eax
  800cae:	8b 00                	mov    (%eax),%eax
  800cb0:	83 ec 08             	sub    $0x8,%esp
  800cb3:	ff 75 0c             	pushl  0xc(%ebp)
  800cb6:	50                   	push   %eax
  800cb7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cba:	ff d0                	call   *%eax
  800cbc:	83 c4 10             	add    $0x10,%esp
			break;
  800cbf:	e9 89 02 00 00       	jmp    800f4d <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800cc4:	8b 45 14             	mov    0x14(%ebp),%eax
  800cc7:	83 c0 04             	add    $0x4,%eax
  800cca:	89 45 14             	mov    %eax,0x14(%ebp)
  800ccd:	8b 45 14             	mov    0x14(%ebp),%eax
  800cd0:	83 e8 04             	sub    $0x4,%eax
  800cd3:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800cd5:	85 db                	test   %ebx,%ebx
  800cd7:	79 02                	jns    800cdb <vprintfmt+0x14a>
				err = -err;
  800cd9:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800cdb:	83 fb 64             	cmp    $0x64,%ebx
  800cde:	7f 0b                	jg     800ceb <vprintfmt+0x15a>
  800ce0:	8b 34 9d 00 25 80 00 	mov    0x802500(,%ebx,4),%esi
  800ce7:	85 f6                	test   %esi,%esi
  800ce9:	75 19                	jne    800d04 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ceb:	53                   	push   %ebx
  800cec:	68 a5 26 80 00       	push   $0x8026a5
  800cf1:	ff 75 0c             	pushl  0xc(%ebp)
  800cf4:	ff 75 08             	pushl  0x8(%ebp)
  800cf7:	e8 5e 02 00 00       	call   800f5a <printfmt>
  800cfc:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800cff:	e9 49 02 00 00       	jmp    800f4d <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800d04:	56                   	push   %esi
  800d05:	68 ae 26 80 00       	push   $0x8026ae
  800d0a:	ff 75 0c             	pushl  0xc(%ebp)
  800d0d:	ff 75 08             	pushl  0x8(%ebp)
  800d10:	e8 45 02 00 00       	call   800f5a <printfmt>
  800d15:	83 c4 10             	add    $0x10,%esp
			break;
  800d18:	e9 30 02 00 00       	jmp    800f4d <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800d1d:	8b 45 14             	mov    0x14(%ebp),%eax
  800d20:	83 c0 04             	add    $0x4,%eax
  800d23:	89 45 14             	mov    %eax,0x14(%ebp)
  800d26:	8b 45 14             	mov    0x14(%ebp),%eax
  800d29:	83 e8 04             	sub    $0x4,%eax
  800d2c:	8b 30                	mov    (%eax),%esi
  800d2e:	85 f6                	test   %esi,%esi
  800d30:	75 05                	jne    800d37 <vprintfmt+0x1a6>
				p = "(null)";
  800d32:	be b1 26 80 00       	mov    $0x8026b1,%esi
			if (width > 0 && padc != '-')
  800d37:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d3b:	7e 6d                	jle    800daa <vprintfmt+0x219>
  800d3d:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800d41:	74 67                	je     800daa <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800d43:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800d46:	83 ec 08             	sub    $0x8,%esp
  800d49:	50                   	push   %eax
  800d4a:	56                   	push   %esi
  800d4b:	e8 0c 03 00 00       	call   80105c <strnlen>
  800d50:	83 c4 10             	add    $0x10,%esp
  800d53:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800d56:	eb 16                	jmp    800d6e <vprintfmt+0x1dd>
					putch(padc, putdat);
  800d58:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800d5c:	83 ec 08             	sub    $0x8,%esp
  800d5f:	ff 75 0c             	pushl  0xc(%ebp)
  800d62:	50                   	push   %eax
  800d63:	8b 45 08             	mov    0x8(%ebp),%eax
  800d66:	ff d0                	call   *%eax
  800d68:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800d6b:	ff 4d e4             	decl   -0x1c(%ebp)
  800d6e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800d72:	7f e4                	jg     800d58 <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800d74:	eb 34                	jmp    800daa <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800d76:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800d7a:	74 1c                	je     800d98 <vprintfmt+0x207>
  800d7c:	83 fb 1f             	cmp    $0x1f,%ebx
  800d7f:	7e 05                	jle    800d86 <vprintfmt+0x1f5>
  800d81:	83 fb 7e             	cmp    $0x7e,%ebx
  800d84:	7e 12                	jle    800d98 <vprintfmt+0x207>
					putch('?', putdat);
  800d86:	83 ec 08             	sub    $0x8,%esp
  800d89:	ff 75 0c             	pushl  0xc(%ebp)
  800d8c:	6a 3f                	push   $0x3f
  800d8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d91:	ff d0                	call   *%eax
  800d93:	83 c4 10             	add    $0x10,%esp
  800d96:	eb 0f                	jmp    800da7 <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800d98:	83 ec 08             	sub    $0x8,%esp
  800d9b:	ff 75 0c             	pushl  0xc(%ebp)
  800d9e:	53                   	push   %ebx
  800d9f:	8b 45 08             	mov    0x8(%ebp),%eax
  800da2:	ff d0                	call   *%eax
  800da4:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800da7:	ff 4d e4             	decl   -0x1c(%ebp)
  800daa:	89 f0                	mov    %esi,%eax
  800dac:	8d 70 01             	lea    0x1(%eax),%esi
  800daf:	8a 00                	mov    (%eax),%al
  800db1:	0f be d8             	movsbl %al,%ebx
  800db4:	85 db                	test   %ebx,%ebx
  800db6:	74 24                	je     800ddc <vprintfmt+0x24b>
  800db8:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800dbc:	78 b8                	js     800d76 <vprintfmt+0x1e5>
  800dbe:	ff 4d e0             	decl   -0x20(%ebp)
  800dc1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800dc5:	79 af                	jns    800d76 <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800dc7:	eb 13                	jmp    800ddc <vprintfmt+0x24b>
				putch(' ', putdat);
  800dc9:	83 ec 08             	sub    $0x8,%esp
  800dcc:	ff 75 0c             	pushl  0xc(%ebp)
  800dcf:	6a 20                	push   $0x20
  800dd1:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd4:	ff d0                	call   *%eax
  800dd6:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800dd9:	ff 4d e4             	decl   -0x1c(%ebp)
  800ddc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800de0:	7f e7                	jg     800dc9 <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800de2:	e9 66 01 00 00       	jmp    800f4d <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800de7:	83 ec 08             	sub    $0x8,%esp
  800dea:	ff 75 e8             	pushl  -0x18(%ebp)
  800ded:	8d 45 14             	lea    0x14(%ebp),%eax
  800df0:	50                   	push   %eax
  800df1:	e8 3c fd ff ff       	call   800b32 <getint>
  800df6:	83 c4 10             	add    $0x10,%esp
  800df9:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800dfc:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800dff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e02:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e05:	85 d2                	test   %edx,%edx
  800e07:	79 23                	jns    800e2c <vprintfmt+0x29b>
				putch('-', putdat);
  800e09:	83 ec 08             	sub    $0x8,%esp
  800e0c:	ff 75 0c             	pushl  0xc(%ebp)
  800e0f:	6a 2d                	push   $0x2d
  800e11:	8b 45 08             	mov    0x8(%ebp),%eax
  800e14:	ff d0                	call   *%eax
  800e16:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800e19:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800e1c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800e1f:	f7 d8                	neg    %eax
  800e21:	83 d2 00             	adc    $0x0,%edx
  800e24:	f7 da                	neg    %edx
  800e26:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e29:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800e2c:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e33:	e9 bc 00 00 00       	jmp    800ef4 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800e38:	83 ec 08             	sub    $0x8,%esp
  800e3b:	ff 75 e8             	pushl  -0x18(%ebp)
  800e3e:	8d 45 14             	lea    0x14(%ebp),%eax
  800e41:	50                   	push   %eax
  800e42:	e8 84 fc ff ff       	call   800acb <getuint>
  800e47:	83 c4 10             	add    $0x10,%esp
  800e4a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800e4d:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800e50:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800e57:	e9 98 00 00 00       	jmp    800ef4 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800e5c:	83 ec 08             	sub    $0x8,%esp
  800e5f:	ff 75 0c             	pushl  0xc(%ebp)
  800e62:	6a 58                	push   $0x58
  800e64:	8b 45 08             	mov    0x8(%ebp),%eax
  800e67:	ff d0                	call   *%eax
  800e69:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e6c:	83 ec 08             	sub    $0x8,%esp
  800e6f:	ff 75 0c             	pushl  0xc(%ebp)
  800e72:	6a 58                	push   $0x58
  800e74:	8b 45 08             	mov    0x8(%ebp),%eax
  800e77:	ff d0                	call   *%eax
  800e79:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800e7c:	83 ec 08             	sub    $0x8,%esp
  800e7f:	ff 75 0c             	pushl  0xc(%ebp)
  800e82:	6a 58                	push   $0x58
  800e84:	8b 45 08             	mov    0x8(%ebp),%eax
  800e87:	ff d0                	call   *%eax
  800e89:	83 c4 10             	add    $0x10,%esp
			break;
  800e8c:	e9 bc 00 00 00       	jmp    800f4d <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800e91:	83 ec 08             	sub    $0x8,%esp
  800e94:	ff 75 0c             	pushl  0xc(%ebp)
  800e97:	6a 30                	push   $0x30
  800e99:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9c:	ff d0                	call   *%eax
  800e9e:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800ea1:	83 ec 08             	sub    $0x8,%esp
  800ea4:	ff 75 0c             	pushl  0xc(%ebp)
  800ea7:	6a 78                	push   $0x78
  800ea9:	8b 45 08             	mov    0x8(%ebp),%eax
  800eac:	ff d0                	call   *%eax
  800eae:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800eb1:	8b 45 14             	mov    0x14(%ebp),%eax
  800eb4:	83 c0 04             	add    $0x4,%eax
  800eb7:	89 45 14             	mov    %eax,0x14(%ebp)
  800eba:	8b 45 14             	mov    0x14(%ebp),%eax
  800ebd:	83 e8 04             	sub    $0x4,%eax
  800ec0:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ec2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ec5:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800ecc:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800ed3:	eb 1f                	jmp    800ef4 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800ed5:	83 ec 08             	sub    $0x8,%esp
  800ed8:	ff 75 e8             	pushl  -0x18(%ebp)
  800edb:	8d 45 14             	lea    0x14(%ebp),%eax
  800ede:	50                   	push   %eax
  800edf:	e8 e7 fb ff ff       	call   800acb <getuint>
  800ee4:	83 c4 10             	add    $0x10,%esp
  800ee7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800eea:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800eed:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800ef4:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800ef8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800efb:	83 ec 04             	sub    $0x4,%esp
  800efe:	52                   	push   %edx
  800eff:	ff 75 e4             	pushl  -0x1c(%ebp)
  800f02:	50                   	push   %eax
  800f03:	ff 75 f4             	pushl  -0xc(%ebp)
  800f06:	ff 75 f0             	pushl  -0x10(%ebp)
  800f09:	ff 75 0c             	pushl  0xc(%ebp)
  800f0c:	ff 75 08             	pushl  0x8(%ebp)
  800f0f:	e8 00 fb ff ff       	call   800a14 <printnum>
  800f14:	83 c4 20             	add    $0x20,%esp
			break;
  800f17:	eb 34                	jmp    800f4d <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800f19:	83 ec 08             	sub    $0x8,%esp
  800f1c:	ff 75 0c             	pushl  0xc(%ebp)
  800f1f:	53                   	push   %ebx
  800f20:	8b 45 08             	mov    0x8(%ebp),%eax
  800f23:	ff d0                	call   *%eax
  800f25:	83 c4 10             	add    $0x10,%esp
			break;
  800f28:	eb 23                	jmp    800f4d <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800f2a:	83 ec 08             	sub    $0x8,%esp
  800f2d:	ff 75 0c             	pushl  0xc(%ebp)
  800f30:	6a 25                	push   $0x25
  800f32:	8b 45 08             	mov    0x8(%ebp),%eax
  800f35:	ff d0                	call   *%eax
  800f37:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800f3a:	ff 4d 10             	decl   0x10(%ebp)
  800f3d:	eb 03                	jmp    800f42 <vprintfmt+0x3b1>
  800f3f:	ff 4d 10             	decl   0x10(%ebp)
  800f42:	8b 45 10             	mov    0x10(%ebp),%eax
  800f45:	48                   	dec    %eax
  800f46:	8a 00                	mov    (%eax),%al
  800f48:	3c 25                	cmp    $0x25,%al
  800f4a:	75 f3                	jne    800f3f <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800f4c:	90                   	nop
		}
	}
  800f4d:	e9 47 fc ff ff       	jmp    800b99 <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800f52:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800f53:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800f56:	5b                   	pop    %ebx
  800f57:	5e                   	pop    %esi
  800f58:	5d                   	pop    %ebp
  800f59:	c3                   	ret    

00800f5a <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800f5a:	55                   	push   %ebp
  800f5b:	89 e5                	mov    %esp,%ebp
  800f5d:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800f60:	8d 45 10             	lea    0x10(%ebp),%eax
  800f63:	83 c0 04             	add    $0x4,%eax
  800f66:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800f69:	8b 45 10             	mov    0x10(%ebp),%eax
  800f6c:	ff 75 f4             	pushl  -0xc(%ebp)
  800f6f:	50                   	push   %eax
  800f70:	ff 75 0c             	pushl  0xc(%ebp)
  800f73:	ff 75 08             	pushl  0x8(%ebp)
  800f76:	e8 16 fc ff ff       	call   800b91 <vprintfmt>
  800f7b:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800f7e:	90                   	nop
  800f7f:	c9                   	leave  
  800f80:	c3                   	ret    

00800f81 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800f81:	55                   	push   %ebp
  800f82:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800f84:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f87:	8b 40 08             	mov    0x8(%eax),%eax
  800f8a:	8d 50 01             	lea    0x1(%eax),%edx
  800f8d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f90:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800f93:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f96:	8b 10                	mov    (%eax),%edx
  800f98:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f9b:	8b 40 04             	mov    0x4(%eax),%eax
  800f9e:	39 c2                	cmp    %eax,%edx
  800fa0:	73 12                	jae    800fb4 <sprintputch+0x33>
		*b->buf++ = ch;
  800fa2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa5:	8b 00                	mov    (%eax),%eax
  800fa7:	8d 48 01             	lea    0x1(%eax),%ecx
  800faa:	8b 55 0c             	mov    0xc(%ebp),%edx
  800fad:	89 0a                	mov    %ecx,(%edx)
  800faf:	8b 55 08             	mov    0x8(%ebp),%edx
  800fb2:	88 10                	mov    %dl,(%eax)
}
  800fb4:	90                   	nop
  800fb5:	5d                   	pop    %ebp
  800fb6:	c3                   	ret    

00800fb7 <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800fb7:	55                   	push   %ebp
  800fb8:	89 e5                	mov    %esp,%ebp
  800fba:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800fbd:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc0:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800fc3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fc6:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fc9:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcc:	01 d0                	add    %edx,%eax
  800fce:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fd1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800fd8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800fdc:	74 06                	je     800fe4 <vsnprintf+0x2d>
  800fde:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800fe2:	7f 07                	jg     800feb <vsnprintf+0x34>
		return -E_INVAL;
  800fe4:	b8 03 00 00 00       	mov    $0x3,%eax
  800fe9:	eb 20                	jmp    80100b <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800feb:	ff 75 14             	pushl  0x14(%ebp)
  800fee:	ff 75 10             	pushl  0x10(%ebp)
  800ff1:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ff4:	50                   	push   %eax
  800ff5:	68 81 0f 80 00       	push   $0x800f81
  800ffa:	e8 92 fb ff ff       	call   800b91 <vprintfmt>
  800fff:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  801002:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801005:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  801008:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80100b:	c9                   	leave  
  80100c:	c3                   	ret    

0080100d <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  80100d:	55                   	push   %ebp
  80100e:	89 e5                	mov    %esp,%ebp
  801010:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  801013:	8d 45 10             	lea    0x10(%ebp),%eax
  801016:	83 c0 04             	add    $0x4,%eax
  801019:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  80101c:	8b 45 10             	mov    0x10(%ebp),%eax
  80101f:	ff 75 f4             	pushl  -0xc(%ebp)
  801022:	50                   	push   %eax
  801023:	ff 75 0c             	pushl  0xc(%ebp)
  801026:	ff 75 08             	pushl  0x8(%ebp)
  801029:	e8 89 ff ff ff       	call   800fb7 <vsnprintf>
  80102e:	83 c4 10             	add    $0x10,%esp
  801031:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  801034:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801037:	c9                   	leave  
  801038:	c3                   	ret    

00801039 <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  801039:	55                   	push   %ebp
  80103a:	89 e5                	mov    %esp,%ebp
  80103c:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  80103f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801046:	eb 06                	jmp    80104e <strlen+0x15>
		n++;
  801048:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  80104b:	ff 45 08             	incl   0x8(%ebp)
  80104e:	8b 45 08             	mov    0x8(%ebp),%eax
  801051:	8a 00                	mov    (%eax),%al
  801053:	84 c0                	test   %al,%al
  801055:	75 f1                	jne    801048 <strlen+0xf>
		n++;
	return n;
  801057:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  80105a:	c9                   	leave  
  80105b:	c3                   	ret    

0080105c <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  80105c:	55                   	push   %ebp
  80105d:	89 e5                	mov    %esp,%ebp
  80105f:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  801062:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801069:	eb 09                	jmp    801074 <strnlen+0x18>
		n++;
  80106b:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  80106e:	ff 45 08             	incl   0x8(%ebp)
  801071:	ff 4d 0c             	decl   0xc(%ebp)
  801074:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  801078:	74 09                	je     801083 <strnlen+0x27>
  80107a:	8b 45 08             	mov    0x8(%ebp),%eax
  80107d:	8a 00                	mov    (%eax),%al
  80107f:	84 c0                	test   %al,%al
  801081:	75 e8                	jne    80106b <strnlen+0xf>
		n++;
	return n;
  801083:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801086:	c9                   	leave  
  801087:	c3                   	ret    

00801088 <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  801088:	55                   	push   %ebp
  801089:	89 e5                	mov    %esp,%ebp
  80108b:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  80108e:	8b 45 08             	mov    0x8(%ebp),%eax
  801091:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  801094:	90                   	nop
  801095:	8b 45 08             	mov    0x8(%ebp),%eax
  801098:	8d 50 01             	lea    0x1(%eax),%edx
  80109b:	89 55 08             	mov    %edx,0x8(%ebp)
  80109e:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010a1:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010a4:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  8010a7:	8a 12                	mov    (%edx),%dl
  8010a9:	88 10                	mov    %dl,(%eax)
  8010ab:	8a 00                	mov    (%eax),%al
  8010ad:	84 c0                	test   %al,%al
  8010af:	75 e4                	jne    801095 <strcpy+0xd>
		/* do nothing */;
	return ret;
  8010b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8010b4:	c9                   	leave  
  8010b5:	c3                   	ret    

008010b6 <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  8010b6:	55                   	push   %ebp
  8010b7:	89 e5                	mov    %esp,%ebp
  8010b9:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  8010bc:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bf:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  8010c2:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8010c9:	eb 1f                	jmp    8010ea <strncpy+0x34>
		*dst++ = *src;
  8010cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ce:	8d 50 01             	lea    0x1(%eax),%edx
  8010d1:	89 55 08             	mov    %edx,0x8(%ebp)
  8010d4:	8b 55 0c             	mov    0xc(%ebp),%edx
  8010d7:	8a 12                	mov    (%edx),%dl
  8010d9:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  8010db:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010de:	8a 00                	mov    (%eax),%al
  8010e0:	84 c0                	test   %al,%al
  8010e2:	74 03                	je     8010e7 <strncpy+0x31>
			src++;
  8010e4:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  8010e7:	ff 45 fc             	incl   -0x4(%ebp)
  8010ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010ed:	3b 45 10             	cmp    0x10(%ebp),%eax
  8010f0:	72 d9                	jb     8010cb <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  8010f2:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8010f5:	c9                   	leave  
  8010f6:	c3                   	ret    

008010f7 <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  8010f7:	55                   	push   %ebp
  8010f8:	89 e5                	mov    %esp,%ebp
  8010fa:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  8010fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801100:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  801103:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801107:	74 30                	je     801139 <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  801109:	eb 16                	jmp    801121 <strlcpy+0x2a>
			*dst++ = *src++;
  80110b:	8b 45 08             	mov    0x8(%ebp),%eax
  80110e:	8d 50 01             	lea    0x1(%eax),%edx
  801111:	89 55 08             	mov    %edx,0x8(%ebp)
  801114:	8b 55 0c             	mov    0xc(%ebp),%edx
  801117:	8d 4a 01             	lea    0x1(%edx),%ecx
  80111a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  80111d:	8a 12                	mov    (%edx),%dl
  80111f:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  801121:	ff 4d 10             	decl   0x10(%ebp)
  801124:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801128:	74 09                	je     801133 <strlcpy+0x3c>
  80112a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80112d:	8a 00                	mov    (%eax),%al
  80112f:	84 c0                	test   %al,%al
  801131:	75 d8                	jne    80110b <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  801133:	8b 45 08             	mov    0x8(%ebp),%eax
  801136:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  801139:	8b 55 08             	mov    0x8(%ebp),%edx
  80113c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80113f:	29 c2                	sub    %eax,%edx
  801141:	89 d0                	mov    %edx,%eax
}
  801143:	c9                   	leave  
  801144:	c3                   	ret    

00801145 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  801145:	55                   	push   %ebp
  801146:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  801148:	eb 06                	jmp    801150 <strcmp+0xb>
		p++, q++;
  80114a:	ff 45 08             	incl   0x8(%ebp)
  80114d:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  801150:	8b 45 08             	mov    0x8(%ebp),%eax
  801153:	8a 00                	mov    (%eax),%al
  801155:	84 c0                	test   %al,%al
  801157:	74 0e                	je     801167 <strcmp+0x22>
  801159:	8b 45 08             	mov    0x8(%ebp),%eax
  80115c:	8a 10                	mov    (%eax),%dl
  80115e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801161:	8a 00                	mov    (%eax),%al
  801163:	38 c2                	cmp    %al,%dl
  801165:	74 e3                	je     80114a <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  801167:	8b 45 08             	mov    0x8(%ebp),%eax
  80116a:	8a 00                	mov    (%eax),%al
  80116c:	0f b6 d0             	movzbl %al,%edx
  80116f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801172:	8a 00                	mov    (%eax),%al
  801174:	0f b6 c0             	movzbl %al,%eax
  801177:	29 c2                	sub    %eax,%edx
  801179:	89 d0                	mov    %edx,%eax
}
  80117b:	5d                   	pop    %ebp
  80117c:	c3                   	ret    

0080117d <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  80117d:	55                   	push   %ebp
  80117e:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  801180:	eb 09                	jmp    80118b <strncmp+0xe>
		n--, p++, q++;
  801182:	ff 4d 10             	decl   0x10(%ebp)
  801185:	ff 45 08             	incl   0x8(%ebp)
  801188:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  80118b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80118f:	74 17                	je     8011a8 <strncmp+0x2b>
  801191:	8b 45 08             	mov    0x8(%ebp),%eax
  801194:	8a 00                	mov    (%eax),%al
  801196:	84 c0                	test   %al,%al
  801198:	74 0e                	je     8011a8 <strncmp+0x2b>
  80119a:	8b 45 08             	mov    0x8(%ebp),%eax
  80119d:	8a 10                	mov    (%eax),%dl
  80119f:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011a2:	8a 00                	mov    (%eax),%al
  8011a4:	38 c2                	cmp    %al,%dl
  8011a6:	74 da                	je     801182 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  8011a8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011ac:	75 07                	jne    8011b5 <strncmp+0x38>
		return 0;
  8011ae:	b8 00 00 00 00       	mov    $0x0,%eax
  8011b3:	eb 14                	jmp    8011c9 <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  8011b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8011b8:	8a 00                	mov    (%eax),%al
  8011ba:	0f b6 d0             	movzbl %al,%edx
  8011bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c0:	8a 00                	mov    (%eax),%al
  8011c2:	0f b6 c0             	movzbl %al,%eax
  8011c5:	29 c2                	sub    %eax,%edx
  8011c7:	89 d0                	mov    %edx,%eax
}
  8011c9:	5d                   	pop    %ebp
  8011ca:	c3                   	ret    

008011cb <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  8011cb:	55                   	push   %ebp
  8011cc:	89 e5                	mov    %esp,%ebp
  8011ce:	83 ec 04             	sub    $0x4,%esp
  8011d1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d4:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  8011d7:	eb 12                	jmp    8011eb <strchr+0x20>
		if (*s == c)
  8011d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011dc:	8a 00                	mov    (%eax),%al
  8011de:	3a 45 fc             	cmp    -0x4(%ebp),%al
  8011e1:	75 05                	jne    8011e8 <strchr+0x1d>
			return (char *) s;
  8011e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e6:	eb 11                	jmp    8011f9 <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  8011e8:	ff 45 08             	incl   0x8(%ebp)
  8011eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ee:	8a 00                	mov    (%eax),%al
  8011f0:	84 c0                	test   %al,%al
  8011f2:	75 e5                	jne    8011d9 <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  8011f4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011f9:	c9                   	leave  
  8011fa:	c3                   	ret    

008011fb <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  8011fb:	55                   	push   %ebp
  8011fc:	89 e5                	mov    %esp,%ebp
  8011fe:	83 ec 04             	sub    $0x4,%esp
  801201:	8b 45 0c             	mov    0xc(%ebp),%eax
  801204:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  801207:	eb 0d                	jmp    801216 <strfind+0x1b>
		if (*s == c)
  801209:	8b 45 08             	mov    0x8(%ebp),%eax
  80120c:	8a 00                	mov    (%eax),%al
  80120e:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801211:	74 0e                	je     801221 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  801213:	ff 45 08             	incl   0x8(%ebp)
  801216:	8b 45 08             	mov    0x8(%ebp),%eax
  801219:	8a 00                	mov    (%eax),%al
  80121b:	84 c0                	test   %al,%al
  80121d:	75 ea                	jne    801209 <strfind+0xe>
  80121f:	eb 01                	jmp    801222 <strfind+0x27>
		if (*s == c)
			break;
  801221:	90                   	nop
	return (char *) s;
  801222:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801225:	c9                   	leave  
  801226:	c3                   	ret    

00801227 <memset>:


void *
memset(void *v, int c, uint32 n)
{
  801227:	55                   	push   %ebp
  801228:	89 e5                	mov    %esp,%ebp
  80122a:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  80122d:	8b 45 08             	mov    0x8(%ebp),%eax
  801230:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801233:	8b 45 10             	mov    0x10(%ebp),%eax
  801236:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  801239:	eb 0e                	jmp    801249 <memset+0x22>
		*p++ = c;
  80123b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80123e:	8d 50 01             	lea    0x1(%eax),%edx
  801241:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801244:	8b 55 0c             	mov    0xc(%ebp),%edx
  801247:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  801249:	ff 4d f8             	decl   -0x8(%ebp)
  80124c:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801250:	79 e9                	jns    80123b <memset+0x14>
		*p++ = c;

	return v;
  801252:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801255:	c9                   	leave  
  801256:	c3                   	ret    

00801257 <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  801257:	55                   	push   %ebp
  801258:	89 e5                	mov    %esp,%ebp
  80125a:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80125d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801260:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801263:	8b 45 08             	mov    0x8(%ebp),%eax
  801266:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  801269:	eb 16                	jmp    801281 <memcpy+0x2a>
		*d++ = *s++;
  80126b:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80126e:	8d 50 01             	lea    0x1(%eax),%edx
  801271:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801274:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801277:	8d 4a 01             	lea    0x1(%edx),%ecx
  80127a:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  80127d:	8a 12                	mov    (%edx),%dl
  80127f:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801281:	8b 45 10             	mov    0x10(%ebp),%eax
  801284:	8d 50 ff             	lea    -0x1(%eax),%edx
  801287:	89 55 10             	mov    %edx,0x10(%ebp)
  80128a:	85 c0                	test   %eax,%eax
  80128c:	75 dd                	jne    80126b <memcpy+0x14>
		*d++ = *s++;

	return dst;
  80128e:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801291:	c9                   	leave  
  801292:	c3                   	ret    

00801293 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801293:	55                   	push   %ebp
  801294:	89 e5                	mov    %esp,%ebp
  801296:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801299:	8b 45 0c             	mov    0xc(%ebp),%eax
  80129c:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  80129f:	8b 45 08             	mov    0x8(%ebp),%eax
  8012a2:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  8012a5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012a8:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8012ab:	73 50                	jae    8012fd <memmove+0x6a>
  8012ad:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012b0:	8b 45 10             	mov    0x10(%ebp),%eax
  8012b3:	01 d0                	add    %edx,%eax
  8012b5:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  8012b8:	76 43                	jbe    8012fd <memmove+0x6a>
		s += n;
  8012ba:	8b 45 10             	mov    0x10(%ebp),%eax
  8012bd:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8012c0:	8b 45 10             	mov    0x10(%ebp),%eax
  8012c3:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8012c6:	eb 10                	jmp    8012d8 <memmove+0x45>
			*--d = *--s;
  8012c8:	ff 4d f8             	decl   -0x8(%ebp)
  8012cb:	ff 4d fc             	decl   -0x4(%ebp)
  8012ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8012d1:	8a 10                	mov    (%eax),%dl
  8012d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012d6:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8012d8:	8b 45 10             	mov    0x10(%ebp),%eax
  8012db:	8d 50 ff             	lea    -0x1(%eax),%edx
  8012de:	89 55 10             	mov    %edx,0x10(%ebp)
  8012e1:	85 c0                	test   %eax,%eax
  8012e3:	75 e3                	jne    8012c8 <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8012e5:	eb 23                	jmp    80130a <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8012e7:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012ea:	8d 50 01             	lea    0x1(%eax),%edx
  8012ed:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8012f0:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012f3:	8d 4a 01             	lea    0x1(%edx),%ecx
  8012f6:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8012f9:	8a 12                	mov    (%edx),%dl
  8012fb:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8012fd:	8b 45 10             	mov    0x10(%ebp),%eax
  801300:	8d 50 ff             	lea    -0x1(%eax),%edx
  801303:	89 55 10             	mov    %edx,0x10(%ebp)
  801306:	85 c0                	test   %eax,%eax
  801308:	75 dd                	jne    8012e7 <memmove+0x54>
			*d++ = *s++;

	return dst;
  80130a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80130d:	c9                   	leave  
  80130e:	c3                   	ret    

0080130f <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  80130f:	55                   	push   %ebp
  801310:	89 e5                	mov    %esp,%ebp
  801312:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  801315:	8b 45 08             	mov    0x8(%ebp),%eax
  801318:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  80131b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80131e:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801321:	eb 2a                	jmp    80134d <memcmp+0x3e>
		if (*s1 != *s2)
  801323:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801326:	8a 10                	mov    (%eax),%dl
  801328:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80132b:	8a 00                	mov    (%eax),%al
  80132d:	38 c2                	cmp    %al,%dl
  80132f:	74 16                	je     801347 <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801331:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801334:	8a 00                	mov    (%eax),%al
  801336:	0f b6 d0             	movzbl %al,%edx
  801339:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80133c:	8a 00                	mov    (%eax),%al
  80133e:	0f b6 c0             	movzbl %al,%eax
  801341:	29 c2                	sub    %eax,%edx
  801343:	89 d0                	mov    %edx,%eax
  801345:	eb 18                	jmp    80135f <memcmp+0x50>
		s1++, s2++;
  801347:	ff 45 fc             	incl   -0x4(%ebp)
  80134a:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  80134d:	8b 45 10             	mov    0x10(%ebp),%eax
  801350:	8d 50 ff             	lea    -0x1(%eax),%edx
  801353:	89 55 10             	mov    %edx,0x10(%ebp)
  801356:	85 c0                	test   %eax,%eax
  801358:	75 c9                	jne    801323 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80135a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80135f:	c9                   	leave  
  801360:	c3                   	ret    

00801361 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801361:	55                   	push   %ebp
  801362:	89 e5                	mov    %esp,%ebp
  801364:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  801367:	8b 55 08             	mov    0x8(%ebp),%edx
  80136a:	8b 45 10             	mov    0x10(%ebp),%eax
  80136d:	01 d0                	add    %edx,%eax
  80136f:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801372:	eb 15                	jmp    801389 <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801374:	8b 45 08             	mov    0x8(%ebp),%eax
  801377:	8a 00                	mov    (%eax),%al
  801379:	0f b6 d0             	movzbl %al,%edx
  80137c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80137f:	0f b6 c0             	movzbl %al,%eax
  801382:	39 c2                	cmp    %eax,%edx
  801384:	74 0d                	je     801393 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  801386:	ff 45 08             	incl   0x8(%ebp)
  801389:	8b 45 08             	mov    0x8(%ebp),%eax
  80138c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  80138f:	72 e3                	jb     801374 <memfind+0x13>
  801391:	eb 01                	jmp    801394 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801393:	90                   	nop
	return (void *) s;
  801394:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801397:	c9                   	leave  
  801398:	c3                   	ret    

00801399 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  801399:	55                   	push   %ebp
  80139a:	89 e5                	mov    %esp,%ebp
  80139c:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  80139f:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  8013a6:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8013ad:	eb 03                	jmp    8013b2 <strtol+0x19>
		s++;
  8013af:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  8013b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013b5:	8a 00                	mov    (%eax),%al
  8013b7:	3c 20                	cmp    $0x20,%al
  8013b9:	74 f4                	je     8013af <strtol+0x16>
  8013bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8013be:	8a 00                	mov    (%eax),%al
  8013c0:	3c 09                	cmp    $0x9,%al
  8013c2:	74 eb                	je     8013af <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8013c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8013c7:	8a 00                	mov    (%eax),%al
  8013c9:	3c 2b                	cmp    $0x2b,%al
  8013cb:	75 05                	jne    8013d2 <strtol+0x39>
		s++;
  8013cd:	ff 45 08             	incl   0x8(%ebp)
  8013d0:	eb 13                	jmp    8013e5 <strtol+0x4c>
	else if (*s == '-')
  8013d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013d5:	8a 00                	mov    (%eax),%al
  8013d7:	3c 2d                	cmp    $0x2d,%al
  8013d9:	75 0a                	jne    8013e5 <strtol+0x4c>
		s++, neg = 1;
  8013db:	ff 45 08             	incl   0x8(%ebp)
  8013de:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8013e5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8013e9:	74 06                	je     8013f1 <strtol+0x58>
  8013eb:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8013ef:	75 20                	jne    801411 <strtol+0x78>
  8013f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8013f4:	8a 00                	mov    (%eax),%al
  8013f6:	3c 30                	cmp    $0x30,%al
  8013f8:	75 17                	jne    801411 <strtol+0x78>
  8013fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fd:	40                   	inc    %eax
  8013fe:	8a 00                	mov    (%eax),%al
  801400:	3c 78                	cmp    $0x78,%al
  801402:	75 0d                	jne    801411 <strtol+0x78>
		s += 2, base = 16;
  801404:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801408:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80140f:	eb 28                	jmp    801439 <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  801411:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801415:	75 15                	jne    80142c <strtol+0x93>
  801417:	8b 45 08             	mov    0x8(%ebp),%eax
  80141a:	8a 00                	mov    (%eax),%al
  80141c:	3c 30                	cmp    $0x30,%al
  80141e:	75 0c                	jne    80142c <strtol+0x93>
		s++, base = 8;
  801420:	ff 45 08             	incl   0x8(%ebp)
  801423:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80142a:	eb 0d                	jmp    801439 <strtol+0xa0>
	else if (base == 0)
  80142c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801430:	75 07                	jne    801439 <strtol+0xa0>
		base = 10;
  801432:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  801439:	8b 45 08             	mov    0x8(%ebp),%eax
  80143c:	8a 00                	mov    (%eax),%al
  80143e:	3c 2f                	cmp    $0x2f,%al
  801440:	7e 19                	jle    80145b <strtol+0xc2>
  801442:	8b 45 08             	mov    0x8(%ebp),%eax
  801445:	8a 00                	mov    (%eax),%al
  801447:	3c 39                	cmp    $0x39,%al
  801449:	7f 10                	jg     80145b <strtol+0xc2>
			dig = *s - '0';
  80144b:	8b 45 08             	mov    0x8(%ebp),%eax
  80144e:	8a 00                	mov    (%eax),%al
  801450:	0f be c0             	movsbl %al,%eax
  801453:	83 e8 30             	sub    $0x30,%eax
  801456:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801459:	eb 42                	jmp    80149d <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  80145b:	8b 45 08             	mov    0x8(%ebp),%eax
  80145e:	8a 00                	mov    (%eax),%al
  801460:	3c 60                	cmp    $0x60,%al
  801462:	7e 19                	jle    80147d <strtol+0xe4>
  801464:	8b 45 08             	mov    0x8(%ebp),%eax
  801467:	8a 00                	mov    (%eax),%al
  801469:	3c 7a                	cmp    $0x7a,%al
  80146b:	7f 10                	jg     80147d <strtol+0xe4>
			dig = *s - 'a' + 10;
  80146d:	8b 45 08             	mov    0x8(%ebp),%eax
  801470:	8a 00                	mov    (%eax),%al
  801472:	0f be c0             	movsbl %al,%eax
  801475:	83 e8 57             	sub    $0x57,%eax
  801478:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80147b:	eb 20                	jmp    80149d <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  80147d:	8b 45 08             	mov    0x8(%ebp),%eax
  801480:	8a 00                	mov    (%eax),%al
  801482:	3c 40                	cmp    $0x40,%al
  801484:	7e 39                	jle    8014bf <strtol+0x126>
  801486:	8b 45 08             	mov    0x8(%ebp),%eax
  801489:	8a 00                	mov    (%eax),%al
  80148b:	3c 5a                	cmp    $0x5a,%al
  80148d:	7f 30                	jg     8014bf <strtol+0x126>
			dig = *s - 'A' + 10;
  80148f:	8b 45 08             	mov    0x8(%ebp),%eax
  801492:	8a 00                	mov    (%eax),%al
  801494:	0f be c0             	movsbl %al,%eax
  801497:	83 e8 37             	sub    $0x37,%eax
  80149a:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  80149d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014a0:	3b 45 10             	cmp    0x10(%ebp),%eax
  8014a3:	7d 19                	jge    8014be <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  8014a5:	ff 45 08             	incl   0x8(%ebp)
  8014a8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014ab:	0f af 45 10          	imul   0x10(%ebp),%eax
  8014af:	89 c2                	mov    %eax,%edx
  8014b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8014b4:	01 d0                	add    %edx,%eax
  8014b6:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  8014b9:	e9 7b ff ff ff       	jmp    801439 <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8014be:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8014bf:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8014c3:	74 08                	je     8014cd <strtol+0x134>
		*endptr = (char *) s;
  8014c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014c8:	8b 55 08             	mov    0x8(%ebp),%edx
  8014cb:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8014cd:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8014d1:	74 07                	je     8014da <strtol+0x141>
  8014d3:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8014d6:	f7 d8                	neg    %eax
  8014d8:	eb 03                	jmp    8014dd <strtol+0x144>
  8014da:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8014dd:	c9                   	leave  
  8014de:	c3                   	ret    

008014df <ltostr>:

void
ltostr(long value, char *str)
{
  8014df:	55                   	push   %ebp
  8014e0:	89 e5                	mov    %esp,%ebp
  8014e2:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8014e5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8014ec:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8014f3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8014f7:	79 13                	jns    80150c <ltostr+0x2d>
	{
		neg = 1;
  8014f9:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  801500:	8b 45 0c             	mov    0xc(%ebp),%eax
  801503:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  801506:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  801509:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  80150c:	8b 45 08             	mov    0x8(%ebp),%eax
  80150f:	b9 0a 00 00 00       	mov    $0xa,%ecx
  801514:	99                   	cltd   
  801515:	f7 f9                	idiv   %ecx
  801517:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  80151a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80151d:	8d 50 01             	lea    0x1(%eax),%edx
  801520:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801523:	89 c2                	mov    %eax,%edx
  801525:	8b 45 0c             	mov    0xc(%ebp),%eax
  801528:	01 d0                	add    %edx,%eax
  80152a:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80152d:	83 c2 30             	add    $0x30,%edx
  801530:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801532:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801535:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80153a:	f7 e9                	imul   %ecx
  80153c:	c1 fa 02             	sar    $0x2,%edx
  80153f:	89 c8                	mov    %ecx,%eax
  801541:	c1 f8 1f             	sar    $0x1f,%eax
  801544:	29 c2                	sub    %eax,%edx
  801546:	89 d0                	mov    %edx,%eax
  801548:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  80154b:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80154e:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801553:	f7 e9                	imul   %ecx
  801555:	c1 fa 02             	sar    $0x2,%edx
  801558:	89 c8                	mov    %ecx,%eax
  80155a:	c1 f8 1f             	sar    $0x1f,%eax
  80155d:	29 c2                	sub    %eax,%edx
  80155f:	89 d0                	mov    %edx,%eax
  801561:	c1 e0 02             	shl    $0x2,%eax
  801564:	01 d0                	add    %edx,%eax
  801566:	01 c0                	add    %eax,%eax
  801568:	29 c1                	sub    %eax,%ecx
  80156a:	89 ca                	mov    %ecx,%edx
  80156c:	85 d2                	test   %edx,%edx
  80156e:	75 9c                	jne    80150c <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801570:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  801577:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80157a:	48                   	dec    %eax
  80157b:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  80157e:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801582:	74 3d                	je     8015c1 <ltostr+0xe2>
		start = 1 ;
  801584:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  80158b:	eb 34                	jmp    8015c1 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  80158d:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801590:	8b 45 0c             	mov    0xc(%ebp),%eax
  801593:	01 d0                	add    %edx,%eax
  801595:	8a 00                	mov    (%eax),%al
  801597:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80159a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80159d:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015a0:	01 c2                	add    %eax,%edx
  8015a2:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  8015a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015a8:	01 c8                	add    %ecx,%eax
  8015aa:	8a 00                	mov    (%eax),%al
  8015ac:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  8015ae:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8015b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015b4:	01 c2                	add    %eax,%edx
  8015b6:	8a 45 eb             	mov    -0x15(%ebp),%al
  8015b9:	88 02                	mov    %al,(%edx)
		start++ ;
  8015bb:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8015be:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8015c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8015c4:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8015c7:	7c c4                	jl     80158d <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8015c9:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8015cc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8015cf:	01 d0                	add    %edx,%eax
  8015d1:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8015d4:	90                   	nop
  8015d5:	c9                   	leave  
  8015d6:	c3                   	ret    

008015d7 <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8015d7:	55                   	push   %ebp
  8015d8:	89 e5                	mov    %esp,%ebp
  8015da:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8015dd:	ff 75 08             	pushl  0x8(%ebp)
  8015e0:	e8 54 fa ff ff       	call   801039 <strlen>
  8015e5:	83 c4 04             	add    $0x4,%esp
  8015e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8015eb:	ff 75 0c             	pushl  0xc(%ebp)
  8015ee:	e8 46 fa ff ff       	call   801039 <strlen>
  8015f3:	83 c4 04             	add    $0x4,%esp
  8015f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8015f9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  801600:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  801607:	eb 17                	jmp    801620 <strcconcat+0x49>
		final[s] = str1[s] ;
  801609:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80160c:	8b 45 10             	mov    0x10(%ebp),%eax
  80160f:	01 c2                	add    %eax,%edx
  801611:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  801614:	8b 45 08             	mov    0x8(%ebp),%eax
  801617:	01 c8                	add    %ecx,%eax
  801619:	8a 00                	mov    (%eax),%al
  80161b:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  80161d:	ff 45 fc             	incl   -0x4(%ebp)
  801620:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801623:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  801626:	7c e1                	jl     801609 <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  801628:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  80162f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  801636:	eb 1f                	jmp    801657 <strcconcat+0x80>
		final[s++] = str2[i] ;
  801638:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80163b:	8d 50 01             	lea    0x1(%eax),%edx
  80163e:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801641:	89 c2                	mov    %eax,%edx
  801643:	8b 45 10             	mov    0x10(%ebp),%eax
  801646:	01 c2                	add    %eax,%edx
  801648:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  80164b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80164e:	01 c8                	add    %ecx,%eax
  801650:	8a 00                	mov    (%eax),%al
  801652:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801654:	ff 45 f8             	incl   -0x8(%ebp)
  801657:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80165a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  80165d:	7c d9                	jl     801638 <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  80165f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801662:	8b 45 10             	mov    0x10(%ebp),%eax
  801665:	01 d0                	add    %edx,%eax
  801667:	c6 00 00             	movb   $0x0,(%eax)
}
  80166a:	90                   	nop
  80166b:	c9                   	leave  
  80166c:	c3                   	ret    

0080166d <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  80166d:	55                   	push   %ebp
  80166e:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801670:	8b 45 14             	mov    0x14(%ebp),%eax
  801673:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  801679:	8b 45 14             	mov    0x14(%ebp),%eax
  80167c:	8b 00                	mov    (%eax),%eax
  80167e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801685:	8b 45 10             	mov    0x10(%ebp),%eax
  801688:	01 d0                	add    %edx,%eax
  80168a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801690:	eb 0c                	jmp    80169e <strsplit+0x31>
			*string++ = 0;
  801692:	8b 45 08             	mov    0x8(%ebp),%eax
  801695:	8d 50 01             	lea    0x1(%eax),%edx
  801698:	89 55 08             	mov    %edx,0x8(%ebp)
  80169b:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  80169e:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a1:	8a 00                	mov    (%eax),%al
  8016a3:	84 c0                	test   %al,%al
  8016a5:	74 18                	je     8016bf <strsplit+0x52>
  8016a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8016aa:	8a 00                	mov    (%eax),%al
  8016ac:	0f be c0             	movsbl %al,%eax
  8016af:	50                   	push   %eax
  8016b0:	ff 75 0c             	pushl  0xc(%ebp)
  8016b3:	e8 13 fb ff ff       	call   8011cb <strchr>
  8016b8:	83 c4 08             	add    $0x8,%esp
  8016bb:	85 c0                	test   %eax,%eax
  8016bd:	75 d3                	jne    801692 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8016bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8016c2:	8a 00                	mov    (%eax),%al
  8016c4:	84 c0                	test   %al,%al
  8016c6:	74 5a                	je     801722 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8016c8:	8b 45 14             	mov    0x14(%ebp),%eax
  8016cb:	8b 00                	mov    (%eax),%eax
  8016cd:	83 f8 0f             	cmp    $0xf,%eax
  8016d0:	75 07                	jne    8016d9 <strsplit+0x6c>
		{
			return 0;
  8016d2:	b8 00 00 00 00       	mov    $0x0,%eax
  8016d7:	eb 66                	jmp    80173f <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8016d9:	8b 45 14             	mov    0x14(%ebp),%eax
  8016dc:	8b 00                	mov    (%eax),%eax
  8016de:	8d 48 01             	lea    0x1(%eax),%ecx
  8016e1:	8b 55 14             	mov    0x14(%ebp),%edx
  8016e4:	89 0a                	mov    %ecx,(%edx)
  8016e6:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8016ed:	8b 45 10             	mov    0x10(%ebp),%eax
  8016f0:	01 c2                	add    %eax,%edx
  8016f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8016f5:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8016f7:	eb 03                	jmp    8016fc <strsplit+0x8f>
			string++;
  8016f9:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8016fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ff:	8a 00                	mov    (%eax),%al
  801701:	84 c0                	test   %al,%al
  801703:	74 8b                	je     801690 <strsplit+0x23>
  801705:	8b 45 08             	mov    0x8(%ebp),%eax
  801708:	8a 00                	mov    (%eax),%al
  80170a:	0f be c0             	movsbl %al,%eax
  80170d:	50                   	push   %eax
  80170e:	ff 75 0c             	pushl  0xc(%ebp)
  801711:	e8 b5 fa ff ff       	call   8011cb <strchr>
  801716:	83 c4 08             	add    $0x8,%esp
  801719:	85 c0                	test   %eax,%eax
  80171b:	74 dc                	je     8016f9 <strsplit+0x8c>
			string++;
	}
  80171d:	e9 6e ff ff ff       	jmp    801690 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801722:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801723:	8b 45 14             	mov    0x14(%ebp),%eax
  801726:	8b 00                	mov    (%eax),%eax
  801728:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80172f:	8b 45 10             	mov    0x10(%ebp),%eax
  801732:	01 d0                	add    %edx,%eax
  801734:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80173a:	b8 01 00 00 00       	mov    $0x1,%eax
}
  80173f:	c9                   	leave  
  801740:	c3                   	ret    

00801741 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801741:	55                   	push   %ebp
  801742:	89 e5                	mov    %esp,%ebp
  801744:	57                   	push   %edi
  801745:	56                   	push   %esi
  801746:	53                   	push   %ebx
  801747:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80174a:	8b 45 08             	mov    0x8(%ebp),%eax
  80174d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801750:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801753:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801756:	8b 7d 18             	mov    0x18(%ebp),%edi
  801759:	8b 75 1c             	mov    0x1c(%ebp),%esi
  80175c:	cd 30                	int    $0x30
  80175e:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801761:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801764:	83 c4 10             	add    $0x10,%esp
  801767:	5b                   	pop    %ebx
  801768:	5e                   	pop    %esi
  801769:	5f                   	pop    %edi
  80176a:	5d                   	pop    %ebp
  80176b:	c3                   	ret    

0080176c <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  80176c:	55                   	push   %ebp
  80176d:	89 e5                	mov    %esp,%ebp
  80176f:	83 ec 04             	sub    $0x4,%esp
  801772:	8b 45 10             	mov    0x10(%ebp),%eax
  801775:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  801778:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  80177c:	8b 45 08             	mov    0x8(%ebp),%eax
  80177f:	6a 00                	push   $0x0
  801781:	6a 00                	push   $0x0
  801783:	52                   	push   %edx
  801784:	ff 75 0c             	pushl  0xc(%ebp)
  801787:	50                   	push   %eax
  801788:	6a 00                	push   $0x0
  80178a:	e8 b2 ff ff ff       	call   801741 <syscall>
  80178f:	83 c4 18             	add    $0x18,%esp
}
  801792:	90                   	nop
  801793:	c9                   	leave  
  801794:	c3                   	ret    

00801795 <sys_cgetc>:

int
sys_cgetc(void)
{
  801795:	55                   	push   %ebp
  801796:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  801798:	6a 00                	push   $0x0
  80179a:	6a 00                	push   $0x0
  80179c:	6a 00                	push   $0x0
  80179e:	6a 00                	push   $0x0
  8017a0:	6a 00                	push   $0x0
  8017a2:	6a 01                	push   $0x1
  8017a4:	e8 98 ff ff ff       	call   801741 <syscall>
  8017a9:	83 c4 18             	add    $0x18,%esp
}
  8017ac:	c9                   	leave  
  8017ad:	c3                   	ret    

008017ae <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  8017ae:	55                   	push   %ebp
  8017af:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  8017b1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b7:	6a 00                	push   $0x0
  8017b9:	6a 00                	push   $0x0
  8017bb:	6a 00                	push   $0x0
  8017bd:	52                   	push   %edx
  8017be:	50                   	push   %eax
  8017bf:	6a 05                	push   $0x5
  8017c1:	e8 7b ff ff ff       	call   801741 <syscall>
  8017c6:	83 c4 18             	add    $0x18,%esp
}
  8017c9:	c9                   	leave  
  8017ca:	c3                   	ret    

008017cb <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8017cb:	55                   	push   %ebp
  8017cc:	89 e5                	mov    %esp,%ebp
  8017ce:	56                   	push   %esi
  8017cf:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8017d0:	8b 75 18             	mov    0x18(%ebp),%esi
  8017d3:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8017d6:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8017d9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8017df:	56                   	push   %esi
  8017e0:	53                   	push   %ebx
  8017e1:	51                   	push   %ecx
  8017e2:	52                   	push   %edx
  8017e3:	50                   	push   %eax
  8017e4:	6a 06                	push   $0x6
  8017e6:	e8 56 ff ff ff       	call   801741 <syscall>
  8017eb:	83 c4 18             	add    $0x18,%esp
}
  8017ee:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8017f1:	5b                   	pop    %ebx
  8017f2:	5e                   	pop    %esi
  8017f3:	5d                   	pop    %ebp
  8017f4:	c3                   	ret    

008017f5 <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8017f5:	55                   	push   %ebp
  8017f6:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8017f8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fe:	6a 00                	push   $0x0
  801800:	6a 00                	push   $0x0
  801802:	6a 00                	push   $0x0
  801804:	52                   	push   %edx
  801805:	50                   	push   %eax
  801806:	6a 07                	push   $0x7
  801808:	e8 34 ff ff ff       	call   801741 <syscall>
  80180d:	83 c4 18             	add    $0x18,%esp
}
  801810:	c9                   	leave  
  801811:	c3                   	ret    

00801812 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  801812:	55                   	push   %ebp
  801813:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  801815:	6a 00                	push   $0x0
  801817:	6a 00                	push   $0x0
  801819:	6a 00                	push   $0x0
  80181b:	ff 75 0c             	pushl  0xc(%ebp)
  80181e:	ff 75 08             	pushl  0x8(%ebp)
  801821:	6a 08                	push   $0x8
  801823:	e8 19 ff ff ff       	call   801741 <syscall>
  801828:	83 c4 18             	add    $0x18,%esp
}
  80182b:	c9                   	leave  
  80182c:	c3                   	ret    

0080182d <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  80182d:	55                   	push   %ebp
  80182e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801830:	6a 00                	push   $0x0
  801832:	6a 00                	push   $0x0
  801834:	6a 00                	push   $0x0
  801836:	6a 00                	push   $0x0
  801838:	6a 00                	push   $0x0
  80183a:	6a 09                	push   $0x9
  80183c:	e8 00 ff ff ff       	call   801741 <syscall>
  801841:	83 c4 18             	add    $0x18,%esp
}
  801844:	c9                   	leave  
  801845:	c3                   	ret    

00801846 <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  801846:	55                   	push   %ebp
  801847:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  801849:	6a 00                	push   $0x0
  80184b:	6a 00                	push   $0x0
  80184d:	6a 00                	push   $0x0
  80184f:	6a 00                	push   $0x0
  801851:	6a 00                	push   $0x0
  801853:	6a 0a                	push   $0xa
  801855:	e8 e7 fe ff ff       	call   801741 <syscall>
  80185a:	83 c4 18             	add    $0x18,%esp
}
  80185d:	c9                   	leave  
  80185e:	c3                   	ret    

0080185f <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  80185f:	55                   	push   %ebp
  801860:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801862:	6a 00                	push   $0x0
  801864:	6a 00                	push   $0x0
  801866:	6a 00                	push   $0x0
  801868:	6a 00                	push   $0x0
  80186a:	6a 00                	push   $0x0
  80186c:	6a 0b                	push   $0xb
  80186e:	e8 ce fe ff ff       	call   801741 <syscall>
  801873:	83 c4 18             	add    $0x18,%esp
}
  801876:	c9                   	leave  
  801877:	c3                   	ret    

00801878 <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  801878:	55                   	push   %ebp
  801879:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  80187b:	6a 00                	push   $0x0
  80187d:	6a 00                	push   $0x0
  80187f:	6a 00                	push   $0x0
  801881:	ff 75 0c             	pushl  0xc(%ebp)
  801884:	ff 75 08             	pushl  0x8(%ebp)
  801887:	6a 0f                	push   $0xf
  801889:	e8 b3 fe ff ff       	call   801741 <syscall>
  80188e:	83 c4 18             	add    $0x18,%esp
	return;
  801891:	90                   	nop
}
  801892:	c9                   	leave  
  801893:	c3                   	ret    

00801894 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801894:	55                   	push   %ebp
  801895:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  801897:	6a 00                	push   $0x0
  801899:	6a 00                	push   $0x0
  80189b:	6a 00                	push   $0x0
  80189d:	ff 75 0c             	pushl  0xc(%ebp)
  8018a0:	ff 75 08             	pushl  0x8(%ebp)
  8018a3:	6a 10                	push   $0x10
  8018a5:	e8 97 fe ff ff       	call   801741 <syscall>
  8018aa:	83 c4 18             	add    $0x18,%esp
	return ;
  8018ad:	90                   	nop
}
  8018ae:	c9                   	leave  
  8018af:	c3                   	ret    

008018b0 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  8018b0:	55                   	push   %ebp
  8018b1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  8018b3:	6a 00                	push   $0x0
  8018b5:	6a 00                	push   $0x0
  8018b7:	ff 75 10             	pushl  0x10(%ebp)
  8018ba:	ff 75 0c             	pushl  0xc(%ebp)
  8018bd:	ff 75 08             	pushl  0x8(%ebp)
  8018c0:	6a 11                	push   $0x11
  8018c2:	e8 7a fe ff ff       	call   801741 <syscall>
  8018c7:	83 c4 18             	add    $0x18,%esp
	return ;
  8018ca:	90                   	nop
}
  8018cb:	c9                   	leave  
  8018cc:	c3                   	ret    

008018cd <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8018cd:	55                   	push   %ebp
  8018ce:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8018d0:	6a 00                	push   $0x0
  8018d2:	6a 00                	push   $0x0
  8018d4:	6a 00                	push   $0x0
  8018d6:	6a 00                	push   $0x0
  8018d8:	6a 00                	push   $0x0
  8018da:	6a 0c                	push   $0xc
  8018dc:	e8 60 fe ff ff       	call   801741 <syscall>
  8018e1:	83 c4 18             	add    $0x18,%esp
}
  8018e4:	c9                   	leave  
  8018e5:	c3                   	ret    

008018e6 <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8018e6:	55                   	push   %ebp
  8018e7:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8018e9:	6a 00                	push   $0x0
  8018eb:	6a 00                	push   $0x0
  8018ed:	6a 00                	push   $0x0
  8018ef:	6a 00                	push   $0x0
  8018f1:	ff 75 08             	pushl  0x8(%ebp)
  8018f4:	6a 0d                	push   $0xd
  8018f6:	e8 46 fe ff ff       	call   801741 <syscall>
  8018fb:	83 c4 18             	add    $0x18,%esp
}
  8018fe:	c9                   	leave  
  8018ff:	c3                   	ret    

00801900 <sys_scarce_memory>:

void sys_scarce_memory()
{
  801900:	55                   	push   %ebp
  801901:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  801903:	6a 00                	push   $0x0
  801905:	6a 00                	push   $0x0
  801907:	6a 00                	push   $0x0
  801909:	6a 00                	push   $0x0
  80190b:	6a 00                	push   $0x0
  80190d:	6a 0e                	push   $0xe
  80190f:	e8 2d fe ff ff       	call   801741 <syscall>
  801914:	83 c4 18             	add    $0x18,%esp
}
  801917:	90                   	nop
  801918:	c9                   	leave  
  801919:	c3                   	ret    

0080191a <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  80191a:	55                   	push   %ebp
  80191b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  80191d:	6a 00                	push   $0x0
  80191f:	6a 00                	push   $0x0
  801921:	6a 00                	push   $0x0
  801923:	6a 00                	push   $0x0
  801925:	6a 00                	push   $0x0
  801927:	6a 13                	push   $0x13
  801929:	e8 13 fe ff ff       	call   801741 <syscall>
  80192e:	83 c4 18             	add    $0x18,%esp
}
  801931:	90                   	nop
  801932:	c9                   	leave  
  801933:	c3                   	ret    

00801934 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801934:	55                   	push   %ebp
  801935:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  801937:	6a 00                	push   $0x0
  801939:	6a 00                	push   $0x0
  80193b:	6a 00                	push   $0x0
  80193d:	6a 00                	push   $0x0
  80193f:	6a 00                	push   $0x0
  801941:	6a 14                	push   $0x14
  801943:	e8 f9 fd ff ff       	call   801741 <syscall>
  801948:	83 c4 18             	add    $0x18,%esp
}
  80194b:	90                   	nop
  80194c:	c9                   	leave  
  80194d:	c3                   	ret    

0080194e <sys_cputc>:


void
sys_cputc(const char c)
{
  80194e:	55                   	push   %ebp
  80194f:	89 e5                	mov    %esp,%ebp
  801951:	83 ec 04             	sub    $0x4,%esp
  801954:	8b 45 08             	mov    0x8(%ebp),%eax
  801957:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80195a:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  80195e:	6a 00                	push   $0x0
  801960:	6a 00                	push   $0x0
  801962:	6a 00                	push   $0x0
  801964:	6a 00                	push   $0x0
  801966:	50                   	push   %eax
  801967:	6a 15                	push   $0x15
  801969:	e8 d3 fd ff ff       	call   801741 <syscall>
  80196e:	83 c4 18             	add    $0x18,%esp
}
  801971:	90                   	nop
  801972:	c9                   	leave  
  801973:	c3                   	ret    

00801974 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801974:	55                   	push   %ebp
  801975:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  801977:	6a 00                	push   $0x0
  801979:	6a 00                	push   $0x0
  80197b:	6a 00                	push   $0x0
  80197d:	6a 00                	push   $0x0
  80197f:	6a 00                	push   $0x0
  801981:	6a 16                	push   $0x16
  801983:	e8 b9 fd ff ff       	call   801741 <syscall>
  801988:	83 c4 18             	add    $0x18,%esp
}
  80198b:	90                   	nop
  80198c:	c9                   	leave  
  80198d:	c3                   	ret    

0080198e <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  80198e:	55                   	push   %ebp
  80198f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801991:	8b 45 08             	mov    0x8(%ebp),%eax
  801994:	6a 00                	push   $0x0
  801996:	6a 00                	push   $0x0
  801998:	6a 00                	push   $0x0
  80199a:	ff 75 0c             	pushl  0xc(%ebp)
  80199d:	50                   	push   %eax
  80199e:	6a 17                	push   $0x17
  8019a0:	e8 9c fd ff ff       	call   801741 <syscall>
  8019a5:	83 c4 18             	add    $0x18,%esp
}
  8019a8:	c9                   	leave  
  8019a9:	c3                   	ret    

008019aa <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  8019aa:	55                   	push   %ebp
  8019ab:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8019ad:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b3:	6a 00                	push   $0x0
  8019b5:	6a 00                	push   $0x0
  8019b7:	6a 00                	push   $0x0
  8019b9:	52                   	push   %edx
  8019ba:	50                   	push   %eax
  8019bb:	6a 1a                	push   $0x1a
  8019bd:	e8 7f fd ff ff       	call   801741 <syscall>
  8019c2:	83 c4 18             	add    $0x18,%esp
}
  8019c5:	c9                   	leave  
  8019c6:	c3                   	ret    

008019c7 <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8019c7:	55                   	push   %ebp
  8019c8:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8019ca:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019cd:	8b 45 08             	mov    0x8(%ebp),%eax
  8019d0:	6a 00                	push   $0x0
  8019d2:	6a 00                	push   $0x0
  8019d4:	6a 00                	push   $0x0
  8019d6:	52                   	push   %edx
  8019d7:	50                   	push   %eax
  8019d8:	6a 18                	push   $0x18
  8019da:	e8 62 fd ff ff       	call   801741 <syscall>
  8019df:	83 c4 18             	add    $0x18,%esp
}
  8019e2:	90                   	nop
  8019e3:	c9                   	leave  
  8019e4:	c3                   	ret    

008019e5 <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8019e5:	55                   	push   %ebp
  8019e6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8019e8:	8b 55 0c             	mov    0xc(%ebp),%edx
  8019eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8019ee:	6a 00                	push   $0x0
  8019f0:	6a 00                	push   $0x0
  8019f2:	6a 00                	push   $0x0
  8019f4:	52                   	push   %edx
  8019f5:	50                   	push   %eax
  8019f6:	6a 19                	push   $0x19
  8019f8:	e8 44 fd ff ff       	call   801741 <syscall>
  8019fd:	83 c4 18             	add    $0x18,%esp
}
  801a00:	90                   	nop
  801a01:	c9                   	leave  
  801a02:	c3                   	ret    

00801a03 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  801a03:	55                   	push   %ebp
  801a04:	89 e5                	mov    %esp,%ebp
  801a06:	83 ec 04             	sub    $0x4,%esp
  801a09:	8b 45 10             	mov    0x10(%ebp),%eax
  801a0c:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  801a0f:	8b 4d 14             	mov    0x14(%ebp),%ecx
  801a12:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801a16:	8b 45 08             	mov    0x8(%ebp),%eax
  801a19:	6a 00                	push   $0x0
  801a1b:	51                   	push   %ecx
  801a1c:	52                   	push   %edx
  801a1d:	ff 75 0c             	pushl  0xc(%ebp)
  801a20:	50                   	push   %eax
  801a21:	6a 1b                	push   $0x1b
  801a23:	e8 19 fd ff ff       	call   801741 <syscall>
  801a28:	83 c4 18             	add    $0x18,%esp
}
  801a2b:	c9                   	leave  
  801a2c:	c3                   	ret    

00801a2d <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801a2d:	55                   	push   %ebp
  801a2e:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801a30:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a33:	8b 45 08             	mov    0x8(%ebp),%eax
  801a36:	6a 00                	push   $0x0
  801a38:	6a 00                	push   $0x0
  801a3a:	6a 00                	push   $0x0
  801a3c:	52                   	push   %edx
  801a3d:	50                   	push   %eax
  801a3e:	6a 1c                	push   $0x1c
  801a40:	e8 fc fc ff ff       	call   801741 <syscall>
  801a45:	83 c4 18             	add    $0x18,%esp
}
  801a48:	c9                   	leave  
  801a49:	c3                   	ret    

00801a4a <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801a4a:	55                   	push   %ebp
  801a4b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801a4d:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a50:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a53:	8b 45 08             	mov    0x8(%ebp),%eax
  801a56:	6a 00                	push   $0x0
  801a58:	6a 00                	push   $0x0
  801a5a:	51                   	push   %ecx
  801a5b:	52                   	push   %edx
  801a5c:	50                   	push   %eax
  801a5d:	6a 1d                	push   $0x1d
  801a5f:	e8 dd fc ff ff       	call   801741 <syscall>
  801a64:	83 c4 18             	add    $0x18,%esp
}
  801a67:	c9                   	leave  
  801a68:	c3                   	ret    

00801a69 <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  801a69:	55                   	push   %ebp
  801a6a:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801a6c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a6f:	8b 45 08             	mov    0x8(%ebp),%eax
  801a72:	6a 00                	push   $0x0
  801a74:	6a 00                	push   $0x0
  801a76:	6a 00                	push   $0x0
  801a78:	52                   	push   %edx
  801a79:	50                   	push   %eax
  801a7a:	6a 1e                	push   $0x1e
  801a7c:	e8 c0 fc ff ff       	call   801741 <syscall>
  801a81:	83 c4 18             	add    $0x18,%esp
}
  801a84:	c9                   	leave  
  801a85:	c3                   	ret    

00801a86 <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  801a86:	55                   	push   %ebp
  801a87:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  801a89:	6a 00                	push   $0x0
  801a8b:	6a 00                	push   $0x0
  801a8d:	6a 00                	push   $0x0
  801a8f:	6a 00                	push   $0x0
  801a91:	6a 00                	push   $0x0
  801a93:	6a 1f                	push   $0x1f
  801a95:	e8 a7 fc ff ff       	call   801741 <syscall>
  801a9a:	83 c4 18             	add    $0x18,%esp
}
  801a9d:	c9                   	leave  
  801a9e:	c3                   	ret    

00801a9f <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801a9f:	55                   	push   %ebp
  801aa0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801aa2:	8b 45 08             	mov    0x8(%ebp),%eax
  801aa5:	6a 00                	push   $0x0
  801aa7:	ff 75 14             	pushl  0x14(%ebp)
  801aaa:	ff 75 10             	pushl  0x10(%ebp)
  801aad:	ff 75 0c             	pushl  0xc(%ebp)
  801ab0:	50                   	push   %eax
  801ab1:	6a 20                	push   $0x20
  801ab3:	e8 89 fc ff ff       	call   801741 <syscall>
  801ab8:	83 c4 18             	add    $0x18,%esp
}
  801abb:	c9                   	leave  
  801abc:	c3                   	ret    

00801abd <sys_run_env>:

void
sys_run_env(int32 envId)
{
  801abd:	55                   	push   %ebp
  801abe:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  801ac0:	8b 45 08             	mov    0x8(%ebp),%eax
  801ac3:	6a 00                	push   $0x0
  801ac5:	6a 00                	push   $0x0
  801ac7:	6a 00                	push   $0x0
  801ac9:	6a 00                	push   $0x0
  801acb:	50                   	push   %eax
  801acc:	6a 21                	push   $0x21
  801ace:	e8 6e fc ff ff       	call   801741 <syscall>
  801ad3:	83 c4 18             	add    $0x18,%esp
}
  801ad6:	90                   	nop
  801ad7:	c9                   	leave  
  801ad8:	c3                   	ret    

00801ad9 <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  801ad9:	55                   	push   %ebp
  801ada:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  801adc:	8b 45 08             	mov    0x8(%ebp),%eax
  801adf:	6a 00                	push   $0x0
  801ae1:	6a 00                	push   $0x0
  801ae3:	6a 00                	push   $0x0
  801ae5:	6a 00                	push   $0x0
  801ae7:	50                   	push   %eax
  801ae8:	6a 22                	push   $0x22
  801aea:	e8 52 fc ff ff       	call   801741 <syscall>
  801aef:	83 c4 18             	add    $0x18,%esp
}
  801af2:	c9                   	leave  
  801af3:	c3                   	ret    

00801af4 <sys_getenvid>:

int32 sys_getenvid(void)
{
  801af4:	55                   	push   %ebp
  801af5:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  801af7:	6a 00                	push   $0x0
  801af9:	6a 00                	push   $0x0
  801afb:	6a 00                	push   $0x0
  801afd:	6a 00                	push   $0x0
  801aff:	6a 00                	push   $0x0
  801b01:	6a 02                	push   $0x2
  801b03:	e8 39 fc ff ff       	call   801741 <syscall>
  801b08:	83 c4 18             	add    $0x18,%esp
}
  801b0b:	c9                   	leave  
  801b0c:	c3                   	ret    

00801b0d <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  801b0d:	55                   	push   %ebp
  801b0e:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  801b10:	6a 00                	push   $0x0
  801b12:	6a 00                	push   $0x0
  801b14:	6a 00                	push   $0x0
  801b16:	6a 00                	push   $0x0
  801b18:	6a 00                	push   $0x0
  801b1a:	6a 03                	push   $0x3
  801b1c:	e8 20 fc ff ff       	call   801741 <syscall>
  801b21:	83 c4 18             	add    $0x18,%esp
}
  801b24:	c9                   	leave  
  801b25:	c3                   	ret    

00801b26 <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  801b26:	55                   	push   %ebp
  801b27:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  801b29:	6a 00                	push   $0x0
  801b2b:	6a 00                	push   $0x0
  801b2d:	6a 00                	push   $0x0
  801b2f:	6a 00                	push   $0x0
  801b31:	6a 00                	push   $0x0
  801b33:	6a 04                	push   $0x4
  801b35:	e8 07 fc ff ff       	call   801741 <syscall>
  801b3a:	83 c4 18             	add    $0x18,%esp
}
  801b3d:	c9                   	leave  
  801b3e:	c3                   	ret    

00801b3f <sys_exit_env>:


void sys_exit_env(void)
{
  801b3f:	55                   	push   %ebp
  801b40:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801b42:	6a 00                	push   $0x0
  801b44:	6a 00                	push   $0x0
  801b46:	6a 00                	push   $0x0
  801b48:	6a 00                	push   $0x0
  801b4a:	6a 00                	push   $0x0
  801b4c:	6a 23                	push   $0x23
  801b4e:	e8 ee fb ff ff       	call   801741 <syscall>
  801b53:	83 c4 18             	add    $0x18,%esp
}
  801b56:	90                   	nop
  801b57:	c9                   	leave  
  801b58:	c3                   	ret    

00801b59 <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  801b59:	55                   	push   %ebp
  801b5a:	89 e5                	mov    %esp,%ebp
  801b5c:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801b5f:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b62:	8d 50 04             	lea    0x4(%eax),%edx
  801b65:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801b68:	6a 00                	push   $0x0
  801b6a:	6a 00                	push   $0x0
  801b6c:	6a 00                	push   $0x0
  801b6e:	52                   	push   %edx
  801b6f:	50                   	push   %eax
  801b70:	6a 24                	push   $0x24
  801b72:	e8 ca fb ff ff       	call   801741 <syscall>
  801b77:	83 c4 18             	add    $0x18,%esp
	return result;
  801b7a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801b7d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801b80:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801b83:	89 01                	mov    %eax,(%ecx)
  801b85:	89 51 04             	mov    %edx,0x4(%ecx)
}
  801b88:	8b 45 08             	mov    0x8(%ebp),%eax
  801b8b:	c9                   	leave  
  801b8c:	c2 04 00             	ret    $0x4

00801b8f <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801b8f:	55                   	push   %ebp
  801b90:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801b92:	6a 00                	push   $0x0
  801b94:	6a 00                	push   $0x0
  801b96:	ff 75 10             	pushl  0x10(%ebp)
  801b99:	ff 75 0c             	pushl  0xc(%ebp)
  801b9c:	ff 75 08             	pushl  0x8(%ebp)
  801b9f:	6a 12                	push   $0x12
  801ba1:	e8 9b fb ff ff       	call   801741 <syscall>
  801ba6:	83 c4 18             	add    $0x18,%esp
	return ;
  801ba9:	90                   	nop
}
  801baa:	c9                   	leave  
  801bab:	c3                   	ret    

00801bac <sys_rcr2>:
uint32 sys_rcr2()
{
  801bac:	55                   	push   %ebp
  801bad:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801baf:	6a 00                	push   $0x0
  801bb1:	6a 00                	push   $0x0
  801bb3:	6a 00                	push   $0x0
  801bb5:	6a 00                	push   $0x0
  801bb7:	6a 00                	push   $0x0
  801bb9:	6a 25                	push   $0x25
  801bbb:	e8 81 fb ff ff       	call   801741 <syscall>
  801bc0:	83 c4 18             	add    $0x18,%esp
}
  801bc3:	c9                   	leave  
  801bc4:	c3                   	ret    

00801bc5 <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  801bc5:	55                   	push   %ebp
  801bc6:	89 e5                	mov    %esp,%ebp
  801bc8:	83 ec 04             	sub    $0x4,%esp
  801bcb:	8b 45 08             	mov    0x8(%ebp),%eax
  801bce:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  801bd1:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  801bd5:	6a 00                	push   $0x0
  801bd7:	6a 00                	push   $0x0
  801bd9:	6a 00                	push   $0x0
  801bdb:	6a 00                	push   $0x0
  801bdd:	50                   	push   %eax
  801bde:	6a 26                	push   $0x26
  801be0:	e8 5c fb ff ff       	call   801741 <syscall>
  801be5:	83 c4 18             	add    $0x18,%esp
	return ;
  801be8:	90                   	nop
}
  801be9:	c9                   	leave  
  801bea:	c3                   	ret    

00801beb <rsttst>:
void rsttst()
{
  801beb:	55                   	push   %ebp
  801bec:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  801bee:	6a 00                	push   $0x0
  801bf0:	6a 00                	push   $0x0
  801bf2:	6a 00                	push   $0x0
  801bf4:	6a 00                	push   $0x0
  801bf6:	6a 00                	push   $0x0
  801bf8:	6a 28                	push   $0x28
  801bfa:	e8 42 fb ff ff       	call   801741 <syscall>
  801bff:	83 c4 18             	add    $0x18,%esp
	return ;
  801c02:	90                   	nop
}
  801c03:	c9                   	leave  
  801c04:	c3                   	ret    

00801c05 <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  801c05:	55                   	push   %ebp
  801c06:	89 e5                	mov    %esp,%ebp
  801c08:	83 ec 04             	sub    $0x4,%esp
  801c0b:	8b 45 14             	mov    0x14(%ebp),%eax
  801c0e:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  801c11:	8b 55 18             	mov    0x18(%ebp),%edx
  801c14:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801c18:	52                   	push   %edx
  801c19:	50                   	push   %eax
  801c1a:	ff 75 10             	pushl  0x10(%ebp)
  801c1d:	ff 75 0c             	pushl  0xc(%ebp)
  801c20:	ff 75 08             	pushl  0x8(%ebp)
  801c23:	6a 27                	push   $0x27
  801c25:	e8 17 fb ff ff       	call   801741 <syscall>
  801c2a:	83 c4 18             	add    $0x18,%esp
	return ;
  801c2d:	90                   	nop
}
  801c2e:	c9                   	leave  
  801c2f:	c3                   	ret    

00801c30 <chktst>:
void chktst(uint32 n)
{
  801c30:	55                   	push   %ebp
  801c31:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801c33:	6a 00                	push   $0x0
  801c35:	6a 00                	push   $0x0
  801c37:	6a 00                	push   $0x0
  801c39:	6a 00                	push   $0x0
  801c3b:	ff 75 08             	pushl  0x8(%ebp)
  801c3e:	6a 29                	push   $0x29
  801c40:	e8 fc fa ff ff       	call   801741 <syscall>
  801c45:	83 c4 18             	add    $0x18,%esp
	return ;
  801c48:	90                   	nop
}
  801c49:	c9                   	leave  
  801c4a:	c3                   	ret    

00801c4b <inctst>:

void inctst()
{
  801c4b:	55                   	push   %ebp
  801c4c:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801c4e:	6a 00                	push   $0x0
  801c50:	6a 00                	push   $0x0
  801c52:	6a 00                	push   $0x0
  801c54:	6a 00                	push   $0x0
  801c56:	6a 00                	push   $0x0
  801c58:	6a 2a                	push   $0x2a
  801c5a:	e8 e2 fa ff ff       	call   801741 <syscall>
  801c5f:	83 c4 18             	add    $0x18,%esp
	return ;
  801c62:	90                   	nop
}
  801c63:	c9                   	leave  
  801c64:	c3                   	ret    

00801c65 <gettst>:
uint32 gettst()
{
  801c65:	55                   	push   %ebp
  801c66:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801c68:	6a 00                	push   $0x0
  801c6a:	6a 00                	push   $0x0
  801c6c:	6a 00                	push   $0x0
  801c6e:	6a 00                	push   $0x0
  801c70:	6a 00                	push   $0x0
  801c72:	6a 2b                	push   $0x2b
  801c74:	e8 c8 fa ff ff       	call   801741 <syscall>
  801c79:	83 c4 18             	add    $0x18,%esp
}
  801c7c:	c9                   	leave  
  801c7d:	c3                   	ret    

00801c7e <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801c7e:	55                   	push   %ebp
  801c7f:	89 e5                	mov    %esp,%ebp
  801c81:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801c84:	6a 00                	push   $0x0
  801c86:	6a 00                	push   $0x0
  801c88:	6a 00                	push   $0x0
  801c8a:	6a 00                	push   $0x0
  801c8c:	6a 00                	push   $0x0
  801c8e:	6a 2c                	push   $0x2c
  801c90:	e8 ac fa ff ff       	call   801741 <syscall>
  801c95:	83 c4 18             	add    $0x18,%esp
  801c98:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801c9b:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801c9f:	75 07                	jne    801ca8 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801ca1:	b8 01 00 00 00       	mov    $0x1,%eax
  801ca6:	eb 05                	jmp    801cad <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801ca8:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cad:	c9                   	leave  
  801cae:	c3                   	ret    

00801caf <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801caf:	55                   	push   %ebp
  801cb0:	89 e5                	mov    %esp,%ebp
  801cb2:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801cb5:	6a 00                	push   $0x0
  801cb7:	6a 00                	push   $0x0
  801cb9:	6a 00                	push   $0x0
  801cbb:	6a 00                	push   $0x0
  801cbd:	6a 00                	push   $0x0
  801cbf:	6a 2c                	push   $0x2c
  801cc1:	e8 7b fa ff ff       	call   801741 <syscall>
  801cc6:	83 c4 18             	add    $0x18,%esp
  801cc9:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801ccc:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801cd0:	75 07                	jne    801cd9 <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801cd2:	b8 01 00 00 00       	mov    $0x1,%eax
  801cd7:	eb 05                	jmp    801cde <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801cd9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801cde:	c9                   	leave  
  801cdf:	c3                   	ret    

00801ce0 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801ce0:	55                   	push   %ebp
  801ce1:	89 e5                	mov    %esp,%ebp
  801ce3:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801ce6:	6a 00                	push   $0x0
  801ce8:	6a 00                	push   $0x0
  801cea:	6a 00                	push   $0x0
  801cec:	6a 00                	push   $0x0
  801cee:	6a 00                	push   $0x0
  801cf0:	6a 2c                	push   $0x2c
  801cf2:	e8 4a fa ff ff       	call   801741 <syscall>
  801cf7:	83 c4 18             	add    $0x18,%esp
  801cfa:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801cfd:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801d01:	75 07                	jne    801d0a <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801d03:	b8 01 00 00 00       	mov    $0x1,%eax
  801d08:	eb 05                	jmp    801d0f <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801d0a:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d0f:	c9                   	leave  
  801d10:	c3                   	ret    

00801d11 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801d11:	55                   	push   %ebp
  801d12:	89 e5                	mov    %esp,%ebp
  801d14:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801d17:	6a 00                	push   $0x0
  801d19:	6a 00                	push   $0x0
  801d1b:	6a 00                	push   $0x0
  801d1d:	6a 00                	push   $0x0
  801d1f:	6a 00                	push   $0x0
  801d21:	6a 2c                	push   $0x2c
  801d23:	e8 19 fa ff ff       	call   801741 <syscall>
  801d28:	83 c4 18             	add    $0x18,%esp
  801d2b:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801d2e:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801d32:	75 07                	jne    801d3b <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801d34:	b8 01 00 00 00       	mov    $0x1,%eax
  801d39:	eb 05                	jmp    801d40 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801d3b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801d40:	c9                   	leave  
  801d41:	c3                   	ret    

00801d42 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801d42:	55                   	push   %ebp
  801d43:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801d45:	6a 00                	push   $0x0
  801d47:	6a 00                	push   $0x0
  801d49:	6a 00                	push   $0x0
  801d4b:	6a 00                	push   $0x0
  801d4d:	ff 75 08             	pushl  0x8(%ebp)
  801d50:	6a 2d                	push   $0x2d
  801d52:	e8 ea f9 ff ff       	call   801741 <syscall>
  801d57:	83 c4 18             	add    $0x18,%esp
	return ;
  801d5a:	90                   	nop
}
  801d5b:	c9                   	leave  
  801d5c:	c3                   	ret    

00801d5d <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801d5d:	55                   	push   %ebp
  801d5e:	89 e5                	mov    %esp,%ebp
  801d60:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801d61:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801d64:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801d67:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d6a:	8b 45 08             	mov    0x8(%ebp),%eax
  801d6d:	6a 00                	push   $0x0
  801d6f:	53                   	push   %ebx
  801d70:	51                   	push   %ecx
  801d71:	52                   	push   %edx
  801d72:	50                   	push   %eax
  801d73:	6a 2e                	push   $0x2e
  801d75:	e8 c7 f9 ff ff       	call   801741 <syscall>
  801d7a:	83 c4 18             	add    $0x18,%esp
}
  801d7d:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801d80:	c9                   	leave  
  801d81:	c3                   	ret    

00801d82 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801d82:	55                   	push   %ebp
  801d83:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801d85:	8b 55 0c             	mov    0xc(%ebp),%edx
  801d88:	8b 45 08             	mov    0x8(%ebp),%eax
  801d8b:	6a 00                	push   $0x0
  801d8d:	6a 00                	push   $0x0
  801d8f:	6a 00                	push   $0x0
  801d91:	52                   	push   %edx
  801d92:	50                   	push   %eax
  801d93:	6a 2f                	push   $0x2f
  801d95:	e8 a7 f9 ff ff       	call   801741 <syscall>
  801d9a:	83 c4 18             	add    $0x18,%esp
}
  801d9d:	c9                   	leave  
  801d9e:	c3                   	ret    
  801d9f:	90                   	nop

00801da0 <__udivdi3>:
  801da0:	55                   	push   %ebp
  801da1:	57                   	push   %edi
  801da2:	56                   	push   %esi
  801da3:	53                   	push   %ebx
  801da4:	83 ec 1c             	sub    $0x1c,%esp
  801da7:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801dab:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801daf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801db3:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801db7:	89 ca                	mov    %ecx,%edx
  801db9:	89 f8                	mov    %edi,%eax
  801dbb:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801dbf:	85 f6                	test   %esi,%esi
  801dc1:	75 2d                	jne    801df0 <__udivdi3+0x50>
  801dc3:	39 cf                	cmp    %ecx,%edi
  801dc5:	77 65                	ja     801e2c <__udivdi3+0x8c>
  801dc7:	89 fd                	mov    %edi,%ebp
  801dc9:	85 ff                	test   %edi,%edi
  801dcb:	75 0b                	jne    801dd8 <__udivdi3+0x38>
  801dcd:	b8 01 00 00 00       	mov    $0x1,%eax
  801dd2:	31 d2                	xor    %edx,%edx
  801dd4:	f7 f7                	div    %edi
  801dd6:	89 c5                	mov    %eax,%ebp
  801dd8:	31 d2                	xor    %edx,%edx
  801dda:	89 c8                	mov    %ecx,%eax
  801ddc:	f7 f5                	div    %ebp
  801dde:	89 c1                	mov    %eax,%ecx
  801de0:	89 d8                	mov    %ebx,%eax
  801de2:	f7 f5                	div    %ebp
  801de4:	89 cf                	mov    %ecx,%edi
  801de6:	89 fa                	mov    %edi,%edx
  801de8:	83 c4 1c             	add    $0x1c,%esp
  801deb:	5b                   	pop    %ebx
  801dec:	5e                   	pop    %esi
  801ded:	5f                   	pop    %edi
  801dee:	5d                   	pop    %ebp
  801def:	c3                   	ret    
  801df0:	39 ce                	cmp    %ecx,%esi
  801df2:	77 28                	ja     801e1c <__udivdi3+0x7c>
  801df4:	0f bd fe             	bsr    %esi,%edi
  801df7:	83 f7 1f             	xor    $0x1f,%edi
  801dfa:	75 40                	jne    801e3c <__udivdi3+0x9c>
  801dfc:	39 ce                	cmp    %ecx,%esi
  801dfe:	72 0a                	jb     801e0a <__udivdi3+0x6a>
  801e00:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801e04:	0f 87 9e 00 00 00    	ja     801ea8 <__udivdi3+0x108>
  801e0a:	b8 01 00 00 00       	mov    $0x1,%eax
  801e0f:	89 fa                	mov    %edi,%edx
  801e11:	83 c4 1c             	add    $0x1c,%esp
  801e14:	5b                   	pop    %ebx
  801e15:	5e                   	pop    %esi
  801e16:	5f                   	pop    %edi
  801e17:	5d                   	pop    %ebp
  801e18:	c3                   	ret    
  801e19:	8d 76 00             	lea    0x0(%esi),%esi
  801e1c:	31 ff                	xor    %edi,%edi
  801e1e:	31 c0                	xor    %eax,%eax
  801e20:	89 fa                	mov    %edi,%edx
  801e22:	83 c4 1c             	add    $0x1c,%esp
  801e25:	5b                   	pop    %ebx
  801e26:	5e                   	pop    %esi
  801e27:	5f                   	pop    %edi
  801e28:	5d                   	pop    %ebp
  801e29:	c3                   	ret    
  801e2a:	66 90                	xchg   %ax,%ax
  801e2c:	89 d8                	mov    %ebx,%eax
  801e2e:	f7 f7                	div    %edi
  801e30:	31 ff                	xor    %edi,%edi
  801e32:	89 fa                	mov    %edi,%edx
  801e34:	83 c4 1c             	add    $0x1c,%esp
  801e37:	5b                   	pop    %ebx
  801e38:	5e                   	pop    %esi
  801e39:	5f                   	pop    %edi
  801e3a:	5d                   	pop    %ebp
  801e3b:	c3                   	ret    
  801e3c:	bd 20 00 00 00       	mov    $0x20,%ebp
  801e41:	89 eb                	mov    %ebp,%ebx
  801e43:	29 fb                	sub    %edi,%ebx
  801e45:	89 f9                	mov    %edi,%ecx
  801e47:	d3 e6                	shl    %cl,%esi
  801e49:	89 c5                	mov    %eax,%ebp
  801e4b:	88 d9                	mov    %bl,%cl
  801e4d:	d3 ed                	shr    %cl,%ebp
  801e4f:	89 e9                	mov    %ebp,%ecx
  801e51:	09 f1                	or     %esi,%ecx
  801e53:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801e57:	89 f9                	mov    %edi,%ecx
  801e59:	d3 e0                	shl    %cl,%eax
  801e5b:	89 c5                	mov    %eax,%ebp
  801e5d:	89 d6                	mov    %edx,%esi
  801e5f:	88 d9                	mov    %bl,%cl
  801e61:	d3 ee                	shr    %cl,%esi
  801e63:	89 f9                	mov    %edi,%ecx
  801e65:	d3 e2                	shl    %cl,%edx
  801e67:	8b 44 24 08          	mov    0x8(%esp),%eax
  801e6b:	88 d9                	mov    %bl,%cl
  801e6d:	d3 e8                	shr    %cl,%eax
  801e6f:	09 c2                	or     %eax,%edx
  801e71:	89 d0                	mov    %edx,%eax
  801e73:	89 f2                	mov    %esi,%edx
  801e75:	f7 74 24 0c          	divl   0xc(%esp)
  801e79:	89 d6                	mov    %edx,%esi
  801e7b:	89 c3                	mov    %eax,%ebx
  801e7d:	f7 e5                	mul    %ebp
  801e7f:	39 d6                	cmp    %edx,%esi
  801e81:	72 19                	jb     801e9c <__udivdi3+0xfc>
  801e83:	74 0b                	je     801e90 <__udivdi3+0xf0>
  801e85:	89 d8                	mov    %ebx,%eax
  801e87:	31 ff                	xor    %edi,%edi
  801e89:	e9 58 ff ff ff       	jmp    801de6 <__udivdi3+0x46>
  801e8e:	66 90                	xchg   %ax,%ax
  801e90:	8b 54 24 08          	mov    0x8(%esp),%edx
  801e94:	89 f9                	mov    %edi,%ecx
  801e96:	d3 e2                	shl    %cl,%edx
  801e98:	39 c2                	cmp    %eax,%edx
  801e9a:	73 e9                	jae    801e85 <__udivdi3+0xe5>
  801e9c:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801e9f:	31 ff                	xor    %edi,%edi
  801ea1:	e9 40 ff ff ff       	jmp    801de6 <__udivdi3+0x46>
  801ea6:	66 90                	xchg   %ax,%ax
  801ea8:	31 c0                	xor    %eax,%eax
  801eaa:	e9 37 ff ff ff       	jmp    801de6 <__udivdi3+0x46>
  801eaf:	90                   	nop

00801eb0 <__umoddi3>:
  801eb0:	55                   	push   %ebp
  801eb1:	57                   	push   %edi
  801eb2:	56                   	push   %esi
  801eb3:	53                   	push   %ebx
  801eb4:	83 ec 1c             	sub    $0x1c,%esp
  801eb7:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801ebb:	8b 74 24 34          	mov    0x34(%esp),%esi
  801ebf:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801ec3:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801ec7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801ecb:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801ecf:	89 f3                	mov    %esi,%ebx
  801ed1:	89 fa                	mov    %edi,%edx
  801ed3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801ed7:	89 34 24             	mov    %esi,(%esp)
  801eda:	85 c0                	test   %eax,%eax
  801edc:	75 1a                	jne    801ef8 <__umoddi3+0x48>
  801ede:	39 f7                	cmp    %esi,%edi
  801ee0:	0f 86 a2 00 00 00    	jbe    801f88 <__umoddi3+0xd8>
  801ee6:	89 c8                	mov    %ecx,%eax
  801ee8:	89 f2                	mov    %esi,%edx
  801eea:	f7 f7                	div    %edi
  801eec:	89 d0                	mov    %edx,%eax
  801eee:	31 d2                	xor    %edx,%edx
  801ef0:	83 c4 1c             	add    $0x1c,%esp
  801ef3:	5b                   	pop    %ebx
  801ef4:	5e                   	pop    %esi
  801ef5:	5f                   	pop    %edi
  801ef6:	5d                   	pop    %ebp
  801ef7:	c3                   	ret    
  801ef8:	39 f0                	cmp    %esi,%eax
  801efa:	0f 87 ac 00 00 00    	ja     801fac <__umoddi3+0xfc>
  801f00:	0f bd e8             	bsr    %eax,%ebp
  801f03:	83 f5 1f             	xor    $0x1f,%ebp
  801f06:	0f 84 ac 00 00 00    	je     801fb8 <__umoddi3+0x108>
  801f0c:	bf 20 00 00 00       	mov    $0x20,%edi
  801f11:	29 ef                	sub    %ebp,%edi
  801f13:	89 fe                	mov    %edi,%esi
  801f15:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801f19:	89 e9                	mov    %ebp,%ecx
  801f1b:	d3 e0                	shl    %cl,%eax
  801f1d:	89 d7                	mov    %edx,%edi
  801f1f:	89 f1                	mov    %esi,%ecx
  801f21:	d3 ef                	shr    %cl,%edi
  801f23:	09 c7                	or     %eax,%edi
  801f25:	89 e9                	mov    %ebp,%ecx
  801f27:	d3 e2                	shl    %cl,%edx
  801f29:	89 14 24             	mov    %edx,(%esp)
  801f2c:	89 d8                	mov    %ebx,%eax
  801f2e:	d3 e0                	shl    %cl,%eax
  801f30:	89 c2                	mov    %eax,%edx
  801f32:	8b 44 24 08          	mov    0x8(%esp),%eax
  801f36:	d3 e0                	shl    %cl,%eax
  801f38:	89 44 24 04          	mov    %eax,0x4(%esp)
  801f3c:	8b 44 24 08          	mov    0x8(%esp),%eax
  801f40:	89 f1                	mov    %esi,%ecx
  801f42:	d3 e8                	shr    %cl,%eax
  801f44:	09 d0                	or     %edx,%eax
  801f46:	d3 eb                	shr    %cl,%ebx
  801f48:	89 da                	mov    %ebx,%edx
  801f4a:	f7 f7                	div    %edi
  801f4c:	89 d3                	mov    %edx,%ebx
  801f4e:	f7 24 24             	mull   (%esp)
  801f51:	89 c6                	mov    %eax,%esi
  801f53:	89 d1                	mov    %edx,%ecx
  801f55:	39 d3                	cmp    %edx,%ebx
  801f57:	0f 82 87 00 00 00    	jb     801fe4 <__umoddi3+0x134>
  801f5d:	0f 84 91 00 00 00    	je     801ff4 <__umoddi3+0x144>
  801f63:	8b 54 24 04          	mov    0x4(%esp),%edx
  801f67:	29 f2                	sub    %esi,%edx
  801f69:	19 cb                	sbb    %ecx,%ebx
  801f6b:	89 d8                	mov    %ebx,%eax
  801f6d:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801f71:	d3 e0                	shl    %cl,%eax
  801f73:	89 e9                	mov    %ebp,%ecx
  801f75:	d3 ea                	shr    %cl,%edx
  801f77:	09 d0                	or     %edx,%eax
  801f79:	89 e9                	mov    %ebp,%ecx
  801f7b:	d3 eb                	shr    %cl,%ebx
  801f7d:	89 da                	mov    %ebx,%edx
  801f7f:	83 c4 1c             	add    $0x1c,%esp
  801f82:	5b                   	pop    %ebx
  801f83:	5e                   	pop    %esi
  801f84:	5f                   	pop    %edi
  801f85:	5d                   	pop    %ebp
  801f86:	c3                   	ret    
  801f87:	90                   	nop
  801f88:	89 fd                	mov    %edi,%ebp
  801f8a:	85 ff                	test   %edi,%edi
  801f8c:	75 0b                	jne    801f99 <__umoddi3+0xe9>
  801f8e:	b8 01 00 00 00       	mov    $0x1,%eax
  801f93:	31 d2                	xor    %edx,%edx
  801f95:	f7 f7                	div    %edi
  801f97:	89 c5                	mov    %eax,%ebp
  801f99:	89 f0                	mov    %esi,%eax
  801f9b:	31 d2                	xor    %edx,%edx
  801f9d:	f7 f5                	div    %ebp
  801f9f:	89 c8                	mov    %ecx,%eax
  801fa1:	f7 f5                	div    %ebp
  801fa3:	89 d0                	mov    %edx,%eax
  801fa5:	e9 44 ff ff ff       	jmp    801eee <__umoddi3+0x3e>
  801faa:	66 90                	xchg   %ax,%ax
  801fac:	89 c8                	mov    %ecx,%eax
  801fae:	89 f2                	mov    %esi,%edx
  801fb0:	83 c4 1c             	add    $0x1c,%esp
  801fb3:	5b                   	pop    %ebx
  801fb4:	5e                   	pop    %esi
  801fb5:	5f                   	pop    %edi
  801fb6:	5d                   	pop    %ebp
  801fb7:	c3                   	ret    
  801fb8:	3b 04 24             	cmp    (%esp),%eax
  801fbb:	72 06                	jb     801fc3 <__umoddi3+0x113>
  801fbd:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801fc1:	77 0f                	ja     801fd2 <__umoddi3+0x122>
  801fc3:	89 f2                	mov    %esi,%edx
  801fc5:	29 f9                	sub    %edi,%ecx
  801fc7:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801fcb:	89 14 24             	mov    %edx,(%esp)
  801fce:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801fd2:	8b 44 24 04          	mov    0x4(%esp),%eax
  801fd6:	8b 14 24             	mov    (%esp),%edx
  801fd9:	83 c4 1c             	add    $0x1c,%esp
  801fdc:	5b                   	pop    %ebx
  801fdd:	5e                   	pop    %esi
  801fde:	5f                   	pop    %edi
  801fdf:	5d                   	pop    %ebp
  801fe0:	c3                   	ret    
  801fe1:	8d 76 00             	lea    0x0(%esi),%esi
  801fe4:	2b 04 24             	sub    (%esp),%eax
  801fe7:	19 fa                	sbb    %edi,%edx
  801fe9:	89 d1                	mov    %edx,%ecx
  801feb:	89 c6                	mov    %eax,%esi
  801fed:	e9 71 ff ff ff       	jmp    801f63 <__umoddi3+0xb3>
  801ff2:	66 90                	xchg   %ax,%ax
  801ff4:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801ff8:	72 ea                	jb     801fe4 <__umoddi3+0x134>
  801ffa:	89 d9                	mov    %ebx,%ecx
  801ffc:	e9 62 ff ff ff       	jmp    801f63 <__umoddi3+0xb3>
