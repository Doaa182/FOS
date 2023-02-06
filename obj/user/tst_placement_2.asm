
obj/user/tst_placement_2:     file format elf32-i386


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
  800031:	e8 76 03 00 00       	call   8003ac <libmain>
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

	uint32 actual_active_list[13] = {0xedbfdb78,0xeebfd000,0x803000,0x802000,0x801000,0x800000,0x205000,0x204000,0x203000,0x202000,0x201000,0x200000};
  800043:	8d 95 a4 ff ff fe    	lea    -0x100005c(%ebp),%edx
  800049:	b9 0d 00 00 00       	mov    $0xd,%ecx
  80004e:	b8 00 00 00 00       	mov    $0x0,%eax
  800053:	89 d7                	mov    %edx,%edi
  800055:	f3 ab                	rep stos %eax,%es:(%edi)
  800057:	c7 85 a4 ff ff fe 78 	movl   $0xedbfdb78,-0x100005c(%ebp)
  80005e:	db bf ed 
  800061:	c7 85 a8 ff ff fe 00 	movl   $0xeebfd000,-0x1000058(%ebp)
  800068:	d0 bf ee 
  80006b:	c7 85 ac ff ff fe 00 	movl   $0x803000,-0x1000054(%ebp)
  800072:	30 80 00 
  800075:	c7 85 b0 ff ff fe 00 	movl   $0x802000,-0x1000050(%ebp)
  80007c:	20 80 00 
  80007f:	c7 85 b4 ff ff fe 00 	movl   $0x801000,-0x100004c(%ebp)
  800086:	10 80 00 
  800089:	c7 85 b8 ff ff fe 00 	movl   $0x800000,-0x1000048(%ebp)
  800090:	00 80 00 
  800093:	c7 85 bc ff ff fe 00 	movl   $0x205000,-0x1000044(%ebp)
  80009a:	50 20 00 
  80009d:	c7 85 c0 ff ff fe 00 	movl   $0x204000,-0x1000040(%ebp)
  8000a4:	40 20 00 
  8000a7:	c7 85 c4 ff ff fe 00 	movl   $0x203000,-0x100003c(%ebp)
  8000ae:	30 20 00 
  8000b1:	c7 85 c8 ff ff fe 00 	movl   $0x202000,-0x1000038(%ebp)
  8000b8:	20 20 00 
  8000bb:	c7 85 cc ff ff fe 00 	movl   $0x201000,-0x1000034(%ebp)
  8000c2:	10 20 00 
  8000c5:	c7 85 d0 ff ff fe 00 	movl   $0x200000,-0x1000030(%ebp)
  8000cc:	00 20 00 
	uint32 actual_second_list[7] = {};
  8000cf:	8d 95 88 ff ff fe    	lea    -0x1000078(%ebp),%edx
  8000d5:	b9 07 00 00 00       	mov    $0x7,%ecx
  8000da:	b8 00 00 00 00       	mov    $0x0,%eax
  8000df:	89 d7                	mov    %edx,%edi
  8000e1:	f3 ab                	rep stos %eax,%es:(%edi)
	("STEP 0: checking Initial LRU lists entries ...\n");
	{
		int check = sys_check_LRU_lists(actual_active_list, actual_second_list, 12, 0);
  8000e3:	6a 00                	push   $0x0
  8000e5:	6a 0c                	push   $0xc
  8000e7:	8d 85 88 ff ff fe    	lea    -0x1000078(%ebp),%eax
  8000ed:	50                   	push   %eax
  8000ee:	8d 85 a4 ff ff fe    	lea    -0x100005c(%ebp),%eax
  8000f4:	50                   	push   %eax
  8000f5:	e8 48 1a 00 00       	call   801b42 <sys_check_LRU_lists>
  8000fa:	83 c4 10             	add    $0x10,%esp
  8000fd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
		if(check == 0)
  800100:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800104:	75 14                	jne    80011a <_main+0xe2>
			panic("INITIAL PAGE LRU LISTs entry checking failed! Review size of the LRU lists..!!");
  800106:	83 ec 04             	sub    $0x4,%esp
  800109:	68 00 1e 80 00       	push   $0x801e00
  80010e:	6a 14                	push   $0x14
  800110:	68 4f 1e 80 00       	push   $0x801e4f
  800115:	e8 ce 03 00 00       	call   8004e8 <_panic>
	}

	int usedDiskPages = sys_pf_calculate_allocated_pages() ;
  80011a:	e8 93 15 00 00       	call   8016b2 <sys_pf_calculate_allocated_pages>
  80011f:	89 45 e0             	mov    %eax,-0x20(%ebp)
	int freePages = sys_calculate_free_frames();
  800122:	e8 eb 14 00 00       	call   801612 <sys_calculate_free_frames>
  800127:	89 45 dc             	mov    %eax,-0x24(%ebp)

	int i=0;
  80012a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for(;i<=PAGE_SIZE;i++)
  800131:	eb 11                	jmp    800144 <_main+0x10c>
	{
		arr[i] = -1;
  800133:	8d 95 d8 ff ff fe    	lea    -0x1000028(%ebp),%edx
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
  800156:	8d 95 d8 ff ff fe    	lea    -0x1000028(%ebp),%edx
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
  800179:	8d 95 d8 ff ff fe    	lea    -0x1000028(%ebp),%edx
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
	{
		arr[i] = -1;
	}

	cprintf("STEP A: checking PLACEMENT fault handling ... \n");
  800193:	83 ec 0c             	sub    $0xc,%esp
  800196:	68 68 1e 80 00       	push   $0x801e68
  80019b:	e8 fc 05 00 00       	call   80079c <cprintf>
  8001a0:	83 c4 10             	add    $0x10,%esp
	{
		if( arr[0] !=  -1)  panic("PLACEMENT of stack page failed");
  8001a3:	8a 85 d8 ff ff fe    	mov    -0x1000028(%ebp),%al
  8001a9:	3c ff                	cmp    $0xff,%al
  8001ab:	74 14                	je     8001c1 <_main+0x189>
  8001ad:	83 ec 04             	sub    $0x4,%esp
  8001b0:	68 98 1e 80 00       	push   $0x801e98
  8001b5:	6a 2e                	push   $0x2e
  8001b7:	68 4f 1e 80 00       	push   $0x801e4f
  8001bc:	e8 27 03 00 00       	call   8004e8 <_panic>
		if( arr[PAGE_SIZE] !=  -1)  panic("PLACEMENT of stack page failed");
  8001c1:	8a 85 d8 0f 00 ff    	mov    -0xfff028(%ebp),%al
  8001c7:	3c ff                	cmp    $0xff,%al
  8001c9:	74 14                	je     8001df <_main+0x1a7>
  8001cb:	83 ec 04             	sub    $0x4,%esp
  8001ce:	68 98 1e 80 00       	push   $0x801e98
  8001d3:	6a 2f                	push   $0x2f
  8001d5:	68 4f 1e 80 00       	push   $0x801e4f
  8001da:	e8 09 03 00 00       	call   8004e8 <_panic>

		if( arr[PAGE_SIZE*1024] !=  -1)  panic("PLACEMENT of stack page failed");
  8001df:	8a 85 d8 ff 3f ff    	mov    -0xc00028(%ebp),%al
  8001e5:	3c ff                	cmp    $0xff,%al
  8001e7:	74 14                	je     8001fd <_main+0x1c5>
  8001e9:	83 ec 04             	sub    $0x4,%esp
  8001ec:	68 98 1e 80 00       	push   $0x801e98
  8001f1:	6a 31                	push   $0x31
  8001f3:	68 4f 1e 80 00       	push   $0x801e4f
  8001f8:	e8 eb 02 00 00       	call   8004e8 <_panic>
		if( arr[PAGE_SIZE*1025] !=  -1)  panic("PLACEMENT of stack page failed");
  8001fd:	8a 85 d8 0f 40 ff    	mov    -0xbff028(%ebp),%al
  800203:	3c ff                	cmp    $0xff,%al
  800205:	74 14                	je     80021b <_main+0x1e3>
  800207:	83 ec 04             	sub    $0x4,%esp
  80020a:	68 98 1e 80 00       	push   $0x801e98
  80020f:	6a 32                	push   $0x32
  800211:	68 4f 1e 80 00       	push   $0x801e4f
  800216:	e8 cd 02 00 00       	call   8004e8 <_panic>

		if( arr[PAGE_SIZE*1024*2] !=  -1)  panic("PLACEMENT of stack page failed");
  80021b:	8a 85 d8 ff 7f ff    	mov    -0x800028(%ebp),%al
  800221:	3c ff                	cmp    $0xff,%al
  800223:	74 14                	je     800239 <_main+0x201>
  800225:	83 ec 04             	sub    $0x4,%esp
  800228:	68 98 1e 80 00       	push   $0x801e98
  80022d:	6a 34                	push   $0x34
  80022f:	68 4f 1e 80 00       	push   $0x801e4f
  800234:	e8 af 02 00 00       	call   8004e8 <_panic>
		if( arr[PAGE_SIZE*1024*2 + PAGE_SIZE] !=  -1)  panic("PLACEMENT of stack page failed");
  800239:	8a 85 d8 0f 80 ff    	mov    -0x7ff028(%ebp),%al
  80023f:	3c ff                	cmp    $0xff,%al
  800241:	74 14                	je     800257 <_main+0x21f>
  800243:	83 ec 04             	sub    $0x4,%esp
  800246:	68 98 1e 80 00       	push   $0x801e98
  80024b:	6a 35                	push   $0x35
  80024d:	68 4f 1e 80 00       	push   $0x801e4f
  800252:	e8 91 02 00 00       	call   8004e8 <_panic>


		if( (sys_pf_calculate_allocated_pages() - usedDiskPages) !=  5) panic("new stack pages are not written to Page File");
  800257:	e8 56 14 00 00       	call   8016b2 <sys_pf_calculate_allocated_pages>
  80025c:	2b 45 e0             	sub    -0x20(%ebp),%eax
  80025f:	83 f8 05             	cmp    $0x5,%eax
  800262:	74 14                	je     800278 <_main+0x240>
  800264:	83 ec 04             	sub    $0x4,%esp
  800267:	68 b8 1e 80 00       	push   $0x801eb8
  80026c:	6a 38                	push   $0x38
  80026e:	68 4f 1e 80 00       	push   $0x801e4f
  800273:	e8 70 02 00 00       	call   8004e8 <_panic>

		if( (freePages - sys_calculate_free_frames() ) != 9 ) panic("allocated memory size incorrect");
  800278:	8b 5d dc             	mov    -0x24(%ebp),%ebx
  80027b:	e8 92 13 00 00       	call   801612 <sys_calculate_free_frames>
  800280:	29 c3                	sub    %eax,%ebx
  800282:	89 d8                	mov    %ebx,%eax
  800284:	83 f8 09             	cmp    $0x9,%eax
  800287:	74 14                	je     80029d <_main+0x265>
  800289:	83 ec 04             	sub    $0x4,%esp
  80028c:	68 e8 1e 80 00       	push   $0x801ee8
  800291:	6a 3a                	push   $0x3a
  800293:	68 4f 1e 80 00       	push   $0x801e4f
  800298:	e8 4b 02 00 00       	call   8004e8 <_panic>
	}
	cprintf("STEP A passed: PLACEMENT fault handling works!\n\n\n");
  80029d:	83 ec 0c             	sub    $0xc,%esp
  8002a0:	68 08 1f 80 00       	push   $0x801f08
  8002a5:	e8 f2 04 00 00       	call   80079c <cprintf>
  8002aa:	83 c4 10             	add    $0x10,%esp

	int j=0;
  8002ad:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
	for (int i=3;i>=0;i--,j++)
  8002b4:	c7 45 ec 03 00 00 00 	movl   $0x3,-0x14(%ebp)
  8002bb:	eb 1f                	jmp    8002dc <_main+0x2a4>
		actual_second_list[i]=actual_active_list[11-j];
  8002bd:	b8 0b 00 00 00       	mov    $0xb,%eax
  8002c2:	2b 45 f0             	sub    -0x10(%ebp),%eax
  8002c5:	8b 94 85 a4 ff ff fe 	mov    -0x100005c(%ebp,%eax,4),%edx
  8002cc:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8002cf:	89 94 85 88 ff ff fe 	mov    %edx,-0x1000078(%ebp,%eax,4)
		if( (freePages - sys_calculate_free_frames() ) != 9 ) panic("allocated memory size incorrect");
	}
	cprintf("STEP A passed: PLACEMENT fault handling works!\n\n\n");

	int j=0;
	for (int i=3;i>=0;i--,j++)
  8002d6:	ff 4d ec             	decl   -0x14(%ebp)
  8002d9:	ff 45 f0             	incl   -0x10(%ebp)
  8002dc:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  8002e0:	79 db                	jns    8002bd <_main+0x285>
		actual_second_list[i]=actual_active_list[11-j];
	for (int i=12;i>4;i--)
  8002e2:	c7 45 e8 0c 00 00 00 	movl   $0xc,-0x18(%ebp)
  8002e9:	eb 1a                	jmp    800305 <_main+0x2cd>
		actual_active_list[i]=actual_active_list[i-5];
  8002eb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002ee:	83 e8 05             	sub    $0x5,%eax
  8002f1:	8b 94 85 a4 ff ff fe 	mov    -0x100005c(%ebp,%eax,4),%edx
  8002f8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8002fb:	89 94 85 a4 ff ff fe 	mov    %edx,-0x100005c(%ebp,%eax,4)
	cprintf("STEP A passed: PLACEMENT fault handling works!\n\n\n");

	int j=0;
	for (int i=3;i>=0;i--,j++)
		actual_second_list[i]=actual_active_list[11-j];
	for (int i=12;i>4;i--)
  800302:	ff 4d e8             	decl   -0x18(%ebp)
  800305:	83 7d e8 04          	cmpl   $0x4,-0x18(%ebp)
  800309:	7f e0                	jg     8002eb <_main+0x2b3>
		actual_active_list[i]=actual_active_list[i-5];
	actual_active_list[0]=0xee3fe000;
  80030b:	c7 85 a4 ff ff fe 00 	movl   $0xee3fe000,-0x100005c(%ebp)
  800312:	e0 3f ee 
	actual_active_list[1]=0xee3fdfa0;
  800315:	c7 85 a8 ff ff fe a0 	movl   $0xee3fdfa0,-0x1000058(%ebp)
  80031c:	df 3f ee 
	actual_active_list[2]=0xedffe000;
  80031f:	c7 85 ac ff ff fe 00 	movl   $0xedffe000,-0x1000054(%ebp)
  800326:	e0 ff ed 
	actual_active_list[3]=0xedffdfa0;
  800329:	c7 85 b0 ff ff fe a0 	movl   $0xedffdfa0,-0x1000050(%ebp)
  800330:	df ff ed 
	actual_active_list[4]=0xedbfe000;
  800333:	c7 85 b4 ff ff fe 00 	movl   $0xedbfe000,-0x100004c(%ebp)
  80033a:	e0 bf ed 

	cprintf("STEP B: checking LRU lists entries ...\n");
  80033d:	83 ec 0c             	sub    $0xc,%esp
  800340:	68 3c 1f 80 00       	push   $0x801f3c
  800345:	e8 52 04 00 00       	call   80079c <cprintf>
  80034a:	83 c4 10             	add    $0x10,%esp
	{
		int check = sys_check_LRU_lists(actual_active_list, actual_second_list, 13, 4);
  80034d:	6a 04                	push   $0x4
  80034f:	6a 0d                	push   $0xd
  800351:	8d 85 88 ff ff fe    	lea    -0x1000078(%ebp),%eax
  800357:	50                   	push   %eax
  800358:	8d 85 a4 ff ff fe    	lea    -0x100005c(%ebp),%eax
  80035e:	50                   	push   %eax
  80035f:	e8 de 17 00 00       	call   801b42 <sys_check_LRU_lists>
  800364:	83 c4 10             	add    $0x10,%esp
  800367:	89 45 d8             	mov    %eax,-0x28(%ebp)
		if(check == 0)
  80036a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  80036e:	75 14                	jne    800384 <_main+0x34c>
			panic("LRU lists entries are not correct, check your logic again!!");
  800370:	83 ec 04             	sub    $0x4,%esp
  800373:	68 64 1f 80 00       	push   $0x801f64
  800378:	6a 4d                	push   $0x4d
  80037a:	68 4f 1e 80 00       	push   $0x801e4f
  80037f:	e8 64 01 00 00       	call   8004e8 <_panic>
	}
	cprintf("STEP B passed: LRU lists entries test are correct\n\n\n");
  800384:	83 ec 0c             	sub    $0xc,%esp
  800387:	68 a0 1f 80 00       	push   $0x801fa0
  80038c:	e8 0b 04 00 00       	call   80079c <cprintf>
  800391:	83 c4 10             	add    $0x10,%esp

	cprintf("Congratulations!! Test of PAGE PLACEMENT SECOND SCENARIO completed successfully!!\n\n\n");
  800394:	83 ec 0c             	sub    $0xc,%esp
  800397:	68 d8 1f 80 00       	push   $0x801fd8
  80039c:	e8 fb 03 00 00       	call   80079c <cprintf>
  8003a1:	83 c4 10             	add    $0x10,%esp
	return;
  8003a4:	90                   	nop
}
  8003a5:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8003a8:	5b                   	pop    %ebx
  8003a9:	5f                   	pop    %edi
  8003aa:	5d                   	pop    %ebp
  8003ab:	c3                   	ret    

008003ac <libmain>:
volatile struct Env *myEnv = NULL;
volatile char *binaryname = "(PROGRAM NAME UNKNOWN)";

void
libmain(int argc, char **argv)
{
  8003ac:	55                   	push   %ebp
  8003ad:	89 e5                	mov    %esp,%ebp
  8003af:	83 ec 18             	sub    $0x18,%esp
	int envIndex = sys_getenvindex();
  8003b2:	e8 3b 15 00 00       	call   8018f2 <sys_getenvindex>
  8003b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	myEnv = &(envs[envIndex]);
  8003ba:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8003bd:	89 d0                	mov    %edx,%eax
  8003bf:	c1 e0 03             	shl    $0x3,%eax
  8003c2:	01 d0                	add    %edx,%eax
  8003c4:	01 c0                	add    %eax,%eax
  8003c6:	01 d0                	add    %edx,%eax
  8003c8:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8003cf:	01 d0                	add    %edx,%eax
  8003d1:	c1 e0 04             	shl    $0x4,%eax
  8003d4:	05 00 00 c0 ee       	add    $0xeec00000,%eax
  8003d9:	a3 20 30 80 00       	mov    %eax,0x803020

	//SET THE PROGRAM NAME
	if (myEnv->prog_name[0] != '\0')
  8003de:	a1 20 30 80 00       	mov    0x803020,%eax
  8003e3:	8a 80 5c 05 00 00    	mov    0x55c(%eax),%al
  8003e9:	84 c0                	test   %al,%al
  8003eb:	74 0f                	je     8003fc <libmain+0x50>
		binaryname = myEnv->prog_name;
  8003ed:	a1 20 30 80 00       	mov    0x803020,%eax
  8003f2:	05 5c 05 00 00       	add    $0x55c,%eax
  8003f7:	a3 00 30 80 00       	mov    %eax,0x803000

	// set env to point at our env structure in envs[].
	// env = envs;

	// save the name of the program so that panic() can use it
	if (argc > 0)
  8003fc:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800400:	7e 0a                	jle    80040c <libmain+0x60>
		binaryname = argv[0];
  800402:	8b 45 0c             	mov    0xc(%ebp),%eax
  800405:	8b 00                	mov    (%eax),%eax
  800407:	a3 00 30 80 00       	mov    %eax,0x803000

	// call user main routine
	_main(argc, argv);
  80040c:	83 ec 08             	sub    $0x8,%esp
  80040f:	ff 75 0c             	pushl  0xc(%ebp)
  800412:	ff 75 08             	pushl  0x8(%ebp)
  800415:	e8 1e fc ff ff       	call   800038 <_main>
  80041a:	83 c4 10             	add    $0x10,%esp



	sys_disable_interrupt();
  80041d:	e8 dd 12 00 00       	call   8016ff <sys_disable_interrupt>
	cprintf("**************************************\n");
  800422:	83 ec 0c             	sub    $0xc,%esp
  800425:	68 48 20 80 00       	push   $0x802048
  80042a:	e8 6d 03 00 00       	call   80079c <cprintf>
  80042f:	83 c4 10             	add    $0x10,%esp
	cprintf("Num of PAGE faults = %d, modif = %d\n", myEnv->pageFaultsCounter, myEnv->nModifiedPages);
  800432:	a1 20 30 80 00       	mov    0x803020,%eax
  800437:	8b 90 44 05 00 00    	mov    0x544(%eax),%edx
  80043d:	a1 20 30 80 00       	mov    0x803020,%eax
  800442:	8b 80 34 05 00 00    	mov    0x534(%eax),%eax
  800448:	83 ec 04             	sub    $0x4,%esp
  80044b:	52                   	push   %edx
  80044c:	50                   	push   %eax
  80044d:	68 70 20 80 00       	push   $0x802070
  800452:	e8 45 03 00 00       	call   80079c <cprintf>
  800457:	83 c4 10             	add    $0x10,%esp
	cprintf("# PAGE IN (from disk) = %d, # PAGE OUT (on disk) = %d, # NEW PAGE ADDED (on disk) = %d\n", myEnv->nPageIn, myEnv->nPageOut,myEnv->nNewPageAdded);
  80045a:	a1 20 30 80 00       	mov    0x803020,%eax
  80045f:	8b 88 54 05 00 00    	mov    0x554(%eax),%ecx
  800465:	a1 20 30 80 00       	mov    0x803020,%eax
  80046a:	8b 90 50 05 00 00    	mov    0x550(%eax),%edx
  800470:	a1 20 30 80 00       	mov    0x803020,%eax
  800475:	8b 80 4c 05 00 00    	mov    0x54c(%eax),%eax
  80047b:	51                   	push   %ecx
  80047c:	52                   	push   %edx
  80047d:	50                   	push   %eax
  80047e:	68 98 20 80 00       	push   $0x802098
  800483:	e8 14 03 00 00       	call   80079c <cprintf>
  800488:	83 c4 10             	add    $0x10,%esp
	//cprintf("Num of freeing scarce memory = %d, freeing full working set = %d\n", myEnv->freeingScarceMemCounter, myEnv->freeingFullWSCounter);
	cprintf("Num of clocks = %d\n", myEnv->nClocks);
  80048b:	a1 20 30 80 00       	mov    0x803020,%eax
  800490:	8b 80 a4 05 00 00    	mov    0x5a4(%eax),%eax
  800496:	83 ec 08             	sub    $0x8,%esp
  800499:	50                   	push   %eax
  80049a:	68 f0 20 80 00       	push   $0x8020f0
  80049f:	e8 f8 02 00 00       	call   80079c <cprintf>
  8004a4:	83 c4 10             	add    $0x10,%esp
	cprintf("**************************************\n");
  8004a7:	83 ec 0c             	sub    $0xc,%esp
  8004aa:	68 48 20 80 00       	push   $0x802048
  8004af:	e8 e8 02 00 00       	call   80079c <cprintf>
  8004b4:	83 c4 10             	add    $0x10,%esp
	sys_enable_interrupt();
  8004b7:	e8 5d 12 00 00       	call   801719 <sys_enable_interrupt>

	// exit gracefully
	exit();
  8004bc:	e8 19 00 00 00       	call   8004da <exit>
}
  8004c1:	90                   	nop
  8004c2:	c9                   	leave  
  8004c3:	c3                   	ret    

008004c4 <destroy>:

#include <inc/lib.h>

void
destroy(void)
{
  8004c4:	55                   	push   %ebp
  8004c5:	89 e5                	mov    %esp,%ebp
  8004c7:	83 ec 08             	sub    $0x8,%esp
	sys_destroy_env(0);
  8004ca:	83 ec 0c             	sub    $0xc,%esp
  8004cd:	6a 00                	push   $0x0
  8004cf:	e8 ea 13 00 00       	call   8018be <sys_destroy_env>
  8004d4:	83 c4 10             	add    $0x10,%esp
}
  8004d7:	90                   	nop
  8004d8:	c9                   	leave  
  8004d9:	c3                   	ret    

008004da <exit>:

void
exit(void)
{
  8004da:	55                   	push   %ebp
  8004db:	89 e5                	mov    %esp,%ebp
  8004dd:	83 ec 08             	sub    $0x8,%esp
	sys_exit_env();
  8004e0:	e8 3f 14 00 00       	call   801924 <sys_exit_env>
}
  8004e5:	90                   	nop
  8004e6:	c9                   	leave  
  8004e7:	c3                   	ret    

008004e8 <_panic>:
 * It prints "panic: <message>", then causes a breakpoint exception,
 * which causes FOS to enter the FOS kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
  8004e8:	55                   	push   %ebp
  8004e9:	89 e5                	mov    %esp,%ebp
  8004eb:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	va_start(ap, fmt);
  8004ee:	8d 45 10             	lea    0x10(%ebp),%eax
  8004f1:	83 c0 04             	add    $0x4,%eax
  8004f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// Print the panic message
	if (argv0)
  8004f7:	a1 5c 31 80 00       	mov    0x80315c,%eax
  8004fc:	85 c0                	test   %eax,%eax
  8004fe:	74 16                	je     800516 <_panic+0x2e>
		cprintf("%s: ", argv0);
  800500:	a1 5c 31 80 00       	mov    0x80315c,%eax
  800505:	83 ec 08             	sub    $0x8,%esp
  800508:	50                   	push   %eax
  800509:	68 04 21 80 00       	push   $0x802104
  80050e:	e8 89 02 00 00       	call   80079c <cprintf>
  800513:	83 c4 10             	add    $0x10,%esp
	cprintf("user panic in %s at %s:%d: ", binaryname, file, line);
  800516:	a1 00 30 80 00       	mov    0x803000,%eax
  80051b:	ff 75 0c             	pushl  0xc(%ebp)
  80051e:	ff 75 08             	pushl  0x8(%ebp)
  800521:	50                   	push   %eax
  800522:	68 09 21 80 00       	push   $0x802109
  800527:	e8 70 02 00 00       	call   80079c <cprintf>
  80052c:	83 c4 10             	add    $0x10,%esp
	vcprintf(fmt, ap);
  80052f:	8b 45 10             	mov    0x10(%ebp),%eax
  800532:	83 ec 08             	sub    $0x8,%esp
  800535:	ff 75 f4             	pushl  -0xc(%ebp)
  800538:	50                   	push   %eax
  800539:	e8 f3 01 00 00       	call   800731 <vcprintf>
  80053e:	83 c4 10             	add    $0x10,%esp
	vcprintf("\n", NULL);
  800541:	83 ec 08             	sub    $0x8,%esp
  800544:	6a 00                	push   $0x0
  800546:	68 25 21 80 00       	push   $0x802125
  80054b:	e8 e1 01 00 00       	call   800731 <vcprintf>
  800550:	83 c4 10             	add    $0x10,%esp
	// Cause a breakpoint exception
//	while (1);
//		asm volatile("int3");

	//2013: exit the panic env only
	exit() ;
  800553:	e8 82 ff ff ff       	call   8004da <exit>

	// should not return here
	while (1) ;
  800558:	eb fe                	jmp    800558 <_panic+0x70>

0080055a <CheckWSWithoutLastIndex>:
}

void CheckWSWithoutLastIndex(uint32 *expectedPages, int arraySize)
{
  80055a:	55                   	push   %ebp
  80055b:	89 e5                	mov    %esp,%ebp
  80055d:	83 ec 28             	sub    $0x28,%esp
	if (arraySize != myEnv->page_WS_max_size)
  800560:	a1 20 30 80 00       	mov    0x803020,%eax
  800565:	8b 50 74             	mov    0x74(%eax),%edx
  800568:	8b 45 0c             	mov    0xc(%ebp),%eax
  80056b:	39 c2                	cmp    %eax,%edx
  80056d:	74 14                	je     800583 <CheckWSWithoutLastIndex+0x29>
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
  80056f:	83 ec 04             	sub    $0x4,%esp
  800572:	68 28 21 80 00       	push   $0x802128
  800577:	6a 26                	push   $0x26
  800579:	68 74 21 80 00       	push   $0x802174
  80057e:	e8 65 ff ff ff       	call   8004e8 <_panic>
	}
	int expectedNumOfEmptyLocs = 0;
  800583:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	for (int e = 0; e < arraySize; e++) {
  80058a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800591:	e9 c2 00 00 00       	jmp    800658 <CheckWSWithoutLastIndex+0xfe>
		if (expectedPages[e] == 0) {
  800596:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800599:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8005a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a3:	01 d0                	add    %edx,%eax
  8005a5:	8b 00                	mov    (%eax),%eax
  8005a7:	85 c0                	test   %eax,%eax
  8005a9:	75 08                	jne    8005b3 <CheckWSWithoutLastIndex+0x59>
			expectedNumOfEmptyLocs++;
  8005ab:	ff 45 f4             	incl   -0xc(%ebp)
			continue;
  8005ae:	e9 a2 00 00 00       	jmp    800655 <CheckWSWithoutLastIndex+0xfb>
		}
		int found = 0;
  8005b3:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  8005ba:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  8005c1:	eb 69                	jmp    80062c <CheckWSWithoutLastIndex+0xd2>
			if (myEnv->__uptr_pws[w].empty == 0) {
  8005c3:	a1 20 30 80 00       	mov    0x803020,%eax
  8005c8:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8005ce:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005d1:	89 d0                	mov    %edx,%eax
  8005d3:	01 c0                	add    %eax,%eax
  8005d5:	01 d0                	add    %edx,%eax
  8005d7:	c1 e0 03             	shl    $0x3,%eax
  8005da:	01 c8                	add    %ecx,%eax
  8005dc:	8a 40 04             	mov    0x4(%eax),%al
  8005df:	84 c0                	test   %al,%al
  8005e1:	75 46                	jne    800629 <CheckWSWithoutLastIndex+0xcf>
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  8005e3:	a1 20 30 80 00       	mov    0x803020,%eax
  8005e8:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  8005ee:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8005f1:	89 d0                	mov    %edx,%eax
  8005f3:	01 c0                	add    %eax,%eax
  8005f5:	01 d0                	add    %edx,%eax
  8005f7:	c1 e0 03             	shl    $0x3,%eax
  8005fa:	01 c8                	add    %ecx,%eax
  8005fc:	8b 00                	mov    (%eax),%eax
  8005fe:	89 45 dc             	mov    %eax,-0x24(%ebp)
  800601:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800604:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  800609:	89 c2                	mov    %eax,%edx
						== expectedPages[e]) {
  80060b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80060e:	8d 0c 85 00 00 00 00 	lea    0x0(,%eax,4),%ecx
  800615:	8b 45 08             	mov    0x8(%ebp),%eax
  800618:	01 c8                	add    %ecx,%eax
  80061a:	8b 00                	mov    (%eax),%eax
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
			if (myEnv->__uptr_pws[w].empty == 0) {
				if (ROUNDDOWN(myEnv->__uptr_pws[w].virtual_address, PAGE_SIZE)
  80061c:	39 c2                	cmp    %eax,%edx
  80061e:	75 09                	jne    800629 <CheckWSWithoutLastIndex+0xcf>
						== expectedPages[e]) {
					found = 1;
  800620:	c7 45 ec 01 00 00 00 	movl   $0x1,-0x14(%ebp)
					break;
  800627:	eb 12                	jmp    80063b <CheckWSWithoutLastIndex+0xe1>
		if (expectedPages[e] == 0) {
			expectedNumOfEmptyLocs++;
			continue;
		}
		int found = 0;
		for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800629:	ff 45 e8             	incl   -0x18(%ebp)
  80062c:	a1 20 30 80 00       	mov    0x803020,%eax
  800631:	8b 50 74             	mov    0x74(%eax),%edx
  800634:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800637:	39 c2                	cmp    %eax,%edx
  800639:	77 88                	ja     8005c3 <CheckWSWithoutLastIndex+0x69>
					found = 1;
					break;
				}
			}
		}
		if (!found)
  80063b:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  80063f:	75 14                	jne    800655 <CheckWSWithoutLastIndex+0xfb>
			panic(
  800641:	83 ec 04             	sub    $0x4,%esp
  800644:	68 80 21 80 00       	push   $0x802180
  800649:	6a 3a                	push   $0x3a
  80064b:	68 74 21 80 00       	push   $0x802174
  800650:	e8 93 fe ff ff       	call   8004e8 <_panic>
	if (arraySize != myEnv->page_WS_max_size)
	{
		panic("number of expected pages SHOULD BE EQUAL to max WS size... review your TA!!");
	}
	int expectedNumOfEmptyLocs = 0;
	for (int e = 0; e < arraySize; e++) {
  800655:	ff 45 f0             	incl   -0x10(%ebp)
  800658:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80065b:	3b 45 0c             	cmp    0xc(%ebp),%eax
  80065e:	0f 8c 32 ff ff ff    	jl     800596 <CheckWSWithoutLastIndex+0x3c>
		}
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
  800664:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  80066b:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  800672:	eb 26                	jmp    80069a <CheckWSWithoutLastIndex+0x140>
		if (myEnv->__uptr_pws[w].empty == 1) {
  800674:	a1 20 30 80 00       	mov    0x803020,%eax
  800679:	8b 88 9c 05 00 00    	mov    0x59c(%eax),%ecx
  80067f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800682:	89 d0                	mov    %edx,%eax
  800684:	01 c0                	add    %eax,%eax
  800686:	01 d0                	add    %edx,%eax
  800688:	c1 e0 03             	shl    $0x3,%eax
  80068b:	01 c8                	add    %ecx,%eax
  80068d:	8a 40 04             	mov    0x4(%eax),%al
  800690:	3c 01                	cmp    $0x1,%al
  800692:	75 03                	jne    800697 <CheckWSWithoutLastIndex+0x13d>
			actualNumOfEmptyLocs++;
  800694:	ff 45 e4             	incl   -0x1c(%ebp)
		if (!found)
			panic(
					"PAGE WS entry checking failed... trace it by printing page WS before & after fault");
	}
	int actualNumOfEmptyLocs = 0;
	for (int w = 0; w < myEnv->page_WS_max_size; w++) {
  800697:	ff 45 e0             	incl   -0x20(%ebp)
  80069a:	a1 20 30 80 00       	mov    0x803020,%eax
  80069f:	8b 50 74             	mov    0x74(%eax),%edx
  8006a2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8006a5:	39 c2                	cmp    %eax,%edx
  8006a7:	77 cb                	ja     800674 <CheckWSWithoutLastIndex+0x11a>
		if (myEnv->__uptr_pws[w].empty == 1) {
			actualNumOfEmptyLocs++;
		}
	}
	if (expectedNumOfEmptyLocs != actualNumOfEmptyLocs)
  8006a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8006ac:	3b 45 e4             	cmp    -0x1c(%ebp),%eax
  8006af:	74 14                	je     8006c5 <CheckWSWithoutLastIndex+0x16b>
		panic(
  8006b1:	83 ec 04             	sub    $0x4,%esp
  8006b4:	68 d4 21 80 00       	push   $0x8021d4
  8006b9:	6a 44                	push   $0x44
  8006bb:	68 74 21 80 00       	push   $0x802174
  8006c0:	e8 23 fe ff ff       	call   8004e8 <_panic>
				"PAGE WS entry checking failed... number of empty locations is not correct");
}
  8006c5:	90                   	nop
  8006c6:	c9                   	leave  
  8006c7:	c3                   	ret    

008006c8 <putch>:
};

//2017:
uint8 printProgName = 0;

static void putch(int ch, struct printbuf *b) {
  8006c8:	55                   	push   %ebp
  8006c9:	89 e5                	mov    %esp,%ebp
  8006cb:	83 ec 08             	sub    $0x8,%esp
	b->buf[b->idx++] = ch;
  8006ce:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006d1:	8b 00                	mov    (%eax),%eax
  8006d3:	8d 48 01             	lea    0x1(%eax),%ecx
  8006d6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006d9:	89 0a                	mov    %ecx,(%edx)
  8006db:	8b 55 08             	mov    0x8(%ebp),%edx
  8006de:	88 d1                	mov    %dl,%cl
  8006e0:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006e3:	88 4c 02 08          	mov    %cl,0x8(%edx,%eax,1)
	if (b->idx == 256 - 1) {
  8006e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006ea:	8b 00                	mov    (%eax),%eax
  8006ec:	3d ff 00 00 00       	cmp    $0xff,%eax
  8006f1:	75 2c                	jne    80071f <putch+0x57>
		sys_cputs(b->buf, b->idx, printProgName);
  8006f3:	a0 24 30 80 00       	mov    0x803024,%al
  8006f8:	0f b6 c0             	movzbl %al,%eax
  8006fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006fe:	8b 12                	mov    (%edx),%edx
  800700:	89 d1                	mov    %edx,%ecx
  800702:	8b 55 0c             	mov    0xc(%ebp),%edx
  800705:	83 c2 08             	add    $0x8,%edx
  800708:	83 ec 04             	sub    $0x4,%esp
  80070b:	50                   	push   %eax
  80070c:	51                   	push   %ecx
  80070d:	52                   	push   %edx
  80070e:	e8 3e 0e 00 00       	call   801551 <sys_cputs>
  800713:	83 c4 10             	add    $0x10,%esp
		b->idx = 0;
  800716:	8b 45 0c             	mov    0xc(%ebp),%eax
  800719:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	}
	b->cnt++;
  80071f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800722:	8b 40 04             	mov    0x4(%eax),%eax
  800725:	8d 50 01             	lea    0x1(%eax),%edx
  800728:	8b 45 0c             	mov    0xc(%ebp),%eax
  80072b:	89 50 04             	mov    %edx,0x4(%eax)
}
  80072e:	90                   	nop
  80072f:	c9                   	leave  
  800730:	c3                   	ret    

00800731 <vcprintf>:

int vcprintf(const char *fmt, va_list ap) {
  800731:	55                   	push   %ebp
  800732:	89 e5                	mov    %esp,%ebp
  800734:	81 ec 18 01 00 00    	sub    $0x118,%esp
	struct printbuf b;

	b.idx = 0;
  80073a:	c7 85 f0 fe ff ff 00 	movl   $0x0,-0x110(%ebp)
  800741:	00 00 00 
	b.cnt = 0;
  800744:	c7 85 f4 fe ff ff 00 	movl   $0x0,-0x10c(%ebp)
  80074b:	00 00 00 
	vprintfmt((void*) putch, &b, fmt, ap);
  80074e:	ff 75 0c             	pushl  0xc(%ebp)
  800751:	ff 75 08             	pushl  0x8(%ebp)
  800754:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  80075a:	50                   	push   %eax
  80075b:	68 c8 06 80 00       	push   $0x8006c8
  800760:	e8 11 02 00 00       	call   800976 <vprintfmt>
  800765:	83 c4 10             	add    $0x10,%esp
	sys_cputs(b.buf, b.idx, printProgName);
  800768:	a0 24 30 80 00       	mov    0x803024,%al
  80076d:	0f b6 c0             	movzbl %al,%eax
  800770:	8b 95 f0 fe ff ff    	mov    -0x110(%ebp),%edx
  800776:	83 ec 04             	sub    $0x4,%esp
  800779:	50                   	push   %eax
  80077a:	52                   	push   %edx
  80077b:	8d 85 f0 fe ff ff    	lea    -0x110(%ebp),%eax
  800781:	83 c0 08             	add    $0x8,%eax
  800784:	50                   	push   %eax
  800785:	e8 c7 0d 00 00       	call   801551 <sys_cputs>
  80078a:	83 c4 10             	add    $0x10,%esp

	printProgName = 0;
  80078d:	c6 05 24 30 80 00 00 	movb   $0x0,0x803024
	return b.cnt;
  800794:	8b 85 f4 fe ff ff    	mov    -0x10c(%ebp),%eax
}
  80079a:	c9                   	leave  
  80079b:	c3                   	ret    

0080079c <cprintf>:

int cprintf(const char *fmt, ...) {
  80079c:	55                   	push   %ebp
  80079d:	89 e5                	mov    %esp,%ebp
  80079f:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int cnt;
	printProgName = 1 ;
  8007a2:	c6 05 24 30 80 00 01 	movb   $0x1,0x803024
	va_start(ap, fmt);
  8007a9:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007ac:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007af:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b2:	83 ec 08             	sub    $0x8,%esp
  8007b5:	ff 75 f4             	pushl  -0xc(%ebp)
  8007b8:	50                   	push   %eax
  8007b9:	e8 73 ff ff ff       	call   800731 <vcprintf>
  8007be:	83 c4 10             	add    $0x10,%esp
  8007c1:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return cnt;
  8007c4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007c7:	c9                   	leave  
  8007c8:	c3                   	ret    

008007c9 <atomic_cprintf>:

int atomic_cprintf(const char *fmt, ...) {
  8007c9:	55                   	push   %ebp
  8007ca:	89 e5                	mov    %esp,%ebp
  8007cc:	83 ec 18             	sub    $0x18,%esp
	sys_disable_interrupt();
  8007cf:	e8 2b 0f 00 00       	call   8016ff <sys_disable_interrupt>
	va_list ap;
	int cnt;

	va_start(ap, fmt);
  8007d4:	8d 45 0c             	lea    0xc(%ebp),%eax
  8007d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
	cnt = vcprintf(fmt, ap);
  8007da:	8b 45 08             	mov    0x8(%ebp),%eax
  8007dd:	83 ec 08             	sub    $0x8,%esp
  8007e0:	ff 75 f4             	pushl  -0xc(%ebp)
  8007e3:	50                   	push   %eax
  8007e4:	e8 48 ff ff ff       	call   800731 <vcprintf>
  8007e9:	83 c4 10             	add    $0x10,%esp
  8007ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	sys_enable_interrupt();
  8007ef:	e8 25 0f 00 00       	call   801719 <sys_enable_interrupt>
	return cnt;
  8007f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  8007f7:	c9                   	leave  
  8007f8:	c3                   	ret    

008007f9 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
  8007f9:	55                   	push   %ebp
  8007fa:	89 e5                	mov    %esp,%ebp
  8007fc:	53                   	push   %ebx
  8007fd:	83 ec 14             	sub    $0x14,%esp
  800800:	8b 45 10             	mov    0x10(%ebp),%eax
  800803:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800806:	8b 45 14             	mov    0x14(%ebp),%eax
  800809:	89 45 f4             	mov    %eax,-0xc(%ebp)
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
  80080c:	8b 45 18             	mov    0x18(%ebp),%eax
  80080f:	ba 00 00 00 00       	mov    $0x0,%edx
  800814:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  800817:	77 55                	ja     80086e <printnum+0x75>
  800819:	3b 55 f4             	cmp    -0xc(%ebp),%edx
  80081c:	72 05                	jb     800823 <printnum+0x2a>
  80081e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  800821:	77 4b                	ja     80086e <printnum+0x75>
		printnum(putch, putdat, num / base, base, width - 1, padc);
  800823:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800826:	8d 58 ff             	lea    -0x1(%eax),%ebx
  800829:	8b 45 18             	mov    0x18(%ebp),%eax
  80082c:	ba 00 00 00 00       	mov    $0x0,%edx
  800831:	52                   	push   %edx
  800832:	50                   	push   %eax
  800833:	ff 75 f4             	pushl  -0xc(%ebp)
  800836:	ff 75 f0             	pushl  -0x10(%ebp)
  800839:	e8 46 13 00 00       	call   801b84 <__udivdi3>
  80083e:	83 c4 10             	add    $0x10,%esp
  800841:	83 ec 04             	sub    $0x4,%esp
  800844:	ff 75 20             	pushl  0x20(%ebp)
  800847:	53                   	push   %ebx
  800848:	ff 75 18             	pushl  0x18(%ebp)
  80084b:	52                   	push   %edx
  80084c:	50                   	push   %eax
  80084d:	ff 75 0c             	pushl  0xc(%ebp)
  800850:	ff 75 08             	pushl  0x8(%ebp)
  800853:	e8 a1 ff ff ff       	call   8007f9 <printnum>
  800858:	83 c4 20             	add    $0x20,%esp
  80085b:	eb 1a                	jmp    800877 <printnum+0x7e>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
  80085d:	83 ec 08             	sub    $0x8,%esp
  800860:	ff 75 0c             	pushl  0xc(%ebp)
  800863:	ff 75 20             	pushl  0x20(%ebp)
  800866:	8b 45 08             	mov    0x8(%ebp),%eax
  800869:	ff d0                	call   *%eax
  80086b:	83 c4 10             	add    $0x10,%esp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
  80086e:	ff 4d 1c             	decl   0x1c(%ebp)
  800871:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800875:	7f e6                	jg     80085d <printnum+0x64>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
  800877:	8b 4d 18             	mov    0x18(%ebp),%ecx
  80087a:	bb 00 00 00 00       	mov    $0x0,%ebx
  80087f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800882:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800885:	53                   	push   %ebx
  800886:	51                   	push   %ecx
  800887:	52                   	push   %edx
  800888:	50                   	push   %eax
  800889:	e8 06 14 00 00       	call   801c94 <__umoddi3>
  80088e:	83 c4 10             	add    $0x10,%esp
  800891:	05 34 24 80 00       	add    $0x802434,%eax
  800896:	8a 00                	mov    (%eax),%al
  800898:	0f be c0             	movsbl %al,%eax
  80089b:	83 ec 08             	sub    $0x8,%esp
  80089e:	ff 75 0c             	pushl  0xc(%ebp)
  8008a1:	50                   	push   %eax
  8008a2:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a5:	ff d0                	call   *%eax
  8008a7:	83 c4 10             	add    $0x10,%esp
}
  8008aa:	90                   	nop
  8008ab:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  8008ae:	c9                   	leave  
  8008af:	c3                   	ret    

008008b0 <getuint>:

// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
  8008b0:	55                   	push   %ebp
  8008b1:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  8008b3:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8008b7:	7e 1c                	jle    8008d5 <getuint+0x25>
		return va_arg(*ap, unsigned long long);
  8008b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008bc:	8b 00                	mov    (%eax),%eax
  8008be:	8d 50 08             	lea    0x8(%eax),%edx
  8008c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c4:	89 10                	mov    %edx,(%eax)
  8008c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8008c9:	8b 00                	mov    (%eax),%eax
  8008cb:	83 e8 08             	sub    $0x8,%eax
  8008ce:	8b 50 04             	mov    0x4(%eax),%edx
  8008d1:	8b 00                	mov    (%eax),%eax
  8008d3:	eb 40                	jmp    800915 <getuint+0x65>
	else if (lflag)
  8008d5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8008d9:	74 1e                	je     8008f9 <getuint+0x49>
		return va_arg(*ap, unsigned long);
  8008db:	8b 45 08             	mov    0x8(%ebp),%eax
  8008de:	8b 00                	mov    (%eax),%eax
  8008e0:	8d 50 04             	lea    0x4(%eax),%edx
  8008e3:	8b 45 08             	mov    0x8(%ebp),%eax
  8008e6:	89 10                	mov    %edx,(%eax)
  8008e8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008eb:	8b 00                	mov    (%eax),%eax
  8008ed:	83 e8 04             	sub    $0x4,%eax
  8008f0:	8b 00                	mov    (%eax),%eax
  8008f2:	ba 00 00 00 00       	mov    $0x0,%edx
  8008f7:	eb 1c                	jmp    800915 <getuint+0x65>
	else
		return va_arg(*ap, unsigned int);
  8008f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8008fc:	8b 00                	mov    (%eax),%eax
  8008fe:	8d 50 04             	lea    0x4(%eax),%edx
  800901:	8b 45 08             	mov    0x8(%ebp),%eax
  800904:	89 10                	mov    %edx,(%eax)
  800906:	8b 45 08             	mov    0x8(%ebp),%eax
  800909:	8b 00                	mov    (%eax),%eax
  80090b:	83 e8 04             	sub    $0x4,%eax
  80090e:	8b 00                	mov    (%eax),%eax
  800910:	ba 00 00 00 00       	mov    $0x0,%edx
}
  800915:	5d                   	pop    %ebp
  800916:	c3                   	ret    

00800917 <getint>:

// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
  800917:	55                   	push   %ebp
  800918:	89 e5                	mov    %esp,%ebp
	if (lflag >= 2)
  80091a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  80091e:	7e 1c                	jle    80093c <getint+0x25>
		return va_arg(*ap, long long);
  800920:	8b 45 08             	mov    0x8(%ebp),%eax
  800923:	8b 00                	mov    (%eax),%eax
  800925:	8d 50 08             	lea    0x8(%eax),%edx
  800928:	8b 45 08             	mov    0x8(%ebp),%eax
  80092b:	89 10                	mov    %edx,(%eax)
  80092d:	8b 45 08             	mov    0x8(%ebp),%eax
  800930:	8b 00                	mov    (%eax),%eax
  800932:	83 e8 08             	sub    $0x8,%eax
  800935:	8b 50 04             	mov    0x4(%eax),%edx
  800938:	8b 00                	mov    (%eax),%eax
  80093a:	eb 38                	jmp    800974 <getint+0x5d>
	else if (lflag)
  80093c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800940:	74 1a                	je     80095c <getint+0x45>
		return va_arg(*ap, long);
  800942:	8b 45 08             	mov    0x8(%ebp),%eax
  800945:	8b 00                	mov    (%eax),%eax
  800947:	8d 50 04             	lea    0x4(%eax),%edx
  80094a:	8b 45 08             	mov    0x8(%ebp),%eax
  80094d:	89 10                	mov    %edx,(%eax)
  80094f:	8b 45 08             	mov    0x8(%ebp),%eax
  800952:	8b 00                	mov    (%eax),%eax
  800954:	83 e8 04             	sub    $0x4,%eax
  800957:	8b 00                	mov    (%eax),%eax
  800959:	99                   	cltd   
  80095a:	eb 18                	jmp    800974 <getint+0x5d>
	else
		return va_arg(*ap, int);
  80095c:	8b 45 08             	mov    0x8(%ebp),%eax
  80095f:	8b 00                	mov    (%eax),%eax
  800961:	8d 50 04             	lea    0x4(%eax),%edx
  800964:	8b 45 08             	mov    0x8(%ebp),%eax
  800967:	89 10                	mov    %edx,(%eax)
  800969:	8b 45 08             	mov    0x8(%ebp),%eax
  80096c:	8b 00                	mov    (%eax),%eax
  80096e:	83 e8 04             	sub    $0x4,%eax
  800971:	8b 00                	mov    (%eax),%eax
  800973:	99                   	cltd   
}
  800974:	5d                   	pop    %ebp
  800975:	c3                   	ret    

00800976 <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
  800976:	55                   	push   %ebp
  800977:	89 e5                	mov    %esp,%ebp
  800979:	56                   	push   %esi
  80097a:	53                   	push   %ebx
  80097b:	83 ec 20             	sub    $0x20,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  80097e:	eb 17                	jmp    800997 <vprintfmt+0x21>
			if (ch == '\0')
  800980:	85 db                	test   %ebx,%ebx
  800982:	0f 84 af 03 00 00    	je     800d37 <vprintfmt+0x3c1>
				return;
			putch(ch, putdat);
  800988:	83 ec 08             	sub    $0x8,%esp
  80098b:	ff 75 0c             	pushl  0xc(%ebp)
  80098e:	53                   	push   %ebx
  80098f:	8b 45 08             	mov    0x8(%ebp),%eax
  800992:	ff d0                	call   *%eax
  800994:	83 c4 10             	add    $0x10,%esp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
  800997:	8b 45 10             	mov    0x10(%ebp),%eax
  80099a:	8d 50 01             	lea    0x1(%eax),%edx
  80099d:	89 55 10             	mov    %edx,0x10(%ebp)
  8009a0:	8a 00                	mov    (%eax),%al
  8009a2:	0f b6 d8             	movzbl %al,%ebx
  8009a5:	83 fb 25             	cmp    $0x25,%ebx
  8009a8:	75 d6                	jne    800980 <vprintfmt+0xa>
				return;
			putch(ch, putdat);
		}

		// Process a %-escape sequence
		padc = ' ';
  8009aa:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
		width = -1;
  8009ae:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
		precision = -1;
  8009b5:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
		lflag = 0;
  8009bc:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
		altflag = 0;
  8009c3:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
  8009ca:	8b 45 10             	mov    0x10(%ebp),%eax
  8009cd:	8d 50 01             	lea    0x1(%eax),%edx
  8009d0:	89 55 10             	mov    %edx,0x10(%ebp)
  8009d3:	8a 00                	mov    (%eax),%al
  8009d5:	0f b6 d8             	movzbl %al,%ebx
  8009d8:	8d 43 dd             	lea    -0x23(%ebx),%eax
  8009db:	83 f8 55             	cmp    $0x55,%eax
  8009de:	0f 87 2b 03 00 00    	ja     800d0f <vprintfmt+0x399>
  8009e4:	8b 04 85 58 24 80 00 	mov    0x802458(,%eax,4),%eax
  8009eb:	ff e0                	jmp    *%eax

		// flag to pad on the right
		case '-':
			padc = '-';
  8009ed:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
			goto reswitch;
  8009f1:	eb d7                	jmp    8009ca <vprintfmt+0x54>

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
  8009f3:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
			goto reswitch;
  8009f7:	eb d1                	jmp    8009ca <vprintfmt+0x54>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  8009f9:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
				precision = precision * 10 + ch - '0';
  800a00:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800a03:	89 d0                	mov    %edx,%eax
  800a05:	c1 e0 02             	shl    $0x2,%eax
  800a08:	01 d0                	add    %edx,%eax
  800a0a:	01 c0                	add    %eax,%eax
  800a0c:	01 d8                	add    %ebx,%eax
  800a0e:	83 e8 30             	sub    $0x30,%eax
  800a11:	89 45 e0             	mov    %eax,-0x20(%ebp)
				ch = *fmt;
  800a14:	8b 45 10             	mov    0x10(%ebp),%eax
  800a17:	8a 00                	mov    (%eax),%al
  800a19:	0f be d8             	movsbl %al,%ebx
				if (ch < '0' || ch > '9')
  800a1c:	83 fb 2f             	cmp    $0x2f,%ebx
  800a1f:	7e 3e                	jle    800a5f <vprintfmt+0xe9>
  800a21:	83 fb 39             	cmp    $0x39,%ebx
  800a24:	7f 39                	jg     800a5f <vprintfmt+0xe9>
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
  800a26:	ff 45 10             	incl   0x10(%ebp)
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
  800a29:	eb d5                	jmp    800a00 <vprintfmt+0x8a>
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
  800a2b:	8b 45 14             	mov    0x14(%ebp),%eax
  800a2e:	83 c0 04             	add    $0x4,%eax
  800a31:	89 45 14             	mov    %eax,0x14(%ebp)
  800a34:	8b 45 14             	mov    0x14(%ebp),%eax
  800a37:	83 e8 04             	sub    $0x4,%eax
  800a3a:	8b 00                	mov    (%eax),%eax
  800a3c:	89 45 e0             	mov    %eax,-0x20(%ebp)
			goto process_precision;
  800a3f:	eb 1f                	jmp    800a60 <vprintfmt+0xea>

		case '.':
			if (width < 0)
  800a41:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a45:	79 83                	jns    8009ca <vprintfmt+0x54>
				width = 0;
  800a47:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
			goto reswitch;
  800a4e:	e9 77 ff ff ff       	jmp    8009ca <vprintfmt+0x54>

		case '#':
			altflag = 1;
  800a53:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
			goto reswitch;
  800a5a:	e9 6b ff ff ff       	jmp    8009ca <vprintfmt+0x54>
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
					break;
			}
			goto process_precision;
  800a5f:	90                   	nop
		case '#':
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
  800a60:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800a64:	0f 89 60 ff ff ff    	jns    8009ca <vprintfmt+0x54>
				width = precision, precision = -1;
  800a6a:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800a6d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800a70:	c7 45 e0 ff ff ff ff 	movl   $0xffffffff,-0x20(%ebp)
			goto reswitch;
  800a77:	e9 4e ff ff ff       	jmp    8009ca <vprintfmt+0x54>

		// long flag (doubled for long long)
		case 'l':
			lflag++;
  800a7c:	ff 45 e8             	incl   -0x18(%ebp)
			goto reswitch;
  800a7f:	e9 46 ff ff ff       	jmp    8009ca <vprintfmt+0x54>

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
  800a84:	8b 45 14             	mov    0x14(%ebp),%eax
  800a87:	83 c0 04             	add    $0x4,%eax
  800a8a:	89 45 14             	mov    %eax,0x14(%ebp)
  800a8d:	8b 45 14             	mov    0x14(%ebp),%eax
  800a90:	83 e8 04             	sub    $0x4,%eax
  800a93:	8b 00                	mov    (%eax),%eax
  800a95:	83 ec 08             	sub    $0x8,%esp
  800a98:	ff 75 0c             	pushl  0xc(%ebp)
  800a9b:	50                   	push   %eax
  800a9c:	8b 45 08             	mov    0x8(%ebp),%eax
  800a9f:	ff d0                	call   *%eax
  800aa1:	83 c4 10             	add    $0x10,%esp
			break;
  800aa4:	e9 89 02 00 00       	jmp    800d32 <vprintfmt+0x3bc>

		// error message
		case 'e':
			err = va_arg(ap, int);
  800aa9:	8b 45 14             	mov    0x14(%ebp),%eax
  800aac:	83 c0 04             	add    $0x4,%eax
  800aaf:	89 45 14             	mov    %eax,0x14(%ebp)
  800ab2:	8b 45 14             	mov    0x14(%ebp),%eax
  800ab5:	83 e8 04             	sub    $0x4,%eax
  800ab8:	8b 18                	mov    (%eax),%ebx
			if (err < 0)
  800aba:	85 db                	test   %ebx,%ebx
  800abc:	79 02                	jns    800ac0 <vprintfmt+0x14a>
				err = -err;
  800abe:	f7 db                	neg    %ebx
			if (err > MAXERROR || (p = error_string[err]) == NULL)
  800ac0:	83 fb 64             	cmp    $0x64,%ebx
  800ac3:	7f 0b                	jg     800ad0 <vprintfmt+0x15a>
  800ac5:	8b 34 9d a0 22 80 00 	mov    0x8022a0(,%ebx,4),%esi
  800acc:	85 f6                	test   %esi,%esi
  800ace:	75 19                	jne    800ae9 <vprintfmt+0x173>
				printfmt(putch, putdat, "error %d", err);
  800ad0:	53                   	push   %ebx
  800ad1:	68 45 24 80 00       	push   $0x802445
  800ad6:	ff 75 0c             	pushl  0xc(%ebp)
  800ad9:	ff 75 08             	pushl  0x8(%ebp)
  800adc:	e8 5e 02 00 00       	call   800d3f <printfmt>
  800ae1:	83 c4 10             	add    $0x10,%esp
			else
				printfmt(putch, putdat, "%s", p);
			break;
  800ae4:	e9 49 02 00 00       	jmp    800d32 <vprintfmt+0x3bc>
			if (err < 0)
				err = -err;
			if (err > MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
			else
				printfmt(putch, putdat, "%s", p);
  800ae9:	56                   	push   %esi
  800aea:	68 4e 24 80 00       	push   $0x80244e
  800aef:	ff 75 0c             	pushl  0xc(%ebp)
  800af2:	ff 75 08             	pushl  0x8(%ebp)
  800af5:	e8 45 02 00 00       	call   800d3f <printfmt>
  800afa:	83 c4 10             	add    $0x10,%esp
			break;
  800afd:	e9 30 02 00 00       	jmp    800d32 <vprintfmt+0x3bc>

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
  800b02:	8b 45 14             	mov    0x14(%ebp),%eax
  800b05:	83 c0 04             	add    $0x4,%eax
  800b08:	89 45 14             	mov    %eax,0x14(%ebp)
  800b0b:	8b 45 14             	mov    0x14(%ebp),%eax
  800b0e:	83 e8 04             	sub    $0x4,%eax
  800b11:	8b 30                	mov    (%eax),%esi
  800b13:	85 f6                	test   %esi,%esi
  800b15:	75 05                	jne    800b1c <vprintfmt+0x1a6>
				p = "(null)";
  800b17:	be 51 24 80 00       	mov    $0x802451,%esi
			if (width > 0 && padc != '-')
  800b1c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b20:	7e 6d                	jle    800b8f <vprintfmt+0x219>
  800b22:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800b26:	74 67                	je     800b8f <vprintfmt+0x219>
				for (width -= strnlen(p, precision); width > 0; width--)
  800b28:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b2b:	83 ec 08             	sub    $0x8,%esp
  800b2e:	50                   	push   %eax
  800b2f:	56                   	push   %esi
  800b30:	e8 0c 03 00 00       	call   800e41 <strnlen>
  800b35:	83 c4 10             	add    $0x10,%esp
  800b38:	29 45 e4             	sub    %eax,-0x1c(%ebp)
  800b3b:	eb 16                	jmp    800b53 <vprintfmt+0x1dd>
					putch(padc, putdat);
  800b3d:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800b41:	83 ec 08             	sub    $0x8,%esp
  800b44:	ff 75 0c             	pushl  0xc(%ebp)
  800b47:	50                   	push   %eax
  800b48:	8b 45 08             	mov    0x8(%ebp),%eax
  800b4b:	ff d0                	call   *%eax
  800b4d:	83 c4 10             	add    $0x10,%esp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
  800b50:	ff 4d e4             	decl   -0x1c(%ebp)
  800b53:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800b57:	7f e4                	jg     800b3d <vprintfmt+0x1c7>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b59:	eb 34                	jmp    800b8f <vprintfmt+0x219>
				if (altflag && (ch < ' ' || ch > '~'))
  800b5b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800b5f:	74 1c                	je     800b7d <vprintfmt+0x207>
  800b61:	83 fb 1f             	cmp    $0x1f,%ebx
  800b64:	7e 05                	jle    800b6b <vprintfmt+0x1f5>
  800b66:	83 fb 7e             	cmp    $0x7e,%ebx
  800b69:	7e 12                	jle    800b7d <vprintfmt+0x207>
					putch('?', putdat);
  800b6b:	83 ec 08             	sub    $0x8,%esp
  800b6e:	ff 75 0c             	pushl  0xc(%ebp)
  800b71:	6a 3f                	push   $0x3f
  800b73:	8b 45 08             	mov    0x8(%ebp),%eax
  800b76:	ff d0                	call   *%eax
  800b78:	83 c4 10             	add    $0x10,%esp
  800b7b:	eb 0f                	jmp    800b8c <vprintfmt+0x216>
				else
					putch(ch, putdat);
  800b7d:	83 ec 08             	sub    $0x8,%esp
  800b80:	ff 75 0c             	pushl  0xc(%ebp)
  800b83:	53                   	push   %ebx
  800b84:	8b 45 08             	mov    0x8(%ebp),%eax
  800b87:	ff d0                	call   *%eax
  800b89:	83 c4 10             	add    $0x10,%esp
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
  800b8c:	ff 4d e4             	decl   -0x1c(%ebp)
  800b8f:	89 f0                	mov    %esi,%eax
  800b91:	8d 70 01             	lea    0x1(%eax),%esi
  800b94:	8a 00                	mov    (%eax),%al
  800b96:	0f be d8             	movsbl %al,%ebx
  800b99:	85 db                	test   %ebx,%ebx
  800b9b:	74 24                	je     800bc1 <vprintfmt+0x24b>
  800b9d:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800ba1:	78 b8                	js     800b5b <vprintfmt+0x1e5>
  800ba3:	ff 4d e0             	decl   -0x20(%ebp)
  800ba6:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  800baa:	79 af                	jns    800b5b <vprintfmt+0x1e5>
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bac:	eb 13                	jmp    800bc1 <vprintfmt+0x24b>
				putch(' ', putdat);
  800bae:	83 ec 08             	sub    $0x8,%esp
  800bb1:	ff 75 0c             	pushl  0xc(%ebp)
  800bb4:	6a 20                	push   $0x20
  800bb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb9:	ff d0                	call   *%eax
  800bbb:	83 c4 10             	add    $0x10,%esp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
  800bbe:	ff 4d e4             	decl   -0x1c(%ebp)
  800bc1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800bc5:	7f e7                	jg     800bae <vprintfmt+0x238>
				putch(' ', putdat);
			break;
  800bc7:	e9 66 01 00 00       	jmp    800d32 <vprintfmt+0x3bc>

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
  800bcc:	83 ec 08             	sub    $0x8,%esp
  800bcf:	ff 75 e8             	pushl  -0x18(%ebp)
  800bd2:	8d 45 14             	lea    0x14(%ebp),%eax
  800bd5:	50                   	push   %eax
  800bd6:	e8 3c fd ff ff       	call   800917 <getint>
  800bdb:	83 c4 10             	add    $0x10,%esp
  800bde:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800be1:	89 55 f4             	mov    %edx,-0xc(%ebp)
			if ((long long) num < 0) {
  800be4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800be7:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800bea:	85 d2                	test   %edx,%edx
  800bec:	79 23                	jns    800c11 <vprintfmt+0x29b>
				putch('-', putdat);
  800bee:	83 ec 08             	sub    $0x8,%esp
  800bf1:	ff 75 0c             	pushl  0xc(%ebp)
  800bf4:	6a 2d                	push   $0x2d
  800bf6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bf9:	ff d0                	call   *%eax
  800bfb:	83 c4 10             	add    $0x10,%esp
				num = -(long long) num;
  800bfe:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c01:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800c04:	f7 d8                	neg    %eax
  800c06:	83 d2 00             	adc    $0x0,%edx
  800c09:	f7 da                	neg    %edx
  800c0b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c0e:	89 55 f4             	mov    %edx,-0xc(%ebp)
			}
			base = 10;
  800c11:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c18:	e9 bc 00 00 00       	jmp    800cd9 <vprintfmt+0x363>

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
  800c1d:	83 ec 08             	sub    $0x8,%esp
  800c20:	ff 75 e8             	pushl  -0x18(%ebp)
  800c23:	8d 45 14             	lea    0x14(%ebp),%eax
  800c26:	50                   	push   %eax
  800c27:	e8 84 fc ff ff       	call   8008b0 <getuint>
  800c2c:	83 c4 10             	add    $0x10,%esp
  800c2f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c32:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 10;
  800c35:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
			goto number;
  800c3c:	e9 98 00 00 00       	jmp    800cd9 <vprintfmt+0x363>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
  800c41:	83 ec 08             	sub    $0x8,%esp
  800c44:	ff 75 0c             	pushl  0xc(%ebp)
  800c47:	6a 58                	push   $0x58
  800c49:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4c:	ff d0                	call   *%eax
  800c4e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c51:	83 ec 08             	sub    $0x8,%esp
  800c54:	ff 75 0c             	pushl  0xc(%ebp)
  800c57:	6a 58                	push   $0x58
  800c59:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5c:	ff d0                	call   *%eax
  800c5e:	83 c4 10             	add    $0x10,%esp
			putch('X', putdat);
  800c61:	83 ec 08             	sub    $0x8,%esp
  800c64:	ff 75 0c             	pushl  0xc(%ebp)
  800c67:	6a 58                	push   $0x58
  800c69:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6c:	ff d0                	call   *%eax
  800c6e:	83 c4 10             	add    $0x10,%esp
			break;
  800c71:	e9 bc 00 00 00       	jmp    800d32 <vprintfmt+0x3bc>

		// pointer
		case 'p':
			putch('0', putdat);
  800c76:	83 ec 08             	sub    $0x8,%esp
  800c79:	ff 75 0c             	pushl  0xc(%ebp)
  800c7c:	6a 30                	push   $0x30
  800c7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c81:	ff d0                	call   *%eax
  800c83:	83 c4 10             	add    $0x10,%esp
			putch('x', putdat);
  800c86:	83 ec 08             	sub    $0x8,%esp
  800c89:	ff 75 0c             	pushl  0xc(%ebp)
  800c8c:	6a 78                	push   $0x78
  800c8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c91:	ff d0                	call   *%eax
  800c93:	83 c4 10             	add    $0x10,%esp
			num = (unsigned long long)
				(uint32) va_arg(ap, void *);
  800c96:	8b 45 14             	mov    0x14(%ebp),%eax
  800c99:	83 c0 04             	add    $0x4,%eax
  800c9c:	89 45 14             	mov    %eax,0x14(%ebp)
  800c9f:	8b 45 14             	mov    0x14(%ebp),%eax
  800ca2:	83 e8 04             	sub    $0x4,%eax
  800ca5:	8b 00                	mov    (%eax),%eax

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
  800ca7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800caa:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
				(uint32) va_arg(ap, void *);
			base = 16;
  800cb1:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
			goto number;
  800cb8:	eb 1f                	jmp    800cd9 <vprintfmt+0x363>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
  800cba:	83 ec 08             	sub    $0x8,%esp
  800cbd:	ff 75 e8             	pushl  -0x18(%ebp)
  800cc0:	8d 45 14             	lea    0x14(%ebp),%eax
  800cc3:	50                   	push   %eax
  800cc4:	e8 e7 fb ff ff       	call   8008b0 <getuint>
  800cc9:	83 c4 10             	add    $0x10,%esp
  800ccc:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ccf:	89 55 f4             	mov    %edx,-0xc(%ebp)
			base = 16;
  800cd2:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
		number:
			printnum(putch, putdat, num, base, width, padc);
  800cd9:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800cdd:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ce0:	83 ec 04             	sub    $0x4,%esp
  800ce3:	52                   	push   %edx
  800ce4:	ff 75 e4             	pushl  -0x1c(%ebp)
  800ce7:	50                   	push   %eax
  800ce8:	ff 75 f4             	pushl  -0xc(%ebp)
  800ceb:	ff 75 f0             	pushl  -0x10(%ebp)
  800cee:	ff 75 0c             	pushl  0xc(%ebp)
  800cf1:	ff 75 08             	pushl  0x8(%ebp)
  800cf4:	e8 00 fb ff ff       	call   8007f9 <printnum>
  800cf9:	83 c4 20             	add    $0x20,%esp
			break;
  800cfc:	eb 34                	jmp    800d32 <vprintfmt+0x3bc>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
  800cfe:	83 ec 08             	sub    $0x8,%esp
  800d01:	ff 75 0c             	pushl  0xc(%ebp)
  800d04:	53                   	push   %ebx
  800d05:	8b 45 08             	mov    0x8(%ebp),%eax
  800d08:	ff d0                	call   *%eax
  800d0a:	83 c4 10             	add    $0x10,%esp
			break;
  800d0d:	eb 23                	jmp    800d32 <vprintfmt+0x3bc>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
  800d0f:	83 ec 08             	sub    $0x8,%esp
  800d12:	ff 75 0c             	pushl  0xc(%ebp)
  800d15:	6a 25                	push   $0x25
  800d17:	8b 45 08             	mov    0x8(%ebp),%eax
  800d1a:	ff d0                	call   *%eax
  800d1c:	83 c4 10             	add    $0x10,%esp
			for (fmt--; fmt[-1] != '%'; fmt--)
  800d1f:	ff 4d 10             	decl   0x10(%ebp)
  800d22:	eb 03                	jmp    800d27 <vprintfmt+0x3b1>
  800d24:	ff 4d 10             	decl   0x10(%ebp)
  800d27:	8b 45 10             	mov    0x10(%ebp),%eax
  800d2a:	48                   	dec    %eax
  800d2b:	8a 00                	mov    (%eax),%al
  800d2d:	3c 25                	cmp    $0x25,%al
  800d2f:	75 f3                	jne    800d24 <vprintfmt+0x3ae>
				/* do nothing */;
			break;
  800d31:	90                   	nop
		}
	}
  800d32:	e9 47 fc ff ff       	jmp    80097e <vprintfmt+0x8>
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
				return;
  800d37:	90                   	nop
			for (fmt--; fmt[-1] != '%'; fmt--)
				/* do nothing */;
			break;
		}
	}
}
  800d38:	8d 65 f8             	lea    -0x8(%ebp),%esp
  800d3b:	5b                   	pop    %ebx
  800d3c:	5e                   	pop    %esi
  800d3d:	5d                   	pop    %ebp
  800d3e:	c3                   	ret    

00800d3f <printfmt>:

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
  800d3f:	55                   	push   %ebp
  800d40:	89 e5                	mov    %esp,%ebp
  800d42:	83 ec 18             	sub    $0x18,%esp
	va_list ap;

	va_start(ap, fmt);
  800d45:	8d 45 10             	lea    0x10(%ebp),%eax
  800d48:	83 c0 04             	add    $0x4,%eax
  800d4b:	89 45 f4             	mov    %eax,-0xc(%ebp)
	vprintfmt(putch, putdat, fmt, ap);
  800d4e:	8b 45 10             	mov    0x10(%ebp),%eax
  800d51:	ff 75 f4             	pushl  -0xc(%ebp)
  800d54:	50                   	push   %eax
  800d55:	ff 75 0c             	pushl  0xc(%ebp)
  800d58:	ff 75 08             	pushl  0x8(%ebp)
  800d5b:	e8 16 fc ff ff       	call   800976 <vprintfmt>
  800d60:	83 c4 10             	add    $0x10,%esp
	va_end(ap);
}
  800d63:	90                   	nop
  800d64:	c9                   	leave  
  800d65:	c3                   	ret    

00800d66 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
  800d66:	55                   	push   %ebp
  800d67:	89 e5                	mov    %esp,%ebp
	b->cnt++;
  800d69:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d6c:	8b 40 08             	mov    0x8(%eax),%eax
  800d6f:	8d 50 01             	lea    0x1(%eax),%edx
  800d72:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d75:	89 50 08             	mov    %edx,0x8(%eax)
	if (b->buf < b->ebuf)
  800d78:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d7b:	8b 10                	mov    (%eax),%edx
  800d7d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d80:	8b 40 04             	mov    0x4(%eax),%eax
  800d83:	39 c2                	cmp    %eax,%edx
  800d85:	73 12                	jae    800d99 <sprintputch+0x33>
		*b->buf++ = ch;
  800d87:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d8a:	8b 00                	mov    (%eax),%eax
  800d8c:	8d 48 01             	lea    0x1(%eax),%ecx
  800d8f:	8b 55 0c             	mov    0xc(%ebp),%edx
  800d92:	89 0a                	mov    %ecx,(%edx)
  800d94:	8b 55 08             	mov    0x8(%ebp),%edx
  800d97:	88 10                	mov    %dl,(%eax)
}
  800d99:	90                   	nop
  800d9a:	5d                   	pop    %ebp
  800d9b:	c3                   	ret    

00800d9c <vsnprintf>:

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
  800d9c:	55                   	push   %ebp
  800d9d:	89 e5                	mov    %esp,%ebp
  800d9f:	83 ec 18             	sub    $0x18,%esp
	struct sprintbuf b = {buf, buf+n-1, 0};
  800da2:	8b 45 08             	mov    0x8(%ebp),%eax
  800da5:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800da8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dab:	8d 50 ff             	lea    -0x1(%eax),%edx
  800dae:	8b 45 08             	mov    0x8(%ebp),%eax
  800db1:	01 d0                	add    %edx,%eax
  800db3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800db6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

	if (buf == NULL || n < 1)
  800dbd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800dc1:	74 06                	je     800dc9 <vsnprintf+0x2d>
  800dc3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800dc7:	7f 07                	jg     800dd0 <vsnprintf+0x34>
		return -E_INVAL;
  800dc9:	b8 03 00 00 00       	mov    $0x3,%eax
  800dce:	eb 20                	jmp    800df0 <vsnprintf+0x54>

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
  800dd0:	ff 75 14             	pushl  0x14(%ebp)
  800dd3:	ff 75 10             	pushl  0x10(%ebp)
  800dd6:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800dd9:	50                   	push   %eax
  800dda:	68 66 0d 80 00       	push   $0x800d66
  800ddf:	e8 92 fb ff ff       	call   800976 <vprintfmt>
  800de4:	83 c4 10             	add    $0x10,%esp

	// null terminate the buffer
	*b.buf = '\0';
  800de7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800dea:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
  800ded:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800df0:	c9                   	leave  
  800df1:	c3                   	ret    

00800df2 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
  800df2:	55                   	push   %ebp
  800df3:	89 e5                	mov    %esp,%ebp
  800df5:	83 ec 18             	sub    $0x18,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
  800df8:	8d 45 10             	lea    0x10(%ebp),%eax
  800dfb:	83 c0 04             	add    $0x4,%eax
  800dfe:	89 45 f4             	mov    %eax,-0xc(%ebp)
	rc = vsnprintf(buf, n, fmt, ap);
  800e01:	8b 45 10             	mov    0x10(%ebp),%eax
  800e04:	ff 75 f4             	pushl  -0xc(%ebp)
  800e07:	50                   	push   %eax
  800e08:	ff 75 0c             	pushl  0xc(%ebp)
  800e0b:	ff 75 08             	pushl  0x8(%ebp)
  800e0e:	e8 89 ff ff ff       	call   800d9c <vsnprintf>
  800e13:	83 c4 10             	add    $0x10,%esp
  800e16:	89 45 f0             	mov    %eax,-0x10(%ebp)
	va_end(ap);

	return rc;
  800e19:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800e1c:	c9                   	leave  
  800e1d:	c3                   	ret    

00800e1e <strlen>:

#include <inc/string.h>

int
strlen(const char *s)
{
  800e1e:	55                   	push   %ebp
  800e1f:	89 e5                	mov    %esp,%ebp
  800e21:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; *s != '\0'; s++)
  800e24:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e2b:	eb 06                	jmp    800e33 <strlen+0x15>
		n++;
  800e2d:	ff 45 fc             	incl   -0x4(%ebp)
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
  800e30:	ff 45 08             	incl   0x8(%ebp)
  800e33:	8b 45 08             	mov    0x8(%ebp),%eax
  800e36:	8a 00                	mov    (%eax),%al
  800e38:	84 c0                	test   %al,%al
  800e3a:	75 f1                	jne    800e2d <strlen+0xf>
		n++;
	return n;
  800e3c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e3f:	c9                   	leave  
  800e40:	c3                   	ret    

00800e41 <strnlen>:

int
strnlen(const char *s, uint32 size)
{
  800e41:	55                   	push   %ebp
  800e42:	89 e5                	mov    %esp,%ebp
  800e44:	83 ec 10             	sub    $0x10,%esp
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e47:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800e4e:	eb 09                	jmp    800e59 <strnlen+0x18>
		n++;
  800e50:	ff 45 fc             	incl   -0x4(%ebp)
int
strnlen(const char *s, uint32 size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
  800e53:	ff 45 08             	incl   0x8(%ebp)
  800e56:	ff 4d 0c             	decl   0xc(%ebp)
  800e59:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e5d:	74 09                	je     800e68 <strnlen+0x27>
  800e5f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e62:	8a 00                	mov    (%eax),%al
  800e64:	84 c0                	test   %al,%al
  800e66:	75 e8                	jne    800e50 <strnlen+0xf>
		n++;
	return n;
  800e68:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e6b:	c9                   	leave  
  800e6c:	c3                   	ret    

00800e6d <strcpy>:

char *
strcpy(char *dst, const char *src)
{
  800e6d:	55                   	push   %ebp
  800e6e:	89 e5                	mov    %esp,%ebp
  800e70:	83 ec 10             	sub    $0x10,%esp
	char *ret;

	ret = dst;
  800e73:	8b 45 08             	mov    0x8(%ebp),%eax
  800e76:	89 45 fc             	mov    %eax,-0x4(%ebp)
	while ((*dst++ = *src++) != '\0')
  800e79:	90                   	nop
  800e7a:	8b 45 08             	mov    0x8(%ebp),%eax
  800e7d:	8d 50 01             	lea    0x1(%eax),%edx
  800e80:	89 55 08             	mov    %edx,0x8(%ebp)
  800e83:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e86:	8d 4a 01             	lea    0x1(%edx),%ecx
  800e89:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800e8c:	8a 12                	mov    (%edx),%dl
  800e8e:	88 10                	mov    %dl,(%eax)
  800e90:	8a 00                	mov    (%eax),%al
  800e92:	84 c0                	test   %al,%al
  800e94:	75 e4                	jne    800e7a <strcpy+0xd>
		/* do nothing */;
	return ret;
  800e96:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800e99:	c9                   	leave  
  800e9a:	c3                   	ret    

00800e9b <strncpy>:

char *
strncpy(char *dst, const char *src, uint32 size) {
  800e9b:	55                   	push   %ebp
  800e9c:	89 e5                	mov    %esp,%ebp
  800e9e:	83 ec 10             	sub    $0x10,%esp
	uint32 i;
	char *ret;

	ret = dst;
  800ea1:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea4:	89 45 f8             	mov    %eax,-0x8(%ebp)
	for (i = 0; i < size; i++) {
  800ea7:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  800eae:	eb 1f                	jmp    800ecf <strncpy+0x34>
		*dst++ = *src;
  800eb0:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb3:	8d 50 01             	lea    0x1(%eax),%edx
  800eb6:	89 55 08             	mov    %edx,0x8(%ebp)
  800eb9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800ebc:	8a 12                	mov    (%edx),%dl
  800ebe:	88 10                	mov    %dl,(%eax)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
  800ec0:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ec3:	8a 00                	mov    (%eax),%al
  800ec5:	84 c0                	test   %al,%al
  800ec7:	74 03                	je     800ecc <strncpy+0x31>
			src++;
  800ec9:	ff 45 0c             	incl   0xc(%ebp)
strncpy(char *dst, const char *src, uint32 size) {
	uint32 i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
  800ecc:	ff 45 fc             	incl   -0x4(%ebp)
  800ecf:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ed2:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ed5:	72 d9                	jb     800eb0 <strncpy+0x15>
		*dst++ = *src;
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
  800ed7:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800eda:	c9                   	leave  
  800edb:	c3                   	ret    

00800edc <strlcpy>:

uint32
strlcpy(char *dst, const char *src, uint32 size)
{
  800edc:	55                   	push   %ebp
  800edd:	89 e5                	mov    %esp,%ebp
  800edf:	83 ec 10             	sub    $0x10,%esp
	char *dst_in;

	dst_in = dst;
  800ee2:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee5:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (size > 0) {
  800ee8:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800eec:	74 30                	je     800f1e <strlcpy+0x42>
		while (--size > 0 && *src != '\0')
  800eee:	eb 16                	jmp    800f06 <strlcpy+0x2a>
			*dst++ = *src++;
  800ef0:	8b 45 08             	mov    0x8(%ebp),%eax
  800ef3:	8d 50 01             	lea    0x1(%eax),%edx
  800ef6:	89 55 08             	mov    %edx,0x8(%ebp)
  800ef9:	8b 55 0c             	mov    0xc(%ebp),%edx
  800efc:	8d 4a 01             	lea    0x1(%edx),%ecx
  800eff:	89 4d 0c             	mov    %ecx,0xc(%ebp)
  800f02:	8a 12                	mov    (%edx),%dl
  800f04:	88 10                	mov    %dl,(%eax)
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
  800f06:	ff 4d 10             	decl   0x10(%ebp)
  800f09:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f0d:	74 09                	je     800f18 <strlcpy+0x3c>
  800f0f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f12:	8a 00                	mov    (%eax),%al
  800f14:	84 c0                	test   %al,%al
  800f16:	75 d8                	jne    800ef0 <strlcpy+0x14>
			*dst++ = *src++;
		*dst = '\0';
  800f18:	8b 45 08             	mov    0x8(%ebp),%eax
  800f1b:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
  800f1e:	8b 55 08             	mov    0x8(%ebp),%edx
  800f21:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800f24:	29 c2                	sub    %eax,%edx
  800f26:	89 d0                	mov    %edx,%eax
}
  800f28:	c9                   	leave  
  800f29:	c3                   	ret    

00800f2a <strcmp>:

int
strcmp(const char *p, const char *q)
{
  800f2a:	55                   	push   %ebp
  800f2b:	89 e5                	mov    %esp,%ebp
	while (*p && *p == *q)
  800f2d:	eb 06                	jmp    800f35 <strcmp+0xb>
		p++, q++;
  800f2f:	ff 45 08             	incl   0x8(%ebp)
  800f32:	ff 45 0c             	incl   0xc(%ebp)
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
  800f35:	8b 45 08             	mov    0x8(%ebp),%eax
  800f38:	8a 00                	mov    (%eax),%al
  800f3a:	84 c0                	test   %al,%al
  800f3c:	74 0e                	je     800f4c <strcmp+0x22>
  800f3e:	8b 45 08             	mov    0x8(%ebp),%eax
  800f41:	8a 10                	mov    (%eax),%dl
  800f43:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f46:	8a 00                	mov    (%eax),%al
  800f48:	38 c2                	cmp    %al,%dl
  800f4a:	74 e3                	je     800f2f <strcmp+0x5>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
  800f4c:	8b 45 08             	mov    0x8(%ebp),%eax
  800f4f:	8a 00                	mov    (%eax),%al
  800f51:	0f b6 d0             	movzbl %al,%edx
  800f54:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f57:	8a 00                	mov    (%eax),%al
  800f59:	0f b6 c0             	movzbl %al,%eax
  800f5c:	29 c2                	sub    %eax,%edx
  800f5e:	89 d0                	mov    %edx,%eax
}
  800f60:	5d                   	pop    %ebp
  800f61:	c3                   	ret    

00800f62 <strncmp>:

int
strncmp(const char *p, const char *q, uint32 n)
{
  800f62:	55                   	push   %ebp
  800f63:	89 e5                	mov    %esp,%ebp
	while (n > 0 && *p && *p == *q)
  800f65:	eb 09                	jmp    800f70 <strncmp+0xe>
		n--, p++, q++;
  800f67:	ff 4d 10             	decl   0x10(%ebp)
  800f6a:	ff 45 08             	incl   0x8(%ebp)
  800f6d:	ff 45 0c             	incl   0xc(%ebp)
}

int
strncmp(const char *p, const char *q, uint32 n)
{
	while (n > 0 && *p && *p == *q)
  800f70:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f74:	74 17                	je     800f8d <strncmp+0x2b>
  800f76:	8b 45 08             	mov    0x8(%ebp),%eax
  800f79:	8a 00                	mov    (%eax),%al
  800f7b:	84 c0                	test   %al,%al
  800f7d:	74 0e                	je     800f8d <strncmp+0x2b>
  800f7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f82:	8a 10                	mov    (%eax),%dl
  800f84:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f87:	8a 00                	mov    (%eax),%al
  800f89:	38 c2                	cmp    %al,%dl
  800f8b:	74 da                	je     800f67 <strncmp+0x5>
		n--, p++, q++;
	if (n == 0)
  800f8d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800f91:	75 07                	jne    800f9a <strncmp+0x38>
		return 0;
  800f93:	b8 00 00 00 00       	mov    $0x0,%eax
  800f98:	eb 14                	jmp    800fae <strncmp+0x4c>
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
  800f9a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f9d:	8a 00                	mov    (%eax),%al
  800f9f:	0f b6 d0             	movzbl %al,%edx
  800fa2:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fa5:	8a 00                	mov    (%eax),%al
  800fa7:	0f b6 c0             	movzbl %al,%eax
  800faa:	29 c2                	sub    %eax,%edx
  800fac:	89 d0                	mov    %edx,%eax
}
  800fae:	5d                   	pop    %ebp
  800faf:	c3                   	ret    

00800fb0 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
  800fb0:	55                   	push   %ebp
  800fb1:	89 e5                	mov    %esp,%ebp
  800fb3:	83 ec 04             	sub    $0x4,%esp
  800fb6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fb9:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fbc:	eb 12                	jmp    800fd0 <strchr+0x20>
		if (*s == c)
  800fbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800fc1:	8a 00                	mov    (%eax),%al
  800fc3:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800fc6:	75 05                	jne    800fcd <strchr+0x1d>
			return (char *) s;
  800fc8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fcb:	eb 11                	jmp    800fde <strchr+0x2e>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
  800fcd:	ff 45 08             	incl   0x8(%ebp)
  800fd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fd3:	8a 00                	mov    (%eax),%al
  800fd5:	84 c0                	test   %al,%al
  800fd7:	75 e5                	jne    800fbe <strchr+0xe>
		if (*s == c)
			return (char *) s;
	return 0;
  800fd9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800fde:	c9                   	leave  
  800fdf:	c3                   	ret    

00800fe0 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
  800fe0:	55                   	push   %ebp
  800fe1:	89 e5                	mov    %esp,%ebp
  800fe3:	83 ec 04             	sub    $0x4,%esp
  800fe6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fe9:	88 45 fc             	mov    %al,-0x4(%ebp)
	for (; *s; s++)
  800fec:	eb 0d                	jmp    800ffb <strfind+0x1b>
		if (*s == c)
  800fee:	8b 45 08             	mov    0x8(%ebp),%eax
  800ff1:	8a 00                	mov    (%eax),%al
  800ff3:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800ff6:	74 0e                	je     801006 <strfind+0x26>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
  800ff8:	ff 45 08             	incl   0x8(%ebp)
  800ffb:	8b 45 08             	mov    0x8(%ebp),%eax
  800ffe:	8a 00                	mov    (%eax),%al
  801000:	84 c0                	test   %al,%al
  801002:	75 ea                	jne    800fee <strfind+0xe>
  801004:	eb 01                	jmp    801007 <strfind+0x27>
		if (*s == c)
			break;
  801006:	90                   	nop
	return (char *) s;
  801007:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80100a:	c9                   	leave  
  80100b:	c3                   	ret    

0080100c <memset>:


void *
memset(void *v, int c, uint32 n)
{
  80100c:	55                   	push   %ebp
  80100d:	89 e5                	mov    %esp,%ebp
  80100f:	83 ec 10             	sub    $0x10,%esp
	char *p;
	int m;

	p = v;
  801012:	8b 45 08             	mov    0x8(%ebp),%eax
  801015:	89 45 fc             	mov    %eax,-0x4(%ebp)
	m = n;
  801018:	8b 45 10             	mov    0x10(%ebp),%eax
  80101b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (--m >= 0)
  80101e:	eb 0e                	jmp    80102e <memset+0x22>
		*p++ = c;
  801020:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801023:	8d 50 01             	lea    0x1(%eax),%edx
  801026:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801029:	8b 55 0c             	mov    0xc(%ebp),%edx
  80102c:	88 10                	mov    %dl,(%eax)
	char *p;
	int m;

	p = v;
	m = n;
	while (--m >= 0)
  80102e:	ff 4d f8             	decl   -0x8(%ebp)
  801031:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  801035:	79 e9                	jns    801020 <memset+0x14>
		*p++ = c;

	return v;
  801037:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80103a:	c9                   	leave  
  80103b:	c3                   	ret    

0080103c <memcpy>:

void *
memcpy(void *dst, const void *src, uint32 n)
{
  80103c:	55                   	push   %ebp
  80103d:	89 e5                	mov    %esp,%ebp
  80103f:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  801042:	8b 45 0c             	mov    0xc(%ebp),%eax
  801045:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801048:	8b 45 08             	mov    0x8(%ebp),%eax
  80104b:	89 45 f8             	mov    %eax,-0x8(%ebp)
	while (n-- > 0)
  80104e:	eb 16                	jmp    801066 <memcpy+0x2a>
		*d++ = *s++;
  801050:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801053:	8d 50 01             	lea    0x1(%eax),%edx
  801056:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801059:	8b 55 fc             	mov    -0x4(%ebp),%edx
  80105c:	8d 4a 01             	lea    0x1(%edx),%ecx
  80105f:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  801062:	8a 12                	mov    (%edx),%dl
  801064:	88 10                	mov    %dl,(%eax)
	const char *s;
	char *d;

	s = src;
	d = dst;
	while (n-- > 0)
  801066:	8b 45 10             	mov    0x10(%ebp),%eax
  801069:	8d 50 ff             	lea    -0x1(%eax),%edx
  80106c:	89 55 10             	mov    %edx,0x10(%ebp)
  80106f:	85 c0                	test   %eax,%eax
  801071:	75 dd                	jne    801050 <memcpy+0x14>
		*d++ = *s++;

	return dst;
  801073:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801076:	c9                   	leave  
  801077:	c3                   	ret    

00801078 <memmove>:

void *
memmove(void *dst, const void *src, uint32 n)
{
  801078:	55                   	push   %ebp
  801079:	89 e5                	mov    %esp,%ebp
  80107b:	83 ec 10             	sub    $0x10,%esp
	const char *s;
	char *d;

	s = src;
  80107e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801081:	89 45 fc             	mov    %eax,-0x4(%ebp)
	d = dst;
  801084:	8b 45 08             	mov    0x8(%ebp),%eax
  801087:	89 45 f8             	mov    %eax,-0x8(%ebp)
	if (s < d && s + n > d) {
  80108a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80108d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  801090:	73 50                	jae    8010e2 <memmove+0x6a>
  801092:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801095:	8b 45 10             	mov    0x10(%ebp),%eax
  801098:	01 d0                	add    %edx,%eax
  80109a:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  80109d:	76 43                	jbe    8010e2 <memmove+0x6a>
		s += n;
  80109f:	8b 45 10             	mov    0x10(%ebp),%eax
  8010a2:	01 45 fc             	add    %eax,-0x4(%ebp)
		d += n;
  8010a5:	8b 45 10             	mov    0x10(%ebp),%eax
  8010a8:	01 45 f8             	add    %eax,-0x8(%ebp)
		while (n-- > 0)
  8010ab:	eb 10                	jmp    8010bd <memmove+0x45>
			*--d = *--s;
  8010ad:	ff 4d f8             	decl   -0x8(%ebp)
  8010b0:	ff 4d fc             	decl   -0x4(%ebp)
  8010b3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010b6:	8a 10                	mov    (%eax),%dl
  8010b8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010bb:	88 10                	mov    %dl,(%eax)
	s = src;
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		while (n-- > 0)
  8010bd:	8b 45 10             	mov    0x10(%ebp),%eax
  8010c0:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010c3:	89 55 10             	mov    %edx,0x10(%ebp)
  8010c6:	85 c0                	test   %eax,%eax
  8010c8:	75 e3                	jne    8010ad <memmove+0x35>
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
  8010ca:	eb 23                	jmp    8010ef <memmove+0x77>
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
			*d++ = *s++;
  8010cc:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010cf:	8d 50 01             	lea    0x1(%eax),%edx
  8010d2:	89 55 f8             	mov    %edx,-0x8(%ebp)
  8010d5:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8010d8:	8d 4a 01             	lea    0x1(%edx),%ecx
  8010db:	89 4d fc             	mov    %ecx,-0x4(%ebp)
  8010de:	8a 12                	mov    (%edx),%dl
  8010e0:	88 10                	mov    %dl,(%eax)
		s += n;
		d += n;
		while (n-- > 0)
			*--d = *--s;
	} else
		while (n-- > 0)
  8010e2:	8b 45 10             	mov    0x10(%ebp),%eax
  8010e5:	8d 50 ff             	lea    -0x1(%eax),%edx
  8010e8:	89 55 10             	mov    %edx,0x10(%ebp)
  8010eb:	85 c0                	test   %eax,%eax
  8010ed:	75 dd                	jne    8010cc <memmove+0x54>
			*d++ = *s++;

	return dst;
  8010ef:	8b 45 08             	mov    0x8(%ebp),%eax
}
  8010f2:	c9                   	leave  
  8010f3:	c3                   	ret    

008010f4 <memcmp>:

int
memcmp(const void *v1, const void *v2, uint32 n)
{
  8010f4:	55                   	push   %ebp
  8010f5:	89 e5                	mov    %esp,%ebp
  8010f7:	83 ec 10             	sub    $0x10,%esp
	const uint8 *s1 = (const uint8 *) v1;
  8010fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8010fd:	89 45 fc             	mov    %eax,-0x4(%ebp)
	const uint8 *s2 = (const uint8 *) v2;
  801100:	8b 45 0c             	mov    0xc(%ebp),%eax
  801103:	89 45 f8             	mov    %eax,-0x8(%ebp)

	while (n-- > 0) {
  801106:	eb 2a                	jmp    801132 <memcmp+0x3e>
		if (*s1 != *s2)
  801108:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80110b:	8a 10                	mov    (%eax),%dl
  80110d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801110:	8a 00                	mov    (%eax),%al
  801112:	38 c2                	cmp    %al,%dl
  801114:	74 16                	je     80112c <memcmp+0x38>
			return (int) *s1 - (int) *s2;
  801116:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801119:	8a 00                	mov    (%eax),%al
  80111b:	0f b6 d0             	movzbl %al,%edx
  80111e:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801121:	8a 00                	mov    (%eax),%al
  801123:	0f b6 c0             	movzbl %al,%eax
  801126:	29 c2                	sub    %eax,%edx
  801128:	89 d0                	mov    %edx,%eax
  80112a:	eb 18                	jmp    801144 <memcmp+0x50>
		s1++, s2++;
  80112c:	ff 45 fc             	incl   -0x4(%ebp)
  80112f:	ff 45 f8             	incl   -0x8(%ebp)
memcmp(const void *v1, const void *v2, uint32 n)
{
	const uint8 *s1 = (const uint8 *) v1;
	const uint8 *s2 = (const uint8 *) v2;

	while (n-- > 0) {
  801132:	8b 45 10             	mov    0x10(%ebp),%eax
  801135:	8d 50 ff             	lea    -0x1(%eax),%edx
  801138:	89 55 10             	mov    %edx,0x10(%ebp)
  80113b:	85 c0                	test   %eax,%eax
  80113d:	75 c9                	jne    801108 <memcmp+0x14>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
  80113f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801144:	c9                   	leave  
  801145:	c3                   	ret    

00801146 <memfind>:

void *
memfind(const void *s, int c, uint32 n)
{
  801146:	55                   	push   %ebp
  801147:	89 e5                	mov    %esp,%ebp
  801149:	83 ec 10             	sub    $0x10,%esp
	const void *ends = (const char *) s + n;
  80114c:	8b 55 08             	mov    0x8(%ebp),%edx
  80114f:	8b 45 10             	mov    0x10(%ebp),%eax
  801152:	01 d0                	add    %edx,%eax
  801154:	89 45 fc             	mov    %eax,-0x4(%ebp)
	for (; s < ends; s++)
  801157:	eb 15                	jmp    80116e <memfind+0x28>
		if (*(const unsigned char *) s == (unsigned char) c)
  801159:	8b 45 08             	mov    0x8(%ebp),%eax
  80115c:	8a 00                	mov    (%eax),%al
  80115e:	0f b6 d0             	movzbl %al,%edx
  801161:	8b 45 0c             	mov    0xc(%ebp),%eax
  801164:	0f b6 c0             	movzbl %al,%eax
  801167:	39 c2                	cmp    %eax,%edx
  801169:	74 0d                	je     801178 <memfind+0x32>

void *
memfind(const void *s, int c, uint32 n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
  80116b:	ff 45 08             	incl   0x8(%ebp)
  80116e:	8b 45 08             	mov    0x8(%ebp),%eax
  801171:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  801174:	72 e3                	jb     801159 <memfind+0x13>
  801176:	eb 01                	jmp    801179 <memfind+0x33>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
  801178:	90                   	nop
	return (void *) s;
  801179:	8b 45 08             	mov    0x8(%ebp),%eax
}
  80117c:	c9                   	leave  
  80117d:	c3                   	ret    

0080117e <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
  80117e:	55                   	push   %ebp
  80117f:	89 e5                	mov    %esp,%ebp
  801181:	83 ec 10             	sub    $0x10,%esp
	int neg = 0;
  801184:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	long val = 0;
  80118b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801192:	eb 03                	jmp    801197 <strtol+0x19>
		s++;
  801194:	ff 45 08             	incl   0x8(%ebp)
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
  801197:	8b 45 08             	mov    0x8(%ebp),%eax
  80119a:	8a 00                	mov    (%eax),%al
  80119c:	3c 20                	cmp    $0x20,%al
  80119e:	74 f4                	je     801194 <strtol+0x16>
  8011a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8011a3:	8a 00                	mov    (%eax),%al
  8011a5:	3c 09                	cmp    $0x9,%al
  8011a7:	74 eb                	je     801194 <strtol+0x16>
		s++;

	// plus/minus sign
	if (*s == '+')
  8011a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ac:	8a 00                	mov    (%eax),%al
  8011ae:	3c 2b                	cmp    $0x2b,%al
  8011b0:	75 05                	jne    8011b7 <strtol+0x39>
		s++;
  8011b2:	ff 45 08             	incl   0x8(%ebp)
  8011b5:	eb 13                	jmp    8011ca <strtol+0x4c>
	else if (*s == '-')
  8011b7:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ba:	8a 00                	mov    (%eax),%al
  8011bc:	3c 2d                	cmp    $0x2d,%al
  8011be:	75 0a                	jne    8011ca <strtol+0x4c>
		s++, neg = 1;
  8011c0:	ff 45 08             	incl   0x8(%ebp)
  8011c3:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
  8011ca:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011ce:	74 06                	je     8011d6 <strtol+0x58>
  8011d0:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8011d4:	75 20                	jne    8011f6 <strtol+0x78>
  8011d6:	8b 45 08             	mov    0x8(%ebp),%eax
  8011d9:	8a 00                	mov    (%eax),%al
  8011db:	3c 30                	cmp    $0x30,%al
  8011dd:	75 17                	jne    8011f6 <strtol+0x78>
  8011df:	8b 45 08             	mov    0x8(%ebp),%eax
  8011e2:	40                   	inc    %eax
  8011e3:	8a 00                	mov    (%eax),%al
  8011e5:	3c 78                	cmp    $0x78,%al
  8011e7:	75 0d                	jne    8011f6 <strtol+0x78>
		s += 2, base = 16;
  8011e9:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  8011ed:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  8011f4:	eb 28                	jmp    80121e <strtol+0xa0>
	else if (base == 0 && s[0] == '0')
  8011f6:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8011fa:	75 15                	jne    801211 <strtol+0x93>
  8011fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8011ff:	8a 00                	mov    (%eax),%al
  801201:	3c 30                	cmp    $0x30,%al
  801203:	75 0c                	jne    801211 <strtol+0x93>
		s++, base = 8;
  801205:	ff 45 08             	incl   0x8(%ebp)
  801208:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  80120f:	eb 0d                	jmp    80121e <strtol+0xa0>
	else if (base == 0)
  801211:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801215:	75 07                	jne    80121e <strtol+0xa0>
		base = 10;
  801217:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
  80121e:	8b 45 08             	mov    0x8(%ebp),%eax
  801221:	8a 00                	mov    (%eax),%al
  801223:	3c 2f                	cmp    $0x2f,%al
  801225:	7e 19                	jle    801240 <strtol+0xc2>
  801227:	8b 45 08             	mov    0x8(%ebp),%eax
  80122a:	8a 00                	mov    (%eax),%al
  80122c:	3c 39                	cmp    $0x39,%al
  80122e:	7f 10                	jg     801240 <strtol+0xc2>
			dig = *s - '0';
  801230:	8b 45 08             	mov    0x8(%ebp),%eax
  801233:	8a 00                	mov    (%eax),%al
  801235:	0f be c0             	movsbl %al,%eax
  801238:	83 e8 30             	sub    $0x30,%eax
  80123b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80123e:	eb 42                	jmp    801282 <strtol+0x104>
		else if (*s >= 'a' && *s <= 'z')
  801240:	8b 45 08             	mov    0x8(%ebp),%eax
  801243:	8a 00                	mov    (%eax),%al
  801245:	3c 60                	cmp    $0x60,%al
  801247:	7e 19                	jle    801262 <strtol+0xe4>
  801249:	8b 45 08             	mov    0x8(%ebp),%eax
  80124c:	8a 00                	mov    (%eax),%al
  80124e:	3c 7a                	cmp    $0x7a,%al
  801250:	7f 10                	jg     801262 <strtol+0xe4>
			dig = *s - 'a' + 10;
  801252:	8b 45 08             	mov    0x8(%ebp),%eax
  801255:	8a 00                	mov    (%eax),%al
  801257:	0f be c0             	movsbl %al,%eax
  80125a:	83 e8 57             	sub    $0x57,%eax
  80125d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801260:	eb 20                	jmp    801282 <strtol+0x104>
		else if (*s >= 'A' && *s <= 'Z')
  801262:	8b 45 08             	mov    0x8(%ebp),%eax
  801265:	8a 00                	mov    (%eax),%al
  801267:	3c 40                	cmp    $0x40,%al
  801269:	7e 39                	jle    8012a4 <strtol+0x126>
  80126b:	8b 45 08             	mov    0x8(%ebp),%eax
  80126e:	8a 00                	mov    (%eax),%al
  801270:	3c 5a                	cmp    $0x5a,%al
  801272:	7f 30                	jg     8012a4 <strtol+0x126>
			dig = *s - 'A' + 10;
  801274:	8b 45 08             	mov    0x8(%ebp),%eax
  801277:	8a 00                	mov    (%eax),%al
  801279:	0f be c0             	movsbl %al,%eax
  80127c:	83 e8 37             	sub    $0x37,%eax
  80127f:	89 45 f4             	mov    %eax,-0xc(%ebp)
		else
			break;
		if (dig >= base)
  801282:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801285:	3b 45 10             	cmp    0x10(%ebp),%eax
  801288:	7d 19                	jge    8012a3 <strtol+0x125>
			break;
		s++, val = (val * base) + dig;
  80128a:	ff 45 08             	incl   0x8(%ebp)
  80128d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801290:	0f af 45 10          	imul   0x10(%ebp),%eax
  801294:	89 c2                	mov    %eax,%edx
  801296:	8b 45 f4             	mov    -0xc(%ebp),%eax
  801299:	01 d0                	add    %edx,%eax
  80129b:	89 45 f8             	mov    %eax,-0x8(%ebp)
		// we don't properly detect overflow!
	}
  80129e:	e9 7b ff ff ff       	jmp    80121e <strtol+0xa0>
		else if (*s >= 'A' && *s <= 'Z')
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
			break;
  8012a3:	90                   	nop
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
  8012a4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8012a8:	74 08                	je     8012b2 <strtol+0x134>
		*endptr = (char *) s;
  8012aa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012ad:	8b 55 08             	mov    0x8(%ebp),%edx
  8012b0:	89 10                	mov    %edx,(%eax)
	return (neg ? -val : val);
  8012b2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8012b6:	74 07                	je     8012bf <strtol+0x141>
  8012b8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8012bb:	f7 d8                	neg    %eax
  8012bd:	eb 03                	jmp    8012c2 <strtol+0x144>
  8012bf:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8012c2:	c9                   	leave  
  8012c3:	c3                   	ret    

008012c4 <ltostr>:

void
ltostr(long value, char *str)
{
  8012c4:	55                   	push   %ebp
  8012c5:	89 e5                	mov    %esp,%ebp
  8012c7:	83 ec 20             	sub    $0x20,%esp
	int neg = 0;
  8012ca:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	int s = 0 ;
  8012d1:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

	// plus/minus sign
	if (value < 0)
  8012d8:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  8012dc:	79 13                	jns    8012f1 <ltostr+0x2d>
	{
		neg = 1;
  8012de:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
		str[0] = '-';
  8012e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8012e8:	c6 00 2d             	movb   $0x2d,(%eax)
		value = value * -1 ;
  8012eb:	f7 5d 08             	negl   0x8(%ebp)
		s++ ;
  8012ee:	ff 45 f8             	incl   -0x8(%ebp)
	}
	do
	{
		int mod = value % 10 ;
  8012f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8012f4:	b9 0a 00 00 00       	mov    $0xa,%ecx
  8012f9:	99                   	cltd   
  8012fa:	f7 f9                	idiv   %ecx
  8012fc:	89 55 ec             	mov    %edx,-0x14(%ebp)
		str[s++] = mod + '0' ;
  8012ff:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801302:	8d 50 01             	lea    0x1(%eax),%edx
  801305:	89 55 f8             	mov    %edx,-0x8(%ebp)
  801308:	89 c2                	mov    %eax,%edx
  80130a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80130d:	01 d0                	add    %edx,%eax
  80130f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  801312:	83 c2 30             	add    $0x30,%edx
  801315:	88 10                	mov    %dl,(%eax)
		value = value / 10 ;
  801317:	8b 4d 08             	mov    0x8(%ebp),%ecx
  80131a:	b8 67 66 66 66       	mov    $0x66666667,%eax
  80131f:	f7 e9                	imul   %ecx
  801321:	c1 fa 02             	sar    $0x2,%edx
  801324:	89 c8                	mov    %ecx,%eax
  801326:	c1 f8 1f             	sar    $0x1f,%eax
  801329:	29 c2                	sub    %eax,%edx
  80132b:	89 d0                	mov    %edx,%eax
  80132d:	89 45 08             	mov    %eax,0x8(%ebp)
	} while (value % 10 != 0);
  801330:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801333:	b8 67 66 66 66       	mov    $0x66666667,%eax
  801338:	f7 e9                	imul   %ecx
  80133a:	c1 fa 02             	sar    $0x2,%edx
  80133d:	89 c8                	mov    %ecx,%eax
  80133f:	c1 f8 1f             	sar    $0x1f,%eax
  801342:	29 c2                	sub    %eax,%edx
  801344:	89 d0                	mov    %edx,%eax
  801346:	c1 e0 02             	shl    $0x2,%eax
  801349:	01 d0                	add    %edx,%eax
  80134b:	01 c0                	add    %eax,%eax
  80134d:	29 c1                	sub    %eax,%ecx
  80134f:	89 ca                	mov    %ecx,%edx
  801351:	85 d2                	test   %edx,%edx
  801353:	75 9c                	jne    8012f1 <ltostr+0x2d>

	//reverse the string
	int start = 0 ;
  801355:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
	int end = s-1 ;
  80135c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80135f:	48                   	dec    %eax
  801360:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (neg)
  801363:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  801367:	74 3d                	je     8013a6 <ltostr+0xe2>
		start = 1 ;
  801369:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
	while(start<end)
  801370:	eb 34                	jmp    8013a6 <ltostr+0xe2>
	{
		char tmp = str[start] ;
  801372:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801375:	8b 45 0c             	mov    0xc(%ebp),%eax
  801378:	01 d0                	add    %edx,%eax
  80137a:	8a 00                	mov    (%eax),%al
  80137c:	88 45 eb             	mov    %al,-0x15(%ebp)
		str[start] = str[end] ;
  80137f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801382:	8b 45 0c             	mov    0xc(%ebp),%eax
  801385:	01 c2                	add    %eax,%edx
  801387:	8b 4d f0             	mov    -0x10(%ebp),%ecx
  80138a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80138d:	01 c8                	add    %ecx,%eax
  80138f:	8a 00                	mov    (%eax),%al
  801391:	88 02                	mov    %al,(%edx)
		str[end] = tmp;
  801393:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801396:	8b 45 0c             	mov    0xc(%ebp),%eax
  801399:	01 c2                	add    %eax,%edx
  80139b:	8a 45 eb             	mov    -0x15(%ebp),%al
  80139e:	88 02                	mov    %al,(%edx)
		start++ ;
  8013a0:	ff 45 f4             	incl   -0xc(%ebp)
		end-- ;
  8013a3:	ff 4d f0             	decl   -0x10(%ebp)
	//reverse the string
	int start = 0 ;
	int end = s-1 ;
	if (neg)
		start = 1 ;
	while(start<end)
  8013a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8013a9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  8013ac:	7c c4                	jl     801372 <ltostr+0xae>
		str[end] = tmp;
		start++ ;
		end-- ;
	}

	str[s] = 0 ;
  8013ae:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8013b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8013b4:	01 d0                	add    %edx,%eax
  8013b6:	c6 00 00             	movb   $0x0,(%eax)
	// we don't properly detect overflow!

}
  8013b9:	90                   	nop
  8013ba:	c9                   	leave  
  8013bb:	c3                   	ret    

008013bc <strcconcat>:

void
strcconcat(const char *str1, const char *str2, char *final)
{
  8013bc:	55                   	push   %ebp
  8013bd:	89 e5                	mov    %esp,%ebp
  8013bf:	83 ec 10             	sub    $0x10,%esp
	int len1 = strlen(str1);
  8013c2:	ff 75 08             	pushl  0x8(%ebp)
  8013c5:	e8 54 fa ff ff       	call   800e1e <strlen>
  8013ca:	83 c4 04             	add    $0x4,%esp
  8013cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
	int len2 = strlen(str2);
  8013d0:	ff 75 0c             	pushl  0xc(%ebp)
  8013d3:	e8 46 fa ff ff       	call   800e1e <strlen>
  8013d8:	83 c4 04             	add    $0x4,%esp
  8013db:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int s = 0 ;
  8013de:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for (s=0 ; s < len1 ; s++)
  8013e5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  8013ec:	eb 17                	jmp    801405 <strcconcat+0x49>
		final[s] = str1[s] ;
  8013ee:	8b 55 fc             	mov    -0x4(%ebp),%edx
  8013f1:	8b 45 10             	mov    0x10(%ebp),%eax
  8013f4:	01 c2                	add    %eax,%edx
  8013f6:	8b 4d fc             	mov    -0x4(%ebp),%ecx
  8013f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fc:	01 c8                	add    %ecx,%eax
  8013fe:	8a 00                	mov    (%eax),%al
  801400:	88 02                	mov    %al,(%edx)
strcconcat(const char *str1, const char *str2, char *final)
{
	int len1 = strlen(str1);
	int len2 = strlen(str2);
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
  801402:	ff 45 fc             	incl   -0x4(%ebp)
  801405:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801408:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  80140b:	7c e1                	jl     8013ee <strcconcat+0x32>
		final[s] = str1[s] ;

	int i = 0 ;
  80140d:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
	for (i=0 ; i < len2 ; i++)
  801414:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  80141b:	eb 1f                	jmp    80143c <strcconcat+0x80>
		final[s++] = str2[i] ;
  80141d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801420:	8d 50 01             	lea    0x1(%eax),%edx
  801423:	89 55 fc             	mov    %edx,-0x4(%ebp)
  801426:	89 c2                	mov    %eax,%edx
  801428:	8b 45 10             	mov    0x10(%ebp),%eax
  80142b:	01 c2                	add    %eax,%edx
  80142d:	8b 4d f8             	mov    -0x8(%ebp),%ecx
  801430:	8b 45 0c             	mov    0xc(%ebp),%eax
  801433:	01 c8                	add    %ecx,%eax
  801435:	8a 00                	mov    (%eax),%al
  801437:	88 02                	mov    %al,(%edx)
	int s = 0 ;
	for (s=0 ; s < len1 ; s++)
		final[s] = str1[s] ;

	int i = 0 ;
	for (i=0 ; i < len2 ; i++)
  801439:	ff 45 f8             	incl   -0x8(%ebp)
  80143c:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80143f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  801442:	7c d9                	jl     80141d <strcconcat+0x61>
		final[s++] = str2[i] ;

	final[s] = 0;
  801444:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801447:	8b 45 10             	mov    0x10(%ebp),%eax
  80144a:	01 d0                	add    %edx,%eax
  80144c:	c6 00 00             	movb   $0x0,(%eax)
}
  80144f:	90                   	nop
  801450:	c9                   	leave  
  801451:	c3                   	ret    

00801452 <strsplit>:
int strsplit(char *string, char *SPLIT_CHARS, char **argv, int * argc)
{
  801452:	55                   	push   %ebp
  801453:	89 e5                	mov    %esp,%ebp
	// Parse the command string into splitchars-separated arguments
	*argc = 0;
  801455:	8b 45 14             	mov    0x14(%ebp),%eax
  801458:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	(argv)[*argc] = 0;
  80145e:	8b 45 14             	mov    0x14(%ebp),%eax
  801461:	8b 00                	mov    (%eax),%eax
  801463:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  80146a:	8b 45 10             	mov    0x10(%ebp),%eax
  80146d:	01 d0                	add    %edx,%eax
  80146f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801475:	eb 0c                	jmp    801483 <strsplit+0x31>
			*string++ = 0;
  801477:	8b 45 08             	mov    0x8(%ebp),%eax
  80147a:	8d 50 01             	lea    0x1(%eax),%edx
  80147d:	89 55 08             	mov    %edx,0x8(%ebp)
  801480:	c6 00 00             	movb   $0x0,(%eax)
	*argc = 0;
	(argv)[*argc] = 0;
	while (1)
	{
		// trim splitchars
		while (*string && strchr(SPLIT_CHARS, *string))
  801483:	8b 45 08             	mov    0x8(%ebp),%eax
  801486:	8a 00                	mov    (%eax),%al
  801488:	84 c0                	test   %al,%al
  80148a:	74 18                	je     8014a4 <strsplit+0x52>
  80148c:	8b 45 08             	mov    0x8(%ebp),%eax
  80148f:	8a 00                	mov    (%eax),%al
  801491:	0f be c0             	movsbl %al,%eax
  801494:	50                   	push   %eax
  801495:	ff 75 0c             	pushl  0xc(%ebp)
  801498:	e8 13 fb ff ff       	call   800fb0 <strchr>
  80149d:	83 c4 08             	add    $0x8,%esp
  8014a0:	85 c0                	test   %eax,%eax
  8014a2:	75 d3                	jne    801477 <strsplit+0x25>
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
  8014a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a7:	8a 00                	mov    (%eax),%al
  8014a9:	84 c0                	test   %al,%al
  8014ab:	74 5a                	je     801507 <strsplit+0xb5>
			break;

		//check current number of arguments
		if (*argc == MAX_ARGUMENTS-1)
  8014ad:	8b 45 14             	mov    0x14(%ebp),%eax
  8014b0:	8b 00                	mov    (%eax),%eax
  8014b2:	83 f8 0f             	cmp    $0xf,%eax
  8014b5:	75 07                	jne    8014be <strsplit+0x6c>
		{
			return 0;
  8014b7:	b8 00 00 00 00       	mov    $0x0,%eax
  8014bc:	eb 66                	jmp    801524 <strsplit+0xd2>
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
  8014be:	8b 45 14             	mov    0x14(%ebp),%eax
  8014c1:	8b 00                	mov    (%eax),%eax
  8014c3:	8d 48 01             	lea    0x1(%eax),%ecx
  8014c6:	8b 55 14             	mov    0x14(%ebp),%edx
  8014c9:	89 0a                	mov    %ecx,(%edx)
  8014cb:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  8014d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8014d5:	01 c2                	add    %eax,%edx
  8014d7:	8b 45 08             	mov    0x8(%ebp),%eax
  8014da:	89 02                	mov    %eax,(%edx)
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014dc:	eb 03                	jmp    8014e1 <strsplit+0x8f>
			string++;
  8014de:	ff 45 08             	incl   0x8(%ebp)
			return 0;
		}

		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
  8014e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8014e4:	8a 00                	mov    (%eax),%al
  8014e6:	84 c0                	test   %al,%al
  8014e8:	74 8b                	je     801475 <strsplit+0x23>
  8014ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8014ed:	8a 00                	mov    (%eax),%al
  8014ef:	0f be c0             	movsbl %al,%eax
  8014f2:	50                   	push   %eax
  8014f3:	ff 75 0c             	pushl  0xc(%ebp)
  8014f6:	e8 b5 fa ff ff       	call   800fb0 <strchr>
  8014fb:	83 c4 08             	add    $0x8,%esp
  8014fe:	85 c0                	test   %eax,%eax
  801500:	74 dc                	je     8014de <strsplit+0x8c>
			string++;
	}
  801502:	e9 6e ff ff ff       	jmp    801475 <strsplit+0x23>
		while (*string && strchr(SPLIT_CHARS, *string))
			*string++ = 0;

		//if the command string is finished, then break the loop
		if (*string == 0)
			break;
  801507:	90                   	nop
		// save the previous argument and scan past next arg
		(argv)[(*argc)++] = string;
		while (*string && !strchr(SPLIT_CHARS, *string))
			string++;
	}
	(argv)[*argc] = 0;
  801508:	8b 45 14             	mov    0x14(%ebp),%eax
  80150b:	8b 00                	mov    (%eax),%eax
  80150d:	8d 14 85 00 00 00 00 	lea    0x0(,%eax,4),%edx
  801514:	8b 45 10             	mov    0x10(%ebp),%eax
  801517:	01 d0                	add    %edx,%eax
  801519:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	return 1 ;
  80151f:	b8 01 00 00 00       	mov    $0x1,%eax
}
  801524:	c9                   	leave  
  801525:	c3                   	ret    

00801526 <syscall>:
#include <inc/syscall.h>
#include <inc/lib.h>

static inline uint32
syscall(int num, uint32 a1, uint32 a2, uint32 a3, uint32 a4, uint32 a5)
{
  801526:	55                   	push   %ebp
  801527:	89 e5                	mov    %esp,%ebp
  801529:	57                   	push   %edi
  80152a:	56                   	push   %esi
  80152b:	53                   	push   %ebx
  80152c:	83 ec 10             	sub    $0x10,%esp
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
  80152f:	8b 45 08             	mov    0x8(%ebp),%eax
  801532:	8b 55 0c             	mov    0xc(%ebp),%edx
  801535:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801538:	8b 5d 14             	mov    0x14(%ebp),%ebx
  80153b:	8b 7d 18             	mov    0x18(%ebp),%edi
  80153e:	8b 75 1c             	mov    0x1c(%ebp),%esi
  801541:	cd 30                	int    $0x30
  801543:	89 45 f0             	mov    %eax,-0x10(%ebp)
		  "b" (a3),
		  "D" (a4),
		  "S" (a5)
		: "cc", "memory");

	return ret;
  801546:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  801549:	83 c4 10             	add    $0x10,%esp
  80154c:	5b                   	pop    %ebx
  80154d:	5e                   	pop    %esi
  80154e:	5f                   	pop    %edi
  80154f:	5d                   	pop    %ebp
  801550:	c3                   	ret    

00801551 <sys_cputs>:

void
sys_cputs(const char *s, uint32 len, uint8 printProgName)
{
  801551:	55                   	push   %ebp
  801552:	89 e5                	mov    %esp,%ebp
  801554:	83 ec 04             	sub    $0x4,%esp
  801557:	8b 45 10             	mov    0x10(%ebp),%eax
  80155a:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputs, (uint32) s, len, (uint32)printProgName, 0, 0);
  80155d:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  801561:	8b 45 08             	mov    0x8(%ebp),%eax
  801564:	6a 00                	push   $0x0
  801566:	6a 00                	push   $0x0
  801568:	52                   	push   %edx
  801569:	ff 75 0c             	pushl  0xc(%ebp)
  80156c:	50                   	push   %eax
  80156d:	6a 00                	push   $0x0
  80156f:	e8 b2 ff ff ff       	call   801526 <syscall>
  801574:	83 c4 18             	add    $0x18,%esp
}
  801577:	90                   	nop
  801578:	c9                   	leave  
  801579:	c3                   	ret    

0080157a <sys_cgetc>:

int
sys_cgetc(void)
{
  80157a:	55                   	push   %ebp
  80157b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_cgetc, 0, 0, 0, 0, 0);
  80157d:	6a 00                	push   $0x0
  80157f:	6a 00                	push   $0x0
  801581:	6a 00                	push   $0x0
  801583:	6a 00                	push   $0x0
  801585:	6a 00                	push   $0x0
  801587:	6a 01                	push   $0x1
  801589:	e8 98 ff ff ff       	call   801526 <syscall>
  80158e:	83 c4 18             	add    $0x18,%esp
}
  801591:	c9                   	leave  
  801592:	c3                   	ret    

00801593 <__sys_allocate_page>:

int __sys_allocate_page(void *va, int perm)
{
  801593:	55                   	push   %ebp
  801594:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_allocate_page, (uint32) va, perm, 0 , 0, 0);
  801596:	8b 55 0c             	mov    0xc(%ebp),%edx
  801599:	8b 45 08             	mov    0x8(%ebp),%eax
  80159c:	6a 00                	push   $0x0
  80159e:	6a 00                	push   $0x0
  8015a0:	6a 00                	push   $0x0
  8015a2:	52                   	push   %edx
  8015a3:	50                   	push   %eax
  8015a4:	6a 05                	push   $0x5
  8015a6:	e8 7b ff ff ff       	call   801526 <syscall>
  8015ab:	83 c4 18             	add    $0x18,%esp
}
  8015ae:	c9                   	leave  
  8015af:	c3                   	ret    

008015b0 <__sys_map_frame>:

int __sys_map_frame(int32 srcenv, void *srcva, int32 dstenv, void *dstva, int perm)
{
  8015b0:	55                   	push   %ebp
  8015b1:	89 e5                	mov    %esp,%ebp
  8015b3:	56                   	push   %esi
  8015b4:	53                   	push   %ebx
	return syscall(SYS_map_frame, srcenv, (uint32) srcva, dstenv, (uint32) dstva, perm);
  8015b5:	8b 75 18             	mov    0x18(%ebp),%esi
  8015b8:	8b 5d 14             	mov    0x14(%ebp),%ebx
  8015bb:	8b 4d 10             	mov    0x10(%ebp),%ecx
  8015be:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c4:	56                   	push   %esi
  8015c5:	53                   	push   %ebx
  8015c6:	51                   	push   %ecx
  8015c7:	52                   	push   %edx
  8015c8:	50                   	push   %eax
  8015c9:	6a 06                	push   $0x6
  8015cb:	e8 56 ff ff ff       	call   801526 <syscall>
  8015d0:	83 c4 18             	add    $0x18,%esp
}
  8015d3:	8d 65 f8             	lea    -0x8(%ebp),%esp
  8015d6:	5b                   	pop    %ebx
  8015d7:	5e                   	pop    %esi
  8015d8:	5d                   	pop    %ebp
  8015d9:	c3                   	ret    

008015da <__sys_unmap_frame>:

int __sys_unmap_frame(int32 envid, void *va)
{
  8015da:	55                   	push   %ebp
  8015db:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_unmap_frame, envid, (uint32) va, 0, 0, 0);
  8015dd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8015e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8015e3:	6a 00                	push   $0x0
  8015e5:	6a 00                	push   $0x0
  8015e7:	6a 00                	push   $0x0
  8015e9:	52                   	push   %edx
  8015ea:	50                   	push   %eax
  8015eb:	6a 07                	push   $0x7
  8015ed:	e8 34 ff ff ff       	call   801526 <syscall>
  8015f2:	83 c4 18             	add    $0x18,%esp
}
  8015f5:	c9                   	leave  
  8015f6:	c3                   	ret    

008015f7 <sys_calculate_required_frames>:

uint32 sys_calculate_required_frames(uint32 start_virtual_address, uint32 size)
{
  8015f7:	55                   	push   %ebp
  8015f8:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_req_frames, start_virtual_address, (uint32) size, 0, 0, 0);
  8015fa:	6a 00                	push   $0x0
  8015fc:	6a 00                	push   $0x0
  8015fe:	6a 00                	push   $0x0
  801600:	ff 75 0c             	pushl  0xc(%ebp)
  801603:	ff 75 08             	pushl  0x8(%ebp)
  801606:	6a 08                	push   $0x8
  801608:	e8 19 ff ff ff       	call   801526 <syscall>
  80160d:	83 c4 18             	add    $0x18,%esp
}
  801610:	c9                   	leave  
  801611:	c3                   	ret    

00801612 <sys_calculate_free_frames>:

uint32 sys_calculate_free_frames()
{
  801612:	55                   	push   %ebp
  801613:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_free_frames, 0, 0, 0, 0, 0);
  801615:	6a 00                	push   $0x0
  801617:	6a 00                	push   $0x0
  801619:	6a 00                	push   $0x0
  80161b:	6a 00                	push   $0x0
  80161d:	6a 00                	push   $0x0
  80161f:	6a 09                	push   $0x9
  801621:	e8 00 ff ff ff       	call   801526 <syscall>
  801626:	83 c4 18             	add    $0x18,%esp
}
  801629:	c9                   	leave  
  80162a:	c3                   	ret    

0080162b <sys_calculate_modified_frames>:
uint32 sys_calculate_modified_frames()
{
  80162b:	55                   	push   %ebp
  80162c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_modified_frames, 0, 0, 0, 0, 0);
  80162e:	6a 00                	push   $0x0
  801630:	6a 00                	push   $0x0
  801632:	6a 00                	push   $0x0
  801634:	6a 00                	push   $0x0
  801636:	6a 00                	push   $0x0
  801638:	6a 0a                	push   $0xa
  80163a:	e8 e7 fe ff ff       	call   801526 <syscall>
  80163f:	83 c4 18             	add    $0x18,%esp
}
  801642:	c9                   	leave  
  801643:	c3                   	ret    

00801644 <sys_calculate_notmod_frames>:

uint32 sys_calculate_notmod_frames()
{
  801644:	55                   	push   %ebp
  801645:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calc_notmod_frames, 0, 0, 0, 0, 0);
  801647:	6a 00                	push   $0x0
  801649:	6a 00                	push   $0x0
  80164b:	6a 00                	push   $0x0
  80164d:	6a 00                	push   $0x0
  80164f:	6a 00                	push   $0x0
  801651:	6a 0b                	push   $0xb
  801653:	e8 ce fe ff ff       	call   801526 <syscall>
  801658:	83 c4 18             	add    $0x18,%esp
}
  80165b:	c9                   	leave  
  80165c:	c3                   	ret    

0080165d <sys_free_user_mem>:

void sys_free_user_mem(uint32 virtual_address, uint32 size)
{
  80165d:	55                   	push   %ebp
  80165e:	89 e5                	mov    %esp,%ebp
	syscall(SYS_free_user_mem, virtual_address, size, 0, 0, 0);
  801660:	6a 00                	push   $0x0
  801662:	6a 00                	push   $0x0
  801664:	6a 00                	push   $0x0
  801666:	ff 75 0c             	pushl  0xc(%ebp)
  801669:	ff 75 08             	pushl  0x8(%ebp)
  80166c:	6a 0f                	push   $0xf
  80166e:	e8 b3 fe ff ff       	call   801526 <syscall>
  801673:	83 c4 18             	add    $0x18,%esp
	return;
  801676:	90                   	nop
}
  801677:	c9                   	leave  
  801678:	c3                   	ret    

00801679 <sys_allocate_user_mem>:

void sys_allocate_user_mem(uint32 virtual_address, uint32 size)
{
  801679:	55                   	push   %ebp
  80167a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_user_mem, virtual_address, size, 0, 0, 0);
  80167c:	6a 00                	push   $0x0
  80167e:	6a 00                	push   $0x0
  801680:	6a 00                	push   $0x0
  801682:	ff 75 0c             	pushl  0xc(%ebp)
  801685:	ff 75 08             	pushl  0x8(%ebp)
  801688:	6a 10                	push   $0x10
  80168a:	e8 97 fe ff ff       	call   801526 <syscall>
  80168f:	83 c4 18             	add    $0x18,%esp
	return ;
  801692:	90                   	nop
}
  801693:	c9                   	leave  
  801694:	c3                   	ret    

00801695 <sys_allocate_chunk>:

void sys_allocate_chunk(uint32 virtual_address, uint32 size, uint32 perms)
{
  801695:	55                   	push   %ebp
  801696:	89 e5                	mov    %esp,%ebp
	syscall(SYS_allocate_chunk_in_mem, virtual_address, size, perms, 0, 0);
  801698:	6a 00                	push   $0x0
  80169a:	6a 00                	push   $0x0
  80169c:	ff 75 10             	pushl  0x10(%ebp)
  80169f:	ff 75 0c             	pushl  0xc(%ebp)
  8016a2:	ff 75 08             	pushl  0x8(%ebp)
  8016a5:	6a 11                	push   $0x11
  8016a7:	e8 7a fe ff ff       	call   801526 <syscall>
  8016ac:	83 c4 18             	add    $0x18,%esp
	return ;
  8016af:	90                   	nop
}
  8016b0:	c9                   	leave  
  8016b1:	c3                   	ret    

008016b2 <sys_pf_calculate_allocated_pages>:

int sys_pf_calculate_allocated_pages()
{
  8016b2:	55                   	push   %ebp
  8016b3:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_pf_calc_allocated_pages, 0,0,0,0,0);
  8016b5:	6a 00                	push   $0x0
  8016b7:	6a 00                	push   $0x0
  8016b9:	6a 00                	push   $0x0
  8016bb:	6a 00                	push   $0x0
  8016bd:	6a 00                	push   $0x0
  8016bf:	6a 0c                	push   $0xc
  8016c1:	e8 60 fe ff ff       	call   801526 <syscall>
  8016c6:	83 c4 18             	add    $0x18,%esp
}
  8016c9:	c9                   	leave  
  8016ca:	c3                   	ret    

008016cb <sys_calculate_pages_tobe_removed_ready_exit>:

int sys_calculate_pages_tobe_removed_ready_exit(uint32 WS_or_MEMORY_flag)
{
  8016cb:	55                   	push   %ebp
  8016cc:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_calculate_pages_tobe_removed_ready_exit, WS_or_MEMORY_flag,0,0,0,0);
  8016ce:	6a 00                	push   $0x0
  8016d0:	6a 00                	push   $0x0
  8016d2:	6a 00                	push   $0x0
  8016d4:	6a 00                	push   $0x0
  8016d6:	ff 75 08             	pushl  0x8(%ebp)
  8016d9:	6a 0d                	push   $0xd
  8016db:	e8 46 fe ff ff       	call   801526 <syscall>
  8016e0:	83 c4 18             	add    $0x18,%esp
}
  8016e3:	c9                   	leave  
  8016e4:	c3                   	ret    

008016e5 <sys_scarce_memory>:

void sys_scarce_memory()
{
  8016e5:	55                   	push   %ebp
  8016e6:	89 e5                	mov    %esp,%ebp
	syscall(SYS_scarce_memory,0,0,0,0,0);
  8016e8:	6a 00                	push   $0x0
  8016ea:	6a 00                	push   $0x0
  8016ec:	6a 00                	push   $0x0
  8016ee:	6a 00                	push   $0x0
  8016f0:	6a 00                	push   $0x0
  8016f2:	6a 0e                	push   $0xe
  8016f4:	e8 2d fe ff ff       	call   801526 <syscall>
  8016f9:	83 c4 18             	add    $0x18,%esp
}
  8016fc:	90                   	nop
  8016fd:	c9                   	leave  
  8016fe:	c3                   	ret    

008016ff <sys_disable_interrupt>:

//NEW !! 2012...
void
sys_disable_interrupt()
{
  8016ff:	55                   	push   %ebp
  801700:	89 e5                	mov    %esp,%ebp
	syscall(SYS_disableINTR,0, 0, 0, 0, 0);
  801702:	6a 00                	push   $0x0
  801704:	6a 00                	push   $0x0
  801706:	6a 00                	push   $0x0
  801708:	6a 00                	push   $0x0
  80170a:	6a 00                	push   $0x0
  80170c:	6a 13                	push   $0x13
  80170e:	e8 13 fe ff ff       	call   801526 <syscall>
  801713:	83 c4 18             	add    $0x18,%esp
}
  801716:	90                   	nop
  801717:	c9                   	leave  
  801718:	c3                   	ret    

00801719 <sys_enable_interrupt>:


void
sys_enable_interrupt()
{
  801719:	55                   	push   %ebp
  80171a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_enableINTR,0, 0, 0, 0, 0);
  80171c:	6a 00                	push   $0x0
  80171e:	6a 00                	push   $0x0
  801720:	6a 00                	push   $0x0
  801722:	6a 00                	push   $0x0
  801724:	6a 00                	push   $0x0
  801726:	6a 14                	push   $0x14
  801728:	e8 f9 fd ff ff       	call   801526 <syscall>
  80172d:	83 c4 18             	add    $0x18,%esp
}
  801730:	90                   	nop
  801731:	c9                   	leave  
  801732:	c3                   	ret    

00801733 <sys_cputc>:


void
sys_cputc(const char c)
{
  801733:	55                   	push   %ebp
  801734:	89 e5                	mov    %esp,%ebp
  801736:	83 ec 04             	sub    $0x4,%esp
  801739:	8b 45 08             	mov    0x8(%ebp),%eax
  80173c:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_cputc, (uint32) c, 0, 0, 0, 0);
  80173f:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  801743:	6a 00                	push   $0x0
  801745:	6a 00                	push   $0x0
  801747:	6a 00                	push   $0x0
  801749:	6a 00                	push   $0x0
  80174b:	50                   	push   %eax
  80174c:	6a 15                	push   $0x15
  80174e:	e8 d3 fd ff ff       	call   801526 <syscall>
  801753:	83 c4 18             	add    $0x18,%esp
}
  801756:	90                   	nop
  801757:	c9                   	leave  
  801758:	c3                   	ret    

00801759 <sys_clear_ffl>:


//NEW'12: BONUS2 Testing
void
sys_clear_ffl()
{
  801759:	55                   	push   %ebp
  80175a:	89 e5                	mov    %esp,%ebp
	syscall(SYS_clearFFL,0, 0, 0, 0, 0);
  80175c:	6a 00                	push   $0x0
  80175e:	6a 00                	push   $0x0
  801760:	6a 00                	push   $0x0
  801762:	6a 00                	push   $0x0
  801764:	6a 00                	push   $0x0
  801766:	6a 16                	push   $0x16
  801768:	e8 b9 fd ff ff       	call   801526 <syscall>
  80176d:	83 c4 18             	add    $0x18,%esp
}
  801770:	90                   	nop
  801771:	c9                   	leave  
  801772:	c3                   	ret    

00801773 <sys_createSemaphore>:

int
sys_createSemaphore(char* semaphoreName, uint32 initialValue)
{
  801773:	55                   	push   %ebp
  801774:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_semaphore,(uint32)semaphoreName, (uint32)initialValue, 0, 0, 0);
  801776:	8b 45 08             	mov    0x8(%ebp),%eax
  801779:	6a 00                	push   $0x0
  80177b:	6a 00                	push   $0x0
  80177d:	6a 00                	push   $0x0
  80177f:	ff 75 0c             	pushl  0xc(%ebp)
  801782:	50                   	push   %eax
  801783:	6a 17                	push   $0x17
  801785:	e8 9c fd ff ff       	call   801526 <syscall>
  80178a:	83 c4 18             	add    $0x18,%esp
}
  80178d:	c9                   	leave  
  80178e:	c3                   	ret    

0080178f <sys_getSemaphoreValue>:

int
sys_getSemaphoreValue(int32 ownerEnvID, char* semaphoreName)
{
  80178f:	55                   	push   %ebp
  801790:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_semaphore_value,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  801792:	8b 55 0c             	mov    0xc(%ebp),%edx
  801795:	8b 45 08             	mov    0x8(%ebp),%eax
  801798:	6a 00                	push   $0x0
  80179a:	6a 00                	push   $0x0
  80179c:	6a 00                	push   $0x0
  80179e:	52                   	push   %edx
  80179f:	50                   	push   %eax
  8017a0:	6a 1a                	push   $0x1a
  8017a2:	e8 7f fd ff ff       	call   801526 <syscall>
  8017a7:	83 c4 18             	add    $0x18,%esp
}
  8017aa:	c9                   	leave  
  8017ab:	c3                   	ret    

008017ac <sys_waitSemaphore>:

void
sys_waitSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8017ac:	55                   	push   %ebp
  8017ad:	89 e5                	mov    %esp,%ebp
	syscall(SYS_wait_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8017af:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017b2:	8b 45 08             	mov    0x8(%ebp),%eax
  8017b5:	6a 00                	push   $0x0
  8017b7:	6a 00                	push   $0x0
  8017b9:	6a 00                	push   $0x0
  8017bb:	52                   	push   %edx
  8017bc:	50                   	push   %eax
  8017bd:	6a 18                	push   $0x18
  8017bf:	e8 62 fd ff ff       	call   801526 <syscall>
  8017c4:	83 c4 18             	add    $0x18,%esp
}
  8017c7:	90                   	nop
  8017c8:	c9                   	leave  
  8017c9:	c3                   	ret    

008017ca <sys_signalSemaphore>:

void
sys_signalSemaphore(int32 ownerEnvID, char* semaphoreName)
{
  8017ca:	55                   	push   %ebp
  8017cb:	89 e5                	mov    %esp,%ebp
	syscall(SYS_signal_semaphore,(uint32) ownerEnvID, (uint32)semaphoreName, 0, 0, 0);
  8017cd:	8b 55 0c             	mov    0xc(%ebp),%edx
  8017d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8017d3:	6a 00                	push   $0x0
  8017d5:	6a 00                	push   $0x0
  8017d7:	6a 00                	push   $0x0
  8017d9:	52                   	push   %edx
  8017da:	50                   	push   %eax
  8017db:	6a 19                	push   $0x19
  8017dd:	e8 44 fd ff ff       	call   801526 <syscall>
  8017e2:	83 c4 18             	add    $0x18,%esp
}
  8017e5:	90                   	nop
  8017e6:	c9                   	leave  
  8017e7:	c3                   	ret    

008017e8 <sys_createSharedObject>:

int
sys_createSharedObject(char* shareName, uint32 size, uint8 isWritable, void* virtual_address)
{
  8017e8:	55                   	push   %ebp
  8017e9:	89 e5                	mov    %esp,%ebp
  8017eb:	83 ec 04             	sub    $0x4,%esp
  8017ee:	8b 45 10             	mov    0x10(%ebp),%eax
  8017f1:	88 45 fc             	mov    %al,-0x4(%ebp)
	return syscall(SYS_create_shared_object,(uint32)shareName, (uint32)size, isWritable, (uint32)virtual_address,  0);
  8017f4:	8b 4d 14             	mov    0x14(%ebp),%ecx
  8017f7:	0f b6 55 fc          	movzbl -0x4(%ebp),%edx
  8017fb:	8b 45 08             	mov    0x8(%ebp),%eax
  8017fe:	6a 00                	push   $0x0
  801800:	51                   	push   %ecx
  801801:	52                   	push   %edx
  801802:	ff 75 0c             	pushl  0xc(%ebp)
  801805:	50                   	push   %eax
  801806:	6a 1b                	push   $0x1b
  801808:	e8 19 fd ff ff       	call   801526 <syscall>
  80180d:	83 c4 18             	add    $0x18,%esp
}
  801810:	c9                   	leave  
  801811:	c3                   	ret    

00801812 <sys_getSizeOfSharedObject>:

//2017:
int
sys_getSizeOfSharedObject(int32 ownerID, char* shareName)
{
  801812:	55                   	push   %ebp
  801813:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_size_of_shared_object,(uint32) ownerID, (uint32)shareName, 0, 0, 0);
  801815:	8b 55 0c             	mov    0xc(%ebp),%edx
  801818:	8b 45 08             	mov    0x8(%ebp),%eax
  80181b:	6a 00                	push   $0x0
  80181d:	6a 00                	push   $0x0
  80181f:	6a 00                	push   $0x0
  801821:	52                   	push   %edx
  801822:	50                   	push   %eax
  801823:	6a 1c                	push   $0x1c
  801825:	e8 fc fc ff ff       	call   801526 <syscall>
  80182a:	83 c4 18             	add    $0x18,%esp
}
  80182d:	c9                   	leave  
  80182e:	c3                   	ret    

0080182f <sys_getSharedObject>:
//==========

int
sys_getSharedObject(int32 ownerID, char* shareName, void* virtual_address)
{
  80182f:	55                   	push   %ebp
  801830:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_shared_object,(uint32) ownerID, (uint32)shareName, (uint32)virtual_address, 0, 0);
  801832:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801835:	8b 55 0c             	mov    0xc(%ebp),%edx
  801838:	8b 45 08             	mov    0x8(%ebp),%eax
  80183b:	6a 00                	push   $0x0
  80183d:	6a 00                	push   $0x0
  80183f:	51                   	push   %ecx
  801840:	52                   	push   %edx
  801841:	50                   	push   %eax
  801842:	6a 1d                	push   $0x1d
  801844:	e8 dd fc ff ff       	call   801526 <syscall>
  801849:	83 c4 18             	add    $0x18,%esp
}
  80184c:	c9                   	leave  
  80184d:	c3                   	ret    

0080184e <sys_freeSharedObject>:

int
sys_freeSharedObject(int32 sharedObjectID, void *startVA)
{
  80184e:	55                   	push   %ebp
  80184f:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_free_shared_object,(uint32) sharedObjectID, (uint32) startVA, 0, 0, 0);
  801851:	8b 55 0c             	mov    0xc(%ebp),%edx
  801854:	8b 45 08             	mov    0x8(%ebp),%eax
  801857:	6a 00                	push   $0x0
  801859:	6a 00                	push   $0x0
  80185b:	6a 00                	push   $0x0
  80185d:	52                   	push   %edx
  80185e:	50                   	push   %eax
  80185f:	6a 1e                	push   $0x1e
  801861:	e8 c0 fc ff ff       	call   801526 <syscall>
  801866:	83 c4 18             	add    $0x18,%esp
}
  801869:	c9                   	leave  
  80186a:	c3                   	ret    

0080186b <sys_getMaxShares>:

uint32 	sys_getMaxShares()
{
  80186b:	55                   	push   %ebp
  80186c:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_get_max_shares,0, 0, 0, 0, 0);
  80186e:	6a 00                	push   $0x0
  801870:	6a 00                	push   $0x0
  801872:	6a 00                	push   $0x0
  801874:	6a 00                	push   $0x0
  801876:	6a 00                	push   $0x0
  801878:	6a 1f                	push   $0x1f
  80187a:	e8 a7 fc ff ff       	call   801526 <syscall>
  80187f:	83 c4 18             	add    $0x18,%esp
}
  801882:	c9                   	leave  
  801883:	c3                   	ret    

00801884 <sys_create_env>:

int sys_create_env(char* programName, unsigned int page_WS_size,unsigned int LRU_second_list_size,unsigned int percent_WS_pages_to_remove)
{
  801884:	55                   	push   %ebp
  801885:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_create_env,(uint32)programName, (uint32)page_WS_size,(uint32)LRU_second_list_size, (uint32)percent_WS_pages_to_remove, 0);
  801887:	8b 45 08             	mov    0x8(%ebp),%eax
  80188a:	6a 00                	push   $0x0
  80188c:	ff 75 14             	pushl  0x14(%ebp)
  80188f:	ff 75 10             	pushl  0x10(%ebp)
  801892:	ff 75 0c             	pushl  0xc(%ebp)
  801895:	50                   	push   %eax
  801896:	6a 20                	push   $0x20
  801898:	e8 89 fc ff ff       	call   801526 <syscall>
  80189d:	83 c4 18             	add    $0x18,%esp
}
  8018a0:	c9                   	leave  
  8018a1:	c3                   	ret    

008018a2 <sys_run_env>:

void
sys_run_env(int32 envId)
{
  8018a2:	55                   	push   %ebp
  8018a3:	89 e5                	mov    %esp,%ebp
	syscall(SYS_run_env, (int32)envId, 0, 0, 0, 0);
  8018a5:	8b 45 08             	mov    0x8(%ebp),%eax
  8018a8:	6a 00                	push   $0x0
  8018aa:	6a 00                	push   $0x0
  8018ac:	6a 00                	push   $0x0
  8018ae:	6a 00                	push   $0x0
  8018b0:	50                   	push   %eax
  8018b1:	6a 21                	push   $0x21
  8018b3:	e8 6e fc ff ff       	call   801526 <syscall>
  8018b8:	83 c4 18             	add    $0x18,%esp
}
  8018bb:	90                   	nop
  8018bc:	c9                   	leave  
  8018bd:	c3                   	ret    

008018be <sys_destroy_env>:

int sys_destroy_env(int32  envid)
{
  8018be:	55                   	push   %ebp
  8018bf:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_destroy_env, envid, 0, 0, 0, 0);
  8018c1:	8b 45 08             	mov    0x8(%ebp),%eax
  8018c4:	6a 00                	push   $0x0
  8018c6:	6a 00                	push   $0x0
  8018c8:	6a 00                	push   $0x0
  8018ca:	6a 00                	push   $0x0
  8018cc:	50                   	push   %eax
  8018cd:	6a 22                	push   $0x22
  8018cf:	e8 52 fc ff ff       	call   801526 <syscall>
  8018d4:	83 c4 18             	add    $0x18,%esp
}
  8018d7:	c9                   	leave  
  8018d8:	c3                   	ret    

008018d9 <sys_getenvid>:

int32 sys_getenvid(void)
{
  8018d9:	55                   	push   %ebp
  8018da:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvid, 0, 0, 0, 0, 0);
  8018dc:	6a 00                	push   $0x0
  8018de:	6a 00                	push   $0x0
  8018e0:	6a 00                	push   $0x0
  8018e2:	6a 00                	push   $0x0
  8018e4:	6a 00                	push   $0x0
  8018e6:	6a 02                	push   $0x2
  8018e8:	e8 39 fc ff ff       	call   801526 <syscall>
  8018ed:	83 c4 18             	add    $0x18,%esp
}
  8018f0:	c9                   	leave  
  8018f1:	c3                   	ret    

008018f2 <sys_getenvindex>:

//2017
int32 sys_getenvindex(void)
{
  8018f2:	55                   	push   %ebp
  8018f3:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getenvindex, 0, 0, 0, 0, 0);
  8018f5:	6a 00                	push   $0x0
  8018f7:	6a 00                	push   $0x0
  8018f9:	6a 00                	push   $0x0
  8018fb:	6a 00                	push   $0x0
  8018fd:	6a 00                	push   $0x0
  8018ff:	6a 03                	push   $0x3
  801901:	e8 20 fc ff ff       	call   801526 <syscall>
  801906:	83 c4 18             	add    $0x18,%esp
}
  801909:	c9                   	leave  
  80190a:	c3                   	ret    

0080190b <sys_getparentenvid>:

int32 sys_getparentenvid(void)
{
  80190b:	55                   	push   %ebp
  80190c:	89 e5                	mov    %esp,%ebp
	 return syscall(SYS_getparentenvid, 0, 0, 0, 0, 0);
  80190e:	6a 00                	push   $0x0
  801910:	6a 00                	push   $0x0
  801912:	6a 00                	push   $0x0
  801914:	6a 00                	push   $0x0
  801916:	6a 00                	push   $0x0
  801918:	6a 04                	push   $0x4
  80191a:	e8 07 fc ff ff       	call   801526 <syscall>
  80191f:	83 c4 18             	add    $0x18,%esp
}
  801922:	c9                   	leave  
  801923:	c3                   	ret    

00801924 <sys_exit_env>:


void sys_exit_env(void)
{
  801924:	55                   	push   %ebp
  801925:	89 e5                	mov    %esp,%ebp
	syscall(SYS_exit_env, 0, 0, 0, 0, 0);
  801927:	6a 00                	push   $0x0
  801929:	6a 00                	push   $0x0
  80192b:	6a 00                	push   $0x0
  80192d:	6a 00                	push   $0x0
  80192f:	6a 00                	push   $0x0
  801931:	6a 23                	push   $0x23
  801933:	e8 ee fb ff ff       	call   801526 <syscall>
  801938:	83 c4 18             	add    $0x18,%esp
}
  80193b:	90                   	nop
  80193c:	c9                   	leave  
  80193d:	c3                   	ret    

0080193e <sys_get_virtual_time>:


struct uint64
sys_get_virtual_time()
{
  80193e:	55                   	push   %ebp
  80193f:	89 e5                	mov    %esp,%ebp
  801941:	83 ec 10             	sub    $0x10,%esp
	struct uint64 result;
	syscall(SYS_get_virtual_time, (uint32)&(result.low), (uint32)&(result.hi), 0, 0, 0);
  801944:	8d 45 f8             	lea    -0x8(%ebp),%eax
  801947:	8d 50 04             	lea    0x4(%eax),%edx
  80194a:	8d 45 f8             	lea    -0x8(%ebp),%eax
  80194d:	6a 00                	push   $0x0
  80194f:	6a 00                	push   $0x0
  801951:	6a 00                	push   $0x0
  801953:	52                   	push   %edx
  801954:	50                   	push   %eax
  801955:	6a 24                	push   $0x24
  801957:	e8 ca fb ff ff       	call   801526 <syscall>
  80195c:	83 c4 18             	add    $0x18,%esp
	return result;
  80195f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  801962:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801965:	8b 55 fc             	mov    -0x4(%ebp),%edx
  801968:	89 01                	mov    %eax,(%ecx)
  80196a:	89 51 04             	mov    %edx,0x4(%ecx)
}
  80196d:	8b 45 08             	mov    0x8(%ebp),%eax
  801970:	c9                   	leave  
  801971:	c2 04 00             	ret    $0x4

00801974 <sys_move_user_mem>:

// 2014
void sys_move_user_mem(uint32 src_virtual_address, uint32 dst_virtual_address, uint32 size)
{
  801974:	55                   	push   %ebp
  801975:	89 e5                	mov    %esp,%ebp
	syscall(SYS_move_user_mem, src_virtual_address, dst_virtual_address, size, 0, 0);
  801977:	6a 00                	push   $0x0
  801979:	6a 00                	push   $0x0
  80197b:	ff 75 10             	pushl  0x10(%ebp)
  80197e:	ff 75 0c             	pushl  0xc(%ebp)
  801981:	ff 75 08             	pushl  0x8(%ebp)
  801984:	6a 12                	push   $0x12
  801986:	e8 9b fb ff ff       	call   801526 <syscall>
  80198b:	83 c4 18             	add    $0x18,%esp
	return ;
  80198e:	90                   	nop
}
  80198f:	c9                   	leave  
  801990:	c3                   	ret    

00801991 <sys_rcr2>:
uint32 sys_rcr2()
{
  801991:	55                   	push   %ebp
  801992:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_rcr2, 0, 0, 0, 0, 0);
  801994:	6a 00                	push   $0x0
  801996:	6a 00                	push   $0x0
  801998:	6a 00                	push   $0x0
  80199a:	6a 00                	push   $0x0
  80199c:	6a 00                	push   $0x0
  80199e:	6a 25                	push   $0x25
  8019a0:	e8 81 fb ff ff       	call   801526 <syscall>
  8019a5:	83 c4 18             	add    $0x18,%esp
}
  8019a8:	c9                   	leave  
  8019a9:	c3                   	ret    

008019aa <sys_bypassPageFault>:
void sys_bypassPageFault(uint8 instrLength)
{
  8019aa:	55                   	push   %ebp
  8019ab:	89 e5                	mov    %esp,%ebp
  8019ad:	83 ec 04             	sub    $0x4,%esp
  8019b0:	8b 45 08             	mov    0x8(%ebp),%eax
  8019b3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_bypassPageFault, instrLength, 0, 0, 0, 0);
  8019b6:	0f b6 45 fc          	movzbl -0x4(%ebp),%eax
  8019ba:	6a 00                	push   $0x0
  8019bc:	6a 00                	push   $0x0
  8019be:	6a 00                	push   $0x0
  8019c0:	6a 00                	push   $0x0
  8019c2:	50                   	push   %eax
  8019c3:	6a 26                	push   $0x26
  8019c5:	e8 5c fb ff ff       	call   801526 <syscall>
  8019ca:	83 c4 18             	add    $0x18,%esp
	return ;
  8019cd:	90                   	nop
}
  8019ce:	c9                   	leave  
  8019cf:	c3                   	ret    

008019d0 <rsttst>:
void rsttst()
{
  8019d0:	55                   	push   %ebp
  8019d1:	89 e5                	mov    %esp,%ebp
	syscall(SYS_rsttst, 0, 0, 0, 0, 0);
  8019d3:	6a 00                	push   $0x0
  8019d5:	6a 00                	push   $0x0
  8019d7:	6a 00                	push   $0x0
  8019d9:	6a 00                	push   $0x0
  8019db:	6a 00                	push   $0x0
  8019dd:	6a 28                	push   $0x28
  8019df:	e8 42 fb ff ff       	call   801526 <syscall>
  8019e4:	83 c4 18             	add    $0x18,%esp
	return ;
  8019e7:	90                   	nop
}
  8019e8:	c9                   	leave  
  8019e9:	c3                   	ret    

008019ea <tst>:
void tst(uint32 n, uint32 v1, uint32 v2, char c, int inv)
{
  8019ea:	55                   	push   %ebp
  8019eb:	89 e5                	mov    %esp,%ebp
  8019ed:	83 ec 04             	sub    $0x4,%esp
  8019f0:	8b 45 14             	mov    0x14(%ebp),%eax
  8019f3:	88 45 fc             	mov    %al,-0x4(%ebp)
	syscall(SYS_testNum, n, v1, v2, c, inv);
  8019f6:	8b 55 18             	mov    0x18(%ebp),%edx
  8019f9:	0f be 45 fc          	movsbl -0x4(%ebp),%eax
  8019fd:	52                   	push   %edx
  8019fe:	50                   	push   %eax
  8019ff:	ff 75 10             	pushl  0x10(%ebp)
  801a02:	ff 75 0c             	pushl  0xc(%ebp)
  801a05:	ff 75 08             	pushl  0x8(%ebp)
  801a08:	6a 27                	push   $0x27
  801a0a:	e8 17 fb ff ff       	call   801526 <syscall>
  801a0f:	83 c4 18             	add    $0x18,%esp
	return ;
  801a12:	90                   	nop
}
  801a13:	c9                   	leave  
  801a14:	c3                   	ret    

00801a15 <chktst>:
void chktst(uint32 n)
{
  801a15:	55                   	push   %ebp
  801a16:	89 e5                	mov    %esp,%ebp
	syscall(SYS_chktst, n, 0, 0, 0, 0);
  801a18:	6a 00                	push   $0x0
  801a1a:	6a 00                	push   $0x0
  801a1c:	6a 00                	push   $0x0
  801a1e:	6a 00                	push   $0x0
  801a20:	ff 75 08             	pushl  0x8(%ebp)
  801a23:	6a 29                	push   $0x29
  801a25:	e8 fc fa ff ff       	call   801526 <syscall>
  801a2a:	83 c4 18             	add    $0x18,%esp
	return ;
  801a2d:	90                   	nop
}
  801a2e:	c9                   	leave  
  801a2f:	c3                   	ret    

00801a30 <inctst>:

void inctst()
{
  801a30:	55                   	push   %ebp
  801a31:	89 e5                	mov    %esp,%ebp
	syscall(SYS_inctst, 0, 0, 0, 0, 0);
  801a33:	6a 00                	push   $0x0
  801a35:	6a 00                	push   $0x0
  801a37:	6a 00                	push   $0x0
  801a39:	6a 00                	push   $0x0
  801a3b:	6a 00                	push   $0x0
  801a3d:	6a 2a                	push   $0x2a
  801a3f:	e8 e2 fa ff ff       	call   801526 <syscall>
  801a44:	83 c4 18             	add    $0x18,%esp
	return ;
  801a47:	90                   	nop
}
  801a48:	c9                   	leave  
  801a49:	c3                   	ret    

00801a4a <gettst>:
uint32 gettst()
{
  801a4a:	55                   	push   %ebp
  801a4b:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_gettst, 0, 0, 0, 0, 0);
  801a4d:	6a 00                	push   $0x0
  801a4f:	6a 00                	push   $0x0
  801a51:	6a 00                	push   $0x0
  801a53:	6a 00                	push   $0x0
  801a55:	6a 00                	push   $0x0
  801a57:	6a 2b                	push   $0x2b
  801a59:	e8 c8 fa ff ff       	call   801526 <syscall>
  801a5e:	83 c4 18             	add    $0x18,%esp
}
  801a61:	c9                   	leave  
  801a62:	c3                   	ret    

00801a63 <sys_isUHeapPlacementStrategyFIRSTFIT>:


//2015
uint32 sys_isUHeapPlacementStrategyFIRSTFIT()
{
  801a63:	55                   	push   %ebp
  801a64:	89 e5                	mov    %esp,%ebp
  801a66:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a69:	6a 00                	push   $0x0
  801a6b:	6a 00                	push   $0x0
  801a6d:	6a 00                	push   $0x0
  801a6f:	6a 00                	push   $0x0
  801a71:	6a 00                	push   $0x0
  801a73:	6a 2c                	push   $0x2c
  801a75:	e8 ac fa ff ff       	call   801526 <syscall>
  801a7a:	83 c4 18             	add    $0x18,%esp
  801a7d:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_FIRSTFIT)
  801a80:	83 7d fc 01          	cmpl   $0x1,-0x4(%ebp)
  801a84:	75 07                	jne    801a8d <sys_isUHeapPlacementStrategyFIRSTFIT+0x2a>
		return 1;
  801a86:	b8 01 00 00 00       	mov    $0x1,%eax
  801a8b:	eb 05                	jmp    801a92 <sys_isUHeapPlacementStrategyFIRSTFIT+0x2f>
	else
		return 0;
  801a8d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801a92:	c9                   	leave  
  801a93:	c3                   	ret    

00801a94 <sys_isUHeapPlacementStrategyBESTFIT>:
uint32 sys_isUHeapPlacementStrategyBESTFIT()
{
  801a94:	55                   	push   %ebp
  801a95:	89 e5                	mov    %esp,%ebp
  801a97:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801a9a:	6a 00                	push   $0x0
  801a9c:	6a 00                	push   $0x0
  801a9e:	6a 00                	push   $0x0
  801aa0:	6a 00                	push   $0x0
  801aa2:	6a 00                	push   $0x0
  801aa4:	6a 2c                	push   $0x2c
  801aa6:	e8 7b fa ff ff       	call   801526 <syscall>
  801aab:	83 c4 18             	add    $0x18,%esp
  801aae:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_BESTFIT)
  801ab1:	83 7d fc 02          	cmpl   $0x2,-0x4(%ebp)
  801ab5:	75 07                	jne    801abe <sys_isUHeapPlacementStrategyBESTFIT+0x2a>
		return 1;
  801ab7:	b8 01 00 00 00       	mov    $0x1,%eax
  801abc:	eb 05                	jmp    801ac3 <sys_isUHeapPlacementStrategyBESTFIT+0x2f>
	else
		return 0;
  801abe:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801ac3:	c9                   	leave  
  801ac4:	c3                   	ret    

00801ac5 <sys_isUHeapPlacementStrategyNEXTFIT>:
uint32 sys_isUHeapPlacementStrategyNEXTFIT()
{
  801ac5:	55                   	push   %ebp
  801ac6:	89 e5                	mov    %esp,%ebp
  801ac8:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801acb:	6a 00                	push   $0x0
  801acd:	6a 00                	push   $0x0
  801acf:	6a 00                	push   $0x0
  801ad1:	6a 00                	push   $0x0
  801ad3:	6a 00                	push   $0x0
  801ad5:	6a 2c                	push   $0x2c
  801ad7:	e8 4a fa ff ff       	call   801526 <syscall>
  801adc:	83 c4 18             	add    $0x18,%esp
  801adf:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_NEXTFIT)
  801ae2:	83 7d fc 03          	cmpl   $0x3,-0x4(%ebp)
  801ae6:	75 07                	jne    801aef <sys_isUHeapPlacementStrategyNEXTFIT+0x2a>
		return 1;
  801ae8:	b8 01 00 00 00       	mov    $0x1,%eax
  801aed:	eb 05                	jmp    801af4 <sys_isUHeapPlacementStrategyNEXTFIT+0x2f>
	else
		return 0;
  801aef:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801af4:	c9                   	leave  
  801af5:	c3                   	ret    

00801af6 <sys_isUHeapPlacementStrategyWORSTFIT>:
uint32 sys_isUHeapPlacementStrategyWORSTFIT()
{
  801af6:	55                   	push   %ebp
  801af7:	89 e5                	mov    %esp,%ebp
  801af9:	83 ec 10             	sub    $0x10,%esp
	uint32 ret = syscall(SYS_get_heap_strategy, 0, 0, 0, 0, 0);
  801afc:	6a 00                	push   $0x0
  801afe:	6a 00                	push   $0x0
  801b00:	6a 00                	push   $0x0
  801b02:	6a 00                	push   $0x0
  801b04:	6a 00                	push   $0x0
  801b06:	6a 2c                	push   $0x2c
  801b08:	e8 19 fa ff ff       	call   801526 <syscall>
  801b0d:	83 c4 18             	add    $0x18,%esp
  801b10:	89 45 fc             	mov    %eax,-0x4(%ebp)
	if (ret == UHP_PLACE_WORSTFIT)
  801b13:	83 7d fc 04          	cmpl   $0x4,-0x4(%ebp)
  801b17:	75 07                	jne    801b20 <sys_isUHeapPlacementStrategyWORSTFIT+0x2a>
		return 1;
  801b19:	b8 01 00 00 00       	mov    $0x1,%eax
  801b1e:	eb 05                	jmp    801b25 <sys_isUHeapPlacementStrategyWORSTFIT+0x2f>
	else
		return 0;
  801b20:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801b25:	c9                   	leave  
  801b26:	c3                   	ret    

00801b27 <sys_set_uheap_strategy>:

void sys_set_uheap_strategy(uint32 heapStrategy)
{
  801b27:	55                   	push   %ebp
  801b28:	89 e5                	mov    %esp,%ebp
	syscall(SYS_set_heap_strategy, heapStrategy, 0, 0, 0, 0);
  801b2a:	6a 00                	push   $0x0
  801b2c:	6a 00                	push   $0x0
  801b2e:	6a 00                	push   $0x0
  801b30:	6a 00                	push   $0x0
  801b32:	ff 75 08             	pushl  0x8(%ebp)
  801b35:	6a 2d                	push   $0x2d
  801b37:	e8 ea f9 ff ff       	call   801526 <syscall>
  801b3c:	83 c4 18             	add    $0x18,%esp
	return ;
  801b3f:	90                   	nop
}
  801b40:	c9                   	leave  
  801b41:	c3                   	ret    

00801b42 <sys_check_LRU_lists>:

//2020
int sys_check_LRU_lists(uint32* active_list_content, uint32* second_list_content, int actual_active_list_size, int actual_second_list_size)
{
  801b42:	55                   	push   %ebp
  801b43:	89 e5                	mov    %esp,%ebp
  801b45:	53                   	push   %ebx
	return syscall(SYS_check_LRU_lists, (uint32)active_list_content, (uint32)second_list_content, (uint32)actual_active_list_size, (uint32)actual_second_list_size, 0);
  801b46:	8b 5d 14             	mov    0x14(%ebp),%ebx
  801b49:	8b 4d 10             	mov    0x10(%ebp),%ecx
  801b4c:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b4f:	8b 45 08             	mov    0x8(%ebp),%eax
  801b52:	6a 00                	push   $0x0
  801b54:	53                   	push   %ebx
  801b55:	51                   	push   %ecx
  801b56:	52                   	push   %edx
  801b57:	50                   	push   %eax
  801b58:	6a 2e                	push   $0x2e
  801b5a:	e8 c7 f9 ff ff       	call   801526 <syscall>
  801b5f:	83 c4 18             	add    $0x18,%esp
}
  801b62:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  801b65:	c9                   	leave  
  801b66:	c3                   	ret    

00801b67 <sys_check_LRU_lists_free>:

int sys_check_LRU_lists_free(uint32* list_content, int list_size)
{
  801b67:	55                   	push   %ebp
  801b68:	89 e5                	mov    %esp,%ebp
	return syscall(SYS_check_LRU_lists_free, (uint32)list_content, (uint32)list_size , 0, 0, 0);
  801b6a:	8b 55 0c             	mov    0xc(%ebp),%edx
  801b6d:	8b 45 08             	mov    0x8(%ebp),%eax
  801b70:	6a 00                	push   $0x0
  801b72:	6a 00                	push   $0x0
  801b74:	6a 00                	push   $0x0
  801b76:	52                   	push   %edx
  801b77:	50                   	push   %eax
  801b78:	6a 2f                	push   $0x2f
  801b7a:	e8 a7 f9 ff ff       	call   801526 <syscall>
  801b7f:	83 c4 18             	add    $0x18,%esp
}
  801b82:	c9                   	leave  
  801b83:	c3                   	ret    

00801b84 <__udivdi3>:
  801b84:	55                   	push   %ebp
  801b85:	57                   	push   %edi
  801b86:	56                   	push   %esi
  801b87:	53                   	push   %ebx
  801b88:	83 ec 1c             	sub    $0x1c,%esp
  801b8b:	8b 5c 24 30          	mov    0x30(%esp),%ebx
  801b8f:	8b 4c 24 34          	mov    0x34(%esp),%ecx
  801b93:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801b97:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  801b9b:	89 ca                	mov    %ecx,%edx
  801b9d:	89 f8                	mov    %edi,%eax
  801b9f:	8b 74 24 3c          	mov    0x3c(%esp),%esi
  801ba3:	85 f6                	test   %esi,%esi
  801ba5:	75 2d                	jne    801bd4 <__udivdi3+0x50>
  801ba7:	39 cf                	cmp    %ecx,%edi
  801ba9:	77 65                	ja     801c10 <__udivdi3+0x8c>
  801bab:	89 fd                	mov    %edi,%ebp
  801bad:	85 ff                	test   %edi,%edi
  801baf:	75 0b                	jne    801bbc <__udivdi3+0x38>
  801bb1:	b8 01 00 00 00       	mov    $0x1,%eax
  801bb6:	31 d2                	xor    %edx,%edx
  801bb8:	f7 f7                	div    %edi
  801bba:	89 c5                	mov    %eax,%ebp
  801bbc:	31 d2                	xor    %edx,%edx
  801bbe:	89 c8                	mov    %ecx,%eax
  801bc0:	f7 f5                	div    %ebp
  801bc2:	89 c1                	mov    %eax,%ecx
  801bc4:	89 d8                	mov    %ebx,%eax
  801bc6:	f7 f5                	div    %ebp
  801bc8:	89 cf                	mov    %ecx,%edi
  801bca:	89 fa                	mov    %edi,%edx
  801bcc:	83 c4 1c             	add    $0x1c,%esp
  801bcf:	5b                   	pop    %ebx
  801bd0:	5e                   	pop    %esi
  801bd1:	5f                   	pop    %edi
  801bd2:	5d                   	pop    %ebp
  801bd3:	c3                   	ret    
  801bd4:	39 ce                	cmp    %ecx,%esi
  801bd6:	77 28                	ja     801c00 <__udivdi3+0x7c>
  801bd8:	0f bd fe             	bsr    %esi,%edi
  801bdb:	83 f7 1f             	xor    $0x1f,%edi
  801bde:	75 40                	jne    801c20 <__udivdi3+0x9c>
  801be0:	39 ce                	cmp    %ecx,%esi
  801be2:	72 0a                	jb     801bee <__udivdi3+0x6a>
  801be4:	3b 44 24 08          	cmp    0x8(%esp),%eax
  801be8:	0f 87 9e 00 00 00    	ja     801c8c <__udivdi3+0x108>
  801bee:	b8 01 00 00 00       	mov    $0x1,%eax
  801bf3:	89 fa                	mov    %edi,%edx
  801bf5:	83 c4 1c             	add    $0x1c,%esp
  801bf8:	5b                   	pop    %ebx
  801bf9:	5e                   	pop    %esi
  801bfa:	5f                   	pop    %edi
  801bfb:	5d                   	pop    %ebp
  801bfc:	c3                   	ret    
  801bfd:	8d 76 00             	lea    0x0(%esi),%esi
  801c00:	31 ff                	xor    %edi,%edi
  801c02:	31 c0                	xor    %eax,%eax
  801c04:	89 fa                	mov    %edi,%edx
  801c06:	83 c4 1c             	add    $0x1c,%esp
  801c09:	5b                   	pop    %ebx
  801c0a:	5e                   	pop    %esi
  801c0b:	5f                   	pop    %edi
  801c0c:	5d                   	pop    %ebp
  801c0d:	c3                   	ret    
  801c0e:	66 90                	xchg   %ax,%ax
  801c10:	89 d8                	mov    %ebx,%eax
  801c12:	f7 f7                	div    %edi
  801c14:	31 ff                	xor    %edi,%edi
  801c16:	89 fa                	mov    %edi,%edx
  801c18:	83 c4 1c             	add    $0x1c,%esp
  801c1b:	5b                   	pop    %ebx
  801c1c:	5e                   	pop    %esi
  801c1d:	5f                   	pop    %edi
  801c1e:	5d                   	pop    %ebp
  801c1f:	c3                   	ret    
  801c20:	bd 20 00 00 00       	mov    $0x20,%ebp
  801c25:	89 eb                	mov    %ebp,%ebx
  801c27:	29 fb                	sub    %edi,%ebx
  801c29:	89 f9                	mov    %edi,%ecx
  801c2b:	d3 e6                	shl    %cl,%esi
  801c2d:	89 c5                	mov    %eax,%ebp
  801c2f:	88 d9                	mov    %bl,%cl
  801c31:	d3 ed                	shr    %cl,%ebp
  801c33:	89 e9                	mov    %ebp,%ecx
  801c35:	09 f1                	or     %esi,%ecx
  801c37:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
  801c3b:	89 f9                	mov    %edi,%ecx
  801c3d:	d3 e0                	shl    %cl,%eax
  801c3f:	89 c5                	mov    %eax,%ebp
  801c41:	89 d6                	mov    %edx,%esi
  801c43:	88 d9                	mov    %bl,%cl
  801c45:	d3 ee                	shr    %cl,%esi
  801c47:	89 f9                	mov    %edi,%ecx
  801c49:	d3 e2                	shl    %cl,%edx
  801c4b:	8b 44 24 08          	mov    0x8(%esp),%eax
  801c4f:	88 d9                	mov    %bl,%cl
  801c51:	d3 e8                	shr    %cl,%eax
  801c53:	09 c2                	or     %eax,%edx
  801c55:	89 d0                	mov    %edx,%eax
  801c57:	89 f2                	mov    %esi,%edx
  801c59:	f7 74 24 0c          	divl   0xc(%esp)
  801c5d:	89 d6                	mov    %edx,%esi
  801c5f:	89 c3                	mov    %eax,%ebx
  801c61:	f7 e5                	mul    %ebp
  801c63:	39 d6                	cmp    %edx,%esi
  801c65:	72 19                	jb     801c80 <__udivdi3+0xfc>
  801c67:	74 0b                	je     801c74 <__udivdi3+0xf0>
  801c69:	89 d8                	mov    %ebx,%eax
  801c6b:	31 ff                	xor    %edi,%edi
  801c6d:	e9 58 ff ff ff       	jmp    801bca <__udivdi3+0x46>
  801c72:	66 90                	xchg   %ax,%ax
  801c74:	8b 54 24 08          	mov    0x8(%esp),%edx
  801c78:	89 f9                	mov    %edi,%ecx
  801c7a:	d3 e2                	shl    %cl,%edx
  801c7c:	39 c2                	cmp    %eax,%edx
  801c7e:	73 e9                	jae    801c69 <__udivdi3+0xe5>
  801c80:	8d 43 ff             	lea    -0x1(%ebx),%eax
  801c83:	31 ff                	xor    %edi,%edi
  801c85:	e9 40 ff ff ff       	jmp    801bca <__udivdi3+0x46>
  801c8a:	66 90                	xchg   %ax,%ax
  801c8c:	31 c0                	xor    %eax,%eax
  801c8e:	e9 37 ff ff ff       	jmp    801bca <__udivdi3+0x46>
  801c93:	90                   	nop

00801c94 <__umoddi3>:
  801c94:	55                   	push   %ebp
  801c95:	57                   	push   %edi
  801c96:	56                   	push   %esi
  801c97:	53                   	push   %ebx
  801c98:	83 ec 1c             	sub    $0x1c,%esp
  801c9b:	8b 4c 24 30          	mov    0x30(%esp),%ecx
  801c9f:	8b 74 24 34          	mov    0x34(%esp),%esi
  801ca3:	8b 7c 24 38          	mov    0x38(%esp),%edi
  801ca7:	8b 44 24 3c          	mov    0x3c(%esp),%eax
  801cab:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801caf:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  801cb3:	89 f3                	mov    %esi,%ebx
  801cb5:	89 fa                	mov    %edi,%edx
  801cb7:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801cbb:	89 34 24             	mov    %esi,(%esp)
  801cbe:	85 c0                	test   %eax,%eax
  801cc0:	75 1a                	jne    801cdc <__umoddi3+0x48>
  801cc2:	39 f7                	cmp    %esi,%edi
  801cc4:	0f 86 a2 00 00 00    	jbe    801d6c <__umoddi3+0xd8>
  801cca:	89 c8                	mov    %ecx,%eax
  801ccc:	89 f2                	mov    %esi,%edx
  801cce:	f7 f7                	div    %edi
  801cd0:	89 d0                	mov    %edx,%eax
  801cd2:	31 d2                	xor    %edx,%edx
  801cd4:	83 c4 1c             	add    $0x1c,%esp
  801cd7:	5b                   	pop    %ebx
  801cd8:	5e                   	pop    %esi
  801cd9:	5f                   	pop    %edi
  801cda:	5d                   	pop    %ebp
  801cdb:	c3                   	ret    
  801cdc:	39 f0                	cmp    %esi,%eax
  801cde:	0f 87 ac 00 00 00    	ja     801d90 <__umoddi3+0xfc>
  801ce4:	0f bd e8             	bsr    %eax,%ebp
  801ce7:	83 f5 1f             	xor    $0x1f,%ebp
  801cea:	0f 84 ac 00 00 00    	je     801d9c <__umoddi3+0x108>
  801cf0:	bf 20 00 00 00       	mov    $0x20,%edi
  801cf5:	29 ef                	sub    %ebp,%edi
  801cf7:	89 fe                	mov    %edi,%esi
  801cf9:	89 7c 24 0c          	mov    %edi,0xc(%esp)
  801cfd:	89 e9                	mov    %ebp,%ecx
  801cff:	d3 e0                	shl    %cl,%eax
  801d01:	89 d7                	mov    %edx,%edi
  801d03:	89 f1                	mov    %esi,%ecx
  801d05:	d3 ef                	shr    %cl,%edi
  801d07:	09 c7                	or     %eax,%edi
  801d09:	89 e9                	mov    %ebp,%ecx
  801d0b:	d3 e2                	shl    %cl,%edx
  801d0d:	89 14 24             	mov    %edx,(%esp)
  801d10:	89 d8                	mov    %ebx,%eax
  801d12:	d3 e0                	shl    %cl,%eax
  801d14:	89 c2                	mov    %eax,%edx
  801d16:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d1a:	d3 e0                	shl    %cl,%eax
  801d1c:	89 44 24 04          	mov    %eax,0x4(%esp)
  801d20:	8b 44 24 08          	mov    0x8(%esp),%eax
  801d24:	89 f1                	mov    %esi,%ecx
  801d26:	d3 e8                	shr    %cl,%eax
  801d28:	09 d0                	or     %edx,%eax
  801d2a:	d3 eb                	shr    %cl,%ebx
  801d2c:	89 da                	mov    %ebx,%edx
  801d2e:	f7 f7                	div    %edi
  801d30:	89 d3                	mov    %edx,%ebx
  801d32:	f7 24 24             	mull   (%esp)
  801d35:	89 c6                	mov    %eax,%esi
  801d37:	89 d1                	mov    %edx,%ecx
  801d39:	39 d3                	cmp    %edx,%ebx
  801d3b:	0f 82 87 00 00 00    	jb     801dc8 <__umoddi3+0x134>
  801d41:	0f 84 91 00 00 00    	je     801dd8 <__umoddi3+0x144>
  801d47:	8b 54 24 04          	mov    0x4(%esp),%edx
  801d4b:	29 f2                	sub    %esi,%edx
  801d4d:	19 cb                	sbb    %ecx,%ebx
  801d4f:	89 d8                	mov    %ebx,%eax
  801d51:	8a 4c 24 0c          	mov    0xc(%esp),%cl
  801d55:	d3 e0                	shl    %cl,%eax
  801d57:	89 e9                	mov    %ebp,%ecx
  801d59:	d3 ea                	shr    %cl,%edx
  801d5b:	09 d0                	or     %edx,%eax
  801d5d:	89 e9                	mov    %ebp,%ecx
  801d5f:	d3 eb                	shr    %cl,%ebx
  801d61:	89 da                	mov    %ebx,%edx
  801d63:	83 c4 1c             	add    $0x1c,%esp
  801d66:	5b                   	pop    %ebx
  801d67:	5e                   	pop    %esi
  801d68:	5f                   	pop    %edi
  801d69:	5d                   	pop    %ebp
  801d6a:	c3                   	ret    
  801d6b:	90                   	nop
  801d6c:	89 fd                	mov    %edi,%ebp
  801d6e:	85 ff                	test   %edi,%edi
  801d70:	75 0b                	jne    801d7d <__umoddi3+0xe9>
  801d72:	b8 01 00 00 00       	mov    $0x1,%eax
  801d77:	31 d2                	xor    %edx,%edx
  801d79:	f7 f7                	div    %edi
  801d7b:	89 c5                	mov    %eax,%ebp
  801d7d:	89 f0                	mov    %esi,%eax
  801d7f:	31 d2                	xor    %edx,%edx
  801d81:	f7 f5                	div    %ebp
  801d83:	89 c8                	mov    %ecx,%eax
  801d85:	f7 f5                	div    %ebp
  801d87:	89 d0                	mov    %edx,%eax
  801d89:	e9 44 ff ff ff       	jmp    801cd2 <__umoddi3+0x3e>
  801d8e:	66 90                	xchg   %ax,%ax
  801d90:	89 c8                	mov    %ecx,%eax
  801d92:	89 f2                	mov    %esi,%edx
  801d94:	83 c4 1c             	add    $0x1c,%esp
  801d97:	5b                   	pop    %ebx
  801d98:	5e                   	pop    %esi
  801d99:	5f                   	pop    %edi
  801d9a:	5d                   	pop    %ebp
  801d9b:	c3                   	ret    
  801d9c:	3b 04 24             	cmp    (%esp),%eax
  801d9f:	72 06                	jb     801da7 <__umoddi3+0x113>
  801da1:	3b 7c 24 04          	cmp    0x4(%esp),%edi
  801da5:	77 0f                	ja     801db6 <__umoddi3+0x122>
  801da7:	89 f2                	mov    %esi,%edx
  801da9:	29 f9                	sub    %edi,%ecx
  801dab:	1b 54 24 0c          	sbb    0xc(%esp),%edx
  801daf:	89 14 24             	mov    %edx,(%esp)
  801db2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  801db6:	8b 44 24 04          	mov    0x4(%esp),%eax
  801dba:	8b 14 24             	mov    (%esp),%edx
  801dbd:	83 c4 1c             	add    $0x1c,%esp
  801dc0:	5b                   	pop    %ebx
  801dc1:	5e                   	pop    %esi
  801dc2:	5f                   	pop    %edi
  801dc3:	5d                   	pop    %ebp
  801dc4:	c3                   	ret    
  801dc5:	8d 76 00             	lea    0x0(%esi),%esi
  801dc8:	2b 04 24             	sub    (%esp),%eax
  801dcb:	19 fa                	sbb    %edi,%edx
  801dcd:	89 d1                	mov    %edx,%ecx
  801dcf:	89 c6                	mov    %eax,%esi
  801dd1:	e9 71 ff ff ff       	jmp    801d47 <__umoddi3+0xb3>
  801dd6:	66 90                	xchg   %ax,%ax
  801dd8:	39 44 24 04          	cmp    %eax,0x4(%esp)
  801ddc:	72 ea                	jb     801dc8 <__umoddi3+0x134>
  801dde:	89 d9                	mov    %ebx,%ecx
  801de0:	e9 62 ff ff ff       	jmp    801d47 <__umoddi3+0xb3>
