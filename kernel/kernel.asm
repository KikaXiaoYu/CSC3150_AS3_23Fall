
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	92013103          	ld	sp,-1760(sp) # 80008920 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	1d7050ef          	jal	ra,800059ec <start>

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
    80000030:	00030797          	auipc	a5,0x30
    80000034:	db078793          	addi	a5,a5,-592 # 8002fde0 <end>
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
    80000054:	92090913          	addi	s2,s2,-1760 # 80008970 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	392080e7          	jalr	914(ra) # 800063ec <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	432080e7          	jalr	1074(ra) # 800064a0 <release>
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
    8000008e:	e18080e7          	jalr	-488(ra) # 80005ea2 <panic>

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
    800000f0:	88450513          	addi	a0,a0,-1916 # 80008970 <kmem>
    800000f4:	00006097          	auipc	ra,0x6
    800000f8:	268080e7          	jalr	616(ra) # 8000635c <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fc:	45c5                	li	a1,17
    800000fe:	05ee                	slli	a1,a1,0x1b
    80000100:	00030517          	auipc	a0,0x30
    80000104:	ce050513          	addi	a0,a0,-800 # 8002fde0 <end>
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
    80000126:	84e48493          	addi	s1,s1,-1970 # 80008970 <kmem>
    8000012a:	8526                	mv	a0,s1
    8000012c:	00006097          	auipc	ra,0x6
    80000130:	2c0080e7          	jalr	704(ra) # 800063ec <acquire>
  r = kmem.freelist;
    80000134:	6c84                	ld	s1,24(s1)
  if(r)
    80000136:	c885                	beqz	s1,80000166 <kalloc+0x4e>
    kmem.freelist = r->next;
    80000138:	609c                	ld	a5,0(s1)
    8000013a:	00009517          	auipc	a0,0x9
    8000013e:	83650513          	addi	a0,a0,-1994 # 80008970 <kmem>
    80000142:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000144:	00006097          	auipc	ra,0x6
    80000148:	35c080e7          	jalr	860(ra) # 800064a0 <release>

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
    8000016a:	80a50513          	addi	a0,a0,-2038 # 80008970 <kmem>
    8000016e:	00006097          	auipc	ra,0x6
    80000172:	332080e7          	jalr	818(ra) # 800064a0 <release>
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
    8000033a:	60a70713          	addi	a4,a4,1546 # 80008940 <started>
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
    80000360:	b90080e7          	jalr	-1136(ra) # 80005eec <printf>
    kvminithart();    // turn on paging
    80000364:	00000097          	auipc	ra,0x0
    80000368:	0d8080e7          	jalr	216(ra) # 8000043c <kvminithart>
    trapinithart();   // install kernel trap vector
    8000036c:	00001097          	auipc	ra,0x1
    80000370:	78e080e7          	jalr	1934(ra) # 80001afa <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000374:	00005097          	auipc	ra,0x5
    80000378:	fcc080e7          	jalr	-52(ra) # 80005340 <plicinithart>
  }

  scheduler();        
    8000037c:	00001097          	auipc	ra,0x1
    80000380:	fd8080e7          	jalr	-40(ra) # 80001354 <scheduler>
    consoleinit();
    80000384:	00006097          	auipc	ra,0x6
    80000388:	a30080e7          	jalr	-1488(ra) # 80005db4 <consoleinit>
    printfinit();
    8000038c:	00006097          	auipc	ra,0x6
    80000390:	d46080e7          	jalr	-698(ra) # 800060d2 <printfinit>
    printf("\n");
    80000394:	00008517          	auipc	a0,0x8
    80000398:	cb450513          	addi	a0,a0,-844 # 80008048 <etext+0x48>
    8000039c:	00006097          	auipc	ra,0x6
    800003a0:	b50080e7          	jalr	-1200(ra) # 80005eec <printf>
    printf("xv6 kernel is booting\n");
    800003a4:	00008517          	auipc	a0,0x8
    800003a8:	c7c50513          	addi	a0,a0,-900 # 80008020 <etext+0x20>
    800003ac:	00006097          	auipc	ra,0x6
    800003b0:	b40080e7          	jalr	-1216(ra) # 80005eec <printf>
    printf("\n");
    800003b4:	00008517          	auipc	a0,0x8
    800003b8:	c9450513          	addi	a0,a0,-876 # 80008048 <etext+0x48>
    800003bc:	00006097          	auipc	ra,0x6
    800003c0:	b30080e7          	jalr	-1232(ra) # 80005eec <printf>
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
    800003f8:	f36080e7          	jalr	-202(ra) # 8000532a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003fc:	00005097          	auipc	ra,0x5
    80000400:	f44080e7          	jalr	-188(ra) # 80005340 <plicinithart>
    binit();         // buffer cache
    80000404:	00002097          	auipc	ra,0x2
    80000408:	f60080e7          	jalr	-160(ra) # 80002364 <binit>
    iinit();         // inode table
    8000040c:	00002097          	auipc	ra,0x2
    80000410:	604080e7          	jalr	1540(ra) # 80002a10 <iinit>
    fileinit();      // file table
    80000414:	00003097          	auipc	ra,0x3
    80000418:	5a2080e7          	jalr	1442(ra) # 800039b6 <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000041c:	00005097          	auipc	ra,0x5
    80000420:	02c080e7          	jalr	44(ra) # 80005448 <virtio_disk_init>
    userinit();      // first user process
    80000424:	00001097          	auipc	ra,0x1
    80000428:	d16080e7          	jalr	-746(ra) # 8000113a <userinit>
    __sync_synchronize();
    8000042c:	0ff0000f          	fence
    started = 1;
    80000430:	4785                	li	a5,1
    80000432:	00008717          	auipc	a4,0x8
    80000436:	50f72723          	sw	a5,1294(a4) # 80008940 <started>
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
    8000044a:	5027b783          	ld	a5,1282(a5) # 80008948 <kernel_pagetable>
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
    80000496:	a10080e7          	jalr	-1520(ra) # 80005ea2 <panic>
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
            panic("mappages: remap");
        }
        *pte = PA2PTE(pa) | perm | PTE_V;
        if (a == last)
            break;
        a += PGSIZE;
    8000057e:	6b85                	lui	s7,0x1
    80000580:	a0a1                	j	800005c8 <mappages+0x7c>
        panic("mappages: size");
    80000582:	00008517          	auipc	a0,0x8
    80000586:	ad650513          	addi	a0,a0,-1322 # 80008058 <etext+0x58>
    8000058a:	00006097          	auipc	ra,0x6
    8000058e:	918080e7          	jalr	-1768(ra) # 80005ea2 <panic>
            printf("[Testing] : pte: %d\n", pte);
    80000592:	85aa                	mv	a1,a0
    80000594:	00008517          	auipc	a0,0x8
    80000598:	ad450513          	addi	a0,a0,-1324 # 80008068 <etext+0x68>
    8000059c:	00006097          	auipc	ra,0x6
    800005a0:	950080e7          	jalr	-1712(ra) # 80005eec <printf>
            printf("[Testing] : PTE_V: %d\n", PTE_V);
    800005a4:	4585                	li	a1,1
    800005a6:	00008517          	auipc	a0,0x8
    800005aa:	ada50513          	addi	a0,a0,-1318 # 80008080 <etext+0x80>
    800005ae:	00006097          	auipc	ra,0x6
    800005b2:	93e080e7          	jalr	-1730(ra) # 80005eec <printf>
            panic("mappages: remap");
    800005b6:	00008517          	auipc	a0,0x8
    800005ba:	ae250513          	addi	a0,a0,-1310 # 80008098 <etext+0x98>
    800005be:	00006097          	auipc	ra,0x6
    800005c2:	8e4080e7          	jalr	-1820(ra) # 80005ea2 <panic>
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
    8000063c:	86a080e7          	jalr	-1942(ra) # 80005ea2 <panic>

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
    8000072a:	22a7b123          	sd	a0,546(a5) # 80008948 <kernel_pagetable>
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
    80000784:	00005097          	auipc	ra,0x5
    80000788:	71e080e7          	jalr	1822(ra) # 80005ea2 <panic>
            panic("uvmunmap: walk");
    8000078c:	00008517          	auipc	a0,0x8
    80000790:	93c50513          	addi	a0,a0,-1732 # 800080c8 <etext+0xc8>
    80000794:	00005097          	auipc	ra,0x5
    80000798:	70e080e7          	jalr	1806(ra) # 80005ea2 <panic>
            panic("uvmunmap: not a leaf");
    8000079c:	00008517          	auipc	a0,0x8
    800007a0:	93c50513          	addi	a0,a0,-1732 # 800080d8 <etext+0xd8>
    800007a4:	00005097          	auipc	ra,0x5
    800007a8:	6fe080e7          	jalr	1790(ra) # 80005ea2 <panic>
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
    80000888:	61e080e7          	jalr	1566(ra) # 80005ea2 <panic>

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
    800009d2:	4d4080e7          	jalr	1236(ra) # 80005ea2 <panic>
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
    80000a56:	450080e7          	jalr	1104(ra) # 80005ea2 <panic>
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
    80000b1c:	38a080e7          	jalr	906(ra) # 80005ea2 <panic>

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
    80000d06:	0be48493          	addi	s1,s1,190 # 80008dc0 <proc>
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
    80000d1c:	0001ca17          	auipc	s4,0x1c
    80000d20:	aa4a0a13          	addi	s4,s4,-1372 # 8001c7c0 <tickslock>
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
    80000d56:	4e848493          	addi	s1,s1,1256
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
    80000d7e:	128080e7          	jalr	296(ra) # 80005ea2 <panic>

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
    80000da2:	bf250513          	addi	a0,a0,-1038 # 80008990 <pid_lock>
    80000da6:	00005097          	auipc	ra,0x5
    80000daa:	5b6080e7          	jalr	1462(ra) # 8000635c <initlock>
    initlock(&wait_lock, "wait_lock");
    80000dae:	00007597          	auipc	a1,0x7
    80000db2:	3b258593          	addi	a1,a1,946 # 80008160 <etext+0x160>
    80000db6:	00008517          	auipc	a0,0x8
    80000dba:	bf250513          	addi	a0,a0,-1038 # 800089a8 <wait_lock>
    80000dbe:	00005097          	auipc	ra,0x5
    80000dc2:	59e080e7          	jalr	1438(ra) # 8000635c <initlock>
    for (p = proc; p < &proc[NPROC]; p++)
    80000dc6:	00008497          	auipc	s1,0x8
    80000dca:	ffa48493          	addi	s1,s1,-6 # 80008dc0 <proc>
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
    80000de8:	0001c997          	auipc	s3,0x1c
    80000dec:	9d898993          	addi	s3,s3,-1576 # 8001c7c0 <tickslock>
        initlock(&p->lock, "proc");
    80000df0:	85da                	mv	a1,s6
    80000df2:	8526                	mv	a0,s1
    80000df4:	00005097          	auipc	ra,0x5
    80000df8:	568080e7          	jalr	1384(ra) # 8000635c <initlock>
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
    80000e1a:	4e848493          	addi	s1,s1,1256
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
    80000e56:	b6e50513          	addi	a0,a0,-1170 # 800089c0 <cpus>
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
    80000e70:	534080e7          	jalr	1332(ra) # 800063a0 <push_off>
    80000e74:	8792                	mv	a5,tp
    struct cpu *c = mycpu();
    struct proc *p = c->proc;
    80000e76:	2781                	sext.w	a5,a5
    80000e78:	079e                	slli	a5,a5,0x7
    80000e7a:	00008717          	auipc	a4,0x8
    80000e7e:	b1670713          	addi	a4,a4,-1258 # 80008990 <pid_lock>
    80000e82:	97ba                	add	a5,a5,a4
    80000e84:	7b84                	ld	s1,48(a5)
    pop_off();
    80000e86:	00005097          	auipc	ra,0x5
    80000e8a:	5ba080e7          	jalr	1466(ra) # 80006440 <pop_off>
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
    80000eae:	5f6080e7          	jalr	1526(ra) # 800064a0 <release>

    if (first)
    80000eb2:	00008797          	auipc	a5,0x8
    80000eb6:	a1e7a783          	lw	a5,-1506(a5) # 800088d0 <first.1694>
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
    80000ed0:	a007a223          	sw	zero,-1532(a5) # 800088d0 <first.1694>
        fsinit(ROOTDEV);
    80000ed4:	4505                	li	a0,1
    80000ed6:	00002097          	auipc	ra,0x2
    80000eda:	aba080e7          	jalr	-1350(ra) # 80002990 <fsinit>
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
    80000ef0:	aa490913          	addi	s2,s2,-1372 # 80008990 <pid_lock>
    80000ef4:	854a                	mv	a0,s2
    80000ef6:	00005097          	auipc	ra,0x5
    80000efa:	4f6080e7          	jalr	1270(ra) # 800063ec <acquire>
    pid = nextpid;
    80000efe:	00008797          	auipc	a5,0x8
    80000f02:	9d678793          	addi	a5,a5,-1578 # 800088d4 <nextpid>
    80000f06:	4384                	lw	s1,0(a5)
    nextpid = nextpid + 1;
    80000f08:	0014871b          	addiw	a4,s1,1
    80000f0c:	c398                	sw	a4,0(a5)
    release(&pid_lock);
    80000f0e:	854a                	mv	a0,s2
    80000f10:	00005097          	auipc	ra,0x5
    80000f14:	590080e7          	jalr	1424(ra) # 800064a0 <release>
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
    8000107c:	d4848493          	addi	s1,s1,-696 # 80008dc0 <proc>
    80001080:	0001b917          	auipc	s2,0x1b
    80001084:	74090913          	addi	s2,s2,1856 # 8001c7c0 <tickslock>
        acquire(&p->lock);
    80001088:	8526                	mv	a0,s1
    8000108a:	00005097          	auipc	ra,0x5
    8000108e:	362080e7          	jalr	866(ra) # 800063ec <acquire>
        if (p->state == UNUSED)
    80001092:	4c9c                	lw	a5,24(s1)
    80001094:	cf81                	beqz	a5,800010ac <allocproc+0x40>
            release(&p->lock);
    80001096:	8526                	mv	a0,s1
    80001098:	00005097          	auipc	ra,0x5
    8000109c:	408080e7          	jalr	1032(ra) # 800064a0 <release>
    for (p = proc; p < &proc[NPROC]; p++)
    800010a0:	4e848493          	addi	s1,s1,1256
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
    8000111a:	38a080e7          	jalr	906(ra) # 800064a0 <release>
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
    80001132:	372080e7          	jalr	882(ra) # 800064a0 <release>
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
    80001152:	80a7b123          	sd	a0,-2046(a5) # 80008950 <initproc>
    uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001156:	03400613          	li	a2,52
    8000115a:	00007597          	auipc	a1,0x7
    8000115e:	78658593          	addi	a1,a1,1926 # 800088e0 <initcode>
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
    8000119c:	21a080e7          	jalr	538(ra) # 800033b2 <namei>
    800011a0:	14a4b823          	sd	a0,336(s1)
    p->state = RUNNABLE;
    800011a4:	478d                	li	a5,3
    800011a6:	cc9c                	sw	a5,24(s1)
    release(&p->lock);
    800011a8:	8526                	mv	a0,s1
    800011aa:	00005097          	auipc	ra,0x5
    800011ae:	2f6080e7          	jalr	758(ra) # 800064a0 <release>
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
    800012ae:	1f6080e7          	jalr	502(ra) # 800064a0 <release>
        return -1;
    800012b2:	5a7d                	li	s4,-1
    800012b4:	a069                	j	8000133e <fork+0x126>
            np->ofile[i] = filedup(p->ofile[i]);
    800012b6:	00002097          	auipc	ra,0x2
    800012ba:	792080e7          	jalr	1938(ra) # 80003a48 <filedup>
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
    800012dc:	8f6080e7          	jalr	-1802(ra) # 80002bce <idup>
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
    80001300:	1a4080e7          	jalr	420(ra) # 800064a0 <release>
    acquire(&wait_lock);
    80001304:	00007497          	auipc	s1,0x7
    80001308:	6a448493          	addi	s1,s1,1700 # 800089a8 <wait_lock>
    8000130c:	8526                	mv	a0,s1
    8000130e:	00005097          	auipc	ra,0x5
    80001312:	0de080e7          	jalr	222(ra) # 800063ec <acquire>
    np->parent = p;
    80001316:	0329bc23          	sd	s2,56(s3)
    release(&wait_lock);
    8000131a:	8526                	mv	a0,s1
    8000131c:	00005097          	auipc	ra,0x5
    80001320:	184080e7          	jalr	388(ra) # 800064a0 <release>
    acquire(&np->lock);
    80001324:	854e                	mv	a0,s3
    80001326:	00005097          	auipc	ra,0x5
    8000132a:	0c6080e7          	jalr	198(ra) # 800063ec <acquire>
    np->state = RUNNABLE;
    8000132e:	478d                	li	a5,3
    80001330:	00f9ac23          	sw	a5,24(s3)
    release(&np->lock);
    80001334:	854e                	mv	a0,s3
    80001336:	00005097          	auipc	ra,0x5
    8000133a:	16a080e7          	jalr	362(ra) # 800064a0 <release>
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
    80001374:	62070713          	addi	a4,a4,1568 # 80008990 <pid_lock>
    80001378:	9756                	add	a4,a4,s5
    8000137a:	02073823          	sd	zero,48(a4)
                swtch(&c->context, &p->context);
    8000137e:	00007717          	auipc	a4,0x7
    80001382:	64a70713          	addi	a4,a4,1610 # 800089c8 <cpus+0x8>
    80001386:	9aba                	add	s5,s5,a4
            if (p->state == RUNNABLE)
    80001388:	498d                	li	s3,3
                p->state = RUNNING;
    8000138a:	4b11                	li	s6,4
                c->proc = p;
    8000138c:	079e                	slli	a5,a5,0x7
    8000138e:	00007a17          	auipc	s4,0x7
    80001392:	602a0a13          	addi	s4,s4,1538 # 80008990 <pid_lock>
    80001396:	9a3e                	add	s4,s4,a5
        for (p = proc; p < &proc[NPROC]; p++)
    80001398:	0001b917          	auipc	s2,0x1b
    8000139c:	42890913          	addi	s2,s2,1064 # 8001c7c0 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800013a0:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800013a4:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800013a8:	10079073          	csrw	sstatus,a5
    800013ac:	00008497          	auipc	s1,0x8
    800013b0:	a1448493          	addi	s1,s1,-1516 # 80008dc0 <proc>
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
    800013d6:	0ce080e7          	jalr	206(ra) # 800064a0 <release>
        for (p = proc; p < &proc[NPROC]; p++)
    800013da:	4e848493          	addi	s1,s1,1256
    800013de:	fd2481e3          	beq	s1,s2,800013a0 <scheduler+0x4c>
            acquire(&p->lock);
    800013e2:	8526                	mv	a0,s1
    800013e4:	00005097          	auipc	ra,0x5
    800013e8:	008080e7          	jalr	8(ra) # 800063ec <acquire>
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
    80001410:	f66080e7          	jalr	-154(ra) # 80006372 <holding>
    80001414:	c93d                	beqz	a0,8000148a <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001416:	8792                	mv	a5,tp
    if (mycpu()->noff != 1)
    80001418:	2781                	sext.w	a5,a5
    8000141a:	079e                	slli	a5,a5,0x7
    8000141c:	00007717          	auipc	a4,0x7
    80001420:	57470713          	addi	a4,a4,1396 # 80008990 <pid_lock>
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
    80001446:	54e90913          	addi	s2,s2,1358 # 80008990 <pid_lock>
    8000144a:	2781                	sext.w	a5,a5
    8000144c:	079e                	slli	a5,a5,0x7
    8000144e:	97ca                	add	a5,a5,s2
    80001450:	0ac7a983          	lw	s3,172(a5)
    80001454:	8792                	mv	a5,tp
    swtch(&p->context, &mycpu()->context);
    80001456:	2781                	sext.w	a5,a5
    80001458:	079e                	slli	a5,a5,0x7
    8000145a:	00007597          	auipc	a1,0x7
    8000145e:	56e58593          	addi	a1,a1,1390 # 800089c8 <cpus+0x8>
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
    80001496:	a10080e7          	jalr	-1520(ra) # 80005ea2 <panic>
        panic("sched locks");
    8000149a:	00007517          	auipc	a0,0x7
    8000149e:	d0650513          	addi	a0,a0,-762 # 800081a0 <etext+0x1a0>
    800014a2:	00005097          	auipc	ra,0x5
    800014a6:	a00080e7          	jalr	-1536(ra) # 80005ea2 <panic>
        panic("sched running");
    800014aa:	00007517          	auipc	a0,0x7
    800014ae:	d0650513          	addi	a0,a0,-762 # 800081b0 <etext+0x1b0>
    800014b2:	00005097          	auipc	ra,0x5
    800014b6:	9f0080e7          	jalr	-1552(ra) # 80005ea2 <panic>
        panic("sched interruptible");
    800014ba:	00007517          	auipc	a0,0x7
    800014be:	d0650513          	addi	a0,a0,-762 # 800081c0 <etext+0x1c0>
    800014c2:	00005097          	auipc	ra,0x5
    800014c6:	9e0080e7          	jalr	-1568(ra) # 80005ea2 <panic>

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
    800014e2:	f0e080e7          	jalr	-242(ra) # 800063ec <acquire>
    p->state = RUNNABLE;
    800014e6:	478d                	li	a5,3
    800014e8:	cc9c                	sw	a5,24(s1)
    sched();
    800014ea:	00000097          	auipc	ra,0x0
    800014ee:	f0a080e7          	jalr	-246(ra) # 800013f4 <sched>
    release(&p->lock);
    800014f2:	8526                	mv	a0,s1
    800014f4:	00005097          	auipc	ra,0x5
    800014f8:	fac080e7          	jalr	-84(ra) # 800064a0 <release>
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
    80001526:	eca080e7          	jalr	-310(ra) # 800063ec <acquire>
    release(lk);
    8000152a:	854a                	mv	a0,s2
    8000152c:	00005097          	auipc	ra,0x5
    80001530:	f74080e7          	jalr	-140(ra) # 800064a0 <release>

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
    8000154e:	f56080e7          	jalr	-170(ra) # 800064a0 <release>
    acquire(lk);
    80001552:	854a                	mv	a0,s2
    80001554:	00005097          	auipc	ra,0x5
    80001558:	e98080e7          	jalr	-360(ra) # 800063ec <acquire>
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
    80001582:	84248493          	addi	s1,s1,-1982 # 80008dc0 <proc>
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
    8000158a:	0001b917          	auipc	s2,0x1b
    8000158e:	23690913          	addi	s2,s2,566 # 8001c7c0 <tickslock>
    80001592:	a821                	j	800015aa <wakeup+0x40>
                p->state = RUNNABLE;
    80001594:	0154ac23          	sw	s5,24(s1)
            }
            release(&p->lock);
    80001598:	8526                	mv	a0,s1
    8000159a:	00005097          	auipc	ra,0x5
    8000159e:	f06080e7          	jalr	-250(ra) # 800064a0 <release>
    for (p = proc; p < &proc[NPROC]; p++)
    800015a2:	4e848493          	addi	s1,s1,1256
    800015a6:	03248463          	beq	s1,s2,800015ce <wakeup+0x64>
        if (p != myproc())
    800015aa:	00000097          	auipc	ra,0x0
    800015ae:	8b8080e7          	jalr	-1864(ra) # 80000e62 <myproc>
    800015b2:	fea488e3          	beq	s1,a0,800015a2 <wakeup+0x38>
            acquire(&p->lock);
    800015b6:	8526                	mv	a0,s1
    800015b8:	00005097          	auipc	ra,0x5
    800015bc:	e34080e7          	jalr	-460(ra) # 800063ec <acquire>
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
    800015f2:	00007497          	auipc	s1,0x7
    800015f6:	7ce48493          	addi	s1,s1,1998 # 80008dc0 <proc>
            pp->parent = initproc;
    800015fa:	00007a17          	auipc	s4,0x7
    800015fe:	356a0a13          	addi	s4,s4,854 # 80008950 <initproc>
    for (pp = proc; pp < &proc[NPROC]; pp++)
    80001602:	0001b997          	auipc	s3,0x1b
    80001606:	1be98993          	addi	s3,s3,446 # 8001c7c0 <tickslock>
    8000160a:	a029                	j	80001614 <reparent+0x34>
    8000160c:	4e848493          	addi	s1,s1,1256
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
    8000165a:	2fa7b783          	ld	a5,762(a5) # 80008950 <initproc>
    8000165e:	0d050493          	addi	s1,a0,208
    80001662:	15050913          	addi	s2,a0,336
    80001666:	02a79363          	bne	a5,a0,8000168c <exit+0x52>
        panic("init exiting");
    8000166a:	00007517          	auipc	a0,0x7
    8000166e:	b6e50513          	addi	a0,a0,-1170 # 800081d8 <etext+0x1d8>
    80001672:	00005097          	auipc	ra,0x5
    80001676:	830080e7          	jalr	-2000(ra) # 80005ea2 <panic>
            fileclose(f);
    8000167a:	00002097          	auipc	ra,0x2
    8000167e:	420080e7          	jalr	1056(ra) # 80003a9a <fileclose>
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
    80001696:	f3c080e7          	jalr	-196(ra) # 800035ce <begin_op>
    iput(p->cwd);
    8000169a:	1509b503          	ld	a0,336(s3)
    8000169e:	00001097          	auipc	ra,0x1
    800016a2:	728080e7          	jalr	1832(ra) # 80002dc6 <iput>
    end_op();
    800016a6:	00002097          	auipc	ra,0x2
    800016aa:	fa8080e7          	jalr	-88(ra) # 8000364e <end_op>
    p->cwd = 0;
    800016ae:	1409b823          	sd	zero,336(s3)
    acquire(&wait_lock);
    800016b2:	00007497          	auipc	s1,0x7
    800016b6:	2f648493          	addi	s1,s1,758 # 800089a8 <wait_lock>
    800016ba:	8526                	mv	a0,s1
    800016bc:	00005097          	auipc	ra,0x5
    800016c0:	d30080e7          	jalr	-720(ra) # 800063ec <acquire>
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
    800016e0:	d10080e7          	jalr	-752(ra) # 800063ec <acquire>
    p->xstate = status;
    800016e4:	0349a623          	sw	s4,44(s3)
    p->state = ZOMBIE;
    800016e8:	4795                	li	a5,5
    800016ea:	00f9ac23          	sw	a5,24(s3)
    release(&wait_lock);
    800016ee:	8526                	mv	a0,s1
    800016f0:	00005097          	auipc	ra,0x5
    800016f4:	db0080e7          	jalr	-592(ra) # 800064a0 <release>
    sched();
    800016f8:	00000097          	auipc	ra,0x0
    800016fc:	cfc080e7          	jalr	-772(ra) # 800013f4 <sched>
    panic("zombie exit");
    80001700:	00007517          	auipc	a0,0x7
    80001704:	ae850513          	addi	a0,a0,-1304 # 800081e8 <etext+0x1e8>
    80001708:	00004097          	auipc	ra,0x4
    8000170c:	79a080e7          	jalr	1946(ra) # 80005ea2 <panic>

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
    80001720:	00007497          	auipc	s1,0x7
    80001724:	6a048493          	addi	s1,s1,1696 # 80008dc0 <proc>
    80001728:	0001b997          	auipc	s3,0x1b
    8000172c:	09898993          	addi	s3,s3,152 # 8001c7c0 <tickslock>
    {
        acquire(&p->lock);
    80001730:	8526                	mv	a0,s1
    80001732:	00005097          	auipc	ra,0x5
    80001736:	cba080e7          	jalr	-838(ra) # 800063ec <acquire>
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
    80001746:	d5e080e7          	jalr	-674(ra) # 800064a0 <release>
    for (p = proc; p < &proc[NPROC]; p++)
    8000174a:	4e848493          	addi	s1,s1,1256
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
    80001768:	d3c080e7          	jalr	-708(ra) # 800064a0 <release>
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
    80001792:	c5e080e7          	jalr	-930(ra) # 800063ec <acquire>
    p->killed = 1;
    80001796:	4785                	li	a5,1
    80001798:	d49c                	sw	a5,40(s1)
    release(&p->lock);
    8000179a:	8526                	mv	a0,s1
    8000179c:	00005097          	auipc	ra,0x5
    800017a0:	d04080e7          	jalr	-764(ra) # 800064a0 <release>
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
    800017c0:	c30080e7          	jalr	-976(ra) # 800063ec <acquire>
    k = p->killed;
    800017c4:	0284a903          	lw	s2,40(s1)
    release(&p->lock);
    800017c8:	8526                	mv	a0,s1
    800017ca:	00005097          	auipc	ra,0x5
    800017ce:	cd6080e7          	jalr	-810(ra) # 800064a0 <release>
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
    80001808:	1a450513          	addi	a0,a0,420 # 800089a8 <wait_lock>
    8000180c:	00005097          	auipc	ra,0x5
    80001810:	be0080e7          	jalr	-1056(ra) # 800063ec <acquire>
        havekids = 0;
    80001814:	4b81                	li	s7,0
                if (pp->state == ZOMBIE)
    80001816:	4a15                	li	s4,5
        for (pp = proc; pp < &proc[NPROC]; pp++)
    80001818:	0001b997          	auipc	s3,0x1b
    8000181c:	fa898993          	addi	s3,s3,-88 # 8001c7c0 <tickslock>
                havekids = 1;
    80001820:	4a85                	li	s5,1
        sleep(p, &wait_lock); // DOC: wait-sleep
    80001822:	00007c17          	auipc	s8,0x7
    80001826:	186c0c13          	addi	s8,s8,390 # 800089a8 <wait_lock>
        havekids = 0;
    8000182a:	875e                	mv	a4,s7
        for (pp = proc; pp < &proc[NPROC]; pp++)
    8000182c:	00007497          	auipc	s1,0x7
    80001830:	59448493          	addi	s1,s1,1428 # 80008dc0 <proc>
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
    80001866:	c3e080e7          	jalr	-962(ra) # 800064a0 <release>
                    release(&wait_lock);
    8000186a:	00007517          	auipc	a0,0x7
    8000186e:	13e50513          	addi	a0,a0,318 # 800089a8 <wait_lock>
    80001872:	00005097          	auipc	ra,0x5
    80001876:	c2e080e7          	jalr	-978(ra) # 800064a0 <release>
                    return pid;
    8000187a:	a0b5                	j	800018e6 <wait+0x106>
                        release(&pp->lock);
    8000187c:	8526                	mv	a0,s1
    8000187e:	00005097          	auipc	ra,0x5
    80001882:	c22080e7          	jalr	-990(ra) # 800064a0 <release>
                        release(&wait_lock);
    80001886:	00007517          	auipc	a0,0x7
    8000188a:	12250513          	addi	a0,a0,290 # 800089a8 <wait_lock>
    8000188e:	00005097          	auipc	ra,0x5
    80001892:	c12080e7          	jalr	-1006(ra) # 800064a0 <release>
                        return -1;
    80001896:	59fd                	li	s3,-1
    80001898:	a0b9                	j	800018e6 <wait+0x106>
        for (pp = proc; pp < &proc[NPROC]; pp++)
    8000189a:	4e848493          	addi	s1,s1,1256
    8000189e:	03348463          	beq	s1,s3,800018c6 <wait+0xe6>
            if (pp->parent == p)
    800018a2:	7c9c                	ld	a5,56(s1)
    800018a4:	ff279be3          	bne	a5,s2,8000189a <wait+0xba>
                acquire(&pp->lock);
    800018a8:	8526                	mv	a0,s1
    800018aa:	00005097          	auipc	ra,0x5
    800018ae:	b42080e7          	jalr	-1214(ra) # 800063ec <acquire>
                if (pp->state == ZOMBIE)
    800018b2:	4c9c                	lw	a5,24(s1)
    800018b4:	f94781e3          	beq	a5,s4,80001836 <wait+0x56>
                release(&pp->lock);
    800018b8:	8526                	mv	a0,s1
    800018ba:	00005097          	auipc	ra,0x5
    800018be:	be6080e7          	jalr	-1050(ra) # 800064a0 <release>
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
    800018d8:	0d450513          	addi	a0,a0,212 # 800089a8 <wait_lock>
    800018dc:	00005097          	auipc	ra,0x5
    800018e0:	bc4080e7          	jalr	-1084(ra) # 800064a0 <release>
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
    800019dc:	514080e7          	jalr	1300(ra) # 80005eec <printf>
    for (p = proc; p < &proc[NPROC]; p++)
    800019e0:	00007497          	auipc	s1,0x7
    800019e4:	53848493          	addi	s1,s1,1336 # 80008f18 <proc+0x158>
    800019e8:	0001b917          	auipc	s2,0x1b
    800019ec:	f3090913          	addi	s2,s2,-208 # 8001c918 <bcache+0x140>
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
    80001a1e:	4d2080e7          	jalr	1234(ra) # 80005eec <printf>
        printf("\n");
    80001a22:	8552                	mv	a0,s4
    80001a24:	00004097          	auipc	ra,0x4
    80001a28:	4c8080e7          	jalr	1224(ra) # 80005eec <printf>
    for (p = proc; p < &proc[NPROC]; p++)
    80001a2c:	4e848493          	addi	s1,s1,1256
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
    80001ae2:	0001b517          	auipc	a0,0x1b
    80001ae6:	cde50513          	addi	a0,a0,-802 # 8001c7c0 <tickslock>
    80001aea:	00005097          	auipc	ra,0x5
    80001aee:	872080e7          	jalr	-1934(ra) # 8000635c <initlock>
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
    80001b00:	00003797          	auipc	a5,0x3
    80001b04:	77078793          	addi	a5,a5,1904 # 80005270 <kernelvec>
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
    80001bb2:	0001b497          	auipc	s1,0x1b
    80001bb6:	c0e48493          	addi	s1,s1,-1010 # 8001c7c0 <tickslock>
    80001bba:	8526                	mv	a0,s1
    80001bbc:	00005097          	auipc	ra,0x5
    80001bc0:	830080e7          	jalr	-2000(ra) # 800063ec <acquire>
    ticks++;
    80001bc4:	00007517          	auipc	a0,0x7
    80001bc8:	d9450513          	addi	a0,a0,-620 # 80008958 <ticks>
    80001bcc:	411c                	lw	a5,0(a0)
    80001bce:	2785                	addiw	a5,a5,1
    80001bd0:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    80001bd2:	00000097          	auipc	ra,0x0
    80001bd6:	998080e7          	jalr	-1640(ra) # 8000156a <wakeup>
    release(&tickslock);
    80001bda:	8526                	mv	a0,s1
    80001bdc:	00005097          	auipc	ra,0x5
    80001be0:	8c4080e7          	jalr	-1852(ra) # 800064a0 <release>
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
    80001c20:	00003097          	auipc	ra,0x3
    80001c24:	758080e7          	jalr	1880(ra) # 80005378 <plic_claim>
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
    80001c48:	2a8080e7          	jalr	680(ra) # 80005eec <printf>
            plic_complete(irq);
    80001c4c:	8526                	mv	a0,s1
    80001c4e:	00003097          	auipc	ra,0x3
    80001c52:	74e080e7          	jalr	1870(ra) # 8000539c <plic_complete>
        return 1;
    80001c56:	4505                	li	a0,1
    80001c58:	bf55                	j	80001c0c <devintr+0x1e>
            uartintr();
    80001c5a:	00004097          	auipc	ra,0x4
    80001c5e:	6b2080e7          	jalr	1714(ra) # 8000630c <uartintr>
    80001c62:	b7ed                	j	80001c4c <devintr+0x5e>
            virtio_disk_intr();
    80001c64:	00004097          	auipc	ra,0x4
    80001c68:	c62080e7          	jalr	-926(ra) # 800058c6 <virtio_disk_intr>
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
    80001cb2:	5c278793          	addi	a5,a5,1474 # 80005270 <kernelvec>
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
    80001ce0:	1a051b63          	bnez	a0,80001e96 <usertrap+0x206>
    80001ce4:	14202773          	csrr	a4,scause
    else if (r_scause() == 13 || r_scause() == 15)
    80001ce8:	47b5                	li	a5,13
    80001cea:	0af70c63          	beq	a4,a5,80001da2 <usertrap+0x112>
    80001cee:	14202773          	csrr	a4,scause
    80001cf2:	47bd                	li	a5,15
    80001cf4:	0af70763          	beq	a4,a5,80001da2 <usertrap+0x112>
    80001cf8:	142025f3          	csrr	a1,scause
        printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001cfc:	03092603          	lw	a2,48(s2)
    80001d00:	00006517          	auipc	a0,0x6
    80001d04:	62050513          	addi	a0,a0,1568 # 80008320 <states.1738+0xe0>
    80001d08:	00004097          	auipc	ra,0x4
    80001d0c:	1e4080e7          	jalr	484(ra) # 80005eec <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d10:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001d14:	14302673          	csrr	a2,stval
        printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001d18:	00006517          	auipc	a0,0x6
    80001d1c:	63850513          	addi	a0,a0,1592 # 80008350 <states.1738+0x110>
    80001d20:	00004097          	auipc	ra,0x4
    80001d24:	1cc080e7          	jalr	460(ra) # 80005eec <printf>
        setkilled(p);
    80001d28:	854a                	mv	a0,s2
    80001d2a:	00000097          	auipc	ra,0x0
    80001d2e:	a58080e7          	jalr	-1448(ra) # 80001782 <setkilled>
    80001d32:	a82d                	j	80001d6c <usertrap+0xdc>
        panic("usertrap: not from user mode");
    80001d34:	00006517          	auipc	a0,0x6
    80001d38:	56450513          	addi	a0,a0,1380 # 80008298 <states.1738+0x58>
    80001d3c:	00004097          	auipc	ra,0x4
    80001d40:	166080e7          	jalr	358(ra) # 80005ea2 <panic>
        if (killed(p))
    80001d44:	00000097          	auipc	ra,0x0
    80001d48:	a6a080e7          	jalr	-1430(ra) # 800017ae <killed>
    80001d4c:	e529                	bnez	a0,80001d96 <usertrap+0x106>
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
    80001d68:	3a6080e7          	jalr	934(ra) # 8000210a <syscall>
    if (killed(p))
    80001d6c:	854a                	mv	a0,s2
    80001d6e:	00000097          	auipc	ra,0x0
    80001d72:	a40080e7          	jalr	-1472(ra) # 800017ae <killed>
    80001d76:	12051763          	bnez	a0,80001ea4 <usertrap+0x214>
    usertrapret();
    80001d7a:	00000097          	auipc	ra,0x0
    80001d7e:	d98080e7          	jalr	-616(ra) # 80001b12 <usertrapret>
}
    80001d82:	70e2                	ld	ra,56(sp)
    80001d84:	7442                	ld	s0,48(sp)
    80001d86:	74a2                	ld	s1,40(sp)
    80001d88:	7902                	ld	s2,32(sp)
    80001d8a:	69e2                	ld	s3,24(sp)
    80001d8c:	6a42                	ld	s4,16(sp)
    80001d8e:	6aa2                	ld	s5,8(sp)
    80001d90:	6b02                	ld	s6,0(sp)
    80001d92:	6121                	addi	sp,sp,64
    80001d94:	8082                	ret
            exit(-1);
    80001d96:	557d                	li	a0,-1
    80001d98:	00000097          	auipc	ra,0x0
    80001d9c:	8a2080e7          	jalr	-1886(ra) # 8000163a <exit>
    80001da0:	b77d                	j	80001d4e <usertrap+0xbe>
        struct proc *p_proc = myproc();
    80001da2:	fffff097          	auipc	ra,0xfffff
    80001da6:	0c0080e7          	jalr	192(ra) # 80000e62 <myproc>
    80001daa:	8a2a                	mv	s4,a0
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001dac:	143029f3          	csrr	s3,stval
        uint64 va = PGROUNDDOWN(r_stval()); // get the address causing the exception
    80001db0:	77fd                	lui	a5,0xfffff
    80001db2:	00f9f9b3          	and	s3,s3,a5
        printf("[Testing] : va: %d\n", va);
    80001db6:	85ce                	mv	a1,s3
    80001db8:	00006517          	auipc	a0,0x6
    80001dbc:	50050513          	addi	a0,a0,1280 # 800082b8 <states.1738+0x78>
    80001dc0:	00004097          	auipc	ra,0x4
    80001dc4:	12c080e7          	jalr	300(ra) # 80005eec <printf>
        for (int i = 0; i <= VMASIZE - 1; i++)
    80001dc8:	168a0793          	addi	a5,s4,360
            if (p_proc->vma[i].occupied == 1)
    80001dcc:	4605                	li	a2,1
        for (int i = 0; i <= VMASIZE - 1; i++)
    80001dce:	45c1                	li	a1,16
    80001dd0:	a031                	j	80001ddc <usertrap+0x14c>
    80001dd2:	2485                	addiw	s1,s1,1
    80001dd4:	03878793          	addi	a5,a5,56 # fffffffffffff038 <end+0xffffffff7ffcf258>
    80001dd8:	08b48b63          	beq	s1,a1,80001e6e <usertrap+0x1de>
            if (p_proc->vma[i].occupied == 1)
    80001ddc:	4398                	lw	a4,0(a5)
    80001dde:	fec71ae3          	bne	a4,a2,80001dd2 <usertrap+0x142>
                if (p_proc->vma[i].start_addr <= va && va <= p_proc->vma[i].end_addr)
    80001de2:	43d8                	lw	a4,4(a5)
    80001de4:	fee9e7e3          	bltu	s3,a4,80001dd2 <usertrap+0x142>
    80001de8:	4798                	lw	a4,8(a5)
    80001dea:	ff3764e3          	bltu	a4,s3,80001dd2 <usertrap+0x142>
                    printf("[Testing] : Find it!\n");
    80001dee:	00006517          	auipc	a0,0x6
    80001df2:	4e250513          	addi	a0,a0,1250 # 800082d0 <states.1738+0x90>
    80001df6:	00004097          	auipc	ra,0x4
    80001dfa:	0f6080e7          	jalr	246(ra) # 80005eec <printf>
                    printf("[Testing] : %d\n", vma_find);
    80001dfe:	4585                	li	a1,1
    80001e00:	00006517          	auipc	a0,0x6
    80001e04:	4e850513          	addi	a0,a0,1256 # 800082e8 <states.1738+0xa8>
    80001e08:	00004097          	auipc	ra,0x4
    80001e0c:	0e4080e7          	jalr	228(ra) # 80005eec <printf>
            char *mem = (char *)kalloc();
    80001e10:	ffffe097          	auipc	ra,0xffffe
    80001e14:	308080e7          	jalr	776(ra) # 80000118 <kalloc>
    80001e18:	8b2a                	mv	s6,a0
            if (mem == 0)
    80001e1a:	c925                	beqz	a0,80001e8a <usertrap+0x1fa>
                mapfile(p_vma->pf, mem, p_vma->offset);
    80001e1c:	00349a93          	slli	s5,s1,0x3
    80001e20:	409a87b3          	sub	a5,s5,s1
    80001e24:	078e                	slli	a5,a5,0x3
    80001e26:	97d2                	add	a5,a5,s4
    80001e28:	1907a603          	lw	a2,400(a5)
    80001e2c:	85aa                	mv	a1,a0
    80001e2e:	1987b503          	ld	a0,408(a5)
    80001e32:	00002097          	auipc	ra,0x2
    80001e36:	da2080e7          	jalr	-606(ra) # 80003bd4 <mapfile>
                if ((mappages(p_proc->pagetable, va, PGSIZE, (uint64)mem, p_vma->prot | PTE_U | PTE_X)) == -1)
    80001e3a:	409a87b3          	sub	a5,s5,s1
    80001e3e:	078e                	slli	a5,a5,0x3
    80001e40:	97d2                	add	a5,a5,s4
    80001e42:	1847a703          	lw	a4,388(a5)
    80001e46:	01876713          	ori	a4,a4,24
    80001e4a:	86da                	mv	a3,s6
    80001e4c:	6605                	lui	a2,0x1
    80001e4e:	85ce                	mv	a1,s3
    80001e50:	050a3503          	ld	a0,80(s4)
    80001e54:	ffffe097          	auipc	ra,0xffffe
    80001e58:	6f8080e7          	jalr	1784(ra) # 8000054c <mappages>
    80001e5c:	57fd                	li	a5,-1
    80001e5e:	f0f517e3          	bne	a0,a5,80001d6c <usertrap+0xdc>
                    setkilled(p_proc);
    80001e62:	8552                	mv	a0,s4
    80001e64:	00000097          	auipc	ra,0x0
    80001e68:	91e080e7          	jalr	-1762(ra) # 80001782 <setkilled>
    80001e6c:	b701                	j	80001d6c <usertrap+0xdc>
            setkilled(p_proc);
    80001e6e:	8552                	mv	a0,s4
    80001e70:	00000097          	auipc	ra,0x0
    80001e74:	912080e7          	jalr	-1774(ra) # 80001782 <setkilled>
            printf("Now, after mmap, we get a page fault\n");
    80001e78:	00006517          	auipc	a0,0x6
    80001e7c:	48050513          	addi	a0,a0,1152 # 800082f8 <states.1738+0xb8>
    80001e80:	00004097          	auipc	ra,0x4
    80001e84:	06c080e7          	jalr	108(ra) # 80005eec <printf>
            goto err;
    80001e88:	bd85                	j	80001cf8 <usertrap+0x68>
                setkilled(p_proc);
    80001e8a:	8552                	mv	a0,s4
    80001e8c:	00000097          	auipc	ra,0x0
    80001e90:	8f6080e7          	jalr	-1802(ra) # 80001782 <setkilled>
                return;
    80001e94:	b5fd                	j	80001d82 <usertrap+0xf2>
    if (killed(p))
    80001e96:	854a                	mv	a0,s2
    80001e98:	00000097          	auipc	ra,0x0
    80001e9c:	916080e7          	jalr	-1770(ra) # 800017ae <killed>
    80001ea0:	c901                	beqz	a0,80001eb0 <usertrap+0x220>
    80001ea2:	a011                	j	80001ea6 <usertrap+0x216>
    80001ea4:	4481                	li	s1,0
        exit(-1);
    80001ea6:	557d                	li	a0,-1
    80001ea8:	fffff097          	auipc	ra,0xfffff
    80001eac:	792080e7          	jalr	1938(ra) # 8000163a <exit>
    if (which_dev == 2)
    80001eb0:	4789                	li	a5,2
    80001eb2:	ecf494e3          	bne	s1,a5,80001d7a <usertrap+0xea>
        yield();
    80001eb6:	fffff097          	auipc	ra,0xfffff
    80001eba:	614080e7          	jalr	1556(ra) # 800014ca <yield>
    80001ebe:	bd75                	j	80001d7a <usertrap+0xea>

0000000080001ec0 <kerneltrap>:
{
    80001ec0:	7179                	addi	sp,sp,-48
    80001ec2:	f406                	sd	ra,40(sp)
    80001ec4:	f022                	sd	s0,32(sp)
    80001ec6:	ec26                	sd	s1,24(sp)
    80001ec8:	e84a                	sd	s2,16(sp)
    80001eca:	e44e                	sd	s3,8(sp)
    80001ecc:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001ece:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ed2:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001ed6:	142029f3          	csrr	s3,scause
    if ((sstatus & SSTATUS_SPP) == 0)
    80001eda:	1004f793          	andi	a5,s1,256
    80001ede:	cb85                	beqz	a5,80001f0e <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ee0:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001ee4:	8b89                	andi	a5,a5,2
    if (intr_get() != 0)
    80001ee6:	ef85                	bnez	a5,80001f1e <kerneltrap+0x5e>
    if ((which_dev = devintr()) == 0)
    80001ee8:	00000097          	auipc	ra,0x0
    80001eec:	d06080e7          	jalr	-762(ra) # 80001bee <devintr>
    80001ef0:	cd1d                	beqz	a0,80001f2e <kerneltrap+0x6e>
    if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001ef2:	4789                	li	a5,2
    80001ef4:	06f50a63          	beq	a0,a5,80001f68 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001ef8:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001efc:	10049073          	csrw	sstatus,s1
}
    80001f00:	70a2                	ld	ra,40(sp)
    80001f02:	7402                	ld	s0,32(sp)
    80001f04:	64e2                	ld	s1,24(sp)
    80001f06:	6942                	ld	s2,16(sp)
    80001f08:	69a2                	ld	s3,8(sp)
    80001f0a:	6145                	addi	sp,sp,48
    80001f0c:	8082                	ret
        panic("kerneltrap: not from supervisor mode");
    80001f0e:	00006517          	auipc	a0,0x6
    80001f12:	46250513          	addi	a0,a0,1122 # 80008370 <states.1738+0x130>
    80001f16:	00004097          	auipc	ra,0x4
    80001f1a:	f8c080e7          	jalr	-116(ra) # 80005ea2 <panic>
        panic("kerneltrap: interrupts enabled");
    80001f1e:	00006517          	auipc	a0,0x6
    80001f22:	47a50513          	addi	a0,a0,1146 # 80008398 <states.1738+0x158>
    80001f26:	00004097          	auipc	ra,0x4
    80001f2a:	f7c080e7          	jalr	-132(ra) # 80005ea2 <panic>
        printf("scause %p\n", scause);
    80001f2e:	85ce                	mv	a1,s3
    80001f30:	00006517          	auipc	a0,0x6
    80001f34:	48850513          	addi	a0,a0,1160 # 800083b8 <states.1738+0x178>
    80001f38:	00004097          	auipc	ra,0x4
    80001f3c:	fb4080e7          	jalr	-76(ra) # 80005eec <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f40:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001f44:	14302673          	csrr	a2,stval
        printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001f48:	00006517          	auipc	a0,0x6
    80001f4c:	48050513          	addi	a0,a0,1152 # 800083c8 <states.1738+0x188>
    80001f50:	00004097          	auipc	ra,0x4
    80001f54:	f9c080e7          	jalr	-100(ra) # 80005eec <printf>
        panic("kerneltrap");
    80001f58:	00006517          	auipc	a0,0x6
    80001f5c:	48850513          	addi	a0,a0,1160 # 800083e0 <states.1738+0x1a0>
    80001f60:	00004097          	auipc	ra,0x4
    80001f64:	f42080e7          	jalr	-190(ra) # 80005ea2 <panic>
    if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001f68:	fffff097          	auipc	ra,0xfffff
    80001f6c:	efa080e7          	jalr	-262(ra) # 80000e62 <myproc>
    80001f70:	d541                	beqz	a0,80001ef8 <kerneltrap+0x38>
    80001f72:	fffff097          	auipc	ra,0xfffff
    80001f76:	ef0080e7          	jalr	-272(ra) # 80000e62 <myproc>
    80001f7a:	4d18                	lw	a4,24(a0)
    80001f7c:	4791                	li	a5,4
    80001f7e:	f6f71de3          	bne	a4,a5,80001ef8 <kerneltrap+0x38>
        yield();
    80001f82:	fffff097          	auipc	ra,0xfffff
    80001f86:	548080e7          	jalr	1352(ra) # 800014ca <yield>
    80001f8a:	b7bd                	j	80001ef8 <kerneltrap+0x38>

0000000080001f8c <argraw>:
    return strlen(buf);
}

static uint64
argraw(int n)
{
    80001f8c:	1101                	addi	sp,sp,-32
    80001f8e:	ec06                	sd	ra,24(sp)
    80001f90:	e822                	sd	s0,16(sp)
    80001f92:	e426                	sd	s1,8(sp)
    80001f94:	1000                	addi	s0,sp,32
    80001f96:	84aa                	mv	s1,a0
    struct proc *p = myproc();
    80001f98:	fffff097          	auipc	ra,0xfffff
    80001f9c:	eca080e7          	jalr	-310(ra) # 80000e62 <myproc>
    switch (n)
    80001fa0:	4795                	li	a5,5
    80001fa2:	0497e163          	bltu	a5,s1,80001fe4 <argraw+0x58>
    80001fa6:	048a                	slli	s1,s1,0x2
    80001fa8:	00006717          	auipc	a4,0x6
    80001fac:	47070713          	addi	a4,a4,1136 # 80008418 <states.1738+0x1d8>
    80001fb0:	94ba                	add	s1,s1,a4
    80001fb2:	409c                	lw	a5,0(s1)
    80001fb4:	97ba                	add	a5,a5,a4
    80001fb6:	8782                	jr	a5
    {
    case 0:
        return p->trapframe->a0;
    80001fb8:	6d3c                	ld	a5,88(a0)
    80001fba:	7ba8                	ld	a0,112(a5)
    case 5:
        return p->trapframe->a5;
    }
    panic("argraw");
    return -1;
}
    80001fbc:	60e2                	ld	ra,24(sp)
    80001fbe:	6442                	ld	s0,16(sp)
    80001fc0:	64a2                	ld	s1,8(sp)
    80001fc2:	6105                	addi	sp,sp,32
    80001fc4:	8082                	ret
        return p->trapframe->a1;
    80001fc6:	6d3c                	ld	a5,88(a0)
    80001fc8:	7fa8                	ld	a0,120(a5)
    80001fca:	bfcd                	j	80001fbc <argraw+0x30>
        return p->trapframe->a2;
    80001fcc:	6d3c                	ld	a5,88(a0)
    80001fce:	63c8                	ld	a0,128(a5)
    80001fd0:	b7f5                	j	80001fbc <argraw+0x30>
        return p->trapframe->a3;
    80001fd2:	6d3c                	ld	a5,88(a0)
    80001fd4:	67c8                	ld	a0,136(a5)
    80001fd6:	b7dd                	j	80001fbc <argraw+0x30>
        return p->trapframe->a4;
    80001fd8:	6d3c                	ld	a5,88(a0)
    80001fda:	6bc8                	ld	a0,144(a5)
    80001fdc:	b7c5                	j	80001fbc <argraw+0x30>
        return p->trapframe->a5;
    80001fde:	6d3c                	ld	a5,88(a0)
    80001fe0:	6fc8                	ld	a0,152(a5)
    80001fe2:	bfe9                	j	80001fbc <argraw+0x30>
    panic("argraw");
    80001fe4:	00006517          	auipc	a0,0x6
    80001fe8:	40c50513          	addi	a0,a0,1036 # 800083f0 <states.1738+0x1b0>
    80001fec:	00004097          	auipc	ra,0x4
    80001ff0:	eb6080e7          	jalr	-330(ra) # 80005ea2 <panic>

0000000080001ff4 <fetchaddr>:
{
    80001ff4:	1101                	addi	sp,sp,-32
    80001ff6:	ec06                	sd	ra,24(sp)
    80001ff8:	e822                	sd	s0,16(sp)
    80001ffa:	e426                	sd	s1,8(sp)
    80001ffc:	e04a                	sd	s2,0(sp)
    80001ffe:	1000                	addi	s0,sp,32
    80002000:	84aa                	mv	s1,a0
    80002002:	892e                	mv	s2,a1
    struct proc *p = myproc();
    80002004:	fffff097          	auipc	ra,0xfffff
    80002008:	e5e080e7          	jalr	-418(ra) # 80000e62 <myproc>
    if (addr >= p->sz || addr + sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    8000200c:	653c                	ld	a5,72(a0)
    8000200e:	02f4f863          	bgeu	s1,a5,8000203e <fetchaddr+0x4a>
    80002012:	00848713          	addi	a4,s1,8
    80002016:	02e7e663          	bltu	a5,a4,80002042 <fetchaddr+0x4e>
    if (copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    8000201a:	46a1                	li	a3,8
    8000201c:	8626                	mv	a2,s1
    8000201e:	85ca                	mv	a1,s2
    80002020:	6928                	ld	a0,80(a0)
    80002022:	fffff097          	auipc	ra,0xfffff
    80002026:	b8a080e7          	jalr	-1142(ra) # 80000bac <copyin>
    8000202a:	00a03533          	snez	a0,a0
    8000202e:	40a00533          	neg	a0,a0
}
    80002032:	60e2                	ld	ra,24(sp)
    80002034:	6442                	ld	s0,16(sp)
    80002036:	64a2                	ld	s1,8(sp)
    80002038:	6902                	ld	s2,0(sp)
    8000203a:	6105                	addi	sp,sp,32
    8000203c:	8082                	ret
        return -1;
    8000203e:	557d                	li	a0,-1
    80002040:	bfcd                	j	80002032 <fetchaddr+0x3e>
    80002042:	557d                	li	a0,-1
    80002044:	b7fd                	j	80002032 <fetchaddr+0x3e>

0000000080002046 <fetchstr>:
{
    80002046:	7179                	addi	sp,sp,-48
    80002048:	f406                	sd	ra,40(sp)
    8000204a:	f022                	sd	s0,32(sp)
    8000204c:	ec26                	sd	s1,24(sp)
    8000204e:	e84a                	sd	s2,16(sp)
    80002050:	e44e                	sd	s3,8(sp)
    80002052:	1800                	addi	s0,sp,48
    80002054:	892a                	mv	s2,a0
    80002056:	84ae                	mv	s1,a1
    80002058:	89b2                	mv	s3,a2
    struct proc *p = myproc();
    8000205a:	fffff097          	auipc	ra,0xfffff
    8000205e:	e08080e7          	jalr	-504(ra) # 80000e62 <myproc>
    if (copyinstr(p->pagetable, buf, addr, max) < 0)
    80002062:	86ce                	mv	a3,s3
    80002064:	864a                	mv	a2,s2
    80002066:	85a6                	mv	a1,s1
    80002068:	6928                	ld	a0,80(a0)
    8000206a:	fffff097          	auipc	ra,0xfffff
    8000206e:	bce080e7          	jalr	-1074(ra) # 80000c38 <copyinstr>
    80002072:	00054e63          	bltz	a0,8000208e <fetchstr+0x48>
    return strlen(buf);
    80002076:	8526                	mv	a0,s1
    80002078:	ffffe097          	auipc	ra,0xffffe
    8000207c:	284080e7          	jalr	644(ra) # 800002fc <strlen>
}
    80002080:	70a2                	ld	ra,40(sp)
    80002082:	7402                	ld	s0,32(sp)
    80002084:	64e2                	ld	s1,24(sp)
    80002086:	6942                	ld	s2,16(sp)
    80002088:	69a2                	ld	s3,8(sp)
    8000208a:	6145                	addi	sp,sp,48
    8000208c:	8082                	ret
        return -1;
    8000208e:	557d                	li	a0,-1
    80002090:	bfc5                	j	80002080 <fetchstr+0x3a>

0000000080002092 <argint>:

// Fetch the nth 32-bit system call argument.
void argint(int n, int *ip)
{
    80002092:	1101                	addi	sp,sp,-32
    80002094:	ec06                	sd	ra,24(sp)
    80002096:	e822                	sd	s0,16(sp)
    80002098:	e426                	sd	s1,8(sp)
    8000209a:	1000                	addi	s0,sp,32
    8000209c:	84ae                	mv	s1,a1
    *ip = argraw(n);
    8000209e:	00000097          	auipc	ra,0x0
    800020a2:	eee080e7          	jalr	-274(ra) # 80001f8c <argraw>
    800020a6:	c088                	sw	a0,0(s1)
}
    800020a8:	60e2                	ld	ra,24(sp)
    800020aa:	6442                	ld	s0,16(sp)
    800020ac:	64a2                	ld	s1,8(sp)
    800020ae:	6105                	addi	sp,sp,32
    800020b0:	8082                	ret

00000000800020b2 <argaddr>:

// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void argaddr(int n, uint64 *ip)
{
    800020b2:	1101                	addi	sp,sp,-32
    800020b4:	ec06                	sd	ra,24(sp)
    800020b6:	e822                	sd	s0,16(sp)
    800020b8:	e426                	sd	s1,8(sp)
    800020ba:	1000                	addi	s0,sp,32
    800020bc:	84ae                	mv	s1,a1
    *ip = argraw(n);
    800020be:	00000097          	auipc	ra,0x0
    800020c2:	ece080e7          	jalr	-306(ra) # 80001f8c <argraw>
    800020c6:	e088                	sd	a0,0(s1)
}
    800020c8:	60e2                	ld	ra,24(sp)
    800020ca:	6442                	ld	s0,16(sp)
    800020cc:	64a2                	ld	s1,8(sp)
    800020ce:	6105                	addi	sp,sp,32
    800020d0:	8082                	ret

00000000800020d2 <argstr>:

// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int argstr(int n, char *buf, int max)
{
    800020d2:	7179                	addi	sp,sp,-48
    800020d4:	f406                	sd	ra,40(sp)
    800020d6:	f022                	sd	s0,32(sp)
    800020d8:	ec26                	sd	s1,24(sp)
    800020da:	e84a                	sd	s2,16(sp)
    800020dc:	1800                	addi	s0,sp,48
    800020de:	84ae                	mv	s1,a1
    800020e0:	8932                	mv	s2,a2
    uint64 addr;
    argaddr(n, &addr);
    800020e2:	fd840593          	addi	a1,s0,-40
    800020e6:	00000097          	auipc	ra,0x0
    800020ea:	fcc080e7          	jalr	-52(ra) # 800020b2 <argaddr>
    return fetchstr(addr, buf, max);
    800020ee:	864a                	mv	a2,s2
    800020f0:	85a6                	mv	a1,s1
    800020f2:	fd843503          	ld	a0,-40(s0)
    800020f6:	00000097          	auipc	ra,0x0
    800020fa:	f50080e7          	jalr	-176(ra) # 80002046 <fetchstr>
}
    800020fe:	70a2                	ld	ra,40(sp)
    80002100:	7402                	ld	s0,32(sp)
    80002102:	64e2                	ld	s1,24(sp)
    80002104:	6942                	ld	s2,16(sp)
    80002106:	6145                	addi	sp,sp,48
    80002108:	8082                	ret

000000008000210a <syscall>:
    [SYS_mmap] sys_mmap,
    [SYS_munmap] sys_munmap,
};

void syscall(void)
{
    8000210a:	1101                	addi	sp,sp,-32
    8000210c:	ec06                	sd	ra,24(sp)
    8000210e:	e822                	sd	s0,16(sp)
    80002110:	e426                	sd	s1,8(sp)
    80002112:	e04a                	sd	s2,0(sp)
    80002114:	1000                	addi	s0,sp,32
    int num;
    struct proc *p = myproc();
    80002116:	fffff097          	auipc	ra,0xfffff
    8000211a:	d4c080e7          	jalr	-692(ra) # 80000e62 <myproc>
    8000211e:	84aa                	mv	s1,a0

    num = p->trapframe->a7;
    80002120:	05853903          	ld	s2,88(a0)
    80002124:	0a893783          	ld	a5,168(s2)
    80002128:	0007869b          	sext.w	a3,a5
    if (num > 0 && num < NELEM(syscalls) && syscalls[num])
    8000212c:	37fd                	addiw	a5,a5,-1
    8000212e:	4759                	li	a4,22
    80002130:	00f76f63          	bltu	a4,a5,8000214e <syscall+0x44>
    80002134:	00369713          	slli	a4,a3,0x3
    80002138:	00006797          	auipc	a5,0x6
    8000213c:	2f878793          	addi	a5,a5,760 # 80008430 <syscalls>
    80002140:	97ba                	add	a5,a5,a4
    80002142:	639c                	ld	a5,0(a5)
    80002144:	c789                	beqz	a5,8000214e <syscall+0x44>
    {
        // Use num to lookup the system call function for num, call it,
        // and store its return value in p->trapframe->a0
        p->trapframe->a0 = syscalls[num]();
    80002146:	9782                	jalr	a5
    80002148:	06a93823          	sd	a0,112(s2)
    8000214c:	a839                	j	8000216a <syscall+0x60>
    }
    else
    {
        printf("%d %s: unknown sys call %d\n",
    8000214e:	15848613          	addi	a2,s1,344
    80002152:	588c                	lw	a1,48(s1)
    80002154:	00006517          	auipc	a0,0x6
    80002158:	2a450513          	addi	a0,a0,676 # 800083f8 <states.1738+0x1b8>
    8000215c:	00004097          	auipc	ra,0x4
    80002160:	d90080e7          	jalr	-624(ra) # 80005eec <printf>
               p->pid, p->name, num);
        p->trapframe->a0 = -1;
    80002164:	6cbc                	ld	a5,88(s1)
    80002166:	577d                	li	a4,-1
    80002168:	fbb8                	sd	a4,112(a5)
    }
}
    8000216a:	60e2                	ld	ra,24(sp)
    8000216c:	6442                	ld	s0,16(sp)
    8000216e:	64a2                	ld	s1,8(sp)
    80002170:	6902                	ld	s2,0(sp)
    80002172:	6105                	addi	sp,sp,32
    80002174:	8082                	ret

0000000080002176 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002176:	1101                	addi	sp,sp,-32
    80002178:	ec06                	sd	ra,24(sp)
    8000217a:	e822                	sd	s0,16(sp)
    8000217c:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    8000217e:	fec40593          	addi	a1,s0,-20
    80002182:	4501                	li	a0,0
    80002184:	00000097          	auipc	ra,0x0
    80002188:	f0e080e7          	jalr	-242(ra) # 80002092 <argint>
  exit(n);
    8000218c:	fec42503          	lw	a0,-20(s0)
    80002190:	fffff097          	auipc	ra,0xfffff
    80002194:	4aa080e7          	jalr	1194(ra) # 8000163a <exit>
  return 0;  // not reached
}
    80002198:	4501                	li	a0,0
    8000219a:	60e2                	ld	ra,24(sp)
    8000219c:	6442                	ld	s0,16(sp)
    8000219e:	6105                	addi	sp,sp,32
    800021a0:	8082                	ret

00000000800021a2 <sys_getpid>:

uint64
sys_getpid(void)
{
    800021a2:	1141                	addi	sp,sp,-16
    800021a4:	e406                	sd	ra,8(sp)
    800021a6:	e022                	sd	s0,0(sp)
    800021a8:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800021aa:	fffff097          	auipc	ra,0xfffff
    800021ae:	cb8080e7          	jalr	-840(ra) # 80000e62 <myproc>
}
    800021b2:	5908                	lw	a0,48(a0)
    800021b4:	60a2                	ld	ra,8(sp)
    800021b6:	6402                	ld	s0,0(sp)
    800021b8:	0141                	addi	sp,sp,16
    800021ba:	8082                	ret

00000000800021bc <sys_fork>:

uint64
sys_fork(void)
{
    800021bc:	1141                	addi	sp,sp,-16
    800021be:	e406                	sd	ra,8(sp)
    800021c0:	e022                	sd	s0,0(sp)
    800021c2:	0800                	addi	s0,sp,16
  return fork();
    800021c4:	fffff097          	auipc	ra,0xfffff
    800021c8:	054080e7          	jalr	84(ra) # 80001218 <fork>
}
    800021cc:	60a2                	ld	ra,8(sp)
    800021ce:	6402                	ld	s0,0(sp)
    800021d0:	0141                	addi	sp,sp,16
    800021d2:	8082                	ret

00000000800021d4 <sys_wait>:

uint64
sys_wait(void)
{
    800021d4:	1101                	addi	sp,sp,-32
    800021d6:	ec06                	sd	ra,24(sp)
    800021d8:	e822                	sd	s0,16(sp)
    800021da:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    800021dc:	fe840593          	addi	a1,s0,-24
    800021e0:	4501                	li	a0,0
    800021e2:	00000097          	auipc	ra,0x0
    800021e6:	ed0080e7          	jalr	-304(ra) # 800020b2 <argaddr>
  return wait(p);
    800021ea:	fe843503          	ld	a0,-24(s0)
    800021ee:	fffff097          	auipc	ra,0xfffff
    800021f2:	5f2080e7          	jalr	1522(ra) # 800017e0 <wait>
}
    800021f6:	60e2                	ld	ra,24(sp)
    800021f8:	6442                	ld	s0,16(sp)
    800021fa:	6105                	addi	sp,sp,32
    800021fc:	8082                	ret

00000000800021fe <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800021fe:	7179                	addi	sp,sp,-48
    80002200:	f406                	sd	ra,40(sp)
    80002202:	f022                	sd	s0,32(sp)
    80002204:	ec26                	sd	s1,24(sp)
    80002206:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80002208:	fdc40593          	addi	a1,s0,-36
    8000220c:	4501                	li	a0,0
    8000220e:	00000097          	auipc	ra,0x0
    80002212:	e84080e7          	jalr	-380(ra) # 80002092 <argint>
  addr = myproc()->sz;
    80002216:	fffff097          	auipc	ra,0xfffff
    8000221a:	c4c080e7          	jalr	-948(ra) # 80000e62 <myproc>
    8000221e:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    80002220:	fdc42503          	lw	a0,-36(s0)
    80002224:	fffff097          	auipc	ra,0xfffff
    80002228:	f98080e7          	jalr	-104(ra) # 800011bc <growproc>
    8000222c:	00054863          	bltz	a0,8000223c <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    80002230:	8526                	mv	a0,s1
    80002232:	70a2                	ld	ra,40(sp)
    80002234:	7402                	ld	s0,32(sp)
    80002236:	64e2                	ld	s1,24(sp)
    80002238:	6145                	addi	sp,sp,48
    8000223a:	8082                	ret
    return -1;
    8000223c:	54fd                	li	s1,-1
    8000223e:	bfcd                	j	80002230 <sys_sbrk+0x32>

0000000080002240 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002240:	7139                	addi	sp,sp,-64
    80002242:	fc06                	sd	ra,56(sp)
    80002244:	f822                	sd	s0,48(sp)
    80002246:	f426                	sd	s1,40(sp)
    80002248:	f04a                	sd	s2,32(sp)
    8000224a:	ec4e                	sd	s3,24(sp)
    8000224c:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    8000224e:	fcc40593          	addi	a1,s0,-52
    80002252:	4501                	li	a0,0
    80002254:	00000097          	auipc	ra,0x0
    80002258:	e3e080e7          	jalr	-450(ra) # 80002092 <argint>
  if(n < 0)
    8000225c:	fcc42783          	lw	a5,-52(s0)
    80002260:	0607cf63          	bltz	a5,800022de <sys_sleep+0x9e>
    n = 0;
  acquire(&tickslock);
    80002264:	0001a517          	auipc	a0,0x1a
    80002268:	55c50513          	addi	a0,a0,1372 # 8001c7c0 <tickslock>
    8000226c:	00004097          	auipc	ra,0x4
    80002270:	180080e7          	jalr	384(ra) # 800063ec <acquire>
  ticks0 = ticks;
    80002274:	00006917          	auipc	s2,0x6
    80002278:	6e492903          	lw	s2,1764(s2) # 80008958 <ticks>
  while(ticks - ticks0 < n){
    8000227c:	fcc42783          	lw	a5,-52(s0)
    80002280:	cf9d                	beqz	a5,800022be <sys_sleep+0x7e>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002282:	0001a997          	auipc	s3,0x1a
    80002286:	53e98993          	addi	s3,s3,1342 # 8001c7c0 <tickslock>
    8000228a:	00006497          	auipc	s1,0x6
    8000228e:	6ce48493          	addi	s1,s1,1742 # 80008958 <ticks>
    if(killed(myproc())){
    80002292:	fffff097          	auipc	ra,0xfffff
    80002296:	bd0080e7          	jalr	-1072(ra) # 80000e62 <myproc>
    8000229a:	fffff097          	auipc	ra,0xfffff
    8000229e:	514080e7          	jalr	1300(ra) # 800017ae <killed>
    800022a2:	e129                	bnez	a0,800022e4 <sys_sleep+0xa4>
    sleep(&ticks, &tickslock);
    800022a4:	85ce                	mv	a1,s3
    800022a6:	8526                	mv	a0,s1
    800022a8:	fffff097          	auipc	ra,0xfffff
    800022ac:	25e080e7          	jalr	606(ra) # 80001506 <sleep>
  while(ticks - ticks0 < n){
    800022b0:	409c                	lw	a5,0(s1)
    800022b2:	412787bb          	subw	a5,a5,s2
    800022b6:	fcc42703          	lw	a4,-52(s0)
    800022ba:	fce7ece3          	bltu	a5,a4,80002292 <sys_sleep+0x52>
  }
  release(&tickslock);
    800022be:	0001a517          	auipc	a0,0x1a
    800022c2:	50250513          	addi	a0,a0,1282 # 8001c7c0 <tickslock>
    800022c6:	00004097          	auipc	ra,0x4
    800022ca:	1da080e7          	jalr	474(ra) # 800064a0 <release>
  return 0;
    800022ce:	4501                	li	a0,0
}
    800022d0:	70e2                	ld	ra,56(sp)
    800022d2:	7442                	ld	s0,48(sp)
    800022d4:	74a2                	ld	s1,40(sp)
    800022d6:	7902                	ld	s2,32(sp)
    800022d8:	69e2                	ld	s3,24(sp)
    800022da:	6121                	addi	sp,sp,64
    800022dc:	8082                	ret
    n = 0;
    800022de:	fc042623          	sw	zero,-52(s0)
    800022e2:	b749                	j	80002264 <sys_sleep+0x24>
      release(&tickslock);
    800022e4:	0001a517          	auipc	a0,0x1a
    800022e8:	4dc50513          	addi	a0,a0,1244 # 8001c7c0 <tickslock>
    800022ec:	00004097          	auipc	ra,0x4
    800022f0:	1b4080e7          	jalr	436(ra) # 800064a0 <release>
      return -1;
    800022f4:	557d                	li	a0,-1
    800022f6:	bfe9                	j	800022d0 <sys_sleep+0x90>

00000000800022f8 <sys_kill>:

uint64
sys_kill(void)
{
    800022f8:	1101                	addi	sp,sp,-32
    800022fa:	ec06                	sd	ra,24(sp)
    800022fc:	e822                	sd	s0,16(sp)
    800022fe:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80002300:	fec40593          	addi	a1,s0,-20
    80002304:	4501                	li	a0,0
    80002306:	00000097          	auipc	ra,0x0
    8000230a:	d8c080e7          	jalr	-628(ra) # 80002092 <argint>
  return kill(pid);
    8000230e:	fec42503          	lw	a0,-20(s0)
    80002312:	fffff097          	auipc	ra,0xfffff
    80002316:	3fe080e7          	jalr	1022(ra) # 80001710 <kill>
}
    8000231a:	60e2                	ld	ra,24(sp)
    8000231c:	6442                	ld	s0,16(sp)
    8000231e:	6105                	addi	sp,sp,32
    80002320:	8082                	ret

0000000080002322 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002322:	1101                	addi	sp,sp,-32
    80002324:	ec06                	sd	ra,24(sp)
    80002326:	e822                	sd	s0,16(sp)
    80002328:	e426                	sd	s1,8(sp)
    8000232a:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    8000232c:	0001a517          	auipc	a0,0x1a
    80002330:	49450513          	addi	a0,a0,1172 # 8001c7c0 <tickslock>
    80002334:	00004097          	auipc	ra,0x4
    80002338:	0b8080e7          	jalr	184(ra) # 800063ec <acquire>
  xticks = ticks;
    8000233c:	00006497          	auipc	s1,0x6
    80002340:	61c4a483          	lw	s1,1564(s1) # 80008958 <ticks>
  release(&tickslock);
    80002344:	0001a517          	auipc	a0,0x1a
    80002348:	47c50513          	addi	a0,a0,1148 # 8001c7c0 <tickslock>
    8000234c:	00004097          	auipc	ra,0x4
    80002350:	154080e7          	jalr	340(ra) # 800064a0 <release>
  return xticks;
}
    80002354:	02049513          	slli	a0,s1,0x20
    80002358:	9101                	srli	a0,a0,0x20
    8000235a:	60e2                	ld	ra,24(sp)
    8000235c:	6442                	ld	s0,16(sp)
    8000235e:	64a2                	ld	s1,8(sp)
    80002360:	6105                	addi	sp,sp,32
    80002362:	8082                	ret

0000000080002364 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002364:	7179                	addi	sp,sp,-48
    80002366:	f406                	sd	ra,40(sp)
    80002368:	f022                	sd	s0,32(sp)
    8000236a:	ec26                	sd	s1,24(sp)
    8000236c:	e84a                	sd	s2,16(sp)
    8000236e:	e44e                	sd	s3,8(sp)
    80002370:	e052                	sd	s4,0(sp)
    80002372:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002374:	00006597          	auipc	a1,0x6
    80002378:	17c58593          	addi	a1,a1,380 # 800084f0 <syscalls+0xc0>
    8000237c:	0001a517          	auipc	a0,0x1a
    80002380:	45c50513          	addi	a0,a0,1116 # 8001c7d8 <bcache>
    80002384:	00004097          	auipc	ra,0x4
    80002388:	fd8080e7          	jalr	-40(ra) # 8000635c <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    8000238c:	00022797          	auipc	a5,0x22
    80002390:	44c78793          	addi	a5,a5,1100 # 800247d8 <bcache+0x8000>
    80002394:	00022717          	auipc	a4,0x22
    80002398:	6ac70713          	addi	a4,a4,1708 # 80024a40 <bcache+0x8268>
    8000239c:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800023a0:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800023a4:	0001a497          	auipc	s1,0x1a
    800023a8:	44c48493          	addi	s1,s1,1100 # 8001c7f0 <bcache+0x18>
    b->next = bcache.head.next;
    800023ac:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800023ae:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800023b0:	00006a17          	auipc	s4,0x6
    800023b4:	148a0a13          	addi	s4,s4,328 # 800084f8 <syscalls+0xc8>
    b->next = bcache.head.next;
    800023b8:	2b893783          	ld	a5,696(s2)
    800023bc:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800023be:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800023c2:	85d2                	mv	a1,s4
    800023c4:	01048513          	addi	a0,s1,16
    800023c8:	00001097          	auipc	ra,0x1
    800023cc:	4c4080e7          	jalr	1220(ra) # 8000388c <initsleeplock>
    bcache.head.next->prev = b;
    800023d0:	2b893783          	ld	a5,696(s2)
    800023d4:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800023d6:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800023da:	45848493          	addi	s1,s1,1112
    800023de:	fd349de3          	bne	s1,s3,800023b8 <binit+0x54>
  }
}
    800023e2:	70a2                	ld	ra,40(sp)
    800023e4:	7402                	ld	s0,32(sp)
    800023e6:	64e2                	ld	s1,24(sp)
    800023e8:	6942                	ld	s2,16(sp)
    800023ea:	69a2                	ld	s3,8(sp)
    800023ec:	6a02                	ld	s4,0(sp)
    800023ee:	6145                	addi	sp,sp,48
    800023f0:	8082                	ret

00000000800023f2 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800023f2:	7179                	addi	sp,sp,-48
    800023f4:	f406                	sd	ra,40(sp)
    800023f6:	f022                	sd	s0,32(sp)
    800023f8:	ec26                	sd	s1,24(sp)
    800023fa:	e84a                	sd	s2,16(sp)
    800023fc:	e44e                	sd	s3,8(sp)
    800023fe:	1800                	addi	s0,sp,48
    80002400:	89aa                	mv	s3,a0
    80002402:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    80002404:	0001a517          	auipc	a0,0x1a
    80002408:	3d450513          	addi	a0,a0,980 # 8001c7d8 <bcache>
    8000240c:	00004097          	auipc	ra,0x4
    80002410:	fe0080e7          	jalr	-32(ra) # 800063ec <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002414:	00022497          	auipc	s1,0x22
    80002418:	67c4b483          	ld	s1,1660(s1) # 80024a90 <bcache+0x82b8>
    8000241c:	00022797          	auipc	a5,0x22
    80002420:	62478793          	addi	a5,a5,1572 # 80024a40 <bcache+0x8268>
    80002424:	02f48f63          	beq	s1,a5,80002462 <bread+0x70>
    80002428:	873e                	mv	a4,a5
    8000242a:	a021                	j	80002432 <bread+0x40>
    8000242c:	68a4                	ld	s1,80(s1)
    8000242e:	02e48a63          	beq	s1,a4,80002462 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002432:	449c                	lw	a5,8(s1)
    80002434:	ff379ce3          	bne	a5,s3,8000242c <bread+0x3a>
    80002438:	44dc                	lw	a5,12(s1)
    8000243a:	ff2799e3          	bne	a5,s2,8000242c <bread+0x3a>
      b->refcnt++;
    8000243e:	40bc                	lw	a5,64(s1)
    80002440:	2785                	addiw	a5,a5,1
    80002442:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002444:	0001a517          	auipc	a0,0x1a
    80002448:	39450513          	addi	a0,a0,916 # 8001c7d8 <bcache>
    8000244c:	00004097          	auipc	ra,0x4
    80002450:	054080e7          	jalr	84(ra) # 800064a0 <release>
      acquiresleep(&b->lock);
    80002454:	01048513          	addi	a0,s1,16
    80002458:	00001097          	auipc	ra,0x1
    8000245c:	46e080e7          	jalr	1134(ra) # 800038c6 <acquiresleep>
      return b;
    80002460:	a8b9                	j	800024be <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002462:	00022497          	auipc	s1,0x22
    80002466:	6264b483          	ld	s1,1574(s1) # 80024a88 <bcache+0x82b0>
    8000246a:	00022797          	auipc	a5,0x22
    8000246e:	5d678793          	addi	a5,a5,1494 # 80024a40 <bcache+0x8268>
    80002472:	00f48863          	beq	s1,a5,80002482 <bread+0x90>
    80002476:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002478:	40bc                	lw	a5,64(s1)
    8000247a:	cf81                	beqz	a5,80002492 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000247c:	64a4                	ld	s1,72(s1)
    8000247e:	fee49de3          	bne	s1,a4,80002478 <bread+0x86>
  panic("bget: no buffers");
    80002482:	00006517          	auipc	a0,0x6
    80002486:	07e50513          	addi	a0,a0,126 # 80008500 <syscalls+0xd0>
    8000248a:	00004097          	auipc	ra,0x4
    8000248e:	a18080e7          	jalr	-1512(ra) # 80005ea2 <panic>
      b->dev = dev;
    80002492:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    80002496:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    8000249a:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    8000249e:	4785                	li	a5,1
    800024a0:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800024a2:	0001a517          	auipc	a0,0x1a
    800024a6:	33650513          	addi	a0,a0,822 # 8001c7d8 <bcache>
    800024aa:	00004097          	auipc	ra,0x4
    800024ae:	ff6080e7          	jalr	-10(ra) # 800064a0 <release>
      acquiresleep(&b->lock);
    800024b2:	01048513          	addi	a0,s1,16
    800024b6:	00001097          	auipc	ra,0x1
    800024ba:	410080e7          	jalr	1040(ra) # 800038c6 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800024be:	409c                	lw	a5,0(s1)
    800024c0:	cb89                	beqz	a5,800024d2 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800024c2:	8526                	mv	a0,s1
    800024c4:	70a2                	ld	ra,40(sp)
    800024c6:	7402                	ld	s0,32(sp)
    800024c8:	64e2                	ld	s1,24(sp)
    800024ca:	6942                	ld	s2,16(sp)
    800024cc:	69a2                	ld	s3,8(sp)
    800024ce:	6145                	addi	sp,sp,48
    800024d0:	8082                	ret
    virtio_disk_rw(b, 0);
    800024d2:	4581                	li	a1,0
    800024d4:	8526                	mv	a0,s1
    800024d6:	00003097          	auipc	ra,0x3
    800024da:	162080e7          	jalr	354(ra) # 80005638 <virtio_disk_rw>
    b->valid = 1;
    800024de:	4785                	li	a5,1
    800024e0:	c09c                	sw	a5,0(s1)
  return b;
    800024e2:	b7c5                	j	800024c2 <bread+0xd0>

00000000800024e4 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800024e4:	1101                	addi	sp,sp,-32
    800024e6:	ec06                	sd	ra,24(sp)
    800024e8:	e822                	sd	s0,16(sp)
    800024ea:	e426                	sd	s1,8(sp)
    800024ec:	1000                	addi	s0,sp,32
    800024ee:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800024f0:	0541                	addi	a0,a0,16
    800024f2:	00001097          	auipc	ra,0x1
    800024f6:	46e080e7          	jalr	1134(ra) # 80003960 <holdingsleep>
    800024fa:	cd01                	beqz	a0,80002512 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800024fc:	4585                	li	a1,1
    800024fe:	8526                	mv	a0,s1
    80002500:	00003097          	auipc	ra,0x3
    80002504:	138080e7          	jalr	312(ra) # 80005638 <virtio_disk_rw>
}
    80002508:	60e2                	ld	ra,24(sp)
    8000250a:	6442                	ld	s0,16(sp)
    8000250c:	64a2                	ld	s1,8(sp)
    8000250e:	6105                	addi	sp,sp,32
    80002510:	8082                	ret
    panic("bwrite");
    80002512:	00006517          	auipc	a0,0x6
    80002516:	00650513          	addi	a0,a0,6 # 80008518 <syscalls+0xe8>
    8000251a:	00004097          	auipc	ra,0x4
    8000251e:	988080e7          	jalr	-1656(ra) # 80005ea2 <panic>

0000000080002522 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002522:	1101                	addi	sp,sp,-32
    80002524:	ec06                	sd	ra,24(sp)
    80002526:	e822                	sd	s0,16(sp)
    80002528:	e426                	sd	s1,8(sp)
    8000252a:	e04a                	sd	s2,0(sp)
    8000252c:	1000                	addi	s0,sp,32
    8000252e:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002530:	01050913          	addi	s2,a0,16
    80002534:	854a                	mv	a0,s2
    80002536:	00001097          	auipc	ra,0x1
    8000253a:	42a080e7          	jalr	1066(ra) # 80003960 <holdingsleep>
    8000253e:	c92d                	beqz	a0,800025b0 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    80002540:	854a                	mv	a0,s2
    80002542:	00001097          	auipc	ra,0x1
    80002546:	3da080e7          	jalr	986(ra) # 8000391c <releasesleep>

  acquire(&bcache.lock);
    8000254a:	0001a517          	auipc	a0,0x1a
    8000254e:	28e50513          	addi	a0,a0,654 # 8001c7d8 <bcache>
    80002552:	00004097          	auipc	ra,0x4
    80002556:	e9a080e7          	jalr	-358(ra) # 800063ec <acquire>
  b->refcnt--;
    8000255a:	40bc                	lw	a5,64(s1)
    8000255c:	37fd                	addiw	a5,a5,-1
    8000255e:	0007871b          	sext.w	a4,a5
    80002562:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002564:	eb05                	bnez	a4,80002594 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002566:	68bc                	ld	a5,80(s1)
    80002568:	64b8                	ld	a4,72(s1)
    8000256a:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    8000256c:	64bc                	ld	a5,72(s1)
    8000256e:	68b8                	ld	a4,80(s1)
    80002570:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002572:	00022797          	auipc	a5,0x22
    80002576:	26678793          	addi	a5,a5,614 # 800247d8 <bcache+0x8000>
    8000257a:	2b87b703          	ld	a4,696(a5)
    8000257e:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002580:	00022717          	auipc	a4,0x22
    80002584:	4c070713          	addi	a4,a4,1216 # 80024a40 <bcache+0x8268>
    80002588:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    8000258a:	2b87b703          	ld	a4,696(a5)
    8000258e:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002590:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    80002594:	0001a517          	auipc	a0,0x1a
    80002598:	24450513          	addi	a0,a0,580 # 8001c7d8 <bcache>
    8000259c:	00004097          	auipc	ra,0x4
    800025a0:	f04080e7          	jalr	-252(ra) # 800064a0 <release>
}
    800025a4:	60e2                	ld	ra,24(sp)
    800025a6:	6442                	ld	s0,16(sp)
    800025a8:	64a2                	ld	s1,8(sp)
    800025aa:	6902                	ld	s2,0(sp)
    800025ac:	6105                	addi	sp,sp,32
    800025ae:	8082                	ret
    panic("brelse");
    800025b0:	00006517          	auipc	a0,0x6
    800025b4:	f7050513          	addi	a0,a0,-144 # 80008520 <syscalls+0xf0>
    800025b8:	00004097          	auipc	ra,0x4
    800025bc:	8ea080e7          	jalr	-1814(ra) # 80005ea2 <panic>

00000000800025c0 <bpin>:

void
bpin(struct buf *b) {
    800025c0:	1101                	addi	sp,sp,-32
    800025c2:	ec06                	sd	ra,24(sp)
    800025c4:	e822                	sd	s0,16(sp)
    800025c6:	e426                	sd	s1,8(sp)
    800025c8:	1000                	addi	s0,sp,32
    800025ca:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800025cc:	0001a517          	auipc	a0,0x1a
    800025d0:	20c50513          	addi	a0,a0,524 # 8001c7d8 <bcache>
    800025d4:	00004097          	auipc	ra,0x4
    800025d8:	e18080e7          	jalr	-488(ra) # 800063ec <acquire>
  b->refcnt++;
    800025dc:	40bc                	lw	a5,64(s1)
    800025de:	2785                	addiw	a5,a5,1
    800025e0:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800025e2:	0001a517          	auipc	a0,0x1a
    800025e6:	1f650513          	addi	a0,a0,502 # 8001c7d8 <bcache>
    800025ea:	00004097          	auipc	ra,0x4
    800025ee:	eb6080e7          	jalr	-330(ra) # 800064a0 <release>
}
    800025f2:	60e2                	ld	ra,24(sp)
    800025f4:	6442                	ld	s0,16(sp)
    800025f6:	64a2                	ld	s1,8(sp)
    800025f8:	6105                	addi	sp,sp,32
    800025fa:	8082                	ret

00000000800025fc <bunpin>:

void
bunpin(struct buf *b) {
    800025fc:	1101                	addi	sp,sp,-32
    800025fe:	ec06                	sd	ra,24(sp)
    80002600:	e822                	sd	s0,16(sp)
    80002602:	e426                	sd	s1,8(sp)
    80002604:	1000                	addi	s0,sp,32
    80002606:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002608:	0001a517          	auipc	a0,0x1a
    8000260c:	1d050513          	addi	a0,a0,464 # 8001c7d8 <bcache>
    80002610:	00004097          	auipc	ra,0x4
    80002614:	ddc080e7          	jalr	-548(ra) # 800063ec <acquire>
  b->refcnt--;
    80002618:	40bc                	lw	a5,64(s1)
    8000261a:	37fd                	addiw	a5,a5,-1
    8000261c:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000261e:	0001a517          	auipc	a0,0x1a
    80002622:	1ba50513          	addi	a0,a0,442 # 8001c7d8 <bcache>
    80002626:	00004097          	auipc	ra,0x4
    8000262a:	e7a080e7          	jalr	-390(ra) # 800064a0 <release>
}
    8000262e:	60e2                	ld	ra,24(sp)
    80002630:	6442                	ld	s0,16(sp)
    80002632:	64a2                	ld	s1,8(sp)
    80002634:	6105                	addi	sp,sp,32
    80002636:	8082                	ret

0000000080002638 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002638:	1101                	addi	sp,sp,-32
    8000263a:	ec06                	sd	ra,24(sp)
    8000263c:	e822                	sd	s0,16(sp)
    8000263e:	e426                	sd	s1,8(sp)
    80002640:	e04a                	sd	s2,0(sp)
    80002642:	1000                	addi	s0,sp,32
    80002644:	84ae                	mv	s1,a1
  struct buf *bp;
  int bi, m;

  bp = bread(dev, BBLOCK(b, sb));
    80002646:	00d5d59b          	srliw	a1,a1,0xd
    8000264a:	00023797          	auipc	a5,0x23
    8000264e:	86a7a783          	lw	a5,-1942(a5) # 80024eb4 <sb+0x1c>
    80002652:	9dbd                	addw	a1,a1,a5
    80002654:	00000097          	auipc	ra,0x0
    80002658:	d9e080e7          	jalr	-610(ra) # 800023f2 <bread>
  bi = b % BPB;
  m = 1 << (bi % 8);
    8000265c:	0074f713          	andi	a4,s1,7
    80002660:	4785                	li	a5,1
    80002662:	00e797bb          	sllw	a5,a5,a4
  if((bp->data[bi/8] & m) == 0)
    80002666:	14ce                	slli	s1,s1,0x33
    80002668:	90d9                	srli	s1,s1,0x36
    8000266a:	00950733          	add	a4,a0,s1
    8000266e:	05874703          	lbu	a4,88(a4)
    80002672:	00e7f6b3          	and	a3,a5,a4
    80002676:	c69d                	beqz	a3,800026a4 <bfree+0x6c>
    80002678:	892a                	mv	s2,a0
    panic("freeing free block");
  bp->data[bi/8] &= ~m;
    8000267a:	94aa                	add	s1,s1,a0
    8000267c:	fff7c793          	not	a5,a5
    80002680:	8ff9                	and	a5,a5,a4
    80002682:	04f48c23          	sb	a5,88(s1)
  log_write(bp);
    80002686:	00001097          	auipc	ra,0x1
    8000268a:	120080e7          	jalr	288(ra) # 800037a6 <log_write>
  brelse(bp);
    8000268e:	854a                	mv	a0,s2
    80002690:	00000097          	auipc	ra,0x0
    80002694:	e92080e7          	jalr	-366(ra) # 80002522 <brelse>
}
    80002698:	60e2                	ld	ra,24(sp)
    8000269a:	6442                	ld	s0,16(sp)
    8000269c:	64a2                	ld	s1,8(sp)
    8000269e:	6902                	ld	s2,0(sp)
    800026a0:	6105                	addi	sp,sp,32
    800026a2:	8082                	ret
    panic("freeing free block");
    800026a4:	00006517          	auipc	a0,0x6
    800026a8:	e8450513          	addi	a0,a0,-380 # 80008528 <syscalls+0xf8>
    800026ac:	00003097          	auipc	ra,0x3
    800026b0:	7f6080e7          	jalr	2038(ra) # 80005ea2 <panic>

00000000800026b4 <balloc>:
{
    800026b4:	711d                	addi	sp,sp,-96
    800026b6:	ec86                	sd	ra,88(sp)
    800026b8:	e8a2                	sd	s0,80(sp)
    800026ba:	e4a6                	sd	s1,72(sp)
    800026bc:	e0ca                	sd	s2,64(sp)
    800026be:	fc4e                	sd	s3,56(sp)
    800026c0:	f852                	sd	s4,48(sp)
    800026c2:	f456                	sd	s5,40(sp)
    800026c4:	f05a                	sd	s6,32(sp)
    800026c6:	ec5e                	sd	s7,24(sp)
    800026c8:	e862                	sd	s8,16(sp)
    800026ca:	e466                	sd	s9,8(sp)
    800026cc:	1080                	addi	s0,sp,96
  for(b = 0; b < sb.size; b += BPB){
    800026ce:	00022797          	auipc	a5,0x22
    800026d2:	7ce7a783          	lw	a5,1998(a5) # 80024e9c <sb+0x4>
    800026d6:	10078163          	beqz	a5,800027d8 <balloc+0x124>
    800026da:	8baa                	mv	s7,a0
    800026dc:	4a81                	li	s5,0
    bp = bread(dev, BBLOCK(b, sb));
    800026de:	00022b17          	auipc	s6,0x22
    800026e2:	7bab0b13          	addi	s6,s6,1978 # 80024e98 <sb>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800026e6:	4c01                	li	s8,0
      m = 1 << (bi % 8);
    800026e8:	4985                	li	s3,1
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800026ea:	6a09                	lui	s4,0x2
  for(b = 0; b < sb.size; b += BPB){
    800026ec:	6c89                	lui	s9,0x2
    800026ee:	a061                	j	80002776 <balloc+0xc2>
        bp->data[bi/8] |= m;  // Mark block in use.
    800026f0:	974a                	add	a4,a4,s2
    800026f2:	8fd5                	or	a5,a5,a3
    800026f4:	04f70c23          	sb	a5,88(a4)
        log_write(bp);
    800026f8:	854a                	mv	a0,s2
    800026fa:	00001097          	auipc	ra,0x1
    800026fe:	0ac080e7          	jalr	172(ra) # 800037a6 <log_write>
        brelse(bp);
    80002702:	854a                	mv	a0,s2
    80002704:	00000097          	auipc	ra,0x0
    80002708:	e1e080e7          	jalr	-482(ra) # 80002522 <brelse>
  bp = bread(dev, bno);
    8000270c:	85a6                	mv	a1,s1
    8000270e:	855e                	mv	a0,s7
    80002710:	00000097          	auipc	ra,0x0
    80002714:	ce2080e7          	jalr	-798(ra) # 800023f2 <bread>
    80002718:	892a                	mv	s2,a0
  memset(bp->data, 0, BSIZE);
    8000271a:	40000613          	li	a2,1024
    8000271e:	4581                	li	a1,0
    80002720:	05850513          	addi	a0,a0,88
    80002724:	ffffe097          	auipc	ra,0xffffe
    80002728:	a54080e7          	jalr	-1452(ra) # 80000178 <memset>
  log_write(bp);
    8000272c:	854a                	mv	a0,s2
    8000272e:	00001097          	auipc	ra,0x1
    80002732:	078080e7          	jalr	120(ra) # 800037a6 <log_write>
  brelse(bp);
    80002736:	854a                	mv	a0,s2
    80002738:	00000097          	auipc	ra,0x0
    8000273c:	dea080e7          	jalr	-534(ra) # 80002522 <brelse>
}
    80002740:	8526                	mv	a0,s1
    80002742:	60e6                	ld	ra,88(sp)
    80002744:	6446                	ld	s0,80(sp)
    80002746:	64a6                	ld	s1,72(sp)
    80002748:	6906                	ld	s2,64(sp)
    8000274a:	79e2                	ld	s3,56(sp)
    8000274c:	7a42                	ld	s4,48(sp)
    8000274e:	7aa2                	ld	s5,40(sp)
    80002750:	7b02                	ld	s6,32(sp)
    80002752:	6be2                	ld	s7,24(sp)
    80002754:	6c42                	ld	s8,16(sp)
    80002756:	6ca2                	ld	s9,8(sp)
    80002758:	6125                	addi	sp,sp,96
    8000275a:	8082                	ret
    brelse(bp);
    8000275c:	854a                	mv	a0,s2
    8000275e:	00000097          	auipc	ra,0x0
    80002762:	dc4080e7          	jalr	-572(ra) # 80002522 <brelse>
  for(b = 0; b < sb.size; b += BPB){
    80002766:	015c87bb          	addw	a5,s9,s5
    8000276a:	00078a9b          	sext.w	s5,a5
    8000276e:	004b2703          	lw	a4,4(s6)
    80002772:	06eaf363          	bgeu	s5,a4,800027d8 <balloc+0x124>
    bp = bread(dev, BBLOCK(b, sb));
    80002776:	41fad79b          	sraiw	a5,s5,0x1f
    8000277a:	0137d79b          	srliw	a5,a5,0x13
    8000277e:	015787bb          	addw	a5,a5,s5
    80002782:	40d7d79b          	sraiw	a5,a5,0xd
    80002786:	01cb2583          	lw	a1,28(s6)
    8000278a:	9dbd                	addw	a1,a1,a5
    8000278c:	855e                	mv	a0,s7
    8000278e:	00000097          	auipc	ra,0x0
    80002792:	c64080e7          	jalr	-924(ra) # 800023f2 <bread>
    80002796:	892a                	mv	s2,a0
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    80002798:	004b2503          	lw	a0,4(s6)
    8000279c:	000a849b          	sext.w	s1,s5
    800027a0:	8662                	mv	a2,s8
    800027a2:	faa4fde3          	bgeu	s1,a0,8000275c <balloc+0xa8>
      m = 1 << (bi % 8);
    800027a6:	41f6579b          	sraiw	a5,a2,0x1f
    800027aa:	01d7d69b          	srliw	a3,a5,0x1d
    800027ae:	00c6873b          	addw	a4,a3,a2
    800027b2:	00777793          	andi	a5,a4,7
    800027b6:	9f95                	subw	a5,a5,a3
    800027b8:	00f997bb          	sllw	a5,s3,a5
      if((bp->data[bi/8] & m) == 0){  // Is block free?
    800027bc:	4037571b          	sraiw	a4,a4,0x3
    800027c0:	00e906b3          	add	a3,s2,a4
    800027c4:	0586c683          	lbu	a3,88(a3)
    800027c8:	00d7f5b3          	and	a1,a5,a3
    800027cc:	d195                	beqz	a1,800026f0 <balloc+0x3c>
    for(bi = 0; bi < BPB && b + bi < sb.size; bi++){
    800027ce:	2605                	addiw	a2,a2,1
    800027d0:	2485                	addiw	s1,s1,1
    800027d2:	fd4618e3          	bne	a2,s4,800027a2 <balloc+0xee>
    800027d6:	b759                	j	8000275c <balloc+0xa8>
  printf("balloc: out of blocks\n");
    800027d8:	00006517          	auipc	a0,0x6
    800027dc:	d6850513          	addi	a0,a0,-664 # 80008540 <syscalls+0x110>
    800027e0:	00003097          	auipc	ra,0x3
    800027e4:	70c080e7          	jalr	1804(ra) # 80005eec <printf>
  return 0;
    800027e8:	4481                	li	s1,0
    800027ea:	bf99                	j	80002740 <balloc+0x8c>

00000000800027ec <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    800027ec:	7179                	addi	sp,sp,-48
    800027ee:	f406                	sd	ra,40(sp)
    800027f0:	f022                	sd	s0,32(sp)
    800027f2:	ec26                	sd	s1,24(sp)
    800027f4:	e84a                	sd	s2,16(sp)
    800027f6:	e44e                	sd	s3,8(sp)
    800027f8:	e052                	sd	s4,0(sp)
    800027fa:	1800                	addi	s0,sp,48
    800027fc:	89aa                	mv	s3,a0
  uint addr, *a;
  struct buf *bp;

  if(bn < NDIRECT){
    800027fe:	47ad                	li	a5,11
    80002800:	02b7e763          	bltu	a5,a1,8000282e <bmap+0x42>
    if((addr = ip->addrs[bn]) == 0){
    80002804:	02059493          	slli	s1,a1,0x20
    80002808:	9081                	srli	s1,s1,0x20
    8000280a:	048a                	slli	s1,s1,0x2
    8000280c:	94aa                	add	s1,s1,a0
    8000280e:	0504a903          	lw	s2,80(s1)
    80002812:	06091e63          	bnez	s2,8000288e <bmap+0xa2>
      addr = balloc(ip->dev);
    80002816:	4108                	lw	a0,0(a0)
    80002818:	00000097          	auipc	ra,0x0
    8000281c:	e9c080e7          	jalr	-356(ra) # 800026b4 <balloc>
    80002820:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002824:	06090563          	beqz	s2,8000288e <bmap+0xa2>
        return 0;
      ip->addrs[bn] = addr;
    80002828:	0524a823          	sw	s2,80(s1)
    8000282c:	a08d                	j	8000288e <bmap+0xa2>
    }
    return addr;
  }
  bn -= NDIRECT;
    8000282e:	ff45849b          	addiw	s1,a1,-12
    80002832:	0004871b          	sext.w	a4,s1

  if(bn < NINDIRECT){
    80002836:	0ff00793          	li	a5,255
    8000283a:	08e7e563          	bltu	a5,a4,800028c4 <bmap+0xd8>
    // Load indirect block, allocating if necessary.
    if((addr = ip->addrs[NDIRECT]) == 0){
    8000283e:	08052903          	lw	s2,128(a0)
    80002842:	00091d63          	bnez	s2,8000285c <bmap+0x70>
      addr = balloc(ip->dev);
    80002846:	4108                	lw	a0,0(a0)
    80002848:	00000097          	auipc	ra,0x0
    8000284c:	e6c080e7          	jalr	-404(ra) # 800026b4 <balloc>
    80002850:	0005091b          	sext.w	s2,a0
      if(addr == 0)
    80002854:	02090d63          	beqz	s2,8000288e <bmap+0xa2>
        return 0;
      ip->addrs[NDIRECT] = addr;
    80002858:	0929a023          	sw	s2,128(s3)
    }
    bp = bread(ip->dev, addr);
    8000285c:	85ca                	mv	a1,s2
    8000285e:	0009a503          	lw	a0,0(s3)
    80002862:	00000097          	auipc	ra,0x0
    80002866:	b90080e7          	jalr	-1136(ra) # 800023f2 <bread>
    8000286a:	8a2a                	mv	s4,a0
    a = (uint*)bp->data;
    8000286c:	05850793          	addi	a5,a0,88
    if((addr = a[bn]) == 0){
    80002870:	02049593          	slli	a1,s1,0x20
    80002874:	9181                	srli	a1,a1,0x20
    80002876:	058a                	slli	a1,a1,0x2
    80002878:	00b784b3          	add	s1,a5,a1
    8000287c:	0004a903          	lw	s2,0(s1)
    80002880:	02090063          	beqz	s2,800028a0 <bmap+0xb4>
      if(addr){
        a[bn] = addr;
        log_write(bp);
      }
    }
    brelse(bp);
    80002884:	8552                	mv	a0,s4
    80002886:	00000097          	auipc	ra,0x0
    8000288a:	c9c080e7          	jalr	-868(ra) # 80002522 <brelse>
    return addr;
  }

  panic("bmap: out of range");
}
    8000288e:	854a                	mv	a0,s2
    80002890:	70a2                	ld	ra,40(sp)
    80002892:	7402                	ld	s0,32(sp)
    80002894:	64e2                	ld	s1,24(sp)
    80002896:	6942                	ld	s2,16(sp)
    80002898:	69a2                	ld	s3,8(sp)
    8000289a:	6a02                	ld	s4,0(sp)
    8000289c:	6145                	addi	sp,sp,48
    8000289e:	8082                	ret
      addr = balloc(ip->dev);
    800028a0:	0009a503          	lw	a0,0(s3)
    800028a4:	00000097          	auipc	ra,0x0
    800028a8:	e10080e7          	jalr	-496(ra) # 800026b4 <balloc>
    800028ac:	0005091b          	sext.w	s2,a0
      if(addr){
    800028b0:	fc090ae3          	beqz	s2,80002884 <bmap+0x98>
        a[bn] = addr;
    800028b4:	0124a023          	sw	s2,0(s1)
        log_write(bp);
    800028b8:	8552                	mv	a0,s4
    800028ba:	00001097          	auipc	ra,0x1
    800028be:	eec080e7          	jalr	-276(ra) # 800037a6 <log_write>
    800028c2:	b7c9                	j	80002884 <bmap+0x98>
  panic("bmap: out of range");
    800028c4:	00006517          	auipc	a0,0x6
    800028c8:	c9450513          	addi	a0,a0,-876 # 80008558 <syscalls+0x128>
    800028cc:	00003097          	auipc	ra,0x3
    800028d0:	5d6080e7          	jalr	1494(ra) # 80005ea2 <panic>

00000000800028d4 <iget>:
{
    800028d4:	7179                	addi	sp,sp,-48
    800028d6:	f406                	sd	ra,40(sp)
    800028d8:	f022                	sd	s0,32(sp)
    800028da:	ec26                	sd	s1,24(sp)
    800028dc:	e84a                	sd	s2,16(sp)
    800028de:	e44e                	sd	s3,8(sp)
    800028e0:	e052                	sd	s4,0(sp)
    800028e2:	1800                	addi	s0,sp,48
    800028e4:	89aa                	mv	s3,a0
    800028e6:	8a2e                	mv	s4,a1
  acquire(&itable.lock);
    800028e8:	00022517          	auipc	a0,0x22
    800028ec:	5d050513          	addi	a0,a0,1488 # 80024eb8 <itable>
    800028f0:	00004097          	auipc	ra,0x4
    800028f4:	afc080e7          	jalr	-1284(ra) # 800063ec <acquire>
  empty = 0;
    800028f8:	4901                	li	s2,0
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    800028fa:	00022497          	auipc	s1,0x22
    800028fe:	5d648493          	addi	s1,s1,1494 # 80024ed0 <itable+0x18>
    80002902:	00024697          	auipc	a3,0x24
    80002906:	05e68693          	addi	a3,a3,94 # 80026960 <log>
    8000290a:	a039                	j	80002918 <iget+0x44>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    8000290c:	02090b63          	beqz	s2,80002942 <iget+0x6e>
  for(ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++){
    80002910:	08848493          	addi	s1,s1,136
    80002914:	02d48a63          	beq	s1,a3,80002948 <iget+0x74>
    if(ip->ref > 0 && ip->dev == dev && ip->inum == inum){
    80002918:	449c                	lw	a5,8(s1)
    8000291a:	fef059e3          	blez	a5,8000290c <iget+0x38>
    8000291e:	4098                	lw	a4,0(s1)
    80002920:	ff3716e3          	bne	a4,s3,8000290c <iget+0x38>
    80002924:	40d8                	lw	a4,4(s1)
    80002926:	ff4713e3          	bne	a4,s4,8000290c <iget+0x38>
      ip->ref++;
    8000292a:	2785                	addiw	a5,a5,1
    8000292c:	c49c                	sw	a5,8(s1)
      release(&itable.lock);
    8000292e:	00022517          	auipc	a0,0x22
    80002932:	58a50513          	addi	a0,a0,1418 # 80024eb8 <itable>
    80002936:	00004097          	auipc	ra,0x4
    8000293a:	b6a080e7          	jalr	-1174(ra) # 800064a0 <release>
      return ip;
    8000293e:	8926                	mv	s2,s1
    80002940:	a03d                	j	8000296e <iget+0x9a>
    if(empty == 0 && ip->ref == 0)    // Remember empty slot.
    80002942:	f7f9                	bnez	a5,80002910 <iget+0x3c>
    80002944:	8926                	mv	s2,s1
    80002946:	b7e9                	j	80002910 <iget+0x3c>
  if(empty == 0)
    80002948:	02090c63          	beqz	s2,80002980 <iget+0xac>
  ip->dev = dev;
    8000294c:	01392023          	sw	s3,0(s2)
  ip->inum = inum;
    80002950:	01492223          	sw	s4,4(s2)
  ip->ref = 1;
    80002954:	4785                	li	a5,1
    80002956:	00f92423          	sw	a5,8(s2)
  ip->valid = 0;
    8000295a:	04092023          	sw	zero,64(s2)
  release(&itable.lock);
    8000295e:	00022517          	auipc	a0,0x22
    80002962:	55a50513          	addi	a0,a0,1370 # 80024eb8 <itable>
    80002966:	00004097          	auipc	ra,0x4
    8000296a:	b3a080e7          	jalr	-1222(ra) # 800064a0 <release>
}
    8000296e:	854a                	mv	a0,s2
    80002970:	70a2                	ld	ra,40(sp)
    80002972:	7402                	ld	s0,32(sp)
    80002974:	64e2                	ld	s1,24(sp)
    80002976:	6942                	ld	s2,16(sp)
    80002978:	69a2                	ld	s3,8(sp)
    8000297a:	6a02                	ld	s4,0(sp)
    8000297c:	6145                	addi	sp,sp,48
    8000297e:	8082                	ret
    panic("iget: no inodes");
    80002980:	00006517          	auipc	a0,0x6
    80002984:	bf050513          	addi	a0,a0,-1040 # 80008570 <syscalls+0x140>
    80002988:	00003097          	auipc	ra,0x3
    8000298c:	51a080e7          	jalr	1306(ra) # 80005ea2 <panic>

0000000080002990 <fsinit>:
fsinit(int dev) {
    80002990:	7179                	addi	sp,sp,-48
    80002992:	f406                	sd	ra,40(sp)
    80002994:	f022                	sd	s0,32(sp)
    80002996:	ec26                	sd	s1,24(sp)
    80002998:	e84a                	sd	s2,16(sp)
    8000299a:	e44e                	sd	s3,8(sp)
    8000299c:	1800                	addi	s0,sp,48
    8000299e:	892a                	mv	s2,a0
  bp = bread(dev, 1);
    800029a0:	4585                	li	a1,1
    800029a2:	00000097          	auipc	ra,0x0
    800029a6:	a50080e7          	jalr	-1456(ra) # 800023f2 <bread>
    800029aa:	84aa                	mv	s1,a0
  memmove(sb, bp->data, sizeof(*sb));
    800029ac:	00022997          	auipc	s3,0x22
    800029b0:	4ec98993          	addi	s3,s3,1260 # 80024e98 <sb>
    800029b4:	02000613          	li	a2,32
    800029b8:	05850593          	addi	a1,a0,88
    800029bc:	854e                	mv	a0,s3
    800029be:	ffffe097          	auipc	ra,0xffffe
    800029c2:	81a080e7          	jalr	-2022(ra) # 800001d8 <memmove>
  brelse(bp);
    800029c6:	8526                	mv	a0,s1
    800029c8:	00000097          	auipc	ra,0x0
    800029cc:	b5a080e7          	jalr	-1190(ra) # 80002522 <brelse>
  if(sb.magic != FSMAGIC)
    800029d0:	0009a703          	lw	a4,0(s3)
    800029d4:	102037b7          	lui	a5,0x10203
    800029d8:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800029dc:	02f71263          	bne	a4,a5,80002a00 <fsinit+0x70>
  initlog(dev, &sb);
    800029e0:	00022597          	auipc	a1,0x22
    800029e4:	4b858593          	addi	a1,a1,1208 # 80024e98 <sb>
    800029e8:	854a                	mv	a0,s2
    800029ea:	00001097          	auipc	ra,0x1
    800029ee:	b40080e7          	jalr	-1216(ra) # 8000352a <initlog>
}
    800029f2:	70a2                	ld	ra,40(sp)
    800029f4:	7402                	ld	s0,32(sp)
    800029f6:	64e2                	ld	s1,24(sp)
    800029f8:	6942                	ld	s2,16(sp)
    800029fa:	69a2                	ld	s3,8(sp)
    800029fc:	6145                	addi	sp,sp,48
    800029fe:	8082                	ret
    panic("invalid file system");
    80002a00:	00006517          	auipc	a0,0x6
    80002a04:	b8050513          	addi	a0,a0,-1152 # 80008580 <syscalls+0x150>
    80002a08:	00003097          	auipc	ra,0x3
    80002a0c:	49a080e7          	jalr	1178(ra) # 80005ea2 <panic>

0000000080002a10 <iinit>:
{
    80002a10:	7179                	addi	sp,sp,-48
    80002a12:	f406                	sd	ra,40(sp)
    80002a14:	f022                	sd	s0,32(sp)
    80002a16:	ec26                	sd	s1,24(sp)
    80002a18:	e84a                	sd	s2,16(sp)
    80002a1a:	e44e                	sd	s3,8(sp)
    80002a1c:	1800                	addi	s0,sp,48
  initlock(&itable.lock, "itable");
    80002a1e:	00006597          	auipc	a1,0x6
    80002a22:	b7a58593          	addi	a1,a1,-1158 # 80008598 <syscalls+0x168>
    80002a26:	00022517          	auipc	a0,0x22
    80002a2a:	49250513          	addi	a0,a0,1170 # 80024eb8 <itable>
    80002a2e:	00004097          	auipc	ra,0x4
    80002a32:	92e080e7          	jalr	-1746(ra) # 8000635c <initlock>
  for(i = 0; i < NINODE; i++) {
    80002a36:	00022497          	auipc	s1,0x22
    80002a3a:	4aa48493          	addi	s1,s1,1194 # 80024ee0 <itable+0x28>
    80002a3e:	00024997          	auipc	s3,0x24
    80002a42:	f3298993          	addi	s3,s3,-206 # 80026970 <log+0x10>
    initsleeplock(&itable.inode[i].lock, "inode");
    80002a46:	00006917          	auipc	s2,0x6
    80002a4a:	b5a90913          	addi	s2,s2,-1190 # 800085a0 <syscalls+0x170>
    80002a4e:	85ca                	mv	a1,s2
    80002a50:	8526                	mv	a0,s1
    80002a52:	00001097          	auipc	ra,0x1
    80002a56:	e3a080e7          	jalr	-454(ra) # 8000388c <initsleeplock>
  for(i = 0; i < NINODE; i++) {
    80002a5a:	08848493          	addi	s1,s1,136
    80002a5e:	ff3498e3          	bne	s1,s3,80002a4e <iinit+0x3e>
}
    80002a62:	70a2                	ld	ra,40(sp)
    80002a64:	7402                	ld	s0,32(sp)
    80002a66:	64e2                	ld	s1,24(sp)
    80002a68:	6942                	ld	s2,16(sp)
    80002a6a:	69a2                	ld	s3,8(sp)
    80002a6c:	6145                	addi	sp,sp,48
    80002a6e:	8082                	ret

0000000080002a70 <ialloc>:
{
    80002a70:	715d                	addi	sp,sp,-80
    80002a72:	e486                	sd	ra,72(sp)
    80002a74:	e0a2                	sd	s0,64(sp)
    80002a76:	fc26                	sd	s1,56(sp)
    80002a78:	f84a                	sd	s2,48(sp)
    80002a7a:	f44e                	sd	s3,40(sp)
    80002a7c:	f052                	sd	s4,32(sp)
    80002a7e:	ec56                	sd	s5,24(sp)
    80002a80:	e85a                	sd	s6,16(sp)
    80002a82:	e45e                	sd	s7,8(sp)
    80002a84:	0880                	addi	s0,sp,80
  for(inum = 1; inum < sb.ninodes; inum++){
    80002a86:	00022717          	auipc	a4,0x22
    80002a8a:	41e72703          	lw	a4,1054(a4) # 80024ea4 <sb+0xc>
    80002a8e:	4785                	li	a5,1
    80002a90:	04e7fa63          	bgeu	a5,a4,80002ae4 <ialloc+0x74>
    80002a94:	8aaa                	mv	s5,a0
    80002a96:	8bae                	mv	s7,a1
    80002a98:	4485                	li	s1,1
    bp = bread(dev, IBLOCK(inum, sb));
    80002a9a:	00022a17          	auipc	s4,0x22
    80002a9e:	3fea0a13          	addi	s4,s4,1022 # 80024e98 <sb>
    80002aa2:	00048b1b          	sext.w	s6,s1
    80002aa6:	0044d593          	srli	a1,s1,0x4
    80002aaa:	018a2783          	lw	a5,24(s4)
    80002aae:	9dbd                	addw	a1,a1,a5
    80002ab0:	8556                	mv	a0,s5
    80002ab2:	00000097          	auipc	ra,0x0
    80002ab6:	940080e7          	jalr	-1728(ra) # 800023f2 <bread>
    80002aba:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + inum%IPB;
    80002abc:	05850993          	addi	s3,a0,88
    80002ac0:	00f4f793          	andi	a5,s1,15
    80002ac4:	079a                	slli	a5,a5,0x6
    80002ac6:	99be                	add	s3,s3,a5
    if(dip->type == 0){  // a free inode
    80002ac8:	00099783          	lh	a5,0(s3)
    80002acc:	c3a1                	beqz	a5,80002b0c <ialloc+0x9c>
    brelse(bp);
    80002ace:	00000097          	auipc	ra,0x0
    80002ad2:	a54080e7          	jalr	-1452(ra) # 80002522 <brelse>
  for(inum = 1; inum < sb.ninodes; inum++){
    80002ad6:	0485                	addi	s1,s1,1
    80002ad8:	00ca2703          	lw	a4,12(s4)
    80002adc:	0004879b          	sext.w	a5,s1
    80002ae0:	fce7e1e3          	bltu	a5,a4,80002aa2 <ialloc+0x32>
  printf("ialloc: no inodes\n");
    80002ae4:	00006517          	auipc	a0,0x6
    80002ae8:	ac450513          	addi	a0,a0,-1340 # 800085a8 <syscalls+0x178>
    80002aec:	00003097          	auipc	ra,0x3
    80002af0:	400080e7          	jalr	1024(ra) # 80005eec <printf>
  return 0;
    80002af4:	4501                	li	a0,0
}
    80002af6:	60a6                	ld	ra,72(sp)
    80002af8:	6406                	ld	s0,64(sp)
    80002afa:	74e2                	ld	s1,56(sp)
    80002afc:	7942                	ld	s2,48(sp)
    80002afe:	79a2                	ld	s3,40(sp)
    80002b00:	7a02                	ld	s4,32(sp)
    80002b02:	6ae2                	ld	s5,24(sp)
    80002b04:	6b42                	ld	s6,16(sp)
    80002b06:	6ba2                	ld	s7,8(sp)
    80002b08:	6161                	addi	sp,sp,80
    80002b0a:	8082                	ret
      memset(dip, 0, sizeof(*dip));
    80002b0c:	04000613          	li	a2,64
    80002b10:	4581                	li	a1,0
    80002b12:	854e                	mv	a0,s3
    80002b14:	ffffd097          	auipc	ra,0xffffd
    80002b18:	664080e7          	jalr	1636(ra) # 80000178 <memset>
      dip->type = type;
    80002b1c:	01799023          	sh	s7,0(s3)
      log_write(bp);   // mark it allocated on the disk
    80002b20:	854a                	mv	a0,s2
    80002b22:	00001097          	auipc	ra,0x1
    80002b26:	c84080e7          	jalr	-892(ra) # 800037a6 <log_write>
      brelse(bp);
    80002b2a:	854a                	mv	a0,s2
    80002b2c:	00000097          	auipc	ra,0x0
    80002b30:	9f6080e7          	jalr	-1546(ra) # 80002522 <brelse>
      return iget(dev, inum);
    80002b34:	85da                	mv	a1,s6
    80002b36:	8556                	mv	a0,s5
    80002b38:	00000097          	auipc	ra,0x0
    80002b3c:	d9c080e7          	jalr	-612(ra) # 800028d4 <iget>
    80002b40:	bf5d                	j	80002af6 <ialloc+0x86>

0000000080002b42 <iupdate>:
{
    80002b42:	1101                	addi	sp,sp,-32
    80002b44:	ec06                	sd	ra,24(sp)
    80002b46:	e822                	sd	s0,16(sp)
    80002b48:	e426                	sd	s1,8(sp)
    80002b4a:	e04a                	sd	s2,0(sp)
    80002b4c:	1000                	addi	s0,sp,32
    80002b4e:	84aa                	mv	s1,a0
  bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002b50:	415c                	lw	a5,4(a0)
    80002b52:	0047d79b          	srliw	a5,a5,0x4
    80002b56:	00022597          	auipc	a1,0x22
    80002b5a:	35a5a583          	lw	a1,858(a1) # 80024eb0 <sb+0x18>
    80002b5e:	9dbd                	addw	a1,a1,a5
    80002b60:	4108                	lw	a0,0(a0)
    80002b62:	00000097          	auipc	ra,0x0
    80002b66:	890080e7          	jalr	-1904(ra) # 800023f2 <bread>
    80002b6a:	892a                	mv	s2,a0
  dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002b6c:	05850793          	addi	a5,a0,88
    80002b70:	40c8                	lw	a0,4(s1)
    80002b72:	893d                	andi	a0,a0,15
    80002b74:	051a                	slli	a0,a0,0x6
    80002b76:	953e                	add	a0,a0,a5
  dip->type = ip->type;
    80002b78:	04449703          	lh	a4,68(s1)
    80002b7c:	00e51023          	sh	a4,0(a0)
  dip->major = ip->major;
    80002b80:	04649703          	lh	a4,70(s1)
    80002b84:	00e51123          	sh	a4,2(a0)
  dip->minor = ip->minor;
    80002b88:	04849703          	lh	a4,72(s1)
    80002b8c:	00e51223          	sh	a4,4(a0)
  dip->nlink = ip->nlink;
    80002b90:	04a49703          	lh	a4,74(s1)
    80002b94:	00e51323          	sh	a4,6(a0)
  dip->size = ip->size;
    80002b98:	44f8                	lw	a4,76(s1)
    80002b9a:	c518                	sw	a4,8(a0)
  memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002b9c:	03400613          	li	a2,52
    80002ba0:	05048593          	addi	a1,s1,80
    80002ba4:	0531                	addi	a0,a0,12
    80002ba6:	ffffd097          	auipc	ra,0xffffd
    80002baa:	632080e7          	jalr	1586(ra) # 800001d8 <memmove>
  log_write(bp);
    80002bae:	854a                	mv	a0,s2
    80002bb0:	00001097          	auipc	ra,0x1
    80002bb4:	bf6080e7          	jalr	-1034(ra) # 800037a6 <log_write>
  brelse(bp);
    80002bb8:	854a                	mv	a0,s2
    80002bba:	00000097          	auipc	ra,0x0
    80002bbe:	968080e7          	jalr	-1688(ra) # 80002522 <brelse>
}
    80002bc2:	60e2                	ld	ra,24(sp)
    80002bc4:	6442                	ld	s0,16(sp)
    80002bc6:	64a2                	ld	s1,8(sp)
    80002bc8:	6902                	ld	s2,0(sp)
    80002bca:	6105                	addi	sp,sp,32
    80002bcc:	8082                	ret

0000000080002bce <idup>:
{
    80002bce:	1101                	addi	sp,sp,-32
    80002bd0:	ec06                	sd	ra,24(sp)
    80002bd2:	e822                	sd	s0,16(sp)
    80002bd4:	e426                	sd	s1,8(sp)
    80002bd6:	1000                	addi	s0,sp,32
    80002bd8:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002bda:	00022517          	auipc	a0,0x22
    80002bde:	2de50513          	addi	a0,a0,734 # 80024eb8 <itable>
    80002be2:	00004097          	auipc	ra,0x4
    80002be6:	80a080e7          	jalr	-2038(ra) # 800063ec <acquire>
  ip->ref++;
    80002bea:	449c                	lw	a5,8(s1)
    80002bec:	2785                	addiw	a5,a5,1
    80002bee:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002bf0:	00022517          	auipc	a0,0x22
    80002bf4:	2c850513          	addi	a0,a0,712 # 80024eb8 <itable>
    80002bf8:	00004097          	auipc	ra,0x4
    80002bfc:	8a8080e7          	jalr	-1880(ra) # 800064a0 <release>
}
    80002c00:	8526                	mv	a0,s1
    80002c02:	60e2                	ld	ra,24(sp)
    80002c04:	6442                	ld	s0,16(sp)
    80002c06:	64a2                	ld	s1,8(sp)
    80002c08:	6105                	addi	sp,sp,32
    80002c0a:	8082                	ret

0000000080002c0c <ilock>:
{
    80002c0c:	1101                	addi	sp,sp,-32
    80002c0e:	ec06                	sd	ra,24(sp)
    80002c10:	e822                	sd	s0,16(sp)
    80002c12:	e426                	sd	s1,8(sp)
    80002c14:	e04a                	sd	s2,0(sp)
    80002c16:	1000                	addi	s0,sp,32
  if(ip == 0 || ip->ref < 1)
    80002c18:	c115                	beqz	a0,80002c3c <ilock+0x30>
    80002c1a:	84aa                	mv	s1,a0
    80002c1c:	451c                	lw	a5,8(a0)
    80002c1e:	00f05f63          	blez	a5,80002c3c <ilock+0x30>
  acquiresleep(&ip->lock);
    80002c22:	0541                	addi	a0,a0,16
    80002c24:	00001097          	auipc	ra,0x1
    80002c28:	ca2080e7          	jalr	-862(ra) # 800038c6 <acquiresleep>
  if(ip->valid == 0){
    80002c2c:	40bc                	lw	a5,64(s1)
    80002c2e:	cf99                	beqz	a5,80002c4c <ilock+0x40>
}
    80002c30:	60e2                	ld	ra,24(sp)
    80002c32:	6442                	ld	s0,16(sp)
    80002c34:	64a2                	ld	s1,8(sp)
    80002c36:	6902                	ld	s2,0(sp)
    80002c38:	6105                	addi	sp,sp,32
    80002c3a:	8082                	ret
    panic("ilock");
    80002c3c:	00006517          	auipc	a0,0x6
    80002c40:	98450513          	addi	a0,a0,-1660 # 800085c0 <syscalls+0x190>
    80002c44:	00003097          	auipc	ra,0x3
    80002c48:	25e080e7          	jalr	606(ra) # 80005ea2 <panic>
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002c4c:	40dc                	lw	a5,4(s1)
    80002c4e:	0047d79b          	srliw	a5,a5,0x4
    80002c52:	00022597          	auipc	a1,0x22
    80002c56:	25e5a583          	lw	a1,606(a1) # 80024eb0 <sb+0x18>
    80002c5a:	9dbd                	addw	a1,a1,a5
    80002c5c:	4088                	lw	a0,0(s1)
    80002c5e:	fffff097          	auipc	ra,0xfffff
    80002c62:	794080e7          	jalr	1940(ra) # 800023f2 <bread>
    80002c66:	892a                	mv	s2,a0
    dip = (struct dinode*)bp->data + ip->inum%IPB;
    80002c68:	05850593          	addi	a1,a0,88
    80002c6c:	40dc                	lw	a5,4(s1)
    80002c6e:	8bbd                	andi	a5,a5,15
    80002c70:	079a                	slli	a5,a5,0x6
    80002c72:	95be                	add	a1,a1,a5
    ip->type = dip->type;
    80002c74:	00059783          	lh	a5,0(a1)
    80002c78:	04f49223          	sh	a5,68(s1)
    ip->major = dip->major;
    80002c7c:	00259783          	lh	a5,2(a1)
    80002c80:	04f49323          	sh	a5,70(s1)
    ip->minor = dip->minor;
    80002c84:	00459783          	lh	a5,4(a1)
    80002c88:	04f49423          	sh	a5,72(s1)
    ip->nlink = dip->nlink;
    80002c8c:	00659783          	lh	a5,6(a1)
    80002c90:	04f49523          	sh	a5,74(s1)
    ip->size = dip->size;
    80002c94:	459c                	lw	a5,8(a1)
    80002c96:	c4fc                	sw	a5,76(s1)
    memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002c98:	03400613          	li	a2,52
    80002c9c:	05b1                	addi	a1,a1,12
    80002c9e:	05048513          	addi	a0,s1,80
    80002ca2:	ffffd097          	auipc	ra,0xffffd
    80002ca6:	536080e7          	jalr	1334(ra) # 800001d8 <memmove>
    brelse(bp);
    80002caa:	854a                	mv	a0,s2
    80002cac:	00000097          	auipc	ra,0x0
    80002cb0:	876080e7          	jalr	-1930(ra) # 80002522 <brelse>
    ip->valid = 1;
    80002cb4:	4785                	li	a5,1
    80002cb6:	c0bc                	sw	a5,64(s1)
    if(ip->type == 0)
    80002cb8:	04449783          	lh	a5,68(s1)
    80002cbc:	fbb5                	bnez	a5,80002c30 <ilock+0x24>
      panic("ilock: no type");
    80002cbe:	00006517          	auipc	a0,0x6
    80002cc2:	90a50513          	addi	a0,a0,-1782 # 800085c8 <syscalls+0x198>
    80002cc6:	00003097          	auipc	ra,0x3
    80002cca:	1dc080e7          	jalr	476(ra) # 80005ea2 <panic>

0000000080002cce <iunlock>:
{
    80002cce:	1101                	addi	sp,sp,-32
    80002cd0:	ec06                	sd	ra,24(sp)
    80002cd2:	e822                	sd	s0,16(sp)
    80002cd4:	e426                	sd	s1,8(sp)
    80002cd6:	e04a                	sd	s2,0(sp)
    80002cd8:	1000                	addi	s0,sp,32
  if(ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002cda:	c905                	beqz	a0,80002d0a <iunlock+0x3c>
    80002cdc:	84aa                	mv	s1,a0
    80002cde:	01050913          	addi	s2,a0,16
    80002ce2:	854a                	mv	a0,s2
    80002ce4:	00001097          	auipc	ra,0x1
    80002ce8:	c7c080e7          	jalr	-900(ra) # 80003960 <holdingsleep>
    80002cec:	cd19                	beqz	a0,80002d0a <iunlock+0x3c>
    80002cee:	449c                	lw	a5,8(s1)
    80002cf0:	00f05d63          	blez	a5,80002d0a <iunlock+0x3c>
  releasesleep(&ip->lock);
    80002cf4:	854a                	mv	a0,s2
    80002cf6:	00001097          	auipc	ra,0x1
    80002cfa:	c26080e7          	jalr	-986(ra) # 8000391c <releasesleep>
}
    80002cfe:	60e2                	ld	ra,24(sp)
    80002d00:	6442                	ld	s0,16(sp)
    80002d02:	64a2                	ld	s1,8(sp)
    80002d04:	6902                	ld	s2,0(sp)
    80002d06:	6105                	addi	sp,sp,32
    80002d08:	8082                	ret
    panic("iunlock");
    80002d0a:	00006517          	auipc	a0,0x6
    80002d0e:	8ce50513          	addi	a0,a0,-1842 # 800085d8 <syscalls+0x1a8>
    80002d12:	00003097          	auipc	ra,0x3
    80002d16:	190080e7          	jalr	400(ra) # 80005ea2 <panic>

0000000080002d1a <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void
itrunc(struct inode *ip)
{
    80002d1a:	7179                	addi	sp,sp,-48
    80002d1c:	f406                	sd	ra,40(sp)
    80002d1e:	f022                	sd	s0,32(sp)
    80002d20:	ec26                	sd	s1,24(sp)
    80002d22:	e84a                	sd	s2,16(sp)
    80002d24:	e44e                	sd	s3,8(sp)
    80002d26:	e052                	sd	s4,0(sp)
    80002d28:	1800                	addi	s0,sp,48
    80002d2a:	89aa                	mv	s3,a0
  int i, j;
  struct buf *bp;
  uint *a;

  for(i = 0; i < NDIRECT; i++){
    80002d2c:	05050493          	addi	s1,a0,80
    80002d30:	08050913          	addi	s2,a0,128
    80002d34:	a021                	j	80002d3c <itrunc+0x22>
    80002d36:	0491                	addi	s1,s1,4
    80002d38:	01248d63          	beq	s1,s2,80002d52 <itrunc+0x38>
    if(ip->addrs[i]){
    80002d3c:	408c                	lw	a1,0(s1)
    80002d3e:	dde5                	beqz	a1,80002d36 <itrunc+0x1c>
      bfree(ip->dev, ip->addrs[i]);
    80002d40:	0009a503          	lw	a0,0(s3)
    80002d44:	00000097          	auipc	ra,0x0
    80002d48:	8f4080e7          	jalr	-1804(ra) # 80002638 <bfree>
      ip->addrs[i] = 0;
    80002d4c:	0004a023          	sw	zero,0(s1)
    80002d50:	b7dd                	j	80002d36 <itrunc+0x1c>
    }
  }

  if(ip->addrs[NDIRECT]){
    80002d52:	0809a583          	lw	a1,128(s3)
    80002d56:	e185                	bnez	a1,80002d76 <itrunc+0x5c>
    brelse(bp);
    bfree(ip->dev, ip->addrs[NDIRECT]);
    ip->addrs[NDIRECT] = 0;
  }

  ip->size = 0;
    80002d58:	0409a623          	sw	zero,76(s3)
  iupdate(ip);
    80002d5c:	854e                	mv	a0,s3
    80002d5e:	00000097          	auipc	ra,0x0
    80002d62:	de4080e7          	jalr	-540(ra) # 80002b42 <iupdate>
}
    80002d66:	70a2                	ld	ra,40(sp)
    80002d68:	7402                	ld	s0,32(sp)
    80002d6a:	64e2                	ld	s1,24(sp)
    80002d6c:	6942                	ld	s2,16(sp)
    80002d6e:	69a2                	ld	s3,8(sp)
    80002d70:	6a02                	ld	s4,0(sp)
    80002d72:	6145                	addi	sp,sp,48
    80002d74:	8082                	ret
    bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002d76:	0009a503          	lw	a0,0(s3)
    80002d7a:	fffff097          	auipc	ra,0xfffff
    80002d7e:	678080e7          	jalr	1656(ra) # 800023f2 <bread>
    80002d82:	8a2a                	mv	s4,a0
    for(j = 0; j < NINDIRECT; j++){
    80002d84:	05850493          	addi	s1,a0,88
    80002d88:	45850913          	addi	s2,a0,1112
    80002d8c:	a811                	j	80002da0 <itrunc+0x86>
        bfree(ip->dev, a[j]);
    80002d8e:	0009a503          	lw	a0,0(s3)
    80002d92:	00000097          	auipc	ra,0x0
    80002d96:	8a6080e7          	jalr	-1882(ra) # 80002638 <bfree>
    for(j = 0; j < NINDIRECT; j++){
    80002d9a:	0491                	addi	s1,s1,4
    80002d9c:	01248563          	beq	s1,s2,80002da6 <itrunc+0x8c>
      if(a[j])
    80002da0:	408c                	lw	a1,0(s1)
    80002da2:	dde5                	beqz	a1,80002d9a <itrunc+0x80>
    80002da4:	b7ed                	j	80002d8e <itrunc+0x74>
    brelse(bp);
    80002da6:	8552                	mv	a0,s4
    80002da8:	fffff097          	auipc	ra,0xfffff
    80002dac:	77a080e7          	jalr	1914(ra) # 80002522 <brelse>
    bfree(ip->dev, ip->addrs[NDIRECT]);
    80002db0:	0809a583          	lw	a1,128(s3)
    80002db4:	0009a503          	lw	a0,0(s3)
    80002db8:	00000097          	auipc	ra,0x0
    80002dbc:	880080e7          	jalr	-1920(ra) # 80002638 <bfree>
    ip->addrs[NDIRECT] = 0;
    80002dc0:	0809a023          	sw	zero,128(s3)
    80002dc4:	bf51                	j	80002d58 <itrunc+0x3e>

0000000080002dc6 <iput>:
{
    80002dc6:	1101                	addi	sp,sp,-32
    80002dc8:	ec06                	sd	ra,24(sp)
    80002dca:	e822                	sd	s0,16(sp)
    80002dcc:	e426                	sd	s1,8(sp)
    80002dce:	e04a                	sd	s2,0(sp)
    80002dd0:	1000                	addi	s0,sp,32
    80002dd2:	84aa                	mv	s1,a0
  acquire(&itable.lock);
    80002dd4:	00022517          	auipc	a0,0x22
    80002dd8:	0e450513          	addi	a0,a0,228 # 80024eb8 <itable>
    80002ddc:	00003097          	auipc	ra,0x3
    80002de0:	610080e7          	jalr	1552(ra) # 800063ec <acquire>
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002de4:	4498                	lw	a4,8(s1)
    80002de6:	4785                	li	a5,1
    80002de8:	02f70363          	beq	a4,a5,80002e0e <iput+0x48>
  ip->ref--;
    80002dec:	449c                	lw	a5,8(s1)
    80002dee:	37fd                	addiw	a5,a5,-1
    80002df0:	c49c                	sw	a5,8(s1)
  release(&itable.lock);
    80002df2:	00022517          	auipc	a0,0x22
    80002df6:	0c650513          	addi	a0,a0,198 # 80024eb8 <itable>
    80002dfa:	00003097          	auipc	ra,0x3
    80002dfe:	6a6080e7          	jalr	1702(ra) # 800064a0 <release>
}
    80002e02:	60e2                	ld	ra,24(sp)
    80002e04:	6442                	ld	s0,16(sp)
    80002e06:	64a2                	ld	s1,8(sp)
    80002e08:	6902                	ld	s2,0(sp)
    80002e0a:	6105                	addi	sp,sp,32
    80002e0c:	8082                	ret
  if(ip->ref == 1 && ip->valid && ip->nlink == 0){
    80002e0e:	40bc                	lw	a5,64(s1)
    80002e10:	dff1                	beqz	a5,80002dec <iput+0x26>
    80002e12:	04a49783          	lh	a5,74(s1)
    80002e16:	fbf9                	bnez	a5,80002dec <iput+0x26>
    acquiresleep(&ip->lock);
    80002e18:	01048913          	addi	s2,s1,16
    80002e1c:	854a                	mv	a0,s2
    80002e1e:	00001097          	auipc	ra,0x1
    80002e22:	aa8080e7          	jalr	-1368(ra) # 800038c6 <acquiresleep>
    release(&itable.lock);
    80002e26:	00022517          	auipc	a0,0x22
    80002e2a:	09250513          	addi	a0,a0,146 # 80024eb8 <itable>
    80002e2e:	00003097          	auipc	ra,0x3
    80002e32:	672080e7          	jalr	1650(ra) # 800064a0 <release>
    itrunc(ip);
    80002e36:	8526                	mv	a0,s1
    80002e38:	00000097          	auipc	ra,0x0
    80002e3c:	ee2080e7          	jalr	-286(ra) # 80002d1a <itrunc>
    ip->type = 0;
    80002e40:	04049223          	sh	zero,68(s1)
    iupdate(ip);
    80002e44:	8526                	mv	a0,s1
    80002e46:	00000097          	auipc	ra,0x0
    80002e4a:	cfc080e7          	jalr	-772(ra) # 80002b42 <iupdate>
    ip->valid = 0;
    80002e4e:	0404a023          	sw	zero,64(s1)
    releasesleep(&ip->lock);
    80002e52:	854a                	mv	a0,s2
    80002e54:	00001097          	auipc	ra,0x1
    80002e58:	ac8080e7          	jalr	-1336(ra) # 8000391c <releasesleep>
    acquire(&itable.lock);
    80002e5c:	00022517          	auipc	a0,0x22
    80002e60:	05c50513          	addi	a0,a0,92 # 80024eb8 <itable>
    80002e64:	00003097          	auipc	ra,0x3
    80002e68:	588080e7          	jalr	1416(ra) # 800063ec <acquire>
    80002e6c:	b741                	j	80002dec <iput+0x26>

0000000080002e6e <iunlockput>:
{
    80002e6e:	1101                	addi	sp,sp,-32
    80002e70:	ec06                	sd	ra,24(sp)
    80002e72:	e822                	sd	s0,16(sp)
    80002e74:	e426                	sd	s1,8(sp)
    80002e76:	1000                	addi	s0,sp,32
    80002e78:	84aa                	mv	s1,a0
  iunlock(ip);
    80002e7a:	00000097          	auipc	ra,0x0
    80002e7e:	e54080e7          	jalr	-428(ra) # 80002cce <iunlock>
  iput(ip);
    80002e82:	8526                	mv	a0,s1
    80002e84:	00000097          	auipc	ra,0x0
    80002e88:	f42080e7          	jalr	-190(ra) # 80002dc6 <iput>
}
    80002e8c:	60e2                	ld	ra,24(sp)
    80002e8e:	6442                	ld	s0,16(sp)
    80002e90:	64a2                	ld	s1,8(sp)
    80002e92:	6105                	addi	sp,sp,32
    80002e94:	8082                	ret

0000000080002e96 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void
stati(struct inode *ip, struct stat *st)
{
    80002e96:	1141                	addi	sp,sp,-16
    80002e98:	e422                	sd	s0,8(sp)
    80002e9a:	0800                	addi	s0,sp,16
  st->dev = ip->dev;
    80002e9c:	411c                	lw	a5,0(a0)
    80002e9e:	c19c                	sw	a5,0(a1)
  st->ino = ip->inum;
    80002ea0:	415c                	lw	a5,4(a0)
    80002ea2:	c1dc                	sw	a5,4(a1)
  st->type = ip->type;
    80002ea4:	04451783          	lh	a5,68(a0)
    80002ea8:	00f59423          	sh	a5,8(a1)
  st->nlink = ip->nlink;
    80002eac:	04a51783          	lh	a5,74(a0)
    80002eb0:	00f59523          	sh	a5,10(a1)
  st->size = ip->size;
    80002eb4:	04c56783          	lwu	a5,76(a0)
    80002eb8:	e99c                	sd	a5,16(a1)
}
    80002eba:	6422                	ld	s0,8(sp)
    80002ebc:	0141                	addi	sp,sp,16
    80002ebe:	8082                	ret

0000000080002ec0 <readi>:
readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002ec0:	457c                	lw	a5,76(a0)
    80002ec2:	0ed7e963          	bltu	a5,a3,80002fb4 <readi+0xf4>
{
    80002ec6:	7159                	addi	sp,sp,-112
    80002ec8:	f486                	sd	ra,104(sp)
    80002eca:	f0a2                	sd	s0,96(sp)
    80002ecc:	eca6                	sd	s1,88(sp)
    80002ece:	e8ca                	sd	s2,80(sp)
    80002ed0:	e4ce                	sd	s3,72(sp)
    80002ed2:	e0d2                	sd	s4,64(sp)
    80002ed4:	fc56                	sd	s5,56(sp)
    80002ed6:	f85a                	sd	s6,48(sp)
    80002ed8:	f45e                	sd	s7,40(sp)
    80002eda:	f062                	sd	s8,32(sp)
    80002edc:	ec66                	sd	s9,24(sp)
    80002ede:	e86a                	sd	s10,16(sp)
    80002ee0:	e46e                	sd	s11,8(sp)
    80002ee2:	1880                	addi	s0,sp,112
    80002ee4:	8b2a                	mv	s6,a0
    80002ee6:	8bae                	mv	s7,a1
    80002ee8:	8a32                	mv	s4,a2
    80002eea:	84b6                	mv	s1,a3
    80002eec:	8aba                	mv	s5,a4
  if(off > ip->size || off + n < off)
    80002eee:	9f35                	addw	a4,a4,a3
    return 0;
    80002ef0:	4501                	li	a0,0
  if(off > ip->size || off + n < off)
    80002ef2:	0ad76063          	bltu	a4,a3,80002f92 <readi+0xd2>
  if(off + n > ip->size)
    80002ef6:	00e7f463          	bgeu	a5,a4,80002efe <readi+0x3e>
    n = ip->size - off;
    80002efa:	40d78abb          	subw	s5,a5,a3

  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002efe:	0a0a8963          	beqz	s5,80002fb0 <readi+0xf0>
    80002f02:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f04:	40000c93          	li	s9,1024
    if(either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1) {
    80002f08:	5c7d                	li	s8,-1
    80002f0a:	a82d                	j	80002f44 <readi+0x84>
    80002f0c:	020d1d93          	slli	s11,s10,0x20
    80002f10:	020ddd93          	srli	s11,s11,0x20
    80002f14:	05890613          	addi	a2,s2,88
    80002f18:	86ee                	mv	a3,s11
    80002f1a:	963a                	add	a2,a2,a4
    80002f1c:	85d2                	mv	a1,s4
    80002f1e:	855e                	mv	a0,s7
    80002f20:	fffff097          	auipc	ra,0xfffff
    80002f24:	9ee080e7          	jalr	-1554(ra) # 8000190e <either_copyout>
    80002f28:	05850d63          	beq	a0,s8,80002f82 <readi+0xc2>
      brelse(bp);
      tot = -1;
      break;
    }
    brelse(bp);
    80002f2c:	854a                	mv	a0,s2
    80002f2e:	fffff097          	auipc	ra,0xfffff
    80002f32:	5f4080e7          	jalr	1524(ra) # 80002522 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002f36:	013d09bb          	addw	s3,s10,s3
    80002f3a:	009d04bb          	addw	s1,s10,s1
    80002f3e:	9a6e                	add	s4,s4,s11
    80002f40:	0559f763          	bgeu	s3,s5,80002f8e <readi+0xce>
    uint addr = bmap(ip, off/BSIZE);
    80002f44:	00a4d59b          	srliw	a1,s1,0xa
    80002f48:	855a                	mv	a0,s6
    80002f4a:	00000097          	auipc	ra,0x0
    80002f4e:	8a2080e7          	jalr	-1886(ra) # 800027ec <bmap>
    80002f52:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80002f56:	cd85                	beqz	a1,80002f8e <readi+0xce>
    bp = bread(ip->dev, addr);
    80002f58:	000b2503          	lw	a0,0(s6)
    80002f5c:	fffff097          	auipc	ra,0xfffff
    80002f60:	496080e7          	jalr	1174(ra) # 800023f2 <bread>
    80002f64:	892a                	mv	s2,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80002f66:	3ff4f713          	andi	a4,s1,1023
    80002f6a:	40ec87bb          	subw	a5,s9,a4
    80002f6e:	413a86bb          	subw	a3,s5,s3
    80002f72:	8d3e                	mv	s10,a5
    80002f74:	2781                	sext.w	a5,a5
    80002f76:	0006861b          	sext.w	a2,a3
    80002f7a:	f8f679e3          	bgeu	a2,a5,80002f0c <readi+0x4c>
    80002f7e:	8d36                	mv	s10,a3
    80002f80:	b771                	j	80002f0c <readi+0x4c>
      brelse(bp);
    80002f82:	854a                	mv	a0,s2
    80002f84:	fffff097          	auipc	ra,0xfffff
    80002f88:	59e080e7          	jalr	1438(ra) # 80002522 <brelse>
      tot = -1;
    80002f8c:	59fd                	li	s3,-1
  }
  return tot;
    80002f8e:	0009851b          	sext.w	a0,s3
}
    80002f92:	70a6                	ld	ra,104(sp)
    80002f94:	7406                	ld	s0,96(sp)
    80002f96:	64e6                	ld	s1,88(sp)
    80002f98:	6946                	ld	s2,80(sp)
    80002f9a:	69a6                	ld	s3,72(sp)
    80002f9c:	6a06                	ld	s4,64(sp)
    80002f9e:	7ae2                	ld	s5,56(sp)
    80002fa0:	7b42                	ld	s6,48(sp)
    80002fa2:	7ba2                	ld	s7,40(sp)
    80002fa4:	7c02                	ld	s8,32(sp)
    80002fa6:	6ce2                	ld	s9,24(sp)
    80002fa8:	6d42                	ld	s10,16(sp)
    80002faa:	6da2                	ld	s11,8(sp)
    80002fac:	6165                	addi	sp,sp,112
    80002fae:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, dst+=m){
    80002fb0:	89d6                	mv	s3,s5
    80002fb2:	bff1                	j	80002f8e <readi+0xce>
    return 0;
    80002fb4:	4501                	li	a0,0
}
    80002fb6:	8082                	ret

0000000080002fb8 <writei>:
writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
  uint tot, m;
  struct buf *bp;

  if(off > ip->size || off + n < off)
    80002fb8:	457c                	lw	a5,76(a0)
    80002fba:	10d7e863          	bltu	a5,a3,800030ca <writei+0x112>
{
    80002fbe:	7159                	addi	sp,sp,-112
    80002fc0:	f486                	sd	ra,104(sp)
    80002fc2:	f0a2                	sd	s0,96(sp)
    80002fc4:	eca6                	sd	s1,88(sp)
    80002fc6:	e8ca                	sd	s2,80(sp)
    80002fc8:	e4ce                	sd	s3,72(sp)
    80002fca:	e0d2                	sd	s4,64(sp)
    80002fcc:	fc56                	sd	s5,56(sp)
    80002fce:	f85a                	sd	s6,48(sp)
    80002fd0:	f45e                	sd	s7,40(sp)
    80002fd2:	f062                	sd	s8,32(sp)
    80002fd4:	ec66                	sd	s9,24(sp)
    80002fd6:	e86a                	sd	s10,16(sp)
    80002fd8:	e46e                	sd	s11,8(sp)
    80002fda:	1880                	addi	s0,sp,112
    80002fdc:	8aaa                	mv	s5,a0
    80002fde:	8bae                	mv	s7,a1
    80002fe0:	8a32                	mv	s4,a2
    80002fe2:	8936                	mv	s2,a3
    80002fe4:	8b3a                	mv	s6,a4
  if(off > ip->size || off + n < off)
    80002fe6:	00e687bb          	addw	a5,a3,a4
    80002fea:	0ed7e263          	bltu	a5,a3,800030ce <writei+0x116>
    return -1;
  if(off + n > MAXFILE*BSIZE)
    80002fee:	00043737          	lui	a4,0x43
    80002ff2:	0ef76063          	bltu	a4,a5,800030d2 <writei+0x11a>
    return -1;

  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80002ff6:	0c0b0863          	beqz	s6,800030c6 <writei+0x10e>
    80002ffa:	4981                	li	s3,0
    uint addr = bmap(ip, off/BSIZE);
    if(addr == 0)
      break;
    bp = bread(ip->dev, addr);
    m = min(n - tot, BSIZE - off%BSIZE);
    80002ffc:	40000c93          	li	s9,1024
    if(either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1) {
    80003000:	5c7d                	li	s8,-1
    80003002:	a091                	j	80003046 <writei+0x8e>
    80003004:	020d1d93          	slli	s11,s10,0x20
    80003008:	020ddd93          	srli	s11,s11,0x20
    8000300c:	05848513          	addi	a0,s1,88
    80003010:	86ee                	mv	a3,s11
    80003012:	8652                	mv	a2,s4
    80003014:	85de                	mv	a1,s7
    80003016:	953a                	add	a0,a0,a4
    80003018:	fffff097          	auipc	ra,0xfffff
    8000301c:	94c080e7          	jalr	-1716(ra) # 80001964 <either_copyin>
    80003020:	07850263          	beq	a0,s8,80003084 <writei+0xcc>
      brelse(bp);
      break;
    }
    log_write(bp);
    80003024:	8526                	mv	a0,s1
    80003026:	00000097          	auipc	ra,0x0
    8000302a:	780080e7          	jalr	1920(ra) # 800037a6 <log_write>
    brelse(bp);
    8000302e:	8526                	mv	a0,s1
    80003030:	fffff097          	auipc	ra,0xfffff
    80003034:	4f2080e7          	jalr	1266(ra) # 80002522 <brelse>
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    80003038:	013d09bb          	addw	s3,s10,s3
    8000303c:	012d093b          	addw	s2,s10,s2
    80003040:	9a6e                	add	s4,s4,s11
    80003042:	0569f663          	bgeu	s3,s6,8000308e <writei+0xd6>
    uint addr = bmap(ip, off/BSIZE);
    80003046:	00a9559b          	srliw	a1,s2,0xa
    8000304a:	8556                	mv	a0,s5
    8000304c:	fffff097          	auipc	ra,0xfffff
    80003050:	7a0080e7          	jalr	1952(ra) # 800027ec <bmap>
    80003054:	0005059b          	sext.w	a1,a0
    if(addr == 0)
    80003058:	c99d                	beqz	a1,8000308e <writei+0xd6>
    bp = bread(ip->dev, addr);
    8000305a:	000aa503          	lw	a0,0(s5)
    8000305e:	fffff097          	auipc	ra,0xfffff
    80003062:	394080e7          	jalr	916(ra) # 800023f2 <bread>
    80003066:	84aa                	mv	s1,a0
    m = min(n - tot, BSIZE - off%BSIZE);
    80003068:	3ff97713          	andi	a4,s2,1023
    8000306c:	40ec87bb          	subw	a5,s9,a4
    80003070:	413b06bb          	subw	a3,s6,s3
    80003074:	8d3e                	mv	s10,a5
    80003076:	2781                	sext.w	a5,a5
    80003078:	0006861b          	sext.w	a2,a3
    8000307c:	f8f674e3          	bgeu	a2,a5,80003004 <writei+0x4c>
    80003080:	8d36                	mv	s10,a3
    80003082:	b749                	j	80003004 <writei+0x4c>
      brelse(bp);
    80003084:	8526                	mv	a0,s1
    80003086:	fffff097          	auipc	ra,0xfffff
    8000308a:	49c080e7          	jalr	1180(ra) # 80002522 <brelse>
  }

  if(off > ip->size)
    8000308e:	04caa783          	lw	a5,76(s5)
    80003092:	0127f463          	bgeu	a5,s2,8000309a <writei+0xe2>
    ip->size = off;
    80003096:	052aa623          	sw	s2,76(s5)

  // write the i-node back to disk even if the size didn't change
  // because the loop above might have called bmap() and added a new
  // block to ip->addrs[].
  iupdate(ip);
    8000309a:	8556                	mv	a0,s5
    8000309c:	00000097          	auipc	ra,0x0
    800030a0:	aa6080e7          	jalr	-1370(ra) # 80002b42 <iupdate>

  return tot;
    800030a4:	0009851b          	sext.w	a0,s3
}
    800030a8:	70a6                	ld	ra,104(sp)
    800030aa:	7406                	ld	s0,96(sp)
    800030ac:	64e6                	ld	s1,88(sp)
    800030ae:	6946                	ld	s2,80(sp)
    800030b0:	69a6                	ld	s3,72(sp)
    800030b2:	6a06                	ld	s4,64(sp)
    800030b4:	7ae2                	ld	s5,56(sp)
    800030b6:	7b42                	ld	s6,48(sp)
    800030b8:	7ba2                	ld	s7,40(sp)
    800030ba:	7c02                	ld	s8,32(sp)
    800030bc:	6ce2                	ld	s9,24(sp)
    800030be:	6d42                	ld	s10,16(sp)
    800030c0:	6da2                	ld	s11,8(sp)
    800030c2:	6165                	addi	sp,sp,112
    800030c4:	8082                	ret
  for(tot=0; tot<n; tot+=m, off+=m, src+=m){
    800030c6:	89da                	mv	s3,s6
    800030c8:	bfc9                	j	8000309a <writei+0xe2>
    return -1;
    800030ca:	557d                	li	a0,-1
}
    800030cc:	8082                	ret
    return -1;
    800030ce:	557d                	li	a0,-1
    800030d0:	bfe1                	j	800030a8 <writei+0xf0>
    return -1;
    800030d2:	557d                	li	a0,-1
    800030d4:	bfd1                	j	800030a8 <writei+0xf0>

00000000800030d6 <namecmp>:

// Directories

int
namecmp(const char *s, const char *t)
{
    800030d6:	1141                	addi	sp,sp,-16
    800030d8:	e406                	sd	ra,8(sp)
    800030da:	e022                	sd	s0,0(sp)
    800030dc:	0800                	addi	s0,sp,16
  return strncmp(s, t, DIRSIZ);
    800030de:	4639                	li	a2,14
    800030e0:	ffffd097          	auipc	ra,0xffffd
    800030e4:	170080e7          	jalr	368(ra) # 80000250 <strncmp>
}
    800030e8:	60a2                	ld	ra,8(sp)
    800030ea:	6402                	ld	s0,0(sp)
    800030ec:	0141                	addi	sp,sp,16
    800030ee:	8082                	ret

00000000800030f0 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode*
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800030f0:	7139                	addi	sp,sp,-64
    800030f2:	fc06                	sd	ra,56(sp)
    800030f4:	f822                	sd	s0,48(sp)
    800030f6:	f426                	sd	s1,40(sp)
    800030f8:	f04a                	sd	s2,32(sp)
    800030fa:	ec4e                	sd	s3,24(sp)
    800030fc:	e852                	sd	s4,16(sp)
    800030fe:	0080                	addi	s0,sp,64
  uint off, inum;
  struct dirent de;

  if(dp->type != T_DIR)
    80003100:	04451703          	lh	a4,68(a0)
    80003104:	4785                	li	a5,1
    80003106:	00f71a63          	bne	a4,a5,8000311a <dirlookup+0x2a>
    8000310a:	892a                	mv	s2,a0
    8000310c:	89ae                	mv	s3,a1
    8000310e:	8a32                	mv	s4,a2
    panic("dirlookup not DIR");

  for(off = 0; off < dp->size; off += sizeof(de)){
    80003110:	457c                	lw	a5,76(a0)
    80003112:	4481                	li	s1,0
      inum = de.inum;
      return iget(dp->dev, inum);
    }
  }

  return 0;
    80003114:	4501                	li	a0,0
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003116:	e79d                	bnez	a5,80003144 <dirlookup+0x54>
    80003118:	a8a5                	j	80003190 <dirlookup+0xa0>
    panic("dirlookup not DIR");
    8000311a:	00005517          	auipc	a0,0x5
    8000311e:	4c650513          	addi	a0,a0,1222 # 800085e0 <syscalls+0x1b0>
    80003122:	00003097          	auipc	ra,0x3
    80003126:	d80080e7          	jalr	-640(ra) # 80005ea2 <panic>
      panic("dirlookup read");
    8000312a:	00005517          	auipc	a0,0x5
    8000312e:	4ce50513          	addi	a0,a0,1230 # 800085f8 <syscalls+0x1c8>
    80003132:	00003097          	auipc	ra,0x3
    80003136:	d70080e7          	jalr	-656(ra) # 80005ea2 <panic>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000313a:	24c1                	addiw	s1,s1,16
    8000313c:	04c92783          	lw	a5,76(s2)
    80003140:	04f4f763          	bgeu	s1,a5,8000318e <dirlookup+0x9e>
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003144:	4741                	li	a4,16
    80003146:	86a6                	mv	a3,s1
    80003148:	fc040613          	addi	a2,s0,-64
    8000314c:	4581                	li	a1,0
    8000314e:	854a                	mv	a0,s2
    80003150:	00000097          	auipc	ra,0x0
    80003154:	d70080e7          	jalr	-656(ra) # 80002ec0 <readi>
    80003158:	47c1                	li	a5,16
    8000315a:	fcf518e3          	bne	a0,a5,8000312a <dirlookup+0x3a>
    if(de.inum == 0)
    8000315e:	fc045783          	lhu	a5,-64(s0)
    80003162:	dfe1                	beqz	a5,8000313a <dirlookup+0x4a>
    if(namecmp(name, de.name) == 0){
    80003164:	fc240593          	addi	a1,s0,-62
    80003168:	854e                	mv	a0,s3
    8000316a:	00000097          	auipc	ra,0x0
    8000316e:	f6c080e7          	jalr	-148(ra) # 800030d6 <namecmp>
    80003172:	f561                	bnez	a0,8000313a <dirlookup+0x4a>
      if(poff)
    80003174:	000a0463          	beqz	s4,8000317c <dirlookup+0x8c>
        *poff = off;
    80003178:	009a2023          	sw	s1,0(s4)
      return iget(dp->dev, inum);
    8000317c:	fc045583          	lhu	a1,-64(s0)
    80003180:	00092503          	lw	a0,0(s2)
    80003184:	fffff097          	auipc	ra,0xfffff
    80003188:	750080e7          	jalr	1872(ra) # 800028d4 <iget>
    8000318c:	a011                	j	80003190 <dirlookup+0xa0>
  return 0;
    8000318e:	4501                	li	a0,0
}
    80003190:	70e2                	ld	ra,56(sp)
    80003192:	7442                	ld	s0,48(sp)
    80003194:	74a2                	ld	s1,40(sp)
    80003196:	7902                	ld	s2,32(sp)
    80003198:	69e2                	ld	s3,24(sp)
    8000319a:	6a42                	ld	s4,16(sp)
    8000319c:	6121                	addi	sp,sp,64
    8000319e:	8082                	ret

00000000800031a0 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode*
namex(char *path, int nameiparent, char *name)
{
    800031a0:	711d                	addi	sp,sp,-96
    800031a2:	ec86                	sd	ra,88(sp)
    800031a4:	e8a2                	sd	s0,80(sp)
    800031a6:	e4a6                	sd	s1,72(sp)
    800031a8:	e0ca                	sd	s2,64(sp)
    800031aa:	fc4e                	sd	s3,56(sp)
    800031ac:	f852                	sd	s4,48(sp)
    800031ae:	f456                	sd	s5,40(sp)
    800031b0:	f05a                	sd	s6,32(sp)
    800031b2:	ec5e                	sd	s7,24(sp)
    800031b4:	e862                	sd	s8,16(sp)
    800031b6:	e466                	sd	s9,8(sp)
    800031b8:	1080                	addi	s0,sp,96
    800031ba:	84aa                	mv	s1,a0
    800031bc:	8b2e                	mv	s6,a1
    800031be:	8ab2                	mv	s5,a2
  struct inode *ip, *next;

  if(*path == '/')
    800031c0:	00054703          	lbu	a4,0(a0)
    800031c4:	02f00793          	li	a5,47
    800031c8:	02f70363          	beq	a4,a5,800031ee <namex+0x4e>
    ip = iget(ROOTDEV, ROOTINO);
  else
    ip = idup(myproc()->cwd);
    800031cc:	ffffe097          	auipc	ra,0xffffe
    800031d0:	c96080e7          	jalr	-874(ra) # 80000e62 <myproc>
    800031d4:	15053503          	ld	a0,336(a0)
    800031d8:	00000097          	auipc	ra,0x0
    800031dc:	9f6080e7          	jalr	-1546(ra) # 80002bce <idup>
    800031e0:	89aa                	mv	s3,a0
  while(*path == '/')
    800031e2:	02f00913          	li	s2,47
  len = path - s;
    800031e6:	4b81                	li	s7,0
  if(len >= DIRSIZ)
    800031e8:	4cb5                	li	s9,13

  while((path = skipelem(path, name)) != 0){
    ilock(ip);
    if(ip->type != T_DIR){
    800031ea:	4c05                	li	s8,1
    800031ec:	a865                	j	800032a4 <namex+0x104>
    ip = iget(ROOTDEV, ROOTINO);
    800031ee:	4585                	li	a1,1
    800031f0:	4505                	li	a0,1
    800031f2:	fffff097          	auipc	ra,0xfffff
    800031f6:	6e2080e7          	jalr	1762(ra) # 800028d4 <iget>
    800031fa:	89aa                	mv	s3,a0
    800031fc:	b7dd                	j	800031e2 <namex+0x42>
      iunlockput(ip);
    800031fe:	854e                	mv	a0,s3
    80003200:	00000097          	auipc	ra,0x0
    80003204:	c6e080e7          	jalr	-914(ra) # 80002e6e <iunlockput>
      return 0;
    80003208:	4981                	li	s3,0
  if(nameiparent){
    iput(ip);
    return 0;
  }
  return ip;
}
    8000320a:	854e                	mv	a0,s3
    8000320c:	60e6                	ld	ra,88(sp)
    8000320e:	6446                	ld	s0,80(sp)
    80003210:	64a6                	ld	s1,72(sp)
    80003212:	6906                	ld	s2,64(sp)
    80003214:	79e2                	ld	s3,56(sp)
    80003216:	7a42                	ld	s4,48(sp)
    80003218:	7aa2                	ld	s5,40(sp)
    8000321a:	7b02                	ld	s6,32(sp)
    8000321c:	6be2                	ld	s7,24(sp)
    8000321e:	6c42                	ld	s8,16(sp)
    80003220:	6ca2                	ld	s9,8(sp)
    80003222:	6125                	addi	sp,sp,96
    80003224:	8082                	ret
      iunlock(ip);
    80003226:	854e                	mv	a0,s3
    80003228:	00000097          	auipc	ra,0x0
    8000322c:	aa6080e7          	jalr	-1370(ra) # 80002cce <iunlock>
      return ip;
    80003230:	bfe9                	j	8000320a <namex+0x6a>
      iunlockput(ip);
    80003232:	854e                	mv	a0,s3
    80003234:	00000097          	auipc	ra,0x0
    80003238:	c3a080e7          	jalr	-966(ra) # 80002e6e <iunlockput>
      return 0;
    8000323c:	89d2                	mv	s3,s4
    8000323e:	b7f1                	j	8000320a <namex+0x6a>
  len = path - s;
    80003240:	40b48633          	sub	a2,s1,a1
    80003244:	00060a1b          	sext.w	s4,a2
  if(len >= DIRSIZ)
    80003248:	094cd463          	bge	s9,s4,800032d0 <namex+0x130>
    memmove(name, s, DIRSIZ);
    8000324c:	4639                	li	a2,14
    8000324e:	8556                	mv	a0,s5
    80003250:	ffffd097          	auipc	ra,0xffffd
    80003254:	f88080e7          	jalr	-120(ra) # 800001d8 <memmove>
  while(*path == '/')
    80003258:	0004c783          	lbu	a5,0(s1)
    8000325c:	01279763          	bne	a5,s2,8000326a <namex+0xca>
    path++;
    80003260:	0485                	addi	s1,s1,1
  while(*path == '/')
    80003262:	0004c783          	lbu	a5,0(s1)
    80003266:	ff278de3          	beq	a5,s2,80003260 <namex+0xc0>
    ilock(ip);
    8000326a:	854e                	mv	a0,s3
    8000326c:	00000097          	auipc	ra,0x0
    80003270:	9a0080e7          	jalr	-1632(ra) # 80002c0c <ilock>
    if(ip->type != T_DIR){
    80003274:	04499783          	lh	a5,68(s3)
    80003278:	f98793e3          	bne	a5,s8,800031fe <namex+0x5e>
    if(nameiparent && *path == '\0'){
    8000327c:	000b0563          	beqz	s6,80003286 <namex+0xe6>
    80003280:	0004c783          	lbu	a5,0(s1)
    80003284:	d3cd                	beqz	a5,80003226 <namex+0x86>
    if((next = dirlookup(ip, name, 0)) == 0){
    80003286:	865e                	mv	a2,s7
    80003288:	85d6                	mv	a1,s5
    8000328a:	854e                	mv	a0,s3
    8000328c:	00000097          	auipc	ra,0x0
    80003290:	e64080e7          	jalr	-412(ra) # 800030f0 <dirlookup>
    80003294:	8a2a                	mv	s4,a0
    80003296:	dd51                	beqz	a0,80003232 <namex+0x92>
    iunlockput(ip);
    80003298:	854e                	mv	a0,s3
    8000329a:	00000097          	auipc	ra,0x0
    8000329e:	bd4080e7          	jalr	-1068(ra) # 80002e6e <iunlockput>
    ip = next;
    800032a2:	89d2                	mv	s3,s4
  while(*path == '/')
    800032a4:	0004c783          	lbu	a5,0(s1)
    800032a8:	05279763          	bne	a5,s2,800032f6 <namex+0x156>
    path++;
    800032ac:	0485                	addi	s1,s1,1
  while(*path == '/')
    800032ae:	0004c783          	lbu	a5,0(s1)
    800032b2:	ff278de3          	beq	a5,s2,800032ac <namex+0x10c>
  if(*path == 0)
    800032b6:	c79d                	beqz	a5,800032e4 <namex+0x144>
    path++;
    800032b8:	85a6                	mv	a1,s1
  len = path - s;
    800032ba:	8a5e                	mv	s4,s7
    800032bc:	865e                	mv	a2,s7
  while(*path != '/' && *path != 0)
    800032be:	01278963          	beq	a5,s2,800032d0 <namex+0x130>
    800032c2:	dfbd                	beqz	a5,80003240 <namex+0xa0>
    path++;
    800032c4:	0485                	addi	s1,s1,1
  while(*path != '/' && *path != 0)
    800032c6:	0004c783          	lbu	a5,0(s1)
    800032ca:	ff279ce3          	bne	a5,s2,800032c2 <namex+0x122>
    800032ce:	bf8d                	j	80003240 <namex+0xa0>
    memmove(name, s, len);
    800032d0:	2601                	sext.w	a2,a2
    800032d2:	8556                	mv	a0,s5
    800032d4:	ffffd097          	auipc	ra,0xffffd
    800032d8:	f04080e7          	jalr	-252(ra) # 800001d8 <memmove>
    name[len] = 0;
    800032dc:	9a56                	add	s4,s4,s5
    800032de:	000a0023          	sb	zero,0(s4)
    800032e2:	bf9d                	j	80003258 <namex+0xb8>
  if(nameiparent){
    800032e4:	f20b03e3          	beqz	s6,8000320a <namex+0x6a>
    iput(ip);
    800032e8:	854e                	mv	a0,s3
    800032ea:	00000097          	auipc	ra,0x0
    800032ee:	adc080e7          	jalr	-1316(ra) # 80002dc6 <iput>
    return 0;
    800032f2:	4981                	li	s3,0
    800032f4:	bf19                	j	8000320a <namex+0x6a>
  if(*path == 0)
    800032f6:	d7fd                	beqz	a5,800032e4 <namex+0x144>
  while(*path != '/' && *path != 0)
    800032f8:	0004c783          	lbu	a5,0(s1)
    800032fc:	85a6                	mv	a1,s1
    800032fe:	b7d1                	j	800032c2 <namex+0x122>

0000000080003300 <dirlink>:
{
    80003300:	7139                	addi	sp,sp,-64
    80003302:	fc06                	sd	ra,56(sp)
    80003304:	f822                	sd	s0,48(sp)
    80003306:	f426                	sd	s1,40(sp)
    80003308:	f04a                	sd	s2,32(sp)
    8000330a:	ec4e                	sd	s3,24(sp)
    8000330c:	e852                	sd	s4,16(sp)
    8000330e:	0080                	addi	s0,sp,64
    80003310:	892a                	mv	s2,a0
    80003312:	8a2e                	mv	s4,a1
    80003314:	89b2                	mv	s3,a2
  if((ip = dirlookup(dp, name, 0)) != 0){
    80003316:	4601                	li	a2,0
    80003318:	00000097          	auipc	ra,0x0
    8000331c:	dd8080e7          	jalr	-552(ra) # 800030f0 <dirlookup>
    80003320:	e93d                	bnez	a0,80003396 <dirlink+0x96>
  for(off = 0; off < dp->size; off += sizeof(de)){
    80003322:	04c92483          	lw	s1,76(s2)
    80003326:	c49d                	beqz	s1,80003354 <dirlink+0x54>
    80003328:	4481                	li	s1,0
    if(readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000332a:	4741                	li	a4,16
    8000332c:	86a6                	mv	a3,s1
    8000332e:	fc040613          	addi	a2,s0,-64
    80003332:	4581                	li	a1,0
    80003334:	854a                	mv	a0,s2
    80003336:	00000097          	auipc	ra,0x0
    8000333a:	b8a080e7          	jalr	-1142(ra) # 80002ec0 <readi>
    8000333e:	47c1                	li	a5,16
    80003340:	06f51163          	bne	a0,a5,800033a2 <dirlink+0xa2>
    if(de.inum == 0)
    80003344:	fc045783          	lhu	a5,-64(s0)
    80003348:	c791                	beqz	a5,80003354 <dirlink+0x54>
  for(off = 0; off < dp->size; off += sizeof(de)){
    8000334a:	24c1                	addiw	s1,s1,16
    8000334c:	04c92783          	lw	a5,76(s2)
    80003350:	fcf4ede3          	bltu	s1,a5,8000332a <dirlink+0x2a>
  strncpy(de.name, name, DIRSIZ);
    80003354:	4639                	li	a2,14
    80003356:	85d2                	mv	a1,s4
    80003358:	fc240513          	addi	a0,s0,-62
    8000335c:	ffffd097          	auipc	ra,0xffffd
    80003360:	f30080e7          	jalr	-208(ra) # 8000028c <strncpy>
  de.inum = inum;
    80003364:	fd341023          	sh	s3,-64(s0)
  if(writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003368:	4741                	li	a4,16
    8000336a:	86a6                	mv	a3,s1
    8000336c:	fc040613          	addi	a2,s0,-64
    80003370:	4581                	li	a1,0
    80003372:	854a                	mv	a0,s2
    80003374:	00000097          	auipc	ra,0x0
    80003378:	c44080e7          	jalr	-956(ra) # 80002fb8 <writei>
    8000337c:	1541                	addi	a0,a0,-16
    8000337e:	00a03533          	snez	a0,a0
    80003382:	40a00533          	neg	a0,a0
}
    80003386:	70e2                	ld	ra,56(sp)
    80003388:	7442                	ld	s0,48(sp)
    8000338a:	74a2                	ld	s1,40(sp)
    8000338c:	7902                	ld	s2,32(sp)
    8000338e:	69e2                	ld	s3,24(sp)
    80003390:	6a42                	ld	s4,16(sp)
    80003392:	6121                	addi	sp,sp,64
    80003394:	8082                	ret
    iput(ip);
    80003396:	00000097          	auipc	ra,0x0
    8000339a:	a30080e7          	jalr	-1488(ra) # 80002dc6 <iput>
    return -1;
    8000339e:	557d                	li	a0,-1
    800033a0:	b7dd                	j	80003386 <dirlink+0x86>
      panic("dirlink read");
    800033a2:	00005517          	auipc	a0,0x5
    800033a6:	26650513          	addi	a0,a0,614 # 80008608 <syscalls+0x1d8>
    800033aa:	00003097          	auipc	ra,0x3
    800033ae:	af8080e7          	jalr	-1288(ra) # 80005ea2 <panic>

00000000800033b2 <namei>:

struct inode*
namei(char *path)
{
    800033b2:	1101                	addi	sp,sp,-32
    800033b4:	ec06                	sd	ra,24(sp)
    800033b6:	e822                	sd	s0,16(sp)
    800033b8:	1000                	addi	s0,sp,32
  char name[DIRSIZ];
  return namex(path, 0, name);
    800033ba:	fe040613          	addi	a2,s0,-32
    800033be:	4581                	li	a1,0
    800033c0:	00000097          	auipc	ra,0x0
    800033c4:	de0080e7          	jalr	-544(ra) # 800031a0 <namex>
}
    800033c8:	60e2                	ld	ra,24(sp)
    800033ca:	6442                	ld	s0,16(sp)
    800033cc:	6105                	addi	sp,sp,32
    800033ce:	8082                	ret

00000000800033d0 <nameiparent>:

struct inode*
nameiparent(char *path, char *name)
{
    800033d0:	1141                	addi	sp,sp,-16
    800033d2:	e406                	sd	ra,8(sp)
    800033d4:	e022                	sd	s0,0(sp)
    800033d6:	0800                	addi	s0,sp,16
    800033d8:	862e                	mv	a2,a1
  return namex(path, 1, name);
    800033da:	4585                	li	a1,1
    800033dc:	00000097          	auipc	ra,0x0
    800033e0:	dc4080e7          	jalr	-572(ra) # 800031a0 <namex>
}
    800033e4:	60a2                	ld	ra,8(sp)
    800033e6:	6402                	ld	s0,0(sp)
    800033e8:	0141                	addi	sp,sp,16
    800033ea:	8082                	ret

00000000800033ec <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800033ec:	1101                	addi	sp,sp,-32
    800033ee:	ec06                	sd	ra,24(sp)
    800033f0:	e822                	sd	s0,16(sp)
    800033f2:	e426                	sd	s1,8(sp)
    800033f4:	e04a                	sd	s2,0(sp)
    800033f6:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800033f8:	00023917          	auipc	s2,0x23
    800033fc:	56890913          	addi	s2,s2,1384 # 80026960 <log>
    80003400:	01892583          	lw	a1,24(s2)
    80003404:	02892503          	lw	a0,40(s2)
    80003408:	fffff097          	auipc	ra,0xfffff
    8000340c:	fea080e7          	jalr	-22(ra) # 800023f2 <bread>
    80003410:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003412:	02c92683          	lw	a3,44(s2)
    80003416:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003418:	02d05763          	blez	a3,80003446 <write_head+0x5a>
    8000341c:	00023797          	auipc	a5,0x23
    80003420:	57478793          	addi	a5,a5,1396 # 80026990 <log+0x30>
    80003424:	05c50713          	addi	a4,a0,92
    80003428:	36fd                	addiw	a3,a3,-1
    8000342a:	1682                	slli	a3,a3,0x20
    8000342c:	9281                	srli	a3,a3,0x20
    8000342e:	068a                	slli	a3,a3,0x2
    80003430:	00023617          	auipc	a2,0x23
    80003434:	56460613          	addi	a2,a2,1380 # 80026994 <log+0x34>
    80003438:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    8000343a:	4390                	lw	a2,0(a5)
    8000343c:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000343e:	0791                	addi	a5,a5,4
    80003440:	0711                	addi	a4,a4,4
    80003442:	fed79ce3          	bne	a5,a3,8000343a <write_head+0x4e>
  }
  bwrite(buf);
    80003446:	8526                	mv	a0,s1
    80003448:	fffff097          	auipc	ra,0xfffff
    8000344c:	09c080e7          	jalr	156(ra) # 800024e4 <bwrite>
  brelse(buf);
    80003450:	8526                	mv	a0,s1
    80003452:	fffff097          	auipc	ra,0xfffff
    80003456:	0d0080e7          	jalr	208(ra) # 80002522 <brelse>
}
    8000345a:	60e2                	ld	ra,24(sp)
    8000345c:	6442                	ld	s0,16(sp)
    8000345e:	64a2                	ld	s1,8(sp)
    80003460:	6902                	ld	s2,0(sp)
    80003462:	6105                	addi	sp,sp,32
    80003464:	8082                	ret

0000000080003466 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003466:	00023797          	auipc	a5,0x23
    8000346a:	5267a783          	lw	a5,1318(a5) # 8002698c <log+0x2c>
    8000346e:	0af05d63          	blez	a5,80003528 <install_trans+0xc2>
{
    80003472:	7139                	addi	sp,sp,-64
    80003474:	fc06                	sd	ra,56(sp)
    80003476:	f822                	sd	s0,48(sp)
    80003478:	f426                	sd	s1,40(sp)
    8000347a:	f04a                	sd	s2,32(sp)
    8000347c:	ec4e                	sd	s3,24(sp)
    8000347e:	e852                	sd	s4,16(sp)
    80003480:	e456                	sd	s5,8(sp)
    80003482:	e05a                	sd	s6,0(sp)
    80003484:	0080                	addi	s0,sp,64
    80003486:	8b2a                	mv	s6,a0
    80003488:	00023a97          	auipc	s5,0x23
    8000348c:	508a8a93          	addi	s5,s5,1288 # 80026990 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003490:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003492:	00023997          	auipc	s3,0x23
    80003496:	4ce98993          	addi	s3,s3,1230 # 80026960 <log>
    8000349a:	a035                	j	800034c6 <install_trans+0x60>
      bunpin(dbuf);
    8000349c:	8526                	mv	a0,s1
    8000349e:	fffff097          	auipc	ra,0xfffff
    800034a2:	15e080e7          	jalr	350(ra) # 800025fc <bunpin>
    brelse(lbuf);
    800034a6:	854a                	mv	a0,s2
    800034a8:	fffff097          	auipc	ra,0xfffff
    800034ac:	07a080e7          	jalr	122(ra) # 80002522 <brelse>
    brelse(dbuf);
    800034b0:	8526                	mv	a0,s1
    800034b2:	fffff097          	auipc	ra,0xfffff
    800034b6:	070080e7          	jalr	112(ra) # 80002522 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800034ba:	2a05                	addiw	s4,s4,1
    800034bc:	0a91                	addi	s5,s5,4
    800034be:	02c9a783          	lw	a5,44(s3)
    800034c2:	04fa5963          	bge	s4,a5,80003514 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800034c6:	0189a583          	lw	a1,24(s3)
    800034ca:	014585bb          	addw	a1,a1,s4
    800034ce:	2585                	addiw	a1,a1,1
    800034d0:	0289a503          	lw	a0,40(s3)
    800034d4:	fffff097          	auipc	ra,0xfffff
    800034d8:	f1e080e7          	jalr	-226(ra) # 800023f2 <bread>
    800034dc:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800034de:	000aa583          	lw	a1,0(s5)
    800034e2:	0289a503          	lw	a0,40(s3)
    800034e6:	fffff097          	auipc	ra,0xfffff
    800034ea:	f0c080e7          	jalr	-244(ra) # 800023f2 <bread>
    800034ee:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800034f0:	40000613          	li	a2,1024
    800034f4:	05890593          	addi	a1,s2,88
    800034f8:	05850513          	addi	a0,a0,88
    800034fc:	ffffd097          	auipc	ra,0xffffd
    80003500:	cdc080e7          	jalr	-804(ra) # 800001d8 <memmove>
    bwrite(dbuf);  // write dst to disk
    80003504:	8526                	mv	a0,s1
    80003506:	fffff097          	auipc	ra,0xfffff
    8000350a:	fde080e7          	jalr	-34(ra) # 800024e4 <bwrite>
    if(recovering == 0)
    8000350e:	f80b1ce3          	bnez	s6,800034a6 <install_trans+0x40>
    80003512:	b769                	j	8000349c <install_trans+0x36>
}
    80003514:	70e2                	ld	ra,56(sp)
    80003516:	7442                	ld	s0,48(sp)
    80003518:	74a2                	ld	s1,40(sp)
    8000351a:	7902                	ld	s2,32(sp)
    8000351c:	69e2                	ld	s3,24(sp)
    8000351e:	6a42                	ld	s4,16(sp)
    80003520:	6aa2                	ld	s5,8(sp)
    80003522:	6b02                	ld	s6,0(sp)
    80003524:	6121                	addi	sp,sp,64
    80003526:	8082                	ret
    80003528:	8082                	ret

000000008000352a <initlog>:
{
    8000352a:	7179                	addi	sp,sp,-48
    8000352c:	f406                	sd	ra,40(sp)
    8000352e:	f022                	sd	s0,32(sp)
    80003530:	ec26                	sd	s1,24(sp)
    80003532:	e84a                	sd	s2,16(sp)
    80003534:	e44e                	sd	s3,8(sp)
    80003536:	1800                	addi	s0,sp,48
    80003538:	892a                	mv	s2,a0
    8000353a:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    8000353c:	00023497          	auipc	s1,0x23
    80003540:	42448493          	addi	s1,s1,1060 # 80026960 <log>
    80003544:	00005597          	auipc	a1,0x5
    80003548:	0d458593          	addi	a1,a1,212 # 80008618 <syscalls+0x1e8>
    8000354c:	8526                	mv	a0,s1
    8000354e:	00003097          	auipc	ra,0x3
    80003552:	e0e080e7          	jalr	-498(ra) # 8000635c <initlock>
  log.start = sb->logstart;
    80003556:	0149a583          	lw	a1,20(s3)
    8000355a:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    8000355c:	0109a783          	lw	a5,16(s3)
    80003560:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003562:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003566:	854a                	mv	a0,s2
    80003568:	fffff097          	auipc	ra,0xfffff
    8000356c:	e8a080e7          	jalr	-374(ra) # 800023f2 <bread>
  log.lh.n = lh->n;
    80003570:	4d3c                	lw	a5,88(a0)
    80003572:	d4dc                	sw	a5,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003574:	02f05563          	blez	a5,8000359e <initlog+0x74>
    80003578:	05c50713          	addi	a4,a0,92
    8000357c:	00023697          	auipc	a3,0x23
    80003580:	41468693          	addi	a3,a3,1044 # 80026990 <log+0x30>
    80003584:	37fd                	addiw	a5,a5,-1
    80003586:	1782                	slli	a5,a5,0x20
    80003588:	9381                	srli	a5,a5,0x20
    8000358a:	078a                	slli	a5,a5,0x2
    8000358c:	06050613          	addi	a2,a0,96
    80003590:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    80003592:	4310                	lw	a2,0(a4)
    80003594:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    80003596:	0711                	addi	a4,a4,4
    80003598:	0691                	addi	a3,a3,4
    8000359a:	fef71ce3          	bne	a4,a5,80003592 <initlog+0x68>
  brelse(buf);
    8000359e:	fffff097          	auipc	ra,0xfffff
    800035a2:	f84080e7          	jalr	-124(ra) # 80002522 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800035a6:	4505                	li	a0,1
    800035a8:	00000097          	auipc	ra,0x0
    800035ac:	ebe080e7          	jalr	-322(ra) # 80003466 <install_trans>
  log.lh.n = 0;
    800035b0:	00023797          	auipc	a5,0x23
    800035b4:	3c07ae23          	sw	zero,988(a5) # 8002698c <log+0x2c>
  write_head(); // clear the log
    800035b8:	00000097          	auipc	ra,0x0
    800035bc:	e34080e7          	jalr	-460(ra) # 800033ec <write_head>
}
    800035c0:	70a2                	ld	ra,40(sp)
    800035c2:	7402                	ld	s0,32(sp)
    800035c4:	64e2                	ld	s1,24(sp)
    800035c6:	6942                	ld	s2,16(sp)
    800035c8:	69a2                	ld	s3,8(sp)
    800035ca:	6145                	addi	sp,sp,48
    800035cc:	8082                	ret

00000000800035ce <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800035ce:	1101                	addi	sp,sp,-32
    800035d0:	ec06                	sd	ra,24(sp)
    800035d2:	e822                	sd	s0,16(sp)
    800035d4:	e426                	sd	s1,8(sp)
    800035d6:	e04a                	sd	s2,0(sp)
    800035d8:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800035da:	00023517          	auipc	a0,0x23
    800035de:	38650513          	addi	a0,a0,902 # 80026960 <log>
    800035e2:	00003097          	auipc	ra,0x3
    800035e6:	e0a080e7          	jalr	-502(ra) # 800063ec <acquire>
  while(1){
    if(log.committing){
    800035ea:	00023497          	auipc	s1,0x23
    800035ee:	37648493          	addi	s1,s1,886 # 80026960 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800035f2:	4979                	li	s2,30
    800035f4:	a039                	j	80003602 <begin_op+0x34>
      sleep(&log, &log.lock);
    800035f6:	85a6                	mv	a1,s1
    800035f8:	8526                	mv	a0,s1
    800035fa:	ffffe097          	auipc	ra,0xffffe
    800035fe:	f0c080e7          	jalr	-244(ra) # 80001506 <sleep>
    if(log.committing){
    80003602:	50dc                	lw	a5,36(s1)
    80003604:	fbed                	bnez	a5,800035f6 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003606:	509c                	lw	a5,32(s1)
    80003608:	0017871b          	addiw	a4,a5,1
    8000360c:	0007069b          	sext.w	a3,a4
    80003610:	0027179b          	slliw	a5,a4,0x2
    80003614:	9fb9                	addw	a5,a5,a4
    80003616:	0017979b          	slliw	a5,a5,0x1
    8000361a:	54d8                	lw	a4,44(s1)
    8000361c:	9fb9                	addw	a5,a5,a4
    8000361e:	00f95963          	bge	s2,a5,80003630 <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003622:	85a6                	mv	a1,s1
    80003624:	8526                	mv	a0,s1
    80003626:	ffffe097          	auipc	ra,0xffffe
    8000362a:	ee0080e7          	jalr	-288(ra) # 80001506 <sleep>
    8000362e:	bfd1                	j	80003602 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80003630:	00023517          	auipc	a0,0x23
    80003634:	33050513          	addi	a0,a0,816 # 80026960 <log>
    80003638:	d114                	sw	a3,32(a0)
      release(&log.lock);
    8000363a:	00003097          	auipc	ra,0x3
    8000363e:	e66080e7          	jalr	-410(ra) # 800064a0 <release>
      break;
    }
  }
}
    80003642:	60e2                	ld	ra,24(sp)
    80003644:	6442                	ld	s0,16(sp)
    80003646:	64a2                	ld	s1,8(sp)
    80003648:	6902                	ld	s2,0(sp)
    8000364a:	6105                	addi	sp,sp,32
    8000364c:	8082                	ret

000000008000364e <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000364e:	7139                	addi	sp,sp,-64
    80003650:	fc06                	sd	ra,56(sp)
    80003652:	f822                	sd	s0,48(sp)
    80003654:	f426                	sd	s1,40(sp)
    80003656:	f04a                	sd	s2,32(sp)
    80003658:	ec4e                	sd	s3,24(sp)
    8000365a:	e852                	sd	s4,16(sp)
    8000365c:	e456                	sd	s5,8(sp)
    8000365e:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003660:	00023497          	auipc	s1,0x23
    80003664:	30048493          	addi	s1,s1,768 # 80026960 <log>
    80003668:	8526                	mv	a0,s1
    8000366a:	00003097          	auipc	ra,0x3
    8000366e:	d82080e7          	jalr	-638(ra) # 800063ec <acquire>
  log.outstanding -= 1;
    80003672:	509c                	lw	a5,32(s1)
    80003674:	37fd                	addiw	a5,a5,-1
    80003676:	0007891b          	sext.w	s2,a5
    8000367a:	d09c                	sw	a5,32(s1)
  if(log.committing)
    8000367c:	50dc                	lw	a5,36(s1)
    8000367e:	efb9                	bnez	a5,800036dc <end_op+0x8e>
    panic("log.committing");
  if(log.outstanding == 0){
    80003680:	06091663          	bnez	s2,800036ec <end_op+0x9e>
    do_commit = 1;
    log.committing = 1;
    80003684:	00023497          	auipc	s1,0x23
    80003688:	2dc48493          	addi	s1,s1,732 # 80026960 <log>
    8000368c:	4785                	li	a5,1
    8000368e:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003690:	8526                	mv	a0,s1
    80003692:	00003097          	auipc	ra,0x3
    80003696:	e0e080e7          	jalr	-498(ra) # 800064a0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    8000369a:	54dc                	lw	a5,44(s1)
    8000369c:	06f04763          	bgtz	a5,8000370a <end_op+0xbc>
    acquire(&log.lock);
    800036a0:	00023497          	auipc	s1,0x23
    800036a4:	2c048493          	addi	s1,s1,704 # 80026960 <log>
    800036a8:	8526                	mv	a0,s1
    800036aa:	00003097          	auipc	ra,0x3
    800036ae:	d42080e7          	jalr	-702(ra) # 800063ec <acquire>
    log.committing = 0;
    800036b2:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800036b6:	8526                	mv	a0,s1
    800036b8:	ffffe097          	auipc	ra,0xffffe
    800036bc:	eb2080e7          	jalr	-334(ra) # 8000156a <wakeup>
    release(&log.lock);
    800036c0:	8526                	mv	a0,s1
    800036c2:	00003097          	auipc	ra,0x3
    800036c6:	dde080e7          	jalr	-546(ra) # 800064a0 <release>
}
    800036ca:	70e2                	ld	ra,56(sp)
    800036cc:	7442                	ld	s0,48(sp)
    800036ce:	74a2                	ld	s1,40(sp)
    800036d0:	7902                	ld	s2,32(sp)
    800036d2:	69e2                	ld	s3,24(sp)
    800036d4:	6a42                	ld	s4,16(sp)
    800036d6:	6aa2                	ld	s5,8(sp)
    800036d8:	6121                	addi	sp,sp,64
    800036da:	8082                	ret
    panic("log.committing");
    800036dc:	00005517          	auipc	a0,0x5
    800036e0:	f4450513          	addi	a0,a0,-188 # 80008620 <syscalls+0x1f0>
    800036e4:	00002097          	auipc	ra,0x2
    800036e8:	7be080e7          	jalr	1982(ra) # 80005ea2 <panic>
    wakeup(&log);
    800036ec:	00023497          	auipc	s1,0x23
    800036f0:	27448493          	addi	s1,s1,628 # 80026960 <log>
    800036f4:	8526                	mv	a0,s1
    800036f6:	ffffe097          	auipc	ra,0xffffe
    800036fa:	e74080e7          	jalr	-396(ra) # 8000156a <wakeup>
  release(&log.lock);
    800036fe:	8526                	mv	a0,s1
    80003700:	00003097          	auipc	ra,0x3
    80003704:	da0080e7          	jalr	-608(ra) # 800064a0 <release>
  if(do_commit){
    80003708:	b7c9                	j	800036ca <end_op+0x7c>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000370a:	00023a97          	auipc	s5,0x23
    8000370e:	286a8a93          	addi	s5,s5,646 # 80026990 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003712:	00023a17          	auipc	s4,0x23
    80003716:	24ea0a13          	addi	s4,s4,590 # 80026960 <log>
    8000371a:	018a2583          	lw	a1,24(s4)
    8000371e:	012585bb          	addw	a1,a1,s2
    80003722:	2585                	addiw	a1,a1,1
    80003724:	028a2503          	lw	a0,40(s4)
    80003728:	fffff097          	auipc	ra,0xfffff
    8000372c:	cca080e7          	jalr	-822(ra) # 800023f2 <bread>
    80003730:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003732:	000aa583          	lw	a1,0(s5)
    80003736:	028a2503          	lw	a0,40(s4)
    8000373a:	fffff097          	auipc	ra,0xfffff
    8000373e:	cb8080e7          	jalr	-840(ra) # 800023f2 <bread>
    80003742:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003744:	40000613          	li	a2,1024
    80003748:	05850593          	addi	a1,a0,88
    8000374c:	05848513          	addi	a0,s1,88
    80003750:	ffffd097          	auipc	ra,0xffffd
    80003754:	a88080e7          	jalr	-1400(ra) # 800001d8 <memmove>
    bwrite(to);  // write the log
    80003758:	8526                	mv	a0,s1
    8000375a:	fffff097          	auipc	ra,0xfffff
    8000375e:	d8a080e7          	jalr	-630(ra) # 800024e4 <bwrite>
    brelse(from);
    80003762:	854e                	mv	a0,s3
    80003764:	fffff097          	auipc	ra,0xfffff
    80003768:	dbe080e7          	jalr	-578(ra) # 80002522 <brelse>
    brelse(to);
    8000376c:	8526                	mv	a0,s1
    8000376e:	fffff097          	auipc	ra,0xfffff
    80003772:	db4080e7          	jalr	-588(ra) # 80002522 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003776:	2905                	addiw	s2,s2,1
    80003778:	0a91                	addi	s5,s5,4
    8000377a:	02ca2783          	lw	a5,44(s4)
    8000377e:	f8f94ee3          	blt	s2,a5,8000371a <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003782:	00000097          	auipc	ra,0x0
    80003786:	c6a080e7          	jalr	-918(ra) # 800033ec <write_head>
    install_trans(0); // Now install writes to home locations
    8000378a:	4501                	li	a0,0
    8000378c:	00000097          	auipc	ra,0x0
    80003790:	cda080e7          	jalr	-806(ra) # 80003466 <install_trans>
    log.lh.n = 0;
    80003794:	00023797          	auipc	a5,0x23
    80003798:	1e07ac23          	sw	zero,504(a5) # 8002698c <log+0x2c>
    write_head();    // Erase the transaction from the log
    8000379c:	00000097          	auipc	ra,0x0
    800037a0:	c50080e7          	jalr	-944(ra) # 800033ec <write_head>
    800037a4:	bdf5                	j	800036a0 <end_op+0x52>

00000000800037a6 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800037a6:	1101                	addi	sp,sp,-32
    800037a8:	ec06                	sd	ra,24(sp)
    800037aa:	e822                	sd	s0,16(sp)
    800037ac:	e426                	sd	s1,8(sp)
    800037ae:	e04a                	sd	s2,0(sp)
    800037b0:	1000                	addi	s0,sp,32
    800037b2:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800037b4:	00023917          	auipc	s2,0x23
    800037b8:	1ac90913          	addi	s2,s2,428 # 80026960 <log>
    800037bc:	854a                	mv	a0,s2
    800037be:	00003097          	auipc	ra,0x3
    800037c2:	c2e080e7          	jalr	-978(ra) # 800063ec <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800037c6:	02c92603          	lw	a2,44(s2)
    800037ca:	47f5                	li	a5,29
    800037cc:	06c7c563          	blt	a5,a2,80003836 <log_write+0x90>
    800037d0:	00023797          	auipc	a5,0x23
    800037d4:	1ac7a783          	lw	a5,428(a5) # 8002697c <log+0x1c>
    800037d8:	37fd                	addiw	a5,a5,-1
    800037da:	04f65e63          	bge	a2,a5,80003836 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800037de:	00023797          	auipc	a5,0x23
    800037e2:	1a27a783          	lw	a5,418(a5) # 80026980 <log+0x20>
    800037e6:	06f05063          	blez	a5,80003846 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800037ea:	4781                	li	a5,0
    800037ec:	06c05563          	blez	a2,80003856 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800037f0:	44cc                	lw	a1,12(s1)
    800037f2:	00023717          	auipc	a4,0x23
    800037f6:	19e70713          	addi	a4,a4,414 # 80026990 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800037fa:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800037fc:	4314                	lw	a3,0(a4)
    800037fe:	04b68c63          	beq	a3,a1,80003856 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80003802:	2785                	addiw	a5,a5,1
    80003804:	0711                	addi	a4,a4,4
    80003806:	fef61be3          	bne	a2,a5,800037fc <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    8000380a:	0621                	addi	a2,a2,8
    8000380c:	060a                	slli	a2,a2,0x2
    8000380e:	00023797          	auipc	a5,0x23
    80003812:	15278793          	addi	a5,a5,338 # 80026960 <log>
    80003816:	963e                	add	a2,a2,a5
    80003818:	44dc                	lw	a5,12(s1)
    8000381a:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    8000381c:	8526                	mv	a0,s1
    8000381e:	fffff097          	auipc	ra,0xfffff
    80003822:	da2080e7          	jalr	-606(ra) # 800025c0 <bpin>
    log.lh.n++;
    80003826:	00023717          	auipc	a4,0x23
    8000382a:	13a70713          	addi	a4,a4,314 # 80026960 <log>
    8000382e:	575c                	lw	a5,44(a4)
    80003830:	2785                	addiw	a5,a5,1
    80003832:	d75c                	sw	a5,44(a4)
    80003834:	a835                	j	80003870 <log_write+0xca>
    panic("too big a transaction");
    80003836:	00005517          	auipc	a0,0x5
    8000383a:	dfa50513          	addi	a0,a0,-518 # 80008630 <syscalls+0x200>
    8000383e:	00002097          	auipc	ra,0x2
    80003842:	664080e7          	jalr	1636(ra) # 80005ea2 <panic>
    panic("log_write outside of trans");
    80003846:	00005517          	auipc	a0,0x5
    8000384a:	e0250513          	addi	a0,a0,-510 # 80008648 <syscalls+0x218>
    8000384e:	00002097          	auipc	ra,0x2
    80003852:	654080e7          	jalr	1620(ra) # 80005ea2 <panic>
  log.lh.block[i] = b->blockno;
    80003856:	00878713          	addi	a4,a5,8
    8000385a:	00271693          	slli	a3,a4,0x2
    8000385e:	00023717          	auipc	a4,0x23
    80003862:	10270713          	addi	a4,a4,258 # 80026960 <log>
    80003866:	9736                	add	a4,a4,a3
    80003868:	44d4                	lw	a3,12(s1)
    8000386a:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    8000386c:	faf608e3          	beq	a2,a5,8000381c <log_write+0x76>
  }
  release(&log.lock);
    80003870:	00023517          	auipc	a0,0x23
    80003874:	0f050513          	addi	a0,a0,240 # 80026960 <log>
    80003878:	00003097          	auipc	ra,0x3
    8000387c:	c28080e7          	jalr	-984(ra) # 800064a0 <release>
}
    80003880:	60e2                	ld	ra,24(sp)
    80003882:	6442                	ld	s0,16(sp)
    80003884:	64a2                	ld	s1,8(sp)
    80003886:	6902                	ld	s2,0(sp)
    80003888:	6105                	addi	sp,sp,32
    8000388a:	8082                	ret

000000008000388c <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    8000388c:	1101                	addi	sp,sp,-32
    8000388e:	ec06                	sd	ra,24(sp)
    80003890:	e822                	sd	s0,16(sp)
    80003892:	e426                	sd	s1,8(sp)
    80003894:	e04a                	sd	s2,0(sp)
    80003896:	1000                	addi	s0,sp,32
    80003898:	84aa                	mv	s1,a0
    8000389a:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    8000389c:	00005597          	auipc	a1,0x5
    800038a0:	dcc58593          	addi	a1,a1,-564 # 80008668 <syscalls+0x238>
    800038a4:	0521                	addi	a0,a0,8
    800038a6:	00003097          	auipc	ra,0x3
    800038aa:	ab6080e7          	jalr	-1354(ra) # 8000635c <initlock>
  lk->name = name;
    800038ae:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800038b2:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800038b6:	0204a423          	sw	zero,40(s1)
}
    800038ba:	60e2                	ld	ra,24(sp)
    800038bc:	6442                	ld	s0,16(sp)
    800038be:	64a2                	ld	s1,8(sp)
    800038c0:	6902                	ld	s2,0(sp)
    800038c2:	6105                	addi	sp,sp,32
    800038c4:	8082                	ret

00000000800038c6 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800038c6:	1101                	addi	sp,sp,-32
    800038c8:	ec06                	sd	ra,24(sp)
    800038ca:	e822                	sd	s0,16(sp)
    800038cc:	e426                	sd	s1,8(sp)
    800038ce:	e04a                	sd	s2,0(sp)
    800038d0:	1000                	addi	s0,sp,32
    800038d2:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800038d4:	00850913          	addi	s2,a0,8
    800038d8:	854a                	mv	a0,s2
    800038da:	00003097          	auipc	ra,0x3
    800038de:	b12080e7          	jalr	-1262(ra) # 800063ec <acquire>
  while (lk->locked) {
    800038e2:	409c                	lw	a5,0(s1)
    800038e4:	cb89                	beqz	a5,800038f6 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800038e6:	85ca                	mv	a1,s2
    800038e8:	8526                	mv	a0,s1
    800038ea:	ffffe097          	auipc	ra,0xffffe
    800038ee:	c1c080e7          	jalr	-996(ra) # 80001506 <sleep>
  while (lk->locked) {
    800038f2:	409c                	lw	a5,0(s1)
    800038f4:	fbed                	bnez	a5,800038e6 <acquiresleep+0x20>
  }
  lk->locked = 1;
    800038f6:	4785                	li	a5,1
    800038f8:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800038fa:	ffffd097          	auipc	ra,0xffffd
    800038fe:	568080e7          	jalr	1384(ra) # 80000e62 <myproc>
    80003902:	591c                	lw	a5,48(a0)
    80003904:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003906:	854a                	mv	a0,s2
    80003908:	00003097          	auipc	ra,0x3
    8000390c:	b98080e7          	jalr	-1128(ra) # 800064a0 <release>
}
    80003910:	60e2                	ld	ra,24(sp)
    80003912:	6442                	ld	s0,16(sp)
    80003914:	64a2                	ld	s1,8(sp)
    80003916:	6902                	ld	s2,0(sp)
    80003918:	6105                	addi	sp,sp,32
    8000391a:	8082                	ret

000000008000391c <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    8000391c:	1101                	addi	sp,sp,-32
    8000391e:	ec06                	sd	ra,24(sp)
    80003920:	e822                	sd	s0,16(sp)
    80003922:	e426                	sd	s1,8(sp)
    80003924:	e04a                	sd	s2,0(sp)
    80003926:	1000                	addi	s0,sp,32
    80003928:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000392a:	00850913          	addi	s2,a0,8
    8000392e:	854a                	mv	a0,s2
    80003930:	00003097          	auipc	ra,0x3
    80003934:	abc080e7          	jalr	-1348(ra) # 800063ec <acquire>
  lk->locked = 0;
    80003938:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000393c:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003940:	8526                	mv	a0,s1
    80003942:	ffffe097          	auipc	ra,0xffffe
    80003946:	c28080e7          	jalr	-984(ra) # 8000156a <wakeup>
  release(&lk->lk);
    8000394a:	854a                	mv	a0,s2
    8000394c:	00003097          	auipc	ra,0x3
    80003950:	b54080e7          	jalr	-1196(ra) # 800064a0 <release>
}
    80003954:	60e2                	ld	ra,24(sp)
    80003956:	6442                	ld	s0,16(sp)
    80003958:	64a2                	ld	s1,8(sp)
    8000395a:	6902                	ld	s2,0(sp)
    8000395c:	6105                	addi	sp,sp,32
    8000395e:	8082                	ret

0000000080003960 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003960:	7179                	addi	sp,sp,-48
    80003962:	f406                	sd	ra,40(sp)
    80003964:	f022                	sd	s0,32(sp)
    80003966:	ec26                	sd	s1,24(sp)
    80003968:	e84a                	sd	s2,16(sp)
    8000396a:	e44e                	sd	s3,8(sp)
    8000396c:	1800                	addi	s0,sp,48
    8000396e:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003970:	00850913          	addi	s2,a0,8
    80003974:	854a                	mv	a0,s2
    80003976:	00003097          	auipc	ra,0x3
    8000397a:	a76080e7          	jalr	-1418(ra) # 800063ec <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    8000397e:	409c                	lw	a5,0(s1)
    80003980:	ef99                	bnez	a5,8000399e <holdingsleep+0x3e>
    80003982:	4481                	li	s1,0
  release(&lk->lk);
    80003984:	854a                	mv	a0,s2
    80003986:	00003097          	auipc	ra,0x3
    8000398a:	b1a080e7          	jalr	-1254(ra) # 800064a0 <release>
  return r;
}
    8000398e:	8526                	mv	a0,s1
    80003990:	70a2                	ld	ra,40(sp)
    80003992:	7402                	ld	s0,32(sp)
    80003994:	64e2                	ld	s1,24(sp)
    80003996:	6942                	ld	s2,16(sp)
    80003998:	69a2                	ld	s3,8(sp)
    8000399a:	6145                	addi	sp,sp,48
    8000399c:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    8000399e:	0284a983          	lw	s3,40(s1)
    800039a2:	ffffd097          	auipc	ra,0xffffd
    800039a6:	4c0080e7          	jalr	1216(ra) # 80000e62 <myproc>
    800039aa:	5904                	lw	s1,48(a0)
    800039ac:	413484b3          	sub	s1,s1,s3
    800039b0:	0014b493          	seqz	s1,s1
    800039b4:	bfc1                	j	80003984 <holdingsleep+0x24>

00000000800039b6 <fileinit>:
  struct file file[NFILE];
} ftable;

void
fileinit(void)
{
    800039b6:	1141                	addi	sp,sp,-16
    800039b8:	e406                	sd	ra,8(sp)
    800039ba:	e022                	sd	s0,0(sp)
    800039bc:	0800                	addi	s0,sp,16
  initlock(&ftable.lock, "ftable");
    800039be:	00005597          	auipc	a1,0x5
    800039c2:	cba58593          	addi	a1,a1,-838 # 80008678 <syscalls+0x248>
    800039c6:	00023517          	auipc	a0,0x23
    800039ca:	0e250513          	addi	a0,a0,226 # 80026aa8 <ftable>
    800039ce:	00003097          	auipc	ra,0x3
    800039d2:	98e080e7          	jalr	-1650(ra) # 8000635c <initlock>
}
    800039d6:	60a2                	ld	ra,8(sp)
    800039d8:	6402                	ld	s0,0(sp)
    800039da:	0141                	addi	sp,sp,16
    800039dc:	8082                	ret

00000000800039de <filealloc>:

// Allocate a file structure.
struct file*
filealloc(void)
{
    800039de:	1101                	addi	sp,sp,-32
    800039e0:	ec06                	sd	ra,24(sp)
    800039e2:	e822                	sd	s0,16(sp)
    800039e4:	e426                	sd	s1,8(sp)
    800039e6:	1000                	addi	s0,sp,32
  struct file *f;

  acquire(&ftable.lock);
    800039e8:	00023517          	auipc	a0,0x23
    800039ec:	0c050513          	addi	a0,a0,192 # 80026aa8 <ftable>
    800039f0:	00003097          	auipc	ra,0x3
    800039f4:	9fc080e7          	jalr	-1540(ra) # 800063ec <acquire>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    800039f8:	00023497          	auipc	s1,0x23
    800039fc:	0c848493          	addi	s1,s1,200 # 80026ac0 <ftable+0x18>
    80003a00:	00024717          	auipc	a4,0x24
    80003a04:	06070713          	addi	a4,a4,96 # 80027a60 <disk>
    if(f->ref == 0){
    80003a08:	40dc                	lw	a5,4(s1)
    80003a0a:	cf99                	beqz	a5,80003a28 <filealloc+0x4a>
  for(f = ftable.file; f < ftable.file + NFILE; f++){
    80003a0c:	02848493          	addi	s1,s1,40
    80003a10:	fee49ce3          	bne	s1,a4,80003a08 <filealloc+0x2a>
      f->ref = 1;
      release(&ftable.lock);
      return f;
    }
  }
  release(&ftable.lock);
    80003a14:	00023517          	auipc	a0,0x23
    80003a18:	09450513          	addi	a0,a0,148 # 80026aa8 <ftable>
    80003a1c:	00003097          	auipc	ra,0x3
    80003a20:	a84080e7          	jalr	-1404(ra) # 800064a0 <release>
  return 0;
    80003a24:	4481                	li	s1,0
    80003a26:	a819                	j	80003a3c <filealloc+0x5e>
      f->ref = 1;
    80003a28:	4785                	li	a5,1
    80003a2a:	c0dc                	sw	a5,4(s1)
      release(&ftable.lock);
    80003a2c:	00023517          	auipc	a0,0x23
    80003a30:	07c50513          	addi	a0,a0,124 # 80026aa8 <ftable>
    80003a34:	00003097          	auipc	ra,0x3
    80003a38:	a6c080e7          	jalr	-1428(ra) # 800064a0 <release>
}
    80003a3c:	8526                	mv	a0,s1
    80003a3e:	60e2                	ld	ra,24(sp)
    80003a40:	6442                	ld	s0,16(sp)
    80003a42:	64a2                	ld	s1,8(sp)
    80003a44:	6105                	addi	sp,sp,32
    80003a46:	8082                	ret

0000000080003a48 <filedup>:

// Increment ref count for file f.
struct file*
filedup(struct file *f)
{
    80003a48:	1101                	addi	sp,sp,-32
    80003a4a:	ec06                	sd	ra,24(sp)
    80003a4c:	e822                	sd	s0,16(sp)
    80003a4e:	e426                	sd	s1,8(sp)
    80003a50:	1000                	addi	s0,sp,32
    80003a52:	84aa                	mv	s1,a0
  acquire(&ftable.lock);
    80003a54:	00023517          	auipc	a0,0x23
    80003a58:	05450513          	addi	a0,a0,84 # 80026aa8 <ftable>
    80003a5c:	00003097          	auipc	ra,0x3
    80003a60:	990080e7          	jalr	-1648(ra) # 800063ec <acquire>
  if(f->ref < 1)
    80003a64:	40dc                	lw	a5,4(s1)
    80003a66:	02f05263          	blez	a5,80003a8a <filedup+0x42>
    panic("filedup");
  f->ref++;
    80003a6a:	2785                	addiw	a5,a5,1
    80003a6c:	c0dc                	sw	a5,4(s1)
  release(&ftable.lock);
    80003a6e:	00023517          	auipc	a0,0x23
    80003a72:	03a50513          	addi	a0,a0,58 # 80026aa8 <ftable>
    80003a76:	00003097          	auipc	ra,0x3
    80003a7a:	a2a080e7          	jalr	-1494(ra) # 800064a0 <release>
  return f;
}
    80003a7e:	8526                	mv	a0,s1
    80003a80:	60e2                	ld	ra,24(sp)
    80003a82:	6442                	ld	s0,16(sp)
    80003a84:	64a2                	ld	s1,8(sp)
    80003a86:	6105                	addi	sp,sp,32
    80003a88:	8082                	ret
    panic("filedup");
    80003a8a:	00005517          	auipc	a0,0x5
    80003a8e:	bf650513          	addi	a0,a0,-1034 # 80008680 <syscalls+0x250>
    80003a92:	00002097          	auipc	ra,0x2
    80003a96:	410080e7          	jalr	1040(ra) # 80005ea2 <panic>

0000000080003a9a <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void
fileclose(struct file *f)
{
    80003a9a:	7139                	addi	sp,sp,-64
    80003a9c:	fc06                	sd	ra,56(sp)
    80003a9e:	f822                	sd	s0,48(sp)
    80003aa0:	f426                	sd	s1,40(sp)
    80003aa2:	f04a                	sd	s2,32(sp)
    80003aa4:	ec4e                	sd	s3,24(sp)
    80003aa6:	e852                	sd	s4,16(sp)
    80003aa8:	e456                	sd	s5,8(sp)
    80003aaa:	0080                	addi	s0,sp,64
    80003aac:	84aa                	mv	s1,a0
  struct file ff;

  acquire(&ftable.lock);
    80003aae:	00023517          	auipc	a0,0x23
    80003ab2:	ffa50513          	addi	a0,a0,-6 # 80026aa8 <ftable>
    80003ab6:	00003097          	auipc	ra,0x3
    80003aba:	936080e7          	jalr	-1738(ra) # 800063ec <acquire>
  if(f->ref < 1)
    80003abe:	40dc                	lw	a5,4(s1)
    80003ac0:	06f05163          	blez	a5,80003b22 <fileclose+0x88>
    panic("fileclose");
  if(--f->ref > 0){
    80003ac4:	37fd                	addiw	a5,a5,-1
    80003ac6:	0007871b          	sext.w	a4,a5
    80003aca:	c0dc                	sw	a5,4(s1)
    80003acc:	06e04363          	bgtz	a4,80003b32 <fileclose+0x98>
    release(&ftable.lock);
    return;
  }
  ff = *f;
    80003ad0:	0004a903          	lw	s2,0(s1)
    80003ad4:	0094ca83          	lbu	s5,9(s1)
    80003ad8:	0104ba03          	ld	s4,16(s1)
    80003adc:	0184b983          	ld	s3,24(s1)
  f->ref = 0;
    80003ae0:	0004a223          	sw	zero,4(s1)
  f->type = FD_NONE;
    80003ae4:	0004a023          	sw	zero,0(s1)
  release(&ftable.lock);
    80003ae8:	00023517          	auipc	a0,0x23
    80003aec:	fc050513          	addi	a0,a0,-64 # 80026aa8 <ftable>
    80003af0:	00003097          	auipc	ra,0x3
    80003af4:	9b0080e7          	jalr	-1616(ra) # 800064a0 <release>

  if(ff.type == FD_PIPE){
    80003af8:	4785                	li	a5,1
    80003afa:	04f90d63          	beq	s2,a5,80003b54 <fileclose+0xba>
    pipeclose(ff.pipe, ff.writable);
  } else if(ff.type == FD_INODE || ff.type == FD_DEVICE){
    80003afe:	3979                	addiw	s2,s2,-2
    80003b00:	4785                	li	a5,1
    80003b02:	0527e063          	bltu	a5,s2,80003b42 <fileclose+0xa8>
    begin_op();
    80003b06:	00000097          	auipc	ra,0x0
    80003b0a:	ac8080e7          	jalr	-1336(ra) # 800035ce <begin_op>
    iput(ff.ip);
    80003b0e:	854e                	mv	a0,s3
    80003b10:	fffff097          	auipc	ra,0xfffff
    80003b14:	2b6080e7          	jalr	694(ra) # 80002dc6 <iput>
    end_op();
    80003b18:	00000097          	auipc	ra,0x0
    80003b1c:	b36080e7          	jalr	-1226(ra) # 8000364e <end_op>
    80003b20:	a00d                	j	80003b42 <fileclose+0xa8>
    panic("fileclose");
    80003b22:	00005517          	auipc	a0,0x5
    80003b26:	b6650513          	addi	a0,a0,-1178 # 80008688 <syscalls+0x258>
    80003b2a:	00002097          	auipc	ra,0x2
    80003b2e:	378080e7          	jalr	888(ra) # 80005ea2 <panic>
    release(&ftable.lock);
    80003b32:	00023517          	auipc	a0,0x23
    80003b36:	f7650513          	addi	a0,a0,-138 # 80026aa8 <ftable>
    80003b3a:	00003097          	auipc	ra,0x3
    80003b3e:	966080e7          	jalr	-1690(ra) # 800064a0 <release>
  }
}
    80003b42:	70e2                	ld	ra,56(sp)
    80003b44:	7442                	ld	s0,48(sp)
    80003b46:	74a2                	ld	s1,40(sp)
    80003b48:	7902                	ld	s2,32(sp)
    80003b4a:	69e2                	ld	s3,24(sp)
    80003b4c:	6a42                	ld	s4,16(sp)
    80003b4e:	6aa2                	ld	s5,8(sp)
    80003b50:	6121                	addi	sp,sp,64
    80003b52:	8082                	ret
    pipeclose(ff.pipe, ff.writable);
    80003b54:	85d6                	mv	a1,s5
    80003b56:	8552                	mv	a0,s4
    80003b58:	00000097          	auipc	ra,0x0
    80003b5c:	3a6080e7          	jalr	934(ra) # 80003efe <pipeclose>
    80003b60:	b7cd                	j	80003b42 <fileclose+0xa8>

0000000080003b62 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int
filestat(struct file *f, uint64 addr)
{
    80003b62:	715d                	addi	sp,sp,-80
    80003b64:	e486                	sd	ra,72(sp)
    80003b66:	e0a2                	sd	s0,64(sp)
    80003b68:	fc26                	sd	s1,56(sp)
    80003b6a:	f84a                	sd	s2,48(sp)
    80003b6c:	f44e                	sd	s3,40(sp)
    80003b6e:	0880                	addi	s0,sp,80
    80003b70:	84aa                	mv	s1,a0
    80003b72:	89ae                	mv	s3,a1
  struct proc *p = myproc();
    80003b74:	ffffd097          	auipc	ra,0xffffd
    80003b78:	2ee080e7          	jalr	750(ra) # 80000e62 <myproc>
  struct stat st;
  
  if(f->type == FD_INODE || f->type == FD_DEVICE){
    80003b7c:	409c                	lw	a5,0(s1)
    80003b7e:	37f9                	addiw	a5,a5,-2
    80003b80:	4705                	li	a4,1
    80003b82:	04f76763          	bltu	a4,a5,80003bd0 <filestat+0x6e>
    80003b86:	892a                	mv	s2,a0
    ilock(f->ip);
    80003b88:	6c88                	ld	a0,24(s1)
    80003b8a:	fffff097          	auipc	ra,0xfffff
    80003b8e:	082080e7          	jalr	130(ra) # 80002c0c <ilock>
    stati(f->ip, &st);
    80003b92:	fb840593          	addi	a1,s0,-72
    80003b96:	6c88                	ld	a0,24(s1)
    80003b98:	fffff097          	auipc	ra,0xfffff
    80003b9c:	2fe080e7          	jalr	766(ra) # 80002e96 <stati>
    iunlock(f->ip);
    80003ba0:	6c88                	ld	a0,24(s1)
    80003ba2:	fffff097          	auipc	ra,0xfffff
    80003ba6:	12c080e7          	jalr	300(ra) # 80002cce <iunlock>
    if(copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003baa:	46e1                	li	a3,24
    80003bac:	fb840613          	addi	a2,s0,-72
    80003bb0:	85ce                	mv	a1,s3
    80003bb2:	05093503          	ld	a0,80(s2)
    80003bb6:	ffffd097          	auipc	ra,0xffffd
    80003bba:	f6a080e7          	jalr	-150(ra) # 80000b20 <copyout>
    80003bbe:	41f5551b          	sraiw	a0,a0,0x1f
      return -1;
    return 0;
  }
  return -1;
}
    80003bc2:	60a6                	ld	ra,72(sp)
    80003bc4:	6406                	ld	s0,64(sp)
    80003bc6:	74e2                	ld	s1,56(sp)
    80003bc8:	7942                	ld	s2,48(sp)
    80003bca:	79a2                	ld	s3,40(sp)
    80003bcc:	6161                	addi	sp,sp,80
    80003bce:	8082                	ret
  return -1;
    80003bd0:	557d                	li	a0,-1
    80003bd2:	bfc5                	j	80003bc2 <filestat+0x60>

0000000080003bd4 <mapfile>:

void mapfile(struct file * f, char * mem, int offset){
    80003bd4:	7179                	addi	sp,sp,-48
    80003bd6:	f406                	sd	ra,40(sp)
    80003bd8:	f022                	sd	s0,32(sp)
    80003bda:	ec26                	sd	s1,24(sp)
    80003bdc:	e84a                	sd	s2,16(sp)
    80003bde:	e44e                	sd	s3,8(sp)
    80003be0:	1800                	addi	s0,sp,48
    80003be2:	84aa                	mv	s1,a0
    80003be4:	89ae                	mv	s3,a1
    80003be6:	8932                	mv	s2,a2
  printf("off %d\n", offset);
    80003be8:	85b2                	mv	a1,a2
    80003bea:	00005517          	auipc	a0,0x5
    80003bee:	aae50513          	addi	a0,a0,-1362 # 80008698 <syscalls+0x268>
    80003bf2:	00002097          	auipc	ra,0x2
    80003bf6:	2fa080e7          	jalr	762(ra) # 80005eec <printf>
  ilock(f->ip);
    80003bfa:	6c88                	ld	a0,24(s1)
    80003bfc:	fffff097          	auipc	ra,0xfffff
    80003c00:	010080e7          	jalr	16(ra) # 80002c0c <ilock>
  readi(f->ip, 0, (uint64) mem, offset, PGSIZE);
    80003c04:	6705                	lui	a4,0x1
    80003c06:	86ca                	mv	a3,s2
    80003c08:	864e                	mv	a2,s3
    80003c0a:	4581                	li	a1,0
    80003c0c:	6c88                	ld	a0,24(s1)
    80003c0e:	fffff097          	auipc	ra,0xfffff
    80003c12:	2b2080e7          	jalr	690(ra) # 80002ec0 <readi>
  iunlock(f->ip);
    80003c16:	6c88                	ld	a0,24(s1)
    80003c18:	fffff097          	auipc	ra,0xfffff
    80003c1c:	0b6080e7          	jalr	182(ra) # 80002cce <iunlock>
}
    80003c20:	70a2                	ld	ra,40(sp)
    80003c22:	7402                	ld	s0,32(sp)
    80003c24:	64e2                	ld	s1,24(sp)
    80003c26:	6942                	ld	s2,16(sp)
    80003c28:	69a2                	ld	s3,8(sp)
    80003c2a:	6145                	addi	sp,sp,48
    80003c2c:	8082                	ret

0000000080003c2e <fileread>:

// Read from file f.
// addr is a user virtual address.
int
fileread(struct file *f, uint64 addr, int n)
{
    80003c2e:	7179                	addi	sp,sp,-48
    80003c30:	f406                	sd	ra,40(sp)
    80003c32:	f022                	sd	s0,32(sp)
    80003c34:	ec26                	sd	s1,24(sp)
    80003c36:	e84a                	sd	s2,16(sp)
    80003c38:	e44e                	sd	s3,8(sp)
    80003c3a:	1800                	addi	s0,sp,48
  int r = 0;

  if(f->readable == 0)
    80003c3c:	00854783          	lbu	a5,8(a0)
    80003c40:	c3d5                	beqz	a5,80003ce4 <fileread+0xb6>
    80003c42:	84aa                	mv	s1,a0
    80003c44:	89ae                	mv	s3,a1
    80003c46:	8932                	mv	s2,a2
    return -1;

  if(f->type == FD_PIPE){
    80003c48:	411c                	lw	a5,0(a0)
    80003c4a:	4705                	li	a4,1
    80003c4c:	04e78963          	beq	a5,a4,80003c9e <fileread+0x70>
    r = piperead(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003c50:	470d                	li	a4,3
    80003c52:	04e78d63          	beq	a5,a4,80003cac <fileread+0x7e>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
      return -1;
    r = devsw[f->major].read(1, addr, n);
  } else if(f->type == FD_INODE){
    80003c56:	4709                	li	a4,2
    80003c58:	06e79e63          	bne	a5,a4,80003cd4 <fileread+0xa6>
    ilock(f->ip);
    80003c5c:	6d08                	ld	a0,24(a0)
    80003c5e:	fffff097          	auipc	ra,0xfffff
    80003c62:	fae080e7          	jalr	-82(ra) # 80002c0c <ilock>
    if((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003c66:	874a                	mv	a4,s2
    80003c68:	5094                	lw	a3,32(s1)
    80003c6a:	864e                	mv	a2,s3
    80003c6c:	4585                	li	a1,1
    80003c6e:	6c88                	ld	a0,24(s1)
    80003c70:	fffff097          	auipc	ra,0xfffff
    80003c74:	250080e7          	jalr	592(ra) # 80002ec0 <readi>
    80003c78:	892a                	mv	s2,a0
    80003c7a:	00a05563          	blez	a0,80003c84 <fileread+0x56>
      f->off += r;
    80003c7e:	509c                	lw	a5,32(s1)
    80003c80:	9fa9                	addw	a5,a5,a0
    80003c82:	d09c                	sw	a5,32(s1)
    iunlock(f->ip);
    80003c84:	6c88                	ld	a0,24(s1)
    80003c86:	fffff097          	auipc	ra,0xfffff
    80003c8a:	048080e7          	jalr	72(ra) # 80002cce <iunlock>
  } else {
    panic("fileread");
  }

  return r;
}
    80003c8e:	854a                	mv	a0,s2
    80003c90:	70a2                	ld	ra,40(sp)
    80003c92:	7402                	ld	s0,32(sp)
    80003c94:	64e2                	ld	s1,24(sp)
    80003c96:	6942                	ld	s2,16(sp)
    80003c98:	69a2                	ld	s3,8(sp)
    80003c9a:	6145                	addi	sp,sp,48
    80003c9c:	8082                	ret
    r = piperead(f->pipe, addr, n);
    80003c9e:	6908                	ld	a0,16(a0)
    80003ca0:	00000097          	auipc	ra,0x0
    80003ca4:	3ce080e7          	jalr	974(ra) # 8000406e <piperead>
    80003ca8:	892a                	mv	s2,a0
    80003caa:	b7d5                	j	80003c8e <fileread+0x60>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003cac:	02451783          	lh	a5,36(a0)
    80003cb0:	03079693          	slli	a3,a5,0x30
    80003cb4:	92c1                	srli	a3,a3,0x30
    80003cb6:	4725                	li	a4,9
    80003cb8:	02d76863          	bltu	a4,a3,80003ce8 <fileread+0xba>
    80003cbc:	0792                	slli	a5,a5,0x4
    80003cbe:	00023717          	auipc	a4,0x23
    80003cc2:	d4a70713          	addi	a4,a4,-694 # 80026a08 <devsw>
    80003cc6:	97ba                	add	a5,a5,a4
    80003cc8:	639c                	ld	a5,0(a5)
    80003cca:	c38d                	beqz	a5,80003cec <fileread+0xbe>
    r = devsw[f->major].read(1, addr, n);
    80003ccc:	4505                	li	a0,1
    80003cce:	9782                	jalr	a5
    80003cd0:	892a                	mv	s2,a0
    80003cd2:	bf75                	j	80003c8e <fileread+0x60>
    panic("fileread");
    80003cd4:	00005517          	auipc	a0,0x5
    80003cd8:	9cc50513          	addi	a0,a0,-1588 # 800086a0 <syscalls+0x270>
    80003cdc:	00002097          	auipc	ra,0x2
    80003ce0:	1c6080e7          	jalr	454(ra) # 80005ea2 <panic>
    return -1;
    80003ce4:	597d                	li	s2,-1
    80003ce6:	b765                	j	80003c8e <fileread+0x60>
      return -1;
    80003ce8:	597d                	li	s2,-1
    80003cea:	b755                	j	80003c8e <fileread+0x60>
    80003cec:	597d                	li	s2,-1
    80003cee:	b745                	j	80003c8e <fileread+0x60>

0000000080003cf0 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int
filewrite(struct file *f, uint64 addr, int n)
{
    80003cf0:	715d                	addi	sp,sp,-80
    80003cf2:	e486                	sd	ra,72(sp)
    80003cf4:	e0a2                	sd	s0,64(sp)
    80003cf6:	fc26                	sd	s1,56(sp)
    80003cf8:	f84a                	sd	s2,48(sp)
    80003cfa:	f44e                	sd	s3,40(sp)
    80003cfc:	f052                	sd	s4,32(sp)
    80003cfe:	ec56                	sd	s5,24(sp)
    80003d00:	e85a                	sd	s6,16(sp)
    80003d02:	e45e                	sd	s7,8(sp)
    80003d04:	e062                	sd	s8,0(sp)
    80003d06:	0880                	addi	s0,sp,80
  int r, ret = 0;

  if(f->writable == 0)
    80003d08:	00954783          	lbu	a5,9(a0)
    80003d0c:	10078663          	beqz	a5,80003e18 <filewrite+0x128>
    80003d10:	892a                	mv	s2,a0
    80003d12:	8aae                	mv	s5,a1
    80003d14:	8a32                	mv	s4,a2
    return -1;

  if(f->type == FD_PIPE){
    80003d16:	411c                	lw	a5,0(a0)
    80003d18:	4705                	li	a4,1
    80003d1a:	02e78263          	beq	a5,a4,80003d3e <filewrite+0x4e>
    ret = pipewrite(f->pipe, addr, n);
  } else if(f->type == FD_DEVICE){
    80003d1e:	470d                	li	a4,3
    80003d20:	02e78663          	beq	a5,a4,80003d4c <filewrite+0x5c>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
      return -1;
    ret = devsw[f->major].write(1, addr, n);
  } else if(f->type == FD_INODE){
    80003d24:	4709                	li	a4,2
    80003d26:	0ee79163          	bne	a5,a4,80003e08 <filewrite+0x118>
    // and 2 blocks of slop for non-aligned writes.
    // this really belongs lower down, since writei()
    // might be writing a device like the console.
    int max = ((MAXOPBLOCKS-1-1-2) / 2) * BSIZE;
    int i = 0;
    while(i < n){
    80003d2a:	0ac05d63          	blez	a2,80003de4 <filewrite+0xf4>
    int i = 0;
    80003d2e:	4981                	li	s3,0
    80003d30:	6b05                	lui	s6,0x1
    80003d32:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003d36:	6b85                	lui	s7,0x1
    80003d38:	c00b8b9b          	addiw	s7,s7,-1024
    80003d3c:	a861                	j	80003dd4 <filewrite+0xe4>
    ret = pipewrite(f->pipe, addr, n);
    80003d3e:	6908                	ld	a0,16(a0)
    80003d40:	00000097          	auipc	ra,0x0
    80003d44:	22e080e7          	jalr	558(ra) # 80003f6e <pipewrite>
    80003d48:	8a2a                	mv	s4,a0
    80003d4a:	a045                	j	80003dea <filewrite+0xfa>
    if(f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003d4c:	02451783          	lh	a5,36(a0)
    80003d50:	03079693          	slli	a3,a5,0x30
    80003d54:	92c1                	srli	a3,a3,0x30
    80003d56:	4725                	li	a4,9
    80003d58:	0cd76263          	bltu	a4,a3,80003e1c <filewrite+0x12c>
    80003d5c:	0792                	slli	a5,a5,0x4
    80003d5e:	00023717          	auipc	a4,0x23
    80003d62:	caa70713          	addi	a4,a4,-854 # 80026a08 <devsw>
    80003d66:	97ba                	add	a5,a5,a4
    80003d68:	679c                	ld	a5,8(a5)
    80003d6a:	cbdd                	beqz	a5,80003e20 <filewrite+0x130>
    ret = devsw[f->major].write(1, addr, n);
    80003d6c:	4505                	li	a0,1
    80003d6e:	9782                	jalr	a5
    80003d70:	8a2a                	mv	s4,a0
    80003d72:	a8a5                	j	80003dea <filewrite+0xfa>
    80003d74:	00048c1b          	sext.w	s8,s1
      int n1 = n - i;
      if(n1 > max)
        n1 = max;

      begin_op();
    80003d78:	00000097          	auipc	ra,0x0
    80003d7c:	856080e7          	jalr	-1962(ra) # 800035ce <begin_op>
      ilock(f->ip);
    80003d80:	01893503          	ld	a0,24(s2)
    80003d84:	fffff097          	auipc	ra,0xfffff
    80003d88:	e88080e7          	jalr	-376(ra) # 80002c0c <ilock>
      if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003d8c:	8762                	mv	a4,s8
    80003d8e:	02092683          	lw	a3,32(s2)
    80003d92:	01598633          	add	a2,s3,s5
    80003d96:	4585                	li	a1,1
    80003d98:	01893503          	ld	a0,24(s2)
    80003d9c:	fffff097          	auipc	ra,0xfffff
    80003da0:	21c080e7          	jalr	540(ra) # 80002fb8 <writei>
    80003da4:	84aa                	mv	s1,a0
    80003da6:	00a05763          	blez	a0,80003db4 <filewrite+0xc4>
        f->off += r;
    80003daa:	02092783          	lw	a5,32(s2)
    80003dae:	9fa9                	addw	a5,a5,a0
    80003db0:	02f92023          	sw	a5,32(s2)
      iunlock(f->ip);
    80003db4:	01893503          	ld	a0,24(s2)
    80003db8:	fffff097          	auipc	ra,0xfffff
    80003dbc:	f16080e7          	jalr	-234(ra) # 80002cce <iunlock>
      end_op();
    80003dc0:	00000097          	auipc	ra,0x0
    80003dc4:	88e080e7          	jalr	-1906(ra) # 8000364e <end_op>

      if(r != n1){
    80003dc8:	009c1f63          	bne	s8,s1,80003de6 <filewrite+0xf6>
        // error from writei
        break;
      }
      i += r;
    80003dcc:	013489bb          	addw	s3,s1,s3
    while(i < n){
    80003dd0:	0149db63          	bge	s3,s4,80003de6 <filewrite+0xf6>
      int n1 = n - i;
    80003dd4:	413a07bb          	subw	a5,s4,s3
      if(n1 > max)
    80003dd8:	84be                	mv	s1,a5
    80003dda:	2781                	sext.w	a5,a5
    80003ddc:	f8fb5ce3          	bge	s6,a5,80003d74 <filewrite+0x84>
    80003de0:	84de                	mv	s1,s7
    80003de2:	bf49                	j	80003d74 <filewrite+0x84>
    int i = 0;
    80003de4:	4981                	li	s3,0
    }
    ret = (i == n ? n : -1);
    80003de6:	013a1f63          	bne	s4,s3,80003e04 <filewrite+0x114>
  } else {
    panic("filewrite");
  }

  return ret;
}
    80003dea:	8552                	mv	a0,s4
    80003dec:	60a6                	ld	ra,72(sp)
    80003dee:	6406                	ld	s0,64(sp)
    80003df0:	74e2                	ld	s1,56(sp)
    80003df2:	7942                	ld	s2,48(sp)
    80003df4:	79a2                	ld	s3,40(sp)
    80003df6:	7a02                	ld	s4,32(sp)
    80003df8:	6ae2                	ld	s5,24(sp)
    80003dfa:	6b42                	ld	s6,16(sp)
    80003dfc:	6ba2                	ld	s7,8(sp)
    80003dfe:	6c02                	ld	s8,0(sp)
    80003e00:	6161                	addi	sp,sp,80
    80003e02:	8082                	ret
    ret = (i == n ? n : -1);
    80003e04:	5a7d                	li	s4,-1
    80003e06:	b7d5                	j	80003dea <filewrite+0xfa>
    panic("filewrite");
    80003e08:	00005517          	auipc	a0,0x5
    80003e0c:	8a850513          	addi	a0,a0,-1880 # 800086b0 <syscalls+0x280>
    80003e10:	00002097          	auipc	ra,0x2
    80003e14:	092080e7          	jalr	146(ra) # 80005ea2 <panic>
    return -1;
    80003e18:	5a7d                	li	s4,-1
    80003e1a:	bfc1                	j	80003dea <filewrite+0xfa>
      return -1;
    80003e1c:	5a7d                	li	s4,-1
    80003e1e:	b7f1                	j	80003dea <filewrite+0xfa>
    80003e20:	5a7d                	li	s4,-1
    80003e22:	b7e1                	j	80003dea <filewrite+0xfa>

0000000080003e24 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003e24:	7179                	addi	sp,sp,-48
    80003e26:	f406                	sd	ra,40(sp)
    80003e28:	f022                	sd	s0,32(sp)
    80003e2a:	ec26                	sd	s1,24(sp)
    80003e2c:	e84a                	sd	s2,16(sp)
    80003e2e:	e44e                	sd	s3,8(sp)
    80003e30:	e052                	sd	s4,0(sp)
    80003e32:	1800                	addi	s0,sp,48
    80003e34:	84aa                	mv	s1,a0
    80003e36:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003e38:	0005b023          	sd	zero,0(a1)
    80003e3c:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003e40:	00000097          	auipc	ra,0x0
    80003e44:	b9e080e7          	jalr	-1122(ra) # 800039de <filealloc>
    80003e48:	e088                	sd	a0,0(s1)
    80003e4a:	c551                	beqz	a0,80003ed6 <pipealloc+0xb2>
    80003e4c:	00000097          	auipc	ra,0x0
    80003e50:	b92080e7          	jalr	-1134(ra) # 800039de <filealloc>
    80003e54:	00aa3023          	sd	a0,0(s4)
    80003e58:	c92d                	beqz	a0,80003eca <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003e5a:	ffffc097          	auipc	ra,0xffffc
    80003e5e:	2be080e7          	jalr	702(ra) # 80000118 <kalloc>
    80003e62:	892a                	mv	s2,a0
    80003e64:	c125                	beqz	a0,80003ec4 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003e66:	4985                	li	s3,1
    80003e68:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003e6c:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003e70:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003e74:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003e78:	00005597          	auipc	a1,0x5
    80003e7c:	84858593          	addi	a1,a1,-1976 # 800086c0 <syscalls+0x290>
    80003e80:	00002097          	auipc	ra,0x2
    80003e84:	4dc080e7          	jalr	1244(ra) # 8000635c <initlock>
  (*f0)->type = FD_PIPE;
    80003e88:	609c                	ld	a5,0(s1)
    80003e8a:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003e8e:	609c                	ld	a5,0(s1)
    80003e90:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003e94:	609c                	ld	a5,0(s1)
    80003e96:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003e9a:	609c                	ld	a5,0(s1)
    80003e9c:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003ea0:	000a3783          	ld	a5,0(s4)
    80003ea4:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003ea8:	000a3783          	ld	a5,0(s4)
    80003eac:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003eb0:	000a3783          	ld	a5,0(s4)
    80003eb4:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003eb8:	000a3783          	ld	a5,0(s4)
    80003ebc:	0127b823          	sd	s2,16(a5)
  return 0;
    80003ec0:	4501                	li	a0,0
    80003ec2:	a025                	j	80003eea <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003ec4:	6088                	ld	a0,0(s1)
    80003ec6:	e501                	bnez	a0,80003ece <pipealloc+0xaa>
    80003ec8:	a039                	j	80003ed6 <pipealloc+0xb2>
    80003eca:	6088                	ld	a0,0(s1)
    80003ecc:	c51d                	beqz	a0,80003efa <pipealloc+0xd6>
    fileclose(*f0);
    80003ece:	00000097          	auipc	ra,0x0
    80003ed2:	bcc080e7          	jalr	-1076(ra) # 80003a9a <fileclose>
  if(*f1)
    80003ed6:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003eda:	557d                	li	a0,-1
  if(*f1)
    80003edc:	c799                	beqz	a5,80003eea <pipealloc+0xc6>
    fileclose(*f1);
    80003ede:	853e                	mv	a0,a5
    80003ee0:	00000097          	auipc	ra,0x0
    80003ee4:	bba080e7          	jalr	-1094(ra) # 80003a9a <fileclose>
  return -1;
    80003ee8:	557d                	li	a0,-1
}
    80003eea:	70a2                	ld	ra,40(sp)
    80003eec:	7402                	ld	s0,32(sp)
    80003eee:	64e2                	ld	s1,24(sp)
    80003ef0:	6942                	ld	s2,16(sp)
    80003ef2:	69a2                	ld	s3,8(sp)
    80003ef4:	6a02                	ld	s4,0(sp)
    80003ef6:	6145                	addi	sp,sp,48
    80003ef8:	8082                	ret
  return -1;
    80003efa:	557d                	li	a0,-1
    80003efc:	b7fd                	j	80003eea <pipealloc+0xc6>

0000000080003efe <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003efe:	1101                	addi	sp,sp,-32
    80003f00:	ec06                	sd	ra,24(sp)
    80003f02:	e822                	sd	s0,16(sp)
    80003f04:	e426                	sd	s1,8(sp)
    80003f06:	e04a                	sd	s2,0(sp)
    80003f08:	1000                	addi	s0,sp,32
    80003f0a:	84aa                	mv	s1,a0
    80003f0c:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003f0e:	00002097          	auipc	ra,0x2
    80003f12:	4de080e7          	jalr	1246(ra) # 800063ec <acquire>
  if(writable){
    80003f16:	02090d63          	beqz	s2,80003f50 <pipeclose+0x52>
    pi->writeopen = 0;
    80003f1a:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003f1e:	21848513          	addi	a0,s1,536
    80003f22:	ffffd097          	auipc	ra,0xffffd
    80003f26:	648080e7          	jalr	1608(ra) # 8000156a <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003f2a:	2204b783          	ld	a5,544(s1)
    80003f2e:	eb95                	bnez	a5,80003f62 <pipeclose+0x64>
    release(&pi->lock);
    80003f30:	8526                	mv	a0,s1
    80003f32:	00002097          	auipc	ra,0x2
    80003f36:	56e080e7          	jalr	1390(ra) # 800064a0 <release>
    kfree((char*)pi);
    80003f3a:	8526                	mv	a0,s1
    80003f3c:	ffffc097          	auipc	ra,0xffffc
    80003f40:	0e0080e7          	jalr	224(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003f44:	60e2                	ld	ra,24(sp)
    80003f46:	6442                	ld	s0,16(sp)
    80003f48:	64a2                	ld	s1,8(sp)
    80003f4a:	6902                	ld	s2,0(sp)
    80003f4c:	6105                	addi	sp,sp,32
    80003f4e:	8082                	ret
    pi->readopen = 0;
    80003f50:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003f54:	21c48513          	addi	a0,s1,540
    80003f58:	ffffd097          	auipc	ra,0xffffd
    80003f5c:	612080e7          	jalr	1554(ra) # 8000156a <wakeup>
    80003f60:	b7e9                	j	80003f2a <pipeclose+0x2c>
    release(&pi->lock);
    80003f62:	8526                	mv	a0,s1
    80003f64:	00002097          	auipc	ra,0x2
    80003f68:	53c080e7          	jalr	1340(ra) # 800064a0 <release>
}
    80003f6c:	bfe1                	j	80003f44 <pipeclose+0x46>

0000000080003f6e <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003f6e:	7159                	addi	sp,sp,-112
    80003f70:	f486                	sd	ra,104(sp)
    80003f72:	f0a2                	sd	s0,96(sp)
    80003f74:	eca6                	sd	s1,88(sp)
    80003f76:	e8ca                	sd	s2,80(sp)
    80003f78:	e4ce                	sd	s3,72(sp)
    80003f7a:	e0d2                	sd	s4,64(sp)
    80003f7c:	fc56                	sd	s5,56(sp)
    80003f7e:	f85a                	sd	s6,48(sp)
    80003f80:	f45e                	sd	s7,40(sp)
    80003f82:	f062                	sd	s8,32(sp)
    80003f84:	ec66                	sd	s9,24(sp)
    80003f86:	1880                	addi	s0,sp,112
    80003f88:	84aa                	mv	s1,a0
    80003f8a:	8aae                	mv	s5,a1
    80003f8c:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003f8e:	ffffd097          	auipc	ra,0xffffd
    80003f92:	ed4080e7          	jalr	-300(ra) # 80000e62 <myproc>
    80003f96:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003f98:	8526                	mv	a0,s1
    80003f9a:	00002097          	auipc	ra,0x2
    80003f9e:	452080e7          	jalr	1106(ra) # 800063ec <acquire>
  while(i < n){
    80003fa2:	0d405463          	blez	s4,8000406a <pipewrite+0xfc>
    80003fa6:	8ba6                	mv	s7,s1
  int i = 0;
    80003fa8:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003faa:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003fac:	21848c93          	addi	s9,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003fb0:	21c48c13          	addi	s8,s1,540
    80003fb4:	a08d                	j	80004016 <pipewrite+0xa8>
      release(&pi->lock);
    80003fb6:	8526                	mv	a0,s1
    80003fb8:	00002097          	auipc	ra,0x2
    80003fbc:	4e8080e7          	jalr	1256(ra) # 800064a0 <release>
      return -1;
    80003fc0:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003fc2:	854a                	mv	a0,s2
    80003fc4:	70a6                	ld	ra,104(sp)
    80003fc6:	7406                	ld	s0,96(sp)
    80003fc8:	64e6                	ld	s1,88(sp)
    80003fca:	6946                	ld	s2,80(sp)
    80003fcc:	69a6                	ld	s3,72(sp)
    80003fce:	6a06                	ld	s4,64(sp)
    80003fd0:	7ae2                	ld	s5,56(sp)
    80003fd2:	7b42                	ld	s6,48(sp)
    80003fd4:	7ba2                	ld	s7,40(sp)
    80003fd6:	7c02                	ld	s8,32(sp)
    80003fd8:	6ce2                	ld	s9,24(sp)
    80003fda:	6165                	addi	sp,sp,112
    80003fdc:	8082                	ret
      wakeup(&pi->nread);
    80003fde:	8566                	mv	a0,s9
    80003fe0:	ffffd097          	auipc	ra,0xffffd
    80003fe4:	58a080e7          	jalr	1418(ra) # 8000156a <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003fe8:	85de                	mv	a1,s7
    80003fea:	8562                	mv	a0,s8
    80003fec:	ffffd097          	auipc	ra,0xffffd
    80003ff0:	51a080e7          	jalr	1306(ra) # 80001506 <sleep>
    80003ff4:	a839                	j	80004012 <pipewrite+0xa4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003ff6:	21c4a783          	lw	a5,540(s1)
    80003ffa:	0017871b          	addiw	a4,a5,1
    80003ffe:	20e4ae23          	sw	a4,540(s1)
    80004002:	1ff7f793          	andi	a5,a5,511
    80004006:	97a6                	add	a5,a5,s1
    80004008:	f9f44703          	lbu	a4,-97(s0)
    8000400c:	00e78c23          	sb	a4,24(a5)
      i++;
    80004010:	2905                	addiw	s2,s2,1
  while(i < n){
    80004012:	05495063          	bge	s2,s4,80004052 <pipewrite+0xe4>
    if(pi->readopen == 0 || killed(pr)){
    80004016:	2204a783          	lw	a5,544(s1)
    8000401a:	dfd1                	beqz	a5,80003fb6 <pipewrite+0x48>
    8000401c:	854e                	mv	a0,s3
    8000401e:	ffffd097          	auipc	ra,0xffffd
    80004022:	790080e7          	jalr	1936(ra) # 800017ae <killed>
    80004026:	f941                	bnez	a0,80003fb6 <pipewrite+0x48>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004028:	2184a783          	lw	a5,536(s1)
    8000402c:	21c4a703          	lw	a4,540(s1)
    80004030:	2007879b          	addiw	a5,a5,512
    80004034:	faf705e3          	beq	a4,a5,80003fde <pipewrite+0x70>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004038:	4685                	li	a3,1
    8000403a:	01590633          	add	a2,s2,s5
    8000403e:	f9f40593          	addi	a1,s0,-97
    80004042:	0509b503          	ld	a0,80(s3)
    80004046:	ffffd097          	auipc	ra,0xffffd
    8000404a:	b66080e7          	jalr	-1178(ra) # 80000bac <copyin>
    8000404e:	fb6514e3          	bne	a0,s6,80003ff6 <pipewrite+0x88>
  wakeup(&pi->nread);
    80004052:	21848513          	addi	a0,s1,536
    80004056:	ffffd097          	auipc	ra,0xffffd
    8000405a:	514080e7          	jalr	1300(ra) # 8000156a <wakeup>
  release(&pi->lock);
    8000405e:	8526                	mv	a0,s1
    80004060:	00002097          	auipc	ra,0x2
    80004064:	440080e7          	jalr	1088(ra) # 800064a0 <release>
  return i;
    80004068:	bfa9                	j	80003fc2 <pipewrite+0x54>
  int i = 0;
    8000406a:	4901                	li	s2,0
    8000406c:	b7dd                	j	80004052 <pipewrite+0xe4>

000000008000406e <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    8000406e:	715d                	addi	sp,sp,-80
    80004070:	e486                	sd	ra,72(sp)
    80004072:	e0a2                	sd	s0,64(sp)
    80004074:	fc26                	sd	s1,56(sp)
    80004076:	f84a                	sd	s2,48(sp)
    80004078:	f44e                	sd	s3,40(sp)
    8000407a:	f052                	sd	s4,32(sp)
    8000407c:	ec56                	sd	s5,24(sp)
    8000407e:	e85a                	sd	s6,16(sp)
    80004080:	0880                	addi	s0,sp,80
    80004082:	84aa                	mv	s1,a0
    80004084:	892e                	mv	s2,a1
    80004086:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004088:	ffffd097          	auipc	ra,0xffffd
    8000408c:	dda080e7          	jalr	-550(ra) # 80000e62 <myproc>
    80004090:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004092:	8b26                	mv	s6,s1
    80004094:	8526                	mv	a0,s1
    80004096:	00002097          	auipc	ra,0x2
    8000409a:	356080e7          	jalr	854(ra) # 800063ec <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    8000409e:	2184a703          	lw	a4,536(s1)
    800040a2:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800040a6:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800040aa:	02f71763          	bne	a4,a5,800040d8 <piperead+0x6a>
    800040ae:	2244a783          	lw	a5,548(s1)
    800040b2:	c39d                	beqz	a5,800040d8 <piperead+0x6a>
    if(killed(pr)){
    800040b4:	8552                	mv	a0,s4
    800040b6:	ffffd097          	auipc	ra,0xffffd
    800040ba:	6f8080e7          	jalr	1784(ra) # 800017ae <killed>
    800040be:	e941                	bnez	a0,8000414e <piperead+0xe0>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800040c0:	85da                	mv	a1,s6
    800040c2:	854e                	mv	a0,s3
    800040c4:	ffffd097          	auipc	ra,0xffffd
    800040c8:	442080e7          	jalr	1090(ra) # 80001506 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800040cc:	2184a703          	lw	a4,536(s1)
    800040d0:	21c4a783          	lw	a5,540(s1)
    800040d4:	fcf70de3          	beq	a4,a5,800040ae <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800040d8:	09505263          	blez	s5,8000415c <piperead+0xee>
    800040dc:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800040de:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    800040e0:	2184a783          	lw	a5,536(s1)
    800040e4:	21c4a703          	lw	a4,540(s1)
    800040e8:	02f70d63          	beq	a4,a5,80004122 <piperead+0xb4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800040ec:	0017871b          	addiw	a4,a5,1
    800040f0:	20e4ac23          	sw	a4,536(s1)
    800040f4:	1ff7f793          	andi	a5,a5,511
    800040f8:	97a6                	add	a5,a5,s1
    800040fa:	0187c783          	lbu	a5,24(a5)
    800040fe:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004102:	4685                	li	a3,1
    80004104:	fbf40613          	addi	a2,s0,-65
    80004108:	85ca                	mv	a1,s2
    8000410a:	050a3503          	ld	a0,80(s4)
    8000410e:	ffffd097          	auipc	ra,0xffffd
    80004112:	a12080e7          	jalr	-1518(ra) # 80000b20 <copyout>
    80004116:	01650663          	beq	a0,s6,80004122 <piperead+0xb4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000411a:	2985                	addiw	s3,s3,1
    8000411c:	0905                	addi	s2,s2,1
    8000411e:	fd3a91e3          	bne	s5,s3,800040e0 <piperead+0x72>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004122:	21c48513          	addi	a0,s1,540
    80004126:	ffffd097          	auipc	ra,0xffffd
    8000412a:	444080e7          	jalr	1092(ra) # 8000156a <wakeup>
  release(&pi->lock);
    8000412e:	8526                	mv	a0,s1
    80004130:	00002097          	auipc	ra,0x2
    80004134:	370080e7          	jalr	880(ra) # 800064a0 <release>
  return i;
}
    80004138:	854e                	mv	a0,s3
    8000413a:	60a6                	ld	ra,72(sp)
    8000413c:	6406                	ld	s0,64(sp)
    8000413e:	74e2                	ld	s1,56(sp)
    80004140:	7942                	ld	s2,48(sp)
    80004142:	79a2                	ld	s3,40(sp)
    80004144:	7a02                	ld	s4,32(sp)
    80004146:	6ae2                	ld	s5,24(sp)
    80004148:	6b42                	ld	s6,16(sp)
    8000414a:	6161                	addi	sp,sp,80
    8000414c:	8082                	ret
      release(&pi->lock);
    8000414e:	8526                	mv	a0,s1
    80004150:	00002097          	auipc	ra,0x2
    80004154:	350080e7          	jalr	848(ra) # 800064a0 <release>
      return -1;
    80004158:	59fd                	li	s3,-1
    8000415a:	bff9                	j	80004138 <piperead+0xca>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000415c:	4981                	li	s3,0
    8000415e:	b7d1                	j	80004122 <piperead+0xb4>

0000000080004160 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80004160:	1141                	addi	sp,sp,-16
    80004162:	e422                	sd	s0,8(sp)
    80004164:	0800                	addi	s0,sp,16
    80004166:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80004168:	8905                	andi	a0,a0,1
    8000416a:	c111                	beqz	a0,8000416e <flags2perm+0xe>
      perm = PTE_X;
    8000416c:	4521                	li	a0,8
    if(flags & 0x2)
    8000416e:	8b89                	andi	a5,a5,2
    80004170:	c399                	beqz	a5,80004176 <flags2perm+0x16>
      perm |= PTE_W;
    80004172:	00456513          	ori	a0,a0,4
    return perm;
}
    80004176:	6422                	ld	s0,8(sp)
    80004178:	0141                	addi	sp,sp,16
    8000417a:	8082                	ret

000000008000417c <exec>:

int
exec(char *path, char **argv)
{
    8000417c:	df010113          	addi	sp,sp,-528
    80004180:	20113423          	sd	ra,520(sp)
    80004184:	20813023          	sd	s0,512(sp)
    80004188:	ffa6                	sd	s1,504(sp)
    8000418a:	fbca                	sd	s2,496(sp)
    8000418c:	f7ce                	sd	s3,488(sp)
    8000418e:	f3d2                	sd	s4,480(sp)
    80004190:	efd6                	sd	s5,472(sp)
    80004192:	ebda                	sd	s6,464(sp)
    80004194:	e7de                	sd	s7,456(sp)
    80004196:	e3e2                	sd	s8,448(sp)
    80004198:	ff66                	sd	s9,440(sp)
    8000419a:	fb6a                	sd	s10,432(sp)
    8000419c:	f76e                	sd	s11,424(sp)
    8000419e:	0c00                	addi	s0,sp,528
    800041a0:	84aa                	mv	s1,a0
    800041a2:	dea43c23          	sd	a0,-520(s0)
    800041a6:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800041aa:	ffffd097          	auipc	ra,0xffffd
    800041ae:	cb8080e7          	jalr	-840(ra) # 80000e62 <myproc>
    800041b2:	892a                	mv	s2,a0

  begin_op();
    800041b4:	fffff097          	auipc	ra,0xfffff
    800041b8:	41a080e7          	jalr	1050(ra) # 800035ce <begin_op>

  if((ip = namei(path)) == 0){
    800041bc:	8526                	mv	a0,s1
    800041be:	fffff097          	auipc	ra,0xfffff
    800041c2:	1f4080e7          	jalr	500(ra) # 800033b2 <namei>
    800041c6:	c92d                	beqz	a0,80004238 <exec+0xbc>
    800041c8:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800041ca:	fffff097          	auipc	ra,0xfffff
    800041ce:	a42080e7          	jalr	-1470(ra) # 80002c0c <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800041d2:	04000713          	li	a4,64
    800041d6:	4681                	li	a3,0
    800041d8:	e5040613          	addi	a2,s0,-432
    800041dc:	4581                	li	a1,0
    800041de:	8526                	mv	a0,s1
    800041e0:	fffff097          	auipc	ra,0xfffff
    800041e4:	ce0080e7          	jalr	-800(ra) # 80002ec0 <readi>
    800041e8:	04000793          	li	a5,64
    800041ec:	00f51a63          	bne	a0,a5,80004200 <exec+0x84>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    800041f0:	e5042703          	lw	a4,-432(s0)
    800041f4:	464c47b7          	lui	a5,0x464c4
    800041f8:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800041fc:	04f70463          	beq	a4,a5,80004244 <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004200:	8526                	mv	a0,s1
    80004202:	fffff097          	auipc	ra,0xfffff
    80004206:	c6c080e7          	jalr	-916(ra) # 80002e6e <iunlockput>
    end_op();
    8000420a:	fffff097          	auipc	ra,0xfffff
    8000420e:	444080e7          	jalr	1092(ra) # 8000364e <end_op>
  }
  return -1;
    80004212:	557d                	li	a0,-1
}
    80004214:	20813083          	ld	ra,520(sp)
    80004218:	20013403          	ld	s0,512(sp)
    8000421c:	74fe                	ld	s1,504(sp)
    8000421e:	795e                	ld	s2,496(sp)
    80004220:	79be                	ld	s3,488(sp)
    80004222:	7a1e                	ld	s4,480(sp)
    80004224:	6afe                	ld	s5,472(sp)
    80004226:	6b5e                	ld	s6,464(sp)
    80004228:	6bbe                	ld	s7,456(sp)
    8000422a:	6c1e                	ld	s8,448(sp)
    8000422c:	7cfa                	ld	s9,440(sp)
    8000422e:	7d5a                	ld	s10,432(sp)
    80004230:	7dba                	ld	s11,424(sp)
    80004232:	21010113          	addi	sp,sp,528
    80004236:	8082                	ret
    end_op();
    80004238:	fffff097          	auipc	ra,0xfffff
    8000423c:	416080e7          	jalr	1046(ra) # 8000364e <end_op>
    return -1;
    80004240:	557d                	li	a0,-1
    80004242:	bfc9                	j	80004214 <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    80004244:	854a                	mv	a0,s2
    80004246:	ffffd097          	auipc	ra,0xffffd
    8000424a:	ce0080e7          	jalr	-800(ra) # 80000f26 <proc_pagetable>
    8000424e:	8baa                	mv	s7,a0
    80004250:	d945                	beqz	a0,80004200 <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004252:	e7042983          	lw	s3,-400(s0)
    80004256:	e8845783          	lhu	a5,-376(s0)
    8000425a:	c7ad                	beqz	a5,800042c4 <exec+0x148>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000425c:	4a01                	li	s4,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000425e:	4b01                	li	s6,0
    if(ph.vaddr % PGSIZE != 0)
    80004260:	6c85                	lui	s9,0x1
    80004262:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004266:	def43823          	sd	a5,-528(s0)
    8000426a:	ac0d                	j	8000449c <exec+0x320>
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    8000426c:	00004517          	auipc	a0,0x4
    80004270:	45c50513          	addi	a0,a0,1116 # 800086c8 <syscalls+0x298>
    80004274:	00002097          	auipc	ra,0x2
    80004278:	c2e080e7          	jalr	-978(ra) # 80005ea2 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    8000427c:	8756                	mv	a4,s5
    8000427e:	012d86bb          	addw	a3,s11,s2
    80004282:	4581                	li	a1,0
    80004284:	8526                	mv	a0,s1
    80004286:	fffff097          	auipc	ra,0xfffff
    8000428a:	c3a080e7          	jalr	-966(ra) # 80002ec0 <readi>
    8000428e:	2501                	sext.w	a0,a0
    80004290:	1aaa9a63          	bne	s5,a0,80004444 <exec+0x2c8>
  for(i = 0; i < sz; i += PGSIZE){
    80004294:	6785                	lui	a5,0x1
    80004296:	0127893b          	addw	s2,a5,s2
    8000429a:	77fd                	lui	a5,0xfffff
    8000429c:	01478a3b          	addw	s4,a5,s4
    800042a0:	1f897563          	bgeu	s2,s8,8000448a <exec+0x30e>
    pa = walkaddr(pagetable, va + i);
    800042a4:	02091593          	slli	a1,s2,0x20
    800042a8:	9181                	srli	a1,a1,0x20
    800042aa:	95ea                	add	a1,a1,s10
    800042ac:	855e                	mv	a0,s7
    800042ae:	ffffc097          	auipc	ra,0xffffc
    800042b2:	25c080e7          	jalr	604(ra) # 8000050a <walkaddr>
    800042b6:	862a                	mv	a2,a0
    if(pa == 0)
    800042b8:	d955                	beqz	a0,8000426c <exec+0xf0>
      n = PGSIZE;
    800042ba:	8ae6                	mv	s5,s9
    if(sz - i < PGSIZE)
    800042bc:	fd9a70e3          	bgeu	s4,s9,8000427c <exec+0x100>
      n = sz - i;
    800042c0:	8ad2                	mv	s5,s4
    800042c2:	bf6d                	j	8000427c <exec+0x100>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800042c4:	4a01                	li	s4,0
  iunlockput(ip);
    800042c6:	8526                	mv	a0,s1
    800042c8:	fffff097          	auipc	ra,0xfffff
    800042cc:	ba6080e7          	jalr	-1114(ra) # 80002e6e <iunlockput>
  end_op();
    800042d0:	fffff097          	auipc	ra,0xfffff
    800042d4:	37e080e7          	jalr	894(ra) # 8000364e <end_op>
  p = myproc();
    800042d8:	ffffd097          	auipc	ra,0xffffd
    800042dc:	b8a080e7          	jalr	-1142(ra) # 80000e62 <myproc>
    800042e0:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    800042e2:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    800042e6:	6785                	lui	a5,0x1
    800042e8:	17fd                	addi	a5,a5,-1
    800042ea:	9a3e                	add	s4,s4,a5
    800042ec:	757d                	lui	a0,0xfffff
    800042ee:	00aa77b3          	and	a5,s4,a0
    800042f2:	e0f43423          	sd	a5,-504(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    800042f6:	4691                	li	a3,4
    800042f8:	6609                	lui	a2,0x2
    800042fa:	963e                	add	a2,a2,a5
    800042fc:	85be                	mv	a1,a5
    800042fe:	855e                	mv	a0,s7
    80004300:	ffffc097          	auipc	ra,0xffffc
    80004304:	5d4080e7          	jalr	1492(ra) # 800008d4 <uvmalloc>
    80004308:	8b2a                	mv	s6,a0
  ip = 0;
    8000430a:	4481                	li	s1,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    8000430c:	12050c63          	beqz	a0,80004444 <exec+0x2c8>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004310:	75f9                	lui	a1,0xffffe
    80004312:	95aa                	add	a1,a1,a0
    80004314:	855e                	mv	a0,s7
    80004316:	ffffc097          	auipc	ra,0xffffc
    8000431a:	7d8080e7          	jalr	2008(ra) # 80000aee <uvmclear>
  stackbase = sp - PGSIZE;
    8000431e:	7c7d                	lui	s8,0xfffff
    80004320:	9c5a                	add	s8,s8,s6
  for(argc = 0; argv[argc]; argc++) {
    80004322:	e0043783          	ld	a5,-512(s0)
    80004326:	6388                	ld	a0,0(a5)
    80004328:	c535                	beqz	a0,80004394 <exec+0x218>
    8000432a:	e9040993          	addi	s3,s0,-368
    8000432e:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    80004332:	895a                	mv	s2,s6
    sp -= strlen(argv[argc]) + 1;
    80004334:	ffffc097          	auipc	ra,0xffffc
    80004338:	fc8080e7          	jalr	-56(ra) # 800002fc <strlen>
    8000433c:	2505                	addiw	a0,a0,1
    8000433e:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004342:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    80004346:	13896663          	bltu	s2,s8,80004472 <exec+0x2f6>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    8000434a:	e0043d83          	ld	s11,-512(s0)
    8000434e:	000dba03          	ld	s4,0(s11)
    80004352:	8552                	mv	a0,s4
    80004354:	ffffc097          	auipc	ra,0xffffc
    80004358:	fa8080e7          	jalr	-88(ra) # 800002fc <strlen>
    8000435c:	0015069b          	addiw	a3,a0,1
    80004360:	8652                	mv	a2,s4
    80004362:	85ca                	mv	a1,s2
    80004364:	855e                	mv	a0,s7
    80004366:	ffffc097          	auipc	ra,0xffffc
    8000436a:	7ba080e7          	jalr	1978(ra) # 80000b20 <copyout>
    8000436e:	10054663          	bltz	a0,8000447a <exec+0x2fe>
    ustack[argc] = sp;
    80004372:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004376:	0485                	addi	s1,s1,1
    80004378:	008d8793          	addi	a5,s11,8
    8000437c:	e0f43023          	sd	a5,-512(s0)
    80004380:	008db503          	ld	a0,8(s11)
    80004384:	c911                	beqz	a0,80004398 <exec+0x21c>
    if(argc >= MAXARG)
    80004386:	09a1                	addi	s3,s3,8
    80004388:	fb3c96e3          	bne	s9,s3,80004334 <exec+0x1b8>
  sz = sz1;
    8000438c:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004390:	4481                	li	s1,0
    80004392:	a84d                	j	80004444 <exec+0x2c8>
  sp = sz;
    80004394:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    80004396:	4481                	li	s1,0
  ustack[argc] = 0;
    80004398:	00349793          	slli	a5,s1,0x3
    8000439c:	f9040713          	addi	a4,s0,-112
    800043a0:	97ba                	add	a5,a5,a4
    800043a2:	f007b023          	sd	zero,-256(a5) # f00 <_entry-0x7ffff100>
  sp -= (argc+1) * sizeof(uint64);
    800043a6:	00148693          	addi	a3,s1,1
    800043aa:	068e                	slli	a3,a3,0x3
    800043ac:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800043b0:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    800043b4:	01897663          	bgeu	s2,s8,800043c0 <exec+0x244>
  sz = sz1;
    800043b8:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800043bc:	4481                	li	s1,0
    800043be:	a059                	j	80004444 <exec+0x2c8>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800043c0:	e9040613          	addi	a2,s0,-368
    800043c4:	85ca                	mv	a1,s2
    800043c6:	855e                	mv	a0,s7
    800043c8:	ffffc097          	auipc	ra,0xffffc
    800043cc:	758080e7          	jalr	1880(ra) # 80000b20 <copyout>
    800043d0:	0a054963          	bltz	a0,80004482 <exec+0x306>
  p->trapframe->a1 = sp;
    800043d4:	058ab783          	ld	a5,88(s5)
    800043d8:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800043dc:	df843783          	ld	a5,-520(s0)
    800043e0:	0007c703          	lbu	a4,0(a5)
    800043e4:	cf11                	beqz	a4,80004400 <exec+0x284>
    800043e6:	0785                	addi	a5,a5,1
    if(*s == '/')
    800043e8:	02f00693          	li	a3,47
    800043ec:	a039                	j	800043fa <exec+0x27e>
      last = s+1;
    800043ee:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    800043f2:	0785                	addi	a5,a5,1
    800043f4:	fff7c703          	lbu	a4,-1(a5)
    800043f8:	c701                	beqz	a4,80004400 <exec+0x284>
    if(*s == '/')
    800043fa:	fed71ce3          	bne	a4,a3,800043f2 <exec+0x276>
    800043fe:	bfc5                	j	800043ee <exec+0x272>
  safestrcpy(p->name, last, sizeof(p->name));
    80004400:	4641                	li	a2,16
    80004402:	df843583          	ld	a1,-520(s0)
    80004406:	158a8513          	addi	a0,s5,344
    8000440a:	ffffc097          	auipc	ra,0xffffc
    8000440e:	ec0080e7          	jalr	-320(ra) # 800002ca <safestrcpy>
  oldpagetable = p->pagetable;
    80004412:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80004416:	057ab823          	sd	s7,80(s5)
  p->sz = sz;
    8000441a:	056ab423          	sd	s6,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    8000441e:	058ab783          	ld	a5,88(s5)
    80004422:	e6843703          	ld	a4,-408(s0)
    80004426:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004428:	058ab783          	ld	a5,88(s5)
    8000442c:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004430:	85ea                	mv	a1,s10
    80004432:	ffffd097          	auipc	ra,0xffffd
    80004436:	b90080e7          	jalr	-1136(ra) # 80000fc2 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    8000443a:	0004851b          	sext.w	a0,s1
    8000443e:	bbd9                	j	80004214 <exec+0x98>
    80004440:	e1443423          	sd	s4,-504(s0)
    proc_freepagetable(pagetable, sz);
    80004444:	e0843583          	ld	a1,-504(s0)
    80004448:	855e                	mv	a0,s7
    8000444a:	ffffd097          	auipc	ra,0xffffd
    8000444e:	b78080e7          	jalr	-1160(ra) # 80000fc2 <proc_freepagetable>
  if(ip){
    80004452:	da0497e3          	bnez	s1,80004200 <exec+0x84>
  return -1;
    80004456:	557d                	li	a0,-1
    80004458:	bb75                	j	80004214 <exec+0x98>
    8000445a:	e1443423          	sd	s4,-504(s0)
    8000445e:	b7dd                	j	80004444 <exec+0x2c8>
    80004460:	e1443423          	sd	s4,-504(s0)
    80004464:	b7c5                	j	80004444 <exec+0x2c8>
    80004466:	e1443423          	sd	s4,-504(s0)
    8000446a:	bfe9                	j	80004444 <exec+0x2c8>
    8000446c:	e1443423          	sd	s4,-504(s0)
    80004470:	bfd1                	j	80004444 <exec+0x2c8>
  sz = sz1;
    80004472:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004476:	4481                	li	s1,0
    80004478:	b7f1                	j	80004444 <exec+0x2c8>
  sz = sz1;
    8000447a:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    8000447e:	4481                	li	s1,0
    80004480:	b7d1                	j	80004444 <exec+0x2c8>
  sz = sz1;
    80004482:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004486:	4481                	li	s1,0
    80004488:	bf75                	j	80004444 <exec+0x2c8>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    8000448a:	e0843a03          	ld	s4,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000448e:	2b05                	addiw	s6,s6,1
    80004490:	0389899b          	addiw	s3,s3,56
    80004494:	e8845783          	lhu	a5,-376(s0)
    80004498:	e2fb57e3          	bge	s6,a5,800042c6 <exec+0x14a>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    8000449c:	2981                	sext.w	s3,s3
    8000449e:	03800713          	li	a4,56
    800044a2:	86ce                	mv	a3,s3
    800044a4:	e1840613          	addi	a2,s0,-488
    800044a8:	4581                	li	a1,0
    800044aa:	8526                	mv	a0,s1
    800044ac:	fffff097          	auipc	ra,0xfffff
    800044b0:	a14080e7          	jalr	-1516(ra) # 80002ec0 <readi>
    800044b4:	03800793          	li	a5,56
    800044b8:	f8f514e3          	bne	a0,a5,80004440 <exec+0x2c4>
    if(ph.type != ELF_PROG_LOAD)
    800044bc:	e1842783          	lw	a5,-488(s0)
    800044c0:	4705                	li	a4,1
    800044c2:	fce796e3          	bne	a5,a4,8000448e <exec+0x312>
    if(ph.memsz < ph.filesz)
    800044c6:	e4043903          	ld	s2,-448(s0)
    800044ca:	e3843783          	ld	a5,-456(s0)
    800044ce:	f8f966e3          	bltu	s2,a5,8000445a <exec+0x2de>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800044d2:	e2843783          	ld	a5,-472(s0)
    800044d6:	993e                	add	s2,s2,a5
    800044d8:	f8f964e3          	bltu	s2,a5,80004460 <exec+0x2e4>
    if(ph.vaddr % PGSIZE != 0)
    800044dc:	df043703          	ld	a4,-528(s0)
    800044e0:	8ff9                	and	a5,a5,a4
    800044e2:	f3d1                	bnez	a5,80004466 <exec+0x2ea>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800044e4:	e1c42503          	lw	a0,-484(s0)
    800044e8:	00000097          	auipc	ra,0x0
    800044ec:	c78080e7          	jalr	-904(ra) # 80004160 <flags2perm>
    800044f0:	86aa                	mv	a3,a0
    800044f2:	864a                	mv	a2,s2
    800044f4:	85d2                	mv	a1,s4
    800044f6:	855e                	mv	a0,s7
    800044f8:	ffffc097          	auipc	ra,0xffffc
    800044fc:	3dc080e7          	jalr	988(ra) # 800008d4 <uvmalloc>
    80004500:	e0a43423          	sd	a0,-504(s0)
    80004504:	d525                	beqz	a0,8000446c <exec+0x2f0>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004506:	e2843d03          	ld	s10,-472(s0)
    8000450a:	e2042d83          	lw	s11,-480(s0)
    8000450e:	e3842c03          	lw	s8,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004512:	f60c0ce3          	beqz	s8,8000448a <exec+0x30e>
    80004516:	8a62                	mv	s4,s8
    80004518:	4901                	li	s2,0
    8000451a:	b369                	j	800042a4 <exec+0x128>

000000008000451c <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    8000451c:	7179                	addi	sp,sp,-48
    8000451e:	f406                	sd	ra,40(sp)
    80004520:	f022                	sd	s0,32(sp)
    80004522:	ec26                	sd	s1,24(sp)
    80004524:	e84a                	sd	s2,16(sp)
    80004526:	1800                	addi	s0,sp,48
    80004528:	892e                	mv	s2,a1
    8000452a:	84b2                	mv	s1,a2
    int fd;
    struct file *f;

    argint(n, &fd);
    8000452c:	fdc40593          	addi	a1,s0,-36
    80004530:	ffffe097          	auipc	ra,0xffffe
    80004534:	b62080e7          	jalr	-1182(ra) # 80002092 <argint>
    if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0)
    80004538:	fdc42703          	lw	a4,-36(s0)
    8000453c:	47bd                	li	a5,15
    8000453e:	02e7eb63          	bltu	a5,a4,80004574 <argfd+0x58>
    80004542:	ffffd097          	auipc	ra,0xffffd
    80004546:	920080e7          	jalr	-1760(ra) # 80000e62 <myproc>
    8000454a:	fdc42703          	lw	a4,-36(s0)
    8000454e:	01a70793          	addi	a5,a4,26
    80004552:	078e                	slli	a5,a5,0x3
    80004554:	953e                	add	a0,a0,a5
    80004556:	611c                	ld	a5,0(a0)
    80004558:	c385                	beqz	a5,80004578 <argfd+0x5c>
        return -1;
    if (pfd)
    8000455a:	00090463          	beqz	s2,80004562 <argfd+0x46>
        *pfd = fd;
    8000455e:	00e92023          	sw	a4,0(s2)
    if (pf)
        *pf = f;
    return 0;
    80004562:	4501                	li	a0,0
    if (pf)
    80004564:	c091                	beqz	s1,80004568 <argfd+0x4c>
        *pf = f;
    80004566:	e09c                	sd	a5,0(s1)
}
    80004568:	70a2                	ld	ra,40(sp)
    8000456a:	7402                	ld	s0,32(sp)
    8000456c:	64e2                	ld	s1,24(sp)
    8000456e:	6942                	ld	s2,16(sp)
    80004570:	6145                	addi	sp,sp,48
    80004572:	8082                	ret
        return -1;
    80004574:	557d                	li	a0,-1
    80004576:	bfcd                	j	80004568 <argfd+0x4c>
    80004578:	557d                	li	a0,-1
    8000457a:	b7fd                	j	80004568 <argfd+0x4c>

000000008000457c <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    8000457c:	1101                	addi	sp,sp,-32
    8000457e:	ec06                	sd	ra,24(sp)
    80004580:	e822                	sd	s0,16(sp)
    80004582:	e426                	sd	s1,8(sp)
    80004584:	1000                	addi	s0,sp,32
    80004586:	84aa                	mv	s1,a0
    int fd;
    struct proc *p = myproc();
    80004588:	ffffd097          	auipc	ra,0xffffd
    8000458c:	8da080e7          	jalr	-1830(ra) # 80000e62 <myproc>
    80004590:	862a                	mv	a2,a0

    for (fd = 0; fd < NOFILE; fd++)
    80004592:	0d050793          	addi	a5,a0,208 # fffffffffffff0d0 <end+0xffffffff7ffcf2f0>
    80004596:	4501                	li	a0,0
    80004598:	46c1                	li	a3,16
    {
        if (p->ofile[fd] == 0)
    8000459a:	6398                	ld	a4,0(a5)
    8000459c:	cb19                	beqz	a4,800045b2 <fdalloc+0x36>
    for (fd = 0; fd < NOFILE; fd++)
    8000459e:	2505                	addiw	a0,a0,1
    800045a0:	07a1                	addi	a5,a5,8
    800045a2:	fed51ce3          	bne	a0,a3,8000459a <fdalloc+0x1e>
        {
            p->ofile[fd] = f;
            return fd;
        }
    }
    return -1;
    800045a6:	557d                	li	a0,-1
}
    800045a8:	60e2                	ld	ra,24(sp)
    800045aa:	6442                	ld	s0,16(sp)
    800045ac:	64a2                	ld	s1,8(sp)
    800045ae:	6105                	addi	sp,sp,32
    800045b0:	8082                	ret
            p->ofile[fd] = f;
    800045b2:	01a50793          	addi	a5,a0,26
    800045b6:	078e                	slli	a5,a5,0x3
    800045b8:	963e                	add	a2,a2,a5
    800045ba:	e204                	sd	s1,0(a2)
            return fd;
    800045bc:	b7f5                	j	800045a8 <fdalloc+0x2c>

00000000800045be <create>:
    return 0;
}

static struct inode *
create(char *path, short type, short major, short minor)
{
    800045be:	715d                	addi	sp,sp,-80
    800045c0:	e486                	sd	ra,72(sp)
    800045c2:	e0a2                	sd	s0,64(sp)
    800045c4:	fc26                	sd	s1,56(sp)
    800045c6:	f84a                	sd	s2,48(sp)
    800045c8:	f44e                	sd	s3,40(sp)
    800045ca:	f052                	sd	s4,32(sp)
    800045cc:	ec56                	sd	s5,24(sp)
    800045ce:	e85a                	sd	s6,16(sp)
    800045d0:	0880                	addi	s0,sp,80
    800045d2:	8b2e                	mv	s6,a1
    800045d4:	89b2                	mv	s3,a2
    800045d6:	8936                	mv	s2,a3
    struct inode *ip, *dp;
    char name[DIRSIZ];

    if ((dp = nameiparent(path, name)) == 0)
    800045d8:	fb040593          	addi	a1,s0,-80
    800045dc:	fffff097          	auipc	ra,0xfffff
    800045e0:	df4080e7          	jalr	-524(ra) # 800033d0 <nameiparent>
    800045e4:	84aa                	mv	s1,a0
    800045e6:	16050063          	beqz	a0,80004746 <create+0x188>
        return 0;

    ilock(dp);
    800045ea:	ffffe097          	auipc	ra,0xffffe
    800045ee:	622080e7          	jalr	1570(ra) # 80002c0c <ilock>

    if ((ip = dirlookup(dp, name, 0)) != 0)
    800045f2:	4601                	li	a2,0
    800045f4:	fb040593          	addi	a1,s0,-80
    800045f8:	8526                	mv	a0,s1
    800045fa:	fffff097          	auipc	ra,0xfffff
    800045fe:	af6080e7          	jalr	-1290(ra) # 800030f0 <dirlookup>
    80004602:	8aaa                	mv	s5,a0
    80004604:	c931                	beqz	a0,80004658 <create+0x9a>
    {
        iunlockput(dp);
    80004606:	8526                	mv	a0,s1
    80004608:	fffff097          	auipc	ra,0xfffff
    8000460c:	866080e7          	jalr	-1946(ra) # 80002e6e <iunlockput>
        ilock(ip);
    80004610:	8556                	mv	a0,s5
    80004612:	ffffe097          	auipc	ra,0xffffe
    80004616:	5fa080e7          	jalr	1530(ra) # 80002c0c <ilock>
        if (type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    8000461a:	000b059b          	sext.w	a1,s6
    8000461e:	4789                	li	a5,2
    80004620:	02f59563          	bne	a1,a5,8000464a <create+0x8c>
    80004624:	044ad783          	lhu	a5,68(s5)
    80004628:	37f9                	addiw	a5,a5,-2
    8000462a:	17c2                	slli	a5,a5,0x30
    8000462c:	93c1                	srli	a5,a5,0x30
    8000462e:	4705                	li	a4,1
    80004630:	00f76d63          	bltu	a4,a5,8000464a <create+0x8c>
    ip->nlink = 0;
    iupdate(ip);
    iunlockput(ip);
    iunlockput(dp);
    return 0;
}
    80004634:	8556                	mv	a0,s5
    80004636:	60a6                	ld	ra,72(sp)
    80004638:	6406                	ld	s0,64(sp)
    8000463a:	74e2                	ld	s1,56(sp)
    8000463c:	7942                	ld	s2,48(sp)
    8000463e:	79a2                	ld	s3,40(sp)
    80004640:	7a02                	ld	s4,32(sp)
    80004642:	6ae2                	ld	s5,24(sp)
    80004644:	6b42                	ld	s6,16(sp)
    80004646:	6161                	addi	sp,sp,80
    80004648:	8082                	ret
        iunlockput(ip);
    8000464a:	8556                	mv	a0,s5
    8000464c:	fffff097          	auipc	ra,0xfffff
    80004650:	822080e7          	jalr	-2014(ra) # 80002e6e <iunlockput>
        return 0;
    80004654:	4a81                	li	s5,0
    80004656:	bff9                	j	80004634 <create+0x76>
    if ((ip = ialloc(dp->dev, type)) == 0)
    80004658:	85da                	mv	a1,s6
    8000465a:	4088                	lw	a0,0(s1)
    8000465c:	ffffe097          	auipc	ra,0xffffe
    80004660:	414080e7          	jalr	1044(ra) # 80002a70 <ialloc>
    80004664:	8a2a                	mv	s4,a0
    80004666:	c921                	beqz	a0,800046b6 <create+0xf8>
    ilock(ip);
    80004668:	ffffe097          	auipc	ra,0xffffe
    8000466c:	5a4080e7          	jalr	1444(ra) # 80002c0c <ilock>
    ip->major = major;
    80004670:	053a1323          	sh	s3,70(s4)
    ip->minor = minor;
    80004674:	052a1423          	sh	s2,72(s4)
    ip->nlink = 1;
    80004678:	4785                	li	a5,1
    8000467a:	04fa1523          	sh	a5,74(s4)
    iupdate(ip);
    8000467e:	8552                	mv	a0,s4
    80004680:	ffffe097          	auipc	ra,0xffffe
    80004684:	4c2080e7          	jalr	1218(ra) # 80002b42 <iupdate>
    if (type == T_DIR)
    80004688:	000b059b          	sext.w	a1,s6
    8000468c:	4785                	li	a5,1
    8000468e:	02f58b63          	beq	a1,a5,800046c4 <create+0x106>
    if (dirlink(dp, name, ip->inum) < 0)
    80004692:	004a2603          	lw	a2,4(s4)
    80004696:	fb040593          	addi	a1,s0,-80
    8000469a:	8526                	mv	a0,s1
    8000469c:	fffff097          	auipc	ra,0xfffff
    800046a0:	c64080e7          	jalr	-924(ra) # 80003300 <dirlink>
    800046a4:	06054f63          	bltz	a0,80004722 <create+0x164>
    iunlockput(dp);
    800046a8:	8526                	mv	a0,s1
    800046aa:	ffffe097          	auipc	ra,0xffffe
    800046ae:	7c4080e7          	jalr	1988(ra) # 80002e6e <iunlockput>
    return ip;
    800046b2:	8ad2                	mv	s5,s4
    800046b4:	b741                	j	80004634 <create+0x76>
        iunlockput(dp);
    800046b6:	8526                	mv	a0,s1
    800046b8:	ffffe097          	auipc	ra,0xffffe
    800046bc:	7b6080e7          	jalr	1974(ra) # 80002e6e <iunlockput>
        return 0;
    800046c0:	8ad2                	mv	s5,s4
    800046c2:	bf8d                	j	80004634 <create+0x76>
        if (dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800046c4:	004a2603          	lw	a2,4(s4)
    800046c8:	00004597          	auipc	a1,0x4
    800046cc:	02058593          	addi	a1,a1,32 # 800086e8 <syscalls+0x2b8>
    800046d0:	8552                	mv	a0,s4
    800046d2:	fffff097          	auipc	ra,0xfffff
    800046d6:	c2e080e7          	jalr	-978(ra) # 80003300 <dirlink>
    800046da:	04054463          	bltz	a0,80004722 <create+0x164>
    800046de:	40d0                	lw	a2,4(s1)
    800046e0:	00004597          	auipc	a1,0x4
    800046e4:	01058593          	addi	a1,a1,16 # 800086f0 <syscalls+0x2c0>
    800046e8:	8552                	mv	a0,s4
    800046ea:	fffff097          	auipc	ra,0xfffff
    800046ee:	c16080e7          	jalr	-1002(ra) # 80003300 <dirlink>
    800046f2:	02054863          	bltz	a0,80004722 <create+0x164>
    if (dirlink(dp, name, ip->inum) < 0)
    800046f6:	004a2603          	lw	a2,4(s4)
    800046fa:	fb040593          	addi	a1,s0,-80
    800046fe:	8526                	mv	a0,s1
    80004700:	fffff097          	auipc	ra,0xfffff
    80004704:	c00080e7          	jalr	-1024(ra) # 80003300 <dirlink>
    80004708:	00054d63          	bltz	a0,80004722 <create+0x164>
        dp->nlink++; // for ".."
    8000470c:	04a4d783          	lhu	a5,74(s1)
    80004710:	2785                	addiw	a5,a5,1
    80004712:	04f49523          	sh	a5,74(s1)
        iupdate(dp);
    80004716:	8526                	mv	a0,s1
    80004718:	ffffe097          	auipc	ra,0xffffe
    8000471c:	42a080e7          	jalr	1066(ra) # 80002b42 <iupdate>
    80004720:	b761                	j	800046a8 <create+0xea>
    ip->nlink = 0;
    80004722:	040a1523          	sh	zero,74(s4)
    iupdate(ip);
    80004726:	8552                	mv	a0,s4
    80004728:	ffffe097          	auipc	ra,0xffffe
    8000472c:	41a080e7          	jalr	1050(ra) # 80002b42 <iupdate>
    iunlockput(ip);
    80004730:	8552                	mv	a0,s4
    80004732:	ffffe097          	auipc	ra,0xffffe
    80004736:	73c080e7          	jalr	1852(ra) # 80002e6e <iunlockput>
    iunlockput(dp);
    8000473a:	8526                	mv	a0,s1
    8000473c:	ffffe097          	auipc	ra,0xffffe
    80004740:	732080e7          	jalr	1842(ra) # 80002e6e <iunlockput>
    return 0;
    80004744:	bdc5                	j	80004634 <create+0x76>
        return 0;
    80004746:	8aaa                	mv	s5,a0
    80004748:	b5f5                	j	80004634 <create+0x76>

000000008000474a <sys_dup>:
{
    8000474a:	7179                	addi	sp,sp,-48
    8000474c:	f406                	sd	ra,40(sp)
    8000474e:	f022                	sd	s0,32(sp)
    80004750:	ec26                	sd	s1,24(sp)
    80004752:	1800                	addi	s0,sp,48
    if (argfd(0, 0, &f) < 0)
    80004754:	fd840613          	addi	a2,s0,-40
    80004758:	4581                	li	a1,0
    8000475a:	4501                	li	a0,0
    8000475c:	00000097          	auipc	ra,0x0
    80004760:	dc0080e7          	jalr	-576(ra) # 8000451c <argfd>
        return -1;
    80004764:	57fd                	li	a5,-1
    if (argfd(0, 0, &f) < 0)
    80004766:	02054363          	bltz	a0,8000478c <sys_dup+0x42>
    if ((fd = fdalloc(f)) < 0)
    8000476a:	fd843503          	ld	a0,-40(s0)
    8000476e:	00000097          	auipc	ra,0x0
    80004772:	e0e080e7          	jalr	-498(ra) # 8000457c <fdalloc>
    80004776:	84aa                	mv	s1,a0
        return -1;
    80004778:	57fd                	li	a5,-1
    if ((fd = fdalloc(f)) < 0)
    8000477a:	00054963          	bltz	a0,8000478c <sys_dup+0x42>
    filedup(f);
    8000477e:	fd843503          	ld	a0,-40(s0)
    80004782:	fffff097          	auipc	ra,0xfffff
    80004786:	2c6080e7          	jalr	710(ra) # 80003a48 <filedup>
    return fd;
    8000478a:	87a6                	mv	a5,s1
}
    8000478c:	853e                	mv	a0,a5
    8000478e:	70a2                	ld	ra,40(sp)
    80004790:	7402                	ld	s0,32(sp)
    80004792:	64e2                	ld	s1,24(sp)
    80004794:	6145                	addi	sp,sp,48
    80004796:	8082                	ret

0000000080004798 <sys_read>:
{
    80004798:	7179                	addi	sp,sp,-48
    8000479a:	f406                	sd	ra,40(sp)
    8000479c:	f022                	sd	s0,32(sp)
    8000479e:	1800                	addi	s0,sp,48
    argaddr(1, &p);
    800047a0:	fd840593          	addi	a1,s0,-40
    800047a4:	4505                	li	a0,1
    800047a6:	ffffe097          	auipc	ra,0xffffe
    800047aa:	90c080e7          	jalr	-1780(ra) # 800020b2 <argaddr>
    argint(2, &n);
    800047ae:	fe440593          	addi	a1,s0,-28
    800047b2:	4509                	li	a0,2
    800047b4:	ffffe097          	auipc	ra,0xffffe
    800047b8:	8de080e7          	jalr	-1826(ra) # 80002092 <argint>
    if (argfd(0, 0, &f) < 0)
    800047bc:	fe840613          	addi	a2,s0,-24
    800047c0:	4581                	li	a1,0
    800047c2:	4501                	li	a0,0
    800047c4:	00000097          	auipc	ra,0x0
    800047c8:	d58080e7          	jalr	-680(ra) # 8000451c <argfd>
    800047cc:	87aa                	mv	a5,a0
        return -1;
    800047ce:	557d                	li	a0,-1
    if (argfd(0, 0, &f) < 0)
    800047d0:	0007cc63          	bltz	a5,800047e8 <sys_read+0x50>
    return fileread(f, p, n);
    800047d4:	fe442603          	lw	a2,-28(s0)
    800047d8:	fd843583          	ld	a1,-40(s0)
    800047dc:	fe843503          	ld	a0,-24(s0)
    800047e0:	fffff097          	auipc	ra,0xfffff
    800047e4:	44e080e7          	jalr	1102(ra) # 80003c2e <fileread>
}
    800047e8:	70a2                	ld	ra,40(sp)
    800047ea:	7402                	ld	s0,32(sp)
    800047ec:	6145                	addi	sp,sp,48
    800047ee:	8082                	ret

00000000800047f0 <sys_write>:
{
    800047f0:	7179                	addi	sp,sp,-48
    800047f2:	f406                	sd	ra,40(sp)
    800047f4:	f022                	sd	s0,32(sp)
    800047f6:	1800                	addi	s0,sp,48
    argaddr(1, &p);
    800047f8:	fd840593          	addi	a1,s0,-40
    800047fc:	4505                	li	a0,1
    800047fe:	ffffe097          	auipc	ra,0xffffe
    80004802:	8b4080e7          	jalr	-1868(ra) # 800020b2 <argaddr>
    argint(2, &n);
    80004806:	fe440593          	addi	a1,s0,-28
    8000480a:	4509                	li	a0,2
    8000480c:	ffffe097          	auipc	ra,0xffffe
    80004810:	886080e7          	jalr	-1914(ra) # 80002092 <argint>
    if (argfd(0, 0, &f) < 0)
    80004814:	fe840613          	addi	a2,s0,-24
    80004818:	4581                	li	a1,0
    8000481a:	4501                	li	a0,0
    8000481c:	00000097          	auipc	ra,0x0
    80004820:	d00080e7          	jalr	-768(ra) # 8000451c <argfd>
    80004824:	87aa                	mv	a5,a0
        return -1;
    80004826:	557d                	li	a0,-1
    if (argfd(0, 0, &f) < 0)
    80004828:	0007cc63          	bltz	a5,80004840 <sys_write+0x50>
    return filewrite(f, p, n);
    8000482c:	fe442603          	lw	a2,-28(s0)
    80004830:	fd843583          	ld	a1,-40(s0)
    80004834:	fe843503          	ld	a0,-24(s0)
    80004838:	fffff097          	auipc	ra,0xfffff
    8000483c:	4b8080e7          	jalr	1208(ra) # 80003cf0 <filewrite>
}
    80004840:	70a2                	ld	ra,40(sp)
    80004842:	7402                	ld	s0,32(sp)
    80004844:	6145                	addi	sp,sp,48
    80004846:	8082                	ret

0000000080004848 <sys_close>:
{
    80004848:	1101                	addi	sp,sp,-32
    8000484a:	ec06                	sd	ra,24(sp)
    8000484c:	e822                	sd	s0,16(sp)
    8000484e:	1000                	addi	s0,sp,32
    if (argfd(0, &fd, &f) < 0)
    80004850:	fe040613          	addi	a2,s0,-32
    80004854:	fec40593          	addi	a1,s0,-20
    80004858:	4501                	li	a0,0
    8000485a:	00000097          	auipc	ra,0x0
    8000485e:	cc2080e7          	jalr	-830(ra) # 8000451c <argfd>
        return -1;
    80004862:	57fd                	li	a5,-1
    if (argfd(0, &fd, &f) < 0)
    80004864:	02054463          	bltz	a0,8000488c <sys_close+0x44>
    myproc()->ofile[fd] = 0;
    80004868:	ffffc097          	auipc	ra,0xffffc
    8000486c:	5fa080e7          	jalr	1530(ra) # 80000e62 <myproc>
    80004870:	fec42783          	lw	a5,-20(s0)
    80004874:	07e9                	addi	a5,a5,26
    80004876:	078e                	slli	a5,a5,0x3
    80004878:	97aa                	add	a5,a5,a0
    8000487a:	0007b023          	sd	zero,0(a5)
    fileclose(f);
    8000487e:	fe043503          	ld	a0,-32(s0)
    80004882:	fffff097          	auipc	ra,0xfffff
    80004886:	218080e7          	jalr	536(ra) # 80003a9a <fileclose>
    return 0;
    8000488a:	4781                	li	a5,0
}
    8000488c:	853e                	mv	a0,a5
    8000488e:	60e2                	ld	ra,24(sp)
    80004890:	6442                	ld	s0,16(sp)
    80004892:	6105                	addi	sp,sp,32
    80004894:	8082                	ret

0000000080004896 <sys_fstat>:
{
    80004896:	1101                	addi	sp,sp,-32
    80004898:	ec06                	sd	ra,24(sp)
    8000489a:	e822                	sd	s0,16(sp)
    8000489c:	1000                	addi	s0,sp,32
    argaddr(1, &st);
    8000489e:	fe040593          	addi	a1,s0,-32
    800048a2:	4505                	li	a0,1
    800048a4:	ffffe097          	auipc	ra,0xffffe
    800048a8:	80e080e7          	jalr	-2034(ra) # 800020b2 <argaddr>
    if (argfd(0, 0, &f) < 0)
    800048ac:	fe840613          	addi	a2,s0,-24
    800048b0:	4581                	li	a1,0
    800048b2:	4501                	li	a0,0
    800048b4:	00000097          	auipc	ra,0x0
    800048b8:	c68080e7          	jalr	-920(ra) # 8000451c <argfd>
    800048bc:	87aa                	mv	a5,a0
        return -1;
    800048be:	557d                	li	a0,-1
    if (argfd(0, 0, &f) < 0)
    800048c0:	0007ca63          	bltz	a5,800048d4 <sys_fstat+0x3e>
    return filestat(f, st);
    800048c4:	fe043583          	ld	a1,-32(s0)
    800048c8:	fe843503          	ld	a0,-24(s0)
    800048cc:	fffff097          	auipc	ra,0xfffff
    800048d0:	296080e7          	jalr	662(ra) # 80003b62 <filestat>
}
    800048d4:	60e2                	ld	ra,24(sp)
    800048d6:	6442                	ld	s0,16(sp)
    800048d8:	6105                	addi	sp,sp,32
    800048da:	8082                	ret

00000000800048dc <sys_link>:
{
    800048dc:	7169                	addi	sp,sp,-304
    800048de:	f606                	sd	ra,296(sp)
    800048e0:	f222                	sd	s0,288(sp)
    800048e2:	ee26                	sd	s1,280(sp)
    800048e4:	ea4a                	sd	s2,272(sp)
    800048e6:	1a00                	addi	s0,sp,304
    if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800048e8:	08000613          	li	a2,128
    800048ec:	ed040593          	addi	a1,s0,-304
    800048f0:	4501                	li	a0,0
    800048f2:	ffffd097          	auipc	ra,0xffffd
    800048f6:	7e0080e7          	jalr	2016(ra) # 800020d2 <argstr>
        return -1;
    800048fa:	57fd                	li	a5,-1
    if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800048fc:	10054e63          	bltz	a0,80004a18 <sys_link+0x13c>
    80004900:	08000613          	li	a2,128
    80004904:	f5040593          	addi	a1,s0,-176
    80004908:	4505                	li	a0,1
    8000490a:	ffffd097          	auipc	ra,0xffffd
    8000490e:	7c8080e7          	jalr	1992(ra) # 800020d2 <argstr>
        return -1;
    80004912:	57fd                	li	a5,-1
    if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004914:	10054263          	bltz	a0,80004a18 <sys_link+0x13c>
    begin_op();
    80004918:	fffff097          	auipc	ra,0xfffff
    8000491c:	cb6080e7          	jalr	-842(ra) # 800035ce <begin_op>
    if ((ip = namei(old)) == 0)
    80004920:	ed040513          	addi	a0,s0,-304
    80004924:	fffff097          	auipc	ra,0xfffff
    80004928:	a8e080e7          	jalr	-1394(ra) # 800033b2 <namei>
    8000492c:	84aa                	mv	s1,a0
    8000492e:	c551                	beqz	a0,800049ba <sys_link+0xde>
    ilock(ip);
    80004930:	ffffe097          	auipc	ra,0xffffe
    80004934:	2dc080e7          	jalr	732(ra) # 80002c0c <ilock>
    if (ip->type == T_DIR)
    80004938:	04449703          	lh	a4,68(s1)
    8000493c:	4785                	li	a5,1
    8000493e:	08f70463          	beq	a4,a5,800049c6 <sys_link+0xea>
    ip->nlink++;
    80004942:	04a4d783          	lhu	a5,74(s1)
    80004946:	2785                	addiw	a5,a5,1
    80004948:	04f49523          	sh	a5,74(s1)
    iupdate(ip);
    8000494c:	8526                	mv	a0,s1
    8000494e:	ffffe097          	auipc	ra,0xffffe
    80004952:	1f4080e7          	jalr	500(ra) # 80002b42 <iupdate>
    iunlock(ip);
    80004956:	8526                	mv	a0,s1
    80004958:	ffffe097          	auipc	ra,0xffffe
    8000495c:	376080e7          	jalr	886(ra) # 80002cce <iunlock>
    if ((dp = nameiparent(new, name)) == 0)
    80004960:	fd040593          	addi	a1,s0,-48
    80004964:	f5040513          	addi	a0,s0,-176
    80004968:	fffff097          	auipc	ra,0xfffff
    8000496c:	a68080e7          	jalr	-1432(ra) # 800033d0 <nameiparent>
    80004970:	892a                	mv	s2,a0
    80004972:	c935                	beqz	a0,800049e6 <sys_link+0x10a>
    ilock(dp);
    80004974:	ffffe097          	auipc	ra,0xffffe
    80004978:	298080e7          	jalr	664(ra) # 80002c0c <ilock>
    if (dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0)
    8000497c:	00092703          	lw	a4,0(s2)
    80004980:	409c                	lw	a5,0(s1)
    80004982:	04f71d63          	bne	a4,a5,800049dc <sys_link+0x100>
    80004986:	40d0                	lw	a2,4(s1)
    80004988:	fd040593          	addi	a1,s0,-48
    8000498c:	854a                	mv	a0,s2
    8000498e:	fffff097          	auipc	ra,0xfffff
    80004992:	972080e7          	jalr	-1678(ra) # 80003300 <dirlink>
    80004996:	04054363          	bltz	a0,800049dc <sys_link+0x100>
    iunlockput(dp);
    8000499a:	854a                	mv	a0,s2
    8000499c:	ffffe097          	auipc	ra,0xffffe
    800049a0:	4d2080e7          	jalr	1234(ra) # 80002e6e <iunlockput>
    iput(ip);
    800049a4:	8526                	mv	a0,s1
    800049a6:	ffffe097          	auipc	ra,0xffffe
    800049aa:	420080e7          	jalr	1056(ra) # 80002dc6 <iput>
    end_op();
    800049ae:	fffff097          	auipc	ra,0xfffff
    800049b2:	ca0080e7          	jalr	-864(ra) # 8000364e <end_op>
    return 0;
    800049b6:	4781                	li	a5,0
    800049b8:	a085                	j	80004a18 <sys_link+0x13c>
        end_op();
    800049ba:	fffff097          	auipc	ra,0xfffff
    800049be:	c94080e7          	jalr	-876(ra) # 8000364e <end_op>
        return -1;
    800049c2:	57fd                	li	a5,-1
    800049c4:	a891                	j	80004a18 <sys_link+0x13c>
        iunlockput(ip);
    800049c6:	8526                	mv	a0,s1
    800049c8:	ffffe097          	auipc	ra,0xffffe
    800049cc:	4a6080e7          	jalr	1190(ra) # 80002e6e <iunlockput>
        end_op();
    800049d0:	fffff097          	auipc	ra,0xfffff
    800049d4:	c7e080e7          	jalr	-898(ra) # 8000364e <end_op>
        return -1;
    800049d8:	57fd                	li	a5,-1
    800049da:	a83d                	j	80004a18 <sys_link+0x13c>
        iunlockput(dp);
    800049dc:	854a                	mv	a0,s2
    800049de:	ffffe097          	auipc	ra,0xffffe
    800049e2:	490080e7          	jalr	1168(ra) # 80002e6e <iunlockput>
    ilock(ip);
    800049e6:	8526                	mv	a0,s1
    800049e8:	ffffe097          	auipc	ra,0xffffe
    800049ec:	224080e7          	jalr	548(ra) # 80002c0c <ilock>
    ip->nlink--;
    800049f0:	04a4d783          	lhu	a5,74(s1)
    800049f4:	37fd                	addiw	a5,a5,-1
    800049f6:	04f49523          	sh	a5,74(s1)
    iupdate(ip);
    800049fa:	8526                	mv	a0,s1
    800049fc:	ffffe097          	auipc	ra,0xffffe
    80004a00:	146080e7          	jalr	326(ra) # 80002b42 <iupdate>
    iunlockput(ip);
    80004a04:	8526                	mv	a0,s1
    80004a06:	ffffe097          	auipc	ra,0xffffe
    80004a0a:	468080e7          	jalr	1128(ra) # 80002e6e <iunlockput>
    end_op();
    80004a0e:	fffff097          	auipc	ra,0xfffff
    80004a12:	c40080e7          	jalr	-960(ra) # 8000364e <end_op>
    return -1;
    80004a16:	57fd                	li	a5,-1
}
    80004a18:	853e                	mv	a0,a5
    80004a1a:	70b2                	ld	ra,296(sp)
    80004a1c:	7412                	ld	s0,288(sp)
    80004a1e:	64f2                	ld	s1,280(sp)
    80004a20:	6952                	ld	s2,272(sp)
    80004a22:	6155                	addi	sp,sp,304
    80004a24:	8082                	ret

0000000080004a26 <sys_unlink>:
{
    80004a26:	7151                	addi	sp,sp,-240
    80004a28:	f586                	sd	ra,232(sp)
    80004a2a:	f1a2                	sd	s0,224(sp)
    80004a2c:	eda6                	sd	s1,216(sp)
    80004a2e:	e9ca                	sd	s2,208(sp)
    80004a30:	e5ce                	sd	s3,200(sp)
    80004a32:	1980                	addi	s0,sp,240
    if (argstr(0, path, MAXPATH) < 0)
    80004a34:	08000613          	li	a2,128
    80004a38:	f3040593          	addi	a1,s0,-208
    80004a3c:	4501                	li	a0,0
    80004a3e:	ffffd097          	auipc	ra,0xffffd
    80004a42:	694080e7          	jalr	1684(ra) # 800020d2 <argstr>
    80004a46:	18054163          	bltz	a0,80004bc8 <sys_unlink+0x1a2>
    begin_op();
    80004a4a:	fffff097          	auipc	ra,0xfffff
    80004a4e:	b84080e7          	jalr	-1148(ra) # 800035ce <begin_op>
    if ((dp = nameiparent(path, name)) == 0)
    80004a52:	fb040593          	addi	a1,s0,-80
    80004a56:	f3040513          	addi	a0,s0,-208
    80004a5a:	fffff097          	auipc	ra,0xfffff
    80004a5e:	976080e7          	jalr	-1674(ra) # 800033d0 <nameiparent>
    80004a62:	84aa                	mv	s1,a0
    80004a64:	c979                	beqz	a0,80004b3a <sys_unlink+0x114>
    ilock(dp);
    80004a66:	ffffe097          	auipc	ra,0xffffe
    80004a6a:	1a6080e7          	jalr	422(ra) # 80002c0c <ilock>
    if (namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004a6e:	00004597          	auipc	a1,0x4
    80004a72:	c7a58593          	addi	a1,a1,-902 # 800086e8 <syscalls+0x2b8>
    80004a76:	fb040513          	addi	a0,s0,-80
    80004a7a:	ffffe097          	auipc	ra,0xffffe
    80004a7e:	65c080e7          	jalr	1628(ra) # 800030d6 <namecmp>
    80004a82:	14050a63          	beqz	a0,80004bd6 <sys_unlink+0x1b0>
    80004a86:	00004597          	auipc	a1,0x4
    80004a8a:	c6a58593          	addi	a1,a1,-918 # 800086f0 <syscalls+0x2c0>
    80004a8e:	fb040513          	addi	a0,s0,-80
    80004a92:	ffffe097          	auipc	ra,0xffffe
    80004a96:	644080e7          	jalr	1604(ra) # 800030d6 <namecmp>
    80004a9a:	12050e63          	beqz	a0,80004bd6 <sys_unlink+0x1b0>
    if ((ip = dirlookup(dp, name, &off)) == 0)
    80004a9e:	f2c40613          	addi	a2,s0,-212
    80004aa2:	fb040593          	addi	a1,s0,-80
    80004aa6:	8526                	mv	a0,s1
    80004aa8:	ffffe097          	auipc	ra,0xffffe
    80004aac:	648080e7          	jalr	1608(ra) # 800030f0 <dirlookup>
    80004ab0:	892a                	mv	s2,a0
    80004ab2:	12050263          	beqz	a0,80004bd6 <sys_unlink+0x1b0>
    ilock(ip);
    80004ab6:	ffffe097          	auipc	ra,0xffffe
    80004aba:	156080e7          	jalr	342(ra) # 80002c0c <ilock>
    if (ip->nlink < 1)
    80004abe:	04a91783          	lh	a5,74(s2)
    80004ac2:	08f05263          	blez	a5,80004b46 <sys_unlink+0x120>
    if (ip->type == T_DIR && !isdirempty(ip))
    80004ac6:	04491703          	lh	a4,68(s2)
    80004aca:	4785                	li	a5,1
    80004acc:	08f70563          	beq	a4,a5,80004b56 <sys_unlink+0x130>
    memset(&de, 0, sizeof(de));
    80004ad0:	4641                	li	a2,16
    80004ad2:	4581                	li	a1,0
    80004ad4:	fc040513          	addi	a0,s0,-64
    80004ad8:	ffffb097          	auipc	ra,0xffffb
    80004adc:	6a0080e7          	jalr	1696(ra) # 80000178 <memset>
    if (writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004ae0:	4741                	li	a4,16
    80004ae2:	f2c42683          	lw	a3,-212(s0)
    80004ae6:	fc040613          	addi	a2,s0,-64
    80004aea:	4581                	li	a1,0
    80004aec:	8526                	mv	a0,s1
    80004aee:	ffffe097          	auipc	ra,0xffffe
    80004af2:	4ca080e7          	jalr	1226(ra) # 80002fb8 <writei>
    80004af6:	47c1                	li	a5,16
    80004af8:	0af51563          	bne	a0,a5,80004ba2 <sys_unlink+0x17c>
    if (ip->type == T_DIR)
    80004afc:	04491703          	lh	a4,68(s2)
    80004b00:	4785                	li	a5,1
    80004b02:	0af70863          	beq	a4,a5,80004bb2 <sys_unlink+0x18c>
    iunlockput(dp);
    80004b06:	8526                	mv	a0,s1
    80004b08:	ffffe097          	auipc	ra,0xffffe
    80004b0c:	366080e7          	jalr	870(ra) # 80002e6e <iunlockput>
    ip->nlink--;
    80004b10:	04a95783          	lhu	a5,74(s2)
    80004b14:	37fd                	addiw	a5,a5,-1
    80004b16:	04f91523          	sh	a5,74(s2)
    iupdate(ip);
    80004b1a:	854a                	mv	a0,s2
    80004b1c:	ffffe097          	auipc	ra,0xffffe
    80004b20:	026080e7          	jalr	38(ra) # 80002b42 <iupdate>
    iunlockput(ip);
    80004b24:	854a                	mv	a0,s2
    80004b26:	ffffe097          	auipc	ra,0xffffe
    80004b2a:	348080e7          	jalr	840(ra) # 80002e6e <iunlockput>
    end_op();
    80004b2e:	fffff097          	auipc	ra,0xfffff
    80004b32:	b20080e7          	jalr	-1248(ra) # 8000364e <end_op>
    return 0;
    80004b36:	4501                	li	a0,0
    80004b38:	a84d                	j	80004bea <sys_unlink+0x1c4>
        end_op();
    80004b3a:	fffff097          	auipc	ra,0xfffff
    80004b3e:	b14080e7          	jalr	-1260(ra) # 8000364e <end_op>
        return -1;
    80004b42:	557d                	li	a0,-1
    80004b44:	a05d                	j	80004bea <sys_unlink+0x1c4>
        panic("unlink: nlink < 1");
    80004b46:	00004517          	auipc	a0,0x4
    80004b4a:	bb250513          	addi	a0,a0,-1102 # 800086f8 <syscalls+0x2c8>
    80004b4e:	00001097          	auipc	ra,0x1
    80004b52:	354080e7          	jalr	852(ra) # 80005ea2 <panic>
    for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de))
    80004b56:	04c92703          	lw	a4,76(s2)
    80004b5a:	02000793          	li	a5,32
    80004b5e:	f6e7f9e3          	bgeu	a5,a4,80004ad0 <sys_unlink+0xaa>
    80004b62:	02000993          	li	s3,32
        if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004b66:	4741                	li	a4,16
    80004b68:	86ce                	mv	a3,s3
    80004b6a:	f1840613          	addi	a2,s0,-232
    80004b6e:	4581                	li	a1,0
    80004b70:	854a                	mv	a0,s2
    80004b72:	ffffe097          	auipc	ra,0xffffe
    80004b76:	34e080e7          	jalr	846(ra) # 80002ec0 <readi>
    80004b7a:	47c1                	li	a5,16
    80004b7c:	00f51b63          	bne	a0,a5,80004b92 <sys_unlink+0x16c>
        if (de.inum != 0)
    80004b80:	f1845783          	lhu	a5,-232(s0)
    80004b84:	e7a1                	bnez	a5,80004bcc <sys_unlink+0x1a6>
    for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de))
    80004b86:	29c1                	addiw	s3,s3,16
    80004b88:	04c92783          	lw	a5,76(s2)
    80004b8c:	fcf9ede3          	bltu	s3,a5,80004b66 <sys_unlink+0x140>
    80004b90:	b781                	j	80004ad0 <sys_unlink+0xaa>
            panic("isdirempty: readi");
    80004b92:	00004517          	auipc	a0,0x4
    80004b96:	b7e50513          	addi	a0,a0,-1154 # 80008710 <syscalls+0x2e0>
    80004b9a:	00001097          	auipc	ra,0x1
    80004b9e:	308080e7          	jalr	776(ra) # 80005ea2 <panic>
        panic("unlink: writei");
    80004ba2:	00004517          	auipc	a0,0x4
    80004ba6:	b8650513          	addi	a0,a0,-1146 # 80008728 <syscalls+0x2f8>
    80004baa:	00001097          	auipc	ra,0x1
    80004bae:	2f8080e7          	jalr	760(ra) # 80005ea2 <panic>
        dp->nlink--;
    80004bb2:	04a4d783          	lhu	a5,74(s1)
    80004bb6:	37fd                	addiw	a5,a5,-1
    80004bb8:	04f49523          	sh	a5,74(s1)
        iupdate(dp);
    80004bbc:	8526                	mv	a0,s1
    80004bbe:	ffffe097          	auipc	ra,0xffffe
    80004bc2:	f84080e7          	jalr	-124(ra) # 80002b42 <iupdate>
    80004bc6:	b781                	j	80004b06 <sys_unlink+0xe0>
        return -1;
    80004bc8:	557d                	li	a0,-1
    80004bca:	a005                	j	80004bea <sys_unlink+0x1c4>
        iunlockput(ip);
    80004bcc:	854a                	mv	a0,s2
    80004bce:	ffffe097          	auipc	ra,0xffffe
    80004bd2:	2a0080e7          	jalr	672(ra) # 80002e6e <iunlockput>
    iunlockput(dp);
    80004bd6:	8526                	mv	a0,s1
    80004bd8:	ffffe097          	auipc	ra,0xffffe
    80004bdc:	296080e7          	jalr	662(ra) # 80002e6e <iunlockput>
    end_op();
    80004be0:	fffff097          	auipc	ra,0xfffff
    80004be4:	a6e080e7          	jalr	-1426(ra) # 8000364e <end_op>
    return -1;
    80004be8:	557d                	li	a0,-1
}
    80004bea:	70ae                	ld	ra,232(sp)
    80004bec:	740e                	ld	s0,224(sp)
    80004bee:	64ee                	ld	s1,216(sp)
    80004bf0:	694e                	ld	s2,208(sp)
    80004bf2:	69ae                	ld	s3,200(sp)
    80004bf4:	616d                	addi	sp,sp,240
    80004bf6:	8082                	ret

0000000080004bf8 <sys_mmap>:
{
    80004bf8:	711d                	addi	sp,sp,-96
    80004bfa:	ec86                	sd	ra,88(sp)
    80004bfc:	e8a2                	sd	s0,80(sp)
    80004bfe:	e4a6                	sd	s1,72(sp)
    80004c00:	e0ca                	sd	s2,64(sp)
    80004c02:	fc4e                	sd	s3,56(sp)
    80004c04:	1080                	addi	s0,sp,96
    argaddr(0, &addr);
    80004c06:	fc840593          	addi	a1,s0,-56
    80004c0a:	4501                	li	a0,0
    80004c0c:	ffffd097          	auipc	ra,0xffffd
    80004c10:	4a6080e7          	jalr	1190(ra) # 800020b2 <argaddr>
    argint(1, &length);
    80004c14:	fc440593          	addi	a1,s0,-60
    80004c18:	4505                	li	a0,1
    80004c1a:	ffffd097          	auipc	ra,0xffffd
    80004c1e:	478080e7          	jalr	1144(ra) # 80002092 <argint>
    argint(2, &prot);
    80004c22:	fc040593          	addi	a1,s0,-64
    80004c26:	4509                	li	a0,2
    80004c28:	ffffd097          	auipc	ra,0xffffd
    80004c2c:	46a080e7          	jalr	1130(ra) # 80002092 <argint>
    argint(3, &flags);
    80004c30:	fbc40593          	addi	a1,s0,-68
    80004c34:	450d                	li	a0,3
    80004c36:	ffffd097          	auipc	ra,0xffffd
    80004c3a:	45c080e7          	jalr	1116(ra) # 80002092 <argint>
    argfd(4, &fd, &pf);
    80004c3e:	fa840613          	addi	a2,s0,-88
    80004c42:	fb840593          	addi	a1,s0,-72
    80004c46:	4511                	li	a0,4
    80004c48:	00000097          	auipc	ra,0x0
    80004c4c:	8d4080e7          	jalr	-1836(ra) # 8000451c <argfd>
    argint(5, &offset);
    80004c50:	fb440593          	addi	a1,s0,-76
    80004c54:	4515                	li	a0,5
    80004c56:	ffffd097          	auipc	ra,0xffffd
    80004c5a:	43c080e7          	jalr	1084(ra) # 80002092 <argint>
    struct proc *p_proc = myproc(); // create a pointer to process struct
    80004c5e:	ffffc097          	auipc	ra,0xffffc
    80004c62:	204080e7          	jalr	516(ra) # 80000e62 <myproc>
    80004c66:	892a                	mv	s2,a0
            if (p_proc->sz + length <= MAXVA)
    80004c68:	fc442883          	lw	a7,-60(s0)
    80004c6c:	8846                	mv	a6,a7
    80004c6e:	16850793          	addi	a5,a0,360
    for (int i = 0; i <= VMASIZE - 1; i++)
    80004c72:	4481                	li	s1,0
        if (p_proc->vma[i].occupied != 1)
    80004c74:	4605                	li	a2,1
            if (p_proc->sz + length <= MAXVA)
    80004c76:	02661513          	slli	a0,a2,0x26
    for (int i = 0; i <= VMASIZE - 1; i++)
    80004c7a:	45c1                	li	a1,16
    80004c7c:	a031                	j	80004c88 <sys_mmap+0x90>
    80004c7e:	2485                	addiw	s1,s1,1
    80004c80:	03878793          	addi	a5,a5,56
    80004c84:	08b48963          	beq	s1,a1,80004d16 <sys_mmap+0x11e>
        if (p_proc->vma[i].occupied != 1)
    80004c88:	4398                	lw	a4,0(a5)
    80004c8a:	fec70ae3          	beq	a4,a2,80004c7e <sys_mmap+0x86>
            if (p_proc->sz + length <= MAXVA)
    80004c8e:	04893703          	ld	a4,72(s2)
    80004c92:	010706b3          	add	a3,a4,a6
    80004c96:	fed564e3          	bltu	a0,a3,80004c7e <sys_mmap+0x86>
        p_vma->occupied = 1; // denote it is occupied
    80004c9a:	00349993          	slli	s3,s1,0x3
    80004c9e:	409987b3          	sub	a5,s3,s1
    80004ca2:	078e                	slli	a5,a5,0x3
    80004ca4:	97ca                	add	a5,a5,s2
    80004ca6:	4685                	li	a3,1
    80004ca8:	16d7a423          	sw	a3,360(a5)
        p_vma->start_addr = p_proc->sz - length;
    80004cac:	411706bb          	subw	a3,a4,a7
    80004cb0:	16d7a623          	sw	a3,364(a5)
        p_vma->end_addr = p_proc->sz;
    80004cb4:	16e7a823          	sw	a4,368(a5)
        p_proc->sz -= length;
    80004cb8:	41170733          	sub	a4,a4,a7
    80004cbc:	04e93423          	sd	a4,72(s2)
        p_vma->addr = addr;
    80004cc0:	fc843703          	ld	a4,-56(s0)
    80004cc4:	16e7bc23          	sd	a4,376(a5)
        p_vma->length = length;
    80004cc8:	1917a023          	sw	a7,384(a5)
        p_vma->prot = prot;
    80004ccc:	fc042703          	lw	a4,-64(s0)
    80004cd0:	18e7a223          	sw	a4,388(a5)
        p_vma->flags = flags;
    80004cd4:	fbc42703          	lw	a4,-68(s0)
    80004cd8:	18e7a423          	sw	a4,392(a5)
        p_vma->fd = fd;
    80004cdc:	fb842703          	lw	a4,-72(s0)
    80004ce0:	18e7a623          	sw	a4,396(a5)
        p_vma->offset = offset;
    80004ce4:	fb442703          	lw	a4,-76(s0)
    80004ce8:	18e7a823          	sw	a4,400(a5)
        p_vma->pf = pf;
    80004cec:	fa843503          	ld	a0,-88(s0)
    80004cf0:	18a7bc23          	sd	a0,408(a5)
        filedup(p_vma->pf);
    80004cf4:	fffff097          	auipc	ra,0xfffff
    80004cf8:	d54080e7          	jalr	-684(ra) # 80003a48 <filedup>
        return (p_vma->start_addr);
    80004cfc:	409984b3          	sub	s1,s3,s1
    80004d00:	048e                	slli	s1,s1,0x3
    80004d02:	9926                	add	s2,s2,s1
    80004d04:	16c92503          	lw	a0,364(s2)
}
    80004d08:	60e6                	ld	ra,88(sp)
    80004d0a:	6446                	ld	s0,80(sp)
    80004d0c:	64a6                	ld	s1,72(sp)
    80004d0e:	6906                	ld	s2,64(sp)
    80004d10:	79e2                	ld	s3,56(sp)
    80004d12:	6125                	addi	sp,sp,96
    80004d14:	8082                	ret
        panic("syscall mmap");
    80004d16:	00004517          	auipc	a0,0x4
    80004d1a:	a2250513          	addi	a0,a0,-1502 # 80008738 <syscalls+0x308>
    80004d1e:	00001097          	auipc	ra,0x1
    80004d22:	184080e7          	jalr	388(ra) # 80005ea2 <panic>

0000000080004d26 <sys_munmap>:
{
    80004d26:	1141                	addi	sp,sp,-16
    80004d28:	e422                	sd	s0,8(sp)
    80004d2a:	0800                	addi	s0,sp,16
}
    80004d2c:	4501                	li	a0,0
    80004d2e:	6422                	ld	s0,8(sp)
    80004d30:	0141                	addi	sp,sp,16
    80004d32:	8082                	ret

0000000080004d34 <sys_open>:

uint64
sys_open(void)
{
    80004d34:	7131                	addi	sp,sp,-192
    80004d36:	fd06                	sd	ra,184(sp)
    80004d38:	f922                	sd	s0,176(sp)
    80004d3a:	f526                	sd	s1,168(sp)
    80004d3c:	f14a                	sd	s2,160(sp)
    80004d3e:	ed4e                	sd	s3,152(sp)
    80004d40:	0180                	addi	s0,sp,192
    int fd, omode;
    struct file *f;
    struct inode *ip;
    int n;

    argint(1, &omode);
    80004d42:	f4c40593          	addi	a1,s0,-180
    80004d46:	4505                	li	a0,1
    80004d48:	ffffd097          	auipc	ra,0xffffd
    80004d4c:	34a080e7          	jalr	842(ra) # 80002092 <argint>
    if ((n = argstr(0, path, MAXPATH)) < 0)
    80004d50:	08000613          	li	a2,128
    80004d54:	f5040593          	addi	a1,s0,-176
    80004d58:	4501                	li	a0,0
    80004d5a:	ffffd097          	auipc	ra,0xffffd
    80004d5e:	378080e7          	jalr	888(ra) # 800020d2 <argstr>
    80004d62:	87aa                	mv	a5,a0
        return -1;
    80004d64:	557d                	li	a0,-1
    if ((n = argstr(0, path, MAXPATH)) < 0)
    80004d66:	0a07c963          	bltz	a5,80004e18 <sys_open+0xe4>

    begin_op();
    80004d6a:	fffff097          	auipc	ra,0xfffff
    80004d6e:	864080e7          	jalr	-1948(ra) # 800035ce <begin_op>

    if (omode & O_CREATE)
    80004d72:	f4c42783          	lw	a5,-180(s0)
    80004d76:	2007f793          	andi	a5,a5,512
    80004d7a:	cfc5                	beqz	a5,80004e32 <sys_open+0xfe>
    {
        ip = create(path, T_FILE, 0, 0);
    80004d7c:	4681                	li	a3,0
    80004d7e:	4601                	li	a2,0
    80004d80:	4589                	li	a1,2
    80004d82:	f5040513          	addi	a0,s0,-176
    80004d86:	00000097          	auipc	ra,0x0
    80004d8a:	838080e7          	jalr	-1992(ra) # 800045be <create>
    80004d8e:	84aa                	mv	s1,a0
        if (ip == 0)
    80004d90:	c959                	beqz	a0,80004e26 <sys_open+0xf2>
            end_op();
            return -1;
        }
    }

    if (ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV))
    80004d92:	04449703          	lh	a4,68(s1)
    80004d96:	478d                	li	a5,3
    80004d98:	00f71763          	bne	a4,a5,80004da6 <sys_open+0x72>
    80004d9c:	0464d703          	lhu	a4,70(s1)
    80004da0:	47a5                	li	a5,9
    80004da2:	0ce7ed63          	bltu	a5,a4,80004e7c <sys_open+0x148>
        iunlockput(ip);
        end_op();
        return -1;
    }

    if ((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0)
    80004da6:	fffff097          	auipc	ra,0xfffff
    80004daa:	c38080e7          	jalr	-968(ra) # 800039de <filealloc>
    80004dae:	89aa                	mv	s3,a0
    80004db0:	10050363          	beqz	a0,80004eb6 <sys_open+0x182>
    80004db4:	fffff097          	auipc	ra,0xfffff
    80004db8:	7c8080e7          	jalr	1992(ra) # 8000457c <fdalloc>
    80004dbc:	892a                	mv	s2,a0
    80004dbe:	0e054763          	bltz	a0,80004eac <sys_open+0x178>
        iunlockput(ip);
        end_op();
        return -1;
    }

    if (ip->type == T_DEVICE)
    80004dc2:	04449703          	lh	a4,68(s1)
    80004dc6:	478d                	li	a5,3
    80004dc8:	0cf70563          	beq	a4,a5,80004e92 <sys_open+0x15e>
        f->type = FD_DEVICE;
        f->major = ip->major;
    }
    else
    {
        f->type = FD_INODE;
    80004dcc:	4789                	li	a5,2
    80004dce:	00f9a023          	sw	a5,0(s3)
        f->off = 0;
    80004dd2:	0209a023          	sw	zero,32(s3)
    }
    f->ip = ip;
    80004dd6:	0099bc23          	sd	s1,24(s3)
    f->readable = !(omode & O_WRONLY);
    80004dda:	f4c42783          	lw	a5,-180(s0)
    80004dde:	0017c713          	xori	a4,a5,1
    80004de2:	8b05                	andi	a4,a4,1
    80004de4:	00e98423          	sb	a4,8(s3)
    f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004de8:	0037f713          	andi	a4,a5,3
    80004dec:	00e03733          	snez	a4,a4
    80004df0:	00e984a3          	sb	a4,9(s3)

    if ((omode & O_TRUNC) && ip->type == T_FILE)
    80004df4:	4007f793          	andi	a5,a5,1024
    80004df8:	c791                	beqz	a5,80004e04 <sys_open+0xd0>
    80004dfa:	04449703          	lh	a4,68(s1)
    80004dfe:	4789                	li	a5,2
    80004e00:	0af70063          	beq	a4,a5,80004ea0 <sys_open+0x16c>
    {
        itrunc(ip);
    }

    iunlock(ip);
    80004e04:	8526                	mv	a0,s1
    80004e06:	ffffe097          	auipc	ra,0xffffe
    80004e0a:	ec8080e7          	jalr	-312(ra) # 80002cce <iunlock>
    end_op();
    80004e0e:	fffff097          	auipc	ra,0xfffff
    80004e12:	840080e7          	jalr	-1984(ra) # 8000364e <end_op>

    return fd;
    80004e16:	854a                	mv	a0,s2
}
    80004e18:	70ea                	ld	ra,184(sp)
    80004e1a:	744a                	ld	s0,176(sp)
    80004e1c:	74aa                	ld	s1,168(sp)
    80004e1e:	790a                	ld	s2,160(sp)
    80004e20:	69ea                	ld	s3,152(sp)
    80004e22:	6129                	addi	sp,sp,192
    80004e24:	8082                	ret
            end_op();
    80004e26:	fffff097          	auipc	ra,0xfffff
    80004e2a:	828080e7          	jalr	-2008(ra) # 8000364e <end_op>
            return -1;
    80004e2e:	557d                	li	a0,-1
    80004e30:	b7e5                	j	80004e18 <sys_open+0xe4>
        if ((ip = namei(path)) == 0)
    80004e32:	f5040513          	addi	a0,s0,-176
    80004e36:	ffffe097          	auipc	ra,0xffffe
    80004e3a:	57c080e7          	jalr	1404(ra) # 800033b2 <namei>
    80004e3e:	84aa                	mv	s1,a0
    80004e40:	c905                	beqz	a0,80004e70 <sys_open+0x13c>
        ilock(ip);
    80004e42:	ffffe097          	auipc	ra,0xffffe
    80004e46:	dca080e7          	jalr	-566(ra) # 80002c0c <ilock>
        if (ip->type == T_DIR && omode != O_RDONLY)
    80004e4a:	04449703          	lh	a4,68(s1)
    80004e4e:	4785                	li	a5,1
    80004e50:	f4f711e3          	bne	a4,a5,80004d92 <sys_open+0x5e>
    80004e54:	f4c42783          	lw	a5,-180(s0)
    80004e58:	d7b9                	beqz	a5,80004da6 <sys_open+0x72>
            iunlockput(ip);
    80004e5a:	8526                	mv	a0,s1
    80004e5c:	ffffe097          	auipc	ra,0xffffe
    80004e60:	012080e7          	jalr	18(ra) # 80002e6e <iunlockput>
            end_op();
    80004e64:	ffffe097          	auipc	ra,0xffffe
    80004e68:	7ea080e7          	jalr	2026(ra) # 8000364e <end_op>
            return -1;
    80004e6c:	557d                	li	a0,-1
    80004e6e:	b76d                	j	80004e18 <sys_open+0xe4>
            end_op();
    80004e70:	ffffe097          	auipc	ra,0xffffe
    80004e74:	7de080e7          	jalr	2014(ra) # 8000364e <end_op>
            return -1;
    80004e78:	557d                	li	a0,-1
    80004e7a:	bf79                	j	80004e18 <sys_open+0xe4>
        iunlockput(ip);
    80004e7c:	8526                	mv	a0,s1
    80004e7e:	ffffe097          	auipc	ra,0xffffe
    80004e82:	ff0080e7          	jalr	-16(ra) # 80002e6e <iunlockput>
        end_op();
    80004e86:	ffffe097          	auipc	ra,0xffffe
    80004e8a:	7c8080e7          	jalr	1992(ra) # 8000364e <end_op>
        return -1;
    80004e8e:	557d                	li	a0,-1
    80004e90:	b761                	j	80004e18 <sys_open+0xe4>
        f->type = FD_DEVICE;
    80004e92:	00f9a023          	sw	a5,0(s3)
        f->major = ip->major;
    80004e96:	04649783          	lh	a5,70(s1)
    80004e9a:	02f99223          	sh	a5,36(s3)
    80004e9e:	bf25                	j	80004dd6 <sys_open+0xa2>
        itrunc(ip);
    80004ea0:	8526                	mv	a0,s1
    80004ea2:	ffffe097          	auipc	ra,0xffffe
    80004ea6:	e78080e7          	jalr	-392(ra) # 80002d1a <itrunc>
    80004eaa:	bfa9                	j	80004e04 <sys_open+0xd0>
            fileclose(f);
    80004eac:	854e                	mv	a0,s3
    80004eae:	fffff097          	auipc	ra,0xfffff
    80004eb2:	bec080e7          	jalr	-1044(ra) # 80003a9a <fileclose>
        iunlockput(ip);
    80004eb6:	8526                	mv	a0,s1
    80004eb8:	ffffe097          	auipc	ra,0xffffe
    80004ebc:	fb6080e7          	jalr	-74(ra) # 80002e6e <iunlockput>
        end_op();
    80004ec0:	ffffe097          	auipc	ra,0xffffe
    80004ec4:	78e080e7          	jalr	1934(ra) # 8000364e <end_op>
        return -1;
    80004ec8:	557d                	li	a0,-1
    80004eca:	b7b9                	j	80004e18 <sys_open+0xe4>

0000000080004ecc <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004ecc:	7175                	addi	sp,sp,-144
    80004ece:	e506                	sd	ra,136(sp)
    80004ed0:	e122                	sd	s0,128(sp)
    80004ed2:	0900                	addi	s0,sp,144
    char path[MAXPATH];
    struct inode *ip;

    begin_op();
    80004ed4:	ffffe097          	auipc	ra,0xffffe
    80004ed8:	6fa080e7          	jalr	1786(ra) # 800035ce <begin_op>
    if (argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0)
    80004edc:	08000613          	li	a2,128
    80004ee0:	f7040593          	addi	a1,s0,-144
    80004ee4:	4501                	li	a0,0
    80004ee6:	ffffd097          	auipc	ra,0xffffd
    80004eea:	1ec080e7          	jalr	492(ra) # 800020d2 <argstr>
    80004eee:	02054963          	bltz	a0,80004f20 <sys_mkdir+0x54>
    80004ef2:	4681                	li	a3,0
    80004ef4:	4601                	li	a2,0
    80004ef6:	4585                	li	a1,1
    80004ef8:	f7040513          	addi	a0,s0,-144
    80004efc:	fffff097          	auipc	ra,0xfffff
    80004f00:	6c2080e7          	jalr	1730(ra) # 800045be <create>
    80004f04:	cd11                	beqz	a0,80004f20 <sys_mkdir+0x54>
    {
        end_op();
        return -1;
    }
    iunlockput(ip);
    80004f06:	ffffe097          	auipc	ra,0xffffe
    80004f0a:	f68080e7          	jalr	-152(ra) # 80002e6e <iunlockput>
    end_op();
    80004f0e:	ffffe097          	auipc	ra,0xffffe
    80004f12:	740080e7          	jalr	1856(ra) # 8000364e <end_op>
    return 0;
    80004f16:	4501                	li	a0,0
}
    80004f18:	60aa                	ld	ra,136(sp)
    80004f1a:	640a                	ld	s0,128(sp)
    80004f1c:	6149                	addi	sp,sp,144
    80004f1e:	8082                	ret
        end_op();
    80004f20:	ffffe097          	auipc	ra,0xffffe
    80004f24:	72e080e7          	jalr	1838(ra) # 8000364e <end_op>
        return -1;
    80004f28:	557d                	li	a0,-1
    80004f2a:	b7fd                	j	80004f18 <sys_mkdir+0x4c>

0000000080004f2c <sys_mknod>:

uint64
sys_mknod(void)
{
    80004f2c:	7135                	addi	sp,sp,-160
    80004f2e:	ed06                	sd	ra,152(sp)
    80004f30:	e922                	sd	s0,144(sp)
    80004f32:	1100                	addi	s0,sp,160
    struct inode *ip;
    char path[MAXPATH];
    int major, minor;

    begin_op();
    80004f34:	ffffe097          	auipc	ra,0xffffe
    80004f38:	69a080e7          	jalr	1690(ra) # 800035ce <begin_op>
    argint(1, &major);
    80004f3c:	f6c40593          	addi	a1,s0,-148
    80004f40:	4505                	li	a0,1
    80004f42:	ffffd097          	auipc	ra,0xffffd
    80004f46:	150080e7          	jalr	336(ra) # 80002092 <argint>
    argint(2, &minor);
    80004f4a:	f6840593          	addi	a1,s0,-152
    80004f4e:	4509                	li	a0,2
    80004f50:	ffffd097          	auipc	ra,0xffffd
    80004f54:	142080e7          	jalr	322(ra) # 80002092 <argint>
    if ((argstr(0, path, MAXPATH)) < 0 ||
    80004f58:	08000613          	li	a2,128
    80004f5c:	f7040593          	addi	a1,s0,-144
    80004f60:	4501                	li	a0,0
    80004f62:	ffffd097          	auipc	ra,0xffffd
    80004f66:	170080e7          	jalr	368(ra) # 800020d2 <argstr>
    80004f6a:	02054b63          	bltz	a0,80004fa0 <sys_mknod+0x74>
        (ip = create(path, T_DEVICE, major, minor)) == 0)
    80004f6e:	f6841683          	lh	a3,-152(s0)
    80004f72:	f6c41603          	lh	a2,-148(s0)
    80004f76:	458d                	li	a1,3
    80004f78:	f7040513          	addi	a0,s0,-144
    80004f7c:	fffff097          	auipc	ra,0xfffff
    80004f80:	642080e7          	jalr	1602(ra) # 800045be <create>
    if ((argstr(0, path, MAXPATH)) < 0 ||
    80004f84:	cd11                	beqz	a0,80004fa0 <sys_mknod+0x74>
    {
        end_op();
        return -1;
    }
    iunlockput(ip);
    80004f86:	ffffe097          	auipc	ra,0xffffe
    80004f8a:	ee8080e7          	jalr	-280(ra) # 80002e6e <iunlockput>
    end_op();
    80004f8e:	ffffe097          	auipc	ra,0xffffe
    80004f92:	6c0080e7          	jalr	1728(ra) # 8000364e <end_op>
    return 0;
    80004f96:	4501                	li	a0,0
}
    80004f98:	60ea                	ld	ra,152(sp)
    80004f9a:	644a                	ld	s0,144(sp)
    80004f9c:	610d                	addi	sp,sp,160
    80004f9e:	8082                	ret
        end_op();
    80004fa0:	ffffe097          	auipc	ra,0xffffe
    80004fa4:	6ae080e7          	jalr	1710(ra) # 8000364e <end_op>
        return -1;
    80004fa8:	557d                	li	a0,-1
    80004faa:	b7fd                	j	80004f98 <sys_mknod+0x6c>

0000000080004fac <sys_chdir>:

uint64
sys_chdir(void)
{
    80004fac:	7135                	addi	sp,sp,-160
    80004fae:	ed06                	sd	ra,152(sp)
    80004fb0:	e922                	sd	s0,144(sp)
    80004fb2:	e526                	sd	s1,136(sp)
    80004fb4:	e14a                	sd	s2,128(sp)
    80004fb6:	1100                	addi	s0,sp,160
    char path[MAXPATH];
    struct inode *ip;
    struct proc *p = myproc();
    80004fb8:	ffffc097          	auipc	ra,0xffffc
    80004fbc:	eaa080e7          	jalr	-342(ra) # 80000e62 <myproc>
    80004fc0:	892a                	mv	s2,a0

    begin_op();
    80004fc2:	ffffe097          	auipc	ra,0xffffe
    80004fc6:	60c080e7          	jalr	1548(ra) # 800035ce <begin_op>
    if (argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0)
    80004fca:	08000613          	li	a2,128
    80004fce:	f6040593          	addi	a1,s0,-160
    80004fd2:	4501                	li	a0,0
    80004fd4:	ffffd097          	auipc	ra,0xffffd
    80004fd8:	0fe080e7          	jalr	254(ra) # 800020d2 <argstr>
    80004fdc:	04054b63          	bltz	a0,80005032 <sys_chdir+0x86>
    80004fe0:	f6040513          	addi	a0,s0,-160
    80004fe4:	ffffe097          	auipc	ra,0xffffe
    80004fe8:	3ce080e7          	jalr	974(ra) # 800033b2 <namei>
    80004fec:	84aa                	mv	s1,a0
    80004fee:	c131                	beqz	a0,80005032 <sys_chdir+0x86>
    {
        end_op();
        return -1;
    }
    ilock(ip);
    80004ff0:	ffffe097          	auipc	ra,0xffffe
    80004ff4:	c1c080e7          	jalr	-996(ra) # 80002c0c <ilock>
    if (ip->type != T_DIR)
    80004ff8:	04449703          	lh	a4,68(s1)
    80004ffc:	4785                	li	a5,1
    80004ffe:	04f71063          	bne	a4,a5,8000503e <sys_chdir+0x92>
    {
        iunlockput(ip);
        end_op();
        return -1;
    }
    iunlock(ip);
    80005002:	8526                	mv	a0,s1
    80005004:	ffffe097          	auipc	ra,0xffffe
    80005008:	cca080e7          	jalr	-822(ra) # 80002cce <iunlock>
    iput(p->cwd);
    8000500c:	15093503          	ld	a0,336(s2)
    80005010:	ffffe097          	auipc	ra,0xffffe
    80005014:	db6080e7          	jalr	-586(ra) # 80002dc6 <iput>
    end_op();
    80005018:	ffffe097          	auipc	ra,0xffffe
    8000501c:	636080e7          	jalr	1590(ra) # 8000364e <end_op>
    p->cwd = ip;
    80005020:	14993823          	sd	s1,336(s2)
    return 0;
    80005024:	4501                	li	a0,0
}
    80005026:	60ea                	ld	ra,152(sp)
    80005028:	644a                	ld	s0,144(sp)
    8000502a:	64aa                	ld	s1,136(sp)
    8000502c:	690a                	ld	s2,128(sp)
    8000502e:	610d                	addi	sp,sp,160
    80005030:	8082                	ret
        end_op();
    80005032:	ffffe097          	auipc	ra,0xffffe
    80005036:	61c080e7          	jalr	1564(ra) # 8000364e <end_op>
        return -1;
    8000503a:	557d                	li	a0,-1
    8000503c:	b7ed                	j	80005026 <sys_chdir+0x7a>
        iunlockput(ip);
    8000503e:	8526                	mv	a0,s1
    80005040:	ffffe097          	auipc	ra,0xffffe
    80005044:	e2e080e7          	jalr	-466(ra) # 80002e6e <iunlockput>
        end_op();
    80005048:	ffffe097          	auipc	ra,0xffffe
    8000504c:	606080e7          	jalr	1542(ra) # 8000364e <end_op>
        return -1;
    80005050:	557d                	li	a0,-1
    80005052:	bfd1                	j	80005026 <sys_chdir+0x7a>

0000000080005054 <sys_exec>:

uint64
sys_exec(void)
{
    80005054:	7145                	addi	sp,sp,-464
    80005056:	e786                	sd	ra,456(sp)
    80005058:	e3a2                	sd	s0,448(sp)
    8000505a:	ff26                	sd	s1,440(sp)
    8000505c:	fb4a                	sd	s2,432(sp)
    8000505e:	f74e                	sd	s3,424(sp)
    80005060:	f352                	sd	s4,416(sp)
    80005062:	ef56                	sd	s5,408(sp)
    80005064:	0b80                	addi	s0,sp,464
    char path[MAXPATH], *argv[MAXARG];
    int i;
    uint64 uargv, uarg;

    argaddr(1, &uargv);
    80005066:	e3840593          	addi	a1,s0,-456
    8000506a:	4505                	li	a0,1
    8000506c:	ffffd097          	auipc	ra,0xffffd
    80005070:	046080e7          	jalr	70(ra) # 800020b2 <argaddr>
    if (argstr(0, path, MAXPATH) < 0)
    80005074:	08000613          	li	a2,128
    80005078:	f4040593          	addi	a1,s0,-192
    8000507c:	4501                	li	a0,0
    8000507e:	ffffd097          	auipc	ra,0xffffd
    80005082:	054080e7          	jalr	84(ra) # 800020d2 <argstr>
    80005086:	87aa                	mv	a5,a0
    {
        return -1;
    80005088:	557d                	li	a0,-1
    if (argstr(0, path, MAXPATH) < 0)
    8000508a:	0c07c263          	bltz	a5,8000514e <sys_exec+0xfa>
    }
    memset(argv, 0, sizeof(argv));
    8000508e:	10000613          	li	a2,256
    80005092:	4581                	li	a1,0
    80005094:	e4040513          	addi	a0,s0,-448
    80005098:	ffffb097          	auipc	ra,0xffffb
    8000509c:	0e0080e7          	jalr	224(ra) # 80000178 <memset>
    for (i = 0;; i++)
    {
        if (i >= NELEM(argv))
    800050a0:	e4040493          	addi	s1,s0,-448
    memset(argv, 0, sizeof(argv));
    800050a4:	89a6                	mv	s3,s1
    800050a6:	4901                	li	s2,0
        if (i >= NELEM(argv))
    800050a8:	02000a13          	li	s4,32
    800050ac:	00090a9b          	sext.w	s5,s2
        {
            goto bad;
        }
        if (fetchaddr(uargv + sizeof(uint64) * i, (uint64 *)&uarg) < 0)
    800050b0:	00391513          	slli	a0,s2,0x3
    800050b4:	e3040593          	addi	a1,s0,-464
    800050b8:	e3843783          	ld	a5,-456(s0)
    800050bc:	953e                	add	a0,a0,a5
    800050be:	ffffd097          	auipc	ra,0xffffd
    800050c2:	f36080e7          	jalr	-202(ra) # 80001ff4 <fetchaddr>
    800050c6:	02054a63          	bltz	a0,800050fa <sys_exec+0xa6>
        {
            goto bad;
        }
        if (uarg == 0)
    800050ca:	e3043783          	ld	a5,-464(s0)
    800050ce:	c3b9                	beqz	a5,80005114 <sys_exec+0xc0>
        {
            argv[i] = 0;
            break;
        }
        argv[i] = kalloc();
    800050d0:	ffffb097          	auipc	ra,0xffffb
    800050d4:	048080e7          	jalr	72(ra) # 80000118 <kalloc>
    800050d8:	85aa                	mv	a1,a0
    800050da:	00a9b023          	sd	a0,0(s3)
        if (argv[i] == 0)
    800050de:	cd11                	beqz	a0,800050fa <sys_exec+0xa6>
            goto bad;
        if (fetchstr(uarg, argv[i], PGSIZE) < 0)
    800050e0:	6605                	lui	a2,0x1
    800050e2:	e3043503          	ld	a0,-464(s0)
    800050e6:	ffffd097          	auipc	ra,0xffffd
    800050ea:	f60080e7          	jalr	-160(ra) # 80002046 <fetchstr>
    800050ee:	00054663          	bltz	a0,800050fa <sys_exec+0xa6>
        if (i >= NELEM(argv))
    800050f2:	0905                	addi	s2,s2,1
    800050f4:	09a1                	addi	s3,s3,8
    800050f6:	fb491be3          	bne	s2,s4,800050ac <sys_exec+0x58>
        kfree(argv[i]);

    return ret;

bad:
    for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800050fa:	10048913          	addi	s2,s1,256
    800050fe:	6088                	ld	a0,0(s1)
    80005100:	c531                	beqz	a0,8000514c <sys_exec+0xf8>
        kfree(argv[i]);
    80005102:	ffffb097          	auipc	ra,0xffffb
    80005106:	f1a080e7          	jalr	-230(ra) # 8000001c <kfree>
    for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000510a:	04a1                	addi	s1,s1,8
    8000510c:	ff2499e3          	bne	s1,s2,800050fe <sys_exec+0xaa>
    return -1;
    80005110:	557d                	li	a0,-1
    80005112:	a835                	j	8000514e <sys_exec+0xfa>
            argv[i] = 0;
    80005114:	0a8e                	slli	s5,s5,0x3
    80005116:	fc040793          	addi	a5,s0,-64
    8000511a:	9abe                	add	s5,s5,a5
    8000511c:	e80ab023          	sd	zero,-384(s5)
    int ret = exec(path, argv);
    80005120:	e4040593          	addi	a1,s0,-448
    80005124:	f4040513          	addi	a0,s0,-192
    80005128:	fffff097          	auipc	ra,0xfffff
    8000512c:	054080e7          	jalr	84(ra) # 8000417c <exec>
    80005130:	892a                	mv	s2,a0
    for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005132:	10048993          	addi	s3,s1,256
    80005136:	6088                	ld	a0,0(s1)
    80005138:	c901                	beqz	a0,80005148 <sys_exec+0xf4>
        kfree(argv[i]);
    8000513a:	ffffb097          	auipc	ra,0xffffb
    8000513e:	ee2080e7          	jalr	-286(ra) # 8000001c <kfree>
    for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005142:	04a1                	addi	s1,s1,8
    80005144:	ff3499e3          	bne	s1,s3,80005136 <sys_exec+0xe2>
    return ret;
    80005148:	854a                	mv	a0,s2
    8000514a:	a011                	j	8000514e <sys_exec+0xfa>
    return -1;
    8000514c:	557d                	li	a0,-1
}
    8000514e:	60be                	ld	ra,456(sp)
    80005150:	641e                	ld	s0,448(sp)
    80005152:	74fa                	ld	s1,440(sp)
    80005154:	795a                	ld	s2,432(sp)
    80005156:	79ba                	ld	s3,424(sp)
    80005158:	7a1a                	ld	s4,416(sp)
    8000515a:	6afa                	ld	s5,408(sp)
    8000515c:	6179                	addi	sp,sp,464
    8000515e:	8082                	ret

0000000080005160 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005160:	7139                	addi	sp,sp,-64
    80005162:	fc06                	sd	ra,56(sp)
    80005164:	f822                	sd	s0,48(sp)
    80005166:	f426                	sd	s1,40(sp)
    80005168:	0080                	addi	s0,sp,64
    uint64 fdarray; // user pointer to array of two integers
    struct file *rf, *wf;
    int fd0, fd1;
    struct proc *p = myproc();
    8000516a:	ffffc097          	auipc	ra,0xffffc
    8000516e:	cf8080e7          	jalr	-776(ra) # 80000e62 <myproc>
    80005172:	84aa                	mv	s1,a0

    argaddr(0, &fdarray);
    80005174:	fd840593          	addi	a1,s0,-40
    80005178:	4501                	li	a0,0
    8000517a:	ffffd097          	auipc	ra,0xffffd
    8000517e:	f38080e7          	jalr	-200(ra) # 800020b2 <argaddr>
    if (pipealloc(&rf, &wf) < 0)
    80005182:	fc840593          	addi	a1,s0,-56
    80005186:	fd040513          	addi	a0,s0,-48
    8000518a:	fffff097          	auipc	ra,0xfffff
    8000518e:	c9a080e7          	jalr	-870(ra) # 80003e24 <pipealloc>
        return -1;
    80005192:	57fd                	li	a5,-1
    if (pipealloc(&rf, &wf) < 0)
    80005194:	0c054463          	bltz	a0,8000525c <sys_pipe+0xfc>
    fd0 = -1;
    80005198:	fcf42223          	sw	a5,-60(s0)
    if ((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0)
    8000519c:	fd043503          	ld	a0,-48(s0)
    800051a0:	fffff097          	auipc	ra,0xfffff
    800051a4:	3dc080e7          	jalr	988(ra) # 8000457c <fdalloc>
    800051a8:	fca42223          	sw	a0,-60(s0)
    800051ac:	08054b63          	bltz	a0,80005242 <sys_pipe+0xe2>
    800051b0:	fc843503          	ld	a0,-56(s0)
    800051b4:	fffff097          	auipc	ra,0xfffff
    800051b8:	3c8080e7          	jalr	968(ra) # 8000457c <fdalloc>
    800051bc:	fca42023          	sw	a0,-64(s0)
    800051c0:	06054863          	bltz	a0,80005230 <sys_pipe+0xd0>
            p->ofile[fd0] = 0;
        fileclose(rf);
        fileclose(wf);
        return -1;
    }
    if (copyout(p->pagetable, fdarray, (char *)&fd0, sizeof(fd0)) < 0 ||
    800051c4:	4691                	li	a3,4
    800051c6:	fc440613          	addi	a2,s0,-60
    800051ca:	fd843583          	ld	a1,-40(s0)
    800051ce:	68a8                	ld	a0,80(s1)
    800051d0:	ffffc097          	auipc	ra,0xffffc
    800051d4:	950080e7          	jalr	-1712(ra) # 80000b20 <copyout>
    800051d8:	02054063          	bltz	a0,800051f8 <sys_pipe+0x98>
        copyout(p->pagetable, fdarray + sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0)
    800051dc:	4691                	li	a3,4
    800051de:	fc040613          	addi	a2,s0,-64
    800051e2:	fd843583          	ld	a1,-40(s0)
    800051e6:	0591                	addi	a1,a1,4
    800051e8:	68a8                	ld	a0,80(s1)
    800051ea:	ffffc097          	auipc	ra,0xffffc
    800051ee:	936080e7          	jalr	-1738(ra) # 80000b20 <copyout>
        p->ofile[fd1] = 0;
        fileclose(rf);
        fileclose(wf);
        return -1;
    }
    return 0;
    800051f2:	4781                	li	a5,0
    if (copyout(p->pagetable, fdarray, (char *)&fd0, sizeof(fd0)) < 0 ||
    800051f4:	06055463          	bgez	a0,8000525c <sys_pipe+0xfc>
        p->ofile[fd0] = 0;
    800051f8:	fc442783          	lw	a5,-60(s0)
    800051fc:	07e9                	addi	a5,a5,26
    800051fe:	078e                	slli	a5,a5,0x3
    80005200:	97a6                	add	a5,a5,s1
    80005202:	0007b023          	sd	zero,0(a5)
        p->ofile[fd1] = 0;
    80005206:	fc042503          	lw	a0,-64(s0)
    8000520a:	0569                	addi	a0,a0,26
    8000520c:	050e                	slli	a0,a0,0x3
    8000520e:	94aa                	add	s1,s1,a0
    80005210:	0004b023          	sd	zero,0(s1)
        fileclose(rf);
    80005214:	fd043503          	ld	a0,-48(s0)
    80005218:	fffff097          	auipc	ra,0xfffff
    8000521c:	882080e7          	jalr	-1918(ra) # 80003a9a <fileclose>
        fileclose(wf);
    80005220:	fc843503          	ld	a0,-56(s0)
    80005224:	fffff097          	auipc	ra,0xfffff
    80005228:	876080e7          	jalr	-1930(ra) # 80003a9a <fileclose>
        return -1;
    8000522c:	57fd                	li	a5,-1
    8000522e:	a03d                	j	8000525c <sys_pipe+0xfc>
        if (fd0 >= 0)
    80005230:	fc442783          	lw	a5,-60(s0)
    80005234:	0007c763          	bltz	a5,80005242 <sys_pipe+0xe2>
            p->ofile[fd0] = 0;
    80005238:	07e9                	addi	a5,a5,26
    8000523a:	078e                	slli	a5,a5,0x3
    8000523c:	94be                	add	s1,s1,a5
    8000523e:	0004b023          	sd	zero,0(s1)
        fileclose(rf);
    80005242:	fd043503          	ld	a0,-48(s0)
    80005246:	fffff097          	auipc	ra,0xfffff
    8000524a:	854080e7          	jalr	-1964(ra) # 80003a9a <fileclose>
        fileclose(wf);
    8000524e:	fc843503          	ld	a0,-56(s0)
    80005252:	fffff097          	auipc	ra,0xfffff
    80005256:	848080e7          	jalr	-1976(ra) # 80003a9a <fileclose>
        return -1;
    8000525a:	57fd                	li	a5,-1
}
    8000525c:	853e                	mv	a0,a5
    8000525e:	70e2                	ld	ra,56(sp)
    80005260:	7442                	ld	s0,48(sp)
    80005262:	74a2                	ld	s1,40(sp)
    80005264:	6121                	addi	sp,sp,64
    80005266:	8082                	ret
	...

0000000080005270 <kernelvec>:
    80005270:	7111                	addi	sp,sp,-256
    80005272:	e006                	sd	ra,0(sp)
    80005274:	e40a                	sd	sp,8(sp)
    80005276:	e80e                	sd	gp,16(sp)
    80005278:	ec12                	sd	tp,24(sp)
    8000527a:	f016                	sd	t0,32(sp)
    8000527c:	f41a                	sd	t1,40(sp)
    8000527e:	f81e                	sd	t2,48(sp)
    80005280:	fc22                	sd	s0,56(sp)
    80005282:	e0a6                	sd	s1,64(sp)
    80005284:	e4aa                	sd	a0,72(sp)
    80005286:	e8ae                	sd	a1,80(sp)
    80005288:	ecb2                	sd	a2,88(sp)
    8000528a:	f0b6                	sd	a3,96(sp)
    8000528c:	f4ba                	sd	a4,104(sp)
    8000528e:	f8be                	sd	a5,112(sp)
    80005290:	fcc2                	sd	a6,120(sp)
    80005292:	e146                	sd	a7,128(sp)
    80005294:	e54a                	sd	s2,136(sp)
    80005296:	e94e                	sd	s3,144(sp)
    80005298:	ed52                	sd	s4,152(sp)
    8000529a:	f156                	sd	s5,160(sp)
    8000529c:	f55a                	sd	s6,168(sp)
    8000529e:	f95e                	sd	s7,176(sp)
    800052a0:	fd62                	sd	s8,184(sp)
    800052a2:	e1e6                	sd	s9,192(sp)
    800052a4:	e5ea                	sd	s10,200(sp)
    800052a6:	e9ee                	sd	s11,208(sp)
    800052a8:	edf2                	sd	t3,216(sp)
    800052aa:	f1f6                	sd	t4,224(sp)
    800052ac:	f5fa                	sd	t5,232(sp)
    800052ae:	f9fe                	sd	t6,240(sp)
    800052b0:	c11fc0ef          	jal	ra,80001ec0 <kerneltrap>
    800052b4:	6082                	ld	ra,0(sp)
    800052b6:	6122                	ld	sp,8(sp)
    800052b8:	61c2                	ld	gp,16(sp)
    800052ba:	7282                	ld	t0,32(sp)
    800052bc:	7322                	ld	t1,40(sp)
    800052be:	73c2                	ld	t2,48(sp)
    800052c0:	7462                	ld	s0,56(sp)
    800052c2:	6486                	ld	s1,64(sp)
    800052c4:	6526                	ld	a0,72(sp)
    800052c6:	65c6                	ld	a1,80(sp)
    800052c8:	6666                	ld	a2,88(sp)
    800052ca:	7686                	ld	a3,96(sp)
    800052cc:	7726                	ld	a4,104(sp)
    800052ce:	77c6                	ld	a5,112(sp)
    800052d0:	7866                	ld	a6,120(sp)
    800052d2:	688a                	ld	a7,128(sp)
    800052d4:	692a                	ld	s2,136(sp)
    800052d6:	69ca                	ld	s3,144(sp)
    800052d8:	6a6a                	ld	s4,152(sp)
    800052da:	7a8a                	ld	s5,160(sp)
    800052dc:	7b2a                	ld	s6,168(sp)
    800052de:	7bca                	ld	s7,176(sp)
    800052e0:	7c6a                	ld	s8,184(sp)
    800052e2:	6c8e                	ld	s9,192(sp)
    800052e4:	6d2e                	ld	s10,200(sp)
    800052e6:	6dce                	ld	s11,208(sp)
    800052e8:	6e6e                	ld	t3,216(sp)
    800052ea:	7e8e                	ld	t4,224(sp)
    800052ec:	7f2e                	ld	t5,232(sp)
    800052ee:	7fce                	ld	t6,240(sp)
    800052f0:	6111                	addi	sp,sp,256
    800052f2:	10200073          	sret
    800052f6:	00000013          	nop
    800052fa:	00000013          	nop
    800052fe:	0001                	nop

0000000080005300 <timervec>:
    80005300:	34051573          	csrrw	a0,mscratch,a0
    80005304:	e10c                	sd	a1,0(a0)
    80005306:	e510                	sd	a2,8(a0)
    80005308:	e914                	sd	a3,16(a0)
    8000530a:	6d0c                	ld	a1,24(a0)
    8000530c:	7110                	ld	a2,32(a0)
    8000530e:	6194                	ld	a3,0(a1)
    80005310:	96b2                	add	a3,a3,a2
    80005312:	e194                	sd	a3,0(a1)
    80005314:	4589                	li	a1,2
    80005316:	14459073          	csrw	sip,a1
    8000531a:	6914                	ld	a3,16(a0)
    8000531c:	6510                	ld	a2,8(a0)
    8000531e:	610c                	ld	a1,0(a0)
    80005320:	34051573          	csrrw	a0,mscratch,a0
    80005324:	30200073          	mret
	...

000000008000532a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000532a:	1141                	addi	sp,sp,-16
    8000532c:	e422                	sd	s0,8(sp)
    8000532e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005330:	0c0007b7          	lui	a5,0xc000
    80005334:	4705                	li	a4,1
    80005336:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005338:	c3d8                	sw	a4,4(a5)
}
    8000533a:	6422                	ld	s0,8(sp)
    8000533c:	0141                	addi	sp,sp,16
    8000533e:	8082                	ret

0000000080005340 <plicinithart>:

void
plicinithart(void)
{
    80005340:	1141                	addi	sp,sp,-16
    80005342:	e406                	sd	ra,8(sp)
    80005344:	e022                	sd	s0,0(sp)
    80005346:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005348:	ffffc097          	auipc	ra,0xffffc
    8000534c:	aee080e7          	jalr	-1298(ra) # 80000e36 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005350:	0085171b          	slliw	a4,a0,0x8
    80005354:	0c0027b7          	lui	a5,0xc002
    80005358:	97ba                	add	a5,a5,a4
    8000535a:	40200713          	li	a4,1026
    8000535e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005362:	00d5151b          	slliw	a0,a0,0xd
    80005366:	0c2017b7          	lui	a5,0xc201
    8000536a:	953e                	add	a0,a0,a5
    8000536c:	00052023          	sw	zero,0(a0)
}
    80005370:	60a2                	ld	ra,8(sp)
    80005372:	6402                	ld	s0,0(sp)
    80005374:	0141                	addi	sp,sp,16
    80005376:	8082                	ret

0000000080005378 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005378:	1141                	addi	sp,sp,-16
    8000537a:	e406                	sd	ra,8(sp)
    8000537c:	e022                	sd	s0,0(sp)
    8000537e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005380:	ffffc097          	auipc	ra,0xffffc
    80005384:	ab6080e7          	jalr	-1354(ra) # 80000e36 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005388:	00d5179b          	slliw	a5,a0,0xd
    8000538c:	0c201537          	lui	a0,0xc201
    80005390:	953e                	add	a0,a0,a5
  return irq;
}
    80005392:	4148                	lw	a0,4(a0)
    80005394:	60a2                	ld	ra,8(sp)
    80005396:	6402                	ld	s0,0(sp)
    80005398:	0141                	addi	sp,sp,16
    8000539a:	8082                	ret

000000008000539c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000539c:	1101                	addi	sp,sp,-32
    8000539e:	ec06                	sd	ra,24(sp)
    800053a0:	e822                	sd	s0,16(sp)
    800053a2:	e426                	sd	s1,8(sp)
    800053a4:	1000                	addi	s0,sp,32
    800053a6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800053a8:	ffffc097          	auipc	ra,0xffffc
    800053ac:	a8e080e7          	jalr	-1394(ra) # 80000e36 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800053b0:	00d5151b          	slliw	a0,a0,0xd
    800053b4:	0c2017b7          	lui	a5,0xc201
    800053b8:	97aa                	add	a5,a5,a0
    800053ba:	c3c4                	sw	s1,4(a5)
}
    800053bc:	60e2                	ld	ra,24(sp)
    800053be:	6442                	ld	s0,16(sp)
    800053c0:	64a2                	ld	s1,8(sp)
    800053c2:	6105                	addi	sp,sp,32
    800053c4:	8082                	ret

00000000800053c6 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800053c6:	1141                	addi	sp,sp,-16
    800053c8:	e406                	sd	ra,8(sp)
    800053ca:	e022                	sd	s0,0(sp)
    800053cc:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800053ce:	479d                	li	a5,7
    800053d0:	04a7cc63          	blt	a5,a0,80005428 <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    800053d4:	00022797          	auipc	a5,0x22
    800053d8:	68c78793          	addi	a5,a5,1676 # 80027a60 <disk>
    800053dc:	97aa                	add	a5,a5,a0
    800053de:	0187c783          	lbu	a5,24(a5)
    800053e2:	ebb9                	bnez	a5,80005438 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800053e4:	00451613          	slli	a2,a0,0x4
    800053e8:	00022797          	auipc	a5,0x22
    800053ec:	67878793          	addi	a5,a5,1656 # 80027a60 <disk>
    800053f0:	6394                	ld	a3,0(a5)
    800053f2:	96b2                	add	a3,a3,a2
    800053f4:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    800053f8:	6398                	ld	a4,0(a5)
    800053fa:	9732                	add	a4,a4,a2
    800053fc:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80005400:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005404:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005408:	953e                	add	a0,a0,a5
    8000540a:	4785                	li	a5,1
    8000540c:	00f50c23          	sb	a5,24(a0) # c201018 <_entry-0x73dfefe8>
  wakeup(&disk.free[0]);
    80005410:	00022517          	auipc	a0,0x22
    80005414:	66850513          	addi	a0,a0,1640 # 80027a78 <disk+0x18>
    80005418:	ffffc097          	auipc	ra,0xffffc
    8000541c:	152080e7          	jalr	338(ra) # 8000156a <wakeup>
}
    80005420:	60a2                	ld	ra,8(sp)
    80005422:	6402                	ld	s0,0(sp)
    80005424:	0141                	addi	sp,sp,16
    80005426:	8082                	ret
    panic("free_desc 1");
    80005428:	00003517          	auipc	a0,0x3
    8000542c:	32050513          	addi	a0,a0,800 # 80008748 <syscalls+0x318>
    80005430:	00001097          	auipc	ra,0x1
    80005434:	a72080e7          	jalr	-1422(ra) # 80005ea2 <panic>
    panic("free_desc 2");
    80005438:	00003517          	auipc	a0,0x3
    8000543c:	32050513          	addi	a0,a0,800 # 80008758 <syscalls+0x328>
    80005440:	00001097          	auipc	ra,0x1
    80005444:	a62080e7          	jalr	-1438(ra) # 80005ea2 <panic>

0000000080005448 <virtio_disk_init>:
{
    80005448:	1101                	addi	sp,sp,-32
    8000544a:	ec06                	sd	ra,24(sp)
    8000544c:	e822                	sd	s0,16(sp)
    8000544e:	e426                	sd	s1,8(sp)
    80005450:	e04a                	sd	s2,0(sp)
    80005452:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005454:	00003597          	auipc	a1,0x3
    80005458:	31458593          	addi	a1,a1,788 # 80008768 <syscalls+0x338>
    8000545c:	00022517          	auipc	a0,0x22
    80005460:	72c50513          	addi	a0,a0,1836 # 80027b88 <disk+0x128>
    80005464:	00001097          	auipc	ra,0x1
    80005468:	ef8080e7          	jalr	-264(ra) # 8000635c <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000546c:	100017b7          	lui	a5,0x10001
    80005470:	4398                	lw	a4,0(a5)
    80005472:	2701                	sext.w	a4,a4
    80005474:	747277b7          	lui	a5,0x74727
    80005478:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    8000547c:	14f71e63          	bne	a4,a5,800055d8 <virtio_disk_init+0x190>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005480:	100017b7          	lui	a5,0x10001
    80005484:	43dc                	lw	a5,4(a5)
    80005486:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005488:	4709                	li	a4,2
    8000548a:	14e79763          	bne	a5,a4,800055d8 <virtio_disk_init+0x190>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000548e:	100017b7          	lui	a5,0x10001
    80005492:	479c                	lw	a5,8(a5)
    80005494:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005496:	14e79163          	bne	a5,a4,800055d8 <virtio_disk_init+0x190>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    8000549a:	100017b7          	lui	a5,0x10001
    8000549e:	47d8                	lw	a4,12(a5)
    800054a0:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800054a2:	554d47b7          	lui	a5,0x554d4
    800054a6:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800054aa:	12f71763          	bne	a4,a5,800055d8 <virtio_disk_init+0x190>
  *R(VIRTIO_MMIO_STATUS) = status;
    800054ae:	100017b7          	lui	a5,0x10001
    800054b2:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    800054b6:	4705                	li	a4,1
    800054b8:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800054ba:	470d                	li	a4,3
    800054bc:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800054be:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800054c0:	c7ffe737          	lui	a4,0xc7ffe
    800054c4:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fce97f>
    800054c8:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800054ca:	2701                	sext.w	a4,a4
    800054cc:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800054ce:	472d                	li	a4,11
    800054d0:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    800054d2:	0707a903          	lw	s2,112(a5)
    800054d6:	2901                	sext.w	s2,s2
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    800054d8:	00897793          	andi	a5,s2,8
    800054dc:	10078663          	beqz	a5,800055e8 <virtio_disk_init+0x1a0>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800054e0:	100017b7          	lui	a5,0x10001
    800054e4:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    800054e8:	43fc                	lw	a5,68(a5)
    800054ea:	2781                	sext.w	a5,a5
    800054ec:	10079663          	bnez	a5,800055f8 <virtio_disk_init+0x1b0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800054f0:	100017b7          	lui	a5,0x10001
    800054f4:	5bdc                	lw	a5,52(a5)
    800054f6:	2781                	sext.w	a5,a5
  if(max == 0)
    800054f8:	10078863          	beqz	a5,80005608 <virtio_disk_init+0x1c0>
  if(max < NUM)
    800054fc:	471d                	li	a4,7
    800054fe:	10f77d63          	bgeu	a4,a5,80005618 <virtio_disk_init+0x1d0>
  disk.desc = kalloc();
    80005502:	ffffb097          	auipc	ra,0xffffb
    80005506:	c16080e7          	jalr	-1002(ra) # 80000118 <kalloc>
    8000550a:	00022497          	auipc	s1,0x22
    8000550e:	55648493          	addi	s1,s1,1366 # 80027a60 <disk>
    80005512:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005514:	ffffb097          	auipc	ra,0xffffb
    80005518:	c04080e7          	jalr	-1020(ra) # 80000118 <kalloc>
    8000551c:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000551e:	ffffb097          	auipc	ra,0xffffb
    80005522:	bfa080e7          	jalr	-1030(ra) # 80000118 <kalloc>
    80005526:	87aa                	mv	a5,a0
    80005528:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    8000552a:	6088                	ld	a0,0(s1)
    8000552c:	cd75                	beqz	a0,80005628 <virtio_disk_init+0x1e0>
    8000552e:	00022717          	auipc	a4,0x22
    80005532:	53a73703          	ld	a4,1338(a4) # 80027a68 <disk+0x8>
    80005536:	cb6d                	beqz	a4,80005628 <virtio_disk_init+0x1e0>
    80005538:	cbe5                	beqz	a5,80005628 <virtio_disk_init+0x1e0>
  memset(disk.desc, 0, PGSIZE);
    8000553a:	6605                	lui	a2,0x1
    8000553c:	4581                	li	a1,0
    8000553e:	ffffb097          	auipc	ra,0xffffb
    80005542:	c3a080e7          	jalr	-966(ra) # 80000178 <memset>
  memset(disk.avail, 0, PGSIZE);
    80005546:	00022497          	auipc	s1,0x22
    8000554a:	51a48493          	addi	s1,s1,1306 # 80027a60 <disk>
    8000554e:	6605                	lui	a2,0x1
    80005550:	4581                	li	a1,0
    80005552:	6488                	ld	a0,8(s1)
    80005554:	ffffb097          	auipc	ra,0xffffb
    80005558:	c24080e7          	jalr	-988(ra) # 80000178 <memset>
  memset(disk.used, 0, PGSIZE);
    8000555c:	6605                	lui	a2,0x1
    8000555e:	4581                	li	a1,0
    80005560:	6888                	ld	a0,16(s1)
    80005562:	ffffb097          	auipc	ra,0xffffb
    80005566:	c16080e7          	jalr	-1002(ra) # 80000178 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    8000556a:	100017b7          	lui	a5,0x10001
    8000556e:	4721                	li	a4,8
    80005570:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80005572:	4098                	lw	a4,0(s1)
    80005574:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80005578:	40d8                	lw	a4,4(s1)
    8000557a:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    8000557e:	6498                	ld	a4,8(s1)
    80005580:	0007069b          	sext.w	a3,a4
    80005584:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80005588:	9701                	srai	a4,a4,0x20
    8000558a:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    8000558e:	6898                	ld	a4,16(s1)
    80005590:	0007069b          	sext.w	a3,a4
    80005594:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80005598:	9701                	srai	a4,a4,0x20
    8000559a:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    8000559e:	4685                	li	a3,1
    800055a0:	c3f4                	sw	a3,68(a5)
    disk.free[i] = 1;
    800055a2:	4705                	li	a4,1
    800055a4:	00d48c23          	sb	a3,24(s1)
    800055a8:	00e48ca3          	sb	a4,25(s1)
    800055ac:	00e48d23          	sb	a4,26(s1)
    800055b0:	00e48da3          	sb	a4,27(s1)
    800055b4:	00e48e23          	sb	a4,28(s1)
    800055b8:	00e48ea3          	sb	a4,29(s1)
    800055bc:	00e48f23          	sb	a4,30(s1)
    800055c0:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    800055c4:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    800055c8:	0727a823          	sw	s2,112(a5)
}
    800055cc:	60e2                	ld	ra,24(sp)
    800055ce:	6442                	ld	s0,16(sp)
    800055d0:	64a2                	ld	s1,8(sp)
    800055d2:	6902                	ld	s2,0(sp)
    800055d4:	6105                	addi	sp,sp,32
    800055d6:	8082                	ret
    panic("could not find virtio disk");
    800055d8:	00003517          	auipc	a0,0x3
    800055dc:	1a050513          	addi	a0,a0,416 # 80008778 <syscalls+0x348>
    800055e0:	00001097          	auipc	ra,0x1
    800055e4:	8c2080e7          	jalr	-1854(ra) # 80005ea2 <panic>
    panic("virtio disk FEATURES_OK unset");
    800055e8:	00003517          	auipc	a0,0x3
    800055ec:	1b050513          	addi	a0,a0,432 # 80008798 <syscalls+0x368>
    800055f0:	00001097          	auipc	ra,0x1
    800055f4:	8b2080e7          	jalr	-1870(ra) # 80005ea2 <panic>
    panic("virtio disk should not be ready");
    800055f8:	00003517          	auipc	a0,0x3
    800055fc:	1c050513          	addi	a0,a0,448 # 800087b8 <syscalls+0x388>
    80005600:	00001097          	auipc	ra,0x1
    80005604:	8a2080e7          	jalr	-1886(ra) # 80005ea2 <panic>
    panic("virtio disk has no queue 0");
    80005608:	00003517          	auipc	a0,0x3
    8000560c:	1d050513          	addi	a0,a0,464 # 800087d8 <syscalls+0x3a8>
    80005610:	00001097          	auipc	ra,0x1
    80005614:	892080e7          	jalr	-1902(ra) # 80005ea2 <panic>
    panic("virtio disk max queue too short");
    80005618:	00003517          	auipc	a0,0x3
    8000561c:	1e050513          	addi	a0,a0,480 # 800087f8 <syscalls+0x3c8>
    80005620:	00001097          	auipc	ra,0x1
    80005624:	882080e7          	jalr	-1918(ra) # 80005ea2 <panic>
    panic("virtio disk kalloc");
    80005628:	00003517          	auipc	a0,0x3
    8000562c:	1f050513          	addi	a0,a0,496 # 80008818 <syscalls+0x3e8>
    80005630:	00001097          	auipc	ra,0x1
    80005634:	872080e7          	jalr	-1934(ra) # 80005ea2 <panic>

0000000080005638 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005638:	7159                	addi	sp,sp,-112
    8000563a:	f486                	sd	ra,104(sp)
    8000563c:	f0a2                	sd	s0,96(sp)
    8000563e:	eca6                	sd	s1,88(sp)
    80005640:	e8ca                	sd	s2,80(sp)
    80005642:	e4ce                	sd	s3,72(sp)
    80005644:	e0d2                	sd	s4,64(sp)
    80005646:	fc56                	sd	s5,56(sp)
    80005648:	f85a                	sd	s6,48(sp)
    8000564a:	f45e                	sd	s7,40(sp)
    8000564c:	f062                	sd	s8,32(sp)
    8000564e:	ec66                	sd	s9,24(sp)
    80005650:	e86a                	sd	s10,16(sp)
    80005652:	1880                	addi	s0,sp,112
    80005654:	892a                	mv	s2,a0
    80005656:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005658:	00c52c83          	lw	s9,12(a0)
    8000565c:	001c9c9b          	slliw	s9,s9,0x1
    80005660:	1c82                	slli	s9,s9,0x20
    80005662:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005666:	00022517          	auipc	a0,0x22
    8000566a:	52250513          	addi	a0,a0,1314 # 80027b88 <disk+0x128>
    8000566e:	00001097          	auipc	ra,0x1
    80005672:	d7e080e7          	jalr	-642(ra) # 800063ec <acquire>
  for(int i = 0; i < 3; i++){
    80005676:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005678:	4ba1                	li	s7,8
      disk.free[i] = 0;
    8000567a:	00022b17          	auipc	s6,0x22
    8000567e:	3e6b0b13          	addi	s6,s6,998 # 80027a60 <disk>
  for(int i = 0; i < 3; i++){
    80005682:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    80005684:	8a4e                	mv	s4,s3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005686:	00022c17          	auipc	s8,0x22
    8000568a:	502c0c13          	addi	s8,s8,1282 # 80027b88 <disk+0x128>
    8000568e:	a8b5                	j	8000570a <virtio_disk_rw+0xd2>
      disk.free[i] = 0;
    80005690:	00fb06b3          	add	a3,s6,a5
    80005694:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    80005698:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    8000569a:	0207c563          	bltz	a5,800056c4 <virtio_disk_rw+0x8c>
  for(int i = 0; i < 3; i++){
    8000569e:	2485                	addiw	s1,s1,1
    800056a0:	0711                	addi	a4,a4,4
    800056a2:	1f548a63          	beq	s1,s5,80005896 <virtio_disk_rw+0x25e>
    idx[i] = alloc_desc();
    800056a6:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    800056a8:	00022697          	auipc	a3,0x22
    800056ac:	3b868693          	addi	a3,a3,952 # 80027a60 <disk>
    800056b0:	87d2                	mv	a5,s4
    if(disk.free[i]){
    800056b2:	0186c583          	lbu	a1,24(a3)
    800056b6:	fde9                	bnez	a1,80005690 <virtio_disk_rw+0x58>
  for(int i = 0; i < NUM; i++){
    800056b8:	2785                	addiw	a5,a5,1
    800056ba:	0685                	addi	a3,a3,1
    800056bc:	ff779be3          	bne	a5,s7,800056b2 <virtio_disk_rw+0x7a>
    idx[i] = alloc_desc();
    800056c0:	57fd                	li	a5,-1
    800056c2:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    800056c4:	02905a63          	blez	s1,800056f8 <virtio_disk_rw+0xc0>
        free_desc(idx[j]);
    800056c8:	f9042503          	lw	a0,-112(s0)
    800056cc:	00000097          	auipc	ra,0x0
    800056d0:	cfa080e7          	jalr	-774(ra) # 800053c6 <free_desc>
      for(int j = 0; j < i; j++)
    800056d4:	4785                	li	a5,1
    800056d6:	0297d163          	bge	a5,s1,800056f8 <virtio_disk_rw+0xc0>
        free_desc(idx[j]);
    800056da:	f9442503          	lw	a0,-108(s0)
    800056de:	00000097          	auipc	ra,0x0
    800056e2:	ce8080e7          	jalr	-792(ra) # 800053c6 <free_desc>
      for(int j = 0; j < i; j++)
    800056e6:	4789                	li	a5,2
    800056e8:	0097d863          	bge	a5,s1,800056f8 <virtio_disk_rw+0xc0>
        free_desc(idx[j]);
    800056ec:	f9842503          	lw	a0,-104(s0)
    800056f0:	00000097          	auipc	ra,0x0
    800056f4:	cd6080e7          	jalr	-810(ra) # 800053c6 <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    800056f8:	85e2                	mv	a1,s8
    800056fa:	00022517          	auipc	a0,0x22
    800056fe:	37e50513          	addi	a0,a0,894 # 80027a78 <disk+0x18>
    80005702:	ffffc097          	auipc	ra,0xffffc
    80005706:	e04080e7          	jalr	-508(ra) # 80001506 <sleep>
  for(int i = 0; i < 3; i++){
    8000570a:	f9040713          	addi	a4,s0,-112
    8000570e:	84ce                	mv	s1,s3
    80005710:	bf59                	j	800056a6 <virtio_disk_rw+0x6e>
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

  if(write)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    80005712:	00a60793          	addi	a5,a2,10 # 100a <_entry-0x7fffeff6>
    80005716:	00479693          	slli	a3,a5,0x4
    8000571a:	00022797          	auipc	a5,0x22
    8000571e:	34678793          	addi	a5,a5,838 # 80027a60 <disk>
    80005722:	97b6                	add	a5,a5,a3
    80005724:	4685                	li	a3,1
    80005726:	c794                	sw	a3,8(a5)
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80005728:	00022597          	auipc	a1,0x22
    8000572c:	33858593          	addi	a1,a1,824 # 80027a60 <disk>
    80005730:	00a60793          	addi	a5,a2,10
    80005734:	0792                	slli	a5,a5,0x4
    80005736:	97ae                	add	a5,a5,a1
    80005738:	0007a623          	sw	zero,12(a5)
  buf0->sector = sector;
    8000573c:	0197b823          	sd	s9,16(a5)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005740:	f6070693          	addi	a3,a4,-160
    80005744:	619c                	ld	a5,0(a1)
    80005746:	97b6                	add	a5,a5,a3
    80005748:	e388                	sd	a0,0(a5)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    8000574a:	6188                	ld	a0,0(a1)
    8000574c:	96aa                	add	a3,a3,a0
    8000574e:	47c1                	li	a5,16
    80005750:	c69c                	sw	a5,8(a3)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005752:	4785                	li	a5,1
    80005754:	00f69623          	sh	a5,12(a3)
  disk.desc[idx[0]].next = idx[1];
    80005758:	f9442783          	lw	a5,-108(s0)
    8000575c:	00f69723          	sh	a5,14(a3)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005760:	0792                	slli	a5,a5,0x4
    80005762:	953e                	add	a0,a0,a5
    80005764:	05890693          	addi	a3,s2,88
    80005768:	e114                	sd	a3,0(a0)
  disk.desc[idx[1]].len = BSIZE;
    8000576a:	6188                	ld	a0,0(a1)
    8000576c:	97aa                	add	a5,a5,a0
    8000576e:	40000693          	li	a3,1024
    80005772:	c794                	sw	a3,8(a5)
  if(write)
    80005774:	100d0d63          	beqz	s10,8000588e <virtio_disk_rw+0x256>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    80005778:	00079623          	sh	zero,12(a5)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000577c:	00c7d683          	lhu	a3,12(a5)
    80005780:	0016e693          	ori	a3,a3,1
    80005784:	00d79623          	sh	a3,12(a5)
  disk.desc[idx[1]].next = idx[2];
    80005788:	f9842583          	lw	a1,-104(s0)
    8000578c:	00b79723          	sh	a1,14(a5)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005790:	00022697          	auipc	a3,0x22
    80005794:	2d068693          	addi	a3,a3,720 # 80027a60 <disk>
    80005798:	00260793          	addi	a5,a2,2
    8000579c:	0792                	slli	a5,a5,0x4
    8000579e:	97b6                	add	a5,a5,a3
    800057a0:	587d                	li	a6,-1
    800057a2:	01078823          	sb	a6,16(a5)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800057a6:	0592                	slli	a1,a1,0x4
    800057a8:	952e                	add	a0,a0,a1
    800057aa:	f9070713          	addi	a4,a4,-112
    800057ae:	9736                	add	a4,a4,a3
    800057b0:	e118                	sd	a4,0(a0)
  disk.desc[idx[2]].len = 1;
    800057b2:	6298                	ld	a4,0(a3)
    800057b4:	972e                	add	a4,a4,a1
    800057b6:	4585                	li	a1,1
    800057b8:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800057ba:	4509                	li	a0,2
    800057bc:	00a71623          	sh	a0,12(a4)
  disk.desc[idx[2]].next = 0;
    800057c0:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800057c4:	00b92223          	sw	a1,4(s2)
  disk.info[idx[0]].b = b;
    800057c8:	0127b423          	sd	s2,8(a5)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800057cc:	6698                	ld	a4,8(a3)
    800057ce:	00275783          	lhu	a5,2(a4)
    800057d2:	8b9d                	andi	a5,a5,7
    800057d4:	0786                	slli	a5,a5,0x1
    800057d6:	97ba                	add	a5,a5,a4
    800057d8:	00c79223          	sh	a2,4(a5)

  __sync_synchronize();
    800057dc:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800057e0:	6698                	ld	a4,8(a3)
    800057e2:	00275783          	lhu	a5,2(a4)
    800057e6:	2785                	addiw	a5,a5,1
    800057e8:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800057ec:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800057f0:	100017b7          	lui	a5,0x10001
    800057f4:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800057f8:	00492703          	lw	a4,4(s2)
    800057fc:	4785                	li	a5,1
    800057fe:	02f71163          	bne	a4,a5,80005820 <virtio_disk_rw+0x1e8>
    sleep(b, &disk.vdisk_lock);
    80005802:	00022997          	auipc	s3,0x22
    80005806:	38698993          	addi	s3,s3,902 # 80027b88 <disk+0x128>
  while(b->disk == 1) {
    8000580a:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    8000580c:	85ce                	mv	a1,s3
    8000580e:	854a                	mv	a0,s2
    80005810:	ffffc097          	auipc	ra,0xffffc
    80005814:	cf6080e7          	jalr	-778(ra) # 80001506 <sleep>
  while(b->disk == 1) {
    80005818:	00492783          	lw	a5,4(s2)
    8000581c:	fe9788e3          	beq	a5,s1,8000580c <virtio_disk_rw+0x1d4>
  }

  disk.info[idx[0]].b = 0;
    80005820:	f9042903          	lw	s2,-112(s0)
    80005824:	00290793          	addi	a5,s2,2
    80005828:	00479713          	slli	a4,a5,0x4
    8000582c:	00022797          	auipc	a5,0x22
    80005830:	23478793          	addi	a5,a5,564 # 80027a60 <disk>
    80005834:	97ba                	add	a5,a5,a4
    80005836:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    8000583a:	00022997          	auipc	s3,0x22
    8000583e:	22698993          	addi	s3,s3,550 # 80027a60 <disk>
    80005842:	00491713          	slli	a4,s2,0x4
    80005846:	0009b783          	ld	a5,0(s3)
    8000584a:	97ba                	add	a5,a5,a4
    8000584c:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005850:	854a                	mv	a0,s2
    80005852:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005856:	00000097          	auipc	ra,0x0
    8000585a:	b70080e7          	jalr	-1168(ra) # 800053c6 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    8000585e:	8885                	andi	s1,s1,1
    80005860:	f0ed                	bnez	s1,80005842 <virtio_disk_rw+0x20a>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005862:	00022517          	auipc	a0,0x22
    80005866:	32650513          	addi	a0,a0,806 # 80027b88 <disk+0x128>
    8000586a:	00001097          	auipc	ra,0x1
    8000586e:	c36080e7          	jalr	-970(ra) # 800064a0 <release>
}
    80005872:	70a6                	ld	ra,104(sp)
    80005874:	7406                	ld	s0,96(sp)
    80005876:	64e6                	ld	s1,88(sp)
    80005878:	6946                	ld	s2,80(sp)
    8000587a:	69a6                	ld	s3,72(sp)
    8000587c:	6a06                	ld	s4,64(sp)
    8000587e:	7ae2                	ld	s5,56(sp)
    80005880:	7b42                	ld	s6,48(sp)
    80005882:	7ba2                	ld	s7,40(sp)
    80005884:	7c02                	ld	s8,32(sp)
    80005886:	6ce2                	ld	s9,24(sp)
    80005888:	6d42                	ld	s10,16(sp)
    8000588a:	6165                	addi	sp,sp,112
    8000588c:	8082                	ret
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    8000588e:	4689                	li	a3,2
    80005890:	00d79623          	sh	a3,12(a5)
    80005894:	b5e5                	j	8000577c <virtio_disk_rw+0x144>
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005896:	f9042603          	lw	a2,-112(s0)
    8000589a:	00a60713          	addi	a4,a2,10
    8000589e:	0712                	slli	a4,a4,0x4
    800058a0:	00022517          	auipc	a0,0x22
    800058a4:	1c850513          	addi	a0,a0,456 # 80027a68 <disk+0x8>
    800058a8:	953a                	add	a0,a0,a4
  if(write)
    800058aa:	e60d14e3          	bnez	s10,80005712 <virtio_disk_rw+0xda>
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    800058ae:	00a60793          	addi	a5,a2,10
    800058b2:	00479693          	slli	a3,a5,0x4
    800058b6:	00022797          	auipc	a5,0x22
    800058ba:	1aa78793          	addi	a5,a5,426 # 80027a60 <disk>
    800058be:	97b6                	add	a5,a5,a3
    800058c0:	0007a423          	sw	zero,8(a5)
    800058c4:	b595                	j	80005728 <virtio_disk_rw+0xf0>

00000000800058c6 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800058c6:	1101                	addi	sp,sp,-32
    800058c8:	ec06                	sd	ra,24(sp)
    800058ca:	e822                	sd	s0,16(sp)
    800058cc:	e426                	sd	s1,8(sp)
    800058ce:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800058d0:	00022497          	auipc	s1,0x22
    800058d4:	19048493          	addi	s1,s1,400 # 80027a60 <disk>
    800058d8:	00022517          	auipc	a0,0x22
    800058dc:	2b050513          	addi	a0,a0,688 # 80027b88 <disk+0x128>
    800058e0:	00001097          	auipc	ra,0x1
    800058e4:	b0c080e7          	jalr	-1268(ra) # 800063ec <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800058e8:	10001737          	lui	a4,0x10001
    800058ec:	533c                	lw	a5,96(a4)
    800058ee:	8b8d                	andi	a5,a5,3
    800058f0:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    800058f2:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800058f6:	689c                	ld	a5,16(s1)
    800058f8:	0204d703          	lhu	a4,32(s1)
    800058fc:	0027d783          	lhu	a5,2(a5)
    80005900:	04f70863          	beq	a4,a5,80005950 <virtio_disk_intr+0x8a>
    __sync_synchronize();
    80005904:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005908:	6898                	ld	a4,16(s1)
    8000590a:	0204d783          	lhu	a5,32(s1)
    8000590e:	8b9d                	andi	a5,a5,7
    80005910:	078e                	slli	a5,a5,0x3
    80005912:	97ba                	add	a5,a5,a4
    80005914:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005916:	00278713          	addi	a4,a5,2
    8000591a:	0712                	slli	a4,a4,0x4
    8000591c:	9726                	add	a4,a4,s1
    8000591e:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    80005922:	e721                	bnez	a4,8000596a <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005924:	0789                	addi	a5,a5,2
    80005926:	0792                	slli	a5,a5,0x4
    80005928:	97a6                	add	a5,a5,s1
    8000592a:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    8000592c:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005930:	ffffc097          	auipc	ra,0xffffc
    80005934:	c3a080e7          	jalr	-966(ra) # 8000156a <wakeup>

    disk.used_idx += 1;
    80005938:	0204d783          	lhu	a5,32(s1)
    8000593c:	2785                	addiw	a5,a5,1
    8000593e:	17c2                	slli	a5,a5,0x30
    80005940:	93c1                	srli	a5,a5,0x30
    80005942:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005946:	6898                	ld	a4,16(s1)
    80005948:	00275703          	lhu	a4,2(a4)
    8000594c:	faf71ce3          	bne	a4,a5,80005904 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80005950:	00022517          	auipc	a0,0x22
    80005954:	23850513          	addi	a0,a0,568 # 80027b88 <disk+0x128>
    80005958:	00001097          	auipc	ra,0x1
    8000595c:	b48080e7          	jalr	-1208(ra) # 800064a0 <release>
}
    80005960:	60e2                	ld	ra,24(sp)
    80005962:	6442                	ld	s0,16(sp)
    80005964:	64a2                	ld	s1,8(sp)
    80005966:	6105                	addi	sp,sp,32
    80005968:	8082                	ret
      panic("virtio_disk_intr status");
    8000596a:	00003517          	auipc	a0,0x3
    8000596e:	ec650513          	addi	a0,a0,-314 # 80008830 <syscalls+0x400>
    80005972:	00000097          	auipc	ra,0x0
    80005976:	530080e7          	jalr	1328(ra) # 80005ea2 <panic>

000000008000597a <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    8000597a:	1141                	addi	sp,sp,-16
    8000597c:	e422                	sd	s0,8(sp)
    8000597e:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005980:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005984:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005988:	0037979b          	slliw	a5,a5,0x3
    8000598c:	02004737          	lui	a4,0x2004
    80005990:	97ba                	add	a5,a5,a4
    80005992:	0200c737          	lui	a4,0x200c
    80005996:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    8000599a:	000f4637          	lui	a2,0xf4
    8000599e:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    800059a2:	95b2                	add	a1,a1,a2
    800059a4:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    800059a6:	00269713          	slli	a4,a3,0x2
    800059aa:	9736                	add	a4,a4,a3
    800059ac:	00371693          	slli	a3,a4,0x3
    800059b0:	00022717          	auipc	a4,0x22
    800059b4:	1f070713          	addi	a4,a4,496 # 80027ba0 <timer_scratch>
    800059b8:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    800059ba:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    800059bc:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    800059be:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    800059c2:	00000797          	auipc	a5,0x0
    800059c6:	93e78793          	addi	a5,a5,-1730 # 80005300 <timervec>
    800059ca:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800059ce:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    800059d2:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    800059d6:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    800059da:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    800059de:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    800059e2:	30479073          	csrw	mie,a5
}
    800059e6:	6422                	ld	s0,8(sp)
    800059e8:	0141                	addi	sp,sp,16
    800059ea:	8082                	ret

00000000800059ec <start>:
{
    800059ec:	1141                	addi	sp,sp,-16
    800059ee:	e406                	sd	ra,8(sp)
    800059f0:	e022                	sd	s0,0(sp)
    800059f2:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    800059f4:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    800059f8:	7779                	lui	a4,0xffffe
    800059fa:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffcea1f>
    800059fe:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80005a00:	6705                	lui	a4,0x1
    80005a02:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005a06:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005a08:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005a0c:	ffffb797          	auipc	a5,0xffffb
    80005a10:	91a78793          	addi	a5,a5,-1766 # 80000326 <main>
    80005a14:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005a18:	4781                	li	a5,0
    80005a1a:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005a1e:	67c1                	lui	a5,0x10
    80005a20:	17fd                	addi	a5,a5,-1
    80005a22:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005a26:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005a2a:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005a2e:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005a32:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005a36:	57fd                	li	a5,-1
    80005a38:	83a9                	srli	a5,a5,0xa
    80005a3a:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005a3e:	47bd                	li	a5,15
    80005a40:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005a44:	00000097          	auipc	ra,0x0
    80005a48:	f36080e7          	jalr	-202(ra) # 8000597a <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005a4c:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005a50:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005a52:	823e                	mv	tp,a5
  asm volatile("mret");
    80005a54:	30200073          	mret
}
    80005a58:	60a2                	ld	ra,8(sp)
    80005a5a:	6402                	ld	s0,0(sp)
    80005a5c:	0141                	addi	sp,sp,16
    80005a5e:	8082                	ret

0000000080005a60 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005a60:	715d                	addi	sp,sp,-80
    80005a62:	e486                	sd	ra,72(sp)
    80005a64:	e0a2                	sd	s0,64(sp)
    80005a66:	fc26                	sd	s1,56(sp)
    80005a68:	f84a                	sd	s2,48(sp)
    80005a6a:	f44e                	sd	s3,40(sp)
    80005a6c:	f052                	sd	s4,32(sp)
    80005a6e:	ec56                	sd	s5,24(sp)
    80005a70:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005a72:	04c05663          	blez	a2,80005abe <consolewrite+0x5e>
    80005a76:	8a2a                	mv	s4,a0
    80005a78:	84ae                	mv	s1,a1
    80005a7a:	89b2                	mv	s3,a2
    80005a7c:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005a7e:	5afd                	li	s5,-1
    80005a80:	4685                	li	a3,1
    80005a82:	8626                	mv	a2,s1
    80005a84:	85d2                	mv	a1,s4
    80005a86:	fbf40513          	addi	a0,s0,-65
    80005a8a:	ffffc097          	auipc	ra,0xffffc
    80005a8e:	eda080e7          	jalr	-294(ra) # 80001964 <either_copyin>
    80005a92:	01550c63          	beq	a0,s5,80005aaa <consolewrite+0x4a>
      break;
    uartputc(c);
    80005a96:	fbf44503          	lbu	a0,-65(s0)
    80005a9a:	00000097          	auipc	ra,0x0
    80005a9e:	794080e7          	jalr	1940(ra) # 8000622e <uartputc>
  for(i = 0; i < n; i++){
    80005aa2:	2905                	addiw	s2,s2,1
    80005aa4:	0485                	addi	s1,s1,1
    80005aa6:	fd299de3          	bne	s3,s2,80005a80 <consolewrite+0x20>
  }

  return i;
}
    80005aaa:	854a                	mv	a0,s2
    80005aac:	60a6                	ld	ra,72(sp)
    80005aae:	6406                	ld	s0,64(sp)
    80005ab0:	74e2                	ld	s1,56(sp)
    80005ab2:	7942                	ld	s2,48(sp)
    80005ab4:	79a2                	ld	s3,40(sp)
    80005ab6:	7a02                	ld	s4,32(sp)
    80005ab8:	6ae2                	ld	s5,24(sp)
    80005aba:	6161                	addi	sp,sp,80
    80005abc:	8082                	ret
  for(i = 0; i < n; i++){
    80005abe:	4901                	li	s2,0
    80005ac0:	b7ed                	j	80005aaa <consolewrite+0x4a>

0000000080005ac2 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005ac2:	7119                	addi	sp,sp,-128
    80005ac4:	fc86                	sd	ra,120(sp)
    80005ac6:	f8a2                	sd	s0,112(sp)
    80005ac8:	f4a6                	sd	s1,104(sp)
    80005aca:	f0ca                	sd	s2,96(sp)
    80005acc:	ecce                	sd	s3,88(sp)
    80005ace:	e8d2                	sd	s4,80(sp)
    80005ad0:	e4d6                	sd	s5,72(sp)
    80005ad2:	e0da                	sd	s6,64(sp)
    80005ad4:	fc5e                	sd	s7,56(sp)
    80005ad6:	f862                	sd	s8,48(sp)
    80005ad8:	f466                	sd	s9,40(sp)
    80005ada:	f06a                	sd	s10,32(sp)
    80005adc:	ec6e                	sd	s11,24(sp)
    80005ade:	0100                	addi	s0,sp,128
    80005ae0:	8b2a                	mv	s6,a0
    80005ae2:	8aae                	mv	s5,a1
    80005ae4:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005ae6:	00060b9b          	sext.w	s7,a2
  acquire(&cons.lock);
    80005aea:	0002a517          	auipc	a0,0x2a
    80005aee:	1f650513          	addi	a0,a0,502 # 8002fce0 <cons>
    80005af2:	00001097          	auipc	ra,0x1
    80005af6:	8fa080e7          	jalr	-1798(ra) # 800063ec <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005afa:	0002a497          	auipc	s1,0x2a
    80005afe:	1e648493          	addi	s1,s1,486 # 8002fce0 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005b02:	89a6                	mv	s3,s1
    80005b04:	0002a917          	auipc	s2,0x2a
    80005b08:	27490913          	addi	s2,s2,628 # 8002fd78 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];

    if(c == C('D')){  // end-of-file
    80005b0c:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005b0e:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    80005b10:	4da9                	li	s11,10
  while(n > 0){
    80005b12:	07405b63          	blez	s4,80005b88 <consoleread+0xc6>
    while(cons.r == cons.w){
    80005b16:	0984a783          	lw	a5,152(s1)
    80005b1a:	09c4a703          	lw	a4,156(s1)
    80005b1e:	02f71763          	bne	a4,a5,80005b4c <consoleread+0x8a>
      if(killed(myproc())){
    80005b22:	ffffb097          	auipc	ra,0xffffb
    80005b26:	340080e7          	jalr	832(ra) # 80000e62 <myproc>
    80005b2a:	ffffc097          	auipc	ra,0xffffc
    80005b2e:	c84080e7          	jalr	-892(ra) # 800017ae <killed>
    80005b32:	e535                	bnez	a0,80005b9e <consoleread+0xdc>
      sleep(&cons.r, &cons.lock);
    80005b34:	85ce                	mv	a1,s3
    80005b36:	854a                	mv	a0,s2
    80005b38:	ffffc097          	auipc	ra,0xffffc
    80005b3c:	9ce080e7          	jalr	-1586(ra) # 80001506 <sleep>
    while(cons.r == cons.w){
    80005b40:	0984a783          	lw	a5,152(s1)
    80005b44:	09c4a703          	lw	a4,156(s1)
    80005b48:	fcf70de3          	beq	a4,a5,80005b22 <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80005b4c:	0017871b          	addiw	a4,a5,1
    80005b50:	08e4ac23          	sw	a4,152(s1)
    80005b54:	07f7f713          	andi	a4,a5,127
    80005b58:	9726                	add	a4,a4,s1
    80005b5a:	01874703          	lbu	a4,24(a4)
    80005b5e:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    80005b62:	079c0663          	beq	s8,s9,80005bce <consoleread+0x10c>
    cbuf = c;
    80005b66:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005b6a:	4685                	li	a3,1
    80005b6c:	f8f40613          	addi	a2,s0,-113
    80005b70:	85d6                	mv	a1,s5
    80005b72:	855a                	mv	a0,s6
    80005b74:	ffffc097          	auipc	ra,0xffffc
    80005b78:	d9a080e7          	jalr	-614(ra) # 8000190e <either_copyout>
    80005b7c:	01a50663          	beq	a0,s10,80005b88 <consoleread+0xc6>
    dst++;
    80005b80:	0a85                	addi	s5,s5,1
    --n;
    80005b82:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    80005b84:	f9bc17e3          	bne	s8,s11,80005b12 <consoleread+0x50>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005b88:	0002a517          	auipc	a0,0x2a
    80005b8c:	15850513          	addi	a0,a0,344 # 8002fce0 <cons>
    80005b90:	00001097          	auipc	ra,0x1
    80005b94:	910080e7          	jalr	-1776(ra) # 800064a0 <release>

  return target - n;
    80005b98:	414b853b          	subw	a0,s7,s4
    80005b9c:	a811                	j	80005bb0 <consoleread+0xee>
        release(&cons.lock);
    80005b9e:	0002a517          	auipc	a0,0x2a
    80005ba2:	14250513          	addi	a0,a0,322 # 8002fce0 <cons>
    80005ba6:	00001097          	auipc	ra,0x1
    80005baa:	8fa080e7          	jalr	-1798(ra) # 800064a0 <release>
        return -1;
    80005bae:	557d                	li	a0,-1
}
    80005bb0:	70e6                	ld	ra,120(sp)
    80005bb2:	7446                	ld	s0,112(sp)
    80005bb4:	74a6                	ld	s1,104(sp)
    80005bb6:	7906                	ld	s2,96(sp)
    80005bb8:	69e6                	ld	s3,88(sp)
    80005bba:	6a46                	ld	s4,80(sp)
    80005bbc:	6aa6                	ld	s5,72(sp)
    80005bbe:	6b06                	ld	s6,64(sp)
    80005bc0:	7be2                	ld	s7,56(sp)
    80005bc2:	7c42                	ld	s8,48(sp)
    80005bc4:	7ca2                	ld	s9,40(sp)
    80005bc6:	7d02                	ld	s10,32(sp)
    80005bc8:	6de2                	ld	s11,24(sp)
    80005bca:	6109                	addi	sp,sp,128
    80005bcc:	8082                	ret
      if(n < target){
    80005bce:	000a071b          	sext.w	a4,s4
    80005bd2:	fb777be3          	bgeu	a4,s7,80005b88 <consoleread+0xc6>
        cons.r--;
    80005bd6:	0002a717          	auipc	a4,0x2a
    80005bda:	1af72123          	sw	a5,418(a4) # 8002fd78 <cons+0x98>
    80005bde:	b76d                	j	80005b88 <consoleread+0xc6>

0000000080005be0 <consputc>:
{
    80005be0:	1141                	addi	sp,sp,-16
    80005be2:	e406                	sd	ra,8(sp)
    80005be4:	e022                	sd	s0,0(sp)
    80005be6:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005be8:	10000793          	li	a5,256
    80005bec:	00f50a63          	beq	a0,a5,80005c00 <consputc+0x20>
    uartputc_sync(c);
    80005bf0:	00000097          	auipc	ra,0x0
    80005bf4:	564080e7          	jalr	1380(ra) # 80006154 <uartputc_sync>
}
    80005bf8:	60a2                	ld	ra,8(sp)
    80005bfa:	6402                	ld	s0,0(sp)
    80005bfc:	0141                	addi	sp,sp,16
    80005bfe:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005c00:	4521                	li	a0,8
    80005c02:	00000097          	auipc	ra,0x0
    80005c06:	552080e7          	jalr	1362(ra) # 80006154 <uartputc_sync>
    80005c0a:	02000513          	li	a0,32
    80005c0e:	00000097          	auipc	ra,0x0
    80005c12:	546080e7          	jalr	1350(ra) # 80006154 <uartputc_sync>
    80005c16:	4521                	li	a0,8
    80005c18:	00000097          	auipc	ra,0x0
    80005c1c:	53c080e7          	jalr	1340(ra) # 80006154 <uartputc_sync>
    80005c20:	bfe1                	j	80005bf8 <consputc+0x18>

0000000080005c22 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005c22:	1101                	addi	sp,sp,-32
    80005c24:	ec06                	sd	ra,24(sp)
    80005c26:	e822                	sd	s0,16(sp)
    80005c28:	e426                	sd	s1,8(sp)
    80005c2a:	e04a                	sd	s2,0(sp)
    80005c2c:	1000                	addi	s0,sp,32
    80005c2e:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005c30:	0002a517          	auipc	a0,0x2a
    80005c34:	0b050513          	addi	a0,a0,176 # 8002fce0 <cons>
    80005c38:	00000097          	auipc	ra,0x0
    80005c3c:	7b4080e7          	jalr	1972(ra) # 800063ec <acquire>

  switch(c){
    80005c40:	47d5                	li	a5,21
    80005c42:	0af48663          	beq	s1,a5,80005cee <consoleintr+0xcc>
    80005c46:	0297ca63          	blt	a5,s1,80005c7a <consoleintr+0x58>
    80005c4a:	47a1                	li	a5,8
    80005c4c:	0ef48763          	beq	s1,a5,80005d3a <consoleintr+0x118>
    80005c50:	47c1                	li	a5,16
    80005c52:	10f49a63          	bne	s1,a5,80005d66 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005c56:	ffffc097          	auipc	ra,0xffffc
    80005c5a:	d64080e7          	jalr	-668(ra) # 800019ba <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005c5e:	0002a517          	auipc	a0,0x2a
    80005c62:	08250513          	addi	a0,a0,130 # 8002fce0 <cons>
    80005c66:	00001097          	auipc	ra,0x1
    80005c6a:	83a080e7          	jalr	-1990(ra) # 800064a0 <release>
}
    80005c6e:	60e2                	ld	ra,24(sp)
    80005c70:	6442                	ld	s0,16(sp)
    80005c72:	64a2                	ld	s1,8(sp)
    80005c74:	6902                	ld	s2,0(sp)
    80005c76:	6105                	addi	sp,sp,32
    80005c78:	8082                	ret
  switch(c){
    80005c7a:	07f00793          	li	a5,127
    80005c7e:	0af48e63          	beq	s1,a5,80005d3a <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005c82:	0002a717          	auipc	a4,0x2a
    80005c86:	05e70713          	addi	a4,a4,94 # 8002fce0 <cons>
    80005c8a:	0a072783          	lw	a5,160(a4)
    80005c8e:	09872703          	lw	a4,152(a4)
    80005c92:	9f99                	subw	a5,a5,a4
    80005c94:	07f00713          	li	a4,127
    80005c98:	fcf763e3          	bltu	a4,a5,80005c5e <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005c9c:	47b5                	li	a5,13
    80005c9e:	0cf48763          	beq	s1,a5,80005d6c <consoleintr+0x14a>
      consputc(c);
    80005ca2:	8526                	mv	a0,s1
    80005ca4:	00000097          	auipc	ra,0x0
    80005ca8:	f3c080e7          	jalr	-196(ra) # 80005be0 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005cac:	0002a797          	auipc	a5,0x2a
    80005cb0:	03478793          	addi	a5,a5,52 # 8002fce0 <cons>
    80005cb4:	0a07a683          	lw	a3,160(a5)
    80005cb8:	0016871b          	addiw	a4,a3,1
    80005cbc:	0007061b          	sext.w	a2,a4
    80005cc0:	0ae7a023          	sw	a4,160(a5)
    80005cc4:	07f6f693          	andi	a3,a3,127
    80005cc8:	97b6                	add	a5,a5,a3
    80005cca:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005cce:	47a9                	li	a5,10
    80005cd0:	0cf48563          	beq	s1,a5,80005d9a <consoleintr+0x178>
    80005cd4:	4791                	li	a5,4
    80005cd6:	0cf48263          	beq	s1,a5,80005d9a <consoleintr+0x178>
    80005cda:	0002a797          	auipc	a5,0x2a
    80005cde:	09e7a783          	lw	a5,158(a5) # 8002fd78 <cons+0x98>
    80005ce2:	9f1d                	subw	a4,a4,a5
    80005ce4:	08000793          	li	a5,128
    80005ce8:	f6f71be3          	bne	a4,a5,80005c5e <consoleintr+0x3c>
    80005cec:	a07d                	j	80005d9a <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005cee:	0002a717          	auipc	a4,0x2a
    80005cf2:	ff270713          	addi	a4,a4,-14 # 8002fce0 <cons>
    80005cf6:	0a072783          	lw	a5,160(a4)
    80005cfa:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005cfe:	0002a497          	auipc	s1,0x2a
    80005d02:	fe248493          	addi	s1,s1,-30 # 8002fce0 <cons>
    while(cons.e != cons.w &&
    80005d06:	4929                	li	s2,10
    80005d08:	f4f70be3          	beq	a4,a5,80005c5e <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005d0c:	37fd                	addiw	a5,a5,-1
    80005d0e:	07f7f713          	andi	a4,a5,127
    80005d12:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005d14:	01874703          	lbu	a4,24(a4)
    80005d18:	f52703e3          	beq	a4,s2,80005c5e <consoleintr+0x3c>
      cons.e--;
    80005d1c:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005d20:	10000513          	li	a0,256
    80005d24:	00000097          	auipc	ra,0x0
    80005d28:	ebc080e7          	jalr	-324(ra) # 80005be0 <consputc>
    while(cons.e != cons.w &&
    80005d2c:	0a04a783          	lw	a5,160(s1)
    80005d30:	09c4a703          	lw	a4,156(s1)
    80005d34:	fcf71ce3          	bne	a4,a5,80005d0c <consoleintr+0xea>
    80005d38:	b71d                	j	80005c5e <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005d3a:	0002a717          	auipc	a4,0x2a
    80005d3e:	fa670713          	addi	a4,a4,-90 # 8002fce0 <cons>
    80005d42:	0a072783          	lw	a5,160(a4)
    80005d46:	09c72703          	lw	a4,156(a4)
    80005d4a:	f0f70ae3          	beq	a4,a5,80005c5e <consoleintr+0x3c>
      cons.e--;
    80005d4e:	37fd                	addiw	a5,a5,-1
    80005d50:	0002a717          	auipc	a4,0x2a
    80005d54:	02f72823          	sw	a5,48(a4) # 8002fd80 <cons+0xa0>
      consputc(BACKSPACE);
    80005d58:	10000513          	li	a0,256
    80005d5c:	00000097          	auipc	ra,0x0
    80005d60:	e84080e7          	jalr	-380(ra) # 80005be0 <consputc>
    80005d64:	bded                	j	80005c5e <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005d66:	ee048ce3          	beqz	s1,80005c5e <consoleintr+0x3c>
    80005d6a:	bf21                	j	80005c82 <consoleintr+0x60>
      consputc(c);
    80005d6c:	4529                	li	a0,10
    80005d6e:	00000097          	auipc	ra,0x0
    80005d72:	e72080e7          	jalr	-398(ra) # 80005be0 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005d76:	0002a797          	auipc	a5,0x2a
    80005d7a:	f6a78793          	addi	a5,a5,-150 # 8002fce0 <cons>
    80005d7e:	0a07a703          	lw	a4,160(a5)
    80005d82:	0017069b          	addiw	a3,a4,1
    80005d86:	0006861b          	sext.w	a2,a3
    80005d8a:	0ad7a023          	sw	a3,160(a5)
    80005d8e:	07f77713          	andi	a4,a4,127
    80005d92:	97ba                	add	a5,a5,a4
    80005d94:	4729                	li	a4,10
    80005d96:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005d9a:	0002a797          	auipc	a5,0x2a
    80005d9e:	fec7a123          	sw	a2,-30(a5) # 8002fd7c <cons+0x9c>
        wakeup(&cons.r);
    80005da2:	0002a517          	auipc	a0,0x2a
    80005da6:	fd650513          	addi	a0,a0,-42 # 8002fd78 <cons+0x98>
    80005daa:	ffffb097          	auipc	ra,0xffffb
    80005dae:	7c0080e7          	jalr	1984(ra) # 8000156a <wakeup>
    80005db2:	b575                	j	80005c5e <consoleintr+0x3c>

0000000080005db4 <consoleinit>:

void
consoleinit(void)
{
    80005db4:	1141                	addi	sp,sp,-16
    80005db6:	e406                	sd	ra,8(sp)
    80005db8:	e022                	sd	s0,0(sp)
    80005dba:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005dbc:	00003597          	auipc	a1,0x3
    80005dc0:	a8c58593          	addi	a1,a1,-1396 # 80008848 <syscalls+0x418>
    80005dc4:	0002a517          	auipc	a0,0x2a
    80005dc8:	f1c50513          	addi	a0,a0,-228 # 8002fce0 <cons>
    80005dcc:	00000097          	auipc	ra,0x0
    80005dd0:	590080e7          	jalr	1424(ra) # 8000635c <initlock>

  uartinit();
    80005dd4:	00000097          	auipc	ra,0x0
    80005dd8:	330080e7          	jalr	816(ra) # 80006104 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005ddc:	00021797          	auipc	a5,0x21
    80005de0:	c2c78793          	addi	a5,a5,-980 # 80026a08 <devsw>
    80005de4:	00000717          	auipc	a4,0x0
    80005de8:	cde70713          	addi	a4,a4,-802 # 80005ac2 <consoleread>
    80005dec:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005dee:	00000717          	auipc	a4,0x0
    80005df2:	c7270713          	addi	a4,a4,-910 # 80005a60 <consolewrite>
    80005df6:	ef98                	sd	a4,24(a5)
}
    80005df8:	60a2                	ld	ra,8(sp)
    80005dfa:	6402                	ld	s0,0(sp)
    80005dfc:	0141                	addi	sp,sp,16
    80005dfe:	8082                	ret

0000000080005e00 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005e00:	7179                	addi	sp,sp,-48
    80005e02:	f406                	sd	ra,40(sp)
    80005e04:	f022                	sd	s0,32(sp)
    80005e06:	ec26                	sd	s1,24(sp)
    80005e08:	e84a                	sd	s2,16(sp)
    80005e0a:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005e0c:	c219                	beqz	a2,80005e12 <printint+0x12>
    80005e0e:	08054663          	bltz	a0,80005e9a <printint+0x9a>
    x = -xx;
  else
    x = xx;
    80005e12:	2501                	sext.w	a0,a0
    80005e14:	4881                	li	a7,0
    80005e16:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005e1a:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005e1c:	2581                	sext.w	a1,a1
    80005e1e:	00003617          	auipc	a2,0x3
    80005e22:	a5a60613          	addi	a2,a2,-1446 # 80008878 <digits>
    80005e26:	883a                	mv	a6,a4
    80005e28:	2705                	addiw	a4,a4,1
    80005e2a:	02b577bb          	remuw	a5,a0,a1
    80005e2e:	1782                	slli	a5,a5,0x20
    80005e30:	9381                	srli	a5,a5,0x20
    80005e32:	97b2                	add	a5,a5,a2
    80005e34:	0007c783          	lbu	a5,0(a5)
    80005e38:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005e3c:	0005079b          	sext.w	a5,a0
    80005e40:	02b5553b          	divuw	a0,a0,a1
    80005e44:	0685                	addi	a3,a3,1
    80005e46:	feb7f0e3          	bgeu	a5,a1,80005e26 <printint+0x26>

  if(sign)
    80005e4a:	00088b63          	beqz	a7,80005e60 <printint+0x60>
    buf[i++] = '-';
    80005e4e:	fe040793          	addi	a5,s0,-32
    80005e52:	973e                	add	a4,a4,a5
    80005e54:	02d00793          	li	a5,45
    80005e58:	fef70823          	sb	a5,-16(a4)
    80005e5c:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005e60:	02e05763          	blez	a4,80005e8e <printint+0x8e>
    80005e64:	fd040793          	addi	a5,s0,-48
    80005e68:	00e784b3          	add	s1,a5,a4
    80005e6c:	fff78913          	addi	s2,a5,-1
    80005e70:	993a                	add	s2,s2,a4
    80005e72:	377d                	addiw	a4,a4,-1
    80005e74:	1702                	slli	a4,a4,0x20
    80005e76:	9301                	srli	a4,a4,0x20
    80005e78:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005e7c:	fff4c503          	lbu	a0,-1(s1)
    80005e80:	00000097          	auipc	ra,0x0
    80005e84:	d60080e7          	jalr	-672(ra) # 80005be0 <consputc>
  while(--i >= 0)
    80005e88:	14fd                	addi	s1,s1,-1
    80005e8a:	ff2499e3          	bne	s1,s2,80005e7c <printint+0x7c>
}
    80005e8e:	70a2                	ld	ra,40(sp)
    80005e90:	7402                	ld	s0,32(sp)
    80005e92:	64e2                	ld	s1,24(sp)
    80005e94:	6942                	ld	s2,16(sp)
    80005e96:	6145                	addi	sp,sp,48
    80005e98:	8082                	ret
    x = -xx;
    80005e9a:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005e9e:	4885                	li	a7,1
    x = -xx;
    80005ea0:	bf9d                	j	80005e16 <printint+0x16>

0000000080005ea2 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005ea2:	1101                	addi	sp,sp,-32
    80005ea4:	ec06                	sd	ra,24(sp)
    80005ea6:	e822                	sd	s0,16(sp)
    80005ea8:	e426                	sd	s1,8(sp)
    80005eaa:	1000                	addi	s0,sp,32
    80005eac:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005eae:	0002a797          	auipc	a5,0x2a
    80005eb2:	ee07a923          	sw	zero,-270(a5) # 8002fda0 <pr+0x18>
  printf("panic: ");
    80005eb6:	00003517          	auipc	a0,0x3
    80005eba:	99a50513          	addi	a0,a0,-1638 # 80008850 <syscalls+0x420>
    80005ebe:	00000097          	auipc	ra,0x0
    80005ec2:	02e080e7          	jalr	46(ra) # 80005eec <printf>
  printf(s);
    80005ec6:	8526                	mv	a0,s1
    80005ec8:	00000097          	auipc	ra,0x0
    80005ecc:	024080e7          	jalr	36(ra) # 80005eec <printf>
  printf("\n");
    80005ed0:	00002517          	auipc	a0,0x2
    80005ed4:	17850513          	addi	a0,a0,376 # 80008048 <etext+0x48>
    80005ed8:	00000097          	auipc	ra,0x0
    80005edc:	014080e7          	jalr	20(ra) # 80005eec <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005ee0:	4785                	li	a5,1
    80005ee2:	00003717          	auipc	a4,0x3
    80005ee6:	a6f72d23          	sw	a5,-1414(a4) # 8000895c <panicked>
  for(;;)
    80005eea:	a001                	j	80005eea <panic+0x48>

0000000080005eec <printf>:
{
    80005eec:	7131                	addi	sp,sp,-192
    80005eee:	fc86                	sd	ra,120(sp)
    80005ef0:	f8a2                	sd	s0,112(sp)
    80005ef2:	f4a6                	sd	s1,104(sp)
    80005ef4:	f0ca                	sd	s2,96(sp)
    80005ef6:	ecce                	sd	s3,88(sp)
    80005ef8:	e8d2                	sd	s4,80(sp)
    80005efa:	e4d6                	sd	s5,72(sp)
    80005efc:	e0da                	sd	s6,64(sp)
    80005efe:	fc5e                	sd	s7,56(sp)
    80005f00:	f862                	sd	s8,48(sp)
    80005f02:	f466                	sd	s9,40(sp)
    80005f04:	f06a                	sd	s10,32(sp)
    80005f06:	ec6e                	sd	s11,24(sp)
    80005f08:	0100                	addi	s0,sp,128
    80005f0a:	8a2a                	mv	s4,a0
    80005f0c:	e40c                	sd	a1,8(s0)
    80005f0e:	e810                	sd	a2,16(s0)
    80005f10:	ec14                	sd	a3,24(s0)
    80005f12:	f018                	sd	a4,32(s0)
    80005f14:	f41c                	sd	a5,40(s0)
    80005f16:	03043823          	sd	a6,48(s0)
    80005f1a:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005f1e:	0002ad97          	auipc	s11,0x2a
    80005f22:	e82dad83          	lw	s11,-382(s11) # 8002fda0 <pr+0x18>
  if(locking)
    80005f26:	020d9b63          	bnez	s11,80005f5c <printf+0x70>
  if (fmt == 0)
    80005f2a:	040a0263          	beqz	s4,80005f6e <printf+0x82>
  va_start(ap, fmt);
    80005f2e:	00840793          	addi	a5,s0,8
    80005f32:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005f36:	000a4503          	lbu	a0,0(s4)
    80005f3a:	16050263          	beqz	a0,8000609e <printf+0x1b2>
    80005f3e:	4481                	li	s1,0
    if(c != '%'){
    80005f40:	02500a93          	li	s5,37
    switch(c){
    80005f44:	07000b13          	li	s6,112
  consputc('x');
    80005f48:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005f4a:	00003b97          	auipc	s7,0x3
    80005f4e:	92eb8b93          	addi	s7,s7,-1746 # 80008878 <digits>
    switch(c){
    80005f52:	07300c93          	li	s9,115
    80005f56:	06400c13          	li	s8,100
    80005f5a:	a82d                	j	80005f94 <printf+0xa8>
    acquire(&pr.lock);
    80005f5c:	0002a517          	auipc	a0,0x2a
    80005f60:	e2c50513          	addi	a0,a0,-468 # 8002fd88 <pr>
    80005f64:	00000097          	auipc	ra,0x0
    80005f68:	488080e7          	jalr	1160(ra) # 800063ec <acquire>
    80005f6c:	bf7d                	j	80005f2a <printf+0x3e>
    panic("null fmt");
    80005f6e:	00003517          	auipc	a0,0x3
    80005f72:	8f250513          	addi	a0,a0,-1806 # 80008860 <syscalls+0x430>
    80005f76:	00000097          	auipc	ra,0x0
    80005f7a:	f2c080e7          	jalr	-212(ra) # 80005ea2 <panic>
      consputc(c);
    80005f7e:	00000097          	auipc	ra,0x0
    80005f82:	c62080e7          	jalr	-926(ra) # 80005be0 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005f86:	2485                	addiw	s1,s1,1
    80005f88:	009a07b3          	add	a5,s4,s1
    80005f8c:	0007c503          	lbu	a0,0(a5)
    80005f90:	10050763          	beqz	a0,8000609e <printf+0x1b2>
    if(c != '%'){
    80005f94:	ff5515e3          	bne	a0,s5,80005f7e <printf+0x92>
    c = fmt[++i] & 0xff;
    80005f98:	2485                	addiw	s1,s1,1
    80005f9a:	009a07b3          	add	a5,s4,s1
    80005f9e:	0007c783          	lbu	a5,0(a5)
    80005fa2:	0007891b          	sext.w	s2,a5
    if(c == 0)
    80005fa6:	cfe5                	beqz	a5,8000609e <printf+0x1b2>
    switch(c){
    80005fa8:	05678a63          	beq	a5,s6,80005ffc <printf+0x110>
    80005fac:	02fb7663          	bgeu	s6,a5,80005fd8 <printf+0xec>
    80005fb0:	09978963          	beq	a5,s9,80006042 <printf+0x156>
    80005fb4:	07800713          	li	a4,120
    80005fb8:	0ce79863          	bne	a5,a4,80006088 <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    80005fbc:	f8843783          	ld	a5,-120(s0)
    80005fc0:	00878713          	addi	a4,a5,8
    80005fc4:	f8e43423          	sd	a4,-120(s0)
    80005fc8:	4605                	li	a2,1
    80005fca:	85ea                	mv	a1,s10
    80005fcc:	4388                	lw	a0,0(a5)
    80005fce:	00000097          	auipc	ra,0x0
    80005fd2:	e32080e7          	jalr	-462(ra) # 80005e00 <printint>
      break;
    80005fd6:	bf45                	j	80005f86 <printf+0x9a>
    switch(c){
    80005fd8:	0b578263          	beq	a5,s5,8000607c <printf+0x190>
    80005fdc:	0b879663          	bne	a5,s8,80006088 <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    80005fe0:	f8843783          	ld	a5,-120(s0)
    80005fe4:	00878713          	addi	a4,a5,8
    80005fe8:	f8e43423          	sd	a4,-120(s0)
    80005fec:	4605                	li	a2,1
    80005fee:	45a9                	li	a1,10
    80005ff0:	4388                	lw	a0,0(a5)
    80005ff2:	00000097          	auipc	ra,0x0
    80005ff6:	e0e080e7          	jalr	-498(ra) # 80005e00 <printint>
      break;
    80005ffa:	b771                	j	80005f86 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    80005ffc:	f8843783          	ld	a5,-120(s0)
    80006000:	00878713          	addi	a4,a5,8
    80006004:	f8e43423          	sd	a4,-120(s0)
    80006008:	0007b983          	ld	s3,0(a5)
  consputc('0');
    8000600c:	03000513          	li	a0,48
    80006010:	00000097          	auipc	ra,0x0
    80006014:	bd0080e7          	jalr	-1072(ra) # 80005be0 <consputc>
  consputc('x');
    80006018:	07800513          	li	a0,120
    8000601c:	00000097          	auipc	ra,0x0
    80006020:	bc4080e7          	jalr	-1084(ra) # 80005be0 <consputc>
    80006024:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80006026:	03c9d793          	srli	a5,s3,0x3c
    8000602a:	97de                	add	a5,a5,s7
    8000602c:	0007c503          	lbu	a0,0(a5)
    80006030:	00000097          	auipc	ra,0x0
    80006034:	bb0080e7          	jalr	-1104(ra) # 80005be0 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80006038:	0992                	slli	s3,s3,0x4
    8000603a:	397d                	addiw	s2,s2,-1
    8000603c:	fe0915e3          	bnez	s2,80006026 <printf+0x13a>
    80006040:	b799                	j	80005f86 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80006042:	f8843783          	ld	a5,-120(s0)
    80006046:	00878713          	addi	a4,a5,8
    8000604a:	f8e43423          	sd	a4,-120(s0)
    8000604e:	0007b903          	ld	s2,0(a5)
    80006052:	00090e63          	beqz	s2,8000606e <printf+0x182>
      for(; *s; s++)
    80006056:	00094503          	lbu	a0,0(s2)
    8000605a:	d515                	beqz	a0,80005f86 <printf+0x9a>
        consputc(*s);
    8000605c:	00000097          	auipc	ra,0x0
    80006060:	b84080e7          	jalr	-1148(ra) # 80005be0 <consputc>
      for(; *s; s++)
    80006064:	0905                	addi	s2,s2,1
    80006066:	00094503          	lbu	a0,0(s2)
    8000606a:	f96d                	bnez	a0,8000605c <printf+0x170>
    8000606c:	bf29                	j	80005f86 <printf+0x9a>
        s = "(null)";
    8000606e:	00002917          	auipc	s2,0x2
    80006072:	7ea90913          	addi	s2,s2,2026 # 80008858 <syscalls+0x428>
      for(; *s; s++)
    80006076:	02800513          	li	a0,40
    8000607a:	b7cd                	j	8000605c <printf+0x170>
      consputc('%');
    8000607c:	8556                	mv	a0,s5
    8000607e:	00000097          	auipc	ra,0x0
    80006082:	b62080e7          	jalr	-1182(ra) # 80005be0 <consputc>
      break;
    80006086:	b701                	j	80005f86 <printf+0x9a>
      consputc('%');
    80006088:	8556                	mv	a0,s5
    8000608a:	00000097          	auipc	ra,0x0
    8000608e:	b56080e7          	jalr	-1194(ra) # 80005be0 <consputc>
      consputc(c);
    80006092:	854a                	mv	a0,s2
    80006094:	00000097          	auipc	ra,0x0
    80006098:	b4c080e7          	jalr	-1204(ra) # 80005be0 <consputc>
      break;
    8000609c:	b5ed                	j	80005f86 <printf+0x9a>
  if(locking)
    8000609e:	020d9163          	bnez	s11,800060c0 <printf+0x1d4>
}
    800060a2:	70e6                	ld	ra,120(sp)
    800060a4:	7446                	ld	s0,112(sp)
    800060a6:	74a6                	ld	s1,104(sp)
    800060a8:	7906                	ld	s2,96(sp)
    800060aa:	69e6                	ld	s3,88(sp)
    800060ac:	6a46                	ld	s4,80(sp)
    800060ae:	6aa6                	ld	s5,72(sp)
    800060b0:	6b06                	ld	s6,64(sp)
    800060b2:	7be2                	ld	s7,56(sp)
    800060b4:	7c42                	ld	s8,48(sp)
    800060b6:	7ca2                	ld	s9,40(sp)
    800060b8:	7d02                	ld	s10,32(sp)
    800060ba:	6de2                	ld	s11,24(sp)
    800060bc:	6129                	addi	sp,sp,192
    800060be:	8082                	ret
    release(&pr.lock);
    800060c0:	0002a517          	auipc	a0,0x2a
    800060c4:	cc850513          	addi	a0,a0,-824 # 8002fd88 <pr>
    800060c8:	00000097          	auipc	ra,0x0
    800060cc:	3d8080e7          	jalr	984(ra) # 800064a0 <release>
}
    800060d0:	bfc9                	j	800060a2 <printf+0x1b6>

00000000800060d2 <printfinit>:
    ;
}

void
printfinit(void)
{
    800060d2:	1101                	addi	sp,sp,-32
    800060d4:	ec06                	sd	ra,24(sp)
    800060d6:	e822                	sd	s0,16(sp)
    800060d8:	e426                	sd	s1,8(sp)
    800060da:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    800060dc:	0002a497          	auipc	s1,0x2a
    800060e0:	cac48493          	addi	s1,s1,-852 # 8002fd88 <pr>
    800060e4:	00002597          	auipc	a1,0x2
    800060e8:	78c58593          	addi	a1,a1,1932 # 80008870 <syscalls+0x440>
    800060ec:	8526                	mv	a0,s1
    800060ee:	00000097          	auipc	ra,0x0
    800060f2:	26e080e7          	jalr	622(ra) # 8000635c <initlock>
  pr.locking = 1;
    800060f6:	4785                	li	a5,1
    800060f8:	cc9c                	sw	a5,24(s1)
}
    800060fa:	60e2                	ld	ra,24(sp)
    800060fc:	6442                	ld	s0,16(sp)
    800060fe:	64a2                	ld	s1,8(sp)
    80006100:	6105                	addi	sp,sp,32
    80006102:	8082                	ret

0000000080006104 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80006104:	1141                	addi	sp,sp,-16
    80006106:	e406                	sd	ra,8(sp)
    80006108:	e022                	sd	s0,0(sp)
    8000610a:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    8000610c:	100007b7          	lui	a5,0x10000
    80006110:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80006114:	f8000713          	li	a4,-128
    80006118:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    8000611c:	470d                	li	a4,3
    8000611e:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80006122:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80006126:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    8000612a:	469d                	li	a3,7
    8000612c:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80006130:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80006134:	00002597          	auipc	a1,0x2
    80006138:	75c58593          	addi	a1,a1,1884 # 80008890 <digits+0x18>
    8000613c:	0002a517          	auipc	a0,0x2a
    80006140:	c6c50513          	addi	a0,a0,-916 # 8002fda8 <uart_tx_lock>
    80006144:	00000097          	auipc	ra,0x0
    80006148:	218080e7          	jalr	536(ra) # 8000635c <initlock>
}
    8000614c:	60a2                	ld	ra,8(sp)
    8000614e:	6402                	ld	s0,0(sp)
    80006150:	0141                	addi	sp,sp,16
    80006152:	8082                	ret

0000000080006154 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80006154:	1101                	addi	sp,sp,-32
    80006156:	ec06                	sd	ra,24(sp)
    80006158:	e822                	sd	s0,16(sp)
    8000615a:	e426                	sd	s1,8(sp)
    8000615c:	1000                	addi	s0,sp,32
    8000615e:	84aa                	mv	s1,a0
  push_off();
    80006160:	00000097          	auipc	ra,0x0
    80006164:	240080e7          	jalr	576(ra) # 800063a0 <push_off>

  if(panicked){
    80006168:	00002797          	auipc	a5,0x2
    8000616c:	7f47a783          	lw	a5,2036(a5) # 8000895c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006170:	10000737          	lui	a4,0x10000
  if(panicked){
    80006174:	c391                	beqz	a5,80006178 <uartputc_sync+0x24>
    for(;;)
    80006176:	a001                	j	80006176 <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006178:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    8000617c:	0ff7f793          	andi	a5,a5,255
    80006180:	0207f793          	andi	a5,a5,32
    80006184:	dbf5                	beqz	a5,80006178 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80006186:	0ff4f793          	andi	a5,s1,255
    8000618a:	10000737          	lui	a4,0x10000
    8000618e:	00f70023          	sb	a5,0(a4) # 10000000 <_entry-0x70000000>

  pop_off();
    80006192:	00000097          	auipc	ra,0x0
    80006196:	2ae080e7          	jalr	686(ra) # 80006440 <pop_off>
}
    8000619a:	60e2                	ld	ra,24(sp)
    8000619c:	6442                	ld	s0,16(sp)
    8000619e:	64a2                	ld	s1,8(sp)
    800061a0:	6105                	addi	sp,sp,32
    800061a2:	8082                	ret

00000000800061a4 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    800061a4:	00002717          	auipc	a4,0x2
    800061a8:	7bc73703          	ld	a4,1980(a4) # 80008960 <uart_tx_r>
    800061ac:	00002797          	auipc	a5,0x2
    800061b0:	7bc7b783          	ld	a5,1980(a5) # 80008968 <uart_tx_w>
    800061b4:	06e78c63          	beq	a5,a4,8000622c <uartstart+0x88>
{
    800061b8:	7139                	addi	sp,sp,-64
    800061ba:	fc06                	sd	ra,56(sp)
    800061bc:	f822                	sd	s0,48(sp)
    800061be:	f426                	sd	s1,40(sp)
    800061c0:	f04a                	sd	s2,32(sp)
    800061c2:	ec4e                	sd	s3,24(sp)
    800061c4:	e852                	sd	s4,16(sp)
    800061c6:	e456                	sd	s5,8(sp)
    800061c8:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800061ca:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800061ce:	0002aa17          	auipc	s4,0x2a
    800061d2:	bdaa0a13          	addi	s4,s4,-1062 # 8002fda8 <uart_tx_lock>
    uart_tx_r += 1;
    800061d6:	00002497          	auipc	s1,0x2
    800061da:	78a48493          	addi	s1,s1,1930 # 80008960 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    800061de:	00002997          	auipc	s3,0x2
    800061e2:	78a98993          	addi	s3,s3,1930 # 80008968 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800061e6:	00594783          	lbu	a5,5(s2) # 10000005 <_entry-0x6ffffffb>
    800061ea:	0ff7f793          	andi	a5,a5,255
    800061ee:	0207f793          	andi	a5,a5,32
    800061f2:	c785                	beqz	a5,8000621a <uartstart+0x76>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800061f4:	01f77793          	andi	a5,a4,31
    800061f8:	97d2                	add	a5,a5,s4
    800061fa:	0187ca83          	lbu	s5,24(a5)
    uart_tx_r += 1;
    800061fe:	0705                	addi	a4,a4,1
    80006200:	e098                	sd	a4,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80006202:	8526                	mv	a0,s1
    80006204:	ffffb097          	auipc	ra,0xffffb
    80006208:	366080e7          	jalr	870(ra) # 8000156a <wakeup>
    
    WriteReg(THR, c);
    8000620c:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80006210:	6098                	ld	a4,0(s1)
    80006212:	0009b783          	ld	a5,0(s3)
    80006216:	fce798e3          	bne	a5,a4,800061e6 <uartstart+0x42>
  }
}
    8000621a:	70e2                	ld	ra,56(sp)
    8000621c:	7442                	ld	s0,48(sp)
    8000621e:	74a2                	ld	s1,40(sp)
    80006220:	7902                	ld	s2,32(sp)
    80006222:	69e2                	ld	s3,24(sp)
    80006224:	6a42                	ld	s4,16(sp)
    80006226:	6aa2                	ld	s5,8(sp)
    80006228:	6121                	addi	sp,sp,64
    8000622a:	8082                	ret
    8000622c:	8082                	ret

000000008000622e <uartputc>:
{
    8000622e:	7179                	addi	sp,sp,-48
    80006230:	f406                	sd	ra,40(sp)
    80006232:	f022                	sd	s0,32(sp)
    80006234:	ec26                	sd	s1,24(sp)
    80006236:	e84a                	sd	s2,16(sp)
    80006238:	e44e                	sd	s3,8(sp)
    8000623a:	e052                	sd	s4,0(sp)
    8000623c:	1800                	addi	s0,sp,48
    8000623e:	89aa                	mv	s3,a0
  acquire(&uart_tx_lock);
    80006240:	0002a517          	auipc	a0,0x2a
    80006244:	b6850513          	addi	a0,a0,-1176 # 8002fda8 <uart_tx_lock>
    80006248:	00000097          	auipc	ra,0x0
    8000624c:	1a4080e7          	jalr	420(ra) # 800063ec <acquire>
  if(panicked){
    80006250:	00002797          	auipc	a5,0x2
    80006254:	70c7a783          	lw	a5,1804(a5) # 8000895c <panicked>
    80006258:	e7c9                	bnez	a5,800062e2 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000625a:	00002797          	auipc	a5,0x2
    8000625e:	70e7b783          	ld	a5,1806(a5) # 80008968 <uart_tx_w>
    80006262:	00002717          	auipc	a4,0x2
    80006266:	6fe73703          	ld	a4,1790(a4) # 80008960 <uart_tx_r>
    8000626a:	02070713          	addi	a4,a4,32
    sleep(&uart_tx_r, &uart_tx_lock);
    8000626e:	0002aa17          	auipc	s4,0x2a
    80006272:	b3aa0a13          	addi	s4,s4,-1222 # 8002fda8 <uart_tx_lock>
    80006276:	00002497          	auipc	s1,0x2
    8000627a:	6ea48493          	addi	s1,s1,1770 # 80008960 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000627e:	00002917          	auipc	s2,0x2
    80006282:	6ea90913          	addi	s2,s2,1770 # 80008968 <uart_tx_w>
    80006286:	00f71f63          	bne	a4,a5,800062a4 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    8000628a:	85d2                	mv	a1,s4
    8000628c:	8526                	mv	a0,s1
    8000628e:	ffffb097          	auipc	ra,0xffffb
    80006292:	278080e7          	jalr	632(ra) # 80001506 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006296:	00093783          	ld	a5,0(s2)
    8000629a:	6098                	ld	a4,0(s1)
    8000629c:	02070713          	addi	a4,a4,32
    800062a0:	fef705e3          	beq	a4,a5,8000628a <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800062a4:	0002a497          	auipc	s1,0x2a
    800062a8:	b0448493          	addi	s1,s1,-1276 # 8002fda8 <uart_tx_lock>
    800062ac:	01f7f713          	andi	a4,a5,31
    800062b0:	9726                	add	a4,a4,s1
    800062b2:	01370c23          	sb	s3,24(a4)
  uart_tx_w += 1;
    800062b6:	0785                	addi	a5,a5,1
    800062b8:	00002717          	auipc	a4,0x2
    800062bc:	6af73823          	sd	a5,1712(a4) # 80008968 <uart_tx_w>
  uartstart();
    800062c0:	00000097          	auipc	ra,0x0
    800062c4:	ee4080e7          	jalr	-284(ra) # 800061a4 <uartstart>
  release(&uart_tx_lock);
    800062c8:	8526                	mv	a0,s1
    800062ca:	00000097          	auipc	ra,0x0
    800062ce:	1d6080e7          	jalr	470(ra) # 800064a0 <release>
}
    800062d2:	70a2                	ld	ra,40(sp)
    800062d4:	7402                	ld	s0,32(sp)
    800062d6:	64e2                	ld	s1,24(sp)
    800062d8:	6942                	ld	s2,16(sp)
    800062da:	69a2                	ld	s3,8(sp)
    800062dc:	6a02                	ld	s4,0(sp)
    800062de:	6145                	addi	sp,sp,48
    800062e0:	8082                	ret
    for(;;)
    800062e2:	a001                	j	800062e2 <uartputc+0xb4>

00000000800062e4 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800062e4:	1141                	addi	sp,sp,-16
    800062e6:	e422                	sd	s0,8(sp)
    800062e8:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800062ea:	100007b7          	lui	a5,0x10000
    800062ee:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800062f2:	8b85                	andi	a5,a5,1
    800062f4:	cb91                	beqz	a5,80006308 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    800062f6:	100007b7          	lui	a5,0x10000
    800062fa:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    800062fe:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    80006302:	6422                	ld	s0,8(sp)
    80006304:	0141                	addi	sp,sp,16
    80006306:	8082                	ret
    return -1;
    80006308:	557d                	li	a0,-1
    8000630a:	bfe5                	j	80006302 <uartgetc+0x1e>

000000008000630c <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    8000630c:	1101                	addi	sp,sp,-32
    8000630e:	ec06                	sd	ra,24(sp)
    80006310:	e822                	sd	s0,16(sp)
    80006312:	e426                	sd	s1,8(sp)
    80006314:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80006316:	54fd                	li	s1,-1
    int c = uartgetc();
    80006318:	00000097          	auipc	ra,0x0
    8000631c:	fcc080e7          	jalr	-52(ra) # 800062e4 <uartgetc>
    if(c == -1)
    80006320:	00950763          	beq	a0,s1,8000632e <uartintr+0x22>
      break;
    consoleintr(c);
    80006324:	00000097          	auipc	ra,0x0
    80006328:	8fe080e7          	jalr	-1794(ra) # 80005c22 <consoleintr>
  while(1){
    8000632c:	b7f5                	j	80006318 <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    8000632e:	0002a497          	auipc	s1,0x2a
    80006332:	a7a48493          	addi	s1,s1,-1414 # 8002fda8 <uart_tx_lock>
    80006336:	8526                	mv	a0,s1
    80006338:	00000097          	auipc	ra,0x0
    8000633c:	0b4080e7          	jalr	180(ra) # 800063ec <acquire>
  uartstart();
    80006340:	00000097          	auipc	ra,0x0
    80006344:	e64080e7          	jalr	-412(ra) # 800061a4 <uartstart>
  release(&uart_tx_lock);
    80006348:	8526                	mv	a0,s1
    8000634a:	00000097          	auipc	ra,0x0
    8000634e:	156080e7          	jalr	342(ra) # 800064a0 <release>
}
    80006352:	60e2                	ld	ra,24(sp)
    80006354:	6442                	ld	s0,16(sp)
    80006356:	64a2                	ld	s1,8(sp)
    80006358:	6105                	addi	sp,sp,32
    8000635a:	8082                	ret

000000008000635c <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    8000635c:	1141                	addi	sp,sp,-16
    8000635e:	e422                	sd	s0,8(sp)
    80006360:	0800                	addi	s0,sp,16
  lk->name = name;
    80006362:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80006364:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80006368:	00053823          	sd	zero,16(a0)
}
    8000636c:	6422                	ld	s0,8(sp)
    8000636e:	0141                	addi	sp,sp,16
    80006370:	8082                	ret

0000000080006372 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80006372:	411c                	lw	a5,0(a0)
    80006374:	e399                	bnez	a5,8000637a <holding+0x8>
    80006376:	4501                	li	a0,0
  return r;
}
    80006378:	8082                	ret
{
    8000637a:	1101                	addi	sp,sp,-32
    8000637c:	ec06                	sd	ra,24(sp)
    8000637e:	e822                	sd	s0,16(sp)
    80006380:	e426                	sd	s1,8(sp)
    80006382:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80006384:	6904                	ld	s1,16(a0)
    80006386:	ffffb097          	auipc	ra,0xffffb
    8000638a:	ac0080e7          	jalr	-1344(ra) # 80000e46 <mycpu>
    8000638e:	40a48533          	sub	a0,s1,a0
    80006392:	00153513          	seqz	a0,a0
}
    80006396:	60e2                	ld	ra,24(sp)
    80006398:	6442                	ld	s0,16(sp)
    8000639a:	64a2                	ld	s1,8(sp)
    8000639c:	6105                	addi	sp,sp,32
    8000639e:	8082                	ret

00000000800063a0 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    800063a0:	1101                	addi	sp,sp,-32
    800063a2:	ec06                	sd	ra,24(sp)
    800063a4:	e822                	sd	s0,16(sp)
    800063a6:	e426                	sd	s1,8(sp)
    800063a8:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800063aa:	100024f3          	csrr	s1,sstatus
    800063ae:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800063b2:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800063b4:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    800063b8:	ffffb097          	auipc	ra,0xffffb
    800063bc:	a8e080e7          	jalr	-1394(ra) # 80000e46 <mycpu>
    800063c0:	5d3c                	lw	a5,120(a0)
    800063c2:	cf89                	beqz	a5,800063dc <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800063c4:	ffffb097          	auipc	ra,0xffffb
    800063c8:	a82080e7          	jalr	-1406(ra) # 80000e46 <mycpu>
    800063cc:	5d3c                	lw	a5,120(a0)
    800063ce:	2785                	addiw	a5,a5,1
    800063d0:	dd3c                	sw	a5,120(a0)
}
    800063d2:	60e2                	ld	ra,24(sp)
    800063d4:	6442                	ld	s0,16(sp)
    800063d6:	64a2                	ld	s1,8(sp)
    800063d8:	6105                	addi	sp,sp,32
    800063da:	8082                	ret
    mycpu()->intena = old;
    800063dc:	ffffb097          	auipc	ra,0xffffb
    800063e0:	a6a080e7          	jalr	-1430(ra) # 80000e46 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800063e4:	8085                	srli	s1,s1,0x1
    800063e6:	8885                	andi	s1,s1,1
    800063e8:	dd64                	sw	s1,124(a0)
    800063ea:	bfe9                	j	800063c4 <push_off+0x24>

00000000800063ec <acquire>:
{
    800063ec:	1101                	addi	sp,sp,-32
    800063ee:	ec06                	sd	ra,24(sp)
    800063f0:	e822                	sd	s0,16(sp)
    800063f2:	e426                	sd	s1,8(sp)
    800063f4:	1000                	addi	s0,sp,32
    800063f6:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800063f8:	00000097          	auipc	ra,0x0
    800063fc:	fa8080e7          	jalr	-88(ra) # 800063a0 <push_off>
  if(holding(lk))
    80006400:	8526                	mv	a0,s1
    80006402:	00000097          	auipc	ra,0x0
    80006406:	f70080e7          	jalr	-144(ra) # 80006372 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000640a:	4705                	li	a4,1
  if(holding(lk))
    8000640c:	e115                	bnez	a0,80006430 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000640e:	87ba                	mv	a5,a4
    80006410:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80006414:	2781                	sext.w	a5,a5
    80006416:	ffe5                	bnez	a5,8000640e <acquire+0x22>
  __sync_synchronize();
    80006418:	0ff0000f          	fence
  lk->cpu = mycpu();
    8000641c:	ffffb097          	auipc	ra,0xffffb
    80006420:	a2a080e7          	jalr	-1494(ra) # 80000e46 <mycpu>
    80006424:	e888                	sd	a0,16(s1)
}
    80006426:	60e2                	ld	ra,24(sp)
    80006428:	6442                	ld	s0,16(sp)
    8000642a:	64a2                	ld	s1,8(sp)
    8000642c:	6105                	addi	sp,sp,32
    8000642e:	8082                	ret
    panic("acquire");
    80006430:	00002517          	auipc	a0,0x2
    80006434:	46850513          	addi	a0,a0,1128 # 80008898 <digits+0x20>
    80006438:	00000097          	auipc	ra,0x0
    8000643c:	a6a080e7          	jalr	-1430(ra) # 80005ea2 <panic>

0000000080006440 <pop_off>:

void
pop_off(void)
{
    80006440:	1141                	addi	sp,sp,-16
    80006442:	e406                	sd	ra,8(sp)
    80006444:	e022                	sd	s0,0(sp)
    80006446:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80006448:	ffffb097          	auipc	ra,0xffffb
    8000644c:	9fe080e7          	jalr	-1538(ra) # 80000e46 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006450:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80006454:	8b89                	andi	a5,a5,2
  if(intr_get())
    80006456:	e78d                	bnez	a5,80006480 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80006458:	5d3c                	lw	a5,120(a0)
    8000645a:	02f05b63          	blez	a5,80006490 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    8000645e:	37fd                	addiw	a5,a5,-1
    80006460:	0007871b          	sext.w	a4,a5
    80006464:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80006466:	eb09                	bnez	a4,80006478 <pop_off+0x38>
    80006468:	5d7c                	lw	a5,124(a0)
    8000646a:	c799                	beqz	a5,80006478 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000646c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006470:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006474:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80006478:	60a2                	ld	ra,8(sp)
    8000647a:	6402                	ld	s0,0(sp)
    8000647c:	0141                	addi	sp,sp,16
    8000647e:	8082                	ret
    panic("pop_off - interruptible");
    80006480:	00002517          	auipc	a0,0x2
    80006484:	42050513          	addi	a0,a0,1056 # 800088a0 <digits+0x28>
    80006488:	00000097          	auipc	ra,0x0
    8000648c:	a1a080e7          	jalr	-1510(ra) # 80005ea2 <panic>
    panic("pop_off");
    80006490:	00002517          	auipc	a0,0x2
    80006494:	42850513          	addi	a0,a0,1064 # 800088b8 <digits+0x40>
    80006498:	00000097          	auipc	ra,0x0
    8000649c:	a0a080e7          	jalr	-1526(ra) # 80005ea2 <panic>

00000000800064a0 <release>:
{
    800064a0:	1101                	addi	sp,sp,-32
    800064a2:	ec06                	sd	ra,24(sp)
    800064a4:	e822                	sd	s0,16(sp)
    800064a6:	e426                	sd	s1,8(sp)
    800064a8:	1000                	addi	s0,sp,32
    800064aa:	84aa                	mv	s1,a0
  if(!holding(lk))
    800064ac:	00000097          	auipc	ra,0x0
    800064b0:	ec6080e7          	jalr	-314(ra) # 80006372 <holding>
    800064b4:	c115                	beqz	a0,800064d8 <release+0x38>
  lk->cpu = 0;
    800064b6:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800064ba:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    800064be:	0f50000f          	fence	iorw,ow
    800064c2:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    800064c6:	00000097          	auipc	ra,0x0
    800064ca:	f7a080e7          	jalr	-134(ra) # 80006440 <pop_off>
}
    800064ce:	60e2                	ld	ra,24(sp)
    800064d0:	6442                	ld	s0,16(sp)
    800064d2:	64a2                	ld	s1,8(sp)
    800064d4:	6105                	addi	sp,sp,32
    800064d6:	8082                	ret
    panic("release");
    800064d8:	00002517          	auipc	a0,0x2
    800064dc:	3e850513          	addi	a0,a0,1000 # 800088c0 <digits+0x48>
    800064e0:	00000097          	auipc	ra,0x0
    800064e4:	9c2080e7          	jalr	-1598(ra) # 80005ea2 <panic>
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
