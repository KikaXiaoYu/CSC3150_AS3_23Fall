
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	98013103          	ld	sp,-1664(sp) # 80008980 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	217050ef          	jal	ra,80005a2c <start>

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
    80000034:	e1078793          	addi	a5,a5,-496 # 80033e40 <end>
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
    80000054:	98090913          	addi	s2,s2,-1664 # 800089d0 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	3d2080e7          	jalr	978(ra) # 8000642c <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	472080e7          	jalr	1138(ra) # 800064e0 <release>
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
    8000008e:	e58080e7          	jalr	-424(ra) # 80005ee2 <panic>

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
    800000f0:	8e450513          	addi	a0,a0,-1820 # 800089d0 <kmem>
    800000f4:	00006097          	auipc	ra,0x6
    800000f8:	2a8080e7          	jalr	680(ra) # 8000639c <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fc:	45c5                	li	a1,17
    800000fe:	05ee                	slli	a1,a1,0x1b
    80000100:	00034517          	auipc	a0,0x34
    80000104:	d4050513          	addi	a0,a0,-704 # 80033e40 <end>
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
    80000126:	8ae48493          	addi	s1,s1,-1874 # 800089d0 <kmem>
    8000012a:	8526                	mv	a0,s1
    8000012c:	00006097          	auipc	ra,0x6
    80000130:	300080e7          	jalr	768(ra) # 8000642c <acquire>
  r = kmem.freelist;
    80000134:	6c84                	ld	s1,24(s1)
  if(r)
    80000136:	c885                	beqz	s1,80000166 <kalloc+0x4e>
    kmem.freelist = r->next;
    80000138:	609c                	ld	a5,0(s1)
    8000013a:	00009517          	auipc	a0,0x9
    8000013e:	89650513          	addi	a0,a0,-1898 # 800089d0 <kmem>
    80000142:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000144:	00006097          	auipc	ra,0x6
    80000148:	39c080e7          	jalr	924(ra) # 800064e0 <release>

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
    8000016a:	86a50513          	addi	a0,a0,-1942 # 800089d0 <kmem>
    8000016e:	00006097          	auipc	ra,0x6
    80000172:	372080e7          	jalr	882(ra) # 800064e0 <release>
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
    8000033a:	66a70713          	addi	a4,a4,1642 # 800089a0 <started>
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
    80000360:	bd0080e7          	jalr	-1072(ra) # 80005f2c <printf>
    kvminithart();    // turn on paging
    80000364:	00000097          	auipc	ra,0x0
    80000368:	0d8080e7          	jalr	216(ra) # 8000043c <kvminithart>
    trapinithart();   // install kernel trap vector
    8000036c:	00001097          	auipc	ra,0x1
    80000370:	78e080e7          	jalr	1934(ra) # 80001afa <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000374:	00005097          	auipc	ra,0x5
    80000378:	00c080e7          	jalr	12(ra) # 80005380 <plicinithart>
  }

  scheduler();        
    8000037c:	00001097          	auipc	ra,0x1
    80000380:	fd8080e7          	jalr	-40(ra) # 80001354 <scheduler>
    consoleinit();
    80000384:	00006097          	auipc	ra,0x6
    80000388:	a70080e7          	jalr	-1424(ra) # 80005df4 <consoleinit>
    printfinit();
    8000038c:	00006097          	auipc	ra,0x6
    80000390:	d86080e7          	jalr	-634(ra) # 80006112 <printfinit>
    printf("\n");
    80000394:	00008517          	auipc	a0,0x8
    80000398:	fc450513          	addi	a0,a0,-60 # 80008358 <states.1738+0x118>
    8000039c:	00006097          	auipc	ra,0x6
    800003a0:	b90080e7          	jalr	-1136(ra) # 80005f2c <printf>
    printf("xv6 kernel is booting\n");
    800003a4:	00008517          	auipc	a0,0x8
    800003a8:	c7c50513          	addi	a0,a0,-900 # 80008020 <etext+0x20>
    800003ac:	00006097          	auipc	ra,0x6
    800003b0:	b80080e7          	jalr	-1152(ra) # 80005f2c <printf>
    printf("\n");
    800003b4:	00008517          	auipc	a0,0x8
    800003b8:	fa450513          	addi	a0,a0,-92 # 80008358 <states.1738+0x118>
    800003bc:	00006097          	auipc	ra,0x6
    800003c0:	b70080e7          	jalr	-1168(ra) # 80005f2c <printf>
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
    800003f8:	f76080e7          	jalr	-138(ra) # 8000536a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003fc:	00005097          	auipc	ra,0x5
    80000400:	f84080e7          	jalr	-124(ra) # 80005380 <plicinithart>
    binit();         // buffer cache
    80000404:	00002097          	auipc	ra,0x2
    80000408:	f7e080e7          	jalr	-130(ra) # 80002382 <binit>
    iinit();         // inode table
    8000040c:	00002097          	auipc	ra,0x2
    80000410:	622080e7          	jalr	1570(ra) # 80002a2e <iinit>
    fileinit();      // file table
    80000414:	00003097          	auipc	ra,0x3
    80000418:	5c0080e7          	jalr	1472(ra) # 800039d4 <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000041c:	00005097          	auipc	ra,0x5
    80000420:	06c080e7          	jalr	108(ra) # 80005488 <virtio_disk_init>
    userinit();      // first user process
    80000424:	00001097          	auipc	ra,0x1
    80000428:	d16080e7          	jalr	-746(ra) # 8000113a <userinit>
    __sync_synchronize();
    8000042c:	0ff0000f          	fence
    started = 1;
    80000430:	4785                	li	a5,1
    80000432:	00008717          	auipc	a4,0x8
    80000436:	56f72723          	sw	a5,1390(a4) # 800089a0 <started>
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
    8000044a:	5627b783          	ld	a5,1378(a5) # 800089a8 <kernel_pagetable>
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
    80000496:	a50080e7          	jalr	-1456(ra) # 80005ee2 <panic>
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
    8000058e:	958080e7          	jalr	-1704(ra) # 80005ee2 <panic>
            printf("[Testing] : pte: %d\n", pte);
    80000592:	85aa                	mv	a1,a0
    80000594:	00008517          	auipc	a0,0x8
    80000598:	ad450513          	addi	a0,a0,-1324 # 80008068 <etext+0x68>
    8000059c:	00006097          	auipc	ra,0x6
    800005a0:	990080e7          	jalr	-1648(ra) # 80005f2c <printf>
            printf("[Testing] : PTE_V: %d\n", PTE_V);
    800005a4:	4585                	li	a1,1
    800005a6:	00008517          	auipc	a0,0x8
    800005aa:	ada50513          	addi	a0,a0,-1318 # 80008080 <etext+0x80>
    800005ae:	00006097          	auipc	ra,0x6
    800005b2:	97e080e7          	jalr	-1666(ra) # 80005f2c <printf>
            panic("mappages: remap");
    800005b6:	00008517          	auipc	a0,0x8
    800005ba:	ae250513          	addi	a0,a0,-1310 # 80008098 <etext+0x98>
    800005be:	00006097          	auipc	ra,0x6
    800005c2:	924080e7          	jalr	-1756(ra) # 80005ee2 <panic>
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
    8000063c:	8aa080e7          	jalr	-1878(ra) # 80005ee2 <panic>

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
    8000072a:	28a7b123          	sd	a0,642(a5) # 800089a8 <kernel_pagetable>
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
    80000788:	75e080e7          	jalr	1886(ra) # 80005ee2 <panic>
            panic("uvmunmap: walk");
    8000078c:	00008517          	auipc	a0,0x8
    80000790:	93c50513          	addi	a0,a0,-1732 # 800080c8 <etext+0xc8>
    80000794:	00005097          	auipc	ra,0x5
    80000798:	74e080e7          	jalr	1870(ra) # 80005ee2 <panic>
            panic("uvmunmap: not a leaf");
    8000079c:	00008517          	auipc	a0,0x8
    800007a0:	93c50513          	addi	a0,a0,-1732 # 800080d8 <etext+0xd8>
    800007a4:	00005097          	auipc	ra,0x5
    800007a8:	73e080e7          	jalr	1854(ra) # 80005ee2 <panic>
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
    80000888:	65e080e7          	jalr	1630(ra) # 80005ee2 <panic>

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
    800009d2:	514080e7          	jalr	1300(ra) # 80005ee2 <panic>
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
    80000a56:	490080e7          	jalr	1168(ra) # 80005ee2 <panic>
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
    80000b1c:	3ca080e7          	jalr	970(ra) # 80005ee2 <panic>

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
    80000d06:	11e48493          	addi	s1,s1,286 # 80008e20 <proc>
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
    80000d20:	b04a0a13          	addi	s4,s4,-1276 # 80020820 <tickslock>
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
    80000d7e:	168080e7          	jalr	360(ra) # 80005ee2 <panic>

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
    80000da2:	c5250513          	addi	a0,a0,-942 # 800089f0 <pid_lock>
    80000da6:	00005097          	auipc	ra,0x5
    80000daa:	5f6080e7          	jalr	1526(ra) # 8000639c <initlock>
    initlock(&wait_lock, "wait_lock");
    80000dae:	00007597          	auipc	a1,0x7
    80000db2:	3b258593          	addi	a1,a1,946 # 80008160 <etext+0x160>
    80000db6:	00008517          	auipc	a0,0x8
    80000dba:	c5250513          	addi	a0,a0,-942 # 80008a08 <wait_lock>
    80000dbe:	00005097          	auipc	ra,0x5
    80000dc2:	5de080e7          	jalr	1502(ra) # 8000639c <initlock>
    for (p = proc; p < &proc[NPROC]; p++)
    80000dc6:	00008497          	auipc	s1,0x8
    80000dca:	05a48493          	addi	s1,s1,90 # 80008e20 <proc>
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
    80000dec:	a3898993          	addi	s3,s3,-1480 # 80020820 <tickslock>
        initlock(&p->lock, "proc");
    80000df0:	85da                	mv	a1,s6
    80000df2:	8526                	mv	a0,s1
    80000df4:	00005097          	auipc	ra,0x5
    80000df8:	5a8080e7          	jalr	1448(ra) # 8000639c <initlock>
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
    80000e56:	bce50513          	addi	a0,a0,-1074 # 80008a20 <cpus>
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
    80000e70:	574080e7          	jalr	1396(ra) # 800063e0 <push_off>
    80000e74:	8792                	mv	a5,tp
    struct cpu *c = mycpu();
    struct proc *p = c->proc;
    80000e76:	2781                	sext.w	a5,a5
    80000e78:	079e                	slli	a5,a5,0x7
    80000e7a:	00008717          	auipc	a4,0x8
    80000e7e:	b7670713          	addi	a4,a4,-1162 # 800089f0 <pid_lock>
    80000e82:	97ba                	add	a5,a5,a4
    80000e84:	7b84                	ld	s1,48(a5)
    pop_off();
    80000e86:	00005097          	auipc	ra,0x5
    80000e8a:	5fa080e7          	jalr	1530(ra) # 80006480 <pop_off>
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
    80000eae:	636080e7          	jalr	1590(ra) # 800064e0 <release>

    if (first)
    80000eb2:	00008797          	auipc	a5,0x8
    80000eb6:	a7e7a783          	lw	a5,-1410(a5) # 80008930 <first.1694>
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
    80000ed0:	a607a223          	sw	zero,-1436(a5) # 80008930 <first.1694>
        fsinit(ROOTDEV);
    80000ed4:	4505                	li	a0,1
    80000ed6:	00002097          	auipc	ra,0x2
    80000eda:	ad8080e7          	jalr	-1320(ra) # 800029ae <fsinit>
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
    80000ef0:	b0490913          	addi	s2,s2,-1276 # 800089f0 <pid_lock>
    80000ef4:	854a                	mv	a0,s2
    80000ef6:	00005097          	auipc	ra,0x5
    80000efa:	536080e7          	jalr	1334(ra) # 8000642c <acquire>
    pid = nextpid;
    80000efe:	00008797          	auipc	a5,0x8
    80000f02:	a3678793          	addi	a5,a5,-1482 # 80008934 <nextpid>
    80000f06:	4384                	lw	s1,0(a5)
    nextpid = nextpid + 1;
    80000f08:	0014871b          	addiw	a4,s1,1
    80000f0c:	c398                	sw	a4,0(a5)
    release(&pid_lock);
    80000f0e:	854a                	mv	a0,s2
    80000f10:	00005097          	auipc	ra,0x5
    80000f14:	5d0080e7          	jalr	1488(ra) # 800064e0 <release>
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
    8000107c:	da848493          	addi	s1,s1,-600 # 80008e20 <proc>
    80001080:	0001f917          	auipc	s2,0x1f
    80001084:	7a090913          	addi	s2,s2,1952 # 80020820 <tickslock>
        acquire(&p->lock);
    80001088:	8526                	mv	a0,s1
    8000108a:	00005097          	auipc	ra,0x5
    8000108e:	3a2080e7          	jalr	930(ra) # 8000642c <acquire>
        if (p->state == UNUSED)
    80001092:	4c9c                	lw	a5,24(s1)
    80001094:	cf81                	beqz	a5,800010ac <allocproc+0x40>
            release(&p->lock);
    80001096:	8526                	mv	a0,s1
    80001098:	00005097          	auipc	ra,0x5
    8000109c:	448080e7          	jalr	1096(ra) # 800064e0 <release>
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
    8000111a:	3ca080e7          	jalr	970(ra) # 800064e0 <release>
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
    80001132:	3b2080e7          	jalr	946(ra) # 800064e0 <release>
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
    80001152:	86a7b123          	sd	a0,-1950(a5) # 800089b0 <initproc>
    uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001156:	03400613          	li	a2,52
    8000115a:	00007597          	auipc	a1,0x7
    8000115e:	7e658593          	addi	a1,a1,2022 # 80008940 <initcode>
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
    8000119c:	238080e7          	jalr	568(ra) # 800033d0 <namei>
    800011a0:	14a4b823          	sd	a0,336(s1)
    p->state = RUNNABLE;
    800011a4:	478d                	li	a5,3
    800011a6:	cc9c                	sw	a5,24(s1)
    release(&p->lock);
    800011a8:	8526                	mv	a0,s1
    800011aa:	00005097          	auipc	ra,0x5
    800011ae:	336080e7          	jalr	822(ra) # 800064e0 <release>
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
    800012ae:	236080e7          	jalr	566(ra) # 800064e0 <release>
        return -1;
    800012b2:	5a7d                	li	s4,-1
    800012b4:	a069                	j	8000133e <fork+0x126>
            np->ofile[i] = filedup(p->ofile[i]);
    800012b6:	00002097          	auipc	ra,0x2
    800012ba:	7b0080e7          	jalr	1968(ra) # 80003a66 <filedup>
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
    800012dc:	914080e7          	jalr	-1772(ra) # 80002bec <idup>
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
    80001300:	1e4080e7          	jalr	484(ra) # 800064e0 <release>
    acquire(&wait_lock);
    80001304:	00007497          	auipc	s1,0x7
    80001308:	70448493          	addi	s1,s1,1796 # 80008a08 <wait_lock>
    8000130c:	8526                	mv	a0,s1
    8000130e:	00005097          	auipc	ra,0x5
    80001312:	11e080e7          	jalr	286(ra) # 8000642c <acquire>
    np->parent = p;
    80001316:	0329bc23          	sd	s2,56(s3)
    release(&wait_lock);
    8000131a:	8526                	mv	a0,s1
    8000131c:	00005097          	auipc	ra,0x5
    80001320:	1c4080e7          	jalr	452(ra) # 800064e0 <release>
    acquire(&np->lock);
    80001324:	854e                	mv	a0,s3
    80001326:	00005097          	auipc	ra,0x5
    8000132a:	106080e7          	jalr	262(ra) # 8000642c <acquire>
    np->state = RUNNABLE;
    8000132e:	478d                	li	a5,3
    80001330:	00f9ac23          	sw	a5,24(s3)
    release(&np->lock);
    80001334:	854e                	mv	a0,s3
    80001336:	00005097          	auipc	ra,0x5
    8000133a:	1aa080e7          	jalr	426(ra) # 800064e0 <release>
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
    80001374:	68070713          	addi	a4,a4,1664 # 800089f0 <pid_lock>
    80001378:	9756                	add	a4,a4,s5
    8000137a:	02073823          	sd	zero,48(a4)
                swtch(&c->context, &p->context);
    8000137e:	00007717          	auipc	a4,0x7
    80001382:	6aa70713          	addi	a4,a4,1706 # 80008a28 <cpus+0x8>
    80001386:	9aba                	add	s5,s5,a4
            if (p->state == RUNNABLE)
    80001388:	498d                	li	s3,3
                p->state = RUNNING;
    8000138a:	4b11                	li	s6,4
                c->proc = p;
    8000138c:	079e                	slli	a5,a5,0x7
    8000138e:	00007a17          	auipc	s4,0x7
    80001392:	662a0a13          	addi	s4,s4,1634 # 800089f0 <pid_lock>
    80001396:	9a3e                	add	s4,s4,a5
        for (p = proc; p < &proc[NPROC]; p++)
    80001398:	0001f917          	auipc	s2,0x1f
    8000139c:	48890913          	addi	s2,s2,1160 # 80020820 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800013a0:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800013a4:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800013a8:	10079073          	csrw	sstatus,a5
    800013ac:	00008497          	auipc	s1,0x8
    800013b0:	a7448493          	addi	s1,s1,-1420 # 80008e20 <proc>
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
    800013d6:	10e080e7          	jalr	270(ra) # 800064e0 <release>
        for (p = proc; p < &proc[NPROC]; p++)
    800013da:	5e848493          	addi	s1,s1,1512
    800013de:	fd2481e3          	beq	s1,s2,800013a0 <scheduler+0x4c>
            acquire(&p->lock);
    800013e2:	8526                	mv	a0,s1
    800013e4:	00005097          	auipc	ra,0x5
    800013e8:	048080e7          	jalr	72(ra) # 8000642c <acquire>
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
    80001410:	fa6080e7          	jalr	-90(ra) # 800063b2 <holding>
    80001414:	c93d                	beqz	a0,8000148a <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001416:	8792                	mv	a5,tp
    if (mycpu()->noff != 1)
    80001418:	2781                	sext.w	a5,a5
    8000141a:	079e                	slli	a5,a5,0x7
    8000141c:	00007717          	auipc	a4,0x7
    80001420:	5d470713          	addi	a4,a4,1492 # 800089f0 <pid_lock>
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
    80001446:	5ae90913          	addi	s2,s2,1454 # 800089f0 <pid_lock>
    8000144a:	2781                	sext.w	a5,a5
    8000144c:	079e                	slli	a5,a5,0x7
    8000144e:	97ca                	add	a5,a5,s2
    80001450:	0ac7a983          	lw	s3,172(a5)
    80001454:	8792                	mv	a5,tp
    swtch(&p->context, &mycpu()->context);
    80001456:	2781                	sext.w	a5,a5
    80001458:	079e                	slli	a5,a5,0x7
    8000145a:	00007597          	auipc	a1,0x7
    8000145e:	5ce58593          	addi	a1,a1,1486 # 80008a28 <cpus+0x8>
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
    80001496:	a50080e7          	jalr	-1456(ra) # 80005ee2 <panic>
        panic("sched locks");
    8000149a:	00007517          	auipc	a0,0x7
    8000149e:	d0650513          	addi	a0,a0,-762 # 800081a0 <etext+0x1a0>
    800014a2:	00005097          	auipc	ra,0x5
    800014a6:	a40080e7          	jalr	-1472(ra) # 80005ee2 <panic>
        panic("sched running");
    800014aa:	00007517          	auipc	a0,0x7
    800014ae:	d0650513          	addi	a0,a0,-762 # 800081b0 <etext+0x1b0>
    800014b2:	00005097          	auipc	ra,0x5
    800014b6:	a30080e7          	jalr	-1488(ra) # 80005ee2 <panic>
        panic("sched interruptible");
    800014ba:	00007517          	auipc	a0,0x7
    800014be:	d0650513          	addi	a0,a0,-762 # 800081c0 <etext+0x1c0>
    800014c2:	00005097          	auipc	ra,0x5
    800014c6:	a20080e7          	jalr	-1504(ra) # 80005ee2 <panic>

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
    800014e2:	f4e080e7          	jalr	-178(ra) # 8000642c <acquire>
    p->state = RUNNABLE;
    800014e6:	478d                	li	a5,3
    800014e8:	cc9c                	sw	a5,24(s1)
    sched();
    800014ea:	00000097          	auipc	ra,0x0
    800014ee:	f0a080e7          	jalr	-246(ra) # 800013f4 <sched>
    release(&p->lock);
    800014f2:	8526                	mv	a0,s1
    800014f4:	00005097          	auipc	ra,0x5
    800014f8:	fec080e7          	jalr	-20(ra) # 800064e0 <release>
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
    80001526:	f0a080e7          	jalr	-246(ra) # 8000642c <acquire>
    release(lk);
    8000152a:	854a                	mv	a0,s2
    8000152c:	00005097          	auipc	ra,0x5
    80001530:	fb4080e7          	jalr	-76(ra) # 800064e0 <release>

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
    8000154e:	f96080e7          	jalr	-106(ra) # 800064e0 <release>
    acquire(lk);
    80001552:	854a                	mv	a0,s2
    80001554:	00005097          	auipc	ra,0x5
    80001558:	ed8080e7          	jalr	-296(ra) # 8000642c <acquire>
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
    80001582:	8a248493          	addi	s1,s1,-1886 # 80008e20 <proc>
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
    8000158e:	29690913          	addi	s2,s2,662 # 80020820 <tickslock>
    80001592:	a821                	j	800015aa <wakeup+0x40>
                p->state = RUNNABLE;
    80001594:	0154ac23          	sw	s5,24(s1)
            }
            release(&p->lock);
    80001598:	8526                	mv	a0,s1
    8000159a:	00005097          	auipc	ra,0x5
    8000159e:	f46080e7          	jalr	-186(ra) # 800064e0 <release>
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
    800015bc:	e74080e7          	jalr	-396(ra) # 8000642c <acquire>
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
    800015f6:	82e48493          	addi	s1,s1,-2002 # 80008e20 <proc>
            pp->parent = initproc;
    800015fa:	00007a17          	auipc	s4,0x7
    800015fe:	3b6a0a13          	addi	s4,s4,950 # 800089b0 <initproc>
    for (pp = proc; pp < &proc[NPROC]; pp++)
    80001602:	0001f997          	auipc	s3,0x1f
    80001606:	21e98993          	addi	s3,s3,542 # 80020820 <tickslock>
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
    8000165a:	35a7b783          	ld	a5,858(a5) # 800089b0 <initproc>
    8000165e:	0d050493          	addi	s1,a0,208
    80001662:	15050913          	addi	s2,a0,336
    80001666:	02a79363          	bne	a5,a0,8000168c <exit+0x52>
        panic("init exiting");
    8000166a:	00007517          	auipc	a0,0x7
    8000166e:	b6e50513          	addi	a0,a0,-1170 # 800081d8 <etext+0x1d8>
    80001672:	00005097          	auipc	ra,0x5
    80001676:	870080e7          	jalr	-1936(ra) # 80005ee2 <panic>
            fileclose(f);
    8000167a:	00002097          	auipc	ra,0x2
    8000167e:	43e080e7          	jalr	1086(ra) # 80003ab8 <fileclose>
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
    80001696:	f5a080e7          	jalr	-166(ra) # 800035ec <begin_op>
    iput(p->cwd);
    8000169a:	1509b503          	ld	a0,336(s3)
    8000169e:	00001097          	auipc	ra,0x1
    800016a2:	746080e7          	jalr	1862(ra) # 80002de4 <iput>
    end_op();
    800016a6:	00002097          	auipc	ra,0x2
    800016aa:	fc6080e7          	jalr	-58(ra) # 8000366c <end_op>
    p->cwd = 0;
    800016ae:	1409b823          	sd	zero,336(s3)
    acquire(&wait_lock);
    800016b2:	00007497          	auipc	s1,0x7
    800016b6:	35648493          	addi	s1,s1,854 # 80008a08 <wait_lock>
    800016ba:	8526                	mv	a0,s1
    800016bc:	00005097          	auipc	ra,0x5
    800016c0:	d70080e7          	jalr	-656(ra) # 8000642c <acquire>
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
    800016e0:	d50080e7          	jalr	-688(ra) # 8000642c <acquire>
    p->xstate = status;
    800016e4:	0349a623          	sw	s4,44(s3)
    p->state = ZOMBIE;
    800016e8:	4795                	li	a5,5
    800016ea:	00f9ac23          	sw	a5,24(s3)
    release(&wait_lock);
    800016ee:	8526                	mv	a0,s1
    800016f0:	00005097          	auipc	ra,0x5
    800016f4:	df0080e7          	jalr	-528(ra) # 800064e0 <release>
    sched();
    800016f8:	00000097          	auipc	ra,0x0
    800016fc:	cfc080e7          	jalr	-772(ra) # 800013f4 <sched>
    panic("zombie exit");
    80001700:	00007517          	auipc	a0,0x7
    80001704:	ae850513          	addi	a0,a0,-1304 # 800081e8 <etext+0x1e8>
    80001708:	00004097          	auipc	ra,0x4
    8000170c:	7da080e7          	jalr	2010(ra) # 80005ee2 <panic>

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
    80001724:	70048493          	addi	s1,s1,1792 # 80008e20 <proc>
    80001728:	0001f997          	auipc	s3,0x1f
    8000172c:	0f898993          	addi	s3,s3,248 # 80020820 <tickslock>
    {
        acquire(&p->lock);
    80001730:	8526                	mv	a0,s1
    80001732:	00005097          	auipc	ra,0x5
    80001736:	cfa080e7          	jalr	-774(ra) # 8000642c <acquire>
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
    80001746:	d9e080e7          	jalr	-610(ra) # 800064e0 <release>
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
    80001768:	d7c080e7          	jalr	-644(ra) # 800064e0 <release>
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
    80001792:	c9e080e7          	jalr	-866(ra) # 8000642c <acquire>
    p->killed = 1;
    80001796:	4785                	li	a5,1
    80001798:	d49c                	sw	a5,40(s1)
    release(&p->lock);
    8000179a:	8526                	mv	a0,s1
    8000179c:	00005097          	auipc	ra,0x5
    800017a0:	d44080e7          	jalr	-700(ra) # 800064e0 <release>
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
    800017c0:	c70080e7          	jalr	-912(ra) # 8000642c <acquire>
    k = p->killed;
    800017c4:	0284a903          	lw	s2,40(s1)
    release(&p->lock);
    800017c8:	8526                	mv	a0,s1
    800017ca:	00005097          	auipc	ra,0x5
    800017ce:	d16080e7          	jalr	-746(ra) # 800064e0 <release>
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
    80001808:	20450513          	addi	a0,a0,516 # 80008a08 <wait_lock>
    8000180c:	00005097          	auipc	ra,0x5
    80001810:	c20080e7          	jalr	-992(ra) # 8000642c <acquire>
        havekids = 0;
    80001814:	4b81                	li	s7,0
                if (pp->state == ZOMBIE)
    80001816:	4a15                	li	s4,5
        for (pp = proc; pp < &proc[NPROC]; pp++)
    80001818:	0001f997          	auipc	s3,0x1f
    8000181c:	00898993          	addi	s3,s3,8 # 80020820 <tickslock>
                havekids = 1;
    80001820:	4a85                	li	s5,1
        sleep(p, &wait_lock); // DOC: wait-sleep
    80001822:	00007c17          	auipc	s8,0x7
    80001826:	1e6c0c13          	addi	s8,s8,486 # 80008a08 <wait_lock>
        havekids = 0;
    8000182a:	875e                	mv	a4,s7
        for (pp = proc; pp < &proc[NPROC]; pp++)
    8000182c:	00007497          	auipc	s1,0x7
    80001830:	5f448493          	addi	s1,s1,1524 # 80008e20 <proc>
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
    80001866:	c7e080e7          	jalr	-898(ra) # 800064e0 <release>
                    release(&wait_lock);
    8000186a:	00007517          	auipc	a0,0x7
    8000186e:	19e50513          	addi	a0,a0,414 # 80008a08 <wait_lock>
    80001872:	00005097          	auipc	ra,0x5
    80001876:	c6e080e7          	jalr	-914(ra) # 800064e0 <release>
                    return pid;
    8000187a:	a0b5                	j	800018e6 <wait+0x106>
                        release(&pp->lock);
    8000187c:	8526                	mv	a0,s1
    8000187e:	00005097          	auipc	ra,0x5
    80001882:	c62080e7          	jalr	-926(ra) # 800064e0 <release>
                        release(&wait_lock);
    80001886:	00007517          	auipc	a0,0x7
    8000188a:	18250513          	addi	a0,a0,386 # 80008a08 <wait_lock>
    8000188e:	00005097          	auipc	ra,0x5
    80001892:	c52080e7          	jalr	-942(ra) # 800064e0 <release>
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
    800018ae:	b82080e7          	jalr	-1150(ra) # 8000642c <acquire>
                if (pp->state == ZOMBIE)
    800018b2:	4c9c                	lw	a5,24(s1)
    800018b4:	f94781e3          	beq	a5,s4,80001836 <wait+0x56>
                release(&pp->lock);
    800018b8:	8526                	mv	a0,s1
    800018ba:	00005097          	auipc	ra,0x5
    800018be:	c26080e7          	jalr	-986(ra) # 800064e0 <release>
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
    800018d8:	13450513          	addi	a0,a0,308 # 80008a08 <wait_lock>
    800018dc:	00005097          	auipc	ra,0x5
    800018e0:	c04080e7          	jalr	-1020(ra) # 800064e0 <release>
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
    800019d0:	00007517          	auipc	a0,0x7
    800019d4:	98850513          	addi	a0,a0,-1656 # 80008358 <states.1738+0x118>
    800019d8:	00004097          	auipc	ra,0x4
    800019dc:	554080e7          	jalr	1364(ra) # 80005f2c <printf>
    for (p = proc; p < &proc[NPROC]; p++)
    800019e0:	00007497          	auipc	s1,0x7
    800019e4:	59848493          	addi	s1,s1,1432 # 80008f78 <proc+0x158>
    800019e8:	0001f917          	auipc	s2,0x1f
    800019ec:	f9090913          	addi	s2,s2,-112 # 80020978 <bcache+0x140>
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
    80001a02:	00007a17          	auipc	s4,0x7
    80001a06:	956a0a13          	addi	s4,s4,-1706 # 80008358 <states.1738+0x118>
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a0a:	00007b97          	auipc	s7,0x7
    80001a0e:	836b8b93          	addi	s7,s7,-1994 # 80008240 <states.1738>
    80001a12:	a00d                	j	80001a34 <procdump+0x7a>
        printf("%d %s %s", p->pid, state, p->name);
    80001a14:	ed86a583          	lw	a1,-296(a3)
    80001a18:	8556                	mv	a0,s5
    80001a1a:	00004097          	auipc	ra,0x4
    80001a1e:	512080e7          	jalr	1298(ra) # 80005f2c <printf>
        printf("\n");
    80001a22:	8552                	mv	a0,s4
    80001a24:	00004097          	auipc	ra,0x4
    80001a28:	508080e7          	jalr	1288(ra) # 80005f2c <printf>
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
    80001ae6:	d3e50513          	addi	a0,a0,-706 # 80020820 <tickslock>
    80001aea:	00005097          	auipc	ra,0x5
    80001aee:	8b2080e7          	jalr	-1870(ra) # 8000639c <initlock>
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
    80001b04:	7b078793          	addi	a5,a5,1968 # 800052b0 <kernelvec>
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
    80001bb6:	c6e48493          	addi	s1,s1,-914 # 80020820 <tickslock>
    80001bba:	8526                	mv	a0,s1
    80001bbc:	00005097          	auipc	ra,0x5
    80001bc0:	870080e7          	jalr	-1936(ra) # 8000642c <acquire>
    ticks++;
    80001bc4:	00007517          	auipc	a0,0x7
    80001bc8:	df450513          	addi	a0,a0,-524 # 800089b8 <ticks>
    80001bcc:	411c                	lw	a5,0(a0)
    80001bce:	2785                	addiw	a5,a5,1
    80001bd0:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    80001bd2:	00000097          	auipc	ra,0x0
    80001bd6:	998080e7          	jalr	-1640(ra) # 8000156a <wakeup>
    release(&tickslock);
    80001bda:	8526                	mv	a0,s1
    80001bdc:	00005097          	auipc	ra,0x5
    80001be0:	904080e7          	jalr	-1788(ra) # 800064e0 <release>
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
    80001c24:	798080e7          	jalr	1944(ra) # 800053b8 <plic_claim>
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
    80001c48:	2e8080e7          	jalr	744(ra) # 80005f2c <printf>
            plic_complete(irq);
    80001c4c:	8526                	mv	a0,s1
    80001c4e:	00003097          	auipc	ra,0x3
    80001c52:	78e080e7          	jalr	1934(ra) # 800053dc <plic_complete>
        return 1;
    80001c56:	4505                	li	a0,1
    80001c58:	bf55                	j	80001c0c <devintr+0x1e>
            uartintr();
    80001c5a:	00004097          	auipc	ra,0x4
    80001c5e:	6f2080e7          	jalr	1778(ra) # 8000634c <uartintr>
    80001c62:	b7ed                	j	80001c4c <devintr+0x5e>
            virtio_disk_intr();
    80001c64:	00004097          	auipc	ra,0x4
    80001c68:	ca2080e7          	jalr	-862(ra) # 80005906 <virtio_disk_intr>
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
    80001ca0:	0080                	addi	s0,sp,64
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ca2:	100027f3          	csrr	a5,sstatus
    if ((r_sstatus() & SSTATUS_SPP) != 0)
    80001ca6:	1007f793          	andi	a5,a5,256
    80001caa:	e7c1                	bnez	a5,80001d32 <usertrap+0xa2>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001cac:	00003797          	auipc	a5,0x3
    80001cb0:	60478793          	addi	a5,a5,1540 # 800052b0 <kernelvec>
    80001cb4:	10579073          	csrw	stvec,a5
    struct proc *p = myproc();
    80001cb8:	fffff097          	auipc	ra,0xfffff
    80001cbc:	1aa080e7          	jalr	426(ra) # 80000e62 <myproc>
    80001cc0:	892a                	mv	s2,a0
    p->trapframe->epc = r_sepc();
    80001cc2:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001cc4:	14102773          	csrr	a4,sepc
    80001cc8:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001cca:	14202773          	csrr	a4,scause
    if (r_scause() == 8)
    80001cce:	47a1                	li	a5,8
    80001cd0:	06f70963          	beq	a4,a5,80001d42 <usertrap+0xb2>
    else if ((which_dev = devintr()) != 0)
    80001cd4:	00000097          	auipc	ra,0x0
    80001cd8:	f1a080e7          	jalr	-230(ra) # 80001bee <devintr>
    80001cdc:	84aa                	mv	s1,a0
    80001cde:	1c051b63          	bnez	a0,80001eb4 <usertrap+0x224>
    80001ce2:	14202773          	csrr	a4,scause
    else if (r_scause() == 13 || r_scause() == 15)
    80001ce6:	47b5                	li	a5,13
    80001ce8:	0af70b63          	beq	a4,a5,80001d9e <usertrap+0x10e>
    80001cec:	14202773          	csrr	a4,scause
    80001cf0:	47bd                	li	a5,15
    80001cf2:	0af70663          	beq	a4,a5,80001d9e <usertrap+0x10e>
    80001cf6:	142025f3          	csrr	a1,scause
        printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001cfa:	03092603          	lw	a2,48(s2)
    80001cfe:	00006517          	auipc	a0,0x6
    80001d02:	68a50513          	addi	a0,a0,1674 # 80008388 <states.1738+0x148>
    80001d06:	00004097          	auipc	ra,0x4
    80001d0a:	226080e7          	jalr	550(ra) # 80005f2c <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d0e:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001d12:	14302673          	csrr	a2,stval
        printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001d16:	00006517          	auipc	a0,0x6
    80001d1a:	6a250513          	addi	a0,a0,1698 # 800083b8 <states.1738+0x178>
    80001d1e:	00004097          	auipc	ra,0x4
    80001d22:	20e080e7          	jalr	526(ra) # 80005f2c <printf>
        setkilled(p);
    80001d26:	854a                	mv	a0,s2
    80001d28:	00000097          	auipc	ra,0x0
    80001d2c:	a5a080e7          	jalr	-1446(ra) # 80001782 <setkilled>
    80001d30:	a82d                	j	80001d6a <usertrap+0xda>
        panic("usertrap: not from user mode");
    80001d32:	00006517          	auipc	a0,0x6
    80001d36:	56650513          	addi	a0,a0,1382 # 80008298 <states.1738+0x58>
    80001d3a:	00004097          	auipc	ra,0x4
    80001d3e:	1a8080e7          	jalr	424(ra) # 80005ee2 <panic>
        if (killed(p))
    80001d42:	00000097          	auipc	ra,0x0
    80001d46:	a6c080e7          	jalr	-1428(ra) # 800017ae <killed>
    80001d4a:	e521                	bnez	a0,80001d92 <usertrap+0x102>
        p->trapframe->epc += 4;
    80001d4c:	05893703          	ld	a4,88(s2)
    80001d50:	6f1c                	ld	a5,24(a4)
    80001d52:	0791                	addi	a5,a5,4
    80001d54:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d56:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001d5a:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d5e:	10079073          	csrw	sstatus,a5
        syscall();
    80001d62:	00000097          	auipc	ra,0x0
    80001d66:	3c6080e7          	jalr	966(ra) # 80002128 <syscall>
    if (killed(p))
    80001d6a:	854a                	mv	a0,s2
    80001d6c:	00000097          	auipc	ra,0x0
    80001d70:	a42080e7          	jalr	-1470(ra) # 800017ae <killed>
    80001d74:	14051763          	bnez	a0,80001ec2 <usertrap+0x232>
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
    80001d8e:	6121                	addi	sp,sp,64
    80001d90:	8082                	ret
            exit(-1);
    80001d92:	557d                	li	a0,-1
    80001d94:	00000097          	auipc	ra,0x0
    80001d98:	8a6080e7          	jalr	-1882(ra) # 8000163a <exit>
    80001d9c:	bf45                	j	80001d4c <usertrap+0xbc>
        struct proc *p_proc = myproc();
    80001d9e:	fffff097          	auipc	ra,0xfffff
    80001da2:	0c4080e7          	jalr	196(ra) # 80000e62 <myproc>
    80001da6:	8a2a                	mv	s4,a0
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001da8:	143029f3          	csrr	s3,stval
        for (int i = 0; i <= VMASIZE - 1; i++)
    80001dac:	16850793          	addi	a5,a0,360
            if (p_proc->vma[i].occupied == 1)
    80001db0:	4605                	li	a2,1
        for (int i = 0; i <= VMASIZE - 1; i++)
    80001db2:	45c1                	li	a1,16
    80001db4:	a031                	j	80001dc0 <usertrap+0x130>
    80001db6:	2485                	addiw	s1,s1,1
    80001db8:	04878793          	addi	a5,a5,72
    80001dbc:	0cb48e63          	beq	s1,a1,80001e98 <usertrap+0x208>
            if (p_proc->vma[i].occupied == 1)
    80001dc0:	4398                	lw	a4,0(a5)
    80001dc2:	fec71ae3          	bne	a4,a2,80001db6 <usertrap+0x126>
                if (p_proc->vma[i].start_addr <= va && va <= p_proc->vma[i].end_addr)
    80001dc6:	6798                	ld	a4,8(a5)
    80001dc8:	fee9e7e3          	bltu	s3,a4,80001db6 <usertrap+0x126>
    80001dcc:	6b98                	ld	a4,16(a5)
    80001dce:	ff3764e3          	bltu	a4,s3,80001db6 <usertrap+0x126>
            char *mem = (char *)kalloc();
    80001dd2:	ffffe097          	auipc	ra,0xffffe
    80001dd6:	346080e7          	jalr	838(ra) # 80000118 <kalloc>
    80001dda:	8aaa                	mv	s5,a0
            if (mem == 0)
    80001ddc:	c151                	beqz	a0,80001e60 <usertrap+0x1d0>
                memset(mem, 0, PGSIZE);
    80001dde:	6605                	lui	a2,0x1
    80001de0:	4581                	li	a1,0
    80001de2:	ffffe097          	auipc	ra,0xffffe
    80001de6:	396080e7          	jalr	918(ra) # 80000178 <memset>
                if (mappages(p_proc->pagetable, va, PGSIZE, (uint64)mem, (p_vma->prot | PTE_R | PTE_X | PTE_W | PTE_U)) == -1)
    80001dea:	00349793          	slli	a5,s1,0x3
    80001dee:	97a6                	add	a5,a5,s1
    80001df0:	078e                	slli	a5,a5,0x3
    80001df2:	97d2                	add	a5,a5,s4
    80001df4:	1907a703          	lw	a4,400(a5)
    80001df8:	01e76713          	ori	a4,a4,30
    80001dfc:	86d6                	mv	a3,s5
    80001dfe:	6605                	lui	a2,0x1
    80001e00:	85ce                	mv	a1,s3
    80001e02:	050a3503          	ld	a0,80(s4)
    80001e06:	ffffe097          	auipc	ra,0xffffe
    80001e0a:	746080e7          	jalr	1862(ra) # 8000054c <mappages>
    80001e0e:	57fd                	li	a5,-1
    80001e10:	06f50663          	beq	a0,a5,80001e7c <usertrap+0x1ec>
                    printf("[Testing] (trap) : mappages successfully!\n");
    80001e14:	00006517          	auipc	a0,0x6
    80001e18:	4f450513          	addi	a0,a0,1268 # 80008308 <states.1738+0xc8>
    80001e1c:	00004097          	auipc	ra,0x4
    80001e20:	110080e7          	jalr	272(ra) # 80005f2c <printf>
                    mapfile(p_vma->pf, mem, p_vma->offset + va - p_vma->start_addr);
    80001e24:	00349793          	slli	a5,s1,0x3
    80001e28:	00978733          	add	a4,a5,s1
    80001e2c:	070e                	slli	a4,a4,0x3
    80001e2e:	9752                	add	a4,a4,s4
    80001e30:	1a073683          	ld	a3,416(a4)
    80001e34:	013689bb          	addw	s3,a3,s3
    80001e38:	17073603          	ld	a2,368(a4)
    80001e3c:	40c9863b          	subw	a2,s3,a2
    80001e40:	85d6                	mv	a1,s5
    80001e42:	1a873503          	ld	a0,424(a4)
    80001e46:	00002097          	auipc	ra,0x2
    80001e4a:	dac080e7          	jalr	-596(ra) # 80003bf2 <mapfile>
                    printf("[Testing] (trap) : mapfile good!\n");
    80001e4e:	00006517          	auipc	a0,0x6
    80001e52:	4ea50513          	addi	a0,a0,1258 # 80008338 <states.1738+0xf8>
    80001e56:	00004097          	auipc	ra,0x4
    80001e5a:	0d6080e7          	jalr	214(ra) # 80005f2c <printf>
    80001e5e:	b731                	j	80001d6a <usertrap+0xda>
                printf("[Testing] (trap) : not enough mem\n");
    80001e60:	00006517          	auipc	a0,0x6
    80001e64:	45850513          	addi	a0,a0,1112 # 800082b8 <states.1738+0x78>
    80001e68:	00004097          	auipc	ra,0x4
    80001e6c:	0c4080e7          	jalr	196(ra) # 80005f2c <printf>
                setkilled(p_proc);
    80001e70:	8552                	mv	a0,s4
    80001e72:	00000097          	auipc	ra,0x0
    80001e76:	910080e7          	jalr	-1776(ra) # 80001782 <setkilled>
                return;
    80001e7a:	b719                	j	80001d80 <usertrap+0xf0>
                    printf("[Testing] (trap) : mappages failed!\n");
    80001e7c:	00006517          	auipc	a0,0x6
    80001e80:	46450513          	addi	a0,a0,1124 # 800082e0 <states.1738+0xa0>
    80001e84:	00004097          	auipc	ra,0x4
    80001e88:	0a8080e7          	jalr	168(ra) # 80005f2c <printf>
                    setkilled(p_proc);
    80001e8c:	8552                	mv	a0,s4
    80001e8e:	00000097          	auipc	ra,0x0
    80001e92:	8f4080e7          	jalr	-1804(ra) # 80001782 <setkilled>
    80001e96:	bdd1                	j	80001d6a <usertrap+0xda>
            setkilled(p_proc);
    80001e98:	8552                	mv	a0,s4
    80001e9a:	00000097          	auipc	ra,0x0
    80001e9e:	8e8080e7          	jalr	-1816(ra) # 80001782 <setkilled>
            printf("Now, after mmap, we get a page fault\n");
    80001ea2:	00006517          	auipc	a0,0x6
    80001ea6:	4be50513          	addi	a0,a0,1214 # 80008360 <states.1738+0x120>
    80001eaa:	00004097          	auipc	ra,0x4
    80001eae:	082080e7          	jalr	130(ra) # 80005f2c <printf>
            goto err;
    80001eb2:	b591                	j	80001cf6 <usertrap+0x66>
    if (killed(p))
    80001eb4:	854a                	mv	a0,s2
    80001eb6:	00000097          	auipc	ra,0x0
    80001eba:	8f8080e7          	jalr	-1800(ra) # 800017ae <killed>
    80001ebe:	c901                	beqz	a0,80001ece <usertrap+0x23e>
    80001ec0:	a011                	j	80001ec4 <usertrap+0x234>
    80001ec2:	4481                	li	s1,0
        exit(-1);
    80001ec4:	557d                	li	a0,-1
    80001ec6:	fffff097          	auipc	ra,0xfffff
    80001eca:	774080e7          	jalr	1908(ra) # 8000163a <exit>
    if (which_dev == 2)
    80001ece:	4789                	li	a5,2
    80001ed0:	eaf494e3          	bne	s1,a5,80001d78 <usertrap+0xe8>
        yield();
    80001ed4:	fffff097          	auipc	ra,0xfffff
    80001ed8:	5f6080e7          	jalr	1526(ra) # 800014ca <yield>
    80001edc:	bd71                	j	80001d78 <usertrap+0xe8>

0000000080001ede <kerneltrap>:
{
    80001ede:	7179                	addi	sp,sp,-48
    80001ee0:	f406                	sd	ra,40(sp)
    80001ee2:	f022                	sd	s0,32(sp)
    80001ee4:	ec26                	sd	s1,24(sp)
    80001ee6:	e84a                	sd	s2,16(sp)
    80001ee8:	e44e                	sd	s3,8(sp)
    80001eea:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001eec:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ef0:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001ef4:	142029f3          	csrr	s3,scause
    if ((sstatus & SSTATUS_SPP) == 0)
    80001ef8:	1004f793          	andi	a5,s1,256
    80001efc:	cb85                	beqz	a5,80001f2c <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001efe:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001f02:	8b89                	andi	a5,a5,2
    if (intr_get() != 0)
    80001f04:	ef85                	bnez	a5,80001f3c <kerneltrap+0x5e>
    if ((which_dev = devintr()) == 0)
    80001f06:	00000097          	auipc	ra,0x0
    80001f0a:	ce8080e7          	jalr	-792(ra) # 80001bee <devintr>
    80001f0e:	cd1d                	beqz	a0,80001f4c <kerneltrap+0x6e>
    if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001f10:	4789                	li	a5,2
    80001f12:	06f50a63          	beq	a0,a5,80001f86 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001f16:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001f1a:	10049073          	csrw	sstatus,s1
}
    80001f1e:	70a2                	ld	ra,40(sp)
    80001f20:	7402                	ld	s0,32(sp)
    80001f22:	64e2                	ld	s1,24(sp)
    80001f24:	6942                	ld	s2,16(sp)
    80001f26:	69a2                	ld	s3,8(sp)
    80001f28:	6145                	addi	sp,sp,48
    80001f2a:	8082                	ret
        panic("kerneltrap: not from supervisor mode");
    80001f2c:	00006517          	auipc	a0,0x6
    80001f30:	4ac50513          	addi	a0,a0,1196 # 800083d8 <states.1738+0x198>
    80001f34:	00004097          	auipc	ra,0x4
    80001f38:	fae080e7          	jalr	-82(ra) # 80005ee2 <panic>
        panic("kerneltrap: interrupts enabled");
    80001f3c:	00006517          	auipc	a0,0x6
    80001f40:	4c450513          	addi	a0,a0,1220 # 80008400 <states.1738+0x1c0>
    80001f44:	00004097          	auipc	ra,0x4
    80001f48:	f9e080e7          	jalr	-98(ra) # 80005ee2 <panic>
        printf("scause %p\n", scause);
    80001f4c:	85ce                	mv	a1,s3
    80001f4e:	00006517          	auipc	a0,0x6
    80001f52:	4d250513          	addi	a0,a0,1234 # 80008420 <states.1738+0x1e0>
    80001f56:	00004097          	auipc	ra,0x4
    80001f5a:	fd6080e7          	jalr	-42(ra) # 80005f2c <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f5e:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001f62:	14302673          	csrr	a2,stval
        printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001f66:	00006517          	auipc	a0,0x6
    80001f6a:	4ca50513          	addi	a0,a0,1226 # 80008430 <states.1738+0x1f0>
    80001f6e:	00004097          	auipc	ra,0x4
    80001f72:	fbe080e7          	jalr	-66(ra) # 80005f2c <printf>
        panic("kerneltrap");
    80001f76:	00006517          	auipc	a0,0x6
    80001f7a:	4d250513          	addi	a0,a0,1234 # 80008448 <states.1738+0x208>
    80001f7e:	00004097          	auipc	ra,0x4
    80001f82:	f64080e7          	jalr	-156(ra) # 80005ee2 <panic>
    if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001f86:	fffff097          	auipc	ra,0xfffff
    80001f8a:	edc080e7          	jalr	-292(ra) # 80000e62 <myproc>
    80001f8e:	d541                	beqz	a0,80001f16 <kerneltrap+0x38>
    80001f90:	fffff097          	auipc	ra,0xfffff
    80001f94:	ed2080e7          	jalr	-302(ra) # 80000e62 <myproc>
    80001f98:	4d18                	lw	a4,24(a0)
    80001f9a:	4791                	li	a5,4
    80001f9c:	f6f71de3          	bne	a4,a5,80001f16 <kerneltrap+0x38>
        yield();
    80001fa0:	fffff097          	auipc	ra,0xfffff
    80001fa4:	52a080e7          	jalr	1322(ra) # 800014ca <yield>
    80001fa8:	b7bd                	j	80001f16 <kerneltrap+0x38>

0000000080001faa <argraw>:
    return strlen(buf);
}

static uint64
argraw(int n)
{
    80001faa:	1101                	addi	sp,sp,-32
    80001fac:	ec06                	sd	ra,24(sp)
    80001fae:	e822                	sd	s0,16(sp)
    80001fb0:	e426                	sd	s1,8(sp)
    80001fb2:	1000                	addi	s0,sp,32
    80001fb4:	84aa                	mv	s1,a0
    struct proc *p = myproc();
    80001fb6:	fffff097          	auipc	ra,0xfffff
    80001fba:	eac080e7          	jalr	-340(ra) # 80000e62 <myproc>
    switch (n)
    80001fbe:	4795                	li	a5,5
    80001fc0:	0497e163          	bltu	a5,s1,80002002 <argraw+0x58>
    80001fc4:	048a                	slli	s1,s1,0x2
    80001fc6:	00006717          	auipc	a4,0x6
    80001fca:	4ba70713          	addi	a4,a4,1210 # 80008480 <states.1738+0x240>
    80001fce:	94ba                	add	s1,s1,a4
    80001fd0:	409c                	lw	a5,0(s1)
    80001fd2:	97ba                	add	a5,a5,a4
    80001fd4:	8782                	jr	a5
    {
    case 0:
        return p->trapframe->a0;
    80001fd6:	6d3c                	ld	a5,88(a0)
    80001fd8:	7ba8                	ld	a0,112(a5)
    case 5:
        return p->trapframe->a5;
    }
    panic("argraw");
    return -1;
}
    80001fda:	60e2                	ld	ra,24(sp)
    80001fdc:	6442                	ld	s0,16(sp)
    80001fde:	64a2                	ld	s1,8(sp)
    80001fe0:	6105                	addi	sp,sp,32
    80001fe2:	8082                	ret
        return p->trapframe->a1;
    80001fe4:	6d3c                	ld	a5,88(a0)
    80001fe6:	7fa8                	ld	a0,120(a5)
    80001fe8:	bfcd                	j	80001fda <argraw+0x30>
        return p->trapframe->a2;
    80001fea:	6d3c                	ld	a5,88(a0)
    80001fec:	63c8                	ld	a0,128(a5)
    80001fee:	b7f5                	j	80001fda <argraw+0x30>
        return p->trapframe->a3;
    80001ff0:	6d3c                	ld	a5,88(a0)
    80001ff2:	67c8                	ld	a0,136(a5)
    80001ff4:	b7dd                	j	80001fda <argraw+0x30>
        return p->trapframe->a4;
    80001ff6:	6d3c                	ld	a5,88(a0)
    80001ff8:	6bc8                	ld	a0,144(a5)
    80001ffa:	b7c5                	j	80001fda <argraw+0x30>
        return p->trapframe->a5;
    80001ffc:	6d3c                	ld	a5,88(a0)
    80001ffe:	6fc8                	ld	a0,152(a5)
    80002000:	bfe9                	j	80001fda <argraw+0x30>
    panic("argraw");
    80002002:	00006517          	auipc	a0,0x6
    80002006:	45650513          	addi	a0,a0,1110 # 80008458 <states.1738+0x218>
    8000200a:	00004097          	auipc	ra,0x4
    8000200e:	ed8080e7          	jalr	-296(ra) # 80005ee2 <panic>

0000000080002012 <fetchaddr>:
{
    80002012:	1101                	addi	sp,sp,-32
    80002014:	ec06                	sd	ra,24(sp)
    80002016:	e822                	sd	s0,16(sp)
    80002018:	e426                	sd	s1,8(sp)
    8000201a:	e04a                	sd	s2,0(sp)
    8000201c:	1000                	addi	s0,sp,32
    8000201e:	84aa                	mv	s1,a0
    80002020:	892e                	mv	s2,a1
    struct proc *p = myproc();
    80002022:	fffff097          	auipc	ra,0xfffff
    80002026:	e40080e7          	jalr	-448(ra) # 80000e62 <myproc>
    if (addr >= p->sz || addr + sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    8000202a:	653c                	ld	a5,72(a0)
    8000202c:	02f4f863          	bgeu	s1,a5,8000205c <fetchaddr+0x4a>
    80002030:	00848713          	addi	a4,s1,8
    80002034:	02e7e663          	bltu	a5,a4,80002060 <fetchaddr+0x4e>
    if (copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002038:	46a1                	li	a3,8
    8000203a:	8626                	mv	a2,s1
    8000203c:	85ca                	mv	a1,s2
    8000203e:	6928                	ld	a0,80(a0)
    80002040:	fffff097          	auipc	ra,0xfffff
    80002044:	b6c080e7          	jalr	-1172(ra) # 80000bac <copyin>
    80002048:	00a03533          	snez	a0,a0
    8000204c:	40a00533          	neg	a0,a0
}
    80002050:	60e2                	ld	ra,24(sp)
    80002052:	6442                	ld	s0,16(sp)
    80002054:	64a2                	ld	s1,8(sp)
    80002056:	6902                	ld	s2,0(sp)
    80002058:	6105                	addi	sp,sp,32
    8000205a:	8082                	ret
        return -1;
    8000205c:	557d                	li	a0,-1
    8000205e:	bfcd                	j	80002050 <fetchaddr+0x3e>
    80002060:	557d                	li	a0,-1
    80002062:	b7fd                	j	80002050 <fetchaddr+0x3e>

0000000080002064 <fetchstr>:
{
    80002064:	7179                	addi	sp,sp,-48
    80002066:	f406                	sd	ra,40(sp)
    80002068:	f022                	sd	s0,32(sp)
    8000206a:	ec26                	sd	s1,24(sp)
    8000206c:	e84a                	sd	s2,16(sp)
    8000206e:	e44e                	sd	s3,8(sp)
    80002070:	1800                	addi	s0,sp,48
    80002072:	892a                	mv	s2,a0
    80002074:	84ae                	mv	s1,a1
    80002076:	89b2                	mv	s3,a2
    struct proc *p = myproc();
    80002078:	fffff097          	auipc	ra,0xfffff
    8000207c:	dea080e7          	jalr	-534(ra) # 80000e62 <myproc>
    if (copyinstr(p->pagetable, buf, addr, max) < 0)
    80002080:	86ce                	mv	a3,s3
    80002082:	864a                	mv	a2,s2
    80002084:	85a6                	mv	a1,s1
    80002086:	6928                	ld	a0,80(a0)
    80002088:	fffff097          	auipc	ra,0xfffff
    8000208c:	bb0080e7          	jalr	-1104(ra) # 80000c38 <copyinstr>
    80002090:	00054e63          	bltz	a0,800020ac <fetchstr+0x48>
    return strlen(buf);
    80002094:	8526                	mv	a0,s1
    80002096:	ffffe097          	auipc	ra,0xffffe
    8000209a:	266080e7          	jalr	614(ra) # 800002fc <strlen>
}
    8000209e:	70a2                	ld	ra,40(sp)
    800020a0:	7402                	ld	s0,32(sp)
    800020a2:	64e2                	ld	s1,24(sp)
    800020a4:	6942                	ld	s2,16(sp)
    800020a6:	69a2                	ld	s3,8(sp)
    800020a8:	6145                	addi	sp,sp,48
    800020aa:	8082                	ret
        return -1;
    800020ac:	557d                	li	a0,-1
    800020ae:	bfc5                	j	8000209e <fetchstr+0x3a>

00000000800020b0 <argint>:

// Fetch the nth 32-bit system call argument.
void argint(int n, int *ip)
{
    800020b0:	1101                	addi	sp,sp,-32
    800020b2:	ec06                	sd	ra,24(sp)
    800020b4:	e822                	sd	s0,16(sp)
    800020b6:	e426                	sd	s1,8(sp)
    800020b8:	1000                	addi	s0,sp,32
    800020ba:	84ae                	mv	s1,a1
    *ip = argraw(n);
    800020bc:	00000097          	auipc	ra,0x0
    800020c0:	eee080e7          	jalr	-274(ra) # 80001faa <argraw>
    800020c4:	c088                	sw	a0,0(s1)
}
    800020c6:	60e2                	ld	ra,24(sp)
    800020c8:	6442                	ld	s0,16(sp)
    800020ca:	64a2                	ld	s1,8(sp)
    800020cc:	6105                	addi	sp,sp,32
    800020ce:	8082                	ret

00000000800020d0 <argaddr>:

// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void argaddr(int n, uint64 *ip)
{
    800020d0:	1101                	addi	sp,sp,-32
    800020d2:	ec06                	sd	ra,24(sp)
    800020d4:	e822                	sd	s0,16(sp)
    800020d6:	e426                	sd	s1,8(sp)
    800020d8:	1000                	addi	s0,sp,32
    800020da:	84ae                	mv	s1,a1
    *ip = argraw(n);
    800020dc:	00000097          	auipc	ra,0x0
    800020e0:	ece080e7          	jalr	-306(ra) # 80001faa <argraw>
    800020e4:	e088                	sd	a0,0(s1)
}
    800020e6:	60e2                	ld	ra,24(sp)
    800020e8:	6442                	ld	s0,16(sp)
    800020ea:	64a2                	ld	s1,8(sp)
    800020ec:	6105                	addi	sp,sp,32
    800020ee:	8082                	ret

00000000800020f0 <argstr>:

// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int argstr(int n, char *buf, int max)
{
    800020f0:	7179                	addi	sp,sp,-48
    800020f2:	f406                	sd	ra,40(sp)
    800020f4:	f022                	sd	s0,32(sp)
    800020f6:	ec26                	sd	s1,24(sp)
    800020f8:	e84a                	sd	s2,16(sp)
    800020fa:	1800                	addi	s0,sp,48
    800020fc:	84ae                	mv	s1,a1
    800020fe:	8932                	mv	s2,a2
    uint64 addr;
    argaddr(n, &addr);
    80002100:	fd840593          	addi	a1,s0,-40
    80002104:	00000097          	auipc	ra,0x0
    80002108:	fcc080e7          	jalr	-52(ra) # 800020d0 <argaddr>
    return fetchstr(addr, buf, max);
    8000210c:	864a                	mv	a2,s2
    8000210e:	85a6                	mv	a1,s1
    80002110:	fd843503          	ld	a0,-40(s0)
    80002114:	00000097          	auipc	ra,0x0
    80002118:	f50080e7          	jalr	-176(ra) # 80002064 <fetchstr>
}
    8000211c:	70a2                	ld	ra,40(sp)
    8000211e:	7402                	ld	s0,32(sp)
    80002120:	64e2                	ld	s1,24(sp)
    80002122:	6942                	ld	s2,16(sp)
    80002124:	6145                	addi	sp,sp,48
    80002126:	8082                	ret

0000000080002128 <syscall>:
    [SYS_mmap] sys_mmap,
    [SYS_munmap] sys_munmap,
};

void syscall(void)
{
    80002128:	1101                	addi	sp,sp,-32
    8000212a:	ec06                	sd	ra,24(sp)
    8000212c:	e822                	sd	s0,16(sp)
    8000212e:	e426                	sd	s1,8(sp)
    80002130:	e04a                	sd	s2,0(sp)
    80002132:	1000                	addi	s0,sp,32
    int num;
    struct proc *p = myproc();
    80002134:	fffff097          	auipc	ra,0xfffff
    80002138:	d2e080e7          	jalr	-722(ra) # 80000e62 <myproc>
    8000213c:	84aa                	mv	s1,a0

    num = p->trapframe->a7;
    8000213e:	05853903          	ld	s2,88(a0)
    80002142:	0a893783          	ld	a5,168(s2)
    80002146:	0007869b          	sext.w	a3,a5
    if (num > 0 && num < NELEM(syscalls) && syscalls[num])
    8000214a:	37fd                	addiw	a5,a5,-1
    8000214c:	4759                	li	a4,22
    8000214e:	00f76f63          	bltu	a4,a5,8000216c <syscall+0x44>
    80002152:	00369713          	slli	a4,a3,0x3
    80002156:	00006797          	auipc	a5,0x6
    8000215a:	34278793          	addi	a5,a5,834 # 80008498 <syscalls>
    8000215e:	97ba                	add	a5,a5,a4
    80002160:	639c                	ld	a5,0(a5)
    80002162:	c789                	beqz	a5,8000216c <syscall+0x44>
    {
        // Use num to lookup the system call function for num, call it,
        // and store its return value in p->trapframe->a0
        p->trapframe->a0 = syscalls[num]();
    80002164:	9782                	jalr	a5
    80002166:	06a93823          	sd	a0,112(s2)
    8000216a:	a839                	j	80002188 <syscall+0x60>
    }
    else
    {
        printf("%d %s: unknown sys call %d\n",
    8000216c:	15848613          	addi	a2,s1,344
    80002170:	588c                	lw	a1,48(s1)
    80002172:	00006517          	auipc	a0,0x6
    80002176:	2ee50513          	addi	a0,a0,750 # 80008460 <states.1738+0x220>
    8000217a:	00004097          	auipc	ra,0x4
    8000217e:	db2080e7          	jalr	-590(ra) # 80005f2c <printf>
               p->pid, p->name, num);
        p->trapframe->a0 = -1;
    80002182:	6cbc                	ld	a5,88(s1)
    80002184:	577d                	li	a4,-1
    80002186:	fbb8                	sd	a4,112(a5)
    }
}
    80002188:	60e2                	ld	ra,24(sp)
    8000218a:	6442                	ld	s0,16(sp)
    8000218c:	64a2                	ld	s1,8(sp)
    8000218e:	6902                	ld	s2,0(sp)
    80002190:	6105                	addi	sp,sp,32
    80002192:	8082                	ret

0000000080002194 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002194:	1101                	addi	sp,sp,-32
    80002196:	ec06                	sd	ra,24(sp)
    80002198:	e822                	sd	s0,16(sp)
    8000219a:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    8000219c:	fec40593          	addi	a1,s0,-20
    800021a0:	4501                	li	a0,0
    800021a2:	00000097          	auipc	ra,0x0
    800021a6:	f0e080e7          	jalr	-242(ra) # 800020b0 <argint>
  exit(n);
    800021aa:	fec42503          	lw	a0,-20(s0)
    800021ae:	fffff097          	auipc	ra,0xfffff
    800021b2:	48c080e7          	jalr	1164(ra) # 8000163a <exit>
  return 0;  // not reached
}
    800021b6:	4501                	li	a0,0
    800021b8:	60e2                	ld	ra,24(sp)
    800021ba:	6442                	ld	s0,16(sp)
    800021bc:	6105                	addi	sp,sp,32
    800021be:	8082                	ret

00000000800021c0 <sys_getpid>:

uint64
sys_getpid(void)
{
    800021c0:	1141                	addi	sp,sp,-16
    800021c2:	e406                	sd	ra,8(sp)
    800021c4:	e022                	sd	s0,0(sp)
    800021c6:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800021c8:	fffff097          	auipc	ra,0xfffff
    800021cc:	c9a080e7          	jalr	-870(ra) # 80000e62 <myproc>
}
    800021d0:	5908                	lw	a0,48(a0)
    800021d2:	60a2                	ld	ra,8(sp)
    800021d4:	6402                	ld	s0,0(sp)
    800021d6:	0141                	addi	sp,sp,16
    800021d8:	8082                	ret

00000000800021da <sys_fork>:

uint64
sys_fork(void)
{
    800021da:	1141                	addi	sp,sp,-16
    800021dc:	e406                	sd	ra,8(sp)
    800021de:	e022                	sd	s0,0(sp)
    800021e0:	0800                	addi	s0,sp,16
  return fork();
    800021e2:	fffff097          	auipc	ra,0xfffff
    800021e6:	036080e7          	jalr	54(ra) # 80001218 <fork>
}
    800021ea:	60a2                	ld	ra,8(sp)
    800021ec:	6402                	ld	s0,0(sp)
    800021ee:	0141                	addi	sp,sp,16
    800021f0:	8082                	ret

00000000800021f2 <sys_wait>:

uint64
sys_wait(void)
{
    800021f2:	1101                	addi	sp,sp,-32
    800021f4:	ec06                	sd	ra,24(sp)
    800021f6:	e822                	sd	s0,16(sp)
    800021f8:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    800021fa:	fe840593          	addi	a1,s0,-24
    800021fe:	4501                	li	a0,0
    80002200:	00000097          	auipc	ra,0x0
    80002204:	ed0080e7          	jalr	-304(ra) # 800020d0 <argaddr>
  return wait(p);
    80002208:	fe843503          	ld	a0,-24(s0)
    8000220c:	fffff097          	auipc	ra,0xfffff
    80002210:	5d4080e7          	jalr	1492(ra) # 800017e0 <wait>
}
    80002214:	60e2                	ld	ra,24(sp)
    80002216:	6442                	ld	s0,16(sp)
    80002218:	6105                	addi	sp,sp,32
    8000221a:	8082                	ret

000000008000221c <sys_sbrk>:

uint64
sys_sbrk(void)
{
    8000221c:	7179                	addi	sp,sp,-48
    8000221e:	f406                	sd	ra,40(sp)
    80002220:	f022                	sd	s0,32(sp)
    80002222:	ec26                	sd	s1,24(sp)
    80002224:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80002226:	fdc40593          	addi	a1,s0,-36
    8000222a:	4501                	li	a0,0
    8000222c:	00000097          	auipc	ra,0x0
    80002230:	e84080e7          	jalr	-380(ra) # 800020b0 <argint>
  addr = myproc()->sz;
    80002234:	fffff097          	auipc	ra,0xfffff
    80002238:	c2e080e7          	jalr	-978(ra) # 80000e62 <myproc>
    8000223c:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    8000223e:	fdc42503          	lw	a0,-36(s0)
    80002242:	fffff097          	auipc	ra,0xfffff
    80002246:	f7a080e7          	jalr	-134(ra) # 800011bc <growproc>
    8000224a:	00054863          	bltz	a0,8000225a <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    8000224e:	8526                	mv	a0,s1
    80002250:	70a2                	ld	ra,40(sp)
    80002252:	7402                	ld	s0,32(sp)
    80002254:	64e2                	ld	s1,24(sp)
    80002256:	6145                	addi	sp,sp,48
    80002258:	8082                	ret
    return -1;
    8000225a:	54fd                	li	s1,-1
    8000225c:	bfcd                	j	8000224e <sys_sbrk+0x32>

000000008000225e <sys_sleep>:

uint64
sys_sleep(void)
{
    8000225e:	7139                	addi	sp,sp,-64
    80002260:	fc06                	sd	ra,56(sp)
    80002262:	f822                	sd	s0,48(sp)
    80002264:	f426                	sd	s1,40(sp)
    80002266:	f04a                	sd	s2,32(sp)
    80002268:	ec4e                	sd	s3,24(sp)
    8000226a:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    8000226c:	fcc40593          	addi	a1,s0,-52
    80002270:	4501                	li	a0,0
    80002272:	00000097          	auipc	ra,0x0
    80002276:	e3e080e7          	jalr	-450(ra) # 800020b0 <argint>
  if(n < 0)
    8000227a:	fcc42783          	lw	a5,-52(s0)
    8000227e:	0607cf63          	bltz	a5,800022fc <sys_sleep+0x9e>
    n = 0;
  acquire(&tickslock);
    80002282:	0001e517          	auipc	a0,0x1e
    80002286:	59e50513          	addi	a0,a0,1438 # 80020820 <tickslock>
    8000228a:	00004097          	auipc	ra,0x4
    8000228e:	1a2080e7          	jalr	418(ra) # 8000642c <acquire>
  ticks0 = ticks;
    80002292:	00006917          	auipc	s2,0x6
    80002296:	72692903          	lw	s2,1830(s2) # 800089b8 <ticks>
  while(ticks - ticks0 < n){
    8000229a:	fcc42783          	lw	a5,-52(s0)
    8000229e:	cf9d                	beqz	a5,800022dc <sys_sleep+0x7e>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800022a0:	0001e997          	auipc	s3,0x1e
    800022a4:	58098993          	addi	s3,s3,1408 # 80020820 <tickslock>
    800022a8:	00006497          	auipc	s1,0x6
    800022ac:	71048493          	addi	s1,s1,1808 # 800089b8 <ticks>
    if(killed(myproc())){
    800022b0:	fffff097          	auipc	ra,0xfffff
    800022b4:	bb2080e7          	jalr	-1102(ra) # 80000e62 <myproc>
    800022b8:	fffff097          	auipc	ra,0xfffff
    800022bc:	4f6080e7          	jalr	1270(ra) # 800017ae <killed>
    800022c0:	e129                	bnez	a0,80002302 <sys_sleep+0xa4>
    sleep(&ticks, &tickslock);
    800022c2:	85ce                	mv	a1,s3
    800022c4:	8526                	mv	a0,s1
    800022c6:	fffff097          	auipc	ra,0xfffff
    800022ca:	240080e7          	jalr	576(ra) # 80001506 <sleep>
  while(ticks - ticks0 < n){
    800022ce:	409c                	lw	a5,0(s1)
    800022d0:	412787bb          	subw	a5,a5,s2
    800022d4:	fcc42703          	lw	a4,-52(s0)
    800022d8:	fce7ece3          	bltu	a5,a4,800022b0 <sys_sleep+0x52>
  }
  release(&tickslock);
    800022dc:	0001e517          	auipc	a0,0x1e
    800022e0:	54450513          	addi	a0,a0,1348 # 80020820 <tickslock>
    800022e4:	00004097          	auipc	ra,0x4
    800022e8:	1fc080e7          	jalr	508(ra) # 800064e0 <release>
  return 0;
    800022ec:	4501                	li	a0,0
}
    800022ee:	70e2                	ld	ra,56(sp)
    800022f0:	7442                	ld	s0,48(sp)
    800022f2:	74a2                	ld	s1,40(sp)
    800022f4:	7902                	ld	s2,32(sp)
    800022f6:	69e2                	ld	s3,24(sp)
    800022f8:	6121                	addi	sp,sp,64
    800022fa:	8082                	ret
    n = 0;
    800022fc:	fc042623          	sw	zero,-52(s0)
    80002300:	b749                	j	80002282 <sys_sleep+0x24>
      release(&tickslock);
    80002302:	0001e517          	auipc	a0,0x1e
    80002306:	51e50513          	addi	a0,a0,1310 # 80020820 <tickslock>
    8000230a:	00004097          	auipc	ra,0x4
    8000230e:	1d6080e7          	jalr	470(ra) # 800064e0 <release>
      return -1;
    80002312:	557d                	li	a0,-1
    80002314:	bfe9                	j	800022ee <sys_sleep+0x90>

0000000080002316 <sys_kill>:

uint64
sys_kill(void)
{
    80002316:	1101                	addi	sp,sp,-32
    80002318:	ec06                	sd	ra,24(sp)
    8000231a:	e822                	sd	s0,16(sp)
    8000231c:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    8000231e:	fec40593          	addi	a1,s0,-20
    80002322:	4501                	li	a0,0
    80002324:	00000097          	auipc	ra,0x0
    80002328:	d8c080e7          	jalr	-628(ra) # 800020b0 <argint>
  return kill(pid);
    8000232c:	fec42503          	lw	a0,-20(s0)
    80002330:	fffff097          	auipc	ra,0xfffff
    80002334:	3e0080e7          	jalr	992(ra) # 80001710 <kill>
}
    80002338:	60e2                	ld	ra,24(sp)
    8000233a:	6442                	ld	s0,16(sp)
    8000233c:	6105                	addi	sp,sp,32
    8000233e:	8082                	ret

0000000080002340 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002340:	1101                	addi	sp,sp,-32
    80002342:	ec06                	sd	ra,24(sp)
    80002344:	e822                	sd	s0,16(sp)
    80002346:	e426                	sd	s1,8(sp)
    80002348:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    8000234a:	0001e517          	auipc	a0,0x1e
    8000234e:	4d650513          	addi	a0,a0,1238 # 80020820 <tickslock>
    80002352:	00004097          	auipc	ra,0x4
    80002356:	0da080e7          	jalr	218(ra) # 8000642c <acquire>
  xticks = ticks;
    8000235a:	00006497          	auipc	s1,0x6
    8000235e:	65e4a483          	lw	s1,1630(s1) # 800089b8 <ticks>
  release(&tickslock);
    80002362:	0001e517          	auipc	a0,0x1e
    80002366:	4be50513          	addi	a0,a0,1214 # 80020820 <tickslock>
    8000236a:	00004097          	auipc	ra,0x4
    8000236e:	176080e7          	jalr	374(ra) # 800064e0 <release>
  return xticks;
}
    80002372:	02049513          	slli	a0,s1,0x20
    80002376:	9101                	srli	a0,a0,0x20
    80002378:	60e2                	ld	ra,24(sp)
    8000237a:	6442                	ld	s0,16(sp)
    8000237c:	64a2                	ld	s1,8(sp)
    8000237e:	6105                	addi	sp,sp,32
    80002380:	8082                	ret

0000000080002382 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002382:	7179                	addi	sp,sp,-48
    80002384:	f406                	sd	ra,40(sp)
    80002386:	f022                	sd	s0,32(sp)
    80002388:	ec26                	sd	s1,24(sp)
    8000238a:	e84a                	sd	s2,16(sp)
    8000238c:	e44e                	sd	s3,8(sp)
    8000238e:	e052                	sd	s4,0(sp)
    80002390:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002392:	00006597          	auipc	a1,0x6
    80002396:	1c658593          	addi	a1,a1,454 # 80008558 <syscalls+0xc0>
    8000239a:	0001e517          	auipc	a0,0x1e
    8000239e:	49e50513          	addi	a0,a0,1182 # 80020838 <bcache>
    800023a2:	00004097          	auipc	ra,0x4
    800023a6:	ffa080e7          	jalr	-6(ra) # 8000639c <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800023aa:	00026797          	auipc	a5,0x26
    800023ae:	48e78793          	addi	a5,a5,1166 # 80028838 <bcache+0x8000>
    800023b2:	00026717          	auipc	a4,0x26
    800023b6:	6ee70713          	addi	a4,a4,1774 # 80028aa0 <bcache+0x8268>
    800023ba:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800023be:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800023c2:	0001e497          	auipc	s1,0x1e
    800023c6:	48e48493          	addi	s1,s1,1166 # 80020850 <bcache+0x18>
    b->next = bcache.head.next;
    800023ca:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800023cc:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800023ce:	00006a17          	auipc	s4,0x6
    800023d2:	192a0a13          	addi	s4,s4,402 # 80008560 <syscalls+0xc8>
    b->next = bcache.head.next;
    800023d6:	2b893783          	ld	a5,696(s2)
    800023da:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800023dc:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800023e0:	85d2                	mv	a1,s4
    800023e2:	01048513          	addi	a0,s1,16
    800023e6:	00001097          	auipc	ra,0x1
    800023ea:	4c4080e7          	jalr	1220(ra) # 800038aa <initsleeplock>
    bcache.head.next->prev = b;
    800023ee:	2b893783          	ld	a5,696(s2)
    800023f2:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800023f4:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800023f8:	45848493          	addi	s1,s1,1112
    800023fc:	fd349de3          	bne	s1,s3,800023d6 <binit+0x54>
  }
}
    80002400:	70a2                	ld	ra,40(sp)
    80002402:	7402                	ld	s0,32(sp)
    80002404:	64e2                	ld	s1,24(sp)
    80002406:	6942                	ld	s2,16(sp)
    80002408:	69a2                	ld	s3,8(sp)
    8000240a:	6a02                	ld	s4,0(sp)
    8000240c:	6145                	addi	sp,sp,48
    8000240e:	8082                	ret

0000000080002410 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002410:	7179                	addi	sp,sp,-48
    80002412:	f406                	sd	ra,40(sp)
    80002414:	f022                	sd	s0,32(sp)
    80002416:	ec26                	sd	s1,24(sp)
    80002418:	e84a                	sd	s2,16(sp)
    8000241a:	e44e                	sd	s3,8(sp)
    8000241c:	1800                	addi	s0,sp,48
    8000241e:	89aa                	mv	s3,a0
    80002420:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    80002422:	0001e517          	auipc	a0,0x1e
    80002426:	41650513          	addi	a0,a0,1046 # 80020838 <bcache>
    8000242a:	00004097          	auipc	ra,0x4
    8000242e:	002080e7          	jalr	2(ra) # 8000642c <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002432:	00026497          	auipc	s1,0x26
    80002436:	6be4b483          	ld	s1,1726(s1) # 80028af0 <bcache+0x82b8>
    8000243a:	00026797          	auipc	a5,0x26
    8000243e:	66678793          	addi	a5,a5,1638 # 80028aa0 <bcache+0x8268>
    80002442:	02f48f63          	beq	s1,a5,80002480 <bread+0x70>
    80002446:	873e                	mv	a4,a5
    80002448:	a021                	j	80002450 <bread+0x40>
    8000244a:	68a4                	ld	s1,80(s1)
    8000244c:	02e48a63          	beq	s1,a4,80002480 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002450:	449c                	lw	a5,8(s1)
    80002452:	ff379ce3          	bne	a5,s3,8000244a <bread+0x3a>
    80002456:	44dc                	lw	a5,12(s1)
    80002458:	ff2799e3          	bne	a5,s2,8000244a <bread+0x3a>
      b->refcnt++;
    8000245c:	40bc                	lw	a5,64(s1)
    8000245e:	2785                	addiw	a5,a5,1
    80002460:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002462:	0001e517          	auipc	a0,0x1e
    80002466:	3d650513          	addi	a0,a0,982 # 80020838 <bcache>
    8000246a:	00004097          	auipc	ra,0x4
    8000246e:	076080e7          	jalr	118(ra) # 800064e0 <release>
      acquiresleep(&b->lock);
    80002472:	01048513          	addi	a0,s1,16
    80002476:	00001097          	auipc	ra,0x1
    8000247a:	46e080e7          	jalr	1134(ra) # 800038e4 <acquiresleep>
      return b;
    8000247e:	a8b9                	j	800024dc <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002480:	00026497          	auipc	s1,0x26
    80002484:	6684b483          	ld	s1,1640(s1) # 80028ae8 <bcache+0x82b0>
    80002488:	00026797          	auipc	a5,0x26
    8000248c:	61878793          	addi	a5,a5,1560 # 80028aa0 <bcache+0x8268>
    80002490:	00f48863          	beq	s1,a5,800024a0 <bread+0x90>
    80002494:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002496:	40bc                	lw	a5,64(s1)
    80002498:	cf81                	beqz	a5,800024b0 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000249a:	64a4                	ld	s1,72(s1)
    8000249c:	fee49de3          	bne	s1,a4,80002496 <bread+0x86>
  panic("bget: no buffers");
    800024a0:	00006517          	auipc	a0,0x6
    800024a4:	0c850513          	addi	a0,a0,200 # 80008568 <syscalls+0xd0>
    800024a8:	00004097          	auipc	ra,0x4
    800024ac:	a3a080e7          	jalr	-1478(ra) # 80005ee2 <panic>
      b->dev = dev;
    800024b0:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    800024b4:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    800024b8:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800024bc:	4785                	li	a5,1
    800024be:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800024c0:	0001e517          	auipc	a0,0x1e
    800024c4:	37850513          	addi	a0,a0,888 # 80020838 <bcache>
    800024c8:	00004097          	auipc	ra,0x4
    800024cc:	018080e7          	jalr	24(ra) # 800064e0 <release>
      acquiresleep(&b->lock);
    800024d0:	01048513          	addi	a0,s1,16
    800024d4:	00001097          	auipc	ra,0x1
    800024d8:	410080e7          	jalr	1040(ra) # 800038e4 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800024dc:	409c                	lw	a5,0(s1)
    800024de:	cb89                	beqz	a5,800024f0 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800024e0:	8526                	mv	a0,s1
    800024e2:	70a2                	ld	ra,40(sp)
    800024e4:	7402                	ld	s0,32(sp)
    800024e6:	64e2                	ld	s1,24(sp)
    800024e8:	6942                	ld	s2,16(sp)
    800024ea:	69a2                	ld	s3,8(sp)
    800024ec:	6145                	addi	sp,sp,48
    800024ee:	8082                	ret
    virtio_disk_rw(b, 0);
    800024f0:	4581                	li	a1,0
    800024f2:	8526                	mv	a0,s1
    800024f4:	00003097          	auipc	ra,0x3
    800024f8:	184080e7          	jalr	388(ra) # 80005678 <virtio_disk_rw>
    b->valid = 1;
    800024fc:	4785                	li	a5,1
    800024fe:	c09c                	sw	a5,0(s1)
  return b;
    80002500:	b7c5                	j	800024e0 <bread+0xd0>

0000000080002502 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    80002502:	1101                	addi	sp,sp,-32
    80002504:	ec06                	sd	ra,24(sp)
    80002506:	e822                	sd	s0,16(sp)
    80002508:	e426                	sd	s1,8(sp)
    8000250a:	1000                	addi	s0,sp,32
    8000250c:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000250e:	0541                	addi	a0,a0,16
    80002510:	00001097          	auipc	ra,0x1
    80002514:	46e080e7          	jalr	1134(ra) # 8000397e <holdingsleep>
    80002518:	cd01                	beqz	a0,80002530 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    8000251a:	4585                	li	a1,1
    8000251c:	8526                	mv	a0,s1
    8000251e:	00003097          	auipc	ra,0x3
    80002522:	15a080e7          	jalr	346(ra) # 80005678 <virtio_disk_rw>
}
    80002526:	60e2                	ld	ra,24(sp)
    80002528:	6442                	ld	s0,16(sp)
    8000252a:	64a2                	ld	s1,8(sp)
    8000252c:	6105                	addi	sp,sp,32
    8000252e:	8082                	ret
    panic("bwrite");
    80002530:	00006517          	auipc	a0,0x6
    80002534:	05050513          	addi	a0,a0,80 # 80008580 <syscalls+0xe8>
    80002538:	00004097          	auipc	ra,0x4
    8000253c:	9aa080e7          	jalr	-1622(ra) # 80005ee2 <panic>

0000000080002540 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002540:	1101                	addi	sp,sp,-32
    80002542:	ec06                	sd	ra,24(sp)
    80002544:	e822                	sd	s0,16(sp)
    80002546:	e426                	sd	s1,8(sp)
    80002548:	e04a                	sd	s2,0(sp)
    8000254a:	1000                	addi	s0,sp,32
    8000254c:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000254e:	01050913          	addi	s2,a0,16
    80002552:	854a                	mv	a0,s2
    80002554:	00001097          	auipc	ra,0x1
    80002558:	42a080e7          	jalr	1066(ra) # 8000397e <holdingsleep>
    8000255c:	c92d                	beqz	a0,800025ce <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    8000255e:	854a                	mv	a0,s2
    80002560:	00001097          	auipc	ra,0x1
    80002564:	3da080e7          	jalr	986(ra) # 8000393a <releasesleep>

  acquire(&bcache.lock);
    80002568:	0001e517          	auipc	a0,0x1e
    8000256c:	2d050513          	addi	a0,a0,720 # 80020838 <bcache>
    80002570:	00004097          	auipc	ra,0x4
    80002574:	ebc080e7          	jalr	-324(ra) # 8000642c <acquire>
  b->refcnt--;
    80002578:	40bc                	lw	a5,64(s1)
    8000257a:	37fd                	addiw	a5,a5,-1
    8000257c:	0007871b          	sext.w	a4,a5
    80002580:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002582:	eb05                	bnez	a4,800025b2 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002584:	68bc                	ld	a5,80(s1)
    80002586:	64b8                	ld	a4,72(s1)
    80002588:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    8000258a:	64bc                	ld	a5,72(s1)
    8000258c:	68b8                	ld	a4,80(s1)
    8000258e:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002590:	00026797          	auipc	a5,0x26
    80002594:	2a878793          	addi	a5,a5,680 # 80028838 <bcache+0x8000>
    80002598:	2b87b703          	ld	a4,696(a5)
    8000259c:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    8000259e:	00026717          	auipc	a4,0x26
    800025a2:	50270713          	addi	a4,a4,1282 # 80028aa0 <bcache+0x8268>
    800025a6:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800025a8:	2b87b703          	ld	a4,696(a5)
    800025ac:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800025ae:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800025b2:	0001e517          	auipc	a0,0x1e
    800025b6:	28650513          	addi	a0,a0,646 # 80020838 <bcache>
    800025ba:	00004097          	auipc	ra,0x4
    800025be:	f26080e7          	jalr	-218(ra) # 800064e0 <release>
}
    800025c2:	60e2                	ld	ra,24(sp)
    800025c4:	6442                	ld	s0,16(sp)
    800025c6:	64a2                	ld	s1,8(sp)
    800025c8:	6902                	ld	s2,0(sp)
    800025ca:	6105                	addi	sp,sp,32
    800025cc:	8082                	ret
    panic("brelse");
    800025ce:	00006517          	auipc	a0,0x6
    800025d2:	fba50513          	addi	a0,a0,-70 # 80008588 <syscalls+0xf0>
    800025d6:	00004097          	auipc	ra,0x4
    800025da:	90c080e7          	jalr	-1780(ra) # 80005ee2 <panic>

00000000800025de <bpin>:

void
bpin(struct buf *b) {
    800025de:	1101                	addi	sp,sp,-32
    800025e0:	ec06                	sd	ra,24(sp)
    800025e2:	e822                	sd	s0,16(sp)
    800025e4:	e426                	sd	s1,8(sp)
    800025e6:	1000                	addi	s0,sp,32
    800025e8:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800025ea:	0001e517          	auipc	a0,0x1e
    800025ee:	24e50513          	addi	a0,a0,590 # 80020838 <bcache>
    800025f2:	00004097          	auipc	ra,0x4
    800025f6:	e3a080e7          	jalr	-454(ra) # 8000642c <acquire>
  b->refcnt++;
    800025fa:	40bc                	lw	a5,64(s1)
    800025fc:	2785                	addiw	a5,a5,1
    800025fe:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002600:	0001e517          	auipc	a0,0x1e
    80002604:	23850513          	addi	a0,a0,568 # 80020838 <bcache>
    80002608:	00004097          	auipc	ra,0x4
    8000260c:	ed8080e7          	jalr	-296(ra) # 800064e0 <release>
}
    80002610:	60e2                	ld	ra,24(sp)
    80002612:	6442                	ld	s0,16(sp)
    80002614:	64a2                	ld	s1,8(sp)
    80002616:	6105                	addi	sp,sp,32
    80002618:	8082                	ret

000000008000261a <bunpin>:

void
bunpin(struct buf *b) {
    8000261a:	1101                	addi	sp,sp,-32
    8000261c:	ec06                	sd	ra,24(sp)
    8000261e:	e822                	sd	s0,16(sp)
    80002620:	e426                	sd	s1,8(sp)
    80002622:	1000                	addi	s0,sp,32
    80002624:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002626:	0001e517          	auipc	a0,0x1e
    8000262a:	21250513          	addi	a0,a0,530 # 80020838 <bcache>
    8000262e:	00004097          	auipc	ra,0x4
    80002632:	dfe080e7          	jalr	-514(ra) # 8000642c <acquire>
  b->refcnt--;
    80002636:	40bc                	lw	a5,64(s1)
    80002638:	37fd                	addiw	a5,a5,-1
    8000263a:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000263c:	0001e517          	auipc	a0,0x1e
    80002640:	1fc50513          	addi	a0,a0,508 # 80020838 <bcache>
    80002644:	00004097          	auipc	ra,0x4
    80002648:	e9c080e7          	jalr	-356(ra) # 800064e0 <release>
}
    8000264c:	60e2                	ld	ra,24(sp)
    8000264e:	6442                	ld	s0,16(sp)
    80002650:	64a2                	ld	s1,8(sp)
    80002652:	6105                	addi	sp,sp,32
    80002654:	8082                	ret

0000000080002656 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002656:	1101                	addi	sp,sp,-32
    80002658:	ec06                	sd	ra,24(sp)
    8000265a:	e822                	sd	s0,16(sp)
    8000265c:	e426                	sd	s1,8(sp)
    8000265e:	e04a                	sd	s2,0(sp)
    80002660:	1000                	addi	s0,sp,32
    80002662:	84ae                	mv	s1,a1
    struct buf *bp;
    int bi, m;

    bp = bread(dev, BBLOCK(b, sb));
    80002664:	00d5d59b          	srliw	a1,a1,0xd
    80002668:	00027797          	auipc	a5,0x27
    8000266c:	8ac7a783          	lw	a5,-1876(a5) # 80028f14 <sb+0x1c>
    80002670:	9dbd                	addw	a1,a1,a5
    80002672:	00000097          	auipc	ra,0x0
    80002676:	d9e080e7          	jalr	-610(ra) # 80002410 <bread>
    bi = b % BPB;
    m = 1 << (bi % 8);
    8000267a:	0074f713          	andi	a4,s1,7
    8000267e:	4785                	li	a5,1
    80002680:	00e797bb          	sllw	a5,a5,a4
    if ((bp->data[bi / 8] & m) == 0)
    80002684:	14ce                	slli	s1,s1,0x33
    80002686:	90d9                	srli	s1,s1,0x36
    80002688:	00950733          	add	a4,a0,s1
    8000268c:	05874703          	lbu	a4,88(a4)
    80002690:	00e7f6b3          	and	a3,a5,a4
    80002694:	c69d                	beqz	a3,800026c2 <bfree+0x6c>
    80002696:	892a                	mv	s2,a0
        panic("freeing free block");
    bp->data[bi / 8] &= ~m;
    80002698:	94aa                	add	s1,s1,a0
    8000269a:	fff7c793          	not	a5,a5
    8000269e:	8ff9                	and	a5,a5,a4
    800026a0:	04f48c23          	sb	a5,88(s1)
    log_write(bp);
    800026a4:	00001097          	auipc	ra,0x1
    800026a8:	120080e7          	jalr	288(ra) # 800037c4 <log_write>
    brelse(bp);
    800026ac:	854a                	mv	a0,s2
    800026ae:	00000097          	auipc	ra,0x0
    800026b2:	e92080e7          	jalr	-366(ra) # 80002540 <brelse>
}
    800026b6:	60e2                	ld	ra,24(sp)
    800026b8:	6442                	ld	s0,16(sp)
    800026ba:	64a2                	ld	s1,8(sp)
    800026bc:	6902                	ld	s2,0(sp)
    800026be:	6105                	addi	sp,sp,32
    800026c0:	8082                	ret
        panic("freeing free block");
    800026c2:	00006517          	auipc	a0,0x6
    800026c6:	ece50513          	addi	a0,a0,-306 # 80008590 <syscalls+0xf8>
    800026ca:	00004097          	auipc	ra,0x4
    800026ce:	818080e7          	jalr	-2024(ra) # 80005ee2 <panic>

00000000800026d2 <balloc>:
{
    800026d2:	711d                	addi	sp,sp,-96
    800026d4:	ec86                	sd	ra,88(sp)
    800026d6:	e8a2                	sd	s0,80(sp)
    800026d8:	e4a6                	sd	s1,72(sp)
    800026da:	e0ca                	sd	s2,64(sp)
    800026dc:	fc4e                	sd	s3,56(sp)
    800026de:	f852                	sd	s4,48(sp)
    800026e0:	f456                	sd	s5,40(sp)
    800026e2:	f05a                	sd	s6,32(sp)
    800026e4:	ec5e                	sd	s7,24(sp)
    800026e6:	e862                	sd	s8,16(sp)
    800026e8:	e466                	sd	s9,8(sp)
    800026ea:	1080                	addi	s0,sp,96
    for (b = 0; b < sb.size; b += BPB)
    800026ec:	00027797          	auipc	a5,0x27
    800026f0:	8107a783          	lw	a5,-2032(a5) # 80028efc <sb+0x4>
    800026f4:	10078163          	beqz	a5,800027f6 <balloc+0x124>
    800026f8:	8baa                	mv	s7,a0
    800026fa:	4a81                	li	s5,0
        bp = bread(dev, BBLOCK(b, sb));
    800026fc:	00026b17          	auipc	s6,0x26
    80002700:	7fcb0b13          	addi	s6,s6,2044 # 80028ef8 <sb>
        for (bi = 0; bi < BPB && b + bi < sb.size; bi++)
    80002704:	4c01                	li	s8,0
            m = 1 << (bi % 8);
    80002706:	4985                	li	s3,1
        for (bi = 0; bi < BPB && b + bi < sb.size; bi++)
    80002708:	6a09                	lui	s4,0x2
    for (b = 0; b < sb.size; b += BPB)
    8000270a:	6c89                	lui	s9,0x2
    8000270c:	a061                	j	80002794 <balloc+0xc2>
                bp->data[bi / 8] |= m; // Mark block in use.
    8000270e:	974a                	add	a4,a4,s2
    80002710:	8fd5                	or	a5,a5,a3
    80002712:	04f70c23          	sb	a5,88(a4)
                log_write(bp);
    80002716:	854a                	mv	a0,s2
    80002718:	00001097          	auipc	ra,0x1
    8000271c:	0ac080e7          	jalr	172(ra) # 800037c4 <log_write>
                brelse(bp);
    80002720:	854a                	mv	a0,s2
    80002722:	00000097          	auipc	ra,0x0
    80002726:	e1e080e7          	jalr	-482(ra) # 80002540 <brelse>
    bp = bread(dev, bno);
    8000272a:	85a6                	mv	a1,s1
    8000272c:	855e                	mv	a0,s7
    8000272e:	00000097          	auipc	ra,0x0
    80002732:	ce2080e7          	jalr	-798(ra) # 80002410 <bread>
    80002736:	892a                	mv	s2,a0
    memset(bp->data, 0, BSIZE);
    80002738:	40000613          	li	a2,1024
    8000273c:	4581                	li	a1,0
    8000273e:	05850513          	addi	a0,a0,88
    80002742:	ffffe097          	auipc	ra,0xffffe
    80002746:	a36080e7          	jalr	-1482(ra) # 80000178 <memset>
    log_write(bp);
    8000274a:	854a                	mv	a0,s2
    8000274c:	00001097          	auipc	ra,0x1
    80002750:	078080e7          	jalr	120(ra) # 800037c4 <log_write>
    brelse(bp);
    80002754:	854a                	mv	a0,s2
    80002756:	00000097          	auipc	ra,0x0
    8000275a:	dea080e7          	jalr	-534(ra) # 80002540 <brelse>
}
    8000275e:	8526                	mv	a0,s1
    80002760:	60e6                	ld	ra,88(sp)
    80002762:	6446                	ld	s0,80(sp)
    80002764:	64a6                	ld	s1,72(sp)
    80002766:	6906                	ld	s2,64(sp)
    80002768:	79e2                	ld	s3,56(sp)
    8000276a:	7a42                	ld	s4,48(sp)
    8000276c:	7aa2                	ld	s5,40(sp)
    8000276e:	7b02                	ld	s6,32(sp)
    80002770:	6be2                	ld	s7,24(sp)
    80002772:	6c42                	ld	s8,16(sp)
    80002774:	6ca2                	ld	s9,8(sp)
    80002776:	6125                	addi	sp,sp,96
    80002778:	8082                	ret
        brelse(bp);
    8000277a:	854a                	mv	a0,s2
    8000277c:	00000097          	auipc	ra,0x0
    80002780:	dc4080e7          	jalr	-572(ra) # 80002540 <brelse>
    for (b = 0; b < sb.size; b += BPB)
    80002784:	015c87bb          	addw	a5,s9,s5
    80002788:	00078a9b          	sext.w	s5,a5
    8000278c:	004b2703          	lw	a4,4(s6)
    80002790:	06eaf363          	bgeu	s5,a4,800027f6 <balloc+0x124>
        bp = bread(dev, BBLOCK(b, sb));
    80002794:	41fad79b          	sraiw	a5,s5,0x1f
    80002798:	0137d79b          	srliw	a5,a5,0x13
    8000279c:	015787bb          	addw	a5,a5,s5
    800027a0:	40d7d79b          	sraiw	a5,a5,0xd
    800027a4:	01cb2583          	lw	a1,28(s6)
    800027a8:	9dbd                	addw	a1,a1,a5
    800027aa:	855e                	mv	a0,s7
    800027ac:	00000097          	auipc	ra,0x0
    800027b0:	c64080e7          	jalr	-924(ra) # 80002410 <bread>
    800027b4:	892a                	mv	s2,a0
        for (bi = 0; bi < BPB && b + bi < sb.size; bi++)
    800027b6:	004b2503          	lw	a0,4(s6)
    800027ba:	000a849b          	sext.w	s1,s5
    800027be:	8662                	mv	a2,s8
    800027c0:	faa4fde3          	bgeu	s1,a0,8000277a <balloc+0xa8>
            m = 1 << (bi % 8);
    800027c4:	41f6579b          	sraiw	a5,a2,0x1f
    800027c8:	01d7d69b          	srliw	a3,a5,0x1d
    800027cc:	00c6873b          	addw	a4,a3,a2
    800027d0:	00777793          	andi	a5,a4,7
    800027d4:	9f95                	subw	a5,a5,a3
    800027d6:	00f997bb          	sllw	a5,s3,a5
            if ((bp->data[bi / 8] & m) == 0)
    800027da:	4037571b          	sraiw	a4,a4,0x3
    800027de:	00e906b3          	add	a3,s2,a4
    800027e2:	0586c683          	lbu	a3,88(a3)
    800027e6:	00d7f5b3          	and	a1,a5,a3
    800027ea:	d195                	beqz	a1,8000270e <balloc+0x3c>
        for (bi = 0; bi < BPB && b + bi < sb.size; bi++)
    800027ec:	2605                	addiw	a2,a2,1
    800027ee:	2485                	addiw	s1,s1,1
    800027f0:	fd4618e3          	bne	a2,s4,800027c0 <balloc+0xee>
    800027f4:	b759                	j	8000277a <balloc+0xa8>
    printf("balloc: out of blocks\n");
    800027f6:	00006517          	auipc	a0,0x6
    800027fa:	db250513          	addi	a0,a0,-590 # 800085a8 <syscalls+0x110>
    800027fe:	00003097          	auipc	ra,0x3
    80002802:	72e080e7          	jalr	1838(ra) # 80005f2c <printf>
    return 0;
    80002806:	4481                	li	s1,0
    80002808:	bf99                	j	8000275e <balloc+0x8c>

000000008000280a <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    8000280a:	7179                	addi	sp,sp,-48
    8000280c:	f406                	sd	ra,40(sp)
    8000280e:	f022                	sd	s0,32(sp)
    80002810:	ec26                	sd	s1,24(sp)
    80002812:	e84a                	sd	s2,16(sp)
    80002814:	e44e                	sd	s3,8(sp)
    80002816:	e052                	sd	s4,0(sp)
    80002818:	1800                	addi	s0,sp,48
    8000281a:	89aa                	mv	s3,a0
    uint addr, *a;
    struct buf *bp;

    if (bn < NDIRECT)
    8000281c:	47ad                	li	a5,11
    8000281e:	02b7e763          	bltu	a5,a1,8000284c <bmap+0x42>
    {
        if ((addr = ip->addrs[bn]) == 0)
    80002822:	02059493          	slli	s1,a1,0x20
    80002826:	9081                	srli	s1,s1,0x20
    80002828:	048a                	slli	s1,s1,0x2
    8000282a:	94aa                	add	s1,s1,a0
    8000282c:	0504a903          	lw	s2,80(s1)
    80002830:	06091e63          	bnez	s2,800028ac <bmap+0xa2>
        {
            addr = balloc(ip->dev);
    80002834:	4108                	lw	a0,0(a0)
    80002836:	00000097          	auipc	ra,0x0
    8000283a:	e9c080e7          	jalr	-356(ra) # 800026d2 <balloc>
    8000283e:	0005091b          	sext.w	s2,a0
            if (addr == 0)
    80002842:	06090563          	beqz	s2,800028ac <bmap+0xa2>
                return 0;
            ip->addrs[bn] = addr;
    80002846:	0524a823          	sw	s2,80(s1)
    8000284a:	a08d                	j	800028ac <bmap+0xa2>
        }
        return addr;
    }
    bn -= NDIRECT;
    8000284c:	ff45849b          	addiw	s1,a1,-12
    80002850:	0004871b          	sext.w	a4,s1

    if (bn < NINDIRECT)
    80002854:	0ff00793          	li	a5,255
    80002858:	08e7e563          	bltu	a5,a4,800028e2 <bmap+0xd8>
    {
        // Load indirect block, allocating if necessary.
        if ((addr = ip->addrs[NDIRECT]) == 0)
    8000285c:	08052903          	lw	s2,128(a0)
    80002860:	00091d63          	bnez	s2,8000287a <bmap+0x70>
        {
            addr = balloc(ip->dev);
    80002864:	4108                	lw	a0,0(a0)
    80002866:	00000097          	auipc	ra,0x0
    8000286a:	e6c080e7          	jalr	-404(ra) # 800026d2 <balloc>
    8000286e:	0005091b          	sext.w	s2,a0
            if (addr == 0)
    80002872:	02090d63          	beqz	s2,800028ac <bmap+0xa2>
                return 0;
            ip->addrs[NDIRECT] = addr;
    80002876:	0929a023          	sw	s2,128(s3)
        }
        bp = bread(ip->dev, addr);
    8000287a:	85ca                	mv	a1,s2
    8000287c:	0009a503          	lw	a0,0(s3)
    80002880:	00000097          	auipc	ra,0x0
    80002884:	b90080e7          	jalr	-1136(ra) # 80002410 <bread>
    80002888:	8a2a                	mv	s4,a0
        a = (uint *)bp->data;
    8000288a:	05850793          	addi	a5,a0,88
        if ((addr = a[bn]) == 0)
    8000288e:	02049593          	slli	a1,s1,0x20
    80002892:	9181                	srli	a1,a1,0x20
    80002894:	058a                	slli	a1,a1,0x2
    80002896:	00b784b3          	add	s1,a5,a1
    8000289a:	0004a903          	lw	s2,0(s1)
    8000289e:	02090063          	beqz	s2,800028be <bmap+0xb4>
            {
                a[bn] = addr;
                log_write(bp);
            }
        }
        brelse(bp);
    800028a2:	8552                	mv	a0,s4
    800028a4:	00000097          	auipc	ra,0x0
    800028a8:	c9c080e7          	jalr	-868(ra) # 80002540 <brelse>
        return addr;
    }

    panic("bmap: out of range");
}
    800028ac:	854a                	mv	a0,s2
    800028ae:	70a2                	ld	ra,40(sp)
    800028b0:	7402                	ld	s0,32(sp)
    800028b2:	64e2                	ld	s1,24(sp)
    800028b4:	6942                	ld	s2,16(sp)
    800028b6:	69a2                	ld	s3,8(sp)
    800028b8:	6a02                	ld	s4,0(sp)
    800028ba:	6145                	addi	sp,sp,48
    800028bc:	8082                	ret
            addr = balloc(ip->dev);
    800028be:	0009a503          	lw	a0,0(s3)
    800028c2:	00000097          	auipc	ra,0x0
    800028c6:	e10080e7          	jalr	-496(ra) # 800026d2 <balloc>
    800028ca:	0005091b          	sext.w	s2,a0
            if (addr)
    800028ce:	fc090ae3          	beqz	s2,800028a2 <bmap+0x98>
                a[bn] = addr;
    800028d2:	0124a023          	sw	s2,0(s1)
                log_write(bp);
    800028d6:	8552                	mv	a0,s4
    800028d8:	00001097          	auipc	ra,0x1
    800028dc:	eec080e7          	jalr	-276(ra) # 800037c4 <log_write>
    800028e0:	b7c9                	j	800028a2 <bmap+0x98>
    panic("bmap: out of range");
    800028e2:	00006517          	auipc	a0,0x6
    800028e6:	cde50513          	addi	a0,a0,-802 # 800085c0 <syscalls+0x128>
    800028ea:	00003097          	auipc	ra,0x3
    800028ee:	5f8080e7          	jalr	1528(ra) # 80005ee2 <panic>

00000000800028f2 <iget>:
{
    800028f2:	7179                	addi	sp,sp,-48
    800028f4:	f406                	sd	ra,40(sp)
    800028f6:	f022                	sd	s0,32(sp)
    800028f8:	ec26                	sd	s1,24(sp)
    800028fa:	e84a                	sd	s2,16(sp)
    800028fc:	e44e                	sd	s3,8(sp)
    800028fe:	e052                	sd	s4,0(sp)
    80002900:	1800                	addi	s0,sp,48
    80002902:	89aa                	mv	s3,a0
    80002904:	8a2e                	mv	s4,a1
    acquire(&itable.lock);
    80002906:	00026517          	auipc	a0,0x26
    8000290a:	61250513          	addi	a0,a0,1554 # 80028f18 <itable>
    8000290e:	00004097          	auipc	ra,0x4
    80002912:	b1e080e7          	jalr	-1250(ra) # 8000642c <acquire>
    empty = 0;
    80002916:	4901                	li	s2,0
    for (ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++)
    80002918:	00026497          	auipc	s1,0x26
    8000291c:	61848493          	addi	s1,s1,1560 # 80028f30 <itable+0x18>
    80002920:	00028697          	auipc	a3,0x28
    80002924:	0a068693          	addi	a3,a3,160 # 8002a9c0 <log>
    80002928:	a039                	j	80002936 <iget+0x44>
        if (empty == 0 && ip->ref == 0) // Remember empty slot.
    8000292a:	02090b63          	beqz	s2,80002960 <iget+0x6e>
    for (ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++)
    8000292e:	08848493          	addi	s1,s1,136
    80002932:	02d48a63          	beq	s1,a3,80002966 <iget+0x74>
        if (ip->ref > 0 && ip->dev == dev && ip->inum == inum)
    80002936:	449c                	lw	a5,8(s1)
    80002938:	fef059e3          	blez	a5,8000292a <iget+0x38>
    8000293c:	4098                	lw	a4,0(s1)
    8000293e:	ff3716e3          	bne	a4,s3,8000292a <iget+0x38>
    80002942:	40d8                	lw	a4,4(s1)
    80002944:	ff4713e3          	bne	a4,s4,8000292a <iget+0x38>
            ip->ref++;
    80002948:	2785                	addiw	a5,a5,1
    8000294a:	c49c                	sw	a5,8(s1)
            release(&itable.lock);
    8000294c:	00026517          	auipc	a0,0x26
    80002950:	5cc50513          	addi	a0,a0,1484 # 80028f18 <itable>
    80002954:	00004097          	auipc	ra,0x4
    80002958:	b8c080e7          	jalr	-1140(ra) # 800064e0 <release>
            return ip;
    8000295c:	8926                	mv	s2,s1
    8000295e:	a03d                	j	8000298c <iget+0x9a>
        if (empty == 0 && ip->ref == 0) // Remember empty slot.
    80002960:	f7f9                	bnez	a5,8000292e <iget+0x3c>
    80002962:	8926                	mv	s2,s1
    80002964:	b7e9                	j	8000292e <iget+0x3c>
    if (empty == 0)
    80002966:	02090c63          	beqz	s2,8000299e <iget+0xac>
    ip->dev = dev;
    8000296a:	01392023          	sw	s3,0(s2)
    ip->inum = inum;
    8000296e:	01492223          	sw	s4,4(s2)
    ip->ref = 1;
    80002972:	4785                	li	a5,1
    80002974:	00f92423          	sw	a5,8(s2)
    ip->valid = 0;
    80002978:	04092023          	sw	zero,64(s2)
    release(&itable.lock);
    8000297c:	00026517          	auipc	a0,0x26
    80002980:	59c50513          	addi	a0,a0,1436 # 80028f18 <itable>
    80002984:	00004097          	auipc	ra,0x4
    80002988:	b5c080e7          	jalr	-1188(ra) # 800064e0 <release>
}
    8000298c:	854a                	mv	a0,s2
    8000298e:	70a2                	ld	ra,40(sp)
    80002990:	7402                	ld	s0,32(sp)
    80002992:	64e2                	ld	s1,24(sp)
    80002994:	6942                	ld	s2,16(sp)
    80002996:	69a2                	ld	s3,8(sp)
    80002998:	6a02                	ld	s4,0(sp)
    8000299a:	6145                	addi	sp,sp,48
    8000299c:	8082                	ret
        panic("iget: no inodes");
    8000299e:	00006517          	auipc	a0,0x6
    800029a2:	c3a50513          	addi	a0,a0,-966 # 800085d8 <syscalls+0x140>
    800029a6:	00003097          	auipc	ra,0x3
    800029aa:	53c080e7          	jalr	1340(ra) # 80005ee2 <panic>

00000000800029ae <fsinit>:
{
    800029ae:	7179                	addi	sp,sp,-48
    800029b0:	f406                	sd	ra,40(sp)
    800029b2:	f022                	sd	s0,32(sp)
    800029b4:	ec26                	sd	s1,24(sp)
    800029b6:	e84a                	sd	s2,16(sp)
    800029b8:	e44e                	sd	s3,8(sp)
    800029ba:	1800                	addi	s0,sp,48
    800029bc:	892a                	mv	s2,a0
    bp = bread(dev, 1);
    800029be:	4585                	li	a1,1
    800029c0:	00000097          	auipc	ra,0x0
    800029c4:	a50080e7          	jalr	-1456(ra) # 80002410 <bread>
    800029c8:	84aa                	mv	s1,a0
    memmove(sb, bp->data, sizeof(*sb));
    800029ca:	00026997          	auipc	s3,0x26
    800029ce:	52e98993          	addi	s3,s3,1326 # 80028ef8 <sb>
    800029d2:	02000613          	li	a2,32
    800029d6:	05850593          	addi	a1,a0,88
    800029da:	854e                	mv	a0,s3
    800029dc:	ffffd097          	auipc	ra,0xffffd
    800029e0:	7fc080e7          	jalr	2044(ra) # 800001d8 <memmove>
    brelse(bp);
    800029e4:	8526                	mv	a0,s1
    800029e6:	00000097          	auipc	ra,0x0
    800029ea:	b5a080e7          	jalr	-1190(ra) # 80002540 <brelse>
    if (sb.magic != FSMAGIC)
    800029ee:	0009a703          	lw	a4,0(s3)
    800029f2:	102037b7          	lui	a5,0x10203
    800029f6:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800029fa:	02f71263          	bne	a4,a5,80002a1e <fsinit+0x70>
    initlog(dev, &sb);
    800029fe:	00026597          	auipc	a1,0x26
    80002a02:	4fa58593          	addi	a1,a1,1274 # 80028ef8 <sb>
    80002a06:	854a                	mv	a0,s2
    80002a08:	00001097          	auipc	ra,0x1
    80002a0c:	b40080e7          	jalr	-1216(ra) # 80003548 <initlog>
}
    80002a10:	70a2                	ld	ra,40(sp)
    80002a12:	7402                	ld	s0,32(sp)
    80002a14:	64e2                	ld	s1,24(sp)
    80002a16:	6942                	ld	s2,16(sp)
    80002a18:	69a2                	ld	s3,8(sp)
    80002a1a:	6145                	addi	sp,sp,48
    80002a1c:	8082                	ret
        panic("invalid file system");
    80002a1e:	00006517          	auipc	a0,0x6
    80002a22:	bca50513          	addi	a0,a0,-1078 # 800085e8 <syscalls+0x150>
    80002a26:	00003097          	auipc	ra,0x3
    80002a2a:	4bc080e7          	jalr	1212(ra) # 80005ee2 <panic>

0000000080002a2e <iinit>:
{
    80002a2e:	7179                	addi	sp,sp,-48
    80002a30:	f406                	sd	ra,40(sp)
    80002a32:	f022                	sd	s0,32(sp)
    80002a34:	ec26                	sd	s1,24(sp)
    80002a36:	e84a                	sd	s2,16(sp)
    80002a38:	e44e                	sd	s3,8(sp)
    80002a3a:	1800                	addi	s0,sp,48
    initlock(&itable.lock, "itable");
    80002a3c:	00006597          	auipc	a1,0x6
    80002a40:	bc458593          	addi	a1,a1,-1084 # 80008600 <syscalls+0x168>
    80002a44:	00026517          	auipc	a0,0x26
    80002a48:	4d450513          	addi	a0,a0,1236 # 80028f18 <itable>
    80002a4c:	00004097          	auipc	ra,0x4
    80002a50:	950080e7          	jalr	-1712(ra) # 8000639c <initlock>
    for (i = 0; i < NINODE; i++)
    80002a54:	00026497          	auipc	s1,0x26
    80002a58:	4ec48493          	addi	s1,s1,1260 # 80028f40 <itable+0x28>
    80002a5c:	00028997          	auipc	s3,0x28
    80002a60:	f7498993          	addi	s3,s3,-140 # 8002a9d0 <log+0x10>
        initsleeplock(&itable.inode[i].lock, "inode");
    80002a64:	00006917          	auipc	s2,0x6
    80002a68:	ba490913          	addi	s2,s2,-1116 # 80008608 <syscalls+0x170>
    80002a6c:	85ca                	mv	a1,s2
    80002a6e:	8526                	mv	a0,s1
    80002a70:	00001097          	auipc	ra,0x1
    80002a74:	e3a080e7          	jalr	-454(ra) # 800038aa <initsleeplock>
    for (i = 0; i < NINODE; i++)
    80002a78:	08848493          	addi	s1,s1,136
    80002a7c:	ff3498e3          	bne	s1,s3,80002a6c <iinit+0x3e>
}
    80002a80:	70a2                	ld	ra,40(sp)
    80002a82:	7402                	ld	s0,32(sp)
    80002a84:	64e2                	ld	s1,24(sp)
    80002a86:	6942                	ld	s2,16(sp)
    80002a88:	69a2                	ld	s3,8(sp)
    80002a8a:	6145                	addi	sp,sp,48
    80002a8c:	8082                	ret

0000000080002a8e <ialloc>:
{
    80002a8e:	715d                	addi	sp,sp,-80
    80002a90:	e486                	sd	ra,72(sp)
    80002a92:	e0a2                	sd	s0,64(sp)
    80002a94:	fc26                	sd	s1,56(sp)
    80002a96:	f84a                	sd	s2,48(sp)
    80002a98:	f44e                	sd	s3,40(sp)
    80002a9a:	f052                	sd	s4,32(sp)
    80002a9c:	ec56                	sd	s5,24(sp)
    80002a9e:	e85a                	sd	s6,16(sp)
    80002aa0:	e45e                	sd	s7,8(sp)
    80002aa2:	0880                	addi	s0,sp,80
    for (inum = 1; inum < sb.ninodes; inum++)
    80002aa4:	00026717          	auipc	a4,0x26
    80002aa8:	46072703          	lw	a4,1120(a4) # 80028f04 <sb+0xc>
    80002aac:	4785                	li	a5,1
    80002aae:	04e7fa63          	bgeu	a5,a4,80002b02 <ialloc+0x74>
    80002ab2:	8aaa                	mv	s5,a0
    80002ab4:	8bae                	mv	s7,a1
    80002ab6:	4485                	li	s1,1
        bp = bread(dev, IBLOCK(inum, sb));
    80002ab8:	00026a17          	auipc	s4,0x26
    80002abc:	440a0a13          	addi	s4,s4,1088 # 80028ef8 <sb>
    80002ac0:	00048b1b          	sext.w	s6,s1
    80002ac4:	0044d593          	srli	a1,s1,0x4
    80002ac8:	018a2783          	lw	a5,24(s4)
    80002acc:	9dbd                	addw	a1,a1,a5
    80002ace:	8556                	mv	a0,s5
    80002ad0:	00000097          	auipc	ra,0x0
    80002ad4:	940080e7          	jalr	-1728(ra) # 80002410 <bread>
    80002ad8:	892a                	mv	s2,a0
        dip = (struct dinode *)bp->data + inum % IPB;
    80002ada:	05850993          	addi	s3,a0,88
    80002ade:	00f4f793          	andi	a5,s1,15
    80002ae2:	079a                	slli	a5,a5,0x6
    80002ae4:	99be                	add	s3,s3,a5
        if (dip->type == 0)
    80002ae6:	00099783          	lh	a5,0(s3)
    80002aea:	c3a1                	beqz	a5,80002b2a <ialloc+0x9c>
        brelse(bp);
    80002aec:	00000097          	auipc	ra,0x0
    80002af0:	a54080e7          	jalr	-1452(ra) # 80002540 <brelse>
    for (inum = 1; inum < sb.ninodes; inum++)
    80002af4:	0485                	addi	s1,s1,1
    80002af6:	00ca2703          	lw	a4,12(s4)
    80002afa:	0004879b          	sext.w	a5,s1
    80002afe:	fce7e1e3          	bltu	a5,a4,80002ac0 <ialloc+0x32>
    printf("ialloc: no inodes\n");
    80002b02:	00006517          	auipc	a0,0x6
    80002b06:	b0e50513          	addi	a0,a0,-1266 # 80008610 <syscalls+0x178>
    80002b0a:	00003097          	auipc	ra,0x3
    80002b0e:	422080e7          	jalr	1058(ra) # 80005f2c <printf>
    return 0;
    80002b12:	4501                	li	a0,0
}
    80002b14:	60a6                	ld	ra,72(sp)
    80002b16:	6406                	ld	s0,64(sp)
    80002b18:	74e2                	ld	s1,56(sp)
    80002b1a:	7942                	ld	s2,48(sp)
    80002b1c:	79a2                	ld	s3,40(sp)
    80002b1e:	7a02                	ld	s4,32(sp)
    80002b20:	6ae2                	ld	s5,24(sp)
    80002b22:	6b42                	ld	s6,16(sp)
    80002b24:	6ba2                	ld	s7,8(sp)
    80002b26:	6161                	addi	sp,sp,80
    80002b28:	8082                	ret
            memset(dip, 0, sizeof(*dip));
    80002b2a:	04000613          	li	a2,64
    80002b2e:	4581                	li	a1,0
    80002b30:	854e                	mv	a0,s3
    80002b32:	ffffd097          	auipc	ra,0xffffd
    80002b36:	646080e7          	jalr	1606(ra) # 80000178 <memset>
            dip->type = type;
    80002b3a:	01799023          	sh	s7,0(s3)
            log_write(bp); // mark it allocated on the disk
    80002b3e:	854a                	mv	a0,s2
    80002b40:	00001097          	auipc	ra,0x1
    80002b44:	c84080e7          	jalr	-892(ra) # 800037c4 <log_write>
            brelse(bp);
    80002b48:	854a                	mv	a0,s2
    80002b4a:	00000097          	auipc	ra,0x0
    80002b4e:	9f6080e7          	jalr	-1546(ra) # 80002540 <brelse>
            return iget(dev, inum);
    80002b52:	85da                	mv	a1,s6
    80002b54:	8556                	mv	a0,s5
    80002b56:	00000097          	auipc	ra,0x0
    80002b5a:	d9c080e7          	jalr	-612(ra) # 800028f2 <iget>
    80002b5e:	bf5d                	j	80002b14 <ialloc+0x86>

0000000080002b60 <iupdate>:
{
    80002b60:	1101                	addi	sp,sp,-32
    80002b62:	ec06                	sd	ra,24(sp)
    80002b64:	e822                	sd	s0,16(sp)
    80002b66:	e426                	sd	s1,8(sp)
    80002b68:	e04a                	sd	s2,0(sp)
    80002b6a:	1000                	addi	s0,sp,32
    80002b6c:	84aa                	mv	s1,a0
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002b6e:	415c                	lw	a5,4(a0)
    80002b70:	0047d79b          	srliw	a5,a5,0x4
    80002b74:	00026597          	auipc	a1,0x26
    80002b78:	39c5a583          	lw	a1,924(a1) # 80028f10 <sb+0x18>
    80002b7c:	9dbd                	addw	a1,a1,a5
    80002b7e:	4108                	lw	a0,0(a0)
    80002b80:	00000097          	auipc	ra,0x0
    80002b84:	890080e7          	jalr	-1904(ra) # 80002410 <bread>
    80002b88:	892a                	mv	s2,a0
    dip = (struct dinode *)bp->data + ip->inum % IPB;
    80002b8a:	05850793          	addi	a5,a0,88
    80002b8e:	40c8                	lw	a0,4(s1)
    80002b90:	893d                	andi	a0,a0,15
    80002b92:	051a                	slli	a0,a0,0x6
    80002b94:	953e                	add	a0,a0,a5
    dip->type = ip->type;
    80002b96:	04449703          	lh	a4,68(s1)
    80002b9a:	00e51023          	sh	a4,0(a0)
    dip->major = ip->major;
    80002b9e:	04649703          	lh	a4,70(s1)
    80002ba2:	00e51123          	sh	a4,2(a0)
    dip->minor = ip->minor;
    80002ba6:	04849703          	lh	a4,72(s1)
    80002baa:	00e51223          	sh	a4,4(a0)
    dip->nlink = ip->nlink;
    80002bae:	04a49703          	lh	a4,74(s1)
    80002bb2:	00e51323          	sh	a4,6(a0)
    dip->size = ip->size;
    80002bb6:	44f8                	lw	a4,76(s1)
    80002bb8:	c518                	sw	a4,8(a0)
    memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002bba:	03400613          	li	a2,52
    80002bbe:	05048593          	addi	a1,s1,80
    80002bc2:	0531                	addi	a0,a0,12
    80002bc4:	ffffd097          	auipc	ra,0xffffd
    80002bc8:	614080e7          	jalr	1556(ra) # 800001d8 <memmove>
    log_write(bp);
    80002bcc:	854a                	mv	a0,s2
    80002bce:	00001097          	auipc	ra,0x1
    80002bd2:	bf6080e7          	jalr	-1034(ra) # 800037c4 <log_write>
    brelse(bp);
    80002bd6:	854a                	mv	a0,s2
    80002bd8:	00000097          	auipc	ra,0x0
    80002bdc:	968080e7          	jalr	-1688(ra) # 80002540 <brelse>
}
    80002be0:	60e2                	ld	ra,24(sp)
    80002be2:	6442                	ld	s0,16(sp)
    80002be4:	64a2                	ld	s1,8(sp)
    80002be6:	6902                	ld	s2,0(sp)
    80002be8:	6105                	addi	sp,sp,32
    80002bea:	8082                	ret

0000000080002bec <idup>:
{
    80002bec:	1101                	addi	sp,sp,-32
    80002bee:	ec06                	sd	ra,24(sp)
    80002bf0:	e822                	sd	s0,16(sp)
    80002bf2:	e426                	sd	s1,8(sp)
    80002bf4:	1000                	addi	s0,sp,32
    80002bf6:	84aa                	mv	s1,a0
    acquire(&itable.lock);
    80002bf8:	00026517          	auipc	a0,0x26
    80002bfc:	32050513          	addi	a0,a0,800 # 80028f18 <itable>
    80002c00:	00004097          	auipc	ra,0x4
    80002c04:	82c080e7          	jalr	-2004(ra) # 8000642c <acquire>
    ip->ref++;
    80002c08:	449c                	lw	a5,8(s1)
    80002c0a:	2785                	addiw	a5,a5,1
    80002c0c:	c49c                	sw	a5,8(s1)
    release(&itable.lock);
    80002c0e:	00026517          	auipc	a0,0x26
    80002c12:	30a50513          	addi	a0,a0,778 # 80028f18 <itable>
    80002c16:	00004097          	auipc	ra,0x4
    80002c1a:	8ca080e7          	jalr	-1846(ra) # 800064e0 <release>
}
    80002c1e:	8526                	mv	a0,s1
    80002c20:	60e2                	ld	ra,24(sp)
    80002c22:	6442                	ld	s0,16(sp)
    80002c24:	64a2                	ld	s1,8(sp)
    80002c26:	6105                	addi	sp,sp,32
    80002c28:	8082                	ret

0000000080002c2a <ilock>:
{
    80002c2a:	1101                	addi	sp,sp,-32
    80002c2c:	ec06                	sd	ra,24(sp)
    80002c2e:	e822                	sd	s0,16(sp)
    80002c30:	e426                	sd	s1,8(sp)
    80002c32:	e04a                	sd	s2,0(sp)
    80002c34:	1000                	addi	s0,sp,32
    if (ip == 0 || ip->ref < 1)
    80002c36:	c115                	beqz	a0,80002c5a <ilock+0x30>
    80002c38:	84aa                	mv	s1,a0
    80002c3a:	451c                	lw	a5,8(a0)
    80002c3c:	00f05f63          	blez	a5,80002c5a <ilock+0x30>
    acquiresleep(&ip->lock);
    80002c40:	0541                	addi	a0,a0,16
    80002c42:	00001097          	auipc	ra,0x1
    80002c46:	ca2080e7          	jalr	-862(ra) # 800038e4 <acquiresleep>
    if (ip->valid == 0)
    80002c4a:	40bc                	lw	a5,64(s1)
    80002c4c:	cf99                	beqz	a5,80002c6a <ilock+0x40>
}
    80002c4e:	60e2                	ld	ra,24(sp)
    80002c50:	6442                	ld	s0,16(sp)
    80002c52:	64a2                	ld	s1,8(sp)
    80002c54:	6902                	ld	s2,0(sp)
    80002c56:	6105                	addi	sp,sp,32
    80002c58:	8082                	ret
        panic("ilock");
    80002c5a:	00006517          	auipc	a0,0x6
    80002c5e:	9ce50513          	addi	a0,a0,-1586 # 80008628 <syscalls+0x190>
    80002c62:	00003097          	auipc	ra,0x3
    80002c66:	280080e7          	jalr	640(ra) # 80005ee2 <panic>
        bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002c6a:	40dc                	lw	a5,4(s1)
    80002c6c:	0047d79b          	srliw	a5,a5,0x4
    80002c70:	00026597          	auipc	a1,0x26
    80002c74:	2a05a583          	lw	a1,672(a1) # 80028f10 <sb+0x18>
    80002c78:	9dbd                	addw	a1,a1,a5
    80002c7a:	4088                	lw	a0,0(s1)
    80002c7c:	fffff097          	auipc	ra,0xfffff
    80002c80:	794080e7          	jalr	1940(ra) # 80002410 <bread>
    80002c84:	892a                	mv	s2,a0
        dip = (struct dinode *)bp->data + ip->inum % IPB;
    80002c86:	05850593          	addi	a1,a0,88
    80002c8a:	40dc                	lw	a5,4(s1)
    80002c8c:	8bbd                	andi	a5,a5,15
    80002c8e:	079a                	slli	a5,a5,0x6
    80002c90:	95be                	add	a1,a1,a5
        ip->type = dip->type;
    80002c92:	00059783          	lh	a5,0(a1)
    80002c96:	04f49223          	sh	a5,68(s1)
        ip->major = dip->major;
    80002c9a:	00259783          	lh	a5,2(a1)
    80002c9e:	04f49323          	sh	a5,70(s1)
        ip->minor = dip->minor;
    80002ca2:	00459783          	lh	a5,4(a1)
    80002ca6:	04f49423          	sh	a5,72(s1)
        ip->nlink = dip->nlink;
    80002caa:	00659783          	lh	a5,6(a1)
    80002cae:	04f49523          	sh	a5,74(s1)
        ip->size = dip->size;
    80002cb2:	459c                	lw	a5,8(a1)
    80002cb4:	c4fc                	sw	a5,76(s1)
        memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002cb6:	03400613          	li	a2,52
    80002cba:	05b1                	addi	a1,a1,12
    80002cbc:	05048513          	addi	a0,s1,80
    80002cc0:	ffffd097          	auipc	ra,0xffffd
    80002cc4:	518080e7          	jalr	1304(ra) # 800001d8 <memmove>
        brelse(bp);
    80002cc8:	854a                	mv	a0,s2
    80002cca:	00000097          	auipc	ra,0x0
    80002cce:	876080e7          	jalr	-1930(ra) # 80002540 <brelse>
        ip->valid = 1;
    80002cd2:	4785                	li	a5,1
    80002cd4:	c0bc                	sw	a5,64(s1)
        if (ip->type == 0)
    80002cd6:	04449783          	lh	a5,68(s1)
    80002cda:	fbb5                	bnez	a5,80002c4e <ilock+0x24>
            panic("ilock: no type");
    80002cdc:	00006517          	auipc	a0,0x6
    80002ce0:	95450513          	addi	a0,a0,-1708 # 80008630 <syscalls+0x198>
    80002ce4:	00003097          	auipc	ra,0x3
    80002ce8:	1fe080e7          	jalr	510(ra) # 80005ee2 <panic>

0000000080002cec <iunlock>:
{
    80002cec:	1101                	addi	sp,sp,-32
    80002cee:	ec06                	sd	ra,24(sp)
    80002cf0:	e822                	sd	s0,16(sp)
    80002cf2:	e426                	sd	s1,8(sp)
    80002cf4:	e04a                	sd	s2,0(sp)
    80002cf6:	1000                	addi	s0,sp,32
    if (ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002cf8:	c905                	beqz	a0,80002d28 <iunlock+0x3c>
    80002cfa:	84aa                	mv	s1,a0
    80002cfc:	01050913          	addi	s2,a0,16
    80002d00:	854a                	mv	a0,s2
    80002d02:	00001097          	auipc	ra,0x1
    80002d06:	c7c080e7          	jalr	-900(ra) # 8000397e <holdingsleep>
    80002d0a:	cd19                	beqz	a0,80002d28 <iunlock+0x3c>
    80002d0c:	449c                	lw	a5,8(s1)
    80002d0e:	00f05d63          	blez	a5,80002d28 <iunlock+0x3c>
    releasesleep(&ip->lock);
    80002d12:	854a                	mv	a0,s2
    80002d14:	00001097          	auipc	ra,0x1
    80002d18:	c26080e7          	jalr	-986(ra) # 8000393a <releasesleep>
}
    80002d1c:	60e2                	ld	ra,24(sp)
    80002d1e:	6442                	ld	s0,16(sp)
    80002d20:	64a2                	ld	s1,8(sp)
    80002d22:	6902                	ld	s2,0(sp)
    80002d24:	6105                	addi	sp,sp,32
    80002d26:	8082                	ret
        panic("iunlock");
    80002d28:	00006517          	auipc	a0,0x6
    80002d2c:	91850513          	addi	a0,a0,-1768 # 80008640 <syscalls+0x1a8>
    80002d30:	00003097          	auipc	ra,0x3
    80002d34:	1b2080e7          	jalr	434(ra) # 80005ee2 <panic>

0000000080002d38 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void itrunc(struct inode *ip)
{
    80002d38:	7179                	addi	sp,sp,-48
    80002d3a:	f406                	sd	ra,40(sp)
    80002d3c:	f022                	sd	s0,32(sp)
    80002d3e:	ec26                	sd	s1,24(sp)
    80002d40:	e84a                	sd	s2,16(sp)
    80002d42:	e44e                	sd	s3,8(sp)
    80002d44:	e052                	sd	s4,0(sp)
    80002d46:	1800                	addi	s0,sp,48
    80002d48:	89aa                	mv	s3,a0
    int i, j;
    struct buf *bp;
    uint *a;

    for (i = 0; i < NDIRECT; i++)
    80002d4a:	05050493          	addi	s1,a0,80
    80002d4e:	08050913          	addi	s2,a0,128
    80002d52:	a021                	j	80002d5a <itrunc+0x22>
    80002d54:	0491                	addi	s1,s1,4
    80002d56:	01248d63          	beq	s1,s2,80002d70 <itrunc+0x38>
    {
        if (ip->addrs[i])
    80002d5a:	408c                	lw	a1,0(s1)
    80002d5c:	dde5                	beqz	a1,80002d54 <itrunc+0x1c>
        {
            bfree(ip->dev, ip->addrs[i]);
    80002d5e:	0009a503          	lw	a0,0(s3)
    80002d62:	00000097          	auipc	ra,0x0
    80002d66:	8f4080e7          	jalr	-1804(ra) # 80002656 <bfree>
            ip->addrs[i] = 0;
    80002d6a:	0004a023          	sw	zero,0(s1)
    80002d6e:	b7dd                	j	80002d54 <itrunc+0x1c>
        }
    }

    if (ip->addrs[NDIRECT])
    80002d70:	0809a583          	lw	a1,128(s3)
    80002d74:	e185                	bnez	a1,80002d94 <itrunc+0x5c>
        brelse(bp);
        bfree(ip->dev, ip->addrs[NDIRECT]);
        ip->addrs[NDIRECT] = 0;
    }

    ip->size = 0;
    80002d76:	0409a623          	sw	zero,76(s3)
    iupdate(ip);
    80002d7a:	854e                	mv	a0,s3
    80002d7c:	00000097          	auipc	ra,0x0
    80002d80:	de4080e7          	jalr	-540(ra) # 80002b60 <iupdate>
}
    80002d84:	70a2                	ld	ra,40(sp)
    80002d86:	7402                	ld	s0,32(sp)
    80002d88:	64e2                	ld	s1,24(sp)
    80002d8a:	6942                	ld	s2,16(sp)
    80002d8c:	69a2                	ld	s3,8(sp)
    80002d8e:	6a02                	ld	s4,0(sp)
    80002d90:	6145                	addi	sp,sp,48
    80002d92:	8082                	ret
        bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002d94:	0009a503          	lw	a0,0(s3)
    80002d98:	fffff097          	auipc	ra,0xfffff
    80002d9c:	678080e7          	jalr	1656(ra) # 80002410 <bread>
    80002da0:	8a2a                	mv	s4,a0
        for (j = 0; j < NINDIRECT; j++)
    80002da2:	05850493          	addi	s1,a0,88
    80002da6:	45850913          	addi	s2,a0,1112
    80002daa:	a811                	j	80002dbe <itrunc+0x86>
                bfree(ip->dev, a[j]);
    80002dac:	0009a503          	lw	a0,0(s3)
    80002db0:	00000097          	auipc	ra,0x0
    80002db4:	8a6080e7          	jalr	-1882(ra) # 80002656 <bfree>
        for (j = 0; j < NINDIRECT; j++)
    80002db8:	0491                	addi	s1,s1,4
    80002dba:	01248563          	beq	s1,s2,80002dc4 <itrunc+0x8c>
            if (a[j])
    80002dbe:	408c                	lw	a1,0(s1)
    80002dc0:	dde5                	beqz	a1,80002db8 <itrunc+0x80>
    80002dc2:	b7ed                	j	80002dac <itrunc+0x74>
        brelse(bp);
    80002dc4:	8552                	mv	a0,s4
    80002dc6:	fffff097          	auipc	ra,0xfffff
    80002dca:	77a080e7          	jalr	1914(ra) # 80002540 <brelse>
        bfree(ip->dev, ip->addrs[NDIRECT]);
    80002dce:	0809a583          	lw	a1,128(s3)
    80002dd2:	0009a503          	lw	a0,0(s3)
    80002dd6:	00000097          	auipc	ra,0x0
    80002dda:	880080e7          	jalr	-1920(ra) # 80002656 <bfree>
        ip->addrs[NDIRECT] = 0;
    80002dde:	0809a023          	sw	zero,128(s3)
    80002de2:	bf51                	j	80002d76 <itrunc+0x3e>

0000000080002de4 <iput>:
{
    80002de4:	1101                	addi	sp,sp,-32
    80002de6:	ec06                	sd	ra,24(sp)
    80002de8:	e822                	sd	s0,16(sp)
    80002dea:	e426                	sd	s1,8(sp)
    80002dec:	e04a                	sd	s2,0(sp)
    80002dee:	1000                	addi	s0,sp,32
    80002df0:	84aa                	mv	s1,a0
    acquire(&itable.lock);
    80002df2:	00026517          	auipc	a0,0x26
    80002df6:	12650513          	addi	a0,a0,294 # 80028f18 <itable>
    80002dfa:	00003097          	auipc	ra,0x3
    80002dfe:	632080e7          	jalr	1586(ra) # 8000642c <acquire>
    if (ip->ref == 1 && ip->valid && ip->nlink == 0)
    80002e02:	4498                	lw	a4,8(s1)
    80002e04:	4785                	li	a5,1
    80002e06:	02f70363          	beq	a4,a5,80002e2c <iput+0x48>
    ip->ref--;
    80002e0a:	449c                	lw	a5,8(s1)
    80002e0c:	37fd                	addiw	a5,a5,-1
    80002e0e:	c49c                	sw	a5,8(s1)
    release(&itable.lock);
    80002e10:	00026517          	auipc	a0,0x26
    80002e14:	10850513          	addi	a0,a0,264 # 80028f18 <itable>
    80002e18:	00003097          	auipc	ra,0x3
    80002e1c:	6c8080e7          	jalr	1736(ra) # 800064e0 <release>
}
    80002e20:	60e2                	ld	ra,24(sp)
    80002e22:	6442                	ld	s0,16(sp)
    80002e24:	64a2                	ld	s1,8(sp)
    80002e26:	6902                	ld	s2,0(sp)
    80002e28:	6105                	addi	sp,sp,32
    80002e2a:	8082                	ret
    if (ip->ref == 1 && ip->valid && ip->nlink == 0)
    80002e2c:	40bc                	lw	a5,64(s1)
    80002e2e:	dff1                	beqz	a5,80002e0a <iput+0x26>
    80002e30:	04a49783          	lh	a5,74(s1)
    80002e34:	fbf9                	bnez	a5,80002e0a <iput+0x26>
        acquiresleep(&ip->lock);
    80002e36:	01048913          	addi	s2,s1,16
    80002e3a:	854a                	mv	a0,s2
    80002e3c:	00001097          	auipc	ra,0x1
    80002e40:	aa8080e7          	jalr	-1368(ra) # 800038e4 <acquiresleep>
        release(&itable.lock);
    80002e44:	00026517          	auipc	a0,0x26
    80002e48:	0d450513          	addi	a0,a0,212 # 80028f18 <itable>
    80002e4c:	00003097          	auipc	ra,0x3
    80002e50:	694080e7          	jalr	1684(ra) # 800064e0 <release>
        itrunc(ip);
    80002e54:	8526                	mv	a0,s1
    80002e56:	00000097          	auipc	ra,0x0
    80002e5a:	ee2080e7          	jalr	-286(ra) # 80002d38 <itrunc>
        ip->type = 0;
    80002e5e:	04049223          	sh	zero,68(s1)
        iupdate(ip);
    80002e62:	8526                	mv	a0,s1
    80002e64:	00000097          	auipc	ra,0x0
    80002e68:	cfc080e7          	jalr	-772(ra) # 80002b60 <iupdate>
        ip->valid = 0;
    80002e6c:	0404a023          	sw	zero,64(s1)
        releasesleep(&ip->lock);
    80002e70:	854a                	mv	a0,s2
    80002e72:	00001097          	auipc	ra,0x1
    80002e76:	ac8080e7          	jalr	-1336(ra) # 8000393a <releasesleep>
        acquire(&itable.lock);
    80002e7a:	00026517          	auipc	a0,0x26
    80002e7e:	09e50513          	addi	a0,a0,158 # 80028f18 <itable>
    80002e82:	00003097          	auipc	ra,0x3
    80002e86:	5aa080e7          	jalr	1450(ra) # 8000642c <acquire>
    80002e8a:	b741                	j	80002e0a <iput+0x26>

0000000080002e8c <iunlockput>:
{
    80002e8c:	1101                	addi	sp,sp,-32
    80002e8e:	ec06                	sd	ra,24(sp)
    80002e90:	e822                	sd	s0,16(sp)
    80002e92:	e426                	sd	s1,8(sp)
    80002e94:	1000                	addi	s0,sp,32
    80002e96:	84aa                	mv	s1,a0
    iunlock(ip);
    80002e98:	00000097          	auipc	ra,0x0
    80002e9c:	e54080e7          	jalr	-428(ra) # 80002cec <iunlock>
    iput(ip);
    80002ea0:	8526                	mv	a0,s1
    80002ea2:	00000097          	auipc	ra,0x0
    80002ea6:	f42080e7          	jalr	-190(ra) # 80002de4 <iput>
}
    80002eaa:	60e2                	ld	ra,24(sp)
    80002eac:	6442                	ld	s0,16(sp)
    80002eae:	64a2                	ld	s1,8(sp)
    80002eb0:	6105                	addi	sp,sp,32
    80002eb2:	8082                	ret

0000000080002eb4 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void stati(struct inode *ip, struct stat *st)
{
    80002eb4:	1141                	addi	sp,sp,-16
    80002eb6:	e422                	sd	s0,8(sp)
    80002eb8:	0800                	addi	s0,sp,16
    st->dev = ip->dev;
    80002eba:	411c                	lw	a5,0(a0)
    80002ebc:	c19c                	sw	a5,0(a1)
    st->ino = ip->inum;
    80002ebe:	415c                	lw	a5,4(a0)
    80002ec0:	c1dc                	sw	a5,4(a1)
    st->type = ip->type;
    80002ec2:	04451783          	lh	a5,68(a0)
    80002ec6:	00f59423          	sh	a5,8(a1)
    st->nlink = ip->nlink;
    80002eca:	04a51783          	lh	a5,74(a0)
    80002ece:	00f59523          	sh	a5,10(a1)
    st->size = ip->size;
    80002ed2:	04c56783          	lwu	a5,76(a0)
    80002ed6:	e99c                	sd	a5,16(a1)
}
    80002ed8:	6422                	ld	s0,8(sp)
    80002eda:	0141                	addi	sp,sp,16
    80002edc:	8082                	ret

0000000080002ede <readi>:
int readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
    uint tot, m;
    struct buf *bp;

    if (off > ip->size || off + n < off)
    80002ede:	457c                	lw	a5,76(a0)
    80002ee0:	0ed7e963          	bltu	a5,a3,80002fd2 <readi+0xf4>
{
    80002ee4:	7159                	addi	sp,sp,-112
    80002ee6:	f486                	sd	ra,104(sp)
    80002ee8:	f0a2                	sd	s0,96(sp)
    80002eea:	eca6                	sd	s1,88(sp)
    80002eec:	e8ca                	sd	s2,80(sp)
    80002eee:	e4ce                	sd	s3,72(sp)
    80002ef0:	e0d2                	sd	s4,64(sp)
    80002ef2:	fc56                	sd	s5,56(sp)
    80002ef4:	f85a                	sd	s6,48(sp)
    80002ef6:	f45e                	sd	s7,40(sp)
    80002ef8:	f062                	sd	s8,32(sp)
    80002efa:	ec66                	sd	s9,24(sp)
    80002efc:	e86a                	sd	s10,16(sp)
    80002efe:	e46e                	sd	s11,8(sp)
    80002f00:	1880                	addi	s0,sp,112
    80002f02:	8b2a                	mv	s6,a0
    80002f04:	8bae                	mv	s7,a1
    80002f06:	8a32                	mv	s4,a2
    80002f08:	84b6                	mv	s1,a3
    80002f0a:	8aba                	mv	s5,a4
    if (off > ip->size || off + n < off)
    80002f0c:	9f35                	addw	a4,a4,a3
        return 0;
    80002f0e:	4501                	li	a0,0
    if (off > ip->size || off + n < off)
    80002f10:	0ad76063          	bltu	a4,a3,80002fb0 <readi+0xd2>
    if (off + n > ip->size)
    80002f14:	00e7f463          	bgeu	a5,a4,80002f1c <readi+0x3e>
        n = ip->size - off;
    80002f18:	40d78abb          	subw	s5,a5,a3

    for (tot = 0; tot < n; tot += m, off += m, dst += m)
    80002f1c:	0a0a8963          	beqz	s5,80002fce <readi+0xf0>
    80002f20:	4981                	li	s3,0
    {
        uint addr = bmap(ip, off / BSIZE);
        if (addr == 0)
            break;
        bp = bread(ip->dev, addr);
        m = min(n - tot, BSIZE - off % BSIZE);
    80002f22:	40000c93          	li	s9,1024
        if (either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1)
    80002f26:	5c7d                	li	s8,-1
    80002f28:	a82d                	j	80002f62 <readi+0x84>
    80002f2a:	020d1d93          	slli	s11,s10,0x20
    80002f2e:	020ddd93          	srli	s11,s11,0x20
    80002f32:	05890613          	addi	a2,s2,88
    80002f36:	86ee                	mv	a3,s11
    80002f38:	963a                	add	a2,a2,a4
    80002f3a:	85d2                	mv	a1,s4
    80002f3c:	855e                	mv	a0,s7
    80002f3e:	fffff097          	auipc	ra,0xfffff
    80002f42:	9d0080e7          	jalr	-1584(ra) # 8000190e <either_copyout>
    80002f46:	05850d63          	beq	a0,s8,80002fa0 <readi+0xc2>
        {
            brelse(bp);
            tot = -1;
            break;
        }
        brelse(bp);
    80002f4a:	854a                	mv	a0,s2
    80002f4c:	fffff097          	auipc	ra,0xfffff
    80002f50:	5f4080e7          	jalr	1524(ra) # 80002540 <brelse>
    for (tot = 0; tot < n; tot += m, off += m, dst += m)
    80002f54:	013d09bb          	addw	s3,s10,s3
    80002f58:	009d04bb          	addw	s1,s10,s1
    80002f5c:	9a6e                	add	s4,s4,s11
    80002f5e:	0559f763          	bgeu	s3,s5,80002fac <readi+0xce>
        uint addr = bmap(ip, off / BSIZE);
    80002f62:	00a4d59b          	srliw	a1,s1,0xa
    80002f66:	855a                	mv	a0,s6
    80002f68:	00000097          	auipc	ra,0x0
    80002f6c:	8a2080e7          	jalr	-1886(ra) # 8000280a <bmap>
    80002f70:	0005059b          	sext.w	a1,a0
        if (addr == 0)
    80002f74:	cd85                	beqz	a1,80002fac <readi+0xce>
        bp = bread(ip->dev, addr);
    80002f76:	000b2503          	lw	a0,0(s6)
    80002f7a:	fffff097          	auipc	ra,0xfffff
    80002f7e:	496080e7          	jalr	1174(ra) # 80002410 <bread>
    80002f82:	892a                	mv	s2,a0
        m = min(n - tot, BSIZE - off % BSIZE);
    80002f84:	3ff4f713          	andi	a4,s1,1023
    80002f88:	40ec87bb          	subw	a5,s9,a4
    80002f8c:	413a86bb          	subw	a3,s5,s3
    80002f90:	8d3e                	mv	s10,a5
    80002f92:	2781                	sext.w	a5,a5
    80002f94:	0006861b          	sext.w	a2,a3
    80002f98:	f8f679e3          	bgeu	a2,a5,80002f2a <readi+0x4c>
    80002f9c:	8d36                	mv	s10,a3
    80002f9e:	b771                	j	80002f2a <readi+0x4c>
            brelse(bp);
    80002fa0:	854a                	mv	a0,s2
    80002fa2:	fffff097          	auipc	ra,0xfffff
    80002fa6:	59e080e7          	jalr	1438(ra) # 80002540 <brelse>
            tot = -1;
    80002faa:	59fd                	li	s3,-1
    }
    return tot;
    80002fac:	0009851b          	sext.w	a0,s3
}
    80002fb0:	70a6                	ld	ra,104(sp)
    80002fb2:	7406                	ld	s0,96(sp)
    80002fb4:	64e6                	ld	s1,88(sp)
    80002fb6:	6946                	ld	s2,80(sp)
    80002fb8:	69a6                	ld	s3,72(sp)
    80002fba:	6a06                	ld	s4,64(sp)
    80002fbc:	7ae2                	ld	s5,56(sp)
    80002fbe:	7b42                	ld	s6,48(sp)
    80002fc0:	7ba2                	ld	s7,40(sp)
    80002fc2:	7c02                	ld	s8,32(sp)
    80002fc4:	6ce2                	ld	s9,24(sp)
    80002fc6:	6d42                	ld	s10,16(sp)
    80002fc8:	6da2                	ld	s11,8(sp)
    80002fca:	6165                	addi	sp,sp,112
    80002fcc:	8082                	ret
    for (tot = 0; tot < n; tot += m, off += m, dst += m)
    80002fce:	89d6                	mv	s3,s5
    80002fd0:	bff1                	j	80002fac <readi+0xce>
        return 0;
    80002fd2:	4501                	li	a0,0
}
    80002fd4:	8082                	ret

0000000080002fd6 <writei>:
int writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
    uint tot, m;
    struct buf *bp;

    if (off > ip->size || off + n < off)
    80002fd6:	457c                	lw	a5,76(a0)
    80002fd8:	10d7e863          	bltu	a5,a3,800030e8 <writei+0x112>
{
    80002fdc:	7159                	addi	sp,sp,-112
    80002fde:	f486                	sd	ra,104(sp)
    80002fe0:	f0a2                	sd	s0,96(sp)
    80002fe2:	eca6                	sd	s1,88(sp)
    80002fe4:	e8ca                	sd	s2,80(sp)
    80002fe6:	e4ce                	sd	s3,72(sp)
    80002fe8:	e0d2                	sd	s4,64(sp)
    80002fea:	fc56                	sd	s5,56(sp)
    80002fec:	f85a                	sd	s6,48(sp)
    80002fee:	f45e                	sd	s7,40(sp)
    80002ff0:	f062                	sd	s8,32(sp)
    80002ff2:	ec66                	sd	s9,24(sp)
    80002ff4:	e86a                	sd	s10,16(sp)
    80002ff6:	e46e                	sd	s11,8(sp)
    80002ff8:	1880                	addi	s0,sp,112
    80002ffa:	8aaa                	mv	s5,a0
    80002ffc:	8bae                	mv	s7,a1
    80002ffe:	8a32                	mv	s4,a2
    80003000:	8936                	mv	s2,a3
    80003002:	8b3a                	mv	s6,a4
    if (off > ip->size || off + n < off)
    80003004:	00e687bb          	addw	a5,a3,a4
    80003008:	0ed7e263          	bltu	a5,a3,800030ec <writei+0x116>
        return -1;
    if (off + n > MAXFILE * BSIZE)
    8000300c:	00043737          	lui	a4,0x43
    80003010:	0ef76063          	bltu	a4,a5,800030f0 <writei+0x11a>
        return -1;

    for (tot = 0; tot < n; tot += m, off += m, src += m)
    80003014:	0c0b0863          	beqz	s6,800030e4 <writei+0x10e>
    80003018:	4981                	li	s3,0
    {
        uint addr = bmap(ip, off / BSIZE);
        if (addr == 0)
            break;
        bp = bread(ip->dev, addr);
        m = min(n - tot, BSIZE - off % BSIZE);
    8000301a:	40000c93          	li	s9,1024
        if (either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1)
    8000301e:	5c7d                	li	s8,-1
    80003020:	a091                	j	80003064 <writei+0x8e>
    80003022:	020d1d93          	slli	s11,s10,0x20
    80003026:	020ddd93          	srli	s11,s11,0x20
    8000302a:	05848513          	addi	a0,s1,88
    8000302e:	86ee                	mv	a3,s11
    80003030:	8652                	mv	a2,s4
    80003032:	85de                	mv	a1,s7
    80003034:	953a                	add	a0,a0,a4
    80003036:	fffff097          	auipc	ra,0xfffff
    8000303a:	92e080e7          	jalr	-1746(ra) # 80001964 <either_copyin>
    8000303e:	07850263          	beq	a0,s8,800030a2 <writei+0xcc>
        {
            brelse(bp);
            break;
        }
        log_write(bp);
    80003042:	8526                	mv	a0,s1
    80003044:	00000097          	auipc	ra,0x0
    80003048:	780080e7          	jalr	1920(ra) # 800037c4 <log_write>
        brelse(bp);
    8000304c:	8526                	mv	a0,s1
    8000304e:	fffff097          	auipc	ra,0xfffff
    80003052:	4f2080e7          	jalr	1266(ra) # 80002540 <brelse>
    for (tot = 0; tot < n; tot += m, off += m, src += m)
    80003056:	013d09bb          	addw	s3,s10,s3
    8000305a:	012d093b          	addw	s2,s10,s2
    8000305e:	9a6e                	add	s4,s4,s11
    80003060:	0569f663          	bgeu	s3,s6,800030ac <writei+0xd6>
        uint addr = bmap(ip, off / BSIZE);
    80003064:	00a9559b          	srliw	a1,s2,0xa
    80003068:	8556                	mv	a0,s5
    8000306a:	fffff097          	auipc	ra,0xfffff
    8000306e:	7a0080e7          	jalr	1952(ra) # 8000280a <bmap>
    80003072:	0005059b          	sext.w	a1,a0
        if (addr == 0)
    80003076:	c99d                	beqz	a1,800030ac <writei+0xd6>
        bp = bread(ip->dev, addr);
    80003078:	000aa503          	lw	a0,0(s5)
    8000307c:	fffff097          	auipc	ra,0xfffff
    80003080:	394080e7          	jalr	916(ra) # 80002410 <bread>
    80003084:	84aa                	mv	s1,a0
        m = min(n - tot, BSIZE - off % BSIZE);
    80003086:	3ff97713          	andi	a4,s2,1023
    8000308a:	40ec87bb          	subw	a5,s9,a4
    8000308e:	413b06bb          	subw	a3,s6,s3
    80003092:	8d3e                	mv	s10,a5
    80003094:	2781                	sext.w	a5,a5
    80003096:	0006861b          	sext.w	a2,a3
    8000309a:	f8f674e3          	bgeu	a2,a5,80003022 <writei+0x4c>
    8000309e:	8d36                	mv	s10,a3
    800030a0:	b749                	j	80003022 <writei+0x4c>
            brelse(bp);
    800030a2:	8526                	mv	a0,s1
    800030a4:	fffff097          	auipc	ra,0xfffff
    800030a8:	49c080e7          	jalr	1180(ra) # 80002540 <brelse>
    }

    if (off > ip->size)
    800030ac:	04caa783          	lw	a5,76(s5)
    800030b0:	0127f463          	bgeu	a5,s2,800030b8 <writei+0xe2>
        ip->size = off;
    800030b4:	052aa623          	sw	s2,76(s5)

    // write the i-node back to disk even if the size didn't change
    // because the loop above might have called bmap() and added a new
    // block to ip->addrs[].
    iupdate(ip);
    800030b8:	8556                	mv	a0,s5
    800030ba:	00000097          	auipc	ra,0x0
    800030be:	aa6080e7          	jalr	-1370(ra) # 80002b60 <iupdate>

    return tot;
    800030c2:	0009851b          	sext.w	a0,s3
}
    800030c6:	70a6                	ld	ra,104(sp)
    800030c8:	7406                	ld	s0,96(sp)
    800030ca:	64e6                	ld	s1,88(sp)
    800030cc:	6946                	ld	s2,80(sp)
    800030ce:	69a6                	ld	s3,72(sp)
    800030d0:	6a06                	ld	s4,64(sp)
    800030d2:	7ae2                	ld	s5,56(sp)
    800030d4:	7b42                	ld	s6,48(sp)
    800030d6:	7ba2                	ld	s7,40(sp)
    800030d8:	7c02                	ld	s8,32(sp)
    800030da:	6ce2                	ld	s9,24(sp)
    800030dc:	6d42                	ld	s10,16(sp)
    800030de:	6da2                	ld	s11,8(sp)
    800030e0:	6165                	addi	sp,sp,112
    800030e2:	8082                	ret
    for (tot = 0; tot < n; tot += m, off += m, src += m)
    800030e4:	89da                	mv	s3,s6
    800030e6:	bfc9                	j	800030b8 <writei+0xe2>
        return -1;
    800030e8:	557d                	li	a0,-1
}
    800030ea:	8082                	ret
        return -1;
    800030ec:	557d                	li	a0,-1
    800030ee:	bfe1                	j	800030c6 <writei+0xf0>
        return -1;
    800030f0:	557d                	li	a0,-1
    800030f2:	bfd1                	j	800030c6 <writei+0xf0>

00000000800030f4 <namecmp>:

// Directories

int namecmp(const char *s, const char *t)
{
    800030f4:	1141                	addi	sp,sp,-16
    800030f6:	e406                	sd	ra,8(sp)
    800030f8:	e022                	sd	s0,0(sp)
    800030fa:	0800                	addi	s0,sp,16
    return strncmp(s, t, DIRSIZ);
    800030fc:	4639                	li	a2,14
    800030fe:	ffffd097          	auipc	ra,0xffffd
    80003102:	152080e7          	jalr	338(ra) # 80000250 <strncmp>
}
    80003106:	60a2                	ld	ra,8(sp)
    80003108:	6402                	ld	s0,0(sp)
    8000310a:	0141                	addi	sp,sp,16
    8000310c:	8082                	ret

000000008000310e <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode *
dirlookup(struct inode *dp, char *name, uint *poff)
{
    8000310e:	7139                	addi	sp,sp,-64
    80003110:	fc06                	sd	ra,56(sp)
    80003112:	f822                	sd	s0,48(sp)
    80003114:	f426                	sd	s1,40(sp)
    80003116:	f04a                	sd	s2,32(sp)
    80003118:	ec4e                	sd	s3,24(sp)
    8000311a:	e852                	sd	s4,16(sp)
    8000311c:	0080                	addi	s0,sp,64
    uint off, inum;
    struct dirent de;

    if (dp->type != T_DIR)
    8000311e:	04451703          	lh	a4,68(a0)
    80003122:	4785                	li	a5,1
    80003124:	00f71a63          	bne	a4,a5,80003138 <dirlookup+0x2a>
    80003128:	892a                	mv	s2,a0
    8000312a:	89ae                	mv	s3,a1
    8000312c:	8a32                	mv	s4,a2
        panic("dirlookup not DIR");

    for (off = 0; off < dp->size; off += sizeof(de))
    8000312e:	457c                	lw	a5,76(a0)
    80003130:	4481                	li	s1,0
            inum = de.inum;
            return iget(dp->dev, inum);
        }
    }

    return 0;
    80003132:	4501                	li	a0,0
    for (off = 0; off < dp->size; off += sizeof(de))
    80003134:	e79d                	bnez	a5,80003162 <dirlookup+0x54>
    80003136:	a8a5                	j	800031ae <dirlookup+0xa0>
        panic("dirlookup not DIR");
    80003138:	00005517          	auipc	a0,0x5
    8000313c:	51050513          	addi	a0,a0,1296 # 80008648 <syscalls+0x1b0>
    80003140:	00003097          	auipc	ra,0x3
    80003144:	da2080e7          	jalr	-606(ra) # 80005ee2 <panic>
            panic("dirlookup read");
    80003148:	00005517          	auipc	a0,0x5
    8000314c:	51850513          	addi	a0,a0,1304 # 80008660 <syscalls+0x1c8>
    80003150:	00003097          	auipc	ra,0x3
    80003154:	d92080e7          	jalr	-622(ra) # 80005ee2 <panic>
    for (off = 0; off < dp->size; off += sizeof(de))
    80003158:	24c1                	addiw	s1,s1,16
    8000315a:	04c92783          	lw	a5,76(s2)
    8000315e:	04f4f763          	bgeu	s1,a5,800031ac <dirlookup+0x9e>
        if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003162:	4741                	li	a4,16
    80003164:	86a6                	mv	a3,s1
    80003166:	fc040613          	addi	a2,s0,-64
    8000316a:	4581                	li	a1,0
    8000316c:	854a                	mv	a0,s2
    8000316e:	00000097          	auipc	ra,0x0
    80003172:	d70080e7          	jalr	-656(ra) # 80002ede <readi>
    80003176:	47c1                	li	a5,16
    80003178:	fcf518e3          	bne	a0,a5,80003148 <dirlookup+0x3a>
        if (de.inum == 0)
    8000317c:	fc045783          	lhu	a5,-64(s0)
    80003180:	dfe1                	beqz	a5,80003158 <dirlookup+0x4a>
        if (namecmp(name, de.name) == 0)
    80003182:	fc240593          	addi	a1,s0,-62
    80003186:	854e                	mv	a0,s3
    80003188:	00000097          	auipc	ra,0x0
    8000318c:	f6c080e7          	jalr	-148(ra) # 800030f4 <namecmp>
    80003190:	f561                	bnez	a0,80003158 <dirlookup+0x4a>
            if (poff)
    80003192:	000a0463          	beqz	s4,8000319a <dirlookup+0x8c>
                *poff = off;
    80003196:	009a2023          	sw	s1,0(s4)
            return iget(dp->dev, inum);
    8000319a:	fc045583          	lhu	a1,-64(s0)
    8000319e:	00092503          	lw	a0,0(s2)
    800031a2:	fffff097          	auipc	ra,0xfffff
    800031a6:	750080e7          	jalr	1872(ra) # 800028f2 <iget>
    800031aa:	a011                	j	800031ae <dirlookup+0xa0>
    return 0;
    800031ac:	4501                	li	a0,0
}
    800031ae:	70e2                	ld	ra,56(sp)
    800031b0:	7442                	ld	s0,48(sp)
    800031b2:	74a2                	ld	s1,40(sp)
    800031b4:	7902                	ld	s2,32(sp)
    800031b6:	69e2                	ld	s3,24(sp)
    800031b8:	6a42                	ld	s4,16(sp)
    800031ba:	6121                	addi	sp,sp,64
    800031bc:	8082                	ret

00000000800031be <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode *
namex(char *path, int nameiparent, char *name)
{
    800031be:	711d                	addi	sp,sp,-96
    800031c0:	ec86                	sd	ra,88(sp)
    800031c2:	e8a2                	sd	s0,80(sp)
    800031c4:	e4a6                	sd	s1,72(sp)
    800031c6:	e0ca                	sd	s2,64(sp)
    800031c8:	fc4e                	sd	s3,56(sp)
    800031ca:	f852                	sd	s4,48(sp)
    800031cc:	f456                	sd	s5,40(sp)
    800031ce:	f05a                	sd	s6,32(sp)
    800031d0:	ec5e                	sd	s7,24(sp)
    800031d2:	e862                	sd	s8,16(sp)
    800031d4:	e466                	sd	s9,8(sp)
    800031d6:	1080                	addi	s0,sp,96
    800031d8:	84aa                	mv	s1,a0
    800031da:	8b2e                	mv	s6,a1
    800031dc:	8ab2                	mv	s5,a2
    struct inode *ip, *next;

    if (*path == '/')
    800031de:	00054703          	lbu	a4,0(a0)
    800031e2:	02f00793          	li	a5,47
    800031e6:	02f70363          	beq	a4,a5,8000320c <namex+0x4e>
        ip = iget(ROOTDEV, ROOTINO);
    else
        ip = idup(myproc()->cwd);
    800031ea:	ffffe097          	auipc	ra,0xffffe
    800031ee:	c78080e7          	jalr	-904(ra) # 80000e62 <myproc>
    800031f2:	15053503          	ld	a0,336(a0)
    800031f6:	00000097          	auipc	ra,0x0
    800031fa:	9f6080e7          	jalr	-1546(ra) # 80002bec <idup>
    800031fe:	89aa                	mv	s3,a0
    while (*path == '/')
    80003200:	02f00913          	li	s2,47
    len = path - s;
    80003204:	4b81                	li	s7,0
    if (len >= DIRSIZ)
    80003206:	4cb5                	li	s9,13

    while ((path = skipelem(path, name)) != 0)
    {
        ilock(ip);
        if (ip->type != T_DIR)
    80003208:	4c05                	li	s8,1
    8000320a:	a865                	j	800032c2 <namex+0x104>
        ip = iget(ROOTDEV, ROOTINO);
    8000320c:	4585                	li	a1,1
    8000320e:	4505                	li	a0,1
    80003210:	fffff097          	auipc	ra,0xfffff
    80003214:	6e2080e7          	jalr	1762(ra) # 800028f2 <iget>
    80003218:	89aa                	mv	s3,a0
    8000321a:	b7dd                	j	80003200 <namex+0x42>
        {
            iunlockput(ip);
    8000321c:	854e                	mv	a0,s3
    8000321e:	00000097          	auipc	ra,0x0
    80003222:	c6e080e7          	jalr	-914(ra) # 80002e8c <iunlockput>
            return 0;
    80003226:	4981                	li	s3,0
    {
        iput(ip);
        return 0;
    }
    return ip;
}
    80003228:	854e                	mv	a0,s3
    8000322a:	60e6                	ld	ra,88(sp)
    8000322c:	6446                	ld	s0,80(sp)
    8000322e:	64a6                	ld	s1,72(sp)
    80003230:	6906                	ld	s2,64(sp)
    80003232:	79e2                	ld	s3,56(sp)
    80003234:	7a42                	ld	s4,48(sp)
    80003236:	7aa2                	ld	s5,40(sp)
    80003238:	7b02                	ld	s6,32(sp)
    8000323a:	6be2                	ld	s7,24(sp)
    8000323c:	6c42                	ld	s8,16(sp)
    8000323e:	6ca2                	ld	s9,8(sp)
    80003240:	6125                	addi	sp,sp,96
    80003242:	8082                	ret
            iunlock(ip);
    80003244:	854e                	mv	a0,s3
    80003246:	00000097          	auipc	ra,0x0
    8000324a:	aa6080e7          	jalr	-1370(ra) # 80002cec <iunlock>
            return ip;
    8000324e:	bfe9                	j	80003228 <namex+0x6a>
            iunlockput(ip);
    80003250:	854e                	mv	a0,s3
    80003252:	00000097          	auipc	ra,0x0
    80003256:	c3a080e7          	jalr	-966(ra) # 80002e8c <iunlockput>
            return 0;
    8000325a:	89d2                	mv	s3,s4
    8000325c:	b7f1                	j	80003228 <namex+0x6a>
    len = path - s;
    8000325e:	40b48633          	sub	a2,s1,a1
    80003262:	00060a1b          	sext.w	s4,a2
    if (len >= DIRSIZ)
    80003266:	094cd463          	bge	s9,s4,800032ee <namex+0x130>
        memmove(name, s, DIRSIZ);
    8000326a:	4639                	li	a2,14
    8000326c:	8556                	mv	a0,s5
    8000326e:	ffffd097          	auipc	ra,0xffffd
    80003272:	f6a080e7          	jalr	-150(ra) # 800001d8 <memmove>
    while (*path == '/')
    80003276:	0004c783          	lbu	a5,0(s1)
    8000327a:	01279763          	bne	a5,s2,80003288 <namex+0xca>
        path++;
    8000327e:	0485                	addi	s1,s1,1
    while (*path == '/')
    80003280:	0004c783          	lbu	a5,0(s1)
    80003284:	ff278de3          	beq	a5,s2,8000327e <namex+0xc0>
        ilock(ip);
    80003288:	854e                	mv	a0,s3
    8000328a:	00000097          	auipc	ra,0x0
    8000328e:	9a0080e7          	jalr	-1632(ra) # 80002c2a <ilock>
        if (ip->type != T_DIR)
    80003292:	04499783          	lh	a5,68(s3)
    80003296:	f98793e3          	bne	a5,s8,8000321c <namex+0x5e>
        if (nameiparent && *path == '\0')
    8000329a:	000b0563          	beqz	s6,800032a4 <namex+0xe6>
    8000329e:	0004c783          	lbu	a5,0(s1)
    800032a2:	d3cd                	beqz	a5,80003244 <namex+0x86>
        if ((next = dirlookup(ip, name, 0)) == 0)
    800032a4:	865e                	mv	a2,s7
    800032a6:	85d6                	mv	a1,s5
    800032a8:	854e                	mv	a0,s3
    800032aa:	00000097          	auipc	ra,0x0
    800032ae:	e64080e7          	jalr	-412(ra) # 8000310e <dirlookup>
    800032b2:	8a2a                	mv	s4,a0
    800032b4:	dd51                	beqz	a0,80003250 <namex+0x92>
        iunlockput(ip);
    800032b6:	854e                	mv	a0,s3
    800032b8:	00000097          	auipc	ra,0x0
    800032bc:	bd4080e7          	jalr	-1068(ra) # 80002e8c <iunlockput>
        ip = next;
    800032c0:	89d2                	mv	s3,s4
    while (*path == '/')
    800032c2:	0004c783          	lbu	a5,0(s1)
    800032c6:	05279763          	bne	a5,s2,80003314 <namex+0x156>
        path++;
    800032ca:	0485                	addi	s1,s1,1
    while (*path == '/')
    800032cc:	0004c783          	lbu	a5,0(s1)
    800032d0:	ff278de3          	beq	a5,s2,800032ca <namex+0x10c>
    if (*path == 0)
    800032d4:	c79d                	beqz	a5,80003302 <namex+0x144>
        path++;
    800032d6:	85a6                	mv	a1,s1
    len = path - s;
    800032d8:	8a5e                	mv	s4,s7
    800032da:	865e                	mv	a2,s7
    while (*path != '/' && *path != 0)
    800032dc:	01278963          	beq	a5,s2,800032ee <namex+0x130>
    800032e0:	dfbd                	beqz	a5,8000325e <namex+0xa0>
        path++;
    800032e2:	0485                	addi	s1,s1,1
    while (*path != '/' && *path != 0)
    800032e4:	0004c783          	lbu	a5,0(s1)
    800032e8:	ff279ce3          	bne	a5,s2,800032e0 <namex+0x122>
    800032ec:	bf8d                	j	8000325e <namex+0xa0>
        memmove(name, s, len);
    800032ee:	2601                	sext.w	a2,a2
    800032f0:	8556                	mv	a0,s5
    800032f2:	ffffd097          	auipc	ra,0xffffd
    800032f6:	ee6080e7          	jalr	-282(ra) # 800001d8 <memmove>
        name[len] = 0;
    800032fa:	9a56                	add	s4,s4,s5
    800032fc:	000a0023          	sb	zero,0(s4)
    80003300:	bf9d                	j	80003276 <namex+0xb8>
    if (nameiparent)
    80003302:	f20b03e3          	beqz	s6,80003228 <namex+0x6a>
        iput(ip);
    80003306:	854e                	mv	a0,s3
    80003308:	00000097          	auipc	ra,0x0
    8000330c:	adc080e7          	jalr	-1316(ra) # 80002de4 <iput>
        return 0;
    80003310:	4981                	li	s3,0
    80003312:	bf19                	j	80003228 <namex+0x6a>
    if (*path == 0)
    80003314:	d7fd                	beqz	a5,80003302 <namex+0x144>
    while (*path != '/' && *path != 0)
    80003316:	0004c783          	lbu	a5,0(s1)
    8000331a:	85a6                	mv	a1,s1
    8000331c:	b7d1                	j	800032e0 <namex+0x122>

000000008000331e <dirlink>:
{
    8000331e:	7139                	addi	sp,sp,-64
    80003320:	fc06                	sd	ra,56(sp)
    80003322:	f822                	sd	s0,48(sp)
    80003324:	f426                	sd	s1,40(sp)
    80003326:	f04a                	sd	s2,32(sp)
    80003328:	ec4e                	sd	s3,24(sp)
    8000332a:	e852                	sd	s4,16(sp)
    8000332c:	0080                	addi	s0,sp,64
    8000332e:	892a                	mv	s2,a0
    80003330:	8a2e                	mv	s4,a1
    80003332:	89b2                	mv	s3,a2
    if ((ip = dirlookup(dp, name, 0)) != 0)
    80003334:	4601                	li	a2,0
    80003336:	00000097          	auipc	ra,0x0
    8000333a:	dd8080e7          	jalr	-552(ra) # 8000310e <dirlookup>
    8000333e:	e93d                	bnez	a0,800033b4 <dirlink+0x96>
    for (off = 0; off < dp->size; off += sizeof(de))
    80003340:	04c92483          	lw	s1,76(s2)
    80003344:	c49d                	beqz	s1,80003372 <dirlink+0x54>
    80003346:	4481                	li	s1,0
        if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003348:	4741                	li	a4,16
    8000334a:	86a6                	mv	a3,s1
    8000334c:	fc040613          	addi	a2,s0,-64
    80003350:	4581                	li	a1,0
    80003352:	854a                	mv	a0,s2
    80003354:	00000097          	auipc	ra,0x0
    80003358:	b8a080e7          	jalr	-1142(ra) # 80002ede <readi>
    8000335c:	47c1                	li	a5,16
    8000335e:	06f51163          	bne	a0,a5,800033c0 <dirlink+0xa2>
        if (de.inum == 0)
    80003362:	fc045783          	lhu	a5,-64(s0)
    80003366:	c791                	beqz	a5,80003372 <dirlink+0x54>
    for (off = 0; off < dp->size; off += sizeof(de))
    80003368:	24c1                	addiw	s1,s1,16
    8000336a:	04c92783          	lw	a5,76(s2)
    8000336e:	fcf4ede3          	bltu	s1,a5,80003348 <dirlink+0x2a>
    strncpy(de.name, name, DIRSIZ);
    80003372:	4639                	li	a2,14
    80003374:	85d2                	mv	a1,s4
    80003376:	fc240513          	addi	a0,s0,-62
    8000337a:	ffffd097          	auipc	ra,0xffffd
    8000337e:	f12080e7          	jalr	-238(ra) # 8000028c <strncpy>
    de.inum = inum;
    80003382:	fd341023          	sh	s3,-64(s0)
    if (writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003386:	4741                	li	a4,16
    80003388:	86a6                	mv	a3,s1
    8000338a:	fc040613          	addi	a2,s0,-64
    8000338e:	4581                	li	a1,0
    80003390:	854a                	mv	a0,s2
    80003392:	00000097          	auipc	ra,0x0
    80003396:	c44080e7          	jalr	-956(ra) # 80002fd6 <writei>
    8000339a:	1541                	addi	a0,a0,-16
    8000339c:	00a03533          	snez	a0,a0
    800033a0:	40a00533          	neg	a0,a0
}
    800033a4:	70e2                	ld	ra,56(sp)
    800033a6:	7442                	ld	s0,48(sp)
    800033a8:	74a2                	ld	s1,40(sp)
    800033aa:	7902                	ld	s2,32(sp)
    800033ac:	69e2                	ld	s3,24(sp)
    800033ae:	6a42                	ld	s4,16(sp)
    800033b0:	6121                	addi	sp,sp,64
    800033b2:	8082                	ret
        iput(ip);
    800033b4:	00000097          	auipc	ra,0x0
    800033b8:	a30080e7          	jalr	-1488(ra) # 80002de4 <iput>
        return -1;
    800033bc:	557d                	li	a0,-1
    800033be:	b7dd                	j	800033a4 <dirlink+0x86>
            panic("dirlink read");
    800033c0:	00005517          	auipc	a0,0x5
    800033c4:	2b050513          	addi	a0,a0,688 # 80008670 <syscalls+0x1d8>
    800033c8:	00003097          	auipc	ra,0x3
    800033cc:	b1a080e7          	jalr	-1254(ra) # 80005ee2 <panic>

00000000800033d0 <namei>:

struct inode *
namei(char *path)
{
    800033d0:	1101                	addi	sp,sp,-32
    800033d2:	ec06                	sd	ra,24(sp)
    800033d4:	e822                	sd	s0,16(sp)
    800033d6:	1000                	addi	s0,sp,32
    char name[DIRSIZ];
    return namex(path, 0, name);
    800033d8:	fe040613          	addi	a2,s0,-32
    800033dc:	4581                	li	a1,0
    800033de:	00000097          	auipc	ra,0x0
    800033e2:	de0080e7          	jalr	-544(ra) # 800031be <namex>
}
    800033e6:	60e2                	ld	ra,24(sp)
    800033e8:	6442                	ld	s0,16(sp)
    800033ea:	6105                	addi	sp,sp,32
    800033ec:	8082                	ret

00000000800033ee <nameiparent>:

struct inode *
nameiparent(char *path, char *name)
{
    800033ee:	1141                	addi	sp,sp,-16
    800033f0:	e406                	sd	ra,8(sp)
    800033f2:	e022                	sd	s0,0(sp)
    800033f4:	0800                	addi	s0,sp,16
    800033f6:	862e                	mv	a2,a1
    return namex(path, 1, name);
    800033f8:	4585                	li	a1,1
    800033fa:	00000097          	auipc	ra,0x0
    800033fe:	dc4080e7          	jalr	-572(ra) # 800031be <namex>
}
    80003402:	60a2                	ld	ra,8(sp)
    80003404:	6402                	ld	s0,0(sp)
    80003406:	0141                	addi	sp,sp,16
    80003408:	8082                	ret

000000008000340a <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    8000340a:	1101                	addi	sp,sp,-32
    8000340c:	ec06                	sd	ra,24(sp)
    8000340e:	e822                	sd	s0,16(sp)
    80003410:	e426                	sd	s1,8(sp)
    80003412:	e04a                	sd	s2,0(sp)
    80003414:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003416:	00027917          	auipc	s2,0x27
    8000341a:	5aa90913          	addi	s2,s2,1450 # 8002a9c0 <log>
    8000341e:	01892583          	lw	a1,24(s2)
    80003422:	02892503          	lw	a0,40(s2)
    80003426:	fffff097          	auipc	ra,0xfffff
    8000342a:	fea080e7          	jalr	-22(ra) # 80002410 <bread>
    8000342e:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003430:	02c92683          	lw	a3,44(s2)
    80003434:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003436:	02d05763          	blez	a3,80003464 <write_head+0x5a>
    8000343a:	00027797          	auipc	a5,0x27
    8000343e:	5b678793          	addi	a5,a5,1462 # 8002a9f0 <log+0x30>
    80003442:	05c50713          	addi	a4,a0,92
    80003446:	36fd                	addiw	a3,a3,-1
    80003448:	1682                	slli	a3,a3,0x20
    8000344a:	9281                	srli	a3,a3,0x20
    8000344c:	068a                	slli	a3,a3,0x2
    8000344e:	00027617          	auipc	a2,0x27
    80003452:	5a660613          	addi	a2,a2,1446 # 8002a9f4 <log+0x34>
    80003456:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80003458:	4390                	lw	a2,0(a5)
    8000345a:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000345c:	0791                	addi	a5,a5,4
    8000345e:	0711                	addi	a4,a4,4
    80003460:	fed79ce3          	bne	a5,a3,80003458 <write_head+0x4e>
  }
  bwrite(buf);
    80003464:	8526                	mv	a0,s1
    80003466:	fffff097          	auipc	ra,0xfffff
    8000346a:	09c080e7          	jalr	156(ra) # 80002502 <bwrite>
  brelse(buf);
    8000346e:	8526                	mv	a0,s1
    80003470:	fffff097          	auipc	ra,0xfffff
    80003474:	0d0080e7          	jalr	208(ra) # 80002540 <brelse>
}
    80003478:	60e2                	ld	ra,24(sp)
    8000347a:	6442                	ld	s0,16(sp)
    8000347c:	64a2                	ld	s1,8(sp)
    8000347e:	6902                	ld	s2,0(sp)
    80003480:	6105                	addi	sp,sp,32
    80003482:	8082                	ret

0000000080003484 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003484:	00027797          	auipc	a5,0x27
    80003488:	5687a783          	lw	a5,1384(a5) # 8002a9ec <log+0x2c>
    8000348c:	0af05d63          	blez	a5,80003546 <install_trans+0xc2>
{
    80003490:	7139                	addi	sp,sp,-64
    80003492:	fc06                	sd	ra,56(sp)
    80003494:	f822                	sd	s0,48(sp)
    80003496:	f426                	sd	s1,40(sp)
    80003498:	f04a                	sd	s2,32(sp)
    8000349a:	ec4e                	sd	s3,24(sp)
    8000349c:	e852                	sd	s4,16(sp)
    8000349e:	e456                	sd	s5,8(sp)
    800034a0:	e05a                	sd	s6,0(sp)
    800034a2:	0080                	addi	s0,sp,64
    800034a4:	8b2a                	mv	s6,a0
    800034a6:	00027a97          	auipc	s5,0x27
    800034aa:	54aa8a93          	addi	s5,s5,1354 # 8002a9f0 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800034ae:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800034b0:	00027997          	auipc	s3,0x27
    800034b4:	51098993          	addi	s3,s3,1296 # 8002a9c0 <log>
    800034b8:	a035                	j	800034e4 <install_trans+0x60>
      bunpin(dbuf);
    800034ba:	8526                	mv	a0,s1
    800034bc:	fffff097          	auipc	ra,0xfffff
    800034c0:	15e080e7          	jalr	350(ra) # 8000261a <bunpin>
    brelse(lbuf);
    800034c4:	854a                	mv	a0,s2
    800034c6:	fffff097          	auipc	ra,0xfffff
    800034ca:	07a080e7          	jalr	122(ra) # 80002540 <brelse>
    brelse(dbuf);
    800034ce:	8526                	mv	a0,s1
    800034d0:	fffff097          	auipc	ra,0xfffff
    800034d4:	070080e7          	jalr	112(ra) # 80002540 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800034d8:	2a05                	addiw	s4,s4,1
    800034da:	0a91                	addi	s5,s5,4
    800034dc:	02c9a783          	lw	a5,44(s3)
    800034e0:	04fa5963          	bge	s4,a5,80003532 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800034e4:	0189a583          	lw	a1,24(s3)
    800034e8:	014585bb          	addw	a1,a1,s4
    800034ec:	2585                	addiw	a1,a1,1
    800034ee:	0289a503          	lw	a0,40(s3)
    800034f2:	fffff097          	auipc	ra,0xfffff
    800034f6:	f1e080e7          	jalr	-226(ra) # 80002410 <bread>
    800034fa:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800034fc:	000aa583          	lw	a1,0(s5)
    80003500:	0289a503          	lw	a0,40(s3)
    80003504:	fffff097          	auipc	ra,0xfffff
    80003508:	f0c080e7          	jalr	-244(ra) # 80002410 <bread>
    8000350c:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    8000350e:	40000613          	li	a2,1024
    80003512:	05890593          	addi	a1,s2,88
    80003516:	05850513          	addi	a0,a0,88
    8000351a:	ffffd097          	auipc	ra,0xffffd
    8000351e:	cbe080e7          	jalr	-834(ra) # 800001d8 <memmove>
    bwrite(dbuf);  // write dst to disk
    80003522:	8526                	mv	a0,s1
    80003524:	fffff097          	auipc	ra,0xfffff
    80003528:	fde080e7          	jalr	-34(ra) # 80002502 <bwrite>
    if(recovering == 0)
    8000352c:	f80b1ce3          	bnez	s6,800034c4 <install_trans+0x40>
    80003530:	b769                	j	800034ba <install_trans+0x36>
}
    80003532:	70e2                	ld	ra,56(sp)
    80003534:	7442                	ld	s0,48(sp)
    80003536:	74a2                	ld	s1,40(sp)
    80003538:	7902                	ld	s2,32(sp)
    8000353a:	69e2                	ld	s3,24(sp)
    8000353c:	6a42                	ld	s4,16(sp)
    8000353e:	6aa2                	ld	s5,8(sp)
    80003540:	6b02                	ld	s6,0(sp)
    80003542:	6121                	addi	sp,sp,64
    80003544:	8082                	ret
    80003546:	8082                	ret

0000000080003548 <initlog>:
{
    80003548:	7179                	addi	sp,sp,-48
    8000354a:	f406                	sd	ra,40(sp)
    8000354c:	f022                	sd	s0,32(sp)
    8000354e:	ec26                	sd	s1,24(sp)
    80003550:	e84a                	sd	s2,16(sp)
    80003552:	e44e                	sd	s3,8(sp)
    80003554:	1800                	addi	s0,sp,48
    80003556:	892a                	mv	s2,a0
    80003558:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    8000355a:	00027497          	auipc	s1,0x27
    8000355e:	46648493          	addi	s1,s1,1126 # 8002a9c0 <log>
    80003562:	00005597          	auipc	a1,0x5
    80003566:	11e58593          	addi	a1,a1,286 # 80008680 <syscalls+0x1e8>
    8000356a:	8526                	mv	a0,s1
    8000356c:	00003097          	auipc	ra,0x3
    80003570:	e30080e7          	jalr	-464(ra) # 8000639c <initlock>
  log.start = sb->logstart;
    80003574:	0149a583          	lw	a1,20(s3)
    80003578:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    8000357a:	0109a783          	lw	a5,16(s3)
    8000357e:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003580:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003584:	854a                	mv	a0,s2
    80003586:	fffff097          	auipc	ra,0xfffff
    8000358a:	e8a080e7          	jalr	-374(ra) # 80002410 <bread>
  log.lh.n = lh->n;
    8000358e:	4d3c                	lw	a5,88(a0)
    80003590:	d4dc                	sw	a5,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003592:	02f05563          	blez	a5,800035bc <initlog+0x74>
    80003596:	05c50713          	addi	a4,a0,92
    8000359a:	00027697          	auipc	a3,0x27
    8000359e:	45668693          	addi	a3,a3,1110 # 8002a9f0 <log+0x30>
    800035a2:	37fd                	addiw	a5,a5,-1
    800035a4:	1782                	slli	a5,a5,0x20
    800035a6:	9381                	srli	a5,a5,0x20
    800035a8:	078a                	slli	a5,a5,0x2
    800035aa:	06050613          	addi	a2,a0,96
    800035ae:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    800035b0:	4310                	lw	a2,0(a4)
    800035b2:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    800035b4:	0711                	addi	a4,a4,4
    800035b6:	0691                	addi	a3,a3,4
    800035b8:	fef71ce3          	bne	a4,a5,800035b0 <initlog+0x68>
  brelse(buf);
    800035bc:	fffff097          	auipc	ra,0xfffff
    800035c0:	f84080e7          	jalr	-124(ra) # 80002540 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800035c4:	4505                	li	a0,1
    800035c6:	00000097          	auipc	ra,0x0
    800035ca:	ebe080e7          	jalr	-322(ra) # 80003484 <install_trans>
  log.lh.n = 0;
    800035ce:	00027797          	auipc	a5,0x27
    800035d2:	4007af23          	sw	zero,1054(a5) # 8002a9ec <log+0x2c>
  write_head(); // clear the log
    800035d6:	00000097          	auipc	ra,0x0
    800035da:	e34080e7          	jalr	-460(ra) # 8000340a <write_head>
}
    800035de:	70a2                	ld	ra,40(sp)
    800035e0:	7402                	ld	s0,32(sp)
    800035e2:	64e2                	ld	s1,24(sp)
    800035e4:	6942                	ld	s2,16(sp)
    800035e6:	69a2                	ld	s3,8(sp)
    800035e8:	6145                	addi	sp,sp,48
    800035ea:	8082                	ret

00000000800035ec <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800035ec:	1101                	addi	sp,sp,-32
    800035ee:	ec06                	sd	ra,24(sp)
    800035f0:	e822                	sd	s0,16(sp)
    800035f2:	e426                	sd	s1,8(sp)
    800035f4:	e04a                	sd	s2,0(sp)
    800035f6:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800035f8:	00027517          	auipc	a0,0x27
    800035fc:	3c850513          	addi	a0,a0,968 # 8002a9c0 <log>
    80003600:	00003097          	auipc	ra,0x3
    80003604:	e2c080e7          	jalr	-468(ra) # 8000642c <acquire>
  while(1){
    if(log.committing){
    80003608:	00027497          	auipc	s1,0x27
    8000360c:	3b848493          	addi	s1,s1,952 # 8002a9c0 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003610:	4979                	li	s2,30
    80003612:	a039                	j	80003620 <begin_op+0x34>
      sleep(&log, &log.lock);
    80003614:	85a6                	mv	a1,s1
    80003616:	8526                	mv	a0,s1
    80003618:	ffffe097          	auipc	ra,0xffffe
    8000361c:	eee080e7          	jalr	-274(ra) # 80001506 <sleep>
    if(log.committing){
    80003620:	50dc                	lw	a5,36(s1)
    80003622:	fbed                	bnez	a5,80003614 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003624:	509c                	lw	a5,32(s1)
    80003626:	0017871b          	addiw	a4,a5,1
    8000362a:	0007069b          	sext.w	a3,a4
    8000362e:	0027179b          	slliw	a5,a4,0x2
    80003632:	9fb9                	addw	a5,a5,a4
    80003634:	0017979b          	slliw	a5,a5,0x1
    80003638:	54d8                	lw	a4,44(s1)
    8000363a:	9fb9                	addw	a5,a5,a4
    8000363c:	00f95963          	bge	s2,a5,8000364e <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003640:	85a6                	mv	a1,s1
    80003642:	8526                	mv	a0,s1
    80003644:	ffffe097          	auipc	ra,0xffffe
    80003648:	ec2080e7          	jalr	-318(ra) # 80001506 <sleep>
    8000364c:	bfd1                	j	80003620 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    8000364e:	00027517          	auipc	a0,0x27
    80003652:	37250513          	addi	a0,a0,882 # 8002a9c0 <log>
    80003656:	d114                	sw	a3,32(a0)
      release(&log.lock);
    80003658:	00003097          	auipc	ra,0x3
    8000365c:	e88080e7          	jalr	-376(ra) # 800064e0 <release>
      break;
    }
  }
}
    80003660:	60e2                	ld	ra,24(sp)
    80003662:	6442                	ld	s0,16(sp)
    80003664:	64a2                	ld	s1,8(sp)
    80003666:	6902                	ld	s2,0(sp)
    80003668:	6105                	addi	sp,sp,32
    8000366a:	8082                	ret

000000008000366c <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000366c:	7139                	addi	sp,sp,-64
    8000366e:	fc06                	sd	ra,56(sp)
    80003670:	f822                	sd	s0,48(sp)
    80003672:	f426                	sd	s1,40(sp)
    80003674:	f04a                	sd	s2,32(sp)
    80003676:	ec4e                	sd	s3,24(sp)
    80003678:	e852                	sd	s4,16(sp)
    8000367a:	e456                	sd	s5,8(sp)
    8000367c:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000367e:	00027497          	auipc	s1,0x27
    80003682:	34248493          	addi	s1,s1,834 # 8002a9c0 <log>
    80003686:	8526                	mv	a0,s1
    80003688:	00003097          	auipc	ra,0x3
    8000368c:	da4080e7          	jalr	-604(ra) # 8000642c <acquire>
  log.outstanding -= 1;
    80003690:	509c                	lw	a5,32(s1)
    80003692:	37fd                	addiw	a5,a5,-1
    80003694:	0007891b          	sext.w	s2,a5
    80003698:	d09c                	sw	a5,32(s1)
  if(log.committing)
    8000369a:	50dc                	lw	a5,36(s1)
    8000369c:	efb9                	bnez	a5,800036fa <end_op+0x8e>
    panic("log.committing");
  if(log.outstanding == 0){
    8000369e:	06091663          	bnez	s2,8000370a <end_op+0x9e>
    do_commit = 1;
    log.committing = 1;
    800036a2:	00027497          	auipc	s1,0x27
    800036a6:	31e48493          	addi	s1,s1,798 # 8002a9c0 <log>
    800036aa:	4785                	li	a5,1
    800036ac:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800036ae:	8526                	mv	a0,s1
    800036b0:	00003097          	auipc	ra,0x3
    800036b4:	e30080e7          	jalr	-464(ra) # 800064e0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800036b8:	54dc                	lw	a5,44(s1)
    800036ba:	06f04763          	bgtz	a5,80003728 <end_op+0xbc>
    acquire(&log.lock);
    800036be:	00027497          	auipc	s1,0x27
    800036c2:	30248493          	addi	s1,s1,770 # 8002a9c0 <log>
    800036c6:	8526                	mv	a0,s1
    800036c8:	00003097          	auipc	ra,0x3
    800036cc:	d64080e7          	jalr	-668(ra) # 8000642c <acquire>
    log.committing = 0;
    800036d0:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800036d4:	8526                	mv	a0,s1
    800036d6:	ffffe097          	auipc	ra,0xffffe
    800036da:	e94080e7          	jalr	-364(ra) # 8000156a <wakeup>
    release(&log.lock);
    800036de:	8526                	mv	a0,s1
    800036e0:	00003097          	auipc	ra,0x3
    800036e4:	e00080e7          	jalr	-512(ra) # 800064e0 <release>
}
    800036e8:	70e2                	ld	ra,56(sp)
    800036ea:	7442                	ld	s0,48(sp)
    800036ec:	74a2                	ld	s1,40(sp)
    800036ee:	7902                	ld	s2,32(sp)
    800036f0:	69e2                	ld	s3,24(sp)
    800036f2:	6a42                	ld	s4,16(sp)
    800036f4:	6aa2                	ld	s5,8(sp)
    800036f6:	6121                	addi	sp,sp,64
    800036f8:	8082                	ret
    panic("log.committing");
    800036fa:	00005517          	auipc	a0,0x5
    800036fe:	f8e50513          	addi	a0,a0,-114 # 80008688 <syscalls+0x1f0>
    80003702:	00002097          	auipc	ra,0x2
    80003706:	7e0080e7          	jalr	2016(ra) # 80005ee2 <panic>
    wakeup(&log);
    8000370a:	00027497          	auipc	s1,0x27
    8000370e:	2b648493          	addi	s1,s1,694 # 8002a9c0 <log>
    80003712:	8526                	mv	a0,s1
    80003714:	ffffe097          	auipc	ra,0xffffe
    80003718:	e56080e7          	jalr	-426(ra) # 8000156a <wakeup>
  release(&log.lock);
    8000371c:	8526                	mv	a0,s1
    8000371e:	00003097          	auipc	ra,0x3
    80003722:	dc2080e7          	jalr	-574(ra) # 800064e0 <release>
  if(do_commit){
    80003726:	b7c9                	j	800036e8 <end_op+0x7c>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003728:	00027a97          	auipc	s5,0x27
    8000372c:	2c8a8a93          	addi	s5,s5,712 # 8002a9f0 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003730:	00027a17          	auipc	s4,0x27
    80003734:	290a0a13          	addi	s4,s4,656 # 8002a9c0 <log>
    80003738:	018a2583          	lw	a1,24(s4)
    8000373c:	012585bb          	addw	a1,a1,s2
    80003740:	2585                	addiw	a1,a1,1
    80003742:	028a2503          	lw	a0,40(s4)
    80003746:	fffff097          	auipc	ra,0xfffff
    8000374a:	cca080e7          	jalr	-822(ra) # 80002410 <bread>
    8000374e:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003750:	000aa583          	lw	a1,0(s5)
    80003754:	028a2503          	lw	a0,40(s4)
    80003758:	fffff097          	auipc	ra,0xfffff
    8000375c:	cb8080e7          	jalr	-840(ra) # 80002410 <bread>
    80003760:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003762:	40000613          	li	a2,1024
    80003766:	05850593          	addi	a1,a0,88
    8000376a:	05848513          	addi	a0,s1,88
    8000376e:	ffffd097          	auipc	ra,0xffffd
    80003772:	a6a080e7          	jalr	-1430(ra) # 800001d8 <memmove>
    bwrite(to);  // write the log
    80003776:	8526                	mv	a0,s1
    80003778:	fffff097          	auipc	ra,0xfffff
    8000377c:	d8a080e7          	jalr	-630(ra) # 80002502 <bwrite>
    brelse(from);
    80003780:	854e                	mv	a0,s3
    80003782:	fffff097          	auipc	ra,0xfffff
    80003786:	dbe080e7          	jalr	-578(ra) # 80002540 <brelse>
    brelse(to);
    8000378a:	8526                	mv	a0,s1
    8000378c:	fffff097          	auipc	ra,0xfffff
    80003790:	db4080e7          	jalr	-588(ra) # 80002540 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003794:	2905                	addiw	s2,s2,1
    80003796:	0a91                	addi	s5,s5,4
    80003798:	02ca2783          	lw	a5,44(s4)
    8000379c:	f8f94ee3          	blt	s2,a5,80003738 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800037a0:	00000097          	auipc	ra,0x0
    800037a4:	c6a080e7          	jalr	-918(ra) # 8000340a <write_head>
    install_trans(0); // Now install writes to home locations
    800037a8:	4501                	li	a0,0
    800037aa:	00000097          	auipc	ra,0x0
    800037ae:	cda080e7          	jalr	-806(ra) # 80003484 <install_trans>
    log.lh.n = 0;
    800037b2:	00027797          	auipc	a5,0x27
    800037b6:	2207ad23          	sw	zero,570(a5) # 8002a9ec <log+0x2c>
    write_head();    // Erase the transaction from the log
    800037ba:	00000097          	auipc	ra,0x0
    800037be:	c50080e7          	jalr	-944(ra) # 8000340a <write_head>
    800037c2:	bdf5                	j	800036be <end_op+0x52>

00000000800037c4 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800037c4:	1101                	addi	sp,sp,-32
    800037c6:	ec06                	sd	ra,24(sp)
    800037c8:	e822                	sd	s0,16(sp)
    800037ca:	e426                	sd	s1,8(sp)
    800037cc:	e04a                	sd	s2,0(sp)
    800037ce:	1000                	addi	s0,sp,32
    800037d0:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800037d2:	00027917          	auipc	s2,0x27
    800037d6:	1ee90913          	addi	s2,s2,494 # 8002a9c0 <log>
    800037da:	854a                	mv	a0,s2
    800037dc:	00003097          	auipc	ra,0x3
    800037e0:	c50080e7          	jalr	-944(ra) # 8000642c <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800037e4:	02c92603          	lw	a2,44(s2)
    800037e8:	47f5                	li	a5,29
    800037ea:	06c7c563          	blt	a5,a2,80003854 <log_write+0x90>
    800037ee:	00027797          	auipc	a5,0x27
    800037f2:	1ee7a783          	lw	a5,494(a5) # 8002a9dc <log+0x1c>
    800037f6:	37fd                	addiw	a5,a5,-1
    800037f8:	04f65e63          	bge	a2,a5,80003854 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800037fc:	00027797          	auipc	a5,0x27
    80003800:	1e47a783          	lw	a5,484(a5) # 8002a9e0 <log+0x20>
    80003804:	06f05063          	blez	a5,80003864 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003808:	4781                	li	a5,0
    8000380a:	06c05563          	blez	a2,80003874 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000380e:	44cc                	lw	a1,12(s1)
    80003810:	00027717          	auipc	a4,0x27
    80003814:	1e070713          	addi	a4,a4,480 # 8002a9f0 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003818:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000381a:	4314                	lw	a3,0(a4)
    8000381c:	04b68c63          	beq	a3,a1,80003874 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80003820:	2785                	addiw	a5,a5,1
    80003822:	0711                	addi	a4,a4,4
    80003824:	fef61be3          	bne	a2,a5,8000381a <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003828:	0621                	addi	a2,a2,8
    8000382a:	060a                	slli	a2,a2,0x2
    8000382c:	00027797          	auipc	a5,0x27
    80003830:	19478793          	addi	a5,a5,404 # 8002a9c0 <log>
    80003834:	963e                	add	a2,a2,a5
    80003836:	44dc                	lw	a5,12(s1)
    80003838:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    8000383a:	8526                	mv	a0,s1
    8000383c:	fffff097          	auipc	ra,0xfffff
    80003840:	da2080e7          	jalr	-606(ra) # 800025de <bpin>
    log.lh.n++;
    80003844:	00027717          	auipc	a4,0x27
    80003848:	17c70713          	addi	a4,a4,380 # 8002a9c0 <log>
    8000384c:	575c                	lw	a5,44(a4)
    8000384e:	2785                	addiw	a5,a5,1
    80003850:	d75c                	sw	a5,44(a4)
    80003852:	a835                	j	8000388e <log_write+0xca>
    panic("too big a transaction");
    80003854:	00005517          	auipc	a0,0x5
    80003858:	e4450513          	addi	a0,a0,-444 # 80008698 <syscalls+0x200>
    8000385c:	00002097          	auipc	ra,0x2
    80003860:	686080e7          	jalr	1670(ra) # 80005ee2 <panic>
    panic("log_write outside of trans");
    80003864:	00005517          	auipc	a0,0x5
    80003868:	e4c50513          	addi	a0,a0,-436 # 800086b0 <syscalls+0x218>
    8000386c:	00002097          	auipc	ra,0x2
    80003870:	676080e7          	jalr	1654(ra) # 80005ee2 <panic>
  log.lh.block[i] = b->blockno;
    80003874:	00878713          	addi	a4,a5,8
    80003878:	00271693          	slli	a3,a4,0x2
    8000387c:	00027717          	auipc	a4,0x27
    80003880:	14470713          	addi	a4,a4,324 # 8002a9c0 <log>
    80003884:	9736                	add	a4,a4,a3
    80003886:	44d4                	lw	a3,12(s1)
    80003888:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    8000388a:	faf608e3          	beq	a2,a5,8000383a <log_write+0x76>
  }
  release(&log.lock);
    8000388e:	00027517          	auipc	a0,0x27
    80003892:	13250513          	addi	a0,a0,306 # 8002a9c0 <log>
    80003896:	00003097          	auipc	ra,0x3
    8000389a:	c4a080e7          	jalr	-950(ra) # 800064e0 <release>
}
    8000389e:	60e2                	ld	ra,24(sp)
    800038a0:	6442                	ld	s0,16(sp)
    800038a2:	64a2                	ld	s1,8(sp)
    800038a4:	6902                	ld	s2,0(sp)
    800038a6:	6105                	addi	sp,sp,32
    800038a8:	8082                	ret

00000000800038aa <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800038aa:	1101                	addi	sp,sp,-32
    800038ac:	ec06                	sd	ra,24(sp)
    800038ae:	e822                	sd	s0,16(sp)
    800038b0:	e426                	sd	s1,8(sp)
    800038b2:	e04a                	sd	s2,0(sp)
    800038b4:	1000                	addi	s0,sp,32
    800038b6:	84aa                	mv	s1,a0
    800038b8:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800038ba:	00005597          	auipc	a1,0x5
    800038be:	e1658593          	addi	a1,a1,-490 # 800086d0 <syscalls+0x238>
    800038c2:	0521                	addi	a0,a0,8
    800038c4:	00003097          	auipc	ra,0x3
    800038c8:	ad8080e7          	jalr	-1320(ra) # 8000639c <initlock>
  lk->name = name;
    800038cc:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800038d0:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800038d4:	0204a423          	sw	zero,40(s1)
}
    800038d8:	60e2                	ld	ra,24(sp)
    800038da:	6442                	ld	s0,16(sp)
    800038dc:	64a2                	ld	s1,8(sp)
    800038de:	6902                	ld	s2,0(sp)
    800038e0:	6105                	addi	sp,sp,32
    800038e2:	8082                	ret

00000000800038e4 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800038e4:	1101                	addi	sp,sp,-32
    800038e6:	ec06                	sd	ra,24(sp)
    800038e8:	e822                	sd	s0,16(sp)
    800038ea:	e426                	sd	s1,8(sp)
    800038ec:	e04a                	sd	s2,0(sp)
    800038ee:	1000                	addi	s0,sp,32
    800038f0:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800038f2:	00850913          	addi	s2,a0,8
    800038f6:	854a                	mv	a0,s2
    800038f8:	00003097          	auipc	ra,0x3
    800038fc:	b34080e7          	jalr	-1228(ra) # 8000642c <acquire>
  while (lk->locked) {
    80003900:	409c                	lw	a5,0(s1)
    80003902:	cb89                	beqz	a5,80003914 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    80003904:	85ca                	mv	a1,s2
    80003906:	8526                	mv	a0,s1
    80003908:	ffffe097          	auipc	ra,0xffffe
    8000390c:	bfe080e7          	jalr	-1026(ra) # 80001506 <sleep>
  while (lk->locked) {
    80003910:	409c                	lw	a5,0(s1)
    80003912:	fbed                	bnez	a5,80003904 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003914:	4785                	li	a5,1
    80003916:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003918:	ffffd097          	auipc	ra,0xffffd
    8000391c:	54a080e7          	jalr	1354(ra) # 80000e62 <myproc>
    80003920:	591c                	lw	a5,48(a0)
    80003922:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003924:	854a                	mv	a0,s2
    80003926:	00003097          	auipc	ra,0x3
    8000392a:	bba080e7          	jalr	-1094(ra) # 800064e0 <release>
}
    8000392e:	60e2                	ld	ra,24(sp)
    80003930:	6442                	ld	s0,16(sp)
    80003932:	64a2                	ld	s1,8(sp)
    80003934:	6902                	ld	s2,0(sp)
    80003936:	6105                	addi	sp,sp,32
    80003938:	8082                	ret

000000008000393a <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    8000393a:	1101                	addi	sp,sp,-32
    8000393c:	ec06                	sd	ra,24(sp)
    8000393e:	e822                	sd	s0,16(sp)
    80003940:	e426                	sd	s1,8(sp)
    80003942:	e04a                	sd	s2,0(sp)
    80003944:	1000                	addi	s0,sp,32
    80003946:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003948:	00850913          	addi	s2,a0,8
    8000394c:	854a                	mv	a0,s2
    8000394e:	00003097          	auipc	ra,0x3
    80003952:	ade080e7          	jalr	-1314(ra) # 8000642c <acquire>
  lk->locked = 0;
    80003956:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000395a:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    8000395e:	8526                	mv	a0,s1
    80003960:	ffffe097          	auipc	ra,0xffffe
    80003964:	c0a080e7          	jalr	-1014(ra) # 8000156a <wakeup>
  release(&lk->lk);
    80003968:	854a                	mv	a0,s2
    8000396a:	00003097          	auipc	ra,0x3
    8000396e:	b76080e7          	jalr	-1162(ra) # 800064e0 <release>
}
    80003972:	60e2                	ld	ra,24(sp)
    80003974:	6442                	ld	s0,16(sp)
    80003976:	64a2                	ld	s1,8(sp)
    80003978:	6902                	ld	s2,0(sp)
    8000397a:	6105                	addi	sp,sp,32
    8000397c:	8082                	ret

000000008000397e <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    8000397e:	7179                	addi	sp,sp,-48
    80003980:	f406                	sd	ra,40(sp)
    80003982:	f022                	sd	s0,32(sp)
    80003984:	ec26                	sd	s1,24(sp)
    80003986:	e84a                	sd	s2,16(sp)
    80003988:	e44e                	sd	s3,8(sp)
    8000398a:	1800                	addi	s0,sp,48
    8000398c:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    8000398e:	00850913          	addi	s2,a0,8
    80003992:	854a                	mv	a0,s2
    80003994:	00003097          	auipc	ra,0x3
    80003998:	a98080e7          	jalr	-1384(ra) # 8000642c <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    8000399c:	409c                	lw	a5,0(s1)
    8000399e:	ef99                	bnez	a5,800039bc <holdingsleep+0x3e>
    800039a0:	4481                	li	s1,0
  release(&lk->lk);
    800039a2:	854a                	mv	a0,s2
    800039a4:	00003097          	auipc	ra,0x3
    800039a8:	b3c080e7          	jalr	-1220(ra) # 800064e0 <release>
  return r;
}
    800039ac:	8526                	mv	a0,s1
    800039ae:	70a2                	ld	ra,40(sp)
    800039b0:	7402                	ld	s0,32(sp)
    800039b2:	64e2                	ld	s1,24(sp)
    800039b4:	6942                	ld	s2,16(sp)
    800039b6:	69a2                	ld	s3,8(sp)
    800039b8:	6145                	addi	sp,sp,48
    800039ba:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    800039bc:	0284a983          	lw	s3,40(s1)
    800039c0:	ffffd097          	auipc	ra,0xffffd
    800039c4:	4a2080e7          	jalr	1186(ra) # 80000e62 <myproc>
    800039c8:	5904                	lw	s1,48(a0)
    800039ca:	413484b3          	sub	s1,s1,s3
    800039ce:	0014b493          	seqz	s1,s1
    800039d2:	bfc1                	j	800039a2 <holdingsleep+0x24>

00000000800039d4 <fileinit>:
    struct spinlock lock;
    struct file file[NFILE];
} ftable;

void fileinit(void)
{
    800039d4:	1141                	addi	sp,sp,-16
    800039d6:	e406                	sd	ra,8(sp)
    800039d8:	e022                	sd	s0,0(sp)
    800039da:	0800                	addi	s0,sp,16
    initlock(&ftable.lock, "ftable");
    800039dc:	00005597          	auipc	a1,0x5
    800039e0:	d0458593          	addi	a1,a1,-764 # 800086e0 <syscalls+0x248>
    800039e4:	00027517          	auipc	a0,0x27
    800039e8:	12450513          	addi	a0,a0,292 # 8002ab08 <ftable>
    800039ec:	00003097          	auipc	ra,0x3
    800039f0:	9b0080e7          	jalr	-1616(ra) # 8000639c <initlock>
}
    800039f4:	60a2                	ld	ra,8(sp)
    800039f6:	6402                	ld	s0,0(sp)
    800039f8:	0141                	addi	sp,sp,16
    800039fa:	8082                	ret

00000000800039fc <filealloc>:

// Allocate a file structure.
struct file *
filealloc(void)
{
    800039fc:	1101                	addi	sp,sp,-32
    800039fe:	ec06                	sd	ra,24(sp)
    80003a00:	e822                	sd	s0,16(sp)
    80003a02:	e426                	sd	s1,8(sp)
    80003a04:	1000                	addi	s0,sp,32
    struct file *f;

    acquire(&ftable.lock);
    80003a06:	00027517          	auipc	a0,0x27
    80003a0a:	10250513          	addi	a0,a0,258 # 8002ab08 <ftable>
    80003a0e:	00003097          	auipc	ra,0x3
    80003a12:	a1e080e7          	jalr	-1506(ra) # 8000642c <acquire>
    for (f = ftable.file; f < ftable.file + NFILE; f++)
    80003a16:	00027497          	auipc	s1,0x27
    80003a1a:	10a48493          	addi	s1,s1,266 # 8002ab20 <ftable+0x18>
    80003a1e:	00028717          	auipc	a4,0x28
    80003a22:	0a270713          	addi	a4,a4,162 # 8002bac0 <disk>
    {
        if (f->ref == 0)
    80003a26:	40dc                	lw	a5,4(s1)
    80003a28:	cf99                	beqz	a5,80003a46 <filealloc+0x4a>
    for (f = ftable.file; f < ftable.file + NFILE; f++)
    80003a2a:	02848493          	addi	s1,s1,40
    80003a2e:	fee49ce3          	bne	s1,a4,80003a26 <filealloc+0x2a>
            f->ref = 1;
            release(&ftable.lock);
            return f;
        }
    }
    release(&ftable.lock);
    80003a32:	00027517          	auipc	a0,0x27
    80003a36:	0d650513          	addi	a0,a0,214 # 8002ab08 <ftable>
    80003a3a:	00003097          	auipc	ra,0x3
    80003a3e:	aa6080e7          	jalr	-1370(ra) # 800064e0 <release>
    return 0;
    80003a42:	4481                	li	s1,0
    80003a44:	a819                	j	80003a5a <filealloc+0x5e>
            f->ref = 1;
    80003a46:	4785                	li	a5,1
    80003a48:	c0dc                	sw	a5,4(s1)
            release(&ftable.lock);
    80003a4a:	00027517          	auipc	a0,0x27
    80003a4e:	0be50513          	addi	a0,a0,190 # 8002ab08 <ftable>
    80003a52:	00003097          	auipc	ra,0x3
    80003a56:	a8e080e7          	jalr	-1394(ra) # 800064e0 <release>
}
    80003a5a:	8526                	mv	a0,s1
    80003a5c:	60e2                	ld	ra,24(sp)
    80003a5e:	6442                	ld	s0,16(sp)
    80003a60:	64a2                	ld	s1,8(sp)
    80003a62:	6105                	addi	sp,sp,32
    80003a64:	8082                	ret

0000000080003a66 <filedup>:

// Increment ref count for file f.
struct file *
filedup(struct file *f)
{
    80003a66:	1101                	addi	sp,sp,-32
    80003a68:	ec06                	sd	ra,24(sp)
    80003a6a:	e822                	sd	s0,16(sp)
    80003a6c:	e426                	sd	s1,8(sp)
    80003a6e:	1000                	addi	s0,sp,32
    80003a70:	84aa                	mv	s1,a0
    acquire(&ftable.lock);
    80003a72:	00027517          	auipc	a0,0x27
    80003a76:	09650513          	addi	a0,a0,150 # 8002ab08 <ftable>
    80003a7a:	00003097          	auipc	ra,0x3
    80003a7e:	9b2080e7          	jalr	-1614(ra) # 8000642c <acquire>
    if (f->ref < 1)
    80003a82:	40dc                	lw	a5,4(s1)
    80003a84:	02f05263          	blez	a5,80003aa8 <filedup+0x42>
        panic("filedup");
    f->ref++;
    80003a88:	2785                	addiw	a5,a5,1
    80003a8a:	c0dc                	sw	a5,4(s1)
    release(&ftable.lock);
    80003a8c:	00027517          	auipc	a0,0x27
    80003a90:	07c50513          	addi	a0,a0,124 # 8002ab08 <ftable>
    80003a94:	00003097          	auipc	ra,0x3
    80003a98:	a4c080e7          	jalr	-1460(ra) # 800064e0 <release>
    return f;
}
    80003a9c:	8526                	mv	a0,s1
    80003a9e:	60e2                	ld	ra,24(sp)
    80003aa0:	6442                	ld	s0,16(sp)
    80003aa2:	64a2                	ld	s1,8(sp)
    80003aa4:	6105                	addi	sp,sp,32
    80003aa6:	8082                	ret
        panic("filedup");
    80003aa8:	00005517          	auipc	a0,0x5
    80003aac:	c4050513          	addi	a0,a0,-960 # 800086e8 <syscalls+0x250>
    80003ab0:	00002097          	auipc	ra,0x2
    80003ab4:	432080e7          	jalr	1074(ra) # 80005ee2 <panic>

0000000080003ab8 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void fileclose(struct file *f)
{
    80003ab8:	7139                	addi	sp,sp,-64
    80003aba:	fc06                	sd	ra,56(sp)
    80003abc:	f822                	sd	s0,48(sp)
    80003abe:	f426                	sd	s1,40(sp)
    80003ac0:	f04a                	sd	s2,32(sp)
    80003ac2:	ec4e                	sd	s3,24(sp)
    80003ac4:	e852                	sd	s4,16(sp)
    80003ac6:	e456                	sd	s5,8(sp)
    80003ac8:	0080                	addi	s0,sp,64
    80003aca:	84aa                	mv	s1,a0
    struct file ff;

    acquire(&ftable.lock);
    80003acc:	00027517          	auipc	a0,0x27
    80003ad0:	03c50513          	addi	a0,a0,60 # 8002ab08 <ftable>
    80003ad4:	00003097          	auipc	ra,0x3
    80003ad8:	958080e7          	jalr	-1704(ra) # 8000642c <acquire>
    if (f->ref < 1)
    80003adc:	40dc                	lw	a5,4(s1)
    80003ade:	06f05163          	blez	a5,80003b40 <fileclose+0x88>
        panic("fileclose");
    if (--f->ref > 0)
    80003ae2:	37fd                	addiw	a5,a5,-1
    80003ae4:	0007871b          	sext.w	a4,a5
    80003ae8:	c0dc                	sw	a5,4(s1)
    80003aea:	06e04363          	bgtz	a4,80003b50 <fileclose+0x98>
    {
        release(&ftable.lock);
        return;
    }
    ff = *f;
    80003aee:	0004a903          	lw	s2,0(s1)
    80003af2:	0094ca83          	lbu	s5,9(s1)
    80003af6:	0104ba03          	ld	s4,16(s1)
    80003afa:	0184b983          	ld	s3,24(s1)
    f->ref = 0;
    80003afe:	0004a223          	sw	zero,4(s1)
    f->type = FD_NONE;
    80003b02:	0004a023          	sw	zero,0(s1)
    release(&ftable.lock);
    80003b06:	00027517          	auipc	a0,0x27
    80003b0a:	00250513          	addi	a0,a0,2 # 8002ab08 <ftable>
    80003b0e:	00003097          	auipc	ra,0x3
    80003b12:	9d2080e7          	jalr	-1582(ra) # 800064e0 <release>

    if (ff.type == FD_PIPE)
    80003b16:	4785                	li	a5,1
    80003b18:	04f90d63          	beq	s2,a5,80003b72 <fileclose+0xba>
    {
        pipeclose(ff.pipe, ff.writable);
    }
    else if (ff.type == FD_INODE || ff.type == FD_DEVICE)
    80003b1c:	3979                	addiw	s2,s2,-2
    80003b1e:	4785                	li	a5,1
    80003b20:	0527e063          	bltu	a5,s2,80003b60 <fileclose+0xa8>
    {
        begin_op();
    80003b24:	00000097          	auipc	ra,0x0
    80003b28:	ac8080e7          	jalr	-1336(ra) # 800035ec <begin_op>
        iput(ff.ip);
    80003b2c:	854e                	mv	a0,s3
    80003b2e:	fffff097          	auipc	ra,0xfffff
    80003b32:	2b6080e7          	jalr	694(ra) # 80002de4 <iput>
        end_op();
    80003b36:	00000097          	auipc	ra,0x0
    80003b3a:	b36080e7          	jalr	-1226(ra) # 8000366c <end_op>
    80003b3e:	a00d                	j	80003b60 <fileclose+0xa8>
        panic("fileclose");
    80003b40:	00005517          	auipc	a0,0x5
    80003b44:	bb050513          	addi	a0,a0,-1104 # 800086f0 <syscalls+0x258>
    80003b48:	00002097          	auipc	ra,0x2
    80003b4c:	39a080e7          	jalr	922(ra) # 80005ee2 <panic>
        release(&ftable.lock);
    80003b50:	00027517          	auipc	a0,0x27
    80003b54:	fb850513          	addi	a0,a0,-72 # 8002ab08 <ftable>
    80003b58:	00003097          	auipc	ra,0x3
    80003b5c:	988080e7          	jalr	-1656(ra) # 800064e0 <release>
    }
}
    80003b60:	70e2                	ld	ra,56(sp)
    80003b62:	7442                	ld	s0,48(sp)
    80003b64:	74a2                	ld	s1,40(sp)
    80003b66:	7902                	ld	s2,32(sp)
    80003b68:	69e2                	ld	s3,24(sp)
    80003b6a:	6a42                	ld	s4,16(sp)
    80003b6c:	6aa2                	ld	s5,8(sp)
    80003b6e:	6121                	addi	sp,sp,64
    80003b70:	8082                	ret
        pipeclose(ff.pipe, ff.writable);
    80003b72:	85d6                	mv	a1,s5
    80003b74:	8552                	mv	a0,s4
    80003b76:	00000097          	auipc	ra,0x0
    80003b7a:	3a6080e7          	jalr	934(ra) # 80003f1c <pipeclose>
    80003b7e:	b7cd                	j	80003b60 <fileclose+0xa8>

0000000080003b80 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int filestat(struct file *f, uint64 addr)
{
    80003b80:	715d                	addi	sp,sp,-80
    80003b82:	e486                	sd	ra,72(sp)
    80003b84:	e0a2                	sd	s0,64(sp)
    80003b86:	fc26                	sd	s1,56(sp)
    80003b88:	f84a                	sd	s2,48(sp)
    80003b8a:	f44e                	sd	s3,40(sp)
    80003b8c:	0880                	addi	s0,sp,80
    80003b8e:	84aa                	mv	s1,a0
    80003b90:	89ae                	mv	s3,a1
    struct proc *p = myproc();
    80003b92:	ffffd097          	auipc	ra,0xffffd
    80003b96:	2d0080e7          	jalr	720(ra) # 80000e62 <myproc>
    struct stat st;

    if (f->type == FD_INODE || f->type == FD_DEVICE)
    80003b9a:	409c                	lw	a5,0(s1)
    80003b9c:	37f9                	addiw	a5,a5,-2
    80003b9e:	4705                	li	a4,1
    80003ba0:	04f76763          	bltu	a4,a5,80003bee <filestat+0x6e>
    80003ba4:	892a                	mv	s2,a0
    {
        ilock(f->ip);
    80003ba6:	6c88                	ld	a0,24(s1)
    80003ba8:	fffff097          	auipc	ra,0xfffff
    80003bac:	082080e7          	jalr	130(ra) # 80002c2a <ilock>
        stati(f->ip, &st);
    80003bb0:	fb840593          	addi	a1,s0,-72
    80003bb4:	6c88                	ld	a0,24(s1)
    80003bb6:	fffff097          	auipc	ra,0xfffff
    80003bba:	2fe080e7          	jalr	766(ra) # 80002eb4 <stati>
        iunlock(f->ip);
    80003bbe:	6c88                	ld	a0,24(s1)
    80003bc0:	fffff097          	auipc	ra,0xfffff
    80003bc4:	12c080e7          	jalr	300(ra) # 80002cec <iunlock>
        if (copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003bc8:	46e1                	li	a3,24
    80003bca:	fb840613          	addi	a2,s0,-72
    80003bce:	85ce                	mv	a1,s3
    80003bd0:	05093503          	ld	a0,80(s2)
    80003bd4:	ffffd097          	auipc	ra,0xffffd
    80003bd8:	f4c080e7          	jalr	-180(ra) # 80000b20 <copyout>
    80003bdc:	41f5551b          	sraiw	a0,a0,0x1f
            return -1;
        return 0;
    }
    return -1;
}
    80003be0:	60a6                	ld	ra,72(sp)
    80003be2:	6406                	ld	s0,64(sp)
    80003be4:	74e2                	ld	s1,56(sp)
    80003be6:	7942                	ld	s2,48(sp)
    80003be8:	79a2                	ld	s3,40(sp)
    80003bea:	6161                	addi	sp,sp,80
    80003bec:	8082                	ret
    return -1;
    80003bee:	557d                	li	a0,-1
    80003bf0:	bfc5                	j	80003be0 <filestat+0x60>

0000000080003bf2 <mapfile>:

void mapfile(struct file *f, char *mem, int offset)
{
    80003bf2:	7179                	addi	sp,sp,-48
    80003bf4:	f406                	sd	ra,40(sp)
    80003bf6:	f022                	sd	s0,32(sp)
    80003bf8:	ec26                	sd	s1,24(sp)
    80003bfa:	e84a                	sd	s2,16(sp)
    80003bfc:	e44e                	sd	s3,8(sp)
    80003bfe:	1800                	addi	s0,sp,48
    80003c00:	84aa                	mv	s1,a0
    80003c02:	89ae                	mv	s3,a1
    80003c04:	8932                	mv	s2,a2
    printf("off %d\n", offset);
    80003c06:	85b2                	mv	a1,a2
    80003c08:	00005517          	auipc	a0,0x5
    80003c0c:	af850513          	addi	a0,a0,-1288 # 80008700 <syscalls+0x268>
    80003c10:	00002097          	auipc	ra,0x2
    80003c14:	31c080e7          	jalr	796(ra) # 80005f2c <printf>
    ilock(f->ip);
    80003c18:	6c88                	ld	a0,24(s1)
    80003c1a:	fffff097          	auipc	ra,0xfffff
    80003c1e:	010080e7          	jalr	16(ra) # 80002c2a <ilock>
    // printf("[Testing] (mapfile) : finish ilock\n");
    readi(f->ip, 0, (uint64)mem, offset, PGSIZE);
    80003c22:	6705                	lui	a4,0x1
    80003c24:	86ca                	mv	a3,s2
    80003c26:	864e                	mv	a2,s3
    80003c28:	4581                	li	a1,0
    80003c2a:	6c88                	ld	a0,24(s1)
    80003c2c:	fffff097          	auipc	ra,0xfffff
    80003c30:	2b2080e7          	jalr	690(ra) # 80002ede <readi>
    // printf("[Testing] (mapfile) : finish readi\n");
    iunlock(f->ip);
    80003c34:	6c88                	ld	a0,24(s1)
    80003c36:	fffff097          	auipc	ra,0xfffff
    80003c3a:	0b6080e7          	jalr	182(ra) # 80002cec <iunlock>
    // printf("[Testing] (mapfile) : finish iunlock\n");
}
    80003c3e:	70a2                	ld	ra,40(sp)
    80003c40:	7402                	ld	s0,32(sp)
    80003c42:	64e2                	ld	s1,24(sp)
    80003c44:	6942                	ld	s2,16(sp)
    80003c46:	69a2                	ld	s3,8(sp)
    80003c48:	6145                	addi	sp,sp,48
    80003c4a:	8082                	ret

0000000080003c4c <fileread>:

// Read from file f.
// addr is a user virtual address.
int fileread(struct file *f, uint64 addr, int n)
{
    80003c4c:	7179                	addi	sp,sp,-48
    80003c4e:	f406                	sd	ra,40(sp)
    80003c50:	f022                	sd	s0,32(sp)
    80003c52:	ec26                	sd	s1,24(sp)
    80003c54:	e84a                	sd	s2,16(sp)
    80003c56:	e44e                	sd	s3,8(sp)
    80003c58:	1800                	addi	s0,sp,48
    int r = 0;

    if (f->readable == 0)
    80003c5a:	00854783          	lbu	a5,8(a0)
    80003c5e:	c3d5                	beqz	a5,80003d02 <fileread+0xb6>
    80003c60:	84aa                	mv	s1,a0
    80003c62:	89ae                	mv	s3,a1
    80003c64:	8932                	mv	s2,a2
        return -1;

    if (f->type == FD_PIPE)
    80003c66:	411c                	lw	a5,0(a0)
    80003c68:	4705                	li	a4,1
    80003c6a:	04e78963          	beq	a5,a4,80003cbc <fileread+0x70>
    {
        r = piperead(f->pipe, addr, n);
    }
    else if (f->type == FD_DEVICE)
    80003c6e:	470d                	li	a4,3
    80003c70:	04e78d63          	beq	a5,a4,80003cca <fileread+0x7e>
    {
        if (f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
            return -1;
        r = devsw[f->major].read(1, addr, n);
    }
    else if (f->type == FD_INODE)
    80003c74:	4709                	li	a4,2
    80003c76:	06e79e63          	bne	a5,a4,80003cf2 <fileread+0xa6>
    {
        ilock(f->ip);
    80003c7a:	6d08                	ld	a0,24(a0)
    80003c7c:	fffff097          	auipc	ra,0xfffff
    80003c80:	fae080e7          	jalr	-82(ra) # 80002c2a <ilock>
        if ((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003c84:	874a                	mv	a4,s2
    80003c86:	5094                	lw	a3,32(s1)
    80003c88:	864e                	mv	a2,s3
    80003c8a:	4585                	li	a1,1
    80003c8c:	6c88                	ld	a0,24(s1)
    80003c8e:	fffff097          	auipc	ra,0xfffff
    80003c92:	250080e7          	jalr	592(ra) # 80002ede <readi>
    80003c96:	892a                	mv	s2,a0
    80003c98:	00a05563          	blez	a0,80003ca2 <fileread+0x56>
            f->off += r;
    80003c9c:	509c                	lw	a5,32(s1)
    80003c9e:	9fa9                	addw	a5,a5,a0
    80003ca0:	d09c                	sw	a5,32(s1)
        iunlock(f->ip);
    80003ca2:	6c88                	ld	a0,24(s1)
    80003ca4:	fffff097          	auipc	ra,0xfffff
    80003ca8:	048080e7          	jalr	72(ra) # 80002cec <iunlock>
    {
        panic("fileread");
    }

    return r;
}
    80003cac:	854a                	mv	a0,s2
    80003cae:	70a2                	ld	ra,40(sp)
    80003cb0:	7402                	ld	s0,32(sp)
    80003cb2:	64e2                	ld	s1,24(sp)
    80003cb4:	6942                	ld	s2,16(sp)
    80003cb6:	69a2                	ld	s3,8(sp)
    80003cb8:	6145                	addi	sp,sp,48
    80003cba:	8082                	ret
        r = piperead(f->pipe, addr, n);
    80003cbc:	6908                	ld	a0,16(a0)
    80003cbe:	00000097          	auipc	ra,0x0
    80003cc2:	3ce080e7          	jalr	974(ra) # 8000408c <piperead>
    80003cc6:	892a                	mv	s2,a0
    80003cc8:	b7d5                	j	80003cac <fileread+0x60>
        if (f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003cca:	02451783          	lh	a5,36(a0)
    80003cce:	03079693          	slli	a3,a5,0x30
    80003cd2:	92c1                	srli	a3,a3,0x30
    80003cd4:	4725                	li	a4,9
    80003cd6:	02d76863          	bltu	a4,a3,80003d06 <fileread+0xba>
    80003cda:	0792                	slli	a5,a5,0x4
    80003cdc:	00027717          	auipc	a4,0x27
    80003ce0:	d8c70713          	addi	a4,a4,-628 # 8002aa68 <devsw>
    80003ce4:	97ba                	add	a5,a5,a4
    80003ce6:	639c                	ld	a5,0(a5)
    80003ce8:	c38d                	beqz	a5,80003d0a <fileread+0xbe>
        r = devsw[f->major].read(1, addr, n);
    80003cea:	4505                	li	a0,1
    80003cec:	9782                	jalr	a5
    80003cee:	892a                	mv	s2,a0
    80003cf0:	bf75                	j	80003cac <fileread+0x60>
        panic("fileread");
    80003cf2:	00005517          	auipc	a0,0x5
    80003cf6:	a1650513          	addi	a0,a0,-1514 # 80008708 <syscalls+0x270>
    80003cfa:	00002097          	auipc	ra,0x2
    80003cfe:	1e8080e7          	jalr	488(ra) # 80005ee2 <panic>
        return -1;
    80003d02:	597d                	li	s2,-1
    80003d04:	b765                	j	80003cac <fileread+0x60>
            return -1;
    80003d06:	597d                	li	s2,-1
    80003d08:	b755                	j	80003cac <fileread+0x60>
    80003d0a:	597d                	li	s2,-1
    80003d0c:	b745                	j	80003cac <fileread+0x60>

0000000080003d0e <filewrite>:

// Write to file f.
// addr is a user virtual address.
int filewrite(struct file *f, uint64 addr, int n)
{
    80003d0e:	715d                	addi	sp,sp,-80
    80003d10:	e486                	sd	ra,72(sp)
    80003d12:	e0a2                	sd	s0,64(sp)
    80003d14:	fc26                	sd	s1,56(sp)
    80003d16:	f84a                	sd	s2,48(sp)
    80003d18:	f44e                	sd	s3,40(sp)
    80003d1a:	f052                	sd	s4,32(sp)
    80003d1c:	ec56                	sd	s5,24(sp)
    80003d1e:	e85a                	sd	s6,16(sp)
    80003d20:	e45e                	sd	s7,8(sp)
    80003d22:	e062                	sd	s8,0(sp)
    80003d24:	0880                	addi	s0,sp,80
    int r, ret = 0;

    if (f->writable == 0)
    80003d26:	00954783          	lbu	a5,9(a0)
    80003d2a:	10078663          	beqz	a5,80003e36 <filewrite+0x128>
    80003d2e:	892a                	mv	s2,a0
    80003d30:	8aae                	mv	s5,a1
    80003d32:	8a32                	mv	s4,a2
        return -1;

    if (f->type == FD_PIPE)
    80003d34:	411c                	lw	a5,0(a0)
    80003d36:	4705                	li	a4,1
    80003d38:	02e78263          	beq	a5,a4,80003d5c <filewrite+0x4e>
    {
        ret = pipewrite(f->pipe, addr, n);
    }
    else if (f->type == FD_DEVICE)
    80003d3c:	470d                	li	a4,3
    80003d3e:	02e78663          	beq	a5,a4,80003d6a <filewrite+0x5c>
    {
        if (f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
            return -1;
        ret = devsw[f->major].write(1, addr, n);
    }
    else if (f->type == FD_INODE)
    80003d42:	4709                	li	a4,2
    80003d44:	0ee79163          	bne	a5,a4,80003e26 <filewrite+0x118>
        // and 2 blocks of slop for non-aligned writes.
        // this really belongs lower down, since writei()
        // might be writing a device like the console.
        int max = ((MAXOPBLOCKS - 1 - 1 - 2) / 2) * BSIZE;
        int i = 0;
        while (i < n)
    80003d48:	0ac05d63          	blez	a2,80003e02 <filewrite+0xf4>
        int i = 0;
    80003d4c:	4981                	li	s3,0
    80003d4e:	6b05                	lui	s6,0x1
    80003d50:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003d54:	6b85                	lui	s7,0x1
    80003d56:	c00b8b9b          	addiw	s7,s7,-1024
    80003d5a:	a861                	j	80003df2 <filewrite+0xe4>
        ret = pipewrite(f->pipe, addr, n);
    80003d5c:	6908                	ld	a0,16(a0)
    80003d5e:	00000097          	auipc	ra,0x0
    80003d62:	22e080e7          	jalr	558(ra) # 80003f8c <pipewrite>
    80003d66:	8a2a                	mv	s4,a0
    80003d68:	a045                	j	80003e08 <filewrite+0xfa>
        if (f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003d6a:	02451783          	lh	a5,36(a0)
    80003d6e:	03079693          	slli	a3,a5,0x30
    80003d72:	92c1                	srli	a3,a3,0x30
    80003d74:	4725                	li	a4,9
    80003d76:	0cd76263          	bltu	a4,a3,80003e3a <filewrite+0x12c>
    80003d7a:	0792                	slli	a5,a5,0x4
    80003d7c:	00027717          	auipc	a4,0x27
    80003d80:	cec70713          	addi	a4,a4,-788 # 8002aa68 <devsw>
    80003d84:	97ba                	add	a5,a5,a4
    80003d86:	679c                	ld	a5,8(a5)
    80003d88:	cbdd                	beqz	a5,80003e3e <filewrite+0x130>
        ret = devsw[f->major].write(1, addr, n);
    80003d8a:	4505                	li	a0,1
    80003d8c:	9782                	jalr	a5
    80003d8e:	8a2a                	mv	s4,a0
    80003d90:	a8a5                	j	80003e08 <filewrite+0xfa>
    80003d92:	00048c1b          	sext.w	s8,s1
        {
            int n1 = n - i;
            if (n1 > max)
                n1 = max;

            begin_op();
    80003d96:	00000097          	auipc	ra,0x0
    80003d9a:	856080e7          	jalr	-1962(ra) # 800035ec <begin_op>
            ilock(f->ip);
    80003d9e:	01893503          	ld	a0,24(s2)
    80003da2:	fffff097          	auipc	ra,0xfffff
    80003da6:	e88080e7          	jalr	-376(ra) # 80002c2a <ilock>
            if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003daa:	8762                	mv	a4,s8
    80003dac:	02092683          	lw	a3,32(s2)
    80003db0:	01598633          	add	a2,s3,s5
    80003db4:	4585                	li	a1,1
    80003db6:	01893503          	ld	a0,24(s2)
    80003dba:	fffff097          	auipc	ra,0xfffff
    80003dbe:	21c080e7          	jalr	540(ra) # 80002fd6 <writei>
    80003dc2:	84aa                	mv	s1,a0
    80003dc4:	00a05763          	blez	a0,80003dd2 <filewrite+0xc4>
                f->off += r;
    80003dc8:	02092783          	lw	a5,32(s2)
    80003dcc:	9fa9                	addw	a5,a5,a0
    80003dce:	02f92023          	sw	a5,32(s2)
            iunlock(f->ip);
    80003dd2:	01893503          	ld	a0,24(s2)
    80003dd6:	fffff097          	auipc	ra,0xfffff
    80003dda:	f16080e7          	jalr	-234(ra) # 80002cec <iunlock>
            end_op();
    80003dde:	00000097          	auipc	ra,0x0
    80003de2:	88e080e7          	jalr	-1906(ra) # 8000366c <end_op>

            if (r != n1)
    80003de6:	009c1f63          	bne	s8,s1,80003e04 <filewrite+0xf6>
            {
                // error from writei
                break;
            }
            i += r;
    80003dea:	013489bb          	addw	s3,s1,s3
        while (i < n)
    80003dee:	0149db63          	bge	s3,s4,80003e04 <filewrite+0xf6>
            int n1 = n - i;
    80003df2:	413a07bb          	subw	a5,s4,s3
            if (n1 > max)
    80003df6:	84be                	mv	s1,a5
    80003df8:	2781                	sext.w	a5,a5
    80003dfa:	f8fb5ce3          	bge	s6,a5,80003d92 <filewrite+0x84>
    80003dfe:	84de                	mv	s1,s7
    80003e00:	bf49                	j	80003d92 <filewrite+0x84>
        int i = 0;
    80003e02:	4981                	li	s3,0
        }
        ret = (i == n ? n : -1);
    80003e04:	013a1f63          	bne	s4,s3,80003e22 <filewrite+0x114>
    {
        panic("filewrite");
    }

    return ret;
}
    80003e08:	8552                	mv	a0,s4
    80003e0a:	60a6                	ld	ra,72(sp)
    80003e0c:	6406                	ld	s0,64(sp)
    80003e0e:	74e2                	ld	s1,56(sp)
    80003e10:	7942                	ld	s2,48(sp)
    80003e12:	79a2                	ld	s3,40(sp)
    80003e14:	7a02                	ld	s4,32(sp)
    80003e16:	6ae2                	ld	s5,24(sp)
    80003e18:	6b42                	ld	s6,16(sp)
    80003e1a:	6ba2                	ld	s7,8(sp)
    80003e1c:	6c02                	ld	s8,0(sp)
    80003e1e:	6161                	addi	sp,sp,80
    80003e20:	8082                	ret
        ret = (i == n ? n : -1);
    80003e22:	5a7d                	li	s4,-1
    80003e24:	b7d5                	j	80003e08 <filewrite+0xfa>
        panic("filewrite");
    80003e26:	00005517          	auipc	a0,0x5
    80003e2a:	8f250513          	addi	a0,a0,-1806 # 80008718 <syscalls+0x280>
    80003e2e:	00002097          	auipc	ra,0x2
    80003e32:	0b4080e7          	jalr	180(ra) # 80005ee2 <panic>
        return -1;
    80003e36:	5a7d                	li	s4,-1
    80003e38:	bfc1                	j	80003e08 <filewrite+0xfa>
            return -1;
    80003e3a:	5a7d                	li	s4,-1
    80003e3c:	b7f1                	j	80003e08 <filewrite+0xfa>
    80003e3e:	5a7d                	li	s4,-1
    80003e40:	b7e1                	j	80003e08 <filewrite+0xfa>

0000000080003e42 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003e42:	7179                	addi	sp,sp,-48
    80003e44:	f406                	sd	ra,40(sp)
    80003e46:	f022                	sd	s0,32(sp)
    80003e48:	ec26                	sd	s1,24(sp)
    80003e4a:	e84a                	sd	s2,16(sp)
    80003e4c:	e44e                	sd	s3,8(sp)
    80003e4e:	e052                	sd	s4,0(sp)
    80003e50:	1800                	addi	s0,sp,48
    80003e52:	84aa                	mv	s1,a0
    80003e54:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003e56:	0005b023          	sd	zero,0(a1)
    80003e5a:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003e5e:	00000097          	auipc	ra,0x0
    80003e62:	b9e080e7          	jalr	-1122(ra) # 800039fc <filealloc>
    80003e66:	e088                	sd	a0,0(s1)
    80003e68:	c551                	beqz	a0,80003ef4 <pipealloc+0xb2>
    80003e6a:	00000097          	auipc	ra,0x0
    80003e6e:	b92080e7          	jalr	-1134(ra) # 800039fc <filealloc>
    80003e72:	00aa3023          	sd	a0,0(s4)
    80003e76:	c92d                	beqz	a0,80003ee8 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003e78:	ffffc097          	auipc	ra,0xffffc
    80003e7c:	2a0080e7          	jalr	672(ra) # 80000118 <kalloc>
    80003e80:	892a                	mv	s2,a0
    80003e82:	c125                	beqz	a0,80003ee2 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003e84:	4985                	li	s3,1
    80003e86:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003e8a:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003e8e:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003e92:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003e96:	00005597          	auipc	a1,0x5
    80003e9a:	89258593          	addi	a1,a1,-1902 # 80008728 <syscalls+0x290>
    80003e9e:	00002097          	auipc	ra,0x2
    80003ea2:	4fe080e7          	jalr	1278(ra) # 8000639c <initlock>
  (*f0)->type = FD_PIPE;
    80003ea6:	609c                	ld	a5,0(s1)
    80003ea8:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003eac:	609c                	ld	a5,0(s1)
    80003eae:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003eb2:	609c                	ld	a5,0(s1)
    80003eb4:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003eb8:	609c                	ld	a5,0(s1)
    80003eba:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003ebe:	000a3783          	ld	a5,0(s4)
    80003ec2:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003ec6:	000a3783          	ld	a5,0(s4)
    80003eca:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003ece:	000a3783          	ld	a5,0(s4)
    80003ed2:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003ed6:	000a3783          	ld	a5,0(s4)
    80003eda:	0127b823          	sd	s2,16(a5)
  return 0;
    80003ede:	4501                	li	a0,0
    80003ee0:	a025                	j	80003f08 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003ee2:	6088                	ld	a0,0(s1)
    80003ee4:	e501                	bnez	a0,80003eec <pipealloc+0xaa>
    80003ee6:	a039                	j	80003ef4 <pipealloc+0xb2>
    80003ee8:	6088                	ld	a0,0(s1)
    80003eea:	c51d                	beqz	a0,80003f18 <pipealloc+0xd6>
    fileclose(*f0);
    80003eec:	00000097          	auipc	ra,0x0
    80003ef0:	bcc080e7          	jalr	-1076(ra) # 80003ab8 <fileclose>
  if(*f1)
    80003ef4:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003ef8:	557d                	li	a0,-1
  if(*f1)
    80003efa:	c799                	beqz	a5,80003f08 <pipealloc+0xc6>
    fileclose(*f1);
    80003efc:	853e                	mv	a0,a5
    80003efe:	00000097          	auipc	ra,0x0
    80003f02:	bba080e7          	jalr	-1094(ra) # 80003ab8 <fileclose>
  return -1;
    80003f06:	557d                	li	a0,-1
}
    80003f08:	70a2                	ld	ra,40(sp)
    80003f0a:	7402                	ld	s0,32(sp)
    80003f0c:	64e2                	ld	s1,24(sp)
    80003f0e:	6942                	ld	s2,16(sp)
    80003f10:	69a2                	ld	s3,8(sp)
    80003f12:	6a02                	ld	s4,0(sp)
    80003f14:	6145                	addi	sp,sp,48
    80003f16:	8082                	ret
  return -1;
    80003f18:	557d                	li	a0,-1
    80003f1a:	b7fd                	j	80003f08 <pipealloc+0xc6>

0000000080003f1c <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003f1c:	1101                	addi	sp,sp,-32
    80003f1e:	ec06                	sd	ra,24(sp)
    80003f20:	e822                	sd	s0,16(sp)
    80003f22:	e426                	sd	s1,8(sp)
    80003f24:	e04a                	sd	s2,0(sp)
    80003f26:	1000                	addi	s0,sp,32
    80003f28:	84aa                	mv	s1,a0
    80003f2a:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003f2c:	00002097          	auipc	ra,0x2
    80003f30:	500080e7          	jalr	1280(ra) # 8000642c <acquire>
  if(writable){
    80003f34:	02090d63          	beqz	s2,80003f6e <pipeclose+0x52>
    pi->writeopen = 0;
    80003f38:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003f3c:	21848513          	addi	a0,s1,536
    80003f40:	ffffd097          	auipc	ra,0xffffd
    80003f44:	62a080e7          	jalr	1578(ra) # 8000156a <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003f48:	2204b783          	ld	a5,544(s1)
    80003f4c:	eb95                	bnez	a5,80003f80 <pipeclose+0x64>
    release(&pi->lock);
    80003f4e:	8526                	mv	a0,s1
    80003f50:	00002097          	auipc	ra,0x2
    80003f54:	590080e7          	jalr	1424(ra) # 800064e0 <release>
    kfree((char*)pi);
    80003f58:	8526                	mv	a0,s1
    80003f5a:	ffffc097          	auipc	ra,0xffffc
    80003f5e:	0c2080e7          	jalr	194(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003f62:	60e2                	ld	ra,24(sp)
    80003f64:	6442                	ld	s0,16(sp)
    80003f66:	64a2                	ld	s1,8(sp)
    80003f68:	6902                	ld	s2,0(sp)
    80003f6a:	6105                	addi	sp,sp,32
    80003f6c:	8082                	ret
    pi->readopen = 0;
    80003f6e:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003f72:	21c48513          	addi	a0,s1,540
    80003f76:	ffffd097          	auipc	ra,0xffffd
    80003f7a:	5f4080e7          	jalr	1524(ra) # 8000156a <wakeup>
    80003f7e:	b7e9                	j	80003f48 <pipeclose+0x2c>
    release(&pi->lock);
    80003f80:	8526                	mv	a0,s1
    80003f82:	00002097          	auipc	ra,0x2
    80003f86:	55e080e7          	jalr	1374(ra) # 800064e0 <release>
}
    80003f8a:	bfe1                	j	80003f62 <pipeclose+0x46>

0000000080003f8c <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003f8c:	7159                	addi	sp,sp,-112
    80003f8e:	f486                	sd	ra,104(sp)
    80003f90:	f0a2                	sd	s0,96(sp)
    80003f92:	eca6                	sd	s1,88(sp)
    80003f94:	e8ca                	sd	s2,80(sp)
    80003f96:	e4ce                	sd	s3,72(sp)
    80003f98:	e0d2                	sd	s4,64(sp)
    80003f9a:	fc56                	sd	s5,56(sp)
    80003f9c:	f85a                	sd	s6,48(sp)
    80003f9e:	f45e                	sd	s7,40(sp)
    80003fa0:	f062                	sd	s8,32(sp)
    80003fa2:	ec66                	sd	s9,24(sp)
    80003fa4:	1880                	addi	s0,sp,112
    80003fa6:	84aa                	mv	s1,a0
    80003fa8:	8aae                	mv	s5,a1
    80003faa:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003fac:	ffffd097          	auipc	ra,0xffffd
    80003fb0:	eb6080e7          	jalr	-330(ra) # 80000e62 <myproc>
    80003fb4:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003fb6:	8526                	mv	a0,s1
    80003fb8:	00002097          	auipc	ra,0x2
    80003fbc:	474080e7          	jalr	1140(ra) # 8000642c <acquire>
  while(i < n){
    80003fc0:	0d405463          	blez	s4,80004088 <pipewrite+0xfc>
    80003fc4:	8ba6                	mv	s7,s1
  int i = 0;
    80003fc6:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003fc8:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003fca:	21848c93          	addi	s9,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003fce:	21c48c13          	addi	s8,s1,540
    80003fd2:	a08d                	j	80004034 <pipewrite+0xa8>
      release(&pi->lock);
    80003fd4:	8526                	mv	a0,s1
    80003fd6:	00002097          	auipc	ra,0x2
    80003fda:	50a080e7          	jalr	1290(ra) # 800064e0 <release>
      return -1;
    80003fde:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003fe0:	854a                	mv	a0,s2
    80003fe2:	70a6                	ld	ra,104(sp)
    80003fe4:	7406                	ld	s0,96(sp)
    80003fe6:	64e6                	ld	s1,88(sp)
    80003fe8:	6946                	ld	s2,80(sp)
    80003fea:	69a6                	ld	s3,72(sp)
    80003fec:	6a06                	ld	s4,64(sp)
    80003fee:	7ae2                	ld	s5,56(sp)
    80003ff0:	7b42                	ld	s6,48(sp)
    80003ff2:	7ba2                	ld	s7,40(sp)
    80003ff4:	7c02                	ld	s8,32(sp)
    80003ff6:	6ce2                	ld	s9,24(sp)
    80003ff8:	6165                	addi	sp,sp,112
    80003ffa:	8082                	ret
      wakeup(&pi->nread);
    80003ffc:	8566                	mv	a0,s9
    80003ffe:	ffffd097          	auipc	ra,0xffffd
    80004002:	56c080e7          	jalr	1388(ra) # 8000156a <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80004006:	85de                	mv	a1,s7
    80004008:	8562                	mv	a0,s8
    8000400a:	ffffd097          	auipc	ra,0xffffd
    8000400e:	4fc080e7          	jalr	1276(ra) # 80001506 <sleep>
    80004012:	a839                	j	80004030 <pipewrite+0xa4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004014:	21c4a783          	lw	a5,540(s1)
    80004018:	0017871b          	addiw	a4,a5,1
    8000401c:	20e4ae23          	sw	a4,540(s1)
    80004020:	1ff7f793          	andi	a5,a5,511
    80004024:	97a6                	add	a5,a5,s1
    80004026:	f9f44703          	lbu	a4,-97(s0)
    8000402a:	00e78c23          	sb	a4,24(a5)
      i++;
    8000402e:	2905                	addiw	s2,s2,1
  while(i < n){
    80004030:	05495063          	bge	s2,s4,80004070 <pipewrite+0xe4>
    if(pi->readopen == 0 || killed(pr)){
    80004034:	2204a783          	lw	a5,544(s1)
    80004038:	dfd1                	beqz	a5,80003fd4 <pipewrite+0x48>
    8000403a:	854e                	mv	a0,s3
    8000403c:	ffffd097          	auipc	ra,0xffffd
    80004040:	772080e7          	jalr	1906(ra) # 800017ae <killed>
    80004044:	f941                	bnez	a0,80003fd4 <pipewrite+0x48>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004046:	2184a783          	lw	a5,536(s1)
    8000404a:	21c4a703          	lw	a4,540(s1)
    8000404e:	2007879b          	addiw	a5,a5,512
    80004052:	faf705e3          	beq	a4,a5,80003ffc <pipewrite+0x70>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004056:	4685                	li	a3,1
    80004058:	01590633          	add	a2,s2,s5
    8000405c:	f9f40593          	addi	a1,s0,-97
    80004060:	0509b503          	ld	a0,80(s3)
    80004064:	ffffd097          	auipc	ra,0xffffd
    80004068:	b48080e7          	jalr	-1208(ra) # 80000bac <copyin>
    8000406c:	fb6514e3          	bne	a0,s6,80004014 <pipewrite+0x88>
  wakeup(&pi->nread);
    80004070:	21848513          	addi	a0,s1,536
    80004074:	ffffd097          	auipc	ra,0xffffd
    80004078:	4f6080e7          	jalr	1270(ra) # 8000156a <wakeup>
  release(&pi->lock);
    8000407c:	8526                	mv	a0,s1
    8000407e:	00002097          	auipc	ra,0x2
    80004082:	462080e7          	jalr	1122(ra) # 800064e0 <release>
  return i;
    80004086:	bfa9                	j	80003fe0 <pipewrite+0x54>
  int i = 0;
    80004088:	4901                	li	s2,0
    8000408a:	b7dd                	j	80004070 <pipewrite+0xe4>

000000008000408c <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    8000408c:	715d                	addi	sp,sp,-80
    8000408e:	e486                	sd	ra,72(sp)
    80004090:	e0a2                	sd	s0,64(sp)
    80004092:	fc26                	sd	s1,56(sp)
    80004094:	f84a                	sd	s2,48(sp)
    80004096:	f44e                	sd	s3,40(sp)
    80004098:	f052                	sd	s4,32(sp)
    8000409a:	ec56                	sd	s5,24(sp)
    8000409c:	e85a                	sd	s6,16(sp)
    8000409e:	0880                	addi	s0,sp,80
    800040a0:	84aa                	mv	s1,a0
    800040a2:	892e                	mv	s2,a1
    800040a4:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800040a6:	ffffd097          	auipc	ra,0xffffd
    800040aa:	dbc080e7          	jalr	-580(ra) # 80000e62 <myproc>
    800040ae:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800040b0:	8b26                	mv	s6,s1
    800040b2:	8526                	mv	a0,s1
    800040b4:	00002097          	auipc	ra,0x2
    800040b8:	378080e7          	jalr	888(ra) # 8000642c <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800040bc:	2184a703          	lw	a4,536(s1)
    800040c0:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800040c4:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800040c8:	02f71763          	bne	a4,a5,800040f6 <piperead+0x6a>
    800040cc:	2244a783          	lw	a5,548(s1)
    800040d0:	c39d                	beqz	a5,800040f6 <piperead+0x6a>
    if(killed(pr)){
    800040d2:	8552                	mv	a0,s4
    800040d4:	ffffd097          	auipc	ra,0xffffd
    800040d8:	6da080e7          	jalr	1754(ra) # 800017ae <killed>
    800040dc:	e941                	bnez	a0,8000416c <piperead+0xe0>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800040de:	85da                	mv	a1,s6
    800040e0:	854e                	mv	a0,s3
    800040e2:	ffffd097          	auipc	ra,0xffffd
    800040e6:	424080e7          	jalr	1060(ra) # 80001506 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800040ea:	2184a703          	lw	a4,536(s1)
    800040ee:	21c4a783          	lw	a5,540(s1)
    800040f2:	fcf70de3          	beq	a4,a5,800040cc <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800040f6:	09505263          	blez	s5,8000417a <piperead+0xee>
    800040fa:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800040fc:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    800040fe:	2184a783          	lw	a5,536(s1)
    80004102:	21c4a703          	lw	a4,540(s1)
    80004106:	02f70d63          	beq	a4,a5,80004140 <piperead+0xb4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    8000410a:	0017871b          	addiw	a4,a5,1
    8000410e:	20e4ac23          	sw	a4,536(s1)
    80004112:	1ff7f793          	andi	a5,a5,511
    80004116:	97a6                	add	a5,a5,s1
    80004118:	0187c783          	lbu	a5,24(a5)
    8000411c:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004120:	4685                	li	a3,1
    80004122:	fbf40613          	addi	a2,s0,-65
    80004126:	85ca                	mv	a1,s2
    80004128:	050a3503          	ld	a0,80(s4)
    8000412c:	ffffd097          	auipc	ra,0xffffd
    80004130:	9f4080e7          	jalr	-1548(ra) # 80000b20 <copyout>
    80004134:	01650663          	beq	a0,s6,80004140 <piperead+0xb4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004138:	2985                	addiw	s3,s3,1
    8000413a:	0905                	addi	s2,s2,1
    8000413c:	fd3a91e3          	bne	s5,s3,800040fe <piperead+0x72>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004140:	21c48513          	addi	a0,s1,540
    80004144:	ffffd097          	auipc	ra,0xffffd
    80004148:	426080e7          	jalr	1062(ra) # 8000156a <wakeup>
  release(&pi->lock);
    8000414c:	8526                	mv	a0,s1
    8000414e:	00002097          	auipc	ra,0x2
    80004152:	392080e7          	jalr	914(ra) # 800064e0 <release>
  return i;
}
    80004156:	854e                	mv	a0,s3
    80004158:	60a6                	ld	ra,72(sp)
    8000415a:	6406                	ld	s0,64(sp)
    8000415c:	74e2                	ld	s1,56(sp)
    8000415e:	7942                	ld	s2,48(sp)
    80004160:	79a2                	ld	s3,40(sp)
    80004162:	7a02                	ld	s4,32(sp)
    80004164:	6ae2                	ld	s5,24(sp)
    80004166:	6b42                	ld	s6,16(sp)
    80004168:	6161                	addi	sp,sp,80
    8000416a:	8082                	ret
      release(&pi->lock);
    8000416c:	8526                	mv	a0,s1
    8000416e:	00002097          	auipc	ra,0x2
    80004172:	372080e7          	jalr	882(ra) # 800064e0 <release>
      return -1;
    80004176:	59fd                	li	s3,-1
    80004178:	bff9                	j	80004156 <piperead+0xca>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000417a:	4981                	li	s3,0
    8000417c:	b7d1                	j	80004140 <piperead+0xb4>

000000008000417e <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    8000417e:	1141                	addi	sp,sp,-16
    80004180:	e422                	sd	s0,8(sp)
    80004182:	0800                	addi	s0,sp,16
    80004184:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80004186:	8905                	andi	a0,a0,1
    80004188:	c111                	beqz	a0,8000418c <flags2perm+0xe>
      perm = PTE_X;
    8000418a:	4521                	li	a0,8
    if(flags & 0x2)
    8000418c:	8b89                	andi	a5,a5,2
    8000418e:	c399                	beqz	a5,80004194 <flags2perm+0x16>
      perm |= PTE_W;
    80004190:	00456513          	ori	a0,a0,4
    return perm;
}
    80004194:	6422                	ld	s0,8(sp)
    80004196:	0141                	addi	sp,sp,16
    80004198:	8082                	ret

000000008000419a <exec>:

int
exec(char *path, char **argv)
{
    8000419a:	df010113          	addi	sp,sp,-528
    8000419e:	20113423          	sd	ra,520(sp)
    800041a2:	20813023          	sd	s0,512(sp)
    800041a6:	ffa6                	sd	s1,504(sp)
    800041a8:	fbca                	sd	s2,496(sp)
    800041aa:	f7ce                	sd	s3,488(sp)
    800041ac:	f3d2                	sd	s4,480(sp)
    800041ae:	efd6                	sd	s5,472(sp)
    800041b0:	ebda                	sd	s6,464(sp)
    800041b2:	e7de                	sd	s7,456(sp)
    800041b4:	e3e2                	sd	s8,448(sp)
    800041b6:	ff66                	sd	s9,440(sp)
    800041b8:	fb6a                	sd	s10,432(sp)
    800041ba:	f76e                	sd	s11,424(sp)
    800041bc:	0c00                	addi	s0,sp,528
    800041be:	84aa                	mv	s1,a0
    800041c0:	dea43c23          	sd	a0,-520(s0)
    800041c4:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800041c8:	ffffd097          	auipc	ra,0xffffd
    800041cc:	c9a080e7          	jalr	-870(ra) # 80000e62 <myproc>
    800041d0:	892a                	mv	s2,a0

  begin_op();
    800041d2:	fffff097          	auipc	ra,0xfffff
    800041d6:	41a080e7          	jalr	1050(ra) # 800035ec <begin_op>

  if((ip = namei(path)) == 0){
    800041da:	8526                	mv	a0,s1
    800041dc:	fffff097          	auipc	ra,0xfffff
    800041e0:	1f4080e7          	jalr	500(ra) # 800033d0 <namei>
    800041e4:	c92d                	beqz	a0,80004256 <exec+0xbc>
    800041e6:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800041e8:	fffff097          	auipc	ra,0xfffff
    800041ec:	a42080e7          	jalr	-1470(ra) # 80002c2a <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800041f0:	04000713          	li	a4,64
    800041f4:	4681                	li	a3,0
    800041f6:	e5040613          	addi	a2,s0,-432
    800041fa:	4581                	li	a1,0
    800041fc:	8526                	mv	a0,s1
    800041fe:	fffff097          	auipc	ra,0xfffff
    80004202:	ce0080e7          	jalr	-800(ra) # 80002ede <readi>
    80004206:	04000793          	li	a5,64
    8000420a:	00f51a63          	bne	a0,a5,8000421e <exec+0x84>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    8000420e:	e5042703          	lw	a4,-432(s0)
    80004212:	464c47b7          	lui	a5,0x464c4
    80004216:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    8000421a:	04f70463          	beq	a4,a5,80004262 <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    8000421e:	8526                	mv	a0,s1
    80004220:	fffff097          	auipc	ra,0xfffff
    80004224:	c6c080e7          	jalr	-916(ra) # 80002e8c <iunlockput>
    end_op();
    80004228:	fffff097          	auipc	ra,0xfffff
    8000422c:	444080e7          	jalr	1092(ra) # 8000366c <end_op>
  }
  return -1;
    80004230:	557d                	li	a0,-1
}
    80004232:	20813083          	ld	ra,520(sp)
    80004236:	20013403          	ld	s0,512(sp)
    8000423a:	74fe                	ld	s1,504(sp)
    8000423c:	795e                	ld	s2,496(sp)
    8000423e:	79be                	ld	s3,488(sp)
    80004240:	7a1e                	ld	s4,480(sp)
    80004242:	6afe                	ld	s5,472(sp)
    80004244:	6b5e                	ld	s6,464(sp)
    80004246:	6bbe                	ld	s7,456(sp)
    80004248:	6c1e                	ld	s8,448(sp)
    8000424a:	7cfa                	ld	s9,440(sp)
    8000424c:	7d5a                	ld	s10,432(sp)
    8000424e:	7dba                	ld	s11,424(sp)
    80004250:	21010113          	addi	sp,sp,528
    80004254:	8082                	ret
    end_op();
    80004256:	fffff097          	auipc	ra,0xfffff
    8000425a:	416080e7          	jalr	1046(ra) # 8000366c <end_op>
    return -1;
    8000425e:	557d                	li	a0,-1
    80004260:	bfc9                	j	80004232 <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    80004262:	854a                	mv	a0,s2
    80004264:	ffffd097          	auipc	ra,0xffffd
    80004268:	cc2080e7          	jalr	-830(ra) # 80000f26 <proc_pagetable>
    8000426c:	8baa                	mv	s7,a0
    8000426e:	d945                	beqz	a0,8000421e <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004270:	e7042983          	lw	s3,-400(s0)
    80004274:	e8845783          	lhu	a5,-376(s0)
    80004278:	c7ad                	beqz	a5,800042e2 <exec+0x148>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000427a:	4a01                	li	s4,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000427c:	4b01                	li	s6,0
    if(ph.vaddr % PGSIZE != 0)
    8000427e:	6c85                	lui	s9,0x1
    80004280:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004284:	def43823          	sd	a5,-528(s0)
    80004288:	ac0d                	j	800044ba <exec+0x320>
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    8000428a:	00004517          	auipc	a0,0x4
    8000428e:	4a650513          	addi	a0,a0,1190 # 80008730 <syscalls+0x298>
    80004292:	00002097          	auipc	ra,0x2
    80004296:	c50080e7          	jalr	-944(ra) # 80005ee2 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    8000429a:	8756                	mv	a4,s5
    8000429c:	012d86bb          	addw	a3,s11,s2
    800042a0:	4581                	li	a1,0
    800042a2:	8526                	mv	a0,s1
    800042a4:	fffff097          	auipc	ra,0xfffff
    800042a8:	c3a080e7          	jalr	-966(ra) # 80002ede <readi>
    800042ac:	2501                	sext.w	a0,a0
    800042ae:	1aaa9a63          	bne	s5,a0,80004462 <exec+0x2c8>
  for(i = 0; i < sz; i += PGSIZE){
    800042b2:	6785                	lui	a5,0x1
    800042b4:	0127893b          	addw	s2,a5,s2
    800042b8:	77fd                	lui	a5,0xfffff
    800042ba:	01478a3b          	addw	s4,a5,s4
    800042be:	1f897563          	bgeu	s2,s8,800044a8 <exec+0x30e>
    pa = walkaddr(pagetable, va + i);
    800042c2:	02091593          	slli	a1,s2,0x20
    800042c6:	9181                	srli	a1,a1,0x20
    800042c8:	95ea                	add	a1,a1,s10
    800042ca:	855e                	mv	a0,s7
    800042cc:	ffffc097          	auipc	ra,0xffffc
    800042d0:	23e080e7          	jalr	574(ra) # 8000050a <walkaddr>
    800042d4:	862a                	mv	a2,a0
    if(pa == 0)
    800042d6:	d955                	beqz	a0,8000428a <exec+0xf0>
      n = PGSIZE;
    800042d8:	8ae6                	mv	s5,s9
    if(sz - i < PGSIZE)
    800042da:	fd9a70e3          	bgeu	s4,s9,8000429a <exec+0x100>
      n = sz - i;
    800042de:	8ad2                	mv	s5,s4
    800042e0:	bf6d                	j	8000429a <exec+0x100>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800042e2:	4a01                	li	s4,0
  iunlockput(ip);
    800042e4:	8526                	mv	a0,s1
    800042e6:	fffff097          	auipc	ra,0xfffff
    800042ea:	ba6080e7          	jalr	-1114(ra) # 80002e8c <iunlockput>
  end_op();
    800042ee:	fffff097          	auipc	ra,0xfffff
    800042f2:	37e080e7          	jalr	894(ra) # 8000366c <end_op>
  p = myproc();
    800042f6:	ffffd097          	auipc	ra,0xffffd
    800042fa:	b6c080e7          	jalr	-1172(ra) # 80000e62 <myproc>
    800042fe:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004300:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    80004304:	6785                	lui	a5,0x1
    80004306:	17fd                	addi	a5,a5,-1
    80004308:	9a3e                	add	s4,s4,a5
    8000430a:	757d                	lui	a0,0xfffff
    8000430c:	00aa77b3          	and	a5,s4,a0
    80004310:	e0f43423          	sd	a5,-504(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80004314:	4691                	li	a3,4
    80004316:	6609                	lui	a2,0x2
    80004318:	963e                	add	a2,a2,a5
    8000431a:	85be                	mv	a1,a5
    8000431c:	855e                	mv	a0,s7
    8000431e:	ffffc097          	auipc	ra,0xffffc
    80004322:	5b6080e7          	jalr	1462(ra) # 800008d4 <uvmalloc>
    80004326:	8b2a                	mv	s6,a0
  ip = 0;
    80004328:	4481                	li	s1,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    8000432a:	12050c63          	beqz	a0,80004462 <exec+0x2c8>
  uvmclear(pagetable, sz-2*PGSIZE);
    8000432e:	75f9                	lui	a1,0xffffe
    80004330:	95aa                	add	a1,a1,a0
    80004332:	855e                	mv	a0,s7
    80004334:	ffffc097          	auipc	ra,0xffffc
    80004338:	7ba080e7          	jalr	1978(ra) # 80000aee <uvmclear>
  stackbase = sp - PGSIZE;
    8000433c:	7c7d                	lui	s8,0xfffff
    8000433e:	9c5a                	add	s8,s8,s6
  for(argc = 0; argv[argc]; argc++) {
    80004340:	e0043783          	ld	a5,-512(s0)
    80004344:	6388                	ld	a0,0(a5)
    80004346:	c535                	beqz	a0,800043b2 <exec+0x218>
    80004348:	e9040993          	addi	s3,s0,-368
    8000434c:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    80004350:	895a                	mv	s2,s6
    sp -= strlen(argv[argc]) + 1;
    80004352:	ffffc097          	auipc	ra,0xffffc
    80004356:	faa080e7          	jalr	-86(ra) # 800002fc <strlen>
    8000435a:	2505                	addiw	a0,a0,1
    8000435c:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004360:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    80004364:	13896663          	bltu	s2,s8,80004490 <exec+0x2f6>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004368:	e0043d83          	ld	s11,-512(s0)
    8000436c:	000dba03          	ld	s4,0(s11)
    80004370:	8552                	mv	a0,s4
    80004372:	ffffc097          	auipc	ra,0xffffc
    80004376:	f8a080e7          	jalr	-118(ra) # 800002fc <strlen>
    8000437a:	0015069b          	addiw	a3,a0,1
    8000437e:	8652                	mv	a2,s4
    80004380:	85ca                	mv	a1,s2
    80004382:	855e                	mv	a0,s7
    80004384:	ffffc097          	auipc	ra,0xffffc
    80004388:	79c080e7          	jalr	1948(ra) # 80000b20 <copyout>
    8000438c:	10054663          	bltz	a0,80004498 <exec+0x2fe>
    ustack[argc] = sp;
    80004390:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004394:	0485                	addi	s1,s1,1
    80004396:	008d8793          	addi	a5,s11,8
    8000439a:	e0f43023          	sd	a5,-512(s0)
    8000439e:	008db503          	ld	a0,8(s11)
    800043a2:	c911                	beqz	a0,800043b6 <exec+0x21c>
    if(argc >= MAXARG)
    800043a4:	09a1                	addi	s3,s3,8
    800043a6:	fb3c96e3          	bne	s9,s3,80004352 <exec+0x1b8>
  sz = sz1;
    800043aa:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800043ae:	4481                	li	s1,0
    800043b0:	a84d                	j	80004462 <exec+0x2c8>
  sp = sz;
    800043b2:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    800043b4:	4481                	li	s1,0
  ustack[argc] = 0;
    800043b6:	00349793          	slli	a5,s1,0x3
    800043ba:	f9040713          	addi	a4,s0,-112
    800043be:	97ba                	add	a5,a5,a4
    800043c0:	f007b023          	sd	zero,-256(a5) # f00 <_entry-0x7ffff100>
  sp -= (argc+1) * sizeof(uint64);
    800043c4:	00148693          	addi	a3,s1,1
    800043c8:	068e                	slli	a3,a3,0x3
    800043ca:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800043ce:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    800043d2:	01897663          	bgeu	s2,s8,800043de <exec+0x244>
  sz = sz1;
    800043d6:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800043da:	4481                	li	s1,0
    800043dc:	a059                	j	80004462 <exec+0x2c8>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800043de:	e9040613          	addi	a2,s0,-368
    800043e2:	85ca                	mv	a1,s2
    800043e4:	855e                	mv	a0,s7
    800043e6:	ffffc097          	auipc	ra,0xffffc
    800043ea:	73a080e7          	jalr	1850(ra) # 80000b20 <copyout>
    800043ee:	0a054963          	bltz	a0,800044a0 <exec+0x306>
  p->trapframe->a1 = sp;
    800043f2:	058ab783          	ld	a5,88(s5)
    800043f6:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800043fa:	df843783          	ld	a5,-520(s0)
    800043fe:	0007c703          	lbu	a4,0(a5)
    80004402:	cf11                	beqz	a4,8000441e <exec+0x284>
    80004404:	0785                	addi	a5,a5,1
    if(*s == '/')
    80004406:	02f00693          	li	a3,47
    8000440a:	a039                	j	80004418 <exec+0x27e>
      last = s+1;
    8000440c:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80004410:	0785                	addi	a5,a5,1
    80004412:	fff7c703          	lbu	a4,-1(a5)
    80004416:	c701                	beqz	a4,8000441e <exec+0x284>
    if(*s == '/')
    80004418:	fed71ce3          	bne	a4,a3,80004410 <exec+0x276>
    8000441c:	bfc5                	j	8000440c <exec+0x272>
  safestrcpy(p->name, last, sizeof(p->name));
    8000441e:	4641                	li	a2,16
    80004420:	df843583          	ld	a1,-520(s0)
    80004424:	158a8513          	addi	a0,s5,344
    80004428:	ffffc097          	auipc	ra,0xffffc
    8000442c:	ea2080e7          	jalr	-350(ra) # 800002ca <safestrcpy>
  oldpagetable = p->pagetable;
    80004430:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80004434:	057ab823          	sd	s7,80(s5)
  p->sz = sz;
    80004438:	056ab423          	sd	s6,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    8000443c:	058ab783          	ld	a5,88(s5)
    80004440:	e6843703          	ld	a4,-408(s0)
    80004444:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004446:	058ab783          	ld	a5,88(s5)
    8000444a:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    8000444e:	85ea                	mv	a1,s10
    80004450:	ffffd097          	auipc	ra,0xffffd
    80004454:	b72080e7          	jalr	-1166(ra) # 80000fc2 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004458:	0004851b          	sext.w	a0,s1
    8000445c:	bbd9                	j	80004232 <exec+0x98>
    8000445e:	e1443423          	sd	s4,-504(s0)
    proc_freepagetable(pagetable, sz);
    80004462:	e0843583          	ld	a1,-504(s0)
    80004466:	855e                	mv	a0,s7
    80004468:	ffffd097          	auipc	ra,0xffffd
    8000446c:	b5a080e7          	jalr	-1190(ra) # 80000fc2 <proc_freepagetable>
  if(ip){
    80004470:	da0497e3          	bnez	s1,8000421e <exec+0x84>
  return -1;
    80004474:	557d                	li	a0,-1
    80004476:	bb75                	j	80004232 <exec+0x98>
    80004478:	e1443423          	sd	s4,-504(s0)
    8000447c:	b7dd                	j	80004462 <exec+0x2c8>
    8000447e:	e1443423          	sd	s4,-504(s0)
    80004482:	b7c5                	j	80004462 <exec+0x2c8>
    80004484:	e1443423          	sd	s4,-504(s0)
    80004488:	bfe9                	j	80004462 <exec+0x2c8>
    8000448a:	e1443423          	sd	s4,-504(s0)
    8000448e:	bfd1                	j	80004462 <exec+0x2c8>
  sz = sz1;
    80004490:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004494:	4481                	li	s1,0
    80004496:	b7f1                	j	80004462 <exec+0x2c8>
  sz = sz1;
    80004498:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    8000449c:	4481                	li	s1,0
    8000449e:	b7d1                	j	80004462 <exec+0x2c8>
  sz = sz1;
    800044a0:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800044a4:	4481                	li	s1,0
    800044a6:	bf75                	j	80004462 <exec+0x2c8>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800044a8:	e0843a03          	ld	s4,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800044ac:	2b05                	addiw	s6,s6,1
    800044ae:	0389899b          	addiw	s3,s3,56
    800044b2:	e8845783          	lhu	a5,-376(s0)
    800044b6:	e2fb57e3          	bge	s6,a5,800042e4 <exec+0x14a>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800044ba:	2981                	sext.w	s3,s3
    800044bc:	03800713          	li	a4,56
    800044c0:	86ce                	mv	a3,s3
    800044c2:	e1840613          	addi	a2,s0,-488
    800044c6:	4581                	li	a1,0
    800044c8:	8526                	mv	a0,s1
    800044ca:	fffff097          	auipc	ra,0xfffff
    800044ce:	a14080e7          	jalr	-1516(ra) # 80002ede <readi>
    800044d2:	03800793          	li	a5,56
    800044d6:	f8f514e3          	bne	a0,a5,8000445e <exec+0x2c4>
    if(ph.type != ELF_PROG_LOAD)
    800044da:	e1842783          	lw	a5,-488(s0)
    800044de:	4705                	li	a4,1
    800044e0:	fce796e3          	bne	a5,a4,800044ac <exec+0x312>
    if(ph.memsz < ph.filesz)
    800044e4:	e4043903          	ld	s2,-448(s0)
    800044e8:	e3843783          	ld	a5,-456(s0)
    800044ec:	f8f966e3          	bltu	s2,a5,80004478 <exec+0x2de>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800044f0:	e2843783          	ld	a5,-472(s0)
    800044f4:	993e                	add	s2,s2,a5
    800044f6:	f8f964e3          	bltu	s2,a5,8000447e <exec+0x2e4>
    if(ph.vaddr % PGSIZE != 0)
    800044fa:	df043703          	ld	a4,-528(s0)
    800044fe:	8ff9                	and	a5,a5,a4
    80004500:	f3d1                	bnez	a5,80004484 <exec+0x2ea>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004502:	e1c42503          	lw	a0,-484(s0)
    80004506:	00000097          	auipc	ra,0x0
    8000450a:	c78080e7          	jalr	-904(ra) # 8000417e <flags2perm>
    8000450e:	86aa                	mv	a3,a0
    80004510:	864a                	mv	a2,s2
    80004512:	85d2                	mv	a1,s4
    80004514:	855e                	mv	a0,s7
    80004516:	ffffc097          	auipc	ra,0xffffc
    8000451a:	3be080e7          	jalr	958(ra) # 800008d4 <uvmalloc>
    8000451e:	e0a43423          	sd	a0,-504(s0)
    80004522:	d525                	beqz	a0,8000448a <exec+0x2f0>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004524:	e2843d03          	ld	s10,-472(s0)
    80004528:	e2042d83          	lw	s11,-480(s0)
    8000452c:	e3842c03          	lw	s8,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004530:	f60c0ce3          	beqz	s8,800044a8 <exec+0x30e>
    80004534:	8a62                	mv	s4,s8
    80004536:	4901                	li	s2,0
    80004538:	b369                	j	800042c2 <exec+0x128>

000000008000453a <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    8000453a:	7179                	addi	sp,sp,-48
    8000453c:	f406                	sd	ra,40(sp)
    8000453e:	f022                	sd	s0,32(sp)
    80004540:	ec26                	sd	s1,24(sp)
    80004542:	e84a                	sd	s2,16(sp)
    80004544:	1800                	addi	s0,sp,48
    80004546:	892e                	mv	s2,a1
    80004548:	84b2                	mv	s1,a2
    int fd;
    struct file *f;

    argint(n, &fd);
    8000454a:	fdc40593          	addi	a1,s0,-36
    8000454e:	ffffe097          	auipc	ra,0xffffe
    80004552:	b62080e7          	jalr	-1182(ra) # 800020b0 <argint>
    if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0)
    80004556:	fdc42703          	lw	a4,-36(s0)
    8000455a:	47bd                	li	a5,15
    8000455c:	02e7eb63          	bltu	a5,a4,80004592 <argfd+0x58>
    80004560:	ffffd097          	auipc	ra,0xffffd
    80004564:	902080e7          	jalr	-1790(ra) # 80000e62 <myproc>
    80004568:	fdc42703          	lw	a4,-36(s0)
    8000456c:	01a70793          	addi	a5,a4,26
    80004570:	078e                	slli	a5,a5,0x3
    80004572:	953e                	add	a0,a0,a5
    80004574:	611c                	ld	a5,0(a0)
    80004576:	c385                	beqz	a5,80004596 <argfd+0x5c>
        return -1;
    if (pfd)
    80004578:	00090463          	beqz	s2,80004580 <argfd+0x46>
        *pfd = fd;
    8000457c:	00e92023          	sw	a4,0(s2)
    if (pf)
        *pf = f;
    return 0;
    80004580:	4501                	li	a0,0
    if (pf)
    80004582:	c091                	beqz	s1,80004586 <argfd+0x4c>
        *pf = f;
    80004584:	e09c                	sd	a5,0(s1)
}
    80004586:	70a2                	ld	ra,40(sp)
    80004588:	7402                	ld	s0,32(sp)
    8000458a:	64e2                	ld	s1,24(sp)
    8000458c:	6942                	ld	s2,16(sp)
    8000458e:	6145                	addi	sp,sp,48
    80004590:	8082                	ret
        return -1;
    80004592:	557d                	li	a0,-1
    80004594:	bfcd                	j	80004586 <argfd+0x4c>
    80004596:	557d                	li	a0,-1
    80004598:	b7fd                	j	80004586 <argfd+0x4c>

000000008000459a <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    8000459a:	1101                	addi	sp,sp,-32
    8000459c:	ec06                	sd	ra,24(sp)
    8000459e:	e822                	sd	s0,16(sp)
    800045a0:	e426                	sd	s1,8(sp)
    800045a2:	1000                	addi	s0,sp,32
    800045a4:	84aa                	mv	s1,a0
    int fd;
    struct proc *p = myproc();
    800045a6:	ffffd097          	auipc	ra,0xffffd
    800045aa:	8bc080e7          	jalr	-1860(ra) # 80000e62 <myproc>
    800045ae:	862a                	mv	a2,a0

    for (fd = 0; fd < NOFILE; fd++)
    800045b0:	0d050793          	addi	a5,a0,208 # fffffffffffff0d0 <end+0xffffffff7ffcb290>
    800045b4:	4501                	li	a0,0
    800045b6:	46c1                	li	a3,16
    {
        if (p->ofile[fd] == 0)
    800045b8:	6398                	ld	a4,0(a5)
    800045ba:	cb19                	beqz	a4,800045d0 <fdalloc+0x36>
    for (fd = 0; fd < NOFILE; fd++)
    800045bc:	2505                	addiw	a0,a0,1
    800045be:	07a1                	addi	a5,a5,8
    800045c0:	fed51ce3          	bne	a0,a3,800045b8 <fdalloc+0x1e>
        {
            p->ofile[fd] = f;
            return fd;
        }
    }
    return -1;
    800045c4:	557d                	li	a0,-1
}
    800045c6:	60e2                	ld	ra,24(sp)
    800045c8:	6442                	ld	s0,16(sp)
    800045ca:	64a2                	ld	s1,8(sp)
    800045cc:	6105                	addi	sp,sp,32
    800045ce:	8082                	ret
            p->ofile[fd] = f;
    800045d0:	01a50793          	addi	a5,a0,26
    800045d4:	078e                	slli	a5,a5,0x3
    800045d6:	963e                	add	a2,a2,a5
    800045d8:	e204                	sd	s1,0(a2)
            return fd;
    800045da:	b7f5                	j	800045c6 <fdalloc+0x2c>

00000000800045dc <create>:
    return 0;
}

static struct inode *
create(char *path, short type, short major, short minor)
{
    800045dc:	715d                	addi	sp,sp,-80
    800045de:	e486                	sd	ra,72(sp)
    800045e0:	e0a2                	sd	s0,64(sp)
    800045e2:	fc26                	sd	s1,56(sp)
    800045e4:	f84a                	sd	s2,48(sp)
    800045e6:	f44e                	sd	s3,40(sp)
    800045e8:	f052                	sd	s4,32(sp)
    800045ea:	ec56                	sd	s5,24(sp)
    800045ec:	e85a                	sd	s6,16(sp)
    800045ee:	0880                	addi	s0,sp,80
    800045f0:	8b2e                	mv	s6,a1
    800045f2:	89b2                	mv	s3,a2
    800045f4:	8936                	mv	s2,a3
    struct inode *ip, *dp;
    char name[DIRSIZ];

    if ((dp = nameiparent(path, name)) == 0)
    800045f6:	fb040593          	addi	a1,s0,-80
    800045fa:	fffff097          	auipc	ra,0xfffff
    800045fe:	df4080e7          	jalr	-524(ra) # 800033ee <nameiparent>
    80004602:	84aa                	mv	s1,a0
    80004604:	16050063          	beqz	a0,80004764 <create+0x188>
        return 0;

    ilock(dp);
    80004608:	ffffe097          	auipc	ra,0xffffe
    8000460c:	622080e7          	jalr	1570(ra) # 80002c2a <ilock>

    if ((ip = dirlookup(dp, name, 0)) != 0)
    80004610:	4601                	li	a2,0
    80004612:	fb040593          	addi	a1,s0,-80
    80004616:	8526                	mv	a0,s1
    80004618:	fffff097          	auipc	ra,0xfffff
    8000461c:	af6080e7          	jalr	-1290(ra) # 8000310e <dirlookup>
    80004620:	8aaa                	mv	s5,a0
    80004622:	c931                	beqz	a0,80004676 <create+0x9a>
    {
        iunlockput(dp);
    80004624:	8526                	mv	a0,s1
    80004626:	fffff097          	auipc	ra,0xfffff
    8000462a:	866080e7          	jalr	-1946(ra) # 80002e8c <iunlockput>
        ilock(ip);
    8000462e:	8556                	mv	a0,s5
    80004630:	ffffe097          	auipc	ra,0xffffe
    80004634:	5fa080e7          	jalr	1530(ra) # 80002c2a <ilock>
        if (type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004638:	000b059b          	sext.w	a1,s6
    8000463c:	4789                	li	a5,2
    8000463e:	02f59563          	bne	a1,a5,80004668 <create+0x8c>
    80004642:	044ad783          	lhu	a5,68(s5)
    80004646:	37f9                	addiw	a5,a5,-2
    80004648:	17c2                	slli	a5,a5,0x30
    8000464a:	93c1                	srli	a5,a5,0x30
    8000464c:	4705                	li	a4,1
    8000464e:	00f76d63          	bltu	a4,a5,80004668 <create+0x8c>
    ip->nlink = 0;
    iupdate(ip);
    iunlockput(ip);
    iunlockput(dp);
    return 0;
}
    80004652:	8556                	mv	a0,s5
    80004654:	60a6                	ld	ra,72(sp)
    80004656:	6406                	ld	s0,64(sp)
    80004658:	74e2                	ld	s1,56(sp)
    8000465a:	7942                	ld	s2,48(sp)
    8000465c:	79a2                	ld	s3,40(sp)
    8000465e:	7a02                	ld	s4,32(sp)
    80004660:	6ae2                	ld	s5,24(sp)
    80004662:	6b42                	ld	s6,16(sp)
    80004664:	6161                	addi	sp,sp,80
    80004666:	8082                	ret
        iunlockput(ip);
    80004668:	8556                	mv	a0,s5
    8000466a:	fffff097          	auipc	ra,0xfffff
    8000466e:	822080e7          	jalr	-2014(ra) # 80002e8c <iunlockput>
        return 0;
    80004672:	4a81                	li	s5,0
    80004674:	bff9                	j	80004652 <create+0x76>
    if ((ip = ialloc(dp->dev, type)) == 0)
    80004676:	85da                	mv	a1,s6
    80004678:	4088                	lw	a0,0(s1)
    8000467a:	ffffe097          	auipc	ra,0xffffe
    8000467e:	414080e7          	jalr	1044(ra) # 80002a8e <ialloc>
    80004682:	8a2a                	mv	s4,a0
    80004684:	c921                	beqz	a0,800046d4 <create+0xf8>
    ilock(ip);
    80004686:	ffffe097          	auipc	ra,0xffffe
    8000468a:	5a4080e7          	jalr	1444(ra) # 80002c2a <ilock>
    ip->major = major;
    8000468e:	053a1323          	sh	s3,70(s4)
    ip->minor = minor;
    80004692:	052a1423          	sh	s2,72(s4)
    ip->nlink = 1;
    80004696:	4785                	li	a5,1
    80004698:	04fa1523          	sh	a5,74(s4)
    iupdate(ip);
    8000469c:	8552                	mv	a0,s4
    8000469e:	ffffe097          	auipc	ra,0xffffe
    800046a2:	4c2080e7          	jalr	1218(ra) # 80002b60 <iupdate>
    if (type == T_DIR)
    800046a6:	000b059b          	sext.w	a1,s6
    800046aa:	4785                	li	a5,1
    800046ac:	02f58b63          	beq	a1,a5,800046e2 <create+0x106>
    if (dirlink(dp, name, ip->inum) < 0)
    800046b0:	004a2603          	lw	a2,4(s4)
    800046b4:	fb040593          	addi	a1,s0,-80
    800046b8:	8526                	mv	a0,s1
    800046ba:	fffff097          	auipc	ra,0xfffff
    800046be:	c64080e7          	jalr	-924(ra) # 8000331e <dirlink>
    800046c2:	06054f63          	bltz	a0,80004740 <create+0x164>
    iunlockput(dp);
    800046c6:	8526                	mv	a0,s1
    800046c8:	ffffe097          	auipc	ra,0xffffe
    800046cc:	7c4080e7          	jalr	1988(ra) # 80002e8c <iunlockput>
    return ip;
    800046d0:	8ad2                	mv	s5,s4
    800046d2:	b741                	j	80004652 <create+0x76>
        iunlockput(dp);
    800046d4:	8526                	mv	a0,s1
    800046d6:	ffffe097          	auipc	ra,0xffffe
    800046da:	7b6080e7          	jalr	1974(ra) # 80002e8c <iunlockput>
        return 0;
    800046de:	8ad2                	mv	s5,s4
    800046e0:	bf8d                	j	80004652 <create+0x76>
        if (dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800046e2:	004a2603          	lw	a2,4(s4)
    800046e6:	00004597          	auipc	a1,0x4
    800046ea:	06a58593          	addi	a1,a1,106 # 80008750 <syscalls+0x2b8>
    800046ee:	8552                	mv	a0,s4
    800046f0:	fffff097          	auipc	ra,0xfffff
    800046f4:	c2e080e7          	jalr	-978(ra) # 8000331e <dirlink>
    800046f8:	04054463          	bltz	a0,80004740 <create+0x164>
    800046fc:	40d0                	lw	a2,4(s1)
    800046fe:	00004597          	auipc	a1,0x4
    80004702:	05a58593          	addi	a1,a1,90 # 80008758 <syscalls+0x2c0>
    80004706:	8552                	mv	a0,s4
    80004708:	fffff097          	auipc	ra,0xfffff
    8000470c:	c16080e7          	jalr	-1002(ra) # 8000331e <dirlink>
    80004710:	02054863          	bltz	a0,80004740 <create+0x164>
    if (dirlink(dp, name, ip->inum) < 0)
    80004714:	004a2603          	lw	a2,4(s4)
    80004718:	fb040593          	addi	a1,s0,-80
    8000471c:	8526                	mv	a0,s1
    8000471e:	fffff097          	auipc	ra,0xfffff
    80004722:	c00080e7          	jalr	-1024(ra) # 8000331e <dirlink>
    80004726:	00054d63          	bltz	a0,80004740 <create+0x164>
        dp->nlink++; // for ".."
    8000472a:	04a4d783          	lhu	a5,74(s1)
    8000472e:	2785                	addiw	a5,a5,1
    80004730:	04f49523          	sh	a5,74(s1)
        iupdate(dp);
    80004734:	8526                	mv	a0,s1
    80004736:	ffffe097          	auipc	ra,0xffffe
    8000473a:	42a080e7          	jalr	1066(ra) # 80002b60 <iupdate>
    8000473e:	b761                	j	800046c6 <create+0xea>
    ip->nlink = 0;
    80004740:	040a1523          	sh	zero,74(s4)
    iupdate(ip);
    80004744:	8552                	mv	a0,s4
    80004746:	ffffe097          	auipc	ra,0xffffe
    8000474a:	41a080e7          	jalr	1050(ra) # 80002b60 <iupdate>
    iunlockput(ip);
    8000474e:	8552                	mv	a0,s4
    80004750:	ffffe097          	auipc	ra,0xffffe
    80004754:	73c080e7          	jalr	1852(ra) # 80002e8c <iunlockput>
    iunlockput(dp);
    80004758:	8526                	mv	a0,s1
    8000475a:	ffffe097          	auipc	ra,0xffffe
    8000475e:	732080e7          	jalr	1842(ra) # 80002e8c <iunlockput>
    return 0;
    80004762:	bdc5                	j	80004652 <create+0x76>
        return 0;
    80004764:	8aaa                	mv	s5,a0
    80004766:	b5f5                	j	80004652 <create+0x76>

0000000080004768 <sys_dup>:
{
    80004768:	7179                	addi	sp,sp,-48
    8000476a:	f406                	sd	ra,40(sp)
    8000476c:	f022                	sd	s0,32(sp)
    8000476e:	ec26                	sd	s1,24(sp)
    80004770:	1800                	addi	s0,sp,48
    if (argfd(0, 0, &f) < 0)
    80004772:	fd840613          	addi	a2,s0,-40
    80004776:	4581                	li	a1,0
    80004778:	4501                	li	a0,0
    8000477a:	00000097          	auipc	ra,0x0
    8000477e:	dc0080e7          	jalr	-576(ra) # 8000453a <argfd>
        return -1;
    80004782:	57fd                	li	a5,-1
    if (argfd(0, 0, &f) < 0)
    80004784:	02054363          	bltz	a0,800047aa <sys_dup+0x42>
    if ((fd = fdalloc(f)) < 0)
    80004788:	fd843503          	ld	a0,-40(s0)
    8000478c:	00000097          	auipc	ra,0x0
    80004790:	e0e080e7          	jalr	-498(ra) # 8000459a <fdalloc>
    80004794:	84aa                	mv	s1,a0
        return -1;
    80004796:	57fd                	li	a5,-1
    if ((fd = fdalloc(f)) < 0)
    80004798:	00054963          	bltz	a0,800047aa <sys_dup+0x42>
    filedup(f);
    8000479c:	fd843503          	ld	a0,-40(s0)
    800047a0:	fffff097          	auipc	ra,0xfffff
    800047a4:	2c6080e7          	jalr	710(ra) # 80003a66 <filedup>
    return fd;
    800047a8:	87a6                	mv	a5,s1
}
    800047aa:	853e                	mv	a0,a5
    800047ac:	70a2                	ld	ra,40(sp)
    800047ae:	7402                	ld	s0,32(sp)
    800047b0:	64e2                	ld	s1,24(sp)
    800047b2:	6145                	addi	sp,sp,48
    800047b4:	8082                	ret

00000000800047b6 <sys_read>:
{
    800047b6:	7179                	addi	sp,sp,-48
    800047b8:	f406                	sd	ra,40(sp)
    800047ba:	f022                	sd	s0,32(sp)
    800047bc:	1800                	addi	s0,sp,48
    argaddr(1, &p);
    800047be:	fd840593          	addi	a1,s0,-40
    800047c2:	4505                	li	a0,1
    800047c4:	ffffe097          	auipc	ra,0xffffe
    800047c8:	90c080e7          	jalr	-1780(ra) # 800020d0 <argaddr>
    argint(2, &n);
    800047cc:	fe440593          	addi	a1,s0,-28
    800047d0:	4509                	li	a0,2
    800047d2:	ffffe097          	auipc	ra,0xffffe
    800047d6:	8de080e7          	jalr	-1826(ra) # 800020b0 <argint>
    if (argfd(0, 0, &f) < 0)
    800047da:	fe840613          	addi	a2,s0,-24
    800047de:	4581                	li	a1,0
    800047e0:	4501                	li	a0,0
    800047e2:	00000097          	auipc	ra,0x0
    800047e6:	d58080e7          	jalr	-680(ra) # 8000453a <argfd>
    800047ea:	87aa                	mv	a5,a0
        return -1;
    800047ec:	557d                	li	a0,-1
    if (argfd(0, 0, &f) < 0)
    800047ee:	0007cc63          	bltz	a5,80004806 <sys_read+0x50>
    return fileread(f, p, n);
    800047f2:	fe442603          	lw	a2,-28(s0)
    800047f6:	fd843583          	ld	a1,-40(s0)
    800047fa:	fe843503          	ld	a0,-24(s0)
    800047fe:	fffff097          	auipc	ra,0xfffff
    80004802:	44e080e7          	jalr	1102(ra) # 80003c4c <fileread>
}
    80004806:	70a2                	ld	ra,40(sp)
    80004808:	7402                	ld	s0,32(sp)
    8000480a:	6145                	addi	sp,sp,48
    8000480c:	8082                	ret

000000008000480e <sys_write>:
{
    8000480e:	7179                	addi	sp,sp,-48
    80004810:	f406                	sd	ra,40(sp)
    80004812:	f022                	sd	s0,32(sp)
    80004814:	1800                	addi	s0,sp,48
    argaddr(1, &p);
    80004816:	fd840593          	addi	a1,s0,-40
    8000481a:	4505                	li	a0,1
    8000481c:	ffffe097          	auipc	ra,0xffffe
    80004820:	8b4080e7          	jalr	-1868(ra) # 800020d0 <argaddr>
    argint(2, &n);
    80004824:	fe440593          	addi	a1,s0,-28
    80004828:	4509                	li	a0,2
    8000482a:	ffffe097          	auipc	ra,0xffffe
    8000482e:	886080e7          	jalr	-1914(ra) # 800020b0 <argint>
    if (argfd(0, 0, &f) < 0)
    80004832:	fe840613          	addi	a2,s0,-24
    80004836:	4581                	li	a1,0
    80004838:	4501                	li	a0,0
    8000483a:	00000097          	auipc	ra,0x0
    8000483e:	d00080e7          	jalr	-768(ra) # 8000453a <argfd>
    80004842:	87aa                	mv	a5,a0
        return -1;
    80004844:	557d                	li	a0,-1
    if (argfd(0, 0, &f) < 0)
    80004846:	0007cc63          	bltz	a5,8000485e <sys_write+0x50>
    return filewrite(f, p, n);
    8000484a:	fe442603          	lw	a2,-28(s0)
    8000484e:	fd843583          	ld	a1,-40(s0)
    80004852:	fe843503          	ld	a0,-24(s0)
    80004856:	fffff097          	auipc	ra,0xfffff
    8000485a:	4b8080e7          	jalr	1208(ra) # 80003d0e <filewrite>
}
    8000485e:	70a2                	ld	ra,40(sp)
    80004860:	7402                	ld	s0,32(sp)
    80004862:	6145                	addi	sp,sp,48
    80004864:	8082                	ret

0000000080004866 <sys_close>:
{
    80004866:	1101                	addi	sp,sp,-32
    80004868:	ec06                	sd	ra,24(sp)
    8000486a:	e822                	sd	s0,16(sp)
    8000486c:	1000                	addi	s0,sp,32
    if (argfd(0, &fd, &f) < 0)
    8000486e:	fe040613          	addi	a2,s0,-32
    80004872:	fec40593          	addi	a1,s0,-20
    80004876:	4501                	li	a0,0
    80004878:	00000097          	auipc	ra,0x0
    8000487c:	cc2080e7          	jalr	-830(ra) # 8000453a <argfd>
        return -1;
    80004880:	57fd                	li	a5,-1
    if (argfd(0, &fd, &f) < 0)
    80004882:	02054463          	bltz	a0,800048aa <sys_close+0x44>
    myproc()->ofile[fd] = 0;
    80004886:	ffffc097          	auipc	ra,0xffffc
    8000488a:	5dc080e7          	jalr	1500(ra) # 80000e62 <myproc>
    8000488e:	fec42783          	lw	a5,-20(s0)
    80004892:	07e9                	addi	a5,a5,26
    80004894:	078e                	slli	a5,a5,0x3
    80004896:	97aa                	add	a5,a5,a0
    80004898:	0007b023          	sd	zero,0(a5)
    fileclose(f);
    8000489c:	fe043503          	ld	a0,-32(s0)
    800048a0:	fffff097          	auipc	ra,0xfffff
    800048a4:	218080e7          	jalr	536(ra) # 80003ab8 <fileclose>
    return 0;
    800048a8:	4781                	li	a5,0
}
    800048aa:	853e                	mv	a0,a5
    800048ac:	60e2                	ld	ra,24(sp)
    800048ae:	6442                	ld	s0,16(sp)
    800048b0:	6105                	addi	sp,sp,32
    800048b2:	8082                	ret

00000000800048b4 <sys_fstat>:
{
    800048b4:	1101                	addi	sp,sp,-32
    800048b6:	ec06                	sd	ra,24(sp)
    800048b8:	e822                	sd	s0,16(sp)
    800048ba:	1000                	addi	s0,sp,32
    argaddr(1, &st);
    800048bc:	fe040593          	addi	a1,s0,-32
    800048c0:	4505                	li	a0,1
    800048c2:	ffffe097          	auipc	ra,0xffffe
    800048c6:	80e080e7          	jalr	-2034(ra) # 800020d0 <argaddr>
    if (argfd(0, 0, &f) < 0)
    800048ca:	fe840613          	addi	a2,s0,-24
    800048ce:	4581                	li	a1,0
    800048d0:	4501                	li	a0,0
    800048d2:	00000097          	auipc	ra,0x0
    800048d6:	c68080e7          	jalr	-920(ra) # 8000453a <argfd>
    800048da:	87aa                	mv	a5,a0
        return -1;
    800048dc:	557d                	li	a0,-1
    if (argfd(0, 0, &f) < 0)
    800048de:	0007ca63          	bltz	a5,800048f2 <sys_fstat+0x3e>
    return filestat(f, st);
    800048e2:	fe043583          	ld	a1,-32(s0)
    800048e6:	fe843503          	ld	a0,-24(s0)
    800048ea:	fffff097          	auipc	ra,0xfffff
    800048ee:	296080e7          	jalr	662(ra) # 80003b80 <filestat>
}
    800048f2:	60e2                	ld	ra,24(sp)
    800048f4:	6442                	ld	s0,16(sp)
    800048f6:	6105                	addi	sp,sp,32
    800048f8:	8082                	ret

00000000800048fa <sys_link>:
{
    800048fa:	7169                	addi	sp,sp,-304
    800048fc:	f606                	sd	ra,296(sp)
    800048fe:	f222                	sd	s0,288(sp)
    80004900:	ee26                	sd	s1,280(sp)
    80004902:	ea4a                	sd	s2,272(sp)
    80004904:	1a00                	addi	s0,sp,304
    if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004906:	08000613          	li	a2,128
    8000490a:	ed040593          	addi	a1,s0,-304
    8000490e:	4501                	li	a0,0
    80004910:	ffffd097          	auipc	ra,0xffffd
    80004914:	7e0080e7          	jalr	2016(ra) # 800020f0 <argstr>
        return -1;
    80004918:	57fd                	li	a5,-1
    if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000491a:	10054e63          	bltz	a0,80004a36 <sys_link+0x13c>
    8000491e:	08000613          	li	a2,128
    80004922:	f5040593          	addi	a1,s0,-176
    80004926:	4505                	li	a0,1
    80004928:	ffffd097          	auipc	ra,0xffffd
    8000492c:	7c8080e7          	jalr	1992(ra) # 800020f0 <argstr>
        return -1;
    80004930:	57fd                	li	a5,-1
    if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004932:	10054263          	bltz	a0,80004a36 <sys_link+0x13c>
    begin_op();
    80004936:	fffff097          	auipc	ra,0xfffff
    8000493a:	cb6080e7          	jalr	-842(ra) # 800035ec <begin_op>
    if ((ip = namei(old)) == 0)
    8000493e:	ed040513          	addi	a0,s0,-304
    80004942:	fffff097          	auipc	ra,0xfffff
    80004946:	a8e080e7          	jalr	-1394(ra) # 800033d0 <namei>
    8000494a:	84aa                	mv	s1,a0
    8000494c:	c551                	beqz	a0,800049d8 <sys_link+0xde>
    ilock(ip);
    8000494e:	ffffe097          	auipc	ra,0xffffe
    80004952:	2dc080e7          	jalr	732(ra) # 80002c2a <ilock>
    if (ip->type == T_DIR)
    80004956:	04449703          	lh	a4,68(s1)
    8000495a:	4785                	li	a5,1
    8000495c:	08f70463          	beq	a4,a5,800049e4 <sys_link+0xea>
    ip->nlink++;
    80004960:	04a4d783          	lhu	a5,74(s1)
    80004964:	2785                	addiw	a5,a5,1
    80004966:	04f49523          	sh	a5,74(s1)
    iupdate(ip);
    8000496a:	8526                	mv	a0,s1
    8000496c:	ffffe097          	auipc	ra,0xffffe
    80004970:	1f4080e7          	jalr	500(ra) # 80002b60 <iupdate>
    iunlock(ip);
    80004974:	8526                	mv	a0,s1
    80004976:	ffffe097          	auipc	ra,0xffffe
    8000497a:	376080e7          	jalr	886(ra) # 80002cec <iunlock>
    if ((dp = nameiparent(new, name)) == 0)
    8000497e:	fd040593          	addi	a1,s0,-48
    80004982:	f5040513          	addi	a0,s0,-176
    80004986:	fffff097          	auipc	ra,0xfffff
    8000498a:	a68080e7          	jalr	-1432(ra) # 800033ee <nameiparent>
    8000498e:	892a                	mv	s2,a0
    80004990:	c935                	beqz	a0,80004a04 <sys_link+0x10a>
    ilock(dp);
    80004992:	ffffe097          	auipc	ra,0xffffe
    80004996:	298080e7          	jalr	664(ra) # 80002c2a <ilock>
    if (dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0)
    8000499a:	00092703          	lw	a4,0(s2)
    8000499e:	409c                	lw	a5,0(s1)
    800049a0:	04f71d63          	bne	a4,a5,800049fa <sys_link+0x100>
    800049a4:	40d0                	lw	a2,4(s1)
    800049a6:	fd040593          	addi	a1,s0,-48
    800049aa:	854a                	mv	a0,s2
    800049ac:	fffff097          	auipc	ra,0xfffff
    800049b0:	972080e7          	jalr	-1678(ra) # 8000331e <dirlink>
    800049b4:	04054363          	bltz	a0,800049fa <sys_link+0x100>
    iunlockput(dp);
    800049b8:	854a                	mv	a0,s2
    800049ba:	ffffe097          	auipc	ra,0xffffe
    800049be:	4d2080e7          	jalr	1234(ra) # 80002e8c <iunlockput>
    iput(ip);
    800049c2:	8526                	mv	a0,s1
    800049c4:	ffffe097          	auipc	ra,0xffffe
    800049c8:	420080e7          	jalr	1056(ra) # 80002de4 <iput>
    end_op();
    800049cc:	fffff097          	auipc	ra,0xfffff
    800049d0:	ca0080e7          	jalr	-864(ra) # 8000366c <end_op>
    return 0;
    800049d4:	4781                	li	a5,0
    800049d6:	a085                	j	80004a36 <sys_link+0x13c>
        end_op();
    800049d8:	fffff097          	auipc	ra,0xfffff
    800049dc:	c94080e7          	jalr	-876(ra) # 8000366c <end_op>
        return -1;
    800049e0:	57fd                	li	a5,-1
    800049e2:	a891                	j	80004a36 <sys_link+0x13c>
        iunlockput(ip);
    800049e4:	8526                	mv	a0,s1
    800049e6:	ffffe097          	auipc	ra,0xffffe
    800049ea:	4a6080e7          	jalr	1190(ra) # 80002e8c <iunlockput>
        end_op();
    800049ee:	fffff097          	auipc	ra,0xfffff
    800049f2:	c7e080e7          	jalr	-898(ra) # 8000366c <end_op>
        return -1;
    800049f6:	57fd                	li	a5,-1
    800049f8:	a83d                	j	80004a36 <sys_link+0x13c>
        iunlockput(dp);
    800049fa:	854a                	mv	a0,s2
    800049fc:	ffffe097          	auipc	ra,0xffffe
    80004a00:	490080e7          	jalr	1168(ra) # 80002e8c <iunlockput>
    ilock(ip);
    80004a04:	8526                	mv	a0,s1
    80004a06:	ffffe097          	auipc	ra,0xffffe
    80004a0a:	224080e7          	jalr	548(ra) # 80002c2a <ilock>
    ip->nlink--;
    80004a0e:	04a4d783          	lhu	a5,74(s1)
    80004a12:	37fd                	addiw	a5,a5,-1
    80004a14:	04f49523          	sh	a5,74(s1)
    iupdate(ip);
    80004a18:	8526                	mv	a0,s1
    80004a1a:	ffffe097          	auipc	ra,0xffffe
    80004a1e:	146080e7          	jalr	326(ra) # 80002b60 <iupdate>
    iunlockput(ip);
    80004a22:	8526                	mv	a0,s1
    80004a24:	ffffe097          	auipc	ra,0xffffe
    80004a28:	468080e7          	jalr	1128(ra) # 80002e8c <iunlockput>
    end_op();
    80004a2c:	fffff097          	auipc	ra,0xfffff
    80004a30:	c40080e7          	jalr	-960(ra) # 8000366c <end_op>
    return -1;
    80004a34:	57fd                	li	a5,-1
}
    80004a36:	853e                	mv	a0,a5
    80004a38:	70b2                	ld	ra,296(sp)
    80004a3a:	7412                	ld	s0,288(sp)
    80004a3c:	64f2                	ld	s1,280(sp)
    80004a3e:	6952                	ld	s2,272(sp)
    80004a40:	6155                	addi	sp,sp,304
    80004a42:	8082                	ret

0000000080004a44 <sys_unlink>:
{
    80004a44:	7151                	addi	sp,sp,-240
    80004a46:	f586                	sd	ra,232(sp)
    80004a48:	f1a2                	sd	s0,224(sp)
    80004a4a:	eda6                	sd	s1,216(sp)
    80004a4c:	e9ca                	sd	s2,208(sp)
    80004a4e:	e5ce                	sd	s3,200(sp)
    80004a50:	1980                	addi	s0,sp,240
    if (argstr(0, path, MAXPATH) < 0)
    80004a52:	08000613          	li	a2,128
    80004a56:	f3040593          	addi	a1,s0,-208
    80004a5a:	4501                	li	a0,0
    80004a5c:	ffffd097          	auipc	ra,0xffffd
    80004a60:	694080e7          	jalr	1684(ra) # 800020f0 <argstr>
    80004a64:	18054163          	bltz	a0,80004be6 <sys_unlink+0x1a2>
    begin_op();
    80004a68:	fffff097          	auipc	ra,0xfffff
    80004a6c:	b84080e7          	jalr	-1148(ra) # 800035ec <begin_op>
    if ((dp = nameiparent(path, name)) == 0)
    80004a70:	fb040593          	addi	a1,s0,-80
    80004a74:	f3040513          	addi	a0,s0,-208
    80004a78:	fffff097          	auipc	ra,0xfffff
    80004a7c:	976080e7          	jalr	-1674(ra) # 800033ee <nameiparent>
    80004a80:	84aa                	mv	s1,a0
    80004a82:	c979                	beqz	a0,80004b58 <sys_unlink+0x114>
    ilock(dp);
    80004a84:	ffffe097          	auipc	ra,0xffffe
    80004a88:	1a6080e7          	jalr	422(ra) # 80002c2a <ilock>
    if (namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004a8c:	00004597          	auipc	a1,0x4
    80004a90:	cc458593          	addi	a1,a1,-828 # 80008750 <syscalls+0x2b8>
    80004a94:	fb040513          	addi	a0,s0,-80
    80004a98:	ffffe097          	auipc	ra,0xffffe
    80004a9c:	65c080e7          	jalr	1628(ra) # 800030f4 <namecmp>
    80004aa0:	14050a63          	beqz	a0,80004bf4 <sys_unlink+0x1b0>
    80004aa4:	00004597          	auipc	a1,0x4
    80004aa8:	cb458593          	addi	a1,a1,-844 # 80008758 <syscalls+0x2c0>
    80004aac:	fb040513          	addi	a0,s0,-80
    80004ab0:	ffffe097          	auipc	ra,0xffffe
    80004ab4:	644080e7          	jalr	1604(ra) # 800030f4 <namecmp>
    80004ab8:	12050e63          	beqz	a0,80004bf4 <sys_unlink+0x1b0>
    if ((ip = dirlookup(dp, name, &off)) == 0)
    80004abc:	f2c40613          	addi	a2,s0,-212
    80004ac0:	fb040593          	addi	a1,s0,-80
    80004ac4:	8526                	mv	a0,s1
    80004ac6:	ffffe097          	auipc	ra,0xffffe
    80004aca:	648080e7          	jalr	1608(ra) # 8000310e <dirlookup>
    80004ace:	892a                	mv	s2,a0
    80004ad0:	12050263          	beqz	a0,80004bf4 <sys_unlink+0x1b0>
    ilock(ip);
    80004ad4:	ffffe097          	auipc	ra,0xffffe
    80004ad8:	156080e7          	jalr	342(ra) # 80002c2a <ilock>
    if (ip->nlink < 1)
    80004adc:	04a91783          	lh	a5,74(s2)
    80004ae0:	08f05263          	blez	a5,80004b64 <sys_unlink+0x120>
    if (ip->type == T_DIR && !isdirempty(ip))
    80004ae4:	04491703          	lh	a4,68(s2)
    80004ae8:	4785                	li	a5,1
    80004aea:	08f70563          	beq	a4,a5,80004b74 <sys_unlink+0x130>
    memset(&de, 0, sizeof(de));
    80004aee:	4641                	li	a2,16
    80004af0:	4581                	li	a1,0
    80004af2:	fc040513          	addi	a0,s0,-64
    80004af6:	ffffb097          	auipc	ra,0xffffb
    80004afa:	682080e7          	jalr	1666(ra) # 80000178 <memset>
    if (writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004afe:	4741                	li	a4,16
    80004b00:	f2c42683          	lw	a3,-212(s0)
    80004b04:	fc040613          	addi	a2,s0,-64
    80004b08:	4581                	li	a1,0
    80004b0a:	8526                	mv	a0,s1
    80004b0c:	ffffe097          	auipc	ra,0xffffe
    80004b10:	4ca080e7          	jalr	1226(ra) # 80002fd6 <writei>
    80004b14:	47c1                	li	a5,16
    80004b16:	0af51563          	bne	a0,a5,80004bc0 <sys_unlink+0x17c>
    if (ip->type == T_DIR)
    80004b1a:	04491703          	lh	a4,68(s2)
    80004b1e:	4785                	li	a5,1
    80004b20:	0af70863          	beq	a4,a5,80004bd0 <sys_unlink+0x18c>
    iunlockput(dp);
    80004b24:	8526                	mv	a0,s1
    80004b26:	ffffe097          	auipc	ra,0xffffe
    80004b2a:	366080e7          	jalr	870(ra) # 80002e8c <iunlockput>
    ip->nlink--;
    80004b2e:	04a95783          	lhu	a5,74(s2)
    80004b32:	37fd                	addiw	a5,a5,-1
    80004b34:	04f91523          	sh	a5,74(s2)
    iupdate(ip);
    80004b38:	854a                	mv	a0,s2
    80004b3a:	ffffe097          	auipc	ra,0xffffe
    80004b3e:	026080e7          	jalr	38(ra) # 80002b60 <iupdate>
    iunlockput(ip);
    80004b42:	854a                	mv	a0,s2
    80004b44:	ffffe097          	auipc	ra,0xffffe
    80004b48:	348080e7          	jalr	840(ra) # 80002e8c <iunlockput>
    end_op();
    80004b4c:	fffff097          	auipc	ra,0xfffff
    80004b50:	b20080e7          	jalr	-1248(ra) # 8000366c <end_op>
    return 0;
    80004b54:	4501                	li	a0,0
    80004b56:	a84d                	j	80004c08 <sys_unlink+0x1c4>
        end_op();
    80004b58:	fffff097          	auipc	ra,0xfffff
    80004b5c:	b14080e7          	jalr	-1260(ra) # 8000366c <end_op>
        return -1;
    80004b60:	557d                	li	a0,-1
    80004b62:	a05d                	j	80004c08 <sys_unlink+0x1c4>
        panic("unlink: nlink < 1");
    80004b64:	00004517          	auipc	a0,0x4
    80004b68:	bfc50513          	addi	a0,a0,-1028 # 80008760 <syscalls+0x2c8>
    80004b6c:	00001097          	auipc	ra,0x1
    80004b70:	376080e7          	jalr	886(ra) # 80005ee2 <panic>
    for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de))
    80004b74:	04c92703          	lw	a4,76(s2)
    80004b78:	02000793          	li	a5,32
    80004b7c:	f6e7f9e3          	bgeu	a5,a4,80004aee <sys_unlink+0xaa>
    80004b80:	02000993          	li	s3,32
        if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004b84:	4741                	li	a4,16
    80004b86:	86ce                	mv	a3,s3
    80004b88:	f1840613          	addi	a2,s0,-232
    80004b8c:	4581                	li	a1,0
    80004b8e:	854a                	mv	a0,s2
    80004b90:	ffffe097          	auipc	ra,0xffffe
    80004b94:	34e080e7          	jalr	846(ra) # 80002ede <readi>
    80004b98:	47c1                	li	a5,16
    80004b9a:	00f51b63          	bne	a0,a5,80004bb0 <sys_unlink+0x16c>
        if (de.inum != 0)
    80004b9e:	f1845783          	lhu	a5,-232(s0)
    80004ba2:	e7a1                	bnez	a5,80004bea <sys_unlink+0x1a6>
    for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de))
    80004ba4:	29c1                	addiw	s3,s3,16
    80004ba6:	04c92783          	lw	a5,76(s2)
    80004baa:	fcf9ede3          	bltu	s3,a5,80004b84 <sys_unlink+0x140>
    80004bae:	b781                	j	80004aee <sys_unlink+0xaa>
            panic("isdirempty: readi");
    80004bb0:	00004517          	auipc	a0,0x4
    80004bb4:	bc850513          	addi	a0,a0,-1080 # 80008778 <syscalls+0x2e0>
    80004bb8:	00001097          	auipc	ra,0x1
    80004bbc:	32a080e7          	jalr	810(ra) # 80005ee2 <panic>
        panic("unlink: writei");
    80004bc0:	00004517          	auipc	a0,0x4
    80004bc4:	bd050513          	addi	a0,a0,-1072 # 80008790 <syscalls+0x2f8>
    80004bc8:	00001097          	auipc	ra,0x1
    80004bcc:	31a080e7          	jalr	794(ra) # 80005ee2 <panic>
        dp->nlink--;
    80004bd0:	04a4d783          	lhu	a5,74(s1)
    80004bd4:	37fd                	addiw	a5,a5,-1
    80004bd6:	04f49523          	sh	a5,74(s1)
        iupdate(dp);
    80004bda:	8526                	mv	a0,s1
    80004bdc:	ffffe097          	auipc	ra,0xffffe
    80004be0:	f84080e7          	jalr	-124(ra) # 80002b60 <iupdate>
    80004be4:	b781                	j	80004b24 <sys_unlink+0xe0>
        return -1;
    80004be6:	557d                	li	a0,-1
    80004be8:	a005                	j	80004c08 <sys_unlink+0x1c4>
        iunlockput(ip);
    80004bea:	854a                	mv	a0,s2
    80004bec:	ffffe097          	auipc	ra,0xffffe
    80004bf0:	2a0080e7          	jalr	672(ra) # 80002e8c <iunlockput>
    iunlockput(dp);
    80004bf4:	8526                	mv	a0,s1
    80004bf6:	ffffe097          	auipc	ra,0xffffe
    80004bfa:	296080e7          	jalr	662(ra) # 80002e8c <iunlockput>
    end_op();
    80004bfe:	fffff097          	auipc	ra,0xfffff
    80004c02:	a6e080e7          	jalr	-1426(ra) # 8000366c <end_op>
    return -1;
    80004c06:	557d                	li	a0,-1
}
    80004c08:	70ae                	ld	ra,232(sp)
    80004c0a:	740e                	ld	s0,224(sp)
    80004c0c:	64ee                	ld	s1,216(sp)
    80004c0e:	694e                	ld	s2,208(sp)
    80004c10:	69ae                	ld	s3,200(sp)
    80004c12:	616d                	addi	sp,sp,240
    80004c14:	8082                	ret

0000000080004c16 <sys_mmap>:
{
    80004c16:	711d                	addi	sp,sp,-96
    80004c18:	ec86                	sd	ra,88(sp)
    80004c1a:	e8a2                	sd	s0,80(sp)
    80004c1c:	e4a6                	sd	s1,72(sp)
    80004c1e:	e0ca                	sd	s2,64(sp)
    80004c20:	fc4e                	sd	s3,56(sp)
    80004c22:	1080                	addi	s0,sp,96
    argaddr(0, &addr);
    80004c24:	fc840593          	addi	a1,s0,-56
    80004c28:	4501                	li	a0,0
    80004c2a:	ffffd097          	auipc	ra,0xffffd
    80004c2e:	4a6080e7          	jalr	1190(ra) # 800020d0 <argaddr>
    argaddr(1, &length);
    80004c32:	fc040593          	addi	a1,s0,-64
    80004c36:	4505                	li	a0,1
    80004c38:	ffffd097          	auipc	ra,0xffffd
    80004c3c:	498080e7          	jalr	1176(ra) # 800020d0 <argaddr>
    argint(2, &prot);
    80004c40:	fbc40593          	addi	a1,s0,-68
    80004c44:	4509                	li	a0,2
    80004c46:	ffffd097          	auipc	ra,0xffffd
    80004c4a:	46a080e7          	jalr	1130(ra) # 800020b0 <argint>
    argint(3, &flags);
    80004c4e:	fb840593          	addi	a1,s0,-72
    80004c52:	450d                	li	a0,3
    80004c54:	ffffd097          	auipc	ra,0xffffd
    80004c58:	45c080e7          	jalr	1116(ra) # 800020b0 <argint>
    argfd(4, &fd, &pf);
    80004c5c:	fa040613          	addi	a2,s0,-96
    80004c60:	fb440593          	addi	a1,s0,-76
    80004c64:	4511                	li	a0,4
    80004c66:	00000097          	auipc	ra,0x0
    80004c6a:	8d4080e7          	jalr	-1836(ra) # 8000453a <argfd>
    argaddr(5, &offset);
    80004c6e:	fa840593          	addi	a1,s0,-88
    80004c72:	4515                	li	a0,5
    80004c74:	ffffd097          	auipc	ra,0xffffd
    80004c78:	45c080e7          	jalr	1116(ra) # 800020d0 <argaddr>
    if ((prot & PROT_WRITE) && (flags & MAP_SHARED) && (!pf->writable))
    80004c7c:	fbc42783          	lw	a5,-68(s0)
    80004c80:	0027f713          	andi	a4,a5,2
    80004c84:	cb11                	beqz	a4,80004c98 <sys_mmap+0x82>
    80004c86:	fb842703          	lw	a4,-72(s0)
    80004c8a:	8b05                	andi	a4,a4,1
    80004c8c:	c711                	beqz	a4,80004c98 <sys_mmap+0x82>
    80004c8e:	fa043703          	ld	a4,-96(s0)
    80004c92:	00974703          	lbu	a4,9(a4)
    80004c96:	c761                	beqz	a4,80004d5e <sys_mmap+0x148>
    if ((prot & PROT_READ) && (!pf->readable))
    80004c98:	8b85                	andi	a5,a5,1
    80004c9a:	c791                	beqz	a5,80004ca6 <sys_mmap+0x90>
    80004c9c:	fa043783          	ld	a5,-96(s0)
    80004ca0:	0087c783          	lbu	a5,8(a5)
    80004ca4:	cfdd                	beqz	a5,80004d62 <sys_mmap+0x14c>
    struct proc *p_proc = myproc(); // create a pointer to process struct
    80004ca6:	ffffc097          	auipc	ra,0xffffc
    80004caa:	1bc080e7          	jalr	444(ra) # 80000e62 <myproc>
    80004cae:	892a                	mv	s2,a0
            if (p_proc->sz + length <= MAXVA)
    80004cb0:	fc043503          	ld	a0,-64(s0)
    80004cb4:	16890793          	addi	a5,s2,360
    for (int i = 0; i <= VMASIZE - 1; i++)
    80004cb8:	4481                	li	s1,0
        if (p_proc->vma[i].occupied != 1)
    80004cba:	4605                	li	a2,1
            if (p_proc->sz + length <= MAXVA)
    80004cbc:	02661813          	slli	a6,a2,0x26
    for (int i = 0; i <= VMASIZE - 1; i++)
    80004cc0:	45c1                	li	a1,16
    80004cc2:	a031                	j	80004cce <sys_mmap+0xb8>
    80004cc4:	2485                	addiw	s1,s1,1
    80004cc6:	04878793          	addi	a5,a5,72
    80004cca:	08b48263          	beq	s1,a1,80004d4e <sys_mmap+0x138>
        if (p_proc->vma[i].occupied != 1)
    80004cce:	4398                	lw	a4,0(a5)
    80004cd0:	fec70ae3          	beq	a4,a2,80004cc4 <sys_mmap+0xae>
            if (p_proc->sz + length <= MAXVA)
    80004cd4:	04893683          	ld	a3,72(s2)
    80004cd8:	00a68733          	add	a4,a3,a0
    80004cdc:	fee864e3          	bltu	a6,a4,80004cc4 <sys_mmap+0xae>
        p_vma->occupied = 1; // denote it is occupied
    80004ce0:	00349993          	slli	s3,s1,0x3
    80004ce4:	009987b3          	add	a5,s3,s1
    80004ce8:	078e                	slli	a5,a5,0x3
    80004cea:	97ca                	add	a5,a5,s2
    80004cec:	4605                	li	a2,1
    80004cee:	16c7a423          	sw	a2,360(a5)
        p_vma->start_addr = (uint64)(p_proc->sz);
    80004cf2:	16d7b823          	sd	a3,368(a5)
        p_vma->end_addr = (uint64)(p_proc->sz + length);
    80004cf6:	16e7bc23          	sd	a4,376(a5)
        p_vma->addr = (uint64)addr;
    80004cfa:	fc843703          	ld	a4,-56(s0)
    80004cfe:	18e7b023          	sd	a4,384(a5)
        p_vma->length = length;
    80004d02:	18a7b423          	sd	a0,392(a5)
        p_vma->prot = prot;
    80004d06:	fbc42703          	lw	a4,-68(s0)
    80004d0a:	18e7a823          	sw	a4,400(a5)
        p_vma->flags = flags;
    80004d0e:	fb842703          	lw	a4,-72(s0)
    80004d12:	18e7aa23          	sw	a4,404(a5)
        p_vma->fd = fd;
    80004d16:	fb442703          	lw	a4,-76(s0)
    80004d1a:	18e7ac23          	sw	a4,408(a5)
        p_vma->offset = offset;
    80004d1e:	fa843703          	ld	a4,-88(s0)
    80004d22:	1ae7b023          	sd	a4,416(a5)
        p_vma->pf = pf;
    80004d26:	fa043503          	ld	a0,-96(s0)
    80004d2a:	1aa7b423          	sd	a0,424(a5)
        filedup(p_vma->pf);
    80004d2e:	fffff097          	auipc	ra,0xfffff
    80004d32:	d38080e7          	jalr	-712(ra) # 80003a66 <filedup>
        return (p_vma->start_addr);
    80004d36:	94ce                	add	s1,s1,s3
    80004d38:	048e                	slli	s1,s1,0x3
    80004d3a:	9926                	add	s2,s2,s1
    80004d3c:	17093503          	ld	a0,368(s2)
}
    80004d40:	60e6                	ld	ra,88(sp)
    80004d42:	6446                	ld	s0,80(sp)
    80004d44:	64a6                	ld	s1,72(sp)
    80004d46:	6906                	ld	s2,64(sp)
    80004d48:	79e2                	ld	s3,56(sp)
    80004d4a:	6125                	addi	sp,sp,96
    80004d4c:	8082                	ret
        panic("syscall mmap");
    80004d4e:	00004517          	auipc	a0,0x4
    80004d52:	a5250513          	addi	a0,a0,-1454 # 800087a0 <syscalls+0x308>
    80004d56:	00001097          	auipc	ra,0x1
    80004d5a:	18c080e7          	jalr	396(ra) # 80005ee2 <panic>
        return -1;
    80004d5e:	557d                	li	a0,-1
    80004d60:	b7c5                	j	80004d40 <sys_mmap+0x12a>
        return -1;
    80004d62:	557d                	li	a0,-1
    80004d64:	bff1                	j	80004d40 <sys_mmap+0x12a>

0000000080004d66 <sys_munmap>:
{
    80004d66:	1141                	addi	sp,sp,-16
    80004d68:	e422                	sd	s0,8(sp)
    80004d6a:	0800                	addi	s0,sp,16
}
    80004d6c:	4501                	li	a0,0
    80004d6e:	6422                	ld	s0,8(sp)
    80004d70:	0141                	addi	sp,sp,16
    80004d72:	8082                	ret

0000000080004d74 <sys_open>:

uint64
sys_open(void)
{
    80004d74:	7131                	addi	sp,sp,-192
    80004d76:	fd06                	sd	ra,184(sp)
    80004d78:	f922                	sd	s0,176(sp)
    80004d7a:	f526                	sd	s1,168(sp)
    80004d7c:	f14a                	sd	s2,160(sp)
    80004d7e:	ed4e                	sd	s3,152(sp)
    80004d80:	0180                	addi	s0,sp,192
    int fd, omode;
    struct file *f;
    struct inode *ip;
    int n;

    argint(1, &omode);
    80004d82:	f4c40593          	addi	a1,s0,-180
    80004d86:	4505                	li	a0,1
    80004d88:	ffffd097          	auipc	ra,0xffffd
    80004d8c:	328080e7          	jalr	808(ra) # 800020b0 <argint>
    if ((n = argstr(0, path, MAXPATH)) < 0)
    80004d90:	08000613          	li	a2,128
    80004d94:	f5040593          	addi	a1,s0,-176
    80004d98:	4501                	li	a0,0
    80004d9a:	ffffd097          	auipc	ra,0xffffd
    80004d9e:	356080e7          	jalr	854(ra) # 800020f0 <argstr>
    80004da2:	87aa                	mv	a5,a0
        return -1;
    80004da4:	557d                	li	a0,-1
    if ((n = argstr(0, path, MAXPATH)) < 0)
    80004da6:	0a07c963          	bltz	a5,80004e58 <sys_open+0xe4>

    begin_op();
    80004daa:	fffff097          	auipc	ra,0xfffff
    80004dae:	842080e7          	jalr	-1982(ra) # 800035ec <begin_op>

    if (omode & O_CREATE)
    80004db2:	f4c42783          	lw	a5,-180(s0)
    80004db6:	2007f793          	andi	a5,a5,512
    80004dba:	cfc5                	beqz	a5,80004e72 <sys_open+0xfe>
    {
        ip = create(path, T_FILE, 0, 0);
    80004dbc:	4681                	li	a3,0
    80004dbe:	4601                	li	a2,0
    80004dc0:	4589                	li	a1,2
    80004dc2:	f5040513          	addi	a0,s0,-176
    80004dc6:	00000097          	auipc	ra,0x0
    80004dca:	816080e7          	jalr	-2026(ra) # 800045dc <create>
    80004dce:	84aa                	mv	s1,a0
        if (ip == 0)
    80004dd0:	c959                	beqz	a0,80004e66 <sys_open+0xf2>
            end_op();
            return -1;
        }
    }

    if (ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV))
    80004dd2:	04449703          	lh	a4,68(s1)
    80004dd6:	478d                	li	a5,3
    80004dd8:	00f71763          	bne	a4,a5,80004de6 <sys_open+0x72>
    80004ddc:	0464d703          	lhu	a4,70(s1)
    80004de0:	47a5                	li	a5,9
    80004de2:	0ce7ed63          	bltu	a5,a4,80004ebc <sys_open+0x148>
        iunlockput(ip);
        end_op();
        return -1;
    }

    if ((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0)
    80004de6:	fffff097          	auipc	ra,0xfffff
    80004dea:	c16080e7          	jalr	-1002(ra) # 800039fc <filealloc>
    80004dee:	89aa                	mv	s3,a0
    80004df0:	10050363          	beqz	a0,80004ef6 <sys_open+0x182>
    80004df4:	fffff097          	auipc	ra,0xfffff
    80004df8:	7a6080e7          	jalr	1958(ra) # 8000459a <fdalloc>
    80004dfc:	892a                	mv	s2,a0
    80004dfe:	0e054763          	bltz	a0,80004eec <sys_open+0x178>
        iunlockput(ip);
        end_op();
        return -1;
    }

    if (ip->type == T_DEVICE)
    80004e02:	04449703          	lh	a4,68(s1)
    80004e06:	478d                	li	a5,3
    80004e08:	0cf70563          	beq	a4,a5,80004ed2 <sys_open+0x15e>
        f->type = FD_DEVICE;
        f->major = ip->major;
    }
    else
    {
        f->type = FD_INODE;
    80004e0c:	4789                	li	a5,2
    80004e0e:	00f9a023          	sw	a5,0(s3)
        f->off = 0;
    80004e12:	0209a023          	sw	zero,32(s3)
    }
    f->ip = ip;
    80004e16:	0099bc23          	sd	s1,24(s3)
    f->readable = !(omode & O_WRONLY);
    80004e1a:	f4c42783          	lw	a5,-180(s0)
    80004e1e:	0017c713          	xori	a4,a5,1
    80004e22:	8b05                	andi	a4,a4,1
    80004e24:	00e98423          	sb	a4,8(s3)
    f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004e28:	0037f713          	andi	a4,a5,3
    80004e2c:	00e03733          	snez	a4,a4
    80004e30:	00e984a3          	sb	a4,9(s3)

    if ((omode & O_TRUNC) && ip->type == T_FILE)
    80004e34:	4007f793          	andi	a5,a5,1024
    80004e38:	c791                	beqz	a5,80004e44 <sys_open+0xd0>
    80004e3a:	04449703          	lh	a4,68(s1)
    80004e3e:	4789                	li	a5,2
    80004e40:	0af70063          	beq	a4,a5,80004ee0 <sys_open+0x16c>
    {
        itrunc(ip);
    }

    iunlock(ip);
    80004e44:	8526                	mv	a0,s1
    80004e46:	ffffe097          	auipc	ra,0xffffe
    80004e4a:	ea6080e7          	jalr	-346(ra) # 80002cec <iunlock>
    end_op();
    80004e4e:	fffff097          	auipc	ra,0xfffff
    80004e52:	81e080e7          	jalr	-2018(ra) # 8000366c <end_op>

    return fd;
    80004e56:	854a                	mv	a0,s2
}
    80004e58:	70ea                	ld	ra,184(sp)
    80004e5a:	744a                	ld	s0,176(sp)
    80004e5c:	74aa                	ld	s1,168(sp)
    80004e5e:	790a                	ld	s2,160(sp)
    80004e60:	69ea                	ld	s3,152(sp)
    80004e62:	6129                	addi	sp,sp,192
    80004e64:	8082                	ret
            end_op();
    80004e66:	fffff097          	auipc	ra,0xfffff
    80004e6a:	806080e7          	jalr	-2042(ra) # 8000366c <end_op>
            return -1;
    80004e6e:	557d                	li	a0,-1
    80004e70:	b7e5                	j	80004e58 <sys_open+0xe4>
        if ((ip = namei(path)) == 0)
    80004e72:	f5040513          	addi	a0,s0,-176
    80004e76:	ffffe097          	auipc	ra,0xffffe
    80004e7a:	55a080e7          	jalr	1370(ra) # 800033d0 <namei>
    80004e7e:	84aa                	mv	s1,a0
    80004e80:	c905                	beqz	a0,80004eb0 <sys_open+0x13c>
        ilock(ip);
    80004e82:	ffffe097          	auipc	ra,0xffffe
    80004e86:	da8080e7          	jalr	-600(ra) # 80002c2a <ilock>
        if (ip->type == T_DIR && omode != O_RDONLY)
    80004e8a:	04449703          	lh	a4,68(s1)
    80004e8e:	4785                	li	a5,1
    80004e90:	f4f711e3          	bne	a4,a5,80004dd2 <sys_open+0x5e>
    80004e94:	f4c42783          	lw	a5,-180(s0)
    80004e98:	d7b9                	beqz	a5,80004de6 <sys_open+0x72>
            iunlockput(ip);
    80004e9a:	8526                	mv	a0,s1
    80004e9c:	ffffe097          	auipc	ra,0xffffe
    80004ea0:	ff0080e7          	jalr	-16(ra) # 80002e8c <iunlockput>
            end_op();
    80004ea4:	ffffe097          	auipc	ra,0xffffe
    80004ea8:	7c8080e7          	jalr	1992(ra) # 8000366c <end_op>
            return -1;
    80004eac:	557d                	li	a0,-1
    80004eae:	b76d                	j	80004e58 <sys_open+0xe4>
            end_op();
    80004eb0:	ffffe097          	auipc	ra,0xffffe
    80004eb4:	7bc080e7          	jalr	1980(ra) # 8000366c <end_op>
            return -1;
    80004eb8:	557d                	li	a0,-1
    80004eba:	bf79                	j	80004e58 <sys_open+0xe4>
        iunlockput(ip);
    80004ebc:	8526                	mv	a0,s1
    80004ebe:	ffffe097          	auipc	ra,0xffffe
    80004ec2:	fce080e7          	jalr	-50(ra) # 80002e8c <iunlockput>
        end_op();
    80004ec6:	ffffe097          	auipc	ra,0xffffe
    80004eca:	7a6080e7          	jalr	1958(ra) # 8000366c <end_op>
        return -1;
    80004ece:	557d                	li	a0,-1
    80004ed0:	b761                	j	80004e58 <sys_open+0xe4>
        f->type = FD_DEVICE;
    80004ed2:	00f9a023          	sw	a5,0(s3)
        f->major = ip->major;
    80004ed6:	04649783          	lh	a5,70(s1)
    80004eda:	02f99223          	sh	a5,36(s3)
    80004ede:	bf25                	j	80004e16 <sys_open+0xa2>
        itrunc(ip);
    80004ee0:	8526                	mv	a0,s1
    80004ee2:	ffffe097          	auipc	ra,0xffffe
    80004ee6:	e56080e7          	jalr	-426(ra) # 80002d38 <itrunc>
    80004eea:	bfa9                	j	80004e44 <sys_open+0xd0>
            fileclose(f);
    80004eec:	854e                	mv	a0,s3
    80004eee:	fffff097          	auipc	ra,0xfffff
    80004ef2:	bca080e7          	jalr	-1078(ra) # 80003ab8 <fileclose>
        iunlockput(ip);
    80004ef6:	8526                	mv	a0,s1
    80004ef8:	ffffe097          	auipc	ra,0xffffe
    80004efc:	f94080e7          	jalr	-108(ra) # 80002e8c <iunlockput>
        end_op();
    80004f00:	ffffe097          	auipc	ra,0xffffe
    80004f04:	76c080e7          	jalr	1900(ra) # 8000366c <end_op>
        return -1;
    80004f08:	557d                	li	a0,-1
    80004f0a:	b7b9                	j	80004e58 <sys_open+0xe4>

0000000080004f0c <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004f0c:	7175                	addi	sp,sp,-144
    80004f0e:	e506                	sd	ra,136(sp)
    80004f10:	e122                	sd	s0,128(sp)
    80004f12:	0900                	addi	s0,sp,144
    char path[MAXPATH];
    struct inode *ip;

    begin_op();
    80004f14:	ffffe097          	auipc	ra,0xffffe
    80004f18:	6d8080e7          	jalr	1752(ra) # 800035ec <begin_op>
    if (argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0)
    80004f1c:	08000613          	li	a2,128
    80004f20:	f7040593          	addi	a1,s0,-144
    80004f24:	4501                	li	a0,0
    80004f26:	ffffd097          	auipc	ra,0xffffd
    80004f2a:	1ca080e7          	jalr	458(ra) # 800020f0 <argstr>
    80004f2e:	02054963          	bltz	a0,80004f60 <sys_mkdir+0x54>
    80004f32:	4681                	li	a3,0
    80004f34:	4601                	li	a2,0
    80004f36:	4585                	li	a1,1
    80004f38:	f7040513          	addi	a0,s0,-144
    80004f3c:	fffff097          	auipc	ra,0xfffff
    80004f40:	6a0080e7          	jalr	1696(ra) # 800045dc <create>
    80004f44:	cd11                	beqz	a0,80004f60 <sys_mkdir+0x54>
    {
        end_op();
        return -1;
    }
    iunlockput(ip);
    80004f46:	ffffe097          	auipc	ra,0xffffe
    80004f4a:	f46080e7          	jalr	-186(ra) # 80002e8c <iunlockput>
    end_op();
    80004f4e:	ffffe097          	auipc	ra,0xffffe
    80004f52:	71e080e7          	jalr	1822(ra) # 8000366c <end_op>
    return 0;
    80004f56:	4501                	li	a0,0
}
    80004f58:	60aa                	ld	ra,136(sp)
    80004f5a:	640a                	ld	s0,128(sp)
    80004f5c:	6149                	addi	sp,sp,144
    80004f5e:	8082                	ret
        end_op();
    80004f60:	ffffe097          	auipc	ra,0xffffe
    80004f64:	70c080e7          	jalr	1804(ra) # 8000366c <end_op>
        return -1;
    80004f68:	557d                	li	a0,-1
    80004f6a:	b7fd                	j	80004f58 <sys_mkdir+0x4c>

0000000080004f6c <sys_mknod>:

uint64
sys_mknod(void)
{
    80004f6c:	7135                	addi	sp,sp,-160
    80004f6e:	ed06                	sd	ra,152(sp)
    80004f70:	e922                	sd	s0,144(sp)
    80004f72:	1100                	addi	s0,sp,160
    struct inode *ip;
    char path[MAXPATH];
    int major, minor;

    begin_op();
    80004f74:	ffffe097          	auipc	ra,0xffffe
    80004f78:	678080e7          	jalr	1656(ra) # 800035ec <begin_op>
    argint(1, &major);
    80004f7c:	f6c40593          	addi	a1,s0,-148
    80004f80:	4505                	li	a0,1
    80004f82:	ffffd097          	auipc	ra,0xffffd
    80004f86:	12e080e7          	jalr	302(ra) # 800020b0 <argint>
    argint(2, &minor);
    80004f8a:	f6840593          	addi	a1,s0,-152
    80004f8e:	4509                	li	a0,2
    80004f90:	ffffd097          	auipc	ra,0xffffd
    80004f94:	120080e7          	jalr	288(ra) # 800020b0 <argint>
    if ((argstr(0, path, MAXPATH)) < 0 ||
    80004f98:	08000613          	li	a2,128
    80004f9c:	f7040593          	addi	a1,s0,-144
    80004fa0:	4501                	li	a0,0
    80004fa2:	ffffd097          	auipc	ra,0xffffd
    80004fa6:	14e080e7          	jalr	334(ra) # 800020f0 <argstr>
    80004faa:	02054b63          	bltz	a0,80004fe0 <sys_mknod+0x74>
        (ip = create(path, T_DEVICE, major, minor)) == 0)
    80004fae:	f6841683          	lh	a3,-152(s0)
    80004fb2:	f6c41603          	lh	a2,-148(s0)
    80004fb6:	458d                	li	a1,3
    80004fb8:	f7040513          	addi	a0,s0,-144
    80004fbc:	fffff097          	auipc	ra,0xfffff
    80004fc0:	620080e7          	jalr	1568(ra) # 800045dc <create>
    if ((argstr(0, path, MAXPATH)) < 0 ||
    80004fc4:	cd11                	beqz	a0,80004fe0 <sys_mknod+0x74>
    {
        end_op();
        return -1;
    }
    iunlockput(ip);
    80004fc6:	ffffe097          	auipc	ra,0xffffe
    80004fca:	ec6080e7          	jalr	-314(ra) # 80002e8c <iunlockput>
    end_op();
    80004fce:	ffffe097          	auipc	ra,0xffffe
    80004fd2:	69e080e7          	jalr	1694(ra) # 8000366c <end_op>
    return 0;
    80004fd6:	4501                	li	a0,0
}
    80004fd8:	60ea                	ld	ra,152(sp)
    80004fda:	644a                	ld	s0,144(sp)
    80004fdc:	610d                	addi	sp,sp,160
    80004fde:	8082                	ret
        end_op();
    80004fe0:	ffffe097          	auipc	ra,0xffffe
    80004fe4:	68c080e7          	jalr	1676(ra) # 8000366c <end_op>
        return -1;
    80004fe8:	557d                	li	a0,-1
    80004fea:	b7fd                	j	80004fd8 <sys_mknod+0x6c>

0000000080004fec <sys_chdir>:

uint64
sys_chdir(void)
{
    80004fec:	7135                	addi	sp,sp,-160
    80004fee:	ed06                	sd	ra,152(sp)
    80004ff0:	e922                	sd	s0,144(sp)
    80004ff2:	e526                	sd	s1,136(sp)
    80004ff4:	e14a                	sd	s2,128(sp)
    80004ff6:	1100                	addi	s0,sp,160
    char path[MAXPATH];
    struct inode *ip;
    struct proc *p = myproc();
    80004ff8:	ffffc097          	auipc	ra,0xffffc
    80004ffc:	e6a080e7          	jalr	-406(ra) # 80000e62 <myproc>
    80005000:	892a                	mv	s2,a0

    begin_op();
    80005002:	ffffe097          	auipc	ra,0xffffe
    80005006:	5ea080e7          	jalr	1514(ra) # 800035ec <begin_op>
    if (argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0)
    8000500a:	08000613          	li	a2,128
    8000500e:	f6040593          	addi	a1,s0,-160
    80005012:	4501                	li	a0,0
    80005014:	ffffd097          	auipc	ra,0xffffd
    80005018:	0dc080e7          	jalr	220(ra) # 800020f0 <argstr>
    8000501c:	04054b63          	bltz	a0,80005072 <sys_chdir+0x86>
    80005020:	f6040513          	addi	a0,s0,-160
    80005024:	ffffe097          	auipc	ra,0xffffe
    80005028:	3ac080e7          	jalr	940(ra) # 800033d0 <namei>
    8000502c:	84aa                	mv	s1,a0
    8000502e:	c131                	beqz	a0,80005072 <sys_chdir+0x86>
    {
        end_op();
        return -1;
    }
    ilock(ip);
    80005030:	ffffe097          	auipc	ra,0xffffe
    80005034:	bfa080e7          	jalr	-1030(ra) # 80002c2a <ilock>
    if (ip->type != T_DIR)
    80005038:	04449703          	lh	a4,68(s1)
    8000503c:	4785                	li	a5,1
    8000503e:	04f71063          	bne	a4,a5,8000507e <sys_chdir+0x92>
    {
        iunlockput(ip);
        end_op();
        return -1;
    }
    iunlock(ip);
    80005042:	8526                	mv	a0,s1
    80005044:	ffffe097          	auipc	ra,0xffffe
    80005048:	ca8080e7          	jalr	-856(ra) # 80002cec <iunlock>
    iput(p->cwd);
    8000504c:	15093503          	ld	a0,336(s2)
    80005050:	ffffe097          	auipc	ra,0xffffe
    80005054:	d94080e7          	jalr	-620(ra) # 80002de4 <iput>
    end_op();
    80005058:	ffffe097          	auipc	ra,0xffffe
    8000505c:	614080e7          	jalr	1556(ra) # 8000366c <end_op>
    p->cwd = ip;
    80005060:	14993823          	sd	s1,336(s2)
    return 0;
    80005064:	4501                	li	a0,0
}
    80005066:	60ea                	ld	ra,152(sp)
    80005068:	644a                	ld	s0,144(sp)
    8000506a:	64aa                	ld	s1,136(sp)
    8000506c:	690a                	ld	s2,128(sp)
    8000506e:	610d                	addi	sp,sp,160
    80005070:	8082                	ret
        end_op();
    80005072:	ffffe097          	auipc	ra,0xffffe
    80005076:	5fa080e7          	jalr	1530(ra) # 8000366c <end_op>
        return -1;
    8000507a:	557d                	li	a0,-1
    8000507c:	b7ed                	j	80005066 <sys_chdir+0x7a>
        iunlockput(ip);
    8000507e:	8526                	mv	a0,s1
    80005080:	ffffe097          	auipc	ra,0xffffe
    80005084:	e0c080e7          	jalr	-500(ra) # 80002e8c <iunlockput>
        end_op();
    80005088:	ffffe097          	auipc	ra,0xffffe
    8000508c:	5e4080e7          	jalr	1508(ra) # 8000366c <end_op>
        return -1;
    80005090:	557d                	li	a0,-1
    80005092:	bfd1                	j	80005066 <sys_chdir+0x7a>

0000000080005094 <sys_exec>:

uint64
sys_exec(void)
{
    80005094:	7145                	addi	sp,sp,-464
    80005096:	e786                	sd	ra,456(sp)
    80005098:	e3a2                	sd	s0,448(sp)
    8000509a:	ff26                	sd	s1,440(sp)
    8000509c:	fb4a                	sd	s2,432(sp)
    8000509e:	f74e                	sd	s3,424(sp)
    800050a0:	f352                	sd	s4,416(sp)
    800050a2:	ef56                	sd	s5,408(sp)
    800050a4:	0b80                	addi	s0,sp,464
    char path[MAXPATH], *argv[MAXARG];
    int i;
    uint64 uargv, uarg;

    argaddr(1, &uargv);
    800050a6:	e3840593          	addi	a1,s0,-456
    800050aa:	4505                	li	a0,1
    800050ac:	ffffd097          	auipc	ra,0xffffd
    800050b0:	024080e7          	jalr	36(ra) # 800020d0 <argaddr>
    if (argstr(0, path, MAXPATH) < 0)
    800050b4:	08000613          	li	a2,128
    800050b8:	f4040593          	addi	a1,s0,-192
    800050bc:	4501                	li	a0,0
    800050be:	ffffd097          	auipc	ra,0xffffd
    800050c2:	032080e7          	jalr	50(ra) # 800020f0 <argstr>
    800050c6:	87aa                	mv	a5,a0
    {
        return -1;
    800050c8:	557d                	li	a0,-1
    if (argstr(0, path, MAXPATH) < 0)
    800050ca:	0c07c263          	bltz	a5,8000518e <sys_exec+0xfa>
    }
    memset(argv, 0, sizeof(argv));
    800050ce:	10000613          	li	a2,256
    800050d2:	4581                	li	a1,0
    800050d4:	e4040513          	addi	a0,s0,-448
    800050d8:	ffffb097          	auipc	ra,0xffffb
    800050dc:	0a0080e7          	jalr	160(ra) # 80000178 <memset>
    for (i = 0;; i++)
    {
        if (i >= NELEM(argv))
    800050e0:	e4040493          	addi	s1,s0,-448
    memset(argv, 0, sizeof(argv));
    800050e4:	89a6                	mv	s3,s1
    800050e6:	4901                	li	s2,0
        if (i >= NELEM(argv))
    800050e8:	02000a13          	li	s4,32
    800050ec:	00090a9b          	sext.w	s5,s2
        {
            goto bad;
        }
        if (fetchaddr(uargv + sizeof(uint64) * i, (uint64 *)&uarg) < 0)
    800050f0:	00391513          	slli	a0,s2,0x3
    800050f4:	e3040593          	addi	a1,s0,-464
    800050f8:	e3843783          	ld	a5,-456(s0)
    800050fc:	953e                	add	a0,a0,a5
    800050fe:	ffffd097          	auipc	ra,0xffffd
    80005102:	f14080e7          	jalr	-236(ra) # 80002012 <fetchaddr>
    80005106:	02054a63          	bltz	a0,8000513a <sys_exec+0xa6>
        {
            goto bad;
        }
        if (uarg == 0)
    8000510a:	e3043783          	ld	a5,-464(s0)
    8000510e:	c3b9                	beqz	a5,80005154 <sys_exec+0xc0>
        {
            argv[i] = 0;
            break;
        }
        argv[i] = kalloc();
    80005110:	ffffb097          	auipc	ra,0xffffb
    80005114:	008080e7          	jalr	8(ra) # 80000118 <kalloc>
    80005118:	85aa                	mv	a1,a0
    8000511a:	00a9b023          	sd	a0,0(s3)
        if (argv[i] == 0)
    8000511e:	cd11                	beqz	a0,8000513a <sys_exec+0xa6>
            goto bad;
        if (fetchstr(uarg, argv[i], PGSIZE) < 0)
    80005120:	6605                	lui	a2,0x1
    80005122:	e3043503          	ld	a0,-464(s0)
    80005126:	ffffd097          	auipc	ra,0xffffd
    8000512a:	f3e080e7          	jalr	-194(ra) # 80002064 <fetchstr>
    8000512e:	00054663          	bltz	a0,8000513a <sys_exec+0xa6>
        if (i >= NELEM(argv))
    80005132:	0905                	addi	s2,s2,1
    80005134:	09a1                	addi	s3,s3,8
    80005136:	fb491be3          	bne	s2,s4,800050ec <sys_exec+0x58>
        kfree(argv[i]);

    return ret;

bad:
    for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000513a:	10048913          	addi	s2,s1,256
    8000513e:	6088                	ld	a0,0(s1)
    80005140:	c531                	beqz	a0,8000518c <sys_exec+0xf8>
        kfree(argv[i]);
    80005142:	ffffb097          	auipc	ra,0xffffb
    80005146:	eda080e7          	jalr	-294(ra) # 8000001c <kfree>
    for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000514a:	04a1                	addi	s1,s1,8
    8000514c:	ff2499e3          	bne	s1,s2,8000513e <sys_exec+0xaa>
    return -1;
    80005150:	557d                	li	a0,-1
    80005152:	a835                	j	8000518e <sys_exec+0xfa>
            argv[i] = 0;
    80005154:	0a8e                	slli	s5,s5,0x3
    80005156:	fc040793          	addi	a5,s0,-64
    8000515a:	9abe                	add	s5,s5,a5
    8000515c:	e80ab023          	sd	zero,-384(s5)
    int ret = exec(path, argv);
    80005160:	e4040593          	addi	a1,s0,-448
    80005164:	f4040513          	addi	a0,s0,-192
    80005168:	fffff097          	auipc	ra,0xfffff
    8000516c:	032080e7          	jalr	50(ra) # 8000419a <exec>
    80005170:	892a                	mv	s2,a0
    for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005172:	10048993          	addi	s3,s1,256
    80005176:	6088                	ld	a0,0(s1)
    80005178:	c901                	beqz	a0,80005188 <sys_exec+0xf4>
        kfree(argv[i]);
    8000517a:	ffffb097          	auipc	ra,0xffffb
    8000517e:	ea2080e7          	jalr	-350(ra) # 8000001c <kfree>
    for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005182:	04a1                	addi	s1,s1,8
    80005184:	ff3499e3          	bne	s1,s3,80005176 <sys_exec+0xe2>
    return ret;
    80005188:	854a                	mv	a0,s2
    8000518a:	a011                	j	8000518e <sys_exec+0xfa>
    return -1;
    8000518c:	557d                	li	a0,-1
}
    8000518e:	60be                	ld	ra,456(sp)
    80005190:	641e                	ld	s0,448(sp)
    80005192:	74fa                	ld	s1,440(sp)
    80005194:	795a                	ld	s2,432(sp)
    80005196:	79ba                	ld	s3,424(sp)
    80005198:	7a1a                	ld	s4,416(sp)
    8000519a:	6afa                	ld	s5,408(sp)
    8000519c:	6179                	addi	sp,sp,464
    8000519e:	8082                	ret

00000000800051a0 <sys_pipe>:

uint64
sys_pipe(void)
{
    800051a0:	7139                	addi	sp,sp,-64
    800051a2:	fc06                	sd	ra,56(sp)
    800051a4:	f822                	sd	s0,48(sp)
    800051a6:	f426                	sd	s1,40(sp)
    800051a8:	0080                	addi	s0,sp,64
    uint64 fdarray; // user pointer to array of two integers
    struct file *rf, *wf;
    int fd0, fd1;
    struct proc *p = myproc();
    800051aa:	ffffc097          	auipc	ra,0xffffc
    800051ae:	cb8080e7          	jalr	-840(ra) # 80000e62 <myproc>
    800051b2:	84aa                	mv	s1,a0

    argaddr(0, &fdarray);
    800051b4:	fd840593          	addi	a1,s0,-40
    800051b8:	4501                	li	a0,0
    800051ba:	ffffd097          	auipc	ra,0xffffd
    800051be:	f16080e7          	jalr	-234(ra) # 800020d0 <argaddr>
    if (pipealloc(&rf, &wf) < 0)
    800051c2:	fc840593          	addi	a1,s0,-56
    800051c6:	fd040513          	addi	a0,s0,-48
    800051ca:	fffff097          	auipc	ra,0xfffff
    800051ce:	c78080e7          	jalr	-904(ra) # 80003e42 <pipealloc>
        return -1;
    800051d2:	57fd                	li	a5,-1
    if (pipealloc(&rf, &wf) < 0)
    800051d4:	0c054463          	bltz	a0,8000529c <sys_pipe+0xfc>
    fd0 = -1;
    800051d8:	fcf42223          	sw	a5,-60(s0)
    if ((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0)
    800051dc:	fd043503          	ld	a0,-48(s0)
    800051e0:	fffff097          	auipc	ra,0xfffff
    800051e4:	3ba080e7          	jalr	954(ra) # 8000459a <fdalloc>
    800051e8:	fca42223          	sw	a0,-60(s0)
    800051ec:	08054b63          	bltz	a0,80005282 <sys_pipe+0xe2>
    800051f0:	fc843503          	ld	a0,-56(s0)
    800051f4:	fffff097          	auipc	ra,0xfffff
    800051f8:	3a6080e7          	jalr	934(ra) # 8000459a <fdalloc>
    800051fc:	fca42023          	sw	a0,-64(s0)
    80005200:	06054863          	bltz	a0,80005270 <sys_pipe+0xd0>
            p->ofile[fd0] = 0;
        fileclose(rf);
        fileclose(wf);
        return -1;
    }
    if (copyout(p->pagetable, fdarray, (char *)&fd0, sizeof(fd0)) < 0 ||
    80005204:	4691                	li	a3,4
    80005206:	fc440613          	addi	a2,s0,-60
    8000520a:	fd843583          	ld	a1,-40(s0)
    8000520e:	68a8                	ld	a0,80(s1)
    80005210:	ffffc097          	auipc	ra,0xffffc
    80005214:	910080e7          	jalr	-1776(ra) # 80000b20 <copyout>
    80005218:	02054063          	bltz	a0,80005238 <sys_pipe+0x98>
        copyout(p->pagetable, fdarray + sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0)
    8000521c:	4691                	li	a3,4
    8000521e:	fc040613          	addi	a2,s0,-64
    80005222:	fd843583          	ld	a1,-40(s0)
    80005226:	0591                	addi	a1,a1,4
    80005228:	68a8                	ld	a0,80(s1)
    8000522a:	ffffc097          	auipc	ra,0xffffc
    8000522e:	8f6080e7          	jalr	-1802(ra) # 80000b20 <copyout>
        p->ofile[fd1] = 0;
        fileclose(rf);
        fileclose(wf);
        return -1;
    }
    return 0;
    80005232:	4781                	li	a5,0
    if (copyout(p->pagetable, fdarray, (char *)&fd0, sizeof(fd0)) < 0 ||
    80005234:	06055463          	bgez	a0,8000529c <sys_pipe+0xfc>
        p->ofile[fd0] = 0;
    80005238:	fc442783          	lw	a5,-60(s0)
    8000523c:	07e9                	addi	a5,a5,26
    8000523e:	078e                	slli	a5,a5,0x3
    80005240:	97a6                	add	a5,a5,s1
    80005242:	0007b023          	sd	zero,0(a5)
        p->ofile[fd1] = 0;
    80005246:	fc042503          	lw	a0,-64(s0)
    8000524a:	0569                	addi	a0,a0,26
    8000524c:	050e                	slli	a0,a0,0x3
    8000524e:	94aa                	add	s1,s1,a0
    80005250:	0004b023          	sd	zero,0(s1)
        fileclose(rf);
    80005254:	fd043503          	ld	a0,-48(s0)
    80005258:	fffff097          	auipc	ra,0xfffff
    8000525c:	860080e7          	jalr	-1952(ra) # 80003ab8 <fileclose>
        fileclose(wf);
    80005260:	fc843503          	ld	a0,-56(s0)
    80005264:	fffff097          	auipc	ra,0xfffff
    80005268:	854080e7          	jalr	-1964(ra) # 80003ab8 <fileclose>
        return -1;
    8000526c:	57fd                	li	a5,-1
    8000526e:	a03d                	j	8000529c <sys_pipe+0xfc>
        if (fd0 >= 0)
    80005270:	fc442783          	lw	a5,-60(s0)
    80005274:	0007c763          	bltz	a5,80005282 <sys_pipe+0xe2>
            p->ofile[fd0] = 0;
    80005278:	07e9                	addi	a5,a5,26
    8000527a:	078e                	slli	a5,a5,0x3
    8000527c:	94be                	add	s1,s1,a5
    8000527e:	0004b023          	sd	zero,0(s1)
        fileclose(rf);
    80005282:	fd043503          	ld	a0,-48(s0)
    80005286:	fffff097          	auipc	ra,0xfffff
    8000528a:	832080e7          	jalr	-1998(ra) # 80003ab8 <fileclose>
        fileclose(wf);
    8000528e:	fc843503          	ld	a0,-56(s0)
    80005292:	fffff097          	auipc	ra,0xfffff
    80005296:	826080e7          	jalr	-2010(ra) # 80003ab8 <fileclose>
        return -1;
    8000529a:	57fd                	li	a5,-1
}
    8000529c:	853e                	mv	a0,a5
    8000529e:	70e2                	ld	ra,56(sp)
    800052a0:	7442                	ld	s0,48(sp)
    800052a2:	74a2                	ld	s1,40(sp)
    800052a4:	6121                	addi	sp,sp,64
    800052a6:	8082                	ret
	...

00000000800052b0 <kernelvec>:
    800052b0:	7111                	addi	sp,sp,-256
    800052b2:	e006                	sd	ra,0(sp)
    800052b4:	e40a                	sd	sp,8(sp)
    800052b6:	e80e                	sd	gp,16(sp)
    800052b8:	ec12                	sd	tp,24(sp)
    800052ba:	f016                	sd	t0,32(sp)
    800052bc:	f41a                	sd	t1,40(sp)
    800052be:	f81e                	sd	t2,48(sp)
    800052c0:	fc22                	sd	s0,56(sp)
    800052c2:	e0a6                	sd	s1,64(sp)
    800052c4:	e4aa                	sd	a0,72(sp)
    800052c6:	e8ae                	sd	a1,80(sp)
    800052c8:	ecb2                	sd	a2,88(sp)
    800052ca:	f0b6                	sd	a3,96(sp)
    800052cc:	f4ba                	sd	a4,104(sp)
    800052ce:	f8be                	sd	a5,112(sp)
    800052d0:	fcc2                	sd	a6,120(sp)
    800052d2:	e146                	sd	a7,128(sp)
    800052d4:	e54a                	sd	s2,136(sp)
    800052d6:	e94e                	sd	s3,144(sp)
    800052d8:	ed52                	sd	s4,152(sp)
    800052da:	f156                	sd	s5,160(sp)
    800052dc:	f55a                	sd	s6,168(sp)
    800052de:	f95e                	sd	s7,176(sp)
    800052e0:	fd62                	sd	s8,184(sp)
    800052e2:	e1e6                	sd	s9,192(sp)
    800052e4:	e5ea                	sd	s10,200(sp)
    800052e6:	e9ee                	sd	s11,208(sp)
    800052e8:	edf2                	sd	t3,216(sp)
    800052ea:	f1f6                	sd	t4,224(sp)
    800052ec:	f5fa                	sd	t5,232(sp)
    800052ee:	f9fe                	sd	t6,240(sp)
    800052f0:	beffc0ef          	jal	ra,80001ede <kerneltrap>
    800052f4:	6082                	ld	ra,0(sp)
    800052f6:	6122                	ld	sp,8(sp)
    800052f8:	61c2                	ld	gp,16(sp)
    800052fa:	7282                	ld	t0,32(sp)
    800052fc:	7322                	ld	t1,40(sp)
    800052fe:	73c2                	ld	t2,48(sp)
    80005300:	7462                	ld	s0,56(sp)
    80005302:	6486                	ld	s1,64(sp)
    80005304:	6526                	ld	a0,72(sp)
    80005306:	65c6                	ld	a1,80(sp)
    80005308:	6666                	ld	a2,88(sp)
    8000530a:	7686                	ld	a3,96(sp)
    8000530c:	7726                	ld	a4,104(sp)
    8000530e:	77c6                	ld	a5,112(sp)
    80005310:	7866                	ld	a6,120(sp)
    80005312:	688a                	ld	a7,128(sp)
    80005314:	692a                	ld	s2,136(sp)
    80005316:	69ca                	ld	s3,144(sp)
    80005318:	6a6a                	ld	s4,152(sp)
    8000531a:	7a8a                	ld	s5,160(sp)
    8000531c:	7b2a                	ld	s6,168(sp)
    8000531e:	7bca                	ld	s7,176(sp)
    80005320:	7c6a                	ld	s8,184(sp)
    80005322:	6c8e                	ld	s9,192(sp)
    80005324:	6d2e                	ld	s10,200(sp)
    80005326:	6dce                	ld	s11,208(sp)
    80005328:	6e6e                	ld	t3,216(sp)
    8000532a:	7e8e                	ld	t4,224(sp)
    8000532c:	7f2e                	ld	t5,232(sp)
    8000532e:	7fce                	ld	t6,240(sp)
    80005330:	6111                	addi	sp,sp,256
    80005332:	10200073          	sret
    80005336:	00000013          	nop
    8000533a:	00000013          	nop
    8000533e:	0001                	nop

0000000080005340 <timervec>:
    80005340:	34051573          	csrrw	a0,mscratch,a0
    80005344:	e10c                	sd	a1,0(a0)
    80005346:	e510                	sd	a2,8(a0)
    80005348:	e914                	sd	a3,16(a0)
    8000534a:	6d0c                	ld	a1,24(a0)
    8000534c:	7110                	ld	a2,32(a0)
    8000534e:	6194                	ld	a3,0(a1)
    80005350:	96b2                	add	a3,a3,a2
    80005352:	e194                	sd	a3,0(a1)
    80005354:	4589                	li	a1,2
    80005356:	14459073          	csrw	sip,a1
    8000535a:	6914                	ld	a3,16(a0)
    8000535c:	6510                	ld	a2,8(a0)
    8000535e:	610c                	ld	a1,0(a0)
    80005360:	34051573          	csrrw	a0,mscratch,a0
    80005364:	30200073          	mret
	...

000000008000536a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000536a:	1141                	addi	sp,sp,-16
    8000536c:	e422                	sd	s0,8(sp)
    8000536e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005370:	0c0007b7          	lui	a5,0xc000
    80005374:	4705                	li	a4,1
    80005376:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005378:	c3d8                	sw	a4,4(a5)
}
    8000537a:	6422                	ld	s0,8(sp)
    8000537c:	0141                	addi	sp,sp,16
    8000537e:	8082                	ret

0000000080005380 <plicinithart>:

void
plicinithart(void)
{
    80005380:	1141                	addi	sp,sp,-16
    80005382:	e406                	sd	ra,8(sp)
    80005384:	e022                	sd	s0,0(sp)
    80005386:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005388:	ffffc097          	auipc	ra,0xffffc
    8000538c:	aae080e7          	jalr	-1362(ra) # 80000e36 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005390:	0085171b          	slliw	a4,a0,0x8
    80005394:	0c0027b7          	lui	a5,0xc002
    80005398:	97ba                	add	a5,a5,a4
    8000539a:	40200713          	li	a4,1026
    8000539e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    800053a2:	00d5151b          	slliw	a0,a0,0xd
    800053a6:	0c2017b7          	lui	a5,0xc201
    800053aa:	953e                	add	a0,a0,a5
    800053ac:	00052023          	sw	zero,0(a0)
}
    800053b0:	60a2                	ld	ra,8(sp)
    800053b2:	6402                	ld	s0,0(sp)
    800053b4:	0141                	addi	sp,sp,16
    800053b6:	8082                	ret

00000000800053b8 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800053b8:	1141                	addi	sp,sp,-16
    800053ba:	e406                	sd	ra,8(sp)
    800053bc:	e022                	sd	s0,0(sp)
    800053be:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800053c0:	ffffc097          	auipc	ra,0xffffc
    800053c4:	a76080e7          	jalr	-1418(ra) # 80000e36 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800053c8:	00d5179b          	slliw	a5,a0,0xd
    800053cc:	0c201537          	lui	a0,0xc201
    800053d0:	953e                	add	a0,a0,a5
  return irq;
}
    800053d2:	4148                	lw	a0,4(a0)
    800053d4:	60a2                	ld	ra,8(sp)
    800053d6:	6402                	ld	s0,0(sp)
    800053d8:	0141                	addi	sp,sp,16
    800053da:	8082                	ret

00000000800053dc <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800053dc:	1101                	addi	sp,sp,-32
    800053de:	ec06                	sd	ra,24(sp)
    800053e0:	e822                	sd	s0,16(sp)
    800053e2:	e426                	sd	s1,8(sp)
    800053e4:	1000                	addi	s0,sp,32
    800053e6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800053e8:	ffffc097          	auipc	ra,0xffffc
    800053ec:	a4e080e7          	jalr	-1458(ra) # 80000e36 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800053f0:	00d5151b          	slliw	a0,a0,0xd
    800053f4:	0c2017b7          	lui	a5,0xc201
    800053f8:	97aa                	add	a5,a5,a0
    800053fa:	c3c4                	sw	s1,4(a5)
}
    800053fc:	60e2                	ld	ra,24(sp)
    800053fe:	6442                	ld	s0,16(sp)
    80005400:	64a2                	ld	s1,8(sp)
    80005402:	6105                	addi	sp,sp,32
    80005404:	8082                	ret

0000000080005406 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    80005406:	1141                	addi	sp,sp,-16
    80005408:	e406                	sd	ra,8(sp)
    8000540a:	e022                	sd	s0,0(sp)
    8000540c:	0800                	addi	s0,sp,16
  if(i >= NUM)
    8000540e:	479d                	li	a5,7
    80005410:	04a7cc63          	blt	a5,a0,80005468 <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    80005414:	00026797          	auipc	a5,0x26
    80005418:	6ac78793          	addi	a5,a5,1708 # 8002bac0 <disk>
    8000541c:	97aa                	add	a5,a5,a0
    8000541e:	0187c783          	lbu	a5,24(a5)
    80005422:	ebb9                	bnez	a5,80005478 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005424:	00451613          	slli	a2,a0,0x4
    80005428:	00026797          	auipc	a5,0x26
    8000542c:	69878793          	addi	a5,a5,1688 # 8002bac0 <disk>
    80005430:	6394                	ld	a3,0(a5)
    80005432:	96b2                	add	a3,a3,a2
    80005434:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    80005438:	6398                	ld	a4,0(a5)
    8000543a:	9732                	add	a4,a4,a2
    8000543c:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80005440:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005444:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005448:	953e                	add	a0,a0,a5
    8000544a:	4785                	li	a5,1
    8000544c:	00f50c23          	sb	a5,24(a0) # c201018 <_entry-0x73dfefe8>
  wakeup(&disk.free[0]);
    80005450:	00026517          	auipc	a0,0x26
    80005454:	68850513          	addi	a0,a0,1672 # 8002bad8 <disk+0x18>
    80005458:	ffffc097          	auipc	ra,0xffffc
    8000545c:	112080e7          	jalr	274(ra) # 8000156a <wakeup>
}
    80005460:	60a2                	ld	ra,8(sp)
    80005462:	6402                	ld	s0,0(sp)
    80005464:	0141                	addi	sp,sp,16
    80005466:	8082                	ret
    panic("free_desc 1");
    80005468:	00003517          	auipc	a0,0x3
    8000546c:	34850513          	addi	a0,a0,840 # 800087b0 <syscalls+0x318>
    80005470:	00001097          	auipc	ra,0x1
    80005474:	a72080e7          	jalr	-1422(ra) # 80005ee2 <panic>
    panic("free_desc 2");
    80005478:	00003517          	auipc	a0,0x3
    8000547c:	34850513          	addi	a0,a0,840 # 800087c0 <syscalls+0x328>
    80005480:	00001097          	auipc	ra,0x1
    80005484:	a62080e7          	jalr	-1438(ra) # 80005ee2 <panic>

0000000080005488 <virtio_disk_init>:
{
    80005488:	1101                	addi	sp,sp,-32
    8000548a:	ec06                	sd	ra,24(sp)
    8000548c:	e822                	sd	s0,16(sp)
    8000548e:	e426                	sd	s1,8(sp)
    80005490:	e04a                	sd	s2,0(sp)
    80005492:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005494:	00003597          	auipc	a1,0x3
    80005498:	33c58593          	addi	a1,a1,828 # 800087d0 <syscalls+0x338>
    8000549c:	00026517          	auipc	a0,0x26
    800054a0:	74c50513          	addi	a0,a0,1868 # 8002bbe8 <disk+0x128>
    800054a4:	00001097          	auipc	ra,0x1
    800054a8:	ef8080e7          	jalr	-264(ra) # 8000639c <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800054ac:	100017b7          	lui	a5,0x10001
    800054b0:	4398                	lw	a4,0(a5)
    800054b2:	2701                	sext.w	a4,a4
    800054b4:	747277b7          	lui	a5,0x74727
    800054b8:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800054bc:	14f71e63          	bne	a4,a5,80005618 <virtio_disk_init+0x190>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800054c0:	100017b7          	lui	a5,0x10001
    800054c4:	43dc                	lw	a5,4(a5)
    800054c6:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800054c8:	4709                	li	a4,2
    800054ca:	14e79763          	bne	a5,a4,80005618 <virtio_disk_init+0x190>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800054ce:	100017b7          	lui	a5,0x10001
    800054d2:	479c                	lw	a5,8(a5)
    800054d4:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800054d6:	14e79163          	bne	a5,a4,80005618 <virtio_disk_init+0x190>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800054da:	100017b7          	lui	a5,0x10001
    800054de:	47d8                	lw	a4,12(a5)
    800054e0:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800054e2:	554d47b7          	lui	a5,0x554d4
    800054e6:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800054ea:	12f71763          	bne	a4,a5,80005618 <virtio_disk_init+0x190>
  *R(VIRTIO_MMIO_STATUS) = status;
    800054ee:	100017b7          	lui	a5,0x10001
    800054f2:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    800054f6:	4705                	li	a4,1
    800054f8:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800054fa:	470d                	li	a4,3
    800054fc:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800054fe:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    80005500:	c7ffe737          	lui	a4,0xc7ffe
    80005504:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fca91f>
    80005508:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    8000550a:	2701                	sext.w	a4,a4
    8000550c:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000550e:	472d                	li	a4,11
    80005510:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    80005512:	0707a903          	lw	s2,112(a5)
    80005516:	2901                	sext.w	s2,s2
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005518:	00897793          	andi	a5,s2,8
    8000551c:	10078663          	beqz	a5,80005628 <virtio_disk_init+0x1a0>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005520:	100017b7          	lui	a5,0x10001
    80005524:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80005528:	43fc                	lw	a5,68(a5)
    8000552a:	2781                	sext.w	a5,a5
    8000552c:	10079663          	bnez	a5,80005638 <virtio_disk_init+0x1b0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005530:	100017b7          	lui	a5,0x10001
    80005534:	5bdc                	lw	a5,52(a5)
    80005536:	2781                	sext.w	a5,a5
  if(max == 0)
    80005538:	10078863          	beqz	a5,80005648 <virtio_disk_init+0x1c0>
  if(max < NUM)
    8000553c:	471d                	li	a4,7
    8000553e:	10f77d63          	bgeu	a4,a5,80005658 <virtio_disk_init+0x1d0>
  disk.desc = kalloc();
    80005542:	ffffb097          	auipc	ra,0xffffb
    80005546:	bd6080e7          	jalr	-1066(ra) # 80000118 <kalloc>
    8000554a:	00026497          	auipc	s1,0x26
    8000554e:	57648493          	addi	s1,s1,1398 # 8002bac0 <disk>
    80005552:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005554:	ffffb097          	auipc	ra,0xffffb
    80005558:	bc4080e7          	jalr	-1084(ra) # 80000118 <kalloc>
    8000555c:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000555e:	ffffb097          	auipc	ra,0xffffb
    80005562:	bba080e7          	jalr	-1094(ra) # 80000118 <kalloc>
    80005566:	87aa                	mv	a5,a0
    80005568:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    8000556a:	6088                	ld	a0,0(s1)
    8000556c:	cd75                	beqz	a0,80005668 <virtio_disk_init+0x1e0>
    8000556e:	00026717          	auipc	a4,0x26
    80005572:	55a73703          	ld	a4,1370(a4) # 8002bac8 <disk+0x8>
    80005576:	cb6d                	beqz	a4,80005668 <virtio_disk_init+0x1e0>
    80005578:	cbe5                	beqz	a5,80005668 <virtio_disk_init+0x1e0>
  memset(disk.desc, 0, PGSIZE);
    8000557a:	6605                	lui	a2,0x1
    8000557c:	4581                	li	a1,0
    8000557e:	ffffb097          	auipc	ra,0xffffb
    80005582:	bfa080e7          	jalr	-1030(ra) # 80000178 <memset>
  memset(disk.avail, 0, PGSIZE);
    80005586:	00026497          	auipc	s1,0x26
    8000558a:	53a48493          	addi	s1,s1,1338 # 8002bac0 <disk>
    8000558e:	6605                	lui	a2,0x1
    80005590:	4581                	li	a1,0
    80005592:	6488                	ld	a0,8(s1)
    80005594:	ffffb097          	auipc	ra,0xffffb
    80005598:	be4080e7          	jalr	-1052(ra) # 80000178 <memset>
  memset(disk.used, 0, PGSIZE);
    8000559c:	6605                	lui	a2,0x1
    8000559e:	4581                	li	a1,0
    800055a0:	6888                	ld	a0,16(s1)
    800055a2:	ffffb097          	auipc	ra,0xffffb
    800055a6:	bd6080e7          	jalr	-1066(ra) # 80000178 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    800055aa:	100017b7          	lui	a5,0x10001
    800055ae:	4721                	li	a4,8
    800055b0:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    800055b2:	4098                	lw	a4,0(s1)
    800055b4:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    800055b8:	40d8                	lw	a4,4(s1)
    800055ba:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    800055be:	6498                	ld	a4,8(s1)
    800055c0:	0007069b          	sext.w	a3,a4
    800055c4:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    800055c8:	9701                	srai	a4,a4,0x20
    800055ca:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    800055ce:	6898                	ld	a4,16(s1)
    800055d0:	0007069b          	sext.w	a3,a4
    800055d4:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    800055d8:	9701                	srai	a4,a4,0x20
    800055da:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    800055de:	4685                	li	a3,1
    800055e0:	c3f4                	sw	a3,68(a5)
    disk.free[i] = 1;
    800055e2:	4705                	li	a4,1
    800055e4:	00d48c23          	sb	a3,24(s1)
    800055e8:	00e48ca3          	sb	a4,25(s1)
    800055ec:	00e48d23          	sb	a4,26(s1)
    800055f0:	00e48da3          	sb	a4,27(s1)
    800055f4:	00e48e23          	sb	a4,28(s1)
    800055f8:	00e48ea3          	sb	a4,29(s1)
    800055fc:	00e48f23          	sb	a4,30(s1)
    80005600:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    80005604:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    80005608:	0727a823          	sw	s2,112(a5)
}
    8000560c:	60e2                	ld	ra,24(sp)
    8000560e:	6442                	ld	s0,16(sp)
    80005610:	64a2                	ld	s1,8(sp)
    80005612:	6902                	ld	s2,0(sp)
    80005614:	6105                	addi	sp,sp,32
    80005616:	8082                	ret
    panic("could not find virtio disk");
    80005618:	00003517          	auipc	a0,0x3
    8000561c:	1c850513          	addi	a0,a0,456 # 800087e0 <syscalls+0x348>
    80005620:	00001097          	auipc	ra,0x1
    80005624:	8c2080e7          	jalr	-1854(ra) # 80005ee2 <panic>
    panic("virtio disk FEATURES_OK unset");
    80005628:	00003517          	auipc	a0,0x3
    8000562c:	1d850513          	addi	a0,a0,472 # 80008800 <syscalls+0x368>
    80005630:	00001097          	auipc	ra,0x1
    80005634:	8b2080e7          	jalr	-1870(ra) # 80005ee2 <panic>
    panic("virtio disk should not be ready");
    80005638:	00003517          	auipc	a0,0x3
    8000563c:	1e850513          	addi	a0,a0,488 # 80008820 <syscalls+0x388>
    80005640:	00001097          	auipc	ra,0x1
    80005644:	8a2080e7          	jalr	-1886(ra) # 80005ee2 <panic>
    panic("virtio disk has no queue 0");
    80005648:	00003517          	auipc	a0,0x3
    8000564c:	1f850513          	addi	a0,a0,504 # 80008840 <syscalls+0x3a8>
    80005650:	00001097          	auipc	ra,0x1
    80005654:	892080e7          	jalr	-1902(ra) # 80005ee2 <panic>
    panic("virtio disk max queue too short");
    80005658:	00003517          	auipc	a0,0x3
    8000565c:	20850513          	addi	a0,a0,520 # 80008860 <syscalls+0x3c8>
    80005660:	00001097          	auipc	ra,0x1
    80005664:	882080e7          	jalr	-1918(ra) # 80005ee2 <panic>
    panic("virtio disk kalloc");
    80005668:	00003517          	auipc	a0,0x3
    8000566c:	21850513          	addi	a0,a0,536 # 80008880 <syscalls+0x3e8>
    80005670:	00001097          	auipc	ra,0x1
    80005674:	872080e7          	jalr	-1934(ra) # 80005ee2 <panic>

0000000080005678 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005678:	7159                	addi	sp,sp,-112
    8000567a:	f486                	sd	ra,104(sp)
    8000567c:	f0a2                	sd	s0,96(sp)
    8000567e:	eca6                	sd	s1,88(sp)
    80005680:	e8ca                	sd	s2,80(sp)
    80005682:	e4ce                	sd	s3,72(sp)
    80005684:	e0d2                	sd	s4,64(sp)
    80005686:	fc56                	sd	s5,56(sp)
    80005688:	f85a                	sd	s6,48(sp)
    8000568a:	f45e                	sd	s7,40(sp)
    8000568c:	f062                	sd	s8,32(sp)
    8000568e:	ec66                	sd	s9,24(sp)
    80005690:	e86a                	sd	s10,16(sp)
    80005692:	1880                	addi	s0,sp,112
    80005694:	892a                	mv	s2,a0
    80005696:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005698:	00c52c83          	lw	s9,12(a0)
    8000569c:	001c9c9b          	slliw	s9,s9,0x1
    800056a0:	1c82                	slli	s9,s9,0x20
    800056a2:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    800056a6:	00026517          	auipc	a0,0x26
    800056aa:	54250513          	addi	a0,a0,1346 # 8002bbe8 <disk+0x128>
    800056ae:	00001097          	auipc	ra,0x1
    800056b2:	d7e080e7          	jalr	-642(ra) # 8000642c <acquire>
  for(int i = 0; i < 3; i++){
    800056b6:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    800056b8:	4ba1                	li	s7,8
      disk.free[i] = 0;
    800056ba:	00026b17          	auipc	s6,0x26
    800056be:	406b0b13          	addi	s6,s6,1030 # 8002bac0 <disk>
  for(int i = 0; i < 3; i++){
    800056c2:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    800056c4:	8a4e                	mv	s4,s3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800056c6:	00026c17          	auipc	s8,0x26
    800056ca:	522c0c13          	addi	s8,s8,1314 # 8002bbe8 <disk+0x128>
    800056ce:	a8b5                	j	8000574a <virtio_disk_rw+0xd2>
      disk.free[i] = 0;
    800056d0:	00fb06b3          	add	a3,s6,a5
    800056d4:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    800056d8:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    800056da:	0207c563          	bltz	a5,80005704 <virtio_disk_rw+0x8c>
  for(int i = 0; i < 3; i++){
    800056de:	2485                	addiw	s1,s1,1
    800056e0:	0711                	addi	a4,a4,4
    800056e2:	1f548a63          	beq	s1,s5,800058d6 <virtio_disk_rw+0x25e>
    idx[i] = alloc_desc();
    800056e6:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    800056e8:	00026697          	auipc	a3,0x26
    800056ec:	3d868693          	addi	a3,a3,984 # 8002bac0 <disk>
    800056f0:	87d2                	mv	a5,s4
    if(disk.free[i]){
    800056f2:	0186c583          	lbu	a1,24(a3)
    800056f6:	fde9                	bnez	a1,800056d0 <virtio_disk_rw+0x58>
  for(int i = 0; i < NUM; i++){
    800056f8:	2785                	addiw	a5,a5,1
    800056fa:	0685                	addi	a3,a3,1
    800056fc:	ff779be3          	bne	a5,s7,800056f2 <virtio_disk_rw+0x7a>
    idx[i] = alloc_desc();
    80005700:	57fd                	li	a5,-1
    80005702:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    80005704:	02905a63          	blez	s1,80005738 <virtio_disk_rw+0xc0>
        free_desc(idx[j]);
    80005708:	f9042503          	lw	a0,-112(s0)
    8000570c:	00000097          	auipc	ra,0x0
    80005710:	cfa080e7          	jalr	-774(ra) # 80005406 <free_desc>
      for(int j = 0; j < i; j++)
    80005714:	4785                	li	a5,1
    80005716:	0297d163          	bge	a5,s1,80005738 <virtio_disk_rw+0xc0>
        free_desc(idx[j]);
    8000571a:	f9442503          	lw	a0,-108(s0)
    8000571e:	00000097          	auipc	ra,0x0
    80005722:	ce8080e7          	jalr	-792(ra) # 80005406 <free_desc>
      for(int j = 0; j < i; j++)
    80005726:	4789                	li	a5,2
    80005728:	0097d863          	bge	a5,s1,80005738 <virtio_disk_rw+0xc0>
        free_desc(idx[j]);
    8000572c:	f9842503          	lw	a0,-104(s0)
    80005730:	00000097          	auipc	ra,0x0
    80005734:	cd6080e7          	jalr	-810(ra) # 80005406 <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005738:	85e2                	mv	a1,s8
    8000573a:	00026517          	auipc	a0,0x26
    8000573e:	39e50513          	addi	a0,a0,926 # 8002bad8 <disk+0x18>
    80005742:	ffffc097          	auipc	ra,0xffffc
    80005746:	dc4080e7          	jalr	-572(ra) # 80001506 <sleep>
  for(int i = 0; i < 3; i++){
    8000574a:	f9040713          	addi	a4,s0,-112
    8000574e:	84ce                	mv	s1,s3
    80005750:	bf59                	j	800056e6 <virtio_disk_rw+0x6e>
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

  if(write)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    80005752:	00a60793          	addi	a5,a2,10 # 100a <_entry-0x7fffeff6>
    80005756:	00479693          	slli	a3,a5,0x4
    8000575a:	00026797          	auipc	a5,0x26
    8000575e:	36678793          	addi	a5,a5,870 # 8002bac0 <disk>
    80005762:	97b6                	add	a5,a5,a3
    80005764:	4685                	li	a3,1
    80005766:	c794                	sw	a3,8(a5)
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80005768:	00026597          	auipc	a1,0x26
    8000576c:	35858593          	addi	a1,a1,856 # 8002bac0 <disk>
    80005770:	00a60793          	addi	a5,a2,10
    80005774:	0792                	slli	a5,a5,0x4
    80005776:	97ae                	add	a5,a5,a1
    80005778:	0007a623          	sw	zero,12(a5)
  buf0->sector = sector;
    8000577c:	0197b823          	sd	s9,16(a5)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005780:	f6070693          	addi	a3,a4,-160
    80005784:	619c                	ld	a5,0(a1)
    80005786:	97b6                	add	a5,a5,a3
    80005788:	e388                	sd	a0,0(a5)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    8000578a:	6188                	ld	a0,0(a1)
    8000578c:	96aa                	add	a3,a3,a0
    8000578e:	47c1                	li	a5,16
    80005790:	c69c                	sw	a5,8(a3)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005792:	4785                	li	a5,1
    80005794:	00f69623          	sh	a5,12(a3)
  disk.desc[idx[0]].next = idx[1];
    80005798:	f9442783          	lw	a5,-108(s0)
    8000579c:	00f69723          	sh	a5,14(a3)

  disk.desc[idx[1]].addr = (uint64) b->data;
    800057a0:	0792                	slli	a5,a5,0x4
    800057a2:	953e                	add	a0,a0,a5
    800057a4:	05890693          	addi	a3,s2,88
    800057a8:	e114                	sd	a3,0(a0)
  disk.desc[idx[1]].len = BSIZE;
    800057aa:	6188                	ld	a0,0(a1)
    800057ac:	97aa                	add	a5,a5,a0
    800057ae:	40000693          	li	a3,1024
    800057b2:	c794                	sw	a3,8(a5)
  if(write)
    800057b4:	100d0d63          	beqz	s10,800058ce <virtio_disk_rw+0x256>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    800057b8:	00079623          	sh	zero,12(a5)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800057bc:	00c7d683          	lhu	a3,12(a5)
    800057c0:	0016e693          	ori	a3,a3,1
    800057c4:	00d79623          	sh	a3,12(a5)
  disk.desc[idx[1]].next = idx[2];
    800057c8:	f9842583          	lw	a1,-104(s0)
    800057cc:	00b79723          	sh	a1,14(a5)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800057d0:	00026697          	auipc	a3,0x26
    800057d4:	2f068693          	addi	a3,a3,752 # 8002bac0 <disk>
    800057d8:	00260793          	addi	a5,a2,2
    800057dc:	0792                	slli	a5,a5,0x4
    800057de:	97b6                	add	a5,a5,a3
    800057e0:	587d                	li	a6,-1
    800057e2:	01078823          	sb	a6,16(a5)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800057e6:	0592                	slli	a1,a1,0x4
    800057e8:	952e                	add	a0,a0,a1
    800057ea:	f9070713          	addi	a4,a4,-112
    800057ee:	9736                	add	a4,a4,a3
    800057f0:	e118                	sd	a4,0(a0)
  disk.desc[idx[2]].len = 1;
    800057f2:	6298                	ld	a4,0(a3)
    800057f4:	972e                	add	a4,a4,a1
    800057f6:	4585                	li	a1,1
    800057f8:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800057fa:	4509                	li	a0,2
    800057fc:	00a71623          	sh	a0,12(a4)
  disk.desc[idx[2]].next = 0;
    80005800:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    80005804:	00b92223          	sw	a1,4(s2)
  disk.info[idx[0]].b = b;
    80005808:	0127b423          	sd	s2,8(a5)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    8000580c:	6698                	ld	a4,8(a3)
    8000580e:	00275783          	lhu	a5,2(a4)
    80005812:	8b9d                	andi	a5,a5,7
    80005814:	0786                	slli	a5,a5,0x1
    80005816:	97ba                	add	a5,a5,a4
    80005818:	00c79223          	sh	a2,4(a5)

  __sync_synchronize();
    8000581c:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005820:	6698                	ld	a4,8(a3)
    80005822:	00275783          	lhu	a5,2(a4)
    80005826:	2785                	addiw	a5,a5,1
    80005828:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    8000582c:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005830:	100017b7          	lui	a5,0x10001
    80005834:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005838:	00492703          	lw	a4,4(s2)
    8000583c:	4785                	li	a5,1
    8000583e:	02f71163          	bne	a4,a5,80005860 <virtio_disk_rw+0x1e8>
    sleep(b, &disk.vdisk_lock);
    80005842:	00026997          	auipc	s3,0x26
    80005846:	3a698993          	addi	s3,s3,934 # 8002bbe8 <disk+0x128>
  while(b->disk == 1) {
    8000584a:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    8000584c:	85ce                	mv	a1,s3
    8000584e:	854a                	mv	a0,s2
    80005850:	ffffc097          	auipc	ra,0xffffc
    80005854:	cb6080e7          	jalr	-842(ra) # 80001506 <sleep>
  while(b->disk == 1) {
    80005858:	00492783          	lw	a5,4(s2)
    8000585c:	fe9788e3          	beq	a5,s1,8000584c <virtio_disk_rw+0x1d4>
  }

  disk.info[idx[0]].b = 0;
    80005860:	f9042903          	lw	s2,-112(s0)
    80005864:	00290793          	addi	a5,s2,2
    80005868:	00479713          	slli	a4,a5,0x4
    8000586c:	00026797          	auipc	a5,0x26
    80005870:	25478793          	addi	a5,a5,596 # 8002bac0 <disk>
    80005874:	97ba                	add	a5,a5,a4
    80005876:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    8000587a:	00026997          	auipc	s3,0x26
    8000587e:	24698993          	addi	s3,s3,582 # 8002bac0 <disk>
    80005882:	00491713          	slli	a4,s2,0x4
    80005886:	0009b783          	ld	a5,0(s3)
    8000588a:	97ba                	add	a5,a5,a4
    8000588c:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005890:	854a                	mv	a0,s2
    80005892:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005896:	00000097          	auipc	ra,0x0
    8000589a:	b70080e7          	jalr	-1168(ra) # 80005406 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    8000589e:	8885                	andi	s1,s1,1
    800058a0:	f0ed                	bnez	s1,80005882 <virtio_disk_rw+0x20a>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    800058a2:	00026517          	auipc	a0,0x26
    800058a6:	34650513          	addi	a0,a0,838 # 8002bbe8 <disk+0x128>
    800058aa:	00001097          	auipc	ra,0x1
    800058ae:	c36080e7          	jalr	-970(ra) # 800064e0 <release>
}
    800058b2:	70a6                	ld	ra,104(sp)
    800058b4:	7406                	ld	s0,96(sp)
    800058b6:	64e6                	ld	s1,88(sp)
    800058b8:	6946                	ld	s2,80(sp)
    800058ba:	69a6                	ld	s3,72(sp)
    800058bc:	6a06                	ld	s4,64(sp)
    800058be:	7ae2                	ld	s5,56(sp)
    800058c0:	7b42                	ld	s6,48(sp)
    800058c2:	7ba2                	ld	s7,40(sp)
    800058c4:	7c02                	ld	s8,32(sp)
    800058c6:	6ce2                	ld	s9,24(sp)
    800058c8:	6d42                	ld	s10,16(sp)
    800058ca:	6165                	addi	sp,sp,112
    800058cc:	8082                	ret
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    800058ce:	4689                	li	a3,2
    800058d0:	00d79623          	sh	a3,12(a5)
    800058d4:	b5e5                	j	800057bc <virtio_disk_rw+0x144>
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800058d6:	f9042603          	lw	a2,-112(s0)
    800058da:	00a60713          	addi	a4,a2,10
    800058de:	0712                	slli	a4,a4,0x4
    800058e0:	00026517          	auipc	a0,0x26
    800058e4:	1e850513          	addi	a0,a0,488 # 8002bac8 <disk+0x8>
    800058e8:	953a                	add	a0,a0,a4
  if(write)
    800058ea:	e60d14e3          	bnez	s10,80005752 <virtio_disk_rw+0xda>
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    800058ee:	00a60793          	addi	a5,a2,10
    800058f2:	00479693          	slli	a3,a5,0x4
    800058f6:	00026797          	auipc	a5,0x26
    800058fa:	1ca78793          	addi	a5,a5,458 # 8002bac0 <disk>
    800058fe:	97b6                	add	a5,a5,a3
    80005900:	0007a423          	sw	zero,8(a5)
    80005904:	b595                	j	80005768 <virtio_disk_rw+0xf0>

0000000080005906 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005906:	1101                	addi	sp,sp,-32
    80005908:	ec06                	sd	ra,24(sp)
    8000590a:	e822                	sd	s0,16(sp)
    8000590c:	e426                	sd	s1,8(sp)
    8000590e:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005910:	00026497          	auipc	s1,0x26
    80005914:	1b048493          	addi	s1,s1,432 # 8002bac0 <disk>
    80005918:	00026517          	auipc	a0,0x26
    8000591c:	2d050513          	addi	a0,a0,720 # 8002bbe8 <disk+0x128>
    80005920:	00001097          	auipc	ra,0x1
    80005924:	b0c080e7          	jalr	-1268(ra) # 8000642c <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005928:	10001737          	lui	a4,0x10001
    8000592c:	533c                	lw	a5,96(a4)
    8000592e:	8b8d                	andi	a5,a5,3
    80005930:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80005932:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005936:	689c                	ld	a5,16(s1)
    80005938:	0204d703          	lhu	a4,32(s1)
    8000593c:	0027d783          	lhu	a5,2(a5)
    80005940:	04f70863          	beq	a4,a5,80005990 <virtio_disk_intr+0x8a>
    __sync_synchronize();
    80005944:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005948:	6898                	ld	a4,16(s1)
    8000594a:	0204d783          	lhu	a5,32(s1)
    8000594e:	8b9d                	andi	a5,a5,7
    80005950:	078e                	slli	a5,a5,0x3
    80005952:	97ba                	add	a5,a5,a4
    80005954:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005956:	00278713          	addi	a4,a5,2
    8000595a:	0712                	slli	a4,a4,0x4
    8000595c:	9726                	add	a4,a4,s1
    8000595e:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    80005962:	e721                	bnez	a4,800059aa <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005964:	0789                	addi	a5,a5,2
    80005966:	0792                	slli	a5,a5,0x4
    80005968:	97a6                	add	a5,a5,s1
    8000596a:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    8000596c:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005970:	ffffc097          	auipc	ra,0xffffc
    80005974:	bfa080e7          	jalr	-1030(ra) # 8000156a <wakeup>

    disk.used_idx += 1;
    80005978:	0204d783          	lhu	a5,32(s1)
    8000597c:	2785                	addiw	a5,a5,1
    8000597e:	17c2                	slli	a5,a5,0x30
    80005980:	93c1                	srli	a5,a5,0x30
    80005982:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005986:	6898                	ld	a4,16(s1)
    80005988:	00275703          	lhu	a4,2(a4)
    8000598c:	faf71ce3          	bne	a4,a5,80005944 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80005990:	00026517          	auipc	a0,0x26
    80005994:	25850513          	addi	a0,a0,600 # 8002bbe8 <disk+0x128>
    80005998:	00001097          	auipc	ra,0x1
    8000599c:	b48080e7          	jalr	-1208(ra) # 800064e0 <release>
}
    800059a0:	60e2                	ld	ra,24(sp)
    800059a2:	6442                	ld	s0,16(sp)
    800059a4:	64a2                	ld	s1,8(sp)
    800059a6:	6105                	addi	sp,sp,32
    800059a8:	8082                	ret
      panic("virtio_disk_intr status");
    800059aa:	00003517          	auipc	a0,0x3
    800059ae:	eee50513          	addi	a0,a0,-274 # 80008898 <syscalls+0x400>
    800059b2:	00000097          	auipc	ra,0x0
    800059b6:	530080e7          	jalr	1328(ra) # 80005ee2 <panic>

00000000800059ba <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    800059ba:	1141                	addi	sp,sp,-16
    800059bc:	e422                	sd	s0,8(sp)
    800059be:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    800059c0:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    800059c4:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    800059c8:	0037979b          	slliw	a5,a5,0x3
    800059cc:	02004737          	lui	a4,0x2004
    800059d0:	97ba                	add	a5,a5,a4
    800059d2:	0200c737          	lui	a4,0x200c
    800059d6:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    800059da:	000f4637          	lui	a2,0xf4
    800059de:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    800059e2:	95b2                	add	a1,a1,a2
    800059e4:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    800059e6:	00269713          	slli	a4,a3,0x2
    800059ea:	9736                	add	a4,a4,a3
    800059ec:	00371693          	slli	a3,a4,0x3
    800059f0:	00026717          	auipc	a4,0x26
    800059f4:	21070713          	addi	a4,a4,528 # 8002bc00 <timer_scratch>
    800059f8:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    800059fa:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    800059fc:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    800059fe:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80005a02:	00000797          	auipc	a5,0x0
    80005a06:	93e78793          	addi	a5,a5,-1730 # 80005340 <timervec>
    80005a0a:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005a0e:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80005a12:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005a16:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005a1a:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80005a1e:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80005a22:	30479073          	csrw	mie,a5
}
    80005a26:	6422                	ld	s0,8(sp)
    80005a28:	0141                	addi	sp,sp,16
    80005a2a:	8082                	ret

0000000080005a2c <start>:
{
    80005a2c:	1141                	addi	sp,sp,-16
    80005a2e:	e406                	sd	ra,8(sp)
    80005a30:	e022                	sd	s0,0(sp)
    80005a32:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005a34:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005a38:	7779                	lui	a4,0xffffe
    80005a3a:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffca9bf>
    80005a3e:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80005a40:	6705                	lui	a4,0x1
    80005a42:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005a46:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005a48:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005a4c:	ffffb797          	auipc	a5,0xffffb
    80005a50:	8da78793          	addi	a5,a5,-1830 # 80000326 <main>
    80005a54:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005a58:	4781                	li	a5,0
    80005a5a:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005a5e:	67c1                	lui	a5,0x10
    80005a60:	17fd                	addi	a5,a5,-1
    80005a62:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005a66:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005a6a:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005a6e:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005a72:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005a76:	57fd                	li	a5,-1
    80005a78:	83a9                	srli	a5,a5,0xa
    80005a7a:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005a7e:	47bd                	li	a5,15
    80005a80:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005a84:	00000097          	auipc	ra,0x0
    80005a88:	f36080e7          	jalr	-202(ra) # 800059ba <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005a8c:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005a90:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005a92:	823e                	mv	tp,a5
  asm volatile("mret");
    80005a94:	30200073          	mret
}
    80005a98:	60a2                	ld	ra,8(sp)
    80005a9a:	6402                	ld	s0,0(sp)
    80005a9c:	0141                	addi	sp,sp,16
    80005a9e:	8082                	ret

0000000080005aa0 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005aa0:	715d                	addi	sp,sp,-80
    80005aa2:	e486                	sd	ra,72(sp)
    80005aa4:	e0a2                	sd	s0,64(sp)
    80005aa6:	fc26                	sd	s1,56(sp)
    80005aa8:	f84a                	sd	s2,48(sp)
    80005aaa:	f44e                	sd	s3,40(sp)
    80005aac:	f052                	sd	s4,32(sp)
    80005aae:	ec56                	sd	s5,24(sp)
    80005ab0:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005ab2:	04c05663          	blez	a2,80005afe <consolewrite+0x5e>
    80005ab6:	8a2a                	mv	s4,a0
    80005ab8:	84ae                	mv	s1,a1
    80005aba:	89b2                	mv	s3,a2
    80005abc:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005abe:	5afd                	li	s5,-1
    80005ac0:	4685                	li	a3,1
    80005ac2:	8626                	mv	a2,s1
    80005ac4:	85d2                	mv	a1,s4
    80005ac6:	fbf40513          	addi	a0,s0,-65
    80005aca:	ffffc097          	auipc	ra,0xffffc
    80005ace:	e9a080e7          	jalr	-358(ra) # 80001964 <either_copyin>
    80005ad2:	01550c63          	beq	a0,s5,80005aea <consolewrite+0x4a>
      break;
    uartputc(c);
    80005ad6:	fbf44503          	lbu	a0,-65(s0)
    80005ada:	00000097          	auipc	ra,0x0
    80005ade:	794080e7          	jalr	1940(ra) # 8000626e <uartputc>
  for(i = 0; i < n; i++){
    80005ae2:	2905                	addiw	s2,s2,1
    80005ae4:	0485                	addi	s1,s1,1
    80005ae6:	fd299de3          	bne	s3,s2,80005ac0 <consolewrite+0x20>
  }

  return i;
}
    80005aea:	854a                	mv	a0,s2
    80005aec:	60a6                	ld	ra,72(sp)
    80005aee:	6406                	ld	s0,64(sp)
    80005af0:	74e2                	ld	s1,56(sp)
    80005af2:	7942                	ld	s2,48(sp)
    80005af4:	79a2                	ld	s3,40(sp)
    80005af6:	7a02                	ld	s4,32(sp)
    80005af8:	6ae2                	ld	s5,24(sp)
    80005afa:	6161                	addi	sp,sp,80
    80005afc:	8082                	ret
  for(i = 0; i < n; i++){
    80005afe:	4901                	li	s2,0
    80005b00:	b7ed                	j	80005aea <consolewrite+0x4a>

0000000080005b02 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005b02:	7119                	addi	sp,sp,-128
    80005b04:	fc86                	sd	ra,120(sp)
    80005b06:	f8a2                	sd	s0,112(sp)
    80005b08:	f4a6                	sd	s1,104(sp)
    80005b0a:	f0ca                	sd	s2,96(sp)
    80005b0c:	ecce                	sd	s3,88(sp)
    80005b0e:	e8d2                	sd	s4,80(sp)
    80005b10:	e4d6                	sd	s5,72(sp)
    80005b12:	e0da                	sd	s6,64(sp)
    80005b14:	fc5e                	sd	s7,56(sp)
    80005b16:	f862                	sd	s8,48(sp)
    80005b18:	f466                	sd	s9,40(sp)
    80005b1a:	f06a                	sd	s10,32(sp)
    80005b1c:	ec6e                	sd	s11,24(sp)
    80005b1e:	0100                	addi	s0,sp,128
    80005b20:	8b2a                	mv	s6,a0
    80005b22:	8aae                	mv	s5,a1
    80005b24:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005b26:	00060b9b          	sext.w	s7,a2
  acquire(&cons.lock);
    80005b2a:	0002e517          	auipc	a0,0x2e
    80005b2e:	21650513          	addi	a0,a0,534 # 80033d40 <cons>
    80005b32:	00001097          	auipc	ra,0x1
    80005b36:	8fa080e7          	jalr	-1798(ra) # 8000642c <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005b3a:	0002e497          	auipc	s1,0x2e
    80005b3e:	20648493          	addi	s1,s1,518 # 80033d40 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005b42:	89a6                	mv	s3,s1
    80005b44:	0002e917          	auipc	s2,0x2e
    80005b48:	29490913          	addi	s2,s2,660 # 80033dd8 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];

    if(c == C('D')){  // end-of-file
    80005b4c:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005b4e:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    80005b50:	4da9                	li	s11,10
  while(n > 0){
    80005b52:	07405b63          	blez	s4,80005bc8 <consoleread+0xc6>
    while(cons.r == cons.w){
    80005b56:	0984a783          	lw	a5,152(s1)
    80005b5a:	09c4a703          	lw	a4,156(s1)
    80005b5e:	02f71763          	bne	a4,a5,80005b8c <consoleread+0x8a>
      if(killed(myproc())){
    80005b62:	ffffb097          	auipc	ra,0xffffb
    80005b66:	300080e7          	jalr	768(ra) # 80000e62 <myproc>
    80005b6a:	ffffc097          	auipc	ra,0xffffc
    80005b6e:	c44080e7          	jalr	-956(ra) # 800017ae <killed>
    80005b72:	e535                	bnez	a0,80005bde <consoleread+0xdc>
      sleep(&cons.r, &cons.lock);
    80005b74:	85ce                	mv	a1,s3
    80005b76:	854a                	mv	a0,s2
    80005b78:	ffffc097          	auipc	ra,0xffffc
    80005b7c:	98e080e7          	jalr	-1650(ra) # 80001506 <sleep>
    while(cons.r == cons.w){
    80005b80:	0984a783          	lw	a5,152(s1)
    80005b84:	09c4a703          	lw	a4,156(s1)
    80005b88:	fcf70de3          	beq	a4,a5,80005b62 <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80005b8c:	0017871b          	addiw	a4,a5,1
    80005b90:	08e4ac23          	sw	a4,152(s1)
    80005b94:	07f7f713          	andi	a4,a5,127
    80005b98:	9726                	add	a4,a4,s1
    80005b9a:	01874703          	lbu	a4,24(a4)
    80005b9e:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    80005ba2:	079c0663          	beq	s8,s9,80005c0e <consoleread+0x10c>
    cbuf = c;
    80005ba6:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005baa:	4685                	li	a3,1
    80005bac:	f8f40613          	addi	a2,s0,-113
    80005bb0:	85d6                	mv	a1,s5
    80005bb2:	855a                	mv	a0,s6
    80005bb4:	ffffc097          	auipc	ra,0xffffc
    80005bb8:	d5a080e7          	jalr	-678(ra) # 8000190e <either_copyout>
    80005bbc:	01a50663          	beq	a0,s10,80005bc8 <consoleread+0xc6>
    dst++;
    80005bc0:	0a85                	addi	s5,s5,1
    --n;
    80005bc2:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    80005bc4:	f9bc17e3          	bne	s8,s11,80005b52 <consoleread+0x50>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005bc8:	0002e517          	auipc	a0,0x2e
    80005bcc:	17850513          	addi	a0,a0,376 # 80033d40 <cons>
    80005bd0:	00001097          	auipc	ra,0x1
    80005bd4:	910080e7          	jalr	-1776(ra) # 800064e0 <release>

  return target - n;
    80005bd8:	414b853b          	subw	a0,s7,s4
    80005bdc:	a811                	j	80005bf0 <consoleread+0xee>
        release(&cons.lock);
    80005bde:	0002e517          	auipc	a0,0x2e
    80005be2:	16250513          	addi	a0,a0,354 # 80033d40 <cons>
    80005be6:	00001097          	auipc	ra,0x1
    80005bea:	8fa080e7          	jalr	-1798(ra) # 800064e0 <release>
        return -1;
    80005bee:	557d                	li	a0,-1
}
    80005bf0:	70e6                	ld	ra,120(sp)
    80005bf2:	7446                	ld	s0,112(sp)
    80005bf4:	74a6                	ld	s1,104(sp)
    80005bf6:	7906                	ld	s2,96(sp)
    80005bf8:	69e6                	ld	s3,88(sp)
    80005bfa:	6a46                	ld	s4,80(sp)
    80005bfc:	6aa6                	ld	s5,72(sp)
    80005bfe:	6b06                	ld	s6,64(sp)
    80005c00:	7be2                	ld	s7,56(sp)
    80005c02:	7c42                	ld	s8,48(sp)
    80005c04:	7ca2                	ld	s9,40(sp)
    80005c06:	7d02                	ld	s10,32(sp)
    80005c08:	6de2                	ld	s11,24(sp)
    80005c0a:	6109                	addi	sp,sp,128
    80005c0c:	8082                	ret
      if(n < target){
    80005c0e:	000a071b          	sext.w	a4,s4
    80005c12:	fb777be3          	bgeu	a4,s7,80005bc8 <consoleread+0xc6>
        cons.r--;
    80005c16:	0002e717          	auipc	a4,0x2e
    80005c1a:	1cf72123          	sw	a5,450(a4) # 80033dd8 <cons+0x98>
    80005c1e:	b76d                	j	80005bc8 <consoleread+0xc6>

0000000080005c20 <consputc>:
{
    80005c20:	1141                	addi	sp,sp,-16
    80005c22:	e406                	sd	ra,8(sp)
    80005c24:	e022                	sd	s0,0(sp)
    80005c26:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005c28:	10000793          	li	a5,256
    80005c2c:	00f50a63          	beq	a0,a5,80005c40 <consputc+0x20>
    uartputc_sync(c);
    80005c30:	00000097          	auipc	ra,0x0
    80005c34:	564080e7          	jalr	1380(ra) # 80006194 <uartputc_sync>
}
    80005c38:	60a2                	ld	ra,8(sp)
    80005c3a:	6402                	ld	s0,0(sp)
    80005c3c:	0141                	addi	sp,sp,16
    80005c3e:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005c40:	4521                	li	a0,8
    80005c42:	00000097          	auipc	ra,0x0
    80005c46:	552080e7          	jalr	1362(ra) # 80006194 <uartputc_sync>
    80005c4a:	02000513          	li	a0,32
    80005c4e:	00000097          	auipc	ra,0x0
    80005c52:	546080e7          	jalr	1350(ra) # 80006194 <uartputc_sync>
    80005c56:	4521                	li	a0,8
    80005c58:	00000097          	auipc	ra,0x0
    80005c5c:	53c080e7          	jalr	1340(ra) # 80006194 <uartputc_sync>
    80005c60:	bfe1                	j	80005c38 <consputc+0x18>

0000000080005c62 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005c62:	1101                	addi	sp,sp,-32
    80005c64:	ec06                	sd	ra,24(sp)
    80005c66:	e822                	sd	s0,16(sp)
    80005c68:	e426                	sd	s1,8(sp)
    80005c6a:	e04a                	sd	s2,0(sp)
    80005c6c:	1000                	addi	s0,sp,32
    80005c6e:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005c70:	0002e517          	auipc	a0,0x2e
    80005c74:	0d050513          	addi	a0,a0,208 # 80033d40 <cons>
    80005c78:	00000097          	auipc	ra,0x0
    80005c7c:	7b4080e7          	jalr	1972(ra) # 8000642c <acquire>

  switch(c){
    80005c80:	47d5                	li	a5,21
    80005c82:	0af48663          	beq	s1,a5,80005d2e <consoleintr+0xcc>
    80005c86:	0297ca63          	blt	a5,s1,80005cba <consoleintr+0x58>
    80005c8a:	47a1                	li	a5,8
    80005c8c:	0ef48763          	beq	s1,a5,80005d7a <consoleintr+0x118>
    80005c90:	47c1                	li	a5,16
    80005c92:	10f49a63          	bne	s1,a5,80005da6 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005c96:	ffffc097          	auipc	ra,0xffffc
    80005c9a:	d24080e7          	jalr	-732(ra) # 800019ba <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005c9e:	0002e517          	auipc	a0,0x2e
    80005ca2:	0a250513          	addi	a0,a0,162 # 80033d40 <cons>
    80005ca6:	00001097          	auipc	ra,0x1
    80005caa:	83a080e7          	jalr	-1990(ra) # 800064e0 <release>
}
    80005cae:	60e2                	ld	ra,24(sp)
    80005cb0:	6442                	ld	s0,16(sp)
    80005cb2:	64a2                	ld	s1,8(sp)
    80005cb4:	6902                	ld	s2,0(sp)
    80005cb6:	6105                	addi	sp,sp,32
    80005cb8:	8082                	ret
  switch(c){
    80005cba:	07f00793          	li	a5,127
    80005cbe:	0af48e63          	beq	s1,a5,80005d7a <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005cc2:	0002e717          	auipc	a4,0x2e
    80005cc6:	07e70713          	addi	a4,a4,126 # 80033d40 <cons>
    80005cca:	0a072783          	lw	a5,160(a4)
    80005cce:	09872703          	lw	a4,152(a4)
    80005cd2:	9f99                	subw	a5,a5,a4
    80005cd4:	07f00713          	li	a4,127
    80005cd8:	fcf763e3          	bltu	a4,a5,80005c9e <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005cdc:	47b5                	li	a5,13
    80005cde:	0cf48763          	beq	s1,a5,80005dac <consoleintr+0x14a>
      consputc(c);
    80005ce2:	8526                	mv	a0,s1
    80005ce4:	00000097          	auipc	ra,0x0
    80005ce8:	f3c080e7          	jalr	-196(ra) # 80005c20 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005cec:	0002e797          	auipc	a5,0x2e
    80005cf0:	05478793          	addi	a5,a5,84 # 80033d40 <cons>
    80005cf4:	0a07a683          	lw	a3,160(a5)
    80005cf8:	0016871b          	addiw	a4,a3,1
    80005cfc:	0007061b          	sext.w	a2,a4
    80005d00:	0ae7a023          	sw	a4,160(a5)
    80005d04:	07f6f693          	andi	a3,a3,127
    80005d08:	97b6                	add	a5,a5,a3
    80005d0a:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005d0e:	47a9                	li	a5,10
    80005d10:	0cf48563          	beq	s1,a5,80005dda <consoleintr+0x178>
    80005d14:	4791                	li	a5,4
    80005d16:	0cf48263          	beq	s1,a5,80005dda <consoleintr+0x178>
    80005d1a:	0002e797          	auipc	a5,0x2e
    80005d1e:	0be7a783          	lw	a5,190(a5) # 80033dd8 <cons+0x98>
    80005d22:	9f1d                	subw	a4,a4,a5
    80005d24:	08000793          	li	a5,128
    80005d28:	f6f71be3          	bne	a4,a5,80005c9e <consoleintr+0x3c>
    80005d2c:	a07d                	j	80005dda <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005d2e:	0002e717          	auipc	a4,0x2e
    80005d32:	01270713          	addi	a4,a4,18 # 80033d40 <cons>
    80005d36:	0a072783          	lw	a5,160(a4)
    80005d3a:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005d3e:	0002e497          	auipc	s1,0x2e
    80005d42:	00248493          	addi	s1,s1,2 # 80033d40 <cons>
    while(cons.e != cons.w &&
    80005d46:	4929                	li	s2,10
    80005d48:	f4f70be3          	beq	a4,a5,80005c9e <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005d4c:	37fd                	addiw	a5,a5,-1
    80005d4e:	07f7f713          	andi	a4,a5,127
    80005d52:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005d54:	01874703          	lbu	a4,24(a4)
    80005d58:	f52703e3          	beq	a4,s2,80005c9e <consoleintr+0x3c>
      cons.e--;
    80005d5c:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005d60:	10000513          	li	a0,256
    80005d64:	00000097          	auipc	ra,0x0
    80005d68:	ebc080e7          	jalr	-324(ra) # 80005c20 <consputc>
    while(cons.e != cons.w &&
    80005d6c:	0a04a783          	lw	a5,160(s1)
    80005d70:	09c4a703          	lw	a4,156(s1)
    80005d74:	fcf71ce3          	bne	a4,a5,80005d4c <consoleintr+0xea>
    80005d78:	b71d                	j	80005c9e <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005d7a:	0002e717          	auipc	a4,0x2e
    80005d7e:	fc670713          	addi	a4,a4,-58 # 80033d40 <cons>
    80005d82:	0a072783          	lw	a5,160(a4)
    80005d86:	09c72703          	lw	a4,156(a4)
    80005d8a:	f0f70ae3          	beq	a4,a5,80005c9e <consoleintr+0x3c>
      cons.e--;
    80005d8e:	37fd                	addiw	a5,a5,-1
    80005d90:	0002e717          	auipc	a4,0x2e
    80005d94:	04f72823          	sw	a5,80(a4) # 80033de0 <cons+0xa0>
      consputc(BACKSPACE);
    80005d98:	10000513          	li	a0,256
    80005d9c:	00000097          	auipc	ra,0x0
    80005da0:	e84080e7          	jalr	-380(ra) # 80005c20 <consputc>
    80005da4:	bded                	j	80005c9e <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005da6:	ee048ce3          	beqz	s1,80005c9e <consoleintr+0x3c>
    80005daa:	bf21                	j	80005cc2 <consoleintr+0x60>
      consputc(c);
    80005dac:	4529                	li	a0,10
    80005dae:	00000097          	auipc	ra,0x0
    80005db2:	e72080e7          	jalr	-398(ra) # 80005c20 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005db6:	0002e797          	auipc	a5,0x2e
    80005dba:	f8a78793          	addi	a5,a5,-118 # 80033d40 <cons>
    80005dbe:	0a07a703          	lw	a4,160(a5)
    80005dc2:	0017069b          	addiw	a3,a4,1
    80005dc6:	0006861b          	sext.w	a2,a3
    80005dca:	0ad7a023          	sw	a3,160(a5)
    80005dce:	07f77713          	andi	a4,a4,127
    80005dd2:	97ba                	add	a5,a5,a4
    80005dd4:	4729                	li	a4,10
    80005dd6:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005dda:	0002e797          	auipc	a5,0x2e
    80005dde:	00c7a123          	sw	a2,2(a5) # 80033ddc <cons+0x9c>
        wakeup(&cons.r);
    80005de2:	0002e517          	auipc	a0,0x2e
    80005de6:	ff650513          	addi	a0,a0,-10 # 80033dd8 <cons+0x98>
    80005dea:	ffffb097          	auipc	ra,0xffffb
    80005dee:	780080e7          	jalr	1920(ra) # 8000156a <wakeup>
    80005df2:	b575                	j	80005c9e <consoleintr+0x3c>

0000000080005df4 <consoleinit>:

void
consoleinit(void)
{
    80005df4:	1141                	addi	sp,sp,-16
    80005df6:	e406                	sd	ra,8(sp)
    80005df8:	e022                	sd	s0,0(sp)
    80005dfa:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005dfc:	00003597          	auipc	a1,0x3
    80005e00:	ab458593          	addi	a1,a1,-1356 # 800088b0 <syscalls+0x418>
    80005e04:	0002e517          	auipc	a0,0x2e
    80005e08:	f3c50513          	addi	a0,a0,-196 # 80033d40 <cons>
    80005e0c:	00000097          	auipc	ra,0x0
    80005e10:	590080e7          	jalr	1424(ra) # 8000639c <initlock>

  uartinit();
    80005e14:	00000097          	auipc	ra,0x0
    80005e18:	330080e7          	jalr	816(ra) # 80006144 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005e1c:	00025797          	auipc	a5,0x25
    80005e20:	c4c78793          	addi	a5,a5,-948 # 8002aa68 <devsw>
    80005e24:	00000717          	auipc	a4,0x0
    80005e28:	cde70713          	addi	a4,a4,-802 # 80005b02 <consoleread>
    80005e2c:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005e2e:	00000717          	auipc	a4,0x0
    80005e32:	c7270713          	addi	a4,a4,-910 # 80005aa0 <consolewrite>
    80005e36:	ef98                	sd	a4,24(a5)
}
    80005e38:	60a2                	ld	ra,8(sp)
    80005e3a:	6402                	ld	s0,0(sp)
    80005e3c:	0141                	addi	sp,sp,16
    80005e3e:	8082                	ret

0000000080005e40 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005e40:	7179                	addi	sp,sp,-48
    80005e42:	f406                	sd	ra,40(sp)
    80005e44:	f022                	sd	s0,32(sp)
    80005e46:	ec26                	sd	s1,24(sp)
    80005e48:	e84a                	sd	s2,16(sp)
    80005e4a:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005e4c:	c219                	beqz	a2,80005e52 <printint+0x12>
    80005e4e:	08054663          	bltz	a0,80005eda <printint+0x9a>
    x = -xx;
  else
    x = xx;
    80005e52:	2501                	sext.w	a0,a0
    80005e54:	4881                	li	a7,0
    80005e56:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005e5a:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005e5c:	2581                	sext.w	a1,a1
    80005e5e:	00003617          	auipc	a2,0x3
    80005e62:	a8260613          	addi	a2,a2,-1406 # 800088e0 <digits>
    80005e66:	883a                	mv	a6,a4
    80005e68:	2705                	addiw	a4,a4,1
    80005e6a:	02b577bb          	remuw	a5,a0,a1
    80005e6e:	1782                	slli	a5,a5,0x20
    80005e70:	9381                	srli	a5,a5,0x20
    80005e72:	97b2                	add	a5,a5,a2
    80005e74:	0007c783          	lbu	a5,0(a5)
    80005e78:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005e7c:	0005079b          	sext.w	a5,a0
    80005e80:	02b5553b          	divuw	a0,a0,a1
    80005e84:	0685                	addi	a3,a3,1
    80005e86:	feb7f0e3          	bgeu	a5,a1,80005e66 <printint+0x26>

  if(sign)
    80005e8a:	00088b63          	beqz	a7,80005ea0 <printint+0x60>
    buf[i++] = '-';
    80005e8e:	fe040793          	addi	a5,s0,-32
    80005e92:	973e                	add	a4,a4,a5
    80005e94:	02d00793          	li	a5,45
    80005e98:	fef70823          	sb	a5,-16(a4)
    80005e9c:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005ea0:	02e05763          	blez	a4,80005ece <printint+0x8e>
    80005ea4:	fd040793          	addi	a5,s0,-48
    80005ea8:	00e784b3          	add	s1,a5,a4
    80005eac:	fff78913          	addi	s2,a5,-1
    80005eb0:	993a                	add	s2,s2,a4
    80005eb2:	377d                	addiw	a4,a4,-1
    80005eb4:	1702                	slli	a4,a4,0x20
    80005eb6:	9301                	srli	a4,a4,0x20
    80005eb8:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005ebc:	fff4c503          	lbu	a0,-1(s1)
    80005ec0:	00000097          	auipc	ra,0x0
    80005ec4:	d60080e7          	jalr	-672(ra) # 80005c20 <consputc>
  while(--i >= 0)
    80005ec8:	14fd                	addi	s1,s1,-1
    80005eca:	ff2499e3          	bne	s1,s2,80005ebc <printint+0x7c>
}
    80005ece:	70a2                	ld	ra,40(sp)
    80005ed0:	7402                	ld	s0,32(sp)
    80005ed2:	64e2                	ld	s1,24(sp)
    80005ed4:	6942                	ld	s2,16(sp)
    80005ed6:	6145                	addi	sp,sp,48
    80005ed8:	8082                	ret
    x = -xx;
    80005eda:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005ede:	4885                	li	a7,1
    x = -xx;
    80005ee0:	bf9d                	j	80005e56 <printint+0x16>

0000000080005ee2 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005ee2:	1101                	addi	sp,sp,-32
    80005ee4:	ec06                	sd	ra,24(sp)
    80005ee6:	e822                	sd	s0,16(sp)
    80005ee8:	e426                	sd	s1,8(sp)
    80005eea:	1000                	addi	s0,sp,32
    80005eec:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005eee:	0002e797          	auipc	a5,0x2e
    80005ef2:	f007a923          	sw	zero,-238(a5) # 80033e00 <pr+0x18>
  printf("panic: ");
    80005ef6:	00003517          	auipc	a0,0x3
    80005efa:	9c250513          	addi	a0,a0,-1598 # 800088b8 <syscalls+0x420>
    80005efe:	00000097          	auipc	ra,0x0
    80005f02:	02e080e7          	jalr	46(ra) # 80005f2c <printf>
  printf(s);
    80005f06:	8526                	mv	a0,s1
    80005f08:	00000097          	auipc	ra,0x0
    80005f0c:	024080e7          	jalr	36(ra) # 80005f2c <printf>
  printf("\n");
    80005f10:	00002517          	auipc	a0,0x2
    80005f14:	44850513          	addi	a0,a0,1096 # 80008358 <states.1738+0x118>
    80005f18:	00000097          	auipc	ra,0x0
    80005f1c:	014080e7          	jalr	20(ra) # 80005f2c <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005f20:	4785                	li	a5,1
    80005f22:	00003717          	auipc	a4,0x3
    80005f26:	a8f72d23          	sw	a5,-1382(a4) # 800089bc <panicked>
  for(;;)
    80005f2a:	a001                	j	80005f2a <panic+0x48>

0000000080005f2c <printf>:
{
    80005f2c:	7131                	addi	sp,sp,-192
    80005f2e:	fc86                	sd	ra,120(sp)
    80005f30:	f8a2                	sd	s0,112(sp)
    80005f32:	f4a6                	sd	s1,104(sp)
    80005f34:	f0ca                	sd	s2,96(sp)
    80005f36:	ecce                	sd	s3,88(sp)
    80005f38:	e8d2                	sd	s4,80(sp)
    80005f3a:	e4d6                	sd	s5,72(sp)
    80005f3c:	e0da                	sd	s6,64(sp)
    80005f3e:	fc5e                	sd	s7,56(sp)
    80005f40:	f862                	sd	s8,48(sp)
    80005f42:	f466                	sd	s9,40(sp)
    80005f44:	f06a                	sd	s10,32(sp)
    80005f46:	ec6e                	sd	s11,24(sp)
    80005f48:	0100                	addi	s0,sp,128
    80005f4a:	8a2a                	mv	s4,a0
    80005f4c:	e40c                	sd	a1,8(s0)
    80005f4e:	e810                	sd	a2,16(s0)
    80005f50:	ec14                	sd	a3,24(s0)
    80005f52:	f018                	sd	a4,32(s0)
    80005f54:	f41c                	sd	a5,40(s0)
    80005f56:	03043823          	sd	a6,48(s0)
    80005f5a:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005f5e:	0002ed97          	auipc	s11,0x2e
    80005f62:	ea2dad83          	lw	s11,-350(s11) # 80033e00 <pr+0x18>
  if(locking)
    80005f66:	020d9b63          	bnez	s11,80005f9c <printf+0x70>
  if (fmt == 0)
    80005f6a:	040a0263          	beqz	s4,80005fae <printf+0x82>
  va_start(ap, fmt);
    80005f6e:	00840793          	addi	a5,s0,8
    80005f72:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005f76:	000a4503          	lbu	a0,0(s4)
    80005f7a:	16050263          	beqz	a0,800060de <printf+0x1b2>
    80005f7e:	4481                	li	s1,0
    if(c != '%'){
    80005f80:	02500a93          	li	s5,37
    switch(c){
    80005f84:	07000b13          	li	s6,112
  consputc('x');
    80005f88:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80005f8a:	00003b97          	auipc	s7,0x3
    80005f8e:	956b8b93          	addi	s7,s7,-1706 # 800088e0 <digits>
    switch(c){
    80005f92:	07300c93          	li	s9,115
    80005f96:	06400c13          	li	s8,100
    80005f9a:	a82d                	j	80005fd4 <printf+0xa8>
    acquire(&pr.lock);
    80005f9c:	0002e517          	auipc	a0,0x2e
    80005fa0:	e4c50513          	addi	a0,a0,-436 # 80033de8 <pr>
    80005fa4:	00000097          	auipc	ra,0x0
    80005fa8:	488080e7          	jalr	1160(ra) # 8000642c <acquire>
    80005fac:	bf7d                	j	80005f6a <printf+0x3e>
    panic("null fmt");
    80005fae:	00003517          	auipc	a0,0x3
    80005fb2:	91a50513          	addi	a0,a0,-1766 # 800088c8 <syscalls+0x430>
    80005fb6:	00000097          	auipc	ra,0x0
    80005fba:	f2c080e7          	jalr	-212(ra) # 80005ee2 <panic>
      consputc(c);
    80005fbe:	00000097          	auipc	ra,0x0
    80005fc2:	c62080e7          	jalr	-926(ra) # 80005c20 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80005fc6:	2485                	addiw	s1,s1,1
    80005fc8:	009a07b3          	add	a5,s4,s1
    80005fcc:	0007c503          	lbu	a0,0(a5)
    80005fd0:	10050763          	beqz	a0,800060de <printf+0x1b2>
    if(c != '%'){
    80005fd4:	ff5515e3          	bne	a0,s5,80005fbe <printf+0x92>
    c = fmt[++i] & 0xff;
    80005fd8:	2485                	addiw	s1,s1,1
    80005fda:	009a07b3          	add	a5,s4,s1
    80005fde:	0007c783          	lbu	a5,0(a5)
    80005fe2:	0007891b          	sext.w	s2,a5
    if(c == 0)
    80005fe6:	cfe5                	beqz	a5,800060de <printf+0x1b2>
    switch(c){
    80005fe8:	05678a63          	beq	a5,s6,8000603c <printf+0x110>
    80005fec:	02fb7663          	bgeu	s6,a5,80006018 <printf+0xec>
    80005ff0:	09978963          	beq	a5,s9,80006082 <printf+0x156>
    80005ff4:	07800713          	li	a4,120
    80005ff8:	0ce79863          	bne	a5,a4,800060c8 <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    80005ffc:	f8843783          	ld	a5,-120(s0)
    80006000:	00878713          	addi	a4,a5,8
    80006004:	f8e43423          	sd	a4,-120(s0)
    80006008:	4605                	li	a2,1
    8000600a:	85ea                	mv	a1,s10
    8000600c:	4388                	lw	a0,0(a5)
    8000600e:	00000097          	auipc	ra,0x0
    80006012:	e32080e7          	jalr	-462(ra) # 80005e40 <printint>
      break;
    80006016:	bf45                	j	80005fc6 <printf+0x9a>
    switch(c){
    80006018:	0b578263          	beq	a5,s5,800060bc <printf+0x190>
    8000601c:	0b879663          	bne	a5,s8,800060c8 <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    80006020:	f8843783          	ld	a5,-120(s0)
    80006024:	00878713          	addi	a4,a5,8
    80006028:	f8e43423          	sd	a4,-120(s0)
    8000602c:	4605                	li	a2,1
    8000602e:	45a9                	li	a1,10
    80006030:	4388                	lw	a0,0(a5)
    80006032:	00000097          	auipc	ra,0x0
    80006036:	e0e080e7          	jalr	-498(ra) # 80005e40 <printint>
      break;
    8000603a:	b771                	j	80005fc6 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    8000603c:	f8843783          	ld	a5,-120(s0)
    80006040:	00878713          	addi	a4,a5,8
    80006044:	f8e43423          	sd	a4,-120(s0)
    80006048:	0007b983          	ld	s3,0(a5)
  consputc('0');
    8000604c:	03000513          	li	a0,48
    80006050:	00000097          	auipc	ra,0x0
    80006054:	bd0080e7          	jalr	-1072(ra) # 80005c20 <consputc>
  consputc('x');
    80006058:	07800513          	li	a0,120
    8000605c:	00000097          	auipc	ra,0x0
    80006060:	bc4080e7          	jalr	-1084(ra) # 80005c20 <consputc>
    80006064:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80006066:	03c9d793          	srli	a5,s3,0x3c
    8000606a:	97de                	add	a5,a5,s7
    8000606c:	0007c503          	lbu	a0,0(a5)
    80006070:	00000097          	auipc	ra,0x0
    80006074:	bb0080e7          	jalr	-1104(ra) # 80005c20 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80006078:	0992                	slli	s3,s3,0x4
    8000607a:	397d                	addiw	s2,s2,-1
    8000607c:	fe0915e3          	bnez	s2,80006066 <printf+0x13a>
    80006080:	b799                	j	80005fc6 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80006082:	f8843783          	ld	a5,-120(s0)
    80006086:	00878713          	addi	a4,a5,8
    8000608a:	f8e43423          	sd	a4,-120(s0)
    8000608e:	0007b903          	ld	s2,0(a5)
    80006092:	00090e63          	beqz	s2,800060ae <printf+0x182>
      for(; *s; s++)
    80006096:	00094503          	lbu	a0,0(s2)
    8000609a:	d515                	beqz	a0,80005fc6 <printf+0x9a>
        consputc(*s);
    8000609c:	00000097          	auipc	ra,0x0
    800060a0:	b84080e7          	jalr	-1148(ra) # 80005c20 <consputc>
      for(; *s; s++)
    800060a4:	0905                	addi	s2,s2,1
    800060a6:	00094503          	lbu	a0,0(s2)
    800060aa:	f96d                	bnez	a0,8000609c <printf+0x170>
    800060ac:	bf29                	j	80005fc6 <printf+0x9a>
        s = "(null)";
    800060ae:	00003917          	auipc	s2,0x3
    800060b2:	81290913          	addi	s2,s2,-2030 # 800088c0 <syscalls+0x428>
      for(; *s; s++)
    800060b6:	02800513          	li	a0,40
    800060ba:	b7cd                	j	8000609c <printf+0x170>
      consputc('%');
    800060bc:	8556                	mv	a0,s5
    800060be:	00000097          	auipc	ra,0x0
    800060c2:	b62080e7          	jalr	-1182(ra) # 80005c20 <consputc>
      break;
    800060c6:	b701                	j	80005fc6 <printf+0x9a>
      consputc('%');
    800060c8:	8556                	mv	a0,s5
    800060ca:	00000097          	auipc	ra,0x0
    800060ce:	b56080e7          	jalr	-1194(ra) # 80005c20 <consputc>
      consputc(c);
    800060d2:	854a                	mv	a0,s2
    800060d4:	00000097          	auipc	ra,0x0
    800060d8:	b4c080e7          	jalr	-1204(ra) # 80005c20 <consputc>
      break;
    800060dc:	b5ed                	j	80005fc6 <printf+0x9a>
  if(locking)
    800060de:	020d9163          	bnez	s11,80006100 <printf+0x1d4>
}
    800060e2:	70e6                	ld	ra,120(sp)
    800060e4:	7446                	ld	s0,112(sp)
    800060e6:	74a6                	ld	s1,104(sp)
    800060e8:	7906                	ld	s2,96(sp)
    800060ea:	69e6                	ld	s3,88(sp)
    800060ec:	6a46                	ld	s4,80(sp)
    800060ee:	6aa6                	ld	s5,72(sp)
    800060f0:	6b06                	ld	s6,64(sp)
    800060f2:	7be2                	ld	s7,56(sp)
    800060f4:	7c42                	ld	s8,48(sp)
    800060f6:	7ca2                	ld	s9,40(sp)
    800060f8:	7d02                	ld	s10,32(sp)
    800060fa:	6de2                	ld	s11,24(sp)
    800060fc:	6129                	addi	sp,sp,192
    800060fe:	8082                	ret
    release(&pr.lock);
    80006100:	0002e517          	auipc	a0,0x2e
    80006104:	ce850513          	addi	a0,a0,-792 # 80033de8 <pr>
    80006108:	00000097          	auipc	ra,0x0
    8000610c:	3d8080e7          	jalr	984(ra) # 800064e0 <release>
}
    80006110:	bfc9                	j	800060e2 <printf+0x1b6>

0000000080006112 <printfinit>:
    ;
}

void
printfinit(void)
{
    80006112:	1101                	addi	sp,sp,-32
    80006114:	ec06                	sd	ra,24(sp)
    80006116:	e822                	sd	s0,16(sp)
    80006118:	e426                	sd	s1,8(sp)
    8000611a:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    8000611c:	0002e497          	auipc	s1,0x2e
    80006120:	ccc48493          	addi	s1,s1,-820 # 80033de8 <pr>
    80006124:	00002597          	auipc	a1,0x2
    80006128:	7b458593          	addi	a1,a1,1972 # 800088d8 <syscalls+0x440>
    8000612c:	8526                	mv	a0,s1
    8000612e:	00000097          	auipc	ra,0x0
    80006132:	26e080e7          	jalr	622(ra) # 8000639c <initlock>
  pr.locking = 1;
    80006136:	4785                	li	a5,1
    80006138:	cc9c                	sw	a5,24(s1)
}
    8000613a:	60e2                	ld	ra,24(sp)
    8000613c:	6442                	ld	s0,16(sp)
    8000613e:	64a2                	ld	s1,8(sp)
    80006140:	6105                	addi	sp,sp,32
    80006142:	8082                	ret

0000000080006144 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80006144:	1141                	addi	sp,sp,-16
    80006146:	e406                	sd	ra,8(sp)
    80006148:	e022                	sd	s0,0(sp)
    8000614a:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    8000614c:	100007b7          	lui	a5,0x10000
    80006150:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80006154:	f8000713          	li	a4,-128
    80006158:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    8000615c:	470d                	li	a4,3
    8000615e:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80006162:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80006166:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    8000616a:	469d                	li	a3,7
    8000616c:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80006170:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80006174:	00002597          	auipc	a1,0x2
    80006178:	78458593          	addi	a1,a1,1924 # 800088f8 <digits+0x18>
    8000617c:	0002e517          	auipc	a0,0x2e
    80006180:	c8c50513          	addi	a0,a0,-884 # 80033e08 <uart_tx_lock>
    80006184:	00000097          	auipc	ra,0x0
    80006188:	218080e7          	jalr	536(ra) # 8000639c <initlock>
}
    8000618c:	60a2                	ld	ra,8(sp)
    8000618e:	6402                	ld	s0,0(sp)
    80006190:	0141                	addi	sp,sp,16
    80006192:	8082                	ret

0000000080006194 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80006194:	1101                	addi	sp,sp,-32
    80006196:	ec06                	sd	ra,24(sp)
    80006198:	e822                	sd	s0,16(sp)
    8000619a:	e426                	sd	s1,8(sp)
    8000619c:	1000                	addi	s0,sp,32
    8000619e:	84aa                	mv	s1,a0
  push_off();
    800061a0:	00000097          	auipc	ra,0x0
    800061a4:	240080e7          	jalr	576(ra) # 800063e0 <push_off>

  if(panicked){
    800061a8:	00003797          	auipc	a5,0x3
    800061ac:	8147a783          	lw	a5,-2028(a5) # 800089bc <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800061b0:	10000737          	lui	a4,0x10000
  if(panicked){
    800061b4:	c391                	beqz	a5,800061b8 <uartputc_sync+0x24>
    for(;;)
    800061b6:	a001                	j	800061b6 <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800061b8:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    800061bc:	0ff7f793          	andi	a5,a5,255
    800061c0:	0207f793          	andi	a5,a5,32
    800061c4:	dbf5                	beqz	a5,800061b8 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    800061c6:	0ff4f793          	andi	a5,s1,255
    800061ca:	10000737          	lui	a4,0x10000
    800061ce:	00f70023          	sb	a5,0(a4) # 10000000 <_entry-0x70000000>

  pop_off();
    800061d2:	00000097          	auipc	ra,0x0
    800061d6:	2ae080e7          	jalr	686(ra) # 80006480 <pop_off>
}
    800061da:	60e2                	ld	ra,24(sp)
    800061dc:	6442                	ld	s0,16(sp)
    800061de:	64a2                	ld	s1,8(sp)
    800061e0:	6105                	addi	sp,sp,32
    800061e2:	8082                	ret

00000000800061e4 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    800061e4:	00002717          	auipc	a4,0x2
    800061e8:	7dc73703          	ld	a4,2012(a4) # 800089c0 <uart_tx_r>
    800061ec:	00002797          	auipc	a5,0x2
    800061f0:	7dc7b783          	ld	a5,2012(a5) # 800089c8 <uart_tx_w>
    800061f4:	06e78c63          	beq	a5,a4,8000626c <uartstart+0x88>
{
    800061f8:	7139                	addi	sp,sp,-64
    800061fa:	fc06                	sd	ra,56(sp)
    800061fc:	f822                	sd	s0,48(sp)
    800061fe:	f426                	sd	s1,40(sp)
    80006200:	f04a                	sd	s2,32(sp)
    80006202:	ec4e                	sd	s3,24(sp)
    80006204:	e852                	sd	s4,16(sp)
    80006206:	e456                	sd	s5,8(sp)
    80006208:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    8000620a:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    8000620e:	0002ea17          	auipc	s4,0x2e
    80006212:	bfaa0a13          	addi	s4,s4,-1030 # 80033e08 <uart_tx_lock>
    uart_tx_r += 1;
    80006216:	00002497          	auipc	s1,0x2
    8000621a:	7aa48493          	addi	s1,s1,1962 # 800089c0 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    8000621e:	00002997          	auipc	s3,0x2
    80006222:	7aa98993          	addi	s3,s3,1962 # 800089c8 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006226:	00594783          	lbu	a5,5(s2) # 10000005 <_entry-0x6ffffffb>
    8000622a:	0ff7f793          	andi	a5,a5,255
    8000622e:	0207f793          	andi	a5,a5,32
    80006232:	c785                	beqz	a5,8000625a <uartstart+0x76>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006234:	01f77793          	andi	a5,a4,31
    80006238:	97d2                	add	a5,a5,s4
    8000623a:	0187ca83          	lbu	s5,24(a5)
    uart_tx_r += 1;
    8000623e:	0705                	addi	a4,a4,1
    80006240:	e098                	sd	a4,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80006242:	8526                	mv	a0,s1
    80006244:	ffffb097          	auipc	ra,0xffffb
    80006248:	326080e7          	jalr	806(ra) # 8000156a <wakeup>
    
    WriteReg(THR, c);
    8000624c:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80006250:	6098                	ld	a4,0(s1)
    80006252:	0009b783          	ld	a5,0(s3)
    80006256:	fce798e3          	bne	a5,a4,80006226 <uartstart+0x42>
  }
}
    8000625a:	70e2                	ld	ra,56(sp)
    8000625c:	7442                	ld	s0,48(sp)
    8000625e:	74a2                	ld	s1,40(sp)
    80006260:	7902                	ld	s2,32(sp)
    80006262:	69e2                	ld	s3,24(sp)
    80006264:	6a42                	ld	s4,16(sp)
    80006266:	6aa2                	ld	s5,8(sp)
    80006268:	6121                	addi	sp,sp,64
    8000626a:	8082                	ret
    8000626c:	8082                	ret

000000008000626e <uartputc>:
{
    8000626e:	7179                	addi	sp,sp,-48
    80006270:	f406                	sd	ra,40(sp)
    80006272:	f022                	sd	s0,32(sp)
    80006274:	ec26                	sd	s1,24(sp)
    80006276:	e84a                	sd	s2,16(sp)
    80006278:	e44e                	sd	s3,8(sp)
    8000627a:	e052                	sd	s4,0(sp)
    8000627c:	1800                	addi	s0,sp,48
    8000627e:	89aa                	mv	s3,a0
  acquire(&uart_tx_lock);
    80006280:	0002e517          	auipc	a0,0x2e
    80006284:	b8850513          	addi	a0,a0,-1144 # 80033e08 <uart_tx_lock>
    80006288:	00000097          	auipc	ra,0x0
    8000628c:	1a4080e7          	jalr	420(ra) # 8000642c <acquire>
  if(panicked){
    80006290:	00002797          	auipc	a5,0x2
    80006294:	72c7a783          	lw	a5,1836(a5) # 800089bc <panicked>
    80006298:	e7c9                	bnez	a5,80006322 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000629a:	00002797          	auipc	a5,0x2
    8000629e:	72e7b783          	ld	a5,1838(a5) # 800089c8 <uart_tx_w>
    800062a2:	00002717          	auipc	a4,0x2
    800062a6:	71e73703          	ld	a4,1822(a4) # 800089c0 <uart_tx_r>
    800062aa:	02070713          	addi	a4,a4,32
    sleep(&uart_tx_r, &uart_tx_lock);
    800062ae:	0002ea17          	auipc	s4,0x2e
    800062b2:	b5aa0a13          	addi	s4,s4,-1190 # 80033e08 <uart_tx_lock>
    800062b6:	00002497          	auipc	s1,0x2
    800062ba:	70a48493          	addi	s1,s1,1802 # 800089c0 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800062be:	00002917          	auipc	s2,0x2
    800062c2:	70a90913          	addi	s2,s2,1802 # 800089c8 <uart_tx_w>
    800062c6:	00f71f63          	bne	a4,a5,800062e4 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    800062ca:	85d2                	mv	a1,s4
    800062cc:	8526                	mv	a0,s1
    800062ce:	ffffb097          	auipc	ra,0xffffb
    800062d2:	238080e7          	jalr	568(ra) # 80001506 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800062d6:	00093783          	ld	a5,0(s2)
    800062da:	6098                	ld	a4,0(s1)
    800062dc:	02070713          	addi	a4,a4,32
    800062e0:	fef705e3          	beq	a4,a5,800062ca <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800062e4:	0002e497          	auipc	s1,0x2e
    800062e8:	b2448493          	addi	s1,s1,-1244 # 80033e08 <uart_tx_lock>
    800062ec:	01f7f713          	andi	a4,a5,31
    800062f0:	9726                	add	a4,a4,s1
    800062f2:	01370c23          	sb	s3,24(a4)
  uart_tx_w += 1;
    800062f6:	0785                	addi	a5,a5,1
    800062f8:	00002717          	auipc	a4,0x2
    800062fc:	6cf73823          	sd	a5,1744(a4) # 800089c8 <uart_tx_w>
  uartstart();
    80006300:	00000097          	auipc	ra,0x0
    80006304:	ee4080e7          	jalr	-284(ra) # 800061e4 <uartstart>
  release(&uart_tx_lock);
    80006308:	8526                	mv	a0,s1
    8000630a:	00000097          	auipc	ra,0x0
    8000630e:	1d6080e7          	jalr	470(ra) # 800064e0 <release>
}
    80006312:	70a2                	ld	ra,40(sp)
    80006314:	7402                	ld	s0,32(sp)
    80006316:	64e2                	ld	s1,24(sp)
    80006318:	6942                	ld	s2,16(sp)
    8000631a:	69a2                	ld	s3,8(sp)
    8000631c:	6a02                	ld	s4,0(sp)
    8000631e:	6145                	addi	sp,sp,48
    80006320:	8082                	ret
    for(;;)
    80006322:	a001                	j	80006322 <uartputc+0xb4>

0000000080006324 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80006324:	1141                	addi	sp,sp,-16
    80006326:	e422                	sd	s0,8(sp)
    80006328:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    8000632a:	100007b7          	lui	a5,0x10000
    8000632e:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80006332:	8b85                	andi	a5,a5,1
    80006334:	cb91                	beqz	a5,80006348 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    80006336:	100007b7          	lui	a5,0x10000
    8000633a:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    8000633e:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    80006342:	6422                	ld	s0,8(sp)
    80006344:	0141                	addi	sp,sp,16
    80006346:	8082                	ret
    return -1;
    80006348:	557d                	li	a0,-1
    8000634a:	bfe5                	j	80006342 <uartgetc+0x1e>

000000008000634c <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    8000634c:	1101                	addi	sp,sp,-32
    8000634e:	ec06                	sd	ra,24(sp)
    80006350:	e822                	sd	s0,16(sp)
    80006352:	e426                	sd	s1,8(sp)
    80006354:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80006356:	54fd                	li	s1,-1
    int c = uartgetc();
    80006358:	00000097          	auipc	ra,0x0
    8000635c:	fcc080e7          	jalr	-52(ra) # 80006324 <uartgetc>
    if(c == -1)
    80006360:	00950763          	beq	a0,s1,8000636e <uartintr+0x22>
      break;
    consoleintr(c);
    80006364:	00000097          	auipc	ra,0x0
    80006368:	8fe080e7          	jalr	-1794(ra) # 80005c62 <consoleintr>
  while(1){
    8000636c:	b7f5                	j	80006358 <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    8000636e:	0002e497          	auipc	s1,0x2e
    80006372:	a9a48493          	addi	s1,s1,-1382 # 80033e08 <uart_tx_lock>
    80006376:	8526                	mv	a0,s1
    80006378:	00000097          	auipc	ra,0x0
    8000637c:	0b4080e7          	jalr	180(ra) # 8000642c <acquire>
  uartstart();
    80006380:	00000097          	auipc	ra,0x0
    80006384:	e64080e7          	jalr	-412(ra) # 800061e4 <uartstart>
  release(&uart_tx_lock);
    80006388:	8526                	mv	a0,s1
    8000638a:	00000097          	auipc	ra,0x0
    8000638e:	156080e7          	jalr	342(ra) # 800064e0 <release>
}
    80006392:	60e2                	ld	ra,24(sp)
    80006394:	6442                	ld	s0,16(sp)
    80006396:	64a2                	ld	s1,8(sp)
    80006398:	6105                	addi	sp,sp,32
    8000639a:	8082                	ret

000000008000639c <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    8000639c:	1141                	addi	sp,sp,-16
    8000639e:	e422                	sd	s0,8(sp)
    800063a0:	0800                	addi	s0,sp,16
  lk->name = name;
    800063a2:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    800063a4:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    800063a8:	00053823          	sd	zero,16(a0)
}
    800063ac:	6422                	ld	s0,8(sp)
    800063ae:	0141                	addi	sp,sp,16
    800063b0:	8082                	ret

00000000800063b2 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    800063b2:	411c                	lw	a5,0(a0)
    800063b4:	e399                	bnez	a5,800063ba <holding+0x8>
    800063b6:	4501                	li	a0,0
  return r;
}
    800063b8:	8082                	ret
{
    800063ba:	1101                	addi	sp,sp,-32
    800063bc:	ec06                	sd	ra,24(sp)
    800063be:	e822                	sd	s0,16(sp)
    800063c0:	e426                	sd	s1,8(sp)
    800063c2:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    800063c4:	6904                	ld	s1,16(a0)
    800063c6:	ffffb097          	auipc	ra,0xffffb
    800063ca:	a80080e7          	jalr	-1408(ra) # 80000e46 <mycpu>
    800063ce:	40a48533          	sub	a0,s1,a0
    800063d2:	00153513          	seqz	a0,a0
}
    800063d6:	60e2                	ld	ra,24(sp)
    800063d8:	6442                	ld	s0,16(sp)
    800063da:	64a2                	ld	s1,8(sp)
    800063dc:	6105                	addi	sp,sp,32
    800063de:	8082                	ret

00000000800063e0 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    800063e0:	1101                	addi	sp,sp,-32
    800063e2:	ec06                	sd	ra,24(sp)
    800063e4:	e822                	sd	s0,16(sp)
    800063e6:	e426                	sd	s1,8(sp)
    800063e8:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800063ea:	100024f3          	csrr	s1,sstatus
    800063ee:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800063f2:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800063f4:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    800063f8:	ffffb097          	auipc	ra,0xffffb
    800063fc:	a4e080e7          	jalr	-1458(ra) # 80000e46 <mycpu>
    80006400:	5d3c                	lw	a5,120(a0)
    80006402:	cf89                	beqz	a5,8000641c <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    80006404:	ffffb097          	auipc	ra,0xffffb
    80006408:	a42080e7          	jalr	-1470(ra) # 80000e46 <mycpu>
    8000640c:	5d3c                	lw	a5,120(a0)
    8000640e:	2785                	addiw	a5,a5,1
    80006410:	dd3c                	sw	a5,120(a0)
}
    80006412:	60e2                	ld	ra,24(sp)
    80006414:	6442                	ld	s0,16(sp)
    80006416:	64a2                	ld	s1,8(sp)
    80006418:	6105                	addi	sp,sp,32
    8000641a:	8082                	ret
    mycpu()->intena = old;
    8000641c:	ffffb097          	auipc	ra,0xffffb
    80006420:	a2a080e7          	jalr	-1494(ra) # 80000e46 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80006424:	8085                	srli	s1,s1,0x1
    80006426:	8885                	andi	s1,s1,1
    80006428:	dd64                	sw	s1,124(a0)
    8000642a:	bfe9                	j	80006404 <push_off+0x24>

000000008000642c <acquire>:
{
    8000642c:	1101                	addi	sp,sp,-32
    8000642e:	ec06                	sd	ra,24(sp)
    80006430:	e822                	sd	s0,16(sp)
    80006432:	e426                	sd	s1,8(sp)
    80006434:	1000                	addi	s0,sp,32
    80006436:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80006438:	00000097          	auipc	ra,0x0
    8000643c:	fa8080e7          	jalr	-88(ra) # 800063e0 <push_off>
  if(holding(lk))
    80006440:	8526                	mv	a0,s1
    80006442:	00000097          	auipc	ra,0x0
    80006446:	f70080e7          	jalr	-144(ra) # 800063b2 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000644a:	4705                	li	a4,1
  if(holding(lk))
    8000644c:	e115                	bnez	a0,80006470 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000644e:	87ba                	mv	a5,a4
    80006450:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80006454:	2781                	sext.w	a5,a5
    80006456:	ffe5                	bnez	a5,8000644e <acquire+0x22>
  __sync_synchronize();
    80006458:	0ff0000f          	fence
  lk->cpu = mycpu();
    8000645c:	ffffb097          	auipc	ra,0xffffb
    80006460:	9ea080e7          	jalr	-1558(ra) # 80000e46 <mycpu>
    80006464:	e888                	sd	a0,16(s1)
}
    80006466:	60e2                	ld	ra,24(sp)
    80006468:	6442                	ld	s0,16(sp)
    8000646a:	64a2                	ld	s1,8(sp)
    8000646c:	6105                	addi	sp,sp,32
    8000646e:	8082                	ret
    panic("acquire");
    80006470:	00002517          	auipc	a0,0x2
    80006474:	49050513          	addi	a0,a0,1168 # 80008900 <digits+0x20>
    80006478:	00000097          	auipc	ra,0x0
    8000647c:	a6a080e7          	jalr	-1430(ra) # 80005ee2 <panic>

0000000080006480 <pop_off>:

void
pop_off(void)
{
    80006480:	1141                	addi	sp,sp,-16
    80006482:	e406                	sd	ra,8(sp)
    80006484:	e022                	sd	s0,0(sp)
    80006486:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80006488:	ffffb097          	auipc	ra,0xffffb
    8000648c:	9be080e7          	jalr	-1602(ra) # 80000e46 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006490:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80006494:	8b89                	andi	a5,a5,2
  if(intr_get())
    80006496:	e78d                	bnez	a5,800064c0 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80006498:	5d3c                	lw	a5,120(a0)
    8000649a:	02f05b63          	blez	a5,800064d0 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    8000649e:	37fd                	addiw	a5,a5,-1
    800064a0:	0007871b          	sext.w	a4,a5
    800064a4:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    800064a6:	eb09                	bnez	a4,800064b8 <pop_off+0x38>
    800064a8:	5d7c                	lw	a5,124(a0)
    800064aa:	c799                	beqz	a5,800064b8 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800064ac:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800064b0:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800064b4:	10079073          	csrw	sstatus,a5
    intr_on();
}
    800064b8:	60a2                	ld	ra,8(sp)
    800064ba:	6402                	ld	s0,0(sp)
    800064bc:	0141                	addi	sp,sp,16
    800064be:	8082                	ret
    panic("pop_off - interruptible");
    800064c0:	00002517          	auipc	a0,0x2
    800064c4:	44850513          	addi	a0,a0,1096 # 80008908 <digits+0x28>
    800064c8:	00000097          	auipc	ra,0x0
    800064cc:	a1a080e7          	jalr	-1510(ra) # 80005ee2 <panic>
    panic("pop_off");
    800064d0:	00002517          	auipc	a0,0x2
    800064d4:	45050513          	addi	a0,a0,1104 # 80008920 <digits+0x40>
    800064d8:	00000097          	auipc	ra,0x0
    800064dc:	a0a080e7          	jalr	-1526(ra) # 80005ee2 <panic>

00000000800064e0 <release>:
{
    800064e0:	1101                	addi	sp,sp,-32
    800064e2:	ec06                	sd	ra,24(sp)
    800064e4:	e822                	sd	s0,16(sp)
    800064e6:	e426                	sd	s1,8(sp)
    800064e8:	1000                	addi	s0,sp,32
    800064ea:	84aa                	mv	s1,a0
  if(!holding(lk))
    800064ec:	00000097          	auipc	ra,0x0
    800064f0:	ec6080e7          	jalr	-314(ra) # 800063b2 <holding>
    800064f4:	c115                	beqz	a0,80006518 <release+0x38>
  lk->cpu = 0;
    800064f6:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800064fa:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    800064fe:	0f50000f          	fence	iorw,ow
    80006502:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    80006506:	00000097          	auipc	ra,0x0
    8000650a:	f7a080e7          	jalr	-134(ra) # 80006480 <pop_off>
}
    8000650e:	60e2                	ld	ra,24(sp)
    80006510:	6442                	ld	s0,16(sp)
    80006512:	64a2                	ld	s1,8(sp)
    80006514:	6105                	addi	sp,sp,32
    80006516:	8082                	ret
    panic("release");
    80006518:	00002517          	auipc	a0,0x2
    8000651c:	41050513          	addi	a0,a0,1040 # 80008928 <digits+0x48>
    80006520:	00000097          	auipc	ra,0x0
    80006524:	9c2080e7          	jalr	-1598(ra) # 80005ee2 <panic>
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
