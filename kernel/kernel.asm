
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	8b013103          	ld	sp,-1872(sp) # 800088b0 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	2b7050ef          	jal	ra,80005acc <start>

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
    80000034:	d4078793          	addi	a5,a5,-704 # 80033d70 <end>
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
    80000054:	8b090913          	addi	s2,s2,-1872 # 80008900 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	472080e7          	jalr	1138(ra) # 800064cc <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	512080e7          	jalr	1298(ra) # 80006580 <release>
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
    8000008e:	ef8080e7          	jalr	-264(ra) # 80005f82 <panic>

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
    800000f0:	81450513          	addi	a0,a0,-2028 # 80008900 <kmem>
    800000f4:	00006097          	auipc	ra,0x6
    800000f8:	348080e7          	jalr	840(ra) # 8000643c <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fc:	45c5                	li	a1,17
    800000fe:	05ee                	slli	a1,a1,0x1b
    80000100:	00034517          	auipc	a0,0x34
    80000104:	c7050513          	addi	a0,a0,-912 # 80033d70 <end>
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
    80000122:	00008497          	auipc	s1,0x8
    80000126:	7de48493          	addi	s1,s1,2014 # 80008900 <kmem>
    8000012a:	8526                	mv	a0,s1
    8000012c:	00006097          	auipc	ra,0x6
    80000130:	3a0080e7          	jalr	928(ra) # 800064cc <acquire>
  r = kmem.freelist;
    80000134:	6c84                	ld	s1,24(s1)
  if(r)
    80000136:	c885                	beqz	s1,80000166 <kalloc+0x4e>
    kmem.freelist = r->next;
    80000138:	609c                	ld	a5,0(s1)
    8000013a:	00008517          	auipc	a0,0x8
    8000013e:	7c650513          	addi	a0,a0,1990 # 80008900 <kmem>
    80000142:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000144:	00006097          	auipc	ra,0x6
    80000148:	43c080e7          	jalr	1084(ra) # 80006580 <release>

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
    80000166:	00008517          	auipc	a0,0x8
    8000016a:	79a50513          	addi	a0,a0,1946 # 80008900 <kmem>
    8000016e:	00006097          	auipc	ra,0x6
    80000172:	412080e7          	jalr	1042(ra) # 80006580 <release>
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
    80000332:	ae4080e7          	jalr	-1308(ra) # 80000e12 <cpuid>
    virtio_disk_init(); // emulated hard disk
    userinit();      // first user process
    __sync_synchronize();
    started = 1;
  } else {
    while(started == 0)
    80000336:	00008717          	auipc	a4,0x8
    8000033a:	59a70713          	addi	a4,a4,1434 # 800088d0 <started>
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
    8000034e:	ac8080e7          	jalr	-1336(ra) # 80000e12 <cpuid>
    80000352:	85aa                	mv	a1,a0
    80000354:	00008517          	auipc	a0,0x8
    80000358:	ce450513          	addi	a0,a0,-796 # 80008038 <etext+0x38>
    8000035c:	00006097          	auipc	ra,0x6
    80000360:	c70080e7          	jalr	-912(ra) # 80005fcc <printf>
    kvminithart();    // turn on paging
    80000364:	00000097          	auipc	ra,0x0
    80000368:	0d8080e7          	jalr	216(ra) # 8000043c <kvminithart>
    trapinithart();   // install kernel trap vector
    8000036c:	00001097          	auipc	ra,0x1
    80000370:	7aa080e7          	jalr	1962(ra) # 80001b16 <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000374:	00005097          	auipc	ra,0x5
    80000378:	0ac080e7          	jalr	172(ra) # 80005420 <plicinithart>
  }

  scheduler();        
    8000037c:	00001097          	auipc	ra,0x1
    80000380:	ff4080e7          	jalr	-12(ra) # 80001370 <scheduler>
    consoleinit();
    80000384:	00006097          	auipc	ra,0x6
    80000388:	b10080e7          	jalr	-1264(ra) # 80005e94 <consoleinit>
    printfinit();
    8000038c:	00006097          	auipc	ra,0x6
    80000390:	e26080e7          	jalr	-474(ra) # 800061b2 <printfinit>
    printf("\n");
    80000394:	00008517          	auipc	a0,0x8
    80000398:	cb450513          	addi	a0,a0,-844 # 80008048 <etext+0x48>
    8000039c:	00006097          	auipc	ra,0x6
    800003a0:	c30080e7          	jalr	-976(ra) # 80005fcc <printf>
    printf("xv6 kernel is booting\n");
    800003a4:	00008517          	auipc	a0,0x8
    800003a8:	c7c50513          	addi	a0,a0,-900 # 80008020 <etext+0x20>
    800003ac:	00006097          	auipc	ra,0x6
    800003b0:	c20080e7          	jalr	-992(ra) # 80005fcc <printf>
    printf("\n");
    800003b4:	00008517          	auipc	a0,0x8
    800003b8:	c9450513          	addi	a0,a0,-876 # 80008048 <etext+0x48>
    800003bc:	00006097          	auipc	ra,0x6
    800003c0:	c10080e7          	jalr	-1008(ra) # 80005fcc <printf>
    kinit();         // physical page allocator
    800003c4:	00000097          	auipc	ra,0x0
    800003c8:	d18080e7          	jalr	-744(ra) # 800000dc <kinit>
    kvminit();       // create kernel page table
    800003cc:	00000097          	auipc	ra,0x0
    800003d0:	326080e7          	jalr	806(ra) # 800006f2 <kvminit>
    kvminithart();   // turn on paging
    800003d4:	00000097          	auipc	ra,0x0
    800003d8:	068080e7          	jalr	104(ra) # 8000043c <kvminithart>
    procinit();      // process table
    800003dc:	00001097          	auipc	ra,0x1
    800003e0:	982080e7          	jalr	-1662(ra) # 80000d5e <procinit>
    trapinit();      // trap vectors
    800003e4:	00001097          	auipc	ra,0x1
    800003e8:	70a080e7          	jalr	1802(ra) # 80001aee <trapinit>
    trapinithart();  // install kernel trap vector
    800003ec:	00001097          	auipc	ra,0x1
    800003f0:	72a080e7          	jalr	1834(ra) # 80001b16 <trapinithart>
    plicinit();      // set up interrupt controller
    800003f4:	00005097          	auipc	ra,0x5
    800003f8:	016080e7          	jalr	22(ra) # 8000540a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003fc:	00005097          	auipc	ra,0x5
    80000400:	024080e7          	jalr	36(ra) # 80005420 <plicinithart>
    binit();         // buffer cache
    80000404:	00002097          	auipc	ra,0x2
    80000408:	f46080e7          	jalr	-186(ra) # 8000234a <binit>
    iinit();         // inode table
    8000040c:	00002097          	auipc	ra,0x2
    80000410:	5ea080e7          	jalr	1514(ra) # 800029f6 <iinit>
    fileinit();      // file table
    80000414:	00003097          	auipc	ra,0x3
    80000418:	588080e7          	jalr	1416(ra) # 8000399c <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000041c:	00005097          	auipc	ra,0x5
    80000420:	10c080e7          	jalr	268(ra) # 80005528 <virtio_disk_init>
    userinit();      // first user process
    80000424:	00001097          	auipc	ra,0x1
    80000428:	cf2080e7          	jalr	-782(ra) # 80001116 <userinit>
    __sync_synchronize();
    8000042c:	0ff0000f          	fence
    started = 1;
    80000430:	4785                	li	a5,1
    80000432:	00008717          	auipc	a4,0x8
    80000436:	48f72f23          	sw	a5,1182(a4) # 800088d0 <started>
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
    8000044a:	4927b783          	ld	a5,1170(a5) # 800088d8 <kernel_pagetable>
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
    80000496:	af0080e7          	jalr	-1296(ra) # 80005f82 <panic>
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

        *pte = PA2PTE(pa) | perm | PTE_V;

        if (a == last)
            break;
        a += PGSIZE;
    8000057e:	6b85                	lui	s7,0x1
    80000580:	a015                	j	800005a4 <mappages+0x58>
        panic("mappages: size");
    80000582:	00008517          	auipc	a0,0x8
    80000586:	ad650513          	addi	a0,a0,-1322 # 80008058 <etext+0x58>
    8000058a:	00006097          	auipc	ra,0x6
    8000058e:	9f8080e7          	jalr	-1544(ra) # 80005f82 <panic>
            panic("mappages: remap");
    80000592:	00008517          	auipc	a0,0x8
    80000596:	ad650513          	addi	a0,a0,-1322 # 80008068 <etext+0x68>
    8000059a:	00006097          	auipc	ra,0x6
    8000059e:	9e8080e7          	jalr	-1560(ra) # 80005f82 <panic>
        a += PGSIZE;
    800005a2:	995e                	add	s2,s2,s7
    for (;;)
    800005a4:	012a04b3          	add	s1,s4,s2
        if ((pte = walk(pagetable, a, 1)) == 0)
    800005a8:	4605                	li	a2,1
    800005aa:	85ca                	mv	a1,s2
    800005ac:	8556                	mv	a0,s5
    800005ae:	00000097          	auipc	ra,0x0
    800005b2:	eb6080e7          	jalr	-330(ra) # 80000464 <walk>
    800005b6:	cd19                	beqz	a0,800005d4 <mappages+0x88>
        if (*pte & PTE_V)
    800005b8:	611c                	ld	a5,0(a0)
    800005ba:	8b85                	andi	a5,a5,1
    800005bc:	fbf9                	bnez	a5,80000592 <mappages+0x46>
        *pte = PA2PTE(pa) | perm | PTE_V;
    800005be:	80b1                	srli	s1,s1,0xc
    800005c0:	04aa                	slli	s1,s1,0xa
    800005c2:	0164e4b3          	or	s1,s1,s6
    800005c6:	0014e493          	ori	s1,s1,1
    800005ca:	e104                	sd	s1,0(a0)
        if (a == last)
    800005cc:	fd391be3          	bne	s2,s3,800005a2 <mappages+0x56>
        pa += PGSIZE;
    }
    return 0;
    800005d0:	4501                	li	a0,0
    800005d2:	a011                	j	800005d6 <mappages+0x8a>
            return -1;
    800005d4:	557d                	li	a0,-1
}
    800005d6:	60a6                	ld	ra,72(sp)
    800005d8:	6406                	ld	s0,64(sp)
    800005da:	74e2                	ld	s1,56(sp)
    800005dc:	7942                	ld	s2,48(sp)
    800005de:	79a2                	ld	s3,40(sp)
    800005e0:	7a02                	ld	s4,32(sp)
    800005e2:	6ae2                	ld	s5,24(sp)
    800005e4:	6b42                	ld	s6,16(sp)
    800005e6:	6ba2                	ld	s7,8(sp)
    800005e8:	6161                	addi	sp,sp,80
    800005ea:	8082                	ret

00000000800005ec <kvmmap>:
{
    800005ec:	1141                	addi	sp,sp,-16
    800005ee:	e406                	sd	ra,8(sp)
    800005f0:	e022                	sd	s0,0(sp)
    800005f2:	0800                	addi	s0,sp,16
    800005f4:	87b6                	mv	a5,a3
    if (mappages(kpgtbl, va, sz, pa, perm) != 0)
    800005f6:	86b2                	mv	a3,a2
    800005f8:	863e                	mv	a2,a5
    800005fa:	00000097          	auipc	ra,0x0
    800005fe:	f52080e7          	jalr	-174(ra) # 8000054c <mappages>
    80000602:	e509                	bnez	a0,8000060c <kvmmap+0x20>
}
    80000604:	60a2                	ld	ra,8(sp)
    80000606:	6402                	ld	s0,0(sp)
    80000608:	0141                	addi	sp,sp,16
    8000060a:	8082                	ret
        panic("kvmmap");
    8000060c:	00008517          	auipc	a0,0x8
    80000610:	a6c50513          	addi	a0,a0,-1428 # 80008078 <etext+0x78>
    80000614:	00006097          	auipc	ra,0x6
    80000618:	96e080e7          	jalr	-1682(ra) # 80005f82 <panic>

000000008000061c <kvmmake>:
{
    8000061c:	1101                	addi	sp,sp,-32
    8000061e:	ec06                	sd	ra,24(sp)
    80000620:	e822                	sd	s0,16(sp)
    80000622:	e426                	sd	s1,8(sp)
    80000624:	e04a                	sd	s2,0(sp)
    80000626:	1000                	addi	s0,sp,32
    kpgtbl = (pagetable_t)kalloc();
    80000628:	00000097          	auipc	ra,0x0
    8000062c:	af0080e7          	jalr	-1296(ra) # 80000118 <kalloc>
    80000630:	84aa                	mv	s1,a0
    memset(kpgtbl, 0, PGSIZE);
    80000632:	6605                	lui	a2,0x1
    80000634:	4581                	li	a1,0
    80000636:	00000097          	auipc	ra,0x0
    8000063a:	b42080e7          	jalr	-1214(ra) # 80000178 <memset>
    kvmmap(kpgtbl, UART0, UART0, PGSIZE, PTE_R | PTE_W);
    8000063e:	4719                	li	a4,6
    80000640:	6685                	lui	a3,0x1
    80000642:	10000637          	lui	a2,0x10000
    80000646:	100005b7          	lui	a1,0x10000
    8000064a:	8526                	mv	a0,s1
    8000064c:	00000097          	auipc	ra,0x0
    80000650:	fa0080e7          	jalr	-96(ra) # 800005ec <kvmmap>
    kvmmap(kpgtbl, VIRTIO0, VIRTIO0, PGSIZE, PTE_R | PTE_W);
    80000654:	4719                	li	a4,6
    80000656:	6685                	lui	a3,0x1
    80000658:	10001637          	lui	a2,0x10001
    8000065c:	100015b7          	lui	a1,0x10001
    80000660:	8526                	mv	a0,s1
    80000662:	00000097          	auipc	ra,0x0
    80000666:	f8a080e7          	jalr	-118(ra) # 800005ec <kvmmap>
    kvmmap(kpgtbl, PLIC, PLIC, 0x400000, PTE_R | PTE_W);
    8000066a:	4719                	li	a4,6
    8000066c:	004006b7          	lui	a3,0x400
    80000670:	0c000637          	lui	a2,0xc000
    80000674:	0c0005b7          	lui	a1,0xc000
    80000678:	8526                	mv	a0,s1
    8000067a:	00000097          	auipc	ra,0x0
    8000067e:	f72080e7          	jalr	-142(ra) # 800005ec <kvmmap>
    kvmmap(kpgtbl, KERNBASE, KERNBASE, (uint64)etext - KERNBASE, PTE_R | PTE_X);
    80000682:	00008917          	auipc	s2,0x8
    80000686:	97e90913          	addi	s2,s2,-1666 # 80008000 <etext>
    8000068a:	4729                	li	a4,10
    8000068c:	80008697          	auipc	a3,0x80008
    80000690:	97468693          	addi	a3,a3,-1676 # 8000 <_entry-0x7fff8000>
    80000694:	4605                	li	a2,1
    80000696:	067e                	slli	a2,a2,0x1f
    80000698:	85b2                	mv	a1,a2
    8000069a:	8526                	mv	a0,s1
    8000069c:	00000097          	auipc	ra,0x0
    800006a0:	f50080e7          	jalr	-176(ra) # 800005ec <kvmmap>
    kvmmap(kpgtbl, (uint64)etext, (uint64)etext, PHYSTOP - (uint64)etext, PTE_R | PTE_W);
    800006a4:	4719                	li	a4,6
    800006a6:	46c5                	li	a3,17
    800006a8:	06ee                	slli	a3,a3,0x1b
    800006aa:	412686b3          	sub	a3,a3,s2
    800006ae:	864a                	mv	a2,s2
    800006b0:	85ca                	mv	a1,s2
    800006b2:	8526                	mv	a0,s1
    800006b4:	00000097          	auipc	ra,0x0
    800006b8:	f38080e7          	jalr	-200(ra) # 800005ec <kvmmap>
    kvmmap(kpgtbl, TRAMPOLINE, (uint64)trampoline, PGSIZE, PTE_R | PTE_X);
    800006bc:	4729                	li	a4,10
    800006be:	6685                	lui	a3,0x1
    800006c0:	00007617          	auipc	a2,0x7
    800006c4:	94060613          	addi	a2,a2,-1728 # 80007000 <_trampoline>
    800006c8:	040005b7          	lui	a1,0x4000
    800006cc:	15fd                	addi	a1,a1,-1
    800006ce:	05b2                	slli	a1,a1,0xc
    800006d0:	8526                	mv	a0,s1
    800006d2:	00000097          	auipc	ra,0x0
    800006d6:	f1a080e7          	jalr	-230(ra) # 800005ec <kvmmap>
    proc_mapstacks(kpgtbl);
    800006da:	8526                	mv	a0,s1
    800006dc:	00000097          	auipc	ra,0x0
    800006e0:	5ec080e7          	jalr	1516(ra) # 80000cc8 <proc_mapstacks>
}
    800006e4:	8526                	mv	a0,s1
    800006e6:	60e2                	ld	ra,24(sp)
    800006e8:	6442                	ld	s0,16(sp)
    800006ea:	64a2                	ld	s1,8(sp)
    800006ec:	6902                	ld	s2,0(sp)
    800006ee:	6105                	addi	sp,sp,32
    800006f0:	8082                	ret

00000000800006f2 <kvminit>:
{
    800006f2:	1141                	addi	sp,sp,-16
    800006f4:	e406                	sd	ra,8(sp)
    800006f6:	e022                	sd	s0,0(sp)
    800006f8:	0800                	addi	s0,sp,16
    kernel_pagetable = kvmmake();
    800006fa:	00000097          	auipc	ra,0x0
    800006fe:	f22080e7          	jalr	-222(ra) # 8000061c <kvmmake>
    80000702:	00008797          	auipc	a5,0x8
    80000706:	1ca7bb23          	sd	a0,470(a5) # 800088d8 <kernel_pagetable>
}
    8000070a:	60a2                	ld	ra,8(sp)
    8000070c:	6402                	ld	s0,0(sp)
    8000070e:	0141                	addi	sp,sp,16
    80000710:	8082                	ret

0000000080000712 <uvmunmap>:

// Remove npages of mappings starting from va. va must be
// page-aligned. The mappings must exist.
// Optionally free the physical memory.
void uvmunmap(pagetable_t pagetable, uint64 va, uint64 npages, int do_free)
{
    80000712:	715d                	addi	sp,sp,-80
    80000714:	e486                	sd	ra,72(sp)
    80000716:	e0a2                	sd	s0,64(sp)
    80000718:	fc26                	sd	s1,56(sp)
    8000071a:	f84a                	sd	s2,48(sp)
    8000071c:	f44e                	sd	s3,40(sp)
    8000071e:	f052                	sd	s4,32(sp)
    80000720:	ec56                	sd	s5,24(sp)
    80000722:	e85a                	sd	s6,16(sp)
    80000724:	e45e                	sd	s7,8(sp)
    80000726:	0880                	addi	s0,sp,80
    uint64 a;
    pte_t *pte;

    if ((va % PGSIZE) != 0)
    80000728:	03459793          	slli	a5,a1,0x34
    8000072c:	e795                	bnez	a5,80000758 <uvmunmap+0x46>
    8000072e:	8a2a                	mv	s4,a0
    80000730:	892e                	mv	s2,a1
    80000732:	8b36                	mv	s6,a3
        panic("uvmunmap: not aligned");

    for (a = va; a < va + npages * PGSIZE; a += PGSIZE)
    80000734:	0632                	slli	a2,a2,0xc
    80000736:	00b609b3          	add	s3,a2,a1
            // if (do_free == -1)
            continue;
            // else
            //   panic("uvmunmap: not mapped");
        }
        if (PTE_FLAGS(*pte) == PTE_V)
    8000073a:	4b85                	li	s7,1
    for (a = va; a < va + npages * PGSIZE; a += PGSIZE)
    8000073c:	6a85                	lui	s5,0x1
    8000073e:	0735e163          	bltu	a1,s3,800007a0 <uvmunmap+0x8e>
            uint64 pa = PTE2PA(*pte);
            kfree((void *)pa);
        }
        *pte = 0;
    }
}
    80000742:	60a6                	ld	ra,72(sp)
    80000744:	6406                	ld	s0,64(sp)
    80000746:	74e2                	ld	s1,56(sp)
    80000748:	7942                	ld	s2,48(sp)
    8000074a:	79a2                	ld	s3,40(sp)
    8000074c:	7a02                	ld	s4,32(sp)
    8000074e:	6ae2                	ld	s5,24(sp)
    80000750:	6b42                	ld	s6,16(sp)
    80000752:	6ba2                	ld	s7,8(sp)
    80000754:	6161                	addi	sp,sp,80
    80000756:	8082                	ret
        panic("uvmunmap: not aligned");
    80000758:	00008517          	auipc	a0,0x8
    8000075c:	92850513          	addi	a0,a0,-1752 # 80008080 <etext+0x80>
    80000760:	00006097          	auipc	ra,0x6
    80000764:	822080e7          	jalr	-2014(ra) # 80005f82 <panic>
            panic("uvmunmap: walk");
    80000768:	00008517          	auipc	a0,0x8
    8000076c:	93050513          	addi	a0,a0,-1744 # 80008098 <etext+0x98>
    80000770:	00006097          	auipc	ra,0x6
    80000774:	812080e7          	jalr	-2030(ra) # 80005f82 <panic>
            panic("uvmunmap: not a leaf");
    80000778:	00008517          	auipc	a0,0x8
    8000077c:	93050513          	addi	a0,a0,-1744 # 800080a8 <etext+0xa8>
    80000780:	00006097          	auipc	ra,0x6
    80000784:	802080e7          	jalr	-2046(ra) # 80005f82 <panic>
            uint64 pa = PTE2PA(*pte);
    80000788:	83a9                	srli	a5,a5,0xa
            kfree((void *)pa);
    8000078a:	00c79513          	slli	a0,a5,0xc
    8000078e:	00000097          	auipc	ra,0x0
    80000792:	88e080e7          	jalr	-1906(ra) # 8000001c <kfree>
        *pte = 0;
    80000796:	0004b023          	sd	zero,0(s1)
    for (a = va; a < va + npages * PGSIZE; a += PGSIZE)
    8000079a:	9956                	add	s2,s2,s5
    8000079c:	fb3973e3          	bgeu	s2,s3,80000742 <uvmunmap+0x30>
        if ((pte = walk(pagetable, a, 0)) == 0)
    800007a0:	4601                	li	a2,0
    800007a2:	85ca                	mv	a1,s2
    800007a4:	8552                	mv	a0,s4
    800007a6:	00000097          	auipc	ra,0x0
    800007aa:	cbe080e7          	jalr	-834(ra) # 80000464 <walk>
    800007ae:	84aa                	mv	s1,a0
    800007b0:	dd45                	beqz	a0,80000768 <uvmunmap+0x56>
        if ((*pte & PTE_V) == 0)
    800007b2:	611c                	ld	a5,0(a0)
    800007b4:	0017f713          	andi	a4,a5,1
    800007b8:	d36d                	beqz	a4,8000079a <uvmunmap+0x88>
        if (PTE_FLAGS(*pte) == PTE_V)
    800007ba:	3ff7f713          	andi	a4,a5,1023
    800007be:	fb770de3          	beq	a4,s7,80000778 <uvmunmap+0x66>
        if (do_free)
    800007c2:	fc0b0ae3          	beqz	s6,80000796 <uvmunmap+0x84>
    800007c6:	b7c9                	j	80000788 <uvmunmap+0x76>

00000000800007c8 <uvmcreate>:

// create an empty user page table.
// returns 0 if out of memory.
pagetable_t
uvmcreate()
{
    800007c8:	1101                	addi	sp,sp,-32
    800007ca:	ec06                	sd	ra,24(sp)
    800007cc:	e822                	sd	s0,16(sp)
    800007ce:	e426                	sd	s1,8(sp)
    800007d0:	1000                	addi	s0,sp,32
    pagetable_t pagetable;
    pagetable = (pagetable_t)kalloc();
    800007d2:	00000097          	auipc	ra,0x0
    800007d6:	946080e7          	jalr	-1722(ra) # 80000118 <kalloc>
    800007da:	84aa                	mv	s1,a0
    if (pagetable == 0)
    800007dc:	c519                	beqz	a0,800007ea <uvmcreate+0x22>
        return 0;
    memset(pagetable, 0, PGSIZE);
    800007de:	6605                	lui	a2,0x1
    800007e0:	4581                	li	a1,0
    800007e2:	00000097          	auipc	ra,0x0
    800007e6:	996080e7          	jalr	-1642(ra) # 80000178 <memset>
    return pagetable;
}
    800007ea:	8526                	mv	a0,s1
    800007ec:	60e2                	ld	ra,24(sp)
    800007ee:	6442                	ld	s0,16(sp)
    800007f0:	64a2                	ld	s1,8(sp)
    800007f2:	6105                	addi	sp,sp,32
    800007f4:	8082                	ret

00000000800007f6 <uvmfirst>:

// Load the user initcode into address 0 of pagetable,
// for the very first process.
// sz must be less than a page.
void uvmfirst(pagetable_t pagetable, uchar *src, uint sz)
{
    800007f6:	7179                	addi	sp,sp,-48
    800007f8:	f406                	sd	ra,40(sp)
    800007fa:	f022                	sd	s0,32(sp)
    800007fc:	ec26                	sd	s1,24(sp)
    800007fe:	e84a                	sd	s2,16(sp)
    80000800:	e44e                	sd	s3,8(sp)
    80000802:	e052                	sd	s4,0(sp)
    80000804:	1800                	addi	s0,sp,48
    char *mem;

    if (sz >= PGSIZE)
    80000806:	6785                	lui	a5,0x1
    80000808:	04f67863          	bgeu	a2,a5,80000858 <uvmfirst+0x62>
    8000080c:	8a2a                	mv	s4,a0
    8000080e:	89ae                	mv	s3,a1
    80000810:	84b2                	mv	s1,a2
        panic("uvmfirst: more than a page");
    mem = kalloc();
    80000812:	00000097          	auipc	ra,0x0
    80000816:	906080e7          	jalr	-1786(ra) # 80000118 <kalloc>
    8000081a:	892a                	mv	s2,a0
    memset(mem, 0, PGSIZE);
    8000081c:	6605                	lui	a2,0x1
    8000081e:	4581                	li	a1,0
    80000820:	00000097          	auipc	ra,0x0
    80000824:	958080e7          	jalr	-1704(ra) # 80000178 <memset>
    mappages(pagetable, 0, PGSIZE, (uint64)mem, PTE_W | PTE_R | PTE_X | PTE_U);
    80000828:	4779                	li	a4,30
    8000082a:	86ca                	mv	a3,s2
    8000082c:	6605                	lui	a2,0x1
    8000082e:	4581                	li	a1,0
    80000830:	8552                	mv	a0,s4
    80000832:	00000097          	auipc	ra,0x0
    80000836:	d1a080e7          	jalr	-742(ra) # 8000054c <mappages>
    memmove(mem, src, sz);
    8000083a:	8626                	mv	a2,s1
    8000083c:	85ce                	mv	a1,s3
    8000083e:	854a                	mv	a0,s2
    80000840:	00000097          	auipc	ra,0x0
    80000844:	998080e7          	jalr	-1640(ra) # 800001d8 <memmove>
}
    80000848:	70a2                	ld	ra,40(sp)
    8000084a:	7402                	ld	s0,32(sp)
    8000084c:	64e2                	ld	s1,24(sp)
    8000084e:	6942                	ld	s2,16(sp)
    80000850:	69a2                	ld	s3,8(sp)
    80000852:	6a02                	ld	s4,0(sp)
    80000854:	6145                	addi	sp,sp,48
    80000856:	8082                	ret
        panic("uvmfirst: more than a page");
    80000858:	00008517          	auipc	a0,0x8
    8000085c:	86850513          	addi	a0,a0,-1944 # 800080c0 <etext+0xc0>
    80000860:	00005097          	auipc	ra,0x5
    80000864:	722080e7          	jalr	1826(ra) # 80005f82 <panic>

0000000080000868 <uvmdealloc>:
// newsz.  oldsz and newsz need not be page-aligned, nor does newsz
// need to be less than oldsz.  oldsz can be larger than the actual
// process size.  Returns the new process size.
uint64
uvmdealloc(pagetable_t pagetable, uint64 oldsz, uint64 newsz)
{
    80000868:	1101                	addi	sp,sp,-32
    8000086a:	ec06                	sd	ra,24(sp)
    8000086c:	e822                	sd	s0,16(sp)
    8000086e:	e426                	sd	s1,8(sp)
    80000870:	1000                	addi	s0,sp,32
    if (newsz >= oldsz)
        return oldsz;
    80000872:	84ae                	mv	s1,a1
    if (newsz >= oldsz)
    80000874:	00b67d63          	bgeu	a2,a1,8000088e <uvmdealloc+0x26>
    80000878:	84b2                	mv	s1,a2

    if (PGROUNDUP(newsz) < PGROUNDUP(oldsz))
    8000087a:	6785                	lui	a5,0x1
    8000087c:	17fd                	addi	a5,a5,-1
    8000087e:	00f60733          	add	a4,a2,a5
    80000882:	767d                	lui	a2,0xfffff
    80000884:	8f71                	and	a4,a4,a2
    80000886:	97ae                	add	a5,a5,a1
    80000888:	8ff1                	and	a5,a5,a2
    8000088a:	00f76863          	bltu	a4,a5,8000089a <uvmdealloc+0x32>
        int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
        uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    }

    return newsz;
}
    8000088e:	8526                	mv	a0,s1
    80000890:	60e2                	ld	ra,24(sp)
    80000892:	6442                	ld	s0,16(sp)
    80000894:	64a2                	ld	s1,8(sp)
    80000896:	6105                	addi	sp,sp,32
    80000898:	8082                	ret
        int npages = (PGROUNDUP(oldsz) - PGROUNDUP(newsz)) / PGSIZE;
    8000089a:	8f99                	sub	a5,a5,a4
    8000089c:	83b1                	srli	a5,a5,0xc
        uvmunmap(pagetable, PGROUNDUP(newsz), npages, 1);
    8000089e:	4685                	li	a3,1
    800008a0:	0007861b          	sext.w	a2,a5
    800008a4:	85ba                	mv	a1,a4
    800008a6:	00000097          	auipc	ra,0x0
    800008aa:	e6c080e7          	jalr	-404(ra) # 80000712 <uvmunmap>
    800008ae:	b7c5                	j	8000088e <uvmdealloc+0x26>

00000000800008b0 <uvmalloc>:
    if (newsz < oldsz)
    800008b0:	0ab66563          	bltu	a2,a1,8000095a <uvmalloc+0xaa>
{
    800008b4:	7139                	addi	sp,sp,-64
    800008b6:	fc06                	sd	ra,56(sp)
    800008b8:	f822                	sd	s0,48(sp)
    800008ba:	f426                	sd	s1,40(sp)
    800008bc:	f04a                	sd	s2,32(sp)
    800008be:	ec4e                	sd	s3,24(sp)
    800008c0:	e852                	sd	s4,16(sp)
    800008c2:	e456                	sd	s5,8(sp)
    800008c4:	e05a                	sd	s6,0(sp)
    800008c6:	0080                	addi	s0,sp,64
    800008c8:	8aaa                	mv	s5,a0
    800008ca:	8a32                	mv	s4,a2
    oldsz = PGROUNDUP(oldsz);
    800008cc:	6985                	lui	s3,0x1
    800008ce:	19fd                	addi	s3,s3,-1
    800008d0:	95ce                	add	a1,a1,s3
    800008d2:	79fd                	lui	s3,0xfffff
    800008d4:	0135f9b3          	and	s3,a1,s3
    for (a = oldsz; a < newsz; a += PGSIZE)
    800008d8:	08c9f363          	bgeu	s3,a2,8000095e <uvmalloc+0xae>
    800008dc:	894e                	mv	s2,s3
        if (mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R | PTE_U | xperm) != 0)
    800008de:	0126eb13          	ori	s6,a3,18
        mem = kalloc();
    800008e2:	00000097          	auipc	ra,0x0
    800008e6:	836080e7          	jalr	-1994(ra) # 80000118 <kalloc>
    800008ea:	84aa                	mv	s1,a0
        if (mem == 0)
    800008ec:	c51d                	beqz	a0,8000091a <uvmalloc+0x6a>
        memset(mem, 0, PGSIZE);
    800008ee:	6605                	lui	a2,0x1
    800008f0:	4581                	li	a1,0
    800008f2:	00000097          	auipc	ra,0x0
    800008f6:	886080e7          	jalr	-1914(ra) # 80000178 <memset>
        if (mappages(pagetable, a, PGSIZE, (uint64)mem, PTE_R | PTE_U | xperm) != 0)
    800008fa:	875a                	mv	a4,s6
    800008fc:	86a6                	mv	a3,s1
    800008fe:	6605                	lui	a2,0x1
    80000900:	85ca                	mv	a1,s2
    80000902:	8556                	mv	a0,s5
    80000904:	00000097          	auipc	ra,0x0
    80000908:	c48080e7          	jalr	-952(ra) # 8000054c <mappages>
    8000090c:	e90d                	bnez	a0,8000093e <uvmalloc+0x8e>
    for (a = oldsz; a < newsz; a += PGSIZE)
    8000090e:	6785                	lui	a5,0x1
    80000910:	993e                	add	s2,s2,a5
    80000912:	fd4968e3          	bltu	s2,s4,800008e2 <uvmalloc+0x32>
    return newsz;
    80000916:	8552                	mv	a0,s4
    80000918:	a809                	j	8000092a <uvmalloc+0x7a>
            uvmdealloc(pagetable, a, oldsz);
    8000091a:	864e                	mv	a2,s3
    8000091c:	85ca                	mv	a1,s2
    8000091e:	8556                	mv	a0,s5
    80000920:	00000097          	auipc	ra,0x0
    80000924:	f48080e7          	jalr	-184(ra) # 80000868 <uvmdealloc>
            return 0;
    80000928:	4501                	li	a0,0
}
    8000092a:	70e2                	ld	ra,56(sp)
    8000092c:	7442                	ld	s0,48(sp)
    8000092e:	74a2                	ld	s1,40(sp)
    80000930:	7902                	ld	s2,32(sp)
    80000932:	69e2                	ld	s3,24(sp)
    80000934:	6a42                	ld	s4,16(sp)
    80000936:	6aa2                	ld	s5,8(sp)
    80000938:	6b02                	ld	s6,0(sp)
    8000093a:	6121                	addi	sp,sp,64
    8000093c:	8082                	ret
            kfree(mem);
    8000093e:	8526                	mv	a0,s1
    80000940:	fffff097          	auipc	ra,0xfffff
    80000944:	6dc080e7          	jalr	1756(ra) # 8000001c <kfree>
            uvmdealloc(pagetable, a, oldsz);
    80000948:	864e                	mv	a2,s3
    8000094a:	85ca                	mv	a1,s2
    8000094c:	8556                	mv	a0,s5
    8000094e:	00000097          	auipc	ra,0x0
    80000952:	f1a080e7          	jalr	-230(ra) # 80000868 <uvmdealloc>
            return 0;
    80000956:	4501                	li	a0,0
    80000958:	bfc9                	j	8000092a <uvmalloc+0x7a>
        return oldsz;
    8000095a:	852e                	mv	a0,a1
}
    8000095c:	8082                	ret
    return newsz;
    8000095e:	8532                	mv	a0,a2
    80000960:	b7e9                	j	8000092a <uvmalloc+0x7a>

0000000080000962 <freewalk>:

// Recursively free page-table pages.
// All leaf mappings must already have been removed.
void freewalk(pagetable_t pagetable)
{
    80000962:	7179                	addi	sp,sp,-48
    80000964:	f406                	sd	ra,40(sp)
    80000966:	f022                	sd	s0,32(sp)
    80000968:	ec26                	sd	s1,24(sp)
    8000096a:	e84a                	sd	s2,16(sp)
    8000096c:	e44e                	sd	s3,8(sp)
    8000096e:	e052                	sd	s4,0(sp)
    80000970:	1800                	addi	s0,sp,48
    80000972:	8a2a                	mv	s4,a0
    // there are 2^9 = 512 PTEs in a page table.
    for (int i = 0; i < 512; i++)
    80000974:	84aa                	mv	s1,a0
    80000976:	6905                	lui	s2,0x1
    80000978:	992a                	add	s2,s2,a0
    {
        pte_t pte = pagetable[i];
        if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0)
    8000097a:	4985                	li	s3,1
    8000097c:	a821                	j	80000994 <freewalk+0x32>
        {
            // this PTE points to a lower-level page table.
            uint64 child = PTE2PA(pte);
    8000097e:	8129                	srli	a0,a0,0xa
            freewalk((pagetable_t)child);
    80000980:	0532                	slli	a0,a0,0xc
    80000982:	00000097          	auipc	ra,0x0
    80000986:	fe0080e7          	jalr	-32(ra) # 80000962 <freewalk>
            pagetable[i] = 0;
    8000098a:	0004b023          	sd	zero,0(s1)
    for (int i = 0; i < 512; i++)
    8000098e:	04a1                	addi	s1,s1,8
    80000990:	03248163          	beq	s1,s2,800009b2 <freewalk+0x50>
        pte_t pte = pagetable[i];
    80000994:	6088                	ld	a0,0(s1)
        if ((pte & PTE_V) && (pte & (PTE_R | PTE_W | PTE_X)) == 0)
    80000996:	00f57793          	andi	a5,a0,15
    8000099a:	ff3782e3          	beq	a5,s3,8000097e <freewalk+0x1c>
        }
        else if (pte & PTE_V)
    8000099e:	8905                	andi	a0,a0,1
    800009a0:	d57d                	beqz	a0,8000098e <freewalk+0x2c>
        {
            panic("freewalk: leaf");
    800009a2:	00007517          	auipc	a0,0x7
    800009a6:	73e50513          	addi	a0,a0,1854 # 800080e0 <etext+0xe0>
    800009aa:	00005097          	auipc	ra,0x5
    800009ae:	5d8080e7          	jalr	1496(ra) # 80005f82 <panic>
        }
    }
    kfree((void *)pagetable);
    800009b2:	8552                	mv	a0,s4
    800009b4:	fffff097          	auipc	ra,0xfffff
    800009b8:	668080e7          	jalr	1640(ra) # 8000001c <kfree>
}
    800009bc:	70a2                	ld	ra,40(sp)
    800009be:	7402                	ld	s0,32(sp)
    800009c0:	64e2                	ld	s1,24(sp)
    800009c2:	6942                	ld	s2,16(sp)
    800009c4:	69a2                	ld	s3,8(sp)
    800009c6:	6a02                	ld	s4,0(sp)
    800009c8:	6145                	addi	sp,sp,48
    800009ca:	8082                	ret

00000000800009cc <uvmfree>:

// Free user memory pages,
// then free page-table pages.
void uvmfree(pagetable_t pagetable, uint64 sz)
{
    800009cc:	1101                	addi	sp,sp,-32
    800009ce:	ec06                	sd	ra,24(sp)
    800009d0:	e822                	sd	s0,16(sp)
    800009d2:	e426                	sd	s1,8(sp)
    800009d4:	1000                	addi	s0,sp,32
    800009d6:	84aa                	mv	s1,a0
    if (sz > 0)
    800009d8:	e999                	bnez	a1,800009ee <uvmfree+0x22>
        uvmunmap(pagetable, 0, PGROUNDUP(sz) / PGSIZE, 1);
    freewalk(pagetable);
    800009da:	8526                	mv	a0,s1
    800009dc:	00000097          	auipc	ra,0x0
    800009e0:	f86080e7          	jalr	-122(ra) # 80000962 <freewalk>
}
    800009e4:	60e2                	ld	ra,24(sp)
    800009e6:	6442                	ld	s0,16(sp)
    800009e8:	64a2                	ld	s1,8(sp)
    800009ea:	6105                	addi	sp,sp,32
    800009ec:	8082                	ret
        uvmunmap(pagetable, 0, PGROUNDUP(sz) / PGSIZE, 1);
    800009ee:	6605                	lui	a2,0x1
    800009f0:	167d                	addi	a2,a2,-1
    800009f2:	962e                	add	a2,a2,a1
    800009f4:	4685                	li	a3,1
    800009f6:	8231                	srli	a2,a2,0xc
    800009f8:	4581                	li	a1,0
    800009fa:	00000097          	auipc	ra,0x0
    800009fe:	d18080e7          	jalr	-744(ra) # 80000712 <uvmunmap>
    80000a02:	bfe1                	j	800009da <uvmfree+0xe>

0000000080000a04 <uvmcopy>:
    pte_t *pte;
    uint64 pa, i;
    uint flags;
    char *mem;

    for (i = 0; i < sz; i += PGSIZE)
    80000a04:	c269                	beqz	a2,80000ac6 <uvmcopy+0xc2>
{
    80000a06:	715d                	addi	sp,sp,-80
    80000a08:	e486                	sd	ra,72(sp)
    80000a0a:	e0a2                	sd	s0,64(sp)
    80000a0c:	fc26                	sd	s1,56(sp)
    80000a0e:	f84a                	sd	s2,48(sp)
    80000a10:	f44e                	sd	s3,40(sp)
    80000a12:	f052                	sd	s4,32(sp)
    80000a14:	ec56                	sd	s5,24(sp)
    80000a16:	e85a                	sd	s6,16(sp)
    80000a18:	e45e                	sd	s7,8(sp)
    80000a1a:	0880                	addi	s0,sp,80
    80000a1c:	8aaa                	mv	s5,a0
    80000a1e:	8b2e                	mv	s6,a1
    80000a20:	8a32                	mv	s4,a2
    for (i = 0; i < sz; i += PGSIZE)
    80000a22:	4481                	li	s1,0
    80000a24:	a829                	j	80000a3e <uvmcopy+0x3a>
    {
        if ((pte = walk(old, i, 0)) == 0)
            panic("uvmcopy: pte should exist");
    80000a26:	00007517          	auipc	a0,0x7
    80000a2a:	6ca50513          	addi	a0,a0,1738 # 800080f0 <etext+0xf0>
    80000a2e:	00005097          	auipc	ra,0x5
    80000a32:	554080e7          	jalr	1364(ra) # 80005f82 <panic>
    for (i = 0; i < sz; i += PGSIZE)
    80000a36:	6785                	lui	a5,0x1
    80000a38:	94be                	add	s1,s1,a5
    80000a3a:	0944f463          	bgeu	s1,s4,80000ac2 <uvmcopy+0xbe>
        if ((pte = walk(old, i, 0)) == 0)
    80000a3e:	4601                	li	a2,0
    80000a40:	85a6                	mv	a1,s1
    80000a42:	8556                	mv	a0,s5
    80000a44:	00000097          	auipc	ra,0x0
    80000a48:	a20080e7          	jalr	-1504(ra) # 80000464 <walk>
    80000a4c:	dd69                	beqz	a0,80000a26 <uvmcopy+0x22>
        if ((*pte & PTE_V) == 0)
    80000a4e:	6118                	ld	a4,0(a0)
    80000a50:	00177793          	andi	a5,a4,1
    80000a54:	d3ed                	beqz	a5,80000a36 <uvmcopy+0x32>
            continue;
        // panic("uvmcopy: page not present");
        pa = PTE2PA(*pte);
    80000a56:	00a75593          	srli	a1,a4,0xa
    80000a5a:	00c59b93          	slli	s7,a1,0xc
        flags = PTE_FLAGS(*pte);
    80000a5e:	3ff77913          	andi	s2,a4,1023
        if ((mem = kalloc()) == 0)
    80000a62:	fffff097          	auipc	ra,0xfffff
    80000a66:	6b6080e7          	jalr	1718(ra) # 80000118 <kalloc>
    80000a6a:	89aa                	mv	s3,a0
    80000a6c:	c515                	beqz	a0,80000a98 <uvmcopy+0x94>
            goto err;
        memmove(mem, (char *)pa, PGSIZE);
    80000a6e:	6605                	lui	a2,0x1
    80000a70:	85de                	mv	a1,s7
    80000a72:	fffff097          	auipc	ra,0xfffff
    80000a76:	766080e7          	jalr	1894(ra) # 800001d8 <memmove>
        if (mappages(new, i, PGSIZE, (uint64)mem, flags) != 0)
    80000a7a:	874a                	mv	a4,s2
    80000a7c:	86ce                	mv	a3,s3
    80000a7e:	6605                	lui	a2,0x1
    80000a80:	85a6                	mv	a1,s1
    80000a82:	855a                	mv	a0,s6
    80000a84:	00000097          	auipc	ra,0x0
    80000a88:	ac8080e7          	jalr	-1336(ra) # 8000054c <mappages>
    80000a8c:	d54d                	beqz	a0,80000a36 <uvmcopy+0x32>
        {
            kfree(mem);
    80000a8e:	854e                	mv	a0,s3
    80000a90:	fffff097          	auipc	ra,0xfffff
    80000a94:	58c080e7          	jalr	1420(ra) # 8000001c <kfree>
        }
    }
    return 0;

err:
    uvmunmap(new, 0, i / PGSIZE, 1);
    80000a98:	4685                	li	a3,1
    80000a9a:	00c4d613          	srli	a2,s1,0xc
    80000a9e:	4581                	li	a1,0
    80000aa0:	855a                	mv	a0,s6
    80000aa2:	00000097          	auipc	ra,0x0
    80000aa6:	c70080e7          	jalr	-912(ra) # 80000712 <uvmunmap>
    return -1;
    80000aaa:	557d                	li	a0,-1
}
    80000aac:	60a6                	ld	ra,72(sp)
    80000aae:	6406                	ld	s0,64(sp)
    80000ab0:	74e2                	ld	s1,56(sp)
    80000ab2:	7942                	ld	s2,48(sp)
    80000ab4:	79a2                	ld	s3,40(sp)
    80000ab6:	7a02                	ld	s4,32(sp)
    80000ab8:	6ae2                	ld	s5,24(sp)
    80000aba:	6b42                	ld	s6,16(sp)
    80000abc:	6ba2                	ld	s7,8(sp)
    80000abe:	6161                	addi	sp,sp,80
    80000ac0:	8082                	ret
    return 0;
    80000ac2:	4501                	li	a0,0
    80000ac4:	b7e5                	j	80000aac <uvmcopy+0xa8>
    80000ac6:	4501                	li	a0,0
}
    80000ac8:	8082                	ret

0000000080000aca <uvmclear>:

// mark a PTE invalid for user access.
// used by exec for the user stack guard page.
void uvmclear(pagetable_t pagetable, uint64 va)
{
    80000aca:	1141                	addi	sp,sp,-16
    80000acc:	e406                	sd	ra,8(sp)
    80000ace:	e022                	sd	s0,0(sp)
    80000ad0:	0800                	addi	s0,sp,16
    pte_t *pte;

    pte = walk(pagetable, va, 0);
    80000ad2:	4601                	li	a2,0
    80000ad4:	00000097          	auipc	ra,0x0
    80000ad8:	990080e7          	jalr	-1648(ra) # 80000464 <walk>
    if (pte == 0)
    80000adc:	c901                	beqz	a0,80000aec <uvmclear+0x22>
        panic("uvmclear");
    *pte &= ~PTE_U;
    80000ade:	611c                	ld	a5,0(a0)
    80000ae0:	9bbd                	andi	a5,a5,-17
    80000ae2:	e11c                	sd	a5,0(a0)
}
    80000ae4:	60a2                	ld	ra,8(sp)
    80000ae6:	6402                	ld	s0,0(sp)
    80000ae8:	0141                	addi	sp,sp,16
    80000aea:	8082                	ret
        panic("uvmclear");
    80000aec:	00007517          	auipc	a0,0x7
    80000af0:	62450513          	addi	a0,a0,1572 # 80008110 <etext+0x110>
    80000af4:	00005097          	auipc	ra,0x5
    80000af8:	48e080e7          	jalr	1166(ra) # 80005f82 <panic>

0000000080000afc <copyout>:
// Return 0 on success, -1 on error.
int copyout(pagetable_t pagetable, uint64 dstva, char *src, uint64 len)
{
    uint64 n, va0, pa0;

    while (len > 0)
    80000afc:	c6bd                	beqz	a3,80000b6a <copyout+0x6e>
{
    80000afe:	715d                	addi	sp,sp,-80
    80000b00:	e486                	sd	ra,72(sp)
    80000b02:	e0a2                	sd	s0,64(sp)
    80000b04:	fc26                	sd	s1,56(sp)
    80000b06:	f84a                	sd	s2,48(sp)
    80000b08:	f44e                	sd	s3,40(sp)
    80000b0a:	f052                	sd	s4,32(sp)
    80000b0c:	ec56                	sd	s5,24(sp)
    80000b0e:	e85a                	sd	s6,16(sp)
    80000b10:	e45e                	sd	s7,8(sp)
    80000b12:	e062                	sd	s8,0(sp)
    80000b14:	0880                	addi	s0,sp,80
    80000b16:	8b2a                	mv	s6,a0
    80000b18:	8c2e                	mv	s8,a1
    80000b1a:	8a32                	mv	s4,a2
    80000b1c:	89b6                	mv	s3,a3
    {
        va0 = PGROUNDDOWN(dstva);
    80000b1e:	7bfd                	lui	s7,0xfffff
        pa0 = walkaddr(pagetable, va0);
        if (pa0 == 0)
            return -1;
        n = PGSIZE - (dstva - va0);
    80000b20:	6a85                	lui	s5,0x1
    80000b22:	a015                	j	80000b46 <copyout+0x4a>
        if (n > len)
            n = len;
        memmove((void *)(pa0 + (dstva - va0)), src, n);
    80000b24:	9562                	add	a0,a0,s8
    80000b26:	0004861b          	sext.w	a2,s1
    80000b2a:	85d2                	mv	a1,s4
    80000b2c:	41250533          	sub	a0,a0,s2
    80000b30:	fffff097          	auipc	ra,0xfffff
    80000b34:	6a8080e7          	jalr	1704(ra) # 800001d8 <memmove>

        len -= n;
    80000b38:	409989b3          	sub	s3,s3,s1
        src += n;
    80000b3c:	9a26                	add	s4,s4,s1
        dstva = va0 + PGSIZE;
    80000b3e:	01590c33          	add	s8,s2,s5
    while (len > 0)
    80000b42:	02098263          	beqz	s3,80000b66 <copyout+0x6a>
        va0 = PGROUNDDOWN(dstva);
    80000b46:	017c7933          	and	s2,s8,s7
        pa0 = walkaddr(pagetable, va0);
    80000b4a:	85ca                	mv	a1,s2
    80000b4c:	855a                	mv	a0,s6
    80000b4e:	00000097          	auipc	ra,0x0
    80000b52:	9bc080e7          	jalr	-1604(ra) # 8000050a <walkaddr>
        if (pa0 == 0)
    80000b56:	cd01                	beqz	a0,80000b6e <copyout+0x72>
        n = PGSIZE - (dstva - va0);
    80000b58:	418904b3          	sub	s1,s2,s8
    80000b5c:	94d6                	add	s1,s1,s5
        if (n > len)
    80000b5e:	fc99f3e3          	bgeu	s3,s1,80000b24 <copyout+0x28>
    80000b62:	84ce                	mv	s1,s3
    80000b64:	b7c1                	j	80000b24 <copyout+0x28>
    }
    return 0;
    80000b66:	4501                	li	a0,0
    80000b68:	a021                	j	80000b70 <copyout+0x74>
    80000b6a:	4501                	li	a0,0
}
    80000b6c:	8082                	ret
            return -1;
    80000b6e:	557d                	li	a0,-1
}
    80000b70:	60a6                	ld	ra,72(sp)
    80000b72:	6406                	ld	s0,64(sp)
    80000b74:	74e2                	ld	s1,56(sp)
    80000b76:	7942                	ld	s2,48(sp)
    80000b78:	79a2                	ld	s3,40(sp)
    80000b7a:	7a02                	ld	s4,32(sp)
    80000b7c:	6ae2                	ld	s5,24(sp)
    80000b7e:	6b42                	ld	s6,16(sp)
    80000b80:	6ba2                	ld	s7,8(sp)
    80000b82:	6c02                	ld	s8,0(sp)
    80000b84:	6161                	addi	sp,sp,80
    80000b86:	8082                	ret

0000000080000b88 <copyin>:
// Return 0 on success, -1 on error.
int copyin(pagetable_t pagetable, char *dst, uint64 srcva, uint64 len)
{
    uint64 n, va0, pa0;

    while (len > 0)
    80000b88:	c6bd                	beqz	a3,80000bf6 <copyin+0x6e>
{
    80000b8a:	715d                	addi	sp,sp,-80
    80000b8c:	e486                	sd	ra,72(sp)
    80000b8e:	e0a2                	sd	s0,64(sp)
    80000b90:	fc26                	sd	s1,56(sp)
    80000b92:	f84a                	sd	s2,48(sp)
    80000b94:	f44e                	sd	s3,40(sp)
    80000b96:	f052                	sd	s4,32(sp)
    80000b98:	ec56                	sd	s5,24(sp)
    80000b9a:	e85a                	sd	s6,16(sp)
    80000b9c:	e45e                	sd	s7,8(sp)
    80000b9e:	e062                	sd	s8,0(sp)
    80000ba0:	0880                	addi	s0,sp,80
    80000ba2:	8b2a                	mv	s6,a0
    80000ba4:	8a2e                	mv	s4,a1
    80000ba6:	8c32                	mv	s8,a2
    80000ba8:	89b6                	mv	s3,a3
    {
        va0 = PGROUNDDOWN(srcva);
    80000baa:	7bfd                	lui	s7,0xfffff
        pa0 = walkaddr(pagetable, va0);
        if (pa0 == 0)
            return -1;
        n = PGSIZE - (srcva - va0);
    80000bac:	6a85                	lui	s5,0x1
    80000bae:	a015                	j	80000bd2 <copyin+0x4a>
        if (n > len)
            n = len;
        memmove(dst, (void *)(pa0 + (srcva - va0)), n);
    80000bb0:	9562                	add	a0,a0,s8
    80000bb2:	0004861b          	sext.w	a2,s1
    80000bb6:	412505b3          	sub	a1,a0,s2
    80000bba:	8552                	mv	a0,s4
    80000bbc:	fffff097          	auipc	ra,0xfffff
    80000bc0:	61c080e7          	jalr	1564(ra) # 800001d8 <memmove>

        len -= n;
    80000bc4:	409989b3          	sub	s3,s3,s1
        dst += n;
    80000bc8:	9a26                	add	s4,s4,s1
        srcva = va0 + PGSIZE;
    80000bca:	01590c33          	add	s8,s2,s5
    while (len > 0)
    80000bce:	02098263          	beqz	s3,80000bf2 <copyin+0x6a>
        va0 = PGROUNDDOWN(srcva);
    80000bd2:	017c7933          	and	s2,s8,s7
        pa0 = walkaddr(pagetable, va0);
    80000bd6:	85ca                	mv	a1,s2
    80000bd8:	855a                	mv	a0,s6
    80000bda:	00000097          	auipc	ra,0x0
    80000bde:	930080e7          	jalr	-1744(ra) # 8000050a <walkaddr>
        if (pa0 == 0)
    80000be2:	cd01                	beqz	a0,80000bfa <copyin+0x72>
        n = PGSIZE - (srcva - va0);
    80000be4:	418904b3          	sub	s1,s2,s8
    80000be8:	94d6                	add	s1,s1,s5
        if (n > len)
    80000bea:	fc99f3e3          	bgeu	s3,s1,80000bb0 <copyin+0x28>
    80000bee:	84ce                	mv	s1,s3
    80000bf0:	b7c1                	j	80000bb0 <copyin+0x28>
    }
    return 0;
    80000bf2:	4501                	li	a0,0
    80000bf4:	a021                	j	80000bfc <copyin+0x74>
    80000bf6:	4501                	li	a0,0
}
    80000bf8:	8082                	ret
            return -1;
    80000bfa:	557d                	li	a0,-1
}
    80000bfc:	60a6                	ld	ra,72(sp)
    80000bfe:	6406                	ld	s0,64(sp)
    80000c00:	74e2                	ld	s1,56(sp)
    80000c02:	7942                	ld	s2,48(sp)
    80000c04:	79a2                	ld	s3,40(sp)
    80000c06:	7a02                	ld	s4,32(sp)
    80000c08:	6ae2                	ld	s5,24(sp)
    80000c0a:	6b42                	ld	s6,16(sp)
    80000c0c:	6ba2                	ld	s7,8(sp)
    80000c0e:	6c02                	ld	s8,0(sp)
    80000c10:	6161                	addi	sp,sp,80
    80000c12:	8082                	ret

0000000080000c14 <copyinstr>:
int copyinstr(pagetable_t pagetable, char *dst, uint64 srcva, uint64 max)
{
    uint64 n, va0, pa0;
    int got_null = 0;

    while (got_null == 0 && max > 0)
    80000c14:	c6c5                	beqz	a3,80000cbc <copyinstr+0xa8>
{
    80000c16:	715d                	addi	sp,sp,-80
    80000c18:	e486                	sd	ra,72(sp)
    80000c1a:	e0a2                	sd	s0,64(sp)
    80000c1c:	fc26                	sd	s1,56(sp)
    80000c1e:	f84a                	sd	s2,48(sp)
    80000c20:	f44e                	sd	s3,40(sp)
    80000c22:	f052                	sd	s4,32(sp)
    80000c24:	ec56                	sd	s5,24(sp)
    80000c26:	e85a                	sd	s6,16(sp)
    80000c28:	e45e                	sd	s7,8(sp)
    80000c2a:	0880                	addi	s0,sp,80
    80000c2c:	8a2a                	mv	s4,a0
    80000c2e:	8b2e                	mv	s6,a1
    80000c30:	8bb2                	mv	s7,a2
    80000c32:	84b6                	mv	s1,a3
    {
        va0 = PGROUNDDOWN(srcva);
    80000c34:	7afd                	lui	s5,0xfffff
        pa0 = walkaddr(pagetable, va0);
        if (pa0 == 0)
            return -1;
        n = PGSIZE - (srcva - va0);
    80000c36:	6985                	lui	s3,0x1
    80000c38:	a035                	j	80000c64 <copyinstr+0x50>
        char *p = (char *)(pa0 + (srcva - va0));
        while (n > 0)
        {
            if (*p == '\0')
            {
                *dst = '\0';
    80000c3a:	00078023          	sb	zero,0(a5) # 1000 <_entry-0x7ffff000>
    80000c3e:	4785                	li	a5,1
            dst++;
        }

        srcva = va0 + PGSIZE;
    }
    if (got_null)
    80000c40:	0017b793          	seqz	a5,a5
    80000c44:	40f00533          	neg	a0,a5
    }
    else
    {
        return -1;
    }
}
    80000c48:	60a6                	ld	ra,72(sp)
    80000c4a:	6406                	ld	s0,64(sp)
    80000c4c:	74e2                	ld	s1,56(sp)
    80000c4e:	7942                	ld	s2,48(sp)
    80000c50:	79a2                	ld	s3,40(sp)
    80000c52:	7a02                	ld	s4,32(sp)
    80000c54:	6ae2                	ld	s5,24(sp)
    80000c56:	6b42                	ld	s6,16(sp)
    80000c58:	6ba2                	ld	s7,8(sp)
    80000c5a:	6161                	addi	sp,sp,80
    80000c5c:	8082                	ret
        srcva = va0 + PGSIZE;
    80000c5e:	01390bb3          	add	s7,s2,s3
    while (got_null == 0 && max > 0)
    80000c62:	c8a9                	beqz	s1,80000cb4 <copyinstr+0xa0>
        va0 = PGROUNDDOWN(srcva);
    80000c64:	015bf933          	and	s2,s7,s5
        pa0 = walkaddr(pagetable, va0);
    80000c68:	85ca                	mv	a1,s2
    80000c6a:	8552                	mv	a0,s4
    80000c6c:	00000097          	auipc	ra,0x0
    80000c70:	89e080e7          	jalr	-1890(ra) # 8000050a <walkaddr>
        if (pa0 == 0)
    80000c74:	c131                	beqz	a0,80000cb8 <copyinstr+0xa4>
        n = PGSIZE - (srcva - va0);
    80000c76:	41790833          	sub	a6,s2,s7
    80000c7a:	984e                	add	a6,a6,s3
        if (n > max)
    80000c7c:	0104f363          	bgeu	s1,a6,80000c82 <copyinstr+0x6e>
    80000c80:	8826                	mv	a6,s1
        char *p = (char *)(pa0 + (srcva - va0));
    80000c82:	955e                	add	a0,a0,s7
    80000c84:	41250533          	sub	a0,a0,s2
        while (n > 0)
    80000c88:	fc080be3          	beqz	a6,80000c5e <copyinstr+0x4a>
    80000c8c:	985a                	add	a6,a6,s6
    80000c8e:	87da                	mv	a5,s6
            if (*p == '\0')
    80000c90:	41650633          	sub	a2,a0,s6
    80000c94:	14fd                	addi	s1,s1,-1
    80000c96:	9b26                	add	s6,s6,s1
    80000c98:	00f60733          	add	a4,a2,a5
    80000c9c:	00074703          	lbu	a4,0(a4)
    80000ca0:	df49                	beqz	a4,80000c3a <copyinstr+0x26>
                *dst = *p;
    80000ca2:	00e78023          	sb	a4,0(a5)
            --max;
    80000ca6:	40fb04b3          	sub	s1,s6,a5
            dst++;
    80000caa:	0785                	addi	a5,a5,1
        while (n > 0)
    80000cac:	ff0796e3          	bne	a5,a6,80000c98 <copyinstr+0x84>
            dst++;
    80000cb0:	8b42                	mv	s6,a6
    80000cb2:	b775                	j	80000c5e <copyinstr+0x4a>
    80000cb4:	4781                	li	a5,0
    80000cb6:	b769                	j	80000c40 <copyinstr+0x2c>
            return -1;
    80000cb8:	557d                	li	a0,-1
    80000cba:	b779                	j	80000c48 <copyinstr+0x34>
    int got_null = 0;
    80000cbc:	4781                	li	a5,0
    if (got_null)
    80000cbe:	0017b793          	seqz	a5,a5
    80000cc2:	40f00533          	neg	a0,a5
}
    80000cc6:	8082                	ret

0000000080000cc8 <proc_mapstacks>:

// Allocate a page for each process's kernel stack.
// Map it high in memory, followed by an invalid
// guard page.
void proc_mapstacks(pagetable_t kpgtbl)
{
    80000cc8:	7139                	addi	sp,sp,-64
    80000cca:	fc06                	sd	ra,56(sp)
    80000ccc:	f822                	sd	s0,48(sp)
    80000cce:	f426                	sd	s1,40(sp)
    80000cd0:	f04a                	sd	s2,32(sp)
    80000cd2:	ec4e                	sd	s3,24(sp)
    80000cd4:	e852                	sd	s4,16(sp)
    80000cd6:	e456                	sd	s5,8(sp)
    80000cd8:	e05a                	sd	s6,0(sp)
    80000cda:	0080                	addi	s0,sp,64
    80000cdc:	89aa                	mv	s3,a0
    struct proc *p;

    for (p = proc; p < &proc[NPROC]; p++)
    80000cde:	00008497          	auipc	s1,0x8
    80000ce2:	07248493          	addi	s1,s1,114 # 80008d50 <proc>
    {
        char *pa = kalloc();
        if (pa == 0)
            panic("kalloc");
        uint64 va = KSTACK((int)(p - proc));
    80000ce6:	8b26                	mv	s6,s1
    80000ce8:	00007a97          	auipc	s5,0x7
    80000cec:	318a8a93          	addi	s5,s5,792 # 80008000 <etext>
    80000cf0:	04000937          	lui	s2,0x4000
    80000cf4:	197d                	addi	s2,s2,-1
    80000cf6:	0932                	slli	s2,s2,0xc
    for (p = proc; p < &proc[NPROC]; p++)
    80000cf8:	00020a17          	auipc	s4,0x20
    80000cfc:	a58a0a13          	addi	s4,s4,-1448 # 80020750 <tickslock>
        char *pa = kalloc();
    80000d00:	fffff097          	auipc	ra,0xfffff
    80000d04:	418080e7          	jalr	1048(ra) # 80000118 <kalloc>
    80000d08:	862a                	mv	a2,a0
        if (pa == 0)
    80000d0a:	c131                	beqz	a0,80000d4e <proc_mapstacks+0x86>
        uint64 va = KSTACK((int)(p - proc));
    80000d0c:	416485b3          	sub	a1,s1,s6
    80000d10:	858d                	srai	a1,a1,0x3
    80000d12:	000ab783          	ld	a5,0(s5)
    80000d16:	02f585b3          	mul	a1,a1,a5
    80000d1a:	2585                	addiw	a1,a1,1
    80000d1c:	00d5959b          	slliw	a1,a1,0xd
        kvmmap(kpgtbl, va, (uint64)pa, PGSIZE, PTE_R | PTE_W);
    80000d20:	4719                	li	a4,6
    80000d22:	6685                	lui	a3,0x1
    80000d24:	40b905b3          	sub	a1,s2,a1
    80000d28:	854e                	mv	a0,s3
    80000d2a:	00000097          	auipc	ra,0x0
    80000d2e:	8c2080e7          	jalr	-1854(ra) # 800005ec <kvmmap>
    for (p = proc; p < &proc[NPROC]; p++)
    80000d32:	5e848493          	addi	s1,s1,1512
    80000d36:	fd4495e3          	bne	s1,s4,80000d00 <proc_mapstacks+0x38>
    }
}
    80000d3a:	70e2                	ld	ra,56(sp)
    80000d3c:	7442                	ld	s0,48(sp)
    80000d3e:	74a2                	ld	s1,40(sp)
    80000d40:	7902                	ld	s2,32(sp)
    80000d42:	69e2                	ld	s3,24(sp)
    80000d44:	6a42                	ld	s4,16(sp)
    80000d46:	6aa2                	ld	s5,8(sp)
    80000d48:	6b02                	ld	s6,0(sp)
    80000d4a:	6121                	addi	sp,sp,64
    80000d4c:	8082                	ret
            panic("kalloc");
    80000d4e:	00007517          	auipc	a0,0x7
    80000d52:	3d250513          	addi	a0,a0,978 # 80008120 <etext+0x120>
    80000d56:	00005097          	auipc	ra,0x5
    80000d5a:	22c080e7          	jalr	556(ra) # 80005f82 <panic>

0000000080000d5e <procinit>:

// initialize the proc table.
void procinit(void)
{
    80000d5e:	7139                	addi	sp,sp,-64
    80000d60:	fc06                	sd	ra,56(sp)
    80000d62:	f822                	sd	s0,48(sp)
    80000d64:	f426                	sd	s1,40(sp)
    80000d66:	f04a                	sd	s2,32(sp)
    80000d68:	ec4e                	sd	s3,24(sp)
    80000d6a:	e852                	sd	s4,16(sp)
    80000d6c:	e456                	sd	s5,8(sp)
    80000d6e:	e05a                	sd	s6,0(sp)
    80000d70:	0080                	addi	s0,sp,64
    struct proc *p;

    initlock(&pid_lock, "nextpid");
    80000d72:	00007597          	auipc	a1,0x7
    80000d76:	3b658593          	addi	a1,a1,950 # 80008128 <etext+0x128>
    80000d7a:	00008517          	auipc	a0,0x8
    80000d7e:	ba650513          	addi	a0,a0,-1114 # 80008920 <pid_lock>
    80000d82:	00005097          	auipc	ra,0x5
    80000d86:	6ba080e7          	jalr	1722(ra) # 8000643c <initlock>
    initlock(&wait_lock, "wait_lock");
    80000d8a:	00007597          	auipc	a1,0x7
    80000d8e:	3a658593          	addi	a1,a1,934 # 80008130 <etext+0x130>
    80000d92:	00008517          	auipc	a0,0x8
    80000d96:	ba650513          	addi	a0,a0,-1114 # 80008938 <wait_lock>
    80000d9a:	00005097          	auipc	ra,0x5
    80000d9e:	6a2080e7          	jalr	1698(ra) # 8000643c <initlock>
    for (p = proc; p < &proc[NPROC]; p++)
    80000da2:	00008497          	auipc	s1,0x8
    80000da6:	fae48493          	addi	s1,s1,-82 # 80008d50 <proc>
    {
        initlock(&p->lock, "proc");
    80000daa:	00007b17          	auipc	s6,0x7
    80000dae:	396b0b13          	addi	s6,s6,918 # 80008140 <etext+0x140>
        p->state = UNUSED;
        p->kstack = KSTACK((int)(p - proc));
    80000db2:	8aa6                	mv	s5,s1
    80000db4:	00007a17          	auipc	s4,0x7
    80000db8:	24ca0a13          	addi	s4,s4,588 # 80008000 <etext>
    80000dbc:	04000937          	lui	s2,0x4000
    80000dc0:	197d                	addi	s2,s2,-1
    80000dc2:	0932                	slli	s2,s2,0xc
    for (p = proc; p < &proc[NPROC]; p++)
    80000dc4:	00020997          	auipc	s3,0x20
    80000dc8:	98c98993          	addi	s3,s3,-1652 # 80020750 <tickslock>
        initlock(&p->lock, "proc");
    80000dcc:	85da                	mv	a1,s6
    80000dce:	8526                	mv	a0,s1
    80000dd0:	00005097          	auipc	ra,0x5
    80000dd4:	66c080e7          	jalr	1644(ra) # 8000643c <initlock>
        p->state = UNUSED;
    80000dd8:	0004ac23          	sw	zero,24(s1)
        p->kstack = KSTACK((int)(p - proc));
    80000ddc:	415487b3          	sub	a5,s1,s5
    80000de0:	878d                	srai	a5,a5,0x3
    80000de2:	000a3703          	ld	a4,0(s4)
    80000de6:	02e787b3          	mul	a5,a5,a4
    80000dea:	2785                	addiw	a5,a5,1
    80000dec:	00d7979b          	slliw	a5,a5,0xd
    80000df0:	40f907b3          	sub	a5,s2,a5
    80000df4:	e0bc                	sd	a5,64(s1)
    for (p = proc; p < &proc[NPROC]; p++)
    80000df6:	5e848493          	addi	s1,s1,1512
    80000dfa:	fd3499e3          	bne	s1,s3,80000dcc <procinit+0x6e>
    }
}
    80000dfe:	70e2                	ld	ra,56(sp)
    80000e00:	7442                	ld	s0,48(sp)
    80000e02:	74a2                	ld	s1,40(sp)
    80000e04:	7902                	ld	s2,32(sp)
    80000e06:	69e2                	ld	s3,24(sp)
    80000e08:	6a42                	ld	s4,16(sp)
    80000e0a:	6aa2                	ld	s5,8(sp)
    80000e0c:	6b02                	ld	s6,0(sp)
    80000e0e:	6121                	addi	sp,sp,64
    80000e10:	8082                	ret

0000000080000e12 <cpuid>:

// Must be called with interrupts disabled,
// to prevent race with process being moved
// to a different CPU.
int cpuid()
{
    80000e12:	1141                	addi	sp,sp,-16
    80000e14:	e422                	sd	s0,8(sp)
    80000e16:	0800                	addi	s0,sp,16
  asm volatile("mv %0, tp" : "=r" (x) );
    80000e18:	8512                	mv	a0,tp
    int id = r_tp();
    return id;
}
    80000e1a:	2501                	sext.w	a0,a0
    80000e1c:	6422                	ld	s0,8(sp)
    80000e1e:	0141                	addi	sp,sp,16
    80000e20:	8082                	ret

0000000080000e22 <mycpu>:

// Return this CPU's cpu struct.
// Interrupts must be disabled.
struct cpu *
mycpu(void)
{
    80000e22:	1141                	addi	sp,sp,-16
    80000e24:	e422                	sd	s0,8(sp)
    80000e26:	0800                	addi	s0,sp,16
    80000e28:	8792                	mv	a5,tp
    int id = cpuid();
    struct cpu *c = &cpus[id];
    80000e2a:	2781                	sext.w	a5,a5
    80000e2c:	079e                	slli	a5,a5,0x7
    return c;
}
    80000e2e:	00008517          	auipc	a0,0x8
    80000e32:	b2250513          	addi	a0,a0,-1246 # 80008950 <cpus>
    80000e36:	953e                	add	a0,a0,a5
    80000e38:	6422                	ld	s0,8(sp)
    80000e3a:	0141                	addi	sp,sp,16
    80000e3c:	8082                	ret

0000000080000e3e <myproc>:

// Return the current struct proc *, or zero if none.
struct proc *
myproc(void)
{
    80000e3e:	1101                	addi	sp,sp,-32
    80000e40:	ec06                	sd	ra,24(sp)
    80000e42:	e822                	sd	s0,16(sp)
    80000e44:	e426                	sd	s1,8(sp)
    80000e46:	1000                	addi	s0,sp,32
    push_off();
    80000e48:	00005097          	auipc	ra,0x5
    80000e4c:	638080e7          	jalr	1592(ra) # 80006480 <push_off>
    80000e50:	8792                	mv	a5,tp
    struct cpu *c = mycpu();
    struct proc *p = c->proc;
    80000e52:	2781                	sext.w	a5,a5
    80000e54:	079e                	slli	a5,a5,0x7
    80000e56:	00008717          	auipc	a4,0x8
    80000e5a:	aca70713          	addi	a4,a4,-1334 # 80008920 <pid_lock>
    80000e5e:	97ba                	add	a5,a5,a4
    80000e60:	7b84                	ld	s1,48(a5)
    pop_off();
    80000e62:	00005097          	auipc	ra,0x5
    80000e66:	6be080e7          	jalr	1726(ra) # 80006520 <pop_off>
    return p;
}
    80000e6a:	8526                	mv	a0,s1
    80000e6c:	60e2                	ld	ra,24(sp)
    80000e6e:	6442                	ld	s0,16(sp)
    80000e70:	64a2                	ld	s1,8(sp)
    80000e72:	6105                	addi	sp,sp,32
    80000e74:	8082                	ret

0000000080000e76 <forkret>:
}

// A fork child's very first scheduling by scheduler()
// will swtch to forkret.
void forkret(void)
{
    80000e76:	1141                	addi	sp,sp,-16
    80000e78:	e406                	sd	ra,8(sp)
    80000e7a:	e022                	sd	s0,0(sp)
    80000e7c:	0800                	addi	s0,sp,16
    static int first = 1;

    // Still holding p->lock from scheduler.
    release(&myproc()->lock);
    80000e7e:	00000097          	auipc	ra,0x0
    80000e82:	fc0080e7          	jalr	-64(ra) # 80000e3e <myproc>
    80000e86:	00005097          	auipc	ra,0x5
    80000e8a:	6fa080e7          	jalr	1786(ra) # 80006580 <release>

    if (first)
    80000e8e:	00008797          	auipc	a5,0x8
    80000e92:	9d27a783          	lw	a5,-1582(a5) # 80008860 <first.1700>
    80000e96:	eb89                	bnez	a5,80000ea8 <forkret+0x32>
        // be run from main().
        first = 0;
        fsinit(ROOTDEV);
    }

    usertrapret();
    80000e98:	00001097          	auipc	ra,0x1
    80000e9c:	c96080e7          	jalr	-874(ra) # 80001b2e <usertrapret>
}
    80000ea0:	60a2                	ld	ra,8(sp)
    80000ea2:	6402                	ld	s0,0(sp)
    80000ea4:	0141                	addi	sp,sp,16
    80000ea6:	8082                	ret
        first = 0;
    80000ea8:	00008797          	auipc	a5,0x8
    80000eac:	9a07ac23          	sw	zero,-1608(a5) # 80008860 <first.1700>
        fsinit(ROOTDEV);
    80000eb0:	4505                	li	a0,1
    80000eb2:	00002097          	auipc	ra,0x2
    80000eb6:	ac4080e7          	jalr	-1340(ra) # 80002976 <fsinit>
    80000eba:	bff9                	j	80000e98 <forkret+0x22>

0000000080000ebc <allocpid>:
{
    80000ebc:	1101                	addi	sp,sp,-32
    80000ebe:	ec06                	sd	ra,24(sp)
    80000ec0:	e822                	sd	s0,16(sp)
    80000ec2:	e426                	sd	s1,8(sp)
    80000ec4:	e04a                	sd	s2,0(sp)
    80000ec6:	1000                	addi	s0,sp,32
    acquire(&pid_lock);
    80000ec8:	00008917          	auipc	s2,0x8
    80000ecc:	a5890913          	addi	s2,s2,-1448 # 80008920 <pid_lock>
    80000ed0:	854a                	mv	a0,s2
    80000ed2:	00005097          	auipc	ra,0x5
    80000ed6:	5fa080e7          	jalr	1530(ra) # 800064cc <acquire>
    pid = nextpid;
    80000eda:	00008797          	auipc	a5,0x8
    80000ede:	98a78793          	addi	a5,a5,-1654 # 80008864 <nextpid>
    80000ee2:	4384                	lw	s1,0(a5)
    nextpid = nextpid + 1;
    80000ee4:	0014871b          	addiw	a4,s1,1
    80000ee8:	c398                	sw	a4,0(a5)
    release(&pid_lock);
    80000eea:	854a                	mv	a0,s2
    80000eec:	00005097          	auipc	ra,0x5
    80000ef0:	694080e7          	jalr	1684(ra) # 80006580 <release>
}
    80000ef4:	8526                	mv	a0,s1
    80000ef6:	60e2                	ld	ra,24(sp)
    80000ef8:	6442                	ld	s0,16(sp)
    80000efa:	64a2                	ld	s1,8(sp)
    80000efc:	6902                	ld	s2,0(sp)
    80000efe:	6105                	addi	sp,sp,32
    80000f00:	8082                	ret

0000000080000f02 <proc_pagetable>:
{
    80000f02:	1101                	addi	sp,sp,-32
    80000f04:	ec06                	sd	ra,24(sp)
    80000f06:	e822                	sd	s0,16(sp)
    80000f08:	e426                	sd	s1,8(sp)
    80000f0a:	e04a                	sd	s2,0(sp)
    80000f0c:	1000                	addi	s0,sp,32
    80000f0e:	892a                	mv	s2,a0
    pagetable = uvmcreate();
    80000f10:	00000097          	auipc	ra,0x0
    80000f14:	8b8080e7          	jalr	-1864(ra) # 800007c8 <uvmcreate>
    80000f18:	84aa                	mv	s1,a0
    if (pagetable == 0)
    80000f1a:	c121                	beqz	a0,80000f5a <proc_pagetable+0x58>
    if (mappages(pagetable, TRAMPOLINE, PGSIZE,
    80000f1c:	4729                	li	a4,10
    80000f1e:	00006697          	auipc	a3,0x6
    80000f22:	0e268693          	addi	a3,a3,226 # 80007000 <_trampoline>
    80000f26:	6605                	lui	a2,0x1
    80000f28:	040005b7          	lui	a1,0x4000
    80000f2c:	15fd                	addi	a1,a1,-1
    80000f2e:	05b2                	slli	a1,a1,0xc
    80000f30:	fffff097          	auipc	ra,0xfffff
    80000f34:	61c080e7          	jalr	1564(ra) # 8000054c <mappages>
    80000f38:	02054863          	bltz	a0,80000f68 <proc_pagetable+0x66>
    if (mappages(pagetable, TRAPFRAME, PGSIZE,
    80000f3c:	4719                	li	a4,6
    80000f3e:	05893683          	ld	a3,88(s2)
    80000f42:	6605                	lui	a2,0x1
    80000f44:	020005b7          	lui	a1,0x2000
    80000f48:	15fd                	addi	a1,a1,-1
    80000f4a:	05b6                	slli	a1,a1,0xd
    80000f4c:	8526                	mv	a0,s1
    80000f4e:	fffff097          	auipc	ra,0xfffff
    80000f52:	5fe080e7          	jalr	1534(ra) # 8000054c <mappages>
    80000f56:	02054163          	bltz	a0,80000f78 <proc_pagetable+0x76>
}
    80000f5a:	8526                	mv	a0,s1
    80000f5c:	60e2                	ld	ra,24(sp)
    80000f5e:	6442                	ld	s0,16(sp)
    80000f60:	64a2                	ld	s1,8(sp)
    80000f62:	6902                	ld	s2,0(sp)
    80000f64:	6105                	addi	sp,sp,32
    80000f66:	8082                	ret
        uvmfree(pagetable, 0);
    80000f68:	4581                	li	a1,0
    80000f6a:	8526                	mv	a0,s1
    80000f6c:	00000097          	auipc	ra,0x0
    80000f70:	a60080e7          	jalr	-1440(ra) # 800009cc <uvmfree>
        return 0;
    80000f74:	4481                	li	s1,0
    80000f76:	b7d5                	j	80000f5a <proc_pagetable+0x58>
        uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000f78:	4681                	li	a3,0
    80000f7a:	4605                	li	a2,1
    80000f7c:	040005b7          	lui	a1,0x4000
    80000f80:	15fd                	addi	a1,a1,-1
    80000f82:	05b2                	slli	a1,a1,0xc
    80000f84:	8526                	mv	a0,s1
    80000f86:	fffff097          	auipc	ra,0xfffff
    80000f8a:	78c080e7          	jalr	1932(ra) # 80000712 <uvmunmap>
        uvmfree(pagetable, 0);
    80000f8e:	4581                	li	a1,0
    80000f90:	8526                	mv	a0,s1
    80000f92:	00000097          	auipc	ra,0x0
    80000f96:	a3a080e7          	jalr	-1478(ra) # 800009cc <uvmfree>
        return 0;
    80000f9a:	4481                	li	s1,0
    80000f9c:	bf7d                	j	80000f5a <proc_pagetable+0x58>

0000000080000f9e <proc_freepagetable>:
{
    80000f9e:	1101                	addi	sp,sp,-32
    80000fa0:	ec06                	sd	ra,24(sp)
    80000fa2:	e822                	sd	s0,16(sp)
    80000fa4:	e426                	sd	s1,8(sp)
    80000fa6:	e04a                	sd	s2,0(sp)
    80000fa8:	1000                	addi	s0,sp,32
    80000faa:	84aa                	mv	s1,a0
    80000fac:	892e                	mv	s2,a1
    uvmunmap(pagetable, TRAMPOLINE, 1, 0);
    80000fae:	4681                	li	a3,0
    80000fb0:	4605                	li	a2,1
    80000fb2:	040005b7          	lui	a1,0x4000
    80000fb6:	15fd                	addi	a1,a1,-1
    80000fb8:	05b2                	slli	a1,a1,0xc
    80000fba:	fffff097          	auipc	ra,0xfffff
    80000fbe:	758080e7          	jalr	1880(ra) # 80000712 <uvmunmap>
    uvmunmap(pagetable, TRAPFRAME, 1, 0);
    80000fc2:	4681                	li	a3,0
    80000fc4:	4605                	li	a2,1
    80000fc6:	020005b7          	lui	a1,0x2000
    80000fca:	15fd                	addi	a1,a1,-1
    80000fcc:	05b6                	slli	a1,a1,0xd
    80000fce:	8526                	mv	a0,s1
    80000fd0:	fffff097          	auipc	ra,0xfffff
    80000fd4:	742080e7          	jalr	1858(ra) # 80000712 <uvmunmap>
    uvmfree(pagetable, sz);
    80000fd8:	85ca                	mv	a1,s2
    80000fda:	8526                	mv	a0,s1
    80000fdc:	00000097          	auipc	ra,0x0
    80000fe0:	9f0080e7          	jalr	-1552(ra) # 800009cc <uvmfree>
}
    80000fe4:	60e2                	ld	ra,24(sp)
    80000fe6:	6442                	ld	s0,16(sp)
    80000fe8:	64a2                	ld	s1,8(sp)
    80000fea:	6902                	ld	s2,0(sp)
    80000fec:	6105                	addi	sp,sp,32
    80000fee:	8082                	ret

0000000080000ff0 <freeproc>:
{
    80000ff0:	1101                	addi	sp,sp,-32
    80000ff2:	ec06                	sd	ra,24(sp)
    80000ff4:	e822                	sd	s0,16(sp)
    80000ff6:	e426                	sd	s1,8(sp)
    80000ff8:	1000                	addi	s0,sp,32
    80000ffa:	84aa                	mv	s1,a0
    if (p->trapframe)
    80000ffc:	6d28                	ld	a0,88(a0)
    80000ffe:	c509                	beqz	a0,80001008 <freeproc+0x18>
        kfree((void *)p->trapframe);
    80001000:	fffff097          	auipc	ra,0xfffff
    80001004:	01c080e7          	jalr	28(ra) # 8000001c <kfree>
    p->trapframe = 0;
    80001008:	0404bc23          	sd	zero,88(s1)
    if (p->pagetable)
    8000100c:	68a8                	ld	a0,80(s1)
    8000100e:	c511                	beqz	a0,8000101a <freeproc+0x2a>
        proc_freepagetable(p->pagetable, p->sz);
    80001010:	64ac                	ld	a1,72(s1)
    80001012:	00000097          	auipc	ra,0x0
    80001016:	f8c080e7          	jalr	-116(ra) # 80000f9e <proc_freepagetable>
    p->pagetable = 0;
    8000101a:	0404b823          	sd	zero,80(s1)
    p->sz = 0;
    8000101e:	0404b423          	sd	zero,72(s1)
    p->pid = 0;
    80001022:	0204a823          	sw	zero,48(s1)
    p->parent = 0;
    80001026:	0204bc23          	sd	zero,56(s1)
    p->name[0] = 0;
    8000102a:	14048c23          	sb	zero,344(s1)
    p->chan = 0;
    8000102e:	0204b023          	sd	zero,32(s1)
    p->killed = 0;
    80001032:	0204a423          	sw	zero,40(s1)
    p->xstate = 0;
    80001036:	0204a623          	sw	zero,44(s1)
    p->state = UNUSED;
    8000103a:	0004ac23          	sw	zero,24(s1)
}
    8000103e:	60e2                	ld	ra,24(sp)
    80001040:	6442                	ld	s0,16(sp)
    80001042:	64a2                	ld	s1,8(sp)
    80001044:	6105                	addi	sp,sp,32
    80001046:	8082                	ret

0000000080001048 <allocproc>:
{
    80001048:	1101                	addi	sp,sp,-32
    8000104a:	ec06                	sd	ra,24(sp)
    8000104c:	e822                	sd	s0,16(sp)
    8000104e:	e426                	sd	s1,8(sp)
    80001050:	e04a                	sd	s2,0(sp)
    80001052:	1000                	addi	s0,sp,32
    for (p = proc; p < &proc[NPROC]; p++)
    80001054:	00008497          	auipc	s1,0x8
    80001058:	cfc48493          	addi	s1,s1,-772 # 80008d50 <proc>
    8000105c:	0001f917          	auipc	s2,0x1f
    80001060:	6f490913          	addi	s2,s2,1780 # 80020750 <tickslock>
        acquire(&p->lock);
    80001064:	8526                	mv	a0,s1
    80001066:	00005097          	auipc	ra,0x5
    8000106a:	466080e7          	jalr	1126(ra) # 800064cc <acquire>
        if (p->state == UNUSED)
    8000106e:	4c9c                	lw	a5,24(s1)
    80001070:	cf81                	beqz	a5,80001088 <allocproc+0x40>
            release(&p->lock);
    80001072:	8526                	mv	a0,s1
    80001074:	00005097          	auipc	ra,0x5
    80001078:	50c080e7          	jalr	1292(ra) # 80006580 <release>
    for (p = proc; p < &proc[NPROC]; p++)
    8000107c:	5e848493          	addi	s1,s1,1512
    80001080:	ff2492e3          	bne	s1,s2,80001064 <allocproc+0x1c>
    return 0;
    80001084:	4481                	li	s1,0
    80001086:	a889                	j	800010d8 <allocproc+0x90>
    p->pid = allocpid();
    80001088:	00000097          	auipc	ra,0x0
    8000108c:	e34080e7          	jalr	-460(ra) # 80000ebc <allocpid>
    80001090:	d888                	sw	a0,48(s1)
    p->state = USED;
    80001092:	4785                	li	a5,1
    80001094:	cc9c                	sw	a5,24(s1)
    if ((p->trapframe = (struct trapframe *)kalloc()) == 0)
    80001096:	fffff097          	auipc	ra,0xfffff
    8000109a:	082080e7          	jalr	130(ra) # 80000118 <kalloc>
    8000109e:	892a                	mv	s2,a0
    800010a0:	eca8                	sd	a0,88(s1)
    800010a2:	c131                	beqz	a0,800010e6 <allocproc+0x9e>
    p->pagetable = proc_pagetable(p);
    800010a4:	8526                	mv	a0,s1
    800010a6:	00000097          	auipc	ra,0x0
    800010aa:	e5c080e7          	jalr	-420(ra) # 80000f02 <proc_pagetable>
    800010ae:	892a                	mv	s2,a0
    800010b0:	e8a8                	sd	a0,80(s1)
    if (p->pagetable == 0)
    800010b2:	c531                	beqz	a0,800010fe <allocproc+0xb6>
    memset(&p->context, 0, sizeof(p->context));
    800010b4:	07000613          	li	a2,112
    800010b8:	4581                	li	a1,0
    800010ba:	06048513          	addi	a0,s1,96
    800010be:	fffff097          	auipc	ra,0xfffff
    800010c2:	0ba080e7          	jalr	186(ra) # 80000178 <memset>
    p->context.ra = (uint64)forkret;
    800010c6:	00000797          	auipc	a5,0x0
    800010ca:	db078793          	addi	a5,a5,-592 # 80000e76 <forkret>
    800010ce:	f0bc                	sd	a5,96(s1)
    p->context.sp = p->kstack + PGSIZE;
    800010d0:	60bc                	ld	a5,64(s1)
    800010d2:	6705                	lui	a4,0x1
    800010d4:	97ba                	add	a5,a5,a4
    800010d6:	f4bc                	sd	a5,104(s1)
}
    800010d8:	8526                	mv	a0,s1
    800010da:	60e2                	ld	ra,24(sp)
    800010dc:	6442                	ld	s0,16(sp)
    800010de:	64a2                	ld	s1,8(sp)
    800010e0:	6902                	ld	s2,0(sp)
    800010e2:	6105                	addi	sp,sp,32
    800010e4:	8082                	ret
        freeproc(p);
    800010e6:	8526                	mv	a0,s1
    800010e8:	00000097          	auipc	ra,0x0
    800010ec:	f08080e7          	jalr	-248(ra) # 80000ff0 <freeproc>
        release(&p->lock);
    800010f0:	8526                	mv	a0,s1
    800010f2:	00005097          	auipc	ra,0x5
    800010f6:	48e080e7          	jalr	1166(ra) # 80006580 <release>
        return 0;
    800010fa:	84ca                	mv	s1,s2
    800010fc:	bff1                	j	800010d8 <allocproc+0x90>
        freeproc(p);
    800010fe:	8526                	mv	a0,s1
    80001100:	00000097          	auipc	ra,0x0
    80001104:	ef0080e7          	jalr	-272(ra) # 80000ff0 <freeproc>
        release(&p->lock);
    80001108:	8526                	mv	a0,s1
    8000110a:	00005097          	auipc	ra,0x5
    8000110e:	476080e7          	jalr	1142(ra) # 80006580 <release>
        return 0;
    80001112:	84ca                	mv	s1,s2
    80001114:	b7d1                	j	800010d8 <allocproc+0x90>

0000000080001116 <userinit>:
{
    80001116:	1101                	addi	sp,sp,-32
    80001118:	ec06                	sd	ra,24(sp)
    8000111a:	e822                	sd	s0,16(sp)
    8000111c:	e426                	sd	s1,8(sp)
    8000111e:	1000                	addi	s0,sp,32
    p = allocproc();
    80001120:	00000097          	auipc	ra,0x0
    80001124:	f28080e7          	jalr	-216(ra) # 80001048 <allocproc>
    80001128:	84aa                	mv	s1,a0
    initproc = p;
    8000112a:	00007797          	auipc	a5,0x7
    8000112e:	7aa7bb23          	sd	a0,1974(a5) # 800088e0 <initproc>
    uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001132:	03400613          	li	a2,52
    80001136:	00007597          	auipc	a1,0x7
    8000113a:	73a58593          	addi	a1,a1,1850 # 80008870 <initcode>
    8000113e:	6928                	ld	a0,80(a0)
    80001140:	fffff097          	auipc	ra,0xfffff
    80001144:	6b6080e7          	jalr	1718(ra) # 800007f6 <uvmfirst>
    p->sz = PGSIZE;
    80001148:	6785                	lui	a5,0x1
    8000114a:	e4bc                	sd	a5,72(s1)
    p->trapframe->epc = 0;     // user program counter
    8000114c:	6cb8                	ld	a4,88(s1)
    8000114e:	00073c23          	sd	zero,24(a4) # 1018 <_entry-0x7fffefe8>
    p->trapframe->sp = PGSIZE; // user stack pointer
    80001152:	6cb8                	ld	a4,88(s1)
    80001154:	fb1c                	sd	a5,48(a4)
    safestrcpy(p->name, "initcode", sizeof(p->name));
    80001156:	4641                	li	a2,16
    80001158:	00007597          	auipc	a1,0x7
    8000115c:	ff058593          	addi	a1,a1,-16 # 80008148 <etext+0x148>
    80001160:	15848513          	addi	a0,s1,344
    80001164:	fffff097          	auipc	ra,0xfffff
    80001168:	166080e7          	jalr	358(ra) # 800002ca <safestrcpy>
    p->cwd = namei("/");
    8000116c:	00007517          	auipc	a0,0x7
    80001170:	fec50513          	addi	a0,a0,-20 # 80008158 <etext+0x158>
    80001174:	00002097          	auipc	ra,0x2
    80001178:	224080e7          	jalr	548(ra) # 80003398 <namei>
    8000117c:	14a4b823          	sd	a0,336(s1)
    p->state = RUNNABLE;
    80001180:	478d                	li	a5,3
    80001182:	cc9c                	sw	a5,24(s1)
    release(&p->lock);
    80001184:	8526                	mv	a0,s1
    80001186:	00005097          	auipc	ra,0x5
    8000118a:	3fa080e7          	jalr	1018(ra) # 80006580 <release>
}
    8000118e:	60e2                	ld	ra,24(sp)
    80001190:	6442                	ld	s0,16(sp)
    80001192:	64a2                	ld	s1,8(sp)
    80001194:	6105                	addi	sp,sp,32
    80001196:	8082                	ret

0000000080001198 <growproc>:
{
    80001198:	1101                	addi	sp,sp,-32
    8000119a:	ec06                	sd	ra,24(sp)
    8000119c:	e822                	sd	s0,16(sp)
    8000119e:	e426                	sd	s1,8(sp)
    800011a0:	e04a                	sd	s2,0(sp)
    800011a2:	1000                	addi	s0,sp,32
    800011a4:	892a                	mv	s2,a0
    struct proc *p = myproc();
    800011a6:	00000097          	auipc	ra,0x0
    800011aa:	c98080e7          	jalr	-872(ra) # 80000e3e <myproc>
    800011ae:	84aa                	mv	s1,a0
    sz = p->sz;
    800011b0:	652c                	ld	a1,72(a0)
    if (n > 0)
    800011b2:	01204c63          	bgtz	s2,800011ca <growproc+0x32>
    else if (n < 0)
    800011b6:	02094663          	bltz	s2,800011e2 <growproc+0x4a>
    p->sz = sz;
    800011ba:	e4ac                	sd	a1,72(s1)
    return 0;
    800011bc:	4501                	li	a0,0
}
    800011be:	60e2                	ld	ra,24(sp)
    800011c0:	6442                	ld	s0,16(sp)
    800011c2:	64a2                	ld	s1,8(sp)
    800011c4:	6902                	ld	s2,0(sp)
    800011c6:	6105                	addi	sp,sp,32
    800011c8:	8082                	ret
        if ((sz = uvmalloc(p->pagetable, sz, sz + n, PTE_W)) == 0)
    800011ca:	4691                	li	a3,4
    800011cc:	00b90633          	add	a2,s2,a1
    800011d0:	6928                	ld	a0,80(a0)
    800011d2:	fffff097          	auipc	ra,0xfffff
    800011d6:	6de080e7          	jalr	1758(ra) # 800008b0 <uvmalloc>
    800011da:	85aa                	mv	a1,a0
    800011dc:	fd79                	bnez	a0,800011ba <growproc+0x22>
            return -1;
    800011de:	557d                	li	a0,-1
    800011e0:	bff9                	j	800011be <growproc+0x26>
        sz = uvmdealloc(p->pagetable, sz, sz + n);
    800011e2:	00b90633          	add	a2,s2,a1
    800011e6:	6928                	ld	a0,80(a0)
    800011e8:	fffff097          	auipc	ra,0xfffff
    800011ec:	680080e7          	jalr	1664(ra) # 80000868 <uvmdealloc>
    800011f0:	85aa                	mv	a1,a0
    800011f2:	b7e1                	j	800011ba <growproc+0x22>

00000000800011f4 <fork>:
{
    800011f4:	7179                	addi	sp,sp,-48
    800011f6:	f406                	sd	ra,40(sp)
    800011f8:	f022                	sd	s0,32(sp)
    800011fa:	ec26                	sd	s1,24(sp)
    800011fc:	e84a                	sd	s2,16(sp)
    800011fe:	e44e                	sd	s3,8(sp)
    80001200:	e052                	sd	s4,0(sp)
    80001202:	1800                	addi	s0,sp,48
    struct proc *p = myproc();
    80001204:	00000097          	auipc	ra,0x0
    80001208:	c3a080e7          	jalr	-966(ra) # 80000e3e <myproc>
    8000120c:	892a                	mv	s2,a0
    if ((np = allocproc()) == 0)
    8000120e:	00000097          	auipc	ra,0x0
    80001212:	e3a080e7          	jalr	-454(ra) # 80001048 <allocproc>
    80001216:	14050b63          	beqz	a0,8000136c <fork+0x178>
    8000121a:	89aa                	mv	s3,a0
    if (uvmcopy(p->pagetable, np->pagetable, p->sz) < 0)
    8000121c:	04893603          	ld	a2,72(s2)
    80001220:	692c                	ld	a1,80(a0)
    80001222:	05093503          	ld	a0,80(s2)
    80001226:	fffff097          	auipc	ra,0xfffff
    8000122a:	7de080e7          	jalr	2014(ra) # 80000a04 <uvmcopy>
    8000122e:	08054663          	bltz	a0,800012ba <fork+0xc6>
    np->sz = p->sz;
    80001232:	04893783          	ld	a5,72(s2)
    80001236:	04f9b423          	sd	a5,72(s3)
    for (int i = VMASIZE - 1; i >= 0; i--)
    8000123a:	5a090793          	addi	a5,s2,1440
    8000123e:	5a098713          	addi	a4,s3,1440
    80001242:	12090613          	addi	a2,s2,288
        p_new_vma->occupied = p_odd_vma->occupied;
    80001246:	4394                	lw	a3,0(a5)
    80001248:	c314                	sw	a3,0(a4)
        p_new_vma->start_addr = p_odd_vma->start_addr;
    8000124a:	6794                	ld	a3,8(a5)
    8000124c:	e714                	sd	a3,8(a4)
        p_new_vma->end_addr = p_odd_vma->end_addr;
    8000124e:	6b94                	ld	a3,16(a5)
    80001250:	eb14                	sd	a3,16(a4)
        p_new_vma->addr = p_odd_vma->addr;
    80001252:	6f94                	ld	a3,24(a5)
    80001254:	ef14                	sd	a3,24(a4)
        p_new_vma->length = p_odd_vma->length;
    80001256:	7394                	ld	a3,32(a5)
    80001258:	f314                	sd	a3,32(a4)
        p_new_vma->prot = p_odd_vma->prot;
    8000125a:	5794                	lw	a3,40(a5)
    8000125c:	d714                	sw	a3,40(a4)
        p_new_vma->flags = p_odd_vma->flags;
    8000125e:	57d4                	lw	a3,44(a5)
    80001260:	d754                	sw	a3,44(a4)
        p_new_vma->fd = p_odd_vma->fd;
    80001262:	5b94                	lw	a3,48(a5)
    80001264:	db14                	sw	a3,48(a4)
        p_new_vma->offset = p_odd_vma->offset;
    80001266:	7f94                	ld	a3,56(a5)
    80001268:	ff14                	sd	a3,56(a4)
        p_new_vma->pf = p_odd_vma->pf;
    8000126a:	63b4                	ld	a3,64(a5)
    8000126c:	e334                	sd	a3,64(a4)
    for (int i = VMASIZE - 1; i >= 0; i--)
    8000126e:	fb878793          	addi	a5,a5,-72 # fb8 <_entry-0x7ffff048>
    80001272:	fb870713          	addi	a4,a4,-72
    80001276:	fcc798e3          	bne	a5,a2,80001246 <fork+0x52>
    *(np->trapframe) = *(p->trapframe);
    8000127a:	05893683          	ld	a3,88(s2)
    8000127e:	87b6                	mv	a5,a3
    80001280:	0589b703          	ld	a4,88(s3)
    80001284:	12068693          	addi	a3,a3,288
    80001288:	0007b803          	ld	a6,0(a5)
    8000128c:	6788                	ld	a0,8(a5)
    8000128e:	6b8c                	ld	a1,16(a5)
    80001290:	6f90                	ld	a2,24(a5)
    80001292:	01073023          	sd	a6,0(a4)
    80001296:	e708                	sd	a0,8(a4)
    80001298:	eb0c                	sd	a1,16(a4)
    8000129a:	ef10                	sd	a2,24(a4)
    8000129c:	02078793          	addi	a5,a5,32
    800012a0:	02070713          	addi	a4,a4,32
    800012a4:	fed792e3          	bne	a5,a3,80001288 <fork+0x94>
    np->trapframe->a0 = 0;
    800012a8:	0589b783          	ld	a5,88(s3)
    800012ac:	0607b823          	sd	zero,112(a5)
    800012b0:	0d000493          	li	s1,208
    for (i = 0; i < NOFILE; i++)
    800012b4:	15000a13          	li	s4,336
    800012b8:	a03d                	j	800012e6 <fork+0xf2>
        freeproc(np);
    800012ba:	854e                	mv	a0,s3
    800012bc:	00000097          	auipc	ra,0x0
    800012c0:	d34080e7          	jalr	-716(ra) # 80000ff0 <freeproc>
        release(&np->lock);
    800012c4:	854e                	mv	a0,s3
    800012c6:	00005097          	auipc	ra,0x5
    800012ca:	2ba080e7          	jalr	698(ra) # 80006580 <release>
        return -1;
    800012ce:	5a7d                	li	s4,-1
    800012d0:	a069                	j	8000135a <fork+0x166>
            np->ofile[i] = filedup(p->ofile[i]);
    800012d2:	00002097          	auipc	ra,0x2
    800012d6:	75c080e7          	jalr	1884(ra) # 80003a2e <filedup>
    800012da:	009987b3          	add	a5,s3,s1
    800012de:	e388                	sd	a0,0(a5)
    for (i = 0; i < NOFILE; i++)
    800012e0:	04a1                	addi	s1,s1,8
    800012e2:	01448763          	beq	s1,s4,800012f0 <fork+0xfc>
        if (p->ofile[i])
    800012e6:	009907b3          	add	a5,s2,s1
    800012ea:	6388                	ld	a0,0(a5)
    800012ec:	f17d                	bnez	a0,800012d2 <fork+0xde>
    800012ee:	bfcd                	j	800012e0 <fork+0xec>
    np->cwd = idup(p->cwd);
    800012f0:	15093503          	ld	a0,336(s2)
    800012f4:	00002097          	auipc	ra,0x2
    800012f8:	8c0080e7          	jalr	-1856(ra) # 80002bb4 <idup>
    800012fc:	14a9b823          	sd	a0,336(s3)
    safestrcpy(np->name, p->name, sizeof(p->name));
    80001300:	4641                	li	a2,16
    80001302:	15890593          	addi	a1,s2,344
    80001306:	15898513          	addi	a0,s3,344
    8000130a:	fffff097          	auipc	ra,0xfffff
    8000130e:	fc0080e7          	jalr	-64(ra) # 800002ca <safestrcpy>
    pid = np->pid;
    80001312:	0309aa03          	lw	s4,48(s3)
    release(&np->lock);
    80001316:	854e                	mv	a0,s3
    80001318:	00005097          	auipc	ra,0x5
    8000131c:	268080e7          	jalr	616(ra) # 80006580 <release>
    acquire(&wait_lock);
    80001320:	00007497          	auipc	s1,0x7
    80001324:	61848493          	addi	s1,s1,1560 # 80008938 <wait_lock>
    80001328:	8526                	mv	a0,s1
    8000132a:	00005097          	auipc	ra,0x5
    8000132e:	1a2080e7          	jalr	418(ra) # 800064cc <acquire>
    np->parent = p;
    80001332:	0329bc23          	sd	s2,56(s3)
    release(&wait_lock);
    80001336:	8526                	mv	a0,s1
    80001338:	00005097          	auipc	ra,0x5
    8000133c:	248080e7          	jalr	584(ra) # 80006580 <release>
    acquire(&np->lock);
    80001340:	854e                	mv	a0,s3
    80001342:	00005097          	auipc	ra,0x5
    80001346:	18a080e7          	jalr	394(ra) # 800064cc <acquire>
    np->state = RUNNABLE;
    8000134a:	478d                	li	a5,3
    8000134c:	00f9ac23          	sw	a5,24(s3)
    release(&np->lock);
    80001350:	854e                	mv	a0,s3
    80001352:	00005097          	auipc	ra,0x5
    80001356:	22e080e7          	jalr	558(ra) # 80006580 <release>
}
    8000135a:	8552                	mv	a0,s4
    8000135c:	70a2                	ld	ra,40(sp)
    8000135e:	7402                	ld	s0,32(sp)
    80001360:	64e2                	ld	s1,24(sp)
    80001362:	6942                	ld	s2,16(sp)
    80001364:	69a2                	ld	s3,8(sp)
    80001366:	6a02                	ld	s4,0(sp)
    80001368:	6145                	addi	sp,sp,48
    8000136a:	8082                	ret
        return -1;
    8000136c:	5a7d                	li	s4,-1
    8000136e:	b7f5                	j	8000135a <fork+0x166>

0000000080001370 <scheduler>:
{
    80001370:	7139                	addi	sp,sp,-64
    80001372:	fc06                	sd	ra,56(sp)
    80001374:	f822                	sd	s0,48(sp)
    80001376:	f426                	sd	s1,40(sp)
    80001378:	f04a                	sd	s2,32(sp)
    8000137a:	ec4e                	sd	s3,24(sp)
    8000137c:	e852                	sd	s4,16(sp)
    8000137e:	e456                	sd	s5,8(sp)
    80001380:	e05a                	sd	s6,0(sp)
    80001382:	0080                	addi	s0,sp,64
    80001384:	8792                	mv	a5,tp
    int id = r_tp();
    80001386:	2781                	sext.w	a5,a5
    c->proc = 0;
    80001388:	00779a93          	slli	s5,a5,0x7
    8000138c:	00007717          	auipc	a4,0x7
    80001390:	59470713          	addi	a4,a4,1428 # 80008920 <pid_lock>
    80001394:	9756                	add	a4,a4,s5
    80001396:	02073823          	sd	zero,48(a4)
                swtch(&c->context, &p->context);
    8000139a:	00007717          	auipc	a4,0x7
    8000139e:	5be70713          	addi	a4,a4,1470 # 80008958 <cpus+0x8>
    800013a2:	9aba                	add	s5,s5,a4
            if (p->state == RUNNABLE)
    800013a4:	498d                	li	s3,3
                p->state = RUNNING;
    800013a6:	4b11                	li	s6,4
                c->proc = p;
    800013a8:	079e                	slli	a5,a5,0x7
    800013aa:	00007a17          	auipc	s4,0x7
    800013ae:	576a0a13          	addi	s4,s4,1398 # 80008920 <pid_lock>
    800013b2:	9a3e                	add	s4,s4,a5
        for (p = proc; p < &proc[NPROC]; p++)
    800013b4:	0001f917          	auipc	s2,0x1f
    800013b8:	39c90913          	addi	s2,s2,924 # 80020750 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800013bc:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800013c0:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800013c4:	10079073          	csrw	sstatus,a5
    800013c8:	00008497          	auipc	s1,0x8
    800013cc:	98848493          	addi	s1,s1,-1656 # 80008d50 <proc>
    800013d0:	a03d                	j	800013fe <scheduler+0x8e>
                p->state = RUNNING;
    800013d2:	0164ac23          	sw	s6,24(s1)
                c->proc = p;
    800013d6:	029a3823          	sd	s1,48(s4)
                swtch(&c->context, &p->context);
    800013da:	06048593          	addi	a1,s1,96
    800013de:	8556                	mv	a0,s5
    800013e0:	00000097          	auipc	ra,0x0
    800013e4:	6a4080e7          	jalr	1700(ra) # 80001a84 <swtch>
                c->proc = 0;
    800013e8:	020a3823          	sd	zero,48(s4)
            release(&p->lock);
    800013ec:	8526                	mv	a0,s1
    800013ee:	00005097          	auipc	ra,0x5
    800013f2:	192080e7          	jalr	402(ra) # 80006580 <release>
        for (p = proc; p < &proc[NPROC]; p++)
    800013f6:	5e848493          	addi	s1,s1,1512
    800013fa:	fd2481e3          	beq	s1,s2,800013bc <scheduler+0x4c>
            acquire(&p->lock);
    800013fe:	8526                	mv	a0,s1
    80001400:	00005097          	auipc	ra,0x5
    80001404:	0cc080e7          	jalr	204(ra) # 800064cc <acquire>
            if (p->state == RUNNABLE)
    80001408:	4c9c                	lw	a5,24(s1)
    8000140a:	ff3791e3          	bne	a5,s3,800013ec <scheduler+0x7c>
    8000140e:	b7d1                	j	800013d2 <scheduler+0x62>

0000000080001410 <sched>:
{
    80001410:	7179                	addi	sp,sp,-48
    80001412:	f406                	sd	ra,40(sp)
    80001414:	f022                	sd	s0,32(sp)
    80001416:	ec26                	sd	s1,24(sp)
    80001418:	e84a                	sd	s2,16(sp)
    8000141a:	e44e                	sd	s3,8(sp)
    8000141c:	1800                	addi	s0,sp,48
    struct proc *p = myproc();
    8000141e:	00000097          	auipc	ra,0x0
    80001422:	a20080e7          	jalr	-1504(ra) # 80000e3e <myproc>
    80001426:	84aa                	mv	s1,a0
    if (!holding(&p->lock))
    80001428:	00005097          	auipc	ra,0x5
    8000142c:	02a080e7          	jalr	42(ra) # 80006452 <holding>
    80001430:	c93d                	beqz	a0,800014a6 <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001432:	8792                	mv	a5,tp
    if (mycpu()->noff != 1)
    80001434:	2781                	sext.w	a5,a5
    80001436:	079e                	slli	a5,a5,0x7
    80001438:	00007717          	auipc	a4,0x7
    8000143c:	4e870713          	addi	a4,a4,1256 # 80008920 <pid_lock>
    80001440:	97ba                	add	a5,a5,a4
    80001442:	0a87a703          	lw	a4,168(a5)
    80001446:	4785                	li	a5,1
    80001448:	06f71763          	bne	a4,a5,800014b6 <sched+0xa6>
    if (p->state == RUNNING)
    8000144c:	4c98                	lw	a4,24(s1)
    8000144e:	4791                	li	a5,4
    80001450:	06f70b63          	beq	a4,a5,800014c6 <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001454:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001458:	8b89                	andi	a5,a5,2
    if (intr_get())
    8000145a:	efb5                	bnez	a5,800014d6 <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000145c:	8792                	mv	a5,tp
    intena = mycpu()->intena;
    8000145e:	00007917          	auipc	s2,0x7
    80001462:	4c290913          	addi	s2,s2,1218 # 80008920 <pid_lock>
    80001466:	2781                	sext.w	a5,a5
    80001468:	079e                	slli	a5,a5,0x7
    8000146a:	97ca                	add	a5,a5,s2
    8000146c:	0ac7a983          	lw	s3,172(a5)
    80001470:	8792                	mv	a5,tp
    swtch(&p->context, &mycpu()->context);
    80001472:	2781                	sext.w	a5,a5
    80001474:	079e                	slli	a5,a5,0x7
    80001476:	00007597          	auipc	a1,0x7
    8000147a:	4e258593          	addi	a1,a1,1250 # 80008958 <cpus+0x8>
    8000147e:	95be                	add	a1,a1,a5
    80001480:	06048513          	addi	a0,s1,96
    80001484:	00000097          	auipc	ra,0x0
    80001488:	600080e7          	jalr	1536(ra) # 80001a84 <swtch>
    8000148c:	8792                	mv	a5,tp
    mycpu()->intena = intena;
    8000148e:	2781                	sext.w	a5,a5
    80001490:	079e                	slli	a5,a5,0x7
    80001492:	97ca                	add	a5,a5,s2
    80001494:	0b37a623          	sw	s3,172(a5)
}
    80001498:	70a2                	ld	ra,40(sp)
    8000149a:	7402                	ld	s0,32(sp)
    8000149c:	64e2                	ld	s1,24(sp)
    8000149e:	6942                	ld	s2,16(sp)
    800014a0:	69a2                	ld	s3,8(sp)
    800014a2:	6145                	addi	sp,sp,48
    800014a4:	8082                	ret
        panic("sched p->lock");
    800014a6:	00007517          	auipc	a0,0x7
    800014aa:	cba50513          	addi	a0,a0,-838 # 80008160 <etext+0x160>
    800014ae:	00005097          	auipc	ra,0x5
    800014b2:	ad4080e7          	jalr	-1324(ra) # 80005f82 <panic>
        panic("sched locks");
    800014b6:	00007517          	auipc	a0,0x7
    800014ba:	cba50513          	addi	a0,a0,-838 # 80008170 <etext+0x170>
    800014be:	00005097          	auipc	ra,0x5
    800014c2:	ac4080e7          	jalr	-1340(ra) # 80005f82 <panic>
        panic("sched running");
    800014c6:	00007517          	auipc	a0,0x7
    800014ca:	cba50513          	addi	a0,a0,-838 # 80008180 <etext+0x180>
    800014ce:	00005097          	auipc	ra,0x5
    800014d2:	ab4080e7          	jalr	-1356(ra) # 80005f82 <panic>
        panic("sched interruptible");
    800014d6:	00007517          	auipc	a0,0x7
    800014da:	cba50513          	addi	a0,a0,-838 # 80008190 <etext+0x190>
    800014de:	00005097          	auipc	ra,0x5
    800014e2:	aa4080e7          	jalr	-1372(ra) # 80005f82 <panic>

00000000800014e6 <yield>:
{
    800014e6:	1101                	addi	sp,sp,-32
    800014e8:	ec06                	sd	ra,24(sp)
    800014ea:	e822                	sd	s0,16(sp)
    800014ec:	e426                	sd	s1,8(sp)
    800014ee:	1000                	addi	s0,sp,32
    struct proc *p = myproc();
    800014f0:	00000097          	auipc	ra,0x0
    800014f4:	94e080e7          	jalr	-1714(ra) # 80000e3e <myproc>
    800014f8:	84aa                	mv	s1,a0
    acquire(&p->lock);
    800014fa:	00005097          	auipc	ra,0x5
    800014fe:	fd2080e7          	jalr	-46(ra) # 800064cc <acquire>
    p->state = RUNNABLE;
    80001502:	478d                	li	a5,3
    80001504:	cc9c                	sw	a5,24(s1)
    sched();
    80001506:	00000097          	auipc	ra,0x0
    8000150a:	f0a080e7          	jalr	-246(ra) # 80001410 <sched>
    release(&p->lock);
    8000150e:	8526                	mv	a0,s1
    80001510:	00005097          	auipc	ra,0x5
    80001514:	070080e7          	jalr	112(ra) # 80006580 <release>
}
    80001518:	60e2                	ld	ra,24(sp)
    8000151a:	6442                	ld	s0,16(sp)
    8000151c:	64a2                	ld	s1,8(sp)
    8000151e:	6105                	addi	sp,sp,32
    80001520:	8082                	ret

0000000080001522 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void sleep(void *chan, struct spinlock *lk)
{
    80001522:	7179                	addi	sp,sp,-48
    80001524:	f406                	sd	ra,40(sp)
    80001526:	f022                	sd	s0,32(sp)
    80001528:	ec26                	sd	s1,24(sp)
    8000152a:	e84a                	sd	s2,16(sp)
    8000152c:	e44e                	sd	s3,8(sp)
    8000152e:	1800                	addi	s0,sp,48
    80001530:	89aa                	mv	s3,a0
    80001532:	892e                	mv	s2,a1
    struct proc *p = myproc();
    80001534:	00000097          	auipc	ra,0x0
    80001538:	90a080e7          	jalr	-1782(ra) # 80000e3e <myproc>
    8000153c:	84aa                	mv	s1,a0
    // Once we hold p->lock, we can be
    // guaranteed that we won't miss any wakeup
    // (wakeup locks p->lock),
    // so it's okay to release lk.

    acquire(&p->lock); // DOC: sleeplock1
    8000153e:	00005097          	auipc	ra,0x5
    80001542:	f8e080e7          	jalr	-114(ra) # 800064cc <acquire>
    release(lk);
    80001546:	854a                	mv	a0,s2
    80001548:	00005097          	auipc	ra,0x5
    8000154c:	038080e7          	jalr	56(ra) # 80006580 <release>

    // Go to sleep.
    p->chan = chan;
    80001550:	0334b023          	sd	s3,32(s1)
    p->state = SLEEPING;
    80001554:	4789                	li	a5,2
    80001556:	cc9c                	sw	a5,24(s1)

    sched();
    80001558:	00000097          	auipc	ra,0x0
    8000155c:	eb8080e7          	jalr	-328(ra) # 80001410 <sched>

    // Tidy up.
    p->chan = 0;
    80001560:	0204b023          	sd	zero,32(s1)

    // Reacquire original lock.
    release(&p->lock);
    80001564:	8526                	mv	a0,s1
    80001566:	00005097          	auipc	ra,0x5
    8000156a:	01a080e7          	jalr	26(ra) # 80006580 <release>
    acquire(lk);
    8000156e:	854a                	mv	a0,s2
    80001570:	00005097          	auipc	ra,0x5
    80001574:	f5c080e7          	jalr	-164(ra) # 800064cc <acquire>
}
    80001578:	70a2                	ld	ra,40(sp)
    8000157a:	7402                	ld	s0,32(sp)
    8000157c:	64e2                	ld	s1,24(sp)
    8000157e:	6942                	ld	s2,16(sp)
    80001580:	69a2                	ld	s3,8(sp)
    80001582:	6145                	addi	sp,sp,48
    80001584:	8082                	ret

0000000080001586 <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void wakeup(void *chan)
{
    80001586:	7139                	addi	sp,sp,-64
    80001588:	fc06                	sd	ra,56(sp)
    8000158a:	f822                	sd	s0,48(sp)
    8000158c:	f426                	sd	s1,40(sp)
    8000158e:	f04a                	sd	s2,32(sp)
    80001590:	ec4e                	sd	s3,24(sp)
    80001592:	e852                	sd	s4,16(sp)
    80001594:	e456                	sd	s5,8(sp)
    80001596:	0080                	addi	s0,sp,64
    80001598:	8a2a                	mv	s4,a0
    struct proc *p;

    for (p = proc; p < &proc[NPROC]; p++)
    8000159a:	00007497          	auipc	s1,0x7
    8000159e:	7b648493          	addi	s1,s1,1974 # 80008d50 <proc>
    {
        if (p != myproc())
        {
            acquire(&p->lock);
            if (p->state == SLEEPING && p->chan == chan)
    800015a2:	4989                	li	s3,2
            {
                p->state = RUNNABLE;
    800015a4:	4a8d                	li	s5,3
    for (p = proc; p < &proc[NPROC]; p++)
    800015a6:	0001f917          	auipc	s2,0x1f
    800015aa:	1aa90913          	addi	s2,s2,426 # 80020750 <tickslock>
    800015ae:	a821                	j	800015c6 <wakeup+0x40>
                p->state = RUNNABLE;
    800015b0:	0154ac23          	sw	s5,24(s1)
            }
            release(&p->lock);
    800015b4:	8526                	mv	a0,s1
    800015b6:	00005097          	auipc	ra,0x5
    800015ba:	fca080e7          	jalr	-54(ra) # 80006580 <release>
    for (p = proc; p < &proc[NPROC]; p++)
    800015be:	5e848493          	addi	s1,s1,1512
    800015c2:	03248463          	beq	s1,s2,800015ea <wakeup+0x64>
        if (p != myproc())
    800015c6:	00000097          	auipc	ra,0x0
    800015ca:	878080e7          	jalr	-1928(ra) # 80000e3e <myproc>
    800015ce:	fea488e3          	beq	s1,a0,800015be <wakeup+0x38>
            acquire(&p->lock);
    800015d2:	8526                	mv	a0,s1
    800015d4:	00005097          	auipc	ra,0x5
    800015d8:	ef8080e7          	jalr	-264(ra) # 800064cc <acquire>
            if (p->state == SLEEPING && p->chan == chan)
    800015dc:	4c9c                	lw	a5,24(s1)
    800015de:	fd379be3          	bne	a5,s3,800015b4 <wakeup+0x2e>
    800015e2:	709c                	ld	a5,32(s1)
    800015e4:	fd4798e3          	bne	a5,s4,800015b4 <wakeup+0x2e>
    800015e8:	b7e1                	j	800015b0 <wakeup+0x2a>
        }
    }
}
    800015ea:	70e2                	ld	ra,56(sp)
    800015ec:	7442                	ld	s0,48(sp)
    800015ee:	74a2                	ld	s1,40(sp)
    800015f0:	7902                	ld	s2,32(sp)
    800015f2:	69e2                	ld	s3,24(sp)
    800015f4:	6a42                	ld	s4,16(sp)
    800015f6:	6aa2                	ld	s5,8(sp)
    800015f8:	6121                	addi	sp,sp,64
    800015fa:	8082                	ret

00000000800015fc <reparent>:
{
    800015fc:	7179                	addi	sp,sp,-48
    800015fe:	f406                	sd	ra,40(sp)
    80001600:	f022                	sd	s0,32(sp)
    80001602:	ec26                	sd	s1,24(sp)
    80001604:	e84a                	sd	s2,16(sp)
    80001606:	e44e                	sd	s3,8(sp)
    80001608:	e052                	sd	s4,0(sp)
    8000160a:	1800                	addi	s0,sp,48
    8000160c:	892a                	mv	s2,a0
    for (pp = proc; pp < &proc[NPROC]; pp++)
    8000160e:	00007497          	auipc	s1,0x7
    80001612:	74248493          	addi	s1,s1,1858 # 80008d50 <proc>
            pp->parent = initproc;
    80001616:	00007a17          	auipc	s4,0x7
    8000161a:	2caa0a13          	addi	s4,s4,714 # 800088e0 <initproc>
    for (pp = proc; pp < &proc[NPROC]; pp++)
    8000161e:	0001f997          	auipc	s3,0x1f
    80001622:	13298993          	addi	s3,s3,306 # 80020750 <tickslock>
    80001626:	a029                	j	80001630 <reparent+0x34>
    80001628:	5e848493          	addi	s1,s1,1512
    8000162c:	01348d63          	beq	s1,s3,80001646 <reparent+0x4a>
        if (pp->parent == p)
    80001630:	7c9c                	ld	a5,56(s1)
    80001632:	ff279be3          	bne	a5,s2,80001628 <reparent+0x2c>
            pp->parent = initproc;
    80001636:	000a3503          	ld	a0,0(s4)
    8000163a:	fc88                	sd	a0,56(s1)
            wakeup(initproc);
    8000163c:	00000097          	auipc	ra,0x0
    80001640:	f4a080e7          	jalr	-182(ra) # 80001586 <wakeup>
    80001644:	b7d5                	j	80001628 <reparent+0x2c>
}
    80001646:	70a2                	ld	ra,40(sp)
    80001648:	7402                	ld	s0,32(sp)
    8000164a:	64e2                	ld	s1,24(sp)
    8000164c:	6942                	ld	s2,16(sp)
    8000164e:	69a2                	ld	s3,8(sp)
    80001650:	6a02                	ld	s4,0(sp)
    80001652:	6145                	addi	sp,sp,48
    80001654:	8082                	ret

0000000080001656 <exit>:
{
    80001656:	7179                	addi	sp,sp,-48
    80001658:	f406                	sd	ra,40(sp)
    8000165a:	f022                	sd	s0,32(sp)
    8000165c:	ec26                	sd	s1,24(sp)
    8000165e:	e84a                	sd	s2,16(sp)
    80001660:	e44e                	sd	s3,8(sp)
    80001662:	e052                	sd	s4,0(sp)
    80001664:	1800                	addi	s0,sp,48
    80001666:	8a2a                	mv	s4,a0
    struct proc *p = myproc();
    80001668:	fffff097          	auipc	ra,0xfffff
    8000166c:	7d6080e7          	jalr	2006(ra) # 80000e3e <myproc>
    80001670:	89aa                	mv	s3,a0
    if (p == initproc)
    80001672:	00007797          	auipc	a5,0x7
    80001676:	26e7b783          	ld	a5,622(a5) # 800088e0 <initproc>
    8000167a:	0d050493          	addi	s1,a0,208
    8000167e:	15050913          	addi	s2,a0,336
    80001682:	02a79363          	bne	a5,a0,800016a8 <exit+0x52>
        panic("init exiting");
    80001686:	00007517          	auipc	a0,0x7
    8000168a:	b2250513          	addi	a0,a0,-1246 # 800081a8 <etext+0x1a8>
    8000168e:	00005097          	auipc	ra,0x5
    80001692:	8f4080e7          	jalr	-1804(ra) # 80005f82 <panic>
            fileclose(f);
    80001696:	00002097          	auipc	ra,0x2
    8000169a:	3ea080e7          	jalr	1002(ra) # 80003a80 <fileclose>
            p->ofile[fd] = 0;
    8000169e:	0004b023          	sd	zero,0(s1)
    for (int fd = 0; fd < NOFILE; fd++)
    800016a2:	04a1                	addi	s1,s1,8
    800016a4:	01248563          	beq	s1,s2,800016ae <exit+0x58>
        if (p->ofile[fd])
    800016a8:	6088                	ld	a0,0(s1)
    800016aa:	f575                	bnez	a0,80001696 <exit+0x40>
    800016ac:	bfdd                	j	800016a2 <exit+0x4c>
    begin_op();
    800016ae:	00002097          	auipc	ra,0x2
    800016b2:	f06080e7          	jalr	-250(ra) # 800035b4 <begin_op>
    iput(p->cwd);
    800016b6:	1509b503          	ld	a0,336(s3)
    800016ba:	00001097          	auipc	ra,0x1
    800016be:	6f2080e7          	jalr	1778(ra) # 80002dac <iput>
    end_op();
    800016c2:	00002097          	auipc	ra,0x2
    800016c6:	f72080e7          	jalr	-142(ra) # 80003634 <end_op>
    p->cwd = 0;
    800016ca:	1409b823          	sd	zero,336(s3)
    acquire(&wait_lock);
    800016ce:	00007497          	auipc	s1,0x7
    800016d2:	26a48493          	addi	s1,s1,618 # 80008938 <wait_lock>
    800016d6:	8526                	mv	a0,s1
    800016d8:	00005097          	auipc	ra,0x5
    800016dc:	df4080e7          	jalr	-524(ra) # 800064cc <acquire>
    reparent(p);
    800016e0:	854e                	mv	a0,s3
    800016e2:	00000097          	auipc	ra,0x0
    800016e6:	f1a080e7          	jalr	-230(ra) # 800015fc <reparent>
    wakeup(p->parent);
    800016ea:	0389b503          	ld	a0,56(s3)
    800016ee:	00000097          	auipc	ra,0x0
    800016f2:	e98080e7          	jalr	-360(ra) # 80001586 <wakeup>
    acquire(&p->lock);
    800016f6:	854e                	mv	a0,s3
    800016f8:	00005097          	auipc	ra,0x5
    800016fc:	dd4080e7          	jalr	-556(ra) # 800064cc <acquire>
    p->xstate = status;
    80001700:	0349a623          	sw	s4,44(s3)
    p->state = ZOMBIE;
    80001704:	4795                	li	a5,5
    80001706:	00f9ac23          	sw	a5,24(s3)
    release(&wait_lock);
    8000170a:	8526                	mv	a0,s1
    8000170c:	00005097          	auipc	ra,0x5
    80001710:	e74080e7          	jalr	-396(ra) # 80006580 <release>
    sched();
    80001714:	00000097          	auipc	ra,0x0
    80001718:	cfc080e7          	jalr	-772(ra) # 80001410 <sched>
    panic("zombie exit");
    8000171c:	00007517          	auipc	a0,0x7
    80001720:	a9c50513          	addi	a0,a0,-1380 # 800081b8 <etext+0x1b8>
    80001724:	00005097          	auipc	ra,0x5
    80001728:	85e080e7          	jalr	-1954(ra) # 80005f82 <panic>

000000008000172c <kill>:

// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int kill(int pid)
{
    8000172c:	7179                	addi	sp,sp,-48
    8000172e:	f406                	sd	ra,40(sp)
    80001730:	f022                	sd	s0,32(sp)
    80001732:	ec26                	sd	s1,24(sp)
    80001734:	e84a                	sd	s2,16(sp)
    80001736:	e44e                	sd	s3,8(sp)
    80001738:	1800                	addi	s0,sp,48
    8000173a:	892a                	mv	s2,a0
    struct proc *p;

    for (p = proc; p < &proc[NPROC]; p++)
    8000173c:	00007497          	auipc	s1,0x7
    80001740:	61448493          	addi	s1,s1,1556 # 80008d50 <proc>
    80001744:	0001f997          	auipc	s3,0x1f
    80001748:	00c98993          	addi	s3,s3,12 # 80020750 <tickslock>
    {
        acquire(&p->lock);
    8000174c:	8526                	mv	a0,s1
    8000174e:	00005097          	auipc	ra,0x5
    80001752:	d7e080e7          	jalr	-642(ra) # 800064cc <acquire>
        if (p->pid == pid)
    80001756:	589c                	lw	a5,48(s1)
    80001758:	01278d63          	beq	a5,s2,80001772 <kill+0x46>
                p->state = RUNNABLE;
            }
            release(&p->lock);
            return 0;
        }
        release(&p->lock);
    8000175c:	8526                	mv	a0,s1
    8000175e:	00005097          	auipc	ra,0x5
    80001762:	e22080e7          	jalr	-478(ra) # 80006580 <release>
    for (p = proc; p < &proc[NPROC]; p++)
    80001766:	5e848493          	addi	s1,s1,1512
    8000176a:	ff3491e3          	bne	s1,s3,8000174c <kill+0x20>
    }
    return -1;
    8000176e:	557d                	li	a0,-1
    80001770:	a829                	j	8000178a <kill+0x5e>
            p->killed = 1;
    80001772:	4785                	li	a5,1
    80001774:	d49c                	sw	a5,40(s1)
            if (p->state == SLEEPING)
    80001776:	4c98                	lw	a4,24(s1)
    80001778:	4789                	li	a5,2
    8000177a:	00f70f63          	beq	a4,a5,80001798 <kill+0x6c>
            release(&p->lock);
    8000177e:	8526                	mv	a0,s1
    80001780:	00005097          	auipc	ra,0x5
    80001784:	e00080e7          	jalr	-512(ra) # 80006580 <release>
            return 0;
    80001788:	4501                	li	a0,0
}
    8000178a:	70a2                	ld	ra,40(sp)
    8000178c:	7402                	ld	s0,32(sp)
    8000178e:	64e2                	ld	s1,24(sp)
    80001790:	6942                	ld	s2,16(sp)
    80001792:	69a2                	ld	s3,8(sp)
    80001794:	6145                	addi	sp,sp,48
    80001796:	8082                	ret
                p->state = RUNNABLE;
    80001798:	478d                	li	a5,3
    8000179a:	cc9c                	sw	a5,24(s1)
    8000179c:	b7cd                	j	8000177e <kill+0x52>

000000008000179e <setkilled>:

void setkilled(struct proc *p)
{
    8000179e:	1101                	addi	sp,sp,-32
    800017a0:	ec06                	sd	ra,24(sp)
    800017a2:	e822                	sd	s0,16(sp)
    800017a4:	e426                	sd	s1,8(sp)
    800017a6:	1000                	addi	s0,sp,32
    800017a8:	84aa                	mv	s1,a0
    acquire(&p->lock);
    800017aa:	00005097          	auipc	ra,0x5
    800017ae:	d22080e7          	jalr	-734(ra) # 800064cc <acquire>
    p->killed = 1;
    800017b2:	4785                	li	a5,1
    800017b4:	d49c                	sw	a5,40(s1)
    release(&p->lock);
    800017b6:	8526                	mv	a0,s1
    800017b8:	00005097          	auipc	ra,0x5
    800017bc:	dc8080e7          	jalr	-568(ra) # 80006580 <release>
}
    800017c0:	60e2                	ld	ra,24(sp)
    800017c2:	6442                	ld	s0,16(sp)
    800017c4:	64a2                	ld	s1,8(sp)
    800017c6:	6105                	addi	sp,sp,32
    800017c8:	8082                	ret

00000000800017ca <killed>:

int killed(struct proc *p)
{
    800017ca:	1101                	addi	sp,sp,-32
    800017cc:	ec06                	sd	ra,24(sp)
    800017ce:	e822                	sd	s0,16(sp)
    800017d0:	e426                	sd	s1,8(sp)
    800017d2:	e04a                	sd	s2,0(sp)
    800017d4:	1000                	addi	s0,sp,32
    800017d6:	84aa                	mv	s1,a0
    int k;

    acquire(&p->lock);
    800017d8:	00005097          	auipc	ra,0x5
    800017dc:	cf4080e7          	jalr	-780(ra) # 800064cc <acquire>
    k = p->killed;
    800017e0:	0284a903          	lw	s2,40(s1)
    release(&p->lock);
    800017e4:	8526                	mv	a0,s1
    800017e6:	00005097          	auipc	ra,0x5
    800017ea:	d9a080e7          	jalr	-614(ra) # 80006580 <release>
    return k;
}
    800017ee:	854a                	mv	a0,s2
    800017f0:	60e2                	ld	ra,24(sp)
    800017f2:	6442                	ld	s0,16(sp)
    800017f4:	64a2                	ld	s1,8(sp)
    800017f6:	6902                	ld	s2,0(sp)
    800017f8:	6105                	addi	sp,sp,32
    800017fa:	8082                	ret

00000000800017fc <wait>:
{
    800017fc:	715d                	addi	sp,sp,-80
    800017fe:	e486                	sd	ra,72(sp)
    80001800:	e0a2                	sd	s0,64(sp)
    80001802:	fc26                	sd	s1,56(sp)
    80001804:	f84a                	sd	s2,48(sp)
    80001806:	f44e                	sd	s3,40(sp)
    80001808:	f052                	sd	s4,32(sp)
    8000180a:	ec56                	sd	s5,24(sp)
    8000180c:	e85a                	sd	s6,16(sp)
    8000180e:	e45e                	sd	s7,8(sp)
    80001810:	e062                	sd	s8,0(sp)
    80001812:	0880                	addi	s0,sp,80
    80001814:	8b2a                	mv	s6,a0
    struct proc *p = myproc();
    80001816:	fffff097          	auipc	ra,0xfffff
    8000181a:	628080e7          	jalr	1576(ra) # 80000e3e <myproc>
    8000181e:	892a                	mv	s2,a0
    acquire(&wait_lock);
    80001820:	00007517          	auipc	a0,0x7
    80001824:	11850513          	addi	a0,a0,280 # 80008938 <wait_lock>
    80001828:	00005097          	auipc	ra,0x5
    8000182c:	ca4080e7          	jalr	-860(ra) # 800064cc <acquire>
        havekids = 0;
    80001830:	4b81                	li	s7,0
                if (pp->state == ZOMBIE)
    80001832:	4a15                	li	s4,5
        for (pp = proc; pp < &proc[NPROC]; pp++)
    80001834:	0001f997          	auipc	s3,0x1f
    80001838:	f1c98993          	addi	s3,s3,-228 # 80020750 <tickslock>
                havekids = 1;
    8000183c:	4a85                	li	s5,1
        sleep(p, &wait_lock); // DOC: wait-sleep
    8000183e:	00007c17          	auipc	s8,0x7
    80001842:	0fac0c13          	addi	s8,s8,250 # 80008938 <wait_lock>
        havekids = 0;
    80001846:	875e                	mv	a4,s7
        for (pp = proc; pp < &proc[NPROC]; pp++)
    80001848:	00007497          	auipc	s1,0x7
    8000184c:	50848493          	addi	s1,s1,1288 # 80008d50 <proc>
    80001850:	a0bd                	j	800018be <wait+0xc2>
                    pid = pp->pid;
    80001852:	0304a983          	lw	s3,48(s1)
                    if (addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    80001856:	000b0e63          	beqz	s6,80001872 <wait+0x76>
    8000185a:	4691                	li	a3,4
    8000185c:	02c48613          	addi	a2,s1,44
    80001860:	85da                	mv	a1,s6
    80001862:	05093503          	ld	a0,80(s2)
    80001866:	fffff097          	auipc	ra,0xfffff
    8000186a:	296080e7          	jalr	662(ra) # 80000afc <copyout>
    8000186e:	02054563          	bltz	a0,80001898 <wait+0x9c>
                    freeproc(pp);
    80001872:	8526                	mv	a0,s1
    80001874:	fffff097          	auipc	ra,0xfffff
    80001878:	77c080e7          	jalr	1916(ra) # 80000ff0 <freeproc>
                    release(&pp->lock);
    8000187c:	8526                	mv	a0,s1
    8000187e:	00005097          	auipc	ra,0x5
    80001882:	d02080e7          	jalr	-766(ra) # 80006580 <release>
                    release(&wait_lock);
    80001886:	00007517          	auipc	a0,0x7
    8000188a:	0b250513          	addi	a0,a0,178 # 80008938 <wait_lock>
    8000188e:	00005097          	auipc	ra,0x5
    80001892:	cf2080e7          	jalr	-782(ra) # 80006580 <release>
                    return pid;
    80001896:	a0b5                	j	80001902 <wait+0x106>
                        release(&pp->lock);
    80001898:	8526                	mv	a0,s1
    8000189a:	00005097          	auipc	ra,0x5
    8000189e:	ce6080e7          	jalr	-794(ra) # 80006580 <release>
                        release(&wait_lock);
    800018a2:	00007517          	auipc	a0,0x7
    800018a6:	09650513          	addi	a0,a0,150 # 80008938 <wait_lock>
    800018aa:	00005097          	auipc	ra,0x5
    800018ae:	cd6080e7          	jalr	-810(ra) # 80006580 <release>
                        return -1;
    800018b2:	59fd                	li	s3,-1
    800018b4:	a0b9                	j	80001902 <wait+0x106>
        for (pp = proc; pp < &proc[NPROC]; pp++)
    800018b6:	5e848493          	addi	s1,s1,1512
    800018ba:	03348463          	beq	s1,s3,800018e2 <wait+0xe6>
            if (pp->parent == p)
    800018be:	7c9c                	ld	a5,56(s1)
    800018c0:	ff279be3          	bne	a5,s2,800018b6 <wait+0xba>
                acquire(&pp->lock);
    800018c4:	8526                	mv	a0,s1
    800018c6:	00005097          	auipc	ra,0x5
    800018ca:	c06080e7          	jalr	-1018(ra) # 800064cc <acquire>
                if (pp->state == ZOMBIE)
    800018ce:	4c9c                	lw	a5,24(s1)
    800018d0:	f94781e3          	beq	a5,s4,80001852 <wait+0x56>
                release(&pp->lock);
    800018d4:	8526                	mv	a0,s1
    800018d6:	00005097          	auipc	ra,0x5
    800018da:	caa080e7          	jalr	-854(ra) # 80006580 <release>
                havekids = 1;
    800018de:	8756                	mv	a4,s5
    800018e0:	bfd9                	j	800018b6 <wait+0xba>
        if (!havekids || killed(p))
    800018e2:	c719                	beqz	a4,800018f0 <wait+0xf4>
    800018e4:	854a                	mv	a0,s2
    800018e6:	00000097          	auipc	ra,0x0
    800018ea:	ee4080e7          	jalr	-284(ra) # 800017ca <killed>
    800018ee:	c51d                	beqz	a0,8000191c <wait+0x120>
            release(&wait_lock);
    800018f0:	00007517          	auipc	a0,0x7
    800018f4:	04850513          	addi	a0,a0,72 # 80008938 <wait_lock>
    800018f8:	00005097          	auipc	ra,0x5
    800018fc:	c88080e7          	jalr	-888(ra) # 80006580 <release>
            return -1;
    80001900:	59fd                	li	s3,-1
}
    80001902:	854e                	mv	a0,s3
    80001904:	60a6                	ld	ra,72(sp)
    80001906:	6406                	ld	s0,64(sp)
    80001908:	74e2                	ld	s1,56(sp)
    8000190a:	7942                	ld	s2,48(sp)
    8000190c:	79a2                	ld	s3,40(sp)
    8000190e:	7a02                	ld	s4,32(sp)
    80001910:	6ae2                	ld	s5,24(sp)
    80001912:	6b42                	ld	s6,16(sp)
    80001914:	6ba2                	ld	s7,8(sp)
    80001916:	6c02                	ld	s8,0(sp)
    80001918:	6161                	addi	sp,sp,80
    8000191a:	8082                	ret
        sleep(p, &wait_lock); // DOC: wait-sleep
    8000191c:	85e2                	mv	a1,s8
    8000191e:	854a                	mv	a0,s2
    80001920:	00000097          	auipc	ra,0x0
    80001924:	c02080e7          	jalr	-1022(ra) # 80001522 <sleep>
        havekids = 0;
    80001928:	bf39                	j	80001846 <wait+0x4a>

000000008000192a <either_copyout>:

// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    8000192a:	7179                	addi	sp,sp,-48
    8000192c:	f406                	sd	ra,40(sp)
    8000192e:	f022                	sd	s0,32(sp)
    80001930:	ec26                	sd	s1,24(sp)
    80001932:	e84a                	sd	s2,16(sp)
    80001934:	e44e                	sd	s3,8(sp)
    80001936:	e052                	sd	s4,0(sp)
    80001938:	1800                	addi	s0,sp,48
    8000193a:	84aa                	mv	s1,a0
    8000193c:	892e                	mv	s2,a1
    8000193e:	89b2                	mv	s3,a2
    80001940:	8a36                	mv	s4,a3
    struct proc *p = myproc();
    80001942:	fffff097          	auipc	ra,0xfffff
    80001946:	4fc080e7          	jalr	1276(ra) # 80000e3e <myproc>
    if (user_dst)
    8000194a:	c08d                	beqz	s1,8000196c <either_copyout+0x42>
    {
        return copyout(p->pagetable, dst, src, len);
    8000194c:	86d2                	mv	a3,s4
    8000194e:	864e                	mv	a2,s3
    80001950:	85ca                	mv	a1,s2
    80001952:	6928                	ld	a0,80(a0)
    80001954:	fffff097          	auipc	ra,0xfffff
    80001958:	1a8080e7          	jalr	424(ra) # 80000afc <copyout>
    else
    {
        memmove((char *)dst, src, len);
        return 0;
    }
}
    8000195c:	70a2                	ld	ra,40(sp)
    8000195e:	7402                	ld	s0,32(sp)
    80001960:	64e2                	ld	s1,24(sp)
    80001962:	6942                	ld	s2,16(sp)
    80001964:	69a2                	ld	s3,8(sp)
    80001966:	6a02                	ld	s4,0(sp)
    80001968:	6145                	addi	sp,sp,48
    8000196a:	8082                	ret
        memmove((char *)dst, src, len);
    8000196c:	000a061b          	sext.w	a2,s4
    80001970:	85ce                	mv	a1,s3
    80001972:	854a                	mv	a0,s2
    80001974:	fffff097          	auipc	ra,0xfffff
    80001978:	864080e7          	jalr	-1948(ra) # 800001d8 <memmove>
        return 0;
    8000197c:	8526                	mv	a0,s1
    8000197e:	bff9                	j	8000195c <either_copyout+0x32>

0000000080001980 <either_copyin>:

// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    80001980:	7179                	addi	sp,sp,-48
    80001982:	f406                	sd	ra,40(sp)
    80001984:	f022                	sd	s0,32(sp)
    80001986:	ec26                	sd	s1,24(sp)
    80001988:	e84a                	sd	s2,16(sp)
    8000198a:	e44e                	sd	s3,8(sp)
    8000198c:	e052                	sd	s4,0(sp)
    8000198e:	1800                	addi	s0,sp,48
    80001990:	892a                	mv	s2,a0
    80001992:	84ae                	mv	s1,a1
    80001994:	89b2                	mv	s3,a2
    80001996:	8a36                	mv	s4,a3
    struct proc *p = myproc();
    80001998:	fffff097          	auipc	ra,0xfffff
    8000199c:	4a6080e7          	jalr	1190(ra) # 80000e3e <myproc>
    if (user_src)
    800019a0:	c08d                	beqz	s1,800019c2 <either_copyin+0x42>
    {
        return copyin(p->pagetable, dst, src, len);
    800019a2:	86d2                	mv	a3,s4
    800019a4:	864e                	mv	a2,s3
    800019a6:	85ca                	mv	a1,s2
    800019a8:	6928                	ld	a0,80(a0)
    800019aa:	fffff097          	auipc	ra,0xfffff
    800019ae:	1de080e7          	jalr	478(ra) # 80000b88 <copyin>
    else
    {
        memmove(dst, (char *)src, len);
        return 0;
    }
}
    800019b2:	70a2                	ld	ra,40(sp)
    800019b4:	7402                	ld	s0,32(sp)
    800019b6:	64e2                	ld	s1,24(sp)
    800019b8:	6942                	ld	s2,16(sp)
    800019ba:	69a2                	ld	s3,8(sp)
    800019bc:	6a02                	ld	s4,0(sp)
    800019be:	6145                	addi	sp,sp,48
    800019c0:	8082                	ret
        memmove(dst, (char *)src, len);
    800019c2:	000a061b          	sext.w	a2,s4
    800019c6:	85ce                	mv	a1,s3
    800019c8:	854a                	mv	a0,s2
    800019ca:	fffff097          	auipc	ra,0xfffff
    800019ce:	80e080e7          	jalr	-2034(ra) # 800001d8 <memmove>
        return 0;
    800019d2:	8526                	mv	a0,s1
    800019d4:	bff9                	j	800019b2 <either_copyin+0x32>

00000000800019d6 <procdump>:

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void procdump(void)
{
    800019d6:	715d                	addi	sp,sp,-80
    800019d8:	e486                	sd	ra,72(sp)
    800019da:	e0a2                	sd	s0,64(sp)
    800019dc:	fc26                	sd	s1,56(sp)
    800019de:	f84a                	sd	s2,48(sp)
    800019e0:	f44e                	sd	s3,40(sp)
    800019e2:	f052                	sd	s4,32(sp)
    800019e4:	ec56                	sd	s5,24(sp)
    800019e6:	e85a                	sd	s6,16(sp)
    800019e8:	e45e                	sd	s7,8(sp)
    800019ea:	0880                	addi	s0,sp,80
        [RUNNING] "run   ",
        [ZOMBIE] "zombie"};
    struct proc *p;
    char *state;

    printf("\n");
    800019ec:	00006517          	auipc	a0,0x6
    800019f0:	65c50513          	addi	a0,a0,1628 # 80008048 <etext+0x48>
    800019f4:	00004097          	auipc	ra,0x4
    800019f8:	5d8080e7          	jalr	1496(ra) # 80005fcc <printf>
    for (p = proc; p < &proc[NPROC]; p++)
    800019fc:	00007497          	auipc	s1,0x7
    80001a00:	4ac48493          	addi	s1,s1,1196 # 80008ea8 <proc+0x158>
    80001a04:	0001f917          	auipc	s2,0x1f
    80001a08:	ea490913          	addi	s2,s2,-348 # 800208a8 <bcache+0x140>
    {
        if (p->state == UNUSED)
            continue;
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a0c:	4b15                	li	s6,5
            state = states[p->state];
        else
            state = "???";
    80001a0e:	00006997          	auipc	s3,0x6
    80001a12:	7ba98993          	addi	s3,s3,1978 # 800081c8 <etext+0x1c8>
        printf("%d %s %s", p->pid, state, p->name);
    80001a16:	00006a97          	auipc	s5,0x6
    80001a1a:	7baa8a93          	addi	s5,s5,1978 # 800081d0 <etext+0x1d0>
        printf("\n");
    80001a1e:	00006a17          	auipc	s4,0x6
    80001a22:	62aa0a13          	addi	s4,s4,1578 # 80008048 <etext+0x48>
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a26:	00006b97          	auipc	s7,0x6
    80001a2a:	7eab8b93          	addi	s7,s7,2026 # 80008210 <states.1744>
    80001a2e:	a00d                	j	80001a50 <procdump+0x7a>
        printf("%d %s %s", p->pid, state, p->name);
    80001a30:	ed86a583          	lw	a1,-296(a3)
    80001a34:	8556                	mv	a0,s5
    80001a36:	00004097          	auipc	ra,0x4
    80001a3a:	596080e7          	jalr	1430(ra) # 80005fcc <printf>
        printf("\n");
    80001a3e:	8552                	mv	a0,s4
    80001a40:	00004097          	auipc	ra,0x4
    80001a44:	58c080e7          	jalr	1420(ra) # 80005fcc <printf>
    for (p = proc; p < &proc[NPROC]; p++)
    80001a48:	5e848493          	addi	s1,s1,1512
    80001a4c:	03248163          	beq	s1,s2,80001a6e <procdump+0x98>
        if (p->state == UNUSED)
    80001a50:	86a6                	mv	a3,s1
    80001a52:	ec04a783          	lw	a5,-320(s1)
    80001a56:	dbed                	beqz	a5,80001a48 <procdump+0x72>
            state = "???";
    80001a58:	864e                	mv	a2,s3
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a5a:	fcfb6be3          	bltu	s6,a5,80001a30 <procdump+0x5a>
    80001a5e:	1782                	slli	a5,a5,0x20
    80001a60:	9381                	srli	a5,a5,0x20
    80001a62:	078e                	slli	a5,a5,0x3
    80001a64:	97de                	add	a5,a5,s7
    80001a66:	6390                	ld	a2,0(a5)
    80001a68:	f661                	bnez	a2,80001a30 <procdump+0x5a>
            state = "???";
    80001a6a:	864e                	mv	a2,s3
    80001a6c:	b7d1                	j	80001a30 <procdump+0x5a>
    }
}
    80001a6e:	60a6                	ld	ra,72(sp)
    80001a70:	6406                	ld	s0,64(sp)
    80001a72:	74e2                	ld	s1,56(sp)
    80001a74:	7942                	ld	s2,48(sp)
    80001a76:	79a2                	ld	s3,40(sp)
    80001a78:	7a02                	ld	s4,32(sp)
    80001a7a:	6ae2                	ld	s5,24(sp)
    80001a7c:	6b42                	ld	s6,16(sp)
    80001a7e:	6ba2                	ld	s7,8(sp)
    80001a80:	6161                	addi	sp,sp,80
    80001a82:	8082                	ret

0000000080001a84 <swtch>:
    80001a84:	00153023          	sd	ra,0(a0)
    80001a88:	00253423          	sd	sp,8(a0)
    80001a8c:	e900                	sd	s0,16(a0)
    80001a8e:	ed04                	sd	s1,24(a0)
    80001a90:	03253023          	sd	s2,32(a0)
    80001a94:	03353423          	sd	s3,40(a0)
    80001a98:	03453823          	sd	s4,48(a0)
    80001a9c:	03553c23          	sd	s5,56(a0)
    80001aa0:	05653023          	sd	s6,64(a0)
    80001aa4:	05753423          	sd	s7,72(a0)
    80001aa8:	05853823          	sd	s8,80(a0)
    80001aac:	05953c23          	sd	s9,88(a0)
    80001ab0:	07a53023          	sd	s10,96(a0)
    80001ab4:	07b53423          	sd	s11,104(a0)
    80001ab8:	0005b083          	ld	ra,0(a1)
    80001abc:	0085b103          	ld	sp,8(a1)
    80001ac0:	6980                	ld	s0,16(a1)
    80001ac2:	6d84                	ld	s1,24(a1)
    80001ac4:	0205b903          	ld	s2,32(a1)
    80001ac8:	0285b983          	ld	s3,40(a1)
    80001acc:	0305ba03          	ld	s4,48(a1)
    80001ad0:	0385ba83          	ld	s5,56(a1)
    80001ad4:	0405bb03          	ld	s6,64(a1)
    80001ad8:	0485bb83          	ld	s7,72(a1)
    80001adc:	0505bc03          	ld	s8,80(a1)
    80001ae0:	0585bc83          	ld	s9,88(a1)
    80001ae4:	0605bd03          	ld	s10,96(a1)
    80001ae8:	0685bd83          	ld	s11,104(a1)
    80001aec:	8082                	ret

0000000080001aee <trapinit>:
void kernelvec();

extern int devintr();

void trapinit(void)
{
    80001aee:	1141                	addi	sp,sp,-16
    80001af0:	e406                	sd	ra,8(sp)
    80001af2:	e022                	sd	s0,0(sp)
    80001af4:	0800                	addi	s0,sp,16
    initlock(&tickslock, "time");
    80001af6:	00006597          	auipc	a1,0x6
    80001afa:	74a58593          	addi	a1,a1,1866 # 80008240 <states.1744+0x30>
    80001afe:	0001f517          	auipc	a0,0x1f
    80001b02:	c5250513          	addi	a0,a0,-942 # 80020750 <tickslock>
    80001b06:	00005097          	auipc	ra,0x5
    80001b0a:	936080e7          	jalr	-1738(ra) # 8000643c <initlock>
}
    80001b0e:	60a2                	ld	ra,8(sp)
    80001b10:	6402                	ld	s0,0(sp)
    80001b12:	0141                	addi	sp,sp,16
    80001b14:	8082                	ret

0000000080001b16 <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void trapinithart(void)
{
    80001b16:	1141                	addi	sp,sp,-16
    80001b18:	e422                	sd	s0,8(sp)
    80001b1a:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b1c:	00004797          	auipc	a5,0x4
    80001b20:	83478793          	addi	a5,a5,-1996 # 80005350 <kernelvec>
    80001b24:	10579073          	csrw	stvec,a5
    w_stvec((uint64)kernelvec);
}
    80001b28:	6422                	ld	s0,8(sp)
    80001b2a:	0141                	addi	sp,sp,16
    80001b2c:	8082                	ret

0000000080001b2e <usertrapret>:

//
// return to user space
//
void usertrapret(void)
{
    80001b2e:	1141                	addi	sp,sp,-16
    80001b30:	e406                	sd	ra,8(sp)
    80001b32:	e022                	sd	s0,0(sp)
    80001b34:	0800                	addi	s0,sp,16
    struct proc *p = myproc();
    80001b36:	fffff097          	auipc	ra,0xfffff
    80001b3a:	308080e7          	jalr	776(ra) # 80000e3e <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b3e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001b42:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b44:	10079073          	csrw	sstatus,a5
    // kerneltrap() to usertrap(), so turn off interrupts until
    // we're back in user space, where usertrap() is correct.
    intr_off();

    // send syscalls, interrupts, and exceptions to uservec in trampoline.S
    uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001b48:	00005617          	auipc	a2,0x5
    80001b4c:	4b860613          	addi	a2,a2,1208 # 80007000 <_trampoline>
    80001b50:	00005697          	auipc	a3,0x5
    80001b54:	4b068693          	addi	a3,a3,1200 # 80007000 <_trampoline>
    80001b58:	8e91                	sub	a3,a3,a2
    80001b5a:	040007b7          	lui	a5,0x4000
    80001b5e:	17fd                	addi	a5,a5,-1
    80001b60:	07b2                	slli	a5,a5,0xc
    80001b62:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b64:	10569073          	csrw	stvec,a3
    w_stvec(trampoline_uservec);

    // set up trapframe values that uservec will need when
    // the process next traps into the kernel.
    p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001b68:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001b6a:	180026f3          	csrr	a3,satp
    80001b6e:	e314                	sd	a3,0(a4)
    p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001b70:	6d38                	ld	a4,88(a0)
    80001b72:	6134                	ld	a3,64(a0)
    80001b74:	6585                	lui	a1,0x1
    80001b76:	96ae                	add	a3,a3,a1
    80001b78:	e714                	sd	a3,8(a4)
    p->trapframe->kernel_trap = (uint64)usertrap;
    80001b7a:	6d38                	ld	a4,88(a0)
    80001b7c:	00000697          	auipc	a3,0x0
    80001b80:	13068693          	addi	a3,a3,304 # 80001cac <usertrap>
    80001b84:	eb14                	sd	a3,16(a4)
    p->trapframe->kernel_hartid = r_tp(); // hartid for cpuid()
    80001b86:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001b88:	8692                	mv	a3,tp
    80001b8a:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b8c:	100026f3          	csrr	a3,sstatus
    // set up the registers that trampoline.S's sret will use
    // to get to user space.

    // set S Previous Privilege mode to User.
    unsigned long x = r_sstatus();
    x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001b90:	eff6f693          	andi	a3,a3,-257
    x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001b94:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b98:	10069073          	csrw	sstatus,a3
    w_sstatus(x);

    // set S Exception Program Counter to the saved user pc.
    w_sepc(p->trapframe->epc);
    80001b9c:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001b9e:	6f18                	ld	a4,24(a4)
    80001ba0:	14171073          	csrw	sepc,a4

    // tell trampoline.S the user page table to switch to.
    uint64 satp = MAKE_SATP(p->pagetable);
    80001ba4:	6928                	ld	a0,80(a0)
    80001ba6:	8131                	srli	a0,a0,0xc

    // jump to userret in trampoline.S at the top of memory, which
    // switches to the user page table, restores user registers,
    // and switches to user mode with sret.
    uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001ba8:	00005717          	auipc	a4,0x5
    80001bac:	4f470713          	addi	a4,a4,1268 # 8000709c <userret>
    80001bb0:	8f11                	sub	a4,a4,a2
    80001bb2:	97ba                	add	a5,a5,a4
    ((void (*)(uint64))trampoline_userret)(satp);
    80001bb4:	577d                	li	a4,-1
    80001bb6:	177e                	slli	a4,a4,0x3f
    80001bb8:	8d59                	or	a0,a0,a4
    80001bba:	9782                	jalr	a5
}
    80001bbc:	60a2                	ld	ra,8(sp)
    80001bbe:	6402                	ld	s0,0(sp)
    80001bc0:	0141                	addi	sp,sp,16
    80001bc2:	8082                	ret

0000000080001bc4 <clockintr>:
    w_sepc(sepc);
    w_sstatus(sstatus);
}

void clockintr()
{
    80001bc4:	1101                	addi	sp,sp,-32
    80001bc6:	ec06                	sd	ra,24(sp)
    80001bc8:	e822                	sd	s0,16(sp)
    80001bca:	e426                	sd	s1,8(sp)
    80001bcc:	1000                	addi	s0,sp,32
    acquire(&tickslock);
    80001bce:	0001f497          	auipc	s1,0x1f
    80001bd2:	b8248493          	addi	s1,s1,-1150 # 80020750 <tickslock>
    80001bd6:	8526                	mv	a0,s1
    80001bd8:	00005097          	auipc	ra,0x5
    80001bdc:	8f4080e7          	jalr	-1804(ra) # 800064cc <acquire>
    ticks++;
    80001be0:	00007517          	auipc	a0,0x7
    80001be4:	d0850513          	addi	a0,a0,-760 # 800088e8 <ticks>
    80001be8:	411c                	lw	a5,0(a0)
    80001bea:	2785                	addiw	a5,a5,1
    80001bec:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    80001bee:	00000097          	auipc	ra,0x0
    80001bf2:	998080e7          	jalr	-1640(ra) # 80001586 <wakeup>
    release(&tickslock);
    80001bf6:	8526                	mv	a0,s1
    80001bf8:	00005097          	auipc	ra,0x5
    80001bfc:	988080e7          	jalr	-1656(ra) # 80006580 <release>
}
    80001c00:	60e2                	ld	ra,24(sp)
    80001c02:	6442                	ld	s0,16(sp)
    80001c04:	64a2                	ld	s1,8(sp)
    80001c06:	6105                	addi	sp,sp,32
    80001c08:	8082                	ret

0000000080001c0a <devintr>:
// and handle it.
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int devintr()
{
    80001c0a:	1101                	addi	sp,sp,-32
    80001c0c:	ec06                	sd	ra,24(sp)
    80001c0e:	e822                	sd	s0,16(sp)
    80001c10:	e426                	sd	s1,8(sp)
    80001c12:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001c14:	14202773          	csrr	a4,scause
    uint64 scause = r_scause();

    if ((scause & 0x8000000000000000L) &&
    80001c18:	00074d63          	bltz	a4,80001c32 <devintr+0x28>
        if (irq)
            plic_complete(irq);

        return 1;
    }
    else if (scause == 0x8000000000000001L)
    80001c1c:	57fd                	li	a5,-1
    80001c1e:	17fe                	slli	a5,a5,0x3f
    80001c20:	0785                	addi	a5,a5,1

        return 2;
    }
    else
    {
        return 0;
    80001c22:	4501                	li	a0,0
    else if (scause == 0x8000000000000001L)
    80001c24:	06f70363          	beq	a4,a5,80001c8a <devintr+0x80>
    }
}
    80001c28:	60e2                	ld	ra,24(sp)
    80001c2a:	6442                	ld	s0,16(sp)
    80001c2c:	64a2                	ld	s1,8(sp)
    80001c2e:	6105                	addi	sp,sp,32
    80001c30:	8082                	ret
        (scause & 0xff) == 9)
    80001c32:	0ff77793          	andi	a5,a4,255
    if ((scause & 0x8000000000000000L) &&
    80001c36:	46a5                	li	a3,9
    80001c38:	fed792e3          	bne	a5,a3,80001c1c <devintr+0x12>
        int irq = plic_claim();
    80001c3c:	00004097          	auipc	ra,0x4
    80001c40:	81c080e7          	jalr	-2020(ra) # 80005458 <plic_claim>
    80001c44:	84aa                	mv	s1,a0
        if (irq == UART0_IRQ)
    80001c46:	47a9                	li	a5,10
    80001c48:	02f50763          	beq	a0,a5,80001c76 <devintr+0x6c>
        else if (irq == VIRTIO0_IRQ)
    80001c4c:	4785                	li	a5,1
    80001c4e:	02f50963          	beq	a0,a5,80001c80 <devintr+0x76>
        return 1;
    80001c52:	4505                	li	a0,1
        else if (irq)
    80001c54:	d8f1                	beqz	s1,80001c28 <devintr+0x1e>
            printf("unexpected interrupt irq=%d\n", irq);
    80001c56:	85a6                	mv	a1,s1
    80001c58:	00006517          	auipc	a0,0x6
    80001c5c:	5f050513          	addi	a0,a0,1520 # 80008248 <states.1744+0x38>
    80001c60:	00004097          	auipc	ra,0x4
    80001c64:	36c080e7          	jalr	876(ra) # 80005fcc <printf>
            plic_complete(irq);
    80001c68:	8526                	mv	a0,s1
    80001c6a:	00004097          	auipc	ra,0x4
    80001c6e:	812080e7          	jalr	-2030(ra) # 8000547c <plic_complete>
        return 1;
    80001c72:	4505                	li	a0,1
    80001c74:	bf55                	j	80001c28 <devintr+0x1e>
            uartintr();
    80001c76:	00004097          	auipc	ra,0x4
    80001c7a:	776080e7          	jalr	1910(ra) # 800063ec <uartintr>
    80001c7e:	b7ed                	j	80001c68 <devintr+0x5e>
            virtio_disk_intr();
    80001c80:	00004097          	auipc	ra,0x4
    80001c84:	d26080e7          	jalr	-730(ra) # 800059a6 <virtio_disk_intr>
    80001c88:	b7c5                	j	80001c68 <devintr+0x5e>
        if (cpuid() == 0)
    80001c8a:	fffff097          	auipc	ra,0xfffff
    80001c8e:	188080e7          	jalr	392(ra) # 80000e12 <cpuid>
    80001c92:	c901                	beqz	a0,80001ca2 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001c94:	144027f3          	csrr	a5,sip
        w_sip(r_sip() & ~2);
    80001c98:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001c9a:	14479073          	csrw	sip,a5
        return 2;
    80001c9e:	4509                	li	a0,2
    80001ca0:	b761                	j	80001c28 <devintr+0x1e>
            clockintr();
    80001ca2:	00000097          	auipc	ra,0x0
    80001ca6:	f22080e7          	jalr	-222(ra) # 80001bc4 <clockintr>
    80001caa:	b7ed                	j	80001c94 <devintr+0x8a>

0000000080001cac <usertrap>:
{
    80001cac:	7139                	addi	sp,sp,-64
    80001cae:	fc06                	sd	ra,56(sp)
    80001cb0:	f822                	sd	s0,48(sp)
    80001cb2:	f426                	sd	s1,40(sp)
    80001cb4:	f04a                	sd	s2,32(sp)
    80001cb6:	ec4e                	sd	s3,24(sp)
    80001cb8:	e852                	sd	s4,16(sp)
    80001cba:	e456                	sd	s5,8(sp)
    80001cbc:	e05a                	sd	s6,0(sp)
    80001cbe:	0080                	addi	s0,sp,64
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001cc0:	100027f3          	csrr	a5,sstatus
    if ((r_sstatus() & SSTATUS_SPP) != 0)
    80001cc4:	1007f793          	andi	a5,a5,256
    80001cc8:	e7c1                	bnez	a5,80001d50 <usertrap+0xa4>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001cca:	00003797          	auipc	a5,0x3
    80001cce:	68678793          	addi	a5,a5,1670 # 80005350 <kernelvec>
    80001cd2:	10579073          	csrw	stvec,a5
    struct proc *p = myproc();
    80001cd6:	fffff097          	auipc	ra,0xfffff
    80001cda:	168080e7          	jalr	360(ra) # 80000e3e <myproc>
    80001cde:	892a                	mv	s2,a0
    p->trapframe->epc = r_sepc();
    80001ce0:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001ce2:	14102773          	csrr	a4,sepc
    80001ce6:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001ce8:	14202773          	csrr	a4,scause
    if (r_scause() == 8)
    80001cec:	47a1                	li	a5,8
    80001cee:	06f70963          	beq	a4,a5,80001d60 <usertrap+0xb4>
    else if ((which_dev = devintr()) != 0)
    80001cf2:	00000097          	auipc	ra,0x0
    80001cf6:	f18080e7          	jalr	-232(ra) # 80001c0a <devintr>
    80001cfa:	84aa                	mv	s1,a0
    80001cfc:	18051063          	bnez	a0,80001e7c <usertrap+0x1d0>
    80001d00:	14202773          	csrr	a4,scause
    else if (r_scause() == 13 || r_scause() == 15)
    80001d04:	47b5                	li	a5,13
    80001d06:	0af70b63          	beq	a4,a5,80001dbc <usertrap+0x110>
    80001d0a:	14202773          	csrr	a4,scause
    80001d0e:	47bd                	li	a5,15
    80001d10:	0af70663          	beq	a4,a5,80001dbc <usertrap+0x110>
    80001d14:	142025f3          	csrr	a1,scause
        printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001d18:	03092603          	lw	a2,48(s2)
    80001d1c:	00006517          	auipc	a0,0x6
    80001d20:	59450513          	addi	a0,a0,1428 # 800082b0 <states.1744+0xa0>
    80001d24:	00004097          	auipc	ra,0x4
    80001d28:	2a8080e7          	jalr	680(ra) # 80005fcc <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d2c:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001d30:	14302673          	csrr	a2,stval
        printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001d34:	00006517          	auipc	a0,0x6
    80001d38:	5ac50513          	addi	a0,a0,1452 # 800082e0 <states.1744+0xd0>
    80001d3c:	00004097          	auipc	ra,0x4
    80001d40:	290080e7          	jalr	656(ra) # 80005fcc <printf>
        setkilled(p);
    80001d44:	854a                	mv	a0,s2
    80001d46:	00000097          	auipc	ra,0x0
    80001d4a:	a58080e7          	jalr	-1448(ra) # 8000179e <setkilled>
    80001d4e:	a82d                	j	80001d88 <usertrap+0xdc>
        panic("usertrap: not from user mode");
    80001d50:	00006517          	auipc	a0,0x6
    80001d54:	51850513          	addi	a0,a0,1304 # 80008268 <states.1744+0x58>
    80001d58:	00004097          	auipc	ra,0x4
    80001d5c:	22a080e7          	jalr	554(ra) # 80005f82 <panic>
        if (killed(p))
    80001d60:	00000097          	auipc	ra,0x0
    80001d64:	a6a080e7          	jalr	-1430(ra) # 800017ca <killed>
    80001d68:	e521                	bnez	a0,80001db0 <usertrap+0x104>
        p->trapframe->epc += 4;
    80001d6a:	05893703          	ld	a4,88(s2)
    80001d6e:	6f1c                	ld	a5,24(a4)
    80001d70:	0791                	addi	a5,a5,4
    80001d72:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d74:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001d78:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001d7c:	10079073          	csrw	sstatus,a5
        syscall();
    80001d80:	00000097          	auipc	ra,0x0
    80001d84:	370080e7          	jalr	880(ra) # 800020f0 <syscall>
    if (killed(p))
    80001d88:	854a                	mv	a0,s2
    80001d8a:	00000097          	auipc	ra,0x0
    80001d8e:	a40080e7          	jalr	-1472(ra) # 800017ca <killed>
    80001d92:	ed65                	bnez	a0,80001e8a <usertrap+0x1de>
    usertrapret();
    80001d94:	00000097          	auipc	ra,0x0
    80001d98:	d9a080e7          	jalr	-614(ra) # 80001b2e <usertrapret>
}
    80001d9c:	70e2                	ld	ra,56(sp)
    80001d9e:	7442                	ld	s0,48(sp)
    80001da0:	74a2                	ld	s1,40(sp)
    80001da2:	7902                	ld	s2,32(sp)
    80001da4:	69e2                	ld	s3,24(sp)
    80001da6:	6a42                	ld	s4,16(sp)
    80001da8:	6aa2                	ld	s5,8(sp)
    80001daa:	6b02                	ld	s6,0(sp)
    80001dac:	6121                	addi	sp,sp,64
    80001dae:	8082                	ret
            exit(-1);
    80001db0:	557d                	li	a0,-1
    80001db2:	00000097          	auipc	ra,0x0
    80001db6:	8a4080e7          	jalr	-1884(ra) # 80001656 <exit>
    80001dba:	bf45                	j	80001d6a <usertrap+0xbe>
        struct proc *p_proc = myproc();
    80001dbc:	fffff097          	auipc	ra,0xfffff
    80001dc0:	082080e7          	jalr	130(ra) # 80000e3e <myproc>
    80001dc4:	8a2a                	mv	s4,a0
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001dc6:	143029f3          	csrr	s3,stval
        for (int i = 0; i <= VMASIZE - 1; i++)
    80001dca:	16850793          	addi	a5,a0,360
            if (p_proc->vma[i].occupied == 1)
    80001dce:	4605                	li	a2,1
        for (int i = 0; i <= VMASIZE - 1; i++)
    80001dd0:	45c1                	li	a1,16
    80001dd2:	a031                	j	80001dde <usertrap+0x132>
    80001dd4:	2485                	addiw	s1,s1,1
    80001dd6:	04878793          	addi	a5,a5,72
    80001dda:	08b48863          	beq	s1,a1,80001e6a <usertrap+0x1be>
            if (p_proc->vma[i].occupied == 1)
    80001dde:	4398                	lw	a4,0(a5)
    80001de0:	fec71ae3          	bne	a4,a2,80001dd4 <usertrap+0x128>
                if (p_proc->vma[i].start_addr <= va && va <= p_proc->vma[i].end_addr)
    80001de4:	6798                	ld	a4,8(a5)
    80001de6:	fee9e7e3          	bltu	s3,a4,80001dd4 <usertrap+0x128>
    80001dea:	6b98                	ld	a4,16(a5)
    80001dec:	ff3764e3          	bltu	a4,s3,80001dd4 <usertrap+0x128>
            char *mem = (char *)kalloc(); // find spare space
    80001df0:	ffffe097          	auipc	ra,0xffffe
    80001df4:	328080e7          	jalr	808(ra) # 80000118 <kalloc>
    80001df8:	8b2a                	mv	s6,a0
            if (mem == 0)
    80001dfa:	c135                	beqz	a0,80001e5e <usertrap+0x1b2>
                memset(mem, 0, PGSIZE);
    80001dfc:	6605                	lui	a2,0x1
    80001dfe:	4581                	li	a1,0
    80001e00:	ffffe097          	auipc	ra,0xffffe
    80001e04:	378080e7          	jalr	888(ra) # 80000178 <memset>
                mapfile(p_vma->pf, mem, va - p_vma->start_addr);
    80001e08:	00349a93          	slli	s5,s1,0x3
    80001e0c:	009a87b3          	add	a5,s5,s1
    80001e10:	078e                	slli	a5,a5,0x3
    80001e12:	97d2                	add	a5,a5,s4
    80001e14:	1707b603          	ld	a2,368(a5)
    80001e18:	40c9863b          	subw	a2,s3,a2
    80001e1c:	85da                	mv	a1,s6
    80001e1e:	1a87b503          	ld	a0,424(a5)
    80001e22:	00002097          	auipc	ra,0x2
    80001e26:	d98080e7          	jalr	-616(ra) # 80003bba <mapfile>
                int flags = (p_vma->prot | PTE_R | PTE_X | PTE_W | PTE_U);
    80001e2a:	009a87b3          	add	a5,s5,s1
    80001e2e:	078e                	slli	a5,a5,0x3
    80001e30:	97d2                	add	a5,a5,s4
    80001e32:	1907a703          	lw	a4,400(a5)
                if (mappages(p_proc->pagetable, va, PGSIZE, (uint64)mem, flags) == -1)
    80001e36:	01e76713          	ori	a4,a4,30
    80001e3a:	86da                	mv	a3,s6
    80001e3c:	6605                	lui	a2,0x1
    80001e3e:	85ce                	mv	a1,s3
    80001e40:	050a3503          	ld	a0,80(s4)
    80001e44:	ffffe097          	auipc	ra,0xffffe
    80001e48:	708080e7          	jalr	1800(ra) # 8000054c <mappages>
    80001e4c:	57fd                	li	a5,-1
    80001e4e:	f2f51de3          	bne	a0,a5,80001d88 <usertrap+0xdc>
                    setkilled(p_proc);
    80001e52:	8552                	mv	a0,s4
    80001e54:	00000097          	auipc	ra,0x0
    80001e58:	94a080e7          	jalr	-1718(ra) # 8000179e <setkilled>
    80001e5c:	b735                	j	80001d88 <usertrap+0xdc>
                setkilled(p_proc);
    80001e5e:	8552                	mv	a0,s4
    80001e60:	00000097          	auipc	ra,0x0
    80001e64:	93e080e7          	jalr	-1730(ra) # 8000179e <setkilled>
    80001e68:	b705                	j	80001d88 <usertrap+0xdc>
            printf("Now, after mmap, we get a page fault\n");
    80001e6a:	00006517          	auipc	a0,0x6
    80001e6e:	41e50513          	addi	a0,a0,1054 # 80008288 <states.1744+0x78>
    80001e72:	00004097          	auipc	ra,0x4
    80001e76:	15a080e7          	jalr	346(ra) # 80005fcc <printf>
            goto err;
    80001e7a:	bd69                	j	80001d14 <usertrap+0x68>
    if (killed(p))
    80001e7c:	854a                	mv	a0,s2
    80001e7e:	00000097          	auipc	ra,0x0
    80001e82:	94c080e7          	jalr	-1716(ra) # 800017ca <killed>
    80001e86:	c901                	beqz	a0,80001e96 <usertrap+0x1ea>
    80001e88:	a011                	j	80001e8c <usertrap+0x1e0>
    80001e8a:	4481                	li	s1,0
        exit(-1);
    80001e8c:	557d                	li	a0,-1
    80001e8e:	fffff097          	auipc	ra,0xfffff
    80001e92:	7c8080e7          	jalr	1992(ra) # 80001656 <exit>
    if (which_dev == 2)
    80001e96:	4789                	li	a5,2
    80001e98:	eef49ee3          	bne	s1,a5,80001d94 <usertrap+0xe8>
        yield();
    80001e9c:	fffff097          	auipc	ra,0xfffff
    80001ea0:	64a080e7          	jalr	1610(ra) # 800014e6 <yield>
    80001ea4:	bdc5                	j	80001d94 <usertrap+0xe8>

0000000080001ea6 <kerneltrap>:
{
    80001ea6:	7179                	addi	sp,sp,-48
    80001ea8:	f406                	sd	ra,40(sp)
    80001eaa:	f022                	sd	s0,32(sp)
    80001eac:	ec26                	sd	s1,24(sp)
    80001eae:	e84a                	sd	s2,16(sp)
    80001eb0:	e44e                	sd	s3,8(sp)
    80001eb2:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001eb4:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001eb8:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001ebc:	142029f3          	csrr	s3,scause
    if ((sstatus & SSTATUS_SPP) == 0)
    80001ec0:	1004f793          	andi	a5,s1,256
    80001ec4:	cb85                	beqz	a5,80001ef4 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ec6:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001eca:	8b89                	andi	a5,a5,2
    if (intr_get() != 0)
    80001ecc:	ef85                	bnez	a5,80001f04 <kerneltrap+0x5e>
    if ((which_dev = devintr()) == 0)
    80001ece:	00000097          	auipc	ra,0x0
    80001ed2:	d3c080e7          	jalr	-708(ra) # 80001c0a <devintr>
    80001ed6:	cd1d                	beqz	a0,80001f14 <kerneltrap+0x6e>
    if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001ed8:	4789                	li	a5,2
    80001eda:	06f50a63          	beq	a0,a5,80001f4e <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001ede:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001ee2:	10049073          	csrw	sstatus,s1
}
    80001ee6:	70a2                	ld	ra,40(sp)
    80001ee8:	7402                	ld	s0,32(sp)
    80001eea:	64e2                	ld	s1,24(sp)
    80001eec:	6942                	ld	s2,16(sp)
    80001eee:	69a2                	ld	s3,8(sp)
    80001ef0:	6145                	addi	sp,sp,48
    80001ef2:	8082                	ret
        panic("kerneltrap: not from supervisor mode");
    80001ef4:	00006517          	auipc	a0,0x6
    80001ef8:	40c50513          	addi	a0,a0,1036 # 80008300 <states.1744+0xf0>
    80001efc:	00004097          	auipc	ra,0x4
    80001f00:	086080e7          	jalr	134(ra) # 80005f82 <panic>
        panic("kerneltrap: interrupts enabled");
    80001f04:	00006517          	auipc	a0,0x6
    80001f08:	42450513          	addi	a0,a0,1060 # 80008328 <states.1744+0x118>
    80001f0c:	00004097          	auipc	ra,0x4
    80001f10:	076080e7          	jalr	118(ra) # 80005f82 <panic>
        printf("scause %p\n", scause);
    80001f14:	85ce                	mv	a1,s3
    80001f16:	00006517          	auipc	a0,0x6
    80001f1a:	43250513          	addi	a0,a0,1074 # 80008348 <states.1744+0x138>
    80001f1e:	00004097          	auipc	ra,0x4
    80001f22:	0ae080e7          	jalr	174(ra) # 80005fcc <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f26:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001f2a:	14302673          	csrr	a2,stval
        printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001f2e:	00006517          	auipc	a0,0x6
    80001f32:	42a50513          	addi	a0,a0,1066 # 80008358 <states.1744+0x148>
    80001f36:	00004097          	auipc	ra,0x4
    80001f3a:	096080e7          	jalr	150(ra) # 80005fcc <printf>
        panic("kerneltrap");
    80001f3e:	00006517          	auipc	a0,0x6
    80001f42:	43250513          	addi	a0,a0,1074 # 80008370 <states.1744+0x160>
    80001f46:	00004097          	auipc	ra,0x4
    80001f4a:	03c080e7          	jalr	60(ra) # 80005f82 <panic>
    if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001f4e:	fffff097          	auipc	ra,0xfffff
    80001f52:	ef0080e7          	jalr	-272(ra) # 80000e3e <myproc>
    80001f56:	d541                	beqz	a0,80001ede <kerneltrap+0x38>
    80001f58:	fffff097          	auipc	ra,0xfffff
    80001f5c:	ee6080e7          	jalr	-282(ra) # 80000e3e <myproc>
    80001f60:	4d18                	lw	a4,24(a0)
    80001f62:	4791                	li	a5,4
    80001f64:	f6f71de3          	bne	a4,a5,80001ede <kerneltrap+0x38>
        yield();
    80001f68:	fffff097          	auipc	ra,0xfffff
    80001f6c:	57e080e7          	jalr	1406(ra) # 800014e6 <yield>
    80001f70:	b7bd                	j	80001ede <kerneltrap+0x38>

0000000080001f72 <argraw>:
    return strlen(buf);
}

static uint64
argraw(int n)
{
    80001f72:	1101                	addi	sp,sp,-32
    80001f74:	ec06                	sd	ra,24(sp)
    80001f76:	e822                	sd	s0,16(sp)
    80001f78:	e426                	sd	s1,8(sp)
    80001f7a:	1000                	addi	s0,sp,32
    80001f7c:	84aa                	mv	s1,a0
    struct proc *p = myproc();
    80001f7e:	fffff097          	auipc	ra,0xfffff
    80001f82:	ec0080e7          	jalr	-320(ra) # 80000e3e <myproc>
    switch (n)
    80001f86:	4795                	li	a5,5
    80001f88:	0497e163          	bltu	a5,s1,80001fca <argraw+0x58>
    80001f8c:	048a                	slli	s1,s1,0x2
    80001f8e:	00006717          	auipc	a4,0x6
    80001f92:	41a70713          	addi	a4,a4,1050 # 800083a8 <states.1744+0x198>
    80001f96:	94ba                	add	s1,s1,a4
    80001f98:	409c                	lw	a5,0(s1)
    80001f9a:	97ba                	add	a5,a5,a4
    80001f9c:	8782                	jr	a5
    {
    case 0:
        return p->trapframe->a0;
    80001f9e:	6d3c                	ld	a5,88(a0)
    80001fa0:	7ba8                	ld	a0,112(a5)
    case 5:
        return p->trapframe->a5;
    }
    panic("argraw");
    return -1;
}
    80001fa2:	60e2                	ld	ra,24(sp)
    80001fa4:	6442                	ld	s0,16(sp)
    80001fa6:	64a2                	ld	s1,8(sp)
    80001fa8:	6105                	addi	sp,sp,32
    80001faa:	8082                	ret
        return p->trapframe->a1;
    80001fac:	6d3c                	ld	a5,88(a0)
    80001fae:	7fa8                	ld	a0,120(a5)
    80001fb0:	bfcd                	j	80001fa2 <argraw+0x30>
        return p->trapframe->a2;
    80001fb2:	6d3c                	ld	a5,88(a0)
    80001fb4:	63c8                	ld	a0,128(a5)
    80001fb6:	b7f5                	j	80001fa2 <argraw+0x30>
        return p->trapframe->a3;
    80001fb8:	6d3c                	ld	a5,88(a0)
    80001fba:	67c8                	ld	a0,136(a5)
    80001fbc:	b7dd                	j	80001fa2 <argraw+0x30>
        return p->trapframe->a4;
    80001fbe:	6d3c                	ld	a5,88(a0)
    80001fc0:	6bc8                	ld	a0,144(a5)
    80001fc2:	b7c5                	j	80001fa2 <argraw+0x30>
        return p->trapframe->a5;
    80001fc4:	6d3c                	ld	a5,88(a0)
    80001fc6:	6fc8                	ld	a0,152(a5)
    80001fc8:	bfe9                	j	80001fa2 <argraw+0x30>
    panic("argraw");
    80001fca:	00006517          	auipc	a0,0x6
    80001fce:	3b650513          	addi	a0,a0,950 # 80008380 <states.1744+0x170>
    80001fd2:	00004097          	auipc	ra,0x4
    80001fd6:	fb0080e7          	jalr	-80(ra) # 80005f82 <panic>

0000000080001fda <fetchaddr>:
{
    80001fda:	1101                	addi	sp,sp,-32
    80001fdc:	ec06                	sd	ra,24(sp)
    80001fde:	e822                	sd	s0,16(sp)
    80001fe0:	e426                	sd	s1,8(sp)
    80001fe2:	e04a                	sd	s2,0(sp)
    80001fe4:	1000                	addi	s0,sp,32
    80001fe6:	84aa                	mv	s1,a0
    80001fe8:	892e                	mv	s2,a1
    struct proc *p = myproc();
    80001fea:	fffff097          	auipc	ra,0xfffff
    80001fee:	e54080e7          	jalr	-428(ra) # 80000e3e <myproc>
    if (addr >= p->sz || addr + sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80001ff2:	653c                	ld	a5,72(a0)
    80001ff4:	02f4f863          	bgeu	s1,a5,80002024 <fetchaddr+0x4a>
    80001ff8:	00848713          	addi	a4,s1,8
    80001ffc:	02e7e663          	bltu	a5,a4,80002028 <fetchaddr+0x4e>
    if (copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002000:	46a1                	li	a3,8
    80002002:	8626                	mv	a2,s1
    80002004:	85ca                	mv	a1,s2
    80002006:	6928                	ld	a0,80(a0)
    80002008:	fffff097          	auipc	ra,0xfffff
    8000200c:	b80080e7          	jalr	-1152(ra) # 80000b88 <copyin>
    80002010:	00a03533          	snez	a0,a0
    80002014:	40a00533          	neg	a0,a0
}
    80002018:	60e2                	ld	ra,24(sp)
    8000201a:	6442                	ld	s0,16(sp)
    8000201c:	64a2                	ld	s1,8(sp)
    8000201e:	6902                	ld	s2,0(sp)
    80002020:	6105                	addi	sp,sp,32
    80002022:	8082                	ret
        return -1;
    80002024:	557d                	li	a0,-1
    80002026:	bfcd                	j	80002018 <fetchaddr+0x3e>
    80002028:	557d                	li	a0,-1
    8000202a:	b7fd                	j	80002018 <fetchaddr+0x3e>

000000008000202c <fetchstr>:
{
    8000202c:	7179                	addi	sp,sp,-48
    8000202e:	f406                	sd	ra,40(sp)
    80002030:	f022                	sd	s0,32(sp)
    80002032:	ec26                	sd	s1,24(sp)
    80002034:	e84a                	sd	s2,16(sp)
    80002036:	e44e                	sd	s3,8(sp)
    80002038:	1800                	addi	s0,sp,48
    8000203a:	892a                	mv	s2,a0
    8000203c:	84ae                	mv	s1,a1
    8000203e:	89b2                	mv	s3,a2
    struct proc *p = myproc();
    80002040:	fffff097          	auipc	ra,0xfffff
    80002044:	dfe080e7          	jalr	-514(ra) # 80000e3e <myproc>
    if (copyinstr(p->pagetable, buf, addr, max) < 0)
    80002048:	86ce                	mv	a3,s3
    8000204a:	864a                	mv	a2,s2
    8000204c:	85a6                	mv	a1,s1
    8000204e:	6928                	ld	a0,80(a0)
    80002050:	fffff097          	auipc	ra,0xfffff
    80002054:	bc4080e7          	jalr	-1084(ra) # 80000c14 <copyinstr>
    80002058:	00054e63          	bltz	a0,80002074 <fetchstr+0x48>
    return strlen(buf);
    8000205c:	8526                	mv	a0,s1
    8000205e:	ffffe097          	auipc	ra,0xffffe
    80002062:	29e080e7          	jalr	670(ra) # 800002fc <strlen>
}
    80002066:	70a2                	ld	ra,40(sp)
    80002068:	7402                	ld	s0,32(sp)
    8000206a:	64e2                	ld	s1,24(sp)
    8000206c:	6942                	ld	s2,16(sp)
    8000206e:	69a2                	ld	s3,8(sp)
    80002070:	6145                	addi	sp,sp,48
    80002072:	8082                	ret
        return -1;
    80002074:	557d                	li	a0,-1
    80002076:	bfc5                	j	80002066 <fetchstr+0x3a>

0000000080002078 <argint>:

// Fetch the nth 32-bit system call argument.
void argint(int n, int *ip)
{
    80002078:	1101                	addi	sp,sp,-32
    8000207a:	ec06                	sd	ra,24(sp)
    8000207c:	e822                	sd	s0,16(sp)
    8000207e:	e426                	sd	s1,8(sp)
    80002080:	1000                	addi	s0,sp,32
    80002082:	84ae                	mv	s1,a1
    *ip = argraw(n);
    80002084:	00000097          	auipc	ra,0x0
    80002088:	eee080e7          	jalr	-274(ra) # 80001f72 <argraw>
    8000208c:	c088                	sw	a0,0(s1)
}
    8000208e:	60e2                	ld	ra,24(sp)
    80002090:	6442                	ld	s0,16(sp)
    80002092:	64a2                	ld	s1,8(sp)
    80002094:	6105                	addi	sp,sp,32
    80002096:	8082                	ret

0000000080002098 <argaddr>:

// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void argaddr(int n, uint64 *ip)
{
    80002098:	1101                	addi	sp,sp,-32
    8000209a:	ec06                	sd	ra,24(sp)
    8000209c:	e822                	sd	s0,16(sp)
    8000209e:	e426                	sd	s1,8(sp)
    800020a0:	1000                	addi	s0,sp,32
    800020a2:	84ae                	mv	s1,a1
    *ip = argraw(n);
    800020a4:	00000097          	auipc	ra,0x0
    800020a8:	ece080e7          	jalr	-306(ra) # 80001f72 <argraw>
    800020ac:	e088                	sd	a0,0(s1)
}
    800020ae:	60e2                	ld	ra,24(sp)
    800020b0:	6442                	ld	s0,16(sp)
    800020b2:	64a2                	ld	s1,8(sp)
    800020b4:	6105                	addi	sp,sp,32
    800020b6:	8082                	ret

00000000800020b8 <argstr>:

// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int argstr(int n, char *buf, int max)
{
    800020b8:	7179                	addi	sp,sp,-48
    800020ba:	f406                	sd	ra,40(sp)
    800020bc:	f022                	sd	s0,32(sp)
    800020be:	ec26                	sd	s1,24(sp)
    800020c0:	e84a                	sd	s2,16(sp)
    800020c2:	1800                	addi	s0,sp,48
    800020c4:	84ae                	mv	s1,a1
    800020c6:	8932                	mv	s2,a2
    uint64 addr;
    argaddr(n, &addr);
    800020c8:	fd840593          	addi	a1,s0,-40
    800020cc:	00000097          	auipc	ra,0x0
    800020d0:	fcc080e7          	jalr	-52(ra) # 80002098 <argaddr>
    return fetchstr(addr, buf, max);
    800020d4:	864a                	mv	a2,s2
    800020d6:	85a6                	mv	a1,s1
    800020d8:	fd843503          	ld	a0,-40(s0)
    800020dc:	00000097          	auipc	ra,0x0
    800020e0:	f50080e7          	jalr	-176(ra) # 8000202c <fetchstr>
}
    800020e4:	70a2                	ld	ra,40(sp)
    800020e6:	7402                	ld	s0,32(sp)
    800020e8:	64e2                	ld	s1,24(sp)
    800020ea:	6942                	ld	s2,16(sp)
    800020ec:	6145                	addi	sp,sp,48
    800020ee:	8082                	ret

00000000800020f0 <syscall>:
    [SYS_mmap] sys_mmap,
    [SYS_munmap] sys_munmap,
};

void syscall(void)
{
    800020f0:	1101                	addi	sp,sp,-32
    800020f2:	ec06                	sd	ra,24(sp)
    800020f4:	e822                	sd	s0,16(sp)
    800020f6:	e426                	sd	s1,8(sp)
    800020f8:	e04a                	sd	s2,0(sp)
    800020fa:	1000                	addi	s0,sp,32
    int num;
    struct proc *p = myproc();
    800020fc:	fffff097          	auipc	ra,0xfffff
    80002100:	d42080e7          	jalr	-702(ra) # 80000e3e <myproc>
    80002104:	84aa                	mv	s1,a0

    num = p->trapframe->a7;
    80002106:	05853903          	ld	s2,88(a0)
    8000210a:	0a893783          	ld	a5,168(s2)
    8000210e:	0007869b          	sext.w	a3,a5
    if (num > 0 && num < NELEM(syscalls) && syscalls[num])
    80002112:	37fd                	addiw	a5,a5,-1
    80002114:	4759                	li	a4,22
    80002116:	00f76f63          	bltu	a4,a5,80002134 <syscall+0x44>
    8000211a:	00369713          	slli	a4,a3,0x3
    8000211e:	00006797          	auipc	a5,0x6
    80002122:	2a278793          	addi	a5,a5,674 # 800083c0 <syscalls>
    80002126:	97ba                	add	a5,a5,a4
    80002128:	639c                	ld	a5,0(a5)
    8000212a:	c789                	beqz	a5,80002134 <syscall+0x44>
    {
        // Use num to lookup the system call function for num, call it,
        // and store its return value in p->trapframe->a0
        p->trapframe->a0 = syscalls[num]();
    8000212c:	9782                	jalr	a5
    8000212e:	06a93823          	sd	a0,112(s2)
    80002132:	a839                	j	80002150 <syscall+0x60>
    }
    else
    {
        printf("%d %s: unknown sys call %d\n",
    80002134:	15848613          	addi	a2,s1,344
    80002138:	588c                	lw	a1,48(s1)
    8000213a:	00006517          	auipc	a0,0x6
    8000213e:	24e50513          	addi	a0,a0,590 # 80008388 <states.1744+0x178>
    80002142:	00004097          	auipc	ra,0x4
    80002146:	e8a080e7          	jalr	-374(ra) # 80005fcc <printf>
               p->pid, p->name, num);
        p->trapframe->a0 = -1;
    8000214a:	6cbc                	ld	a5,88(s1)
    8000214c:	577d                	li	a4,-1
    8000214e:	fbb8                	sd	a4,112(a5)
    }
}
    80002150:	60e2                	ld	ra,24(sp)
    80002152:	6442                	ld	s0,16(sp)
    80002154:	64a2                	ld	s1,8(sp)
    80002156:	6902                	ld	s2,0(sp)
    80002158:	6105                	addi	sp,sp,32
    8000215a:	8082                	ret

000000008000215c <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    8000215c:	1101                	addi	sp,sp,-32
    8000215e:	ec06                	sd	ra,24(sp)
    80002160:	e822                	sd	s0,16(sp)
    80002162:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    80002164:	fec40593          	addi	a1,s0,-20
    80002168:	4501                	li	a0,0
    8000216a:	00000097          	auipc	ra,0x0
    8000216e:	f0e080e7          	jalr	-242(ra) # 80002078 <argint>
  exit(n);
    80002172:	fec42503          	lw	a0,-20(s0)
    80002176:	fffff097          	auipc	ra,0xfffff
    8000217a:	4e0080e7          	jalr	1248(ra) # 80001656 <exit>
  return 0;  // not reached
}
    8000217e:	4501                	li	a0,0
    80002180:	60e2                	ld	ra,24(sp)
    80002182:	6442                	ld	s0,16(sp)
    80002184:	6105                	addi	sp,sp,32
    80002186:	8082                	ret

0000000080002188 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002188:	1141                	addi	sp,sp,-16
    8000218a:	e406                	sd	ra,8(sp)
    8000218c:	e022                	sd	s0,0(sp)
    8000218e:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002190:	fffff097          	auipc	ra,0xfffff
    80002194:	cae080e7          	jalr	-850(ra) # 80000e3e <myproc>
}
    80002198:	5908                	lw	a0,48(a0)
    8000219a:	60a2                	ld	ra,8(sp)
    8000219c:	6402                	ld	s0,0(sp)
    8000219e:	0141                	addi	sp,sp,16
    800021a0:	8082                	ret

00000000800021a2 <sys_fork>:

uint64
sys_fork(void)
{
    800021a2:	1141                	addi	sp,sp,-16
    800021a4:	e406                	sd	ra,8(sp)
    800021a6:	e022                	sd	s0,0(sp)
    800021a8:	0800                	addi	s0,sp,16
  return fork();
    800021aa:	fffff097          	auipc	ra,0xfffff
    800021ae:	04a080e7          	jalr	74(ra) # 800011f4 <fork>
}
    800021b2:	60a2                	ld	ra,8(sp)
    800021b4:	6402                	ld	s0,0(sp)
    800021b6:	0141                	addi	sp,sp,16
    800021b8:	8082                	ret

00000000800021ba <sys_wait>:

uint64
sys_wait(void)
{
    800021ba:	1101                	addi	sp,sp,-32
    800021bc:	ec06                	sd	ra,24(sp)
    800021be:	e822                	sd	s0,16(sp)
    800021c0:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    800021c2:	fe840593          	addi	a1,s0,-24
    800021c6:	4501                	li	a0,0
    800021c8:	00000097          	auipc	ra,0x0
    800021cc:	ed0080e7          	jalr	-304(ra) # 80002098 <argaddr>
  return wait(p);
    800021d0:	fe843503          	ld	a0,-24(s0)
    800021d4:	fffff097          	auipc	ra,0xfffff
    800021d8:	628080e7          	jalr	1576(ra) # 800017fc <wait>
}
    800021dc:	60e2                	ld	ra,24(sp)
    800021de:	6442                	ld	s0,16(sp)
    800021e0:	6105                	addi	sp,sp,32
    800021e2:	8082                	ret

00000000800021e4 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    800021e4:	7179                	addi	sp,sp,-48
    800021e6:	f406                	sd	ra,40(sp)
    800021e8:	f022                	sd	s0,32(sp)
    800021ea:	ec26                	sd	s1,24(sp)
    800021ec:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    800021ee:	fdc40593          	addi	a1,s0,-36
    800021f2:	4501                	li	a0,0
    800021f4:	00000097          	auipc	ra,0x0
    800021f8:	e84080e7          	jalr	-380(ra) # 80002078 <argint>
  addr = myproc()->sz;
    800021fc:	fffff097          	auipc	ra,0xfffff
    80002200:	c42080e7          	jalr	-958(ra) # 80000e3e <myproc>
    80002204:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    80002206:	fdc42503          	lw	a0,-36(s0)
    8000220a:	fffff097          	auipc	ra,0xfffff
    8000220e:	f8e080e7          	jalr	-114(ra) # 80001198 <growproc>
    80002212:	00054863          	bltz	a0,80002222 <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    80002216:	8526                	mv	a0,s1
    80002218:	70a2                	ld	ra,40(sp)
    8000221a:	7402                	ld	s0,32(sp)
    8000221c:	64e2                	ld	s1,24(sp)
    8000221e:	6145                	addi	sp,sp,48
    80002220:	8082                	ret
    return -1;
    80002222:	54fd                	li	s1,-1
    80002224:	bfcd                	j	80002216 <sys_sbrk+0x32>

0000000080002226 <sys_sleep>:

uint64
sys_sleep(void)
{
    80002226:	7139                	addi	sp,sp,-64
    80002228:	fc06                	sd	ra,56(sp)
    8000222a:	f822                	sd	s0,48(sp)
    8000222c:	f426                	sd	s1,40(sp)
    8000222e:	f04a                	sd	s2,32(sp)
    80002230:	ec4e                	sd	s3,24(sp)
    80002232:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    80002234:	fcc40593          	addi	a1,s0,-52
    80002238:	4501                	li	a0,0
    8000223a:	00000097          	auipc	ra,0x0
    8000223e:	e3e080e7          	jalr	-450(ra) # 80002078 <argint>
  if(n < 0)
    80002242:	fcc42783          	lw	a5,-52(s0)
    80002246:	0607cf63          	bltz	a5,800022c4 <sys_sleep+0x9e>
    n = 0;
  acquire(&tickslock);
    8000224a:	0001e517          	auipc	a0,0x1e
    8000224e:	50650513          	addi	a0,a0,1286 # 80020750 <tickslock>
    80002252:	00004097          	auipc	ra,0x4
    80002256:	27a080e7          	jalr	634(ra) # 800064cc <acquire>
  ticks0 = ticks;
    8000225a:	00006917          	auipc	s2,0x6
    8000225e:	68e92903          	lw	s2,1678(s2) # 800088e8 <ticks>
  while(ticks - ticks0 < n){
    80002262:	fcc42783          	lw	a5,-52(s0)
    80002266:	cf9d                	beqz	a5,800022a4 <sys_sleep+0x7e>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002268:	0001e997          	auipc	s3,0x1e
    8000226c:	4e898993          	addi	s3,s3,1256 # 80020750 <tickslock>
    80002270:	00006497          	auipc	s1,0x6
    80002274:	67848493          	addi	s1,s1,1656 # 800088e8 <ticks>
    if(killed(myproc())){
    80002278:	fffff097          	auipc	ra,0xfffff
    8000227c:	bc6080e7          	jalr	-1082(ra) # 80000e3e <myproc>
    80002280:	fffff097          	auipc	ra,0xfffff
    80002284:	54a080e7          	jalr	1354(ra) # 800017ca <killed>
    80002288:	e129                	bnez	a0,800022ca <sys_sleep+0xa4>
    sleep(&ticks, &tickslock);
    8000228a:	85ce                	mv	a1,s3
    8000228c:	8526                	mv	a0,s1
    8000228e:	fffff097          	auipc	ra,0xfffff
    80002292:	294080e7          	jalr	660(ra) # 80001522 <sleep>
  while(ticks - ticks0 < n){
    80002296:	409c                	lw	a5,0(s1)
    80002298:	412787bb          	subw	a5,a5,s2
    8000229c:	fcc42703          	lw	a4,-52(s0)
    800022a0:	fce7ece3          	bltu	a5,a4,80002278 <sys_sleep+0x52>
  }
  release(&tickslock);
    800022a4:	0001e517          	auipc	a0,0x1e
    800022a8:	4ac50513          	addi	a0,a0,1196 # 80020750 <tickslock>
    800022ac:	00004097          	auipc	ra,0x4
    800022b0:	2d4080e7          	jalr	724(ra) # 80006580 <release>
  return 0;
    800022b4:	4501                	li	a0,0
}
    800022b6:	70e2                	ld	ra,56(sp)
    800022b8:	7442                	ld	s0,48(sp)
    800022ba:	74a2                	ld	s1,40(sp)
    800022bc:	7902                	ld	s2,32(sp)
    800022be:	69e2                	ld	s3,24(sp)
    800022c0:	6121                	addi	sp,sp,64
    800022c2:	8082                	ret
    n = 0;
    800022c4:	fc042623          	sw	zero,-52(s0)
    800022c8:	b749                	j	8000224a <sys_sleep+0x24>
      release(&tickslock);
    800022ca:	0001e517          	auipc	a0,0x1e
    800022ce:	48650513          	addi	a0,a0,1158 # 80020750 <tickslock>
    800022d2:	00004097          	auipc	ra,0x4
    800022d6:	2ae080e7          	jalr	686(ra) # 80006580 <release>
      return -1;
    800022da:	557d                	li	a0,-1
    800022dc:	bfe9                	j	800022b6 <sys_sleep+0x90>

00000000800022de <sys_kill>:

uint64
sys_kill(void)
{
    800022de:	1101                	addi	sp,sp,-32
    800022e0:	ec06                	sd	ra,24(sp)
    800022e2:	e822                	sd	s0,16(sp)
    800022e4:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    800022e6:	fec40593          	addi	a1,s0,-20
    800022ea:	4501                	li	a0,0
    800022ec:	00000097          	auipc	ra,0x0
    800022f0:	d8c080e7          	jalr	-628(ra) # 80002078 <argint>
  return kill(pid);
    800022f4:	fec42503          	lw	a0,-20(s0)
    800022f8:	fffff097          	auipc	ra,0xfffff
    800022fc:	434080e7          	jalr	1076(ra) # 8000172c <kill>
}
    80002300:	60e2                	ld	ra,24(sp)
    80002302:	6442                	ld	s0,16(sp)
    80002304:	6105                	addi	sp,sp,32
    80002306:	8082                	ret

0000000080002308 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002308:	1101                	addi	sp,sp,-32
    8000230a:	ec06                	sd	ra,24(sp)
    8000230c:	e822                	sd	s0,16(sp)
    8000230e:	e426                	sd	s1,8(sp)
    80002310:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002312:	0001e517          	auipc	a0,0x1e
    80002316:	43e50513          	addi	a0,a0,1086 # 80020750 <tickslock>
    8000231a:	00004097          	auipc	ra,0x4
    8000231e:	1b2080e7          	jalr	434(ra) # 800064cc <acquire>
  xticks = ticks;
    80002322:	00006497          	auipc	s1,0x6
    80002326:	5c64a483          	lw	s1,1478(s1) # 800088e8 <ticks>
  release(&tickslock);
    8000232a:	0001e517          	auipc	a0,0x1e
    8000232e:	42650513          	addi	a0,a0,1062 # 80020750 <tickslock>
    80002332:	00004097          	auipc	ra,0x4
    80002336:	24e080e7          	jalr	590(ra) # 80006580 <release>
  return xticks;
}
    8000233a:	02049513          	slli	a0,s1,0x20
    8000233e:	9101                	srli	a0,a0,0x20
    80002340:	60e2                	ld	ra,24(sp)
    80002342:	6442                	ld	s0,16(sp)
    80002344:	64a2                	ld	s1,8(sp)
    80002346:	6105                	addi	sp,sp,32
    80002348:	8082                	ret

000000008000234a <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    8000234a:	7179                	addi	sp,sp,-48
    8000234c:	f406                	sd	ra,40(sp)
    8000234e:	f022                	sd	s0,32(sp)
    80002350:	ec26                	sd	s1,24(sp)
    80002352:	e84a                	sd	s2,16(sp)
    80002354:	e44e                	sd	s3,8(sp)
    80002356:	e052                	sd	s4,0(sp)
    80002358:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    8000235a:	00006597          	auipc	a1,0x6
    8000235e:	12658593          	addi	a1,a1,294 # 80008480 <syscalls+0xc0>
    80002362:	0001e517          	auipc	a0,0x1e
    80002366:	40650513          	addi	a0,a0,1030 # 80020768 <bcache>
    8000236a:	00004097          	auipc	ra,0x4
    8000236e:	0d2080e7          	jalr	210(ra) # 8000643c <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    80002372:	00026797          	auipc	a5,0x26
    80002376:	3f678793          	addi	a5,a5,1014 # 80028768 <bcache+0x8000>
    8000237a:	00026717          	auipc	a4,0x26
    8000237e:	65670713          	addi	a4,a4,1622 # 800289d0 <bcache+0x8268>
    80002382:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002386:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000238a:	0001e497          	auipc	s1,0x1e
    8000238e:	3f648493          	addi	s1,s1,1014 # 80020780 <bcache+0x18>
    b->next = bcache.head.next;
    80002392:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002394:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002396:	00006a17          	auipc	s4,0x6
    8000239a:	0f2a0a13          	addi	s4,s4,242 # 80008488 <syscalls+0xc8>
    b->next = bcache.head.next;
    8000239e:	2b893783          	ld	a5,696(s2)
    800023a2:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800023a4:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800023a8:	85d2                	mv	a1,s4
    800023aa:	01048513          	addi	a0,s1,16
    800023ae:	00001097          	auipc	ra,0x1
    800023b2:	4c4080e7          	jalr	1220(ra) # 80003872 <initsleeplock>
    bcache.head.next->prev = b;
    800023b6:	2b893783          	ld	a5,696(s2)
    800023ba:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800023bc:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800023c0:	45848493          	addi	s1,s1,1112
    800023c4:	fd349de3          	bne	s1,s3,8000239e <binit+0x54>
  }
}
    800023c8:	70a2                	ld	ra,40(sp)
    800023ca:	7402                	ld	s0,32(sp)
    800023cc:	64e2                	ld	s1,24(sp)
    800023ce:	6942                	ld	s2,16(sp)
    800023d0:	69a2                	ld	s3,8(sp)
    800023d2:	6a02                	ld	s4,0(sp)
    800023d4:	6145                	addi	sp,sp,48
    800023d6:	8082                	ret

00000000800023d8 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    800023d8:	7179                	addi	sp,sp,-48
    800023da:	f406                	sd	ra,40(sp)
    800023dc:	f022                	sd	s0,32(sp)
    800023de:	ec26                	sd	s1,24(sp)
    800023e0:	e84a                	sd	s2,16(sp)
    800023e2:	e44e                	sd	s3,8(sp)
    800023e4:	1800                	addi	s0,sp,48
    800023e6:	89aa                	mv	s3,a0
    800023e8:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    800023ea:	0001e517          	auipc	a0,0x1e
    800023ee:	37e50513          	addi	a0,a0,894 # 80020768 <bcache>
    800023f2:	00004097          	auipc	ra,0x4
    800023f6:	0da080e7          	jalr	218(ra) # 800064cc <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    800023fa:	00026497          	auipc	s1,0x26
    800023fe:	6264b483          	ld	s1,1574(s1) # 80028a20 <bcache+0x82b8>
    80002402:	00026797          	auipc	a5,0x26
    80002406:	5ce78793          	addi	a5,a5,1486 # 800289d0 <bcache+0x8268>
    8000240a:	02f48f63          	beq	s1,a5,80002448 <bread+0x70>
    8000240e:	873e                	mv	a4,a5
    80002410:	a021                	j	80002418 <bread+0x40>
    80002412:	68a4                	ld	s1,80(s1)
    80002414:	02e48a63          	beq	s1,a4,80002448 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002418:	449c                	lw	a5,8(s1)
    8000241a:	ff379ce3          	bne	a5,s3,80002412 <bread+0x3a>
    8000241e:	44dc                	lw	a5,12(s1)
    80002420:	ff2799e3          	bne	a5,s2,80002412 <bread+0x3a>
      b->refcnt++;
    80002424:	40bc                	lw	a5,64(s1)
    80002426:	2785                	addiw	a5,a5,1
    80002428:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    8000242a:	0001e517          	auipc	a0,0x1e
    8000242e:	33e50513          	addi	a0,a0,830 # 80020768 <bcache>
    80002432:	00004097          	auipc	ra,0x4
    80002436:	14e080e7          	jalr	334(ra) # 80006580 <release>
      acquiresleep(&b->lock);
    8000243a:	01048513          	addi	a0,s1,16
    8000243e:	00001097          	auipc	ra,0x1
    80002442:	46e080e7          	jalr	1134(ra) # 800038ac <acquiresleep>
      return b;
    80002446:	a8b9                	j	800024a4 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002448:	00026497          	auipc	s1,0x26
    8000244c:	5d04b483          	ld	s1,1488(s1) # 80028a18 <bcache+0x82b0>
    80002450:	00026797          	auipc	a5,0x26
    80002454:	58078793          	addi	a5,a5,1408 # 800289d0 <bcache+0x8268>
    80002458:	00f48863          	beq	s1,a5,80002468 <bread+0x90>
    8000245c:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    8000245e:	40bc                	lw	a5,64(s1)
    80002460:	cf81                	beqz	a5,80002478 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002462:	64a4                	ld	s1,72(s1)
    80002464:	fee49de3          	bne	s1,a4,8000245e <bread+0x86>
  panic("bget: no buffers");
    80002468:	00006517          	auipc	a0,0x6
    8000246c:	02850513          	addi	a0,a0,40 # 80008490 <syscalls+0xd0>
    80002470:	00004097          	auipc	ra,0x4
    80002474:	b12080e7          	jalr	-1262(ra) # 80005f82 <panic>
      b->dev = dev;
    80002478:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    8000247c:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    80002480:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002484:	4785                	li	a5,1
    80002486:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002488:	0001e517          	auipc	a0,0x1e
    8000248c:	2e050513          	addi	a0,a0,736 # 80020768 <bcache>
    80002490:	00004097          	auipc	ra,0x4
    80002494:	0f0080e7          	jalr	240(ra) # 80006580 <release>
      acquiresleep(&b->lock);
    80002498:	01048513          	addi	a0,s1,16
    8000249c:	00001097          	auipc	ra,0x1
    800024a0:	410080e7          	jalr	1040(ra) # 800038ac <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800024a4:	409c                	lw	a5,0(s1)
    800024a6:	cb89                	beqz	a5,800024b8 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800024a8:	8526                	mv	a0,s1
    800024aa:	70a2                	ld	ra,40(sp)
    800024ac:	7402                	ld	s0,32(sp)
    800024ae:	64e2                	ld	s1,24(sp)
    800024b0:	6942                	ld	s2,16(sp)
    800024b2:	69a2                	ld	s3,8(sp)
    800024b4:	6145                	addi	sp,sp,48
    800024b6:	8082                	ret
    virtio_disk_rw(b, 0);
    800024b8:	4581                	li	a1,0
    800024ba:	8526                	mv	a0,s1
    800024bc:	00003097          	auipc	ra,0x3
    800024c0:	25c080e7          	jalr	604(ra) # 80005718 <virtio_disk_rw>
    b->valid = 1;
    800024c4:	4785                	li	a5,1
    800024c6:	c09c                	sw	a5,0(s1)
  return b;
    800024c8:	b7c5                	j	800024a8 <bread+0xd0>

00000000800024ca <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800024ca:	1101                	addi	sp,sp,-32
    800024cc:	ec06                	sd	ra,24(sp)
    800024ce:	e822                	sd	s0,16(sp)
    800024d0:	e426                	sd	s1,8(sp)
    800024d2:	1000                	addi	s0,sp,32
    800024d4:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800024d6:	0541                	addi	a0,a0,16
    800024d8:	00001097          	auipc	ra,0x1
    800024dc:	46e080e7          	jalr	1134(ra) # 80003946 <holdingsleep>
    800024e0:	cd01                	beqz	a0,800024f8 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    800024e2:	4585                	li	a1,1
    800024e4:	8526                	mv	a0,s1
    800024e6:	00003097          	auipc	ra,0x3
    800024ea:	232080e7          	jalr	562(ra) # 80005718 <virtio_disk_rw>
}
    800024ee:	60e2                	ld	ra,24(sp)
    800024f0:	6442                	ld	s0,16(sp)
    800024f2:	64a2                	ld	s1,8(sp)
    800024f4:	6105                	addi	sp,sp,32
    800024f6:	8082                	ret
    panic("bwrite");
    800024f8:	00006517          	auipc	a0,0x6
    800024fc:	fb050513          	addi	a0,a0,-80 # 800084a8 <syscalls+0xe8>
    80002500:	00004097          	auipc	ra,0x4
    80002504:	a82080e7          	jalr	-1406(ra) # 80005f82 <panic>

0000000080002508 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002508:	1101                	addi	sp,sp,-32
    8000250a:	ec06                	sd	ra,24(sp)
    8000250c:	e822                	sd	s0,16(sp)
    8000250e:	e426                	sd	s1,8(sp)
    80002510:	e04a                	sd	s2,0(sp)
    80002512:	1000                	addi	s0,sp,32
    80002514:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002516:	01050913          	addi	s2,a0,16
    8000251a:	854a                	mv	a0,s2
    8000251c:	00001097          	auipc	ra,0x1
    80002520:	42a080e7          	jalr	1066(ra) # 80003946 <holdingsleep>
    80002524:	c92d                	beqz	a0,80002596 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    80002526:	854a                	mv	a0,s2
    80002528:	00001097          	auipc	ra,0x1
    8000252c:	3da080e7          	jalr	986(ra) # 80003902 <releasesleep>

  acquire(&bcache.lock);
    80002530:	0001e517          	auipc	a0,0x1e
    80002534:	23850513          	addi	a0,a0,568 # 80020768 <bcache>
    80002538:	00004097          	auipc	ra,0x4
    8000253c:	f94080e7          	jalr	-108(ra) # 800064cc <acquire>
  b->refcnt--;
    80002540:	40bc                	lw	a5,64(s1)
    80002542:	37fd                	addiw	a5,a5,-1
    80002544:	0007871b          	sext.w	a4,a5
    80002548:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    8000254a:	eb05                	bnez	a4,8000257a <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    8000254c:	68bc                	ld	a5,80(s1)
    8000254e:	64b8                	ld	a4,72(s1)
    80002550:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    80002552:	64bc                	ld	a5,72(s1)
    80002554:	68b8                	ld	a4,80(s1)
    80002556:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002558:	00026797          	auipc	a5,0x26
    8000255c:	21078793          	addi	a5,a5,528 # 80028768 <bcache+0x8000>
    80002560:	2b87b703          	ld	a4,696(a5)
    80002564:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    80002566:	00026717          	auipc	a4,0x26
    8000256a:	46a70713          	addi	a4,a4,1130 # 800289d0 <bcache+0x8268>
    8000256e:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002570:	2b87b703          	ld	a4,696(a5)
    80002574:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    80002576:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    8000257a:	0001e517          	auipc	a0,0x1e
    8000257e:	1ee50513          	addi	a0,a0,494 # 80020768 <bcache>
    80002582:	00004097          	auipc	ra,0x4
    80002586:	ffe080e7          	jalr	-2(ra) # 80006580 <release>
}
    8000258a:	60e2                	ld	ra,24(sp)
    8000258c:	6442                	ld	s0,16(sp)
    8000258e:	64a2                	ld	s1,8(sp)
    80002590:	6902                	ld	s2,0(sp)
    80002592:	6105                	addi	sp,sp,32
    80002594:	8082                	ret
    panic("brelse");
    80002596:	00006517          	auipc	a0,0x6
    8000259a:	f1a50513          	addi	a0,a0,-230 # 800084b0 <syscalls+0xf0>
    8000259e:	00004097          	auipc	ra,0x4
    800025a2:	9e4080e7          	jalr	-1564(ra) # 80005f82 <panic>

00000000800025a6 <bpin>:

void
bpin(struct buf *b) {
    800025a6:	1101                	addi	sp,sp,-32
    800025a8:	ec06                	sd	ra,24(sp)
    800025aa:	e822                	sd	s0,16(sp)
    800025ac:	e426                	sd	s1,8(sp)
    800025ae:	1000                	addi	s0,sp,32
    800025b0:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800025b2:	0001e517          	auipc	a0,0x1e
    800025b6:	1b650513          	addi	a0,a0,438 # 80020768 <bcache>
    800025ba:	00004097          	auipc	ra,0x4
    800025be:	f12080e7          	jalr	-238(ra) # 800064cc <acquire>
  b->refcnt++;
    800025c2:	40bc                	lw	a5,64(s1)
    800025c4:	2785                	addiw	a5,a5,1
    800025c6:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800025c8:	0001e517          	auipc	a0,0x1e
    800025cc:	1a050513          	addi	a0,a0,416 # 80020768 <bcache>
    800025d0:	00004097          	auipc	ra,0x4
    800025d4:	fb0080e7          	jalr	-80(ra) # 80006580 <release>
}
    800025d8:	60e2                	ld	ra,24(sp)
    800025da:	6442                	ld	s0,16(sp)
    800025dc:	64a2                	ld	s1,8(sp)
    800025de:	6105                	addi	sp,sp,32
    800025e0:	8082                	ret

00000000800025e2 <bunpin>:

void
bunpin(struct buf *b) {
    800025e2:	1101                	addi	sp,sp,-32
    800025e4:	ec06                	sd	ra,24(sp)
    800025e6:	e822                	sd	s0,16(sp)
    800025e8:	e426                	sd	s1,8(sp)
    800025ea:	1000                	addi	s0,sp,32
    800025ec:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800025ee:	0001e517          	auipc	a0,0x1e
    800025f2:	17a50513          	addi	a0,a0,378 # 80020768 <bcache>
    800025f6:	00004097          	auipc	ra,0x4
    800025fa:	ed6080e7          	jalr	-298(ra) # 800064cc <acquire>
  b->refcnt--;
    800025fe:	40bc                	lw	a5,64(s1)
    80002600:	37fd                	addiw	a5,a5,-1
    80002602:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002604:	0001e517          	auipc	a0,0x1e
    80002608:	16450513          	addi	a0,a0,356 # 80020768 <bcache>
    8000260c:	00004097          	auipc	ra,0x4
    80002610:	f74080e7          	jalr	-140(ra) # 80006580 <release>
}
    80002614:	60e2                	ld	ra,24(sp)
    80002616:	6442                	ld	s0,16(sp)
    80002618:	64a2                	ld	s1,8(sp)
    8000261a:	6105                	addi	sp,sp,32
    8000261c:	8082                	ret

000000008000261e <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    8000261e:	1101                	addi	sp,sp,-32
    80002620:	ec06                	sd	ra,24(sp)
    80002622:	e822                	sd	s0,16(sp)
    80002624:	e426                	sd	s1,8(sp)
    80002626:	e04a                	sd	s2,0(sp)
    80002628:	1000                	addi	s0,sp,32
    8000262a:	84ae                	mv	s1,a1
    struct buf *bp;
    int bi, m;

    bp = bread(dev, BBLOCK(b, sb));
    8000262c:	00d5d59b          	srliw	a1,a1,0xd
    80002630:	00027797          	auipc	a5,0x27
    80002634:	8147a783          	lw	a5,-2028(a5) # 80028e44 <sb+0x1c>
    80002638:	9dbd                	addw	a1,a1,a5
    8000263a:	00000097          	auipc	ra,0x0
    8000263e:	d9e080e7          	jalr	-610(ra) # 800023d8 <bread>
    bi = b % BPB;
    m = 1 << (bi % 8);
    80002642:	0074f713          	andi	a4,s1,7
    80002646:	4785                	li	a5,1
    80002648:	00e797bb          	sllw	a5,a5,a4
    if ((bp->data[bi / 8] & m) == 0)
    8000264c:	14ce                	slli	s1,s1,0x33
    8000264e:	90d9                	srli	s1,s1,0x36
    80002650:	00950733          	add	a4,a0,s1
    80002654:	05874703          	lbu	a4,88(a4)
    80002658:	00e7f6b3          	and	a3,a5,a4
    8000265c:	c69d                	beqz	a3,8000268a <bfree+0x6c>
    8000265e:	892a                	mv	s2,a0
        panic("freeing free block");
    bp->data[bi / 8] &= ~m;
    80002660:	94aa                	add	s1,s1,a0
    80002662:	fff7c793          	not	a5,a5
    80002666:	8ff9                	and	a5,a5,a4
    80002668:	04f48c23          	sb	a5,88(s1)
    log_write(bp);
    8000266c:	00001097          	auipc	ra,0x1
    80002670:	120080e7          	jalr	288(ra) # 8000378c <log_write>
    brelse(bp);
    80002674:	854a                	mv	a0,s2
    80002676:	00000097          	auipc	ra,0x0
    8000267a:	e92080e7          	jalr	-366(ra) # 80002508 <brelse>
}
    8000267e:	60e2                	ld	ra,24(sp)
    80002680:	6442                	ld	s0,16(sp)
    80002682:	64a2                	ld	s1,8(sp)
    80002684:	6902                	ld	s2,0(sp)
    80002686:	6105                	addi	sp,sp,32
    80002688:	8082                	ret
        panic("freeing free block");
    8000268a:	00006517          	auipc	a0,0x6
    8000268e:	e2e50513          	addi	a0,a0,-466 # 800084b8 <syscalls+0xf8>
    80002692:	00004097          	auipc	ra,0x4
    80002696:	8f0080e7          	jalr	-1808(ra) # 80005f82 <panic>

000000008000269a <balloc>:
{
    8000269a:	711d                	addi	sp,sp,-96
    8000269c:	ec86                	sd	ra,88(sp)
    8000269e:	e8a2                	sd	s0,80(sp)
    800026a0:	e4a6                	sd	s1,72(sp)
    800026a2:	e0ca                	sd	s2,64(sp)
    800026a4:	fc4e                	sd	s3,56(sp)
    800026a6:	f852                	sd	s4,48(sp)
    800026a8:	f456                	sd	s5,40(sp)
    800026aa:	f05a                	sd	s6,32(sp)
    800026ac:	ec5e                	sd	s7,24(sp)
    800026ae:	e862                	sd	s8,16(sp)
    800026b0:	e466                	sd	s9,8(sp)
    800026b2:	1080                	addi	s0,sp,96
    for (b = 0; b < sb.size; b += BPB)
    800026b4:	00026797          	auipc	a5,0x26
    800026b8:	7787a783          	lw	a5,1912(a5) # 80028e2c <sb+0x4>
    800026bc:	10078163          	beqz	a5,800027be <balloc+0x124>
    800026c0:	8baa                	mv	s7,a0
    800026c2:	4a81                	li	s5,0
        bp = bread(dev, BBLOCK(b, sb));
    800026c4:	00026b17          	auipc	s6,0x26
    800026c8:	764b0b13          	addi	s6,s6,1892 # 80028e28 <sb>
        for (bi = 0; bi < BPB && b + bi < sb.size; bi++)
    800026cc:	4c01                	li	s8,0
            m = 1 << (bi % 8);
    800026ce:	4985                	li	s3,1
        for (bi = 0; bi < BPB && b + bi < sb.size; bi++)
    800026d0:	6a09                	lui	s4,0x2
    for (b = 0; b < sb.size; b += BPB)
    800026d2:	6c89                	lui	s9,0x2
    800026d4:	a061                	j	8000275c <balloc+0xc2>
                bp->data[bi / 8] |= m; // Mark block in use.
    800026d6:	974a                	add	a4,a4,s2
    800026d8:	8fd5                	or	a5,a5,a3
    800026da:	04f70c23          	sb	a5,88(a4)
                log_write(bp);
    800026de:	854a                	mv	a0,s2
    800026e0:	00001097          	auipc	ra,0x1
    800026e4:	0ac080e7          	jalr	172(ra) # 8000378c <log_write>
                brelse(bp);
    800026e8:	854a                	mv	a0,s2
    800026ea:	00000097          	auipc	ra,0x0
    800026ee:	e1e080e7          	jalr	-482(ra) # 80002508 <brelse>
    bp = bread(dev, bno);
    800026f2:	85a6                	mv	a1,s1
    800026f4:	855e                	mv	a0,s7
    800026f6:	00000097          	auipc	ra,0x0
    800026fa:	ce2080e7          	jalr	-798(ra) # 800023d8 <bread>
    800026fe:	892a                	mv	s2,a0
    memset(bp->data, 0, BSIZE);
    80002700:	40000613          	li	a2,1024
    80002704:	4581                	li	a1,0
    80002706:	05850513          	addi	a0,a0,88
    8000270a:	ffffe097          	auipc	ra,0xffffe
    8000270e:	a6e080e7          	jalr	-1426(ra) # 80000178 <memset>
    log_write(bp);
    80002712:	854a                	mv	a0,s2
    80002714:	00001097          	auipc	ra,0x1
    80002718:	078080e7          	jalr	120(ra) # 8000378c <log_write>
    brelse(bp);
    8000271c:	854a                	mv	a0,s2
    8000271e:	00000097          	auipc	ra,0x0
    80002722:	dea080e7          	jalr	-534(ra) # 80002508 <brelse>
}
    80002726:	8526                	mv	a0,s1
    80002728:	60e6                	ld	ra,88(sp)
    8000272a:	6446                	ld	s0,80(sp)
    8000272c:	64a6                	ld	s1,72(sp)
    8000272e:	6906                	ld	s2,64(sp)
    80002730:	79e2                	ld	s3,56(sp)
    80002732:	7a42                	ld	s4,48(sp)
    80002734:	7aa2                	ld	s5,40(sp)
    80002736:	7b02                	ld	s6,32(sp)
    80002738:	6be2                	ld	s7,24(sp)
    8000273a:	6c42                	ld	s8,16(sp)
    8000273c:	6ca2                	ld	s9,8(sp)
    8000273e:	6125                	addi	sp,sp,96
    80002740:	8082                	ret
        brelse(bp);
    80002742:	854a                	mv	a0,s2
    80002744:	00000097          	auipc	ra,0x0
    80002748:	dc4080e7          	jalr	-572(ra) # 80002508 <brelse>
    for (b = 0; b < sb.size; b += BPB)
    8000274c:	015c87bb          	addw	a5,s9,s5
    80002750:	00078a9b          	sext.w	s5,a5
    80002754:	004b2703          	lw	a4,4(s6)
    80002758:	06eaf363          	bgeu	s5,a4,800027be <balloc+0x124>
        bp = bread(dev, BBLOCK(b, sb));
    8000275c:	41fad79b          	sraiw	a5,s5,0x1f
    80002760:	0137d79b          	srliw	a5,a5,0x13
    80002764:	015787bb          	addw	a5,a5,s5
    80002768:	40d7d79b          	sraiw	a5,a5,0xd
    8000276c:	01cb2583          	lw	a1,28(s6)
    80002770:	9dbd                	addw	a1,a1,a5
    80002772:	855e                	mv	a0,s7
    80002774:	00000097          	auipc	ra,0x0
    80002778:	c64080e7          	jalr	-924(ra) # 800023d8 <bread>
    8000277c:	892a                	mv	s2,a0
        for (bi = 0; bi < BPB && b + bi < sb.size; bi++)
    8000277e:	004b2503          	lw	a0,4(s6)
    80002782:	000a849b          	sext.w	s1,s5
    80002786:	8662                	mv	a2,s8
    80002788:	faa4fde3          	bgeu	s1,a0,80002742 <balloc+0xa8>
            m = 1 << (bi % 8);
    8000278c:	41f6579b          	sraiw	a5,a2,0x1f
    80002790:	01d7d69b          	srliw	a3,a5,0x1d
    80002794:	00c6873b          	addw	a4,a3,a2
    80002798:	00777793          	andi	a5,a4,7
    8000279c:	9f95                	subw	a5,a5,a3
    8000279e:	00f997bb          	sllw	a5,s3,a5
            if ((bp->data[bi / 8] & m) == 0)
    800027a2:	4037571b          	sraiw	a4,a4,0x3
    800027a6:	00e906b3          	add	a3,s2,a4
    800027aa:	0586c683          	lbu	a3,88(a3)
    800027ae:	00d7f5b3          	and	a1,a5,a3
    800027b2:	d195                	beqz	a1,800026d6 <balloc+0x3c>
        for (bi = 0; bi < BPB && b + bi < sb.size; bi++)
    800027b4:	2605                	addiw	a2,a2,1
    800027b6:	2485                	addiw	s1,s1,1
    800027b8:	fd4618e3          	bne	a2,s4,80002788 <balloc+0xee>
    800027bc:	b759                	j	80002742 <balloc+0xa8>
    printf("balloc: out of blocks\n");
    800027be:	00006517          	auipc	a0,0x6
    800027c2:	d1250513          	addi	a0,a0,-750 # 800084d0 <syscalls+0x110>
    800027c6:	00004097          	auipc	ra,0x4
    800027ca:	806080e7          	jalr	-2042(ra) # 80005fcc <printf>
    return 0;
    800027ce:	4481                	li	s1,0
    800027d0:	bf99                	j	80002726 <balloc+0x8c>

00000000800027d2 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    800027d2:	7179                	addi	sp,sp,-48
    800027d4:	f406                	sd	ra,40(sp)
    800027d6:	f022                	sd	s0,32(sp)
    800027d8:	ec26                	sd	s1,24(sp)
    800027da:	e84a                	sd	s2,16(sp)
    800027dc:	e44e                	sd	s3,8(sp)
    800027de:	e052                	sd	s4,0(sp)
    800027e0:	1800                	addi	s0,sp,48
    800027e2:	89aa                	mv	s3,a0
    uint addr, *a;
    struct buf *bp;

    if (bn < NDIRECT)
    800027e4:	47ad                	li	a5,11
    800027e6:	02b7e763          	bltu	a5,a1,80002814 <bmap+0x42>
    {
        if ((addr = ip->addrs[bn]) == 0)
    800027ea:	02059493          	slli	s1,a1,0x20
    800027ee:	9081                	srli	s1,s1,0x20
    800027f0:	048a                	slli	s1,s1,0x2
    800027f2:	94aa                	add	s1,s1,a0
    800027f4:	0504a903          	lw	s2,80(s1)
    800027f8:	06091e63          	bnez	s2,80002874 <bmap+0xa2>
        {
            addr = balloc(ip->dev);
    800027fc:	4108                	lw	a0,0(a0)
    800027fe:	00000097          	auipc	ra,0x0
    80002802:	e9c080e7          	jalr	-356(ra) # 8000269a <balloc>
    80002806:	0005091b          	sext.w	s2,a0
            if (addr == 0)
    8000280a:	06090563          	beqz	s2,80002874 <bmap+0xa2>
                return 0;
            ip->addrs[bn] = addr;
    8000280e:	0524a823          	sw	s2,80(s1)
    80002812:	a08d                	j	80002874 <bmap+0xa2>
        }
        return addr;
    }
    bn -= NDIRECT;
    80002814:	ff45849b          	addiw	s1,a1,-12
    80002818:	0004871b          	sext.w	a4,s1

    if (bn < NINDIRECT)
    8000281c:	0ff00793          	li	a5,255
    80002820:	08e7e563          	bltu	a5,a4,800028aa <bmap+0xd8>
    {
        // Load indirect block, allocating if necessary.
        if ((addr = ip->addrs[NDIRECT]) == 0)
    80002824:	08052903          	lw	s2,128(a0)
    80002828:	00091d63          	bnez	s2,80002842 <bmap+0x70>
        {
            addr = balloc(ip->dev);
    8000282c:	4108                	lw	a0,0(a0)
    8000282e:	00000097          	auipc	ra,0x0
    80002832:	e6c080e7          	jalr	-404(ra) # 8000269a <balloc>
    80002836:	0005091b          	sext.w	s2,a0
            if (addr == 0)
    8000283a:	02090d63          	beqz	s2,80002874 <bmap+0xa2>
                return 0;
            ip->addrs[NDIRECT] = addr;
    8000283e:	0929a023          	sw	s2,128(s3)
        }
        bp = bread(ip->dev, addr);
    80002842:	85ca                	mv	a1,s2
    80002844:	0009a503          	lw	a0,0(s3)
    80002848:	00000097          	auipc	ra,0x0
    8000284c:	b90080e7          	jalr	-1136(ra) # 800023d8 <bread>
    80002850:	8a2a                	mv	s4,a0
        a = (uint *)bp->data;
    80002852:	05850793          	addi	a5,a0,88
        if ((addr = a[bn]) == 0)
    80002856:	02049593          	slli	a1,s1,0x20
    8000285a:	9181                	srli	a1,a1,0x20
    8000285c:	058a                	slli	a1,a1,0x2
    8000285e:	00b784b3          	add	s1,a5,a1
    80002862:	0004a903          	lw	s2,0(s1)
    80002866:	02090063          	beqz	s2,80002886 <bmap+0xb4>
            {
                a[bn] = addr;
                log_write(bp);
            }
        }
        brelse(bp);
    8000286a:	8552                	mv	a0,s4
    8000286c:	00000097          	auipc	ra,0x0
    80002870:	c9c080e7          	jalr	-868(ra) # 80002508 <brelse>
        return addr;
    }

    panic("bmap: out of range");
}
    80002874:	854a                	mv	a0,s2
    80002876:	70a2                	ld	ra,40(sp)
    80002878:	7402                	ld	s0,32(sp)
    8000287a:	64e2                	ld	s1,24(sp)
    8000287c:	6942                	ld	s2,16(sp)
    8000287e:	69a2                	ld	s3,8(sp)
    80002880:	6a02                	ld	s4,0(sp)
    80002882:	6145                	addi	sp,sp,48
    80002884:	8082                	ret
            addr = balloc(ip->dev);
    80002886:	0009a503          	lw	a0,0(s3)
    8000288a:	00000097          	auipc	ra,0x0
    8000288e:	e10080e7          	jalr	-496(ra) # 8000269a <balloc>
    80002892:	0005091b          	sext.w	s2,a0
            if (addr)
    80002896:	fc090ae3          	beqz	s2,8000286a <bmap+0x98>
                a[bn] = addr;
    8000289a:	0124a023          	sw	s2,0(s1)
                log_write(bp);
    8000289e:	8552                	mv	a0,s4
    800028a0:	00001097          	auipc	ra,0x1
    800028a4:	eec080e7          	jalr	-276(ra) # 8000378c <log_write>
    800028a8:	b7c9                	j	8000286a <bmap+0x98>
    panic("bmap: out of range");
    800028aa:	00006517          	auipc	a0,0x6
    800028ae:	c3e50513          	addi	a0,a0,-962 # 800084e8 <syscalls+0x128>
    800028b2:	00003097          	auipc	ra,0x3
    800028b6:	6d0080e7          	jalr	1744(ra) # 80005f82 <panic>

00000000800028ba <iget>:
{
    800028ba:	7179                	addi	sp,sp,-48
    800028bc:	f406                	sd	ra,40(sp)
    800028be:	f022                	sd	s0,32(sp)
    800028c0:	ec26                	sd	s1,24(sp)
    800028c2:	e84a                	sd	s2,16(sp)
    800028c4:	e44e                	sd	s3,8(sp)
    800028c6:	e052                	sd	s4,0(sp)
    800028c8:	1800                	addi	s0,sp,48
    800028ca:	89aa                	mv	s3,a0
    800028cc:	8a2e                	mv	s4,a1
    acquire(&itable.lock);
    800028ce:	00026517          	auipc	a0,0x26
    800028d2:	57a50513          	addi	a0,a0,1402 # 80028e48 <itable>
    800028d6:	00004097          	auipc	ra,0x4
    800028da:	bf6080e7          	jalr	-1034(ra) # 800064cc <acquire>
    empty = 0;
    800028de:	4901                	li	s2,0
    for (ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++)
    800028e0:	00026497          	auipc	s1,0x26
    800028e4:	58048493          	addi	s1,s1,1408 # 80028e60 <itable+0x18>
    800028e8:	00028697          	auipc	a3,0x28
    800028ec:	00868693          	addi	a3,a3,8 # 8002a8f0 <log>
    800028f0:	a039                	j	800028fe <iget+0x44>
        if (empty == 0 && ip->ref == 0) // Remember empty slot.
    800028f2:	02090b63          	beqz	s2,80002928 <iget+0x6e>
    for (ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++)
    800028f6:	08848493          	addi	s1,s1,136
    800028fa:	02d48a63          	beq	s1,a3,8000292e <iget+0x74>
        if (ip->ref > 0 && ip->dev == dev && ip->inum == inum)
    800028fe:	449c                	lw	a5,8(s1)
    80002900:	fef059e3          	blez	a5,800028f2 <iget+0x38>
    80002904:	4098                	lw	a4,0(s1)
    80002906:	ff3716e3          	bne	a4,s3,800028f2 <iget+0x38>
    8000290a:	40d8                	lw	a4,4(s1)
    8000290c:	ff4713e3          	bne	a4,s4,800028f2 <iget+0x38>
            ip->ref++;
    80002910:	2785                	addiw	a5,a5,1
    80002912:	c49c                	sw	a5,8(s1)
            release(&itable.lock);
    80002914:	00026517          	auipc	a0,0x26
    80002918:	53450513          	addi	a0,a0,1332 # 80028e48 <itable>
    8000291c:	00004097          	auipc	ra,0x4
    80002920:	c64080e7          	jalr	-924(ra) # 80006580 <release>
            return ip;
    80002924:	8926                	mv	s2,s1
    80002926:	a03d                	j	80002954 <iget+0x9a>
        if (empty == 0 && ip->ref == 0) // Remember empty slot.
    80002928:	f7f9                	bnez	a5,800028f6 <iget+0x3c>
    8000292a:	8926                	mv	s2,s1
    8000292c:	b7e9                	j	800028f6 <iget+0x3c>
    if (empty == 0)
    8000292e:	02090c63          	beqz	s2,80002966 <iget+0xac>
    ip->dev = dev;
    80002932:	01392023          	sw	s3,0(s2)
    ip->inum = inum;
    80002936:	01492223          	sw	s4,4(s2)
    ip->ref = 1;
    8000293a:	4785                	li	a5,1
    8000293c:	00f92423          	sw	a5,8(s2)
    ip->valid = 0;
    80002940:	04092023          	sw	zero,64(s2)
    release(&itable.lock);
    80002944:	00026517          	auipc	a0,0x26
    80002948:	50450513          	addi	a0,a0,1284 # 80028e48 <itable>
    8000294c:	00004097          	auipc	ra,0x4
    80002950:	c34080e7          	jalr	-972(ra) # 80006580 <release>
}
    80002954:	854a                	mv	a0,s2
    80002956:	70a2                	ld	ra,40(sp)
    80002958:	7402                	ld	s0,32(sp)
    8000295a:	64e2                	ld	s1,24(sp)
    8000295c:	6942                	ld	s2,16(sp)
    8000295e:	69a2                	ld	s3,8(sp)
    80002960:	6a02                	ld	s4,0(sp)
    80002962:	6145                	addi	sp,sp,48
    80002964:	8082                	ret
        panic("iget: no inodes");
    80002966:	00006517          	auipc	a0,0x6
    8000296a:	b9a50513          	addi	a0,a0,-1126 # 80008500 <syscalls+0x140>
    8000296e:	00003097          	auipc	ra,0x3
    80002972:	614080e7          	jalr	1556(ra) # 80005f82 <panic>

0000000080002976 <fsinit>:
{
    80002976:	7179                	addi	sp,sp,-48
    80002978:	f406                	sd	ra,40(sp)
    8000297a:	f022                	sd	s0,32(sp)
    8000297c:	ec26                	sd	s1,24(sp)
    8000297e:	e84a                	sd	s2,16(sp)
    80002980:	e44e                	sd	s3,8(sp)
    80002982:	1800                	addi	s0,sp,48
    80002984:	892a                	mv	s2,a0
    bp = bread(dev, 1);
    80002986:	4585                	li	a1,1
    80002988:	00000097          	auipc	ra,0x0
    8000298c:	a50080e7          	jalr	-1456(ra) # 800023d8 <bread>
    80002990:	84aa                	mv	s1,a0
    memmove(sb, bp->data, sizeof(*sb));
    80002992:	00026997          	auipc	s3,0x26
    80002996:	49698993          	addi	s3,s3,1174 # 80028e28 <sb>
    8000299a:	02000613          	li	a2,32
    8000299e:	05850593          	addi	a1,a0,88
    800029a2:	854e                	mv	a0,s3
    800029a4:	ffffe097          	auipc	ra,0xffffe
    800029a8:	834080e7          	jalr	-1996(ra) # 800001d8 <memmove>
    brelse(bp);
    800029ac:	8526                	mv	a0,s1
    800029ae:	00000097          	auipc	ra,0x0
    800029b2:	b5a080e7          	jalr	-1190(ra) # 80002508 <brelse>
    if (sb.magic != FSMAGIC)
    800029b6:	0009a703          	lw	a4,0(s3)
    800029ba:	102037b7          	lui	a5,0x10203
    800029be:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800029c2:	02f71263          	bne	a4,a5,800029e6 <fsinit+0x70>
    initlog(dev, &sb);
    800029c6:	00026597          	auipc	a1,0x26
    800029ca:	46258593          	addi	a1,a1,1122 # 80028e28 <sb>
    800029ce:	854a                	mv	a0,s2
    800029d0:	00001097          	auipc	ra,0x1
    800029d4:	b40080e7          	jalr	-1216(ra) # 80003510 <initlog>
}
    800029d8:	70a2                	ld	ra,40(sp)
    800029da:	7402                	ld	s0,32(sp)
    800029dc:	64e2                	ld	s1,24(sp)
    800029de:	6942                	ld	s2,16(sp)
    800029e0:	69a2                	ld	s3,8(sp)
    800029e2:	6145                	addi	sp,sp,48
    800029e4:	8082                	ret
        panic("invalid file system");
    800029e6:	00006517          	auipc	a0,0x6
    800029ea:	b2a50513          	addi	a0,a0,-1238 # 80008510 <syscalls+0x150>
    800029ee:	00003097          	auipc	ra,0x3
    800029f2:	594080e7          	jalr	1428(ra) # 80005f82 <panic>

00000000800029f6 <iinit>:
{
    800029f6:	7179                	addi	sp,sp,-48
    800029f8:	f406                	sd	ra,40(sp)
    800029fa:	f022                	sd	s0,32(sp)
    800029fc:	ec26                	sd	s1,24(sp)
    800029fe:	e84a                	sd	s2,16(sp)
    80002a00:	e44e                	sd	s3,8(sp)
    80002a02:	1800                	addi	s0,sp,48
    initlock(&itable.lock, "itable");
    80002a04:	00006597          	auipc	a1,0x6
    80002a08:	b2458593          	addi	a1,a1,-1244 # 80008528 <syscalls+0x168>
    80002a0c:	00026517          	auipc	a0,0x26
    80002a10:	43c50513          	addi	a0,a0,1084 # 80028e48 <itable>
    80002a14:	00004097          	auipc	ra,0x4
    80002a18:	a28080e7          	jalr	-1496(ra) # 8000643c <initlock>
    for (i = 0; i < NINODE; i++)
    80002a1c:	00026497          	auipc	s1,0x26
    80002a20:	45448493          	addi	s1,s1,1108 # 80028e70 <itable+0x28>
    80002a24:	00028997          	auipc	s3,0x28
    80002a28:	edc98993          	addi	s3,s3,-292 # 8002a900 <log+0x10>
        initsleeplock(&itable.inode[i].lock, "inode");
    80002a2c:	00006917          	auipc	s2,0x6
    80002a30:	b0490913          	addi	s2,s2,-1276 # 80008530 <syscalls+0x170>
    80002a34:	85ca                	mv	a1,s2
    80002a36:	8526                	mv	a0,s1
    80002a38:	00001097          	auipc	ra,0x1
    80002a3c:	e3a080e7          	jalr	-454(ra) # 80003872 <initsleeplock>
    for (i = 0; i < NINODE; i++)
    80002a40:	08848493          	addi	s1,s1,136
    80002a44:	ff3498e3          	bne	s1,s3,80002a34 <iinit+0x3e>
}
    80002a48:	70a2                	ld	ra,40(sp)
    80002a4a:	7402                	ld	s0,32(sp)
    80002a4c:	64e2                	ld	s1,24(sp)
    80002a4e:	6942                	ld	s2,16(sp)
    80002a50:	69a2                	ld	s3,8(sp)
    80002a52:	6145                	addi	sp,sp,48
    80002a54:	8082                	ret

0000000080002a56 <ialloc>:
{
    80002a56:	715d                	addi	sp,sp,-80
    80002a58:	e486                	sd	ra,72(sp)
    80002a5a:	e0a2                	sd	s0,64(sp)
    80002a5c:	fc26                	sd	s1,56(sp)
    80002a5e:	f84a                	sd	s2,48(sp)
    80002a60:	f44e                	sd	s3,40(sp)
    80002a62:	f052                	sd	s4,32(sp)
    80002a64:	ec56                	sd	s5,24(sp)
    80002a66:	e85a                	sd	s6,16(sp)
    80002a68:	e45e                	sd	s7,8(sp)
    80002a6a:	0880                	addi	s0,sp,80
    for (inum = 1; inum < sb.ninodes; inum++)
    80002a6c:	00026717          	auipc	a4,0x26
    80002a70:	3c872703          	lw	a4,968(a4) # 80028e34 <sb+0xc>
    80002a74:	4785                	li	a5,1
    80002a76:	04e7fa63          	bgeu	a5,a4,80002aca <ialloc+0x74>
    80002a7a:	8aaa                	mv	s5,a0
    80002a7c:	8bae                	mv	s7,a1
    80002a7e:	4485                	li	s1,1
        bp = bread(dev, IBLOCK(inum, sb));
    80002a80:	00026a17          	auipc	s4,0x26
    80002a84:	3a8a0a13          	addi	s4,s4,936 # 80028e28 <sb>
    80002a88:	00048b1b          	sext.w	s6,s1
    80002a8c:	0044d593          	srli	a1,s1,0x4
    80002a90:	018a2783          	lw	a5,24(s4)
    80002a94:	9dbd                	addw	a1,a1,a5
    80002a96:	8556                	mv	a0,s5
    80002a98:	00000097          	auipc	ra,0x0
    80002a9c:	940080e7          	jalr	-1728(ra) # 800023d8 <bread>
    80002aa0:	892a                	mv	s2,a0
        dip = (struct dinode *)bp->data + inum % IPB;
    80002aa2:	05850993          	addi	s3,a0,88
    80002aa6:	00f4f793          	andi	a5,s1,15
    80002aaa:	079a                	slli	a5,a5,0x6
    80002aac:	99be                	add	s3,s3,a5
        if (dip->type == 0)
    80002aae:	00099783          	lh	a5,0(s3)
    80002ab2:	c3a1                	beqz	a5,80002af2 <ialloc+0x9c>
        brelse(bp);
    80002ab4:	00000097          	auipc	ra,0x0
    80002ab8:	a54080e7          	jalr	-1452(ra) # 80002508 <brelse>
    for (inum = 1; inum < sb.ninodes; inum++)
    80002abc:	0485                	addi	s1,s1,1
    80002abe:	00ca2703          	lw	a4,12(s4)
    80002ac2:	0004879b          	sext.w	a5,s1
    80002ac6:	fce7e1e3          	bltu	a5,a4,80002a88 <ialloc+0x32>
    printf("ialloc: no inodes\n");
    80002aca:	00006517          	auipc	a0,0x6
    80002ace:	a6e50513          	addi	a0,a0,-1426 # 80008538 <syscalls+0x178>
    80002ad2:	00003097          	auipc	ra,0x3
    80002ad6:	4fa080e7          	jalr	1274(ra) # 80005fcc <printf>
    return 0;
    80002ada:	4501                	li	a0,0
}
    80002adc:	60a6                	ld	ra,72(sp)
    80002ade:	6406                	ld	s0,64(sp)
    80002ae0:	74e2                	ld	s1,56(sp)
    80002ae2:	7942                	ld	s2,48(sp)
    80002ae4:	79a2                	ld	s3,40(sp)
    80002ae6:	7a02                	ld	s4,32(sp)
    80002ae8:	6ae2                	ld	s5,24(sp)
    80002aea:	6b42                	ld	s6,16(sp)
    80002aec:	6ba2                	ld	s7,8(sp)
    80002aee:	6161                	addi	sp,sp,80
    80002af0:	8082                	ret
            memset(dip, 0, sizeof(*dip));
    80002af2:	04000613          	li	a2,64
    80002af6:	4581                	li	a1,0
    80002af8:	854e                	mv	a0,s3
    80002afa:	ffffd097          	auipc	ra,0xffffd
    80002afe:	67e080e7          	jalr	1662(ra) # 80000178 <memset>
            dip->type = type;
    80002b02:	01799023          	sh	s7,0(s3)
            log_write(bp); // mark it allocated on the disk
    80002b06:	854a                	mv	a0,s2
    80002b08:	00001097          	auipc	ra,0x1
    80002b0c:	c84080e7          	jalr	-892(ra) # 8000378c <log_write>
            brelse(bp);
    80002b10:	854a                	mv	a0,s2
    80002b12:	00000097          	auipc	ra,0x0
    80002b16:	9f6080e7          	jalr	-1546(ra) # 80002508 <brelse>
            return iget(dev, inum);
    80002b1a:	85da                	mv	a1,s6
    80002b1c:	8556                	mv	a0,s5
    80002b1e:	00000097          	auipc	ra,0x0
    80002b22:	d9c080e7          	jalr	-612(ra) # 800028ba <iget>
    80002b26:	bf5d                	j	80002adc <ialloc+0x86>

0000000080002b28 <iupdate>:
{
    80002b28:	1101                	addi	sp,sp,-32
    80002b2a:	ec06                	sd	ra,24(sp)
    80002b2c:	e822                	sd	s0,16(sp)
    80002b2e:	e426                	sd	s1,8(sp)
    80002b30:	e04a                	sd	s2,0(sp)
    80002b32:	1000                	addi	s0,sp,32
    80002b34:	84aa                	mv	s1,a0
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002b36:	415c                	lw	a5,4(a0)
    80002b38:	0047d79b          	srliw	a5,a5,0x4
    80002b3c:	00026597          	auipc	a1,0x26
    80002b40:	3045a583          	lw	a1,772(a1) # 80028e40 <sb+0x18>
    80002b44:	9dbd                	addw	a1,a1,a5
    80002b46:	4108                	lw	a0,0(a0)
    80002b48:	00000097          	auipc	ra,0x0
    80002b4c:	890080e7          	jalr	-1904(ra) # 800023d8 <bread>
    80002b50:	892a                	mv	s2,a0
    dip = (struct dinode *)bp->data + ip->inum % IPB;
    80002b52:	05850793          	addi	a5,a0,88
    80002b56:	40c8                	lw	a0,4(s1)
    80002b58:	893d                	andi	a0,a0,15
    80002b5a:	051a                	slli	a0,a0,0x6
    80002b5c:	953e                	add	a0,a0,a5
    dip->type = ip->type;
    80002b5e:	04449703          	lh	a4,68(s1)
    80002b62:	00e51023          	sh	a4,0(a0)
    dip->major = ip->major;
    80002b66:	04649703          	lh	a4,70(s1)
    80002b6a:	00e51123          	sh	a4,2(a0)
    dip->minor = ip->minor;
    80002b6e:	04849703          	lh	a4,72(s1)
    80002b72:	00e51223          	sh	a4,4(a0)
    dip->nlink = ip->nlink;
    80002b76:	04a49703          	lh	a4,74(s1)
    80002b7a:	00e51323          	sh	a4,6(a0)
    dip->size = ip->size;
    80002b7e:	44f8                	lw	a4,76(s1)
    80002b80:	c518                	sw	a4,8(a0)
    memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002b82:	03400613          	li	a2,52
    80002b86:	05048593          	addi	a1,s1,80
    80002b8a:	0531                	addi	a0,a0,12
    80002b8c:	ffffd097          	auipc	ra,0xffffd
    80002b90:	64c080e7          	jalr	1612(ra) # 800001d8 <memmove>
    log_write(bp);
    80002b94:	854a                	mv	a0,s2
    80002b96:	00001097          	auipc	ra,0x1
    80002b9a:	bf6080e7          	jalr	-1034(ra) # 8000378c <log_write>
    brelse(bp);
    80002b9e:	854a                	mv	a0,s2
    80002ba0:	00000097          	auipc	ra,0x0
    80002ba4:	968080e7          	jalr	-1688(ra) # 80002508 <brelse>
}
    80002ba8:	60e2                	ld	ra,24(sp)
    80002baa:	6442                	ld	s0,16(sp)
    80002bac:	64a2                	ld	s1,8(sp)
    80002bae:	6902                	ld	s2,0(sp)
    80002bb0:	6105                	addi	sp,sp,32
    80002bb2:	8082                	ret

0000000080002bb4 <idup>:
{
    80002bb4:	1101                	addi	sp,sp,-32
    80002bb6:	ec06                	sd	ra,24(sp)
    80002bb8:	e822                	sd	s0,16(sp)
    80002bba:	e426                	sd	s1,8(sp)
    80002bbc:	1000                	addi	s0,sp,32
    80002bbe:	84aa                	mv	s1,a0
    acquire(&itable.lock);
    80002bc0:	00026517          	auipc	a0,0x26
    80002bc4:	28850513          	addi	a0,a0,648 # 80028e48 <itable>
    80002bc8:	00004097          	auipc	ra,0x4
    80002bcc:	904080e7          	jalr	-1788(ra) # 800064cc <acquire>
    ip->ref++;
    80002bd0:	449c                	lw	a5,8(s1)
    80002bd2:	2785                	addiw	a5,a5,1
    80002bd4:	c49c                	sw	a5,8(s1)
    release(&itable.lock);
    80002bd6:	00026517          	auipc	a0,0x26
    80002bda:	27250513          	addi	a0,a0,626 # 80028e48 <itable>
    80002bde:	00004097          	auipc	ra,0x4
    80002be2:	9a2080e7          	jalr	-1630(ra) # 80006580 <release>
}
    80002be6:	8526                	mv	a0,s1
    80002be8:	60e2                	ld	ra,24(sp)
    80002bea:	6442                	ld	s0,16(sp)
    80002bec:	64a2                	ld	s1,8(sp)
    80002bee:	6105                	addi	sp,sp,32
    80002bf0:	8082                	ret

0000000080002bf2 <ilock>:
{
    80002bf2:	1101                	addi	sp,sp,-32
    80002bf4:	ec06                	sd	ra,24(sp)
    80002bf6:	e822                	sd	s0,16(sp)
    80002bf8:	e426                	sd	s1,8(sp)
    80002bfa:	e04a                	sd	s2,0(sp)
    80002bfc:	1000                	addi	s0,sp,32
    if (ip == 0 || ip->ref < 1)
    80002bfe:	c115                	beqz	a0,80002c22 <ilock+0x30>
    80002c00:	84aa                	mv	s1,a0
    80002c02:	451c                	lw	a5,8(a0)
    80002c04:	00f05f63          	blez	a5,80002c22 <ilock+0x30>
    acquiresleep(&ip->lock);
    80002c08:	0541                	addi	a0,a0,16
    80002c0a:	00001097          	auipc	ra,0x1
    80002c0e:	ca2080e7          	jalr	-862(ra) # 800038ac <acquiresleep>
    if (ip->valid == 0)
    80002c12:	40bc                	lw	a5,64(s1)
    80002c14:	cf99                	beqz	a5,80002c32 <ilock+0x40>
}
    80002c16:	60e2                	ld	ra,24(sp)
    80002c18:	6442                	ld	s0,16(sp)
    80002c1a:	64a2                	ld	s1,8(sp)
    80002c1c:	6902                	ld	s2,0(sp)
    80002c1e:	6105                	addi	sp,sp,32
    80002c20:	8082                	ret
        panic("ilock");
    80002c22:	00006517          	auipc	a0,0x6
    80002c26:	92e50513          	addi	a0,a0,-1746 # 80008550 <syscalls+0x190>
    80002c2a:	00003097          	auipc	ra,0x3
    80002c2e:	358080e7          	jalr	856(ra) # 80005f82 <panic>
        bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002c32:	40dc                	lw	a5,4(s1)
    80002c34:	0047d79b          	srliw	a5,a5,0x4
    80002c38:	00026597          	auipc	a1,0x26
    80002c3c:	2085a583          	lw	a1,520(a1) # 80028e40 <sb+0x18>
    80002c40:	9dbd                	addw	a1,a1,a5
    80002c42:	4088                	lw	a0,0(s1)
    80002c44:	fffff097          	auipc	ra,0xfffff
    80002c48:	794080e7          	jalr	1940(ra) # 800023d8 <bread>
    80002c4c:	892a                	mv	s2,a0
        dip = (struct dinode *)bp->data + ip->inum % IPB;
    80002c4e:	05850593          	addi	a1,a0,88
    80002c52:	40dc                	lw	a5,4(s1)
    80002c54:	8bbd                	andi	a5,a5,15
    80002c56:	079a                	slli	a5,a5,0x6
    80002c58:	95be                	add	a1,a1,a5
        ip->type = dip->type;
    80002c5a:	00059783          	lh	a5,0(a1)
    80002c5e:	04f49223          	sh	a5,68(s1)
        ip->major = dip->major;
    80002c62:	00259783          	lh	a5,2(a1)
    80002c66:	04f49323          	sh	a5,70(s1)
        ip->minor = dip->minor;
    80002c6a:	00459783          	lh	a5,4(a1)
    80002c6e:	04f49423          	sh	a5,72(s1)
        ip->nlink = dip->nlink;
    80002c72:	00659783          	lh	a5,6(a1)
    80002c76:	04f49523          	sh	a5,74(s1)
        ip->size = dip->size;
    80002c7a:	459c                	lw	a5,8(a1)
    80002c7c:	c4fc                	sw	a5,76(s1)
        memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002c7e:	03400613          	li	a2,52
    80002c82:	05b1                	addi	a1,a1,12
    80002c84:	05048513          	addi	a0,s1,80
    80002c88:	ffffd097          	auipc	ra,0xffffd
    80002c8c:	550080e7          	jalr	1360(ra) # 800001d8 <memmove>
        brelse(bp);
    80002c90:	854a                	mv	a0,s2
    80002c92:	00000097          	auipc	ra,0x0
    80002c96:	876080e7          	jalr	-1930(ra) # 80002508 <brelse>
        ip->valid = 1;
    80002c9a:	4785                	li	a5,1
    80002c9c:	c0bc                	sw	a5,64(s1)
        if (ip->type == 0)
    80002c9e:	04449783          	lh	a5,68(s1)
    80002ca2:	fbb5                	bnez	a5,80002c16 <ilock+0x24>
            panic("ilock: no type");
    80002ca4:	00006517          	auipc	a0,0x6
    80002ca8:	8b450513          	addi	a0,a0,-1868 # 80008558 <syscalls+0x198>
    80002cac:	00003097          	auipc	ra,0x3
    80002cb0:	2d6080e7          	jalr	726(ra) # 80005f82 <panic>

0000000080002cb4 <iunlock>:
{
    80002cb4:	1101                	addi	sp,sp,-32
    80002cb6:	ec06                	sd	ra,24(sp)
    80002cb8:	e822                	sd	s0,16(sp)
    80002cba:	e426                	sd	s1,8(sp)
    80002cbc:	e04a                	sd	s2,0(sp)
    80002cbe:	1000                	addi	s0,sp,32
    if (ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002cc0:	c905                	beqz	a0,80002cf0 <iunlock+0x3c>
    80002cc2:	84aa                	mv	s1,a0
    80002cc4:	01050913          	addi	s2,a0,16
    80002cc8:	854a                	mv	a0,s2
    80002cca:	00001097          	auipc	ra,0x1
    80002cce:	c7c080e7          	jalr	-900(ra) # 80003946 <holdingsleep>
    80002cd2:	cd19                	beqz	a0,80002cf0 <iunlock+0x3c>
    80002cd4:	449c                	lw	a5,8(s1)
    80002cd6:	00f05d63          	blez	a5,80002cf0 <iunlock+0x3c>
    releasesleep(&ip->lock);
    80002cda:	854a                	mv	a0,s2
    80002cdc:	00001097          	auipc	ra,0x1
    80002ce0:	c26080e7          	jalr	-986(ra) # 80003902 <releasesleep>
}
    80002ce4:	60e2                	ld	ra,24(sp)
    80002ce6:	6442                	ld	s0,16(sp)
    80002ce8:	64a2                	ld	s1,8(sp)
    80002cea:	6902                	ld	s2,0(sp)
    80002cec:	6105                	addi	sp,sp,32
    80002cee:	8082                	ret
        panic("iunlock");
    80002cf0:	00006517          	auipc	a0,0x6
    80002cf4:	87850513          	addi	a0,a0,-1928 # 80008568 <syscalls+0x1a8>
    80002cf8:	00003097          	auipc	ra,0x3
    80002cfc:	28a080e7          	jalr	650(ra) # 80005f82 <panic>

0000000080002d00 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void itrunc(struct inode *ip)
{
    80002d00:	7179                	addi	sp,sp,-48
    80002d02:	f406                	sd	ra,40(sp)
    80002d04:	f022                	sd	s0,32(sp)
    80002d06:	ec26                	sd	s1,24(sp)
    80002d08:	e84a                	sd	s2,16(sp)
    80002d0a:	e44e                	sd	s3,8(sp)
    80002d0c:	e052                	sd	s4,0(sp)
    80002d0e:	1800                	addi	s0,sp,48
    80002d10:	89aa                	mv	s3,a0
    int i, j;
    struct buf *bp;
    uint *a;

    for (i = 0; i < NDIRECT; i++)
    80002d12:	05050493          	addi	s1,a0,80
    80002d16:	08050913          	addi	s2,a0,128
    80002d1a:	a021                	j	80002d22 <itrunc+0x22>
    80002d1c:	0491                	addi	s1,s1,4
    80002d1e:	01248d63          	beq	s1,s2,80002d38 <itrunc+0x38>
    {
        if (ip->addrs[i])
    80002d22:	408c                	lw	a1,0(s1)
    80002d24:	dde5                	beqz	a1,80002d1c <itrunc+0x1c>
        {
            bfree(ip->dev, ip->addrs[i]);
    80002d26:	0009a503          	lw	a0,0(s3)
    80002d2a:	00000097          	auipc	ra,0x0
    80002d2e:	8f4080e7          	jalr	-1804(ra) # 8000261e <bfree>
            ip->addrs[i] = 0;
    80002d32:	0004a023          	sw	zero,0(s1)
    80002d36:	b7dd                	j	80002d1c <itrunc+0x1c>
        }
    }

    if (ip->addrs[NDIRECT])
    80002d38:	0809a583          	lw	a1,128(s3)
    80002d3c:	e185                	bnez	a1,80002d5c <itrunc+0x5c>
        brelse(bp);
        bfree(ip->dev, ip->addrs[NDIRECT]);
        ip->addrs[NDIRECT] = 0;
    }

    ip->size = 0;
    80002d3e:	0409a623          	sw	zero,76(s3)
    iupdate(ip);
    80002d42:	854e                	mv	a0,s3
    80002d44:	00000097          	auipc	ra,0x0
    80002d48:	de4080e7          	jalr	-540(ra) # 80002b28 <iupdate>
}
    80002d4c:	70a2                	ld	ra,40(sp)
    80002d4e:	7402                	ld	s0,32(sp)
    80002d50:	64e2                	ld	s1,24(sp)
    80002d52:	6942                	ld	s2,16(sp)
    80002d54:	69a2                	ld	s3,8(sp)
    80002d56:	6a02                	ld	s4,0(sp)
    80002d58:	6145                	addi	sp,sp,48
    80002d5a:	8082                	ret
        bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002d5c:	0009a503          	lw	a0,0(s3)
    80002d60:	fffff097          	auipc	ra,0xfffff
    80002d64:	678080e7          	jalr	1656(ra) # 800023d8 <bread>
    80002d68:	8a2a                	mv	s4,a0
        for (j = 0; j < NINDIRECT; j++)
    80002d6a:	05850493          	addi	s1,a0,88
    80002d6e:	45850913          	addi	s2,a0,1112
    80002d72:	a811                	j	80002d86 <itrunc+0x86>
                bfree(ip->dev, a[j]);
    80002d74:	0009a503          	lw	a0,0(s3)
    80002d78:	00000097          	auipc	ra,0x0
    80002d7c:	8a6080e7          	jalr	-1882(ra) # 8000261e <bfree>
        for (j = 0; j < NINDIRECT; j++)
    80002d80:	0491                	addi	s1,s1,4
    80002d82:	01248563          	beq	s1,s2,80002d8c <itrunc+0x8c>
            if (a[j])
    80002d86:	408c                	lw	a1,0(s1)
    80002d88:	dde5                	beqz	a1,80002d80 <itrunc+0x80>
    80002d8a:	b7ed                	j	80002d74 <itrunc+0x74>
        brelse(bp);
    80002d8c:	8552                	mv	a0,s4
    80002d8e:	fffff097          	auipc	ra,0xfffff
    80002d92:	77a080e7          	jalr	1914(ra) # 80002508 <brelse>
        bfree(ip->dev, ip->addrs[NDIRECT]);
    80002d96:	0809a583          	lw	a1,128(s3)
    80002d9a:	0009a503          	lw	a0,0(s3)
    80002d9e:	00000097          	auipc	ra,0x0
    80002da2:	880080e7          	jalr	-1920(ra) # 8000261e <bfree>
        ip->addrs[NDIRECT] = 0;
    80002da6:	0809a023          	sw	zero,128(s3)
    80002daa:	bf51                	j	80002d3e <itrunc+0x3e>

0000000080002dac <iput>:
{
    80002dac:	1101                	addi	sp,sp,-32
    80002dae:	ec06                	sd	ra,24(sp)
    80002db0:	e822                	sd	s0,16(sp)
    80002db2:	e426                	sd	s1,8(sp)
    80002db4:	e04a                	sd	s2,0(sp)
    80002db6:	1000                	addi	s0,sp,32
    80002db8:	84aa                	mv	s1,a0
    acquire(&itable.lock);
    80002dba:	00026517          	auipc	a0,0x26
    80002dbe:	08e50513          	addi	a0,a0,142 # 80028e48 <itable>
    80002dc2:	00003097          	auipc	ra,0x3
    80002dc6:	70a080e7          	jalr	1802(ra) # 800064cc <acquire>
    if (ip->ref == 1 && ip->valid && ip->nlink == 0)
    80002dca:	4498                	lw	a4,8(s1)
    80002dcc:	4785                	li	a5,1
    80002dce:	02f70363          	beq	a4,a5,80002df4 <iput+0x48>
    ip->ref--;
    80002dd2:	449c                	lw	a5,8(s1)
    80002dd4:	37fd                	addiw	a5,a5,-1
    80002dd6:	c49c                	sw	a5,8(s1)
    release(&itable.lock);
    80002dd8:	00026517          	auipc	a0,0x26
    80002ddc:	07050513          	addi	a0,a0,112 # 80028e48 <itable>
    80002de0:	00003097          	auipc	ra,0x3
    80002de4:	7a0080e7          	jalr	1952(ra) # 80006580 <release>
}
    80002de8:	60e2                	ld	ra,24(sp)
    80002dea:	6442                	ld	s0,16(sp)
    80002dec:	64a2                	ld	s1,8(sp)
    80002dee:	6902                	ld	s2,0(sp)
    80002df0:	6105                	addi	sp,sp,32
    80002df2:	8082                	ret
    if (ip->ref == 1 && ip->valid && ip->nlink == 0)
    80002df4:	40bc                	lw	a5,64(s1)
    80002df6:	dff1                	beqz	a5,80002dd2 <iput+0x26>
    80002df8:	04a49783          	lh	a5,74(s1)
    80002dfc:	fbf9                	bnez	a5,80002dd2 <iput+0x26>
        acquiresleep(&ip->lock);
    80002dfe:	01048913          	addi	s2,s1,16
    80002e02:	854a                	mv	a0,s2
    80002e04:	00001097          	auipc	ra,0x1
    80002e08:	aa8080e7          	jalr	-1368(ra) # 800038ac <acquiresleep>
        release(&itable.lock);
    80002e0c:	00026517          	auipc	a0,0x26
    80002e10:	03c50513          	addi	a0,a0,60 # 80028e48 <itable>
    80002e14:	00003097          	auipc	ra,0x3
    80002e18:	76c080e7          	jalr	1900(ra) # 80006580 <release>
        itrunc(ip);
    80002e1c:	8526                	mv	a0,s1
    80002e1e:	00000097          	auipc	ra,0x0
    80002e22:	ee2080e7          	jalr	-286(ra) # 80002d00 <itrunc>
        ip->type = 0;
    80002e26:	04049223          	sh	zero,68(s1)
        iupdate(ip);
    80002e2a:	8526                	mv	a0,s1
    80002e2c:	00000097          	auipc	ra,0x0
    80002e30:	cfc080e7          	jalr	-772(ra) # 80002b28 <iupdate>
        ip->valid = 0;
    80002e34:	0404a023          	sw	zero,64(s1)
        releasesleep(&ip->lock);
    80002e38:	854a                	mv	a0,s2
    80002e3a:	00001097          	auipc	ra,0x1
    80002e3e:	ac8080e7          	jalr	-1336(ra) # 80003902 <releasesleep>
        acquire(&itable.lock);
    80002e42:	00026517          	auipc	a0,0x26
    80002e46:	00650513          	addi	a0,a0,6 # 80028e48 <itable>
    80002e4a:	00003097          	auipc	ra,0x3
    80002e4e:	682080e7          	jalr	1666(ra) # 800064cc <acquire>
    80002e52:	b741                	j	80002dd2 <iput+0x26>

0000000080002e54 <iunlockput>:
{
    80002e54:	1101                	addi	sp,sp,-32
    80002e56:	ec06                	sd	ra,24(sp)
    80002e58:	e822                	sd	s0,16(sp)
    80002e5a:	e426                	sd	s1,8(sp)
    80002e5c:	1000                	addi	s0,sp,32
    80002e5e:	84aa                	mv	s1,a0
    iunlock(ip);
    80002e60:	00000097          	auipc	ra,0x0
    80002e64:	e54080e7          	jalr	-428(ra) # 80002cb4 <iunlock>
    iput(ip);
    80002e68:	8526                	mv	a0,s1
    80002e6a:	00000097          	auipc	ra,0x0
    80002e6e:	f42080e7          	jalr	-190(ra) # 80002dac <iput>
}
    80002e72:	60e2                	ld	ra,24(sp)
    80002e74:	6442                	ld	s0,16(sp)
    80002e76:	64a2                	ld	s1,8(sp)
    80002e78:	6105                	addi	sp,sp,32
    80002e7a:	8082                	ret

0000000080002e7c <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void stati(struct inode *ip, struct stat *st)
{
    80002e7c:	1141                	addi	sp,sp,-16
    80002e7e:	e422                	sd	s0,8(sp)
    80002e80:	0800                	addi	s0,sp,16
    st->dev = ip->dev;
    80002e82:	411c                	lw	a5,0(a0)
    80002e84:	c19c                	sw	a5,0(a1)
    st->ino = ip->inum;
    80002e86:	415c                	lw	a5,4(a0)
    80002e88:	c1dc                	sw	a5,4(a1)
    st->type = ip->type;
    80002e8a:	04451783          	lh	a5,68(a0)
    80002e8e:	00f59423          	sh	a5,8(a1)
    st->nlink = ip->nlink;
    80002e92:	04a51783          	lh	a5,74(a0)
    80002e96:	00f59523          	sh	a5,10(a1)
    st->size = ip->size;
    80002e9a:	04c56783          	lwu	a5,76(a0)
    80002e9e:	e99c                	sd	a5,16(a1)
}
    80002ea0:	6422                	ld	s0,8(sp)
    80002ea2:	0141                	addi	sp,sp,16
    80002ea4:	8082                	ret

0000000080002ea6 <readi>:
int readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
    uint tot, m;
    struct buf *bp;

    if (off > ip->size || off + n < off)
    80002ea6:	457c                	lw	a5,76(a0)
    80002ea8:	0ed7e963          	bltu	a5,a3,80002f9a <readi+0xf4>
{
    80002eac:	7159                	addi	sp,sp,-112
    80002eae:	f486                	sd	ra,104(sp)
    80002eb0:	f0a2                	sd	s0,96(sp)
    80002eb2:	eca6                	sd	s1,88(sp)
    80002eb4:	e8ca                	sd	s2,80(sp)
    80002eb6:	e4ce                	sd	s3,72(sp)
    80002eb8:	e0d2                	sd	s4,64(sp)
    80002eba:	fc56                	sd	s5,56(sp)
    80002ebc:	f85a                	sd	s6,48(sp)
    80002ebe:	f45e                	sd	s7,40(sp)
    80002ec0:	f062                	sd	s8,32(sp)
    80002ec2:	ec66                	sd	s9,24(sp)
    80002ec4:	e86a                	sd	s10,16(sp)
    80002ec6:	e46e                	sd	s11,8(sp)
    80002ec8:	1880                	addi	s0,sp,112
    80002eca:	8b2a                	mv	s6,a0
    80002ecc:	8bae                	mv	s7,a1
    80002ece:	8a32                	mv	s4,a2
    80002ed0:	84b6                	mv	s1,a3
    80002ed2:	8aba                	mv	s5,a4
    if (off > ip->size || off + n < off)
    80002ed4:	9f35                	addw	a4,a4,a3
        return 0;
    80002ed6:	4501                	li	a0,0
    if (off > ip->size || off + n < off)
    80002ed8:	0ad76063          	bltu	a4,a3,80002f78 <readi+0xd2>
    if (off + n > ip->size)
    80002edc:	00e7f463          	bgeu	a5,a4,80002ee4 <readi+0x3e>
        n = ip->size - off;
    80002ee0:	40d78abb          	subw	s5,a5,a3

    for (tot = 0; tot < n; tot += m, off += m, dst += m)
    80002ee4:	0a0a8963          	beqz	s5,80002f96 <readi+0xf0>
    80002ee8:	4981                	li	s3,0
    {
        uint addr = bmap(ip, off / BSIZE);
        if (addr == 0)
            break;
        bp = bread(ip->dev, addr);
        m = min(n - tot, BSIZE - off % BSIZE);
    80002eea:	40000c93          	li	s9,1024
        if (either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1)
    80002eee:	5c7d                	li	s8,-1
    80002ef0:	a82d                	j	80002f2a <readi+0x84>
    80002ef2:	020d1d93          	slli	s11,s10,0x20
    80002ef6:	020ddd93          	srli	s11,s11,0x20
    80002efa:	05890613          	addi	a2,s2,88
    80002efe:	86ee                	mv	a3,s11
    80002f00:	963a                	add	a2,a2,a4
    80002f02:	85d2                	mv	a1,s4
    80002f04:	855e                	mv	a0,s7
    80002f06:	fffff097          	auipc	ra,0xfffff
    80002f0a:	a24080e7          	jalr	-1500(ra) # 8000192a <either_copyout>
    80002f0e:	05850d63          	beq	a0,s8,80002f68 <readi+0xc2>
        {
            brelse(bp);
            tot = -1;
            break;
        }
        brelse(bp);
    80002f12:	854a                	mv	a0,s2
    80002f14:	fffff097          	auipc	ra,0xfffff
    80002f18:	5f4080e7          	jalr	1524(ra) # 80002508 <brelse>
    for (tot = 0; tot < n; tot += m, off += m, dst += m)
    80002f1c:	013d09bb          	addw	s3,s10,s3
    80002f20:	009d04bb          	addw	s1,s10,s1
    80002f24:	9a6e                	add	s4,s4,s11
    80002f26:	0559f763          	bgeu	s3,s5,80002f74 <readi+0xce>
        uint addr = bmap(ip, off / BSIZE);
    80002f2a:	00a4d59b          	srliw	a1,s1,0xa
    80002f2e:	855a                	mv	a0,s6
    80002f30:	00000097          	auipc	ra,0x0
    80002f34:	8a2080e7          	jalr	-1886(ra) # 800027d2 <bmap>
    80002f38:	0005059b          	sext.w	a1,a0
        if (addr == 0)
    80002f3c:	cd85                	beqz	a1,80002f74 <readi+0xce>
        bp = bread(ip->dev, addr);
    80002f3e:	000b2503          	lw	a0,0(s6)
    80002f42:	fffff097          	auipc	ra,0xfffff
    80002f46:	496080e7          	jalr	1174(ra) # 800023d8 <bread>
    80002f4a:	892a                	mv	s2,a0
        m = min(n - tot, BSIZE - off % BSIZE);
    80002f4c:	3ff4f713          	andi	a4,s1,1023
    80002f50:	40ec87bb          	subw	a5,s9,a4
    80002f54:	413a86bb          	subw	a3,s5,s3
    80002f58:	8d3e                	mv	s10,a5
    80002f5a:	2781                	sext.w	a5,a5
    80002f5c:	0006861b          	sext.w	a2,a3
    80002f60:	f8f679e3          	bgeu	a2,a5,80002ef2 <readi+0x4c>
    80002f64:	8d36                	mv	s10,a3
    80002f66:	b771                	j	80002ef2 <readi+0x4c>
            brelse(bp);
    80002f68:	854a                	mv	a0,s2
    80002f6a:	fffff097          	auipc	ra,0xfffff
    80002f6e:	59e080e7          	jalr	1438(ra) # 80002508 <brelse>
            tot = -1;
    80002f72:	59fd                	li	s3,-1
    }
    return tot;
    80002f74:	0009851b          	sext.w	a0,s3
}
    80002f78:	70a6                	ld	ra,104(sp)
    80002f7a:	7406                	ld	s0,96(sp)
    80002f7c:	64e6                	ld	s1,88(sp)
    80002f7e:	6946                	ld	s2,80(sp)
    80002f80:	69a6                	ld	s3,72(sp)
    80002f82:	6a06                	ld	s4,64(sp)
    80002f84:	7ae2                	ld	s5,56(sp)
    80002f86:	7b42                	ld	s6,48(sp)
    80002f88:	7ba2                	ld	s7,40(sp)
    80002f8a:	7c02                	ld	s8,32(sp)
    80002f8c:	6ce2                	ld	s9,24(sp)
    80002f8e:	6d42                	ld	s10,16(sp)
    80002f90:	6da2                	ld	s11,8(sp)
    80002f92:	6165                	addi	sp,sp,112
    80002f94:	8082                	ret
    for (tot = 0; tot < n; tot += m, off += m, dst += m)
    80002f96:	89d6                	mv	s3,s5
    80002f98:	bff1                	j	80002f74 <readi+0xce>
        return 0;
    80002f9a:	4501                	li	a0,0
}
    80002f9c:	8082                	ret

0000000080002f9e <writei>:
int writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
    uint tot, m;
    struct buf *bp;

    if (off > ip->size || off + n < off)
    80002f9e:	457c                	lw	a5,76(a0)
    80002fa0:	10d7e863          	bltu	a5,a3,800030b0 <writei+0x112>
{
    80002fa4:	7159                	addi	sp,sp,-112
    80002fa6:	f486                	sd	ra,104(sp)
    80002fa8:	f0a2                	sd	s0,96(sp)
    80002faa:	eca6                	sd	s1,88(sp)
    80002fac:	e8ca                	sd	s2,80(sp)
    80002fae:	e4ce                	sd	s3,72(sp)
    80002fb0:	e0d2                	sd	s4,64(sp)
    80002fb2:	fc56                	sd	s5,56(sp)
    80002fb4:	f85a                	sd	s6,48(sp)
    80002fb6:	f45e                	sd	s7,40(sp)
    80002fb8:	f062                	sd	s8,32(sp)
    80002fba:	ec66                	sd	s9,24(sp)
    80002fbc:	e86a                	sd	s10,16(sp)
    80002fbe:	e46e                	sd	s11,8(sp)
    80002fc0:	1880                	addi	s0,sp,112
    80002fc2:	8aaa                	mv	s5,a0
    80002fc4:	8bae                	mv	s7,a1
    80002fc6:	8a32                	mv	s4,a2
    80002fc8:	8936                	mv	s2,a3
    80002fca:	8b3a                	mv	s6,a4
    if (off > ip->size || off + n < off)
    80002fcc:	00e687bb          	addw	a5,a3,a4
    80002fd0:	0ed7e263          	bltu	a5,a3,800030b4 <writei+0x116>
        return -1;
    if (off + n > MAXFILE * BSIZE)
    80002fd4:	00043737          	lui	a4,0x43
    80002fd8:	0ef76063          	bltu	a4,a5,800030b8 <writei+0x11a>
        return -1;

    for (tot = 0; tot < n; tot += m, off += m, src += m)
    80002fdc:	0c0b0863          	beqz	s6,800030ac <writei+0x10e>
    80002fe0:	4981                	li	s3,0
    {
        uint addr = bmap(ip, off / BSIZE);
        if (addr == 0)
            break;
        bp = bread(ip->dev, addr);
        m = min(n - tot, BSIZE - off % BSIZE);
    80002fe2:	40000c93          	li	s9,1024
        if (either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1)
    80002fe6:	5c7d                	li	s8,-1
    80002fe8:	a091                	j	8000302c <writei+0x8e>
    80002fea:	020d1d93          	slli	s11,s10,0x20
    80002fee:	020ddd93          	srli	s11,s11,0x20
    80002ff2:	05848513          	addi	a0,s1,88
    80002ff6:	86ee                	mv	a3,s11
    80002ff8:	8652                	mv	a2,s4
    80002ffa:	85de                	mv	a1,s7
    80002ffc:	953a                	add	a0,a0,a4
    80002ffe:	fffff097          	auipc	ra,0xfffff
    80003002:	982080e7          	jalr	-1662(ra) # 80001980 <either_copyin>
    80003006:	07850263          	beq	a0,s8,8000306a <writei+0xcc>
        {
            brelse(bp);
            break;
        }
        log_write(bp);
    8000300a:	8526                	mv	a0,s1
    8000300c:	00000097          	auipc	ra,0x0
    80003010:	780080e7          	jalr	1920(ra) # 8000378c <log_write>
        brelse(bp);
    80003014:	8526                	mv	a0,s1
    80003016:	fffff097          	auipc	ra,0xfffff
    8000301a:	4f2080e7          	jalr	1266(ra) # 80002508 <brelse>
    for (tot = 0; tot < n; tot += m, off += m, src += m)
    8000301e:	013d09bb          	addw	s3,s10,s3
    80003022:	012d093b          	addw	s2,s10,s2
    80003026:	9a6e                	add	s4,s4,s11
    80003028:	0569f663          	bgeu	s3,s6,80003074 <writei+0xd6>
        uint addr = bmap(ip, off / BSIZE);
    8000302c:	00a9559b          	srliw	a1,s2,0xa
    80003030:	8556                	mv	a0,s5
    80003032:	fffff097          	auipc	ra,0xfffff
    80003036:	7a0080e7          	jalr	1952(ra) # 800027d2 <bmap>
    8000303a:	0005059b          	sext.w	a1,a0
        if (addr == 0)
    8000303e:	c99d                	beqz	a1,80003074 <writei+0xd6>
        bp = bread(ip->dev, addr);
    80003040:	000aa503          	lw	a0,0(s5)
    80003044:	fffff097          	auipc	ra,0xfffff
    80003048:	394080e7          	jalr	916(ra) # 800023d8 <bread>
    8000304c:	84aa                	mv	s1,a0
        m = min(n - tot, BSIZE - off % BSIZE);
    8000304e:	3ff97713          	andi	a4,s2,1023
    80003052:	40ec87bb          	subw	a5,s9,a4
    80003056:	413b06bb          	subw	a3,s6,s3
    8000305a:	8d3e                	mv	s10,a5
    8000305c:	2781                	sext.w	a5,a5
    8000305e:	0006861b          	sext.w	a2,a3
    80003062:	f8f674e3          	bgeu	a2,a5,80002fea <writei+0x4c>
    80003066:	8d36                	mv	s10,a3
    80003068:	b749                	j	80002fea <writei+0x4c>
            brelse(bp);
    8000306a:	8526                	mv	a0,s1
    8000306c:	fffff097          	auipc	ra,0xfffff
    80003070:	49c080e7          	jalr	1180(ra) # 80002508 <brelse>
    }

    if (off > ip->size)
    80003074:	04caa783          	lw	a5,76(s5)
    80003078:	0127f463          	bgeu	a5,s2,80003080 <writei+0xe2>
        ip->size = off;
    8000307c:	052aa623          	sw	s2,76(s5)

    // write the i-node back to disk even if the size didn't change
    // because the loop above might have called bmap() and added a new
    // block to ip->addrs[].
    iupdate(ip);
    80003080:	8556                	mv	a0,s5
    80003082:	00000097          	auipc	ra,0x0
    80003086:	aa6080e7          	jalr	-1370(ra) # 80002b28 <iupdate>

    return tot;
    8000308a:	0009851b          	sext.w	a0,s3
}
    8000308e:	70a6                	ld	ra,104(sp)
    80003090:	7406                	ld	s0,96(sp)
    80003092:	64e6                	ld	s1,88(sp)
    80003094:	6946                	ld	s2,80(sp)
    80003096:	69a6                	ld	s3,72(sp)
    80003098:	6a06                	ld	s4,64(sp)
    8000309a:	7ae2                	ld	s5,56(sp)
    8000309c:	7b42                	ld	s6,48(sp)
    8000309e:	7ba2                	ld	s7,40(sp)
    800030a0:	7c02                	ld	s8,32(sp)
    800030a2:	6ce2                	ld	s9,24(sp)
    800030a4:	6d42                	ld	s10,16(sp)
    800030a6:	6da2                	ld	s11,8(sp)
    800030a8:	6165                	addi	sp,sp,112
    800030aa:	8082                	ret
    for (tot = 0; tot < n; tot += m, off += m, src += m)
    800030ac:	89da                	mv	s3,s6
    800030ae:	bfc9                	j	80003080 <writei+0xe2>
        return -1;
    800030b0:	557d                	li	a0,-1
}
    800030b2:	8082                	ret
        return -1;
    800030b4:	557d                	li	a0,-1
    800030b6:	bfe1                	j	8000308e <writei+0xf0>
        return -1;
    800030b8:	557d                	li	a0,-1
    800030ba:	bfd1                	j	8000308e <writei+0xf0>

00000000800030bc <namecmp>:

// Directories

int namecmp(const char *s, const char *t)
{
    800030bc:	1141                	addi	sp,sp,-16
    800030be:	e406                	sd	ra,8(sp)
    800030c0:	e022                	sd	s0,0(sp)
    800030c2:	0800                	addi	s0,sp,16
    return strncmp(s, t, DIRSIZ);
    800030c4:	4639                	li	a2,14
    800030c6:	ffffd097          	auipc	ra,0xffffd
    800030ca:	18a080e7          	jalr	394(ra) # 80000250 <strncmp>
}
    800030ce:	60a2                	ld	ra,8(sp)
    800030d0:	6402                	ld	s0,0(sp)
    800030d2:	0141                	addi	sp,sp,16
    800030d4:	8082                	ret

00000000800030d6 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode *
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800030d6:	7139                	addi	sp,sp,-64
    800030d8:	fc06                	sd	ra,56(sp)
    800030da:	f822                	sd	s0,48(sp)
    800030dc:	f426                	sd	s1,40(sp)
    800030de:	f04a                	sd	s2,32(sp)
    800030e0:	ec4e                	sd	s3,24(sp)
    800030e2:	e852                	sd	s4,16(sp)
    800030e4:	0080                	addi	s0,sp,64
    uint off, inum;
    struct dirent de;

    if (dp->type != T_DIR)
    800030e6:	04451703          	lh	a4,68(a0)
    800030ea:	4785                	li	a5,1
    800030ec:	00f71a63          	bne	a4,a5,80003100 <dirlookup+0x2a>
    800030f0:	892a                	mv	s2,a0
    800030f2:	89ae                	mv	s3,a1
    800030f4:	8a32                	mv	s4,a2
        panic("dirlookup not DIR");

    for (off = 0; off < dp->size; off += sizeof(de))
    800030f6:	457c                	lw	a5,76(a0)
    800030f8:	4481                	li	s1,0
            inum = de.inum;
            return iget(dp->dev, inum);
        }
    }

    return 0;
    800030fa:	4501                	li	a0,0
    for (off = 0; off < dp->size; off += sizeof(de))
    800030fc:	e79d                	bnez	a5,8000312a <dirlookup+0x54>
    800030fe:	a8a5                	j	80003176 <dirlookup+0xa0>
        panic("dirlookup not DIR");
    80003100:	00005517          	auipc	a0,0x5
    80003104:	47050513          	addi	a0,a0,1136 # 80008570 <syscalls+0x1b0>
    80003108:	00003097          	auipc	ra,0x3
    8000310c:	e7a080e7          	jalr	-390(ra) # 80005f82 <panic>
            panic("dirlookup read");
    80003110:	00005517          	auipc	a0,0x5
    80003114:	47850513          	addi	a0,a0,1144 # 80008588 <syscalls+0x1c8>
    80003118:	00003097          	auipc	ra,0x3
    8000311c:	e6a080e7          	jalr	-406(ra) # 80005f82 <panic>
    for (off = 0; off < dp->size; off += sizeof(de))
    80003120:	24c1                	addiw	s1,s1,16
    80003122:	04c92783          	lw	a5,76(s2)
    80003126:	04f4f763          	bgeu	s1,a5,80003174 <dirlookup+0x9e>
        if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000312a:	4741                	li	a4,16
    8000312c:	86a6                	mv	a3,s1
    8000312e:	fc040613          	addi	a2,s0,-64
    80003132:	4581                	li	a1,0
    80003134:	854a                	mv	a0,s2
    80003136:	00000097          	auipc	ra,0x0
    8000313a:	d70080e7          	jalr	-656(ra) # 80002ea6 <readi>
    8000313e:	47c1                	li	a5,16
    80003140:	fcf518e3          	bne	a0,a5,80003110 <dirlookup+0x3a>
        if (de.inum == 0)
    80003144:	fc045783          	lhu	a5,-64(s0)
    80003148:	dfe1                	beqz	a5,80003120 <dirlookup+0x4a>
        if (namecmp(name, de.name) == 0)
    8000314a:	fc240593          	addi	a1,s0,-62
    8000314e:	854e                	mv	a0,s3
    80003150:	00000097          	auipc	ra,0x0
    80003154:	f6c080e7          	jalr	-148(ra) # 800030bc <namecmp>
    80003158:	f561                	bnez	a0,80003120 <dirlookup+0x4a>
            if (poff)
    8000315a:	000a0463          	beqz	s4,80003162 <dirlookup+0x8c>
                *poff = off;
    8000315e:	009a2023          	sw	s1,0(s4)
            return iget(dp->dev, inum);
    80003162:	fc045583          	lhu	a1,-64(s0)
    80003166:	00092503          	lw	a0,0(s2)
    8000316a:	fffff097          	auipc	ra,0xfffff
    8000316e:	750080e7          	jalr	1872(ra) # 800028ba <iget>
    80003172:	a011                	j	80003176 <dirlookup+0xa0>
    return 0;
    80003174:	4501                	li	a0,0
}
    80003176:	70e2                	ld	ra,56(sp)
    80003178:	7442                	ld	s0,48(sp)
    8000317a:	74a2                	ld	s1,40(sp)
    8000317c:	7902                	ld	s2,32(sp)
    8000317e:	69e2                	ld	s3,24(sp)
    80003180:	6a42                	ld	s4,16(sp)
    80003182:	6121                	addi	sp,sp,64
    80003184:	8082                	ret

0000000080003186 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode *
namex(char *path, int nameiparent, char *name)
{
    80003186:	711d                	addi	sp,sp,-96
    80003188:	ec86                	sd	ra,88(sp)
    8000318a:	e8a2                	sd	s0,80(sp)
    8000318c:	e4a6                	sd	s1,72(sp)
    8000318e:	e0ca                	sd	s2,64(sp)
    80003190:	fc4e                	sd	s3,56(sp)
    80003192:	f852                	sd	s4,48(sp)
    80003194:	f456                	sd	s5,40(sp)
    80003196:	f05a                	sd	s6,32(sp)
    80003198:	ec5e                	sd	s7,24(sp)
    8000319a:	e862                	sd	s8,16(sp)
    8000319c:	e466                	sd	s9,8(sp)
    8000319e:	1080                	addi	s0,sp,96
    800031a0:	84aa                	mv	s1,a0
    800031a2:	8b2e                	mv	s6,a1
    800031a4:	8ab2                	mv	s5,a2
    struct inode *ip, *next;

    if (*path == '/')
    800031a6:	00054703          	lbu	a4,0(a0)
    800031aa:	02f00793          	li	a5,47
    800031ae:	02f70363          	beq	a4,a5,800031d4 <namex+0x4e>
        ip = iget(ROOTDEV, ROOTINO);
    else
        ip = idup(myproc()->cwd);
    800031b2:	ffffe097          	auipc	ra,0xffffe
    800031b6:	c8c080e7          	jalr	-884(ra) # 80000e3e <myproc>
    800031ba:	15053503          	ld	a0,336(a0)
    800031be:	00000097          	auipc	ra,0x0
    800031c2:	9f6080e7          	jalr	-1546(ra) # 80002bb4 <idup>
    800031c6:	89aa                	mv	s3,a0
    while (*path == '/')
    800031c8:	02f00913          	li	s2,47
    len = path - s;
    800031cc:	4b81                	li	s7,0
    if (len >= DIRSIZ)
    800031ce:	4cb5                	li	s9,13

    while ((path = skipelem(path, name)) != 0)
    {
        ilock(ip);
        if (ip->type != T_DIR)
    800031d0:	4c05                	li	s8,1
    800031d2:	a865                	j	8000328a <namex+0x104>
        ip = iget(ROOTDEV, ROOTINO);
    800031d4:	4585                	li	a1,1
    800031d6:	4505                	li	a0,1
    800031d8:	fffff097          	auipc	ra,0xfffff
    800031dc:	6e2080e7          	jalr	1762(ra) # 800028ba <iget>
    800031e0:	89aa                	mv	s3,a0
    800031e2:	b7dd                	j	800031c8 <namex+0x42>
        {
            iunlockput(ip);
    800031e4:	854e                	mv	a0,s3
    800031e6:	00000097          	auipc	ra,0x0
    800031ea:	c6e080e7          	jalr	-914(ra) # 80002e54 <iunlockput>
            return 0;
    800031ee:	4981                	li	s3,0
    {
        iput(ip);
        return 0;
    }
    return ip;
}
    800031f0:	854e                	mv	a0,s3
    800031f2:	60e6                	ld	ra,88(sp)
    800031f4:	6446                	ld	s0,80(sp)
    800031f6:	64a6                	ld	s1,72(sp)
    800031f8:	6906                	ld	s2,64(sp)
    800031fa:	79e2                	ld	s3,56(sp)
    800031fc:	7a42                	ld	s4,48(sp)
    800031fe:	7aa2                	ld	s5,40(sp)
    80003200:	7b02                	ld	s6,32(sp)
    80003202:	6be2                	ld	s7,24(sp)
    80003204:	6c42                	ld	s8,16(sp)
    80003206:	6ca2                	ld	s9,8(sp)
    80003208:	6125                	addi	sp,sp,96
    8000320a:	8082                	ret
            iunlock(ip);
    8000320c:	854e                	mv	a0,s3
    8000320e:	00000097          	auipc	ra,0x0
    80003212:	aa6080e7          	jalr	-1370(ra) # 80002cb4 <iunlock>
            return ip;
    80003216:	bfe9                	j	800031f0 <namex+0x6a>
            iunlockput(ip);
    80003218:	854e                	mv	a0,s3
    8000321a:	00000097          	auipc	ra,0x0
    8000321e:	c3a080e7          	jalr	-966(ra) # 80002e54 <iunlockput>
            return 0;
    80003222:	89d2                	mv	s3,s4
    80003224:	b7f1                	j	800031f0 <namex+0x6a>
    len = path - s;
    80003226:	40b48633          	sub	a2,s1,a1
    8000322a:	00060a1b          	sext.w	s4,a2
    if (len >= DIRSIZ)
    8000322e:	094cd463          	bge	s9,s4,800032b6 <namex+0x130>
        memmove(name, s, DIRSIZ);
    80003232:	4639                	li	a2,14
    80003234:	8556                	mv	a0,s5
    80003236:	ffffd097          	auipc	ra,0xffffd
    8000323a:	fa2080e7          	jalr	-94(ra) # 800001d8 <memmove>
    while (*path == '/')
    8000323e:	0004c783          	lbu	a5,0(s1)
    80003242:	01279763          	bne	a5,s2,80003250 <namex+0xca>
        path++;
    80003246:	0485                	addi	s1,s1,1
    while (*path == '/')
    80003248:	0004c783          	lbu	a5,0(s1)
    8000324c:	ff278de3          	beq	a5,s2,80003246 <namex+0xc0>
        ilock(ip);
    80003250:	854e                	mv	a0,s3
    80003252:	00000097          	auipc	ra,0x0
    80003256:	9a0080e7          	jalr	-1632(ra) # 80002bf2 <ilock>
        if (ip->type != T_DIR)
    8000325a:	04499783          	lh	a5,68(s3)
    8000325e:	f98793e3          	bne	a5,s8,800031e4 <namex+0x5e>
        if (nameiparent && *path == '\0')
    80003262:	000b0563          	beqz	s6,8000326c <namex+0xe6>
    80003266:	0004c783          	lbu	a5,0(s1)
    8000326a:	d3cd                	beqz	a5,8000320c <namex+0x86>
        if ((next = dirlookup(ip, name, 0)) == 0)
    8000326c:	865e                	mv	a2,s7
    8000326e:	85d6                	mv	a1,s5
    80003270:	854e                	mv	a0,s3
    80003272:	00000097          	auipc	ra,0x0
    80003276:	e64080e7          	jalr	-412(ra) # 800030d6 <dirlookup>
    8000327a:	8a2a                	mv	s4,a0
    8000327c:	dd51                	beqz	a0,80003218 <namex+0x92>
        iunlockput(ip);
    8000327e:	854e                	mv	a0,s3
    80003280:	00000097          	auipc	ra,0x0
    80003284:	bd4080e7          	jalr	-1068(ra) # 80002e54 <iunlockput>
        ip = next;
    80003288:	89d2                	mv	s3,s4
    while (*path == '/')
    8000328a:	0004c783          	lbu	a5,0(s1)
    8000328e:	05279763          	bne	a5,s2,800032dc <namex+0x156>
        path++;
    80003292:	0485                	addi	s1,s1,1
    while (*path == '/')
    80003294:	0004c783          	lbu	a5,0(s1)
    80003298:	ff278de3          	beq	a5,s2,80003292 <namex+0x10c>
    if (*path == 0)
    8000329c:	c79d                	beqz	a5,800032ca <namex+0x144>
        path++;
    8000329e:	85a6                	mv	a1,s1
    len = path - s;
    800032a0:	8a5e                	mv	s4,s7
    800032a2:	865e                	mv	a2,s7
    while (*path != '/' && *path != 0)
    800032a4:	01278963          	beq	a5,s2,800032b6 <namex+0x130>
    800032a8:	dfbd                	beqz	a5,80003226 <namex+0xa0>
        path++;
    800032aa:	0485                	addi	s1,s1,1
    while (*path != '/' && *path != 0)
    800032ac:	0004c783          	lbu	a5,0(s1)
    800032b0:	ff279ce3          	bne	a5,s2,800032a8 <namex+0x122>
    800032b4:	bf8d                	j	80003226 <namex+0xa0>
        memmove(name, s, len);
    800032b6:	2601                	sext.w	a2,a2
    800032b8:	8556                	mv	a0,s5
    800032ba:	ffffd097          	auipc	ra,0xffffd
    800032be:	f1e080e7          	jalr	-226(ra) # 800001d8 <memmove>
        name[len] = 0;
    800032c2:	9a56                	add	s4,s4,s5
    800032c4:	000a0023          	sb	zero,0(s4)
    800032c8:	bf9d                	j	8000323e <namex+0xb8>
    if (nameiparent)
    800032ca:	f20b03e3          	beqz	s6,800031f0 <namex+0x6a>
        iput(ip);
    800032ce:	854e                	mv	a0,s3
    800032d0:	00000097          	auipc	ra,0x0
    800032d4:	adc080e7          	jalr	-1316(ra) # 80002dac <iput>
        return 0;
    800032d8:	4981                	li	s3,0
    800032da:	bf19                	j	800031f0 <namex+0x6a>
    if (*path == 0)
    800032dc:	d7fd                	beqz	a5,800032ca <namex+0x144>
    while (*path != '/' && *path != 0)
    800032de:	0004c783          	lbu	a5,0(s1)
    800032e2:	85a6                	mv	a1,s1
    800032e4:	b7d1                	j	800032a8 <namex+0x122>

00000000800032e6 <dirlink>:
{
    800032e6:	7139                	addi	sp,sp,-64
    800032e8:	fc06                	sd	ra,56(sp)
    800032ea:	f822                	sd	s0,48(sp)
    800032ec:	f426                	sd	s1,40(sp)
    800032ee:	f04a                	sd	s2,32(sp)
    800032f0:	ec4e                	sd	s3,24(sp)
    800032f2:	e852                	sd	s4,16(sp)
    800032f4:	0080                	addi	s0,sp,64
    800032f6:	892a                	mv	s2,a0
    800032f8:	8a2e                	mv	s4,a1
    800032fa:	89b2                	mv	s3,a2
    if ((ip = dirlookup(dp, name, 0)) != 0)
    800032fc:	4601                	li	a2,0
    800032fe:	00000097          	auipc	ra,0x0
    80003302:	dd8080e7          	jalr	-552(ra) # 800030d6 <dirlookup>
    80003306:	e93d                	bnez	a0,8000337c <dirlink+0x96>
    for (off = 0; off < dp->size; off += sizeof(de))
    80003308:	04c92483          	lw	s1,76(s2)
    8000330c:	c49d                	beqz	s1,8000333a <dirlink+0x54>
    8000330e:	4481                	li	s1,0
        if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003310:	4741                	li	a4,16
    80003312:	86a6                	mv	a3,s1
    80003314:	fc040613          	addi	a2,s0,-64
    80003318:	4581                	li	a1,0
    8000331a:	854a                	mv	a0,s2
    8000331c:	00000097          	auipc	ra,0x0
    80003320:	b8a080e7          	jalr	-1142(ra) # 80002ea6 <readi>
    80003324:	47c1                	li	a5,16
    80003326:	06f51163          	bne	a0,a5,80003388 <dirlink+0xa2>
        if (de.inum == 0)
    8000332a:	fc045783          	lhu	a5,-64(s0)
    8000332e:	c791                	beqz	a5,8000333a <dirlink+0x54>
    for (off = 0; off < dp->size; off += sizeof(de))
    80003330:	24c1                	addiw	s1,s1,16
    80003332:	04c92783          	lw	a5,76(s2)
    80003336:	fcf4ede3          	bltu	s1,a5,80003310 <dirlink+0x2a>
    strncpy(de.name, name, DIRSIZ);
    8000333a:	4639                	li	a2,14
    8000333c:	85d2                	mv	a1,s4
    8000333e:	fc240513          	addi	a0,s0,-62
    80003342:	ffffd097          	auipc	ra,0xffffd
    80003346:	f4a080e7          	jalr	-182(ra) # 8000028c <strncpy>
    de.inum = inum;
    8000334a:	fd341023          	sh	s3,-64(s0)
    if (writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    8000334e:	4741                	li	a4,16
    80003350:	86a6                	mv	a3,s1
    80003352:	fc040613          	addi	a2,s0,-64
    80003356:	4581                	li	a1,0
    80003358:	854a                	mv	a0,s2
    8000335a:	00000097          	auipc	ra,0x0
    8000335e:	c44080e7          	jalr	-956(ra) # 80002f9e <writei>
    80003362:	1541                	addi	a0,a0,-16
    80003364:	00a03533          	snez	a0,a0
    80003368:	40a00533          	neg	a0,a0
}
    8000336c:	70e2                	ld	ra,56(sp)
    8000336e:	7442                	ld	s0,48(sp)
    80003370:	74a2                	ld	s1,40(sp)
    80003372:	7902                	ld	s2,32(sp)
    80003374:	69e2                	ld	s3,24(sp)
    80003376:	6a42                	ld	s4,16(sp)
    80003378:	6121                	addi	sp,sp,64
    8000337a:	8082                	ret
        iput(ip);
    8000337c:	00000097          	auipc	ra,0x0
    80003380:	a30080e7          	jalr	-1488(ra) # 80002dac <iput>
        return -1;
    80003384:	557d                	li	a0,-1
    80003386:	b7dd                	j	8000336c <dirlink+0x86>
            panic("dirlink read");
    80003388:	00005517          	auipc	a0,0x5
    8000338c:	21050513          	addi	a0,a0,528 # 80008598 <syscalls+0x1d8>
    80003390:	00003097          	auipc	ra,0x3
    80003394:	bf2080e7          	jalr	-1038(ra) # 80005f82 <panic>

0000000080003398 <namei>:

struct inode *
namei(char *path)
{
    80003398:	1101                	addi	sp,sp,-32
    8000339a:	ec06                	sd	ra,24(sp)
    8000339c:	e822                	sd	s0,16(sp)
    8000339e:	1000                	addi	s0,sp,32
    char name[DIRSIZ];
    return namex(path, 0, name);
    800033a0:	fe040613          	addi	a2,s0,-32
    800033a4:	4581                	li	a1,0
    800033a6:	00000097          	auipc	ra,0x0
    800033aa:	de0080e7          	jalr	-544(ra) # 80003186 <namex>
}
    800033ae:	60e2                	ld	ra,24(sp)
    800033b0:	6442                	ld	s0,16(sp)
    800033b2:	6105                	addi	sp,sp,32
    800033b4:	8082                	ret

00000000800033b6 <nameiparent>:

struct inode *
nameiparent(char *path, char *name)
{
    800033b6:	1141                	addi	sp,sp,-16
    800033b8:	e406                	sd	ra,8(sp)
    800033ba:	e022                	sd	s0,0(sp)
    800033bc:	0800                	addi	s0,sp,16
    800033be:	862e                	mv	a2,a1
    return namex(path, 1, name);
    800033c0:	4585                	li	a1,1
    800033c2:	00000097          	auipc	ra,0x0
    800033c6:	dc4080e7          	jalr	-572(ra) # 80003186 <namex>
}
    800033ca:	60a2                	ld	ra,8(sp)
    800033cc:	6402                	ld	s0,0(sp)
    800033ce:	0141                	addi	sp,sp,16
    800033d0:	8082                	ret

00000000800033d2 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800033d2:	1101                	addi	sp,sp,-32
    800033d4:	ec06                	sd	ra,24(sp)
    800033d6:	e822                	sd	s0,16(sp)
    800033d8:	e426                	sd	s1,8(sp)
    800033da:	e04a                	sd	s2,0(sp)
    800033dc:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    800033de:	00027917          	auipc	s2,0x27
    800033e2:	51290913          	addi	s2,s2,1298 # 8002a8f0 <log>
    800033e6:	01892583          	lw	a1,24(s2)
    800033ea:	02892503          	lw	a0,40(s2)
    800033ee:	fffff097          	auipc	ra,0xfffff
    800033f2:	fea080e7          	jalr	-22(ra) # 800023d8 <bread>
    800033f6:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    800033f8:	02c92683          	lw	a3,44(s2)
    800033fc:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    800033fe:	02d05763          	blez	a3,8000342c <write_head+0x5a>
    80003402:	00027797          	auipc	a5,0x27
    80003406:	51e78793          	addi	a5,a5,1310 # 8002a920 <log+0x30>
    8000340a:	05c50713          	addi	a4,a0,92
    8000340e:	36fd                	addiw	a3,a3,-1
    80003410:	1682                	slli	a3,a3,0x20
    80003412:	9281                	srli	a3,a3,0x20
    80003414:	068a                	slli	a3,a3,0x2
    80003416:	00027617          	auipc	a2,0x27
    8000341a:	50e60613          	addi	a2,a2,1294 # 8002a924 <log+0x34>
    8000341e:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80003420:	4390                	lw	a2,0(a5)
    80003422:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    80003424:	0791                	addi	a5,a5,4
    80003426:	0711                	addi	a4,a4,4
    80003428:	fed79ce3          	bne	a5,a3,80003420 <write_head+0x4e>
  }
  bwrite(buf);
    8000342c:	8526                	mv	a0,s1
    8000342e:	fffff097          	auipc	ra,0xfffff
    80003432:	09c080e7          	jalr	156(ra) # 800024ca <bwrite>
  brelse(buf);
    80003436:	8526                	mv	a0,s1
    80003438:	fffff097          	auipc	ra,0xfffff
    8000343c:	0d0080e7          	jalr	208(ra) # 80002508 <brelse>
}
    80003440:	60e2                	ld	ra,24(sp)
    80003442:	6442                	ld	s0,16(sp)
    80003444:	64a2                	ld	s1,8(sp)
    80003446:	6902                	ld	s2,0(sp)
    80003448:	6105                	addi	sp,sp,32
    8000344a:	8082                	ret

000000008000344c <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    8000344c:	00027797          	auipc	a5,0x27
    80003450:	4d07a783          	lw	a5,1232(a5) # 8002a91c <log+0x2c>
    80003454:	0af05d63          	blez	a5,8000350e <install_trans+0xc2>
{
    80003458:	7139                	addi	sp,sp,-64
    8000345a:	fc06                	sd	ra,56(sp)
    8000345c:	f822                	sd	s0,48(sp)
    8000345e:	f426                	sd	s1,40(sp)
    80003460:	f04a                	sd	s2,32(sp)
    80003462:	ec4e                	sd	s3,24(sp)
    80003464:	e852                	sd	s4,16(sp)
    80003466:	e456                	sd	s5,8(sp)
    80003468:	e05a                	sd	s6,0(sp)
    8000346a:	0080                	addi	s0,sp,64
    8000346c:	8b2a                	mv	s6,a0
    8000346e:	00027a97          	auipc	s5,0x27
    80003472:	4b2a8a93          	addi	s5,s5,1202 # 8002a920 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003476:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    80003478:	00027997          	auipc	s3,0x27
    8000347c:	47898993          	addi	s3,s3,1144 # 8002a8f0 <log>
    80003480:	a035                	j	800034ac <install_trans+0x60>
      bunpin(dbuf);
    80003482:	8526                	mv	a0,s1
    80003484:	fffff097          	auipc	ra,0xfffff
    80003488:	15e080e7          	jalr	350(ra) # 800025e2 <bunpin>
    brelse(lbuf);
    8000348c:	854a                	mv	a0,s2
    8000348e:	fffff097          	auipc	ra,0xfffff
    80003492:	07a080e7          	jalr	122(ra) # 80002508 <brelse>
    brelse(dbuf);
    80003496:	8526                	mv	a0,s1
    80003498:	fffff097          	auipc	ra,0xfffff
    8000349c:	070080e7          	jalr	112(ra) # 80002508 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800034a0:	2a05                	addiw	s4,s4,1
    800034a2:	0a91                	addi	s5,s5,4
    800034a4:	02c9a783          	lw	a5,44(s3)
    800034a8:	04fa5963          	bge	s4,a5,800034fa <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800034ac:	0189a583          	lw	a1,24(s3)
    800034b0:	014585bb          	addw	a1,a1,s4
    800034b4:	2585                	addiw	a1,a1,1
    800034b6:	0289a503          	lw	a0,40(s3)
    800034ba:	fffff097          	auipc	ra,0xfffff
    800034be:	f1e080e7          	jalr	-226(ra) # 800023d8 <bread>
    800034c2:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800034c4:	000aa583          	lw	a1,0(s5)
    800034c8:	0289a503          	lw	a0,40(s3)
    800034cc:	fffff097          	auipc	ra,0xfffff
    800034d0:	f0c080e7          	jalr	-244(ra) # 800023d8 <bread>
    800034d4:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800034d6:	40000613          	li	a2,1024
    800034da:	05890593          	addi	a1,s2,88
    800034de:	05850513          	addi	a0,a0,88
    800034e2:	ffffd097          	auipc	ra,0xffffd
    800034e6:	cf6080e7          	jalr	-778(ra) # 800001d8 <memmove>
    bwrite(dbuf);  // write dst to disk
    800034ea:	8526                	mv	a0,s1
    800034ec:	fffff097          	auipc	ra,0xfffff
    800034f0:	fde080e7          	jalr	-34(ra) # 800024ca <bwrite>
    if(recovering == 0)
    800034f4:	f80b1ce3          	bnez	s6,8000348c <install_trans+0x40>
    800034f8:	b769                	j	80003482 <install_trans+0x36>
}
    800034fa:	70e2                	ld	ra,56(sp)
    800034fc:	7442                	ld	s0,48(sp)
    800034fe:	74a2                	ld	s1,40(sp)
    80003500:	7902                	ld	s2,32(sp)
    80003502:	69e2                	ld	s3,24(sp)
    80003504:	6a42                	ld	s4,16(sp)
    80003506:	6aa2                	ld	s5,8(sp)
    80003508:	6b02                	ld	s6,0(sp)
    8000350a:	6121                	addi	sp,sp,64
    8000350c:	8082                	ret
    8000350e:	8082                	ret

0000000080003510 <initlog>:
{
    80003510:	7179                	addi	sp,sp,-48
    80003512:	f406                	sd	ra,40(sp)
    80003514:	f022                	sd	s0,32(sp)
    80003516:	ec26                	sd	s1,24(sp)
    80003518:	e84a                	sd	s2,16(sp)
    8000351a:	e44e                	sd	s3,8(sp)
    8000351c:	1800                	addi	s0,sp,48
    8000351e:	892a                	mv	s2,a0
    80003520:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    80003522:	00027497          	auipc	s1,0x27
    80003526:	3ce48493          	addi	s1,s1,974 # 8002a8f0 <log>
    8000352a:	00005597          	auipc	a1,0x5
    8000352e:	07e58593          	addi	a1,a1,126 # 800085a8 <syscalls+0x1e8>
    80003532:	8526                	mv	a0,s1
    80003534:	00003097          	auipc	ra,0x3
    80003538:	f08080e7          	jalr	-248(ra) # 8000643c <initlock>
  log.start = sb->logstart;
    8000353c:	0149a583          	lw	a1,20(s3)
    80003540:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    80003542:	0109a783          	lw	a5,16(s3)
    80003546:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003548:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    8000354c:	854a                	mv	a0,s2
    8000354e:	fffff097          	auipc	ra,0xfffff
    80003552:	e8a080e7          	jalr	-374(ra) # 800023d8 <bread>
  log.lh.n = lh->n;
    80003556:	4d3c                	lw	a5,88(a0)
    80003558:	d4dc                	sw	a5,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    8000355a:	02f05563          	blez	a5,80003584 <initlog+0x74>
    8000355e:	05c50713          	addi	a4,a0,92
    80003562:	00027697          	auipc	a3,0x27
    80003566:	3be68693          	addi	a3,a3,958 # 8002a920 <log+0x30>
    8000356a:	37fd                	addiw	a5,a5,-1
    8000356c:	1782                	slli	a5,a5,0x20
    8000356e:	9381                	srli	a5,a5,0x20
    80003570:	078a                	slli	a5,a5,0x2
    80003572:	06050613          	addi	a2,a0,96
    80003576:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    80003578:	4310                	lw	a2,0(a4)
    8000357a:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    8000357c:	0711                	addi	a4,a4,4
    8000357e:	0691                	addi	a3,a3,4
    80003580:	fef71ce3          	bne	a4,a5,80003578 <initlog+0x68>
  brelse(buf);
    80003584:	fffff097          	auipc	ra,0xfffff
    80003588:	f84080e7          	jalr	-124(ra) # 80002508 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    8000358c:	4505                	li	a0,1
    8000358e:	00000097          	auipc	ra,0x0
    80003592:	ebe080e7          	jalr	-322(ra) # 8000344c <install_trans>
  log.lh.n = 0;
    80003596:	00027797          	auipc	a5,0x27
    8000359a:	3807a323          	sw	zero,902(a5) # 8002a91c <log+0x2c>
  write_head(); // clear the log
    8000359e:	00000097          	auipc	ra,0x0
    800035a2:	e34080e7          	jalr	-460(ra) # 800033d2 <write_head>
}
    800035a6:	70a2                	ld	ra,40(sp)
    800035a8:	7402                	ld	s0,32(sp)
    800035aa:	64e2                	ld	s1,24(sp)
    800035ac:	6942                	ld	s2,16(sp)
    800035ae:	69a2                	ld	s3,8(sp)
    800035b0:	6145                	addi	sp,sp,48
    800035b2:	8082                	ret

00000000800035b4 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800035b4:	1101                	addi	sp,sp,-32
    800035b6:	ec06                	sd	ra,24(sp)
    800035b8:	e822                	sd	s0,16(sp)
    800035ba:	e426                	sd	s1,8(sp)
    800035bc:	e04a                	sd	s2,0(sp)
    800035be:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800035c0:	00027517          	auipc	a0,0x27
    800035c4:	33050513          	addi	a0,a0,816 # 8002a8f0 <log>
    800035c8:	00003097          	auipc	ra,0x3
    800035cc:	f04080e7          	jalr	-252(ra) # 800064cc <acquire>
  while(1){
    if(log.committing){
    800035d0:	00027497          	auipc	s1,0x27
    800035d4:	32048493          	addi	s1,s1,800 # 8002a8f0 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800035d8:	4979                	li	s2,30
    800035da:	a039                	j	800035e8 <begin_op+0x34>
      sleep(&log, &log.lock);
    800035dc:	85a6                	mv	a1,s1
    800035de:	8526                	mv	a0,s1
    800035e0:	ffffe097          	auipc	ra,0xffffe
    800035e4:	f42080e7          	jalr	-190(ra) # 80001522 <sleep>
    if(log.committing){
    800035e8:	50dc                	lw	a5,36(s1)
    800035ea:	fbed                	bnez	a5,800035dc <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    800035ec:	509c                	lw	a5,32(s1)
    800035ee:	0017871b          	addiw	a4,a5,1
    800035f2:	0007069b          	sext.w	a3,a4
    800035f6:	0027179b          	slliw	a5,a4,0x2
    800035fa:	9fb9                	addw	a5,a5,a4
    800035fc:	0017979b          	slliw	a5,a5,0x1
    80003600:	54d8                	lw	a4,44(s1)
    80003602:	9fb9                	addw	a5,a5,a4
    80003604:	00f95963          	bge	s2,a5,80003616 <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003608:	85a6                	mv	a1,s1
    8000360a:	8526                	mv	a0,s1
    8000360c:	ffffe097          	auipc	ra,0xffffe
    80003610:	f16080e7          	jalr	-234(ra) # 80001522 <sleep>
    80003614:	bfd1                	j	800035e8 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80003616:	00027517          	auipc	a0,0x27
    8000361a:	2da50513          	addi	a0,a0,730 # 8002a8f0 <log>
    8000361e:	d114                	sw	a3,32(a0)
      release(&log.lock);
    80003620:	00003097          	auipc	ra,0x3
    80003624:	f60080e7          	jalr	-160(ra) # 80006580 <release>
      break;
    }
  }
}
    80003628:	60e2                	ld	ra,24(sp)
    8000362a:	6442                	ld	s0,16(sp)
    8000362c:	64a2                	ld	s1,8(sp)
    8000362e:	6902                	ld	s2,0(sp)
    80003630:	6105                	addi	sp,sp,32
    80003632:	8082                	ret

0000000080003634 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    80003634:	7139                	addi	sp,sp,-64
    80003636:	fc06                	sd	ra,56(sp)
    80003638:	f822                	sd	s0,48(sp)
    8000363a:	f426                	sd	s1,40(sp)
    8000363c:	f04a                	sd	s2,32(sp)
    8000363e:	ec4e                	sd	s3,24(sp)
    80003640:	e852                	sd	s4,16(sp)
    80003642:	e456                	sd	s5,8(sp)
    80003644:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    80003646:	00027497          	auipc	s1,0x27
    8000364a:	2aa48493          	addi	s1,s1,682 # 8002a8f0 <log>
    8000364e:	8526                	mv	a0,s1
    80003650:	00003097          	auipc	ra,0x3
    80003654:	e7c080e7          	jalr	-388(ra) # 800064cc <acquire>
  log.outstanding -= 1;
    80003658:	509c                	lw	a5,32(s1)
    8000365a:	37fd                	addiw	a5,a5,-1
    8000365c:	0007891b          	sext.w	s2,a5
    80003660:	d09c                	sw	a5,32(s1)
  if(log.committing)
    80003662:	50dc                	lw	a5,36(s1)
    80003664:	efb9                	bnez	a5,800036c2 <end_op+0x8e>
    panic("log.committing");
  if(log.outstanding == 0){
    80003666:	06091663          	bnez	s2,800036d2 <end_op+0x9e>
    do_commit = 1;
    log.committing = 1;
    8000366a:	00027497          	auipc	s1,0x27
    8000366e:	28648493          	addi	s1,s1,646 # 8002a8f0 <log>
    80003672:	4785                	li	a5,1
    80003674:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    80003676:	8526                	mv	a0,s1
    80003678:	00003097          	auipc	ra,0x3
    8000367c:	f08080e7          	jalr	-248(ra) # 80006580 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003680:	54dc                	lw	a5,44(s1)
    80003682:	06f04763          	bgtz	a5,800036f0 <end_op+0xbc>
    acquire(&log.lock);
    80003686:	00027497          	auipc	s1,0x27
    8000368a:	26a48493          	addi	s1,s1,618 # 8002a8f0 <log>
    8000368e:	8526                	mv	a0,s1
    80003690:	00003097          	auipc	ra,0x3
    80003694:	e3c080e7          	jalr	-452(ra) # 800064cc <acquire>
    log.committing = 0;
    80003698:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    8000369c:	8526                	mv	a0,s1
    8000369e:	ffffe097          	auipc	ra,0xffffe
    800036a2:	ee8080e7          	jalr	-280(ra) # 80001586 <wakeup>
    release(&log.lock);
    800036a6:	8526                	mv	a0,s1
    800036a8:	00003097          	auipc	ra,0x3
    800036ac:	ed8080e7          	jalr	-296(ra) # 80006580 <release>
}
    800036b0:	70e2                	ld	ra,56(sp)
    800036b2:	7442                	ld	s0,48(sp)
    800036b4:	74a2                	ld	s1,40(sp)
    800036b6:	7902                	ld	s2,32(sp)
    800036b8:	69e2                	ld	s3,24(sp)
    800036ba:	6a42                	ld	s4,16(sp)
    800036bc:	6aa2                	ld	s5,8(sp)
    800036be:	6121                	addi	sp,sp,64
    800036c0:	8082                	ret
    panic("log.committing");
    800036c2:	00005517          	auipc	a0,0x5
    800036c6:	eee50513          	addi	a0,a0,-274 # 800085b0 <syscalls+0x1f0>
    800036ca:	00003097          	auipc	ra,0x3
    800036ce:	8b8080e7          	jalr	-1864(ra) # 80005f82 <panic>
    wakeup(&log);
    800036d2:	00027497          	auipc	s1,0x27
    800036d6:	21e48493          	addi	s1,s1,542 # 8002a8f0 <log>
    800036da:	8526                	mv	a0,s1
    800036dc:	ffffe097          	auipc	ra,0xffffe
    800036e0:	eaa080e7          	jalr	-342(ra) # 80001586 <wakeup>
  release(&log.lock);
    800036e4:	8526                	mv	a0,s1
    800036e6:	00003097          	auipc	ra,0x3
    800036ea:	e9a080e7          	jalr	-358(ra) # 80006580 <release>
  if(do_commit){
    800036ee:	b7c9                	j	800036b0 <end_op+0x7c>
  for (tail = 0; tail < log.lh.n; tail++) {
    800036f0:	00027a97          	auipc	s5,0x27
    800036f4:	230a8a93          	addi	s5,s5,560 # 8002a920 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    800036f8:	00027a17          	auipc	s4,0x27
    800036fc:	1f8a0a13          	addi	s4,s4,504 # 8002a8f0 <log>
    80003700:	018a2583          	lw	a1,24(s4)
    80003704:	012585bb          	addw	a1,a1,s2
    80003708:	2585                	addiw	a1,a1,1
    8000370a:	028a2503          	lw	a0,40(s4)
    8000370e:	fffff097          	auipc	ra,0xfffff
    80003712:	cca080e7          	jalr	-822(ra) # 800023d8 <bread>
    80003716:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003718:	000aa583          	lw	a1,0(s5)
    8000371c:	028a2503          	lw	a0,40(s4)
    80003720:	fffff097          	auipc	ra,0xfffff
    80003724:	cb8080e7          	jalr	-840(ra) # 800023d8 <bread>
    80003728:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    8000372a:	40000613          	li	a2,1024
    8000372e:	05850593          	addi	a1,a0,88
    80003732:	05848513          	addi	a0,s1,88
    80003736:	ffffd097          	auipc	ra,0xffffd
    8000373a:	aa2080e7          	jalr	-1374(ra) # 800001d8 <memmove>
    bwrite(to);  // write the log
    8000373e:	8526                	mv	a0,s1
    80003740:	fffff097          	auipc	ra,0xfffff
    80003744:	d8a080e7          	jalr	-630(ra) # 800024ca <bwrite>
    brelse(from);
    80003748:	854e                	mv	a0,s3
    8000374a:	fffff097          	auipc	ra,0xfffff
    8000374e:	dbe080e7          	jalr	-578(ra) # 80002508 <brelse>
    brelse(to);
    80003752:	8526                	mv	a0,s1
    80003754:	fffff097          	auipc	ra,0xfffff
    80003758:	db4080e7          	jalr	-588(ra) # 80002508 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000375c:	2905                	addiw	s2,s2,1
    8000375e:	0a91                	addi	s5,s5,4
    80003760:	02ca2783          	lw	a5,44(s4)
    80003764:	f8f94ee3          	blt	s2,a5,80003700 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003768:	00000097          	auipc	ra,0x0
    8000376c:	c6a080e7          	jalr	-918(ra) # 800033d2 <write_head>
    install_trans(0); // Now install writes to home locations
    80003770:	4501                	li	a0,0
    80003772:	00000097          	auipc	ra,0x0
    80003776:	cda080e7          	jalr	-806(ra) # 8000344c <install_trans>
    log.lh.n = 0;
    8000377a:	00027797          	auipc	a5,0x27
    8000377e:	1a07a123          	sw	zero,418(a5) # 8002a91c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003782:	00000097          	auipc	ra,0x0
    80003786:	c50080e7          	jalr	-944(ra) # 800033d2 <write_head>
    8000378a:	bdf5                	j	80003686 <end_op+0x52>

000000008000378c <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    8000378c:	1101                	addi	sp,sp,-32
    8000378e:	ec06                	sd	ra,24(sp)
    80003790:	e822                	sd	s0,16(sp)
    80003792:	e426                	sd	s1,8(sp)
    80003794:	e04a                	sd	s2,0(sp)
    80003796:	1000                	addi	s0,sp,32
    80003798:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    8000379a:	00027917          	auipc	s2,0x27
    8000379e:	15690913          	addi	s2,s2,342 # 8002a8f0 <log>
    800037a2:	854a                	mv	a0,s2
    800037a4:	00003097          	auipc	ra,0x3
    800037a8:	d28080e7          	jalr	-728(ra) # 800064cc <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800037ac:	02c92603          	lw	a2,44(s2)
    800037b0:	47f5                	li	a5,29
    800037b2:	06c7c563          	blt	a5,a2,8000381c <log_write+0x90>
    800037b6:	00027797          	auipc	a5,0x27
    800037ba:	1567a783          	lw	a5,342(a5) # 8002a90c <log+0x1c>
    800037be:	37fd                	addiw	a5,a5,-1
    800037c0:	04f65e63          	bge	a2,a5,8000381c <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800037c4:	00027797          	auipc	a5,0x27
    800037c8:	14c7a783          	lw	a5,332(a5) # 8002a910 <log+0x20>
    800037cc:	06f05063          	blez	a5,8000382c <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800037d0:	4781                	li	a5,0
    800037d2:	06c05563          	blez	a2,8000383c <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800037d6:	44cc                	lw	a1,12(s1)
    800037d8:	00027717          	auipc	a4,0x27
    800037dc:	14870713          	addi	a4,a4,328 # 8002a920 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    800037e0:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    800037e2:	4314                	lw	a3,0(a4)
    800037e4:	04b68c63          	beq	a3,a1,8000383c <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    800037e8:	2785                	addiw	a5,a5,1
    800037ea:	0711                	addi	a4,a4,4
    800037ec:	fef61be3          	bne	a2,a5,800037e2 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    800037f0:	0621                	addi	a2,a2,8
    800037f2:	060a                	slli	a2,a2,0x2
    800037f4:	00027797          	auipc	a5,0x27
    800037f8:	0fc78793          	addi	a5,a5,252 # 8002a8f0 <log>
    800037fc:	963e                	add	a2,a2,a5
    800037fe:	44dc                	lw	a5,12(s1)
    80003800:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003802:	8526                	mv	a0,s1
    80003804:	fffff097          	auipc	ra,0xfffff
    80003808:	da2080e7          	jalr	-606(ra) # 800025a6 <bpin>
    log.lh.n++;
    8000380c:	00027717          	auipc	a4,0x27
    80003810:	0e470713          	addi	a4,a4,228 # 8002a8f0 <log>
    80003814:	575c                	lw	a5,44(a4)
    80003816:	2785                	addiw	a5,a5,1
    80003818:	d75c                	sw	a5,44(a4)
    8000381a:	a835                	j	80003856 <log_write+0xca>
    panic("too big a transaction");
    8000381c:	00005517          	auipc	a0,0x5
    80003820:	da450513          	addi	a0,a0,-604 # 800085c0 <syscalls+0x200>
    80003824:	00002097          	auipc	ra,0x2
    80003828:	75e080e7          	jalr	1886(ra) # 80005f82 <panic>
    panic("log_write outside of trans");
    8000382c:	00005517          	auipc	a0,0x5
    80003830:	dac50513          	addi	a0,a0,-596 # 800085d8 <syscalls+0x218>
    80003834:	00002097          	auipc	ra,0x2
    80003838:	74e080e7          	jalr	1870(ra) # 80005f82 <panic>
  log.lh.block[i] = b->blockno;
    8000383c:	00878713          	addi	a4,a5,8
    80003840:	00271693          	slli	a3,a4,0x2
    80003844:	00027717          	auipc	a4,0x27
    80003848:	0ac70713          	addi	a4,a4,172 # 8002a8f0 <log>
    8000384c:	9736                	add	a4,a4,a3
    8000384e:	44d4                	lw	a3,12(s1)
    80003850:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    80003852:	faf608e3          	beq	a2,a5,80003802 <log_write+0x76>
  }
  release(&log.lock);
    80003856:	00027517          	auipc	a0,0x27
    8000385a:	09a50513          	addi	a0,a0,154 # 8002a8f0 <log>
    8000385e:	00003097          	auipc	ra,0x3
    80003862:	d22080e7          	jalr	-734(ra) # 80006580 <release>
}
    80003866:	60e2                	ld	ra,24(sp)
    80003868:	6442                	ld	s0,16(sp)
    8000386a:	64a2                	ld	s1,8(sp)
    8000386c:	6902                	ld	s2,0(sp)
    8000386e:	6105                	addi	sp,sp,32
    80003870:	8082                	ret

0000000080003872 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    80003872:	1101                	addi	sp,sp,-32
    80003874:	ec06                	sd	ra,24(sp)
    80003876:	e822                	sd	s0,16(sp)
    80003878:	e426                	sd	s1,8(sp)
    8000387a:	e04a                	sd	s2,0(sp)
    8000387c:	1000                	addi	s0,sp,32
    8000387e:	84aa                	mv	s1,a0
    80003880:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003882:	00005597          	auipc	a1,0x5
    80003886:	d7658593          	addi	a1,a1,-650 # 800085f8 <syscalls+0x238>
    8000388a:	0521                	addi	a0,a0,8
    8000388c:	00003097          	auipc	ra,0x3
    80003890:	bb0080e7          	jalr	-1104(ra) # 8000643c <initlock>
  lk->name = name;
    80003894:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003898:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000389c:	0204a423          	sw	zero,40(s1)
}
    800038a0:	60e2                	ld	ra,24(sp)
    800038a2:	6442                	ld	s0,16(sp)
    800038a4:	64a2                	ld	s1,8(sp)
    800038a6:	6902                	ld	s2,0(sp)
    800038a8:	6105                	addi	sp,sp,32
    800038aa:	8082                	ret

00000000800038ac <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800038ac:	1101                	addi	sp,sp,-32
    800038ae:	ec06                	sd	ra,24(sp)
    800038b0:	e822                	sd	s0,16(sp)
    800038b2:	e426                	sd	s1,8(sp)
    800038b4:	e04a                	sd	s2,0(sp)
    800038b6:	1000                	addi	s0,sp,32
    800038b8:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800038ba:	00850913          	addi	s2,a0,8
    800038be:	854a                	mv	a0,s2
    800038c0:	00003097          	auipc	ra,0x3
    800038c4:	c0c080e7          	jalr	-1012(ra) # 800064cc <acquire>
  while (lk->locked) {
    800038c8:	409c                	lw	a5,0(s1)
    800038ca:	cb89                	beqz	a5,800038dc <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800038cc:	85ca                	mv	a1,s2
    800038ce:	8526                	mv	a0,s1
    800038d0:	ffffe097          	auipc	ra,0xffffe
    800038d4:	c52080e7          	jalr	-942(ra) # 80001522 <sleep>
  while (lk->locked) {
    800038d8:	409c                	lw	a5,0(s1)
    800038da:	fbed                	bnez	a5,800038cc <acquiresleep+0x20>
  }
  lk->locked = 1;
    800038dc:	4785                	li	a5,1
    800038de:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    800038e0:	ffffd097          	auipc	ra,0xffffd
    800038e4:	55e080e7          	jalr	1374(ra) # 80000e3e <myproc>
    800038e8:	591c                	lw	a5,48(a0)
    800038ea:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    800038ec:	854a                	mv	a0,s2
    800038ee:	00003097          	auipc	ra,0x3
    800038f2:	c92080e7          	jalr	-878(ra) # 80006580 <release>
}
    800038f6:	60e2                	ld	ra,24(sp)
    800038f8:	6442                	ld	s0,16(sp)
    800038fa:	64a2                	ld	s1,8(sp)
    800038fc:	6902                	ld	s2,0(sp)
    800038fe:	6105                	addi	sp,sp,32
    80003900:	8082                	ret

0000000080003902 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003902:	1101                	addi	sp,sp,-32
    80003904:	ec06                	sd	ra,24(sp)
    80003906:	e822                	sd	s0,16(sp)
    80003908:	e426                	sd	s1,8(sp)
    8000390a:	e04a                	sd	s2,0(sp)
    8000390c:	1000                	addi	s0,sp,32
    8000390e:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003910:	00850913          	addi	s2,a0,8
    80003914:	854a                	mv	a0,s2
    80003916:	00003097          	auipc	ra,0x3
    8000391a:	bb6080e7          	jalr	-1098(ra) # 800064cc <acquire>
  lk->locked = 0;
    8000391e:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    80003922:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    80003926:	8526                	mv	a0,s1
    80003928:	ffffe097          	auipc	ra,0xffffe
    8000392c:	c5e080e7          	jalr	-930(ra) # 80001586 <wakeup>
  release(&lk->lk);
    80003930:	854a                	mv	a0,s2
    80003932:	00003097          	auipc	ra,0x3
    80003936:	c4e080e7          	jalr	-946(ra) # 80006580 <release>
}
    8000393a:	60e2                	ld	ra,24(sp)
    8000393c:	6442                	ld	s0,16(sp)
    8000393e:	64a2                	ld	s1,8(sp)
    80003940:	6902                	ld	s2,0(sp)
    80003942:	6105                	addi	sp,sp,32
    80003944:	8082                	ret

0000000080003946 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    80003946:	7179                	addi	sp,sp,-48
    80003948:	f406                	sd	ra,40(sp)
    8000394a:	f022                	sd	s0,32(sp)
    8000394c:	ec26                	sd	s1,24(sp)
    8000394e:	e84a                	sd	s2,16(sp)
    80003950:	e44e                	sd	s3,8(sp)
    80003952:	1800                	addi	s0,sp,48
    80003954:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    80003956:	00850913          	addi	s2,a0,8
    8000395a:	854a                	mv	a0,s2
    8000395c:	00003097          	auipc	ra,0x3
    80003960:	b70080e7          	jalr	-1168(ra) # 800064cc <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    80003964:	409c                	lw	a5,0(s1)
    80003966:	ef99                	bnez	a5,80003984 <holdingsleep+0x3e>
    80003968:	4481                	li	s1,0
  release(&lk->lk);
    8000396a:	854a                	mv	a0,s2
    8000396c:	00003097          	auipc	ra,0x3
    80003970:	c14080e7          	jalr	-1004(ra) # 80006580 <release>
  return r;
}
    80003974:	8526                	mv	a0,s1
    80003976:	70a2                	ld	ra,40(sp)
    80003978:	7402                	ld	s0,32(sp)
    8000397a:	64e2                	ld	s1,24(sp)
    8000397c:	6942                	ld	s2,16(sp)
    8000397e:	69a2                	ld	s3,8(sp)
    80003980:	6145                	addi	sp,sp,48
    80003982:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003984:	0284a983          	lw	s3,40(s1)
    80003988:	ffffd097          	auipc	ra,0xffffd
    8000398c:	4b6080e7          	jalr	1206(ra) # 80000e3e <myproc>
    80003990:	5904                	lw	s1,48(a0)
    80003992:	413484b3          	sub	s1,s1,s3
    80003996:	0014b493          	seqz	s1,s1
    8000399a:	bfc1                	j	8000396a <holdingsleep+0x24>

000000008000399c <fileinit>:
    struct spinlock lock;
    struct file file[NFILE];
} ftable;

void fileinit(void)
{
    8000399c:	1141                	addi	sp,sp,-16
    8000399e:	e406                	sd	ra,8(sp)
    800039a0:	e022                	sd	s0,0(sp)
    800039a2:	0800                	addi	s0,sp,16
    initlock(&ftable.lock, "ftable");
    800039a4:	00005597          	auipc	a1,0x5
    800039a8:	c6458593          	addi	a1,a1,-924 # 80008608 <syscalls+0x248>
    800039ac:	00027517          	auipc	a0,0x27
    800039b0:	08c50513          	addi	a0,a0,140 # 8002aa38 <ftable>
    800039b4:	00003097          	auipc	ra,0x3
    800039b8:	a88080e7          	jalr	-1400(ra) # 8000643c <initlock>
}
    800039bc:	60a2                	ld	ra,8(sp)
    800039be:	6402                	ld	s0,0(sp)
    800039c0:	0141                	addi	sp,sp,16
    800039c2:	8082                	ret

00000000800039c4 <filealloc>:

// Allocate a file structure.
struct file *
filealloc(void)
{
    800039c4:	1101                	addi	sp,sp,-32
    800039c6:	ec06                	sd	ra,24(sp)
    800039c8:	e822                	sd	s0,16(sp)
    800039ca:	e426                	sd	s1,8(sp)
    800039cc:	1000                	addi	s0,sp,32
    struct file *f;

    acquire(&ftable.lock);
    800039ce:	00027517          	auipc	a0,0x27
    800039d2:	06a50513          	addi	a0,a0,106 # 8002aa38 <ftable>
    800039d6:	00003097          	auipc	ra,0x3
    800039da:	af6080e7          	jalr	-1290(ra) # 800064cc <acquire>
    for (f = ftable.file; f < ftable.file + NFILE; f++)
    800039de:	00027497          	auipc	s1,0x27
    800039e2:	07248493          	addi	s1,s1,114 # 8002aa50 <ftable+0x18>
    800039e6:	00028717          	auipc	a4,0x28
    800039ea:	00a70713          	addi	a4,a4,10 # 8002b9f0 <disk>
    {
        if (f->ref == 0)
    800039ee:	40dc                	lw	a5,4(s1)
    800039f0:	cf99                	beqz	a5,80003a0e <filealloc+0x4a>
    for (f = ftable.file; f < ftable.file + NFILE; f++)
    800039f2:	02848493          	addi	s1,s1,40
    800039f6:	fee49ce3          	bne	s1,a4,800039ee <filealloc+0x2a>
            f->ref = 1;
            release(&ftable.lock);
            return f;
        }
    }
    release(&ftable.lock);
    800039fa:	00027517          	auipc	a0,0x27
    800039fe:	03e50513          	addi	a0,a0,62 # 8002aa38 <ftable>
    80003a02:	00003097          	auipc	ra,0x3
    80003a06:	b7e080e7          	jalr	-1154(ra) # 80006580 <release>
    return 0;
    80003a0a:	4481                	li	s1,0
    80003a0c:	a819                	j	80003a22 <filealloc+0x5e>
            f->ref = 1;
    80003a0e:	4785                	li	a5,1
    80003a10:	c0dc                	sw	a5,4(s1)
            release(&ftable.lock);
    80003a12:	00027517          	auipc	a0,0x27
    80003a16:	02650513          	addi	a0,a0,38 # 8002aa38 <ftable>
    80003a1a:	00003097          	auipc	ra,0x3
    80003a1e:	b66080e7          	jalr	-1178(ra) # 80006580 <release>
}
    80003a22:	8526                	mv	a0,s1
    80003a24:	60e2                	ld	ra,24(sp)
    80003a26:	6442                	ld	s0,16(sp)
    80003a28:	64a2                	ld	s1,8(sp)
    80003a2a:	6105                	addi	sp,sp,32
    80003a2c:	8082                	ret

0000000080003a2e <filedup>:

// Increment ref count for file f.
struct file *
filedup(struct file *f)
{
    80003a2e:	1101                	addi	sp,sp,-32
    80003a30:	ec06                	sd	ra,24(sp)
    80003a32:	e822                	sd	s0,16(sp)
    80003a34:	e426                	sd	s1,8(sp)
    80003a36:	1000                	addi	s0,sp,32
    80003a38:	84aa                	mv	s1,a0
    acquire(&ftable.lock);
    80003a3a:	00027517          	auipc	a0,0x27
    80003a3e:	ffe50513          	addi	a0,a0,-2 # 8002aa38 <ftable>
    80003a42:	00003097          	auipc	ra,0x3
    80003a46:	a8a080e7          	jalr	-1398(ra) # 800064cc <acquire>
    if (f->ref < 1)
    80003a4a:	40dc                	lw	a5,4(s1)
    80003a4c:	02f05263          	blez	a5,80003a70 <filedup+0x42>
        panic("filedup");
    f->ref++;
    80003a50:	2785                	addiw	a5,a5,1
    80003a52:	c0dc                	sw	a5,4(s1)
    release(&ftable.lock);
    80003a54:	00027517          	auipc	a0,0x27
    80003a58:	fe450513          	addi	a0,a0,-28 # 8002aa38 <ftable>
    80003a5c:	00003097          	auipc	ra,0x3
    80003a60:	b24080e7          	jalr	-1244(ra) # 80006580 <release>
    return f;
}
    80003a64:	8526                	mv	a0,s1
    80003a66:	60e2                	ld	ra,24(sp)
    80003a68:	6442                	ld	s0,16(sp)
    80003a6a:	64a2                	ld	s1,8(sp)
    80003a6c:	6105                	addi	sp,sp,32
    80003a6e:	8082                	ret
        panic("filedup");
    80003a70:	00005517          	auipc	a0,0x5
    80003a74:	ba050513          	addi	a0,a0,-1120 # 80008610 <syscalls+0x250>
    80003a78:	00002097          	auipc	ra,0x2
    80003a7c:	50a080e7          	jalr	1290(ra) # 80005f82 <panic>

0000000080003a80 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void fileclose(struct file *f)
{
    80003a80:	7139                	addi	sp,sp,-64
    80003a82:	fc06                	sd	ra,56(sp)
    80003a84:	f822                	sd	s0,48(sp)
    80003a86:	f426                	sd	s1,40(sp)
    80003a88:	f04a                	sd	s2,32(sp)
    80003a8a:	ec4e                	sd	s3,24(sp)
    80003a8c:	e852                	sd	s4,16(sp)
    80003a8e:	e456                	sd	s5,8(sp)
    80003a90:	0080                	addi	s0,sp,64
    80003a92:	84aa                	mv	s1,a0
    struct file ff;

    acquire(&ftable.lock);
    80003a94:	00027517          	auipc	a0,0x27
    80003a98:	fa450513          	addi	a0,a0,-92 # 8002aa38 <ftable>
    80003a9c:	00003097          	auipc	ra,0x3
    80003aa0:	a30080e7          	jalr	-1488(ra) # 800064cc <acquire>
    if (f->ref < 1)
    80003aa4:	40dc                	lw	a5,4(s1)
    80003aa6:	06f05163          	blez	a5,80003b08 <fileclose+0x88>
        panic("fileclose");
    if (--f->ref > 0)
    80003aaa:	37fd                	addiw	a5,a5,-1
    80003aac:	0007871b          	sext.w	a4,a5
    80003ab0:	c0dc                	sw	a5,4(s1)
    80003ab2:	06e04363          	bgtz	a4,80003b18 <fileclose+0x98>
    {
        release(&ftable.lock);
        return;
    }
    ff = *f;
    80003ab6:	0004a903          	lw	s2,0(s1)
    80003aba:	0094ca83          	lbu	s5,9(s1)
    80003abe:	0104ba03          	ld	s4,16(s1)
    80003ac2:	0184b983          	ld	s3,24(s1)
    f->ref = 0;
    80003ac6:	0004a223          	sw	zero,4(s1)
    f->type = FD_NONE;
    80003aca:	0004a023          	sw	zero,0(s1)
    release(&ftable.lock);
    80003ace:	00027517          	auipc	a0,0x27
    80003ad2:	f6a50513          	addi	a0,a0,-150 # 8002aa38 <ftable>
    80003ad6:	00003097          	auipc	ra,0x3
    80003ada:	aaa080e7          	jalr	-1366(ra) # 80006580 <release>

    if (ff.type == FD_PIPE)
    80003ade:	4785                	li	a5,1
    80003ae0:	04f90d63          	beq	s2,a5,80003b3a <fileclose+0xba>
    {
        pipeclose(ff.pipe, ff.writable);
    }
    else if (ff.type == FD_INODE || ff.type == FD_DEVICE)
    80003ae4:	3979                	addiw	s2,s2,-2
    80003ae6:	4785                	li	a5,1
    80003ae8:	0527e063          	bltu	a5,s2,80003b28 <fileclose+0xa8>
    {
        begin_op();
    80003aec:	00000097          	auipc	ra,0x0
    80003af0:	ac8080e7          	jalr	-1336(ra) # 800035b4 <begin_op>
        iput(ff.ip);
    80003af4:	854e                	mv	a0,s3
    80003af6:	fffff097          	auipc	ra,0xfffff
    80003afa:	2b6080e7          	jalr	694(ra) # 80002dac <iput>
        end_op();
    80003afe:	00000097          	auipc	ra,0x0
    80003b02:	b36080e7          	jalr	-1226(ra) # 80003634 <end_op>
    80003b06:	a00d                	j	80003b28 <fileclose+0xa8>
        panic("fileclose");
    80003b08:	00005517          	auipc	a0,0x5
    80003b0c:	b1050513          	addi	a0,a0,-1264 # 80008618 <syscalls+0x258>
    80003b10:	00002097          	auipc	ra,0x2
    80003b14:	472080e7          	jalr	1138(ra) # 80005f82 <panic>
        release(&ftable.lock);
    80003b18:	00027517          	auipc	a0,0x27
    80003b1c:	f2050513          	addi	a0,a0,-224 # 8002aa38 <ftable>
    80003b20:	00003097          	auipc	ra,0x3
    80003b24:	a60080e7          	jalr	-1440(ra) # 80006580 <release>
    }
}
    80003b28:	70e2                	ld	ra,56(sp)
    80003b2a:	7442                	ld	s0,48(sp)
    80003b2c:	74a2                	ld	s1,40(sp)
    80003b2e:	7902                	ld	s2,32(sp)
    80003b30:	69e2                	ld	s3,24(sp)
    80003b32:	6a42                	ld	s4,16(sp)
    80003b34:	6aa2                	ld	s5,8(sp)
    80003b36:	6121                	addi	sp,sp,64
    80003b38:	8082                	ret
        pipeclose(ff.pipe, ff.writable);
    80003b3a:	85d6                	mv	a1,s5
    80003b3c:	8552                	mv	a0,s4
    80003b3e:	00000097          	auipc	ra,0x0
    80003b42:	3a6080e7          	jalr	934(ra) # 80003ee4 <pipeclose>
    80003b46:	b7cd                	j	80003b28 <fileclose+0xa8>

0000000080003b48 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int filestat(struct file *f, uint64 addr)
{
    80003b48:	715d                	addi	sp,sp,-80
    80003b4a:	e486                	sd	ra,72(sp)
    80003b4c:	e0a2                	sd	s0,64(sp)
    80003b4e:	fc26                	sd	s1,56(sp)
    80003b50:	f84a                	sd	s2,48(sp)
    80003b52:	f44e                	sd	s3,40(sp)
    80003b54:	0880                	addi	s0,sp,80
    80003b56:	84aa                	mv	s1,a0
    80003b58:	89ae                	mv	s3,a1
    struct proc *p = myproc();
    80003b5a:	ffffd097          	auipc	ra,0xffffd
    80003b5e:	2e4080e7          	jalr	740(ra) # 80000e3e <myproc>
    struct stat st;

    if (f->type == FD_INODE || f->type == FD_DEVICE)
    80003b62:	409c                	lw	a5,0(s1)
    80003b64:	37f9                	addiw	a5,a5,-2
    80003b66:	4705                	li	a4,1
    80003b68:	04f76763          	bltu	a4,a5,80003bb6 <filestat+0x6e>
    80003b6c:	892a                	mv	s2,a0
    {
        ilock(f->ip);
    80003b6e:	6c88                	ld	a0,24(s1)
    80003b70:	fffff097          	auipc	ra,0xfffff
    80003b74:	082080e7          	jalr	130(ra) # 80002bf2 <ilock>
        stati(f->ip, &st);
    80003b78:	fb840593          	addi	a1,s0,-72
    80003b7c:	6c88                	ld	a0,24(s1)
    80003b7e:	fffff097          	auipc	ra,0xfffff
    80003b82:	2fe080e7          	jalr	766(ra) # 80002e7c <stati>
        iunlock(f->ip);
    80003b86:	6c88                	ld	a0,24(s1)
    80003b88:	fffff097          	auipc	ra,0xfffff
    80003b8c:	12c080e7          	jalr	300(ra) # 80002cb4 <iunlock>
        if (copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003b90:	46e1                	li	a3,24
    80003b92:	fb840613          	addi	a2,s0,-72
    80003b96:	85ce                	mv	a1,s3
    80003b98:	05093503          	ld	a0,80(s2)
    80003b9c:	ffffd097          	auipc	ra,0xffffd
    80003ba0:	f60080e7          	jalr	-160(ra) # 80000afc <copyout>
    80003ba4:	41f5551b          	sraiw	a0,a0,0x1f
            return -1;
        return 0;
    }
    return -1;
}
    80003ba8:	60a6                	ld	ra,72(sp)
    80003baa:	6406                	ld	s0,64(sp)
    80003bac:	74e2                	ld	s1,56(sp)
    80003bae:	7942                	ld	s2,48(sp)
    80003bb0:	79a2                	ld	s3,40(sp)
    80003bb2:	6161                	addi	sp,sp,80
    80003bb4:	8082                	ret
    return -1;
    80003bb6:	557d                	li	a0,-1
    80003bb8:	bfc5                	j	80003ba8 <filestat+0x60>

0000000080003bba <mapfile>:

void mapfile(struct file *f, char *mem, int offset)
{
    80003bba:	7179                	addi	sp,sp,-48
    80003bbc:	f406                	sd	ra,40(sp)
    80003bbe:	f022                	sd	s0,32(sp)
    80003bc0:	ec26                	sd	s1,24(sp)
    80003bc2:	e84a                	sd	s2,16(sp)
    80003bc4:	e44e                	sd	s3,8(sp)
    80003bc6:	1800                	addi	s0,sp,48
    80003bc8:	84aa                	mv	s1,a0
    80003bca:	89ae                	mv	s3,a1
    80003bcc:	8932                	mv	s2,a2
    printf("off %d\n", offset);
    80003bce:	85b2                	mv	a1,a2
    80003bd0:	00005517          	auipc	a0,0x5
    80003bd4:	a5850513          	addi	a0,a0,-1448 # 80008628 <syscalls+0x268>
    80003bd8:	00002097          	auipc	ra,0x2
    80003bdc:	3f4080e7          	jalr	1012(ra) # 80005fcc <printf>
    ilock(f->ip);
    80003be0:	6c88                	ld	a0,24(s1)
    80003be2:	fffff097          	auipc	ra,0xfffff
    80003be6:	010080e7          	jalr	16(ra) # 80002bf2 <ilock>
    readi(f->ip, 0, (uint64)mem, offset, PGSIZE);
    80003bea:	6705                	lui	a4,0x1
    80003bec:	86ca                	mv	a3,s2
    80003bee:	864e                	mv	a2,s3
    80003bf0:	4581                	li	a1,0
    80003bf2:	6c88                	ld	a0,24(s1)
    80003bf4:	fffff097          	auipc	ra,0xfffff
    80003bf8:	2b2080e7          	jalr	690(ra) # 80002ea6 <readi>
    iunlock(f->ip);
    80003bfc:	6c88                	ld	a0,24(s1)
    80003bfe:	fffff097          	auipc	ra,0xfffff
    80003c02:	0b6080e7          	jalr	182(ra) # 80002cb4 <iunlock>
}
    80003c06:	70a2                	ld	ra,40(sp)
    80003c08:	7402                	ld	s0,32(sp)
    80003c0a:	64e2                	ld	s1,24(sp)
    80003c0c:	6942                	ld	s2,16(sp)
    80003c0e:	69a2                	ld	s3,8(sp)
    80003c10:	6145                	addi	sp,sp,48
    80003c12:	8082                	ret

0000000080003c14 <fileread>:

// Read from file f.
// addr is a user virtual address.
int fileread(struct file *f, uint64 addr, int n)
{
    80003c14:	7179                	addi	sp,sp,-48
    80003c16:	f406                	sd	ra,40(sp)
    80003c18:	f022                	sd	s0,32(sp)
    80003c1a:	ec26                	sd	s1,24(sp)
    80003c1c:	e84a                	sd	s2,16(sp)
    80003c1e:	e44e                	sd	s3,8(sp)
    80003c20:	1800                	addi	s0,sp,48
    int r = 0;

    if (f->readable == 0)
    80003c22:	00854783          	lbu	a5,8(a0)
    80003c26:	c3d5                	beqz	a5,80003cca <fileread+0xb6>
    80003c28:	84aa                	mv	s1,a0
    80003c2a:	89ae                	mv	s3,a1
    80003c2c:	8932                	mv	s2,a2
        return -1;

    if (f->type == FD_PIPE)
    80003c2e:	411c                	lw	a5,0(a0)
    80003c30:	4705                	li	a4,1
    80003c32:	04e78963          	beq	a5,a4,80003c84 <fileread+0x70>
    {
        r = piperead(f->pipe, addr, n);
    }
    else if (f->type == FD_DEVICE)
    80003c36:	470d                	li	a4,3
    80003c38:	04e78d63          	beq	a5,a4,80003c92 <fileread+0x7e>
    {
        if (f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
            return -1;
        r = devsw[f->major].read(1, addr, n);
    }
    else if (f->type == FD_INODE)
    80003c3c:	4709                	li	a4,2
    80003c3e:	06e79e63          	bne	a5,a4,80003cba <fileread+0xa6>
    {
        ilock(f->ip);
    80003c42:	6d08                	ld	a0,24(a0)
    80003c44:	fffff097          	auipc	ra,0xfffff
    80003c48:	fae080e7          	jalr	-82(ra) # 80002bf2 <ilock>
        if ((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003c4c:	874a                	mv	a4,s2
    80003c4e:	5094                	lw	a3,32(s1)
    80003c50:	864e                	mv	a2,s3
    80003c52:	4585                	li	a1,1
    80003c54:	6c88                	ld	a0,24(s1)
    80003c56:	fffff097          	auipc	ra,0xfffff
    80003c5a:	250080e7          	jalr	592(ra) # 80002ea6 <readi>
    80003c5e:	892a                	mv	s2,a0
    80003c60:	00a05563          	blez	a0,80003c6a <fileread+0x56>
            f->off += r;
    80003c64:	509c                	lw	a5,32(s1)
    80003c66:	9fa9                	addw	a5,a5,a0
    80003c68:	d09c                	sw	a5,32(s1)
        iunlock(f->ip);
    80003c6a:	6c88                	ld	a0,24(s1)
    80003c6c:	fffff097          	auipc	ra,0xfffff
    80003c70:	048080e7          	jalr	72(ra) # 80002cb4 <iunlock>
    {
        panic("fileread");
    }

    return r;
}
    80003c74:	854a                	mv	a0,s2
    80003c76:	70a2                	ld	ra,40(sp)
    80003c78:	7402                	ld	s0,32(sp)
    80003c7a:	64e2                	ld	s1,24(sp)
    80003c7c:	6942                	ld	s2,16(sp)
    80003c7e:	69a2                	ld	s3,8(sp)
    80003c80:	6145                	addi	sp,sp,48
    80003c82:	8082                	ret
        r = piperead(f->pipe, addr, n);
    80003c84:	6908                	ld	a0,16(a0)
    80003c86:	00000097          	auipc	ra,0x0
    80003c8a:	3ce080e7          	jalr	974(ra) # 80004054 <piperead>
    80003c8e:	892a                	mv	s2,a0
    80003c90:	b7d5                	j	80003c74 <fileread+0x60>
        if (f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003c92:	02451783          	lh	a5,36(a0)
    80003c96:	03079693          	slli	a3,a5,0x30
    80003c9a:	92c1                	srli	a3,a3,0x30
    80003c9c:	4725                	li	a4,9
    80003c9e:	02d76863          	bltu	a4,a3,80003cce <fileread+0xba>
    80003ca2:	0792                	slli	a5,a5,0x4
    80003ca4:	00027717          	auipc	a4,0x27
    80003ca8:	cf470713          	addi	a4,a4,-780 # 8002a998 <devsw>
    80003cac:	97ba                	add	a5,a5,a4
    80003cae:	639c                	ld	a5,0(a5)
    80003cb0:	c38d                	beqz	a5,80003cd2 <fileread+0xbe>
        r = devsw[f->major].read(1, addr, n);
    80003cb2:	4505                	li	a0,1
    80003cb4:	9782                	jalr	a5
    80003cb6:	892a                	mv	s2,a0
    80003cb8:	bf75                	j	80003c74 <fileread+0x60>
        panic("fileread");
    80003cba:	00005517          	auipc	a0,0x5
    80003cbe:	97650513          	addi	a0,a0,-1674 # 80008630 <syscalls+0x270>
    80003cc2:	00002097          	auipc	ra,0x2
    80003cc6:	2c0080e7          	jalr	704(ra) # 80005f82 <panic>
        return -1;
    80003cca:	597d                	li	s2,-1
    80003ccc:	b765                	j	80003c74 <fileread+0x60>
            return -1;
    80003cce:	597d                	li	s2,-1
    80003cd0:	b755                	j	80003c74 <fileread+0x60>
    80003cd2:	597d                	li	s2,-1
    80003cd4:	b745                	j	80003c74 <fileread+0x60>

0000000080003cd6 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int filewrite(struct file *f, uint64 addr, int n)
{
    80003cd6:	715d                	addi	sp,sp,-80
    80003cd8:	e486                	sd	ra,72(sp)
    80003cda:	e0a2                	sd	s0,64(sp)
    80003cdc:	fc26                	sd	s1,56(sp)
    80003cde:	f84a                	sd	s2,48(sp)
    80003ce0:	f44e                	sd	s3,40(sp)
    80003ce2:	f052                	sd	s4,32(sp)
    80003ce4:	ec56                	sd	s5,24(sp)
    80003ce6:	e85a                	sd	s6,16(sp)
    80003ce8:	e45e                	sd	s7,8(sp)
    80003cea:	e062                	sd	s8,0(sp)
    80003cec:	0880                	addi	s0,sp,80
    int r, ret = 0;

    if (f->writable == 0)
    80003cee:	00954783          	lbu	a5,9(a0)
    80003cf2:	10078663          	beqz	a5,80003dfe <filewrite+0x128>
    80003cf6:	892a                	mv	s2,a0
    80003cf8:	8aae                	mv	s5,a1
    80003cfa:	8a32                	mv	s4,a2
        return -1;

    if (f->type == FD_PIPE)
    80003cfc:	411c                	lw	a5,0(a0)
    80003cfe:	4705                	li	a4,1
    80003d00:	02e78263          	beq	a5,a4,80003d24 <filewrite+0x4e>
    {
        ret = pipewrite(f->pipe, addr, n);
    }
    else if (f->type == FD_DEVICE)
    80003d04:	470d                	li	a4,3
    80003d06:	02e78663          	beq	a5,a4,80003d32 <filewrite+0x5c>
    {
        if (f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
            return -1;
        ret = devsw[f->major].write(1, addr, n);
    }
    else if (f->type == FD_INODE)
    80003d0a:	4709                	li	a4,2
    80003d0c:	0ee79163          	bne	a5,a4,80003dee <filewrite+0x118>
        // and 2 blocks of slop for non-aligned writes.
        // this really belongs lower down, since writei()
        // might be writing a device like the console.
        int max = ((MAXOPBLOCKS - 1 - 1 - 2) / 2) * BSIZE;
        int i = 0;
        while (i < n)
    80003d10:	0ac05d63          	blez	a2,80003dca <filewrite+0xf4>
        int i = 0;
    80003d14:	4981                	li	s3,0
    80003d16:	6b05                	lui	s6,0x1
    80003d18:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003d1c:	6b85                	lui	s7,0x1
    80003d1e:	c00b8b9b          	addiw	s7,s7,-1024
    80003d22:	a861                	j	80003dba <filewrite+0xe4>
        ret = pipewrite(f->pipe, addr, n);
    80003d24:	6908                	ld	a0,16(a0)
    80003d26:	00000097          	auipc	ra,0x0
    80003d2a:	22e080e7          	jalr	558(ra) # 80003f54 <pipewrite>
    80003d2e:	8a2a                	mv	s4,a0
    80003d30:	a045                	j	80003dd0 <filewrite+0xfa>
        if (f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003d32:	02451783          	lh	a5,36(a0)
    80003d36:	03079693          	slli	a3,a5,0x30
    80003d3a:	92c1                	srli	a3,a3,0x30
    80003d3c:	4725                	li	a4,9
    80003d3e:	0cd76263          	bltu	a4,a3,80003e02 <filewrite+0x12c>
    80003d42:	0792                	slli	a5,a5,0x4
    80003d44:	00027717          	auipc	a4,0x27
    80003d48:	c5470713          	addi	a4,a4,-940 # 8002a998 <devsw>
    80003d4c:	97ba                	add	a5,a5,a4
    80003d4e:	679c                	ld	a5,8(a5)
    80003d50:	cbdd                	beqz	a5,80003e06 <filewrite+0x130>
        ret = devsw[f->major].write(1, addr, n);
    80003d52:	4505                	li	a0,1
    80003d54:	9782                	jalr	a5
    80003d56:	8a2a                	mv	s4,a0
    80003d58:	a8a5                	j	80003dd0 <filewrite+0xfa>
    80003d5a:	00048c1b          	sext.w	s8,s1
        {
            int n1 = n - i;
            if (n1 > max)
                n1 = max;

            begin_op();
    80003d5e:	00000097          	auipc	ra,0x0
    80003d62:	856080e7          	jalr	-1962(ra) # 800035b4 <begin_op>
            ilock(f->ip);
    80003d66:	01893503          	ld	a0,24(s2)
    80003d6a:	fffff097          	auipc	ra,0xfffff
    80003d6e:	e88080e7          	jalr	-376(ra) # 80002bf2 <ilock>
            if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003d72:	8762                	mv	a4,s8
    80003d74:	02092683          	lw	a3,32(s2)
    80003d78:	01598633          	add	a2,s3,s5
    80003d7c:	4585                	li	a1,1
    80003d7e:	01893503          	ld	a0,24(s2)
    80003d82:	fffff097          	auipc	ra,0xfffff
    80003d86:	21c080e7          	jalr	540(ra) # 80002f9e <writei>
    80003d8a:	84aa                	mv	s1,a0
    80003d8c:	00a05763          	blez	a0,80003d9a <filewrite+0xc4>
                f->off += r;
    80003d90:	02092783          	lw	a5,32(s2)
    80003d94:	9fa9                	addw	a5,a5,a0
    80003d96:	02f92023          	sw	a5,32(s2)
            iunlock(f->ip);
    80003d9a:	01893503          	ld	a0,24(s2)
    80003d9e:	fffff097          	auipc	ra,0xfffff
    80003da2:	f16080e7          	jalr	-234(ra) # 80002cb4 <iunlock>
            end_op();
    80003da6:	00000097          	auipc	ra,0x0
    80003daa:	88e080e7          	jalr	-1906(ra) # 80003634 <end_op>

            if (r != n1)
    80003dae:	009c1f63          	bne	s8,s1,80003dcc <filewrite+0xf6>
            {
                // error from writei
                break;
            }
            i += r;
    80003db2:	013489bb          	addw	s3,s1,s3
        while (i < n)
    80003db6:	0149db63          	bge	s3,s4,80003dcc <filewrite+0xf6>
            int n1 = n - i;
    80003dba:	413a07bb          	subw	a5,s4,s3
            if (n1 > max)
    80003dbe:	84be                	mv	s1,a5
    80003dc0:	2781                	sext.w	a5,a5
    80003dc2:	f8fb5ce3          	bge	s6,a5,80003d5a <filewrite+0x84>
    80003dc6:	84de                	mv	s1,s7
    80003dc8:	bf49                	j	80003d5a <filewrite+0x84>
        int i = 0;
    80003dca:	4981                	li	s3,0
        }
        ret = (i == n ? n : -1);
    80003dcc:	013a1f63          	bne	s4,s3,80003dea <filewrite+0x114>
    {
        panic("filewrite");
    }

    return ret;
}
    80003dd0:	8552                	mv	a0,s4
    80003dd2:	60a6                	ld	ra,72(sp)
    80003dd4:	6406                	ld	s0,64(sp)
    80003dd6:	74e2                	ld	s1,56(sp)
    80003dd8:	7942                	ld	s2,48(sp)
    80003dda:	79a2                	ld	s3,40(sp)
    80003ddc:	7a02                	ld	s4,32(sp)
    80003dde:	6ae2                	ld	s5,24(sp)
    80003de0:	6b42                	ld	s6,16(sp)
    80003de2:	6ba2                	ld	s7,8(sp)
    80003de4:	6c02                	ld	s8,0(sp)
    80003de6:	6161                	addi	sp,sp,80
    80003de8:	8082                	ret
        ret = (i == n ? n : -1);
    80003dea:	5a7d                	li	s4,-1
    80003dec:	b7d5                	j	80003dd0 <filewrite+0xfa>
        panic("filewrite");
    80003dee:	00005517          	auipc	a0,0x5
    80003df2:	85250513          	addi	a0,a0,-1966 # 80008640 <syscalls+0x280>
    80003df6:	00002097          	auipc	ra,0x2
    80003dfa:	18c080e7          	jalr	396(ra) # 80005f82 <panic>
        return -1;
    80003dfe:	5a7d                	li	s4,-1
    80003e00:	bfc1                	j	80003dd0 <filewrite+0xfa>
            return -1;
    80003e02:	5a7d                	li	s4,-1
    80003e04:	b7f1                	j	80003dd0 <filewrite+0xfa>
    80003e06:	5a7d                	li	s4,-1
    80003e08:	b7e1                	j	80003dd0 <filewrite+0xfa>

0000000080003e0a <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003e0a:	7179                	addi	sp,sp,-48
    80003e0c:	f406                	sd	ra,40(sp)
    80003e0e:	f022                	sd	s0,32(sp)
    80003e10:	ec26                	sd	s1,24(sp)
    80003e12:	e84a                	sd	s2,16(sp)
    80003e14:	e44e                	sd	s3,8(sp)
    80003e16:	e052                	sd	s4,0(sp)
    80003e18:	1800                	addi	s0,sp,48
    80003e1a:	84aa                	mv	s1,a0
    80003e1c:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003e1e:	0005b023          	sd	zero,0(a1)
    80003e22:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003e26:	00000097          	auipc	ra,0x0
    80003e2a:	b9e080e7          	jalr	-1122(ra) # 800039c4 <filealloc>
    80003e2e:	e088                	sd	a0,0(s1)
    80003e30:	c551                	beqz	a0,80003ebc <pipealloc+0xb2>
    80003e32:	00000097          	auipc	ra,0x0
    80003e36:	b92080e7          	jalr	-1134(ra) # 800039c4 <filealloc>
    80003e3a:	00aa3023          	sd	a0,0(s4)
    80003e3e:	c92d                	beqz	a0,80003eb0 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003e40:	ffffc097          	auipc	ra,0xffffc
    80003e44:	2d8080e7          	jalr	728(ra) # 80000118 <kalloc>
    80003e48:	892a                	mv	s2,a0
    80003e4a:	c125                	beqz	a0,80003eaa <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003e4c:	4985                	li	s3,1
    80003e4e:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003e52:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003e56:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003e5a:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003e5e:	00004597          	auipc	a1,0x4
    80003e62:	7f258593          	addi	a1,a1,2034 # 80008650 <syscalls+0x290>
    80003e66:	00002097          	auipc	ra,0x2
    80003e6a:	5d6080e7          	jalr	1494(ra) # 8000643c <initlock>
  (*f0)->type = FD_PIPE;
    80003e6e:	609c                	ld	a5,0(s1)
    80003e70:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003e74:	609c                	ld	a5,0(s1)
    80003e76:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003e7a:	609c                	ld	a5,0(s1)
    80003e7c:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003e80:	609c                	ld	a5,0(s1)
    80003e82:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003e86:	000a3783          	ld	a5,0(s4)
    80003e8a:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003e8e:	000a3783          	ld	a5,0(s4)
    80003e92:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003e96:	000a3783          	ld	a5,0(s4)
    80003e9a:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003e9e:	000a3783          	ld	a5,0(s4)
    80003ea2:	0127b823          	sd	s2,16(a5)
  return 0;
    80003ea6:	4501                	li	a0,0
    80003ea8:	a025                	j	80003ed0 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003eaa:	6088                	ld	a0,0(s1)
    80003eac:	e501                	bnez	a0,80003eb4 <pipealloc+0xaa>
    80003eae:	a039                	j	80003ebc <pipealloc+0xb2>
    80003eb0:	6088                	ld	a0,0(s1)
    80003eb2:	c51d                	beqz	a0,80003ee0 <pipealloc+0xd6>
    fileclose(*f0);
    80003eb4:	00000097          	auipc	ra,0x0
    80003eb8:	bcc080e7          	jalr	-1076(ra) # 80003a80 <fileclose>
  if(*f1)
    80003ebc:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003ec0:	557d                	li	a0,-1
  if(*f1)
    80003ec2:	c799                	beqz	a5,80003ed0 <pipealloc+0xc6>
    fileclose(*f1);
    80003ec4:	853e                	mv	a0,a5
    80003ec6:	00000097          	auipc	ra,0x0
    80003eca:	bba080e7          	jalr	-1094(ra) # 80003a80 <fileclose>
  return -1;
    80003ece:	557d                	li	a0,-1
}
    80003ed0:	70a2                	ld	ra,40(sp)
    80003ed2:	7402                	ld	s0,32(sp)
    80003ed4:	64e2                	ld	s1,24(sp)
    80003ed6:	6942                	ld	s2,16(sp)
    80003ed8:	69a2                	ld	s3,8(sp)
    80003eda:	6a02                	ld	s4,0(sp)
    80003edc:	6145                	addi	sp,sp,48
    80003ede:	8082                	ret
  return -1;
    80003ee0:	557d                	li	a0,-1
    80003ee2:	b7fd                	j	80003ed0 <pipealloc+0xc6>

0000000080003ee4 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003ee4:	1101                	addi	sp,sp,-32
    80003ee6:	ec06                	sd	ra,24(sp)
    80003ee8:	e822                	sd	s0,16(sp)
    80003eea:	e426                	sd	s1,8(sp)
    80003eec:	e04a                	sd	s2,0(sp)
    80003eee:	1000                	addi	s0,sp,32
    80003ef0:	84aa                	mv	s1,a0
    80003ef2:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003ef4:	00002097          	auipc	ra,0x2
    80003ef8:	5d8080e7          	jalr	1496(ra) # 800064cc <acquire>
  if(writable){
    80003efc:	02090d63          	beqz	s2,80003f36 <pipeclose+0x52>
    pi->writeopen = 0;
    80003f00:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003f04:	21848513          	addi	a0,s1,536
    80003f08:	ffffd097          	auipc	ra,0xffffd
    80003f0c:	67e080e7          	jalr	1662(ra) # 80001586 <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003f10:	2204b783          	ld	a5,544(s1)
    80003f14:	eb95                	bnez	a5,80003f48 <pipeclose+0x64>
    release(&pi->lock);
    80003f16:	8526                	mv	a0,s1
    80003f18:	00002097          	auipc	ra,0x2
    80003f1c:	668080e7          	jalr	1640(ra) # 80006580 <release>
    kfree((char*)pi);
    80003f20:	8526                	mv	a0,s1
    80003f22:	ffffc097          	auipc	ra,0xffffc
    80003f26:	0fa080e7          	jalr	250(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003f2a:	60e2                	ld	ra,24(sp)
    80003f2c:	6442                	ld	s0,16(sp)
    80003f2e:	64a2                	ld	s1,8(sp)
    80003f30:	6902                	ld	s2,0(sp)
    80003f32:	6105                	addi	sp,sp,32
    80003f34:	8082                	ret
    pi->readopen = 0;
    80003f36:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003f3a:	21c48513          	addi	a0,s1,540
    80003f3e:	ffffd097          	auipc	ra,0xffffd
    80003f42:	648080e7          	jalr	1608(ra) # 80001586 <wakeup>
    80003f46:	b7e9                	j	80003f10 <pipeclose+0x2c>
    release(&pi->lock);
    80003f48:	8526                	mv	a0,s1
    80003f4a:	00002097          	auipc	ra,0x2
    80003f4e:	636080e7          	jalr	1590(ra) # 80006580 <release>
}
    80003f52:	bfe1                	j	80003f2a <pipeclose+0x46>

0000000080003f54 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003f54:	7159                	addi	sp,sp,-112
    80003f56:	f486                	sd	ra,104(sp)
    80003f58:	f0a2                	sd	s0,96(sp)
    80003f5a:	eca6                	sd	s1,88(sp)
    80003f5c:	e8ca                	sd	s2,80(sp)
    80003f5e:	e4ce                	sd	s3,72(sp)
    80003f60:	e0d2                	sd	s4,64(sp)
    80003f62:	fc56                	sd	s5,56(sp)
    80003f64:	f85a                	sd	s6,48(sp)
    80003f66:	f45e                	sd	s7,40(sp)
    80003f68:	f062                	sd	s8,32(sp)
    80003f6a:	ec66                	sd	s9,24(sp)
    80003f6c:	1880                	addi	s0,sp,112
    80003f6e:	84aa                	mv	s1,a0
    80003f70:	8aae                	mv	s5,a1
    80003f72:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003f74:	ffffd097          	auipc	ra,0xffffd
    80003f78:	eca080e7          	jalr	-310(ra) # 80000e3e <myproc>
    80003f7c:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003f7e:	8526                	mv	a0,s1
    80003f80:	00002097          	auipc	ra,0x2
    80003f84:	54c080e7          	jalr	1356(ra) # 800064cc <acquire>
  while(i < n){
    80003f88:	0d405463          	blez	s4,80004050 <pipewrite+0xfc>
    80003f8c:	8ba6                	mv	s7,s1
  int i = 0;
    80003f8e:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003f90:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003f92:	21848c93          	addi	s9,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003f96:	21c48c13          	addi	s8,s1,540
    80003f9a:	a08d                	j	80003ffc <pipewrite+0xa8>
      release(&pi->lock);
    80003f9c:	8526                	mv	a0,s1
    80003f9e:	00002097          	auipc	ra,0x2
    80003fa2:	5e2080e7          	jalr	1506(ra) # 80006580 <release>
      return -1;
    80003fa6:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003fa8:	854a                	mv	a0,s2
    80003faa:	70a6                	ld	ra,104(sp)
    80003fac:	7406                	ld	s0,96(sp)
    80003fae:	64e6                	ld	s1,88(sp)
    80003fb0:	6946                	ld	s2,80(sp)
    80003fb2:	69a6                	ld	s3,72(sp)
    80003fb4:	6a06                	ld	s4,64(sp)
    80003fb6:	7ae2                	ld	s5,56(sp)
    80003fb8:	7b42                	ld	s6,48(sp)
    80003fba:	7ba2                	ld	s7,40(sp)
    80003fbc:	7c02                	ld	s8,32(sp)
    80003fbe:	6ce2                	ld	s9,24(sp)
    80003fc0:	6165                	addi	sp,sp,112
    80003fc2:	8082                	ret
      wakeup(&pi->nread);
    80003fc4:	8566                	mv	a0,s9
    80003fc6:	ffffd097          	auipc	ra,0xffffd
    80003fca:	5c0080e7          	jalr	1472(ra) # 80001586 <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003fce:	85de                	mv	a1,s7
    80003fd0:	8562                	mv	a0,s8
    80003fd2:	ffffd097          	auipc	ra,0xffffd
    80003fd6:	550080e7          	jalr	1360(ra) # 80001522 <sleep>
    80003fda:	a839                	j	80003ff8 <pipewrite+0xa4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80003fdc:	21c4a783          	lw	a5,540(s1)
    80003fe0:	0017871b          	addiw	a4,a5,1
    80003fe4:	20e4ae23          	sw	a4,540(s1)
    80003fe8:	1ff7f793          	andi	a5,a5,511
    80003fec:	97a6                	add	a5,a5,s1
    80003fee:	f9f44703          	lbu	a4,-97(s0)
    80003ff2:	00e78c23          	sb	a4,24(a5)
      i++;
    80003ff6:	2905                	addiw	s2,s2,1
  while(i < n){
    80003ff8:	05495063          	bge	s2,s4,80004038 <pipewrite+0xe4>
    if(pi->readopen == 0 || killed(pr)){
    80003ffc:	2204a783          	lw	a5,544(s1)
    80004000:	dfd1                	beqz	a5,80003f9c <pipewrite+0x48>
    80004002:	854e                	mv	a0,s3
    80004004:	ffffd097          	auipc	ra,0xffffd
    80004008:	7c6080e7          	jalr	1990(ra) # 800017ca <killed>
    8000400c:	f941                	bnez	a0,80003f9c <pipewrite+0x48>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    8000400e:	2184a783          	lw	a5,536(s1)
    80004012:	21c4a703          	lw	a4,540(s1)
    80004016:	2007879b          	addiw	a5,a5,512
    8000401a:	faf705e3          	beq	a4,a5,80003fc4 <pipewrite+0x70>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000401e:	4685                	li	a3,1
    80004020:	01590633          	add	a2,s2,s5
    80004024:	f9f40593          	addi	a1,s0,-97
    80004028:	0509b503          	ld	a0,80(s3)
    8000402c:	ffffd097          	auipc	ra,0xffffd
    80004030:	b5c080e7          	jalr	-1188(ra) # 80000b88 <copyin>
    80004034:	fb6514e3          	bne	a0,s6,80003fdc <pipewrite+0x88>
  wakeup(&pi->nread);
    80004038:	21848513          	addi	a0,s1,536
    8000403c:	ffffd097          	auipc	ra,0xffffd
    80004040:	54a080e7          	jalr	1354(ra) # 80001586 <wakeup>
  release(&pi->lock);
    80004044:	8526                	mv	a0,s1
    80004046:	00002097          	auipc	ra,0x2
    8000404a:	53a080e7          	jalr	1338(ra) # 80006580 <release>
  return i;
    8000404e:	bfa9                	j	80003fa8 <pipewrite+0x54>
  int i = 0;
    80004050:	4901                	li	s2,0
    80004052:	b7dd                	j	80004038 <pipewrite+0xe4>

0000000080004054 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    80004054:	715d                	addi	sp,sp,-80
    80004056:	e486                	sd	ra,72(sp)
    80004058:	e0a2                	sd	s0,64(sp)
    8000405a:	fc26                	sd	s1,56(sp)
    8000405c:	f84a                	sd	s2,48(sp)
    8000405e:	f44e                	sd	s3,40(sp)
    80004060:	f052                	sd	s4,32(sp)
    80004062:	ec56                	sd	s5,24(sp)
    80004064:	e85a                	sd	s6,16(sp)
    80004066:	0880                	addi	s0,sp,80
    80004068:	84aa                	mv	s1,a0
    8000406a:	892e                	mv	s2,a1
    8000406c:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    8000406e:	ffffd097          	auipc	ra,0xffffd
    80004072:	dd0080e7          	jalr	-560(ra) # 80000e3e <myproc>
    80004076:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    80004078:	8b26                	mv	s6,s1
    8000407a:	8526                	mv	a0,s1
    8000407c:	00002097          	auipc	ra,0x2
    80004080:	450080e7          	jalr	1104(ra) # 800064cc <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004084:	2184a703          	lw	a4,536(s1)
    80004088:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000408c:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004090:	02f71763          	bne	a4,a5,800040be <piperead+0x6a>
    80004094:	2244a783          	lw	a5,548(s1)
    80004098:	c39d                	beqz	a5,800040be <piperead+0x6a>
    if(killed(pr)){
    8000409a:	8552                	mv	a0,s4
    8000409c:	ffffd097          	auipc	ra,0xffffd
    800040a0:	72e080e7          	jalr	1838(ra) # 800017ca <killed>
    800040a4:	e941                	bnez	a0,80004134 <piperead+0xe0>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800040a6:	85da                	mv	a1,s6
    800040a8:	854e                	mv	a0,s3
    800040aa:	ffffd097          	auipc	ra,0xffffd
    800040ae:	478080e7          	jalr	1144(ra) # 80001522 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800040b2:	2184a703          	lw	a4,536(s1)
    800040b6:	21c4a783          	lw	a5,540(s1)
    800040ba:	fcf70de3          	beq	a4,a5,80004094 <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800040be:	09505263          	blez	s5,80004142 <piperead+0xee>
    800040c2:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800040c4:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    800040c6:	2184a783          	lw	a5,536(s1)
    800040ca:	21c4a703          	lw	a4,540(s1)
    800040ce:	02f70d63          	beq	a4,a5,80004108 <piperead+0xb4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800040d2:	0017871b          	addiw	a4,a5,1
    800040d6:	20e4ac23          	sw	a4,536(s1)
    800040da:	1ff7f793          	andi	a5,a5,511
    800040de:	97a6                	add	a5,a5,s1
    800040e0:	0187c783          	lbu	a5,24(a5)
    800040e4:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800040e8:	4685                	li	a3,1
    800040ea:	fbf40613          	addi	a2,s0,-65
    800040ee:	85ca                	mv	a1,s2
    800040f0:	050a3503          	ld	a0,80(s4)
    800040f4:	ffffd097          	auipc	ra,0xffffd
    800040f8:	a08080e7          	jalr	-1528(ra) # 80000afc <copyout>
    800040fc:	01650663          	beq	a0,s6,80004108 <piperead+0xb4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004100:	2985                	addiw	s3,s3,1
    80004102:	0905                	addi	s2,s2,1
    80004104:	fd3a91e3          	bne	s5,s3,800040c6 <piperead+0x72>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004108:	21c48513          	addi	a0,s1,540
    8000410c:	ffffd097          	auipc	ra,0xffffd
    80004110:	47a080e7          	jalr	1146(ra) # 80001586 <wakeup>
  release(&pi->lock);
    80004114:	8526                	mv	a0,s1
    80004116:	00002097          	auipc	ra,0x2
    8000411a:	46a080e7          	jalr	1130(ra) # 80006580 <release>
  return i;
}
    8000411e:	854e                	mv	a0,s3
    80004120:	60a6                	ld	ra,72(sp)
    80004122:	6406                	ld	s0,64(sp)
    80004124:	74e2                	ld	s1,56(sp)
    80004126:	7942                	ld	s2,48(sp)
    80004128:	79a2                	ld	s3,40(sp)
    8000412a:	7a02                	ld	s4,32(sp)
    8000412c:	6ae2                	ld	s5,24(sp)
    8000412e:	6b42                	ld	s6,16(sp)
    80004130:	6161                	addi	sp,sp,80
    80004132:	8082                	ret
      release(&pi->lock);
    80004134:	8526                	mv	a0,s1
    80004136:	00002097          	auipc	ra,0x2
    8000413a:	44a080e7          	jalr	1098(ra) # 80006580 <release>
      return -1;
    8000413e:	59fd                	li	s3,-1
    80004140:	bff9                	j	8000411e <piperead+0xca>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004142:	4981                	li	s3,0
    80004144:	b7d1                	j	80004108 <piperead+0xb4>

0000000080004146 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    80004146:	1141                	addi	sp,sp,-16
    80004148:	e422                	sd	s0,8(sp)
    8000414a:	0800                	addi	s0,sp,16
    8000414c:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    8000414e:	8905                	andi	a0,a0,1
    80004150:	c111                	beqz	a0,80004154 <flags2perm+0xe>
      perm = PTE_X;
    80004152:	4521                	li	a0,8
    if(flags & 0x2)
    80004154:	8b89                	andi	a5,a5,2
    80004156:	c399                	beqz	a5,8000415c <flags2perm+0x16>
      perm |= PTE_W;
    80004158:	00456513          	ori	a0,a0,4
    return perm;
}
    8000415c:	6422                	ld	s0,8(sp)
    8000415e:	0141                	addi	sp,sp,16
    80004160:	8082                	ret

0000000080004162 <exec>:

int
exec(char *path, char **argv)
{
    80004162:	df010113          	addi	sp,sp,-528
    80004166:	20113423          	sd	ra,520(sp)
    8000416a:	20813023          	sd	s0,512(sp)
    8000416e:	ffa6                	sd	s1,504(sp)
    80004170:	fbca                	sd	s2,496(sp)
    80004172:	f7ce                	sd	s3,488(sp)
    80004174:	f3d2                	sd	s4,480(sp)
    80004176:	efd6                	sd	s5,472(sp)
    80004178:	ebda                	sd	s6,464(sp)
    8000417a:	e7de                	sd	s7,456(sp)
    8000417c:	e3e2                	sd	s8,448(sp)
    8000417e:	ff66                	sd	s9,440(sp)
    80004180:	fb6a                	sd	s10,432(sp)
    80004182:	f76e                	sd	s11,424(sp)
    80004184:	0c00                	addi	s0,sp,528
    80004186:	84aa                	mv	s1,a0
    80004188:	dea43c23          	sd	a0,-520(s0)
    8000418c:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004190:	ffffd097          	auipc	ra,0xffffd
    80004194:	cae080e7          	jalr	-850(ra) # 80000e3e <myproc>
    80004198:	892a                	mv	s2,a0

  begin_op();
    8000419a:	fffff097          	auipc	ra,0xfffff
    8000419e:	41a080e7          	jalr	1050(ra) # 800035b4 <begin_op>

  if((ip = namei(path)) == 0){
    800041a2:	8526                	mv	a0,s1
    800041a4:	fffff097          	auipc	ra,0xfffff
    800041a8:	1f4080e7          	jalr	500(ra) # 80003398 <namei>
    800041ac:	c92d                	beqz	a0,8000421e <exec+0xbc>
    800041ae:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800041b0:	fffff097          	auipc	ra,0xfffff
    800041b4:	a42080e7          	jalr	-1470(ra) # 80002bf2 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800041b8:	04000713          	li	a4,64
    800041bc:	4681                	li	a3,0
    800041be:	e5040613          	addi	a2,s0,-432
    800041c2:	4581                	li	a1,0
    800041c4:	8526                	mv	a0,s1
    800041c6:	fffff097          	auipc	ra,0xfffff
    800041ca:	ce0080e7          	jalr	-800(ra) # 80002ea6 <readi>
    800041ce:	04000793          	li	a5,64
    800041d2:	00f51a63          	bne	a0,a5,800041e6 <exec+0x84>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    800041d6:	e5042703          	lw	a4,-432(s0)
    800041da:	464c47b7          	lui	a5,0x464c4
    800041de:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    800041e2:	04f70463          	beq	a4,a5,8000422a <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    800041e6:	8526                	mv	a0,s1
    800041e8:	fffff097          	auipc	ra,0xfffff
    800041ec:	c6c080e7          	jalr	-916(ra) # 80002e54 <iunlockput>
    end_op();
    800041f0:	fffff097          	auipc	ra,0xfffff
    800041f4:	444080e7          	jalr	1092(ra) # 80003634 <end_op>
  }
  return -1;
    800041f8:	557d                	li	a0,-1
}
    800041fa:	20813083          	ld	ra,520(sp)
    800041fe:	20013403          	ld	s0,512(sp)
    80004202:	74fe                	ld	s1,504(sp)
    80004204:	795e                	ld	s2,496(sp)
    80004206:	79be                	ld	s3,488(sp)
    80004208:	7a1e                	ld	s4,480(sp)
    8000420a:	6afe                	ld	s5,472(sp)
    8000420c:	6b5e                	ld	s6,464(sp)
    8000420e:	6bbe                	ld	s7,456(sp)
    80004210:	6c1e                	ld	s8,448(sp)
    80004212:	7cfa                	ld	s9,440(sp)
    80004214:	7d5a                	ld	s10,432(sp)
    80004216:	7dba                	ld	s11,424(sp)
    80004218:	21010113          	addi	sp,sp,528
    8000421c:	8082                	ret
    end_op();
    8000421e:	fffff097          	auipc	ra,0xfffff
    80004222:	416080e7          	jalr	1046(ra) # 80003634 <end_op>
    return -1;
    80004226:	557d                	li	a0,-1
    80004228:	bfc9                	j	800041fa <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    8000422a:	854a                	mv	a0,s2
    8000422c:	ffffd097          	auipc	ra,0xffffd
    80004230:	cd6080e7          	jalr	-810(ra) # 80000f02 <proc_pagetable>
    80004234:	8baa                	mv	s7,a0
    80004236:	d945                	beqz	a0,800041e6 <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004238:	e7042983          	lw	s3,-400(s0)
    8000423c:	e8845783          	lhu	a5,-376(s0)
    80004240:	c7ad                	beqz	a5,800042aa <exec+0x148>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    80004242:	4a01                	li	s4,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004244:	4b01                	li	s6,0
    if(ph.vaddr % PGSIZE != 0)
    80004246:	6c85                	lui	s9,0x1
    80004248:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    8000424c:	def43823          	sd	a5,-528(s0)
    80004250:	ac0d                	j	80004482 <exec+0x320>
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    80004252:	00004517          	auipc	a0,0x4
    80004256:	40650513          	addi	a0,a0,1030 # 80008658 <syscalls+0x298>
    8000425a:	00002097          	auipc	ra,0x2
    8000425e:	d28080e7          	jalr	-728(ra) # 80005f82 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    80004262:	8756                	mv	a4,s5
    80004264:	012d86bb          	addw	a3,s11,s2
    80004268:	4581                	li	a1,0
    8000426a:	8526                	mv	a0,s1
    8000426c:	fffff097          	auipc	ra,0xfffff
    80004270:	c3a080e7          	jalr	-966(ra) # 80002ea6 <readi>
    80004274:	2501                	sext.w	a0,a0
    80004276:	1aaa9a63          	bne	s5,a0,8000442a <exec+0x2c8>
  for(i = 0; i < sz; i += PGSIZE){
    8000427a:	6785                	lui	a5,0x1
    8000427c:	0127893b          	addw	s2,a5,s2
    80004280:	77fd                	lui	a5,0xfffff
    80004282:	01478a3b          	addw	s4,a5,s4
    80004286:	1f897563          	bgeu	s2,s8,80004470 <exec+0x30e>
    pa = walkaddr(pagetable, va + i);
    8000428a:	02091593          	slli	a1,s2,0x20
    8000428e:	9181                	srli	a1,a1,0x20
    80004290:	95ea                	add	a1,a1,s10
    80004292:	855e                	mv	a0,s7
    80004294:	ffffc097          	auipc	ra,0xffffc
    80004298:	276080e7          	jalr	630(ra) # 8000050a <walkaddr>
    8000429c:	862a                	mv	a2,a0
    if(pa == 0)
    8000429e:	d955                	beqz	a0,80004252 <exec+0xf0>
      n = PGSIZE;
    800042a0:	8ae6                	mv	s5,s9
    if(sz - i < PGSIZE)
    800042a2:	fd9a70e3          	bgeu	s4,s9,80004262 <exec+0x100>
      n = sz - i;
    800042a6:	8ad2                	mv	s5,s4
    800042a8:	bf6d                	j	80004262 <exec+0x100>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800042aa:	4a01                	li	s4,0
  iunlockput(ip);
    800042ac:	8526                	mv	a0,s1
    800042ae:	fffff097          	auipc	ra,0xfffff
    800042b2:	ba6080e7          	jalr	-1114(ra) # 80002e54 <iunlockput>
  end_op();
    800042b6:	fffff097          	auipc	ra,0xfffff
    800042ba:	37e080e7          	jalr	894(ra) # 80003634 <end_op>
  p = myproc();
    800042be:	ffffd097          	auipc	ra,0xffffd
    800042c2:	b80080e7          	jalr	-1152(ra) # 80000e3e <myproc>
    800042c6:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    800042c8:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    800042cc:	6785                	lui	a5,0x1
    800042ce:	17fd                	addi	a5,a5,-1
    800042d0:	9a3e                	add	s4,s4,a5
    800042d2:	757d                	lui	a0,0xfffff
    800042d4:	00aa77b3          	and	a5,s4,a0
    800042d8:	e0f43423          	sd	a5,-504(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    800042dc:	4691                	li	a3,4
    800042de:	6609                	lui	a2,0x2
    800042e0:	963e                	add	a2,a2,a5
    800042e2:	85be                	mv	a1,a5
    800042e4:	855e                	mv	a0,s7
    800042e6:	ffffc097          	auipc	ra,0xffffc
    800042ea:	5ca080e7          	jalr	1482(ra) # 800008b0 <uvmalloc>
    800042ee:	8b2a                	mv	s6,a0
  ip = 0;
    800042f0:	4481                	li	s1,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    800042f2:	12050c63          	beqz	a0,8000442a <exec+0x2c8>
  uvmclear(pagetable, sz-2*PGSIZE);
    800042f6:	75f9                	lui	a1,0xffffe
    800042f8:	95aa                	add	a1,a1,a0
    800042fa:	855e                	mv	a0,s7
    800042fc:	ffffc097          	auipc	ra,0xffffc
    80004300:	7ce080e7          	jalr	1998(ra) # 80000aca <uvmclear>
  stackbase = sp - PGSIZE;
    80004304:	7c7d                	lui	s8,0xfffff
    80004306:	9c5a                	add	s8,s8,s6
  for(argc = 0; argv[argc]; argc++) {
    80004308:	e0043783          	ld	a5,-512(s0)
    8000430c:	6388                	ld	a0,0(a5)
    8000430e:	c535                	beqz	a0,8000437a <exec+0x218>
    80004310:	e9040993          	addi	s3,s0,-368
    80004314:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    80004318:	895a                	mv	s2,s6
    sp -= strlen(argv[argc]) + 1;
    8000431a:	ffffc097          	auipc	ra,0xffffc
    8000431e:	fe2080e7          	jalr	-30(ra) # 800002fc <strlen>
    80004322:	2505                	addiw	a0,a0,1
    80004324:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004328:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    8000432c:	13896663          	bltu	s2,s8,80004458 <exec+0x2f6>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004330:	e0043d83          	ld	s11,-512(s0)
    80004334:	000dba03          	ld	s4,0(s11)
    80004338:	8552                	mv	a0,s4
    8000433a:	ffffc097          	auipc	ra,0xffffc
    8000433e:	fc2080e7          	jalr	-62(ra) # 800002fc <strlen>
    80004342:	0015069b          	addiw	a3,a0,1
    80004346:	8652                	mv	a2,s4
    80004348:	85ca                	mv	a1,s2
    8000434a:	855e                	mv	a0,s7
    8000434c:	ffffc097          	auipc	ra,0xffffc
    80004350:	7b0080e7          	jalr	1968(ra) # 80000afc <copyout>
    80004354:	10054663          	bltz	a0,80004460 <exec+0x2fe>
    ustack[argc] = sp;
    80004358:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    8000435c:	0485                	addi	s1,s1,1
    8000435e:	008d8793          	addi	a5,s11,8
    80004362:	e0f43023          	sd	a5,-512(s0)
    80004366:	008db503          	ld	a0,8(s11)
    8000436a:	c911                	beqz	a0,8000437e <exec+0x21c>
    if(argc >= MAXARG)
    8000436c:	09a1                	addi	s3,s3,8
    8000436e:	fb3c96e3          	bne	s9,s3,8000431a <exec+0x1b8>
  sz = sz1;
    80004372:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004376:	4481                	li	s1,0
    80004378:	a84d                	j	8000442a <exec+0x2c8>
  sp = sz;
    8000437a:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    8000437c:	4481                	li	s1,0
  ustack[argc] = 0;
    8000437e:	00349793          	slli	a5,s1,0x3
    80004382:	f9040713          	addi	a4,s0,-112
    80004386:	97ba                	add	a5,a5,a4
    80004388:	f007b023          	sd	zero,-256(a5) # f00 <_entry-0x7ffff100>
  sp -= (argc+1) * sizeof(uint64);
    8000438c:	00148693          	addi	a3,s1,1
    80004390:	068e                	slli	a3,a3,0x3
    80004392:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004396:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    8000439a:	01897663          	bgeu	s2,s8,800043a6 <exec+0x244>
  sz = sz1;
    8000439e:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800043a2:	4481                	li	s1,0
    800043a4:	a059                	j	8000442a <exec+0x2c8>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800043a6:	e9040613          	addi	a2,s0,-368
    800043aa:	85ca                	mv	a1,s2
    800043ac:	855e                	mv	a0,s7
    800043ae:	ffffc097          	auipc	ra,0xffffc
    800043b2:	74e080e7          	jalr	1870(ra) # 80000afc <copyout>
    800043b6:	0a054963          	bltz	a0,80004468 <exec+0x306>
  p->trapframe->a1 = sp;
    800043ba:	058ab783          	ld	a5,88(s5)
    800043be:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800043c2:	df843783          	ld	a5,-520(s0)
    800043c6:	0007c703          	lbu	a4,0(a5)
    800043ca:	cf11                	beqz	a4,800043e6 <exec+0x284>
    800043cc:	0785                	addi	a5,a5,1
    if(*s == '/')
    800043ce:	02f00693          	li	a3,47
    800043d2:	a039                	j	800043e0 <exec+0x27e>
      last = s+1;
    800043d4:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    800043d8:	0785                	addi	a5,a5,1
    800043da:	fff7c703          	lbu	a4,-1(a5)
    800043de:	c701                	beqz	a4,800043e6 <exec+0x284>
    if(*s == '/')
    800043e0:	fed71ce3          	bne	a4,a3,800043d8 <exec+0x276>
    800043e4:	bfc5                	j	800043d4 <exec+0x272>
  safestrcpy(p->name, last, sizeof(p->name));
    800043e6:	4641                	li	a2,16
    800043e8:	df843583          	ld	a1,-520(s0)
    800043ec:	158a8513          	addi	a0,s5,344
    800043f0:	ffffc097          	auipc	ra,0xffffc
    800043f4:	eda080e7          	jalr	-294(ra) # 800002ca <safestrcpy>
  oldpagetable = p->pagetable;
    800043f8:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    800043fc:	057ab823          	sd	s7,80(s5)
  p->sz = sz;
    80004400:	056ab423          	sd	s6,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004404:	058ab783          	ld	a5,88(s5)
    80004408:	e6843703          	ld	a4,-408(s0)
    8000440c:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    8000440e:	058ab783          	ld	a5,88(s5)
    80004412:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004416:	85ea                	mv	a1,s10
    80004418:	ffffd097          	auipc	ra,0xffffd
    8000441c:	b86080e7          	jalr	-1146(ra) # 80000f9e <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004420:	0004851b          	sext.w	a0,s1
    80004424:	bbd9                	j	800041fa <exec+0x98>
    80004426:	e1443423          	sd	s4,-504(s0)
    proc_freepagetable(pagetable, sz);
    8000442a:	e0843583          	ld	a1,-504(s0)
    8000442e:	855e                	mv	a0,s7
    80004430:	ffffd097          	auipc	ra,0xffffd
    80004434:	b6e080e7          	jalr	-1170(ra) # 80000f9e <proc_freepagetable>
  if(ip){
    80004438:	da0497e3          	bnez	s1,800041e6 <exec+0x84>
  return -1;
    8000443c:	557d                	li	a0,-1
    8000443e:	bb75                	j	800041fa <exec+0x98>
    80004440:	e1443423          	sd	s4,-504(s0)
    80004444:	b7dd                	j	8000442a <exec+0x2c8>
    80004446:	e1443423          	sd	s4,-504(s0)
    8000444a:	b7c5                	j	8000442a <exec+0x2c8>
    8000444c:	e1443423          	sd	s4,-504(s0)
    80004450:	bfe9                	j	8000442a <exec+0x2c8>
    80004452:	e1443423          	sd	s4,-504(s0)
    80004456:	bfd1                	j	8000442a <exec+0x2c8>
  sz = sz1;
    80004458:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    8000445c:	4481                	li	s1,0
    8000445e:	b7f1                	j	8000442a <exec+0x2c8>
  sz = sz1;
    80004460:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004464:	4481                	li	s1,0
    80004466:	b7d1                	j	8000442a <exec+0x2c8>
  sz = sz1;
    80004468:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    8000446c:	4481                	li	s1,0
    8000446e:	bf75                	j	8000442a <exec+0x2c8>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004470:	e0843a03          	ld	s4,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004474:	2b05                	addiw	s6,s6,1
    80004476:	0389899b          	addiw	s3,s3,56
    8000447a:	e8845783          	lhu	a5,-376(s0)
    8000447e:	e2fb57e3          	bge	s6,a5,800042ac <exec+0x14a>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004482:	2981                	sext.w	s3,s3
    80004484:	03800713          	li	a4,56
    80004488:	86ce                	mv	a3,s3
    8000448a:	e1840613          	addi	a2,s0,-488
    8000448e:	4581                	li	a1,0
    80004490:	8526                	mv	a0,s1
    80004492:	fffff097          	auipc	ra,0xfffff
    80004496:	a14080e7          	jalr	-1516(ra) # 80002ea6 <readi>
    8000449a:	03800793          	li	a5,56
    8000449e:	f8f514e3          	bne	a0,a5,80004426 <exec+0x2c4>
    if(ph.type != ELF_PROG_LOAD)
    800044a2:	e1842783          	lw	a5,-488(s0)
    800044a6:	4705                	li	a4,1
    800044a8:	fce796e3          	bne	a5,a4,80004474 <exec+0x312>
    if(ph.memsz < ph.filesz)
    800044ac:	e4043903          	ld	s2,-448(s0)
    800044b0:	e3843783          	ld	a5,-456(s0)
    800044b4:	f8f966e3          	bltu	s2,a5,80004440 <exec+0x2de>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800044b8:	e2843783          	ld	a5,-472(s0)
    800044bc:	993e                	add	s2,s2,a5
    800044be:	f8f964e3          	bltu	s2,a5,80004446 <exec+0x2e4>
    if(ph.vaddr % PGSIZE != 0)
    800044c2:	df043703          	ld	a4,-528(s0)
    800044c6:	8ff9                	and	a5,a5,a4
    800044c8:	f3d1                	bnez	a5,8000444c <exec+0x2ea>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800044ca:	e1c42503          	lw	a0,-484(s0)
    800044ce:	00000097          	auipc	ra,0x0
    800044d2:	c78080e7          	jalr	-904(ra) # 80004146 <flags2perm>
    800044d6:	86aa                	mv	a3,a0
    800044d8:	864a                	mv	a2,s2
    800044da:	85d2                	mv	a1,s4
    800044dc:	855e                	mv	a0,s7
    800044de:	ffffc097          	auipc	ra,0xffffc
    800044e2:	3d2080e7          	jalr	978(ra) # 800008b0 <uvmalloc>
    800044e6:	e0a43423          	sd	a0,-504(s0)
    800044ea:	d525                	beqz	a0,80004452 <exec+0x2f0>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    800044ec:	e2843d03          	ld	s10,-472(s0)
    800044f0:	e2042d83          	lw	s11,-480(s0)
    800044f4:	e3842c03          	lw	s8,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    800044f8:	f60c0ce3          	beqz	s8,80004470 <exec+0x30e>
    800044fc:	8a62                	mv	s4,s8
    800044fe:	4901                	li	s2,0
    80004500:	b369                	j	8000428a <exec+0x128>

0000000080004502 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004502:	7179                	addi	sp,sp,-48
    80004504:	f406                	sd	ra,40(sp)
    80004506:	f022                	sd	s0,32(sp)
    80004508:	ec26                	sd	s1,24(sp)
    8000450a:	e84a                	sd	s2,16(sp)
    8000450c:	1800                	addi	s0,sp,48
    8000450e:	892e                	mv	s2,a1
    80004510:	84b2                	mv	s1,a2
    int fd;
    struct file *f;

    argint(n, &fd);
    80004512:	fdc40593          	addi	a1,s0,-36
    80004516:	ffffe097          	auipc	ra,0xffffe
    8000451a:	b62080e7          	jalr	-1182(ra) # 80002078 <argint>
    if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0)
    8000451e:	fdc42703          	lw	a4,-36(s0)
    80004522:	47bd                	li	a5,15
    80004524:	02e7eb63          	bltu	a5,a4,8000455a <argfd+0x58>
    80004528:	ffffd097          	auipc	ra,0xffffd
    8000452c:	916080e7          	jalr	-1770(ra) # 80000e3e <myproc>
    80004530:	fdc42703          	lw	a4,-36(s0)
    80004534:	01a70793          	addi	a5,a4,26
    80004538:	078e                	slli	a5,a5,0x3
    8000453a:	953e                	add	a0,a0,a5
    8000453c:	611c                	ld	a5,0(a0)
    8000453e:	c385                	beqz	a5,8000455e <argfd+0x5c>
        return -1;
    if (pfd)
    80004540:	00090463          	beqz	s2,80004548 <argfd+0x46>
        *pfd = fd;
    80004544:	00e92023          	sw	a4,0(s2)
    if (pf)
        *pf = f;
    return 0;
    80004548:	4501                	li	a0,0
    if (pf)
    8000454a:	c091                	beqz	s1,8000454e <argfd+0x4c>
        *pf = f;
    8000454c:	e09c                	sd	a5,0(s1)
}
    8000454e:	70a2                	ld	ra,40(sp)
    80004550:	7402                	ld	s0,32(sp)
    80004552:	64e2                	ld	s1,24(sp)
    80004554:	6942                	ld	s2,16(sp)
    80004556:	6145                	addi	sp,sp,48
    80004558:	8082                	ret
        return -1;
    8000455a:	557d                	li	a0,-1
    8000455c:	bfcd                	j	8000454e <argfd+0x4c>
    8000455e:	557d                	li	a0,-1
    80004560:	b7fd                	j	8000454e <argfd+0x4c>

0000000080004562 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    80004562:	1101                	addi	sp,sp,-32
    80004564:	ec06                	sd	ra,24(sp)
    80004566:	e822                	sd	s0,16(sp)
    80004568:	e426                	sd	s1,8(sp)
    8000456a:	1000                	addi	s0,sp,32
    8000456c:	84aa                	mv	s1,a0
    int fd;
    struct proc *p = myproc();
    8000456e:	ffffd097          	auipc	ra,0xffffd
    80004572:	8d0080e7          	jalr	-1840(ra) # 80000e3e <myproc>
    80004576:	862a                	mv	a2,a0

    for (fd = 0; fd < NOFILE; fd++)
    80004578:	0d050793          	addi	a5,a0,208 # fffffffffffff0d0 <end+0xffffffff7ffcb360>
    8000457c:	4501                	li	a0,0
    8000457e:	46c1                	li	a3,16
    {
        if (p->ofile[fd] == 0)
    80004580:	6398                	ld	a4,0(a5)
    80004582:	cb19                	beqz	a4,80004598 <fdalloc+0x36>
    for (fd = 0; fd < NOFILE; fd++)
    80004584:	2505                	addiw	a0,a0,1
    80004586:	07a1                	addi	a5,a5,8
    80004588:	fed51ce3          	bne	a0,a3,80004580 <fdalloc+0x1e>
        {
            p->ofile[fd] = f;
            return fd;
        }
    }
    return -1;
    8000458c:	557d                	li	a0,-1
}
    8000458e:	60e2                	ld	ra,24(sp)
    80004590:	6442                	ld	s0,16(sp)
    80004592:	64a2                	ld	s1,8(sp)
    80004594:	6105                	addi	sp,sp,32
    80004596:	8082                	ret
            p->ofile[fd] = f;
    80004598:	01a50793          	addi	a5,a0,26
    8000459c:	078e                	slli	a5,a5,0x3
    8000459e:	963e                	add	a2,a2,a5
    800045a0:	e204                	sd	s1,0(a2)
            return fd;
    800045a2:	b7f5                	j	8000458e <fdalloc+0x2c>

00000000800045a4 <create>:
    }
}

static struct inode *
create(char *path, short type, short major, short minor)
{
    800045a4:	715d                	addi	sp,sp,-80
    800045a6:	e486                	sd	ra,72(sp)
    800045a8:	e0a2                	sd	s0,64(sp)
    800045aa:	fc26                	sd	s1,56(sp)
    800045ac:	f84a                	sd	s2,48(sp)
    800045ae:	f44e                	sd	s3,40(sp)
    800045b0:	f052                	sd	s4,32(sp)
    800045b2:	ec56                	sd	s5,24(sp)
    800045b4:	e85a                	sd	s6,16(sp)
    800045b6:	0880                	addi	s0,sp,80
    800045b8:	8b2e                	mv	s6,a1
    800045ba:	89b2                	mv	s3,a2
    800045bc:	8936                	mv	s2,a3
    struct inode *ip, *dp;
    char name[DIRSIZ];

    if ((dp = nameiparent(path, name)) == 0)
    800045be:	fb040593          	addi	a1,s0,-80
    800045c2:	fffff097          	auipc	ra,0xfffff
    800045c6:	df4080e7          	jalr	-524(ra) # 800033b6 <nameiparent>
    800045ca:	84aa                	mv	s1,a0
    800045cc:	16050063          	beqz	a0,8000472c <create+0x188>
        return 0;

    ilock(dp);
    800045d0:	ffffe097          	auipc	ra,0xffffe
    800045d4:	622080e7          	jalr	1570(ra) # 80002bf2 <ilock>

    if ((ip = dirlookup(dp, name, 0)) != 0)
    800045d8:	4601                	li	a2,0
    800045da:	fb040593          	addi	a1,s0,-80
    800045de:	8526                	mv	a0,s1
    800045e0:	fffff097          	auipc	ra,0xfffff
    800045e4:	af6080e7          	jalr	-1290(ra) # 800030d6 <dirlookup>
    800045e8:	8aaa                	mv	s5,a0
    800045ea:	c931                	beqz	a0,8000463e <create+0x9a>
    {
        iunlockput(dp);
    800045ec:	8526                	mv	a0,s1
    800045ee:	fffff097          	auipc	ra,0xfffff
    800045f2:	866080e7          	jalr	-1946(ra) # 80002e54 <iunlockput>
        ilock(ip);
    800045f6:	8556                	mv	a0,s5
    800045f8:	ffffe097          	auipc	ra,0xffffe
    800045fc:	5fa080e7          	jalr	1530(ra) # 80002bf2 <ilock>
        if (type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004600:	000b059b          	sext.w	a1,s6
    80004604:	4789                	li	a5,2
    80004606:	02f59563          	bne	a1,a5,80004630 <create+0x8c>
    8000460a:	044ad783          	lhu	a5,68(s5)
    8000460e:	37f9                	addiw	a5,a5,-2
    80004610:	17c2                	slli	a5,a5,0x30
    80004612:	93c1                	srli	a5,a5,0x30
    80004614:	4705                	li	a4,1
    80004616:	00f76d63          	bltu	a4,a5,80004630 <create+0x8c>
    ip->nlink = 0;
    iupdate(ip);
    iunlockput(ip);
    iunlockput(dp);
    return 0;
}
    8000461a:	8556                	mv	a0,s5
    8000461c:	60a6                	ld	ra,72(sp)
    8000461e:	6406                	ld	s0,64(sp)
    80004620:	74e2                	ld	s1,56(sp)
    80004622:	7942                	ld	s2,48(sp)
    80004624:	79a2                	ld	s3,40(sp)
    80004626:	7a02                	ld	s4,32(sp)
    80004628:	6ae2                	ld	s5,24(sp)
    8000462a:	6b42                	ld	s6,16(sp)
    8000462c:	6161                	addi	sp,sp,80
    8000462e:	8082                	ret
        iunlockput(ip);
    80004630:	8556                	mv	a0,s5
    80004632:	fffff097          	auipc	ra,0xfffff
    80004636:	822080e7          	jalr	-2014(ra) # 80002e54 <iunlockput>
        return 0;
    8000463a:	4a81                	li	s5,0
    8000463c:	bff9                	j	8000461a <create+0x76>
    if ((ip = ialloc(dp->dev, type)) == 0)
    8000463e:	85da                	mv	a1,s6
    80004640:	4088                	lw	a0,0(s1)
    80004642:	ffffe097          	auipc	ra,0xffffe
    80004646:	414080e7          	jalr	1044(ra) # 80002a56 <ialloc>
    8000464a:	8a2a                	mv	s4,a0
    8000464c:	c921                	beqz	a0,8000469c <create+0xf8>
    ilock(ip);
    8000464e:	ffffe097          	auipc	ra,0xffffe
    80004652:	5a4080e7          	jalr	1444(ra) # 80002bf2 <ilock>
    ip->major = major;
    80004656:	053a1323          	sh	s3,70(s4)
    ip->minor = minor;
    8000465a:	052a1423          	sh	s2,72(s4)
    ip->nlink = 1;
    8000465e:	4785                	li	a5,1
    80004660:	04fa1523          	sh	a5,74(s4)
    iupdate(ip);
    80004664:	8552                	mv	a0,s4
    80004666:	ffffe097          	auipc	ra,0xffffe
    8000466a:	4c2080e7          	jalr	1218(ra) # 80002b28 <iupdate>
    if (type == T_DIR)
    8000466e:	000b059b          	sext.w	a1,s6
    80004672:	4785                	li	a5,1
    80004674:	02f58b63          	beq	a1,a5,800046aa <create+0x106>
    if (dirlink(dp, name, ip->inum) < 0)
    80004678:	004a2603          	lw	a2,4(s4)
    8000467c:	fb040593          	addi	a1,s0,-80
    80004680:	8526                	mv	a0,s1
    80004682:	fffff097          	auipc	ra,0xfffff
    80004686:	c64080e7          	jalr	-924(ra) # 800032e6 <dirlink>
    8000468a:	06054f63          	bltz	a0,80004708 <create+0x164>
    iunlockput(dp);
    8000468e:	8526                	mv	a0,s1
    80004690:	ffffe097          	auipc	ra,0xffffe
    80004694:	7c4080e7          	jalr	1988(ra) # 80002e54 <iunlockput>
    return ip;
    80004698:	8ad2                	mv	s5,s4
    8000469a:	b741                	j	8000461a <create+0x76>
        iunlockput(dp);
    8000469c:	8526                	mv	a0,s1
    8000469e:	ffffe097          	auipc	ra,0xffffe
    800046a2:	7b6080e7          	jalr	1974(ra) # 80002e54 <iunlockput>
        return 0;
    800046a6:	8ad2                	mv	s5,s4
    800046a8:	bf8d                	j	8000461a <create+0x76>
        if (dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800046aa:	004a2603          	lw	a2,4(s4)
    800046ae:	00004597          	auipc	a1,0x4
    800046b2:	fca58593          	addi	a1,a1,-54 # 80008678 <syscalls+0x2b8>
    800046b6:	8552                	mv	a0,s4
    800046b8:	fffff097          	auipc	ra,0xfffff
    800046bc:	c2e080e7          	jalr	-978(ra) # 800032e6 <dirlink>
    800046c0:	04054463          	bltz	a0,80004708 <create+0x164>
    800046c4:	40d0                	lw	a2,4(s1)
    800046c6:	00004597          	auipc	a1,0x4
    800046ca:	fba58593          	addi	a1,a1,-70 # 80008680 <syscalls+0x2c0>
    800046ce:	8552                	mv	a0,s4
    800046d0:	fffff097          	auipc	ra,0xfffff
    800046d4:	c16080e7          	jalr	-1002(ra) # 800032e6 <dirlink>
    800046d8:	02054863          	bltz	a0,80004708 <create+0x164>
    if (dirlink(dp, name, ip->inum) < 0)
    800046dc:	004a2603          	lw	a2,4(s4)
    800046e0:	fb040593          	addi	a1,s0,-80
    800046e4:	8526                	mv	a0,s1
    800046e6:	fffff097          	auipc	ra,0xfffff
    800046ea:	c00080e7          	jalr	-1024(ra) # 800032e6 <dirlink>
    800046ee:	00054d63          	bltz	a0,80004708 <create+0x164>
        dp->nlink++; // for ".."
    800046f2:	04a4d783          	lhu	a5,74(s1)
    800046f6:	2785                	addiw	a5,a5,1
    800046f8:	04f49523          	sh	a5,74(s1)
        iupdate(dp);
    800046fc:	8526                	mv	a0,s1
    800046fe:	ffffe097          	auipc	ra,0xffffe
    80004702:	42a080e7          	jalr	1066(ra) # 80002b28 <iupdate>
    80004706:	b761                	j	8000468e <create+0xea>
    ip->nlink = 0;
    80004708:	040a1523          	sh	zero,74(s4)
    iupdate(ip);
    8000470c:	8552                	mv	a0,s4
    8000470e:	ffffe097          	auipc	ra,0xffffe
    80004712:	41a080e7          	jalr	1050(ra) # 80002b28 <iupdate>
    iunlockput(ip);
    80004716:	8552                	mv	a0,s4
    80004718:	ffffe097          	auipc	ra,0xffffe
    8000471c:	73c080e7          	jalr	1852(ra) # 80002e54 <iunlockput>
    iunlockput(dp);
    80004720:	8526                	mv	a0,s1
    80004722:	ffffe097          	auipc	ra,0xffffe
    80004726:	732080e7          	jalr	1842(ra) # 80002e54 <iunlockput>
    return 0;
    8000472a:	bdc5                	j	8000461a <create+0x76>
        return 0;
    8000472c:	8aaa                	mv	s5,a0
    8000472e:	b5f5                	j	8000461a <create+0x76>

0000000080004730 <sys_dup>:
{
    80004730:	7179                	addi	sp,sp,-48
    80004732:	f406                	sd	ra,40(sp)
    80004734:	f022                	sd	s0,32(sp)
    80004736:	ec26                	sd	s1,24(sp)
    80004738:	1800                	addi	s0,sp,48
    if (argfd(0, 0, &f) < 0)
    8000473a:	fd840613          	addi	a2,s0,-40
    8000473e:	4581                	li	a1,0
    80004740:	4501                	li	a0,0
    80004742:	00000097          	auipc	ra,0x0
    80004746:	dc0080e7          	jalr	-576(ra) # 80004502 <argfd>
        return -1;
    8000474a:	57fd                	li	a5,-1
    if (argfd(0, 0, &f) < 0)
    8000474c:	02054363          	bltz	a0,80004772 <sys_dup+0x42>
    if ((fd = fdalloc(f)) < 0)
    80004750:	fd843503          	ld	a0,-40(s0)
    80004754:	00000097          	auipc	ra,0x0
    80004758:	e0e080e7          	jalr	-498(ra) # 80004562 <fdalloc>
    8000475c:	84aa                	mv	s1,a0
        return -1;
    8000475e:	57fd                	li	a5,-1
    if ((fd = fdalloc(f)) < 0)
    80004760:	00054963          	bltz	a0,80004772 <sys_dup+0x42>
    filedup(f);
    80004764:	fd843503          	ld	a0,-40(s0)
    80004768:	fffff097          	auipc	ra,0xfffff
    8000476c:	2c6080e7          	jalr	710(ra) # 80003a2e <filedup>
    return fd;
    80004770:	87a6                	mv	a5,s1
}
    80004772:	853e                	mv	a0,a5
    80004774:	70a2                	ld	ra,40(sp)
    80004776:	7402                	ld	s0,32(sp)
    80004778:	64e2                	ld	s1,24(sp)
    8000477a:	6145                	addi	sp,sp,48
    8000477c:	8082                	ret

000000008000477e <sys_read>:
{
    8000477e:	7179                	addi	sp,sp,-48
    80004780:	f406                	sd	ra,40(sp)
    80004782:	f022                	sd	s0,32(sp)
    80004784:	1800                	addi	s0,sp,48
    argaddr(1, &p);
    80004786:	fd840593          	addi	a1,s0,-40
    8000478a:	4505                	li	a0,1
    8000478c:	ffffe097          	auipc	ra,0xffffe
    80004790:	90c080e7          	jalr	-1780(ra) # 80002098 <argaddr>
    argint(2, &n);
    80004794:	fe440593          	addi	a1,s0,-28
    80004798:	4509                	li	a0,2
    8000479a:	ffffe097          	auipc	ra,0xffffe
    8000479e:	8de080e7          	jalr	-1826(ra) # 80002078 <argint>
    if (argfd(0, 0, &f) < 0)
    800047a2:	fe840613          	addi	a2,s0,-24
    800047a6:	4581                	li	a1,0
    800047a8:	4501                	li	a0,0
    800047aa:	00000097          	auipc	ra,0x0
    800047ae:	d58080e7          	jalr	-680(ra) # 80004502 <argfd>
    800047b2:	87aa                	mv	a5,a0
        return -1;
    800047b4:	557d                	li	a0,-1
    if (argfd(0, 0, &f) < 0)
    800047b6:	0007cc63          	bltz	a5,800047ce <sys_read+0x50>
    return fileread(f, p, n);
    800047ba:	fe442603          	lw	a2,-28(s0)
    800047be:	fd843583          	ld	a1,-40(s0)
    800047c2:	fe843503          	ld	a0,-24(s0)
    800047c6:	fffff097          	auipc	ra,0xfffff
    800047ca:	44e080e7          	jalr	1102(ra) # 80003c14 <fileread>
}
    800047ce:	70a2                	ld	ra,40(sp)
    800047d0:	7402                	ld	s0,32(sp)
    800047d2:	6145                	addi	sp,sp,48
    800047d4:	8082                	ret

00000000800047d6 <sys_write>:
{
    800047d6:	7179                	addi	sp,sp,-48
    800047d8:	f406                	sd	ra,40(sp)
    800047da:	f022                	sd	s0,32(sp)
    800047dc:	1800                	addi	s0,sp,48
    argaddr(1, &p);
    800047de:	fd840593          	addi	a1,s0,-40
    800047e2:	4505                	li	a0,1
    800047e4:	ffffe097          	auipc	ra,0xffffe
    800047e8:	8b4080e7          	jalr	-1868(ra) # 80002098 <argaddr>
    argint(2, &n);
    800047ec:	fe440593          	addi	a1,s0,-28
    800047f0:	4509                	li	a0,2
    800047f2:	ffffe097          	auipc	ra,0xffffe
    800047f6:	886080e7          	jalr	-1914(ra) # 80002078 <argint>
    if (argfd(0, 0, &f) < 0)
    800047fa:	fe840613          	addi	a2,s0,-24
    800047fe:	4581                	li	a1,0
    80004800:	4501                	li	a0,0
    80004802:	00000097          	auipc	ra,0x0
    80004806:	d00080e7          	jalr	-768(ra) # 80004502 <argfd>
    8000480a:	87aa                	mv	a5,a0
        return -1;
    8000480c:	557d                	li	a0,-1
    if (argfd(0, 0, &f) < 0)
    8000480e:	0007cc63          	bltz	a5,80004826 <sys_write+0x50>
    return filewrite(f, p, n);
    80004812:	fe442603          	lw	a2,-28(s0)
    80004816:	fd843583          	ld	a1,-40(s0)
    8000481a:	fe843503          	ld	a0,-24(s0)
    8000481e:	fffff097          	auipc	ra,0xfffff
    80004822:	4b8080e7          	jalr	1208(ra) # 80003cd6 <filewrite>
}
    80004826:	70a2                	ld	ra,40(sp)
    80004828:	7402                	ld	s0,32(sp)
    8000482a:	6145                	addi	sp,sp,48
    8000482c:	8082                	ret

000000008000482e <sys_close>:
{
    8000482e:	1101                	addi	sp,sp,-32
    80004830:	ec06                	sd	ra,24(sp)
    80004832:	e822                	sd	s0,16(sp)
    80004834:	1000                	addi	s0,sp,32
    if (argfd(0, &fd, &f) < 0)
    80004836:	fe040613          	addi	a2,s0,-32
    8000483a:	fec40593          	addi	a1,s0,-20
    8000483e:	4501                	li	a0,0
    80004840:	00000097          	auipc	ra,0x0
    80004844:	cc2080e7          	jalr	-830(ra) # 80004502 <argfd>
        return -1;
    80004848:	57fd                	li	a5,-1
    if (argfd(0, &fd, &f) < 0)
    8000484a:	02054463          	bltz	a0,80004872 <sys_close+0x44>
    myproc()->ofile[fd] = 0;
    8000484e:	ffffc097          	auipc	ra,0xffffc
    80004852:	5f0080e7          	jalr	1520(ra) # 80000e3e <myproc>
    80004856:	fec42783          	lw	a5,-20(s0)
    8000485a:	07e9                	addi	a5,a5,26
    8000485c:	078e                	slli	a5,a5,0x3
    8000485e:	97aa                	add	a5,a5,a0
    80004860:	0007b023          	sd	zero,0(a5)
    fileclose(f);
    80004864:	fe043503          	ld	a0,-32(s0)
    80004868:	fffff097          	auipc	ra,0xfffff
    8000486c:	218080e7          	jalr	536(ra) # 80003a80 <fileclose>
    return 0;
    80004870:	4781                	li	a5,0
}
    80004872:	853e                	mv	a0,a5
    80004874:	60e2                	ld	ra,24(sp)
    80004876:	6442                	ld	s0,16(sp)
    80004878:	6105                	addi	sp,sp,32
    8000487a:	8082                	ret

000000008000487c <sys_fstat>:
{
    8000487c:	1101                	addi	sp,sp,-32
    8000487e:	ec06                	sd	ra,24(sp)
    80004880:	e822                	sd	s0,16(sp)
    80004882:	1000                	addi	s0,sp,32
    argaddr(1, &st);
    80004884:	fe040593          	addi	a1,s0,-32
    80004888:	4505                	li	a0,1
    8000488a:	ffffe097          	auipc	ra,0xffffe
    8000488e:	80e080e7          	jalr	-2034(ra) # 80002098 <argaddr>
    if (argfd(0, 0, &f) < 0)
    80004892:	fe840613          	addi	a2,s0,-24
    80004896:	4581                	li	a1,0
    80004898:	4501                	li	a0,0
    8000489a:	00000097          	auipc	ra,0x0
    8000489e:	c68080e7          	jalr	-920(ra) # 80004502 <argfd>
    800048a2:	87aa                	mv	a5,a0
        return -1;
    800048a4:	557d                	li	a0,-1
    if (argfd(0, 0, &f) < 0)
    800048a6:	0007ca63          	bltz	a5,800048ba <sys_fstat+0x3e>
    return filestat(f, st);
    800048aa:	fe043583          	ld	a1,-32(s0)
    800048ae:	fe843503          	ld	a0,-24(s0)
    800048b2:	fffff097          	auipc	ra,0xfffff
    800048b6:	296080e7          	jalr	662(ra) # 80003b48 <filestat>
}
    800048ba:	60e2                	ld	ra,24(sp)
    800048bc:	6442                	ld	s0,16(sp)
    800048be:	6105                	addi	sp,sp,32
    800048c0:	8082                	ret

00000000800048c2 <sys_link>:
{
    800048c2:	7169                	addi	sp,sp,-304
    800048c4:	f606                	sd	ra,296(sp)
    800048c6:	f222                	sd	s0,288(sp)
    800048c8:	ee26                	sd	s1,280(sp)
    800048ca:	ea4a                	sd	s2,272(sp)
    800048cc:	1a00                	addi	s0,sp,304
    if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800048ce:	08000613          	li	a2,128
    800048d2:	ed040593          	addi	a1,s0,-304
    800048d6:	4501                	li	a0,0
    800048d8:	ffffd097          	auipc	ra,0xffffd
    800048dc:	7e0080e7          	jalr	2016(ra) # 800020b8 <argstr>
        return -1;
    800048e0:	57fd                	li	a5,-1
    if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800048e2:	10054e63          	bltz	a0,800049fe <sys_link+0x13c>
    800048e6:	08000613          	li	a2,128
    800048ea:	f5040593          	addi	a1,s0,-176
    800048ee:	4505                	li	a0,1
    800048f0:	ffffd097          	auipc	ra,0xffffd
    800048f4:	7c8080e7          	jalr	1992(ra) # 800020b8 <argstr>
        return -1;
    800048f8:	57fd                	li	a5,-1
    if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800048fa:	10054263          	bltz	a0,800049fe <sys_link+0x13c>
    begin_op();
    800048fe:	fffff097          	auipc	ra,0xfffff
    80004902:	cb6080e7          	jalr	-842(ra) # 800035b4 <begin_op>
    if ((ip = namei(old)) == 0)
    80004906:	ed040513          	addi	a0,s0,-304
    8000490a:	fffff097          	auipc	ra,0xfffff
    8000490e:	a8e080e7          	jalr	-1394(ra) # 80003398 <namei>
    80004912:	84aa                	mv	s1,a0
    80004914:	c551                	beqz	a0,800049a0 <sys_link+0xde>
    ilock(ip);
    80004916:	ffffe097          	auipc	ra,0xffffe
    8000491a:	2dc080e7          	jalr	732(ra) # 80002bf2 <ilock>
    if (ip->type == T_DIR)
    8000491e:	04449703          	lh	a4,68(s1)
    80004922:	4785                	li	a5,1
    80004924:	08f70463          	beq	a4,a5,800049ac <sys_link+0xea>
    ip->nlink++;
    80004928:	04a4d783          	lhu	a5,74(s1)
    8000492c:	2785                	addiw	a5,a5,1
    8000492e:	04f49523          	sh	a5,74(s1)
    iupdate(ip);
    80004932:	8526                	mv	a0,s1
    80004934:	ffffe097          	auipc	ra,0xffffe
    80004938:	1f4080e7          	jalr	500(ra) # 80002b28 <iupdate>
    iunlock(ip);
    8000493c:	8526                	mv	a0,s1
    8000493e:	ffffe097          	auipc	ra,0xffffe
    80004942:	376080e7          	jalr	886(ra) # 80002cb4 <iunlock>
    if ((dp = nameiparent(new, name)) == 0)
    80004946:	fd040593          	addi	a1,s0,-48
    8000494a:	f5040513          	addi	a0,s0,-176
    8000494e:	fffff097          	auipc	ra,0xfffff
    80004952:	a68080e7          	jalr	-1432(ra) # 800033b6 <nameiparent>
    80004956:	892a                	mv	s2,a0
    80004958:	c935                	beqz	a0,800049cc <sys_link+0x10a>
    ilock(dp);
    8000495a:	ffffe097          	auipc	ra,0xffffe
    8000495e:	298080e7          	jalr	664(ra) # 80002bf2 <ilock>
    if (dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0)
    80004962:	00092703          	lw	a4,0(s2)
    80004966:	409c                	lw	a5,0(s1)
    80004968:	04f71d63          	bne	a4,a5,800049c2 <sys_link+0x100>
    8000496c:	40d0                	lw	a2,4(s1)
    8000496e:	fd040593          	addi	a1,s0,-48
    80004972:	854a                	mv	a0,s2
    80004974:	fffff097          	auipc	ra,0xfffff
    80004978:	972080e7          	jalr	-1678(ra) # 800032e6 <dirlink>
    8000497c:	04054363          	bltz	a0,800049c2 <sys_link+0x100>
    iunlockput(dp);
    80004980:	854a                	mv	a0,s2
    80004982:	ffffe097          	auipc	ra,0xffffe
    80004986:	4d2080e7          	jalr	1234(ra) # 80002e54 <iunlockput>
    iput(ip);
    8000498a:	8526                	mv	a0,s1
    8000498c:	ffffe097          	auipc	ra,0xffffe
    80004990:	420080e7          	jalr	1056(ra) # 80002dac <iput>
    end_op();
    80004994:	fffff097          	auipc	ra,0xfffff
    80004998:	ca0080e7          	jalr	-864(ra) # 80003634 <end_op>
    return 0;
    8000499c:	4781                	li	a5,0
    8000499e:	a085                	j	800049fe <sys_link+0x13c>
        end_op();
    800049a0:	fffff097          	auipc	ra,0xfffff
    800049a4:	c94080e7          	jalr	-876(ra) # 80003634 <end_op>
        return -1;
    800049a8:	57fd                	li	a5,-1
    800049aa:	a891                	j	800049fe <sys_link+0x13c>
        iunlockput(ip);
    800049ac:	8526                	mv	a0,s1
    800049ae:	ffffe097          	auipc	ra,0xffffe
    800049b2:	4a6080e7          	jalr	1190(ra) # 80002e54 <iunlockput>
        end_op();
    800049b6:	fffff097          	auipc	ra,0xfffff
    800049ba:	c7e080e7          	jalr	-898(ra) # 80003634 <end_op>
        return -1;
    800049be:	57fd                	li	a5,-1
    800049c0:	a83d                	j	800049fe <sys_link+0x13c>
        iunlockput(dp);
    800049c2:	854a                	mv	a0,s2
    800049c4:	ffffe097          	auipc	ra,0xffffe
    800049c8:	490080e7          	jalr	1168(ra) # 80002e54 <iunlockput>
    ilock(ip);
    800049cc:	8526                	mv	a0,s1
    800049ce:	ffffe097          	auipc	ra,0xffffe
    800049d2:	224080e7          	jalr	548(ra) # 80002bf2 <ilock>
    ip->nlink--;
    800049d6:	04a4d783          	lhu	a5,74(s1)
    800049da:	37fd                	addiw	a5,a5,-1
    800049dc:	04f49523          	sh	a5,74(s1)
    iupdate(ip);
    800049e0:	8526                	mv	a0,s1
    800049e2:	ffffe097          	auipc	ra,0xffffe
    800049e6:	146080e7          	jalr	326(ra) # 80002b28 <iupdate>
    iunlockput(ip);
    800049ea:	8526                	mv	a0,s1
    800049ec:	ffffe097          	auipc	ra,0xffffe
    800049f0:	468080e7          	jalr	1128(ra) # 80002e54 <iunlockput>
    end_op();
    800049f4:	fffff097          	auipc	ra,0xfffff
    800049f8:	c40080e7          	jalr	-960(ra) # 80003634 <end_op>
    return -1;
    800049fc:	57fd                	li	a5,-1
}
    800049fe:	853e                	mv	a0,a5
    80004a00:	70b2                	ld	ra,296(sp)
    80004a02:	7412                	ld	s0,288(sp)
    80004a04:	64f2                	ld	s1,280(sp)
    80004a06:	6952                	ld	s2,272(sp)
    80004a08:	6155                	addi	sp,sp,304
    80004a0a:	8082                	ret

0000000080004a0c <sys_unlink>:
{
    80004a0c:	7151                	addi	sp,sp,-240
    80004a0e:	f586                	sd	ra,232(sp)
    80004a10:	f1a2                	sd	s0,224(sp)
    80004a12:	eda6                	sd	s1,216(sp)
    80004a14:	e9ca                	sd	s2,208(sp)
    80004a16:	e5ce                	sd	s3,200(sp)
    80004a18:	1980                	addi	s0,sp,240
    if (argstr(0, path, MAXPATH) < 0)
    80004a1a:	08000613          	li	a2,128
    80004a1e:	f3040593          	addi	a1,s0,-208
    80004a22:	4501                	li	a0,0
    80004a24:	ffffd097          	auipc	ra,0xffffd
    80004a28:	694080e7          	jalr	1684(ra) # 800020b8 <argstr>
    80004a2c:	18054163          	bltz	a0,80004bae <sys_unlink+0x1a2>
    begin_op();
    80004a30:	fffff097          	auipc	ra,0xfffff
    80004a34:	b84080e7          	jalr	-1148(ra) # 800035b4 <begin_op>
    if ((dp = nameiparent(path, name)) == 0)
    80004a38:	fb040593          	addi	a1,s0,-80
    80004a3c:	f3040513          	addi	a0,s0,-208
    80004a40:	fffff097          	auipc	ra,0xfffff
    80004a44:	976080e7          	jalr	-1674(ra) # 800033b6 <nameiparent>
    80004a48:	84aa                	mv	s1,a0
    80004a4a:	c979                	beqz	a0,80004b20 <sys_unlink+0x114>
    ilock(dp);
    80004a4c:	ffffe097          	auipc	ra,0xffffe
    80004a50:	1a6080e7          	jalr	422(ra) # 80002bf2 <ilock>
    if (namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004a54:	00004597          	auipc	a1,0x4
    80004a58:	c2458593          	addi	a1,a1,-988 # 80008678 <syscalls+0x2b8>
    80004a5c:	fb040513          	addi	a0,s0,-80
    80004a60:	ffffe097          	auipc	ra,0xffffe
    80004a64:	65c080e7          	jalr	1628(ra) # 800030bc <namecmp>
    80004a68:	14050a63          	beqz	a0,80004bbc <sys_unlink+0x1b0>
    80004a6c:	00004597          	auipc	a1,0x4
    80004a70:	c1458593          	addi	a1,a1,-1004 # 80008680 <syscalls+0x2c0>
    80004a74:	fb040513          	addi	a0,s0,-80
    80004a78:	ffffe097          	auipc	ra,0xffffe
    80004a7c:	644080e7          	jalr	1604(ra) # 800030bc <namecmp>
    80004a80:	12050e63          	beqz	a0,80004bbc <sys_unlink+0x1b0>
    if ((ip = dirlookup(dp, name, &off)) == 0)
    80004a84:	f2c40613          	addi	a2,s0,-212
    80004a88:	fb040593          	addi	a1,s0,-80
    80004a8c:	8526                	mv	a0,s1
    80004a8e:	ffffe097          	auipc	ra,0xffffe
    80004a92:	648080e7          	jalr	1608(ra) # 800030d6 <dirlookup>
    80004a96:	892a                	mv	s2,a0
    80004a98:	12050263          	beqz	a0,80004bbc <sys_unlink+0x1b0>
    ilock(ip);
    80004a9c:	ffffe097          	auipc	ra,0xffffe
    80004aa0:	156080e7          	jalr	342(ra) # 80002bf2 <ilock>
    if (ip->nlink < 1)
    80004aa4:	04a91783          	lh	a5,74(s2)
    80004aa8:	08f05263          	blez	a5,80004b2c <sys_unlink+0x120>
    if (ip->type == T_DIR && !isdirempty(ip))
    80004aac:	04491703          	lh	a4,68(s2)
    80004ab0:	4785                	li	a5,1
    80004ab2:	08f70563          	beq	a4,a5,80004b3c <sys_unlink+0x130>
    memset(&de, 0, sizeof(de));
    80004ab6:	4641                	li	a2,16
    80004ab8:	4581                	li	a1,0
    80004aba:	fc040513          	addi	a0,s0,-64
    80004abe:	ffffb097          	auipc	ra,0xffffb
    80004ac2:	6ba080e7          	jalr	1722(ra) # 80000178 <memset>
    if (writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004ac6:	4741                	li	a4,16
    80004ac8:	f2c42683          	lw	a3,-212(s0)
    80004acc:	fc040613          	addi	a2,s0,-64
    80004ad0:	4581                	li	a1,0
    80004ad2:	8526                	mv	a0,s1
    80004ad4:	ffffe097          	auipc	ra,0xffffe
    80004ad8:	4ca080e7          	jalr	1226(ra) # 80002f9e <writei>
    80004adc:	47c1                	li	a5,16
    80004ade:	0af51563          	bne	a0,a5,80004b88 <sys_unlink+0x17c>
    if (ip->type == T_DIR)
    80004ae2:	04491703          	lh	a4,68(s2)
    80004ae6:	4785                	li	a5,1
    80004ae8:	0af70863          	beq	a4,a5,80004b98 <sys_unlink+0x18c>
    iunlockput(dp);
    80004aec:	8526                	mv	a0,s1
    80004aee:	ffffe097          	auipc	ra,0xffffe
    80004af2:	366080e7          	jalr	870(ra) # 80002e54 <iunlockput>
    ip->nlink--;
    80004af6:	04a95783          	lhu	a5,74(s2)
    80004afa:	37fd                	addiw	a5,a5,-1
    80004afc:	04f91523          	sh	a5,74(s2)
    iupdate(ip);
    80004b00:	854a                	mv	a0,s2
    80004b02:	ffffe097          	auipc	ra,0xffffe
    80004b06:	026080e7          	jalr	38(ra) # 80002b28 <iupdate>
    iunlockput(ip);
    80004b0a:	854a                	mv	a0,s2
    80004b0c:	ffffe097          	auipc	ra,0xffffe
    80004b10:	348080e7          	jalr	840(ra) # 80002e54 <iunlockput>
    end_op();
    80004b14:	fffff097          	auipc	ra,0xfffff
    80004b18:	b20080e7          	jalr	-1248(ra) # 80003634 <end_op>
    return 0;
    80004b1c:	4501                	li	a0,0
    80004b1e:	a84d                	j	80004bd0 <sys_unlink+0x1c4>
        end_op();
    80004b20:	fffff097          	auipc	ra,0xfffff
    80004b24:	b14080e7          	jalr	-1260(ra) # 80003634 <end_op>
        return -1;
    80004b28:	557d                	li	a0,-1
    80004b2a:	a05d                	j	80004bd0 <sys_unlink+0x1c4>
        panic("unlink: nlink < 1");
    80004b2c:	00004517          	auipc	a0,0x4
    80004b30:	b5c50513          	addi	a0,a0,-1188 # 80008688 <syscalls+0x2c8>
    80004b34:	00001097          	auipc	ra,0x1
    80004b38:	44e080e7          	jalr	1102(ra) # 80005f82 <panic>
    for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de))
    80004b3c:	04c92703          	lw	a4,76(s2)
    80004b40:	02000793          	li	a5,32
    80004b44:	f6e7f9e3          	bgeu	a5,a4,80004ab6 <sys_unlink+0xaa>
    80004b48:	02000993          	li	s3,32
        if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004b4c:	4741                	li	a4,16
    80004b4e:	86ce                	mv	a3,s3
    80004b50:	f1840613          	addi	a2,s0,-232
    80004b54:	4581                	li	a1,0
    80004b56:	854a                	mv	a0,s2
    80004b58:	ffffe097          	auipc	ra,0xffffe
    80004b5c:	34e080e7          	jalr	846(ra) # 80002ea6 <readi>
    80004b60:	47c1                	li	a5,16
    80004b62:	00f51b63          	bne	a0,a5,80004b78 <sys_unlink+0x16c>
        if (de.inum != 0)
    80004b66:	f1845783          	lhu	a5,-232(s0)
    80004b6a:	e7a1                	bnez	a5,80004bb2 <sys_unlink+0x1a6>
    for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de))
    80004b6c:	29c1                	addiw	s3,s3,16
    80004b6e:	04c92783          	lw	a5,76(s2)
    80004b72:	fcf9ede3          	bltu	s3,a5,80004b4c <sys_unlink+0x140>
    80004b76:	b781                	j	80004ab6 <sys_unlink+0xaa>
            panic("isdirempty: readi");
    80004b78:	00004517          	auipc	a0,0x4
    80004b7c:	b2850513          	addi	a0,a0,-1240 # 800086a0 <syscalls+0x2e0>
    80004b80:	00001097          	auipc	ra,0x1
    80004b84:	402080e7          	jalr	1026(ra) # 80005f82 <panic>
        panic("unlink: writei");
    80004b88:	00004517          	auipc	a0,0x4
    80004b8c:	b3050513          	addi	a0,a0,-1232 # 800086b8 <syscalls+0x2f8>
    80004b90:	00001097          	auipc	ra,0x1
    80004b94:	3f2080e7          	jalr	1010(ra) # 80005f82 <panic>
        dp->nlink--;
    80004b98:	04a4d783          	lhu	a5,74(s1)
    80004b9c:	37fd                	addiw	a5,a5,-1
    80004b9e:	04f49523          	sh	a5,74(s1)
        iupdate(dp);
    80004ba2:	8526                	mv	a0,s1
    80004ba4:	ffffe097          	auipc	ra,0xffffe
    80004ba8:	f84080e7          	jalr	-124(ra) # 80002b28 <iupdate>
    80004bac:	b781                	j	80004aec <sys_unlink+0xe0>
        return -1;
    80004bae:	557d                	li	a0,-1
    80004bb0:	a005                	j	80004bd0 <sys_unlink+0x1c4>
        iunlockput(ip);
    80004bb2:	854a                	mv	a0,s2
    80004bb4:	ffffe097          	auipc	ra,0xffffe
    80004bb8:	2a0080e7          	jalr	672(ra) # 80002e54 <iunlockput>
    iunlockput(dp);
    80004bbc:	8526                	mv	a0,s1
    80004bbe:	ffffe097          	auipc	ra,0xffffe
    80004bc2:	296080e7          	jalr	662(ra) # 80002e54 <iunlockput>
    end_op();
    80004bc6:	fffff097          	auipc	ra,0xfffff
    80004bca:	a6e080e7          	jalr	-1426(ra) # 80003634 <end_op>
    return -1;
    80004bce:	557d                	li	a0,-1
}
    80004bd0:	70ae                	ld	ra,232(sp)
    80004bd2:	740e                	ld	s0,224(sp)
    80004bd4:	64ee                	ld	s1,216(sp)
    80004bd6:	694e                	ld	s2,208(sp)
    80004bd8:	69ae                	ld	s3,200(sp)
    80004bda:	616d                	addi	sp,sp,240
    80004bdc:	8082                	ret

0000000080004bde <sys_mmap>:
{
    80004bde:	711d                	addi	sp,sp,-96
    80004be0:	ec86                	sd	ra,88(sp)
    80004be2:	e8a2                	sd	s0,80(sp)
    80004be4:	e4a6                	sd	s1,72(sp)
    80004be6:	e0ca                	sd	s2,64(sp)
    80004be8:	fc4e                	sd	s3,56(sp)
    80004bea:	1080                	addi	s0,sp,96
    argaddr(0, &addr);
    80004bec:	fc840593          	addi	a1,s0,-56
    80004bf0:	4501                	li	a0,0
    80004bf2:	ffffd097          	auipc	ra,0xffffd
    80004bf6:	4a6080e7          	jalr	1190(ra) # 80002098 <argaddr>
    argaddr(1, &length);
    80004bfa:	fc040593          	addi	a1,s0,-64
    80004bfe:	4505                	li	a0,1
    80004c00:	ffffd097          	auipc	ra,0xffffd
    80004c04:	498080e7          	jalr	1176(ra) # 80002098 <argaddr>
    argint(2, &prot);
    80004c08:	fbc40593          	addi	a1,s0,-68
    80004c0c:	4509                	li	a0,2
    80004c0e:	ffffd097          	auipc	ra,0xffffd
    80004c12:	46a080e7          	jalr	1130(ra) # 80002078 <argint>
    argint(3, &flags);
    80004c16:	fb840593          	addi	a1,s0,-72
    80004c1a:	450d                	li	a0,3
    80004c1c:	ffffd097          	auipc	ra,0xffffd
    80004c20:	45c080e7          	jalr	1116(ra) # 80002078 <argint>
    argfd(4, &fd, &pf);
    80004c24:	fa040613          	addi	a2,s0,-96
    80004c28:	fb440593          	addi	a1,s0,-76
    80004c2c:	4511                	li	a0,4
    80004c2e:	00000097          	auipc	ra,0x0
    80004c32:	8d4080e7          	jalr	-1836(ra) # 80004502 <argfd>
    argaddr(5, &offset);
    80004c36:	fa840593          	addi	a1,s0,-88
    80004c3a:	4515                	li	a0,5
    80004c3c:	ffffd097          	auipc	ra,0xffffd
    80004c40:	45c080e7          	jalr	1116(ra) # 80002098 <argaddr>
    if ((prot & PROT_WRITE) && (flags & MAP_SHARED) && (!pf->writable))
    80004c44:	fbc42783          	lw	a5,-68(s0)
    80004c48:	0027f713          	andi	a4,a5,2
    80004c4c:	cb11                	beqz	a4,80004c60 <sys_mmap+0x82>
    80004c4e:	fb842703          	lw	a4,-72(s0)
    80004c52:	8b05                	andi	a4,a4,1
    80004c54:	c711                	beqz	a4,80004c60 <sys_mmap+0x82>
    80004c56:	fa043703          	ld	a4,-96(s0)
    80004c5a:	00974703          	lbu	a4,9(a4)
    80004c5e:	cb61                	beqz	a4,80004d2e <sys_mmap+0x150>
    if ((prot & PROT_READ) && (!pf->readable))
    80004c60:	8b85                	andi	a5,a5,1
    80004c62:	c791                	beqz	a5,80004c6e <sys_mmap+0x90>
    80004c64:	fa043783          	ld	a5,-96(s0)
    80004c68:	0087c783          	lbu	a5,8(a5)
    80004c6c:	c3f9                	beqz	a5,80004d32 <sys_mmap+0x154>
    struct proc *p_proc = myproc(); // create a pt pointing to process struct
    80004c6e:	ffffc097          	auipc	ra,0xffffc
    80004c72:	1d0080e7          	jalr	464(ra) # 80000e3e <myproc>
    80004c76:	892a                	mv	s2,a0
            if (p_proc->sz + length <= MAXVA) // still enough space in process
    80004c78:	fc043503          	ld	a0,-64(s0)
    80004c7c:	16890793          	addi	a5,s2,360
    for (int i = 0; i <= VMASIZE - 1; i++)
    80004c80:	4481                	li	s1,0
        if (p_proc->vma[i].occupied != 1) // not used
    80004c82:	4605                	li	a2,1
            if (p_proc->sz + length <= MAXVA) // still enough space in process
    80004c84:	02661813          	slli	a6,a2,0x26
    for (int i = 0; i <= VMASIZE - 1; i++)
    80004c88:	45c1                	li	a1,16
    80004c8a:	a031                	j	80004c96 <sys_mmap+0xb8>
    80004c8c:	2485                	addiw	s1,s1,1
    80004c8e:	04878793          	addi	a5,a5,72
    80004c92:	08b48663          	beq	s1,a1,80004d1e <sys_mmap+0x140>
        if (p_proc->vma[i].occupied != 1) // not used
    80004c96:	4398                	lw	a4,0(a5)
    80004c98:	fec70ae3          	beq	a4,a2,80004c8c <sys_mmap+0xae>
            if (p_proc->sz + length <= MAXVA) // still enough space in process
    80004c9c:	04893683          	ld	a3,72(s2)
    80004ca0:	00a68733          	add	a4,a3,a0
    80004ca4:	fee864e3          	bltu	a6,a4,80004c8c <sys_mmap+0xae>
        p_vma->occupied = 1;                                 // denote it is occupied
    80004ca8:	00349993          	slli	s3,s1,0x3
    80004cac:	009987b3          	add	a5,s3,s1
    80004cb0:	078e                	slli	a5,a5,0x3
    80004cb2:	97ca                	add	a5,a5,s2
    80004cb4:	4605                	li	a2,1
    80004cb6:	16c7a423          	sw	a2,360(a5)
        p_vma->start_addr = (uint64)(p_proc->sz);            // get start address
    80004cba:	16d7b823          	sd	a3,368(a5)
        p_vma->end_addr = (uint64)(p_proc->sz + length - 1); // get end addrerss
    80004cbe:	fff70693          	addi	a3,a4,-1
    80004cc2:	16d7bc23          	sd	a3,376(a5)
        p_proc->sz += (uint64)(length);                      // increase sz, for other vmas
    80004cc6:	04e93423          	sd	a4,72(s2)
        p_vma->addr = (uint64)(addr);
    80004cca:	fc843703          	ld	a4,-56(s0)
    80004cce:	18e7b023          	sd	a4,384(a5)
        p_vma->length = (uint64)(length);
    80004cd2:	18a7b423          	sd	a0,392(a5)
        p_vma->prot = (int)(prot);
    80004cd6:	fbc42703          	lw	a4,-68(s0)
    80004cda:	18e7a823          	sw	a4,400(a5)
        p_vma->flags = (int)(flags);
    80004cde:	fb842703          	lw	a4,-72(s0)
    80004ce2:	18e7aa23          	sw	a4,404(a5)
        p_vma->fd = fd;
    80004ce6:	fb442703          	lw	a4,-76(s0)
    80004cea:	18e7ac23          	sw	a4,408(a5)
        p_vma->offset = (uint64)(offset);
    80004cee:	fa843703          	ld	a4,-88(s0)
    80004cf2:	1ae7b023          	sd	a4,416(a5)
        p_vma->pf = pf;
    80004cf6:	fa043503          	ld	a0,-96(s0)
    80004cfa:	1aa7b423          	sd	a0,424(a5)
        filedup(p_vma->pf);
    80004cfe:	fffff097          	auipc	ra,0xfffff
    80004d02:	d30080e7          	jalr	-720(ra) # 80003a2e <filedup>
        return (uint64)(p_vma->start_addr);
    80004d06:	94ce                	add	s1,s1,s3
    80004d08:	048e                	slli	s1,s1,0x3
    80004d0a:	9926                	add	s2,s2,s1
    80004d0c:	17093503          	ld	a0,368(s2)
}
    80004d10:	60e6                	ld	ra,88(sp)
    80004d12:	6446                	ld	s0,80(sp)
    80004d14:	64a6                	ld	s1,72(sp)
    80004d16:	6906                	ld	s2,64(sp)
    80004d18:	79e2                	ld	s3,56(sp)
    80004d1a:	6125                	addi	sp,sp,96
    80004d1c:	8082                	ret
        panic("syscall mmap");
    80004d1e:	00004517          	auipc	a0,0x4
    80004d22:	9aa50513          	addi	a0,a0,-1622 # 800086c8 <syscalls+0x308>
    80004d26:	00001097          	auipc	ra,0x1
    80004d2a:	25c080e7          	jalr	604(ra) # 80005f82 <panic>
        return -1;
    80004d2e:	557d                	li	a0,-1
    80004d30:	b7c5                	j	80004d10 <sys_mmap+0x132>
        return -1;
    80004d32:	557d                	li	a0,-1
    80004d34:	bff1                	j	80004d10 <sys_mmap+0x132>

0000000080004d36 <sys_munmap>:
{
    80004d36:	7139                	addi	sp,sp,-64
    80004d38:	fc06                	sd	ra,56(sp)
    80004d3a:	f822                	sd	s0,48(sp)
    80004d3c:	f426                	sd	s1,40(sp)
    80004d3e:	f04a                	sd	s2,32(sp)
    80004d40:	ec4e                	sd	s3,24(sp)
    80004d42:	0080                	addi	s0,sp,64
    argaddr(0, &addr);
    80004d44:	fc840593          	addi	a1,s0,-56
    80004d48:	4501                	li	a0,0
    80004d4a:	ffffd097          	auipc	ra,0xffffd
    80004d4e:	34e080e7          	jalr	846(ra) # 80002098 <argaddr>
    argaddr(1, &length);
    80004d52:	fc040593          	addi	a1,s0,-64
    80004d56:	4505                	li	a0,1
    80004d58:	ffffd097          	auipc	ra,0xffffd
    80004d5c:	340080e7          	jalr	832(ra) # 80002098 <argaddr>
    struct proc *p_proc = myproc(); // create a pt pointing to process struct
    80004d60:	ffffc097          	auipc	ra,0xffffc
    80004d64:	0de080e7          	jalr	222(ra) # 80000e3e <myproc>
    80004d68:	892a                	mv	s2,a0
        if ((p_proc->vma[i].start_addr <= addr) && (addr <= p_proc->vma[i].end_addr))
    80004d6a:	fc843703          	ld	a4,-56(s0)
    80004d6e:	17050793          	addi	a5,a0,368
    for (int i = 0; i <= VMASIZE - 1; i++)
    80004d72:	4481                	li	s1,0
    80004d74:	46c1                	li	a3,16
    80004d76:	a031                	j	80004d82 <sys_munmap+0x4c>
    80004d78:	2485                	addiw	s1,s1,1
    80004d7a:	04878793          	addi	a5,a5,72
    80004d7e:	06d48863          	beq	s1,a3,80004dee <sys_munmap+0xb8>
        if ((p_proc->vma[i].start_addr <= addr) && (addr <= p_proc->vma[i].end_addr))
    80004d82:	638c                	ld	a1,0(a5)
    80004d84:	feb76ae3          	bltu	a4,a1,80004d78 <sys_munmap+0x42>
    80004d88:	6790                	ld	a2,8(a5)
    80004d8a:	fee667e3          	bltu	a2,a4,80004d78 <sys_munmap+0x42>
        if ((p_vma->flags & MAP_SHARED) != 0)
    80004d8e:	00349793          	slli	a5,s1,0x3
    80004d92:	97a6                	add	a5,a5,s1
    80004d94:	078e                	slli	a5,a5,0x3
    80004d96:	97ca                	add	a5,a5,s2
    80004d98:	1947a783          	lw	a5,404(a5)
    80004d9c:	8b85                	andi	a5,a5,1
    80004d9e:	e3a5                	bnez	a5,80004dfe <sys_munmap+0xc8>
        uvmunmap(p_proc->pagetable, p_vma->start_addr, length / PGSIZE, 1);
    80004da0:	00349993          	slli	s3,s1,0x3
    80004da4:	99a6                	add	s3,s3,s1
    80004da6:	098e                	slli	s3,s3,0x3
    80004da8:	99ca                	add	s3,s3,s2
    80004daa:	4685                	li	a3,1
    80004dac:	fc043603          	ld	a2,-64(s0)
    80004db0:	8231                	srli	a2,a2,0xc
    80004db2:	1709b583          	ld	a1,368(s3)
    80004db6:	05093503          	ld	a0,80(s2)
    80004dba:	ffffc097          	auipc	ra,0xffffc
    80004dbe:	958080e7          	jalr	-1704(ra) # 80000712 <uvmunmap>
        p_vma->start_addr += length;
    80004dc2:	1709b783          	ld	a5,368(s3)
    80004dc6:	fc043703          	ld	a4,-64(s0)
    80004dca:	97ba                	add	a5,a5,a4
    80004dcc:	16f9b823          	sd	a5,368(s3)
        if (p_vma->start_addr == p_vma->end_addr)
    80004dd0:	1789b703          	ld	a4,376(s3)
        return 0;
    80004dd4:	4501                	li	a0,0
        if (p_vma->start_addr == p_vma->end_addr)
    80004dd6:	00e79d63          	bne	a5,a4,80004df0 <sys_munmap+0xba>
            p_vma->occupied = 0;  // denoting unused for further usage
    80004dda:	1609a423          	sw	zero,360(s3)
            fileclose(p_vma->pf); // close the file
    80004dde:	1a89b503          	ld	a0,424(s3)
    80004de2:	fffff097          	auipc	ra,0xfffff
    80004de6:	c9e080e7          	jalr	-866(ra) # 80003a80 <fileclose>
            return 0;
    80004dea:	4501                	li	a0,0
    80004dec:	a011                	j	80004df0 <sys_munmap+0xba>
        return -1;
    80004dee:	557d                	li	a0,-1
}
    80004df0:	70e2                	ld	ra,56(sp)
    80004df2:	7442                	ld	s0,48(sp)
    80004df4:	74a2                	ld	s1,40(sp)
    80004df6:	7902                	ld	s2,32(sp)
    80004df8:	69e2                	ld	s3,24(sp)
    80004dfa:	6121                	addi	sp,sp,64
    80004dfc:	8082                	ret
            filewrite(p_vma->pf, p_vma->start_addr, length);
    80004dfe:	00349793          	slli	a5,s1,0x3
    80004e02:	97a6                	add	a5,a5,s1
    80004e04:	078e                	slli	a5,a5,0x3
    80004e06:	97ca                	add	a5,a5,s2
    80004e08:	fc042603          	lw	a2,-64(s0)
    80004e0c:	1a87b503          	ld	a0,424(a5)
    80004e10:	fffff097          	auipc	ra,0xfffff
    80004e14:	ec6080e7          	jalr	-314(ra) # 80003cd6 <filewrite>
    80004e18:	b761                	j	80004da0 <sys_munmap+0x6a>

0000000080004e1a <sys_open>:

uint64
sys_open(void)
{
    80004e1a:	7131                	addi	sp,sp,-192
    80004e1c:	fd06                	sd	ra,184(sp)
    80004e1e:	f922                	sd	s0,176(sp)
    80004e20:	f526                	sd	s1,168(sp)
    80004e22:	f14a                	sd	s2,160(sp)
    80004e24:	ed4e                	sd	s3,152(sp)
    80004e26:	0180                	addi	s0,sp,192
    int fd, omode;
    struct file *f;
    struct inode *ip;
    int n;

    argint(1, &omode);
    80004e28:	f4c40593          	addi	a1,s0,-180
    80004e2c:	4505                	li	a0,1
    80004e2e:	ffffd097          	auipc	ra,0xffffd
    80004e32:	24a080e7          	jalr	586(ra) # 80002078 <argint>
    if ((n = argstr(0, path, MAXPATH)) < 0)
    80004e36:	08000613          	li	a2,128
    80004e3a:	f5040593          	addi	a1,s0,-176
    80004e3e:	4501                	li	a0,0
    80004e40:	ffffd097          	auipc	ra,0xffffd
    80004e44:	278080e7          	jalr	632(ra) # 800020b8 <argstr>
    80004e48:	87aa                	mv	a5,a0
        return -1;
    80004e4a:	557d                	li	a0,-1
    if ((n = argstr(0, path, MAXPATH)) < 0)
    80004e4c:	0a07c963          	bltz	a5,80004efe <sys_open+0xe4>

    begin_op();
    80004e50:	ffffe097          	auipc	ra,0xffffe
    80004e54:	764080e7          	jalr	1892(ra) # 800035b4 <begin_op>

    if (omode & O_CREATE)
    80004e58:	f4c42783          	lw	a5,-180(s0)
    80004e5c:	2007f793          	andi	a5,a5,512
    80004e60:	cfc5                	beqz	a5,80004f18 <sys_open+0xfe>
    {
        ip = create(path, T_FILE, 0, 0);
    80004e62:	4681                	li	a3,0
    80004e64:	4601                	li	a2,0
    80004e66:	4589                	li	a1,2
    80004e68:	f5040513          	addi	a0,s0,-176
    80004e6c:	fffff097          	auipc	ra,0xfffff
    80004e70:	738080e7          	jalr	1848(ra) # 800045a4 <create>
    80004e74:	84aa                	mv	s1,a0
        if (ip == 0)
    80004e76:	c959                	beqz	a0,80004f0c <sys_open+0xf2>
            end_op();
            return -1;
        }
    }

    if (ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV))
    80004e78:	04449703          	lh	a4,68(s1)
    80004e7c:	478d                	li	a5,3
    80004e7e:	00f71763          	bne	a4,a5,80004e8c <sys_open+0x72>
    80004e82:	0464d703          	lhu	a4,70(s1)
    80004e86:	47a5                	li	a5,9
    80004e88:	0ce7ed63          	bltu	a5,a4,80004f62 <sys_open+0x148>
        iunlockput(ip);
        end_op();
        return -1;
    }

    if ((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0)
    80004e8c:	fffff097          	auipc	ra,0xfffff
    80004e90:	b38080e7          	jalr	-1224(ra) # 800039c4 <filealloc>
    80004e94:	89aa                	mv	s3,a0
    80004e96:	10050363          	beqz	a0,80004f9c <sys_open+0x182>
    80004e9a:	fffff097          	auipc	ra,0xfffff
    80004e9e:	6c8080e7          	jalr	1736(ra) # 80004562 <fdalloc>
    80004ea2:	892a                	mv	s2,a0
    80004ea4:	0e054763          	bltz	a0,80004f92 <sys_open+0x178>
        iunlockput(ip);
        end_op();
        return -1;
    }

    if (ip->type == T_DEVICE)
    80004ea8:	04449703          	lh	a4,68(s1)
    80004eac:	478d                	li	a5,3
    80004eae:	0cf70563          	beq	a4,a5,80004f78 <sys_open+0x15e>
        f->type = FD_DEVICE;
        f->major = ip->major;
    }
    else
    {
        f->type = FD_INODE;
    80004eb2:	4789                	li	a5,2
    80004eb4:	00f9a023          	sw	a5,0(s3)
        f->off = 0;
    80004eb8:	0209a023          	sw	zero,32(s3)
    }
    f->ip = ip;
    80004ebc:	0099bc23          	sd	s1,24(s3)
    f->readable = !(omode & O_WRONLY);
    80004ec0:	f4c42783          	lw	a5,-180(s0)
    80004ec4:	0017c713          	xori	a4,a5,1
    80004ec8:	8b05                	andi	a4,a4,1
    80004eca:	00e98423          	sb	a4,8(s3)
    f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004ece:	0037f713          	andi	a4,a5,3
    80004ed2:	00e03733          	snez	a4,a4
    80004ed6:	00e984a3          	sb	a4,9(s3)

    if ((omode & O_TRUNC) && ip->type == T_FILE)
    80004eda:	4007f793          	andi	a5,a5,1024
    80004ede:	c791                	beqz	a5,80004eea <sys_open+0xd0>
    80004ee0:	04449703          	lh	a4,68(s1)
    80004ee4:	4789                	li	a5,2
    80004ee6:	0af70063          	beq	a4,a5,80004f86 <sys_open+0x16c>
    {
        itrunc(ip);
    }

    iunlock(ip);
    80004eea:	8526                	mv	a0,s1
    80004eec:	ffffe097          	auipc	ra,0xffffe
    80004ef0:	dc8080e7          	jalr	-568(ra) # 80002cb4 <iunlock>
    end_op();
    80004ef4:	ffffe097          	auipc	ra,0xffffe
    80004ef8:	740080e7          	jalr	1856(ra) # 80003634 <end_op>

    return fd;
    80004efc:	854a                	mv	a0,s2
}
    80004efe:	70ea                	ld	ra,184(sp)
    80004f00:	744a                	ld	s0,176(sp)
    80004f02:	74aa                	ld	s1,168(sp)
    80004f04:	790a                	ld	s2,160(sp)
    80004f06:	69ea                	ld	s3,152(sp)
    80004f08:	6129                	addi	sp,sp,192
    80004f0a:	8082                	ret
            end_op();
    80004f0c:	ffffe097          	auipc	ra,0xffffe
    80004f10:	728080e7          	jalr	1832(ra) # 80003634 <end_op>
            return -1;
    80004f14:	557d                	li	a0,-1
    80004f16:	b7e5                	j	80004efe <sys_open+0xe4>
        if ((ip = namei(path)) == 0)
    80004f18:	f5040513          	addi	a0,s0,-176
    80004f1c:	ffffe097          	auipc	ra,0xffffe
    80004f20:	47c080e7          	jalr	1148(ra) # 80003398 <namei>
    80004f24:	84aa                	mv	s1,a0
    80004f26:	c905                	beqz	a0,80004f56 <sys_open+0x13c>
        ilock(ip);
    80004f28:	ffffe097          	auipc	ra,0xffffe
    80004f2c:	cca080e7          	jalr	-822(ra) # 80002bf2 <ilock>
        if (ip->type == T_DIR && omode != O_RDONLY)
    80004f30:	04449703          	lh	a4,68(s1)
    80004f34:	4785                	li	a5,1
    80004f36:	f4f711e3          	bne	a4,a5,80004e78 <sys_open+0x5e>
    80004f3a:	f4c42783          	lw	a5,-180(s0)
    80004f3e:	d7b9                	beqz	a5,80004e8c <sys_open+0x72>
            iunlockput(ip);
    80004f40:	8526                	mv	a0,s1
    80004f42:	ffffe097          	auipc	ra,0xffffe
    80004f46:	f12080e7          	jalr	-238(ra) # 80002e54 <iunlockput>
            end_op();
    80004f4a:	ffffe097          	auipc	ra,0xffffe
    80004f4e:	6ea080e7          	jalr	1770(ra) # 80003634 <end_op>
            return -1;
    80004f52:	557d                	li	a0,-1
    80004f54:	b76d                	j	80004efe <sys_open+0xe4>
            end_op();
    80004f56:	ffffe097          	auipc	ra,0xffffe
    80004f5a:	6de080e7          	jalr	1758(ra) # 80003634 <end_op>
            return -1;
    80004f5e:	557d                	li	a0,-1
    80004f60:	bf79                	j	80004efe <sys_open+0xe4>
        iunlockput(ip);
    80004f62:	8526                	mv	a0,s1
    80004f64:	ffffe097          	auipc	ra,0xffffe
    80004f68:	ef0080e7          	jalr	-272(ra) # 80002e54 <iunlockput>
        end_op();
    80004f6c:	ffffe097          	auipc	ra,0xffffe
    80004f70:	6c8080e7          	jalr	1736(ra) # 80003634 <end_op>
        return -1;
    80004f74:	557d                	li	a0,-1
    80004f76:	b761                	j	80004efe <sys_open+0xe4>
        f->type = FD_DEVICE;
    80004f78:	00f9a023          	sw	a5,0(s3)
        f->major = ip->major;
    80004f7c:	04649783          	lh	a5,70(s1)
    80004f80:	02f99223          	sh	a5,36(s3)
    80004f84:	bf25                	j	80004ebc <sys_open+0xa2>
        itrunc(ip);
    80004f86:	8526                	mv	a0,s1
    80004f88:	ffffe097          	auipc	ra,0xffffe
    80004f8c:	d78080e7          	jalr	-648(ra) # 80002d00 <itrunc>
    80004f90:	bfa9                	j	80004eea <sys_open+0xd0>
            fileclose(f);
    80004f92:	854e                	mv	a0,s3
    80004f94:	fffff097          	auipc	ra,0xfffff
    80004f98:	aec080e7          	jalr	-1300(ra) # 80003a80 <fileclose>
        iunlockput(ip);
    80004f9c:	8526                	mv	a0,s1
    80004f9e:	ffffe097          	auipc	ra,0xffffe
    80004fa2:	eb6080e7          	jalr	-330(ra) # 80002e54 <iunlockput>
        end_op();
    80004fa6:	ffffe097          	auipc	ra,0xffffe
    80004faa:	68e080e7          	jalr	1678(ra) # 80003634 <end_op>
        return -1;
    80004fae:	557d                	li	a0,-1
    80004fb0:	b7b9                	j	80004efe <sys_open+0xe4>

0000000080004fb2 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004fb2:	7175                	addi	sp,sp,-144
    80004fb4:	e506                	sd	ra,136(sp)
    80004fb6:	e122                	sd	s0,128(sp)
    80004fb8:	0900                	addi	s0,sp,144
    char path[MAXPATH];
    struct inode *ip;

    begin_op();
    80004fba:	ffffe097          	auipc	ra,0xffffe
    80004fbe:	5fa080e7          	jalr	1530(ra) # 800035b4 <begin_op>
    if (argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0)
    80004fc2:	08000613          	li	a2,128
    80004fc6:	f7040593          	addi	a1,s0,-144
    80004fca:	4501                	li	a0,0
    80004fcc:	ffffd097          	auipc	ra,0xffffd
    80004fd0:	0ec080e7          	jalr	236(ra) # 800020b8 <argstr>
    80004fd4:	02054963          	bltz	a0,80005006 <sys_mkdir+0x54>
    80004fd8:	4681                	li	a3,0
    80004fda:	4601                	li	a2,0
    80004fdc:	4585                	li	a1,1
    80004fde:	f7040513          	addi	a0,s0,-144
    80004fe2:	fffff097          	auipc	ra,0xfffff
    80004fe6:	5c2080e7          	jalr	1474(ra) # 800045a4 <create>
    80004fea:	cd11                	beqz	a0,80005006 <sys_mkdir+0x54>
    {
        end_op();
        return -1;
    }
    iunlockput(ip);
    80004fec:	ffffe097          	auipc	ra,0xffffe
    80004ff0:	e68080e7          	jalr	-408(ra) # 80002e54 <iunlockput>
    end_op();
    80004ff4:	ffffe097          	auipc	ra,0xffffe
    80004ff8:	640080e7          	jalr	1600(ra) # 80003634 <end_op>
    return 0;
    80004ffc:	4501                	li	a0,0
}
    80004ffe:	60aa                	ld	ra,136(sp)
    80005000:	640a                	ld	s0,128(sp)
    80005002:	6149                	addi	sp,sp,144
    80005004:	8082                	ret
        end_op();
    80005006:	ffffe097          	auipc	ra,0xffffe
    8000500a:	62e080e7          	jalr	1582(ra) # 80003634 <end_op>
        return -1;
    8000500e:	557d                	li	a0,-1
    80005010:	b7fd                	j	80004ffe <sys_mkdir+0x4c>

0000000080005012 <sys_mknod>:

uint64
sys_mknod(void)
{
    80005012:	7135                	addi	sp,sp,-160
    80005014:	ed06                	sd	ra,152(sp)
    80005016:	e922                	sd	s0,144(sp)
    80005018:	1100                	addi	s0,sp,160
    struct inode *ip;
    char path[MAXPATH];
    int major, minor;

    begin_op();
    8000501a:	ffffe097          	auipc	ra,0xffffe
    8000501e:	59a080e7          	jalr	1434(ra) # 800035b4 <begin_op>
    argint(1, &major);
    80005022:	f6c40593          	addi	a1,s0,-148
    80005026:	4505                	li	a0,1
    80005028:	ffffd097          	auipc	ra,0xffffd
    8000502c:	050080e7          	jalr	80(ra) # 80002078 <argint>
    argint(2, &minor);
    80005030:	f6840593          	addi	a1,s0,-152
    80005034:	4509                	li	a0,2
    80005036:	ffffd097          	auipc	ra,0xffffd
    8000503a:	042080e7          	jalr	66(ra) # 80002078 <argint>
    if ((argstr(0, path, MAXPATH)) < 0 ||
    8000503e:	08000613          	li	a2,128
    80005042:	f7040593          	addi	a1,s0,-144
    80005046:	4501                	li	a0,0
    80005048:	ffffd097          	auipc	ra,0xffffd
    8000504c:	070080e7          	jalr	112(ra) # 800020b8 <argstr>
    80005050:	02054b63          	bltz	a0,80005086 <sys_mknod+0x74>
        (ip = create(path, T_DEVICE, major, minor)) == 0)
    80005054:	f6841683          	lh	a3,-152(s0)
    80005058:	f6c41603          	lh	a2,-148(s0)
    8000505c:	458d                	li	a1,3
    8000505e:	f7040513          	addi	a0,s0,-144
    80005062:	fffff097          	auipc	ra,0xfffff
    80005066:	542080e7          	jalr	1346(ra) # 800045a4 <create>
    if ((argstr(0, path, MAXPATH)) < 0 ||
    8000506a:	cd11                	beqz	a0,80005086 <sys_mknod+0x74>
    {
        end_op();
        return -1;
    }
    iunlockput(ip);
    8000506c:	ffffe097          	auipc	ra,0xffffe
    80005070:	de8080e7          	jalr	-536(ra) # 80002e54 <iunlockput>
    end_op();
    80005074:	ffffe097          	auipc	ra,0xffffe
    80005078:	5c0080e7          	jalr	1472(ra) # 80003634 <end_op>
    return 0;
    8000507c:	4501                	li	a0,0
}
    8000507e:	60ea                	ld	ra,152(sp)
    80005080:	644a                	ld	s0,144(sp)
    80005082:	610d                	addi	sp,sp,160
    80005084:	8082                	ret
        end_op();
    80005086:	ffffe097          	auipc	ra,0xffffe
    8000508a:	5ae080e7          	jalr	1454(ra) # 80003634 <end_op>
        return -1;
    8000508e:	557d                	li	a0,-1
    80005090:	b7fd                	j	8000507e <sys_mknod+0x6c>

0000000080005092 <sys_chdir>:

uint64
sys_chdir(void)
{
    80005092:	7135                	addi	sp,sp,-160
    80005094:	ed06                	sd	ra,152(sp)
    80005096:	e922                	sd	s0,144(sp)
    80005098:	e526                	sd	s1,136(sp)
    8000509a:	e14a                	sd	s2,128(sp)
    8000509c:	1100                	addi	s0,sp,160
    char path[MAXPATH];
    struct inode *ip;
    struct proc *p = myproc();
    8000509e:	ffffc097          	auipc	ra,0xffffc
    800050a2:	da0080e7          	jalr	-608(ra) # 80000e3e <myproc>
    800050a6:	892a                	mv	s2,a0

    begin_op();
    800050a8:	ffffe097          	auipc	ra,0xffffe
    800050ac:	50c080e7          	jalr	1292(ra) # 800035b4 <begin_op>
    if (argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0)
    800050b0:	08000613          	li	a2,128
    800050b4:	f6040593          	addi	a1,s0,-160
    800050b8:	4501                	li	a0,0
    800050ba:	ffffd097          	auipc	ra,0xffffd
    800050be:	ffe080e7          	jalr	-2(ra) # 800020b8 <argstr>
    800050c2:	04054b63          	bltz	a0,80005118 <sys_chdir+0x86>
    800050c6:	f6040513          	addi	a0,s0,-160
    800050ca:	ffffe097          	auipc	ra,0xffffe
    800050ce:	2ce080e7          	jalr	718(ra) # 80003398 <namei>
    800050d2:	84aa                	mv	s1,a0
    800050d4:	c131                	beqz	a0,80005118 <sys_chdir+0x86>
    {
        end_op();
        return -1;
    }
    ilock(ip);
    800050d6:	ffffe097          	auipc	ra,0xffffe
    800050da:	b1c080e7          	jalr	-1252(ra) # 80002bf2 <ilock>
    if (ip->type != T_DIR)
    800050de:	04449703          	lh	a4,68(s1)
    800050e2:	4785                	li	a5,1
    800050e4:	04f71063          	bne	a4,a5,80005124 <sys_chdir+0x92>
    {
        iunlockput(ip);
        end_op();
        return -1;
    }
    iunlock(ip);
    800050e8:	8526                	mv	a0,s1
    800050ea:	ffffe097          	auipc	ra,0xffffe
    800050ee:	bca080e7          	jalr	-1078(ra) # 80002cb4 <iunlock>
    iput(p->cwd);
    800050f2:	15093503          	ld	a0,336(s2)
    800050f6:	ffffe097          	auipc	ra,0xffffe
    800050fa:	cb6080e7          	jalr	-842(ra) # 80002dac <iput>
    end_op();
    800050fe:	ffffe097          	auipc	ra,0xffffe
    80005102:	536080e7          	jalr	1334(ra) # 80003634 <end_op>
    p->cwd = ip;
    80005106:	14993823          	sd	s1,336(s2)
    return 0;
    8000510a:	4501                	li	a0,0
}
    8000510c:	60ea                	ld	ra,152(sp)
    8000510e:	644a                	ld	s0,144(sp)
    80005110:	64aa                	ld	s1,136(sp)
    80005112:	690a                	ld	s2,128(sp)
    80005114:	610d                	addi	sp,sp,160
    80005116:	8082                	ret
        end_op();
    80005118:	ffffe097          	auipc	ra,0xffffe
    8000511c:	51c080e7          	jalr	1308(ra) # 80003634 <end_op>
        return -1;
    80005120:	557d                	li	a0,-1
    80005122:	b7ed                	j	8000510c <sys_chdir+0x7a>
        iunlockput(ip);
    80005124:	8526                	mv	a0,s1
    80005126:	ffffe097          	auipc	ra,0xffffe
    8000512a:	d2e080e7          	jalr	-722(ra) # 80002e54 <iunlockput>
        end_op();
    8000512e:	ffffe097          	auipc	ra,0xffffe
    80005132:	506080e7          	jalr	1286(ra) # 80003634 <end_op>
        return -1;
    80005136:	557d                	li	a0,-1
    80005138:	bfd1                	j	8000510c <sys_chdir+0x7a>

000000008000513a <sys_exec>:

uint64
sys_exec(void)
{
    8000513a:	7145                	addi	sp,sp,-464
    8000513c:	e786                	sd	ra,456(sp)
    8000513e:	e3a2                	sd	s0,448(sp)
    80005140:	ff26                	sd	s1,440(sp)
    80005142:	fb4a                	sd	s2,432(sp)
    80005144:	f74e                	sd	s3,424(sp)
    80005146:	f352                	sd	s4,416(sp)
    80005148:	ef56                	sd	s5,408(sp)
    8000514a:	0b80                	addi	s0,sp,464
    char path[MAXPATH], *argv[MAXARG];
    int i;
    uint64 uargv, uarg;

    argaddr(1, &uargv);
    8000514c:	e3840593          	addi	a1,s0,-456
    80005150:	4505                	li	a0,1
    80005152:	ffffd097          	auipc	ra,0xffffd
    80005156:	f46080e7          	jalr	-186(ra) # 80002098 <argaddr>
    if (argstr(0, path, MAXPATH) < 0)
    8000515a:	08000613          	li	a2,128
    8000515e:	f4040593          	addi	a1,s0,-192
    80005162:	4501                	li	a0,0
    80005164:	ffffd097          	auipc	ra,0xffffd
    80005168:	f54080e7          	jalr	-172(ra) # 800020b8 <argstr>
    8000516c:	87aa                	mv	a5,a0
    {
        return -1;
    8000516e:	557d                	li	a0,-1
    if (argstr(0, path, MAXPATH) < 0)
    80005170:	0c07c263          	bltz	a5,80005234 <sys_exec+0xfa>
    }
    memset(argv, 0, sizeof(argv));
    80005174:	10000613          	li	a2,256
    80005178:	4581                	li	a1,0
    8000517a:	e4040513          	addi	a0,s0,-448
    8000517e:	ffffb097          	auipc	ra,0xffffb
    80005182:	ffa080e7          	jalr	-6(ra) # 80000178 <memset>
    for (i = 0;; i++)
    {
        if (i >= NELEM(argv))
    80005186:	e4040493          	addi	s1,s0,-448
    memset(argv, 0, sizeof(argv));
    8000518a:	89a6                	mv	s3,s1
    8000518c:	4901                	li	s2,0
        if (i >= NELEM(argv))
    8000518e:	02000a13          	li	s4,32
    80005192:	00090a9b          	sext.w	s5,s2
        {
            goto bad;
        }
        if (fetchaddr(uargv + sizeof(uint64) * i, (uint64 *)&uarg) < 0)
    80005196:	00391513          	slli	a0,s2,0x3
    8000519a:	e3040593          	addi	a1,s0,-464
    8000519e:	e3843783          	ld	a5,-456(s0)
    800051a2:	953e                	add	a0,a0,a5
    800051a4:	ffffd097          	auipc	ra,0xffffd
    800051a8:	e36080e7          	jalr	-458(ra) # 80001fda <fetchaddr>
    800051ac:	02054a63          	bltz	a0,800051e0 <sys_exec+0xa6>
        {
            goto bad;
        }
        if (uarg == 0)
    800051b0:	e3043783          	ld	a5,-464(s0)
    800051b4:	c3b9                	beqz	a5,800051fa <sys_exec+0xc0>
        {
            argv[i] = 0;
            break;
        }
        argv[i] = kalloc();
    800051b6:	ffffb097          	auipc	ra,0xffffb
    800051ba:	f62080e7          	jalr	-158(ra) # 80000118 <kalloc>
    800051be:	85aa                	mv	a1,a0
    800051c0:	00a9b023          	sd	a0,0(s3)
        if (argv[i] == 0)
    800051c4:	cd11                	beqz	a0,800051e0 <sys_exec+0xa6>
            goto bad;
        if (fetchstr(uarg, argv[i], PGSIZE) < 0)
    800051c6:	6605                	lui	a2,0x1
    800051c8:	e3043503          	ld	a0,-464(s0)
    800051cc:	ffffd097          	auipc	ra,0xffffd
    800051d0:	e60080e7          	jalr	-416(ra) # 8000202c <fetchstr>
    800051d4:	00054663          	bltz	a0,800051e0 <sys_exec+0xa6>
        if (i >= NELEM(argv))
    800051d8:	0905                	addi	s2,s2,1
    800051da:	09a1                	addi	s3,s3,8
    800051dc:	fb491be3          	bne	s2,s4,80005192 <sys_exec+0x58>
        kfree(argv[i]);

    return ret;

bad:
    for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800051e0:	10048913          	addi	s2,s1,256
    800051e4:	6088                	ld	a0,0(s1)
    800051e6:	c531                	beqz	a0,80005232 <sys_exec+0xf8>
        kfree(argv[i]);
    800051e8:	ffffb097          	auipc	ra,0xffffb
    800051ec:	e34080e7          	jalr	-460(ra) # 8000001c <kfree>
    for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    800051f0:	04a1                	addi	s1,s1,8
    800051f2:	ff2499e3          	bne	s1,s2,800051e4 <sys_exec+0xaa>
    return -1;
    800051f6:	557d                	li	a0,-1
    800051f8:	a835                	j	80005234 <sys_exec+0xfa>
            argv[i] = 0;
    800051fa:	0a8e                	slli	s5,s5,0x3
    800051fc:	fc040793          	addi	a5,s0,-64
    80005200:	9abe                	add	s5,s5,a5
    80005202:	e80ab023          	sd	zero,-384(s5)
    int ret = exec(path, argv);
    80005206:	e4040593          	addi	a1,s0,-448
    8000520a:	f4040513          	addi	a0,s0,-192
    8000520e:	fffff097          	auipc	ra,0xfffff
    80005212:	f54080e7          	jalr	-172(ra) # 80004162 <exec>
    80005216:	892a                	mv	s2,a0
    for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005218:	10048993          	addi	s3,s1,256
    8000521c:	6088                	ld	a0,0(s1)
    8000521e:	c901                	beqz	a0,8000522e <sys_exec+0xf4>
        kfree(argv[i]);
    80005220:	ffffb097          	auipc	ra,0xffffb
    80005224:	dfc080e7          	jalr	-516(ra) # 8000001c <kfree>
    for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005228:	04a1                	addi	s1,s1,8
    8000522a:	ff3499e3          	bne	s1,s3,8000521c <sys_exec+0xe2>
    return ret;
    8000522e:	854a                	mv	a0,s2
    80005230:	a011                	j	80005234 <sys_exec+0xfa>
    return -1;
    80005232:	557d                	li	a0,-1
}
    80005234:	60be                	ld	ra,456(sp)
    80005236:	641e                	ld	s0,448(sp)
    80005238:	74fa                	ld	s1,440(sp)
    8000523a:	795a                	ld	s2,432(sp)
    8000523c:	79ba                	ld	s3,424(sp)
    8000523e:	7a1a                	ld	s4,416(sp)
    80005240:	6afa                	ld	s5,408(sp)
    80005242:	6179                	addi	sp,sp,464
    80005244:	8082                	ret

0000000080005246 <sys_pipe>:

uint64
sys_pipe(void)
{
    80005246:	7139                	addi	sp,sp,-64
    80005248:	fc06                	sd	ra,56(sp)
    8000524a:	f822                	sd	s0,48(sp)
    8000524c:	f426                	sd	s1,40(sp)
    8000524e:	0080                	addi	s0,sp,64
    uint64 fdarray; // user pointer to array of two integers
    struct file *rf, *wf;
    int fd0, fd1;
    struct proc *p = myproc();
    80005250:	ffffc097          	auipc	ra,0xffffc
    80005254:	bee080e7          	jalr	-1042(ra) # 80000e3e <myproc>
    80005258:	84aa                	mv	s1,a0

    argaddr(0, &fdarray);
    8000525a:	fd840593          	addi	a1,s0,-40
    8000525e:	4501                	li	a0,0
    80005260:	ffffd097          	auipc	ra,0xffffd
    80005264:	e38080e7          	jalr	-456(ra) # 80002098 <argaddr>
    if (pipealloc(&rf, &wf) < 0)
    80005268:	fc840593          	addi	a1,s0,-56
    8000526c:	fd040513          	addi	a0,s0,-48
    80005270:	fffff097          	auipc	ra,0xfffff
    80005274:	b9a080e7          	jalr	-1126(ra) # 80003e0a <pipealloc>
        return -1;
    80005278:	57fd                	li	a5,-1
    if (pipealloc(&rf, &wf) < 0)
    8000527a:	0c054463          	bltz	a0,80005342 <sys_pipe+0xfc>
    fd0 = -1;
    8000527e:	fcf42223          	sw	a5,-60(s0)
    if ((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0)
    80005282:	fd043503          	ld	a0,-48(s0)
    80005286:	fffff097          	auipc	ra,0xfffff
    8000528a:	2dc080e7          	jalr	732(ra) # 80004562 <fdalloc>
    8000528e:	fca42223          	sw	a0,-60(s0)
    80005292:	08054b63          	bltz	a0,80005328 <sys_pipe+0xe2>
    80005296:	fc843503          	ld	a0,-56(s0)
    8000529a:	fffff097          	auipc	ra,0xfffff
    8000529e:	2c8080e7          	jalr	712(ra) # 80004562 <fdalloc>
    800052a2:	fca42023          	sw	a0,-64(s0)
    800052a6:	06054863          	bltz	a0,80005316 <sys_pipe+0xd0>
            p->ofile[fd0] = 0;
        fileclose(rf);
        fileclose(wf);
        return -1;
    }
    if (copyout(p->pagetable, fdarray, (char *)&fd0, sizeof(fd0)) < 0 ||
    800052aa:	4691                	li	a3,4
    800052ac:	fc440613          	addi	a2,s0,-60
    800052b0:	fd843583          	ld	a1,-40(s0)
    800052b4:	68a8                	ld	a0,80(s1)
    800052b6:	ffffc097          	auipc	ra,0xffffc
    800052ba:	846080e7          	jalr	-1978(ra) # 80000afc <copyout>
    800052be:	02054063          	bltz	a0,800052de <sys_pipe+0x98>
        copyout(p->pagetable, fdarray + sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0)
    800052c2:	4691                	li	a3,4
    800052c4:	fc040613          	addi	a2,s0,-64
    800052c8:	fd843583          	ld	a1,-40(s0)
    800052cc:	0591                	addi	a1,a1,4
    800052ce:	68a8                	ld	a0,80(s1)
    800052d0:	ffffc097          	auipc	ra,0xffffc
    800052d4:	82c080e7          	jalr	-2004(ra) # 80000afc <copyout>
        p->ofile[fd1] = 0;
        fileclose(rf);
        fileclose(wf);
        return -1;
    }
    return 0;
    800052d8:	4781                	li	a5,0
    if (copyout(p->pagetable, fdarray, (char *)&fd0, sizeof(fd0)) < 0 ||
    800052da:	06055463          	bgez	a0,80005342 <sys_pipe+0xfc>
        p->ofile[fd0] = 0;
    800052de:	fc442783          	lw	a5,-60(s0)
    800052e2:	07e9                	addi	a5,a5,26
    800052e4:	078e                	slli	a5,a5,0x3
    800052e6:	97a6                	add	a5,a5,s1
    800052e8:	0007b023          	sd	zero,0(a5)
        p->ofile[fd1] = 0;
    800052ec:	fc042503          	lw	a0,-64(s0)
    800052f0:	0569                	addi	a0,a0,26
    800052f2:	050e                	slli	a0,a0,0x3
    800052f4:	94aa                	add	s1,s1,a0
    800052f6:	0004b023          	sd	zero,0(s1)
        fileclose(rf);
    800052fa:	fd043503          	ld	a0,-48(s0)
    800052fe:	ffffe097          	auipc	ra,0xffffe
    80005302:	782080e7          	jalr	1922(ra) # 80003a80 <fileclose>
        fileclose(wf);
    80005306:	fc843503          	ld	a0,-56(s0)
    8000530a:	ffffe097          	auipc	ra,0xffffe
    8000530e:	776080e7          	jalr	1910(ra) # 80003a80 <fileclose>
        return -1;
    80005312:	57fd                	li	a5,-1
    80005314:	a03d                	j	80005342 <sys_pipe+0xfc>
        if (fd0 >= 0)
    80005316:	fc442783          	lw	a5,-60(s0)
    8000531a:	0007c763          	bltz	a5,80005328 <sys_pipe+0xe2>
            p->ofile[fd0] = 0;
    8000531e:	07e9                	addi	a5,a5,26
    80005320:	078e                	slli	a5,a5,0x3
    80005322:	94be                	add	s1,s1,a5
    80005324:	0004b023          	sd	zero,0(s1)
        fileclose(rf);
    80005328:	fd043503          	ld	a0,-48(s0)
    8000532c:	ffffe097          	auipc	ra,0xffffe
    80005330:	754080e7          	jalr	1876(ra) # 80003a80 <fileclose>
        fileclose(wf);
    80005334:	fc843503          	ld	a0,-56(s0)
    80005338:	ffffe097          	auipc	ra,0xffffe
    8000533c:	748080e7          	jalr	1864(ra) # 80003a80 <fileclose>
        return -1;
    80005340:	57fd                	li	a5,-1
}
    80005342:	853e                	mv	a0,a5
    80005344:	70e2                	ld	ra,56(sp)
    80005346:	7442                	ld	s0,48(sp)
    80005348:	74a2                	ld	s1,40(sp)
    8000534a:	6121                	addi	sp,sp,64
    8000534c:	8082                	ret
	...

0000000080005350 <kernelvec>:
    80005350:	7111                	addi	sp,sp,-256
    80005352:	e006                	sd	ra,0(sp)
    80005354:	e40a                	sd	sp,8(sp)
    80005356:	e80e                	sd	gp,16(sp)
    80005358:	ec12                	sd	tp,24(sp)
    8000535a:	f016                	sd	t0,32(sp)
    8000535c:	f41a                	sd	t1,40(sp)
    8000535e:	f81e                	sd	t2,48(sp)
    80005360:	fc22                	sd	s0,56(sp)
    80005362:	e0a6                	sd	s1,64(sp)
    80005364:	e4aa                	sd	a0,72(sp)
    80005366:	e8ae                	sd	a1,80(sp)
    80005368:	ecb2                	sd	a2,88(sp)
    8000536a:	f0b6                	sd	a3,96(sp)
    8000536c:	f4ba                	sd	a4,104(sp)
    8000536e:	f8be                	sd	a5,112(sp)
    80005370:	fcc2                	sd	a6,120(sp)
    80005372:	e146                	sd	a7,128(sp)
    80005374:	e54a                	sd	s2,136(sp)
    80005376:	e94e                	sd	s3,144(sp)
    80005378:	ed52                	sd	s4,152(sp)
    8000537a:	f156                	sd	s5,160(sp)
    8000537c:	f55a                	sd	s6,168(sp)
    8000537e:	f95e                	sd	s7,176(sp)
    80005380:	fd62                	sd	s8,184(sp)
    80005382:	e1e6                	sd	s9,192(sp)
    80005384:	e5ea                	sd	s10,200(sp)
    80005386:	e9ee                	sd	s11,208(sp)
    80005388:	edf2                	sd	t3,216(sp)
    8000538a:	f1f6                	sd	t4,224(sp)
    8000538c:	f5fa                	sd	t5,232(sp)
    8000538e:	f9fe                	sd	t6,240(sp)
    80005390:	b17fc0ef          	jal	ra,80001ea6 <kerneltrap>
    80005394:	6082                	ld	ra,0(sp)
    80005396:	6122                	ld	sp,8(sp)
    80005398:	61c2                	ld	gp,16(sp)
    8000539a:	7282                	ld	t0,32(sp)
    8000539c:	7322                	ld	t1,40(sp)
    8000539e:	73c2                	ld	t2,48(sp)
    800053a0:	7462                	ld	s0,56(sp)
    800053a2:	6486                	ld	s1,64(sp)
    800053a4:	6526                	ld	a0,72(sp)
    800053a6:	65c6                	ld	a1,80(sp)
    800053a8:	6666                	ld	a2,88(sp)
    800053aa:	7686                	ld	a3,96(sp)
    800053ac:	7726                	ld	a4,104(sp)
    800053ae:	77c6                	ld	a5,112(sp)
    800053b0:	7866                	ld	a6,120(sp)
    800053b2:	688a                	ld	a7,128(sp)
    800053b4:	692a                	ld	s2,136(sp)
    800053b6:	69ca                	ld	s3,144(sp)
    800053b8:	6a6a                	ld	s4,152(sp)
    800053ba:	7a8a                	ld	s5,160(sp)
    800053bc:	7b2a                	ld	s6,168(sp)
    800053be:	7bca                	ld	s7,176(sp)
    800053c0:	7c6a                	ld	s8,184(sp)
    800053c2:	6c8e                	ld	s9,192(sp)
    800053c4:	6d2e                	ld	s10,200(sp)
    800053c6:	6dce                	ld	s11,208(sp)
    800053c8:	6e6e                	ld	t3,216(sp)
    800053ca:	7e8e                	ld	t4,224(sp)
    800053cc:	7f2e                	ld	t5,232(sp)
    800053ce:	7fce                	ld	t6,240(sp)
    800053d0:	6111                	addi	sp,sp,256
    800053d2:	10200073          	sret
    800053d6:	00000013          	nop
    800053da:	00000013          	nop
    800053de:	0001                	nop

00000000800053e0 <timervec>:
    800053e0:	34051573          	csrrw	a0,mscratch,a0
    800053e4:	e10c                	sd	a1,0(a0)
    800053e6:	e510                	sd	a2,8(a0)
    800053e8:	e914                	sd	a3,16(a0)
    800053ea:	6d0c                	ld	a1,24(a0)
    800053ec:	7110                	ld	a2,32(a0)
    800053ee:	6194                	ld	a3,0(a1)
    800053f0:	96b2                	add	a3,a3,a2
    800053f2:	e194                	sd	a3,0(a1)
    800053f4:	4589                	li	a1,2
    800053f6:	14459073          	csrw	sip,a1
    800053fa:	6914                	ld	a3,16(a0)
    800053fc:	6510                	ld	a2,8(a0)
    800053fe:	610c                	ld	a1,0(a0)
    80005400:	34051573          	csrrw	a0,mscratch,a0
    80005404:	30200073          	mret
	...

000000008000540a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000540a:	1141                	addi	sp,sp,-16
    8000540c:	e422                	sd	s0,8(sp)
    8000540e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005410:	0c0007b7          	lui	a5,0xc000
    80005414:	4705                	li	a4,1
    80005416:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005418:	c3d8                	sw	a4,4(a5)
}
    8000541a:	6422                	ld	s0,8(sp)
    8000541c:	0141                	addi	sp,sp,16
    8000541e:	8082                	ret

0000000080005420 <plicinithart>:

void
plicinithart(void)
{
    80005420:	1141                	addi	sp,sp,-16
    80005422:	e406                	sd	ra,8(sp)
    80005424:	e022                	sd	s0,0(sp)
    80005426:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005428:	ffffc097          	auipc	ra,0xffffc
    8000542c:	9ea080e7          	jalr	-1558(ra) # 80000e12 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005430:	0085171b          	slliw	a4,a0,0x8
    80005434:	0c0027b7          	lui	a5,0xc002
    80005438:	97ba                	add	a5,a5,a4
    8000543a:	40200713          	li	a4,1026
    8000543e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005442:	00d5151b          	slliw	a0,a0,0xd
    80005446:	0c2017b7          	lui	a5,0xc201
    8000544a:	953e                	add	a0,a0,a5
    8000544c:	00052023          	sw	zero,0(a0)
}
    80005450:	60a2                	ld	ra,8(sp)
    80005452:	6402                	ld	s0,0(sp)
    80005454:	0141                	addi	sp,sp,16
    80005456:	8082                	ret

0000000080005458 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005458:	1141                	addi	sp,sp,-16
    8000545a:	e406                	sd	ra,8(sp)
    8000545c:	e022                	sd	s0,0(sp)
    8000545e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005460:	ffffc097          	auipc	ra,0xffffc
    80005464:	9b2080e7          	jalr	-1614(ra) # 80000e12 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005468:	00d5179b          	slliw	a5,a0,0xd
    8000546c:	0c201537          	lui	a0,0xc201
    80005470:	953e                	add	a0,a0,a5
  return irq;
}
    80005472:	4148                	lw	a0,4(a0)
    80005474:	60a2                	ld	ra,8(sp)
    80005476:	6402                	ld	s0,0(sp)
    80005478:	0141                	addi	sp,sp,16
    8000547a:	8082                	ret

000000008000547c <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    8000547c:	1101                	addi	sp,sp,-32
    8000547e:	ec06                	sd	ra,24(sp)
    80005480:	e822                	sd	s0,16(sp)
    80005482:	e426                	sd	s1,8(sp)
    80005484:	1000                	addi	s0,sp,32
    80005486:	84aa                	mv	s1,a0
  int hart = cpuid();
    80005488:	ffffc097          	auipc	ra,0xffffc
    8000548c:	98a080e7          	jalr	-1654(ra) # 80000e12 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    80005490:	00d5151b          	slliw	a0,a0,0xd
    80005494:	0c2017b7          	lui	a5,0xc201
    80005498:	97aa                	add	a5,a5,a0
    8000549a:	c3c4                	sw	s1,4(a5)
}
    8000549c:	60e2                	ld	ra,24(sp)
    8000549e:	6442                	ld	s0,16(sp)
    800054a0:	64a2                	ld	s1,8(sp)
    800054a2:	6105                	addi	sp,sp,32
    800054a4:	8082                	ret

00000000800054a6 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800054a6:	1141                	addi	sp,sp,-16
    800054a8:	e406                	sd	ra,8(sp)
    800054aa:	e022                	sd	s0,0(sp)
    800054ac:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800054ae:	479d                	li	a5,7
    800054b0:	04a7cc63          	blt	a5,a0,80005508 <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    800054b4:	00026797          	auipc	a5,0x26
    800054b8:	53c78793          	addi	a5,a5,1340 # 8002b9f0 <disk>
    800054bc:	97aa                	add	a5,a5,a0
    800054be:	0187c783          	lbu	a5,24(a5)
    800054c2:	ebb9                	bnez	a5,80005518 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800054c4:	00451613          	slli	a2,a0,0x4
    800054c8:	00026797          	auipc	a5,0x26
    800054cc:	52878793          	addi	a5,a5,1320 # 8002b9f0 <disk>
    800054d0:	6394                	ld	a3,0(a5)
    800054d2:	96b2                	add	a3,a3,a2
    800054d4:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    800054d8:	6398                	ld	a4,0(a5)
    800054da:	9732                	add	a4,a4,a2
    800054dc:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    800054e0:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    800054e4:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    800054e8:	953e                	add	a0,a0,a5
    800054ea:	4785                	li	a5,1
    800054ec:	00f50c23          	sb	a5,24(a0) # c201018 <_entry-0x73dfefe8>
  wakeup(&disk.free[0]);
    800054f0:	00026517          	auipc	a0,0x26
    800054f4:	51850513          	addi	a0,a0,1304 # 8002ba08 <disk+0x18>
    800054f8:	ffffc097          	auipc	ra,0xffffc
    800054fc:	08e080e7          	jalr	142(ra) # 80001586 <wakeup>
}
    80005500:	60a2                	ld	ra,8(sp)
    80005502:	6402                	ld	s0,0(sp)
    80005504:	0141                	addi	sp,sp,16
    80005506:	8082                	ret
    panic("free_desc 1");
    80005508:	00003517          	auipc	a0,0x3
    8000550c:	1d050513          	addi	a0,a0,464 # 800086d8 <syscalls+0x318>
    80005510:	00001097          	auipc	ra,0x1
    80005514:	a72080e7          	jalr	-1422(ra) # 80005f82 <panic>
    panic("free_desc 2");
    80005518:	00003517          	auipc	a0,0x3
    8000551c:	1d050513          	addi	a0,a0,464 # 800086e8 <syscalls+0x328>
    80005520:	00001097          	auipc	ra,0x1
    80005524:	a62080e7          	jalr	-1438(ra) # 80005f82 <panic>

0000000080005528 <virtio_disk_init>:
{
    80005528:	1101                	addi	sp,sp,-32
    8000552a:	ec06                	sd	ra,24(sp)
    8000552c:	e822                	sd	s0,16(sp)
    8000552e:	e426                	sd	s1,8(sp)
    80005530:	e04a                	sd	s2,0(sp)
    80005532:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005534:	00003597          	auipc	a1,0x3
    80005538:	1c458593          	addi	a1,a1,452 # 800086f8 <syscalls+0x338>
    8000553c:	00026517          	auipc	a0,0x26
    80005540:	5dc50513          	addi	a0,a0,1500 # 8002bb18 <disk+0x128>
    80005544:	00001097          	auipc	ra,0x1
    80005548:	ef8080e7          	jalr	-264(ra) # 8000643c <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000554c:	100017b7          	lui	a5,0x10001
    80005550:	4398                	lw	a4,0(a5)
    80005552:	2701                	sext.w	a4,a4
    80005554:	747277b7          	lui	a5,0x74727
    80005558:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    8000555c:	14f71e63          	bne	a4,a5,800056b8 <virtio_disk_init+0x190>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005560:	100017b7          	lui	a5,0x10001
    80005564:	43dc                	lw	a5,4(a5)
    80005566:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005568:	4709                	li	a4,2
    8000556a:	14e79763          	bne	a5,a4,800056b8 <virtio_disk_init+0x190>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000556e:	100017b7          	lui	a5,0x10001
    80005572:	479c                	lw	a5,8(a5)
    80005574:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005576:	14e79163          	bne	a5,a4,800056b8 <virtio_disk_init+0x190>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    8000557a:	100017b7          	lui	a5,0x10001
    8000557e:	47d8                	lw	a4,12(a5)
    80005580:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    80005582:	554d47b7          	lui	a5,0x554d4
    80005586:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    8000558a:	12f71763          	bne	a4,a5,800056b8 <virtio_disk_init+0x190>
  *R(VIRTIO_MMIO_STATUS) = status;
    8000558e:	100017b7          	lui	a5,0x10001
    80005592:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    80005596:	4705                	li	a4,1
    80005598:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    8000559a:	470d                	li	a4,3
    8000559c:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    8000559e:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800055a0:	c7ffe737          	lui	a4,0xc7ffe
    800055a4:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fca9ef>
    800055a8:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800055aa:	2701                	sext.w	a4,a4
    800055ac:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800055ae:	472d                	li	a4,11
    800055b0:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    800055b2:	0707a903          	lw	s2,112(a5)
    800055b6:	2901                	sext.w	s2,s2
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    800055b8:	00897793          	andi	a5,s2,8
    800055bc:	10078663          	beqz	a5,800056c8 <virtio_disk_init+0x1a0>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800055c0:	100017b7          	lui	a5,0x10001
    800055c4:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    800055c8:	43fc                	lw	a5,68(a5)
    800055ca:	2781                	sext.w	a5,a5
    800055cc:	10079663          	bnez	a5,800056d8 <virtio_disk_init+0x1b0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    800055d0:	100017b7          	lui	a5,0x10001
    800055d4:	5bdc                	lw	a5,52(a5)
    800055d6:	2781                	sext.w	a5,a5
  if(max == 0)
    800055d8:	10078863          	beqz	a5,800056e8 <virtio_disk_init+0x1c0>
  if(max < NUM)
    800055dc:	471d                	li	a4,7
    800055de:	10f77d63          	bgeu	a4,a5,800056f8 <virtio_disk_init+0x1d0>
  disk.desc = kalloc();
    800055e2:	ffffb097          	auipc	ra,0xffffb
    800055e6:	b36080e7          	jalr	-1226(ra) # 80000118 <kalloc>
    800055ea:	00026497          	auipc	s1,0x26
    800055ee:	40648493          	addi	s1,s1,1030 # 8002b9f0 <disk>
    800055f2:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    800055f4:	ffffb097          	auipc	ra,0xffffb
    800055f8:	b24080e7          	jalr	-1244(ra) # 80000118 <kalloc>
    800055fc:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    800055fe:	ffffb097          	auipc	ra,0xffffb
    80005602:	b1a080e7          	jalr	-1254(ra) # 80000118 <kalloc>
    80005606:	87aa                	mv	a5,a0
    80005608:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    8000560a:	6088                	ld	a0,0(s1)
    8000560c:	cd75                	beqz	a0,80005708 <virtio_disk_init+0x1e0>
    8000560e:	00026717          	auipc	a4,0x26
    80005612:	3ea73703          	ld	a4,1002(a4) # 8002b9f8 <disk+0x8>
    80005616:	cb6d                	beqz	a4,80005708 <virtio_disk_init+0x1e0>
    80005618:	cbe5                	beqz	a5,80005708 <virtio_disk_init+0x1e0>
  memset(disk.desc, 0, PGSIZE);
    8000561a:	6605                	lui	a2,0x1
    8000561c:	4581                	li	a1,0
    8000561e:	ffffb097          	auipc	ra,0xffffb
    80005622:	b5a080e7          	jalr	-1190(ra) # 80000178 <memset>
  memset(disk.avail, 0, PGSIZE);
    80005626:	00026497          	auipc	s1,0x26
    8000562a:	3ca48493          	addi	s1,s1,970 # 8002b9f0 <disk>
    8000562e:	6605                	lui	a2,0x1
    80005630:	4581                	li	a1,0
    80005632:	6488                	ld	a0,8(s1)
    80005634:	ffffb097          	auipc	ra,0xffffb
    80005638:	b44080e7          	jalr	-1212(ra) # 80000178 <memset>
  memset(disk.used, 0, PGSIZE);
    8000563c:	6605                	lui	a2,0x1
    8000563e:	4581                	li	a1,0
    80005640:	6888                	ld	a0,16(s1)
    80005642:	ffffb097          	auipc	ra,0xffffb
    80005646:	b36080e7          	jalr	-1226(ra) # 80000178 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    8000564a:	100017b7          	lui	a5,0x10001
    8000564e:	4721                	li	a4,8
    80005650:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80005652:	4098                	lw	a4,0(s1)
    80005654:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80005658:	40d8                	lw	a4,4(s1)
    8000565a:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    8000565e:	6498                	ld	a4,8(s1)
    80005660:	0007069b          	sext.w	a3,a4
    80005664:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80005668:	9701                	srai	a4,a4,0x20
    8000566a:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    8000566e:	6898                	ld	a4,16(s1)
    80005670:	0007069b          	sext.w	a3,a4
    80005674:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    80005678:	9701                	srai	a4,a4,0x20
    8000567a:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    8000567e:	4685                	li	a3,1
    80005680:	c3f4                	sw	a3,68(a5)
    disk.free[i] = 1;
    80005682:	4705                	li	a4,1
    80005684:	00d48c23          	sb	a3,24(s1)
    80005688:	00e48ca3          	sb	a4,25(s1)
    8000568c:	00e48d23          	sb	a4,26(s1)
    80005690:	00e48da3          	sb	a4,27(s1)
    80005694:	00e48e23          	sb	a4,28(s1)
    80005698:	00e48ea3          	sb	a4,29(s1)
    8000569c:	00e48f23          	sb	a4,30(s1)
    800056a0:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    800056a4:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    800056a8:	0727a823          	sw	s2,112(a5)
}
    800056ac:	60e2                	ld	ra,24(sp)
    800056ae:	6442                	ld	s0,16(sp)
    800056b0:	64a2                	ld	s1,8(sp)
    800056b2:	6902                	ld	s2,0(sp)
    800056b4:	6105                	addi	sp,sp,32
    800056b6:	8082                	ret
    panic("could not find virtio disk");
    800056b8:	00003517          	auipc	a0,0x3
    800056bc:	05050513          	addi	a0,a0,80 # 80008708 <syscalls+0x348>
    800056c0:	00001097          	auipc	ra,0x1
    800056c4:	8c2080e7          	jalr	-1854(ra) # 80005f82 <panic>
    panic("virtio disk FEATURES_OK unset");
    800056c8:	00003517          	auipc	a0,0x3
    800056cc:	06050513          	addi	a0,a0,96 # 80008728 <syscalls+0x368>
    800056d0:	00001097          	auipc	ra,0x1
    800056d4:	8b2080e7          	jalr	-1870(ra) # 80005f82 <panic>
    panic("virtio disk should not be ready");
    800056d8:	00003517          	auipc	a0,0x3
    800056dc:	07050513          	addi	a0,a0,112 # 80008748 <syscalls+0x388>
    800056e0:	00001097          	auipc	ra,0x1
    800056e4:	8a2080e7          	jalr	-1886(ra) # 80005f82 <panic>
    panic("virtio disk has no queue 0");
    800056e8:	00003517          	auipc	a0,0x3
    800056ec:	08050513          	addi	a0,a0,128 # 80008768 <syscalls+0x3a8>
    800056f0:	00001097          	auipc	ra,0x1
    800056f4:	892080e7          	jalr	-1902(ra) # 80005f82 <panic>
    panic("virtio disk max queue too short");
    800056f8:	00003517          	auipc	a0,0x3
    800056fc:	09050513          	addi	a0,a0,144 # 80008788 <syscalls+0x3c8>
    80005700:	00001097          	auipc	ra,0x1
    80005704:	882080e7          	jalr	-1918(ra) # 80005f82 <panic>
    panic("virtio disk kalloc");
    80005708:	00003517          	auipc	a0,0x3
    8000570c:	0a050513          	addi	a0,a0,160 # 800087a8 <syscalls+0x3e8>
    80005710:	00001097          	auipc	ra,0x1
    80005714:	872080e7          	jalr	-1934(ra) # 80005f82 <panic>

0000000080005718 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005718:	7159                	addi	sp,sp,-112
    8000571a:	f486                	sd	ra,104(sp)
    8000571c:	f0a2                	sd	s0,96(sp)
    8000571e:	eca6                	sd	s1,88(sp)
    80005720:	e8ca                	sd	s2,80(sp)
    80005722:	e4ce                	sd	s3,72(sp)
    80005724:	e0d2                	sd	s4,64(sp)
    80005726:	fc56                	sd	s5,56(sp)
    80005728:	f85a                	sd	s6,48(sp)
    8000572a:	f45e                	sd	s7,40(sp)
    8000572c:	f062                	sd	s8,32(sp)
    8000572e:	ec66                	sd	s9,24(sp)
    80005730:	e86a                	sd	s10,16(sp)
    80005732:	1880                	addi	s0,sp,112
    80005734:	892a                	mv	s2,a0
    80005736:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005738:	00c52c83          	lw	s9,12(a0)
    8000573c:	001c9c9b          	slliw	s9,s9,0x1
    80005740:	1c82                	slli	s9,s9,0x20
    80005742:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005746:	00026517          	auipc	a0,0x26
    8000574a:	3d250513          	addi	a0,a0,978 # 8002bb18 <disk+0x128>
    8000574e:	00001097          	auipc	ra,0x1
    80005752:	d7e080e7          	jalr	-642(ra) # 800064cc <acquire>
  for(int i = 0; i < 3; i++){
    80005756:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005758:	4ba1                	li	s7,8
      disk.free[i] = 0;
    8000575a:	00026b17          	auipc	s6,0x26
    8000575e:	296b0b13          	addi	s6,s6,662 # 8002b9f0 <disk>
  for(int i = 0; i < 3; i++){
    80005762:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    80005764:	8a4e                	mv	s4,s3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005766:	00026c17          	auipc	s8,0x26
    8000576a:	3b2c0c13          	addi	s8,s8,946 # 8002bb18 <disk+0x128>
    8000576e:	a8b5                	j	800057ea <virtio_disk_rw+0xd2>
      disk.free[i] = 0;
    80005770:	00fb06b3          	add	a3,s6,a5
    80005774:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    80005778:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    8000577a:	0207c563          	bltz	a5,800057a4 <virtio_disk_rw+0x8c>
  for(int i = 0; i < 3; i++){
    8000577e:	2485                	addiw	s1,s1,1
    80005780:	0711                	addi	a4,a4,4
    80005782:	1f548a63          	beq	s1,s5,80005976 <virtio_disk_rw+0x25e>
    idx[i] = alloc_desc();
    80005786:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    80005788:	00026697          	auipc	a3,0x26
    8000578c:	26868693          	addi	a3,a3,616 # 8002b9f0 <disk>
    80005790:	87d2                	mv	a5,s4
    if(disk.free[i]){
    80005792:	0186c583          	lbu	a1,24(a3)
    80005796:	fde9                	bnez	a1,80005770 <virtio_disk_rw+0x58>
  for(int i = 0; i < NUM; i++){
    80005798:	2785                	addiw	a5,a5,1
    8000579a:	0685                	addi	a3,a3,1
    8000579c:	ff779be3          	bne	a5,s7,80005792 <virtio_disk_rw+0x7a>
    idx[i] = alloc_desc();
    800057a0:	57fd                	li	a5,-1
    800057a2:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    800057a4:	02905a63          	blez	s1,800057d8 <virtio_disk_rw+0xc0>
        free_desc(idx[j]);
    800057a8:	f9042503          	lw	a0,-112(s0)
    800057ac:	00000097          	auipc	ra,0x0
    800057b0:	cfa080e7          	jalr	-774(ra) # 800054a6 <free_desc>
      for(int j = 0; j < i; j++)
    800057b4:	4785                	li	a5,1
    800057b6:	0297d163          	bge	a5,s1,800057d8 <virtio_disk_rw+0xc0>
        free_desc(idx[j]);
    800057ba:	f9442503          	lw	a0,-108(s0)
    800057be:	00000097          	auipc	ra,0x0
    800057c2:	ce8080e7          	jalr	-792(ra) # 800054a6 <free_desc>
      for(int j = 0; j < i; j++)
    800057c6:	4789                	li	a5,2
    800057c8:	0097d863          	bge	a5,s1,800057d8 <virtio_disk_rw+0xc0>
        free_desc(idx[j]);
    800057cc:	f9842503          	lw	a0,-104(s0)
    800057d0:	00000097          	auipc	ra,0x0
    800057d4:	cd6080e7          	jalr	-810(ra) # 800054a6 <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    800057d8:	85e2                	mv	a1,s8
    800057da:	00026517          	auipc	a0,0x26
    800057de:	22e50513          	addi	a0,a0,558 # 8002ba08 <disk+0x18>
    800057e2:	ffffc097          	auipc	ra,0xffffc
    800057e6:	d40080e7          	jalr	-704(ra) # 80001522 <sleep>
  for(int i = 0; i < 3; i++){
    800057ea:	f9040713          	addi	a4,s0,-112
    800057ee:	84ce                	mv	s1,s3
    800057f0:	bf59                	j	80005786 <virtio_disk_rw+0x6e>
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

  if(write)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    800057f2:	00a60793          	addi	a5,a2,10 # 100a <_entry-0x7fffeff6>
    800057f6:	00479693          	slli	a3,a5,0x4
    800057fa:	00026797          	auipc	a5,0x26
    800057fe:	1f678793          	addi	a5,a5,502 # 8002b9f0 <disk>
    80005802:	97b6                	add	a5,a5,a3
    80005804:	4685                	li	a3,1
    80005806:	c794                	sw	a3,8(a5)
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80005808:	00026597          	auipc	a1,0x26
    8000580c:	1e858593          	addi	a1,a1,488 # 8002b9f0 <disk>
    80005810:	00a60793          	addi	a5,a2,10
    80005814:	0792                	slli	a5,a5,0x4
    80005816:	97ae                	add	a5,a5,a1
    80005818:	0007a623          	sw	zero,12(a5)
  buf0->sector = sector;
    8000581c:	0197b823          	sd	s9,16(a5)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005820:	f6070693          	addi	a3,a4,-160
    80005824:	619c                	ld	a5,0(a1)
    80005826:	97b6                	add	a5,a5,a3
    80005828:	e388                	sd	a0,0(a5)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    8000582a:	6188                	ld	a0,0(a1)
    8000582c:	96aa                	add	a3,a3,a0
    8000582e:	47c1                	li	a5,16
    80005830:	c69c                	sw	a5,8(a3)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005832:	4785                	li	a5,1
    80005834:	00f69623          	sh	a5,12(a3)
  disk.desc[idx[0]].next = idx[1];
    80005838:	f9442783          	lw	a5,-108(s0)
    8000583c:	00f69723          	sh	a5,14(a3)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005840:	0792                	slli	a5,a5,0x4
    80005842:	953e                	add	a0,a0,a5
    80005844:	05890693          	addi	a3,s2,88
    80005848:	e114                	sd	a3,0(a0)
  disk.desc[idx[1]].len = BSIZE;
    8000584a:	6188                	ld	a0,0(a1)
    8000584c:	97aa                	add	a5,a5,a0
    8000584e:	40000693          	li	a3,1024
    80005852:	c794                	sw	a3,8(a5)
  if(write)
    80005854:	100d0d63          	beqz	s10,8000596e <virtio_disk_rw+0x256>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    80005858:	00079623          	sh	zero,12(a5)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000585c:	00c7d683          	lhu	a3,12(a5)
    80005860:	0016e693          	ori	a3,a3,1
    80005864:	00d79623          	sh	a3,12(a5)
  disk.desc[idx[1]].next = idx[2];
    80005868:	f9842583          	lw	a1,-104(s0)
    8000586c:	00b79723          	sh	a1,14(a5)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    80005870:	00026697          	auipc	a3,0x26
    80005874:	18068693          	addi	a3,a3,384 # 8002b9f0 <disk>
    80005878:	00260793          	addi	a5,a2,2
    8000587c:	0792                	slli	a5,a5,0x4
    8000587e:	97b6                	add	a5,a5,a3
    80005880:	587d                	li	a6,-1
    80005882:	01078823          	sb	a6,16(a5)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    80005886:	0592                	slli	a1,a1,0x4
    80005888:	952e                	add	a0,a0,a1
    8000588a:	f9070713          	addi	a4,a4,-112
    8000588e:	9736                	add	a4,a4,a3
    80005890:	e118                	sd	a4,0(a0)
  disk.desc[idx[2]].len = 1;
    80005892:	6298                	ld	a4,0(a3)
    80005894:	972e                	add	a4,a4,a1
    80005896:	4585                	li	a1,1
    80005898:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    8000589a:	4509                	li	a0,2
    8000589c:	00a71623          	sh	a0,12(a4)
  disk.desc[idx[2]].next = 0;
    800058a0:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800058a4:	00b92223          	sw	a1,4(s2)
  disk.info[idx[0]].b = b;
    800058a8:	0127b423          	sd	s2,8(a5)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800058ac:	6698                	ld	a4,8(a3)
    800058ae:	00275783          	lhu	a5,2(a4)
    800058b2:	8b9d                	andi	a5,a5,7
    800058b4:	0786                	slli	a5,a5,0x1
    800058b6:	97ba                	add	a5,a5,a4
    800058b8:	00c79223          	sh	a2,4(a5)

  __sync_synchronize();
    800058bc:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800058c0:	6698                	ld	a4,8(a3)
    800058c2:	00275783          	lhu	a5,2(a4)
    800058c6:	2785                	addiw	a5,a5,1
    800058c8:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800058cc:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    800058d0:	100017b7          	lui	a5,0x10001
    800058d4:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    800058d8:	00492703          	lw	a4,4(s2)
    800058dc:	4785                	li	a5,1
    800058de:	02f71163          	bne	a4,a5,80005900 <virtio_disk_rw+0x1e8>
    sleep(b, &disk.vdisk_lock);
    800058e2:	00026997          	auipc	s3,0x26
    800058e6:	23698993          	addi	s3,s3,566 # 8002bb18 <disk+0x128>
  while(b->disk == 1) {
    800058ea:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    800058ec:	85ce                	mv	a1,s3
    800058ee:	854a                	mv	a0,s2
    800058f0:	ffffc097          	auipc	ra,0xffffc
    800058f4:	c32080e7          	jalr	-974(ra) # 80001522 <sleep>
  while(b->disk == 1) {
    800058f8:	00492783          	lw	a5,4(s2)
    800058fc:	fe9788e3          	beq	a5,s1,800058ec <virtio_disk_rw+0x1d4>
  }

  disk.info[idx[0]].b = 0;
    80005900:	f9042903          	lw	s2,-112(s0)
    80005904:	00290793          	addi	a5,s2,2
    80005908:	00479713          	slli	a4,a5,0x4
    8000590c:	00026797          	auipc	a5,0x26
    80005910:	0e478793          	addi	a5,a5,228 # 8002b9f0 <disk>
    80005914:	97ba                	add	a5,a5,a4
    80005916:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    8000591a:	00026997          	auipc	s3,0x26
    8000591e:	0d698993          	addi	s3,s3,214 # 8002b9f0 <disk>
    80005922:	00491713          	slli	a4,s2,0x4
    80005926:	0009b783          	ld	a5,0(s3)
    8000592a:	97ba                	add	a5,a5,a4
    8000592c:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005930:	854a                	mv	a0,s2
    80005932:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005936:	00000097          	auipc	ra,0x0
    8000593a:	b70080e7          	jalr	-1168(ra) # 800054a6 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    8000593e:	8885                	andi	s1,s1,1
    80005940:	f0ed                	bnez	s1,80005922 <virtio_disk_rw+0x20a>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005942:	00026517          	auipc	a0,0x26
    80005946:	1d650513          	addi	a0,a0,470 # 8002bb18 <disk+0x128>
    8000594a:	00001097          	auipc	ra,0x1
    8000594e:	c36080e7          	jalr	-970(ra) # 80006580 <release>
}
    80005952:	70a6                	ld	ra,104(sp)
    80005954:	7406                	ld	s0,96(sp)
    80005956:	64e6                	ld	s1,88(sp)
    80005958:	6946                	ld	s2,80(sp)
    8000595a:	69a6                	ld	s3,72(sp)
    8000595c:	6a06                	ld	s4,64(sp)
    8000595e:	7ae2                	ld	s5,56(sp)
    80005960:	7b42                	ld	s6,48(sp)
    80005962:	7ba2                	ld	s7,40(sp)
    80005964:	7c02                	ld	s8,32(sp)
    80005966:	6ce2                	ld	s9,24(sp)
    80005968:	6d42                	ld	s10,16(sp)
    8000596a:	6165                	addi	sp,sp,112
    8000596c:	8082                	ret
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    8000596e:	4689                	li	a3,2
    80005970:	00d79623          	sh	a3,12(a5)
    80005974:	b5e5                	j	8000585c <virtio_disk_rw+0x144>
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005976:	f9042603          	lw	a2,-112(s0)
    8000597a:	00a60713          	addi	a4,a2,10
    8000597e:	0712                	slli	a4,a4,0x4
    80005980:	00026517          	auipc	a0,0x26
    80005984:	07850513          	addi	a0,a0,120 # 8002b9f8 <disk+0x8>
    80005988:	953a                	add	a0,a0,a4
  if(write)
    8000598a:	e60d14e3          	bnez	s10,800057f2 <virtio_disk_rw+0xda>
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    8000598e:	00a60793          	addi	a5,a2,10
    80005992:	00479693          	slli	a3,a5,0x4
    80005996:	00026797          	auipc	a5,0x26
    8000599a:	05a78793          	addi	a5,a5,90 # 8002b9f0 <disk>
    8000599e:	97b6                	add	a5,a5,a3
    800059a0:	0007a423          	sw	zero,8(a5)
    800059a4:	b595                	j	80005808 <virtio_disk_rw+0xf0>

00000000800059a6 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800059a6:	1101                	addi	sp,sp,-32
    800059a8:	ec06                	sd	ra,24(sp)
    800059aa:	e822                	sd	s0,16(sp)
    800059ac:	e426                	sd	s1,8(sp)
    800059ae:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800059b0:	00026497          	auipc	s1,0x26
    800059b4:	04048493          	addi	s1,s1,64 # 8002b9f0 <disk>
    800059b8:	00026517          	auipc	a0,0x26
    800059bc:	16050513          	addi	a0,a0,352 # 8002bb18 <disk+0x128>
    800059c0:	00001097          	auipc	ra,0x1
    800059c4:	b0c080e7          	jalr	-1268(ra) # 800064cc <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800059c8:	10001737          	lui	a4,0x10001
    800059cc:	533c                	lw	a5,96(a4)
    800059ce:	8b8d                	andi	a5,a5,3
    800059d0:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    800059d2:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    800059d6:	689c                	ld	a5,16(s1)
    800059d8:	0204d703          	lhu	a4,32(s1)
    800059dc:	0027d783          	lhu	a5,2(a5)
    800059e0:	04f70863          	beq	a4,a5,80005a30 <virtio_disk_intr+0x8a>
    __sync_synchronize();
    800059e4:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    800059e8:	6898                	ld	a4,16(s1)
    800059ea:	0204d783          	lhu	a5,32(s1)
    800059ee:	8b9d                	andi	a5,a5,7
    800059f0:	078e                	slli	a5,a5,0x3
    800059f2:	97ba                	add	a5,a5,a4
    800059f4:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    800059f6:	00278713          	addi	a4,a5,2
    800059fa:	0712                	slli	a4,a4,0x4
    800059fc:	9726                	add	a4,a4,s1
    800059fe:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    80005a02:	e721                	bnez	a4,80005a4a <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005a04:	0789                	addi	a5,a5,2
    80005a06:	0792                	slli	a5,a5,0x4
    80005a08:	97a6                	add	a5,a5,s1
    80005a0a:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80005a0c:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005a10:	ffffc097          	auipc	ra,0xffffc
    80005a14:	b76080e7          	jalr	-1162(ra) # 80001586 <wakeup>

    disk.used_idx += 1;
    80005a18:	0204d783          	lhu	a5,32(s1)
    80005a1c:	2785                	addiw	a5,a5,1
    80005a1e:	17c2                	slli	a5,a5,0x30
    80005a20:	93c1                	srli	a5,a5,0x30
    80005a22:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005a26:	6898                	ld	a4,16(s1)
    80005a28:	00275703          	lhu	a4,2(a4)
    80005a2c:	faf71ce3          	bne	a4,a5,800059e4 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80005a30:	00026517          	auipc	a0,0x26
    80005a34:	0e850513          	addi	a0,a0,232 # 8002bb18 <disk+0x128>
    80005a38:	00001097          	auipc	ra,0x1
    80005a3c:	b48080e7          	jalr	-1208(ra) # 80006580 <release>
}
    80005a40:	60e2                	ld	ra,24(sp)
    80005a42:	6442                	ld	s0,16(sp)
    80005a44:	64a2                	ld	s1,8(sp)
    80005a46:	6105                	addi	sp,sp,32
    80005a48:	8082                	ret
      panic("virtio_disk_intr status");
    80005a4a:	00003517          	auipc	a0,0x3
    80005a4e:	d7650513          	addi	a0,a0,-650 # 800087c0 <syscalls+0x400>
    80005a52:	00000097          	auipc	ra,0x0
    80005a56:	530080e7          	jalr	1328(ra) # 80005f82 <panic>

0000000080005a5a <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005a5a:	1141                	addi	sp,sp,-16
    80005a5c:	e422                	sd	s0,8(sp)
    80005a5e:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005a60:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005a64:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005a68:	0037979b          	slliw	a5,a5,0x3
    80005a6c:	02004737          	lui	a4,0x2004
    80005a70:	97ba                	add	a5,a5,a4
    80005a72:	0200c737          	lui	a4,0x200c
    80005a76:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005a7a:	000f4637          	lui	a2,0xf4
    80005a7e:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005a82:	95b2                	add	a1,a1,a2
    80005a84:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005a86:	00269713          	slli	a4,a3,0x2
    80005a8a:	9736                	add	a4,a4,a3
    80005a8c:	00371693          	slli	a3,a4,0x3
    80005a90:	00026717          	auipc	a4,0x26
    80005a94:	0a070713          	addi	a4,a4,160 # 8002bb30 <timer_scratch>
    80005a98:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005a9a:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80005a9c:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80005a9e:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80005aa2:	00000797          	auipc	a5,0x0
    80005aa6:	93e78793          	addi	a5,a5,-1730 # 800053e0 <timervec>
    80005aaa:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005aae:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80005ab2:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005ab6:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005aba:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80005abe:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80005ac2:	30479073          	csrw	mie,a5
}
    80005ac6:	6422                	ld	s0,8(sp)
    80005ac8:	0141                	addi	sp,sp,16
    80005aca:	8082                	ret

0000000080005acc <start>:
{
    80005acc:	1141                	addi	sp,sp,-16
    80005ace:	e406                	sd	ra,8(sp)
    80005ad0:	e022                	sd	s0,0(sp)
    80005ad2:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005ad4:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005ad8:	7779                	lui	a4,0xffffe
    80005ada:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffcaa8f>
    80005ade:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80005ae0:	6705                	lui	a4,0x1
    80005ae2:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005ae6:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005ae8:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005aec:	ffffb797          	auipc	a5,0xffffb
    80005af0:	83a78793          	addi	a5,a5,-1990 # 80000326 <main>
    80005af4:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005af8:	4781                	li	a5,0
    80005afa:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005afe:	67c1                	lui	a5,0x10
    80005b00:	17fd                	addi	a5,a5,-1
    80005b02:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005b06:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005b0a:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005b0e:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005b12:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005b16:	57fd                	li	a5,-1
    80005b18:	83a9                	srli	a5,a5,0xa
    80005b1a:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005b1e:	47bd                	li	a5,15
    80005b20:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005b24:	00000097          	auipc	ra,0x0
    80005b28:	f36080e7          	jalr	-202(ra) # 80005a5a <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005b2c:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005b30:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005b32:	823e                	mv	tp,a5
  asm volatile("mret");
    80005b34:	30200073          	mret
}
    80005b38:	60a2                	ld	ra,8(sp)
    80005b3a:	6402                	ld	s0,0(sp)
    80005b3c:	0141                	addi	sp,sp,16
    80005b3e:	8082                	ret

0000000080005b40 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005b40:	715d                	addi	sp,sp,-80
    80005b42:	e486                	sd	ra,72(sp)
    80005b44:	e0a2                	sd	s0,64(sp)
    80005b46:	fc26                	sd	s1,56(sp)
    80005b48:	f84a                	sd	s2,48(sp)
    80005b4a:	f44e                	sd	s3,40(sp)
    80005b4c:	f052                	sd	s4,32(sp)
    80005b4e:	ec56                	sd	s5,24(sp)
    80005b50:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005b52:	04c05663          	blez	a2,80005b9e <consolewrite+0x5e>
    80005b56:	8a2a                	mv	s4,a0
    80005b58:	84ae                	mv	s1,a1
    80005b5a:	89b2                	mv	s3,a2
    80005b5c:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005b5e:	5afd                	li	s5,-1
    80005b60:	4685                	li	a3,1
    80005b62:	8626                	mv	a2,s1
    80005b64:	85d2                	mv	a1,s4
    80005b66:	fbf40513          	addi	a0,s0,-65
    80005b6a:	ffffc097          	auipc	ra,0xffffc
    80005b6e:	e16080e7          	jalr	-490(ra) # 80001980 <either_copyin>
    80005b72:	01550c63          	beq	a0,s5,80005b8a <consolewrite+0x4a>
      break;
    uartputc(c);
    80005b76:	fbf44503          	lbu	a0,-65(s0)
    80005b7a:	00000097          	auipc	ra,0x0
    80005b7e:	794080e7          	jalr	1940(ra) # 8000630e <uartputc>
  for(i = 0; i < n; i++){
    80005b82:	2905                	addiw	s2,s2,1
    80005b84:	0485                	addi	s1,s1,1
    80005b86:	fd299de3          	bne	s3,s2,80005b60 <consolewrite+0x20>
  }

  return i;
}
    80005b8a:	854a                	mv	a0,s2
    80005b8c:	60a6                	ld	ra,72(sp)
    80005b8e:	6406                	ld	s0,64(sp)
    80005b90:	74e2                	ld	s1,56(sp)
    80005b92:	7942                	ld	s2,48(sp)
    80005b94:	79a2                	ld	s3,40(sp)
    80005b96:	7a02                	ld	s4,32(sp)
    80005b98:	6ae2                	ld	s5,24(sp)
    80005b9a:	6161                	addi	sp,sp,80
    80005b9c:	8082                	ret
  for(i = 0; i < n; i++){
    80005b9e:	4901                	li	s2,0
    80005ba0:	b7ed                	j	80005b8a <consolewrite+0x4a>

0000000080005ba2 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005ba2:	7119                	addi	sp,sp,-128
    80005ba4:	fc86                	sd	ra,120(sp)
    80005ba6:	f8a2                	sd	s0,112(sp)
    80005ba8:	f4a6                	sd	s1,104(sp)
    80005baa:	f0ca                	sd	s2,96(sp)
    80005bac:	ecce                	sd	s3,88(sp)
    80005bae:	e8d2                	sd	s4,80(sp)
    80005bb0:	e4d6                	sd	s5,72(sp)
    80005bb2:	e0da                	sd	s6,64(sp)
    80005bb4:	fc5e                	sd	s7,56(sp)
    80005bb6:	f862                	sd	s8,48(sp)
    80005bb8:	f466                	sd	s9,40(sp)
    80005bba:	f06a                	sd	s10,32(sp)
    80005bbc:	ec6e                	sd	s11,24(sp)
    80005bbe:	0100                	addi	s0,sp,128
    80005bc0:	8b2a                	mv	s6,a0
    80005bc2:	8aae                	mv	s5,a1
    80005bc4:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005bc6:	00060b9b          	sext.w	s7,a2
  acquire(&cons.lock);
    80005bca:	0002e517          	auipc	a0,0x2e
    80005bce:	0a650513          	addi	a0,a0,166 # 80033c70 <cons>
    80005bd2:	00001097          	auipc	ra,0x1
    80005bd6:	8fa080e7          	jalr	-1798(ra) # 800064cc <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005bda:	0002e497          	auipc	s1,0x2e
    80005bde:	09648493          	addi	s1,s1,150 # 80033c70 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005be2:	89a6                	mv	s3,s1
    80005be4:	0002e917          	auipc	s2,0x2e
    80005be8:	12490913          	addi	s2,s2,292 # 80033d08 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];

    if(c == C('D')){  // end-of-file
    80005bec:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005bee:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    80005bf0:	4da9                	li	s11,10
  while(n > 0){
    80005bf2:	07405b63          	blez	s4,80005c68 <consoleread+0xc6>
    while(cons.r == cons.w){
    80005bf6:	0984a783          	lw	a5,152(s1)
    80005bfa:	09c4a703          	lw	a4,156(s1)
    80005bfe:	02f71763          	bne	a4,a5,80005c2c <consoleread+0x8a>
      if(killed(myproc())){
    80005c02:	ffffb097          	auipc	ra,0xffffb
    80005c06:	23c080e7          	jalr	572(ra) # 80000e3e <myproc>
    80005c0a:	ffffc097          	auipc	ra,0xffffc
    80005c0e:	bc0080e7          	jalr	-1088(ra) # 800017ca <killed>
    80005c12:	e535                	bnez	a0,80005c7e <consoleread+0xdc>
      sleep(&cons.r, &cons.lock);
    80005c14:	85ce                	mv	a1,s3
    80005c16:	854a                	mv	a0,s2
    80005c18:	ffffc097          	auipc	ra,0xffffc
    80005c1c:	90a080e7          	jalr	-1782(ra) # 80001522 <sleep>
    while(cons.r == cons.w){
    80005c20:	0984a783          	lw	a5,152(s1)
    80005c24:	09c4a703          	lw	a4,156(s1)
    80005c28:	fcf70de3          	beq	a4,a5,80005c02 <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80005c2c:	0017871b          	addiw	a4,a5,1
    80005c30:	08e4ac23          	sw	a4,152(s1)
    80005c34:	07f7f713          	andi	a4,a5,127
    80005c38:	9726                	add	a4,a4,s1
    80005c3a:	01874703          	lbu	a4,24(a4)
    80005c3e:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    80005c42:	079c0663          	beq	s8,s9,80005cae <consoleread+0x10c>
    cbuf = c;
    80005c46:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005c4a:	4685                	li	a3,1
    80005c4c:	f8f40613          	addi	a2,s0,-113
    80005c50:	85d6                	mv	a1,s5
    80005c52:	855a                	mv	a0,s6
    80005c54:	ffffc097          	auipc	ra,0xffffc
    80005c58:	cd6080e7          	jalr	-810(ra) # 8000192a <either_copyout>
    80005c5c:	01a50663          	beq	a0,s10,80005c68 <consoleread+0xc6>
    dst++;
    80005c60:	0a85                	addi	s5,s5,1
    --n;
    80005c62:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    80005c64:	f9bc17e3          	bne	s8,s11,80005bf2 <consoleread+0x50>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005c68:	0002e517          	auipc	a0,0x2e
    80005c6c:	00850513          	addi	a0,a0,8 # 80033c70 <cons>
    80005c70:	00001097          	auipc	ra,0x1
    80005c74:	910080e7          	jalr	-1776(ra) # 80006580 <release>

  return target - n;
    80005c78:	414b853b          	subw	a0,s7,s4
    80005c7c:	a811                	j	80005c90 <consoleread+0xee>
        release(&cons.lock);
    80005c7e:	0002e517          	auipc	a0,0x2e
    80005c82:	ff250513          	addi	a0,a0,-14 # 80033c70 <cons>
    80005c86:	00001097          	auipc	ra,0x1
    80005c8a:	8fa080e7          	jalr	-1798(ra) # 80006580 <release>
        return -1;
    80005c8e:	557d                	li	a0,-1
}
    80005c90:	70e6                	ld	ra,120(sp)
    80005c92:	7446                	ld	s0,112(sp)
    80005c94:	74a6                	ld	s1,104(sp)
    80005c96:	7906                	ld	s2,96(sp)
    80005c98:	69e6                	ld	s3,88(sp)
    80005c9a:	6a46                	ld	s4,80(sp)
    80005c9c:	6aa6                	ld	s5,72(sp)
    80005c9e:	6b06                	ld	s6,64(sp)
    80005ca0:	7be2                	ld	s7,56(sp)
    80005ca2:	7c42                	ld	s8,48(sp)
    80005ca4:	7ca2                	ld	s9,40(sp)
    80005ca6:	7d02                	ld	s10,32(sp)
    80005ca8:	6de2                	ld	s11,24(sp)
    80005caa:	6109                	addi	sp,sp,128
    80005cac:	8082                	ret
      if(n < target){
    80005cae:	000a071b          	sext.w	a4,s4
    80005cb2:	fb777be3          	bgeu	a4,s7,80005c68 <consoleread+0xc6>
        cons.r--;
    80005cb6:	0002e717          	auipc	a4,0x2e
    80005cba:	04f72923          	sw	a5,82(a4) # 80033d08 <cons+0x98>
    80005cbe:	b76d                	j	80005c68 <consoleread+0xc6>

0000000080005cc0 <consputc>:
{
    80005cc0:	1141                	addi	sp,sp,-16
    80005cc2:	e406                	sd	ra,8(sp)
    80005cc4:	e022                	sd	s0,0(sp)
    80005cc6:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005cc8:	10000793          	li	a5,256
    80005ccc:	00f50a63          	beq	a0,a5,80005ce0 <consputc+0x20>
    uartputc_sync(c);
    80005cd0:	00000097          	auipc	ra,0x0
    80005cd4:	564080e7          	jalr	1380(ra) # 80006234 <uartputc_sync>
}
    80005cd8:	60a2                	ld	ra,8(sp)
    80005cda:	6402                	ld	s0,0(sp)
    80005cdc:	0141                	addi	sp,sp,16
    80005cde:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005ce0:	4521                	li	a0,8
    80005ce2:	00000097          	auipc	ra,0x0
    80005ce6:	552080e7          	jalr	1362(ra) # 80006234 <uartputc_sync>
    80005cea:	02000513          	li	a0,32
    80005cee:	00000097          	auipc	ra,0x0
    80005cf2:	546080e7          	jalr	1350(ra) # 80006234 <uartputc_sync>
    80005cf6:	4521                	li	a0,8
    80005cf8:	00000097          	auipc	ra,0x0
    80005cfc:	53c080e7          	jalr	1340(ra) # 80006234 <uartputc_sync>
    80005d00:	bfe1                	j	80005cd8 <consputc+0x18>

0000000080005d02 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005d02:	1101                	addi	sp,sp,-32
    80005d04:	ec06                	sd	ra,24(sp)
    80005d06:	e822                	sd	s0,16(sp)
    80005d08:	e426                	sd	s1,8(sp)
    80005d0a:	e04a                	sd	s2,0(sp)
    80005d0c:	1000                	addi	s0,sp,32
    80005d0e:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005d10:	0002e517          	auipc	a0,0x2e
    80005d14:	f6050513          	addi	a0,a0,-160 # 80033c70 <cons>
    80005d18:	00000097          	auipc	ra,0x0
    80005d1c:	7b4080e7          	jalr	1972(ra) # 800064cc <acquire>

  switch(c){
    80005d20:	47d5                	li	a5,21
    80005d22:	0af48663          	beq	s1,a5,80005dce <consoleintr+0xcc>
    80005d26:	0297ca63          	blt	a5,s1,80005d5a <consoleintr+0x58>
    80005d2a:	47a1                	li	a5,8
    80005d2c:	0ef48763          	beq	s1,a5,80005e1a <consoleintr+0x118>
    80005d30:	47c1                	li	a5,16
    80005d32:	10f49a63          	bne	s1,a5,80005e46 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005d36:	ffffc097          	auipc	ra,0xffffc
    80005d3a:	ca0080e7          	jalr	-864(ra) # 800019d6 <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005d3e:	0002e517          	auipc	a0,0x2e
    80005d42:	f3250513          	addi	a0,a0,-206 # 80033c70 <cons>
    80005d46:	00001097          	auipc	ra,0x1
    80005d4a:	83a080e7          	jalr	-1990(ra) # 80006580 <release>
}
    80005d4e:	60e2                	ld	ra,24(sp)
    80005d50:	6442                	ld	s0,16(sp)
    80005d52:	64a2                	ld	s1,8(sp)
    80005d54:	6902                	ld	s2,0(sp)
    80005d56:	6105                	addi	sp,sp,32
    80005d58:	8082                	ret
  switch(c){
    80005d5a:	07f00793          	li	a5,127
    80005d5e:	0af48e63          	beq	s1,a5,80005e1a <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005d62:	0002e717          	auipc	a4,0x2e
    80005d66:	f0e70713          	addi	a4,a4,-242 # 80033c70 <cons>
    80005d6a:	0a072783          	lw	a5,160(a4)
    80005d6e:	09872703          	lw	a4,152(a4)
    80005d72:	9f99                	subw	a5,a5,a4
    80005d74:	07f00713          	li	a4,127
    80005d78:	fcf763e3          	bltu	a4,a5,80005d3e <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005d7c:	47b5                	li	a5,13
    80005d7e:	0cf48763          	beq	s1,a5,80005e4c <consoleintr+0x14a>
      consputc(c);
    80005d82:	8526                	mv	a0,s1
    80005d84:	00000097          	auipc	ra,0x0
    80005d88:	f3c080e7          	jalr	-196(ra) # 80005cc0 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005d8c:	0002e797          	auipc	a5,0x2e
    80005d90:	ee478793          	addi	a5,a5,-284 # 80033c70 <cons>
    80005d94:	0a07a683          	lw	a3,160(a5)
    80005d98:	0016871b          	addiw	a4,a3,1
    80005d9c:	0007061b          	sext.w	a2,a4
    80005da0:	0ae7a023          	sw	a4,160(a5)
    80005da4:	07f6f693          	andi	a3,a3,127
    80005da8:	97b6                	add	a5,a5,a3
    80005daa:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005dae:	47a9                	li	a5,10
    80005db0:	0cf48563          	beq	s1,a5,80005e7a <consoleintr+0x178>
    80005db4:	4791                	li	a5,4
    80005db6:	0cf48263          	beq	s1,a5,80005e7a <consoleintr+0x178>
    80005dba:	0002e797          	auipc	a5,0x2e
    80005dbe:	f4e7a783          	lw	a5,-178(a5) # 80033d08 <cons+0x98>
    80005dc2:	9f1d                	subw	a4,a4,a5
    80005dc4:	08000793          	li	a5,128
    80005dc8:	f6f71be3          	bne	a4,a5,80005d3e <consoleintr+0x3c>
    80005dcc:	a07d                	j	80005e7a <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005dce:	0002e717          	auipc	a4,0x2e
    80005dd2:	ea270713          	addi	a4,a4,-350 # 80033c70 <cons>
    80005dd6:	0a072783          	lw	a5,160(a4)
    80005dda:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005dde:	0002e497          	auipc	s1,0x2e
    80005de2:	e9248493          	addi	s1,s1,-366 # 80033c70 <cons>
    while(cons.e != cons.w &&
    80005de6:	4929                	li	s2,10
    80005de8:	f4f70be3          	beq	a4,a5,80005d3e <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005dec:	37fd                	addiw	a5,a5,-1
    80005dee:	07f7f713          	andi	a4,a5,127
    80005df2:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005df4:	01874703          	lbu	a4,24(a4)
    80005df8:	f52703e3          	beq	a4,s2,80005d3e <consoleintr+0x3c>
      cons.e--;
    80005dfc:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005e00:	10000513          	li	a0,256
    80005e04:	00000097          	auipc	ra,0x0
    80005e08:	ebc080e7          	jalr	-324(ra) # 80005cc0 <consputc>
    while(cons.e != cons.w &&
    80005e0c:	0a04a783          	lw	a5,160(s1)
    80005e10:	09c4a703          	lw	a4,156(s1)
    80005e14:	fcf71ce3          	bne	a4,a5,80005dec <consoleintr+0xea>
    80005e18:	b71d                	j	80005d3e <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005e1a:	0002e717          	auipc	a4,0x2e
    80005e1e:	e5670713          	addi	a4,a4,-426 # 80033c70 <cons>
    80005e22:	0a072783          	lw	a5,160(a4)
    80005e26:	09c72703          	lw	a4,156(a4)
    80005e2a:	f0f70ae3          	beq	a4,a5,80005d3e <consoleintr+0x3c>
      cons.e--;
    80005e2e:	37fd                	addiw	a5,a5,-1
    80005e30:	0002e717          	auipc	a4,0x2e
    80005e34:	eef72023          	sw	a5,-288(a4) # 80033d10 <cons+0xa0>
      consputc(BACKSPACE);
    80005e38:	10000513          	li	a0,256
    80005e3c:	00000097          	auipc	ra,0x0
    80005e40:	e84080e7          	jalr	-380(ra) # 80005cc0 <consputc>
    80005e44:	bded                	j	80005d3e <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005e46:	ee048ce3          	beqz	s1,80005d3e <consoleintr+0x3c>
    80005e4a:	bf21                	j	80005d62 <consoleintr+0x60>
      consputc(c);
    80005e4c:	4529                	li	a0,10
    80005e4e:	00000097          	auipc	ra,0x0
    80005e52:	e72080e7          	jalr	-398(ra) # 80005cc0 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005e56:	0002e797          	auipc	a5,0x2e
    80005e5a:	e1a78793          	addi	a5,a5,-486 # 80033c70 <cons>
    80005e5e:	0a07a703          	lw	a4,160(a5)
    80005e62:	0017069b          	addiw	a3,a4,1
    80005e66:	0006861b          	sext.w	a2,a3
    80005e6a:	0ad7a023          	sw	a3,160(a5)
    80005e6e:	07f77713          	andi	a4,a4,127
    80005e72:	97ba                	add	a5,a5,a4
    80005e74:	4729                	li	a4,10
    80005e76:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005e7a:	0002e797          	auipc	a5,0x2e
    80005e7e:	e8c7a923          	sw	a2,-366(a5) # 80033d0c <cons+0x9c>
        wakeup(&cons.r);
    80005e82:	0002e517          	auipc	a0,0x2e
    80005e86:	e8650513          	addi	a0,a0,-378 # 80033d08 <cons+0x98>
    80005e8a:	ffffb097          	auipc	ra,0xffffb
    80005e8e:	6fc080e7          	jalr	1788(ra) # 80001586 <wakeup>
    80005e92:	b575                	j	80005d3e <consoleintr+0x3c>

0000000080005e94 <consoleinit>:

void
consoleinit(void)
{
    80005e94:	1141                	addi	sp,sp,-16
    80005e96:	e406                	sd	ra,8(sp)
    80005e98:	e022                	sd	s0,0(sp)
    80005e9a:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005e9c:	00003597          	auipc	a1,0x3
    80005ea0:	93c58593          	addi	a1,a1,-1732 # 800087d8 <syscalls+0x418>
    80005ea4:	0002e517          	auipc	a0,0x2e
    80005ea8:	dcc50513          	addi	a0,a0,-564 # 80033c70 <cons>
    80005eac:	00000097          	auipc	ra,0x0
    80005eb0:	590080e7          	jalr	1424(ra) # 8000643c <initlock>

  uartinit();
    80005eb4:	00000097          	auipc	ra,0x0
    80005eb8:	330080e7          	jalr	816(ra) # 800061e4 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005ebc:	00025797          	auipc	a5,0x25
    80005ec0:	adc78793          	addi	a5,a5,-1316 # 8002a998 <devsw>
    80005ec4:	00000717          	auipc	a4,0x0
    80005ec8:	cde70713          	addi	a4,a4,-802 # 80005ba2 <consoleread>
    80005ecc:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005ece:	00000717          	auipc	a4,0x0
    80005ed2:	c7270713          	addi	a4,a4,-910 # 80005b40 <consolewrite>
    80005ed6:	ef98                	sd	a4,24(a5)
}
    80005ed8:	60a2                	ld	ra,8(sp)
    80005eda:	6402                	ld	s0,0(sp)
    80005edc:	0141                	addi	sp,sp,16
    80005ede:	8082                	ret

0000000080005ee0 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005ee0:	7179                	addi	sp,sp,-48
    80005ee2:	f406                	sd	ra,40(sp)
    80005ee4:	f022                	sd	s0,32(sp)
    80005ee6:	ec26                	sd	s1,24(sp)
    80005ee8:	e84a                	sd	s2,16(sp)
    80005eea:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005eec:	c219                	beqz	a2,80005ef2 <printint+0x12>
    80005eee:	08054663          	bltz	a0,80005f7a <printint+0x9a>
    x = -xx;
  else
    x = xx;
    80005ef2:	2501                	sext.w	a0,a0
    80005ef4:	4881                	li	a7,0
    80005ef6:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005efa:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005efc:	2581                	sext.w	a1,a1
    80005efe:	00003617          	auipc	a2,0x3
    80005f02:	90a60613          	addi	a2,a2,-1782 # 80008808 <digits>
    80005f06:	883a                	mv	a6,a4
    80005f08:	2705                	addiw	a4,a4,1
    80005f0a:	02b577bb          	remuw	a5,a0,a1
    80005f0e:	1782                	slli	a5,a5,0x20
    80005f10:	9381                	srli	a5,a5,0x20
    80005f12:	97b2                	add	a5,a5,a2
    80005f14:	0007c783          	lbu	a5,0(a5)
    80005f18:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005f1c:	0005079b          	sext.w	a5,a0
    80005f20:	02b5553b          	divuw	a0,a0,a1
    80005f24:	0685                	addi	a3,a3,1
    80005f26:	feb7f0e3          	bgeu	a5,a1,80005f06 <printint+0x26>

  if(sign)
    80005f2a:	00088b63          	beqz	a7,80005f40 <printint+0x60>
    buf[i++] = '-';
    80005f2e:	fe040793          	addi	a5,s0,-32
    80005f32:	973e                	add	a4,a4,a5
    80005f34:	02d00793          	li	a5,45
    80005f38:	fef70823          	sb	a5,-16(a4)
    80005f3c:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005f40:	02e05763          	blez	a4,80005f6e <printint+0x8e>
    80005f44:	fd040793          	addi	a5,s0,-48
    80005f48:	00e784b3          	add	s1,a5,a4
    80005f4c:	fff78913          	addi	s2,a5,-1
    80005f50:	993a                	add	s2,s2,a4
    80005f52:	377d                	addiw	a4,a4,-1
    80005f54:	1702                	slli	a4,a4,0x20
    80005f56:	9301                	srli	a4,a4,0x20
    80005f58:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005f5c:	fff4c503          	lbu	a0,-1(s1)
    80005f60:	00000097          	auipc	ra,0x0
    80005f64:	d60080e7          	jalr	-672(ra) # 80005cc0 <consputc>
  while(--i >= 0)
    80005f68:	14fd                	addi	s1,s1,-1
    80005f6a:	ff2499e3          	bne	s1,s2,80005f5c <printint+0x7c>
}
    80005f6e:	70a2                	ld	ra,40(sp)
    80005f70:	7402                	ld	s0,32(sp)
    80005f72:	64e2                	ld	s1,24(sp)
    80005f74:	6942                	ld	s2,16(sp)
    80005f76:	6145                	addi	sp,sp,48
    80005f78:	8082                	ret
    x = -xx;
    80005f7a:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005f7e:	4885                	li	a7,1
    x = -xx;
    80005f80:	bf9d                	j	80005ef6 <printint+0x16>

0000000080005f82 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005f82:	1101                	addi	sp,sp,-32
    80005f84:	ec06                	sd	ra,24(sp)
    80005f86:	e822                	sd	s0,16(sp)
    80005f88:	e426                	sd	s1,8(sp)
    80005f8a:	1000                	addi	s0,sp,32
    80005f8c:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005f8e:	0002e797          	auipc	a5,0x2e
    80005f92:	da07a123          	sw	zero,-606(a5) # 80033d30 <pr+0x18>
  printf("panic: ");
    80005f96:	00003517          	auipc	a0,0x3
    80005f9a:	84a50513          	addi	a0,a0,-1974 # 800087e0 <syscalls+0x420>
    80005f9e:	00000097          	auipc	ra,0x0
    80005fa2:	02e080e7          	jalr	46(ra) # 80005fcc <printf>
  printf(s);
    80005fa6:	8526                	mv	a0,s1
    80005fa8:	00000097          	auipc	ra,0x0
    80005fac:	024080e7          	jalr	36(ra) # 80005fcc <printf>
  printf("\n");
    80005fb0:	00002517          	auipc	a0,0x2
    80005fb4:	09850513          	addi	a0,a0,152 # 80008048 <etext+0x48>
    80005fb8:	00000097          	auipc	ra,0x0
    80005fbc:	014080e7          	jalr	20(ra) # 80005fcc <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005fc0:	4785                	li	a5,1
    80005fc2:	00003717          	auipc	a4,0x3
    80005fc6:	92f72523          	sw	a5,-1750(a4) # 800088ec <panicked>
  for(;;)
    80005fca:	a001                	j	80005fca <panic+0x48>

0000000080005fcc <printf>:
{
    80005fcc:	7131                	addi	sp,sp,-192
    80005fce:	fc86                	sd	ra,120(sp)
    80005fd0:	f8a2                	sd	s0,112(sp)
    80005fd2:	f4a6                	sd	s1,104(sp)
    80005fd4:	f0ca                	sd	s2,96(sp)
    80005fd6:	ecce                	sd	s3,88(sp)
    80005fd8:	e8d2                	sd	s4,80(sp)
    80005fda:	e4d6                	sd	s5,72(sp)
    80005fdc:	e0da                	sd	s6,64(sp)
    80005fde:	fc5e                	sd	s7,56(sp)
    80005fe0:	f862                	sd	s8,48(sp)
    80005fe2:	f466                	sd	s9,40(sp)
    80005fe4:	f06a                	sd	s10,32(sp)
    80005fe6:	ec6e                	sd	s11,24(sp)
    80005fe8:	0100                	addi	s0,sp,128
    80005fea:	8a2a                	mv	s4,a0
    80005fec:	e40c                	sd	a1,8(s0)
    80005fee:	e810                	sd	a2,16(s0)
    80005ff0:	ec14                	sd	a3,24(s0)
    80005ff2:	f018                	sd	a4,32(s0)
    80005ff4:	f41c                	sd	a5,40(s0)
    80005ff6:	03043823          	sd	a6,48(s0)
    80005ffa:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    80005ffe:	0002ed97          	auipc	s11,0x2e
    80006002:	d32dad83          	lw	s11,-718(s11) # 80033d30 <pr+0x18>
  if(locking)
    80006006:	020d9b63          	bnez	s11,8000603c <printf+0x70>
  if (fmt == 0)
    8000600a:	040a0263          	beqz	s4,8000604e <printf+0x82>
  va_start(ap, fmt);
    8000600e:	00840793          	addi	a5,s0,8
    80006012:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80006016:	000a4503          	lbu	a0,0(s4)
    8000601a:	16050263          	beqz	a0,8000617e <printf+0x1b2>
    8000601e:	4481                	li	s1,0
    if(c != '%'){
    80006020:	02500a93          	li	s5,37
    switch(c){
    80006024:	07000b13          	li	s6,112
  consputc('x');
    80006028:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    8000602a:	00002b97          	auipc	s7,0x2
    8000602e:	7deb8b93          	addi	s7,s7,2014 # 80008808 <digits>
    switch(c){
    80006032:	07300c93          	li	s9,115
    80006036:	06400c13          	li	s8,100
    8000603a:	a82d                	j	80006074 <printf+0xa8>
    acquire(&pr.lock);
    8000603c:	0002e517          	auipc	a0,0x2e
    80006040:	cdc50513          	addi	a0,a0,-804 # 80033d18 <pr>
    80006044:	00000097          	auipc	ra,0x0
    80006048:	488080e7          	jalr	1160(ra) # 800064cc <acquire>
    8000604c:	bf7d                	j	8000600a <printf+0x3e>
    panic("null fmt");
    8000604e:	00002517          	auipc	a0,0x2
    80006052:	7a250513          	addi	a0,a0,1954 # 800087f0 <syscalls+0x430>
    80006056:	00000097          	auipc	ra,0x0
    8000605a:	f2c080e7          	jalr	-212(ra) # 80005f82 <panic>
      consputc(c);
    8000605e:	00000097          	auipc	ra,0x0
    80006062:	c62080e7          	jalr	-926(ra) # 80005cc0 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80006066:	2485                	addiw	s1,s1,1
    80006068:	009a07b3          	add	a5,s4,s1
    8000606c:	0007c503          	lbu	a0,0(a5)
    80006070:	10050763          	beqz	a0,8000617e <printf+0x1b2>
    if(c != '%'){
    80006074:	ff5515e3          	bne	a0,s5,8000605e <printf+0x92>
    c = fmt[++i] & 0xff;
    80006078:	2485                	addiw	s1,s1,1
    8000607a:	009a07b3          	add	a5,s4,s1
    8000607e:	0007c783          	lbu	a5,0(a5)
    80006082:	0007891b          	sext.w	s2,a5
    if(c == 0)
    80006086:	cfe5                	beqz	a5,8000617e <printf+0x1b2>
    switch(c){
    80006088:	05678a63          	beq	a5,s6,800060dc <printf+0x110>
    8000608c:	02fb7663          	bgeu	s6,a5,800060b8 <printf+0xec>
    80006090:	09978963          	beq	a5,s9,80006122 <printf+0x156>
    80006094:	07800713          	li	a4,120
    80006098:	0ce79863          	bne	a5,a4,80006168 <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    8000609c:	f8843783          	ld	a5,-120(s0)
    800060a0:	00878713          	addi	a4,a5,8
    800060a4:	f8e43423          	sd	a4,-120(s0)
    800060a8:	4605                	li	a2,1
    800060aa:	85ea                	mv	a1,s10
    800060ac:	4388                	lw	a0,0(a5)
    800060ae:	00000097          	auipc	ra,0x0
    800060b2:	e32080e7          	jalr	-462(ra) # 80005ee0 <printint>
      break;
    800060b6:	bf45                	j	80006066 <printf+0x9a>
    switch(c){
    800060b8:	0b578263          	beq	a5,s5,8000615c <printf+0x190>
    800060bc:	0b879663          	bne	a5,s8,80006168 <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    800060c0:	f8843783          	ld	a5,-120(s0)
    800060c4:	00878713          	addi	a4,a5,8
    800060c8:	f8e43423          	sd	a4,-120(s0)
    800060cc:	4605                	li	a2,1
    800060ce:	45a9                	li	a1,10
    800060d0:	4388                	lw	a0,0(a5)
    800060d2:	00000097          	auipc	ra,0x0
    800060d6:	e0e080e7          	jalr	-498(ra) # 80005ee0 <printint>
      break;
    800060da:	b771                	j	80006066 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    800060dc:	f8843783          	ld	a5,-120(s0)
    800060e0:	00878713          	addi	a4,a5,8
    800060e4:	f8e43423          	sd	a4,-120(s0)
    800060e8:	0007b983          	ld	s3,0(a5)
  consputc('0');
    800060ec:	03000513          	li	a0,48
    800060f0:	00000097          	auipc	ra,0x0
    800060f4:	bd0080e7          	jalr	-1072(ra) # 80005cc0 <consputc>
  consputc('x');
    800060f8:	07800513          	li	a0,120
    800060fc:	00000097          	auipc	ra,0x0
    80006100:	bc4080e7          	jalr	-1084(ra) # 80005cc0 <consputc>
    80006104:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80006106:	03c9d793          	srli	a5,s3,0x3c
    8000610a:	97de                	add	a5,a5,s7
    8000610c:	0007c503          	lbu	a0,0(a5)
    80006110:	00000097          	auipc	ra,0x0
    80006114:	bb0080e7          	jalr	-1104(ra) # 80005cc0 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80006118:	0992                	slli	s3,s3,0x4
    8000611a:	397d                	addiw	s2,s2,-1
    8000611c:	fe0915e3          	bnez	s2,80006106 <printf+0x13a>
    80006120:	b799                	j	80006066 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80006122:	f8843783          	ld	a5,-120(s0)
    80006126:	00878713          	addi	a4,a5,8
    8000612a:	f8e43423          	sd	a4,-120(s0)
    8000612e:	0007b903          	ld	s2,0(a5)
    80006132:	00090e63          	beqz	s2,8000614e <printf+0x182>
      for(; *s; s++)
    80006136:	00094503          	lbu	a0,0(s2)
    8000613a:	d515                	beqz	a0,80006066 <printf+0x9a>
        consputc(*s);
    8000613c:	00000097          	auipc	ra,0x0
    80006140:	b84080e7          	jalr	-1148(ra) # 80005cc0 <consputc>
      for(; *s; s++)
    80006144:	0905                	addi	s2,s2,1
    80006146:	00094503          	lbu	a0,0(s2)
    8000614a:	f96d                	bnez	a0,8000613c <printf+0x170>
    8000614c:	bf29                	j	80006066 <printf+0x9a>
        s = "(null)";
    8000614e:	00002917          	auipc	s2,0x2
    80006152:	69a90913          	addi	s2,s2,1690 # 800087e8 <syscalls+0x428>
      for(; *s; s++)
    80006156:	02800513          	li	a0,40
    8000615a:	b7cd                	j	8000613c <printf+0x170>
      consputc('%');
    8000615c:	8556                	mv	a0,s5
    8000615e:	00000097          	auipc	ra,0x0
    80006162:	b62080e7          	jalr	-1182(ra) # 80005cc0 <consputc>
      break;
    80006166:	b701                	j	80006066 <printf+0x9a>
      consputc('%');
    80006168:	8556                	mv	a0,s5
    8000616a:	00000097          	auipc	ra,0x0
    8000616e:	b56080e7          	jalr	-1194(ra) # 80005cc0 <consputc>
      consputc(c);
    80006172:	854a                	mv	a0,s2
    80006174:	00000097          	auipc	ra,0x0
    80006178:	b4c080e7          	jalr	-1204(ra) # 80005cc0 <consputc>
      break;
    8000617c:	b5ed                	j	80006066 <printf+0x9a>
  if(locking)
    8000617e:	020d9163          	bnez	s11,800061a0 <printf+0x1d4>
}
    80006182:	70e6                	ld	ra,120(sp)
    80006184:	7446                	ld	s0,112(sp)
    80006186:	74a6                	ld	s1,104(sp)
    80006188:	7906                	ld	s2,96(sp)
    8000618a:	69e6                	ld	s3,88(sp)
    8000618c:	6a46                	ld	s4,80(sp)
    8000618e:	6aa6                	ld	s5,72(sp)
    80006190:	6b06                	ld	s6,64(sp)
    80006192:	7be2                	ld	s7,56(sp)
    80006194:	7c42                	ld	s8,48(sp)
    80006196:	7ca2                	ld	s9,40(sp)
    80006198:	7d02                	ld	s10,32(sp)
    8000619a:	6de2                	ld	s11,24(sp)
    8000619c:	6129                	addi	sp,sp,192
    8000619e:	8082                	ret
    release(&pr.lock);
    800061a0:	0002e517          	auipc	a0,0x2e
    800061a4:	b7850513          	addi	a0,a0,-1160 # 80033d18 <pr>
    800061a8:	00000097          	auipc	ra,0x0
    800061ac:	3d8080e7          	jalr	984(ra) # 80006580 <release>
}
    800061b0:	bfc9                	j	80006182 <printf+0x1b6>

00000000800061b2 <printfinit>:
    ;
}

void
printfinit(void)
{
    800061b2:	1101                	addi	sp,sp,-32
    800061b4:	ec06                	sd	ra,24(sp)
    800061b6:	e822                	sd	s0,16(sp)
    800061b8:	e426                	sd	s1,8(sp)
    800061ba:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    800061bc:	0002e497          	auipc	s1,0x2e
    800061c0:	b5c48493          	addi	s1,s1,-1188 # 80033d18 <pr>
    800061c4:	00002597          	auipc	a1,0x2
    800061c8:	63c58593          	addi	a1,a1,1596 # 80008800 <syscalls+0x440>
    800061cc:	8526                	mv	a0,s1
    800061ce:	00000097          	auipc	ra,0x0
    800061d2:	26e080e7          	jalr	622(ra) # 8000643c <initlock>
  pr.locking = 1;
    800061d6:	4785                	li	a5,1
    800061d8:	cc9c                	sw	a5,24(s1)
}
    800061da:	60e2                	ld	ra,24(sp)
    800061dc:	6442                	ld	s0,16(sp)
    800061de:	64a2                	ld	s1,8(sp)
    800061e0:	6105                	addi	sp,sp,32
    800061e2:	8082                	ret

00000000800061e4 <uartinit>:

void uartstart();

void
uartinit(void)
{
    800061e4:	1141                	addi	sp,sp,-16
    800061e6:	e406                	sd	ra,8(sp)
    800061e8:	e022                	sd	s0,0(sp)
    800061ea:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    800061ec:	100007b7          	lui	a5,0x10000
    800061f0:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    800061f4:	f8000713          	li	a4,-128
    800061f8:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    800061fc:	470d                	li	a4,3
    800061fe:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80006202:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80006206:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    8000620a:	469d                	li	a3,7
    8000620c:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80006210:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80006214:	00002597          	auipc	a1,0x2
    80006218:	60c58593          	addi	a1,a1,1548 # 80008820 <digits+0x18>
    8000621c:	0002e517          	auipc	a0,0x2e
    80006220:	b1c50513          	addi	a0,a0,-1252 # 80033d38 <uart_tx_lock>
    80006224:	00000097          	auipc	ra,0x0
    80006228:	218080e7          	jalr	536(ra) # 8000643c <initlock>
}
    8000622c:	60a2                	ld	ra,8(sp)
    8000622e:	6402                	ld	s0,0(sp)
    80006230:	0141                	addi	sp,sp,16
    80006232:	8082                	ret

0000000080006234 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80006234:	1101                	addi	sp,sp,-32
    80006236:	ec06                	sd	ra,24(sp)
    80006238:	e822                	sd	s0,16(sp)
    8000623a:	e426                	sd	s1,8(sp)
    8000623c:	1000                	addi	s0,sp,32
    8000623e:	84aa                	mv	s1,a0
  push_off();
    80006240:	00000097          	auipc	ra,0x0
    80006244:	240080e7          	jalr	576(ra) # 80006480 <push_off>

  if(panicked){
    80006248:	00002797          	auipc	a5,0x2
    8000624c:	6a47a783          	lw	a5,1700(a5) # 800088ec <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006250:	10000737          	lui	a4,0x10000
  if(panicked){
    80006254:	c391                	beqz	a5,80006258 <uartputc_sync+0x24>
    for(;;)
    80006256:	a001                	j	80006256 <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006258:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    8000625c:	0ff7f793          	andi	a5,a5,255
    80006260:	0207f793          	andi	a5,a5,32
    80006264:	dbf5                	beqz	a5,80006258 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80006266:	0ff4f793          	andi	a5,s1,255
    8000626a:	10000737          	lui	a4,0x10000
    8000626e:	00f70023          	sb	a5,0(a4) # 10000000 <_entry-0x70000000>

  pop_off();
    80006272:	00000097          	auipc	ra,0x0
    80006276:	2ae080e7          	jalr	686(ra) # 80006520 <pop_off>
}
    8000627a:	60e2                	ld	ra,24(sp)
    8000627c:	6442                	ld	s0,16(sp)
    8000627e:	64a2                	ld	s1,8(sp)
    80006280:	6105                	addi	sp,sp,32
    80006282:	8082                	ret

0000000080006284 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    80006284:	00002717          	auipc	a4,0x2
    80006288:	66c73703          	ld	a4,1644(a4) # 800088f0 <uart_tx_r>
    8000628c:	00002797          	auipc	a5,0x2
    80006290:	66c7b783          	ld	a5,1644(a5) # 800088f8 <uart_tx_w>
    80006294:	06e78c63          	beq	a5,a4,8000630c <uartstart+0x88>
{
    80006298:	7139                	addi	sp,sp,-64
    8000629a:	fc06                	sd	ra,56(sp)
    8000629c:	f822                	sd	s0,48(sp)
    8000629e:	f426                	sd	s1,40(sp)
    800062a0:	f04a                	sd	s2,32(sp)
    800062a2:	ec4e                	sd	s3,24(sp)
    800062a4:	e852                	sd	s4,16(sp)
    800062a6:	e456                	sd	s5,8(sp)
    800062a8:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800062aa:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800062ae:	0002ea17          	auipc	s4,0x2e
    800062b2:	a8aa0a13          	addi	s4,s4,-1398 # 80033d38 <uart_tx_lock>
    uart_tx_r += 1;
    800062b6:	00002497          	auipc	s1,0x2
    800062ba:	63a48493          	addi	s1,s1,1594 # 800088f0 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    800062be:	00002997          	auipc	s3,0x2
    800062c2:	63a98993          	addi	s3,s3,1594 # 800088f8 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800062c6:	00594783          	lbu	a5,5(s2) # 10000005 <_entry-0x6ffffffb>
    800062ca:	0ff7f793          	andi	a5,a5,255
    800062ce:	0207f793          	andi	a5,a5,32
    800062d2:	c785                	beqz	a5,800062fa <uartstart+0x76>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800062d4:	01f77793          	andi	a5,a4,31
    800062d8:	97d2                	add	a5,a5,s4
    800062da:	0187ca83          	lbu	s5,24(a5)
    uart_tx_r += 1;
    800062de:	0705                	addi	a4,a4,1
    800062e0:	e098                	sd	a4,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    800062e2:	8526                	mv	a0,s1
    800062e4:	ffffb097          	auipc	ra,0xffffb
    800062e8:	2a2080e7          	jalr	674(ra) # 80001586 <wakeup>
    
    WriteReg(THR, c);
    800062ec:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    800062f0:	6098                	ld	a4,0(s1)
    800062f2:	0009b783          	ld	a5,0(s3)
    800062f6:	fce798e3          	bne	a5,a4,800062c6 <uartstart+0x42>
  }
}
    800062fa:	70e2                	ld	ra,56(sp)
    800062fc:	7442                	ld	s0,48(sp)
    800062fe:	74a2                	ld	s1,40(sp)
    80006300:	7902                	ld	s2,32(sp)
    80006302:	69e2                	ld	s3,24(sp)
    80006304:	6a42                	ld	s4,16(sp)
    80006306:	6aa2                	ld	s5,8(sp)
    80006308:	6121                	addi	sp,sp,64
    8000630a:	8082                	ret
    8000630c:	8082                	ret

000000008000630e <uartputc>:
{
    8000630e:	7179                	addi	sp,sp,-48
    80006310:	f406                	sd	ra,40(sp)
    80006312:	f022                	sd	s0,32(sp)
    80006314:	ec26                	sd	s1,24(sp)
    80006316:	e84a                	sd	s2,16(sp)
    80006318:	e44e                	sd	s3,8(sp)
    8000631a:	e052                	sd	s4,0(sp)
    8000631c:	1800                	addi	s0,sp,48
    8000631e:	89aa                	mv	s3,a0
  acquire(&uart_tx_lock);
    80006320:	0002e517          	auipc	a0,0x2e
    80006324:	a1850513          	addi	a0,a0,-1512 # 80033d38 <uart_tx_lock>
    80006328:	00000097          	auipc	ra,0x0
    8000632c:	1a4080e7          	jalr	420(ra) # 800064cc <acquire>
  if(panicked){
    80006330:	00002797          	auipc	a5,0x2
    80006334:	5bc7a783          	lw	a5,1468(a5) # 800088ec <panicked>
    80006338:	e7c9                	bnez	a5,800063c2 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000633a:	00002797          	auipc	a5,0x2
    8000633e:	5be7b783          	ld	a5,1470(a5) # 800088f8 <uart_tx_w>
    80006342:	00002717          	auipc	a4,0x2
    80006346:	5ae73703          	ld	a4,1454(a4) # 800088f0 <uart_tx_r>
    8000634a:	02070713          	addi	a4,a4,32
    sleep(&uart_tx_r, &uart_tx_lock);
    8000634e:	0002ea17          	auipc	s4,0x2e
    80006352:	9eaa0a13          	addi	s4,s4,-1558 # 80033d38 <uart_tx_lock>
    80006356:	00002497          	auipc	s1,0x2
    8000635a:	59a48493          	addi	s1,s1,1434 # 800088f0 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000635e:	00002917          	auipc	s2,0x2
    80006362:	59a90913          	addi	s2,s2,1434 # 800088f8 <uart_tx_w>
    80006366:	00f71f63          	bne	a4,a5,80006384 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    8000636a:	85d2                	mv	a1,s4
    8000636c:	8526                	mv	a0,s1
    8000636e:	ffffb097          	auipc	ra,0xffffb
    80006372:	1b4080e7          	jalr	436(ra) # 80001522 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    80006376:	00093783          	ld	a5,0(s2)
    8000637a:	6098                	ld	a4,0(s1)
    8000637c:	02070713          	addi	a4,a4,32
    80006380:	fef705e3          	beq	a4,a5,8000636a <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    80006384:	0002e497          	auipc	s1,0x2e
    80006388:	9b448493          	addi	s1,s1,-1612 # 80033d38 <uart_tx_lock>
    8000638c:	01f7f713          	andi	a4,a5,31
    80006390:	9726                	add	a4,a4,s1
    80006392:	01370c23          	sb	s3,24(a4)
  uart_tx_w += 1;
    80006396:	0785                	addi	a5,a5,1
    80006398:	00002717          	auipc	a4,0x2
    8000639c:	56f73023          	sd	a5,1376(a4) # 800088f8 <uart_tx_w>
  uartstart();
    800063a0:	00000097          	auipc	ra,0x0
    800063a4:	ee4080e7          	jalr	-284(ra) # 80006284 <uartstart>
  release(&uart_tx_lock);
    800063a8:	8526                	mv	a0,s1
    800063aa:	00000097          	auipc	ra,0x0
    800063ae:	1d6080e7          	jalr	470(ra) # 80006580 <release>
}
    800063b2:	70a2                	ld	ra,40(sp)
    800063b4:	7402                	ld	s0,32(sp)
    800063b6:	64e2                	ld	s1,24(sp)
    800063b8:	6942                	ld	s2,16(sp)
    800063ba:	69a2                	ld	s3,8(sp)
    800063bc:	6a02                	ld	s4,0(sp)
    800063be:	6145                	addi	sp,sp,48
    800063c0:	8082                	ret
    for(;;)
    800063c2:	a001                	j	800063c2 <uartputc+0xb4>

00000000800063c4 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800063c4:	1141                	addi	sp,sp,-16
    800063c6:	e422                	sd	s0,8(sp)
    800063c8:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800063ca:	100007b7          	lui	a5,0x10000
    800063ce:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    800063d2:	8b85                	andi	a5,a5,1
    800063d4:	cb91                	beqz	a5,800063e8 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    800063d6:	100007b7          	lui	a5,0x10000
    800063da:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    800063de:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    800063e2:	6422                	ld	s0,8(sp)
    800063e4:	0141                	addi	sp,sp,16
    800063e6:	8082                	ret
    return -1;
    800063e8:	557d                	li	a0,-1
    800063ea:	bfe5                	j	800063e2 <uartgetc+0x1e>

00000000800063ec <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    800063ec:	1101                	addi	sp,sp,-32
    800063ee:	ec06                	sd	ra,24(sp)
    800063f0:	e822                	sd	s0,16(sp)
    800063f2:	e426                	sd	s1,8(sp)
    800063f4:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    800063f6:	54fd                	li	s1,-1
    int c = uartgetc();
    800063f8:	00000097          	auipc	ra,0x0
    800063fc:	fcc080e7          	jalr	-52(ra) # 800063c4 <uartgetc>
    if(c == -1)
    80006400:	00950763          	beq	a0,s1,8000640e <uartintr+0x22>
      break;
    consoleintr(c);
    80006404:	00000097          	auipc	ra,0x0
    80006408:	8fe080e7          	jalr	-1794(ra) # 80005d02 <consoleintr>
  while(1){
    8000640c:	b7f5                	j	800063f8 <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    8000640e:	0002e497          	auipc	s1,0x2e
    80006412:	92a48493          	addi	s1,s1,-1750 # 80033d38 <uart_tx_lock>
    80006416:	8526                	mv	a0,s1
    80006418:	00000097          	auipc	ra,0x0
    8000641c:	0b4080e7          	jalr	180(ra) # 800064cc <acquire>
  uartstart();
    80006420:	00000097          	auipc	ra,0x0
    80006424:	e64080e7          	jalr	-412(ra) # 80006284 <uartstart>
  release(&uart_tx_lock);
    80006428:	8526                	mv	a0,s1
    8000642a:	00000097          	auipc	ra,0x0
    8000642e:	156080e7          	jalr	342(ra) # 80006580 <release>
}
    80006432:	60e2                	ld	ra,24(sp)
    80006434:	6442                	ld	s0,16(sp)
    80006436:	64a2                	ld	s1,8(sp)
    80006438:	6105                	addi	sp,sp,32
    8000643a:	8082                	ret

000000008000643c <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    8000643c:	1141                	addi	sp,sp,-16
    8000643e:	e422                	sd	s0,8(sp)
    80006440:	0800                	addi	s0,sp,16
  lk->name = name;
    80006442:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80006444:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80006448:	00053823          	sd	zero,16(a0)
}
    8000644c:	6422                	ld	s0,8(sp)
    8000644e:	0141                	addi	sp,sp,16
    80006450:	8082                	ret

0000000080006452 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80006452:	411c                	lw	a5,0(a0)
    80006454:	e399                	bnez	a5,8000645a <holding+0x8>
    80006456:	4501                	li	a0,0
  return r;
}
    80006458:	8082                	ret
{
    8000645a:	1101                	addi	sp,sp,-32
    8000645c:	ec06                	sd	ra,24(sp)
    8000645e:	e822                	sd	s0,16(sp)
    80006460:	e426                	sd	s1,8(sp)
    80006462:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80006464:	6904                	ld	s1,16(a0)
    80006466:	ffffb097          	auipc	ra,0xffffb
    8000646a:	9bc080e7          	jalr	-1604(ra) # 80000e22 <mycpu>
    8000646e:	40a48533          	sub	a0,s1,a0
    80006472:	00153513          	seqz	a0,a0
}
    80006476:	60e2                	ld	ra,24(sp)
    80006478:	6442                	ld	s0,16(sp)
    8000647a:	64a2                	ld	s1,8(sp)
    8000647c:	6105                	addi	sp,sp,32
    8000647e:	8082                	ret

0000000080006480 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    80006480:	1101                	addi	sp,sp,-32
    80006482:	ec06                	sd	ra,24(sp)
    80006484:	e822                	sd	s0,16(sp)
    80006486:	e426                	sd	s1,8(sp)
    80006488:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000648a:	100024f3          	csrr	s1,sstatus
    8000648e:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80006492:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006494:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    80006498:	ffffb097          	auipc	ra,0xffffb
    8000649c:	98a080e7          	jalr	-1654(ra) # 80000e22 <mycpu>
    800064a0:	5d3c                	lw	a5,120(a0)
    800064a2:	cf89                	beqz	a5,800064bc <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800064a4:	ffffb097          	auipc	ra,0xffffb
    800064a8:	97e080e7          	jalr	-1666(ra) # 80000e22 <mycpu>
    800064ac:	5d3c                	lw	a5,120(a0)
    800064ae:	2785                	addiw	a5,a5,1
    800064b0:	dd3c                	sw	a5,120(a0)
}
    800064b2:	60e2                	ld	ra,24(sp)
    800064b4:	6442                	ld	s0,16(sp)
    800064b6:	64a2                	ld	s1,8(sp)
    800064b8:	6105                	addi	sp,sp,32
    800064ba:	8082                	ret
    mycpu()->intena = old;
    800064bc:	ffffb097          	auipc	ra,0xffffb
    800064c0:	966080e7          	jalr	-1690(ra) # 80000e22 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800064c4:	8085                	srli	s1,s1,0x1
    800064c6:	8885                	andi	s1,s1,1
    800064c8:	dd64                	sw	s1,124(a0)
    800064ca:	bfe9                	j	800064a4 <push_off+0x24>

00000000800064cc <acquire>:
{
    800064cc:	1101                	addi	sp,sp,-32
    800064ce:	ec06                	sd	ra,24(sp)
    800064d0:	e822                	sd	s0,16(sp)
    800064d2:	e426                	sd	s1,8(sp)
    800064d4:	1000                	addi	s0,sp,32
    800064d6:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    800064d8:	00000097          	auipc	ra,0x0
    800064dc:	fa8080e7          	jalr	-88(ra) # 80006480 <push_off>
  if(holding(lk))
    800064e0:	8526                	mv	a0,s1
    800064e2:	00000097          	auipc	ra,0x0
    800064e6:	f70080e7          	jalr	-144(ra) # 80006452 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800064ea:	4705                	li	a4,1
  if(holding(lk))
    800064ec:	e115                	bnez	a0,80006510 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    800064ee:	87ba                	mv	a5,a4
    800064f0:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    800064f4:	2781                	sext.w	a5,a5
    800064f6:	ffe5                	bnez	a5,800064ee <acquire+0x22>
  __sync_synchronize();
    800064f8:	0ff0000f          	fence
  lk->cpu = mycpu();
    800064fc:	ffffb097          	auipc	ra,0xffffb
    80006500:	926080e7          	jalr	-1754(ra) # 80000e22 <mycpu>
    80006504:	e888                	sd	a0,16(s1)
}
    80006506:	60e2                	ld	ra,24(sp)
    80006508:	6442                	ld	s0,16(sp)
    8000650a:	64a2                	ld	s1,8(sp)
    8000650c:	6105                	addi	sp,sp,32
    8000650e:	8082                	ret
    panic("acquire");
    80006510:	00002517          	auipc	a0,0x2
    80006514:	31850513          	addi	a0,a0,792 # 80008828 <digits+0x20>
    80006518:	00000097          	auipc	ra,0x0
    8000651c:	a6a080e7          	jalr	-1430(ra) # 80005f82 <panic>

0000000080006520 <pop_off>:

void
pop_off(void)
{
    80006520:	1141                	addi	sp,sp,-16
    80006522:	e406                	sd	ra,8(sp)
    80006524:	e022                	sd	s0,0(sp)
    80006526:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80006528:	ffffb097          	auipc	ra,0xffffb
    8000652c:	8fa080e7          	jalr	-1798(ra) # 80000e22 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006530:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80006534:	8b89                	andi	a5,a5,2
  if(intr_get())
    80006536:	e78d                	bnez	a5,80006560 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80006538:	5d3c                	lw	a5,120(a0)
    8000653a:	02f05b63          	blez	a5,80006570 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    8000653e:	37fd                	addiw	a5,a5,-1
    80006540:	0007871b          	sext.w	a4,a5
    80006544:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80006546:	eb09                	bnez	a4,80006558 <pop_off+0x38>
    80006548:	5d7c                	lw	a5,124(a0)
    8000654a:	c799                	beqz	a5,80006558 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000654c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006550:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006554:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80006558:	60a2                	ld	ra,8(sp)
    8000655a:	6402                	ld	s0,0(sp)
    8000655c:	0141                	addi	sp,sp,16
    8000655e:	8082                	ret
    panic("pop_off - interruptible");
    80006560:	00002517          	auipc	a0,0x2
    80006564:	2d050513          	addi	a0,a0,720 # 80008830 <digits+0x28>
    80006568:	00000097          	auipc	ra,0x0
    8000656c:	a1a080e7          	jalr	-1510(ra) # 80005f82 <panic>
    panic("pop_off");
    80006570:	00002517          	auipc	a0,0x2
    80006574:	2d850513          	addi	a0,a0,728 # 80008848 <digits+0x40>
    80006578:	00000097          	auipc	ra,0x0
    8000657c:	a0a080e7          	jalr	-1526(ra) # 80005f82 <panic>

0000000080006580 <release>:
{
    80006580:	1101                	addi	sp,sp,-32
    80006582:	ec06                	sd	ra,24(sp)
    80006584:	e822                	sd	s0,16(sp)
    80006586:	e426                	sd	s1,8(sp)
    80006588:	1000                	addi	s0,sp,32
    8000658a:	84aa                	mv	s1,a0
  if(!holding(lk))
    8000658c:	00000097          	auipc	ra,0x0
    80006590:	ec6080e7          	jalr	-314(ra) # 80006452 <holding>
    80006594:	c115                	beqz	a0,800065b8 <release+0x38>
  lk->cpu = 0;
    80006596:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    8000659a:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    8000659e:	0f50000f          	fence	iorw,ow
    800065a2:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    800065a6:	00000097          	auipc	ra,0x0
    800065aa:	f7a080e7          	jalr	-134(ra) # 80006520 <pop_off>
}
    800065ae:	60e2                	ld	ra,24(sp)
    800065b0:	6442                	ld	s0,16(sp)
    800065b2:	64a2                	ld	s1,8(sp)
    800065b4:	6105                	addi	sp,sp,32
    800065b6:	8082                	ret
    panic("release");
    800065b8:	00002517          	auipc	a0,0x2
    800065bc:	29850513          	addi	a0,a0,664 # 80008850 <digits+0x48>
    800065c0:	00000097          	auipc	ra,0x0
    800065c4:	9c2080e7          	jalr	-1598(ra) # 80005f82 <panic>
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
