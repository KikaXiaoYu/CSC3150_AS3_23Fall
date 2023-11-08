
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	ab013103          	ld	sp,-1360(sp) # 80008ab0 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	367050ef          	jal	ra,80005b7c <start>

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
    80000034:	f4078793          	addi	a5,a5,-192 # 80033f70 <end>
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
    80000054:	ab090913          	addi	s2,s2,-1360 # 80008b00 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	522080e7          	jalr	1314(ra) # 8000657c <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	5c2080e7          	jalr	1474(ra) # 80006630 <release>
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
    8000008e:	fa8080e7          	jalr	-88(ra) # 80006032 <panic>

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
    800000f0:	a1450513          	addi	a0,a0,-1516 # 80008b00 <kmem>
    800000f4:	00006097          	auipc	ra,0x6
    800000f8:	3f8080e7          	jalr	1016(ra) # 800064ec <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fc:	45c5                	li	a1,17
    800000fe:	05ee                	slli	a1,a1,0x1b
    80000100:	00034517          	auipc	a0,0x34
    80000104:	e7050513          	addi	a0,a0,-400 # 80033f70 <end>
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
    80000126:	9de48493          	addi	s1,s1,-1570 # 80008b00 <kmem>
    8000012a:	8526                	mv	a0,s1
    8000012c:	00006097          	auipc	ra,0x6
    80000130:	450080e7          	jalr	1104(ra) # 8000657c <acquire>
  r = kmem.freelist;
    80000134:	6c84                	ld	s1,24(s1)
  if(r)
    80000136:	c885                	beqz	s1,80000166 <kalloc+0x4e>
    kmem.freelist = r->next;
    80000138:	609c                	ld	a5,0(s1)
    8000013a:	00009517          	auipc	a0,0x9
    8000013e:	9c650513          	addi	a0,a0,-1594 # 80008b00 <kmem>
    80000142:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000144:	00006097          	auipc	ra,0x6
    80000148:	4ec080e7          	jalr	1260(ra) # 80006630 <release>

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
    8000016a:	99a50513          	addi	a0,a0,-1638 # 80008b00 <kmem>
    8000016e:	00006097          	auipc	ra,0x6
    80000172:	4c2080e7          	jalr	1218(ra) # 80006630 <release>
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
    8000033a:	79a70713          	addi	a4,a4,1946 # 80008ad0 <started>
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
    80000360:	d20080e7          	jalr	-736(ra) # 8000607c <printf>
    kvminithart();    // turn on paging
    80000364:	00000097          	auipc	ra,0x0
    80000368:	0d8080e7          	jalr	216(ra) # 8000043c <kvminithart>
    trapinithart();   // install kernel trap vector
    8000036c:	00001097          	auipc	ra,0x1
    80000370:	78e080e7          	jalr	1934(ra) # 80001afa <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000374:	00005097          	auipc	ra,0x5
    80000378:	15c080e7          	jalr	348(ra) # 800054d0 <plicinithart>
  }

  scheduler();        
    8000037c:	00001097          	auipc	ra,0x1
    80000380:	fd8080e7          	jalr	-40(ra) # 80001354 <scheduler>
    consoleinit();
    80000384:	00006097          	auipc	ra,0x6
    80000388:	bc0080e7          	jalr	-1088(ra) # 80005f44 <consoleinit>
    printfinit();
    8000038c:	00006097          	auipc	ra,0x6
    80000390:	ed6080e7          	jalr	-298(ra) # 80006262 <printfinit>
    printf("\n");
    80000394:	00008517          	auipc	a0,0x8
    80000398:	cb450513          	addi	a0,a0,-844 # 80008048 <etext+0x48>
    8000039c:	00006097          	auipc	ra,0x6
    800003a0:	ce0080e7          	jalr	-800(ra) # 8000607c <printf>
    printf("xv6 kernel is booting\n");
    800003a4:	00008517          	auipc	a0,0x8
    800003a8:	c7c50513          	addi	a0,a0,-900 # 80008020 <etext+0x20>
    800003ac:	00006097          	auipc	ra,0x6
    800003b0:	cd0080e7          	jalr	-816(ra) # 8000607c <printf>
    printf("\n");
    800003b4:	00008517          	auipc	a0,0x8
    800003b8:	c9450513          	addi	a0,a0,-876 # 80008048 <etext+0x48>
    800003bc:	00006097          	auipc	ra,0x6
    800003c0:	cc0080e7          	jalr	-832(ra) # 8000607c <printf>
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
    800003f8:	0c6080e7          	jalr	198(ra) # 800054ba <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003fc:	00005097          	auipc	ra,0x5
    80000400:	0d4080e7          	jalr	212(ra) # 800054d0 <plicinithart>
    binit();         // buffer cache
    80000404:	00002097          	auipc	ra,0x2
    80000408:	f2a080e7          	jalr	-214(ra) # 8000232e <binit>
    iinit();         // inode table
    8000040c:	00002097          	auipc	ra,0x2
    80000410:	5ce080e7          	jalr	1486(ra) # 800029da <iinit>
    fileinit();      // file table
    80000414:	00003097          	auipc	ra,0x3
    80000418:	56c080e7          	jalr	1388(ra) # 80003980 <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000041c:	00005097          	auipc	ra,0x5
    80000420:	1bc080e7          	jalr	444(ra) # 800055d8 <virtio_disk_init>
    userinit();      // first user process
    80000424:	00001097          	auipc	ra,0x1
    80000428:	d16080e7          	jalr	-746(ra) # 8000113a <userinit>
    __sync_synchronize();
    8000042c:	0ff0000f          	fence
    started = 1;
    80000430:	4785                	li	a5,1
    80000432:	00008717          	auipc	a4,0x8
    80000436:	68f72f23          	sw	a5,1694(a4) # 80008ad0 <started>
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
    8000044a:	6927b783          	ld	a5,1682(a5) # 80008ad8 <kernel_pagetable>
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
    80000496:	ba0080e7          	jalr	-1120(ra) # 80006032 <panic>
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
    8000058e:	aa8080e7          	jalr	-1368(ra) # 80006032 <panic>
            printf("[Testing] : pte: %d\n", pte);
    80000592:	85aa                	mv	a1,a0
    80000594:	00008517          	auipc	a0,0x8
    80000598:	ad450513          	addi	a0,a0,-1324 # 80008068 <etext+0x68>
    8000059c:	00006097          	auipc	ra,0x6
    800005a0:	ae0080e7          	jalr	-1312(ra) # 8000607c <printf>
            printf("[Testing] : PTE_V: %d\n", PTE_V);
    800005a4:	4585                	li	a1,1
    800005a6:	00008517          	auipc	a0,0x8
    800005aa:	ada50513          	addi	a0,a0,-1318 # 80008080 <etext+0x80>
    800005ae:	00006097          	auipc	ra,0x6
    800005b2:	ace080e7          	jalr	-1330(ra) # 8000607c <printf>
            panic("mappages: remap");
    800005b6:	00008517          	auipc	a0,0x8
    800005ba:	ae250513          	addi	a0,a0,-1310 # 80008098 <etext+0x98>
    800005be:	00006097          	auipc	ra,0x6
    800005c2:	a74080e7          	jalr	-1420(ra) # 80006032 <panic>
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
    8000063c:	9fa080e7          	jalr	-1542(ra) # 80006032 <panic>

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
    8000072a:	3aa7b923          	sd	a0,946(a5) # 80008ad8 <kernel_pagetable>
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
    80000788:	8ae080e7          	jalr	-1874(ra) # 80006032 <panic>
            panic("uvmunmap: walk");
    8000078c:	00008517          	auipc	a0,0x8
    80000790:	93c50513          	addi	a0,a0,-1732 # 800080c8 <etext+0xc8>
    80000794:	00006097          	auipc	ra,0x6
    80000798:	89e080e7          	jalr	-1890(ra) # 80006032 <panic>
            panic("uvmunmap: not a leaf");
    8000079c:	00008517          	auipc	a0,0x8
    800007a0:	93c50513          	addi	a0,a0,-1732 # 800080d8 <etext+0xd8>
    800007a4:	00006097          	auipc	ra,0x6
    800007a8:	88e080e7          	jalr	-1906(ra) # 80006032 <panic>
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
    80000888:	7ae080e7          	jalr	1966(ra) # 80006032 <panic>

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
    800009d2:	664080e7          	jalr	1636(ra) # 80006032 <panic>
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
    80000a56:	5e0080e7          	jalr	1504(ra) # 80006032 <panic>
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
    80000b1c:	51a080e7          	jalr	1306(ra) # 80006032 <panic>

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
    80000d06:	24e48493          	addi	s1,s1,590 # 80008f50 <proc>
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
    80000d20:	c34a0a13          	addi	s4,s4,-972 # 80020950 <tickslock>
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
    80000d7e:	2b8080e7          	jalr	696(ra) # 80006032 <panic>

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
    80000da2:	d8250513          	addi	a0,a0,-638 # 80008b20 <pid_lock>
    80000da6:	00005097          	auipc	ra,0x5
    80000daa:	746080e7          	jalr	1862(ra) # 800064ec <initlock>
    initlock(&wait_lock, "wait_lock");
    80000dae:	00007597          	auipc	a1,0x7
    80000db2:	3b258593          	addi	a1,a1,946 # 80008160 <etext+0x160>
    80000db6:	00008517          	auipc	a0,0x8
    80000dba:	d8250513          	addi	a0,a0,-638 # 80008b38 <wait_lock>
    80000dbe:	00005097          	auipc	ra,0x5
    80000dc2:	72e080e7          	jalr	1838(ra) # 800064ec <initlock>
    for (p = proc; p < &proc[NPROC]; p++)
    80000dc6:	00008497          	auipc	s1,0x8
    80000dca:	18a48493          	addi	s1,s1,394 # 80008f50 <proc>
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
    80000dec:	b6898993          	addi	s3,s3,-1176 # 80020950 <tickslock>
        initlock(&p->lock, "proc");
    80000df0:	85da                	mv	a1,s6
    80000df2:	8526                	mv	a0,s1
    80000df4:	00005097          	auipc	ra,0x5
    80000df8:	6f8080e7          	jalr	1784(ra) # 800064ec <initlock>
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
    80000e56:	cfe50513          	addi	a0,a0,-770 # 80008b50 <cpus>
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
    80000e70:	6c4080e7          	jalr	1732(ra) # 80006530 <push_off>
    80000e74:	8792                	mv	a5,tp
    struct cpu *c = mycpu();
    struct proc *p = c->proc;
    80000e76:	2781                	sext.w	a5,a5
    80000e78:	079e                	slli	a5,a5,0x7
    80000e7a:	00008717          	auipc	a4,0x8
    80000e7e:	ca670713          	addi	a4,a4,-858 # 80008b20 <pid_lock>
    80000e82:	97ba                	add	a5,a5,a4
    80000e84:	7b84                	ld	s1,48(a5)
    pop_off();
    80000e86:	00005097          	auipc	ra,0x5
    80000e8a:	74a080e7          	jalr	1866(ra) # 800065d0 <pop_off>
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
    80000eae:	786080e7          	jalr	1926(ra) # 80006630 <release>

    if (first)
    80000eb2:	00008797          	auipc	a5,0x8
    80000eb6:	bae7a783          	lw	a5,-1106(a5) # 80008a60 <first.1694>
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
    80000ed0:	b807aa23          	sw	zero,-1132(a5) # 80008a60 <first.1694>
        fsinit(ROOTDEV);
    80000ed4:	4505                	li	a0,1
    80000ed6:	00002097          	auipc	ra,0x2
    80000eda:	a84080e7          	jalr	-1404(ra) # 8000295a <fsinit>
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
    80000ef0:	c3490913          	addi	s2,s2,-972 # 80008b20 <pid_lock>
    80000ef4:	854a                	mv	a0,s2
    80000ef6:	00005097          	auipc	ra,0x5
    80000efa:	686080e7          	jalr	1670(ra) # 8000657c <acquire>
    pid = nextpid;
    80000efe:	00008797          	auipc	a5,0x8
    80000f02:	b6678793          	addi	a5,a5,-1178 # 80008a64 <nextpid>
    80000f06:	4384                	lw	s1,0(a5)
    nextpid = nextpid + 1;
    80000f08:	0014871b          	addiw	a4,s1,1
    80000f0c:	c398                	sw	a4,0(a5)
    release(&pid_lock);
    80000f0e:	854a                	mv	a0,s2
    80000f10:	00005097          	auipc	ra,0x5
    80000f14:	720080e7          	jalr	1824(ra) # 80006630 <release>
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
    8000107c:	ed848493          	addi	s1,s1,-296 # 80008f50 <proc>
    80001080:	00020917          	auipc	s2,0x20
    80001084:	8d090913          	addi	s2,s2,-1840 # 80020950 <tickslock>
        acquire(&p->lock);
    80001088:	8526                	mv	a0,s1
    8000108a:	00005097          	auipc	ra,0x5
    8000108e:	4f2080e7          	jalr	1266(ra) # 8000657c <acquire>
        if (p->state == UNUSED)
    80001092:	4c9c                	lw	a5,24(s1)
    80001094:	cf81                	beqz	a5,800010ac <allocproc+0x40>
            release(&p->lock);
    80001096:	8526                	mv	a0,s1
    80001098:	00005097          	auipc	ra,0x5
    8000109c:	598080e7          	jalr	1432(ra) # 80006630 <release>
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
    8000111a:	51a080e7          	jalr	1306(ra) # 80006630 <release>
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
    80001132:	502080e7          	jalr	1282(ra) # 80006630 <release>
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
    80001152:	98a7b923          	sd	a0,-1646(a5) # 80008ae0 <initproc>
    uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001156:	03400613          	li	a2,52
    8000115a:	00008597          	auipc	a1,0x8
    8000115e:	91658593          	addi	a1,a1,-1770 # 80008a70 <initcode>
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
    8000119c:	1e4080e7          	jalr	484(ra) # 8000337c <namei>
    800011a0:	14a4b823          	sd	a0,336(s1)
    p->state = RUNNABLE;
    800011a4:	478d                	li	a5,3
    800011a6:	cc9c                	sw	a5,24(s1)
    release(&p->lock);
    800011a8:	8526                	mv	a0,s1
    800011aa:	00005097          	auipc	ra,0x5
    800011ae:	486080e7          	jalr	1158(ra) # 80006630 <release>
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
    800012ae:	386080e7          	jalr	902(ra) # 80006630 <release>
        return -1;
    800012b2:	5a7d                	li	s4,-1
    800012b4:	a069                	j	8000133e <fork+0x126>
            np->ofile[i] = filedup(p->ofile[i]);
    800012b6:	00002097          	auipc	ra,0x2
    800012ba:	75c080e7          	jalr	1884(ra) # 80003a12 <filedup>
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
    800012dc:	8c0080e7          	jalr	-1856(ra) # 80002b98 <idup>
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
    80001300:	334080e7          	jalr	820(ra) # 80006630 <release>
    acquire(&wait_lock);
    80001304:	00008497          	auipc	s1,0x8
    80001308:	83448493          	addi	s1,s1,-1996 # 80008b38 <wait_lock>
    8000130c:	8526                	mv	a0,s1
    8000130e:	00005097          	auipc	ra,0x5
    80001312:	26e080e7          	jalr	622(ra) # 8000657c <acquire>
    np->parent = p;
    80001316:	0329bc23          	sd	s2,56(s3)
    release(&wait_lock);
    8000131a:	8526                	mv	a0,s1
    8000131c:	00005097          	auipc	ra,0x5
    80001320:	314080e7          	jalr	788(ra) # 80006630 <release>
    acquire(&np->lock);
    80001324:	854e                	mv	a0,s3
    80001326:	00005097          	auipc	ra,0x5
    8000132a:	256080e7          	jalr	598(ra) # 8000657c <acquire>
    np->state = RUNNABLE;
    8000132e:	478d                	li	a5,3
    80001330:	00f9ac23          	sw	a5,24(s3)
    release(&np->lock);
    80001334:	854e                	mv	a0,s3
    80001336:	00005097          	auipc	ra,0x5
    8000133a:	2fa080e7          	jalr	762(ra) # 80006630 <release>
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
    80001370:	00007717          	auipc	a4,0x7
    80001374:	7b070713          	addi	a4,a4,1968 # 80008b20 <pid_lock>
    80001378:	9756                	add	a4,a4,s5
    8000137a:	02073823          	sd	zero,48(a4)
                swtch(&c->context, &p->context);
    8000137e:	00007717          	auipc	a4,0x7
    80001382:	7da70713          	addi	a4,a4,2010 # 80008b58 <cpus+0x8>
    80001386:	9aba                	add	s5,s5,a4
            if (p->state == RUNNABLE)
    80001388:	498d                	li	s3,3
                p->state = RUNNING;
    8000138a:	4b11                	li	s6,4
                c->proc = p;
    8000138c:	079e                	slli	a5,a5,0x7
    8000138e:	00007a17          	auipc	s4,0x7
    80001392:	792a0a13          	addi	s4,s4,1938 # 80008b20 <pid_lock>
    80001396:	9a3e                	add	s4,s4,a5
        for (p = proc; p < &proc[NPROC]; p++)
    80001398:	0001f917          	auipc	s2,0x1f
    8000139c:	5b890913          	addi	s2,s2,1464 # 80020950 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800013a0:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800013a4:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800013a8:	10079073          	csrw	sstatus,a5
    800013ac:	00008497          	auipc	s1,0x8
    800013b0:	ba448493          	addi	s1,s1,-1116 # 80008f50 <proc>
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
    800013d6:	25e080e7          	jalr	606(ra) # 80006630 <release>
        for (p = proc; p < &proc[NPROC]; p++)
    800013da:	5e848493          	addi	s1,s1,1512
    800013de:	fd2481e3          	beq	s1,s2,800013a0 <scheduler+0x4c>
            acquire(&p->lock);
    800013e2:	8526                	mv	a0,s1
    800013e4:	00005097          	auipc	ra,0x5
    800013e8:	198080e7          	jalr	408(ra) # 8000657c <acquire>
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
    80001410:	0f6080e7          	jalr	246(ra) # 80006502 <holding>
    80001414:	c93d                	beqz	a0,8000148a <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001416:	8792                	mv	a5,tp
    if (mycpu()->noff != 1)
    80001418:	2781                	sext.w	a5,a5
    8000141a:	079e                	slli	a5,a5,0x7
    8000141c:	00007717          	auipc	a4,0x7
    80001420:	70470713          	addi	a4,a4,1796 # 80008b20 <pid_lock>
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
    80001446:	6de90913          	addi	s2,s2,1758 # 80008b20 <pid_lock>
    8000144a:	2781                	sext.w	a5,a5
    8000144c:	079e                	slli	a5,a5,0x7
    8000144e:	97ca                	add	a5,a5,s2
    80001450:	0ac7a983          	lw	s3,172(a5)
    80001454:	8792                	mv	a5,tp
    swtch(&p->context, &mycpu()->context);
    80001456:	2781                	sext.w	a5,a5
    80001458:	079e                	slli	a5,a5,0x7
    8000145a:	00007597          	auipc	a1,0x7
    8000145e:	6fe58593          	addi	a1,a1,1790 # 80008b58 <cpus+0x8>
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
    80001496:	ba0080e7          	jalr	-1120(ra) # 80006032 <panic>
        panic("sched locks");
    8000149a:	00007517          	auipc	a0,0x7
    8000149e:	d0650513          	addi	a0,a0,-762 # 800081a0 <etext+0x1a0>
    800014a2:	00005097          	auipc	ra,0x5
    800014a6:	b90080e7          	jalr	-1136(ra) # 80006032 <panic>
        panic("sched running");
    800014aa:	00007517          	auipc	a0,0x7
    800014ae:	d0650513          	addi	a0,a0,-762 # 800081b0 <etext+0x1b0>
    800014b2:	00005097          	auipc	ra,0x5
    800014b6:	b80080e7          	jalr	-1152(ra) # 80006032 <panic>
        panic("sched interruptible");
    800014ba:	00007517          	auipc	a0,0x7
    800014be:	d0650513          	addi	a0,a0,-762 # 800081c0 <etext+0x1c0>
    800014c2:	00005097          	auipc	ra,0x5
    800014c6:	b70080e7          	jalr	-1168(ra) # 80006032 <panic>

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
    800014e2:	09e080e7          	jalr	158(ra) # 8000657c <acquire>
    p->state = RUNNABLE;
    800014e6:	478d                	li	a5,3
    800014e8:	cc9c                	sw	a5,24(s1)
    sched();
    800014ea:	00000097          	auipc	ra,0x0
    800014ee:	f0a080e7          	jalr	-246(ra) # 800013f4 <sched>
    release(&p->lock);
    800014f2:	8526                	mv	a0,s1
    800014f4:	00005097          	auipc	ra,0x5
    800014f8:	13c080e7          	jalr	316(ra) # 80006630 <release>
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
    80001526:	05a080e7          	jalr	90(ra) # 8000657c <acquire>
    release(lk);
    8000152a:	854a                	mv	a0,s2
    8000152c:	00005097          	auipc	ra,0x5
    80001530:	104080e7          	jalr	260(ra) # 80006630 <release>

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
    8000154e:	0e6080e7          	jalr	230(ra) # 80006630 <release>
    acquire(lk);
    80001552:	854a                	mv	a0,s2
    80001554:	00005097          	auipc	ra,0x5
    80001558:	028080e7          	jalr	40(ra) # 8000657c <acquire>
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
    80001582:	9d248493          	addi	s1,s1,-1582 # 80008f50 <proc>
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
    8000158e:	3c690913          	addi	s2,s2,966 # 80020950 <tickslock>
    80001592:	a821                	j	800015aa <wakeup+0x40>
                p->state = RUNNABLE;
    80001594:	0154ac23          	sw	s5,24(s1)
            }
            release(&p->lock);
    80001598:	8526                	mv	a0,s1
    8000159a:	00005097          	auipc	ra,0x5
    8000159e:	096080e7          	jalr	150(ra) # 80006630 <release>
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
    800015bc:	fc4080e7          	jalr	-60(ra) # 8000657c <acquire>
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
    800015f6:	95e48493          	addi	s1,s1,-1698 # 80008f50 <proc>
            pp->parent = initproc;
    800015fa:	00007a17          	auipc	s4,0x7
    800015fe:	4e6a0a13          	addi	s4,s4,1254 # 80008ae0 <initproc>
    for (pp = proc; pp < &proc[NPROC]; pp++)
    80001602:	0001f997          	auipc	s3,0x1f
    80001606:	34e98993          	addi	s3,s3,846 # 80020950 <tickslock>
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
    8000165a:	48a7b783          	ld	a5,1162(a5) # 80008ae0 <initproc>
    8000165e:	0d050493          	addi	s1,a0,208
    80001662:	15050913          	addi	s2,a0,336
    80001666:	02a79363          	bne	a5,a0,8000168c <exit+0x52>
        panic("init exiting");
    8000166a:	00007517          	auipc	a0,0x7
    8000166e:	b6e50513          	addi	a0,a0,-1170 # 800081d8 <etext+0x1d8>
    80001672:	00005097          	auipc	ra,0x5
    80001676:	9c0080e7          	jalr	-1600(ra) # 80006032 <panic>
            fileclose(f);
    8000167a:	00002097          	auipc	ra,0x2
    8000167e:	3ea080e7          	jalr	1002(ra) # 80003a64 <fileclose>
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
    80001696:	f06080e7          	jalr	-250(ra) # 80003598 <begin_op>
    iput(p->cwd);
    8000169a:	1509b503          	ld	a0,336(s3)
    8000169e:	00001097          	auipc	ra,0x1
    800016a2:	6f2080e7          	jalr	1778(ra) # 80002d90 <iput>
    end_op();
    800016a6:	00002097          	auipc	ra,0x2
    800016aa:	f72080e7          	jalr	-142(ra) # 80003618 <end_op>
    p->cwd = 0;
    800016ae:	1409b823          	sd	zero,336(s3)
    acquire(&wait_lock);
    800016b2:	00007497          	auipc	s1,0x7
    800016b6:	48648493          	addi	s1,s1,1158 # 80008b38 <wait_lock>
    800016ba:	8526                	mv	a0,s1
    800016bc:	00005097          	auipc	ra,0x5
    800016c0:	ec0080e7          	jalr	-320(ra) # 8000657c <acquire>
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
    800016e0:	ea0080e7          	jalr	-352(ra) # 8000657c <acquire>
    p->xstate = status;
    800016e4:	0349a623          	sw	s4,44(s3)
    p->state = ZOMBIE;
    800016e8:	4795                	li	a5,5
    800016ea:	00f9ac23          	sw	a5,24(s3)
    release(&wait_lock);
    800016ee:	8526                	mv	a0,s1
    800016f0:	00005097          	auipc	ra,0x5
    800016f4:	f40080e7          	jalr	-192(ra) # 80006630 <release>
    sched();
    800016f8:	00000097          	auipc	ra,0x0
    800016fc:	cfc080e7          	jalr	-772(ra) # 800013f4 <sched>
    panic("zombie exit");
    80001700:	00007517          	auipc	a0,0x7
    80001704:	ae850513          	addi	a0,a0,-1304 # 800081e8 <etext+0x1e8>
    80001708:	00005097          	auipc	ra,0x5
    8000170c:	92a080e7          	jalr	-1750(ra) # 80006032 <panic>

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
    80001724:	83048493          	addi	s1,s1,-2000 # 80008f50 <proc>
    80001728:	0001f997          	auipc	s3,0x1f
    8000172c:	22898993          	addi	s3,s3,552 # 80020950 <tickslock>
    {
        acquire(&p->lock);
    80001730:	8526                	mv	a0,s1
    80001732:	00005097          	auipc	ra,0x5
    80001736:	e4a080e7          	jalr	-438(ra) # 8000657c <acquire>
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
    80001746:	eee080e7          	jalr	-274(ra) # 80006630 <release>
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
    80001768:	ecc080e7          	jalr	-308(ra) # 80006630 <release>
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
    80001792:	dee080e7          	jalr	-530(ra) # 8000657c <acquire>
    p->killed = 1;
    80001796:	4785                	li	a5,1
    80001798:	d49c                	sw	a5,40(s1)
    release(&p->lock);
    8000179a:	8526                	mv	a0,s1
    8000179c:	00005097          	auipc	ra,0x5
    800017a0:	e94080e7          	jalr	-364(ra) # 80006630 <release>
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
    800017c0:	dc0080e7          	jalr	-576(ra) # 8000657c <acquire>
    k = p->killed;
    800017c4:	0284a903          	lw	s2,40(s1)
    release(&p->lock);
    800017c8:	8526                	mv	a0,s1
    800017ca:	00005097          	auipc	ra,0x5
    800017ce:	e66080e7          	jalr	-410(ra) # 80006630 <release>
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
    80001808:	33450513          	addi	a0,a0,820 # 80008b38 <wait_lock>
    8000180c:	00005097          	auipc	ra,0x5
    80001810:	d70080e7          	jalr	-656(ra) # 8000657c <acquire>
        havekids = 0;
    80001814:	4b81                	li	s7,0
                if (pp->state == ZOMBIE)
    80001816:	4a15                	li	s4,5
        for (pp = proc; pp < &proc[NPROC]; pp++)
    80001818:	0001f997          	auipc	s3,0x1f
    8000181c:	13898993          	addi	s3,s3,312 # 80020950 <tickslock>
                havekids = 1;
    80001820:	4a85                	li	s5,1
        sleep(p, &wait_lock); // DOC: wait-sleep
    80001822:	00007c17          	auipc	s8,0x7
    80001826:	316c0c13          	addi	s8,s8,790 # 80008b38 <wait_lock>
        havekids = 0;
    8000182a:	875e                	mv	a4,s7
        for (pp = proc; pp < &proc[NPROC]; pp++)
    8000182c:	00007497          	auipc	s1,0x7
    80001830:	72448493          	addi	s1,s1,1828 # 80008f50 <proc>
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
    80001866:	dce080e7          	jalr	-562(ra) # 80006630 <release>
                    release(&wait_lock);
    8000186a:	00007517          	auipc	a0,0x7
    8000186e:	2ce50513          	addi	a0,a0,718 # 80008b38 <wait_lock>
    80001872:	00005097          	auipc	ra,0x5
    80001876:	dbe080e7          	jalr	-578(ra) # 80006630 <release>
                    return pid;
    8000187a:	a0b5                	j	800018e6 <wait+0x106>
                        release(&pp->lock);
    8000187c:	8526                	mv	a0,s1
    8000187e:	00005097          	auipc	ra,0x5
    80001882:	db2080e7          	jalr	-590(ra) # 80006630 <release>
                        release(&wait_lock);
    80001886:	00007517          	auipc	a0,0x7
    8000188a:	2b250513          	addi	a0,a0,690 # 80008b38 <wait_lock>
    8000188e:	00005097          	auipc	ra,0x5
    80001892:	da2080e7          	jalr	-606(ra) # 80006630 <release>
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
    800018ae:	cd2080e7          	jalr	-814(ra) # 8000657c <acquire>
                if (pp->state == ZOMBIE)
    800018b2:	4c9c                	lw	a5,24(s1)
    800018b4:	f94781e3          	beq	a5,s4,80001836 <wait+0x56>
                release(&pp->lock);
    800018b8:	8526                	mv	a0,s1
    800018ba:	00005097          	auipc	ra,0x5
    800018be:	d76080e7          	jalr	-650(ra) # 80006630 <release>
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
    800018d8:	26450513          	addi	a0,a0,612 # 80008b38 <wait_lock>
    800018dc:	00005097          	auipc	ra,0x5
    800018e0:	d54080e7          	jalr	-684(ra) # 80006630 <release>
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
    800019dc:	6a4080e7          	jalr	1700(ra) # 8000607c <printf>
    for (p = proc; p < &proc[NPROC]; p++)
    800019e0:	00007497          	auipc	s1,0x7
    800019e4:	6c848493          	addi	s1,s1,1736 # 800090a8 <proc+0x158>
    800019e8:	0001f917          	auipc	s2,0x1f
    800019ec:	0c090913          	addi	s2,s2,192 # 80020aa8 <bcache+0x140>
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
    80001a1e:	662080e7          	jalr	1634(ra) # 8000607c <printf>
        printf("\n");
    80001a22:	8552                	mv	a0,s4
    80001a24:	00004097          	auipc	ra,0x4
    80001a28:	658080e7          	jalr	1624(ra) # 8000607c <printf>
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
    80001ae6:	e6e50513          	addi	a0,a0,-402 # 80020950 <tickslock>
    80001aea:	00005097          	auipc	ra,0x5
    80001aee:	a02080e7          	jalr	-1534(ra) # 800064ec <initlock>
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
    80001b04:	90078793          	addi	a5,a5,-1792 # 80005400 <kernelvec>
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
    80001bb6:	d9e48493          	addi	s1,s1,-610 # 80020950 <tickslock>
    80001bba:	8526                	mv	a0,s1
    80001bbc:	00005097          	auipc	ra,0x5
    80001bc0:	9c0080e7          	jalr	-1600(ra) # 8000657c <acquire>
    ticks++;
    80001bc4:	00007517          	auipc	a0,0x7
    80001bc8:	f2450513          	addi	a0,a0,-220 # 80008ae8 <ticks>
    80001bcc:	411c                	lw	a5,0(a0)
    80001bce:	2785                	addiw	a5,a5,1
    80001bd0:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    80001bd2:	00000097          	auipc	ra,0x0
    80001bd6:	998080e7          	jalr	-1640(ra) # 8000156a <wakeup>
    release(&tickslock);
    80001bda:	8526                	mv	a0,s1
    80001bdc:	00005097          	auipc	ra,0x5
    80001be0:	a54080e7          	jalr	-1452(ra) # 80006630 <release>
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
    80001c24:	8e8080e7          	jalr	-1816(ra) # 80005508 <plic_claim>
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
    80001c48:	438080e7          	jalr	1080(ra) # 8000607c <printf>
            plic_complete(irq);
    80001c4c:	8526                	mv	a0,s1
    80001c4e:	00004097          	auipc	ra,0x4
    80001c52:	8de080e7          	jalr	-1826(ra) # 8000552c <plic_complete>
        return 1;
    80001c56:	4505                	li	a0,1
    80001c58:	bf55                	j	80001c0c <devintr+0x1e>
            uartintr();
    80001c5a:	00005097          	auipc	ra,0x5
    80001c5e:	842080e7          	jalr	-1982(ra) # 8000649c <uartintr>
    80001c62:	b7ed                	j	80001c4c <devintr+0x5e>
            virtio_disk_intr();
    80001c64:	00004097          	auipc	ra,0x4
    80001c68:	df2080e7          	jalr	-526(ra) # 80005a56 <virtio_disk_intr>
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
    80001c90:	7139                	addi	sp,sp,-64
    80001c92:	fc06                	sd	ra,56(sp)
    80001c94:	f822                	sd	s0,48(sp)
    80001c96:	f426                	sd	s1,40(sp)
    80001c98:	f04a                	sd	s2,32(sp)
    80001c9a:	ec4e                	sd	s3,24(sp)
    80001c9c:	e852                	sd	s4,16(sp)
    80001c9e:	e456                	sd	s5,8(sp)
    80001ca0:	e05a                	sd	s6,0(sp)
    80001ca2:	0080                	addi	s0,sp,64
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ca4:	100027f3          	csrr	a5,sstatus
    if ((r_sstatus() & SSTATUS_SPP) != 0)
    80001ca8:	1007f793          	andi	a5,a5,256
    80001cac:	e7c1                	bnez	a5,80001d34 <usertrap+0xa4>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001cae:	00003797          	auipc	a5,0x3
    80001cb2:	75278793          	addi	a5,a5,1874 # 80005400 <kernelvec>
    80001cb6:	10579073          	csrw	stvec,a5
    struct proc *p = myproc();
    80001cba:	fffff097          	auipc	ra,0xfffff
    80001cbe:	1a8080e7          	jalr	424(ra) # 80000e62 <myproc>
    80001cc2:	892a                	mv	s2,a0
    p->trapframe->epc = r_sepc();
    80001cc4:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001cc6:	14102773          	csrr	a4,sepc
    80001cca:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001ccc:	14202773          	csrr	a4,scause
    if (r_scause() == 8)
    80001cd0:	47a1                	li	a5,8
    80001cd2:	06f70963          	beq	a4,a5,80001d44 <usertrap+0xb4>
    else if ((which_dev = devintr()) != 0)
    80001cd6:	00000097          	auipc	ra,0x0
    80001cda:	f18080e7          	jalr	-232(ra) # 80001bee <devintr>
    80001cde:	84aa                	mv	s1,a0
    80001ce0:	18051063          	bnez	a0,80001e60 <usertrap+0x1d0>
    80001ce4:	14202773          	csrr	a4,scause
    else if (r_scause() == 13 || r_scause() == 15)
    80001ce8:	47b5                	li	a5,13
    80001cea:	0af70b63          	beq	a4,a5,80001da0 <usertrap+0x110>
    80001cee:	14202773          	csrr	a4,scause
    80001cf2:	47bd                	li	a5,15
    80001cf4:	0af70663          	beq	a4,a5,80001da0 <usertrap+0x110>
    80001cf8:	142025f3          	csrr	a1,scause
        printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001cfc:	03092603          	lw	a2,48(s2)
    80001d00:	00006517          	auipc	a0,0x6
    80001d04:	5e050513          	addi	a0,a0,1504 # 800082e0 <states.1738+0xa0>
    80001d08:	00004097          	auipc	ra,0x4
    80001d0c:	374080e7          	jalr	884(ra) # 8000607c <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d10:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001d14:	14302673          	csrr	a2,stval
        printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001d18:	00006517          	auipc	a0,0x6
    80001d1c:	5f850513          	addi	a0,a0,1528 # 80008310 <states.1738+0xd0>
    80001d20:	00004097          	auipc	ra,0x4
    80001d24:	35c080e7          	jalr	860(ra) # 8000607c <printf>
        setkilled(p);
    80001d28:	854a                	mv	a0,s2
    80001d2a:	00000097          	auipc	ra,0x0
    80001d2e:	a58080e7          	jalr	-1448(ra) # 80001782 <setkilled>
    80001d32:	a82d                	j	80001d6c <usertrap+0xdc>
        panic("usertrap: not from user mode");
    80001d34:	00006517          	auipc	a0,0x6
    80001d38:	56450513          	addi	a0,a0,1380 # 80008298 <states.1738+0x58>
    80001d3c:	00004097          	auipc	ra,0x4
    80001d40:	2f6080e7          	jalr	758(ra) # 80006032 <panic>
        if (killed(p))
    80001d44:	00000097          	auipc	ra,0x0
    80001d48:	a6a080e7          	jalr	-1430(ra) # 800017ae <killed>
    80001d4c:	e521                	bnez	a0,80001d94 <usertrap+0x104>
        p->trapframe->epc += 4;
    80001d4e:	05893703          	ld	a4,88(s2)
    80001d52:	6f1c                	ld	a5,24(a4)
    80001d54:	0791                	addi	a5,a5,4
    80001d56:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d58:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001d5c:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d60:	10079073          	csrw	sstatus,a5
        syscall();
    80001d64:	00000097          	auipc	ra,0x0
    80001d68:	370080e7          	jalr	880(ra) # 800020d4 <syscall>
    if (killed(p))
    80001d6c:	854a                	mv	a0,s2
    80001d6e:	00000097          	auipc	ra,0x0
    80001d72:	a40080e7          	jalr	-1472(ra) # 800017ae <killed>
    80001d76:	ed65                	bnez	a0,80001e6e <usertrap+0x1de>
    usertrapret();
    80001d78:	00000097          	auipc	ra,0x0
    80001d7c:	d9a080e7          	jalr	-614(ra) # 80001b12 <usertrapret>
}
    80001d80:	70e2                	ld	ra,56(sp)
    80001d82:	7442                	ld	s0,48(sp)
    80001d84:	74a2                	ld	s1,40(sp)
    80001d86:	7902                	ld	s2,32(sp)
    80001d88:	69e2                	ld	s3,24(sp)
    80001d8a:	6a42                	ld	s4,16(sp)
    80001d8c:	6aa2                	ld	s5,8(sp)
    80001d8e:	6b02                	ld	s6,0(sp)
    80001d90:	6121                	addi	sp,sp,64
    80001d92:	8082                	ret
            exit(-1);
    80001d94:	557d                	li	a0,-1
    80001d96:	00000097          	auipc	ra,0x0
    80001d9a:	8a4080e7          	jalr	-1884(ra) # 8000163a <exit>
    80001d9e:	bf45                	j	80001d4e <usertrap+0xbe>
        struct proc *p_proc = myproc();
    80001da0:	fffff097          	auipc	ra,0xfffff
    80001da4:	0c2080e7          	jalr	194(ra) # 80000e62 <myproc>
    80001da8:	8a2a                	mv	s4,a0
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001daa:	143029f3          	csrr	s3,stval
        for (int i = 0; i <= VMASIZE - 1; i++)
    80001dae:	16850793          	addi	a5,a0,360
            if (p_proc->vma[i].occupied == 1)
    80001db2:	4605                	li	a2,1
        for (int i = 0; i <= VMASIZE - 1; i++)
    80001db4:	45c1                	li	a1,16
    80001db6:	a031                	j	80001dc2 <usertrap+0x132>
    80001db8:	2485                	addiw	s1,s1,1
    80001dba:	04878793          	addi	a5,a5,72
    80001dbe:	08b48863          	beq	s1,a1,80001e4e <usertrap+0x1be>
            if (p_proc->vma[i].occupied == 1)
    80001dc2:	4398                	lw	a4,0(a5)
    80001dc4:	fec71ae3          	bne	a4,a2,80001db8 <usertrap+0x128>
                if (p_proc->vma[i].start_addr <= va && va <= p_proc->vma[i].end_addr)
    80001dc8:	6798                	ld	a4,8(a5)
    80001dca:	fee9e7e3          	bltu	s3,a4,80001db8 <usertrap+0x128>
    80001dce:	6b98                	ld	a4,16(a5)
    80001dd0:	ff3764e3          	bltu	a4,s3,80001db8 <usertrap+0x128>
            char *mem = (char *)kalloc();
    80001dd4:	ffffe097          	auipc	ra,0xffffe
    80001dd8:	344080e7          	jalr	836(ra) # 80000118 <kalloc>
    80001ddc:	8b2a                	mv	s6,a0
            if (mem == 0)
    80001dde:	c135                	beqz	a0,80001e42 <usertrap+0x1b2>
                memset(mem, 0, PGSIZE);
    80001de0:	6605                	lui	a2,0x1
    80001de2:	4581                	li	a1,0
    80001de4:	ffffe097          	auipc	ra,0xffffe
    80001de8:	394080e7          	jalr	916(ra) # 80000178 <memset>
                mapfile(p_vma->pf, mem, va - p_vma->start_addr);
    80001dec:	00349a93          	slli	s5,s1,0x3
    80001df0:	009a87b3          	add	a5,s5,s1
    80001df4:	078e                	slli	a5,a5,0x3
    80001df6:	97d2                	add	a5,a5,s4
    80001df8:	1707b603          	ld	a2,368(a5)
    80001dfc:	40c9863b          	subw	a2,s3,a2
    80001e00:	85da                	mv	a1,s6
    80001e02:	1a87b503          	ld	a0,424(a5)
    80001e06:	00002097          	auipc	ra,0x2
    80001e0a:	d98080e7          	jalr	-616(ra) # 80003b9e <mapfile>
                if (mappages(p_proc->pagetable, va, PGSIZE, (uint64)mem, (p_vma->prot | PTE_R | PTE_X | PTE_W | PTE_U)) == -1)
    80001e0e:	009a87b3          	add	a5,s5,s1
    80001e12:	078e                	slli	a5,a5,0x3
    80001e14:	97d2                	add	a5,a5,s4
    80001e16:	1907a703          	lw	a4,400(a5)
    80001e1a:	01e76713          	ori	a4,a4,30
    80001e1e:	86da                	mv	a3,s6
    80001e20:	6605                	lui	a2,0x1
    80001e22:	85ce                	mv	a1,s3
    80001e24:	050a3503          	ld	a0,80(s4)
    80001e28:	ffffe097          	auipc	ra,0xffffe
    80001e2c:	724080e7          	jalr	1828(ra) # 8000054c <mappages>
    80001e30:	57fd                	li	a5,-1
    80001e32:	f2f51de3          	bne	a0,a5,80001d6c <usertrap+0xdc>
                    setkilled(p_proc);
    80001e36:	8552                	mv	a0,s4
    80001e38:	00000097          	auipc	ra,0x0
    80001e3c:	94a080e7          	jalr	-1718(ra) # 80001782 <setkilled>
    80001e40:	b735                	j	80001d6c <usertrap+0xdc>
                setkilled(p_proc);
    80001e42:	8552                	mv	a0,s4
    80001e44:	00000097          	auipc	ra,0x0
    80001e48:	93e080e7          	jalr	-1730(ra) # 80001782 <setkilled>
                return;
    80001e4c:	bf15                	j	80001d80 <usertrap+0xf0>
            printf("Now, after mmap, we get a page fault\n");
    80001e4e:	00006517          	auipc	a0,0x6
    80001e52:	46a50513          	addi	a0,a0,1130 # 800082b8 <states.1738+0x78>
    80001e56:	00004097          	auipc	ra,0x4
    80001e5a:	226080e7          	jalr	550(ra) # 8000607c <printf>
            goto err;
    80001e5e:	bd69                	j	80001cf8 <usertrap+0x68>
    if (killed(p))
    80001e60:	854a                	mv	a0,s2
    80001e62:	00000097          	auipc	ra,0x0
    80001e66:	94c080e7          	jalr	-1716(ra) # 800017ae <killed>
    80001e6a:	c901                	beqz	a0,80001e7a <usertrap+0x1ea>
    80001e6c:	a011                	j	80001e70 <usertrap+0x1e0>
    80001e6e:	4481                	li	s1,0
        exit(-1);
    80001e70:	557d                	li	a0,-1
    80001e72:	fffff097          	auipc	ra,0xfffff
    80001e76:	7c8080e7          	jalr	1992(ra) # 8000163a <exit>
    if (which_dev == 2)
    80001e7a:	4789                	li	a5,2
    80001e7c:	eef49ee3          	bne	s1,a5,80001d78 <usertrap+0xe8>
        yield();
    80001e80:	fffff097          	auipc	ra,0xfffff
    80001e84:	64a080e7          	jalr	1610(ra) # 800014ca <yield>
    80001e88:	bdc5                	j	80001d78 <usertrap+0xe8>

0000000080001e8a <kerneltrap>:
{
    80001e8a:	7179                	addi	sp,sp,-48
    80001e8c:	f406                	sd	ra,40(sp)
    80001e8e:	f022                	sd	s0,32(sp)
    80001e90:	ec26                	sd	s1,24(sp)
    80001e92:	e84a                	sd	s2,16(sp)
    80001e94:	e44e                	sd	s3,8(sp)
    80001e96:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001e98:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001e9c:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001ea0:	142029f3          	csrr	s3,scause
    if ((sstatus & SSTATUS_SPP) == 0)
    80001ea4:	1004f793          	andi	a5,s1,256
    80001ea8:	cb85                	beqz	a5,80001ed8 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001eaa:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001eae:	8b89                	andi	a5,a5,2
    if (intr_get() != 0)
    80001eb0:	ef85                	bnez	a5,80001ee8 <kerneltrap+0x5e>
    if ((which_dev = devintr()) == 0)
    80001eb2:	00000097          	auipc	ra,0x0
    80001eb6:	d3c080e7          	jalr	-708(ra) # 80001bee <devintr>
    80001eba:	cd1d                	beqz	a0,80001ef8 <kerneltrap+0x6e>
    if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001ebc:	4789                	li	a5,2
    80001ebe:	06f50a63          	beq	a0,a5,80001f32 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001ec2:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ec6:	10049073          	csrw	sstatus,s1
}
    80001eca:	70a2                	ld	ra,40(sp)
    80001ecc:	7402                	ld	s0,32(sp)
    80001ece:	64e2                	ld	s1,24(sp)
    80001ed0:	6942                	ld	s2,16(sp)
    80001ed2:	69a2                	ld	s3,8(sp)
    80001ed4:	6145                	addi	sp,sp,48
    80001ed6:	8082                	ret
        panic("kerneltrap: not from supervisor mode");
    80001ed8:	00006517          	auipc	a0,0x6
    80001edc:	45850513          	addi	a0,a0,1112 # 80008330 <states.1738+0xf0>
    80001ee0:	00004097          	auipc	ra,0x4
    80001ee4:	152080e7          	jalr	338(ra) # 80006032 <panic>
        panic("kerneltrap: interrupts enabled");
    80001ee8:	00006517          	auipc	a0,0x6
    80001eec:	47050513          	addi	a0,a0,1136 # 80008358 <states.1738+0x118>
    80001ef0:	00004097          	auipc	ra,0x4
    80001ef4:	142080e7          	jalr	322(ra) # 80006032 <panic>
        printf("scause %p\n", scause);
    80001ef8:	85ce                	mv	a1,s3
    80001efa:	00006517          	auipc	a0,0x6
    80001efe:	47e50513          	addi	a0,a0,1150 # 80008378 <states.1738+0x138>
    80001f02:	00004097          	auipc	ra,0x4
    80001f06:	17a080e7          	jalr	378(ra) # 8000607c <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f0a:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001f0e:	14302673          	csrr	a2,stval
        printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001f12:	00006517          	auipc	a0,0x6
    80001f16:	47650513          	addi	a0,a0,1142 # 80008388 <states.1738+0x148>
    80001f1a:	00004097          	auipc	ra,0x4
    80001f1e:	162080e7          	jalr	354(ra) # 8000607c <printf>
        panic("kerneltrap");
    80001f22:	00006517          	auipc	a0,0x6
    80001f26:	47e50513          	addi	a0,a0,1150 # 800083a0 <states.1738+0x160>
    80001f2a:	00004097          	auipc	ra,0x4
    80001f2e:	108080e7          	jalr	264(ra) # 80006032 <panic>
    if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001f32:	fffff097          	auipc	ra,0xfffff
    80001f36:	f30080e7          	jalr	-208(ra) # 80000e62 <myproc>
    80001f3a:	d541                	beqz	a0,80001ec2 <kerneltrap+0x38>
    80001f3c:	fffff097          	auipc	ra,0xfffff
    80001f40:	f26080e7          	jalr	-218(ra) # 80000e62 <myproc>
    80001f44:	4d18                	lw	a4,24(a0)
    80001f46:	4791                	li	a5,4
    80001f48:	f6f71de3          	bne	a4,a5,80001ec2 <kerneltrap+0x38>
        yield();
    80001f4c:	fffff097          	auipc	ra,0xfffff
    80001f50:	57e080e7          	jalr	1406(ra) # 800014ca <yield>
    80001f54:	b7bd                	j	80001ec2 <kerneltrap+0x38>

0000000080001f56 <argraw>:
    return strlen(buf);
}

static uint64
argraw(int n)
{
    80001f56:	1101                	addi	sp,sp,-32
    80001f58:	ec06                	sd	ra,24(sp)
    80001f5a:	e822                	sd	s0,16(sp)
    80001f5c:	e426                	sd	s1,8(sp)
    80001f5e:	1000                	addi	s0,sp,32
    80001f60:	84aa                	mv	s1,a0
    struct proc *p = myproc();
    80001f62:	fffff097          	auipc	ra,0xfffff
    80001f66:	f00080e7          	jalr	-256(ra) # 80000e62 <myproc>
    switch (n)
    80001f6a:	4795                	li	a5,5
    80001f6c:	0497e163          	bltu	a5,s1,80001fae <argraw+0x58>
    80001f70:	048a                	slli	s1,s1,0x2
    80001f72:	00006717          	auipc	a4,0x6
    80001f76:	46670713          	addi	a4,a4,1126 # 800083d8 <states.1738+0x198>
    80001f7a:	94ba                	add	s1,s1,a4
    80001f7c:	409c                	lw	a5,0(s1)
    80001f7e:	97ba                	add	a5,a5,a4
    80001f80:	8782                	jr	a5
    {
    case 0:
        return p->trapframe->a0;
    80001f82:	6d3c                	ld	a5,88(a0)
    80001f84:	7ba8                	ld	a0,112(a5)
    case 5:
        return p->trapframe->a5;
    }
    panic("argraw");
    return -1;
}
    80001f86:	60e2                	ld	ra,24(sp)
    80001f88:	6442                	ld	s0,16(sp)
    80001f8a:	64a2                	ld	s1,8(sp)
    80001f8c:	6105                	addi	sp,sp,32
    80001f8e:	8082                	ret
        return p->trapframe->a1;
    80001f90:	6d3c                	ld	a5,88(a0)
    80001f92:	7fa8                	ld	a0,120(a5)
    80001f94:	bfcd                	j	80001f86 <argraw+0x30>
        return p->trapframe->a2;
    80001f96:	6d3c                	ld	a5,88(a0)
    80001f98:	63c8                	ld	a0,128(a5)
    80001f9a:	b7f5                	j	80001f86 <argraw+0x30>
        return p->trapframe->a3;
    80001f9c:	6d3c                	ld	a5,88(a0)
    80001f9e:	67c8                	ld	a0,136(a5)
    80001fa0:	b7dd                	j	80001f86 <argraw+0x30>
        return p->trapframe->a4;
    80001fa2:	6d3c                	ld	a5,88(a0)
    80001fa4:	6bc8                	ld	a0,144(a5)
    80001fa6:	b7c5                	j	80001f86 <argraw+0x30>
        return p->trapframe->a5;
    80001fa8:	6d3c                	ld	a5,88(a0)
    80001faa:	6fc8                	ld	a0,152(a5)
    80001fac:	bfe9                	j	80001f86 <argraw+0x30>
    panic("argraw");
    80001fae:	00006517          	auipc	a0,0x6
    80001fb2:	40250513          	addi	a0,a0,1026 # 800083b0 <states.1738+0x170>
    80001fb6:	00004097          	auipc	ra,0x4
    80001fba:	07c080e7          	jalr	124(ra) # 80006032 <panic>

0000000080001fbe <fetchaddr>:
{
    80001fbe:	1101                	addi	sp,sp,-32
    80001fc0:	ec06                	sd	ra,24(sp)
    80001fc2:	e822                	sd	s0,16(sp)
    80001fc4:	e426                	sd	s1,8(sp)
    80001fc6:	e04a                	sd	s2,0(sp)
    80001fc8:	1000                	addi	s0,sp,32
    80001fca:	84aa                	mv	s1,a0
    80001fcc:	892e                	mv	s2,a1
    struct proc *p = myproc();
    80001fce:	fffff097          	auipc	ra,0xfffff
    80001fd2:	e94080e7          	jalr	-364(ra) # 80000e62 <myproc>
    if (addr >= p->sz || addr + sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80001fd6:	653c                	ld	a5,72(a0)
    80001fd8:	02f4f863          	bgeu	s1,a5,80002008 <fetchaddr+0x4a>
    80001fdc:	00848713          	addi	a4,s1,8
    80001fe0:	02e7e663          	bltu	a5,a4,8000200c <fetchaddr+0x4e>
    if (copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80001fe4:	46a1                	li	a3,8
    80001fe6:	8626                	mv	a2,s1
    80001fe8:	85ca                	mv	a1,s2
    80001fea:	6928                	ld	a0,80(a0)
    80001fec:	fffff097          	auipc	ra,0xfffff
    80001ff0:	bc0080e7          	jalr	-1088(ra) # 80000bac <copyin>
    80001ff4:	00a03533          	snez	a0,a0
    80001ff8:	40a00533          	neg	a0,a0
}
    80001ffc:	60e2                	ld	ra,24(sp)
    80001ffe:	6442                	ld	s0,16(sp)
    80002000:	64a2                	ld	s1,8(sp)
    80002002:	6902                	ld	s2,0(sp)
    80002004:	6105                	addi	sp,sp,32
    80002006:	8082                	ret
        return -1;
    80002008:	557d                	li	a0,-1
    8000200a:	bfcd                	j	80001ffc <fetchaddr+0x3e>
    8000200c:	557d                	li	a0,-1
    8000200e:	b7fd                	j	80001ffc <fetchaddr+0x3e>

0000000080002010 <fetchstr>:
{
    80002010:	7179                	addi	sp,sp,-48
    80002012:	f406                	sd	ra,40(sp)
    80002014:	f022                	sd	s0,32(sp)
    80002016:	ec26                	sd	s1,24(sp)
    80002018:	e84a                	sd	s2,16(sp)
    8000201a:	e44e                	sd	s3,8(sp)
    8000201c:	1800                	addi	s0,sp,48
    8000201e:	892a                	mv	s2,a0
    80002020:	84ae                	mv	s1,a1
    80002022:	89b2                	mv	s3,a2
    struct proc *p = myproc();
    80002024:	fffff097          	auipc	ra,0xfffff
    80002028:	e3e080e7          	jalr	-450(ra) # 80000e62 <myproc>
    if (copyinstr(p->pagetable, buf, addr, max) < 0)
    8000202c:	86ce                	mv	a3,s3
    8000202e:	864a                	mv	a2,s2
    80002030:	85a6                	mv	a1,s1
    80002032:	6928                	ld	a0,80(a0)
    80002034:	fffff097          	auipc	ra,0xfffff
    80002038:	c04080e7          	jalr	-1020(ra) # 80000c38 <copyinstr>
    8000203c:	00054e63          	bltz	a0,80002058 <fetchstr+0x48>
    return strlen(buf);
    80002040:	8526                	mv	a0,s1
    80002042:	ffffe097          	auipc	ra,0xffffe
    80002046:	2ba080e7          	jalr	698(ra) # 800002fc <strlen>
}
    8000204a:	70a2                	ld	ra,40(sp)
    8000204c:	7402                	ld	s0,32(sp)
    8000204e:	64e2                	ld	s1,24(sp)
    80002050:	6942                	ld	s2,16(sp)
    80002052:	69a2                	ld	s3,8(sp)
    80002054:	6145                	addi	sp,sp,48
    80002056:	8082                	ret
        return -1;
    80002058:	557d                	li	a0,-1
    8000205a:	bfc5                	j	8000204a <fetchstr+0x3a>

000000008000205c <argint>:

// Fetch the nth 32-bit system call argument.
void argint(int n, int *ip)
{
    8000205c:	1101                	addi	sp,sp,-32
    8000205e:	ec06                	sd	ra,24(sp)
    80002060:	e822                	sd	s0,16(sp)
    80002062:	e426                	sd	s1,8(sp)
    80002064:	1000                	addi	s0,sp,32
    80002066:	84ae                	mv	s1,a1
    *ip = argraw(n);
    80002068:	00000097          	auipc	ra,0x0
    8000206c:	eee080e7          	jalr	-274(ra) # 80001f56 <argraw>
    80002070:	c088                	sw	a0,0(s1)
}
    80002072:	60e2                	ld	ra,24(sp)
    80002074:	6442                	ld	s0,16(sp)
    80002076:	64a2                	ld	s1,8(sp)
    80002078:	6105                	addi	sp,sp,32
    8000207a:	8082                	ret

000000008000207c <argaddr>:

// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void argaddr(int n, uint64 *ip)
{
    8000207c:	1101                	addi	sp,sp,-32
    8000207e:	ec06                	sd	ra,24(sp)
    80002080:	e822                	sd	s0,16(sp)
    80002082:	e426                	sd	s1,8(sp)
    80002084:	1000                	addi	s0,sp,32
    80002086:	84ae                	mv	s1,a1
    *ip = argraw(n);
    80002088:	00000097          	auipc	ra,0x0
    8000208c:	ece080e7          	jalr	-306(ra) # 80001f56 <argraw>
    80002090:	e088                	sd	a0,0(s1)
}
    80002092:	60e2                	ld	ra,24(sp)
    80002094:	6442                	ld	s0,16(sp)
    80002096:	64a2                	ld	s1,8(sp)
    80002098:	6105                	addi	sp,sp,32
    8000209a:	8082                	ret

000000008000209c <argstr>:

// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int argstr(int n, char *buf, int max)
{
    8000209c:	7179                	addi	sp,sp,-48
    8000209e:	f406                	sd	ra,40(sp)
    800020a0:	f022                	sd	s0,32(sp)
    800020a2:	ec26                	sd	s1,24(sp)
    800020a4:	e84a                	sd	s2,16(sp)
    800020a6:	1800                	addi	s0,sp,48
    800020a8:	84ae                	mv	s1,a1
    800020aa:	8932                	mv	s2,a2
    uint64 addr;
    argaddr(n, &addr);
    800020ac:	fd840593          	addi	a1,s0,-40
    800020b0:	00000097          	auipc	ra,0x0
    800020b4:	fcc080e7          	jalr	-52(ra) # 8000207c <argaddr>
    return fetchstr(addr, buf, max);
    800020b8:	864a                	mv	a2,s2
    800020ba:	85a6                	mv	a1,s1
    800020bc:	fd843503          	ld	a0,-40(s0)
    800020c0:	00000097          	auipc	ra,0x0
    800020c4:	f50080e7          	jalr	-176(ra) # 80002010 <fetchstr>
}
    800020c8:	70a2                	ld	ra,40(sp)
    800020ca:	7402                	ld	s0,32(sp)
    800020cc:	64e2                	ld	s1,24(sp)
    800020ce:	6942                	ld	s2,16(sp)
    800020d0:	6145                	addi	sp,sp,48
    800020d2:	8082                	ret

00000000800020d4 <syscall>:
    [SYS_mmap] sys_mmap,
    [SYS_munmap] sys_munmap,
};

void syscall(void)
{
    800020d4:	1101                	addi	sp,sp,-32
    800020d6:	ec06                	sd	ra,24(sp)
    800020d8:	e822                	sd	s0,16(sp)
    800020da:	e426                	sd	s1,8(sp)
    800020dc:	e04a                	sd	s2,0(sp)
    800020de:	1000                	addi	s0,sp,32
    int num;
    struct proc *p = myproc();
    800020e0:	fffff097          	auipc	ra,0xfffff
    800020e4:	d82080e7          	jalr	-638(ra) # 80000e62 <myproc>
    800020e8:	84aa                	mv	s1,a0

    num = p->trapframe->a7;
    800020ea:	05853903          	ld	s2,88(a0)
    800020ee:	0a893783          	ld	a5,168(s2)
    800020f2:	0007869b          	sext.w	a3,a5
    if (num > 0 && num < NELEM(syscalls) && syscalls[num])
    800020f6:	37fd                	addiw	a5,a5,-1
    800020f8:	4759                	li	a4,22
    800020fa:	00f76f63          	bltu	a4,a5,80002118 <syscall+0x44>
    800020fe:	00369713          	slli	a4,a3,0x3
    80002102:	00006797          	auipc	a5,0x6
    80002106:	2ee78793          	addi	a5,a5,750 # 800083f0 <syscalls>
    8000210a:	97ba                	add	a5,a5,a4
    8000210c:	639c                	ld	a5,0(a5)
    8000210e:	c789                	beqz	a5,80002118 <syscall+0x44>
    {
        // Use num to lookup the system call function for num, call it,
        // and store its return value in p->trapframe->a0
        p->trapframe->a0 = syscalls[num]();
    80002110:	9782                	jalr	a5
    80002112:	06a93823          	sd	a0,112(s2)
    80002116:	a839                	j	80002134 <syscall+0x60>
    }
    else
    {
        printf("%d %s: unknown sys call %d\n",
    80002118:	15848613          	addi	a2,s1,344
    8000211c:	588c                	lw	a1,48(s1)
    8000211e:	00006517          	auipc	a0,0x6
    80002122:	29a50513          	addi	a0,a0,666 # 800083b8 <states.1738+0x178>
    80002126:	00004097          	auipc	ra,0x4
    8000212a:	f56080e7          	jalr	-170(ra) # 8000607c <printf>
               p->pid, p->name, num);
        p->trapframe->a0 = -1;
    8000212e:	6cbc                	ld	a5,88(s1)
    80002130:	577d                	li	a4,-1
    80002132:	fbb8                	sd	a4,112(a5)
    }
}
    80002134:	60e2                	ld	ra,24(sp)
    80002136:	6442                	ld	s0,16(sp)
    80002138:	64a2                	ld	s1,8(sp)
    8000213a:	6902                	ld	s2,0(sp)
    8000213c:	6105                	addi	sp,sp,32
    8000213e:	8082                	ret

0000000080002140 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002140:	1101                	addi	sp,sp,-32
    80002142:	ec06                	sd	ra,24(sp)
    80002144:	e822                	sd	s0,16(sp)
    80002146:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80002148:	fec40593          	addi	a1,s0,-20
    8000214c:	4501                	li	a0,0
    8000214e:	00000097          	auipc	ra,0x0
    80002152:	f0e080e7          	jalr	-242(ra) # 8000205c <argint>
  exit(n);
    80002156:	fec42503          	lw	a0,-20(s0)
    8000215a:	fffff097          	auipc	ra,0xfffff
    8000215e:	4e0080e7          	jalr	1248(ra) # 8000163a <exit>
  return 0;  // not reached
}
    80002162:	4501                	li	a0,0
    80002164:	60e2                	ld	ra,24(sp)
    80002166:	6442                	ld	s0,16(sp)
    80002168:	6105                	addi	sp,sp,32
    8000216a:	8082                	ret

000000008000216c <sys_getpid>:

uint64
sys_getpid(void)
{
    8000216c:	1141                	addi	sp,sp,-16
    8000216e:	e406                	sd	ra,8(sp)
    80002170:	e022                	sd	s0,0(sp)
    80002172:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002174:	fffff097          	auipc	ra,0xfffff
    80002178:	cee080e7          	jalr	-786(ra) # 80000e62 <myproc>
}
    8000217c:	5908                	lw	a0,48(a0)
    8000217e:	60a2                	ld	ra,8(sp)
    80002180:	6402                	ld	s0,0(sp)
    80002182:	0141                	addi	sp,sp,16
    80002184:	8082                	ret

0000000080002186 <sys_fork>:

uint64
sys_fork(void)
{
    80002186:	1141                	addi	sp,sp,-16
    80002188:	e406                	sd	ra,8(sp)
    8000218a:	e022                	sd	s0,0(sp)
    8000218c:	0800                	addi	s0,sp,16
  return fork();
    8000218e:	fffff097          	auipc	ra,0xfffff
    80002192:	08a080e7          	jalr	138(ra) # 80001218 <fork>
}
    80002196:	60a2                	ld	ra,8(sp)
    80002198:	6402                	ld	s0,0(sp)
    8000219a:	0141                	addi	sp,sp,16
    8000219c:	8082                	ret

000000008000219e <sys_wait>:

uint64
sys_wait(void)
{
    8000219e:	1101                	addi	sp,sp,-32
    800021a0:	ec06                	sd	ra,24(sp)
    800021a2:	e822                	sd	s0,16(sp)
    800021a4:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    800021a6:	fe840593          	addi	a1,s0,-24
    800021aa:	4501                	li	a0,0
    800021ac:	00000097          	auipc	ra,0x0
    800021b0:	ed0080e7          	jalr	-304(ra) # 8000207c <argaddr>
  return wait(p);
    800021b4:	fe843503          	ld	a0,-24(s0)
    800021b8:	fffff097          	auipc	ra,0xfffff
    800021bc:	628080e7          	jalr	1576(ra) # 800017e0 <wait>
}
    800021c0:	60e2                	ld	ra,24(sp)
    800021c2:	6442                	ld	s0,16(sp)
    800021c4:	6105                	addi	sp,sp,32
    800021c6:	8082                	ret

00000000800021c8 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800021c8:	7179                	addi	sp,sp,-48
    800021ca:	f406                	sd	ra,40(sp)
    800021cc:	f022                	sd	s0,32(sp)
    800021ce:	ec26                	sd	s1,24(sp)
    800021d0:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    800021d2:	fdc40593          	addi	a1,s0,-36
    800021d6:	4501                	li	a0,0
    800021d8:	00000097          	auipc	ra,0x0
    800021dc:	e84080e7          	jalr	-380(ra) # 8000205c <argint>
  addr = myproc()->sz;
    800021e0:	fffff097          	auipc	ra,0xfffff
    800021e4:	c82080e7          	jalr	-894(ra) # 80000e62 <myproc>
    800021e8:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    800021ea:	fdc42503          	lw	a0,-36(s0)
    800021ee:	fffff097          	auipc	ra,0xfffff
    800021f2:	fce080e7          	jalr	-50(ra) # 800011bc <growproc>
    800021f6:	00054863          	bltz	a0,80002206 <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    800021fa:	8526                	mv	a0,s1
    800021fc:	70a2                	ld	ra,40(sp)
    800021fe:	7402                	ld	s0,32(sp)
    80002200:	64e2                	ld	s1,24(sp)
    80002202:	6145                	addi	sp,sp,48
    80002204:	8082                	ret
    return -1;
    80002206:	54fd                	li	s1,-1
    80002208:	bfcd                	j	800021fa <sys_sbrk+0x32>

000000008000220a <sys_sleep>:

uint64
sys_sleep(void)
{
    8000220a:	7139                	addi	sp,sp,-64
    8000220c:	fc06                	sd	ra,56(sp)
    8000220e:	f822                	sd	s0,48(sp)
    80002210:	f426                	sd	s1,40(sp)
    80002212:	f04a                	sd	s2,32(sp)
    80002214:	ec4e                	sd	s3,24(sp)
    80002216:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80002218:	fcc40593          	addi	a1,s0,-52
    8000221c:	4501                	li	a0,0
    8000221e:	00000097          	auipc	ra,0x0
    80002222:	e3e080e7          	jalr	-450(ra) # 8000205c <argint>
  if(n < 0)
    80002226:	fcc42783          	lw	a5,-52(s0)
    8000222a:	0607cf63          	bltz	a5,800022a8 <sys_sleep+0x9e>
    n = 0;
  acquire(&tickslock);
    8000222e:	0001e517          	auipc	a0,0x1e
    80002232:	72250513          	addi	a0,a0,1826 # 80020950 <tickslock>
    80002236:	00004097          	auipc	ra,0x4
    8000223a:	346080e7          	jalr	838(ra) # 8000657c <acquire>
  ticks0 = ticks;
    8000223e:	00007917          	auipc	s2,0x7
    80002242:	8aa92903          	lw	s2,-1878(s2) # 80008ae8 <ticks>
  while(ticks - ticks0 < n){
    80002246:	fcc42783          	lw	a5,-52(s0)
    8000224a:	cf9d                	beqz	a5,80002288 <sys_sleep+0x7e>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    8000224c:	0001e997          	auipc	s3,0x1e
    80002250:	70498993          	addi	s3,s3,1796 # 80020950 <tickslock>
    80002254:	00007497          	auipc	s1,0x7
    80002258:	89448493          	addi	s1,s1,-1900 # 80008ae8 <ticks>
    if(killed(myproc())){
    8000225c:	fffff097          	auipc	ra,0xfffff
    80002260:	c06080e7          	jalr	-1018(ra) # 80000e62 <myproc>
    80002264:	fffff097          	auipc	ra,0xfffff
    80002268:	54a080e7          	jalr	1354(ra) # 800017ae <killed>
    8000226c:	e129                	bnez	a0,800022ae <sys_sleep+0xa4>
    sleep(&ticks, &tickslock);
    8000226e:	85ce                	mv	a1,s3
    80002270:	8526                	mv	a0,s1
    80002272:	fffff097          	auipc	ra,0xfffff
    80002276:	294080e7          	jalr	660(ra) # 80001506 <sleep>
  while(ticks - ticks0 < n){
    8000227a:	409c                	lw	a5,0(s1)
    8000227c:	412787bb          	subw	a5,a5,s2
    80002280:	fcc42703          	lw	a4,-52(s0)
    80002284:	fce7ece3          	bltu	a5,a4,8000225c <sys_sleep+0x52>
  }
  release(&tickslock);
    80002288:	0001e517          	auipc	a0,0x1e
    8000228c:	6c850513          	addi	a0,a0,1736 # 80020950 <tickslock>
    80002290:	00004097          	auipc	ra,0x4
    80002294:	3a0080e7          	jalr	928(ra) # 80006630 <release>
  return 0;
    80002298:	4501                	li	a0,0
}
    8000229a:	70e2                	ld	ra,56(sp)
    8000229c:	7442                	ld	s0,48(sp)
    8000229e:	74a2                	ld	s1,40(sp)
    800022a0:	7902                	ld	s2,32(sp)
    800022a2:	69e2                	ld	s3,24(sp)
    800022a4:	6121                	addi	sp,sp,64
    800022a6:	8082                	ret
    n = 0;
    800022a8:	fc042623          	sw	zero,-52(s0)
    800022ac:	b749                	j	8000222e <sys_sleep+0x24>
      release(&tickslock);
    800022ae:	0001e517          	auipc	a0,0x1e
    800022b2:	6a250513          	addi	a0,a0,1698 # 80020950 <tickslock>
    800022b6:	00004097          	auipc	ra,0x4
    800022ba:	37a080e7          	jalr	890(ra) # 80006630 <release>
      return -1;
    800022be:	557d                	li	a0,-1
    800022c0:	bfe9                	j	8000229a <sys_sleep+0x90>

00000000800022c2 <sys_kill>:

uint64
sys_kill(void)
{
    800022c2:	1101                	addi	sp,sp,-32
    800022c4:	ec06                	sd	ra,24(sp)
    800022c6:	e822                	sd	s0,16(sp)
    800022c8:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    800022ca:	fec40593          	addi	a1,s0,-20
    800022ce:	4501                	li	a0,0
    800022d0:	00000097          	auipc	ra,0x0
    800022d4:	d8c080e7          	jalr	-628(ra) # 8000205c <argint>
  return kill(pid);
    800022d8:	fec42503          	lw	a0,-20(s0)
    800022dc:	fffff097          	auipc	ra,0xfffff
    800022e0:	434080e7          	jalr	1076(ra) # 80001710 <kill>
}
    800022e4:	60e2                	ld	ra,24(sp)
    800022e6:	6442                	ld	s0,16(sp)
    800022e8:	6105                	addi	sp,sp,32
    800022ea:	8082                	ret

00000000800022ec <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    800022ec:	1101                	addi	sp,sp,-32
    800022ee:	ec06                	sd	ra,24(sp)
    800022f0:	e822                	sd	s0,16(sp)
    800022f2:	e426                	sd	s1,8(sp)
    800022f4:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    800022f6:	0001e517          	auipc	a0,0x1e
    800022fa:	65a50513          	addi	a0,a0,1626 # 80020950 <tickslock>
    800022fe:	00004097          	auipc	ra,0x4
    80002302:	27e080e7          	jalr	638(ra) # 8000657c <acquire>
  xticks = ticks;
    80002306:	00006497          	auipc	s1,0x6
    8000230a:	7e24a483          	lw	s1,2018(s1) # 80008ae8 <ticks>
  release(&tickslock);
    8000230e:	0001e517          	auipc	a0,0x1e
    80002312:	64250513          	addi	a0,a0,1602 # 80020950 <tickslock>
    80002316:	00004097          	auipc	ra,0x4
    8000231a:	31a080e7          	jalr	794(ra) # 80006630 <release>
  return xticks;
}
    8000231e:	02049513          	slli	a0,s1,0x20
    80002322:	9101                	srli	a0,a0,0x20
    80002324:	60e2                	ld	ra,24(sp)
    80002326:	6442                	ld	s0,16(sp)
    80002328:	64a2                	ld	s1,8(sp)
    8000232a:	6105                	addi	sp,sp,32
    8000232c:	8082                	ret

000000008000232e <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    8000232e:	7179                	addi	sp,sp,-48
    80002330:	f406                	sd	ra,40(sp)
    80002332:	f022                	sd	s0,32(sp)
    80002334:	ec26                	sd	s1,24(sp)
    80002336:	e84a                	sd	s2,16(sp)
    80002338:	e44e                	sd	s3,8(sp)
    8000233a:	e052                	sd	s4,0(sp)
    8000233c:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    8000233e:	00006597          	auipc	a1,0x6
    80002342:	17258593          	addi	a1,a1,370 # 800084b0 <syscalls+0xc0>
    80002346:	0001e517          	auipc	a0,0x1e
    8000234a:	62250513          	addi	a0,a0,1570 # 80020968 <bcache>
    8000234e:	00004097          	auipc	ra,0x4
    80002352:	19e080e7          	jalr	414(ra) # 800064ec <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002356:	00026797          	auipc	a5,0x26
    8000235a:	61278793          	addi	a5,a5,1554 # 80028968 <bcache+0x8000>
    8000235e:	00027717          	auipc	a4,0x27
    80002362:	87270713          	addi	a4,a4,-1934 # 80028bd0 <bcache+0x8268>
    80002366:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    8000236a:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000236e:	0001e497          	auipc	s1,0x1e
    80002372:	61248493          	addi	s1,s1,1554 # 80020980 <bcache+0x18>
    b->next = bcache.head.next;
    80002376:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002378:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    8000237a:	00006a17          	auipc	s4,0x6
    8000237e:	13ea0a13          	addi	s4,s4,318 # 800084b8 <syscalls+0xc8>
    b->next = bcache.head.next;
    80002382:	2b893783          	ld	a5,696(s2)
    80002386:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002388:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    8000238c:	85d2                	mv	a1,s4
    8000238e:	01048513          	addi	a0,s1,16
    80002392:	00001097          	auipc	ra,0x1
    80002396:	4c4080e7          	jalr	1220(ra) # 80003856 <initsleeplock>
    bcache.head.next->prev = b;
    8000239a:	2b893783          	ld	a5,696(s2)
    8000239e:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800023a0:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800023a4:	45848493          	addi	s1,s1,1112
    800023a8:	fd349de3          	bne	s1,s3,80002382 <binit+0x54>
  }
}
    800023ac:	70a2                	ld	ra,40(sp)
    800023ae:	7402                	ld	s0,32(sp)
    800023b0:	64e2                	ld	s1,24(sp)
    800023b2:	6942                	ld	s2,16(sp)
    800023b4:	69a2                	ld	s3,8(sp)
    800023b6:	6a02                	ld	s4,0(sp)
    800023b8:	6145                	addi	sp,sp,48
    800023ba:	8082                	ret

00000000800023bc <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800023bc:	7179                	addi	sp,sp,-48
    800023be:	f406                	sd	ra,40(sp)
    800023c0:	f022                	sd	s0,32(sp)
    800023c2:	ec26                	sd	s1,24(sp)
    800023c4:	e84a                	sd	s2,16(sp)
    800023c6:	e44e                	sd	s3,8(sp)
    800023c8:	1800                	addi	s0,sp,48
    800023ca:	89aa                	mv	s3,a0
    800023cc:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    800023ce:	0001e517          	auipc	a0,0x1e
    800023d2:	59a50513          	addi	a0,a0,1434 # 80020968 <bcache>
    800023d6:	00004097          	auipc	ra,0x4
    800023da:	1a6080e7          	jalr	422(ra) # 8000657c <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800023de:	00027497          	auipc	s1,0x27
    800023e2:	8424b483          	ld	s1,-1982(s1) # 80028c20 <bcache+0x82b8>
    800023e6:	00026797          	auipc	a5,0x26
    800023ea:	7ea78793          	addi	a5,a5,2026 # 80028bd0 <bcache+0x8268>
    800023ee:	02f48f63          	beq	s1,a5,8000242c <bread+0x70>
    800023f2:	873e                	mv	a4,a5
    800023f4:	a021                	j	800023fc <bread+0x40>
    800023f6:	68a4                	ld	s1,80(s1)
    800023f8:	02e48a63          	beq	s1,a4,8000242c <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    800023fc:	449c                	lw	a5,8(s1)
    800023fe:	ff379ce3          	bne	a5,s3,800023f6 <bread+0x3a>
    80002402:	44dc                	lw	a5,12(s1)
    80002404:	ff2799e3          	bne	a5,s2,800023f6 <bread+0x3a>
      b->refcnt++;
    80002408:	40bc                	lw	a5,64(s1)
    8000240a:	2785                	addiw	a5,a5,1
    8000240c:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000240e:	0001e517          	auipc	a0,0x1e
    80002412:	55a50513          	addi	a0,a0,1370 # 80020968 <bcache>
    80002416:	00004097          	auipc	ra,0x4
    8000241a:	21a080e7          	jalr	538(ra) # 80006630 <release>
      acquiresleep(&b->lock);
    8000241e:	01048513          	addi	a0,s1,16
    80002422:	00001097          	auipc	ra,0x1
    80002426:	46e080e7          	jalr	1134(ra) # 80003890 <acquiresleep>
      return b;
    8000242a:	a8b9                	j	80002488 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000242c:	00026497          	auipc	s1,0x26
    80002430:	7ec4b483          	ld	s1,2028(s1) # 80028c18 <bcache+0x82b0>
    80002434:	00026797          	auipc	a5,0x26
    80002438:	79c78793          	addi	a5,a5,1948 # 80028bd0 <bcache+0x8268>
    8000243c:	00f48863          	beq	s1,a5,8000244c <bread+0x90>
    80002440:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002442:	40bc                	lw	a5,64(s1)
    80002444:	cf81                	beqz	a5,8000245c <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002446:	64a4                	ld	s1,72(s1)
    80002448:	fee49de3          	bne	s1,a4,80002442 <bread+0x86>
  panic("bget: no buffers");
    8000244c:	00006517          	auipc	a0,0x6
    80002450:	07450513          	addi	a0,a0,116 # 800084c0 <syscalls+0xd0>
    80002454:	00004097          	auipc	ra,0x4
    80002458:	bde080e7          	jalr	-1058(ra) # 80006032 <panic>
      b->dev = dev;
    8000245c:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    80002460:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    80002464:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002468:	4785                	li	a5,1
    8000246a:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000246c:	0001e517          	auipc	a0,0x1e
    80002470:	4fc50513          	addi	a0,a0,1276 # 80020968 <bcache>
    80002474:	00004097          	auipc	ra,0x4
    80002478:	1bc080e7          	jalr	444(ra) # 80006630 <release>
      acquiresleep(&b->lock);
    8000247c:	01048513          	addi	a0,s1,16
    80002480:	00001097          	auipc	ra,0x1
    80002484:	410080e7          	jalr	1040(ra) # 80003890 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002488:	409c                	lw	a5,0(s1)
    8000248a:	cb89                	beqz	a5,8000249c <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    8000248c:	8526                	mv	a0,s1
    8000248e:	70a2                	ld	ra,40(sp)
    80002490:	7402                	ld	s0,32(sp)
    80002492:	64e2                	ld	s1,24(sp)
    80002494:	6942                	ld	s2,16(sp)
    80002496:	69a2                	ld	s3,8(sp)
    80002498:	6145                	addi	sp,sp,48
    8000249a:	8082                	ret
    virtio_disk_rw(b, 0);
    8000249c:	4581                	li	a1,0
    8000249e:	8526                	mv	a0,s1
    800024a0:	00003097          	auipc	ra,0x3
    800024a4:	328080e7          	jalr	808(ra) # 800057c8 <virtio_disk_rw>
    b->valid = 1;
    800024a8:	4785                	li	a5,1
    800024aa:	c09c                	sw	a5,0(s1)
  return b;
    800024ac:	b7c5                	j	8000248c <bread+0xd0>

00000000800024ae <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800024ae:	1101                	addi	sp,sp,-32
    800024b0:	ec06                	sd	ra,24(sp)
    800024b2:	e822                	sd	s0,16(sp)
    800024b4:	e426                	sd	s1,8(sp)
    800024b6:	1000                	addi	s0,sp,32
    800024b8:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800024ba:	0541                	addi	a0,a0,16
    800024bc:	00001097          	auipc	ra,0x1
    800024c0:	46e080e7          	jalr	1134(ra) # 8000392a <holdingsleep>
    800024c4:	cd01                	beqz	a0,800024dc <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800024c6:	4585                	li	a1,1
    800024c8:	8526                	mv	a0,s1
    800024ca:	00003097          	auipc	ra,0x3
    800024ce:	2fe080e7          	jalr	766(ra) # 800057c8 <virtio_disk_rw>
}
    800024d2:	60e2                	ld	ra,24(sp)
    800024d4:	6442                	ld	s0,16(sp)
    800024d6:	64a2                	ld	s1,8(sp)
    800024d8:	6105                	addi	sp,sp,32
    800024da:	8082                	ret
    panic("bwrite");
    800024dc:	00006517          	auipc	a0,0x6
    800024e0:	ffc50513          	addi	a0,a0,-4 # 800084d8 <syscalls+0xe8>
    800024e4:	00004097          	auipc	ra,0x4
    800024e8:	b4e080e7          	jalr	-1202(ra) # 80006032 <panic>

00000000800024ec <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    800024ec:	1101                	addi	sp,sp,-32
    800024ee:	ec06                	sd	ra,24(sp)
    800024f0:	e822                	sd	s0,16(sp)
    800024f2:	e426                	sd	s1,8(sp)
    800024f4:	e04a                	sd	s2,0(sp)
    800024f6:	1000                	addi	s0,sp,32
    800024f8:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800024fa:	01050913          	addi	s2,a0,16
    800024fe:	854a                	mv	a0,s2
    80002500:	00001097          	auipc	ra,0x1
    80002504:	42a080e7          	jalr	1066(ra) # 8000392a <holdingsleep>
    80002508:	c92d                	beqz	a0,8000257a <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    8000250a:	854a                	mv	a0,s2
    8000250c:	00001097          	auipc	ra,0x1
    80002510:	3da080e7          	jalr	986(ra) # 800038e6 <releasesleep>

  acquire(&bcache.lock);
    80002514:	0001e517          	auipc	a0,0x1e
    80002518:	45450513          	addi	a0,a0,1108 # 80020968 <bcache>
    8000251c:	00004097          	auipc	ra,0x4
    80002520:	060080e7          	jalr	96(ra) # 8000657c <acquire>
  b->refcnt--;
    80002524:	40bc                	lw	a5,64(s1)
    80002526:	37fd                	addiw	a5,a5,-1
    80002528:	0007871b          	sext.w	a4,a5
    8000252c:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000252e:	eb05                	bnez	a4,8000255e <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002530:	68bc                	ld	a5,80(s1)
    80002532:	64b8                	ld	a4,72(s1)
    80002534:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80002536:	64bc                	ld	a5,72(s1)
    80002538:	68b8                	ld	a4,80(s1)
    8000253a:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    8000253c:	00026797          	auipc	a5,0x26
    80002540:	42c78793          	addi	a5,a5,1068 # 80028968 <bcache+0x8000>
    80002544:	2b87b703          	ld	a4,696(a5)
    80002548:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    8000254a:	00026717          	auipc	a4,0x26
    8000254e:	68670713          	addi	a4,a4,1670 # 80028bd0 <bcache+0x8268>
    80002552:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002554:	2b87b703          	ld	a4,696(a5)
    80002558:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    8000255a:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    8000255e:	0001e517          	auipc	a0,0x1e
    80002562:	40a50513          	addi	a0,a0,1034 # 80020968 <bcache>
    80002566:	00004097          	auipc	ra,0x4
    8000256a:	0ca080e7          	jalr	202(ra) # 80006630 <release>
}
    8000256e:	60e2                	ld	ra,24(sp)
    80002570:	6442                	ld	s0,16(sp)
    80002572:	64a2                	ld	s1,8(sp)
    80002574:	6902                	ld	s2,0(sp)
    80002576:	6105                	addi	sp,sp,32
    80002578:	8082                	ret
    panic("brelse");
    8000257a:	00006517          	auipc	a0,0x6
    8000257e:	f6650513          	addi	a0,a0,-154 # 800084e0 <syscalls+0xf0>
    80002582:	00004097          	auipc	ra,0x4
    80002586:	ab0080e7          	jalr	-1360(ra) # 80006032 <panic>

000000008000258a <bpin>:

void
bpin(struct buf *b) {
    8000258a:	1101                	addi	sp,sp,-32
    8000258c:	ec06                	sd	ra,24(sp)
    8000258e:	e822                	sd	s0,16(sp)
    80002590:	e426                	sd	s1,8(sp)
    80002592:	1000                	addi	s0,sp,32
    80002594:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002596:	0001e517          	auipc	a0,0x1e
    8000259a:	3d250513          	addi	a0,a0,978 # 80020968 <bcache>
    8000259e:	00004097          	auipc	ra,0x4
    800025a2:	fde080e7          	jalr	-34(ra) # 8000657c <acquire>
  b->refcnt++;
    800025a6:	40bc                	lw	a5,64(s1)
    800025a8:	2785                	addiw	a5,a5,1
    800025aa:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800025ac:	0001e517          	auipc	a0,0x1e
    800025b0:	3bc50513          	addi	a0,a0,956 # 80020968 <bcache>
    800025b4:	00004097          	auipc	ra,0x4
    800025b8:	07c080e7          	jalr	124(ra) # 80006630 <release>
}
    800025bc:	60e2                	ld	ra,24(sp)
    800025be:	6442                	ld	s0,16(sp)
    800025c0:	64a2                	ld	s1,8(sp)
    800025c2:	6105                	addi	sp,sp,32
    800025c4:	8082                	ret

00000000800025c6 <bunpin>:

void
bunpin(struct buf *b) {
    800025c6:	1101                	addi	sp,sp,-32
    800025c8:	ec06                	sd	ra,24(sp)
    800025ca:	e822                	sd	s0,16(sp)
    800025cc:	e426                	sd	s1,8(sp)
    800025ce:	1000                	addi	s0,sp,32
    800025d0:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800025d2:	0001e517          	auipc	a0,0x1e
    800025d6:	39650513          	addi	a0,a0,918 # 80020968 <bcache>
    800025da:	00004097          	auipc	ra,0x4
    800025de:	fa2080e7          	jalr	-94(ra) # 8000657c <acquire>
  b->refcnt--;
    800025e2:	40bc                	lw	a5,64(s1)
    800025e4:	37fd                	addiw	a5,a5,-1
    800025e6:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800025e8:	0001e517          	auipc	a0,0x1e
    800025ec:	38050513          	addi	a0,a0,896 # 80020968 <bcache>
    800025f0:	00004097          	auipc	ra,0x4
    800025f4:	040080e7          	jalr	64(ra) # 80006630 <release>
}
    800025f8:	60e2                	ld	ra,24(sp)
    800025fa:	6442                	ld	s0,16(sp)
    800025fc:	64a2                	ld	s1,8(sp)
    800025fe:	6105                	addi	sp,sp,32
    80002600:	8082                	ret

0000000080002602 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002602:	1101                	addi	sp,sp,-32
    80002604:	ec06                	sd	ra,24(sp)
    80002606:	e822                	sd	s0,16(sp)
    80002608:	e426                	sd	s1,8(sp)
    8000260a:	e04a                	sd	s2,0(sp)
    8000260c:	1000                	addi	s0,sp,32
    8000260e:	84ae                	mv	s1,a1
    struct buf *bp;
    int bi, m;

    bp = bread(dev, BBLOCK(b, sb));
    80002610:	00d5d59b          	srliw	a1,a1,0xd
    80002614:	00027797          	auipc	a5,0x27
    80002618:	a307a783          	lw	a5,-1488(a5) # 80029044 <sb+0x1c>
    8000261c:	9dbd                	addw	a1,a1,a5
    8000261e:	00000097          	auipc	ra,0x0
    80002622:	d9e080e7          	jalr	-610(ra) # 800023bc <bread>
    bi = b % BPB;
    m = 1 << (bi % 8);
    80002626:	0074f713          	andi	a4,s1,7
    8000262a:	4785                	li	a5,1
    8000262c:	00e797bb          	sllw	a5,a5,a4
    if ((bp->data[bi / 8] & m) == 0)
    80002630:	14ce                	slli	s1,s1,0x33
    80002632:	90d9                	srli	s1,s1,0x36
    80002634:	00950733          	add	a4,a0,s1
    80002638:	05874703          	lbu	a4,88(a4)
    8000263c:	00e7f6b3          	and	a3,a5,a4
    80002640:	c69d                	beqz	a3,8000266e <bfree+0x6c>
    80002642:	892a                	mv	s2,a0
        panic("freeing free block");
    bp->data[bi / 8] &= ~m;
    80002644:	94aa                	add	s1,s1,a0
    80002646:	fff7c793          	not	a5,a5
    8000264a:	8ff9                	and	a5,a5,a4
    8000264c:	04f48c23          	sb	a5,88(s1)
    log_write(bp);
    80002650:	00001097          	auipc	ra,0x1
    80002654:	120080e7          	jalr	288(ra) # 80003770 <log_write>
    brelse(bp);
    80002658:	854a                	mv	a0,s2
    8000265a:	00000097          	auipc	ra,0x0
    8000265e:	e92080e7          	jalr	-366(ra) # 800024ec <brelse>
}
    80002662:	60e2                	ld	ra,24(sp)
    80002664:	6442                	ld	s0,16(sp)
    80002666:	64a2                	ld	s1,8(sp)
    80002668:	6902                	ld	s2,0(sp)
    8000266a:	6105                	addi	sp,sp,32
    8000266c:	8082                	ret
        panic("freeing free block");
    8000266e:	00006517          	auipc	a0,0x6
    80002672:	e7a50513          	addi	a0,a0,-390 # 800084e8 <syscalls+0xf8>
    80002676:	00004097          	auipc	ra,0x4
    8000267a:	9bc080e7          	jalr	-1604(ra) # 80006032 <panic>

000000008000267e <balloc>:
{
    8000267e:	711d                	addi	sp,sp,-96
    80002680:	ec86                	sd	ra,88(sp)
    80002682:	e8a2                	sd	s0,80(sp)
    80002684:	e4a6                	sd	s1,72(sp)
    80002686:	e0ca                	sd	s2,64(sp)
    80002688:	fc4e                	sd	s3,56(sp)
    8000268a:	f852                	sd	s4,48(sp)
    8000268c:	f456                	sd	s5,40(sp)
    8000268e:	f05a                	sd	s6,32(sp)
    80002690:	ec5e                	sd	s7,24(sp)
    80002692:	e862                	sd	s8,16(sp)
    80002694:	e466                	sd	s9,8(sp)
    80002696:	1080                	addi	s0,sp,96
    for (b = 0; b < sb.size; b += BPB)
    80002698:	00027797          	auipc	a5,0x27
    8000269c:	9947a783          	lw	a5,-1644(a5) # 8002902c <sb+0x4>
    800026a0:	10078163          	beqz	a5,800027a2 <balloc+0x124>
    800026a4:	8baa                	mv	s7,a0
    800026a6:	4a81                	li	s5,0
        bp = bread(dev, BBLOCK(b, sb));
    800026a8:	00027b17          	auipc	s6,0x27
    800026ac:	980b0b13          	addi	s6,s6,-1664 # 80029028 <sb>
        for (bi = 0; bi < BPB && b + bi < sb.size; bi++)
    800026b0:	4c01                	li	s8,0
            m = 1 << (bi % 8);
    800026b2:	4985                	li	s3,1
        for (bi = 0; bi < BPB && b + bi < sb.size; bi++)
    800026b4:	6a09                	lui	s4,0x2
    for (b = 0; b < sb.size; b += BPB)
    800026b6:	6c89                	lui	s9,0x2
    800026b8:	a061                	j	80002740 <balloc+0xc2>
                bp->data[bi / 8] |= m; // Mark block in use.
    800026ba:	974a                	add	a4,a4,s2
    800026bc:	8fd5                	or	a5,a5,a3
    800026be:	04f70c23          	sb	a5,88(a4)
                log_write(bp);
    800026c2:	854a                	mv	a0,s2
    800026c4:	00001097          	auipc	ra,0x1
    800026c8:	0ac080e7          	jalr	172(ra) # 80003770 <log_write>
                brelse(bp);
    800026cc:	854a                	mv	a0,s2
    800026ce:	00000097          	auipc	ra,0x0
    800026d2:	e1e080e7          	jalr	-482(ra) # 800024ec <brelse>
    bp = bread(dev, bno);
    800026d6:	85a6                	mv	a1,s1
    800026d8:	855e                	mv	a0,s7
    800026da:	00000097          	auipc	ra,0x0
    800026de:	ce2080e7          	jalr	-798(ra) # 800023bc <bread>
    800026e2:	892a                	mv	s2,a0
    memset(bp->data, 0, BSIZE);
    800026e4:	40000613          	li	a2,1024
    800026e8:	4581                	li	a1,0
    800026ea:	05850513          	addi	a0,a0,88
    800026ee:	ffffe097          	auipc	ra,0xffffe
    800026f2:	a8a080e7          	jalr	-1398(ra) # 80000178 <memset>
    log_write(bp);
    800026f6:	854a                	mv	a0,s2
    800026f8:	00001097          	auipc	ra,0x1
    800026fc:	078080e7          	jalr	120(ra) # 80003770 <log_write>
    brelse(bp);
    80002700:	854a                	mv	a0,s2
    80002702:	00000097          	auipc	ra,0x0
    80002706:	dea080e7          	jalr	-534(ra) # 800024ec <brelse>
}
    8000270a:	8526                	mv	a0,s1
    8000270c:	60e6                	ld	ra,88(sp)
    8000270e:	6446                	ld	s0,80(sp)
    80002710:	64a6                	ld	s1,72(sp)
    80002712:	6906                	ld	s2,64(sp)
    80002714:	79e2                	ld	s3,56(sp)
    80002716:	7a42                	ld	s4,48(sp)
    80002718:	7aa2                	ld	s5,40(sp)
    8000271a:	7b02                	ld	s6,32(sp)
    8000271c:	6be2                	ld	s7,24(sp)
    8000271e:	6c42                	ld	s8,16(sp)
    80002720:	6ca2                	ld	s9,8(sp)
    80002722:	6125                	addi	sp,sp,96
    80002724:	8082                	ret
        brelse(bp);
    80002726:	854a                	mv	a0,s2
    80002728:	00000097          	auipc	ra,0x0
    8000272c:	dc4080e7          	jalr	-572(ra) # 800024ec <brelse>
    for (b = 0; b < sb.size; b += BPB)
    80002730:	015c87bb          	addw	a5,s9,s5
    80002734:	00078a9b          	sext.w	s5,a5
    80002738:	004b2703          	lw	a4,4(s6)
    8000273c:	06eaf363          	bgeu	s5,a4,800027a2 <balloc+0x124>
        bp = bread(dev, BBLOCK(b, sb));
    80002740:	41fad79b          	sraiw	a5,s5,0x1f
    80002744:	0137d79b          	srliw	a5,a5,0x13
    80002748:	015787bb          	addw	a5,a5,s5
    8000274c:	40d7d79b          	sraiw	a5,a5,0xd
    80002750:	01cb2583          	lw	a1,28(s6)
    80002754:	9dbd                	addw	a1,a1,a5
    80002756:	855e                	mv	a0,s7
    80002758:	00000097          	auipc	ra,0x0
    8000275c:	c64080e7          	jalr	-924(ra) # 800023bc <bread>
    80002760:	892a                	mv	s2,a0
        for (bi = 0; bi < BPB && b + bi < sb.size; bi++)
    80002762:	004b2503          	lw	a0,4(s6)
    80002766:	000a849b          	sext.w	s1,s5
    8000276a:	8662                	mv	a2,s8
    8000276c:	faa4fde3          	bgeu	s1,a0,80002726 <balloc+0xa8>
            m = 1 << (bi % 8);
    80002770:	41f6579b          	sraiw	a5,a2,0x1f
    80002774:	01d7d69b          	srliw	a3,a5,0x1d
    80002778:	00c6873b          	addw	a4,a3,a2
    8000277c:	00777793          	andi	a5,a4,7
    80002780:	9f95                	subw	a5,a5,a3
    80002782:	00f997bb          	sllw	a5,s3,a5
            if ((bp->data[bi / 8] & m) == 0)
    80002786:	4037571b          	sraiw	a4,a4,0x3
    8000278a:	00e906b3          	add	a3,s2,a4
    8000278e:	0586c683          	lbu	a3,88(a3)
    80002792:	00d7f5b3          	and	a1,a5,a3
    80002796:	d195                	beqz	a1,800026ba <balloc+0x3c>
        for (bi = 0; bi < BPB && b + bi < sb.size; bi++)
    80002798:	2605                	addiw	a2,a2,1
    8000279a:	2485                	addiw	s1,s1,1
    8000279c:	fd4618e3          	bne	a2,s4,8000276c <balloc+0xee>
    800027a0:	b759                	j	80002726 <balloc+0xa8>
    printf("balloc: out of blocks\n");
    800027a2:	00006517          	auipc	a0,0x6
    800027a6:	d5e50513          	addi	a0,a0,-674 # 80008500 <syscalls+0x110>
    800027aa:	00004097          	auipc	ra,0x4
    800027ae:	8d2080e7          	jalr	-1838(ra) # 8000607c <printf>
    return 0;
    800027b2:	4481                	li	s1,0
    800027b4:	bf99                	j	8000270a <balloc+0x8c>

00000000800027b6 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    800027b6:	7179                	addi	sp,sp,-48
    800027b8:	f406                	sd	ra,40(sp)
    800027ba:	f022                	sd	s0,32(sp)
    800027bc:	ec26                	sd	s1,24(sp)
    800027be:	e84a                	sd	s2,16(sp)
    800027c0:	e44e                	sd	s3,8(sp)
    800027c2:	e052                	sd	s4,0(sp)
    800027c4:	1800                	addi	s0,sp,48
    800027c6:	89aa                	mv	s3,a0
    uint addr, *a;
    struct buf *bp;

    if (bn < NDIRECT)
    800027c8:	47ad                	li	a5,11
    800027ca:	02b7e763          	bltu	a5,a1,800027f8 <bmap+0x42>
    {
        if ((addr = ip->addrs[bn]) == 0)
    800027ce:	02059493          	slli	s1,a1,0x20
    800027d2:	9081                	srli	s1,s1,0x20
    800027d4:	048a                	slli	s1,s1,0x2
    800027d6:	94aa                	add	s1,s1,a0
    800027d8:	0504a903          	lw	s2,80(s1)
    800027dc:	06091e63          	bnez	s2,80002858 <bmap+0xa2>
        {
            addr = balloc(ip->dev);
    800027e0:	4108                	lw	a0,0(a0)
    800027e2:	00000097          	auipc	ra,0x0
    800027e6:	e9c080e7          	jalr	-356(ra) # 8000267e <balloc>
    800027ea:	0005091b          	sext.w	s2,a0
            if (addr == 0)
    800027ee:	06090563          	beqz	s2,80002858 <bmap+0xa2>
                return 0;
            ip->addrs[bn] = addr;
    800027f2:	0524a823          	sw	s2,80(s1)
    800027f6:	a08d                	j	80002858 <bmap+0xa2>
        }
        return addr;
    }
    bn -= NDIRECT;
    800027f8:	ff45849b          	addiw	s1,a1,-12
    800027fc:	0004871b          	sext.w	a4,s1

    if (bn < NINDIRECT)
    80002800:	0ff00793          	li	a5,255
    80002804:	08e7e563          	bltu	a5,a4,8000288e <bmap+0xd8>
    {
        // Load indirect block, allocating if necessary.
        if ((addr = ip->addrs[NDIRECT]) == 0)
    80002808:	08052903          	lw	s2,128(a0)
    8000280c:	00091d63          	bnez	s2,80002826 <bmap+0x70>
        {
            addr = balloc(ip->dev);
    80002810:	4108                	lw	a0,0(a0)
    80002812:	00000097          	auipc	ra,0x0
    80002816:	e6c080e7          	jalr	-404(ra) # 8000267e <balloc>
    8000281a:	0005091b          	sext.w	s2,a0
            if (addr == 0)
    8000281e:	02090d63          	beqz	s2,80002858 <bmap+0xa2>
                return 0;
            ip->addrs[NDIRECT] = addr;
    80002822:	0929a023          	sw	s2,128(s3)
        }
        bp = bread(ip->dev, addr);
    80002826:	85ca                	mv	a1,s2
    80002828:	0009a503          	lw	a0,0(s3)
    8000282c:	00000097          	auipc	ra,0x0
    80002830:	b90080e7          	jalr	-1136(ra) # 800023bc <bread>
    80002834:	8a2a                	mv	s4,a0
        a = (uint *)bp->data;
    80002836:	05850793          	addi	a5,a0,88
        if ((addr = a[bn]) == 0)
    8000283a:	02049593          	slli	a1,s1,0x20
    8000283e:	9181                	srli	a1,a1,0x20
    80002840:	058a                	slli	a1,a1,0x2
    80002842:	00b784b3          	add	s1,a5,a1
    80002846:	0004a903          	lw	s2,0(s1)
    8000284a:	02090063          	beqz	s2,8000286a <bmap+0xb4>
            {
                a[bn] = addr;
                log_write(bp);
            }
        }
        brelse(bp);
    8000284e:	8552                	mv	a0,s4
    80002850:	00000097          	auipc	ra,0x0
    80002854:	c9c080e7          	jalr	-868(ra) # 800024ec <brelse>
        return addr;
    }

    panic("bmap: out of range");
}
    80002858:	854a                	mv	a0,s2
    8000285a:	70a2                	ld	ra,40(sp)
    8000285c:	7402                	ld	s0,32(sp)
    8000285e:	64e2                	ld	s1,24(sp)
    80002860:	6942                	ld	s2,16(sp)
    80002862:	69a2                	ld	s3,8(sp)
    80002864:	6a02                	ld	s4,0(sp)
    80002866:	6145                	addi	sp,sp,48
    80002868:	8082                	ret
            addr = balloc(ip->dev);
    8000286a:	0009a503          	lw	a0,0(s3)
    8000286e:	00000097          	auipc	ra,0x0
    80002872:	e10080e7          	jalr	-496(ra) # 8000267e <balloc>
    80002876:	0005091b          	sext.w	s2,a0
            if (addr)
    8000287a:	fc090ae3          	beqz	s2,8000284e <bmap+0x98>
                a[bn] = addr;
    8000287e:	0124a023          	sw	s2,0(s1)
                log_write(bp);
    80002882:	8552                	mv	a0,s4
    80002884:	00001097          	auipc	ra,0x1
    80002888:	eec080e7          	jalr	-276(ra) # 80003770 <log_write>
    8000288c:	b7c9                	j	8000284e <bmap+0x98>
    panic("bmap: out of range");
    8000288e:	00006517          	auipc	a0,0x6
    80002892:	c8a50513          	addi	a0,a0,-886 # 80008518 <syscalls+0x128>
    80002896:	00003097          	auipc	ra,0x3
    8000289a:	79c080e7          	jalr	1948(ra) # 80006032 <panic>

000000008000289e <iget>:
{
    8000289e:	7179                	addi	sp,sp,-48
    800028a0:	f406                	sd	ra,40(sp)
    800028a2:	f022                	sd	s0,32(sp)
    800028a4:	ec26                	sd	s1,24(sp)
    800028a6:	e84a                	sd	s2,16(sp)
    800028a8:	e44e                	sd	s3,8(sp)
    800028aa:	e052                	sd	s4,0(sp)
    800028ac:	1800                	addi	s0,sp,48
    800028ae:	89aa                	mv	s3,a0
    800028b0:	8a2e                	mv	s4,a1
    acquire(&itable.lock);
    800028b2:	00026517          	auipc	a0,0x26
    800028b6:	79650513          	addi	a0,a0,1942 # 80029048 <itable>
    800028ba:	00004097          	auipc	ra,0x4
    800028be:	cc2080e7          	jalr	-830(ra) # 8000657c <acquire>
    empty = 0;
    800028c2:	4901                	li	s2,0
    for (ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++)
    800028c4:	00026497          	auipc	s1,0x26
    800028c8:	79c48493          	addi	s1,s1,1948 # 80029060 <itable+0x18>
    800028cc:	00028697          	auipc	a3,0x28
    800028d0:	22468693          	addi	a3,a3,548 # 8002aaf0 <log>
    800028d4:	a039                	j	800028e2 <iget+0x44>
        if (empty == 0 && ip->ref == 0) // Remember empty slot.
    800028d6:	02090b63          	beqz	s2,8000290c <iget+0x6e>
    for (ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++)
    800028da:	08848493          	addi	s1,s1,136
    800028de:	02d48a63          	beq	s1,a3,80002912 <iget+0x74>
        if (ip->ref > 0 && ip->dev == dev && ip->inum == inum)
    800028e2:	449c                	lw	a5,8(s1)
    800028e4:	fef059e3          	blez	a5,800028d6 <iget+0x38>
    800028e8:	4098                	lw	a4,0(s1)
    800028ea:	ff3716e3          	bne	a4,s3,800028d6 <iget+0x38>
    800028ee:	40d8                	lw	a4,4(s1)
    800028f0:	ff4713e3          	bne	a4,s4,800028d6 <iget+0x38>
            ip->ref++;
    800028f4:	2785                	addiw	a5,a5,1
    800028f6:	c49c                	sw	a5,8(s1)
            release(&itable.lock);
    800028f8:	00026517          	auipc	a0,0x26
    800028fc:	75050513          	addi	a0,a0,1872 # 80029048 <itable>
    80002900:	00004097          	auipc	ra,0x4
    80002904:	d30080e7          	jalr	-720(ra) # 80006630 <release>
            return ip;
    80002908:	8926                	mv	s2,s1
    8000290a:	a03d                	j	80002938 <iget+0x9a>
        if (empty == 0 && ip->ref == 0) // Remember empty slot.
    8000290c:	f7f9                	bnez	a5,800028da <iget+0x3c>
    8000290e:	8926                	mv	s2,s1
    80002910:	b7e9                	j	800028da <iget+0x3c>
    if (empty == 0)
    80002912:	02090c63          	beqz	s2,8000294a <iget+0xac>
    ip->dev = dev;
    80002916:	01392023          	sw	s3,0(s2)
    ip->inum = inum;
    8000291a:	01492223          	sw	s4,4(s2)
    ip->ref = 1;
    8000291e:	4785                	li	a5,1
    80002920:	00f92423          	sw	a5,8(s2)
    ip->valid = 0;
    80002924:	04092023          	sw	zero,64(s2)
    release(&itable.lock);
    80002928:	00026517          	auipc	a0,0x26
    8000292c:	72050513          	addi	a0,a0,1824 # 80029048 <itable>
    80002930:	00004097          	auipc	ra,0x4
    80002934:	d00080e7          	jalr	-768(ra) # 80006630 <release>
}
    80002938:	854a                	mv	a0,s2
    8000293a:	70a2                	ld	ra,40(sp)
    8000293c:	7402                	ld	s0,32(sp)
    8000293e:	64e2                	ld	s1,24(sp)
    80002940:	6942                	ld	s2,16(sp)
    80002942:	69a2                	ld	s3,8(sp)
    80002944:	6a02                	ld	s4,0(sp)
    80002946:	6145                	addi	sp,sp,48
    80002948:	8082                	ret
        panic("iget: no inodes");
    8000294a:	00006517          	auipc	a0,0x6
    8000294e:	be650513          	addi	a0,a0,-1050 # 80008530 <syscalls+0x140>
    80002952:	00003097          	auipc	ra,0x3
    80002956:	6e0080e7          	jalr	1760(ra) # 80006032 <panic>

000000008000295a <fsinit>:
{
    8000295a:	7179                	addi	sp,sp,-48
    8000295c:	f406                	sd	ra,40(sp)
    8000295e:	f022                	sd	s0,32(sp)
    80002960:	ec26                	sd	s1,24(sp)
    80002962:	e84a                	sd	s2,16(sp)
    80002964:	e44e                	sd	s3,8(sp)
    80002966:	1800                	addi	s0,sp,48
    80002968:	892a                	mv	s2,a0
    bp = bread(dev, 1);
    8000296a:	4585                	li	a1,1
    8000296c:	00000097          	auipc	ra,0x0
    80002970:	a50080e7          	jalr	-1456(ra) # 800023bc <bread>
    80002974:	84aa                	mv	s1,a0
    memmove(sb, bp->data, sizeof(*sb));
    80002976:	00026997          	auipc	s3,0x26
    8000297a:	6b298993          	addi	s3,s3,1714 # 80029028 <sb>
    8000297e:	02000613          	li	a2,32
    80002982:	05850593          	addi	a1,a0,88
    80002986:	854e                	mv	a0,s3
    80002988:	ffffe097          	auipc	ra,0xffffe
    8000298c:	850080e7          	jalr	-1968(ra) # 800001d8 <memmove>
    brelse(bp);
    80002990:	8526                	mv	a0,s1
    80002992:	00000097          	auipc	ra,0x0
    80002996:	b5a080e7          	jalr	-1190(ra) # 800024ec <brelse>
    if (sb.magic != FSMAGIC)
    8000299a:	0009a703          	lw	a4,0(s3)
    8000299e:	102037b7          	lui	a5,0x10203
    800029a2:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800029a6:	02f71263          	bne	a4,a5,800029ca <fsinit+0x70>
    initlog(dev, &sb);
    800029aa:	00026597          	auipc	a1,0x26
    800029ae:	67e58593          	addi	a1,a1,1662 # 80029028 <sb>
    800029b2:	854a                	mv	a0,s2
    800029b4:	00001097          	auipc	ra,0x1
    800029b8:	b40080e7          	jalr	-1216(ra) # 800034f4 <initlog>
}
    800029bc:	70a2                	ld	ra,40(sp)
    800029be:	7402                	ld	s0,32(sp)
    800029c0:	64e2                	ld	s1,24(sp)
    800029c2:	6942                	ld	s2,16(sp)
    800029c4:	69a2                	ld	s3,8(sp)
    800029c6:	6145                	addi	sp,sp,48
    800029c8:	8082                	ret
        panic("invalid file system");
    800029ca:	00006517          	auipc	a0,0x6
    800029ce:	b7650513          	addi	a0,a0,-1162 # 80008540 <syscalls+0x150>
    800029d2:	00003097          	auipc	ra,0x3
    800029d6:	660080e7          	jalr	1632(ra) # 80006032 <panic>

00000000800029da <iinit>:
{
    800029da:	7179                	addi	sp,sp,-48
    800029dc:	f406                	sd	ra,40(sp)
    800029de:	f022                	sd	s0,32(sp)
    800029e0:	ec26                	sd	s1,24(sp)
    800029e2:	e84a                	sd	s2,16(sp)
    800029e4:	e44e                	sd	s3,8(sp)
    800029e6:	1800                	addi	s0,sp,48
    initlock(&itable.lock, "itable");
    800029e8:	00006597          	auipc	a1,0x6
    800029ec:	b7058593          	addi	a1,a1,-1168 # 80008558 <syscalls+0x168>
    800029f0:	00026517          	auipc	a0,0x26
    800029f4:	65850513          	addi	a0,a0,1624 # 80029048 <itable>
    800029f8:	00004097          	auipc	ra,0x4
    800029fc:	af4080e7          	jalr	-1292(ra) # 800064ec <initlock>
    for (i = 0; i < NINODE; i++)
    80002a00:	00026497          	auipc	s1,0x26
    80002a04:	67048493          	addi	s1,s1,1648 # 80029070 <itable+0x28>
    80002a08:	00028997          	auipc	s3,0x28
    80002a0c:	0f898993          	addi	s3,s3,248 # 8002ab00 <log+0x10>
        initsleeplock(&itable.inode[i].lock, "inode");
    80002a10:	00006917          	auipc	s2,0x6
    80002a14:	b5090913          	addi	s2,s2,-1200 # 80008560 <syscalls+0x170>
    80002a18:	85ca                	mv	a1,s2
    80002a1a:	8526                	mv	a0,s1
    80002a1c:	00001097          	auipc	ra,0x1
    80002a20:	e3a080e7          	jalr	-454(ra) # 80003856 <initsleeplock>
    for (i = 0; i < NINODE; i++)
    80002a24:	08848493          	addi	s1,s1,136
    80002a28:	ff3498e3          	bne	s1,s3,80002a18 <iinit+0x3e>
}
    80002a2c:	70a2                	ld	ra,40(sp)
    80002a2e:	7402                	ld	s0,32(sp)
    80002a30:	64e2                	ld	s1,24(sp)
    80002a32:	6942                	ld	s2,16(sp)
    80002a34:	69a2                	ld	s3,8(sp)
    80002a36:	6145                	addi	sp,sp,48
    80002a38:	8082                	ret

0000000080002a3a <ialloc>:
{
    80002a3a:	715d                	addi	sp,sp,-80
    80002a3c:	e486                	sd	ra,72(sp)
    80002a3e:	e0a2                	sd	s0,64(sp)
    80002a40:	fc26                	sd	s1,56(sp)
    80002a42:	f84a                	sd	s2,48(sp)
    80002a44:	f44e                	sd	s3,40(sp)
    80002a46:	f052                	sd	s4,32(sp)
    80002a48:	ec56                	sd	s5,24(sp)
    80002a4a:	e85a                	sd	s6,16(sp)
    80002a4c:	e45e                	sd	s7,8(sp)
    80002a4e:	0880                	addi	s0,sp,80
    for (inum = 1; inum < sb.ninodes; inum++)
    80002a50:	00026717          	auipc	a4,0x26
    80002a54:	5e472703          	lw	a4,1508(a4) # 80029034 <sb+0xc>
    80002a58:	4785                	li	a5,1
    80002a5a:	04e7fa63          	bgeu	a5,a4,80002aae <ialloc+0x74>
    80002a5e:	8aaa                	mv	s5,a0
    80002a60:	8bae                	mv	s7,a1
    80002a62:	4485                	li	s1,1
        bp = bread(dev, IBLOCK(inum, sb));
    80002a64:	00026a17          	auipc	s4,0x26
    80002a68:	5c4a0a13          	addi	s4,s4,1476 # 80029028 <sb>
    80002a6c:	00048b1b          	sext.w	s6,s1
    80002a70:	0044d593          	srli	a1,s1,0x4
    80002a74:	018a2783          	lw	a5,24(s4)
    80002a78:	9dbd                	addw	a1,a1,a5
    80002a7a:	8556                	mv	a0,s5
    80002a7c:	00000097          	auipc	ra,0x0
    80002a80:	940080e7          	jalr	-1728(ra) # 800023bc <bread>
    80002a84:	892a                	mv	s2,a0
        dip = (struct dinode *)bp->data + inum % IPB;
    80002a86:	05850993          	addi	s3,a0,88
    80002a8a:	00f4f793          	andi	a5,s1,15
    80002a8e:	079a                	slli	a5,a5,0x6
    80002a90:	99be                	add	s3,s3,a5
        if (dip->type == 0)
    80002a92:	00099783          	lh	a5,0(s3)
    80002a96:	c3a1                	beqz	a5,80002ad6 <ialloc+0x9c>
        brelse(bp);
    80002a98:	00000097          	auipc	ra,0x0
    80002a9c:	a54080e7          	jalr	-1452(ra) # 800024ec <brelse>
    for (inum = 1; inum < sb.ninodes; inum++)
    80002aa0:	0485                	addi	s1,s1,1
    80002aa2:	00ca2703          	lw	a4,12(s4)
    80002aa6:	0004879b          	sext.w	a5,s1
    80002aaa:	fce7e1e3          	bltu	a5,a4,80002a6c <ialloc+0x32>
    printf("ialloc: no inodes\n");
    80002aae:	00006517          	auipc	a0,0x6
    80002ab2:	aba50513          	addi	a0,a0,-1350 # 80008568 <syscalls+0x178>
    80002ab6:	00003097          	auipc	ra,0x3
    80002aba:	5c6080e7          	jalr	1478(ra) # 8000607c <printf>
    return 0;
    80002abe:	4501                	li	a0,0
}
    80002ac0:	60a6                	ld	ra,72(sp)
    80002ac2:	6406                	ld	s0,64(sp)
    80002ac4:	74e2                	ld	s1,56(sp)
    80002ac6:	7942                	ld	s2,48(sp)
    80002ac8:	79a2                	ld	s3,40(sp)
    80002aca:	7a02                	ld	s4,32(sp)
    80002acc:	6ae2                	ld	s5,24(sp)
    80002ace:	6b42                	ld	s6,16(sp)
    80002ad0:	6ba2                	ld	s7,8(sp)
    80002ad2:	6161                	addi	sp,sp,80
    80002ad4:	8082                	ret
            memset(dip, 0, sizeof(*dip));
    80002ad6:	04000613          	li	a2,64
    80002ada:	4581                	li	a1,0
    80002adc:	854e                	mv	a0,s3
    80002ade:	ffffd097          	auipc	ra,0xffffd
    80002ae2:	69a080e7          	jalr	1690(ra) # 80000178 <memset>
            dip->type = type;
    80002ae6:	01799023          	sh	s7,0(s3)
            log_write(bp); // mark it allocated on the disk
    80002aea:	854a                	mv	a0,s2
    80002aec:	00001097          	auipc	ra,0x1
    80002af0:	c84080e7          	jalr	-892(ra) # 80003770 <log_write>
            brelse(bp);
    80002af4:	854a                	mv	a0,s2
    80002af6:	00000097          	auipc	ra,0x0
    80002afa:	9f6080e7          	jalr	-1546(ra) # 800024ec <brelse>
            return iget(dev, inum);
    80002afe:	85da                	mv	a1,s6
    80002b00:	8556                	mv	a0,s5
    80002b02:	00000097          	auipc	ra,0x0
    80002b06:	d9c080e7          	jalr	-612(ra) # 8000289e <iget>
    80002b0a:	bf5d                	j	80002ac0 <ialloc+0x86>

0000000080002b0c <iupdate>:
{
    80002b0c:	1101                	addi	sp,sp,-32
    80002b0e:	ec06                	sd	ra,24(sp)
    80002b10:	e822                	sd	s0,16(sp)
    80002b12:	e426                	sd	s1,8(sp)
    80002b14:	e04a                	sd	s2,0(sp)
    80002b16:	1000                	addi	s0,sp,32
    80002b18:	84aa                	mv	s1,a0
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002b1a:	415c                	lw	a5,4(a0)
    80002b1c:	0047d79b          	srliw	a5,a5,0x4
    80002b20:	00026597          	auipc	a1,0x26
    80002b24:	5205a583          	lw	a1,1312(a1) # 80029040 <sb+0x18>
    80002b28:	9dbd                	addw	a1,a1,a5
    80002b2a:	4108                	lw	a0,0(a0)
    80002b2c:	00000097          	auipc	ra,0x0
    80002b30:	890080e7          	jalr	-1904(ra) # 800023bc <bread>
    80002b34:	892a                	mv	s2,a0
    dip = (struct dinode *)bp->data + ip->inum % IPB;
    80002b36:	05850793          	addi	a5,a0,88
    80002b3a:	40c8                	lw	a0,4(s1)
    80002b3c:	893d                	andi	a0,a0,15
    80002b3e:	051a                	slli	a0,a0,0x6
    80002b40:	953e                	add	a0,a0,a5
    dip->type = ip->type;
    80002b42:	04449703          	lh	a4,68(s1)
    80002b46:	00e51023          	sh	a4,0(a0)
    dip->major = ip->major;
    80002b4a:	04649703          	lh	a4,70(s1)
    80002b4e:	00e51123          	sh	a4,2(a0)
    dip->minor = ip->minor;
    80002b52:	04849703          	lh	a4,72(s1)
    80002b56:	00e51223          	sh	a4,4(a0)
    dip->nlink = ip->nlink;
    80002b5a:	04a49703          	lh	a4,74(s1)
    80002b5e:	00e51323          	sh	a4,6(a0)
    dip->size = ip->size;
    80002b62:	44f8                	lw	a4,76(s1)
    80002b64:	c518                	sw	a4,8(a0)
    memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002b66:	03400613          	li	a2,52
    80002b6a:	05048593          	addi	a1,s1,80
    80002b6e:	0531                	addi	a0,a0,12
    80002b70:	ffffd097          	auipc	ra,0xffffd
    80002b74:	668080e7          	jalr	1640(ra) # 800001d8 <memmove>
    log_write(bp);
    80002b78:	854a                	mv	a0,s2
    80002b7a:	00001097          	auipc	ra,0x1
    80002b7e:	bf6080e7          	jalr	-1034(ra) # 80003770 <log_write>
    brelse(bp);
    80002b82:	854a                	mv	a0,s2
    80002b84:	00000097          	auipc	ra,0x0
    80002b88:	968080e7          	jalr	-1688(ra) # 800024ec <brelse>
}
    80002b8c:	60e2                	ld	ra,24(sp)
    80002b8e:	6442                	ld	s0,16(sp)
    80002b90:	64a2                	ld	s1,8(sp)
    80002b92:	6902                	ld	s2,0(sp)
    80002b94:	6105                	addi	sp,sp,32
    80002b96:	8082                	ret

0000000080002b98 <idup>:
{
    80002b98:	1101                	addi	sp,sp,-32
    80002b9a:	ec06                	sd	ra,24(sp)
    80002b9c:	e822                	sd	s0,16(sp)
    80002b9e:	e426                	sd	s1,8(sp)
    80002ba0:	1000                	addi	s0,sp,32
    80002ba2:	84aa                	mv	s1,a0
    acquire(&itable.lock);
    80002ba4:	00026517          	auipc	a0,0x26
    80002ba8:	4a450513          	addi	a0,a0,1188 # 80029048 <itable>
    80002bac:	00004097          	auipc	ra,0x4
    80002bb0:	9d0080e7          	jalr	-1584(ra) # 8000657c <acquire>
    ip->ref++;
    80002bb4:	449c                	lw	a5,8(s1)
    80002bb6:	2785                	addiw	a5,a5,1
    80002bb8:	c49c                	sw	a5,8(s1)
    release(&itable.lock);
    80002bba:	00026517          	auipc	a0,0x26
    80002bbe:	48e50513          	addi	a0,a0,1166 # 80029048 <itable>
    80002bc2:	00004097          	auipc	ra,0x4
    80002bc6:	a6e080e7          	jalr	-1426(ra) # 80006630 <release>
}
    80002bca:	8526                	mv	a0,s1
    80002bcc:	60e2                	ld	ra,24(sp)
    80002bce:	6442                	ld	s0,16(sp)
    80002bd0:	64a2                	ld	s1,8(sp)
    80002bd2:	6105                	addi	sp,sp,32
    80002bd4:	8082                	ret

0000000080002bd6 <ilock>:
{
    80002bd6:	1101                	addi	sp,sp,-32
    80002bd8:	ec06                	sd	ra,24(sp)
    80002bda:	e822                	sd	s0,16(sp)
    80002bdc:	e426                	sd	s1,8(sp)
    80002bde:	e04a                	sd	s2,0(sp)
    80002be0:	1000                	addi	s0,sp,32
    if (ip == 0 || ip->ref < 1)
    80002be2:	c115                	beqz	a0,80002c06 <ilock+0x30>
    80002be4:	84aa                	mv	s1,a0
    80002be6:	451c                	lw	a5,8(a0)
    80002be8:	00f05f63          	blez	a5,80002c06 <ilock+0x30>
    acquiresleep(&ip->lock);
    80002bec:	0541                	addi	a0,a0,16
    80002bee:	00001097          	auipc	ra,0x1
    80002bf2:	ca2080e7          	jalr	-862(ra) # 80003890 <acquiresleep>
    if (ip->valid == 0)
    80002bf6:	40bc                	lw	a5,64(s1)
    80002bf8:	cf99                	beqz	a5,80002c16 <ilock+0x40>
}
    80002bfa:	60e2                	ld	ra,24(sp)
    80002bfc:	6442                	ld	s0,16(sp)
    80002bfe:	64a2                	ld	s1,8(sp)
    80002c00:	6902                	ld	s2,0(sp)
    80002c02:	6105                	addi	sp,sp,32
    80002c04:	8082                	ret
        panic("ilock");
    80002c06:	00006517          	auipc	a0,0x6
    80002c0a:	97a50513          	addi	a0,a0,-1670 # 80008580 <syscalls+0x190>
    80002c0e:	00003097          	auipc	ra,0x3
    80002c12:	424080e7          	jalr	1060(ra) # 80006032 <panic>
        bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002c16:	40dc                	lw	a5,4(s1)
    80002c18:	0047d79b          	srliw	a5,a5,0x4
    80002c1c:	00026597          	auipc	a1,0x26
    80002c20:	4245a583          	lw	a1,1060(a1) # 80029040 <sb+0x18>
    80002c24:	9dbd                	addw	a1,a1,a5
    80002c26:	4088                	lw	a0,0(s1)
    80002c28:	fffff097          	auipc	ra,0xfffff
    80002c2c:	794080e7          	jalr	1940(ra) # 800023bc <bread>
    80002c30:	892a                	mv	s2,a0
        dip = (struct dinode *)bp->data + ip->inum % IPB;
    80002c32:	05850593          	addi	a1,a0,88
    80002c36:	40dc                	lw	a5,4(s1)
    80002c38:	8bbd                	andi	a5,a5,15
    80002c3a:	079a                	slli	a5,a5,0x6
    80002c3c:	95be                	add	a1,a1,a5
        ip->type = dip->type;
    80002c3e:	00059783          	lh	a5,0(a1)
    80002c42:	04f49223          	sh	a5,68(s1)
        ip->major = dip->major;
    80002c46:	00259783          	lh	a5,2(a1)
    80002c4a:	04f49323          	sh	a5,70(s1)
        ip->minor = dip->minor;
    80002c4e:	00459783          	lh	a5,4(a1)
    80002c52:	04f49423          	sh	a5,72(s1)
        ip->nlink = dip->nlink;
    80002c56:	00659783          	lh	a5,6(a1)
    80002c5a:	04f49523          	sh	a5,74(s1)
        ip->size = dip->size;
    80002c5e:	459c                	lw	a5,8(a1)
    80002c60:	c4fc                	sw	a5,76(s1)
        memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002c62:	03400613          	li	a2,52
    80002c66:	05b1                	addi	a1,a1,12
    80002c68:	05048513          	addi	a0,s1,80
    80002c6c:	ffffd097          	auipc	ra,0xffffd
    80002c70:	56c080e7          	jalr	1388(ra) # 800001d8 <memmove>
        brelse(bp);
    80002c74:	854a                	mv	a0,s2
    80002c76:	00000097          	auipc	ra,0x0
    80002c7a:	876080e7          	jalr	-1930(ra) # 800024ec <brelse>
        ip->valid = 1;
    80002c7e:	4785                	li	a5,1
    80002c80:	c0bc                	sw	a5,64(s1)
        if (ip->type == 0)
    80002c82:	04449783          	lh	a5,68(s1)
    80002c86:	fbb5                	bnez	a5,80002bfa <ilock+0x24>
            panic("ilock: no type");
    80002c88:	00006517          	auipc	a0,0x6
    80002c8c:	90050513          	addi	a0,a0,-1792 # 80008588 <syscalls+0x198>
    80002c90:	00003097          	auipc	ra,0x3
    80002c94:	3a2080e7          	jalr	930(ra) # 80006032 <panic>

0000000080002c98 <iunlock>:
{
    80002c98:	1101                	addi	sp,sp,-32
    80002c9a:	ec06                	sd	ra,24(sp)
    80002c9c:	e822                	sd	s0,16(sp)
    80002c9e:	e426                	sd	s1,8(sp)
    80002ca0:	e04a                	sd	s2,0(sp)
    80002ca2:	1000                	addi	s0,sp,32
    if (ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002ca4:	c905                	beqz	a0,80002cd4 <iunlock+0x3c>
    80002ca6:	84aa                	mv	s1,a0
    80002ca8:	01050913          	addi	s2,a0,16
    80002cac:	854a                	mv	a0,s2
    80002cae:	00001097          	auipc	ra,0x1
    80002cb2:	c7c080e7          	jalr	-900(ra) # 8000392a <holdingsleep>
    80002cb6:	cd19                	beqz	a0,80002cd4 <iunlock+0x3c>
    80002cb8:	449c                	lw	a5,8(s1)
    80002cba:	00f05d63          	blez	a5,80002cd4 <iunlock+0x3c>
    releasesleep(&ip->lock);
    80002cbe:	854a                	mv	a0,s2
    80002cc0:	00001097          	auipc	ra,0x1
    80002cc4:	c26080e7          	jalr	-986(ra) # 800038e6 <releasesleep>
}
    80002cc8:	60e2                	ld	ra,24(sp)
    80002cca:	6442                	ld	s0,16(sp)
    80002ccc:	64a2                	ld	s1,8(sp)
    80002cce:	6902                	ld	s2,0(sp)
    80002cd0:	6105                	addi	sp,sp,32
    80002cd2:	8082                	ret
        panic("iunlock");
    80002cd4:	00006517          	auipc	a0,0x6
    80002cd8:	8c450513          	addi	a0,a0,-1852 # 80008598 <syscalls+0x1a8>
    80002cdc:	00003097          	auipc	ra,0x3
    80002ce0:	356080e7          	jalr	854(ra) # 80006032 <panic>

0000000080002ce4 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void itrunc(struct inode *ip)
{
    80002ce4:	7179                	addi	sp,sp,-48
    80002ce6:	f406                	sd	ra,40(sp)
    80002ce8:	f022                	sd	s0,32(sp)
    80002cea:	ec26                	sd	s1,24(sp)
    80002cec:	e84a                	sd	s2,16(sp)
    80002cee:	e44e                	sd	s3,8(sp)
    80002cf0:	e052                	sd	s4,0(sp)
    80002cf2:	1800                	addi	s0,sp,48
    80002cf4:	89aa                	mv	s3,a0
    int i, j;
    struct buf *bp;
    uint *a;

    for (i = 0; i < NDIRECT; i++)
    80002cf6:	05050493          	addi	s1,a0,80
    80002cfa:	08050913          	addi	s2,a0,128
    80002cfe:	a021                	j	80002d06 <itrunc+0x22>
    80002d00:	0491                	addi	s1,s1,4
    80002d02:	01248d63          	beq	s1,s2,80002d1c <itrunc+0x38>
    {
        if (ip->addrs[i])
    80002d06:	408c                	lw	a1,0(s1)
    80002d08:	dde5                	beqz	a1,80002d00 <itrunc+0x1c>
        {
            bfree(ip->dev, ip->addrs[i]);
    80002d0a:	0009a503          	lw	a0,0(s3)
    80002d0e:	00000097          	auipc	ra,0x0
    80002d12:	8f4080e7          	jalr	-1804(ra) # 80002602 <bfree>
            ip->addrs[i] = 0;
    80002d16:	0004a023          	sw	zero,0(s1)
    80002d1a:	b7dd                	j	80002d00 <itrunc+0x1c>
        }
    }

    if (ip->addrs[NDIRECT])
    80002d1c:	0809a583          	lw	a1,128(s3)
    80002d20:	e185                	bnez	a1,80002d40 <itrunc+0x5c>
        brelse(bp);
        bfree(ip->dev, ip->addrs[NDIRECT]);
        ip->addrs[NDIRECT] = 0;
    }

    ip->size = 0;
    80002d22:	0409a623          	sw	zero,76(s3)
    iupdate(ip);
    80002d26:	854e                	mv	a0,s3
    80002d28:	00000097          	auipc	ra,0x0
    80002d2c:	de4080e7          	jalr	-540(ra) # 80002b0c <iupdate>
}
    80002d30:	70a2                	ld	ra,40(sp)
    80002d32:	7402                	ld	s0,32(sp)
    80002d34:	64e2                	ld	s1,24(sp)
    80002d36:	6942                	ld	s2,16(sp)
    80002d38:	69a2                	ld	s3,8(sp)
    80002d3a:	6a02                	ld	s4,0(sp)
    80002d3c:	6145                	addi	sp,sp,48
    80002d3e:	8082                	ret
        bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002d40:	0009a503          	lw	a0,0(s3)
    80002d44:	fffff097          	auipc	ra,0xfffff
    80002d48:	678080e7          	jalr	1656(ra) # 800023bc <bread>
    80002d4c:	8a2a                	mv	s4,a0
        for (j = 0; j < NINDIRECT; j++)
    80002d4e:	05850493          	addi	s1,a0,88
    80002d52:	45850913          	addi	s2,a0,1112
    80002d56:	a811                	j	80002d6a <itrunc+0x86>
                bfree(ip->dev, a[j]);
    80002d58:	0009a503          	lw	a0,0(s3)
    80002d5c:	00000097          	auipc	ra,0x0
    80002d60:	8a6080e7          	jalr	-1882(ra) # 80002602 <bfree>
        for (j = 0; j < NINDIRECT; j++)
    80002d64:	0491                	addi	s1,s1,4
    80002d66:	01248563          	beq	s1,s2,80002d70 <itrunc+0x8c>
            if (a[j])
    80002d6a:	408c                	lw	a1,0(s1)
    80002d6c:	dde5                	beqz	a1,80002d64 <itrunc+0x80>
    80002d6e:	b7ed                	j	80002d58 <itrunc+0x74>
        brelse(bp);
    80002d70:	8552                	mv	a0,s4
    80002d72:	fffff097          	auipc	ra,0xfffff
    80002d76:	77a080e7          	jalr	1914(ra) # 800024ec <brelse>
        bfree(ip->dev, ip->addrs[NDIRECT]);
    80002d7a:	0809a583          	lw	a1,128(s3)
    80002d7e:	0009a503          	lw	a0,0(s3)
    80002d82:	00000097          	auipc	ra,0x0
    80002d86:	880080e7          	jalr	-1920(ra) # 80002602 <bfree>
        ip->addrs[NDIRECT] = 0;
    80002d8a:	0809a023          	sw	zero,128(s3)
    80002d8e:	bf51                	j	80002d22 <itrunc+0x3e>

0000000080002d90 <iput>:
{
    80002d90:	1101                	addi	sp,sp,-32
    80002d92:	ec06                	sd	ra,24(sp)
    80002d94:	e822                	sd	s0,16(sp)
    80002d96:	e426                	sd	s1,8(sp)
    80002d98:	e04a                	sd	s2,0(sp)
    80002d9a:	1000                	addi	s0,sp,32
    80002d9c:	84aa                	mv	s1,a0
    acquire(&itable.lock);
    80002d9e:	00026517          	auipc	a0,0x26
    80002da2:	2aa50513          	addi	a0,a0,682 # 80029048 <itable>
    80002da6:	00003097          	auipc	ra,0x3
    80002daa:	7d6080e7          	jalr	2006(ra) # 8000657c <acquire>
    if (ip->ref == 1 && ip->valid && ip->nlink == 0)
    80002dae:	4498                	lw	a4,8(s1)
    80002db0:	4785                	li	a5,1
    80002db2:	02f70363          	beq	a4,a5,80002dd8 <iput+0x48>
    ip->ref--;
    80002db6:	449c                	lw	a5,8(s1)
    80002db8:	37fd                	addiw	a5,a5,-1
    80002dba:	c49c                	sw	a5,8(s1)
    release(&itable.lock);
    80002dbc:	00026517          	auipc	a0,0x26
    80002dc0:	28c50513          	addi	a0,a0,652 # 80029048 <itable>
    80002dc4:	00004097          	auipc	ra,0x4
    80002dc8:	86c080e7          	jalr	-1940(ra) # 80006630 <release>
}
    80002dcc:	60e2                	ld	ra,24(sp)
    80002dce:	6442                	ld	s0,16(sp)
    80002dd0:	64a2                	ld	s1,8(sp)
    80002dd2:	6902                	ld	s2,0(sp)
    80002dd4:	6105                	addi	sp,sp,32
    80002dd6:	8082                	ret
    if (ip->ref == 1 && ip->valid && ip->nlink == 0)
    80002dd8:	40bc                	lw	a5,64(s1)
    80002dda:	dff1                	beqz	a5,80002db6 <iput+0x26>
    80002ddc:	04a49783          	lh	a5,74(s1)
    80002de0:	fbf9                	bnez	a5,80002db6 <iput+0x26>
        acquiresleep(&ip->lock);
    80002de2:	01048913          	addi	s2,s1,16
    80002de6:	854a                	mv	a0,s2
    80002de8:	00001097          	auipc	ra,0x1
    80002dec:	aa8080e7          	jalr	-1368(ra) # 80003890 <acquiresleep>
        release(&itable.lock);
    80002df0:	00026517          	auipc	a0,0x26
    80002df4:	25850513          	addi	a0,a0,600 # 80029048 <itable>
    80002df8:	00004097          	auipc	ra,0x4
    80002dfc:	838080e7          	jalr	-1992(ra) # 80006630 <release>
        itrunc(ip);
    80002e00:	8526                	mv	a0,s1
    80002e02:	00000097          	auipc	ra,0x0
    80002e06:	ee2080e7          	jalr	-286(ra) # 80002ce4 <itrunc>
        ip->type = 0;
    80002e0a:	04049223          	sh	zero,68(s1)
        iupdate(ip);
    80002e0e:	8526                	mv	a0,s1
    80002e10:	00000097          	auipc	ra,0x0
    80002e14:	cfc080e7          	jalr	-772(ra) # 80002b0c <iupdate>
        ip->valid = 0;
    80002e18:	0404a023          	sw	zero,64(s1)
        releasesleep(&ip->lock);
    80002e1c:	854a                	mv	a0,s2
    80002e1e:	00001097          	auipc	ra,0x1
    80002e22:	ac8080e7          	jalr	-1336(ra) # 800038e6 <releasesleep>
        acquire(&itable.lock);
    80002e26:	00026517          	auipc	a0,0x26
    80002e2a:	22250513          	addi	a0,a0,546 # 80029048 <itable>
    80002e2e:	00003097          	auipc	ra,0x3
    80002e32:	74e080e7          	jalr	1870(ra) # 8000657c <acquire>
    80002e36:	b741                	j	80002db6 <iput+0x26>

0000000080002e38 <iunlockput>:
{
    80002e38:	1101                	addi	sp,sp,-32
    80002e3a:	ec06                	sd	ra,24(sp)
    80002e3c:	e822                	sd	s0,16(sp)
    80002e3e:	e426                	sd	s1,8(sp)
    80002e40:	1000                	addi	s0,sp,32
    80002e42:	84aa                	mv	s1,a0
    iunlock(ip);
    80002e44:	00000097          	auipc	ra,0x0
    80002e48:	e54080e7          	jalr	-428(ra) # 80002c98 <iunlock>
    iput(ip);
    80002e4c:	8526                	mv	a0,s1
    80002e4e:	00000097          	auipc	ra,0x0
    80002e52:	f42080e7          	jalr	-190(ra) # 80002d90 <iput>
}
    80002e56:	60e2                	ld	ra,24(sp)
    80002e58:	6442                	ld	s0,16(sp)
    80002e5a:	64a2                	ld	s1,8(sp)
    80002e5c:	6105                	addi	sp,sp,32
    80002e5e:	8082                	ret

0000000080002e60 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void stati(struct inode *ip, struct stat *st)
{
    80002e60:	1141                	addi	sp,sp,-16
    80002e62:	e422                	sd	s0,8(sp)
    80002e64:	0800                	addi	s0,sp,16
    st->dev = ip->dev;
    80002e66:	411c                	lw	a5,0(a0)
    80002e68:	c19c                	sw	a5,0(a1)
    st->ino = ip->inum;
    80002e6a:	415c                	lw	a5,4(a0)
    80002e6c:	c1dc                	sw	a5,4(a1)
    st->type = ip->type;
    80002e6e:	04451783          	lh	a5,68(a0)
    80002e72:	00f59423          	sh	a5,8(a1)
    st->nlink = ip->nlink;
    80002e76:	04a51783          	lh	a5,74(a0)
    80002e7a:	00f59523          	sh	a5,10(a1)
    st->size = ip->size;
    80002e7e:	04c56783          	lwu	a5,76(a0)
    80002e82:	e99c                	sd	a5,16(a1)
}
    80002e84:	6422                	ld	s0,8(sp)
    80002e86:	0141                	addi	sp,sp,16
    80002e88:	8082                	ret

0000000080002e8a <readi>:
int readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
    uint tot, m;
    struct buf *bp;

    if (off > ip->size || off + n < off)
    80002e8a:	457c                	lw	a5,76(a0)
    80002e8c:	0ed7e963          	bltu	a5,a3,80002f7e <readi+0xf4>
{
    80002e90:	7159                	addi	sp,sp,-112
    80002e92:	f486                	sd	ra,104(sp)
    80002e94:	f0a2                	sd	s0,96(sp)
    80002e96:	eca6                	sd	s1,88(sp)
    80002e98:	e8ca                	sd	s2,80(sp)
    80002e9a:	e4ce                	sd	s3,72(sp)
    80002e9c:	e0d2                	sd	s4,64(sp)
    80002e9e:	fc56                	sd	s5,56(sp)
    80002ea0:	f85a                	sd	s6,48(sp)
    80002ea2:	f45e                	sd	s7,40(sp)
    80002ea4:	f062                	sd	s8,32(sp)
    80002ea6:	ec66                	sd	s9,24(sp)
    80002ea8:	e86a                	sd	s10,16(sp)
    80002eaa:	e46e                	sd	s11,8(sp)
    80002eac:	1880                	addi	s0,sp,112
    80002eae:	8b2a                	mv	s6,a0
    80002eb0:	8bae                	mv	s7,a1
    80002eb2:	8a32                	mv	s4,a2
    80002eb4:	84b6                	mv	s1,a3
    80002eb6:	8aba                	mv	s5,a4
    if (off > ip->size || off + n < off)
    80002eb8:	9f35                	addw	a4,a4,a3
        return 0;
    80002eba:	4501                	li	a0,0
    if (off > ip->size || off + n < off)
    80002ebc:	0ad76063          	bltu	a4,a3,80002f5c <readi+0xd2>
    if (off + n > ip->size)
    80002ec0:	00e7f463          	bgeu	a5,a4,80002ec8 <readi+0x3e>
        n = ip->size - off;
    80002ec4:	40d78abb          	subw	s5,a5,a3

    for (tot = 0; tot < n; tot += m, off += m, dst += m)
    80002ec8:	0a0a8963          	beqz	s5,80002f7a <readi+0xf0>
    80002ecc:	4981                	li	s3,0
    {
        uint addr = bmap(ip, off / BSIZE);
        if (addr == 0)
            break;
        bp = bread(ip->dev, addr);
        m = min(n - tot, BSIZE - off % BSIZE);
    80002ece:	40000c93          	li	s9,1024
        if (either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1)
    80002ed2:	5c7d                	li	s8,-1
    80002ed4:	a82d                	j	80002f0e <readi+0x84>
    80002ed6:	020d1d93          	slli	s11,s10,0x20
    80002eda:	020ddd93          	srli	s11,s11,0x20
    80002ede:	05890613          	addi	a2,s2,88
    80002ee2:	86ee                	mv	a3,s11
    80002ee4:	963a                	add	a2,a2,a4
    80002ee6:	85d2                	mv	a1,s4
    80002ee8:	855e                	mv	a0,s7
    80002eea:	fffff097          	auipc	ra,0xfffff
    80002eee:	a24080e7          	jalr	-1500(ra) # 8000190e <either_copyout>
    80002ef2:	05850d63          	beq	a0,s8,80002f4c <readi+0xc2>
        {
            brelse(bp);
            tot = -1;
            break;
        }
        brelse(bp);
    80002ef6:	854a                	mv	a0,s2
    80002ef8:	fffff097          	auipc	ra,0xfffff
    80002efc:	5f4080e7          	jalr	1524(ra) # 800024ec <brelse>
    for (tot = 0; tot < n; tot += m, off += m, dst += m)
    80002f00:	013d09bb          	addw	s3,s10,s3
    80002f04:	009d04bb          	addw	s1,s10,s1
    80002f08:	9a6e                	add	s4,s4,s11
    80002f0a:	0559f763          	bgeu	s3,s5,80002f58 <readi+0xce>
        uint addr = bmap(ip, off / BSIZE);
    80002f0e:	00a4d59b          	srliw	a1,s1,0xa
    80002f12:	855a                	mv	a0,s6
    80002f14:	00000097          	auipc	ra,0x0
    80002f18:	8a2080e7          	jalr	-1886(ra) # 800027b6 <bmap>
    80002f1c:	0005059b          	sext.w	a1,a0
        if (addr == 0)
    80002f20:	cd85                	beqz	a1,80002f58 <readi+0xce>
        bp = bread(ip->dev, addr);
    80002f22:	000b2503          	lw	a0,0(s6)
    80002f26:	fffff097          	auipc	ra,0xfffff
    80002f2a:	496080e7          	jalr	1174(ra) # 800023bc <bread>
    80002f2e:	892a                	mv	s2,a0
        m = min(n - tot, BSIZE - off % BSIZE);
    80002f30:	3ff4f713          	andi	a4,s1,1023
    80002f34:	40ec87bb          	subw	a5,s9,a4
    80002f38:	413a86bb          	subw	a3,s5,s3
    80002f3c:	8d3e                	mv	s10,a5
    80002f3e:	2781                	sext.w	a5,a5
    80002f40:	0006861b          	sext.w	a2,a3
    80002f44:	f8f679e3          	bgeu	a2,a5,80002ed6 <readi+0x4c>
    80002f48:	8d36                	mv	s10,a3
    80002f4a:	b771                	j	80002ed6 <readi+0x4c>
            brelse(bp);
    80002f4c:	854a                	mv	a0,s2
    80002f4e:	fffff097          	auipc	ra,0xfffff
    80002f52:	59e080e7          	jalr	1438(ra) # 800024ec <brelse>
            tot = -1;
    80002f56:	59fd                	li	s3,-1
    }
    return tot;
    80002f58:	0009851b          	sext.w	a0,s3
}
    80002f5c:	70a6                	ld	ra,104(sp)
    80002f5e:	7406                	ld	s0,96(sp)
    80002f60:	64e6                	ld	s1,88(sp)
    80002f62:	6946                	ld	s2,80(sp)
    80002f64:	69a6                	ld	s3,72(sp)
    80002f66:	6a06                	ld	s4,64(sp)
    80002f68:	7ae2                	ld	s5,56(sp)
    80002f6a:	7b42                	ld	s6,48(sp)
    80002f6c:	7ba2                	ld	s7,40(sp)
    80002f6e:	7c02                	ld	s8,32(sp)
    80002f70:	6ce2                	ld	s9,24(sp)
    80002f72:	6d42                	ld	s10,16(sp)
    80002f74:	6da2                	ld	s11,8(sp)
    80002f76:	6165                	addi	sp,sp,112
    80002f78:	8082                	ret
    for (tot = 0; tot < n; tot += m, off += m, dst += m)
    80002f7a:	89d6                	mv	s3,s5
    80002f7c:	bff1                	j	80002f58 <readi+0xce>
        return 0;
    80002f7e:	4501                	li	a0,0
}
    80002f80:	8082                	ret

0000000080002f82 <writei>:
int writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
    uint tot, m;
    struct buf *bp;

    if (off > ip->size || off + n < off)
    80002f82:	457c                	lw	a5,76(a0)
    80002f84:	10d7e863          	bltu	a5,a3,80003094 <writei+0x112>
{
    80002f88:	7159                	addi	sp,sp,-112
    80002f8a:	f486                	sd	ra,104(sp)
    80002f8c:	f0a2                	sd	s0,96(sp)
    80002f8e:	eca6                	sd	s1,88(sp)
    80002f90:	e8ca                	sd	s2,80(sp)
    80002f92:	e4ce                	sd	s3,72(sp)
    80002f94:	e0d2                	sd	s4,64(sp)
    80002f96:	fc56                	sd	s5,56(sp)
    80002f98:	f85a                	sd	s6,48(sp)
    80002f9a:	f45e                	sd	s7,40(sp)
    80002f9c:	f062                	sd	s8,32(sp)
    80002f9e:	ec66                	sd	s9,24(sp)
    80002fa0:	e86a                	sd	s10,16(sp)
    80002fa2:	e46e                	sd	s11,8(sp)
    80002fa4:	1880                	addi	s0,sp,112
    80002fa6:	8aaa                	mv	s5,a0
    80002fa8:	8bae                	mv	s7,a1
    80002faa:	8a32                	mv	s4,a2
    80002fac:	8936                	mv	s2,a3
    80002fae:	8b3a                	mv	s6,a4
    if (off > ip->size || off + n < off)
    80002fb0:	00e687bb          	addw	a5,a3,a4
    80002fb4:	0ed7e263          	bltu	a5,a3,80003098 <writei+0x116>
        return -1;
    if (off + n > MAXFILE * BSIZE)
    80002fb8:	00043737          	lui	a4,0x43
    80002fbc:	0ef76063          	bltu	a4,a5,8000309c <writei+0x11a>
        return -1;

    for (tot = 0; tot < n; tot += m, off += m, src += m)
    80002fc0:	0c0b0863          	beqz	s6,80003090 <writei+0x10e>
    80002fc4:	4981                	li	s3,0
    {
        uint addr = bmap(ip, off / BSIZE);
        if (addr == 0)
            break;
        bp = bread(ip->dev, addr);
        m = min(n - tot, BSIZE - off % BSIZE);
    80002fc6:	40000c93          	li	s9,1024
        if (either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1)
    80002fca:	5c7d                	li	s8,-1
    80002fcc:	a091                	j	80003010 <writei+0x8e>
    80002fce:	020d1d93          	slli	s11,s10,0x20
    80002fd2:	020ddd93          	srli	s11,s11,0x20
    80002fd6:	05848513          	addi	a0,s1,88
    80002fda:	86ee                	mv	a3,s11
    80002fdc:	8652                	mv	a2,s4
    80002fde:	85de                	mv	a1,s7
    80002fe0:	953a                	add	a0,a0,a4
    80002fe2:	fffff097          	auipc	ra,0xfffff
    80002fe6:	982080e7          	jalr	-1662(ra) # 80001964 <either_copyin>
    80002fea:	07850263          	beq	a0,s8,8000304e <writei+0xcc>
        {
            brelse(bp);
            break;
        }
        log_write(bp);
    80002fee:	8526                	mv	a0,s1
    80002ff0:	00000097          	auipc	ra,0x0
    80002ff4:	780080e7          	jalr	1920(ra) # 80003770 <log_write>
        brelse(bp);
    80002ff8:	8526                	mv	a0,s1
    80002ffa:	fffff097          	auipc	ra,0xfffff
    80002ffe:	4f2080e7          	jalr	1266(ra) # 800024ec <brelse>
    for (tot = 0; tot < n; tot += m, off += m, src += m)
    80003002:	013d09bb          	addw	s3,s10,s3
    80003006:	012d093b          	addw	s2,s10,s2
    8000300a:	9a6e                	add	s4,s4,s11
    8000300c:	0569f663          	bgeu	s3,s6,80003058 <writei+0xd6>
        uint addr = bmap(ip, off / BSIZE);
    80003010:	00a9559b          	srliw	a1,s2,0xa
    80003014:	8556                	mv	a0,s5
    80003016:	fffff097          	auipc	ra,0xfffff
    8000301a:	7a0080e7          	jalr	1952(ra) # 800027b6 <bmap>
    8000301e:	0005059b          	sext.w	a1,a0
        if (addr == 0)
    80003022:	c99d                	beqz	a1,80003058 <writei+0xd6>
        bp = bread(ip->dev, addr);
    80003024:	000aa503          	lw	a0,0(s5)
    80003028:	fffff097          	auipc	ra,0xfffff
    8000302c:	394080e7          	jalr	916(ra) # 800023bc <bread>
    80003030:	84aa                	mv	s1,a0
        m = min(n - tot, BSIZE - off % BSIZE);
    80003032:	3ff97713          	andi	a4,s2,1023
    80003036:	40ec87bb          	subw	a5,s9,a4
    8000303a:	413b06bb          	subw	a3,s6,s3
    8000303e:	8d3e                	mv	s10,a5
    80003040:	2781                	sext.w	a5,a5
    80003042:	0006861b          	sext.w	a2,a3
    80003046:	f8f674e3          	bgeu	a2,a5,80002fce <writei+0x4c>
    8000304a:	8d36                	mv	s10,a3
    8000304c:	b749                	j	80002fce <writei+0x4c>
            brelse(bp);
    8000304e:	8526                	mv	a0,s1
    80003050:	fffff097          	auipc	ra,0xfffff
    80003054:	49c080e7          	jalr	1180(ra) # 800024ec <brelse>
    }

    if (off > ip->size)
    80003058:	04caa783          	lw	a5,76(s5)
    8000305c:	0127f463          	bgeu	a5,s2,80003064 <writei+0xe2>
        ip->size = off;
    80003060:	052aa623          	sw	s2,76(s5)

    // write the i-node back to disk even if the size didn't change
    // because the loop above might have called bmap() and added a new
    // block to ip->addrs[].
    iupdate(ip);
    80003064:	8556                	mv	a0,s5
    80003066:	00000097          	auipc	ra,0x0
    8000306a:	aa6080e7          	jalr	-1370(ra) # 80002b0c <iupdate>

    return tot;
    8000306e:	0009851b          	sext.w	a0,s3
}
    80003072:	70a6                	ld	ra,104(sp)
    80003074:	7406                	ld	s0,96(sp)
    80003076:	64e6                	ld	s1,88(sp)
    80003078:	6946                	ld	s2,80(sp)
    8000307a:	69a6                	ld	s3,72(sp)
    8000307c:	6a06                	ld	s4,64(sp)
    8000307e:	7ae2                	ld	s5,56(sp)
    80003080:	7b42                	ld	s6,48(sp)
    80003082:	7ba2                	ld	s7,40(sp)
    80003084:	7c02                	ld	s8,32(sp)
    80003086:	6ce2                	ld	s9,24(sp)
    80003088:	6d42                	ld	s10,16(sp)
    8000308a:	6da2                	ld	s11,8(sp)
    8000308c:	6165                	addi	sp,sp,112
    8000308e:	8082                	ret
    for (tot = 0; tot < n; tot += m, off += m, src += m)
    80003090:	89da                	mv	s3,s6
    80003092:	bfc9                	j	80003064 <writei+0xe2>
        return -1;
    80003094:	557d                	li	a0,-1
}
    80003096:	8082                	ret
        return -1;
    80003098:	557d                	li	a0,-1
    8000309a:	bfe1                	j	80003072 <writei+0xf0>
        return -1;
    8000309c:	557d                	li	a0,-1
    8000309e:	bfd1                	j	80003072 <writei+0xf0>

00000000800030a0 <namecmp>:

// Directories

int namecmp(const char *s, const char *t)
{
    800030a0:	1141                	addi	sp,sp,-16
    800030a2:	e406                	sd	ra,8(sp)
    800030a4:	e022                	sd	s0,0(sp)
    800030a6:	0800                	addi	s0,sp,16
    return strncmp(s, t, DIRSIZ);
    800030a8:	4639                	li	a2,14
    800030aa:	ffffd097          	auipc	ra,0xffffd
    800030ae:	1a6080e7          	jalr	422(ra) # 80000250 <strncmp>
}
    800030b2:	60a2                	ld	ra,8(sp)
    800030b4:	6402                	ld	s0,0(sp)
    800030b6:	0141                	addi	sp,sp,16
    800030b8:	8082                	ret

00000000800030ba <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode *
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800030ba:	7139                	addi	sp,sp,-64
    800030bc:	fc06                	sd	ra,56(sp)
    800030be:	f822                	sd	s0,48(sp)
    800030c0:	f426                	sd	s1,40(sp)
    800030c2:	f04a                	sd	s2,32(sp)
    800030c4:	ec4e                	sd	s3,24(sp)
    800030c6:	e852                	sd	s4,16(sp)
    800030c8:	0080                	addi	s0,sp,64
    uint off, inum;
    struct dirent de;

    if (dp->type != T_DIR)
    800030ca:	04451703          	lh	a4,68(a0)
    800030ce:	4785                	li	a5,1
    800030d0:	00f71a63          	bne	a4,a5,800030e4 <dirlookup+0x2a>
    800030d4:	892a                	mv	s2,a0
    800030d6:	89ae                	mv	s3,a1
    800030d8:	8a32                	mv	s4,a2
        panic("dirlookup not DIR");

    for (off = 0; off < dp->size; off += sizeof(de))
    800030da:	457c                	lw	a5,76(a0)
    800030dc:	4481                	li	s1,0
            inum = de.inum;
            return iget(dp->dev, inum);
        }
    }

    return 0;
    800030de:	4501                	li	a0,0
    for (off = 0; off < dp->size; off += sizeof(de))
    800030e0:	e79d                	bnez	a5,8000310e <dirlookup+0x54>
    800030e2:	a8a5                	j	8000315a <dirlookup+0xa0>
        panic("dirlookup not DIR");
    800030e4:	00005517          	auipc	a0,0x5
    800030e8:	4bc50513          	addi	a0,a0,1212 # 800085a0 <syscalls+0x1b0>
    800030ec:	00003097          	auipc	ra,0x3
    800030f0:	f46080e7          	jalr	-186(ra) # 80006032 <panic>
            panic("dirlookup read");
    800030f4:	00005517          	auipc	a0,0x5
    800030f8:	4c450513          	addi	a0,a0,1220 # 800085b8 <syscalls+0x1c8>
    800030fc:	00003097          	auipc	ra,0x3
    80003100:	f36080e7          	jalr	-202(ra) # 80006032 <panic>
    for (off = 0; off < dp->size; off += sizeof(de))
    80003104:	24c1                	addiw	s1,s1,16
    80003106:	04c92783          	lw	a5,76(s2)
    8000310a:	04f4f763          	bgeu	s1,a5,80003158 <dirlookup+0x9e>
        if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000310e:	4741                	li	a4,16
    80003110:	86a6                	mv	a3,s1
    80003112:	fc040613          	addi	a2,s0,-64
    80003116:	4581                	li	a1,0
    80003118:	854a                	mv	a0,s2
    8000311a:	00000097          	auipc	ra,0x0
    8000311e:	d70080e7          	jalr	-656(ra) # 80002e8a <readi>
    80003122:	47c1                	li	a5,16
    80003124:	fcf518e3          	bne	a0,a5,800030f4 <dirlookup+0x3a>
        if (de.inum == 0)
    80003128:	fc045783          	lhu	a5,-64(s0)
    8000312c:	dfe1                	beqz	a5,80003104 <dirlookup+0x4a>
        if (namecmp(name, de.name) == 0)
    8000312e:	fc240593          	addi	a1,s0,-62
    80003132:	854e                	mv	a0,s3
    80003134:	00000097          	auipc	ra,0x0
    80003138:	f6c080e7          	jalr	-148(ra) # 800030a0 <namecmp>
    8000313c:	f561                	bnez	a0,80003104 <dirlookup+0x4a>
            if (poff)
    8000313e:	000a0463          	beqz	s4,80003146 <dirlookup+0x8c>
                *poff = off;
    80003142:	009a2023          	sw	s1,0(s4)
            return iget(dp->dev, inum);
    80003146:	fc045583          	lhu	a1,-64(s0)
    8000314a:	00092503          	lw	a0,0(s2)
    8000314e:	fffff097          	auipc	ra,0xfffff
    80003152:	750080e7          	jalr	1872(ra) # 8000289e <iget>
    80003156:	a011                	j	8000315a <dirlookup+0xa0>
    return 0;
    80003158:	4501                	li	a0,0
}
    8000315a:	70e2                	ld	ra,56(sp)
    8000315c:	7442                	ld	s0,48(sp)
    8000315e:	74a2                	ld	s1,40(sp)
    80003160:	7902                	ld	s2,32(sp)
    80003162:	69e2                	ld	s3,24(sp)
    80003164:	6a42                	ld	s4,16(sp)
    80003166:	6121                	addi	sp,sp,64
    80003168:	8082                	ret

000000008000316a <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode *
namex(char *path, int nameiparent, char *name)
{
    8000316a:	711d                	addi	sp,sp,-96
    8000316c:	ec86                	sd	ra,88(sp)
    8000316e:	e8a2                	sd	s0,80(sp)
    80003170:	e4a6                	sd	s1,72(sp)
    80003172:	e0ca                	sd	s2,64(sp)
    80003174:	fc4e                	sd	s3,56(sp)
    80003176:	f852                	sd	s4,48(sp)
    80003178:	f456                	sd	s5,40(sp)
    8000317a:	f05a                	sd	s6,32(sp)
    8000317c:	ec5e                	sd	s7,24(sp)
    8000317e:	e862                	sd	s8,16(sp)
    80003180:	e466                	sd	s9,8(sp)
    80003182:	1080                	addi	s0,sp,96
    80003184:	84aa                	mv	s1,a0
    80003186:	8b2e                	mv	s6,a1
    80003188:	8ab2                	mv	s5,a2
    struct inode *ip, *next;

    if (*path == '/')
    8000318a:	00054703          	lbu	a4,0(a0)
    8000318e:	02f00793          	li	a5,47
    80003192:	02f70363          	beq	a4,a5,800031b8 <namex+0x4e>
        ip = iget(ROOTDEV, ROOTINO);
    else
        ip = idup(myproc()->cwd);
    80003196:	ffffe097          	auipc	ra,0xffffe
    8000319a:	ccc080e7          	jalr	-820(ra) # 80000e62 <myproc>
    8000319e:	15053503          	ld	a0,336(a0)
    800031a2:	00000097          	auipc	ra,0x0
    800031a6:	9f6080e7          	jalr	-1546(ra) # 80002b98 <idup>
    800031aa:	89aa                	mv	s3,a0
    while (*path == '/')
    800031ac:	02f00913          	li	s2,47
    len = path - s;
    800031b0:	4b81                	li	s7,0
    if (len >= DIRSIZ)
    800031b2:	4cb5                	li	s9,13

    while ((path = skipelem(path, name)) != 0)
    {
        ilock(ip);
        if (ip->type != T_DIR)
    800031b4:	4c05                	li	s8,1
    800031b6:	a865                	j	8000326e <namex+0x104>
        ip = iget(ROOTDEV, ROOTINO);
    800031b8:	4585                	li	a1,1
    800031ba:	4505                	li	a0,1
    800031bc:	fffff097          	auipc	ra,0xfffff
    800031c0:	6e2080e7          	jalr	1762(ra) # 8000289e <iget>
    800031c4:	89aa                	mv	s3,a0
    800031c6:	b7dd                	j	800031ac <namex+0x42>
        {
            iunlockput(ip);
    800031c8:	854e                	mv	a0,s3
    800031ca:	00000097          	auipc	ra,0x0
    800031ce:	c6e080e7          	jalr	-914(ra) # 80002e38 <iunlockput>
            return 0;
    800031d2:	4981                	li	s3,0
    {
        iput(ip);
        return 0;
    }
    return ip;
}
    800031d4:	854e                	mv	a0,s3
    800031d6:	60e6                	ld	ra,88(sp)
    800031d8:	6446                	ld	s0,80(sp)
    800031da:	64a6                	ld	s1,72(sp)
    800031dc:	6906                	ld	s2,64(sp)
    800031de:	79e2                	ld	s3,56(sp)
    800031e0:	7a42                	ld	s4,48(sp)
    800031e2:	7aa2                	ld	s5,40(sp)
    800031e4:	7b02                	ld	s6,32(sp)
    800031e6:	6be2                	ld	s7,24(sp)
    800031e8:	6c42                	ld	s8,16(sp)
    800031ea:	6ca2                	ld	s9,8(sp)
    800031ec:	6125                	addi	sp,sp,96
    800031ee:	8082                	ret
            iunlock(ip);
    800031f0:	854e                	mv	a0,s3
    800031f2:	00000097          	auipc	ra,0x0
    800031f6:	aa6080e7          	jalr	-1370(ra) # 80002c98 <iunlock>
            return ip;
    800031fa:	bfe9                	j	800031d4 <namex+0x6a>
            iunlockput(ip);
    800031fc:	854e                	mv	a0,s3
    800031fe:	00000097          	auipc	ra,0x0
    80003202:	c3a080e7          	jalr	-966(ra) # 80002e38 <iunlockput>
            return 0;
    80003206:	89d2                	mv	s3,s4
    80003208:	b7f1                	j	800031d4 <namex+0x6a>
    len = path - s;
    8000320a:	40b48633          	sub	a2,s1,a1
    8000320e:	00060a1b          	sext.w	s4,a2
    if (len >= DIRSIZ)
    80003212:	094cd463          	bge	s9,s4,8000329a <namex+0x130>
        memmove(name, s, DIRSIZ);
    80003216:	4639                	li	a2,14
    80003218:	8556                	mv	a0,s5
    8000321a:	ffffd097          	auipc	ra,0xffffd
    8000321e:	fbe080e7          	jalr	-66(ra) # 800001d8 <memmove>
    while (*path == '/')
    80003222:	0004c783          	lbu	a5,0(s1)
    80003226:	01279763          	bne	a5,s2,80003234 <namex+0xca>
        path++;
    8000322a:	0485                	addi	s1,s1,1
    while (*path == '/')
    8000322c:	0004c783          	lbu	a5,0(s1)
    80003230:	ff278de3          	beq	a5,s2,8000322a <namex+0xc0>
        ilock(ip);
    80003234:	854e                	mv	a0,s3
    80003236:	00000097          	auipc	ra,0x0
    8000323a:	9a0080e7          	jalr	-1632(ra) # 80002bd6 <ilock>
        if (ip->type != T_DIR)
    8000323e:	04499783          	lh	a5,68(s3)
    80003242:	f98793e3          	bne	a5,s8,800031c8 <namex+0x5e>
        if (nameiparent && *path == '\0')
    80003246:	000b0563          	beqz	s6,80003250 <namex+0xe6>
    8000324a:	0004c783          	lbu	a5,0(s1)
    8000324e:	d3cd                	beqz	a5,800031f0 <namex+0x86>
        if ((next = dirlookup(ip, name, 0)) == 0)
    80003250:	865e                	mv	a2,s7
    80003252:	85d6                	mv	a1,s5
    80003254:	854e                	mv	a0,s3
    80003256:	00000097          	auipc	ra,0x0
    8000325a:	e64080e7          	jalr	-412(ra) # 800030ba <dirlookup>
    8000325e:	8a2a                	mv	s4,a0
    80003260:	dd51                	beqz	a0,800031fc <namex+0x92>
        iunlockput(ip);
    80003262:	854e                	mv	a0,s3
    80003264:	00000097          	auipc	ra,0x0
    80003268:	bd4080e7          	jalr	-1068(ra) # 80002e38 <iunlockput>
        ip = next;
    8000326c:	89d2                	mv	s3,s4
    while (*path == '/')
    8000326e:	0004c783          	lbu	a5,0(s1)
    80003272:	05279763          	bne	a5,s2,800032c0 <namex+0x156>
        path++;
    80003276:	0485                	addi	s1,s1,1
    while (*path == '/')
    80003278:	0004c783          	lbu	a5,0(s1)
    8000327c:	ff278de3          	beq	a5,s2,80003276 <namex+0x10c>
    if (*path == 0)
    80003280:	c79d                	beqz	a5,800032ae <namex+0x144>
        path++;
    80003282:	85a6                	mv	a1,s1
    len = path - s;
    80003284:	8a5e                	mv	s4,s7
    80003286:	865e                	mv	a2,s7
    while (*path != '/' && *path != 0)
    80003288:	01278963          	beq	a5,s2,8000329a <namex+0x130>
    8000328c:	dfbd                	beqz	a5,8000320a <namex+0xa0>
        path++;
    8000328e:	0485                	addi	s1,s1,1
    while (*path != '/' && *path != 0)
    80003290:	0004c783          	lbu	a5,0(s1)
    80003294:	ff279ce3          	bne	a5,s2,8000328c <namex+0x122>
    80003298:	bf8d                	j	8000320a <namex+0xa0>
        memmove(name, s, len);
    8000329a:	2601                	sext.w	a2,a2
    8000329c:	8556                	mv	a0,s5
    8000329e:	ffffd097          	auipc	ra,0xffffd
    800032a2:	f3a080e7          	jalr	-198(ra) # 800001d8 <memmove>
        name[len] = 0;
    800032a6:	9a56                	add	s4,s4,s5
    800032a8:	000a0023          	sb	zero,0(s4)
    800032ac:	bf9d                	j	80003222 <namex+0xb8>
    if (nameiparent)
    800032ae:	f20b03e3          	beqz	s6,800031d4 <namex+0x6a>
        iput(ip);
    800032b2:	854e                	mv	a0,s3
    800032b4:	00000097          	auipc	ra,0x0
    800032b8:	adc080e7          	jalr	-1316(ra) # 80002d90 <iput>
        return 0;
    800032bc:	4981                	li	s3,0
    800032be:	bf19                	j	800031d4 <namex+0x6a>
    if (*path == 0)
    800032c0:	d7fd                	beqz	a5,800032ae <namex+0x144>
    while (*path != '/' && *path != 0)
    800032c2:	0004c783          	lbu	a5,0(s1)
    800032c6:	85a6                	mv	a1,s1
    800032c8:	b7d1                	j	8000328c <namex+0x122>

00000000800032ca <dirlink>:
{
    800032ca:	7139                	addi	sp,sp,-64
    800032cc:	fc06                	sd	ra,56(sp)
    800032ce:	f822                	sd	s0,48(sp)
    800032d0:	f426                	sd	s1,40(sp)
    800032d2:	f04a                	sd	s2,32(sp)
    800032d4:	ec4e                	sd	s3,24(sp)
    800032d6:	e852                	sd	s4,16(sp)
    800032d8:	0080                	addi	s0,sp,64
    800032da:	892a                	mv	s2,a0
    800032dc:	8a2e                	mv	s4,a1
    800032de:	89b2                	mv	s3,a2
    if ((ip = dirlookup(dp, name, 0)) != 0)
    800032e0:	4601                	li	a2,0
    800032e2:	00000097          	auipc	ra,0x0
    800032e6:	dd8080e7          	jalr	-552(ra) # 800030ba <dirlookup>
    800032ea:	e93d                	bnez	a0,80003360 <dirlink+0x96>
    for (off = 0; off < dp->size; off += sizeof(de))
    800032ec:	04c92483          	lw	s1,76(s2)
    800032f0:	c49d                	beqz	s1,8000331e <dirlink+0x54>
    800032f2:	4481                	li	s1,0
        if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800032f4:	4741                	li	a4,16
    800032f6:	86a6                	mv	a3,s1
    800032f8:	fc040613          	addi	a2,s0,-64
    800032fc:	4581                	li	a1,0
    800032fe:	854a                	mv	a0,s2
    80003300:	00000097          	auipc	ra,0x0
    80003304:	b8a080e7          	jalr	-1142(ra) # 80002e8a <readi>
    80003308:	47c1                	li	a5,16
    8000330a:	06f51163          	bne	a0,a5,8000336c <dirlink+0xa2>
        if (de.inum == 0)
    8000330e:	fc045783          	lhu	a5,-64(s0)
    80003312:	c791                	beqz	a5,8000331e <dirlink+0x54>
    for (off = 0; off < dp->size; off += sizeof(de))
    80003314:	24c1                	addiw	s1,s1,16
    80003316:	04c92783          	lw	a5,76(s2)
    8000331a:	fcf4ede3          	bltu	s1,a5,800032f4 <dirlink+0x2a>
    strncpy(de.name, name, DIRSIZ);
    8000331e:	4639                	li	a2,14
    80003320:	85d2                	mv	a1,s4
    80003322:	fc240513          	addi	a0,s0,-62
    80003326:	ffffd097          	auipc	ra,0xffffd
    8000332a:	f66080e7          	jalr	-154(ra) # 8000028c <strncpy>
    de.inum = inum;
    8000332e:	fd341023          	sh	s3,-64(s0)
    if (writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003332:	4741                	li	a4,16
    80003334:	86a6                	mv	a3,s1
    80003336:	fc040613          	addi	a2,s0,-64
    8000333a:	4581                	li	a1,0
    8000333c:	854a                	mv	a0,s2
    8000333e:	00000097          	auipc	ra,0x0
    80003342:	c44080e7          	jalr	-956(ra) # 80002f82 <writei>
    80003346:	1541                	addi	a0,a0,-16
    80003348:	00a03533          	snez	a0,a0
    8000334c:	40a00533          	neg	a0,a0
}
    80003350:	70e2                	ld	ra,56(sp)
    80003352:	7442                	ld	s0,48(sp)
    80003354:	74a2                	ld	s1,40(sp)
    80003356:	7902                	ld	s2,32(sp)
    80003358:	69e2                	ld	s3,24(sp)
    8000335a:	6a42                	ld	s4,16(sp)
    8000335c:	6121                	addi	sp,sp,64
    8000335e:	8082                	ret
        iput(ip);
    80003360:	00000097          	auipc	ra,0x0
    80003364:	a30080e7          	jalr	-1488(ra) # 80002d90 <iput>
        return -1;
    80003368:	557d                	li	a0,-1
    8000336a:	b7dd                	j	80003350 <dirlink+0x86>
            panic("dirlink read");
    8000336c:	00005517          	auipc	a0,0x5
    80003370:	25c50513          	addi	a0,a0,604 # 800085c8 <syscalls+0x1d8>
    80003374:	00003097          	auipc	ra,0x3
    80003378:	cbe080e7          	jalr	-834(ra) # 80006032 <panic>

000000008000337c <namei>:

struct inode *
namei(char *path)
{
    8000337c:	1101                	addi	sp,sp,-32
    8000337e:	ec06                	sd	ra,24(sp)
    80003380:	e822                	sd	s0,16(sp)
    80003382:	1000                	addi	s0,sp,32
    char name[DIRSIZ];
    return namex(path, 0, name);
    80003384:	fe040613          	addi	a2,s0,-32
    80003388:	4581                	li	a1,0
    8000338a:	00000097          	auipc	ra,0x0
    8000338e:	de0080e7          	jalr	-544(ra) # 8000316a <namex>
}
    80003392:	60e2                	ld	ra,24(sp)
    80003394:	6442                	ld	s0,16(sp)
    80003396:	6105                	addi	sp,sp,32
    80003398:	8082                	ret

000000008000339a <nameiparent>:

struct inode *
nameiparent(char *path, char *name)
{
    8000339a:	1141                	addi	sp,sp,-16
    8000339c:	e406                	sd	ra,8(sp)
    8000339e:	e022                	sd	s0,0(sp)
    800033a0:	0800                	addi	s0,sp,16
    800033a2:	862e                	mv	a2,a1
    return namex(path, 1, name);
    800033a4:	4585                	li	a1,1
    800033a6:	00000097          	auipc	ra,0x0
    800033aa:	dc4080e7          	jalr	-572(ra) # 8000316a <namex>
}
    800033ae:	60a2                	ld	ra,8(sp)
    800033b0:	6402                	ld	s0,0(sp)
    800033b2:	0141                	addi	sp,sp,16
    800033b4:	8082                	ret

00000000800033b6 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800033b6:	1101                	addi	sp,sp,-32
    800033b8:	ec06                	sd	ra,24(sp)
    800033ba:	e822                	sd	s0,16(sp)
    800033bc:	e426                	sd	s1,8(sp)
    800033be:	e04a                	sd	s2,0(sp)
    800033c0:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800033c2:	00027917          	auipc	s2,0x27
    800033c6:	72e90913          	addi	s2,s2,1838 # 8002aaf0 <log>
    800033ca:	01892583          	lw	a1,24(s2)
    800033ce:	02892503          	lw	a0,40(s2)
    800033d2:	fffff097          	auipc	ra,0xfffff
    800033d6:	fea080e7          	jalr	-22(ra) # 800023bc <bread>
    800033da:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800033dc:	02c92683          	lw	a3,44(s2)
    800033e0:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800033e2:	02d05763          	blez	a3,80003410 <write_head+0x5a>
    800033e6:	00027797          	auipc	a5,0x27
    800033ea:	73a78793          	addi	a5,a5,1850 # 8002ab20 <log+0x30>
    800033ee:	05c50713          	addi	a4,a0,92
    800033f2:	36fd                	addiw	a3,a3,-1
    800033f4:	1682                	slli	a3,a3,0x20
    800033f6:	9281                	srli	a3,a3,0x20
    800033f8:	068a                	slli	a3,a3,0x2
    800033fa:	00027617          	auipc	a2,0x27
    800033fe:	72a60613          	addi	a2,a2,1834 # 8002ab24 <log+0x34>
    80003402:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80003404:	4390                	lw	a2,0(a5)
    80003406:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003408:	0791                	addi	a5,a5,4
    8000340a:	0711                	addi	a4,a4,4
    8000340c:	fed79ce3          	bne	a5,a3,80003404 <write_head+0x4e>
  }
  bwrite(buf);
    80003410:	8526                	mv	a0,s1
    80003412:	fffff097          	auipc	ra,0xfffff
    80003416:	09c080e7          	jalr	156(ra) # 800024ae <bwrite>
  brelse(buf);
    8000341a:	8526                	mv	a0,s1
    8000341c:	fffff097          	auipc	ra,0xfffff
    80003420:	0d0080e7          	jalr	208(ra) # 800024ec <brelse>
}
    80003424:	60e2                	ld	ra,24(sp)
    80003426:	6442                	ld	s0,16(sp)
    80003428:	64a2                	ld	s1,8(sp)
    8000342a:	6902                	ld	s2,0(sp)
    8000342c:	6105                	addi	sp,sp,32
    8000342e:	8082                	ret

0000000080003430 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003430:	00027797          	auipc	a5,0x27
    80003434:	6ec7a783          	lw	a5,1772(a5) # 8002ab1c <log+0x2c>
    80003438:	0af05d63          	blez	a5,800034f2 <install_trans+0xc2>
{
    8000343c:	7139                	addi	sp,sp,-64
    8000343e:	fc06                	sd	ra,56(sp)
    80003440:	f822                	sd	s0,48(sp)
    80003442:	f426                	sd	s1,40(sp)
    80003444:	f04a                	sd	s2,32(sp)
    80003446:	ec4e                	sd	s3,24(sp)
    80003448:	e852                	sd	s4,16(sp)
    8000344a:	e456                	sd	s5,8(sp)
    8000344c:	e05a                	sd	s6,0(sp)
    8000344e:	0080                	addi	s0,sp,64
    80003450:	8b2a                	mv	s6,a0
    80003452:	00027a97          	auipc	s5,0x27
    80003456:	6cea8a93          	addi	s5,s5,1742 # 8002ab20 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000345a:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000345c:	00027997          	auipc	s3,0x27
    80003460:	69498993          	addi	s3,s3,1684 # 8002aaf0 <log>
    80003464:	a035                	j	80003490 <install_trans+0x60>
      bunpin(dbuf);
    80003466:	8526                	mv	a0,s1
    80003468:	fffff097          	auipc	ra,0xfffff
    8000346c:	15e080e7          	jalr	350(ra) # 800025c6 <bunpin>
    brelse(lbuf);
    80003470:	854a                	mv	a0,s2
    80003472:	fffff097          	auipc	ra,0xfffff
    80003476:	07a080e7          	jalr	122(ra) # 800024ec <brelse>
    brelse(dbuf);
    8000347a:	8526                	mv	a0,s1
    8000347c:	fffff097          	auipc	ra,0xfffff
    80003480:	070080e7          	jalr	112(ra) # 800024ec <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003484:	2a05                	addiw	s4,s4,1
    80003486:	0a91                	addi	s5,s5,4
    80003488:	02c9a783          	lw	a5,44(s3)
    8000348c:	04fa5963          	bge	s4,a5,800034de <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003490:	0189a583          	lw	a1,24(s3)
    80003494:	014585bb          	addw	a1,a1,s4
    80003498:	2585                	addiw	a1,a1,1
    8000349a:	0289a503          	lw	a0,40(s3)
    8000349e:	fffff097          	auipc	ra,0xfffff
    800034a2:	f1e080e7          	jalr	-226(ra) # 800023bc <bread>
    800034a6:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800034a8:	000aa583          	lw	a1,0(s5)
    800034ac:	0289a503          	lw	a0,40(s3)
    800034b0:	fffff097          	auipc	ra,0xfffff
    800034b4:	f0c080e7          	jalr	-244(ra) # 800023bc <bread>
    800034b8:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800034ba:	40000613          	li	a2,1024
    800034be:	05890593          	addi	a1,s2,88
    800034c2:	05850513          	addi	a0,a0,88
    800034c6:	ffffd097          	auipc	ra,0xffffd
    800034ca:	d12080e7          	jalr	-750(ra) # 800001d8 <memmove>
    bwrite(dbuf);  // write dst to disk
    800034ce:	8526                	mv	a0,s1
    800034d0:	fffff097          	auipc	ra,0xfffff
    800034d4:	fde080e7          	jalr	-34(ra) # 800024ae <bwrite>
    if(recovering == 0)
    800034d8:	f80b1ce3          	bnez	s6,80003470 <install_trans+0x40>
    800034dc:	b769                	j	80003466 <install_trans+0x36>
}
    800034de:	70e2                	ld	ra,56(sp)
    800034e0:	7442                	ld	s0,48(sp)
    800034e2:	74a2                	ld	s1,40(sp)
    800034e4:	7902                	ld	s2,32(sp)
    800034e6:	69e2                	ld	s3,24(sp)
    800034e8:	6a42                	ld	s4,16(sp)
    800034ea:	6aa2                	ld	s5,8(sp)
    800034ec:	6b02                	ld	s6,0(sp)
    800034ee:	6121                	addi	sp,sp,64
    800034f0:	8082                	ret
    800034f2:	8082                	ret

00000000800034f4 <initlog>:
{
    800034f4:	7179                	addi	sp,sp,-48
    800034f6:	f406                	sd	ra,40(sp)
    800034f8:	f022                	sd	s0,32(sp)
    800034fa:	ec26                	sd	s1,24(sp)
    800034fc:	e84a                	sd	s2,16(sp)
    800034fe:	e44e                	sd	s3,8(sp)
    80003500:	1800                	addi	s0,sp,48
    80003502:	892a                	mv	s2,a0
    80003504:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003506:	00027497          	auipc	s1,0x27
    8000350a:	5ea48493          	addi	s1,s1,1514 # 8002aaf0 <log>
    8000350e:	00005597          	auipc	a1,0x5
    80003512:	0ca58593          	addi	a1,a1,202 # 800085d8 <syscalls+0x1e8>
    80003516:	8526                	mv	a0,s1
    80003518:	00003097          	auipc	ra,0x3
    8000351c:	fd4080e7          	jalr	-44(ra) # 800064ec <initlock>
  log.start = sb->logstart;
    80003520:	0149a583          	lw	a1,20(s3)
    80003524:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003526:	0109a783          	lw	a5,16(s3)
    8000352a:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    8000352c:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003530:	854a                	mv	a0,s2
    80003532:	fffff097          	auipc	ra,0xfffff
    80003536:	e8a080e7          	jalr	-374(ra) # 800023bc <bread>
  log.lh.n = lh->n;
    8000353a:	4d3c                	lw	a5,88(a0)
    8000353c:	d4dc                	sw	a5,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    8000353e:	02f05563          	blez	a5,80003568 <initlog+0x74>
    80003542:	05c50713          	addi	a4,a0,92
    80003546:	00027697          	auipc	a3,0x27
    8000354a:	5da68693          	addi	a3,a3,1498 # 8002ab20 <log+0x30>
    8000354e:	37fd                	addiw	a5,a5,-1
    80003550:	1782                	slli	a5,a5,0x20
    80003552:	9381                	srli	a5,a5,0x20
    80003554:	078a                	slli	a5,a5,0x2
    80003556:	06050613          	addi	a2,a0,96
    8000355a:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    8000355c:	4310                	lw	a2,0(a4)
    8000355e:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    80003560:	0711                	addi	a4,a4,4
    80003562:	0691                	addi	a3,a3,4
    80003564:	fef71ce3          	bne	a4,a5,8000355c <initlog+0x68>
  brelse(buf);
    80003568:	fffff097          	auipc	ra,0xfffff
    8000356c:	f84080e7          	jalr	-124(ra) # 800024ec <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    80003570:	4505                	li	a0,1
    80003572:	00000097          	auipc	ra,0x0
    80003576:	ebe080e7          	jalr	-322(ra) # 80003430 <install_trans>
  log.lh.n = 0;
    8000357a:	00027797          	auipc	a5,0x27
    8000357e:	5a07a123          	sw	zero,1442(a5) # 8002ab1c <log+0x2c>
  write_head(); // clear the log
    80003582:	00000097          	auipc	ra,0x0
    80003586:	e34080e7          	jalr	-460(ra) # 800033b6 <write_head>
}
    8000358a:	70a2                	ld	ra,40(sp)
    8000358c:	7402                	ld	s0,32(sp)
    8000358e:	64e2                	ld	s1,24(sp)
    80003590:	6942                	ld	s2,16(sp)
    80003592:	69a2                	ld	s3,8(sp)
    80003594:	6145                	addi	sp,sp,48
    80003596:	8082                	ret

0000000080003598 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003598:	1101                	addi	sp,sp,-32
    8000359a:	ec06                	sd	ra,24(sp)
    8000359c:	e822                	sd	s0,16(sp)
    8000359e:	e426                	sd	s1,8(sp)
    800035a0:	e04a                	sd	s2,0(sp)
    800035a2:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800035a4:	00027517          	auipc	a0,0x27
    800035a8:	54c50513          	addi	a0,a0,1356 # 8002aaf0 <log>
    800035ac:	00003097          	auipc	ra,0x3
    800035b0:	fd0080e7          	jalr	-48(ra) # 8000657c <acquire>
  while(1){
    if(log.committing){
    800035b4:	00027497          	auipc	s1,0x27
    800035b8:	53c48493          	addi	s1,s1,1340 # 8002aaf0 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800035bc:	4979                	li	s2,30
    800035be:	a039                	j	800035cc <begin_op+0x34>
      sleep(&log, &log.lock);
    800035c0:	85a6                	mv	a1,s1
    800035c2:	8526                	mv	a0,s1
    800035c4:	ffffe097          	auipc	ra,0xffffe
    800035c8:	f42080e7          	jalr	-190(ra) # 80001506 <sleep>
    if(log.committing){
    800035cc:	50dc                	lw	a5,36(s1)
    800035ce:	fbed                	bnez	a5,800035c0 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800035d0:	509c                	lw	a5,32(s1)
    800035d2:	0017871b          	addiw	a4,a5,1
    800035d6:	0007069b          	sext.w	a3,a4
    800035da:	0027179b          	slliw	a5,a4,0x2
    800035de:	9fb9                	addw	a5,a5,a4
    800035e0:	0017979b          	slliw	a5,a5,0x1
    800035e4:	54d8                	lw	a4,44(s1)
    800035e6:	9fb9                	addw	a5,a5,a4
    800035e8:	00f95963          	bge	s2,a5,800035fa <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    800035ec:	85a6                	mv	a1,s1
    800035ee:	8526                	mv	a0,s1
    800035f0:	ffffe097          	auipc	ra,0xffffe
    800035f4:	f16080e7          	jalr	-234(ra) # 80001506 <sleep>
    800035f8:	bfd1                	j	800035cc <begin_op+0x34>
    } else {
      log.outstanding += 1;
    800035fa:	00027517          	auipc	a0,0x27
    800035fe:	4f650513          	addi	a0,a0,1270 # 8002aaf0 <log>
    80003602:	d114                	sw	a3,32(a0)
      release(&log.lock);
    80003604:	00003097          	auipc	ra,0x3
    80003608:	02c080e7          	jalr	44(ra) # 80006630 <release>
      break;
    }
  }
}
    8000360c:	60e2                	ld	ra,24(sp)
    8000360e:	6442                	ld	s0,16(sp)
    80003610:	64a2                	ld	s1,8(sp)
    80003612:	6902                	ld	s2,0(sp)
    80003614:	6105                	addi	sp,sp,32
    80003616:	8082                	ret

0000000080003618 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003618:	7139                	addi	sp,sp,-64
    8000361a:	fc06                	sd	ra,56(sp)
    8000361c:	f822                	sd	s0,48(sp)
    8000361e:	f426                	sd	s1,40(sp)
    80003620:	f04a                	sd	s2,32(sp)
    80003622:	ec4e                	sd	s3,24(sp)
    80003624:	e852                	sd	s4,16(sp)
    80003626:	e456                	sd	s5,8(sp)
    80003628:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000362a:	00027497          	auipc	s1,0x27
    8000362e:	4c648493          	addi	s1,s1,1222 # 8002aaf0 <log>
    80003632:	8526                	mv	a0,s1
    80003634:	00003097          	auipc	ra,0x3
    80003638:	f48080e7          	jalr	-184(ra) # 8000657c <acquire>
  log.outstanding -= 1;
    8000363c:	509c                	lw	a5,32(s1)
    8000363e:	37fd                	addiw	a5,a5,-1
    80003640:	0007891b          	sext.w	s2,a5
    80003644:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003646:	50dc                	lw	a5,36(s1)
    80003648:	efb9                	bnez	a5,800036a6 <end_op+0x8e>
    panic("log.committing");
  if(log.outstanding == 0){
    8000364a:	06091663          	bnez	s2,800036b6 <end_op+0x9e>
    do_commit = 1;
    log.committing = 1;
    8000364e:	00027497          	auipc	s1,0x27
    80003652:	4a248493          	addi	s1,s1,1186 # 8002aaf0 <log>
    80003656:	4785                	li	a5,1
    80003658:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000365a:	8526                	mv	a0,s1
    8000365c:	00003097          	auipc	ra,0x3
    80003660:	fd4080e7          	jalr	-44(ra) # 80006630 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003664:	54dc                	lw	a5,44(s1)
    80003666:	06f04763          	bgtz	a5,800036d4 <end_op+0xbc>
    acquire(&log.lock);
    8000366a:	00027497          	auipc	s1,0x27
    8000366e:	48648493          	addi	s1,s1,1158 # 8002aaf0 <log>
    80003672:	8526                	mv	a0,s1
    80003674:	00003097          	auipc	ra,0x3
    80003678:	f08080e7          	jalr	-248(ra) # 8000657c <acquire>
    log.committing = 0;
    8000367c:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    80003680:	8526                	mv	a0,s1
    80003682:	ffffe097          	auipc	ra,0xffffe
    80003686:	ee8080e7          	jalr	-280(ra) # 8000156a <wakeup>
    release(&log.lock);
    8000368a:	8526                	mv	a0,s1
    8000368c:	00003097          	auipc	ra,0x3
    80003690:	fa4080e7          	jalr	-92(ra) # 80006630 <release>
}
    80003694:	70e2                	ld	ra,56(sp)
    80003696:	7442                	ld	s0,48(sp)
    80003698:	74a2                	ld	s1,40(sp)
    8000369a:	7902                	ld	s2,32(sp)
    8000369c:	69e2                	ld	s3,24(sp)
    8000369e:	6a42                	ld	s4,16(sp)
    800036a0:	6aa2                	ld	s5,8(sp)
    800036a2:	6121                	addi	sp,sp,64
    800036a4:	8082                	ret
    panic("log.committing");
    800036a6:	00005517          	auipc	a0,0x5
    800036aa:	f3a50513          	addi	a0,a0,-198 # 800085e0 <syscalls+0x1f0>
    800036ae:	00003097          	auipc	ra,0x3
    800036b2:	984080e7          	jalr	-1660(ra) # 80006032 <panic>
    wakeup(&log);
    800036b6:	00027497          	auipc	s1,0x27
    800036ba:	43a48493          	addi	s1,s1,1082 # 8002aaf0 <log>
    800036be:	8526                	mv	a0,s1
    800036c0:	ffffe097          	auipc	ra,0xffffe
    800036c4:	eaa080e7          	jalr	-342(ra) # 8000156a <wakeup>
  release(&log.lock);
    800036c8:	8526                	mv	a0,s1
    800036ca:	00003097          	auipc	ra,0x3
    800036ce:	f66080e7          	jalr	-154(ra) # 80006630 <release>
  if(do_commit){
    800036d2:	b7c9                	j	80003694 <end_op+0x7c>
  for (tail = 0; tail < log.lh.n; tail++) {
    800036d4:	00027a97          	auipc	s5,0x27
    800036d8:	44ca8a93          	addi	s5,s5,1100 # 8002ab20 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800036dc:	00027a17          	auipc	s4,0x27
    800036e0:	414a0a13          	addi	s4,s4,1044 # 8002aaf0 <log>
    800036e4:	018a2583          	lw	a1,24(s4)
    800036e8:	012585bb          	addw	a1,a1,s2
    800036ec:	2585                	addiw	a1,a1,1
    800036ee:	028a2503          	lw	a0,40(s4)
    800036f2:	fffff097          	auipc	ra,0xfffff
    800036f6:	cca080e7          	jalr	-822(ra) # 800023bc <bread>
    800036fa:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    800036fc:	000aa583          	lw	a1,0(s5)
    80003700:	028a2503          	lw	a0,40(s4)
    80003704:	fffff097          	auipc	ra,0xfffff
    80003708:	cb8080e7          	jalr	-840(ra) # 800023bc <bread>
    8000370c:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    8000370e:	40000613          	li	a2,1024
    80003712:	05850593          	addi	a1,a0,88
    80003716:	05848513          	addi	a0,s1,88
    8000371a:	ffffd097          	auipc	ra,0xffffd
    8000371e:	abe080e7          	jalr	-1346(ra) # 800001d8 <memmove>
    bwrite(to);  // write the log
    80003722:	8526                	mv	a0,s1
    80003724:	fffff097          	auipc	ra,0xfffff
    80003728:	d8a080e7          	jalr	-630(ra) # 800024ae <bwrite>
    brelse(from);
    8000372c:	854e                	mv	a0,s3
    8000372e:	fffff097          	auipc	ra,0xfffff
    80003732:	dbe080e7          	jalr	-578(ra) # 800024ec <brelse>
    brelse(to);
    80003736:	8526                	mv	a0,s1
    80003738:	fffff097          	auipc	ra,0xfffff
    8000373c:	db4080e7          	jalr	-588(ra) # 800024ec <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003740:	2905                	addiw	s2,s2,1
    80003742:	0a91                	addi	s5,s5,4
    80003744:	02ca2783          	lw	a5,44(s4)
    80003748:	f8f94ee3          	blt	s2,a5,800036e4 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    8000374c:	00000097          	auipc	ra,0x0
    80003750:	c6a080e7          	jalr	-918(ra) # 800033b6 <write_head>
    install_trans(0); // Now install writes to home locations
    80003754:	4501                	li	a0,0
    80003756:	00000097          	auipc	ra,0x0
    8000375a:	cda080e7          	jalr	-806(ra) # 80003430 <install_trans>
    log.lh.n = 0;
    8000375e:	00027797          	auipc	a5,0x27
    80003762:	3a07af23          	sw	zero,958(a5) # 8002ab1c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003766:	00000097          	auipc	ra,0x0
    8000376a:	c50080e7          	jalr	-944(ra) # 800033b6 <write_head>
    8000376e:	bdf5                	j	8000366a <end_op+0x52>

0000000080003770 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    80003770:	1101                	addi	sp,sp,-32
    80003772:	ec06                	sd	ra,24(sp)
    80003774:	e822                	sd	s0,16(sp)
    80003776:	e426                	sd	s1,8(sp)
    80003778:	e04a                	sd	s2,0(sp)
    8000377a:	1000                	addi	s0,sp,32
    8000377c:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    8000377e:	00027917          	auipc	s2,0x27
    80003782:	37290913          	addi	s2,s2,882 # 8002aaf0 <log>
    80003786:	854a                	mv	a0,s2
    80003788:	00003097          	auipc	ra,0x3
    8000378c:	df4080e7          	jalr	-524(ra) # 8000657c <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    80003790:	02c92603          	lw	a2,44(s2)
    80003794:	47f5                	li	a5,29
    80003796:	06c7c563          	blt	a5,a2,80003800 <log_write+0x90>
    8000379a:	00027797          	auipc	a5,0x27
    8000379e:	3727a783          	lw	a5,882(a5) # 8002ab0c <log+0x1c>
    800037a2:	37fd                	addiw	a5,a5,-1
    800037a4:	04f65e63          	bge	a2,a5,80003800 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800037a8:	00027797          	auipc	a5,0x27
    800037ac:	3687a783          	lw	a5,872(a5) # 8002ab10 <log+0x20>
    800037b0:	06f05063          	blez	a5,80003810 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800037b4:	4781                	li	a5,0
    800037b6:	06c05563          	blez	a2,80003820 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800037ba:	44cc                	lw	a1,12(s1)
    800037bc:	00027717          	auipc	a4,0x27
    800037c0:	36470713          	addi	a4,a4,868 # 8002ab20 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800037c4:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800037c6:	4314                	lw	a3,0(a4)
    800037c8:	04b68c63          	beq	a3,a1,80003820 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800037cc:	2785                	addiw	a5,a5,1
    800037ce:	0711                	addi	a4,a4,4
    800037d0:	fef61be3          	bne	a2,a5,800037c6 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800037d4:	0621                	addi	a2,a2,8
    800037d6:	060a                	slli	a2,a2,0x2
    800037d8:	00027797          	auipc	a5,0x27
    800037dc:	31878793          	addi	a5,a5,792 # 8002aaf0 <log>
    800037e0:	963e                	add	a2,a2,a5
    800037e2:	44dc                	lw	a5,12(s1)
    800037e4:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    800037e6:	8526                	mv	a0,s1
    800037e8:	fffff097          	auipc	ra,0xfffff
    800037ec:	da2080e7          	jalr	-606(ra) # 8000258a <bpin>
    log.lh.n++;
    800037f0:	00027717          	auipc	a4,0x27
    800037f4:	30070713          	addi	a4,a4,768 # 8002aaf0 <log>
    800037f8:	575c                	lw	a5,44(a4)
    800037fa:	2785                	addiw	a5,a5,1
    800037fc:	d75c                	sw	a5,44(a4)
    800037fe:	a835                	j	8000383a <log_write+0xca>
    panic("too big a transaction");
    80003800:	00005517          	auipc	a0,0x5
    80003804:	df050513          	addi	a0,a0,-528 # 800085f0 <syscalls+0x200>
    80003808:	00003097          	auipc	ra,0x3
    8000380c:	82a080e7          	jalr	-2006(ra) # 80006032 <panic>
    panic("log_write outside of trans");
    80003810:	00005517          	auipc	a0,0x5
    80003814:	df850513          	addi	a0,a0,-520 # 80008608 <syscalls+0x218>
    80003818:	00003097          	auipc	ra,0x3
    8000381c:	81a080e7          	jalr	-2022(ra) # 80006032 <panic>
  log.lh.block[i] = b->blockno;
    80003820:	00878713          	addi	a4,a5,8
    80003824:	00271693          	slli	a3,a4,0x2
    80003828:	00027717          	auipc	a4,0x27
    8000382c:	2c870713          	addi	a4,a4,712 # 8002aaf0 <log>
    80003830:	9736                	add	a4,a4,a3
    80003832:	44d4                	lw	a3,12(s1)
    80003834:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003836:	faf608e3          	beq	a2,a5,800037e6 <log_write+0x76>
  }
  release(&log.lock);
    8000383a:	00027517          	auipc	a0,0x27
    8000383e:	2b650513          	addi	a0,a0,694 # 8002aaf0 <log>
    80003842:	00003097          	auipc	ra,0x3
    80003846:	dee080e7          	jalr	-530(ra) # 80006630 <release>
}
    8000384a:	60e2                	ld	ra,24(sp)
    8000384c:	6442                	ld	s0,16(sp)
    8000384e:	64a2                	ld	s1,8(sp)
    80003850:	6902                	ld	s2,0(sp)
    80003852:	6105                	addi	sp,sp,32
    80003854:	8082                	ret

0000000080003856 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003856:	1101                	addi	sp,sp,-32
    80003858:	ec06                	sd	ra,24(sp)
    8000385a:	e822                	sd	s0,16(sp)
    8000385c:	e426                	sd	s1,8(sp)
    8000385e:	e04a                	sd	s2,0(sp)
    80003860:	1000                	addi	s0,sp,32
    80003862:	84aa                	mv	s1,a0
    80003864:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003866:	00005597          	auipc	a1,0x5
    8000386a:	dc258593          	addi	a1,a1,-574 # 80008628 <syscalls+0x238>
    8000386e:	0521                	addi	a0,a0,8
    80003870:	00003097          	auipc	ra,0x3
    80003874:	c7c080e7          	jalr	-900(ra) # 800064ec <initlock>
  lk->name = name;
    80003878:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    8000387c:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003880:	0204a423          	sw	zero,40(s1)
}
    80003884:	60e2                	ld	ra,24(sp)
    80003886:	6442                	ld	s0,16(sp)
    80003888:	64a2                	ld	s1,8(sp)
    8000388a:	6902                	ld	s2,0(sp)
    8000388c:	6105                	addi	sp,sp,32
    8000388e:	8082                	ret

0000000080003890 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    80003890:	1101                	addi	sp,sp,-32
    80003892:	ec06                	sd	ra,24(sp)
    80003894:	e822                	sd	s0,16(sp)
    80003896:	e426                	sd	s1,8(sp)
    80003898:	e04a                	sd	s2,0(sp)
    8000389a:	1000                	addi	s0,sp,32
    8000389c:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000389e:	00850913          	addi	s2,a0,8
    800038a2:	854a                	mv	a0,s2
    800038a4:	00003097          	auipc	ra,0x3
    800038a8:	cd8080e7          	jalr	-808(ra) # 8000657c <acquire>
  while (lk->locked) {
    800038ac:	409c                	lw	a5,0(s1)
    800038ae:	cb89                	beqz	a5,800038c0 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800038b0:	85ca                	mv	a1,s2
    800038b2:	8526                	mv	a0,s1
    800038b4:	ffffe097          	auipc	ra,0xffffe
    800038b8:	c52080e7          	jalr	-942(ra) # 80001506 <sleep>
  while (lk->locked) {
    800038bc:	409c                	lw	a5,0(s1)
    800038be:	fbed                	bnez	a5,800038b0 <acquiresleep+0x20>
  }
  lk->locked = 1;
    800038c0:	4785                	li	a5,1
    800038c2:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800038c4:	ffffd097          	auipc	ra,0xffffd
    800038c8:	59e080e7          	jalr	1438(ra) # 80000e62 <myproc>
    800038cc:	591c                	lw	a5,48(a0)
    800038ce:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800038d0:	854a                	mv	a0,s2
    800038d2:	00003097          	auipc	ra,0x3
    800038d6:	d5e080e7          	jalr	-674(ra) # 80006630 <release>
}
    800038da:	60e2                	ld	ra,24(sp)
    800038dc:	6442                	ld	s0,16(sp)
    800038de:	64a2                	ld	s1,8(sp)
    800038e0:	6902                	ld	s2,0(sp)
    800038e2:	6105                	addi	sp,sp,32
    800038e4:	8082                	ret

00000000800038e6 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    800038e6:	1101                	addi	sp,sp,-32
    800038e8:	ec06                	sd	ra,24(sp)
    800038ea:	e822                	sd	s0,16(sp)
    800038ec:	e426                	sd	s1,8(sp)
    800038ee:	e04a                	sd	s2,0(sp)
    800038f0:	1000                	addi	s0,sp,32
    800038f2:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800038f4:	00850913          	addi	s2,a0,8
    800038f8:	854a                	mv	a0,s2
    800038fa:	00003097          	auipc	ra,0x3
    800038fe:	c82080e7          	jalr	-894(ra) # 8000657c <acquire>
  lk->locked = 0;
    80003902:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003906:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    8000390a:	8526                	mv	a0,s1
    8000390c:	ffffe097          	auipc	ra,0xffffe
    80003910:	c5e080e7          	jalr	-930(ra) # 8000156a <wakeup>
  release(&lk->lk);
    80003914:	854a                	mv	a0,s2
    80003916:	00003097          	auipc	ra,0x3
    8000391a:	d1a080e7          	jalr	-742(ra) # 80006630 <release>
}
    8000391e:	60e2                	ld	ra,24(sp)
    80003920:	6442                	ld	s0,16(sp)
    80003922:	64a2                	ld	s1,8(sp)
    80003924:	6902                	ld	s2,0(sp)
    80003926:	6105                	addi	sp,sp,32
    80003928:	8082                	ret

000000008000392a <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    8000392a:	7179                	addi	sp,sp,-48
    8000392c:	f406                	sd	ra,40(sp)
    8000392e:	f022                	sd	s0,32(sp)
    80003930:	ec26                	sd	s1,24(sp)
    80003932:	e84a                	sd	s2,16(sp)
    80003934:	e44e                	sd	s3,8(sp)
    80003936:	1800                	addi	s0,sp,48
    80003938:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    8000393a:	00850913          	addi	s2,a0,8
    8000393e:	854a                	mv	a0,s2
    80003940:	00003097          	auipc	ra,0x3
    80003944:	c3c080e7          	jalr	-964(ra) # 8000657c <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003948:	409c                	lw	a5,0(s1)
    8000394a:	ef99                	bnez	a5,80003968 <holdingsleep+0x3e>
    8000394c:	4481                	li	s1,0
  release(&lk->lk);
    8000394e:	854a                	mv	a0,s2
    80003950:	00003097          	auipc	ra,0x3
    80003954:	ce0080e7          	jalr	-800(ra) # 80006630 <release>
  return r;
}
    80003958:	8526                	mv	a0,s1
    8000395a:	70a2                	ld	ra,40(sp)
    8000395c:	7402                	ld	s0,32(sp)
    8000395e:	64e2                	ld	s1,24(sp)
    80003960:	6942                	ld	s2,16(sp)
    80003962:	69a2                	ld	s3,8(sp)
    80003964:	6145                	addi	sp,sp,48
    80003966:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003968:	0284a983          	lw	s3,40(s1)
    8000396c:	ffffd097          	auipc	ra,0xffffd
    80003970:	4f6080e7          	jalr	1270(ra) # 80000e62 <myproc>
    80003974:	5904                	lw	s1,48(a0)
    80003976:	413484b3          	sub	s1,s1,s3
    8000397a:	0014b493          	seqz	s1,s1
    8000397e:	bfc1                	j	8000394e <holdingsleep+0x24>

0000000080003980 <fileinit>:
    struct spinlock lock;
    struct file file[NFILE];
} ftable;

void fileinit(void)
{
    80003980:	1141                	addi	sp,sp,-16
    80003982:	e406                	sd	ra,8(sp)
    80003984:	e022                	sd	s0,0(sp)
    80003986:	0800                	addi	s0,sp,16
    initlock(&ftable.lock, "ftable");
    80003988:	00005597          	auipc	a1,0x5
    8000398c:	cb058593          	addi	a1,a1,-848 # 80008638 <syscalls+0x248>
    80003990:	00027517          	auipc	a0,0x27
    80003994:	2a850513          	addi	a0,a0,680 # 8002ac38 <ftable>
    80003998:	00003097          	auipc	ra,0x3
    8000399c:	b54080e7          	jalr	-1196(ra) # 800064ec <initlock>
}
    800039a0:	60a2                	ld	ra,8(sp)
    800039a2:	6402                	ld	s0,0(sp)
    800039a4:	0141                	addi	sp,sp,16
    800039a6:	8082                	ret

00000000800039a8 <filealloc>:

// Allocate a file structure.
struct file *
filealloc(void)
{
    800039a8:	1101                	addi	sp,sp,-32
    800039aa:	ec06                	sd	ra,24(sp)
    800039ac:	e822                	sd	s0,16(sp)
    800039ae:	e426                	sd	s1,8(sp)
    800039b0:	1000                	addi	s0,sp,32
    struct file *f;

    acquire(&ftable.lock);
    800039b2:	00027517          	auipc	a0,0x27
    800039b6:	28650513          	addi	a0,a0,646 # 8002ac38 <ftable>
    800039ba:	00003097          	auipc	ra,0x3
    800039be:	bc2080e7          	jalr	-1086(ra) # 8000657c <acquire>
    for (f = ftable.file; f < ftable.file + NFILE; f++)
    800039c2:	00027497          	auipc	s1,0x27
    800039c6:	28e48493          	addi	s1,s1,654 # 8002ac50 <ftable+0x18>
    800039ca:	00028717          	auipc	a4,0x28
    800039ce:	22670713          	addi	a4,a4,550 # 8002bbf0 <disk>
    {
        if (f->ref == 0)
    800039d2:	40dc                	lw	a5,4(s1)
    800039d4:	cf99                	beqz	a5,800039f2 <filealloc+0x4a>
    for (f = ftable.file; f < ftable.file + NFILE; f++)
    800039d6:	02848493          	addi	s1,s1,40
    800039da:	fee49ce3          	bne	s1,a4,800039d2 <filealloc+0x2a>
            f->ref = 1;
            release(&ftable.lock);
            return f;
        }
    }
    release(&ftable.lock);
    800039de:	00027517          	auipc	a0,0x27
    800039e2:	25a50513          	addi	a0,a0,602 # 8002ac38 <ftable>
    800039e6:	00003097          	auipc	ra,0x3
    800039ea:	c4a080e7          	jalr	-950(ra) # 80006630 <release>
    return 0;
    800039ee:	4481                	li	s1,0
    800039f0:	a819                	j	80003a06 <filealloc+0x5e>
            f->ref = 1;
    800039f2:	4785                	li	a5,1
    800039f4:	c0dc                	sw	a5,4(s1)
            release(&ftable.lock);
    800039f6:	00027517          	auipc	a0,0x27
    800039fa:	24250513          	addi	a0,a0,578 # 8002ac38 <ftable>
    800039fe:	00003097          	auipc	ra,0x3
    80003a02:	c32080e7          	jalr	-974(ra) # 80006630 <release>
}
    80003a06:	8526                	mv	a0,s1
    80003a08:	60e2                	ld	ra,24(sp)
    80003a0a:	6442                	ld	s0,16(sp)
    80003a0c:	64a2                	ld	s1,8(sp)
    80003a0e:	6105                	addi	sp,sp,32
    80003a10:	8082                	ret

0000000080003a12 <filedup>:

// Increment ref count for file f.
struct file *
filedup(struct file *f)
{
    80003a12:	1101                	addi	sp,sp,-32
    80003a14:	ec06                	sd	ra,24(sp)
    80003a16:	e822                	sd	s0,16(sp)
    80003a18:	e426                	sd	s1,8(sp)
    80003a1a:	1000                	addi	s0,sp,32
    80003a1c:	84aa                	mv	s1,a0
    acquire(&ftable.lock);
    80003a1e:	00027517          	auipc	a0,0x27
    80003a22:	21a50513          	addi	a0,a0,538 # 8002ac38 <ftable>
    80003a26:	00003097          	auipc	ra,0x3
    80003a2a:	b56080e7          	jalr	-1194(ra) # 8000657c <acquire>
    if (f->ref < 1)
    80003a2e:	40dc                	lw	a5,4(s1)
    80003a30:	02f05263          	blez	a5,80003a54 <filedup+0x42>
        panic("filedup");
    f->ref++;
    80003a34:	2785                	addiw	a5,a5,1
    80003a36:	c0dc                	sw	a5,4(s1)
    release(&ftable.lock);
    80003a38:	00027517          	auipc	a0,0x27
    80003a3c:	20050513          	addi	a0,a0,512 # 8002ac38 <ftable>
    80003a40:	00003097          	auipc	ra,0x3
    80003a44:	bf0080e7          	jalr	-1040(ra) # 80006630 <release>
    return f;
}
    80003a48:	8526                	mv	a0,s1
    80003a4a:	60e2                	ld	ra,24(sp)
    80003a4c:	6442                	ld	s0,16(sp)
    80003a4e:	64a2                	ld	s1,8(sp)
    80003a50:	6105                	addi	sp,sp,32
    80003a52:	8082                	ret
        panic("filedup");
    80003a54:	00005517          	auipc	a0,0x5
    80003a58:	bec50513          	addi	a0,a0,-1044 # 80008640 <syscalls+0x250>
    80003a5c:	00002097          	auipc	ra,0x2
    80003a60:	5d6080e7          	jalr	1494(ra) # 80006032 <panic>

0000000080003a64 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void fileclose(struct file *f)
{
    80003a64:	7139                	addi	sp,sp,-64
    80003a66:	fc06                	sd	ra,56(sp)
    80003a68:	f822                	sd	s0,48(sp)
    80003a6a:	f426                	sd	s1,40(sp)
    80003a6c:	f04a                	sd	s2,32(sp)
    80003a6e:	ec4e                	sd	s3,24(sp)
    80003a70:	e852                	sd	s4,16(sp)
    80003a72:	e456                	sd	s5,8(sp)
    80003a74:	0080                	addi	s0,sp,64
    80003a76:	84aa                	mv	s1,a0
    struct file ff;

    acquire(&ftable.lock);
    80003a78:	00027517          	auipc	a0,0x27
    80003a7c:	1c050513          	addi	a0,a0,448 # 8002ac38 <ftable>
    80003a80:	00003097          	auipc	ra,0x3
    80003a84:	afc080e7          	jalr	-1284(ra) # 8000657c <acquire>
    if (f->ref < 1)
    80003a88:	40dc                	lw	a5,4(s1)
    80003a8a:	06f05163          	blez	a5,80003aec <fileclose+0x88>
        panic("fileclose");
    if (--f->ref > 0)
    80003a8e:	37fd                	addiw	a5,a5,-1
    80003a90:	0007871b          	sext.w	a4,a5
    80003a94:	c0dc                	sw	a5,4(s1)
    80003a96:	06e04363          	bgtz	a4,80003afc <fileclose+0x98>
    {
        release(&ftable.lock);
        return;
    }
    ff = *f;
    80003a9a:	0004a903          	lw	s2,0(s1)
    80003a9e:	0094ca83          	lbu	s5,9(s1)
    80003aa2:	0104ba03          	ld	s4,16(s1)
    80003aa6:	0184b983          	ld	s3,24(s1)
    f->ref = 0;
    80003aaa:	0004a223          	sw	zero,4(s1)
    f->type = FD_NONE;
    80003aae:	0004a023          	sw	zero,0(s1)
    release(&ftable.lock);
    80003ab2:	00027517          	auipc	a0,0x27
    80003ab6:	18650513          	addi	a0,a0,390 # 8002ac38 <ftable>
    80003aba:	00003097          	auipc	ra,0x3
    80003abe:	b76080e7          	jalr	-1162(ra) # 80006630 <release>

    if (ff.type == FD_PIPE)
    80003ac2:	4785                	li	a5,1
    80003ac4:	04f90d63          	beq	s2,a5,80003b1e <fileclose+0xba>
    {
        pipeclose(ff.pipe, ff.writable);
    }
    else if (ff.type == FD_INODE || ff.type == FD_DEVICE)
    80003ac8:	3979                	addiw	s2,s2,-2
    80003aca:	4785                	li	a5,1
    80003acc:	0527e063          	bltu	a5,s2,80003b0c <fileclose+0xa8>
    {
        begin_op();
    80003ad0:	00000097          	auipc	ra,0x0
    80003ad4:	ac8080e7          	jalr	-1336(ra) # 80003598 <begin_op>
        iput(ff.ip);
    80003ad8:	854e                	mv	a0,s3
    80003ada:	fffff097          	auipc	ra,0xfffff
    80003ade:	2b6080e7          	jalr	694(ra) # 80002d90 <iput>
        end_op();
    80003ae2:	00000097          	auipc	ra,0x0
    80003ae6:	b36080e7          	jalr	-1226(ra) # 80003618 <end_op>
    80003aea:	a00d                	j	80003b0c <fileclose+0xa8>
        panic("fileclose");
    80003aec:	00005517          	auipc	a0,0x5
    80003af0:	b5c50513          	addi	a0,a0,-1188 # 80008648 <syscalls+0x258>
    80003af4:	00002097          	auipc	ra,0x2
    80003af8:	53e080e7          	jalr	1342(ra) # 80006032 <panic>
        release(&ftable.lock);
    80003afc:	00027517          	auipc	a0,0x27
    80003b00:	13c50513          	addi	a0,a0,316 # 8002ac38 <ftable>
    80003b04:	00003097          	auipc	ra,0x3
    80003b08:	b2c080e7          	jalr	-1236(ra) # 80006630 <release>
    }
}
    80003b0c:	70e2                	ld	ra,56(sp)
    80003b0e:	7442                	ld	s0,48(sp)
    80003b10:	74a2                	ld	s1,40(sp)
    80003b12:	7902                	ld	s2,32(sp)
    80003b14:	69e2                	ld	s3,24(sp)
    80003b16:	6a42                	ld	s4,16(sp)
    80003b18:	6aa2                	ld	s5,8(sp)
    80003b1a:	6121                	addi	sp,sp,64
    80003b1c:	8082                	ret
        pipeclose(ff.pipe, ff.writable);
    80003b1e:	85d6                	mv	a1,s5
    80003b20:	8552                	mv	a0,s4
    80003b22:	00000097          	auipc	ra,0x0
    80003b26:	3a6080e7          	jalr	934(ra) # 80003ec8 <pipeclose>
    80003b2a:	b7cd                	j	80003b0c <fileclose+0xa8>

0000000080003b2c <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int filestat(struct file *f, uint64 addr)
{
    80003b2c:	715d                	addi	sp,sp,-80
    80003b2e:	e486                	sd	ra,72(sp)
    80003b30:	e0a2                	sd	s0,64(sp)
    80003b32:	fc26                	sd	s1,56(sp)
    80003b34:	f84a                	sd	s2,48(sp)
    80003b36:	f44e                	sd	s3,40(sp)
    80003b38:	0880                	addi	s0,sp,80
    80003b3a:	84aa                	mv	s1,a0
    80003b3c:	89ae                	mv	s3,a1
    struct proc *p = myproc();
    80003b3e:	ffffd097          	auipc	ra,0xffffd
    80003b42:	324080e7          	jalr	804(ra) # 80000e62 <myproc>
    struct stat st;

    if (f->type == FD_INODE || f->type == FD_DEVICE)
    80003b46:	409c                	lw	a5,0(s1)
    80003b48:	37f9                	addiw	a5,a5,-2
    80003b4a:	4705                	li	a4,1
    80003b4c:	04f76763          	bltu	a4,a5,80003b9a <filestat+0x6e>
    80003b50:	892a                	mv	s2,a0
    {
        ilock(f->ip);
    80003b52:	6c88                	ld	a0,24(s1)
    80003b54:	fffff097          	auipc	ra,0xfffff
    80003b58:	082080e7          	jalr	130(ra) # 80002bd6 <ilock>
        stati(f->ip, &st);
    80003b5c:	fb840593          	addi	a1,s0,-72
    80003b60:	6c88                	ld	a0,24(s1)
    80003b62:	fffff097          	auipc	ra,0xfffff
    80003b66:	2fe080e7          	jalr	766(ra) # 80002e60 <stati>
        iunlock(f->ip);
    80003b6a:	6c88                	ld	a0,24(s1)
    80003b6c:	fffff097          	auipc	ra,0xfffff
    80003b70:	12c080e7          	jalr	300(ra) # 80002c98 <iunlock>
        if (copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003b74:	46e1                	li	a3,24
    80003b76:	fb840613          	addi	a2,s0,-72
    80003b7a:	85ce                	mv	a1,s3
    80003b7c:	05093503          	ld	a0,80(s2)
    80003b80:	ffffd097          	auipc	ra,0xffffd
    80003b84:	fa0080e7          	jalr	-96(ra) # 80000b20 <copyout>
    80003b88:	41f5551b          	sraiw	a0,a0,0x1f
            return -1;
        return 0;
    }
    return -1;
}
    80003b8c:	60a6                	ld	ra,72(sp)
    80003b8e:	6406                	ld	s0,64(sp)
    80003b90:	74e2                	ld	s1,56(sp)
    80003b92:	7942                	ld	s2,48(sp)
    80003b94:	79a2                	ld	s3,40(sp)
    80003b96:	6161                	addi	sp,sp,80
    80003b98:	8082                	ret
    return -1;
    80003b9a:	557d                	li	a0,-1
    80003b9c:	bfc5                	j	80003b8c <filestat+0x60>

0000000080003b9e <mapfile>:

void mapfile(struct file *f, char *mem, int offset)
{
    80003b9e:	7179                	addi	sp,sp,-48
    80003ba0:	f406                	sd	ra,40(sp)
    80003ba2:	f022                	sd	s0,32(sp)
    80003ba4:	ec26                	sd	s1,24(sp)
    80003ba6:	e84a                	sd	s2,16(sp)
    80003ba8:	e44e                	sd	s3,8(sp)
    80003baa:	1800                	addi	s0,sp,48
    80003bac:	84aa                	mv	s1,a0
    80003bae:	89ae                	mv	s3,a1
    80003bb0:	8932                	mv	s2,a2
    printf("off %d\n", offset);
    80003bb2:	85b2                	mv	a1,a2
    80003bb4:	00005517          	auipc	a0,0x5
    80003bb8:	aa450513          	addi	a0,a0,-1372 # 80008658 <syscalls+0x268>
    80003bbc:	00002097          	auipc	ra,0x2
    80003bc0:	4c0080e7          	jalr	1216(ra) # 8000607c <printf>
    ilock(f->ip);
    80003bc4:	6c88                	ld	a0,24(s1)
    80003bc6:	fffff097          	auipc	ra,0xfffff
    80003bca:	010080e7          	jalr	16(ra) # 80002bd6 <ilock>
    // printf("[Testing] (mapfile) : finish ilock\n");
    readi(f->ip, 0, (uint64)mem, offset, PGSIZE);
    80003bce:	6705                	lui	a4,0x1
    80003bd0:	86ca                	mv	a3,s2
    80003bd2:	864e                	mv	a2,s3
    80003bd4:	4581                	li	a1,0
    80003bd6:	6c88                	ld	a0,24(s1)
    80003bd8:	fffff097          	auipc	ra,0xfffff
    80003bdc:	2b2080e7          	jalr	690(ra) # 80002e8a <readi>
    // printf("[Testing] (mapfile) : finish readi\n");
    iunlock(f->ip);
    80003be0:	6c88                	ld	a0,24(s1)
    80003be2:	fffff097          	auipc	ra,0xfffff
    80003be6:	0b6080e7          	jalr	182(ra) # 80002c98 <iunlock>
    // printf("[Testing] (mapfile) : finish iunlock\n");
}
    80003bea:	70a2                	ld	ra,40(sp)
    80003bec:	7402                	ld	s0,32(sp)
    80003bee:	64e2                	ld	s1,24(sp)
    80003bf0:	6942                	ld	s2,16(sp)
    80003bf2:	69a2                	ld	s3,8(sp)
    80003bf4:	6145                	addi	sp,sp,48
    80003bf6:	8082                	ret

0000000080003bf8 <fileread>:

// Read from file f.
// addr is a user virtual address.
int fileread(struct file *f, uint64 addr, int n)
{
    80003bf8:	7179                	addi	sp,sp,-48
    80003bfa:	f406                	sd	ra,40(sp)
    80003bfc:	f022                	sd	s0,32(sp)
    80003bfe:	ec26                	sd	s1,24(sp)
    80003c00:	e84a                	sd	s2,16(sp)
    80003c02:	e44e                	sd	s3,8(sp)
    80003c04:	1800                	addi	s0,sp,48
    int r = 0;

    if (f->readable == 0)
    80003c06:	00854783          	lbu	a5,8(a0)
    80003c0a:	c3d5                	beqz	a5,80003cae <fileread+0xb6>
    80003c0c:	84aa                	mv	s1,a0
    80003c0e:	89ae                	mv	s3,a1
    80003c10:	8932                	mv	s2,a2
        return -1;

    if (f->type == FD_PIPE)
    80003c12:	411c                	lw	a5,0(a0)
    80003c14:	4705                	li	a4,1
    80003c16:	04e78963          	beq	a5,a4,80003c68 <fileread+0x70>
    {
        r = piperead(f->pipe, addr, n);
    }
    else if (f->type == FD_DEVICE)
    80003c1a:	470d                	li	a4,3
    80003c1c:	04e78d63          	beq	a5,a4,80003c76 <fileread+0x7e>
    {
        if (f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
            return -1;
        r = devsw[f->major].read(1, addr, n);
    }
    else if (f->type == FD_INODE)
    80003c20:	4709                	li	a4,2
    80003c22:	06e79e63          	bne	a5,a4,80003c9e <fileread+0xa6>
    {
        ilock(f->ip);
    80003c26:	6d08                	ld	a0,24(a0)
    80003c28:	fffff097          	auipc	ra,0xfffff
    80003c2c:	fae080e7          	jalr	-82(ra) # 80002bd6 <ilock>
        if ((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003c30:	874a                	mv	a4,s2
    80003c32:	5094                	lw	a3,32(s1)
    80003c34:	864e                	mv	a2,s3
    80003c36:	4585                	li	a1,1
    80003c38:	6c88                	ld	a0,24(s1)
    80003c3a:	fffff097          	auipc	ra,0xfffff
    80003c3e:	250080e7          	jalr	592(ra) # 80002e8a <readi>
    80003c42:	892a                	mv	s2,a0
    80003c44:	00a05563          	blez	a0,80003c4e <fileread+0x56>
            f->off += r;
    80003c48:	509c                	lw	a5,32(s1)
    80003c4a:	9fa9                	addw	a5,a5,a0
    80003c4c:	d09c                	sw	a5,32(s1)
        iunlock(f->ip);
    80003c4e:	6c88                	ld	a0,24(s1)
    80003c50:	fffff097          	auipc	ra,0xfffff
    80003c54:	048080e7          	jalr	72(ra) # 80002c98 <iunlock>
    {
        panic("fileread");
    }

    return r;
}
    80003c58:	854a                	mv	a0,s2
    80003c5a:	70a2                	ld	ra,40(sp)
    80003c5c:	7402                	ld	s0,32(sp)
    80003c5e:	64e2                	ld	s1,24(sp)
    80003c60:	6942                	ld	s2,16(sp)
    80003c62:	69a2                	ld	s3,8(sp)
    80003c64:	6145                	addi	sp,sp,48
    80003c66:	8082                	ret
        r = piperead(f->pipe, addr, n);
    80003c68:	6908                	ld	a0,16(a0)
    80003c6a:	00000097          	auipc	ra,0x0
    80003c6e:	3ce080e7          	jalr	974(ra) # 80004038 <piperead>
    80003c72:	892a                	mv	s2,a0
    80003c74:	b7d5                	j	80003c58 <fileread+0x60>
        if (f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003c76:	02451783          	lh	a5,36(a0)
    80003c7a:	03079693          	slli	a3,a5,0x30
    80003c7e:	92c1                	srli	a3,a3,0x30
    80003c80:	4725                	li	a4,9
    80003c82:	02d76863          	bltu	a4,a3,80003cb2 <fileread+0xba>
    80003c86:	0792                	slli	a5,a5,0x4
    80003c88:	00027717          	auipc	a4,0x27
    80003c8c:	f1070713          	addi	a4,a4,-240 # 8002ab98 <devsw>
    80003c90:	97ba                	add	a5,a5,a4
    80003c92:	639c                	ld	a5,0(a5)
    80003c94:	c38d                	beqz	a5,80003cb6 <fileread+0xbe>
        r = devsw[f->major].read(1, addr, n);
    80003c96:	4505                	li	a0,1
    80003c98:	9782                	jalr	a5
    80003c9a:	892a                	mv	s2,a0
    80003c9c:	bf75                	j	80003c58 <fileread+0x60>
        panic("fileread");
    80003c9e:	00005517          	auipc	a0,0x5
    80003ca2:	9c250513          	addi	a0,a0,-1598 # 80008660 <syscalls+0x270>
    80003ca6:	00002097          	auipc	ra,0x2
    80003caa:	38c080e7          	jalr	908(ra) # 80006032 <panic>
        return -1;
    80003cae:	597d                	li	s2,-1
    80003cb0:	b765                	j	80003c58 <fileread+0x60>
            return -1;
    80003cb2:	597d                	li	s2,-1
    80003cb4:	b755                	j	80003c58 <fileread+0x60>
    80003cb6:	597d                	li	s2,-1
    80003cb8:	b745                	j	80003c58 <fileread+0x60>

0000000080003cba <filewrite>:

// Write to file f.
// addr is a user virtual address.
int filewrite(struct file *f, uint64 addr, int n)
{
    80003cba:	715d                	addi	sp,sp,-80
    80003cbc:	e486                	sd	ra,72(sp)
    80003cbe:	e0a2                	sd	s0,64(sp)
    80003cc0:	fc26                	sd	s1,56(sp)
    80003cc2:	f84a                	sd	s2,48(sp)
    80003cc4:	f44e                	sd	s3,40(sp)
    80003cc6:	f052                	sd	s4,32(sp)
    80003cc8:	ec56                	sd	s5,24(sp)
    80003cca:	e85a                	sd	s6,16(sp)
    80003ccc:	e45e                	sd	s7,8(sp)
    80003cce:	e062                	sd	s8,0(sp)
    80003cd0:	0880                	addi	s0,sp,80
    int r, ret = 0;

    if (f->writable == 0)
    80003cd2:	00954783          	lbu	a5,9(a0)
    80003cd6:	10078663          	beqz	a5,80003de2 <filewrite+0x128>
    80003cda:	892a                	mv	s2,a0
    80003cdc:	8aae                	mv	s5,a1
    80003cde:	8a32                	mv	s4,a2
        return -1;

    if (f->type == FD_PIPE)
    80003ce0:	411c                	lw	a5,0(a0)
    80003ce2:	4705                	li	a4,1
    80003ce4:	02e78263          	beq	a5,a4,80003d08 <filewrite+0x4e>
    {
        ret = pipewrite(f->pipe, addr, n);
    }
    else if (f->type == FD_DEVICE)
    80003ce8:	470d                	li	a4,3
    80003cea:	02e78663          	beq	a5,a4,80003d16 <filewrite+0x5c>
    {
        if (f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
            return -1;
        ret = devsw[f->major].write(1, addr, n);
    }
    else if (f->type == FD_INODE)
    80003cee:	4709                	li	a4,2
    80003cf0:	0ee79163          	bne	a5,a4,80003dd2 <filewrite+0x118>
        // and 2 blocks of slop for non-aligned writes.
        // this really belongs lower down, since writei()
        // might be writing a device like the console.
        int max = ((MAXOPBLOCKS - 1 - 1 - 2) / 2) * BSIZE;
        int i = 0;
        while (i < n)
    80003cf4:	0ac05d63          	blez	a2,80003dae <filewrite+0xf4>
        int i = 0;
    80003cf8:	4981                	li	s3,0
    80003cfa:	6b05                	lui	s6,0x1
    80003cfc:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003d00:	6b85                	lui	s7,0x1
    80003d02:	c00b8b9b          	addiw	s7,s7,-1024
    80003d06:	a861                	j	80003d9e <filewrite+0xe4>
        ret = pipewrite(f->pipe, addr, n);
    80003d08:	6908                	ld	a0,16(a0)
    80003d0a:	00000097          	auipc	ra,0x0
    80003d0e:	22e080e7          	jalr	558(ra) # 80003f38 <pipewrite>
    80003d12:	8a2a                	mv	s4,a0
    80003d14:	a045                	j	80003db4 <filewrite+0xfa>
        if (f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003d16:	02451783          	lh	a5,36(a0)
    80003d1a:	03079693          	slli	a3,a5,0x30
    80003d1e:	92c1                	srli	a3,a3,0x30
    80003d20:	4725                	li	a4,9
    80003d22:	0cd76263          	bltu	a4,a3,80003de6 <filewrite+0x12c>
    80003d26:	0792                	slli	a5,a5,0x4
    80003d28:	00027717          	auipc	a4,0x27
    80003d2c:	e7070713          	addi	a4,a4,-400 # 8002ab98 <devsw>
    80003d30:	97ba                	add	a5,a5,a4
    80003d32:	679c                	ld	a5,8(a5)
    80003d34:	cbdd                	beqz	a5,80003dea <filewrite+0x130>
        ret = devsw[f->major].write(1, addr, n);
    80003d36:	4505                	li	a0,1
    80003d38:	9782                	jalr	a5
    80003d3a:	8a2a                	mv	s4,a0
    80003d3c:	a8a5                	j	80003db4 <filewrite+0xfa>
    80003d3e:	00048c1b          	sext.w	s8,s1
        {
            int n1 = n - i;
            if (n1 > max)
                n1 = max;

            begin_op();
    80003d42:	00000097          	auipc	ra,0x0
    80003d46:	856080e7          	jalr	-1962(ra) # 80003598 <begin_op>
            ilock(f->ip);
    80003d4a:	01893503          	ld	a0,24(s2)
    80003d4e:	fffff097          	auipc	ra,0xfffff
    80003d52:	e88080e7          	jalr	-376(ra) # 80002bd6 <ilock>
            if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003d56:	8762                	mv	a4,s8
    80003d58:	02092683          	lw	a3,32(s2)
    80003d5c:	01598633          	add	a2,s3,s5
    80003d60:	4585                	li	a1,1
    80003d62:	01893503          	ld	a0,24(s2)
    80003d66:	fffff097          	auipc	ra,0xfffff
    80003d6a:	21c080e7          	jalr	540(ra) # 80002f82 <writei>
    80003d6e:	84aa                	mv	s1,a0
    80003d70:	00a05763          	blez	a0,80003d7e <filewrite+0xc4>
                f->off += r;
    80003d74:	02092783          	lw	a5,32(s2)
    80003d78:	9fa9                	addw	a5,a5,a0
    80003d7a:	02f92023          	sw	a5,32(s2)
            iunlock(f->ip);
    80003d7e:	01893503          	ld	a0,24(s2)
    80003d82:	fffff097          	auipc	ra,0xfffff
    80003d86:	f16080e7          	jalr	-234(ra) # 80002c98 <iunlock>
            end_op();
    80003d8a:	00000097          	auipc	ra,0x0
    80003d8e:	88e080e7          	jalr	-1906(ra) # 80003618 <end_op>

            if (r != n1)
    80003d92:	009c1f63          	bne	s8,s1,80003db0 <filewrite+0xf6>
            {
                // error from writei
                break;
            }
            i += r;
    80003d96:	013489bb          	addw	s3,s1,s3
        while (i < n)
    80003d9a:	0149db63          	bge	s3,s4,80003db0 <filewrite+0xf6>
            int n1 = n - i;
    80003d9e:	413a07bb          	subw	a5,s4,s3
            if (n1 > max)
    80003da2:	84be                	mv	s1,a5
    80003da4:	2781                	sext.w	a5,a5
    80003da6:	f8fb5ce3          	bge	s6,a5,80003d3e <filewrite+0x84>
    80003daa:	84de                	mv	s1,s7
    80003dac:	bf49                	j	80003d3e <filewrite+0x84>
        int i = 0;
    80003dae:	4981                	li	s3,0
        }
        ret = (i == n ? n : -1);
    80003db0:	013a1f63          	bne	s4,s3,80003dce <filewrite+0x114>
    {
        panic("filewrite");
    }

    return ret;
}
    80003db4:	8552                	mv	a0,s4
    80003db6:	60a6                	ld	ra,72(sp)
    80003db8:	6406                	ld	s0,64(sp)
    80003dba:	74e2                	ld	s1,56(sp)
    80003dbc:	7942                	ld	s2,48(sp)
    80003dbe:	79a2                	ld	s3,40(sp)
    80003dc0:	7a02                	ld	s4,32(sp)
    80003dc2:	6ae2                	ld	s5,24(sp)
    80003dc4:	6b42                	ld	s6,16(sp)
    80003dc6:	6ba2                	ld	s7,8(sp)
    80003dc8:	6c02                	ld	s8,0(sp)
    80003dca:	6161                	addi	sp,sp,80
    80003dcc:	8082                	ret
        ret = (i == n ? n : -1);
    80003dce:	5a7d                	li	s4,-1
    80003dd0:	b7d5                	j	80003db4 <filewrite+0xfa>
        panic("filewrite");
    80003dd2:	00005517          	auipc	a0,0x5
    80003dd6:	89e50513          	addi	a0,a0,-1890 # 80008670 <syscalls+0x280>
    80003dda:	00002097          	auipc	ra,0x2
    80003dde:	258080e7          	jalr	600(ra) # 80006032 <panic>
        return -1;
    80003de2:	5a7d                	li	s4,-1
    80003de4:	bfc1                	j	80003db4 <filewrite+0xfa>
            return -1;
    80003de6:	5a7d                	li	s4,-1
    80003de8:	b7f1                	j	80003db4 <filewrite+0xfa>
    80003dea:	5a7d                	li	s4,-1
    80003dec:	b7e1                	j	80003db4 <filewrite+0xfa>

0000000080003dee <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003dee:	7179                	addi	sp,sp,-48
    80003df0:	f406                	sd	ra,40(sp)
    80003df2:	f022                	sd	s0,32(sp)
    80003df4:	ec26                	sd	s1,24(sp)
    80003df6:	e84a                	sd	s2,16(sp)
    80003df8:	e44e                	sd	s3,8(sp)
    80003dfa:	e052                	sd	s4,0(sp)
    80003dfc:	1800                	addi	s0,sp,48
    80003dfe:	84aa                	mv	s1,a0
    80003e00:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003e02:	0005b023          	sd	zero,0(a1)
    80003e06:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003e0a:	00000097          	auipc	ra,0x0
    80003e0e:	b9e080e7          	jalr	-1122(ra) # 800039a8 <filealloc>
    80003e12:	e088                	sd	a0,0(s1)
    80003e14:	c551                	beqz	a0,80003ea0 <pipealloc+0xb2>
    80003e16:	00000097          	auipc	ra,0x0
    80003e1a:	b92080e7          	jalr	-1134(ra) # 800039a8 <filealloc>
    80003e1e:	00aa3023          	sd	a0,0(s4)
    80003e22:	c92d                	beqz	a0,80003e94 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003e24:	ffffc097          	auipc	ra,0xffffc
    80003e28:	2f4080e7          	jalr	756(ra) # 80000118 <kalloc>
    80003e2c:	892a                	mv	s2,a0
    80003e2e:	c125                	beqz	a0,80003e8e <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003e30:	4985                	li	s3,1
    80003e32:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003e36:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003e3a:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003e3e:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003e42:	00005597          	auipc	a1,0x5
    80003e46:	83e58593          	addi	a1,a1,-1986 # 80008680 <syscalls+0x290>
    80003e4a:	00002097          	auipc	ra,0x2
    80003e4e:	6a2080e7          	jalr	1698(ra) # 800064ec <initlock>
  (*f0)->type = FD_PIPE;
    80003e52:	609c                	ld	a5,0(s1)
    80003e54:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003e58:	609c                	ld	a5,0(s1)
    80003e5a:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003e5e:	609c                	ld	a5,0(s1)
    80003e60:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003e64:	609c                	ld	a5,0(s1)
    80003e66:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003e6a:	000a3783          	ld	a5,0(s4)
    80003e6e:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003e72:	000a3783          	ld	a5,0(s4)
    80003e76:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003e7a:	000a3783          	ld	a5,0(s4)
    80003e7e:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003e82:	000a3783          	ld	a5,0(s4)
    80003e86:	0127b823          	sd	s2,16(a5)
  return 0;
    80003e8a:	4501                	li	a0,0
    80003e8c:	a025                	j	80003eb4 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003e8e:	6088                	ld	a0,0(s1)
    80003e90:	e501                	bnez	a0,80003e98 <pipealloc+0xaa>
    80003e92:	a039                	j	80003ea0 <pipealloc+0xb2>
    80003e94:	6088                	ld	a0,0(s1)
    80003e96:	c51d                	beqz	a0,80003ec4 <pipealloc+0xd6>
    fileclose(*f0);
    80003e98:	00000097          	auipc	ra,0x0
    80003e9c:	bcc080e7          	jalr	-1076(ra) # 80003a64 <fileclose>
  if(*f1)
    80003ea0:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003ea4:	557d                	li	a0,-1
  if(*f1)
    80003ea6:	c799                	beqz	a5,80003eb4 <pipealloc+0xc6>
    fileclose(*f1);
    80003ea8:	853e                	mv	a0,a5
    80003eaa:	00000097          	auipc	ra,0x0
    80003eae:	bba080e7          	jalr	-1094(ra) # 80003a64 <fileclose>
  return -1;
    80003eb2:	557d                	li	a0,-1
}
    80003eb4:	70a2                	ld	ra,40(sp)
    80003eb6:	7402                	ld	s0,32(sp)
    80003eb8:	64e2                	ld	s1,24(sp)
    80003eba:	6942                	ld	s2,16(sp)
    80003ebc:	69a2                	ld	s3,8(sp)
    80003ebe:	6a02                	ld	s4,0(sp)
    80003ec0:	6145                	addi	sp,sp,48
    80003ec2:	8082                	ret
  return -1;
    80003ec4:	557d                	li	a0,-1
    80003ec6:	b7fd                	j	80003eb4 <pipealloc+0xc6>

0000000080003ec8 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003ec8:	1101                	addi	sp,sp,-32
    80003eca:	ec06                	sd	ra,24(sp)
    80003ecc:	e822                	sd	s0,16(sp)
    80003ece:	e426                	sd	s1,8(sp)
    80003ed0:	e04a                	sd	s2,0(sp)
    80003ed2:	1000                	addi	s0,sp,32
    80003ed4:	84aa                	mv	s1,a0
    80003ed6:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003ed8:	00002097          	auipc	ra,0x2
    80003edc:	6a4080e7          	jalr	1700(ra) # 8000657c <acquire>
  if(writable){
    80003ee0:	02090d63          	beqz	s2,80003f1a <pipeclose+0x52>
    pi->writeopen = 0;
    80003ee4:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003ee8:	21848513          	addi	a0,s1,536
    80003eec:	ffffd097          	auipc	ra,0xffffd
    80003ef0:	67e080e7          	jalr	1662(ra) # 8000156a <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003ef4:	2204b783          	ld	a5,544(s1)
    80003ef8:	eb95                	bnez	a5,80003f2c <pipeclose+0x64>
    release(&pi->lock);
    80003efa:	8526                	mv	a0,s1
    80003efc:	00002097          	auipc	ra,0x2
    80003f00:	734080e7          	jalr	1844(ra) # 80006630 <release>
    kfree((char*)pi);
    80003f04:	8526                	mv	a0,s1
    80003f06:	ffffc097          	auipc	ra,0xffffc
    80003f0a:	116080e7          	jalr	278(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003f0e:	60e2                	ld	ra,24(sp)
    80003f10:	6442                	ld	s0,16(sp)
    80003f12:	64a2                	ld	s1,8(sp)
    80003f14:	6902                	ld	s2,0(sp)
    80003f16:	6105                	addi	sp,sp,32
    80003f18:	8082                	ret
    pi->readopen = 0;
    80003f1a:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003f1e:	21c48513          	addi	a0,s1,540
    80003f22:	ffffd097          	auipc	ra,0xffffd
    80003f26:	648080e7          	jalr	1608(ra) # 8000156a <wakeup>
    80003f2a:	b7e9                	j	80003ef4 <pipeclose+0x2c>
    release(&pi->lock);
    80003f2c:	8526                	mv	a0,s1
    80003f2e:	00002097          	auipc	ra,0x2
    80003f32:	702080e7          	jalr	1794(ra) # 80006630 <release>
}
    80003f36:	bfe1                	j	80003f0e <pipeclose+0x46>

0000000080003f38 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003f38:	7159                	addi	sp,sp,-112
    80003f3a:	f486                	sd	ra,104(sp)
    80003f3c:	f0a2                	sd	s0,96(sp)
    80003f3e:	eca6                	sd	s1,88(sp)
    80003f40:	e8ca                	sd	s2,80(sp)
    80003f42:	e4ce                	sd	s3,72(sp)
    80003f44:	e0d2                	sd	s4,64(sp)
    80003f46:	fc56                	sd	s5,56(sp)
    80003f48:	f85a                	sd	s6,48(sp)
    80003f4a:	f45e                	sd	s7,40(sp)
    80003f4c:	f062                	sd	s8,32(sp)
    80003f4e:	ec66                	sd	s9,24(sp)
    80003f50:	1880                	addi	s0,sp,112
    80003f52:	84aa                	mv	s1,a0
    80003f54:	8aae                	mv	s5,a1
    80003f56:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003f58:	ffffd097          	auipc	ra,0xffffd
    80003f5c:	f0a080e7          	jalr	-246(ra) # 80000e62 <myproc>
    80003f60:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003f62:	8526                	mv	a0,s1
    80003f64:	00002097          	auipc	ra,0x2
    80003f68:	618080e7          	jalr	1560(ra) # 8000657c <acquire>
  while(i < n){
    80003f6c:	0d405463          	blez	s4,80004034 <pipewrite+0xfc>
    80003f70:	8ba6                	mv	s7,s1
  int i = 0;
    80003f72:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003f74:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003f76:	21848c93          	addi	s9,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003f7a:	21c48c13          	addi	s8,s1,540
    80003f7e:	a08d                	j	80003fe0 <pipewrite+0xa8>
      release(&pi->lock);
    80003f80:	8526                	mv	a0,s1
    80003f82:	00002097          	auipc	ra,0x2
    80003f86:	6ae080e7          	jalr	1710(ra) # 80006630 <release>
      return -1;
    80003f8a:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003f8c:	854a                	mv	a0,s2
    80003f8e:	70a6                	ld	ra,104(sp)
    80003f90:	7406                	ld	s0,96(sp)
    80003f92:	64e6                	ld	s1,88(sp)
    80003f94:	6946                	ld	s2,80(sp)
    80003f96:	69a6                	ld	s3,72(sp)
    80003f98:	6a06                	ld	s4,64(sp)
    80003f9a:	7ae2                	ld	s5,56(sp)
    80003f9c:	7b42                	ld	s6,48(sp)
    80003f9e:	7ba2                	ld	s7,40(sp)
    80003fa0:	7c02                	ld	s8,32(sp)
    80003fa2:	6ce2                	ld	s9,24(sp)
    80003fa4:	6165                	addi	sp,sp,112
    80003fa6:	8082                	ret
      wakeup(&pi->nread);
    80003fa8:	8566                	mv	a0,s9
    80003faa:	ffffd097          	auipc	ra,0xffffd
    80003fae:	5c0080e7          	jalr	1472(ra) # 8000156a <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003fb2:	85de                	mv	a1,s7
    80003fb4:	8562                	mv	a0,s8
    80003fb6:	ffffd097          	auipc	ra,0xffffd
    80003fba:	550080e7          	jalr	1360(ra) # 80001506 <sleep>
    80003fbe:	a839                	j	80003fdc <pipewrite+0xa4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003fc0:	21c4a783          	lw	a5,540(s1)
    80003fc4:	0017871b          	addiw	a4,a5,1
    80003fc8:	20e4ae23          	sw	a4,540(s1)
    80003fcc:	1ff7f793          	andi	a5,a5,511
    80003fd0:	97a6                	add	a5,a5,s1
    80003fd2:	f9f44703          	lbu	a4,-97(s0)
    80003fd6:	00e78c23          	sb	a4,24(a5)
      i++;
    80003fda:	2905                	addiw	s2,s2,1
  while(i < n){
    80003fdc:	05495063          	bge	s2,s4,8000401c <pipewrite+0xe4>
    if(pi->readopen == 0 || killed(pr)){
    80003fe0:	2204a783          	lw	a5,544(s1)
    80003fe4:	dfd1                	beqz	a5,80003f80 <pipewrite+0x48>
    80003fe6:	854e                	mv	a0,s3
    80003fe8:	ffffd097          	auipc	ra,0xffffd
    80003fec:	7c6080e7          	jalr	1990(ra) # 800017ae <killed>
    80003ff0:	f941                	bnez	a0,80003f80 <pipewrite+0x48>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80003ff2:	2184a783          	lw	a5,536(s1)
    80003ff6:	21c4a703          	lw	a4,540(s1)
    80003ffa:	2007879b          	addiw	a5,a5,512
    80003ffe:	faf705e3          	beq	a4,a5,80003fa8 <pipewrite+0x70>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004002:	4685                	li	a3,1
    80004004:	01590633          	add	a2,s2,s5
    80004008:	f9f40593          	addi	a1,s0,-97
    8000400c:	0509b503          	ld	a0,80(s3)
    80004010:	ffffd097          	auipc	ra,0xffffd
    80004014:	b9c080e7          	jalr	-1124(ra) # 80000bac <copyin>
    80004018:	fb6514e3          	bne	a0,s6,80003fc0 <pipewrite+0x88>
  wakeup(&pi->nread);
    8000401c:	21848513          	addi	a0,s1,536
    80004020:	ffffd097          	auipc	ra,0xffffd
    80004024:	54a080e7          	jalr	1354(ra) # 8000156a <wakeup>
  release(&pi->lock);
    80004028:	8526                	mv	a0,s1
    8000402a:	00002097          	auipc	ra,0x2
    8000402e:	606080e7          	jalr	1542(ra) # 80006630 <release>
  return i;
    80004032:	bfa9                	j	80003f8c <pipewrite+0x54>
  int i = 0;
    80004034:	4901                	li	s2,0
    80004036:	b7dd                	j	8000401c <pipewrite+0xe4>

0000000080004038 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004038:	715d                	addi	sp,sp,-80
    8000403a:	e486                	sd	ra,72(sp)
    8000403c:	e0a2                	sd	s0,64(sp)
    8000403e:	fc26                	sd	s1,56(sp)
    80004040:	f84a                	sd	s2,48(sp)
    80004042:	f44e                	sd	s3,40(sp)
    80004044:	f052                	sd	s4,32(sp)
    80004046:	ec56                	sd	s5,24(sp)
    80004048:	e85a                	sd	s6,16(sp)
    8000404a:	0880                	addi	s0,sp,80
    8000404c:	84aa                	mv	s1,a0
    8000404e:	892e                	mv	s2,a1
    80004050:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004052:	ffffd097          	auipc	ra,0xffffd
    80004056:	e10080e7          	jalr	-496(ra) # 80000e62 <myproc>
    8000405a:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    8000405c:	8b26                	mv	s6,s1
    8000405e:	8526                	mv	a0,s1
    80004060:	00002097          	auipc	ra,0x2
    80004064:	51c080e7          	jalr	1308(ra) # 8000657c <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004068:	2184a703          	lw	a4,536(s1)
    8000406c:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004070:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004074:	02f71763          	bne	a4,a5,800040a2 <piperead+0x6a>
    80004078:	2244a783          	lw	a5,548(s1)
    8000407c:	c39d                	beqz	a5,800040a2 <piperead+0x6a>
    if(killed(pr)){
    8000407e:	8552                	mv	a0,s4
    80004080:	ffffd097          	auipc	ra,0xffffd
    80004084:	72e080e7          	jalr	1838(ra) # 800017ae <killed>
    80004088:	e941                	bnez	a0,80004118 <piperead+0xe0>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000408a:	85da                	mv	a1,s6
    8000408c:	854e                	mv	a0,s3
    8000408e:	ffffd097          	auipc	ra,0xffffd
    80004092:	478080e7          	jalr	1144(ra) # 80001506 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004096:	2184a703          	lw	a4,536(s1)
    8000409a:	21c4a783          	lw	a5,540(s1)
    8000409e:	fcf70de3          	beq	a4,a5,80004078 <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800040a2:	09505263          	blez	s5,80004126 <piperead+0xee>
    800040a6:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800040a8:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    800040aa:	2184a783          	lw	a5,536(s1)
    800040ae:	21c4a703          	lw	a4,540(s1)
    800040b2:	02f70d63          	beq	a4,a5,800040ec <piperead+0xb4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800040b6:	0017871b          	addiw	a4,a5,1
    800040ba:	20e4ac23          	sw	a4,536(s1)
    800040be:	1ff7f793          	andi	a5,a5,511
    800040c2:	97a6                	add	a5,a5,s1
    800040c4:	0187c783          	lbu	a5,24(a5)
    800040c8:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800040cc:	4685                	li	a3,1
    800040ce:	fbf40613          	addi	a2,s0,-65
    800040d2:	85ca                	mv	a1,s2
    800040d4:	050a3503          	ld	a0,80(s4)
    800040d8:	ffffd097          	auipc	ra,0xffffd
    800040dc:	a48080e7          	jalr	-1464(ra) # 80000b20 <copyout>
    800040e0:	01650663          	beq	a0,s6,800040ec <piperead+0xb4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800040e4:	2985                	addiw	s3,s3,1
    800040e6:	0905                	addi	s2,s2,1
    800040e8:	fd3a91e3          	bne	s5,s3,800040aa <piperead+0x72>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    800040ec:	21c48513          	addi	a0,s1,540
    800040f0:	ffffd097          	auipc	ra,0xffffd
    800040f4:	47a080e7          	jalr	1146(ra) # 8000156a <wakeup>
  release(&pi->lock);
    800040f8:	8526                	mv	a0,s1
    800040fa:	00002097          	auipc	ra,0x2
    800040fe:	536080e7          	jalr	1334(ra) # 80006630 <release>
  return i;
}
    80004102:	854e                	mv	a0,s3
    80004104:	60a6                	ld	ra,72(sp)
    80004106:	6406                	ld	s0,64(sp)
    80004108:	74e2                	ld	s1,56(sp)
    8000410a:	7942                	ld	s2,48(sp)
    8000410c:	79a2                	ld	s3,40(sp)
    8000410e:	7a02                	ld	s4,32(sp)
    80004110:	6ae2                	ld	s5,24(sp)
    80004112:	6b42                	ld	s6,16(sp)
    80004114:	6161                	addi	sp,sp,80
    80004116:	8082                	ret
      release(&pi->lock);
    80004118:	8526                	mv	a0,s1
    8000411a:	00002097          	auipc	ra,0x2
    8000411e:	516080e7          	jalr	1302(ra) # 80006630 <release>
      return -1;
    80004122:	59fd                	li	s3,-1
    80004124:	bff9                	j	80004102 <piperead+0xca>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004126:	4981                	li	s3,0
    80004128:	b7d1                	j	800040ec <piperead+0xb4>

000000008000412a <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    8000412a:	1141                	addi	sp,sp,-16
    8000412c:	e422                	sd	s0,8(sp)
    8000412e:	0800                	addi	s0,sp,16
    80004130:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80004132:	8905                	andi	a0,a0,1
    80004134:	c111                	beqz	a0,80004138 <flags2perm+0xe>
      perm = PTE_X;
    80004136:	4521                	li	a0,8
    if(flags & 0x2)
    80004138:	8b89                	andi	a5,a5,2
    8000413a:	c399                	beqz	a5,80004140 <flags2perm+0x16>
      perm |= PTE_W;
    8000413c:	00456513          	ori	a0,a0,4
    return perm;
}
    80004140:	6422                	ld	s0,8(sp)
    80004142:	0141                	addi	sp,sp,16
    80004144:	8082                	ret

0000000080004146 <exec>:

int
exec(char *path, char **argv)
{
    80004146:	df010113          	addi	sp,sp,-528
    8000414a:	20113423          	sd	ra,520(sp)
    8000414e:	20813023          	sd	s0,512(sp)
    80004152:	ffa6                	sd	s1,504(sp)
    80004154:	fbca                	sd	s2,496(sp)
    80004156:	f7ce                	sd	s3,488(sp)
    80004158:	f3d2                	sd	s4,480(sp)
    8000415a:	efd6                	sd	s5,472(sp)
    8000415c:	ebda                	sd	s6,464(sp)
    8000415e:	e7de                	sd	s7,456(sp)
    80004160:	e3e2                	sd	s8,448(sp)
    80004162:	ff66                	sd	s9,440(sp)
    80004164:	fb6a                	sd	s10,432(sp)
    80004166:	f76e                	sd	s11,424(sp)
    80004168:	0c00                	addi	s0,sp,528
    8000416a:	84aa                	mv	s1,a0
    8000416c:	dea43c23          	sd	a0,-520(s0)
    80004170:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004174:	ffffd097          	auipc	ra,0xffffd
    80004178:	cee080e7          	jalr	-786(ra) # 80000e62 <myproc>
    8000417c:	892a                	mv	s2,a0

  begin_op();
    8000417e:	fffff097          	auipc	ra,0xfffff
    80004182:	41a080e7          	jalr	1050(ra) # 80003598 <begin_op>

  if((ip = namei(path)) == 0){
    80004186:	8526                	mv	a0,s1
    80004188:	fffff097          	auipc	ra,0xfffff
    8000418c:	1f4080e7          	jalr	500(ra) # 8000337c <namei>
    80004190:	c92d                	beqz	a0,80004202 <exec+0xbc>
    80004192:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004194:	fffff097          	auipc	ra,0xfffff
    80004198:	a42080e7          	jalr	-1470(ra) # 80002bd6 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    8000419c:	04000713          	li	a4,64
    800041a0:	4681                	li	a3,0
    800041a2:	e5040613          	addi	a2,s0,-432
    800041a6:	4581                	li	a1,0
    800041a8:	8526                	mv	a0,s1
    800041aa:	fffff097          	auipc	ra,0xfffff
    800041ae:	ce0080e7          	jalr	-800(ra) # 80002e8a <readi>
    800041b2:	04000793          	li	a5,64
    800041b6:	00f51a63          	bne	a0,a5,800041ca <exec+0x84>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    800041ba:	e5042703          	lw	a4,-432(s0)
    800041be:	464c47b7          	lui	a5,0x464c4
    800041c2:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800041c6:	04f70463          	beq	a4,a5,8000420e <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800041ca:	8526                	mv	a0,s1
    800041cc:	fffff097          	auipc	ra,0xfffff
    800041d0:	c6c080e7          	jalr	-916(ra) # 80002e38 <iunlockput>
    end_op();
    800041d4:	fffff097          	auipc	ra,0xfffff
    800041d8:	444080e7          	jalr	1092(ra) # 80003618 <end_op>
  }
  return -1;
    800041dc:	557d                	li	a0,-1
}
    800041de:	20813083          	ld	ra,520(sp)
    800041e2:	20013403          	ld	s0,512(sp)
    800041e6:	74fe                	ld	s1,504(sp)
    800041e8:	795e                	ld	s2,496(sp)
    800041ea:	79be                	ld	s3,488(sp)
    800041ec:	7a1e                	ld	s4,480(sp)
    800041ee:	6afe                	ld	s5,472(sp)
    800041f0:	6b5e                	ld	s6,464(sp)
    800041f2:	6bbe                	ld	s7,456(sp)
    800041f4:	6c1e                	ld	s8,448(sp)
    800041f6:	7cfa                	ld	s9,440(sp)
    800041f8:	7d5a                	ld	s10,432(sp)
    800041fa:	7dba                	ld	s11,424(sp)
    800041fc:	21010113          	addi	sp,sp,528
    80004200:	8082                	ret
    end_op();
    80004202:	fffff097          	auipc	ra,0xfffff
    80004206:	416080e7          	jalr	1046(ra) # 80003618 <end_op>
    return -1;
    8000420a:	557d                	li	a0,-1
    8000420c:	bfc9                	j	800041de <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    8000420e:	854a                	mv	a0,s2
    80004210:	ffffd097          	auipc	ra,0xffffd
    80004214:	d16080e7          	jalr	-746(ra) # 80000f26 <proc_pagetable>
    80004218:	8baa                	mv	s7,a0
    8000421a:	d945                	beqz	a0,800041ca <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000421c:	e7042983          	lw	s3,-400(s0)
    80004220:	e8845783          	lhu	a5,-376(s0)
    80004224:	c7ad                	beqz	a5,8000428e <exec+0x148>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004226:	4a01                	li	s4,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004228:	4b01                	li	s6,0
    if(ph.vaddr % PGSIZE != 0)
    8000422a:	6c85                	lui	s9,0x1
    8000422c:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004230:	def43823          	sd	a5,-528(s0)
    80004234:	ac0d                	j	80004466 <exec+0x320>
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80004236:	00004517          	auipc	a0,0x4
    8000423a:	45250513          	addi	a0,a0,1106 # 80008688 <syscalls+0x298>
    8000423e:	00002097          	auipc	ra,0x2
    80004242:	df4080e7          	jalr	-524(ra) # 80006032 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004246:	8756                	mv	a4,s5
    80004248:	012d86bb          	addw	a3,s11,s2
    8000424c:	4581                	li	a1,0
    8000424e:	8526                	mv	a0,s1
    80004250:	fffff097          	auipc	ra,0xfffff
    80004254:	c3a080e7          	jalr	-966(ra) # 80002e8a <readi>
    80004258:	2501                	sext.w	a0,a0
    8000425a:	1aaa9a63          	bne	s5,a0,8000440e <exec+0x2c8>
  for(i = 0; i < sz; i += PGSIZE){
    8000425e:	6785                	lui	a5,0x1
    80004260:	0127893b          	addw	s2,a5,s2
    80004264:	77fd                	lui	a5,0xfffff
    80004266:	01478a3b          	addw	s4,a5,s4
    8000426a:	1f897563          	bgeu	s2,s8,80004454 <exec+0x30e>
    pa = walkaddr(pagetable, va + i);
    8000426e:	02091593          	slli	a1,s2,0x20
    80004272:	9181                	srli	a1,a1,0x20
    80004274:	95ea                	add	a1,a1,s10
    80004276:	855e                	mv	a0,s7
    80004278:	ffffc097          	auipc	ra,0xffffc
    8000427c:	292080e7          	jalr	658(ra) # 8000050a <walkaddr>
    80004280:	862a                	mv	a2,a0
    if(pa == 0)
    80004282:	d955                	beqz	a0,80004236 <exec+0xf0>
      n = PGSIZE;
    80004284:	8ae6                	mv	s5,s9
    if(sz - i < PGSIZE)
    80004286:	fd9a70e3          	bgeu	s4,s9,80004246 <exec+0x100>
      n = sz - i;
    8000428a:	8ad2                	mv	s5,s4
    8000428c:	bf6d                	j	80004246 <exec+0x100>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000428e:	4a01                	li	s4,0
  iunlockput(ip);
    80004290:	8526                	mv	a0,s1
    80004292:	fffff097          	auipc	ra,0xfffff
    80004296:	ba6080e7          	jalr	-1114(ra) # 80002e38 <iunlockput>
  end_op();
    8000429a:	fffff097          	auipc	ra,0xfffff
    8000429e:	37e080e7          	jalr	894(ra) # 80003618 <end_op>
  p = myproc();
    800042a2:	ffffd097          	auipc	ra,0xffffd
    800042a6:	bc0080e7          	jalr	-1088(ra) # 80000e62 <myproc>
    800042aa:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    800042ac:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    800042b0:	6785                	lui	a5,0x1
    800042b2:	17fd                	addi	a5,a5,-1
    800042b4:	9a3e                	add	s4,s4,a5
    800042b6:	757d                	lui	a0,0xfffff
    800042b8:	00aa77b3          	and	a5,s4,a0
    800042bc:	e0f43423          	sd	a5,-504(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    800042c0:	4691                	li	a3,4
    800042c2:	6609                	lui	a2,0x2
    800042c4:	963e                	add	a2,a2,a5
    800042c6:	85be                	mv	a1,a5
    800042c8:	855e                	mv	a0,s7
    800042ca:	ffffc097          	auipc	ra,0xffffc
    800042ce:	60a080e7          	jalr	1546(ra) # 800008d4 <uvmalloc>
    800042d2:	8b2a                	mv	s6,a0
  ip = 0;
    800042d4:	4481                	li	s1,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    800042d6:	12050c63          	beqz	a0,8000440e <exec+0x2c8>
  uvmclear(pagetable, sz-2*PGSIZE);
    800042da:	75f9                	lui	a1,0xffffe
    800042dc:	95aa                	add	a1,a1,a0
    800042de:	855e                	mv	a0,s7
    800042e0:	ffffd097          	auipc	ra,0xffffd
    800042e4:	80e080e7          	jalr	-2034(ra) # 80000aee <uvmclear>
  stackbase = sp - PGSIZE;
    800042e8:	7c7d                	lui	s8,0xfffff
    800042ea:	9c5a                	add	s8,s8,s6
  for(argc = 0; argv[argc]; argc++) {
    800042ec:	e0043783          	ld	a5,-512(s0)
    800042f0:	6388                	ld	a0,0(a5)
    800042f2:	c535                	beqz	a0,8000435e <exec+0x218>
    800042f4:	e9040993          	addi	s3,s0,-368
    800042f8:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    800042fc:	895a                	mv	s2,s6
    sp -= strlen(argv[argc]) + 1;
    800042fe:	ffffc097          	auipc	ra,0xffffc
    80004302:	ffe080e7          	jalr	-2(ra) # 800002fc <strlen>
    80004306:	2505                	addiw	a0,a0,1
    80004308:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    8000430c:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    80004310:	13896663          	bltu	s2,s8,8000443c <exec+0x2f6>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004314:	e0043d83          	ld	s11,-512(s0)
    80004318:	000dba03          	ld	s4,0(s11)
    8000431c:	8552                	mv	a0,s4
    8000431e:	ffffc097          	auipc	ra,0xffffc
    80004322:	fde080e7          	jalr	-34(ra) # 800002fc <strlen>
    80004326:	0015069b          	addiw	a3,a0,1
    8000432a:	8652                	mv	a2,s4
    8000432c:	85ca                	mv	a1,s2
    8000432e:	855e                	mv	a0,s7
    80004330:	ffffc097          	auipc	ra,0xffffc
    80004334:	7f0080e7          	jalr	2032(ra) # 80000b20 <copyout>
    80004338:	10054663          	bltz	a0,80004444 <exec+0x2fe>
    ustack[argc] = sp;
    8000433c:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004340:	0485                	addi	s1,s1,1
    80004342:	008d8793          	addi	a5,s11,8
    80004346:	e0f43023          	sd	a5,-512(s0)
    8000434a:	008db503          	ld	a0,8(s11)
    8000434e:	c911                	beqz	a0,80004362 <exec+0x21c>
    if(argc >= MAXARG)
    80004350:	09a1                	addi	s3,s3,8
    80004352:	fb3c96e3          	bne	s9,s3,800042fe <exec+0x1b8>
  sz = sz1;
    80004356:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    8000435a:	4481                	li	s1,0
    8000435c:	a84d                	j	8000440e <exec+0x2c8>
  sp = sz;
    8000435e:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    80004360:	4481                	li	s1,0
  ustack[argc] = 0;
    80004362:	00349793          	slli	a5,s1,0x3
    80004366:	f9040713          	addi	a4,s0,-112
    8000436a:	97ba                	add	a5,a5,a4
    8000436c:	f007b023          	sd	zero,-256(a5) # f00 <_entry-0x7ffff100>
  sp -= (argc+1) * sizeof(uint64);
    80004370:	00148693          	addi	a3,s1,1
    80004374:	068e                	slli	a3,a3,0x3
    80004376:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    8000437a:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    8000437e:	01897663          	bgeu	s2,s8,8000438a <exec+0x244>
  sz = sz1;
    80004382:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004386:	4481                	li	s1,0
    80004388:	a059                	j	8000440e <exec+0x2c8>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    8000438a:	e9040613          	addi	a2,s0,-368
    8000438e:	85ca                	mv	a1,s2
    80004390:	855e                	mv	a0,s7
    80004392:	ffffc097          	auipc	ra,0xffffc
    80004396:	78e080e7          	jalr	1934(ra) # 80000b20 <copyout>
    8000439a:	0a054963          	bltz	a0,8000444c <exec+0x306>
  p->trapframe->a1 = sp;
    8000439e:	058ab783          	ld	a5,88(s5)
    800043a2:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800043a6:	df843783          	ld	a5,-520(s0)
    800043aa:	0007c703          	lbu	a4,0(a5)
    800043ae:	cf11                	beqz	a4,800043ca <exec+0x284>
    800043b0:	0785                	addi	a5,a5,1
    if(*s == '/')
    800043b2:	02f00693          	li	a3,47
    800043b6:	a039                	j	800043c4 <exec+0x27e>
      last = s+1;
    800043b8:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    800043bc:	0785                	addi	a5,a5,1
    800043be:	fff7c703          	lbu	a4,-1(a5)
    800043c2:	c701                	beqz	a4,800043ca <exec+0x284>
    if(*s == '/')
    800043c4:	fed71ce3          	bne	a4,a3,800043bc <exec+0x276>
    800043c8:	bfc5                	j	800043b8 <exec+0x272>
  safestrcpy(p->name, last, sizeof(p->name));
    800043ca:	4641                	li	a2,16
    800043cc:	df843583          	ld	a1,-520(s0)
    800043d0:	158a8513          	addi	a0,s5,344
    800043d4:	ffffc097          	auipc	ra,0xffffc
    800043d8:	ef6080e7          	jalr	-266(ra) # 800002ca <safestrcpy>
  oldpagetable = p->pagetable;
    800043dc:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    800043e0:	057ab823          	sd	s7,80(s5)
  p->sz = sz;
    800043e4:	056ab423          	sd	s6,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    800043e8:	058ab783          	ld	a5,88(s5)
    800043ec:	e6843703          	ld	a4,-408(s0)
    800043f0:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    800043f2:	058ab783          	ld	a5,88(s5)
    800043f6:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    800043fa:	85ea                	mv	a1,s10
    800043fc:	ffffd097          	auipc	ra,0xffffd
    80004400:	bc6080e7          	jalr	-1082(ra) # 80000fc2 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004404:	0004851b          	sext.w	a0,s1
    80004408:	bbd9                	j	800041de <exec+0x98>
    8000440a:	e1443423          	sd	s4,-504(s0)
    proc_freepagetable(pagetable, sz);
    8000440e:	e0843583          	ld	a1,-504(s0)
    80004412:	855e                	mv	a0,s7
    80004414:	ffffd097          	auipc	ra,0xffffd
    80004418:	bae080e7          	jalr	-1106(ra) # 80000fc2 <proc_freepagetable>
  if(ip){
    8000441c:	da0497e3          	bnez	s1,800041ca <exec+0x84>
  return -1;
    80004420:	557d                	li	a0,-1
    80004422:	bb75                	j	800041de <exec+0x98>
    80004424:	e1443423          	sd	s4,-504(s0)
    80004428:	b7dd                	j	8000440e <exec+0x2c8>
    8000442a:	e1443423          	sd	s4,-504(s0)
    8000442e:	b7c5                	j	8000440e <exec+0x2c8>
    80004430:	e1443423          	sd	s4,-504(s0)
    80004434:	bfe9                	j	8000440e <exec+0x2c8>
    80004436:	e1443423          	sd	s4,-504(s0)
    8000443a:	bfd1                	j	8000440e <exec+0x2c8>
  sz = sz1;
    8000443c:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004440:	4481                	li	s1,0
    80004442:	b7f1                	j	8000440e <exec+0x2c8>
  sz = sz1;
    80004444:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004448:	4481                	li	s1,0
    8000444a:	b7d1                	j	8000440e <exec+0x2c8>
  sz = sz1;
    8000444c:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004450:	4481                	li	s1,0
    80004452:	bf75                	j	8000440e <exec+0x2c8>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004454:	e0843a03          	ld	s4,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004458:	2b05                	addiw	s6,s6,1
    8000445a:	0389899b          	addiw	s3,s3,56
    8000445e:	e8845783          	lhu	a5,-376(s0)
    80004462:	e2fb57e3          	bge	s6,a5,80004290 <exec+0x14a>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004466:	2981                	sext.w	s3,s3
    80004468:	03800713          	li	a4,56
    8000446c:	86ce                	mv	a3,s3
    8000446e:	e1840613          	addi	a2,s0,-488
    80004472:	4581                	li	a1,0
    80004474:	8526                	mv	a0,s1
    80004476:	fffff097          	auipc	ra,0xfffff
    8000447a:	a14080e7          	jalr	-1516(ra) # 80002e8a <readi>
    8000447e:	03800793          	li	a5,56
    80004482:	f8f514e3          	bne	a0,a5,8000440a <exec+0x2c4>
    if(ph.type != ELF_PROG_LOAD)
    80004486:	e1842783          	lw	a5,-488(s0)
    8000448a:	4705                	li	a4,1
    8000448c:	fce796e3          	bne	a5,a4,80004458 <exec+0x312>
    if(ph.memsz < ph.filesz)
    80004490:	e4043903          	ld	s2,-448(s0)
    80004494:	e3843783          	ld	a5,-456(s0)
    80004498:	f8f966e3          	bltu	s2,a5,80004424 <exec+0x2de>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    8000449c:	e2843783          	ld	a5,-472(s0)
    800044a0:	993e                	add	s2,s2,a5
    800044a2:	f8f964e3          	bltu	s2,a5,8000442a <exec+0x2e4>
    if(ph.vaddr % PGSIZE != 0)
    800044a6:	df043703          	ld	a4,-528(s0)
    800044aa:	8ff9                	and	a5,a5,a4
    800044ac:	f3d1                	bnez	a5,80004430 <exec+0x2ea>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800044ae:	e1c42503          	lw	a0,-484(s0)
    800044b2:	00000097          	auipc	ra,0x0
    800044b6:	c78080e7          	jalr	-904(ra) # 8000412a <flags2perm>
    800044ba:	86aa                	mv	a3,a0
    800044bc:	864a                	mv	a2,s2
    800044be:	85d2                	mv	a1,s4
    800044c0:	855e                	mv	a0,s7
    800044c2:	ffffc097          	auipc	ra,0xffffc
    800044c6:	412080e7          	jalr	1042(ra) # 800008d4 <uvmalloc>
    800044ca:	e0a43423          	sd	a0,-504(s0)
    800044ce:	d525                	beqz	a0,80004436 <exec+0x2f0>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800044d0:	e2843d03          	ld	s10,-472(s0)
    800044d4:	e2042d83          	lw	s11,-480(s0)
    800044d8:	e3842c03          	lw	s8,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    800044dc:	f60c0ce3          	beqz	s8,80004454 <exec+0x30e>
    800044e0:	8a62                	mv	s4,s8
    800044e2:	4901                	li	s2,0
    800044e4:	b369                	j	8000426e <exec+0x128>

00000000800044e6 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    800044e6:	7179                	addi	sp,sp,-48
    800044e8:	f406                	sd	ra,40(sp)
    800044ea:	f022                	sd	s0,32(sp)
    800044ec:	ec26                	sd	s1,24(sp)
    800044ee:	e84a                	sd	s2,16(sp)
    800044f0:	1800                	addi	s0,sp,48
    800044f2:	892e                	mv	s2,a1
    800044f4:	84b2                	mv	s1,a2
    int fd;
    struct file *f;

    argint(n, &fd);
    800044f6:	fdc40593          	addi	a1,s0,-36
    800044fa:	ffffe097          	auipc	ra,0xffffe
    800044fe:	b62080e7          	jalr	-1182(ra) # 8000205c <argint>
    if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0)
    80004502:	fdc42703          	lw	a4,-36(s0)
    80004506:	47bd                	li	a5,15
    80004508:	02e7eb63          	bltu	a5,a4,8000453e <argfd+0x58>
    8000450c:	ffffd097          	auipc	ra,0xffffd
    80004510:	956080e7          	jalr	-1706(ra) # 80000e62 <myproc>
    80004514:	fdc42703          	lw	a4,-36(s0)
    80004518:	01a70793          	addi	a5,a4,26
    8000451c:	078e                	slli	a5,a5,0x3
    8000451e:	953e                	add	a0,a0,a5
    80004520:	611c                	ld	a5,0(a0)
    80004522:	c385                	beqz	a5,80004542 <argfd+0x5c>
        return -1;
    if (pfd)
    80004524:	00090463          	beqz	s2,8000452c <argfd+0x46>
        *pfd = fd;
    80004528:	00e92023          	sw	a4,0(s2)
    if (pf)
        *pf = f;
    return 0;
    8000452c:	4501                	li	a0,0
    if (pf)
    8000452e:	c091                	beqz	s1,80004532 <argfd+0x4c>
        *pf = f;
    80004530:	e09c                	sd	a5,0(s1)
}
    80004532:	70a2                	ld	ra,40(sp)
    80004534:	7402                	ld	s0,32(sp)
    80004536:	64e2                	ld	s1,24(sp)
    80004538:	6942                	ld	s2,16(sp)
    8000453a:	6145                	addi	sp,sp,48
    8000453c:	8082                	ret
        return -1;
    8000453e:	557d                	li	a0,-1
    80004540:	bfcd                	j	80004532 <argfd+0x4c>
    80004542:	557d                	li	a0,-1
    80004544:	b7fd                	j	80004532 <argfd+0x4c>

0000000080004546 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004546:	1101                	addi	sp,sp,-32
    80004548:	ec06                	sd	ra,24(sp)
    8000454a:	e822                	sd	s0,16(sp)
    8000454c:	e426                	sd	s1,8(sp)
    8000454e:	1000                	addi	s0,sp,32
    80004550:	84aa                	mv	s1,a0
    int fd;
    struct proc *p = myproc();
    80004552:	ffffd097          	auipc	ra,0xffffd
    80004556:	910080e7          	jalr	-1776(ra) # 80000e62 <myproc>
    8000455a:	862a                	mv	a2,a0

    for (fd = 0; fd < NOFILE; fd++)
    8000455c:	0d050793          	addi	a5,a0,208 # fffffffffffff0d0 <end+0xffffffff7ffcb160>
    80004560:	4501                	li	a0,0
    80004562:	46c1                	li	a3,16
    {
        if (p->ofile[fd] == 0)
    80004564:	6398                	ld	a4,0(a5)
    80004566:	cb19                	beqz	a4,8000457c <fdalloc+0x36>
    for (fd = 0; fd < NOFILE; fd++)
    80004568:	2505                	addiw	a0,a0,1
    8000456a:	07a1                	addi	a5,a5,8
    8000456c:	fed51ce3          	bne	a0,a3,80004564 <fdalloc+0x1e>
        {
            p->ofile[fd] = f;
            return fd;
        }
    }
    return -1;
    80004570:	557d                	li	a0,-1
}
    80004572:	60e2                	ld	ra,24(sp)
    80004574:	6442                	ld	s0,16(sp)
    80004576:	64a2                	ld	s1,8(sp)
    80004578:	6105                	addi	sp,sp,32
    8000457a:	8082                	ret
            p->ofile[fd] = f;
    8000457c:	01a50793          	addi	a5,a0,26
    80004580:	078e                	slli	a5,a5,0x3
    80004582:	963e                	add	a2,a2,a5
    80004584:	e204                	sd	s1,0(a2)
            return fd;
    80004586:	b7f5                	j	80004572 <fdalloc+0x2c>

0000000080004588 <create>:
    }
}

static struct inode *
create(char *path, short type, short major, short minor)
{
    80004588:	715d                	addi	sp,sp,-80
    8000458a:	e486                	sd	ra,72(sp)
    8000458c:	e0a2                	sd	s0,64(sp)
    8000458e:	fc26                	sd	s1,56(sp)
    80004590:	f84a                	sd	s2,48(sp)
    80004592:	f44e                	sd	s3,40(sp)
    80004594:	f052                	sd	s4,32(sp)
    80004596:	ec56                	sd	s5,24(sp)
    80004598:	e85a                	sd	s6,16(sp)
    8000459a:	0880                	addi	s0,sp,80
    8000459c:	8b2e                	mv	s6,a1
    8000459e:	89b2                	mv	s3,a2
    800045a0:	8936                	mv	s2,a3
    struct inode *ip, *dp;
    char name[DIRSIZ];

    if ((dp = nameiparent(path, name)) == 0)
    800045a2:	fb040593          	addi	a1,s0,-80
    800045a6:	fffff097          	auipc	ra,0xfffff
    800045aa:	df4080e7          	jalr	-524(ra) # 8000339a <nameiparent>
    800045ae:	84aa                	mv	s1,a0
    800045b0:	16050063          	beqz	a0,80004710 <create+0x188>
        return 0;

    ilock(dp);
    800045b4:	ffffe097          	auipc	ra,0xffffe
    800045b8:	622080e7          	jalr	1570(ra) # 80002bd6 <ilock>

    if ((ip = dirlookup(dp, name, 0)) != 0)
    800045bc:	4601                	li	a2,0
    800045be:	fb040593          	addi	a1,s0,-80
    800045c2:	8526                	mv	a0,s1
    800045c4:	fffff097          	auipc	ra,0xfffff
    800045c8:	af6080e7          	jalr	-1290(ra) # 800030ba <dirlookup>
    800045cc:	8aaa                	mv	s5,a0
    800045ce:	c931                	beqz	a0,80004622 <create+0x9a>
    {
        iunlockput(dp);
    800045d0:	8526                	mv	a0,s1
    800045d2:	fffff097          	auipc	ra,0xfffff
    800045d6:	866080e7          	jalr	-1946(ra) # 80002e38 <iunlockput>
        ilock(ip);
    800045da:	8556                	mv	a0,s5
    800045dc:	ffffe097          	auipc	ra,0xffffe
    800045e0:	5fa080e7          	jalr	1530(ra) # 80002bd6 <ilock>
        if (type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    800045e4:	000b059b          	sext.w	a1,s6
    800045e8:	4789                	li	a5,2
    800045ea:	02f59563          	bne	a1,a5,80004614 <create+0x8c>
    800045ee:	044ad783          	lhu	a5,68(s5)
    800045f2:	37f9                	addiw	a5,a5,-2
    800045f4:	17c2                	slli	a5,a5,0x30
    800045f6:	93c1                	srli	a5,a5,0x30
    800045f8:	4705                	li	a4,1
    800045fa:	00f76d63          	bltu	a4,a5,80004614 <create+0x8c>
    ip->nlink = 0;
    iupdate(ip);
    iunlockput(ip);
    iunlockput(dp);
    return 0;
}
    800045fe:	8556                	mv	a0,s5
    80004600:	60a6                	ld	ra,72(sp)
    80004602:	6406                	ld	s0,64(sp)
    80004604:	74e2                	ld	s1,56(sp)
    80004606:	7942                	ld	s2,48(sp)
    80004608:	79a2                	ld	s3,40(sp)
    8000460a:	7a02                	ld	s4,32(sp)
    8000460c:	6ae2                	ld	s5,24(sp)
    8000460e:	6b42                	ld	s6,16(sp)
    80004610:	6161                	addi	sp,sp,80
    80004612:	8082                	ret
        iunlockput(ip);
    80004614:	8556                	mv	a0,s5
    80004616:	fffff097          	auipc	ra,0xfffff
    8000461a:	822080e7          	jalr	-2014(ra) # 80002e38 <iunlockput>
        return 0;
    8000461e:	4a81                	li	s5,0
    80004620:	bff9                	j	800045fe <create+0x76>
    if ((ip = ialloc(dp->dev, type)) == 0)
    80004622:	85da                	mv	a1,s6
    80004624:	4088                	lw	a0,0(s1)
    80004626:	ffffe097          	auipc	ra,0xffffe
    8000462a:	414080e7          	jalr	1044(ra) # 80002a3a <ialloc>
    8000462e:	8a2a                	mv	s4,a0
    80004630:	c921                	beqz	a0,80004680 <create+0xf8>
    ilock(ip);
    80004632:	ffffe097          	auipc	ra,0xffffe
    80004636:	5a4080e7          	jalr	1444(ra) # 80002bd6 <ilock>
    ip->major = major;
    8000463a:	053a1323          	sh	s3,70(s4)
    ip->minor = minor;
    8000463e:	052a1423          	sh	s2,72(s4)
    ip->nlink = 1;
    80004642:	4785                	li	a5,1
    80004644:	04fa1523          	sh	a5,74(s4)
    iupdate(ip);
    80004648:	8552                	mv	a0,s4
    8000464a:	ffffe097          	auipc	ra,0xffffe
    8000464e:	4c2080e7          	jalr	1218(ra) # 80002b0c <iupdate>
    if (type == T_DIR)
    80004652:	000b059b          	sext.w	a1,s6
    80004656:	4785                	li	a5,1
    80004658:	02f58b63          	beq	a1,a5,8000468e <create+0x106>
    if (dirlink(dp, name, ip->inum) < 0)
    8000465c:	004a2603          	lw	a2,4(s4)
    80004660:	fb040593          	addi	a1,s0,-80
    80004664:	8526                	mv	a0,s1
    80004666:	fffff097          	auipc	ra,0xfffff
    8000466a:	c64080e7          	jalr	-924(ra) # 800032ca <dirlink>
    8000466e:	06054f63          	bltz	a0,800046ec <create+0x164>
    iunlockput(dp);
    80004672:	8526                	mv	a0,s1
    80004674:	ffffe097          	auipc	ra,0xffffe
    80004678:	7c4080e7          	jalr	1988(ra) # 80002e38 <iunlockput>
    return ip;
    8000467c:	8ad2                	mv	s5,s4
    8000467e:	b741                	j	800045fe <create+0x76>
        iunlockput(dp);
    80004680:	8526                	mv	a0,s1
    80004682:	ffffe097          	auipc	ra,0xffffe
    80004686:	7b6080e7          	jalr	1974(ra) # 80002e38 <iunlockput>
        return 0;
    8000468a:	8ad2                	mv	s5,s4
    8000468c:	bf8d                	j	800045fe <create+0x76>
        if (dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    8000468e:	004a2603          	lw	a2,4(s4)
    80004692:	00004597          	auipc	a1,0x4
    80004696:	01658593          	addi	a1,a1,22 # 800086a8 <syscalls+0x2b8>
    8000469a:	8552                	mv	a0,s4
    8000469c:	fffff097          	auipc	ra,0xfffff
    800046a0:	c2e080e7          	jalr	-978(ra) # 800032ca <dirlink>
    800046a4:	04054463          	bltz	a0,800046ec <create+0x164>
    800046a8:	40d0                	lw	a2,4(s1)
    800046aa:	00004597          	auipc	a1,0x4
    800046ae:	00658593          	addi	a1,a1,6 # 800086b0 <syscalls+0x2c0>
    800046b2:	8552                	mv	a0,s4
    800046b4:	fffff097          	auipc	ra,0xfffff
    800046b8:	c16080e7          	jalr	-1002(ra) # 800032ca <dirlink>
    800046bc:	02054863          	bltz	a0,800046ec <create+0x164>
    if (dirlink(dp, name, ip->inum) < 0)
    800046c0:	004a2603          	lw	a2,4(s4)
    800046c4:	fb040593          	addi	a1,s0,-80
    800046c8:	8526                	mv	a0,s1
    800046ca:	fffff097          	auipc	ra,0xfffff
    800046ce:	c00080e7          	jalr	-1024(ra) # 800032ca <dirlink>
    800046d2:	00054d63          	bltz	a0,800046ec <create+0x164>
        dp->nlink++; // for ".."
    800046d6:	04a4d783          	lhu	a5,74(s1)
    800046da:	2785                	addiw	a5,a5,1
    800046dc:	04f49523          	sh	a5,74(s1)
        iupdate(dp);
    800046e0:	8526                	mv	a0,s1
    800046e2:	ffffe097          	auipc	ra,0xffffe
    800046e6:	42a080e7          	jalr	1066(ra) # 80002b0c <iupdate>
    800046ea:	b761                	j	80004672 <create+0xea>
    ip->nlink = 0;
    800046ec:	040a1523          	sh	zero,74(s4)
    iupdate(ip);
    800046f0:	8552                	mv	a0,s4
    800046f2:	ffffe097          	auipc	ra,0xffffe
    800046f6:	41a080e7          	jalr	1050(ra) # 80002b0c <iupdate>
    iunlockput(ip);
    800046fa:	8552                	mv	a0,s4
    800046fc:	ffffe097          	auipc	ra,0xffffe
    80004700:	73c080e7          	jalr	1852(ra) # 80002e38 <iunlockput>
    iunlockput(dp);
    80004704:	8526                	mv	a0,s1
    80004706:	ffffe097          	auipc	ra,0xffffe
    8000470a:	732080e7          	jalr	1842(ra) # 80002e38 <iunlockput>
    return 0;
    8000470e:	bdc5                	j	800045fe <create+0x76>
        return 0;
    80004710:	8aaa                	mv	s5,a0
    80004712:	b5f5                	j	800045fe <create+0x76>

0000000080004714 <sys_dup>:
{
    80004714:	7179                	addi	sp,sp,-48
    80004716:	f406                	sd	ra,40(sp)
    80004718:	f022                	sd	s0,32(sp)
    8000471a:	ec26                	sd	s1,24(sp)
    8000471c:	1800                	addi	s0,sp,48
    if (argfd(0, 0, &f) < 0)
    8000471e:	fd840613          	addi	a2,s0,-40
    80004722:	4581                	li	a1,0
    80004724:	4501                	li	a0,0
    80004726:	00000097          	auipc	ra,0x0
    8000472a:	dc0080e7          	jalr	-576(ra) # 800044e6 <argfd>
        return -1;
    8000472e:	57fd                	li	a5,-1
    if (argfd(0, 0, &f) < 0)
    80004730:	02054363          	bltz	a0,80004756 <sys_dup+0x42>
    if ((fd = fdalloc(f)) < 0)
    80004734:	fd843503          	ld	a0,-40(s0)
    80004738:	00000097          	auipc	ra,0x0
    8000473c:	e0e080e7          	jalr	-498(ra) # 80004546 <fdalloc>
    80004740:	84aa                	mv	s1,a0
        return -1;
    80004742:	57fd                	li	a5,-1
    if ((fd = fdalloc(f)) < 0)
    80004744:	00054963          	bltz	a0,80004756 <sys_dup+0x42>
    filedup(f);
    80004748:	fd843503          	ld	a0,-40(s0)
    8000474c:	fffff097          	auipc	ra,0xfffff
    80004750:	2c6080e7          	jalr	710(ra) # 80003a12 <filedup>
    return fd;
    80004754:	87a6                	mv	a5,s1
}
    80004756:	853e                	mv	a0,a5
    80004758:	70a2                	ld	ra,40(sp)
    8000475a:	7402                	ld	s0,32(sp)
    8000475c:	64e2                	ld	s1,24(sp)
    8000475e:	6145                	addi	sp,sp,48
    80004760:	8082                	ret

0000000080004762 <sys_read>:
{
    80004762:	7179                	addi	sp,sp,-48
    80004764:	f406                	sd	ra,40(sp)
    80004766:	f022                	sd	s0,32(sp)
    80004768:	1800                	addi	s0,sp,48
    argaddr(1, &p);
    8000476a:	fd840593          	addi	a1,s0,-40
    8000476e:	4505                	li	a0,1
    80004770:	ffffe097          	auipc	ra,0xffffe
    80004774:	90c080e7          	jalr	-1780(ra) # 8000207c <argaddr>
    argint(2, &n);
    80004778:	fe440593          	addi	a1,s0,-28
    8000477c:	4509                	li	a0,2
    8000477e:	ffffe097          	auipc	ra,0xffffe
    80004782:	8de080e7          	jalr	-1826(ra) # 8000205c <argint>
    if (argfd(0, 0, &f) < 0)
    80004786:	fe840613          	addi	a2,s0,-24
    8000478a:	4581                	li	a1,0
    8000478c:	4501                	li	a0,0
    8000478e:	00000097          	auipc	ra,0x0
    80004792:	d58080e7          	jalr	-680(ra) # 800044e6 <argfd>
    80004796:	87aa                	mv	a5,a0
        return -1;
    80004798:	557d                	li	a0,-1
    if (argfd(0, 0, &f) < 0)
    8000479a:	0007cc63          	bltz	a5,800047b2 <sys_read+0x50>
    return fileread(f, p, n);
    8000479e:	fe442603          	lw	a2,-28(s0)
    800047a2:	fd843583          	ld	a1,-40(s0)
    800047a6:	fe843503          	ld	a0,-24(s0)
    800047aa:	fffff097          	auipc	ra,0xfffff
    800047ae:	44e080e7          	jalr	1102(ra) # 80003bf8 <fileread>
}
    800047b2:	70a2                	ld	ra,40(sp)
    800047b4:	7402                	ld	s0,32(sp)
    800047b6:	6145                	addi	sp,sp,48
    800047b8:	8082                	ret

00000000800047ba <sys_write>:
{
    800047ba:	7179                	addi	sp,sp,-48
    800047bc:	f406                	sd	ra,40(sp)
    800047be:	f022                	sd	s0,32(sp)
    800047c0:	1800                	addi	s0,sp,48
    argaddr(1, &p);
    800047c2:	fd840593          	addi	a1,s0,-40
    800047c6:	4505                	li	a0,1
    800047c8:	ffffe097          	auipc	ra,0xffffe
    800047cc:	8b4080e7          	jalr	-1868(ra) # 8000207c <argaddr>
    argint(2, &n);
    800047d0:	fe440593          	addi	a1,s0,-28
    800047d4:	4509                	li	a0,2
    800047d6:	ffffe097          	auipc	ra,0xffffe
    800047da:	886080e7          	jalr	-1914(ra) # 8000205c <argint>
    if (argfd(0, 0, &f) < 0)
    800047de:	fe840613          	addi	a2,s0,-24
    800047e2:	4581                	li	a1,0
    800047e4:	4501                	li	a0,0
    800047e6:	00000097          	auipc	ra,0x0
    800047ea:	d00080e7          	jalr	-768(ra) # 800044e6 <argfd>
    800047ee:	87aa                	mv	a5,a0
        return -1;
    800047f0:	557d                	li	a0,-1
    if (argfd(0, 0, &f) < 0)
    800047f2:	0007cc63          	bltz	a5,8000480a <sys_write+0x50>
    return filewrite(f, p, n);
    800047f6:	fe442603          	lw	a2,-28(s0)
    800047fa:	fd843583          	ld	a1,-40(s0)
    800047fe:	fe843503          	ld	a0,-24(s0)
    80004802:	fffff097          	auipc	ra,0xfffff
    80004806:	4b8080e7          	jalr	1208(ra) # 80003cba <filewrite>
}
    8000480a:	70a2                	ld	ra,40(sp)
    8000480c:	7402                	ld	s0,32(sp)
    8000480e:	6145                	addi	sp,sp,48
    80004810:	8082                	ret

0000000080004812 <sys_close>:
{
    80004812:	1101                	addi	sp,sp,-32
    80004814:	ec06                	sd	ra,24(sp)
    80004816:	e822                	sd	s0,16(sp)
    80004818:	1000                	addi	s0,sp,32
    if (argfd(0, &fd, &f) < 0)
    8000481a:	fe040613          	addi	a2,s0,-32
    8000481e:	fec40593          	addi	a1,s0,-20
    80004822:	4501                	li	a0,0
    80004824:	00000097          	auipc	ra,0x0
    80004828:	cc2080e7          	jalr	-830(ra) # 800044e6 <argfd>
        return -1;
    8000482c:	57fd                	li	a5,-1
    if (argfd(0, &fd, &f) < 0)
    8000482e:	02054463          	bltz	a0,80004856 <sys_close+0x44>
    myproc()->ofile[fd] = 0;
    80004832:	ffffc097          	auipc	ra,0xffffc
    80004836:	630080e7          	jalr	1584(ra) # 80000e62 <myproc>
    8000483a:	fec42783          	lw	a5,-20(s0)
    8000483e:	07e9                	addi	a5,a5,26
    80004840:	078e                	slli	a5,a5,0x3
    80004842:	97aa                	add	a5,a5,a0
    80004844:	0007b023          	sd	zero,0(a5)
    fileclose(f);
    80004848:	fe043503          	ld	a0,-32(s0)
    8000484c:	fffff097          	auipc	ra,0xfffff
    80004850:	218080e7          	jalr	536(ra) # 80003a64 <fileclose>
    return 0;
    80004854:	4781                	li	a5,0
}
    80004856:	853e                	mv	a0,a5
    80004858:	60e2                	ld	ra,24(sp)
    8000485a:	6442                	ld	s0,16(sp)
    8000485c:	6105                	addi	sp,sp,32
    8000485e:	8082                	ret

0000000080004860 <sys_fstat>:
{
    80004860:	1101                	addi	sp,sp,-32
    80004862:	ec06                	sd	ra,24(sp)
    80004864:	e822                	sd	s0,16(sp)
    80004866:	1000                	addi	s0,sp,32
    argaddr(1, &st);
    80004868:	fe040593          	addi	a1,s0,-32
    8000486c:	4505                	li	a0,1
    8000486e:	ffffe097          	auipc	ra,0xffffe
    80004872:	80e080e7          	jalr	-2034(ra) # 8000207c <argaddr>
    if (argfd(0, 0, &f) < 0)
    80004876:	fe840613          	addi	a2,s0,-24
    8000487a:	4581                	li	a1,0
    8000487c:	4501                	li	a0,0
    8000487e:	00000097          	auipc	ra,0x0
    80004882:	c68080e7          	jalr	-920(ra) # 800044e6 <argfd>
    80004886:	87aa                	mv	a5,a0
        return -1;
    80004888:	557d                	li	a0,-1
    if (argfd(0, 0, &f) < 0)
    8000488a:	0007ca63          	bltz	a5,8000489e <sys_fstat+0x3e>
    return filestat(f, st);
    8000488e:	fe043583          	ld	a1,-32(s0)
    80004892:	fe843503          	ld	a0,-24(s0)
    80004896:	fffff097          	auipc	ra,0xfffff
    8000489a:	296080e7          	jalr	662(ra) # 80003b2c <filestat>
}
    8000489e:	60e2                	ld	ra,24(sp)
    800048a0:	6442                	ld	s0,16(sp)
    800048a2:	6105                	addi	sp,sp,32
    800048a4:	8082                	ret

00000000800048a6 <sys_link>:
{
    800048a6:	7169                	addi	sp,sp,-304
    800048a8:	f606                	sd	ra,296(sp)
    800048aa:	f222                	sd	s0,288(sp)
    800048ac:	ee26                	sd	s1,280(sp)
    800048ae:	ea4a                	sd	s2,272(sp)
    800048b0:	1a00                	addi	s0,sp,304
    if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800048b2:	08000613          	li	a2,128
    800048b6:	ed040593          	addi	a1,s0,-304
    800048ba:	4501                	li	a0,0
    800048bc:	ffffd097          	auipc	ra,0xffffd
    800048c0:	7e0080e7          	jalr	2016(ra) # 8000209c <argstr>
        return -1;
    800048c4:	57fd                	li	a5,-1
    if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800048c6:	10054e63          	bltz	a0,800049e2 <sys_link+0x13c>
    800048ca:	08000613          	li	a2,128
    800048ce:	f5040593          	addi	a1,s0,-176
    800048d2:	4505                	li	a0,1
    800048d4:	ffffd097          	auipc	ra,0xffffd
    800048d8:	7c8080e7          	jalr	1992(ra) # 8000209c <argstr>
        return -1;
    800048dc:	57fd                	li	a5,-1
    if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800048de:	10054263          	bltz	a0,800049e2 <sys_link+0x13c>
    begin_op();
    800048e2:	fffff097          	auipc	ra,0xfffff
    800048e6:	cb6080e7          	jalr	-842(ra) # 80003598 <begin_op>
    if ((ip = namei(old)) == 0)
    800048ea:	ed040513          	addi	a0,s0,-304
    800048ee:	fffff097          	auipc	ra,0xfffff
    800048f2:	a8e080e7          	jalr	-1394(ra) # 8000337c <namei>
    800048f6:	84aa                	mv	s1,a0
    800048f8:	c551                	beqz	a0,80004984 <sys_link+0xde>
    ilock(ip);
    800048fa:	ffffe097          	auipc	ra,0xffffe
    800048fe:	2dc080e7          	jalr	732(ra) # 80002bd6 <ilock>
    if (ip->type == T_DIR)
    80004902:	04449703          	lh	a4,68(s1)
    80004906:	4785                	li	a5,1
    80004908:	08f70463          	beq	a4,a5,80004990 <sys_link+0xea>
    ip->nlink++;
    8000490c:	04a4d783          	lhu	a5,74(s1)
    80004910:	2785                	addiw	a5,a5,1
    80004912:	04f49523          	sh	a5,74(s1)
    iupdate(ip);
    80004916:	8526                	mv	a0,s1
    80004918:	ffffe097          	auipc	ra,0xffffe
    8000491c:	1f4080e7          	jalr	500(ra) # 80002b0c <iupdate>
    iunlock(ip);
    80004920:	8526                	mv	a0,s1
    80004922:	ffffe097          	auipc	ra,0xffffe
    80004926:	376080e7          	jalr	886(ra) # 80002c98 <iunlock>
    if ((dp = nameiparent(new, name)) == 0)
    8000492a:	fd040593          	addi	a1,s0,-48
    8000492e:	f5040513          	addi	a0,s0,-176
    80004932:	fffff097          	auipc	ra,0xfffff
    80004936:	a68080e7          	jalr	-1432(ra) # 8000339a <nameiparent>
    8000493a:	892a                	mv	s2,a0
    8000493c:	c935                	beqz	a0,800049b0 <sys_link+0x10a>
    ilock(dp);
    8000493e:	ffffe097          	auipc	ra,0xffffe
    80004942:	298080e7          	jalr	664(ra) # 80002bd6 <ilock>
    if (dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0)
    80004946:	00092703          	lw	a4,0(s2)
    8000494a:	409c                	lw	a5,0(s1)
    8000494c:	04f71d63          	bne	a4,a5,800049a6 <sys_link+0x100>
    80004950:	40d0                	lw	a2,4(s1)
    80004952:	fd040593          	addi	a1,s0,-48
    80004956:	854a                	mv	a0,s2
    80004958:	fffff097          	auipc	ra,0xfffff
    8000495c:	972080e7          	jalr	-1678(ra) # 800032ca <dirlink>
    80004960:	04054363          	bltz	a0,800049a6 <sys_link+0x100>
    iunlockput(dp);
    80004964:	854a                	mv	a0,s2
    80004966:	ffffe097          	auipc	ra,0xffffe
    8000496a:	4d2080e7          	jalr	1234(ra) # 80002e38 <iunlockput>
    iput(ip);
    8000496e:	8526                	mv	a0,s1
    80004970:	ffffe097          	auipc	ra,0xffffe
    80004974:	420080e7          	jalr	1056(ra) # 80002d90 <iput>
    end_op();
    80004978:	fffff097          	auipc	ra,0xfffff
    8000497c:	ca0080e7          	jalr	-864(ra) # 80003618 <end_op>
    return 0;
    80004980:	4781                	li	a5,0
    80004982:	a085                	j	800049e2 <sys_link+0x13c>
        end_op();
    80004984:	fffff097          	auipc	ra,0xfffff
    80004988:	c94080e7          	jalr	-876(ra) # 80003618 <end_op>
        return -1;
    8000498c:	57fd                	li	a5,-1
    8000498e:	a891                	j	800049e2 <sys_link+0x13c>
        iunlockput(ip);
    80004990:	8526                	mv	a0,s1
    80004992:	ffffe097          	auipc	ra,0xffffe
    80004996:	4a6080e7          	jalr	1190(ra) # 80002e38 <iunlockput>
        end_op();
    8000499a:	fffff097          	auipc	ra,0xfffff
    8000499e:	c7e080e7          	jalr	-898(ra) # 80003618 <end_op>
        return -1;
    800049a2:	57fd                	li	a5,-1
    800049a4:	a83d                	j	800049e2 <sys_link+0x13c>
        iunlockput(dp);
    800049a6:	854a                	mv	a0,s2
    800049a8:	ffffe097          	auipc	ra,0xffffe
    800049ac:	490080e7          	jalr	1168(ra) # 80002e38 <iunlockput>
    ilock(ip);
    800049b0:	8526                	mv	a0,s1
    800049b2:	ffffe097          	auipc	ra,0xffffe
    800049b6:	224080e7          	jalr	548(ra) # 80002bd6 <ilock>
    ip->nlink--;
    800049ba:	04a4d783          	lhu	a5,74(s1)
    800049be:	37fd                	addiw	a5,a5,-1
    800049c0:	04f49523          	sh	a5,74(s1)
    iupdate(ip);
    800049c4:	8526                	mv	a0,s1
    800049c6:	ffffe097          	auipc	ra,0xffffe
    800049ca:	146080e7          	jalr	326(ra) # 80002b0c <iupdate>
    iunlockput(ip);
    800049ce:	8526                	mv	a0,s1
    800049d0:	ffffe097          	auipc	ra,0xffffe
    800049d4:	468080e7          	jalr	1128(ra) # 80002e38 <iunlockput>
    end_op();
    800049d8:	fffff097          	auipc	ra,0xfffff
    800049dc:	c40080e7          	jalr	-960(ra) # 80003618 <end_op>
    return -1;
    800049e0:	57fd                	li	a5,-1
}
    800049e2:	853e                	mv	a0,a5
    800049e4:	70b2                	ld	ra,296(sp)
    800049e6:	7412                	ld	s0,288(sp)
    800049e8:	64f2                	ld	s1,280(sp)
    800049ea:	6952                	ld	s2,272(sp)
    800049ec:	6155                	addi	sp,sp,304
    800049ee:	8082                	ret

00000000800049f0 <sys_unlink>:
{
    800049f0:	7151                	addi	sp,sp,-240
    800049f2:	f586                	sd	ra,232(sp)
    800049f4:	f1a2                	sd	s0,224(sp)
    800049f6:	eda6                	sd	s1,216(sp)
    800049f8:	e9ca                	sd	s2,208(sp)
    800049fa:	e5ce                	sd	s3,200(sp)
    800049fc:	1980                	addi	s0,sp,240
    if (argstr(0, path, MAXPATH) < 0)
    800049fe:	08000613          	li	a2,128
    80004a02:	f3040593          	addi	a1,s0,-208
    80004a06:	4501                	li	a0,0
    80004a08:	ffffd097          	auipc	ra,0xffffd
    80004a0c:	694080e7          	jalr	1684(ra) # 8000209c <argstr>
    80004a10:	18054163          	bltz	a0,80004b92 <sys_unlink+0x1a2>
    begin_op();
    80004a14:	fffff097          	auipc	ra,0xfffff
    80004a18:	b84080e7          	jalr	-1148(ra) # 80003598 <begin_op>
    if ((dp = nameiparent(path, name)) == 0)
    80004a1c:	fb040593          	addi	a1,s0,-80
    80004a20:	f3040513          	addi	a0,s0,-208
    80004a24:	fffff097          	auipc	ra,0xfffff
    80004a28:	976080e7          	jalr	-1674(ra) # 8000339a <nameiparent>
    80004a2c:	84aa                	mv	s1,a0
    80004a2e:	c979                	beqz	a0,80004b04 <sys_unlink+0x114>
    ilock(dp);
    80004a30:	ffffe097          	auipc	ra,0xffffe
    80004a34:	1a6080e7          	jalr	422(ra) # 80002bd6 <ilock>
    if (namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004a38:	00004597          	auipc	a1,0x4
    80004a3c:	c7058593          	addi	a1,a1,-912 # 800086a8 <syscalls+0x2b8>
    80004a40:	fb040513          	addi	a0,s0,-80
    80004a44:	ffffe097          	auipc	ra,0xffffe
    80004a48:	65c080e7          	jalr	1628(ra) # 800030a0 <namecmp>
    80004a4c:	14050a63          	beqz	a0,80004ba0 <sys_unlink+0x1b0>
    80004a50:	00004597          	auipc	a1,0x4
    80004a54:	c6058593          	addi	a1,a1,-928 # 800086b0 <syscalls+0x2c0>
    80004a58:	fb040513          	addi	a0,s0,-80
    80004a5c:	ffffe097          	auipc	ra,0xffffe
    80004a60:	644080e7          	jalr	1604(ra) # 800030a0 <namecmp>
    80004a64:	12050e63          	beqz	a0,80004ba0 <sys_unlink+0x1b0>
    if ((ip = dirlookup(dp, name, &off)) == 0)
    80004a68:	f2c40613          	addi	a2,s0,-212
    80004a6c:	fb040593          	addi	a1,s0,-80
    80004a70:	8526                	mv	a0,s1
    80004a72:	ffffe097          	auipc	ra,0xffffe
    80004a76:	648080e7          	jalr	1608(ra) # 800030ba <dirlookup>
    80004a7a:	892a                	mv	s2,a0
    80004a7c:	12050263          	beqz	a0,80004ba0 <sys_unlink+0x1b0>
    ilock(ip);
    80004a80:	ffffe097          	auipc	ra,0xffffe
    80004a84:	156080e7          	jalr	342(ra) # 80002bd6 <ilock>
    if (ip->nlink < 1)
    80004a88:	04a91783          	lh	a5,74(s2)
    80004a8c:	08f05263          	blez	a5,80004b10 <sys_unlink+0x120>
    if (ip->type == T_DIR && !isdirempty(ip))
    80004a90:	04491703          	lh	a4,68(s2)
    80004a94:	4785                	li	a5,1
    80004a96:	08f70563          	beq	a4,a5,80004b20 <sys_unlink+0x130>
    memset(&de, 0, sizeof(de));
    80004a9a:	4641                	li	a2,16
    80004a9c:	4581                	li	a1,0
    80004a9e:	fc040513          	addi	a0,s0,-64
    80004aa2:	ffffb097          	auipc	ra,0xffffb
    80004aa6:	6d6080e7          	jalr	1750(ra) # 80000178 <memset>
    if (writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004aaa:	4741                	li	a4,16
    80004aac:	f2c42683          	lw	a3,-212(s0)
    80004ab0:	fc040613          	addi	a2,s0,-64
    80004ab4:	4581                	li	a1,0
    80004ab6:	8526                	mv	a0,s1
    80004ab8:	ffffe097          	auipc	ra,0xffffe
    80004abc:	4ca080e7          	jalr	1226(ra) # 80002f82 <writei>
    80004ac0:	47c1                	li	a5,16
    80004ac2:	0af51563          	bne	a0,a5,80004b6c <sys_unlink+0x17c>
    if (ip->type == T_DIR)
    80004ac6:	04491703          	lh	a4,68(s2)
    80004aca:	4785                	li	a5,1
    80004acc:	0af70863          	beq	a4,a5,80004b7c <sys_unlink+0x18c>
    iunlockput(dp);
    80004ad0:	8526                	mv	a0,s1
    80004ad2:	ffffe097          	auipc	ra,0xffffe
    80004ad6:	366080e7          	jalr	870(ra) # 80002e38 <iunlockput>
    ip->nlink--;
    80004ada:	04a95783          	lhu	a5,74(s2)
    80004ade:	37fd                	addiw	a5,a5,-1
    80004ae0:	04f91523          	sh	a5,74(s2)
    iupdate(ip);
    80004ae4:	854a                	mv	a0,s2
    80004ae6:	ffffe097          	auipc	ra,0xffffe
    80004aea:	026080e7          	jalr	38(ra) # 80002b0c <iupdate>
    iunlockput(ip);
    80004aee:	854a                	mv	a0,s2
    80004af0:	ffffe097          	auipc	ra,0xffffe
    80004af4:	348080e7          	jalr	840(ra) # 80002e38 <iunlockput>
    end_op();
    80004af8:	fffff097          	auipc	ra,0xfffff
    80004afc:	b20080e7          	jalr	-1248(ra) # 80003618 <end_op>
    return 0;
    80004b00:	4501                	li	a0,0
    80004b02:	a84d                	j	80004bb4 <sys_unlink+0x1c4>
        end_op();
    80004b04:	fffff097          	auipc	ra,0xfffff
    80004b08:	b14080e7          	jalr	-1260(ra) # 80003618 <end_op>
        return -1;
    80004b0c:	557d                	li	a0,-1
    80004b0e:	a05d                	j	80004bb4 <sys_unlink+0x1c4>
        panic("unlink: nlink < 1");
    80004b10:	00004517          	auipc	a0,0x4
    80004b14:	ba850513          	addi	a0,a0,-1112 # 800086b8 <syscalls+0x2c8>
    80004b18:	00001097          	auipc	ra,0x1
    80004b1c:	51a080e7          	jalr	1306(ra) # 80006032 <panic>
    for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de))
    80004b20:	04c92703          	lw	a4,76(s2)
    80004b24:	02000793          	li	a5,32
    80004b28:	f6e7f9e3          	bgeu	a5,a4,80004a9a <sys_unlink+0xaa>
    80004b2c:	02000993          	li	s3,32
        if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004b30:	4741                	li	a4,16
    80004b32:	86ce                	mv	a3,s3
    80004b34:	f1840613          	addi	a2,s0,-232
    80004b38:	4581                	li	a1,0
    80004b3a:	854a                	mv	a0,s2
    80004b3c:	ffffe097          	auipc	ra,0xffffe
    80004b40:	34e080e7          	jalr	846(ra) # 80002e8a <readi>
    80004b44:	47c1                	li	a5,16
    80004b46:	00f51b63          	bne	a0,a5,80004b5c <sys_unlink+0x16c>
        if (de.inum != 0)
    80004b4a:	f1845783          	lhu	a5,-232(s0)
    80004b4e:	e7a1                	bnez	a5,80004b96 <sys_unlink+0x1a6>
    for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de))
    80004b50:	29c1                	addiw	s3,s3,16
    80004b52:	04c92783          	lw	a5,76(s2)
    80004b56:	fcf9ede3          	bltu	s3,a5,80004b30 <sys_unlink+0x140>
    80004b5a:	b781                	j	80004a9a <sys_unlink+0xaa>
            panic("isdirempty: readi");
    80004b5c:	00004517          	auipc	a0,0x4
    80004b60:	b7450513          	addi	a0,a0,-1164 # 800086d0 <syscalls+0x2e0>
    80004b64:	00001097          	auipc	ra,0x1
    80004b68:	4ce080e7          	jalr	1230(ra) # 80006032 <panic>
        panic("unlink: writei");
    80004b6c:	00004517          	auipc	a0,0x4
    80004b70:	b7c50513          	addi	a0,a0,-1156 # 800086e8 <syscalls+0x2f8>
    80004b74:	00001097          	auipc	ra,0x1
    80004b78:	4be080e7          	jalr	1214(ra) # 80006032 <panic>
        dp->nlink--;
    80004b7c:	04a4d783          	lhu	a5,74(s1)
    80004b80:	37fd                	addiw	a5,a5,-1
    80004b82:	04f49523          	sh	a5,74(s1)
        iupdate(dp);
    80004b86:	8526                	mv	a0,s1
    80004b88:	ffffe097          	auipc	ra,0xffffe
    80004b8c:	f84080e7          	jalr	-124(ra) # 80002b0c <iupdate>
    80004b90:	b781                	j	80004ad0 <sys_unlink+0xe0>
        return -1;
    80004b92:	557d                	li	a0,-1
    80004b94:	a005                	j	80004bb4 <sys_unlink+0x1c4>
        iunlockput(ip);
    80004b96:	854a                	mv	a0,s2
    80004b98:	ffffe097          	auipc	ra,0xffffe
    80004b9c:	2a0080e7          	jalr	672(ra) # 80002e38 <iunlockput>
    iunlockput(dp);
    80004ba0:	8526                	mv	a0,s1
    80004ba2:	ffffe097          	auipc	ra,0xffffe
    80004ba6:	296080e7          	jalr	662(ra) # 80002e38 <iunlockput>
    end_op();
    80004baa:	fffff097          	auipc	ra,0xfffff
    80004bae:	a6e080e7          	jalr	-1426(ra) # 80003618 <end_op>
    return -1;
    80004bb2:	557d                	li	a0,-1
}
    80004bb4:	70ae                	ld	ra,232(sp)
    80004bb6:	740e                	ld	s0,224(sp)
    80004bb8:	64ee                	ld	s1,216(sp)
    80004bba:	694e                	ld	s2,208(sp)
    80004bbc:	69ae                	ld	s3,200(sp)
    80004bbe:	616d                	addi	sp,sp,240
    80004bc0:	8082                	ret

0000000080004bc2 <sys_mmap>:
{
    80004bc2:	711d                	addi	sp,sp,-96
    80004bc4:	ec86                	sd	ra,88(sp)
    80004bc6:	e8a2                	sd	s0,80(sp)
    80004bc8:	e4a6                	sd	s1,72(sp)
    80004bca:	e0ca                	sd	s2,64(sp)
    80004bcc:	fc4e                	sd	s3,56(sp)
    80004bce:	f852                	sd	s4,48(sp)
    80004bd0:	1080                	addi	s0,sp,96
    argaddr(0, &addr);
    80004bd2:	fc840593          	addi	a1,s0,-56
    80004bd6:	4501                	li	a0,0
    80004bd8:	ffffd097          	auipc	ra,0xffffd
    80004bdc:	4a4080e7          	jalr	1188(ra) # 8000207c <argaddr>
    argaddr(1, &length);
    80004be0:	fc040593          	addi	a1,s0,-64
    80004be4:	4505                	li	a0,1
    80004be6:	ffffd097          	auipc	ra,0xffffd
    80004bea:	496080e7          	jalr	1174(ra) # 8000207c <argaddr>
    argint(2, &prot);
    80004bee:	fbc40593          	addi	a1,s0,-68
    80004bf2:	4509                	li	a0,2
    80004bf4:	ffffd097          	auipc	ra,0xffffd
    80004bf8:	468080e7          	jalr	1128(ra) # 8000205c <argint>
    argint(3, &flags);
    80004bfc:	fb840593          	addi	a1,s0,-72
    80004c00:	450d                	li	a0,3
    80004c02:	ffffd097          	auipc	ra,0xffffd
    80004c06:	45a080e7          	jalr	1114(ra) # 8000205c <argint>
    argfd(4, &fd, &pf);
    80004c0a:	fa040613          	addi	a2,s0,-96
    80004c0e:	fb440593          	addi	a1,s0,-76
    80004c12:	4511                	li	a0,4
    80004c14:	00000097          	auipc	ra,0x0
    80004c18:	8d2080e7          	jalr	-1838(ra) # 800044e6 <argfd>
    argaddr(5, &offset);
    80004c1c:	fa840593          	addi	a1,s0,-88
    80004c20:	4515                	li	a0,5
    80004c22:	ffffd097          	auipc	ra,0xffffd
    80004c26:	45a080e7          	jalr	1114(ra) # 8000207c <argaddr>
    if ((prot & PROT_WRITE) && (flags & MAP_SHARED) && (!pf->writable))
    80004c2a:	fbc42783          	lw	a5,-68(s0)
    80004c2e:	0027f713          	andi	a4,a5,2
    80004c32:	cb11                	beqz	a4,80004c46 <sys_mmap+0x84>
    80004c34:	fb842703          	lw	a4,-72(s0)
    80004c38:	8b05                	andi	a4,a4,1
    80004c3a:	c711                	beqz	a4,80004c46 <sys_mmap+0x84>
    80004c3c:	fa043703          	ld	a4,-96(s0)
    80004c40:	00974703          	lbu	a4,9(a4)
    80004c44:	c71d                	beqz	a4,80004c72 <sys_mmap+0xb0>
    if ((prot & PROT_READ) && (!pf->readable))
    80004c46:	8b85                	andi	a5,a5,1
    80004c48:	c791                	beqz	a5,80004c54 <sys_mmap+0x92>
    80004c4a:	fa043783          	ld	a5,-96(s0)
    80004c4e:	0087c783          	lbu	a5,8(a5)
    80004c52:	cb95                	beqz	a5,80004c86 <sys_mmap+0xc4>
    struct proc *p_proc = myproc(); // create a pointer to process struct
    80004c54:	ffffc097          	auipc	ra,0xffffc
    80004c58:	20e080e7          	jalr	526(ra) # 80000e62 <myproc>
    80004c5c:	892a                	mv	s2,a0
            if (p_proc->sz + length <= MAXVA)
    80004c5e:	fc043503          	ld	a0,-64(s0)
    80004c62:	16890793          	addi	a5,s2,360
    for (int i = 0; i <= VMASIZE - 1; i++)
    80004c66:	4481                	li	s1,0
        if (p_proc->vma[i].occupied != 1)
    80004c68:	4685                	li	a3,1
            if (p_proc->sz + length <= MAXVA)
    80004c6a:	02669593          	slli	a1,a3,0x26
    for (int i = 0; i <= VMASIZE - 1; i++)
    80004c6e:	4641                	li	a2,16
    80004c70:	a815                	j	80004ca4 <sys_mmap+0xe2>
        printf("[Testing] (sys_mmap) : not writable but write and map shared\n");
    80004c72:	00004517          	auipc	a0,0x4
    80004c76:	a8650513          	addi	a0,a0,-1402 # 800086f8 <syscalls+0x308>
    80004c7a:	00001097          	auipc	ra,0x1
    80004c7e:	402080e7          	jalr	1026(ra) # 8000607c <printf>
        return -1;
    80004c82:	557d                	li	a0,-1
    80004c84:	a8e1                	j	80004d5c <sys_mmap+0x19a>
        printf("[Testing] (sys_mmap) : not readable but read\n");
    80004c86:	00004517          	auipc	a0,0x4
    80004c8a:	ab250513          	addi	a0,a0,-1358 # 80008738 <syscalls+0x348>
    80004c8e:	00001097          	auipc	ra,0x1
    80004c92:	3ee080e7          	jalr	1006(ra) # 8000607c <printf>
        return -1;
    80004c96:	557d                	li	a0,-1
    80004c98:	a0d1                	j	80004d5c <sys_mmap+0x19a>
    for (int i = 0; i <= VMASIZE - 1; i++)
    80004c9a:	2485                	addiw	s1,s1,1
    80004c9c:	04878793          	addi	a5,a5,72
    80004ca0:	0cc48663          	beq	s1,a2,80004d6c <sys_mmap+0x1aa>
        if (p_proc->vma[i].occupied != 1)
    80004ca4:	4398                	lw	a4,0(a5)
    80004ca6:	fed70ae3          	beq	a4,a3,80004c9a <sys_mmap+0xd8>
            if (p_proc->sz + length <= MAXVA)
    80004caa:	04893703          	ld	a4,72(s2)
    80004cae:	972a                	add	a4,a4,a0
    80004cb0:	fee5e5e3          	bltu	a1,a4,80004c9a <sys_mmap+0xd8>
                printf("[Testing] (sys_mmap) : find vma : %d \n", i);
    80004cb4:	85a6                	mv	a1,s1
    80004cb6:	00004517          	auipc	a0,0x4
    80004cba:	ab250513          	addi	a0,a0,-1358 # 80008768 <syscalls+0x378>
    80004cbe:	00001097          	auipc	ra,0x1
    80004cc2:	3be080e7          	jalr	958(ra) # 8000607c <printf>
        p_vma->occupied = 1; // denote it is occupied
    80004cc6:	00349a13          	slli	s4,s1,0x3
    80004cca:	009a09b3          	add	s3,s4,s1
    80004cce:	098e                	slli	s3,s3,0x3
    80004cd0:	99ca                	add	s3,s3,s2
    80004cd2:	4785                	li	a5,1
    80004cd4:	16f9a423          	sw	a5,360(s3)
        p_vma->start_addr = (uint64)(p_proc->sz);
    80004cd8:	04893583          	ld	a1,72(s2)
    80004cdc:	16b9b823          	sd	a1,368(s3)
        printf("[Testing] (sys_mmap) : find vma : start : %d \n", p_vma->start_addr);
    80004ce0:	00004517          	auipc	a0,0x4
    80004ce4:	ab050513          	addi	a0,a0,-1360 # 80008790 <syscalls+0x3a0>
    80004ce8:	00001097          	auipc	ra,0x1
    80004cec:	394080e7          	jalr	916(ra) # 8000607c <printf>
        p_vma->end_addr = (uint64)(p_proc->sz + length);
    80004cf0:	04893583          	ld	a1,72(s2)
    80004cf4:	fc043783          	ld	a5,-64(s0)
    80004cf8:	95be                	add	a1,a1,a5
    80004cfa:	16b9bc23          	sd	a1,376(s3)
        printf("[Testing] (sys_mmap) : find vma : end : %d\n", p_vma->end_addr);
    80004cfe:	00004517          	auipc	a0,0x4
    80004d02:	ac250513          	addi	a0,a0,-1342 # 800087c0 <syscalls+0x3d0>
    80004d06:	00001097          	auipc	ra,0x1
    80004d0a:	376080e7          	jalr	886(ra) # 8000607c <printf>
        p_proc->sz += length;
    80004d0e:	fc043703          	ld	a4,-64(s0)
    80004d12:	04893783          	ld	a5,72(s2)
    80004d16:	97ba                	add	a5,a5,a4
    80004d18:	04f93423          	sd	a5,72(s2)
        p_vma->addr = (uint64)addr;
    80004d1c:	fc843783          	ld	a5,-56(s0)
    80004d20:	18f9b023          	sd	a5,384(s3)
        p_vma->length = length;
    80004d24:	18e9b423          	sd	a4,392(s3)
        p_vma->prot = prot;
    80004d28:	fbc42783          	lw	a5,-68(s0)
    80004d2c:	18f9a823          	sw	a5,400(s3)
        p_vma->flags = flags;
    80004d30:	fb842783          	lw	a5,-72(s0)
    80004d34:	18f9aa23          	sw	a5,404(s3)
        p_vma->fd = fd;
    80004d38:	fb442783          	lw	a5,-76(s0)
    80004d3c:	18f9ac23          	sw	a5,408(s3)
        p_vma->offset = offset;
    80004d40:	fa843783          	ld	a5,-88(s0)
    80004d44:	1af9b023          	sd	a5,416(s3)
        p_vma->pf = pf;
    80004d48:	fa043503          	ld	a0,-96(s0)
    80004d4c:	1aa9b423          	sd	a0,424(s3)
        filedup(p_vma->pf);
    80004d50:	fffff097          	auipc	ra,0xfffff
    80004d54:	cc2080e7          	jalr	-830(ra) # 80003a12 <filedup>
        return (p_vma->start_addr);
    80004d58:	1709b503          	ld	a0,368(s3)
}
    80004d5c:	60e6                	ld	ra,88(sp)
    80004d5e:	6446                	ld	s0,80(sp)
    80004d60:	64a6                	ld	s1,72(sp)
    80004d62:	6906                	ld	s2,64(sp)
    80004d64:	79e2                	ld	s3,56(sp)
    80004d66:	7a42                	ld	s4,48(sp)
    80004d68:	6125                	addi	sp,sp,96
    80004d6a:	8082                	ret
        panic("syscall mmap");
    80004d6c:	00004517          	auipc	a0,0x4
    80004d70:	a8450513          	addi	a0,a0,-1404 # 800087f0 <syscalls+0x400>
    80004d74:	00001097          	auipc	ra,0x1
    80004d78:	2be080e7          	jalr	702(ra) # 80006032 <panic>

0000000080004d7c <sys_munmap>:
{
    80004d7c:	7139                	addi	sp,sp,-64
    80004d7e:	fc06                	sd	ra,56(sp)
    80004d80:	f822                	sd	s0,48(sp)
    80004d82:	f426                	sd	s1,40(sp)
    80004d84:	f04a                	sd	s2,32(sp)
    80004d86:	ec4e                	sd	s3,24(sp)
    80004d88:	0080                	addi	s0,sp,64
    argaddr(0, &addr);
    80004d8a:	fc840593          	addi	a1,s0,-56
    80004d8e:	4501                	li	a0,0
    80004d90:	ffffd097          	auipc	ra,0xffffd
    80004d94:	2ec080e7          	jalr	748(ra) # 8000207c <argaddr>
    argaddr(1, &length);
    80004d98:	fc040593          	addi	a1,s0,-64
    80004d9c:	4505                	li	a0,1
    80004d9e:	ffffd097          	auipc	ra,0xffffd
    80004da2:	2de080e7          	jalr	734(ra) # 8000207c <argaddr>
    struct proc *p_proc = myproc(); // create a pointer to process struct
    80004da6:	ffffc097          	auipc	ra,0xffffc
    80004daa:	0bc080e7          	jalr	188(ra) # 80000e62 <myproc>
    80004dae:	892a                	mv	s2,a0
        if ((p_proc->vma[i].start_addr <= addr) && (addr <= p_proc->vma[i].end_addr))
    80004db0:	fc843683          	ld	a3,-56(s0)
    80004db4:	17050793          	addi	a5,a0,368
    for (int i = 0; i <= VMASIZE - 1; i++)
    80004db8:	4481                	li	s1,0
    80004dba:	4641                	li	a2,16
    80004dbc:	a031                	j	80004dc8 <sys_munmap+0x4c>
    80004dbe:	2485                	addiw	s1,s1,1
    80004dc0:	04878793          	addi	a5,a5,72
    80004dc4:	0cc48763          	beq	s1,a2,80004e92 <sys_munmap+0x116>
        if ((p_proc->vma[i].start_addr <= addr) && (addr <= p_proc->vma[i].end_addr))
    80004dc8:	6398                	ld	a4,0(a5)
    80004dca:	fee6eae3          	bltu	a3,a4,80004dbe <sys_munmap+0x42>
    80004dce:	6798                	ld	a4,8(a5)
    80004dd0:	fed767e3          	bltu	a4,a3,80004dbe <sys_munmap+0x42>
            printf("[Testing] (sys_munmap): find vma %d\n", i);
    80004dd4:	85a6                	mv	a1,s1
    80004dd6:	00004517          	auipc	a0,0x4
    80004dda:	a2a50513          	addi	a0,a0,-1494 # 80008800 <syscalls+0x410>
    80004dde:	00001097          	auipc	ra,0x1
    80004de2:	29e080e7          	jalr	670(ra) # 8000607c <printf>
            printf("[Testing] (sys_munmap): vma start address %d\n", p_proc->vma[i].start_addr);
    80004de6:	00349993          	slli	s3,s1,0x3
    80004dea:	99a6                	add	s3,s3,s1
    80004dec:	098e                	slli	s3,s3,0x3
    80004dee:	99ca                	add	s3,s3,s2
    80004df0:	1709b583          	ld	a1,368(s3)
    80004df4:	00004517          	auipc	a0,0x4
    80004df8:	a3450513          	addi	a0,a0,-1484 # 80008828 <syscalls+0x438>
    80004dfc:	00001097          	auipc	ra,0x1
    80004e00:	280080e7          	jalr	640(ra) # 8000607c <printf>
        if ((p_vma->flags & MAP_SHARED) != 0)
    80004e04:	1949a783          	lw	a5,404(s3)
    80004e08:	8b85                	andi	a5,a5,1
    80004e0a:	efc1                	bnez	a5,80004ea2 <sys_munmap+0x126>
        printf("[Testing] (sys_munmap) : start: %d\n", p_vma->start_addr);
    80004e0c:	00349993          	slli	s3,s1,0x3
    80004e10:	99a6                	add	s3,s3,s1
    80004e12:	098e                	slli	s3,s3,0x3
    80004e14:	99ca                	add	s3,s3,s2
    80004e16:	1709b583          	ld	a1,368(s3)
    80004e1a:	00004517          	auipc	a0,0x4
    80004e1e:	a3e50513          	addi	a0,a0,-1474 # 80008858 <syscalls+0x468>
    80004e22:	00001097          	auipc	ra,0x1
    80004e26:	25a080e7          	jalr	602(ra) # 8000607c <printf>
        printf("[Testing] (sys_munmap) : length: %d\n", length);
    80004e2a:	fc043583          	ld	a1,-64(s0)
    80004e2e:	00004517          	auipc	a0,0x4
    80004e32:	a5250513          	addi	a0,a0,-1454 # 80008880 <syscalls+0x490>
    80004e36:	00001097          	auipc	ra,0x1
    80004e3a:	246080e7          	jalr	582(ra) # 8000607c <printf>
        uvmunmap(p_proc->pagetable, p_vma->start_addr, length / PGSIZE, 1);
    80004e3e:	4685                	li	a3,1
    80004e40:	fc043603          	ld	a2,-64(s0)
    80004e44:	8231                	srli	a2,a2,0xc
    80004e46:	1709b583          	ld	a1,368(s3)
    80004e4a:	05093503          	ld	a0,80(s2)
    80004e4e:	ffffc097          	auipc	ra,0xffffc
    80004e52:	8e8080e7          	jalr	-1816(ra) # 80000736 <uvmunmap>
        p_vma->start_addr += length;
    80004e56:	1709b783          	ld	a5,368(s3)
    80004e5a:	fc043703          	ld	a4,-64(s0)
    80004e5e:	97ba                	add	a5,a5,a4
    80004e60:	16f9b823          	sd	a5,368(s3)
        if (p_vma->start_addr == p_vma->end_addr)
    80004e64:	1789b703          	ld	a4,376(s3)
        return 0;
    80004e68:	4501                	li	a0,0
        if (p_vma->start_addr == p_vma->end_addr)
    80004e6a:	02e79563          	bne	a5,a4,80004e94 <sys_munmap+0x118>
            printf("[Testing] (sys_munmap) : whole vma closed\n");
    80004e6e:	00004517          	auipc	a0,0x4
    80004e72:	a3a50513          	addi	a0,a0,-1478 # 800088a8 <syscalls+0x4b8>
    80004e76:	00001097          	auipc	ra,0x1
    80004e7a:	206080e7          	jalr	518(ra) # 8000607c <printf>
            p_vma->occupied = 0;
    80004e7e:	1609a423          	sw	zero,360(s3)
            fileclose(p_vma->pf);
    80004e82:	1a89b503          	ld	a0,424(s3)
    80004e86:	fffff097          	auipc	ra,0xfffff
    80004e8a:	bde080e7          	jalr	-1058(ra) # 80003a64 <fileclose>
            return 0;
    80004e8e:	4501                	li	a0,0
    80004e90:	a011                	j	80004e94 <sys_munmap+0x118>
        return -1;
    80004e92:	557d                	li	a0,-1
}
    80004e94:	70e2                	ld	ra,56(sp)
    80004e96:	7442                	ld	s0,48(sp)
    80004e98:	74a2                	ld	s1,40(sp)
    80004e9a:	7902                	ld	s2,32(sp)
    80004e9c:	69e2                	ld	s3,24(sp)
    80004e9e:	6121                	addi	sp,sp,64
    80004ea0:	8082                	ret
            filewrite(p_vma->pf, p_vma->start_addr, length);
    80004ea2:	00349793          	slli	a5,s1,0x3
    80004ea6:	97a6                	add	a5,a5,s1
    80004ea8:	078e                	slli	a5,a5,0x3
    80004eaa:	97ca                	add	a5,a5,s2
    80004eac:	fc042603          	lw	a2,-64(s0)
    80004eb0:	1707b583          	ld	a1,368(a5)
    80004eb4:	1a87b503          	ld	a0,424(a5)
    80004eb8:	fffff097          	auipc	ra,0xfffff
    80004ebc:	e02080e7          	jalr	-510(ra) # 80003cba <filewrite>
    80004ec0:	b7b1                	j	80004e0c <sys_munmap+0x90>

0000000080004ec2 <sys_open>:

uint64
sys_open(void)
{
    80004ec2:	7131                	addi	sp,sp,-192
    80004ec4:	fd06                	sd	ra,184(sp)
    80004ec6:	f922                	sd	s0,176(sp)
    80004ec8:	f526                	sd	s1,168(sp)
    80004eca:	f14a                	sd	s2,160(sp)
    80004ecc:	ed4e                	sd	s3,152(sp)
    80004ece:	0180                	addi	s0,sp,192
    int fd, omode;
    struct file *f;
    struct inode *ip;
    int n;

    argint(1, &omode);
    80004ed0:	f4c40593          	addi	a1,s0,-180
    80004ed4:	4505                	li	a0,1
    80004ed6:	ffffd097          	auipc	ra,0xffffd
    80004eda:	186080e7          	jalr	390(ra) # 8000205c <argint>
    if ((n = argstr(0, path, MAXPATH)) < 0)
    80004ede:	08000613          	li	a2,128
    80004ee2:	f5040593          	addi	a1,s0,-176
    80004ee6:	4501                	li	a0,0
    80004ee8:	ffffd097          	auipc	ra,0xffffd
    80004eec:	1b4080e7          	jalr	436(ra) # 8000209c <argstr>
    80004ef0:	87aa                	mv	a5,a0
        return -1;
    80004ef2:	557d                	li	a0,-1
    if ((n = argstr(0, path, MAXPATH)) < 0)
    80004ef4:	0a07c963          	bltz	a5,80004fa6 <sys_open+0xe4>

    begin_op();
    80004ef8:	ffffe097          	auipc	ra,0xffffe
    80004efc:	6a0080e7          	jalr	1696(ra) # 80003598 <begin_op>

    if (omode & O_CREATE)
    80004f00:	f4c42783          	lw	a5,-180(s0)
    80004f04:	2007f793          	andi	a5,a5,512
    80004f08:	cfc5                	beqz	a5,80004fc0 <sys_open+0xfe>
    {
        ip = create(path, T_FILE, 0, 0);
    80004f0a:	4681                	li	a3,0
    80004f0c:	4601                	li	a2,0
    80004f0e:	4589                	li	a1,2
    80004f10:	f5040513          	addi	a0,s0,-176
    80004f14:	fffff097          	auipc	ra,0xfffff
    80004f18:	674080e7          	jalr	1652(ra) # 80004588 <create>
    80004f1c:	84aa                	mv	s1,a0
        if (ip == 0)
    80004f1e:	c959                	beqz	a0,80004fb4 <sys_open+0xf2>
            end_op();
            return -1;
        }
    }

    if (ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV))
    80004f20:	04449703          	lh	a4,68(s1)
    80004f24:	478d                	li	a5,3
    80004f26:	00f71763          	bne	a4,a5,80004f34 <sys_open+0x72>
    80004f2a:	0464d703          	lhu	a4,70(s1)
    80004f2e:	47a5                	li	a5,9
    80004f30:	0ce7ed63          	bltu	a5,a4,8000500a <sys_open+0x148>
        iunlockput(ip);
        end_op();
        return -1;
    }

    if ((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0)
    80004f34:	fffff097          	auipc	ra,0xfffff
    80004f38:	a74080e7          	jalr	-1420(ra) # 800039a8 <filealloc>
    80004f3c:	89aa                	mv	s3,a0
    80004f3e:	10050363          	beqz	a0,80005044 <sys_open+0x182>
    80004f42:	fffff097          	auipc	ra,0xfffff
    80004f46:	604080e7          	jalr	1540(ra) # 80004546 <fdalloc>
    80004f4a:	892a                	mv	s2,a0
    80004f4c:	0e054763          	bltz	a0,8000503a <sys_open+0x178>
        iunlockput(ip);
        end_op();
        return -1;
    }

    if (ip->type == T_DEVICE)
    80004f50:	04449703          	lh	a4,68(s1)
    80004f54:	478d                	li	a5,3
    80004f56:	0cf70563          	beq	a4,a5,80005020 <sys_open+0x15e>
        f->type = FD_DEVICE;
        f->major = ip->major;
    }
    else
    {
        f->type = FD_INODE;
    80004f5a:	4789                	li	a5,2
    80004f5c:	00f9a023          	sw	a5,0(s3)
        f->off = 0;
    80004f60:	0209a023          	sw	zero,32(s3)
    }
    f->ip = ip;
    80004f64:	0099bc23          	sd	s1,24(s3)
    f->readable = !(omode & O_WRONLY);
    80004f68:	f4c42783          	lw	a5,-180(s0)
    80004f6c:	0017c713          	xori	a4,a5,1
    80004f70:	8b05                	andi	a4,a4,1
    80004f72:	00e98423          	sb	a4,8(s3)
    f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004f76:	0037f713          	andi	a4,a5,3
    80004f7a:	00e03733          	snez	a4,a4
    80004f7e:	00e984a3          	sb	a4,9(s3)

    if ((omode & O_TRUNC) && ip->type == T_FILE)
    80004f82:	4007f793          	andi	a5,a5,1024
    80004f86:	c791                	beqz	a5,80004f92 <sys_open+0xd0>
    80004f88:	04449703          	lh	a4,68(s1)
    80004f8c:	4789                	li	a5,2
    80004f8e:	0af70063          	beq	a4,a5,8000502e <sys_open+0x16c>
    {
        itrunc(ip);
    }

    iunlock(ip);
    80004f92:	8526                	mv	a0,s1
    80004f94:	ffffe097          	auipc	ra,0xffffe
    80004f98:	d04080e7          	jalr	-764(ra) # 80002c98 <iunlock>
    end_op();
    80004f9c:	ffffe097          	auipc	ra,0xffffe
    80004fa0:	67c080e7          	jalr	1660(ra) # 80003618 <end_op>

    return fd;
    80004fa4:	854a                	mv	a0,s2
}
    80004fa6:	70ea                	ld	ra,184(sp)
    80004fa8:	744a                	ld	s0,176(sp)
    80004faa:	74aa                	ld	s1,168(sp)
    80004fac:	790a                	ld	s2,160(sp)
    80004fae:	69ea                	ld	s3,152(sp)
    80004fb0:	6129                	addi	sp,sp,192
    80004fb2:	8082                	ret
            end_op();
    80004fb4:	ffffe097          	auipc	ra,0xffffe
    80004fb8:	664080e7          	jalr	1636(ra) # 80003618 <end_op>
            return -1;
    80004fbc:	557d                	li	a0,-1
    80004fbe:	b7e5                	j	80004fa6 <sys_open+0xe4>
        if ((ip = namei(path)) == 0)
    80004fc0:	f5040513          	addi	a0,s0,-176
    80004fc4:	ffffe097          	auipc	ra,0xffffe
    80004fc8:	3b8080e7          	jalr	952(ra) # 8000337c <namei>
    80004fcc:	84aa                	mv	s1,a0
    80004fce:	c905                	beqz	a0,80004ffe <sys_open+0x13c>
        ilock(ip);
    80004fd0:	ffffe097          	auipc	ra,0xffffe
    80004fd4:	c06080e7          	jalr	-1018(ra) # 80002bd6 <ilock>
        if (ip->type == T_DIR && omode != O_RDONLY)
    80004fd8:	04449703          	lh	a4,68(s1)
    80004fdc:	4785                	li	a5,1
    80004fde:	f4f711e3          	bne	a4,a5,80004f20 <sys_open+0x5e>
    80004fe2:	f4c42783          	lw	a5,-180(s0)
    80004fe6:	d7b9                	beqz	a5,80004f34 <sys_open+0x72>
            iunlockput(ip);
    80004fe8:	8526                	mv	a0,s1
    80004fea:	ffffe097          	auipc	ra,0xffffe
    80004fee:	e4e080e7          	jalr	-434(ra) # 80002e38 <iunlockput>
            end_op();
    80004ff2:	ffffe097          	auipc	ra,0xffffe
    80004ff6:	626080e7          	jalr	1574(ra) # 80003618 <end_op>
            return -1;
    80004ffa:	557d                	li	a0,-1
    80004ffc:	b76d                	j	80004fa6 <sys_open+0xe4>
            end_op();
    80004ffe:	ffffe097          	auipc	ra,0xffffe
    80005002:	61a080e7          	jalr	1562(ra) # 80003618 <end_op>
            return -1;
    80005006:	557d                	li	a0,-1
    80005008:	bf79                	j	80004fa6 <sys_open+0xe4>
        iunlockput(ip);
    8000500a:	8526                	mv	a0,s1
    8000500c:	ffffe097          	auipc	ra,0xffffe
    80005010:	e2c080e7          	jalr	-468(ra) # 80002e38 <iunlockput>
        end_op();
    80005014:	ffffe097          	auipc	ra,0xffffe
    80005018:	604080e7          	jalr	1540(ra) # 80003618 <end_op>
        return -1;
    8000501c:	557d                	li	a0,-1
    8000501e:	b761                	j	80004fa6 <sys_open+0xe4>
        f->type = FD_DEVICE;
    80005020:	00f9a023          	sw	a5,0(s3)
        f->major = ip->major;
    80005024:	04649783          	lh	a5,70(s1)
    80005028:	02f99223          	sh	a5,36(s3)
    8000502c:	bf25                	j	80004f64 <sys_open+0xa2>
        itrunc(ip);
    8000502e:	8526                	mv	a0,s1
    80005030:	ffffe097          	auipc	ra,0xffffe
    80005034:	cb4080e7          	jalr	-844(ra) # 80002ce4 <itrunc>
    80005038:	bfa9                	j	80004f92 <sys_open+0xd0>
            fileclose(f);
    8000503a:	854e                	mv	a0,s3
    8000503c:	fffff097          	auipc	ra,0xfffff
    80005040:	a28080e7          	jalr	-1496(ra) # 80003a64 <fileclose>
        iunlockput(ip);
    80005044:	8526                	mv	a0,s1
    80005046:	ffffe097          	auipc	ra,0xffffe
    8000504a:	df2080e7          	jalr	-526(ra) # 80002e38 <iunlockput>
        end_op();
    8000504e:	ffffe097          	auipc	ra,0xffffe
    80005052:	5ca080e7          	jalr	1482(ra) # 80003618 <end_op>
        return -1;
    80005056:	557d                	li	a0,-1
    80005058:	b7b9                	j	80004fa6 <sys_open+0xe4>

000000008000505a <sys_mkdir>:

uint64
sys_mkdir(void)
{
    8000505a:	7175                	addi	sp,sp,-144
    8000505c:	e506                	sd	ra,136(sp)
    8000505e:	e122                	sd	s0,128(sp)
    80005060:	0900                	addi	s0,sp,144
    char path[MAXPATH];
    struct inode *ip;

    begin_op();
    80005062:	ffffe097          	auipc	ra,0xffffe
    80005066:	536080e7          	jalr	1334(ra) # 80003598 <begin_op>
    if (argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0)
    8000506a:	08000613          	li	a2,128
    8000506e:	f7040593          	addi	a1,s0,-144
    80005072:	4501                	li	a0,0
    80005074:	ffffd097          	auipc	ra,0xffffd
    80005078:	028080e7          	jalr	40(ra) # 8000209c <argstr>
    8000507c:	02054963          	bltz	a0,800050ae <sys_mkdir+0x54>
    80005080:	4681                	li	a3,0
    80005082:	4601                	li	a2,0
    80005084:	4585                	li	a1,1
    80005086:	f7040513          	addi	a0,s0,-144
    8000508a:	fffff097          	auipc	ra,0xfffff
    8000508e:	4fe080e7          	jalr	1278(ra) # 80004588 <create>
    80005092:	cd11                	beqz	a0,800050ae <sys_mkdir+0x54>
    {
        end_op();
        return -1;
    }
    iunlockput(ip);
    80005094:	ffffe097          	auipc	ra,0xffffe
    80005098:	da4080e7          	jalr	-604(ra) # 80002e38 <iunlockput>
    end_op();
    8000509c:	ffffe097          	auipc	ra,0xffffe
    800050a0:	57c080e7          	jalr	1404(ra) # 80003618 <end_op>
    return 0;
    800050a4:	4501                	li	a0,0
}
    800050a6:	60aa                	ld	ra,136(sp)
    800050a8:	640a                	ld	s0,128(sp)
    800050aa:	6149                	addi	sp,sp,144
    800050ac:	8082                	ret
        end_op();
    800050ae:	ffffe097          	auipc	ra,0xffffe
    800050b2:	56a080e7          	jalr	1386(ra) # 80003618 <end_op>
        return -1;
    800050b6:	557d                	li	a0,-1
    800050b8:	b7fd                	j	800050a6 <sys_mkdir+0x4c>

00000000800050ba <sys_mknod>:

uint64
sys_mknod(void)
{
    800050ba:	7135                	addi	sp,sp,-160
    800050bc:	ed06                	sd	ra,152(sp)
    800050be:	e922                	sd	s0,144(sp)
    800050c0:	1100                	addi	s0,sp,160
    struct inode *ip;
    char path[MAXPATH];
    int major, minor;

    begin_op();
    800050c2:	ffffe097          	auipc	ra,0xffffe
    800050c6:	4d6080e7          	jalr	1238(ra) # 80003598 <begin_op>
    argint(1, &major);
    800050ca:	f6c40593          	addi	a1,s0,-148
    800050ce:	4505                	li	a0,1
    800050d0:	ffffd097          	auipc	ra,0xffffd
    800050d4:	f8c080e7          	jalr	-116(ra) # 8000205c <argint>
    argint(2, &minor);
    800050d8:	f6840593          	addi	a1,s0,-152
    800050dc:	4509                	li	a0,2
    800050de:	ffffd097          	auipc	ra,0xffffd
    800050e2:	f7e080e7          	jalr	-130(ra) # 8000205c <argint>
    if ((argstr(0, path, MAXPATH)) < 0 ||
    800050e6:	08000613          	li	a2,128
    800050ea:	f7040593          	addi	a1,s0,-144
    800050ee:	4501                	li	a0,0
    800050f0:	ffffd097          	auipc	ra,0xffffd
    800050f4:	fac080e7          	jalr	-84(ra) # 8000209c <argstr>
    800050f8:	02054b63          	bltz	a0,8000512e <sys_mknod+0x74>
        (ip = create(path, T_DEVICE, major, minor)) == 0)
    800050fc:	f6841683          	lh	a3,-152(s0)
    80005100:	f6c41603          	lh	a2,-148(s0)
    80005104:	458d                	li	a1,3
    80005106:	f7040513          	addi	a0,s0,-144
    8000510a:	fffff097          	auipc	ra,0xfffff
    8000510e:	47e080e7          	jalr	1150(ra) # 80004588 <create>
    if ((argstr(0, path, MAXPATH)) < 0 ||
    80005112:	cd11                	beqz	a0,8000512e <sys_mknod+0x74>
    {
        end_op();
        return -1;
    }
    iunlockput(ip);
    80005114:	ffffe097          	auipc	ra,0xffffe
    80005118:	d24080e7          	jalr	-732(ra) # 80002e38 <iunlockput>
    end_op();
    8000511c:	ffffe097          	auipc	ra,0xffffe
    80005120:	4fc080e7          	jalr	1276(ra) # 80003618 <end_op>
    return 0;
    80005124:	4501                	li	a0,0
}
    80005126:	60ea                	ld	ra,152(sp)
    80005128:	644a                	ld	s0,144(sp)
    8000512a:	610d                	addi	sp,sp,160
    8000512c:	8082                	ret
        end_op();
    8000512e:	ffffe097          	auipc	ra,0xffffe
    80005132:	4ea080e7          	jalr	1258(ra) # 80003618 <end_op>
        return -1;
    80005136:	557d                	li	a0,-1
    80005138:	b7fd                	j	80005126 <sys_mknod+0x6c>

000000008000513a <sys_chdir>:

uint64
sys_chdir(void)
{
    8000513a:	7135                	addi	sp,sp,-160
    8000513c:	ed06                	sd	ra,152(sp)
    8000513e:	e922                	sd	s0,144(sp)
    80005140:	e526                	sd	s1,136(sp)
    80005142:	e14a                	sd	s2,128(sp)
    80005144:	1100                	addi	s0,sp,160
    char path[MAXPATH];
    struct inode *ip;
    struct proc *p = myproc();
    80005146:	ffffc097          	auipc	ra,0xffffc
    8000514a:	d1c080e7          	jalr	-740(ra) # 80000e62 <myproc>
    8000514e:	892a                	mv	s2,a0

    begin_op();
    80005150:	ffffe097          	auipc	ra,0xffffe
    80005154:	448080e7          	jalr	1096(ra) # 80003598 <begin_op>
    if (argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0)
    80005158:	08000613          	li	a2,128
    8000515c:	f6040593          	addi	a1,s0,-160
    80005160:	4501                	li	a0,0
    80005162:	ffffd097          	auipc	ra,0xffffd
    80005166:	f3a080e7          	jalr	-198(ra) # 8000209c <argstr>
    8000516a:	04054b63          	bltz	a0,800051c0 <sys_chdir+0x86>
    8000516e:	f6040513          	addi	a0,s0,-160
    80005172:	ffffe097          	auipc	ra,0xffffe
    80005176:	20a080e7          	jalr	522(ra) # 8000337c <namei>
    8000517a:	84aa                	mv	s1,a0
    8000517c:	c131                	beqz	a0,800051c0 <sys_chdir+0x86>
    {
        end_op();
        return -1;
    }
    ilock(ip);
    8000517e:	ffffe097          	auipc	ra,0xffffe
    80005182:	a58080e7          	jalr	-1448(ra) # 80002bd6 <ilock>
    if (ip->type != T_DIR)
    80005186:	04449703          	lh	a4,68(s1)
    8000518a:	4785                	li	a5,1
    8000518c:	04f71063          	bne	a4,a5,800051cc <sys_chdir+0x92>
    {
        iunlockput(ip);
        end_op();
        return -1;
    }
    iunlock(ip);
    80005190:	8526                	mv	a0,s1
    80005192:	ffffe097          	auipc	ra,0xffffe
    80005196:	b06080e7          	jalr	-1274(ra) # 80002c98 <iunlock>
    iput(p->cwd);
    8000519a:	15093503          	ld	a0,336(s2)
    8000519e:	ffffe097          	auipc	ra,0xffffe
    800051a2:	bf2080e7          	jalr	-1038(ra) # 80002d90 <iput>
    end_op();
    800051a6:	ffffe097          	auipc	ra,0xffffe
    800051aa:	472080e7          	jalr	1138(ra) # 80003618 <end_op>
    p->cwd = ip;
    800051ae:	14993823          	sd	s1,336(s2)
    return 0;
    800051b2:	4501                	li	a0,0
}
    800051b4:	60ea                	ld	ra,152(sp)
    800051b6:	644a                	ld	s0,144(sp)
    800051b8:	64aa                	ld	s1,136(sp)
    800051ba:	690a                	ld	s2,128(sp)
    800051bc:	610d                	addi	sp,sp,160
    800051be:	8082                	ret
        end_op();
    800051c0:	ffffe097          	auipc	ra,0xffffe
    800051c4:	458080e7          	jalr	1112(ra) # 80003618 <end_op>
        return -1;
    800051c8:	557d                	li	a0,-1
    800051ca:	b7ed                	j	800051b4 <sys_chdir+0x7a>
        iunlockput(ip);
    800051cc:	8526                	mv	a0,s1
    800051ce:	ffffe097          	auipc	ra,0xffffe
    800051d2:	c6a080e7          	jalr	-918(ra) # 80002e38 <iunlockput>
        end_op();
    800051d6:	ffffe097          	auipc	ra,0xffffe
    800051da:	442080e7          	jalr	1090(ra) # 80003618 <end_op>
        return -1;
    800051de:	557d                	li	a0,-1
    800051e0:	bfd1                	j	800051b4 <sys_chdir+0x7a>

00000000800051e2 <sys_exec>:

uint64
sys_exec(void)
{
    800051e2:	7145                	addi	sp,sp,-464
    800051e4:	e786                	sd	ra,456(sp)
    800051e6:	e3a2                	sd	s0,448(sp)
    800051e8:	ff26                	sd	s1,440(sp)
    800051ea:	fb4a                	sd	s2,432(sp)
    800051ec:	f74e                	sd	s3,424(sp)
    800051ee:	f352                	sd	s4,416(sp)
    800051f0:	ef56                	sd	s5,408(sp)
    800051f2:	0b80                	addi	s0,sp,464
    char path[MAXPATH], *argv[MAXARG];
    int i;
    uint64 uargv, uarg;

    argaddr(1, &uargv);
    800051f4:	e3840593          	addi	a1,s0,-456
    800051f8:	4505                	li	a0,1
    800051fa:	ffffd097          	auipc	ra,0xffffd
    800051fe:	e82080e7          	jalr	-382(ra) # 8000207c <argaddr>
    if (argstr(0, path, MAXPATH) < 0)
    80005202:	08000613          	li	a2,128
    80005206:	f4040593          	addi	a1,s0,-192
    8000520a:	4501                	li	a0,0
    8000520c:	ffffd097          	auipc	ra,0xffffd
    80005210:	e90080e7          	jalr	-368(ra) # 8000209c <argstr>
    80005214:	87aa                	mv	a5,a0
    {
        return -1;
    80005216:	557d                	li	a0,-1
    if (argstr(0, path, MAXPATH) < 0)
    80005218:	0c07c263          	bltz	a5,800052dc <sys_exec+0xfa>
    }
    memset(argv, 0, sizeof(argv));
    8000521c:	10000613          	li	a2,256
    80005220:	4581                	li	a1,0
    80005222:	e4040513          	addi	a0,s0,-448
    80005226:	ffffb097          	auipc	ra,0xffffb
    8000522a:	f52080e7          	jalr	-174(ra) # 80000178 <memset>
    for (i = 0;; i++)
    {
        if (i >= NELEM(argv))
    8000522e:	e4040493          	addi	s1,s0,-448
    memset(argv, 0, sizeof(argv));
    80005232:	89a6                	mv	s3,s1
    80005234:	4901                	li	s2,0
        if (i >= NELEM(argv))
    80005236:	02000a13          	li	s4,32
    8000523a:	00090a9b          	sext.w	s5,s2
        {
            goto bad;
        }
        if (fetchaddr(uargv + sizeof(uint64) * i, (uint64 *)&uarg) < 0)
    8000523e:	00391513          	slli	a0,s2,0x3
    80005242:	e3040593          	addi	a1,s0,-464
    80005246:	e3843783          	ld	a5,-456(s0)
    8000524a:	953e                	add	a0,a0,a5
    8000524c:	ffffd097          	auipc	ra,0xffffd
    80005250:	d72080e7          	jalr	-654(ra) # 80001fbe <fetchaddr>
    80005254:	02054a63          	bltz	a0,80005288 <sys_exec+0xa6>
        {
            goto bad;
        }
        if (uarg == 0)
    80005258:	e3043783          	ld	a5,-464(s0)
    8000525c:	c3b9                	beqz	a5,800052a2 <sys_exec+0xc0>
        {
            argv[i] = 0;
            break;
        }
        argv[i] = kalloc();
    8000525e:	ffffb097          	auipc	ra,0xffffb
    80005262:	eba080e7          	jalr	-326(ra) # 80000118 <kalloc>
    80005266:	85aa                	mv	a1,a0
    80005268:	00a9b023          	sd	a0,0(s3)
        if (argv[i] == 0)
    8000526c:	cd11                	beqz	a0,80005288 <sys_exec+0xa6>
            goto bad;
        if (fetchstr(uarg, argv[i], PGSIZE) < 0)
    8000526e:	6605                	lui	a2,0x1
    80005270:	e3043503          	ld	a0,-464(s0)
    80005274:	ffffd097          	auipc	ra,0xffffd
    80005278:	d9c080e7          	jalr	-612(ra) # 80002010 <fetchstr>
    8000527c:	00054663          	bltz	a0,80005288 <sys_exec+0xa6>
        if (i >= NELEM(argv))
    80005280:	0905                	addi	s2,s2,1
    80005282:	09a1                	addi	s3,s3,8
    80005284:	fb491be3          	bne	s2,s4,8000523a <sys_exec+0x58>
        kfree(argv[i]);

    return ret;

bad:
    for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005288:	10048913          	addi	s2,s1,256
    8000528c:	6088                	ld	a0,0(s1)
    8000528e:	c531                	beqz	a0,800052da <sys_exec+0xf8>
        kfree(argv[i]);
    80005290:	ffffb097          	auipc	ra,0xffffb
    80005294:	d8c080e7          	jalr	-628(ra) # 8000001c <kfree>
    for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005298:	04a1                	addi	s1,s1,8
    8000529a:	ff2499e3          	bne	s1,s2,8000528c <sys_exec+0xaa>
    return -1;
    8000529e:	557d                	li	a0,-1
    800052a0:	a835                	j	800052dc <sys_exec+0xfa>
            argv[i] = 0;
    800052a2:	0a8e                	slli	s5,s5,0x3
    800052a4:	fc040793          	addi	a5,s0,-64
    800052a8:	9abe                	add	s5,s5,a5
    800052aa:	e80ab023          	sd	zero,-384(s5)
    int ret = exec(path, argv);
    800052ae:	e4040593          	addi	a1,s0,-448
    800052b2:	f4040513          	addi	a0,s0,-192
    800052b6:	fffff097          	auipc	ra,0xfffff
    800052ba:	e90080e7          	jalr	-368(ra) # 80004146 <exec>
    800052be:	892a                	mv	s2,a0
    for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800052c0:	10048993          	addi	s3,s1,256
    800052c4:	6088                	ld	a0,0(s1)
    800052c6:	c901                	beqz	a0,800052d6 <sys_exec+0xf4>
        kfree(argv[i]);
    800052c8:	ffffb097          	auipc	ra,0xffffb
    800052cc:	d54080e7          	jalr	-684(ra) # 8000001c <kfree>
    for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800052d0:	04a1                	addi	s1,s1,8
    800052d2:	ff3499e3          	bne	s1,s3,800052c4 <sys_exec+0xe2>
    return ret;
    800052d6:	854a                	mv	a0,s2
    800052d8:	a011                	j	800052dc <sys_exec+0xfa>
    return -1;
    800052da:	557d                	li	a0,-1
}
    800052dc:	60be                	ld	ra,456(sp)
    800052de:	641e                	ld	s0,448(sp)
    800052e0:	74fa                	ld	s1,440(sp)
    800052e2:	795a                	ld	s2,432(sp)
    800052e4:	79ba                	ld	s3,424(sp)
    800052e6:	7a1a                	ld	s4,416(sp)
    800052e8:	6afa                	ld	s5,408(sp)
    800052ea:	6179                	addi	sp,sp,464
    800052ec:	8082                	ret

00000000800052ee <sys_pipe>:

uint64
sys_pipe(void)
{
    800052ee:	7139                	addi	sp,sp,-64
    800052f0:	fc06                	sd	ra,56(sp)
    800052f2:	f822                	sd	s0,48(sp)
    800052f4:	f426                	sd	s1,40(sp)
    800052f6:	0080                	addi	s0,sp,64
    uint64 fdarray; // user pointer to array of two integers
    struct file *rf, *wf;
    int fd0, fd1;
    struct proc *p = myproc();
    800052f8:	ffffc097          	auipc	ra,0xffffc
    800052fc:	b6a080e7          	jalr	-1174(ra) # 80000e62 <myproc>
    80005300:	84aa                	mv	s1,a0

    argaddr(0, &fdarray);
    80005302:	fd840593          	addi	a1,s0,-40
    80005306:	4501                	li	a0,0
    80005308:	ffffd097          	auipc	ra,0xffffd
    8000530c:	d74080e7          	jalr	-652(ra) # 8000207c <argaddr>
    if (pipealloc(&rf, &wf) < 0)
    80005310:	fc840593          	addi	a1,s0,-56
    80005314:	fd040513          	addi	a0,s0,-48
    80005318:	fffff097          	auipc	ra,0xfffff
    8000531c:	ad6080e7          	jalr	-1322(ra) # 80003dee <pipealloc>
        return -1;
    80005320:	57fd                	li	a5,-1
    if (pipealloc(&rf, &wf) < 0)
    80005322:	0c054463          	bltz	a0,800053ea <sys_pipe+0xfc>
    fd0 = -1;
    80005326:	fcf42223          	sw	a5,-60(s0)
    if ((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0)
    8000532a:	fd043503          	ld	a0,-48(s0)
    8000532e:	fffff097          	auipc	ra,0xfffff
    80005332:	218080e7          	jalr	536(ra) # 80004546 <fdalloc>
    80005336:	fca42223          	sw	a0,-60(s0)
    8000533a:	08054b63          	bltz	a0,800053d0 <sys_pipe+0xe2>
    8000533e:	fc843503          	ld	a0,-56(s0)
    80005342:	fffff097          	auipc	ra,0xfffff
    80005346:	204080e7          	jalr	516(ra) # 80004546 <fdalloc>
    8000534a:	fca42023          	sw	a0,-64(s0)
    8000534e:	06054863          	bltz	a0,800053be <sys_pipe+0xd0>
            p->ofile[fd0] = 0;
        fileclose(rf);
        fileclose(wf);
        return -1;
    }
    if (copyout(p->pagetable, fdarray, (char *)&fd0, sizeof(fd0)) < 0 ||
    80005352:	4691                	li	a3,4
    80005354:	fc440613          	addi	a2,s0,-60
    80005358:	fd843583          	ld	a1,-40(s0)
    8000535c:	68a8                	ld	a0,80(s1)
    8000535e:	ffffb097          	auipc	ra,0xffffb
    80005362:	7c2080e7          	jalr	1986(ra) # 80000b20 <copyout>
    80005366:	02054063          	bltz	a0,80005386 <sys_pipe+0x98>
        copyout(p->pagetable, fdarray + sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0)
    8000536a:	4691                	li	a3,4
    8000536c:	fc040613          	addi	a2,s0,-64
    80005370:	fd843583          	ld	a1,-40(s0)
    80005374:	0591                	addi	a1,a1,4
    80005376:	68a8                	ld	a0,80(s1)
    80005378:	ffffb097          	auipc	ra,0xffffb
    8000537c:	7a8080e7          	jalr	1960(ra) # 80000b20 <copyout>
        p->ofile[fd1] = 0;
        fileclose(rf);
        fileclose(wf);
        return -1;
    }
    return 0;
    80005380:	4781                	li	a5,0
    if (copyout(p->pagetable, fdarray, (char *)&fd0, sizeof(fd0)) < 0 ||
    80005382:	06055463          	bgez	a0,800053ea <sys_pipe+0xfc>
        p->ofile[fd0] = 0;
    80005386:	fc442783          	lw	a5,-60(s0)
    8000538a:	07e9                	addi	a5,a5,26
    8000538c:	078e                	slli	a5,a5,0x3
    8000538e:	97a6                	add	a5,a5,s1
    80005390:	0007b023          	sd	zero,0(a5)
        p->ofile[fd1] = 0;
    80005394:	fc042503          	lw	a0,-64(s0)
    80005398:	0569                	addi	a0,a0,26
    8000539a:	050e                	slli	a0,a0,0x3
    8000539c:	94aa                	add	s1,s1,a0
    8000539e:	0004b023          	sd	zero,0(s1)
        fileclose(rf);
    800053a2:	fd043503          	ld	a0,-48(s0)
    800053a6:	ffffe097          	auipc	ra,0xffffe
    800053aa:	6be080e7          	jalr	1726(ra) # 80003a64 <fileclose>
        fileclose(wf);
    800053ae:	fc843503          	ld	a0,-56(s0)
    800053b2:	ffffe097          	auipc	ra,0xffffe
    800053b6:	6b2080e7          	jalr	1714(ra) # 80003a64 <fileclose>
        return -1;
    800053ba:	57fd                	li	a5,-1
    800053bc:	a03d                	j	800053ea <sys_pipe+0xfc>
        if (fd0 >= 0)
    800053be:	fc442783          	lw	a5,-60(s0)
    800053c2:	0007c763          	bltz	a5,800053d0 <sys_pipe+0xe2>
            p->ofile[fd0] = 0;
    800053c6:	07e9                	addi	a5,a5,26
    800053c8:	078e                	slli	a5,a5,0x3
    800053ca:	94be                	add	s1,s1,a5
    800053cc:	0004b023          	sd	zero,0(s1)
        fileclose(rf);
    800053d0:	fd043503          	ld	a0,-48(s0)
    800053d4:	ffffe097          	auipc	ra,0xffffe
    800053d8:	690080e7          	jalr	1680(ra) # 80003a64 <fileclose>
        fileclose(wf);
    800053dc:	fc843503          	ld	a0,-56(s0)
    800053e0:	ffffe097          	auipc	ra,0xffffe
    800053e4:	684080e7          	jalr	1668(ra) # 80003a64 <fileclose>
        return -1;
    800053e8:	57fd                	li	a5,-1
}
    800053ea:	853e                	mv	a0,a5
    800053ec:	70e2                	ld	ra,56(sp)
    800053ee:	7442                	ld	s0,48(sp)
    800053f0:	74a2                	ld	s1,40(sp)
    800053f2:	6121                	addi	sp,sp,64
    800053f4:	8082                	ret
	...

0000000080005400 <kernelvec>:
    80005400:	7111                	addi	sp,sp,-256
    80005402:	e006                	sd	ra,0(sp)
    80005404:	e40a                	sd	sp,8(sp)
    80005406:	e80e                	sd	gp,16(sp)
    80005408:	ec12                	sd	tp,24(sp)
    8000540a:	f016                	sd	t0,32(sp)
    8000540c:	f41a                	sd	t1,40(sp)
    8000540e:	f81e                	sd	t2,48(sp)
    80005410:	fc22                	sd	s0,56(sp)
    80005412:	e0a6                	sd	s1,64(sp)
    80005414:	e4aa                	sd	a0,72(sp)
    80005416:	e8ae                	sd	a1,80(sp)
    80005418:	ecb2                	sd	a2,88(sp)
    8000541a:	f0b6                	sd	a3,96(sp)
    8000541c:	f4ba                	sd	a4,104(sp)
    8000541e:	f8be                	sd	a5,112(sp)
    80005420:	fcc2                	sd	a6,120(sp)
    80005422:	e146                	sd	a7,128(sp)
    80005424:	e54a                	sd	s2,136(sp)
    80005426:	e94e                	sd	s3,144(sp)
    80005428:	ed52                	sd	s4,152(sp)
    8000542a:	f156                	sd	s5,160(sp)
    8000542c:	f55a                	sd	s6,168(sp)
    8000542e:	f95e                	sd	s7,176(sp)
    80005430:	fd62                	sd	s8,184(sp)
    80005432:	e1e6                	sd	s9,192(sp)
    80005434:	e5ea                	sd	s10,200(sp)
    80005436:	e9ee                	sd	s11,208(sp)
    80005438:	edf2                	sd	t3,216(sp)
    8000543a:	f1f6                	sd	t4,224(sp)
    8000543c:	f5fa                	sd	t5,232(sp)
    8000543e:	f9fe                	sd	t6,240(sp)
    80005440:	a4bfc0ef          	jal	ra,80001e8a <kerneltrap>
    80005444:	6082                	ld	ra,0(sp)
    80005446:	6122                	ld	sp,8(sp)
    80005448:	61c2                	ld	gp,16(sp)
    8000544a:	7282                	ld	t0,32(sp)
    8000544c:	7322                	ld	t1,40(sp)
    8000544e:	73c2                	ld	t2,48(sp)
    80005450:	7462                	ld	s0,56(sp)
    80005452:	6486                	ld	s1,64(sp)
    80005454:	6526                	ld	a0,72(sp)
    80005456:	65c6                	ld	a1,80(sp)
    80005458:	6666                	ld	a2,88(sp)
    8000545a:	7686                	ld	a3,96(sp)
    8000545c:	7726                	ld	a4,104(sp)
    8000545e:	77c6                	ld	a5,112(sp)
    80005460:	7866                	ld	a6,120(sp)
    80005462:	688a                	ld	a7,128(sp)
    80005464:	692a                	ld	s2,136(sp)
    80005466:	69ca                	ld	s3,144(sp)
    80005468:	6a6a                	ld	s4,152(sp)
    8000546a:	7a8a                	ld	s5,160(sp)
    8000546c:	7b2a                	ld	s6,168(sp)
    8000546e:	7bca                	ld	s7,176(sp)
    80005470:	7c6a                	ld	s8,184(sp)
    80005472:	6c8e                	ld	s9,192(sp)
    80005474:	6d2e                	ld	s10,200(sp)
    80005476:	6dce                	ld	s11,208(sp)
    80005478:	6e6e                	ld	t3,216(sp)
    8000547a:	7e8e                	ld	t4,224(sp)
    8000547c:	7f2e                	ld	t5,232(sp)
    8000547e:	7fce                	ld	t6,240(sp)
    80005480:	6111                	addi	sp,sp,256
    80005482:	10200073          	sret
    80005486:	00000013          	nop
    8000548a:	00000013          	nop
    8000548e:	0001                	nop

0000000080005490 <timervec>:
    80005490:	34051573          	csrrw	a0,mscratch,a0
    80005494:	e10c                	sd	a1,0(a0)
    80005496:	e510                	sd	a2,8(a0)
    80005498:	e914                	sd	a3,16(a0)
    8000549a:	6d0c                	ld	a1,24(a0)
    8000549c:	7110                	ld	a2,32(a0)
    8000549e:	6194                	ld	a3,0(a1)
    800054a0:	96b2                	add	a3,a3,a2
    800054a2:	e194                	sd	a3,0(a1)
    800054a4:	4589                	li	a1,2
    800054a6:	14459073          	csrw	sip,a1
    800054aa:	6914                	ld	a3,16(a0)
    800054ac:	6510                	ld	a2,8(a0)
    800054ae:	610c                	ld	a1,0(a0)
    800054b0:	34051573          	csrrw	a0,mscratch,a0
    800054b4:	30200073          	mret
	...

00000000800054ba <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    800054ba:	1141                	addi	sp,sp,-16
    800054bc:	e422                	sd	s0,8(sp)
    800054be:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    800054c0:	0c0007b7          	lui	a5,0xc000
    800054c4:	4705                	li	a4,1
    800054c6:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    800054c8:	c3d8                	sw	a4,4(a5)
}
    800054ca:	6422                	ld	s0,8(sp)
    800054cc:	0141                	addi	sp,sp,16
    800054ce:	8082                	ret

00000000800054d0 <plicinithart>:

void
plicinithart(void)
{
    800054d0:	1141                	addi	sp,sp,-16
    800054d2:	e406                	sd	ra,8(sp)
    800054d4:	e022                	sd	s0,0(sp)
    800054d6:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800054d8:	ffffc097          	auipc	ra,0xffffc
    800054dc:	95e080e7          	jalr	-1698(ra) # 80000e36 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    800054e0:	0085171b          	slliw	a4,a0,0x8
    800054e4:	0c0027b7          	lui	a5,0xc002
    800054e8:	97ba                	add	a5,a5,a4
    800054ea:	40200713          	li	a4,1026
    800054ee:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800054f2:	00d5151b          	slliw	a0,a0,0xd
    800054f6:	0c2017b7          	lui	a5,0xc201
    800054fa:	953e                	add	a0,a0,a5
    800054fc:	00052023          	sw	zero,0(a0)
}
    80005500:	60a2                	ld	ra,8(sp)
    80005502:	6402                	ld	s0,0(sp)
    80005504:	0141                	addi	sp,sp,16
    80005506:	8082                	ret

0000000080005508 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005508:	1141                	addi	sp,sp,-16
    8000550a:	e406                	sd	ra,8(sp)
    8000550c:	e022                	sd	s0,0(sp)
    8000550e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005510:	ffffc097          	auipc	ra,0xffffc
    80005514:	926080e7          	jalr	-1754(ra) # 80000e36 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005518:	00d5179b          	slliw	a5,a0,0xd
    8000551c:	0c201537          	lui	a0,0xc201
    80005520:	953e                	add	a0,a0,a5
  return irq;
}
    80005522:	4148                	lw	a0,4(a0)
    80005524:	60a2                	ld	ra,8(sp)
    80005526:	6402                	ld	s0,0(sp)
    80005528:	0141                	addi	sp,sp,16
    8000552a:	8082                	ret

000000008000552c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000552c:	1101                	addi	sp,sp,-32
    8000552e:	ec06                	sd	ra,24(sp)
    80005530:	e822                	sd	s0,16(sp)
    80005532:	e426                	sd	s1,8(sp)
    80005534:	1000                	addi	s0,sp,32
    80005536:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005538:	ffffc097          	auipc	ra,0xffffc
    8000553c:	8fe080e7          	jalr	-1794(ra) # 80000e36 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005540:	00d5151b          	slliw	a0,a0,0xd
    80005544:	0c2017b7          	lui	a5,0xc201
    80005548:	97aa                	add	a5,a5,a0
    8000554a:	c3c4                	sw	s1,4(a5)
}
    8000554c:	60e2                	ld	ra,24(sp)
    8000554e:	6442                	ld	s0,16(sp)
    80005550:	64a2                	ld	s1,8(sp)
    80005552:	6105                	addi	sp,sp,32
    80005554:	8082                	ret

0000000080005556 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005556:	1141                	addi	sp,sp,-16
    80005558:	e406                	sd	ra,8(sp)
    8000555a:	e022                	sd	s0,0(sp)
    8000555c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000555e:	479d                	li	a5,7
    80005560:	04a7cc63          	blt	a5,a0,800055b8 <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    80005564:	00026797          	auipc	a5,0x26
    80005568:	68c78793          	addi	a5,a5,1676 # 8002bbf0 <disk>
    8000556c:	97aa                	add	a5,a5,a0
    8000556e:	0187c783          	lbu	a5,24(a5)
    80005572:	ebb9                	bnez	a5,800055c8 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005574:	00451613          	slli	a2,a0,0x4
    80005578:	00026797          	auipc	a5,0x26
    8000557c:	67878793          	addi	a5,a5,1656 # 8002bbf0 <disk>
    80005580:	6394                	ld	a3,0(a5)
    80005582:	96b2                	add	a3,a3,a2
    80005584:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    80005588:	6398                	ld	a4,0(a5)
    8000558a:	9732                	add	a4,a4,a2
    8000558c:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80005590:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005594:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005598:	953e                	add	a0,a0,a5
    8000559a:	4785                	li	a5,1
    8000559c:	00f50c23          	sb	a5,24(a0) # c201018 <_entry-0x73dfefe8>
  wakeup(&disk.free[0]);
    800055a0:	00026517          	auipc	a0,0x26
    800055a4:	66850513          	addi	a0,a0,1640 # 8002bc08 <disk+0x18>
    800055a8:	ffffc097          	auipc	ra,0xffffc
    800055ac:	fc2080e7          	jalr	-62(ra) # 8000156a <wakeup>
}
    800055b0:	60a2                	ld	ra,8(sp)
    800055b2:	6402                	ld	s0,0(sp)
    800055b4:	0141                	addi	sp,sp,16
    800055b6:	8082                	ret
    panic("free_desc 1");
    800055b8:	00003517          	auipc	a0,0x3
    800055bc:	32050513          	addi	a0,a0,800 # 800088d8 <syscalls+0x4e8>
    800055c0:	00001097          	auipc	ra,0x1
    800055c4:	a72080e7          	jalr	-1422(ra) # 80006032 <panic>
    panic("free_desc 2");
    800055c8:	00003517          	auipc	a0,0x3
    800055cc:	32050513          	addi	a0,a0,800 # 800088e8 <syscalls+0x4f8>
    800055d0:	00001097          	auipc	ra,0x1
    800055d4:	a62080e7          	jalr	-1438(ra) # 80006032 <panic>

00000000800055d8 <virtio_disk_init>:
{
    800055d8:	1101                	addi	sp,sp,-32
    800055da:	ec06                	sd	ra,24(sp)
    800055dc:	e822                	sd	s0,16(sp)
    800055de:	e426                	sd	s1,8(sp)
    800055e0:	e04a                	sd	s2,0(sp)
    800055e2:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    800055e4:	00003597          	auipc	a1,0x3
    800055e8:	31458593          	addi	a1,a1,788 # 800088f8 <syscalls+0x508>
    800055ec:	00026517          	auipc	a0,0x26
    800055f0:	72c50513          	addi	a0,a0,1836 # 8002bd18 <disk+0x128>
    800055f4:	00001097          	auipc	ra,0x1
    800055f8:	ef8080e7          	jalr	-264(ra) # 800064ec <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800055fc:	100017b7          	lui	a5,0x10001
    80005600:	4398                	lw	a4,0(a5)
    80005602:	2701                	sext.w	a4,a4
    80005604:	747277b7          	lui	a5,0x74727
    80005608:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    8000560c:	14f71e63          	bne	a4,a5,80005768 <virtio_disk_init+0x190>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005610:	100017b7          	lui	a5,0x10001
    80005614:	43dc                	lw	a5,4(a5)
    80005616:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005618:	4709                	li	a4,2
    8000561a:	14e79763          	bne	a5,a4,80005768 <virtio_disk_init+0x190>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000561e:	100017b7          	lui	a5,0x10001
    80005622:	479c                	lw	a5,8(a5)
    80005624:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005626:	14e79163          	bne	a5,a4,80005768 <virtio_disk_init+0x190>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    8000562a:	100017b7          	lui	a5,0x10001
    8000562e:	47d8                	lw	a4,12(a5)
    80005630:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005632:	554d47b7          	lui	a5,0x554d4
    80005636:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    8000563a:	12f71763          	bne	a4,a5,80005768 <virtio_disk_init+0x190>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000563e:	100017b7          	lui	a5,0x10001
    80005642:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005646:	4705                	li	a4,1
    80005648:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000564a:	470d                	li	a4,3
    8000564c:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    8000564e:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005650:	c7ffe737          	lui	a4,0xc7ffe
    80005654:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fca7ef>
    80005658:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    8000565a:	2701                	sext.w	a4,a4
    8000565c:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000565e:	472d                	li	a4,11
    80005660:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    80005662:	0707a903          	lw	s2,112(a5)
    80005666:	2901                	sext.w	s2,s2
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005668:	00897793          	andi	a5,s2,8
    8000566c:	10078663          	beqz	a5,80005778 <virtio_disk_init+0x1a0>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005670:	100017b7          	lui	a5,0x10001
    80005674:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80005678:	43fc                	lw	a5,68(a5)
    8000567a:	2781                	sext.w	a5,a5
    8000567c:	10079663          	bnez	a5,80005788 <virtio_disk_init+0x1b0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005680:	100017b7          	lui	a5,0x10001
    80005684:	5bdc                	lw	a5,52(a5)
    80005686:	2781                	sext.w	a5,a5
  if(max == 0)
    80005688:	10078863          	beqz	a5,80005798 <virtio_disk_init+0x1c0>
  if(max < NUM)
    8000568c:	471d                	li	a4,7
    8000568e:	10f77d63          	bgeu	a4,a5,800057a8 <virtio_disk_init+0x1d0>
  disk.desc = kalloc();
    80005692:	ffffb097          	auipc	ra,0xffffb
    80005696:	a86080e7          	jalr	-1402(ra) # 80000118 <kalloc>
    8000569a:	00026497          	auipc	s1,0x26
    8000569e:	55648493          	addi	s1,s1,1366 # 8002bbf0 <disk>
    800056a2:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    800056a4:	ffffb097          	auipc	ra,0xffffb
    800056a8:	a74080e7          	jalr	-1420(ra) # 80000118 <kalloc>
    800056ac:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    800056ae:	ffffb097          	auipc	ra,0xffffb
    800056b2:	a6a080e7          	jalr	-1430(ra) # 80000118 <kalloc>
    800056b6:	87aa                	mv	a5,a0
    800056b8:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    800056ba:	6088                	ld	a0,0(s1)
    800056bc:	cd75                	beqz	a0,800057b8 <virtio_disk_init+0x1e0>
    800056be:	00026717          	auipc	a4,0x26
    800056c2:	53a73703          	ld	a4,1338(a4) # 8002bbf8 <disk+0x8>
    800056c6:	cb6d                	beqz	a4,800057b8 <virtio_disk_init+0x1e0>
    800056c8:	cbe5                	beqz	a5,800057b8 <virtio_disk_init+0x1e0>
  memset(disk.desc, 0, PGSIZE);
    800056ca:	6605                	lui	a2,0x1
    800056cc:	4581                	li	a1,0
    800056ce:	ffffb097          	auipc	ra,0xffffb
    800056d2:	aaa080e7          	jalr	-1366(ra) # 80000178 <memset>
  memset(disk.avail, 0, PGSIZE);
    800056d6:	00026497          	auipc	s1,0x26
    800056da:	51a48493          	addi	s1,s1,1306 # 8002bbf0 <disk>
    800056de:	6605                	lui	a2,0x1
    800056e0:	4581                	li	a1,0
    800056e2:	6488                	ld	a0,8(s1)
    800056e4:	ffffb097          	auipc	ra,0xffffb
    800056e8:	a94080e7          	jalr	-1388(ra) # 80000178 <memset>
  memset(disk.used, 0, PGSIZE);
    800056ec:	6605                	lui	a2,0x1
    800056ee:	4581                	li	a1,0
    800056f0:	6888                	ld	a0,16(s1)
    800056f2:	ffffb097          	auipc	ra,0xffffb
    800056f6:	a86080e7          	jalr	-1402(ra) # 80000178 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800056fa:	100017b7          	lui	a5,0x10001
    800056fe:	4721                	li	a4,8
    80005700:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80005702:	4098                	lw	a4,0(s1)
    80005704:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80005708:	40d8                	lw	a4,4(s1)
    8000570a:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    8000570e:	6498                	ld	a4,8(s1)
    80005710:	0007069b          	sext.w	a3,a4
    80005714:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80005718:	9701                	srai	a4,a4,0x20
    8000571a:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    8000571e:	6898                	ld	a4,16(s1)
    80005720:	0007069b          	sext.w	a3,a4
    80005724:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80005728:	9701                	srai	a4,a4,0x20
    8000572a:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    8000572e:	4685                	li	a3,1
    80005730:	c3f4                	sw	a3,68(a5)
    disk.free[i] = 1;
    80005732:	4705                	li	a4,1
    80005734:	00d48c23          	sb	a3,24(s1)
    80005738:	00e48ca3          	sb	a4,25(s1)
    8000573c:	00e48d23          	sb	a4,26(s1)
    80005740:	00e48da3          	sb	a4,27(s1)
    80005744:	00e48e23          	sb	a4,28(s1)
    80005748:	00e48ea3          	sb	a4,29(s1)
    8000574c:	00e48f23          	sb	a4,30(s1)
    80005750:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80005754:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005758:	0727a823          	sw	s2,112(a5)
}
    8000575c:	60e2                	ld	ra,24(sp)
    8000575e:	6442                	ld	s0,16(sp)
    80005760:	64a2                	ld	s1,8(sp)
    80005762:	6902                	ld	s2,0(sp)
    80005764:	6105                	addi	sp,sp,32
    80005766:	8082                	ret
    panic("could not find virtio disk");
    80005768:	00003517          	auipc	a0,0x3
    8000576c:	1a050513          	addi	a0,a0,416 # 80008908 <syscalls+0x518>
    80005770:	00001097          	auipc	ra,0x1
    80005774:	8c2080e7          	jalr	-1854(ra) # 80006032 <panic>
    panic("virtio disk FEATURES_OK unset");
    80005778:	00003517          	auipc	a0,0x3
    8000577c:	1b050513          	addi	a0,a0,432 # 80008928 <syscalls+0x538>
    80005780:	00001097          	auipc	ra,0x1
    80005784:	8b2080e7          	jalr	-1870(ra) # 80006032 <panic>
    panic("virtio disk should not be ready");
    80005788:	00003517          	auipc	a0,0x3
    8000578c:	1c050513          	addi	a0,a0,448 # 80008948 <syscalls+0x558>
    80005790:	00001097          	auipc	ra,0x1
    80005794:	8a2080e7          	jalr	-1886(ra) # 80006032 <panic>
    panic("virtio disk has no queue 0");
    80005798:	00003517          	auipc	a0,0x3
    8000579c:	1d050513          	addi	a0,a0,464 # 80008968 <syscalls+0x578>
    800057a0:	00001097          	auipc	ra,0x1
    800057a4:	892080e7          	jalr	-1902(ra) # 80006032 <panic>
    panic("virtio disk max queue too short");
    800057a8:	00003517          	auipc	a0,0x3
    800057ac:	1e050513          	addi	a0,a0,480 # 80008988 <syscalls+0x598>
    800057b0:	00001097          	auipc	ra,0x1
    800057b4:	882080e7          	jalr	-1918(ra) # 80006032 <panic>
    panic("virtio disk kalloc");
    800057b8:	00003517          	auipc	a0,0x3
    800057bc:	1f050513          	addi	a0,a0,496 # 800089a8 <syscalls+0x5b8>
    800057c0:	00001097          	auipc	ra,0x1
    800057c4:	872080e7          	jalr	-1934(ra) # 80006032 <panic>

00000000800057c8 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    800057c8:	7159                	addi	sp,sp,-112
    800057ca:	f486                	sd	ra,104(sp)
    800057cc:	f0a2                	sd	s0,96(sp)
    800057ce:	eca6                	sd	s1,88(sp)
    800057d0:	e8ca                	sd	s2,80(sp)
    800057d2:	e4ce                	sd	s3,72(sp)
    800057d4:	e0d2                	sd	s4,64(sp)
    800057d6:	fc56                	sd	s5,56(sp)
    800057d8:	f85a                	sd	s6,48(sp)
    800057da:	f45e                	sd	s7,40(sp)
    800057dc:	f062                	sd	s8,32(sp)
    800057de:	ec66                	sd	s9,24(sp)
    800057e0:	e86a                	sd	s10,16(sp)
    800057e2:	1880                	addi	s0,sp,112
    800057e4:	892a                	mv	s2,a0
    800057e6:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    800057e8:	00c52c83          	lw	s9,12(a0)
    800057ec:	001c9c9b          	slliw	s9,s9,0x1
    800057f0:	1c82                	slli	s9,s9,0x20
    800057f2:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    800057f6:	00026517          	auipc	a0,0x26
    800057fa:	52250513          	addi	a0,a0,1314 # 8002bd18 <disk+0x128>
    800057fe:	00001097          	auipc	ra,0x1
    80005802:	d7e080e7          	jalr	-642(ra) # 8000657c <acquire>
  for(int i = 0; i < 3; i++){
    80005806:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005808:	4ba1                	li	s7,8
      disk.free[i] = 0;
    8000580a:	00026b17          	auipc	s6,0x26
    8000580e:	3e6b0b13          	addi	s6,s6,998 # 8002bbf0 <disk>
  for(int i = 0; i < 3; i++){
    80005812:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    80005814:	8a4e                	mv	s4,s3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005816:	00026c17          	auipc	s8,0x26
    8000581a:	502c0c13          	addi	s8,s8,1282 # 8002bd18 <disk+0x128>
    8000581e:	a8b5                	j	8000589a <virtio_disk_rw+0xd2>
      disk.free[i] = 0;
    80005820:	00fb06b3          	add	a3,s6,a5
    80005824:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    80005828:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    8000582a:	0207c563          	bltz	a5,80005854 <virtio_disk_rw+0x8c>
  for(int i = 0; i < 3; i++){
    8000582e:	2485                	addiw	s1,s1,1
    80005830:	0711                	addi	a4,a4,4
    80005832:	1f548a63          	beq	s1,s5,80005a26 <virtio_disk_rw+0x25e>
    idx[i] = alloc_desc();
    80005836:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    80005838:	00026697          	auipc	a3,0x26
    8000583c:	3b868693          	addi	a3,a3,952 # 8002bbf0 <disk>
    80005840:	87d2                	mv	a5,s4
    if(disk.free[i]){
    80005842:	0186c583          	lbu	a1,24(a3)
    80005846:	fde9                	bnez	a1,80005820 <virtio_disk_rw+0x58>
  for(int i = 0; i < NUM; i++){
    80005848:	2785                	addiw	a5,a5,1
    8000584a:	0685                	addi	a3,a3,1
    8000584c:	ff779be3          	bne	a5,s7,80005842 <virtio_disk_rw+0x7a>
    idx[i] = alloc_desc();
    80005850:	57fd                	li	a5,-1
    80005852:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    80005854:	02905a63          	blez	s1,80005888 <virtio_disk_rw+0xc0>
        free_desc(idx[j]);
    80005858:	f9042503          	lw	a0,-112(s0)
    8000585c:	00000097          	auipc	ra,0x0
    80005860:	cfa080e7          	jalr	-774(ra) # 80005556 <free_desc>
      for(int j = 0; j < i; j++)
    80005864:	4785                	li	a5,1
    80005866:	0297d163          	bge	a5,s1,80005888 <virtio_disk_rw+0xc0>
        free_desc(idx[j]);
    8000586a:	f9442503          	lw	a0,-108(s0)
    8000586e:	00000097          	auipc	ra,0x0
    80005872:	ce8080e7          	jalr	-792(ra) # 80005556 <free_desc>
      for(int j = 0; j < i; j++)
    80005876:	4789                	li	a5,2
    80005878:	0097d863          	bge	a5,s1,80005888 <virtio_disk_rw+0xc0>
        free_desc(idx[j]);
    8000587c:	f9842503          	lw	a0,-104(s0)
    80005880:	00000097          	auipc	ra,0x0
    80005884:	cd6080e7          	jalr	-810(ra) # 80005556 <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005888:	85e2                	mv	a1,s8
    8000588a:	00026517          	auipc	a0,0x26
    8000588e:	37e50513          	addi	a0,a0,894 # 8002bc08 <disk+0x18>
    80005892:	ffffc097          	auipc	ra,0xffffc
    80005896:	c74080e7          	jalr	-908(ra) # 80001506 <sleep>
  for(int i = 0; i < 3; i++){
    8000589a:	f9040713          	addi	a4,s0,-112
    8000589e:	84ce                	mv	s1,s3
    800058a0:	bf59                	j	80005836 <virtio_disk_rw+0x6e>
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

  if(write)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    800058a2:	00a60793          	addi	a5,a2,10 # 100a <_entry-0x7fffeff6>
    800058a6:	00479693          	slli	a3,a5,0x4
    800058aa:	00026797          	auipc	a5,0x26
    800058ae:	34678793          	addi	a5,a5,838 # 8002bbf0 <disk>
    800058b2:	97b6                	add	a5,a5,a3
    800058b4:	4685                	li	a3,1
    800058b6:	c794                	sw	a3,8(a5)
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    800058b8:	00026597          	auipc	a1,0x26
    800058bc:	33858593          	addi	a1,a1,824 # 8002bbf0 <disk>
    800058c0:	00a60793          	addi	a5,a2,10
    800058c4:	0792                	slli	a5,a5,0x4
    800058c6:	97ae                	add	a5,a5,a1
    800058c8:	0007a623          	sw	zero,12(a5)
  buf0->sector = sector;
    800058cc:	0197b823          	sd	s9,16(a5)

  disk.desc[idx[0]].addr = (uint64) buf0;
    800058d0:	f6070693          	addi	a3,a4,-160
    800058d4:	619c                	ld	a5,0(a1)
    800058d6:	97b6                	add	a5,a5,a3
    800058d8:	e388                	sd	a0,0(a5)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    800058da:	6188                	ld	a0,0(a1)
    800058dc:	96aa                	add	a3,a3,a0
    800058de:	47c1                	li	a5,16
    800058e0:	c69c                	sw	a5,8(a3)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    800058e2:	4785                	li	a5,1
    800058e4:	00f69623          	sh	a5,12(a3)
  disk.desc[idx[0]].next = idx[1];
    800058e8:	f9442783          	lw	a5,-108(s0)
    800058ec:	00f69723          	sh	a5,14(a3)

  disk.desc[idx[1]].addr = (uint64) b->data;
    800058f0:	0792                	slli	a5,a5,0x4
    800058f2:	953e                	add	a0,a0,a5
    800058f4:	05890693          	addi	a3,s2,88
    800058f8:	e114                	sd	a3,0(a0)
  disk.desc[idx[1]].len = BSIZE;
    800058fa:	6188                	ld	a0,0(a1)
    800058fc:	97aa                	add	a5,a5,a0
    800058fe:	40000693          	li	a3,1024
    80005902:	c794                	sw	a3,8(a5)
  if(write)
    80005904:	100d0d63          	beqz	s10,80005a1e <virtio_disk_rw+0x256>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    80005908:	00079623          	sh	zero,12(a5)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000590c:	00c7d683          	lhu	a3,12(a5)
    80005910:	0016e693          	ori	a3,a3,1
    80005914:	00d79623          	sh	a3,12(a5)
  disk.desc[idx[1]].next = idx[2];
    80005918:	f9842583          	lw	a1,-104(s0)
    8000591c:	00b79723          	sh	a1,14(a5)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005920:	00026697          	auipc	a3,0x26
    80005924:	2d068693          	addi	a3,a3,720 # 8002bbf0 <disk>
    80005928:	00260793          	addi	a5,a2,2
    8000592c:	0792                	slli	a5,a5,0x4
    8000592e:	97b6                	add	a5,a5,a3
    80005930:	587d                	li	a6,-1
    80005932:	01078823          	sb	a6,16(a5)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005936:	0592                	slli	a1,a1,0x4
    80005938:	952e                	add	a0,a0,a1
    8000593a:	f9070713          	addi	a4,a4,-112
    8000593e:	9736                	add	a4,a4,a3
    80005940:	e118                	sd	a4,0(a0)
  disk.desc[idx[2]].len = 1;
    80005942:	6298                	ld	a4,0(a3)
    80005944:	972e                	add	a4,a4,a1
    80005946:	4585                	li	a1,1
    80005948:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    8000594a:	4509                	li	a0,2
    8000594c:	00a71623          	sh	a0,12(a4)
  disk.desc[idx[2]].next = 0;
    80005950:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005954:	00b92223          	sw	a1,4(s2)
  disk.info[idx[0]].b = b;
    80005958:	0127b423          	sd	s2,8(a5)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    8000595c:	6698                	ld	a4,8(a3)
    8000595e:	00275783          	lhu	a5,2(a4)
    80005962:	8b9d                	andi	a5,a5,7
    80005964:	0786                	slli	a5,a5,0x1
    80005966:	97ba                	add	a5,a5,a4
    80005968:	00c79223          	sh	a2,4(a5)

  __sync_synchronize();
    8000596c:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005970:	6698                	ld	a4,8(a3)
    80005972:	00275783          	lhu	a5,2(a4)
    80005976:	2785                	addiw	a5,a5,1
    80005978:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    8000597c:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005980:	100017b7          	lui	a5,0x10001
    80005984:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005988:	00492703          	lw	a4,4(s2)
    8000598c:	4785                	li	a5,1
    8000598e:	02f71163          	bne	a4,a5,800059b0 <virtio_disk_rw+0x1e8>
    sleep(b, &disk.vdisk_lock);
    80005992:	00026997          	auipc	s3,0x26
    80005996:	38698993          	addi	s3,s3,902 # 8002bd18 <disk+0x128>
  while(b->disk == 1) {
    8000599a:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    8000599c:	85ce                	mv	a1,s3
    8000599e:	854a                	mv	a0,s2
    800059a0:	ffffc097          	auipc	ra,0xffffc
    800059a4:	b66080e7          	jalr	-1178(ra) # 80001506 <sleep>
  while(b->disk == 1) {
    800059a8:	00492783          	lw	a5,4(s2)
    800059ac:	fe9788e3          	beq	a5,s1,8000599c <virtio_disk_rw+0x1d4>
  }

  disk.info[idx[0]].b = 0;
    800059b0:	f9042903          	lw	s2,-112(s0)
    800059b4:	00290793          	addi	a5,s2,2
    800059b8:	00479713          	slli	a4,a5,0x4
    800059bc:	00026797          	auipc	a5,0x26
    800059c0:	23478793          	addi	a5,a5,564 # 8002bbf0 <disk>
    800059c4:	97ba                	add	a5,a5,a4
    800059c6:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    800059ca:	00026997          	auipc	s3,0x26
    800059ce:	22698993          	addi	s3,s3,550 # 8002bbf0 <disk>
    800059d2:	00491713          	slli	a4,s2,0x4
    800059d6:	0009b783          	ld	a5,0(s3)
    800059da:	97ba                	add	a5,a5,a4
    800059dc:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    800059e0:	854a                	mv	a0,s2
    800059e2:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    800059e6:	00000097          	auipc	ra,0x0
    800059ea:	b70080e7          	jalr	-1168(ra) # 80005556 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    800059ee:	8885                	andi	s1,s1,1
    800059f0:	f0ed                	bnez	s1,800059d2 <virtio_disk_rw+0x20a>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800059f2:	00026517          	auipc	a0,0x26
    800059f6:	32650513          	addi	a0,a0,806 # 8002bd18 <disk+0x128>
    800059fa:	00001097          	auipc	ra,0x1
    800059fe:	c36080e7          	jalr	-970(ra) # 80006630 <release>
}
    80005a02:	70a6                	ld	ra,104(sp)
    80005a04:	7406                	ld	s0,96(sp)
    80005a06:	64e6                	ld	s1,88(sp)
    80005a08:	6946                	ld	s2,80(sp)
    80005a0a:	69a6                	ld	s3,72(sp)
    80005a0c:	6a06                	ld	s4,64(sp)
    80005a0e:	7ae2                	ld	s5,56(sp)
    80005a10:	7b42                	ld	s6,48(sp)
    80005a12:	7ba2                	ld	s7,40(sp)
    80005a14:	7c02                	ld	s8,32(sp)
    80005a16:	6ce2                	ld	s9,24(sp)
    80005a18:	6d42                	ld	s10,16(sp)
    80005a1a:	6165                	addi	sp,sp,112
    80005a1c:	8082                	ret
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    80005a1e:	4689                	li	a3,2
    80005a20:	00d79623          	sh	a3,12(a5)
    80005a24:	b5e5                	j	8000590c <virtio_disk_rw+0x144>
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005a26:	f9042603          	lw	a2,-112(s0)
    80005a2a:	00a60713          	addi	a4,a2,10
    80005a2e:	0712                	slli	a4,a4,0x4
    80005a30:	00026517          	auipc	a0,0x26
    80005a34:	1c850513          	addi	a0,a0,456 # 8002bbf8 <disk+0x8>
    80005a38:	953a                	add	a0,a0,a4
  if(write)
    80005a3a:	e60d14e3          	bnez	s10,800058a2 <virtio_disk_rw+0xda>
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    80005a3e:	00a60793          	addi	a5,a2,10
    80005a42:	00479693          	slli	a3,a5,0x4
    80005a46:	00026797          	auipc	a5,0x26
    80005a4a:	1aa78793          	addi	a5,a5,426 # 8002bbf0 <disk>
    80005a4e:	97b6                	add	a5,a5,a3
    80005a50:	0007a423          	sw	zero,8(a5)
    80005a54:	b595                	j	800058b8 <virtio_disk_rw+0xf0>

0000000080005a56 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005a56:	1101                	addi	sp,sp,-32
    80005a58:	ec06                	sd	ra,24(sp)
    80005a5a:	e822                	sd	s0,16(sp)
    80005a5c:	e426                	sd	s1,8(sp)
    80005a5e:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005a60:	00026497          	auipc	s1,0x26
    80005a64:	19048493          	addi	s1,s1,400 # 8002bbf0 <disk>
    80005a68:	00026517          	auipc	a0,0x26
    80005a6c:	2b050513          	addi	a0,a0,688 # 8002bd18 <disk+0x128>
    80005a70:	00001097          	auipc	ra,0x1
    80005a74:	b0c080e7          	jalr	-1268(ra) # 8000657c <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005a78:	10001737          	lui	a4,0x10001
    80005a7c:	533c                	lw	a5,96(a4)
    80005a7e:	8b8d                	andi	a5,a5,3
    80005a80:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80005a82:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005a86:	689c                	ld	a5,16(s1)
    80005a88:	0204d703          	lhu	a4,32(s1)
    80005a8c:	0027d783          	lhu	a5,2(a5)
    80005a90:	04f70863          	beq	a4,a5,80005ae0 <virtio_disk_intr+0x8a>
    __sync_synchronize();
    80005a94:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005a98:	6898                	ld	a4,16(s1)
    80005a9a:	0204d783          	lhu	a5,32(s1)
    80005a9e:	8b9d                	andi	a5,a5,7
    80005aa0:	078e                	slli	a5,a5,0x3
    80005aa2:	97ba                	add	a5,a5,a4
    80005aa4:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005aa6:	00278713          	addi	a4,a5,2
    80005aaa:	0712                	slli	a4,a4,0x4
    80005aac:	9726                	add	a4,a4,s1
    80005aae:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    80005ab2:	e721                	bnez	a4,80005afa <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005ab4:	0789                	addi	a5,a5,2
    80005ab6:	0792                	slli	a5,a5,0x4
    80005ab8:	97a6                	add	a5,a5,s1
    80005aba:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80005abc:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005ac0:	ffffc097          	auipc	ra,0xffffc
    80005ac4:	aaa080e7          	jalr	-1366(ra) # 8000156a <wakeup>

    disk.used_idx += 1;
    80005ac8:	0204d783          	lhu	a5,32(s1)
    80005acc:	2785                	addiw	a5,a5,1
    80005ace:	17c2                	slli	a5,a5,0x30
    80005ad0:	93c1                	srli	a5,a5,0x30
    80005ad2:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005ad6:	6898                	ld	a4,16(s1)
    80005ad8:	00275703          	lhu	a4,2(a4)
    80005adc:	faf71ce3          	bne	a4,a5,80005a94 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80005ae0:	00026517          	auipc	a0,0x26
    80005ae4:	23850513          	addi	a0,a0,568 # 8002bd18 <disk+0x128>
    80005ae8:	00001097          	auipc	ra,0x1
    80005aec:	b48080e7          	jalr	-1208(ra) # 80006630 <release>
}
    80005af0:	60e2                	ld	ra,24(sp)
    80005af2:	6442                	ld	s0,16(sp)
    80005af4:	64a2                	ld	s1,8(sp)
    80005af6:	6105                	addi	sp,sp,32
    80005af8:	8082                	ret
      panic("virtio_disk_intr status");
    80005afa:	00003517          	auipc	a0,0x3
    80005afe:	ec650513          	addi	a0,a0,-314 # 800089c0 <syscalls+0x5d0>
    80005b02:	00000097          	auipc	ra,0x0
    80005b06:	530080e7          	jalr	1328(ra) # 80006032 <panic>

0000000080005b0a <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005b0a:	1141                	addi	sp,sp,-16
    80005b0c:	e422                	sd	s0,8(sp)
    80005b0e:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005b10:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005b14:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005b18:	0037979b          	slliw	a5,a5,0x3
    80005b1c:	02004737          	lui	a4,0x2004
    80005b20:	97ba                	add	a5,a5,a4
    80005b22:	0200c737          	lui	a4,0x200c
    80005b26:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005b2a:	000f4637          	lui	a2,0xf4
    80005b2e:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005b32:	95b2                	add	a1,a1,a2
    80005b34:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005b36:	00269713          	slli	a4,a3,0x2
    80005b3a:	9736                	add	a4,a4,a3
    80005b3c:	00371693          	slli	a3,a4,0x3
    80005b40:	00026717          	auipc	a4,0x26
    80005b44:	1f070713          	addi	a4,a4,496 # 8002bd30 <timer_scratch>
    80005b48:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005b4a:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80005b4c:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80005b4e:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80005b52:	00000797          	auipc	a5,0x0
    80005b56:	93e78793          	addi	a5,a5,-1730 # 80005490 <timervec>
    80005b5a:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005b5e:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80005b62:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005b66:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005b6a:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80005b6e:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80005b72:	30479073          	csrw	mie,a5
}
    80005b76:	6422                	ld	s0,8(sp)
    80005b78:	0141                	addi	sp,sp,16
    80005b7a:	8082                	ret

0000000080005b7c <start>:
{
    80005b7c:	1141                	addi	sp,sp,-16
    80005b7e:	e406                	sd	ra,8(sp)
    80005b80:	e022                	sd	s0,0(sp)
    80005b82:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005b84:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005b88:	7779                	lui	a4,0xffffe
    80005b8a:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffca88f>
    80005b8e:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80005b90:	6705                	lui	a4,0x1
    80005b92:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005b96:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005b98:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005b9c:	ffffa797          	auipc	a5,0xffffa
    80005ba0:	78a78793          	addi	a5,a5,1930 # 80000326 <main>
    80005ba4:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005ba8:	4781                	li	a5,0
    80005baa:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005bae:	67c1                	lui	a5,0x10
    80005bb0:	17fd                	addi	a5,a5,-1
    80005bb2:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005bb6:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005bba:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005bbe:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005bc2:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005bc6:	57fd                	li	a5,-1
    80005bc8:	83a9                	srli	a5,a5,0xa
    80005bca:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005bce:	47bd                	li	a5,15
    80005bd0:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005bd4:	00000097          	auipc	ra,0x0
    80005bd8:	f36080e7          	jalr	-202(ra) # 80005b0a <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005bdc:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005be0:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005be2:	823e                	mv	tp,a5
  asm volatile("mret");
    80005be4:	30200073          	mret
}
    80005be8:	60a2                	ld	ra,8(sp)
    80005bea:	6402                	ld	s0,0(sp)
    80005bec:	0141                	addi	sp,sp,16
    80005bee:	8082                	ret

0000000080005bf0 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005bf0:	715d                	addi	sp,sp,-80
    80005bf2:	e486                	sd	ra,72(sp)
    80005bf4:	e0a2                	sd	s0,64(sp)
    80005bf6:	fc26                	sd	s1,56(sp)
    80005bf8:	f84a                	sd	s2,48(sp)
    80005bfa:	f44e                	sd	s3,40(sp)
    80005bfc:	f052                	sd	s4,32(sp)
    80005bfe:	ec56                	sd	s5,24(sp)
    80005c00:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005c02:	04c05663          	blez	a2,80005c4e <consolewrite+0x5e>
    80005c06:	8a2a                	mv	s4,a0
    80005c08:	84ae                	mv	s1,a1
    80005c0a:	89b2                	mv	s3,a2
    80005c0c:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005c0e:	5afd                	li	s5,-1
    80005c10:	4685                	li	a3,1
    80005c12:	8626                	mv	a2,s1
    80005c14:	85d2                	mv	a1,s4
    80005c16:	fbf40513          	addi	a0,s0,-65
    80005c1a:	ffffc097          	auipc	ra,0xffffc
    80005c1e:	d4a080e7          	jalr	-694(ra) # 80001964 <either_copyin>
    80005c22:	01550c63          	beq	a0,s5,80005c3a <consolewrite+0x4a>
      break;
    uartputc(c);
    80005c26:	fbf44503          	lbu	a0,-65(s0)
    80005c2a:	00000097          	auipc	ra,0x0
    80005c2e:	794080e7          	jalr	1940(ra) # 800063be <uartputc>
  for(i = 0; i < n; i++){
    80005c32:	2905                	addiw	s2,s2,1
    80005c34:	0485                	addi	s1,s1,1
    80005c36:	fd299de3          	bne	s3,s2,80005c10 <consolewrite+0x20>
  }

  return i;
}
    80005c3a:	854a                	mv	a0,s2
    80005c3c:	60a6                	ld	ra,72(sp)
    80005c3e:	6406                	ld	s0,64(sp)
    80005c40:	74e2                	ld	s1,56(sp)
    80005c42:	7942                	ld	s2,48(sp)
    80005c44:	79a2                	ld	s3,40(sp)
    80005c46:	7a02                	ld	s4,32(sp)
    80005c48:	6ae2                	ld	s5,24(sp)
    80005c4a:	6161                	addi	sp,sp,80
    80005c4c:	8082                	ret
  for(i = 0; i < n; i++){
    80005c4e:	4901                	li	s2,0
    80005c50:	b7ed                	j	80005c3a <consolewrite+0x4a>

0000000080005c52 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005c52:	7119                	addi	sp,sp,-128
    80005c54:	fc86                	sd	ra,120(sp)
    80005c56:	f8a2                	sd	s0,112(sp)
    80005c58:	f4a6                	sd	s1,104(sp)
    80005c5a:	f0ca                	sd	s2,96(sp)
    80005c5c:	ecce                	sd	s3,88(sp)
    80005c5e:	e8d2                	sd	s4,80(sp)
    80005c60:	e4d6                	sd	s5,72(sp)
    80005c62:	e0da                	sd	s6,64(sp)
    80005c64:	fc5e                	sd	s7,56(sp)
    80005c66:	f862                	sd	s8,48(sp)
    80005c68:	f466                	sd	s9,40(sp)
    80005c6a:	f06a                	sd	s10,32(sp)
    80005c6c:	ec6e                	sd	s11,24(sp)
    80005c6e:	0100                	addi	s0,sp,128
    80005c70:	8b2a                	mv	s6,a0
    80005c72:	8aae                	mv	s5,a1
    80005c74:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005c76:	00060b9b          	sext.w	s7,a2
  acquire(&cons.lock);
    80005c7a:	0002e517          	auipc	a0,0x2e
    80005c7e:	1f650513          	addi	a0,a0,502 # 80033e70 <cons>
    80005c82:	00001097          	auipc	ra,0x1
    80005c86:	8fa080e7          	jalr	-1798(ra) # 8000657c <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005c8a:	0002e497          	auipc	s1,0x2e
    80005c8e:	1e648493          	addi	s1,s1,486 # 80033e70 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005c92:	89a6                	mv	s3,s1
    80005c94:	0002e917          	auipc	s2,0x2e
    80005c98:	27490913          	addi	s2,s2,628 # 80033f08 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];

    if(c == C('D')){  // end-of-file
    80005c9c:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005c9e:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    80005ca0:	4da9                	li	s11,10
  while(n > 0){
    80005ca2:	07405b63          	blez	s4,80005d18 <consoleread+0xc6>
    while(cons.r == cons.w){
    80005ca6:	0984a783          	lw	a5,152(s1)
    80005caa:	09c4a703          	lw	a4,156(s1)
    80005cae:	02f71763          	bne	a4,a5,80005cdc <consoleread+0x8a>
      if(killed(myproc())){
    80005cb2:	ffffb097          	auipc	ra,0xffffb
    80005cb6:	1b0080e7          	jalr	432(ra) # 80000e62 <myproc>
    80005cba:	ffffc097          	auipc	ra,0xffffc
    80005cbe:	af4080e7          	jalr	-1292(ra) # 800017ae <killed>
    80005cc2:	e535                	bnez	a0,80005d2e <consoleread+0xdc>
      sleep(&cons.r, &cons.lock);
    80005cc4:	85ce                	mv	a1,s3
    80005cc6:	854a                	mv	a0,s2
    80005cc8:	ffffc097          	auipc	ra,0xffffc
    80005ccc:	83e080e7          	jalr	-1986(ra) # 80001506 <sleep>
    while(cons.r == cons.w){
    80005cd0:	0984a783          	lw	a5,152(s1)
    80005cd4:	09c4a703          	lw	a4,156(s1)
    80005cd8:	fcf70de3          	beq	a4,a5,80005cb2 <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80005cdc:	0017871b          	addiw	a4,a5,1
    80005ce0:	08e4ac23          	sw	a4,152(s1)
    80005ce4:	07f7f713          	andi	a4,a5,127
    80005ce8:	9726                	add	a4,a4,s1
    80005cea:	01874703          	lbu	a4,24(a4)
    80005cee:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    80005cf2:	079c0663          	beq	s8,s9,80005d5e <consoleread+0x10c>
    cbuf = c;
    80005cf6:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005cfa:	4685                	li	a3,1
    80005cfc:	f8f40613          	addi	a2,s0,-113
    80005d00:	85d6                	mv	a1,s5
    80005d02:	855a                	mv	a0,s6
    80005d04:	ffffc097          	auipc	ra,0xffffc
    80005d08:	c0a080e7          	jalr	-1014(ra) # 8000190e <either_copyout>
    80005d0c:	01a50663          	beq	a0,s10,80005d18 <consoleread+0xc6>
    dst++;
    80005d10:	0a85                	addi	s5,s5,1
    --n;
    80005d12:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    80005d14:	f9bc17e3          	bne	s8,s11,80005ca2 <consoleread+0x50>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005d18:	0002e517          	auipc	a0,0x2e
    80005d1c:	15850513          	addi	a0,a0,344 # 80033e70 <cons>
    80005d20:	00001097          	auipc	ra,0x1
    80005d24:	910080e7          	jalr	-1776(ra) # 80006630 <release>

  return target - n;
    80005d28:	414b853b          	subw	a0,s7,s4
    80005d2c:	a811                	j	80005d40 <consoleread+0xee>
        release(&cons.lock);
    80005d2e:	0002e517          	auipc	a0,0x2e
    80005d32:	14250513          	addi	a0,a0,322 # 80033e70 <cons>
    80005d36:	00001097          	auipc	ra,0x1
    80005d3a:	8fa080e7          	jalr	-1798(ra) # 80006630 <release>
        return -1;
    80005d3e:	557d                	li	a0,-1
}
    80005d40:	70e6                	ld	ra,120(sp)
    80005d42:	7446                	ld	s0,112(sp)
    80005d44:	74a6                	ld	s1,104(sp)
    80005d46:	7906                	ld	s2,96(sp)
    80005d48:	69e6                	ld	s3,88(sp)
    80005d4a:	6a46                	ld	s4,80(sp)
    80005d4c:	6aa6                	ld	s5,72(sp)
    80005d4e:	6b06                	ld	s6,64(sp)
    80005d50:	7be2                	ld	s7,56(sp)
    80005d52:	7c42                	ld	s8,48(sp)
    80005d54:	7ca2                	ld	s9,40(sp)
    80005d56:	7d02                	ld	s10,32(sp)
    80005d58:	6de2                	ld	s11,24(sp)
    80005d5a:	6109                	addi	sp,sp,128
    80005d5c:	8082                	ret
      if(n < target){
    80005d5e:	000a071b          	sext.w	a4,s4
    80005d62:	fb777be3          	bgeu	a4,s7,80005d18 <consoleread+0xc6>
        cons.r--;
    80005d66:	0002e717          	auipc	a4,0x2e
    80005d6a:	1af72123          	sw	a5,418(a4) # 80033f08 <cons+0x98>
    80005d6e:	b76d                	j	80005d18 <consoleread+0xc6>

0000000080005d70 <consputc>:
{
    80005d70:	1141                	addi	sp,sp,-16
    80005d72:	e406                	sd	ra,8(sp)
    80005d74:	e022                	sd	s0,0(sp)
    80005d76:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005d78:	10000793          	li	a5,256
    80005d7c:	00f50a63          	beq	a0,a5,80005d90 <consputc+0x20>
    uartputc_sync(c);
    80005d80:	00000097          	auipc	ra,0x0
    80005d84:	564080e7          	jalr	1380(ra) # 800062e4 <uartputc_sync>
}
    80005d88:	60a2                	ld	ra,8(sp)
    80005d8a:	6402                	ld	s0,0(sp)
    80005d8c:	0141                	addi	sp,sp,16
    80005d8e:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005d90:	4521                	li	a0,8
    80005d92:	00000097          	auipc	ra,0x0
    80005d96:	552080e7          	jalr	1362(ra) # 800062e4 <uartputc_sync>
    80005d9a:	02000513          	li	a0,32
    80005d9e:	00000097          	auipc	ra,0x0
    80005da2:	546080e7          	jalr	1350(ra) # 800062e4 <uartputc_sync>
    80005da6:	4521                	li	a0,8
    80005da8:	00000097          	auipc	ra,0x0
    80005dac:	53c080e7          	jalr	1340(ra) # 800062e4 <uartputc_sync>
    80005db0:	bfe1                	j	80005d88 <consputc+0x18>

0000000080005db2 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005db2:	1101                	addi	sp,sp,-32
    80005db4:	ec06                	sd	ra,24(sp)
    80005db6:	e822                	sd	s0,16(sp)
    80005db8:	e426                	sd	s1,8(sp)
    80005dba:	e04a                	sd	s2,0(sp)
    80005dbc:	1000                	addi	s0,sp,32
    80005dbe:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005dc0:	0002e517          	auipc	a0,0x2e
    80005dc4:	0b050513          	addi	a0,a0,176 # 80033e70 <cons>
    80005dc8:	00000097          	auipc	ra,0x0
    80005dcc:	7b4080e7          	jalr	1972(ra) # 8000657c <acquire>

  switch(c){
    80005dd0:	47d5                	li	a5,21
    80005dd2:	0af48663          	beq	s1,a5,80005e7e <consoleintr+0xcc>
    80005dd6:	0297ca63          	blt	a5,s1,80005e0a <consoleintr+0x58>
    80005dda:	47a1                	li	a5,8
    80005ddc:	0ef48763          	beq	s1,a5,80005eca <consoleintr+0x118>
    80005de0:	47c1                	li	a5,16
    80005de2:	10f49a63          	bne	s1,a5,80005ef6 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005de6:	ffffc097          	auipc	ra,0xffffc
    80005dea:	bd4080e7          	jalr	-1068(ra) # 800019ba <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005dee:	0002e517          	auipc	a0,0x2e
    80005df2:	08250513          	addi	a0,a0,130 # 80033e70 <cons>
    80005df6:	00001097          	auipc	ra,0x1
    80005dfa:	83a080e7          	jalr	-1990(ra) # 80006630 <release>
}
    80005dfe:	60e2                	ld	ra,24(sp)
    80005e00:	6442                	ld	s0,16(sp)
    80005e02:	64a2                	ld	s1,8(sp)
    80005e04:	6902                	ld	s2,0(sp)
    80005e06:	6105                	addi	sp,sp,32
    80005e08:	8082                	ret
  switch(c){
    80005e0a:	07f00793          	li	a5,127
    80005e0e:	0af48e63          	beq	s1,a5,80005eca <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005e12:	0002e717          	auipc	a4,0x2e
    80005e16:	05e70713          	addi	a4,a4,94 # 80033e70 <cons>
    80005e1a:	0a072783          	lw	a5,160(a4)
    80005e1e:	09872703          	lw	a4,152(a4)
    80005e22:	9f99                	subw	a5,a5,a4
    80005e24:	07f00713          	li	a4,127
    80005e28:	fcf763e3          	bltu	a4,a5,80005dee <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005e2c:	47b5                	li	a5,13
    80005e2e:	0cf48763          	beq	s1,a5,80005efc <consoleintr+0x14a>
      consputc(c);
    80005e32:	8526                	mv	a0,s1
    80005e34:	00000097          	auipc	ra,0x0
    80005e38:	f3c080e7          	jalr	-196(ra) # 80005d70 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005e3c:	0002e797          	auipc	a5,0x2e
    80005e40:	03478793          	addi	a5,a5,52 # 80033e70 <cons>
    80005e44:	0a07a683          	lw	a3,160(a5)
    80005e48:	0016871b          	addiw	a4,a3,1
    80005e4c:	0007061b          	sext.w	a2,a4
    80005e50:	0ae7a023          	sw	a4,160(a5)
    80005e54:	07f6f693          	andi	a3,a3,127
    80005e58:	97b6                	add	a5,a5,a3
    80005e5a:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005e5e:	47a9                	li	a5,10
    80005e60:	0cf48563          	beq	s1,a5,80005f2a <consoleintr+0x178>
    80005e64:	4791                	li	a5,4
    80005e66:	0cf48263          	beq	s1,a5,80005f2a <consoleintr+0x178>
    80005e6a:	0002e797          	auipc	a5,0x2e
    80005e6e:	09e7a783          	lw	a5,158(a5) # 80033f08 <cons+0x98>
    80005e72:	9f1d                	subw	a4,a4,a5
    80005e74:	08000793          	li	a5,128
    80005e78:	f6f71be3          	bne	a4,a5,80005dee <consoleintr+0x3c>
    80005e7c:	a07d                	j	80005f2a <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005e7e:	0002e717          	auipc	a4,0x2e
    80005e82:	ff270713          	addi	a4,a4,-14 # 80033e70 <cons>
    80005e86:	0a072783          	lw	a5,160(a4)
    80005e8a:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005e8e:	0002e497          	auipc	s1,0x2e
    80005e92:	fe248493          	addi	s1,s1,-30 # 80033e70 <cons>
    while(cons.e != cons.w &&
    80005e96:	4929                	li	s2,10
    80005e98:	f4f70be3          	beq	a4,a5,80005dee <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005e9c:	37fd                	addiw	a5,a5,-1
    80005e9e:	07f7f713          	andi	a4,a5,127
    80005ea2:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005ea4:	01874703          	lbu	a4,24(a4)
    80005ea8:	f52703e3          	beq	a4,s2,80005dee <consoleintr+0x3c>
      cons.e--;
    80005eac:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005eb0:	10000513          	li	a0,256
    80005eb4:	00000097          	auipc	ra,0x0
    80005eb8:	ebc080e7          	jalr	-324(ra) # 80005d70 <consputc>
    while(cons.e != cons.w &&
    80005ebc:	0a04a783          	lw	a5,160(s1)
    80005ec0:	09c4a703          	lw	a4,156(s1)
    80005ec4:	fcf71ce3          	bne	a4,a5,80005e9c <consoleintr+0xea>
    80005ec8:	b71d                	j	80005dee <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005eca:	0002e717          	auipc	a4,0x2e
    80005ece:	fa670713          	addi	a4,a4,-90 # 80033e70 <cons>
    80005ed2:	0a072783          	lw	a5,160(a4)
    80005ed6:	09c72703          	lw	a4,156(a4)
    80005eda:	f0f70ae3          	beq	a4,a5,80005dee <consoleintr+0x3c>
      cons.e--;
    80005ede:	37fd                	addiw	a5,a5,-1
    80005ee0:	0002e717          	auipc	a4,0x2e
    80005ee4:	02f72823          	sw	a5,48(a4) # 80033f10 <cons+0xa0>
      consputc(BACKSPACE);
    80005ee8:	10000513          	li	a0,256
    80005eec:	00000097          	auipc	ra,0x0
    80005ef0:	e84080e7          	jalr	-380(ra) # 80005d70 <consputc>
    80005ef4:	bded                	j	80005dee <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005ef6:	ee048ce3          	beqz	s1,80005dee <consoleintr+0x3c>
    80005efa:	bf21                	j	80005e12 <consoleintr+0x60>
      consputc(c);
    80005efc:	4529                	li	a0,10
    80005efe:	00000097          	auipc	ra,0x0
    80005f02:	e72080e7          	jalr	-398(ra) # 80005d70 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005f06:	0002e797          	auipc	a5,0x2e
    80005f0a:	f6a78793          	addi	a5,a5,-150 # 80033e70 <cons>
    80005f0e:	0a07a703          	lw	a4,160(a5)
    80005f12:	0017069b          	addiw	a3,a4,1
    80005f16:	0006861b          	sext.w	a2,a3
    80005f1a:	0ad7a023          	sw	a3,160(a5)
    80005f1e:	07f77713          	andi	a4,a4,127
    80005f22:	97ba                	add	a5,a5,a4
    80005f24:	4729                	li	a4,10
    80005f26:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005f2a:	0002e797          	auipc	a5,0x2e
    80005f2e:	fec7a123          	sw	a2,-30(a5) # 80033f0c <cons+0x9c>
        wakeup(&cons.r);
    80005f32:	0002e517          	auipc	a0,0x2e
    80005f36:	fd650513          	addi	a0,a0,-42 # 80033f08 <cons+0x98>
    80005f3a:	ffffb097          	auipc	ra,0xffffb
    80005f3e:	630080e7          	jalr	1584(ra) # 8000156a <wakeup>
    80005f42:	b575                	j	80005dee <consoleintr+0x3c>

0000000080005f44 <consoleinit>:

void
consoleinit(void)
{
    80005f44:	1141                	addi	sp,sp,-16
    80005f46:	e406                	sd	ra,8(sp)
    80005f48:	e022                	sd	s0,0(sp)
    80005f4a:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005f4c:	00003597          	auipc	a1,0x3
    80005f50:	a8c58593          	addi	a1,a1,-1396 # 800089d8 <syscalls+0x5e8>
    80005f54:	0002e517          	auipc	a0,0x2e
    80005f58:	f1c50513          	addi	a0,a0,-228 # 80033e70 <cons>
    80005f5c:	00000097          	auipc	ra,0x0
    80005f60:	590080e7          	jalr	1424(ra) # 800064ec <initlock>

  uartinit();
    80005f64:	00000097          	auipc	ra,0x0
    80005f68:	330080e7          	jalr	816(ra) # 80006294 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005f6c:	00025797          	auipc	a5,0x25
    80005f70:	c2c78793          	addi	a5,a5,-980 # 8002ab98 <devsw>
    80005f74:	00000717          	auipc	a4,0x0
    80005f78:	cde70713          	addi	a4,a4,-802 # 80005c52 <consoleread>
    80005f7c:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005f7e:	00000717          	auipc	a4,0x0
    80005f82:	c7270713          	addi	a4,a4,-910 # 80005bf0 <consolewrite>
    80005f86:	ef98                	sd	a4,24(a5)
}
    80005f88:	60a2                	ld	ra,8(sp)
    80005f8a:	6402                	ld	s0,0(sp)
    80005f8c:	0141                	addi	sp,sp,16
    80005f8e:	8082                	ret

0000000080005f90 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005f90:	7179                	addi	sp,sp,-48
    80005f92:	f406                	sd	ra,40(sp)
    80005f94:	f022                	sd	s0,32(sp)
    80005f96:	ec26                	sd	s1,24(sp)
    80005f98:	e84a                	sd	s2,16(sp)
    80005f9a:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005f9c:	c219                	beqz	a2,80005fa2 <printint+0x12>
    80005f9e:	08054663          	bltz	a0,8000602a <printint+0x9a>
    x = -xx;
  else
    x = xx;
    80005fa2:	2501                	sext.w	a0,a0
    80005fa4:	4881                	li	a7,0
    80005fa6:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005faa:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005fac:	2581                	sext.w	a1,a1
    80005fae:	00003617          	auipc	a2,0x3
    80005fb2:	a5a60613          	addi	a2,a2,-1446 # 80008a08 <digits>
    80005fb6:	883a                	mv	a6,a4
    80005fb8:	2705                	addiw	a4,a4,1
    80005fba:	02b577bb          	remuw	a5,a0,a1
    80005fbe:	1782                	slli	a5,a5,0x20
    80005fc0:	9381                	srli	a5,a5,0x20
    80005fc2:	97b2                	add	a5,a5,a2
    80005fc4:	0007c783          	lbu	a5,0(a5)
    80005fc8:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005fcc:	0005079b          	sext.w	a5,a0
    80005fd0:	02b5553b          	divuw	a0,a0,a1
    80005fd4:	0685                	addi	a3,a3,1
    80005fd6:	feb7f0e3          	bgeu	a5,a1,80005fb6 <printint+0x26>

  if(sign)
    80005fda:	00088b63          	beqz	a7,80005ff0 <printint+0x60>
    buf[i++] = '-';
    80005fde:	fe040793          	addi	a5,s0,-32
    80005fe2:	973e                	add	a4,a4,a5
    80005fe4:	02d00793          	li	a5,45
    80005fe8:	fef70823          	sb	a5,-16(a4)
    80005fec:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005ff0:	02e05763          	blez	a4,8000601e <printint+0x8e>
    80005ff4:	fd040793          	addi	a5,s0,-48
    80005ff8:	00e784b3          	add	s1,a5,a4
    80005ffc:	fff78913          	addi	s2,a5,-1
    80006000:	993a                	add	s2,s2,a4
    80006002:	377d                	addiw	a4,a4,-1
    80006004:	1702                	slli	a4,a4,0x20
    80006006:	9301                	srli	a4,a4,0x20
    80006008:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    8000600c:	fff4c503          	lbu	a0,-1(s1)
    80006010:	00000097          	auipc	ra,0x0
    80006014:	d60080e7          	jalr	-672(ra) # 80005d70 <consputc>
  while(--i >= 0)
    80006018:	14fd                	addi	s1,s1,-1
    8000601a:	ff2499e3          	bne	s1,s2,8000600c <printint+0x7c>
}
    8000601e:	70a2                	ld	ra,40(sp)
    80006020:	7402                	ld	s0,32(sp)
    80006022:	64e2                	ld	s1,24(sp)
    80006024:	6942                	ld	s2,16(sp)
    80006026:	6145                	addi	sp,sp,48
    80006028:	8082                	ret
    x = -xx;
    8000602a:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    8000602e:	4885                	li	a7,1
    x = -xx;
    80006030:	bf9d                	j	80005fa6 <printint+0x16>

0000000080006032 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80006032:	1101                	addi	sp,sp,-32
    80006034:	ec06                	sd	ra,24(sp)
    80006036:	e822                	sd	s0,16(sp)
    80006038:	e426                	sd	s1,8(sp)
    8000603a:	1000                	addi	s0,sp,32
    8000603c:	84aa                	mv	s1,a0
  pr.locking = 0;
    8000603e:	0002e797          	auipc	a5,0x2e
    80006042:	ee07a923          	sw	zero,-270(a5) # 80033f30 <pr+0x18>
  printf("panic: ");
    80006046:	00003517          	auipc	a0,0x3
    8000604a:	99a50513          	addi	a0,a0,-1638 # 800089e0 <syscalls+0x5f0>
    8000604e:	00000097          	auipc	ra,0x0
    80006052:	02e080e7          	jalr	46(ra) # 8000607c <printf>
  printf(s);
    80006056:	8526                	mv	a0,s1
    80006058:	00000097          	auipc	ra,0x0
    8000605c:	024080e7          	jalr	36(ra) # 8000607c <printf>
  printf("\n");
    80006060:	00002517          	auipc	a0,0x2
    80006064:	fe850513          	addi	a0,a0,-24 # 80008048 <etext+0x48>
    80006068:	00000097          	auipc	ra,0x0
    8000606c:	014080e7          	jalr	20(ra) # 8000607c <printf>
  panicked = 1; // freeze uart output from other CPUs
    80006070:	4785                	li	a5,1
    80006072:	00003717          	auipc	a4,0x3
    80006076:	a6f72d23          	sw	a5,-1414(a4) # 80008aec <panicked>
  for(;;)
    8000607a:	a001                	j	8000607a <panic+0x48>

000000008000607c <printf>:
{
    8000607c:	7131                	addi	sp,sp,-192
    8000607e:	fc86                	sd	ra,120(sp)
    80006080:	f8a2                	sd	s0,112(sp)
    80006082:	f4a6                	sd	s1,104(sp)
    80006084:	f0ca                	sd	s2,96(sp)
    80006086:	ecce                	sd	s3,88(sp)
    80006088:	e8d2                	sd	s4,80(sp)
    8000608a:	e4d6                	sd	s5,72(sp)
    8000608c:	e0da                	sd	s6,64(sp)
    8000608e:	fc5e                	sd	s7,56(sp)
    80006090:	f862                	sd	s8,48(sp)
    80006092:	f466                	sd	s9,40(sp)
    80006094:	f06a                	sd	s10,32(sp)
    80006096:	ec6e                	sd	s11,24(sp)
    80006098:	0100                	addi	s0,sp,128
    8000609a:	8a2a                	mv	s4,a0
    8000609c:	e40c                	sd	a1,8(s0)
    8000609e:	e810                	sd	a2,16(s0)
    800060a0:	ec14                	sd	a3,24(s0)
    800060a2:	f018                	sd	a4,32(s0)
    800060a4:	f41c                	sd	a5,40(s0)
    800060a6:	03043823          	sd	a6,48(s0)
    800060aa:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    800060ae:	0002ed97          	auipc	s11,0x2e
    800060b2:	e82dad83          	lw	s11,-382(s11) # 80033f30 <pr+0x18>
  if(locking)
    800060b6:	020d9b63          	bnez	s11,800060ec <printf+0x70>
  if (fmt == 0)
    800060ba:	040a0263          	beqz	s4,800060fe <printf+0x82>
  va_start(ap, fmt);
    800060be:	00840793          	addi	a5,s0,8
    800060c2:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    800060c6:	000a4503          	lbu	a0,0(s4)
    800060ca:	16050263          	beqz	a0,8000622e <printf+0x1b2>
    800060ce:	4481                	li	s1,0
    if(c != '%'){
    800060d0:	02500a93          	li	s5,37
    switch(c){
    800060d4:	07000b13          	li	s6,112
  consputc('x');
    800060d8:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800060da:	00003b97          	auipc	s7,0x3
    800060de:	92eb8b93          	addi	s7,s7,-1746 # 80008a08 <digits>
    switch(c){
    800060e2:	07300c93          	li	s9,115
    800060e6:	06400c13          	li	s8,100
    800060ea:	a82d                	j	80006124 <printf+0xa8>
    acquire(&pr.lock);
    800060ec:	0002e517          	auipc	a0,0x2e
    800060f0:	e2c50513          	addi	a0,a0,-468 # 80033f18 <pr>
    800060f4:	00000097          	auipc	ra,0x0
    800060f8:	488080e7          	jalr	1160(ra) # 8000657c <acquire>
    800060fc:	bf7d                	j	800060ba <printf+0x3e>
    panic("null fmt");
    800060fe:	00003517          	auipc	a0,0x3
    80006102:	8f250513          	addi	a0,a0,-1806 # 800089f0 <syscalls+0x600>
    80006106:	00000097          	auipc	ra,0x0
    8000610a:	f2c080e7          	jalr	-212(ra) # 80006032 <panic>
      consputc(c);
    8000610e:	00000097          	auipc	ra,0x0
    80006112:	c62080e7          	jalr	-926(ra) # 80005d70 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80006116:	2485                	addiw	s1,s1,1
    80006118:	009a07b3          	add	a5,s4,s1
    8000611c:	0007c503          	lbu	a0,0(a5)
    80006120:	10050763          	beqz	a0,8000622e <printf+0x1b2>
    if(c != '%'){
    80006124:	ff5515e3          	bne	a0,s5,8000610e <printf+0x92>
    c = fmt[++i] & 0xff;
    80006128:	2485                	addiw	s1,s1,1
    8000612a:	009a07b3          	add	a5,s4,s1
    8000612e:	0007c783          	lbu	a5,0(a5)
    80006132:	0007891b          	sext.w	s2,a5
    if(c == 0)
    80006136:	cfe5                	beqz	a5,8000622e <printf+0x1b2>
    switch(c){
    80006138:	05678a63          	beq	a5,s6,8000618c <printf+0x110>
    8000613c:	02fb7663          	bgeu	s6,a5,80006168 <printf+0xec>
    80006140:	09978963          	beq	a5,s9,800061d2 <printf+0x156>
    80006144:	07800713          	li	a4,120
    80006148:	0ce79863          	bne	a5,a4,80006218 <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    8000614c:	f8843783          	ld	a5,-120(s0)
    80006150:	00878713          	addi	a4,a5,8
    80006154:	f8e43423          	sd	a4,-120(s0)
    80006158:	4605                	li	a2,1
    8000615a:	85ea                	mv	a1,s10
    8000615c:	4388                	lw	a0,0(a5)
    8000615e:	00000097          	auipc	ra,0x0
    80006162:	e32080e7          	jalr	-462(ra) # 80005f90 <printint>
      break;
    80006166:	bf45                	j	80006116 <printf+0x9a>
    switch(c){
    80006168:	0b578263          	beq	a5,s5,8000620c <printf+0x190>
    8000616c:	0b879663          	bne	a5,s8,80006218 <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    80006170:	f8843783          	ld	a5,-120(s0)
    80006174:	00878713          	addi	a4,a5,8
    80006178:	f8e43423          	sd	a4,-120(s0)
    8000617c:	4605                	li	a2,1
    8000617e:	45a9                	li	a1,10
    80006180:	4388                	lw	a0,0(a5)
    80006182:	00000097          	auipc	ra,0x0
    80006186:	e0e080e7          	jalr	-498(ra) # 80005f90 <printint>
      break;
    8000618a:	b771                	j	80006116 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    8000618c:	f8843783          	ld	a5,-120(s0)
    80006190:	00878713          	addi	a4,a5,8
    80006194:	f8e43423          	sd	a4,-120(s0)
    80006198:	0007b983          	ld	s3,0(a5)
  consputc('0');
    8000619c:	03000513          	li	a0,48
    800061a0:	00000097          	auipc	ra,0x0
    800061a4:	bd0080e7          	jalr	-1072(ra) # 80005d70 <consputc>
  consputc('x');
    800061a8:	07800513          	li	a0,120
    800061ac:	00000097          	auipc	ra,0x0
    800061b0:	bc4080e7          	jalr	-1084(ra) # 80005d70 <consputc>
    800061b4:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    800061b6:	03c9d793          	srli	a5,s3,0x3c
    800061ba:	97de                	add	a5,a5,s7
    800061bc:	0007c503          	lbu	a0,0(a5)
    800061c0:	00000097          	auipc	ra,0x0
    800061c4:	bb0080e7          	jalr	-1104(ra) # 80005d70 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    800061c8:	0992                	slli	s3,s3,0x4
    800061ca:	397d                	addiw	s2,s2,-1
    800061cc:	fe0915e3          	bnez	s2,800061b6 <printf+0x13a>
    800061d0:	b799                	j	80006116 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    800061d2:	f8843783          	ld	a5,-120(s0)
    800061d6:	00878713          	addi	a4,a5,8
    800061da:	f8e43423          	sd	a4,-120(s0)
    800061de:	0007b903          	ld	s2,0(a5)
    800061e2:	00090e63          	beqz	s2,800061fe <printf+0x182>
      for(; *s; s++)
    800061e6:	00094503          	lbu	a0,0(s2)
    800061ea:	d515                	beqz	a0,80006116 <printf+0x9a>
        consputc(*s);
    800061ec:	00000097          	auipc	ra,0x0
    800061f0:	b84080e7          	jalr	-1148(ra) # 80005d70 <consputc>
      for(; *s; s++)
    800061f4:	0905                	addi	s2,s2,1
    800061f6:	00094503          	lbu	a0,0(s2)
    800061fa:	f96d                	bnez	a0,800061ec <printf+0x170>
    800061fc:	bf29                	j	80006116 <printf+0x9a>
        s = "(null)";
    800061fe:	00002917          	auipc	s2,0x2
    80006202:	7ea90913          	addi	s2,s2,2026 # 800089e8 <syscalls+0x5f8>
      for(; *s; s++)
    80006206:	02800513          	li	a0,40
    8000620a:	b7cd                	j	800061ec <printf+0x170>
      consputc('%');
    8000620c:	8556                	mv	a0,s5
    8000620e:	00000097          	auipc	ra,0x0
    80006212:	b62080e7          	jalr	-1182(ra) # 80005d70 <consputc>
      break;
    80006216:	b701                	j	80006116 <printf+0x9a>
      consputc('%');
    80006218:	8556                	mv	a0,s5
    8000621a:	00000097          	auipc	ra,0x0
    8000621e:	b56080e7          	jalr	-1194(ra) # 80005d70 <consputc>
      consputc(c);
    80006222:	854a                	mv	a0,s2
    80006224:	00000097          	auipc	ra,0x0
    80006228:	b4c080e7          	jalr	-1204(ra) # 80005d70 <consputc>
      break;
    8000622c:	b5ed                	j	80006116 <printf+0x9a>
  if(locking)
    8000622e:	020d9163          	bnez	s11,80006250 <printf+0x1d4>
}
    80006232:	70e6                	ld	ra,120(sp)
    80006234:	7446                	ld	s0,112(sp)
    80006236:	74a6                	ld	s1,104(sp)
    80006238:	7906                	ld	s2,96(sp)
    8000623a:	69e6                	ld	s3,88(sp)
    8000623c:	6a46                	ld	s4,80(sp)
    8000623e:	6aa6                	ld	s5,72(sp)
    80006240:	6b06                	ld	s6,64(sp)
    80006242:	7be2                	ld	s7,56(sp)
    80006244:	7c42                	ld	s8,48(sp)
    80006246:	7ca2                	ld	s9,40(sp)
    80006248:	7d02                	ld	s10,32(sp)
    8000624a:	6de2                	ld	s11,24(sp)
    8000624c:	6129                	addi	sp,sp,192
    8000624e:	8082                	ret
    release(&pr.lock);
    80006250:	0002e517          	auipc	a0,0x2e
    80006254:	cc850513          	addi	a0,a0,-824 # 80033f18 <pr>
    80006258:	00000097          	auipc	ra,0x0
    8000625c:	3d8080e7          	jalr	984(ra) # 80006630 <release>
}
    80006260:	bfc9                	j	80006232 <printf+0x1b6>

0000000080006262 <printfinit>:
    ;
}

void
printfinit(void)
{
    80006262:	1101                	addi	sp,sp,-32
    80006264:	ec06                	sd	ra,24(sp)
    80006266:	e822                	sd	s0,16(sp)
    80006268:	e426                	sd	s1,8(sp)
    8000626a:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    8000626c:	0002e497          	auipc	s1,0x2e
    80006270:	cac48493          	addi	s1,s1,-852 # 80033f18 <pr>
    80006274:	00002597          	auipc	a1,0x2
    80006278:	78c58593          	addi	a1,a1,1932 # 80008a00 <syscalls+0x610>
    8000627c:	8526                	mv	a0,s1
    8000627e:	00000097          	auipc	ra,0x0
    80006282:	26e080e7          	jalr	622(ra) # 800064ec <initlock>
  pr.locking = 1;
    80006286:	4785                	li	a5,1
    80006288:	cc9c                	sw	a5,24(s1)
}
    8000628a:	60e2                	ld	ra,24(sp)
    8000628c:	6442                	ld	s0,16(sp)
    8000628e:	64a2                	ld	s1,8(sp)
    80006290:	6105                	addi	sp,sp,32
    80006292:	8082                	ret

0000000080006294 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80006294:	1141                	addi	sp,sp,-16
    80006296:	e406                	sd	ra,8(sp)
    80006298:	e022                	sd	s0,0(sp)
    8000629a:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    8000629c:	100007b7          	lui	a5,0x10000
    800062a0:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800062a4:	f8000713          	li	a4,-128
    800062a8:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800062ac:	470d                	li	a4,3
    800062ae:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    800062b2:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    800062b6:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    800062ba:	469d                	li	a3,7
    800062bc:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    800062c0:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    800062c4:	00002597          	auipc	a1,0x2
    800062c8:	75c58593          	addi	a1,a1,1884 # 80008a20 <digits+0x18>
    800062cc:	0002e517          	auipc	a0,0x2e
    800062d0:	c6c50513          	addi	a0,a0,-916 # 80033f38 <uart_tx_lock>
    800062d4:	00000097          	auipc	ra,0x0
    800062d8:	218080e7          	jalr	536(ra) # 800064ec <initlock>
}
    800062dc:	60a2                	ld	ra,8(sp)
    800062de:	6402                	ld	s0,0(sp)
    800062e0:	0141                	addi	sp,sp,16
    800062e2:	8082                	ret

00000000800062e4 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    800062e4:	1101                	addi	sp,sp,-32
    800062e6:	ec06                	sd	ra,24(sp)
    800062e8:	e822                	sd	s0,16(sp)
    800062ea:	e426                	sd	s1,8(sp)
    800062ec:	1000                	addi	s0,sp,32
    800062ee:	84aa                	mv	s1,a0
  push_off();
    800062f0:	00000097          	auipc	ra,0x0
    800062f4:	240080e7          	jalr	576(ra) # 80006530 <push_off>

  if(panicked){
    800062f8:	00002797          	auipc	a5,0x2
    800062fc:	7f47a783          	lw	a5,2036(a5) # 80008aec <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006300:	10000737          	lui	a4,0x10000
  if(panicked){
    80006304:	c391                	beqz	a5,80006308 <uartputc_sync+0x24>
    for(;;)
    80006306:	a001                	j	80006306 <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006308:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    8000630c:	0ff7f793          	andi	a5,a5,255
    80006310:	0207f793          	andi	a5,a5,32
    80006314:	dbf5                	beqz	a5,80006308 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80006316:	0ff4f793          	andi	a5,s1,255
    8000631a:	10000737          	lui	a4,0x10000
    8000631e:	00f70023          	sb	a5,0(a4) # 10000000 <_entry-0x70000000>

  pop_off();
    80006322:	00000097          	auipc	ra,0x0
    80006326:	2ae080e7          	jalr	686(ra) # 800065d0 <pop_off>
}
    8000632a:	60e2                	ld	ra,24(sp)
    8000632c:	6442                	ld	s0,16(sp)
    8000632e:	64a2                	ld	s1,8(sp)
    80006330:	6105                	addi	sp,sp,32
    80006332:	8082                	ret

0000000080006334 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80006334:	00002717          	auipc	a4,0x2
    80006338:	7bc73703          	ld	a4,1980(a4) # 80008af0 <uart_tx_r>
    8000633c:	00002797          	auipc	a5,0x2
    80006340:	7bc7b783          	ld	a5,1980(a5) # 80008af8 <uart_tx_w>
    80006344:	06e78c63          	beq	a5,a4,800063bc <uartstart+0x88>
{
    80006348:	7139                	addi	sp,sp,-64
    8000634a:	fc06                	sd	ra,56(sp)
    8000634c:	f822                	sd	s0,48(sp)
    8000634e:	f426                	sd	s1,40(sp)
    80006350:	f04a                	sd	s2,32(sp)
    80006352:	ec4e                	sd	s3,24(sp)
    80006354:	e852                	sd	s4,16(sp)
    80006356:	e456                	sd	s5,8(sp)
    80006358:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000635a:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000635e:	0002ea17          	auipc	s4,0x2e
    80006362:	bdaa0a13          	addi	s4,s4,-1062 # 80033f38 <uart_tx_lock>
    uart_tx_r += 1;
    80006366:	00002497          	auipc	s1,0x2
    8000636a:	78a48493          	addi	s1,s1,1930 # 80008af0 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    8000636e:	00002997          	auipc	s3,0x2
    80006372:	78a98993          	addi	s3,s3,1930 # 80008af8 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006376:	00594783          	lbu	a5,5(s2) # 10000005 <_entry-0x6ffffffb>
    8000637a:	0ff7f793          	andi	a5,a5,255
    8000637e:	0207f793          	andi	a5,a5,32
    80006382:	c785                	beqz	a5,800063aa <uartstart+0x76>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006384:	01f77793          	andi	a5,a4,31
    80006388:	97d2                	add	a5,a5,s4
    8000638a:	0187ca83          	lbu	s5,24(a5)
    uart_tx_r += 1;
    8000638e:	0705                	addi	a4,a4,1
    80006390:	e098                	sd	a4,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80006392:	8526                	mv	a0,s1
    80006394:	ffffb097          	auipc	ra,0xffffb
    80006398:	1d6080e7          	jalr	470(ra) # 8000156a <wakeup>
    
    WriteReg(THR, c);
    8000639c:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    800063a0:	6098                	ld	a4,0(s1)
    800063a2:	0009b783          	ld	a5,0(s3)
    800063a6:	fce798e3          	bne	a5,a4,80006376 <uartstart+0x42>
  }
}
    800063aa:	70e2                	ld	ra,56(sp)
    800063ac:	7442                	ld	s0,48(sp)
    800063ae:	74a2                	ld	s1,40(sp)
    800063b0:	7902                	ld	s2,32(sp)
    800063b2:	69e2                	ld	s3,24(sp)
    800063b4:	6a42                	ld	s4,16(sp)
    800063b6:	6aa2                	ld	s5,8(sp)
    800063b8:	6121                	addi	sp,sp,64
    800063ba:	8082                	ret
    800063bc:	8082                	ret

00000000800063be <uartputc>:
{
    800063be:	7179                	addi	sp,sp,-48
    800063c0:	f406                	sd	ra,40(sp)
    800063c2:	f022                	sd	s0,32(sp)
    800063c4:	ec26                	sd	s1,24(sp)
    800063c6:	e84a                	sd	s2,16(sp)
    800063c8:	e44e                	sd	s3,8(sp)
    800063ca:	e052                	sd	s4,0(sp)
    800063cc:	1800                	addi	s0,sp,48
    800063ce:	89aa                	mv	s3,a0
  acquire(&uart_tx_lock);
    800063d0:	0002e517          	auipc	a0,0x2e
    800063d4:	b6850513          	addi	a0,a0,-1176 # 80033f38 <uart_tx_lock>
    800063d8:	00000097          	auipc	ra,0x0
    800063dc:	1a4080e7          	jalr	420(ra) # 8000657c <acquire>
  if(panicked){
    800063e0:	00002797          	auipc	a5,0x2
    800063e4:	70c7a783          	lw	a5,1804(a5) # 80008aec <panicked>
    800063e8:	e7c9                	bnez	a5,80006472 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800063ea:	00002797          	auipc	a5,0x2
    800063ee:	70e7b783          	ld	a5,1806(a5) # 80008af8 <uart_tx_w>
    800063f2:	00002717          	auipc	a4,0x2
    800063f6:	6fe73703          	ld	a4,1790(a4) # 80008af0 <uart_tx_r>
    800063fa:	02070713          	addi	a4,a4,32
    sleep(&uart_tx_r, &uart_tx_lock);
    800063fe:	0002ea17          	auipc	s4,0x2e
    80006402:	b3aa0a13          	addi	s4,s4,-1222 # 80033f38 <uart_tx_lock>
    80006406:	00002497          	auipc	s1,0x2
    8000640a:	6ea48493          	addi	s1,s1,1770 # 80008af0 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000640e:	00002917          	auipc	s2,0x2
    80006412:	6ea90913          	addi	s2,s2,1770 # 80008af8 <uart_tx_w>
    80006416:	00f71f63          	bne	a4,a5,80006434 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    8000641a:	85d2                	mv	a1,s4
    8000641c:	8526                	mv	a0,s1
    8000641e:	ffffb097          	auipc	ra,0xffffb
    80006422:	0e8080e7          	jalr	232(ra) # 80001506 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006426:	00093783          	ld	a5,0(s2)
    8000642a:	6098                	ld	a4,0(s1)
    8000642c:	02070713          	addi	a4,a4,32
    80006430:	fef705e3          	beq	a4,a5,8000641a <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80006434:	0002e497          	auipc	s1,0x2e
    80006438:	b0448493          	addi	s1,s1,-1276 # 80033f38 <uart_tx_lock>
    8000643c:	01f7f713          	andi	a4,a5,31
    80006440:	9726                	add	a4,a4,s1
    80006442:	01370c23          	sb	s3,24(a4)
  uart_tx_w += 1;
    80006446:	0785                	addi	a5,a5,1
    80006448:	00002717          	auipc	a4,0x2
    8000644c:	6af73823          	sd	a5,1712(a4) # 80008af8 <uart_tx_w>
  uartstart();
    80006450:	00000097          	auipc	ra,0x0
    80006454:	ee4080e7          	jalr	-284(ra) # 80006334 <uartstart>
  release(&uart_tx_lock);
    80006458:	8526                	mv	a0,s1
    8000645a:	00000097          	auipc	ra,0x0
    8000645e:	1d6080e7          	jalr	470(ra) # 80006630 <release>
}
    80006462:	70a2                	ld	ra,40(sp)
    80006464:	7402                	ld	s0,32(sp)
    80006466:	64e2                	ld	s1,24(sp)
    80006468:	6942                	ld	s2,16(sp)
    8000646a:	69a2                	ld	s3,8(sp)
    8000646c:	6a02                	ld	s4,0(sp)
    8000646e:	6145                	addi	sp,sp,48
    80006470:	8082                	ret
    for(;;)
    80006472:	a001                	j	80006472 <uartputc+0xb4>

0000000080006474 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80006474:	1141                	addi	sp,sp,-16
    80006476:	e422                	sd	s0,8(sp)
    80006478:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    8000647a:	100007b7          	lui	a5,0x10000
    8000647e:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80006482:	8b85                	andi	a5,a5,1
    80006484:	cb91                	beqz	a5,80006498 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    80006486:	100007b7          	lui	a5,0x10000
    8000648a:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    8000648e:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    80006492:	6422                	ld	s0,8(sp)
    80006494:	0141                	addi	sp,sp,16
    80006496:	8082                	ret
    return -1;
    80006498:	557d                	li	a0,-1
    8000649a:	bfe5                	j	80006492 <uartgetc+0x1e>

000000008000649c <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    8000649c:	1101                	addi	sp,sp,-32
    8000649e:	ec06                	sd	ra,24(sp)
    800064a0:	e822                	sd	s0,16(sp)
    800064a2:	e426                	sd	s1,8(sp)
    800064a4:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800064a6:	54fd                	li	s1,-1
    int c = uartgetc();
    800064a8:	00000097          	auipc	ra,0x0
    800064ac:	fcc080e7          	jalr	-52(ra) # 80006474 <uartgetc>
    if(c == -1)
    800064b0:	00950763          	beq	a0,s1,800064be <uartintr+0x22>
      break;
    consoleintr(c);
    800064b4:	00000097          	auipc	ra,0x0
    800064b8:	8fe080e7          	jalr	-1794(ra) # 80005db2 <consoleintr>
  while(1){
    800064bc:	b7f5                	j	800064a8 <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    800064be:	0002e497          	auipc	s1,0x2e
    800064c2:	a7a48493          	addi	s1,s1,-1414 # 80033f38 <uart_tx_lock>
    800064c6:	8526                	mv	a0,s1
    800064c8:	00000097          	auipc	ra,0x0
    800064cc:	0b4080e7          	jalr	180(ra) # 8000657c <acquire>
  uartstart();
    800064d0:	00000097          	auipc	ra,0x0
    800064d4:	e64080e7          	jalr	-412(ra) # 80006334 <uartstart>
  release(&uart_tx_lock);
    800064d8:	8526                	mv	a0,s1
    800064da:	00000097          	auipc	ra,0x0
    800064de:	156080e7          	jalr	342(ra) # 80006630 <release>
}
    800064e2:	60e2                	ld	ra,24(sp)
    800064e4:	6442                	ld	s0,16(sp)
    800064e6:	64a2                	ld	s1,8(sp)
    800064e8:	6105                	addi	sp,sp,32
    800064ea:	8082                	ret

00000000800064ec <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    800064ec:	1141                	addi	sp,sp,-16
    800064ee:	e422                	sd	s0,8(sp)
    800064f0:	0800                	addi	s0,sp,16
  lk->name = name;
    800064f2:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    800064f4:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    800064f8:	00053823          	sd	zero,16(a0)
}
    800064fc:	6422                	ld	s0,8(sp)
    800064fe:	0141                	addi	sp,sp,16
    80006500:	8082                	ret

0000000080006502 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80006502:	411c                	lw	a5,0(a0)
    80006504:	e399                	bnez	a5,8000650a <holding+0x8>
    80006506:	4501                	li	a0,0
  return r;
}
    80006508:	8082                	ret
{
    8000650a:	1101                	addi	sp,sp,-32
    8000650c:	ec06                	sd	ra,24(sp)
    8000650e:	e822                	sd	s0,16(sp)
    80006510:	e426                	sd	s1,8(sp)
    80006512:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80006514:	6904                	ld	s1,16(a0)
    80006516:	ffffb097          	auipc	ra,0xffffb
    8000651a:	930080e7          	jalr	-1744(ra) # 80000e46 <mycpu>
    8000651e:	40a48533          	sub	a0,s1,a0
    80006522:	00153513          	seqz	a0,a0
}
    80006526:	60e2                	ld	ra,24(sp)
    80006528:	6442                	ld	s0,16(sp)
    8000652a:	64a2                	ld	s1,8(sp)
    8000652c:	6105                	addi	sp,sp,32
    8000652e:	8082                	ret

0000000080006530 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80006530:	1101                	addi	sp,sp,-32
    80006532:	ec06                	sd	ra,24(sp)
    80006534:	e822                	sd	s0,16(sp)
    80006536:	e426                	sd	s1,8(sp)
    80006538:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000653a:	100024f3          	csrr	s1,sstatus
    8000653e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80006542:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006544:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80006548:	ffffb097          	auipc	ra,0xffffb
    8000654c:	8fe080e7          	jalr	-1794(ra) # 80000e46 <mycpu>
    80006550:	5d3c                	lw	a5,120(a0)
    80006552:	cf89                	beqz	a5,8000656c <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80006554:	ffffb097          	auipc	ra,0xffffb
    80006558:	8f2080e7          	jalr	-1806(ra) # 80000e46 <mycpu>
    8000655c:	5d3c                	lw	a5,120(a0)
    8000655e:	2785                	addiw	a5,a5,1
    80006560:	dd3c                	sw	a5,120(a0)
}
    80006562:	60e2                	ld	ra,24(sp)
    80006564:	6442                	ld	s0,16(sp)
    80006566:	64a2                	ld	s1,8(sp)
    80006568:	6105                	addi	sp,sp,32
    8000656a:	8082                	ret
    mycpu()->intena = old;
    8000656c:	ffffb097          	auipc	ra,0xffffb
    80006570:	8da080e7          	jalr	-1830(ra) # 80000e46 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80006574:	8085                	srli	s1,s1,0x1
    80006576:	8885                	andi	s1,s1,1
    80006578:	dd64                	sw	s1,124(a0)
    8000657a:	bfe9                	j	80006554 <push_off+0x24>

000000008000657c <acquire>:
{
    8000657c:	1101                	addi	sp,sp,-32
    8000657e:	ec06                	sd	ra,24(sp)
    80006580:	e822                	sd	s0,16(sp)
    80006582:	e426                	sd	s1,8(sp)
    80006584:	1000                	addi	s0,sp,32
    80006586:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80006588:	00000097          	auipc	ra,0x0
    8000658c:	fa8080e7          	jalr	-88(ra) # 80006530 <push_off>
  if(holding(lk))
    80006590:	8526                	mv	a0,s1
    80006592:	00000097          	auipc	ra,0x0
    80006596:	f70080e7          	jalr	-144(ra) # 80006502 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000659a:	4705                	li	a4,1
  if(holding(lk))
    8000659c:	e115                	bnez	a0,800065c0 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000659e:	87ba                	mv	a5,a4
    800065a0:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800065a4:	2781                	sext.w	a5,a5
    800065a6:	ffe5                	bnez	a5,8000659e <acquire+0x22>
  __sync_synchronize();
    800065a8:	0ff0000f          	fence
  lk->cpu = mycpu();
    800065ac:	ffffb097          	auipc	ra,0xffffb
    800065b0:	89a080e7          	jalr	-1894(ra) # 80000e46 <mycpu>
    800065b4:	e888                	sd	a0,16(s1)
}
    800065b6:	60e2                	ld	ra,24(sp)
    800065b8:	6442                	ld	s0,16(sp)
    800065ba:	64a2                	ld	s1,8(sp)
    800065bc:	6105                	addi	sp,sp,32
    800065be:	8082                	ret
    panic("acquire");
    800065c0:	00002517          	auipc	a0,0x2
    800065c4:	46850513          	addi	a0,a0,1128 # 80008a28 <digits+0x20>
    800065c8:	00000097          	auipc	ra,0x0
    800065cc:	a6a080e7          	jalr	-1430(ra) # 80006032 <panic>

00000000800065d0 <pop_off>:

void
pop_off(void)
{
    800065d0:	1141                	addi	sp,sp,-16
    800065d2:	e406                	sd	ra,8(sp)
    800065d4:	e022                	sd	s0,0(sp)
    800065d6:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    800065d8:	ffffb097          	auipc	ra,0xffffb
    800065dc:	86e080e7          	jalr	-1938(ra) # 80000e46 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800065e0:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    800065e4:	8b89                	andi	a5,a5,2
  if(intr_get())
    800065e6:	e78d                	bnez	a5,80006610 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    800065e8:	5d3c                	lw	a5,120(a0)
    800065ea:	02f05b63          	blez	a5,80006620 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    800065ee:	37fd                	addiw	a5,a5,-1
    800065f0:	0007871b          	sext.w	a4,a5
    800065f4:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    800065f6:	eb09                	bnez	a4,80006608 <pop_off+0x38>
    800065f8:	5d7c                	lw	a5,124(a0)
    800065fa:	c799                	beqz	a5,80006608 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800065fc:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006600:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006604:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80006608:	60a2                	ld	ra,8(sp)
    8000660a:	6402                	ld	s0,0(sp)
    8000660c:	0141                	addi	sp,sp,16
    8000660e:	8082                	ret
    panic("pop_off - interruptible");
    80006610:	00002517          	auipc	a0,0x2
    80006614:	42050513          	addi	a0,a0,1056 # 80008a30 <digits+0x28>
    80006618:	00000097          	auipc	ra,0x0
    8000661c:	a1a080e7          	jalr	-1510(ra) # 80006032 <panic>
    panic("pop_off");
    80006620:	00002517          	auipc	a0,0x2
    80006624:	42850513          	addi	a0,a0,1064 # 80008a48 <digits+0x40>
    80006628:	00000097          	auipc	ra,0x0
    8000662c:	a0a080e7          	jalr	-1526(ra) # 80006032 <panic>

0000000080006630 <release>:
{
    80006630:	1101                	addi	sp,sp,-32
    80006632:	ec06                	sd	ra,24(sp)
    80006634:	e822                	sd	s0,16(sp)
    80006636:	e426                	sd	s1,8(sp)
    80006638:	1000                	addi	s0,sp,32
    8000663a:	84aa                	mv	s1,a0
  if(!holding(lk))
    8000663c:	00000097          	auipc	ra,0x0
    80006640:	ec6080e7          	jalr	-314(ra) # 80006502 <holding>
    80006644:	c115                	beqz	a0,80006668 <release+0x38>
  lk->cpu = 0;
    80006646:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    8000664a:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    8000664e:	0f50000f          	fence	iorw,ow
    80006652:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80006656:	00000097          	auipc	ra,0x0
    8000665a:	f7a080e7          	jalr	-134(ra) # 800065d0 <pop_off>
}
    8000665e:	60e2                	ld	ra,24(sp)
    80006660:	6442                	ld	s0,16(sp)
    80006662:	64a2                	ld	s1,8(sp)
    80006664:	6105                	addi	sp,sp,32
    80006666:	8082                	ret
    panic("release");
    80006668:	00002517          	auipc	a0,0x2
    8000666c:	3e850513          	addi	a0,a0,1000 # 80008a50 <digits+0x48>
    80006670:	00000097          	auipc	ra,0x0
    80006674:	9c2080e7          	jalr	-1598(ra) # 80006032 <panic>
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
