
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
      1a:	c82080e7          	jalr	-894(ra) # c98 <getpid>
      1e:	86aa                	mv	a3,a0
      20:	8626                	mv	a2,s1
      22:	85ca                	mv	a1,s2
      24:	00001517          	auipc	a0,0x1
      28:	12c50513          	addi	a0,a0,300 # 1150 <malloc+0xf2>
      2c:	00001097          	auipc	ra,0x1
      30:	f74080e7          	jalr	-140(ra) # fa0 <printf>
    exit(1);
      34:	4505                	li	a0,1
      36:	00001097          	auipc	ra,0x1
      3a:	be2080e7          	jalr	-1054(ra) # c18 <exit>

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
    // printf("[Testing] (_v1) : check finished\n");
    int i;
    for (i = 0; i < PGSIZE * 2; i++)
    {
        // printf("[Testing] (_v1) : i= %d, con = %c\n", i, p[i]);
        if (i < PGSIZE + (PGSIZE / 2))
      48:	6685                	lui	a3,0x1
      4a:	7ff68693          	addi	a3,a3,2047 # 17ff <digits+0x117>
    for (i = 0; i < PGSIZE * 2; i++)
      4e:	6889                	lui	a7,0x2
        {
            // printf("[Testing] (_v1) : print p[i] %d\n", p[i]);
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
      82:	0fa50513          	addi	a0,a0,250 # 1178 <malloc+0x11a>
      86:	00001097          	auipc	ra,0x1
      8a:	f1a080e7          	jalr	-230(ra) # fa0 <printf>
                err("v1 mismatch (1)");
      8e:	00001517          	auipc	a0,0x1
      92:	11250513          	addi	a0,a0,274 # 11a0 <malloc+0x142>
      96:	00000097          	auipc	ra,0x0
      9a:	f6a080e7          	jalr	-150(ra) # 0 <err>
            {
                printf("mismatch at %d, wanted zero, got 0x%x\n", i, p[i]);
      9e:	00001517          	auipc	a0,0x1
      a2:	11250513          	addi	a0,a0,274 # 11b0 <malloc+0x152>
      a6:	00001097          	auipc	ra,0x1
      aa:	efa080e7          	jalr	-262(ra) # fa0 <printf>
                err("v1 mismatch (2)");
      ae:	00001517          	auipc	a0,0x1
      b2:	12a50513          	addi	a0,a0,298 # 11d8 <malloc+0x17a>
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
      da:	b92080e7          	jalr	-1134(ra) # c68 <unlink>
    int fd = open(f, O_WRONLY | O_CREATE);
      de:	20100593          	li	a1,513
      e2:	8526                	mv	a0,s1
      e4:	00001097          	auipc	ra,0x1
      e8:	b74080e7          	jalr	-1164(ra) # c58 <open>
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
     108:	910080e7          	jalr	-1776(ra) # a14 <memset>
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
     122:	b1a080e7          	jalr	-1254(ra) # c38 <write>
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
     138:	b0c080e7          	jalr	-1268(ra) # c40 <close>
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
     154:	09850513          	addi	a0,a0,152 # 11e8 <malloc+0x18a>
     158:	00000097          	auipc	ra,0x0
     15c:	ea8080e7          	jalr	-344(ra) # 0 <err>
            err("write 0 makefile");
     160:	00001517          	auipc	a0,0x1
     164:	09050513          	addi	a0,a0,144 # 11f0 <malloc+0x192>
     168:	00000097          	auipc	ra,0x0
     16c:	e98080e7          	jalr	-360(ra) # 0 <err>
        err("close");
     170:	00001517          	auipc	a0,0x1
     174:	09850513          	addi	a0,a0,152 # 1208 <malloc+0x1aa>
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
     194:	08050513          	addi	a0,a0,128 # 1210 <malloc+0x1b2>
     198:	00001097          	auipc	ra,0x1
     19c:	e08080e7          	jalr	-504(ra) # fa0 <printf>
    testname = "mmap_test";
     1a0:	00001797          	auipc	a5,0x1
     1a4:	08878793          	addi	a5,a5,136 # 1228 <malloc+0x1ca>
     1a8:	00002717          	auipc	a4,0x2
     1ac:	e4f73c23          	sd	a5,-424(a4) # 2000 <testname>
    //
    // create a file with known content, map it into memory, check that
    // the mapped memory has the same bytes as originally written to the
    // file.
    //
    makefile(f);
     1b0:	00001517          	auipc	a0,0x1
     1b4:	08850513          	addi	a0,a0,136 # 1238 <malloc+0x1da>
     1b8:	00000097          	auipc	ra,0x0
     1bc:	f0e080e7          	jalr	-242(ra) # c6 <makefile>
    if ((fd = open(f, O_RDONLY)) == -1)
     1c0:	4581                	li	a1,0
     1c2:	00001517          	auipc	a0,0x1
     1c6:	07650513          	addi	a0,a0,118 # 1238 <malloc+0x1da>
     1ca:	00001097          	auipc	ra,0x1
     1ce:	a8e080e7          	jalr	-1394(ra) # c58 <open>
     1d2:	57fd                	li	a5,-1
     1d4:	3ef50663          	beq	a0,a5,5c0 <mmap_test+0x440>
     1d8:	892a                	mv	s2,a0
        err("open");

    printf("test mmap f\n");
     1da:	00001517          	auipc	a0,0x1
     1de:	06e50513          	addi	a0,a0,110 # 1248 <malloc+0x1ea>
     1e2:	00001097          	auipc	ra,0x1
     1e6:	dbe080e7          	jalr	-578(ra) # fa0 <printf>
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
     1fa:	ac2080e7          	jalr	-1342(ra) # cb8 <mmap>
     1fe:	84aa                	mv	s1,a0
    // printf("[Testing] (mmaptest) : mmap output! \n");

    if (p == MAP_FAILED)
     200:	57fd                	li	a5,-1
     202:	3cf50763          	beq	a0,a5,5d0 <mmap_test+0x450>
        err("mmap (1)");
    // printf("[Testing] (mmaptest) : before _v1(p) \n");
    _v1(p);
     206:	00000097          	auipc	ra,0x0
     20a:	e38080e7          	jalr	-456(ra) # 3e <_v1>
    // printf("[Testing] (mmaptest) : mmap! good \n");
    if (munmap(p, PGSIZE * 2) == -1)
     20e:	6589                	lui	a1,0x2
     210:	8526                	mv	a0,s1
     212:	00001097          	auipc	ra,0x1
     216:	aae080e7          	jalr	-1362(ra) # cc0 <munmap>
     21a:	57fd                	li	a5,-1
     21c:	3cf50263          	beq	a0,a5,5e0 <mmap_test+0x460>
        err("munmap (1)");

    printf("test mmap f: OK\n");
     220:	00001517          	auipc	a0,0x1
     224:	05850513          	addi	a0,a0,88 # 1278 <malloc+0x21a>
     228:	00001097          	auipc	ra,0x1
     22c:	d78080e7          	jalr	-648(ra) # fa0 <printf>

    printf("test mmap private\n");
     230:	00001517          	auipc	a0,0x1
     234:	06050513          	addi	a0,a0,96 # 1290 <malloc+0x232>
     238:	00001097          	auipc	ra,0x1
     23c:	d68080e7          	jalr	-664(ra) # fa0 <printf>
    // should be able to map file opened read-only with private writable
    // mapping
    p = mmap(0, PGSIZE * 2, PROT_READ | PROT_WRITE, MAP_PRIVATE, fd, 0);
     240:	4781                	li	a5,0
     242:	874a                	mv	a4,s2
     244:	4689                	li	a3,2
     246:	460d                	li	a2,3
     248:	6589                	lui	a1,0x2
     24a:	4501                	li	a0,0
     24c:	00001097          	auipc	ra,0x1
     250:	a6c080e7          	jalr	-1428(ra) # cb8 <mmap>
     254:	84aa                	mv	s1,a0
    if (p == MAP_FAILED)
     256:	57fd                	li	a5,-1
     258:	38f50c63          	beq	a0,a5,5f0 <mmap_test+0x470>
        err("mmap (2)");
    if (close(fd) == -1)
     25c:	854a                	mv	a0,s2
     25e:	00001097          	auipc	ra,0x1
     262:	9e2080e7          	jalr	-1566(ra) # c40 <close>
     266:	57fd                	li	a5,-1
     268:	38f50c63          	beq	a0,a5,600 <mmap_test+0x480>
        err("close");
    _v1(p);
     26c:	8526                	mv	a0,s1
     26e:	00000097          	auipc	ra,0x0
     272:	dd0080e7          	jalr	-560(ra) # 3e <_v1>
    for (i = 0; i < PGSIZE * 2; i++)
     276:	87a6                	mv	a5,s1
     278:	6709                	lui	a4,0x2
     27a:	9726                	add	a4,a4,s1
        p[i] = 'Z';
     27c:	05a00693          	li	a3,90
     280:	00d78023          	sb	a3,0(a5)
    for (i = 0; i < PGSIZE * 2; i++)
     284:	0785                	addi	a5,a5,1
     286:	fef71de3          	bne	a4,a5,280 <mmap_test+0x100>
    if (munmap(p, PGSIZE * 2) == -1)
     28a:	6589                	lui	a1,0x2
     28c:	8526                	mv	a0,s1
     28e:	00001097          	auipc	ra,0x1
     292:	a32080e7          	jalr	-1486(ra) # cc0 <munmap>
     296:	57fd                	li	a5,-1
     298:	36f50c63          	beq	a0,a5,610 <mmap_test+0x490>
        err("munmap (2)");

    printf("test mmap private: OK\n");
     29c:	00001517          	auipc	a0,0x1
     2a0:	02c50513          	addi	a0,a0,44 # 12c8 <malloc+0x26a>
     2a4:	00001097          	auipc	ra,0x1
     2a8:	cfc080e7          	jalr	-772(ra) # fa0 <printf>

    printf("test mmap read-only\n");
     2ac:	00001517          	auipc	a0,0x1
     2b0:	03450513          	addi	a0,a0,52 # 12e0 <malloc+0x282>
     2b4:	00001097          	auipc	ra,0x1
     2b8:	cec080e7          	jalr	-788(ra) # fa0 <printf>

    // check that mmap doesn't allow read/write mapping of a
    // file opened read-only.
    if ((fd = open(f, O_RDONLY)) == -1)
     2bc:	4581                	li	a1,0
     2be:	00001517          	auipc	a0,0x1
     2c2:	f7a50513          	addi	a0,a0,-134 # 1238 <malloc+0x1da>
     2c6:	00001097          	auipc	ra,0x1
     2ca:	992080e7          	jalr	-1646(ra) # c58 <open>
     2ce:	84aa                	mv	s1,a0
     2d0:	57fd                	li	a5,-1
     2d2:	34f50763          	beq	a0,a5,620 <mmap_test+0x4a0>
        err("open");
    p = mmap(0, PGSIZE * 3, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
     2d6:	4781                	li	a5,0
     2d8:	872a                	mv	a4,a0
     2da:	4685                	li	a3,1
     2dc:	460d                	li	a2,3
     2de:	658d                	lui	a1,0x3
     2e0:	4501                	li	a0,0
     2e2:	00001097          	auipc	ra,0x1
     2e6:	9d6080e7          	jalr	-1578(ra) # cb8 <mmap>
    if (p != MAP_FAILED)
     2ea:	57fd                	li	a5,-1
     2ec:	34f51263          	bne	a0,a5,630 <mmap_test+0x4b0>
        err("mmap call should have failed");
    if (close(fd) == -1)
     2f0:	8526                	mv	a0,s1
     2f2:	00001097          	auipc	ra,0x1
     2f6:	94e080e7          	jalr	-1714(ra) # c40 <close>
     2fa:	57fd                	li	a5,-1
     2fc:	34f50263          	beq	a0,a5,640 <mmap_test+0x4c0>
        err("close");

    printf("test mmap read-only: OK\n");
     300:	00001517          	auipc	a0,0x1
     304:	01850513          	addi	a0,a0,24 # 1318 <malloc+0x2ba>
     308:	00001097          	auipc	ra,0x1
     30c:	c98080e7          	jalr	-872(ra) # fa0 <printf>

    printf("test mmap read/write\n");
     310:	00001517          	auipc	a0,0x1
     314:	02850513          	addi	a0,a0,40 # 1338 <malloc+0x2da>
     318:	00001097          	auipc	ra,0x1
     31c:	c88080e7          	jalr	-888(ra) # fa0 <printf>

    // check that mmap does allow read/write mapping of a
    // file opened read/write.
    if ((fd = open(f, O_RDWR)) == -1)
     320:	4589                	li	a1,2
     322:	00001517          	auipc	a0,0x1
     326:	f1650513          	addi	a0,a0,-234 # 1238 <malloc+0x1da>
     32a:	00001097          	auipc	ra,0x1
     32e:	92e080e7          	jalr	-1746(ra) # c58 <open>
     332:	84aa                	mv	s1,a0
     334:	57fd                	li	a5,-1
     336:	30f50d63          	beq	a0,a5,650 <mmap_test+0x4d0>
        err("open");
    p = mmap(0, PGSIZE * 3, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
     33a:	4781                	li	a5,0
     33c:	872a                	mv	a4,a0
     33e:	4685                	li	a3,1
     340:	460d                	li	a2,3
     342:	658d                	lui	a1,0x3
     344:	4501                	li	a0,0
     346:	00001097          	auipc	ra,0x1
     34a:	972080e7          	jalr	-1678(ra) # cb8 <mmap>
     34e:	89aa                	mv	s3,a0
    if (p == MAP_FAILED)
     350:	57fd                	li	a5,-1
     352:	30f50763          	beq	a0,a5,660 <mmap_test+0x4e0>
        err("mmap (3)");
    if (close(fd) == -1)
     356:	8526                	mv	a0,s1
     358:	00001097          	auipc	ra,0x1
     35c:	8e8080e7          	jalr	-1816(ra) # c40 <close>
     360:	57fd                	li	a5,-1
     362:	30f50763          	beq	a0,a5,670 <mmap_test+0x4f0>
        err("close");

    // check that the mapping still works after close(fd).
    _v1(p);
     366:	854e                	mv	a0,s3
     368:	00000097          	auipc	ra,0x0
     36c:	cd6080e7          	jalr	-810(ra) # 3e <_v1>

    // write the mapped memory.
    for (i = 0; i < PGSIZE * 2; i++)
     370:	87ce                	mv	a5,s3
     372:	6709                	lui	a4,0x2
     374:	974e                	add	a4,a4,s3
        p[i] = 'Z';
     376:	05a00693          	li	a3,90
     37a:	00d78023          	sb	a3,0(a5)
    for (i = 0; i < PGSIZE * 2; i++)
     37e:	0785                	addi	a5,a5,1
     380:	fee79de3          	bne	a5,a4,37a <mmap_test+0x1fa>

    // unmap just the first two of three pages of mapped memory.
    if (munmap(p, PGSIZE * 2) == -1)
     384:	6589                	lui	a1,0x2
     386:	854e                	mv	a0,s3
     388:	00001097          	auipc	ra,0x1
     38c:	938080e7          	jalr	-1736(ra) # cc0 <munmap>
     390:	57fd                	li	a5,-1
     392:	2ef50763          	beq	a0,a5,680 <mmap_test+0x500>
        err("munmap (3)");

    printf("test mmap read/write: OK\n");
     396:	00001517          	auipc	a0,0x1
     39a:	fda50513          	addi	a0,a0,-38 # 1370 <malloc+0x312>
     39e:	00001097          	auipc	ra,0x1
     3a2:	c02080e7          	jalr	-1022(ra) # fa0 <printf>

    printf("test mmap dirty\n");
     3a6:	00001517          	auipc	a0,0x1
     3aa:	fea50513          	addi	a0,a0,-22 # 1390 <malloc+0x332>
     3ae:	00001097          	auipc	ra,0x1
     3b2:	bf2080e7          	jalr	-1038(ra) # fa0 <printf>

    // check that the writes to the mapped memory were
    // written to the file.
    if ((fd = open(f, O_RDWR)) == -1)
     3b6:	4589                	li	a1,2
     3b8:	00001517          	auipc	a0,0x1
     3bc:	e8050513          	addi	a0,a0,-384 # 1238 <malloc+0x1da>
     3c0:	00001097          	auipc	ra,0x1
     3c4:	898080e7          	jalr	-1896(ra) # c58 <open>
     3c8:	892a                	mv	s2,a0
     3ca:	57fd                	li	a5,-1
     3cc:	6489                	lui	s1,0x2
     3ce:	80048493          	addi	s1,s1,-2048 # 1800 <digits+0x118>
    for (i = 0; i < PGSIZE + (PGSIZE / 2); i++)
    {
        char b;
        if (read(fd, &b, 1) != 1)
            err("read (1)");
        if (b != 'Z')
     3d2:	05a00a13          	li	s4,90
    if ((fd = open(f, O_RDWR)) == -1)
     3d6:	2af50d63          	beq	a0,a5,690 <mmap_test+0x510>
        if (read(fd, &b, 1) != 1)
     3da:	4605                	li	a2,1
     3dc:	fcf40593          	addi	a1,s0,-49
     3e0:	854a                	mv	a0,s2
     3e2:	00001097          	auipc	ra,0x1
     3e6:	84e080e7          	jalr	-1970(ra) # c30 <read>
     3ea:	4785                	li	a5,1
     3ec:	2af51a63          	bne	a0,a5,6a0 <mmap_test+0x520>
        if (b != 'Z')
     3f0:	fcf44783          	lbu	a5,-49(s0)
     3f4:	2b479e63          	bne	a5,s4,6b0 <mmap_test+0x530>
    for (i = 0; i < PGSIZE + (PGSIZE / 2); i++)
     3f8:	34fd                	addiw	s1,s1,-1
     3fa:	f0e5                	bnez	s1,3da <mmap_test+0x25a>
            err("file does not contain modifications");
    }
    if (close(fd) == -1)
     3fc:	854a                	mv	a0,s2
     3fe:	00001097          	auipc	ra,0x1
     402:	842080e7          	jalr	-1982(ra) # c40 <close>
     406:	57fd                	li	a5,-1
     408:	2af50c63          	beq	a0,a5,6c0 <mmap_test+0x540>
        err("close");

    printf("test mmap dirty: OK\n");
     40c:	00001517          	auipc	a0,0x1
     410:	fd450513          	addi	a0,a0,-44 # 13e0 <malloc+0x382>
     414:	00001097          	auipc	ra,0x1
     418:	b8c080e7          	jalr	-1140(ra) # fa0 <printf>

    printf("test not-mapped unmap\n");
     41c:	00001517          	auipc	a0,0x1
     420:	fdc50513          	addi	a0,a0,-36 # 13f8 <malloc+0x39a>
     424:	00001097          	auipc	ra,0x1
     428:	b7c080e7          	jalr	-1156(ra) # fa0 <printf>

    // unmap the rest of the mapped memory.
    if (munmap(p + PGSIZE * 2, PGSIZE) == -1)
     42c:	6585                	lui	a1,0x1
     42e:	6509                	lui	a0,0x2
     430:	954e                	add	a0,a0,s3
     432:	00001097          	auipc	ra,0x1
     436:	88e080e7          	jalr	-1906(ra) # cc0 <munmap>
     43a:	57fd                	li	a5,-1
     43c:	28f50a63          	beq	a0,a5,6d0 <mmap_test+0x550>
        err("munmap (4)");

    printf("test not-mapped unmap: OK\n");
     440:	00001517          	auipc	a0,0x1
     444:	fe050513          	addi	a0,a0,-32 # 1420 <malloc+0x3c2>
     448:	00001097          	auipc	ra,0x1
     44c:	b58080e7          	jalr	-1192(ra) # fa0 <printf>

    printf("test mmap two files\n");
     450:	00001517          	auipc	a0,0x1
     454:	ff050513          	addi	a0,a0,-16 # 1440 <malloc+0x3e2>
     458:	00001097          	auipc	ra,0x1
     45c:	b48080e7          	jalr	-1208(ra) # fa0 <printf>

    //
    // mmap two files at the same time.
    //
    int fd1;
    if ((fd1 = open("mmap1", O_RDWR | O_CREATE)) < 0)
     460:	20200593          	li	a1,514
     464:	00001517          	auipc	a0,0x1
     468:	ff450513          	addi	a0,a0,-12 # 1458 <malloc+0x3fa>
     46c:	00000097          	auipc	ra,0x0
     470:	7ec080e7          	jalr	2028(ra) # c58 <open>
     474:	84aa                	mv	s1,a0
     476:	26054563          	bltz	a0,6e0 <mmap_test+0x560>
        err("open mmap1");
    if (write(fd1, "12345", 5) != 5)
     47a:	4615                	li	a2,5
     47c:	00001597          	auipc	a1,0x1
     480:	ff458593          	addi	a1,a1,-12 # 1470 <malloc+0x412>
     484:	00000097          	auipc	ra,0x0
     488:	7b4080e7          	jalr	1972(ra) # c38 <write>
     48c:	4795                	li	a5,5
     48e:	26f51163          	bne	a0,a5,6f0 <mmap_test+0x570>
        err("write mmap1");
    char *p1 = mmap(0, PGSIZE, PROT_READ, MAP_PRIVATE, fd1, 0);
     492:	4781                	li	a5,0
     494:	8726                	mv	a4,s1
     496:	4689                	li	a3,2
     498:	4605                	li	a2,1
     49a:	6585                	lui	a1,0x1
     49c:	4501                	li	a0,0
     49e:	00001097          	auipc	ra,0x1
     4a2:	81a080e7          	jalr	-2022(ra) # cb8 <mmap>
     4a6:	89aa                	mv	s3,a0
    if (p1 == MAP_FAILED)
     4a8:	57fd                	li	a5,-1
     4aa:	24f50b63          	beq	a0,a5,700 <mmap_test+0x580>
        err("mmap mmap1");
    close(fd1);
     4ae:	8526                	mv	a0,s1
     4b0:	00000097          	auipc	ra,0x0
     4b4:	790080e7          	jalr	1936(ra) # c40 <close>
    unlink("mmap1");
     4b8:	00001517          	auipc	a0,0x1
     4bc:	fa050513          	addi	a0,a0,-96 # 1458 <malloc+0x3fa>
     4c0:	00000097          	auipc	ra,0x0
     4c4:	7a8080e7          	jalr	1960(ra) # c68 <unlink>

    int fd2;
    if ((fd2 = open("mmap2", O_RDWR | O_CREATE)) < 0)
     4c8:	20200593          	li	a1,514
     4cc:	00001517          	auipc	a0,0x1
     4d0:	fcc50513          	addi	a0,a0,-52 # 1498 <malloc+0x43a>
     4d4:	00000097          	auipc	ra,0x0
     4d8:	784080e7          	jalr	1924(ra) # c58 <open>
     4dc:	892a                	mv	s2,a0
     4de:	22054963          	bltz	a0,710 <mmap_test+0x590>
        err("open mmap2");
    if (write(fd2, "67890", 5) != 5)
     4e2:	4615                	li	a2,5
     4e4:	00001597          	auipc	a1,0x1
     4e8:	fcc58593          	addi	a1,a1,-52 # 14b0 <malloc+0x452>
     4ec:	00000097          	auipc	ra,0x0
     4f0:	74c080e7          	jalr	1868(ra) # c38 <write>
     4f4:	4795                	li	a5,5
     4f6:	22f51563          	bne	a0,a5,720 <mmap_test+0x5a0>
        err("write mmap2");
    char *p2 = mmap(0, PGSIZE, PROT_READ, MAP_PRIVATE, fd2, 0);
     4fa:	4781                	li	a5,0
     4fc:	874a                	mv	a4,s2
     4fe:	4689                	li	a3,2
     500:	4605                	li	a2,1
     502:	6585                	lui	a1,0x1
     504:	4501                	li	a0,0
     506:	00000097          	auipc	ra,0x0
     50a:	7b2080e7          	jalr	1970(ra) # cb8 <mmap>
     50e:	84aa                	mv	s1,a0
    if (p2 == MAP_FAILED)
     510:	57fd                	li	a5,-1
     512:	20f50f63          	beq	a0,a5,730 <mmap_test+0x5b0>
        err("mmap mmap2");
    close(fd2);
     516:	854a                	mv	a0,s2
     518:	00000097          	auipc	ra,0x0
     51c:	728080e7          	jalr	1832(ra) # c40 <close>
    unlink("mmap2");
     520:	00001517          	auipc	a0,0x1
     524:	f7850513          	addi	a0,a0,-136 # 1498 <malloc+0x43a>
     528:	00000097          	auipc	ra,0x0
     52c:	740080e7          	jalr	1856(ra) # c68 <unlink>

    if (memcmp(p1, "12345", 5) != 0)
     530:	4615                	li	a2,5
     532:	00001597          	auipc	a1,0x1
     536:	f3e58593          	addi	a1,a1,-194 # 1470 <malloc+0x412>
     53a:	854e                	mv	a0,s3
     53c:	00000097          	auipc	ra,0x0
     540:	682080e7          	jalr	1666(ra) # bbe <memcmp>
     544:	1e051e63          	bnez	a0,740 <mmap_test+0x5c0>
    {
        err("mmap1 mismatch");
    }
    if (memcmp(p2, "67890", 5) != 0)
     548:	4615                	li	a2,5
     54a:	00001597          	auipc	a1,0x1
     54e:	f6658593          	addi	a1,a1,-154 # 14b0 <malloc+0x452>
     552:	8526                	mv	a0,s1
     554:	00000097          	auipc	ra,0x0
     558:	66a080e7          	jalr	1642(ra) # bbe <memcmp>
     55c:	1e051a63          	bnez	a0,750 <mmap_test+0x5d0>
    {
        err("mmap2 mismatch");
    }

    munmap(p1, PGSIZE);
     560:	6585                	lui	a1,0x1
     562:	854e                	mv	a0,s3
     564:	00000097          	auipc	ra,0x0
     568:	75c080e7          	jalr	1884(ra) # cc0 <munmap>
    if (memcmp(p2, "67890", 5) != 0)
     56c:	4615                	li	a2,5
     56e:	00001597          	auipc	a1,0x1
     572:	f4258593          	addi	a1,a1,-190 # 14b0 <malloc+0x452>
     576:	8526                	mv	a0,s1
     578:	00000097          	auipc	ra,0x0
     57c:	646080e7          	jalr	1606(ra) # bbe <memcmp>
     580:	1e051063          	bnez	a0,760 <mmap_test+0x5e0>
        err("mmap2 mismatch (2)");
    munmap(p2, PGSIZE);
     584:	6585                	lui	a1,0x1
     586:	8526                	mv	a0,s1
     588:	00000097          	auipc	ra,0x0
     58c:	738080e7          	jalr	1848(ra) # cc0 <munmap>

    printf("test mmap two files: OK\n");
     590:	00001517          	auipc	a0,0x1
     594:	f8050513          	addi	a0,a0,-128 # 1510 <malloc+0x4b2>
     598:	00001097          	auipc	ra,0x1
     59c:	a08080e7          	jalr	-1528(ra) # fa0 <printf>

    printf("mmap_test: ALL OK\n");
     5a0:	00001517          	auipc	a0,0x1
     5a4:	f9050513          	addi	a0,a0,-112 # 1530 <malloc+0x4d2>
     5a8:	00001097          	auipc	ra,0x1
     5ac:	9f8080e7          	jalr	-1544(ra) # fa0 <printf>
}
     5b0:	70e2                	ld	ra,56(sp)
     5b2:	7442                	ld	s0,48(sp)
     5b4:	74a2                	ld	s1,40(sp)
     5b6:	7902                	ld	s2,32(sp)
     5b8:	69e2                	ld	s3,24(sp)
     5ba:	6a42                	ld	s4,16(sp)
     5bc:	6121                	addi	sp,sp,64
     5be:	8082                	ret
        err("open");
     5c0:	00001517          	auipc	a0,0x1
     5c4:	c2850513          	addi	a0,a0,-984 # 11e8 <malloc+0x18a>
     5c8:	00000097          	auipc	ra,0x0
     5cc:	a38080e7          	jalr	-1480(ra) # 0 <err>
        err("mmap (1)");
     5d0:	00001517          	auipc	a0,0x1
     5d4:	c8850513          	addi	a0,a0,-888 # 1258 <malloc+0x1fa>
     5d8:	00000097          	auipc	ra,0x0
     5dc:	a28080e7          	jalr	-1496(ra) # 0 <err>
        err("munmap (1)");
     5e0:	00001517          	auipc	a0,0x1
     5e4:	c8850513          	addi	a0,a0,-888 # 1268 <malloc+0x20a>
     5e8:	00000097          	auipc	ra,0x0
     5ec:	a18080e7          	jalr	-1512(ra) # 0 <err>
        err("mmap (2)");
     5f0:	00001517          	auipc	a0,0x1
     5f4:	cb850513          	addi	a0,a0,-840 # 12a8 <malloc+0x24a>
     5f8:	00000097          	auipc	ra,0x0
     5fc:	a08080e7          	jalr	-1528(ra) # 0 <err>
        err("close");
     600:	00001517          	auipc	a0,0x1
     604:	c0850513          	addi	a0,a0,-1016 # 1208 <malloc+0x1aa>
     608:	00000097          	auipc	ra,0x0
     60c:	9f8080e7          	jalr	-1544(ra) # 0 <err>
        err("munmap (2)");
     610:	00001517          	auipc	a0,0x1
     614:	ca850513          	addi	a0,a0,-856 # 12b8 <malloc+0x25a>
     618:	00000097          	auipc	ra,0x0
     61c:	9e8080e7          	jalr	-1560(ra) # 0 <err>
        err("open");
     620:	00001517          	auipc	a0,0x1
     624:	bc850513          	addi	a0,a0,-1080 # 11e8 <malloc+0x18a>
     628:	00000097          	auipc	ra,0x0
     62c:	9d8080e7          	jalr	-1576(ra) # 0 <err>
        err("mmap call should have failed");
     630:	00001517          	auipc	a0,0x1
     634:	cc850513          	addi	a0,a0,-824 # 12f8 <malloc+0x29a>
     638:	00000097          	auipc	ra,0x0
     63c:	9c8080e7          	jalr	-1592(ra) # 0 <err>
        err("close");
     640:	00001517          	auipc	a0,0x1
     644:	bc850513          	addi	a0,a0,-1080 # 1208 <malloc+0x1aa>
     648:	00000097          	auipc	ra,0x0
     64c:	9b8080e7          	jalr	-1608(ra) # 0 <err>
        err("open");
     650:	00001517          	auipc	a0,0x1
     654:	b9850513          	addi	a0,a0,-1128 # 11e8 <malloc+0x18a>
     658:	00000097          	auipc	ra,0x0
     65c:	9a8080e7          	jalr	-1624(ra) # 0 <err>
        err("mmap (3)");
     660:	00001517          	auipc	a0,0x1
     664:	cf050513          	addi	a0,a0,-784 # 1350 <malloc+0x2f2>
     668:	00000097          	auipc	ra,0x0
     66c:	998080e7          	jalr	-1640(ra) # 0 <err>
        err("close");
     670:	00001517          	auipc	a0,0x1
     674:	b9850513          	addi	a0,a0,-1128 # 1208 <malloc+0x1aa>
     678:	00000097          	auipc	ra,0x0
     67c:	988080e7          	jalr	-1656(ra) # 0 <err>
        err("munmap (3)");
     680:	00001517          	auipc	a0,0x1
     684:	ce050513          	addi	a0,a0,-800 # 1360 <malloc+0x302>
     688:	00000097          	auipc	ra,0x0
     68c:	978080e7          	jalr	-1672(ra) # 0 <err>
        err("open");
     690:	00001517          	auipc	a0,0x1
     694:	b5850513          	addi	a0,a0,-1192 # 11e8 <malloc+0x18a>
     698:	00000097          	auipc	ra,0x0
     69c:	968080e7          	jalr	-1688(ra) # 0 <err>
            err("read (1)");
     6a0:	00001517          	auipc	a0,0x1
     6a4:	d0850513          	addi	a0,a0,-760 # 13a8 <malloc+0x34a>
     6a8:	00000097          	auipc	ra,0x0
     6ac:	958080e7          	jalr	-1704(ra) # 0 <err>
            err("file does not contain modifications");
     6b0:	00001517          	auipc	a0,0x1
     6b4:	d0850513          	addi	a0,a0,-760 # 13b8 <malloc+0x35a>
     6b8:	00000097          	auipc	ra,0x0
     6bc:	948080e7          	jalr	-1720(ra) # 0 <err>
        err("close");
     6c0:	00001517          	auipc	a0,0x1
     6c4:	b4850513          	addi	a0,a0,-1208 # 1208 <malloc+0x1aa>
     6c8:	00000097          	auipc	ra,0x0
     6cc:	938080e7          	jalr	-1736(ra) # 0 <err>
        err("munmap (4)");
     6d0:	00001517          	auipc	a0,0x1
     6d4:	d4050513          	addi	a0,a0,-704 # 1410 <malloc+0x3b2>
     6d8:	00000097          	auipc	ra,0x0
     6dc:	928080e7          	jalr	-1752(ra) # 0 <err>
        err("open mmap1");
     6e0:	00001517          	auipc	a0,0x1
     6e4:	d8050513          	addi	a0,a0,-640 # 1460 <malloc+0x402>
     6e8:	00000097          	auipc	ra,0x0
     6ec:	918080e7          	jalr	-1768(ra) # 0 <err>
        err("write mmap1");
     6f0:	00001517          	auipc	a0,0x1
     6f4:	d8850513          	addi	a0,a0,-632 # 1478 <malloc+0x41a>
     6f8:	00000097          	auipc	ra,0x0
     6fc:	908080e7          	jalr	-1784(ra) # 0 <err>
        err("mmap mmap1");
     700:	00001517          	auipc	a0,0x1
     704:	d8850513          	addi	a0,a0,-632 # 1488 <malloc+0x42a>
     708:	00000097          	auipc	ra,0x0
     70c:	8f8080e7          	jalr	-1800(ra) # 0 <err>
        err("open mmap2");
     710:	00001517          	auipc	a0,0x1
     714:	d9050513          	addi	a0,a0,-624 # 14a0 <malloc+0x442>
     718:	00000097          	auipc	ra,0x0
     71c:	8e8080e7          	jalr	-1816(ra) # 0 <err>
        err("write mmap2");
     720:	00001517          	auipc	a0,0x1
     724:	d9850513          	addi	a0,a0,-616 # 14b8 <malloc+0x45a>
     728:	00000097          	auipc	ra,0x0
     72c:	8d8080e7          	jalr	-1832(ra) # 0 <err>
        err("mmap mmap2");
     730:	00001517          	auipc	a0,0x1
     734:	d9850513          	addi	a0,a0,-616 # 14c8 <malloc+0x46a>
     738:	00000097          	auipc	ra,0x0
     73c:	8c8080e7          	jalr	-1848(ra) # 0 <err>
        err("mmap1 mismatch");
     740:	00001517          	auipc	a0,0x1
     744:	d9850513          	addi	a0,a0,-616 # 14d8 <malloc+0x47a>
     748:	00000097          	auipc	ra,0x0
     74c:	8b8080e7          	jalr	-1864(ra) # 0 <err>
        err("mmap2 mismatch");
     750:	00001517          	auipc	a0,0x1
     754:	d9850513          	addi	a0,a0,-616 # 14e8 <malloc+0x48a>
     758:	00000097          	auipc	ra,0x0
     75c:	8a8080e7          	jalr	-1880(ra) # 0 <err>
        err("mmap2 mismatch (2)");
     760:	00001517          	auipc	a0,0x1
     764:	d9850513          	addi	a0,a0,-616 # 14f8 <malloc+0x49a>
     768:	00000097          	auipc	ra,0x0
     76c:	898080e7          	jalr	-1896(ra) # 0 <err>

0000000000000770 <fork_test>:
//
// mmap a file, then fork.
// check that the child sees the mapped file.
//
void fork_test(void)
{
     770:	7139                	addi	sp,sp,-64
     772:	fc06                	sd	ra,56(sp)
     774:	f822                	sd	s0,48(sp)
     776:	f426                	sd	s1,40(sp)
     778:	f04a                	sd	s2,32(sp)
     77a:	ec4e                	sd	s3,24(sp)
     77c:	0080                	addi	s0,sp,64
    int fd;
    int pid;
    const char *const f = "mmap.dur";

    printf("fork_test starting\n");
     77e:	00001517          	auipc	a0,0x1
     782:	dca50513          	addi	a0,a0,-566 # 1548 <malloc+0x4ea>
     786:	00001097          	auipc	ra,0x1
     78a:	81a080e7          	jalr	-2022(ra) # fa0 <printf>
    testname = "fork_test";
     78e:	00001797          	auipc	a5,0x1
     792:	dd278793          	addi	a5,a5,-558 # 1560 <malloc+0x502>
     796:	00002717          	auipc	a4,0x2
     79a:	86f73523          	sd	a5,-1942(a4) # 2000 <testname>

    // mmap the file twice.
    makefile(f);
     79e:	00001517          	auipc	a0,0x1
     7a2:	a9a50513          	addi	a0,a0,-1382 # 1238 <malloc+0x1da>
     7a6:	00000097          	auipc	ra,0x0
     7aa:	920080e7          	jalr	-1760(ra) # c6 <makefile>
    if ((fd = open(f, O_RDONLY)) == -1)
     7ae:	4581                	li	a1,0
     7b0:	00001517          	auipc	a0,0x1
     7b4:	a8850513          	addi	a0,a0,-1400 # 1238 <malloc+0x1da>
     7b8:	00000097          	auipc	ra,0x0
     7bc:	4a0080e7          	jalr	1184(ra) # c58 <open>
     7c0:	57fd                	li	a5,-1
     7c2:	0ef50d63          	beq	a0,a5,8bc <fork_test+0x14c>
     7c6:	84aa                	mv	s1,a0
        err("open");
    unlink(f);
     7c8:	00001517          	auipc	a0,0x1
     7cc:	a7050513          	addi	a0,a0,-1424 # 1238 <malloc+0x1da>
     7d0:	00000097          	auipc	ra,0x0
     7d4:	498080e7          	jalr	1176(ra) # c68 <unlink>
    char *p1 = mmap(0, PGSIZE * 2, PROT_READ, MAP_SHARED, fd, 0);
     7d8:	4781                	li	a5,0
     7da:	8726                	mv	a4,s1
     7dc:	4685                	li	a3,1
     7de:	4605                	li	a2,1
     7e0:	6589                	lui	a1,0x2
     7e2:	4501                	li	a0,0
     7e4:	00000097          	auipc	ra,0x0
     7e8:	4d4080e7          	jalr	1236(ra) # cb8 <mmap>
     7ec:	892a                	mv	s2,a0
    if (p1 == MAP_FAILED)
     7ee:	57fd                	li	a5,-1
     7f0:	0cf50e63          	beq	a0,a5,8cc <fork_test+0x15c>
        err("mmap (4)");
    char *p2 = mmap(0, PGSIZE * 2, PROT_READ, MAP_SHARED, fd, 0);
     7f4:	4781                	li	a5,0
     7f6:	8726                	mv	a4,s1
     7f8:	4685                	li	a3,1
     7fa:	4605                	li	a2,1
     7fc:	6589                	lui	a1,0x2
     7fe:	4501                	li	a0,0
     800:	00000097          	auipc	ra,0x0
     804:	4b8080e7          	jalr	1208(ra) # cb8 <mmap>
     808:	84aa                	mv	s1,a0
    if (p2 == MAP_FAILED)
     80a:	57fd                	li	a5,-1
     80c:	0cf50863          	beq	a0,a5,8dc <fork_test+0x16c>
        err("mmap (5)");

    // read just 2nd page.
    printf("[Testing] (fork_test) : read just 2nd page.\n");
     810:	00001517          	auipc	a0,0x1
     814:	d8050513          	addi	a0,a0,-640 # 1590 <malloc+0x532>
     818:	00000097          	auipc	ra,0x0
     81c:	788080e7          	jalr	1928(ra) # fa0 <printf>
    if (*(p1 + PGSIZE) != 'A')
     820:	6785                	lui	a5,0x1
     822:	97ca                	add	a5,a5,s2
     824:	0007c703          	lbu	a4,0(a5) # 1000 <free+0x2a>
     828:	04100793          	li	a5,65
     82c:	0cf71063          	bne	a4,a5,8ec <fork_test+0x17c>
        err("fork mismatch (1)");
    printf("[Testing] (fork_test) : read just 2nd page finished.\n");
     830:	00001517          	auipc	a0,0x1
     834:	da850513          	addi	a0,a0,-600 # 15d8 <malloc+0x57a>
     838:	00000097          	auipc	ra,0x0
     83c:	768080e7          	jalr	1896(ra) # fa0 <printf>
    printf("[Testing] (fork_test) : fork starts.\n");
     840:	00001517          	auipc	a0,0x1
     844:	dd050513          	addi	a0,a0,-560 # 1610 <malloc+0x5b2>
     848:	00000097          	auipc	ra,0x0
     84c:	758080e7          	jalr	1880(ra) # fa0 <printf>
    if ((pid = fork()) < 0)
     850:	00000097          	auipc	ra,0x0
     854:	3c0080e7          	jalr	960(ra) # c10 <fork>
     858:	89aa                	mv	s3,a0
     85a:	0a054163          	bltz	a0,8fc <fork_test+0x18c>
    {
        printf("[Testing] (fork_test) : fork error.\n");
        err("fork");
    }
    printf("[Testing] (fork_test) : fork finishes.\n");
     85e:	00001517          	auipc	a0,0x1
     862:	e0a50513          	addi	a0,a0,-502 # 1668 <malloc+0x60a>
     866:	00000097          	auipc	ra,0x0
     86a:	73a080e7          	jalr	1850(ra) # fa0 <printf>
    if (pid == 0)
     86e:	0a098763          	beqz	s3,91c <fork_test+0x1ac>
        _v1(p1);
        munmap(p1, PGSIZE); // just the first page
        exit(0);            // tell the parent that the mapping looks OK.
    }

    int status = -1;
     872:	57fd                	li	a5,-1
     874:	fcf42623          	sw	a5,-52(s0)
    wait(&status);
     878:	fcc40513          	addi	a0,s0,-52
     87c:	00000097          	auipc	ra,0x0
     880:	3a4080e7          	jalr	932(ra) # c20 <wait>

    if (status != 0)
     884:	fcc42783          	lw	a5,-52(s0)
     888:	ebd5                	bnez	a5,93c <fork_test+0x1cc>
        printf("fork_test failed\n");
        exit(1);
    }

    // check that the parent's mappings are still there.
    _v1(p1);
     88a:	854a                	mv	a0,s2
     88c:	fffff097          	auipc	ra,0xfffff
     890:	7b2080e7          	jalr	1970(ra) # 3e <_v1>
    _v1(p2);
     894:	8526                	mv	a0,s1
     896:	fffff097          	auipc	ra,0xfffff
     89a:	7a8080e7          	jalr	1960(ra) # 3e <_v1>

    printf("fork_test OK\n");
     89e:	00001517          	auipc	a0,0x1
     8a2:	e0a50513          	addi	a0,a0,-502 # 16a8 <malloc+0x64a>
     8a6:	00000097          	auipc	ra,0x0
     8aa:	6fa080e7          	jalr	1786(ra) # fa0 <printf>
}
     8ae:	70e2                	ld	ra,56(sp)
     8b0:	7442                	ld	s0,48(sp)
     8b2:	74a2                	ld	s1,40(sp)
     8b4:	7902                	ld	s2,32(sp)
     8b6:	69e2                	ld	s3,24(sp)
     8b8:	6121                	addi	sp,sp,64
     8ba:	8082                	ret
        err("open");
     8bc:	00001517          	auipc	a0,0x1
     8c0:	92c50513          	addi	a0,a0,-1748 # 11e8 <malloc+0x18a>
     8c4:	fffff097          	auipc	ra,0xfffff
     8c8:	73c080e7          	jalr	1852(ra) # 0 <err>
        err("mmap (4)");
     8cc:	00001517          	auipc	a0,0x1
     8d0:	ca450513          	addi	a0,a0,-860 # 1570 <malloc+0x512>
     8d4:	fffff097          	auipc	ra,0xfffff
     8d8:	72c080e7          	jalr	1836(ra) # 0 <err>
        err("mmap (5)");
     8dc:	00001517          	auipc	a0,0x1
     8e0:	ca450513          	addi	a0,a0,-860 # 1580 <malloc+0x522>
     8e4:	fffff097          	auipc	ra,0xfffff
     8e8:	71c080e7          	jalr	1820(ra) # 0 <err>
        err("fork mismatch (1)");
     8ec:	00001517          	auipc	a0,0x1
     8f0:	cd450513          	addi	a0,a0,-812 # 15c0 <malloc+0x562>
     8f4:	fffff097          	auipc	ra,0xfffff
     8f8:	70c080e7          	jalr	1804(ra) # 0 <err>
        printf("[Testing] (fork_test) : fork error.\n");
     8fc:	00001517          	auipc	a0,0x1
     900:	d3c50513          	addi	a0,a0,-708 # 1638 <malloc+0x5da>
     904:	00000097          	auipc	ra,0x0
     908:	69c080e7          	jalr	1692(ra) # fa0 <printf>
        err("fork");
     90c:	00001517          	auipc	a0,0x1
     910:	d5450513          	addi	a0,a0,-684 # 1660 <malloc+0x602>
     914:	fffff097          	auipc	ra,0xfffff
     918:	6ec080e7          	jalr	1772(ra) # 0 <err>
        _v1(p1);
     91c:	854a                	mv	a0,s2
     91e:	fffff097          	auipc	ra,0xfffff
     922:	720080e7          	jalr	1824(ra) # 3e <_v1>
        munmap(p1, PGSIZE); // just the first page
     926:	6585                	lui	a1,0x1
     928:	854a                	mv	a0,s2
     92a:	00000097          	auipc	ra,0x0
     92e:	396080e7          	jalr	918(ra) # cc0 <munmap>
        exit(0);            // tell the parent that the mapping looks OK.
     932:	4501                	li	a0,0
     934:	00000097          	auipc	ra,0x0
     938:	2e4080e7          	jalr	740(ra) # c18 <exit>
        printf("fork_test failed\n");
     93c:	00001517          	auipc	a0,0x1
     940:	d5450513          	addi	a0,a0,-684 # 1690 <malloc+0x632>
     944:	00000097          	auipc	ra,0x0
     948:	65c080e7          	jalr	1628(ra) # fa0 <printf>
        exit(1);
     94c:	4505                	li	a0,1
     94e:	00000097          	auipc	ra,0x0
     952:	2ca080e7          	jalr	714(ra) # c18 <exit>

0000000000000956 <main>:
{
     956:	1141                	addi	sp,sp,-16
     958:	e406                	sd	ra,8(sp)
     95a:	e022                	sd	s0,0(sp)
     95c:	0800                	addi	s0,sp,16
    mmap_test();
     95e:	00000097          	auipc	ra,0x0
     962:	822080e7          	jalr	-2014(ra) # 180 <mmap_test>
    fork_test();
     966:	00000097          	auipc	ra,0x0
     96a:	e0a080e7          	jalr	-502(ra) # 770 <fork_test>
    printf("mmaptest: all tests succeeded\n");
     96e:	00001517          	auipc	a0,0x1
     972:	d4a50513          	addi	a0,a0,-694 # 16b8 <malloc+0x65a>
     976:	00000097          	auipc	ra,0x0
     97a:	62a080e7          	jalr	1578(ra) # fa0 <printf>
    exit(0);
     97e:	4501                	li	a0,0
     980:	00000097          	auipc	ra,0x0
     984:	298080e7          	jalr	664(ra) # c18 <exit>

0000000000000988 <_main>:
//
// wrapper so that it's OK if main() does not call exit().
//
void
_main()
{
     988:	1141                	addi	sp,sp,-16
     98a:	e406                	sd	ra,8(sp)
     98c:	e022                	sd	s0,0(sp)
     98e:	0800                	addi	s0,sp,16
  extern int main();
  main();
     990:	00000097          	auipc	ra,0x0
     994:	fc6080e7          	jalr	-58(ra) # 956 <main>
  exit(0);
     998:	4501                	li	a0,0
     99a:	00000097          	auipc	ra,0x0
     99e:	27e080e7          	jalr	638(ra) # c18 <exit>

00000000000009a2 <strcpy>:
}

char*
strcpy(char *s, const char *t)
{
     9a2:	1141                	addi	sp,sp,-16
     9a4:	e422                	sd	s0,8(sp)
     9a6:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
     9a8:	87aa                	mv	a5,a0
     9aa:	0585                	addi	a1,a1,1
     9ac:	0785                	addi	a5,a5,1
     9ae:	fff5c703          	lbu	a4,-1(a1) # fff <free+0x29>
     9b2:	fee78fa3          	sb	a4,-1(a5)
     9b6:	fb75                	bnez	a4,9aa <strcpy+0x8>
    ;
  return os;
}
     9b8:	6422                	ld	s0,8(sp)
     9ba:	0141                	addi	sp,sp,16
     9bc:	8082                	ret

00000000000009be <strcmp>:

int
strcmp(const char *p, const char *q)
{
     9be:	1141                	addi	sp,sp,-16
     9c0:	e422                	sd	s0,8(sp)
     9c2:	0800                	addi	s0,sp,16
  while(*p && *p == *q)
     9c4:	00054783          	lbu	a5,0(a0)
     9c8:	cb91                	beqz	a5,9dc <strcmp+0x1e>
     9ca:	0005c703          	lbu	a4,0(a1)
     9ce:	00f71763          	bne	a4,a5,9dc <strcmp+0x1e>
    p++, q++;
     9d2:	0505                	addi	a0,a0,1
     9d4:	0585                	addi	a1,a1,1
  while(*p && *p == *q)
     9d6:	00054783          	lbu	a5,0(a0)
     9da:	fbe5                	bnez	a5,9ca <strcmp+0xc>
  return (uchar)*p - (uchar)*q;
     9dc:	0005c503          	lbu	a0,0(a1)
}
     9e0:	40a7853b          	subw	a0,a5,a0
     9e4:	6422                	ld	s0,8(sp)
     9e6:	0141                	addi	sp,sp,16
     9e8:	8082                	ret

00000000000009ea <strlen>:

uint
strlen(const char *s)
{
     9ea:	1141                	addi	sp,sp,-16
     9ec:	e422                	sd	s0,8(sp)
     9ee:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
     9f0:	00054783          	lbu	a5,0(a0)
     9f4:	cf91                	beqz	a5,a10 <strlen+0x26>
     9f6:	0505                	addi	a0,a0,1
     9f8:	87aa                	mv	a5,a0
     9fa:	4685                	li	a3,1
     9fc:	9e89                	subw	a3,a3,a0
     9fe:	00f6853b          	addw	a0,a3,a5
     a02:	0785                	addi	a5,a5,1
     a04:	fff7c703          	lbu	a4,-1(a5)
     a08:	fb7d                	bnez	a4,9fe <strlen+0x14>
    ;
  return n;
}
     a0a:	6422                	ld	s0,8(sp)
     a0c:	0141                	addi	sp,sp,16
     a0e:	8082                	ret
  for(n = 0; s[n]; n++)
     a10:	4501                	li	a0,0
     a12:	bfe5                	j	a0a <strlen+0x20>

0000000000000a14 <memset>:

void*
memset(void *dst, int c, uint n)
{
     a14:	1141                	addi	sp,sp,-16
     a16:	e422                	sd	s0,8(sp)
     a18:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
     a1a:	ce09                	beqz	a2,a34 <memset+0x20>
     a1c:	87aa                	mv	a5,a0
     a1e:	fff6071b          	addiw	a4,a2,-1
     a22:	1702                	slli	a4,a4,0x20
     a24:	9301                	srli	a4,a4,0x20
     a26:	0705                	addi	a4,a4,1
     a28:	972a                	add	a4,a4,a0
    cdst[i] = c;
     a2a:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
     a2e:	0785                	addi	a5,a5,1
     a30:	fee79de3          	bne	a5,a4,a2a <memset+0x16>
  }
  return dst;
}
     a34:	6422                	ld	s0,8(sp)
     a36:	0141                	addi	sp,sp,16
     a38:	8082                	ret

0000000000000a3a <strchr>:

char*
strchr(const char *s, char c)
{
     a3a:	1141                	addi	sp,sp,-16
     a3c:	e422                	sd	s0,8(sp)
     a3e:	0800                	addi	s0,sp,16
  for(; *s; s++)
     a40:	00054783          	lbu	a5,0(a0)
     a44:	cb99                	beqz	a5,a5a <strchr+0x20>
    if(*s == c)
     a46:	00f58763          	beq	a1,a5,a54 <strchr+0x1a>
  for(; *s; s++)
     a4a:	0505                	addi	a0,a0,1
     a4c:	00054783          	lbu	a5,0(a0)
     a50:	fbfd                	bnez	a5,a46 <strchr+0xc>
      return (char*)s;
  return 0;
     a52:	4501                	li	a0,0
}
     a54:	6422                	ld	s0,8(sp)
     a56:	0141                	addi	sp,sp,16
     a58:	8082                	ret
  return 0;
     a5a:	4501                	li	a0,0
     a5c:	bfe5                	j	a54 <strchr+0x1a>

0000000000000a5e <gets>:

char*
gets(char *buf, int max)
{
     a5e:	711d                	addi	sp,sp,-96
     a60:	ec86                	sd	ra,88(sp)
     a62:	e8a2                	sd	s0,80(sp)
     a64:	e4a6                	sd	s1,72(sp)
     a66:	e0ca                	sd	s2,64(sp)
     a68:	fc4e                	sd	s3,56(sp)
     a6a:	f852                	sd	s4,48(sp)
     a6c:	f456                	sd	s5,40(sp)
     a6e:	f05a                	sd	s6,32(sp)
     a70:	ec5e                	sd	s7,24(sp)
     a72:	1080                	addi	s0,sp,96
     a74:	8baa                	mv	s7,a0
     a76:	8a2e                	mv	s4,a1
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
     a78:	892a                	mv	s2,a0
     a7a:	4481                	li	s1,0
    cc = read(0, &c, 1);
    if(cc < 1)
      break;
    buf[i++] = c;
    if(c == '\n' || c == '\r')
     a7c:	4aa9                	li	s5,10
     a7e:	4b35                	li	s6,13
  for(i=0; i+1 < max; ){
     a80:	89a6                	mv	s3,s1
     a82:	2485                	addiw	s1,s1,1
     a84:	0344d863          	bge	s1,s4,ab4 <gets+0x56>
    cc = read(0, &c, 1);
     a88:	4605                	li	a2,1
     a8a:	faf40593          	addi	a1,s0,-81
     a8e:	4501                	li	a0,0
     a90:	00000097          	auipc	ra,0x0
     a94:	1a0080e7          	jalr	416(ra) # c30 <read>
    if(cc < 1)
     a98:	00a05e63          	blez	a0,ab4 <gets+0x56>
    buf[i++] = c;
     a9c:	faf44783          	lbu	a5,-81(s0)
     aa0:	00f90023          	sb	a5,0(s2)
    if(c == '\n' || c == '\r')
     aa4:	01578763          	beq	a5,s5,ab2 <gets+0x54>
     aa8:	0905                	addi	s2,s2,1
     aaa:	fd679be3          	bne	a5,s6,a80 <gets+0x22>
  for(i=0; i+1 < max; ){
     aae:	89a6                	mv	s3,s1
     ab0:	a011                	j	ab4 <gets+0x56>
     ab2:	89a6                	mv	s3,s1
      break;
  }
  buf[i] = '\0';
     ab4:	99de                	add	s3,s3,s7
     ab6:	00098023          	sb	zero,0(s3)
  return buf;
}
     aba:	855e                	mv	a0,s7
     abc:	60e6                	ld	ra,88(sp)
     abe:	6446                	ld	s0,80(sp)
     ac0:	64a6                	ld	s1,72(sp)
     ac2:	6906                	ld	s2,64(sp)
     ac4:	79e2                	ld	s3,56(sp)
     ac6:	7a42                	ld	s4,48(sp)
     ac8:	7aa2                	ld	s5,40(sp)
     aca:	7b02                	ld	s6,32(sp)
     acc:	6be2                	ld	s7,24(sp)
     ace:	6125                	addi	sp,sp,96
     ad0:	8082                	ret

0000000000000ad2 <stat>:

int
stat(const char *n, struct stat *st)
{
     ad2:	1101                	addi	sp,sp,-32
     ad4:	ec06                	sd	ra,24(sp)
     ad6:	e822                	sd	s0,16(sp)
     ad8:	e426                	sd	s1,8(sp)
     ada:	e04a                	sd	s2,0(sp)
     adc:	1000                	addi	s0,sp,32
     ade:	892e                	mv	s2,a1
  int fd;
  int r;

  fd = open(n, O_RDONLY);
     ae0:	4581                	li	a1,0
     ae2:	00000097          	auipc	ra,0x0
     ae6:	176080e7          	jalr	374(ra) # c58 <open>
  if(fd < 0)
     aea:	02054563          	bltz	a0,b14 <stat+0x42>
     aee:	84aa                	mv	s1,a0
    return -1;
  r = fstat(fd, st);
     af0:	85ca                	mv	a1,s2
     af2:	00000097          	auipc	ra,0x0
     af6:	17e080e7          	jalr	382(ra) # c70 <fstat>
     afa:	892a                	mv	s2,a0
  close(fd);
     afc:	8526                	mv	a0,s1
     afe:	00000097          	auipc	ra,0x0
     b02:	142080e7          	jalr	322(ra) # c40 <close>
  return r;
}
     b06:	854a                	mv	a0,s2
     b08:	60e2                	ld	ra,24(sp)
     b0a:	6442                	ld	s0,16(sp)
     b0c:	64a2                	ld	s1,8(sp)
     b0e:	6902                	ld	s2,0(sp)
     b10:	6105                	addi	sp,sp,32
     b12:	8082                	ret
    return -1;
     b14:	597d                	li	s2,-1
     b16:	bfc5                	j	b06 <stat+0x34>

0000000000000b18 <atoi>:

int
atoi(const char *s)
{
     b18:	1141                	addi	sp,sp,-16
     b1a:	e422                	sd	s0,8(sp)
     b1c:	0800                	addi	s0,sp,16
  int n;

  n = 0;
  while('0' <= *s && *s <= '9')
     b1e:	00054603          	lbu	a2,0(a0)
     b22:	fd06079b          	addiw	a5,a2,-48
     b26:	0ff7f793          	andi	a5,a5,255
     b2a:	4725                	li	a4,9
     b2c:	02f76963          	bltu	a4,a5,b5e <atoi+0x46>
     b30:	86aa                	mv	a3,a0
  n = 0;
     b32:	4501                	li	a0,0
  while('0' <= *s && *s <= '9')
     b34:	45a5                	li	a1,9
    n = n*10 + *s++ - '0';
     b36:	0685                	addi	a3,a3,1
     b38:	0025179b          	slliw	a5,a0,0x2
     b3c:	9fa9                	addw	a5,a5,a0
     b3e:	0017979b          	slliw	a5,a5,0x1
     b42:	9fb1                	addw	a5,a5,a2
     b44:	fd07851b          	addiw	a0,a5,-48
  while('0' <= *s && *s <= '9')
     b48:	0006c603          	lbu	a2,0(a3)
     b4c:	fd06071b          	addiw	a4,a2,-48
     b50:	0ff77713          	andi	a4,a4,255
     b54:	fee5f1e3          	bgeu	a1,a4,b36 <atoi+0x1e>
  return n;
}
     b58:	6422                	ld	s0,8(sp)
     b5a:	0141                	addi	sp,sp,16
     b5c:	8082                	ret
  n = 0;
     b5e:	4501                	li	a0,0
     b60:	bfe5                	j	b58 <atoi+0x40>

0000000000000b62 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
     b62:	1141                	addi	sp,sp,-16
     b64:	e422                	sd	s0,8(sp)
     b66:	0800                	addi	s0,sp,16
  char *dst;
  const char *src;

  dst = vdst;
  src = vsrc;
  if (src > dst) {
     b68:	02b57663          	bgeu	a0,a1,b94 <memmove+0x32>
    while(n-- > 0)
     b6c:	02c05163          	blez	a2,b8e <memmove+0x2c>
     b70:	fff6079b          	addiw	a5,a2,-1
     b74:	1782                	slli	a5,a5,0x20
     b76:	9381                	srli	a5,a5,0x20
     b78:	0785                	addi	a5,a5,1
     b7a:	97aa                	add	a5,a5,a0
  dst = vdst;
     b7c:	872a                	mv	a4,a0
      *dst++ = *src++;
     b7e:	0585                	addi	a1,a1,1
     b80:	0705                	addi	a4,a4,1
     b82:	fff5c683          	lbu	a3,-1(a1)
     b86:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
     b8a:	fee79ae3          	bne	a5,a4,b7e <memmove+0x1c>
    src += n;
    while(n-- > 0)
      *--dst = *--src;
  }
  return vdst;
}
     b8e:	6422                	ld	s0,8(sp)
     b90:	0141                	addi	sp,sp,16
     b92:	8082                	ret
    dst += n;
     b94:	00c50733          	add	a4,a0,a2
    src += n;
     b98:	95b2                	add	a1,a1,a2
    while(n-- > 0)
     b9a:	fec05ae3          	blez	a2,b8e <memmove+0x2c>
     b9e:	fff6079b          	addiw	a5,a2,-1
     ba2:	1782                	slli	a5,a5,0x20
     ba4:	9381                	srli	a5,a5,0x20
     ba6:	fff7c793          	not	a5,a5
     baa:	97ba                	add	a5,a5,a4
      *--dst = *--src;
     bac:	15fd                	addi	a1,a1,-1
     bae:	177d                	addi	a4,a4,-1
     bb0:	0005c683          	lbu	a3,0(a1)
     bb4:	00d70023          	sb	a3,0(a4)
    while(n-- > 0)
     bb8:	fee79ae3          	bne	a5,a4,bac <memmove+0x4a>
     bbc:	bfc9                	j	b8e <memmove+0x2c>

0000000000000bbe <memcmp>:

int
memcmp(const void *s1, const void *s2, uint n)
{
     bbe:	1141                	addi	sp,sp,-16
     bc0:	e422                	sd	s0,8(sp)
     bc2:	0800                	addi	s0,sp,16
  const char *p1 = s1, *p2 = s2;
  while (n-- > 0) {
     bc4:	ca05                	beqz	a2,bf4 <memcmp+0x36>
     bc6:	fff6069b          	addiw	a3,a2,-1
     bca:	1682                	slli	a3,a3,0x20
     bcc:	9281                	srli	a3,a3,0x20
     bce:	0685                	addi	a3,a3,1
     bd0:	96aa                	add	a3,a3,a0
    if (*p1 != *p2) {
     bd2:	00054783          	lbu	a5,0(a0)
     bd6:	0005c703          	lbu	a4,0(a1)
     bda:	00e79863          	bne	a5,a4,bea <memcmp+0x2c>
      return *p1 - *p2;
    }
    p1++;
     bde:	0505                	addi	a0,a0,1
    p2++;
     be0:	0585                	addi	a1,a1,1
  while (n-- > 0) {
     be2:	fed518e3          	bne	a0,a3,bd2 <memcmp+0x14>
  }
  return 0;
     be6:	4501                	li	a0,0
     be8:	a019                	j	bee <memcmp+0x30>
      return *p1 - *p2;
     bea:	40e7853b          	subw	a0,a5,a4
}
     bee:	6422                	ld	s0,8(sp)
     bf0:	0141                	addi	sp,sp,16
     bf2:	8082                	ret
  return 0;
     bf4:	4501                	li	a0,0
     bf6:	bfe5                	j	bee <memcmp+0x30>

0000000000000bf8 <memcpy>:

void *
memcpy(void *dst, const void *src, uint n)
{
     bf8:	1141                	addi	sp,sp,-16
     bfa:	e406                	sd	ra,8(sp)
     bfc:	e022                	sd	s0,0(sp)
     bfe:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
     c00:	00000097          	auipc	ra,0x0
     c04:	f62080e7          	jalr	-158(ra) # b62 <memmove>
}
     c08:	60a2                	ld	ra,8(sp)
     c0a:	6402                	ld	s0,0(sp)
     c0c:	0141                	addi	sp,sp,16
     c0e:	8082                	ret

0000000000000c10 <fork>:
# generated by usys.pl - do not edit
#include "kernel/syscall.h"
.global fork
fork:
 li a7, SYS_fork
     c10:	4885                	li	a7,1
 ecall
     c12:	00000073          	ecall
 ret
     c16:	8082                	ret

0000000000000c18 <exit>:
.global exit
exit:
 li a7, SYS_exit
     c18:	4889                	li	a7,2
 ecall
     c1a:	00000073          	ecall
 ret
     c1e:	8082                	ret

0000000000000c20 <wait>:
.global wait
wait:
 li a7, SYS_wait
     c20:	488d                	li	a7,3
 ecall
     c22:	00000073          	ecall
 ret
     c26:	8082                	ret

0000000000000c28 <pipe>:
.global pipe
pipe:
 li a7, SYS_pipe
     c28:	4891                	li	a7,4
 ecall
     c2a:	00000073          	ecall
 ret
     c2e:	8082                	ret

0000000000000c30 <read>:
.global read
read:
 li a7, SYS_read
     c30:	4895                	li	a7,5
 ecall
     c32:	00000073          	ecall
 ret
     c36:	8082                	ret

0000000000000c38 <write>:
.global write
write:
 li a7, SYS_write
     c38:	48c1                	li	a7,16
 ecall
     c3a:	00000073          	ecall
 ret
     c3e:	8082                	ret

0000000000000c40 <close>:
.global close
close:
 li a7, SYS_close
     c40:	48d5                	li	a7,21
 ecall
     c42:	00000073          	ecall
 ret
     c46:	8082                	ret

0000000000000c48 <kill>:
.global kill
kill:
 li a7, SYS_kill
     c48:	4899                	li	a7,6
 ecall
     c4a:	00000073          	ecall
 ret
     c4e:	8082                	ret

0000000000000c50 <exec>:
.global exec
exec:
 li a7, SYS_exec
     c50:	489d                	li	a7,7
 ecall
     c52:	00000073          	ecall
 ret
     c56:	8082                	ret

0000000000000c58 <open>:
.global open
open:
 li a7, SYS_open
     c58:	48bd                	li	a7,15
 ecall
     c5a:	00000073          	ecall
 ret
     c5e:	8082                	ret

0000000000000c60 <mknod>:
.global mknod
mknod:
 li a7, SYS_mknod
     c60:	48c5                	li	a7,17
 ecall
     c62:	00000073          	ecall
 ret
     c66:	8082                	ret

0000000000000c68 <unlink>:
.global unlink
unlink:
 li a7, SYS_unlink
     c68:	48c9                	li	a7,18
 ecall
     c6a:	00000073          	ecall
 ret
     c6e:	8082                	ret

0000000000000c70 <fstat>:
.global fstat
fstat:
 li a7, SYS_fstat
     c70:	48a1                	li	a7,8
 ecall
     c72:	00000073          	ecall
 ret
     c76:	8082                	ret

0000000000000c78 <link>:
.global link
link:
 li a7, SYS_link
     c78:	48cd                	li	a7,19
 ecall
     c7a:	00000073          	ecall
 ret
     c7e:	8082                	ret

0000000000000c80 <mkdir>:
.global mkdir
mkdir:
 li a7, SYS_mkdir
     c80:	48d1                	li	a7,20
 ecall
     c82:	00000073          	ecall
 ret
     c86:	8082                	ret

0000000000000c88 <chdir>:
.global chdir
chdir:
 li a7, SYS_chdir
     c88:	48a5                	li	a7,9
 ecall
     c8a:	00000073          	ecall
 ret
     c8e:	8082                	ret

0000000000000c90 <dup>:
.global dup
dup:
 li a7, SYS_dup
     c90:	48a9                	li	a7,10
 ecall
     c92:	00000073          	ecall
 ret
     c96:	8082                	ret

0000000000000c98 <getpid>:
.global getpid
getpid:
 li a7, SYS_getpid
     c98:	48ad                	li	a7,11
 ecall
     c9a:	00000073          	ecall
 ret
     c9e:	8082                	ret

0000000000000ca0 <sbrk>:
.global sbrk
sbrk:
 li a7, SYS_sbrk
     ca0:	48b1                	li	a7,12
 ecall
     ca2:	00000073          	ecall
 ret
     ca6:	8082                	ret

0000000000000ca8 <sleep>:
.global sleep
sleep:
 li a7, SYS_sleep
     ca8:	48b5                	li	a7,13
 ecall
     caa:	00000073          	ecall
 ret
     cae:	8082                	ret

0000000000000cb0 <uptime>:
.global uptime
uptime:
 li a7, SYS_uptime
     cb0:	48b9                	li	a7,14
 ecall
     cb2:	00000073          	ecall
 ret
     cb6:	8082                	ret

0000000000000cb8 <mmap>:
.global mmap
mmap:
 li a7, SYS_mmap
     cb8:	48d9                	li	a7,22
 ecall
     cba:	00000073          	ecall
 ret
     cbe:	8082                	ret

0000000000000cc0 <munmap>:
.global munmap
munmap:
 li a7, SYS_munmap
     cc0:	48dd                	li	a7,23
 ecall
     cc2:	00000073          	ecall
 ret
     cc6:	8082                	ret

0000000000000cc8 <putc>:

static char digits[] = "0123456789ABCDEF";

static void
putc(int fd, char c)
{
     cc8:	1101                	addi	sp,sp,-32
     cca:	ec06                	sd	ra,24(sp)
     ccc:	e822                	sd	s0,16(sp)
     cce:	1000                	addi	s0,sp,32
     cd0:	feb407a3          	sb	a1,-17(s0)
  write(fd, &c, 1);
     cd4:	4605                	li	a2,1
     cd6:	fef40593          	addi	a1,s0,-17
     cda:	00000097          	auipc	ra,0x0
     cde:	f5e080e7          	jalr	-162(ra) # c38 <write>
}
     ce2:	60e2                	ld	ra,24(sp)
     ce4:	6442                	ld	s0,16(sp)
     ce6:	6105                	addi	sp,sp,32
     ce8:	8082                	ret

0000000000000cea <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
     cea:	7139                	addi	sp,sp,-64
     cec:	fc06                	sd	ra,56(sp)
     cee:	f822                	sd	s0,48(sp)
     cf0:	f426                	sd	s1,40(sp)
     cf2:	f04a                	sd	s2,32(sp)
     cf4:	ec4e                	sd	s3,24(sp)
     cf6:	0080                	addi	s0,sp,64
     cf8:	84aa                	mv	s1,a0
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
     cfa:	c299                	beqz	a3,d00 <printint+0x16>
     cfc:	0805c863          	bltz	a1,d8c <printint+0xa2>
    neg = 1;
    x = -xx;
  } else {
    x = xx;
     d00:	2581                	sext.w	a1,a1
  neg = 0;
     d02:	4881                	li	a7,0
     d04:	fc040693          	addi	a3,s0,-64
  }

  i = 0;
     d08:	4701                	li	a4,0
  do{
    buf[i++] = digits[x % base];
     d0a:	2601                	sext.w	a2,a2
     d0c:	00001517          	auipc	a0,0x1
     d10:	9dc50513          	addi	a0,a0,-1572 # 16e8 <digits>
     d14:	883a                	mv	a6,a4
     d16:	2705                	addiw	a4,a4,1
     d18:	02c5f7bb          	remuw	a5,a1,a2
     d1c:	1782                	slli	a5,a5,0x20
     d1e:	9381                	srli	a5,a5,0x20
     d20:	97aa                	add	a5,a5,a0
     d22:	0007c783          	lbu	a5,0(a5)
     d26:	00f68023          	sb	a5,0(a3)
  }while((x /= base) != 0);
     d2a:	0005879b          	sext.w	a5,a1
     d2e:	02c5d5bb          	divuw	a1,a1,a2
     d32:	0685                	addi	a3,a3,1
     d34:	fec7f0e3          	bgeu	a5,a2,d14 <printint+0x2a>
  if(neg)
     d38:	00088b63          	beqz	a7,d4e <printint+0x64>
    buf[i++] = '-';
     d3c:	fd040793          	addi	a5,s0,-48
     d40:	973e                	add	a4,a4,a5
     d42:	02d00793          	li	a5,45
     d46:	fef70823          	sb	a5,-16(a4)
     d4a:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
     d4e:	02e05863          	blez	a4,d7e <printint+0x94>
     d52:	fc040793          	addi	a5,s0,-64
     d56:	00e78933          	add	s2,a5,a4
     d5a:	fff78993          	addi	s3,a5,-1
     d5e:	99ba                	add	s3,s3,a4
     d60:	377d                	addiw	a4,a4,-1
     d62:	1702                	slli	a4,a4,0x20
     d64:	9301                	srli	a4,a4,0x20
     d66:	40e989b3          	sub	s3,s3,a4
    putc(fd, buf[i]);
     d6a:	fff94583          	lbu	a1,-1(s2)
     d6e:	8526                	mv	a0,s1
     d70:	00000097          	auipc	ra,0x0
     d74:	f58080e7          	jalr	-168(ra) # cc8 <putc>
  while(--i >= 0)
     d78:	197d                	addi	s2,s2,-1
     d7a:	ff3918e3          	bne	s2,s3,d6a <printint+0x80>
}
     d7e:	70e2                	ld	ra,56(sp)
     d80:	7442                	ld	s0,48(sp)
     d82:	74a2                	ld	s1,40(sp)
     d84:	7902                	ld	s2,32(sp)
     d86:	69e2                	ld	s3,24(sp)
     d88:	6121                	addi	sp,sp,64
     d8a:	8082                	ret
    x = -xx;
     d8c:	40b005bb          	negw	a1,a1
    neg = 1;
     d90:	4885                	li	a7,1
    x = -xx;
     d92:	bf8d                	j	d04 <printint+0x1a>

0000000000000d94 <vprintf>:
}

// Print to the given fd. Only understands %d, %x, %p, %s.
void
vprintf(int fd, const char *fmt, va_list ap)
{
     d94:	7119                	addi	sp,sp,-128
     d96:	fc86                	sd	ra,120(sp)
     d98:	f8a2                	sd	s0,112(sp)
     d9a:	f4a6                	sd	s1,104(sp)
     d9c:	f0ca                	sd	s2,96(sp)
     d9e:	ecce                	sd	s3,88(sp)
     da0:	e8d2                	sd	s4,80(sp)
     da2:	e4d6                	sd	s5,72(sp)
     da4:	e0da                	sd	s6,64(sp)
     da6:	fc5e                	sd	s7,56(sp)
     da8:	f862                	sd	s8,48(sp)
     daa:	f466                	sd	s9,40(sp)
     dac:	f06a                	sd	s10,32(sp)
     dae:	ec6e                	sd	s11,24(sp)
     db0:	0100                	addi	s0,sp,128
  char *s;
  int c, i, state;

  state = 0;
  for(i = 0; fmt[i]; i++){
     db2:	0005c903          	lbu	s2,0(a1)
     db6:	18090f63          	beqz	s2,f54 <vprintf+0x1c0>
     dba:	8aaa                	mv	s5,a0
     dbc:	8b32                	mv	s6,a2
     dbe:	00158493          	addi	s1,a1,1
  state = 0;
     dc2:	4981                	li	s3,0
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
      }
    } else if(state == '%'){
     dc4:	02500a13          	li	s4,37
      if(c == 'd'){
     dc8:	06400c13          	li	s8,100
        printint(fd, va_arg(ap, int), 10, 1);
      } else if(c == 'l') {
     dcc:	06c00c93          	li	s9,108
        printint(fd, va_arg(ap, uint64), 10, 0);
      } else if(c == 'x') {
     dd0:	07800d13          	li	s10,120
        printint(fd, va_arg(ap, int), 16, 0);
      } else if(c == 'p') {
     dd4:	07000d93          	li	s11,112
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     dd8:	00001b97          	auipc	s7,0x1
     ddc:	910b8b93          	addi	s7,s7,-1776 # 16e8 <digits>
     de0:	a839                	j	dfe <vprintf+0x6a>
        putc(fd, c);
     de2:	85ca                	mv	a1,s2
     de4:	8556                	mv	a0,s5
     de6:	00000097          	auipc	ra,0x0
     dea:	ee2080e7          	jalr	-286(ra) # cc8 <putc>
     dee:	a019                	j	df4 <vprintf+0x60>
    } else if(state == '%'){
     df0:	01498f63          	beq	s3,s4,e0e <vprintf+0x7a>
  for(i = 0; fmt[i]; i++){
     df4:	0485                	addi	s1,s1,1
     df6:	fff4c903          	lbu	s2,-1(s1)
     dfa:	14090d63          	beqz	s2,f54 <vprintf+0x1c0>
    c = fmt[i] & 0xff;
     dfe:	0009079b          	sext.w	a5,s2
    if(state == 0){
     e02:	fe0997e3          	bnez	s3,df0 <vprintf+0x5c>
      if(c == '%'){
     e06:	fd479ee3          	bne	a5,s4,de2 <vprintf+0x4e>
        state = '%';
     e0a:	89be                	mv	s3,a5
     e0c:	b7e5                	j	df4 <vprintf+0x60>
      if(c == 'd'){
     e0e:	05878063          	beq	a5,s8,e4e <vprintf+0xba>
      } else if(c == 'l') {
     e12:	05978c63          	beq	a5,s9,e6a <vprintf+0xd6>
      } else if(c == 'x') {
     e16:	07a78863          	beq	a5,s10,e86 <vprintf+0xf2>
      } else if(c == 'p') {
     e1a:	09b78463          	beq	a5,s11,ea2 <vprintf+0x10e>
        printptr(fd, va_arg(ap, uint64));
      } else if(c == 's'){
     e1e:	07300713          	li	a4,115
     e22:	0ce78663          	beq	a5,a4,eee <vprintf+0x15a>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
     e26:	06300713          	li	a4,99
     e2a:	0ee78e63          	beq	a5,a4,f26 <vprintf+0x192>
        putc(fd, va_arg(ap, uint));
      } else if(c == '%'){
     e2e:	11478863          	beq	a5,s4,f3e <vprintf+0x1aa>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
     e32:	85d2                	mv	a1,s4
     e34:	8556                	mv	a0,s5
     e36:	00000097          	auipc	ra,0x0
     e3a:	e92080e7          	jalr	-366(ra) # cc8 <putc>
        putc(fd, c);
     e3e:	85ca                	mv	a1,s2
     e40:	8556                	mv	a0,s5
     e42:	00000097          	auipc	ra,0x0
     e46:	e86080e7          	jalr	-378(ra) # cc8 <putc>
      }
      state = 0;
     e4a:	4981                	li	s3,0
     e4c:	b765                	j	df4 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 10, 1);
     e4e:	008b0913          	addi	s2,s6,8
     e52:	4685                	li	a3,1
     e54:	4629                	li	a2,10
     e56:	000b2583          	lw	a1,0(s6)
     e5a:	8556                	mv	a0,s5
     e5c:	00000097          	auipc	ra,0x0
     e60:	e8e080e7          	jalr	-370(ra) # cea <printint>
     e64:	8b4a                	mv	s6,s2
      state = 0;
     e66:	4981                	li	s3,0
     e68:	b771                	j	df4 <vprintf+0x60>
        printint(fd, va_arg(ap, uint64), 10, 0);
     e6a:	008b0913          	addi	s2,s6,8
     e6e:	4681                	li	a3,0
     e70:	4629                	li	a2,10
     e72:	000b2583          	lw	a1,0(s6)
     e76:	8556                	mv	a0,s5
     e78:	00000097          	auipc	ra,0x0
     e7c:	e72080e7          	jalr	-398(ra) # cea <printint>
     e80:	8b4a                	mv	s6,s2
      state = 0;
     e82:	4981                	li	s3,0
     e84:	bf85                	j	df4 <vprintf+0x60>
        printint(fd, va_arg(ap, int), 16, 0);
     e86:	008b0913          	addi	s2,s6,8
     e8a:	4681                	li	a3,0
     e8c:	4641                	li	a2,16
     e8e:	000b2583          	lw	a1,0(s6)
     e92:	8556                	mv	a0,s5
     e94:	00000097          	auipc	ra,0x0
     e98:	e56080e7          	jalr	-426(ra) # cea <printint>
     e9c:	8b4a                	mv	s6,s2
      state = 0;
     e9e:	4981                	li	s3,0
     ea0:	bf91                	j	df4 <vprintf+0x60>
        printptr(fd, va_arg(ap, uint64));
     ea2:	008b0793          	addi	a5,s6,8
     ea6:	f8f43423          	sd	a5,-120(s0)
     eaa:	000b3983          	ld	s3,0(s6)
  putc(fd, '0');
     eae:	03000593          	li	a1,48
     eb2:	8556                	mv	a0,s5
     eb4:	00000097          	auipc	ra,0x0
     eb8:	e14080e7          	jalr	-492(ra) # cc8 <putc>
  putc(fd, 'x');
     ebc:	85ea                	mv	a1,s10
     ebe:	8556                	mv	a0,s5
     ec0:	00000097          	auipc	ra,0x0
     ec4:	e08080e7          	jalr	-504(ra) # cc8 <putc>
     ec8:	4941                	li	s2,16
    putc(fd, digits[x >> (sizeof(uint64) * 8 - 4)]);
     eca:	03c9d793          	srli	a5,s3,0x3c
     ece:	97de                	add	a5,a5,s7
     ed0:	0007c583          	lbu	a1,0(a5)
     ed4:	8556                	mv	a0,s5
     ed6:	00000097          	auipc	ra,0x0
     eda:	df2080e7          	jalr	-526(ra) # cc8 <putc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
     ede:	0992                	slli	s3,s3,0x4
     ee0:	397d                	addiw	s2,s2,-1
     ee2:	fe0914e3          	bnez	s2,eca <vprintf+0x136>
        printptr(fd, va_arg(ap, uint64));
     ee6:	f8843b03          	ld	s6,-120(s0)
      state = 0;
     eea:	4981                	li	s3,0
     eec:	b721                	j	df4 <vprintf+0x60>
        s = va_arg(ap, char*);
     eee:	008b0993          	addi	s3,s6,8
     ef2:	000b3903          	ld	s2,0(s6)
        if(s == 0)
     ef6:	02090163          	beqz	s2,f18 <vprintf+0x184>
        while(*s != 0){
     efa:	00094583          	lbu	a1,0(s2)
     efe:	c9a1                	beqz	a1,f4e <vprintf+0x1ba>
          putc(fd, *s);
     f00:	8556                	mv	a0,s5
     f02:	00000097          	auipc	ra,0x0
     f06:	dc6080e7          	jalr	-570(ra) # cc8 <putc>
          s++;
     f0a:	0905                	addi	s2,s2,1
        while(*s != 0){
     f0c:	00094583          	lbu	a1,0(s2)
     f10:	f9e5                	bnez	a1,f00 <vprintf+0x16c>
        s = va_arg(ap, char*);
     f12:	8b4e                	mv	s6,s3
      state = 0;
     f14:	4981                	li	s3,0
     f16:	bdf9                	j	df4 <vprintf+0x60>
          s = "(null)";
     f18:	00000917          	auipc	s2,0x0
     f1c:	7c890913          	addi	s2,s2,1992 # 16e0 <malloc+0x682>
        while(*s != 0){
     f20:	02800593          	li	a1,40
     f24:	bff1                	j	f00 <vprintf+0x16c>
        putc(fd, va_arg(ap, uint));
     f26:	008b0913          	addi	s2,s6,8
     f2a:	000b4583          	lbu	a1,0(s6)
     f2e:	8556                	mv	a0,s5
     f30:	00000097          	auipc	ra,0x0
     f34:	d98080e7          	jalr	-616(ra) # cc8 <putc>
     f38:	8b4a                	mv	s6,s2
      state = 0;
     f3a:	4981                	li	s3,0
     f3c:	bd65                	j	df4 <vprintf+0x60>
        putc(fd, c);
     f3e:	85d2                	mv	a1,s4
     f40:	8556                	mv	a0,s5
     f42:	00000097          	auipc	ra,0x0
     f46:	d86080e7          	jalr	-634(ra) # cc8 <putc>
      state = 0;
     f4a:	4981                	li	s3,0
     f4c:	b565                	j	df4 <vprintf+0x60>
        s = va_arg(ap, char*);
     f4e:	8b4e                	mv	s6,s3
      state = 0;
     f50:	4981                	li	s3,0
     f52:	b54d                	j	df4 <vprintf+0x60>
    }
  }
}
     f54:	70e6                	ld	ra,120(sp)
     f56:	7446                	ld	s0,112(sp)
     f58:	74a6                	ld	s1,104(sp)
     f5a:	7906                	ld	s2,96(sp)
     f5c:	69e6                	ld	s3,88(sp)
     f5e:	6a46                	ld	s4,80(sp)
     f60:	6aa6                	ld	s5,72(sp)
     f62:	6b06                	ld	s6,64(sp)
     f64:	7be2                	ld	s7,56(sp)
     f66:	7c42                	ld	s8,48(sp)
     f68:	7ca2                	ld	s9,40(sp)
     f6a:	7d02                	ld	s10,32(sp)
     f6c:	6de2                	ld	s11,24(sp)
     f6e:	6109                	addi	sp,sp,128
     f70:	8082                	ret

0000000000000f72 <fprintf>:

void
fprintf(int fd, const char *fmt, ...)
{
     f72:	715d                	addi	sp,sp,-80
     f74:	ec06                	sd	ra,24(sp)
     f76:	e822                	sd	s0,16(sp)
     f78:	1000                	addi	s0,sp,32
     f7a:	e010                	sd	a2,0(s0)
     f7c:	e414                	sd	a3,8(s0)
     f7e:	e818                	sd	a4,16(s0)
     f80:	ec1c                	sd	a5,24(s0)
     f82:	03043023          	sd	a6,32(s0)
     f86:	03143423          	sd	a7,40(s0)
  va_list ap;

  va_start(ap, fmt);
     f8a:	fe843423          	sd	s0,-24(s0)
  vprintf(fd, fmt, ap);
     f8e:	8622                	mv	a2,s0
     f90:	00000097          	auipc	ra,0x0
     f94:	e04080e7          	jalr	-508(ra) # d94 <vprintf>
}
     f98:	60e2                	ld	ra,24(sp)
     f9a:	6442                	ld	s0,16(sp)
     f9c:	6161                	addi	sp,sp,80
     f9e:	8082                	ret

0000000000000fa0 <printf>:

void
printf(const char *fmt, ...)
{
     fa0:	711d                	addi	sp,sp,-96
     fa2:	ec06                	sd	ra,24(sp)
     fa4:	e822                	sd	s0,16(sp)
     fa6:	1000                	addi	s0,sp,32
     fa8:	e40c                	sd	a1,8(s0)
     faa:	e810                	sd	a2,16(s0)
     fac:	ec14                	sd	a3,24(s0)
     fae:	f018                	sd	a4,32(s0)
     fb0:	f41c                	sd	a5,40(s0)
     fb2:	03043823          	sd	a6,48(s0)
     fb6:	03143c23          	sd	a7,56(s0)
  va_list ap;

  va_start(ap, fmt);
     fba:	00840613          	addi	a2,s0,8
     fbe:	fec43423          	sd	a2,-24(s0)
  vprintf(1, fmt, ap);
     fc2:	85aa                	mv	a1,a0
     fc4:	4505                	li	a0,1
     fc6:	00000097          	auipc	ra,0x0
     fca:	dce080e7          	jalr	-562(ra) # d94 <vprintf>
}
     fce:	60e2                	ld	ra,24(sp)
     fd0:	6442                	ld	s0,16(sp)
     fd2:	6125                	addi	sp,sp,96
     fd4:	8082                	ret

0000000000000fd6 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
     fd6:	1141                	addi	sp,sp,-16
     fd8:	e422                	sd	s0,8(sp)
     fda:	0800                	addi	s0,sp,16
  Header *bp, *p;

  bp = (Header*)ap - 1;
     fdc:	ff050693          	addi	a3,a0,-16
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
     fe0:	00001797          	auipc	a5,0x1
     fe4:	0307b783          	ld	a5,48(a5) # 2010 <freep>
     fe8:	a805                	j	1018 <free+0x42>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
      break;
  if(bp + bp->s.size == p->s.ptr){
    bp->s.size += p->s.ptr->s.size;
     fea:	4618                	lw	a4,8(a2)
     fec:	9db9                	addw	a1,a1,a4
     fee:	feb52c23          	sw	a1,-8(a0)
    bp->s.ptr = p->s.ptr->s.ptr;
     ff2:	6398                	ld	a4,0(a5)
     ff4:	6318                	ld	a4,0(a4)
     ff6:	fee53823          	sd	a4,-16(a0)
     ffa:	a091                	j	103e <free+0x68>
  } else
    bp->s.ptr = p->s.ptr;
  if(p + p->s.size == bp){
    p->s.size += bp->s.size;
     ffc:	ff852703          	lw	a4,-8(a0)
    1000:	9e39                	addw	a2,a2,a4
    1002:	c790                	sw	a2,8(a5)
    p->s.ptr = bp->s.ptr;
    1004:	ff053703          	ld	a4,-16(a0)
    1008:	e398                	sd	a4,0(a5)
    100a:	a099                	j	1050 <free+0x7a>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    100c:	6398                	ld	a4,0(a5)
    100e:	00e7e463          	bltu	a5,a4,1016 <free+0x40>
    1012:	00e6ea63          	bltu	a3,a4,1026 <free+0x50>
{
    1016:	87ba                	mv	a5,a4
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
    1018:	fed7fae3          	bgeu	a5,a3,100c <free+0x36>
    101c:	6398                	ld	a4,0(a5)
    101e:	00e6e463          	bltu	a3,a4,1026 <free+0x50>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
    1022:	fee7eae3          	bltu	a5,a4,1016 <free+0x40>
  if(bp + bp->s.size == p->s.ptr){
    1026:	ff852583          	lw	a1,-8(a0)
    102a:	6390                	ld	a2,0(a5)
    102c:	02059713          	slli	a4,a1,0x20
    1030:	9301                	srli	a4,a4,0x20
    1032:	0712                	slli	a4,a4,0x4
    1034:	9736                	add	a4,a4,a3
    1036:	fae60ae3          	beq	a2,a4,fea <free+0x14>
    bp->s.ptr = p->s.ptr;
    103a:	fec53823          	sd	a2,-16(a0)
  if(p + p->s.size == bp){
    103e:	4790                	lw	a2,8(a5)
    1040:	02061713          	slli	a4,a2,0x20
    1044:	9301                	srli	a4,a4,0x20
    1046:	0712                	slli	a4,a4,0x4
    1048:	973e                	add	a4,a4,a5
    104a:	fae689e3          	beq	a3,a4,ffc <free+0x26>
  } else
    p->s.ptr = bp;
    104e:	e394                	sd	a3,0(a5)
  freep = p;
    1050:	00001717          	auipc	a4,0x1
    1054:	fcf73023          	sd	a5,-64(a4) # 2010 <freep>
}
    1058:	6422                	ld	s0,8(sp)
    105a:	0141                	addi	sp,sp,16
    105c:	8082                	ret

000000000000105e <malloc>:
  return freep;
}

void*
malloc(uint nbytes)
{
    105e:	7139                	addi	sp,sp,-64
    1060:	fc06                	sd	ra,56(sp)
    1062:	f822                	sd	s0,48(sp)
    1064:	f426                	sd	s1,40(sp)
    1066:	f04a                	sd	s2,32(sp)
    1068:	ec4e                	sd	s3,24(sp)
    106a:	e852                	sd	s4,16(sp)
    106c:	e456                	sd	s5,8(sp)
    106e:	e05a                	sd	s6,0(sp)
    1070:	0080                	addi	s0,sp,64
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
    1072:	02051493          	slli	s1,a0,0x20
    1076:	9081                	srli	s1,s1,0x20
    1078:	04bd                	addi	s1,s1,15
    107a:	8091                	srli	s1,s1,0x4
    107c:	0014899b          	addiw	s3,s1,1
    1080:	0485                	addi	s1,s1,1
  if((prevp = freep) == 0){
    1082:	00001517          	auipc	a0,0x1
    1086:	f8e53503          	ld	a0,-114(a0) # 2010 <freep>
    108a:	c515                	beqz	a0,10b6 <malloc+0x58>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    108c:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    108e:	4798                	lw	a4,8(a5)
    1090:	02977f63          	bgeu	a4,s1,10ce <malloc+0x70>
    1094:	8a4e                	mv	s4,s3
    1096:	0009871b          	sext.w	a4,s3
    109a:	6685                	lui	a3,0x1
    109c:	00d77363          	bgeu	a4,a3,10a2 <malloc+0x44>
    10a0:	6a05                	lui	s4,0x1
    10a2:	000a0b1b          	sext.w	s6,s4
  p = sbrk(nu * sizeof(Header));
    10a6:	004a1a1b          	slliw	s4,s4,0x4
        p->s.size = nunits;
      }
      freep = prevp;
      return (void*)(p + 1);
    }
    if(p == freep)
    10aa:	00001917          	auipc	s2,0x1
    10ae:	f6690913          	addi	s2,s2,-154 # 2010 <freep>
  if(p == (char*)-1)
    10b2:	5afd                	li	s5,-1
    10b4:	a88d                	j	1126 <malloc+0xc8>
    base.s.ptr = freep = prevp = &base;
    10b6:	00001797          	auipc	a5,0x1
    10ba:	36a78793          	addi	a5,a5,874 # 2420 <base>
    10be:	00001717          	auipc	a4,0x1
    10c2:	f4f73923          	sd	a5,-174(a4) # 2010 <freep>
    10c6:	e39c                	sd	a5,0(a5)
    base.s.size = 0;
    10c8:	0007a423          	sw	zero,8(a5)
    if(p->s.size >= nunits){
    10cc:	b7e1                	j	1094 <malloc+0x36>
      if(p->s.size == nunits)
    10ce:	02e48b63          	beq	s1,a4,1104 <malloc+0xa6>
        p->s.size -= nunits;
    10d2:	4137073b          	subw	a4,a4,s3
    10d6:	c798                	sw	a4,8(a5)
        p += p->s.size;
    10d8:	1702                	slli	a4,a4,0x20
    10da:	9301                	srli	a4,a4,0x20
    10dc:	0712                	slli	a4,a4,0x4
    10de:	97ba                	add	a5,a5,a4
        p->s.size = nunits;
    10e0:	0137a423          	sw	s3,8(a5)
      freep = prevp;
    10e4:	00001717          	auipc	a4,0x1
    10e8:	f2a73623          	sd	a0,-212(a4) # 2010 <freep>
      return (void*)(p + 1);
    10ec:	01078513          	addi	a0,a5,16
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
    10f0:	70e2                	ld	ra,56(sp)
    10f2:	7442                	ld	s0,48(sp)
    10f4:	74a2                	ld	s1,40(sp)
    10f6:	7902                	ld	s2,32(sp)
    10f8:	69e2                	ld	s3,24(sp)
    10fa:	6a42                	ld	s4,16(sp)
    10fc:	6aa2                	ld	s5,8(sp)
    10fe:	6b02                	ld	s6,0(sp)
    1100:	6121                	addi	sp,sp,64
    1102:	8082                	ret
        prevp->s.ptr = p->s.ptr;
    1104:	6398                	ld	a4,0(a5)
    1106:	e118                	sd	a4,0(a0)
    1108:	bff1                	j	10e4 <malloc+0x86>
  hp->s.size = nu;
    110a:	01652423          	sw	s6,8(a0)
  free((void*)(hp + 1));
    110e:	0541                	addi	a0,a0,16
    1110:	00000097          	auipc	ra,0x0
    1114:	ec6080e7          	jalr	-314(ra) # fd6 <free>
  return freep;
    1118:	00093503          	ld	a0,0(s2)
      if((p = morecore(nunits)) == 0)
    111c:	d971                	beqz	a0,10f0 <malloc+0x92>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
    111e:	611c                	ld	a5,0(a0)
    if(p->s.size >= nunits){
    1120:	4798                	lw	a4,8(a5)
    1122:	fa9776e3          	bgeu	a4,s1,10ce <malloc+0x70>
    if(p == freep)
    1126:	00093703          	ld	a4,0(s2)
    112a:	853e                	mv	a0,a5
    112c:	fef719e3          	bne	a4,a5,111e <malloc+0xc0>
  p = sbrk(nu * sizeof(Header));
    1130:	8552                	mv	a0,s4
    1132:	00000097          	auipc	ra,0x0
    1136:	b6e080e7          	jalr	-1170(ra) # ca0 <sbrk>
  if(p == (char*)-1)
    113a:	fd5518e3          	bne	a0,s5,110a <malloc+0xac>
        return 0;
    113e:	4501                	li	a0,0
    1140:	bf45                	j	10f0 <malloc+0x92>
