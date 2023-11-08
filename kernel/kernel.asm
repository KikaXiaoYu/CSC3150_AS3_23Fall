
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	b1013103          	ld	sp,-1264(sp) # 80008b10 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	3b7050ef          	jal	ra,80005bcc <start>

000000008000001a <spin>:
    8000001a:	a001                	j	8000001a <spin>

000000008000001c <kfree>:
// which normally should have been returned by a
// call to kalloc().  (The exception is when
// initializing the allocator; see kinit above.)
void
kfree(void *pa)
{
    8000001c:	1101                	addi	sp,sp,-32
    8000001e:	ec06                	sd	ra,24(sp)
    80000020:	e822                	sd	s0,16(sp)
    80000022:	e426                	sd	s1,8(sp)
    80000024:	e04a                	sd	s2,0(sp)
    80000026:	1000                	addi	s0,sp,32
  struct run *r;

  if(((uint64)pa % PGSIZE) != 0 || (char*)pa < end || (uint64)pa >= PHYSTOP)
    80000028:	03451793          	slli	a5,a0,0x34
    8000002c:	ebb9                	bnez	a5,80000082 <kfree+0x66>
    8000002e:	84aa                	mv	s1,a0
    80000030:	00034797          	auipc	a5,0x34
    80000034:	fa078793          	addi	a5,a5,-96 # 80033fd0 <end>
    80000038:	04f56563          	bltu	a0,a5,80000082 <kfree+0x66>
    8000003c:	47c5                	li	a5,17
    8000003e:	07ee                	slli	a5,a5,0x1b
    80000040:	04f57163          	bgeu	a0,a5,80000082 <kfree+0x66>
    panic("kfree");

  // Fill with junk to catch dangling refs.
  memset(pa, 1, PGSIZE);
    80000044:	6605                	lui	a2,0x1
    80000046:	4585                	li	a1,1
    80000048:	00000097          	auipc	ra,0x0
    8000004c:	130080e7          	jalr	304(ra) # 80000178 <memset>

  r = (struct run*)pa;

  acquire(&kmem.lock);
    80000050:	00009917          	auipc	s2,0x9
    80000054:	b1090913          	addi	s2,s2,-1264 # 80008b60 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	572080e7          	jalr	1394(ra) # 800065cc <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	612080e7          	jalr	1554(ra) # 80006680 <release>
}
    80000076:	60e2                	ld	ra,24(sp)
    80000078:	6442                	ld	s0,16(sp)
    8000007a:	64a2                	ld	s1,8(sp)
    8000007c:	6902                	ld	s2,0(sp)
    8000007e:	6105                	addi	sp,sp,32
    80000080:	8082                	ret
    panic("kfree");
    80000082:	00008517          	auipc	a0,0x8
    80000086:	f8e50513          	addi	a0,a0,-114 # 80008010 <etext+0x10>
    8000008a:	00006097          	auipc	ra,0x6
    8000008e:	ff8080e7          	jalr	-8(ra) # 80006082 <panic>

0000000080000092 <freerange>:
{
    80000092:	7179                	addi	sp,sp,-48
    80000094:	f406                	sd	ra,40(sp)
    80000096:	f022                	sd	s0,32(sp)
    80000098:	ec26                	sd	s1,24(sp)
    8000009a:	e84a                	sd	s2,16(sp)
    8000009c:	e44e                	sd	s3,8(sp)
    8000009e:	e052                	sd	s4,0(sp)
    800000a0:	1800                	addi	s0,sp,48
  p = (char*)PGROUNDUP((uint64)pa_start);
    800000a2:	6785                	lui	a5,0x1
    800000a4:	fff78493          	addi	s1,a5,-1 # fff <_entry-0x7ffff001>
    800000a8:	94aa                	add	s1,s1,a0
    800000aa:	757d                	lui	a0,0xfffff
    800000ac:	8ce9                	and	s1,s1,a0
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000ae:	94be                	add	s1,s1,a5
    800000b0:	0095ee63          	bltu	a1,s1,800000cc <freerange+0x3a>
    800000b4:	892e                	mv	s2,a1
    kfree(p);
    800000b6:	7a7d                	lui	s4,0xfffff
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000b8:	6985                	lui	s3,0x1
    kfree(p);
    800000ba:	01448533          	add	a0,s1,s4
    800000be:	00000097          	auipc	ra,0x0
    800000c2:	f5e080e7          	jalr	-162(ra) # 8000001c <kfree>
  for(; p + PGSIZE <= (char*)pa_end; p += PGSIZE)
    800000c6:	94ce                	add	s1,s1,s3
    800000c8:	fe9979e3          	bgeu	s2,s1,800000ba <freerange+0x28>
}
    800000cc:	70a2                	ld	ra,40(sp)
    800000ce:	7402                	ld	s0,32(sp)
    800000d0:	64e2                	ld	s1,24(sp)
    800000d2:	6942                	ld	s2,16(sp)
    800000d4:	69a2                	ld	s3,8(sp)
    800000d6:	6a02                	ld	s4,0(sp)
    800000d8:	6145                	addi	sp,sp,48
    800000da:	8082                	ret

00000000800000dc <kinit>:
{
    800000dc:	1141                	addi	sp,sp,-16
    800000de:	e406                	sd	ra,8(sp)
    800000e0:	e022                	sd	s0,0(sp)
    800000e2:	0800                	addi	s0,sp,16
  initlock(&kmem.lock, "kmem");
    800000e4:	00008597          	auipc	a1,0x8
    800000e8:	f3458593          	addi	a1,a1,-204 # 80008018 <etext+0x18>
    800000ec:	00009517          	auipc	a0,0x9
    800000f0:	a7450513          	addi	a0,a0,-1420 # 80008b60 <kmem>
    800000f4:	00006097          	auipc	ra,0x6
    800000f8:	448080e7          	jalr	1096(ra) # 8000653c <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fc:	45c5                	li	a1,17
    800000fe:	05ee                	slli	a1,a1,0x1b
    80000100:	00034517          	auipc	a0,0x34
    80000104:	ed050513          	addi	a0,a0,-304 # 80033fd0 <end>
    80000108:	00000097          	auipc	ra,0x0
    8000010c:	f8a080e7          	jalr	-118(ra) # 80000092 <freerange>
}
    80000110:	60a2                	ld	ra,8(sp)
    80000112:	6402                	ld	s0,0(sp)
    80000114:	0141                	addi	sp,sp,16
    80000116:	8082                	ret

0000000080000118 <kalloc>:
// Allocate one 4096-byte page of physical memory.
// Returns a pointer that the kernel can use.
// Returns 0 if the memory cannot be allocated.
void *
kalloc(void)
{
    80000118:	1101                	addi	sp,sp,-32
    8000011a:	ec06                	sd	ra,24(sp)
    8000011c:	e822                	sd	s0,16(sp)
    8000011e:	e426                	sd	s1,8(sp)
    80000120:	1000                	addi	s0,sp,32
  struct run *r;

  acquire(&kmem.lock);
    80000122:	00009497          	auipc	s1,0x9
    80000126:	a3e48493          	addi	s1,s1,-1474 # 80008b60 <kmem>
    8000012a:	8526                	mv	a0,s1
    8000012c:	00006097          	auipc	ra,0x6
    80000130:	4a0080e7          	jalr	1184(ra) # 800065cc <acquire>
  r = kmem.freelist;
    80000134:	6c84                	ld	s1,24(s1)
  if(r)
    80000136:	c885                	beqz	s1,80000166 <kalloc+0x4e>
    kmem.freelist = r->next;
    80000138:	609c                	ld	a5,0(s1)
    8000013a:	00009517          	auipc	a0,0x9
    8000013e:	a2650513          	addi	a0,a0,-1498 # 80008b60 <kmem>
    80000142:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000144:	00006097          	auipc	ra,0x6
    80000148:	53c080e7          	jalr	1340(ra) # 80006680 <release>

  if(r)
    memset((char*)r, 5, PGSIZE); // fill with junk
    8000014c:	6605                	lui	a2,0x1
    8000014e:	4595                	li	a1,5
    80000150:	8526                	mv	a0,s1
    80000152:	00000097          	auipc	ra,0x0
    80000156:	026080e7          	jalr	38(ra) # 80000178 <memset>
  return (void*)r;
}
    8000015a:	8526                	mv	a0,s1
    8000015c:	60e2                	ld	ra,24(sp)
    8000015e:	6442                	ld	s0,16(sp)
    80000160:	64a2                	ld	s1,8(sp)
    80000162:	6105                	addi	sp,sp,32
    80000164:	8082                	ret
  release(&kmem.lock);
    80000166:	00009517          	auipc	a0,0x9
    8000016a:	9fa50513          	addi	a0,a0,-1542 # 80008b60 <kmem>
    8000016e:	00006097          	auipc	ra,0x6
    80000172:	512080e7          	jalr	1298(ra) # 80006680 <release>
  if(r)
    80000176:	b7d5                	j	8000015a <kalloc+0x42>

0000000080000178 <memset>:
#include "types.h"

void*
memset(void *dst, int c, uint n)
{
    80000178:	1141                	addi	sp,sp,-16
    8000017a:	e422                	sd	s0,8(sp)
    8000017c:	0800                	addi	s0,sp,16
  char *cdst = (char *) dst;
  int i;
  for(i = 0; i < n; i++){
    8000017e:	ce09                	beqz	a2,80000198 <memset+0x20>
    80000180:	87aa                	mv	a5,a0
    80000182:	fff6071b          	addiw	a4,a2,-1
    80000186:	1702                	slli	a4,a4,0x20
    80000188:	9301                	srli	a4,a4,0x20
    8000018a:	0705                	addi	a4,a4,1
    8000018c:	972a                	add	a4,a4,a0
    cdst[i] = c;
    8000018e:	00b78023          	sb	a1,0(a5)
  for(i = 0; i < n; i++){
    80000192:	0785                	addi	a5,a5,1
    80000194:	fee79de3          	bne	a5,a4,8000018e <memset+0x16>
  }
  return dst;
}
    80000198:	6422                	ld	s0,8(sp)
    8000019a:	0141                	addi	sp,sp,16
    8000019c:	8082                	ret

000000008000019e <memcmp>:

int
memcmp(const void *v1, const void *v2, uint n)
{
    8000019e:	1141                	addi	sp,sp,-16
    800001a0:	e422                	sd	s0,8(sp)
    800001a2:	0800                	addi	s0,sp,16
  const uchar *s1, *s2;

  s1 = v1;
  s2 = v2;
  while(n-- > 0){
    800001a4:	ca05                	beqz	a2,800001d4 <memcmp+0x36>
    800001a6:	fff6069b          	addiw	a3,a2,-1
    800001aa:	1682                	slli	a3,a3,0x20
    800001ac:	9281                	srli	a3,a3,0x20
    800001ae:	0685                	addi	a3,a3,1
    800001b0:	96aa                	add	a3,a3,a0
    if(*s1 != *s2)
    800001b2:	00054783          	lbu	a5,0(a0)
    800001b6:	0005c703          	lbu	a4,0(a1)
    800001ba:	00e79863          	bne	a5,a4,800001ca <memcmp+0x2c>
      return *s1 - *s2;
    s1++, s2++;
    800001be:	0505                	addi	a0,a0,1
    800001c0:	0585                	addi	a1,a1,1
  while(n-- > 0){
    800001c2:	fed518e3          	bne	a0,a3,800001b2 <memcmp+0x14>
  }

  return 0;
    800001c6:	4501                	li	a0,0
    800001c8:	a019                	j	800001ce <memcmp+0x30>
      return *s1 - *s2;
    800001ca:	40e7853b          	subw	a0,a5,a4
}
    800001ce:	6422                	ld	s0,8(sp)
    800001d0:	0141                	addi	sp,sp,16
    800001d2:	8082                	ret
  return 0;
    800001d4:	4501                	li	a0,0
    800001d6:	bfe5                	j	800001ce <memcmp+0x30>

00000000800001d8 <memmove>:

void*
memmove(void *dst, const void *src, uint n)
{
    800001d8:	1141                	addi	sp,sp,-16
    800001da:	e422                	sd	s0,8(sp)
    800001dc:	0800                	addi	s0,sp,16
  const char *s;
  char *d;

  if(n == 0)
    800001de:	ca0d                	beqz	a2,80000210 <memmove+0x38>
    return dst;
  
  s = src;
  d = dst;
  if(s < d && s + n > d){
    800001e0:	00a5f963          	bgeu	a1,a0,800001f2 <memmove+0x1a>
    800001e4:	02061693          	slli	a3,a2,0x20
    800001e8:	9281                	srli	a3,a3,0x20
    800001ea:	00d58733          	add	a4,a1,a3
    800001ee:	02e56463          	bltu	a0,a4,80000216 <memmove+0x3e>
    s += n;
    d += n;
    while(n-- > 0)
      *--d = *--s;
  } else
    while(n-- > 0)
    800001f2:	fff6079b          	addiw	a5,a2,-1
    800001f6:	1782                	slli	a5,a5,0x20
    800001f8:	9381                	srli	a5,a5,0x20
    800001fa:	0785                	addi	a5,a5,1
    800001fc:	97ae                	add	a5,a5,a1
    800001fe:	872a                	mv	a4,a0
      *d++ = *s++;
    80000200:	0585                	addi	a1,a1,1
    80000202:	0705                	addi	a4,a4,1
    80000204:	fff5c683          	lbu	a3,-1(a1)
    80000208:	fed70fa3          	sb	a3,-1(a4)
    while(n-- > 0)
    8000020c:	fef59ae3          	bne	a1,a5,80000200 <memmove+0x28>

  return dst;
}
    80000210:	6422                	ld	s0,8(sp)
    80000212:	0141                	addi	sp,sp,16
    80000214:	8082                	ret
    d += n;
    80000216:	96aa                	add	a3,a3,a0
    while(n-- > 0)
    80000218:	fff6079b          	addiw	a5,a2,-1
    8000021c:	1782                	slli	a5,a5,0x20
    8000021e:	9381                	srli	a5,a5,0x20
    80000220:	fff7c793          	not	a5,a5
    80000224:	97ba                	add	a5,a5,a4
      *--d = *--s;
    80000226:	177d                	addi	a4,a4,-1
    80000228:	16fd                	addi	a3,a3,-1
    8000022a:	00074603          	lbu	a2,0(a4)
    8000022e:	00c68023          	sb	a2,0(a3)
    while(n-- > 0)
    80000232:	fef71ae3          	bne	a4,a5,80000226 <memmove+0x4e>
    80000236:	bfe9                	j	80000210 <memmove+0x38>

0000000080000238 <memcpy>:

// memcpy exists to placate GCC.  Use memmove.
void*
memcpy(void *dst, const void *src, uint n)
{
    80000238:	1141                	addi	sp,sp,-16
    8000023a:	e406                	sd	ra,8(sp)
    8000023c:	e022                	sd	s0,0(sp)
    8000023e:	0800                	addi	s0,sp,16
  return memmove(dst, src, n);
    80000240:	00000097          	auipc	ra,0x0
    80000244:	f98080e7          	jalr	-104(ra) # 800001d8 <memmove>
}
    80000248:	60a2                	ld	ra,8(sp)
    8000024a:	6402                	ld	s0,0(sp)
    8000024c:	0141                	addi	sp,sp,16
    8000024e:	8082                	ret

0000000080000250 <strncmp>:

int
strncmp(const char *p, const char *q, uint n)
{
    80000250:	1141                	addi	sp,sp,-16
    80000252:	e422                	sd	s0,8(sp)
    80000254:	0800                	addi	s0,sp,16
  while(n > 0 && *p && *p == *q)
    80000256:	ce11                	beqz	a2,80000272 <strncmp+0x22>
    80000258:	00054783          	lbu	a5,0(a0)
    8000025c:	cf89                	beqz	a5,80000276 <strncmp+0x26>
    8000025e:	0005c703          	lbu	a4,0(a1)
    80000262:	00f71a63          	bne	a4,a5,80000276 <strncmp+0x26>
    n--, p++, q++;
    80000266:	367d                	addiw	a2,a2,-1
    80000268:	0505                	addi	a0,a0,1
    8000026a:	0585                	addi	a1,a1,1
  while(n > 0 && *p && *p == *q)
    8000026c:	f675                	bnez	a2,80000258 <strncmp+0x8>
  if(n == 0)
    return 0;
    8000026e:	4501                	li	a0,0
    80000270:	a809                	j	80000282 <strncmp+0x32>
    80000272:	4501                	li	a0,0
    80000274:	a039                	j	80000282 <strncmp+0x32>
  if(n == 0)
    80000276:	ca09                	beqz	a2,80000288 <strncmp+0x38>
  return (uchar)*p - (uchar)*q;
    80000278:	00054503          	lbu	a0,0(a0)
    8000027c:	0005c783          	lbu	a5,0(a1)
    80000280:	9d1d                	subw	a0,a0,a5
}
    80000282:	6422                	ld	s0,8(sp)
    80000284:	0141                	addi	sp,sp,16
    80000286:	8082                	ret
    return 0;
    80000288:	4501                	li	a0,0
    8000028a:	bfe5                	j	80000282 <strncmp+0x32>

000000008000028c <strncpy>:

char*
strncpy(char *s, const char *t, int n)
{
    8000028c:	1141                	addi	sp,sp,-16
    8000028e:	e422                	sd	s0,8(sp)
    80000290:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  while(n-- > 0 && (*s++ = *t++) != 0)
    80000292:	872a                	mv	a4,a0
    80000294:	8832                	mv	a6,a2
    80000296:	367d                	addiw	a2,a2,-1
    80000298:	01005963          	blez	a6,800002aa <strncpy+0x1e>
    8000029c:	0705                	addi	a4,a4,1
    8000029e:	0005c783          	lbu	a5,0(a1)
    800002a2:	fef70fa3          	sb	a5,-1(a4)
    800002a6:	0585                	addi	a1,a1,1
    800002a8:	f7f5                	bnez	a5,80000294 <strncpy+0x8>
    ;
  while(n-- > 0)
    800002aa:	00c05d63          	blez	a2,800002c4 <strncpy+0x38>
    800002ae:	86ba                	mv	a3,a4
    *s++ = 0;
    800002b0:	0685                	addi	a3,a3,1
    800002b2:	fe068fa3          	sb	zero,-1(a3)
  while(n-- > 0)
    800002b6:	fff6c793          	not	a5,a3
    800002ba:	9fb9                	addw	a5,a5,a4
    800002bc:	010787bb          	addw	a5,a5,a6
    800002c0:	fef048e3          	bgtz	a5,800002b0 <strncpy+0x24>
  return os;
}
    800002c4:	6422                	ld	s0,8(sp)
    800002c6:	0141                	addi	sp,sp,16
    800002c8:	8082                	ret

00000000800002ca <safestrcpy>:

// Like strncpy but guaranteed to NUL-terminate.
char*
safestrcpy(char *s, const char *t, int n)
{
    800002ca:	1141                	addi	sp,sp,-16
    800002cc:	e422                	sd	s0,8(sp)
    800002ce:	0800                	addi	s0,sp,16
  char *os;

  os = s;
  if(n <= 0)
    800002d0:	02c05363          	blez	a2,800002f6 <safestrcpy+0x2c>
    800002d4:	fff6069b          	addiw	a3,a2,-1
    800002d8:	1682                	slli	a3,a3,0x20
    800002da:	9281                	srli	a3,a3,0x20
    800002dc:	96ae                	add	a3,a3,a1
    800002de:	87aa                	mv	a5,a0
    return os;
  while(--n > 0 && (*s++ = *t++) != 0)
    800002e0:	00d58963          	beq	a1,a3,800002f2 <safestrcpy+0x28>
    800002e4:	0585                	addi	a1,a1,1
    800002e6:	0785                	addi	a5,a5,1
    800002e8:	fff5c703          	lbu	a4,-1(a1)
    800002ec:	fee78fa3          	sb	a4,-1(a5)
    800002f0:	fb65                	bnez	a4,800002e0 <safestrcpy+0x16>
    ;
  *s = 0;
    800002f2:	00078023          	sb	zero,0(a5)
  return os;
}
    800002f6:	6422                	ld	s0,8(sp)
    800002f8:	0141                	addi	sp,sp,16
    800002fa:	8082                	ret

00000000800002fc <strlen>:

int
strlen(const char *s)
{
    800002fc:	1141                	addi	sp,sp,-16
    800002fe:	e422                	sd	s0,8(sp)
    80000300:	0800                	addi	s0,sp,16
  int n;

  for(n = 0; s[n]; n++)
    80000302:	00054783          	lbu	a5,0(a0)
    80000306:	cf91                	beqz	a5,80000322 <strlen+0x26>
    80000308:	0505                	addi	a0,a0,1
    8000030a:	87aa                	mv	a5,a0
    8000030c:	4685                	li	a3,1
    8000030e:	9e89                	subw	a3,a3,a0
    80000310:	00f6853b          	addw	a0,a3,a5
    80000314:	0785                	addi	a5,a5,1
    80000316:	fff7c703          	lbu	a4,-1(a5)
    8000031a:	fb7d                	bnez	a4,80000310 <strlen+0x14>
    ;
  return n;
}
    8000031c:	6422                	ld	s0,8(sp)
    8000031e:	0141                	addi	sp,sp,16
    80000320:	8082                	ret
  for(n = 0; s[n]; n++)
    80000322:	4501                	li	a0,0
    80000324:	bfe5                	j	8000031c <strlen+0x20>

0000000080000326 <main>:
volatile static int started = 0;

// start() jumps here in supervisor mode on all CPUs.
void
main()
{
    80000326:	1141                	addi	sp,sp,-16
    80000328:	e406                	sd	ra,8(sp)
    8000032a:	e022                	sd	s0,0(sp)
    8000032c:	0800                	addi	s0,sp,16
  if(cpuid() == 0){
    8000032e:	00001097          	auipc	ra,0x1
    80000332:	b08080e7          	jalr	-1272(ra) # 80000e36 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000336:	00008717          	auipc	a4,0x8
    8000033a:	7fa70713          	addi	a4,a4,2042 # 80008b30 <started>
  if(cpuid() == 0){
    8000033e:	c139                	beqz	a0,80000384 <main+0x5e>
    while(started == 0)
    80000340:	431c                	lw	a5,0(a4)
    80000342:	2781                	sext.w	a5,a5
    80000344:	dff5                	beqz	a5,80000340 <main+0x1a>
      ;
    __sync_synchronize();
    80000346:	0ff0000f          	fence
    printf("hart %d starting\n", cpuid());
    8000034a:	00001097          	auipc	ra,0x1
    8000034e:	aec080e7          	jalr	-1300(ra) # 80000e36 <cpuid>
    80000352:	85aa                	mv	a1,a0
    80000354:	00008517          	auipc	a0,0x8
    80000358:	ce450513          	addi	a0,a0,-796 # 80008038 <etext+0x38>
    8000035c:	00006097          	auipc	ra,0x6
    80000360:	d70080e7          	jalr	-656(ra) # 800060cc <printf>
    kvminithart();    // turn on paging
    80000364:	00000097          	auipc	ra,0x0
    80000368:	0d8080e7          	jalr	216(ra) # 8000043c <kvminithart>
    trapinithart();   // install kernel trap vector
    8000036c:	00001097          	auipc	ra,0x1
    80000370:	78e080e7          	jalr	1934(ra) # 80001afa <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000374:	00005097          	auipc	ra,0x5
    80000378:	1ac080e7          	jalr	428(ra) # 80005520 <plicinithart>
  }

  scheduler();        
    8000037c:	00001097          	auipc	ra,0x1
    80000380:	fd8080e7          	jalr	-40(ra) # 80001354 <scheduler>
    consoleinit();
    80000384:	00006097          	auipc	ra,0x6
    80000388:	c10080e7          	jalr	-1008(ra) # 80005f94 <consoleinit>
    printfinit();
    8000038c:	00006097          	auipc	ra,0x6
    80000390:	f26080e7          	jalr	-218(ra) # 800062b2 <printfinit>
    printf("\n");
    80000394:	00008517          	auipc	a0,0x8
    80000398:	cb450513          	addi	a0,a0,-844 # 80008048 <etext+0x48>
    8000039c:	00006097          	auipc	ra,0x6
    800003a0:	d30080e7          	jalr	-720(ra) # 800060cc <printf>
    printf("xv6 kernel is booting\n");
    800003a4:	00008517          	auipc	a0,0x8
    800003a8:	c7c50513          	addi	a0,a0,-900 # 80008020 <etext+0x20>
    800003ac:	00006097          	auipc	ra,0x6
    800003b0:	d20080e7          	jalr	-736(ra) # 800060cc <printf>
    printf("\n");
    800003b4:	00008517          	auipc	a0,0x8
    800003b8:	c9450513          	addi	a0,a0,-876 # 80008048 <etext+0x48>
    800003bc:	00006097          	auipc	ra,0x6
    800003c0:	d10080e7          	jalr	-752(ra) # 800060cc <printf>
    kinit();         // physical page allocator
    800003c4:	00000097          	auipc	ra,0x0
    800003c8:	d18080e7          	jalr	-744(ra) # 800000dc <kinit>
    kvminit();       // create kernel page table
    800003cc:	00000097          	auipc	ra,0x0
    800003d0:	34a080e7          	jalr	842(ra) # 80000716 <kvminit>
    kvminithart();   // turn on paging
    800003d4:	00000097          	auipc	ra,0x0
    800003d8:	068080e7          	jalr	104(ra) # 8000043c <kvminithart>
    procinit();      // process table
    800003dc:	00001097          	auipc	ra,0x1
    800003e0:	9a6080e7          	jalr	-1626(ra) # 80000d82 <procinit>
    trapinit();      // trap vectors
    800003e4:	00001097          	auipc	ra,0x1
    800003e8:	6ee080e7          	jalr	1774(ra) # 80001ad2 <trapinit>
    trapinithart();  // install kernel trap vector
    800003ec:	00001097          	auipc	ra,0x1
    800003f0:	70e080e7          	jalr	1806(ra) # 80001afa <trapinithart>
    plicinit();      // set up interrupt controller
    800003f4:	00005097          	auipc	ra,0x5
    800003f8:	116080e7          	jalr	278(ra) # 8000550a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003fc:	00005097          	auipc	ra,0x5
    80000400:	124080e7          	jalr	292(ra) # 80005520 <plicinithart>
    binit();         // buffer cache
    80000404:	00002097          	auipc	ra,0x2
    80000408:	f74080e7          	jalr	-140(ra) # 80002378 <binit>
    iinit();         // inode table
    8000040c:	00002097          	auipc	ra,0x2
    80000410:	618080e7          	jalr	1560(ra) # 80002a24 <iinit>
    fileinit();      // file table
    80000414:	00003097          	auipc	ra,0x3
    80000418:	5b6080e7          	jalr	1462(ra) # 800039ca <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000041c:	00005097          	auipc	ra,0x5
    80000420:	20c080e7          	jalr	524(ra) # 80005628 <virtio_disk_init>
    userinit();      // first user process
    80000424:	00001097          	auipc	ra,0x1
    80000428:	d16080e7          	jalr	-746(ra) # 8000113a <userinit>
    __sync_synchronize();
    8000042c:	0ff0000f          	fence
    started = 1;
    80000430:	4785                	li	a5,1
    80000432:	00008717          	auipc	a4,0x8
    80000436:	6ef72f23          	sw	a5,1790(a4) # 80008b30 <started>
    8000043a:	b789                	j	8000037c <main+0x56>

000000008000043c <kvminithart>:
}

// Switch h/w page table register to the kernel's page table,
// and enable paging.
void kvminithart()
{
    8000043c:	1141                	addi	sp,sp,-16
    8000043e:	e422                	sd	s0,8(sp)
    80000440:	0800                	addi	s0,sp,16
// flush the TLB.
static inline void
sfence_vma()
{
  // the zero, zero means flush all TLB entries.
  asm volatile("sfence.vma zero, zero");
    80000442:	12000073          	sfence.vma
    // wait for any previous writes to the page table memory to finish.
    sfence_vma();

    w_satp(MAKE_SATP(kernel_pagetable));
    80000446:	00008797          	auipc	a5,0x8
    8000044a:	6f27b783          	ld	a5,1778(a5) # 80008b38 <kernel_pagetable>
    8000044e:	83b1                	srli	a5,a5,0xc
    80000450:	577d                	li	a4,-1
    80000452:	177e                	slli	a4,a4,0x3f
    80000454:	8fd9                	or	a5,a5,a4
  asm volatile("csrw satp, %0" : : "r" (x));
    80000456:	18079073          	csrw	satp,a5
  asm volatile("sfence.vma zero, zero");
    8000045a:	12000073          	sfence.vma

    // flush stale entries from the TLB.
    sfence_vma();
}
    8000045e:	6422                	ld	s0,8(sp)
    80000460:	0141                	addi	sp,sp,16
    80000462:	8082                	ret

0000000080000464 <walk>:
//   21..29 -- 9 bits of level-1 index.
//   12..20 -- 9 bits of level-0 index.
//    0..11 -- 12 bits of byte offset within the page.
pte_t *
walk(pagetable_t pagetable, uint64 va, int alloc)
{
    80000464:	7139                	addi	sp,sp,-64
    80000466:	fc06                	sd	ra,56(sp)
    80000468:	f822                	sd	s0,48(sp)
    8000046a:	f426                	sd	s1,40(sp)
    8000046c:	f04a                	sd	s2,32(sp)
    8000046e:	ec4e                	sd	s3,24(sp)
    80000470:	e852                	sd	s4,16(sp)
    80000472:	e456                	sd	s5,8(sp)
    80000474:	e05a                	sd	s6,0(sp)
    80000476:	0080                	addi	s0,sp,64
    80000478:	84aa                	mv	s1,a0
    8000047a:	89ae                	mv	s3,a1
    8000047c:	8ab2                	mv	s5,a2
    if (va >= MAXVA)
    8000047e:	57fd                	li	a5,-1
    80000480:	83e9                	srli	a5,a5,0x1a
    80000482:	4a79                	li	s4,30
        panic("walk");

    for (int level = 2; level > 0; level--)
    80000484:	4b31                	li	s6,12
    if (va >= MAXVA)
    80000486:	04b7f263          	bgeu	a5,a1,800004ca <walk+0x66>
        panic("walk");
    8000048a:	00008517          	auipc	a0,0x8
    8000048e:	bc650513          	addi	a0,a0,-1082 # 80008050 <etext+0x50>
    80000492:	00006097          	auipc	ra,0x6
    80000496:	bf0080e7          	jalr	-1040(ra) # 80006082 <panic>
        {
            pagetable = (pagetable_t)PTE2PA(*pte);
        }
        else
        {
            if (!alloc || (pagetable = (pde_t *)kalloc()) == 0)
    8000049a:	060a8663          	beqz	s5,80000506 <walk+0xa2>
    8000049e:	00000097          	auipc	ra,0x0
    800004a2:	c7a080e7          	jalr	-902(ra) # 80000118 <kalloc>
    800004a6:	84aa                	mv	s1,a0
    800004a8:	c529                	beqz	a0,800004f2 <walk+0x8e>
                return 0;
            memset(pagetable, 0, PGSIZE);
    800004aa:	6605                	lui	a2,0x1
    800004ac:	4581                	li	a1,0
    800004ae:	00000097          	auipc	ra,0x0
    800004b2:	cca080e7          	jalr	-822(ra) # 80000178 <memset>
            *pte = PA2PTE(pagetable) | PTE_V;
    800004b6:	00c4d793          	srli	a5,s1,0xc
    800004ba:	07aa                	slli	a5,a5,0xa
    800004bc:	0017e793          	ori	a5,a5,1
    800004c0:	00f93023          	sd	a5,0(s2)
    for (int level = 2; level > 0; level--)
    800004c4:	3a5d                	addiw	s4,s4,-9
    800004c6:	036a0063          	beq	s4,s6,800004e6 <walk+0x82>
        pte_t *pte = &pagetable[PX(level, va)];
    800004ca:	0149d933          	srl	s2,s3,s4
    800004ce:	1ff97913          	andi	s2,s2,511
    800004d2:	090e                	slli	s2,s2,0x3
    800004d4:	9926                	add	s2,s2,s1
        if (*pte & PTE_V)
    800004d6:	00093483          	ld	s1,0(s2)
    800004da:	0014f793          	andi	a5,s1,1
    800004de:	dfd5                	beqz	a5,8000049a <walk+0x36>
            pagetable = (pagetable_t)PTE2PA(*pte);
    800004e0:	80a9                	srli	s1,s1,0xa
    800004e2:	04b2                	slli	s1,s1,0xc
    800004e4:	b7c5                	j	800004c4 <walk+0x60>
        }
    }
    return &pagetable[PX(0, va)];
    800004e6:	00c9d513          	srli	a0,s3,0xc
    800004ea:	1ff57513          	andi	a0,a0,511
    800004ee:	050e                	slli	a0,a0,0x3
    800004f0:	9526                	add	a0,a0,s1
}
    800004f2:	70e2                	ld	ra,56(sp)
    800004f4:	7442                	ld	s0,48(sp)
    800004f6:	74a2                	ld	s1,40(sp)
    800004f8:	7902                	ld	s2,32(sp)
    800004fa:	69e2                	ld	s3,24(sp)
    800004fc:	6a42                	ld	s4,16(sp)
    800004fe:	6aa2                	ld	s5,8(sp)
    80000500:	6b02                	ld	s6,0(sp)
    80000502:	6121                	addi	sp,sp,64
    80000504:	8082                	ret
                return 0;
    80000506:	4501                	li	a0,0
    80000508:	b7ed                	j	800004f2 <walk+0x8e>

000000008000050a <walkaddr>:
walkaddr(pagetable_t pagetable, uint64 va)
{
    pte_t *pte;
    uint64 pa;

    if (va >= MAXVA)
    8000050a:	57fd                	li	a5,-1
    8000050c:	83e9                	srli	a5,a5,0x1a
    8000050e:	00b7f463          	bgeu	a5,a1,80000516 <walkaddr+0xc>
        return 0;
    80000512:	4501                	li	a0,0
        return 0;
    if ((*pte & PTE_U) == 0)
        return 0;
    pa = PTE2PA(*pte);
    return pa;
}
    80000514:	8082                	ret
{
    80000516:	1141                	addi	sp,sp,-16
    80000518:	e406                	sd	ra,8(sp)
    8000051a:	e022                	sd	s0,0(sp)
    8000051c:	0800                	addi	s0,sp,16
    pte = walk(pagetable, va, 0);
    8000051e:	4601                	li	a2,0
    80000520:	00000097          	auipc	ra,0x0
    80000524:	f44080e7          	jalr	-188(ra) # 80000464 <walk>
    if (pte == 0)
    80000528:	c105                	beqz	a0,80000548 <walkaddr+0x3e>
    if ((*pte & PTE_V) == 0)
    8000052a:	611c                	ld	a5,0(a0)
    if ((*pte & PTE_U) == 0)
    8000052c:	0117f693          	andi	a3,a5,17
    80000530:	4745                	li	a4,17
        return 0;
    80000532:	4501                	li	a0,0
    if ((*pte & PTE_U) == 0)
    80000534:	00e68663          	beq	a3,a4,80000540 <walkaddr+0x36>
}
    80000538:	60a2                	ld	ra,8(sp)
    8000053a:	6402                	ld	s0,0(sp)
    8000053c:	0141                	addi	sp,sp,16
    8000053e:	8082                	ret
    pa = PTE2PA(*pte);
    80000540:	00a7d513          	srli	a0,a5,0xa
    80000544:	0532                	slli	a0,a0,0xc
    return pa;
    80000546:	bfcd                	j	80000538 <walkaddr+0x2e>
        return 0;
    80000548:	4501                	li	a0,0
    8000054a:	b7fd                	j	80000538 <walkaddr+0x2e>

000000008000054c <mappages>:
// Create PTEs for virtual addresses starting at va that refer to
// physical addresses starting at pa. va and size might not
// be page-aligned. Returns 0 on success, -1 if walk() couldn't
// allocate a needed page-table page.
int mappages(pagetable_t pagetable, uint64 va, uint64 size, uint64 pa, int perm)
{
    8000054c:	715d                	addi	sp,sp,-80
    8000054e:	e486                	sd	ra,72(sp)
    80000550:	e0a2                	sd	s0,64(sp)
    80000552:	fc26                	sd	s1,56(sp)
    80000554:	f84a                	sd	s2,48(sp)
    80000556:	f44e                	sd	s3,40(sp)
    80000558:	f052                	sd	s4,32(sp)
    8000055a:	ec56                	sd	s5,24(sp)
    8000055c:	e85a                	sd	s6,16(sp)
    8000055e:	e45e                	sd	s7,8(sp)
    80000560:	0880                	addi	s0,sp,80
    uint64 a, last;
    pte_t *pte;

    if (size == 0)
    80000562:	c205                	beqz	a2,80000582 <mappages+0x36>
    80000564:	8aaa                	mv	s5,a0
    80000566:	8b3a                	mv	s6,a4
        panic("mappages: size");

    // printf("[Testing] : size OK\n");
    a = PGROUNDDOWN(va);
    80000568:	77fd                	lui	a5,0xfffff
    8000056a:	00f5fa33          	and	s4,a1,a5
    last = PGROUNDDOWN(va + size - 1);
    8000056e:	15fd                	addi	a1,a1,-1
    80000570:	00c589b3          	add	s3,a1,a2
    80000574:	00f9f9b3          	and	s3,s3,a5
    a = PGROUNDDOWN(va);
    80000578:	8952                	mv	s2,s4
    8000057a:	41468a33          	sub	s4,a3,s4
        *pte = PA2PTE(pa) | perm | PTE_V;

        // printf("[Testing] : new! pte: %d\n", pte);
        if (a == last)
            break;
        a += PGSIZE;
    8000057e:	6b85                	lui	s7,0x1
    80000580:	a0a1                	j	800005c8 <mappages+0x7c>
        panic("mappages: size");
    80000582:	00008517          	auipc	a0,0x8
    80000586:	ad650513          	addi	a0,a0,-1322 # 80008058 <etext+0x58>
    8000058a:	00006097          	auipc	ra,0x6
    8000058e:	af8080e7          	jalr	-1288(ra) # 80006082 <panic>
            printf("[Testing] : pte: %d\n", pte);
    80000592:	85aa                	mv	a1,a0
    80000594:	00008517          	auipc	a0,0x8
    80000598:	ad450513          	addi	a0,a0,-1324 # 80008068 <etext+0x68>
    8000059c:	00006097          	auipc	ra,0x6
    800005a0:	b30080e7          	jalr	-1232(ra) # 800060cc <printf>
            printf("[Testing] : PTE_V: %d\n", PTE_V);
    800005a4:	4585                	li	a1,1
    800005a6:	00008517          	auipc	a0,0x8
    800005aa:	ada50513          	addi	a0,a0,-1318 # 80008080 <etext+0x80>
    800005ae:	00006097          	auipc	ra,0x6
    800005b2:	b1e080e7          	jalr	-1250(ra) # 800060cc <printf>
            panic("mappages: remap");
    800005b6:	00008517          	auipc	a0,0x8
    800005ba:	ae250513          	addi	a0,a0,-1310 # 80008098 <etext+0x98>
    800005be:	00006097          	auipc	ra,0x6
    800005c2:	ac4080e7          	jalr	-1340(ra) # 80006082 <panic>
        a += PGSIZE;
    800005c6:	995e                	add	s2,s2,s7
    for (;;)
    800005c8:	012a04b3          	add	s1,s4,s2
        if ((pte = walk(pagetable, a, 1)) == 0)
    800005cc:	4605                	li	a2,1
    800005ce:	85ca                	mv	a1,s2
    800005d0:	8556                	mv	a0,s5
    800005d2:	00000097          	auipc	ra,0x0
    800005d6:	e92080e7          	jalr	-366(ra) # 80000464 <walk>
    800005da:	cd19                	beqz	a0,800005f8 <mappages+0xac>
        if (*pte & PTE_V)
    800005dc:	611c                	ld	a5,0(a0)
    800005de:	8b85                	andi	a5,a5,1
    800005e0:	fbcd                	bnez	a5,80000592 <mappages+0x46>
        *pte = PA2PTE(pa) | perm | PTE_V;
    800005e2:	80b1                	srli	s1,s1,0xc
    800005e4:	04aa                	slli	s1,s1,0xa
    800005e6:	0164e4b3          	or	s1,s1,s6
    800005ea:	0014e493          	ori	s1,s1,1
    800005ee:	e104                	sd	s1,0(a0)
        if (a == last)
    800005f0:	fd391be3          	bne	s2,s3,800005c6 <mappages+0x7a>
        pa += PGSIZE;
    }
    // printf("[Testing] : return 0\n");
    return 0;
    800005f4:	4501                	li	a0,0
    800005f6:	a011                	j	800005fa <mappages+0xae>
            return -1;
    800005f8:	557d                	li	a0,-1
}
    800005fa:	60a6                	ld	ra,72(sp)
    800005fc:	6406                	ld	s0,64(sp)
    800005fe:	74e2                	ld	s1,56(sp)
    80000600:	7942                	ld	s2,48(sp)
    80000602:	79a2                	ld	s3,40(sp)
    80000604:	7a02                	ld	s4,32(sp)
    80000606:	6ae2                	ld	s5,24(sp)
    80000608:	6b42                	ld	s6,16(sp)
    8000060a:	6ba2                	ld	s7,8(sp)
    8000060c:	6161                	addi	sp,sp,80
    8000060e:	8082                	ret

0000000080000610 <kvmmap>:
{
    80000610:	1141                	addi	sp,sp,-16
    80000612:	e406                	sd	ra,8(sp)
    80000614:	e022                	sd	s0,0(sp)
    80000616:	0800                	addi	s0,sp,16
    80000618:	87b6                	mv	a5,a3
    if (mappages(kpgtbl, va, sz, pa, perm) != 0)
    8000061a:	86b2                	mv	a3,a2
    8000061c:	863e                	mv	a2,a5
    8000061e:	00000097          	auipc	ra,0x0
    80000622:	f2e080e7          	jalr	-210(ra) # 8000054c <mappages>
    80000626:	e509                	bnez	a0,80000630 <kvmmap+0x20>
}
    80000628:	60a2                	ld	ra,8(sp)
    8000062a:	6402                	ld	s0,0(sp)
    8000062c:	0141                	addi	sp,sp,16
    8000062e:	8082                	ret
        panic("kvmmap");
    80000630:	00008517          	auipc	a0,0x8
    80000634:	a7850513          	addi	a0,a0,-1416 # 800080a8 <etext+0xa8>
    80000638:	00006097          	auipc	ra,0x6
    8000063c:	a4a080e7          	jalr	-1462(ra) # 80006082 <panic>

0000000080000640 <kvmmake>:
{
    80000640:	1101                	addi	sp,sp,-32
    80000642:	ec06                	sd	ra,24(sp)
    80000644:	e822                	sd	s0,16(sp)
    80000646:	e426                	sd	s1,8(sp)
    80000648:	e04a                	sd	s2,0(sp)
    8000064a:	1000                	addi	s0,sp,32
    kpgtbl = (pagetable_t)kalloc();
    8000064c:	00000097          	auipc	ra,0x0
    80000650:	acc080e7          	jalr	-1332(ra) # 80000118 <kalloc>
    80000654:	84aa                	mv	s1,a0
    memset(kpgtbl, 0, PGSIZE);
    80000656:	6605                	lui	a2,0x1
    80000658:	4581                	li	a1,0
    8000065a:	00000097          	auipc	ra,0x0
    8000065e:	b1e080e7          	jalr	-1250(ra) # 80000178 <memset>
    kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    80000662:	4719                	li	a4,6
    80000664:	6685                	lui	a3,0x1
    80000666:	10000637          	lui	a2,0x10000
    8000066a:	100005b7          	lui	a1,0x10000
    8000066e:	8526                	mv	a0,s1
    80000670:	00000097          	auipc	ra,0x0
    80000674:	fa0080e7          	jalr	-96(ra) # 80000610 <kvmmap>
    kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80000678:	4719                	li	a4,6
    8000067a:	6685                	lui	a3,0x1
    8000067c:	10001637          	lui	a2,0x10001
    80000680:	100015b7          	lui	a1,0x10001
    80000684:	8526                	mv	a0,s1
    80000686:	00000097          	auipc	ra,0x0
    8000068a:	f8a080e7          	jalr	-118(ra) # 80000610 <kvmmap>
    kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    8000068e:	4719                	li	a4,6
    80000690:	004006b7          	lui	a3,0x400
    80000694:	0c000637          	lui	a2,0xc000
    80000698:	0c0005b7          	lui	a1,0xc000
    8000069c:	8526                	mv	a0,s1
    8000069e:	00000097          	auipc	ra,0x0
    800006a2:	f72080e7          	jalr	-142(ra) # 80000610 <kvmmap>
    kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext - KERNBASE, PTE_R | PTE_X);
    800006a6:	00008917          	auipc	s2,0x8
    800006aa:	95a90913          	addi	s2,s2,-1702 # 80008000 <etext>
    800006ae:	4729                	li	a4,10
    800006b0:	80008697          	auipc	a3,0x80008
    800006b4:	95068693          	addi	a3,a3,-1712 # 8000 <_entry-0x7fff8000>
    800006b8:	4605                	li	a2,1
    800006ba:	067e                	slli	a2,a2,0x1f
    800006bc:	85b2                	mv	a1,a2
    800006be:	8526                	mv	a0,s1
    800006c0:	00000097          	auipc	ra,0x0
    800006c4:	f50080e7          	jalr	-176(ra) # 80000610 <kvmmap>
    kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP - (uint64)etext, PTE_R | PTE_W);
    800006c8:	4719                	li	a4,6
    800006ca:	46c5                	li	a3,17
    800006cc:	06ee                	slli	a3,a3,0x1b
    800006ce:	412686b3          	sub	a3,a3,s2
    800006d2:	864a                	mv	a2,s2
    800006d4:	85ca                	mv	a1,s2
    800006d6:	8526                	mv	a0,s1
    800006d8:	00000097          	auipc	ra,0x0
    800006dc:	f38080e7          	jalr	-200(ra) # 80000610 <kvmmap>
    kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800006e0:	4729                	li	a4,10
    800006e2:	6685                	lui	a3,0x1
    800006e4:	00007617          	auipc	a2,0x7
    800006e8:	91c60613          	addi	a2,a2,-1764 # 80007000 <_trampoline>
    800006ec:	040005b7          	lui	a1,0x4000
    800006f0:	15fd                	addi	a1,a1,-1
    800006f2:	05b2                	slli	a1,a1,0xc
    800006f4:	8526                	mv	a0,s1
    800006f6:	00000097          	auipc	ra,0x0
    800006fa:	f1a080e7          	jalr	-230(ra) # 80000610 <kvmmap>
    proc_mapstacks(kpgtbl);
    800006fe:	8526                	mv	a0,s1
    80000700:	00000097          	auipc	ra,0x0
    80000704:	5ec080e7          	jalr	1516(ra) # 80000cec <proc_mapstacks>
}
    80000708:	8526                	mv	a0,s1
    8000070a:	60e2                	ld	ra,24(sp)
    8000070c:	6442                	ld	s0,16(sp)
    8000070e:	64a2                	ld	s1,8(sp)
    80000710:	6902                	ld	s2,0(sp)
    80000712:	6105                	addi	sp,sp,32
    80000714:	8082                	ret

0000000080000716 <kvminit>:
{
    80000716:	1141                	addi	sp,sp,-16
    80000718:	e406                	sd	ra,8(sp)
    8000071a:	e022                	sd	s0,0(sp)
    8000071c:	0800                	addi	s0,sp,16
    kernel_pagetable = kvmmake();
    8000071e:	00000097          	auipc	ra,0x0
    80000722:	f22080e7          	jalr	-222(ra) # 80000640 <kvmmake>
    80000726:	00008797          	auipc	a5,0x8
    8000072a:	40a7b923          	sd	a0,1042(a5) # 80008b38 <kernel_pagetable>
}
    8000072e:	60a2                	ld	ra,8(sp)
    80000730:	6402                	ld	s0,0(sp)
    80000732:	0141                	addi	sp,sp,16
    80000734:	8082                	ret

0000000080000736 <uvmunmap>:

// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000736:	715d                	addi	sp,sp,-80
    80000738:	e486                	sd	ra,72(sp)
    8000073a:	e0a2                	sd	s0,64(sp)
    8000073c:	fc26                	sd	s1,56(sp)
    8000073e:	f84a                	sd	s2,48(sp)
    80000740:	f44e                	sd	s3,40(sp)
    80000742:	f052                	sd	s4,32(sp)
    80000744:	ec56                	sd	s5,24(sp)
    80000746:	e85a                	sd	s6,16(sp)
    80000748:	e45e                	sd	s7,8(sp)
    8000074a:	0880                	addi	s0,sp,80
    uint64 a;
    pte_t *pte;

    if ((va % PGSIZE) != 0)
    8000074c:	03459793          	slli	a5,a1,0x34
    80000750:	e795                	bnez	a5,8000077c <uvmunmap+0x46>
    80000752:	8a2a                	mv	s4,a0
    80000754:	892e                	mv	s2,a1
    80000756:	8b36                	mv	s6,a3
        panic("uvmunmap: not aligned");

    for (a = va; a < va + npages * PGSIZE; a += PGSIZE)
    80000758:	0632                	slli	a2,a2,0xc
    8000075a:	00b609b3          	add	s3,a2,a1
            // if (do_free == -1)
            continue;
            // else
            //   panic("uvmunmap: not mapped");
        }
        if (PTE_FLAGS(*pte) == PTE_V)
    8000075e:	4b85                	li	s7,1
    for (a = va; a < va + npages * PGSIZE; a += PGSIZE)
    80000760:	6a85                	lui	s5,0x1
    80000762:	0735e163          	bltu	a1,s3,800007c4 <uvmunmap+0x8e>
            uint64 pa = PTE2PA(*pte);
            kfree((void *)pa);
        }
        *pte = 0;
    }
}
    80000766:	60a6                	ld	ra,72(sp)
    80000768:	6406                	ld	s0,64(sp)
    8000076a:	74e2                	ld	s1,56(sp)
    8000076c:	7942                	ld	s2,48(sp)
    8000076e:	79a2                	ld	s3,40(sp)
    80000770:	7a02                	ld	s4,32(sp)
    80000772:	6ae2                	ld	s5,24(sp)
    80000774:	6b42                	ld	s6,16(sp)
    80000776:	6ba2                	ld	s7,8(sp)
    80000778:	6161                	addi	sp,sp,80
    8000077a:	8082                	ret
        panic("uvmunmap: not aligned");
    8000077c:	00008517          	auipc	a0,0x8
    80000780:	93450513          	addi	a0,a0,-1740 # 800080b0 <etext+0xb0>
    80000784:	00006097          	auipc	ra,0x6
    80000788:	8fe080e7          	jalr	-1794(ra) # 80006082 <panic>
            panic("uvmunmap: walk");
    8000078c:	00008517          	auipc	a0,0x8
    80000790:	93c50513          	addi	a0,a0,-1732 # 800080c8 <etext+0xc8>
    80000794:	00006097          	auipc	ra,0x6
    80000798:	8ee080e7          	jalr	-1810(ra) # 80006082 <panic>
            panic("uvmunmap: not a leaf");
    8000079c:	00008517          	auipc	a0,0x8
    800007a0:	93c50513          	addi	a0,a0,-1732 # 800080d8 <etext+0xd8>
    800007a4:	00006097          	auipc	ra,0x6
    800007a8:	8de080e7          	jalr	-1826(ra) # 80006082 <panic>
            uint64 pa = PTE2PA(*pte);
    800007ac:	83a9                	srli	a5,a5,0xa
            kfree((void *)pa);
    800007ae:	00c79513          	slli	a0,a5,0xc
    800007b2:	00000097          	auipc	ra,0x0
    800007b6:	86a080e7          	jalr	-1942(ra) # 8000001c <kfree>
        *pte = 0;
    800007ba:	0004b023          	sd	zero,0(s1)
    for (a = va; a < va + npages * PGSIZE; a += PGSIZE)
    800007be:	9956                	add	s2,s2,s5
    800007c0:	fb3973e3          	bgeu	s2,s3,80000766 <uvmunmap+0x30>
        if ((pte = walk(pagetable, a, 0)) == 0)
    800007c4:	4601                	li	a2,0
    800007c6:	85ca                	mv	a1,s2
    800007c8:	8552                	mv	a0,s4
    800007ca:	00000097          	auipc	ra,0x0
    800007ce:	c9a080e7          	jalr	-870(ra) # 80000464 <walk>
    800007d2:	84aa                	mv	s1,a0
    800007d4:	dd45                	beqz	a0,8000078c <uvmunmap+0x56>
        if ((*pte & PTE_V) == 0)
    800007d6:	611c                	ld	a5,0(a0)
    800007d8:	0017f713          	andi	a4,a5,1
    800007dc:	d36d                	beqz	a4,800007be <uvmunmap+0x88>
        if (PTE_FLAGS(*pte) == PTE_V)
    800007de:	3ff7f713          	andi	a4,a5,1023
    800007e2:	fb770de3          	beq	a4,s7,8000079c <uvmunmap+0x66>
        if (do_free)
    800007e6:	fc0b0ae3          	beqz	s6,800007ba <uvmunmap+0x84>
    800007ea:	b7c9                	j	800007ac <uvmunmap+0x76>

00000000800007ec <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800007ec:	1101                	addi	sp,sp,-32
    800007ee:	ec06                	sd	ra,24(sp)
    800007f0:	e822                	sd	s0,16(sp)
    800007f2:	e426                	sd	s1,8(sp)
    800007f4:	1000                	addi	s0,sp,32
    pagetable_t pagetable;
    pagetable = (pagetable_t)kalloc();
    800007f6:	00000097          	auipc	ra,0x0
    800007fa:	922080e7          	jalr	-1758(ra) # 80000118 <kalloc>
    800007fe:	84aa                	mv	s1,a0
    if (pagetable == 0)
    80000800:	c519                	beqz	a0,8000080e <uvmcreate+0x22>
        return 0;
    memset(pagetable, 0, PGSIZE);
    80000802:	6605                	lui	a2,0x1
    80000804:	4581                	li	a1,0
    80000806:	00000097          	auipc	ra,0x0
    8000080a:	972080e7          	jalr	-1678(ra) # 80000178 <memset>
    return pagetable;
}
    8000080e:	8526                	mv	a0,s1
    80000810:	60e2                	ld	ra,24(sp)
    80000812:	6442                	ld	s0,16(sp)
    80000814:	64a2                	ld	s1,8(sp)
    80000816:	6105                	addi	sp,sp,32
    80000818:	8082                	ret

000000008000081a <uvmfirst>:

// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    8000081a:	7179                	addi	sp,sp,-48
    8000081c:	f406                	sd	ra,40(sp)
    8000081e:	f022                	sd	s0,32(sp)
    80000820:	ec26                	sd	s1,24(sp)
    80000822:	e84a                	sd	s2,16(sp)
    80000824:	e44e                	sd	s3,8(sp)
    80000826:	e052                	sd	s4,0(sp)
    80000828:	1800                	addi	s0,sp,48
    char *mem;

    if (sz >= PGSIZE)
    8000082a:	6785                	lui	a5,0x1
    8000082c:	04f67863          	bgeu	a2,a5,8000087c <uvmfirst+0x62>
    80000830:	8a2a                	mv	s4,a0
    80000832:	89ae                	mv	s3,a1
    80000834:	84b2                	mv	s1,a2
        panic("uvmfirst: more than a page");
    mem = kalloc();
    80000836:	00000097          	auipc	ra,0x0
    8000083a:	8e2080e7          	jalr	-1822(ra) # 80000118 <kalloc>
    8000083e:	892a                	mv	s2,a0
    memset(mem, 0, PGSIZE);
    80000840:	6605                	lui	a2,0x1
    80000842:	4581                	li	a1,0
    80000844:	00000097          	auipc	ra,0x0
    80000848:	934080e7          	jalr	-1740(ra) # 80000178 <memset>
    mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W | PTE_R | PTE_X | PTE_U);
    8000084c:	4779                	li	a4,30
    8000084e:	86ca                	mv	a3,s2
    80000850:	6605                	lui	a2,0x1
    80000852:	4581                	li	a1,0
    80000854:	8552                	mv	a0,s4
    80000856:	00000097          	auipc	ra,0x0
    8000085a:	cf6080e7          	jalr	-778(ra) # 8000054c <mappages>
    memmove(mem, src, sz);
    8000085e:	8626                	mv	a2,s1
    80000860:	85ce                	mv	a1,s3
    80000862:	854a                	mv	a0,s2
    80000864:	00000097          	auipc	ra,0x0
    80000868:	974080e7          	jalr	-1676(ra) # 800001d8 <memmove>
}
    8000086c:	70a2                	ld	ra,40(sp)
    8000086e:	7402                	ld	s0,32(sp)
    80000870:	64e2                	ld	s1,24(sp)
    80000872:	6942                	ld	s2,16(sp)
    80000874:	69a2                	ld	s3,8(sp)
    80000876:	6a02                	ld	s4,0(sp)
    80000878:	6145                	addi	sp,sp,48
    8000087a:	8082                	ret
        panic("uvmfirst: more than a page");
    8000087c:	00008517          	auipc	a0,0x8
    80000880:	87450513          	addi	a0,a0,-1932 # 800080f0 <etext+0xf0>
    80000884:	00005097          	auipc	ra,0x5
    80000888:	7fe080e7          	jalr	2046(ra) # 80006082 <panic>

000000008000088c <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    8000088c:	1101                	addi	sp,sp,-32
    8000088e:	ec06                	sd	ra,24(sp)
    80000890:	e822                	sd	s0,16(sp)
    80000892:	e426                	sd	s1,8(sp)
    80000894:	1000                	addi	s0,sp,32
    if (newsz >= oldsz)
        return oldsz;
    80000896:	84ae                	mv	s1,a1
    if (newsz >= oldsz)
    80000898:	00b67d63          	bgeu	a2,a1,800008b2 <uvmdealloc+0x26>
    8000089c:	84b2                	mv	s1,a2

    if (PGROUNDUP(newsz) < PGROUNDUP(oldsz))
    8000089e:	6785                	lui	a5,0x1
    800008a0:	17fd                	addi	a5,a5,-1
    800008a2:	00f60733          	add	a4,a2,a5
    800008a6:	767d                	lui	a2,0xfffff
    800008a8:	8f71                	and	a4,a4,a2
    800008aa:	97ae                	add	a5,a5,a1
    800008ac:	8ff1                	and	a5,a5,a2
    800008ae:	00f76863          	bltu	a4,a5,800008be <uvmdealloc+0x32>
        int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
        uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    }

    return newsz;
}
    800008b2:	8526                	mv	a0,s1
    800008b4:	60e2                	ld	ra,24(sp)
    800008b6:	6442                	ld	s0,16(sp)
    800008b8:	64a2                	ld	s1,8(sp)
    800008ba:	6105                	addi	sp,sp,32
    800008bc:	8082                	ret
        int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    800008be:	8f99                	sub	a5,a5,a4
    800008c0:	83b1                	srli	a5,a5,0xc
        uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    800008c2:	4685                	li	a3,1
    800008c4:	0007861b          	sext.w	a2,a5
    800008c8:	85ba                	mv	a1,a4
    800008ca:	00000097          	auipc	ra,0x0
    800008ce:	e6c080e7          	jalr	-404(ra) # 80000736 <uvmunmap>
    800008d2:	b7c5                	j	800008b2 <uvmdealloc+0x26>

00000000800008d4 <uvmalloc>:
    if (newsz < oldsz)
    800008d4:	0ab66563          	bltu	a2,a1,8000097e <uvmalloc+0xaa>
{
    800008d8:	7139                	addi	sp,sp,-64
    800008da:	fc06                	sd	ra,56(sp)
    800008dc:	f822                	sd	s0,48(sp)
    800008de:	f426                	sd	s1,40(sp)
    800008e0:	f04a                	sd	s2,32(sp)
    800008e2:	ec4e                	sd	s3,24(sp)
    800008e4:	e852                	sd	s4,16(sp)
    800008e6:	e456                	sd	s5,8(sp)
    800008e8:	e05a                	sd	s6,0(sp)
    800008ea:	0080                	addi	s0,sp,64
    800008ec:	8aaa                	mv	s5,a0
    800008ee:	8a32                	mv	s4,a2
    oldsz = PGROUNDUP(oldsz);
    800008f0:	6985                	lui	s3,0x1
    800008f2:	19fd                	addi	s3,s3,-1
    800008f4:	95ce                	add	a1,a1,s3
    800008f6:	79fd                	lui	s3,0xfffff
    800008f8:	0135f9b3          	and	s3,a1,s3
    for (a = oldsz; a < newsz; a += PGSIZE)
    800008fc:	08c9f363          	bgeu	s3,a2,80000982 <uvmalloc+0xae>
    80000900:	894e                	mv	s2,s3
        if (mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R | PTE_U | xperm) != 0)
    80000902:	0126eb13          	ori	s6,a3,18
        mem = kalloc();
    80000906:	00000097          	auipc	ra,0x0
    8000090a:	812080e7          	jalr	-2030(ra) # 80000118 <kalloc>
    8000090e:	84aa                	mv	s1,a0
        if (mem == 0)
    80000910:	c51d                	beqz	a0,8000093e <uvmalloc+0x6a>
        memset(mem, 0, PGSIZE);
    80000912:	6605                	lui	a2,0x1
    80000914:	4581                	li	a1,0
    80000916:	00000097          	auipc	ra,0x0
    8000091a:	862080e7          	jalr	-1950(ra) # 80000178 <memset>
        if (mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R | PTE_U | xperm) != 0)
    8000091e:	875a                	mv	a4,s6
    80000920:	86a6                	mv	a3,s1
    80000922:	6605                	lui	a2,0x1
    80000924:	85ca                	mv	a1,s2
    80000926:	8556                	mv	a0,s5
    80000928:	00000097          	auipc	ra,0x0
    8000092c:	c24080e7          	jalr	-988(ra) # 8000054c <mappages>
    80000930:	e90d                	bnez	a0,80000962 <uvmalloc+0x8e>
    for (a = oldsz; a < newsz; a += PGSIZE)
    80000932:	6785                	lui	a5,0x1
    80000934:	993e                	add	s2,s2,a5
    80000936:	fd4968e3          	bltu	s2,s4,80000906 <uvmalloc+0x32>
    return newsz;
    8000093a:	8552                	mv	a0,s4
    8000093c:	a809                	j	8000094e <uvmalloc+0x7a>
            uvmdealloc(pagetable, a, oldsz);
    8000093e:	864e                	mv	a2,s3
    80000940:	85ca                	mv	a1,s2
    80000942:	8556                	mv	a0,s5
    80000944:	00000097          	auipc	ra,0x0
    80000948:	f48080e7          	jalr	-184(ra) # 8000088c <uvmdealloc>
            return 0;
    8000094c:	4501                	li	a0,0
}
    8000094e:	70e2                	ld	ra,56(sp)
    80000950:	7442                	ld	s0,48(sp)
    80000952:	74a2                	ld	s1,40(sp)
    80000954:	7902                	ld	s2,32(sp)
    80000956:	69e2                	ld	s3,24(sp)
    80000958:	6a42                	ld	s4,16(sp)
    8000095a:	6aa2                	ld	s5,8(sp)
    8000095c:	6b02                	ld	s6,0(sp)
    8000095e:	6121                	addi	sp,sp,64
    80000960:	8082                	ret
            kfree(mem);
    80000962:	8526                	mv	a0,s1
    80000964:	fffff097          	auipc	ra,0xfffff
    80000968:	6b8080e7          	jalr	1720(ra) # 8000001c <kfree>
            uvmdealloc(pagetable, a, oldsz);
    8000096c:	864e                	mv	a2,s3
    8000096e:	85ca                	mv	a1,s2
    80000970:	8556                	mv	a0,s5
    80000972:	00000097          	auipc	ra,0x0
    80000976:	f1a080e7          	jalr	-230(ra) # 8000088c <uvmdealloc>
            return 0;
    8000097a:	4501                	li	a0,0
    8000097c:	bfc9                	j	8000094e <uvmalloc+0x7a>
        return oldsz;
    8000097e:	852e                	mv	a0,a1
}
    80000980:	8082                	ret
    return newsz;
    80000982:	8532                	mv	a0,a2
    80000984:	b7e9                	j	8000094e <uvmalloc+0x7a>

0000000080000986 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void freewalk(pagetable_t pagetable)
{
    80000986:	7179                	addi	sp,sp,-48
    80000988:	f406                	sd	ra,40(sp)
    8000098a:	f022                	sd	s0,32(sp)
    8000098c:	ec26                	sd	s1,24(sp)
    8000098e:	e84a                	sd	s2,16(sp)
    80000990:	e44e                	sd	s3,8(sp)
    80000992:	e052                	sd	s4,0(sp)
    80000994:	1800                	addi	s0,sp,48
    80000996:	8a2a                	mv	s4,a0
    // there are 2^9 = 512 PTEs in a page table.
    for (int i = 0; i < 512; i++)
    80000998:	84aa                	mv	s1,a0
    8000099a:	6905                	lui	s2,0x1
    8000099c:	992a                	add	s2,s2,a0
    {
        pte_t pte = pagetable[i];
        if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0)
    8000099e:	4985                	li	s3,1
    800009a0:	a821                	j	800009b8 <freewalk+0x32>
        {
            // this PTE points to a lower-level page table.
            uint64 child = PTE2PA(pte);
    800009a2:	8129                	srli	a0,a0,0xa
            freewalk((pagetable_t)child);
    800009a4:	0532                	slli	a0,a0,0xc
    800009a6:	00000097          	auipc	ra,0x0
    800009aa:	fe0080e7          	jalr	-32(ra) # 80000986 <freewalk>
            pagetable[i] = 0;
    800009ae:	0004b023          	sd	zero,0(s1)
    for (int i = 0; i < 512; i++)
    800009b2:	04a1                	addi	s1,s1,8
    800009b4:	03248163          	beq	s1,s2,800009d6 <freewalk+0x50>
        pte_t pte = pagetable[i];
    800009b8:	6088                	ld	a0,0(s1)
        if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0)
    800009ba:	00f57793          	andi	a5,a0,15
    800009be:	ff3782e3          	beq	a5,s3,800009a2 <freewalk+0x1c>
        }
        else if (pte & PTE_V)
    800009c2:	8905                	andi	a0,a0,1
    800009c4:	d57d                	beqz	a0,800009b2 <freewalk+0x2c>
        {
            panic("freewalk: leaf");
    800009c6:	00007517          	auipc	a0,0x7
    800009ca:	74a50513          	addi	a0,a0,1866 # 80008110 <etext+0x110>
    800009ce:	00005097          	auipc	ra,0x5
    800009d2:	6b4080e7          	jalr	1716(ra) # 80006082 <panic>
        }
    }
    kfree((void *)pagetable);
    800009d6:	8552                	mv	a0,s4
    800009d8:	fffff097          	auipc	ra,0xfffff
    800009dc:	644080e7          	jalr	1604(ra) # 8000001c <kfree>
}
    800009e0:	70a2                	ld	ra,40(sp)
    800009e2:	7402                	ld	s0,32(sp)
    800009e4:	64e2                	ld	s1,24(sp)
    800009e6:	6942                	ld	s2,16(sp)
    800009e8:	69a2                	ld	s3,8(sp)
    800009ea:	6a02                	ld	s4,0(sp)
    800009ec:	6145                	addi	sp,sp,48
    800009ee:	8082                	ret

00000000800009f0 <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void uvmfree(pagetable_t pagetable, uint64 sz)
{
    800009f0:	1101                	addi	sp,sp,-32
    800009f2:	ec06                	sd	ra,24(sp)
    800009f4:	e822                	sd	s0,16(sp)
    800009f6:	e426                	sd	s1,8(sp)
    800009f8:	1000                	addi	s0,sp,32
    800009fa:	84aa                	mv	s1,a0
    if (sz > 0)
    800009fc:	e999                	bnez	a1,80000a12 <uvmfree+0x22>
        uvmunmap(pagetable, 0, PGROUNDUP(sz) / PGSIZE, 1);
    freewalk(pagetable);
    800009fe:	8526                	mv	a0,s1
    80000a00:	00000097          	auipc	ra,0x0
    80000a04:	f86080e7          	jalr	-122(ra) # 80000986 <freewalk>
}
    80000a08:	60e2                	ld	ra,24(sp)
    80000a0a:	6442                	ld	s0,16(sp)
    80000a0c:	64a2                	ld	s1,8(sp)
    80000a0e:	6105                	addi	sp,sp,32
    80000a10:	8082                	ret
        uvmunmap(pagetable, 0, PGROUNDUP(sz) / PGSIZE, 1);
    80000a12:	6605                	lui	a2,0x1
    80000a14:	167d                	addi	a2,a2,-1
    80000a16:	962e                	add	a2,a2,a1
    80000a18:	4685                	li	a3,1
    80000a1a:	8231                	srli	a2,a2,0xc
    80000a1c:	4581                	li	a1,0
    80000a1e:	00000097          	auipc	ra,0x0
    80000a22:	d18080e7          	jalr	-744(ra) # 80000736 <uvmunmap>
    80000a26:	bfe1                	j	800009fe <uvmfree+0xe>

0000000080000a28 <uvmcopy>:
    pte_t *pte;
    uint64 pa, i;
    uint flags;
    char *mem;

    for (i = 0; i < sz; i += PGSIZE)
    80000a28:	c269                	beqz	a2,80000aea <uvmcopy+0xc2>
{
    80000a2a:	715d                	addi	sp,sp,-80
    80000a2c:	e486                	sd	ra,72(sp)
    80000a2e:	e0a2                	sd	s0,64(sp)
    80000a30:	fc26                	sd	s1,56(sp)
    80000a32:	f84a                	sd	s2,48(sp)
    80000a34:	f44e                	sd	s3,40(sp)
    80000a36:	f052                	sd	s4,32(sp)
    80000a38:	ec56                	sd	s5,24(sp)
    80000a3a:	e85a                	sd	s6,16(sp)
    80000a3c:	e45e                	sd	s7,8(sp)
    80000a3e:	0880                	addi	s0,sp,80
    80000a40:	8aaa                	mv	s5,a0
    80000a42:	8b2e                	mv	s6,a1
    80000a44:	8a32                	mv	s4,a2
    for (i = 0; i < sz; i += PGSIZE)
    80000a46:	4481                	li	s1,0
    80000a48:	a829                	j	80000a62 <uvmcopy+0x3a>
    {
        if ((pte = walk(old, i, 0)) == 0)
            panic("uvmcopy: pte should exist");
    80000a4a:	00007517          	auipc	a0,0x7
    80000a4e:	6d650513          	addi	a0,a0,1750 # 80008120 <etext+0x120>
    80000a52:	00005097          	auipc	ra,0x5
    80000a56:	630080e7          	jalr	1584(ra) # 80006082 <panic>
    for (i = 0; i < sz; i += PGSIZE)
    80000a5a:	6785                	lui	a5,0x1
    80000a5c:	94be                	add	s1,s1,a5
    80000a5e:	0944f463          	bgeu	s1,s4,80000ae6 <uvmcopy+0xbe>
        if ((pte = walk(old, i, 0)) == 0)
    80000a62:	4601                	li	a2,0
    80000a64:	85a6                	mv	a1,s1
    80000a66:	8556                	mv	a0,s5
    80000a68:	00000097          	auipc	ra,0x0
    80000a6c:	9fc080e7          	jalr	-1540(ra) # 80000464 <walk>
    80000a70:	dd69                	beqz	a0,80000a4a <uvmcopy+0x22>
        if ((*pte & PTE_V) == 0)
    80000a72:	6118                	ld	a4,0(a0)
    80000a74:	00177793          	andi	a5,a4,1
    80000a78:	d3ed                	beqz	a5,80000a5a <uvmcopy+0x32>
            continue;
        // panic("uvmcopy: page not present");
        pa = PTE2PA(*pte);
    80000a7a:	00a75593          	srli	a1,a4,0xa
    80000a7e:	00c59b93          	slli	s7,a1,0xc
        flags = PTE_FLAGS(*pte);
    80000a82:	3ff77913          	andi	s2,a4,1023
        if ((mem = kalloc()) == 0)
    80000a86:	fffff097          	auipc	ra,0xfffff
    80000a8a:	692080e7          	jalr	1682(ra) # 80000118 <kalloc>
    80000a8e:	89aa                	mv	s3,a0
    80000a90:	c515                	beqz	a0,80000abc <uvmcopy+0x94>
            goto err;
        memmove(mem, (char *)pa, PGSIZE);
    80000a92:	6605                	lui	a2,0x1
    80000a94:	85de                	mv	a1,s7
    80000a96:	fffff097          	auipc	ra,0xfffff
    80000a9a:	742080e7          	jalr	1858(ra) # 800001d8 <memmove>
        if (mappages(new, i, PGSIZE, (uint64)mem, flags) != 0)
    80000a9e:	874a                	mv	a4,s2
    80000aa0:	86ce                	mv	a3,s3
    80000aa2:	6605                	lui	a2,0x1
    80000aa4:	85a6                	mv	a1,s1
    80000aa6:	855a                	mv	a0,s6
    80000aa8:	00000097          	auipc	ra,0x0
    80000aac:	aa4080e7          	jalr	-1372(ra) # 8000054c <mappages>
    80000ab0:	d54d                	beqz	a0,80000a5a <uvmcopy+0x32>
        {
            kfree(mem);
    80000ab2:	854e                	mv	a0,s3
    80000ab4:	fffff097          	auipc	ra,0xfffff
    80000ab8:	568080e7          	jalr	1384(ra) # 8000001c <kfree>
        }
    }
    return 0;

err:
    uvmunmap(new, 0, i / PGSIZE, 1);
    80000abc:	4685                	li	a3,1
    80000abe:	00c4d613          	srli	a2,s1,0xc
    80000ac2:	4581                	li	a1,0
    80000ac4:	855a                	mv	a0,s6
    80000ac6:	00000097          	auipc	ra,0x0
    80000aca:	c70080e7          	jalr	-912(ra) # 80000736 <uvmunmap>
    return -1;
    80000ace:	557d                	li	a0,-1
}
    80000ad0:	60a6                	ld	ra,72(sp)
    80000ad2:	6406                	ld	s0,64(sp)
    80000ad4:	74e2                	ld	s1,56(sp)
    80000ad6:	7942                	ld	s2,48(sp)
    80000ad8:	79a2                	ld	s3,40(sp)
    80000ada:	7a02                	ld	s4,32(sp)
    80000adc:	6ae2                	ld	s5,24(sp)
    80000ade:	6b42                	ld	s6,16(sp)
    80000ae0:	6ba2                	ld	s7,8(sp)
    80000ae2:	6161                	addi	sp,sp,80
    80000ae4:	8082                	ret
    return 0;
    80000ae6:	4501                	li	a0,0
    80000ae8:	b7e5                	j	80000ad0 <uvmcopy+0xa8>
    80000aea:	4501                	li	a0,0
}
    80000aec:	8082                	ret

0000000080000aee <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void uvmclear(pagetable_t pagetable, uint64 va)
{
    80000aee:	1141                	addi	sp,sp,-16
    80000af0:	e406                	sd	ra,8(sp)
    80000af2:	e022                	sd	s0,0(sp)
    80000af4:	0800                	addi	s0,sp,16
    pte_t *pte;

    pte = walk(pagetable, va, 0);
    80000af6:	4601                	li	a2,0
    80000af8:	00000097          	auipc	ra,0x0
    80000afc:	96c080e7          	jalr	-1684(ra) # 80000464 <walk>
    if (pte == 0)
    80000b00:	c901                	beqz	a0,80000b10 <uvmclear+0x22>
        panic("uvmclear");
    *pte &= ~PTE_U;
    80000b02:	611c                	ld	a5,0(a0)
    80000b04:	9bbd                	andi	a5,a5,-17
    80000b06:	e11c                	sd	a5,0(a0)
}
    80000b08:	60a2                	ld	ra,8(sp)
    80000b0a:	6402                	ld	s0,0(sp)
    80000b0c:	0141                	addi	sp,sp,16
    80000b0e:	8082                	ret
        panic("uvmclear");
    80000b10:	00007517          	auipc	a0,0x7
    80000b14:	63050513          	addi	a0,a0,1584 # 80008140 <etext+0x140>
    80000b18:	00005097          	auipc	ra,0x5
    80000b1c:	56a080e7          	jalr	1386(ra) # 80006082 <panic>

0000000080000b20 <copyout>:
// Return 0 on success, -1 on error.
int copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
    uint64 n, va0, pa0;

    while (len > 0)
    80000b20:	c6bd                	beqz	a3,80000b8e <copyout+0x6e>
{
    80000b22:	715d                	addi	sp,sp,-80
    80000b24:	e486                	sd	ra,72(sp)
    80000b26:	e0a2                	sd	s0,64(sp)
    80000b28:	fc26                	sd	s1,56(sp)
    80000b2a:	f84a                	sd	s2,48(sp)
    80000b2c:	f44e                	sd	s3,40(sp)
    80000b2e:	f052                	sd	s4,32(sp)
    80000b30:	ec56                	sd	s5,24(sp)
    80000b32:	e85a                	sd	s6,16(sp)
    80000b34:	e45e                	sd	s7,8(sp)
    80000b36:	e062                	sd	s8,0(sp)
    80000b38:	0880                	addi	s0,sp,80
    80000b3a:	8b2a                	mv	s6,a0
    80000b3c:	8c2e                	mv	s8,a1
    80000b3e:	8a32                	mv	s4,a2
    80000b40:	89b6                	mv	s3,a3
    {
        va0 = PGROUNDDOWN(dstva);
    80000b42:	7bfd                	lui	s7,0xfffff
        pa0 = walkaddr(pagetable, va0);
        if (pa0 == 0)
            return -1;
        n = PGSIZE - (dstva - va0);
    80000b44:	6a85                	lui	s5,0x1
    80000b46:	a015                	j	80000b6a <copyout+0x4a>
        if (n > len)
            n = len;
        memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b48:	9562                	add	a0,a0,s8
    80000b4a:	0004861b          	sext.w	a2,s1
    80000b4e:	85d2                	mv	a1,s4
    80000b50:	41250533          	sub	a0,a0,s2
    80000b54:	fffff097          	auipc	ra,0xfffff
    80000b58:	684080e7          	jalr	1668(ra) # 800001d8 <memmove>

        len -= n;
    80000b5c:	409989b3          	sub	s3,s3,s1
        src += n;
    80000b60:	9a26                	add	s4,s4,s1
        dstva = va0 + PGSIZE;
    80000b62:	01590c33          	add	s8,s2,s5
    while (len > 0)
    80000b66:	02098263          	beqz	s3,80000b8a <copyout+0x6a>
        va0 = PGROUNDDOWN(dstva);
    80000b6a:	017c7933          	and	s2,s8,s7
        pa0 = walkaddr(pagetable, va0);
    80000b6e:	85ca                	mv	a1,s2
    80000b70:	855a                	mv	a0,s6
    80000b72:	00000097          	auipc	ra,0x0
    80000b76:	998080e7          	jalr	-1640(ra) # 8000050a <walkaddr>
        if (pa0 == 0)
    80000b7a:	cd01                	beqz	a0,80000b92 <copyout+0x72>
        n = PGSIZE - (dstva - va0);
    80000b7c:	418904b3          	sub	s1,s2,s8
    80000b80:	94d6                	add	s1,s1,s5
        if (n > len)
    80000b82:	fc99f3e3          	bgeu	s3,s1,80000b48 <copyout+0x28>
    80000b86:	84ce                	mv	s1,s3
    80000b88:	b7c1                	j	80000b48 <copyout+0x28>
    }
    return 0;
    80000b8a:	4501                	li	a0,0
    80000b8c:	a021                	j	80000b94 <copyout+0x74>
    80000b8e:	4501                	li	a0,0
}
    80000b90:	8082                	ret
            return -1;
    80000b92:	557d                	li	a0,-1
}
    80000b94:	60a6                	ld	ra,72(sp)
    80000b96:	6406                	ld	s0,64(sp)
    80000b98:	74e2                	ld	s1,56(sp)
    80000b9a:	7942                	ld	s2,48(sp)
    80000b9c:	79a2                	ld	s3,40(sp)
    80000b9e:	7a02                	ld	s4,32(sp)
    80000ba0:	6ae2                	ld	s5,24(sp)
    80000ba2:	6b42                	ld	s6,16(sp)
    80000ba4:	6ba2                	ld	s7,8(sp)
    80000ba6:	6c02                	ld	s8,0(sp)
    80000ba8:	6161                	addi	sp,sp,80
    80000baa:	8082                	ret

0000000080000bac <copyin>:
// Return 0 on success, -1 on error.
int copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
    uint64 n, va0, pa0;

    while (len > 0)
    80000bac:	c6bd                	beqz	a3,80000c1a <copyin+0x6e>
{
    80000bae:	715d                	addi	sp,sp,-80
    80000bb0:	e486                	sd	ra,72(sp)
    80000bb2:	e0a2                	sd	s0,64(sp)
    80000bb4:	fc26                	sd	s1,56(sp)
    80000bb6:	f84a                	sd	s2,48(sp)
    80000bb8:	f44e                	sd	s3,40(sp)
    80000bba:	f052                	sd	s4,32(sp)
    80000bbc:	ec56                	sd	s5,24(sp)
    80000bbe:	e85a                	sd	s6,16(sp)
    80000bc0:	e45e                	sd	s7,8(sp)
    80000bc2:	e062                	sd	s8,0(sp)
    80000bc4:	0880                	addi	s0,sp,80
    80000bc6:	8b2a                	mv	s6,a0
    80000bc8:	8a2e                	mv	s4,a1
    80000bca:	8c32                	mv	s8,a2
    80000bcc:	89b6                	mv	s3,a3
    {
        va0 = PGROUNDDOWN(srcva);
    80000bce:	7bfd                	lui	s7,0xfffff
        pa0 = walkaddr(pagetable, va0);
        if (pa0 == 0)
            return -1;
        n = PGSIZE - (srcva - va0);
    80000bd0:	6a85                	lui	s5,0x1
    80000bd2:	a015                	j	80000bf6 <copyin+0x4a>
        if (n > len)
            n = len;
        memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000bd4:	9562                	add	a0,a0,s8
    80000bd6:	0004861b          	sext.w	a2,s1
    80000bda:	412505b3          	sub	a1,a0,s2
    80000bde:	8552                	mv	a0,s4
    80000be0:	fffff097          	auipc	ra,0xfffff
    80000be4:	5f8080e7          	jalr	1528(ra) # 800001d8 <memmove>

        len -= n;
    80000be8:	409989b3          	sub	s3,s3,s1
        dst += n;
    80000bec:	9a26                	add	s4,s4,s1
        srcva = va0 + PGSIZE;
    80000bee:	01590c33          	add	s8,s2,s5
    while (len > 0)
    80000bf2:	02098263          	beqz	s3,80000c16 <copyin+0x6a>
        va0 = PGROUNDDOWN(srcva);
    80000bf6:	017c7933          	and	s2,s8,s7
        pa0 = walkaddr(pagetable, va0);
    80000bfa:	85ca                	mv	a1,s2
    80000bfc:	855a                	mv	a0,s6
    80000bfe:	00000097          	auipc	ra,0x0
    80000c02:	90c080e7          	jalr	-1780(ra) # 8000050a <walkaddr>
        if (pa0 == 0)
    80000c06:	cd01                	beqz	a0,80000c1e <copyin+0x72>
        n = PGSIZE - (srcva - va0);
    80000c08:	418904b3          	sub	s1,s2,s8
    80000c0c:	94d6                	add	s1,s1,s5
        if (n > len)
    80000c0e:	fc99f3e3          	bgeu	s3,s1,80000bd4 <copyin+0x28>
    80000c12:	84ce                	mv	s1,s3
    80000c14:	b7c1                	j	80000bd4 <copyin+0x28>
    }
    return 0;
    80000c16:	4501                	li	a0,0
    80000c18:	a021                	j	80000c20 <copyin+0x74>
    80000c1a:	4501                	li	a0,0
}
    80000c1c:	8082                	ret
            return -1;
    80000c1e:	557d                	li	a0,-1
}
    80000c20:	60a6                	ld	ra,72(sp)
    80000c22:	6406                	ld	s0,64(sp)
    80000c24:	74e2                	ld	s1,56(sp)
    80000c26:	7942                	ld	s2,48(sp)
    80000c28:	79a2                	ld	s3,40(sp)
    80000c2a:	7a02                	ld	s4,32(sp)
    80000c2c:	6ae2                	ld	s5,24(sp)
    80000c2e:	6b42                	ld	s6,16(sp)
    80000c30:	6ba2                	ld	s7,8(sp)
    80000c32:	6c02                	ld	s8,0(sp)
    80000c34:	6161                	addi	sp,sp,80
    80000c36:	8082                	ret

0000000080000c38 <copyinstr>:
int copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
    uint64 n, va0, pa0;
    int got_null = 0;

    while (got_null == 0 && max > 0)
    80000c38:	c6c5                	beqz	a3,80000ce0 <copyinstr+0xa8>
{
    80000c3a:	715d                	addi	sp,sp,-80
    80000c3c:	e486                	sd	ra,72(sp)
    80000c3e:	e0a2                	sd	s0,64(sp)
    80000c40:	fc26                	sd	s1,56(sp)
    80000c42:	f84a                	sd	s2,48(sp)
    80000c44:	f44e                	sd	s3,40(sp)
    80000c46:	f052                	sd	s4,32(sp)
    80000c48:	ec56                	sd	s5,24(sp)
    80000c4a:	e85a                	sd	s6,16(sp)
    80000c4c:	e45e                	sd	s7,8(sp)
    80000c4e:	0880                	addi	s0,sp,80
    80000c50:	8a2a                	mv	s4,a0
    80000c52:	8b2e                	mv	s6,a1
    80000c54:	8bb2                	mv	s7,a2
    80000c56:	84b6                	mv	s1,a3
    {
        va0 = PGROUNDDOWN(srcva);
    80000c58:	7afd                	lui	s5,0xfffff
        pa0 = walkaddr(pagetable, va0);
        if (pa0 == 0)
            return -1;
        n = PGSIZE - (srcva - va0);
    80000c5a:	6985                	lui	s3,0x1
    80000c5c:	a035                	j	80000c88 <copyinstr+0x50>
        char *p = (char *)(pa0 + (srcva - va0));
        while (n > 0)
        {
            if (*p == '\0')
            {
                *dst = '\0';
    80000c5e:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000c62:	4785                	li	a5,1
            dst++;
        }

        srcva = va0 + PGSIZE;
    }
    if (got_null)
    80000c64:	0017b793          	seqz	a5,a5
    80000c68:	40f00533          	neg	a0,a5
    }
    else
    {
        return -1;
    }
}
    80000c6c:	60a6                	ld	ra,72(sp)
    80000c6e:	6406                	ld	s0,64(sp)
    80000c70:	74e2                	ld	s1,56(sp)
    80000c72:	7942                	ld	s2,48(sp)
    80000c74:	79a2                	ld	s3,40(sp)
    80000c76:	7a02                	ld	s4,32(sp)
    80000c78:	6ae2                	ld	s5,24(sp)
    80000c7a:	6b42                	ld	s6,16(sp)
    80000c7c:	6ba2                	ld	s7,8(sp)
    80000c7e:	6161                	addi	sp,sp,80
    80000c80:	8082                	ret
        srcva = va0 + PGSIZE;
    80000c82:	01390bb3          	add	s7,s2,s3
    while (got_null == 0 && max > 0)
    80000c86:	c8a9                	beqz	s1,80000cd8 <copyinstr+0xa0>
        va0 = PGROUNDDOWN(srcva);
    80000c88:	015bf933          	and	s2,s7,s5
        pa0 = walkaddr(pagetable, va0);
    80000c8c:	85ca                	mv	a1,s2
    80000c8e:	8552                	mv	a0,s4
    80000c90:	00000097          	auipc	ra,0x0
    80000c94:	87a080e7          	jalr	-1926(ra) # 8000050a <walkaddr>
        if (pa0 == 0)
    80000c98:	c131                	beqz	a0,80000cdc <copyinstr+0xa4>
        n = PGSIZE - (srcva - va0);
    80000c9a:	41790833          	sub	a6,s2,s7
    80000c9e:	984e                	add	a6,a6,s3
        if (n > max)
    80000ca0:	0104f363          	bgeu	s1,a6,80000ca6 <copyinstr+0x6e>
    80000ca4:	8826                	mv	a6,s1
        char *p = (char *)(pa0 + (srcva - va0));
    80000ca6:	955e                	add	a0,a0,s7
    80000ca8:	41250533          	sub	a0,a0,s2
        while (n > 0)
    80000cac:	fc080be3          	beqz	a6,80000c82 <copyinstr+0x4a>
    80000cb0:	985a                	add	a6,a6,s6
    80000cb2:	87da                	mv	a5,s6
            if (*p == '\0')
    80000cb4:	41650633          	sub	a2,a0,s6
    80000cb8:	14fd                	addi	s1,s1,-1
    80000cba:	9b26                	add	s6,s6,s1
    80000cbc:	00f60733          	add	a4,a2,a5
    80000cc0:	00074703          	lbu	a4,0(a4)
    80000cc4:	df49                	beqz	a4,80000c5e <copyinstr+0x26>
                *dst = *p;
    80000cc6:	00e78023          	sb	a4,0(a5)
            --max;
    80000cca:	40fb04b3          	sub	s1,s6,a5
            dst++;
    80000cce:	0785                	addi	a5,a5,1
        while (n > 0)
    80000cd0:	ff0796e3          	bne	a5,a6,80000cbc <copyinstr+0x84>
            dst++;
    80000cd4:	8b42                	mv	s6,a6
    80000cd6:	b775                	j	80000c82 <copyinstr+0x4a>
    80000cd8:	4781                	li	a5,0
    80000cda:	b769                	j	80000c64 <copyinstr+0x2c>
            return -1;
    80000cdc:	557d                	li	a0,-1
    80000cde:	b779                	j	80000c6c <copyinstr+0x34>
    int got_null = 0;
    80000ce0:	4781                	li	a5,0
    if (got_null)
    80000ce2:	0017b793          	seqz	a5,a5
    80000ce6:	40f00533          	neg	a0,a5
}
    80000cea:	8082                	ret

0000000080000cec <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void proc_mapstacks(pagetable_t kpgtbl)
{
    80000cec:	7139                	addi	sp,sp,-64
    80000cee:	fc06                	sd	ra,56(sp)
    80000cf0:	f822                	sd	s0,48(sp)
    80000cf2:	f426                	sd	s1,40(sp)
    80000cf4:	f04a                	sd	s2,32(sp)
    80000cf6:	ec4e                	sd	s3,24(sp)
    80000cf8:	e852                	sd	s4,16(sp)
    80000cfa:	e456                	sd	s5,8(sp)
    80000cfc:	e05a                	sd	s6,0(sp)
    80000cfe:	0080                	addi	s0,sp,64
    80000d00:	89aa                	mv	s3,a0
    struct proc *p;

    for (p = proc; p < &proc[NPROC]; p++)
    80000d02:	00008497          	auipc	s1,0x8
    80000d06:	2ae48493          	addi	s1,s1,686 # 80008fb0 <proc>
    {
        char *pa = kalloc();
        if (pa == 0)
            panic("kalloc");
        uint64 va = KSTACK((int)(p - proc));
    80000d0a:	8b26                	mv	s6,s1
    80000d0c:	00007a97          	auipc	s5,0x7
    80000d10:	2f4a8a93          	addi	s5,s5,756 # 80008000 <etext>
    80000d14:	04000937          	lui	s2,0x4000
    80000d18:	197d                	addi	s2,s2,-1
    80000d1a:	0932                	slli	s2,s2,0xc
    for (p = proc; p < &proc[NPROC]; p++)
    80000d1c:	00020a17          	auipc	s4,0x20
    80000d20:	c94a0a13          	addi	s4,s4,-876 # 800209b0 <tickslock>
        char *pa = kalloc();
    80000d24:	fffff097          	auipc	ra,0xfffff
    80000d28:	3f4080e7          	jalr	1012(ra) # 80000118 <kalloc>
    80000d2c:	862a                	mv	a2,a0
        if (pa == 0)
    80000d2e:	c131                	beqz	a0,80000d72 <proc_mapstacks+0x86>
        uint64 va = KSTACK((int)(p - proc));
    80000d30:	416485b3          	sub	a1,s1,s6
    80000d34:	858d                	srai	a1,a1,0x3
    80000d36:	000ab783          	ld	a5,0(s5)
    80000d3a:	02f585b3          	mul	a1,a1,a5
    80000d3e:	2585                	addiw	a1,a1,1
    80000d40:	00d5959b          	slliw	a1,a1,0xd
        kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d44:	4719                	li	a4,6
    80000d46:	6685                	lui	a3,0x1
    80000d48:	40b905b3          	sub	a1,s2,a1
    80000d4c:	854e                	mv	a0,s3
    80000d4e:	00000097          	auipc	ra,0x0
    80000d52:	8c2080e7          	jalr	-1854(ra) # 80000610 <kvmmap>
    for (p = proc; p < &proc[NPROC]; p++)
    80000d56:	5e848493          	addi	s1,s1,1512
    80000d5a:	fd4495e3          	bne	s1,s4,80000d24 <proc_mapstacks+0x38>
    }
}
    80000d5e:	70e2                	ld	ra,56(sp)
    80000d60:	7442                	ld	s0,48(sp)
    80000d62:	74a2                	ld	s1,40(sp)
    80000d64:	7902                	ld	s2,32(sp)
    80000d66:	69e2                	ld	s3,24(sp)
    80000d68:	6a42                	ld	s4,16(sp)
    80000d6a:	6aa2                	ld	s5,8(sp)
    80000d6c:	6b02                	ld	s6,0(sp)
    80000d6e:	6121                	addi	sp,sp,64
    80000d70:	8082                	ret
            panic("kalloc");
    80000d72:	00007517          	auipc	a0,0x7
    80000d76:	3de50513          	addi	a0,a0,990 # 80008150 <etext+0x150>
    80000d7a:	00005097          	auipc	ra,0x5
    80000d7e:	308080e7          	jalr	776(ra) # 80006082 <panic>

0000000080000d82 <procinit>:

// initialize the proc table.
void procinit(void)
{
    80000d82:	7139                	addi	sp,sp,-64
    80000d84:	fc06                	sd	ra,56(sp)
    80000d86:	f822                	sd	s0,48(sp)
    80000d88:	f426                	sd	s1,40(sp)
    80000d8a:	f04a                	sd	s2,32(sp)
    80000d8c:	ec4e                	sd	s3,24(sp)
    80000d8e:	e852                	sd	s4,16(sp)
    80000d90:	e456                	sd	s5,8(sp)
    80000d92:	e05a                	sd	s6,0(sp)
    80000d94:	0080                	addi	s0,sp,64
    struct proc *p;

    initlock(&pid_lock, "nextpid");
    80000d96:	00007597          	auipc	a1,0x7
    80000d9a:	3c258593          	addi	a1,a1,962 # 80008158 <etext+0x158>
    80000d9e:	00008517          	auipc	a0,0x8
    80000da2:	de250513          	addi	a0,a0,-542 # 80008b80 <pid_lock>
    80000da6:	00005097          	auipc	ra,0x5
    80000daa:	796080e7          	jalr	1942(ra) # 8000653c <initlock>
    initlock(&wait_lock, "wait_lock");
    80000dae:	00007597          	auipc	a1,0x7
    80000db2:	3b258593          	addi	a1,a1,946 # 80008160 <etext+0x160>
    80000db6:	00008517          	auipc	a0,0x8
    80000dba:	de250513          	addi	a0,a0,-542 # 80008b98 <wait_lock>
    80000dbe:	00005097          	auipc	ra,0x5
    80000dc2:	77e080e7          	jalr	1918(ra) # 8000653c <initlock>
    for (p = proc; p < &proc[NPROC]; p++)
    80000dc6:	00008497          	auipc	s1,0x8
    80000dca:	1ea48493          	addi	s1,s1,490 # 80008fb0 <proc>
    {
        initlock(&p->lock, "proc");
    80000dce:	00007b17          	auipc	s6,0x7
    80000dd2:	3a2b0b13          	addi	s6,s6,930 # 80008170 <etext+0x170>
        p->state = UNUSED;
        p->kstack = KSTACK((int)(p - proc));
    80000dd6:	8aa6                	mv	s5,s1
    80000dd8:	00007a17          	auipc	s4,0x7
    80000ddc:	228a0a13          	addi	s4,s4,552 # 80008000 <etext>
    80000de0:	04000937          	lui	s2,0x4000
    80000de4:	197d                	addi	s2,s2,-1
    80000de6:	0932                	slli	s2,s2,0xc
    for (p = proc; p < &proc[NPROC]; p++)
    80000de8:	00020997          	auipc	s3,0x20
    80000dec:	bc898993          	addi	s3,s3,-1080 # 800209b0 <tickslock>
        initlock(&p->lock, "proc");
    80000df0:	85da                	mv	a1,s6
    80000df2:	8526                	mv	a0,s1
    80000df4:	00005097          	auipc	ra,0x5
    80000df8:	748080e7          	jalr	1864(ra) # 8000653c <initlock>
        p->state = UNUSED;
    80000dfc:	0004ac23          	sw	zero,24(s1)
        p->kstack = KSTACK((int)(p - proc));
    80000e00:	415487b3          	sub	a5,s1,s5
    80000e04:	878d                	srai	a5,a5,0x3
    80000e06:	000a3703          	ld	a4,0(s4)
    80000e0a:	02e787b3          	mul	a5,a5,a4
    80000e0e:	2785                	addiw	a5,a5,1
    80000e10:	00d7979b          	slliw	a5,a5,0xd
    80000e14:	40f907b3          	sub	a5,s2,a5
    80000e18:	e0bc                	sd	a5,64(s1)
    for (p = proc; p < &proc[NPROC]; p++)
    80000e1a:	5e848493          	addi	s1,s1,1512
    80000e1e:	fd3499e3          	bne	s1,s3,80000df0 <procinit+0x6e>
    }
}
    80000e22:	70e2                	ld	ra,56(sp)
    80000e24:	7442                	ld	s0,48(sp)
    80000e26:	74a2                	ld	s1,40(sp)
    80000e28:	7902                	ld	s2,32(sp)
    80000e2a:	69e2                	ld	s3,24(sp)
    80000e2c:	6a42                	ld	s4,16(sp)
    80000e2e:	6aa2                	ld	s5,8(sp)
    80000e30:	6b02                	ld	s6,0(sp)
    80000e32:	6121                	addi	sp,sp,64
    80000e34:	8082                	ret

0000000080000e36 <cpuid>:

// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int cpuid()
{
    80000e36:	1141                	addi	sp,sp,-16
    80000e38:	e422                	sd	s0,8(sp)
    80000e3a:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000e3c:	8512                	mv	a0,tp
    int id = r_tp();
    return id;
}
    80000e3e:	2501                	sext.w	a0,a0
    80000e40:	6422                	ld	s0,8(sp)
    80000e42:	0141                	addi	sp,sp,16
    80000e44:	8082                	ret

0000000080000e46 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu *
mycpu(void)
{
    80000e46:	1141                	addi	sp,sp,-16
    80000e48:	e422                	sd	s0,8(sp)
    80000e4a:	0800                	addi	s0,sp,16
    80000e4c:	8792                	mv	a5,tp
    int id = cpuid();
    struct cpu *c = &cpus[id];
    80000e4e:	2781                	sext.w	a5,a5
    80000e50:	079e                	slli	a5,a5,0x7
    return c;
}
    80000e52:	00008517          	auipc	a0,0x8
    80000e56:	d5e50513          	addi	a0,a0,-674 # 80008bb0 <cpus>
    80000e5a:	953e                	add	a0,a0,a5
    80000e5c:	6422                	ld	s0,8(sp)
    80000e5e:	0141                	addi	sp,sp,16
    80000e60:	8082                	ret

0000000080000e62 <myproc>:

// Return the current struct proc *, or zero if none.
struct proc *
myproc(void)
{
    80000e62:	1101                	addi	sp,sp,-32
    80000e64:	ec06                	sd	ra,24(sp)
    80000e66:	e822                	sd	s0,16(sp)
    80000e68:	e426                	sd	s1,8(sp)
    80000e6a:	1000                	addi	s0,sp,32
    push_off();
    80000e6c:	00005097          	auipc	ra,0x5
    80000e70:	714080e7          	jalr	1812(ra) # 80006580 <push_off>
    80000e74:	8792                	mv	a5,tp
    struct cpu *c = mycpu();
    struct proc *p = c->proc;
    80000e76:	2781                	sext.w	a5,a5
    80000e78:	079e                	slli	a5,a5,0x7
    80000e7a:	00008717          	auipc	a4,0x8
    80000e7e:	d0670713          	addi	a4,a4,-762 # 80008b80 <pid_lock>
    80000e82:	97ba                	add	a5,a5,a4
    80000e84:	7b84                	ld	s1,48(a5)
    pop_off();
    80000e86:	00005097          	auipc	ra,0x5
    80000e8a:	79a080e7          	jalr	1946(ra) # 80006620 <pop_off>
    return p;
}
    80000e8e:	8526                	mv	a0,s1
    80000e90:	60e2                	ld	ra,24(sp)
    80000e92:	6442                	ld	s0,16(sp)
    80000e94:	64a2                	ld	s1,8(sp)
    80000e96:	6105                	addi	sp,sp,32
    80000e98:	8082                	ret

0000000080000e9a <forkret>:
}

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void forkret(void)
{
    80000e9a:	1141                	addi	sp,sp,-16
    80000e9c:	e406                	sd	ra,8(sp)
    80000e9e:	e022                	sd	s0,0(sp)
    80000ea0:	0800                	addi	s0,sp,16
    static int first = 1;

    // Still holding p->lock from scheduler.
    release(&myproc()->lock);
    80000ea2:	00000097          	auipc	ra,0x0
    80000ea6:	fc0080e7          	jalr	-64(ra) # 80000e62 <myproc>
    80000eaa:	00005097          	auipc	ra,0x5
    80000eae:	7d6080e7          	jalr	2006(ra) # 80006680 <release>

    if (first)
    80000eb2:	00008797          	auipc	a5,0x8
    80000eb6:	c0e7a783          	lw	a5,-1010(a5) # 80008ac0 <first.1694>
    80000eba:	eb89                	bnez	a5,80000ecc <forkret+0x32>
        // be run from main().
        first = 0;
        fsinit(ROOTDEV);
    }

    usertrapret();
    80000ebc:	00001097          	auipc	ra,0x1
    80000ec0:	c56080e7          	jalr	-938(ra) # 80001b12 <usertrapret>
}
    80000ec4:	60a2                	ld	ra,8(sp)
    80000ec6:	6402                	ld	s0,0(sp)
    80000ec8:	0141                	addi	sp,sp,16
    80000eca:	8082                	ret
        first = 0;
    80000ecc:	00008797          	auipc	a5,0x8
    80000ed0:	be07aa23          	sw	zero,-1036(a5) # 80008ac0 <first.1694>
        fsinit(ROOTDEV);
    80000ed4:	4505                	li	a0,1
    80000ed6:	00002097          	auipc	ra,0x2
    80000eda:	ace080e7          	jalr	-1330(ra) # 800029a4 <fsinit>
    80000ede:	bff9                	j	80000ebc <forkret+0x22>

0000000080000ee0 <allocpid>:
{
    80000ee0:	1101                	addi	sp,sp,-32
    80000ee2:	ec06                	sd	ra,24(sp)
    80000ee4:	e822                	sd	s0,16(sp)
    80000ee6:	e426                	sd	s1,8(sp)
    80000ee8:	e04a                	sd	s2,0(sp)
    80000eea:	1000                	addi	s0,sp,32
    acquire(&pid_lock);
    80000eec:	00008917          	auipc	s2,0x8
    80000ef0:	c9490913          	addi	s2,s2,-876 # 80008b80 <pid_lock>
    80000ef4:	854a                	mv	a0,s2
    80000ef6:	00005097          	auipc	ra,0x5
    80000efa:	6d6080e7          	jalr	1750(ra) # 800065cc <acquire>
    pid = nextpid;
    80000efe:	00008797          	auipc	a5,0x8
    80000f02:	bc678793          	addi	a5,a5,-1082 # 80008ac4 <nextpid>
    80000f06:	4384                	lw	s1,0(a5)
    nextpid = nextpid + 1;
    80000f08:	0014871b          	addiw	a4,s1,1
    80000f0c:	c398                	sw	a4,0(a5)
    release(&pid_lock);
    80000f0e:	854a                	mv	a0,s2
    80000f10:	00005097          	auipc	ra,0x5
    80000f14:	770080e7          	jalr	1904(ra) # 80006680 <release>
}
    80000f18:	8526                	mv	a0,s1
    80000f1a:	60e2                	ld	ra,24(sp)
    80000f1c:	6442                	ld	s0,16(sp)
    80000f1e:	64a2                	ld	s1,8(sp)
    80000f20:	6902                	ld	s2,0(sp)
    80000f22:	6105                	addi	sp,sp,32
    80000f24:	8082                	ret

0000000080000f26 <proc_pagetable>:
{
    80000f26:	1101                	addi	sp,sp,-32
    80000f28:	ec06                	sd	ra,24(sp)
    80000f2a:	e822                	sd	s0,16(sp)
    80000f2c:	e426                	sd	s1,8(sp)
    80000f2e:	e04a                	sd	s2,0(sp)
    80000f30:	1000                	addi	s0,sp,32
    80000f32:	892a                	mv	s2,a0
    pagetable = uvmcreate();
    80000f34:	00000097          	auipc	ra,0x0
    80000f38:	8b8080e7          	jalr	-1864(ra) # 800007ec <uvmcreate>
    80000f3c:	84aa                	mv	s1,a0
    if (pagetable == 0)
    80000f3e:	c121                	beqz	a0,80000f7e <proc_pagetable+0x58>
    if (mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000f40:	4729                	li	a4,10
    80000f42:	00006697          	auipc	a3,0x6
    80000f46:	0be68693          	addi	a3,a3,190 # 80007000 <_trampoline>
    80000f4a:	6605                	lui	a2,0x1
    80000f4c:	040005b7          	lui	a1,0x4000
    80000f50:	15fd                	addi	a1,a1,-1
    80000f52:	05b2                	slli	a1,a1,0xc
    80000f54:	fffff097          	auipc	ra,0xfffff
    80000f58:	5f8080e7          	jalr	1528(ra) # 8000054c <mappages>
    80000f5c:	02054863          	bltz	a0,80000f8c <proc_pagetable+0x66>
    if (mappages(pagetable, TRAPFRAME, PGSIZE,
    80000f60:	4719                	li	a4,6
    80000f62:	05893683          	ld	a3,88(s2)
    80000f66:	6605                	lui	a2,0x1
    80000f68:	020005b7          	lui	a1,0x2000
    80000f6c:	15fd                	addi	a1,a1,-1
    80000f6e:	05b6                	slli	a1,a1,0xd
    80000f70:	8526                	mv	a0,s1
    80000f72:	fffff097          	auipc	ra,0xfffff
    80000f76:	5da080e7          	jalr	1498(ra) # 8000054c <mappages>
    80000f7a:	02054163          	bltz	a0,80000f9c <proc_pagetable+0x76>
}
    80000f7e:	8526                	mv	a0,s1
    80000f80:	60e2                	ld	ra,24(sp)
    80000f82:	6442                	ld	s0,16(sp)
    80000f84:	64a2                	ld	s1,8(sp)
    80000f86:	6902                	ld	s2,0(sp)
    80000f88:	6105                	addi	sp,sp,32
    80000f8a:	8082                	ret
        uvmfree(pagetable, 0);
    80000f8c:	4581                	li	a1,0
    80000f8e:	8526                	mv	a0,s1
    80000f90:	00000097          	auipc	ra,0x0
    80000f94:	a60080e7          	jalr	-1440(ra) # 800009f0 <uvmfree>
        return 0;
    80000f98:	4481                	li	s1,0
    80000f9a:	b7d5                	j	80000f7e <proc_pagetable+0x58>
        uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000f9c:	4681                	li	a3,0
    80000f9e:	4605                	li	a2,1
    80000fa0:	040005b7          	lui	a1,0x4000
    80000fa4:	15fd                	addi	a1,a1,-1
    80000fa6:	05b2                	slli	a1,a1,0xc
    80000fa8:	8526                	mv	a0,s1
    80000faa:	fffff097          	auipc	ra,0xfffff
    80000fae:	78c080e7          	jalr	1932(ra) # 80000736 <uvmunmap>
        uvmfree(pagetable, 0);
    80000fb2:	4581                	li	a1,0
    80000fb4:	8526                	mv	a0,s1
    80000fb6:	00000097          	auipc	ra,0x0
    80000fba:	a3a080e7          	jalr	-1478(ra) # 800009f0 <uvmfree>
        return 0;
    80000fbe:	4481                	li	s1,0
    80000fc0:	bf7d                	j	80000f7e <proc_pagetable+0x58>

0000000080000fc2 <proc_freepagetable>:
{
    80000fc2:	1101                	addi	sp,sp,-32
    80000fc4:	ec06                	sd	ra,24(sp)
    80000fc6:	e822                	sd	s0,16(sp)
    80000fc8:	e426                	sd	s1,8(sp)
    80000fca:	e04a                	sd	s2,0(sp)
    80000fcc:	1000                	addi	s0,sp,32
    80000fce:	84aa                	mv	s1,a0
    80000fd0:	892e                	mv	s2,a1
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fd2:	4681                	li	a3,0
    80000fd4:	4605                	li	a2,1
    80000fd6:	040005b7          	lui	a1,0x4000
    80000fda:	15fd                	addi	a1,a1,-1
    80000fdc:	05b2                	slli	a1,a1,0xc
    80000fde:	fffff097          	auipc	ra,0xfffff
    80000fe2:	758080e7          	jalr	1880(ra) # 80000736 <uvmunmap>
    uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000fe6:	4681                	li	a3,0
    80000fe8:	4605                	li	a2,1
    80000fea:	020005b7          	lui	a1,0x2000
    80000fee:	15fd                	addi	a1,a1,-1
    80000ff0:	05b6                	slli	a1,a1,0xd
    80000ff2:	8526                	mv	a0,s1
    80000ff4:	fffff097          	auipc	ra,0xfffff
    80000ff8:	742080e7          	jalr	1858(ra) # 80000736 <uvmunmap>
    uvmfree(pagetable, sz);
    80000ffc:	85ca                	mv	a1,s2
    80000ffe:	8526                	mv	a0,s1
    80001000:	00000097          	auipc	ra,0x0
    80001004:	9f0080e7          	jalr	-1552(ra) # 800009f0 <uvmfree>
}
    80001008:	60e2                	ld	ra,24(sp)
    8000100a:	6442                	ld	s0,16(sp)
    8000100c:	64a2                	ld	s1,8(sp)
    8000100e:	6902                	ld	s2,0(sp)
    80001010:	6105                	addi	sp,sp,32
    80001012:	8082                	ret

0000000080001014 <freeproc>:
{
    80001014:	1101                	addi	sp,sp,-32
    80001016:	ec06                	sd	ra,24(sp)
    80001018:	e822                	sd	s0,16(sp)
    8000101a:	e426                	sd	s1,8(sp)
    8000101c:	1000                	addi	s0,sp,32
    8000101e:	84aa                	mv	s1,a0
    if (p->trapframe)
    80001020:	6d28                	ld	a0,88(a0)
    80001022:	c509                	beqz	a0,8000102c <freeproc+0x18>
        kfree((void *)p->trapframe);
    80001024:	fffff097          	auipc	ra,0xfffff
    80001028:	ff8080e7          	jalr	-8(ra) # 8000001c <kfree>
    p->trapframe = 0;
    8000102c:	0404bc23          	sd	zero,88(s1)
    if (p->pagetable)
    80001030:	68a8                	ld	a0,80(s1)
    80001032:	c511                	beqz	a0,8000103e <freeproc+0x2a>
        proc_freepagetable(p->pagetable, p->sz);
    80001034:	64ac                	ld	a1,72(s1)
    80001036:	00000097          	auipc	ra,0x0
    8000103a:	f8c080e7          	jalr	-116(ra) # 80000fc2 <proc_freepagetable>
    p->pagetable = 0;
    8000103e:	0404b823          	sd	zero,80(s1)
    p->sz = 0;
    80001042:	0404b423          	sd	zero,72(s1)
    p->pid = 0;
    80001046:	0204a823          	sw	zero,48(s1)
    p->parent = 0;
    8000104a:	0204bc23          	sd	zero,56(s1)
    p->name[0] = 0;
    8000104e:	14048c23          	sb	zero,344(s1)
    p->chan = 0;
    80001052:	0204b023          	sd	zero,32(s1)
    p->killed = 0;
    80001056:	0204a423          	sw	zero,40(s1)
    p->xstate = 0;
    8000105a:	0204a623          	sw	zero,44(s1)
    p->state = UNUSED;
    8000105e:	0004ac23          	sw	zero,24(s1)
}
    80001062:	60e2                	ld	ra,24(sp)
    80001064:	6442                	ld	s0,16(sp)
    80001066:	64a2                	ld	s1,8(sp)
    80001068:	6105                	addi	sp,sp,32
    8000106a:	8082                	ret

000000008000106c <allocproc>:
{
    8000106c:	1101                	addi	sp,sp,-32
    8000106e:	ec06                	sd	ra,24(sp)
    80001070:	e822                	sd	s0,16(sp)
    80001072:	e426                	sd	s1,8(sp)
    80001074:	e04a                	sd	s2,0(sp)
    80001076:	1000                	addi	s0,sp,32
    for (p = proc; p < &proc[NPROC]; p++)
    80001078:	00008497          	auipc	s1,0x8
    8000107c:	f3848493          	addi	s1,s1,-200 # 80008fb0 <proc>
    80001080:	00020917          	auipc	s2,0x20
    80001084:	93090913          	addi	s2,s2,-1744 # 800209b0 <tickslock>
        acquire(&p->lock);
    80001088:	8526                	mv	a0,s1
    8000108a:	00005097          	auipc	ra,0x5
    8000108e:	542080e7          	jalr	1346(ra) # 800065cc <acquire>
        if (p->state == UNUSED)
    80001092:	4c9c                	lw	a5,24(s1)
    80001094:	cf81                	beqz	a5,800010ac <allocproc+0x40>
            release(&p->lock);
    80001096:	8526                	mv	a0,s1
    80001098:	00005097          	auipc	ra,0x5
    8000109c:	5e8080e7          	jalr	1512(ra) # 80006680 <release>
    for (p = proc; p < &proc[NPROC]; p++)
    800010a0:	5e848493          	addi	s1,s1,1512
    800010a4:	ff2492e3          	bne	s1,s2,80001088 <allocproc+0x1c>
    return 0;
    800010a8:	4481                	li	s1,0
    800010aa:	a889                	j	800010fc <allocproc+0x90>
    p->pid = allocpid();
    800010ac:	00000097          	auipc	ra,0x0
    800010b0:	e34080e7          	jalr	-460(ra) # 80000ee0 <allocpid>
    800010b4:	d888                	sw	a0,48(s1)
    p->state = USED;
    800010b6:	4785                	li	a5,1
    800010b8:	cc9c                	sw	a5,24(s1)
    if ((p->trapframe = (struct trapframe *)kalloc()) == 0)
    800010ba:	fffff097          	auipc	ra,0xfffff
    800010be:	05e080e7          	jalr	94(ra) # 80000118 <kalloc>
    800010c2:	892a                	mv	s2,a0
    800010c4:	eca8                	sd	a0,88(s1)
    800010c6:	c131                	beqz	a0,8000110a <allocproc+0x9e>
    p->pagetable = proc_pagetable(p);
    800010c8:	8526                	mv	a0,s1
    800010ca:	00000097          	auipc	ra,0x0
    800010ce:	e5c080e7          	jalr	-420(ra) # 80000f26 <proc_pagetable>
    800010d2:	892a                	mv	s2,a0
    800010d4:	e8a8                	sd	a0,80(s1)
    if (p->pagetable == 0)
    800010d6:	c531                	beqz	a0,80001122 <allocproc+0xb6>
    memset(&p->context, 0, sizeof(p->context));
    800010d8:	07000613          	li	a2,112
    800010dc:	4581                	li	a1,0
    800010de:	06048513          	addi	a0,s1,96
    800010e2:	fffff097          	auipc	ra,0xfffff
    800010e6:	096080e7          	jalr	150(ra) # 80000178 <memset>
    p->context.ra = (uint64)forkret;
    800010ea:	00000797          	auipc	a5,0x0
    800010ee:	db078793          	addi	a5,a5,-592 # 80000e9a <forkret>
    800010f2:	f0bc                	sd	a5,96(s1)
    p->context.sp = p->kstack + PGSIZE;
    800010f4:	60bc                	ld	a5,64(s1)
    800010f6:	6705                	lui	a4,0x1
    800010f8:	97ba                	add	a5,a5,a4
    800010fa:	f4bc                	sd	a5,104(s1)
}
    800010fc:	8526                	mv	a0,s1
    800010fe:	60e2                	ld	ra,24(sp)
    80001100:	6442                	ld	s0,16(sp)
    80001102:	64a2                	ld	s1,8(sp)
    80001104:	6902                	ld	s2,0(sp)
    80001106:	6105                	addi	sp,sp,32
    80001108:	8082                	ret
        freeproc(p);
    8000110a:	8526                	mv	a0,s1
    8000110c:	00000097          	auipc	ra,0x0
    80001110:	f08080e7          	jalr	-248(ra) # 80001014 <freeproc>
        release(&p->lock);
    80001114:	8526                	mv	a0,s1
    80001116:	00005097          	auipc	ra,0x5
    8000111a:	56a080e7          	jalr	1386(ra) # 80006680 <release>
        return 0;
    8000111e:	84ca                	mv	s1,s2
    80001120:	bff1                	j	800010fc <allocproc+0x90>
        freeproc(p);
    80001122:	8526                	mv	a0,s1
    80001124:	00000097          	auipc	ra,0x0
    80001128:	ef0080e7          	jalr	-272(ra) # 80001014 <freeproc>
        release(&p->lock);
    8000112c:	8526                	mv	a0,s1
    8000112e:	00005097          	auipc	ra,0x5
    80001132:	552080e7          	jalr	1362(ra) # 80006680 <release>
        return 0;
    80001136:	84ca                	mv	s1,s2
    80001138:	b7d1                	j	800010fc <allocproc+0x90>

000000008000113a <userinit>:
{
    8000113a:	1101                	addi	sp,sp,-32
    8000113c:	ec06                	sd	ra,24(sp)
    8000113e:	e822                	sd	s0,16(sp)
    80001140:	e426                	sd	s1,8(sp)
    80001142:	1000                	addi	s0,sp,32
    p = allocproc();
    80001144:	00000097          	auipc	ra,0x0
    80001148:	f28080e7          	jalr	-216(ra) # 8000106c <allocproc>
    8000114c:	84aa                	mv	s1,a0
    initproc = p;
    8000114e:	00008797          	auipc	a5,0x8
    80001152:	9ea7b923          	sd	a0,-1550(a5) # 80008b40 <initproc>
    uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001156:	03400613          	li	a2,52
    8000115a:	00008597          	auipc	a1,0x8
    8000115e:	97658593          	addi	a1,a1,-1674 # 80008ad0 <initcode>
    80001162:	6928                	ld	a0,80(a0)
    80001164:	fffff097          	auipc	ra,0xfffff
    80001168:	6b6080e7          	jalr	1718(ra) # 8000081a <uvmfirst>
    p->sz = PGSIZE;
    8000116c:	6785                	lui	a5,0x1
    8000116e:	e4bc                	sd	a5,72(s1)
    p->trapframe->epc = 0;     // user program counter
    80001170:	6cb8                	ld	a4,88(s1)
    80001172:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
    p->trapframe->sp = PGSIZE; // user stack pointer
    80001176:	6cb8                	ld	a4,88(s1)
    80001178:	fb1c                	sd	a5,48(a4)
    safestrcpy(p->name, "initcode", sizeof(p->name));
    8000117a:	4641                	li	a2,16
    8000117c:	00007597          	auipc	a1,0x7
    80001180:	ffc58593          	addi	a1,a1,-4 # 80008178 <etext+0x178>
    80001184:	15848513          	addi	a0,s1,344
    80001188:	fffff097          	auipc	ra,0xfffff
    8000118c:	142080e7          	jalr	322(ra) # 800002ca <safestrcpy>
    p->cwd = namei("/");
    80001190:	00007517          	auipc	a0,0x7
    80001194:	ff850513          	addi	a0,a0,-8 # 80008188 <etext+0x188>
    80001198:	00002097          	auipc	ra,0x2
    8000119c:	22e080e7          	jalr	558(ra) # 800033c6 <namei>
    800011a0:	14a4b823          	sd	a0,336(s1)
    p->state = RUNNABLE;
    800011a4:	478d                	li	a5,3
    800011a6:	cc9c                	sw	a5,24(s1)
    release(&p->lock);
    800011a8:	8526                	mv	a0,s1
    800011aa:	00005097          	auipc	ra,0x5
    800011ae:	4d6080e7          	jalr	1238(ra) # 80006680 <release>
}
    800011b2:	60e2                	ld	ra,24(sp)
    800011b4:	6442                	ld	s0,16(sp)
    800011b6:	64a2                	ld	s1,8(sp)
    800011b8:	6105                	addi	sp,sp,32
    800011ba:	8082                	ret

00000000800011bc <growproc>:
{
    800011bc:	1101                	addi	sp,sp,-32
    800011be:	ec06                	sd	ra,24(sp)
    800011c0:	e822                	sd	s0,16(sp)
    800011c2:	e426                	sd	s1,8(sp)
    800011c4:	e04a                	sd	s2,0(sp)
    800011c6:	1000                	addi	s0,sp,32
    800011c8:	892a                	mv	s2,a0
    struct proc *p = myproc();
    800011ca:	00000097          	auipc	ra,0x0
    800011ce:	c98080e7          	jalr	-872(ra) # 80000e62 <myproc>
    800011d2:	84aa                	mv	s1,a0
    sz = p->sz;
    800011d4:	652c                	ld	a1,72(a0)
    if (n > 0)
    800011d6:	01204c63          	bgtz	s2,800011ee <growproc+0x32>
    else if (n < 0)
    800011da:	02094663          	bltz	s2,80001206 <growproc+0x4a>
    p->sz = sz;
    800011de:	e4ac                	sd	a1,72(s1)
    return 0;
    800011e0:	4501                	li	a0,0
}
    800011e2:	60e2                	ld	ra,24(sp)
    800011e4:	6442                	ld	s0,16(sp)
    800011e6:	64a2                	ld	s1,8(sp)
    800011e8:	6902                	ld	s2,0(sp)
    800011ea:	6105                	addi	sp,sp,32
    800011ec:	8082                	ret
        if ((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0)
    800011ee:	4691                	li	a3,4
    800011f0:	00b90633          	add	a2,s2,a1
    800011f4:	6928                	ld	a0,80(a0)
    800011f6:	fffff097          	auipc	ra,0xfffff
    800011fa:	6de080e7          	jalr	1758(ra) # 800008d4 <uvmalloc>
    800011fe:	85aa                	mv	a1,a0
    80001200:	fd79                	bnez	a0,800011de <growproc+0x22>
            return -1;
    80001202:	557d                	li	a0,-1
    80001204:	bff9                	j	800011e2 <growproc+0x26>
        sz = uvmdealloc(p->pagetable, sz, sz + n);
    80001206:	00b90633          	add	a2,s2,a1
    8000120a:	6928                	ld	a0,80(a0)
    8000120c:	fffff097          	auipc	ra,0xfffff
    80001210:	680080e7          	jalr	1664(ra) # 8000088c <uvmdealloc>
    80001214:	85aa                	mv	a1,a0
    80001216:	b7e1                	j	800011de <growproc+0x22>

0000000080001218 <fork>:
{
    80001218:	7179                	addi	sp,sp,-48
    8000121a:	f406                	sd	ra,40(sp)
    8000121c:	f022                	sd	s0,32(sp)
    8000121e:	ec26                	sd	s1,24(sp)
    80001220:	e84a                	sd	s2,16(sp)
    80001222:	e44e                	sd	s3,8(sp)
    80001224:	e052                	sd	s4,0(sp)
    80001226:	1800                	addi	s0,sp,48
    struct proc *p = myproc();
    80001228:	00000097          	auipc	ra,0x0
    8000122c:	c3a080e7          	jalr	-966(ra) # 80000e62 <myproc>
    80001230:	892a                	mv	s2,a0
    if ((np = allocproc()) == 0)
    80001232:	00000097          	auipc	ra,0x0
    80001236:	e3a080e7          	jalr	-454(ra) # 8000106c <allocproc>
    8000123a:	10050b63          	beqz	a0,80001350 <fork+0x138>
    8000123e:	89aa                	mv	s3,a0
    if (uvmcopy(p->pagetable, np->pagetable, p->sz) < 0)
    80001240:	04893603          	ld	a2,72(s2)
    80001244:	692c                	ld	a1,80(a0)
    80001246:	05093503          	ld	a0,80(s2)
    8000124a:	fffff097          	auipc	ra,0xfffff
    8000124e:	7de080e7          	jalr	2014(ra) # 80000a28 <uvmcopy>
    80001252:	04054663          	bltz	a0,8000129e <fork+0x86>
    np->sz = p->sz;
    80001256:	04893783          	ld	a5,72(s2)
    8000125a:	04f9b423          	sd	a5,72(s3)
    *(np->trapframe) = *(p->trapframe);
    8000125e:	05893683          	ld	a3,88(s2)
    80001262:	87b6                	mv	a5,a3
    80001264:	0589b703          	ld	a4,88(s3)
    80001268:	12068693          	addi	a3,a3,288
    8000126c:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    80001270:	6788                	ld	a0,8(a5)
    80001272:	6b8c                	ld	a1,16(a5)
    80001274:	6f90                	ld	a2,24(a5)
    80001276:	01073023          	sd	a6,0(a4)
    8000127a:	e708                	sd	a0,8(a4)
    8000127c:	eb0c                	sd	a1,16(a4)
    8000127e:	ef10                	sd	a2,24(a4)
    80001280:	02078793          	addi	a5,a5,32
    80001284:	02070713          	addi	a4,a4,32
    80001288:	fed792e3          	bne	a5,a3,8000126c <fork+0x54>
    np->trapframe->a0 = 0;
    8000128c:	0589b783          	ld	a5,88(s3)
    80001290:	0607b823          	sd	zero,112(a5)
    80001294:	0d000493          	li	s1,208
    for (i = 0; i < NOFILE; i++)
    80001298:	15000a13          	li	s4,336
    8000129c:	a03d                	j	800012ca <fork+0xb2>
        freeproc(np);
    8000129e:	854e                	mv	a0,s3
    800012a0:	00000097          	auipc	ra,0x0
    800012a4:	d74080e7          	jalr	-652(ra) # 80001014 <freeproc>
        release(&np->lock);
    800012a8:	854e                	mv	a0,s3
    800012aa:	00005097          	auipc	ra,0x5
    800012ae:	3d6080e7          	jalr	982(ra) # 80006680 <release>
        return -1;
    800012b2:	5a7d                	li	s4,-1
    800012b4:	a069                	j	8000133e <fork+0x126>
            np->ofile[i] = filedup(p->ofile[i]);
    800012b6:	00002097          	auipc	ra,0x2
    800012ba:	7a6080e7          	jalr	1958(ra) # 80003a5c <filedup>
    800012be:	009987b3          	add	a5,s3,s1
    800012c2:	e388                	sd	a0,0(a5)
    for (i = 0; i < NOFILE; i++)
    800012c4:	04a1                	addi	s1,s1,8
    800012c6:	01448763          	beq	s1,s4,800012d4 <fork+0xbc>
        if (p->ofile[i])
    800012ca:	009907b3          	add	a5,s2,s1
    800012ce:	6388                	ld	a0,0(a5)
    800012d0:	f17d                	bnez	a0,800012b6 <fork+0x9e>
    800012d2:	bfcd                	j	800012c4 <fork+0xac>
    np->cwd = idup(p->cwd);
    800012d4:	15093503          	ld	a0,336(s2)
    800012d8:	00002097          	auipc	ra,0x2
    800012dc:	90a080e7          	jalr	-1782(ra) # 80002be2 <idup>
    800012e0:	14a9b823          	sd	a0,336(s3)
    safestrcpy(np->name, p->name, sizeof(p->name));
    800012e4:	4641                	li	a2,16
    800012e6:	15890593          	addi	a1,s2,344
    800012ea:	15898513          	addi	a0,s3,344
    800012ee:	fffff097          	auipc	ra,0xfffff
    800012f2:	fdc080e7          	jalr	-36(ra) # 800002ca <safestrcpy>
    pid = np->pid;
    800012f6:	0309aa03          	lw	s4,48(s3)
    release(&np->lock);
    800012fa:	854e                	mv	a0,s3
    800012fc:	00005097          	auipc	ra,0x5
    80001300:	384080e7          	jalr	900(ra) # 80006680 <release>
    acquire(&wait_lock);
    80001304:	00008497          	auipc	s1,0x8
    80001308:	89448493          	addi	s1,s1,-1900 # 80008b98 <wait_lock>
    8000130c:	8526                	mv	a0,s1
    8000130e:	00005097          	auipc	ra,0x5
    80001312:	2be080e7          	jalr	702(ra) # 800065cc <acquire>
    np->parent = p;
    80001316:	0329bc23          	sd	s2,56(s3)
    release(&wait_lock);
    8000131a:	8526                	mv	a0,s1
    8000131c:	00005097          	auipc	ra,0x5
    80001320:	364080e7          	jalr	868(ra) # 80006680 <release>
    acquire(&np->lock);
    80001324:	854e                	mv	a0,s3
    80001326:	00005097          	auipc	ra,0x5
    8000132a:	2a6080e7          	jalr	678(ra) # 800065cc <acquire>
    np->state = RUNNABLE;
    8000132e:	478d                	li	a5,3
    80001330:	00f9ac23          	sw	a5,24(s3)
    release(&np->lock);
    80001334:	854e                	mv	a0,s3
    80001336:	00005097          	auipc	ra,0x5
    8000133a:	34a080e7          	jalr	842(ra) # 80006680 <release>
}
    8000133e:	8552                	mv	a0,s4
    80001340:	70a2                	ld	ra,40(sp)
    80001342:	7402                	ld	s0,32(sp)
    80001344:	64e2                	ld	s1,24(sp)
    80001346:	6942                	ld	s2,16(sp)
    80001348:	69a2                	ld	s3,8(sp)
    8000134a:	6a02                	ld	s4,0(sp)
    8000134c:	6145                	addi	sp,sp,48
    8000134e:	8082                	ret
        return -1;
    80001350:	5a7d                	li	s4,-1
    80001352:	b7f5                	j	8000133e <fork+0x126>

0000000080001354 <scheduler>:
{
    80001354:	7139                	addi	sp,sp,-64
    80001356:	fc06                	sd	ra,56(sp)
    80001358:	f822                	sd	s0,48(sp)
    8000135a:	f426                	sd	s1,40(sp)
    8000135c:	f04a                	sd	s2,32(sp)
    8000135e:	ec4e                	sd	s3,24(sp)
    80001360:	e852                	sd	s4,16(sp)
    80001362:	e456                	sd	s5,8(sp)
    80001364:	e05a                	sd	s6,0(sp)
    80001366:	0080                	addi	s0,sp,64
    80001368:	8792                	mv	a5,tp
    int id = r_tp();
    8000136a:	2781                	sext.w	a5,a5
    c->proc = 0;
    8000136c:	00779a93          	slli	s5,a5,0x7
    80001370:	00008717          	auipc	a4,0x8
    80001374:	81070713          	addi	a4,a4,-2032 # 80008b80 <pid_lock>
    80001378:	9756                	add	a4,a4,s5
    8000137a:	02073823          	sd	zero,48(a4)
                swtch(&c->context, &p->context);
    8000137e:	00008717          	auipc	a4,0x8
    80001382:	83a70713          	addi	a4,a4,-1990 # 80008bb8 <cpus+0x8>
    80001386:	9aba                	add	s5,s5,a4
            if (p->state == RUNNABLE)
    80001388:	498d                	li	s3,3
                p->state = RUNNING;
    8000138a:	4b11                	li	s6,4
                c->proc = p;
    8000138c:	079e                	slli	a5,a5,0x7
    8000138e:	00007a17          	auipc	s4,0x7
    80001392:	7f2a0a13          	addi	s4,s4,2034 # 80008b80 <pid_lock>
    80001396:	9a3e                	add	s4,s4,a5
        for (p = proc; p < &proc[NPROC]; p++)
    80001398:	0001f917          	auipc	s2,0x1f
    8000139c:	61890913          	addi	s2,s2,1560 # 800209b0 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800013a0:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800013a4:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800013a8:	10079073          	csrw	sstatus,a5
    800013ac:	00008497          	auipc	s1,0x8
    800013b0:	c0448493          	addi	s1,s1,-1020 # 80008fb0 <proc>
    800013b4:	a03d                	j	800013e2 <scheduler+0x8e>
                p->state = RUNNING;
    800013b6:	0164ac23          	sw	s6,24(s1)
                c->proc = p;
    800013ba:	029a3823          	sd	s1,48(s4)
                swtch(&c->context, &p->context);
    800013be:	06048593          	addi	a1,s1,96
    800013c2:	8556                	mv	a0,s5
    800013c4:	00000097          	auipc	ra,0x0
    800013c8:	6a4080e7          	jalr	1700(ra) # 80001a68 <swtch>
                c->proc = 0;
    800013cc:	020a3823          	sd	zero,48(s4)
            release(&p->lock);
    800013d0:	8526                	mv	a0,s1
    800013d2:	00005097          	auipc	ra,0x5
    800013d6:	2ae080e7          	jalr	686(ra) # 80006680 <release>
        for (p = proc; p < &proc[NPROC]; p++)
    800013da:	5e848493          	addi	s1,s1,1512
    800013de:	fd2481e3          	beq	s1,s2,800013a0 <scheduler+0x4c>
            acquire(&p->lock);
    800013e2:	8526                	mv	a0,s1
    800013e4:	00005097          	auipc	ra,0x5
    800013e8:	1e8080e7          	jalr	488(ra) # 800065cc <acquire>
            if (p->state == RUNNABLE)
    800013ec:	4c9c                	lw	a5,24(s1)
    800013ee:	ff3791e3          	bne	a5,s3,800013d0 <scheduler+0x7c>
    800013f2:	b7d1                	j	800013b6 <scheduler+0x62>

00000000800013f4 <sched>:
{
    800013f4:	7179                	addi	sp,sp,-48
    800013f6:	f406                	sd	ra,40(sp)
    800013f8:	f022                	sd	s0,32(sp)
    800013fa:	ec26                	sd	s1,24(sp)
    800013fc:	e84a                	sd	s2,16(sp)
    800013fe:	e44e                	sd	s3,8(sp)
    80001400:	1800                	addi	s0,sp,48
    struct proc *p = myproc();
    80001402:	00000097          	auipc	ra,0x0
    80001406:	a60080e7          	jalr	-1440(ra) # 80000e62 <myproc>
    8000140a:	84aa                	mv	s1,a0
    if (!holding(&p->lock))
    8000140c:	00005097          	auipc	ra,0x5
    80001410:	146080e7          	jalr	326(ra) # 80006552 <holding>
    80001414:	c93d                	beqz	a0,8000148a <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001416:	8792                	mv	a5,tp
    if (mycpu()->noff != 1)
    80001418:	2781                	sext.w	a5,a5
    8000141a:	079e                	slli	a5,a5,0x7
    8000141c:	00007717          	auipc	a4,0x7
    80001420:	76470713          	addi	a4,a4,1892 # 80008b80 <pid_lock>
    80001424:	97ba                	add	a5,a5,a4
    80001426:	0a87a703          	lw	a4,168(a5)
    8000142a:	4785                	li	a5,1
    8000142c:	06f71763          	bne	a4,a5,8000149a <sched+0xa6>
    if (p->state == RUNNING)
    80001430:	4c98                	lw	a4,24(s1)
    80001432:	4791                	li	a5,4
    80001434:	06f70b63          	beq	a4,a5,800014aa <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001438:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000143c:	8b89                	andi	a5,a5,2
    if (intr_get())
    8000143e:	efb5                	bnez	a5,800014ba <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001440:	8792                	mv	a5,tp
    intena = mycpu()->intena;
    80001442:	00007917          	auipc	s2,0x7
    80001446:	73e90913          	addi	s2,s2,1854 # 80008b80 <pid_lock>
    8000144a:	2781                	sext.w	a5,a5
    8000144c:	079e                	slli	a5,a5,0x7
    8000144e:	97ca                	add	a5,a5,s2
    80001450:	0ac7a983          	lw	s3,172(a5)
    80001454:	8792                	mv	a5,tp
    swtch(&p->context, &mycpu()->context);
    80001456:	2781                	sext.w	a5,a5
    80001458:	079e                	slli	a5,a5,0x7
    8000145a:	00007597          	auipc	a1,0x7
    8000145e:	75e58593          	addi	a1,a1,1886 # 80008bb8 <cpus+0x8>
    80001462:	95be                	add	a1,a1,a5
    80001464:	06048513          	addi	a0,s1,96
    80001468:	00000097          	auipc	ra,0x0
    8000146c:	600080e7          	jalr	1536(ra) # 80001a68 <swtch>
    80001470:	8792                	mv	a5,tp
    mycpu()->intena = intena;
    80001472:	2781                	sext.w	a5,a5
    80001474:	079e                	slli	a5,a5,0x7
    80001476:	97ca                	add	a5,a5,s2
    80001478:	0b37a623          	sw	s3,172(a5)
}
    8000147c:	70a2                	ld	ra,40(sp)
    8000147e:	7402                	ld	s0,32(sp)
    80001480:	64e2                	ld	s1,24(sp)
    80001482:	6942                	ld	s2,16(sp)
    80001484:	69a2                	ld	s3,8(sp)
    80001486:	6145                	addi	sp,sp,48
    80001488:	8082                	ret
        panic("sched p->lock");
    8000148a:	00007517          	auipc	a0,0x7
    8000148e:	d0650513          	addi	a0,a0,-762 # 80008190 <etext+0x190>
    80001492:	00005097          	auipc	ra,0x5
    80001496:	bf0080e7          	jalr	-1040(ra) # 80006082 <panic>
        panic("sched locks");
    8000149a:	00007517          	auipc	a0,0x7
    8000149e:	d0650513          	addi	a0,a0,-762 # 800081a0 <etext+0x1a0>
    800014a2:	00005097          	auipc	ra,0x5
    800014a6:	be0080e7          	jalr	-1056(ra) # 80006082 <panic>
        panic("sched running");
    800014aa:	00007517          	auipc	a0,0x7
    800014ae:	d0650513          	addi	a0,a0,-762 # 800081b0 <etext+0x1b0>
    800014b2:	00005097          	auipc	ra,0x5
    800014b6:	bd0080e7          	jalr	-1072(ra) # 80006082 <panic>
        panic("sched interruptible");
    800014ba:	00007517          	auipc	a0,0x7
    800014be:	d0650513          	addi	a0,a0,-762 # 800081c0 <etext+0x1c0>
    800014c2:	00005097          	auipc	ra,0x5
    800014c6:	bc0080e7          	jalr	-1088(ra) # 80006082 <panic>

00000000800014ca <yield>:
{
    800014ca:	1101                	addi	sp,sp,-32
    800014cc:	ec06                	sd	ra,24(sp)
    800014ce:	e822                	sd	s0,16(sp)
    800014d0:	e426                	sd	s1,8(sp)
    800014d2:	1000                	addi	s0,sp,32
    struct proc *p = myproc();
    800014d4:	00000097          	auipc	ra,0x0
    800014d8:	98e080e7          	jalr	-1650(ra) # 80000e62 <myproc>
    800014dc:	84aa                	mv	s1,a0
    acquire(&p->lock);
    800014de:	00005097          	auipc	ra,0x5
    800014e2:	0ee080e7          	jalr	238(ra) # 800065cc <acquire>
    p->state = RUNNABLE;
    800014e6:	478d                	li	a5,3
    800014e8:	cc9c                	sw	a5,24(s1)
    sched();
    800014ea:	00000097          	auipc	ra,0x0
    800014ee:	f0a080e7          	jalr	-246(ra) # 800013f4 <sched>
    release(&p->lock);
    800014f2:	8526                	mv	a0,s1
    800014f4:	00005097          	auipc	ra,0x5
    800014f8:	18c080e7          	jalr	396(ra) # 80006680 <release>
}
    800014fc:	60e2                	ld	ra,24(sp)
    800014fe:	6442                	ld	s0,16(sp)
    80001500:	64a2                	ld	s1,8(sp)
    80001502:	6105                	addi	sp,sp,32
    80001504:	8082                	ret

0000000080001506 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void sleep(void *chan, struct spinlock *lk)
{
    80001506:	7179                	addi	sp,sp,-48
    80001508:	f406                	sd	ra,40(sp)
    8000150a:	f022                	sd	s0,32(sp)
    8000150c:	ec26                	sd	s1,24(sp)
    8000150e:	e84a                	sd	s2,16(sp)
    80001510:	e44e                	sd	s3,8(sp)
    80001512:	1800                	addi	s0,sp,48
    80001514:	89aa                	mv	s3,a0
    80001516:	892e                	mv	s2,a1
    struct proc *p = myproc();
    80001518:	00000097          	auipc	ra,0x0
    8000151c:	94a080e7          	jalr	-1718(ra) # 80000e62 <myproc>
    80001520:	84aa                	mv	s1,a0
    // Once we hold p->lock, we can be
    // guaranteed that we won't miss any wakeup
    // (wakeup locks p->lock),
    // so it's okay to release lk.

    acquire(&p->lock); // DOC: sleeplock1
    80001522:	00005097          	auipc	ra,0x5
    80001526:	0aa080e7          	jalr	170(ra) # 800065cc <acquire>
    release(lk);
    8000152a:	854a                	mv	a0,s2
    8000152c:	00005097          	auipc	ra,0x5
    80001530:	154080e7          	jalr	340(ra) # 80006680 <release>

    // Go to sleep.
    p->chan = chan;
    80001534:	0334b023          	sd	s3,32(s1)
    p->state = SLEEPING;
    80001538:	4789                	li	a5,2
    8000153a:	cc9c                	sw	a5,24(s1)

    sched();
    8000153c:	00000097          	auipc	ra,0x0
    80001540:	eb8080e7          	jalr	-328(ra) # 800013f4 <sched>

    // Tidy up.
    p->chan = 0;
    80001544:	0204b023          	sd	zero,32(s1)

    // Reacquire original lock.
    release(&p->lock);
    80001548:	8526                	mv	a0,s1
    8000154a:	00005097          	auipc	ra,0x5
    8000154e:	136080e7          	jalr	310(ra) # 80006680 <release>
    acquire(lk);
    80001552:	854a                	mv	a0,s2
    80001554:	00005097          	auipc	ra,0x5
    80001558:	078080e7          	jalr	120(ra) # 800065cc <acquire>
}
    8000155c:	70a2                	ld	ra,40(sp)
    8000155e:	7402                	ld	s0,32(sp)
    80001560:	64e2                	ld	s1,24(sp)
    80001562:	6942                	ld	s2,16(sp)
    80001564:	69a2                	ld	s3,8(sp)
    80001566:	6145                	addi	sp,sp,48
    80001568:	8082                	ret

000000008000156a <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void wakeup(void *chan)
{
    8000156a:	7139                	addi	sp,sp,-64
    8000156c:	fc06                	sd	ra,56(sp)
    8000156e:	f822                	sd	s0,48(sp)
    80001570:	f426                	sd	s1,40(sp)
    80001572:	f04a                	sd	s2,32(sp)
    80001574:	ec4e                	sd	s3,24(sp)
    80001576:	e852                	sd	s4,16(sp)
    80001578:	e456                	sd	s5,8(sp)
    8000157a:	0080                	addi	s0,sp,64
    8000157c:	8a2a                	mv	s4,a0
    struct proc *p;

    for (p = proc; p < &proc[NPROC]; p++)
    8000157e:	00008497          	auipc	s1,0x8
    80001582:	a3248493          	addi	s1,s1,-1486 # 80008fb0 <proc>
    {
        if (p != myproc())
        {
            acquire(&p->lock);
            if (p->state == SLEEPING && p->chan == chan)
    80001586:	4989                	li	s3,2
            {
                p->state = RUNNABLE;
    80001588:	4a8d                	li	s5,3
    for (p = proc; p < &proc[NPROC]; p++)
    8000158a:	0001f917          	auipc	s2,0x1f
    8000158e:	42690913          	addi	s2,s2,1062 # 800209b0 <tickslock>
    80001592:	a821                	j	800015aa <wakeup+0x40>
                p->state = RUNNABLE;
    80001594:	0154ac23          	sw	s5,24(s1)
            }
            release(&p->lock);
    80001598:	8526                	mv	a0,s1
    8000159a:	00005097          	auipc	ra,0x5
    8000159e:	0e6080e7          	jalr	230(ra) # 80006680 <release>
    for (p = proc; p < &proc[NPROC]; p++)
    800015a2:	5e848493          	addi	s1,s1,1512
    800015a6:	03248463          	beq	s1,s2,800015ce <wakeup+0x64>
        if (p != myproc())
    800015aa:	00000097          	auipc	ra,0x0
    800015ae:	8b8080e7          	jalr	-1864(ra) # 80000e62 <myproc>
    800015b2:	fea488e3          	beq	s1,a0,800015a2 <wakeup+0x38>
            acquire(&p->lock);
    800015b6:	8526                	mv	a0,s1
    800015b8:	00005097          	auipc	ra,0x5
    800015bc:	014080e7          	jalr	20(ra) # 800065cc <acquire>
            if (p->state == SLEEPING && p->chan == chan)
    800015c0:	4c9c                	lw	a5,24(s1)
    800015c2:	fd379be3          	bne	a5,s3,80001598 <wakeup+0x2e>
    800015c6:	709c                	ld	a5,32(s1)
    800015c8:	fd4798e3          	bne	a5,s4,80001598 <wakeup+0x2e>
    800015cc:	b7e1                	j	80001594 <wakeup+0x2a>
        }
    }
}
    800015ce:	70e2                	ld	ra,56(sp)
    800015d0:	7442                	ld	s0,48(sp)
    800015d2:	74a2                	ld	s1,40(sp)
    800015d4:	7902                	ld	s2,32(sp)
    800015d6:	69e2                	ld	s3,24(sp)
    800015d8:	6a42                	ld	s4,16(sp)
    800015da:	6aa2                	ld	s5,8(sp)
    800015dc:	6121                	addi	sp,sp,64
    800015de:	8082                	ret

00000000800015e0 <reparent>:
{
    800015e0:	7179                	addi	sp,sp,-48
    800015e2:	f406                	sd	ra,40(sp)
    800015e4:	f022                	sd	s0,32(sp)
    800015e6:	ec26                	sd	s1,24(sp)
    800015e8:	e84a                	sd	s2,16(sp)
    800015ea:	e44e                	sd	s3,8(sp)
    800015ec:	e052                	sd	s4,0(sp)
    800015ee:	1800                	addi	s0,sp,48
    800015f0:	892a                	mv	s2,a0
    for (pp = proc; pp < &proc[NPROC]; pp++)
    800015f2:	00008497          	auipc	s1,0x8
    800015f6:	9be48493          	addi	s1,s1,-1602 # 80008fb0 <proc>
            pp->parent = initproc;
    800015fa:	00007a17          	auipc	s4,0x7
    800015fe:	546a0a13          	addi	s4,s4,1350 # 80008b40 <initproc>
    for (pp = proc; pp < &proc[NPROC]; pp++)
    80001602:	0001f997          	auipc	s3,0x1f
    80001606:	3ae98993          	addi	s3,s3,942 # 800209b0 <tickslock>
    8000160a:	a029                	j	80001614 <reparent+0x34>
    8000160c:	5e848493          	addi	s1,s1,1512
    80001610:	01348d63          	beq	s1,s3,8000162a <reparent+0x4a>
        if (pp->parent == p)
    80001614:	7c9c                	ld	a5,56(s1)
    80001616:	ff279be3          	bne	a5,s2,8000160c <reparent+0x2c>
            pp->parent = initproc;
    8000161a:	000a3503          	ld	a0,0(s4)
    8000161e:	fc88                	sd	a0,56(s1)
            wakeup(initproc);
    80001620:	00000097          	auipc	ra,0x0
    80001624:	f4a080e7          	jalr	-182(ra) # 8000156a <wakeup>
    80001628:	b7d5                	j	8000160c <reparent+0x2c>
}
    8000162a:	70a2                	ld	ra,40(sp)
    8000162c:	7402                	ld	s0,32(sp)
    8000162e:	64e2                	ld	s1,24(sp)
    80001630:	6942                	ld	s2,16(sp)
    80001632:	69a2                	ld	s3,8(sp)
    80001634:	6a02                	ld	s4,0(sp)
    80001636:	6145                	addi	sp,sp,48
    80001638:	8082                	ret

000000008000163a <exit>:
{
    8000163a:	7179                	addi	sp,sp,-48
    8000163c:	f406                	sd	ra,40(sp)
    8000163e:	f022                	sd	s0,32(sp)
    80001640:	ec26                	sd	s1,24(sp)
    80001642:	e84a                	sd	s2,16(sp)
    80001644:	e44e                	sd	s3,8(sp)
    80001646:	e052                	sd	s4,0(sp)
    80001648:	1800                	addi	s0,sp,48
    8000164a:	8a2a                	mv	s4,a0
    struct proc *p = myproc();
    8000164c:	00000097          	auipc	ra,0x0
    80001650:	816080e7          	jalr	-2026(ra) # 80000e62 <myproc>
    80001654:	89aa                	mv	s3,a0
    if (p == initproc)
    80001656:	00007797          	auipc	a5,0x7
    8000165a:	4ea7b783          	ld	a5,1258(a5) # 80008b40 <initproc>
    8000165e:	0d050493          	addi	s1,a0,208
    80001662:	15050913          	addi	s2,a0,336
    80001666:	02a79363          	bne	a5,a0,8000168c <exit+0x52>
        panic("init exiting");
    8000166a:	00007517          	auipc	a0,0x7
    8000166e:	b6e50513          	addi	a0,a0,-1170 # 800081d8 <etext+0x1d8>
    80001672:	00005097          	auipc	ra,0x5
    80001676:	a10080e7          	jalr	-1520(ra) # 80006082 <panic>
            fileclose(f);
    8000167a:	00002097          	auipc	ra,0x2
    8000167e:	434080e7          	jalr	1076(ra) # 80003aae <fileclose>
            p->ofile[fd] = 0;
    80001682:	0004b023          	sd	zero,0(s1)
    for (int fd = 0; fd < NOFILE; fd++)
    80001686:	04a1                	addi	s1,s1,8
    80001688:	01248563          	beq	s1,s2,80001692 <exit+0x58>
        if (p->ofile[fd])
    8000168c:	6088                	ld	a0,0(s1)
    8000168e:	f575                	bnez	a0,8000167a <exit+0x40>
    80001690:	bfdd                	j	80001686 <exit+0x4c>
    begin_op();
    80001692:	00002097          	auipc	ra,0x2
    80001696:	f50080e7          	jalr	-176(ra) # 800035e2 <begin_op>
    iput(p->cwd);
    8000169a:	1509b503          	ld	a0,336(s3)
    8000169e:	00001097          	auipc	ra,0x1
    800016a2:	73c080e7          	jalr	1852(ra) # 80002dda <iput>
    end_op();
    800016a6:	00002097          	auipc	ra,0x2
    800016aa:	fbc080e7          	jalr	-68(ra) # 80003662 <end_op>
    p->cwd = 0;
    800016ae:	1409b823          	sd	zero,336(s3)
    acquire(&wait_lock);
    800016b2:	00007497          	auipc	s1,0x7
    800016b6:	4e648493          	addi	s1,s1,1254 # 80008b98 <wait_lock>
    800016ba:	8526                	mv	a0,s1
    800016bc:	00005097          	auipc	ra,0x5
    800016c0:	f10080e7          	jalr	-240(ra) # 800065cc <acquire>
    reparent(p);
    800016c4:	854e                	mv	a0,s3
    800016c6:	00000097          	auipc	ra,0x0
    800016ca:	f1a080e7          	jalr	-230(ra) # 800015e0 <reparent>
    wakeup(p->parent);
    800016ce:	0389b503          	ld	a0,56(s3)
    800016d2:	00000097          	auipc	ra,0x0
    800016d6:	e98080e7          	jalr	-360(ra) # 8000156a <wakeup>
    acquire(&p->lock);
    800016da:	854e                	mv	a0,s3
    800016dc:	00005097          	auipc	ra,0x5
    800016e0:	ef0080e7          	jalr	-272(ra) # 800065cc <acquire>
    p->xstate = status;
    800016e4:	0349a623          	sw	s4,44(s3)
    p->state = ZOMBIE;
    800016e8:	4795                	li	a5,5
    800016ea:	00f9ac23          	sw	a5,24(s3)
    release(&wait_lock);
    800016ee:	8526                	mv	a0,s1
    800016f0:	00005097          	auipc	ra,0x5
    800016f4:	f90080e7          	jalr	-112(ra) # 80006680 <release>
    sched();
    800016f8:	00000097          	auipc	ra,0x0
    800016fc:	cfc080e7          	jalr	-772(ra) # 800013f4 <sched>
    panic("zombie exit");
    80001700:	00007517          	auipc	a0,0x7
    80001704:	ae850513          	addi	a0,a0,-1304 # 800081e8 <etext+0x1e8>
    80001708:	00005097          	auipc	ra,0x5
    8000170c:	97a080e7          	jalr	-1670(ra) # 80006082 <panic>

0000000080001710 <kill>:

// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int kill(int pid)
{
    80001710:	7179                	addi	sp,sp,-48
    80001712:	f406                	sd	ra,40(sp)
    80001714:	f022                	sd	s0,32(sp)
    80001716:	ec26                	sd	s1,24(sp)
    80001718:	e84a                	sd	s2,16(sp)
    8000171a:	e44e                	sd	s3,8(sp)
    8000171c:	1800                	addi	s0,sp,48
    8000171e:	892a                	mv	s2,a0
    struct proc *p;

    for (p = proc; p < &proc[NPROC]; p++)
    80001720:	00008497          	auipc	s1,0x8
    80001724:	89048493          	addi	s1,s1,-1904 # 80008fb0 <proc>
    80001728:	0001f997          	auipc	s3,0x1f
    8000172c:	28898993          	addi	s3,s3,648 # 800209b0 <tickslock>
    {
        acquire(&p->lock);
    80001730:	8526                	mv	a0,s1
    80001732:	00005097          	auipc	ra,0x5
    80001736:	e9a080e7          	jalr	-358(ra) # 800065cc <acquire>
        if (p->pid == pid)
    8000173a:	589c                	lw	a5,48(s1)
    8000173c:	01278d63          	beq	a5,s2,80001756 <kill+0x46>
                p->state = RUNNABLE;
            }
            release(&p->lock);
            return 0;
        }
        release(&p->lock);
    80001740:	8526                	mv	a0,s1
    80001742:	00005097          	auipc	ra,0x5
    80001746:	f3e080e7          	jalr	-194(ra) # 80006680 <release>
    for (p = proc; p < &proc[NPROC]; p++)
    8000174a:	5e848493          	addi	s1,s1,1512
    8000174e:	ff3491e3          	bne	s1,s3,80001730 <kill+0x20>
    }
    return -1;
    80001752:	557d                	li	a0,-1
    80001754:	a829                	j	8000176e <kill+0x5e>
            p->killed = 1;
    80001756:	4785                	li	a5,1
    80001758:	d49c                	sw	a5,40(s1)
            if (p->state == SLEEPING)
    8000175a:	4c98                	lw	a4,24(s1)
    8000175c:	4789                	li	a5,2
    8000175e:	00f70f63          	beq	a4,a5,8000177c <kill+0x6c>
            release(&p->lock);
    80001762:	8526                	mv	a0,s1
    80001764:	00005097          	auipc	ra,0x5
    80001768:	f1c080e7          	jalr	-228(ra) # 80006680 <release>
            return 0;
    8000176c:	4501                	li	a0,0
}
    8000176e:	70a2                	ld	ra,40(sp)
    80001770:	7402                	ld	s0,32(sp)
    80001772:	64e2                	ld	s1,24(sp)
    80001774:	6942                	ld	s2,16(sp)
    80001776:	69a2                	ld	s3,8(sp)
    80001778:	6145                	addi	sp,sp,48
    8000177a:	8082                	ret
                p->state = RUNNABLE;
    8000177c:	478d                	li	a5,3
    8000177e:	cc9c                	sw	a5,24(s1)
    80001780:	b7cd                	j	80001762 <kill+0x52>

0000000080001782 <setkilled>:

void setkilled(struct proc *p)
{
    80001782:	1101                	addi	sp,sp,-32
    80001784:	ec06                	sd	ra,24(sp)
    80001786:	e822                	sd	s0,16(sp)
    80001788:	e426                	sd	s1,8(sp)
    8000178a:	1000                	addi	s0,sp,32
    8000178c:	84aa                	mv	s1,a0
    acquire(&p->lock);
    8000178e:	00005097          	auipc	ra,0x5
    80001792:	e3e080e7          	jalr	-450(ra) # 800065cc <acquire>
    p->killed = 1;
    80001796:	4785                	li	a5,1
    80001798:	d49c                	sw	a5,40(s1)
    release(&p->lock);
    8000179a:	8526                	mv	a0,s1
    8000179c:	00005097          	auipc	ra,0x5
    800017a0:	ee4080e7          	jalr	-284(ra) # 80006680 <release>
}
    800017a4:	60e2                	ld	ra,24(sp)
    800017a6:	6442                	ld	s0,16(sp)
    800017a8:	64a2                	ld	s1,8(sp)
    800017aa:	6105                	addi	sp,sp,32
    800017ac:	8082                	ret

00000000800017ae <killed>:

int killed(struct proc *p)
{
    800017ae:	1101                	addi	sp,sp,-32
    800017b0:	ec06                	sd	ra,24(sp)
    800017b2:	e822                	sd	s0,16(sp)
    800017b4:	e426                	sd	s1,8(sp)
    800017b6:	e04a                	sd	s2,0(sp)
    800017b8:	1000                	addi	s0,sp,32
    800017ba:	84aa                	mv	s1,a0
    int k;

    acquire(&p->lock);
    800017bc:	00005097          	auipc	ra,0x5
    800017c0:	e10080e7          	jalr	-496(ra) # 800065cc <acquire>
    k = p->killed;
    800017c4:	0284a903          	lw	s2,40(s1)
    release(&p->lock);
    800017c8:	8526                	mv	a0,s1
    800017ca:	00005097          	auipc	ra,0x5
    800017ce:	eb6080e7          	jalr	-330(ra) # 80006680 <release>
    return k;
}
    800017d2:	854a                	mv	a0,s2
    800017d4:	60e2                	ld	ra,24(sp)
    800017d6:	6442                	ld	s0,16(sp)
    800017d8:	64a2                	ld	s1,8(sp)
    800017da:	6902                	ld	s2,0(sp)
    800017dc:	6105                	addi	sp,sp,32
    800017de:	8082                	ret

00000000800017e0 <wait>:
{
    800017e0:	715d                	addi	sp,sp,-80
    800017e2:	e486                	sd	ra,72(sp)
    800017e4:	e0a2                	sd	s0,64(sp)
    800017e6:	fc26                	sd	s1,56(sp)
    800017e8:	f84a                	sd	s2,48(sp)
    800017ea:	f44e                	sd	s3,40(sp)
    800017ec:	f052                	sd	s4,32(sp)
    800017ee:	ec56                	sd	s5,24(sp)
    800017f0:	e85a                	sd	s6,16(sp)
    800017f2:	e45e                	sd	s7,8(sp)
    800017f4:	e062                	sd	s8,0(sp)
    800017f6:	0880                	addi	s0,sp,80
    800017f8:	8b2a                	mv	s6,a0
    struct proc *p = myproc();
    800017fa:	fffff097          	auipc	ra,0xfffff
    800017fe:	668080e7          	jalr	1640(ra) # 80000e62 <myproc>
    80001802:	892a                	mv	s2,a0
    acquire(&wait_lock);
    80001804:	00007517          	auipc	a0,0x7
    80001808:	39450513          	addi	a0,a0,916 # 80008b98 <wait_lock>
    8000180c:	00005097          	auipc	ra,0x5
    80001810:	dc0080e7          	jalr	-576(ra) # 800065cc <acquire>
        havekids = 0;
    80001814:	4b81                	li	s7,0
                if (pp->state == ZOMBIE)
    80001816:	4a15                	li	s4,5
        for (pp = proc; pp < &proc[NPROC]; pp++)
    80001818:	0001f997          	auipc	s3,0x1f
    8000181c:	19898993          	addi	s3,s3,408 # 800209b0 <tickslock>
                havekids = 1;
    80001820:	4a85                	li	s5,1
        sleep(p, &wait_lock); // DOC: wait-sleep
    80001822:	00007c17          	auipc	s8,0x7
    80001826:	376c0c13          	addi	s8,s8,886 # 80008b98 <wait_lock>
        havekids = 0;
    8000182a:	875e                	mv	a4,s7
        for (pp = proc; pp < &proc[NPROC]; pp++)
    8000182c:	00007497          	auipc	s1,0x7
    80001830:	78448493          	addi	s1,s1,1924 # 80008fb0 <proc>
    80001834:	a0bd                	j	800018a2 <wait+0xc2>
                    pid = pp->pid;
    80001836:	0304a983          	lw	s3,48(s1)
                    if (addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    8000183a:	000b0e63          	beqz	s6,80001856 <wait+0x76>
    8000183e:	4691                	li	a3,4
    80001840:	02c48613          	addi	a2,s1,44
    80001844:	85da                	mv	a1,s6
    80001846:	05093503          	ld	a0,80(s2)
    8000184a:	fffff097          	auipc	ra,0xfffff
    8000184e:	2d6080e7          	jalr	726(ra) # 80000b20 <copyout>
    80001852:	02054563          	bltz	a0,8000187c <wait+0x9c>
                    freeproc(pp);
    80001856:	8526                	mv	a0,s1
    80001858:	fffff097          	auipc	ra,0xfffff
    8000185c:	7bc080e7          	jalr	1980(ra) # 80001014 <freeproc>
                    release(&pp->lock);
    80001860:	8526                	mv	a0,s1
    80001862:	00005097          	auipc	ra,0x5
    80001866:	e1e080e7          	jalr	-482(ra) # 80006680 <release>
                    release(&wait_lock);
    8000186a:	00007517          	auipc	a0,0x7
    8000186e:	32e50513          	addi	a0,a0,814 # 80008b98 <wait_lock>
    80001872:	00005097          	auipc	ra,0x5
    80001876:	e0e080e7          	jalr	-498(ra) # 80006680 <release>
                    return pid;
    8000187a:	a0b5                	j	800018e6 <wait+0x106>
                        release(&pp->lock);
    8000187c:	8526                	mv	a0,s1
    8000187e:	00005097          	auipc	ra,0x5
    80001882:	e02080e7          	jalr	-510(ra) # 80006680 <release>
                        release(&wait_lock);
    80001886:	00007517          	auipc	a0,0x7
    8000188a:	31250513          	addi	a0,a0,786 # 80008b98 <wait_lock>
    8000188e:	00005097          	auipc	ra,0x5
    80001892:	df2080e7          	jalr	-526(ra) # 80006680 <release>
                        return -1;
    80001896:	59fd                	li	s3,-1
    80001898:	a0b9                	j	800018e6 <wait+0x106>
        for (pp = proc; pp < &proc[NPROC]; pp++)
    8000189a:	5e848493          	addi	s1,s1,1512
    8000189e:	03348463          	beq	s1,s3,800018c6 <wait+0xe6>
            if (pp->parent == p)
    800018a2:	7c9c                	ld	a5,56(s1)
    800018a4:	ff279be3          	bne	a5,s2,8000189a <wait+0xba>
                acquire(&pp->lock);
    800018a8:	8526                	mv	a0,s1
    800018aa:	00005097          	auipc	ra,0x5
    800018ae:	d22080e7          	jalr	-734(ra) # 800065cc <acquire>
                if (pp->state == ZOMBIE)
    800018b2:	4c9c                	lw	a5,24(s1)
    800018b4:	f94781e3          	beq	a5,s4,80001836 <wait+0x56>
                release(&pp->lock);
    800018b8:	8526                	mv	a0,s1
    800018ba:	00005097          	auipc	ra,0x5
    800018be:	dc6080e7          	jalr	-570(ra) # 80006680 <release>
                havekids = 1;
    800018c2:	8756                	mv	a4,s5
    800018c4:	bfd9                	j	8000189a <wait+0xba>
        if (!havekids || killed(p))
    800018c6:	c719                	beqz	a4,800018d4 <wait+0xf4>
    800018c8:	854a                	mv	a0,s2
    800018ca:	00000097          	auipc	ra,0x0
    800018ce:	ee4080e7          	jalr	-284(ra) # 800017ae <killed>
    800018d2:	c51d                	beqz	a0,80001900 <wait+0x120>
            release(&wait_lock);
    800018d4:	00007517          	auipc	a0,0x7
    800018d8:	2c450513          	addi	a0,a0,708 # 80008b98 <wait_lock>
    800018dc:	00005097          	auipc	ra,0x5
    800018e0:	da4080e7          	jalr	-604(ra) # 80006680 <release>
            return -1;
    800018e4:	59fd                	li	s3,-1
}
    800018e6:	854e                	mv	a0,s3
    800018e8:	60a6                	ld	ra,72(sp)
    800018ea:	6406                	ld	s0,64(sp)
    800018ec:	74e2                	ld	s1,56(sp)
    800018ee:	7942                	ld	s2,48(sp)
    800018f0:	79a2                	ld	s3,40(sp)
    800018f2:	7a02                	ld	s4,32(sp)
    800018f4:	6ae2                	ld	s5,24(sp)
    800018f6:	6b42                	ld	s6,16(sp)
    800018f8:	6ba2                	ld	s7,8(sp)
    800018fa:	6c02                	ld	s8,0(sp)
    800018fc:	6161                	addi	sp,sp,80
    800018fe:	8082                	ret
        sleep(p, &wait_lock); // DOC: wait-sleep
    80001900:	85e2                	mv	a1,s8
    80001902:	854a                	mv	a0,s2
    80001904:	00000097          	auipc	ra,0x0
    80001908:	c02080e7          	jalr	-1022(ra) # 80001506 <sleep>
        havekids = 0;
    8000190c:	bf39                	j	8000182a <wait+0x4a>

000000008000190e <either_copyout>:

// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    8000190e:	7179                	addi	sp,sp,-48
    80001910:	f406                	sd	ra,40(sp)
    80001912:	f022                	sd	s0,32(sp)
    80001914:	ec26                	sd	s1,24(sp)
    80001916:	e84a                	sd	s2,16(sp)
    80001918:	e44e                	sd	s3,8(sp)
    8000191a:	e052                	sd	s4,0(sp)
    8000191c:	1800                	addi	s0,sp,48
    8000191e:	84aa                	mv	s1,a0
    80001920:	892e                	mv	s2,a1
    80001922:	89b2                	mv	s3,a2
    80001924:	8a36                	mv	s4,a3
    struct proc *p = myproc();
    80001926:	fffff097          	auipc	ra,0xfffff
    8000192a:	53c080e7          	jalr	1340(ra) # 80000e62 <myproc>
    if (user_dst)
    8000192e:	c08d                	beqz	s1,80001950 <either_copyout+0x42>
    {
        return copyout(p->pagetable, dst, src, len);
    80001930:	86d2                	mv	a3,s4
    80001932:	864e                	mv	a2,s3
    80001934:	85ca                	mv	a1,s2
    80001936:	6928                	ld	a0,80(a0)
    80001938:	fffff097          	auipc	ra,0xfffff
    8000193c:	1e8080e7          	jalr	488(ra) # 80000b20 <copyout>
    else
    {
        memmove((char *)dst, src, len);
        return 0;
    }
}
    80001940:	70a2                	ld	ra,40(sp)
    80001942:	7402                	ld	s0,32(sp)
    80001944:	64e2                	ld	s1,24(sp)
    80001946:	6942                	ld	s2,16(sp)
    80001948:	69a2                	ld	s3,8(sp)
    8000194a:	6a02                	ld	s4,0(sp)
    8000194c:	6145                	addi	sp,sp,48
    8000194e:	8082                	ret
        memmove((char *)dst, src, len);
    80001950:	000a061b          	sext.w	a2,s4
    80001954:	85ce                	mv	a1,s3
    80001956:	854a                	mv	a0,s2
    80001958:	fffff097          	auipc	ra,0xfffff
    8000195c:	880080e7          	jalr	-1920(ra) # 800001d8 <memmove>
        return 0;
    80001960:	8526                	mv	a0,s1
    80001962:	bff9                	j	80001940 <either_copyout+0x32>

0000000080001964 <either_copyin>:

// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001964:	7179                	addi	sp,sp,-48
    80001966:	f406                	sd	ra,40(sp)
    80001968:	f022                	sd	s0,32(sp)
    8000196a:	ec26                	sd	s1,24(sp)
    8000196c:	e84a                	sd	s2,16(sp)
    8000196e:	e44e                	sd	s3,8(sp)
    80001970:	e052                	sd	s4,0(sp)
    80001972:	1800                	addi	s0,sp,48
    80001974:	892a                	mv	s2,a0
    80001976:	84ae                	mv	s1,a1
    80001978:	89b2                	mv	s3,a2
    8000197a:	8a36                	mv	s4,a3
    struct proc *p = myproc();
    8000197c:	fffff097          	auipc	ra,0xfffff
    80001980:	4e6080e7          	jalr	1254(ra) # 80000e62 <myproc>
    if (user_src)
    80001984:	c08d                	beqz	s1,800019a6 <either_copyin+0x42>
    {
        return copyin(p->pagetable, dst, src, len);
    80001986:	86d2                	mv	a3,s4
    80001988:	864e                	mv	a2,s3
    8000198a:	85ca                	mv	a1,s2
    8000198c:	6928                	ld	a0,80(a0)
    8000198e:	fffff097          	auipc	ra,0xfffff
    80001992:	21e080e7          	jalr	542(ra) # 80000bac <copyin>
    else
    {
        memmove(dst, (char *)src, len);
        return 0;
    }
}
    80001996:	70a2                	ld	ra,40(sp)
    80001998:	7402                	ld	s0,32(sp)
    8000199a:	64e2                	ld	s1,24(sp)
    8000199c:	6942                	ld	s2,16(sp)
    8000199e:	69a2                	ld	s3,8(sp)
    800019a0:	6a02                	ld	s4,0(sp)
    800019a2:	6145                	addi	sp,sp,48
    800019a4:	8082                	ret
        memmove(dst, (char *)src, len);
    800019a6:	000a061b          	sext.w	a2,s4
    800019aa:	85ce                	mv	a1,s3
    800019ac:	854a                	mv	a0,s2
    800019ae:	fffff097          	auipc	ra,0xfffff
    800019b2:	82a080e7          	jalr	-2006(ra) # 800001d8 <memmove>
        return 0;
    800019b6:	8526                	mv	a0,s1
    800019b8:	bff9                	j	80001996 <either_copyin+0x32>

00000000800019ba <procdump>:

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void procdump(void)
{
    800019ba:	715d                	addi	sp,sp,-80
    800019bc:	e486                	sd	ra,72(sp)
    800019be:	e0a2                	sd	s0,64(sp)
    800019c0:	fc26                	sd	s1,56(sp)
    800019c2:	f84a                	sd	s2,48(sp)
    800019c4:	f44e                	sd	s3,40(sp)
    800019c6:	f052                	sd	s4,32(sp)
    800019c8:	ec56                	sd	s5,24(sp)
    800019ca:	e85a                	sd	s6,16(sp)
    800019cc:	e45e                	sd	s7,8(sp)
    800019ce:	0880                	addi	s0,sp,80
        [RUNNING] "run   ",
        [ZOMBIE] "zombie"};
    struct proc *p;
    char *state;

    printf("\n");
    800019d0:	00006517          	auipc	a0,0x6
    800019d4:	67850513          	addi	a0,a0,1656 # 80008048 <etext+0x48>
    800019d8:	00004097          	auipc	ra,0x4
    800019dc:	6f4080e7          	jalr	1780(ra) # 800060cc <printf>
    for (p = proc; p < &proc[NPROC]; p++)
    800019e0:	00007497          	auipc	s1,0x7
    800019e4:	72848493          	addi	s1,s1,1832 # 80009108 <proc+0x158>
    800019e8:	0001f917          	auipc	s2,0x1f
    800019ec:	12090913          	addi	s2,s2,288 # 80020b08 <bcache+0x140>
    {
        if (p->state == UNUSED)
            continue;
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    800019f0:	4b15                	li	s6,5
            state = states[p->state];
        else
            state = "???";
    800019f2:	00007997          	auipc	s3,0x7
    800019f6:	80698993          	addi	s3,s3,-2042 # 800081f8 <etext+0x1f8>
        printf("%d %s %s", p->pid, state, p->name);
    800019fa:	00007a97          	auipc	s5,0x7
    800019fe:	806a8a93          	addi	s5,s5,-2042 # 80008200 <etext+0x200>
        printf("\n");
    80001a02:	00006a17          	auipc	s4,0x6
    80001a06:	646a0a13          	addi	s4,s4,1606 # 80008048 <etext+0x48>
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a0a:	00007b97          	auipc	s7,0x7
    80001a0e:	836b8b93          	addi	s7,s7,-1994 # 80008240 <states.1738>
    80001a12:	a00d                	j	80001a34 <procdump+0x7a>
        printf("%d %s %s", p->pid, state, p->name);
    80001a14:	ed86a583          	lw	a1,-296(a3)
    80001a18:	8556                	mv	a0,s5
    80001a1a:	00004097          	auipc	ra,0x4
    80001a1e:	6b2080e7          	jalr	1714(ra) # 800060cc <printf>
        printf("\n");
    80001a22:	8552                	mv	a0,s4
    80001a24:	00004097          	auipc	ra,0x4
    80001a28:	6a8080e7          	jalr	1704(ra) # 800060cc <printf>
    for (p = proc; p < &proc[NPROC]; p++)
    80001a2c:	5e848493          	addi	s1,s1,1512
    80001a30:	03248163          	beq	s1,s2,80001a52 <procdump+0x98>
        if (p->state == UNUSED)
    80001a34:	86a6                	mv	a3,s1
    80001a36:	ec04a783          	lw	a5,-320(s1)
    80001a3a:	dbed                	beqz	a5,80001a2c <procdump+0x72>
            state = "???";
    80001a3c:	864e                	mv	a2,s3
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a3e:	fcfb6be3          	bltu	s6,a5,80001a14 <procdump+0x5a>
    80001a42:	1782                	slli	a5,a5,0x20
    80001a44:	9381                	srli	a5,a5,0x20
    80001a46:	078e                	slli	a5,a5,0x3
    80001a48:	97de                	add	a5,a5,s7
    80001a4a:	6390                	ld	a2,0(a5)
    80001a4c:	f661                	bnez	a2,80001a14 <procdump+0x5a>
            state = "???";
    80001a4e:	864e                	mv	a2,s3
    80001a50:	b7d1                	j	80001a14 <procdump+0x5a>
    }
}
    80001a52:	60a6                	ld	ra,72(sp)
    80001a54:	6406                	ld	s0,64(sp)
    80001a56:	74e2                	ld	s1,56(sp)
    80001a58:	7942                	ld	s2,48(sp)
    80001a5a:	79a2                	ld	s3,40(sp)
    80001a5c:	7a02                	ld	s4,32(sp)
    80001a5e:	6ae2                	ld	s5,24(sp)
    80001a60:	6b42                	ld	s6,16(sp)
    80001a62:	6ba2                	ld	s7,8(sp)
    80001a64:	6161                	addi	sp,sp,80
    80001a66:	8082                	ret

0000000080001a68 <swtch>:
    80001a68:	00153023          	sd	ra,0(a0)
    80001a6c:	00253423          	sd	sp,8(a0)
    80001a70:	e900                	sd	s0,16(a0)
    80001a72:	ed04                	sd	s1,24(a0)
    80001a74:	03253023          	sd	s2,32(a0)
    80001a78:	03353423          	sd	s3,40(a0)
    80001a7c:	03453823          	sd	s4,48(a0)
    80001a80:	03553c23          	sd	s5,56(a0)
    80001a84:	05653023          	sd	s6,64(a0)
    80001a88:	05753423          	sd	s7,72(a0)
    80001a8c:	05853823          	sd	s8,80(a0)
    80001a90:	05953c23          	sd	s9,88(a0)
    80001a94:	07a53023          	sd	s10,96(a0)
    80001a98:	07b53423          	sd	s11,104(a0)
    80001a9c:	0005b083          	ld	ra,0(a1)
    80001aa0:	0085b103          	ld	sp,8(a1)
    80001aa4:	6980                	ld	s0,16(a1)
    80001aa6:	6d84                	ld	s1,24(a1)
    80001aa8:	0205b903          	ld	s2,32(a1)
    80001aac:	0285b983          	ld	s3,40(a1)
    80001ab0:	0305ba03          	ld	s4,48(a1)
    80001ab4:	0385ba83          	ld	s5,56(a1)
    80001ab8:	0405bb03          	ld	s6,64(a1)
    80001abc:	0485bb83          	ld	s7,72(a1)
    80001ac0:	0505bc03          	ld	s8,80(a1)
    80001ac4:	0585bc83          	ld	s9,88(a1)
    80001ac8:	0605bd03          	ld	s10,96(a1)
    80001acc:	0685bd83          	ld	s11,104(a1)
    80001ad0:	8082                	ret

0000000080001ad2 <trapinit>:
void kernelvec();

extern int devintr();

void trapinit(void)
{
    80001ad2:	1141                	addi	sp,sp,-16
    80001ad4:	e406                	sd	ra,8(sp)
    80001ad6:	e022                	sd	s0,0(sp)
    80001ad8:	0800                	addi	s0,sp,16
    initlock(&tickslock, "time");
    80001ada:	00006597          	auipc	a1,0x6
    80001ade:	79658593          	addi	a1,a1,1942 # 80008270 <states.1738+0x30>
    80001ae2:	0001f517          	auipc	a0,0x1f
    80001ae6:	ece50513          	addi	a0,a0,-306 # 800209b0 <tickslock>
    80001aea:	00005097          	auipc	ra,0x5
    80001aee:	a52080e7          	jalr	-1454(ra) # 8000653c <initlock>
}
    80001af2:	60a2                	ld	ra,8(sp)
    80001af4:	6402                	ld	s0,0(sp)
    80001af6:	0141                	addi	sp,sp,16
    80001af8:	8082                	ret

0000000080001afa <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void trapinithart(void)
{
    80001afa:	1141                	addi	sp,sp,-16
    80001afc:	e422                	sd	s0,8(sp)
    80001afe:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b00:	00004797          	auipc	a5,0x4
    80001b04:	95078793          	addi	a5,a5,-1712 # 80005450 <kernelvec>
    80001b08:	10579073          	csrw	stvec,a5
    w_stvec((uint64)kernelvec);
}
    80001b0c:	6422                	ld	s0,8(sp)
    80001b0e:	0141                	addi	sp,sp,16
    80001b10:	8082                	ret

0000000080001b12 <usertrapret>:

//
// return to user space
//
void usertrapret(void)
{
    80001b12:	1141                	addi	sp,sp,-16
    80001b14:	e406                	sd	ra,8(sp)
    80001b16:	e022                	sd	s0,0(sp)
    80001b18:	0800                	addi	s0,sp,16
    struct proc *p = myproc();
    80001b1a:	fffff097          	auipc	ra,0xfffff
    80001b1e:	348080e7          	jalr	840(ra) # 80000e62 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b22:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001b26:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b28:	10079073          	csrw	sstatus,a5
    // kerneltrap() to usertrap(), so turn off interrupts until
    // we're back in user space, where usertrap() is correct.
    intr_off();

    // send syscalls, interrupts, and exceptions to uservec in trampoline.S
    uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001b2c:	00005617          	auipc	a2,0x5
    80001b30:	4d460613          	addi	a2,a2,1236 # 80007000 <_trampoline>
    80001b34:	00005697          	auipc	a3,0x5
    80001b38:	4cc68693          	addi	a3,a3,1228 # 80007000 <_trampoline>
    80001b3c:	8e91                	sub	a3,a3,a2
    80001b3e:	040007b7          	lui	a5,0x4000
    80001b42:	17fd                	addi	a5,a5,-1
    80001b44:	07b2                	slli	a5,a5,0xc
    80001b46:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b48:	10569073          	csrw	stvec,a3
    w_stvec(trampoline_uservec);

    // set up trapframe values that uservec will need when
    // the process next traps into the kernel.
    p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001b4c:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001b4e:	180026f3          	csrr	a3,satp
    80001b52:	e314                	sd	a3,0(a4)
    p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001b54:	6d38                	ld	a4,88(a0)
    80001b56:	6134                	ld	a3,64(a0)
    80001b58:	6585                	lui	a1,0x1
    80001b5a:	96ae                	add	a3,a3,a1
    80001b5c:	e714                	sd	a3,8(a4)
    p->trapframe->kernel_trap = (uint64)usertrap;
    80001b5e:	6d38                	ld	a4,88(a0)
    80001b60:	00000697          	auipc	a3,0x0
    80001b64:	13068693          	addi	a3,a3,304 # 80001c90 <usertrap>
    80001b68:	eb14                	sd	a3,16(a4)
    p->trapframe->kernel_hartid = r_tp(); // hartid for cpuid()
    80001b6a:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001b6c:	8692                	mv	a3,tp
    80001b6e:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b70:	100026f3          	csrr	a3,sstatus
    // set up the registers that trampoline.S's sret will use
    // to get to user space.

    // set S Previous Privilege mode to User.
    unsigned long x = r_sstatus();
    x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001b74:	eff6f693          	andi	a3,a3,-257
    x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001b78:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b7c:	10069073          	csrw	sstatus,a3
    w_sstatus(x);

    // set S Exception Program Counter to the saved user pc.
    w_sepc(p->trapframe->epc);
    80001b80:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001b82:	6f18                	ld	a4,24(a4)
    80001b84:	14171073          	csrw	sepc,a4

    // tell trampoline.S the user page table to switch to.
    uint64 satp = MAKE_SATP(p->pagetable);
    80001b88:	6928                	ld	a0,80(a0)
    80001b8a:	8131                	srli	a0,a0,0xc

    // jump to userret in trampoline.S at the top of memory, which
    // switches to the user page table, restores user registers,
    // and switches to user mode with sret.
    uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001b8c:	00005717          	auipc	a4,0x5
    80001b90:	51070713          	addi	a4,a4,1296 # 8000709c <userret>
    80001b94:	8f11                	sub	a4,a4,a2
    80001b96:	97ba                	add	a5,a5,a4
    ((void (*)(uint64))trampoline_userret)(satp);
    80001b98:	577d                	li	a4,-1
    80001b9a:	177e                	slli	a4,a4,0x3f
    80001b9c:	8d59                	or	a0,a0,a4
    80001b9e:	9782                	jalr	a5
}
    80001ba0:	60a2                	ld	ra,8(sp)
    80001ba2:	6402                	ld	s0,0(sp)
    80001ba4:	0141                	addi	sp,sp,16
    80001ba6:	8082                	ret

0000000080001ba8 <clockintr>:
    w_sepc(sepc);
    w_sstatus(sstatus);
}

void clockintr()
{
    80001ba8:	1101                	addi	sp,sp,-32
    80001baa:	ec06                	sd	ra,24(sp)
    80001bac:	e822                	sd	s0,16(sp)
    80001bae:	e426                	sd	s1,8(sp)
    80001bb0:	1000                	addi	s0,sp,32
    acquire(&tickslock);
    80001bb2:	0001f497          	auipc	s1,0x1f
    80001bb6:	dfe48493          	addi	s1,s1,-514 # 800209b0 <tickslock>
    80001bba:	8526                	mv	a0,s1
    80001bbc:	00005097          	auipc	ra,0x5
    80001bc0:	a10080e7          	jalr	-1520(ra) # 800065cc <acquire>
    ticks++;
    80001bc4:	00007517          	auipc	a0,0x7
    80001bc8:	f8450513          	addi	a0,a0,-124 # 80008b48 <ticks>
    80001bcc:	411c                	lw	a5,0(a0)
    80001bce:	2785                	addiw	a5,a5,1
    80001bd0:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    80001bd2:	00000097          	auipc	ra,0x0
    80001bd6:	998080e7          	jalr	-1640(ra) # 8000156a <wakeup>
    release(&tickslock);
    80001bda:	8526                	mv	a0,s1
    80001bdc:	00005097          	auipc	ra,0x5
    80001be0:	aa4080e7          	jalr	-1372(ra) # 80006680 <release>
}
    80001be4:	60e2                	ld	ra,24(sp)
    80001be6:	6442                	ld	s0,16(sp)
    80001be8:	64a2                	ld	s1,8(sp)
    80001bea:	6105                	addi	sp,sp,32
    80001bec:	8082                	ret

0000000080001bee <devintr>:
// and handle it.
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int devintr()
{
    80001bee:	1101                	addi	sp,sp,-32
    80001bf0:	ec06                	sd	ra,24(sp)
    80001bf2:	e822                	sd	s0,16(sp)
    80001bf4:	e426                	sd	s1,8(sp)
    80001bf6:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001bf8:	14202773          	csrr	a4,scause
    uint64 scause = r_scause();

    if ((scause & 0x8000000000000000L) &&
    80001bfc:	00074d63          	bltz	a4,80001c16 <devintr+0x28>
        if (irq)
            plic_complete(irq);

        return 1;
    }
    else if (scause == 0x8000000000000001L)
    80001c00:	57fd                	li	a5,-1
    80001c02:	17fe                	slli	a5,a5,0x3f
    80001c04:	0785                	addi	a5,a5,1

        return 2;
    }
    else
    {
        return 0;
    80001c06:	4501                	li	a0,0
    else if (scause == 0x8000000000000001L)
    80001c08:	06f70363          	beq	a4,a5,80001c6e <devintr+0x80>
    }
}
    80001c0c:	60e2                	ld	ra,24(sp)
    80001c0e:	6442                	ld	s0,16(sp)
    80001c10:	64a2                	ld	s1,8(sp)
    80001c12:	6105                	addi	sp,sp,32
    80001c14:	8082                	ret
        (scause & 0xff) == 9)
    80001c16:	0ff77793          	andi	a5,a4,255
    if ((scause & 0x8000000000000000L) &&
    80001c1a:	46a5                	li	a3,9
    80001c1c:	fed792e3          	bne	a5,a3,80001c00 <devintr+0x12>
        int irq = plic_claim();
    80001c20:	00004097          	auipc	ra,0x4
    80001c24:	938080e7          	jalr	-1736(ra) # 80005558 <plic_claim>
    80001c28:	84aa                	mv	s1,a0
        if (irq == UART0_IRQ)
    80001c2a:	47a9                	li	a5,10
    80001c2c:	02f50763          	beq	a0,a5,80001c5a <devintr+0x6c>
        else if (irq == VIRTIO0_IRQ)
    80001c30:	4785                	li	a5,1
    80001c32:	02f50963          	beq	a0,a5,80001c64 <devintr+0x76>
        return 1;
    80001c36:	4505                	li	a0,1
        else if (irq)
    80001c38:	d8f1                	beqz	s1,80001c0c <devintr+0x1e>
            printf("unexpected interrupt irq=%d\n", irq);
    80001c3a:	85a6                	mv	a1,s1
    80001c3c:	00006517          	auipc	a0,0x6
    80001c40:	63c50513          	addi	a0,a0,1596 # 80008278 <states.1738+0x38>
    80001c44:	00004097          	auipc	ra,0x4
    80001c48:	488080e7          	jalr	1160(ra) # 800060cc <printf>
            plic_complete(irq);
    80001c4c:	8526                	mv	a0,s1
    80001c4e:	00004097          	auipc	ra,0x4
    80001c52:	92e080e7          	jalr	-1746(ra) # 8000557c <plic_complete>
        return 1;
    80001c56:	4505                	li	a0,1
    80001c58:	bf55                	j	80001c0c <devintr+0x1e>
            uartintr();
    80001c5a:	00005097          	auipc	ra,0x5
    80001c5e:	892080e7          	jalr	-1902(ra) # 800064ec <uartintr>
    80001c62:	b7ed                	j	80001c4c <devintr+0x5e>
            virtio_disk_intr();
    80001c64:	00004097          	auipc	ra,0x4
    80001c68:	e42080e7          	jalr	-446(ra) # 80005aa6 <virtio_disk_intr>
    80001c6c:	b7c5                	j	80001c4c <devintr+0x5e>
        if (cpuid() == 0)
    80001c6e:	fffff097          	auipc	ra,0xfffff
    80001c72:	1c8080e7          	jalr	456(ra) # 80000e36 <cpuid>
    80001c76:	c901                	beqz	a0,80001c86 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001c78:	144027f3          	csrr	a5,sip
        w_sip(r_sip() & ~2);
    80001c7c:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001c7e:	14479073          	csrw	sip,a5
        return 2;
    80001c82:	4509                	li	a0,2
    80001c84:	b761                	j	80001c0c <devintr+0x1e>
            clockintr();
    80001c86:	00000097          	auipc	ra,0x0
    80001c8a:	f22080e7          	jalr	-222(ra) # 80001ba8 <clockintr>
    80001c8e:	b7ed                	j	80001c78 <devintr+0x8a>

0000000080001c90 <usertrap>:
{
    80001c90:	715d                	addi	sp,sp,-80
    80001c92:	e486                	sd	ra,72(sp)
    80001c94:	e0a2                	sd	s0,64(sp)
    80001c96:	fc26                	sd	s1,56(sp)
    80001c98:	f84a                	sd	s2,48(sp)
    80001c9a:	f44e                	sd	s3,40(sp)
    80001c9c:	f052                	sd	s4,32(sp)
    80001c9e:	ec56                	sd	s5,24(sp)
    80001ca0:	e85a                	sd	s6,16(sp)
    80001ca2:	e45e                	sd	s7,8(sp)
    80001ca4:	0880                	addi	s0,sp,80
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ca6:	100027f3          	csrr	a5,sstatus
    if ((r_sstatus() & SSTATUS_SPP) != 0)
    80001caa:	1007f793          	andi	a5,a5,256
    80001cae:	e7c1                	bnez	a5,80001d36 <usertrap+0xa6>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001cb0:	00003797          	auipc	a5,0x3
    80001cb4:	7a078793          	addi	a5,a5,1952 # 80005450 <kernelvec>
    80001cb8:	10579073          	csrw	stvec,a5
    struct proc *p = myproc();
    80001cbc:	fffff097          	auipc	ra,0xfffff
    80001cc0:	1a6080e7          	jalr	422(ra) # 80000e62 <myproc>
    80001cc4:	892a                	mv	s2,a0
    p->trapframe->epc = r_sepc();
    80001cc6:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001cc8:	14102773          	csrr	a4,sepc
    80001ccc:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001cce:	14202773          	csrr	a4,scause
    if (r_scause() == 8)
    80001cd2:	47a1                	li	a5,8
    80001cd4:	06f70963          	beq	a4,a5,80001d46 <usertrap+0xb6>
    else if ((which_dev = devintr()) != 0)
    80001cd8:	00000097          	auipc	ra,0x0
    80001cdc:	f16080e7          	jalr	-234(ra) # 80001bee <devintr>
    80001ce0:	84aa                	mv	s1,a0
    80001ce2:	1c051463          	bnez	a0,80001eaa <usertrap+0x21a>
    80001ce6:	14202773          	csrr	a4,scause
    else if (r_scause() == 13 || r_scause() == 15)
    80001cea:	47b5                	li	a5,13
    80001cec:	0af70d63          	beq	a4,a5,80001da6 <usertrap+0x116>
    80001cf0:	14202773          	csrr	a4,scause
    80001cf4:	47bd                	li	a5,15
    80001cf6:	0af70863          	beq	a4,a5,80001da6 <usertrap+0x116>
    80001cfa:	142025f3          	csrr	a1,scause
        printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001cfe:	03092603          	lw	a2,48(s2)
    80001d02:	00006517          	auipc	a0,0x6
    80001d06:	64650513          	addi	a0,a0,1606 # 80008348 <states.1738+0x108>
    80001d0a:	00004097          	auipc	ra,0x4
    80001d0e:	3c2080e7          	jalr	962(ra) # 800060cc <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d12:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001d16:	14302673          	csrr	a2,stval
        printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001d1a:	00006517          	auipc	a0,0x6
    80001d1e:	65e50513          	addi	a0,a0,1630 # 80008378 <states.1738+0x138>
    80001d22:	00004097          	auipc	ra,0x4
    80001d26:	3aa080e7          	jalr	938(ra) # 800060cc <printf>
        setkilled(p);
    80001d2a:	854a                	mv	a0,s2
    80001d2c:	00000097          	auipc	ra,0x0
    80001d30:	a56080e7          	jalr	-1450(ra) # 80001782 <setkilled>
    80001d34:	a82d                	j	80001d6e <usertrap+0xde>
        panic("usertrap: not from user mode");
    80001d36:	00006517          	auipc	a0,0x6
    80001d3a:	56250513          	addi	a0,a0,1378 # 80008298 <states.1738+0x58>
    80001d3e:	00004097          	auipc	ra,0x4
    80001d42:	344080e7          	jalr	836(ra) # 80006082 <panic>
        if (killed(p))
    80001d46:	00000097          	auipc	ra,0x0
    80001d4a:	a68080e7          	jalr	-1432(ra) # 800017ae <killed>
    80001d4e:	e531                	bnez	a0,80001d9a <usertrap+0x10a>
        p->trapframe->epc += 4;
    80001d50:	05893703          	ld	a4,88(s2)
    80001d54:	6f1c                	ld	a5,24(a4)
    80001d56:	0791                	addi	a5,a5,4
    80001d58:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d5a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001d5e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d62:	10079073          	csrw	sstatus,a5
        syscall();
    80001d66:	00000097          	auipc	ra,0x0
    80001d6a:	3b8080e7          	jalr	952(ra) # 8000211e <syscall>
    if (killed(p))
    80001d6e:	854a                	mv	a0,s2
    80001d70:	00000097          	auipc	ra,0x0
    80001d74:	a3e080e7          	jalr	-1474(ra) # 800017ae <killed>
    80001d78:	14051063          	bnez	a0,80001eb8 <usertrap+0x228>
    usertrapret();
    80001d7c:	00000097          	auipc	ra,0x0
    80001d80:	d96080e7          	jalr	-618(ra) # 80001b12 <usertrapret>
}
    80001d84:	60a6                	ld	ra,72(sp)
    80001d86:	6406                	ld	s0,64(sp)
    80001d88:	74e2                	ld	s1,56(sp)
    80001d8a:	7942                	ld	s2,48(sp)
    80001d8c:	79a2                	ld	s3,40(sp)
    80001d8e:	7a02                	ld	s4,32(sp)
    80001d90:	6ae2                	ld	s5,24(sp)
    80001d92:	6b42                	ld	s6,16(sp)
    80001d94:	6ba2                	ld	s7,8(sp)
    80001d96:	6161                	addi	sp,sp,80
    80001d98:	8082                	ret
            exit(-1);
    80001d9a:	557d                	li	a0,-1
    80001d9c:	00000097          	auipc	ra,0x0
    80001da0:	89e080e7          	jalr	-1890(ra) # 8000163a <exit>
    80001da4:	b775                	j	80001d50 <usertrap+0xc0>
        struct proc *p_proc = myproc();
    80001da6:	fffff097          	auipc	ra,0xfffff
    80001daa:	0bc080e7          	jalr	188(ra) # 80000e62 <myproc>
    80001dae:	8a2a                	mv	s4,a0
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001db0:	143029f3          	csrr	s3,stval
        for (int i = 0; i <= VMASIZE - 1; i++)
    80001db4:	16850793          	addi	a5,a0,360
            if (p_proc->vma[i].occupied == 1)
    80001db8:	4605                	li	a2,1
        for (int i = 0; i <= VMASIZE - 1; i++)
    80001dba:	45c1                	li	a1,16
    80001dbc:	a031                	j	80001dc8 <usertrap+0x138>
    80001dbe:	2485                	addiw	s1,s1,1
    80001dc0:	04878793          	addi	a5,a5,72
    80001dc4:	0cb48463          	beq	s1,a1,80001e8c <usertrap+0x1fc>
            if (p_proc->vma[i].occupied == 1)
    80001dc8:	4398                	lw	a4,0(a5)
    80001dca:	fec71ae3          	bne	a4,a2,80001dbe <usertrap+0x12e>
                if (p_proc->vma[i].start_addr <= va && va <= p_proc->vma[i].end_addr)
    80001dce:	6798                	ld	a4,8(a5)
    80001dd0:	fee9e7e3          	bltu	s3,a4,80001dbe <usertrap+0x12e>
    80001dd4:	6b98                	ld	a4,16(a5)
    80001dd6:	ff3764e3          	bltu	a4,s3,80001dbe <usertrap+0x12e>
                    printf("[Testing] (trap) : Find it!\n");
    80001dda:	00006517          	auipc	a0,0x6
    80001dde:	4de50513          	addi	a0,a0,1246 # 800082b8 <states.1738+0x78>
    80001de2:	00004097          	auipc	ra,0x4
    80001de6:	2ea080e7          	jalr	746(ra) # 800060cc <printf>
                    printf("[Testing] (trap) : %d, %d -> %d\n", i, p_proc->vma[i].start_addr, p_proc->vma[i].end_addr);
    80001dea:	00349793          	slli	a5,s1,0x3
    80001dee:	97a6                	add	a5,a5,s1
    80001df0:	078e                	slli	a5,a5,0x3
    80001df2:	97d2                	add	a5,a5,s4
    80001df4:	1787b683          	ld	a3,376(a5)
    80001df8:	1707b603          	ld	a2,368(a5)
    80001dfc:	85a6                	mv	a1,s1
    80001dfe:	00006517          	auipc	a0,0x6
    80001e02:	4da50513          	addi	a0,a0,1242 # 800082d8 <states.1738+0x98>
    80001e06:	00004097          	auipc	ra,0x4
    80001e0a:	2c6080e7          	jalr	710(ra) # 800060cc <printf>
            char *mem = (char *)kalloc();
    80001e0e:	ffffe097          	auipc	ra,0xffffe
    80001e12:	30a080e7          	jalr	778(ra) # 80000118 <kalloc>
    80001e16:	8baa                	mv	s7,a0
            if (mem == 0)
    80001e18:	c159                	beqz	a0,80001e9e <usertrap+0x20e>
                memset(mem, 0, PGSIZE);
    80001e1a:	6605                	lui	a2,0x1
    80001e1c:	4581                	li	a1,0
    80001e1e:	ffffe097          	auipc	ra,0xffffe
    80001e22:	35a080e7          	jalr	858(ra) # 80000178 <memset>
                printf("[Testing] (trap) : map off: %d\n", va - p_vma->start_addr);
    80001e26:	00349a93          	slli	s5,s1,0x3
    80001e2a:	009a8b33          	add	s6,s5,s1
    80001e2e:	0b0e                	slli	s6,s6,0x3
    80001e30:	9b52                	add	s6,s6,s4
    80001e32:	170b3583          	ld	a1,368(s6)
    80001e36:	40b985b3          	sub	a1,s3,a1
    80001e3a:	00006517          	auipc	a0,0x6
    80001e3e:	4ee50513          	addi	a0,a0,1262 # 80008328 <states.1738+0xe8>
    80001e42:	00004097          	auipc	ra,0x4
    80001e46:	28a080e7          	jalr	650(ra) # 800060cc <printf>
                mapfile(p_vma->pf, mem, va - p_vma->start_addr);
    80001e4a:	170b3603          	ld	a2,368(s6)
    80001e4e:	40c9863b          	subw	a2,s3,a2
    80001e52:	85de                	mv	a1,s7
    80001e54:	1a8b3503          	ld	a0,424(s6)
    80001e58:	00002097          	auipc	ra,0x2
    80001e5c:	d90080e7          	jalr	-624(ra) # 80003be8 <mapfile>
                if (mappages(p_proc->pagetable, va, PGSIZE, (uint64)mem, (p_vma->prot | PTE_R | PTE_X | PTE_W | PTE_U)) == -1)
    80001e60:	190b2703          	lw	a4,400(s6)
    80001e64:	01e76713          	ori	a4,a4,30
    80001e68:	86de                	mv	a3,s7
    80001e6a:	6605                	lui	a2,0x1
    80001e6c:	85ce                	mv	a1,s3
    80001e6e:	050a3503          	ld	a0,80(s4)
    80001e72:	ffffe097          	auipc	ra,0xffffe
    80001e76:	6da080e7          	jalr	1754(ra) # 8000054c <mappages>
    80001e7a:	57fd                	li	a5,-1
    80001e7c:	eef519e3          	bne	a0,a5,80001d6e <usertrap+0xde>
                    setkilled(p_proc);
    80001e80:	8552                	mv	a0,s4
    80001e82:	00000097          	auipc	ra,0x0
    80001e86:	900080e7          	jalr	-1792(ra) # 80001782 <setkilled>
    80001e8a:	b5d5                	j	80001d6e <usertrap+0xde>
            printf("Now, after mmap, we get a page fault\n");
    80001e8c:	00006517          	auipc	a0,0x6
    80001e90:	47450513          	addi	a0,a0,1140 # 80008300 <states.1738+0xc0>
    80001e94:	00004097          	auipc	ra,0x4
    80001e98:	238080e7          	jalr	568(ra) # 800060cc <printf>
            goto err;
    80001e9c:	bdb9                	j	80001cfa <usertrap+0x6a>
                setkilled(p_proc);
    80001e9e:	8552                	mv	a0,s4
    80001ea0:	00000097          	auipc	ra,0x0
    80001ea4:	8e2080e7          	jalr	-1822(ra) # 80001782 <setkilled>
                return;
    80001ea8:	bdf1                	j	80001d84 <usertrap+0xf4>
    if (killed(p))
    80001eaa:	854a                	mv	a0,s2
    80001eac:	00000097          	auipc	ra,0x0
    80001eb0:	902080e7          	jalr	-1790(ra) # 800017ae <killed>
    80001eb4:	c901                	beqz	a0,80001ec4 <usertrap+0x234>
    80001eb6:	a011                	j	80001eba <usertrap+0x22a>
    80001eb8:	4481                	li	s1,0
        exit(-1);
    80001eba:	557d                	li	a0,-1
    80001ebc:	fffff097          	auipc	ra,0xfffff
    80001ec0:	77e080e7          	jalr	1918(ra) # 8000163a <exit>
    if (which_dev == 2)
    80001ec4:	4789                	li	a5,2
    80001ec6:	eaf49be3          	bne	s1,a5,80001d7c <usertrap+0xec>
        yield();
    80001eca:	fffff097          	auipc	ra,0xfffff
    80001ece:	600080e7          	jalr	1536(ra) # 800014ca <yield>
    80001ed2:	b56d                	j	80001d7c <usertrap+0xec>

0000000080001ed4 <kerneltrap>:
{
    80001ed4:	7179                	addi	sp,sp,-48
    80001ed6:	f406                	sd	ra,40(sp)
    80001ed8:	f022                	sd	s0,32(sp)
    80001eda:	ec26                	sd	s1,24(sp)
    80001edc:	e84a                	sd	s2,16(sp)
    80001ede:	e44e                	sd	s3,8(sp)
    80001ee0:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001ee2:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ee6:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001eea:	142029f3          	csrr	s3,scause
    if ((sstatus & SSTATUS_SPP) == 0)
    80001eee:	1004f793          	andi	a5,s1,256
    80001ef2:	cb85                	beqz	a5,80001f22 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ef4:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001ef8:	8b89                	andi	a5,a5,2
    if (intr_get() != 0)
    80001efa:	ef85                	bnez	a5,80001f32 <kerneltrap+0x5e>
    if ((which_dev = devintr()) == 0)
    80001efc:	00000097          	auipc	ra,0x0
    80001f00:	cf2080e7          	jalr	-782(ra) # 80001bee <devintr>
    80001f04:	cd1d                	beqz	a0,80001f42 <kerneltrap+0x6e>
    if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001f06:	4789                	li	a5,2
    80001f08:	06f50a63          	beq	a0,a5,80001f7c <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001f0c:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001f10:	10049073          	csrw	sstatus,s1
}
    80001f14:	70a2                	ld	ra,40(sp)
    80001f16:	7402                	ld	s0,32(sp)
    80001f18:	64e2                	ld	s1,24(sp)
    80001f1a:	6942                	ld	s2,16(sp)
    80001f1c:	69a2                	ld	s3,8(sp)
    80001f1e:	6145                	addi	sp,sp,48
    80001f20:	8082                	ret
        panic("kerneltrap: not from supervisor mode");
    80001f22:	00006517          	auipc	a0,0x6
    80001f26:	47650513          	addi	a0,a0,1142 # 80008398 <states.1738+0x158>
    80001f2a:	00004097          	auipc	ra,0x4
    80001f2e:	158080e7          	jalr	344(ra) # 80006082 <panic>
        panic("kerneltrap: interrupts enabled");
    80001f32:	00006517          	auipc	a0,0x6
    80001f36:	48e50513          	addi	a0,a0,1166 # 800083c0 <states.1738+0x180>
    80001f3a:	00004097          	auipc	ra,0x4
    80001f3e:	148080e7          	jalr	328(ra) # 80006082 <panic>
        printf("scause %p\n", scause);
    80001f42:	85ce                	mv	a1,s3
    80001f44:	00006517          	auipc	a0,0x6
    80001f48:	49c50513          	addi	a0,a0,1180 # 800083e0 <states.1738+0x1a0>
    80001f4c:	00004097          	auipc	ra,0x4
    80001f50:	180080e7          	jalr	384(ra) # 800060cc <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f54:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001f58:	14302673          	csrr	a2,stval
        printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001f5c:	00006517          	auipc	a0,0x6
    80001f60:	49450513          	addi	a0,a0,1172 # 800083f0 <states.1738+0x1b0>
    80001f64:	00004097          	auipc	ra,0x4
    80001f68:	168080e7          	jalr	360(ra) # 800060cc <printf>
        panic("kerneltrap");
    80001f6c:	00006517          	auipc	a0,0x6
    80001f70:	49c50513          	addi	a0,a0,1180 # 80008408 <states.1738+0x1c8>
    80001f74:	00004097          	auipc	ra,0x4
    80001f78:	10e080e7          	jalr	270(ra) # 80006082 <panic>
    if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001f7c:	fffff097          	auipc	ra,0xfffff
    80001f80:	ee6080e7          	jalr	-282(ra) # 80000e62 <myproc>
    80001f84:	d541                	beqz	a0,80001f0c <kerneltrap+0x38>
    80001f86:	fffff097          	auipc	ra,0xfffff
    80001f8a:	edc080e7          	jalr	-292(ra) # 80000e62 <myproc>
    80001f8e:	4d18                	lw	a4,24(a0)
    80001f90:	4791                	li	a5,4
    80001f92:	f6f71de3          	bne	a4,a5,80001f0c <kerneltrap+0x38>
        yield();
    80001f96:	fffff097          	auipc	ra,0xfffff
    80001f9a:	534080e7          	jalr	1332(ra) # 800014ca <yield>
    80001f9e:	b7bd                	j	80001f0c <kerneltrap+0x38>

0000000080001fa0 <argraw>:
    return strlen(buf);
}

static uint64
argraw(int n)
{
    80001fa0:	1101                	addi	sp,sp,-32
    80001fa2:	ec06                	sd	ra,24(sp)
    80001fa4:	e822                	sd	s0,16(sp)
    80001fa6:	e426                	sd	s1,8(sp)
    80001fa8:	1000                	addi	s0,sp,32
    80001faa:	84aa                	mv	s1,a0
    struct proc *p = myproc();
    80001fac:	fffff097          	auipc	ra,0xfffff
    80001fb0:	eb6080e7          	jalr	-330(ra) # 80000e62 <myproc>
    switch (n)
    80001fb4:	4795                	li	a5,5
    80001fb6:	0497e163          	bltu	a5,s1,80001ff8 <argraw+0x58>
    80001fba:	048a                	slli	s1,s1,0x2
    80001fbc:	00006717          	auipc	a4,0x6
    80001fc0:	48470713          	addi	a4,a4,1156 # 80008440 <states.1738+0x200>
    80001fc4:	94ba                	add	s1,s1,a4
    80001fc6:	409c                	lw	a5,0(s1)
    80001fc8:	97ba                	add	a5,a5,a4
    80001fca:	8782                	jr	a5
    {
    case 0:
        return p->trapframe->a0;
    80001fcc:	6d3c                	ld	a5,88(a0)
    80001fce:	7ba8                	ld	a0,112(a5)
    case 5:
        return p->trapframe->a5;
    }
    panic("argraw");
    return -1;
}
    80001fd0:	60e2                	ld	ra,24(sp)
    80001fd2:	6442                	ld	s0,16(sp)
    80001fd4:	64a2                	ld	s1,8(sp)
    80001fd6:	6105                	addi	sp,sp,32
    80001fd8:	8082                	ret
        return p->trapframe->a1;
    80001fda:	6d3c                	ld	a5,88(a0)
    80001fdc:	7fa8                	ld	a0,120(a5)
    80001fde:	bfcd                	j	80001fd0 <argraw+0x30>
        return p->trapframe->a2;
    80001fe0:	6d3c                	ld	a5,88(a0)
    80001fe2:	63c8                	ld	a0,128(a5)
    80001fe4:	b7f5                	j	80001fd0 <argraw+0x30>
        return p->trapframe->a3;
    80001fe6:	6d3c                	ld	a5,88(a0)
    80001fe8:	67c8                	ld	a0,136(a5)
    80001fea:	b7dd                	j	80001fd0 <argraw+0x30>
        return p->trapframe->a4;
    80001fec:	6d3c                	ld	a5,88(a0)
    80001fee:	6bc8                	ld	a0,144(a5)
    80001ff0:	b7c5                	j	80001fd0 <argraw+0x30>
        return p->trapframe->a5;
    80001ff2:	6d3c                	ld	a5,88(a0)
    80001ff4:	6fc8                	ld	a0,152(a5)
    80001ff6:	bfe9                	j	80001fd0 <argraw+0x30>
    panic("argraw");
    80001ff8:	00006517          	auipc	a0,0x6
    80001ffc:	42050513          	addi	a0,a0,1056 # 80008418 <states.1738+0x1d8>
    80002000:	00004097          	auipc	ra,0x4
    80002004:	082080e7          	jalr	130(ra) # 80006082 <panic>

0000000080002008 <fetchaddr>:
{
    80002008:	1101                	addi	sp,sp,-32
    8000200a:	ec06                	sd	ra,24(sp)
    8000200c:	e822                	sd	s0,16(sp)
    8000200e:	e426                	sd	s1,8(sp)
    80002010:	e04a                	sd	s2,0(sp)
    80002012:	1000                	addi	s0,sp,32
    80002014:	84aa                	mv	s1,a0
    80002016:	892e                	mv	s2,a1
    struct proc *p = myproc();
    80002018:	fffff097          	auipc	ra,0xfffff
    8000201c:	e4a080e7          	jalr	-438(ra) # 80000e62 <myproc>
    if (addr >= p->sz || addr + sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80002020:	653c                	ld	a5,72(a0)
    80002022:	02f4f863          	bgeu	s1,a5,80002052 <fetchaddr+0x4a>
    80002026:	00848713          	addi	a4,s1,8
    8000202a:	02e7e663          	bltu	a5,a4,80002056 <fetchaddr+0x4e>
    if (copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    8000202e:	46a1                	li	a3,8
    80002030:	8626                	mv	a2,s1
    80002032:	85ca                	mv	a1,s2
    80002034:	6928                	ld	a0,80(a0)
    80002036:	fffff097          	auipc	ra,0xfffff
    8000203a:	b76080e7          	jalr	-1162(ra) # 80000bac <copyin>
    8000203e:	00a03533          	snez	a0,a0
    80002042:	40a00533          	neg	a0,a0
}
    80002046:	60e2                	ld	ra,24(sp)
    80002048:	6442                	ld	s0,16(sp)
    8000204a:	64a2                	ld	s1,8(sp)
    8000204c:	6902                	ld	s2,0(sp)
    8000204e:	6105                	addi	sp,sp,32
    80002050:	8082                	ret
        return -1;
    80002052:	557d                	li	a0,-1
    80002054:	bfcd                	j	80002046 <fetchaddr+0x3e>
    80002056:	557d                	li	a0,-1
    80002058:	b7fd                	j	80002046 <fetchaddr+0x3e>

000000008000205a <fetchstr>:
{
    8000205a:	7179                	addi	sp,sp,-48
    8000205c:	f406                	sd	ra,40(sp)
    8000205e:	f022                	sd	s0,32(sp)
    80002060:	ec26                	sd	s1,24(sp)
    80002062:	e84a                	sd	s2,16(sp)
    80002064:	e44e                	sd	s3,8(sp)
    80002066:	1800                	addi	s0,sp,48
    80002068:	892a                	mv	s2,a0
    8000206a:	84ae                	mv	s1,a1
    8000206c:	89b2                	mv	s3,a2
    struct proc *p = myproc();
    8000206e:	fffff097          	auipc	ra,0xfffff
    80002072:	df4080e7          	jalr	-524(ra) # 80000e62 <myproc>
    if (copyinstr(p->pagetable, buf, addr, max) < 0)
    80002076:	86ce                	mv	a3,s3
    80002078:	864a                	mv	a2,s2
    8000207a:	85a6                	mv	a1,s1
    8000207c:	6928                	ld	a0,80(a0)
    8000207e:	fffff097          	auipc	ra,0xfffff
    80002082:	bba080e7          	jalr	-1094(ra) # 80000c38 <copyinstr>
    80002086:	00054e63          	bltz	a0,800020a2 <fetchstr+0x48>
    return strlen(buf);
    8000208a:	8526                	mv	a0,s1
    8000208c:	ffffe097          	auipc	ra,0xffffe
    80002090:	270080e7          	jalr	624(ra) # 800002fc <strlen>
}
    80002094:	70a2                	ld	ra,40(sp)
    80002096:	7402                	ld	s0,32(sp)
    80002098:	64e2                	ld	s1,24(sp)
    8000209a:	6942                	ld	s2,16(sp)
    8000209c:	69a2                	ld	s3,8(sp)
    8000209e:	6145                	addi	sp,sp,48
    800020a0:	8082                	ret
        return -1;
    800020a2:	557d                	li	a0,-1
    800020a4:	bfc5                	j	80002094 <fetchstr+0x3a>

00000000800020a6 <argint>:

// Fetch the nth 32-bit system call argument.
void argint(int n, int *ip)
{
    800020a6:	1101                	addi	sp,sp,-32
    800020a8:	ec06                	sd	ra,24(sp)
    800020aa:	e822                	sd	s0,16(sp)
    800020ac:	e426                	sd	s1,8(sp)
    800020ae:	1000                	addi	s0,sp,32
    800020b0:	84ae                	mv	s1,a1
    *ip = argraw(n);
    800020b2:	00000097          	auipc	ra,0x0
    800020b6:	eee080e7          	jalr	-274(ra) # 80001fa0 <argraw>
    800020ba:	c088                	sw	a0,0(s1)
}
    800020bc:	60e2                	ld	ra,24(sp)
    800020be:	6442                	ld	s0,16(sp)
    800020c0:	64a2                	ld	s1,8(sp)
    800020c2:	6105                	addi	sp,sp,32
    800020c4:	8082                	ret

00000000800020c6 <argaddr>:

// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void argaddr(int n, uint64 *ip)
{
    800020c6:	1101                	addi	sp,sp,-32
    800020c8:	ec06                	sd	ra,24(sp)
    800020ca:	e822                	sd	s0,16(sp)
    800020cc:	e426                	sd	s1,8(sp)
    800020ce:	1000                	addi	s0,sp,32
    800020d0:	84ae                	mv	s1,a1
    *ip = argraw(n);
    800020d2:	00000097          	auipc	ra,0x0
    800020d6:	ece080e7          	jalr	-306(ra) # 80001fa0 <argraw>
    800020da:	e088                	sd	a0,0(s1)
}
    800020dc:	60e2                	ld	ra,24(sp)
    800020de:	6442                	ld	s0,16(sp)
    800020e0:	64a2                	ld	s1,8(sp)
    800020e2:	6105                	addi	sp,sp,32
    800020e4:	8082                	ret

00000000800020e6 <argstr>:

// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int argstr(int n, char *buf, int max)
{
    800020e6:	7179                	addi	sp,sp,-48
    800020e8:	f406                	sd	ra,40(sp)
    800020ea:	f022                	sd	s0,32(sp)
    800020ec:	ec26                	sd	s1,24(sp)
    800020ee:	e84a                	sd	s2,16(sp)
    800020f0:	1800                	addi	s0,sp,48
    800020f2:	84ae                	mv	s1,a1
    800020f4:	8932                	mv	s2,a2
    uint64 addr;
    argaddr(n, &addr);
    800020f6:	fd840593          	addi	a1,s0,-40
    800020fa:	00000097          	auipc	ra,0x0
    800020fe:	fcc080e7          	jalr	-52(ra) # 800020c6 <argaddr>
    return fetchstr(addr, buf, max);
    80002102:	864a                	mv	a2,s2
    80002104:	85a6                	mv	a1,s1
    80002106:	fd843503          	ld	a0,-40(s0)
    8000210a:	00000097          	auipc	ra,0x0
    8000210e:	f50080e7          	jalr	-176(ra) # 8000205a <fetchstr>
}
    80002112:	70a2                	ld	ra,40(sp)
    80002114:	7402                	ld	s0,32(sp)
    80002116:	64e2                	ld	s1,24(sp)
    80002118:	6942                	ld	s2,16(sp)
    8000211a:	6145                	addi	sp,sp,48
    8000211c:	8082                	ret

000000008000211e <syscall>:
    [SYS_mmap] sys_mmap,
    [SYS_munmap] sys_munmap,
};

void syscall(void)
{
    8000211e:	1101                	addi	sp,sp,-32
    80002120:	ec06                	sd	ra,24(sp)
    80002122:	e822                	sd	s0,16(sp)
    80002124:	e426                	sd	s1,8(sp)
    80002126:	e04a                	sd	s2,0(sp)
    80002128:	1000                	addi	s0,sp,32
    int num;
    struct proc *p = myproc();
    8000212a:	fffff097          	auipc	ra,0xfffff
    8000212e:	d38080e7          	jalr	-712(ra) # 80000e62 <myproc>
    80002132:	84aa                	mv	s1,a0

    num = p->trapframe->a7;
    80002134:	05853903          	ld	s2,88(a0)
    80002138:	0a893783          	ld	a5,168(s2)
    8000213c:	0007869b          	sext.w	a3,a5
    if (num > 0 && num < NELEM(syscalls) && syscalls[num])
    80002140:	37fd                	addiw	a5,a5,-1
    80002142:	4759                	li	a4,22
    80002144:	00f76f63          	bltu	a4,a5,80002162 <syscall+0x44>
    80002148:	00369713          	slli	a4,a3,0x3
    8000214c:	00006797          	auipc	a5,0x6
    80002150:	30c78793          	addi	a5,a5,780 # 80008458 <syscalls>
    80002154:	97ba                	add	a5,a5,a4
    80002156:	639c                	ld	a5,0(a5)
    80002158:	c789                	beqz	a5,80002162 <syscall+0x44>
    {
        // Use num to lookup the system call function for num, call it,
        // and store its return value in p->trapframe->a0
        p->trapframe->a0 = syscalls[num]();
    8000215a:	9782                	jalr	a5
    8000215c:	06a93823          	sd	a0,112(s2)
    80002160:	a839                	j	8000217e <syscall+0x60>
    }
    else
    {
        printf("%d %s: unknown sys call %d\n",
    80002162:	15848613          	addi	a2,s1,344
    80002166:	588c                	lw	a1,48(s1)
    80002168:	00006517          	auipc	a0,0x6
    8000216c:	2b850513          	addi	a0,a0,696 # 80008420 <states.1738+0x1e0>
    80002170:	00004097          	auipc	ra,0x4
    80002174:	f5c080e7          	jalr	-164(ra) # 800060cc <printf>
               p->pid, p->name, num);
        p->trapframe->a0 = -1;
    80002178:	6cbc                	ld	a5,88(s1)
    8000217a:	577d                	li	a4,-1
    8000217c:	fbb8                	sd	a4,112(a5)
    }
}
    8000217e:	60e2                	ld	ra,24(sp)
    80002180:	6442                	ld	s0,16(sp)
    80002182:	64a2                	ld	s1,8(sp)
    80002184:	6902                	ld	s2,0(sp)
    80002186:	6105                	addi	sp,sp,32
    80002188:	8082                	ret

000000008000218a <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    8000218a:	1101                	addi	sp,sp,-32
    8000218c:	ec06                	sd	ra,24(sp)
    8000218e:	e822                	sd	s0,16(sp)
    80002190:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80002192:	fec40593          	addi	a1,s0,-20
    80002196:	4501                	li	a0,0
    80002198:	00000097          	auipc	ra,0x0
    8000219c:	f0e080e7          	jalr	-242(ra) # 800020a6 <argint>
  exit(n);
    800021a0:	fec42503          	lw	a0,-20(s0)
    800021a4:	fffff097          	auipc	ra,0xfffff
    800021a8:	496080e7          	jalr	1174(ra) # 8000163a <exit>
  return 0;  // not reached
}
    800021ac:	4501                	li	a0,0
    800021ae:	60e2                	ld	ra,24(sp)
    800021b0:	6442                	ld	s0,16(sp)
    800021b2:	6105                	addi	sp,sp,32
    800021b4:	8082                	ret

00000000800021b6 <sys_getpid>:

uint64
sys_getpid(void)
{
    800021b6:	1141                	addi	sp,sp,-16
    800021b8:	e406                	sd	ra,8(sp)
    800021ba:	e022                	sd	s0,0(sp)
    800021bc:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800021be:	fffff097          	auipc	ra,0xfffff
    800021c2:	ca4080e7          	jalr	-860(ra) # 80000e62 <myproc>
}
    800021c6:	5908                	lw	a0,48(a0)
    800021c8:	60a2                	ld	ra,8(sp)
    800021ca:	6402                	ld	s0,0(sp)
    800021cc:	0141                	addi	sp,sp,16
    800021ce:	8082                	ret

00000000800021d0 <sys_fork>:

uint64
sys_fork(void)
{
    800021d0:	1141                	addi	sp,sp,-16
    800021d2:	e406                	sd	ra,8(sp)
    800021d4:	e022                	sd	s0,0(sp)
    800021d6:	0800                	addi	s0,sp,16
  return fork();
    800021d8:	fffff097          	auipc	ra,0xfffff
    800021dc:	040080e7          	jalr	64(ra) # 80001218 <fork>
}
    800021e0:	60a2                	ld	ra,8(sp)
    800021e2:	6402                	ld	s0,0(sp)
    800021e4:	0141                	addi	sp,sp,16
    800021e6:	8082                	ret

00000000800021e8 <sys_wait>:

uint64
sys_wait(void)
{
    800021e8:	1101                	addi	sp,sp,-32
    800021ea:	ec06                	sd	ra,24(sp)
    800021ec:	e822                	sd	s0,16(sp)
    800021ee:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    800021f0:	fe840593          	addi	a1,s0,-24
    800021f4:	4501                	li	a0,0
    800021f6:	00000097          	auipc	ra,0x0
    800021fa:	ed0080e7          	jalr	-304(ra) # 800020c6 <argaddr>
  return wait(p);
    800021fe:	fe843503          	ld	a0,-24(s0)
    80002202:	fffff097          	auipc	ra,0xfffff
    80002206:	5de080e7          	jalr	1502(ra) # 800017e0 <wait>
}
    8000220a:	60e2                	ld	ra,24(sp)
    8000220c:	6442                	ld	s0,16(sp)
    8000220e:	6105                	addi	sp,sp,32
    80002210:	8082                	ret

0000000080002212 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002212:	7179                	addi	sp,sp,-48
    80002214:	f406                	sd	ra,40(sp)
    80002216:	f022                	sd	s0,32(sp)
    80002218:	ec26                	sd	s1,24(sp)
    8000221a:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    8000221c:	fdc40593          	addi	a1,s0,-36
    80002220:	4501                	li	a0,0
    80002222:	00000097          	auipc	ra,0x0
    80002226:	e84080e7          	jalr	-380(ra) # 800020a6 <argint>
  addr = myproc()->sz;
    8000222a:	fffff097          	auipc	ra,0xfffff
    8000222e:	c38080e7          	jalr	-968(ra) # 80000e62 <myproc>
    80002232:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    80002234:	fdc42503          	lw	a0,-36(s0)
    80002238:	fffff097          	auipc	ra,0xfffff
    8000223c:	f84080e7          	jalr	-124(ra) # 800011bc <growproc>
    80002240:	00054863          	bltz	a0,80002250 <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    80002244:	8526                	mv	a0,s1
    80002246:	70a2                	ld	ra,40(sp)
    80002248:	7402                	ld	s0,32(sp)
    8000224a:	64e2                	ld	s1,24(sp)
    8000224c:	6145                	addi	sp,sp,48
    8000224e:	8082                	ret
    return -1;
    80002250:	54fd                	li	s1,-1
    80002252:	bfcd                	j	80002244 <sys_sbrk+0x32>

0000000080002254 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002254:	7139                	addi	sp,sp,-64
    80002256:	fc06                	sd	ra,56(sp)
    80002258:	f822                	sd	s0,48(sp)
    8000225a:	f426                	sd	s1,40(sp)
    8000225c:	f04a                	sd	s2,32(sp)
    8000225e:	ec4e                	sd	s3,24(sp)
    80002260:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80002262:	fcc40593          	addi	a1,s0,-52
    80002266:	4501                	li	a0,0
    80002268:	00000097          	auipc	ra,0x0
    8000226c:	e3e080e7          	jalr	-450(ra) # 800020a6 <argint>
  if(n < 0)
    80002270:	fcc42783          	lw	a5,-52(s0)
    80002274:	0607cf63          	bltz	a5,800022f2 <sys_sleep+0x9e>
    n = 0;
  acquire(&tickslock);
    80002278:	0001e517          	auipc	a0,0x1e
    8000227c:	73850513          	addi	a0,a0,1848 # 800209b0 <tickslock>
    80002280:	00004097          	auipc	ra,0x4
    80002284:	34c080e7          	jalr	844(ra) # 800065cc <acquire>
  ticks0 = ticks;
    80002288:	00007917          	auipc	s2,0x7
    8000228c:	8c092903          	lw	s2,-1856(s2) # 80008b48 <ticks>
  while(ticks - ticks0 < n){
    80002290:	fcc42783          	lw	a5,-52(s0)
    80002294:	cf9d                	beqz	a5,800022d2 <sys_sleep+0x7e>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002296:	0001e997          	auipc	s3,0x1e
    8000229a:	71a98993          	addi	s3,s3,1818 # 800209b0 <tickslock>
    8000229e:	00007497          	auipc	s1,0x7
    800022a2:	8aa48493          	addi	s1,s1,-1878 # 80008b48 <ticks>
    if(killed(myproc())){
    800022a6:	fffff097          	auipc	ra,0xfffff
    800022aa:	bbc080e7          	jalr	-1092(ra) # 80000e62 <myproc>
    800022ae:	fffff097          	auipc	ra,0xfffff
    800022b2:	500080e7          	jalr	1280(ra) # 800017ae <killed>
    800022b6:	e129                	bnez	a0,800022f8 <sys_sleep+0xa4>
    sleep(&ticks, &tickslock);
    800022b8:	85ce                	mv	a1,s3
    800022ba:	8526                	mv	a0,s1
    800022bc:	fffff097          	auipc	ra,0xfffff
    800022c0:	24a080e7          	jalr	586(ra) # 80001506 <sleep>
  while(ticks - ticks0 < n){
    800022c4:	409c                	lw	a5,0(s1)
    800022c6:	412787bb          	subw	a5,a5,s2
    800022ca:	fcc42703          	lw	a4,-52(s0)
    800022ce:	fce7ece3          	bltu	a5,a4,800022a6 <sys_sleep+0x52>
  }
  release(&tickslock);
    800022d2:	0001e517          	auipc	a0,0x1e
    800022d6:	6de50513          	addi	a0,a0,1758 # 800209b0 <tickslock>
    800022da:	00004097          	auipc	ra,0x4
    800022de:	3a6080e7          	jalr	934(ra) # 80006680 <release>
  return 0;
    800022e2:	4501                	li	a0,0
}
    800022e4:	70e2                	ld	ra,56(sp)
    800022e6:	7442                	ld	s0,48(sp)
    800022e8:	74a2                	ld	s1,40(sp)
    800022ea:	7902                	ld	s2,32(sp)
    800022ec:	69e2                	ld	s3,24(sp)
    800022ee:	6121                	addi	sp,sp,64
    800022f0:	8082                	ret
    n = 0;
    800022f2:	fc042623          	sw	zero,-52(s0)
    800022f6:	b749                	j	80002278 <sys_sleep+0x24>
      release(&tickslock);
    800022f8:	0001e517          	auipc	a0,0x1e
    800022fc:	6b850513          	addi	a0,a0,1720 # 800209b0 <tickslock>
    80002300:	00004097          	auipc	ra,0x4
    80002304:	380080e7          	jalr	896(ra) # 80006680 <release>
      return -1;
    80002308:	557d                	li	a0,-1
    8000230a:	bfe9                	j	800022e4 <sys_sleep+0x90>

000000008000230c <sys_kill>:

uint64
sys_kill(void)
{
    8000230c:	1101                	addi	sp,sp,-32
    8000230e:	ec06                	sd	ra,24(sp)
    80002310:	e822                	sd	s0,16(sp)
    80002312:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80002314:	fec40593          	addi	a1,s0,-20
    80002318:	4501                	li	a0,0
    8000231a:	00000097          	auipc	ra,0x0
    8000231e:	d8c080e7          	jalr	-628(ra) # 800020a6 <argint>
  return kill(pid);
    80002322:	fec42503          	lw	a0,-20(s0)
    80002326:	fffff097          	auipc	ra,0xfffff
    8000232a:	3ea080e7          	jalr	1002(ra) # 80001710 <kill>
}
    8000232e:	60e2                	ld	ra,24(sp)
    80002330:	6442                	ld	s0,16(sp)
    80002332:	6105                	addi	sp,sp,32
    80002334:	8082                	ret

0000000080002336 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002336:	1101                	addi	sp,sp,-32
    80002338:	ec06                	sd	ra,24(sp)
    8000233a:	e822                	sd	s0,16(sp)
    8000233c:	e426                	sd	s1,8(sp)
    8000233e:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002340:	0001e517          	auipc	a0,0x1e
    80002344:	67050513          	addi	a0,a0,1648 # 800209b0 <tickslock>
    80002348:	00004097          	auipc	ra,0x4
    8000234c:	284080e7          	jalr	644(ra) # 800065cc <acquire>
  xticks = ticks;
    80002350:	00006497          	auipc	s1,0x6
    80002354:	7f84a483          	lw	s1,2040(s1) # 80008b48 <ticks>
  release(&tickslock);
    80002358:	0001e517          	auipc	a0,0x1e
    8000235c:	65850513          	addi	a0,a0,1624 # 800209b0 <tickslock>
    80002360:	00004097          	auipc	ra,0x4
    80002364:	320080e7          	jalr	800(ra) # 80006680 <release>
  return xticks;
}
    80002368:	02049513          	slli	a0,s1,0x20
    8000236c:	9101                	srli	a0,a0,0x20
    8000236e:	60e2                	ld	ra,24(sp)
    80002370:	6442                	ld	s0,16(sp)
    80002372:	64a2                	ld	s1,8(sp)
    80002374:	6105                	addi	sp,sp,32
    80002376:	8082                	ret

0000000080002378 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002378:	7179                	addi	sp,sp,-48
    8000237a:	f406                	sd	ra,40(sp)
    8000237c:	f022                	sd	s0,32(sp)
    8000237e:	ec26                	sd	s1,24(sp)
    80002380:	e84a                	sd	s2,16(sp)
    80002382:	e44e                	sd	s3,8(sp)
    80002384:	e052                	sd	s4,0(sp)
    80002386:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002388:	00006597          	auipc	a1,0x6
    8000238c:	19058593          	addi	a1,a1,400 # 80008518 <syscalls+0xc0>
    80002390:	0001e517          	auipc	a0,0x1e
    80002394:	63850513          	addi	a0,a0,1592 # 800209c8 <bcache>
    80002398:	00004097          	auipc	ra,0x4
    8000239c:	1a4080e7          	jalr	420(ra) # 8000653c <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800023a0:	00026797          	auipc	a5,0x26
    800023a4:	62878793          	addi	a5,a5,1576 # 800289c8 <bcache+0x8000>
    800023a8:	00027717          	auipc	a4,0x27
    800023ac:	88870713          	addi	a4,a4,-1912 # 80028c30 <bcache+0x8268>
    800023b0:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800023b4:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800023b8:	0001e497          	auipc	s1,0x1e
    800023bc:	62848493          	addi	s1,s1,1576 # 800209e0 <bcache+0x18>
    b->next = bcache.head.next;
    800023c0:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800023c2:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800023c4:	00006a17          	auipc	s4,0x6
    800023c8:	15ca0a13          	addi	s4,s4,348 # 80008520 <syscalls+0xc8>
    b->next = bcache.head.next;
    800023cc:	2b893783          	ld	a5,696(s2)
    800023d0:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800023d2:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800023d6:	85d2                	mv	a1,s4
    800023d8:	01048513          	addi	a0,s1,16
    800023dc:	00001097          	auipc	ra,0x1
    800023e0:	4c4080e7          	jalr	1220(ra) # 800038a0 <initsleeplock>
    bcache.head.next->prev = b;
    800023e4:	2b893783          	ld	a5,696(s2)
    800023e8:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800023ea:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800023ee:	45848493          	addi	s1,s1,1112
    800023f2:	fd349de3          	bne	s1,s3,800023cc <binit+0x54>
  }
}
    800023f6:	70a2                	ld	ra,40(sp)
    800023f8:	7402                	ld	s0,32(sp)
    800023fa:	64e2                	ld	s1,24(sp)
    800023fc:	6942                	ld	s2,16(sp)
    800023fe:	69a2                	ld	s3,8(sp)
    80002400:	6a02                	ld	s4,0(sp)
    80002402:	6145                	addi	sp,sp,48
    80002404:	8082                	ret

0000000080002406 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002406:	7179                	addi	sp,sp,-48
    80002408:	f406                	sd	ra,40(sp)
    8000240a:	f022                	sd	s0,32(sp)
    8000240c:	ec26                	sd	s1,24(sp)
    8000240e:	e84a                	sd	s2,16(sp)
    80002410:	e44e                	sd	s3,8(sp)
    80002412:	1800                	addi	s0,sp,48
    80002414:	89aa                	mv	s3,a0
    80002416:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    80002418:	0001e517          	auipc	a0,0x1e
    8000241c:	5b050513          	addi	a0,a0,1456 # 800209c8 <bcache>
    80002420:	00004097          	auipc	ra,0x4
    80002424:	1ac080e7          	jalr	428(ra) # 800065cc <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002428:	00027497          	auipc	s1,0x27
    8000242c:	8584b483          	ld	s1,-1960(s1) # 80028c80 <bcache+0x82b8>
    80002430:	00027797          	auipc	a5,0x27
    80002434:	80078793          	addi	a5,a5,-2048 # 80028c30 <bcache+0x8268>
    80002438:	02f48f63          	beq	s1,a5,80002476 <bread+0x70>
    8000243c:	873e                	mv	a4,a5
    8000243e:	a021                	j	80002446 <bread+0x40>
    80002440:	68a4                	ld	s1,80(s1)
    80002442:	02e48a63          	beq	s1,a4,80002476 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002446:	449c                	lw	a5,8(s1)
    80002448:	ff379ce3          	bne	a5,s3,80002440 <bread+0x3a>
    8000244c:	44dc                	lw	a5,12(s1)
    8000244e:	ff2799e3          	bne	a5,s2,80002440 <bread+0x3a>
      b->refcnt++;
    80002452:	40bc                	lw	a5,64(s1)
    80002454:	2785                	addiw	a5,a5,1
    80002456:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002458:	0001e517          	auipc	a0,0x1e
    8000245c:	57050513          	addi	a0,a0,1392 # 800209c8 <bcache>
    80002460:	00004097          	auipc	ra,0x4
    80002464:	220080e7          	jalr	544(ra) # 80006680 <release>
      acquiresleep(&b->lock);
    80002468:	01048513          	addi	a0,s1,16
    8000246c:	00001097          	auipc	ra,0x1
    80002470:	46e080e7          	jalr	1134(ra) # 800038da <acquiresleep>
      return b;
    80002474:	a8b9                	j	800024d2 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002476:	00027497          	auipc	s1,0x27
    8000247a:	8024b483          	ld	s1,-2046(s1) # 80028c78 <bcache+0x82b0>
    8000247e:	00026797          	auipc	a5,0x26
    80002482:	7b278793          	addi	a5,a5,1970 # 80028c30 <bcache+0x8268>
    80002486:	00f48863          	beq	s1,a5,80002496 <bread+0x90>
    8000248a:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    8000248c:	40bc                	lw	a5,64(s1)
    8000248e:	cf81                	beqz	a5,800024a6 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002490:	64a4                	ld	s1,72(s1)
    80002492:	fee49de3          	bne	s1,a4,8000248c <bread+0x86>
  panic("bget: no buffers");
    80002496:	00006517          	auipc	a0,0x6
    8000249a:	09250513          	addi	a0,a0,146 # 80008528 <syscalls+0xd0>
    8000249e:	00004097          	auipc	ra,0x4
    800024a2:	be4080e7          	jalr	-1052(ra) # 80006082 <panic>
      b->dev = dev;
    800024a6:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    800024aa:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    800024ae:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800024b2:	4785                	li	a5,1
    800024b4:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800024b6:	0001e517          	auipc	a0,0x1e
    800024ba:	51250513          	addi	a0,a0,1298 # 800209c8 <bcache>
    800024be:	00004097          	auipc	ra,0x4
    800024c2:	1c2080e7          	jalr	450(ra) # 80006680 <release>
      acquiresleep(&b->lock);
    800024c6:	01048513          	addi	a0,s1,16
    800024ca:	00001097          	auipc	ra,0x1
    800024ce:	410080e7          	jalr	1040(ra) # 800038da <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800024d2:	409c                	lw	a5,0(s1)
    800024d4:	cb89                	beqz	a5,800024e6 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800024d6:	8526                	mv	a0,s1
    800024d8:	70a2                	ld	ra,40(sp)
    800024da:	7402                	ld	s0,32(sp)
    800024dc:	64e2                	ld	s1,24(sp)
    800024de:	6942                	ld	s2,16(sp)
    800024e0:	69a2                	ld	s3,8(sp)
    800024e2:	6145                	addi	sp,sp,48
    800024e4:	8082                	ret
    virtio_disk_rw(b, 0);
    800024e6:	4581                	li	a1,0
    800024e8:	8526                	mv	a0,s1
    800024ea:	00003097          	auipc	ra,0x3
    800024ee:	32e080e7          	jalr	814(ra) # 80005818 <virtio_disk_rw>
    b->valid = 1;
    800024f2:	4785                	li	a5,1
    800024f4:	c09c                	sw	a5,0(s1)
  return b;
    800024f6:	b7c5                	j	800024d6 <bread+0xd0>

00000000800024f8 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800024f8:	1101                	addi	sp,sp,-32
    800024fa:	ec06                	sd	ra,24(sp)
    800024fc:	e822                	sd	s0,16(sp)
    800024fe:	e426                	sd	s1,8(sp)
    80002500:	1000                	addi	s0,sp,32
    80002502:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002504:	0541                	addi	a0,a0,16
    80002506:	00001097          	auipc	ra,0x1
    8000250a:	46e080e7          	jalr	1134(ra) # 80003974 <holdingsleep>
    8000250e:	cd01                	beqz	a0,80002526 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002510:	4585                	li	a1,1
    80002512:	8526                	mv	a0,s1
    80002514:	00003097          	auipc	ra,0x3
    80002518:	304080e7          	jalr	772(ra) # 80005818 <virtio_disk_rw>
}
    8000251c:	60e2                	ld	ra,24(sp)
    8000251e:	6442                	ld	s0,16(sp)
    80002520:	64a2                	ld	s1,8(sp)
    80002522:	6105                	addi	sp,sp,32
    80002524:	8082                	ret
    panic("bwrite");
    80002526:	00006517          	auipc	a0,0x6
    8000252a:	01a50513          	addi	a0,a0,26 # 80008540 <syscalls+0xe8>
    8000252e:	00004097          	auipc	ra,0x4
    80002532:	b54080e7          	jalr	-1196(ra) # 80006082 <panic>

0000000080002536 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002536:	1101                	addi	sp,sp,-32
    80002538:	ec06                	sd	ra,24(sp)
    8000253a:	e822                	sd	s0,16(sp)
    8000253c:	e426                	sd	s1,8(sp)
    8000253e:	e04a                	sd	s2,0(sp)
    80002540:	1000                	addi	s0,sp,32
    80002542:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002544:	01050913          	addi	s2,a0,16
    80002548:	854a                	mv	a0,s2
    8000254a:	00001097          	auipc	ra,0x1
    8000254e:	42a080e7          	jalr	1066(ra) # 80003974 <holdingsleep>
    80002552:	c92d                	beqz	a0,800025c4 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    80002554:	854a                	mv	a0,s2
    80002556:	00001097          	auipc	ra,0x1
    8000255a:	3da080e7          	jalr	986(ra) # 80003930 <releasesleep>

  acquire(&bcache.lock);
    8000255e:	0001e517          	auipc	a0,0x1e
    80002562:	46a50513          	addi	a0,a0,1130 # 800209c8 <bcache>
    80002566:	00004097          	auipc	ra,0x4
    8000256a:	066080e7          	jalr	102(ra) # 800065cc <acquire>
  b->refcnt--;
    8000256e:	40bc                	lw	a5,64(s1)
    80002570:	37fd                	addiw	a5,a5,-1
    80002572:	0007871b          	sext.w	a4,a5
    80002576:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002578:	eb05                	bnez	a4,800025a8 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000257a:	68bc                	ld	a5,80(s1)
    8000257c:	64b8                	ld	a4,72(s1)
    8000257e:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80002580:	64bc                	ld	a5,72(s1)
    80002582:	68b8                	ld	a4,80(s1)
    80002584:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002586:	00026797          	auipc	a5,0x26
    8000258a:	44278793          	addi	a5,a5,1090 # 800289c8 <bcache+0x8000>
    8000258e:	2b87b703          	ld	a4,696(a5)
    80002592:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002594:	00026717          	auipc	a4,0x26
    80002598:	69c70713          	addi	a4,a4,1692 # 80028c30 <bcache+0x8268>
    8000259c:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    8000259e:	2b87b703          	ld	a4,696(a5)
    800025a2:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800025a4:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800025a8:	0001e517          	auipc	a0,0x1e
    800025ac:	42050513          	addi	a0,a0,1056 # 800209c8 <bcache>
    800025b0:	00004097          	auipc	ra,0x4
    800025b4:	0d0080e7          	jalr	208(ra) # 80006680 <release>
}
    800025b8:	60e2                	ld	ra,24(sp)
    800025ba:	6442                	ld	s0,16(sp)
    800025bc:	64a2                	ld	s1,8(sp)
    800025be:	6902                	ld	s2,0(sp)
    800025c0:	6105                	addi	sp,sp,32
    800025c2:	8082                	ret
    panic("brelse");
    800025c4:	00006517          	auipc	a0,0x6
    800025c8:	f8450513          	addi	a0,a0,-124 # 80008548 <syscalls+0xf0>
    800025cc:	00004097          	auipc	ra,0x4
    800025d0:	ab6080e7          	jalr	-1354(ra) # 80006082 <panic>

00000000800025d4 <bpin>:

void
bpin(struct buf *b) {
    800025d4:	1101                	addi	sp,sp,-32
    800025d6:	ec06                	sd	ra,24(sp)
    800025d8:	e822                	sd	s0,16(sp)
    800025da:	e426                	sd	s1,8(sp)
    800025dc:	1000                	addi	s0,sp,32
    800025de:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800025e0:	0001e517          	auipc	a0,0x1e
    800025e4:	3e850513          	addi	a0,a0,1000 # 800209c8 <bcache>
    800025e8:	00004097          	auipc	ra,0x4
    800025ec:	fe4080e7          	jalr	-28(ra) # 800065cc <acquire>
  b->refcnt++;
    800025f0:	40bc                	lw	a5,64(s1)
    800025f2:	2785                	addiw	a5,a5,1
    800025f4:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800025f6:	0001e517          	auipc	a0,0x1e
    800025fa:	3d250513          	addi	a0,a0,978 # 800209c8 <bcache>
    800025fe:	00004097          	auipc	ra,0x4
    80002602:	082080e7          	jalr	130(ra) # 80006680 <release>
}
    80002606:	60e2                	ld	ra,24(sp)
    80002608:	6442                	ld	s0,16(sp)
    8000260a:	64a2                	ld	s1,8(sp)
    8000260c:	6105                	addi	sp,sp,32
    8000260e:	8082                	ret

0000000080002610 <bunpin>:

void
bunpin(struct buf *b) {
    80002610:	1101                	addi	sp,sp,-32
    80002612:	ec06                	sd	ra,24(sp)
    80002614:	e822                	sd	s0,16(sp)
    80002616:	e426                	sd	s1,8(sp)
    80002618:	1000                	addi	s0,sp,32
    8000261a:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000261c:	0001e517          	auipc	a0,0x1e
    80002620:	3ac50513          	addi	a0,a0,940 # 800209c8 <bcache>
    80002624:	00004097          	auipc	ra,0x4
    80002628:	fa8080e7          	jalr	-88(ra) # 800065cc <acquire>
  b->refcnt--;
    8000262c:	40bc                	lw	a5,64(s1)
    8000262e:	37fd                	addiw	a5,a5,-1
    80002630:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002632:	0001e517          	auipc	a0,0x1e
    80002636:	39650513          	addi	a0,a0,918 # 800209c8 <bcache>
    8000263a:	00004097          	auipc	ra,0x4
    8000263e:	046080e7          	jalr	70(ra) # 80006680 <release>
}
    80002642:	60e2                	ld	ra,24(sp)
    80002644:	6442                	ld	s0,16(sp)
    80002646:	64a2                	ld	s1,8(sp)
    80002648:	6105                	addi	sp,sp,32
    8000264a:	8082                	ret

000000008000264c <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    8000264c:	1101                	addi	sp,sp,-32
    8000264e:	ec06                	sd	ra,24(sp)
    80002650:	e822                	sd	s0,16(sp)
    80002652:	e426                	sd	s1,8(sp)
    80002654:	e04a                	sd	s2,0(sp)
    80002656:	1000                	addi	s0,sp,32
    80002658:	84ae                	mv	s1,a1
    struct buf *bp;
    int bi, m;

    bp = bread(dev, BBLOCK(b, sb));
    8000265a:	00d5d59b          	srliw	a1,a1,0xd
    8000265e:	00027797          	auipc	a5,0x27
    80002662:	a467a783          	lw	a5,-1466(a5) # 800290a4 <sb+0x1c>
    80002666:	9dbd                	addw	a1,a1,a5
    80002668:	00000097          	auipc	ra,0x0
    8000266c:	d9e080e7          	jalr	-610(ra) # 80002406 <bread>
    bi = b % BPB;
    m = 1 << (bi % 8);
    80002670:	0074f713          	andi	a4,s1,7
    80002674:	4785                	li	a5,1
    80002676:	00e797bb          	sllw	a5,a5,a4
    if ((bp->data[bi / 8] & m) == 0)
    8000267a:	14ce                	slli	s1,s1,0x33
    8000267c:	90d9                	srli	s1,s1,0x36
    8000267e:	00950733          	add	a4,a0,s1
    80002682:	05874703          	lbu	a4,88(a4)
    80002686:	00e7f6b3          	and	a3,a5,a4
    8000268a:	c69d                	beqz	a3,800026b8 <bfree+0x6c>
    8000268c:	892a                	mv	s2,a0
        panic("freeing free block");
    bp->data[bi / 8] &= ~m;
    8000268e:	94aa                	add	s1,s1,a0
    80002690:	fff7c793          	not	a5,a5
    80002694:	8ff9                	and	a5,a5,a4
    80002696:	04f48c23          	sb	a5,88(s1)
    log_write(bp);
    8000269a:	00001097          	auipc	ra,0x1
    8000269e:	120080e7          	jalr	288(ra) # 800037ba <log_write>
    brelse(bp);
    800026a2:	854a                	mv	a0,s2
    800026a4:	00000097          	auipc	ra,0x0
    800026a8:	e92080e7          	jalr	-366(ra) # 80002536 <brelse>
}
    800026ac:	60e2                	ld	ra,24(sp)
    800026ae:	6442                	ld	s0,16(sp)
    800026b0:	64a2                	ld	s1,8(sp)
    800026b2:	6902                	ld	s2,0(sp)
    800026b4:	6105                	addi	sp,sp,32
    800026b6:	8082                	ret
        panic("freeing free block");
    800026b8:	00006517          	auipc	a0,0x6
    800026bc:	e9850513          	addi	a0,a0,-360 # 80008550 <syscalls+0xf8>
    800026c0:	00004097          	auipc	ra,0x4
    800026c4:	9c2080e7          	jalr	-1598(ra) # 80006082 <panic>

00000000800026c8 <balloc>:
{
    800026c8:	711d                	addi	sp,sp,-96
    800026ca:	ec86                	sd	ra,88(sp)
    800026cc:	e8a2                	sd	s0,80(sp)
    800026ce:	e4a6                	sd	s1,72(sp)
    800026d0:	e0ca                	sd	s2,64(sp)
    800026d2:	fc4e                	sd	s3,56(sp)
    800026d4:	f852                	sd	s4,48(sp)
    800026d6:	f456                	sd	s5,40(sp)
    800026d8:	f05a                	sd	s6,32(sp)
    800026da:	ec5e                	sd	s7,24(sp)
    800026dc:	e862                	sd	s8,16(sp)
    800026de:	e466                	sd	s9,8(sp)
    800026e0:	1080                	addi	s0,sp,96
    for (b = 0; b < sb.size; b += BPB)
    800026e2:	00027797          	auipc	a5,0x27
    800026e6:	9aa7a783          	lw	a5,-1622(a5) # 8002908c <sb+0x4>
    800026ea:	10078163          	beqz	a5,800027ec <balloc+0x124>
    800026ee:	8baa                	mv	s7,a0
    800026f0:	4a81                	li	s5,0
        bp = bread(dev, BBLOCK(b, sb));
    800026f2:	00027b17          	auipc	s6,0x27
    800026f6:	996b0b13          	addi	s6,s6,-1642 # 80029088 <sb>
        for (bi = 0; bi < BPB && b + bi < sb.size; bi++)
    800026fa:	4c01                	li	s8,0
            m = 1 << (bi % 8);
    800026fc:	4985                	li	s3,1
        for (bi = 0; bi < BPB && b + bi < sb.size; bi++)
    800026fe:	6a09                	lui	s4,0x2
    for (b = 0; b < sb.size; b += BPB)
    80002700:	6c89                	lui	s9,0x2
    80002702:	a061                	j	8000278a <balloc+0xc2>
                bp->data[bi / 8] |= m; // Mark block in use.
    80002704:	974a                	add	a4,a4,s2
    80002706:	8fd5                	or	a5,a5,a3
    80002708:	04f70c23          	sb	a5,88(a4)
                log_write(bp);
    8000270c:	854a                	mv	a0,s2
    8000270e:	00001097          	auipc	ra,0x1
    80002712:	0ac080e7          	jalr	172(ra) # 800037ba <log_write>
                brelse(bp);
    80002716:	854a                	mv	a0,s2
    80002718:	00000097          	auipc	ra,0x0
    8000271c:	e1e080e7          	jalr	-482(ra) # 80002536 <brelse>
    bp = bread(dev, bno);
    80002720:	85a6                	mv	a1,s1
    80002722:	855e                	mv	a0,s7
    80002724:	00000097          	auipc	ra,0x0
    80002728:	ce2080e7          	jalr	-798(ra) # 80002406 <bread>
    8000272c:	892a                	mv	s2,a0
    memset(bp->data, 0, BSIZE);
    8000272e:	40000613          	li	a2,1024
    80002732:	4581                	li	a1,0
    80002734:	05850513          	addi	a0,a0,88
    80002738:	ffffe097          	auipc	ra,0xffffe
    8000273c:	a40080e7          	jalr	-1472(ra) # 80000178 <memset>
    log_write(bp);
    80002740:	854a                	mv	a0,s2
    80002742:	00001097          	auipc	ra,0x1
    80002746:	078080e7          	jalr	120(ra) # 800037ba <log_write>
    brelse(bp);
    8000274a:	854a                	mv	a0,s2
    8000274c:	00000097          	auipc	ra,0x0
    80002750:	dea080e7          	jalr	-534(ra) # 80002536 <brelse>
}
    80002754:	8526                	mv	a0,s1
    80002756:	60e6                	ld	ra,88(sp)
    80002758:	6446                	ld	s0,80(sp)
    8000275a:	64a6                	ld	s1,72(sp)
    8000275c:	6906                	ld	s2,64(sp)
    8000275e:	79e2                	ld	s3,56(sp)
    80002760:	7a42                	ld	s4,48(sp)
    80002762:	7aa2                	ld	s5,40(sp)
    80002764:	7b02                	ld	s6,32(sp)
    80002766:	6be2                	ld	s7,24(sp)
    80002768:	6c42                	ld	s8,16(sp)
    8000276a:	6ca2                	ld	s9,8(sp)
    8000276c:	6125                	addi	sp,sp,96
    8000276e:	8082                	ret
        brelse(bp);
    80002770:	854a                	mv	a0,s2
    80002772:	00000097          	auipc	ra,0x0
    80002776:	dc4080e7          	jalr	-572(ra) # 80002536 <brelse>
    for (b = 0; b < sb.size; b += BPB)
    8000277a:	015c87bb          	addw	a5,s9,s5
    8000277e:	00078a9b          	sext.w	s5,a5
    80002782:	004b2703          	lw	a4,4(s6)
    80002786:	06eaf363          	bgeu	s5,a4,800027ec <balloc+0x124>
        bp = bread(dev, BBLOCK(b, sb));
    8000278a:	41fad79b          	sraiw	a5,s5,0x1f
    8000278e:	0137d79b          	srliw	a5,a5,0x13
    80002792:	015787bb          	addw	a5,a5,s5
    80002796:	40d7d79b          	sraiw	a5,a5,0xd
    8000279a:	01cb2583          	lw	a1,28(s6)
    8000279e:	9dbd                	addw	a1,a1,a5
    800027a0:	855e                	mv	a0,s7
    800027a2:	00000097          	auipc	ra,0x0
    800027a6:	c64080e7          	jalr	-924(ra) # 80002406 <bread>
    800027aa:	892a                	mv	s2,a0
        for (bi = 0; bi < BPB && b + bi < sb.size; bi++)
    800027ac:	004b2503          	lw	a0,4(s6)
    800027b0:	000a849b          	sext.w	s1,s5
    800027b4:	8662                	mv	a2,s8
    800027b6:	faa4fde3          	bgeu	s1,a0,80002770 <balloc+0xa8>
            m = 1 << (bi % 8);
    800027ba:	41f6579b          	sraiw	a5,a2,0x1f
    800027be:	01d7d69b          	srliw	a3,a5,0x1d
    800027c2:	00c6873b          	addw	a4,a3,a2
    800027c6:	00777793          	andi	a5,a4,7
    800027ca:	9f95                	subw	a5,a5,a3
    800027cc:	00f997bb          	sllw	a5,s3,a5
            if ((bp->data[bi / 8] & m) == 0)
    800027d0:	4037571b          	sraiw	a4,a4,0x3
    800027d4:	00e906b3          	add	a3,s2,a4
    800027d8:	0586c683          	lbu	a3,88(a3)
    800027dc:	00d7f5b3          	and	a1,a5,a3
    800027e0:	d195                	beqz	a1,80002704 <balloc+0x3c>
        for (bi = 0; bi < BPB && b + bi < sb.size; bi++)
    800027e2:	2605                	addiw	a2,a2,1
    800027e4:	2485                	addiw	s1,s1,1
    800027e6:	fd4618e3          	bne	a2,s4,800027b6 <balloc+0xee>
    800027ea:	b759                	j	80002770 <balloc+0xa8>
    printf("balloc: out of blocks\n");
    800027ec:	00006517          	auipc	a0,0x6
    800027f0:	d7c50513          	addi	a0,a0,-644 # 80008568 <syscalls+0x110>
    800027f4:	00004097          	auipc	ra,0x4
    800027f8:	8d8080e7          	jalr	-1832(ra) # 800060cc <printf>
    return 0;
    800027fc:	4481                	li	s1,0
    800027fe:	bf99                	j	80002754 <balloc+0x8c>

0000000080002800 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80002800:	7179                	addi	sp,sp,-48
    80002802:	f406                	sd	ra,40(sp)
    80002804:	f022                	sd	s0,32(sp)
    80002806:	ec26                	sd	s1,24(sp)
    80002808:	e84a                	sd	s2,16(sp)
    8000280a:	e44e                	sd	s3,8(sp)
    8000280c:	e052                	sd	s4,0(sp)
    8000280e:	1800                	addi	s0,sp,48
    80002810:	89aa                	mv	s3,a0
    uint addr, *a;
    struct buf *bp;

    if (bn < NDIRECT)
    80002812:	47ad                	li	a5,11
    80002814:	02b7e763          	bltu	a5,a1,80002842 <bmap+0x42>
    {
        if ((addr = ip->addrs[bn]) == 0)
    80002818:	02059493          	slli	s1,a1,0x20
    8000281c:	9081                	srli	s1,s1,0x20
    8000281e:	048a                	slli	s1,s1,0x2
    80002820:	94aa                	add	s1,s1,a0
    80002822:	0504a903          	lw	s2,80(s1)
    80002826:	06091e63          	bnez	s2,800028a2 <bmap+0xa2>
        {
            addr = balloc(ip->dev);
    8000282a:	4108                	lw	a0,0(a0)
    8000282c:	00000097          	auipc	ra,0x0
    80002830:	e9c080e7          	jalr	-356(ra) # 800026c8 <balloc>
    80002834:	0005091b          	sext.w	s2,a0
            if (addr == 0)
    80002838:	06090563          	beqz	s2,800028a2 <bmap+0xa2>
                return 0;
            ip->addrs[bn] = addr;
    8000283c:	0524a823          	sw	s2,80(s1)
    80002840:	a08d                	j	800028a2 <bmap+0xa2>
        }
        return addr;
    }
    bn -= NDIRECT;
    80002842:	ff45849b          	addiw	s1,a1,-12
    80002846:	0004871b          	sext.w	a4,s1

    if (bn < NINDIRECT)
    8000284a:	0ff00793          	li	a5,255
    8000284e:	08e7e563          	bltu	a5,a4,800028d8 <bmap+0xd8>
    {
        // Load indirect block, allocating if necessary.
        if ((addr = ip->addrs[NDIRECT]) == 0)
    80002852:	08052903          	lw	s2,128(a0)
    80002856:	00091d63          	bnez	s2,80002870 <bmap+0x70>
        {
            addr = balloc(ip->dev);
    8000285a:	4108                	lw	a0,0(a0)
    8000285c:	00000097          	auipc	ra,0x0
    80002860:	e6c080e7          	jalr	-404(ra) # 800026c8 <balloc>
    80002864:	0005091b          	sext.w	s2,a0
            if (addr == 0)
    80002868:	02090d63          	beqz	s2,800028a2 <bmap+0xa2>
                return 0;
            ip->addrs[NDIRECT] = addr;
    8000286c:	0929a023          	sw	s2,128(s3)
        }
        bp = bread(ip->dev, addr);
    80002870:	85ca                	mv	a1,s2
    80002872:	0009a503          	lw	a0,0(s3)
    80002876:	00000097          	auipc	ra,0x0
    8000287a:	b90080e7          	jalr	-1136(ra) # 80002406 <bread>
    8000287e:	8a2a                	mv	s4,a0
        a = (uint *)bp->data;
    80002880:	05850793          	addi	a5,a0,88
        if ((addr = a[bn]) == 0)
    80002884:	02049593          	slli	a1,s1,0x20
    80002888:	9181                	srli	a1,a1,0x20
    8000288a:	058a                	slli	a1,a1,0x2
    8000288c:	00b784b3          	add	s1,a5,a1
    80002890:	0004a903          	lw	s2,0(s1)
    80002894:	02090063          	beqz	s2,800028b4 <bmap+0xb4>
            {
                a[bn] = addr;
                log_write(bp);
            }
        }
        brelse(bp);
    80002898:	8552                	mv	a0,s4
    8000289a:	00000097          	auipc	ra,0x0
    8000289e:	c9c080e7          	jalr	-868(ra) # 80002536 <brelse>
        return addr;
    }

    panic("bmap: out of range");
}
    800028a2:	854a                	mv	a0,s2
    800028a4:	70a2                	ld	ra,40(sp)
    800028a6:	7402                	ld	s0,32(sp)
    800028a8:	64e2                	ld	s1,24(sp)
    800028aa:	6942                	ld	s2,16(sp)
    800028ac:	69a2                	ld	s3,8(sp)
    800028ae:	6a02                	ld	s4,0(sp)
    800028b0:	6145                	addi	sp,sp,48
    800028b2:	8082                	ret
            addr = balloc(ip->dev);
    800028b4:	0009a503          	lw	a0,0(s3)
    800028b8:	00000097          	auipc	ra,0x0
    800028bc:	e10080e7          	jalr	-496(ra) # 800026c8 <balloc>
    800028c0:	0005091b          	sext.w	s2,a0
            if (addr)
    800028c4:	fc090ae3          	beqz	s2,80002898 <bmap+0x98>
                a[bn] = addr;
    800028c8:	0124a023          	sw	s2,0(s1)
                log_write(bp);
    800028cc:	8552                	mv	a0,s4
    800028ce:	00001097          	auipc	ra,0x1
    800028d2:	eec080e7          	jalr	-276(ra) # 800037ba <log_write>
    800028d6:	b7c9                	j	80002898 <bmap+0x98>
    panic("bmap: out of range");
    800028d8:	00006517          	auipc	a0,0x6
    800028dc:	ca850513          	addi	a0,a0,-856 # 80008580 <syscalls+0x128>
    800028e0:	00003097          	auipc	ra,0x3
    800028e4:	7a2080e7          	jalr	1954(ra) # 80006082 <panic>

00000000800028e8 <iget>:
{
    800028e8:	7179                	addi	sp,sp,-48
    800028ea:	f406                	sd	ra,40(sp)
    800028ec:	f022                	sd	s0,32(sp)
    800028ee:	ec26                	sd	s1,24(sp)
    800028f0:	e84a                	sd	s2,16(sp)
    800028f2:	e44e                	sd	s3,8(sp)
    800028f4:	e052                	sd	s4,0(sp)
    800028f6:	1800                	addi	s0,sp,48
    800028f8:	89aa                	mv	s3,a0
    800028fa:	8a2e                	mv	s4,a1
    acquire(&itable.lock);
    800028fc:	00026517          	auipc	a0,0x26
    80002900:	7ac50513          	addi	a0,a0,1964 # 800290a8 <itable>
    80002904:	00004097          	auipc	ra,0x4
    80002908:	cc8080e7          	jalr	-824(ra) # 800065cc <acquire>
    empty = 0;
    8000290c:	4901                	li	s2,0
    for (ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++)
    8000290e:	00026497          	auipc	s1,0x26
    80002912:	7b248493          	addi	s1,s1,1970 # 800290c0 <itable+0x18>
    80002916:	00028697          	auipc	a3,0x28
    8000291a:	23a68693          	addi	a3,a3,570 # 8002ab50 <log>
    8000291e:	a039                	j	8000292c <iget+0x44>
        if (empty == 0 && ip->ref == 0) // Remember empty slot.
    80002920:	02090b63          	beqz	s2,80002956 <iget+0x6e>
    for (ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++)
    80002924:	08848493          	addi	s1,s1,136
    80002928:	02d48a63          	beq	s1,a3,8000295c <iget+0x74>
        if (ip->ref > 0 && ip->dev == dev && ip->inum == inum)
    8000292c:	449c                	lw	a5,8(s1)
    8000292e:	fef059e3          	blez	a5,80002920 <iget+0x38>
    80002932:	4098                	lw	a4,0(s1)
    80002934:	ff3716e3          	bne	a4,s3,80002920 <iget+0x38>
    80002938:	40d8                	lw	a4,4(s1)
    8000293a:	ff4713e3          	bne	a4,s4,80002920 <iget+0x38>
            ip->ref++;
    8000293e:	2785                	addiw	a5,a5,1
    80002940:	c49c                	sw	a5,8(s1)
            release(&itable.lock);
    80002942:	00026517          	auipc	a0,0x26
    80002946:	76650513          	addi	a0,a0,1894 # 800290a8 <itable>
    8000294a:	00004097          	auipc	ra,0x4
    8000294e:	d36080e7          	jalr	-714(ra) # 80006680 <release>
            return ip;
    80002952:	8926                	mv	s2,s1
    80002954:	a03d                	j	80002982 <iget+0x9a>
        if (empty == 0 && ip->ref == 0) // Remember empty slot.
    80002956:	f7f9                	bnez	a5,80002924 <iget+0x3c>
    80002958:	8926                	mv	s2,s1
    8000295a:	b7e9                	j	80002924 <iget+0x3c>
    if (empty == 0)
    8000295c:	02090c63          	beqz	s2,80002994 <iget+0xac>
    ip->dev = dev;
    80002960:	01392023          	sw	s3,0(s2)
    ip->inum = inum;
    80002964:	01492223          	sw	s4,4(s2)
    ip->ref = 1;
    80002968:	4785                	li	a5,1
    8000296a:	00f92423          	sw	a5,8(s2)
    ip->valid = 0;
    8000296e:	04092023          	sw	zero,64(s2)
    release(&itable.lock);
    80002972:	00026517          	auipc	a0,0x26
    80002976:	73650513          	addi	a0,a0,1846 # 800290a8 <itable>
    8000297a:	00004097          	auipc	ra,0x4
    8000297e:	d06080e7          	jalr	-762(ra) # 80006680 <release>
}
    80002982:	854a                	mv	a0,s2
    80002984:	70a2                	ld	ra,40(sp)
    80002986:	7402                	ld	s0,32(sp)
    80002988:	64e2                	ld	s1,24(sp)
    8000298a:	6942                	ld	s2,16(sp)
    8000298c:	69a2                	ld	s3,8(sp)
    8000298e:	6a02                	ld	s4,0(sp)
    80002990:	6145                	addi	sp,sp,48
    80002992:	8082                	ret
        panic("iget: no inodes");
    80002994:	00006517          	auipc	a0,0x6
    80002998:	c0450513          	addi	a0,a0,-1020 # 80008598 <syscalls+0x140>
    8000299c:	00003097          	auipc	ra,0x3
    800029a0:	6e6080e7          	jalr	1766(ra) # 80006082 <panic>

00000000800029a4 <fsinit>:
{
    800029a4:	7179                	addi	sp,sp,-48
    800029a6:	f406                	sd	ra,40(sp)
    800029a8:	f022                	sd	s0,32(sp)
    800029aa:	ec26                	sd	s1,24(sp)
    800029ac:	e84a                	sd	s2,16(sp)
    800029ae:	e44e                	sd	s3,8(sp)
    800029b0:	1800                	addi	s0,sp,48
    800029b2:	892a                	mv	s2,a0
    bp = bread(dev, 1);
    800029b4:	4585                	li	a1,1
    800029b6:	00000097          	auipc	ra,0x0
    800029ba:	a50080e7          	jalr	-1456(ra) # 80002406 <bread>
    800029be:	84aa                	mv	s1,a0
    memmove(sb, bp->data, sizeof(*sb));
    800029c0:	00026997          	auipc	s3,0x26
    800029c4:	6c898993          	addi	s3,s3,1736 # 80029088 <sb>
    800029c8:	02000613          	li	a2,32
    800029cc:	05850593          	addi	a1,a0,88
    800029d0:	854e                	mv	a0,s3
    800029d2:	ffffe097          	auipc	ra,0xffffe
    800029d6:	806080e7          	jalr	-2042(ra) # 800001d8 <memmove>
    brelse(bp);
    800029da:	8526                	mv	a0,s1
    800029dc:	00000097          	auipc	ra,0x0
    800029e0:	b5a080e7          	jalr	-1190(ra) # 80002536 <brelse>
    if (sb.magic != FSMAGIC)
    800029e4:	0009a703          	lw	a4,0(s3)
    800029e8:	102037b7          	lui	a5,0x10203
    800029ec:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800029f0:	02f71263          	bne	a4,a5,80002a14 <fsinit+0x70>
    initlog(dev, &sb);
    800029f4:	00026597          	auipc	a1,0x26
    800029f8:	69458593          	addi	a1,a1,1684 # 80029088 <sb>
    800029fc:	854a                	mv	a0,s2
    800029fe:	00001097          	auipc	ra,0x1
    80002a02:	b40080e7          	jalr	-1216(ra) # 8000353e <initlog>
}
    80002a06:	70a2                	ld	ra,40(sp)
    80002a08:	7402                	ld	s0,32(sp)
    80002a0a:	64e2                	ld	s1,24(sp)
    80002a0c:	6942                	ld	s2,16(sp)
    80002a0e:	69a2                	ld	s3,8(sp)
    80002a10:	6145                	addi	sp,sp,48
    80002a12:	8082                	ret
        panic("invalid file system");
    80002a14:	00006517          	auipc	a0,0x6
    80002a18:	b9450513          	addi	a0,a0,-1132 # 800085a8 <syscalls+0x150>
    80002a1c:	00003097          	auipc	ra,0x3
    80002a20:	666080e7          	jalr	1638(ra) # 80006082 <panic>

0000000080002a24 <iinit>:
{
    80002a24:	7179                	addi	sp,sp,-48
    80002a26:	f406                	sd	ra,40(sp)
    80002a28:	f022                	sd	s0,32(sp)
    80002a2a:	ec26                	sd	s1,24(sp)
    80002a2c:	e84a                	sd	s2,16(sp)
    80002a2e:	e44e                	sd	s3,8(sp)
    80002a30:	1800                	addi	s0,sp,48
    initlock(&itable.lock, "itable");
    80002a32:	00006597          	auipc	a1,0x6
    80002a36:	b8e58593          	addi	a1,a1,-1138 # 800085c0 <syscalls+0x168>
    80002a3a:	00026517          	auipc	a0,0x26
    80002a3e:	66e50513          	addi	a0,a0,1646 # 800290a8 <itable>
    80002a42:	00004097          	auipc	ra,0x4
    80002a46:	afa080e7          	jalr	-1286(ra) # 8000653c <initlock>
    for (i = 0; i < NINODE; i++)
    80002a4a:	00026497          	auipc	s1,0x26
    80002a4e:	68648493          	addi	s1,s1,1670 # 800290d0 <itable+0x28>
    80002a52:	00028997          	auipc	s3,0x28
    80002a56:	10e98993          	addi	s3,s3,270 # 8002ab60 <log+0x10>
        initsleeplock(&itable.inode[i].lock, "inode");
    80002a5a:	00006917          	auipc	s2,0x6
    80002a5e:	b6e90913          	addi	s2,s2,-1170 # 800085c8 <syscalls+0x170>
    80002a62:	85ca                	mv	a1,s2
    80002a64:	8526                	mv	a0,s1
    80002a66:	00001097          	auipc	ra,0x1
    80002a6a:	e3a080e7          	jalr	-454(ra) # 800038a0 <initsleeplock>
    for (i = 0; i < NINODE; i++)
    80002a6e:	08848493          	addi	s1,s1,136
    80002a72:	ff3498e3          	bne	s1,s3,80002a62 <iinit+0x3e>
}
    80002a76:	70a2                	ld	ra,40(sp)
    80002a78:	7402                	ld	s0,32(sp)
    80002a7a:	64e2                	ld	s1,24(sp)
    80002a7c:	6942                	ld	s2,16(sp)
    80002a7e:	69a2                	ld	s3,8(sp)
    80002a80:	6145                	addi	sp,sp,48
    80002a82:	8082                	ret

0000000080002a84 <ialloc>:
{
    80002a84:	715d                	addi	sp,sp,-80
    80002a86:	e486                	sd	ra,72(sp)
    80002a88:	e0a2                	sd	s0,64(sp)
    80002a8a:	fc26                	sd	s1,56(sp)
    80002a8c:	f84a                	sd	s2,48(sp)
    80002a8e:	f44e                	sd	s3,40(sp)
    80002a90:	f052                	sd	s4,32(sp)
    80002a92:	ec56                	sd	s5,24(sp)
    80002a94:	e85a                	sd	s6,16(sp)
    80002a96:	e45e                	sd	s7,8(sp)
    80002a98:	0880                	addi	s0,sp,80
    for (inum = 1; inum < sb.ninodes; inum++)
    80002a9a:	00026717          	auipc	a4,0x26
    80002a9e:	5fa72703          	lw	a4,1530(a4) # 80029094 <sb+0xc>
    80002aa2:	4785                	li	a5,1
    80002aa4:	04e7fa63          	bgeu	a5,a4,80002af8 <ialloc+0x74>
    80002aa8:	8aaa                	mv	s5,a0
    80002aaa:	8bae                	mv	s7,a1
    80002aac:	4485                	li	s1,1
        bp = bread(dev, IBLOCK(inum, sb));
    80002aae:	00026a17          	auipc	s4,0x26
    80002ab2:	5daa0a13          	addi	s4,s4,1498 # 80029088 <sb>
    80002ab6:	00048b1b          	sext.w	s6,s1
    80002aba:	0044d593          	srli	a1,s1,0x4
    80002abe:	018a2783          	lw	a5,24(s4)
    80002ac2:	9dbd                	addw	a1,a1,a5
    80002ac4:	8556                	mv	a0,s5
    80002ac6:	00000097          	auipc	ra,0x0
    80002aca:	940080e7          	jalr	-1728(ra) # 80002406 <bread>
    80002ace:	892a                	mv	s2,a0
        dip = (struct dinode *)bp->data + inum % IPB;
    80002ad0:	05850993          	addi	s3,a0,88
    80002ad4:	00f4f793          	andi	a5,s1,15
    80002ad8:	079a                	slli	a5,a5,0x6
    80002ada:	99be                	add	s3,s3,a5
        if (dip->type == 0)
    80002adc:	00099783          	lh	a5,0(s3)
    80002ae0:	c3a1                	beqz	a5,80002b20 <ialloc+0x9c>
        brelse(bp);
    80002ae2:	00000097          	auipc	ra,0x0
    80002ae6:	a54080e7          	jalr	-1452(ra) # 80002536 <brelse>
    for (inum = 1; inum < sb.ninodes; inum++)
    80002aea:	0485                	addi	s1,s1,1
    80002aec:	00ca2703          	lw	a4,12(s4)
    80002af0:	0004879b          	sext.w	a5,s1
    80002af4:	fce7e1e3          	bltu	a5,a4,80002ab6 <ialloc+0x32>
    printf("ialloc: no inodes\n");
    80002af8:	00006517          	auipc	a0,0x6
    80002afc:	ad850513          	addi	a0,a0,-1320 # 800085d0 <syscalls+0x178>
    80002b00:	00003097          	auipc	ra,0x3
    80002b04:	5cc080e7          	jalr	1484(ra) # 800060cc <printf>
    return 0;
    80002b08:	4501                	li	a0,0
}
    80002b0a:	60a6                	ld	ra,72(sp)
    80002b0c:	6406                	ld	s0,64(sp)
    80002b0e:	74e2                	ld	s1,56(sp)
    80002b10:	7942                	ld	s2,48(sp)
    80002b12:	79a2                	ld	s3,40(sp)
    80002b14:	7a02                	ld	s4,32(sp)
    80002b16:	6ae2                	ld	s5,24(sp)
    80002b18:	6b42                	ld	s6,16(sp)
    80002b1a:	6ba2                	ld	s7,8(sp)
    80002b1c:	6161                	addi	sp,sp,80
    80002b1e:	8082                	ret
            memset(dip, 0, sizeof(*dip));
    80002b20:	04000613          	li	a2,64
    80002b24:	4581                	li	a1,0
    80002b26:	854e                	mv	a0,s3
    80002b28:	ffffd097          	auipc	ra,0xffffd
    80002b2c:	650080e7          	jalr	1616(ra) # 80000178 <memset>
            dip->type = type;
    80002b30:	01799023          	sh	s7,0(s3)
            log_write(bp); // mark it allocated on the disk
    80002b34:	854a                	mv	a0,s2
    80002b36:	00001097          	auipc	ra,0x1
    80002b3a:	c84080e7          	jalr	-892(ra) # 800037ba <log_write>
            brelse(bp);
    80002b3e:	854a                	mv	a0,s2
    80002b40:	00000097          	auipc	ra,0x0
    80002b44:	9f6080e7          	jalr	-1546(ra) # 80002536 <brelse>
            return iget(dev, inum);
    80002b48:	85da                	mv	a1,s6
    80002b4a:	8556                	mv	a0,s5
    80002b4c:	00000097          	auipc	ra,0x0
    80002b50:	d9c080e7          	jalr	-612(ra) # 800028e8 <iget>
    80002b54:	bf5d                	j	80002b0a <ialloc+0x86>

0000000080002b56 <iupdate>:
{
    80002b56:	1101                	addi	sp,sp,-32
    80002b58:	ec06                	sd	ra,24(sp)
    80002b5a:	e822                	sd	s0,16(sp)
    80002b5c:	e426                	sd	s1,8(sp)
    80002b5e:	e04a                	sd	s2,0(sp)
    80002b60:	1000                	addi	s0,sp,32
    80002b62:	84aa                	mv	s1,a0
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002b64:	415c                	lw	a5,4(a0)
    80002b66:	0047d79b          	srliw	a5,a5,0x4
    80002b6a:	00026597          	auipc	a1,0x26
    80002b6e:	5365a583          	lw	a1,1334(a1) # 800290a0 <sb+0x18>
    80002b72:	9dbd                	addw	a1,a1,a5
    80002b74:	4108                	lw	a0,0(a0)
    80002b76:	00000097          	auipc	ra,0x0
    80002b7a:	890080e7          	jalr	-1904(ra) # 80002406 <bread>
    80002b7e:	892a                	mv	s2,a0
    dip = (struct dinode *)bp->data + ip->inum % IPB;
    80002b80:	05850793          	addi	a5,a0,88
    80002b84:	40c8                	lw	a0,4(s1)
    80002b86:	893d                	andi	a0,a0,15
    80002b88:	051a                	slli	a0,a0,0x6
    80002b8a:	953e                	add	a0,a0,a5
    dip->type = ip->type;
    80002b8c:	04449703          	lh	a4,68(s1)
    80002b90:	00e51023          	sh	a4,0(a0)
    dip->major = ip->major;
    80002b94:	04649703          	lh	a4,70(s1)
    80002b98:	00e51123          	sh	a4,2(a0)
    dip->minor = ip->minor;
    80002b9c:	04849703          	lh	a4,72(s1)
    80002ba0:	00e51223          	sh	a4,4(a0)
    dip->nlink = ip->nlink;
    80002ba4:	04a49703          	lh	a4,74(s1)
    80002ba8:	00e51323          	sh	a4,6(a0)
    dip->size = ip->size;
    80002bac:	44f8                	lw	a4,76(s1)
    80002bae:	c518                	sw	a4,8(a0)
    memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002bb0:	03400613          	li	a2,52
    80002bb4:	05048593          	addi	a1,s1,80
    80002bb8:	0531                	addi	a0,a0,12
    80002bba:	ffffd097          	auipc	ra,0xffffd
    80002bbe:	61e080e7          	jalr	1566(ra) # 800001d8 <memmove>
    log_write(bp);
    80002bc2:	854a                	mv	a0,s2
    80002bc4:	00001097          	auipc	ra,0x1
    80002bc8:	bf6080e7          	jalr	-1034(ra) # 800037ba <log_write>
    brelse(bp);
    80002bcc:	854a                	mv	a0,s2
    80002bce:	00000097          	auipc	ra,0x0
    80002bd2:	968080e7          	jalr	-1688(ra) # 80002536 <brelse>
}
    80002bd6:	60e2                	ld	ra,24(sp)
    80002bd8:	6442                	ld	s0,16(sp)
    80002bda:	64a2                	ld	s1,8(sp)
    80002bdc:	6902                	ld	s2,0(sp)
    80002bde:	6105                	addi	sp,sp,32
    80002be0:	8082                	ret

0000000080002be2 <idup>:
{
    80002be2:	1101                	addi	sp,sp,-32
    80002be4:	ec06                	sd	ra,24(sp)
    80002be6:	e822                	sd	s0,16(sp)
    80002be8:	e426                	sd	s1,8(sp)
    80002bea:	1000                	addi	s0,sp,32
    80002bec:	84aa                	mv	s1,a0
    acquire(&itable.lock);
    80002bee:	00026517          	auipc	a0,0x26
    80002bf2:	4ba50513          	addi	a0,a0,1210 # 800290a8 <itable>
    80002bf6:	00004097          	auipc	ra,0x4
    80002bfa:	9d6080e7          	jalr	-1578(ra) # 800065cc <acquire>
    ip->ref++;
    80002bfe:	449c                	lw	a5,8(s1)
    80002c00:	2785                	addiw	a5,a5,1
    80002c02:	c49c                	sw	a5,8(s1)
    release(&itable.lock);
    80002c04:	00026517          	auipc	a0,0x26
    80002c08:	4a450513          	addi	a0,a0,1188 # 800290a8 <itable>
    80002c0c:	00004097          	auipc	ra,0x4
    80002c10:	a74080e7          	jalr	-1420(ra) # 80006680 <release>
}
    80002c14:	8526                	mv	a0,s1
    80002c16:	60e2                	ld	ra,24(sp)
    80002c18:	6442                	ld	s0,16(sp)
    80002c1a:	64a2                	ld	s1,8(sp)
    80002c1c:	6105                	addi	sp,sp,32
    80002c1e:	8082                	ret

0000000080002c20 <ilock>:
{
    80002c20:	1101                	addi	sp,sp,-32
    80002c22:	ec06                	sd	ra,24(sp)
    80002c24:	e822                	sd	s0,16(sp)
    80002c26:	e426                	sd	s1,8(sp)
    80002c28:	e04a                	sd	s2,0(sp)
    80002c2a:	1000                	addi	s0,sp,32
    if (ip == 0 || ip->ref < 1)
    80002c2c:	c115                	beqz	a0,80002c50 <ilock+0x30>
    80002c2e:	84aa                	mv	s1,a0
    80002c30:	451c                	lw	a5,8(a0)
    80002c32:	00f05f63          	blez	a5,80002c50 <ilock+0x30>
    acquiresleep(&ip->lock);
    80002c36:	0541                	addi	a0,a0,16
    80002c38:	00001097          	auipc	ra,0x1
    80002c3c:	ca2080e7          	jalr	-862(ra) # 800038da <acquiresleep>
    if (ip->valid == 0)
    80002c40:	40bc                	lw	a5,64(s1)
    80002c42:	cf99                	beqz	a5,80002c60 <ilock+0x40>
}
    80002c44:	60e2                	ld	ra,24(sp)
    80002c46:	6442                	ld	s0,16(sp)
    80002c48:	64a2                	ld	s1,8(sp)
    80002c4a:	6902                	ld	s2,0(sp)
    80002c4c:	6105                	addi	sp,sp,32
    80002c4e:	8082                	ret
        panic("ilock");
    80002c50:	00006517          	auipc	a0,0x6
    80002c54:	99850513          	addi	a0,a0,-1640 # 800085e8 <syscalls+0x190>
    80002c58:	00003097          	auipc	ra,0x3
    80002c5c:	42a080e7          	jalr	1066(ra) # 80006082 <panic>
        bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002c60:	40dc                	lw	a5,4(s1)
    80002c62:	0047d79b          	srliw	a5,a5,0x4
    80002c66:	00026597          	auipc	a1,0x26
    80002c6a:	43a5a583          	lw	a1,1082(a1) # 800290a0 <sb+0x18>
    80002c6e:	9dbd                	addw	a1,a1,a5
    80002c70:	4088                	lw	a0,0(s1)
    80002c72:	fffff097          	auipc	ra,0xfffff
    80002c76:	794080e7          	jalr	1940(ra) # 80002406 <bread>
    80002c7a:	892a                	mv	s2,a0
        dip = (struct dinode *)bp->data + ip->inum % IPB;
    80002c7c:	05850593          	addi	a1,a0,88
    80002c80:	40dc                	lw	a5,4(s1)
    80002c82:	8bbd                	andi	a5,a5,15
    80002c84:	079a                	slli	a5,a5,0x6
    80002c86:	95be                	add	a1,a1,a5
        ip->type = dip->type;
    80002c88:	00059783          	lh	a5,0(a1)
    80002c8c:	04f49223          	sh	a5,68(s1)
        ip->major = dip->major;
    80002c90:	00259783          	lh	a5,2(a1)
    80002c94:	04f49323          	sh	a5,70(s1)
        ip->minor = dip->minor;
    80002c98:	00459783          	lh	a5,4(a1)
    80002c9c:	04f49423          	sh	a5,72(s1)
        ip->nlink = dip->nlink;
    80002ca0:	00659783          	lh	a5,6(a1)
    80002ca4:	04f49523          	sh	a5,74(s1)
        ip->size = dip->size;
    80002ca8:	459c                	lw	a5,8(a1)
    80002caa:	c4fc                	sw	a5,76(s1)
        memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002cac:	03400613          	li	a2,52
    80002cb0:	05b1                	addi	a1,a1,12
    80002cb2:	05048513          	addi	a0,s1,80
    80002cb6:	ffffd097          	auipc	ra,0xffffd
    80002cba:	522080e7          	jalr	1314(ra) # 800001d8 <memmove>
        brelse(bp);
    80002cbe:	854a                	mv	a0,s2
    80002cc0:	00000097          	auipc	ra,0x0
    80002cc4:	876080e7          	jalr	-1930(ra) # 80002536 <brelse>
        ip->valid = 1;
    80002cc8:	4785                	li	a5,1
    80002cca:	c0bc                	sw	a5,64(s1)
        if (ip->type == 0)
    80002ccc:	04449783          	lh	a5,68(s1)
    80002cd0:	fbb5                	bnez	a5,80002c44 <ilock+0x24>
            panic("ilock: no type");
    80002cd2:	00006517          	auipc	a0,0x6
    80002cd6:	91e50513          	addi	a0,a0,-1762 # 800085f0 <syscalls+0x198>
    80002cda:	00003097          	auipc	ra,0x3
    80002cde:	3a8080e7          	jalr	936(ra) # 80006082 <panic>

0000000080002ce2 <iunlock>:
{
    80002ce2:	1101                	addi	sp,sp,-32
    80002ce4:	ec06                	sd	ra,24(sp)
    80002ce6:	e822                	sd	s0,16(sp)
    80002ce8:	e426                	sd	s1,8(sp)
    80002cea:	e04a                	sd	s2,0(sp)
    80002cec:	1000                	addi	s0,sp,32
    if (ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002cee:	c905                	beqz	a0,80002d1e <iunlock+0x3c>
    80002cf0:	84aa                	mv	s1,a0
    80002cf2:	01050913          	addi	s2,a0,16
    80002cf6:	854a                	mv	a0,s2
    80002cf8:	00001097          	auipc	ra,0x1
    80002cfc:	c7c080e7          	jalr	-900(ra) # 80003974 <holdingsleep>
    80002d00:	cd19                	beqz	a0,80002d1e <iunlock+0x3c>
    80002d02:	449c                	lw	a5,8(s1)
    80002d04:	00f05d63          	blez	a5,80002d1e <iunlock+0x3c>
    releasesleep(&ip->lock);
    80002d08:	854a                	mv	a0,s2
    80002d0a:	00001097          	auipc	ra,0x1
    80002d0e:	c26080e7          	jalr	-986(ra) # 80003930 <releasesleep>
}
    80002d12:	60e2                	ld	ra,24(sp)
    80002d14:	6442                	ld	s0,16(sp)
    80002d16:	64a2                	ld	s1,8(sp)
    80002d18:	6902                	ld	s2,0(sp)
    80002d1a:	6105                	addi	sp,sp,32
    80002d1c:	8082                	ret
        panic("iunlock");
    80002d1e:	00006517          	auipc	a0,0x6
    80002d22:	8e250513          	addi	a0,a0,-1822 # 80008600 <syscalls+0x1a8>
    80002d26:	00003097          	auipc	ra,0x3
    80002d2a:	35c080e7          	jalr	860(ra) # 80006082 <panic>

0000000080002d2e <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void itrunc(struct inode *ip)
{
    80002d2e:	7179                	addi	sp,sp,-48
    80002d30:	f406                	sd	ra,40(sp)
    80002d32:	f022                	sd	s0,32(sp)
    80002d34:	ec26                	sd	s1,24(sp)
    80002d36:	e84a                	sd	s2,16(sp)
    80002d38:	e44e                	sd	s3,8(sp)
    80002d3a:	e052                	sd	s4,0(sp)
    80002d3c:	1800                	addi	s0,sp,48
    80002d3e:	89aa                	mv	s3,a0
    int i, j;
    struct buf *bp;
    uint *a;

    for (i = 0; i < NDIRECT; i++)
    80002d40:	05050493          	addi	s1,a0,80
    80002d44:	08050913          	addi	s2,a0,128
    80002d48:	a021                	j	80002d50 <itrunc+0x22>
    80002d4a:	0491                	addi	s1,s1,4
    80002d4c:	01248d63          	beq	s1,s2,80002d66 <itrunc+0x38>
    {
        if (ip->addrs[i])
    80002d50:	408c                	lw	a1,0(s1)
    80002d52:	dde5                	beqz	a1,80002d4a <itrunc+0x1c>
        {
            bfree(ip->dev, ip->addrs[i]);
    80002d54:	0009a503          	lw	a0,0(s3)
    80002d58:	00000097          	auipc	ra,0x0
    80002d5c:	8f4080e7          	jalr	-1804(ra) # 8000264c <bfree>
            ip->addrs[i] = 0;
    80002d60:	0004a023          	sw	zero,0(s1)
    80002d64:	b7dd                	j	80002d4a <itrunc+0x1c>
        }
    }

    if (ip->addrs[NDIRECT])
    80002d66:	0809a583          	lw	a1,128(s3)
    80002d6a:	e185                	bnez	a1,80002d8a <itrunc+0x5c>
        brelse(bp);
        bfree(ip->dev, ip->addrs[NDIRECT]);
        ip->addrs[NDIRECT] = 0;
    }

    ip->size = 0;
    80002d6c:	0409a623          	sw	zero,76(s3)
    iupdate(ip);
    80002d70:	854e                	mv	a0,s3
    80002d72:	00000097          	auipc	ra,0x0
    80002d76:	de4080e7          	jalr	-540(ra) # 80002b56 <iupdate>
}
    80002d7a:	70a2                	ld	ra,40(sp)
    80002d7c:	7402                	ld	s0,32(sp)
    80002d7e:	64e2                	ld	s1,24(sp)
    80002d80:	6942                	ld	s2,16(sp)
    80002d82:	69a2                	ld	s3,8(sp)
    80002d84:	6a02                	ld	s4,0(sp)
    80002d86:	6145                	addi	sp,sp,48
    80002d88:	8082                	ret
        bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002d8a:	0009a503          	lw	a0,0(s3)
    80002d8e:	fffff097          	auipc	ra,0xfffff
    80002d92:	678080e7          	jalr	1656(ra) # 80002406 <bread>
    80002d96:	8a2a                	mv	s4,a0
        for (j = 0; j < NINDIRECT; j++)
    80002d98:	05850493          	addi	s1,a0,88
    80002d9c:	45850913          	addi	s2,a0,1112
    80002da0:	a811                	j	80002db4 <itrunc+0x86>
                bfree(ip->dev, a[j]);
    80002da2:	0009a503          	lw	a0,0(s3)
    80002da6:	00000097          	auipc	ra,0x0
    80002daa:	8a6080e7          	jalr	-1882(ra) # 8000264c <bfree>
        for (j = 0; j < NINDIRECT; j++)
    80002dae:	0491                	addi	s1,s1,4
    80002db0:	01248563          	beq	s1,s2,80002dba <itrunc+0x8c>
            if (a[j])
    80002db4:	408c                	lw	a1,0(s1)
    80002db6:	dde5                	beqz	a1,80002dae <itrunc+0x80>
    80002db8:	b7ed                	j	80002da2 <itrunc+0x74>
        brelse(bp);
    80002dba:	8552                	mv	a0,s4
    80002dbc:	fffff097          	auipc	ra,0xfffff
    80002dc0:	77a080e7          	jalr	1914(ra) # 80002536 <brelse>
        bfree(ip->dev, ip->addrs[NDIRECT]);
    80002dc4:	0809a583          	lw	a1,128(s3)
    80002dc8:	0009a503          	lw	a0,0(s3)
    80002dcc:	00000097          	auipc	ra,0x0
    80002dd0:	880080e7          	jalr	-1920(ra) # 8000264c <bfree>
        ip->addrs[NDIRECT] = 0;
    80002dd4:	0809a023          	sw	zero,128(s3)
    80002dd8:	bf51                	j	80002d6c <itrunc+0x3e>

0000000080002dda <iput>:
{
    80002dda:	1101                	addi	sp,sp,-32
    80002ddc:	ec06                	sd	ra,24(sp)
    80002dde:	e822                	sd	s0,16(sp)
    80002de0:	e426                	sd	s1,8(sp)
    80002de2:	e04a                	sd	s2,0(sp)
    80002de4:	1000                	addi	s0,sp,32
    80002de6:	84aa                	mv	s1,a0
    acquire(&itable.lock);
    80002de8:	00026517          	auipc	a0,0x26
    80002dec:	2c050513          	addi	a0,a0,704 # 800290a8 <itable>
    80002df0:	00003097          	auipc	ra,0x3
    80002df4:	7dc080e7          	jalr	2012(ra) # 800065cc <acquire>
    if (ip->ref == 1 && ip->valid && ip->nlink == 0)
    80002df8:	4498                	lw	a4,8(s1)
    80002dfa:	4785                	li	a5,1
    80002dfc:	02f70363          	beq	a4,a5,80002e22 <iput+0x48>
    ip->ref--;
    80002e00:	449c                	lw	a5,8(s1)
    80002e02:	37fd                	addiw	a5,a5,-1
    80002e04:	c49c                	sw	a5,8(s1)
    release(&itable.lock);
    80002e06:	00026517          	auipc	a0,0x26
    80002e0a:	2a250513          	addi	a0,a0,674 # 800290a8 <itable>
    80002e0e:	00004097          	auipc	ra,0x4
    80002e12:	872080e7          	jalr	-1934(ra) # 80006680 <release>
}
    80002e16:	60e2                	ld	ra,24(sp)
    80002e18:	6442                	ld	s0,16(sp)
    80002e1a:	64a2                	ld	s1,8(sp)
    80002e1c:	6902                	ld	s2,0(sp)
    80002e1e:	6105                	addi	sp,sp,32
    80002e20:	8082                	ret
    if (ip->ref == 1 && ip->valid && ip->nlink == 0)
    80002e22:	40bc                	lw	a5,64(s1)
    80002e24:	dff1                	beqz	a5,80002e00 <iput+0x26>
    80002e26:	04a49783          	lh	a5,74(s1)
    80002e2a:	fbf9                	bnez	a5,80002e00 <iput+0x26>
        acquiresleep(&ip->lock);
    80002e2c:	01048913          	addi	s2,s1,16
    80002e30:	854a                	mv	a0,s2
    80002e32:	00001097          	auipc	ra,0x1
    80002e36:	aa8080e7          	jalr	-1368(ra) # 800038da <acquiresleep>
        release(&itable.lock);
    80002e3a:	00026517          	auipc	a0,0x26
    80002e3e:	26e50513          	addi	a0,a0,622 # 800290a8 <itable>
    80002e42:	00004097          	auipc	ra,0x4
    80002e46:	83e080e7          	jalr	-1986(ra) # 80006680 <release>
        itrunc(ip);
    80002e4a:	8526                	mv	a0,s1
    80002e4c:	00000097          	auipc	ra,0x0
    80002e50:	ee2080e7          	jalr	-286(ra) # 80002d2e <itrunc>
        ip->type = 0;
    80002e54:	04049223          	sh	zero,68(s1)
        iupdate(ip);
    80002e58:	8526                	mv	a0,s1
    80002e5a:	00000097          	auipc	ra,0x0
    80002e5e:	cfc080e7          	jalr	-772(ra) # 80002b56 <iupdate>
        ip->valid = 0;
    80002e62:	0404a023          	sw	zero,64(s1)
        releasesleep(&ip->lock);
    80002e66:	854a                	mv	a0,s2
    80002e68:	00001097          	auipc	ra,0x1
    80002e6c:	ac8080e7          	jalr	-1336(ra) # 80003930 <releasesleep>
        acquire(&itable.lock);
    80002e70:	00026517          	auipc	a0,0x26
    80002e74:	23850513          	addi	a0,a0,568 # 800290a8 <itable>
    80002e78:	00003097          	auipc	ra,0x3
    80002e7c:	754080e7          	jalr	1876(ra) # 800065cc <acquire>
    80002e80:	b741                	j	80002e00 <iput+0x26>

0000000080002e82 <iunlockput>:
{
    80002e82:	1101                	addi	sp,sp,-32
    80002e84:	ec06                	sd	ra,24(sp)
    80002e86:	e822                	sd	s0,16(sp)
    80002e88:	e426                	sd	s1,8(sp)
    80002e8a:	1000                	addi	s0,sp,32
    80002e8c:	84aa                	mv	s1,a0
    iunlock(ip);
    80002e8e:	00000097          	auipc	ra,0x0
    80002e92:	e54080e7          	jalr	-428(ra) # 80002ce2 <iunlock>
    iput(ip);
    80002e96:	8526                	mv	a0,s1
    80002e98:	00000097          	auipc	ra,0x0
    80002e9c:	f42080e7          	jalr	-190(ra) # 80002dda <iput>
}
    80002ea0:	60e2                	ld	ra,24(sp)
    80002ea2:	6442                	ld	s0,16(sp)
    80002ea4:	64a2                	ld	s1,8(sp)
    80002ea6:	6105                	addi	sp,sp,32
    80002ea8:	8082                	ret

0000000080002eaa <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void stati(struct inode *ip, struct stat *st)
{
    80002eaa:	1141                	addi	sp,sp,-16
    80002eac:	e422                	sd	s0,8(sp)
    80002eae:	0800                	addi	s0,sp,16
    st->dev = ip->dev;
    80002eb0:	411c                	lw	a5,0(a0)
    80002eb2:	c19c                	sw	a5,0(a1)
    st->ino = ip->inum;
    80002eb4:	415c                	lw	a5,4(a0)
    80002eb6:	c1dc                	sw	a5,4(a1)
    st->type = ip->type;
    80002eb8:	04451783          	lh	a5,68(a0)
    80002ebc:	00f59423          	sh	a5,8(a1)
    st->nlink = ip->nlink;
    80002ec0:	04a51783          	lh	a5,74(a0)
    80002ec4:	00f59523          	sh	a5,10(a1)
    st->size = ip->size;
    80002ec8:	04c56783          	lwu	a5,76(a0)
    80002ecc:	e99c                	sd	a5,16(a1)
}
    80002ece:	6422                	ld	s0,8(sp)
    80002ed0:	0141                	addi	sp,sp,16
    80002ed2:	8082                	ret

0000000080002ed4 <readi>:
int readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
    uint tot, m;
    struct buf *bp;

    if (off > ip->size || off + n < off)
    80002ed4:	457c                	lw	a5,76(a0)
    80002ed6:	0ed7e963          	bltu	a5,a3,80002fc8 <readi+0xf4>
{
    80002eda:	7159                	addi	sp,sp,-112
    80002edc:	f486                	sd	ra,104(sp)
    80002ede:	f0a2                	sd	s0,96(sp)
    80002ee0:	eca6                	sd	s1,88(sp)
    80002ee2:	e8ca                	sd	s2,80(sp)
    80002ee4:	e4ce                	sd	s3,72(sp)
    80002ee6:	e0d2                	sd	s4,64(sp)
    80002ee8:	fc56                	sd	s5,56(sp)
    80002eea:	f85a                	sd	s6,48(sp)
    80002eec:	f45e                	sd	s7,40(sp)
    80002eee:	f062                	sd	s8,32(sp)
    80002ef0:	ec66                	sd	s9,24(sp)
    80002ef2:	e86a                	sd	s10,16(sp)
    80002ef4:	e46e                	sd	s11,8(sp)
    80002ef6:	1880                	addi	s0,sp,112
    80002ef8:	8b2a                	mv	s6,a0
    80002efa:	8bae                	mv	s7,a1
    80002efc:	8a32                	mv	s4,a2
    80002efe:	84b6                	mv	s1,a3
    80002f00:	8aba                	mv	s5,a4
    if (off > ip->size || off + n < off)
    80002f02:	9f35                	addw	a4,a4,a3
        return 0;
    80002f04:	4501                	li	a0,0
    if (off > ip->size || off + n < off)
    80002f06:	0ad76063          	bltu	a4,a3,80002fa6 <readi+0xd2>
    if (off + n > ip->size)
    80002f0a:	00e7f463          	bgeu	a5,a4,80002f12 <readi+0x3e>
        n = ip->size - off;
    80002f0e:	40d78abb          	subw	s5,a5,a3

    for (tot = 0; tot < n; tot += m, off += m, dst += m)
    80002f12:	0a0a8963          	beqz	s5,80002fc4 <readi+0xf0>
    80002f16:	4981                	li	s3,0
    {
        uint addr = bmap(ip, off / BSIZE);
        if (addr == 0)
            break;
        bp = bread(ip->dev, addr);
        m = min(n - tot, BSIZE - off % BSIZE);
    80002f18:	40000c93          	li	s9,1024
        if (either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1)
    80002f1c:	5c7d                	li	s8,-1
    80002f1e:	a82d                	j	80002f58 <readi+0x84>
    80002f20:	020d1d93          	slli	s11,s10,0x20
    80002f24:	020ddd93          	srli	s11,s11,0x20
    80002f28:	05890613          	addi	a2,s2,88
    80002f2c:	86ee                	mv	a3,s11
    80002f2e:	963a                	add	a2,a2,a4
    80002f30:	85d2                	mv	a1,s4
    80002f32:	855e                	mv	a0,s7
    80002f34:	fffff097          	auipc	ra,0xfffff
    80002f38:	9da080e7          	jalr	-1574(ra) # 8000190e <either_copyout>
    80002f3c:	05850d63          	beq	a0,s8,80002f96 <readi+0xc2>
        {
            brelse(bp);
            tot = -1;
            break;
        }
        brelse(bp);
    80002f40:	854a                	mv	a0,s2
    80002f42:	fffff097          	auipc	ra,0xfffff
    80002f46:	5f4080e7          	jalr	1524(ra) # 80002536 <brelse>
    for (tot = 0; tot < n; tot += m, off += m, dst += m)
    80002f4a:	013d09bb          	addw	s3,s10,s3
    80002f4e:	009d04bb          	addw	s1,s10,s1
    80002f52:	9a6e                	add	s4,s4,s11
    80002f54:	0559f763          	bgeu	s3,s5,80002fa2 <readi+0xce>
        uint addr = bmap(ip, off / BSIZE);
    80002f58:	00a4d59b          	srliw	a1,s1,0xa
    80002f5c:	855a                	mv	a0,s6
    80002f5e:	00000097          	auipc	ra,0x0
    80002f62:	8a2080e7          	jalr	-1886(ra) # 80002800 <bmap>
    80002f66:	0005059b          	sext.w	a1,a0
        if (addr == 0)
    80002f6a:	cd85                	beqz	a1,80002fa2 <readi+0xce>
        bp = bread(ip->dev, addr);
    80002f6c:	000b2503          	lw	a0,0(s6)
    80002f70:	fffff097          	auipc	ra,0xfffff
    80002f74:	496080e7          	jalr	1174(ra) # 80002406 <bread>
    80002f78:	892a                	mv	s2,a0
        m = min(n - tot, BSIZE - off % BSIZE);
    80002f7a:	3ff4f713          	andi	a4,s1,1023
    80002f7e:	40ec87bb          	subw	a5,s9,a4
    80002f82:	413a86bb          	subw	a3,s5,s3
    80002f86:	8d3e                	mv	s10,a5
    80002f88:	2781                	sext.w	a5,a5
    80002f8a:	0006861b          	sext.w	a2,a3
    80002f8e:	f8f679e3          	bgeu	a2,a5,80002f20 <readi+0x4c>
    80002f92:	8d36                	mv	s10,a3
    80002f94:	b771                	j	80002f20 <readi+0x4c>
            brelse(bp);
    80002f96:	854a                	mv	a0,s2
    80002f98:	fffff097          	auipc	ra,0xfffff
    80002f9c:	59e080e7          	jalr	1438(ra) # 80002536 <brelse>
            tot = -1;
    80002fa0:	59fd                	li	s3,-1
    }
    return tot;
    80002fa2:	0009851b          	sext.w	a0,s3
}
    80002fa6:	70a6                	ld	ra,104(sp)
    80002fa8:	7406                	ld	s0,96(sp)
    80002faa:	64e6                	ld	s1,88(sp)
    80002fac:	6946                	ld	s2,80(sp)
    80002fae:	69a6                	ld	s3,72(sp)
    80002fb0:	6a06                	ld	s4,64(sp)
    80002fb2:	7ae2                	ld	s5,56(sp)
    80002fb4:	7b42                	ld	s6,48(sp)
    80002fb6:	7ba2                	ld	s7,40(sp)
    80002fb8:	7c02                	ld	s8,32(sp)
    80002fba:	6ce2                	ld	s9,24(sp)
    80002fbc:	6d42                	ld	s10,16(sp)
    80002fbe:	6da2                	ld	s11,8(sp)
    80002fc0:	6165                	addi	sp,sp,112
    80002fc2:	8082                	ret
    for (tot = 0; tot < n; tot += m, off += m, dst += m)
    80002fc4:	89d6                	mv	s3,s5
    80002fc6:	bff1                	j	80002fa2 <readi+0xce>
        return 0;
    80002fc8:	4501                	li	a0,0
}
    80002fca:	8082                	ret

0000000080002fcc <writei>:
int writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
    uint tot, m;
    struct buf *bp;

    if (off > ip->size || off + n < off)
    80002fcc:	457c                	lw	a5,76(a0)
    80002fce:	10d7e863          	bltu	a5,a3,800030de <writei+0x112>
{
    80002fd2:	7159                	addi	sp,sp,-112
    80002fd4:	f486                	sd	ra,104(sp)
    80002fd6:	f0a2                	sd	s0,96(sp)
    80002fd8:	eca6                	sd	s1,88(sp)
    80002fda:	e8ca                	sd	s2,80(sp)
    80002fdc:	e4ce                	sd	s3,72(sp)
    80002fde:	e0d2                	sd	s4,64(sp)
    80002fe0:	fc56                	sd	s5,56(sp)
    80002fe2:	f85a                	sd	s6,48(sp)
    80002fe4:	f45e                	sd	s7,40(sp)
    80002fe6:	f062                	sd	s8,32(sp)
    80002fe8:	ec66                	sd	s9,24(sp)
    80002fea:	e86a                	sd	s10,16(sp)
    80002fec:	e46e                	sd	s11,8(sp)
    80002fee:	1880                	addi	s0,sp,112
    80002ff0:	8aaa                	mv	s5,a0
    80002ff2:	8bae                	mv	s7,a1
    80002ff4:	8a32                	mv	s4,a2
    80002ff6:	8936                	mv	s2,a3
    80002ff8:	8b3a                	mv	s6,a4
    if (off > ip->size || off + n < off)
    80002ffa:	00e687bb          	addw	a5,a3,a4
    80002ffe:	0ed7e263          	bltu	a5,a3,800030e2 <writei+0x116>
        return -1;
    if (off + n > MAXFILE * BSIZE)
    80003002:	00043737          	lui	a4,0x43
    80003006:	0ef76063          	bltu	a4,a5,800030e6 <writei+0x11a>
        return -1;

    for (tot = 0; tot < n; tot += m, off += m, src += m)
    8000300a:	0c0b0863          	beqz	s6,800030da <writei+0x10e>
    8000300e:	4981                	li	s3,0
    {
        uint addr = bmap(ip, off / BSIZE);
        if (addr == 0)
            break;
        bp = bread(ip->dev, addr);
        m = min(n - tot, BSIZE - off % BSIZE);
    80003010:	40000c93          	li	s9,1024
        if (either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1)
    80003014:	5c7d                	li	s8,-1
    80003016:	a091                	j	8000305a <writei+0x8e>
    80003018:	020d1d93          	slli	s11,s10,0x20
    8000301c:	020ddd93          	srli	s11,s11,0x20
    80003020:	05848513          	addi	a0,s1,88
    80003024:	86ee                	mv	a3,s11
    80003026:	8652                	mv	a2,s4
    80003028:	85de                	mv	a1,s7
    8000302a:	953a                	add	a0,a0,a4
    8000302c:	fffff097          	auipc	ra,0xfffff
    80003030:	938080e7          	jalr	-1736(ra) # 80001964 <either_copyin>
    80003034:	07850263          	beq	a0,s8,80003098 <writei+0xcc>
        {
            brelse(bp);
            break;
        }
        log_write(bp);
    80003038:	8526                	mv	a0,s1
    8000303a:	00000097          	auipc	ra,0x0
    8000303e:	780080e7          	jalr	1920(ra) # 800037ba <log_write>
        brelse(bp);
    80003042:	8526                	mv	a0,s1
    80003044:	fffff097          	auipc	ra,0xfffff
    80003048:	4f2080e7          	jalr	1266(ra) # 80002536 <brelse>
    for (tot = 0; tot < n; tot += m, off += m, src += m)
    8000304c:	013d09bb          	addw	s3,s10,s3
    80003050:	012d093b          	addw	s2,s10,s2
    80003054:	9a6e                	add	s4,s4,s11
    80003056:	0569f663          	bgeu	s3,s6,800030a2 <writei+0xd6>
        uint addr = bmap(ip, off / BSIZE);
    8000305a:	00a9559b          	srliw	a1,s2,0xa
    8000305e:	8556                	mv	a0,s5
    80003060:	fffff097          	auipc	ra,0xfffff
    80003064:	7a0080e7          	jalr	1952(ra) # 80002800 <bmap>
    80003068:	0005059b          	sext.w	a1,a0
        if (addr == 0)
    8000306c:	c99d                	beqz	a1,800030a2 <writei+0xd6>
        bp = bread(ip->dev, addr);
    8000306e:	000aa503          	lw	a0,0(s5)
    80003072:	fffff097          	auipc	ra,0xfffff
    80003076:	394080e7          	jalr	916(ra) # 80002406 <bread>
    8000307a:	84aa                	mv	s1,a0
        m = min(n - tot, BSIZE - off % BSIZE);
    8000307c:	3ff97713          	andi	a4,s2,1023
    80003080:	40ec87bb          	subw	a5,s9,a4
    80003084:	413b06bb          	subw	a3,s6,s3
    80003088:	8d3e                	mv	s10,a5
    8000308a:	2781                	sext.w	a5,a5
    8000308c:	0006861b          	sext.w	a2,a3
    80003090:	f8f674e3          	bgeu	a2,a5,80003018 <writei+0x4c>
    80003094:	8d36                	mv	s10,a3
    80003096:	b749                	j	80003018 <writei+0x4c>
            brelse(bp);
    80003098:	8526                	mv	a0,s1
    8000309a:	fffff097          	auipc	ra,0xfffff
    8000309e:	49c080e7          	jalr	1180(ra) # 80002536 <brelse>
    }

    if (off > ip->size)
    800030a2:	04caa783          	lw	a5,76(s5)
    800030a6:	0127f463          	bgeu	a5,s2,800030ae <writei+0xe2>
        ip->size = off;
    800030aa:	052aa623          	sw	s2,76(s5)

    // write the i-node back to disk even if the size didn't change
    // because the loop above might have called bmap() and added a new
    // block to ip->addrs[].
    iupdate(ip);
    800030ae:	8556                	mv	a0,s5
    800030b0:	00000097          	auipc	ra,0x0
    800030b4:	aa6080e7          	jalr	-1370(ra) # 80002b56 <iupdate>

    return tot;
    800030b8:	0009851b          	sext.w	a0,s3
}
    800030bc:	70a6                	ld	ra,104(sp)
    800030be:	7406                	ld	s0,96(sp)
    800030c0:	64e6                	ld	s1,88(sp)
    800030c2:	6946                	ld	s2,80(sp)
    800030c4:	69a6                	ld	s3,72(sp)
    800030c6:	6a06                	ld	s4,64(sp)
    800030c8:	7ae2                	ld	s5,56(sp)
    800030ca:	7b42                	ld	s6,48(sp)
    800030cc:	7ba2                	ld	s7,40(sp)
    800030ce:	7c02                	ld	s8,32(sp)
    800030d0:	6ce2                	ld	s9,24(sp)
    800030d2:	6d42                	ld	s10,16(sp)
    800030d4:	6da2                	ld	s11,8(sp)
    800030d6:	6165                	addi	sp,sp,112
    800030d8:	8082                	ret
    for (tot = 0; tot < n; tot += m, off += m, src += m)
    800030da:	89da                	mv	s3,s6
    800030dc:	bfc9                	j	800030ae <writei+0xe2>
        return -1;
    800030de:	557d                	li	a0,-1
}
    800030e0:	8082                	ret
        return -1;
    800030e2:	557d                	li	a0,-1
    800030e4:	bfe1                	j	800030bc <writei+0xf0>
        return -1;
    800030e6:	557d                	li	a0,-1
    800030e8:	bfd1                	j	800030bc <writei+0xf0>

00000000800030ea <namecmp>:

// Directories

int namecmp(const char *s, const char *t)
{
    800030ea:	1141                	addi	sp,sp,-16
    800030ec:	e406                	sd	ra,8(sp)
    800030ee:	e022                	sd	s0,0(sp)
    800030f0:	0800                	addi	s0,sp,16
    return strncmp(s, t, DIRSIZ);
    800030f2:	4639                	li	a2,14
    800030f4:	ffffd097          	auipc	ra,0xffffd
    800030f8:	15c080e7          	jalr	348(ra) # 80000250 <strncmp>
}
    800030fc:	60a2                	ld	ra,8(sp)
    800030fe:	6402                	ld	s0,0(sp)
    80003100:	0141                	addi	sp,sp,16
    80003102:	8082                	ret

0000000080003104 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode *
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003104:	7139                	addi	sp,sp,-64
    80003106:	fc06                	sd	ra,56(sp)
    80003108:	f822                	sd	s0,48(sp)
    8000310a:	f426                	sd	s1,40(sp)
    8000310c:	f04a                	sd	s2,32(sp)
    8000310e:	ec4e                	sd	s3,24(sp)
    80003110:	e852                	sd	s4,16(sp)
    80003112:	0080                	addi	s0,sp,64
    uint off, inum;
    struct dirent de;

    if (dp->type != T_DIR)
    80003114:	04451703          	lh	a4,68(a0)
    80003118:	4785                	li	a5,1
    8000311a:	00f71a63          	bne	a4,a5,8000312e <dirlookup+0x2a>
    8000311e:	892a                	mv	s2,a0
    80003120:	89ae                	mv	s3,a1
    80003122:	8a32                	mv	s4,a2
        panic("dirlookup not DIR");

    for (off = 0; off < dp->size; off += sizeof(de))
    80003124:	457c                	lw	a5,76(a0)
    80003126:	4481                	li	s1,0
            inum = de.inum;
            return iget(dp->dev, inum);
        }
    }

    return 0;
    80003128:	4501                	li	a0,0
    for (off = 0; off < dp->size; off += sizeof(de))
    8000312a:	e79d                	bnez	a5,80003158 <dirlookup+0x54>
    8000312c:	a8a5                	j	800031a4 <dirlookup+0xa0>
        panic("dirlookup not DIR");
    8000312e:	00005517          	auipc	a0,0x5
    80003132:	4da50513          	addi	a0,a0,1242 # 80008608 <syscalls+0x1b0>
    80003136:	00003097          	auipc	ra,0x3
    8000313a:	f4c080e7          	jalr	-180(ra) # 80006082 <panic>
            panic("dirlookup read");
    8000313e:	00005517          	auipc	a0,0x5
    80003142:	4e250513          	addi	a0,a0,1250 # 80008620 <syscalls+0x1c8>
    80003146:	00003097          	auipc	ra,0x3
    8000314a:	f3c080e7          	jalr	-196(ra) # 80006082 <panic>
    for (off = 0; off < dp->size; off += sizeof(de))
    8000314e:	24c1                	addiw	s1,s1,16
    80003150:	04c92783          	lw	a5,76(s2)
    80003154:	04f4f763          	bgeu	s1,a5,800031a2 <dirlookup+0x9e>
        if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003158:	4741                	li	a4,16
    8000315a:	86a6                	mv	a3,s1
    8000315c:	fc040613          	addi	a2,s0,-64
    80003160:	4581                	li	a1,0
    80003162:	854a                	mv	a0,s2
    80003164:	00000097          	auipc	ra,0x0
    80003168:	d70080e7          	jalr	-656(ra) # 80002ed4 <readi>
    8000316c:	47c1                	li	a5,16
    8000316e:	fcf518e3          	bne	a0,a5,8000313e <dirlookup+0x3a>
        if (de.inum == 0)
    80003172:	fc045783          	lhu	a5,-64(s0)
    80003176:	dfe1                	beqz	a5,8000314e <dirlookup+0x4a>
        if (namecmp(name, de.name) == 0)
    80003178:	fc240593          	addi	a1,s0,-62
    8000317c:	854e                	mv	a0,s3
    8000317e:	00000097          	auipc	ra,0x0
    80003182:	f6c080e7          	jalr	-148(ra) # 800030ea <namecmp>
    80003186:	f561                	bnez	a0,8000314e <dirlookup+0x4a>
            if (poff)
    80003188:	000a0463          	beqz	s4,80003190 <dirlookup+0x8c>
                *poff = off;
    8000318c:	009a2023          	sw	s1,0(s4)
            return iget(dp->dev, inum);
    80003190:	fc045583          	lhu	a1,-64(s0)
    80003194:	00092503          	lw	a0,0(s2)
    80003198:	fffff097          	auipc	ra,0xfffff
    8000319c:	750080e7          	jalr	1872(ra) # 800028e8 <iget>
    800031a0:	a011                	j	800031a4 <dirlookup+0xa0>
    return 0;
    800031a2:	4501                	li	a0,0
}
    800031a4:	70e2                	ld	ra,56(sp)
    800031a6:	7442                	ld	s0,48(sp)
    800031a8:	74a2                	ld	s1,40(sp)
    800031aa:	7902                	ld	s2,32(sp)
    800031ac:	69e2                	ld	s3,24(sp)
    800031ae:	6a42                	ld	s4,16(sp)
    800031b0:	6121                	addi	sp,sp,64
    800031b2:	8082                	ret

00000000800031b4 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode *
namex(char *path, int nameiparent, char *name)
{
    800031b4:	711d                	addi	sp,sp,-96
    800031b6:	ec86                	sd	ra,88(sp)
    800031b8:	e8a2                	sd	s0,80(sp)
    800031ba:	e4a6                	sd	s1,72(sp)
    800031bc:	e0ca                	sd	s2,64(sp)
    800031be:	fc4e                	sd	s3,56(sp)
    800031c0:	f852                	sd	s4,48(sp)
    800031c2:	f456                	sd	s5,40(sp)
    800031c4:	f05a                	sd	s6,32(sp)
    800031c6:	ec5e                	sd	s7,24(sp)
    800031c8:	e862                	sd	s8,16(sp)
    800031ca:	e466                	sd	s9,8(sp)
    800031cc:	1080                	addi	s0,sp,96
    800031ce:	84aa                	mv	s1,a0
    800031d0:	8b2e                	mv	s6,a1
    800031d2:	8ab2                	mv	s5,a2
    struct inode *ip, *next;

    if (*path == '/')
    800031d4:	00054703          	lbu	a4,0(a0)
    800031d8:	02f00793          	li	a5,47
    800031dc:	02f70363          	beq	a4,a5,80003202 <namex+0x4e>
        ip = iget(ROOTDEV, ROOTINO);
    else
        ip = idup(myproc()->cwd);
    800031e0:	ffffe097          	auipc	ra,0xffffe
    800031e4:	c82080e7          	jalr	-894(ra) # 80000e62 <myproc>
    800031e8:	15053503          	ld	a0,336(a0)
    800031ec:	00000097          	auipc	ra,0x0
    800031f0:	9f6080e7          	jalr	-1546(ra) # 80002be2 <idup>
    800031f4:	89aa                	mv	s3,a0
    while (*path == '/')
    800031f6:	02f00913          	li	s2,47
    len = path - s;
    800031fa:	4b81                	li	s7,0
    if (len >= DIRSIZ)
    800031fc:	4cb5                	li	s9,13

    while ((path = skipelem(path, name)) != 0)
    {
        ilock(ip);
        if (ip->type != T_DIR)
    800031fe:	4c05                	li	s8,1
    80003200:	a865                	j	800032b8 <namex+0x104>
        ip = iget(ROOTDEV, ROOTINO);
    80003202:	4585                	li	a1,1
    80003204:	4505                	li	a0,1
    80003206:	fffff097          	auipc	ra,0xfffff
    8000320a:	6e2080e7          	jalr	1762(ra) # 800028e8 <iget>
    8000320e:	89aa                	mv	s3,a0
    80003210:	b7dd                	j	800031f6 <namex+0x42>
        {
            iunlockput(ip);
    80003212:	854e                	mv	a0,s3
    80003214:	00000097          	auipc	ra,0x0
    80003218:	c6e080e7          	jalr	-914(ra) # 80002e82 <iunlockput>
            return 0;
    8000321c:	4981                	li	s3,0
    {
        iput(ip);
        return 0;
    }
    return ip;
}
    8000321e:	854e                	mv	a0,s3
    80003220:	60e6                	ld	ra,88(sp)
    80003222:	6446                	ld	s0,80(sp)
    80003224:	64a6                	ld	s1,72(sp)
    80003226:	6906                	ld	s2,64(sp)
    80003228:	79e2                	ld	s3,56(sp)
    8000322a:	7a42                	ld	s4,48(sp)
    8000322c:	7aa2                	ld	s5,40(sp)
    8000322e:	7b02                	ld	s6,32(sp)
    80003230:	6be2                	ld	s7,24(sp)
    80003232:	6c42                	ld	s8,16(sp)
    80003234:	6ca2                	ld	s9,8(sp)
    80003236:	6125                	addi	sp,sp,96
    80003238:	8082                	ret
            iunlock(ip);
    8000323a:	854e                	mv	a0,s3
    8000323c:	00000097          	auipc	ra,0x0
    80003240:	aa6080e7          	jalr	-1370(ra) # 80002ce2 <iunlock>
            return ip;
    80003244:	bfe9                	j	8000321e <namex+0x6a>
            iunlockput(ip);
    80003246:	854e                	mv	a0,s3
    80003248:	00000097          	auipc	ra,0x0
    8000324c:	c3a080e7          	jalr	-966(ra) # 80002e82 <iunlockput>
            return 0;
    80003250:	89d2                	mv	s3,s4
    80003252:	b7f1                	j	8000321e <namex+0x6a>
    len = path - s;
    80003254:	40b48633          	sub	a2,s1,a1
    80003258:	00060a1b          	sext.w	s4,a2
    if (len >= DIRSIZ)
    8000325c:	094cd463          	bge	s9,s4,800032e4 <namex+0x130>
        memmove(name, s, DIRSIZ);
    80003260:	4639                	li	a2,14
    80003262:	8556                	mv	a0,s5
    80003264:	ffffd097          	auipc	ra,0xffffd
    80003268:	f74080e7          	jalr	-140(ra) # 800001d8 <memmove>
    while (*path == '/')
    8000326c:	0004c783          	lbu	a5,0(s1)
    80003270:	01279763          	bne	a5,s2,8000327e <namex+0xca>
        path++;
    80003274:	0485                	addi	s1,s1,1
    while (*path == '/')
    80003276:	0004c783          	lbu	a5,0(s1)
    8000327a:	ff278de3          	beq	a5,s2,80003274 <namex+0xc0>
        ilock(ip);
    8000327e:	854e                	mv	a0,s3
    80003280:	00000097          	auipc	ra,0x0
    80003284:	9a0080e7          	jalr	-1632(ra) # 80002c20 <ilock>
        if (ip->type != T_DIR)
    80003288:	04499783          	lh	a5,68(s3)
    8000328c:	f98793e3          	bne	a5,s8,80003212 <namex+0x5e>
        if (nameiparent && *path == '\0')
    80003290:	000b0563          	beqz	s6,8000329a <namex+0xe6>
    80003294:	0004c783          	lbu	a5,0(s1)
    80003298:	d3cd                	beqz	a5,8000323a <namex+0x86>
        if ((next = dirlookup(ip, name, 0)) == 0)
    8000329a:	865e                	mv	a2,s7
    8000329c:	85d6                	mv	a1,s5
    8000329e:	854e                	mv	a0,s3
    800032a0:	00000097          	auipc	ra,0x0
    800032a4:	e64080e7          	jalr	-412(ra) # 80003104 <dirlookup>
    800032a8:	8a2a                	mv	s4,a0
    800032aa:	dd51                	beqz	a0,80003246 <namex+0x92>
        iunlockput(ip);
    800032ac:	854e                	mv	a0,s3
    800032ae:	00000097          	auipc	ra,0x0
    800032b2:	bd4080e7          	jalr	-1068(ra) # 80002e82 <iunlockput>
        ip = next;
    800032b6:	89d2                	mv	s3,s4
    while (*path == '/')
    800032b8:	0004c783          	lbu	a5,0(s1)
    800032bc:	05279763          	bne	a5,s2,8000330a <namex+0x156>
        path++;
    800032c0:	0485                	addi	s1,s1,1
    while (*path == '/')
    800032c2:	0004c783          	lbu	a5,0(s1)
    800032c6:	ff278de3          	beq	a5,s2,800032c0 <namex+0x10c>
    if (*path == 0)
    800032ca:	c79d                	beqz	a5,800032f8 <namex+0x144>
        path++;
    800032cc:	85a6                	mv	a1,s1
    len = path - s;
    800032ce:	8a5e                	mv	s4,s7
    800032d0:	865e                	mv	a2,s7
    while (*path != '/' && *path != 0)
    800032d2:	01278963          	beq	a5,s2,800032e4 <namex+0x130>
    800032d6:	dfbd                	beqz	a5,80003254 <namex+0xa0>
        path++;
    800032d8:	0485                	addi	s1,s1,1
    while (*path != '/' && *path != 0)
    800032da:	0004c783          	lbu	a5,0(s1)
    800032de:	ff279ce3          	bne	a5,s2,800032d6 <namex+0x122>
    800032e2:	bf8d                	j	80003254 <namex+0xa0>
        memmove(name, s, len);
    800032e4:	2601                	sext.w	a2,a2
    800032e6:	8556                	mv	a0,s5
    800032e8:	ffffd097          	auipc	ra,0xffffd
    800032ec:	ef0080e7          	jalr	-272(ra) # 800001d8 <memmove>
        name[len] = 0;
    800032f0:	9a56                	add	s4,s4,s5
    800032f2:	000a0023          	sb	zero,0(s4)
    800032f6:	bf9d                	j	8000326c <namex+0xb8>
    if (nameiparent)
    800032f8:	f20b03e3          	beqz	s6,8000321e <namex+0x6a>
        iput(ip);
    800032fc:	854e                	mv	a0,s3
    800032fe:	00000097          	auipc	ra,0x0
    80003302:	adc080e7          	jalr	-1316(ra) # 80002dda <iput>
        return 0;
    80003306:	4981                	li	s3,0
    80003308:	bf19                	j	8000321e <namex+0x6a>
    if (*path == 0)
    8000330a:	d7fd                	beqz	a5,800032f8 <namex+0x144>
    while (*path != '/' && *path != 0)
    8000330c:	0004c783          	lbu	a5,0(s1)
    80003310:	85a6                	mv	a1,s1
    80003312:	b7d1                	j	800032d6 <namex+0x122>

0000000080003314 <dirlink>:
{
    80003314:	7139                	addi	sp,sp,-64
    80003316:	fc06                	sd	ra,56(sp)
    80003318:	f822                	sd	s0,48(sp)
    8000331a:	f426                	sd	s1,40(sp)
    8000331c:	f04a                	sd	s2,32(sp)
    8000331e:	ec4e                	sd	s3,24(sp)
    80003320:	e852                	sd	s4,16(sp)
    80003322:	0080                	addi	s0,sp,64
    80003324:	892a                	mv	s2,a0
    80003326:	8a2e                	mv	s4,a1
    80003328:	89b2                	mv	s3,a2
    if ((ip = dirlookup(dp, name, 0)) != 0)
    8000332a:	4601                	li	a2,0
    8000332c:	00000097          	auipc	ra,0x0
    80003330:	dd8080e7          	jalr	-552(ra) # 80003104 <dirlookup>
    80003334:	e93d                	bnez	a0,800033aa <dirlink+0x96>
    for (off = 0; off < dp->size; off += sizeof(de))
    80003336:	04c92483          	lw	s1,76(s2)
    8000333a:	c49d                	beqz	s1,80003368 <dirlink+0x54>
    8000333c:	4481                	li	s1,0
        if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000333e:	4741                	li	a4,16
    80003340:	86a6                	mv	a3,s1
    80003342:	fc040613          	addi	a2,s0,-64
    80003346:	4581                	li	a1,0
    80003348:	854a                	mv	a0,s2
    8000334a:	00000097          	auipc	ra,0x0
    8000334e:	b8a080e7          	jalr	-1142(ra) # 80002ed4 <readi>
    80003352:	47c1                	li	a5,16
    80003354:	06f51163          	bne	a0,a5,800033b6 <dirlink+0xa2>
        if (de.inum == 0)
    80003358:	fc045783          	lhu	a5,-64(s0)
    8000335c:	c791                	beqz	a5,80003368 <dirlink+0x54>
    for (off = 0; off < dp->size; off += sizeof(de))
    8000335e:	24c1                	addiw	s1,s1,16
    80003360:	04c92783          	lw	a5,76(s2)
    80003364:	fcf4ede3          	bltu	s1,a5,8000333e <dirlink+0x2a>
    strncpy(de.name, name, DIRSIZ);
    80003368:	4639                	li	a2,14
    8000336a:	85d2                	mv	a1,s4
    8000336c:	fc240513          	addi	a0,s0,-62
    80003370:	ffffd097          	auipc	ra,0xffffd
    80003374:	f1c080e7          	jalr	-228(ra) # 8000028c <strncpy>
    de.inum = inum;
    80003378:	fd341023          	sh	s3,-64(s0)
    if (writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000337c:	4741                	li	a4,16
    8000337e:	86a6                	mv	a3,s1
    80003380:	fc040613          	addi	a2,s0,-64
    80003384:	4581                	li	a1,0
    80003386:	854a                	mv	a0,s2
    80003388:	00000097          	auipc	ra,0x0
    8000338c:	c44080e7          	jalr	-956(ra) # 80002fcc <writei>
    80003390:	1541                	addi	a0,a0,-16
    80003392:	00a03533          	snez	a0,a0
    80003396:	40a00533          	neg	a0,a0
}
    8000339a:	70e2                	ld	ra,56(sp)
    8000339c:	7442                	ld	s0,48(sp)
    8000339e:	74a2                	ld	s1,40(sp)
    800033a0:	7902                	ld	s2,32(sp)
    800033a2:	69e2                	ld	s3,24(sp)
    800033a4:	6a42                	ld	s4,16(sp)
    800033a6:	6121                	addi	sp,sp,64
    800033a8:	8082                	ret
        iput(ip);
    800033aa:	00000097          	auipc	ra,0x0
    800033ae:	a30080e7          	jalr	-1488(ra) # 80002dda <iput>
        return -1;
    800033b2:	557d                	li	a0,-1
    800033b4:	b7dd                	j	8000339a <dirlink+0x86>
            panic("dirlink read");
    800033b6:	00005517          	auipc	a0,0x5
    800033ba:	27a50513          	addi	a0,a0,634 # 80008630 <syscalls+0x1d8>
    800033be:	00003097          	auipc	ra,0x3
    800033c2:	cc4080e7          	jalr	-828(ra) # 80006082 <panic>

00000000800033c6 <namei>:

struct inode *
namei(char *path)
{
    800033c6:	1101                	addi	sp,sp,-32
    800033c8:	ec06                	sd	ra,24(sp)
    800033ca:	e822                	sd	s0,16(sp)
    800033cc:	1000                	addi	s0,sp,32
    char name[DIRSIZ];
    return namex(path, 0, name);
    800033ce:	fe040613          	addi	a2,s0,-32
    800033d2:	4581                	li	a1,0
    800033d4:	00000097          	auipc	ra,0x0
    800033d8:	de0080e7          	jalr	-544(ra) # 800031b4 <namex>
}
    800033dc:	60e2                	ld	ra,24(sp)
    800033de:	6442                	ld	s0,16(sp)
    800033e0:	6105                	addi	sp,sp,32
    800033e2:	8082                	ret

00000000800033e4 <nameiparent>:

struct inode *
nameiparent(char *path, char *name)
{
    800033e4:	1141                	addi	sp,sp,-16
    800033e6:	e406                	sd	ra,8(sp)
    800033e8:	e022                	sd	s0,0(sp)
    800033ea:	0800                	addi	s0,sp,16
    800033ec:	862e                	mv	a2,a1
    return namex(path, 1, name);
    800033ee:	4585                	li	a1,1
    800033f0:	00000097          	auipc	ra,0x0
    800033f4:	dc4080e7          	jalr	-572(ra) # 800031b4 <namex>
}
    800033f8:	60a2                	ld	ra,8(sp)
    800033fa:	6402                	ld	s0,0(sp)
    800033fc:	0141                	addi	sp,sp,16
    800033fe:	8082                	ret

0000000080003400 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003400:	1101                	addi	sp,sp,-32
    80003402:	ec06                	sd	ra,24(sp)
    80003404:	e822                	sd	s0,16(sp)
    80003406:	e426                	sd	s1,8(sp)
    80003408:	e04a                	sd	s2,0(sp)
    8000340a:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    8000340c:	00027917          	auipc	s2,0x27
    80003410:	74490913          	addi	s2,s2,1860 # 8002ab50 <log>
    80003414:	01892583          	lw	a1,24(s2)
    80003418:	02892503          	lw	a0,40(s2)
    8000341c:	fffff097          	auipc	ra,0xfffff
    80003420:	fea080e7          	jalr	-22(ra) # 80002406 <bread>
    80003424:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003426:	02c92683          	lw	a3,44(s2)
    8000342a:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    8000342c:	02d05763          	blez	a3,8000345a <write_head+0x5a>
    80003430:	00027797          	auipc	a5,0x27
    80003434:	75078793          	addi	a5,a5,1872 # 8002ab80 <log+0x30>
    80003438:	05c50713          	addi	a4,a0,92
    8000343c:	36fd                	addiw	a3,a3,-1
    8000343e:	1682                	slli	a3,a3,0x20
    80003440:	9281                	srli	a3,a3,0x20
    80003442:	068a                	slli	a3,a3,0x2
    80003444:	00027617          	auipc	a2,0x27
    80003448:	74060613          	addi	a2,a2,1856 # 8002ab84 <log+0x34>
    8000344c:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    8000344e:	4390                	lw	a2,0(a5)
    80003450:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003452:	0791                	addi	a5,a5,4
    80003454:	0711                	addi	a4,a4,4
    80003456:	fed79ce3          	bne	a5,a3,8000344e <write_head+0x4e>
  }
  bwrite(buf);
    8000345a:	8526                	mv	a0,s1
    8000345c:	fffff097          	auipc	ra,0xfffff
    80003460:	09c080e7          	jalr	156(ra) # 800024f8 <bwrite>
  brelse(buf);
    80003464:	8526                	mv	a0,s1
    80003466:	fffff097          	auipc	ra,0xfffff
    8000346a:	0d0080e7          	jalr	208(ra) # 80002536 <brelse>
}
    8000346e:	60e2                	ld	ra,24(sp)
    80003470:	6442                	ld	s0,16(sp)
    80003472:	64a2                	ld	s1,8(sp)
    80003474:	6902                	ld	s2,0(sp)
    80003476:	6105                	addi	sp,sp,32
    80003478:	8082                	ret

000000008000347a <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    8000347a:	00027797          	auipc	a5,0x27
    8000347e:	7027a783          	lw	a5,1794(a5) # 8002ab7c <log+0x2c>
    80003482:	0af05d63          	blez	a5,8000353c <install_trans+0xc2>
{
    80003486:	7139                	addi	sp,sp,-64
    80003488:	fc06                	sd	ra,56(sp)
    8000348a:	f822                	sd	s0,48(sp)
    8000348c:	f426                	sd	s1,40(sp)
    8000348e:	f04a                	sd	s2,32(sp)
    80003490:	ec4e                	sd	s3,24(sp)
    80003492:	e852                	sd	s4,16(sp)
    80003494:	e456                	sd	s5,8(sp)
    80003496:	e05a                	sd	s6,0(sp)
    80003498:	0080                	addi	s0,sp,64
    8000349a:	8b2a                	mv	s6,a0
    8000349c:	00027a97          	auipc	s5,0x27
    800034a0:	6e4a8a93          	addi	s5,s5,1764 # 8002ab80 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800034a4:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800034a6:	00027997          	auipc	s3,0x27
    800034aa:	6aa98993          	addi	s3,s3,1706 # 8002ab50 <log>
    800034ae:	a035                	j	800034da <install_trans+0x60>
      bunpin(dbuf);
    800034b0:	8526                	mv	a0,s1
    800034b2:	fffff097          	auipc	ra,0xfffff
    800034b6:	15e080e7          	jalr	350(ra) # 80002610 <bunpin>
    brelse(lbuf);
    800034ba:	854a                	mv	a0,s2
    800034bc:	fffff097          	auipc	ra,0xfffff
    800034c0:	07a080e7          	jalr	122(ra) # 80002536 <brelse>
    brelse(dbuf);
    800034c4:	8526                	mv	a0,s1
    800034c6:	fffff097          	auipc	ra,0xfffff
    800034ca:	070080e7          	jalr	112(ra) # 80002536 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800034ce:	2a05                	addiw	s4,s4,1
    800034d0:	0a91                	addi	s5,s5,4
    800034d2:	02c9a783          	lw	a5,44(s3)
    800034d6:	04fa5963          	bge	s4,a5,80003528 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800034da:	0189a583          	lw	a1,24(s3)
    800034de:	014585bb          	addw	a1,a1,s4
    800034e2:	2585                	addiw	a1,a1,1
    800034e4:	0289a503          	lw	a0,40(s3)
    800034e8:	fffff097          	auipc	ra,0xfffff
    800034ec:	f1e080e7          	jalr	-226(ra) # 80002406 <bread>
    800034f0:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800034f2:	000aa583          	lw	a1,0(s5)
    800034f6:	0289a503          	lw	a0,40(s3)
    800034fa:	fffff097          	auipc	ra,0xfffff
    800034fe:	f0c080e7          	jalr	-244(ra) # 80002406 <bread>
    80003502:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003504:	40000613          	li	a2,1024
    80003508:	05890593          	addi	a1,s2,88
    8000350c:	05850513          	addi	a0,a0,88
    80003510:	ffffd097          	auipc	ra,0xffffd
    80003514:	cc8080e7          	jalr	-824(ra) # 800001d8 <memmove>
    bwrite(dbuf);  // write dst to disk
    80003518:	8526                	mv	a0,s1
    8000351a:	fffff097          	auipc	ra,0xfffff
    8000351e:	fde080e7          	jalr	-34(ra) # 800024f8 <bwrite>
    if(recovering == 0)
    80003522:	f80b1ce3          	bnez	s6,800034ba <install_trans+0x40>
    80003526:	b769                	j	800034b0 <install_trans+0x36>
}
    80003528:	70e2                	ld	ra,56(sp)
    8000352a:	7442                	ld	s0,48(sp)
    8000352c:	74a2                	ld	s1,40(sp)
    8000352e:	7902                	ld	s2,32(sp)
    80003530:	69e2                	ld	s3,24(sp)
    80003532:	6a42                	ld	s4,16(sp)
    80003534:	6aa2                	ld	s5,8(sp)
    80003536:	6b02                	ld	s6,0(sp)
    80003538:	6121                	addi	sp,sp,64
    8000353a:	8082                	ret
    8000353c:	8082                	ret

000000008000353e <initlog>:
{
    8000353e:	7179                	addi	sp,sp,-48
    80003540:	f406                	sd	ra,40(sp)
    80003542:	f022                	sd	s0,32(sp)
    80003544:	ec26                	sd	s1,24(sp)
    80003546:	e84a                	sd	s2,16(sp)
    80003548:	e44e                	sd	s3,8(sp)
    8000354a:	1800                	addi	s0,sp,48
    8000354c:	892a                	mv	s2,a0
    8000354e:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003550:	00027497          	auipc	s1,0x27
    80003554:	60048493          	addi	s1,s1,1536 # 8002ab50 <log>
    80003558:	00005597          	auipc	a1,0x5
    8000355c:	0e858593          	addi	a1,a1,232 # 80008640 <syscalls+0x1e8>
    80003560:	8526                	mv	a0,s1
    80003562:	00003097          	auipc	ra,0x3
    80003566:	fda080e7          	jalr	-38(ra) # 8000653c <initlock>
  log.start = sb->logstart;
    8000356a:	0149a583          	lw	a1,20(s3)
    8000356e:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003570:	0109a783          	lw	a5,16(s3)
    80003574:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003576:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    8000357a:	854a                	mv	a0,s2
    8000357c:	fffff097          	auipc	ra,0xfffff
    80003580:	e8a080e7          	jalr	-374(ra) # 80002406 <bread>
  log.lh.n = lh->n;
    80003584:	4d3c                	lw	a5,88(a0)
    80003586:	d4dc                	sw	a5,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003588:	02f05563          	blez	a5,800035b2 <initlog+0x74>
    8000358c:	05c50713          	addi	a4,a0,92
    80003590:	00027697          	auipc	a3,0x27
    80003594:	5f068693          	addi	a3,a3,1520 # 8002ab80 <log+0x30>
    80003598:	37fd                	addiw	a5,a5,-1
    8000359a:	1782                	slli	a5,a5,0x20
    8000359c:	9381                	srli	a5,a5,0x20
    8000359e:	078a                	slli	a5,a5,0x2
    800035a0:	06050613          	addi	a2,a0,96
    800035a4:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    800035a6:	4310                	lw	a2,0(a4)
    800035a8:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    800035aa:	0711                	addi	a4,a4,4
    800035ac:	0691                	addi	a3,a3,4
    800035ae:	fef71ce3          	bne	a4,a5,800035a6 <initlog+0x68>
  brelse(buf);
    800035b2:	fffff097          	auipc	ra,0xfffff
    800035b6:	f84080e7          	jalr	-124(ra) # 80002536 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800035ba:	4505                	li	a0,1
    800035bc:	00000097          	auipc	ra,0x0
    800035c0:	ebe080e7          	jalr	-322(ra) # 8000347a <install_trans>
  log.lh.n = 0;
    800035c4:	00027797          	auipc	a5,0x27
    800035c8:	5a07ac23          	sw	zero,1464(a5) # 8002ab7c <log+0x2c>
  write_head(); // clear the log
    800035cc:	00000097          	auipc	ra,0x0
    800035d0:	e34080e7          	jalr	-460(ra) # 80003400 <write_head>
}
    800035d4:	70a2                	ld	ra,40(sp)
    800035d6:	7402                	ld	s0,32(sp)
    800035d8:	64e2                	ld	s1,24(sp)
    800035da:	6942                	ld	s2,16(sp)
    800035dc:	69a2                	ld	s3,8(sp)
    800035de:	6145                	addi	sp,sp,48
    800035e0:	8082                	ret

00000000800035e2 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800035e2:	1101                	addi	sp,sp,-32
    800035e4:	ec06                	sd	ra,24(sp)
    800035e6:	e822                	sd	s0,16(sp)
    800035e8:	e426                	sd	s1,8(sp)
    800035ea:	e04a                	sd	s2,0(sp)
    800035ec:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800035ee:	00027517          	auipc	a0,0x27
    800035f2:	56250513          	addi	a0,a0,1378 # 8002ab50 <log>
    800035f6:	00003097          	auipc	ra,0x3
    800035fa:	fd6080e7          	jalr	-42(ra) # 800065cc <acquire>
  while(1){
    if(log.committing){
    800035fe:	00027497          	auipc	s1,0x27
    80003602:	55248493          	addi	s1,s1,1362 # 8002ab50 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003606:	4979                	li	s2,30
    80003608:	a039                	j	80003616 <begin_op+0x34>
      sleep(&log, &log.lock);
    8000360a:	85a6                	mv	a1,s1
    8000360c:	8526                	mv	a0,s1
    8000360e:	ffffe097          	auipc	ra,0xffffe
    80003612:	ef8080e7          	jalr	-264(ra) # 80001506 <sleep>
    if(log.committing){
    80003616:	50dc                	lw	a5,36(s1)
    80003618:	fbed                	bnez	a5,8000360a <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000361a:	509c                	lw	a5,32(s1)
    8000361c:	0017871b          	addiw	a4,a5,1
    80003620:	0007069b          	sext.w	a3,a4
    80003624:	0027179b          	slliw	a5,a4,0x2
    80003628:	9fb9                	addw	a5,a5,a4
    8000362a:	0017979b          	slliw	a5,a5,0x1
    8000362e:	54d8                	lw	a4,44(s1)
    80003630:	9fb9                	addw	a5,a5,a4
    80003632:	00f95963          	bge	s2,a5,80003644 <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003636:	85a6                	mv	a1,s1
    80003638:	8526                	mv	a0,s1
    8000363a:	ffffe097          	auipc	ra,0xffffe
    8000363e:	ecc080e7          	jalr	-308(ra) # 80001506 <sleep>
    80003642:	bfd1                	j	80003616 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80003644:	00027517          	auipc	a0,0x27
    80003648:	50c50513          	addi	a0,a0,1292 # 8002ab50 <log>
    8000364c:	d114                	sw	a3,32(a0)
      release(&log.lock);
    8000364e:	00003097          	auipc	ra,0x3
    80003652:	032080e7          	jalr	50(ra) # 80006680 <release>
      break;
    }
  }
}
    80003656:	60e2                	ld	ra,24(sp)
    80003658:	6442                	ld	s0,16(sp)
    8000365a:	64a2                	ld	s1,8(sp)
    8000365c:	6902                	ld	s2,0(sp)
    8000365e:	6105                	addi	sp,sp,32
    80003660:	8082                	ret

0000000080003662 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003662:	7139                	addi	sp,sp,-64
    80003664:	fc06                	sd	ra,56(sp)
    80003666:	f822                	sd	s0,48(sp)
    80003668:	f426                	sd	s1,40(sp)
    8000366a:	f04a                	sd	s2,32(sp)
    8000366c:	ec4e                	sd	s3,24(sp)
    8000366e:	e852                	sd	s4,16(sp)
    80003670:	e456                	sd	s5,8(sp)
    80003672:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003674:	00027497          	auipc	s1,0x27
    80003678:	4dc48493          	addi	s1,s1,1244 # 8002ab50 <log>
    8000367c:	8526                	mv	a0,s1
    8000367e:	00003097          	auipc	ra,0x3
    80003682:	f4e080e7          	jalr	-178(ra) # 800065cc <acquire>
  log.outstanding -= 1;
    80003686:	509c                	lw	a5,32(s1)
    80003688:	37fd                	addiw	a5,a5,-1
    8000368a:	0007891b          	sext.w	s2,a5
    8000368e:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003690:	50dc                	lw	a5,36(s1)
    80003692:	efb9                	bnez	a5,800036f0 <end_op+0x8e>
    panic("log.committing");
  if(log.outstanding == 0){
    80003694:	06091663          	bnez	s2,80003700 <end_op+0x9e>
    do_commit = 1;
    log.committing = 1;
    80003698:	00027497          	auipc	s1,0x27
    8000369c:	4b848493          	addi	s1,s1,1208 # 8002ab50 <log>
    800036a0:	4785                	li	a5,1
    800036a2:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800036a4:	8526                	mv	a0,s1
    800036a6:	00003097          	auipc	ra,0x3
    800036aa:	fda080e7          	jalr	-38(ra) # 80006680 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800036ae:	54dc                	lw	a5,44(s1)
    800036b0:	06f04763          	bgtz	a5,8000371e <end_op+0xbc>
    acquire(&log.lock);
    800036b4:	00027497          	auipc	s1,0x27
    800036b8:	49c48493          	addi	s1,s1,1180 # 8002ab50 <log>
    800036bc:	8526                	mv	a0,s1
    800036be:	00003097          	auipc	ra,0x3
    800036c2:	f0e080e7          	jalr	-242(ra) # 800065cc <acquire>
    log.committing = 0;
    800036c6:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800036ca:	8526                	mv	a0,s1
    800036cc:	ffffe097          	auipc	ra,0xffffe
    800036d0:	e9e080e7          	jalr	-354(ra) # 8000156a <wakeup>
    release(&log.lock);
    800036d4:	8526                	mv	a0,s1
    800036d6:	00003097          	auipc	ra,0x3
    800036da:	faa080e7          	jalr	-86(ra) # 80006680 <release>
}
    800036de:	70e2                	ld	ra,56(sp)
    800036e0:	7442                	ld	s0,48(sp)
    800036e2:	74a2                	ld	s1,40(sp)
    800036e4:	7902                	ld	s2,32(sp)
    800036e6:	69e2                	ld	s3,24(sp)
    800036e8:	6a42                	ld	s4,16(sp)
    800036ea:	6aa2                	ld	s5,8(sp)
    800036ec:	6121                	addi	sp,sp,64
    800036ee:	8082                	ret
    panic("log.committing");
    800036f0:	00005517          	auipc	a0,0x5
    800036f4:	f5850513          	addi	a0,a0,-168 # 80008648 <syscalls+0x1f0>
    800036f8:	00003097          	auipc	ra,0x3
    800036fc:	98a080e7          	jalr	-1654(ra) # 80006082 <panic>
    wakeup(&log);
    80003700:	00027497          	auipc	s1,0x27
    80003704:	45048493          	addi	s1,s1,1104 # 8002ab50 <log>
    80003708:	8526                	mv	a0,s1
    8000370a:	ffffe097          	auipc	ra,0xffffe
    8000370e:	e60080e7          	jalr	-416(ra) # 8000156a <wakeup>
  release(&log.lock);
    80003712:	8526                	mv	a0,s1
    80003714:	00003097          	auipc	ra,0x3
    80003718:	f6c080e7          	jalr	-148(ra) # 80006680 <release>
  if(do_commit){
    8000371c:	b7c9                	j	800036de <end_op+0x7c>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000371e:	00027a97          	auipc	s5,0x27
    80003722:	462a8a93          	addi	s5,s5,1122 # 8002ab80 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003726:	00027a17          	auipc	s4,0x27
    8000372a:	42aa0a13          	addi	s4,s4,1066 # 8002ab50 <log>
    8000372e:	018a2583          	lw	a1,24(s4)
    80003732:	012585bb          	addw	a1,a1,s2
    80003736:	2585                	addiw	a1,a1,1
    80003738:	028a2503          	lw	a0,40(s4)
    8000373c:	fffff097          	auipc	ra,0xfffff
    80003740:	cca080e7          	jalr	-822(ra) # 80002406 <bread>
    80003744:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003746:	000aa583          	lw	a1,0(s5)
    8000374a:	028a2503          	lw	a0,40(s4)
    8000374e:	fffff097          	auipc	ra,0xfffff
    80003752:	cb8080e7          	jalr	-840(ra) # 80002406 <bread>
    80003756:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003758:	40000613          	li	a2,1024
    8000375c:	05850593          	addi	a1,a0,88
    80003760:	05848513          	addi	a0,s1,88
    80003764:	ffffd097          	auipc	ra,0xffffd
    80003768:	a74080e7          	jalr	-1420(ra) # 800001d8 <memmove>
    bwrite(to);  // write the log
    8000376c:	8526                	mv	a0,s1
    8000376e:	fffff097          	auipc	ra,0xfffff
    80003772:	d8a080e7          	jalr	-630(ra) # 800024f8 <bwrite>
    brelse(from);
    80003776:	854e                	mv	a0,s3
    80003778:	fffff097          	auipc	ra,0xfffff
    8000377c:	dbe080e7          	jalr	-578(ra) # 80002536 <brelse>
    brelse(to);
    80003780:	8526                	mv	a0,s1
    80003782:	fffff097          	auipc	ra,0xfffff
    80003786:	db4080e7          	jalr	-588(ra) # 80002536 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000378a:	2905                	addiw	s2,s2,1
    8000378c:	0a91                	addi	s5,s5,4
    8000378e:	02ca2783          	lw	a5,44(s4)
    80003792:	f8f94ee3          	blt	s2,a5,8000372e <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003796:	00000097          	auipc	ra,0x0
    8000379a:	c6a080e7          	jalr	-918(ra) # 80003400 <write_head>
    install_trans(0); // Now install writes to home locations
    8000379e:	4501                	li	a0,0
    800037a0:	00000097          	auipc	ra,0x0
    800037a4:	cda080e7          	jalr	-806(ra) # 8000347a <install_trans>
    log.lh.n = 0;
    800037a8:	00027797          	auipc	a5,0x27
    800037ac:	3c07aa23          	sw	zero,980(a5) # 8002ab7c <log+0x2c>
    write_head();    // Erase the transaction from the log
    800037b0:	00000097          	auipc	ra,0x0
    800037b4:	c50080e7          	jalr	-944(ra) # 80003400 <write_head>
    800037b8:	bdf5                	j	800036b4 <end_op+0x52>

00000000800037ba <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800037ba:	1101                	addi	sp,sp,-32
    800037bc:	ec06                	sd	ra,24(sp)
    800037be:	e822                	sd	s0,16(sp)
    800037c0:	e426                	sd	s1,8(sp)
    800037c2:	e04a                	sd	s2,0(sp)
    800037c4:	1000                	addi	s0,sp,32
    800037c6:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800037c8:	00027917          	auipc	s2,0x27
    800037cc:	38890913          	addi	s2,s2,904 # 8002ab50 <log>
    800037d0:	854a                	mv	a0,s2
    800037d2:	00003097          	auipc	ra,0x3
    800037d6:	dfa080e7          	jalr	-518(ra) # 800065cc <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800037da:	02c92603          	lw	a2,44(s2)
    800037de:	47f5                	li	a5,29
    800037e0:	06c7c563          	blt	a5,a2,8000384a <log_write+0x90>
    800037e4:	00027797          	auipc	a5,0x27
    800037e8:	3887a783          	lw	a5,904(a5) # 8002ab6c <log+0x1c>
    800037ec:	37fd                	addiw	a5,a5,-1
    800037ee:	04f65e63          	bge	a2,a5,8000384a <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800037f2:	00027797          	auipc	a5,0x27
    800037f6:	37e7a783          	lw	a5,894(a5) # 8002ab70 <log+0x20>
    800037fa:	06f05063          	blez	a5,8000385a <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800037fe:	4781                	li	a5,0
    80003800:	06c05563          	blez	a2,8000386a <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003804:	44cc                	lw	a1,12(s1)
    80003806:	00027717          	auipc	a4,0x27
    8000380a:	37a70713          	addi	a4,a4,890 # 8002ab80 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    8000380e:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003810:	4314                	lw	a3,0(a4)
    80003812:	04b68c63          	beq	a3,a1,8000386a <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80003816:	2785                	addiw	a5,a5,1
    80003818:	0711                	addi	a4,a4,4
    8000381a:	fef61be3          	bne	a2,a5,80003810 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    8000381e:	0621                	addi	a2,a2,8
    80003820:	060a                	slli	a2,a2,0x2
    80003822:	00027797          	auipc	a5,0x27
    80003826:	32e78793          	addi	a5,a5,814 # 8002ab50 <log>
    8000382a:	963e                	add	a2,a2,a5
    8000382c:	44dc                	lw	a5,12(s1)
    8000382e:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003830:	8526                	mv	a0,s1
    80003832:	fffff097          	auipc	ra,0xfffff
    80003836:	da2080e7          	jalr	-606(ra) # 800025d4 <bpin>
    log.lh.n++;
    8000383a:	00027717          	auipc	a4,0x27
    8000383e:	31670713          	addi	a4,a4,790 # 8002ab50 <log>
    80003842:	575c                	lw	a5,44(a4)
    80003844:	2785                	addiw	a5,a5,1
    80003846:	d75c                	sw	a5,44(a4)
    80003848:	a835                	j	80003884 <log_write+0xca>
    panic("too big a transaction");
    8000384a:	00005517          	auipc	a0,0x5
    8000384e:	e0e50513          	addi	a0,a0,-498 # 80008658 <syscalls+0x200>
    80003852:	00003097          	auipc	ra,0x3
    80003856:	830080e7          	jalr	-2000(ra) # 80006082 <panic>
    panic("log_write outside of trans");
    8000385a:	00005517          	auipc	a0,0x5
    8000385e:	e1650513          	addi	a0,a0,-490 # 80008670 <syscalls+0x218>
    80003862:	00003097          	auipc	ra,0x3
    80003866:	820080e7          	jalr	-2016(ra) # 80006082 <panic>
  log.lh.block[i] = b->blockno;
    8000386a:	00878713          	addi	a4,a5,8
    8000386e:	00271693          	slli	a3,a4,0x2
    80003872:	00027717          	auipc	a4,0x27
    80003876:	2de70713          	addi	a4,a4,734 # 8002ab50 <log>
    8000387a:	9736                	add	a4,a4,a3
    8000387c:	44d4                	lw	a3,12(s1)
    8000387e:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003880:	faf608e3          	beq	a2,a5,80003830 <log_write+0x76>
  }
  release(&log.lock);
    80003884:	00027517          	auipc	a0,0x27
    80003888:	2cc50513          	addi	a0,a0,716 # 8002ab50 <log>
    8000388c:	00003097          	auipc	ra,0x3
    80003890:	df4080e7          	jalr	-524(ra) # 80006680 <release>
}
    80003894:	60e2                	ld	ra,24(sp)
    80003896:	6442                	ld	s0,16(sp)
    80003898:	64a2                	ld	s1,8(sp)
    8000389a:	6902                	ld	s2,0(sp)
    8000389c:	6105                	addi	sp,sp,32
    8000389e:	8082                	ret

00000000800038a0 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800038a0:	1101                	addi	sp,sp,-32
    800038a2:	ec06                	sd	ra,24(sp)
    800038a4:	e822                	sd	s0,16(sp)
    800038a6:	e426                	sd	s1,8(sp)
    800038a8:	e04a                	sd	s2,0(sp)
    800038aa:	1000                	addi	s0,sp,32
    800038ac:	84aa                	mv	s1,a0
    800038ae:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800038b0:	00005597          	auipc	a1,0x5
    800038b4:	de058593          	addi	a1,a1,-544 # 80008690 <syscalls+0x238>
    800038b8:	0521                	addi	a0,a0,8
    800038ba:	00003097          	auipc	ra,0x3
    800038be:	c82080e7          	jalr	-894(ra) # 8000653c <initlock>
  lk->name = name;
    800038c2:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800038c6:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800038ca:	0204a423          	sw	zero,40(s1)
}
    800038ce:	60e2                	ld	ra,24(sp)
    800038d0:	6442                	ld	s0,16(sp)
    800038d2:	64a2                	ld	s1,8(sp)
    800038d4:	6902                	ld	s2,0(sp)
    800038d6:	6105                	addi	sp,sp,32
    800038d8:	8082                	ret

00000000800038da <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800038da:	1101                	addi	sp,sp,-32
    800038dc:	ec06                	sd	ra,24(sp)
    800038de:	e822                	sd	s0,16(sp)
    800038e0:	e426                	sd	s1,8(sp)
    800038e2:	e04a                	sd	s2,0(sp)
    800038e4:	1000                	addi	s0,sp,32
    800038e6:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800038e8:	00850913          	addi	s2,a0,8
    800038ec:	854a                	mv	a0,s2
    800038ee:	00003097          	auipc	ra,0x3
    800038f2:	cde080e7          	jalr	-802(ra) # 800065cc <acquire>
  while (lk->locked) {
    800038f6:	409c                	lw	a5,0(s1)
    800038f8:	cb89                	beqz	a5,8000390a <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800038fa:	85ca                	mv	a1,s2
    800038fc:	8526                	mv	a0,s1
    800038fe:	ffffe097          	auipc	ra,0xffffe
    80003902:	c08080e7          	jalr	-1016(ra) # 80001506 <sleep>
  while (lk->locked) {
    80003906:	409c                	lw	a5,0(s1)
    80003908:	fbed                	bnez	a5,800038fa <acquiresleep+0x20>
  }
  lk->locked = 1;
    8000390a:	4785                	li	a5,1
    8000390c:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    8000390e:	ffffd097          	auipc	ra,0xffffd
    80003912:	554080e7          	jalr	1364(ra) # 80000e62 <myproc>
    80003916:	591c                	lw	a5,48(a0)
    80003918:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    8000391a:	854a                	mv	a0,s2
    8000391c:	00003097          	auipc	ra,0x3
    80003920:	d64080e7          	jalr	-668(ra) # 80006680 <release>
}
    80003924:	60e2                	ld	ra,24(sp)
    80003926:	6442                	ld	s0,16(sp)
    80003928:	64a2                	ld	s1,8(sp)
    8000392a:	6902                	ld	s2,0(sp)
    8000392c:	6105                	addi	sp,sp,32
    8000392e:	8082                	ret

0000000080003930 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003930:	1101                	addi	sp,sp,-32
    80003932:	ec06                	sd	ra,24(sp)
    80003934:	e822                	sd	s0,16(sp)
    80003936:	e426                	sd	s1,8(sp)
    80003938:	e04a                	sd	s2,0(sp)
    8000393a:	1000                	addi	s0,sp,32
    8000393c:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000393e:	00850913          	addi	s2,a0,8
    80003942:	854a                	mv	a0,s2
    80003944:	00003097          	auipc	ra,0x3
    80003948:	c88080e7          	jalr	-888(ra) # 800065cc <acquire>
  lk->locked = 0;
    8000394c:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003950:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003954:	8526                	mv	a0,s1
    80003956:	ffffe097          	auipc	ra,0xffffe
    8000395a:	c14080e7          	jalr	-1004(ra) # 8000156a <wakeup>
  release(&lk->lk);
    8000395e:	854a                	mv	a0,s2
    80003960:	00003097          	auipc	ra,0x3
    80003964:	d20080e7          	jalr	-736(ra) # 80006680 <release>
}
    80003968:	60e2                	ld	ra,24(sp)
    8000396a:	6442                	ld	s0,16(sp)
    8000396c:	64a2                	ld	s1,8(sp)
    8000396e:	6902                	ld	s2,0(sp)
    80003970:	6105                	addi	sp,sp,32
    80003972:	8082                	ret

0000000080003974 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003974:	7179                	addi	sp,sp,-48
    80003976:	f406                	sd	ra,40(sp)
    80003978:	f022                	sd	s0,32(sp)
    8000397a:	ec26                	sd	s1,24(sp)
    8000397c:	e84a                	sd	s2,16(sp)
    8000397e:	e44e                	sd	s3,8(sp)
    80003980:	1800                	addi	s0,sp,48
    80003982:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003984:	00850913          	addi	s2,a0,8
    80003988:	854a                	mv	a0,s2
    8000398a:	00003097          	auipc	ra,0x3
    8000398e:	c42080e7          	jalr	-958(ra) # 800065cc <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003992:	409c                	lw	a5,0(s1)
    80003994:	ef99                	bnez	a5,800039b2 <holdingsleep+0x3e>
    80003996:	4481                	li	s1,0
  release(&lk->lk);
    80003998:	854a                	mv	a0,s2
    8000399a:	00003097          	auipc	ra,0x3
    8000399e:	ce6080e7          	jalr	-794(ra) # 80006680 <release>
  return r;
}
    800039a2:	8526                	mv	a0,s1
    800039a4:	70a2                	ld	ra,40(sp)
    800039a6:	7402                	ld	s0,32(sp)
    800039a8:	64e2                	ld	s1,24(sp)
    800039aa:	6942                	ld	s2,16(sp)
    800039ac:	69a2                	ld	s3,8(sp)
    800039ae:	6145                	addi	sp,sp,48
    800039b0:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    800039b2:	0284a983          	lw	s3,40(s1)
    800039b6:	ffffd097          	auipc	ra,0xffffd
    800039ba:	4ac080e7          	jalr	1196(ra) # 80000e62 <myproc>
    800039be:	5904                	lw	s1,48(a0)
    800039c0:	413484b3          	sub	s1,s1,s3
    800039c4:	0014b493          	seqz	s1,s1
    800039c8:	bfc1                	j	80003998 <holdingsleep+0x24>

00000000800039ca <fileinit>:
    struct spinlock lock;
    struct file file[NFILE];
} ftable;

void fileinit(void)
{
    800039ca:	1141                	addi	sp,sp,-16
    800039cc:	e406                	sd	ra,8(sp)
    800039ce:	e022                	sd	s0,0(sp)
    800039d0:	0800                	addi	s0,sp,16
    initlock(&ftable.lock, "ftable");
    800039d2:	00005597          	auipc	a1,0x5
    800039d6:	cce58593          	addi	a1,a1,-818 # 800086a0 <syscalls+0x248>
    800039da:	00027517          	auipc	a0,0x27
    800039de:	2be50513          	addi	a0,a0,702 # 8002ac98 <ftable>
    800039e2:	00003097          	auipc	ra,0x3
    800039e6:	b5a080e7          	jalr	-1190(ra) # 8000653c <initlock>
}
    800039ea:	60a2                	ld	ra,8(sp)
    800039ec:	6402                	ld	s0,0(sp)
    800039ee:	0141                	addi	sp,sp,16
    800039f0:	8082                	ret

00000000800039f2 <filealloc>:

// Allocate a file structure.
struct file *
filealloc(void)
{
    800039f2:	1101                	addi	sp,sp,-32
    800039f4:	ec06                	sd	ra,24(sp)
    800039f6:	e822                	sd	s0,16(sp)
    800039f8:	e426                	sd	s1,8(sp)
    800039fa:	1000                	addi	s0,sp,32
    struct file *f;

    acquire(&ftable.lock);
    800039fc:	00027517          	auipc	a0,0x27
    80003a00:	29c50513          	addi	a0,a0,668 # 8002ac98 <ftable>
    80003a04:	00003097          	auipc	ra,0x3
    80003a08:	bc8080e7          	jalr	-1080(ra) # 800065cc <acquire>
    for (f = ftable.file; f < ftable.file + NFILE; f++)
    80003a0c:	00027497          	auipc	s1,0x27
    80003a10:	2a448493          	addi	s1,s1,676 # 8002acb0 <ftable+0x18>
    80003a14:	00028717          	auipc	a4,0x28
    80003a18:	23c70713          	addi	a4,a4,572 # 8002bc50 <disk>
    {
        if (f->ref == 0)
    80003a1c:	40dc                	lw	a5,4(s1)
    80003a1e:	cf99                	beqz	a5,80003a3c <filealloc+0x4a>
    for (f = ftable.file; f < ftable.file + NFILE; f++)
    80003a20:	02848493          	addi	s1,s1,40
    80003a24:	fee49ce3          	bne	s1,a4,80003a1c <filealloc+0x2a>
            f->ref = 1;
            release(&ftable.lock);
            return f;
        }
    }
    release(&ftable.lock);
    80003a28:	00027517          	auipc	a0,0x27
    80003a2c:	27050513          	addi	a0,a0,624 # 8002ac98 <ftable>
    80003a30:	00003097          	auipc	ra,0x3
    80003a34:	c50080e7          	jalr	-944(ra) # 80006680 <release>
    return 0;
    80003a38:	4481                	li	s1,0
    80003a3a:	a819                	j	80003a50 <filealloc+0x5e>
            f->ref = 1;
    80003a3c:	4785                	li	a5,1
    80003a3e:	c0dc                	sw	a5,4(s1)
            release(&ftable.lock);
    80003a40:	00027517          	auipc	a0,0x27
    80003a44:	25850513          	addi	a0,a0,600 # 8002ac98 <ftable>
    80003a48:	00003097          	auipc	ra,0x3
    80003a4c:	c38080e7          	jalr	-968(ra) # 80006680 <release>
}
    80003a50:	8526                	mv	a0,s1
    80003a52:	60e2                	ld	ra,24(sp)
    80003a54:	6442                	ld	s0,16(sp)
    80003a56:	64a2                	ld	s1,8(sp)
    80003a58:	6105                	addi	sp,sp,32
    80003a5a:	8082                	ret

0000000080003a5c <filedup>:

// Increment ref count for file f.
struct file *
filedup(struct file *f)
{
    80003a5c:	1101                	addi	sp,sp,-32
    80003a5e:	ec06                	sd	ra,24(sp)
    80003a60:	e822                	sd	s0,16(sp)
    80003a62:	e426                	sd	s1,8(sp)
    80003a64:	1000                	addi	s0,sp,32
    80003a66:	84aa                	mv	s1,a0
    acquire(&ftable.lock);
    80003a68:	00027517          	auipc	a0,0x27
    80003a6c:	23050513          	addi	a0,a0,560 # 8002ac98 <ftable>
    80003a70:	00003097          	auipc	ra,0x3
    80003a74:	b5c080e7          	jalr	-1188(ra) # 800065cc <acquire>
    if (f->ref < 1)
    80003a78:	40dc                	lw	a5,4(s1)
    80003a7a:	02f05263          	blez	a5,80003a9e <filedup+0x42>
        panic("filedup");
    f->ref++;
    80003a7e:	2785                	addiw	a5,a5,1
    80003a80:	c0dc                	sw	a5,4(s1)
    release(&ftable.lock);
    80003a82:	00027517          	auipc	a0,0x27
    80003a86:	21650513          	addi	a0,a0,534 # 8002ac98 <ftable>
    80003a8a:	00003097          	auipc	ra,0x3
    80003a8e:	bf6080e7          	jalr	-1034(ra) # 80006680 <release>
    return f;
}
    80003a92:	8526                	mv	a0,s1
    80003a94:	60e2                	ld	ra,24(sp)
    80003a96:	6442                	ld	s0,16(sp)
    80003a98:	64a2                	ld	s1,8(sp)
    80003a9a:	6105                	addi	sp,sp,32
    80003a9c:	8082                	ret
        panic("filedup");
    80003a9e:	00005517          	auipc	a0,0x5
    80003aa2:	c0a50513          	addi	a0,a0,-1014 # 800086a8 <syscalls+0x250>
    80003aa6:	00002097          	auipc	ra,0x2
    80003aaa:	5dc080e7          	jalr	1500(ra) # 80006082 <panic>

0000000080003aae <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void fileclose(struct file *f)
{
    80003aae:	7139                	addi	sp,sp,-64
    80003ab0:	fc06                	sd	ra,56(sp)
    80003ab2:	f822                	sd	s0,48(sp)
    80003ab4:	f426                	sd	s1,40(sp)
    80003ab6:	f04a                	sd	s2,32(sp)
    80003ab8:	ec4e                	sd	s3,24(sp)
    80003aba:	e852                	sd	s4,16(sp)
    80003abc:	e456                	sd	s5,8(sp)
    80003abe:	0080                	addi	s0,sp,64
    80003ac0:	84aa                	mv	s1,a0
    struct file ff;

    acquire(&ftable.lock);
    80003ac2:	00027517          	auipc	a0,0x27
    80003ac6:	1d650513          	addi	a0,a0,470 # 8002ac98 <ftable>
    80003aca:	00003097          	auipc	ra,0x3
    80003ace:	b02080e7          	jalr	-1278(ra) # 800065cc <acquire>
    if (f->ref < 1)
    80003ad2:	40dc                	lw	a5,4(s1)
    80003ad4:	06f05163          	blez	a5,80003b36 <fileclose+0x88>
        panic("fileclose");
    if (--f->ref > 0)
    80003ad8:	37fd                	addiw	a5,a5,-1
    80003ada:	0007871b          	sext.w	a4,a5
    80003ade:	c0dc                	sw	a5,4(s1)
    80003ae0:	06e04363          	bgtz	a4,80003b46 <fileclose+0x98>
    {
        release(&ftable.lock);
        return;
    }
    ff = *f;
    80003ae4:	0004a903          	lw	s2,0(s1)
    80003ae8:	0094ca83          	lbu	s5,9(s1)
    80003aec:	0104ba03          	ld	s4,16(s1)
    80003af0:	0184b983          	ld	s3,24(s1)
    f->ref = 0;
    80003af4:	0004a223          	sw	zero,4(s1)
    f->type = FD_NONE;
    80003af8:	0004a023          	sw	zero,0(s1)
    release(&ftable.lock);
    80003afc:	00027517          	auipc	a0,0x27
    80003b00:	19c50513          	addi	a0,a0,412 # 8002ac98 <ftable>
    80003b04:	00003097          	auipc	ra,0x3
    80003b08:	b7c080e7          	jalr	-1156(ra) # 80006680 <release>

    if (ff.type == FD_PIPE)
    80003b0c:	4785                	li	a5,1
    80003b0e:	04f90d63          	beq	s2,a5,80003b68 <fileclose+0xba>
    {
        pipeclose(ff.pipe, ff.writable);
    }
    else if (ff.type == FD_INODE || ff.type == FD_DEVICE)
    80003b12:	3979                	addiw	s2,s2,-2
    80003b14:	4785                	li	a5,1
    80003b16:	0527e063          	bltu	a5,s2,80003b56 <fileclose+0xa8>
    {
        begin_op();
    80003b1a:	00000097          	auipc	ra,0x0
    80003b1e:	ac8080e7          	jalr	-1336(ra) # 800035e2 <begin_op>
        iput(ff.ip);
    80003b22:	854e                	mv	a0,s3
    80003b24:	fffff097          	auipc	ra,0xfffff
    80003b28:	2b6080e7          	jalr	694(ra) # 80002dda <iput>
        end_op();
    80003b2c:	00000097          	auipc	ra,0x0
    80003b30:	b36080e7          	jalr	-1226(ra) # 80003662 <end_op>
    80003b34:	a00d                	j	80003b56 <fileclose+0xa8>
        panic("fileclose");
    80003b36:	00005517          	auipc	a0,0x5
    80003b3a:	b7a50513          	addi	a0,a0,-1158 # 800086b0 <syscalls+0x258>
    80003b3e:	00002097          	auipc	ra,0x2
    80003b42:	544080e7          	jalr	1348(ra) # 80006082 <panic>
        release(&ftable.lock);
    80003b46:	00027517          	auipc	a0,0x27
    80003b4a:	15250513          	addi	a0,a0,338 # 8002ac98 <ftable>
    80003b4e:	00003097          	auipc	ra,0x3
    80003b52:	b32080e7          	jalr	-1230(ra) # 80006680 <release>
    }
}
    80003b56:	70e2                	ld	ra,56(sp)
    80003b58:	7442                	ld	s0,48(sp)
    80003b5a:	74a2                	ld	s1,40(sp)
    80003b5c:	7902                	ld	s2,32(sp)
    80003b5e:	69e2                	ld	s3,24(sp)
    80003b60:	6a42                	ld	s4,16(sp)
    80003b62:	6aa2                	ld	s5,8(sp)
    80003b64:	6121                	addi	sp,sp,64
    80003b66:	8082                	ret
        pipeclose(ff.pipe, ff.writable);
    80003b68:	85d6                	mv	a1,s5
    80003b6a:	8552                	mv	a0,s4
    80003b6c:	00000097          	auipc	ra,0x0
    80003b70:	3a6080e7          	jalr	934(ra) # 80003f12 <pipeclose>
    80003b74:	b7cd                	j	80003b56 <fileclose+0xa8>

0000000080003b76 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int filestat(struct file *f, uint64 addr)
{
    80003b76:	715d                	addi	sp,sp,-80
    80003b78:	e486                	sd	ra,72(sp)
    80003b7a:	e0a2                	sd	s0,64(sp)
    80003b7c:	fc26                	sd	s1,56(sp)
    80003b7e:	f84a                	sd	s2,48(sp)
    80003b80:	f44e                	sd	s3,40(sp)
    80003b82:	0880                	addi	s0,sp,80
    80003b84:	84aa                	mv	s1,a0
    80003b86:	89ae                	mv	s3,a1
    struct proc *p = myproc();
    80003b88:	ffffd097          	auipc	ra,0xffffd
    80003b8c:	2da080e7          	jalr	730(ra) # 80000e62 <myproc>
    struct stat st;

    if (f->type == FD_INODE || f->type == FD_DEVICE)
    80003b90:	409c                	lw	a5,0(s1)
    80003b92:	37f9                	addiw	a5,a5,-2
    80003b94:	4705                	li	a4,1
    80003b96:	04f76763          	bltu	a4,a5,80003be4 <filestat+0x6e>
    80003b9a:	892a                	mv	s2,a0
    {
        ilock(f->ip);
    80003b9c:	6c88                	ld	a0,24(s1)
    80003b9e:	fffff097          	auipc	ra,0xfffff
    80003ba2:	082080e7          	jalr	130(ra) # 80002c20 <ilock>
        stati(f->ip, &st);
    80003ba6:	fb840593          	addi	a1,s0,-72
    80003baa:	6c88                	ld	a0,24(s1)
    80003bac:	fffff097          	auipc	ra,0xfffff
    80003bb0:	2fe080e7          	jalr	766(ra) # 80002eaa <stati>
        iunlock(f->ip);
    80003bb4:	6c88                	ld	a0,24(s1)
    80003bb6:	fffff097          	auipc	ra,0xfffff
    80003bba:	12c080e7          	jalr	300(ra) # 80002ce2 <iunlock>
        if (copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003bbe:	46e1                	li	a3,24
    80003bc0:	fb840613          	addi	a2,s0,-72
    80003bc4:	85ce                	mv	a1,s3
    80003bc6:	05093503          	ld	a0,80(s2)
    80003bca:	ffffd097          	auipc	ra,0xffffd
    80003bce:	f56080e7          	jalr	-170(ra) # 80000b20 <copyout>
    80003bd2:	41f5551b          	sraiw	a0,a0,0x1f
            return -1;
        return 0;
    }
    return -1;
}
    80003bd6:	60a6                	ld	ra,72(sp)
    80003bd8:	6406                	ld	s0,64(sp)
    80003bda:	74e2                	ld	s1,56(sp)
    80003bdc:	7942                	ld	s2,48(sp)
    80003bde:	79a2                	ld	s3,40(sp)
    80003be0:	6161                	addi	sp,sp,80
    80003be2:	8082                	ret
    return -1;
    80003be4:	557d                	li	a0,-1
    80003be6:	bfc5                	j	80003bd6 <filestat+0x60>

0000000080003be8 <mapfile>:

void mapfile(struct file *f, char *mem, int offset)
{
    80003be8:	7179                	addi	sp,sp,-48
    80003bea:	f406                	sd	ra,40(sp)
    80003bec:	f022                	sd	s0,32(sp)
    80003bee:	ec26                	sd	s1,24(sp)
    80003bf0:	e84a                	sd	s2,16(sp)
    80003bf2:	e44e                	sd	s3,8(sp)
    80003bf4:	1800                	addi	s0,sp,48
    80003bf6:	84aa                	mv	s1,a0
    80003bf8:	89ae                	mv	s3,a1
    80003bfa:	8932                	mv	s2,a2
    printf("off %d\n", offset);
    80003bfc:	85b2                	mv	a1,a2
    80003bfe:	00005517          	auipc	a0,0x5
    80003c02:	ac250513          	addi	a0,a0,-1342 # 800086c0 <syscalls+0x268>
    80003c06:	00002097          	auipc	ra,0x2
    80003c0a:	4c6080e7          	jalr	1222(ra) # 800060cc <printf>
    ilock(f->ip);
    80003c0e:	6c88                	ld	a0,24(s1)
    80003c10:	fffff097          	auipc	ra,0xfffff
    80003c14:	010080e7          	jalr	16(ra) # 80002c20 <ilock>
    // printf("[Testing] (mapfile) : finish ilock\n");
    readi(f->ip, 0, (uint64)mem, offset, PGSIZE);
    80003c18:	6705                	lui	a4,0x1
    80003c1a:	86ca                	mv	a3,s2
    80003c1c:	864e                	mv	a2,s3
    80003c1e:	4581                	li	a1,0
    80003c20:	6c88                	ld	a0,24(s1)
    80003c22:	fffff097          	auipc	ra,0xfffff
    80003c26:	2b2080e7          	jalr	690(ra) # 80002ed4 <readi>
    // printf("[Testing] (mapfile) : finish readi\n");
    iunlock(f->ip);
    80003c2a:	6c88                	ld	a0,24(s1)
    80003c2c:	fffff097          	auipc	ra,0xfffff
    80003c30:	0b6080e7          	jalr	182(ra) # 80002ce2 <iunlock>
    // printf("[Testing] (mapfile) : finish iunlock\n");
}
    80003c34:	70a2                	ld	ra,40(sp)
    80003c36:	7402                	ld	s0,32(sp)
    80003c38:	64e2                	ld	s1,24(sp)
    80003c3a:	6942                	ld	s2,16(sp)
    80003c3c:	69a2                	ld	s3,8(sp)
    80003c3e:	6145                	addi	sp,sp,48
    80003c40:	8082                	ret

0000000080003c42 <fileread>:

// Read from file f.
// addr is a user virtual address.
int fileread(struct file *f, uint64 addr, int n)
{
    80003c42:	7179                	addi	sp,sp,-48
    80003c44:	f406                	sd	ra,40(sp)
    80003c46:	f022                	sd	s0,32(sp)
    80003c48:	ec26                	sd	s1,24(sp)
    80003c4a:	e84a                	sd	s2,16(sp)
    80003c4c:	e44e                	sd	s3,8(sp)
    80003c4e:	1800                	addi	s0,sp,48
    int r = 0;

    if (f->readable == 0)
    80003c50:	00854783          	lbu	a5,8(a0)
    80003c54:	c3d5                	beqz	a5,80003cf8 <fileread+0xb6>
    80003c56:	84aa                	mv	s1,a0
    80003c58:	89ae                	mv	s3,a1
    80003c5a:	8932                	mv	s2,a2
        return -1;

    if (f->type == FD_PIPE)
    80003c5c:	411c                	lw	a5,0(a0)
    80003c5e:	4705                	li	a4,1
    80003c60:	04e78963          	beq	a5,a4,80003cb2 <fileread+0x70>
    {
        r = piperead(f->pipe, addr, n);
    }
    else if (f->type == FD_DEVICE)
    80003c64:	470d                	li	a4,3
    80003c66:	04e78d63          	beq	a5,a4,80003cc0 <fileread+0x7e>
    {
        if (f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
            return -1;
        r = devsw[f->major].read(1, addr, n);
    }
    else if (f->type == FD_INODE)
    80003c6a:	4709                	li	a4,2
    80003c6c:	06e79e63          	bne	a5,a4,80003ce8 <fileread+0xa6>
    {
        ilock(f->ip);
    80003c70:	6d08                	ld	a0,24(a0)
    80003c72:	fffff097          	auipc	ra,0xfffff
    80003c76:	fae080e7          	jalr	-82(ra) # 80002c20 <ilock>
        if ((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003c7a:	874a                	mv	a4,s2
    80003c7c:	5094                	lw	a3,32(s1)
    80003c7e:	864e                	mv	a2,s3
    80003c80:	4585                	li	a1,1
    80003c82:	6c88                	ld	a0,24(s1)
    80003c84:	fffff097          	auipc	ra,0xfffff
    80003c88:	250080e7          	jalr	592(ra) # 80002ed4 <readi>
    80003c8c:	892a                	mv	s2,a0
    80003c8e:	00a05563          	blez	a0,80003c98 <fileread+0x56>
            f->off += r;
    80003c92:	509c                	lw	a5,32(s1)
    80003c94:	9fa9                	addw	a5,a5,a0
    80003c96:	d09c                	sw	a5,32(s1)
        iunlock(f->ip);
    80003c98:	6c88                	ld	a0,24(s1)
    80003c9a:	fffff097          	auipc	ra,0xfffff
    80003c9e:	048080e7          	jalr	72(ra) # 80002ce2 <iunlock>
    {
        panic("fileread");
    }

    return r;
}
    80003ca2:	854a                	mv	a0,s2
    80003ca4:	70a2                	ld	ra,40(sp)
    80003ca6:	7402                	ld	s0,32(sp)
    80003ca8:	64e2                	ld	s1,24(sp)
    80003caa:	6942                	ld	s2,16(sp)
    80003cac:	69a2                	ld	s3,8(sp)
    80003cae:	6145                	addi	sp,sp,48
    80003cb0:	8082                	ret
        r = piperead(f->pipe, addr, n);
    80003cb2:	6908                	ld	a0,16(a0)
    80003cb4:	00000097          	auipc	ra,0x0
    80003cb8:	3ce080e7          	jalr	974(ra) # 80004082 <piperead>
    80003cbc:	892a                	mv	s2,a0
    80003cbe:	b7d5                	j	80003ca2 <fileread+0x60>
        if (f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003cc0:	02451783          	lh	a5,36(a0)
    80003cc4:	03079693          	slli	a3,a5,0x30
    80003cc8:	92c1                	srli	a3,a3,0x30
    80003cca:	4725                	li	a4,9
    80003ccc:	02d76863          	bltu	a4,a3,80003cfc <fileread+0xba>
    80003cd0:	0792                	slli	a5,a5,0x4
    80003cd2:	00027717          	auipc	a4,0x27
    80003cd6:	f2670713          	addi	a4,a4,-218 # 8002abf8 <devsw>
    80003cda:	97ba                	add	a5,a5,a4
    80003cdc:	639c                	ld	a5,0(a5)
    80003cde:	c38d                	beqz	a5,80003d00 <fileread+0xbe>
        r = devsw[f->major].read(1, addr, n);
    80003ce0:	4505                	li	a0,1
    80003ce2:	9782                	jalr	a5
    80003ce4:	892a                	mv	s2,a0
    80003ce6:	bf75                	j	80003ca2 <fileread+0x60>
        panic("fileread");
    80003ce8:	00005517          	auipc	a0,0x5
    80003cec:	9e050513          	addi	a0,a0,-1568 # 800086c8 <syscalls+0x270>
    80003cf0:	00002097          	auipc	ra,0x2
    80003cf4:	392080e7          	jalr	914(ra) # 80006082 <panic>
        return -1;
    80003cf8:	597d                	li	s2,-1
    80003cfa:	b765                	j	80003ca2 <fileread+0x60>
            return -1;
    80003cfc:	597d                	li	s2,-1
    80003cfe:	b755                	j	80003ca2 <fileread+0x60>
    80003d00:	597d                	li	s2,-1
    80003d02:	b745                	j	80003ca2 <fileread+0x60>

0000000080003d04 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int filewrite(struct file *f, uint64 addr, int n)
{
    80003d04:	715d                	addi	sp,sp,-80
    80003d06:	e486                	sd	ra,72(sp)
    80003d08:	e0a2                	sd	s0,64(sp)
    80003d0a:	fc26                	sd	s1,56(sp)
    80003d0c:	f84a                	sd	s2,48(sp)
    80003d0e:	f44e                	sd	s3,40(sp)
    80003d10:	f052                	sd	s4,32(sp)
    80003d12:	ec56                	sd	s5,24(sp)
    80003d14:	e85a                	sd	s6,16(sp)
    80003d16:	e45e                	sd	s7,8(sp)
    80003d18:	e062                	sd	s8,0(sp)
    80003d1a:	0880                	addi	s0,sp,80
    int r, ret = 0;

    if (f->writable == 0)
    80003d1c:	00954783          	lbu	a5,9(a0)
    80003d20:	10078663          	beqz	a5,80003e2c <filewrite+0x128>
    80003d24:	892a                	mv	s2,a0
    80003d26:	8aae                	mv	s5,a1
    80003d28:	8a32                	mv	s4,a2
        return -1;

    if (f->type == FD_PIPE)
    80003d2a:	411c                	lw	a5,0(a0)
    80003d2c:	4705                	li	a4,1
    80003d2e:	02e78263          	beq	a5,a4,80003d52 <filewrite+0x4e>
    {
        ret = pipewrite(f->pipe, addr, n);
    }
    else if (f->type == FD_DEVICE)
    80003d32:	470d                	li	a4,3
    80003d34:	02e78663          	beq	a5,a4,80003d60 <filewrite+0x5c>
    {
        if (f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
            return -1;
        ret = devsw[f->major].write(1, addr, n);
    }
    else if (f->type == FD_INODE)
    80003d38:	4709                	li	a4,2
    80003d3a:	0ee79163          	bne	a5,a4,80003e1c <filewrite+0x118>
        // and 2 blocks of slop for non-aligned writes.
        // this really belongs lower down, since writei()
        // might be writing a device like the console.
        int max = ((MAXOPBLOCKS - 1 - 1 - 2) / 2) * BSIZE;
        int i = 0;
        while (i < n)
    80003d3e:	0ac05d63          	blez	a2,80003df8 <filewrite+0xf4>
        int i = 0;
    80003d42:	4981                	li	s3,0
    80003d44:	6b05                	lui	s6,0x1
    80003d46:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003d4a:	6b85                	lui	s7,0x1
    80003d4c:	c00b8b9b          	addiw	s7,s7,-1024
    80003d50:	a861                	j	80003de8 <filewrite+0xe4>
        ret = pipewrite(f->pipe, addr, n);
    80003d52:	6908                	ld	a0,16(a0)
    80003d54:	00000097          	auipc	ra,0x0
    80003d58:	22e080e7          	jalr	558(ra) # 80003f82 <pipewrite>
    80003d5c:	8a2a                	mv	s4,a0
    80003d5e:	a045                	j	80003dfe <filewrite+0xfa>
        if (f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003d60:	02451783          	lh	a5,36(a0)
    80003d64:	03079693          	slli	a3,a5,0x30
    80003d68:	92c1                	srli	a3,a3,0x30
    80003d6a:	4725                	li	a4,9
    80003d6c:	0cd76263          	bltu	a4,a3,80003e30 <filewrite+0x12c>
    80003d70:	0792                	slli	a5,a5,0x4
    80003d72:	00027717          	auipc	a4,0x27
    80003d76:	e8670713          	addi	a4,a4,-378 # 8002abf8 <devsw>
    80003d7a:	97ba                	add	a5,a5,a4
    80003d7c:	679c                	ld	a5,8(a5)
    80003d7e:	cbdd                	beqz	a5,80003e34 <filewrite+0x130>
        ret = devsw[f->major].write(1, addr, n);
    80003d80:	4505                	li	a0,1
    80003d82:	9782                	jalr	a5
    80003d84:	8a2a                	mv	s4,a0
    80003d86:	a8a5                	j	80003dfe <filewrite+0xfa>
    80003d88:	00048c1b          	sext.w	s8,s1
        {
            int n1 = n - i;
            if (n1 > max)
                n1 = max;

            begin_op();
    80003d8c:	00000097          	auipc	ra,0x0
    80003d90:	856080e7          	jalr	-1962(ra) # 800035e2 <begin_op>
            ilock(f->ip);
    80003d94:	01893503          	ld	a0,24(s2)
    80003d98:	fffff097          	auipc	ra,0xfffff
    80003d9c:	e88080e7          	jalr	-376(ra) # 80002c20 <ilock>
            if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003da0:	8762                	mv	a4,s8
    80003da2:	02092683          	lw	a3,32(s2)
    80003da6:	01598633          	add	a2,s3,s5
    80003daa:	4585                	li	a1,1
    80003dac:	01893503          	ld	a0,24(s2)
    80003db0:	fffff097          	auipc	ra,0xfffff
    80003db4:	21c080e7          	jalr	540(ra) # 80002fcc <writei>
    80003db8:	84aa                	mv	s1,a0
    80003dba:	00a05763          	blez	a0,80003dc8 <filewrite+0xc4>
                f->off += r;
    80003dbe:	02092783          	lw	a5,32(s2)
    80003dc2:	9fa9                	addw	a5,a5,a0
    80003dc4:	02f92023          	sw	a5,32(s2)
            iunlock(f->ip);
    80003dc8:	01893503          	ld	a0,24(s2)
    80003dcc:	fffff097          	auipc	ra,0xfffff
    80003dd0:	f16080e7          	jalr	-234(ra) # 80002ce2 <iunlock>
            end_op();
    80003dd4:	00000097          	auipc	ra,0x0
    80003dd8:	88e080e7          	jalr	-1906(ra) # 80003662 <end_op>

            if (r != n1)
    80003ddc:	009c1f63          	bne	s8,s1,80003dfa <filewrite+0xf6>
            {
                // error from writei
                break;
            }
            i += r;
    80003de0:	013489bb          	addw	s3,s1,s3
        while (i < n)
    80003de4:	0149db63          	bge	s3,s4,80003dfa <filewrite+0xf6>
            int n1 = n - i;
    80003de8:	413a07bb          	subw	a5,s4,s3
            if (n1 > max)
    80003dec:	84be                	mv	s1,a5
    80003dee:	2781                	sext.w	a5,a5
    80003df0:	f8fb5ce3          	bge	s6,a5,80003d88 <filewrite+0x84>
    80003df4:	84de                	mv	s1,s7
    80003df6:	bf49                	j	80003d88 <filewrite+0x84>
        int i = 0;
    80003df8:	4981                	li	s3,0
        }
        ret = (i == n ? n : -1);
    80003dfa:	013a1f63          	bne	s4,s3,80003e18 <filewrite+0x114>
    {
        panic("filewrite");
    }

    return ret;
}
    80003dfe:	8552                	mv	a0,s4
    80003e00:	60a6                	ld	ra,72(sp)
    80003e02:	6406                	ld	s0,64(sp)
    80003e04:	74e2                	ld	s1,56(sp)
    80003e06:	7942                	ld	s2,48(sp)
    80003e08:	79a2                	ld	s3,40(sp)
    80003e0a:	7a02                	ld	s4,32(sp)
    80003e0c:	6ae2                	ld	s5,24(sp)
    80003e0e:	6b42                	ld	s6,16(sp)
    80003e10:	6ba2                	ld	s7,8(sp)
    80003e12:	6c02                	ld	s8,0(sp)
    80003e14:	6161                	addi	sp,sp,80
    80003e16:	8082                	ret
        ret = (i == n ? n : -1);
    80003e18:	5a7d                	li	s4,-1
    80003e1a:	b7d5                	j	80003dfe <filewrite+0xfa>
        panic("filewrite");
    80003e1c:	00005517          	auipc	a0,0x5
    80003e20:	8bc50513          	addi	a0,a0,-1860 # 800086d8 <syscalls+0x280>
    80003e24:	00002097          	auipc	ra,0x2
    80003e28:	25e080e7          	jalr	606(ra) # 80006082 <panic>
        return -1;
    80003e2c:	5a7d                	li	s4,-1
    80003e2e:	bfc1                	j	80003dfe <filewrite+0xfa>
            return -1;
    80003e30:	5a7d                	li	s4,-1
    80003e32:	b7f1                	j	80003dfe <filewrite+0xfa>
    80003e34:	5a7d                	li	s4,-1
    80003e36:	b7e1                	j	80003dfe <filewrite+0xfa>

0000000080003e38 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003e38:	7179                	addi	sp,sp,-48
    80003e3a:	f406                	sd	ra,40(sp)
    80003e3c:	f022                	sd	s0,32(sp)
    80003e3e:	ec26                	sd	s1,24(sp)
    80003e40:	e84a                	sd	s2,16(sp)
    80003e42:	e44e                	sd	s3,8(sp)
    80003e44:	e052                	sd	s4,0(sp)
    80003e46:	1800                	addi	s0,sp,48
    80003e48:	84aa                	mv	s1,a0
    80003e4a:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003e4c:	0005b023          	sd	zero,0(a1)
    80003e50:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003e54:	00000097          	auipc	ra,0x0
    80003e58:	b9e080e7          	jalr	-1122(ra) # 800039f2 <filealloc>
    80003e5c:	e088                	sd	a0,0(s1)
    80003e5e:	c551                	beqz	a0,80003eea <pipealloc+0xb2>
    80003e60:	00000097          	auipc	ra,0x0
    80003e64:	b92080e7          	jalr	-1134(ra) # 800039f2 <filealloc>
    80003e68:	00aa3023          	sd	a0,0(s4)
    80003e6c:	c92d                	beqz	a0,80003ede <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003e6e:	ffffc097          	auipc	ra,0xffffc
    80003e72:	2aa080e7          	jalr	682(ra) # 80000118 <kalloc>
    80003e76:	892a                	mv	s2,a0
    80003e78:	c125                	beqz	a0,80003ed8 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003e7a:	4985                	li	s3,1
    80003e7c:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003e80:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003e84:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003e88:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003e8c:	00005597          	auipc	a1,0x5
    80003e90:	85c58593          	addi	a1,a1,-1956 # 800086e8 <syscalls+0x290>
    80003e94:	00002097          	auipc	ra,0x2
    80003e98:	6a8080e7          	jalr	1704(ra) # 8000653c <initlock>
  (*f0)->type = FD_PIPE;
    80003e9c:	609c                	ld	a5,0(s1)
    80003e9e:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003ea2:	609c                	ld	a5,0(s1)
    80003ea4:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003ea8:	609c                	ld	a5,0(s1)
    80003eaa:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003eae:	609c                	ld	a5,0(s1)
    80003eb0:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003eb4:	000a3783          	ld	a5,0(s4)
    80003eb8:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003ebc:	000a3783          	ld	a5,0(s4)
    80003ec0:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003ec4:	000a3783          	ld	a5,0(s4)
    80003ec8:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003ecc:	000a3783          	ld	a5,0(s4)
    80003ed0:	0127b823          	sd	s2,16(a5)
  return 0;
    80003ed4:	4501                	li	a0,0
    80003ed6:	a025                	j	80003efe <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003ed8:	6088                	ld	a0,0(s1)
    80003eda:	e501                	bnez	a0,80003ee2 <pipealloc+0xaa>
    80003edc:	a039                	j	80003eea <pipealloc+0xb2>
    80003ede:	6088                	ld	a0,0(s1)
    80003ee0:	c51d                	beqz	a0,80003f0e <pipealloc+0xd6>
    fileclose(*f0);
    80003ee2:	00000097          	auipc	ra,0x0
    80003ee6:	bcc080e7          	jalr	-1076(ra) # 80003aae <fileclose>
  if(*f1)
    80003eea:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003eee:	557d                	li	a0,-1
  if(*f1)
    80003ef0:	c799                	beqz	a5,80003efe <pipealloc+0xc6>
    fileclose(*f1);
    80003ef2:	853e                	mv	a0,a5
    80003ef4:	00000097          	auipc	ra,0x0
    80003ef8:	bba080e7          	jalr	-1094(ra) # 80003aae <fileclose>
  return -1;
    80003efc:	557d                	li	a0,-1
}
    80003efe:	70a2                	ld	ra,40(sp)
    80003f00:	7402                	ld	s0,32(sp)
    80003f02:	64e2                	ld	s1,24(sp)
    80003f04:	6942                	ld	s2,16(sp)
    80003f06:	69a2                	ld	s3,8(sp)
    80003f08:	6a02                	ld	s4,0(sp)
    80003f0a:	6145                	addi	sp,sp,48
    80003f0c:	8082                	ret
  return -1;
    80003f0e:	557d                	li	a0,-1
    80003f10:	b7fd                	j	80003efe <pipealloc+0xc6>

0000000080003f12 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003f12:	1101                	addi	sp,sp,-32
    80003f14:	ec06                	sd	ra,24(sp)
    80003f16:	e822                	sd	s0,16(sp)
    80003f18:	e426                	sd	s1,8(sp)
    80003f1a:	e04a                	sd	s2,0(sp)
    80003f1c:	1000                	addi	s0,sp,32
    80003f1e:	84aa                	mv	s1,a0
    80003f20:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003f22:	00002097          	auipc	ra,0x2
    80003f26:	6aa080e7          	jalr	1706(ra) # 800065cc <acquire>
  if(writable){
    80003f2a:	02090d63          	beqz	s2,80003f64 <pipeclose+0x52>
    pi->writeopen = 0;
    80003f2e:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003f32:	21848513          	addi	a0,s1,536
    80003f36:	ffffd097          	auipc	ra,0xffffd
    80003f3a:	634080e7          	jalr	1588(ra) # 8000156a <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003f3e:	2204b783          	ld	a5,544(s1)
    80003f42:	eb95                	bnez	a5,80003f76 <pipeclose+0x64>
    release(&pi->lock);
    80003f44:	8526                	mv	a0,s1
    80003f46:	00002097          	auipc	ra,0x2
    80003f4a:	73a080e7          	jalr	1850(ra) # 80006680 <release>
    kfree((char*)pi);
    80003f4e:	8526                	mv	a0,s1
    80003f50:	ffffc097          	auipc	ra,0xffffc
    80003f54:	0cc080e7          	jalr	204(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003f58:	60e2                	ld	ra,24(sp)
    80003f5a:	6442                	ld	s0,16(sp)
    80003f5c:	64a2                	ld	s1,8(sp)
    80003f5e:	6902                	ld	s2,0(sp)
    80003f60:	6105                	addi	sp,sp,32
    80003f62:	8082                	ret
    pi->readopen = 0;
    80003f64:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003f68:	21c48513          	addi	a0,s1,540
    80003f6c:	ffffd097          	auipc	ra,0xffffd
    80003f70:	5fe080e7          	jalr	1534(ra) # 8000156a <wakeup>
    80003f74:	b7e9                	j	80003f3e <pipeclose+0x2c>
    release(&pi->lock);
    80003f76:	8526                	mv	a0,s1
    80003f78:	00002097          	auipc	ra,0x2
    80003f7c:	708080e7          	jalr	1800(ra) # 80006680 <release>
}
    80003f80:	bfe1                	j	80003f58 <pipeclose+0x46>

0000000080003f82 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003f82:	7159                	addi	sp,sp,-112
    80003f84:	f486                	sd	ra,104(sp)
    80003f86:	f0a2                	sd	s0,96(sp)
    80003f88:	eca6                	sd	s1,88(sp)
    80003f8a:	e8ca                	sd	s2,80(sp)
    80003f8c:	e4ce                	sd	s3,72(sp)
    80003f8e:	e0d2                	sd	s4,64(sp)
    80003f90:	fc56                	sd	s5,56(sp)
    80003f92:	f85a                	sd	s6,48(sp)
    80003f94:	f45e                	sd	s7,40(sp)
    80003f96:	f062                	sd	s8,32(sp)
    80003f98:	ec66                	sd	s9,24(sp)
    80003f9a:	1880                	addi	s0,sp,112
    80003f9c:	84aa                	mv	s1,a0
    80003f9e:	8aae                	mv	s5,a1
    80003fa0:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003fa2:	ffffd097          	auipc	ra,0xffffd
    80003fa6:	ec0080e7          	jalr	-320(ra) # 80000e62 <myproc>
    80003faa:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003fac:	8526                	mv	a0,s1
    80003fae:	00002097          	auipc	ra,0x2
    80003fb2:	61e080e7          	jalr	1566(ra) # 800065cc <acquire>
  while(i < n){
    80003fb6:	0d405463          	blez	s4,8000407e <pipewrite+0xfc>
    80003fba:	8ba6                	mv	s7,s1
  int i = 0;
    80003fbc:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003fbe:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003fc0:	21848c93          	addi	s9,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003fc4:	21c48c13          	addi	s8,s1,540
    80003fc8:	a08d                	j	8000402a <pipewrite+0xa8>
      release(&pi->lock);
    80003fca:	8526                	mv	a0,s1
    80003fcc:	00002097          	auipc	ra,0x2
    80003fd0:	6b4080e7          	jalr	1716(ra) # 80006680 <release>
      return -1;
    80003fd4:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003fd6:	854a                	mv	a0,s2
    80003fd8:	70a6                	ld	ra,104(sp)
    80003fda:	7406                	ld	s0,96(sp)
    80003fdc:	64e6                	ld	s1,88(sp)
    80003fde:	6946                	ld	s2,80(sp)
    80003fe0:	69a6                	ld	s3,72(sp)
    80003fe2:	6a06                	ld	s4,64(sp)
    80003fe4:	7ae2                	ld	s5,56(sp)
    80003fe6:	7b42                	ld	s6,48(sp)
    80003fe8:	7ba2                	ld	s7,40(sp)
    80003fea:	7c02                	ld	s8,32(sp)
    80003fec:	6ce2                	ld	s9,24(sp)
    80003fee:	6165                	addi	sp,sp,112
    80003ff0:	8082                	ret
      wakeup(&pi->nread);
    80003ff2:	8566                	mv	a0,s9
    80003ff4:	ffffd097          	auipc	ra,0xffffd
    80003ff8:	576080e7          	jalr	1398(ra) # 8000156a <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003ffc:	85de                	mv	a1,s7
    80003ffe:	8562                	mv	a0,s8
    80004000:	ffffd097          	auipc	ra,0xffffd
    80004004:	506080e7          	jalr	1286(ra) # 80001506 <sleep>
    80004008:	a839                	j	80004026 <pipewrite+0xa4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    8000400a:	21c4a783          	lw	a5,540(s1)
    8000400e:	0017871b          	addiw	a4,a5,1
    80004012:	20e4ae23          	sw	a4,540(s1)
    80004016:	1ff7f793          	andi	a5,a5,511
    8000401a:	97a6                	add	a5,a5,s1
    8000401c:	f9f44703          	lbu	a4,-97(s0)
    80004020:	00e78c23          	sb	a4,24(a5)
      i++;
    80004024:	2905                	addiw	s2,s2,1
  while(i < n){
    80004026:	05495063          	bge	s2,s4,80004066 <pipewrite+0xe4>
    if(pi->readopen == 0 || killed(pr)){
    8000402a:	2204a783          	lw	a5,544(s1)
    8000402e:	dfd1                	beqz	a5,80003fca <pipewrite+0x48>
    80004030:	854e                	mv	a0,s3
    80004032:	ffffd097          	auipc	ra,0xffffd
    80004036:	77c080e7          	jalr	1916(ra) # 800017ae <killed>
    8000403a:	f941                	bnez	a0,80003fca <pipewrite+0x48>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    8000403c:	2184a783          	lw	a5,536(s1)
    80004040:	21c4a703          	lw	a4,540(s1)
    80004044:	2007879b          	addiw	a5,a5,512
    80004048:	faf705e3          	beq	a4,a5,80003ff2 <pipewrite+0x70>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000404c:	4685                	li	a3,1
    8000404e:	01590633          	add	a2,s2,s5
    80004052:	f9f40593          	addi	a1,s0,-97
    80004056:	0509b503          	ld	a0,80(s3)
    8000405a:	ffffd097          	auipc	ra,0xffffd
    8000405e:	b52080e7          	jalr	-1198(ra) # 80000bac <copyin>
    80004062:	fb6514e3          	bne	a0,s6,8000400a <pipewrite+0x88>
  wakeup(&pi->nread);
    80004066:	21848513          	addi	a0,s1,536
    8000406a:	ffffd097          	auipc	ra,0xffffd
    8000406e:	500080e7          	jalr	1280(ra) # 8000156a <wakeup>
  release(&pi->lock);
    80004072:	8526                	mv	a0,s1
    80004074:	00002097          	auipc	ra,0x2
    80004078:	60c080e7          	jalr	1548(ra) # 80006680 <release>
  return i;
    8000407c:	bfa9                	j	80003fd6 <pipewrite+0x54>
  int i = 0;
    8000407e:	4901                	li	s2,0
    80004080:	b7dd                	j	80004066 <pipewrite+0xe4>

0000000080004082 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004082:	715d                	addi	sp,sp,-80
    80004084:	e486                	sd	ra,72(sp)
    80004086:	e0a2                	sd	s0,64(sp)
    80004088:	fc26                	sd	s1,56(sp)
    8000408a:	f84a                	sd	s2,48(sp)
    8000408c:	f44e                	sd	s3,40(sp)
    8000408e:	f052                	sd	s4,32(sp)
    80004090:	ec56                	sd	s5,24(sp)
    80004092:	e85a                	sd	s6,16(sp)
    80004094:	0880                	addi	s0,sp,80
    80004096:	84aa                	mv	s1,a0
    80004098:	892e                	mv	s2,a1
    8000409a:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    8000409c:	ffffd097          	auipc	ra,0xffffd
    800040a0:	dc6080e7          	jalr	-570(ra) # 80000e62 <myproc>
    800040a4:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800040a6:	8b26                	mv	s6,s1
    800040a8:	8526                	mv	a0,s1
    800040aa:	00002097          	auipc	ra,0x2
    800040ae:	522080e7          	jalr	1314(ra) # 800065cc <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800040b2:	2184a703          	lw	a4,536(s1)
    800040b6:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800040ba:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800040be:	02f71763          	bne	a4,a5,800040ec <piperead+0x6a>
    800040c2:	2244a783          	lw	a5,548(s1)
    800040c6:	c39d                	beqz	a5,800040ec <piperead+0x6a>
    if(killed(pr)){
    800040c8:	8552                	mv	a0,s4
    800040ca:	ffffd097          	auipc	ra,0xffffd
    800040ce:	6e4080e7          	jalr	1764(ra) # 800017ae <killed>
    800040d2:	e941                	bnez	a0,80004162 <piperead+0xe0>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800040d4:	85da                	mv	a1,s6
    800040d6:	854e                	mv	a0,s3
    800040d8:	ffffd097          	auipc	ra,0xffffd
    800040dc:	42e080e7          	jalr	1070(ra) # 80001506 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800040e0:	2184a703          	lw	a4,536(s1)
    800040e4:	21c4a783          	lw	a5,540(s1)
    800040e8:	fcf70de3          	beq	a4,a5,800040c2 <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800040ec:	09505263          	blez	s5,80004170 <piperead+0xee>
    800040f0:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800040f2:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    800040f4:	2184a783          	lw	a5,536(s1)
    800040f8:	21c4a703          	lw	a4,540(s1)
    800040fc:	02f70d63          	beq	a4,a5,80004136 <piperead+0xb4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004100:	0017871b          	addiw	a4,a5,1
    80004104:	20e4ac23          	sw	a4,536(s1)
    80004108:	1ff7f793          	andi	a5,a5,511
    8000410c:	97a6                	add	a5,a5,s1
    8000410e:	0187c783          	lbu	a5,24(a5)
    80004112:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004116:	4685                	li	a3,1
    80004118:	fbf40613          	addi	a2,s0,-65
    8000411c:	85ca                	mv	a1,s2
    8000411e:	050a3503          	ld	a0,80(s4)
    80004122:	ffffd097          	auipc	ra,0xffffd
    80004126:	9fe080e7          	jalr	-1538(ra) # 80000b20 <copyout>
    8000412a:	01650663          	beq	a0,s6,80004136 <piperead+0xb4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000412e:	2985                	addiw	s3,s3,1
    80004130:	0905                	addi	s2,s2,1
    80004132:	fd3a91e3          	bne	s5,s3,800040f4 <piperead+0x72>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004136:	21c48513          	addi	a0,s1,540
    8000413a:	ffffd097          	auipc	ra,0xffffd
    8000413e:	430080e7          	jalr	1072(ra) # 8000156a <wakeup>
  release(&pi->lock);
    80004142:	8526                	mv	a0,s1
    80004144:	00002097          	auipc	ra,0x2
    80004148:	53c080e7          	jalr	1340(ra) # 80006680 <release>
  return i;
}
    8000414c:	854e                	mv	a0,s3
    8000414e:	60a6                	ld	ra,72(sp)
    80004150:	6406                	ld	s0,64(sp)
    80004152:	74e2                	ld	s1,56(sp)
    80004154:	7942                	ld	s2,48(sp)
    80004156:	79a2                	ld	s3,40(sp)
    80004158:	7a02                	ld	s4,32(sp)
    8000415a:	6ae2                	ld	s5,24(sp)
    8000415c:	6b42                	ld	s6,16(sp)
    8000415e:	6161                	addi	sp,sp,80
    80004160:	8082                	ret
      release(&pi->lock);
    80004162:	8526                	mv	a0,s1
    80004164:	00002097          	auipc	ra,0x2
    80004168:	51c080e7          	jalr	1308(ra) # 80006680 <release>
      return -1;
    8000416c:	59fd                	li	s3,-1
    8000416e:	bff9                	j	8000414c <piperead+0xca>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004170:	4981                	li	s3,0
    80004172:	b7d1                	j	80004136 <piperead+0xb4>

0000000080004174 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80004174:	1141                	addi	sp,sp,-16
    80004176:	e422                	sd	s0,8(sp)
    80004178:	0800                	addi	s0,sp,16
    8000417a:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    8000417c:	8905                	andi	a0,a0,1
    8000417e:	c111                	beqz	a0,80004182 <flags2perm+0xe>
      perm = PTE_X;
    80004180:	4521                	li	a0,8
    if(flags & 0x2)
    80004182:	8b89                	andi	a5,a5,2
    80004184:	c399                	beqz	a5,8000418a <flags2perm+0x16>
      perm |= PTE_W;
    80004186:	00456513          	ori	a0,a0,4
    return perm;
}
    8000418a:	6422                	ld	s0,8(sp)
    8000418c:	0141                	addi	sp,sp,16
    8000418e:	8082                	ret

0000000080004190 <exec>:

int
exec(char *path, char **argv)
{
    80004190:	df010113          	addi	sp,sp,-528
    80004194:	20113423          	sd	ra,520(sp)
    80004198:	20813023          	sd	s0,512(sp)
    8000419c:	ffa6                	sd	s1,504(sp)
    8000419e:	fbca                	sd	s2,496(sp)
    800041a0:	f7ce                	sd	s3,488(sp)
    800041a2:	f3d2                	sd	s4,480(sp)
    800041a4:	efd6                	sd	s5,472(sp)
    800041a6:	ebda                	sd	s6,464(sp)
    800041a8:	e7de                	sd	s7,456(sp)
    800041aa:	e3e2                	sd	s8,448(sp)
    800041ac:	ff66                	sd	s9,440(sp)
    800041ae:	fb6a                	sd	s10,432(sp)
    800041b0:	f76e                	sd	s11,424(sp)
    800041b2:	0c00                	addi	s0,sp,528
    800041b4:	84aa                	mv	s1,a0
    800041b6:	dea43c23          	sd	a0,-520(s0)
    800041ba:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800041be:	ffffd097          	auipc	ra,0xffffd
    800041c2:	ca4080e7          	jalr	-860(ra) # 80000e62 <myproc>
    800041c6:	892a                	mv	s2,a0

  begin_op();
    800041c8:	fffff097          	auipc	ra,0xfffff
    800041cc:	41a080e7          	jalr	1050(ra) # 800035e2 <begin_op>

  if((ip = namei(path)) == 0){
    800041d0:	8526                	mv	a0,s1
    800041d2:	fffff097          	auipc	ra,0xfffff
    800041d6:	1f4080e7          	jalr	500(ra) # 800033c6 <namei>
    800041da:	c92d                	beqz	a0,8000424c <exec+0xbc>
    800041dc:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800041de:	fffff097          	auipc	ra,0xfffff
    800041e2:	a42080e7          	jalr	-1470(ra) # 80002c20 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800041e6:	04000713          	li	a4,64
    800041ea:	4681                	li	a3,0
    800041ec:	e5040613          	addi	a2,s0,-432
    800041f0:	4581                	li	a1,0
    800041f2:	8526                	mv	a0,s1
    800041f4:	fffff097          	auipc	ra,0xfffff
    800041f8:	ce0080e7          	jalr	-800(ra) # 80002ed4 <readi>
    800041fc:	04000793          	li	a5,64
    80004200:	00f51a63          	bne	a0,a5,80004214 <exec+0x84>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80004204:	e5042703          	lw	a4,-432(s0)
    80004208:	464c47b7          	lui	a5,0x464c4
    8000420c:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004210:	04f70463          	beq	a4,a5,80004258 <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004214:	8526                	mv	a0,s1
    80004216:	fffff097          	auipc	ra,0xfffff
    8000421a:	c6c080e7          	jalr	-916(ra) # 80002e82 <iunlockput>
    end_op();
    8000421e:	fffff097          	auipc	ra,0xfffff
    80004222:	444080e7          	jalr	1092(ra) # 80003662 <end_op>
  }
  return -1;
    80004226:	557d                	li	a0,-1
}
    80004228:	20813083          	ld	ra,520(sp)
    8000422c:	20013403          	ld	s0,512(sp)
    80004230:	74fe                	ld	s1,504(sp)
    80004232:	795e                	ld	s2,496(sp)
    80004234:	79be                	ld	s3,488(sp)
    80004236:	7a1e                	ld	s4,480(sp)
    80004238:	6afe                	ld	s5,472(sp)
    8000423a:	6b5e                	ld	s6,464(sp)
    8000423c:	6bbe                	ld	s7,456(sp)
    8000423e:	6c1e                	ld	s8,448(sp)
    80004240:	7cfa                	ld	s9,440(sp)
    80004242:	7d5a                	ld	s10,432(sp)
    80004244:	7dba                	ld	s11,424(sp)
    80004246:	21010113          	addi	sp,sp,528
    8000424a:	8082                	ret
    end_op();
    8000424c:	fffff097          	auipc	ra,0xfffff
    80004250:	416080e7          	jalr	1046(ra) # 80003662 <end_op>
    return -1;
    80004254:	557d                	li	a0,-1
    80004256:	bfc9                	j	80004228 <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    80004258:	854a                	mv	a0,s2
    8000425a:	ffffd097          	auipc	ra,0xffffd
    8000425e:	ccc080e7          	jalr	-820(ra) # 80000f26 <proc_pagetable>
    80004262:	8baa                	mv	s7,a0
    80004264:	d945                	beqz	a0,80004214 <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004266:	e7042983          	lw	s3,-400(s0)
    8000426a:	e8845783          	lhu	a5,-376(s0)
    8000426e:	c7ad                	beqz	a5,800042d8 <exec+0x148>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004270:	4a01                	li	s4,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004272:	4b01                	li	s6,0
    if(ph.vaddr % PGSIZE != 0)
    80004274:	6c85                	lui	s9,0x1
    80004276:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    8000427a:	def43823          	sd	a5,-528(s0)
    8000427e:	ac0d                	j	800044b0 <exec+0x320>
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80004280:	00004517          	auipc	a0,0x4
    80004284:	47050513          	addi	a0,a0,1136 # 800086f0 <syscalls+0x298>
    80004288:	00002097          	auipc	ra,0x2
    8000428c:	dfa080e7          	jalr	-518(ra) # 80006082 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004290:	8756                	mv	a4,s5
    80004292:	012d86bb          	addw	a3,s11,s2
    80004296:	4581                	li	a1,0
    80004298:	8526                	mv	a0,s1
    8000429a:	fffff097          	auipc	ra,0xfffff
    8000429e:	c3a080e7          	jalr	-966(ra) # 80002ed4 <readi>
    800042a2:	2501                	sext.w	a0,a0
    800042a4:	1aaa9a63          	bne	s5,a0,80004458 <exec+0x2c8>
  for(i = 0; i < sz; i += PGSIZE){
    800042a8:	6785                	lui	a5,0x1
    800042aa:	0127893b          	addw	s2,a5,s2
    800042ae:	77fd                	lui	a5,0xfffff
    800042b0:	01478a3b          	addw	s4,a5,s4
    800042b4:	1f897563          	bgeu	s2,s8,8000449e <exec+0x30e>
    pa = walkaddr(pagetable, va + i);
    800042b8:	02091593          	slli	a1,s2,0x20
    800042bc:	9181                	srli	a1,a1,0x20
    800042be:	95ea                	add	a1,a1,s10
    800042c0:	855e                	mv	a0,s7
    800042c2:	ffffc097          	auipc	ra,0xffffc
    800042c6:	248080e7          	jalr	584(ra) # 8000050a <walkaddr>
    800042ca:	862a                	mv	a2,a0
    if(pa == 0)
    800042cc:	d955                	beqz	a0,80004280 <exec+0xf0>
      n = PGSIZE;
    800042ce:	8ae6                	mv	s5,s9
    if(sz - i < PGSIZE)
    800042d0:	fd9a70e3          	bgeu	s4,s9,80004290 <exec+0x100>
      n = sz - i;
    800042d4:	8ad2                	mv	s5,s4
    800042d6:	bf6d                	j	80004290 <exec+0x100>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800042d8:	4a01                	li	s4,0
  iunlockput(ip);
    800042da:	8526                	mv	a0,s1
    800042dc:	fffff097          	auipc	ra,0xfffff
    800042e0:	ba6080e7          	jalr	-1114(ra) # 80002e82 <iunlockput>
  end_op();
    800042e4:	fffff097          	auipc	ra,0xfffff
    800042e8:	37e080e7          	jalr	894(ra) # 80003662 <end_op>
  p = myproc();
    800042ec:	ffffd097          	auipc	ra,0xffffd
    800042f0:	b76080e7          	jalr	-1162(ra) # 80000e62 <myproc>
    800042f4:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    800042f6:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    800042fa:	6785                	lui	a5,0x1
    800042fc:	17fd                	addi	a5,a5,-1
    800042fe:	9a3e                	add	s4,s4,a5
    80004300:	757d                	lui	a0,0xfffff
    80004302:	00aa77b3          	and	a5,s4,a0
    80004306:	e0f43423          	sd	a5,-504(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    8000430a:	4691                	li	a3,4
    8000430c:	6609                	lui	a2,0x2
    8000430e:	963e                	add	a2,a2,a5
    80004310:	85be                	mv	a1,a5
    80004312:	855e                	mv	a0,s7
    80004314:	ffffc097          	auipc	ra,0xffffc
    80004318:	5c0080e7          	jalr	1472(ra) # 800008d4 <uvmalloc>
    8000431c:	8b2a                	mv	s6,a0
  ip = 0;
    8000431e:	4481                	li	s1,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80004320:	12050c63          	beqz	a0,80004458 <exec+0x2c8>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004324:	75f9                	lui	a1,0xffffe
    80004326:	95aa                	add	a1,a1,a0
    80004328:	855e                	mv	a0,s7
    8000432a:	ffffc097          	auipc	ra,0xffffc
    8000432e:	7c4080e7          	jalr	1988(ra) # 80000aee <uvmclear>
  stackbase = sp - PGSIZE;
    80004332:	7c7d                	lui	s8,0xfffff
    80004334:	9c5a                	add	s8,s8,s6
  for(argc = 0; argv[argc]; argc++) {
    80004336:	e0043783          	ld	a5,-512(s0)
    8000433a:	6388                	ld	a0,0(a5)
    8000433c:	c535                	beqz	a0,800043a8 <exec+0x218>
    8000433e:	e9040993          	addi	s3,s0,-368
    80004342:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    80004346:	895a                	mv	s2,s6
    sp -= strlen(argv[argc]) + 1;
    80004348:	ffffc097          	auipc	ra,0xffffc
    8000434c:	fb4080e7          	jalr	-76(ra) # 800002fc <strlen>
    80004350:	2505                	addiw	a0,a0,1
    80004352:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004356:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    8000435a:	13896663          	bltu	s2,s8,80004486 <exec+0x2f6>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    8000435e:	e0043d83          	ld	s11,-512(s0)
    80004362:	000dba03          	ld	s4,0(s11)
    80004366:	8552                	mv	a0,s4
    80004368:	ffffc097          	auipc	ra,0xffffc
    8000436c:	f94080e7          	jalr	-108(ra) # 800002fc <strlen>
    80004370:	0015069b          	addiw	a3,a0,1
    80004374:	8652                	mv	a2,s4
    80004376:	85ca                	mv	a1,s2
    80004378:	855e                	mv	a0,s7
    8000437a:	ffffc097          	auipc	ra,0xffffc
    8000437e:	7a6080e7          	jalr	1958(ra) # 80000b20 <copyout>
    80004382:	10054663          	bltz	a0,8000448e <exec+0x2fe>
    ustack[argc] = sp;
    80004386:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    8000438a:	0485                	addi	s1,s1,1
    8000438c:	008d8793          	addi	a5,s11,8
    80004390:	e0f43023          	sd	a5,-512(s0)
    80004394:	008db503          	ld	a0,8(s11)
    80004398:	c911                	beqz	a0,800043ac <exec+0x21c>
    if(argc >= MAXARG)
    8000439a:	09a1                	addi	s3,s3,8
    8000439c:	fb3c96e3          	bne	s9,s3,80004348 <exec+0x1b8>
  sz = sz1;
    800043a0:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800043a4:	4481                	li	s1,0
    800043a6:	a84d                	j	80004458 <exec+0x2c8>
  sp = sz;
    800043a8:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    800043aa:	4481                	li	s1,0
  ustack[argc] = 0;
    800043ac:	00349793          	slli	a5,s1,0x3
    800043b0:	f9040713          	addi	a4,s0,-112
    800043b4:	97ba                	add	a5,a5,a4
    800043b6:	f007b023          	sd	zero,-256(a5) # f00 <_entry-0x7ffff100>
  sp -= (argc+1) * sizeof(uint64);
    800043ba:	00148693          	addi	a3,s1,1
    800043be:	068e                	slli	a3,a3,0x3
    800043c0:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800043c4:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    800043c8:	01897663          	bgeu	s2,s8,800043d4 <exec+0x244>
  sz = sz1;
    800043cc:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800043d0:	4481                	li	s1,0
    800043d2:	a059                	j	80004458 <exec+0x2c8>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800043d4:	e9040613          	addi	a2,s0,-368
    800043d8:	85ca                	mv	a1,s2
    800043da:	855e                	mv	a0,s7
    800043dc:	ffffc097          	auipc	ra,0xffffc
    800043e0:	744080e7          	jalr	1860(ra) # 80000b20 <copyout>
    800043e4:	0a054963          	bltz	a0,80004496 <exec+0x306>
  p->trapframe->a1 = sp;
    800043e8:	058ab783          	ld	a5,88(s5)
    800043ec:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800043f0:	df843783          	ld	a5,-520(s0)
    800043f4:	0007c703          	lbu	a4,0(a5)
    800043f8:	cf11                	beqz	a4,80004414 <exec+0x284>
    800043fa:	0785                	addi	a5,a5,1
    if(*s == '/')
    800043fc:	02f00693          	li	a3,47
    80004400:	a039                	j	8000440e <exec+0x27e>
      last = s+1;
    80004402:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80004406:	0785                	addi	a5,a5,1
    80004408:	fff7c703          	lbu	a4,-1(a5)
    8000440c:	c701                	beqz	a4,80004414 <exec+0x284>
    if(*s == '/')
    8000440e:	fed71ce3          	bne	a4,a3,80004406 <exec+0x276>
    80004412:	bfc5                	j	80004402 <exec+0x272>
  safestrcpy(p->name, last, sizeof(p->name));
    80004414:	4641                	li	a2,16
    80004416:	df843583          	ld	a1,-520(s0)
    8000441a:	158a8513          	addi	a0,s5,344
    8000441e:	ffffc097          	auipc	ra,0xffffc
    80004422:	eac080e7          	jalr	-340(ra) # 800002ca <safestrcpy>
  oldpagetable = p->pagetable;
    80004426:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    8000442a:	057ab823          	sd	s7,80(s5)
  p->sz = sz;
    8000442e:	056ab423          	sd	s6,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004432:	058ab783          	ld	a5,88(s5)
    80004436:	e6843703          	ld	a4,-408(s0)
    8000443a:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    8000443c:	058ab783          	ld	a5,88(s5)
    80004440:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004444:	85ea                	mv	a1,s10
    80004446:	ffffd097          	auipc	ra,0xffffd
    8000444a:	b7c080e7          	jalr	-1156(ra) # 80000fc2 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    8000444e:	0004851b          	sext.w	a0,s1
    80004452:	bbd9                	j	80004228 <exec+0x98>
    80004454:	e1443423          	sd	s4,-504(s0)
    proc_freepagetable(pagetable, sz);
    80004458:	e0843583          	ld	a1,-504(s0)
    8000445c:	855e                	mv	a0,s7
    8000445e:	ffffd097          	auipc	ra,0xffffd
    80004462:	b64080e7          	jalr	-1180(ra) # 80000fc2 <proc_freepagetable>
  if(ip){
    80004466:	da0497e3          	bnez	s1,80004214 <exec+0x84>
  return -1;
    8000446a:	557d                	li	a0,-1
    8000446c:	bb75                	j	80004228 <exec+0x98>
    8000446e:	e1443423          	sd	s4,-504(s0)
    80004472:	b7dd                	j	80004458 <exec+0x2c8>
    80004474:	e1443423          	sd	s4,-504(s0)
    80004478:	b7c5                	j	80004458 <exec+0x2c8>
    8000447a:	e1443423          	sd	s4,-504(s0)
    8000447e:	bfe9                	j	80004458 <exec+0x2c8>
    80004480:	e1443423          	sd	s4,-504(s0)
    80004484:	bfd1                	j	80004458 <exec+0x2c8>
  sz = sz1;
    80004486:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    8000448a:	4481                	li	s1,0
    8000448c:	b7f1                	j	80004458 <exec+0x2c8>
  sz = sz1;
    8000448e:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004492:	4481                	li	s1,0
    80004494:	b7d1                	j	80004458 <exec+0x2c8>
  sz = sz1;
    80004496:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    8000449a:	4481                	li	s1,0
    8000449c:	bf75                	j	80004458 <exec+0x2c8>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    8000449e:	e0843a03          	ld	s4,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800044a2:	2b05                	addiw	s6,s6,1
    800044a4:	0389899b          	addiw	s3,s3,56
    800044a8:	e8845783          	lhu	a5,-376(s0)
    800044ac:	e2fb57e3          	bge	s6,a5,800042da <exec+0x14a>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800044b0:	2981                	sext.w	s3,s3
    800044b2:	03800713          	li	a4,56
    800044b6:	86ce                	mv	a3,s3
    800044b8:	e1840613          	addi	a2,s0,-488
    800044bc:	4581                	li	a1,0
    800044be:	8526                	mv	a0,s1
    800044c0:	fffff097          	auipc	ra,0xfffff
    800044c4:	a14080e7          	jalr	-1516(ra) # 80002ed4 <readi>
    800044c8:	03800793          	li	a5,56
    800044cc:	f8f514e3          	bne	a0,a5,80004454 <exec+0x2c4>
    if(ph.type != ELF_PROG_LOAD)
    800044d0:	e1842783          	lw	a5,-488(s0)
    800044d4:	4705                	li	a4,1
    800044d6:	fce796e3          	bne	a5,a4,800044a2 <exec+0x312>
    if(ph.memsz < ph.filesz)
    800044da:	e4043903          	ld	s2,-448(s0)
    800044de:	e3843783          	ld	a5,-456(s0)
    800044e2:	f8f966e3          	bltu	s2,a5,8000446e <exec+0x2de>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800044e6:	e2843783          	ld	a5,-472(s0)
    800044ea:	993e                	add	s2,s2,a5
    800044ec:	f8f964e3          	bltu	s2,a5,80004474 <exec+0x2e4>
    if(ph.vaddr % PGSIZE != 0)
    800044f0:	df043703          	ld	a4,-528(s0)
    800044f4:	8ff9                	and	a5,a5,a4
    800044f6:	f3d1                	bnez	a5,8000447a <exec+0x2ea>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800044f8:	e1c42503          	lw	a0,-484(s0)
    800044fc:	00000097          	auipc	ra,0x0
    80004500:	c78080e7          	jalr	-904(ra) # 80004174 <flags2perm>
    80004504:	86aa                	mv	a3,a0
    80004506:	864a                	mv	a2,s2
    80004508:	85d2                	mv	a1,s4
    8000450a:	855e                	mv	a0,s7
    8000450c:	ffffc097          	auipc	ra,0xffffc
    80004510:	3c8080e7          	jalr	968(ra) # 800008d4 <uvmalloc>
    80004514:	e0a43423          	sd	a0,-504(s0)
    80004518:	d525                	beqz	a0,80004480 <exec+0x2f0>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000451a:	e2843d03          	ld	s10,-472(s0)
    8000451e:	e2042d83          	lw	s11,-480(s0)
    80004522:	e3842c03          	lw	s8,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004526:	f60c0ce3          	beqz	s8,8000449e <exec+0x30e>
    8000452a:	8a62                	mv	s4,s8
    8000452c:	4901                	li	s2,0
    8000452e:	b369                	j	800042b8 <exec+0x128>

0000000080004530 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004530:	7179                	addi	sp,sp,-48
    80004532:	f406                	sd	ra,40(sp)
    80004534:	f022                	sd	s0,32(sp)
    80004536:	ec26                	sd	s1,24(sp)
    80004538:	e84a                	sd	s2,16(sp)
    8000453a:	1800                	addi	s0,sp,48
    8000453c:	892e                	mv	s2,a1
    8000453e:	84b2                	mv	s1,a2
    int fd;
    struct file *f;

    argint(n, &fd);
    80004540:	fdc40593          	addi	a1,s0,-36
    80004544:	ffffe097          	auipc	ra,0xffffe
    80004548:	b62080e7          	jalr	-1182(ra) # 800020a6 <argint>
    if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0)
    8000454c:	fdc42703          	lw	a4,-36(s0)
    80004550:	47bd                	li	a5,15
    80004552:	02e7eb63          	bltu	a5,a4,80004588 <argfd+0x58>
    80004556:	ffffd097          	auipc	ra,0xffffd
    8000455a:	90c080e7          	jalr	-1780(ra) # 80000e62 <myproc>
    8000455e:	fdc42703          	lw	a4,-36(s0)
    80004562:	01a70793          	addi	a5,a4,26
    80004566:	078e                	slli	a5,a5,0x3
    80004568:	953e                	add	a0,a0,a5
    8000456a:	611c                	ld	a5,0(a0)
    8000456c:	c385                	beqz	a5,8000458c <argfd+0x5c>
        return -1;
    if (pfd)
    8000456e:	00090463          	beqz	s2,80004576 <argfd+0x46>
        *pfd = fd;
    80004572:	00e92023          	sw	a4,0(s2)
    if (pf)
        *pf = f;
    return 0;
    80004576:	4501                	li	a0,0
    if (pf)
    80004578:	c091                	beqz	s1,8000457c <argfd+0x4c>
        *pf = f;
    8000457a:	e09c                	sd	a5,0(s1)
}
    8000457c:	70a2                	ld	ra,40(sp)
    8000457e:	7402                	ld	s0,32(sp)
    80004580:	64e2                	ld	s1,24(sp)
    80004582:	6942                	ld	s2,16(sp)
    80004584:	6145                	addi	sp,sp,48
    80004586:	8082                	ret
        return -1;
    80004588:	557d                	li	a0,-1
    8000458a:	bfcd                	j	8000457c <argfd+0x4c>
    8000458c:	557d                	li	a0,-1
    8000458e:	b7fd                	j	8000457c <argfd+0x4c>

0000000080004590 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004590:	1101                	addi	sp,sp,-32
    80004592:	ec06                	sd	ra,24(sp)
    80004594:	e822                	sd	s0,16(sp)
    80004596:	e426                	sd	s1,8(sp)
    80004598:	1000                	addi	s0,sp,32
    8000459a:	84aa                	mv	s1,a0
    int fd;
    struct proc *p = myproc();
    8000459c:	ffffd097          	auipc	ra,0xffffd
    800045a0:	8c6080e7          	jalr	-1850(ra) # 80000e62 <myproc>
    800045a4:	862a                	mv	a2,a0

    for (fd = 0; fd < NOFILE; fd++)
    800045a6:	0d050793          	addi	a5,a0,208 # fffffffffffff0d0 <end+0xffffffff7ffcb100>
    800045aa:	4501                	li	a0,0
    800045ac:	46c1                	li	a3,16
    {
        if (p->ofile[fd] == 0)
    800045ae:	6398                	ld	a4,0(a5)
    800045b0:	cb19                	beqz	a4,800045c6 <fdalloc+0x36>
    for (fd = 0; fd < NOFILE; fd++)
    800045b2:	2505                	addiw	a0,a0,1
    800045b4:	07a1                	addi	a5,a5,8
    800045b6:	fed51ce3          	bne	a0,a3,800045ae <fdalloc+0x1e>
        {
            p->ofile[fd] = f;
            return fd;
        }
    }
    return -1;
    800045ba:	557d                	li	a0,-1
}
    800045bc:	60e2                	ld	ra,24(sp)
    800045be:	6442                	ld	s0,16(sp)
    800045c0:	64a2                	ld	s1,8(sp)
    800045c2:	6105                	addi	sp,sp,32
    800045c4:	8082                	ret
            p->ofile[fd] = f;
    800045c6:	01a50793          	addi	a5,a0,26
    800045ca:	078e                	slli	a5,a5,0x3
    800045cc:	963e                	add	a2,a2,a5
    800045ce:	e204                	sd	s1,0(a2)
            return fd;
    800045d0:	b7f5                	j	800045bc <fdalloc+0x2c>

00000000800045d2 <create>:
    }
}

static struct inode *
create(char *path, short type, short major, short minor)
{
    800045d2:	715d                	addi	sp,sp,-80
    800045d4:	e486                	sd	ra,72(sp)
    800045d6:	e0a2                	sd	s0,64(sp)
    800045d8:	fc26                	sd	s1,56(sp)
    800045da:	f84a                	sd	s2,48(sp)
    800045dc:	f44e                	sd	s3,40(sp)
    800045de:	f052                	sd	s4,32(sp)
    800045e0:	ec56                	sd	s5,24(sp)
    800045e2:	e85a                	sd	s6,16(sp)
    800045e4:	0880                	addi	s0,sp,80
    800045e6:	8b2e                	mv	s6,a1
    800045e8:	89b2                	mv	s3,a2
    800045ea:	8936                	mv	s2,a3
    struct inode *ip, *dp;
    char name[DIRSIZ];

    if ((dp = nameiparent(path, name)) == 0)
    800045ec:	fb040593          	addi	a1,s0,-80
    800045f0:	fffff097          	auipc	ra,0xfffff
    800045f4:	df4080e7          	jalr	-524(ra) # 800033e4 <nameiparent>
    800045f8:	84aa                	mv	s1,a0
    800045fa:	16050063          	beqz	a0,8000475a <create+0x188>
        return 0;

    ilock(dp);
    800045fe:	ffffe097          	auipc	ra,0xffffe
    80004602:	622080e7          	jalr	1570(ra) # 80002c20 <ilock>

    if ((ip = dirlookup(dp, name, 0)) != 0)
    80004606:	4601                	li	a2,0
    80004608:	fb040593          	addi	a1,s0,-80
    8000460c:	8526                	mv	a0,s1
    8000460e:	fffff097          	auipc	ra,0xfffff
    80004612:	af6080e7          	jalr	-1290(ra) # 80003104 <dirlookup>
    80004616:	8aaa                	mv	s5,a0
    80004618:	c931                	beqz	a0,8000466c <create+0x9a>
    {
        iunlockput(dp);
    8000461a:	8526                	mv	a0,s1
    8000461c:	fffff097          	auipc	ra,0xfffff
    80004620:	866080e7          	jalr	-1946(ra) # 80002e82 <iunlockput>
        ilock(ip);
    80004624:	8556                	mv	a0,s5
    80004626:	ffffe097          	auipc	ra,0xffffe
    8000462a:	5fa080e7          	jalr	1530(ra) # 80002c20 <ilock>
        if (type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000462e:	000b059b          	sext.w	a1,s6
    80004632:	4789                	li	a5,2
    80004634:	02f59563          	bne	a1,a5,8000465e <create+0x8c>
    80004638:	044ad783          	lhu	a5,68(s5)
    8000463c:	37f9                	addiw	a5,a5,-2
    8000463e:	17c2                	slli	a5,a5,0x30
    80004640:	93c1                	srli	a5,a5,0x30
    80004642:	4705                	li	a4,1
    80004644:	00f76d63          	bltu	a4,a5,8000465e <create+0x8c>
    ip->nlink = 0;
    iupdate(ip);
    iunlockput(ip);
    iunlockput(dp);
    return 0;
}
    80004648:	8556                	mv	a0,s5
    8000464a:	60a6                	ld	ra,72(sp)
    8000464c:	6406                	ld	s0,64(sp)
    8000464e:	74e2                	ld	s1,56(sp)
    80004650:	7942                	ld	s2,48(sp)
    80004652:	79a2                	ld	s3,40(sp)
    80004654:	7a02                	ld	s4,32(sp)
    80004656:	6ae2                	ld	s5,24(sp)
    80004658:	6b42                	ld	s6,16(sp)
    8000465a:	6161                	addi	sp,sp,80
    8000465c:	8082                	ret
        iunlockput(ip);
    8000465e:	8556                	mv	a0,s5
    80004660:	fffff097          	auipc	ra,0xfffff
    80004664:	822080e7          	jalr	-2014(ra) # 80002e82 <iunlockput>
        return 0;
    80004668:	4a81                	li	s5,0
    8000466a:	bff9                	j	80004648 <create+0x76>
    if ((ip = ialloc(dp->dev, type)) == 0)
    8000466c:	85da                	mv	a1,s6
    8000466e:	4088                	lw	a0,0(s1)
    80004670:	ffffe097          	auipc	ra,0xffffe
    80004674:	414080e7          	jalr	1044(ra) # 80002a84 <ialloc>
    80004678:	8a2a                	mv	s4,a0
    8000467a:	c921                	beqz	a0,800046ca <create+0xf8>
    ilock(ip);
    8000467c:	ffffe097          	auipc	ra,0xffffe
    80004680:	5a4080e7          	jalr	1444(ra) # 80002c20 <ilock>
    ip->major = major;
    80004684:	053a1323          	sh	s3,70(s4)
    ip->minor = minor;
    80004688:	052a1423          	sh	s2,72(s4)
    ip->nlink = 1;
    8000468c:	4785                	li	a5,1
    8000468e:	04fa1523          	sh	a5,74(s4)
    iupdate(ip);
    80004692:	8552                	mv	a0,s4
    80004694:	ffffe097          	auipc	ra,0xffffe
    80004698:	4c2080e7          	jalr	1218(ra) # 80002b56 <iupdate>
    if (type == T_DIR)
    8000469c:	000b059b          	sext.w	a1,s6
    800046a0:	4785                	li	a5,1
    800046a2:	02f58b63          	beq	a1,a5,800046d8 <create+0x106>
    if (dirlink(dp, name, ip->inum) < 0)
    800046a6:	004a2603          	lw	a2,4(s4)
    800046aa:	fb040593          	addi	a1,s0,-80
    800046ae:	8526                	mv	a0,s1
    800046b0:	fffff097          	auipc	ra,0xfffff
    800046b4:	c64080e7          	jalr	-924(ra) # 80003314 <dirlink>
    800046b8:	06054f63          	bltz	a0,80004736 <create+0x164>
    iunlockput(dp);
    800046bc:	8526                	mv	a0,s1
    800046be:	ffffe097          	auipc	ra,0xffffe
    800046c2:	7c4080e7          	jalr	1988(ra) # 80002e82 <iunlockput>
    return ip;
    800046c6:	8ad2                	mv	s5,s4
    800046c8:	b741                	j	80004648 <create+0x76>
        iunlockput(dp);
    800046ca:	8526                	mv	a0,s1
    800046cc:	ffffe097          	auipc	ra,0xffffe
    800046d0:	7b6080e7          	jalr	1974(ra) # 80002e82 <iunlockput>
        return 0;
    800046d4:	8ad2                	mv	s5,s4
    800046d6:	bf8d                	j	80004648 <create+0x76>
        if (dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800046d8:	004a2603          	lw	a2,4(s4)
    800046dc:	00004597          	auipc	a1,0x4
    800046e0:	03458593          	addi	a1,a1,52 # 80008710 <syscalls+0x2b8>
    800046e4:	8552                	mv	a0,s4
    800046e6:	fffff097          	auipc	ra,0xfffff
    800046ea:	c2e080e7          	jalr	-978(ra) # 80003314 <dirlink>
    800046ee:	04054463          	bltz	a0,80004736 <create+0x164>
    800046f2:	40d0                	lw	a2,4(s1)
    800046f4:	00004597          	auipc	a1,0x4
    800046f8:	02458593          	addi	a1,a1,36 # 80008718 <syscalls+0x2c0>
    800046fc:	8552                	mv	a0,s4
    800046fe:	fffff097          	auipc	ra,0xfffff
    80004702:	c16080e7          	jalr	-1002(ra) # 80003314 <dirlink>
    80004706:	02054863          	bltz	a0,80004736 <create+0x164>
    if (dirlink(dp, name, ip->inum) < 0)
    8000470a:	004a2603          	lw	a2,4(s4)
    8000470e:	fb040593          	addi	a1,s0,-80
    80004712:	8526                	mv	a0,s1
    80004714:	fffff097          	auipc	ra,0xfffff
    80004718:	c00080e7          	jalr	-1024(ra) # 80003314 <dirlink>
    8000471c:	00054d63          	bltz	a0,80004736 <create+0x164>
        dp->nlink++; // for ".."
    80004720:	04a4d783          	lhu	a5,74(s1)
    80004724:	2785                	addiw	a5,a5,1
    80004726:	04f49523          	sh	a5,74(s1)
        iupdate(dp);
    8000472a:	8526                	mv	a0,s1
    8000472c:	ffffe097          	auipc	ra,0xffffe
    80004730:	42a080e7          	jalr	1066(ra) # 80002b56 <iupdate>
    80004734:	b761                	j	800046bc <create+0xea>
    ip->nlink = 0;
    80004736:	040a1523          	sh	zero,74(s4)
    iupdate(ip);
    8000473a:	8552                	mv	a0,s4
    8000473c:	ffffe097          	auipc	ra,0xffffe
    80004740:	41a080e7          	jalr	1050(ra) # 80002b56 <iupdate>
    iunlockput(ip);
    80004744:	8552                	mv	a0,s4
    80004746:	ffffe097          	auipc	ra,0xffffe
    8000474a:	73c080e7          	jalr	1852(ra) # 80002e82 <iunlockput>
    iunlockput(dp);
    8000474e:	8526                	mv	a0,s1
    80004750:	ffffe097          	auipc	ra,0xffffe
    80004754:	732080e7          	jalr	1842(ra) # 80002e82 <iunlockput>
    return 0;
    80004758:	bdc5                	j	80004648 <create+0x76>
        return 0;
    8000475a:	8aaa                	mv	s5,a0
    8000475c:	b5f5                	j	80004648 <create+0x76>

000000008000475e <sys_dup>:
{
    8000475e:	7179                	addi	sp,sp,-48
    80004760:	f406                	sd	ra,40(sp)
    80004762:	f022                	sd	s0,32(sp)
    80004764:	ec26                	sd	s1,24(sp)
    80004766:	1800                	addi	s0,sp,48
    if (argfd(0, 0, &f) < 0)
    80004768:	fd840613          	addi	a2,s0,-40
    8000476c:	4581                	li	a1,0
    8000476e:	4501                	li	a0,0
    80004770:	00000097          	auipc	ra,0x0
    80004774:	dc0080e7          	jalr	-576(ra) # 80004530 <argfd>
        return -1;
    80004778:	57fd                	li	a5,-1
    if (argfd(0, 0, &f) < 0)
    8000477a:	02054363          	bltz	a0,800047a0 <sys_dup+0x42>
    if ((fd = fdalloc(f)) < 0)
    8000477e:	fd843503          	ld	a0,-40(s0)
    80004782:	00000097          	auipc	ra,0x0
    80004786:	e0e080e7          	jalr	-498(ra) # 80004590 <fdalloc>
    8000478a:	84aa                	mv	s1,a0
        return -1;
    8000478c:	57fd                	li	a5,-1
    if ((fd = fdalloc(f)) < 0)
    8000478e:	00054963          	bltz	a0,800047a0 <sys_dup+0x42>
    filedup(f);
    80004792:	fd843503          	ld	a0,-40(s0)
    80004796:	fffff097          	auipc	ra,0xfffff
    8000479a:	2c6080e7          	jalr	710(ra) # 80003a5c <filedup>
    return fd;
    8000479e:	87a6                	mv	a5,s1
}
    800047a0:	853e                	mv	a0,a5
    800047a2:	70a2                	ld	ra,40(sp)
    800047a4:	7402                	ld	s0,32(sp)
    800047a6:	64e2                	ld	s1,24(sp)
    800047a8:	6145                	addi	sp,sp,48
    800047aa:	8082                	ret

00000000800047ac <sys_read>:
{
    800047ac:	7179                	addi	sp,sp,-48
    800047ae:	f406                	sd	ra,40(sp)
    800047b0:	f022                	sd	s0,32(sp)
    800047b2:	1800                	addi	s0,sp,48
    argaddr(1, &p);
    800047b4:	fd840593          	addi	a1,s0,-40
    800047b8:	4505                	li	a0,1
    800047ba:	ffffe097          	auipc	ra,0xffffe
    800047be:	90c080e7          	jalr	-1780(ra) # 800020c6 <argaddr>
    argint(2, &n);
    800047c2:	fe440593          	addi	a1,s0,-28
    800047c6:	4509                	li	a0,2
    800047c8:	ffffe097          	auipc	ra,0xffffe
    800047cc:	8de080e7          	jalr	-1826(ra) # 800020a6 <argint>
    if (argfd(0, 0, &f) < 0)
    800047d0:	fe840613          	addi	a2,s0,-24
    800047d4:	4581                	li	a1,0
    800047d6:	4501                	li	a0,0
    800047d8:	00000097          	auipc	ra,0x0
    800047dc:	d58080e7          	jalr	-680(ra) # 80004530 <argfd>
    800047e0:	87aa                	mv	a5,a0
        return -1;
    800047e2:	557d                	li	a0,-1
    if (argfd(0, 0, &f) < 0)
    800047e4:	0007cc63          	bltz	a5,800047fc <sys_read+0x50>
    return fileread(f, p, n);
    800047e8:	fe442603          	lw	a2,-28(s0)
    800047ec:	fd843583          	ld	a1,-40(s0)
    800047f0:	fe843503          	ld	a0,-24(s0)
    800047f4:	fffff097          	auipc	ra,0xfffff
    800047f8:	44e080e7          	jalr	1102(ra) # 80003c42 <fileread>
}
    800047fc:	70a2                	ld	ra,40(sp)
    800047fe:	7402                	ld	s0,32(sp)
    80004800:	6145                	addi	sp,sp,48
    80004802:	8082                	ret

0000000080004804 <sys_write>:
{
    80004804:	7179                	addi	sp,sp,-48
    80004806:	f406                	sd	ra,40(sp)
    80004808:	f022                	sd	s0,32(sp)
    8000480a:	1800                	addi	s0,sp,48
    argaddr(1, &p);
    8000480c:	fd840593          	addi	a1,s0,-40
    80004810:	4505                	li	a0,1
    80004812:	ffffe097          	auipc	ra,0xffffe
    80004816:	8b4080e7          	jalr	-1868(ra) # 800020c6 <argaddr>
    argint(2, &n);
    8000481a:	fe440593          	addi	a1,s0,-28
    8000481e:	4509                	li	a0,2
    80004820:	ffffe097          	auipc	ra,0xffffe
    80004824:	886080e7          	jalr	-1914(ra) # 800020a6 <argint>
    if (argfd(0, 0, &f) < 0)
    80004828:	fe840613          	addi	a2,s0,-24
    8000482c:	4581                	li	a1,0
    8000482e:	4501                	li	a0,0
    80004830:	00000097          	auipc	ra,0x0
    80004834:	d00080e7          	jalr	-768(ra) # 80004530 <argfd>
    80004838:	87aa                	mv	a5,a0
        return -1;
    8000483a:	557d                	li	a0,-1
    if (argfd(0, 0, &f) < 0)
    8000483c:	0007cc63          	bltz	a5,80004854 <sys_write+0x50>
    return filewrite(f, p, n);
    80004840:	fe442603          	lw	a2,-28(s0)
    80004844:	fd843583          	ld	a1,-40(s0)
    80004848:	fe843503          	ld	a0,-24(s0)
    8000484c:	fffff097          	auipc	ra,0xfffff
    80004850:	4b8080e7          	jalr	1208(ra) # 80003d04 <filewrite>
}
    80004854:	70a2                	ld	ra,40(sp)
    80004856:	7402                	ld	s0,32(sp)
    80004858:	6145                	addi	sp,sp,48
    8000485a:	8082                	ret

000000008000485c <sys_close>:
{
    8000485c:	1101                	addi	sp,sp,-32
    8000485e:	ec06                	sd	ra,24(sp)
    80004860:	e822                	sd	s0,16(sp)
    80004862:	1000                	addi	s0,sp,32
    if (argfd(0, &fd, &f) < 0)
    80004864:	fe040613          	addi	a2,s0,-32
    80004868:	fec40593          	addi	a1,s0,-20
    8000486c:	4501                	li	a0,0
    8000486e:	00000097          	auipc	ra,0x0
    80004872:	cc2080e7          	jalr	-830(ra) # 80004530 <argfd>
        return -1;
    80004876:	57fd                	li	a5,-1
    if (argfd(0, &fd, &f) < 0)
    80004878:	02054463          	bltz	a0,800048a0 <sys_close+0x44>
    myproc()->ofile[fd] = 0;
    8000487c:	ffffc097          	auipc	ra,0xffffc
    80004880:	5e6080e7          	jalr	1510(ra) # 80000e62 <myproc>
    80004884:	fec42783          	lw	a5,-20(s0)
    80004888:	07e9                	addi	a5,a5,26
    8000488a:	078e                	slli	a5,a5,0x3
    8000488c:	97aa                	add	a5,a5,a0
    8000488e:	0007b023          	sd	zero,0(a5)
    fileclose(f);
    80004892:	fe043503          	ld	a0,-32(s0)
    80004896:	fffff097          	auipc	ra,0xfffff
    8000489a:	218080e7          	jalr	536(ra) # 80003aae <fileclose>
    return 0;
    8000489e:	4781                	li	a5,0
}
    800048a0:	853e                	mv	a0,a5
    800048a2:	60e2                	ld	ra,24(sp)
    800048a4:	6442                	ld	s0,16(sp)
    800048a6:	6105                	addi	sp,sp,32
    800048a8:	8082                	ret

00000000800048aa <sys_fstat>:
{
    800048aa:	1101                	addi	sp,sp,-32
    800048ac:	ec06                	sd	ra,24(sp)
    800048ae:	e822                	sd	s0,16(sp)
    800048b0:	1000                	addi	s0,sp,32
    argaddr(1, &st);
    800048b2:	fe040593          	addi	a1,s0,-32
    800048b6:	4505                	li	a0,1
    800048b8:	ffffe097          	auipc	ra,0xffffe
    800048bc:	80e080e7          	jalr	-2034(ra) # 800020c6 <argaddr>
    if (argfd(0, 0, &f) < 0)
    800048c0:	fe840613          	addi	a2,s0,-24
    800048c4:	4581                	li	a1,0
    800048c6:	4501                	li	a0,0
    800048c8:	00000097          	auipc	ra,0x0
    800048cc:	c68080e7          	jalr	-920(ra) # 80004530 <argfd>
    800048d0:	87aa                	mv	a5,a0
        return -1;
    800048d2:	557d                	li	a0,-1
    if (argfd(0, 0, &f) < 0)
    800048d4:	0007ca63          	bltz	a5,800048e8 <sys_fstat+0x3e>
    return filestat(f, st);
    800048d8:	fe043583          	ld	a1,-32(s0)
    800048dc:	fe843503          	ld	a0,-24(s0)
    800048e0:	fffff097          	auipc	ra,0xfffff
    800048e4:	296080e7          	jalr	662(ra) # 80003b76 <filestat>
}
    800048e8:	60e2                	ld	ra,24(sp)
    800048ea:	6442                	ld	s0,16(sp)
    800048ec:	6105                	addi	sp,sp,32
    800048ee:	8082                	ret

00000000800048f0 <sys_link>:
{
    800048f0:	7169                	addi	sp,sp,-304
    800048f2:	f606                	sd	ra,296(sp)
    800048f4:	f222                	sd	s0,288(sp)
    800048f6:	ee26                	sd	s1,280(sp)
    800048f8:	ea4a                	sd	s2,272(sp)
    800048fa:	1a00                	addi	s0,sp,304
    if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800048fc:	08000613          	li	a2,128
    80004900:	ed040593          	addi	a1,s0,-304
    80004904:	4501                	li	a0,0
    80004906:	ffffd097          	auipc	ra,0xffffd
    8000490a:	7e0080e7          	jalr	2016(ra) # 800020e6 <argstr>
        return -1;
    8000490e:	57fd                	li	a5,-1
    if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004910:	10054e63          	bltz	a0,80004a2c <sys_link+0x13c>
    80004914:	08000613          	li	a2,128
    80004918:	f5040593          	addi	a1,s0,-176
    8000491c:	4505                	li	a0,1
    8000491e:	ffffd097          	auipc	ra,0xffffd
    80004922:	7c8080e7          	jalr	1992(ra) # 800020e6 <argstr>
        return -1;
    80004926:	57fd                	li	a5,-1
    if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004928:	10054263          	bltz	a0,80004a2c <sys_link+0x13c>
    begin_op();
    8000492c:	fffff097          	auipc	ra,0xfffff
    80004930:	cb6080e7          	jalr	-842(ra) # 800035e2 <begin_op>
    if ((ip = namei(old)) == 0)
    80004934:	ed040513          	addi	a0,s0,-304
    80004938:	fffff097          	auipc	ra,0xfffff
    8000493c:	a8e080e7          	jalr	-1394(ra) # 800033c6 <namei>
    80004940:	84aa                	mv	s1,a0
    80004942:	c551                	beqz	a0,800049ce <sys_link+0xde>
    ilock(ip);
    80004944:	ffffe097          	auipc	ra,0xffffe
    80004948:	2dc080e7          	jalr	732(ra) # 80002c20 <ilock>
    if (ip->type == T_DIR)
    8000494c:	04449703          	lh	a4,68(s1)
    80004950:	4785                	li	a5,1
    80004952:	08f70463          	beq	a4,a5,800049da <sys_link+0xea>
    ip->nlink++;
    80004956:	04a4d783          	lhu	a5,74(s1)
    8000495a:	2785                	addiw	a5,a5,1
    8000495c:	04f49523          	sh	a5,74(s1)
    iupdate(ip);
    80004960:	8526                	mv	a0,s1
    80004962:	ffffe097          	auipc	ra,0xffffe
    80004966:	1f4080e7          	jalr	500(ra) # 80002b56 <iupdate>
    iunlock(ip);
    8000496a:	8526                	mv	a0,s1
    8000496c:	ffffe097          	auipc	ra,0xffffe
    80004970:	376080e7          	jalr	886(ra) # 80002ce2 <iunlock>
    if ((dp = nameiparent(new, name)) == 0)
    80004974:	fd040593          	addi	a1,s0,-48
    80004978:	f5040513          	addi	a0,s0,-176
    8000497c:	fffff097          	auipc	ra,0xfffff
    80004980:	a68080e7          	jalr	-1432(ra) # 800033e4 <nameiparent>
    80004984:	892a                	mv	s2,a0
    80004986:	c935                	beqz	a0,800049fa <sys_link+0x10a>
    ilock(dp);
    80004988:	ffffe097          	auipc	ra,0xffffe
    8000498c:	298080e7          	jalr	664(ra) # 80002c20 <ilock>
    if (dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0)
    80004990:	00092703          	lw	a4,0(s2)
    80004994:	409c                	lw	a5,0(s1)
    80004996:	04f71d63          	bne	a4,a5,800049f0 <sys_link+0x100>
    8000499a:	40d0                	lw	a2,4(s1)
    8000499c:	fd040593          	addi	a1,s0,-48
    800049a0:	854a                	mv	a0,s2
    800049a2:	fffff097          	auipc	ra,0xfffff
    800049a6:	972080e7          	jalr	-1678(ra) # 80003314 <dirlink>
    800049aa:	04054363          	bltz	a0,800049f0 <sys_link+0x100>
    iunlockput(dp);
    800049ae:	854a                	mv	a0,s2
    800049b0:	ffffe097          	auipc	ra,0xffffe
    800049b4:	4d2080e7          	jalr	1234(ra) # 80002e82 <iunlockput>
    iput(ip);
    800049b8:	8526                	mv	a0,s1
    800049ba:	ffffe097          	auipc	ra,0xffffe
    800049be:	420080e7          	jalr	1056(ra) # 80002dda <iput>
    end_op();
    800049c2:	fffff097          	auipc	ra,0xfffff
    800049c6:	ca0080e7          	jalr	-864(ra) # 80003662 <end_op>
    return 0;
    800049ca:	4781                	li	a5,0
    800049cc:	a085                	j	80004a2c <sys_link+0x13c>
        end_op();
    800049ce:	fffff097          	auipc	ra,0xfffff
    800049d2:	c94080e7          	jalr	-876(ra) # 80003662 <end_op>
        return -1;
    800049d6:	57fd                	li	a5,-1
    800049d8:	a891                	j	80004a2c <sys_link+0x13c>
        iunlockput(ip);
    800049da:	8526                	mv	a0,s1
    800049dc:	ffffe097          	auipc	ra,0xffffe
    800049e0:	4a6080e7          	jalr	1190(ra) # 80002e82 <iunlockput>
        end_op();
    800049e4:	fffff097          	auipc	ra,0xfffff
    800049e8:	c7e080e7          	jalr	-898(ra) # 80003662 <end_op>
        return -1;
    800049ec:	57fd                	li	a5,-1
    800049ee:	a83d                	j	80004a2c <sys_link+0x13c>
        iunlockput(dp);
    800049f0:	854a                	mv	a0,s2
    800049f2:	ffffe097          	auipc	ra,0xffffe
    800049f6:	490080e7          	jalr	1168(ra) # 80002e82 <iunlockput>
    ilock(ip);
    800049fa:	8526                	mv	a0,s1
    800049fc:	ffffe097          	auipc	ra,0xffffe
    80004a00:	224080e7          	jalr	548(ra) # 80002c20 <ilock>
    ip->nlink--;
    80004a04:	04a4d783          	lhu	a5,74(s1)
    80004a08:	37fd                	addiw	a5,a5,-1
    80004a0a:	04f49523          	sh	a5,74(s1)
    iupdate(ip);
    80004a0e:	8526                	mv	a0,s1
    80004a10:	ffffe097          	auipc	ra,0xffffe
    80004a14:	146080e7          	jalr	326(ra) # 80002b56 <iupdate>
    iunlockput(ip);
    80004a18:	8526                	mv	a0,s1
    80004a1a:	ffffe097          	auipc	ra,0xffffe
    80004a1e:	468080e7          	jalr	1128(ra) # 80002e82 <iunlockput>
    end_op();
    80004a22:	fffff097          	auipc	ra,0xfffff
    80004a26:	c40080e7          	jalr	-960(ra) # 80003662 <end_op>
    return -1;
    80004a2a:	57fd                	li	a5,-1
}
    80004a2c:	853e                	mv	a0,a5
    80004a2e:	70b2                	ld	ra,296(sp)
    80004a30:	7412                	ld	s0,288(sp)
    80004a32:	64f2                	ld	s1,280(sp)
    80004a34:	6952                	ld	s2,272(sp)
    80004a36:	6155                	addi	sp,sp,304
    80004a38:	8082                	ret

0000000080004a3a <sys_unlink>:
{
    80004a3a:	7151                	addi	sp,sp,-240
    80004a3c:	f586                	sd	ra,232(sp)
    80004a3e:	f1a2                	sd	s0,224(sp)
    80004a40:	eda6                	sd	s1,216(sp)
    80004a42:	e9ca                	sd	s2,208(sp)
    80004a44:	e5ce                	sd	s3,200(sp)
    80004a46:	1980                	addi	s0,sp,240
    if (argstr(0, path, MAXPATH) < 0)
    80004a48:	08000613          	li	a2,128
    80004a4c:	f3040593          	addi	a1,s0,-208
    80004a50:	4501                	li	a0,0
    80004a52:	ffffd097          	auipc	ra,0xffffd
    80004a56:	694080e7          	jalr	1684(ra) # 800020e6 <argstr>
    80004a5a:	18054163          	bltz	a0,80004bdc <sys_unlink+0x1a2>
    begin_op();
    80004a5e:	fffff097          	auipc	ra,0xfffff
    80004a62:	b84080e7          	jalr	-1148(ra) # 800035e2 <begin_op>
    if ((dp = nameiparent(path, name)) == 0)
    80004a66:	fb040593          	addi	a1,s0,-80
    80004a6a:	f3040513          	addi	a0,s0,-208
    80004a6e:	fffff097          	auipc	ra,0xfffff
    80004a72:	976080e7          	jalr	-1674(ra) # 800033e4 <nameiparent>
    80004a76:	84aa                	mv	s1,a0
    80004a78:	c979                	beqz	a0,80004b4e <sys_unlink+0x114>
    ilock(dp);
    80004a7a:	ffffe097          	auipc	ra,0xffffe
    80004a7e:	1a6080e7          	jalr	422(ra) # 80002c20 <ilock>
    if (namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004a82:	00004597          	auipc	a1,0x4
    80004a86:	c8e58593          	addi	a1,a1,-882 # 80008710 <syscalls+0x2b8>
    80004a8a:	fb040513          	addi	a0,s0,-80
    80004a8e:	ffffe097          	auipc	ra,0xffffe
    80004a92:	65c080e7          	jalr	1628(ra) # 800030ea <namecmp>
    80004a96:	14050a63          	beqz	a0,80004bea <sys_unlink+0x1b0>
    80004a9a:	00004597          	auipc	a1,0x4
    80004a9e:	c7e58593          	addi	a1,a1,-898 # 80008718 <syscalls+0x2c0>
    80004aa2:	fb040513          	addi	a0,s0,-80
    80004aa6:	ffffe097          	auipc	ra,0xffffe
    80004aaa:	644080e7          	jalr	1604(ra) # 800030ea <namecmp>
    80004aae:	12050e63          	beqz	a0,80004bea <sys_unlink+0x1b0>
    if ((ip = dirlookup(dp, name, &off)) == 0)
    80004ab2:	f2c40613          	addi	a2,s0,-212
    80004ab6:	fb040593          	addi	a1,s0,-80
    80004aba:	8526                	mv	a0,s1
    80004abc:	ffffe097          	auipc	ra,0xffffe
    80004ac0:	648080e7          	jalr	1608(ra) # 80003104 <dirlookup>
    80004ac4:	892a                	mv	s2,a0
    80004ac6:	12050263          	beqz	a0,80004bea <sys_unlink+0x1b0>
    ilock(ip);
    80004aca:	ffffe097          	auipc	ra,0xffffe
    80004ace:	156080e7          	jalr	342(ra) # 80002c20 <ilock>
    if (ip->nlink < 1)
    80004ad2:	04a91783          	lh	a5,74(s2)
    80004ad6:	08f05263          	blez	a5,80004b5a <sys_unlink+0x120>
    if (ip->type == T_DIR && !isdirempty(ip))
    80004ada:	04491703          	lh	a4,68(s2)
    80004ade:	4785                	li	a5,1
    80004ae0:	08f70563          	beq	a4,a5,80004b6a <sys_unlink+0x130>
    memset(&de, 0, sizeof(de));
    80004ae4:	4641                	li	a2,16
    80004ae6:	4581                	li	a1,0
    80004ae8:	fc040513          	addi	a0,s0,-64
    80004aec:	ffffb097          	auipc	ra,0xffffb
    80004af0:	68c080e7          	jalr	1676(ra) # 80000178 <memset>
    if (writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004af4:	4741                	li	a4,16
    80004af6:	f2c42683          	lw	a3,-212(s0)
    80004afa:	fc040613          	addi	a2,s0,-64
    80004afe:	4581                	li	a1,0
    80004b00:	8526                	mv	a0,s1
    80004b02:	ffffe097          	auipc	ra,0xffffe
    80004b06:	4ca080e7          	jalr	1226(ra) # 80002fcc <writei>
    80004b0a:	47c1                	li	a5,16
    80004b0c:	0af51563          	bne	a0,a5,80004bb6 <sys_unlink+0x17c>
    if (ip->type == T_DIR)
    80004b10:	04491703          	lh	a4,68(s2)
    80004b14:	4785                	li	a5,1
    80004b16:	0af70863          	beq	a4,a5,80004bc6 <sys_unlink+0x18c>
    iunlockput(dp);
    80004b1a:	8526                	mv	a0,s1
    80004b1c:	ffffe097          	auipc	ra,0xffffe
    80004b20:	366080e7          	jalr	870(ra) # 80002e82 <iunlockput>
    ip->nlink--;
    80004b24:	04a95783          	lhu	a5,74(s2)
    80004b28:	37fd                	addiw	a5,a5,-1
    80004b2a:	04f91523          	sh	a5,74(s2)
    iupdate(ip);
    80004b2e:	854a                	mv	a0,s2
    80004b30:	ffffe097          	auipc	ra,0xffffe
    80004b34:	026080e7          	jalr	38(ra) # 80002b56 <iupdate>
    iunlockput(ip);
    80004b38:	854a                	mv	a0,s2
    80004b3a:	ffffe097          	auipc	ra,0xffffe
    80004b3e:	348080e7          	jalr	840(ra) # 80002e82 <iunlockput>
    end_op();
    80004b42:	fffff097          	auipc	ra,0xfffff
    80004b46:	b20080e7          	jalr	-1248(ra) # 80003662 <end_op>
    return 0;
    80004b4a:	4501                	li	a0,0
    80004b4c:	a84d                	j	80004bfe <sys_unlink+0x1c4>
        end_op();
    80004b4e:	fffff097          	auipc	ra,0xfffff
    80004b52:	b14080e7          	jalr	-1260(ra) # 80003662 <end_op>
        return -1;
    80004b56:	557d                	li	a0,-1
    80004b58:	a05d                	j	80004bfe <sys_unlink+0x1c4>
        panic("unlink: nlink < 1");
    80004b5a:	00004517          	auipc	a0,0x4
    80004b5e:	bc650513          	addi	a0,a0,-1082 # 80008720 <syscalls+0x2c8>
    80004b62:	00001097          	auipc	ra,0x1
    80004b66:	520080e7          	jalr	1312(ra) # 80006082 <panic>
    for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de))
    80004b6a:	04c92703          	lw	a4,76(s2)
    80004b6e:	02000793          	li	a5,32
    80004b72:	f6e7f9e3          	bgeu	a5,a4,80004ae4 <sys_unlink+0xaa>
    80004b76:	02000993          	li	s3,32
        if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004b7a:	4741                	li	a4,16
    80004b7c:	86ce                	mv	a3,s3
    80004b7e:	f1840613          	addi	a2,s0,-232
    80004b82:	4581                	li	a1,0
    80004b84:	854a                	mv	a0,s2
    80004b86:	ffffe097          	auipc	ra,0xffffe
    80004b8a:	34e080e7          	jalr	846(ra) # 80002ed4 <readi>
    80004b8e:	47c1                	li	a5,16
    80004b90:	00f51b63          	bne	a0,a5,80004ba6 <sys_unlink+0x16c>
        if (de.inum != 0)
    80004b94:	f1845783          	lhu	a5,-232(s0)
    80004b98:	e7a1                	bnez	a5,80004be0 <sys_unlink+0x1a6>
    for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de))
    80004b9a:	29c1                	addiw	s3,s3,16
    80004b9c:	04c92783          	lw	a5,76(s2)
    80004ba0:	fcf9ede3          	bltu	s3,a5,80004b7a <sys_unlink+0x140>
    80004ba4:	b781                	j	80004ae4 <sys_unlink+0xaa>
            panic("isdirempty: readi");
    80004ba6:	00004517          	auipc	a0,0x4
    80004baa:	b9250513          	addi	a0,a0,-1134 # 80008738 <syscalls+0x2e0>
    80004bae:	00001097          	auipc	ra,0x1
    80004bb2:	4d4080e7          	jalr	1236(ra) # 80006082 <panic>
        panic("unlink: writei");
    80004bb6:	00004517          	auipc	a0,0x4
    80004bba:	b9a50513          	addi	a0,a0,-1126 # 80008750 <syscalls+0x2f8>
    80004bbe:	00001097          	auipc	ra,0x1
    80004bc2:	4c4080e7          	jalr	1220(ra) # 80006082 <panic>
        dp->nlink--;
    80004bc6:	04a4d783          	lhu	a5,74(s1)
    80004bca:	37fd                	addiw	a5,a5,-1
    80004bcc:	04f49523          	sh	a5,74(s1)
        iupdate(dp);
    80004bd0:	8526                	mv	a0,s1
    80004bd2:	ffffe097          	auipc	ra,0xffffe
    80004bd6:	f84080e7          	jalr	-124(ra) # 80002b56 <iupdate>
    80004bda:	b781                	j	80004b1a <sys_unlink+0xe0>
        return -1;
    80004bdc:	557d                	li	a0,-1
    80004bde:	a005                	j	80004bfe <sys_unlink+0x1c4>
        iunlockput(ip);
    80004be0:	854a                	mv	a0,s2
    80004be2:	ffffe097          	auipc	ra,0xffffe
    80004be6:	2a0080e7          	jalr	672(ra) # 80002e82 <iunlockput>
    iunlockput(dp);
    80004bea:	8526                	mv	a0,s1
    80004bec:	ffffe097          	auipc	ra,0xffffe
    80004bf0:	296080e7          	jalr	662(ra) # 80002e82 <iunlockput>
    end_op();
    80004bf4:	fffff097          	auipc	ra,0xfffff
    80004bf8:	a6e080e7          	jalr	-1426(ra) # 80003662 <end_op>
    return -1;
    80004bfc:	557d                	li	a0,-1
}
    80004bfe:	70ae                	ld	ra,232(sp)
    80004c00:	740e                	ld	s0,224(sp)
    80004c02:	64ee                	ld	s1,216(sp)
    80004c04:	694e                	ld	s2,208(sp)
    80004c06:	69ae                	ld	s3,200(sp)
    80004c08:	616d                	addi	sp,sp,240
    80004c0a:	8082                	ret

0000000080004c0c <sys_mmap>:
{
    80004c0c:	711d                	addi	sp,sp,-96
    80004c0e:	ec86                	sd	ra,88(sp)
    80004c10:	e8a2                	sd	s0,80(sp)
    80004c12:	e4a6                	sd	s1,72(sp)
    80004c14:	e0ca                	sd	s2,64(sp)
    80004c16:	fc4e                	sd	s3,56(sp)
    80004c18:	f852                	sd	s4,48(sp)
    80004c1a:	1080                	addi	s0,sp,96
    argaddr(0, &addr);
    80004c1c:	fc840593          	addi	a1,s0,-56
    80004c20:	4501                	li	a0,0
    80004c22:	ffffd097          	auipc	ra,0xffffd
    80004c26:	4a4080e7          	jalr	1188(ra) # 800020c6 <argaddr>
    argaddr(1, &length);
    80004c2a:	fc040593          	addi	a1,s0,-64
    80004c2e:	4505                	li	a0,1
    80004c30:	ffffd097          	auipc	ra,0xffffd
    80004c34:	496080e7          	jalr	1174(ra) # 800020c6 <argaddr>
    argint(2, &prot);
    80004c38:	fbc40593          	addi	a1,s0,-68
    80004c3c:	4509                	li	a0,2
    80004c3e:	ffffd097          	auipc	ra,0xffffd
    80004c42:	468080e7          	jalr	1128(ra) # 800020a6 <argint>
    argint(3, &flags);
    80004c46:	fb840593          	addi	a1,s0,-72
    80004c4a:	450d                	li	a0,3
    80004c4c:	ffffd097          	auipc	ra,0xffffd
    80004c50:	45a080e7          	jalr	1114(ra) # 800020a6 <argint>
    argfd(4, &fd, &pf);
    80004c54:	fa040613          	addi	a2,s0,-96
    80004c58:	fb440593          	addi	a1,s0,-76
    80004c5c:	4511                	li	a0,4
    80004c5e:	00000097          	auipc	ra,0x0
    80004c62:	8d2080e7          	jalr	-1838(ra) # 80004530 <argfd>
    argaddr(5, &offset);
    80004c66:	fa840593          	addi	a1,s0,-88
    80004c6a:	4515                	li	a0,5
    80004c6c:	ffffd097          	auipc	ra,0xffffd
    80004c70:	45a080e7          	jalr	1114(ra) # 800020c6 <argaddr>
    if ((prot & PROT_WRITE) && (flags & MAP_SHARED) && (!pf->writable))
    80004c74:	fbc42783          	lw	a5,-68(s0)
    80004c78:	0027f713          	andi	a4,a5,2
    80004c7c:	cb11                	beqz	a4,80004c90 <sys_mmap+0x84>
    80004c7e:	fb842703          	lw	a4,-72(s0)
    80004c82:	8b05                	andi	a4,a4,1
    80004c84:	c711                	beqz	a4,80004c90 <sys_mmap+0x84>
    80004c86:	fa043703          	ld	a4,-96(s0)
    80004c8a:	00974703          	lbu	a4,9(a4)
    80004c8e:	c71d                	beqz	a4,80004cbc <sys_mmap+0xb0>
    if ((prot & PROT_READ) && (!pf->readable))
    80004c90:	8b85                	andi	a5,a5,1
    80004c92:	c791                	beqz	a5,80004c9e <sys_mmap+0x92>
    80004c94:	fa043783          	ld	a5,-96(s0)
    80004c98:	0087c783          	lbu	a5,8(a5)
    80004c9c:	cb95                	beqz	a5,80004cd0 <sys_mmap+0xc4>
    struct proc *p_proc = myproc(); // create a pointer to process struct
    80004c9e:	ffffc097          	auipc	ra,0xffffc
    80004ca2:	1c4080e7          	jalr	452(ra) # 80000e62 <myproc>
    80004ca6:	892a                	mv	s2,a0
            if (p_proc->sz + length <= MAXVA)
    80004ca8:	fc043503          	ld	a0,-64(s0)
    80004cac:	16890793          	addi	a5,s2,360
    for (int i = 0; i <= VMASIZE - 1; i++)
    80004cb0:	4481                	li	s1,0
        if (p_proc->vma[i].occupied != 1)
    80004cb2:	4685                	li	a3,1
            if (p_proc->sz + length <= MAXVA)
    80004cb4:	02669593          	slli	a1,a3,0x26
    for (int i = 0; i <= VMASIZE - 1; i++)
    80004cb8:	4641                	li	a2,16
    80004cba:	a815                	j	80004cee <sys_mmap+0xe2>
        printf("[Testing] (sys_mmap) : not writable but write and map shared\n");
    80004cbc:	00004517          	auipc	a0,0x4
    80004cc0:	aa450513          	addi	a0,a0,-1372 # 80008760 <syscalls+0x308>
    80004cc4:	00001097          	auipc	ra,0x1
    80004cc8:	408080e7          	jalr	1032(ra) # 800060cc <printf>
        return -1;
    80004ccc:	557d                	li	a0,-1
    80004cce:	a8e9                	j	80004da8 <sys_mmap+0x19c>
        printf("[Testing] (sys_mmap) : not readable but read\n");
    80004cd0:	00004517          	auipc	a0,0x4
    80004cd4:	ad050513          	addi	a0,a0,-1328 # 800087a0 <syscalls+0x348>
    80004cd8:	00001097          	auipc	ra,0x1
    80004cdc:	3f4080e7          	jalr	1012(ra) # 800060cc <printf>
        return -1;
    80004ce0:	557d                	li	a0,-1
    80004ce2:	a0d9                	j	80004da8 <sys_mmap+0x19c>
    for (int i = 0; i <= VMASIZE - 1; i++)
    80004ce4:	2485                	addiw	s1,s1,1
    80004ce6:	04878793          	addi	a5,a5,72
    80004cea:	0cc48763          	beq	s1,a2,80004db8 <sys_mmap+0x1ac>
        if (p_proc->vma[i].occupied != 1)
    80004cee:	4398                	lw	a4,0(a5)
    80004cf0:	fed70ae3          	beq	a4,a3,80004ce4 <sys_mmap+0xd8>
            if (p_proc->sz + length <= MAXVA)
    80004cf4:	04893703          	ld	a4,72(s2)
    80004cf8:	972a                	add	a4,a4,a0
    80004cfa:	fee5e5e3          	bltu	a1,a4,80004ce4 <sys_mmap+0xd8>
                printf("[Testing] (sys_mmap) : find vma : %d \n", i);
    80004cfe:	85a6                	mv	a1,s1
    80004d00:	00004517          	auipc	a0,0x4
    80004d04:	ad050513          	addi	a0,a0,-1328 # 800087d0 <syscalls+0x378>
    80004d08:	00001097          	auipc	ra,0x1
    80004d0c:	3c4080e7          	jalr	964(ra) # 800060cc <printf>
        p_vma->occupied = 1; // denote it is occupied
    80004d10:	00349a13          	slli	s4,s1,0x3
    80004d14:	009a09b3          	add	s3,s4,s1
    80004d18:	098e                	slli	s3,s3,0x3
    80004d1a:	99ca                	add	s3,s3,s2
    80004d1c:	4785                	li	a5,1
    80004d1e:	16f9a423          	sw	a5,360(s3)
        p_vma->start_addr = (uint64)(p_proc->sz);
    80004d22:	04893583          	ld	a1,72(s2)
    80004d26:	16b9b823          	sd	a1,368(s3)
        printf("[Testing] (sys_mmap) : find vma : start : %d \n", p_vma->start_addr);
    80004d2a:	00004517          	auipc	a0,0x4
    80004d2e:	ace50513          	addi	a0,a0,-1330 # 800087f8 <syscalls+0x3a0>
    80004d32:	00001097          	auipc	ra,0x1
    80004d36:	39a080e7          	jalr	922(ra) # 800060cc <printf>
        p_vma->end_addr = (uint64)(p_proc->sz + length - 1);
    80004d3a:	fc043583          	ld	a1,-64(s0)
    80004d3e:	15fd                	addi	a1,a1,-1
    80004d40:	04893783          	ld	a5,72(s2)
    80004d44:	95be                	add	a1,a1,a5
    80004d46:	16b9bc23          	sd	a1,376(s3)
        printf("[Testing] (sys_mmap) : find vma : end : %d\n", p_vma->end_addr);
    80004d4a:	00004517          	auipc	a0,0x4
    80004d4e:	ade50513          	addi	a0,a0,-1314 # 80008828 <syscalls+0x3d0>
    80004d52:	00001097          	auipc	ra,0x1
    80004d56:	37a080e7          	jalr	890(ra) # 800060cc <printf>
        p_proc->sz += length;
    80004d5a:	fc043703          	ld	a4,-64(s0)
    80004d5e:	04893783          	ld	a5,72(s2)
    80004d62:	97ba                	add	a5,a5,a4
    80004d64:	04f93423          	sd	a5,72(s2)
        p_vma->addr = (uint64)addr;
    80004d68:	fc843783          	ld	a5,-56(s0)
    80004d6c:	18f9b023          	sd	a5,384(s3)
        p_vma->length = length;
    80004d70:	18e9b423          	sd	a4,392(s3)
        p_vma->prot = prot;
    80004d74:	fbc42783          	lw	a5,-68(s0)
    80004d78:	18f9a823          	sw	a5,400(s3)
        p_vma->flags = flags;
    80004d7c:	fb842783          	lw	a5,-72(s0)
    80004d80:	18f9aa23          	sw	a5,404(s3)
        p_vma->fd = fd;
    80004d84:	fb442783          	lw	a5,-76(s0)
    80004d88:	18f9ac23          	sw	a5,408(s3)
        p_vma->offset = offset;
    80004d8c:	fa843783          	ld	a5,-88(s0)
    80004d90:	1af9b023          	sd	a5,416(s3)
        p_vma->pf = pf;
    80004d94:	fa043503          	ld	a0,-96(s0)
    80004d98:	1aa9b423          	sd	a0,424(s3)
        filedup(p_vma->pf);
    80004d9c:	fffff097          	auipc	ra,0xfffff
    80004da0:	cc0080e7          	jalr	-832(ra) # 80003a5c <filedup>
        return (p_vma->start_addr);
    80004da4:	1709b503          	ld	a0,368(s3)
}
    80004da8:	60e6                	ld	ra,88(sp)
    80004daa:	6446                	ld	s0,80(sp)
    80004dac:	64a6                	ld	s1,72(sp)
    80004dae:	6906                	ld	s2,64(sp)
    80004db0:	79e2                	ld	s3,56(sp)
    80004db2:	7a42                	ld	s4,48(sp)
    80004db4:	6125                	addi	sp,sp,96
    80004db6:	8082                	ret
        panic("syscall mmap");
    80004db8:	00004517          	auipc	a0,0x4
    80004dbc:	aa050513          	addi	a0,a0,-1376 # 80008858 <syscalls+0x400>
    80004dc0:	00001097          	auipc	ra,0x1
    80004dc4:	2c2080e7          	jalr	706(ra) # 80006082 <panic>

0000000080004dc8 <sys_munmap>:
{
    80004dc8:	7139                	addi	sp,sp,-64
    80004dca:	fc06                	sd	ra,56(sp)
    80004dcc:	f822                	sd	s0,48(sp)
    80004dce:	f426                	sd	s1,40(sp)
    80004dd0:	f04a                	sd	s2,32(sp)
    80004dd2:	ec4e                	sd	s3,24(sp)
    80004dd4:	0080                	addi	s0,sp,64
    argaddr(0, &addr);
    80004dd6:	fc840593          	addi	a1,s0,-56
    80004dda:	4501                	li	a0,0
    80004ddc:	ffffd097          	auipc	ra,0xffffd
    80004de0:	2ea080e7          	jalr	746(ra) # 800020c6 <argaddr>
    argaddr(1, &length);
    80004de4:	fc040593          	addi	a1,s0,-64
    80004de8:	4505                	li	a0,1
    80004dea:	ffffd097          	auipc	ra,0xffffd
    80004dee:	2dc080e7          	jalr	732(ra) # 800020c6 <argaddr>
    struct proc *p_proc = myproc(); // create a pointer to process struct
    80004df2:	ffffc097          	auipc	ra,0xffffc
    80004df6:	070080e7          	jalr	112(ra) # 80000e62 <myproc>
    80004dfa:	892a                	mv	s2,a0
        if ((p_proc->vma[i].start_addr <= addr) && (addr <= p_proc->vma[i].end_addr))
    80004dfc:	fc843683          	ld	a3,-56(s0)
    80004e00:	17050793          	addi	a5,a0,368
    for (int i = 0; i <= VMASIZE - 1; i++)
    80004e04:	4481                	li	s1,0
    80004e06:	4641                	li	a2,16
    80004e08:	a031                	j	80004e14 <sys_munmap+0x4c>
    80004e0a:	2485                	addiw	s1,s1,1
    80004e0c:	04878793          	addi	a5,a5,72
    80004e10:	0cc48763          	beq	s1,a2,80004ede <sys_munmap+0x116>
        if ((p_proc->vma[i].start_addr <= addr) && (addr <= p_proc->vma[i].end_addr))
    80004e14:	6398                	ld	a4,0(a5)
    80004e16:	fee6eae3          	bltu	a3,a4,80004e0a <sys_munmap+0x42>
    80004e1a:	6798                	ld	a4,8(a5)
    80004e1c:	fed767e3          	bltu	a4,a3,80004e0a <sys_munmap+0x42>
            printf("[Testing] (sys_munmap): find vma %d\n", i);
    80004e20:	85a6                	mv	a1,s1
    80004e22:	00004517          	auipc	a0,0x4
    80004e26:	a4650513          	addi	a0,a0,-1466 # 80008868 <syscalls+0x410>
    80004e2a:	00001097          	auipc	ra,0x1
    80004e2e:	2a2080e7          	jalr	674(ra) # 800060cc <printf>
            printf("[Testing] (sys_munmap): vma start address %d\n", p_proc->vma[i].start_addr);
    80004e32:	00349993          	slli	s3,s1,0x3
    80004e36:	99a6                	add	s3,s3,s1
    80004e38:	098e                	slli	s3,s3,0x3
    80004e3a:	99ca                	add	s3,s3,s2
    80004e3c:	1709b583          	ld	a1,368(s3)
    80004e40:	00004517          	auipc	a0,0x4
    80004e44:	a5050513          	addi	a0,a0,-1456 # 80008890 <syscalls+0x438>
    80004e48:	00001097          	auipc	ra,0x1
    80004e4c:	284080e7          	jalr	644(ra) # 800060cc <printf>
        if ((p_vma->flags & MAP_SHARED) != 0)
    80004e50:	1949a783          	lw	a5,404(s3)
    80004e54:	8b85                	andi	a5,a5,1
    80004e56:	efc1                	bnez	a5,80004eee <sys_munmap+0x126>
        printf("[Testing] (sys_munmap) : start: %d\n", p_vma->start_addr);
    80004e58:	00349993          	slli	s3,s1,0x3
    80004e5c:	99a6                	add	s3,s3,s1
    80004e5e:	098e                	slli	s3,s3,0x3
    80004e60:	99ca                	add	s3,s3,s2
    80004e62:	1709b583          	ld	a1,368(s3)
    80004e66:	00004517          	auipc	a0,0x4
    80004e6a:	a5a50513          	addi	a0,a0,-1446 # 800088c0 <syscalls+0x468>
    80004e6e:	00001097          	auipc	ra,0x1
    80004e72:	25e080e7          	jalr	606(ra) # 800060cc <printf>
        printf("[Testing] (sys_munmap) : length: %d\n", length);
    80004e76:	fc043583          	ld	a1,-64(s0)
    80004e7a:	00004517          	auipc	a0,0x4
    80004e7e:	a6e50513          	addi	a0,a0,-1426 # 800088e8 <syscalls+0x490>
    80004e82:	00001097          	auipc	ra,0x1
    80004e86:	24a080e7          	jalr	586(ra) # 800060cc <printf>
        uvmunmap(p_proc->pagetable, p_vma->start_addr, length / PGSIZE, 1);
    80004e8a:	4685                	li	a3,1
    80004e8c:	fc043603          	ld	a2,-64(s0)
    80004e90:	8231                	srli	a2,a2,0xc
    80004e92:	1709b583          	ld	a1,368(s3)
    80004e96:	05093503          	ld	a0,80(s2)
    80004e9a:	ffffc097          	auipc	ra,0xffffc
    80004e9e:	89c080e7          	jalr	-1892(ra) # 80000736 <uvmunmap>
        p_vma->start_addr += length;
    80004ea2:	1709b783          	ld	a5,368(s3)
    80004ea6:	fc043703          	ld	a4,-64(s0)
    80004eaa:	97ba                	add	a5,a5,a4
    80004eac:	16f9b823          	sd	a5,368(s3)
        if (p_vma->start_addr == p_vma->end_addr)
    80004eb0:	1789b703          	ld	a4,376(s3)
        return 0;
    80004eb4:	4501                	li	a0,0
        if (p_vma->start_addr == p_vma->end_addr)
    80004eb6:	02e79563          	bne	a5,a4,80004ee0 <sys_munmap+0x118>
            printf("[Testing] (sys_munmap) : whole vma closed\n");
    80004eba:	00004517          	auipc	a0,0x4
    80004ebe:	a5650513          	addi	a0,a0,-1450 # 80008910 <syscalls+0x4b8>
    80004ec2:	00001097          	auipc	ra,0x1
    80004ec6:	20a080e7          	jalr	522(ra) # 800060cc <printf>
            p_vma->occupied = 0;
    80004eca:	1609a423          	sw	zero,360(s3)
            fileclose(p_vma->pf);
    80004ece:	1a89b503          	ld	a0,424(s3)
    80004ed2:	fffff097          	auipc	ra,0xfffff
    80004ed6:	bdc080e7          	jalr	-1060(ra) # 80003aae <fileclose>
            return 0;
    80004eda:	4501                	li	a0,0
    80004edc:	a011                	j	80004ee0 <sys_munmap+0x118>
        return -1;
    80004ede:	557d                	li	a0,-1
}
    80004ee0:	70e2                	ld	ra,56(sp)
    80004ee2:	7442                	ld	s0,48(sp)
    80004ee4:	74a2                	ld	s1,40(sp)
    80004ee6:	7902                	ld	s2,32(sp)
    80004ee8:	69e2                	ld	s3,24(sp)
    80004eea:	6121                	addi	sp,sp,64
    80004eec:	8082                	ret
            filewrite(p_vma->pf, p_vma->start_addr, length);
    80004eee:	00349793          	slli	a5,s1,0x3
    80004ef2:	97a6                	add	a5,a5,s1
    80004ef4:	078e                	slli	a5,a5,0x3
    80004ef6:	97ca                	add	a5,a5,s2
    80004ef8:	fc042603          	lw	a2,-64(s0)
    80004efc:	1707b583          	ld	a1,368(a5)
    80004f00:	1a87b503          	ld	a0,424(a5)
    80004f04:	fffff097          	auipc	ra,0xfffff
    80004f08:	e00080e7          	jalr	-512(ra) # 80003d04 <filewrite>
    80004f0c:	b7b1                	j	80004e58 <sys_munmap+0x90>

0000000080004f0e <sys_open>:

uint64
sys_open(void)
{
    80004f0e:	7131                	addi	sp,sp,-192
    80004f10:	fd06                	sd	ra,184(sp)
    80004f12:	f922                	sd	s0,176(sp)
    80004f14:	f526                	sd	s1,168(sp)
    80004f16:	f14a                	sd	s2,160(sp)
    80004f18:	ed4e                	sd	s3,152(sp)
    80004f1a:	0180                	addi	s0,sp,192
    int fd, omode;
    struct file *f;
    struct inode *ip;
    int n;

    argint(1, &omode);
    80004f1c:	f4c40593          	addi	a1,s0,-180
    80004f20:	4505                	li	a0,1
    80004f22:	ffffd097          	auipc	ra,0xffffd
    80004f26:	184080e7          	jalr	388(ra) # 800020a6 <argint>
    if ((n = argstr(0, path, MAXPATH)) < 0)
    80004f2a:	08000613          	li	a2,128
    80004f2e:	f5040593          	addi	a1,s0,-176
    80004f32:	4501                	li	a0,0
    80004f34:	ffffd097          	auipc	ra,0xffffd
    80004f38:	1b2080e7          	jalr	434(ra) # 800020e6 <argstr>
    80004f3c:	87aa                	mv	a5,a0
        return -1;
    80004f3e:	557d                	li	a0,-1
    if ((n = argstr(0, path, MAXPATH)) < 0)
    80004f40:	0a07c963          	bltz	a5,80004ff2 <sys_open+0xe4>

    begin_op();
    80004f44:	ffffe097          	auipc	ra,0xffffe
    80004f48:	69e080e7          	jalr	1694(ra) # 800035e2 <begin_op>

    if (omode & O_CREATE)
    80004f4c:	f4c42783          	lw	a5,-180(s0)
    80004f50:	2007f793          	andi	a5,a5,512
    80004f54:	cfc5                	beqz	a5,8000500c <sys_open+0xfe>
    {
        ip = create(path, T_FILE, 0, 0);
    80004f56:	4681                	li	a3,0
    80004f58:	4601                	li	a2,0
    80004f5a:	4589                	li	a1,2
    80004f5c:	f5040513          	addi	a0,s0,-176
    80004f60:	fffff097          	auipc	ra,0xfffff
    80004f64:	672080e7          	jalr	1650(ra) # 800045d2 <create>
    80004f68:	84aa                	mv	s1,a0
        if (ip == 0)
    80004f6a:	c959                	beqz	a0,80005000 <sys_open+0xf2>
            end_op();
            return -1;
        }
    }

    if (ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV))
    80004f6c:	04449703          	lh	a4,68(s1)
    80004f70:	478d                	li	a5,3
    80004f72:	00f71763          	bne	a4,a5,80004f80 <sys_open+0x72>
    80004f76:	0464d703          	lhu	a4,70(s1)
    80004f7a:	47a5                	li	a5,9
    80004f7c:	0ce7ed63          	bltu	a5,a4,80005056 <sys_open+0x148>
        iunlockput(ip);
        end_op();
        return -1;
    }

    if ((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0)
    80004f80:	fffff097          	auipc	ra,0xfffff
    80004f84:	a72080e7          	jalr	-1422(ra) # 800039f2 <filealloc>
    80004f88:	89aa                	mv	s3,a0
    80004f8a:	10050363          	beqz	a0,80005090 <sys_open+0x182>
    80004f8e:	fffff097          	auipc	ra,0xfffff
    80004f92:	602080e7          	jalr	1538(ra) # 80004590 <fdalloc>
    80004f96:	892a                	mv	s2,a0
    80004f98:	0e054763          	bltz	a0,80005086 <sys_open+0x178>
        iunlockput(ip);
        end_op();
        return -1;
    }

    if (ip->type == T_DEVICE)
    80004f9c:	04449703          	lh	a4,68(s1)
    80004fa0:	478d                	li	a5,3
    80004fa2:	0cf70563          	beq	a4,a5,8000506c <sys_open+0x15e>
        f->type = FD_DEVICE;
        f->major = ip->major;
    }
    else
    {
        f->type = FD_INODE;
    80004fa6:	4789                	li	a5,2
    80004fa8:	00f9a023          	sw	a5,0(s3)
        f->off = 0;
    80004fac:	0209a023          	sw	zero,32(s3)
    }
    f->ip = ip;
    80004fb0:	0099bc23          	sd	s1,24(s3)
    f->readable = !(omode & O_WRONLY);
    80004fb4:	f4c42783          	lw	a5,-180(s0)
    80004fb8:	0017c713          	xori	a4,a5,1
    80004fbc:	8b05                	andi	a4,a4,1
    80004fbe:	00e98423          	sb	a4,8(s3)
    f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004fc2:	0037f713          	andi	a4,a5,3
    80004fc6:	00e03733          	snez	a4,a4
    80004fca:	00e984a3          	sb	a4,9(s3)

    if ((omode & O_TRUNC) && ip->type == T_FILE)
    80004fce:	4007f793          	andi	a5,a5,1024
    80004fd2:	c791                	beqz	a5,80004fde <sys_open+0xd0>
    80004fd4:	04449703          	lh	a4,68(s1)
    80004fd8:	4789                	li	a5,2
    80004fda:	0af70063          	beq	a4,a5,8000507a <sys_open+0x16c>
    {
        itrunc(ip);
    }

    iunlock(ip);
    80004fde:	8526                	mv	a0,s1
    80004fe0:	ffffe097          	auipc	ra,0xffffe
    80004fe4:	d02080e7          	jalr	-766(ra) # 80002ce2 <iunlock>
    end_op();
    80004fe8:	ffffe097          	auipc	ra,0xffffe
    80004fec:	67a080e7          	jalr	1658(ra) # 80003662 <end_op>

    return fd;
    80004ff0:	854a                	mv	a0,s2
}
    80004ff2:	70ea                	ld	ra,184(sp)
    80004ff4:	744a                	ld	s0,176(sp)
    80004ff6:	74aa                	ld	s1,168(sp)
    80004ff8:	790a                	ld	s2,160(sp)
    80004ffa:	69ea                	ld	s3,152(sp)
    80004ffc:	6129                	addi	sp,sp,192
    80004ffe:	8082                	ret
            end_op();
    80005000:	ffffe097          	auipc	ra,0xffffe
    80005004:	662080e7          	jalr	1634(ra) # 80003662 <end_op>
            return -1;
    80005008:	557d                	li	a0,-1
    8000500a:	b7e5                	j	80004ff2 <sys_open+0xe4>
        if ((ip = namei(path)) == 0)
    8000500c:	f5040513          	addi	a0,s0,-176
    80005010:	ffffe097          	auipc	ra,0xffffe
    80005014:	3b6080e7          	jalr	950(ra) # 800033c6 <namei>
    80005018:	84aa                	mv	s1,a0
    8000501a:	c905                	beqz	a0,8000504a <sys_open+0x13c>
        ilock(ip);
    8000501c:	ffffe097          	auipc	ra,0xffffe
    80005020:	c04080e7          	jalr	-1020(ra) # 80002c20 <ilock>
        if (ip->type == T_DIR && omode != O_RDONLY)
    80005024:	04449703          	lh	a4,68(s1)
    80005028:	4785                	li	a5,1
    8000502a:	f4f711e3          	bne	a4,a5,80004f6c <sys_open+0x5e>
    8000502e:	f4c42783          	lw	a5,-180(s0)
    80005032:	d7b9                	beqz	a5,80004f80 <sys_open+0x72>
            iunlockput(ip);
    80005034:	8526                	mv	a0,s1
    80005036:	ffffe097          	auipc	ra,0xffffe
    8000503a:	e4c080e7          	jalr	-436(ra) # 80002e82 <iunlockput>
            end_op();
    8000503e:	ffffe097          	auipc	ra,0xffffe
    80005042:	624080e7          	jalr	1572(ra) # 80003662 <end_op>
            return -1;
    80005046:	557d                	li	a0,-1
    80005048:	b76d                	j	80004ff2 <sys_open+0xe4>
            end_op();
    8000504a:	ffffe097          	auipc	ra,0xffffe
    8000504e:	618080e7          	jalr	1560(ra) # 80003662 <end_op>
            return -1;
    80005052:	557d                	li	a0,-1
    80005054:	bf79                	j	80004ff2 <sys_open+0xe4>
        iunlockput(ip);
    80005056:	8526                	mv	a0,s1
    80005058:	ffffe097          	auipc	ra,0xffffe
    8000505c:	e2a080e7          	jalr	-470(ra) # 80002e82 <iunlockput>
        end_op();
    80005060:	ffffe097          	auipc	ra,0xffffe
    80005064:	602080e7          	jalr	1538(ra) # 80003662 <end_op>
        return -1;
    80005068:	557d                	li	a0,-1
    8000506a:	b761                	j	80004ff2 <sys_open+0xe4>
        f->type = FD_DEVICE;
    8000506c:	00f9a023          	sw	a5,0(s3)
        f->major = ip->major;
    80005070:	04649783          	lh	a5,70(s1)
    80005074:	02f99223          	sh	a5,36(s3)
    80005078:	bf25                	j	80004fb0 <sys_open+0xa2>
        itrunc(ip);
    8000507a:	8526                	mv	a0,s1
    8000507c:	ffffe097          	auipc	ra,0xffffe
    80005080:	cb2080e7          	jalr	-846(ra) # 80002d2e <itrunc>
    80005084:	bfa9                	j	80004fde <sys_open+0xd0>
            fileclose(f);
    80005086:	854e                	mv	a0,s3
    80005088:	fffff097          	auipc	ra,0xfffff
    8000508c:	a26080e7          	jalr	-1498(ra) # 80003aae <fileclose>
        iunlockput(ip);
    80005090:	8526                	mv	a0,s1
    80005092:	ffffe097          	auipc	ra,0xffffe
    80005096:	df0080e7          	jalr	-528(ra) # 80002e82 <iunlockput>
        end_op();
    8000509a:	ffffe097          	auipc	ra,0xffffe
    8000509e:	5c8080e7          	jalr	1480(ra) # 80003662 <end_op>
        return -1;
    800050a2:	557d                	li	a0,-1
    800050a4:	b7b9                	j	80004ff2 <sys_open+0xe4>

00000000800050a6 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    800050a6:	7175                	addi	sp,sp,-144
    800050a8:	e506                	sd	ra,136(sp)
    800050aa:	e122                	sd	s0,128(sp)
    800050ac:	0900                	addi	s0,sp,144
    char path[MAXPATH];
    struct inode *ip;

    begin_op();
    800050ae:	ffffe097          	auipc	ra,0xffffe
    800050b2:	534080e7          	jalr	1332(ra) # 800035e2 <begin_op>
    if (argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0)
    800050b6:	08000613          	li	a2,128
    800050ba:	f7040593          	addi	a1,s0,-144
    800050be:	4501                	li	a0,0
    800050c0:	ffffd097          	auipc	ra,0xffffd
    800050c4:	026080e7          	jalr	38(ra) # 800020e6 <argstr>
    800050c8:	02054963          	bltz	a0,800050fa <sys_mkdir+0x54>
    800050cc:	4681                	li	a3,0
    800050ce:	4601                	li	a2,0
    800050d0:	4585                	li	a1,1
    800050d2:	f7040513          	addi	a0,s0,-144
    800050d6:	fffff097          	auipc	ra,0xfffff
    800050da:	4fc080e7          	jalr	1276(ra) # 800045d2 <create>
    800050de:	cd11                	beqz	a0,800050fa <sys_mkdir+0x54>
    {
        end_op();
        return -1;
    }
    iunlockput(ip);
    800050e0:	ffffe097          	auipc	ra,0xffffe
    800050e4:	da2080e7          	jalr	-606(ra) # 80002e82 <iunlockput>
    end_op();
    800050e8:	ffffe097          	auipc	ra,0xffffe
    800050ec:	57a080e7          	jalr	1402(ra) # 80003662 <end_op>
    return 0;
    800050f0:	4501                	li	a0,0
}
    800050f2:	60aa                	ld	ra,136(sp)
    800050f4:	640a                	ld	s0,128(sp)
    800050f6:	6149                	addi	sp,sp,144
    800050f8:	8082                	ret
        end_op();
    800050fa:	ffffe097          	auipc	ra,0xffffe
    800050fe:	568080e7          	jalr	1384(ra) # 80003662 <end_op>
        return -1;
    80005102:	557d                	li	a0,-1
    80005104:	b7fd                	j	800050f2 <sys_mkdir+0x4c>

0000000080005106 <sys_mknod>:

uint64
sys_mknod(void)
{
    80005106:	7135                	addi	sp,sp,-160
    80005108:	ed06                	sd	ra,152(sp)
    8000510a:	e922                	sd	s0,144(sp)
    8000510c:	1100                	addi	s0,sp,160
    struct inode *ip;
    char path[MAXPATH];
    int major, minor;

    begin_op();
    8000510e:	ffffe097          	auipc	ra,0xffffe
    80005112:	4d4080e7          	jalr	1236(ra) # 800035e2 <begin_op>
    argint(1, &major);
    80005116:	f6c40593          	addi	a1,s0,-148
    8000511a:	4505                	li	a0,1
    8000511c:	ffffd097          	auipc	ra,0xffffd
    80005120:	f8a080e7          	jalr	-118(ra) # 800020a6 <argint>
    argint(2, &minor);
    80005124:	f6840593          	addi	a1,s0,-152
    80005128:	4509                	li	a0,2
    8000512a:	ffffd097          	auipc	ra,0xffffd
    8000512e:	f7c080e7          	jalr	-132(ra) # 800020a6 <argint>
    if ((argstr(0, path, MAXPATH)) < 0 ||
    80005132:	08000613          	li	a2,128
    80005136:	f7040593          	addi	a1,s0,-144
    8000513a:	4501                	li	a0,0
    8000513c:	ffffd097          	auipc	ra,0xffffd
    80005140:	faa080e7          	jalr	-86(ra) # 800020e6 <argstr>
    80005144:	02054b63          	bltz	a0,8000517a <sys_mknod+0x74>
        (ip = create(path, T_DEVICE, major, minor)) == 0)
    80005148:	f6841683          	lh	a3,-152(s0)
    8000514c:	f6c41603          	lh	a2,-148(s0)
    80005150:	458d                	li	a1,3
    80005152:	f7040513          	addi	a0,s0,-144
    80005156:	fffff097          	auipc	ra,0xfffff
    8000515a:	47c080e7          	jalr	1148(ra) # 800045d2 <create>
    if ((argstr(0, path, MAXPATH)) < 0 ||
    8000515e:	cd11                	beqz	a0,8000517a <sys_mknod+0x74>
    {
        end_op();
        return -1;
    }
    iunlockput(ip);
    80005160:	ffffe097          	auipc	ra,0xffffe
    80005164:	d22080e7          	jalr	-734(ra) # 80002e82 <iunlockput>
    end_op();
    80005168:	ffffe097          	auipc	ra,0xffffe
    8000516c:	4fa080e7          	jalr	1274(ra) # 80003662 <end_op>
    return 0;
    80005170:	4501                	li	a0,0
}
    80005172:	60ea                	ld	ra,152(sp)
    80005174:	644a                	ld	s0,144(sp)
    80005176:	610d                	addi	sp,sp,160
    80005178:	8082                	ret
        end_op();
    8000517a:	ffffe097          	auipc	ra,0xffffe
    8000517e:	4e8080e7          	jalr	1256(ra) # 80003662 <end_op>
        return -1;
    80005182:	557d                	li	a0,-1
    80005184:	b7fd                	j	80005172 <sys_mknod+0x6c>

0000000080005186 <sys_chdir>:

uint64
sys_chdir(void)
{
    80005186:	7135                	addi	sp,sp,-160
    80005188:	ed06                	sd	ra,152(sp)
    8000518a:	e922                	sd	s0,144(sp)
    8000518c:	e526                	sd	s1,136(sp)
    8000518e:	e14a                	sd	s2,128(sp)
    80005190:	1100                	addi	s0,sp,160
    char path[MAXPATH];
    struct inode *ip;
    struct proc *p = myproc();
    80005192:	ffffc097          	auipc	ra,0xffffc
    80005196:	cd0080e7          	jalr	-816(ra) # 80000e62 <myproc>
    8000519a:	892a                	mv	s2,a0

    begin_op();
    8000519c:	ffffe097          	auipc	ra,0xffffe
    800051a0:	446080e7          	jalr	1094(ra) # 800035e2 <begin_op>
    if (argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0)
    800051a4:	08000613          	li	a2,128
    800051a8:	f6040593          	addi	a1,s0,-160
    800051ac:	4501                	li	a0,0
    800051ae:	ffffd097          	auipc	ra,0xffffd
    800051b2:	f38080e7          	jalr	-200(ra) # 800020e6 <argstr>
    800051b6:	04054b63          	bltz	a0,8000520c <sys_chdir+0x86>
    800051ba:	f6040513          	addi	a0,s0,-160
    800051be:	ffffe097          	auipc	ra,0xffffe
    800051c2:	208080e7          	jalr	520(ra) # 800033c6 <namei>
    800051c6:	84aa                	mv	s1,a0
    800051c8:	c131                	beqz	a0,8000520c <sys_chdir+0x86>
    {
        end_op();
        return -1;
    }
    ilock(ip);
    800051ca:	ffffe097          	auipc	ra,0xffffe
    800051ce:	a56080e7          	jalr	-1450(ra) # 80002c20 <ilock>
    if (ip->type != T_DIR)
    800051d2:	04449703          	lh	a4,68(s1)
    800051d6:	4785                	li	a5,1
    800051d8:	04f71063          	bne	a4,a5,80005218 <sys_chdir+0x92>
    {
        iunlockput(ip);
        end_op();
        return -1;
    }
    iunlock(ip);
    800051dc:	8526                	mv	a0,s1
    800051de:	ffffe097          	auipc	ra,0xffffe
    800051e2:	b04080e7          	jalr	-1276(ra) # 80002ce2 <iunlock>
    iput(p->cwd);
    800051e6:	15093503          	ld	a0,336(s2)
    800051ea:	ffffe097          	auipc	ra,0xffffe
    800051ee:	bf0080e7          	jalr	-1040(ra) # 80002dda <iput>
    end_op();
    800051f2:	ffffe097          	auipc	ra,0xffffe
    800051f6:	470080e7          	jalr	1136(ra) # 80003662 <end_op>
    p->cwd = ip;
    800051fa:	14993823          	sd	s1,336(s2)
    return 0;
    800051fe:	4501                	li	a0,0
}
    80005200:	60ea                	ld	ra,152(sp)
    80005202:	644a                	ld	s0,144(sp)
    80005204:	64aa                	ld	s1,136(sp)
    80005206:	690a                	ld	s2,128(sp)
    80005208:	610d                	addi	sp,sp,160
    8000520a:	8082                	ret
        end_op();
    8000520c:	ffffe097          	auipc	ra,0xffffe
    80005210:	456080e7          	jalr	1110(ra) # 80003662 <end_op>
        return -1;
    80005214:	557d                	li	a0,-1
    80005216:	b7ed                	j	80005200 <sys_chdir+0x7a>
        iunlockput(ip);
    80005218:	8526                	mv	a0,s1
    8000521a:	ffffe097          	auipc	ra,0xffffe
    8000521e:	c68080e7          	jalr	-920(ra) # 80002e82 <iunlockput>
        end_op();
    80005222:	ffffe097          	auipc	ra,0xffffe
    80005226:	440080e7          	jalr	1088(ra) # 80003662 <end_op>
        return -1;
    8000522a:	557d                	li	a0,-1
    8000522c:	bfd1                	j	80005200 <sys_chdir+0x7a>

000000008000522e <sys_exec>:

uint64
sys_exec(void)
{
    8000522e:	7145                	addi	sp,sp,-464
    80005230:	e786                	sd	ra,456(sp)
    80005232:	e3a2                	sd	s0,448(sp)
    80005234:	ff26                	sd	s1,440(sp)
    80005236:	fb4a                	sd	s2,432(sp)
    80005238:	f74e                	sd	s3,424(sp)
    8000523a:	f352                	sd	s4,416(sp)
    8000523c:	ef56                	sd	s5,408(sp)
    8000523e:	0b80                	addi	s0,sp,464
    char path[MAXPATH], *argv[MAXARG];
    int i;
    uint64 uargv, uarg;

    argaddr(1, &uargv);
    80005240:	e3840593          	addi	a1,s0,-456
    80005244:	4505                	li	a0,1
    80005246:	ffffd097          	auipc	ra,0xffffd
    8000524a:	e80080e7          	jalr	-384(ra) # 800020c6 <argaddr>
    if (argstr(0, path, MAXPATH) < 0)
    8000524e:	08000613          	li	a2,128
    80005252:	f4040593          	addi	a1,s0,-192
    80005256:	4501                	li	a0,0
    80005258:	ffffd097          	auipc	ra,0xffffd
    8000525c:	e8e080e7          	jalr	-370(ra) # 800020e6 <argstr>
    80005260:	87aa                	mv	a5,a0
    {
        return -1;
    80005262:	557d                	li	a0,-1
    if (argstr(0, path, MAXPATH) < 0)
    80005264:	0c07c263          	bltz	a5,80005328 <sys_exec+0xfa>
    }
    memset(argv, 0, sizeof(argv));
    80005268:	10000613          	li	a2,256
    8000526c:	4581                	li	a1,0
    8000526e:	e4040513          	addi	a0,s0,-448
    80005272:	ffffb097          	auipc	ra,0xffffb
    80005276:	f06080e7          	jalr	-250(ra) # 80000178 <memset>
    for (i = 0;; i++)
    {
        if (i >= NELEM(argv))
    8000527a:	e4040493          	addi	s1,s0,-448
    memset(argv, 0, sizeof(argv));
    8000527e:	89a6                	mv	s3,s1
    80005280:	4901                	li	s2,0
        if (i >= NELEM(argv))
    80005282:	02000a13          	li	s4,32
    80005286:	00090a9b          	sext.w	s5,s2
        {
            goto bad;
        }
        if (fetchaddr(uargv + sizeof(uint64) * i, (uint64 *)&uarg) < 0)
    8000528a:	00391513          	slli	a0,s2,0x3
    8000528e:	e3040593          	addi	a1,s0,-464
    80005292:	e3843783          	ld	a5,-456(s0)
    80005296:	953e                	add	a0,a0,a5
    80005298:	ffffd097          	auipc	ra,0xffffd
    8000529c:	d70080e7          	jalr	-656(ra) # 80002008 <fetchaddr>
    800052a0:	02054a63          	bltz	a0,800052d4 <sys_exec+0xa6>
        {
            goto bad;
        }
        if (uarg == 0)
    800052a4:	e3043783          	ld	a5,-464(s0)
    800052a8:	c3b9                	beqz	a5,800052ee <sys_exec+0xc0>
        {
            argv[i] = 0;
            break;
        }
        argv[i] = kalloc();
    800052aa:	ffffb097          	auipc	ra,0xffffb
    800052ae:	e6e080e7          	jalr	-402(ra) # 80000118 <kalloc>
    800052b2:	85aa                	mv	a1,a0
    800052b4:	00a9b023          	sd	a0,0(s3)
        if (argv[i] == 0)
    800052b8:	cd11                	beqz	a0,800052d4 <sys_exec+0xa6>
            goto bad;
        if (fetchstr(uarg, argv[i], PGSIZE) < 0)
    800052ba:	6605                	lui	a2,0x1
    800052bc:	e3043503          	ld	a0,-464(s0)
    800052c0:	ffffd097          	auipc	ra,0xffffd
    800052c4:	d9a080e7          	jalr	-614(ra) # 8000205a <fetchstr>
    800052c8:	00054663          	bltz	a0,800052d4 <sys_exec+0xa6>
        if (i >= NELEM(argv))
    800052cc:	0905                	addi	s2,s2,1
    800052ce:	09a1                	addi	s3,s3,8
    800052d0:	fb491be3          	bne	s2,s4,80005286 <sys_exec+0x58>
        kfree(argv[i]);

    return ret;

bad:
    for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800052d4:	10048913          	addi	s2,s1,256
    800052d8:	6088                	ld	a0,0(s1)
    800052da:	c531                	beqz	a0,80005326 <sys_exec+0xf8>
        kfree(argv[i]);
    800052dc:	ffffb097          	auipc	ra,0xffffb
    800052e0:	d40080e7          	jalr	-704(ra) # 8000001c <kfree>
    for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800052e4:	04a1                	addi	s1,s1,8
    800052e6:	ff2499e3          	bne	s1,s2,800052d8 <sys_exec+0xaa>
    return -1;
    800052ea:	557d                	li	a0,-1
    800052ec:	a835                	j	80005328 <sys_exec+0xfa>
            argv[i] = 0;
    800052ee:	0a8e                	slli	s5,s5,0x3
    800052f0:	fc040793          	addi	a5,s0,-64
    800052f4:	9abe                	add	s5,s5,a5
    800052f6:	e80ab023          	sd	zero,-384(s5)
    int ret = exec(path, argv);
    800052fa:	e4040593          	addi	a1,s0,-448
    800052fe:	f4040513          	addi	a0,s0,-192
    80005302:	fffff097          	auipc	ra,0xfffff
    80005306:	e8e080e7          	jalr	-370(ra) # 80004190 <exec>
    8000530a:	892a                	mv	s2,a0
    for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000530c:	10048993          	addi	s3,s1,256
    80005310:	6088                	ld	a0,0(s1)
    80005312:	c901                	beqz	a0,80005322 <sys_exec+0xf4>
        kfree(argv[i]);
    80005314:	ffffb097          	auipc	ra,0xffffb
    80005318:	d08080e7          	jalr	-760(ra) # 8000001c <kfree>
    for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000531c:	04a1                	addi	s1,s1,8
    8000531e:	ff3499e3          	bne	s1,s3,80005310 <sys_exec+0xe2>
    return ret;
    80005322:	854a                	mv	a0,s2
    80005324:	a011                	j	80005328 <sys_exec+0xfa>
    return -1;
    80005326:	557d                	li	a0,-1
}
    80005328:	60be                	ld	ra,456(sp)
    8000532a:	641e                	ld	s0,448(sp)
    8000532c:	74fa                	ld	s1,440(sp)
    8000532e:	795a                	ld	s2,432(sp)
    80005330:	79ba                	ld	s3,424(sp)
    80005332:	7a1a                	ld	s4,416(sp)
    80005334:	6afa                	ld	s5,408(sp)
    80005336:	6179                	addi	sp,sp,464
    80005338:	8082                	ret

000000008000533a <sys_pipe>:

uint64
sys_pipe(void)
{
    8000533a:	7139                	addi	sp,sp,-64
    8000533c:	fc06                	sd	ra,56(sp)
    8000533e:	f822                	sd	s0,48(sp)
    80005340:	f426                	sd	s1,40(sp)
    80005342:	0080                	addi	s0,sp,64
    uint64 fdarray; // user pointer to array of two integers
    struct file *rf, *wf;
    int fd0, fd1;
    struct proc *p = myproc();
    80005344:	ffffc097          	auipc	ra,0xffffc
    80005348:	b1e080e7          	jalr	-1250(ra) # 80000e62 <myproc>
    8000534c:	84aa                	mv	s1,a0

    argaddr(0, &fdarray);
    8000534e:	fd840593          	addi	a1,s0,-40
    80005352:	4501                	li	a0,0
    80005354:	ffffd097          	auipc	ra,0xffffd
    80005358:	d72080e7          	jalr	-654(ra) # 800020c6 <argaddr>
    if (pipealloc(&rf, &wf) < 0)
    8000535c:	fc840593          	addi	a1,s0,-56
    80005360:	fd040513          	addi	a0,s0,-48
    80005364:	fffff097          	auipc	ra,0xfffff
    80005368:	ad4080e7          	jalr	-1324(ra) # 80003e38 <pipealloc>
        return -1;
    8000536c:	57fd                	li	a5,-1
    if (pipealloc(&rf, &wf) < 0)
    8000536e:	0c054463          	bltz	a0,80005436 <sys_pipe+0xfc>
    fd0 = -1;
    80005372:	fcf42223          	sw	a5,-60(s0)
    if ((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0)
    80005376:	fd043503          	ld	a0,-48(s0)
    8000537a:	fffff097          	auipc	ra,0xfffff
    8000537e:	216080e7          	jalr	534(ra) # 80004590 <fdalloc>
    80005382:	fca42223          	sw	a0,-60(s0)
    80005386:	08054b63          	bltz	a0,8000541c <sys_pipe+0xe2>
    8000538a:	fc843503          	ld	a0,-56(s0)
    8000538e:	fffff097          	auipc	ra,0xfffff
    80005392:	202080e7          	jalr	514(ra) # 80004590 <fdalloc>
    80005396:	fca42023          	sw	a0,-64(s0)
    8000539a:	06054863          	bltz	a0,8000540a <sys_pipe+0xd0>
            p->ofile[fd0] = 0;
        fileclose(rf);
        fileclose(wf);
        return -1;
    }
    if (copyout(p->pagetable, fdarray, (char *)&fd0, sizeof(fd0)) < 0 ||
    8000539e:	4691                	li	a3,4
    800053a0:	fc440613          	addi	a2,s0,-60
    800053a4:	fd843583          	ld	a1,-40(s0)
    800053a8:	68a8                	ld	a0,80(s1)
    800053aa:	ffffb097          	auipc	ra,0xffffb
    800053ae:	776080e7          	jalr	1910(ra) # 80000b20 <copyout>
    800053b2:	02054063          	bltz	a0,800053d2 <sys_pipe+0x98>
        copyout(p->pagetable, fdarray + sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0)
    800053b6:	4691                	li	a3,4
    800053b8:	fc040613          	addi	a2,s0,-64
    800053bc:	fd843583          	ld	a1,-40(s0)
    800053c0:	0591                	addi	a1,a1,4
    800053c2:	68a8                	ld	a0,80(s1)
    800053c4:	ffffb097          	auipc	ra,0xffffb
    800053c8:	75c080e7          	jalr	1884(ra) # 80000b20 <copyout>
        p->ofile[fd1] = 0;
        fileclose(rf);
        fileclose(wf);
        return -1;
    }
    return 0;
    800053cc:	4781                	li	a5,0
    if (copyout(p->pagetable, fdarray, (char *)&fd0, sizeof(fd0)) < 0 ||
    800053ce:	06055463          	bgez	a0,80005436 <sys_pipe+0xfc>
        p->ofile[fd0] = 0;
    800053d2:	fc442783          	lw	a5,-60(s0)
    800053d6:	07e9                	addi	a5,a5,26
    800053d8:	078e                	slli	a5,a5,0x3
    800053da:	97a6                	add	a5,a5,s1
    800053dc:	0007b023          	sd	zero,0(a5)
        p->ofile[fd1] = 0;
    800053e0:	fc042503          	lw	a0,-64(s0)
    800053e4:	0569                	addi	a0,a0,26
    800053e6:	050e                	slli	a0,a0,0x3
    800053e8:	94aa                	add	s1,s1,a0
    800053ea:	0004b023          	sd	zero,0(s1)
        fileclose(rf);
    800053ee:	fd043503          	ld	a0,-48(s0)
    800053f2:	ffffe097          	auipc	ra,0xffffe
    800053f6:	6bc080e7          	jalr	1724(ra) # 80003aae <fileclose>
        fileclose(wf);
    800053fa:	fc843503          	ld	a0,-56(s0)
    800053fe:	ffffe097          	auipc	ra,0xffffe
    80005402:	6b0080e7          	jalr	1712(ra) # 80003aae <fileclose>
        return -1;
    80005406:	57fd                	li	a5,-1
    80005408:	a03d                	j	80005436 <sys_pipe+0xfc>
        if (fd0 >= 0)
    8000540a:	fc442783          	lw	a5,-60(s0)
    8000540e:	0007c763          	bltz	a5,8000541c <sys_pipe+0xe2>
            p->ofile[fd0] = 0;
    80005412:	07e9                	addi	a5,a5,26
    80005414:	078e                	slli	a5,a5,0x3
    80005416:	94be                	add	s1,s1,a5
    80005418:	0004b023          	sd	zero,0(s1)
        fileclose(rf);
    8000541c:	fd043503          	ld	a0,-48(s0)
    80005420:	ffffe097          	auipc	ra,0xffffe
    80005424:	68e080e7          	jalr	1678(ra) # 80003aae <fileclose>
        fileclose(wf);
    80005428:	fc843503          	ld	a0,-56(s0)
    8000542c:	ffffe097          	auipc	ra,0xffffe
    80005430:	682080e7          	jalr	1666(ra) # 80003aae <fileclose>
        return -1;
    80005434:	57fd                	li	a5,-1
}
    80005436:	853e                	mv	a0,a5
    80005438:	70e2                	ld	ra,56(sp)
    8000543a:	7442                	ld	s0,48(sp)
    8000543c:	74a2                	ld	s1,40(sp)
    8000543e:	6121                	addi	sp,sp,64
    80005440:	8082                	ret
	...

0000000080005450 <kernelvec>:
    80005450:	7111                	addi	sp,sp,-256
    80005452:	e006                	sd	ra,0(sp)
    80005454:	e40a                	sd	sp,8(sp)
    80005456:	e80e                	sd	gp,16(sp)
    80005458:	ec12                	sd	tp,24(sp)
    8000545a:	f016                	sd	t0,32(sp)
    8000545c:	f41a                	sd	t1,40(sp)
    8000545e:	f81e                	sd	t2,48(sp)
    80005460:	fc22                	sd	s0,56(sp)
    80005462:	e0a6                	sd	s1,64(sp)
    80005464:	e4aa                	sd	a0,72(sp)
    80005466:	e8ae                	sd	a1,80(sp)
    80005468:	ecb2                	sd	a2,88(sp)
    8000546a:	f0b6                	sd	a3,96(sp)
    8000546c:	f4ba                	sd	a4,104(sp)
    8000546e:	f8be                	sd	a5,112(sp)
    80005470:	fcc2                	sd	a6,120(sp)
    80005472:	e146                	sd	a7,128(sp)
    80005474:	e54a                	sd	s2,136(sp)
    80005476:	e94e                	sd	s3,144(sp)
    80005478:	ed52                	sd	s4,152(sp)
    8000547a:	f156                	sd	s5,160(sp)
    8000547c:	f55a                	sd	s6,168(sp)
    8000547e:	f95e                	sd	s7,176(sp)
    80005480:	fd62                	sd	s8,184(sp)
    80005482:	e1e6                	sd	s9,192(sp)
    80005484:	e5ea                	sd	s10,200(sp)
    80005486:	e9ee                	sd	s11,208(sp)
    80005488:	edf2                	sd	t3,216(sp)
    8000548a:	f1f6                	sd	t4,224(sp)
    8000548c:	f5fa                	sd	t5,232(sp)
    8000548e:	f9fe                	sd	t6,240(sp)
    80005490:	a45fc0ef          	jal	ra,80001ed4 <kerneltrap>
    80005494:	6082                	ld	ra,0(sp)
    80005496:	6122                	ld	sp,8(sp)
    80005498:	61c2                	ld	gp,16(sp)
    8000549a:	7282                	ld	t0,32(sp)
    8000549c:	7322                	ld	t1,40(sp)
    8000549e:	73c2                	ld	t2,48(sp)
    800054a0:	7462                	ld	s0,56(sp)
    800054a2:	6486                	ld	s1,64(sp)
    800054a4:	6526                	ld	a0,72(sp)
    800054a6:	65c6                	ld	a1,80(sp)
    800054a8:	6666                	ld	a2,88(sp)
    800054aa:	7686                	ld	a3,96(sp)
    800054ac:	7726                	ld	a4,104(sp)
    800054ae:	77c6                	ld	a5,112(sp)
    800054b0:	7866                	ld	a6,120(sp)
    800054b2:	688a                	ld	a7,128(sp)
    800054b4:	692a                	ld	s2,136(sp)
    800054b6:	69ca                	ld	s3,144(sp)
    800054b8:	6a6a                	ld	s4,152(sp)
    800054ba:	7a8a                	ld	s5,160(sp)
    800054bc:	7b2a                	ld	s6,168(sp)
    800054be:	7bca                	ld	s7,176(sp)
    800054c0:	7c6a                	ld	s8,184(sp)
    800054c2:	6c8e                	ld	s9,192(sp)
    800054c4:	6d2e                	ld	s10,200(sp)
    800054c6:	6dce                	ld	s11,208(sp)
    800054c8:	6e6e                	ld	t3,216(sp)
    800054ca:	7e8e                	ld	t4,224(sp)
    800054cc:	7f2e                	ld	t5,232(sp)
    800054ce:	7fce                	ld	t6,240(sp)
    800054d0:	6111                	addi	sp,sp,256
    800054d2:	10200073          	sret
    800054d6:	00000013          	nop
    800054da:	00000013          	nop
    800054de:	0001                	nop

00000000800054e0 <timervec>:
    800054e0:	34051573          	csrrw	a0,mscratch,a0
    800054e4:	e10c                	sd	a1,0(a0)
    800054e6:	e510                	sd	a2,8(a0)
    800054e8:	e914                	sd	a3,16(a0)
    800054ea:	6d0c                	ld	a1,24(a0)
    800054ec:	7110                	ld	a2,32(a0)
    800054ee:	6194                	ld	a3,0(a1)
    800054f0:	96b2                	add	a3,a3,a2
    800054f2:	e194                	sd	a3,0(a1)
    800054f4:	4589                	li	a1,2
    800054f6:	14459073          	csrw	sip,a1
    800054fa:	6914                	ld	a3,16(a0)
    800054fc:	6510                	ld	a2,8(a0)
    800054fe:	610c                	ld	a1,0(a0)
    80005500:	34051573          	csrrw	a0,mscratch,a0
    80005504:	30200073          	mret
	...

000000008000550a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000550a:	1141                	addi	sp,sp,-16
    8000550c:	e422                	sd	s0,8(sp)
    8000550e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005510:	0c0007b7          	lui	a5,0xc000
    80005514:	4705                	li	a4,1
    80005516:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005518:	c3d8                	sw	a4,4(a5)
}
    8000551a:	6422                	ld	s0,8(sp)
    8000551c:	0141                	addi	sp,sp,16
    8000551e:	8082                	ret

0000000080005520 <plicinithart>:

void
plicinithart(void)
{
    80005520:	1141                	addi	sp,sp,-16
    80005522:	e406                	sd	ra,8(sp)
    80005524:	e022                	sd	s0,0(sp)
    80005526:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005528:	ffffc097          	auipc	ra,0xffffc
    8000552c:	90e080e7          	jalr	-1778(ra) # 80000e36 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005530:	0085171b          	slliw	a4,a0,0x8
    80005534:	0c0027b7          	lui	a5,0xc002
    80005538:	97ba                	add	a5,a5,a4
    8000553a:	40200713          	li	a4,1026
    8000553e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005542:	00d5151b          	slliw	a0,a0,0xd
    80005546:	0c2017b7          	lui	a5,0xc201
    8000554a:	953e                	add	a0,a0,a5
    8000554c:	00052023          	sw	zero,0(a0)
}
    80005550:	60a2                	ld	ra,8(sp)
    80005552:	6402                	ld	s0,0(sp)
    80005554:	0141                	addi	sp,sp,16
    80005556:	8082                	ret

0000000080005558 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005558:	1141                	addi	sp,sp,-16
    8000555a:	e406                	sd	ra,8(sp)
    8000555c:	e022                	sd	s0,0(sp)
    8000555e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005560:	ffffc097          	auipc	ra,0xffffc
    80005564:	8d6080e7          	jalr	-1834(ra) # 80000e36 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005568:	00d5179b          	slliw	a5,a0,0xd
    8000556c:	0c201537          	lui	a0,0xc201
    80005570:	953e                	add	a0,a0,a5
  return irq;
}
    80005572:	4148                	lw	a0,4(a0)
    80005574:	60a2                	ld	ra,8(sp)
    80005576:	6402                	ld	s0,0(sp)
    80005578:	0141                	addi	sp,sp,16
    8000557a:	8082                	ret

000000008000557c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000557c:	1101                	addi	sp,sp,-32
    8000557e:	ec06                	sd	ra,24(sp)
    80005580:	e822                	sd	s0,16(sp)
    80005582:	e426                	sd	s1,8(sp)
    80005584:	1000                	addi	s0,sp,32
    80005586:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005588:	ffffc097          	auipc	ra,0xffffc
    8000558c:	8ae080e7          	jalr	-1874(ra) # 80000e36 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005590:	00d5151b          	slliw	a0,a0,0xd
    80005594:	0c2017b7          	lui	a5,0xc201
    80005598:	97aa                	add	a5,a5,a0
    8000559a:	c3c4                	sw	s1,4(a5)
}
    8000559c:	60e2                	ld	ra,24(sp)
    8000559e:	6442                	ld	s0,16(sp)
    800055a0:	64a2                	ld	s1,8(sp)
    800055a2:	6105                	addi	sp,sp,32
    800055a4:	8082                	ret

00000000800055a6 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800055a6:	1141                	addi	sp,sp,-16
    800055a8:	e406                	sd	ra,8(sp)
    800055aa:	e022                	sd	s0,0(sp)
    800055ac:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800055ae:	479d                	li	a5,7
    800055b0:	04a7cc63          	blt	a5,a0,80005608 <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    800055b4:	00026797          	auipc	a5,0x26
    800055b8:	69c78793          	addi	a5,a5,1692 # 8002bc50 <disk>
    800055bc:	97aa                	add	a5,a5,a0
    800055be:	0187c783          	lbu	a5,24(a5)
    800055c2:	ebb9                	bnez	a5,80005618 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800055c4:	00451613          	slli	a2,a0,0x4
    800055c8:	00026797          	auipc	a5,0x26
    800055cc:	68878793          	addi	a5,a5,1672 # 8002bc50 <disk>
    800055d0:	6394                	ld	a3,0(a5)
    800055d2:	96b2                	add	a3,a3,a2
    800055d4:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    800055d8:	6398                	ld	a4,0(a5)
    800055da:	9732                	add	a4,a4,a2
    800055dc:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    800055e0:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    800055e4:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    800055e8:	953e                	add	a0,a0,a5
    800055ea:	4785                	li	a5,1
    800055ec:	00f50c23          	sb	a5,24(a0) # c201018 <_entry-0x73dfefe8>
  wakeup(&disk.free[0]);
    800055f0:	00026517          	auipc	a0,0x26
    800055f4:	67850513          	addi	a0,a0,1656 # 8002bc68 <disk+0x18>
    800055f8:	ffffc097          	auipc	ra,0xffffc
    800055fc:	f72080e7          	jalr	-142(ra) # 8000156a <wakeup>
}
    80005600:	60a2                	ld	ra,8(sp)
    80005602:	6402                	ld	s0,0(sp)
    80005604:	0141                	addi	sp,sp,16
    80005606:	8082                	ret
    panic("free_desc 1");
    80005608:	00003517          	auipc	a0,0x3
    8000560c:	33850513          	addi	a0,a0,824 # 80008940 <syscalls+0x4e8>
    80005610:	00001097          	auipc	ra,0x1
    80005614:	a72080e7          	jalr	-1422(ra) # 80006082 <panic>
    panic("free_desc 2");
    80005618:	00003517          	auipc	a0,0x3
    8000561c:	33850513          	addi	a0,a0,824 # 80008950 <syscalls+0x4f8>
    80005620:	00001097          	auipc	ra,0x1
    80005624:	a62080e7          	jalr	-1438(ra) # 80006082 <panic>

0000000080005628 <virtio_disk_init>:
{
    80005628:	1101                	addi	sp,sp,-32
    8000562a:	ec06                	sd	ra,24(sp)
    8000562c:	e822                	sd	s0,16(sp)
    8000562e:	e426                	sd	s1,8(sp)
    80005630:	e04a                	sd	s2,0(sp)
    80005632:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005634:	00003597          	auipc	a1,0x3
    80005638:	32c58593          	addi	a1,a1,812 # 80008960 <syscalls+0x508>
    8000563c:	00026517          	auipc	a0,0x26
    80005640:	73c50513          	addi	a0,a0,1852 # 8002bd78 <disk+0x128>
    80005644:	00001097          	auipc	ra,0x1
    80005648:	ef8080e7          	jalr	-264(ra) # 8000653c <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000564c:	100017b7          	lui	a5,0x10001
    80005650:	4398                	lw	a4,0(a5)
    80005652:	2701                	sext.w	a4,a4
    80005654:	747277b7          	lui	a5,0x74727
    80005658:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    8000565c:	14f71e63          	bne	a4,a5,800057b8 <virtio_disk_init+0x190>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005660:	100017b7          	lui	a5,0x10001
    80005664:	43dc                	lw	a5,4(a5)
    80005666:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005668:	4709                	li	a4,2
    8000566a:	14e79763          	bne	a5,a4,800057b8 <virtio_disk_init+0x190>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000566e:	100017b7          	lui	a5,0x10001
    80005672:	479c                	lw	a5,8(a5)
    80005674:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005676:	14e79163          	bne	a5,a4,800057b8 <virtio_disk_init+0x190>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    8000567a:	100017b7          	lui	a5,0x10001
    8000567e:	47d8                	lw	a4,12(a5)
    80005680:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005682:	554d47b7          	lui	a5,0x554d4
    80005686:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    8000568a:	12f71763          	bne	a4,a5,800057b8 <virtio_disk_init+0x190>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000568e:	100017b7          	lui	a5,0x10001
    80005692:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005696:	4705                	li	a4,1
    80005698:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000569a:	470d                	li	a4,3
    8000569c:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    8000569e:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800056a0:	c7ffe737          	lui	a4,0xc7ffe
    800056a4:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fca78f>
    800056a8:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800056aa:	2701                	sext.w	a4,a4
    800056ac:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800056ae:	472d                	li	a4,11
    800056b0:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    800056b2:	0707a903          	lw	s2,112(a5)
    800056b6:	2901                	sext.w	s2,s2
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    800056b8:	00897793          	andi	a5,s2,8
    800056bc:	10078663          	beqz	a5,800057c8 <virtio_disk_init+0x1a0>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800056c0:	100017b7          	lui	a5,0x10001
    800056c4:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    800056c8:	43fc                	lw	a5,68(a5)
    800056ca:	2781                	sext.w	a5,a5
    800056cc:	10079663          	bnez	a5,800057d8 <virtio_disk_init+0x1b0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800056d0:	100017b7          	lui	a5,0x10001
    800056d4:	5bdc                	lw	a5,52(a5)
    800056d6:	2781                	sext.w	a5,a5
  if(max == 0)
    800056d8:	10078863          	beqz	a5,800057e8 <virtio_disk_init+0x1c0>
  if(max < NUM)
    800056dc:	471d                	li	a4,7
    800056de:	10f77d63          	bgeu	a4,a5,800057f8 <virtio_disk_init+0x1d0>
  disk.desc = kalloc();
    800056e2:	ffffb097          	auipc	ra,0xffffb
    800056e6:	a36080e7          	jalr	-1482(ra) # 80000118 <kalloc>
    800056ea:	00026497          	auipc	s1,0x26
    800056ee:	56648493          	addi	s1,s1,1382 # 8002bc50 <disk>
    800056f2:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    800056f4:	ffffb097          	auipc	ra,0xffffb
    800056f8:	a24080e7          	jalr	-1500(ra) # 80000118 <kalloc>
    800056fc:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    800056fe:	ffffb097          	auipc	ra,0xffffb
    80005702:	a1a080e7          	jalr	-1510(ra) # 80000118 <kalloc>
    80005706:	87aa                	mv	a5,a0
    80005708:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    8000570a:	6088                	ld	a0,0(s1)
    8000570c:	cd75                	beqz	a0,80005808 <virtio_disk_init+0x1e0>
    8000570e:	00026717          	auipc	a4,0x26
    80005712:	54a73703          	ld	a4,1354(a4) # 8002bc58 <disk+0x8>
    80005716:	cb6d                	beqz	a4,80005808 <virtio_disk_init+0x1e0>
    80005718:	cbe5                	beqz	a5,80005808 <virtio_disk_init+0x1e0>
  memset(disk.desc, 0, PGSIZE);
    8000571a:	6605                	lui	a2,0x1
    8000571c:	4581                	li	a1,0
    8000571e:	ffffb097          	auipc	ra,0xffffb
    80005722:	a5a080e7          	jalr	-1446(ra) # 80000178 <memset>
  memset(disk.avail, 0, PGSIZE);
    80005726:	00026497          	auipc	s1,0x26
    8000572a:	52a48493          	addi	s1,s1,1322 # 8002bc50 <disk>
    8000572e:	6605                	lui	a2,0x1
    80005730:	4581                	li	a1,0
    80005732:	6488                	ld	a0,8(s1)
    80005734:	ffffb097          	auipc	ra,0xffffb
    80005738:	a44080e7          	jalr	-1468(ra) # 80000178 <memset>
  memset(disk.used, 0, PGSIZE);
    8000573c:	6605                	lui	a2,0x1
    8000573e:	4581                	li	a1,0
    80005740:	6888                	ld	a0,16(s1)
    80005742:	ffffb097          	auipc	ra,0xffffb
    80005746:	a36080e7          	jalr	-1482(ra) # 80000178 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    8000574a:	100017b7          	lui	a5,0x10001
    8000574e:	4721                	li	a4,8
    80005750:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80005752:	4098                	lw	a4,0(s1)
    80005754:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80005758:	40d8                	lw	a4,4(s1)
    8000575a:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    8000575e:	6498                	ld	a4,8(s1)
    80005760:	0007069b          	sext.w	a3,a4
    80005764:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80005768:	9701                	srai	a4,a4,0x20
    8000576a:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    8000576e:	6898                	ld	a4,16(s1)
    80005770:	0007069b          	sext.w	a3,a4
    80005774:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80005778:	9701                	srai	a4,a4,0x20
    8000577a:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    8000577e:	4685                	li	a3,1
    80005780:	c3f4                	sw	a3,68(a5)
    disk.free[i] = 1;
    80005782:	4705                	li	a4,1
    80005784:	00d48c23          	sb	a3,24(s1)
    80005788:	00e48ca3          	sb	a4,25(s1)
    8000578c:	00e48d23          	sb	a4,26(s1)
    80005790:	00e48da3          	sb	a4,27(s1)
    80005794:	00e48e23          	sb	a4,28(s1)
    80005798:	00e48ea3          	sb	a4,29(s1)
    8000579c:	00e48f23          	sb	a4,30(s1)
    800057a0:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    800057a4:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    800057a8:	0727a823          	sw	s2,112(a5)
}
    800057ac:	60e2                	ld	ra,24(sp)
    800057ae:	6442                	ld	s0,16(sp)
    800057b0:	64a2                	ld	s1,8(sp)
    800057b2:	6902                	ld	s2,0(sp)
    800057b4:	6105                	addi	sp,sp,32
    800057b6:	8082                	ret
    panic("could not find virtio disk");
    800057b8:	00003517          	auipc	a0,0x3
    800057bc:	1b850513          	addi	a0,a0,440 # 80008970 <syscalls+0x518>
    800057c0:	00001097          	auipc	ra,0x1
    800057c4:	8c2080e7          	jalr	-1854(ra) # 80006082 <panic>
    panic("virtio disk FEATURES_OK unset");
    800057c8:	00003517          	auipc	a0,0x3
    800057cc:	1c850513          	addi	a0,a0,456 # 80008990 <syscalls+0x538>
    800057d0:	00001097          	auipc	ra,0x1
    800057d4:	8b2080e7          	jalr	-1870(ra) # 80006082 <panic>
    panic("virtio disk should not be ready");
    800057d8:	00003517          	auipc	a0,0x3
    800057dc:	1d850513          	addi	a0,a0,472 # 800089b0 <syscalls+0x558>
    800057e0:	00001097          	auipc	ra,0x1
    800057e4:	8a2080e7          	jalr	-1886(ra) # 80006082 <panic>
    panic("virtio disk has no queue 0");
    800057e8:	00003517          	auipc	a0,0x3
    800057ec:	1e850513          	addi	a0,a0,488 # 800089d0 <syscalls+0x578>
    800057f0:	00001097          	auipc	ra,0x1
    800057f4:	892080e7          	jalr	-1902(ra) # 80006082 <panic>
    panic("virtio disk max queue too short");
    800057f8:	00003517          	auipc	a0,0x3
    800057fc:	1f850513          	addi	a0,a0,504 # 800089f0 <syscalls+0x598>
    80005800:	00001097          	auipc	ra,0x1
    80005804:	882080e7          	jalr	-1918(ra) # 80006082 <panic>
    panic("virtio disk kalloc");
    80005808:	00003517          	auipc	a0,0x3
    8000580c:	20850513          	addi	a0,a0,520 # 80008a10 <syscalls+0x5b8>
    80005810:	00001097          	auipc	ra,0x1
    80005814:	872080e7          	jalr	-1934(ra) # 80006082 <panic>

0000000080005818 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005818:	7159                	addi	sp,sp,-112
    8000581a:	f486                	sd	ra,104(sp)
    8000581c:	f0a2                	sd	s0,96(sp)
    8000581e:	eca6                	sd	s1,88(sp)
    80005820:	e8ca                	sd	s2,80(sp)
    80005822:	e4ce                	sd	s3,72(sp)
    80005824:	e0d2                	sd	s4,64(sp)
    80005826:	fc56                	sd	s5,56(sp)
    80005828:	f85a                	sd	s6,48(sp)
    8000582a:	f45e                	sd	s7,40(sp)
    8000582c:	f062                	sd	s8,32(sp)
    8000582e:	ec66                	sd	s9,24(sp)
    80005830:	e86a                	sd	s10,16(sp)
    80005832:	1880                	addi	s0,sp,112
    80005834:	892a                	mv	s2,a0
    80005836:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005838:	00c52c83          	lw	s9,12(a0)
    8000583c:	001c9c9b          	slliw	s9,s9,0x1
    80005840:	1c82                	slli	s9,s9,0x20
    80005842:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005846:	00026517          	auipc	a0,0x26
    8000584a:	53250513          	addi	a0,a0,1330 # 8002bd78 <disk+0x128>
    8000584e:	00001097          	auipc	ra,0x1
    80005852:	d7e080e7          	jalr	-642(ra) # 800065cc <acquire>
  for(int i = 0; i < 3; i++){
    80005856:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005858:	4ba1                	li	s7,8
      disk.free[i] = 0;
    8000585a:	00026b17          	auipc	s6,0x26
    8000585e:	3f6b0b13          	addi	s6,s6,1014 # 8002bc50 <disk>
  for(int i = 0; i < 3; i++){
    80005862:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    80005864:	8a4e                	mv	s4,s3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005866:	00026c17          	auipc	s8,0x26
    8000586a:	512c0c13          	addi	s8,s8,1298 # 8002bd78 <disk+0x128>
    8000586e:	a8b5                	j	800058ea <virtio_disk_rw+0xd2>
      disk.free[i] = 0;
    80005870:	00fb06b3          	add	a3,s6,a5
    80005874:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    80005878:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    8000587a:	0207c563          	bltz	a5,800058a4 <virtio_disk_rw+0x8c>
  for(int i = 0; i < 3; i++){
    8000587e:	2485                	addiw	s1,s1,1
    80005880:	0711                	addi	a4,a4,4
    80005882:	1f548a63          	beq	s1,s5,80005a76 <virtio_disk_rw+0x25e>
    idx[i] = alloc_desc();
    80005886:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    80005888:	00026697          	auipc	a3,0x26
    8000588c:	3c868693          	addi	a3,a3,968 # 8002bc50 <disk>
    80005890:	87d2                	mv	a5,s4
    if(disk.free[i]){
    80005892:	0186c583          	lbu	a1,24(a3)
    80005896:	fde9                	bnez	a1,80005870 <virtio_disk_rw+0x58>
  for(int i = 0; i < NUM; i++){
    80005898:	2785                	addiw	a5,a5,1
    8000589a:	0685                	addi	a3,a3,1
    8000589c:	ff779be3          	bne	a5,s7,80005892 <virtio_disk_rw+0x7a>
    idx[i] = alloc_desc();
    800058a0:	57fd                	li	a5,-1
    800058a2:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    800058a4:	02905a63          	blez	s1,800058d8 <virtio_disk_rw+0xc0>
        free_desc(idx[j]);
    800058a8:	f9042503          	lw	a0,-112(s0)
    800058ac:	00000097          	auipc	ra,0x0
    800058b0:	cfa080e7          	jalr	-774(ra) # 800055a6 <free_desc>
      for(int j = 0; j < i; j++)
    800058b4:	4785                	li	a5,1
    800058b6:	0297d163          	bge	a5,s1,800058d8 <virtio_disk_rw+0xc0>
        free_desc(idx[j]);
    800058ba:	f9442503          	lw	a0,-108(s0)
    800058be:	00000097          	auipc	ra,0x0
    800058c2:	ce8080e7          	jalr	-792(ra) # 800055a6 <free_desc>
      for(int j = 0; j < i; j++)
    800058c6:	4789                	li	a5,2
    800058c8:	0097d863          	bge	a5,s1,800058d8 <virtio_disk_rw+0xc0>
        free_desc(idx[j]);
    800058cc:	f9842503          	lw	a0,-104(s0)
    800058d0:	00000097          	auipc	ra,0x0
    800058d4:	cd6080e7          	jalr	-810(ra) # 800055a6 <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    800058d8:	85e2                	mv	a1,s8
    800058da:	00026517          	auipc	a0,0x26
    800058de:	38e50513          	addi	a0,a0,910 # 8002bc68 <disk+0x18>
    800058e2:	ffffc097          	auipc	ra,0xffffc
    800058e6:	c24080e7          	jalr	-988(ra) # 80001506 <sleep>
  for(int i = 0; i < 3; i++){
    800058ea:	f9040713          	addi	a4,s0,-112
    800058ee:	84ce                	mv	s1,s3
    800058f0:	bf59                	j	80005886 <virtio_disk_rw+0x6e>
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

  if(write)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    800058f2:	00a60793          	addi	a5,a2,10 # 100a <_entry-0x7fffeff6>
    800058f6:	00479693          	slli	a3,a5,0x4
    800058fa:	00026797          	auipc	a5,0x26
    800058fe:	35678793          	addi	a5,a5,854 # 8002bc50 <disk>
    80005902:	97b6                	add	a5,a5,a3
    80005904:	4685                	li	a3,1
    80005906:	c794                	sw	a3,8(a5)
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80005908:	00026597          	auipc	a1,0x26
    8000590c:	34858593          	addi	a1,a1,840 # 8002bc50 <disk>
    80005910:	00a60793          	addi	a5,a2,10
    80005914:	0792                	slli	a5,a5,0x4
    80005916:	97ae                	add	a5,a5,a1
    80005918:	0007a623          	sw	zero,12(a5)
  buf0->sector = sector;
    8000591c:	0197b823          	sd	s9,16(a5)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005920:	f6070693          	addi	a3,a4,-160
    80005924:	619c                	ld	a5,0(a1)
    80005926:	97b6                	add	a5,a5,a3
    80005928:	e388                	sd	a0,0(a5)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    8000592a:	6188                	ld	a0,0(a1)
    8000592c:	96aa                	add	a3,a3,a0
    8000592e:	47c1                	li	a5,16
    80005930:	c69c                	sw	a5,8(a3)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005932:	4785                	li	a5,1
    80005934:	00f69623          	sh	a5,12(a3)
  disk.desc[idx[0]].next = idx[1];
    80005938:	f9442783          	lw	a5,-108(s0)
    8000593c:	00f69723          	sh	a5,14(a3)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005940:	0792                	slli	a5,a5,0x4
    80005942:	953e                	add	a0,a0,a5
    80005944:	05890693          	addi	a3,s2,88
    80005948:	e114                	sd	a3,0(a0)
  disk.desc[idx[1]].len = BSIZE;
    8000594a:	6188                	ld	a0,0(a1)
    8000594c:	97aa                	add	a5,a5,a0
    8000594e:	40000693          	li	a3,1024
    80005952:	c794                	sw	a3,8(a5)
  if(write)
    80005954:	100d0d63          	beqz	s10,80005a6e <virtio_disk_rw+0x256>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    80005958:	00079623          	sh	zero,12(a5)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000595c:	00c7d683          	lhu	a3,12(a5)
    80005960:	0016e693          	ori	a3,a3,1
    80005964:	00d79623          	sh	a3,12(a5)
  disk.desc[idx[1]].next = idx[2];
    80005968:	f9842583          	lw	a1,-104(s0)
    8000596c:	00b79723          	sh	a1,14(a5)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005970:	00026697          	auipc	a3,0x26
    80005974:	2e068693          	addi	a3,a3,736 # 8002bc50 <disk>
    80005978:	00260793          	addi	a5,a2,2
    8000597c:	0792                	slli	a5,a5,0x4
    8000597e:	97b6                	add	a5,a5,a3
    80005980:	587d                	li	a6,-1
    80005982:	01078823          	sb	a6,16(a5)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005986:	0592                	slli	a1,a1,0x4
    80005988:	952e                	add	a0,a0,a1
    8000598a:	f9070713          	addi	a4,a4,-112
    8000598e:	9736                	add	a4,a4,a3
    80005990:	e118                	sd	a4,0(a0)
  disk.desc[idx[2]].len = 1;
    80005992:	6298                	ld	a4,0(a3)
    80005994:	972e                	add	a4,a4,a1
    80005996:	4585                	li	a1,1
    80005998:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    8000599a:	4509                	li	a0,2
    8000599c:	00a71623          	sh	a0,12(a4)
  disk.desc[idx[2]].next = 0;
    800059a0:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800059a4:	00b92223          	sw	a1,4(s2)
  disk.info[idx[0]].b = b;
    800059a8:	0127b423          	sd	s2,8(a5)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800059ac:	6698                	ld	a4,8(a3)
    800059ae:	00275783          	lhu	a5,2(a4)
    800059b2:	8b9d                	andi	a5,a5,7
    800059b4:	0786                	slli	a5,a5,0x1
    800059b6:	97ba                	add	a5,a5,a4
    800059b8:	00c79223          	sh	a2,4(a5)

  __sync_synchronize();
    800059bc:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800059c0:	6698                	ld	a4,8(a3)
    800059c2:	00275783          	lhu	a5,2(a4)
    800059c6:	2785                	addiw	a5,a5,1
    800059c8:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800059cc:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800059d0:	100017b7          	lui	a5,0x10001
    800059d4:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800059d8:	00492703          	lw	a4,4(s2)
    800059dc:	4785                	li	a5,1
    800059de:	02f71163          	bne	a4,a5,80005a00 <virtio_disk_rw+0x1e8>
    sleep(b, &disk.vdisk_lock);
    800059e2:	00026997          	auipc	s3,0x26
    800059e6:	39698993          	addi	s3,s3,918 # 8002bd78 <disk+0x128>
  while(b->disk == 1) {
    800059ea:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    800059ec:	85ce                	mv	a1,s3
    800059ee:	854a                	mv	a0,s2
    800059f0:	ffffc097          	auipc	ra,0xffffc
    800059f4:	b16080e7          	jalr	-1258(ra) # 80001506 <sleep>
  while(b->disk == 1) {
    800059f8:	00492783          	lw	a5,4(s2)
    800059fc:	fe9788e3          	beq	a5,s1,800059ec <virtio_disk_rw+0x1d4>
  }

  disk.info[idx[0]].b = 0;
    80005a00:	f9042903          	lw	s2,-112(s0)
    80005a04:	00290793          	addi	a5,s2,2
    80005a08:	00479713          	slli	a4,a5,0x4
    80005a0c:	00026797          	auipc	a5,0x26
    80005a10:	24478793          	addi	a5,a5,580 # 8002bc50 <disk>
    80005a14:	97ba                	add	a5,a5,a4
    80005a16:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80005a1a:	00026997          	auipc	s3,0x26
    80005a1e:	23698993          	addi	s3,s3,566 # 8002bc50 <disk>
    80005a22:	00491713          	slli	a4,s2,0x4
    80005a26:	0009b783          	ld	a5,0(s3)
    80005a2a:	97ba                	add	a5,a5,a4
    80005a2c:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005a30:	854a                	mv	a0,s2
    80005a32:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005a36:	00000097          	auipc	ra,0x0
    80005a3a:	b70080e7          	jalr	-1168(ra) # 800055a6 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005a3e:	8885                	andi	s1,s1,1
    80005a40:	f0ed                	bnez	s1,80005a22 <virtio_disk_rw+0x20a>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005a42:	00026517          	auipc	a0,0x26
    80005a46:	33650513          	addi	a0,a0,822 # 8002bd78 <disk+0x128>
    80005a4a:	00001097          	auipc	ra,0x1
    80005a4e:	c36080e7          	jalr	-970(ra) # 80006680 <release>
}
    80005a52:	70a6                	ld	ra,104(sp)
    80005a54:	7406                	ld	s0,96(sp)
    80005a56:	64e6                	ld	s1,88(sp)
    80005a58:	6946                	ld	s2,80(sp)
    80005a5a:	69a6                	ld	s3,72(sp)
    80005a5c:	6a06                	ld	s4,64(sp)
    80005a5e:	7ae2                	ld	s5,56(sp)
    80005a60:	7b42                	ld	s6,48(sp)
    80005a62:	7ba2                	ld	s7,40(sp)
    80005a64:	7c02                	ld	s8,32(sp)
    80005a66:	6ce2                	ld	s9,24(sp)
    80005a68:	6d42                	ld	s10,16(sp)
    80005a6a:	6165                	addi	sp,sp,112
    80005a6c:	8082                	ret
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    80005a6e:	4689                	li	a3,2
    80005a70:	00d79623          	sh	a3,12(a5)
    80005a74:	b5e5                	j	8000595c <virtio_disk_rw+0x144>
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005a76:	f9042603          	lw	a2,-112(s0)
    80005a7a:	00a60713          	addi	a4,a2,10
    80005a7e:	0712                	slli	a4,a4,0x4
    80005a80:	00026517          	auipc	a0,0x26
    80005a84:	1d850513          	addi	a0,a0,472 # 8002bc58 <disk+0x8>
    80005a88:	953a                	add	a0,a0,a4
  if(write)
    80005a8a:	e60d14e3          	bnez	s10,800058f2 <virtio_disk_rw+0xda>
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    80005a8e:	00a60793          	addi	a5,a2,10
    80005a92:	00479693          	slli	a3,a5,0x4
    80005a96:	00026797          	auipc	a5,0x26
    80005a9a:	1ba78793          	addi	a5,a5,442 # 8002bc50 <disk>
    80005a9e:	97b6                	add	a5,a5,a3
    80005aa0:	0007a423          	sw	zero,8(a5)
    80005aa4:	b595                	j	80005908 <virtio_disk_rw+0xf0>

0000000080005aa6 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005aa6:	1101                	addi	sp,sp,-32
    80005aa8:	ec06                	sd	ra,24(sp)
    80005aaa:	e822                	sd	s0,16(sp)
    80005aac:	e426                	sd	s1,8(sp)
    80005aae:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005ab0:	00026497          	auipc	s1,0x26
    80005ab4:	1a048493          	addi	s1,s1,416 # 8002bc50 <disk>
    80005ab8:	00026517          	auipc	a0,0x26
    80005abc:	2c050513          	addi	a0,a0,704 # 8002bd78 <disk+0x128>
    80005ac0:	00001097          	auipc	ra,0x1
    80005ac4:	b0c080e7          	jalr	-1268(ra) # 800065cc <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005ac8:	10001737          	lui	a4,0x10001
    80005acc:	533c                	lw	a5,96(a4)
    80005ace:	8b8d                	andi	a5,a5,3
    80005ad0:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80005ad2:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005ad6:	689c                	ld	a5,16(s1)
    80005ad8:	0204d703          	lhu	a4,32(s1)
    80005adc:	0027d783          	lhu	a5,2(a5)
    80005ae0:	04f70863          	beq	a4,a5,80005b30 <virtio_disk_intr+0x8a>
    __sync_synchronize();
    80005ae4:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005ae8:	6898                	ld	a4,16(s1)
    80005aea:	0204d783          	lhu	a5,32(s1)
    80005aee:	8b9d                	andi	a5,a5,7
    80005af0:	078e                	slli	a5,a5,0x3
    80005af2:	97ba                	add	a5,a5,a4
    80005af4:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005af6:	00278713          	addi	a4,a5,2
    80005afa:	0712                	slli	a4,a4,0x4
    80005afc:	9726                	add	a4,a4,s1
    80005afe:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    80005b02:	e721                	bnez	a4,80005b4a <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005b04:	0789                	addi	a5,a5,2
    80005b06:	0792                	slli	a5,a5,0x4
    80005b08:	97a6                	add	a5,a5,s1
    80005b0a:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80005b0c:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005b10:	ffffc097          	auipc	ra,0xffffc
    80005b14:	a5a080e7          	jalr	-1446(ra) # 8000156a <wakeup>

    disk.used_idx += 1;
    80005b18:	0204d783          	lhu	a5,32(s1)
    80005b1c:	2785                	addiw	a5,a5,1
    80005b1e:	17c2                	slli	a5,a5,0x30
    80005b20:	93c1                	srli	a5,a5,0x30
    80005b22:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005b26:	6898                	ld	a4,16(s1)
    80005b28:	00275703          	lhu	a4,2(a4)
    80005b2c:	faf71ce3          	bne	a4,a5,80005ae4 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80005b30:	00026517          	auipc	a0,0x26
    80005b34:	24850513          	addi	a0,a0,584 # 8002bd78 <disk+0x128>
    80005b38:	00001097          	auipc	ra,0x1
    80005b3c:	b48080e7          	jalr	-1208(ra) # 80006680 <release>
}
    80005b40:	60e2                	ld	ra,24(sp)
    80005b42:	6442                	ld	s0,16(sp)
    80005b44:	64a2                	ld	s1,8(sp)
    80005b46:	6105                	addi	sp,sp,32
    80005b48:	8082                	ret
      panic("virtio_disk_intr status");
    80005b4a:	00003517          	auipc	a0,0x3
    80005b4e:	ede50513          	addi	a0,a0,-290 # 80008a28 <syscalls+0x5d0>
    80005b52:	00000097          	auipc	ra,0x0
    80005b56:	530080e7          	jalr	1328(ra) # 80006082 <panic>

0000000080005b5a <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005b5a:	1141                	addi	sp,sp,-16
    80005b5c:	e422                	sd	s0,8(sp)
    80005b5e:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005b60:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005b64:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005b68:	0037979b          	slliw	a5,a5,0x3
    80005b6c:	02004737          	lui	a4,0x2004
    80005b70:	97ba                	add	a5,a5,a4
    80005b72:	0200c737          	lui	a4,0x200c
    80005b76:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005b7a:	000f4637          	lui	a2,0xf4
    80005b7e:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005b82:	95b2                	add	a1,a1,a2
    80005b84:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005b86:	00269713          	slli	a4,a3,0x2
    80005b8a:	9736                	add	a4,a4,a3
    80005b8c:	00371693          	slli	a3,a4,0x3
    80005b90:	00026717          	auipc	a4,0x26
    80005b94:	20070713          	addi	a4,a4,512 # 8002bd90 <timer_scratch>
    80005b98:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005b9a:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80005b9c:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80005b9e:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80005ba2:	00000797          	auipc	a5,0x0
    80005ba6:	93e78793          	addi	a5,a5,-1730 # 800054e0 <timervec>
    80005baa:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005bae:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80005bb2:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005bb6:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005bba:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80005bbe:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80005bc2:	30479073          	csrw	mie,a5
}
    80005bc6:	6422                	ld	s0,8(sp)
    80005bc8:	0141                	addi	sp,sp,16
    80005bca:	8082                	ret

0000000080005bcc <start>:
{
    80005bcc:	1141                	addi	sp,sp,-16
    80005bce:	e406                	sd	ra,8(sp)
    80005bd0:	e022                	sd	s0,0(sp)
    80005bd2:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005bd4:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005bd8:	7779                	lui	a4,0xffffe
    80005bda:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffca82f>
    80005bde:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80005be0:	6705                	lui	a4,0x1
    80005be2:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005be6:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005be8:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005bec:	ffffa797          	auipc	a5,0xffffa
    80005bf0:	73a78793          	addi	a5,a5,1850 # 80000326 <main>
    80005bf4:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005bf8:	4781                	li	a5,0
    80005bfa:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005bfe:	67c1                	lui	a5,0x10
    80005c00:	17fd                	addi	a5,a5,-1
    80005c02:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005c06:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005c0a:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005c0e:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005c12:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005c16:	57fd                	li	a5,-1
    80005c18:	83a9                	srli	a5,a5,0xa
    80005c1a:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005c1e:	47bd                	li	a5,15
    80005c20:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005c24:	00000097          	auipc	ra,0x0
    80005c28:	f36080e7          	jalr	-202(ra) # 80005b5a <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005c2c:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005c30:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005c32:	823e                	mv	tp,a5
  asm volatile("mret");
    80005c34:	30200073          	mret
}
    80005c38:	60a2                	ld	ra,8(sp)
    80005c3a:	6402                	ld	s0,0(sp)
    80005c3c:	0141                	addi	sp,sp,16
    80005c3e:	8082                	ret

0000000080005c40 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005c40:	715d                	addi	sp,sp,-80
    80005c42:	e486                	sd	ra,72(sp)
    80005c44:	e0a2                	sd	s0,64(sp)
    80005c46:	fc26                	sd	s1,56(sp)
    80005c48:	f84a                	sd	s2,48(sp)
    80005c4a:	f44e                	sd	s3,40(sp)
    80005c4c:	f052                	sd	s4,32(sp)
    80005c4e:	ec56                	sd	s5,24(sp)
    80005c50:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005c52:	04c05663          	blez	a2,80005c9e <consolewrite+0x5e>
    80005c56:	8a2a                	mv	s4,a0
    80005c58:	84ae                	mv	s1,a1
    80005c5a:	89b2                	mv	s3,a2
    80005c5c:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005c5e:	5afd                	li	s5,-1
    80005c60:	4685                	li	a3,1
    80005c62:	8626                	mv	a2,s1
    80005c64:	85d2                	mv	a1,s4
    80005c66:	fbf40513          	addi	a0,s0,-65
    80005c6a:	ffffc097          	auipc	ra,0xffffc
    80005c6e:	cfa080e7          	jalr	-774(ra) # 80001964 <either_copyin>
    80005c72:	01550c63          	beq	a0,s5,80005c8a <consolewrite+0x4a>
      break;
    uartputc(c);
    80005c76:	fbf44503          	lbu	a0,-65(s0)
    80005c7a:	00000097          	auipc	ra,0x0
    80005c7e:	794080e7          	jalr	1940(ra) # 8000640e <uartputc>
  for(i = 0; i < n; i++){
    80005c82:	2905                	addiw	s2,s2,1
    80005c84:	0485                	addi	s1,s1,1
    80005c86:	fd299de3          	bne	s3,s2,80005c60 <consolewrite+0x20>
  }

  return i;
}
    80005c8a:	854a                	mv	a0,s2
    80005c8c:	60a6                	ld	ra,72(sp)
    80005c8e:	6406                	ld	s0,64(sp)
    80005c90:	74e2                	ld	s1,56(sp)
    80005c92:	7942                	ld	s2,48(sp)
    80005c94:	79a2                	ld	s3,40(sp)
    80005c96:	7a02                	ld	s4,32(sp)
    80005c98:	6ae2                	ld	s5,24(sp)
    80005c9a:	6161                	addi	sp,sp,80
    80005c9c:	8082                	ret
  for(i = 0; i < n; i++){
    80005c9e:	4901                	li	s2,0
    80005ca0:	b7ed                	j	80005c8a <consolewrite+0x4a>

0000000080005ca2 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005ca2:	7119                	addi	sp,sp,-128
    80005ca4:	fc86                	sd	ra,120(sp)
    80005ca6:	f8a2                	sd	s0,112(sp)
    80005ca8:	f4a6                	sd	s1,104(sp)
    80005caa:	f0ca                	sd	s2,96(sp)
    80005cac:	ecce                	sd	s3,88(sp)
    80005cae:	e8d2                	sd	s4,80(sp)
    80005cb0:	e4d6                	sd	s5,72(sp)
    80005cb2:	e0da                	sd	s6,64(sp)
    80005cb4:	fc5e                	sd	s7,56(sp)
    80005cb6:	f862                	sd	s8,48(sp)
    80005cb8:	f466                	sd	s9,40(sp)
    80005cba:	f06a                	sd	s10,32(sp)
    80005cbc:	ec6e                	sd	s11,24(sp)
    80005cbe:	0100                	addi	s0,sp,128
    80005cc0:	8b2a                	mv	s6,a0
    80005cc2:	8aae                	mv	s5,a1
    80005cc4:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005cc6:	00060b9b          	sext.w	s7,a2
  acquire(&cons.lock);
    80005cca:	0002e517          	auipc	a0,0x2e
    80005cce:	20650513          	addi	a0,a0,518 # 80033ed0 <cons>
    80005cd2:	00001097          	auipc	ra,0x1
    80005cd6:	8fa080e7          	jalr	-1798(ra) # 800065cc <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005cda:	0002e497          	auipc	s1,0x2e
    80005cde:	1f648493          	addi	s1,s1,502 # 80033ed0 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005ce2:	89a6                	mv	s3,s1
    80005ce4:	0002e917          	auipc	s2,0x2e
    80005ce8:	28490913          	addi	s2,s2,644 # 80033f68 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];

    if(c == C('D')){  // end-of-file
    80005cec:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005cee:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    80005cf0:	4da9                	li	s11,10
  while(n > 0){
    80005cf2:	07405b63          	blez	s4,80005d68 <consoleread+0xc6>
    while(cons.r == cons.w){
    80005cf6:	0984a783          	lw	a5,152(s1)
    80005cfa:	09c4a703          	lw	a4,156(s1)
    80005cfe:	02f71763          	bne	a4,a5,80005d2c <consoleread+0x8a>
      if(killed(myproc())){
    80005d02:	ffffb097          	auipc	ra,0xffffb
    80005d06:	160080e7          	jalr	352(ra) # 80000e62 <myproc>
    80005d0a:	ffffc097          	auipc	ra,0xffffc
    80005d0e:	aa4080e7          	jalr	-1372(ra) # 800017ae <killed>
    80005d12:	e535                	bnez	a0,80005d7e <consoleread+0xdc>
      sleep(&cons.r, &cons.lock);
    80005d14:	85ce                	mv	a1,s3
    80005d16:	854a                	mv	a0,s2
    80005d18:	ffffb097          	auipc	ra,0xffffb
    80005d1c:	7ee080e7          	jalr	2030(ra) # 80001506 <sleep>
    while(cons.r == cons.w){
    80005d20:	0984a783          	lw	a5,152(s1)
    80005d24:	09c4a703          	lw	a4,156(s1)
    80005d28:	fcf70de3          	beq	a4,a5,80005d02 <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80005d2c:	0017871b          	addiw	a4,a5,1
    80005d30:	08e4ac23          	sw	a4,152(s1)
    80005d34:	07f7f713          	andi	a4,a5,127
    80005d38:	9726                	add	a4,a4,s1
    80005d3a:	01874703          	lbu	a4,24(a4)
    80005d3e:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    80005d42:	079c0663          	beq	s8,s9,80005dae <consoleread+0x10c>
    cbuf = c;
    80005d46:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005d4a:	4685                	li	a3,1
    80005d4c:	f8f40613          	addi	a2,s0,-113
    80005d50:	85d6                	mv	a1,s5
    80005d52:	855a                	mv	a0,s6
    80005d54:	ffffc097          	auipc	ra,0xffffc
    80005d58:	bba080e7          	jalr	-1094(ra) # 8000190e <either_copyout>
    80005d5c:	01a50663          	beq	a0,s10,80005d68 <consoleread+0xc6>
    dst++;
    80005d60:	0a85                	addi	s5,s5,1
    --n;
    80005d62:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    80005d64:	f9bc17e3          	bne	s8,s11,80005cf2 <consoleread+0x50>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005d68:	0002e517          	auipc	a0,0x2e
    80005d6c:	16850513          	addi	a0,a0,360 # 80033ed0 <cons>
    80005d70:	00001097          	auipc	ra,0x1
    80005d74:	910080e7          	jalr	-1776(ra) # 80006680 <release>

  return target - n;
    80005d78:	414b853b          	subw	a0,s7,s4
    80005d7c:	a811                	j	80005d90 <consoleread+0xee>
        release(&cons.lock);
    80005d7e:	0002e517          	auipc	a0,0x2e
    80005d82:	15250513          	addi	a0,a0,338 # 80033ed0 <cons>
    80005d86:	00001097          	auipc	ra,0x1
    80005d8a:	8fa080e7          	jalr	-1798(ra) # 80006680 <release>
        return -1;
    80005d8e:	557d                	li	a0,-1
}
    80005d90:	70e6                	ld	ra,120(sp)
    80005d92:	7446                	ld	s0,112(sp)
    80005d94:	74a6                	ld	s1,104(sp)
    80005d96:	7906                	ld	s2,96(sp)
    80005d98:	69e6                	ld	s3,88(sp)
    80005d9a:	6a46                	ld	s4,80(sp)
    80005d9c:	6aa6                	ld	s5,72(sp)
    80005d9e:	6b06                	ld	s6,64(sp)
    80005da0:	7be2                	ld	s7,56(sp)
    80005da2:	7c42                	ld	s8,48(sp)
    80005da4:	7ca2                	ld	s9,40(sp)
    80005da6:	7d02                	ld	s10,32(sp)
    80005da8:	6de2                	ld	s11,24(sp)
    80005daa:	6109                	addi	sp,sp,128
    80005dac:	8082                	ret
      if(n < target){
    80005dae:	000a071b          	sext.w	a4,s4
    80005db2:	fb777be3          	bgeu	a4,s7,80005d68 <consoleread+0xc6>
        cons.r--;
    80005db6:	0002e717          	auipc	a4,0x2e
    80005dba:	1af72923          	sw	a5,434(a4) # 80033f68 <cons+0x98>
    80005dbe:	b76d                	j	80005d68 <consoleread+0xc6>

0000000080005dc0 <consputc>:
{
    80005dc0:	1141                	addi	sp,sp,-16
    80005dc2:	e406                	sd	ra,8(sp)
    80005dc4:	e022                	sd	s0,0(sp)
    80005dc6:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005dc8:	10000793          	li	a5,256
    80005dcc:	00f50a63          	beq	a0,a5,80005de0 <consputc+0x20>
    uartputc_sync(c);
    80005dd0:	00000097          	auipc	ra,0x0
    80005dd4:	564080e7          	jalr	1380(ra) # 80006334 <uartputc_sync>
}
    80005dd8:	60a2                	ld	ra,8(sp)
    80005dda:	6402                	ld	s0,0(sp)
    80005ddc:	0141                	addi	sp,sp,16
    80005dde:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005de0:	4521                	li	a0,8
    80005de2:	00000097          	auipc	ra,0x0
    80005de6:	552080e7          	jalr	1362(ra) # 80006334 <uartputc_sync>
    80005dea:	02000513          	li	a0,32
    80005dee:	00000097          	auipc	ra,0x0
    80005df2:	546080e7          	jalr	1350(ra) # 80006334 <uartputc_sync>
    80005df6:	4521                	li	a0,8
    80005df8:	00000097          	auipc	ra,0x0
    80005dfc:	53c080e7          	jalr	1340(ra) # 80006334 <uartputc_sync>
    80005e00:	bfe1                	j	80005dd8 <consputc+0x18>

0000000080005e02 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005e02:	1101                	addi	sp,sp,-32
    80005e04:	ec06                	sd	ra,24(sp)
    80005e06:	e822                	sd	s0,16(sp)
    80005e08:	e426                	sd	s1,8(sp)
    80005e0a:	e04a                	sd	s2,0(sp)
    80005e0c:	1000                	addi	s0,sp,32
    80005e0e:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005e10:	0002e517          	auipc	a0,0x2e
    80005e14:	0c050513          	addi	a0,a0,192 # 80033ed0 <cons>
    80005e18:	00000097          	auipc	ra,0x0
    80005e1c:	7b4080e7          	jalr	1972(ra) # 800065cc <acquire>

  switch(c){
    80005e20:	47d5                	li	a5,21
    80005e22:	0af48663          	beq	s1,a5,80005ece <consoleintr+0xcc>
    80005e26:	0297ca63          	blt	a5,s1,80005e5a <consoleintr+0x58>
    80005e2a:	47a1                	li	a5,8
    80005e2c:	0ef48763          	beq	s1,a5,80005f1a <consoleintr+0x118>
    80005e30:	47c1                	li	a5,16
    80005e32:	10f49a63          	bne	s1,a5,80005f46 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005e36:	ffffc097          	auipc	ra,0xffffc
    80005e3a:	b84080e7          	jalr	-1148(ra) # 800019ba <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005e3e:	0002e517          	auipc	a0,0x2e
    80005e42:	09250513          	addi	a0,a0,146 # 80033ed0 <cons>
    80005e46:	00001097          	auipc	ra,0x1
    80005e4a:	83a080e7          	jalr	-1990(ra) # 80006680 <release>
}
    80005e4e:	60e2                	ld	ra,24(sp)
    80005e50:	6442                	ld	s0,16(sp)
    80005e52:	64a2                	ld	s1,8(sp)
    80005e54:	6902                	ld	s2,0(sp)
    80005e56:	6105                	addi	sp,sp,32
    80005e58:	8082                	ret
  switch(c){
    80005e5a:	07f00793          	li	a5,127
    80005e5e:	0af48e63          	beq	s1,a5,80005f1a <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005e62:	0002e717          	auipc	a4,0x2e
    80005e66:	06e70713          	addi	a4,a4,110 # 80033ed0 <cons>
    80005e6a:	0a072783          	lw	a5,160(a4)
    80005e6e:	09872703          	lw	a4,152(a4)
    80005e72:	9f99                	subw	a5,a5,a4
    80005e74:	07f00713          	li	a4,127
    80005e78:	fcf763e3          	bltu	a4,a5,80005e3e <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005e7c:	47b5                	li	a5,13
    80005e7e:	0cf48763          	beq	s1,a5,80005f4c <consoleintr+0x14a>
      consputc(c);
    80005e82:	8526                	mv	a0,s1
    80005e84:	00000097          	auipc	ra,0x0
    80005e88:	f3c080e7          	jalr	-196(ra) # 80005dc0 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005e8c:	0002e797          	auipc	a5,0x2e
    80005e90:	04478793          	addi	a5,a5,68 # 80033ed0 <cons>
    80005e94:	0a07a683          	lw	a3,160(a5)
    80005e98:	0016871b          	addiw	a4,a3,1
    80005e9c:	0007061b          	sext.w	a2,a4
    80005ea0:	0ae7a023          	sw	a4,160(a5)
    80005ea4:	07f6f693          	andi	a3,a3,127
    80005ea8:	97b6                	add	a5,a5,a3
    80005eaa:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005eae:	47a9                	li	a5,10
    80005eb0:	0cf48563          	beq	s1,a5,80005f7a <consoleintr+0x178>
    80005eb4:	4791                	li	a5,4
    80005eb6:	0cf48263          	beq	s1,a5,80005f7a <consoleintr+0x178>
    80005eba:	0002e797          	auipc	a5,0x2e
    80005ebe:	0ae7a783          	lw	a5,174(a5) # 80033f68 <cons+0x98>
    80005ec2:	9f1d                	subw	a4,a4,a5
    80005ec4:	08000793          	li	a5,128
    80005ec8:	f6f71be3          	bne	a4,a5,80005e3e <consoleintr+0x3c>
    80005ecc:	a07d                	j	80005f7a <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005ece:	0002e717          	auipc	a4,0x2e
    80005ed2:	00270713          	addi	a4,a4,2 # 80033ed0 <cons>
    80005ed6:	0a072783          	lw	a5,160(a4)
    80005eda:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005ede:	0002e497          	auipc	s1,0x2e
    80005ee2:	ff248493          	addi	s1,s1,-14 # 80033ed0 <cons>
    while(cons.e != cons.w &&
    80005ee6:	4929                	li	s2,10
    80005ee8:	f4f70be3          	beq	a4,a5,80005e3e <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005eec:	37fd                	addiw	a5,a5,-1
    80005eee:	07f7f713          	andi	a4,a5,127
    80005ef2:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005ef4:	01874703          	lbu	a4,24(a4)
    80005ef8:	f52703e3          	beq	a4,s2,80005e3e <consoleintr+0x3c>
      cons.e--;
    80005efc:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005f00:	10000513          	li	a0,256
    80005f04:	00000097          	auipc	ra,0x0
    80005f08:	ebc080e7          	jalr	-324(ra) # 80005dc0 <consputc>
    while(cons.e != cons.w &&
    80005f0c:	0a04a783          	lw	a5,160(s1)
    80005f10:	09c4a703          	lw	a4,156(s1)
    80005f14:	fcf71ce3          	bne	a4,a5,80005eec <consoleintr+0xea>
    80005f18:	b71d                	j	80005e3e <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005f1a:	0002e717          	auipc	a4,0x2e
    80005f1e:	fb670713          	addi	a4,a4,-74 # 80033ed0 <cons>
    80005f22:	0a072783          	lw	a5,160(a4)
    80005f26:	09c72703          	lw	a4,156(a4)
    80005f2a:	f0f70ae3          	beq	a4,a5,80005e3e <consoleintr+0x3c>
      cons.e--;
    80005f2e:	37fd                	addiw	a5,a5,-1
    80005f30:	0002e717          	auipc	a4,0x2e
    80005f34:	04f72023          	sw	a5,64(a4) # 80033f70 <cons+0xa0>
      consputc(BACKSPACE);
    80005f38:	10000513          	li	a0,256
    80005f3c:	00000097          	auipc	ra,0x0
    80005f40:	e84080e7          	jalr	-380(ra) # 80005dc0 <consputc>
    80005f44:	bded                	j	80005e3e <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005f46:	ee048ce3          	beqz	s1,80005e3e <consoleintr+0x3c>
    80005f4a:	bf21                	j	80005e62 <consoleintr+0x60>
      consputc(c);
    80005f4c:	4529                	li	a0,10
    80005f4e:	00000097          	auipc	ra,0x0
    80005f52:	e72080e7          	jalr	-398(ra) # 80005dc0 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005f56:	0002e797          	auipc	a5,0x2e
    80005f5a:	f7a78793          	addi	a5,a5,-134 # 80033ed0 <cons>
    80005f5e:	0a07a703          	lw	a4,160(a5)
    80005f62:	0017069b          	addiw	a3,a4,1
    80005f66:	0006861b          	sext.w	a2,a3
    80005f6a:	0ad7a023          	sw	a3,160(a5)
    80005f6e:	07f77713          	andi	a4,a4,127
    80005f72:	97ba                	add	a5,a5,a4
    80005f74:	4729                	li	a4,10
    80005f76:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005f7a:	0002e797          	auipc	a5,0x2e
    80005f7e:	fec7a923          	sw	a2,-14(a5) # 80033f6c <cons+0x9c>
        wakeup(&cons.r);
    80005f82:	0002e517          	auipc	a0,0x2e
    80005f86:	fe650513          	addi	a0,a0,-26 # 80033f68 <cons+0x98>
    80005f8a:	ffffb097          	auipc	ra,0xffffb
    80005f8e:	5e0080e7          	jalr	1504(ra) # 8000156a <wakeup>
    80005f92:	b575                	j	80005e3e <consoleintr+0x3c>

0000000080005f94 <consoleinit>:

void
consoleinit(void)
{
    80005f94:	1141                	addi	sp,sp,-16
    80005f96:	e406                	sd	ra,8(sp)
    80005f98:	e022                	sd	s0,0(sp)
    80005f9a:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005f9c:	00003597          	auipc	a1,0x3
    80005fa0:	aa458593          	addi	a1,a1,-1372 # 80008a40 <syscalls+0x5e8>
    80005fa4:	0002e517          	auipc	a0,0x2e
    80005fa8:	f2c50513          	addi	a0,a0,-212 # 80033ed0 <cons>
    80005fac:	00000097          	auipc	ra,0x0
    80005fb0:	590080e7          	jalr	1424(ra) # 8000653c <initlock>

  uartinit();
    80005fb4:	00000097          	auipc	ra,0x0
    80005fb8:	330080e7          	jalr	816(ra) # 800062e4 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005fbc:	00025797          	auipc	a5,0x25
    80005fc0:	c3c78793          	addi	a5,a5,-964 # 8002abf8 <devsw>
    80005fc4:	00000717          	auipc	a4,0x0
    80005fc8:	cde70713          	addi	a4,a4,-802 # 80005ca2 <consoleread>
    80005fcc:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005fce:	00000717          	auipc	a4,0x0
    80005fd2:	c7270713          	addi	a4,a4,-910 # 80005c40 <consolewrite>
    80005fd6:	ef98                	sd	a4,24(a5)
}
    80005fd8:	60a2                	ld	ra,8(sp)
    80005fda:	6402                	ld	s0,0(sp)
    80005fdc:	0141                	addi	sp,sp,16
    80005fde:	8082                	ret

0000000080005fe0 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005fe0:	7179                	addi	sp,sp,-48
    80005fe2:	f406                	sd	ra,40(sp)
    80005fe4:	f022                	sd	s0,32(sp)
    80005fe6:	ec26                	sd	s1,24(sp)
    80005fe8:	e84a                	sd	s2,16(sp)
    80005fea:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005fec:	c219                	beqz	a2,80005ff2 <printint+0x12>
    80005fee:	08054663          	bltz	a0,8000607a <printint+0x9a>
    x = -xx;
  else
    x = xx;
    80005ff2:	2501                	sext.w	a0,a0
    80005ff4:	4881                	li	a7,0
    80005ff6:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005ffa:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005ffc:	2581                	sext.w	a1,a1
    80005ffe:	00003617          	auipc	a2,0x3
    80006002:	a7260613          	addi	a2,a2,-1422 # 80008a70 <digits>
    80006006:	883a                	mv	a6,a4
    80006008:	2705                	addiw	a4,a4,1
    8000600a:	02b577bb          	remuw	a5,a0,a1
    8000600e:	1782                	slli	a5,a5,0x20
    80006010:	9381                	srli	a5,a5,0x20
    80006012:	97b2                	add	a5,a5,a2
    80006014:	0007c783          	lbu	a5,0(a5)
    80006018:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    8000601c:	0005079b          	sext.w	a5,a0
    80006020:	02b5553b          	divuw	a0,a0,a1
    80006024:	0685                	addi	a3,a3,1
    80006026:	feb7f0e3          	bgeu	a5,a1,80006006 <printint+0x26>

  if(sign)
    8000602a:	00088b63          	beqz	a7,80006040 <printint+0x60>
    buf[i++] = '-';
    8000602e:	fe040793          	addi	a5,s0,-32
    80006032:	973e                	add	a4,a4,a5
    80006034:	02d00793          	li	a5,45
    80006038:	fef70823          	sb	a5,-16(a4)
    8000603c:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80006040:	02e05763          	blez	a4,8000606e <printint+0x8e>
    80006044:	fd040793          	addi	a5,s0,-48
    80006048:	00e784b3          	add	s1,a5,a4
    8000604c:	fff78913          	addi	s2,a5,-1
    80006050:	993a                	add	s2,s2,a4
    80006052:	377d                	addiw	a4,a4,-1
    80006054:	1702                	slli	a4,a4,0x20
    80006056:	9301                	srli	a4,a4,0x20
    80006058:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    8000605c:	fff4c503          	lbu	a0,-1(s1)
    80006060:	00000097          	auipc	ra,0x0
    80006064:	d60080e7          	jalr	-672(ra) # 80005dc0 <consputc>
  while(--i >= 0)
    80006068:	14fd                	addi	s1,s1,-1
    8000606a:	ff2499e3          	bne	s1,s2,8000605c <printint+0x7c>
}
    8000606e:	70a2                	ld	ra,40(sp)
    80006070:	7402                	ld	s0,32(sp)
    80006072:	64e2                	ld	s1,24(sp)
    80006074:	6942                	ld	s2,16(sp)
    80006076:	6145                	addi	sp,sp,48
    80006078:	8082                	ret
    x = -xx;
    8000607a:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    8000607e:	4885                	li	a7,1
    x = -xx;
    80006080:	bf9d                	j	80005ff6 <printint+0x16>

0000000080006082 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80006082:	1101                	addi	sp,sp,-32
    80006084:	ec06                	sd	ra,24(sp)
    80006086:	e822                	sd	s0,16(sp)
    80006088:	e426                	sd	s1,8(sp)
    8000608a:	1000                	addi	s0,sp,32
    8000608c:	84aa                	mv	s1,a0
  pr.locking = 0;
    8000608e:	0002e797          	auipc	a5,0x2e
    80006092:	f007a123          	sw	zero,-254(a5) # 80033f90 <pr+0x18>
  printf("panic: ");
    80006096:	00003517          	auipc	a0,0x3
    8000609a:	9b250513          	addi	a0,a0,-1614 # 80008a48 <syscalls+0x5f0>
    8000609e:	00000097          	auipc	ra,0x0
    800060a2:	02e080e7          	jalr	46(ra) # 800060cc <printf>
  printf(s);
    800060a6:	8526                	mv	a0,s1
    800060a8:	00000097          	auipc	ra,0x0
    800060ac:	024080e7          	jalr	36(ra) # 800060cc <printf>
  printf("\n");
    800060b0:	00002517          	auipc	a0,0x2
    800060b4:	f9850513          	addi	a0,a0,-104 # 80008048 <etext+0x48>
    800060b8:	00000097          	auipc	ra,0x0
    800060bc:	014080e7          	jalr	20(ra) # 800060cc <printf>
  panicked = 1; // freeze uart output from other CPUs
    800060c0:	4785                	li	a5,1
    800060c2:	00003717          	auipc	a4,0x3
    800060c6:	a8f72523          	sw	a5,-1398(a4) # 80008b4c <panicked>
  for(;;)
    800060ca:	a001                	j	800060ca <panic+0x48>

00000000800060cc <printf>:
{
    800060cc:	7131                	addi	sp,sp,-192
    800060ce:	fc86                	sd	ra,120(sp)
    800060d0:	f8a2                	sd	s0,112(sp)
    800060d2:	f4a6                	sd	s1,104(sp)
    800060d4:	f0ca                	sd	s2,96(sp)
    800060d6:	ecce                	sd	s3,88(sp)
    800060d8:	e8d2                	sd	s4,80(sp)
    800060da:	e4d6                	sd	s5,72(sp)
    800060dc:	e0da                	sd	s6,64(sp)
    800060de:	fc5e                	sd	s7,56(sp)
    800060e0:	f862                	sd	s8,48(sp)
    800060e2:	f466                	sd	s9,40(sp)
    800060e4:	f06a                	sd	s10,32(sp)
    800060e6:	ec6e                	sd	s11,24(sp)
    800060e8:	0100                	addi	s0,sp,128
    800060ea:	8a2a                	mv	s4,a0
    800060ec:	e40c                	sd	a1,8(s0)
    800060ee:	e810                	sd	a2,16(s0)
    800060f0:	ec14                	sd	a3,24(s0)
    800060f2:	f018                	sd	a4,32(s0)
    800060f4:	f41c                	sd	a5,40(s0)
    800060f6:	03043823          	sd	a6,48(s0)
    800060fa:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    800060fe:	0002ed97          	auipc	s11,0x2e
    80006102:	e92dad83          	lw	s11,-366(s11) # 80033f90 <pr+0x18>
  if(locking)
    80006106:	020d9b63          	bnez	s11,8000613c <printf+0x70>
  if (fmt == 0)
    8000610a:	040a0263          	beqz	s4,8000614e <printf+0x82>
  va_start(ap, fmt);
    8000610e:	00840793          	addi	a5,s0,8
    80006112:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80006116:	000a4503          	lbu	a0,0(s4)
    8000611a:	16050263          	beqz	a0,8000627e <printf+0x1b2>
    8000611e:	4481                	li	s1,0
    if(c != '%'){
    80006120:	02500a93          	li	s5,37
    switch(c){
    80006124:	07000b13          	li	s6,112
  consputc('x');
    80006128:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    8000612a:	00003b97          	auipc	s7,0x3
    8000612e:	946b8b93          	addi	s7,s7,-1722 # 80008a70 <digits>
    switch(c){
    80006132:	07300c93          	li	s9,115
    80006136:	06400c13          	li	s8,100
    8000613a:	a82d                	j	80006174 <printf+0xa8>
    acquire(&pr.lock);
    8000613c:	0002e517          	auipc	a0,0x2e
    80006140:	e3c50513          	addi	a0,a0,-452 # 80033f78 <pr>
    80006144:	00000097          	auipc	ra,0x0
    80006148:	488080e7          	jalr	1160(ra) # 800065cc <acquire>
    8000614c:	bf7d                	j	8000610a <printf+0x3e>
    panic("null fmt");
    8000614e:	00003517          	auipc	a0,0x3
    80006152:	90a50513          	addi	a0,a0,-1782 # 80008a58 <syscalls+0x600>
    80006156:	00000097          	auipc	ra,0x0
    8000615a:	f2c080e7          	jalr	-212(ra) # 80006082 <panic>
      consputc(c);
    8000615e:	00000097          	auipc	ra,0x0
    80006162:	c62080e7          	jalr	-926(ra) # 80005dc0 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80006166:	2485                	addiw	s1,s1,1
    80006168:	009a07b3          	add	a5,s4,s1
    8000616c:	0007c503          	lbu	a0,0(a5)
    80006170:	10050763          	beqz	a0,8000627e <printf+0x1b2>
    if(c != '%'){
    80006174:	ff5515e3          	bne	a0,s5,8000615e <printf+0x92>
    c = fmt[++i] & 0xff;
    80006178:	2485                	addiw	s1,s1,1
    8000617a:	009a07b3          	add	a5,s4,s1
    8000617e:	0007c783          	lbu	a5,0(a5)
    80006182:	0007891b          	sext.w	s2,a5
    if(c == 0)
    80006186:	cfe5                	beqz	a5,8000627e <printf+0x1b2>
    switch(c){
    80006188:	05678a63          	beq	a5,s6,800061dc <printf+0x110>
    8000618c:	02fb7663          	bgeu	s6,a5,800061b8 <printf+0xec>
    80006190:	09978963          	beq	a5,s9,80006222 <printf+0x156>
    80006194:	07800713          	li	a4,120
    80006198:	0ce79863          	bne	a5,a4,80006268 <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    8000619c:	f8843783          	ld	a5,-120(s0)
    800061a0:	00878713          	addi	a4,a5,8
    800061a4:	f8e43423          	sd	a4,-120(s0)
    800061a8:	4605                	li	a2,1
    800061aa:	85ea                	mv	a1,s10
    800061ac:	4388                	lw	a0,0(a5)
    800061ae:	00000097          	auipc	ra,0x0
    800061b2:	e32080e7          	jalr	-462(ra) # 80005fe0 <printint>
      break;
    800061b6:	bf45                	j	80006166 <printf+0x9a>
    switch(c){
    800061b8:	0b578263          	beq	a5,s5,8000625c <printf+0x190>
    800061bc:	0b879663          	bne	a5,s8,80006268 <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    800061c0:	f8843783          	ld	a5,-120(s0)
    800061c4:	00878713          	addi	a4,a5,8
    800061c8:	f8e43423          	sd	a4,-120(s0)
    800061cc:	4605                	li	a2,1
    800061ce:	45a9                	li	a1,10
    800061d0:	4388                	lw	a0,0(a5)
    800061d2:	00000097          	auipc	ra,0x0
    800061d6:	e0e080e7          	jalr	-498(ra) # 80005fe0 <printint>
      break;
    800061da:	b771                	j	80006166 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    800061dc:	f8843783          	ld	a5,-120(s0)
    800061e0:	00878713          	addi	a4,a5,8
    800061e4:	f8e43423          	sd	a4,-120(s0)
    800061e8:	0007b983          	ld	s3,0(a5)
  consputc('0');
    800061ec:	03000513          	li	a0,48
    800061f0:	00000097          	auipc	ra,0x0
    800061f4:	bd0080e7          	jalr	-1072(ra) # 80005dc0 <consputc>
  consputc('x');
    800061f8:	07800513          	li	a0,120
    800061fc:	00000097          	auipc	ra,0x0
    80006200:	bc4080e7          	jalr	-1084(ra) # 80005dc0 <consputc>
    80006204:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80006206:	03c9d793          	srli	a5,s3,0x3c
    8000620a:	97de                	add	a5,a5,s7
    8000620c:	0007c503          	lbu	a0,0(a5)
    80006210:	00000097          	auipc	ra,0x0
    80006214:	bb0080e7          	jalr	-1104(ra) # 80005dc0 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80006218:	0992                	slli	s3,s3,0x4
    8000621a:	397d                	addiw	s2,s2,-1
    8000621c:	fe0915e3          	bnez	s2,80006206 <printf+0x13a>
    80006220:	b799                	j	80006166 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80006222:	f8843783          	ld	a5,-120(s0)
    80006226:	00878713          	addi	a4,a5,8
    8000622a:	f8e43423          	sd	a4,-120(s0)
    8000622e:	0007b903          	ld	s2,0(a5)
    80006232:	00090e63          	beqz	s2,8000624e <printf+0x182>
      for(; *s; s++)
    80006236:	00094503          	lbu	a0,0(s2)
    8000623a:	d515                	beqz	a0,80006166 <printf+0x9a>
        consputc(*s);
    8000623c:	00000097          	auipc	ra,0x0
    80006240:	b84080e7          	jalr	-1148(ra) # 80005dc0 <consputc>
      for(; *s; s++)
    80006244:	0905                	addi	s2,s2,1
    80006246:	00094503          	lbu	a0,0(s2)
    8000624a:	f96d                	bnez	a0,8000623c <printf+0x170>
    8000624c:	bf29                	j	80006166 <printf+0x9a>
        s = "(null)";
    8000624e:	00003917          	auipc	s2,0x3
    80006252:	80290913          	addi	s2,s2,-2046 # 80008a50 <syscalls+0x5f8>
      for(; *s; s++)
    80006256:	02800513          	li	a0,40
    8000625a:	b7cd                	j	8000623c <printf+0x170>
      consputc('%');
    8000625c:	8556                	mv	a0,s5
    8000625e:	00000097          	auipc	ra,0x0
    80006262:	b62080e7          	jalr	-1182(ra) # 80005dc0 <consputc>
      break;
    80006266:	b701                	j	80006166 <printf+0x9a>
      consputc('%');
    80006268:	8556                	mv	a0,s5
    8000626a:	00000097          	auipc	ra,0x0
    8000626e:	b56080e7          	jalr	-1194(ra) # 80005dc0 <consputc>
      consputc(c);
    80006272:	854a                	mv	a0,s2
    80006274:	00000097          	auipc	ra,0x0
    80006278:	b4c080e7          	jalr	-1204(ra) # 80005dc0 <consputc>
      break;
    8000627c:	b5ed                	j	80006166 <printf+0x9a>
  if(locking)
    8000627e:	020d9163          	bnez	s11,800062a0 <printf+0x1d4>
}
    80006282:	70e6                	ld	ra,120(sp)
    80006284:	7446                	ld	s0,112(sp)
    80006286:	74a6                	ld	s1,104(sp)
    80006288:	7906                	ld	s2,96(sp)
    8000628a:	69e6                	ld	s3,88(sp)
    8000628c:	6a46                	ld	s4,80(sp)
    8000628e:	6aa6                	ld	s5,72(sp)
    80006290:	6b06                	ld	s6,64(sp)
    80006292:	7be2                	ld	s7,56(sp)
    80006294:	7c42                	ld	s8,48(sp)
    80006296:	7ca2                	ld	s9,40(sp)
    80006298:	7d02                	ld	s10,32(sp)
    8000629a:	6de2                	ld	s11,24(sp)
    8000629c:	6129                	addi	sp,sp,192
    8000629e:	8082                	ret
    release(&pr.lock);
    800062a0:	0002e517          	auipc	a0,0x2e
    800062a4:	cd850513          	addi	a0,a0,-808 # 80033f78 <pr>
    800062a8:	00000097          	auipc	ra,0x0
    800062ac:	3d8080e7          	jalr	984(ra) # 80006680 <release>
}
    800062b0:	bfc9                	j	80006282 <printf+0x1b6>

00000000800062b2 <printfinit>:
    ;
}

void
printfinit(void)
{
    800062b2:	1101                	addi	sp,sp,-32
    800062b4:	ec06                	sd	ra,24(sp)
    800062b6:	e822                	sd	s0,16(sp)
    800062b8:	e426                	sd	s1,8(sp)
    800062ba:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    800062bc:	0002e497          	auipc	s1,0x2e
    800062c0:	cbc48493          	addi	s1,s1,-836 # 80033f78 <pr>
    800062c4:	00002597          	auipc	a1,0x2
    800062c8:	7a458593          	addi	a1,a1,1956 # 80008a68 <syscalls+0x610>
    800062cc:	8526                	mv	a0,s1
    800062ce:	00000097          	auipc	ra,0x0
    800062d2:	26e080e7          	jalr	622(ra) # 8000653c <initlock>
  pr.locking = 1;
    800062d6:	4785                	li	a5,1
    800062d8:	cc9c                	sw	a5,24(s1)
}
    800062da:	60e2                	ld	ra,24(sp)
    800062dc:	6442                	ld	s0,16(sp)
    800062de:	64a2                	ld	s1,8(sp)
    800062e0:	6105                	addi	sp,sp,32
    800062e2:	8082                	ret

00000000800062e4 <uartinit>:

void uartstart();

void
uartinit(void)
{
    800062e4:	1141                	addi	sp,sp,-16
    800062e6:	e406                	sd	ra,8(sp)
    800062e8:	e022                	sd	s0,0(sp)
    800062ea:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800062ec:	100007b7          	lui	a5,0x10000
    800062f0:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800062f4:	f8000713          	li	a4,-128
    800062f8:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800062fc:	470d                	li	a4,3
    800062fe:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80006302:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80006306:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    8000630a:	469d                	li	a3,7
    8000630c:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80006310:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80006314:	00002597          	auipc	a1,0x2
    80006318:	77458593          	addi	a1,a1,1908 # 80008a88 <digits+0x18>
    8000631c:	0002e517          	auipc	a0,0x2e
    80006320:	c7c50513          	addi	a0,a0,-900 # 80033f98 <uart_tx_lock>
    80006324:	00000097          	auipc	ra,0x0
    80006328:	218080e7          	jalr	536(ra) # 8000653c <initlock>
}
    8000632c:	60a2                	ld	ra,8(sp)
    8000632e:	6402                	ld	s0,0(sp)
    80006330:	0141                	addi	sp,sp,16
    80006332:	8082                	ret

0000000080006334 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80006334:	1101                	addi	sp,sp,-32
    80006336:	ec06                	sd	ra,24(sp)
    80006338:	e822                	sd	s0,16(sp)
    8000633a:	e426                	sd	s1,8(sp)
    8000633c:	1000                	addi	s0,sp,32
    8000633e:	84aa                	mv	s1,a0
  push_off();
    80006340:	00000097          	auipc	ra,0x0
    80006344:	240080e7          	jalr	576(ra) # 80006580 <push_off>

  if(panicked){
    80006348:	00003797          	auipc	a5,0x3
    8000634c:	8047a783          	lw	a5,-2044(a5) # 80008b4c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006350:	10000737          	lui	a4,0x10000
  if(panicked){
    80006354:	c391                	beqz	a5,80006358 <uartputc_sync+0x24>
    for(;;)
    80006356:	a001                	j	80006356 <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006358:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    8000635c:	0ff7f793          	andi	a5,a5,255
    80006360:	0207f793          	andi	a5,a5,32
    80006364:	dbf5                	beqz	a5,80006358 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80006366:	0ff4f793          	andi	a5,s1,255
    8000636a:	10000737          	lui	a4,0x10000
    8000636e:	00f70023          	sb	a5,0(a4) # 10000000 <_entry-0x70000000>

  pop_off();
    80006372:	00000097          	auipc	ra,0x0
    80006376:	2ae080e7          	jalr	686(ra) # 80006620 <pop_off>
}
    8000637a:	60e2                	ld	ra,24(sp)
    8000637c:	6442                	ld	s0,16(sp)
    8000637e:	64a2                	ld	s1,8(sp)
    80006380:	6105                	addi	sp,sp,32
    80006382:	8082                	ret

0000000080006384 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80006384:	00002717          	auipc	a4,0x2
    80006388:	7cc73703          	ld	a4,1996(a4) # 80008b50 <uart_tx_r>
    8000638c:	00002797          	auipc	a5,0x2
    80006390:	7cc7b783          	ld	a5,1996(a5) # 80008b58 <uart_tx_w>
    80006394:	06e78c63          	beq	a5,a4,8000640c <uartstart+0x88>
{
    80006398:	7139                	addi	sp,sp,-64
    8000639a:	fc06                	sd	ra,56(sp)
    8000639c:	f822                	sd	s0,48(sp)
    8000639e:	f426                	sd	s1,40(sp)
    800063a0:	f04a                	sd	s2,32(sp)
    800063a2:	ec4e                	sd	s3,24(sp)
    800063a4:	e852                	sd	s4,16(sp)
    800063a6:	e456                	sd	s5,8(sp)
    800063a8:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800063aa:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800063ae:	0002ea17          	auipc	s4,0x2e
    800063b2:	beaa0a13          	addi	s4,s4,-1046 # 80033f98 <uart_tx_lock>
    uart_tx_r += 1;
    800063b6:	00002497          	auipc	s1,0x2
    800063ba:	79a48493          	addi	s1,s1,1946 # 80008b50 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    800063be:	00002997          	auipc	s3,0x2
    800063c2:	79a98993          	addi	s3,s3,1946 # 80008b58 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800063c6:	00594783          	lbu	a5,5(s2) # 10000005 <_entry-0x6ffffffb>
    800063ca:	0ff7f793          	andi	a5,a5,255
    800063ce:	0207f793          	andi	a5,a5,32
    800063d2:	c785                	beqz	a5,800063fa <uartstart+0x76>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800063d4:	01f77793          	andi	a5,a4,31
    800063d8:	97d2                	add	a5,a5,s4
    800063da:	0187ca83          	lbu	s5,24(a5)
    uart_tx_r += 1;
    800063de:	0705                	addi	a4,a4,1
    800063e0:	e098                	sd	a4,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    800063e2:	8526                	mv	a0,s1
    800063e4:	ffffb097          	auipc	ra,0xffffb
    800063e8:	186080e7          	jalr	390(ra) # 8000156a <wakeup>
    
    WriteReg(THR, c);
    800063ec:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    800063f0:	6098                	ld	a4,0(s1)
    800063f2:	0009b783          	ld	a5,0(s3)
    800063f6:	fce798e3          	bne	a5,a4,800063c6 <uartstart+0x42>
  }
}
    800063fa:	70e2                	ld	ra,56(sp)
    800063fc:	7442                	ld	s0,48(sp)
    800063fe:	74a2                	ld	s1,40(sp)
    80006400:	7902                	ld	s2,32(sp)
    80006402:	69e2                	ld	s3,24(sp)
    80006404:	6a42                	ld	s4,16(sp)
    80006406:	6aa2                	ld	s5,8(sp)
    80006408:	6121                	addi	sp,sp,64
    8000640a:	8082                	ret
    8000640c:	8082                	ret

000000008000640e <uartputc>:
{
    8000640e:	7179                	addi	sp,sp,-48
    80006410:	f406                	sd	ra,40(sp)
    80006412:	f022                	sd	s0,32(sp)
    80006414:	ec26                	sd	s1,24(sp)
    80006416:	e84a                	sd	s2,16(sp)
    80006418:	e44e                	sd	s3,8(sp)
    8000641a:	e052                	sd	s4,0(sp)
    8000641c:	1800                	addi	s0,sp,48
    8000641e:	89aa                	mv	s3,a0
  acquire(&uart_tx_lock);
    80006420:	0002e517          	auipc	a0,0x2e
    80006424:	b7850513          	addi	a0,a0,-1160 # 80033f98 <uart_tx_lock>
    80006428:	00000097          	auipc	ra,0x0
    8000642c:	1a4080e7          	jalr	420(ra) # 800065cc <acquire>
  if(panicked){
    80006430:	00002797          	auipc	a5,0x2
    80006434:	71c7a783          	lw	a5,1820(a5) # 80008b4c <panicked>
    80006438:	e7c9                	bnez	a5,800064c2 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000643a:	00002797          	auipc	a5,0x2
    8000643e:	71e7b783          	ld	a5,1822(a5) # 80008b58 <uart_tx_w>
    80006442:	00002717          	auipc	a4,0x2
    80006446:	70e73703          	ld	a4,1806(a4) # 80008b50 <uart_tx_r>
    8000644a:	02070713          	addi	a4,a4,32
    sleep(&uart_tx_r, &uart_tx_lock);
    8000644e:	0002ea17          	auipc	s4,0x2e
    80006452:	b4aa0a13          	addi	s4,s4,-1206 # 80033f98 <uart_tx_lock>
    80006456:	00002497          	auipc	s1,0x2
    8000645a:	6fa48493          	addi	s1,s1,1786 # 80008b50 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000645e:	00002917          	auipc	s2,0x2
    80006462:	6fa90913          	addi	s2,s2,1786 # 80008b58 <uart_tx_w>
    80006466:	00f71f63          	bne	a4,a5,80006484 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    8000646a:	85d2                	mv	a1,s4
    8000646c:	8526                	mv	a0,s1
    8000646e:	ffffb097          	auipc	ra,0xffffb
    80006472:	098080e7          	jalr	152(ra) # 80001506 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006476:	00093783          	ld	a5,0(s2)
    8000647a:	6098                	ld	a4,0(s1)
    8000647c:	02070713          	addi	a4,a4,32
    80006480:	fef705e3          	beq	a4,a5,8000646a <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80006484:	0002e497          	auipc	s1,0x2e
    80006488:	b1448493          	addi	s1,s1,-1260 # 80033f98 <uart_tx_lock>
    8000648c:	01f7f713          	andi	a4,a5,31
    80006490:	9726                	add	a4,a4,s1
    80006492:	01370c23          	sb	s3,24(a4)
  uart_tx_w += 1;
    80006496:	0785                	addi	a5,a5,1
    80006498:	00002717          	auipc	a4,0x2
    8000649c:	6cf73023          	sd	a5,1728(a4) # 80008b58 <uart_tx_w>
  uartstart();
    800064a0:	00000097          	auipc	ra,0x0
    800064a4:	ee4080e7          	jalr	-284(ra) # 80006384 <uartstart>
  release(&uart_tx_lock);
    800064a8:	8526                	mv	a0,s1
    800064aa:	00000097          	auipc	ra,0x0
    800064ae:	1d6080e7          	jalr	470(ra) # 80006680 <release>
}
    800064b2:	70a2                	ld	ra,40(sp)
    800064b4:	7402                	ld	s0,32(sp)
    800064b6:	64e2                	ld	s1,24(sp)
    800064b8:	6942                	ld	s2,16(sp)
    800064ba:	69a2                	ld	s3,8(sp)
    800064bc:	6a02                	ld	s4,0(sp)
    800064be:	6145                	addi	sp,sp,48
    800064c0:	8082                	ret
    for(;;)
    800064c2:	a001                	j	800064c2 <uartputc+0xb4>

00000000800064c4 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800064c4:	1141                	addi	sp,sp,-16
    800064c6:	e422                	sd	s0,8(sp)
    800064c8:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800064ca:	100007b7          	lui	a5,0x10000
    800064ce:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800064d2:	8b85                	andi	a5,a5,1
    800064d4:	cb91                	beqz	a5,800064e8 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    800064d6:	100007b7          	lui	a5,0x10000
    800064da:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    800064de:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    800064e2:	6422                	ld	s0,8(sp)
    800064e4:	0141                	addi	sp,sp,16
    800064e6:	8082                	ret
    return -1;
    800064e8:	557d                	li	a0,-1
    800064ea:	bfe5                	j	800064e2 <uartgetc+0x1e>

00000000800064ec <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    800064ec:	1101                	addi	sp,sp,-32
    800064ee:	ec06                	sd	ra,24(sp)
    800064f0:	e822                	sd	s0,16(sp)
    800064f2:	e426                	sd	s1,8(sp)
    800064f4:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800064f6:	54fd                	li	s1,-1
    int c = uartgetc();
    800064f8:	00000097          	auipc	ra,0x0
    800064fc:	fcc080e7          	jalr	-52(ra) # 800064c4 <uartgetc>
    if(c == -1)
    80006500:	00950763          	beq	a0,s1,8000650e <uartintr+0x22>
      break;
    consoleintr(c);
    80006504:	00000097          	auipc	ra,0x0
    80006508:	8fe080e7          	jalr	-1794(ra) # 80005e02 <consoleintr>
  while(1){
    8000650c:	b7f5                	j	800064f8 <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    8000650e:	0002e497          	auipc	s1,0x2e
    80006512:	a8a48493          	addi	s1,s1,-1398 # 80033f98 <uart_tx_lock>
    80006516:	8526                	mv	a0,s1
    80006518:	00000097          	auipc	ra,0x0
    8000651c:	0b4080e7          	jalr	180(ra) # 800065cc <acquire>
  uartstart();
    80006520:	00000097          	auipc	ra,0x0
    80006524:	e64080e7          	jalr	-412(ra) # 80006384 <uartstart>
  release(&uart_tx_lock);
    80006528:	8526                	mv	a0,s1
    8000652a:	00000097          	auipc	ra,0x0
    8000652e:	156080e7          	jalr	342(ra) # 80006680 <release>
}
    80006532:	60e2                	ld	ra,24(sp)
    80006534:	6442                	ld	s0,16(sp)
    80006536:	64a2                	ld	s1,8(sp)
    80006538:	6105                	addi	sp,sp,32
    8000653a:	8082                	ret

000000008000653c <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    8000653c:	1141                	addi	sp,sp,-16
    8000653e:	e422                	sd	s0,8(sp)
    80006540:	0800                	addi	s0,sp,16
  lk->name = name;
    80006542:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80006544:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80006548:	00053823          	sd	zero,16(a0)
}
    8000654c:	6422                	ld	s0,8(sp)
    8000654e:	0141                	addi	sp,sp,16
    80006550:	8082                	ret

0000000080006552 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80006552:	411c                	lw	a5,0(a0)
    80006554:	e399                	bnez	a5,8000655a <holding+0x8>
    80006556:	4501                	li	a0,0
  return r;
}
    80006558:	8082                	ret
{
    8000655a:	1101                	addi	sp,sp,-32
    8000655c:	ec06                	sd	ra,24(sp)
    8000655e:	e822                	sd	s0,16(sp)
    80006560:	e426                	sd	s1,8(sp)
    80006562:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80006564:	6904                	ld	s1,16(a0)
    80006566:	ffffb097          	auipc	ra,0xffffb
    8000656a:	8e0080e7          	jalr	-1824(ra) # 80000e46 <mycpu>
    8000656e:	40a48533          	sub	a0,s1,a0
    80006572:	00153513          	seqz	a0,a0
}
    80006576:	60e2                	ld	ra,24(sp)
    80006578:	6442                	ld	s0,16(sp)
    8000657a:	64a2                	ld	s1,8(sp)
    8000657c:	6105                	addi	sp,sp,32
    8000657e:	8082                	ret

0000000080006580 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80006580:	1101                	addi	sp,sp,-32
    80006582:	ec06                	sd	ra,24(sp)
    80006584:	e822                	sd	s0,16(sp)
    80006586:	e426                	sd	s1,8(sp)
    80006588:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000658a:	100024f3          	csrr	s1,sstatus
    8000658e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80006592:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006594:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80006598:	ffffb097          	auipc	ra,0xffffb
    8000659c:	8ae080e7          	jalr	-1874(ra) # 80000e46 <mycpu>
    800065a0:	5d3c                	lw	a5,120(a0)
    800065a2:	cf89                	beqz	a5,800065bc <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800065a4:	ffffb097          	auipc	ra,0xffffb
    800065a8:	8a2080e7          	jalr	-1886(ra) # 80000e46 <mycpu>
    800065ac:	5d3c                	lw	a5,120(a0)
    800065ae:	2785                	addiw	a5,a5,1
    800065b0:	dd3c                	sw	a5,120(a0)
}
    800065b2:	60e2                	ld	ra,24(sp)
    800065b4:	6442                	ld	s0,16(sp)
    800065b6:	64a2                	ld	s1,8(sp)
    800065b8:	6105                	addi	sp,sp,32
    800065ba:	8082                	ret
    mycpu()->intena = old;
    800065bc:	ffffb097          	auipc	ra,0xffffb
    800065c0:	88a080e7          	jalr	-1910(ra) # 80000e46 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800065c4:	8085                	srli	s1,s1,0x1
    800065c6:	8885                	andi	s1,s1,1
    800065c8:	dd64                	sw	s1,124(a0)
    800065ca:	bfe9                	j	800065a4 <push_off+0x24>

00000000800065cc <acquire>:
{
    800065cc:	1101                	addi	sp,sp,-32
    800065ce:	ec06                	sd	ra,24(sp)
    800065d0:	e822                	sd	s0,16(sp)
    800065d2:	e426                	sd	s1,8(sp)
    800065d4:	1000                	addi	s0,sp,32
    800065d6:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800065d8:	00000097          	auipc	ra,0x0
    800065dc:	fa8080e7          	jalr	-88(ra) # 80006580 <push_off>
  if(holding(lk))
    800065e0:	8526                	mv	a0,s1
    800065e2:	00000097          	auipc	ra,0x0
    800065e6:	f70080e7          	jalr	-144(ra) # 80006552 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800065ea:	4705                	li	a4,1
  if(holding(lk))
    800065ec:	e115                	bnez	a0,80006610 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800065ee:	87ba                	mv	a5,a4
    800065f0:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800065f4:	2781                	sext.w	a5,a5
    800065f6:	ffe5                	bnez	a5,800065ee <acquire+0x22>
  __sync_synchronize();
    800065f8:	0ff0000f          	fence
  lk->cpu = mycpu();
    800065fc:	ffffb097          	auipc	ra,0xffffb
    80006600:	84a080e7          	jalr	-1974(ra) # 80000e46 <mycpu>
    80006604:	e888                	sd	a0,16(s1)
}
    80006606:	60e2                	ld	ra,24(sp)
    80006608:	6442                	ld	s0,16(sp)
    8000660a:	64a2                	ld	s1,8(sp)
    8000660c:	6105                	addi	sp,sp,32
    8000660e:	8082                	ret
    panic("acquire");
    80006610:	00002517          	auipc	a0,0x2
    80006614:	48050513          	addi	a0,a0,1152 # 80008a90 <digits+0x20>
    80006618:	00000097          	auipc	ra,0x0
    8000661c:	a6a080e7          	jalr	-1430(ra) # 80006082 <panic>

0000000080006620 <pop_off>:

void
pop_off(void)
{
    80006620:	1141                	addi	sp,sp,-16
    80006622:	e406                	sd	ra,8(sp)
    80006624:	e022                	sd	s0,0(sp)
    80006626:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80006628:	ffffb097          	auipc	ra,0xffffb
    8000662c:	81e080e7          	jalr	-2018(ra) # 80000e46 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006630:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80006634:	8b89                	andi	a5,a5,2
  if(intr_get())
    80006636:	e78d                	bnez	a5,80006660 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80006638:	5d3c                	lw	a5,120(a0)
    8000663a:	02f05b63          	blez	a5,80006670 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    8000663e:	37fd                	addiw	a5,a5,-1
    80006640:	0007871b          	sext.w	a4,a5
    80006644:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80006646:	eb09                	bnez	a4,80006658 <pop_off+0x38>
    80006648:	5d7c                	lw	a5,124(a0)
    8000664a:	c799                	beqz	a5,80006658 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000664c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006650:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006654:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80006658:	60a2                	ld	ra,8(sp)
    8000665a:	6402                	ld	s0,0(sp)
    8000665c:	0141                	addi	sp,sp,16
    8000665e:	8082                	ret
    panic("pop_off - interruptible");
    80006660:	00002517          	auipc	a0,0x2
    80006664:	43850513          	addi	a0,a0,1080 # 80008a98 <digits+0x28>
    80006668:	00000097          	auipc	ra,0x0
    8000666c:	a1a080e7          	jalr	-1510(ra) # 80006082 <panic>
    panic("pop_off");
    80006670:	00002517          	auipc	a0,0x2
    80006674:	44050513          	addi	a0,a0,1088 # 80008ab0 <digits+0x40>
    80006678:	00000097          	auipc	ra,0x0
    8000667c:	a0a080e7          	jalr	-1526(ra) # 80006082 <panic>

0000000080006680 <release>:
{
    80006680:	1101                	addi	sp,sp,-32
    80006682:	ec06                	sd	ra,24(sp)
    80006684:	e822                	sd	s0,16(sp)
    80006686:	e426                	sd	s1,8(sp)
    80006688:	1000                	addi	s0,sp,32
    8000668a:	84aa                	mv	s1,a0
  if(!holding(lk))
    8000668c:	00000097          	auipc	ra,0x0
    80006690:	ec6080e7          	jalr	-314(ra) # 80006552 <holding>
    80006694:	c115                	beqz	a0,800066b8 <release+0x38>
  lk->cpu = 0;
    80006696:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    8000669a:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    8000669e:	0f50000f          	fence	iorw,ow
    800066a2:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    800066a6:	00000097          	auipc	ra,0x0
    800066aa:	f7a080e7          	jalr	-134(ra) # 80006620 <pop_off>
}
    800066ae:	60e2                	ld	ra,24(sp)
    800066b0:	6442                	ld	s0,16(sp)
    800066b2:	64a2                	ld	s1,8(sp)
    800066b4:	6105                	addi	sp,sp,32
    800066b6:	8082                	ret
    panic("release");
    800066b8:	00002517          	auipc	a0,0x2
    800066bc:	40050513          	addi	a0,a0,1024 # 80008ab8 <digits+0x48>
    800066c0:	00000097          	auipc	ra,0x0
    800066c4:	9c2080e7          	jalr	-1598(ra) # 80006082 <panic>
	...

0000000080007000 <_trampoline>:
    80007000:	14051073          	csrw	sscratch,a0
    80007004:	02000537          	lui	a0,0x2000
    80007008:	357d                	addiw	a0,a0,-1
    8000700a:	0536                	slli	a0,a0,0xd
    8000700c:	02153423          	sd	ra,40(a0) # 2000028 <_entry-0x7dffffd8>
    80007010:	02253823          	sd	sp,48(a0)
    80007014:	02353c23          	sd	gp,56(a0)
    80007018:	04453023          	sd	tp,64(a0)
    8000701c:	04553423          	sd	t0,72(a0)
    80007020:	04653823          	sd	t1,80(a0)
    80007024:	04753c23          	sd	t2,88(a0)
    80007028:	f120                	sd	s0,96(a0)
    8000702a:	f524                	sd	s1,104(a0)
    8000702c:	fd2c                	sd	a1,120(a0)
    8000702e:	e150                	sd	a2,128(a0)
    80007030:	e554                	sd	a3,136(a0)
    80007032:	e958                	sd	a4,144(a0)
    80007034:	ed5c                	sd	a5,152(a0)
    80007036:	0b053023          	sd	a6,160(a0)
    8000703a:	0b153423          	sd	a7,168(a0)
    8000703e:	0b253823          	sd	s2,176(a0)
    80007042:	0b353c23          	sd	s3,184(a0)
    80007046:	0d453023          	sd	s4,192(a0)
    8000704a:	0d553423          	sd	s5,200(a0)
    8000704e:	0d653823          	sd	s6,208(a0)
    80007052:	0d753c23          	sd	s7,216(a0)
    80007056:	0f853023          	sd	s8,224(a0)
    8000705a:	0f953423          	sd	s9,232(a0)
    8000705e:	0fa53823          	sd	s10,240(a0)
    80007062:	0fb53c23          	sd	s11,248(a0)
    80007066:	11c53023          	sd	t3,256(a0)
    8000706a:	11d53423          	sd	t4,264(a0)
    8000706e:	11e53823          	sd	t5,272(a0)
    80007072:	11f53c23          	sd	t6,280(a0)
    80007076:	140022f3          	csrr	t0,sscratch
    8000707a:	06553823          	sd	t0,112(a0)
    8000707e:	00853103          	ld	sp,8(a0)
    80007082:	02053203          	ld	tp,32(a0)
    80007086:	01053283          	ld	t0,16(a0)
    8000708a:	00053303          	ld	t1,0(a0)
    8000708e:	12000073          	sfence.vma
    80007092:	18031073          	csrw	satp,t1
    80007096:	12000073          	sfence.vma
    8000709a:	8282                	jr	t0

000000008000709c <userret>:
    8000709c:	12000073          	sfence.vma
    800070a0:	18051073          	csrw	satp,a0
    800070a4:	12000073          	sfence.vma
    800070a8:	02000537          	lui	a0,0x2000
    800070ac:	357d                	addiw	a0,a0,-1
    800070ae:	0536                	slli	a0,a0,0xd
    800070b0:	02853083          	ld	ra,40(a0) # 2000028 <_entry-0x7dffffd8>
    800070b4:	03053103          	ld	sp,48(a0)
    800070b8:	03853183          	ld	gp,56(a0)
    800070bc:	04053203          	ld	tp,64(a0)
    800070c0:	04853283          	ld	t0,72(a0)
    800070c4:	05053303          	ld	t1,80(a0)
    800070c8:	05853383          	ld	t2,88(a0)
    800070cc:	7120                	ld	s0,96(a0)
    800070ce:	7524                	ld	s1,104(a0)
    800070d0:	7d2c                	ld	a1,120(a0)
    800070d2:	6150                	ld	a2,128(a0)
    800070d4:	6554                	ld	a3,136(a0)
    800070d6:	6958                	ld	a4,144(a0)
    800070d8:	6d5c                	ld	a5,152(a0)
    800070da:	0a053803          	ld	a6,160(a0)
    800070de:	0a853883          	ld	a7,168(a0)
    800070e2:	0b053903          	ld	s2,176(a0)
    800070e6:	0b853983          	ld	s3,184(a0)
    800070ea:	0c053a03          	ld	s4,192(a0)
    800070ee:	0c853a83          	ld	s5,200(a0)
    800070f2:	0d053b03          	ld	s6,208(a0)
    800070f6:	0d853b83          	ld	s7,216(a0)
    800070fa:	0e053c03          	ld	s8,224(a0)
    800070fe:	0e853c83          	ld	s9,232(a0)
    80007102:	0f053d03          	ld	s10,240(a0)
    80007106:	0f853d83          	ld	s11,248(a0)
    8000710a:	10053e03          	ld	t3,256(a0)
    8000710e:	10853e83          	ld	t4,264(a0)
    80007112:	11053f03          	ld	t5,272(a0)
    80007116:	11853f83          	ld	t6,280(a0)
    8000711a:	7928                	ld	a0,112(a0)
    8000711c:	10200073          	sret
	...
