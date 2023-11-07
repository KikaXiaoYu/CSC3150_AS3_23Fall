
user/_mmaptest:     file format elf64-littleriscv


Disassembly of section .text:

0000000000000000 <err>:
}

char *testname = "???";

void err(char *why)
{
       0:	1101                	addi	sp,sp,-32
       2:	ec06                	sd	ra,24(sp)
       4:	e822                	sd	s0,16(sp)
       6:	e426                	sd	s1,8(sp)
       8:	e04a                	sd	s2,0(sp)
       a:	1000                	addi	s0,sp,32
       c:	84aa                	mv	s1,a0
    printf("mmaptest: %s failed: %s, pid=%d\n", testname, why, getpid());
       e:	00002917          	auipc	s2,0x2
      12:	ff293903          	ld	s2,-14(s2) # 2000 <testname>
      16:	00001097          	auipc	ra,0x1
      1a:	c3a080e7          	jalr	-966(ra) # c50 <getpid>
      1e:	86aa                	mv	a3,a0
      20:	8626                	mv	a2,s1
      22:	85ca                	mv	a1,s2
      24:	00001517          	auipc	a0,0x1
      28:	0dc50513          	addi	a0,a0,220 # 1100 <malloc+0xea>
      2c:	00001097          	auipc	ra,0x1
      30:	f2c080e7          	jalr	-212(ra) # f58 <printf>
    exit(1);
      34:	4505                	li	a0,1
      36:	00001097          	auipc	ra,0x1
      3a:	b9a080e7          	jalr	-1126(ra) # bd0 <exit>

000000000000003e <_v1>:

//
// check the content of the two mapped pages.
//
void _v1(char *p)
{
      3e:	1141                	addi	sp,sp,-16
      40:	e406                	sd	ra,8(sp)
      42:	e022                	sd	s0,0(sp)
      44:	0800                	addi	s0,sp,16
      46:	4781                	li	a5,0
    int i;
    for (i = 0; i < PGSIZE * 2; i++)
    {
        if (i < PGSIZE + (PGSIZE / 2))
      48:	6685                	lui	a3,0x1
      4a:	7ff68693          	addi	a3,a3,2047 # 17ff <digits+0x227>
    for (i = 0; i < PGSIZE * 2; i++)
      4e:	6889                	lui	a7,0x2
        {
            if (p[i] != 'A')
      50:	04100813          	li	a6,65
      54:	a811                	j	68 <_v1+0x2a>
                err("v1 mismatch (1)");
            }
        }
        else
        {
            if (p[i] != 0)
      56:	00f50633          	add	a2,a0,a5
      5a:	00064603          	lbu	a2,0(a2)
      5e:	e221                	bnez	a2,9e <_v1+0x60>
    for (i = 0; i < PGSIZE * 2; i++)
      60:	2705                	addiw	a4,a4,1
      62:	05175e63          	bge	a4,a7,be <_v1+0x80>
      66:	0785                	addi	a5,a5,1
      68:	0007871b          	sext.w	a4,a5
      6c:	85ba                	mv	a1,a4
        if (i < PGSIZE + (PGSIZE / 2))
      6e:	fee6c4e3          	blt	a3,a4,56 <_v1+0x18>
            if (p[i] != 'A')
      72:	00f50733          	add	a4,a0,a5
      76:	00074603          	lbu	a2,0(a4)
      7a:	ff0606e3          	beq	a2,a6,66 <_v1+0x28>
                printf("mismatch at %d, wanted 'A', got 0x%x\n", i, p[i]);
      7e:	00001517          	auipc	a0,0x1
      82:	0aa50513          	addi	a0,a0,170 # 1128 <malloc+0x112>
      86:	00001097          	auipc	ra,0x1
      8a:	ed2080e7          	jalr	-302(ra) # f58 <printf>
                err("v1 mismatch (1)");
      8e:	00001517          	auipc	a0,0x1
      92:	0c250513          	addi	a0,a0,194 # 1150 <malloc+0x13a>
      96:	00000097          	auipc	ra,0x0
      9a:	f6a080e7          	jalr	-150(ra) # 0 <err>
            {
                printf("mismatch at %d, wanted zero, got 0x%x\n", i, p[i]);
      9e:	00001517          	auipc	a0,0x1
      a2:	0c250513          	addi	a0,a0,194 # 1160 <malloc+0x14a>
      a6:	00001097          	auipc	ra,0x1
      aa:	eb2080e7          	jalr	-334(ra) # f58 <printf>
                err("v1 mismatch (2)");
      ae:	00001517          	auipc	a0,0x1
      b2:	0da50513          	addi	a0,a0,218 # 1188 <malloc+0x172>
      b6:	00000097          	auipc	ra,0x0
      ba:	f4a080e7          	jalr	-182(ra) # 0 <err>
            }
        }
    }
}
      be:	60a2                	ld	ra,8(sp)
      c0:	6402                	ld	s0,0(sp)
      c2:	0141                	addi	sp,sp,16
      c4:	8082                	ret

00000000000000c6 <makefile>:
//
// create a file to be mapped, containing
// 1.5 pages of 'A' and half a page of zeros.
//
void makefile(const char *f)
{
      c6:	7179                	addi	sp,sp,-48
      c8:	f406                	sd	ra,40(sp)
      ca:	f022                	sd	s0,32(sp)
      cc:	ec26                	sd	s1,24(sp)
      ce:	e84a                	sd	s2,16(sp)
      d0:	e44e                	sd	s3,8(sp)
      d2:	1800                	addi	s0,sp,48
      d4:	84aa                	mv	s1,a0
    int i;
    int n = PGSIZE / BSIZE;

    unlink(f);
      d6:	00001097          	auipc	ra,0x1
      da:	b4a080e7          	jalr	-1206(ra) # c20 <unlink>
    int fd = open(f, O_WRONLY | O_CREATE);
      de:	20100593          	li	a1,513
      e2:	8526                	mv	a0,s1
      e4:	00001097          	auipc	ra,0x1
      e8:	b2c080e7          	jalr	-1236(ra) # c10 <open>
    if (fd == -1)
      ec:	57fd                	li	a5,-1
      ee:	06f50163          	beq	a0,a5,150 <makefile+0x8a>
      f2:	892a                	mv	s2,a0
        err("open");
    memset(buf, 'A', BSIZE);
      f4:	40000613          	li	a2,1024
      f8:	04100593          	li	a1,65
      fc:	00002517          	auipc	a0,0x2
     100:	f2450513          	addi	a0,a0,-220 # 2020 <buf>
     104:	00001097          	auipc	ra,0x1
     108:	8c8080e7          	jalr	-1848(ra) # 9cc <memset>
     10c:	4499                	li	s1,6
    // write 1.5 page
    for (i = 0; i < n + n / 2; i++)
    {
        if (write(fd, buf, BSIZE) != BSIZE)
     10e:	00002997          	auipc	s3,0x2
     112:	f1298993          	addi	s3,s3,-238 # 2020 <buf>
     116:	40000613          	li	a2,1024
     11a:	85ce                	mv	a1,s3
     11c:	854a                	mv	a0,s2
     11e:	00001097          	auipc	ra,0x1
     122:	ad2080e7          	jalr	-1326(ra) # bf0 <write>
     126:	40000793          	li	a5,1024
     12a:	02f51b63          	bne	a0,a5,160 <makefile+0x9a>
    for (i = 0; i < n + n / 2; i++)
     12e:	34fd                	addiw	s1,s1,-1
     130:	f0fd                	bnez	s1,116 <makefile+0x50>
            err("write 0 makefile");
    }
    if (close(fd) == -1)
     132:	854a                	mv	a0,s2
     134:	00001097          	auipc	ra,0x1
     138:	ac4080e7          	jalr	-1340(ra) # bf8 <close>
     13c:	57fd                	li	a5,-1
     13e:	02f50963          	beq	a0,a5,170 <makefile+0xaa>
        err("close");
}
     142:	70a2                	ld	ra,40(sp)
     144:	7402                	ld	s0,32(sp)
     146:	64e2                	ld	s1,24(sp)
     148:	6942                	ld	s2,16(sp)
     14a:	69a2                	ld	s3,8(sp)
     14c:	6145                	addi	sp,sp,48
     14e:	8082                	ret
        err("open");
     150:	00001517          	auipc	a0,0x1
     154:	04850513          	addi	a0,a0,72 # 1198 <malloc+0x182>
     158:	00000097          	auipc	ra,0x0
     15c:	ea8080e7          	jalr	-344(ra) # 0 <err>
            err("write 0 makefile");
     160:	00001517          	auipc	a0,0x1
     164:	04050513          	addi	a0,a0,64 # 11a0 <malloc+0x18a>
     168:	00000097          	auipc	ra,0x0
     16c:	e98080e7          	jalr	-360(ra) # 0 <err>
        err("close");
     170:	00001517          	auipc	a0,0x1
     174:	04850513          	addi	a0,a0,72 # 11b8 <malloc+0x1a2>
     178:	00000097          	auipc	ra,0x0
     17c:	e88080e7          	jalr	-376(ra) # 0 <err>

0000000000000180 <mmap_test>:

void mmap_test(void)
{
     180:	7139                	addi	sp,sp,-64
     182:	fc06                	sd	ra,56(sp)
     184:	f822                	sd	s0,48(sp)
     186:	f426                	sd	s1,40(sp)
     188:	f04a                	sd	s2,32(sp)
     18a:	ec4e                	sd	s3,24(sp)
     18c:	e852                	sd	s4,16(sp)
     18e:	0080                	addi	s0,sp,64
    int fd;
    int i;
    const char *const f = "mmap.dur";
    printf("mmap_test starting\n");
     190:	00001517          	auipc	a0,0x1
     194:	03050513          	addi	a0,a0,48 # 11c0 <malloc+0x1aa>
     198:	00001097          	auipc	ra,0x1
     19c:	dc0080e7          	jalr	-576(ra) # f58 <printf>
    testname = "mmap_test";
     1a0:	00001797          	auipc	a5,0x1
     1a4:	03878793          	addi	a5,a5,56 # 11d8 <malloc+0x1c2>
     1a8:	00002717          	auipc	a4,0x2
     1ac:	e4f73c23          	sd	a5,-424(a4) # 2000 <testname>
    //
    // create a file with known content, map it into memory, check that
    // the mapped memory has the same bytes as originally written to the
    // file.
    //
    makefile(f);
     1b0:	00001517          	auipc	a0,0x1
     1b4:	03850513          	addi	a0,a0,56 # 11e8 <malloc+0x1d2>
     1b8:	00000097          	auipc	ra,0x0
     1bc:	f0e080e7          	jalr	-242(ra) # c6 <makefile>
    if ((fd = open(f, O_RDONLY)) == -1)
     1c0:	4581                	li	a1,0
     1c2:	00001517          	auipc	a0,0x1
     1c6:	02650513          	addi	a0,a0,38 # 11e8 <malloc+0x1d2>
     1ca:	00001097          	auipc	ra,0x1
     1ce:	a46080e7          	jalr	-1466(ra) # c10 <open>
     1d2:	57fd                	li	a5,-1
     1d4:	3ef50e63          	beq	a0,a5,5d0 <mmap_test+0x450>
     1d8:	892a                	mv	s2,a0
        err("open");

    printf("test mmap f\n");
     1da:	00001517          	auipc	a0,0x1
     1de:	01e50513          	addi	a0,a0,30 # 11f8 <malloc+0x1e2>
     1e2:	00001097          	auipc	ra,0x1
     1e6:	d76080e7          	jalr	-650(ra) # f58 <printf>
    // same file (of course in this case updates are prohibited
    // due to PROT_READ). the fifth argument is the file descriptor
    // of the file to be mapped. the last argument is the starting
    // offset in the file.
    //
    char *p = mmap(0, PGSIZE * 2, PROT_READ, MAP_PRIVATE, fd, 0);
     1ea:	4781                	li	a5,0
     1ec:	874a                	mv	a4,s2
     1ee:	4689                	li	a3,2
     1f0:	4605                	li	a2,1
     1f2:	6589                	lui	a1,0x2
     1f4:	4501                	li	a0,0
     1f6:	00001097          	auipc	ra,0x1
     1fa:	a7a080e7          	jalr	-1414(ra) # c70 <mmap>
     1fe:	84aa                	mv	s1,a0
    if (p == MAP_FAILED)
     200:	57fd                	li	a5,-1
     202:	3cf50f63          	beq	a0,a5,5e0 <mmap_test+0x460>
        err("mmap (1)");
    _v1(p);
     206:	00000097          	auipc	ra,0x0
     20a:	e38080e7          	jalr	-456(ra) # 3e <_v1>
    printf("[Testing] : mmap! good \n");
     20e:	00001517          	auipc	a0,0x1
     212:	00a50513          	addi	a0,a0,10 # 1218 <malloc+0x202>
     216:	00001097          	auipc	ra,0x1
     21a:	d42080e7          	jalr	-702(ra) # f58 <printf>
    if (munmap(p, PGSIZE * 2) == -1)
     21e:	6589                	lui	a1,0x2
     220:	8526                	mv	a0,s1
     222:	00001097          	auipc	ra,0x1
     226:	a56080e7          	jalr	-1450(ra) # c78 <munmap>
     22a:	57fd                	li	a5,-1
     22c:	3cf50263          	beq	a0,a5,5f0 <mmap_test+0x470>
        err("munmap (1)");

    printf("test mmap f: OK\n");
     230:	00001517          	auipc	a0,0x1
     234:	01850513          	addi	a0,a0,24 # 1248 <malloc+0x232>
     238:	00001097          	auipc	ra,0x1
     23c:	d20080e7          	jalr	-736(ra) # f58 <printf>

    printf("test mmap private\n");
     240:	00001517          	auipc	a0,0x1
     244:	02050513          	addi	a0,a0,32 # 1260 <malloc+0x24a>
     248:	00001097          	auipc	ra,0x1
     24c:	d10080e7          	jalr	-752(ra) # f58 <printf>
    // should be able to map file opened read-only with private writable
    // mapping
    p = mmap(0, PGSIZE * 2, PROT_READ | PROT_WRITE, MAP_PRIVATE, fd, 0);
     250:	4781                	li	a5,0
     252:	874a                	mv	a4,s2
     254:	4689                	li	a3,2
     256:	460d                	li	a2,3
     258:	6589                	lui	a1,0x2
     25a:	4501                	li	a0,0
     25c:	00001097          	auipc	ra,0x1
     260:	a14080e7          	jalr	-1516(ra) # c70 <mmap>
     264:	84aa                	mv	s1,a0
    if (p == MAP_FAILED)
     266:	57fd                	li	a5,-1
     268:	38f50c63          	beq	a0,a5,600 <mmap_test+0x480>
        err("mmap (2)");
    if (close(fd) == -1)
     26c:	854a                	mv	a0,s2
     26e:	00001097          	auipc	ra,0x1
     272:	98a080e7          	jalr	-1654(ra) # bf8 <close>
     276:	57fd                	li	a5,-1
     278:	38f50c63          	beq	a0,a5,610 <mmap_test+0x490>
        err("close");
    _v1(p);
     27c:	8526                	mv	a0,s1
     27e:	00000097          	auipc	ra,0x0
     282:	dc0080e7          	jalr	-576(ra) # 3e <_v1>
    for (i = 0; i < PGSIZE * 2; i++)
     286:	87a6                	mv	a5,s1
     288:	6709                	lui	a4,0x2
     28a:	9726                	add	a4,a4,s1
        p[i] = 'Z';
     28c:	05a00693          	li	a3,90
     290:	00d78023          	sb	a3,0(a5)
    for (i = 0; i < PGSIZE * 2; i++)
     294:	0785                	addi	a5,a5,1
     296:	fef71de3          	bne	a4,a5,290 <mmap_test+0x110>
    if (munmap(p, PGSIZE * 2) == -1)
     29a:	6589                	lui	a1,0x2
     29c:	8526                	mv	a0,s1
     29e:	00001097          	auipc	ra,0x1
     2a2:	9da080e7          	jalr	-1574(ra) # c78 <munmap>
     2a6:	57fd                	li	a5,-1
     2a8:	36f50c63          	beq	a0,a5,620 <mmap_test+0x4a0>
        err("munmap (2)");

    printf("test mmap private: OK\n");
     2ac:	00001517          	auipc	a0,0x1
     2b0:	fec50513          	addi	a0,a0,-20 # 1298 <malloc+0x282>
     2b4:	00001097          	auipc	ra,0x1
     2b8:	ca4080e7          	jalr	-860(ra) # f58 <printf>

    printf("test mmap read-only\n");
     2bc:	00001517          	auipc	a0,0x1
     2c0:	ff450513          	addi	a0,a0,-12 # 12b0 <malloc+0x29a>
     2c4:	00001097          	auipc	ra,0x1
     2c8:	c94080e7          	jalr	-876(ra) # f58 <printf>

    // check that mmap doesn't allow read/write mapping of a
    // file opened read-only.
    if ((fd = open(f, O_RDONLY)) == -1)
     2cc:	4581                	li	a1,0
     2ce:	00001517          	auipc	a0,0x1
     2d2:	f1a50513          	addi	a0,a0,-230 # 11e8 <malloc+0x1d2>
     2d6:	00001097          	auipc	ra,0x1
     2da:	93a080e7          	jalr	-1734(ra) # c10 <open>
     2de:	84aa                	mv	s1,a0
     2e0:	57fd                	li	a5,-1
     2e2:	34f50763          	beq	a0,a5,630 <mmap_test+0x4b0>
        err("open");
    p = mmap(0, PGSIZE * 3, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
     2e6:	4781                	li	a5,0
     2e8:	872a                	mv	a4,a0
     2ea:	4685                	li	a3,1
     2ec:	460d                	li	a2,3
     2ee:	658d                	lui	a1,0x3
     2f0:	4501                	li	a0,0
     2f2:	00001097          	auipc	ra,0x1
     2f6:	97e080e7          	jalr	-1666(ra) # c70 <mmap>
    if (p != MAP_FAILED)
     2fa:	57fd                	li	a5,-1
     2fc:	34f51263          	bne	a0,a5,640 <mmap_test+0x4c0>
        err("mmap call should have failed");
    if (close(fd) == -1)
     300:	8526                	mv	a0,s1
     302:	00001097          	auipc	ra,0x1
     306:	8f6080e7          	jalr	-1802(ra) # bf8 <close>
     30a:	57fd                	li	a5,-1
     30c:	34f50263          	beq	a0,a5,650 <mmap_test+0x4d0>
        err("close");

    printf("test mmap read-only: OK\n");
     310:	00001517          	auipc	a0,0x1
     314:	fd850513          	addi	a0,a0,-40 # 12e8 <malloc+0x2d2>
     318:	00001097          	auipc	ra,0x1
     31c:	c40080e7          	jalr	-960(ra) # f58 <printf>

    printf("test mmap read/write\n");
     320:	00001517          	auipc	a0,0x1
     324:	fe850513          	addi	a0,a0,-24 # 1308 <malloc+0x2f2>
     328:	00001097          	auipc	ra,0x1
     32c:	c30080e7          	jalr	-976(ra) # f58 <printf>

    // check that mmap does allow read/write mapping of a
    // file opened read/write.
    if ((fd = open(f, O_RDWR)) == -1)
     330:	4589                	li	a1,2
     332:	00001517          	auipc	a0,0x1
     336:	eb650513          	addi	a0,a0,-330 # 11e8 <malloc+0x1d2>
     33a:	00001097          	auipc	ra,0x1
     33e:	8d6080e7          	jalr	-1834(ra) # c10 <open>
     342:	84aa                	mv	s1,a0
     344:	57fd                	li	a5,-1
     346:	30f50d63          	beq	a0,a5,660 <mmap_test+0x4e0>
        err("open");
    p = mmap(0, PGSIZE * 3, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
     34a:	4781                	li	a5,0
     34c:	872a                	mv	a4,a0
     34e:	4685                	li	a3,1
     350:	460d                	li	a2,3
     352:	658d                	lui	a1,0x3
     354:	4501                	li	a0,0
     356:	00001097          	auipc	ra,0x1
     35a:	91a080e7          	jalr	-1766(ra) # c70 <mmap>
     35e:	89aa                	mv	s3,a0
    if (p == MAP_FAILED)
     360:	57fd                	li	a5,-1
     362:	30f50763          	beq	a0,a5,670 <mmap_test+0x4f0>
        err("mmap (3)");
    if (close(fd) == -1)
     366:	8526                	mv	a0,s1
     368:	00001097          	auipc	ra,0x1
     36c:	890080e7          	jalr	-1904(ra) # bf8 <close>
     370:	57fd                	li	a5,-1
     372:	30f50763          	beq	a0,a5,680 <mmap_test+0x500>
        err("close");

    // check that the mapping still works after close(fd).
    _v1(p);
     376:	854e                	mv	a0,s3
     378:	00000097          	auipc	ra,0x0
     37c:	cc6080e7          	jalr	-826(ra) # 3e <_v1>

    // write the mapped memory.
    for (i = 0; i < PGSIZE * 2; i++)
     380:	87ce                	mv	a5,s3
     382:	6709                	lui	a4,0x2
     384:	974e                	add	a4,a4,s3
        p[i] = 'Z';
     386:	05a00693          	li	a3,90
     38a:	00d78023          	sb	a3,0(a5)
    for (i = 0; i < PGSIZE * 2; i++)
     38e:	0785                	addi	a5,a5,1
     390:	fee79de3          	bne	a5,a4,38a <mmap_test+0x20a>

    // unmap just the first two of three pages of mapped memory.
    if (munmap(p, PGSIZE * 2) == -1)
     394:	6589                	lui	a1,0x2
     396:	854e                	mv	a0,s3
     398:	00001097          	auipc	ra,0x1
     39c:	8e0080e7          	jalr	-1824(ra) # c78 <munmap>
     3a0:	57fd                	li	a5,-1
     3a2:	2ef50763          	beq	a0,a5,690 <mmap_test+0x510>
        err("munmap (3)");

    printf("test mmap read/write: OK\n");
     3a6:	00001517          	auipc	a0,0x1
     3aa:	f9a50513          	addi	a0,a0,-102 # 1340 <malloc+0x32a>
     3ae:	00001097          	auipc	ra,0x1
     3b2:	baa080e7          	jalr	-1110(ra) # f58 <printf>

    printf("test mmap dirty\n");
     3b6:	00001517          	auipc	a0,0x1
     3ba:	faa50513          	addi	a0,a0,-86 # 1360 <malloc+0x34a>
     3be:	00001097          	auipc	ra,0x1
     3c2:	b9a080e7          	jalr	-1126(ra) # f58 <printf>

    // check that the writes to the mapped memory were
    // written to the file.
    if ((fd = open(f, O_RDWR)) == -1)
     3c6:	4589                	li	a1,2
     3c8:	00001517          	auipc	a0,0x1
     3cc:	e2050513          	addi	a0,a0,-480 # 11e8 <malloc+0x1d2>
     3d0:	00001097          	auipc	ra,0x1
     3d4:	840080e7          	jalr	-1984(ra) # c10 <open>
     3d8:	892a                	mv	s2,a0
     3da:	57fd                	li	a5,-1
     3dc:	6489                	lui	s1,0x2
     3de:	80048493          	addi	s1,s1,-2048 # 1800 <digits+0x228>
    for (i = 0; i < PGSIZE + (PGSIZE / 2); i++)
    {
        char b;
        if (read(fd, &b, 1) != 1)
            err("read (1)");
        if (b != 'Z')
     3e2:	05a00a13          	li	s4,90
    if ((fd = open(f, O_RDWR)) == -1)
     3e6:	2af50d63          	beq	a0,a5,6a0 <mmap_test+0x520>
        if (read(fd, &b, 1) != 1)
     3ea:	4605                	li	a2,1
     3ec:	fcf40593          	addi	a1,s0,-49
     3f0:	854a                	mv	a0,s2
     3f2:	00000097          	auipc	ra,0x0
     3f6:	7f6080e7          	jalr	2038(ra) # be8 <read>
     3fa:	4785                	li	a5,1
     3fc:	2af51a63          	bne	a0,a5,6b0 <mmap_test+0x530>
        if (b != 'Z')
     400:	fcf44783          	lbu	a5,-49(s0)
     404:	2b479e63          	bne	a5,s4,6c0 <mmap_test+0x540>
    for (i = 0; i < PGSIZE + (PGSIZE / 2); i++)
     408:	34fd                	addiw	s1,s1,-1
     40a:	f0e5                	bnez	s1,3ea <mmap_test+0x26a>
            err("file does not contain modifications");
    }
    if (close(fd) == -1)
     40c:	854a                	mv	a0,s2
     40e:	00000097          	auipc	ra,0x0
     412:	7ea080e7          	jalr	2026(ra) # bf8 <close>
     416:	57fd                	li	a5,-1
     418:	2af50c63          	beq	a0,a5,6d0 <mmap_test+0x550>
        err("close");

    printf("test mmap dirty: OK\n");
     41c:	00001517          	auipc	a0,0x1
     420:	f9450513          	addi	a0,a0,-108 # 13b0 <malloc+0x39a>
     424:	00001097          	auipc	ra,0x1
     428:	b34080e7          	jalr	-1228(ra) # f58 <printf>

    printf("test not-mapped unmap\n");
     42c:	00001517          	auipc	a0,0x1
     430:	f9c50513          	addi	a0,a0,-100 # 13c8 <malloc+0x3b2>
     434:	00001097          	auipc	ra,0x1
     438:	b24080e7          	jalr	-1244(ra) # f58 <printf>

    // unmap the rest of the mapped memory.
    if (munmap(p + PGSIZE * 2, PGSIZE) == -1)
     43c:	6585                	lui	a1,0x1
     43e:	6509                	lui	a0,0x2
     440:	954e                	add	a0,a0,s3
     442:	00001097          	auipc	ra,0x1
     446:	836080e7          	jalr	-1994(ra) # c78 <munmap>
     44a:	57fd                	li	a5,-1
     44c:	28f50a63          	beq	a0,a5,6e0 <mmap_test+0x560>
        err("munmap (4)");

    printf("test not-mapped unmap: OK\n");
     450:	00001517          	auipc	a0,0x1
     454:	fa050513          	addi	a0,a0,-96 # 13f0 <malloc+0x3da>
     458:	00001097          	auipc	ra,0x1
     45c:	b00080e7          	jalr	-1280(ra) # f58 <printf>

    printf("test mmap two files\n");
     460:	00001517          	auipc	a0,0x1
     464:	fb050513          	addi	a0,a0,-80 # 1410 <malloc+0x3fa>
     468:	00001097          	auipc	ra,0x1
     46c:	af0080e7          	jalr	-1296(ra) # f58 <printf>

    //
    // mmap two files at the same time.
    //
    int fd1;
    if ((fd1 = open("mmap1", O_RDWR | O_CREATE)) < 0)
     470:	20200593          	li	a1,514
     474:	00001517          	auipc	a0,0x1
     478:	fb450513          	addi	a0,a0,-76 # 1428 <malloc+0x412>
     47c:	00000097          	auipc	ra,0x0
     480:	794080e7          	jalr	1940(ra) # c10 <open>
     484:	84aa                	mv	s1,a0
     486:	26054563          	bltz	a0,6f0 <mmap_test+0x570>
        err("open mmap1");
    if (write(fd1, "12345", 5) != 5)
     48a:	4615                	li	a2,5
     48c:	00001597          	auipc	a1,0x1
     490:	fb458593          	addi	a1,a1,-76 # 1440 <malloc+0x42a>
     494:	00000097          	auipc	ra,0x0
     498:	75c080e7          	jalr	1884(ra) # bf0 <write>
     49c:	4795                	li	a5,5
     49e:	26f51163          	bne	a0,a5,700 <mmap_test+0x580>
        err("write mmap1");
    char *p1 = mmap(0, PGSIZE, PROT_READ, MAP_PRIVATE, fd1, 0);
     4a2:	4781                	li	a5,0
     4a4:	8726                	mv	a4,s1
     4a6:	4689                	li	a3,2
     4a8:	4605                	li	a2,1
     4aa:	6585                	lui	a1,0x1
     4ac:	4501                	li	a0,0
     4ae:	00000097          	auipc	ra,0x0
     4b2:	7c2080e7          	jalr	1986(ra) # c70 <mmap>
     4b6:	89aa                	mv	s3,a0
    if (p1 == MAP_FAILED)
     4b8:	57fd                	li	a5,-1
     4ba:	24f50b63          	beq	a0,a5,710 <mmap_test+0x590>
        err("mmap mmap1");
    close(fd1);
     4be:	8526                	mv	a0,s1
     4c0:	00000097          	auipc	ra,0x0
     4c4:	738080e7          	jalr	1848(ra) # bf8 <close>
    unlink("mmap1");
     4c8:	00001517          	auipc	a0,0x1
     4cc:	f6050513          	addi	a0,a0,-160 # 1428 <malloc+0x412>
     4d0:	00000097          	auipc	ra,0x0
     4d4:	750080e7          	jalr	1872(ra) # c20 <unlink>

    int fd2;
    if ((fd2 = open("mmap2", O_RDWR | O_CREATE)) < 0)
     4d8:	20200593          	li	a1,514
     4dc:	00001517          	auipc	a0,0x1
     4e0:	f8c50513          	addi	a0,a0,-116 # 1468 <malloc+0x452>
     4e4:	00000097          	auipc	ra,0x0
     4e8:	72c080e7          	jalr	1836(ra) # c10 <open>
     4ec:	892a                	mv	s2,a0
     4ee:	22054963          	bltz	a0,720 <mmap_test+0x5a0>
        err("open mmap2");
    if (write(fd2, "67890", 5) != 5)
     4f2:	4615                	li	a2,5
     4f4:	00001597          	auipc	a1,0x1
     4f8:	f8c58593          	addi	a1,a1,-116 # 1480 <malloc+0x46a>
     4fc:	00000097          	auipc	ra,0x0
     500:	6f4080e7          	jalr	1780(ra) # bf0 <write>
     504:	4795                	li	a5,5
     506:	22f51563          	bne	a0,a5,730 <mmap_test+0x5b0>
        err("write mmap2");
    char *p2 = mmap(0, PGSIZE, PROT_READ, MAP_PRIVATE, fd2, 0);
     50a:	4781                	li	a5,0
     50c:	874a                	mv	a4,s2
     50e:	4689                	li	a3,2
     510:	4605                	li	a2,1
     512:	6585                	lui	a1,0x1
     514:	4501                	li	a0,0
     516:	00000097          	auipc	ra,0x0
     51a:	75a080e7          	jalr	1882(ra) # c70 <mmap>
     51e:	84aa                	mv	s1,a0
    if (p2 == MAP_FAILED)
     520:	57fd                	li	a5,-1
     522:	20f50f63          	beq	a0,a5,740 <mmap_test+0x5c0>
        err("mmap mmap2");
    close(fd2);
     526:	854a                	mv	a0,s2
     528:	00000097          	auipc	ra,0x0
     52c:	6d0080e7          	jalr	1744(ra) # bf8 <close>
    unlink("mmap2");
     530:	00001517          	auipc	a0,0x1
     534:	f3850513          	addi	a0,a0,-200 # 1468 <malloc+0x452>
     538:	00000097          	auipc	ra,0x0
     53c:	6e8080e7          	jalr	1768(ra) # c20 <unlink>

    if (memcmp(p1, "12345", 5) != 0)
     540:	4615                	li	a2,5
     542:	00001597          	auipc	a1,0x1
     546:	efe58593          	addi	a1,a1,-258 # 1440 <malloc+0x42a>
     54a:	854e                	mv	a0,s3
     54c:	00000097          	auipc	ra,0x0
     550:	62a080e7          	jalr	1578(ra) # b76 <memcmp>
     554:	1e051e63          	bnez	a0,750 <mmap_test+0x5d0>
        err("mmap1 mismatch");
    if (memcmp(p2, "67890", 5) != 0)
     558:	4615                	li	a2,5
     55a:	00001597          	auipc	a1,0x1
     55e:	f2658593          	addi	a1,a1,-218 # 1480 <malloc+0x46a>
     562:	8526                	mv	a0,s1
     564:	00000097          	auipc	ra,0x0
     568:	612080e7          	jalr	1554(ra) # b76 <memcmp>
     56c:	1e051a63          	bnez	a0,760 <mmap_test+0x5e0>
        err("mmap2 mismatch");

    munmap(p1, PGSIZE);
     570:	6585                	lui	a1,0x1
     572:	854e                	mv	a0,s3
     574:	00000097          	auipc	ra,0x0
     578:	704080e7          	jalr	1796(ra) # c78 <munmap>
    if (memcmp(p2, "67890", 5) != 0)
     57c:	4615                	li	a2,5
     57e:	00001597          	auipc	a1,0x1
     582:	f0258593          	addi	a1,a1,-254 # 1480 <malloc+0x46a>
     586:	8526                	mv	a0,s1
     588:	00000097          	auipc	ra,0x0
     58c:	5ee080e7          	jalr	1518(ra) # b76 <memcmp>
     590:	1e051063          	bnez	a0,770 <mmap_test+0x5f0>
        err("mmap2 mismatch (2)");
    munmap(p2, PGSIZE);
     594:	6585                	lui	a1,0x1
     596:	8526                	mv	a0,s1
     598:	00000097          	auipc	ra,0x0
     59c:	6e0080e7          	jalr	1760(ra) # c78 <munmap>

    printf("test mmap two files: OK\n");
     5a0:	00001517          	auipc	a0,0x1
     5a4:	f4050513          	addi	a0,a0,-192 # 14e0 <malloc+0x4ca>
     5a8:	00001097          	auipc	ra,0x1
     5ac:	9b0080e7          	jalr	-1616(ra) # f58 <printf>

    printf("mmap_test: ALL OK\n");
     5b0:	00001517          	auipc	a0,0x1
     5b4:	f5050513          	addi	a0,a0,-176 # 1500 <malloc+0x4ea>
     5b8:	00001097          	auipc	ra,0x1
     5bc:	9a0080e7          	jalr	-1632(ra) # f58 <printf>
}
     5c0:	70e2                	ld	ra,56(sp)
     5c2:	7442                	ld	s0,48(sp)
     5c4:	74a2                	ld	s1,40(sp)
     5c6:	7902                	ld	s2,32(sp)
     5c8:	69e2                	ld	s3,24(sp)
     5ca:	6a42                	ld	s4,16(sp)
     5cc:	6121                	addi	sp,sp,64
     5ce:	8082                	ret
        err("open");
     5d0:	00001517          	auipc	a0,0x1
     5d4:	bc850513          	addi	a0,a0,-1080 # 1198 <malloc+0x182>
     5d8:	00000097          	auipc	ra,0x0
     5dc:	a28080e7          	jalr	-1496(ra) # 0 <err>
        err("mmap (1)");
     5e0:	00001517          	auipc	a0,0x1
     5e4:	c2850513          	addi	a0,a0,-984 # 1208 <malloc+0x1f2>
     5e8:	00000097          	auipc	ra,0x0
     5ec:	a18080e7          	jalr	-1512(ra) # 0 <err>
        err("munmap (1)");
     5f0:	00001517          	auipc	a0,0x1
     5f4:	c4850513          	addi	a0,a0,-952 # 1238 <malloc+0x222>
     5f8:	00000097          	auipc	ra,0x0
     5fc:	a08080e7          	jalr	-1528(ra) # 0 <err>
        err("mmap (2)");
     600:	00001517          	auipc	a0,0x1
     604:	c7850513          	addi	a0,a0,-904 # 1278 <malloc+0x262>
     608:	00000097          	auipc	ra,0x0
     60c:	9f8080e7          	jalr	-1544(ra) # 0 <err>
        err("close");
     610:	00001517          	auipc	a0,0x1
     614:	ba850513          	addi	a0,a0,-1112 # 11b8 <malloc+0x1a2>
     618:	00000097          	auipc	ra,0x0
     61c:	9e8080e7          	jalr	-1560(ra) # 0 <err>
        err("munmap (2)");
     620:	00001517          	auipc	a0,0x1
     624:	c6850513          	addi	a0,a0,-920 # 1288 <malloc+0x272>
     628:	00000097          	auipc	ra,0x0
     62c:	9d8080e7          	jalr	-1576(ra) # 0 <err>
        err("open");
     630:	00001517          	auipc	a0,0x1
     634:	b6850513          	addi	a0,a0,-1176 # 1198 <malloc+0x182>
     638:	00000097          	auipc	ra,0x0
     63c:	9c8080e7          	jalr	-1592(ra) # 0 <err>
        err("mmap call should have failed");
     640:	00001517          	auipc	a0,0x1
     644:	c8850513          	addi	a0,a0,-888 # 12c8 <malloc+0x2b2>
     648:	00000097          	auipc	ra,0x0
     64c:	9b8080e7          	jalr	-1608(ra) # 0 <err>
        err("close");
     650:	00001517          	auipc	a0,0x1
     654:	b6850513          	addi	a0,a0,-1176 # 11b8 <malloc+0x1a2>
     658:	00000097          	auipc	ra,0x0
     65c:	9a8080e7          	jalr	-1624(ra) # 0 <err>
        err("open");
     660:	00001517          	auipc	a0,0x1
     664:	b3850513          	addi	a0,a0,-1224 # 1198 <malloc+0x182>
     668:	00000097          	auipc	ra,0x0
     66c:	998080e7          	jalr	-1640(ra) # 0 <err>
        err("mmap (3)");
     670:	00001517          	auipc	a0,0x1
     674:	cb050513          	addi	a0,a0,-848 # 1320 <malloc+0x30a>
     678:	00000097          	auipc	ra,0x0
     67c:	988080e7          	jalr	-1656(ra) # 0 <err>
        err("close");
     680:	00001517          	auipc	a0,0x1
     684:	b3850513          	addi	a0,a0,-1224 # 11b8 <malloc+0x1a2>
     688:	00000097          	auipc	ra,0x0
     68c:	978080e7          	jalr	-1672(ra) # 0 <err>
        err("munmap (3)");
     690:	00001517          	auipc	a0,0x1
     694:	ca050513          	addi	a0,a0,-864 # 1330 <malloc+0x31a>
     698:	00000097          	auipc	ra,0x0
     69c:	968080e7          	jalr	-1688(ra) # 0 <err>
        err("open");
     6a0:	00001517          	auipc	a0,0x1
     6a4:	af850513          	addi	a0,a0,-1288 # 1198 <malloc+0x182>
     6a8:	00000097          	auipc	ra,0x0
     6ac:	958080e7          	jalr	-1704(ra) # 0 <err>
            err("read (1)");
     6b0:	00001517          	auipc	a0,0x1
     6b4:	cc850513          	addi	a0,a0,-824 # 1378 <malloc+0x362>
     6b8:	00000097          	auipc	ra,0x0
     6bc:	948080e7          	jalr	-1720(ra) # 0 <err>
            err("file does not contain modifications");
     6c0:	00001517          	auipc	a0,0x1
     6c4:	cc850513          	addi	a0,a0,-824 # 1388 <malloc+0x372>
     6c8:	00000097          	auipc	ra,0x0
     6cc:	938080e7          	jalr	-1736(ra) # 0 <err>
        err("close");
     6d0:	00001517          	auipc	a0,0x1
     6d4:	ae850513          	addi	a0,a0,-1304 # 11b8 <malloc+0x1a2>
     6d8:	00000097          	auipc	ra,0x0
     6dc:	928080e7          	jalr	-1752(ra) # 0 <err>
        err("munmap (4)");
     6e0:	00001517          	auipc	a0,0x1
     6e4:	d0050513          	addi	a0,a0,-768 # 13e0 <malloc+0x3ca>
     6e8:	00000097          	auipc	ra,0x0
     6ec:	918080e7          	jalr	-1768(ra) # 0 <err>
        err("open mmap1");
     6f0:	00001517          	auipc	a0,0x1
     6f4:	d4050513          	addi	a0,a0,-704 # 1430 <malloc+0x41a>
     6f8:	00000097          	auipc	ra,0x0
     6fc:	908080e7          	jalr	-1784(ra) # 0 <err>
        err("write mmap1");
     700:	00001517          	auipc	a0,0x1
     704:	d4850513          	addi	a0,a0,-696 # 1448 <malloc+0x432>
     708:	00000097          	auipc	ra,0x0
     70c:	8f8080e7          	jalr	-1800(ra) # 0 <err>
        err("mmap mmap1");
     710:	00001517          	auipc	a0,0x1
     714:	d4850513          	addi	a0,a0,-696 # 1458 <malloc+0x442>
     718:	00000097          	auipc	ra,0x0
     71c:	8e8080e7          	jalr	-1816(ra) # 0 <err>
        err("open mmap2");
     720:	00001517          	auipc	a0,0x1
     724:	d5050513          	addi	a0,a0,-688 # 1470 <malloc+0x45a>
     728:	00000097          	auipc	ra,0x0
     72c:	8d8080e7          	jalr	-1832(ra) # 0 <err>
        err("write mmap2");
     730:	00001517          	auipc	a0,0x1
     734:	d5850513          	addi	a0,a0,-680 # 1488 <malloc+0x472>
     738:	00000097          	auipc	ra,0x0
     73c:	8c8080e7          	jalr	-1848(ra) # 0 <err>
        err("mmap mmap2");
     740:	00001517          	auipc	a0,0x1
     744:	d5850513          	addi	a0,a0,-680 # 1498 <malloc+0x482>
     748:	00000097          	auipc	ra,0x0
     74c:	8b8080e7          	jalr	-1864(ra) # 0 <err>
        err("mmap1 mismatch");
     750:	00001517          	auipc	a0,0x1
     754:	d5850513          	addi	a0,a0,-680 # 14a8 <malloc+0x492>
     758:	00000097          	auipc	ra,0x0
     75c:	8a8080e7          	jalr	-1880(ra) # 0 <err>
        err("mmap2 mismatch");
     760:	00001517          	auipc	a0,0x1
     764:	d5850513          	addi	a0,a0,-680 # 14b8 <malloc+0x4a2>
     768:	00000097          	auipc	ra,0x0
     76c:	898080e7          	jalr	-1896(ra) # 0 <err>
        err("mmap2 mismatch (2)");
     770:	00001517          	auipc	a0,0x1
     774:	d5850513          	addi	a0,a0,-680 # 14c8 <malloc+0x4b2>
     778:	00000097          	auipc	ra,0x0
     77c:	888080e7          	jalr	-1912(ra) # 0 <err>

0000000000000780 <fork_test>:
//
// mmap a file, then fork.
// check that the child sees the mapped file.
//
void fork_test(void)
{
     780:	7179                	addi	sp,sp,-48
     782:	f406                	sd	ra,40(sp)
     784:	f022                	sd	s0,32(sp)
     786:	ec26                	sd	s1,24(sp)
     788:	e84a                	sd	s2,16(sp)
     78a:	1800                	addi	s0,sp,48
    int fd;
    int pid;
    const char *const f = "mmap.dur";

    printf("fork_test starting\n");
     78c:	00001517          	auipc	a0,0x1
     790:	d8c50513          	addi	a0,a0,-628 # 1518 <malloc+0x502>
     794:	00000097          	auipc	ra,0x0
     798:	7c4080e7          	jalr	1988(ra) # f58 <printf>
    testname = "fork_test";
     79c:	00001797          	auipc	a5,0x1
     7a0:	d9478793          	addi	a5,a5,-620 # 1530 <malloc+0x51a>
     7a4:	00002717          	auipc	a4,0x2
     7a8:	84f73e23          	sd	a5,-1956(a4) # 2000 <testname>

    // mmap the file twice.
    makefile(f);
     7ac:	00001517          	auipc	a0,0x1
     7b0:	a3c50513          	addi	a0,a0,-1476 # 11e8 <malloc+0x1d2>
     7b4:	00000097          	auipc	ra,0x0
     7b8:	912080e7          	jalr	-1774(ra) # c6 <makefile>
    if ((fd = open(f, O_RDONLY)) == -1)
     7bc:	4581                	li	a1,0
     7be:	00001517          	auipc	a0,0x1
     7c2:	a2a50513          	addi	a0,a0,-1494 # 11e8 <malloc+0x1d2>
     7c6:	00000097          	auipc	ra,0x0
     7ca:	44a080e7          	jalr	1098(ra) # c10 <open>
     7ce:	57fd                	li	a5,-1
     7d0:	0af50a63          	beq	a0,a5,884 <fork_test+0x104>
     7d4:	84aa                	mv	s1,a0
        err("open");
    unlink(f);
     7d6:	00001517          	auipc	a0,0x1
     7da:	a1250513          	addi	a0,a0,-1518 # 11e8 <malloc+0x1d2>
     7de:	00000097          	auipc	ra,0x0
     7e2:	442080e7          	jalr	1090(ra) # c20 <unlink>
    char *p1 = mmap(0, PGSIZE * 2, PROT_READ, MAP_SHARED, fd, 0);
     7e6:	4781                	li	a5,0
     7e8:	8726                	mv	a4,s1
     7ea:	4685                	li	a3,1
     7ec:	4605                	li	a2,1
     7ee:	6589                	lui	a1,0x2
     7f0:	4501                	li	a0,0
     7f2:	00000097          	auipc	ra,0x0
     7f6:	47e080e7          	jalr	1150(ra) # c70 <mmap>
     7fa:	892a                	mv	s2,a0
    if (p1 == MAP_FAILED)
     7fc:	57fd                	li	a5,-1
     7fe:	08f50b63          	beq	a0,a5,894 <fork_test+0x114>
        err("mmap (4)");
    char *p2 = mmap(0, PGSIZE * 2, PROT_READ, MAP_SHARED, fd, 0);
     802:	4781                	li	a5,0
     804:	8726                	mv	a4,s1
     806:	4685                	li	a3,1
     808:	4605                	li	a2,1
     80a:	6589                	lui	a1,0x2
     80c:	4501                	li	a0,0
     80e:	00000097          	auipc	ra,0x0
     812:	462080e7          	jalr	1122(ra) # c70 <mmap>
     816:	84aa                	mv	s1,a0
    if (p2 == MAP_FAILED)
     818:	57fd                	li	a5,-1
     81a:	08f50563          	beq	a0,a5,8a4 <fork_test+0x124>
        err("mmap (5)");

    // read just 2nd page.
    if (*(p1 + PGSIZE) != 'A')
     81e:	6785                	lui	a5,0x1
     820:	97ca                	add	a5,a5,s2
     822:	0007c703          	lbu	a4,0(a5) # 1000 <free+0x72>
     826:	04100793          	li	a5,65
     82a:	08f71563          	bne	a4,a5,8b4 <fork_test+0x134>
        err("fork mismatch (1)");

    if ((pid = fork()) < 0)
     82e:	00000097          	auipc	ra,0x0
     832:	39a080e7          	jalr	922(ra) # bc8 <fork>
     836:	08054763          	bltz	a0,8c4 <fork_test+0x144>
        err("fork");
    if (pid == 0)
     83a:	cd49                	beqz	a0,8d4 <fork_test+0x154>
        _v1(p1);
        munmap(p1, PGSIZE); // just the first page
        exit(0);            // tell the parent that the mapping looks OK.
    }

    int status = -1;
     83c:	57fd                	li	a5,-1
     83e:	fcf42e23          	sw	a5,-36(s0)
    wait(&status);
     842:	fdc40513          	addi	a0,s0,-36
     846:	00000097          	auipc	ra,0x0
     84a:	392080e7          	jalr	914(ra) # bd8 <wait>

    if (status != 0)
     84e:	fdc42783          	lw	a5,-36(s0)
     852:	e3cd                	bnez	a5,8f4 <fork_test+0x174>
        printf("fork_test failed\n");
        exit(1);
    }

    // check that the parent's mappings are still there.
    _v1(p1);
     854:	854a                	mv	a0,s2
     856:	fffff097          	auipc	ra,0xfffff
     85a:	7e8080e7          	jalr	2024(ra) # 3e <_v1>
    _v1(p2);
     85e:	8526                	mv	a0,s1
     860:	fffff097          	auipc	ra,0xfffff
     864:	7de080e7          	jalr	2014(ra) # 3e <_v1>

    printf("fork_test OK\n");
     868:	00001517          	auipc	a0,0x1
     86c:	d3050513          	addi	a0,a0,-720 # 1598 <malloc+0x582>
     870:	00000097          	auipc	ra,0x0
     874:	6e8080e7          	jalr	1768(ra) # f58 <printf>
}
     878:	70a2                	ld	ra,40(sp)
     87a:	7402                	ld	s0,32(sp)
     87c:	64e2                	ld	s1,24(sp)
     87e:	6942                	ld	s2,16(sp)
     880:	6145                	addi	sp,sp,48
     882:	8082                	ret
        err("open");
     884:	00001517          	auipc	a0,0x1
     888:	91450513          	addi	a0,a0,-1772 # 1198 <malloc+0x182>
     88c:	fffff097          	auipc	ra,0xfffff
     890:	774080e7          	jalr	1908(ra) # 0 <err>
        err("mmap (4)");
     894:	00001517          	auipc	a0,0x1
     898:	cac50513          	addi	a0,a0,-852 # 1540 <malloc+0x52a>
     89c:	fffff097          	auipc	ra,0xfffff
     8a0:	764080e7          	jalr	1892(ra) # 0 <err>
        err("mmap (5)");
     8a4:	00001517          	auipc	a0,0x1
     8a8:	cac50513          	addi	a0,a0,-852 # 1550 <malloc+0x53a>
     8ac:	fffff097          	auipc	ra,0xfffff
     8b0:	754080e7          	jalr	1876(ra) # 0 <err>
        err("fork mismatch (1)");
     8b4:	00001517          	auipc	a0,0x1
     8b8:	cac50513          	addi	a0,a0,-852 # 1560 <malloc+0x54a>
     8bc:	fffff097          	auipc	ra,0xfffff
     8c0:	744080e7          	jalr	1860(ra) # 0 <err>
        err("fork");
     8c4:	00001517          	auipc	a0,0x1
     8c8:	cb450513          	addi	a0,a0,-844 # 1578 <malloc+0x562>
     8cc:	fffff097          	auipc	ra,0xfffff
     8d0:	734080e7          	jalr	1844(ra) # 0 <err>
        _v1(p1);
     8d4:	854a                	mv	a0,s2
     8d6:	fffff097          	auipc	ra,0xfffff
     8da:	768080e7          	jalr	1896(ra) # 3e <_v1>
        munmap(p1, PGSIZE); // just the first page
     8de:	6585                	lui	a1,0x1
     8e0:	854a                	mv	a0,s2
     8e2:	00000097          	auipc	ra,0x0
     8e6:	396080e7          	jalr	918(ra) # c78 <munmap>
        exit(0);            // tell the parent that the mapping looks OK.
     8ea:	4501                	li	a0,0
     8ec:	00000097          	auipc	ra,0x0
     8f0:	2e4080e7          	jalr	740(ra) # bd0 <exit>
        printf("fork_test failed\n");
     8f4:	00001517          	auipc	a0,0x1
     8f8:	c8c50513          	addi	a0,a0,-884 # 1580 <malloc+0x56a>
     8fc:	00000097          	auipc	ra,0x0
     900:	65c080e7          	jalr	1628(ra) # f58 <printf>
        exit(1);
     904:	4505                	li	a0,1
     906:	00000097          	auipc	ra,0x0
     90a:	2ca080e7          	jalr	714(ra) # bd0 <exit>

000000000000090e <main>:
{
     90e:	1141                	addi	sp,sp,-16
     910:	e406                	sd	ra,8(sp)
     912:	e022                	sd	s0,0(sp)
     914:	0800                	addi	s0,sp,16
    mmap_test();
     916:	00000097          	auipc	ra,0x0
     91a:	86a080e7          	jalr	-1942(ra) # 180 <mmap_test>
    fork_test();
     91e:	00000097          	auipc	ra,0x0
     922:	e62080e7          	jalr	-414(ra) # 780 <fork_test>
    printf("mmaptest: all tests succeeded\n");
     926:	00001517          	auipc	a0,0x1
     92a:	c8250513          	addi	a0,a0,-894 # 15a8 <malloc+0x592>
     92e:	00000097          	auipc	ra,0x0
     932:	62a080e7          	jalr	1578(ra) # f58 <printf>
    exit(0);
     936:	4501                	li	a0,0
     938:	00000097          	auipc	ra,0x0
     93c:	298080e7          	jalr	664(ra) # bd0 <exit>

0000000000000940 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
     940:	1141                	addi	sp,sp,-16
     942:	e406                	sd	ra,8(sp)
     944:	e022                	sd	s0,0(sp)
     946:	0800                	addi	s0,sp,16
  extern int main();
  main();
     948:	00000097          	auipc	ra,0x0
     94c:	fc6080e7          	jalr	-58(ra) # 90e <main>
  exit(0);
     950:	4501                	li	a0,0
     952:	00000097          	auipc	ra,0x0
     956:	27e080e7          	jalr	638(ra) # bd0 <exit>

000000000000095a <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
     95a:	1141                	addi	sp,sp,-16
     95c:	e422                	sd	s0,8(sp)
     95e:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     960:	87aa                	mv	a5,a0
     962:	0585                	addi	a1,a1,1
     964:	0785                	addi	a5,a5,1
     966:	fff5c703          	lbu	a4,-1(a1) # fff <free+0x71>
     96a:	fee78fa3          	sb	a4,-1(a5)
     96e:	fb75                	bnez	a4,962 <strcpy+0x8>
    ;
  return os;
}
     970:	6422                	ld	s0,8(sp)
     972:	0141                	addi	sp,sp,16
     974:	8082                	ret

0000000000000976 <strcmp>:

int
strcmp(const char *p, const char *q)
{
     976:	1141                	addi	sp,sp,-16
     978:	e422                	sd	s0,8(sp)
     97a:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     97c:	00054783          	lbu	a5,0(a0)
     980:	cb91                	beqz	a5,994 <strcmp+0x1e>
     982:	0005c703          	lbu	a4,0(a1)
     986:	00f71763          	bne	a4,a5,994 <strcmp+0x1e>
    p++, q++;
     98a:	0505                	addi	a0,a0,1
     98c:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     98e:	00054783          	lbu	a5,0(a0)
     992:	fbe5                	bnez	a5,982 <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
     994:	0005c503          	lbu	a0,0(a1)
}
     998:	40a7853b          	subw	a0,a5,a0
     99c:	6422                	ld	s0,8(sp)
     99e:	0141                	addi	sp,sp,16
     9a0:	8082                	ret

00000000000009a2 <strlen>:

uint
strlen(const char *s)
{
     9a2:	1141                	addi	sp,sp,-16
     9a4:	e422                	sd	s0,8(sp)
     9a6:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     9a8:	00054783          	lbu	a5,0(a0)
     9ac:	cf91                	beqz	a5,9c8 <strlen+0x26>
     9ae:	0505                	addi	a0,a0,1
     9b0:	87aa                	mv	a5,a0
     9b2:	4685                	li	a3,1
     9b4:	9e89                	subw	a3,a3,a0
     9b6:	00f6853b          	addw	a0,a3,a5
     9ba:	0785                	addi	a5,a5,1
     9bc:	fff7c703          	lbu	a4,-1(a5)
     9c0:	fb7d                	bnez	a4,9b6 <strlen+0x14>
    ;
  return n;
}
     9c2:	6422                	ld	s0,8(sp)
     9c4:	0141                	addi	sp,sp,16
     9c6:	8082                	ret
  for(n = 0; s[n]; n++)
     9c8:	4501                	li	a0,0
     9ca:	bfe5                	j	9c2 <strlen+0x20>

00000000000009cc <memset>:

void*
memset(void *dst, int c, uint n)
{
     9cc:	1141                	addi	sp,sp,-16
     9ce:	e422                	sd	s0,8(sp)
     9d0:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     9d2:	ce09                	beqz	a2,9ec <memset+0x20>
     9d4:	87aa                	mv	a5,a0
     9d6:	fff6071b          	addiw	a4,a2,-1
     9da:	1702                	slli	a4,a4,0x20
     9dc:	9301                	srli	a4,a4,0x20
     9de:	0705                	addi	a4,a4,1
     9e0:	972a                	add	a4,a4,a0
    cdst[i] = c;
     9e2:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     9e6:	0785                	addi	a5,a5,1
     9e8:	fee79de3          	bne	a5,a4,9e2 <memset+0x16>
  }
  return dst;
}
     9ec:	6422                	ld	s0,8(sp)
     9ee:	0141                	addi	sp,sp,16
     9f0:	8082                	ret

00000000000009f2 <strchr>:

char*
strchr(const char *s, char c)
{
     9f2:	1141                	addi	sp,sp,-16
     9f4:	e422                	sd	s0,8(sp)
     9f6:	0800                	addi	s0,sp,16
  for(; *s; s++)
     9f8:	00054783          	lbu	a5,0(a0)
     9fc:	cb99                	beqz	a5,a12 <strchr+0x20>
    if(*s == c)
     9fe:	00f58763          	beq	a1,a5,a0c <strchr+0x1a>
  for(; *s; s++)
     a02:	0505                	addi	a0,a0,1
     a04:	00054783          	lbu	a5,0(a0)
     a08:	fbfd                	bnez	a5,9fe <strchr+0xc>
      return (char*)s;
  return 0;
     a0a:	4501                	li	a0,0
}
     a0c:	6422                	ld	s0,8(sp)
     a0e:	0141                	addi	sp,sp,16
     a10:	8082                	ret
  return 0;
     a12:	4501                	li	a0,0
     a14:	bfe5                	j	a0c <strchr+0x1a>

0000000000000a16 <gets>:

char*
gets(char *buf, int max)
{
     a16:	711d                	addi	sp,sp,-96
     a18:	ec86                	sd	ra,88(sp)
     a1a:	e8a2                	sd	s0,80(sp)
     a1c:	e4a6                	sd	s1,72(sp)
     a1e:	e0ca                	sd	s2,64(sp)
     a20:	fc4e                	sd	s3,56(sp)
     a22:	f852                	sd	s4,48(sp)
     a24:	f456                	sd	s5,40(sp)
     a26:	f05a                	sd	s6,32(sp)
     a28:	ec5e                	sd	s7,24(sp)
     a2a:	1080                	addi	s0,sp,96
     a2c:	8baa                	mv	s7,a0
     a2e:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     a30:	892a                	mv	s2,a0
     a32:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     a34:	4aa9                	li	s5,10
     a36:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
     a38:	89a6                	mv	s3,s1
     a3a:	2485                	addiw	s1,s1,1
     a3c:	0344d863          	bge	s1,s4,a6c <gets+0x56>
    cc = read(0, &c, 1);
     a40:	4605                	li	a2,1
     a42:	faf40593          	addi	a1,s0,-81
     a46:	4501                	li	a0,0
     a48:	00000097          	auipc	ra,0x0
     a4c:	1a0080e7          	jalr	416(ra) # be8 <read>
    if(cc < 1)
     a50:	00a05e63          	blez	a0,a6c <gets+0x56>
    buf[i++] = c;
     a54:	faf44783          	lbu	a5,-81(s0)
     a58:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     a5c:	01578763          	beq	a5,s5,a6a <gets+0x54>
     a60:	0905                	addi	s2,s2,1
     a62:	fd679be3          	bne	a5,s6,a38 <gets+0x22>
  for(i=0; i+1 < max; ){
     a66:	89a6                	mv	s3,s1
     a68:	a011                	j	a6c <gets+0x56>
     a6a:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
     a6c:	99de                	add	s3,s3,s7
     a6e:	00098023          	sb	zero,0(s3)
  return buf;
}
     a72:	855e                	mv	a0,s7
     a74:	60e6                	ld	ra,88(sp)
     a76:	6446                	ld	s0,80(sp)
     a78:	64a6                	ld	s1,72(sp)
     a7a:	6906                	ld	s2,64(sp)
     a7c:	79e2                	ld	s3,56(sp)
     a7e:	7a42                	ld	s4,48(sp)
     a80:	7aa2                	ld	s5,40(sp)
     a82:	7b02                	ld	s6,32(sp)
     a84:	6be2                	ld	s7,24(sp)
     a86:	6125                	addi	sp,sp,96
     a88:	8082                	ret

0000000000000a8a <stat>:

int
stat(const char *n, struct stat *st)
{
     a8a:	1101                	addi	sp,sp,-32
     a8c:	ec06                	sd	ra,24(sp)
     a8e:	e822                	sd	s0,16(sp)
     a90:	e426                	sd	s1,8(sp)
     a92:	e04a                	sd	s2,0(sp)
     a94:	1000                	addi	s0,sp,32
     a96:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     a98:	4581                	li	a1,0
     a9a:	00000097          	auipc	ra,0x0
     a9e:	176080e7          	jalr	374(ra) # c10 <open>
  if(fd < 0)
     aa2:	02054563          	bltz	a0,acc <stat+0x42>
     aa6:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     aa8:	85ca                	mv	a1,s2
     aaa:	00000097          	auipc	ra,0x0
     aae:	17e080e7          	jalr	382(ra) # c28 <fstat>
     ab2:	892a                	mv	s2,a0
  close(fd);
     ab4:	8526                	mv	a0,s1
     ab6:	00000097          	auipc	ra,0x0
     aba:	142080e7          	jalr	322(ra) # bf8 <close>
  return r;
}
     abe:	854a                	mv	a0,s2
     ac0:	60e2                	ld	ra,24(sp)
     ac2:	6442                	ld	s0,16(sp)
     ac4:	64a2                	ld	s1,8(sp)
     ac6:	6902                	ld	s2,0(sp)
     ac8:	6105                	addi	sp,sp,32
     aca:	8082                	ret
    return -1;
     acc:	597d                	li	s2,-1
     ace:	bfc5                	j	abe <stat+0x34>

0000000000000ad0 <atoi>:

int
atoi(const char *s)
{
     ad0:	1141                	addi	sp,sp,-16
     ad2:	e422                	sd	s0,8(sp)
     ad4:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     ad6:	00054603          	lbu	a2,0(a0)
     ada:	fd06079b          	addiw	a5,a2,-48
     ade:	0ff7f793          	andi	a5,a5,255
     ae2:	4725                	li	a4,9
     ae4:	02f76963          	bltu	a4,a5,b16 <atoi+0x46>
     ae8:	86aa                	mv	a3,a0
  n = 0;
     aea:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
     aec:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
     aee:	0685                	addi	a3,a3,1
     af0:	0025179b          	slliw	a5,a0,0x2
     af4:	9fa9                	addw	a5,a5,a0
     af6:	0017979b          	slliw	a5,a5,0x1
     afa:	9fb1                	addw	a5,a5,a2
     afc:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     b00:	0006c603          	lbu	a2,0(a3)
     b04:	fd06071b          	addiw	a4,a2,-48
     b08:	0ff77713          	andi	a4,a4,255
     b0c:	fee5f1e3          	bgeu	a1,a4,aee <atoi+0x1e>
  return n;
}
     b10:	6422                	ld	s0,8(sp)
     b12:	0141                	addi	sp,sp,16
     b14:	8082                	ret
  n = 0;
     b16:	4501                	li	a0,0
     b18:	bfe5                	j	b10 <atoi+0x40>

0000000000000b1a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     b1a:	1141                	addi	sp,sp,-16
     b1c:	e422                	sd	s0,8(sp)
     b1e:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     b20:	02b57663          	bgeu	a0,a1,b4c <memmove+0x32>
    while(n-- > 0)
     b24:	02c05163          	blez	a2,b46 <memmove+0x2c>
     b28:	fff6079b          	addiw	a5,a2,-1
     b2c:	1782                	slli	a5,a5,0x20
     b2e:	9381                	srli	a5,a5,0x20
     b30:	0785                	addi	a5,a5,1
     b32:	97aa                	add	a5,a5,a0
  dst = vdst;
     b34:	872a                	mv	a4,a0
      *dst++ = *src++;
     b36:	0585                	addi	a1,a1,1
     b38:	0705                	addi	a4,a4,1
     b3a:	fff5c683          	lbu	a3,-1(a1)
     b3e:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     b42:	fee79ae3          	bne	a5,a4,b36 <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     b46:	6422                	ld	s0,8(sp)
     b48:	0141                	addi	sp,sp,16
     b4a:	8082                	ret
    dst += n;
     b4c:	00c50733          	add	a4,a0,a2
    src += n;
     b50:	95b2                	add	a1,a1,a2
    while(n-- > 0)
     b52:	fec05ae3          	blez	a2,b46 <memmove+0x2c>
     b56:	fff6079b          	addiw	a5,a2,-1
     b5a:	1782                	slli	a5,a5,0x20
     b5c:	9381                	srli	a5,a5,0x20
     b5e:	fff7c793          	not	a5,a5
     b62:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     b64:	15fd                	addi	a1,a1,-1
     b66:	177d                	addi	a4,a4,-1
     b68:	0005c683          	lbu	a3,0(a1)
     b6c:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     b70:	fee79ae3          	bne	a5,a4,b64 <memmove+0x4a>
     b74:	bfc9                	j	b46 <memmove+0x2c>

0000000000000b76 <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     b76:	1141                	addi	sp,sp,-16
     b78:	e422                	sd	s0,8(sp)
     b7a:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     b7c:	ca05                	beqz	a2,bac <memcmp+0x36>
     b7e:	fff6069b          	addiw	a3,a2,-1
     b82:	1682                	slli	a3,a3,0x20
     b84:	9281                	srli	a3,a3,0x20
     b86:	0685                	addi	a3,a3,1
     b88:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
     b8a:	00054783          	lbu	a5,0(a0)
     b8e:	0005c703          	lbu	a4,0(a1)
     b92:	00e79863          	bne	a5,a4,ba2 <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
     b96:	0505                	addi	a0,a0,1
    p2++;
     b98:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     b9a:	fed518e3          	bne	a0,a3,b8a <memcmp+0x14>
  }
  return 0;
     b9e:	4501                	li	a0,0
     ba0:	a019                	j	ba6 <memcmp+0x30>
      return *p1 - *p2;
     ba2:	40e7853b          	subw	a0,a5,a4
}
     ba6:	6422                	ld	s0,8(sp)
     ba8:	0141                	addi	sp,sp,16
     baa:	8082                	ret
  return 0;
     bac:	4501                	li	a0,0
     bae:	bfe5                	j	ba6 <memcmp+0x30>

0000000000000bb0 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     bb0:	1141                	addi	sp,sp,-16
     bb2:	e406                	sd	ra,8(sp)
     bb4:	e022                	sd	s0,0(sp)
     bb6:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     bb8:	00000097          	auipc	ra,0x0
     bbc:	f62080e7          	jalr	-158(ra) # b1a <memmove>
}
     bc0:	60a2                	ld	ra,8(sp)
     bc2:	6402                	ld	s0,0(sp)
     bc4:	0141                	addi	sp,sp,16
     bc6:	8082                	ret

0000000000000bc8 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     bc8:	4885                	li	a7,1
 ecall
     bca:	00000073          	ecall
 ret
     bce:	8082                	ret

0000000000000bd0 <exit>:
.global exit
exit:
 li a7, SYS_exit
     bd0:	4889                	li	a7,2
 ecall
     bd2:	00000073          	ecall
 ret
     bd6:	8082                	ret

0000000000000bd8 <wait>:
.global wait
wait:
 li a7, SYS_wait
     bd8:	488d                	li	a7,3
 ecall
     bda:	00000073          	ecall
 ret
     bde:	8082                	ret

0000000000000be0 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     be0:	4891                	li	a7,4
 ecall
     be2:	00000073          	ecall
 ret
     be6:	8082                	ret

0000000000000be8 <read>:
.global read
read:
 li a7, SYS_read
     be8:	4895                	li	a7,5
 ecall
     bea:	00000073          	ecall
 ret
     bee:	8082                	ret

0000000000000bf0 <write>:
.global write
write:
 li a7, SYS_write
     bf0:	48c1                	li	a7,16
 ecall
     bf2:	00000073          	ecall
 ret
     bf6:	8082                	ret

0000000000000bf8 <close>:
.global close
close:
 li a7, SYS_close
     bf8:	48d5                	li	a7,21
 ecall
     bfa:	00000073          	ecall
 ret
     bfe:	8082                	ret

0000000000000c00 <kill>:
.global kill
kill:
 li a7, SYS_kill
     c00:	4899                	li	a7,6
 ecall
     c02:	00000073          	ecall
 ret
     c06:	8082                	ret

0000000000000c08 <exec>:
.global exec
exec:
 li a7, SYS_exec
     c08:	489d                	li	a7,7
 ecall
     c0a:	00000073          	ecall
 ret
     c0e:	8082                	ret

0000000000000c10 <open>:
.global open
open:
 li a7, SYS_open
     c10:	48bd                	li	a7,15
 ecall
     c12:	00000073          	ecall
 ret
     c16:	8082                	ret

0000000000000c18 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     c18:	48c5                	li	a7,17
 ecall
     c1a:	00000073          	ecall
 ret
     c1e:	8082                	ret

0000000000000c20 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     c20:	48c9                	li	a7,18
 ecall
     c22:	00000073          	ecall
 ret
     c26:	8082                	ret

0000000000000c28 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     c28:	48a1                	li	a7,8
 ecall
     c2a:	00000073          	ecall
 ret
     c2e:	8082                	ret

0000000000000c30 <link>:
.global link
link:
 li a7, SYS_link
     c30:	48cd                	li	a7,19
 ecall
     c32:	00000073          	ecall
 ret
     c36:	8082                	ret

0000000000000c38 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     c38:	48d1                	li	a7,20
 ecall
     c3a:	00000073          	ecall
 ret
     c3e:	8082                	ret

0000000000000c40 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     c40:	48a5                	li	a7,9
 ecall
     c42:	00000073          	ecall
 ret
     c46:	8082                	ret

0000000000000c48 <dup>:
.global dup
dup:
 li a7, SYS_dup
     c48:	48a9                	li	a7,10
 ecall
     c4a:	00000073          	ecall
 ret
     c4e:	8082                	ret

0000000000000c50 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     c50:	48ad                	li	a7,11
 ecall
     c52:	00000073          	ecall
 ret
     c56:	8082                	ret

0000000000000c58 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     c58:	48b1                	li	a7,12
 ecall
     c5a:	00000073          	ecall
 ret
     c5e:	8082                	ret

0000000000000c60 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     c60:	48b5                	li	a7,13
 ecall
     c62:	00000073          	ecall
 ret
     c66:	8082                	ret

0000000000000c68 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     c68:	48b9                	li	a7,14
 ecall
     c6a:	00000073          	ecall
 ret
     c6e:	8082                	ret

0000000000000c70 <mmap>:
.global mmap
mmap:
 li a7, SYS_mmap
     c70:	48d9                	li	a7,22
 ecall
     c72:	00000073          	ecall
 ret
     c76:	8082                	ret

0000000000000c78 <munmap>:
.global munmap
munmap:
 li a7, SYS_munmap
     c78:	48dd                	li	a7,23
 ecall
     c7a:	00000073          	ecall
 ret
     c7e:	8082                	ret

0000000000000c80 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     c80:	1101                	addi	sp,sp,-32
     c82:	ec06                	sd	ra,24(sp)
     c84:	e822                	sd	s0,16(sp)
     c86:	1000                	addi	s0,sp,32
     c88:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     c8c:	4605                	li	a2,1
     c8e:	fef40593          	addi	a1,s0,-17
     c92:	00000097          	auipc	ra,0x0
     c96:	f5e080e7          	jalr	-162(ra) # bf0 <write>
}
     c9a:	60e2                	ld	ra,24(sp)
     c9c:	6442                	ld	s0,16(sp)
     c9e:	6105                	addi	sp,sp,32
     ca0:	8082                	ret

0000000000000ca2 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     ca2:	7139                	addi	sp,sp,-64
     ca4:	fc06                	sd	ra,56(sp)
     ca6:	f822                	sd	s0,48(sp)
     ca8:	f426                	sd	s1,40(sp)
     caa:	f04a                	sd	s2,32(sp)
     cac:	ec4e                	sd	s3,24(sp)
     cae:	0080                	addi	s0,sp,64
     cb0:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     cb2:	c299                	beqz	a3,cb8 <printint+0x16>
     cb4:	0805c863          	bltz	a1,d44 <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
     cb8:	2581                	sext.w	a1,a1
  neg = 0;
     cba:	4881                	li	a7,0
     cbc:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
     cc0:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     cc2:	2601                	sext.w	a2,a2
     cc4:	00001517          	auipc	a0,0x1
     cc8:	91450513          	addi	a0,a0,-1772 # 15d8 <digits>
     ccc:	883a                	mv	a6,a4
     cce:	2705                	addiw	a4,a4,1
     cd0:	02c5f7bb          	remuw	a5,a1,a2
     cd4:	1782                	slli	a5,a5,0x20
     cd6:	9381                	srli	a5,a5,0x20
     cd8:	97aa                	add	a5,a5,a0
     cda:	0007c783          	lbu	a5,0(a5)
     cde:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     ce2:	0005879b          	sext.w	a5,a1
     ce6:	02c5d5bb          	divuw	a1,a1,a2
     cea:	0685                	addi	a3,a3,1
     cec:	fec7f0e3          	bgeu	a5,a2,ccc <printint+0x2a>
  if(neg)
     cf0:	00088b63          	beqz	a7,d06 <printint+0x64>
    buf[i++] = '-';
     cf4:	fd040793          	addi	a5,s0,-48
     cf8:	973e                	add	a4,a4,a5
     cfa:	02d00793          	li	a5,45
     cfe:	fef70823          	sb	a5,-16(a4)
     d02:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
     d06:	02e05863          	blez	a4,d36 <printint+0x94>
     d0a:	fc040793          	addi	a5,s0,-64
     d0e:	00e78933          	add	s2,a5,a4
     d12:	fff78993          	addi	s3,a5,-1
     d16:	99ba                	add	s3,s3,a4
     d18:	377d                	addiw	a4,a4,-1
     d1a:	1702                	slli	a4,a4,0x20
     d1c:	9301                	srli	a4,a4,0x20
     d1e:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     d22:	fff94583          	lbu	a1,-1(s2)
     d26:	8526                	mv	a0,s1
     d28:	00000097          	auipc	ra,0x0
     d2c:	f58080e7          	jalr	-168(ra) # c80 <putc>
  while(--i >= 0)
     d30:	197d                	addi	s2,s2,-1
     d32:	ff3918e3          	bne	s2,s3,d22 <printint+0x80>
}
     d36:	70e2                	ld	ra,56(sp)
     d38:	7442                	ld	s0,48(sp)
     d3a:	74a2                	ld	s1,40(sp)
     d3c:	7902                	ld	s2,32(sp)
     d3e:	69e2                	ld	s3,24(sp)
     d40:	6121                	addi	sp,sp,64
     d42:	8082                	ret
    x = -xx;
     d44:	40b005bb          	negw	a1,a1
    neg = 1;
     d48:	4885                	li	a7,1
    x = -xx;
     d4a:	bf8d                	j	cbc <printint+0x1a>

0000000000000d4c <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     d4c:	7119                	addi	sp,sp,-128
     d4e:	fc86                	sd	ra,120(sp)
     d50:	f8a2                	sd	s0,112(sp)
     d52:	f4a6                	sd	s1,104(sp)
     d54:	f0ca                	sd	s2,96(sp)
     d56:	ecce                	sd	s3,88(sp)
     d58:	e8d2                	sd	s4,80(sp)
     d5a:	e4d6                	sd	s5,72(sp)
     d5c:	e0da                	sd	s6,64(sp)
     d5e:	fc5e                	sd	s7,56(sp)
     d60:	f862                	sd	s8,48(sp)
     d62:	f466                	sd	s9,40(sp)
     d64:	f06a                	sd	s10,32(sp)
     d66:	ec6e                	sd	s11,24(sp)
     d68:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     d6a:	0005c903          	lbu	s2,0(a1)
     d6e:	18090f63          	beqz	s2,f0c <vprintf+0x1c0>
     d72:	8aaa                	mv	s5,a0
     d74:	8b32                	mv	s6,a2
     d76:	00158493          	addi	s1,a1,1
  state = 0;
     d7a:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
     d7c:	02500a13          	li	s4,37
      if(c == 'd'){
     d80:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
     d84:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
     d88:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
     d8c:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     d90:	00001b97          	auipc	s7,0x1
     d94:	848b8b93          	addi	s7,s7,-1976 # 15d8 <digits>
     d98:	a839                	j	db6 <vprintf+0x6a>
        putc(fd, c);
     d9a:	85ca                	mv	a1,s2
     d9c:	8556                	mv	a0,s5
     d9e:	00000097          	auipc	ra,0x0
     da2:	ee2080e7          	jalr	-286(ra) # c80 <putc>
     da6:	a019                	j	dac <vprintf+0x60>
    } else if(state == '%'){
     da8:	01498f63          	beq	s3,s4,dc6 <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
     dac:	0485                	addi	s1,s1,1
     dae:	fff4c903          	lbu	s2,-1(s1)
     db2:	14090d63          	beqz	s2,f0c <vprintf+0x1c0>
    c = fmt[i] & 0xff;
     db6:	0009079b          	sext.w	a5,s2
    if(state == 0){
     dba:	fe0997e3          	bnez	s3,da8 <vprintf+0x5c>
      if(c == '%'){
     dbe:	fd479ee3          	bne	a5,s4,d9a <vprintf+0x4e>
        state = '%';
     dc2:	89be                	mv	s3,a5
     dc4:	b7e5                	j	dac <vprintf+0x60>
      if(c == 'd'){
     dc6:	05878063          	beq	a5,s8,e06 <vprintf+0xba>
      } else if(c == 'l') {
     dca:	05978c63          	beq	a5,s9,e22 <vprintf+0xd6>
      } else if(c == 'x') {
     dce:	07a78863          	beq	a5,s10,e3e <vprintf+0xf2>
      } else if(c == 'p') {
     dd2:	09b78463          	beq	a5,s11,e5a <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
     dd6:	07300713          	li	a4,115
     dda:	0ce78663          	beq	a5,a4,ea6 <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
     dde:	06300713          	li	a4,99
     de2:	0ee78e63          	beq	a5,a4,ede <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
     de6:	11478863          	beq	a5,s4,ef6 <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
     dea:	85d2                	mv	a1,s4
     dec:	8556                	mv	a0,s5
     dee:	00000097          	auipc	ra,0x0
     df2:	e92080e7          	jalr	-366(ra) # c80 <putc>
        putc(fd, c);
     df6:	85ca                	mv	a1,s2
     df8:	8556                	mv	a0,s5
     dfa:	00000097          	auipc	ra,0x0
     dfe:	e86080e7          	jalr	-378(ra) # c80 <putc>
      }
      state = 0;
     e02:	4981                	li	s3,0
     e04:	b765                	j	dac <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
     e06:	008b0913          	addi	s2,s6,8
     e0a:	4685                	li	a3,1
     e0c:	4629                	li	a2,10
     e0e:	000b2583          	lw	a1,0(s6)
     e12:	8556                	mv	a0,s5
     e14:	00000097          	auipc	ra,0x0
     e18:	e8e080e7          	jalr	-370(ra) # ca2 <printint>
     e1c:	8b4a                	mv	s6,s2
      state = 0;
     e1e:	4981                	li	s3,0
     e20:	b771                	j	dac <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
     e22:	008b0913          	addi	s2,s6,8
     e26:	4681                	li	a3,0
     e28:	4629                	li	a2,10
     e2a:	000b2583          	lw	a1,0(s6)
     e2e:	8556                	mv	a0,s5
     e30:	00000097          	auipc	ra,0x0
     e34:	e72080e7          	jalr	-398(ra) # ca2 <printint>
     e38:	8b4a                	mv	s6,s2
      state = 0;
     e3a:	4981                	li	s3,0
     e3c:	bf85                	j	dac <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
     e3e:	008b0913          	addi	s2,s6,8
     e42:	4681                	li	a3,0
     e44:	4641                	li	a2,16
     e46:	000b2583          	lw	a1,0(s6)
     e4a:	8556                	mv	a0,s5
     e4c:	00000097          	auipc	ra,0x0
     e50:	e56080e7          	jalr	-426(ra) # ca2 <printint>
     e54:	8b4a                	mv	s6,s2
      state = 0;
     e56:	4981                	li	s3,0
     e58:	bf91                	j	dac <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
     e5a:	008b0793          	addi	a5,s6,8
     e5e:	f8f43423          	sd	a5,-120(s0)
     e62:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
     e66:	03000593          	li	a1,48
     e6a:	8556                	mv	a0,s5
     e6c:	00000097          	auipc	ra,0x0
     e70:	e14080e7          	jalr	-492(ra) # c80 <putc>
  putc(fd, 'x');
     e74:	85ea                	mv	a1,s10
     e76:	8556                	mv	a0,s5
     e78:	00000097          	auipc	ra,0x0
     e7c:	e08080e7          	jalr	-504(ra) # c80 <putc>
     e80:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     e82:	03c9d793          	srli	a5,s3,0x3c
     e86:	97de                	add	a5,a5,s7
     e88:	0007c583          	lbu	a1,0(a5)
     e8c:	8556                	mv	a0,s5
     e8e:	00000097          	auipc	ra,0x0
     e92:	df2080e7          	jalr	-526(ra) # c80 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
     e96:	0992                	slli	s3,s3,0x4
     e98:	397d                	addiw	s2,s2,-1
     e9a:	fe0914e3          	bnez	s2,e82 <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
     e9e:	f8843b03          	ld	s6,-120(s0)
      state = 0;
     ea2:	4981                	li	s3,0
     ea4:	b721                	j	dac <vprintf+0x60>
        s = va_arg(ap, char*);
     ea6:	008b0993          	addi	s3,s6,8
     eaa:	000b3903          	ld	s2,0(s6)
        if(s == 0)
     eae:	02090163          	beqz	s2,ed0 <vprintf+0x184>
        while(*s != 0){
     eb2:	00094583          	lbu	a1,0(s2)
     eb6:	c9a1                	beqz	a1,f06 <vprintf+0x1ba>
          putc(fd, *s);
     eb8:	8556                	mv	a0,s5
     eba:	00000097          	auipc	ra,0x0
     ebe:	dc6080e7          	jalr	-570(ra) # c80 <putc>
          s++;
     ec2:	0905                	addi	s2,s2,1
        while(*s != 0){
     ec4:	00094583          	lbu	a1,0(s2)
     ec8:	f9e5                	bnez	a1,eb8 <vprintf+0x16c>
        s = va_arg(ap, char*);
     eca:	8b4e                	mv	s6,s3
      state = 0;
     ecc:	4981                	li	s3,0
     ece:	bdf9                	j	dac <vprintf+0x60>
          s = "(null)";
     ed0:	00000917          	auipc	s2,0x0
     ed4:	70090913          	addi	s2,s2,1792 # 15d0 <malloc+0x5ba>
        while(*s != 0){
     ed8:	02800593          	li	a1,40
     edc:	bff1                	j	eb8 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
     ede:	008b0913          	addi	s2,s6,8
     ee2:	000b4583          	lbu	a1,0(s6)
     ee6:	8556                	mv	a0,s5
     ee8:	00000097          	auipc	ra,0x0
     eec:	d98080e7          	jalr	-616(ra) # c80 <putc>
     ef0:	8b4a                	mv	s6,s2
      state = 0;
     ef2:	4981                	li	s3,0
     ef4:	bd65                	j	dac <vprintf+0x60>
        putc(fd, c);
     ef6:	85d2                	mv	a1,s4
     ef8:	8556                	mv	a0,s5
     efa:	00000097          	auipc	ra,0x0
     efe:	d86080e7          	jalr	-634(ra) # c80 <putc>
      state = 0;
     f02:	4981                	li	s3,0
     f04:	b565                	j	dac <vprintf+0x60>
        s = va_arg(ap, char*);
     f06:	8b4e                	mv	s6,s3
      state = 0;
     f08:	4981                	li	s3,0
     f0a:	b54d                	j	dac <vprintf+0x60>
    }
  }
}
     f0c:	70e6                	ld	ra,120(sp)
     f0e:	7446                	ld	s0,112(sp)
     f10:	74a6                	ld	s1,104(sp)
     f12:	7906                	ld	s2,96(sp)
     f14:	69e6                	ld	s3,88(sp)
     f16:	6a46                	ld	s4,80(sp)
     f18:	6aa6                	ld	s5,72(sp)
     f1a:	6b06                	ld	s6,64(sp)
     f1c:	7be2                	ld	s7,56(sp)
     f1e:	7c42                	ld	s8,48(sp)
     f20:	7ca2                	ld	s9,40(sp)
     f22:	7d02                	ld	s10,32(sp)
     f24:	6de2                	ld	s11,24(sp)
     f26:	6109                	addi	sp,sp,128
     f28:	8082                	ret

0000000000000f2a <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
     f2a:	715d                	addi	sp,sp,-80
     f2c:	ec06                	sd	ra,24(sp)
     f2e:	e822                	sd	s0,16(sp)
     f30:	1000                	addi	s0,sp,32
     f32:	e010                	sd	a2,0(s0)
     f34:	e414                	sd	a3,8(s0)
     f36:	e818                	sd	a4,16(s0)
     f38:	ec1c                	sd	a5,24(s0)
     f3a:	03043023          	sd	a6,32(s0)
     f3e:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
     f42:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
     f46:	8622                	mv	a2,s0
     f48:	00000097          	auipc	ra,0x0
     f4c:	e04080e7          	jalr	-508(ra) # d4c <vprintf>
}
     f50:	60e2                	ld	ra,24(sp)
     f52:	6442                	ld	s0,16(sp)
     f54:	6161                	addi	sp,sp,80
     f56:	8082                	ret

0000000000000f58 <printf>:

void
printf(const char *fmt, ...)
{
     f58:	711d                	addi	sp,sp,-96
     f5a:	ec06                	sd	ra,24(sp)
     f5c:	e822                	sd	s0,16(sp)
     f5e:	1000                	addi	s0,sp,32
     f60:	e40c                	sd	a1,8(s0)
     f62:	e810                	sd	a2,16(s0)
     f64:	ec14                	sd	a3,24(s0)
     f66:	f018                	sd	a4,32(s0)
     f68:	f41c                	sd	a5,40(s0)
     f6a:	03043823          	sd	a6,48(s0)
     f6e:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
     f72:	00840613          	addi	a2,s0,8
     f76:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
     f7a:	85aa                	mv	a1,a0
     f7c:	4505                	li	a0,1
     f7e:	00000097          	auipc	ra,0x0
     f82:	dce080e7          	jalr	-562(ra) # d4c <vprintf>
}
     f86:	60e2                	ld	ra,24(sp)
     f88:	6442                	ld	s0,16(sp)
     f8a:	6125                	addi	sp,sp,96
     f8c:	8082                	ret

0000000000000f8e <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
     f8e:	1141                	addi	sp,sp,-16
     f90:	e422                	sd	s0,8(sp)
     f92:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
     f94:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     f98:	00001797          	auipc	a5,0x1
     f9c:	0787b783          	ld	a5,120(a5) # 2010 <freep>
     fa0:	a805                	j	fd0 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
     fa2:	4618                	lw	a4,8(a2)
     fa4:	9db9                	addw	a1,a1,a4
     fa6:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
     faa:	6398                	ld	a4,0(a5)
     fac:	6318                	ld	a4,0(a4)
     fae:	fee53823          	sd	a4,-16(a0)
     fb2:	a091                	j	ff6 <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
     fb4:	ff852703          	lw	a4,-8(a0)
     fb8:	9e39                	addw	a2,a2,a4
     fba:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
     fbc:	ff053703          	ld	a4,-16(a0)
     fc0:	e398                	sd	a4,0(a5)
     fc2:	a099                	j	1008 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     fc4:	6398                	ld	a4,0(a5)
     fc6:	00e7e463          	bltu	a5,a4,fce <free+0x40>
     fca:	00e6ea63          	bltu	a3,a4,fde <free+0x50>
{
     fce:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     fd0:	fed7fae3          	bgeu	a5,a3,fc4 <free+0x36>
     fd4:	6398                	ld	a4,0(a5)
     fd6:	00e6e463          	bltu	a3,a4,fde <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
     fda:	fee7eae3          	bltu	a5,a4,fce <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
     fde:	ff852583          	lw	a1,-8(a0)
     fe2:	6390                	ld	a2,0(a5)
     fe4:	02059713          	slli	a4,a1,0x20
     fe8:	9301                	srli	a4,a4,0x20
     fea:	0712                	slli	a4,a4,0x4
     fec:	9736                	add	a4,a4,a3
     fee:	fae60ae3          	beq	a2,a4,fa2 <free+0x14>
    bp->s.ptr = p->s.ptr;
     ff2:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
     ff6:	4790                	lw	a2,8(a5)
     ff8:	02061713          	slli	a4,a2,0x20
     ffc:	9301                	srli	a4,a4,0x20
     ffe:	0712                	slli	a4,a4,0x4
    1000:	973e                	add	a4,a4,a5
    1002:	fae689e3          	beq	a3,a4,fb4 <free+0x26>
  } else
    p->s.ptr = bp;
    1006:	e394                	sd	a3,0(a5)
  freep = p;
    1008:	00001717          	auipc	a4,0x1
    100c:	00f73423          	sd	a5,8(a4) # 2010 <freep>
}
    1010:	6422                	ld	s0,8(sp)
    1012:	0141                	addi	sp,sp,16
    1014:	8082                	ret

0000000000001016 <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    1016:	7139                	addi	sp,sp,-64
    1018:	fc06                	sd	ra,56(sp)
    101a:	f822                	sd	s0,48(sp)
    101c:	f426                	sd	s1,40(sp)
    101e:	f04a                	sd	s2,32(sp)
    1020:	ec4e                	sd	s3,24(sp)
    1022:	e852                	sd	s4,16(sp)
    1024:	e456                	sd	s5,8(sp)
    1026:	e05a                	sd	s6,0(sp)
    1028:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    102a:	02051493          	slli	s1,a0,0x20
    102e:	9081                	srli	s1,s1,0x20
    1030:	04bd                	addi	s1,s1,15
    1032:	8091                	srli	s1,s1,0x4
    1034:	0014899b          	addiw	s3,s1,1
    1038:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    103a:	00001517          	auipc	a0,0x1
    103e:	fd653503          	ld	a0,-42(a0) # 2010 <freep>
    1042:	c515                	beqz	a0,106e <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    1044:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1046:	4798                	lw	a4,8(a5)
    1048:	02977f63          	bgeu	a4,s1,1086 <malloc+0x70>
    104c:	8a4e                	mv	s4,s3
    104e:	0009871b          	sext.w	a4,s3
    1052:	6685                	lui	a3,0x1
    1054:	00d77363          	bgeu	a4,a3,105a <malloc+0x44>
    1058:	6a05                	lui	s4,0x1
    105a:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    105e:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    1062:	00001917          	auipc	s2,0x1
    1066:	fae90913          	addi	s2,s2,-82 # 2010 <freep>
  if(p == (char*)-1)
    106a:	5afd                	li	s5,-1
    106c:	a88d                	j	10de <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
    106e:	00001797          	auipc	a5,0x1
    1072:	3b278793          	addi	a5,a5,946 # 2420 <base>
    1076:	00001717          	auipc	a4,0x1
    107a:	f8f73d23          	sd	a5,-102(a4) # 2010 <freep>
    107e:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    1080:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    1084:	b7e1                	j	104c <malloc+0x36>
      if(p->s.size == nunits)
    1086:	02e48b63          	beq	s1,a4,10bc <malloc+0xa6>
        p->s.size -= nunits;
    108a:	4137073b          	subw	a4,a4,s3
    108e:	c798                	sw	a4,8(a5)
        p += p->s.size;
    1090:	1702                	slli	a4,a4,0x20
    1092:	9301                	srli	a4,a4,0x20
    1094:	0712                	slli	a4,a4,0x4
    1096:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    1098:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    109c:	00001717          	auipc	a4,0x1
    10a0:	f6a73a23          	sd	a0,-140(a4) # 2010 <freep>
      return (void*)(p + 1);
    10a4:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    10a8:	70e2                	ld	ra,56(sp)
    10aa:	7442                	ld	s0,48(sp)
    10ac:	74a2                	ld	s1,40(sp)
    10ae:	7902                	ld	s2,32(sp)
    10b0:	69e2                	ld	s3,24(sp)
    10b2:	6a42                	ld	s4,16(sp)
    10b4:	6aa2                	ld	s5,8(sp)
    10b6:	6b02                	ld	s6,0(sp)
    10b8:	6121                	addi	sp,sp,64
    10ba:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    10bc:	6398                	ld	a4,0(a5)
    10be:	e118                	sd	a4,0(a0)
    10c0:	bff1                	j	109c <malloc+0x86>
  hp->s.size = nu;
    10c2:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    10c6:	0541                	addi	a0,a0,16
    10c8:	00000097          	auipc	ra,0x0
    10cc:	ec6080e7          	jalr	-314(ra) # f8e <free>
  return freep;
    10d0:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    10d4:	d971                	beqz	a0,10a8 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    10d6:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    10d8:	4798                	lw	a4,8(a5)
    10da:	fa9776e3          	bgeu	a4,s1,1086 <malloc+0x70>
    if(p == freep)
    10de:	00093703          	ld	a4,0(s2)
    10e2:	853e                	mv	a0,a5
    10e4:	fef719e3          	bne	a4,a5,10d6 <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
    10e8:	8552                	mv	a0,s4
    10ea:	00000097          	auipc	ra,0x0
    10ee:	b6e080e7          	jalr	-1170(ra) # c58 <sbrk>
  if(p == (char*)-1)
    10f2:	fd5518e3          	bne	a0,s5,10c2 <malloc+0xac>
        return 0;
    10f6:	4501                	li	a0,0
    10f8:	bf45                	j	10a8 <malloc+0x92>
