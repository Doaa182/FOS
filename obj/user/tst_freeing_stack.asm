
obj/user/tst_freeing_stack:     file format elf32-i386


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
  800031:	e8 77 02 00 00       	call   8002ad <libmain>
1:      jmp 1b
  800036:	eb fe                	jmp    800036 <args_exist+0x5>

00800038 <_main>:

#include <inc/lib.h>

int RecursiveFn(int numOfRec);
void _main(void)
{
  800038:	55                   	push   %ebp
  800039:	89 e5                	mov    %esp,%ebp
  80003b:	83 ec 38             	sub    $0x38,%esp
	int res, numOfRec, expectedResult, r, i, j, freeFrames, usedDiskPages ;
	uint32 vaOf1stStackPage = USTACKTOP - PAGE_SIZE;
  80003e:	c7 45 dc 00 d0 bf ee 	movl   $0xeebfd000,-0x24(%ebp)

	int initNumOfEmptyWSEntries, curNumOfEmptyWSEntries ;

	/*Different number of recursive calls (each call takes 1 PAGE)*/
	for (r = 1; r <= 10; ++r)
  800045:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  80004c:	e9 c5 01 00 00       	jmp    800216 <_main+0x1de>
	{
		numOfRec = r;
  800051:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800054:	89 45 d8             	mov    %eax,-0x28(%ebp)

		initNumOfEmptyWSEntries = 0;
  800057:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
		for (j = 0; j < myEnv->page_WS_max_size; ++j)
  80005e:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800065:	eb 26                	jmp    80008d <_main+0x55>
		{
			if (myEnv->__uptr_pws[j].empty==1)
  800067:	a1 20 30 80 00       	mov    0x803020,%eax
  80006c:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800072:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800075:	89 d0                	mov    %edx,%eax
  800077:	01 c0                	add    %eax,%eax
  800079:	01 d0                	add    %edx,%eax
  80007b:	c1 e0 03             	shl    $0x3,%eax
  80007e:	01 c8                	add    %ecx,%eax
  800080:	8a 40 04             	mov    0x4(%eax),%al
  800083:	3c 01                	cmp    $0x1,%al
  800085:	75 03                	jne    80008a <_main+0x52>
				initNumOfEmptyWSEntries++;
  800087:	ff 45 e4             	incl   -0x1c(%ebp)
	for (r = 1; r <= 10; ++r)
	{
		numOfRec = r;

		initNumOfEmptyWSEntries = 0;
		for (j = 0; j < myEnv->page_WS_max_size; ++j)
  80008a:	ff 45 e8             	incl   -0x18(%ebp)
  80008d:	a1 20 30 80 00       	mov    0x803020,%eax
  800092:	8b 50 74             	mov    0x74(%eax),%edx
  800095:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800098:	39 c2                	cmp    %eax,%edx
  80009a:	77 cb                	ja     800067 <_main+0x2f>
		{
			if (myEnv->__uptr_pws[j].empty==1)
				initNumOfEmptyWSEntries++;
		}

		freeFrames = sys_calculate_free_frames() ;
  80009c:	e8 72 14 00 00       	call   801513 <sys_calculate_free_frames>
  8000a1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;
  8000a4:	e8 0a 15 00 00       	call   8015b3 <sys_pf_calculate_allocated_pages>
  8000a9:	89 45 d0             	mov    %eax,-0x30(%ebp)

		res = RecursiveFn(numOfRec);
  8000ac:	83 ec 0c             	sub    $0xc,%esp
  8000af:	ff 75 d8             	pushl  -0x28(%ebp)
  8000b2:	e8 7c 01 00 00       	call   800233 <RecursiveFn>
  8000b7:	83 c4 10             	add    $0x10,%esp
  8000ba:	89 45 cc             	mov    %eax,-0x34(%ebp)
		env_sleep(1) ;
  8000bd:	83 ec 0c             	sub    $0xc,%esp
  8000c0:	6a 01                	push   $0x1
  8000c2:	e8 be 19 00 00       	call   801a85 <env_sleep>
  8000c7:	83 c4 10             	add    $0x10,%esp
		expectedResult = 0;
  8000ca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
		for (i = 1; i <= numOfRec; ++i) {
  8000d1:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
  8000d8:	eb 0c                	jmp    8000e6 <_main+0xae>
			expectedResult += i * 1024;
  8000da:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000dd:	c1 e0 0a             	shl    $0xa,%eax
  8000e0:	01 45 f4             	add    %eax,-0xc(%ebp)
		usedDiskPages = sys_pf_calculate_allocated_pages() ;

		res = RecursiveFn(numOfRec);
		env_sleep(1) ;
		expectedResult = 0;
		for (i = 1; i <= numOfRec; ++i) {
  8000e3:	ff 45 ec             	incl   -0x14(%ebp)
  8000e6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8000e9:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8000ec:	7e ec                	jle    8000da <_main+0xa2>
			expectedResult += i * 1024;
		}
		//check correct answer & page file
		if (res != expectedResult) panic("Wrong result of the recursive function!\n");
  8000ee:	8b 45 cc             	mov    -0x34(%ebp),%eax
  8000f1:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  8000f4:	74 14                	je     80010a <_main+0xd2>
  8000f6:	83 ec 04             	sub    $0x4,%esp
  8000f9:	68 a0 1d 80 00       	push   $0x801da0
  8000fe:	6a 28                	push   $0x28
  800100:	68 c9 1d 80 00       	push   $0x801dc9
  800105:	e8 df 02 00 00       	call   8003e9 <_panic>
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong freeing the stack pages from the page file!\n");
  80010a:	e8 a4 14 00 00       	call   8015b3 <sys_pf_calculate_allocated_pages>
  80010f:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  800112:	74 14                	je     800128 <_main+0xf0>
  800114:	83 ec 04             	sub    $0x4,%esp
  800117:	68 e4 1d 80 00       	push   $0x801de4
  80011c:	6a 29                	push   $0x29
  80011e:	68 c9 1d 80 00       	push   $0x801dc9
  800123:	e8 c1 02 00 00       	call   8003e9 <_panic>

		//check WS
		for (i = 1; i <= numOfRec; ++i)
  800128:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
  80012f:	eb 6b                	jmp    80019c <_main+0x164>
		{
			for (j = 0; j < myEnv->page_WS_max_size; ++j)
  800131:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  800138:	eb 50                	jmp    80018a <_main+0x152>
			{
				if (ROUNDDOWN(myEnv->__uptr_pws[j].virtual_address, PAGE_SIZE) == vaOf1stStackPage - i*PAGE_SIZE)
  80013a:	a1 20 30 80 00       	mov    0x803020,%eax
  80013f:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800145:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800148:	89 d0                	mov    %edx,%eax
  80014a:	01 c0                	add    %eax,%eax
  80014c:	01 d0                	add    %edx,%eax
  80014e:	c1 e0 03             	shl    $0x3,%eax
  800151:	01 c8                	add    %ecx,%eax
  800153:	8b 00                	mov    (%eax),%eax
  800155:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800158:	8b 45 c8             	mov    -0x38(%ebp),%eax
  80015b:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800160:	89 c2                	mov    %eax,%edx
  800162:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800165:	c1 e0 0c             	shl    $0xc,%eax
  800168:	89 c1                	mov    %eax,%ecx
  80016a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80016d:	29 c8                	sub    %ecx,%eax
  80016f:	39 c2                	cmp    %eax,%edx
  800171:	75 14                	jne    800187 <_main+0x14f>
					panic("Wrong freeing the stack pages from the working set!\n");
  800173:	83 ec 04             	sub    $0x4,%esp
  800176:	68 18 1e 80 00       	push   $0x801e18
  80017b:	6a 31                	push   $0x31
  80017d:	68 c9 1d 80 00       	push   $0x801dc9
  800182:	e8 62 02 00 00       	call   8003e9 <_panic>
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong freeing the stack pages from the page file!\n");

		//check WS
		for (i = 1; i <= numOfRec; ++i)
		{
			for (j = 0; j < myEnv->page_WS_max_size; ++j)
  800187:	ff 45 e8             	incl   -0x18(%ebp)
  80018a:	a1 20 30 80 00       	mov    0x803020,%eax
  80018f:	8b 50 74             	mov    0x74(%eax),%edx
  800192:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800195:	39 c2                	cmp    %eax,%edx
  800197:	77 a1                	ja     80013a <_main+0x102>
		//check correct answer & page file
		if (res != expectedResult) panic("Wrong result of the recursive function!\n");
		if ((usedDiskPages - sys_pf_calculate_allocated_pages()) != 0) panic("Wrong freeing the stack pages from the page file!\n");

		//check WS
		for (i = 1; i <= numOfRec; ++i)
  800199:	ff 45 ec             	incl   -0x14(%ebp)
  80019c:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80019f:	3b 45 d8             	cmp    -0x28(%ebp),%eax
  8001a2:	7e 8d                	jle    800131 <_main+0xf9>
					panic("Wrong freeing the stack pages from the working set!\n");
			}
		}

		//check free frames
		curNumOfEmptyWSEntries = 0;
  8001a4:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
		for (j = 0; j < myEnv->page_WS_max_size; ++j)
  8001ab:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8001b2:	eb 26                	jmp    8001da <_main+0x1a2>
		{
			if (myEnv->__uptr_pws[j].empty==1)
  8001b4:	a1 20 30 80 00       	mov    0x803020,%eax
  8001b9:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8001bf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8001c2:	89 d0                	mov    %edx,%eax
  8001c4:	01 c0                	add    %eax,%eax
  8001c6:	01 d0                	add    %edx,%eax
  8001c8:	c1 e0 03             	shl    $0x3,%eax
  8001cb:	01 c8                	add    %ecx,%eax
  8001cd:	8a 40 04             	mov    0x4(%eax),%al
  8001d0:	3c 01                	cmp    $0x1,%al
  8001d2:	75 03                	jne    8001d7 <_main+0x19f>
				curNumOfEmptyWSEntries++;
  8001d4:	ff 45 e0             	incl   -0x20(%ebp)
			}
		}

		//check free frames
		curNumOfEmptyWSEntries = 0;
		for (j = 0; j < myEnv->page_WS_max_size; ++j)
  8001d7:	ff 45 e8             	incl   -0x18(%ebp)
  8001da:	a1 20 30 80 00       	mov    0x803020,%eax
  8001df:	8b 50 74             	mov    0x74(%eax),%edx
  8001e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001e5:	39 c2                	cmp    %eax,%edx
  8001e7:	77 cb                	ja     8001b4 <_main+0x17c>
			if (myEnv->__uptr_pws[j].empty==1)
				curNumOfEmptyWSEntries++;
		}

		//cprintf("diff in RAM = %d\n", sys_calculate_free_frames() - freeFrames);
		if ((sys_calculate_free_frames() - freeFrames) != curNumOfEmptyWSEntries - initNumOfEmptyWSEntries)
  8001e9:	e8 25 13 00 00       	call   801513 <sys_calculate_free_frames>
  8001ee:	89 c2                	mov    %eax,%edx
  8001f0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  8001f3:	29 c2                	sub    %eax,%edx
  8001f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8001f8:	2b 45 e4             	sub    -0x1c(%ebp),%eax
  8001fb:	39 c2                	cmp    %eax,%edx
  8001fd:	74 14                	je     800213 <_main+0x1db>
			panic("Wrong freeing the stack pages from memory!\n");
  8001ff:	83 ec 04             	sub    $0x4,%esp
  800202:	68 50 1e 80 00       	push   $0x801e50
  800207:	6a 3f                	push   $0x3f
  800209:	68 c9 1d 80 00       	push   $0x801dc9
  80020e:	e8 d6 01 00 00       	call   8003e9 <_panic>
	uint32 vaOf1stStackPage = USTACKTOP - PAGE_SIZE;

	int initNumOfEmptyWSEntries, curNumOfEmptyWSEntries ;

	/*Different number of recursive calls (each call takes 1 PAGE)*/
	for (r = 1; r <= 10; ++r)
  800213:	ff 45 f0             	incl   -0x10(%ebp)
  800216:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  80021a:	0f 8e 31 fe ff ff    	jle    800051 <_main+0x19>
		//cprintf("diff in RAM = %d\n", sys_calculate_free_frames() - freeFrames);
		if ((sys_calculate_free_frames() - freeFrames) != curNumOfEmptyWSEntries - initNumOfEmptyWSEntries)
			panic("Wrong freeing the stack pages from memory!\n");
	}

	cprintf("Congratulations!! test freeing the stack pages is completed successfully.\n");
  800220:	83 ec 0c             	sub    $0xc,%esp
  800223:	68 7c 1e 80 00       	push   $0x801e7c
  800228:	e8 70 04 00 00       	call   80069d <cprintf>
  80022d:	83 c4 10             	add    $0x10,%esp

	return;
  800230:	90                   	nop
}
  800231:	c9                   	leave  
  800232:	c3                   	ret    

00800233 <RecursiveFn>:

int RecursiveFn(int numOfRec)
{
  800233:	55                   	push   %ebp
  800234:	89 e5                	mov    %esp,%ebp
  800236:	81 ec 18 10 00 00    	sub    $0x1018,%esp
	if (numOfRec == 0)
  80023c:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800240:	75 07                	jne    800249 <RecursiveFn+0x16>
		return 0;
  800242:	b8 00 00 00 00       	mov    $0x0,%eax
  800247:	eb 62                	jmp    8002ab <RecursiveFn+0x78>

	int A[1024] ;
	int i, sum = 0 ;
  800249:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	for (i = 0; i < 1024; ++i) {
  800250:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800257:	eb 10                	jmp    800269 <RecursiveFn+0x36>
		A[i] = numOfRec;
  800259:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80025c:	8b 55 08             	mov    0x8(%ebp),%edx
  80025f:	89 94 85 f0 ef ff ff 	mov    %edx,-0x1010(%ebp,%eax,4)
	if (numOfRec == 0)
		return 0;

	int A[1024] ;
	int i, sum = 0 ;
	for (i = 0; i < 1024; ++i) {
  800266:	ff 45 f4             	incl   -0xc(%ebp)
  800269:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
  800270:	7e e7                	jle    800259 <RecursiveFn+0x26>
		A[i] = numOfRec;
	}
	for (i = 0; i < 1024; ++i) {
  800272:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  800279:	eb 10                	jmp    80028b <RecursiveFn+0x58>
		sum += A[i] ;
  80027b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80027e:	8b 84 85 f0 ef ff ff 	mov    -0x1010(%ebp,%eax,4),%eax
  800285:	01 45 f0             	add    %eax,-0x10(%ebp)
	int A[1024] ;
	int i, sum = 0 ;
	for (i = 0; i < 1024; ++i) {
		A[i] = numOfRec;
	}
	for (i = 0; i < 1024; ++i) {
  800288:	ff 45 f4             	incl   -0xc(%ebp)
  80028b:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
  800292:	7e e7                	jle    80027b <RecursiveFn+0x48>
		sum += A[i] ;
	}
	return sum + RecursiveFn(numOfRec-1);
  800294:	8b 45 08             	mov    0x8(%ebp),%eax
  800297:	48                   	dec    %eax
  800298:	83 ec 0c             	sub    $0xc,%esp
  80029b:	50                   	push   %eax
  80029c:	e8 92 ff ff ff       	call   800233 <RecursiveFn>
  8002a1:	83 c4 10             	add    $0x10,%esp
  8002a4:	89 c2                	mov    %eax,%edx
  8002a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8002a9:	01 d0                	add    %edx,%eax
}
  8002ab:	c9                   	leave  
  8002ac:	c3                   	ret    

008002ad <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8002ad:	55                   	push   %ebp
  8002ae:	89 e5                	mov    %esp,%ebp
  8002b0:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8002b3:	e8 3b 15 00 00       	call   8017f3 <sys_getenvindex>
  8002b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8002bb:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8002be:	89 d0                	mov    %edx,%eax
  8002c0:	c1 e0 03             	shl    $0x3,%eax
  8002c3:	01 d0                	add    %edx,%eax
  8002c5:	01 c0                	add    %eax,%eax
  8002c7:	01 d0                	add    %edx,%eax
  8002c9:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8002d0:	01 d0                	add    %edx,%eax
  8002d2:	c1 e0 04             	shl    $0x4,%eax
  8002d5:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8002da:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8002df:	a1 20 30 80 00       	mov    0x803020,%eax
  8002e4:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8002ea:	84 c0                	test   %al,%al
  8002ec:	74 0f                	je     8002fd <libmain+0x50>
		binaryname = myEnv->prog_name;
  8002ee:	a1 20 30 80 00       	mov    0x803020,%eax
  8002f3:	05 5c 05 00 00       	add    $0x55c,%eax
  8002f8:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8002fd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800301:	7e 0a                	jle    80030d <libmain+0x60>
		binaryname = argv[0];
  800303:	8b 45 0c             	mov    0xc(%ebp),%eax
  800306:	8b 00                	mov    (%eax),%eax
  800308:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  80030d:	83 ec 08             	sub    $0x8,%esp
  800310:	ff 75 0c             	pushl  0xc(%ebp)
  800313:	ff 75 08             	pushl  0x8(%ebp)
  800316:	e8 1d fd ff ff       	call   800038 <_main>
  80031b:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80031e:	e8 dd 12 00 00       	call   801600 <sys_disable_interrupt>
	cprintf("**************************************\n");
  800323:	83 ec 0c             	sub    $0xc,%esp
  800326:	68 e0 1e 80 00       	push   $0x801ee0
  80032b:	e8 6d 03 00 00       	call   80069d <cprintf>
  800330:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800333:	a1 20 30 80 00       	mov    0x803020,%eax
  800338:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  80033e:	a1 20 30 80 00       	mov    0x803020,%eax
  800343:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800349:	83 ec 04             	sub    $0x4,%esp
  80034c:	52                   	push   %edx
  80034d:	50                   	push   %eax
  80034e:	68 08 1f 80 00       	push   $0x801f08
  800353:	e8 45 03 00 00       	call   80069d <cprintf>
  800358:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80035b:	a1 20 30 80 00       	mov    0x803020,%eax
  800360:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800366:	a1 20 30 80 00       	mov    0x803020,%eax
  80036b:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800371:	a1 20 30 80 00       	mov    0x803020,%eax
  800376:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  80037c:	51                   	push   %ecx
  80037d:	52                   	push   %edx
  80037e:	50                   	push   %eax
  80037f:	68 30 1f 80 00       	push   $0x801f30
  800384:	e8 14 03 00 00       	call   80069d <cprintf>
  800389:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80038c:	a1 20 30 80 00       	mov    0x803020,%eax
  800391:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800397:	83 ec 08             	sub    $0x8,%esp
  80039a:	50                   	push   %eax
  80039b:	68 88 1f 80 00       	push   $0x801f88
  8003a0:	e8 f8 02 00 00       	call   80069d <cprintf>
  8003a5:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8003a8:	83 ec 0c             	sub    $0xc,%esp
  8003ab:	68 e0 1e 80 00       	push   $0x801ee0
  8003b0:	e8 e8 02 00 00       	call   80069d <cprintf>
  8003b5:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8003b8:	e8 5d 12 00 00       	call   80161a <sys_enable_interrupt>

	// exit gracefully
	exit();
  8003bd:	e8 19 00 00 00       	call   8003db <exit>
}
  8003c2:	90                   	nop
  8003c3:	c9                   	leave  
  8003c4:	c3                   	ret    

008003c5 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8003c5:	55                   	push   %ebp
  8003c6:	89 e5                	mov    %esp,%ebp
  8003c8:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8003cb:	83 ec 0c             	sub    $0xc,%esp
  8003ce:	6a 00                	push   $0x0
  8003d0:	e8 ea 13 00 00       	call   8017bf <sys_destroy_env>
  8003d5:	83 c4 10             	add    $0x10,%esp
}
  8003d8:	90                   	nop
  8003d9:	c9                   	leave  
  8003da:	c3                   	ret    

008003db <exit>:

void
exit(void)
{
  8003db:	55                   	push   %ebp
  8003dc:	89 e5                	mov    %esp,%ebp
  8003de:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8003e1:	e8 3f 14 00 00       	call   801825 <sys_exit_env>
}
  8003e6:	90                   	nop
  8003e7:	c9                   	leave  
  8003e8:	c3                   	ret    

008003e9 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8003e9:	55                   	push   %ebp
  8003ea:	89 e5                	mov    %esp,%ebp
  8003ec:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8003ef:	8d 45 10             	lea    0x10(%ebp),%eax
  8003f2:	83 c0 04             	add    $0x4,%eax
  8003f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8003f8:	a1 5c 31 80 00       	mov    0x80315c,%eax
  8003fd:	85 c0                	test   %eax,%eax
  8003ff:	74 16                	je     800417 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800401:	a1 5c 31 80 00       	mov    0x80315c,%eax
  800406:	83 ec 08             	sub    $0x8,%esp
  800409:	50                   	push   %eax
  80040a:	68 9c 1f 80 00       	push   $0x801f9c
  80040f:	e8 89 02 00 00       	call   80069d <cprintf>
  800414:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800417:	a1 00 30 80 00       	mov    0x803000,%eax
  80041c:	ff 75 0c             	pushl  0xc(%ebp)
  80041f:	ff 75 08             	pushl  0x8(%ebp)
  800422:	50                   	push   %eax
  800423:	68 a1 1f 80 00       	push   $0x801fa1
  800428:	e8 70 02 00 00       	call   80069d <cprintf>
  80042d:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  800430:	8b 45 10             	mov    0x10(%ebp),%eax
  800433:	83 ec 08             	sub    $0x8,%esp
  800436:	ff 75 f4             	pushl  -0xc(%ebp)
  800439:	50                   	push   %eax
  80043a:	e8 f3 01 00 00       	call   800632 <vcprintf>
  80043f:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800442:	83 ec 08             	sub    $0x8,%esp
  800445:	6a 00                	push   $0x0
  800447:	68 bd 1f 80 00       	push   $0x801fbd
  80044c:	e8 e1 01 00 00       	call   800632 <vcprintf>
  800451:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800454:	e8 82 ff ff ff       	call   8003db <exit>

	// should not return here
	while (1) ;
  800459:	eb fe                	jmp    800459 <_panic+0x70>

0080045b <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80045b:	55                   	push   %ebp
  80045c:	89 e5                	mov    %esp,%ebp
  80045e:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800461:	a1 20 30 80 00       	mov    0x803020,%eax
  800466:	8b 50 74             	mov    0x74(%eax),%edx
  800469:	8b 45 0c             	mov    0xc(%ebp),%eax
  80046c:	39 c2                	cmp    %eax,%edx
  80046e:	74 14                	je     800484 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  800470:	83 ec 04             	sub    $0x4,%esp
  800473:	68 c0 1f 80 00       	push   $0x801fc0
  800478:	6a 26                	push   $0x26
  80047a:	68 0c 20 80 00       	push   $0x80200c
  80047f:	e8 65 ff ff ff       	call   8003e9 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800484:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80048b:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800492:	e9 c2 00 00 00       	jmp    800559 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800497:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80049a:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8004a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8004a4:	01 d0                	add    %edx,%eax
  8004a6:	8b 00                	mov    (%eax),%eax
  8004a8:	85 c0                	test   %eax,%eax
  8004aa:	75 08                	jne    8004b4 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8004ac:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8004af:	e9 a2 00 00 00       	jmp    800556 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8004b4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8004bb:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8004c2:	eb 69                	jmp    80052d <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8004c4:	a1 20 30 80 00       	mov    0x803020,%eax
  8004c9:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8004cf:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8004d2:	89 d0                	mov    %edx,%eax
  8004d4:	01 c0                	add    %eax,%eax
  8004d6:	01 d0                	add    %edx,%eax
  8004d8:	c1 e0 03             	shl    $0x3,%eax
  8004db:	01 c8                	add    %ecx,%eax
  8004dd:	8a 40 04             	mov    0x4(%eax),%al
  8004e0:	84 c0                	test   %al,%al
  8004e2:	75 46                	jne    80052a <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8004e4:	a1 20 30 80 00       	mov    0x803020,%eax
  8004e9:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8004ef:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8004f2:	89 d0                	mov    %edx,%eax
  8004f4:	01 c0                	add    %eax,%eax
  8004f6:	01 d0                	add    %edx,%eax
  8004f8:	c1 e0 03             	shl    $0x3,%eax
  8004fb:	01 c8                	add    %ecx,%eax
  8004fd:	8b 00                	mov    (%eax),%eax
  8004ff:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800502:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800505:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  80050a:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80050c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80050f:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800516:	8b 45 08             	mov    0x8(%ebp),%eax
  800519:	01 c8                	add    %ecx,%eax
  80051b:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80051d:	39 c2                	cmp    %eax,%edx
  80051f:	75 09                	jne    80052a <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800521:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800528:	eb 12                	jmp    80053c <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80052a:	ff 45 e8             	incl   -0x18(%ebp)
  80052d:	a1 20 30 80 00       	mov    0x803020,%eax
  800532:	8b 50 74             	mov    0x74(%eax),%edx
  800535:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800538:	39 c2                	cmp    %eax,%edx
  80053a:	77 88                	ja     8004c4 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80053c:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  800540:	75 14                	jne    800556 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800542:	83 ec 04             	sub    $0x4,%esp
  800545:	68 18 20 80 00       	push   $0x802018
  80054a:	6a 3a                	push   $0x3a
  80054c:	68 0c 20 80 00       	push   $0x80200c
  800551:	e8 93 fe ff ff       	call   8003e9 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800556:	ff 45 f0             	incl   -0x10(%ebp)
  800559:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80055c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80055f:	0f 8c 32 ff ff ff    	jl     800497 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800565:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80056c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800573:	eb 26                	jmp    80059b <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800575:	a1 20 30 80 00       	mov    0x803020,%eax
  80057a:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  800580:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800583:	89 d0                	mov    %edx,%eax
  800585:	01 c0                	add    %eax,%eax
  800587:	01 d0                	add    %edx,%eax
  800589:	c1 e0 03             	shl    $0x3,%eax
  80058c:	01 c8                	add    %ecx,%eax
  80058e:	8a 40 04             	mov    0x4(%eax),%al
  800591:	3c 01                	cmp    $0x1,%al
  800593:	75 03                	jne    800598 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800595:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800598:	ff 45 e0             	incl   -0x20(%ebp)
  80059b:	a1 20 30 80 00       	mov    0x803020,%eax
  8005a0:	8b 50 74             	mov    0x74(%eax),%edx
  8005a3:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8005a6:	39 c2                	cmp    %eax,%edx
  8005a8:	77 cb                	ja     800575 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8005aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005ad:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8005b0:	74 14                	je     8005c6 <CheckWSWithoutLastIndex+0x16b>
		panic(
  8005b2:	83 ec 04             	sub    $0x4,%esp
  8005b5:	68 6c 20 80 00       	push   $0x80206c
  8005ba:	6a 44                	push   $0x44
  8005bc:	68 0c 20 80 00       	push   $0x80200c
  8005c1:	e8 23 fe ff ff       	call   8003e9 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8005c6:	90                   	nop
  8005c7:	c9                   	leave  
  8005c8:	c3                   	ret    

008005c9 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8005c9:	55                   	push   %ebp
  8005ca:	89 e5                	mov    %esp,%ebp
  8005cc:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8005cf:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005d2:	8b 00                	mov    (%eax),%eax
  8005d4:	8d 48 01             	lea    0x1(%eax),%ecx
  8005d7:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005da:	89 0a                	mov    %ecx,(%edx)
  8005dc:	8b 55 08             	mov    0x8(%ebp),%edx
  8005df:	88 d1                	mov    %dl,%cl
  8005e1:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005e4:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8005e8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005eb:	8b 00                	mov    (%eax),%eax
  8005ed:	3d ff 00 00 00       	cmp    $0xff,%eax
  8005f2:	75 2c                	jne    800620 <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8005f4:	a0 24 30 80 00       	mov    0x803024,%al
  8005f9:	0f b6 c0             	movzbl %al,%eax
  8005fc:	8b 55 0c             	mov    0xc(%ebp),%edx
  8005ff:	8b 12                	mov    (%edx),%edx
  800601:	89 d1                	mov    %edx,%ecx
  800603:	8b 55 0c             	mov    0xc(%ebp),%edx
  800606:	83 c2 08             	add    $0x8,%edx
  800609:	83 ec 04             	sub    $0x4,%esp
  80060c:	50                   	push   %eax
  80060d:	51                   	push   %ecx
  80060e:	52                   	push   %edx
  80060f:	e8 3e 0e 00 00       	call   801452 <sys_cputs>
  800614:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800617:	8b 45 0c             	mov    0xc(%ebp),%eax
  80061a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  800620:	8b 45 0c             	mov    0xc(%ebp),%eax
  800623:	8b 40 04             	mov    0x4(%eax),%eax
  800626:	8d 50 01             	lea    0x1(%eax),%edx
  800629:	8b 45 0c             	mov    0xc(%ebp),%eax
  80062c:	89 50 04             	mov    %edx,0x4(%eax)
}
  80062f:	90                   	nop
  800630:	c9                   	leave  
  800631:	c3                   	ret    

00800632 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800632:	55                   	push   %ebp
  800633:	89 e5                	mov    %esp,%ebp
  800635:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80063b:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800642:	00 00 00 
	b.cnt = 0;
  800645:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80064c:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80064f:	ff 75 0c             	pushl  0xc(%ebp)
  800652:	ff 75 08             	pushl  0x8(%ebp)
  800655:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80065b:	50                   	push   %eax
  80065c:	68 c9 05 80 00       	push   $0x8005c9
  800661:	e8 11 02 00 00       	call   800877 <vprintfmt>
  800666:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800669:	a0 24 30 80 00       	mov    0x803024,%al
  80066e:	0f b6 c0             	movzbl %al,%eax
  800671:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800677:	83 ec 04             	sub    $0x4,%esp
  80067a:	50                   	push   %eax
  80067b:	52                   	push   %edx
  80067c:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800682:	83 c0 08             	add    $0x8,%eax
  800685:	50                   	push   %eax
  800686:	e8 c7 0d 00 00       	call   801452 <sys_cputs>
  80068b:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80068e:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  800695:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80069b:	c9                   	leave  
  80069c:	c3                   	ret    

0080069d <cprintf>:

int cprintf(const char *fmt, ...) {
  80069d:	55                   	push   %ebp
  80069e:	89 e5                	mov    %esp,%ebp
  8006a0:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8006a3:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  8006aa:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006ad:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8006b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8006b3:	83 ec 08             	sub    $0x8,%esp
  8006b6:	ff 75 f4             	pushl  -0xc(%ebp)
  8006b9:	50                   	push   %eax
  8006ba:	e8 73 ff ff ff       	call   800632 <vcprintf>
  8006bf:	83 c4 10             	add    $0x10,%esp
  8006c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8006c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006c8:	c9                   	leave  
  8006c9:	c3                   	ret    

008006ca <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8006ca:	55                   	push   %ebp
  8006cb:	89 e5                	mov    %esp,%ebp
  8006cd:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8006d0:	e8 2b 0f 00 00       	call   801600 <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8006d5:	8d 45 0c             	lea    0xc(%ebp),%eax
  8006d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8006db:	8b 45 08             	mov    0x8(%ebp),%eax
  8006de:	83 ec 08             	sub    $0x8,%esp
  8006e1:	ff 75 f4             	pushl  -0xc(%ebp)
  8006e4:	50                   	push   %eax
  8006e5:	e8 48 ff ff ff       	call   800632 <vcprintf>
  8006ea:	83 c4 10             	add    $0x10,%esp
  8006ed:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8006f0:	e8 25 0f 00 00       	call   80161a <sys_enable_interrupt>
	return cnt;
  8006f5:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8006f8:	c9                   	leave  
  8006f9:	c3                   	ret    

008006fa <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8006fa:	55                   	push   %ebp
  8006fb:	89 e5                	mov    %esp,%ebp
  8006fd:	53                   	push   %ebx
  8006fe:	83 ec 14             	sub    $0x14,%esp
  800701:	8b 45 10             	mov    0x10(%ebp),%eax
  800704:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800707:	8b 45 14             	mov    0x14(%ebp),%eax
  80070a:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80070d:	8b 45 18             	mov    0x18(%ebp),%eax
  800710:	ba 00 00 00 00       	mov    $0x0,%edx
  800715:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800718:	77 55                	ja     80076f <printnum+0x75>
  80071a:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80071d:	72 05                	jb     800724 <printnum+0x2a>
  80071f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800722:	77 4b                	ja     80076f <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800724:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800727:	8d 58 ff             	lea    -0x1(%eax),%ebx
  80072a:	8b 45 18             	mov    0x18(%ebp),%eax
  80072d:	ba 00 00 00 00       	mov    $0x0,%edx
  800732:	52                   	push   %edx
  800733:	50                   	push   %eax
  800734:	ff 75 f4             	pushl  -0xc(%ebp)
  800737:	ff 75 f0             	pushl  -0x10(%ebp)
  80073a:	e8 fd 13 00 00       	call   801b3c <__udivdi3>
  80073f:	83 c4 10             	add    $0x10,%esp
  800742:	83 ec 04             	sub    $0x4,%esp
  800745:	ff 75 20             	pushl  0x20(%ebp)
  800748:	53                   	push   %ebx
  800749:	ff 75 18             	pushl  0x18(%ebp)
  80074c:	52                   	push   %edx
  80074d:	50                   	push   %eax
  80074e:	ff 75 0c             	pushl  0xc(%ebp)
  800751:	ff 75 08             	pushl  0x8(%ebp)
  800754:	e8 a1 ff ff ff       	call   8006fa <printnum>
  800759:	83 c4 20             	add    $0x20,%esp
  80075c:	eb 1a                	jmp    800778 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80075e:	83 ec 08             	sub    $0x8,%esp
  800761:	ff 75 0c             	pushl  0xc(%ebp)
  800764:	ff 75 20             	pushl  0x20(%ebp)
  800767:	8b 45 08             	mov    0x8(%ebp),%eax
  80076a:	ff d0                	call   *%eax
  80076c:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80076f:	ff 4d 1c             	decl   0x1c(%ebp)
  800772:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800776:	7f e6                	jg     80075e <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800778:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80077b:	bb 00 00 00 00       	mov    $0x0,%ebx
  800780:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800783:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800786:	53                   	push   %ebx
  800787:	51                   	push   %ecx
  800788:	52                   	push   %edx
  800789:	50                   	push   %eax
  80078a:	e8 bd 14 00 00       	call   801c4c <__umoddi3>
  80078f:	83 c4 10             	add    $0x10,%esp
  800792:	05 d4 22 80 00       	add    $0x8022d4,%eax
  800797:	8a 00                	mov    (%eax),%al
  800799:	0f be c0             	movsbl %al,%eax
  80079c:	83 ec 08             	sub    $0x8,%esp
  80079f:	ff 75 0c             	pushl  0xc(%ebp)
  8007a2:	50                   	push   %eax
  8007a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8007a6:	ff d0                	call   *%eax
  8007a8:	83 c4 10             	add    $0x10,%esp
}
  8007ab:	90                   	nop
  8007ac:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8007af:	c9                   	leave  
  8007b0:	c3                   	ret    

008007b1 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8007b1:	55                   	push   %ebp
  8007b2:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8007b4:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8007b8:	7e 1c                	jle    8007d6 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8007ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8007bd:	8b 00                	mov    (%eax),%eax
  8007bf:	8d 50 08             	lea    0x8(%eax),%edx
  8007c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c5:	89 10                	mov    %edx,(%eax)
  8007c7:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ca:	8b 00                	mov    (%eax),%eax
  8007cc:	83 e8 08             	sub    $0x8,%eax
  8007cf:	8b 50 04             	mov    0x4(%eax),%edx
  8007d2:	8b 00                	mov    (%eax),%eax
  8007d4:	eb 40                	jmp    800816 <getuint+0x65>
	else if (lflag)
  8007d6:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8007da:	74 1e                	je     8007fa <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8007dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007df:	8b 00                	mov    (%eax),%eax
  8007e1:	8d 50 04             	lea    0x4(%eax),%edx
  8007e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e7:	89 10                	mov    %edx,(%eax)
  8007e9:	8b 45 08             	mov    0x8(%ebp),%eax
  8007ec:	8b 00                	mov    (%eax),%eax
  8007ee:	83 e8 04             	sub    $0x4,%eax
  8007f1:	8b 00                	mov    (%eax),%eax
  8007f3:	ba 00 00 00 00       	mov    $0x0,%edx
  8007f8:	eb 1c                	jmp    800816 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8007fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8007fd:	8b 00                	mov    (%eax),%eax
  8007ff:	8d 50 04             	lea    0x4(%eax),%edx
  800802:	8b 45 08             	mov    0x8(%ebp),%eax
  800805:	89 10                	mov    %edx,(%eax)
  800807:	8b 45 08             	mov    0x8(%ebp),%eax
  80080a:	8b 00                	mov    (%eax),%eax
  80080c:	83 e8 04             	sub    $0x4,%eax
  80080f:	8b 00                	mov    (%eax),%eax
  800811:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800816:	5d                   	pop    %ebp
  800817:	c3                   	ret    

00800818 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800818:	55                   	push   %ebp
  800819:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80081b:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80081f:	7e 1c                	jle    80083d <getint+0x25>
		return va_arg(*ap, long long);
  800821:	8b 45 08             	mov    0x8(%ebp),%eax
  800824:	8b 00                	mov    (%eax),%eax
  800826:	8d 50 08             	lea    0x8(%eax),%edx
  800829:	8b 45 08             	mov    0x8(%ebp),%eax
  80082c:	89 10                	mov    %edx,(%eax)
  80082e:	8b 45 08             	mov    0x8(%ebp),%eax
  800831:	8b 00                	mov    (%eax),%eax
  800833:	83 e8 08             	sub    $0x8,%eax
  800836:	8b 50 04             	mov    0x4(%eax),%edx
  800839:	8b 00                	mov    (%eax),%eax
  80083b:	eb 38                	jmp    800875 <getint+0x5d>
	else if (lflag)
  80083d:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800841:	74 1a                	je     80085d <getint+0x45>
		return va_arg(*ap, long);
  800843:	8b 45 08             	mov    0x8(%ebp),%eax
  800846:	8b 00                	mov    (%eax),%eax
  800848:	8d 50 04             	lea    0x4(%eax),%edx
  80084b:	8b 45 08             	mov    0x8(%ebp),%eax
  80084e:	89 10                	mov    %edx,(%eax)
  800850:	8b 45 08             	mov    0x8(%ebp),%eax
  800853:	8b 00                	mov    (%eax),%eax
  800855:	83 e8 04             	sub    $0x4,%eax
  800858:	8b 00                	mov    (%eax),%eax
  80085a:	99                   	cltd   
  80085b:	eb 18                	jmp    800875 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80085d:	8b 45 08             	mov    0x8(%ebp),%eax
  800860:	8b 00                	mov    (%eax),%eax
  800862:	8d 50 04             	lea    0x4(%eax),%edx
  800865:	8b 45 08             	mov    0x8(%ebp),%eax
  800868:	89 10                	mov    %edx,(%eax)
  80086a:	8b 45 08             	mov    0x8(%ebp),%eax
  80086d:	8b 00                	mov    (%eax),%eax
  80086f:	83 e8 04             	sub    $0x4,%eax
  800872:	8b 00                	mov    (%eax),%eax
  800874:	99                   	cltd   
}
  800875:	5d                   	pop    %ebp
  800876:	c3                   	ret    

00800877 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800877:	55                   	push   %ebp
  800878:	89 e5                	mov    %esp,%ebp
  80087a:	56                   	push   %esi
  80087b:	53                   	push   %ebx
  80087c:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80087f:	eb 17                	jmp    800898 <vprintfmt+0x21>
			if (ch == '\0')
  800881:	85 db                	test   %ebx,%ebx
  800883:	0f 84 af 03 00 00    	je     800c38 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800889:	83 ec 08             	sub    $0x8,%esp
  80088c:	ff 75 0c             	pushl  0xc(%ebp)
  80088f:	53                   	push   %ebx
  800890:	8b 45 08             	mov    0x8(%ebp),%eax
  800893:	ff d0                	call   *%eax
  800895:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800898:	8b 45 10             	mov    0x10(%ebp),%eax
  80089b:	8d 50 01             	lea    0x1(%eax),%edx
  80089e:	89 55 10             	mov    %edx,0x10(%ebp)
  8008a1:	8a 00                	mov    (%eax),%al
  8008a3:	0f b6 d8             	movzbl %al,%ebx
  8008a6:	83 fb 25             	cmp    $0x25,%ebx
  8008a9:	75 d6                	jne    800881 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8008ab:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8008af:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8008b6:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8008bd:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8008c4:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8008cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8008ce:	8d 50 01             	lea    0x1(%eax),%edx
  8008d1:	89 55 10             	mov    %edx,0x10(%ebp)
  8008d4:	8a 00                	mov    (%eax),%al
  8008d6:	0f b6 d8             	movzbl %al,%ebx
  8008d9:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8008dc:	83 f8 55             	cmp    $0x55,%eax
  8008df:	0f 87 2b 03 00 00    	ja     800c10 <vprintfmt+0x399>
  8008e5:	8b 04 85 f8 22 80 00 	mov    0x8022f8(,%eax,4),%eax
  8008ec:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8008ee:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8008f2:	eb d7                	jmp    8008cb <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8008f4:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8008f8:	eb d1                	jmp    8008cb <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8008fa:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800901:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800904:	89 d0                	mov    %edx,%eax
  800906:	c1 e0 02             	shl    $0x2,%eax
  800909:	01 d0                	add    %edx,%eax
  80090b:	01 c0                	add    %eax,%eax
  80090d:	01 d8                	add    %ebx,%eax
  80090f:	83 e8 30             	sub    $0x30,%eax
  800912:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800915:	8b 45 10             	mov    0x10(%ebp),%eax
  800918:	8a 00                	mov    (%eax),%al
  80091a:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  80091d:	83 fb 2f             	cmp    $0x2f,%ebx
  800920:	7e 3e                	jle    800960 <vprintfmt+0xe9>
  800922:	83 fb 39             	cmp    $0x39,%ebx
  800925:	7f 39                	jg     800960 <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800927:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  80092a:	eb d5                	jmp    800901 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  80092c:	8b 45 14             	mov    0x14(%ebp),%eax
  80092f:	83 c0 04             	add    $0x4,%eax
  800932:	89 45 14             	mov    %eax,0x14(%ebp)
  800935:	8b 45 14             	mov    0x14(%ebp),%eax
  800938:	83 e8 04             	sub    $0x4,%eax
  80093b:	8b 00                	mov    (%eax),%eax
  80093d:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800940:	eb 1f                	jmp    800961 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800942:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800946:	79 83                	jns    8008cb <vprintfmt+0x54>
				width = 0;
  800948:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  80094f:	e9 77 ff ff ff       	jmp    8008cb <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800954:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  80095b:	e9 6b ff ff ff       	jmp    8008cb <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800960:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800961:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800965:	0f 89 60 ff ff ff    	jns    8008cb <vprintfmt+0x54>
				width = precision, precision = -1;
  80096b:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80096e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800971:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800978:	e9 4e ff ff ff       	jmp    8008cb <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  80097d:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800980:	e9 46 ff ff ff       	jmp    8008cb <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800985:	8b 45 14             	mov    0x14(%ebp),%eax
  800988:	83 c0 04             	add    $0x4,%eax
  80098b:	89 45 14             	mov    %eax,0x14(%ebp)
  80098e:	8b 45 14             	mov    0x14(%ebp),%eax
  800991:	83 e8 04             	sub    $0x4,%eax
  800994:	8b 00                	mov    (%eax),%eax
  800996:	83 ec 08             	sub    $0x8,%esp
  800999:	ff 75 0c             	pushl  0xc(%ebp)
  80099c:	50                   	push   %eax
  80099d:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a0:	ff d0                	call   *%eax
  8009a2:	83 c4 10             	add    $0x10,%esp
			break;
  8009a5:	e9 89 02 00 00       	jmp    800c33 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  8009aa:	8b 45 14             	mov    0x14(%ebp),%eax
  8009ad:	83 c0 04             	add    $0x4,%eax
  8009b0:	89 45 14             	mov    %eax,0x14(%ebp)
  8009b3:	8b 45 14             	mov    0x14(%ebp),%eax
  8009b6:	83 e8 04             	sub    $0x4,%eax
  8009b9:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  8009bb:	85 db                	test   %ebx,%ebx
  8009bd:	79 02                	jns    8009c1 <vprintfmt+0x14a>
				err = -err;
  8009bf:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  8009c1:	83 fb 64             	cmp    $0x64,%ebx
  8009c4:	7f 0b                	jg     8009d1 <vprintfmt+0x15a>
  8009c6:	8b 34 9d 40 21 80 00 	mov    0x802140(,%ebx,4),%esi
  8009cd:	85 f6                	test   %esi,%esi
  8009cf:	75 19                	jne    8009ea <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  8009d1:	53                   	push   %ebx
  8009d2:	68 e5 22 80 00       	push   $0x8022e5
  8009d7:	ff 75 0c             	pushl  0xc(%ebp)
  8009da:	ff 75 08             	pushl  0x8(%ebp)
  8009dd:	e8 5e 02 00 00       	call   800c40 <printfmt>
  8009e2:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  8009e5:	e9 49 02 00 00       	jmp    800c33 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  8009ea:	56                   	push   %esi
  8009eb:	68 ee 22 80 00       	push   $0x8022ee
  8009f0:	ff 75 0c             	pushl  0xc(%ebp)
  8009f3:	ff 75 08             	pushl  0x8(%ebp)
  8009f6:	e8 45 02 00 00       	call   800c40 <printfmt>
  8009fb:	83 c4 10             	add    $0x10,%esp
			break;
  8009fe:	e9 30 02 00 00       	jmp    800c33 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800a03:	8b 45 14             	mov    0x14(%ebp),%eax
  800a06:	83 c0 04             	add    $0x4,%eax
  800a09:	89 45 14             	mov    %eax,0x14(%ebp)
  800a0c:	8b 45 14             	mov    0x14(%ebp),%eax
  800a0f:	83 e8 04             	sub    $0x4,%eax
  800a12:	8b 30                	mov    (%eax),%esi
  800a14:	85 f6                	test   %esi,%esi
  800a16:	75 05                	jne    800a1d <vprintfmt+0x1a6>
				p = "(null)";
  800a18:	be f1 22 80 00       	mov    $0x8022f1,%esi
			if (width > 0 && padc != '-')
  800a1d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a21:	7e 6d                	jle    800a90 <vprintfmt+0x219>
  800a23:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800a27:	74 67                	je     800a90 <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800a29:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a2c:	83 ec 08             	sub    $0x8,%esp
  800a2f:	50                   	push   %eax
  800a30:	56                   	push   %esi
  800a31:	e8 0c 03 00 00       	call   800d42 <strnlen>
  800a36:	83 c4 10             	add    $0x10,%esp
  800a39:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800a3c:	eb 16                	jmp    800a54 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800a3e:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800a42:	83 ec 08             	sub    $0x8,%esp
  800a45:	ff 75 0c             	pushl  0xc(%ebp)
  800a48:	50                   	push   %eax
  800a49:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4c:	ff d0                	call   *%eax
  800a4e:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800a51:	ff 4d e4             	decl   -0x1c(%ebp)
  800a54:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a58:	7f e4                	jg     800a3e <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a5a:	eb 34                	jmp    800a90 <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800a5c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800a60:	74 1c                	je     800a7e <vprintfmt+0x207>
  800a62:	83 fb 1f             	cmp    $0x1f,%ebx
  800a65:	7e 05                	jle    800a6c <vprintfmt+0x1f5>
  800a67:	83 fb 7e             	cmp    $0x7e,%ebx
  800a6a:	7e 12                	jle    800a7e <vprintfmt+0x207>
					putch('?', putdat);
  800a6c:	83 ec 08             	sub    $0x8,%esp
  800a6f:	ff 75 0c             	pushl  0xc(%ebp)
  800a72:	6a 3f                	push   $0x3f
  800a74:	8b 45 08             	mov    0x8(%ebp),%eax
  800a77:	ff d0                	call   *%eax
  800a79:	83 c4 10             	add    $0x10,%esp
  800a7c:	eb 0f                	jmp    800a8d <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800a7e:	83 ec 08             	sub    $0x8,%esp
  800a81:	ff 75 0c             	pushl  0xc(%ebp)
  800a84:	53                   	push   %ebx
  800a85:	8b 45 08             	mov    0x8(%ebp),%eax
  800a88:	ff d0                	call   *%eax
  800a8a:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800a8d:	ff 4d e4             	decl   -0x1c(%ebp)
  800a90:	89 f0                	mov    %esi,%eax
  800a92:	8d 70 01             	lea    0x1(%eax),%esi
  800a95:	8a 00                	mov    (%eax),%al
  800a97:	0f be d8             	movsbl %al,%ebx
  800a9a:	85 db                	test   %ebx,%ebx
  800a9c:	74 24                	je     800ac2 <vprintfmt+0x24b>
  800a9e:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800aa2:	78 b8                	js     800a5c <vprintfmt+0x1e5>
  800aa4:	ff 4d e0             	decl   -0x20(%ebp)
  800aa7:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800aab:	79 af                	jns    800a5c <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800aad:	eb 13                	jmp    800ac2 <vprintfmt+0x24b>
				putch(' ', putdat);
  800aaf:	83 ec 08             	sub    $0x8,%esp
  800ab2:	ff 75 0c             	pushl  0xc(%ebp)
  800ab5:	6a 20                	push   $0x20
  800ab7:	8b 45 08             	mov    0x8(%ebp),%eax
  800aba:	ff d0                	call   *%eax
  800abc:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800abf:	ff 4d e4             	decl   -0x1c(%ebp)
  800ac2:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800ac6:	7f e7                	jg     800aaf <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800ac8:	e9 66 01 00 00       	jmp    800c33 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800acd:	83 ec 08             	sub    $0x8,%esp
  800ad0:	ff 75 e8             	pushl  -0x18(%ebp)
  800ad3:	8d 45 14             	lea    0x14(%ebp),%eax
  800ad6:	50                   	push   %eax
  800ad7:	e8 3c fd ff ff       	call   800818 <getint>
  800adc:	83 c4 10             	add    $0x10,%esp
  800adf:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ae2:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800ae5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ae8:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800aeb:	85 d2                	test   %edx,%edx
  800aed:	79 23                	jns    800b12 <vprintfmt+0x29b>
				putch('-', putdat);
  800aef:	83 ec 08             	sub    $0x8,%esp
  800af2:	ff 75 0c             	pushl  0xc(%ebp)
  800af5:	6a 2d                	push   $0x2d
  800af7:	8b 45 08             	mov    0x8(%ebp),%eax
  800afa:	ff d0                	call   *%eax
  800afc:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800aff:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b02:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800b05:	f7 d8                	neg    %eax
  800b07:	83 d2 00             	adc    $0x0,%edx
  800b0a:	f7 da                	neg    %edx
  800b0c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b0f:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800b12:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b19:	e9 bc 00 00 00       	jmp    800bda <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800b1e:	83 ec 08             	sub    $0x8,%esp
  800b21:	ff 75 e8             	pushl  -0x18(%ebp)
  800b24:	8d 45 14             	lea    0x14(%ebp),%eax
  800b27:	50                   	push   %eax
  800b28:	e8 84 fc ff ff       	call   8007b1 <getuint>
  800b2d:	83 c4 10             	add    $0x10,%esp
  800b30:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800b33:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800b36:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800b3d:	e9 98 00 00 00       	jmp    800bda <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800b42:	83 ec 08             	sub    $0x8,%esp
  800b45:	ff 75 0c             	pushl  0xc(%ebp)
  800b48:	6a 58                	push   $0x58
  800b4a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4d:	ff d0                	call   *%eax
  800b4f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b52:	83 ec 08             	sub    $0x8,%esp
  800b55:	ff 75 0c             	pushl  0xc(%ebp)
  800b58:	6a 58                	push   $0x58
  800b5a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5d:	ff d0                	call   *%eax
  800b5f:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800b62:	83 ec 08             	sub    $0x8,%esp
  800b65:	ff 75 0c             	pushl  0xc(%ebp)
  800b68:	6a 58                	push   $0x58
  800b6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800b6d:	ff d0                	call   *%eax
  800b6f:	83 c4 10             	add    $0x10,%esp
			break;
  800b72:	e9 bc 00 00 00       	jmp    800c33 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800b77:	83 ec 08             	sub    $0x8,%esp
  800b7a:	ff 75 0c             	pushl  0xc(%ebp)
  800b7d:	6a 30                	push   $0x30
  800b7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b82:	ff d0                	call   *%eax
  800b84:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800b87:	83 ec 08             	sub    $0x8,%esp
  800b8a:	ff 75 0c             	pushl  0xc(%ebp)
  800b8d:	6a 78                	push   $0x78
  800b8f:	8b 45 08             	mov    0x8(%ebp),%eax
  800b92:	ff d0                	call   *%eax
  800b94:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800b97:	8b 45 14             	mov    0x14(%ebp),%eax
  800b9a:	83 c0 04             	add    $0x4,%eax
  800b9d:	89 45 14             	mov    %eax,0x14(%ebp)
  800ba0:	8b 45 14             	mov    0x14(%ebp),%eax
  800ba3:	83 e8 04             	sub    $0x4,%eax
  800ba6:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ba8:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bab:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800bb2:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800bb9:	eb 1f                	jmp    800bda <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800bbb:	83 ec 08             	sub    $0x8,%esp
  800bbe:	ff 75 e8             	pushl  -0x18(%ebp)
  800bc1:	8d 45 14             	lea    0x14(%ebp),%eax
  800bc4:	50                   	push   %eax
  800bc5:	e8 e7 fb ff ff       	call   8007b1 <getuint>
  800bca:	83 c4 10             	add    $0x10,%esp
  800bcd:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bd0:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800bd3:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800bda:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800bde:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800be1:	83 ec 04             	sub    $0x4,%esp
  800be4:	52                   	push   %edx
  800be5:	ff 75 e4             	pushl  -0x1c(%ebp)
  800be8:	50                   	push   %eax
  800be9:	ff 75 f4             	pushl  -0xc(%ebp)
  800bec:	ff 75 f0             	pushl  -0x10(%ebp)
  800bef:	ff 75 0c             	pushl  0xc(%ebp)
  800bf2:	ff 75 08             	pushl  0x8(%ebp)
  800bf5:	e8 00 fb ff ff       	call   8006fa <printnum>
  800bfa:	83 c4 20             	add    $0x20,%esp
			break;
  800bfd:	eb 34                	jmp    800c33 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800bff:	83 ec 08             	sub    $0x8,%esp
  800c02:	ff 75 0c             	pushl  0xc(%ebp)
  800c05:	53                   	push   %ebx
  800c06:	8b 45 08             	mov    0x8(%ebp),%eax
  800c09:	ff d0                	call   *%eax
  800c0b:	83 c4 10             	add    $0x10,%esp
			break;
  800c0e:	eb 23                	jmp    800c33 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800c10:	83 ec 08             	sub    $0x8,%esp
  800c13:	ff 75 0c             	pushl  0xc(%ebp)
  800c16:	6a 25                	push   $0x25
  800c18:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1b:	ff d0                	call   *%eax
  800c1d:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800c20:	ff 4d 10             	decl   0x10(%ebp)
  800c23:	eb 03                	jmp    800c28 <vprintfmt+0x3b1>
  800c25:	ff 4d 10             	decl   0x10(%ebp)
  800c28:	8b 45 10             	mov    0x10(%ebp),%eax
  800c2b:	48                   	dec    %eax
  800c2c:	8a 00                	mov    (%eax),%al
  800c2e:	3c 25                	cmp    $0x25,%al
  800c30:	75 f3                	jne    800c25 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800c32:	90                   	nop
		}
	}
  800c33:	e9 47 fc ff ff       	jmp    80087f <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800c38:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800c39:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800c3c:	5b                   	pop    %ebx
  800c3d:	5e                   	pop    %esi
  800c3e:	5d                   	pop    %ebp
  800c3f:	c3                   	ret    

00800c40 <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800c40:	55                   	push   %ebp
  800c41:	89 e5                	mov    %esp,%ebp
  800c43:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800c46:	8d 45 10             	lea    0x10(%ebp),%eax
  800c49:	83 c0 04             	add    $0x4,%eax
  800c4c:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800c4f:	8b 45 10             	mov    0x10(%ebp),%eax
  800c52:	ff 75 f4             	pushl  -0xc(%ebp)
  800c55:	50                   	push   %eax
  800c56:	ff 75 0c             	pushl  0xc(%ebp)
  800c59:	ff 75 08             	pushl  0x8(%ebp)
  800c5c:	e8 16 fc ff ff       	call   800877 <vprintfmt>
  800c61:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800c64:	90                   	nop
  800c65:	c9                   	leave  
  800c66:	c3                   	ret    

00800c67 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800c67:	55                   	push   %ebp
  800c68:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800c6a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c6d:	8b 40 08             	mov    0x8(%eax),%eax
  800c70:	8d 50 01             	lea    0x1(%eax),%edx
  800c73:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c76:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800c79:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c7c:	8b 10                	mov    (%eax),%edx
  800c7e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c81:	8b 40 04             	mov    0x4(%eax),%eax
  800c84:	39 c2                	cmp    %eax,%edx
  800c86:	73 12                	jae    800c9a <sprintputch+0x33>
		*b->buf++ = ch;
  800c88:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c8b:	8b 00                	mov    (%eax),%eax
  800c8d:	8d 48 01             	lea    0x1(%eax),%ecx
  800c90:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c93:	89 0a                	mov    %ecx,(%edx)
  800c95:	8b 55 08             	mov    0x8(%ebp),%edx
  800c98:	88 10                	mov    %dl,(%eax)
}
  800c9a:	90                   	nop
  800c9b:	5d                   	pop    %ebp
  800c9c:	c3                   	ret    

00800c9d <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800c9d:	55                   	push   %ebp
  800c9e:	89 e5                	mov    %esp,%ebp
  800ca0:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800ca3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca6:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800ca9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cac:	8d 50 ff             	lea    -0x1(%eax),%edx
  800caf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb2:	01 d0                	add    %edx,%eax
  800cb4:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cb7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800cbe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800cc2:	74 06                	je     800cca <vsnprintf+0x2d>
  800cc4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cc8:	7f 07                	jg     800cd1 <vsnprintf+0x34>
		return -E_INVAL;
  800cca:	b8 03 00 00 00       	mov    $0x3,%eax
  800ccf:	eb 20                	jmp    800cf1 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800cd1:	ff 75 14             	pushl  0x14(%ebp)
  800cd4:	ff 75 10             	pushl  0x10(%ebp)
  800cd7:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800cda:	50                   	push   %eax
  800cdb:	68 67 0c 80 00       	push   $0x800c67
  800ce0:	e8 92 fb ff ff       	call   800877 <vprintfmt>
  800ce5:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800ce8:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ceb:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800cee:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800cf1:	c9                   	leave  
  800cf2:	c3                   	ret    

00800cf3 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800cf3:	55                   	push   %ebp
  800cf4:	89 e5                	mov    %esp,%ebp
  800cf6:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800cf9:	8d 45 10             	lea    0x10(%ebp),%eax
  800cfc:	83 c0 04             	add    $0x4,%eax
  800cff:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800d02:	8b 45 10             	mov    0x10(%ebp),%eax
  800d05:	ff 75 f4             	pushl  -0xc(%ebp)
  800d08:	50                   	push   %eax
  800d09:	ff 75 0c             	pushl  0xc(%ebp)
  800d0c:	ff 75 08             	pushl  0x8(%ebp)
  800d0f:	e8 89 ff ff ff       	call   800c9d <vsnprintf>
  800d14:	83 c4 10             	add    $0x10,%esp
  800d17:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800d1a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800d1d:	c9                   	leave  
  800d1e:	c3                   	ret    

00800d1f <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800d1f:	55                   	push   %ebp
  800d20:	89 e5                	mov    %esp,%ebp
  800d22:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800d25:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d2c:	eb 06                	jmp    800d34 <strlen+0x15>
		n++;
  800d2e:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800d31:	ff 45 08             	incl   0x8(%ebp)
  800d34:	8b 45 08             	mov    0x8(%ebp),%eax
  800d37:	8a 00                	mov    (%eax),%al
  800d39:	84 c0                	test   %al,%al
  800d3b:	75 f1                	jne    800d2e <strlen+0xf>
		n++;
	return n;
  800d3d:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d40:	c9                   	leave  
  800d41:	c3                   	ret    

00800d42 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800d42:	55                   	push   %ebp
  800d43:	89 e5                	mov    %esp,%ebp
  800d45:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d48:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800d4f:	eb 09                	jmp    800d5a <strnlen+0x18>
		n++;
  800d51:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800d54:	ff 45 08             	incl   0x8(%ebp)
  800d57:	ff 4d 0c             	decl   0xc(%ebp)
  800d5a:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800d5e:	74 09                	je     800d69 <strnlen+0x27>
  800d60:	8b 45 08             	mov    0x8(%ebp),%eax
  800d63:	8a 00                	mov    (%eax),%al
  800d65:	84 c0                	test   %al,%al
  800d67:	75 e8                	jne    800d51 <strnlen+0xf>
		n++;
	return n;
  800d69:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d6c:	c9                   	leave  
  800d6d:	c3                   	ret    

00800d6e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800d6e:	55                   	push   %ebp
  800d6f:	89 e5                	mov    %esp,%ebp
  800d71:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800d74:	8b 45 08             	mov    0x8(%ebp),%eax
  800d77:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800d7a:	90                   	nop
  800d7b:	8b 45 08             	mov    0x8(%ebp),%eax
  800d7e:	8d 50 01             	lea    0x1(%eax),%edx
  800d81:	89 55 08             	mov    %edx,0x8(%ebp)
  800d84:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d87:	8d 4a 01             	lea    0x1(%edx),%ecx
  800d8a:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800d8d:	8a 12                	mov    (%edx),%dl
  800d8f:	88 10                	mov    %dl,(%eax)
  800d91:	8a 00                	mov    (%eax),%al
  800d93:	84 c0                	test   %al,%al
  800d95:	75 e4                	jne    800d7b <strcpy+0xd>
		/* do nothing */;
	return ret;
  800d97:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800d9a:	c9                   	leave  
  800d9b:	c3                   	ret    

00800d9c <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800d9c:	55                   	push   %ebp
  800d9d:	89 e5                	mov    %esp,%ebp
  800d9f:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800da2:	8b 45 08             	mov    0x8(%ebp),%eax
  800da5:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800da8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800daf:	eb 1f                	jmp    800dd0 <strncpy+0x34>
		*dst++ = *src;
  800db1:	8b 45 08             	mov    0x8(%ebp),%eax
  800db4:	8d 50 01             	lea    0x1(%eax),%edx
  800db7:	89 55 08             	mov    %edx,0x8(%ebp)
  800dba:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dbd:	8a 12                	mov    (%edx),%dl
  800dbf:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800dc1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dc4:	8a 00                	mov    (%eax),%al
  800dc6:	84 c0                	test   %al,%al
  800dc8:	74 03                	je     800dcd <strncpy+0x31>
			src++;
  800dca:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800dcd:	ff 45 fc             	incl   -0x4(%ebp)
  800dd0:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800dd3:	3b 45 10             	cmp    0x10(%ebp),%eax
  800dd6:	72 d9                	jb     800db1 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800dd8:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ddb:	c9                   	leave  
  800ddc:	c3                   	ret    

00800ddd <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800ddd:	55                   	push   %ebp
  800dde:	89 e5                	mov    %esp,%ebp
  800de0:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800de3:	8b 45 08             	mov    0x8(%ebp),%eax
  800de6:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800de9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ded:	74 30                	je     800e1f <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800def:	eb 16                	jmp    800e07 <strlcpy+0x2a>
			*dst++ = *src++;
  800df1:	8b 45 08             	mov    0x8(%ebp),%eax
  800df4:	8d 50 01             	lea    0x1(%eax),%edx
  800df7:	89 55 08             	mov    %edx,0x8(%ebp)
  800dfa:	8b 55 0c             	mov    0xc(%ebp),%edx
  800dfd:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e00:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e03:	8a 12                	mov    (%edx),%dl
  800e05:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800e07:	ff 4d 10             	decl   0x10(%ebp)
  800e0a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e0e:	74 09                	je     800e19 <strlcpy+0x3c>
  800e10:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e13:	8a 00                	mov    (%eax),%al
  800e15:	84 c0                	test   %al,%al
  800e17:	75 d8                	jne    800df1 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800e19:	8b 45 08             	mov    0x8(%ebp),%eax
  800e1c:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800e1f:	8b 55 08             	mov    0x8(%ebp),%edx
  800e22:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800e25:	29 c2                	sub    %eax,%edx
  800e27:	89 d0                	mov    %edx,%eax
}
  800e29:	c9                   	leave  
  800e2a:	c3                   	ret    

00800e2b <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800e2b:	55                   	push   %ebp
  800e2c:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800e2e:	eb 06                	jmp    800e36 <strcmp+0xb>
		p++, q++;
  800e30:	ff 45 08             	incl   0x8(%ebp)
  800e33:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800e36:	8b 45 08             	mov    0x8(%ebp),%eax
  800e39:	8a 00                	mov    (%eax),%al
  800e3b:	84 c0                	test   %al,%al
  800e3d:	74 0e                	je     800e4d <strcmp+0x22>
  800e3f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e42:	8a 10                	mov    (%eax),%dl
  800e44:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e47:	8a 00                	mov    (%eax),%al
  800e49:	38 c2                	cmp    %al,%dl
  800e4b:	74 e3                	je     800e30 <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800e4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e50:	8a 00                	mov    (%eax),%al
  800e52:	0f b6 d0             	movzbl %al,%edx
  800e55:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e58:	8a 00                	mov    (%eax),%al
  800e5a:	0f b6 c0             	movzbl %al,%eax
  800e5d:	29 c2                	sub    %eax,%edx
  800e5f:	89 d0                	mov    %edx,%eax
}
  800e61:	5d                   	pop    %ebp
  800e62:	c3                   	ret    

00800e63 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800e63:	55                   	push   %ebp
  800e64:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800e66:	eb 09                	jmp    800e71 <strncmp+0xe>
		n--, p++, q++;
  800e68:	ff 4d 10             	decl   0x10(%ebp)
  800e6b:	ff 45 08             	incl   0x8(%ebp)
  800e6e:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800e71:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e75:	74 17                	je     800e8e <strncmp+0x2b>
  800e77:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7a:	8a 00                	mov    (%eax),%al
  800e7c:	84 c0                	test   %al,%al
  800e7e:	74 0e                	je     800e8e <strncmp+0x2b>
  800e80:	8b 45 08             	mov    0x8(%ebp),%eax
  800e83:	8a 10                	mov    (%eax),%dl
  800e85:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e88:	8a 00                	mov    (%eax),%al
  800e8a:	38 c2                	cmp    %al,%dl
  800e8c:	74 da                	je     800e68 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800e8e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e92:	75 07                	jne    800e9b <strncmp+0x38>
		return 0;
  800e94:	b8 00 00 00 00       	mov    $0x0,%eax
  800e99:	eb 14                	jmp    800eaf <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800e9b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9e:	8a 00                	mov    (%eax),%al
  800ea0:	0f b6 d0             	movzbl %al,%edx
  800ea3:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ea6:	8a 00                	mov    (%eax),%al
  800ea8:	0f b6 c0             	movzbl %al,%eax
  800eab:	29 c2                	sub    %eax,%edx
  800ead:	89 d0                	mov    %edx,%eax
}
  800eaf:	5d                   	pop    %ebp
  800eb0:	c3                   	ret    

00800eb1 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800eb1:	55                   	push   %ebp
  800eb2:	89 e5                	mov    %esp,%ebp
  800eb4:	83 ec 04             	sub    $0x4,%esp
  800eb7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eba:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800ebd:	eb 12                	jmp    800ed1 <strchr+0x20>
		if (*s == c)
  800ebf:	8b 45 08             	mov    0x8(%ebp),%eax
  800ec2:	8a 00                	mov    (%eax),%al
  800ec4:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ec7:	75 05                	jne    800ece <strchr+0x1d>
			return (char *) s;
  800ec9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecc:	eb 11                	jmp    800edf <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800ece:	ff 45 08             	incl   0x8(%ebp)
  800ed1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed4:	8a 00                	mov    (%eax),%al
  800ed6:	84 c0                	test   %al,%al
  800ed8:	75 e5                	jne    800ebf <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800eda:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800edf:	c9                   	leave  
  800ee0:	c3                   	ret    

00800ee1 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800ee1:	55                   	push   %ebp
  800ee2:	89 e5                	mov    %esp,%ebp
  800ee4:	83 ec 04             	sub    $0x4,%esp
  800ee7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eea:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800eed:	eb 0d                	jmp    800efc <strfind+0x1b>
		if (*s == c)
  800eef:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef2:	8a 00                	mov    (%eax),%al
  800ef4:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ef7:	74 0e                	je     800f07 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800ef9:	ff 45 08             	incl   0x8(%ebp)
  800efc:	8b 45 08             	mov    0x8(%ebp),%eax
  800eff:	8a 00                	mov    (%eax),%al
  800f01:	84 c0                	test   %al,%al
  800f03:	75 ea                	jne    800eef <strfind+0xe>
  800f05:	eb 01                	jmp    800f08 <strfind+0x27>
		if (*s == c)
			break;
  800f07:	90                   	nop
	return (char *) s;
  800f08:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f0b:	c9                   	leave  
  800f0c:	c3                   	ret    

00800f0d <memset>:


void *
memset(void *v, int c, uint32 n)
{
  800f0d:	55                   	push   %ebp
  800f0e:	89 e5                	mov    %esp,%ebp
  800f10:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  800f13:	8b 45 08             	mov    0x8(%ebp),%eax
  800f16:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  800f19:	8b 45 10             	mov    0x10(%ebp),%eax
  800f1c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  800f1f:	eb 0e                	jmp    800f2f <memset+0x22>
		*p++ = c;
  800f21:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f24:	8d 50 01             	lea    0x1(%eax),%edx
  800f27:	89 55 fc             	mov    %edx,-0x4(%ebp)
  800f2a:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f2d:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  800f2f:	ff 4d f8             	decl   -0x8(%ebp)
  800f32:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800f36:	79 e9                	jns    800f21 <memset+0x14>
		*p++ = c;

	return v;
  800f38:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f3b:	c9                   	leave  
  800f3c:	c3                   	ret    

00800f3d <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  800f3d:	55                   	push   %ebp
  800f3e:	89 e5                	mov    %esp,%ebp
  800f40:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f43:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f46:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f49:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4c:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  800f4f:	eb 16                	jmp    800f67 <memcpy+0x2a>
		*d++ = *s++;
  800f51:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f54:	8d 50 01             	lea    0x1(%eax),%edx
  800f57:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800f5a:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f5d:	8d 4a 01             	lea    0x1(%edx),%ecx
  800f60:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800f63:	8a 12                	mov    (%edx),%dl
  800f65:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  800f67:	8b 45 10             	mov    0x10(%ebp),%eax
  800f6a:	8d 50 ff             	lea    -0x1(%eax),%edx
  800f6d:	89 55 10             	mov    %edx,0x10(%ebp)
  800f70:	85 c0                	test   %eax,%eax
  800f72:	75 dd                	jne    800f51 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  800f74:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800f77:	c9                   	leave  
  800f78:	c3                   	ret    

00800f79 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  800f79:	55                   	push   %ebp
  800f7a:	89 e5                	mov    %esp,%ebp
  800f7c:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  800f7f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f82:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  800f85:	8b 45 08             	mov    0x8(%ebp),%eax
  800f88:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  800f8b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f8e:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f91:	73 50                	jae    800fe3 <memmove+0x6a>
  800f93:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800f96:	8b 45 10             	mov    0x10(%ebp),%eax
  800f99:	01 d0                	add    %edx,%eax
  800f9b:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  800f9e:	76 43                	jbe    800fe3 <memmove+0x6a>
		s += n;
  800fa0:	8b 45 10             	mov    0x10(%ebp),%eax
  800fa3:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  800fa6:	8b 45 10             	mov    0x10(%ebp),%eax
  800fa9:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  800fac:	eb 10                	jmp    800fbe <memmove+0x45>
			*--d = *--s;
  800fae:	ff 4d f8             	decl   -0x8(%ebp)
  800fb1:	ff 4d fc             	decl   -0x4(%ebp)
  800fb4:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800fb7:	8a 10                	mov    (%eax),%dl
  800fb9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fbc:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  800fbe:	8b 45 10             	mov    0x10(%ebp),%eax
  800fc1:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fc4:	89 55 10             	mov    %edx,0x10(%ebp)
  800fc7:	85 c0                	test   %eax,%eax
  800fc9:	75 e3                	jne    800fae <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  800fcb:	eb 23                	jmp    800ff0 <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  800fcd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800fd0:	8d 50 01             	lea    0x1(%eax),%edx
  800fd3:	89 55 f8             	mov    %edx,-0x8(%ebp)
  800fd6:	8b 55 fc             	mov    -0x4(%ebp),%edx
  800fd9:	8d 4a 01             	lea    0x1(%edx),%ecx
  800fdc:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  800fdf:	8a 12                	mov    (%edx),%dl
  800fe1:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  800fe3:	8b 45 10             	mov    0x10(%ebp),%eax
  800fe6:	8d 50 ff             	lea    -0x1(%eax),%edx
  800fe9:	89 55 10             	mov    %edx,0x10(%ebp)
  800fec:	85 c0                	test   %eax,%eax
  800fee:	75 dd                	jne    800fcd <memmove+0x54>
			*d++ = *s++;

	return dst;
  800ff0:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800ff3:	c9                   	leave  
  800ff4:	c3                   	ret    

00800ff5 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  800ff5:	55                   	push   %ebp
  800ff6:	89 e5                	mov    %esp,%ebp
  800ff8:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  800ffb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffe:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801001:	8b 45 0c             	mov    0xc(%ebp),%eax
  801004:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801007:	eb 2a                	jmp    801033 <memcmp+0x3e>
		if (*s1 != *s2)
  801009:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80100c:	8a 10                	mov    (%eax),%dl
  80100e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801011:	8a 00                	mov    (%eax),%al
  801013:	38 c2                	cmp    %al,%dl
  801015:	74 16                	je     80102d <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801017:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80101a:	8a 00                	mov    (%eax),%al
  80101c:	0f b6 d0             	movzbl %al,%edx
  80101f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801022:	8a 00                	mov    (%eax),%al
  801024:	0f b6 c0             	movzbl %al,%eax
  801027:	29 c2                	sub    %eax,%edx
  801029:	89 d0                	mov    %edx,%eax
  80102b:	eb 18                	jmp    801045 <memcmp+0x50>
		s1++, s2++;
  80102d:	ff 45 fc             	incl   -0x4(%ebp)
  801030:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801033:	8b 45 10             	mov    0x10(%ebp),%eax
  801036:	8d 50 ff             	lea    -0x1(%eax),%edx
  801039:	89 55 10             	mov    %edx,0x10(%ebp)
  80103c:	85 c0                	test   %eax,%eax
  80103e:	75 c9                	jne    801009 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  801040:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801045:	c9                   	leave  
  801046:	c3                   	ret    

00801047 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801047:	55                   	push   %ebp
  801048:	89 e5                	mov    %esp,%ebp
  80104a:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80104d:	8b 55 08             	mov    0x8(%ebp),%edx
  801050:	8b 45 10             	mov    0x10(%ebp),%eax
  801053:	01 d0                	add    %edx,%eax
  801055:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801058:	eb 15                	jmp    80106f <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  80105a:	8b 45 08             	mov    0x8(%ebp),%eax
  80105d:	8a 00                	mov    (%eax),%al
  80105f:	0f b6 d0             	movzbl %al,%edx
  801062:	8b 45 0c             	mov    0xc(%ebp),%eax
  801065:	0f b6 c0             	movzbl %al,%eax
  801068:	39 c2                	cmp    %eax,%edx
  80106a:	74 0d                	je     801079 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80106c:	ff 45 08             	incl   0x8(%ebp)
  80106f:	8b 45 08             	mov    0x8(%ebp),%eax
  801072:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801075:	72 e3                	jb     80105a <memfind+0x13>
  801077:	eb 01                	jmp    80107a <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801079:	90                   	nop
	return (void *) s;
  80107a:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80107d:	c9                   	leave  
  80107e:	c3                   	ret    

0080107f <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80107f:	55                   	push   %ebp
  801080:	89 e5                	mov    %esp,%ebp
  801082:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801085:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80108c:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801093:	eb 03                	jmp    801098 <strtol+0x19>
		s++;
  801095:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801098:	8b 45 08             	mov    0x8(%ebp),%eax
  80109b:	8a 00                	mov    (%eax),%al
  80109d:	3c 20                	cmp    $0x20,%al
  80109f:	74 f4                	je     801095 <strtol+0x16>
  8010a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8010a4:	8a 00                	mov    (%eax),%al
  8010a6:	3c 09                	cmp    $0x9,%al
  8010a8:	74 eb                	je     801095 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8010aa:	8b 45 08             	mov    0x8(%ebp),%eax
  8010ad:	8a 00                	mov    (%eax),%al
  8010af:	3c 2b                	cmp    $0x2b,%al
  8010b1:	75 05                	jne    8010b8 <strtol+0x39>
		s++;
  8010b3:	ff 45 08             	incl   0x8(%ebp)
  8010b6:	eb 13                	jmp    8010cb <strtol+0x4c>
	else if (*s == '-')
  8010b8:	8b 45 08             	mov    0x8(%ebp),%eax
  8010bb:	8a 00                	mov    (%eax),%al
  8010bd:	3c 2d                	cmp    $0x2d,%al
  8010bf:	75 0a                	jne    8010cb <strtol+0x4c>
		s++, neg = 1;
  8010c1:	ff 45 08             	incl   0x8(%ebp)
  8010c4:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8010cb:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010cf:	74 06                	je     8010d7 <strtol+0x58>
  8010d1:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8010d5:	75 20                	jne    8010f7 <strtol+0x78>
  8010d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8010da:	8a 00                	mov    (%eax),%al
  8010dc:	3c 30                	cmp    $0x30,%al
  8010de:	75 17                	jne    8010f7 <strtol+0x78>
  8010e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e3:	40                   	inc    %eax
  8010e4:	8a 00                	mov    (%eax),%al
  8010e6:	3c 78                	cmp    $0x78,%al
  8010e8:	75 0d                	jne    8010f7 <strtol+0x78>
		s += 2, base = 16;
  8010ea:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8010ee:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8010f5:	eb 28                	jmp    80111f <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8010f7:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010fb:	75 15                	jne    801112 <strtol+0x93>
  8010fd:	8b 45 08             	mov    0x8(%ebp),%eax
  801100:	8a 00                	mov    (%eax),%al
  801102:	3c 30                	cmp    $0x30,%al
  801104:	75 0c                	jne    801112 <strtol+0x93>
		s++, base = 8;
  801106:	ff 45 08             	incl   0x8(%ebp)
  801109:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801110:	eb 0d                	jmp    80111f <strtol+0xa0>
	else if (base == 0)
  801112:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801116:	75 07                	jne    80111f <strtol+0xa0>
		base = 10;
  801118:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80111f:	8b 45 08             	mov    0x8(%ebp),%eax
  801122:	8a 00                	mov    (%eax),%al
  801124:	3c 2f                	cmp    $0x2f,%al
  801126:	7e 19                	jle    801141 <strtol+0xc2>
  801128:	8b 45 08             	mov    0x8(%ebp),%eax
  80112b:	8a 00                	mov    (%eax),%al
  80112d:	3c 39                	cmp    $0x39,%al
  80112f:	7f 10                	jg     801141 <strtol+0xc2>
			dig = *s - '0';
  801131:	8b 45 08             	mov    0x8(%ebp),%eax
  801134:	8a 00                	mov    (%eax),%al
  801136:	0f be c0             	movsbl %al,%eax
  801139:	83 e8 30             	sub    $0x30,%eax
  80113c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80113f:	eb 42                	jmp    801183 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801141:	8b 45 08             	mov    0x8(%ebp),%eax
  801144:	8a 00                	mov    (%eax),%al
  801146:	3c 60                	cmp    $0x60,%al
  801148:	7e 19                	jle    801163 <strtol+0xe4>
  80114a:	8b 45 08             	mov    0x8(%ebp),%eax
  80114d:	8a 00                	mov    (%eax),%al
  80114f:	3c 7a                	cmp    $0x7a,%al
  801151:	7f 10                	jg     801163 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801153:	8b 45 08             	mov    0x8(%ebp),%eax
  801156:	8a 00                	mov    (%eax),%al
  801158:	0f be c0             	movsbl %al,%eax
  80115b:	83 e8 57             	sub    $0x57,%eax
  80115e:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801161:	eb 20                	jmp    801183 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801163:	8b 45 08             	mov    0x8(%ebp),%eax
  801166:	8a 00                	mov    (%eax),%al
  801168:	3c 40                	cmp    $0x40,%al
  80116a:	7e 39                	jle    8011a5 <strtol+0x126>
  80116c:	8b 45 08             	mov    0x8(%ebp),%eax
  80116f:	8a 00                	mov    (%eax),%al
  801171:	3c 5a                	cmp    $0x5a,%al
  801173:	7f 30                	jg     8011a5 <strtol+0x126>
			dig = *s - 'A' + 10;
  801175:	8b 45 08             	mov    0x8(%ebp),%eax
  801178:	8a 00                	mov    (%eax),%al
  80117a:	0f be c0             	movsbl %al,%eax
  80117d:	83 e8 37             	sub    $0x37,%eax
  801180:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801183:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801186:	3b 45 10             	cmp    0x10(%ebp),%eax
  801189:	7d 19                	jge    8011a4 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80118b:	ff 45 08             	incl   0x8(%ebp)
  80118e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801191:	0f af 45 10          	imul   0x10(%ebp),%eax
  801195:	89 c2                	mov    %eax,%edx
  801197:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80119a:	01 d0                	add    %edx,%eax
  80119c:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80119f:	e9 7b ff ff ff       	jmp    80111f <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8011a4:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8011a5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8011a9:	74 08                	je     8011b3 <strtol+0x134>
		*endptr = (char *) s;
  8011ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ae:	8b 55 08             	mov    0x8(%ebp),%edx
  8011b1:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8011b3:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8011b7:	74 07                	je     8011c0 <strtol+0x141>
  8011b9:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8011bc:	f7 d8                	neg    %eax
  8011be:	eb 03                	jmp    8011c3 <strtol+0x144>
  8011c0:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8011c3:	c9                   	leave  
  8011c4:	c3                   	ret    

008011c5 <ltostr>:

void
ltostr(long value, char *str)
{
  8011c5:	55                   	push   %ebp
  8011c6:	89 e5                	mov    %esp,%ebp
  8011c8:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8011cb:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8011d2:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8011d9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8011dd:	79 13                	jns    8011f2 <ltostr+0x2d>
	{
		neg = 1;
  8011df:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8011e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011e9:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8011ec:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8011ef:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8011f2:	8b 45 08             	mov    0x8(%ebp),%eax
  8011f5:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8011fa:	99                   	cltd   
  8011fb:	f7 f9                	idiv   %ecx
  8011fd:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  801200:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801203:	8d 50 01             	lea    0x1(%eax),%edx
  801206:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801209:	89 c2                	mov    %eax,%edx
  80120b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80120e:	01 d0                	add    %edx,%eax
  801210:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801213:	83 c2 30             	add    $0x30,%edx
  801216:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801218:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80121b:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801220:	f7 e9                	imul   %ecx
  801222:	c1 fa 02             	sar    $0x2,%edx
  801225:	89 c8                	mov    %ecx,%eax
  801227:	c1 f8 1f             	sar    $0x1f,%eax
  80122a:	29 c2                	sub    %eax,%edx
  80122c:	89 d0                	mov    %edx,%eax
  80122e:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801231:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801234:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801239:	f7 e9                	imul   %ecx
  80123b:	c1 fa 02             	sar    $0x2,%edx
  80123e:	89 c8                	mov    %ecx,%eax
  801240:	c1 f8 1f             	sar    $0x1f,%eax
  801243:	29 c2                	sub    %eax,%edx
  801245:	89 d0                	mov    %edx,%eax
  801247:	c1 e0 02             	shl    $0x2,%eax
  80124a:	01 d0                	add    %edx,%eax
  80124c:	01 c0                	add    %eax,%eax
  80124e:	29 c1                	sub    %eax,%ecx
  801250:	89 ca                	mov    %ecx,%edx
  801252:	85 d2                	test   %edx,%edx
  801254:	75 9c                	jne    8011f2 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801256:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80125d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801260:	48                   	dec    %eax
  801261:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801264:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801268:	74 3d                	je     8012a7 <ltostr+0xe2>
		start = 1 ;
  80126a:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801271:	eb 34                	jmp    8012a7 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801273:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801276:	8b 45 0c             	mov    0xc(%ebp),%eax
  801279:	01 d0                	add    %edx,%eax
  80127b:	8a 00                	mov    (%eax),%al
  80127d:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  801280:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801283:	8b 45 0c             	mov    0xc(%ebp),%eax
  801286:	01 c2                	add    %eax,%edx
  801288:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80128b:	8b 45 0c             	mov    0xc(%ebp),%eax
  80128e:	01 c8                	add    %ecx,%eax
  801290:	8a 00                	mov    (%eax),%al
  801292:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801294:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801297:	8b 45 0c             	mov    0xc(%ebp),%eax
  80129a:	01 c2                	add    %eax,%edx
  80129c:	8a 45 eb             	mov    -0x15(%ebp),%al
  80129f:	88 02                	mov    %al,(%edx)
		start++ ;
  8012a1:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8012a4:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8012a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8012aa:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8012ad:	7c c4                	jl     801273 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8012af:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8012b2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012b5:	01 d0                	add    %edx,%eax
  8012b7:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8012ba:	90                   	nop
  8012bb:	c9                   	leave  
  8012bc:	c3                   	ret    

008012bd <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8012bd:	55                   	push   %ebp
  8012be:	89 e5                	mov    %esp,%ebp
  8012c0:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8012c3:	ff 75 08             	pushl  0x8(%ebp)
  8012c6:	e8 54 fa ff ff       	call   800d1f <strlen>
  8012cb:	83 c4 04             	add    $0x4,%esp
  8012ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8012d1:	ff 75 0c             	pushl  0xc(%ebp)
  8012d4:	e8 46 fa ff ff       	call   800d1f <strlen>
  8012d9:	83 c4 04             	add    $0x4,%esp
  8012dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8012df:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8012e6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8012ed:	eb 17                	jmp    801306 <strcconcat+0x49>
		final[s] = str1[s] ;
  8012ef:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8012f2:	8b 45 10             	mov    0x10(%ebp),%eax
  8012f5:	01 c2                	add    %eax,%edx
  8012f7:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8012fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8012fd:	01 c8                	add    %ecx,%eax
  8012ff:	8a 00                	mov    (%eax),%al
  801301:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801303:	ff 45 fc             	incl   -0x4(%ebp)
  801306:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801309:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80130c:	7c e1                	jl     8012ef <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80130e:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801315:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80131c:	eb 1f                	jmp    80133d <strcconcat+0x80>
		final[s++] = str2[i] ;
  80131e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801321:	8d 50 01             	lea    0x1(%eax),%edx
  801324:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801327:	89 c2                	mov    %eax,%edx
  801329:	8b 45 10             	mov    0x10(%ebp),%eax
  80132c:	01 c2                	add    %eax,%edx
  80132e:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801331:	8b 45 0c             	mov    0xc(%ebp),%eax
  801334:	01 c8                	add    %ecx,%eax
  801336:	8a 00                	mov    (%eax),%al
  801338:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  80133a:	ff 45 f8             	incl   -0x8(%ebp)
  80133d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801340:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801343:	7c d9                	jl     80131e <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801345:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801348:	8b 45 10             	mov    0x10(%ebp),%eax
  80134b:	01 d0                	add    %edx,%eax
  80134d:	c6 00 00             	movb   $0x0,(%eax)
}
  801350:	90                   	nop
  801351:	c9                   	leave  
  801352:	c3                   	ret    

00801353 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801353:	55                   	push   %ebp
  801354:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801356:	8b 45 14             	mov    0x14(%ebp),%eax
  801359:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80135f:	8b 45 14             	mov    0x14(%ebp),%eax
  801362:	8b 00                	mov    (%eax),%eax
  801364:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80136b:	8b 45 10             	mov    0x10(%ebp),%eax
  80136e:	01 d0                	add    %edx,%eax
  801370:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801376:	eb 0c                	jmp    801384 <strsplit+0x31>
			*string++ = 0;
  801378:	8b 45 08             	mov    0x8(%ebp),%eax
  80137b:	8d 50 01             	lea    0x1(%eax),%edx
  80137e:	89 55 08             	mov    %edx,0x8(%ebp)
  801381:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801384:	8b 45 08             	mov    0x8(%ebp),%eax
  801387:	8a 00                	mov    (%eax),%al
  801389:	84 c0                	test   %al,%al
  80138b:	74 18                	je     8013a5 <strsplit+0x52>
  80138d:	8b 45 08             	mov    0x8(%ebp),%eax
  801390:	8a 00                	mov    (%eax),%al
  801392:	0f be c0             	movsbl %al,%eax
  801395:	50                   	push   %eax
  801396:	ff 75 0c             	pushl  0xc(%ebp)
  801399:	e8 13 fb ff ff       	call   800eb1 <strchr>
  80139e:	83 c4 08             	add    $0x8,%esp
  8013a1:	85 c0                	test   %eax,%eax
  8013a3:	75 d3                	jne    801378 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8013a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8013a8:	8a 00                	mov    (%eax),%al
  8013aa:	84 c0                	test   %al,%al
  8013ac:	74 5a                	je     801408 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8013ae:	8b 45 14             	mov    0x14(%ebp),%eax
  8013b1:	8b 00                	mov    (%eax),%eax
  8013b3:	83 f8 0f             	cmp    $0xf,%eax
  8013b6:	75 07                	jne    8013bf <strsplit+0x6c>
		{
			return 0;
  8013b8:	b8 00 00 00 00       	mov    $0x0,%eax
  8013bd:	eb 66                	jmp    801425 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8013bf:	8b 45 14             	mov    0x14(%ebp),%eax
  8013c2:	8b 00                	mov    (%eax),%eax
  8013c4:	8d 48 01             	lea    0x1(%eax),%ecx
  8013c7:	8b 55 14             	mov    0x14(%ebp),%edx
  8013ca:	89 0a                	mov    %ecx,(%edx)
  8013cc:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8013d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8013d6:	01 c2                	add    %eax,%edx
  8013d8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013db:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013dd:	eb 03                	jmp    8013e2 <strsplit+0x8f>
			string++;
  8013df:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8013e2:	8b 45 08             	mov    0x8(%ebp),%eax
  8013e5:	8a 00                	mov    (%eax),%al
  8013e7:	84 c0                	test   %al,%al
  8013e9:	74 8b                	je     801376 <strsplit+0x23>
  8013eb:	8b 45 08             	mov    0x8(%ebp),%eax
  8013ee:	8a 00                	mov    (%eax),%al
  8013f0:	0f be c0             	movsbl %al,%eax
  8013f3:	50                   	push   %eax
  8013f4:	ff 75 0c             	pushl  0xc(%ebp)
  8013f7:	e8 b5 fa ff ff       	call   800eb1 <strchr>
  8013fc:	83 c4 08             	add    $0x8,%esp
  8013ff:	85 c0                	test   %eax,%eax
  801401:	74 dc                	je     8013df <strsplit+0x8c>
			string++;
	}
  801403:	e9 6e ff ff ff       	jmp    801376 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801408:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801409:	8b 45 14             	mov    0x14(%ebp),%eax
  80140c:	8b 00                	mov    (%eax),%eax
  80140e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801415:	8b 45 10             	mov    0x10(%ebp),%eax
  801418:	01 d0                	add    %edx,%eax
  80141a:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  801420:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801425:	c9                   	leave  
  801426:	c3                   	ret    

00801427 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801427:	55                   	push   %ebp
  801428:	89 e5                	mov    %esp,%ebp
  80142a:	57                   	push   %edi
  80142b:	56                   	push   %esi
  80142c:	53                   	push   %ebx
  80142d:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  801430:	8b 45 08             	mov    0x8(%ebp),%eax
  801433:	8b 55 0c             	mov    0xc(%ebp),%edx
  801436:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801439:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80143c:	8b 7d 18             	mov    0x18(%ebp),%edi
  80143f:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801442:	cd 30                	int    $0x30
  801444:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801447:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80144a:	83 c4 10             	add    $0x10,%esp
  80144d:	5b                   	pop    %ebx
  80144e:	5e                   	pop    %esi
  80144f:	5f                   	pop    %edi
  801450:	5d                   	pop    %ebp
  801451:	c3                   	ret    

00801452 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801452:	55                   	push   %ebp
  801453:	89 e5                	mov    %esp,%ebp
  801455:	83 ec 04             	sub    $0x4,%esp
  801458:	8b 45 10             	mov    0x10(%ebp),%eax
  80145b:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80145e:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801462:	8b 45 08             	mov    0x8(%ebp),%eax
  801465:	6a 00                	push   $0x0
  801467:	6a 00                	push   $0x0
  801469:	52                   	push   %edx
  80146a:	ff 75 0c             	pushl  0xc(%ebp)
  80146d:	50                   	push   %eax
  80146e:	6a 00                	push   $0x0
  801470:	e8 b2 ff ff ff       	call   801427 <syscall>
  801475:	83 c4 18             	add    $0x18,%esp
}
  801478:	90                   	nop
  801479:	c9                   	leave  
  80147a:	c3                   	ret    

0080147b <sys_cgetc>:

int
sys_cgetc(void)
{
  80147b:	55                   	push   %ebp
  80147c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80147e:	6a 00                	push   $0x0
  801480:	6a 00                	push   $0x0
  801482:	6a 00                	push   $0x0
  801484:	6a 00                	push   $0x0
  801486:	6a 00                	push   $0x0
  801488:	6a 01                	push   $0x1
  80148a:	e8 98 ff ff ff       	call   801427 <syscall>
  80148f:	83 c4 18             	add    $0x18,%esp
}
  801492:	c9                   	leave  
  801493:	c3                   	ret    

00801494 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801494:	55                   	push   %ebp
  801495:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801497:	8b 55 0c             	mov    0xc(%ebp),%edx
  80149a:	8b 45 08             	mov    0x8(%ebp),%eax
  80149d:	6a 00                	push   $0x0
  80149f:	6a 00                	push   $0x0
  8014a1:	6a 00                	push   $0x0
  8014a3:	52                   	push   %edx
  8014a4:	50                   	push   %eax
  8014a5:	6a 05                	push   $0x5
  8014a7:	e8 7b ff ff ff       	call   801427 <syscall>
  8014ac:	83 c4 18             	add    $0x18,%esp
}
  8014af:	c9                   	leave  
  8014b0:	c3                   	ret    

008014b1 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8014b1:	55                   	push   %ebp
  8014b2:	89 e5                	mov    %esp,%ebp
  8014b4:	56                   	push   %esi
  8014b5:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8014b6:	8b 75 18             	mov    0x18(%ebp),%esi
  8014b9:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8014bc:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8014bf:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8014c5:	56                   	push   %esi
  8014c6:	53                   	push   %ebx
  8014c7:	51                   	push   %ecx
  8014c8:	52                   	push   %edx
  8014c9:	50                   	push   %eax
  8014ca:	6a 06                	push   $0x6
  8014cc:	e8 56 ff ff ff       	call   801427 <syscall>
  8014d1:	83 c4 18             	add    $0x18,%esp
}
  8014d4:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8014d7:	5b                   	pop    %ebx
  8014d8:	5e                   	pop    %esi
  8014d9:	5d                   	pop    %ebp
  8014da:	c3                   	ret    

008014db <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8014db:	55                   	push   %ebp
  8014dc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8014de:	8b 55 0c             	mov    0xc(%ebp),%edx
  8014e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e4:	6a 00                	push   $0x0
  8014e6:	6a 00                	push   $0x0
  8014e8:	6a 00                	push   $0x0
  8014ea:	52                   	push   %edx
  8014eb:	50                   	push   %eax
  8014ec:	6a 07                	push   $0x7
  8014ee:	e8 34 ff ff ff       	call   801427 <syscall>
  8014f3:	83 c4 18             	add    $0x18,%esp
}
  8014f6:	c9                   	leave  
  8014f7:	c3                   	ret    

008014f8 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8014f8:	55                   	push   %ebp
  8014f9:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8014fb:	6a 00                	push   $0x0
  8014fd:	6a 00                	push   $0x0
  8014ff:	6a 00                	push   $0x0
  801501:	ff 75 0c             	pushl  0xc(%ebp)
  801504:	ff 75 08             	pushl  0x8(%ebp)
  801507:	6a 08                	push   $0x8
  801509:	e8 19 ff ff ff       	call   801427 <syscall>
  80150e:	83 c4 18             	add    $0x18,%esp
}
  801511:	c9                   	leave  
  801512:	c3                   	ret    

00801513 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801513:	55                   	push   %ebp
  801514:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801516:	6a 00                	push   $0x0
  801518:	6a 00                	push   $0x0
  80151a:	6a 00                	push   $0x0
  80151c:	6a 00                	push   $0x0
  80151e:	6a 00                	push   $0x0
  801520:	6a 09                	push   $0x9
  801522:	e8 00 ff ff ff       	call   801427 <syscall>
  801527:	83 c4 18             	add    $0x18,%esp
}
  80152a:	c9                   	leave  
  80152b:	c3                   	ret    

0080152c <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80152c:	55                   	push   %ebp
  80152d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80152f:	6a 00                	push   $0x0
  801531:	6a 00                	push   $0x0
  801533:	6a 00                	push   $0x0
  801535:	6a 00                	push   $0x0
  801537:	6a 00                	push   $0x0
  801539:	6a 0a                	push   $0xa
  80153b:	e8 e7 fe ff ff       	call   801427 <syscall>
  801540:	83 c4 18             	add    $0x18,%esp
}
  801543:	c9                   	leave  
  801544:	c3                   	ret    

00801545 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801545:	55                   	push   %ebp
  801546:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801548:	6a 00                	push   $0x0
  80154a:	6a 00                	push   $0x0
  80154c:	6a 00                	push   $0x0
  80154e:	6a 00                	push   $0x0
  801550:	6a 00                	push   $0x0
  801552:	6a 0b                	push   $0xb
  801554:	e8 ce fe ff ff       	call   801427 <syscall>
  801559:	83 c4 18             	add    $0x18,%esp
}
  80155c:	c9                   	leave  
  80155d:	c3                   	ret    

0080155e <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80155e:	55                   	push   %ebp
  80155f:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801561:	6a 00                	push   $0x0
  801563:	6a 00                	push   $0x0
  801565:	6a 00                	push   $0x0
  801567:	ff 75 0c             	pushl  0xc(%ebp)
  80156a:	ff 75 08             	pushl  0x8(%ebp)
  80156d:	6a 0f                	push   $0xf
  80156f:	e8 b3 fe ff ff       	call   801427 <syscall>
  801574:	83 c4 18             	add    $0x18,%esp
	return;
  801577:	90                   	nop
}
  801578:	c9                   	leave  
  801579:	c3                   	ret    

0080157a <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  80157a:	55                   	push   %ebp
  80157b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80157d:	6a 00                	push   $0x0
  80157f:	6a 00                	push   $0x0
  801581:	6a 00                	push   $0x0
  801583:	ff 75 0c             	pushl  0xc(%ebp)
  801586:	ff 75 08             	pushl  0x8(%ebp)
  801589:	6a 10                	push   $0x10
  80158b:	e8 97 fe ff ff       	call   801427 <syscall>
  801590:	83 c4 18             	add    $0x18,%esp
	return ;
  801593:	90                   	nop
}
  801594:	c9                   	leave  
  801595:	c3                   	ret    

00801596 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801596:	55                   	push   %ebp
  801597:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801599:	6a 00                	push   $0x0
  80159b:	6a 00                	push   $0x0
  80159d:	ff 75 10             	pushl  0x10(%ebp)
  8015a0:	ff 75 0c             	pushl  0xc(%ebp)
  8015a3:	ff 75 08             	pushl  0x8(%ebp)
  8015a6:	6a 11                	push   $0x11
  8015a8:	e8 7a fe ff ff       	call   801427 <syscall>
  8015ad:	83 c4 18             	add    $0x18,%esp
	return ;
  8015b0:	90                   	nop
}
  8015b1:	c9                   	leave  
  8015b2:	c3                   	ret    

008015b3 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8015b3:	55                   	push   %ebp
  8015b4:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8015b6:	6a 00                	push   $0x0
  8015b8:	6a 00                	push   $0x0
  8015ba:	6a 00                	push   $0x0
  8015bc:	6a 00                	push   $0x0
  8015be:	6a 00                	push   $0x0
  8015c0:	6a 0c                	push   $0xc
  8015c2:	e8 60 fe ff ff       	call   801427 <syscall>
  8015c7:	83 c4 18             	add    $0x18,%esp
}
  8015ca:	c9                   	leave  
  8015cb:	c3                   	ret    

008015cc <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8015cc:	55                   	push   %ebp
  8015cd:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8015cf:	6a 00                	push   $0x0
  8015d1:	6a 00                	push   $0x0
  8015d3:	6a 00                	push   $0x0
  8015d5:	6a 00                	push   $0x0
  8015d7:	ff 75 08             	pushl  0x8(%ebp)
  8015da:	6a 0d                	push   $0xd
  8015dc:	e8 46 fe ff ff       	call   801427 <syscall>
  8015e1:	83 c4 18             	add    $0x18,%esp
}
  8015e4:	c9                   	leave  
  8015e5:	c3                   	ret    

008015e6 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8015e6:	55                   	push   %ebp
  8015e7:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8015e9:	6a 00                	push   $0x0
  8015eb:	6a 00                	push   $0x0
  8015ed:	6a 00                	push   $0x0
  8015ef:	6a 00                	push   $0x0
  8015f1:	6a 00                	push   $0x0
  8015f3:	6a 0e                	push   $0xe
  8015f5:	e8 2d fe ff ff       	call   801427 <syscall>
  8015fa:	83 c4 18             	add    $0x18,%esp
}
  8015fd:	90                   	nop
  8015fe:	c9                   	leave  
  8015ff:	c3                   	ret    

00801600 <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  801600:	55                   	push   %ebp
  801601:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801603:	6a 00                	push   $0x0
  801605:	6a 00                	push   $0x0
  801607:	6a 00                	push   $0x0
  801609:	6a 00                	push   $0x0
  80160b:	6a 00                	push   $0x0
  80160d:	6a 13                	push   $0x13
  80160f:	e8 13 fe ff ff       	call   801427 <syscall>
  801614:	83 c4 18             	add    $0x18,%esp
}
  801617:	90                   	nop
  801618:	c9                   	leave  
  801619:	c3                   	ret    

0080161a <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  80161a:	55                   	push   %ebp
  80161b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80161d:	6a 00                	push   $0x0
  80161f:	6a 00                	push   $0x0
  801621:	6a 00                	push   $0x0
  801623:	6a 00                	push   $0x0
  801625:	6a 00                	push   $0x0
  801627:	6a 14                	push   $0x14
  801629:	e8 f9 fd ff ff       	call   801427 <syscall>
  80162e:	83 c4 18             	add    $0x18,%esp
}
  801631:	90                   	nop
  801632:	c9                   	leave  
  801633:	c3                   	ret    

00801634 <sys_cputc>:


void
sys_cputc(const char c)
{
  801634:	55                   	push   %ebp
  801635:	89 e5                	mov    %esp,%ebp
  801637:	83 ec 04             	sub    $0x4,%esp
  80163a:	8b 45 08             	mov    0x8(%ebp),%eax
  80163d:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  801640:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801644:	6a 00                	push   $0x0
  801646:	6a 00                	push   $0x0
  801648:	6a 00                	push   $0x0
  80164a:	6a 00                	push   $0x0
  80164c:	50                   	push   %eax
  80164d:	6a 15                	push   $0x15
  80164f:	e8 d3 fd ff ff       	call   801427 <syscall>
  801654:	83 c4 18             	add    $0x18,%esp
}
  801657:	90                   	nop
  801658:	c9                   	leave  
  801659:	c3                   	ret    

0080165a <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  80165a:	55                   	push   %ebp
  80165b:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80165d:	6a 00                	push   $0x0
  80165f:	6a 00                	push   $0x0
  801661:	6a 00                	push   $0x0
  801663:	6a 00                	push   $0x0
  801665:	6a 00                	push   $0x0
  801667:	6a 16                	push   $0x16
  801669:	e8 b9 fd ff ff       	call   801427 <syscall>
  80166e:	83 c4 18             	add    $0x18,%esp
}
  801671:	90                   	nop
  801672:	c9                   	leave  
  801673:	c3                   	ret    

00801674 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801674:	55                   	push   %ebp
  801675:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801677:	8b 45 08             	mov    0x8(%ebp),%eax
  80167a:	6a 00                	push   $0x0
  80167c:	6a 00                	push   $0x0
  80167e:	6a 00                	push   $0x0
  801680:	ff 75 0c             	pushl  0xc(%ebp)
  801683:	50                   	push   %eax
  801684:	6a 17                	push   $0x17
  801686:	e8 9c fd ff ff       	call   801427 <syscall>
  80168b:	83 c4 18             	add    $0x18,%esp
}
  80168e:	c9                   	leave  
  80168f:	c3                   	ret    

00801690 <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  801690:	55                   	push   %ebp
  801691:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801693:	8b 55 0c             	mov    0xc(%ebp),%edx
  801696:	8b 45 08             	mov    0x8(%ebp),%eax
  801699:	6a 00                	push   $0x0
  80169b:	6a 00                	push   $0x0
  80169d:	6a 00                	push   $0x0
  80169f:	52                   	push   %edx
  8016a0:	50                   	push   %eax
  8016a1:	6a 1a                	push   $0x1a
  8016a3:	e8 7f fd ff ff       	call   801427 <syscall>
  8016a8:	83 c4 18             	add    $0x18,%esp
}
  8016ab:	c9                   	leave  
  8016ac:	c3                   	ret    

008016ad <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8016ad:	55                   	push   %ebp
  8016ae:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8016b0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016b3:	8b 45 08             	mov    0x8(%ebp),%eax
  8016b6:	6a 00                	push   $0x0
  8016b8:	6a 00                	push   $0x0
  8016ba:	6a 00                	push   $0x0
  8016bc:	52                   	push   %edx
  8016bd:	50                   	push   %eax
  8016be:	6a 18                	push   $0x18
  8016c0:	e8 62 fd ff ff       	call   801427 <syscall>
  8016c5:	83 c4 18             	add    $0x18,%esp
}
  8016c8:	90                   	nop
  8016c9:	c9                   	leave  
  8016ca:	c3                   	ret    

008016cb <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8016cb:	55                   	push   %ebp
  8016cc:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8016ce:	8b 55 0c             	mov    0xc(%ebp),%edx
  8016d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8016d4:	6a 00                	push   $0x0
  8016d6:	6a 00                	push   $0x0
  8016d8:	6a 00                	push   $0x0
  8016da:	52                   	push   %edx
  8016db:	50                   	push   %eax
  8016dc:	6a 19                	push   $0x19
  8016de:	e8 44 fd ff ff       	call   801427 <syscall>
  8016e3:	83 c4 18             	add    $0x18,%esp
}
  8016e6:	90                   	nop
  8016e7:	c9                   	leave  
  8016e8:	c3                   	ret    

008016e9 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8016e9:	55                   	push   %ebp
  8016ea:	89 e5                	mov    %esp,%ebp
  8016ec:	83 ec 04             	sub    $0x4,%esp
  8016ef:	8b 45 10             	mov    0x10(%ebp),%eax
  8016f2:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8016f5:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8016f8:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8016fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8016ff:	6a 00                	push   $0x0
  801701:	51                   	push   %ecx
  801702:	52                   	push   %edx
  801703:	ff 75 0c             	pushl  0xc(%ebp)
  801706:	50                   	push   %eax
  801707:	6a 1b                	push   $0x1b
  801709:	e8 19 fd ff ff       	call   801427 <syscall>
  80170e:	83 c4 18             	add    $0x18,%esp
}
  801711:	c9                   	leave  
  801712:	c3                   	ret    

00801713 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801713:	55                   	push   %ebp
  801714:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801716:	8b 55 0c             	mov    0xc(%ebp),%edx
  801719:	8b 45 08             	mov    0x8(%ebp),%eax
  80171c:	6a 00                	push   $0x0
  80171e:	6a 00                	push   $0x0
  801720:	6a 00                	push   $0x0
  801722:	52                   	push   %edx
  801723:	50                   	push   %eax
  801724:	6a 1c                	push   $0x1c
  801726:	e8 fc fc ff ff       	call   801427 <syscall>
  80172b:	83 c4 18             	add    $0x18,%esp
}
  80172e:	c9                   	leave  
  80172f:	c3                   	ret    

00801730 <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  801730:	55                   	push   %ebp
  801731:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801733:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801736:	8b 55 0c             	mov    0xc(%ebp),%edx
  801739:	8b 45 08             	mov    0x8(%ebp),%eax
  80173c:	6a 00                	push   $0x0
  80173e:	6a 00                	push   $0x0
  801740:	51                   	push   %ecx
  801741:	52                   	push   %edx
  801742:	50                   	push   %eax
  801743:	6a 1d                	push   $0x1d
  801745:	e8 dd fc ff ff       	call   801427 <syscall>
  80174a:	83 c4 18             	add    $0x18,%esp
}
  80174d:	c9                   	leave  
  80174e:	c3                   	ret    

0080174f <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80174f:	55                   	push   %ebp
  801750:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801752:	8b 55 0c             	mov    0xc(%ebp),%edx
  801755:	8b 45 08             	mov    0x8(%ebp),%eax
  801758:	6a 00                	push   $0x0
  80175a:	6a 00                	push   $0x0
  80175c:	6a 00                	push   $0x0
  80175e:	52                   	push   %edx
  80175f:	50                   	push   %eax
  801760:	6a 1e                	push   $0x1e
  801762:	e8 c0 fc ff ff       	call   801427 <syscall>
  801767:	83 c4 18             	add    $0x18,%esp
}
  80176a:	c9                   	leave  
  80176b:	c3                   	ret    

0080176c <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80176c:	55                   	push   %ebp
  80176d:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80176f:	6a 00                	push   $0x0
  801771:	6a 00                	push   $0x0
  801773:	6a 00                	push   $0x0
  801775:	6a 00                	push   $0x0
  801777:	6a 00                	push   $0x0
  801779:	6a 1f                	push   $0x1f
  80177b:	e8 a7 fc ff ff       	call   801427 <syscall>
  801780:	83 c4 18             	add    $0x18,%esp
}
  801783:	c9                   	leave  
  801784:	c3                   	ret    

00801785 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801785:	55                   	push   %ebp
  801786:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801788:	8b 45 08             	mov    0x8(%ebp),%eax
  80178b:	6a 00                	push   $0x0
  80178d:	ff 75 14             	pushl  0x14(%ebp)
  801790:	ff 75 10             	pushl  0x10(%ebp)
  801793:	ff 75 0c             	pushl  0xc(%ebp)
  801796:	50                   	push   %eax
  801797:	6a 20                	push   $0x20
  801799:	e8 89 fc ff ff       	call   801427 <syscall>
  80179e:	83 c4 18             	add    $0x18,%esp
}
  8017a1:	c9                   	leave  
  8017a2:	c3                   	ret    

008017a3 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8017a3:	55                   	push   %ebp
  8017a4:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8017a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8017a9:	6a 00                	push   $0x0
  8017ab:	6a 00                	push   $0x0
  8017ad:	6a 00                	push   $0x0
  8017af:	6a 00                	push   $0x0
  8017b1:	50                   	push   %eax
  8017b2:	6a 21                	push   $0x21
  8017b4:	e8 6e fc ff ff       	call   801427 <syscall>
  8017b9:	83 c4 18             	add    $0x18,%esp
}
  8017bc:	90                   	nop
  8017bd:	c9                   	leave  
  8017be:	c3                   	ret    

008017bf <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8017bf:	55                   	push   %ebp
  8017c0:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8017c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017c5:	6a 00                	push   $0x0
  8017c7:	6a 00                	push   $0x0
  8017c9:	6a 00                	push   $0x0
  8017cb:	6a 00                	push   $0x0
  8017cd:	50                   	push   %eax
  8017ce:	6a 22                	push   $0x22
  8017d0:	e8 52 fc ff ff       	call   801427 <syscall>
  8017d5:	83 c4 18             	add    $0x18,%esp
}
  8017d8:	c9                   	leave  
  8017d9:	c3                   	ret    

008017da <sys_getenvid>:

int32 sys_getenvid(void)
{
  8017da:	55                   	push   %ebp
  8017db:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8017dd:	6a 00                	push   $0x0
  8017df:	6a 00                	push   $0x0
  8017e1:	6a 00                	push   $0x0
  8017e3:	6a 00                	push   $0x0
  8017e5:	6a 00                	push   $0x0
  8017e7:	6a 02                	push   $0x2
  8017e9:	e8 39 fc ff ff       	call   801427 <syscall>
  8017ee:	83 c4 18             	add    $0x18,%esp
}
  8017f1:	c9                   	leave  
  8017f2:	c3                   	ret    

008017f3 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8017f3:	55                   	push   %ebp
  8017f4:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8017f6:	6a 00                	push   $0x0
  8017f8:	6a 00                	push   $0x0
  8017fa:	6a 00                	push   $0x0
  8017fc:	6a 00                	push   $0x0
  8017fe:	6a 00                	push   $0x0
  801800:	6a 03                	push   $0x3
  801802:	e8 20 fc ff ff       	call   801427 <syscall>
  801807:	83 c4 18             	add    $0x18,%esp
}
  80180a:	c9                   	leave  
  80180b:	c3                   	ret    

0080180c <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80180c:	55                   	push   %ebp
  80180d:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80180f:	6a 00                	push   $0x0
  801811:	6a 00                	push   $0x0
  801813:	6a 00                	push   $0x0
  801815:	6a 00                	push   $0x0
  801817:	6a 00                	push   $0x0
  801819:	6a 04                	push   $0x4
  80181b:	e8 07 fc ff ff       	call   801427 <syscall>
  801820:	83 c4 18             	add    $0x18,%esp
}
  801823:	c9                   	leave  
  801824:	c3                   	ret    

00801825 <sys_exit_env>:


void sys_exit_env(void)
{
  801825:	55                   	push   %ebp
  801826:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801828:	6a 00                	push   $0x0
  80182a:	6a 00                	push   $0x0
  80182c:	6a 00                	push   $0x0
  80182e:	6a 00                	push   $0x0
  801830:	6a 00                	push   $0x0
  801832:	6a 23                	push   $0x23
  801834:	e8 ee fb ff ff       	call   801427 <syscall>
  801839:	83 c4 18             	add    $0x18,%esp
}
  80183c:	90                   	nop
  80183d:	c9                   	leave  
  80183e:	c3                   	ret    

0080183f <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  80183f:	55                   	push   %ebp
  801840:	89 e5                	mov    %esp,%ebp
  801842:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801845:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801848:	8d 50 04             	lea    0x4(%eax),%edx
  80184b:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80184e:	6a 00                	push   $0x0
  801850:	6a 00                	push   $0x0
  801852:	6a 00                	push   $0x0
  801854:	52                   	push   %edx
  801855:	50                   	push   %eax
  801856:	6a 24                	push   $0x24
  801858:	e8 ca fb ff ff       	call   801427 <syscall>
  80185d:	83 c4 18             	add    $0x18,%esp
	return result;
  801860:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801863:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801866:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801869:	89 01                	mov    %eax,(%ecx)
  80186b:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80186e:	8b 45 08             	mov    0x8(%ebp),%eax
  801871:	c9                   	leave  
  801872:	c2 04 00             	ret    $0x4

00801875 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801875:	55                   	push   %ebp
  801876:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801878:	6a 00                	push   $0x0
  80187a:	6a 00                	push   $0x0
  80187c:	ff 75 10             	pushl  0x10(%ebp)
  80187f:	ff 75 0c             	pushl  0xc(%ebp)
  801882:	ff 75 08             	pushl  0x8(%ebp)
  801885:	6a 12                	push   $0x12
  801887:	e8 9b fb ff ff       	call   801427 <syscall>
  80188c:	83 c4 18             	add    $0x18,%esp
	return ;
  80188f:	90                   	nop
}
  801890:	c9                   	leave  
  801891:	c3                   	ret    

00801892 <sys_rcr2>:
uint32 sys_rcr2()
{
  801892:	55                   	push   %ebp
  801893:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801895:	6a 00                	push   $0x0
  801897:	6a 00                	push   $0x0
  801899:	6a 00                	push   $0x0
  80189b:	6a 00                	push   $0x0
  80189d:	6a 00                	push   $0x0
  80189f:	6a 25                	push   $0x25
  8018a1:	e8 81 fb ff ff       	call   801427 <syscall>
  8018a6:	83 c4 18             	add    $0x18,%esp
}
  8018a9:	c9                   	leave  
  8018aa:	c3                   	ret    

008018ab <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8018ab:	55                   	push   %ebp
  8018ac:	89 e5                	mov    %esp,%ebp
  8018ae:	83 ec 04             	sub    $0x4,%esp
  8018b1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018b4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8018b7:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8018bb:	6a 00                	push   $0x0
  8018bd:	6a 00                	push   $0x0
  8018bf:	6a 00                	push   $0x0
  8018c1:	6a 00                	push   $0x0
  8018c3:	50                   	push   %eax
  8018c4:	6a 26                	push   $0x26
  8018c6:	e8 5c fb ff ff       	call   801427 <syscall>
  8018cb:	83 c4 18             	add    $0x18,%esp
	return ;
  8018ce:	90                   	nop
}
  8018cf:	c9                   	leave  
  8018d0:	c3                   	ret    

008018d1 <rsttst>:
void rsttst()
{
  8018d1:	55                   	push   %ebp
  8018d2:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8018d4:	6a 00                	push   $0x0
  8018d6:	6a 00                	push   $0x0
  8018d8:	6a 00                	push   $0x0
  8018da:	6a 00                	push   $0x0
  8018dc:	6a 00                	push   $0x0
  8018de:	6a 28                	push   $0x28
  8018e0:	e8 42 fb ff ff       	call   801427 <syscall>
  8018e5:	83 c4 18             	add    $0x18,%esp
	return ;
  8018e8:	90                   	nop
}
  8018e9:	c9                   	leave  
  8018ea:	c3                   	ret    

008018eb <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8018eb:	55                   	push   %ebp
  8018ec:	89 e5                	mov    %esp,%ebp
  8018ee:	83 ec 04             	sub    $0x4,%esp
  8018f1:	8b 45 14             	mov    0x14(%ebp),%eax
  8018f4:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8018f7:	8b 55 18             	mov    0x18(%ebp),%edx
  8018fa:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8018fe:	52                   	push   %edx
  8018ff:	50                   	push   %eax
  801900:	ff 75 10             	pushl  0x10(%ebp)
  801903:	ff 75 0c             	pushl  0xc(%ebp)
  801906:	ff 75 08             	pushl  0x8(%ebp)
  801909:	6a 27                	push   $0x27
  80190b:	e8 17 fb ff ff       	call   801427 <syscall>
  801910:	83 c4 18             	add    $0x18,%esp
	return ;
  801913:	90                   	nop
}
  801914:	c9                   	leave  
  801915:	c3                   	ret    

00801916 <chktst>:
void chktst(uint32 n)
{
  801916:	55                   	push   %ebp
  801917:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801919:	6a 00                	push   $0x0
  80191b:	6a 00                	push   $0x0
  80191d:	6a 00                	push   $0x0
  80191f:	6a 00                	push   $0x0
  801921:	ff 75 08             	pushl  0x8(%ebp)
  801924:	6a 29                	push   $0x29
  801926:	e8 fc fa ff ff       	call   801427 <syscall>
  80192b:	83 c4 18             	add    $0x18,%esp
	return ;
  80192e:	90                   	nop
}
  80192f:	c9                   	leave  
  801930:	c3                   	ret    

00801931 <inctst>:

void inctst()
{
  801931:	55                   	push   %ebp
  801932:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801934:	6a 00                	push   $0x0
  801936:	6a 00                	push   $0x0
  801938:	6a 00                	push   $0x0
  80193a:	6a 00                	push   $0x0
  80193c:	6a 00                	push   $0x0
  80193e:	6a 2a                	push   $0x2a
  801940:	e8 e2 fa ff ff       	call   801427 <syscall>
  801945:	83 c4 18             	add    $0x18,%esp
	return ;
  801948:	90                   	nop
}
  801949:	c9                   	leave  
  80194a:	c3                   	ret    

0080194b <gettst>:
uint32 gettst()
{
  80194b:	55                   	push   %ebp
  80194c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  80194e:	6a 00                	push   $0x0
  801950:	6a 00                	push   $0x0
  801952:	6a 00                	push   $0x0
  801954:	6a 00                	push   $0x0
  801956:	6a 00                	push   $0x0
  801958:	6a 2b                	push   $0x2b
  80195a:	e8 c8 fa ff ff       	call   801427 <syscall>
  80195f:	83 c4 18             	add    $0x18,%esp
}
  801962:	c9                   	leave  
  801963:	c3                   	ret    

00801964 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801964:	55                   	push   %ebp
  801965:	89 e5                	mov    %esp,%ebp
  801967:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80196a:	6a 00                	push   $0x0
  80196c:	6a 00                	push   $0x0
  80196e:	6a 00                	push   $0x0
  801970:	6a 00                	push   $0x0
  801972:	6a 00                	push   $0x0
  801974:	6a 2c                	push   $0x2c
  801976:	e8 ac fa ff ff       	call   801427 <syscall>
  80197b:	83 c4 18             	add    $0x18,%esp
  80197e:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801981:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801985:	75 07                	jne    80198e <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801987:	b8 01 00 00 00       	mov    $0x1,%eax
  80198c:	eb 05                	jmp    801993 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  80198e:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801993:	c9                   	leave  
  801994:	c3                   	ret    

00801995 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801995:	55                   	push   %ebp
  801996:	89 e5                	mov    %esp,%ebp
  801998:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  80199b:	6a 00                	push   $0x0
  80199d:	6a 00                	push   $0x0
  80199f:	6a 00                	push   $0x0
  8019a1:	6a 00                	push   $0x0
  8019a3:	6a 00                	push   $0x0
  8019a5:	6a 2c                	push   $0x2c
  8019a7:	e8 7b fa ff ff       	call   801427 <syscall>
  8019ac:	83 c4 18             	add    $0x18,%esp
  8019af:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  8019b2:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  8019b6:	75 07                	jne    8019bf <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  8019b8:	b8 01 00 00 00       	mov    $0x1,%eax
  8019bd:	eb 05                	jmp    8019c4 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  8019bf:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019c4:	c9                   	leave  
  8019c5:	c3                   	ret    

008019c6 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  8019c6:	55                   	push   %ebp
  8019c7:	89 e5                	mov    %esp,%ebp
  8019c9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8019cc:	6a 00                	push   $0x0
  8019ce:	6a 00                	push   $0x0
  8019d0:	6a 00                	push   $0x0
  8019d2:	6a 00                	push   $0x0
  8019d4:	6a 00                	push   $0x0
  8019d6:	6a 2c                	push   $0x2c
  8019d8:	e8 4a fa ff ff       	call   801427 <syscall>
  8019dd:	83 c4 18             	add    $0x18,%esp
  8019e0:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  8019e3:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  8019e7:	75 07                	jne    8019f0 <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  8019e9:	b8 01 00 00 00       	mov    $0x1,%eax
  8019ee:	eb 05                	jmp    8019f5 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  8019f0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8019f5:	c9                   	leave  
  8019f6:	c3                   	ret    

008019f7 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  8019f7:	55                   	push   %ebp
  8019f8:	89 e5                	mov    %esp,%ebp
  8019fa:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  8019fd:	6a 00                	push   $0x0
  8019ff:	6a 00                	push   $0x0
  801a01:	6a 00                	push   $0x0
  801a03:	6a 00                	push   $0x0
  801a05:	6a 00                	push   $0x0
  801a07:	6a 2c                	push   $0x2c
  801a09:	e8 19 fa ff ff       	call   801427 <syscall>
  801a0e:	83 c4 18             	add    $0x18,%esp
  801a11:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801a14:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801a18:	75 07                	jne    801a21 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801a1a:	b8 01 00 00 00       	mov    $0x1,%eax
  801a1f:	eb 05                	jmp    801a26 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801a21:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a26:	c9                   	leave  
  801a27:	c3                   	ret    

00801a28 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801a28:	55                   	push   %ebp
  801a29:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801a2b:	6a 00                	push   $0x0
  801a2d:	6a 00                	push   $0x0
  801a2f:	6a 00                	push   $0x0
  801a31:	6a 00                	push   $0x0
  801a33:	ff 75 08             	pushl  0x8(%ebp)
  801a36:	6a 2d                	push   $0x2d
  801a38:	e8 ea f9 ff ff       	call   801427 <syscall>
  801a3d:	83 c4 18             	add    $0x18,%esp
	return ;
  801a40:	90                   	nop
}
  801a41:	c9                   	leave  
  801a42:	c3                   	ret    

00801a43 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801a43:	55                   	push   %ebp
  801a44:	89 e5                	mov    %esp,%ebp
  801a46:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801a47:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801a4a:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801a4d:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a50:	8b 45 08             	mov    0x8(%ebp),%eax
  801a53:	6a 00                	push   $0x0
  801a55:	53                   	push   %ebx
  801a56:	51                   	push   %ecx
  801a57:	52                   	push   %edx
  801a58:	50                   	push   %eax
  801a59:	6a 2e                	push   $0x2e
  801a5b:	e8 c7 f9 ff ff       	call   801427 <syscall>
  801a60:	83 c4 18             	add    $0x18,%esp
}
  801a63:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801a66:	c9                   	leave  
  801a67:	c3                   	ret    

00801a68 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801a68:	55                   	push   %ebp
  801a69:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801a6b:	8b 55 0c             	mov    0xc(%ebp),%edx
  801a6e:	8b 45 08             	mov    0x8(%ebp),%eax
  801a71:	6a 00                	push   $0x0
  801a73:	6a 00                	push   $0x0
  801a75:	6a 00                	push   $0x0
  801a77:	52                   	push   %edx
  801a78:	50                   	push   %eax
  801a79:	6a 2f                	push   $0x2f
  801a7b:	e8 a7 f9 ff ff       	call   801427 <syscall>
  801a80:	83 c4 18             	add    $0x18,%esp
}
  801a83:	c9                   	leave  
  801a84:	c3                   	ret    

00801a85 <env_sleep>:
#include <inc/lib.h>
#include <inc/timerreg.h>

void
env_sleep(uint32 approxMilliSeconds)
{
  801a85:	55                   	push   %ebp
  801a86:	89 e5                	mov    %esp,%ebp
  801a88:	83 ec 28             	sub    $0x28,%esp
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
  801a8b:	8b 55 08             	mov    0x8(%ebp),%edx
  801a8e:	89 d0                	mov    %edx,%eax
  801a90:	c1 e0 02             	shl    $0x2,%eax
  801a93:	01 d0                	add    %edx,%eax
  801a95:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801a9c:	01 d0                	add    %edx,%eax
  801a9e:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801aa5:	01 d0                	add    %edx,%eax
  801aa7:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801aae:	01 d0                	add    %edx,%eax
  801ab0:	c1 e0 04             	shl    $0x4,%eax
  801ab3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	uint32 cycles_counter =0;
  801ab6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	struct uint64 baseTime = sys_get_virtual_time() ;
  801abd:	8d 45 e8             	lea    -0x18(%ebp),%eax
  801ac0:	83 ec 0c             	sub    $0xc,%esp
  801ac3:	50                   	push   %eax
  801ac4:	e8 76 fd ff ff       	call   80183f <sys_get_virtual_time>
  801ac9:	83 c4 0c             	add    $0xc,%esp
	while(cycles_counter<time_in_cycles)
  801acc:	eb 41                	jmp    801b0f <env_sleep+0x8a>
	{
		struct uint64 currentTime = sys_get_virtual_time() ;
  801ace:	8d 45 e0             	lea    -0x20(%ebp),%eax
  801ad1:	83 ec 0c             	sub    $0xc,%esp
  801ad4:	50                   	push   %eax
  801ad5:	e8 65 fd ff ff       	call   80183f <sys_get_virtual_time>
  801ada:	83 c4 0c             	add    $0xc,%esp

		// update the cycles_count
		#define M32 0xffffffff
		// subtract basetime from current time
		struct uint64 res;
		res.low = (currentTime.low - baseTime.low) & M32;
  801add:	8b 55 e0             	mov    -0x20(%ebp),%edx
  801ae0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801ae3:	29 c2                	sub    %eax,%edx
  801ae5:	89 d0                	mov    %edx,%eax
  801ae7:	89 45 d8             	mov    %eax,-0x28(%ebp)
		res.hi = (currentTime.hi - baseTime.hi - (res.low > currentTime.low)) & M32;
  801aea:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  801aed:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801af0:	89 d1                	mov    %edx,%ecx
  801af2:	29 c1                	sub    %eax,%ecx
  801af4:	8b 55 d8             	mov    -0x28(%ebp),%edx
  801af7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801afa:	39 c2                	cmp    %eax,%edx
  801afc:	0f 97 c0             	seta   %al
  801aff:	0f b6 c0             	movzbl %al,%eax
  801b02:	29 c1                	sub    %eax,%ecx
  801b04:	89 c8                	mov    %ecx,%eax
  801b06:	89 45 dc             	mov    %eax,-0x24(%ebp)

		//update cycles_count with result
		cycles_counter = res.low;
  801b09:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801b0c:	89 45 f4             	mov    %eax,-0xc(%ebp)
//	cprintf("%s go to sleep...\n", myEnv->prog_name);
	uint32 time_in_cycles=approxMilliSeconds*CYCLES_PER_MILLISEC;
	uint32 cycles_counter =0;

	struct uint64 baseTime = sys_get_virtual_time() ;
	while(cycles_counter<time_in_cycles)
  801b0f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801b12:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801b15:	72 b7                	jb     801ace <env_sleep+0x49>
//				,cycles_counter
//				);
	}
	//cprintf("%s [%d] wake up now!\n", myEnv->prog_name, myEnv->env_id);

}
  801b17:	90                   	nop
  801b18:	c9                   	leave  
  801b19:	c3                   	ret    

00801b1a <busy_wait>:

//2017
uint32 busy_wait(uint32 loopMax)
{
  801b1a:	55                   	push   %ebp
  801b1b:	89 e5                	mov    %esp,%ebp
  801b1d:	83 ec 10             	sub    $0x10,%esp
	uint32 i = 0 ;
  801b20:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	while (i < loopMax) i++;
  801b27:	eb 03                	jmp    801b2c <busy_wait+0x12>
  801b29:	ff 45 fc             	incl   -0x4(%ebp)
  801b2c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801b2f:	3b 45 08             	cmp    0x8(%ebp),%eax
  801b32:	72 f5                	jb     801b29 <busy_wait+0xf>
	return i;
  801b34:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  801b37:	c9                   	leave  
  801b38:	c3                   	ret    
  801b39:	66 90                	xchg   %ax,%ax
  801b3b:	90                   	nop

00801b3c <__udivdi3>:
  801b3c:	55                   	push   %ebp
  801b3d:	57                   	push   %edi
  801b3e:	56                   	push   %esi
  801b3f:	53                   	push   %ebx
  801b40:	83 ec 1c             	sub    $0x1c,%esp
  801b43:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801b47:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801b4b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b4f:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801b53:	89 ca                	mov    %ecx,%edx
  801b55:	89 f8                	mov    %edi,%eax
  801b57:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801b5b:	85 f6                	test   %esi,%esi
  801b5d:	75 2d                	jne    801b8c <__udivdi3+0x50>
  801b5f:	39 cf                	cmp    %ecx,%edi
  801b61:	77 65                	ja     801bc8 <__udivdi3+0x8c>
  801b63:	89 fd                	mov    %edi,%ebp
  801b65:	85 ff                	test   %edi,%edi
  801b67:	75 0b                	jne    801b74 <__udivdi3+0x38>
  801b69:	b8 01 00 00 00       	mov    $0x1,%eax
  801b6e:	31 d2                	xor    %edx,%edx
  801b70:	f7 f7                	div    %edi
  801b72:	89 c5                	mov    %eax,%ebp
  801b74:	31 d2                	xor    %edx,%edx
  801b76:	89 c8                	mov    %ecx,%eax
  801b78:	f7 f5                	div    %ebp
  801b7a:	89 c1                	mov    %eax,%ecx
  801b7c:	89 d8                	mov    %ebx,%eax
  801b7e:	f7 f5                	div    %ebp
  801b80:	89 cf                	mov    %ecx,%edi
  801b82:	89 fa                	mov    %edi,%edx
  801b84:	83 c4 1c             	add    $0x1c,%esp
  801b87:	5b                   	pop    %ebx
  801b88:	5e                   	pop    %esi
  801b89:	5f                   	pop    %edi
  801b8a:	5d                   	pop    %ebp
  801b8b:	c3                   	ret    
  801b8c:	39 ce                	cmp    %ecx,%esi
  801b8e:	77 28                	ja     801bb8 <__udivdi3+0x7c>
  801b90:	0f bd fe             	bsr    %esi,%edi
  801b93:	83 f7 1f             	xor    $0x1f,%edi
  801b96:	75 40                	jne    801bd8 <__udivdi3+0x9c>
  801b98:	39 ce                	cmp    %ecx,%esi
  801b9a:	72 0a                	jb     801ba6 <__udivdi3+0x6a>
  801b9c:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801ba0:	0f 87 9e 00 00 00    	ja     801c44 <__udivdi3+0x108>
  801ba6:	b8 01 00 00 00       	mov    $0x1,%eax
  801bab:	89 fa                	mov    %edi,%edx
  801bad:	83 c4 1c             	add    $0x1c,%esp
  801bb0:	5b                   	pop    %ebx
  801bb1:	5e                   	pop    %esi
  801bb2:	5f                   	pop    %edi
  801bb3:	5d                   	pop    %ebp
  801bb4:	c3                   	ret    
  801bb5:	8d 76 00             	lea    0x0(%esi),%esi
  801bb8:	31 ff                	xor    %edi,%edi
  801bba:	31 c0                	xor    %eax,%eax
  801bbc:	89 fa                	mov    %edi,%edx
  801bbe:	83 c4 1c             	add    $0x1c,%esp
  801bc1:	5b                   	pop    %ebx
  801bc2:	5e                   	pop    %esi
  801bc3:	5f                   	pop    %edi
  801bc4:	5d                   	pop    %ebp
  801bc5:	c3                   	ret    
  801bc6:	66 90                	xchg   %ax,%ax
  801bc8:	89 d8                	mov    %ebx,%eax
  801bca:	f7 f7                	div    %edi
  801bcc:	31 ff                	xor    %edi,%edi
  801bce:	89 fa                	mov    %edi,%edx
  801bd0:	83 c4 1c             	add    $0x1c,%esp
  801bd3:	5b                   	pop    %ebx
  801bd4:	5e                   	pop    %esi
  801bd5:	5f                   	pop    %edi
  801bd6:	5d                   	pop    %ebp
  801bd7:	c3                   	ret    
  801bd8:	bd 20 00 00 00       	mov    $0x20,%ebp
  801bdd:	89 eb                	mov    %ebp,%ebx
  801bdf:	29 fb                	sub    %edi,%ebx
  801be1:	89 f9                	mov    %edi,%ecx
  801be3:	d3 e6                	shl    %cl,%esi
  801be5:	89 c5                	mov    %eax,%ebp
  801be7:	88 d9                	mov    %bl,%cl
  801be9:	d3 ed                	shr    %cl,%ebp
  801beb:	89 e9                	mov    %ebp,%ecx
  801bed:	09 f1                	or     %esi,%ecx
  801bef:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801bf3:	89 f9                	mov    %edi,%ecx
  801bf5:	d3 e0                	shl    %cl,%eax
  801bf7:	89 c5                	mov    %eax,%ebp
  801bf9:	89 d6                	mov    %edx,%esi
  801bfb:	88 d9                	mov    %bl,%cl
  801bfd:	d3 ee                	shr    %cl,%esi
  801bff:	89 f9                	mov    %edi,%ecx
  801c01:	d3 e2                	shl    %cl,%edx
  801c03:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c07:	88 d9                	mov    %bl,%cl
  801c09:	d3 e8                	shr    %cl,%eax
  801c0b:	09 c2                	or     %eax,%edx
  801c0d:	89 d0                	mov    %edx,%eax
  801c0f:	89 f2                	mov    %esi,%edx
  801c11:	f7 74 24 0c          	divl   0xc(%esp)
  801c15:	89 d6                	mov    %edx,%esi
  801c17:	89 c3                	mov    %eax,%ebx
  801c19:	f7 e5                	mul    %ebp
  801c1b:	39 d6                	cmp    %edx,%esi
  801c1d:	72 19                	jb     801c38 <__udivdi3+0xfc>
  801c1f:	74 0b                	je     801c2c <__udivdi3+0xf0>
  801c21:	89 d8                	mov    %ebx,%eax
  801c23:	31 ff                	xor    %edi,%edi
  801c25:	e9 58 ff ff ff       	jmp    801b82 <__udivdi3+0x46>
  801c2a:	66 90                	xchg   %ax,%ax
  801c2c:	8b 54 24 08          	mov    0x8(%esp),%edx
  801c30:	89 f9                	mov    %edi,%ecx
  801c32:	d3 e2                	shl    %cl,%edx
  801c34:	39 c2                	cmp    %eax,%edx
  801c36:	73 e9                	jae    801c21 <__udivdi3+0xe5>
  801c38:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801c3b:	31 ff                	xor    %edi,%edi
  801c3d:	e9 40 ff ff ff       	jmp    801b82 <__udivdi3+0x46>
  801c42:	66 90                	xchg   %ax,%ax
  801c44:	31 c0                	xor    %eax,%eax
  801c46:	e9 37 ff ff ff       	jmp    801b82 <__udivdi3+0x46>
  801c4b:	90                   	nop

00801c4c <__umoddi3>:
  801c4c:	55                   	push   %ebp
  801c4d:	57                   	push   %edi
  801c4e:	56                   	push   %esi
  801c4f:	53                   	push   %ebx
  801c50:	83 ec 1c             	sub    $0x1c,%esp
  801c53:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801c57:	8b 74 24 34          	mov    0x34(%esp),%esi
  801c5b:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801c5f:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801c63:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801c67:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801c6b:	89 f3                	mov    %esi,%ebx
  801c6d:	89 fa                	mov    %edi,%edx
  801c6f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801c73:	89 34 24             	mov    %esi,(%esp)
  801c76:	85 c0                	test   %eax,%eax
  801c78:	75 1a                	jne    801c94 <__umoddi3+0x48>
  801c7a:	39 f7                	cmp    %esi,%edi
  801c7c:	0f 86 a2 00 00 00    	jbe    801d24 <__umoddi3+0xd8>
  801c82:	89 c8                	mov    %ecx,%eax
  801c84:	89 f2                	mov    %esi,%edx
  801c86:	f7 f7                	div    %edi
  801c88:	89 d0                	mov    %edx,%eax
  801c8a:	31 d2                	xor    %edx,%edx
  801c8c:	83 c4 1c             	add    $0x1c,%esp
  801c8f:	5b                   	pop    %ebx
  801c90:	5e                   	pop    %esi
  801c91:	5f                   	pop    %edi
  801c92:	5d                   	pop    %ebp
  801c93:	c3                   	ret    
  801c94:	39 f0                	cmp    %esi,%eax
  801c96:	0f 87 ac 00 00 00    	ja     801d48 <__umoddi3+0xfc>
  801c9c:	0f bd e8             	bsr    %eax,%ebp
  801c9f:	83 f5 1f             	xor    $0x1f,%ebp
  801ca2:	0f 84 ac 00 00 00    	je     801d54 <__umoddi3+0x108>
  801ca8:	bf 20 00 00 00       	mov    $0x20,%edi
  801cad:	29 ef                	sub    %ebp,%edi
  801caf:	89 fe                	mov    %edi,%esi
  801cb1:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801cb5:	89 e9                	mov    %ebp,%ecx
  801cb7:	d3 e0                	shl    %cl,%eax
  801cb9:	89 d7                	mov    %edx,%edi
  801cbb:	89 f1                	mov    %esi,%ecx
  801cbd:	d3 ef                	shr    %cl,%edi
  801cbf:	09 c7                	or     %eax,%edi
  801cc1:	89 e9                	mov    %ebp,%ecx
  801cc3:	d3 e2                	shl    %cl,%edx
  801cc5:	89 14 24             	mov    %edx,(%esp)
  801cc8:	89 d8                	mov    %ebx,%eax
  801cca:	d3 e0                	shl    %cl,%eax
  801ccc:	89 c2                	mov    %eax,%edx
  801cce:	8b 44 24 08          	mov    0x8(%esp),%eax
  801cd2:	d3 e0                	shl    %cl,%eax
  801cd4:	89 44 24 04          	mov    %eax,0x4(%esp)
  801cd8:	8b 44 24 08          	mov    0x8(%esp),%eax
  801cdc:	89 f1                	mov    %esi,%ecx
  801cde:	d3 e8                	shr    %cl,%eax
  801ce0:	09 d0                	or     %edx,%eax
  801ce2:	d3 eb                	shr    %cl,%ebx
  801ce4:	89 da                	mov    %ebx,%edx
  801ce6:	f7 f7                	div    %edi
  801ce8:	89 d3                	mov    %edx,%ebx
  801cea:	f7 24 24             	mull   (%esp)
  801ced:	89 c6                	mov    %eax,%esi
  801cef:	89 d1                	mov    %edx,%ecx
  801cf1:	39 d3                	cmp    %edx,%ebx
  801cf3:	0f 82 87 00 00 00    	jb     801d80 <__umoddi3+0x134>
  801cf9:	0f 84 91 00 00 00    	je     801d90 <__umoddi3+0x144>
  801cff:	8b 54 24 04          	mov    0x4(%esp),%edx
  801d03:	29 f2                	sub    %esi,%edx
  801d05:	19 cb                	sbb    %ecx,%ebx
  801d07:	89 d8                	mov    %ebx,%eax
  801d09:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801d0d:	d3 e0                	shl    %cl,%eax
  801d0f:	89 e9                	mov    %ebp,%ecx
  801d11:	d3 ea                	shr    %cl,%edx
  801d13:	09 d0                	or     %edx,%eax
  801d15:	89 e9                	mov    %ebp,%ecx
  801d17:	d3 eb                	shr    %cl,%ebx
  801d19:	89 da                	mov    %ebx,%edx
  801d1b:	83 c4 1c             	add    $0x1c,%esp
  801d1e:	5b                   	pop    %ebx
  801d1f:	5e                   	pop    %esi
  801d20:	5f                   	pop    %edi
  801d21:	5d                   	pop    %ebp
  801d22:	c3                   	ret    
  801d23:	90                   	nop
  801d24:	89 fd                	mov    %edi,%ebp
  801d26:	85 ff                	test   %edi,%edi
  801d28:	75 0b                	jne    801d35 <__umoddi3+0xe9>
  801d2a:	b8 01 00 00 00       	mov    $0x1,%eax
  801d2f:	31 d2                	xor    %edx,%edx
  801d31:	f7 f7                	div    %edi
  801d33:	89 c5                	mov    %eax,%ebp
  801d35:	89 f0                	mov    %esi,%eax
  801d37:	31 d2                	xor    %edx,%edx
  801d39:	f7 f5                	div    %ebp
  801d3b:	89 c8                	mov    %ecx,%eax
  801d3d:	f7 f5                	div    %ebp
  801d3f:	89 d0                	mov    %edx,%eax
  801d41:	e9 44 ff ff ff       	jmp    801c8a <__umoddi3+0x3e>
  801d46:	66 90                	xchg   %ax,%ax
  801d48:	89 c8                	mov    %ecx,%eax
  801d4a:	89 f2                	mov    %esi,%edx
  801d4c:	83 c4 1c             	add    $0x1c,%esp
  801d4f:	5b                   	pop    %ebx
  801d50:	5e                   	pop    %esi
  801d51:	5f                   	pop    %edi
  801d52:	5d                   	pop    %ebp
  801d53:	c3                   	ret    
  801d54:	3b 04 24             	cmp    (%esp),%eax
  801d57:	72 06                	jb     801d5f <__umoddi3+0x113>
  801d59:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801d5d:	77 0f                	ja     801d6e <__umoddi3+0x122>
  801d5f:	89 f2                	mov    %esi,%edx
  801d61:	29 f9                	sub    %edi,%ecx
  801d63:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801d67:	89 14 24             	mov    %edx,(%esp)
  801d6a:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801d6e:	8b 44 24 04          	mov    0x4(%esp),%eax
  801d72:	8b 14 24             	mov    (%esp),%edx
  801d75:	83 c4 1c             	add    $0x1c,%esp
  801d78:	5b                   	pop    %ebx
  801d79:	5e                   	pop    %esi
  801d7a:	5f                   	pop    %edi
  801d7b:	5d                   	pop    %ebp
  801d7c:	c3                   	ret    
  801d7d:	8d 76 00             	lea    0x0(%esi),%esi
  801d80:	2b 04 24             	sub    (%esp),%eax
  801d83:	19 fa                	sbb    %edi,%edx
  801d85:	89 d1                	mov    %edx,%ecx
  801d87:	89 c6                	mov    %eax,%esi
  801d89:	e9 71 ff ff ff       	jmp    801cff <__umoddi3+0xb3>
  801d8e:	66 90                	xchg   %ax,%ax
  801d90:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801d94:	72 ea                	jb     801d80 <__umoddi3+0x134>
  801d96:	89 d9                	mov    %ebx,%ecx
  801d98:	e9 62 ff ff ff       	jmp    801cff <__umoddi3+0xb3>
