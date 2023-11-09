
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
    80000016:	2e7050ef          	jal	ra,80005afc <start>

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
    8000005e:	4a2080e7          	jalr	1186(ra) # 800064fc <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	542080e7          	jalr	1346(ra) # 800065b0 <release>
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
    8000008e:	f28080e7          	jalr	-216(ra) # 80005fb2 <panic>

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
    800000f8:	378080e7          	jalr	888(ra) # 8000646c <initlock>
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
    80000130:	3d0080e7          	jalr	976(ra) # 800064fc <acquire>
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
    80000148:	46c080e7          	jalr	1132(ra) # 800065b0 <release>

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
    80000172:	442080e7          	jalr	1090(ra) # 800065b0 <release>
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
    80000360:	ca0080e7          	jalr	-864(ra) # 80005ffc <printf>
    kvminithart();    // turn on paging
    80000364:	00000097          	auipc	ra,0x0
    80000368:	0d8080e7          	jalr	216(ra) # 8000043c <kvminithart>
    trapinithart();   // install kernel trap vector
    8000036c:	00001097          	auipc	ra,0x1
    80000370:	7d2080e7          	jalr	2002(ra) # 80001b3e <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000374:	00005097          	auipc	ra,0x5
    80000378:	0dc080e7          	jalr	220(ra) # 80005450 <plicinithart>
  }

  scheduler();        
    8000037c:	00001097          	auipc	ra,0x1
    80000380:	01c080e7          	jalr	28(ra) # 80001398 <scheduler>
    consoleinit();
    80000384:	00006097          	auipc	ra,0x6
    80000388:	b40080e7          	jalr	-1216(ra) # 80005ec4 <consoleinit>
    printfinit();
    8000038c:	00006097          	auipc	ra,0x6
    80000390:	e56080e7          	jalr	-426(ra) # 800061e2 <printfinit>
    printf("\n");
    80000394:	00008517          	auipc	a0,0x8
    80000398:	cb450513          	addi	a0,a0,-844 # 80008048 <etext+0x48>
    8000039c:	00006097          	auipc	ra,0x6
    800003a0:	c60080e7          	jalr	-928(ra) # 80005ffc <printf>
    printf("xv6 kernel is booting\n");
    800003a4:	00008517          	auipc	a0,0x8
    800003a8:	c7c50513          	addi	a0,a0,-900 # 80008020 <etext+0x20>
    800003ac:	00006097          	auipc	ra,0x6
    800003b0:	c50080e7          	jalr	-944(ra) # 80005ffc <printf>
    printf("\n");
    800003b4:	00008517          	auipc	a0,0x8
    800003b8:	c9450513          	addi	a0,a0,-876 # 80008048 <etext+0x48>
    800003bc:	00006097          	auipc	ra,0x6
    800003c0:	c40080e7          	jalr	-960(ra) # 80005ffc <printf>
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
    800003e8:	732080e7          	jalr	1842(ra) # 80001b16 <trapinit>
    trapinithart();  // install kernel trap vector
    800003ec:	00001097          	auipc	ra,0x1
    800003f0:	752080e7          	jalr	1874(ra) # 80001b3e <trapinithart>
    plicinit();      // set up interrupt controller
    800003f4:	00005097          	auipc	ra,0x5
    800003f8:	046080e7          	jalr	70(ra) # 8000543a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003fc:	00005097          	auipc	ra,0x5
    80000400:	054080e7          	jalr	84(ra) # 80005450 <plicinithart>
    binit();         // buffer cache
    80000404:	00002097          	auipc	ra,0x2
    80000408:	f6e080e7          	jalr	-146(ra) # 80002372 <binit>
    iinit();         // inode table
    8000040c:	00002097          	auipc	ra,0x2
    80000410:	612080e7          	jalr	1554(ra) # 80002a1e <iinit>
    fileinit();      // file table
    80000414:	00003097          	auipc	ra,0x3
    80000418:	5b0080e7          	jalr	1456(ra) # 800039c4 <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000041c:	00005097          	auipc	ra,0x5
    80000420:	13c080e7          	jalr	316(ra) # 80005558 <virtio_disk_init>
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
    80000496:	b20080e7          	jalr	-1248(ra) # 80005fb2 <panic>
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
    8000058e:	a28080e7          	jalr	-1496(ra) # 80005fb2 <panic>
            panic("mappages: remap");
    80000592:	00008517          	auipc	a0,0x8
    80000596:	ad650513          	addi	a0,a0,-1322 # 80008068 <etext+0x68>
    8000059a:	00006097          	auipc	ra,0x6
    8000059e:	a18080e7          	jalr	-1512(ra) # 80005fb2 <panic>
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
    80000618:	99e080e7          	jalr	-1634(ra) # 80005fb2 <panic>

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
    80000764:	852080e7          	jalr	-1966(ra) # 80005fb2 <panic>
            panic("uvmunmap: walk");
    80000768:	00008517          	auipc	a0,0x8
    8000076c:	93050513          	addi	a0,a0,-1744 # 80008098 <etext+0x98>
    80000770:	00006097          	auipc	ra,0x6
    80000774:	842080e7          	jalr	-1982(ra) # 80005fb2 <panic>
            panic("uvmunmap: not a leaf");
    80000778:	00008517          	auipc	a0,0x8
    8000077c:	93050513          	addi	a0,a0,-1744 # 800080a8 <etext+0xa8>
    80000780:	00006097          	auipc	ra,0x6
    80000784:	832080e7          	jalr	-1998(ra) # 80005fb2 <panic>
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
    80000864:	752080e7          	jalr	1874(ra) # 80005fb2 <panic>

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
    800009ae:	608080e7          	jalr	1544(ra) # 80005fb2 <panic>
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
    80000a32:	584080e7          	jalr	1412(ra) # 80005fb2 <panic>
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
    80000af8:	4be080e7          	jalr	1214(ra) # 80005fb2 <panic>

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
    80000d5a:	25c080e7          	jalr	604(ra) # 80005fb2 <panic>

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
    80000d86:	6ea080e7          	jalr	1770(ra) # 8000646c <initlock>
    initlock(&wait_lock, "wait_lock");
    80000d8a:	00007597          	auipc	a1,0x7
    80000d8e:	3a658593          	addi	a1,a1,934 # 80008130 <etext+0x130>
    80000d92:	00008517          	auipc	a0,0x8
    80000d96:	ba650513          	addi	a0,a0,-1114 # 80008938 <wait_lock>
    80000d9a:	00005097          	auipc	ra,0x5
    80000d9e:	6d2080e7          	jalr	1746(ra) # 8000646c <initlock>
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
    80000dd4:	69c080e7          	jalr	1692(ra) # 8000646c <initlock>
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
    80000e4c:	668080e7          	jalr	1640(ra) # 800064b0 <push_off>
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
    80000e66:	6ee080e7          	jalr	1774(ra) # 80006550 <pop_off>
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
    80000e8a:	72a080e7          	jalr	1834(ra) # 800065b0 <release>

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
    80000e9c:	cbe080e7          	jalr	-834(ra) # 80001b56 <usertrapret>
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
    80000eb6:	aec080e7          	jalr	-1300(ra) # 8000299e <fsinit>
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
    80000ed6:	62a080e7          	jalr	1578(ra) # 800064fc <acquire>
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
    80000ef0:	6c4080e7          	jalr	1732(ra) # 800065b0 <release>
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
    8000106a:	496080e7          	jalr	1174(ra) # 800064fc <acquire>
        if (p->state == UNUSED)
    8000106e:	4c9c                	lw	a5,24(s1)
    80001070:	cf81                	beqz	a5,80001088 <allocproc+0x40>
            release(&p->lock);
    80001072:	8526                	mv	a0,s1
    80001074:	00005097          	auipc	ra,0x5
    80001078:	53c080e7          	jalr	1340(ra) # 800065b0 <release>
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
    800010f6:	4be080e7          	jalr	1214(ra) # 800065b0 <release>
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
    8000110e:	4a6080e7          	jalr	1190(ra) # 800065b0 <release>
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
    80001178:	24c080e7          	jalr	588(ra) # 800033c0 <namei>
    8000117c:	14a4b823          	sd	a0,336(s1)
    p->state = RUNNABLE;
    80001180:	478d                	li	a5,3
    80001182:	cc9c                	sw	a5,24(s1)
    release(&p->lock);
    80001184:	8526                	mv	a0,s1
    80001186:	00005097          	auipc	ra,0x5
    8000118a:	42a080e7          	jalr	1066(ra) # 800065b0 <release>
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
    800011f4:	7139                	addi	sp,sp,-64
    800011f6:	fc06                	sd	ra,56(sp)
    800011f8:	f822                	sd	s0,48(sp)
    800011fa:	f426                	sd	s1,40(sp)
    800011fc:	f04a                	sd	s2,32(sp)
    800011fe:	ec4e                	sd	s3,24(sp)
    80001200:	e852                	sd	s4,16(sp)
    80001202:	e456                	sd	s5,8(sp)
    80001204:	0080                	addi	s0,sp,64
    struct proc *p = myproc();
    80001206:	00000097          	auipc	ra,0x0
    8000120a:	c38080e7          	jalr	-968(ra) # 80000e3e <myproc>
    8000120e:	89aa                	mv	s3,a0
    if ((np = allocproc()) == 0)
    80001210:	00000097          	auipc	ra,0x0
    80001214:	e38080e7          	jalr	-456(ra) # 80001048 <allocproc>
    80001218:	16050e63          	beqz	a0,80001394 <fork+0x1a0>
    8000121c:	8a2a                	mv	s4,a0
    if (uvmcopy(p->pagetable, np->pagetable, p->sz) < 0)
    8000121e:	0489b603          	ld	a2,72(s3)
    80001222:	692c                	ld	a1,80(a0)
    80001224:	0509b503          	ld	a0,80(s3)
    80001228:	fffff097          	auipc	ra,0xfffff
    8000122c:	7dc080e7          	jalr	2012(ra) # 80000a04 <uvmcopy>
    80001230:	00054d63          	bltz	a0,8000124a <fork+0x56>
    np->sz = p->sz;
    80001234:	0489b783          	ld	a5,72(s3)
    80001238:	04fa3423          	sd	a5,72(s4)
    for (int i = VMASIZE - 1; i >= 0; i--)
    8000123c:	5a098493          	addi	s1,s3,1440
    80001240:	5a0a0913          	addi	s2,s4,1440
    80001244:	12098a93          	addi	s5,s3,288
    80001248:	a03d                	j	80001276 <fork+0x82>
        freeproc(np);
    8000124a:	8552                	mv	a0,s4
    8000124c:	00000097          	auipc	ra,0x0
    80001250:	da4080e7          	jalr	-604(ra) # 80000ff0 <freeproc>
        release(&np->lock);
    80001254:	8552                	mv	a0,s4
    80001256:	00005097          	auipc	ra,0x5
    8000125a:	35a080e7          	jalr	858(ra) # 800065b0 <release>
        return -1;
    8000125e:	597d                	li	s2,-1
    80001260:	a205                	j	80001380 <fork+0x18c>
            filedup(p_odd_vma->pf);
    80001262:	00002097          	auipc	ra,0x2
    80001266:	7f4080e7          	jalr	2036(ra) # 80003a56 <filedup>
    for (int i = VMASIZE - 1; i >= 0; i--)
    8000126a:	fb848493          	addi	s1,s1,-72
    8000126e:	fb890913          	addi	s2,s2,-72
    80001272:	05548363          	beq	s1,s5,800012b8 <fork+0xc4>
        p_new_vma->occupied = p_odd_vma->occupied;
    80001276:	409c                	lw	a5,0(s1)
    80001278:	00f92023          	sw	a5,0(s2)
        p_new_vma->start_addr = p_odd_vma->start_addr;
    8000127c:	649c                	ld	a5,8(s1)
    8000127e:	00f93423          	sd	a5,8(s2)
        p_new_vma->end_addr = p_odd_vma->end_addr;
    80001282:	689c                	ld	a5,16(s1)
    80001284:	00f93823          	sd	a5,16(s2)
        p_new_vma->addr = p_odd_vma->addr;
    80001288:	6c9c                	ld	a5,24(s1)
    8000128a:	00f93c23          	sd	a5,24(s2)
        p_new_vma->length = p_odd_vma->length;
    8000128e:	709c                	ld	a5,32(s1)
    80001290:	02f93023          	sd	a5,32(s2)
        p_new_vma->prot = p_odd_vma->prot;
    80001294:	549c                	lw	a5,40(s1)
    80001296:	02f92423          	sw	a5,40(s2)
        p_new_vma->flags = p_odd_vma->flags;
    8000129a:	54dc                	lw	a5,44(s1)
    8000129c:	02f92623          	sw	a5,44(s2)
        p_new_vma->fd = p_odd_vma->fd;
    800012a0:	589c                	lw	a5,48(s1)
    800012a2:	02f92823          	sw	a5,48(s2)
        p_new_vma->offset = p_odd_vma->offset;
    800012a6:	7c9c                	ld	a5,56(s1)
    800012a8:	02f93c23          	sd	a5,56(s2)
        p_new_vma->pf = p_odd_vma->pf;
    800012ac:	60a8                	ld	a0,64(s1)
    800012ae:	04a93023          	sd	a0,64(s2)
        if (p_odd_vma->fd != 0)
    800012b2:	589c                	lw	a5,48(s1)
    800012b4:	dbdd                	beqz	a5,8000126a <fork+0x76>
    800012b6:	b775                	j	80001262 <fork+0x6e>
    *(np->trapframe) = *(p->trapframe);
    800012b8:	0589b683          	ld	a3,88(s3)
    800012bc:	87b6                	mv	a5,a3
    800012be:	058a3703          	ld	a4,88(s4)
    800012c2:	12068693          	addi	a3,a3,288
    800012c6:	0007b803          	ld	a6,0(a5) # 1000 <_entry-0x7ffff000>
    800012ca:	6788                	ld	a0,8(a5)
    800012cc:	6b8c                	ld	a1,16(a5)
    800012ce:	6f90                	ld	a2,24(a5)
    800012d0:	01073023          	sd	a6,0(a4)
    800012d4:	e708                	sd	a0,8(a4)
    800012d6:	eb0c                	sd	a1,16(a4)
    800012d8:	ef10                	sd	a2,24(a4)
    800012da:	02078793          	addi	a5,a5,32
    800012de:	02070713          	addi	a4,a4,32
    800012e2:	fed792e3          	bne	a5,a3,800012c6 <fork+0xd2>
    np->trapframe->a0 = 0;
    800012e6:	058a3783          	ld	a5,88(s4)
    800012ea:	0607b823          	sd	zero,112(a5)
    800012ee:	0d000493          	li	s1,208
    for (i = 0; i < NOFILE; i++)
    800012f2:	15000913          	li	s2,336
    800012f6:	a819                	j	8000130c <fork+0x118>
            np->ofile[i] = filedup(p->ofile[i]);
    800012f8:	00002097          	auipc	ra,0x2
    800012fc:	75e080e7          	jalr	1886(ra) # 80003a56 <filedup>
    80001300:	009a07b3          	add	a5,s4,s1
    80001304:	e388                	sd	a0,0(a5)
    for (i = 0; i < NOFILE; i++)
    80001306:	04a1                	addi	s1,s1,8
    80001308:	01248763          	beq	s1,s2,80001316 <fork+0x122>
        if (p->ofile[i])
    8000130c:	009987b3          	add	a5,s3,s1
    80001310:	6388                	ld	a0,0(a5)
    80001312:	f17d                	bnez	a0,800012f8 <fork+0x104>
    80001314:	bfcd                	j	80001306 <fork+0x112>
    np->cwd = idup(p->cwd);
    80001316:	1509b503          	ld	a0,336(s3)
    8000131a:	00002097          	auipc	ra,0x2
    8000131e:	8c2080e7          	jalr	-1854(ra) # 80002bdc <idup>
    80001322:	14aa3823          	sd	a0,336(s4)
    safestrcpy(np->name, p->name, sizeof(p->name));
    80001326:	4641                	li	a2,16
    80001328:	15898593          	addi	a1,s3,344
    8000132c:	158a0513          	addi	a0,s4,344
    80001330:	fffff097          	auipc	ra,0xfffff
    80001334:	f9a080e7          	jalr	-102(ra) # 800002ca <safestrcpy>
    pid = np->pid;
    80001338:	030a2903          	lw	s2,48(s4)
    release(&np->lock);
    8000133c:	8552                	mv	a0,s4
    8000133e:	00005097          	auipc	ra,0x5
    80001342:	272080e7          	jalr	626(ra) # 800065b0 <release>
    acquire(&wait_lock);
    80001346:	00007497          	auipc	s1,0x7
    8000134a:	5f248493          	addi	s1,s1,1522 # 80008938 <wait_lock>
    8000134e:	8526                	mv	a0,s1
    80001350:	00005097          	auipc	ra,0x5
    80001354:	1ac080e7          	jalr	428(ra) # 800064fc <acquire>
    np->parent = p;
    80001358:	033a3c23          	sd	s3,56(s4)
    release(&wait_lock);
    8000135c:	8526                	mv	a0,s1
    8000135e:	00005097          	auipc	ra,0x5
    80001362:	252080e7          	jalr	594(ra) # 800065b0 <release>
    acquire(&np->lock);
    80001366:	8552                	mv	a0,s4
    80001368:	00005097          	auipc	ra,0x5
    8000136c:	194080e7          	jalr	404(ra) # 800064fc <acquire>
    np->state = RUNNABLE;
    80001370:	478d                	li	a5,3
    80001372:	00fa2c23          	sw	a5,24(s4)
    release(&np->lock);
    80001376:	8552                	mv	a0,s4
    80001378:	00005097          	auipc	ra,0x5
    8000137c:	238080e7          	jalr	568(ra) # 800065b0 <release>
}
    80001380:	854a                	mv	a0,s2
    80001382:	70e2                	ld	ra,56(sp)
    80001384:	7442                	ld	s0,48(sp)
    80001386:	74a2                	ld	s1,40(sp)
    80001388:	7902                	ld	s2,32(sp)
    8000138a:	69e2                	ld	s3,24(sp)
    8000138c:	6a42                	ld	s4,16(sp)
    8000138e:	6aa2                	ld	s5,8(sp)
    80001390:	6121                	addi	sp,sp,64
    80001392:	8082                	ret
        return -1;
    80001394:	597d                	li	s2,-1
    80001396:	b7ed                	j	80001380 <fork+0x18c>

0000000080001398 <scheduler>:
{
    80001398:	7139                	addi	sp,sp,-64
    8000139a:	fc06                	sd	ra,56(sp)
    8000139c:	f822                	sd	s0,48(sp)
    8000139e:	f426                	sd	s1,40(sp)
    800013a0:	f04a                	sd	s2,32(sp)
    800013a2:	ec4e                	sd	s3,24(sp)
    800013a4:	e852                	sd	s4,16(sp)
    800013a6:	e456                	sd	s5,8(sp)
    800013a8:	e05a                	sd	s6,0(sp)
    800013aa:	0080                	addi	s0,sp,64
    800013ac:	8792                	mv	a5,tp
    int id = r_tp();
    800013ae:	2781                	sext.w	a5,a5
    c->proc = 0;
    800013b0:	00779a93          	slli	s5,a5,0x7
    800013b4:	00007717          	auipc	a4,0x7
    800013b8:	56c70713          	addi	a4,a4,1388 # 80008920 <pid_lock>
    800013bc:	9756                	add	a4,a4,s5
    800013be:	02073823          	sd	zero,48(a4)
                swtch(&c->context, &p->context);
    800013c2:	00007717          	auipc	a4,0x7
    800013c6:	59670713          	addi	a4,a4,1430 # 80008958 <cpus+0x8>
    800013ca:	9aba                	add	s5,s5,a4
            if (p->state == RUNNABLE)
    800013cc:	498d                	li	s3,3
                p->state = RUNNING;
    800013ce:	4b11                	li	s6,4
                c->proc = p;
    800013d0:	079e                	slli	a5,a5,0x7
    800013d2:	00007a17          	auipc	s4,0x7
    800013d6:	54ea0a13          	addi	s4,s4,1358 # 80008920 <pid_lock>
    800013da:	9a3e                	add	s4,s4,a5
        for (p = proc; p < &proc[NPROC]; p++)
    800013dc:	0001f917          	auipc	s2,0x1f
    800013e0:	37490913          	addi	s2,s2,884 # 80020750 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800013e4:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800013e8:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800013ec:	10079073          	csrw	sstatus,a5
    800013f0:	00008497          	auipc	s1,0x8
    800013f4:	96048493          	addi	s1,s1,-1696 # 80008d50 <proc>
    800013f8:	a03d                	j	80001426 <scheduler+0x8e>
                p->state = RUNNING;
    800013fa:	0164ac23          	sw	s6,24(s1)
                c->proc = p;
    800013fe:	029a3823          	sd	s1,48(s4)
                swtch(&c->context, &p->context);
    80001402:	06048593          	addi	a1,s1,96
    80001406:	8556                	mv	a0,s5
    80001408:	00000097          	auipc	ra,0x0
    8000140c:	6a4080e7          	jalr	1700(ra) # 80001aac <swtch>
                c->proc = 0;
    80001410:	020a3823          	sd	zero,48(s4)
            release(&p->lock);
    80001414:	8526                	mv	a0,s1
    80001416:	00005097          	auipc	ra,0x5
    8000141a:	19a080e7          	jalr	410(ra) # 800065b0 <release>
        for (p = proc; p < &proc[NPROC]; p++)
    8000141e:	5e848493          	addi	s1,s1,1512
    80001422:	fd2481e3          	beq	s1,s2,800013e4 <scheduler+0x4c>
            acquire(&p->lock);
    80001426:	8526                	mv	a0,s1
    80001428:	00005097          	auipc	ra,0x5
    8000142c:	0d4080e7          	jalr	212(ra) # 800064fc <acquire>
            if (p->state == RUNNABLE)
    80001430:	4c9c                	lw	a5,24(s1)
    80001432:	ff3791e3          	bne	a5,s3,80001414 <scheduler+0x7c>
    80001436:	b7d1                	j	800013fa <scheduler+0x62>

0000000080001438 <sched>:
{
    80001438:	7179                	addi	sp,sp,-48
    8000143a:	f406                	sd	ra,40(sp)
    8000143c:	f022                	sd	s0,32(sp)
    8000143e:	ec26                	sd	s1,24(sp)
    80001440:	e84a                	sd	s2,16(sp)
    80001442:	e44e                	sd	s3,8(sp)
    80001444:	1800                	addi	s0,sp,48
    struct proc *p = myproc();
    80001446:	00000097          	auipc	ra,0x0
    8000144a:	9f8080e7          	jalr	-1544(ra) # 80000e3e <myproc>
    8000144e:	84aa                	mv	s1,a0
    if (!holding(&p->lock))
    80001450:	00005097          	auipc	ra,0x5
    80001454:	032080e7          	jalr	50(ra) # 80006482 <holding>
    80001458:	c93d                	beqz	a0,800014ce <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    8000145a:	8792                	mv	a5,tp
    if (mycpu()->noff != 1)
    8000145c:	2781                	sext.w	a5,a5
    8000145e:	079e                	slli	a5,a5,0x7
    80001460:	00007717          	auipc	a4,0x7
    80001464:	4c070713          	addi	a4,a4,1216 # 80008920 <pid_lock>
    80001468:	97ba                	add	a5,a5,a4
    8000146a:	0a87a703          	lw	a4,168(a5)
    8000146e:	4785                	li	a5,1
    80001470:	06f71763          	bne	a4,a5,800014de <sched+0xa6>
    if (p->state == RUNNING)
    80001474:	4c98                	lw	a4,24(s1)
    80001476:	4791                	li	a5,4
    80001478:	06f70b63          	beq	a4,a5,800014ee <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000147c:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001480:	8b89                	andi	a5,a5,2
    if (intr_get())
    80001482:	efb5                	bnez	a5,800014fe <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001484:	8792                	mv	a5,tp
    intena = mycpu()->intena;
    80001486:	00007917          	auipc	s2,0x7
    8000148a:	49a90913          	addi	s2,s2,1178 # 80008920 <pid_lock>
    8000148e:	2781                	sext.w	a5,a5
    80001490:	079e                	slli	a5,a5,0x7
    80001492:	97ca                	add	a5,a5,s2
    80001494:	0ac7a983          	lw	s3,172(a5)
    80001498:	8792                	mv	a5,tp
    swtch(&p->context, &mycpu()->context);
    8000149a:	2781                	sext.w	a5,a5
    8000149c:	079e                	slli	a5,a5,0x7
    8000149e:	00007597          	auipc	a1,0x7
    800014a2:	4ba58593          	addi	a1,a1,1210 # 80008958 <cpus+0x8>
    800014a6:	95be                	add	a1,a1,a5
    800014a8:	06048513          	addi	a0,s1,96
    800014ac:	00000097          	auipc	ra,0x0
    800014b0:	600080e7          	jalr	1536(ra) # 80001aac <swtch>
    800014b4:	8792                	mv	a5,tp
    mycpu()->intena = intena;
    800014b6:	2781                	sext.w	a5,a5
    800014b8:	079e                	slli	a5,a5,0x7
    800014ba:	97ca                	add	a5,a5,s2
    800014bc:	0b37a623          	sw	s3,172(a5)
}
    800014c0:	70a2                	ld	ra,40(sp)
    800014c2:	7402                	ld	s0,32(sp)
    800014c4:	64e2                	ld	s1,24(sp)
    800014c6:	6942                	ld	s2,16(sp)
    800014c8:	69a2                	ld	s3,8(sp)
    800014ca:	6145                	addi	sp,sp,48
    800014cc:	8082                	ret
        panic("sched p->lock");
    800014ce:	00007517          	auipc	a0,0x7
    800014d2:	c9250513          	addi	a0,a0,-878 # 80008160 <etext+0x160>
    800014d6:	00005097          	auipc	ra,0x5
    800014da:	adc080e7          	jalr	-1316(ra) # 80005fb2 <panic>
        panic("sched locks");
    800014de:	00007517          	auipc	a0,0x7
    800014e2:	c9250513          	addi	a0,a0,-878 # 80008170 <etext+0x170>
    800014e6:	00005097          	auipc	ra,0x5
    800014ea:	acc080e7          	jalr	-1332(ra) # 80005fb2 <panic>
        panic("sched running");
    800014ee:	00007517          	auipc	a0,0x7
    800014f2:	c9250513          	addi	a0,a0,-878 # 80008180 <etext+0x180>
    800014f6:	00005097          	auipc	ra,0x5
    800014fa:	abc080e7          	jalr	-1348(ra) # 80005fb2 <panic>
        panic("sched interruptible");
    800014fe:	00007517          	auipc	a0,0x7
    80001502:	c9250513          	addi	a0,a0,-878 # 80008190 <etext+0x190>
    80001506:	00005097          	auipc	ra,0x5
    8000150a:	aac080e7          	jalr	-1364(ra) # 80005fb2 <panic>

000000008000150e <yield>:
{
    8000150e:	1101                	addi	sp,sp,-32
    80001510:	ec06                	sd	ra,24(sp)
    80001512:	e822                	sd	s0,16(sp)
    80001514:	e426                	sd	s1,8(sp)
    80001516:	1000                	addi	s0,sp,32
    struct proc *p = myproc();
    80001518:	00000097          	auipc	ra,0x0
    8000151c:	926080e7          	jalr	-1754(ra) # 80000e3e <myproc>
    80001520:	84aa                	mv	s1,a0
    acquire(&p->lock);
    80001522:	00005097          	auipc	ra,0x5
    80001526:	fda080e7          	jalr	-38(ra) # 800064fc <acquire>
    p->state = RUNNABLE;
    8000152a:	478d                	li	a5,3
    8000152c:	cc9c                	sw	a5,24(s1)
    sched();
    8000152e:	00000097          	auipc	ra,0x0
    80001532:	f0a080e7          	jalr	-246(ra) # 80001438 <sched>
    release(&p->lock);
    80001536:	8526                	mv	a0,s1
    80001538:	00005097          	auipc	ra,0x5
    8000153c:	078080e7          	jalr	120(ra) # 800065b0 <release>
}
    80001540:	60e2                	ld	ra,24(sp)
    80001542:	6442                	ld	s0,16(sp)
    80001544:	64a2                	ld	s1,8(sp)
    80001546:	6105                	addi	sp,sp,32
    80001548:	8082                	ret

000000008000154a <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void sleep(void *chan, struct spinlock *lk)
{
    8000154a:	7179                	addi	sp,sp,-48
    8000154c:	f406                	sd	ra,40(sp)
    8000154e:	f022                	sd	s0,32(sp)
    80001550:	ec26                	sd	s1,24(sp)
    80001552:	e84a                	sd	s2,16(sp)
    80001554:	e44e                	sd	s3,8(sp)
    80001556:	1800                	addi	s0,sp,48
    80001558:	89aa                	mv	s3,a0
    8000155a:	892e                	mv	s2,a1
    struct proc *p = myproc();
    8000155c:	00000097          	auipc	ra,0x0
    80001560:	8e2080e7          	jalr	-1822(ra) # 80000e3e <myproc>
    80001564:	84aa                	mv	s1,a0
    // Once we hold p->lock, we can be
    // guaranteed that we won't miss any wakeup
    // (wakeup locks p->lock),
    // so it's okay to release lk.

    acquire(&p->lock); // DOC: sleeplock1
    80001566:	00005097          	auipc	ra,0x5
    8000156a:	f96080e7          	jalr	-106(ra) # 800064fc <acquire>
    release(lk);
    8000156e:	854a                	mv	a0,s2
    80001570:	00005097          	auipc	ra,0x5
    80001574:	040080e7          	jalr	64(ra) # 800065b0 <release>

    // Go to sleep.
    p->chan = chan;
    80001578:	0334b023          	sd	s3,32(s1)
    p->state = SLEEPING;
    8000157c:	4789                	li	a5,2
    8000157e:	cc9c                	sw	a5,24(s1)

    sched();
    80001580:	00000097          	auipc	ra,0x0
    80001584:	eb8080e7          	jalr	-328(ra) # 80001438 <sched>

    // Tidy up.
    p->chan = 0;
    80001588:	0204b023          	sd	zero,32(s1)

    // Reacquire original lock.
    release(&p->lock);
    8000158c:	8526                	mv	a0,s1
    8000158e:	00005097          	auipc	ra,0x5
    80001592:	022080e7          	jalr	34(ra) # 800065b0 <release>
    acquire(lk);
    80001596:	854a                	mv	a0,s2
    80001598:	00005097          	auipc	ra,0x5
    8000159c:	f64080e7          	jalr	-156(ra) # 800064fc <acquire>
}
    800015a0:	70a2                	ld	ra,40(sp)
    800015a2:	7402                	ld	s0,32(sp)
    800015a4:	64e2                	ld	s1,24(sp)
    800015a6:	6942                	ld	s2,16(sp)
    800015a8:	69a2                	ld	s3,8(sp)
    800015aa:	6145                	addi	sp,sp,48
    800015ac:	8082                	ret

00000000800015ae <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void wakeup(void *chan)
{
    800015ae:	7139                	addi	sp,sp,-64
    800015b0:	fc06                	sd	ra,56(sp)
    800015b2:	f822                	sd	s0,48(sp)
    800015b4:	f426                	sd	s1,40(sp)
    800015b6:	f04a                	sd	s2,32(sp)
    800015b8:	ec4e                	sd	s3,24(sp)
    800015ba:	e852                	sd	s4,16(sp)
    800015bc:	e456                	sd	s5,8(sp)
    800015be:	0080                	addi	s0,sp,64
    800015c0:	8a2a                	mv	s4,a0
    struct proc *p;

    for (p = proc; p < &proc[NPROC]; p++)
    800015c2:	00007497          	auipc	s1,0x7
    800015c6:	78e48493          	addi	s1,s1,1934 # 80008d50 <proc>
    {
        if (p != myproc())
        {
            acquire(&p->lock);
            if (p->state == SLEEPING && p->chan == chan)
    800015ca:	4989                	li	s3,2
            {
                p->state = RUNNABLE;
    800015cc:	4a8d                	li	s5,3
    for (p = proc; p < &proc[NPROC]; p++)
    800015ce:	0001f917          	auipc	s2,0x1f
    800015d2:	18290913          	addi	s2,s2,386 # 80020750 <tickslock>
    800015d6:	a821                	j	800015ee <wakeup+0x40>
                p->state = RUNNABLE;
    800015d8:	0154ac23          	sw	s5,24(s1)
            }
            release(&p->lock);
    800015dc:	8526                	mv	a0,s1
    800015de:	00005097          	auipc	ra,0x5
    800015e2:	fd2080e7          	jalr	-46(ra) # 800065b0 <release>
    for (p = proc; p < &proc[NPROC]; p++)
    800015e6:	5e848493          	addi	s1,s1,1512
    800015ea:	03248463          	beq	s1,s2,80001612 <wakeup+0x64>
        if (p != myproc())
    800015ee:	00000097          	auipc	ra,0x0
    800015f2:	850080e7          	jalr	-1968(ra) # 80000e3e <myproc>
    800015f6:	fea488e3          	beq	s1,a0,800015e6 <wakeup+0x38>
            acquire(&p->lock);
    800015fa:	8526                	mv	a0,s1
    800015fc:	00005097          	auipc	ra,0x5
    80001600:	f00080e7          	jalr	-256(ra) # 800064fc <acquire>
            if (p->state == SLEEPING && p->chan == chan)
    80001604:	4c9c                	lw	a5,24(s1)
    80001606:	fd379be3          	bne	a5,s3,800015dc <wakeup+0x2e>
    8000160a:	709c                	ld	a5,32(s1)
    8000160c:	fd4798e3          	bne	a5,s4,800015dc <wakeup+0x2e>
    80001610:	b7e1                	j	800015d8 <wakeup+0x2a>
        }
    }
}
    80001612:	70e2                	ld	ra,56(sp)
    80001614:	7442                	ld	s0,48(sp)
    80001616:	74a2                	ld	s1,40(sp)
    80001618:	7902                	ld	s2,32(sp)
    8000161a:	69e2                	ld	s3,24(sp)
    8000161c:	6a42                	ld	s4,16(sp)
    8000161e:	6aa2                	ld	s5,8(sp)
    80001620:	6121                	addi	sp,sp,64
    80001622:	8082                	ret

0000000080001624 <reparent>:
{
    80001624:	7179                	addi	sp,sp,-48
    80001626:	f406                	sd	ra,40(sp)
    80001628:	f022                	sd	s0,32(sp)
    8000162a:	ec26                	sd	s1,24(sp)
    8000162c:	e84a                	sd	s2,16(sp)
    8000162e:	e44e                	sd	s3,8(sp)
    80001630:	e052                	sd	s4,0(sp)
    80001632:	1800                	addi	s0,sp,48
    80001634:	892a                	mv	s2,a0
    for (pp = proc; pp < &proc[NPROC]; pp++)
    80001636:	00007497          	auipc	s1,0x7
    8000163a:	71a48493          	addi	s1,s1,1818 # 80008d50 <proc>
            pp->parent = initproc;
    8000163e:	00007a17          	auipc	s4,0x7
    80001642:	2a2a0a13          	addi	s4,s4,674 # 800088e0 <initproc>
    for (pp = proc; pp < &proc[NPROC]; pp++)
    80001646:	0001f997          	auipc	s3,0x1f
    8000164a:	10a98993          	addi	s3,s3,266 # 80020750 <tickslock>
    8000164e:	a029                	j	80001658 <reparent+0x34>
    80001650:	5e848493          	addi	s1,s1,1512
    80001654:	01348d63          	beq	s1,s3,8000166e <reparent+0x4a>
        if (pp->parent == p)
    80001658:	7c9c                	ld	a5,56(s1)
    8000165a:	ff279be3          	bne	a5,s2,80001650 <reparent+0x2c>
            pp->parent = initproc;
    8000165e:	000a3503          	ld	a0,0(s4)
    80001662:	fc88                	sd	a0,56(s1)
            wakeup(initproc);
    80001664:	00000097          	auipc	ra,0x0
    80001668:	f4a080e7          	jalr	-182(ra) # 800015ae <wakeup>
    8000166c:	b7d5                	j	80001650 <reparent+0x2c>
}
    8000166e:	70a2                	ld	ra,40(sp)
    80001670:	7402                	ld	s0,32(sp)
    80001672:	64e2                	ld	s1,24(sp)
    80001674:	6942                	ld	s2,16(sp)
    80001676:	69a2                	ld	s3,8(sp)
    80001678:	6a02                	ld	s4,0(sp)
    8000167a:	6145                	addi	sp,sp,48
    8000167c:	8082                	ret

000000008000167e <exit>:
{
    8000167e:	7179                	addi	sp,sp,-48
    80001680:	f406                	sd	ra,40(sp)
    80001682:	f022                	sd	s0,32(sp)
    80001684:	ec26                	sd	s1,24(sp)
    80001686:	e84a                	sd	s2,16(sp)
    80001688:	e44e                	sd	s3,8(sp)
    8000168a:	e052                	sd	s4,0(sp)
    8000168c:	1800                	addi	s0,sp,48
    8000168e:	8a2a                	mv	s4,a0
    struct proc *p = myproc();
    80001690:	fffff097          	auipc	ra,0xfffff
    80001694:	7ae080e7          	jalr	1966(ra) # 80000e3e <myproc>
    80001698:	89aa                	mv	s3,a0
    if (p == initproc)
    8000169a:	00007797          	auipc	a5,0x7
    8000169e:	2467b783          	ld	a5,582(a5) # 800088e0 <initproc>
    800016a2:	0d050493          	addi	s1,a0,208
    800016a6:	15050913          	addi	s2,a0,336
    800016aa:	02a79363          	bne	a5,a0,800016d0 <exit+0x52>
        panic("init exiting");
    800016ae:	00007517          	auipc	a0,0x7
    800016b2:	afa50513          	addi	a0,a0,-1286 # 800081a8 <etext+0x1a8>
    800016b6:	00005097          	auipc	ra,0x5
    800016ba:	8fc080e7          	jalr	-1796(ra) # 80005fb2 <panic>
            fileclose(f);
    800016be:	00002097          	auipc	ra,0x2
    800016c2:	3ea080e7          	jalr	1002(ra) # 80003aa8 <fileclose>
            p->ofile[fd] = 0;
    800016c6:	0004b023          	sd	zero,0(s1)
    for (int fd = 0; fd < NOFILE; fd++)
    800016ca:	04a1                	addi	s1,s1,8
    800016cc:	01248563          	beq	s1,s2,800016d6 <exit+0x58>
        if (p->ofile[fd])
    800016d0:	6088                	ld	a0,0(s1)
    800016d2:	f575                	bnez	a0,800016be <exit+0x40>
    800016d4:	bfdd                	j	800016ca <exit+0x4c>
    begin_op();
    800016d6:	00002097          	auipc	ra,0x2
    800016da:	f06080e7          	jalr	-250(ra) # 800035dc <begin_op>
    iput(p->cwd);
    800016de:	1509b503          	ld	a0,336(s3)
    800016e2:	00001097          	auipc	ra,0x1
    800016e6:	6f2080e7          	jalr	1778(ra) # 80002dd4 <iput>
    end_op();
    800016ea:	00002097          	auipc	ra,0x2
    800016ee:	f72080e7          	jalr	-142(ra) # 8000365c <end_op>
    p->cwd = 0;
    800016f2:	1409b823          	sd	zero,336(s3)
    acquire(&wait_lock);
    800016f6:	00007497          	auipc	s1,0x7
    800016fa:	24248493          	addi	s1,s1,578 # 80008938 <wait_lock>
    800016fe:	8526                	mv	a0,s1
    80001700:	00005097          	auipc	ra,0x5
    80001704:	dfc080e7          	jalr	-516(ra) # 800064fc <acquire>
    reparent(p);
    80001708:	854e                	mv	a0,s3
    8000170a:	00000097          	auipc	ra,0x0
    8000170e:	f1a080e7          	jalr	-230(ra) # 80001624 <reparent>
    wakeup(p->parent);
    80001712:	0389b503          	ld	a0,56(s3)
    80001716:	00000097          	auipc	ra,0x0
    8000171a:	e98080e7          	jalr	-360(ra) # 800015ae <wakeup>
    acquire(&p->lock);
    8000171e:	854e                	mv	a0,s3
    80001720:	00005097          	auipc	ra,0x5
    80001724:	ddc080e7          	jalr	-548(ra) # 800064fc <acquire>
    p->xstate = status;
    80001728:	0349a623          	sw	s4,44(s3)
    p->state = ZOMBIE;
    8000172c:	4795                	li	a5,5
    8000172e:	00f9ac23          	sw	a5,24(s3)
    release(&wait_lock);
    80001732:	8526                	mv	a0,s1
    80001734:	00005097          	auipc	ra,0x5
    80001738:	e7c080e7          	jalr	-388(ra) # 800065b0 <release>
    sched();
    8000173c:	00000097          	auipc	ra,0x0
    80001740:	cfc080e7          	jalr	-772(ra) # 80001438 <sched>
    panic("zombie exit");
    80001744:	00007517          	auipc	a0,0x7
    80001748:	a7450513          	addi	a0,a0,-1420 # 800081b8 <etext+0x1b8>
    8000174c:	00005097          	auipc	ra,0x5
    80001750:	866080e7          	jalr	-1946(ra) # 80005fb2 <panic>

0000000080001754 <kill>:

// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int kill(int pid)
{
    80001754:	7179                	addi	sp,sp,-48
    80001756:	f406                	sd	ra,40(sp)
    80001758:	f022                	sd	s0,32(sp)
    8000175a:	ec26                	sd	s1,24(sp)
    8000175c:	e84a                	sd	s2,16(sp)
    8000175e:	e44e                	sd	s3,8(sp)
    80001760:	1800                	addi	s0,sp,48
    80001762:	892a                	mv	s2,a0
    struct proc *p;

    for (p = proc; p < &proc[NPROC]; p++)
    80001764:	00007497          	auipc	s1,0x7
    80001768:	5ec48493          	addi	s1,s1,1516 # 80008d50 <proc>
    8000176c:	0001f997          	auipc	s3,0x1f
    80001770:	fe498993          	addi	s3,s3,-28 # 80020750 <tickslock>
    {
        acquire(&p->lock);
    80001774:	8526                	mv	a0,s1
    80001776:	00005097          	auipc	ra,0x5
    8000177a:	d86080e7          	jalr	-634(ra) # 800064fc <acquire>
        if (p->pid == pid)
    8000177e:	589c                	lw	a5,48(s1)
    80001780:	01278d63          	beq	a5,s2,8000179a <kill+0x46>
                p->state = RUNNABLE;
            }
            release(&p->lock);
            return 0;
        }
        release(&p->lock);
    80001784:	8526                	mv	a0,s1
    80001786:	00005097          	auipc	ra,0x5
    8000178a:	e2a080e7          	jalr	-470(ra) # 800065b0 <release>
    for (p = proc; p < &proc[NPROC]; p++)
    8000178e:	5e848493          	addi	s1,s1,1512
    80001792:	ff3491e3          	bne	s1,s3,80001774 <kill+0x20>
    }
    return -1;
    80001796:	557d                	li	a0,-1
    80001798:	a829                	j	800017b2 <kill+0x5e>
            p->killed = 1;
    8000179a:	4785                	li	a5,1
    8000179c:	d49c                	sw	a5,40(s1)
            if (p->state == SLEEPING)
    8000179e:	4c98                	lw	a4,24(s1)
    800017a0:	4789                	li	a5,2
    800017a2:	00f70f63          	beq	a4,a5,800017c0 <kill+0x6c>
            release(&p->lock);
    800017a6:	8526                	mv	a0,s1
    800017a8:	00005097          	auipc	ra,0x5
    800017ac:	e08080e7          	jalr	-504(ra) # 800065b0 <release>
            return 0;
    800017b0:	4501                	li	a0,0
}
    800017b2:	70a2                	ld	ra,40(sp)
    800017b4:	7402                	ld	s0,32(sp)
    800017b6:	64e2                	ld	s1,24(sp)
    800017b8:	6942                	ld	s2,16(sp)
    800017ba:	69a2                	ld	s3,8(sp)
    800017bc:	6145                	addi	sp,sp,48
    800017be:	8082                	ret
                p->state = RUNNABLE;
    800017c0:	478d                	li	a5,3
    800017c2:	cc9c                	sw	a5,24(s1)
    800017c4:	b7cd                	j	800017a6 <kill+0x52>

00000000800017c6 <setkilled>:

void setkilled(struct proc *p)
{
    800017c6:	1101                	addi	sp,sp,-32
    800017c8:	ec06                	sd	ra,24(sp)
    800017ca:	e822                	sd	s0,16(sp)
    800017cc:	e426                	sd	s1,8(sp)
    800017ce:	1000                	addi	s0,sp,32
    800017d0:	84aa                	mv	s1,a0
    acquire(&p->lock);
    800017d2:	00005097          	auipc	ra,0x5
    800017d6:	d2a080e7          	jalr	-726(ra) # 800064fc <acquire>
    p->killed = 1;
    800017da:	4785                	li	a5,1
    800017dc:	d49c                	sw	a5,40(s1)
    release(&p->lock);
    800017de:	8526                	mv	a0,s1
    800017e0:	00005097          	auipc	ra,0x5
    800017e4:	dd0080e7          	jalr	-560(ra) # 800065b0 <release>
}
    800017e8:	60e2                	ld	ra,24(sp)
    800017ea:	6442                	ld	s0,16(sp)
    800017ec:	64a2                	ld	s1,8(sp)
    800017ee:	6105                	addi	sp,sp,32
    800017f0:	8082                	ret

00000000800017f2 <killed>:

int killed(struct proc *p)
{
    800017f2:	1101                	addi	sp,sp,-32
    800017f4:	ec06                	sd	ra,24(sp)
    800017f6:	e822                	sd	s0,16(sp)
    800017f8:	e426                	sd	s1,8(sp)
    800017fa:	e04a                	sd	s2,0(sp)
    800017fc:	1000                	addi	s0,sp,32
    800017fe:	84aa                	mv	s1,a0
    int k;

    acquire(&p->lock);
    80001800:	00005097          	auipc	ra,0x5
    80001804:	cfc080e7          	jalr	-772(ra) # 800064fc <acquire>
    k = p->killed;
    80001808:	0284a903          	lw	s2,40(s1)
    release(&p->lock);
    8000180c:	8526                	mv	a0,s1
    8000180e:	00005097          	auipc	ra,0x5
    80001812:	da2080e7          	jalr	-606(ra) # 800065b0 <release>
    return k;
}
    80001816:	854a                	mv	a0,s2
    80001818:	60e2                	ld	ra,24(sp)
    8000181a:	6442                	ld	s0,16(sp)
    8000181c:	64a2                	ld	s1,8(sp)
    8000181e:	6902                	ld	s2,0(sp)
    80001820:	6105                	addi	sp,sp,32
    80001822:	8082                	ret

0000000080001824 <wait>:
{
    80001824:	715d                	addi	sp,sp,-80
    80001826:	e486                	sd	ra,72(sp)
    80001828:	e0a2                	sd	s0,64(sp)
    8000182a:	fc26                	sd	s1,56(sp)
    8000182c:	f84a                	sd	s2,48(sp)
    8000182e:	f44e                	sd	s3,40(sp)
    80001830:	f052                	sd	s4,32(sp)
    80001832:	ec56                	sd	s5,24(sp)
    80001834:	e85a                	sd	s6,16(sp)
    80001836:	e45e                	sd	s7,8(sp)
    80001838:	e062                	sd	s8,0(sp)
    8000183a:	0880                	addi	s0,sp,80
    8000183c:	8b2a                	mv	s6,a0
    struct proc *p = myproc();
    8000183e:	fffff097          	auipc	ra,0xfffff
    80001842:	600080e7          	jalr	1536(ra) # 80000e3e <myproc>
    80001846:	892a                	mv	s2,a0
    acquire(&wait_lock);
    80001848:	00007517          	auipc	a0,0x7
    8000184c:	0f050513          	addi	a0,a0,240 # 80008938 <wait_lock>
    80001850:	00005097          	auipc	ra,0x5
    80001854:	cac080e7          	jalr	-852(ra) # 800064fc <acquire>
        havekids = 0;
    80001858:	4b81                	li	s7,0
                if (pp->state == ZOMBIE)
    8000185a:	4a15                	li	s4,5
        for (pp = proc; pp < &proc[NPROC]; pp++)
    8000185c:	0001f997          	auipc	s3,0x1f
    80001860:	ef498993          	addi	s3,s3,-268 # 80020750 <tickslock>
                havekids = 1;
    80001864:	4a85                	li	s5,1
        sleep(p, &wait_lock); // DOC: wait-sleep
    80001866:	00007c17          	auipc	s8,0x7
    8000186a:	0d2c0c13          	addi	s8,s8,210 # 80008938 <wait_lock>
        havekids = 0;
    8000186e:	875e                	mv	a4,s7
        for (pp = proc; pp < &proc[NPROC]; pp++)
    80001870:	00007497          	auipc	s1,0x7
    80001874:	4e048493          	addi	s1,s1,1248 # 80008d50 <proc>
    80001878:	a0bd                	j	800018e6 <wait+0xc2>
                    pid = pp->pid;
    8000187a:	0304a983          	lw	s3,48(s1)
                    if (addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    8000187e:	000b0e63          	beqz	s6,8000189a <wait+0x76>
    80001882:	4691                	li	a3,4
    80001884:	02c48613          	addi	a2,s1,44
    80001888:	85da                	mv	a1,s6
    8000188a:	05093503          	ld	a0,80(s2)
    8000188e:	fffff097          	auipc	ra,0xfffff
    80001892:	26e080e7          	jalr	622(ra) # 80000afc <copyout>
    80001896:	02054563          	bltz	a0,800018c0 <wait+0x9c>
                    freeproc(pp);
    8000189a:	8526                	mv	a0,s1
    8000189c:	fffff097          	auipc	ra,0xfffff
    800018a0:	754080e7          	jalr	1876(ra) # 80000ff0 <freeproc>
                    release(&pp->lock);
    800018a4:	8526                	mv	a0,s1
    800018a6:	00005097          	auipc	ra,0x5
    800018aa:	d0a080e7          	jalr	-758(ra) # 800065b0 <release>
                    release(&wait_lock);
    800018ae:	00007517          	auipc	a0,0x7
    800018b2:	08a50513          	addi	a0,a0,138 # 80008938 <wait_lock>
    800018b6:	00005097          	auipc	ra,0x5
    800018ba:	cfa080e7          	jalr	-774(ra) # 800065b0 <release>
                    return pid;
    800018be:	a0b5                	j	8000192a <wait+0x106>
                        release(&pp->lock);
    800018c0:	8526                	mv	a0,s1
    800018c2:	00005097          	auipc	ra,0x5
    800018c6:	cee080e7          	jalr	-786(ra) # 800065b0 <release>
                        release(&wait_lock);
    800018ca:	00007517          	auipc	a0,0x7
    800018ce:	06e50513          	addi	a0,a0,110 # 80008938 <wait_lock>
    800018d2:	00005097          	auipc	ra,0x5
    800018d6:	cde080e7          	jalr	-802(ra) # 800065b0 <release>
                        return -1;
    800018da:	59fd                	li	s3,-1
    800018dc:	a0b9                	j	8000192a <wait+0x106>
        for (pp = proc; pp < &proc[NPROC]; pp++)
    800018de:	5e848493          	addi	s1,s1,1512
    800018e2:	03348463          	beq	s1,s3,8000190a <wait+0xe6>
            if (pp->parent == p)
    800018e6:	7c9c                	ld	a5,56(s1)
    800018e8:	ff279be3          	bne	a5,s2,800018de <wait+0xba>
                acquire(&pp->lock);
    800018ec:	8526                	mv	a0,s1
    800018ee:	00005097          	auipc	ra,0x5
    800018f2:	c0e080e7          	jalr	-1010(ra) # 800064fc <acquire>
                if (pp->state == ZOMBIE)
    800018f6:	4c9c                	lw	a5,24(s1)
    800018f8:	f94781e3          	beq	a5,s4,8000187a <wait+0x56>
                release(&pp->lock);
    800018fc:	8526                	mv	a0,s1
    800018fe:	00005097          	auipc	ra,0x5
    80001902:	cb2080e7          	jalr	-846(ra) # 800065b0 <release>
                havekids = 1;
    80001906:	8756                	mv	a4,s5
    80001908:	bfd9                	j	800018de <wait+0xba>
        if (!havekids || killed(p))
    8000190a:	c719                	beqz	a4,80001918 <wait+0xf4>
    8000190c:	854a                	mv	a0,s2
    8000190e:	00000097          	auipc	ra,0x0
    80001912:	ee4080e7          	jalr	-284(ra) # 800017f2 <killed>
    80001916:	c51d                	beqz	a0,80001944 <wait+0x120>
            release(&wait_lock);
    80001918:	00007517          	auipc	a0,0x7
    8000191c:	02050513          	addi	a0,a0,32 # 80008938 <wait_lock>
    80001920:	00005097          	auipc	ra,0x5
    80001924:	c90080e7          	jalr	-880(ra) # 800065b0 <release>
            return -1;
    80001928:	59fd                	li	s3,-1
}
    8000192a:	854e                	mv	a0,s3
    8000192c:	60a6                	ld	ra,72(sp)
    8000192e:	6406                	ld	s0,64(sp)
    80001930:	74e2                	ld	s1,56(sp)
    80001932:	7942                	ld	s2,48(sp)
    80001934:	79a2                	ld	s3,40(sp)
    80001936:	7a02                	ld	s4,32(sp)
    80001938:	6ae2                	ld	s5,24(sp)
    8000193a:	6b42                	ld	s6,16(sp)
    8000193c:	6ba2                	ld	s7,8(sp)
    8000193e:	6c02                	ld	s8,0(sp)
    80001940:	6161                	addi	sp,sp,80
    80001942:	8082                	ret
        sleep(p, &wait_lock); // DOC: wait-sleep
    80001944:	85e2                	mv	a1,s8
    80001946:	854a                	mv	a0,s2
    80001948:	00000097          	auipc	ra,0x0
    8000194c:	c02080e7          	jalr	-1022(ra) # 8000154a <sleep>
        havekids = 0;
    80001950:	bf39                	j	8000186e <wait+0x4a>

0000000080001952 <either_copyout>:

// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    80001952:	7179                	addi	sp,sp,-48
    80001954:	f406                	sd	ra,40(sp)
    80001956:	f022                	sd	s0,32(sp)
    80001958:	ec26                	sd	s1,24(sp)
    8000195a:	e84a                	sd	s2,16(sp)
    8000195c:	e44e                	sd	s3,8(sp)
    8000195e:	e052                	sd	s4,0(sp)
    80001960:	1800                	addi	s0,sp,48
    80001962:	84aa                	mv	s1,a0
    80001964:	892e                	mv	s2,a1
    80001966:	89b2                	mv	s3,a2
    80001968:	8a36                	mv	s4,a3
    struct proc *p = myproc();
    8000196a:	fffff097          	auipc	ra,0xfffff
    8000196e:	4d4080e7          	jalr	1236(ra) # 80000e3e <myproc>
    if (user_dst)
    80001972:	c08d                	beqz	s1,80001994 <either_copyout+0x42>
    {
        return copyout(p->pagetable, dst, src, len);
    80001974:	86d2                	mv	a3,s4
    80001976:	864e                	mv	a2,s3
    80001978:	85ca                	mv	a1,s2
    8000197a:	6928                	ld	a0,80(a0)
    8000197c:	fffff097          	auipc	ra,0xfffff
    80001980:	180080e7          	jalr	384(ra) # 80000afc <copyout>
    else
    {
        memmove((char *)dst, src, len);
        return 0;
    }
}
    80001984:	70a2                	ld	ra,40(sp)
    80001986:	7402                	ld	s0,32(sp)
    80001988:	64e2                	ld	s1,24(sp)
    8000198a:	6942                	ld	s2,16(sp)
    8000198c:	69a2                	ld	s3,8(sp)
    8000198e:	6a02                	ld	s4,0(sp)
    80001990:	6145                	addi	sp,sp,48
    80001992:	8082                	ret
        memmove((char *)dst, src, len);
    80001994:	000a061b          	sext.w	a2,s4
    80001998:	85ce                	mv	a1,s3
    8000199a:	854a                	mv	a0,s2
    8000199c:	fffff097          	auipc	ra,0xfffff
    800019a0:	83c080e7          	jalr	-1988(ra) # 800001d8 <memmove>
        return 0;
    800019a4:	8526                	mv	a0,s1
    800019a6:	bff9                	j	80001984 <either_copyout+0x32>

00000000800019a8 <either_copyin>:

// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800019a8:	7179                	addi	sp,sp,-48
    800019aa:	f406                	sd	ra,40(sp)
    800019ac:	f022                	sd	s0,32(sp)
    800019ae:	ec26                	sd	s1,24(sp)
    800019b0:	e84a                	sd	s2,16(sp)
    800019b2:	e44e                	sd	s3,8(sp)
    800019b4:	e052                	sd	s4,0(sp)
    800019b6:	1800                	addi	s0,sp,48
    800019b8:	892a                	mv	s2,a0
    800019ba:	84ae                	mv	s1,a1
    800019bc:	89b2                	mv	s3,a2
    800019be:	8a36                	mv	s4,a3
    struct proc *p = myproc();
    800019c0:	fffff097          	auipc	ra,0xfffff
    800019c4:	47e080e7          	jalr	1150(ra) # 80000e3e <myproc>
    if (user_src)
    800019c8:	c08d                	beqz	s1,800019ea <either_copyin+0x42>
    {
        return copyin(p->pagetable, dst, src, len);
    800019ca:	86d2                	mv	a3,s4
    800019cc:	864e                	mv	a2,s3
    800019ce:	85ca                	mv	a1,s2
    800019d0:	6928                	ld	a0,80(a0)
    800019d2:	fffff097          	auipc	ra,0xfffff
    800019d6:	1b6080e7          	jalr	438(ra) # 80000b88 <copyin>
    else
    {
        memmove(dst, (char *)src, len);
        return 0;
    }
}
    800019da:	70a2                	ld	ra,40(sp)
    800019dc:	7402                	ld	s0,32(sp)
    800019de:	64e2                	ld	s1,24(sp)
    800019e0:	6942                	ld	s2,16(sp)
    800019e2:	69a2                	ld	s3,8(sp)
    800019e4:	6a02                	ld	s4,0(sp)
    800019e6:	6145                	addi	sp,sp,48
    800019e8:	8082                	ret
        memmove(dst, (char *)src, len);
    800019ea:	000a061b          	sext.w	a2,s4
    800019ee:	85ce                	mv	a1,s3
    800019f0:	854a                	mv	a0,s2
    800019f2:	ffffe097          	auipc	ra,0xffffe
    800019f6:	7e6080e7          	jalr	2022(ra) # 800001d8 <memmove>
        return 0;
    800019fa:	8526                	mv	a0,s1
    800019fc:	bff9                	j	800019da <either_copyin+0x32>

00000000800019fe <procdump>:

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void procdump(void)
{
    800019fe:	715d                	addi	sp,sp,-80
    80001a00:	e486                	sd	ra,72(sp)
    80001a02:	e0a2                	sd	s0,64(sp)
    80001a04:	fc26                	sd	s1,56(sp)
    80001a06:	f84a                	sd	s2,48(sp)
    80001a08:	f44e                	sd	s3,40(sp)
    80001a0a:	f052                	sd	s4,32(sp)
    80001a0c:	ec56                	sd	s5,24(sp)
    80001a0e:	e85a                	sd	s6,16(sp)
    80001a10:	e45e                	sd	s7,8(sp)
    80001a12:	0880                	addi	s0,sp,80
        [RUNNING] "run   ",
        [ZOMBIE] "zombie"};
    struct proc *p;
    char *state;

    printf("\n");
    80001a14:	00006517          	auipc	a0,0x6
    80001a18:	63450513          	addi	a0,a0,1588 # 80008048 <etext+0x48>
    80001a1c:	00004097          	auipc	ra,0x4
    80001a20:	5e0080e7          	jalr	1504(ra) # 80005ffc <printf>
    for (p = proc; p < &proc[NPROC]; p++)
    80001a24:	00007497          	auipc	s1,0x7
    80001a28:	48448493          	addi	s1,s1,1156 # 80008ea8 <proc+0x158>
    80001a2c:	0001f917          	auipc	s2,0x1f
    80001a30:	e7c90913          	addi	s2,s2,-388 # 800208a8 <bcache+0x140>
    {
        if (p->state == UNUSED)
            continue;
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a34:	4b15                	li	s6,5
            state = states[p->state];
        else
            state = "???";
    80001a36:	00006997          	auipc	s3,0x6
    80001a3a:	79298993          	addi	s3,s3,1938 # 800081c8 <etext+0x1c8>
        printf("%d %s %s", p->pid, state, p->name);
    80001a3e:	00006a97          	auipc	s5,0x6
    80001a42:	792a8a93          	addi	s5,s5,1938 # 800081d0 <etext+0x1d0>
        printf("\n");
    80001a46:	00006a17          	auipc	s4,0x6
    80001a4a:	602a0a13          	addi	s4,s4,1538 # 80008048 <etext+0x48>
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a4e:	00006b97          	auipc	s7,0x6
    80001a52:	7c2b8b93          	addi	s7,s7,1986 # 80008210 <states.1744>
    80001a56:	a00d                	j	80001a78 <procdump+0x7a>
        printf("%d %s %s", p->pid, state, p->name);
    80001a58:	ed86a583          	lw	a1,-296(a3)
    80001a5c:	8556                	mv	a0,s5
    80001a5e:	00004097          	auipc	ra,0x4
    80001a62:	59e080e7          	jalr	1438(ra) # 80005ffc <printf>
        printf("\n");
    80001a66:	8552                	mv	a0,s4
    80001a68:	00004097          	auipc	ra,0x4
    80001a6c:	594080e7          	jalr	1428(ra) # 80005ffc <printf>
    for (p = proc; p < &proc[NPROC]; p++)
    80001a70:	5e848493          	addi	s1,s1,1512
    80001a74:	03248163          	beq	s1,s2,80001a96 <procdump+0x98>
        if (p->state == UNUSED)
    80001a78:	86a6                	mv	a3,s1
    80001a7a:	ec04a783          	lw	a5,-320(s1)
    80001a7e:	dbed                	beqz	a5,80001a70 <procdump+0x72>
            state = "???";
    80001a80:	864e                	mv	a2,s3
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a82:	fcfb6be3          	bltu	s6,a5,80001a58 <procdump+0x5a>
    80001a86:	1782                	slli	a5,a5,0x20
    80001a88:	9381                	srli	a5,a5,0x20
    80001a8a:	078e                	slli	a5,a5,0x3
    80001a8c:	97de                	add	a5,a5,s7
    80001a8e:	6390                	ld	a2,0(a5)
    80001a90:	f661                	bnez	a2,80001a58 <procdump+0x5a>
            state = "???";
    80001a92:	864e                	mv	a2,s3
    80001a94:	b7d1                	j	80001a58 <procdump+0x5a>
    }
}
    80001a96:	60a6                	ld	ra,72(sp)
    80001a98:	6406                	ld	s0,64(sp)
    80001a9a:	74e2                	ld	s1,56(sp)
    80001a9c:	7942                	ld	s2,48(sp)
    80001a9e:	79a2                	ld	s3,40(sp)
    80001aa0:	7a02                	ld	s4,32(sp)
    80001aa2:	6ae2                	ld	s5,24(sp)
    80001aa4:	6b42                	ld	s6,16(sp)
    80001aa6:	6ba2                	ld	s7,8(sp)
    80001aa8:	6161                	addi	sp,sp,80
    80001aaa:	8082                	ret

0000000080001aac <swtch>:
    80001aac:	00153023          	sd	ra,0(a0)
    80001ab0:	00253423          	sd	sp,8(a0)
    80001ab4:	e900                	sd	s0,16(a0)
    80001ab6:	ed04                	sd	s1,24(a0)
    80001ab8:	03253023          	sd	s2,32(a0)
    80001abc:	03353423          	sd	s3,40(a0)
    80001ac0:	03453823          	sd	s4,48(a0)
    80001ac4:	03553c23          	sd	s5,56(a0)
    80001ac8:	05653023          	sd	s6,64(a0)
    80001acc:	05753423          	sd	s7,72(a0)
    80001ad0:	05853823          	sd	s8,80(a0)
    80001ad4:	05953c23          	sd	s9,88(a0)
    80001ad8:	07a53023          	sd	s10,96(a0)
    80001adc:	07b53423          	sd	s11,104(a0)
    80001ae0:	0005b083          	ld	ra,0(a1)
    80001ae4:	0085b103          	ld	sp,8(a1)
    80001ae8:	6980                	ld	s0,16(a1)
    80001aea:	6d84                	ld	s1,24(a1)
    80001aec:	0205b903          	ld	s2,32(a1)
    80001af0:	0285b983          	ld	s3,40(a1)
    80001af4:	0305ba03          	ld	s4,48(a1)
    80001af8:	0385ba83          	ld	s5,56(a1)
    80001afc:	0405bb03          	ld	s6,64(a1)
    80001b00:	0485bb83          	ld	s7,72(a1)
    80001b04:	0505bc03          	ld	s8,80(a1)
    80001b08:	0585bc83          	ld	s9,88(a1)
    80001b0c:	0605bd03          	ld	s10,96(a1)
    80001b10:	0685bd83          	ld	s11,104(a1)
    80001b14:	8082                	ret

0000000080001b16 <trapinit>:
void kernelvec();

extern int devintr();

void trapinit(void)
{
    80001b16:	1141                	addi	sp,sp,-16
    80001b18:	e406                	sd	ra,8(sp)
    80001b1a:	e022                	sd	s0,0(sp)
    80001b1c:	0800                	addi	s0,sp,16
    initlock(&tickslock, "time");
    80001b1e:	00006597          	auipc	a1,0x6
    80001b22:	72258593          	addi	a1,a1,1826 # 80008240 <states.1744+0x30>
    80001b26:	0001f517          	auipc	a0,0x1f
    80001b2a:	c2a50513          	addi	a0,a0,-982 # 80020750 <tickslock>
    80001b2e:	00005097          	auipc	ra,0x5
    80001b32:	93e080e7          	jalr	-1730(ra) # 8000646c <initlock>
}
    80001b36:	60a2                	ld	ra,8(sp)
    80001b38:	6402                	ld	s0,0(sp)
    80001b3a:	0141                	addi	sp,sp,16
    80001b3c:	8082                	ret

0000000080001b3e <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void trapinithart(void)
{
    80001b3e:	1141                	addi	sp,sp,-16
    80001b40:	e422                	sd	s0,8(sp)
    80001b42:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b44:	00004797          	auipc	a5,0x4
    80001b48:	83c78793          	addi	a5,a5,-1988 # 80005380 <kernelvec>
    80001b4c:	10579073          	csrw	stvec,a5
    w_stvec((uint64)kernelvec);
}
    80001b50:	6422                	ld	s0,8(sp)
    80001b52:	0141                	addi	sp,sp,16
    80001b54:	8082                	ret

0000000080001b56 <usertrapret>:

//
// return to user space
//
void usertrapret(void)
{
    80001b56:	1141                	addi	sp,sp,-16
    80001b58:	e406                	sd	ra,8(sp)
    80001b5a:	e022                	sd	s0,0(sp)
    80001b5c:	0800                	addi	s0,sp,16
    struct proc *p = myproc();
    80001b5e:	fffff097          	auipc	ra,0xfffff
    80001b62:	2e0080e7          	jalr	736(ra) # 80000e3e <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b66:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001b6a:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b6c:	10079073          	csrw	sstatus,a5
    // kerneltrap() to usertrap(), so turn off interrupts until
    // we're back in user space, where usertrap() is correct.
    intr_off();

    // send syscalls, interrupts, and exceptions to uservec in trampoline.S
    uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001b70:	00005617          	auipc	a2,0x5
    80001b74:	49060613          	addi	a2,a2,1168 # 80007000 <_trampoline>
    80001b78:	00005697          	auipc	a3,0x5
    80001b7c:	48868693          	addi	a3,a3,1160 # 80007000 <_trampoline>
    80001b80:	8e91                	sub	a3,a3,a2
    80001b82:	040007b7          	lui	a5,0x4000
    80001b86:	17fd                	addi	a5,a5,-1
    80001b88:	07b2                	slli	a5,a5,0xc
    80001b8a:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b8c:	10569073          	csrw	stvec,a3
    w_stvec(trampoline_uservec);

    // set up trapframe values that uservec will need when
    // the process next traps into the kernel.
    p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001b90:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001b92:	180026f3          	csrr	a3,satp
    80001b96:	e314                	sd	a3,0(a4)
    p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001b98:	6d38                	ld	a4,88(a0)
    80001b9a:	6134                	ld	a3,64(a0)
    80001b9c:	6585                	lui	a1,0x1
    80001b9e:	96ae                	add	a3,a3,a1
    80001ba0:	e714                	sd	a3,8(a4)
    p->trapframe->kernel_trap = (uint64)usertrap;
    80001ba2:	6d38                	ld	a4,88(a0)
    80001ba4:	00000697          	auipc	a3,0x0
    80001ba8:	13068693          	addi	a3,a3,304 # 80001cd4 <usertrap>
    80001bac:	eb14                	sd	a3,16(a4)
    p->trapframe->kernel_hartid = r_tp(); // hartid for cpuid()
    80001bae:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001bb0:	8692                	mv	a3,tp
    80001bb2:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001bb4:	100026f3          	csrr	a3,sstatus
    // set up the registers that trampoline.S's sret will use
    // to get to user space.

    // set S Previous Privilege mode to User.
    unsigned long x = r_sstatus();
    x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001bb8:	eff6f693          	andi	a3,a3,-257
    x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001bbc:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001bc0:	10069073          	csrw	sstatus,a3
    w_sstatus(x);

    // set S Exception Program Counter to the saved user pc.
    w_sepc(p->trapframe->epc);
    80001bc4:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001bc6:	6f18                	ld	a4,24(a4)
    80001bc8:	14171073          	csrw	sepc,a4

    // tell trampoline.S the user page table to switch to.
    uint64 satp = MAKE_SATP(p->pagetable);
    80001bcc:	6928                	ld	a0,80(a0)
    80001bce:	8131                	srli	a0,a0,0xc

    // jump to userret in trampoline.S at the top of memory, which
    // switches to the user page table, restores user registers,
    // and switches to user mode with sret.
    uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001bd0:	00005717          	auipc	a4,0x5
    80001bd4:	4cc70713          	addi	a4,a4,1228 # 8000709c <userret>
    80001bd8:	8f11                	sub	a4,a4,a2
    80001bda:	97ba                	add	a5,a5,a4
    ((void (*)(uint64))trampoline_userret)(satp);
    80001bdc:	577d                	li	a4,-1
    80001bde:	177e                	slli	a4,a4,0x3f
    80001be0:	8d59                	or	a0,a0,a4
    80001be2:	9782                	jalr	a5
}
    80001be4:	60a2                	ld	ra,8(sp)
    80001be6:	6402                	ld	s0,0(sp)
    80001be8:	0141                	addi	sp,sp,16
    80001bea:	8082                	ret

0000000080001bec <clockintr>:
    w_sepc(sepc);
    w_sstatus(sstatus);
}

void clockintr()
{
    80001bec:	1101                	addi	sp,sp,-32
    80001bee:	ec06                	sd	ra,24(sp)
    80001bf0:	e822                	sd	s0,16(sp)
    80001bf2:	e426                	sd	s1,8(sp)
    80001bf4:	1000                	addi	s0,sp,32
    acquire(&tickslock);
    80001bf6:	0001f497          	auipc	s1,0x1f
    80001bfa:	b5a48493          	addi	s1,s1,-1190 # 80020750 <tickslock>
    80001bfe:	8526                	mv	a0,s1
    80001c00:	00005097          	auipc	ra,0x5
    80001c04:	8fc080e7          	jalr	-1796(ra) # 800064fc <acquire>
    ticks++;
    80001c08:	00007517          	auipc	a0,0x7
    80001c0c:	ce050513          	addi	a0,a0,-800 # 800088e8 <ticks>
    80001c10:	411c                	lw	a5,0(a0)
    80001c12:	2785                	addiw	a5,a5,1
    80001c14:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    80001c16:	00000097          	auipc	ra,0x0
    80001c1a:	998080e7          	jalr	-1640(ra) # 800015ae <wakeup>
    release(&tickslock);
    80001c1e:	8526                	mv	a0,s1
    80001c20:	00005097          	auipc	ra,0x5
    80001c24:	990080e7          	jalr	-1648(ra) # 800065b0 <release>
}
    80001c28:	60e2                	ld	ra,24(sp)
    80001c2a:	6442                	ld	s0,16(sp)
    80001c2c:	64a2                	ld	s1,8(sp)
    80001c2e:	6105                	addi	sp,sp,32
    80001c30:	8082                	ret

0000000080001c32 <devintr>:
// and handle it.
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int devintr()
{
    80001c32:	1101                	addi	sp,sp,-32
    80001c34:	ec06                	sd	ra,24(sp)
    80001c36:	e822                	sd	s0,16(sp)
    80001c38:	e426                	sd	s1,8(sp)
    80001c3a:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001c3c:	14202773          	csrr	a4,scause
    uint64 scause = r_scause();

    if ((scause & 0x8000000000000000L) &&
    80001c40:	00074d63          	bltz	a4,80001c5a <devintr+0x28>
        if (irq)
            plic_complete(irq);

        return 1;
    }
    else if (scause == 0x8000000000000001L)
    80001c44:	57fd                	li	a5,-1
    80001c46:	17fe                	slli	a5,a5,0x3f
    80001c48:	0785                	addi	a5,a5,1

        return 2;
    }
    else
    {
        return 0;
    80001c4a:	4501                	li	a0,0
    else if (scause == 0x8000000000000001L)
    80001c4c:	06f70363          	beq	a4,a5,80001cb2 <devintr+0x80>
    }
}
    80001c50:	60e2                	ld	ra,24(sp)
    80001c52:	6442                	ld	s0,16(sp)
    80001c54:	64a2                	ld	s1,8(sp)
    80001c56:	6105                	addi	sp,sp,32
    80001c58:	8082                	ret
        (scause & 0xff) == 9)
    80001c5a:	0ff77793          	andi	a5,a4,255
    if ((scause & 0x8000000000000000L) &&
    80001c5e:	46a5                	li	a3,9
    80001c60:	fed792e3          	bne	a5,a3,80001c44 <devintr+0x12>
        int irq = plic_claim();
    80001c64:	00004097          	auipc	ra,0x4
    80001c68:	824080e7          	jalr	-2012(ra) # 80005488 <plic_claim>
    80001c6c:	84aa                	mv	s1,a0
        if (irq == UART0_IRQ)
    80001c6e:	47a9                	li	a5,10
    80001c70:	02f50763          	beq	a0,a5,80001c9e <devintr+0x6c>
        else if (irq == VIRTIO0_IRQ)
    80001c74:	4785                	li	a5,1
    80001c76:	02f50963          	beq	a0,a5,80001ca8 <devintr+0x76>
        return 1;
    80001c7a:	4505                	li	a0,1
        else if (irq)
    80001c7c:	d8f1                	beqz	s1,80001c50 <devintr+0x1e>
            printf("unexpected interrupt irq=%d\n", irq);
    80001c7e:	85a6                	mv	a1,s1
    80001c80:	00006517          	auipc	a0,0x6
    80001c84:	5c850513          	addi	a0,a0,1480 # 80008248 <states.1744+0x38>
    80001c88:	00004097          	auipc	ra,0x4
    80001c8c:	374080e7          	jalr	884(ra) # 80005ffc <printf>
            plic_complete(irq);
    80001c90:	8526                	mv	a0,s1
    80001c92:	00004097          	auipc	ra,0x4
    80001c96:	81a080e7          	jalr	-2022(ra) # 800054ac <plic_complete>
        return 1;
    80001c9a:	4505                	li	a0,1
    80001c9c:	bf55                	j	80001c50 <devintr+0x1e>
            uartintr();
    80001c9e:	00004097          	auipc	ra,0x4
    80001ca2:	77e080e7          	jalr	1918(ra) # 8000641c <uartintr>
    80001ca6:	b7ed                	j	80001c90 <devintr+0x5e>
            virtio_disk_intr();
    80001ca8:	00004097          	auipc	ra,0x4
    80001cac:	d2e080e7          	jalr	-722(ra) # 800059d6 <virtio_disk_intr>
    80001cb0:	b7c5                	j	80001c90 <devintr+0x5e>
        if (cpuid() == 0)
    80001cb2:	fffff097          	auipc	ra,0xfffff
    80001cb6:	160080e7          	jalr	352(ra) # 80000e12 <cpuid>
    80001cba:	c901                	beqz	a0,80001cca <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001cbc:	144027f3          	csrr	a5,sip
        w_sip(r_sip() & ~2);
    80001cc0:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001cc2:	14479073          	csrw	sip,a5
        return 2;
    80001cc6:	4509                	li	a0,2
    80001cc8:	b761                	j	80001c50 <devintr+0x1e>
            clockintr();
    80001cca:	00000097          	auipc	ra,0x0
    80001cce:	f22080e7          	jalr	-222(ra) # 80001bec <clockintr>
    80001cd2:	b7ed                	j	80001cbc <devintr+0x8a>

0000000080001cd4 <usertrap>:
{
    80001cd4:	7139                	addi	sp,sp,-64
    80001cd6:	fc06                	sd	ra,56(sp)
    80001cd8:	f822                	sd	s0,48(sp)
    80001cda:	f426                	sd	s1,40(sp)
    80001cdc:	f04a                	sd	s2,32(sp)
    80001cde:	ec4e                	sd	s3,24(sp)
    80001ce0:	e852                	sd	s4,16(sp)
    80001ce2:	e456                	sd	s5,8(sp)
    80001ce4:	e05a                	sd	s6,0(sp)
    80001ce6:	0080                	addi	s0,sp,64
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ce8:	100027f3          	csrr	a5,sstatus
    if ((r_sstatus() & SSTATUS_SPP) != 0)
    80001cec:	1007f793          	andi	a5,a5,256
    80001cf0:	e7c1                	bnez	a5,80001d78 <usertrap+0xa4>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001cf2:	00003797          	auipc	a5,0x3
    80001cf6:	68e78793          	addi	a5,a5,1678 # 80005380 <kernelvec>
    80001cfa:	10579073          	csrw	stvec,a5
    struct proc *p = myproc();
    80001cfe:	fffff097          	auipc	ra,0xfffff
    80001d02:	140080e7          	jalr	320(ra) # 80000e3e <myproc>
    80001d06:	892a                	mv	s2,a0
    p->trapframe->epc = r_sepc();
    80001d08:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d0a:	14102773          	csrr	a4,sepc
    80001d0e:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d10:	14202773          	csrr	a4,scause
    if (r_scause() == 8)
    80001d14:	47a1                	li	a5,8
    80001d16:	06f70963          	beq	a4,a5,80001d88 <usertrap+0xb4>
    else if ((which_dev = devintr()) != 0)
    80001d1a:	00000097          	auipc	ra,0x0
    80001d1e:	f18080e7          	jalr	-232(ra) # 80001c32 <devintr>
    80001d22:	84aa                	mv	s1,a0
    80001d24:	18051063          	bnez	a0,80001ea4 <usertrap+0x1d0>
    80001d28:	14202773          	csrr	a4,scause
    else if (r_scause() == 13 || r_scause() == 15)
    80001d2c:	47b5                	li	a5,13
    80001d2e:	0af70b63          	beq	a4,a5,80001de4 <usertrap+0x110>
    80001d32:	14202773          	csrr	a4,scause
    80001d36:	47bd                	li	a5,15
    80001d38:	0af70663          	beq	a4,a5,80001de4 <usertrap+0x110>
    80001d3c:	142025f3          	csrr	a1,scause
        printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001d40:	03092603          	lw	a2,48(s2)
    80001d44:	00006517          	auipc	a0,0x6
    80001d48:	56c50513          	addi	a0,a0,1388 # 800082b0 <states.1744+0xa0>
    80001d4c:	00004097          	auipc	ra,0x4
    80001d50:	2b0080e7          	jalr	688(ra) # 80005ffc <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d54:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001d58:	14302673          	csrr	a2,stval
        printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001d5c:	00006517          	auipc	a0,0x6
    80001d60:	58450513          	addi	a0,a0,1412 # 800082e0 <states.1744+0xd0>
    80001d64:	00004097          	auipc	ra,0x4
    80001d68:	298080e7          	jalr	664(ra) # 80005ffc <printf>
        setkilled(p);
    80001d6c:	854a                	mv	a0,s2
    80001d6e:	00000097          	auipc	ra,0x0
    80001d72:	a58080e7          	jalr	-1448(ra) # 800017c6 <setkilled>
    80001d76:	a82d                	j	80001db0 <usertrap+0xdc>
        panic("usertrap: not from user mode");
    80001d78:	00006517          	auipc	a0,0x6
    80001d7c:	4f050513          	addi	a0,a0,1264 # 80008268 <states.1744+0x58>
    80001d80:	00004097          	auipc	ra,0x4
    80001d84:	232080e7          	jalr	562(ra) # 80005fb2 <panic>
        if (killed(p))
    80001d88:	00000097          	auipc	ra,0x0
    80001d8c:	a6a080e7          	jalr	-1430(ra) # 800017f2 <killed>
    80001d90:	e521                	bnez	a0,80001dd8 <usertrap+0x104>
        p->trapframe->epc += 4;
    80001d92:	05893703          	ld	a4,88(s2)
    80001d96:	6f1c                	ld	a5,24(a4)
    80001d98:	0791                	addi	a5,a5,4
    80001d9a:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d9c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001da0:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001da4:	10079073          	csrw	sstatus,a5
        syscall();
    80001da8:	00000097          	auipc	ra,0x0
    80001dac:	370080e7          	jalr	880(ra) # 80002118 <syscall>
    if (killed(p))
    80001db0:	854a                	mv	a0,s2
    80001db2:	00000097          	auipc	ra,0x0
    80001db6:	a40080e7          	jalr	-1472(ra) # 800017f2 <killed>
    80001dba:	ed65                	bnez	a0,80001eb2 <usertrap+0x1de>
    usertrapret();
    80001dbc:	00000097          	auipc	ra,0x0
    80001dc0:	d9a080e7          	jalr	-614(ra) # 80001b56 <usertrapret>
}
    80001dc4:	70e2                	ld	ra,56(sp)
    80001dc6:	7442                	ld	s0,48(sp)
    80001dc8:	74a2                	ld	s1,40(sp)
    80001dca:	7902                	ld	s2,32(sp)
    80001dcc:	69e2                	ld	s3,24(sp)
    80001dce:	6a42                	ld	s4,16(sp)
    80001dd0:	6aa2                	ld	s5,8(sp)
    80001dd2:	6b02                	ld	s6,0(sp)
    80001dd4:	6121                	addi	sp,sp,64
    80001dd6:	8082                	ret
            exit(-1);
    80001dd8:	557d                	li	a0,-1
    80001dda:	00000097          	auipc	ra,0x0
    80001dde:	8a4080e7          	jalr	-1884(ra) # 8000167e <exit>
    80001de2:	bf45                	j	80001d92 <usertrap+0xbe>
        struct proc *p_proc = myproc();
    80001de4:	fffff097          	auipc	ra,0xfffff
    80001de8:	05a080e7          	jalr	90(ra) # 80000e3e <myproc>
    80001dec:	8a2a                	mv	s4,a0
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001dee:	143029f3          	csrr	s3,stval
        for (int i = 0; i <= VMASIZE - 1; i++)
    80001df2:	16850793          	addi	a5,a0,360
            if (p_proc->vma[i].occupied == 1)
    80001df6:	4605                	li	a2,1
        for (int i = 0; i <= VMASIZE - 1; i++)
    80001df8:	45c1                	li	a1,16
    80001dfa:	a031                	j	80001e06 <usertrap+0x132>
    80001dfc:	2485                	addiw	s1,s1,1
    80001dfe:	04878793          	addi	a5,a5,72
    80001e02:	08b48863          	beq	s1,a1,80001e92 <usertrap+0x1be>
            if (p_proc->vma[i].occupied == 1)
    80001e06:	4398                	lw	a4,0(a5)
    80001e08:	fec71ae3          	bne	a4,a2,80001dfc <usertrap+0x128>
                if (p_proc->vma[i].start_addr <= va && va <= p_proc->vma[i].end_addr)
    80001e0c:	6798                	ld	a4,8(a5)
    80001e0e:	fee9e7e3          	bltu	s3,a4,80001dfc <usertrap+0x128>
    80001e12:	6b98                	ld	a4,16(a5)
    80001e14:	ff3764e3          	bltu	a4,s3,80001dfc <usertrap+0x128>
            char *mem = (char *)kalloc(); // find spare space
    80001e18:	ffffe097          	auipc	ra,0xffffe
    80001e1c:	300080e7          	jalr	768(ra) # 80000118 <kalloc>
    80001e20:	8b2a                	mv	s6,a0
            if (mem == 0)
    80001e22:	c135                	beqz	a0,80001e86 <usertrap+0x1b2>
                memset(mem, 0, PGSIZE);
    80001e24:	6605                	lui	a2,0x1
    80001e26:	4581                	li	a1,0
    80001e28:	ffffe097          	auipc	ra,0xffffe
    80001e2c:	350080e7          	jalr	848(ra) # 80000178 <memset>
                mapfile(p_vma->pf, mem, va - p_vma->start_addr);
    80001e30:	00349a93          	slli	s5,s1,0x3
    80001e34:	009a87b3          	add	a5,s5,s1
    80001e38:	078e                	slli	a5,a5,0x3
    80001e3a:	97d2                	add	a5,a5,s4
    80001e3c:	1707b603          	ld	a2,368(a5)
    80001e40:	40c9863b          	subw	a2,s3,a2
    80001e44:	85da                	mv	a1,s6
    80001e46:	1a87b503          	ld	a0,424(a5)
    80001e4a:	00002097          	auipc	ra,0x2
    80001e4e:	d98080e7          	jalr	-616(ra) # 80003be2 <mapfile>
                int flags = (p_vma->prot | PTE_R | PTE_X | PTE_W | PTE_U);
    80001e52:	009a87b3          	add	a5,s5,s1
    80001e56:	078e                	slli	a5,a5,0x3
    80001e58:	97d2                	add	a5,a5,s4
    80001e5a:	1907a703          	lw	a4,400(a5)
                if (mappages(p_proc->pagetable, va, PGSIZE, (uint64)mem, flags) == -1)
    80001e5e:	01e76713          	ori	a4,a4,30
    80001e62:	86da                	mv	a3,s6
    80001e64:	6605                	lui	a2,0x1
    80001e66:	85ce                	mv	a1,s3
    80001e68:	050a3503          	ld	a0,80(s4)
    80001e6c:	ffffe097          	auipc	ra,0xffffe
    80001e70:	6e0080e7          	jalr	1760(ra) # 8000054c <mappages>
    80001e74:	57fd                	li	a5,-1
    80001e76:	f2f51de3          	bne	a0,a5,80001db0 <usertrap+0xdc>
                    setkilled(p_proc);
    80001e7a:	8552                	mv	a0,s4
    80001e7c:	00000097          	auipc	ra,0x0
    80001e80:	94a080e7          	jalr	-1718(ra) # 800017c6 <setkilled>
    80001e84:	b735                	j	80001db0 <usertrap+0xdc>
                setkilled(p_proc);
    80001e86:	8552                	mv	a0,s4
    80001e88:	00000097          	auipc	ra,0x0
    80001e8c:	93e080e7          	jalr	-1730(ra) # 800017c6 <setkilled>
    80001e90:	b705                	j	80001db0 <usertrap+0xdc>
            printf("Now, after mmap, we get a page fault\n");
    80001e92:	00006517          	auipc	a0,0x6
    80001e96:	3f650513          	addi	a0,a0,1014 # 80008288 <states.1744+0x78>
    80001e9a:	00004097          	auipc	ra,0x4
    80001e9e:	162080e7          	jalr	354(ra) # 80005ffc <printf>
            goto err;
    80001ea2:	bd69                	j	80001d3c <usertrap+0x68>
    if (killed(p))
    80001ea4:	854a                	mv	a0,s2
    80001ea6:	00000097          	auipc	ra,0x0
    80001eaa:	94c080e7          	jalr	-1716(ra) # 800017f2 <killed>
    80001eae:	c901                	beqz	a0,80001ebe <usertrap+0x1ea>
    80001eb0:	a011                	j	80001eb4 <usertrap+0x1e0>
    80001eb2:	4481                	li	s1,0
        exit(-1);
    80001eb4:	557d                	li	a0,-1
    80001eb6:	fffff097          	auipc	ra,0xfffff
    80001eba:	7c8080e7          	jalr	1992(ra) # 8000167e <exit>
    if (which_dev == 2)
    80001ebe:	4789                	li	a5,2
    80001ec0:	eef49ee3          	bne	s1,a5,80001dbc <usertrap+0xe8>
        yield();
    80001ec4:	fffff097          	auipc	ra,0xfffff
    80001ec8:	64a080e7          	jalr	1610(ra) # 8000150e <yield>
    80001ecc:	bdc5                	j	80001dbc <usertrap+0xe8>

0000000080001ece <kerneltrap>:
{
    80001ece:	7179                	addi	sp,sp,-48
    80001ed0:	f406                	sd	ra,40(sp)
    80001ed2:	f022                	sd	s0,32(sp)
    80001ed4:	ec26                	sd	s1,24(sp)
    80001ed6:	e84a                	sd	s2,16(sp)
    80001ed8:	e44e                	sd	s3,8(sp)
    80001eda:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001edc:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ee0:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001ee4:	142029f3          	csrr	s3,scause
    if ((sstatus & SSTATUS_SPP) == 0)
    80001ee8:	1004f793          	andi	a5,s1,256
    80001eec:	cb85                	beqz	a5,80001f1c <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001eee:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001ef2:	8b89                	andi	a5,a5,2
    if (intr_get() != 0)
    80001ef4:	ef85                	bnez	a5,80001f2c <kerneltrap+0x5e>
    if ((which_dev = devintr()) == 0)
    80001ef6:	00000097          	auipc	ra,0x0
    80001efa:	d3c080e7          	jalr	-708(ra) # 80001c32 <devintr>
    80001efe:	cd1d                	beqz	a0,80001f3c <kerneltrap+0x6e>
    if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001f00:	4789                	li	a5,2
    80001f02:	06f50a63          	beq	a0,a5,80001f76 <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001f06:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001f0a:	10049073          	csrw	sstatus,s1
}
    80001f0e:	70a2                	ld	ra,40(sp)
    80001f10:	7402                	ld	s0,32(sp)
    80001f12:	64e2                	ld	s1,24(sp)
    80001f14:	6942                	ld	s2,16(sp)
    80001f16:	69a2                	ld	s3,8(sp)
    80001f18:	6145                	addi	sp,sp,48
    80001f1a:	8082                	ret
        panic("kerneltrap: not from supervisor mode");
    80001f1c:	00006517          	auipc	a0,0x6
    80001f20:	3e450513          	addi	a0,a0,996 # 80008300 <states.1744+0xf0>
    80001f24:	00004097          	auipc	ra,0x4
    80001f28:	08e080e7          	jalr	142(ra) # 80005fb2 <panic>
        panic("kerneltrap: interrupts enabled");
    80001f2c:	00006517          	auipc	a0,0x6
    80001f30:	3fc50513          	addi	a0,a0,1020 # 80008328 <states.1744+0x118>
    80001f34:	00004097          	auipc	ra,0x4
    80001f38:	07e080e7          	jalr	126(ra) # 80005fb2 <panic>
        printf("scause %p\n", scause);
    80001f3c:	85ce                	mv	a1,s3
    80001f3e:	00006517          	auipc	a0,0x6
    80001f42:	40a50513          	addi	a0,a0,1034 # 80008348 <states.1744+0x138>
    80001f46:	00004097          	auipc	ra,0x4
    80001f4a:	0b6080e7          	jalr	182(ra) # 80005ffc <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f4e:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001f52:	14302673          	csrr	a2,stval
        printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001f56:	00006517          	auipc	a0,0x6
    80001f5a:	40250513          	addi	a0,a0,1026 # 80008358 <states.1744+0x148>
    80001f5e:	00004097          	auipc	ra,0x4
    80001f62:	09e080e7          	jalr	158(ra) # 80005ffc <printf>
        panic("kerneltrap");
    80001f66:	00006517          	auipc	a0,0x6
    80001f6a:	40a50513          	addi	a0,a0,1034 # 80008370 <states.1744+0x160>
    80001f6e:	00004097          	auipc	ra,0x4
    80001f72:	044080e7          	jalr	68(ra) # 80005fb2 <panic>
    if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001f76:	fffff097          	auipc	ra,0xfffff
    80001f7a:	ec8080e7          	jalr	-312(ra) # 80000e3e <myproc>
    80001f7e:	d541                	beqz	a0,80001f06 <kerneltrap+0x38>
    80001f80:	fffff097          	auipc	ra,0xfffff
    80001f84:	ebe080e7          	jalr	-322(ra) # 80000e3e <myproc>
    80001f88:	4d18                	lw	a4,24(a0)
    80001f8a:	4791                	li	a5,4
    80001f8c:	f6f71de3          	bne	a4,a5,80001f06 <kerneltrap+0x38>
        yield();
    80001f90:	fffff097          	auipc	ra,0xfffff
    80001f94:	57e080e7          	jalr	1406(ra) # 8000150e <yield>
    80001f98:	b7bd                	j	80001f06 <kerneltrap+0x38>

0000000080001f9a <argraw>:
    return strlen(buf);
}

static uint64
argraw(int n)
{
    80001f9a:	1101                	addi	sp,sp,-32
    80001f9c:	ec06                	sd	ra,24(sp)
    80001f9e:	e822                	sd	s0,16(sp)
    80001fa0:	e426                	sd	s1,8(sp)
    80001fa2:	1000                	addi	s0,sp,32
    80001fa4:	84aa                	mv	s1,a0
    struct proc *p = myproc();
    80001fa6:	fffff097          	auipc	ra,0xfffff
    80001faa:	e98080e7          	jalr	-360(ra) # 80000e3e <myproc>
    switch (n)
    80001fae:	4795                	li	a5,5
    80001fb0:	0497e163          	bltu	a5,s1,80001ff2 <argraw+0x58>
    80001fb4:	048a                	slli	s1,s1,0x2
    80001fb6:	00006717          	auipc	a4,0x6
    80001fba:	3f270713          	addi	a4,a4,1010 # 800083a8 <states.1744+0x198>
    80001fbe:	94ba                	add	s1,s1,a4
    80001fc0:	409c                	lw	a5,0(s1)
    80001fc2:	97ba                	add	a5,a5,a4
    80001fc4:	8782                	jr	a5
    {
    case 0:
        return p->trapframe->a0;
    80001fc6:	6d3c                	ld	a5,88(a0)
    80001fc8:	7ba8                	ld	a0,112(a5)
    case 5:
        return p->trapframe->a5;
    }
    panic("argraw");
    return -1;
}
    80001fca:	60e2                	ld	ra,24(sp)
    80001fcc:	6442                	ld	s0,16(sp)
    80001fce:	64a2                	ld	s1,8(sp)
    80001fd0:	6105                	addi	sp,sp,32
    80001fd2:	8082                	ret
        return p->trapframe->a1;
    80001fd4:	6d3c                	ld	a5,88(a0)
    80001fd6:	7fa8                	ld	a0,120(a5)
    80001fd8:	bfcd                	j	80001fca <argraw+0x30>
        return p->trapframe->a2;
    80001fda:	6d3c                	ld	a5,88(a0)
    80001fdc:	63c8                	ld	a0,128(a5)
    80001fde:	b7f5                	j	80001fca <argraw+0x30>
        return p->trapframe->a3;
    80001fe0:	6d3c                	ld	a5,88(a0)
    80001fe2:	67c8                	ld	a0,136(a5)
    80001fe4:	b7dd                	j	80001fca <argraw+0x30>
        return p->trapframe->a4;
    80001fe6:	6d3c                	ld	a5,88(a0)
    80001fe8:	6bc8                	ld	a0,144(a5)
    80001fea:	b7c5                	j	80001fca <argraw+0x30>
        return p->trapframe->a5;
    80001fec:	6d3c                	ld	a5,88(a0)
    80001fee:	6fc8                	ld	a0,152(a5)
    80001ff0:	bfe9                	j	80001fca <argraw+0x30>
    panic("argraw");
    80001ff2:	00006517          	auipc	a0,0x6
    80001ff6:	38e50513          	addi	a0,a0,910 # 80008380 <states.1744+0x170>
    80001ffa:	00004097          	auipc	ra,0x4
    80001ffe:	fb8080e7          	jalr	-72(ra) # 80005fb2 <panic>

0000000080002002 <fetchaddr>:
{
    80002002:	1101                	addi	sp,sp,-32
    80002004:	ec06                	sd	ra,24(sp)
    80002006:	e822                	sd	s0,16(sp)
    80002008:	e426                	sd	s1,8(sp)
    8000200a:	e04a                	sd	s2,0(sp)
    8000200c:	1000                	addi	s0,sp,32
    8000200e:	84aa                	mv	s1,a0
    80002010:	892e                	mv	s2,a1
    struct proc *p = myproc();
    80002012:	fffff097          	auipc	ra,0xfffff
    80002016:	e2c080e7          	jalr	-468(ra) # 80000e3e <myproc>
    if (addr >= p->sz || addr + sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    8000201a:	653c                	ld	a5,72(a0)
    8000201c:	02f4f863          	bgeu	s1,a5,8000204c <fetchaddr+0x4a>
    80002020:	00848713          	addi	a4,s1,8
    80002024:	02e7e663          	bltu	a5,a4,80002050 <fetchaddr+0x4e>
    if (copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002028:	46a1                	li	a3,8
    8000202a:	8626                	mv	a2,s1
    8000202c:	85ca                	mv	a1,s2
    8000202e:	6928                	ld	a0,80(a0)
    80002030:	fffff097          	auipc	ra,0xfffff
    80002034:	b58080e7          	jalr	-1192(ra) # 80000b88 <copyin>
    80002038:	00a03533          	snez	a0,a0
    8000203c:	40a00533          	neg	a0,a0
}
    80002040:	60e2                	ld	ra,24(sp)
    80002042:	6442                	ld	s0,16(sp)
    80002044:	64a2                	ld	s1,8(sp)
    80002046:	6902                	ld	s2,0(sp)
    80002048:	6105                	addi	sp,sp,32
    8000204a:	8082                	ret
        return -1;
    8000204c:	557d                	li	a0,-1
    8000204e:	bfcd                	j	80002040 <fetchaddr+0x3e>
    80002050:	557d                	li	a0,-1
    80002052:	b7fd                	j	80002040 <fetchaddr+0x3e>

0000000080002054 <fetchstr>:
{
    80002054:	7179                	addi	sp,sp,-48
    80002056:	f406                	sd	ra,40(sp)
    80002058:	f022                	sd	s0,32(sp)
    8000205a:	ec26                	sd	s1,24(sp)
    8000205c:	e84a                	sd	s2,16(sp)
    8000205e:	e44e                	sd	s3,8(sp)
    80002060:	1800                	addi	s0,sp,48
    80002062:	892a                	mv	s2,a0
    80002064:	84ae                	mv	s1,a1
    80002066:	89b2                	mv	s3,a2
    struct proc *p = myproc();
    80002068:	fffff097          	auipc	ra,0xfffff
    8000206c:	dd6080e7          	jalr	-554(ra) # 80000e3e <myproc>
    if (copyinstr(p->pagetable, buf, addr, max) < 0)
    80002070:	86ce                	mv	a3,s3
    80002072:	864a                	mv	a2,s2
    80002074:	85a6                	mv	a1,s1
    80002076:	6928                	ld	a0,80(a0)
    80002078:	fffff097          	auipc	ra,0xfffff
    8000207c:	b9c080e7          	jalr	-1124(ra) # 80000c14 <copyinstr>
    80002080:	00054e63          	bltz	a0,8000209c <fetchstr+0x48>
    return strlen(buf);
    80002084:	8526                	mv	a0,s1
    80002086:	ffffe097          	auipc	ra,0xffffe
    8000208a:	276080e7          	jalr	630(ra) # 800002fc <strlen>
}
    8000208e:	70a2                	ld	ra,40(sp)
    80002090:	7402                	ld	s0,32(sp)
    80002092:	64e2                	ld	s1,24(sp)
    80002094:	6942                	ld	s2,16(sp)
    80002096:	69a2                	ld	s3,8(sp)
    80002098:	6145                	addi	sp,sp,48
    8000209a:	8082                	ret
        return -1;
    8000209c:	557d                	li	a0,-1
    8000209e:	bfc5                	j	8000208e <fetchstr+0x3a>

00000000800020a0 <argint>:

// Fetch the nth 32-bit system call argument.
void argint(int n, int *ip)
{
    800020a0:	1101                	addi	sp,sp,-32
    800020a2:	ec06                	sd	ra,24(sp)
    800020a4:	e822                	sd	s0,16(sp)
    800020a6:	e426                	sd	s1,8(sp)
    800020a8:	1000                	addi	s0,sp,32
    800020aa:	84ae                	mv	s1,a1
    *ip = argraw(n);
    800020ac:	00000097          	auipc	ra,0x0
    800020b0:	eee080e7          	jalr	-274(ra) # 80001f9a <argraw>
    800020b4:	c088                	sw	a0,0(s1)
}
    800020b6:	60e2                	ld	ra,24(sp)
    800020b8:	6442                	ld	s0,16(sp)
    800020ba:	64a2                	ld	s1,8(sp)
    800020bc:	6105                	addi	sp,sp,32
    800020be:	8082                	ret

00000000800020c0 <argaddr>:

// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void argaddr(int n, uint64 *ip)
{
    800020c0:	1101                	addi	sp,sp,-32
    800020c2:	ec06                	sd	ra,24(sp)
    800020c4:	e822                	sd	s0,16(sp)
    800020c6:	e426                	sd	s1,8(sp)
    800020c8:	1000                	addi	s0,sp,32
    800020ca:	84ae                	mv	s1,a1
    *ip = argraw(n);
    800020cc:	00000097          	auipc	ra,0x0
    800020d0:	ece080e7          	jalr	-306(ra) # 80001f9a <argraw>
    800020d4:	e088                	sd	a0,0(s1)
}
    800020d6:	60e2                	ld	ra,24(sp)
    800020d8:	6442                	ld	s0,16(sp)
    800020da:	64a2                	ld	s1,8(sp)
    800020dc:	6105                	addi	sp,sp,32
    800020de:	8082                	ret

00000000800020e0 <argstr>:

// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int argstr(int n, char *buf, int max)
{
    800020e0:	7179                	addi	sp,sp,-48
    800020e2:	f406                	sd	ra,40(sp)
    800020e4:	f022                	sd	s0,32(sp)
    800020e6:	ec26                	sd	s1,24(sp)
    800020e8:	e84a                	sd	s2,16(sp)
    800020ea:	1800                	addi	s0,sp,48
    800020ec:	84ae                	mv	s1,a1
    800020ee:	8932                	mv	s2,a2
    uint64 addr;
    argaddr(n, &addr);
    800020f0:	fd840593          	addi	a1,s0,-40
    800020f4:	00000097          	auipc	ra,0x0
    800020f8:	fcc080e7          	jalr	-52(ra) # 800020c0 <argaddr>
    return fetchstr(addr, buf, max);
    800020fc:	864a                	mv	a2,s2
    800020fe:	85a6                	mv	a1,s1
    80002100:	fd843503          	ld	a0,-40(s0)
    80002104:	00000097          	auipc	ra,0x0
    80002108:	f50080e7          	jalr	-176(ra) # 80002054 <fetchstr>
}
    8000210c:	70a2                	ld	ra,40(sp)
    8000210e:	7402                	ld	s0,32(sp)
    80002110:	64e2                	ld	s1,24(sp)
    80002112:	6942                	ld	s2,16(sp)
    80002114:	6145                	addi	sp,sp,48
    80002116:	8082                	ret

0000000080002118 <syscall>:
    [SYS_mmap] sys_mmap,
    [SYS_munmap] sys_munmap,
};

void syscall(void)
{
    80002118:	1101                	addi	sp,sp,-32
    8000211a:	ec06                	sd	ra,24(sp)
    8000211c:	e822                	sd	s0,16(sp)
    8000211e:	e426                	sd	s1,8(sp)
    80002120:	e04a                	sd	s2,0(sp)
    80002122:	1000                	addi	s0,sp,32
    int num;
    struct proc *p = myproc();
    80002124:	fffff097          	auipc	ra,0xfffff
    80002128:	d1a080e7          	jalr	-742(ra) # 80000e3e <myproc>
    8000212c:	84aa                	mv	s1,a0

    num = p->trapframe->a7;
    8000212e:	05853903          	ld	s2,88(a0)
    80002132:	0a893783          	ld	a5,168(s2)
    80002136:	0007869b          	sext.w	a3,a5
    if (num > 0 && num < NELEM(syscalls) && syscalls[num])
    8000213a:	37fd                	addiw	a5,a5,-1
    8000213c:	4759                	li	a4,22
    8000213e:	00f76f63          	bltu	a4,a5,8000215c <syscall+0x44>
    80002142:	00369713          	slli	a4,a3,0x3
    80002146:	00006797          	auipc	a5,0x6
    8000214a:	27a78793          	addi	a5,a5,634 # 800083c0 <syscalls>
    8000214e:	97ba                	add	a5,a5,a4
    80002150:	639c                	ld	a5,0(a5)
    80002152:	c789                	beqz	a5,8000215c <syscall+0x44>
    {
        // Use num to lookup the system call function for num, call it,
        // and store its return value in p->trapframe->a0
        p->trapframe->a0 = syscalls[num]();
    80002154:	9782                	jalr	a5
    80002156:	06a93823          	sd	a0,112(s2)
    8000215a:	a839                	j	80002178 <syscall+0x60>
    }
    else
    {
        printf("%d %s: unknown sys call %d\n",
    8000215c:	15848613          	addi	a2,s1,344
    80002160:	588c                	lw	a1,48(s1)
    80002162:	00006517          	auipc	a0,0x6
    80002166:	22650513          	addi	a0,a0,550 # 80008388 <states.1744+0x178>
    8000216a:	00004097          	auipc	ra,0x4
    8000216e:	e92080e7          	jalr	-366(ra) # 80005ffc <printf>
               p->pid, p->name, num);
        p->trapframe->a0 = -1;
    80002172:	6cbc                	ld	a5,88(s1)
    80002174:	577d                	li	a4,-1
    80002176:	fbb8                	sd	a4,112(a5)
    }
}
    80002178:	60e2                	ld	ra,24(sp)
    8000217a:	6442                	ld	s0,16(sp)
    8000217c:	64a2                	ld	s1,8(sp)
    8000217e:	6902                	ld	s2,0(sp)
    80002180:	6105                	addi	sp,sp,32
    80002182:	8082                	ret

0000000080002184 <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    80002184:	1101                	addi	sp,sp,-32
    80002186:	ec06                	sd	ra,24(sp)
    80002188:	e822                	sd	s0,16(sp)
    8000218a:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    8000218c:	fec40593          	addi	a1,s0,-20
    80002190:	4501                	li	a0,0
    80002192:	00000097          	auipc	ra,0x0
    80002196:	f0e080e7          	jalr	-242(ra) # 800020a0 <argint>
  exit(n);
    8000219a:	fec42503          	lw	a0,-20(s0)
    8000219e:	fffff097          	auipc	ra,0xfffff
    800021a2:	4e0080e7          	jalr	1248(ra) # 8000167e <exit>
  return 0;  // not reached
}
    800021a6:	4501                	li	a0,0
    800021a8:	60e2                	ld	ra,24(sp)
    800021aa:	6442                	ld	s0,16(sp)
    800021ac:	6105                	addi	sp,sp,32
    800021ae:	8082                	ret

00000000800021b0 <sys_getpid>:

uint64
sys_getpid(void)
{
    800021b0:	1141                	addi	sp,sp,-16
    800021b2:	e406                	sd	ra,8(sp)
    800021b4:	e022                	sd	s0,0(sp)
    800021b6:	0800                	addi	s0,sp,16
  return myproc()->pid;
    800021b8:	fffff097          	auipc	ra,0xfffff
    800021bc:	c86080e7          	jalr	-890(ra) # 80000e3e <myproc>
}
    800021c0:	5908                	lw	a0,48(a0)
    800021c2:	60a2                	ld	ra,8(sp)
    800021c4:	6402                	ld	s0,0(sp)
    800021c6:	0141                	addi	sp,sp,16
    800021c8:	8082                	ret

00000000800021ca <sys_fork>:

uint64
sys_fork(void)
{
    800021ca:	1141                	addi	sp,sp,-16
    800021cc:	e406                	sd	ra,8(sp)
    800021ce:	e022                	sd	s0,0(sp)
    800021d0:	0800                	addi	s0,sp,16
  return fork();
    800021d2:	fffff097          	auipc	ra,0xfffff
    800021d6:	022080e7          	jalr	34(ra) # 800011f4 <fork>
}
    800021da:	60a2                	ld	ra,8(sp)
    800021dc:	6402                	ld	s0,0(sp)
    800021de:	0141                	addi	sp,sp,16
    800021e0:	8082                	ret

00000000800021e2 <sys_wait>:

uint64
sys_wait(void)
{
    800021e2:	1101                	addi	sp,sp,-32
    800021e4:	ec06                	sd	ra,24(sp)
    800021e6:	e822                	sd	s0,16(sp)
    800021e8:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    800021ea:	fe840593          	addi	a1,s0,-24
    800021ee:	4501                	li	a0,0
    800021f0:	00000097          	auipc	ra,0x0
    800021f4:	ed0080e7          	jalr	-304(ra) # 800020c0 <argaddr>
  return wait(p);
    800021f8:	fe843503          	ld	a0,-24(s0)
    800021fc:	fffff097          	auipc	ra,0xfffff
    80002200:	628080e7          	jalr	1576(ra) # 80001824 <wait>
}
    80002204:	60e2                	ld	ra,24(sp)
    80002206:	6442                	ld	s0,16(sp)
    80002208:	6105                	addi	sp,sp,32
    8000220a:	8082                	ret

000000008000220c <sys_sbrk>:

uint64
sys_sbrk(void)
{
    8000220c:	7179                	addi	sp,sp,-48
    8000220e:	f406                	sd	ra,40(sp)
    80002210:	f022                	sd	s0,32(sp)
    80002212:	ec26                	sd	s1,24(sp)
    80002214:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    80002216:	fdc40593          	addi	a1,s0,-36
    8000221a:	4501                	li	a0,0
    8000221c:	00000097          	auipc	ra,0x0
    80002220:	e84080e7          	jalr	-380(ra) # 800020a0 <argint>
  addr = myproc()->sz;
    80002224:	fffff097          	auipc	ra,0xfffff
    80002228:	c1a080e7          	jalr	-998(ra) # 80000e3e <myproc>
    8000222c:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    8000222e:	fdc42503          	lw	a0,-36(s0)
    80002232:	fffff097          	auipc	ra,0xfffff
    80002236:	f66080e7          	jalr	-154(ra) # 80001198 <growproc>
    8000223a:	00054863          	bltz	a0,8000224a <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    8000223e:	8526                	mv	a0,s1
    80002240:	70a2                	ld	ra,40(sp)
    80002242:	7402                	ld	s0,32(sp)
    80002244:	64e2                	ld	s1,24(sp)
    80002246:	6145                	addi	sp,sp,48
    80002248:	8082                	ret
    return -1;
    8000224a:	54fd                	li	s1,-1
    8000224c:	bfcd                	j	8000223e <sys_sbrk+0x32>

000000008000224e <sys_sleep>:

uint64
sys_sleep(void)
{
    8000224e:	7139                	addi	sp,sp,-64
    80002250:	fc06                	sd	ra,56(sp)
    80002252:	f822                	sd	s0,48(sp)
    80002254:	f426                	sd	s1,40(sp)
    80002256:	f04a                	sd	s2,32(sp)
    80002258:	ec4e                	sd	s3,24(sp)
    8000225a:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    8000225c:	fcc40593          	addi	a1,s0,-52
    80002260:	4501                	li	a0,0
    80002262:	00000097          	auipc	ra,0x0
    80002266:	e3e080e7          	jalr	-450(ra) # 800020a0 <argint>
  if(n < 0)
    8000226a:	fcc42783          	lw	a5,-52(s0)
    8000226e:	0607cf63          	bltz	a5,800022ec <sys_sleep+0x9e>
    n = 0;
  acquire(&tickslock);
    80002272:	0001e517          	auipc	a0,0x1e
    80002276:	4de50513          	addi	a0,a0,1246 # 80020750 <tickslock>
    8000227a:	00004097          	auipc	ra,0x4
    8000227e:	282080e7          	jalr	642(ra) # 800064fc <acquire>
  ticks0 = ticks;
    80002282:	00006917          	auipc	s2,0x6
    80002286:	66692903          	lw	s2,1638(s2) # 800088e8 <ticks>
  while(ticks - ticks0 < n){
    8000228a:	fcc42783          	lw	a5,-52(s0)
    8000228e:	cf9d                	beqz	a5,800022cc <sys_sleep+0x7e>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    80002290:	0001e997          	auipc	s3,0x1e
    80002294:	4c098993          	addi	s3,s3,1216 # 80020750 <tickslock>
    80002298:	00006497          	auipc	s1,0x6
    8000229c:	65048493          	addi	s1,s1,1616 # 800088e8 <ticks>
    if(killed(myproc())){
    800022a0:	fffff097          	auipc	ra,0xfffff
    800022a4:	b9e080e7          	jalr	-1122(ra) # 80000e3e <myproc>
    800022a8:	fffff097          	auipc	ra,0xfffff
    800022ac:	54a080e7          	jalr	1354(ra) # 800017f2 <killed>
    800022b0:	e129                	bnez	a0,800022f2 <sys_sleep+0xa4>
    sleep(&ticks, &tickslock);
    800022b2:	85ce                	mv	a1,s3
    800022b4:	8526                	mv	a0,s1
    800022b6:	fffff097          	auipc	ra,0xfffff
    800022ba:	294080e7          	jalr	660(ra) # 8000154a <sleep>
  while(ticks - ticks0 < n){
    800022be:	409c                	lw	a5,0(s1)
    800022c0:	412787bb          	subw	a5,a5,s2
    800022c4:	fcc42703          	lw	a4,-52(s0)
    800022c8:	fce7ece3          	bltu	a5,a4,800022a0 <sys_sleep+0x52>
  }
  release(&tickslock);
    800022cc:	0001e517          	auipc	a0,0x1e
    800022d0:	48450513          	addi	a0,a0,1156 # 80020750 <tickslock>
    800022d4:	00004097          	auipc	ra,0x4
    800022d8:	2dc080e7          	jalr	732(ra) # 800065b0 <release>
  return 0;
    800022dc:	4501                	li	a0,0
}
    800022de:	70e2                	ld	ra,56(sp)
    800022e0:	7442                	ld	s0,48(sp)
    800022e2:	74a2                	ld	s1,40(sp)
    800022e4:	7902                	ld	s2,32(sp)
    800022e6:	69e2                	ld	s3,24(sp)
    800022e8:	6121                	addi	sp,sp,64
    800022ea:	8082                	ret
    n = 0;
    800022ec:	fc042623          	sw	zero,-52(s0)
    800022f0:	b749                	j	80002272 <sys_sleep+0x24>
      release(&tickslock);
    800022f2:	0001e517          	auipc	a0,0x1e
    800022f6:	45e50513          	addi	a0,a0,1118 # 80020750 <tickslock>
    800022fa:	00004097          	auipc	ra,0x4
    800022fe:	2b6080e7          	jalr	694(ra) # 800065b0 <release>
      return -1;
    80002302:	557d                	li	a0,-1
    80002304:	bfe9                	j	800022de <sys_sleep+0x90>

0000000080002306 <sys_kill>:

uint64
sys_kill(void)
{
    80002306:	1101                	addi	sp,sp,-32
    80002308:	ec06                	sd	ra,24(sp)
    8000230a:	e822                	sd	s0,16(sp)
    8000230c:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    8000230e:	fec40593          	addi	a1,s0,-20
    80002312:	4501                	li	a0,0
    80002314:	00000097          	auipc	ra,0x0
    80002318:	d8c080e7          	jalr	-628(ra) # 800020a0 <argint>
  return kill(pid);
    8000231c:	fec42503          	lw	a0,-20(s0)
    80002320:	fffff097          	auipc	ra,0xfffff
    80002324:	434080e7          	jalr	1076(ra) # 80001754 <kill>
}
    80002328:	60e2                	ld	ra,24(sp)
    8000232a:	6442                	ld	s0,16(sp)
    8000232c:	6105                	addi	sp,sp,32
    8000232e:	8082                	ret

0000000080002330 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002330:	1101                	addi	sp,sp,-32
    80002332:	ec06                	sd	ra,24(sp)
    80002334:	e822                	sd	s0,16(sp)
    80002336:	e426                	sd	s1,8(sp)
    80002338:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    8000233a:	0001e517          	auipc	a0,0x1e
    8000233e:	41650513          	addi	a0,a0,1046 # 80020750 <tickslock>
    80002342:	00004097          	auipc	ra,0x4
    80002346:	1ba080e7          	jalr	442(ra) # 800064fc <acquire>
  xticks = ticks;
    8000234a:	00006497          	auipc	s1,0x6
    8000234e:	59e4a483          	lw	s1,1438(s1) # 800088e8 <ticks>
  release(&tickslock);
    80002352:	0001e517          	auipc	a0,0x1e
    80002356:	3fe50513          	addi	a0,a0,1022 # 80020750 <tickslock>
    8000235a:	00004097          	auipc	ra,0x4
    8000235e:	256080e7          	jalr	598(ra) # 800065b0 <release>
  return xticks;
}
    80002362:	02049513          	slli	a0,s1,0x20
    80002366:	9101                	srli	a0,a0,0x20
    80002368:	60e2                	ld	ra,24(sp)
    8000236a:	6442                	ld	s0,16(sp)
    8000236c:	64a2                	ld	s1,8(sp)
    8000236e:	6105                	addi	sp,sp,32
    80002370:	8082                	ret

0000000080002372 <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    80002372:	7179                	addi	sp,sp,-48
    80002374:	f406                	sd	ra,40(sp)
    80002376:	f022                	sd	s0,32(sp)
    80002378:	ec26                	sd	s1,24(sp)
    8000237a:	e84a                	sd	s2,16(sp)
    8000237c:	e44e                	sd	s3,8(sp)
    8000237e:	e052                	sd	s4,0(sp)
    80002380:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    80002382:	00006597          	auipc	a1,0x6
    80002386:	0fe58593          	addi	a1,a1,254 # 80008480 <syscalls+0xc0>
    8000238a:	0001e517          	auipc	a0,0x1e
    8000238e:	3de50513          	addi	a0,a0,990 # 80020768 <bcache>
    80002392:	00004097          	auipc	ra,0x4
    80002396:	0da080e7          	jalr	218(ra) # 8000646c <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    8000239a:	00026797          	auipc	a5,0x26
    8000239e:	3ce78793          	addi	a5,a5,974 # 80028768 <bcache+0x8000>
    800023a2:	00026717          	auipc	a4,0x26
    800023a6:	62e70713          	addi	a4,a4,1582 # 800289d0 <bcache+0x8268>
    800023aa:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    800023ae:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800023b2:	0001e497          	auipc	s1,0x1e
    800023b6:	3ce48493          	addi	s1,s1,974 # 80020780 <bcache+0x18>
    b->next = bcache.head.next;
    800023ba:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    800023bc:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    800023be:	00006a17          	auipc	s4,0x6
    800023c2:	0caa0a13          	addi	s4,s4,202 # 80008488 <syscalls+0xc8>
    b->next = bcache.head.next;
    800023c6:	2b893783          	ld	a5,696(s2)
    800023ca:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    800023cc:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    800023d0:	85d2                	mv	a1,s4
    800023d2:	01048513          	addi	a0,s1,16
    800023d6:	00001097          	auipc	ra,0x1
    800023da:	4c4080e7          	jalr	1220(ra) # 8000389a <initsleeplock>
    bcache.head.next->prev = b;
    800023de:	2b893783          	ld	a5,696(s2)
    800023e2:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    800023e4:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    800023e8:	45848493          	addi	s1,s1,1112
    800023ec:	fd349de3          	bne	s1,s3,800023c6 <binit+0x54>
  }
}
    800023f0:	70a2                	ld	ra,40(sp)
    800023f2:	7402                	ld	s0,32(sp)
    800023f4:	64e2                	ld	s1,24(sp)
    800023f6:	6942                	ld	s2,16(sp)
    800023f8:	69a2                	ld	s3,8(sp)
    800023fa:	6a02                	ld	s4,0(sp)
    800023fc:	6145                	addi	sp,sp,48
    800023fe:	8082                	ret

0000000080002400 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002400:	7179                	addi	sp,sp,-48
    80002402:	f406                	sd	ra,40(sp)
    80002404:	f022                	sd	s0,32(sp)
    80002406:	ec26                	sd	s1,24(sp)
    80002408:	e84a                	sd	s2,16(sp)
    8000240a:	e44e                	sd	s3,8(sp)
    8000240c:	1800                	addi	s0,sp,48
    8000240e:	89aa                	mv	s3,a0
    80002410:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    80002412:	0001e517          	auipc	a0,0x1e
    80002416:	35650513          	addi	a0,a0,854 # 80020768 <bcache>
    8000241a:	00004097          	auipc	ra,0x4
    8000241e:	0e2080e7          	jalr	226(ra) # 800064fc <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    80002422:	00026497          	auipc	s1,0x26
    80002426:	5fe4b483          	ld	s1,1534(s1) # 80028a20 <bcache+0x82b8>
    8000242a:	00026797          	auipc	a5,0x26
    8000242e:	5a678793          	addi	a5,a5,1446 # 800289d0 <bcache+0x8268>
    80002432:	02f48f63          	beq	s1,a5,80002470 <bread+0x70>
    80002436:	873e                	mv	a4,a5
    80002438:	a021                	j	80002440 <bread+0x40>
    8000243a:	68a4                	ld	s1,80(s1)
    8000243c:	02e48a63          	beq	s1,a4,80002470 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002440:	449c                	lw	a5,8(s1)
    80002442:	ff379ce3          	bne	a5,s3,8000243a <bread+0x3a>
    80002446:	44dc                	lw	a5,12(s1)
    80002448:	ff2799e3          	bne	a5,s2,8000243a <bread+0x3a>
      b->refcnt++;
    8000244c:	40bc                	lw	a5,64(s1)
    8000244e:	2785                	addiw	a5,a5,1
    80002450:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002452:	0001e517          	auipc	a0,0x1e
    80002456:	31650513          	addi	a0,a0,790 # 80020768 <bcache>
    8000245a:	00004097          	auipc	ra,0x4
    8000245e:	156080e7          	jalr	342(ra) # 800065b0 <release>
      acquiresleep(&b->lock);
    80002462:	01048513          	addi	a0,s1,16
    80002466:	00001097          	auipc	ra,0x1
    8000246a:	46e080e7          	jalr	1134(ra) # 800038d4 <acquiresleep>
      return b;
    8000246e:	a8b9                	j	800024cc <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    80002470:	00026497          	auipc	s1,0x26
    80002474:	5a84b483          	ld	s1,1448(s1) # 80028a18 <bcache+0x82b0>
    80002478:	00026797          	auipc	a5,0x26
    8000247c:	55878793          	addi	a5,a5,1368 # 800289d0 <bcache+0x8268>
    80002480:	00f48863          	beq	s1,a5,80002490 <bread+0x90>
    80002484:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    80002486:	40bc                	lw	a5,64(s1)
    80002488:	cf81                	beqz	a5,800024a0 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    8000248a:	64a4                	ld	s1,72(s1)
    8000248c:	fee49de3          	bne	s1,a4,80002486 <bread+0x86>
  panic("bget: no buffers");
    80002490:	00006517          	auipc	a0,0x6
    80002494:	00050513          	mv	a0,a0
    80002498:	00004097          	auipc	ra,0x4
    8000249c:	b1a080e7          	jalr	-1254(ra) # 80005fb2 <panic>
      b->dev = dev;
    800024a0:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    800024a4:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    800024a8:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    800024ac:	4785                	li	a5,1
    800024ae:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800024b0:	0001e517          	auipc	a0,0x1e
    800024b4:	2b850513          	addi	a0,a0,696 # 80020768 <bcache>
    800024b8:	00004097          	auipc	ra,0x4
    800024bc:	0f8080e7          	jalr	248(ra) # 800065b0 <release>
      acquiresleep(&b->lock);
    800024c0:	01048513          	addi	a0,s1,16
    800024c4:	00001097          	auipc	ra,0x1
    800024c8:	410080e7          	jalr	1040(ra) # 800038d4 <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    800024cc:	409c                	lw	a5,0(s1)
    800024ce:	cb89                	beqz	a5,800024e0 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    800024d0:	8526                	mv	a0,s1
    800024d2:	70a2                	ld	ra,40(sp)
    800024d4:	7402                	ld	s0,32(sp)
    800024d6:	64e2                	ld	s1,24(sp)
    800024d8:	6942                	ld	s2,16(sp)
    800024da:	69a2                	ld	s3,8(sp)
    800024dc:	6145                	addi	sp,sp,48
    800024de:	8082                	ret
    virtio_disk_rw(b, 0);
    800024e0:	4581                	li	a1,0
    800024e2:	8526                	mv	a0,s1
    800024e4:	00003097          	auipc	ra,0x3
    800024e8:	264080e7          	jalr	612(ra) # 80005748 <virtio_disk_rw>
    b->valid = 1;
    800024ec:	4785                	li	a5,1
    800024ee:	c09c                	sw	a5,0(s1)
  return b;
    800024f0:	b7c5                	j	800024d0 <bread+0xd0>

00000000800024f2 <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    800024f2:	1101                	addi	sp,sp,-32
    800024f4:	ec06                	sd	ra,24(sp)
    800024f6:	e822                	sd	s0,16(sp)
    800024f8:	e426                	sd	s1,8(sp)
    800024fa:	1000                	addi	s0,sp,32
    800024fc:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    800024fe:	0541                	addi	a0,a0,16
    80002500:	00001097          	auipc	ra,0x1
    80002504:	46e080e7          	jalr	1134(ra) # 8000396e <holdingsleep>
    80002508:	cd01                	beqz	a0,80002520 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    8000250a:	4585                	li	a1,1
    8000250c:	8526                	mv	a0,s1
    8000250e:	00003097          	auipc	ra,0x3
    80002512:	23a080e7          	jalr	570(ra) # 80005748 <virtio_disk_rw>
}
    80002516:	60e2                	ld	ra,24(sp)
    80002518:	6442                	ld	s0,16(sp)
    8000251a:	64a2                	ld	s1,8(sp)
    8000251c:	6105                	addi	sp,sp,32
    8000251e:	8082                	ret
    panic("bwrite");
    80002520:	00006517          	auipc	a0,0x6
    80002524:	f8850513          	addi	a0,a0,-120 # 800084a8 <syscalls+0xe8>
    80002528:	00004097          	auipc	ra,0x4
    8000252c:	a8a080e7          	jalr	-1398(ra) # 80005fb2 <panic>

0000000080002530 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002530:	1101                	addi	sp,sp,-32
    80002532:	ec06                	sd	ra,24(sp)
    80002534:	e822                	sd	s0,16(sp)
    80002536:	e426                	sd	s1,8(sp)
    80002538:	e04a                	sd	s2,0(sp)
    8000253a:	1000                	addi	s0,sp,32
    8000253c:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    8000253e:	01050913          	addi	s2,a0,16
    80002542:	854a                	mv	a0,s2
    80002544:	00001097          	auipc	ra,0x1
    80002548:	42a080e7          	jalr	1066(ra) # 8000396e <holdingsleep>
    8000254c:	c92d                	beqz	a0,800025be <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    8000254e:	854a                	mv	a0,s2
    80002550:	00001097          	auipc	ra,0x1
    80002554:	3da080e7          	jalr	986(ra) # 8000392a <releasesleep>

  acquire(&bcache.lock);
    80002558:	0001e517          	auipc	a0,0x1e
    8000255c:	21050513          	addi	a0,a0,528 # 80020768 <bcache>
    80002560:	00004097          	auipc	ra,0x4
    80002564:	f9c080e7          	jalr	-100(ra) # 800064fc <acquire>
  b->refcnt--;
    80002568:	40bc                	lw	a5,64(s1)
    8000256a:	37fd                	addiw	a5,a5,-1
    8000256c:	0007871b          	sext.w	a4,a5
    80002570:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    80002572:	eb05                	bnez	a4,800025a2 <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    80002574:	68bc                	ld	a5,80(s1)
    80002576:	64b8                	ld	a4,72(s1)
    80002578:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    8000257a:	64bc                	ld	a5,72(s1)
    8000257c:	68b8                	ld	a4,80(s1)
    8000257e:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    80002580:	00026797          	auipc	a5,0x26
    80002584:	1e878793          	addi	a5,a5,488 # 80028768 <bcache+0x8000>
    80002588:	2b87b703          	ld	a4,696(a5)
    8000258c:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    8000258e:	00026717          	auipc	a4,0x26
    80002592:	44270713          	addi	a4,a4,1090 # 800289d0 <bcache+0x8268>
    80002596:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    80002598:	2b87b703          	ld	a4,696(a5)
    8000259c:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    8000259e:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800025a2:	0001e517          	auipc	a0,0x1e
    800025a6:	1c650513          	addi	a0,a0,454 # 80020768 <bcache>
    800025aa:	00004097          	auipc	ra,0x4
    800025ae:	006080e7          	jalr	6(ra) # 800065b0 <release>
}
    800025b2:	60e2                	ld	ra,24(sp)
    800025b4:	6442                	ld	s0,16(sp)
    800025b6:	64a2                	ld	s1,8(sp)
    800025b8:	6902                	ld	s2,0(sp)
    800025ba:	6105                	addi	sp,sp,32
    800025bc:	8082                	ret
    panic("brelse");
    800025be:	00006517          	auipc	a0,0x6
    800025c2:	ef250513          	addi	a0,a0,-270 # 800084b0 <syscalls+0xf0>
    800025c6:	00004097          	auipc	ra,0x4
    800025ca:	9ec080e7          	jalr	-1556(ra) # 80005fb2 <panic>

00000000800025ce <bpin>:

void
bpin(struct buf *b) {
    800025ce:	1101                	addi	sp,sp,-32
    800025d0:	ec06                	sd	ra,24(sp)
    800025d2:	e822                	sd	s0,16(sp)
    800025d4:	e426                	sd	s1,8(sp)
    800025d6:	1000                	addi	s0,sp,32
    800025d8:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    800025da:	0001e517          	auipc	a0,0x1e
    800025de:	18e50513          	addi	a0,a0,398 # 80020768 <bcache>
    800025e2:	00004097          	auipc	ra,0x4
    800025e6:	f1a080e7          	jalr	-230(ra) # 800064fc <acquire>
  b->refcnt++;
    800025ea:	40bc                	lw	a5,64(s1)
    800025ec:	2785                	addiw	a5,a5,1
    800025ee:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    800025f0:	0001e517          	auipc	a0,0x1e
    800025f4:	17850513          	addi	a0,a0,376 # 80020768 <bcache>
    800025f8:	00004097          	auipc	ra,0x4
    800025fc:	fb8080e7          	jalr	-72(ra) # 800065b0 <release>
}
    80002600:	60e2                	ld	ra,24(sp)
    80002602:	6442                	ld	s0,16(sp)
    80002604:	64a2                	ld	s1,8(sp)
    80002606:	6105                	addi	sp,sp,32
    80002608:	8082                	ret

000000008000260a <bunpin>:

void
bunpin(struct buf *b) {
    8000260a:	1101                	addi	sp,sp,-32
    8000260c:	ec06                	sd	ra,24(sp)
    8000260e:	e822                	sd	s0,16(sp)
    80002610:	e426                	sd	s1,8(sp)
    80002612:	1000                	addi	s0,sp,32
    80002614:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002616:	0001e517          	auipc	a0,0x1e
    8000261a:	15250513          	addi	a0,a0,338 # 80020768 <bcache>
    8000261e:	00004097          	auipc	ra,0x4
    80002622:	ede080e7          	jalr	-290(ra) # 800064fc <acquire>
  b->refcnt--;
    80002626:	40bc                	lw	a5,64(s1)
    80002628:	37fd                	addiw	a5,a5,-1
    8000262a:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    8000262c:	0001e517          	auipc	a0,0x1e
    80002630:	13c50513          	addi	a0,a0,316 # 80020768 <bcache>
    80002634:	00004097          	auipc	ra,0x4
    80002638:	f7c080e7          	jalr	-132(ra) # 800065b0 <release>
}
    8000263c:	60e2                	ld	ra,24(sp)
    8000263e:	6442                	ld	s0,16(sp)
    80002640:	64a2                	ld	s1,8(sp)
    80002642:	6105                	addi	sp,sp,32
    80002644:	8082                	ret

0000000080002646 <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    80002646:	1101                	addi	sp,sp,-32
    80002648:	ec06                	sd	ra,24(sp)
    8000264a:	e822                	sd	s0,16(sp)
    8000264c:	e426                	sd	s1,8(sp)
    8000264e:	e04a                	sd	s2,0(sp)
    80002650:	1000                	addi	s0,sp,32
    80002652:	84ae                	mv	s1,a1
    struct buf *bp;
    int bi, m;

    bp = bread(dev, BBLOCK(b, sb));
    80002654:	00d5d59b          	srliw	a1,a1,0xd
    80002658:	00026797          	auipc	a5,0x26
    8000265c:	7ec7a783          	lw	a5,2028(a5) # 80028e44 <sb+0x1c>
    80002660:	9dbd                	addw	a1,a1,a5
    80002662:	00000097          	auipc	ra,0x0
    80002666:	d9e080e7          	jalr	-610(ra) # 80002400 <bread>
    bi = b % BPB;
    m = 1 << (bi % 8);
    8000266a:	0074f713          	andi	a4,s1,7
    8000266e:	4785                	li	a5,1
    80002670:	00e797bb          	sllw	a5,a5,a4
    if ((bp->data[bi / 8] & m) == 0)
    80002674:	14ce                	slli	s1,s1,0x33
    80002676:	90d9                	srli	s1,s1,0x36
    80002678:	00950733          	add	a4,a0,s1
    8000267c:	05874703          	lbu	a4,88(a4)
    80002680:	00e7f6b3          	and	a3,a5,a4
    80002684:	c69d                	beqz	a3,800026b2 <bfree+0x6c>
    80002686:	892a                	mv	s2,a0
        panic("freeing free block");
    bp->data[bi / 8] &= ~m;
    80002688:	94aa                	add	s1,s1,a0
    8000268a:	fff7c793          	not	a5,a5
    8000268e:	8ff9                	and	a5,a5,a4
    80002690:	04f48c23          	sb	a5,88(s1)
    log_write(bp);
    80002694:	00001097          	auipc	ra,0x1
    80002698:	120080e7          	jalr	288(ra) # 800037b4 <log_write>
    brelse(bp);
    8000269c:	854a                	mv	a0,s2
    8000269e:	00000097          	auipc	ra,0x0
    800026a2:	e92080e7          	jalr	-366(ra) # 80002530 <brelse>
}
    800026a6:	60e2                	ld	ra,24(sp)
    800026a8:	6442                	ld	s0,16(sp)
    800026aa:	64a2                	ld	s1,8(sp)
    800026ac:	6902                	ld	s2,0(sp)
    800026ae:	6105                	addi	sp,sp,32
    800026b0:	8082                	ret
        panic("freeing free block");
    800026b2:	00006517          	auipc	a0,0x6
    800026b6:	e0650513          	addi	a0,a0,-506 # 800084b8 <syscalls+0xf8>
    800026ba:	00004097          	auipc	ra,0x4
    800026be:	8f8080e7          	jalr	-1800(ra) # 80005fb2 <panic>

00000000800026c2 <balloc>:
{
    800026c2:	711d                	addi	sp,sp,-96
    800026c4:	ec86                	sd	ra,88(sp)
    800026c6:	e8a2                	sd	s0,80(sp)
    800026c8:	e4a6                	sd	s1,72(sp)
    800026ca:	e0ca                	sd	s2,64(sp)
    800026cc:	fc4e                	sd	s3,56(sp)
    800026ce:	f852                	sd	s4,48(sp)
    800026d0:	f456                	sd	s5,40(sp)
    800026d2:	f05a                	sd	s6,32(sp)
    800026d4:	ec5e                	sd	s7,24(sp)
    800026d6:	e862                	sd	s8,16(sp)
    800026d8:	e466                	sd	s9,8(sp)
    800026da:	1080                	addi	s0,sp,96
    for (b = 0; b < sb.size; b += BPB)
    800026dc:	00026797          	auipc	a5,0x26
    800026e0:	7507a783          	lw	a5,1872(a5) # 80028e2c <sb+0x4>
    800026e4:	10078163          	beqz	a5,800027e6 <balloc+0x124>
    800026e8:	8baa                	mv	s7,a0
    800026ea:	4a81                	li	s5,0
        bp = bread(dev, BBLOCK(b, sb));
    800026ec:	00026b17          	auipc	s6,0x26
    800026f0:	73cb0b13          	addi	s6,s6,1852 # 80028e28 <sb>
        for (bi = 0; bi < BPB && b + bi < sb.size; bi++)
    800026f4:	4c01                	li	s8,0
            m = 1 << (bi % 8);
    800026f6:	4985                	li	s3,1
        for (bi = 0; bi < BPB && b + bi < sb.size; bi++)
    800026f8:	6a09                	lui	s4,0x2
    for (b = 0; b < sb.size; b += BPB)
    800026fa:	6c89                	lui	s9,0x2
    800026fc:	a061                	j	80002784 <balloc+0xc2>
                bp->data[bi / 8] |= m; // Mark block in use.
    800026fe:	974a                	add	a4,a4,s2
    80002700:	8fd5                	or	a5,a5,a3
    80002702:	04f70c23          	sb	a5,88(a4)
                log_write(bp);
    80002706:	854a                	mv	a0,s2
    80002708:	00001097          	auipc	ra,0x1
    8000270c:	0ac080e7          	jalr	172(ra) # 800037b4 <log_write>
                brelse(bp);
    80002710:	854a                	mv	a0,s2
    80002712:	00000097          	auipc	ra,0x0
    80002716:	e1e080e7          	jalr	-482(ra) # 80002530 <brelse>
    bp = bread(dev, bno);
    8000271a:	85a6                	mv	a1,s1
    8000271c:	855e                	mv	a0,s7
    8000271e:	00000097          	auipc	ra,0x0
    80002722:	ce2080e7          	jalr	-798(ra) # 80002400 <bread>
    80002726:	892a                	mv	s2,a0
    memset(bp->data, 0, BSIZE);
    80002728:	40000613          	li	a2,1024
    8000272c:	4581                	li	a1,0
    8000272e:	05850513          	addi	a0,a0,88
    80002732:	ffffe097          	auipc	ra,0xffffe
    80002736:	a46080e7          	jalr	-1466(ra) # 80000178 <memset>
    log_write(bp);
    8000273a:	854a                	mv	a0,s2
    8000273c:	00001097          	auipc	ra,0x1
    80002740:	078080e7          	jalr	120(ra) # 800037b4 <log_write>
    brelse(bp);
    80002744:	854a                	mv	a0,s2
    80002746:	00000097          	auipc	ra,0x0
    8000274a:	dea080e7          	jalr	-534(ra) # 80002530 <brelse>
}
    8000274e:	8526                	mv	a0,s1
    80002750:	60e6                	ld	ra,88(sp)
    80002752:	6446                	ld	s0,80(sp)
    80002754:	64a6                	ld	s1,72(sp)
    80002756:	6906                	ld	s2,64(sp)
    80002758:	79e2                	ld	s3,56(sp)
    8000275a:	7a42                	ld	s4,48(sp)
    8000275c:	7aa2                	ld	s5,40(sp)
    8000275e:	7b02                	ld	s6,32(sp)
    80002760:	6be2                	ld	s7,24(sp)
    80002762:	6c42                	ld	s8,16(sp)
    80002764:	6ca2                	ld	s9,8(sp)
    80002766:	6125                	addi	sp,sp,96
    80002768:	8082                	ret
        brelse(bp);
    8000276a:	854a                	mv	a0,s2
    8000276c:	00000097          	auipc	ra,0x0
    80002770:	dc4080e7          	jalr	-572(ra) # 80002530 <brelse>
    for (b = 0; b < sb.size; b += BPB)
    80002774:	015c87bb          	addw	a5,s9,s5
    80002778:	00078a9b          	sext.w	s5,a5
    8000277c:	004b2703          	lw	a4,4(s6)
    80002780:	06eaf363          	bgeu	s5,a4,800027e6 <balloc+0x124>
        bp = bread(dev, BBLOCK(b, sb));
    80002784:	41fad79b          	sraiw	a5,s5,0x1f
    80002788:	0137d79b          	srliw	a5,a5,0x13
    8000278c:	015787bb          	addw	a5,a5,s5
    80002790:	40d7d79b          	sraiw	a5,a5,0xd
    80002794:	01cb2583          	lw	a1,28(s6)
    80002798:	9dbd                	addw	a1,a1,a5
    8000279a:	855e                	mv	a0,s7
    8000279c:	00000097          	auipc	ra,0x0
    800027a0:	c64080e7          	jalr	-924(ra) # 80002400 <bread>
    800027a4:	892a                	mv	s2,a0
        for (bi = 0; bi < BPB && b + bi < sb.size; bi++)
    800027a6:	004b2503          	lw	a0,4(s6)
    800027aa:	000a849b          	sext.w	s1,s5
    800027ae:	8662                	mv	a2,s8
    800027b0:	faa4fde3          	bgeu	s1,a0,8000276a <balloc+0xa8>
            m = 1 << (bi % 8);
    800027b4:	41f6579b          	sraiw	a5,a2,0x1f
    800027b8:	01d7d69b          	srliw	a3,a5,0x1d
    800027bc:	00c6873b          	addw	a4,a3,a2
    800027c0:	00777793          	andi	a5,a4,7
    800027c4:	9f95                	subw	a5,a5,a3
    800027c6:	00f997bb          	sllw	a5,s3,a5
            if ((bp->data[bi / 8] & m) == 0)
    800027ca:	4037571b          	sraiw	a4,a4,0x3
    800027ce:	00e906b3          	add	a3,s2,a4
    800027d2:	0586c683          	lbu	a3,88(a3)
    800027d6:	00d7f5b3          	and	a1,a5,a3
    800027da:	d195                	beqz	a1,800026fe <balloc+0x3c>
        for (bi = 0; bi < BPB && b + bi < sb.size; bi++)
    800027dc:	2605                	addiw	a2,a2,1
    800027de:	2485                	addiw	s1,s1,1
    800027e0:	fd4618e3          	bne	a2,s4,800027b0 <balloc+0xee>
    800027e4:	b759                	j	8000276a <balloc+0xa8>
    printf("balloc: out of blocks\n");
    800027e6:	00006517          	auipc	a0,0x6
    800027ea:	cea50513          	addi	a0,a0,-790 # 800084d0 <syscalls+0x110>
    800027ee:	00004097          	auipc	ra,0x4
    800027f2:	80e080e7          	jalr	-2034(ra) # 80005ffc <printf>
    return 0;
    800027f6:	4481                	li	s1,0
    800027f8:	bf99                	j	8000274e <balloc+0x8c>

00000000800027fa <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    800027fa:	7179                	addi	sp,sp,-48
    800027fc:	f406                	sd	ra,40(sp)
    800027fe:	f022                	sd	s0,32(sp)
    80002800:	ec26                	sd	s1,24(sp)
    80002802:	e84a                	sd	s2,16(sp)
    80002804:	e44e                	sd	s3,8(sp)
    80002806:	e052                	sd	s4,0(sp)
    80002808:	1800                	addi	s0,sp,48
    8000280a:	89aa                	mv	s3,a0
    uint addr, *a;
    struct buf *bp;

    if (bn < NDIRECT)
    8000280c:	47ad                	li	a5,11
    8000280e:	02b7e763          	bltu	a5,a1,8000283c <bmap+0x42>
    {
        if ((addr = ip->addrs[bn]) == 0)
    80002812:	02059493          	slli	s1,a1,0x20
    80002816:	9081                	srli	s1,s1,0x20
    80002818:	048a                	slli	s1,s1,0x2
    8000281a:	94aa                	add	s1,s1,a0
    8000281c:	0504a903          	lw	s2,80(s1)
    80002820:	06091e63          	bnez	s2,8000289c <bmap+0xa2>
        {
            addr = balloc(ip->dev);
    80002824:	4108                	lw	a0,0(a0)
    80002826:	00000097          	auipc	ra,0x0
    8000282a:	e9c080e7          	jalr	-356(ra) # 800026c2 <balloc>
    8000282e:	0005091b          	sext.w	s2,a0
            if (addr == 0)
    80002832:	06090563          	beqz	s2,8000289c <bmap+0xa2>
                return 0;
            ip->addrs[bn] = addr;
    80002836:	0524a823          	sw	s2,80(s1)
    8000283a:	a08d                	j	8000289c <bmap+0xa2>
        }
        return addr;
    }
    bn -= NDIRECT;
    8000283c:	ff45849b          	addiw	s1,a1,-12
    80002840:	0004871b          	sext.w	a4,s1

    if (bn < NINDIRECT)
    80002844:	0ff00793          	li	a5,255
    80002848:	08e7e563          	bltu	a5,a4,800028d2 <bmap+0xd8>
    {
        // Load indirect block, allocating if necessary.
        if ((addr = ip->addrs[NDIRECT]) == 0)
    8000284c:	08052903          	lw	s2,128(a0)
    80002850:	00091d63          	bnez	s2,8000286a <bmap+0x70>
        {
            addr = balloc(ip->dev);
    80002854:	4108                	lw	a0,0(a0)
    80002856:	00000097          	auipc	ra,0x0
    8000285a:	e6c080e7          	jalr	-404(ra) # 800026c2 <balloc>
    8000285e:	0005091b          	sext.w	s2,a0
            if (addr == 0)
    80002862:	02090d63          	beqz	s2,8000289c <bmap+0xa2>
                return 0;
            ip->addrs[NDIRECT] = addr;
    80002866:	0929a023          	sw	s2,128(s3)
        }
        bp = bread(ip->dev, addr);
    8000286a:	85ca                	mv	a1,s2
    8000286c:	0009a503          	lw	a0,0(s3)
    80002870:	00000097          	auipc	ra,0x0
    80002874:	b90080e7          	jalr	-1136(ra) # 80002400 <bread>
    80002878:	8a2a                	mv	s4,a0
        a = (uint *)bp->data;
    8000287a:	05850793          	addi	a5,a0,88
        if ((addr = a[bn]) == 0)
    8000287e:	02049593          	slli	a1,s1,0x20
    80002882:	9181                	srli	a1,a1,0x20
    80002884:	058a                	slli	a1,a1,0x2
    80002886:	00b784b3          	add	s1,a5,a1
    8000288a:	0004a903          	lw	s2,0(s1)
    8000288e:	02090063          	beqz	s2,800028ae <bmap+0xb4>
            {
                a[bn] = addr;
                log_write(bp);
            }
        }
        brelse(bp);
    80002892:	8552                	mv	a0,s4
    80002894:	00000097          	auipc	ra,0x0
    80002898:	c9c080e7          	jalr	-868(ra) # 80002530 <brelse>
        return addr;
    }

    panic("bmap: out of range");
}
    8000289c:	854a                	mv	a0,s2
    8000289e:	70a2                	ld	ra,40(sp)
    800028a0:	7402                	ld	s0,32(sp)
    800028a2:	64e2                	ld	s1,24(sp)
    800028a4:	6942                	ld	s2,16(sp)
    800028a6:	69a2                	ld	s3,8(sp)
    800028a8:	6a02                	ld	s4,0(sp)
    800028aa:	6145                	addi	sp,sp,48
    800028ac:	8082                	ret
            addr = balloc(ip->dev);
    800028ae:	0009a503          	lw	a0,0(s3)
    800028b2:	00000097          	auipc	ra,0x0
    800028b6:	e10080e7          	jalr	-496(ra) # 800026c2 <balloc>
    800028ba:	0005091b          	sext.w	s2,a0
            if (addr)
    800028be:	fc090ae3          	beqz	s2,80002892 <bmap+0x98>
                a[bn] = addr;
    800028c2:	0124a023          	sw	s2,0(s1)
                log_write(bp);
    800028c6:	8552                	mv	a0,s4
    800028c8:	00001097          	auipc	ra,0x1
    800028cc:	eec080e7          	jalr	-276(ra) # 800037b4 <log_write>
    800028d0:	b7c9                	j	80002892 <bmap+0x98>
    panic("bmap: out of range");
    800028d2:	00006517          	auipc	a0,0x6
    800028d6:	c1650513          	addi	a0,a0,-1002 # 800084e8 <syscalls+0x128>
    800028da:	00003097          	auipc	ra,0x3
    800028de:	6d8080e7          	jalr	1752(ra) # 80005fb2 <panic>

00000000800028e2 <iget>:
{
    800028e2:	7179                	addi	sp,sp,-48
    800028e4:	f406                	sd	ra,40(sp)
    800028e6:	f022                	sd	s0,32(sp)
    800028e8:	ec26                	sd	s1,24(sp)
    800028ea:	e84a                	sd	s2,16(sp)
    800028ec:	e44e                	sd	s3,8(sp)
    800028ee:	e052                	sd	s4,0(sp)
    800028f0:	1800                	addi	s0,sp,48
    800028f2:	89aa                	mv	s3,a0
    800028f4:	8a2e                	mv	s4,a1
    acquire(&itable.lock);
    800028f6:	00026517          	auipc	a0,0x26
    800028fa:	55250513          	addi	a0,a0,1362 # 80028e48 <itable>
    800028fe:	00004097          	auipc	ra,0x4
    80002902:	bfe080e7          	jalr	-1026(ra) # 800064fc <acquire>
    empty = 0;
    80002906:	4901                	li	s2,0
    for (ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++)
    80002908:	00026497          	auipc	s1,0x26
    8000290c:	55848493          	addi	s1,s1,1368 # 80028e60 <itable+0x18>
    80002910:	00028697          	auipc	a3,0x28
    80002914:	fe068693          	addi	a3,a3,-32 # 8002a8f0 <log>
    80002918:	a039                	j	80002926 <iget+0x44>
        if (empty == 0 && ip->ref == 0) // Remember empty slot.
    8000291a:	02090b63          	beqz	s2,80002950 <iget+0x6e>
    for (ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++)
    8000291e:	08848493          	addi	s1,s1,136
    80002922:	02d48a63          	beq	s1,a3,80002956 <iget+0x74>
        if (ip->ref > 0 && ip->dev == dev && ip->inum == inum)
    80002926:	449c                	lw	a5,8(s1)
    80002928:	fef059e3          	blez	a5,8000291a <iget+0x38>
    8000292c:	4098                	lw	a4,0(s1)
    8000292e:	ff3716e3          	bne	a4,s3,8000291a <iget+0x38>
    80002932:	40d8                	lw	a4,4(s1)
    80002934:	ff4713e3          	bne	a4,s4,8000291a <iget+0x38>
            ip->ref++;
    80002938:	2785                	addiw	a5,a5,1
    8000293a:	c49c                	sw	a5,8(s1)
            release(&itable.lock);
    8000293c:	00026517          	auipc	a0,0x26
    80002940:	50c50513          	addi	a0,a0,1292 # 80028e48 <itable>
    80002944:	00004097          	auipc	ra,0x4
    80002948:	c6c080e7          	jalr	-916(ra) # 800065b0 <release>
            return ip;
    8000294c:	8926                	mv	s2,s1
    8000294e:	a03d                	j	8000297c <iget+0x9a>
        if (empty == 0 && ip->ref == 0) // Remember empty slot.
    80002950:	f7f9                	bnez	a5,8000291e <iget+0x3c>
    80002952:	8926                	mv	s2,s1
    80002954:	b7e9                	j	8000291e <iget+0x3c>
    if (empty == 0)
    80002956:	02090c63          	beqz	s2,8000298e <iget+0xac>
    ip->dev = dev;
    8000295a:	01392023          	sw	s3,0(s2)
    ip->inum = inum;
    8000295e:	01492223          	sw	s4,4(s2)
    ip->ref = 1;
    80002962:	4785                	li	a5,1
    80002964:	00f92423          	sw	a5,8(s2)
    ip->valid = 0;
    80002968:	04092023          	sw	zero,64(s2)
    release(&itable.lock);
    8000296c:	00026517          	auipc	a0,0x26
    80002970:	4dc50513          	addi	a0,a0,1244 # 80028e48 <itable>
    80002974:	00004097          	auipc	ra,0x4
    80002978:	c3c080e7          	jalr	-964(ra) # 800065b0 <release>
}
    8000297c:	854a                	mv	a0,s2
    8000297e:	70a2                	ld	ra,40(sp)
    80002980:	7402                	ld	s0,32(sp)
    80002982:	64e2                	ld	s1,24(sp)
    80002984:	6942                	ld	s2,16(sp)
    80002986:	69a2                	ld	s3,8(sp)
    80002988:	6a02                	ld	s4,0(sp)
    8000298a:	6145                	addi	sp,sp,48
    8000298c:	8082                	ret
        panic("iget: no inodes");
    8000298e:	00006517          	auipc	a0,0x6
    80002992:	b7250513          	addi	a0,a0,-1166 # 80008500 <syscalls+0x140>
    80002996:	00003097          	auipc	ra,0x3
    8000299a:	61c080e7          	jalr	1564(ra) # 80005fb2 <panic>

000000008000299e <fsinit>:
{
    8000299e:	7179                	addi	sp,sp,-48
    800029a0:	f406                	sd	ra,40(sp)
    800029a2:	f022                	sd	s0,32(sp)
    800029a4:	ec26                	sd	s1,24(sp)
    800029a6:	e84a                	sd	s2,16(sp)
    800029a8:	e44e                	sd	s3,8(sp)
    800029aa:	1800                	addi	s0,sp,48
    800029ac:	892a                	mv	s2,a0
    bp = bread(dev, 1);
    800029ae:	4585                	li	a1,1
    800029b0:	00000097          	auipc	ra,0x0
    800029b4:	a50080e7          	jalr	-1456(ra) # 80002400 <bread>
    800029b8:	84aa                	mv	s1,a0
    memmove(sb, bp->data, sizeof(*sb));
    800029ba:	00026997          	auipc	s3,0x26
    800029be:	46e98993          	addi	s3,s3,1134 # 80028e28 <sb>
    800029c2:	02000613          	li	a2,32
    800029c6:	05850593          	addi	a1,a0,88
    800029ca:	854e                	mv	a0,s3
    800029cc:	ffffe097          	auipc	ra,0xffffe
    800029d0:	80c080e7          	jalr	-2036(ra) # 800001d8 <memmove>
    brelse(bp);
    800029d4:	8526                	mv	a0,s1
    800029d6:	00000097          	auipc	ra,0x0
    800029da:	b5a080e7          	jalr	-1190(ra) # 80002530 <brelse>
    if (sb.magic != FSMAGIC)
    800029de:	0009a703          	lw	a4,0(s3)
    800029e2:	102037b7          	lui	a5,0x10203
    800029e6:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    800029ea:	02f71263          	bne	a4,a5,80002a0e <fsinit+0x70>
    initlog(dev, &sb);
    800029ee:	00026597          	auipc	a1,0x26
    800029f2:	43a58593          	addi	a1,a1,1082 # 80028e28 <sb>
    800029f6:	854a                	mv	a0,s2
    800029f8:	00001097          	auipc	ra,0x1
    800029fc:	b40080e7          	jalr	-1216(ra) # 80003538 <initlog>
}
    80002a00:	70a2                	ld	ra,40(sp)
    80002a02:	7402                	ld	s0,32(sp)
    80002a04:	64e2                	ld	s1,24(sp)
    80002a06:	6942                	ld	s2,16(sp)
    80002a08:	69a2                	ld	s3,8(sp)
    80002a0a:	6145                	addi	sp,sp,48
    80002a0c:	8082                	ret
        panic("invalid file system");
    80002a0e:	00006517          	auipc	a0,0x6
    80002a12:	b0250513          	addi	a0,a0,-1278 # 80008510 <syscalls+0x150>
    80002a16:	00003097          	auipc	ra,0x3
    80002a1a:	59c080e7          	jalr	1436(ra) # 80005fb2 <panic>

0000000080002a1e <iinit>:
{
    80002a1e:	7179                	addi	sp,sp,-48
    80002a20:	f406                	sd	ra,40(sp)
    80002a22:	f022                	sd	s0,32(sp)
    80002a24:	ec26                	sd	s1,24(sp)
    80002a26:	e84a                	sd	s2,16(sp)
    80002a28:	e44e                	sd	s3,8(sp)
    80002a2a:	1800                	addi	s0,sp,48
    initlock(&itable.lock, "itable");
    80002a2c:	00006597          	auipc	a1,0x6
    80002a30:	afc58593          	addi	a1,a1,-1284 # 80008528 <syscalls+0x168>
    80002a34:	00026517          	auipc	a0,0x26
    80002a38:	41450513          	addi	a0,a0,1044 # 80028e48 <itable>
    80002a3c:	00004097          	auipc	ra,0x4
    80002a40:	a30080e7          	jalr	-1488(ra) # 8000646c <initlock>
    for (i = 0; i < NINODE; i++)
    80002a44:	00026497          	auipc	s1,0x26
    80002a48:	42c48493          	addi	s1,s1,1068 # 80028e70 <itable+0x28>
    80002a4c:	00028997          	auipc	s3,0x28
    80002a50:	eb498993          	addi	s3,s3,-332 # 8002a900 <log+0x10>
        initsleeplock(&itable.inode[i].lock, "inode");
    80002a54:	00006917          	auipc	s2,0x6
    80002a58:	adc90913          	addi	s2,s2,-1316 # 80008530 <syscalls+0x170>
    80002a5c:	85ca                	mv	a1,s2
    80002a5e:	8526                	mv	a0,s1
    80002a60:	00001097          	auipc	ra,0x1
    80002a64:	e3a080e7          	jalr	-454(ra) # 8000389a <initsleeplock>
    for (i = 0; i < NINODE; i++)
    80002a68:	08848493          	addi	s1,s1,136
    80002a6c:	ff3498e3          	bne	s1,s3,80002a5c <iinit+0x3e>
}
    80002a70:	70a2                	ld	ra,40(sp)
    80002a72:	7402                	ld	s0,32(sp)
    80002a74:	64e2                	ld	s1,24(sp)
    80002a76:	6942                	ld	s2,16(sp)
    80002a78:	69a2                	ld	s3,8(sp)
    80002a7a:	6145                	addi	sp,sp,48
    80002a7c:	8082                	ret

0000000080002a7e <ialloc>:
{
    80002a7e:	715d                	addi	sp,sp,-80
    80002a80:	e486                	sd	ra,72(sp)
    80002a82:	e0a2                	sd	s0,64(sp)
    80002a84:	fc26                	sd	s1,56(sp)
    80002a86:	f84a                	sd	s2,48(sp)
    80002a88:	f44e                	sd	s3,40(sp)
    80002a8a:	f052                	sd	s4,32(sp)
    80002a8c:	ec56                	sd	s5,24(sp)
    80002a8e:	e85a                	sd	s6,16(sp)
    80002a90:	e45e                	sd	s7,8(sp)
    80002a92:	0880                	addi	s0,sp,80
    for (inum = 1; inum < sb.ninodes; inum++)
    80002a94:	00026717          	auipc	a4,0x26
    80002a98:	3a072703          	lw	a4,928(a4) # 80028e34 <sb+0xc>
    80002a9c:	4785                	li	a5,1
    80002a9e:	04e7fa63          	bgeu	a5,a4,80002af2 <ialloc+0x74>
    80002aa2:	8aaa                	mv	s5,a0
    80002aa4:	8bae                	mv	s7,a1
    80002aa6:	4485                	li	s1,1
        bp = bread(dev, IBLOCK(inum, sb));
    80002aa8:	00026a17          	auipc	s4,0x26
    80002aac:	380a0a13          	addi	s4,s4,896 # 80028e28 <sb>
    80002ab0:	00048b1b          	sext.w	s6,s1
    80002ab4:	0044d593          	srli	a1,s1,0x4
    80002ab8:	018a2783          	lw	a5,24(s4)
    80002abc:	9dbd                	addw	a1,a1,a5
    80002abe:	8556                	mv	a0,s5
    80002ac0:	00000097          	auipc	ra,0x0
    80002ac4:	940080e7          	jalr	-1728(ra) # 80002400 <bread>
    80002ac8:	892a                	mv	s2,a0
        dip = (struct dinode *)bp->data + inum % IPB;
    80002aca:	05850993          	addi	s3,a0,88
    80002ace:	00f4f793          	andi	a5,s1,15
    80002ad2:	079a                	slli	a5,a5,0x6
    80002ad4:	99be                	add	s3,s3,a5
        if (dip->type == 0)
    80002ad6:	00099783          	lh	a5,0(s3)
    80002ada:	c3a1                	beqz	a5,80002b1a <ialloc+0x9c>
        brelse(bp);
    80002adc:	00000097          	auipc	ra,0x0
    80002ae0:	a54080e7          	jalr	-1452(ra) # 80002530 <brelse>
    for (inum = 1; inum < sb.ninodes; inum++)
    80002ae4:	0485                	addi	s1,s1,1
    80002ae6:	00ca2703          	lw	a4,12(s4)
    80002aea:	0004879b          	sext.w	a5,s1
    80002aee:	fce7e1e3          	bltu	a5,a4,80002ab0 <ialloc+0x32>
    printf("ialloc: no inodes\n");
    80002af2:	00006517          	auipc	a0,0x6
    80002af6:	a4650513          	addi	a0,a0,-1466 # 80008538 <syscalls+0x178>
    80002afa:	00003097          	auipc	ra,0x3
    80002afe:	502080e7          	jalr	1282(ra) # 80005ffc <printf>
    return 0;
    80002b02:	4501                	li	a0,0
}
    80002b04:	60a6                	ld	ra,72(sp)
    80002b06:	6406                	ld	s0,64(sp)
    80002b08:	74e2                	ld	s1,56(sp)
    80002b0a:	7942                	ld	s2,48(sp)
    80002b0c:	79a2                	ld	s3,40(sp)
    80002b0e:	7a02                	ld	s4,32(sp)
    80002b10:	6ae2                	ld	s5,24(sp)
    80002b12:	6b42                	ld	s6,16(sp)
    80002b14:	6ba2                	ld	s7,8(sp)
    80002b16:	6161                	addi	sp,sp,80
    80002b18:	8082                	ret
            memset(dip, 0, sizeof(*dip));
    80002b1a:	04000613          	li	a2,64
    80002b1e:	4581                	li	a1,0
    80002b20:	854e                	mv	a0,s3
    80002b22:	ffffd097          	auipc	ra,0xffffd
    80002b26:	656080e7          	jalr	1622(ra) # 80000178 <memset>
            dip->type = type;
    80002b2a:	01799023          	sh	s7,0(s3)
            log_write(bp); // mark it allocated on the disk
    80002b2e:	854a                	mv	a0,s2
    80002b30:	00001097          	auipc	ra,0x1
    80002b34:	c84080e7          	jalr	-892(ra) # 800037b4 <log_write>
            brelse(bp);
    80002b38:	854a                	mv	a0,s2
    80002b3a:	00000097          	auipc	ra,0x0
    80002b3e:	9f6080e7          	jalr	-1546(ra) # 80002530 <brelse>
            return iget(dev, inum);
    80002b42:	85da                	mv	a1,s6
    80002b44:	8556                	mv	a0,s5
    80002b46:	00000097          	auipc	ra,0x0
    80002b4a:	d9c080e7          	jalr	-612(ra) # 800028e2 <iget>
    80002b4e:	bf5d                	j	80002b04 <ialloc+0x86>

0000000080002b50 <iupdate>:
{
    80002b50:	1101                	addi	sp,sp,-32
    80002b52:	ec06                	sd	ra,24(sp)
    80002b54:	e822                	sd	s0,16(sp)
    80002b56:	e426                	sd	s1,8(sp)
    80002b58:	e04a                	sd	s2,0(sp)
    80002b5a:	1000                	addi	s0,sp,32
    80002b5c:	84aa                	mv	s1,a0
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002b5e:	415c                	lw	a5,4(a0)
    80002b60:	0047d79b          	srliw	a5,a5,0x4
    80002b64:	00026597          	auipc	a1,0x26
    80002b68:	2dc5a583          	lw	a1,732(a1) # 80028e40 <sb+0x18>
    80002b6c:	9dbd                	addw	a1,a1,a5
    80002b6e:	4108                	lw	a0,0(a0)
    80002b70:	00000097          	auipc	ra,0x0
    80002b74:	890080e7          	jalr	-1904(ra) # 80002400 <bread>
    80002b78:	892a                	mv	s2,a0
    dip = (struct dinode *)bp->data + ip->inum % IPB;
    80002b7a:	05850793          	addi	a5,a0,88
    80002b7e:	40c8                	lw	a0,4(s1)
    80002b80:	893d                	andi	a0,a0,15
    80002b82:	051a                	slli	a0,a0,0x6
    80002b84:	953e                	add	a0,a0,a5
    dip->type = ip->type;
    80002b86:	04449703          	lh	a4,68(s1)
    80002b8a:	00e51023          	sh	a4,0(a0)
    dip->major = ip->major;
    80002b8e:	04649703          	lh	a4,70(s1)
    80002b92:	00e51123          	sh	a4,2(a0)
    dip->minor = ip->minor;
    80002b96:	04849703          	lh	a4,72(s1)
    80002b9a:	00e51223          	sh	a4,4(a0)
    dip->nlink = ip->nlink;
    80002b9e:	04a49703          	lh	a4,74(s1)
    80002ba2:	00e51323          	sh	a4,6(a0)
    dip->size = ip->size;
    80002ba6:	44f8                	lw	a4,76(s1)
    80002ba8:	c518                	sw	a4,8(a0)
    memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002baa:	03400613          	li	a2,52
    80002bae:	05048593          	addi	a1,s1,80
    80002bb2:	0531                	addi	a0,a0,12
    80002bb4:	ffffd097          	auipc	ra,0xffffd
    80002bb8:	624080e7          	jalr	1572(ra) # 800001d8 <memmove>
    log_write(bp);
    80002bbc:	854a                	mv	a0,s2
    80002bbe:	00001097          	auipc	ra,0x1
    80002bc2:	bf6080e7          	jalr	-1034(ra) # 800037b4 <log_write>
    brelse(bp);
    80002bc6:	854a                	mv	a0,s2
    80002bc8:	00000097          	auipc	ra,0x0
    80002bcc:	968080e7          	jalr	-1688(ra) # 80002530 <brelse>
}
    80002bd0:	60e2                	ld	ra,24(sp)
    80002bd2:	6442                	ld	s0,16(sp)
    80002bd4:	64a2                	ld	s1,8(sp)
    80002bd6:	6902                	ld	s2,0(sp)
    80002bd8:	6105                	addi	sp,sp,32
    80002bda:	8082                	ret

0000000080002bdc <idup>:
{
    80002bdc:	1101                	addi	sp,sp,-32
    80002bde:	ec06                	sd	ra,24(sp)
    80002be0:	e822                	sd	s0,16(sp)
    80002be2:	e426                	sd	s1,8(sp)
    80002be4:	1000                	addi	s0,sp,32
    80002be6:	84aa                	mv	s1,a0
    acquire(&itable.lock);
    80002be8:	00026517          	auipc	a0,0x26
    80002bec:	26050513          	addi	a0,a0,608 # 80028e48 <itable>
    80002bf0:	00004097          	auipc	ra,0x4
    80002bf4:	90c080e7          	jalr	-1780(ra) # 800064fc <acquire>
    ip->ref++;
    80002bf8:	449c                	lw	a5,8(s1)
    80002bfa:	2785                	addiw	a5,a5,1
    80002bfc:	c49c                	sw	a5,8(s1)
    release(&itable.lock);
    80002bfe:	00026517          	auipc	a0,0x26
    80002c02:	24a50513          	addi	a0,a0,586 # 80028e48 <itable>
    80002c06:	00004097          	auipc	ra,0x4
    80002c0a:	9aa080e7          	jalr	-1622(ra) # 800065b0 <release>
}
    80002c0e:	8526                	mv	a0,s1
    80002c10:	60e2                	ld	ra,24(sp)
    80002c12:	6442                	ld	s0,16(sp)
    80002c14:	64a2                	ld	s1,8(sp)
    80002c16:	6105                	addi	sp,sp,32
    80002c18:	8082                	ret

0000000080002c1a <ilock>:
{
    80002c1a:	1101                	addi	sp,sp,-32
    80002c1c:	ec06                	sd	ra,24(sp)
    80002c1e:	e822                	sd	s0,16(sp)
    80002c20:	e426                	sd	s1,8(sp)
    80002c22:	e04a                	sd	s2,0(sp)
    80002c24:	1000                	addi	s0,sp,32
    if (ip == 0 || ip->ref < 1)
    80002c26:	c115                	beqz	a0,80002c4a <ilock+0x30>
    80002c28:	84aa                	mv	s1,a0
    80002c2a:	451c                	lw	a5,8(a0)
    80002c2c:	00f05f63          	blez	a5,80002c4a <ilock+0x30>
    acquiresleep(&ip->lock);
    80002c30:	0541                	addi	a0,a0,16
    80002c32:	00001097          	auipc	ra,0x1
    80002c36:	ca2080e7          	jalr	-862(ra) # 800038d4 <acquiresleep>
    if (ip->valid == 0)
    80002c3a:	40bc                	lw	a5,64(s1)
    80002c3c:	cf99                	beqz	a5,80002c5a <ilock+0x40>
}
    80002c3e:	60e2                	ld	ra,24(sp)
    80002c40:	6442                	ld	s0,16(sp)
    80002c42:	64a2                	ld	s1,8(sp)
    80002c44:	6902                	ld	s2,0(sp)
    80002c46:	6105                	addi	sp,sp,32
    80002c48:	8082                	ret
        panic("ilock");
    80002c4a:	00006517          	auipc	a0,0x6
    80002c4e:	90650513          	addi	a0,a0,-1786 # 80008550 <syscalls+0x190>
    80002c52:	00003097          	auipc	ra,0x3
    80002c56:	360080e7          	jalr	864(ra) # 80005fb2 <panic>
        bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002c5a:	40dc                	lw	a5,4(s1)
    80002c5c:	0047d79b          	srliw	a5,a5,0x4
    80002c60:	00026597          	auipc	a1,0x26
    80002c64:	1e05a583          	lw	a1,480(a1) # 80028e40 <sb+0x18>
    80002c68:	9dbd                	addw	a1,a1,a5
    80002c6a:	4088                	lw	a0,0(s1)
    80002c6c:	fffff097          	auipc	ra,0xfffff
    80002c70:	794080e7          	jalr	1940(ra) # 80002400 <bread>
    80002c74:	892a                	mv	s2,a0
        dip = (struct dinode *)bp->data + ip->inum % IPB;
    80002c76:	05850593          	addi	a1,a0,88
    80002c7a:	40dc                	lw	a5,4(s1)
    80002c7c:	8bbd                	andi	a5,a5,15
    80002c7e:	079a                	slli	a5,a5,0x6
    80002c80:	95be                	add	a1,a1,a5
        ip->type = dip->type;
    80002c82:	00059783          	lh	a5,0(a1)
    80002c86:	04f49223          	sh	a5,68(s1)
        ip->major = dip->major;
    80002c8a:	00259783          	lh	a5,2(a1)
    80002c8e:	04f49323          	sh	a5,70(s1)
        ip->minor = dip->minor;
    80002c92:	00459783          	lh	a5,4(a1)
    80002c96:	04f49423          	sh	a5,72(s1)
        ip->nlink = dip->nlink;
    80002c9a:	00659783          	lh	a5,6(a1)
    80002c9e:	04f49523          	sh	a5,74(s1)
        ip->size = dip->size;
    80002ca2:	459c                	lw	a5,8(a1)
    80002ca4:	c4fc                	sw	a5,76(s1)
        memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002ca6:	03400613          	li	a2,52
    80002caa:	05b1                	addi	a1,a1,12
    80002cac:	05048513          	addi	a0,s1,80
    80002cb0:	ffffd097          	auipc	ra,0xffffd
    80002cb4:	528080e7          	jalr	1320(ra) # 800001d8 <memmove>
        brelse(bp);
    80002cb8:	854a                	mv	a0,s2
    80002cba:	00000097          	auipc	ra,0x0
    80002cbe:	876080e7          	jalr	-1930(ra) # 80002530 <brelse>
        ip->valid = 1;
    80002cc2:	4785                	li	a5,1
    80002cc4:	c0bc                	sw	a5,64(s1)
        if (ip->type == 0)
    80002cc6:	04449783          	lh	a5,68(s1)
    80002cca:	fbb5                	bnez	a5,80002c3e <ilock+0x24>
            panic("ilock: no type");
    80002ccc:	00006517          	auipc	a0,0x6
    80002cd0:	88c50513          	addi	a0,a0,-1908 # 80008558 <syscalls+0x198>
    80002cd4:	00003097          	auipc	ra,0x3
    80002cd8:	2de080e7          	jalr	734(ra) # 80005fb2 <panic>

0000000080002cdc <iunlock>:
{
    80002cdc:	1101                	addi	sp,sp,-32
    80002cde:	ec06                	sd	ra,24(sp)
    80002ce0:	e822                	sd	s0,16(sp)
    80002ce2:	e426                	sd	s1,8(sp)
    80002ce4:	e04a                	sd	s2,0(sp)
    80002ce6:	1000                	addi	s0,sp,32
    if (ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002ce8:	c905                	beqz	a0,80002d18 <iunlock+0x3c>
    80002cea:	84aa                	mv	s1,a0
    80002cec:	01050913          	addi	s2,a0,16
    80002cf0:	854a                	mv	a0,s2
    80002cf2:	00001097          	auipc	ra,0x1
    80002cf6:	c7c080e7          	jalr	-900(ra) # 8000396e <holdingsleep>
    80002cfa:	cd19                	beqz	a0,80002d18 <iunlock+0x3c>
    80002cfc:	449c                	lw	a5,8(s1)
    80002cfe:	00f05d63          	blez	a5,80002d18 <iunlock+0x3c>
    releasesleep(&ip->lock);
    80002d02:	854a                	mv	a0,s2
    80002d04:	00001097          	auipc	ra,0x1
    80002d08:	c26080e7          	jalr	-986(ra) # 8000392a <releasesleep>
}
    80002d0c:	60e2                	ld	ra,24(sp)
    80002d0e:	6442                	ld	s0,16(sp)
    80002d10:	64a2                	ld	s1,8(sp)
    80002d12:	6902                	ld	s2,0(sp)
    80002d14:	6105                	addi	sp,sp,32
    80002d16:	8082                	ret
        panic("iunlock");
    80002d18:	00006517          	auipc	a0,0x6
    80002d1c:	85050513          	addi	a0,a0,-1968 # 80008568 <syscalls+0x1a8>
    80002d20:	00003097          	auipc	ra,0x3
    80002d24:	292080e7          	jalr	658(ra) # 80005fb2 <panic>

0000000080002d28 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void itrunc(struct inode *ip)
{
    80002d28:	7179                	addi	sp,sp,-48
    80002d2a:	f406                	sd	ra,40(sp)
    80002d2c:	f022                	sd	s0,32(sp)
    80002d2e:	ec26                	sd	s1,24(sp)
    80002d30:	e84a                	sd	s2,16(sp)
    80002d32:	e44e                	sd	s3,8(sp)
    80002d34:	e052                	sd	s4,0(sp)
    80002d36:	1800                	addi	s0,sp,48
    80002d38:	89aa                	mv	s3,a0
    int i, j;
    struct buf *bp;
    uint *a;

    for (i = 0; i < NDIRECT; i++)
    80002d3a:	05050493          	addi	s1,a0,80
    80002d3e:	08050913          	addi	s2,a0,128
    80002d42:	a021                	j	80002d4a <itrunc+0x22>
    80002d44:	0491                	addi	s1,s1,4
    80002d46:	01248d63          	beq	s1,s2,80002d60 <itrunc+0x38>
    {
        if (ip->addrs[i])
    80002d4a:	408c                	lw	a1,0(s1)
    80002d4c:	dde5                	beqz	a1,80002d44 <itrunc+0x1c>
        {
            bfree(ip->dev, ip->addrs[i]);
    80002d4e:	0009a503          	lw	a0,0(s3)
    80002d52:	00000097          	auipc	ra,0x0
    80002d56:	8f4080e7          	jalr	-1804(ra) # 80002646 <bfree>
            ip->addrs[i] = 0;
    80002d5a:	0004a023          	sw	zero,0(s1)
    80002d5e:	b7dd                	j	80002d44 <itrunc+0x1c>
        }
    }

    if (ip->addrs[NDIRECT])
    80002d60:	0809a583          	lw	a1,128(s3)
    80002d64:	e185                	bnez	a1,80002d84 <itrunc+0x5c>
        brelse(bp);
        bfree(ip->dev, ip->addrs[NDIRECT]);
        ip->addrs[NDIRECT] = 0;
    }

    ip->size = 0;
    80002d66:	0409a623          	sw	zero,76(s3)
    iupdate(ip);
    80002d6a:	854e                	mv	a0,s3
    80002d6c:	00000097          	auipc	ra,0x0
    80002d70:	de4080e7          	jalr	-540(ra) # 80002b50 <iupdate>
}
    80002d74:	70a2                	ld	ra,40(sp)
    80002d76:	7402                	ld	s0,32(sp)
    80002d78:	64e2                	ld	s1,24(sp)
    80002d7a:	6942                	ld	s2,16(sp)
    80002d7c:	69a2                	ld	s3,8(sp)
    80002d7e:	6a02                	ld	s4,0(sp)
    80002d80:	6145                	addi	sp,sp,48
    80002d82:	8082                	ret
        bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002d84:	0009a503          	lw	a0,0(s3)
    80002d88:	fffff097          	auipc	ra,0xfffff
    80002d8c:	678080e7          	jalr	1656(ra) # 80002400 <bread>
    80002d90:	8a2a                	mv	s4,a0
        for (j = 0; j < NINDIRECT; j++)
    80002d92:	05850493          	addi	s1,a0,88
    80002d96:	45850913          	addi	s2,a0,1112
    80002d9a:	a811                	j	80002dae <itrunc+0x86>
                bfree(ip->dev, a[j]);
    80002d9c:	0009a503          	lw	a0,0(s3)
    80002da0:	00000097          	auipc	ra,0x0
    80002da4:	8a6080e7          	jalr	-1882(ra) # 80002646 <bfree>
        for (j = 0; j < NINDIRECT; j++)
    80002da8:	0491                	addi	s1,s1,4
    80002daa:	01248563          	beq	s1,s2,80002db4 <itrunc+0x8c>
            if (a[j])
    80002dae:	408c                	lw	a1,0(s1)
    80002db0:	dde5                	beqz	a1,80002da8 <itrunc+0x80>
    80002db2:	b7ed                	j	80002d9c <itrunc+0x74>
        brelse(bp);
    80002db4:	8552                	mv	a0,s4
    80002db6:	fffff097          	auipc	ra,0xfffff
    80002dba:	77a080e7          	jalr	1914(ra) # 80002530 <brelse>
        bfree(ip->dev, ip->addrs[NDIRECT]);
    80002dbe:	0809a583          	lw	a1,128(s3)
    80002dc2:	0009a503          	lw	a0,0(s3)
    80002dc6:	00000097          	auipc	ra,0x0
    80002dca:	880080e7          	jalr	-1920(ra) # 80002646 <bfree>
        ip->addrs[NDIRECT] = 0;
    80002dce:	0809a023          	sw	zero,128(s3)
    80002dd2:	bf51                	j	80002d66 <itrunc+0x3e>

0000000080002dd4 <iput>:
{
    80002dd4:	1101                	addi	sp,sp,-32
    80002dd6:	ec06                	sd	ra,24(sp)
    80002dd8:	e822                	sd	s0,16(sp)
    80002dda:	e426                	sd	s1,8(sp)
    80002ddc:	e04a                	sd	s2,0(sp)
    80002dde:	1000                	addi	s0,sp,32
    80002de0:	84aa                	mv	s1,a0
    acquire(&itable.lock);
    80002de2:	00026517          	auipc	a0,0x26
    80002de6:	06650513          	addi	a0,a0,102 # 80028e48 <itable>
    80002dea:	00003097          	auipc	ra,0x3
    80002dee:	712080e7          	jalr	1810(ra) # 800064fc <acquire>
    if (ip->ref == 1 && ip->valid && ip->nlink == 0)
    80002df2:	4498                	lw	a4,8(s1)
    80002df4:	4785                	li	a5,1
    80002df6:	02f70363          	beq	a4,a5,80002e1c <iput+0x48>
    ip->ref--;
    80002dfa:	449c                	lw	a5,8(s1)
    80002dfc:	37fd                	addiw	a5,a5,-1
    80002dfe:	c49c                	sw	a5,8(s1)
    release(&itable.lock);
    80002e00:	00026517          	auipc	a0,0x26
    80002e04:	04850513          	addi	a0,a0,72 # 80028e48 <itable>
    80002e08:	00003097          	auipc	ra,0x3
    80002e0c:	7a8080e7          	jalr	1960(ra) # 800065b0 <release>
}
    80002e10:	60e2                	ld	ra,24(sp)
    80002e12:	6442                	ld	s0,16(sp)
    80002e14:	64a2                	ld	s1,8(sp)
    80002e16:	6902                	ld	s2,0(sp)
    80002e18:	6105                	addi	sp,sp,32
    80002e1a:	8082                	ret
    if (ip->ref == 1 && ip->valid && ip->nlink == 0)
    80002e1c:	40bc                	lw	a5,64(s1)
    80002e1e:	dff1                	beqz	a5,80002dfa <iput+0x26>
    80002e20:	04a49783          	lh	a5,74(s1)
    80002e24:	fbf9                	bnez	a5,80002dfa <iput+0x26>
        acquiresleep(&ip->lock);
    80002e26:	01048913          	addi	s2,s1,16
    80002e2a:	854a                	mv	a0,s2
    80002e2c:	00001097          	auipc	ra,0x1
    80002e30:	aa8080e7          	jalr	-1368(ra) # 800038d4 <acquiresleep>
        release(&itable.lock);
    80002e34:	00026517          	auipc	a0,0x26
    80002e38:	01450513          	addi	a0,a0,20 # 80028e48 <itable>
    80002e3c:	00003097          	auipc	ra,0x3
    80002e40:	774080e7          	jalr	1908(ra) # 800065b0 <release>
        itrunc(ip);
    80002e44:	8526                	mv	a0,s1
    80002e46:	00000097          	auipc	ra,0x0
    80002e4a:	ee2080e7          	jalr	-286(ra) # 80002d28 <itrunc>
        ip->type = 0;
    80002e4e:	04049223          	sh	zero,68(s1)
        iupdate(ip);
    80002e52:	8526                	mv	a0,s1
    80002e54:	00000097          	auipc	ra,0x0
    80002e58:	cfc080e7          	jalr	-772(ra) # 80002b50 <iupdate>
        ip->valid = 0;
    80002e5c:	0404a023          	sw	zero,64(s1)
        releasesleep(&ip->lock);
    80002e60:	854a                	mv	a0,s2
    80002e62:	00001097          	auipc	ra,0x1
    80002e66:	ac8080e7          	jalr	-1336(ra) # 8000392a <releasesleep>
        acquire(&itable.lock);
    80002e6a:	00026517          	auipc	a0,0x26
    80002e6e:	fde50513          	addi	a0,a0,-34 # 80028e48 <itable>
    80002e72:	00003097          	auipc	ra,0x3
    80002e76:	68a080e7          	jalr	1674(ra) # 800064fc <acquire>
    80002e7a:	b741                	j	80002dfa <iput+0x26>

0000000080002e7c <iunlockput>:
{
    80002e7c:	1101                	addi	sp,sp,-32
    80002e7e:	ec06                	sd	ra,24(sp)
    80002e80:	e822                	sd	s0,16(sp)
    80002e82:	e426                	sd	s1,8(sp)
    80002e84:	1000                	addi	s0,sp,32
    80002e86:	84aa                	mv	s1,a0
    iunlock(ip);
    80002e88:	00000097          	auipc	ra,0x0
    80002e8c:	e54080e7          	jalr	-428(ra) # 80002cdc <iunlock>
    iput(ip);
    80002e90:	8526                	mv	a0,s1
    80002e92:	00000097          	auipc	ra,0x0
    80002e96:	f42080e7          	jalr	-190(ra) # 80002dd4 <iput>
}
    80002e9a:	60e2                	ld	ra,24(sp)
    80002e9c:	6442                	ld	s0,16(sp)
    80002e9e:	64a2                	ld	s1,8(sp)
    80002ea0:	6105                	addi	sp,sp,32
    80002ea2:	8082                	ret

0000000080002ea4 <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void stati(struct inode *ip, struct stat *st)
{
    80002ea4:	1141                	addi	sp,sp,-16
    80002ea6:	e422                	sd	s0,8(sp)
    80002ea8:	0800                	addi	s0,sp,16
    st->dev = ip->dev;
    80002eaa:	411c                	lw	a5,0(a0)
    80002eac:	c19c                	sw	a5,0(a1)
    st->ino = ip->inum;
    80002eae:	415c                	lw	a5,4(a0)
    80002eb0:	c1dc                	sw	a5,4(a1)
    st->type = ip->type;
    80002eb2:	04451783          	lh	a5,68(a0)
    80002eb6:	00f59423          	sh	a5,8(a1)
    st->nlink = ip->nlink;
    80002eba:	04a51783          	lh	a5,74(a0)
    80002ebe:	00f59523          	sh	a5,10(a1)
    st->size = ip->size;
    80002ec2:	04c56783          	lwu	a5,76(a0)
    80002ec6:	e99c                	sd	a5,16(a1)
}
    80002ec8:	6422                	ld	s0,8(sp)
    80002eca:	0141                	addi	sp,sp,16
    80002ecc:	8082                	ret

0000000080002ece <readi>:
int readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
    uint tot, m;
    struct buf *bp;

    if (off > ip->size || off + n < off)
    80002ece:	457c                	lw	a5,76(a0)
    80002ed0:	0ed7e963          	bltu	a5,a3,80002fc2 <readi+0xf4>
{
    80002ed4:	7159                	addi	sp,sp,-112
    80002ed6:	f486                	sd	ra,104(sp)
    80002ed8:	f0a2                	sd	s0,96(sp)
    80002eda:	eca6                	sd	s1,88(sp)
    80002edc:	e8ca                	sd	s2,80(sp)
    80002ede:	e4ce                	sd	s3,72(sp)
    80002ee0:	e0d2                	sd	s4,64(sp)
    80002ee2:	fc56                	sd	s5,56(sp)
    80002ee4:	f85a                	sd	s6,48(sp)
    80002ee6:	f45e                	sd	s7,40(sp)
    80002ee8:	f062                	sd	s8,32(sp)
    80002eea:	ec66                	sd	s9,24(sp)
    80002eec:	e86a                	sd	s10,16(sp)
    80002eee:	e46e                	sd	s11,8(sp)
    80002ef0:	1880                	addi	s0,sp,112
    80002ef2:	8b2a                	mv	s6,a0
    80002ef4:	8bae                	mv	s7,a1
    80002ef6:	8a32                	mv	s4,a2
    80002ef8:	84b6                	mv	s1,a3
    80002efa:	8aba                	mv	s5,a4
    if (off > ip->size || off + n < off)
    80002efc:	9f35                	addw	a4,a4,a3
        return 0;
    80002efe:	4501                	li	a0,0
    if (off > ip->size || off + n < off)
    80002f00:	0ad76063          	bltu	a4,a3,80002fa0 <readi+0xd2>
    if (off + n > ip->size)
    80002f04:	00e7f463          	bgeu	a5,a4,80002f0c <readi+0x3e>
        n = ip->size - off;
    80002f08:	40d78abb          	subw	s5,a5,a3

    for (tot = 0; tot < n; tot += m, off += m, dst += m)
    80002f0c:	0a0a8963          	beqz	s5,80002fbe <readi+0xf0>
    80002f10:	4981                	li	s3,0
    {
        uint addr = bmap(ip, off / BSIZE);
        if (addr == 0)
            break;
        bp = bread(ip->dev, addr);
        m = min(n - tot, BSIZE - off % BSIZE);
    80002f12:	40000c93          	li	s9,1024
        if (either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1)
    80002f16:	5c7d                	li	s8,-1
    80002f18:	a82d                	j	80002f52 <readi+0x84>
    80002f1a:	020d1d93          	slli	s11,s10,0x20
    80002f1e:	020ddd93          	srli	s11,s11,0x20
    80002f22:	05890613          	addi	a2,s2,88
    80002f26:	86ee                	mv	a3,s11
    80002f28:	963a                	add	a2,a2,a4
    80002f2a:	85d2                	mv	a1,s4
    80002f2c:	855e                	mv	a0,s7
    80002f2e:	fffff097          	auipc	ra,0xfffff
    80002f32:	a24080e7          	jalr	-1500(ra) # 80001952 <either_copyout>
    80002f36:	05850d63          	beq	a0,s8,80002f90 <readi+0xc2>
        {
            brelse(bp);
            tot = -1;
            break;
        }
        brelse(bp);
    80002f3a:	854a                	mv	a0,s2
    80002f3c:	fffff097          	auipc	ra,0xfffff
    80002f40:	5f4080e7          	jalr	1524(ra) # 80002530 <brelse>
    for (tot = 0; tot < n; tot += m, off += m, dst += m)
    80002f44:	013d09bb          	addw	s3,s10,s3
    80002f48:	009d04bb          	addw	s1,s10,s1
    80002f4c:	9a6e                	add	s4,s4,s11
    80002f4e:	0559f763          	bgeu	s3,s5,80002f9c <readi+0xce>
        uint addr = bmap(ip, off / BSIZE);
    80002f52:	00a4d59b          	srliw	a1,s1,0xa
    80002f56:	855a                	mv	a0,s6
    80002f58:	00000097          	auipc	ra,0x0
    80002f5c:	8a2080e7          	jalr	-1886(ra) # 800027fa <bmap>
    80002f60:	0005059b          	sext.w	a1,a0
        if (addr == 0)
    80002f64:	cd85                	beqz	a1,80002f9c <readi+0xce>
        bp = bread(ip->dev, addr);
    80002f66:	000b2503          	lw	a0,0(s6)
    80002f6a:	fffff097          	auipc	ra,0xfffff
    80002f6e:	496080e7          	jalr	1174(ra) # 80002400 <bread>
    80002f72:	892a                	mv	s2,a0
        m = min(n - tot, BSIZE - off % BSIZE);
    80002f74:	3ff4f713          	andi	a4,s1,1023
    80002f78:	40ec87bb          	subw	a5,s9,a4
    80002f7c:	413a86bb          	subw	a3,s5,s3
    80002f80:	8d3e                	mv	s10,a5
    80002f82:	2781                	sext.w	a5,a5
    80002f84:	0006861b          	sext.w	a2,a3
    80002f88:	f8f679e3          	bgeu	a2,a5,80002f1a <readi+0x4c>
    80002f8c:	8d36                	mv	s10,a3
    80002f8e:	b771                	j	80002f1a <readi+0x4c>
            brelse(bp);
    80002f90:	854a                	mv	a0,s2
    80002f92:	fffff097          	auipc	ra,0xfffff
    80002f96:	59e080e7          	jalr	1438(ra) # 80002530 <brelse>
            tot = -1;
    80002f9a:	59fd                	li	s3,-1
    }
    return tot;
    80002f9c:	0009851b          	sext.w	a0,s3
}
    80002fa0:	70a6                	ld	ra,104(sp)
    80002fa2:	7406                	ld	s0,96(sp)
    80002fa4:	64e6                	ld	s1,88(sp)
    80002fa6:	6946                	ld	s2,80(sp)
    80002fa8:	69a6                	ld	s3,72(sp)
    80002faa:	6a06                	ld	s4,64(sp)
    80002fac:	7ae2                	ld	s5,56(sp)
    80002fae:	7b42                	ld	s6,48(sp)
    80002fb0:	7ba2                	ld	s7,40(sp)
    80002fb2:	7c02                	ld	s8,32(sp)
    80002fb4:	6ce2                	ld	s9,24(sp)
    80002fb6:	6d42                	ld	s10,16(sp)
    80002fb8:	6da2                	ld	s11,8(sp)
    80002fba:	6165                	addi	sp,sp,112
    80002fbc:	8082                	ret
    for (tot = 0; tot < n; tot += m, off += m, dst += m)
    80002fbe:	89d6                	mv	s3,s5
    80002fc0:	bff1                	j	80002f9c <readi+0xce>
        return 0;
    80002fc2:	4501                	li	a0,0
}
    80002fc4:	8082                	ret

0000000080002fc6 <writei>:
int writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
    uint tot, m;
    struct buf *bp;

    if (off > ip->size || off + n < off)
    80002fc6:	457c                	lw	a5,76(a0)
    80002fc8:	10d7e863          	bltu	a5,a3,800030d8 <writei+0x112>
{
    80002fcc:	7159                	addi	sp,sp,-112
    80002fce:	f486                	sd	ra,104(sp)
    80002fd0:	f0a2                	sd	s0,96(sp)
    80002fd2:	eca6                	sd	s1,88(sp)
    80002fd4:	e8ca                	sd	s2,80(sp)
    80002fd6:	e4ce                	sd	s3,72(sp)
    80002fd8:	e0d2                	sd	s4,64(sp)
    80002fda:	fc56                	sd	s5,56(sp)
    80002fdc:	f85a                	sd	s6,48(sp)
    80002fde:	f45e                	sd	s7,40(sp)
    80002fe0:	f062                	sd	s8,32(sp)
    80002fe2:	ec66                	sd	s9,24(sp)
    80002fe4:	e86a                	sd	s10,16(sp)
    80002fe6:	e46e                	sd	s11,8(sp)
    80002fe8:	1880                	addi	s0,sp,112
    80002fea:	8aaa                	mv	s5,a0
    80002fec:	8bae                	mv	s7,a1
    80002fee:	8a32                	mv	s4,a2
    80002ff0:	8936                	mv	s2,a3
    80002ff2:	8b3a                	mv	s6,a4
    if (off > ip->size || off + n < off)
    80002ff4:	00e687bb          	addw	a5,a3,a4
    80002ff8:	0ed7e263          	bltu	a5,a3,800030dc <writei+0x116>
        return -1;
    if (off + n > MAXFILE * BSIZE)
    80002ffc:	00043737          	lui	a4,0x43
    80003000:	0ef76063          	bltu	a4,a5,800030e0 <writei+0x11a>
        return -1;

    for (tot = 0; tot < n; tot += m, off += m, src += m)
    80003004:	0c0b0863          	beqz	s6,800030d4 <writei+0x10e>
    80003008:	4981                	li	s3,0
    {
        uint addr = bmap(ip, off / BSIZE);
        if (addr == 0)
            break;
        bp = bread(ip->dev, addr);
        m = min(n - tot, BSIZE - off % BSIZE);
    8000300a:	40000c93          	li	s9,1024
        if (either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1)
    8000300e:	5c7d                	li	s8,-1
    80003010:	a091                	j	80003054 <writei+0x8e>
    80003012:	020d1d93          	slli	s11,s10,0x20
    80003016:	020ddd93          	srli	s11,s11,0x20
    8000301a:	05848513          	addi	a0,s1,88
    8000301e:	86ee                	mv	a3,s11
    80003020:	8652                	mv	a2,s4
    80003022:	85de                	mv	a1,s7
    80003024:	953a                	add	a0,a0,a4
    80003026:	fffff097          	auipc	ra,0xfffff
    8000302a:	982080e7          	jalr	-1662(ra) # 800019a8 <either_copyin>
    8000302e:	07850263          	beq	a0,s8,80003092 <writei+0xcc>
        {
            brelse(bp);
            break;
        }
        log_write(bp);
    80003032:	8526                	mv	a0,s1
    80003034:	00000097          	auipc	ra,0x0
    80003038:	780080e7          	jalr	1920(ra) # 800037b4 <log_write>
        brelse(bp);
    8000303c:	8526                	mv	a0,s1
    8000303e:	fffff097          	auipc	ra,0xfffff
    80003042:	4f2080e7          	jalr	1266(ra) # 80002530 <brelse>
    for (tot = 0; tot < n; tot += m, off += m, src += m)
    80003046:	013d09bb          	addw	s3,s10,s3
    8000304a:	012d093b          	addw	s2,s10,s2
    8000304e:	9a6e                	add	s4,s4,s11
    80003050:	0569f663          	bgeu	s3,s6,8000309c <writei+0xd6>
        uint addr = bmap(ip, off / BSIZE);
    80003054:	00a9559b          	srliw	a1,s2,0xa
    80003058:	8556                	mv	a0,s5
    8000305a:	fffff097          	auipc	ra,0xfffff
    8000305e:	7a0080e7          	jalr	1952(ra) # 800027fa <bmap>
    80003062:	0005059b          	sext.w	a1,a0
        if (addr == 0)
    80003066:	c99d                	beqz	a1,8000309c <writei+0xd6>
        bp = bread(ip->dev, addr);
    80003068:	000aa503          	lw	a0,0(s5)
    8000306c:	fffff097          	auipc	ra,0xfffff
    80003070:	394080e7          	jalr	916(ra) # 80002400 <bread>
    80003074:	84aa                	mv	s1,a0
        m = min(n - tot, BSIZE - off % BSIZE);
    80003076:	3ff97713          	andi	a4,s2,1023
    8000307a:	40ec87bb          	subw	a5,s9,a4
    8000307e:	413b06bb          	subw	a3,s6,s3
    80003082:	8d3e                	mv	s10,a5
    80003084:	2781                	sext.w	a5,a5
    80003086:	0006861b          	sext.w	a2,a3
    8000308a:	f8f674e3          	bgeu	a2,a5,80003012 <writei+0x4c>
    8000308e:	8d36                	mv	s10,a3
    80003090:	b749                	j	80003012 <writei+0x4c>
            brelse(bp);
    80003092:	8526                	mv	a0,s1
    80003094:	fffff097          	auipc	ra,0xfffff
    80003098:	49c080e7          	jalr	1180(ra) # 80002530 <brelse>
    }

    if (off > ip->size)
    8000309c:	04caa783          	lw	a5,76(s5)
    800030a0:	0127f463          	bgeu	a5,s2,800030a8 <writei+0xe2>
        ip->size = off;
    800030a4:	052aa623          	sw	s2,76(s5)

    // write the i-node back to disk even if the size didn't change
    // because the loop above might have called bmap() and added a new
    // block to ip->addrs[].
    iupdate(ip);
    800030a8:	8556                	mv	a0,s5
    800030aa:	00000097          	auipc	ra,0x0
    800030ae:	aa6080e7          	jalr	-1370(ra) # 80002b50 <iupdate>

    return tot;
    800030b2:	0009851b          	sext.w	a0,s3
}
    800030b6:	70a6                	ld	ra,104(sp)
    800030b8:	7406                	ld	s0,96(sp)
    800030ba:	64e6                	ld	s1,88(sp)
    800030bc:	6946                	ld	s2,80(sp)
    800030be:	69a6                	ld	s3,72(sp)
    800030c0:	6a06                	ld	s4,64(sp)
    800030c2:	7ae2                	ld	s5,56(sp)
    800030c4:	7b42                	ld	s6,48(sp)
    800030c6:	7ba2                	ld	s7,40(sp)
    800030c8:	7c02                	ld	s8,32(sp)
    800030ca:	6ce2                	ld	s9,24(sp)
    800030cc:	6d42                	ld	s10,16(sp)
    800030ce:	6da2                	ld	s11,8(sp)
    800030d0:	6165                	addi	sp,sp,112
    800030d2:	8082                	ret
    for (tot = 0; tot < n; tot += m, off += m, src += m)
    800030d4:	89da                	mv	s3,s6
    800030d6:	bfc9                	j	800030a8 <writei+0xe2>
        return -1;
    800030d8:	557d                	li	a0,-1
}
    800030da:	8082                	ret
        return -1;
    800030dc:	557d                	li	a0,-1
    800030de:	bfe1                	j	800030b6 <writei+0xf0>
        return -1;
    800030e0:	557d                	li	a0,-1
    800030e2:	bfd1                	j	800030b6 <writei+0xf0>

00000000800030e4 <namecmp>:

// Directories

int namecmp(const char *s, const char *t)
{
    800030e4:	1141                	addi	sp,sp,-16
    800030e6:	e406                	sd	ra,8(sp)
    800030e8:	e022                	sd	s0,0(sp)
    800030ea:	0800                	addi	s0,sp,16
    return strncmp(s, t, DIRSIZ);
    800030ec:	4639                	li	a2,14
    800030ee:	ffffd097          	auipc	ra,0xffffd
    800030f2:	162080e7          	jalr	354(ra) # 80000250 <strncmp>
}
    800030f6:	60a2                	ld	ra,8(sp)
    800030f8:	6402                	ld	s0,0(sp)
    800030fa:	0141                	addi	sp,sp,16
    800030fc:	8082                	ret

00000000800030fe <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode *
dirlookup(struct inode *dp, char *name, uint *poff)
{
    800030fe:	7139                	addi	sp,sp,-64
    80003100:	fc06                	sd	ra,56(sp)
    80003102:	f822                	sd	s0,48(sp)
    80003104:	f426                	sd	s1,40(sp)
    80003106:	f04a                	sd	s2,32(sp)
    80003108:	ec4e                	sd	s3,24(sp)
    8000310a:	e852                	sd	s4,16(sp)
    8000310c:	0080                	addi	s0,sp,64
    uint off, inum;
    struct dirent de;

    if (dp->type != T_DIR)
    8000310e:	04451703          	lh	a4,68(a0)
    80003112:	4785                	li	a5,1
    80003114:	00f71a63          	bne	a4,a5,80003128 <dirlookup+0x2a>
    80003118:	892a                	mv	s2,a0
    8000311a:	89ae                	mv	s3,a1
    8000311c:	8a32                	mv	s4,a2
        panic("dirlookup not DIR");

    for (off = 0; off < dp->size; off += sizeof(de))
    8000311e:	457c                	lw	a5,76(a0)
    80003120:	4481                	li	s1,0
            inum = de.inum;
            return iget(dp->dev, inum);
        }
    }

    return 0;
    80003122:	4501                	li	a0,0
    for (off = 0; off < dp->size; off += sizeof(de))
    80003124:	e79d                	bnez	a5,80003152 <dirlookup+0x54>
    80003126:	a8a5                	j	8000319e <dirlookup+0xa0>
        panic("dirlookup not DIR");
    80003128:	00005517          	auipc	a0,0x5
    8000312c:	44850513          	addi	a0,a0,1096 # 80008570 <syscalls+0x1b0>
    80003130:	00003097          	auipc	ra,0x3
    80003134:	e82080e7          	jalr	-382(ra) # 80005fb2 <panic>
            panic("dirlookup read");
    80003138:	00005517          	auipc	a0,0x5
    8000313c:	45050513          	addi	a0,a0,1104 # 80008588 <syscalls+0x1c8>
    80003140:	00003097          	auipc	ra,0x3
    80003144:	e72080e7          	jalr	-398(ra) # 80005fb2 <panic>
    for (off = 0; off < dp->size; off += sizeof(de))
    80003148:	24c1                	addiw	s1,s1,16
    8000314a:	04c92783          	lw	a5,76(s2)
    8000314e:	04f4f763          	bgeu	s1,a5,8000319c <dirlookup+0x9e>
        if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003152:	4741                	li	a4,16
    80003154:	86a6                	mv	a3,s1
    80003156:	fc040613          	addi	a2,s0,-64
    8000315a:	4581                	li	a1,0
    8000315c:	854a                	mv	a0,s2
    8000315e:	00000097          	auipc	ra,0x0
    80003162:	d70080e7          	jalr	-656(ra) # 80002ece <readi>
    80003166:	47c1                	li	a5,16
    80003168:	fcf518e3          	bne	a0,a5,80003138 <dirlookup+0x3a>
        if (de.inum == 0)
    8000316c:	fc045783          	lhu	a5,-64(s0)
    80003170:	dfe1                	beqz	a5,80003148 <dirlookup+0x4a>
        if (namecmp(name, de.name) == 0)
    80003172:	fc240593          	addi	a1,s0,-62
    80003176:	854e                	mv	a0,s3
    80003178:	00000097          	auipc	ra,0x0
    8000317c:	f6c080e7          	jalr	-148(ra) # 800030e4 <namecmp>
    80003180:	f561                	bnez	a0,80003148 <dirlookup+0x4a>
            if (poff)
    80003182:	000a0463          	beqz	s4,8000318a <dirlookup+0x8c>
                *poff = off;
    80003186:	009a2023          	sw	s1,0(s4)
            return iget(dp->dev, inum);
    8000318a:	fc045583          	lhu	a1,-64(s0)
    8000318e:	00092503          	lw	a0,0(s2)
    80003192:	fffff097          	auipc	ra,0xfffff
    80003196:	750080e7          	jalr	1872(ra) # 800028e2 <iget>
    8000319a:	a011                	j	8000319e <dirlookup+0xa0>
    return 0;
    8000319c:	4501                	li	a0,0
}
    8000319e:	70e2                	ld	ra,56(sp)
    800031a0:	7442                	ld	s0,48(sp)
    800031a2:	74a2                	ld	s1,40(sp)
    800031a4:	7902                	ld	s2,32(sp)
    800031a6:	69e2                	ld	s3,24(sp)
    800031a8:	6a42                	ld	s4,16(sp)
    800031aa:	6121                	addi	sp,sp,64
    800031ac:	8082                	ret

00000000800031ae <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode *
namex(char *path, int nameiparent, char *name)
{
    800031ae:	711d                	addi	sp,sp,-96
    800031b0:	ec86                	sd	ra,88(sp)
    800031b2:	e8a2                	sd	s0,80(sp)
    800031b4:	e4a6                	sd	s1,72(sp)
    800031b6:	e0ca                	sd	s2,64(sp)
    800031b8:	fc4e                	sd	s3,56(sp)
    800031ba:	f852                	sd	s4,48(sp)
    800031bc:	f456                	sd	s5,40(sp)
    800031be:	f05a                	sd	s6,32(sp)
    800031c0:	ec5e                	sd	s7,24(sp)
    800031c2:	e862                	sd	s8,16(sp)
    800031c4:	e466                	sd	s9,8(sp)
    800031c6:	1080                	addi	s0,sp,96
    800031c8:	84aa                	mv	s1,a0
    800031ca:	8b2e                	mv	s6,a1
    800031cc:	8ab2                	mv	s5,a2
    struct inode *ip, *next;

    if (*path == '/')
    800031ce:	00054703          	lbu	a4,0(a0)
    800031d2:	02f00793          	li	a5,47
    800031d6:	02f70363          	beq	a4,a5,800031fc <namex+0x4e>
        ip = iget(ROOTDEV, ROOTINO);
    else
        ip = idup(myproc()->cwd);
    800031da:	ffffe097          	auipc	ra,0xffffe
    800031de:	c64080e7          	jalr	-924(ra) # 80000e3e <myproc>
    800031e2:	15053503          	ld	a0,336(a0)
    800031e6:	00000097          	auipc	ra,0x0
    800031ea:	9f6080e7          	jalr	-1546(ra) # 80002bdc <idup>
    800031ee:	89aa                	mv	s3,a0
    while (*path == '/')
    800031f0:	02f00913          	li	s2,47
    len = path - s;
    800031f4:	4b81                	li	s7,0
    if (len >= DIRSIZ)
    800031f6:	4cb5                	li	s9,13

    while ((path = skipelem(path, name)) != 0)
    {
        ilock(ip);
        if (ip->type != T_DIR)
    800031f8:	4c05                	li	s8,1
    800031fa:	a865                	j	800032b2 <namex+0x104>
        ip = iget(ROOTDEV, ROOTINO);
    800031fc:	4585                	li	a1,1
    800031fe:	4505                	li	a0,1
    80003200:	fffff097          	auipc	ra,0xfffff
    80003204:	6e2080e7          	jalr	1762(ra) # 800028e2 <iget>
    80003208:	89aa                	mv	s3,a0
    8000320a:	b7dd                	j	800031f0 <namex+0x42>
        {
            iunlockput(ip);
    8000320c:	854e                	mv	a0,s3
    8000320e:	00000097          	auipc	ra,0x0
    80003212:	c6e080e7          	jalr	-914(ra) # 80002e7c <iunlockput>
            return 0;
    80003216:	4981                	li	s3,0
    {
        iput(ip);
        return 0;
    }
    return ip;
}
    80003218:	854e                	mv	a0,s3
    8000321a:	60e6                	ld	ra,88(sp)
    8000321c:	6446                	ld	s0,80(sp)
    8000321e:	64a6                	ld	s1,72(sp)
    80003220:	6906                	ld	s2,64(sp)
    80003222:	79e2                	ld	s3,56(sp)
    80003224:	7a42                	ld	s4,48(sp)
    80003226:	7aa2                	ld	s5,40(sp)
    80003228:	7b02                	ld	s6,32(sp)
    8000322a:	6be2                	ld	s7,24(sp)
    8000322c:	6c42                	ld	s8,16(sp)
    8000322e:	6ca2                	ld	s9,8(sp)
    80003230:	6125                	addi	sp,sp,96
    80003232:	8082                	ret
            iunlock(ip);
    80003234:	854e                	mv	a0,s3
    80003236:	00000097          	auipc	ra,0x0
    8000323a:	aa6080e7          	jalr	-1370(ra) # 80002cdc <iunlock>
            return ip;
    8000323e:	bfe9                	j	80003218 <namex+0x6a>
            iunlockput(ip);
    80003240:	854e                	mv	a0,s3
    80003242:	00000097          	auipc	ra,0x0
    80003246:	c3a080e7          	jalr	-966(ra) # 80002e7c <iunlockput>
            return 0;
    8000324a:	89d2                	mv	s3,s4
    8000324c:	b7f1                	j	80003218 <namex+0x6a>
    len = path - s;
    8000324e:	40b48633          	sub	a2,s1,a1
    80003252:	00060a1b          	sext.w	s4,a2
    if (len >= DIRSIZ)
    80003256:	094cd463          	bge	s9,s4,800032de <namex+0x130>
        memmove(name, s, DIRSIZ);
    8000325a:	4639                	li	a2,14
    8000325c:	8556                	mv	a0,s5
    8000325e:	ffffd097          	auipc	ra,0xffffd
    80003262:	f7a080e7          	jalr	-134(ra) # 800001d8 <memmove>
    while (*path == '/')
    80003266:	0004c783          	lbu	a5,0(s1)
    8000326a:	01279763          	bne	a5,s2,80003278 <namex+0xca>
        path++;
    8000326e:	0485                	addi	s1,s1,1
    while (*path == '/')
    80003270:	0004c783          	lbu	a5,0(s1)
    80003274:	ff278de3          	beq	a5,s2,8000326e <namex+0xc0>
        ilock(ip);
    80003278:	854e                	mv	a0,s3
    8000327a:	00000097          	auipc	ra,0x0
    8000327e:	9a0080e7          	jalr	-1632(ra) # 80002c1a <ilock>
        if (ip->type != T_DIR)
    80003282:	04499783          	lh	a5,68(s3)
    80003286:	f98793e3          	bne	a5,s8,8000320c <namex+0x5e>
        if (nameiparent && *path == '\0')
    8000328a:	000b0563          	beqz	s6,80003294 <namex+0xe6>
    8000328e:	0004c783          	lbu	a5,0(s1)
    80003292:	d3cd                	beqz	a5,80003234 <namex+0x86>
        if ((next = dirlookup(ip, name, 0)) == 0)
    80003294:	865e                	mv	a2,s7
    80003296:	85d6                	mv	a1,s5
    80003298:	854e                	mv	a0,s3
    8000329a:	00000097          	auipc	ra,0x0
    8000329e:	e64080e7          	jalr	-412(ra) # 800030fe <dirlookup>
    800032a2:	8a2a                	mv	s4,a0
    800032a4:	dd51                	beqz	a0,80003240 <namex+0x92>
        iunlockput(ip);
    800032a6:	854e                	mv	a0,s3
    800032a8:	00000097          	auipc	ra,0x0
    800032ac:	bd4080e7          	jalr	-1068(ra) # 80002e7c <iunlockput>
        ip = next;
    800032b0:	89d2                	mv	s3,s4
    while (*path == '/')
    800032b2:	0004c783          	lbu	a5,0(s1)
    800032b6:	05279763          	bne	a5,s2,80003304 <namex+0x156>
        path++;
    800032ba:	0485                	addi	s1,s1,1
    while (*path == '/')
    800032bc:	0004c783          	lbu	a5,0(s1)
    800032c0:	ff278de3          	beq	a5,s2,800032ba <namex+0x10c>
    if (*path == 0)
    800032c4:	c79d                	beqz	a5,800032f2 <namex+0x144>
        path++;
    800032c6:	85a6                	mv	a1,s1
    len = path - s;
    800032c8:	8a5e                	mv	s4,s7
    800032ca:	865e                	mv	a2,s7
    while (*path != '/' && *path != 0)
    800032cc:	01278963          	beq	a5,s2,800032de <namex+0x130>
    800032d0:	dfbd                	beqz	a5,8000324e <namex+0xa0>
        path++;
    800032d2:	0485                	addi	s1,s1,1
    while (*path != '/' && *path != 0)
    800032d4:	0004c783          	lbu	a5,0(s1)
    800032d8:	ff279ce3          	bne	a5,s2,800032d0 <namex+0x122>
    800032dc:	bf8d                	j	8000324e <namex+0xa0>
        memmove(name, s, len);
    800032de:	2601                	sext.w	a2,a2
    800032e0:	8556                	mv	a0,s5
    800032e2:	ffffd097          	auipc	ra,0xffffd
    800032e6:	ef6080e7          	jalr	-266(ra) # 800001d8 <memmove>
        name[len] = 0;
    800032ea:	9a56                	add	s4,s4,s5
    800032ec:	000a0023          	sb	zero,0(s4)
    800032f0:	bf9d                	j	80003266 <namex+0xb8>
    if (nameiparent)
    800032f2:	f20b03e3          	beqz	s6,80003218 <namex+0x6a>
        iput(ip);
    800032f6:	854e                	mv	a0,s3
    800032f8:	00000097          	auipc	ra,0x0
    800032fc:	adc080e7          	jalr	-1316(ra) # 80002dd4 <iput>
        return 0;
    80003300:	4981                	li	s3,0
    80003302:	bf19                	j	80003218 <namex+0x6a>
    if (*path == 0)
    80003304:	d7fd                	beqz	a5,800032f2 <namex+0x144>
    while (*path != '/' && *path != 0)
    80003306:	0004c783          	lbu	a5,0(s1)
    8000330a:	85a6                	mv	a1,s1
    8000330c:	b7d1                	j	800032d0 <namex+0x122>

000000008000330e <dirlink>:
{
    8000330e:	7139                	addi	sp,sp,-64
    80003310:	fc06                	sd	ra,56(sp)
    80003312:	f822                	sd	s0,48(sp)
    80003314:	f426                	sd	s1,40(sp)
    80003316:	f04a                	sd	s2,32(sp)
    80003318:	ec4e                	sd	s3,24(sp)
    8000331a:	e852                	sd	s4,16(sp)
    8000331c:	0080                	addi	s0,sp,64
    8000331e:	892a                	mv	s2,a0
    80003320:	8a2e                	mv	s4,a1
    80003322:	89b2                	mv	s3,a2
    if ((ip = dirlookup(dp, name, 0)) != 0)
    80003324:	4601                	li	a2,0
    80003326:	00000097          	auipc	ra,0x0
    8000332a:	dd8080e7          	jalr	-552(ra) # 800030fe <dirlookup>
    8000332e:	e93d                	bnez	a0,800033a4 <dirlink+0x96>
    for (off = 0; off < dp->size; off += sizeof(de))
    80003330:	04c92483          	lw	s1,76(s2)
    80003334:	c49d                	beqz	s1,80003362 <dirlink+0x54>
    80003336:	4481                	li	s1,0
        if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003338:	4741                	li	a4,16
    8000333a:	86a6                	mv	a3,s1
    8000333c:	fc040613          	addi	a2,s0,-64
    80003340:	4581                	li	a1,0
    80003342:	854a                	mv	a0,s2
    80003344:	00000097          	auipc	ra,0x0
    80003348:	b8a080e7          	jalr	-1142(ra) # 80002ece <readi>
    8000334c:	47c1                	li	a5,16
    8000334e:	06f51163          	bne	a0,a5,800033b0 <dirlink+0xa2>
        if (de.inum == 0)
    80003352:	fc045783          	lhu	a5,-64(s0)
    80003356:	c791                	beqz	a5,80003362 <dirlink+0x54>
    for (off = 0; off < dp->size; off += sizeof(de))
    80003358:	24c1                	addiw	s1,s1,16
    8000335a:	04c92783          	lw	a5,76(s2)
    8000335e:	fcf4ede3          	bltu	s1,a5,80003338 <dirlink+0x2a>
    strncpy(de.name, name, DIRSIZ);
    80003362:	4639                	li	a2,14
    80003364:	85d2                	mv	a1,s4
    80003366:	fc240513          	addi	a0,s0,-62
    8000336a:	ffffd097          	auipc	ra,0xffffd
    8000336e:	f22080e7          	jalr	-222(ra) # 8000028c <strncpy>
    de.inum = inum;
    80003372:	fd341023          	sh	s3,-64(s0)
    if (writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003376:	4741                	li	a4,16
    80003378:	86a6                	mv	a3,s1
    8000337a:	fc040613          	addi	a2,s0,-64
    8000337e:	4581                	li	a1,0
    80003380:	854a                	mv	a0,s2
    80003382:	00000097          	auipc	ra,0x0
    80003386:	c44080e7          	jalr	-956(ra) # 80002fc6 <writei>
    8000338a:	1541                	addi	a0,a0,-16
    8000338c:	00a03533          	snez	a0,a0
    80003390:	40a00533          	neg	a0,a0
}
    80003394:	70e2                	ld	ra,56(sp)
    80003396:	7442                	ld	s0,48(sp)
    80003398:	74a2                	ld	s1,40(sp)
    8000339a:	7902                	ld	s2,32(sp)
    8000339c:	69e2                	ld	s3,24(sp)
    8000339e:	6a42                	ld	s4,16(sp)
    800033a0:	6121                	addi	sp,sp,64
    800033a2:	8082                	ret
        iput(ip);
    800033a4:	00000097          	auipc	ra,0x0
    800033a8:	a30080e7          	jalr	-1488(ra) # 80002dd4 <iput>
        return -1;
    800033ac:	557d                	li	a0,-1
    800033ae:	b7dd                	j	80003394 <dirlink+0x86>
            panic("dirlink read");
    800033b0:	00005517          	auipc	a0,0x5
    800033b4:	1e850513          	addi	a0,a0,488 # 80008598 <syscalls+0x1d8>
    800033b8:	00003097          	auipc	ra,0x3
    800033bc:	bfa080e7          	jalr	-1030(ra) # 80005fb2 <panic>

00000000800033c0 <namei>:

struct inode *
namei(char *path)
{
    800033c0:	1101                	addi	sp,sp,-32
    800033c2:	ec06                	sd	ra,24(sp)
    800033c4:	e822                	sd	s0,16(sp)
    800033c6:	1000                	addi	s0,sp,32
    char name[DIRSIZ];
    return namex(path, 0, name);
    800033c8:	fe040613          	addi	a2,s0,-32
    800033cc:	4581                	li	a1,0
    800033ce:	00000097          	auipc	ra,0x0
    800033d2:	de0080e7          	jalr	-544(ra) # 800031ae <namex>
}
    800033d6:	60e2                	ld	ra,24(sp)
    800033d8:	6442                	ld	s0,16(sp)
    800033da:	6105                	addi	sp,sp,32
    800033dc:	8082                	ret

00000000800033de <nameiparent>:

struct inode *
nameiparent(char *path, char *name)
{
    800033de:	1141                	addi	sp,sp,-16
    800033e0:	e406                	sd	ra,8(sp)
    800033e2:	e022                	sd	s0,0(sp)
    800033e4:	0800                	addi	s0,sp,16
    800033e6:	862e                	mv	a2,a1
    return namex(path, 1, name);
    800033e8:	4585                	li	a1,1
    800033ea:	00000097          	auipc	ra,0x0
    800033ee:	dc4080e7          	jalr	-572(ra) # 800031ae <namex>
}
    800033f2:	60a2                	ld	ra,8(sp)
    800033f4:	6402                	ld	s0,0(sp)
    800033f6:	0141                	addi	sp,sp,16
    800033f8:	8082                	ret

00000000800033fa <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    800033fa:	1101                	addi	sp,sp,-32
    800033fc:	ec06                	sd	ra,24(sp)
    800033fe:	e822                	sd	s0,16(sp)
    80003400:	e426                	sd	s1,8(sp)
    80003402:	e04a                	sd	s2,0(sp)
    80003404:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    80003406:	00027917          	auipc	s2,0x27
    8000340a:	4ea90913          	addi	s2,s2,1258 # 8002a8f0 <log>
    8000340e:	01892583          	lw	a1,24(s2)
    80003412:	02892503          	lw	a0,40(s2)
    80003416:	fffff097          	auipc	ra,0xfffff
    8000341a:	fea080e7          	jalr	-22(ra) # 80002400 <bread>
    8000341e:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003420:	02c92683          	lw	a3,44(s2)
    80003424:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    80003426:	02d05763          	blez	a3,80003454 <write_head+0x5a>
    8000342a:	00027797          	auipc	a5,0x27
    8000342e:	4f678793          	addi	a5,a5,1270 # 8002a920 <log+0x30>
    80003432:	05c50713          	addi	a4,a0,92
    80003436:	36fd                	addiw	a3,a3,-1
    80003438:	1682                	slli	a3,a3,0x20
    8000343a:	9281                	srli	a3,a3,0x20
    8000343c:	068a                	slli	a3,a3,0x2
    8000343e:	00027617          	auipc	a2,0x27
    80003442:	4e660613          	addi	a2,a2,1254 # 8002a924 <log+0x34>
    80003446:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    80003448:	4390                	lw	a2,0(a5)
    8000344a:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    8000344c:	0791                	addi	a5,a5,4
    8000344e:	0711                	addi	a4,a4,4
    80003450:	fed79ce3          	bne	a5,a3,80003448 <write_head+0x4e>
  }
  bwrite(buf);
    80003454:	8526                	mv	a0,s1
    80003456:	fffff097          	auipc	ra,0xfffff
    8000345a:	09c080e7          	jalr	156(ra) # 800024f2 <bwrite>
  brelse(buf);
    8000345e:	8526                	mv	a0,s1
    80003460:	fffff097          	auipc	ra,0xfffff
    80003464:	0d0080e7          	jalr	208(ra) # 80002530 <brelse>
}
    80003468:	60e2                	ld	ra,24(sp)
    8000346a:	6442                	ld	s0,16(sp)
    8000346c:	64a2                	ld	s1,8(sp)
    8000346e:	6902                	ld	s2,0(sp)
    80003470:	6105                	addi	sp,sp,32
    80003472:	8082                	ret

0000000080003474 <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    80003474:	00027797          	auipc	a5,0x27
    80003478:	4a87a783          	lw	a5,1192(a5) # 8002a91c <log+0x2c>
    8000347c:	0af05d63          	blez	a5,80003536 <install_trans+0xc2>
{
    80003480:	7139                	addi	sp,sp,-64
    80003482:	fc06                	sd	ra,56(sp)
    80003484:	f822                	sd	s0,48(sp)
    80003486:	f426                	sd	s1,40(sp)
    80003488:	f04a                	sd	s2,32(sp)
    8000348a:	ec4e                	sd	s3,24(sp)
    8000348c:	e852                	sd	s4,16(sp)
    8000348e:	e456                	sd	s5,8(sp)
    80003490:	e05a                	sd	s6,0(sp)
    80003492:	0080                	addi	s0,sp,64
    80003494:	8b2a                	mv	s6,a0
    80003496:	00027a97          	auipc	s5,0x27
    8000349a:	48aa8a93          	addi	s5,s5,1162 # 8002a920 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    8000349e:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800034a0:	00027997          	auipc	s3,0x27
    800034a4:	45098993          	addi	s3,s3,1104 # 8002a8f0 <log>
    800034a8:	a035                	j	800034d4 <install_trans+0x60>
      bunpin(dbuf);
    800034aa:	8526                	mv	a0,s1
    800034ac:	fffff097          	auipc	ra,0xfffff
    800034b0:	15e080e7          	jalr	350(ra) # 8000260a <bunpin>
    brelse(lbuf);
    800034b4:	854a                	mv	a0,s2
    800034b6:	fffff097          	auipc	ra,0xfffff
    800034ba:	07a080e7          	jalr	122(ra) # 80002530 <brelse>
    brelse(dbuf);
    800034be:	8526                	mv	a0,s1
    800034c0:	fffff097          	auipc	ra,0xfffff
    800034c4:	070080e7          	jalr	112(ra) # 80002530 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800034c8:	2a05                	addiw	s4,s4,1
    800034ca:	0a91                	addi	s5,s5,4
    800034cc:	02c9a783          	lw	a5,44(s3)
    800034d0:	04fa5963          	bge	s4,a5,80003522 <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800034d4:	0189a583          	lw	a1,24(s3)
    800034d8:	014585bb          	addw	a1,a1,s4
    800034dc:	2585                	addiw	a1,a1,1
    800034de:	0289a503          	lw	a0,40(s3)
    800034e2:	fffff097          	auipc	ra,0xfffff
    800034e6:	f1e080e7          	jalr	-226(ra) # 80002400 <bread>
    800034ea:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    800034ec:	000aa583          	lw	a1,0(s5)
    800034f0:	0289a503          	lw	a0,40(s3)
    800034f4:	fffff097          	auipc	ra,0xfffff
    800034f8:	f0c080e7          	jalr	-244(ra) # 80002400 <bread>
    800034fc:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    800034fe:	40000613          	li	a2,1024
    80003502:	05890593          	addi	a1,s2,88
    80003506:	05850513          	addi	a0,a0,88
    8000350a:	ffffd097          	auipc	ra,0xffffd
    8000350e:	cce080e7          	jalr	-818(ra) # 800001d8 <memmove>
    bwrite(dbuf);  // write dst to disk
    80003512:	8526                	mv	a0,s1
    80003514:	fffff097          	auipc	ra,0xfffff
    80003518:	fde080e7          	jalr	-34(ra) # 800024f2 <bwrite>
    if(recovering == 0)
    8000351c:	f80b1ce3          	bnez	s6,800034b4 <install_trans+0x40>
    80003520:	b769                	j	800034aa <install_trans+0x36>
}
    80003522:	70e2                	ld	ra,56(sp)
    80003524:	7442                	ld	s0,48(sp)
    80003526:	74a2                	ld	s1,40(sp)
    80003528:	7902                	ld	s2,32(sp)
    8000352a:	69e2                	ld	s3,24(sp)
    8000352c:	6a42                	ld	s4,16(sp)
    8000352e:	6aa2                	ld	s5,8(sp)
    80003530:	6b02                	ld	s6,0(sp)
    80003532:	6121                	addi	sp,sp,64
    80003534:	8082                	ret
    80003536:	8082                	ret

0000000080003538 <initlog>:
{
    80003538:	7179                	addi	sp,sp,-48
    8000353a:	f406                	sd	ra,40(sp)
    8000353c:	f022                	sd	s0,32(sp)
    8000353e:	ec26                	sd	s1,24(sp)
    80003540:	e84a                	sd	s2,16(sp)
    80003542:	e44e                	sd	s3,8(sp)
    80003544:	1800                	addi	s0,sp,48
    80003546:	892a                	mv	s2,a0
    80003548:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    8000354a:	00027497          	auipc	s1,0x27
    8000354e:	3a648493          	addi	s1,s1,934 # 8002a8f0 <log>
    80003552:	00005597          	auipc	a1,0x5
    80003556:	05658593          	addi	a1,a1,86 # 800085a8 <syscalls+0x1e8>
    8000355a:	8526                	mv	a0,s1
    8000355c:	00003097          	auipc	ra,0x3
    80003560:	f10080e7          	jalr	-240(ra) # 8000646c <initlock>
  log.start = sb->logstart;
    80003564:	0149a583          	lw	a1,20(s3)
    80003568:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    8000356a:	0109a783          	lw	a5,16(s3)
    8000356e:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    80003570:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    80003574:	854a                	mv	a0,s2
    80003576:	fffff097          	auipc	ra,0xfffff
    8000357a:	e8a080e7          	jalr	-374(ra) # 80002400 <bread>
  log.lh.n = lh->n;
    8000357e:	4d3c                	lw	a5,88(a0)
    80003580:	d4dc                	sw	a5,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    80003582:	02f05563          	blez	a5,800035ac <initlog+0x74>
    80003586:	05c50713          	addi	a4,a0,92
    8000358a:	00027697          	auipc	a3,0x27
    8000358e:	39668693          	addi	a3,a3,918 # 8002a920 <log+0x30>
    80003592:	37fd                	addiw	a5,a5,-1
    80003594:	1782                	slli	a5,a5,0x20
    80003596:	9381                	srli	a5,a5,0x20
    80003598:	078a                	slli	a5,a5,0x2
    8000359a:	06050613          	addi	a2,a0,96
    8000359e:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    800035a0:	4310                	lw	a2,0(a4)
    800035a2:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    800035a4:	0711                	addi	a4,a4,4
    800035a6:	0691                	addi	a3,a3,4
    800035a8:	fef71ce3          	bne	a4,a5,800035a0 <initlog+0x68>
  brelse(buf);
    800035ac:	fffff097          	auipc	ra,0xfffff
    800035b0:	f84080e7          	jalr	-124(ra) # 80002530 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    800035b4:	4505                	li	a0,1
    800035b6:	00000097          	auipc	ra,0x0
    800035ba:	ebe080e7          	jalr	-322(ra) # 80003474 <install_trans>
  log.lh.n = 0;
    800035be:	00027797          	auipc	a5,0x27
    800035c2:	3407af23          	sw	zero,862(a5) # 8002a91c <log+0x2c>
  write_head(); // clear the log
    800035c6:	00000097          	auipc	ra,0x0
    800035ca:	e34080e7          	jalr	-460(ra) # 800033fa <write_head>
}
    800035ce:	70a2                	ld	ra,40(sp)
    800035d0:	7402                	ld	s0,32(sp)
    800035d2:	64e2                	ld	s1,24(sp)
    800035d4:	6942                	ld	s2,16(sp)
    800035d6:	69a2                	ld	s3,8(sp)
    800035d8:	6145                	addi	sp,sp,48
    800035da:	8082                	ret

00000000800035dc <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    800035dc:	1101                	addi	sp,sp,-32
    800035de:	ec06                	sd	ra,24(sp)
    800035e0:	e822                	sd	s0,16(sp)
    800035e2:	e426                	sd	s1,8(sp)
    800035e4:	e04a                	sd	s2,0(sp)
    800035e6:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    800035e8:	00027517          	auipc	a0,0x27
    800035ec:	30850513          	addi	a0,a0,776 # 8002a8f0 <log>
    800035f0:	00003097          	auipc	ra,0x3
    800035f4:	f0c080e7          	jalr	-244(ra) # 800064fc <acquire>
  while(1){
    if(log.committing){
    800035f8:	00027497          	auipc	s1,0x27
    800035fc:	2f848493          	addi	s1,s1,760 # 8002a8f0 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003600:	4979                	li	s2,30
    80003602:	a039                	j	80003610 <begin_op+0x34>
      sleep(&log, &log.lock);
    80003604:	85a6                	mv	a1,s1
    80003606:	8526                	mv	a0,s1
    80003608:	ffffe097          	auipc	ra,0xffffe
    8000360c:	f42080e7          	jalr	-190(ra) # 8000154a <sleep>
    if(log.committing){
    80003610:	50dc                	lw	a5,36(s1)
    80003612:	fbed                	bnez	a5,80003604 <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003614:	509c                	lw	a5,32(s1)
    80003616:	0017871b          	addiw	a4,a5,1
    8000361a:	0007069b          	sext.w	a3,a4
    8000361e:	0027179b          	slliw	a5,a4,0x2
    80003622:	9fb9                	addw	a5,a5,a4
    80003624:	0017979b          	slliw	a5,a5,0x1
    80003628:	54d8                	lw	a4,44(s1)
    8000362a:	9fb9                	addw	a5,a5,a4
    8000362c:	00f95963          	bge	s2,a5,8000363e <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003630:	85a6                	mv	a1,s1
    80003632:	8526                	mv	a0,s1
    80003634:	ffffe097          	auipc	ra,0xffffe
    80003638:	f16080e7          	jalr	-234(ra) # 8000154a <sleep>
    8000363c:	bfd1                	j	80003610 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    8000363e:	00027517          	auipc	a0,0x27
    80003642:	2b250513          	addi	a0,a0,690 # 8002a8f0 <log>
    80003646:	d114                	sw	a3,32(a0)
      release(&log.lock);
    80003648:	00003097          	auipc	ra,0x3
    8000364c:	f68080e7          	jalr	-152(ra) # 800065b0 <release>
      break;
    }
  }
}
    80003650:	60e2                	ld	ra,24(sp)
    80003652:	6442                	ld	s0,16(sp)
    80003654:	64a2                	ld	s1,8(sp)
    80003656:	6902                	ld	s2,0(sp)
    80003658:	6105                	addi	sp,sp,32
    8000365a:	8082                	ret

000000008000365c <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    8000365c:	7139                	addi	sp,sp,-64
    8000365e:	fc06                	sd	ra,56(sp)
    80003660:	f822                	sd	s0,48(sp)
    80003662:	f426                	sd	s1,40(sp)
    80003664:	f04a                	sd	s2,32(sp)
    80003666:	ec4e                	sd	s3,24(sp)
    80003668:	e852                	sd	s4,16(sp)
    8000366a:	e456                	sd	s5,8(sp)
    8000366c:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    8000366e:	00027497          	auipc	s1,0x27
    80003672:	28248493          	addi	s1,s1,642 # 8002a8f0 <log>
    80003676:	8526                	mv	a0,s1
    80003678:	00003097          	auipc	ra,0x3
    8000367c:	e84080e7          	jalr	-380(ra) # 800064fc <acquire>
  log.outstanding -= 1;
    80003680:	509c                	lw	a5,32(s1)
    80003682:	37fd                	addiw	a5,a5,-1
    80003684:	0007891b          	sext.w	s2,a5
    80003688:	d09c                	sw	a5,32(s1)
  if(log.committing)
    8000368a:	50dc                	lw	a5,36(s1)
    8000368c:	efb9                	bnez	a5,800036ea <end_op+0x8e>
    panic("log.committing");
  if(log.outstanding == 0){
    8000368e:	06091663          	bnez	s2,800036fa <end_op+0x9e>
    do_commit = 1;
    log.committing = 1;
    80003692:	00027497          	auipc	s1,0x27
    80003696:	25e48493          	addi	s1,s1,606 # 8002a8f0 <log>
    8000369a:	4785                	li	a5,1
    8000369c:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    8000369e:	8526                	mv	a0,s1
    800036a0:	00003097          	auipc	ra,0x3
    800036a4:	f10080e7          	jalr	-240(ra) # 800065b0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    800036a8:	54dc                	lw	a5,44(s1)
    800036aa:	06f04763          	bgtz	a5,80003718 <end_op+0xbc>
    acquire(&log.lock);
    800036ae:	00027497          	auipc	s1,0x27
    800036b2:	24248493          	addi	s1,s1,578 # 8002a8f0 <log>
    800036b6:	8526                	mv	a0,s1
    800036b8:	00003097          	auipc	ra,0x3
    800036bc:	e44080e7          	jalr	-444(ra) # 800064fc <acquire>
    log.committing = 0;
    800036c0:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    800036c4:	8526                	mv	a0,s1
    800036c6:	ffffe097          	auipc	ra,0xffffe
    800036ca:	ee8080e7          	jalr	-280(ra) # 800015ae <wakeup>
    release(&log.lock);
    800036ce:	8526                	mv	a0,s1
    800036d0:	00003097          	auipc	ra,0x3
    800036d4:	ee0080e7          	jalr	-288(ra) # 800065b0 <release>
}
    800036d8:	70e2                	ld	ra,56(sp)
    800036da:	7442                	ld	s0,48(sp)
    800036dc:	74a2                	ld	s1,40(sp)
    800036de:	7902                	ld	s2,32(sp)
    800036e0:	69e2                	ld	s3,24(sp)
    800036e2:	6a42                	ld	s4,16(sp)
    800036e4:	6aa2                	ld	s5,8(sp)
    800036e6:	6121                	addi	sp,sp,64
    800036e8:	8082                	ret
    panic("log.committing");
    800036ea:	00005517          	auipc	a0,0x5
    800036ee:	ec650513          	addi	a0,a0,-314 # 800085b0 <syscalls+0x1f0>
    800036f2:	00003097          	auipc	ra,0x3
    800036f6:	8c0080e7          	jalr	-1856(ra) # 80005fb2 <panic>
    wakeup(&log);
    800036fa:	00027497          	auipc	s1,0x27
    800036fe:	1f648493          	addi	s1,s1,502 # 8002a8f0 <log>
    80003702:	8526                	mv	a0,s1
    80003704:	ffffe097          	auipc	ra,0xffffe
    80003708:	eaa080e7          	jalr	-342(ra) # 800015ae <wakeup>
  release(&log.lock);
    8000370c:	8526                	mv	a0,s1
    8000370e:	00003097          	auipc	ra,0x3
    80003712:	ea2080e7          	jalr	-350(ra) # 800065b0 <release>
  if(do_commit){
    80003716:	b7c9                	j	800036d8 <end_op+0x7c>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003718:	00027a97          	auipc	s5,0x27
    8000371c:	208a8a93          	addi	s5,s5,520 # 8002a920 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003720:	00027a17          	auipc	s4,0x27
    80003724:	1d0a0a13          	addi	s4,s4,464 # 8002a8f0 <log>
    80003728:	018a2583          	lw	a1,24(s4)
    8000372c:	012585bb          	addw	a1,a1,s2
    80003730:	2585                	addiw	a1,a1,1
    80003732:	028a2503          	lw	a0,40(s4)
    80003736:	fffff097          	auipc	ra,0xfffff
    8000373a:	cca080e7          	jalr	-822(ra) # 80002400 <bread>
    8000373e:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003740:	000aa583          	lw	a1,0(s5)
    80003744:	028a2503          	lw	a0,40(s4)
    80003748:	fffff097          	auipc	ra,0xfffff
    8000374c:	cb8080e7          	jalr	-840(ra) # 80002400 <bread>
    80003750:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    80003752:	40000613          	li	a2,1024
    80003756:	05850593          	addi	a1,a0,88
    8000375a:	05848513          	addi	a0,s1,88
    8000375e:	ffffd097          	auipc	ra,0xffffd
    80003762:	a7a080e7          	jalr	-1414(ra) # 800001d8 <memmove>
    bwrite(to);  // write the log
    80003766:	8526                	mv	a0,s1
    80003768:	fffff097          	auipc	ra,0xfffff
    8000376c:	d8a080e7          	jalr	-630(ra) # 800024f2 <bwrite>
    brelse(from);
    80003770:	854e                	mv	a0,s3
    80003772:	fffff097          	auipc	ra,0xfffff
    80003776:	dbe080e7          	jalr	-578(ra) # 80002530 <brelse>
    brelse(to);
    8000377a:	8526                	mv	a0,s1
    8000377c:	fffff097          	auipc	ra,0xfffff
    80003780:	db4080e7          	jalr	-588(ra) # 80002530 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003784:	2905                	addiw	s2,s2,1
    80003786:	0a91                	addi	s5,s5,4
    80003788:	02ca2783          	lw	a5,44(s4)
    8000378c:	f8f94ee3          	blt	s2,a5,80003728 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    80003790:	00000097          	auipc	ra,0x0
    80003794:	c6a080e7          	jalr	-918(ra) # 800033fa <write_head>
    install_trans(0); // Now install writes to home locations
    80003798:	4501                	li	a0,0
    8000379a:	00000097          	auipc	ra,0x0
    8000379e:	cda080e7          	jalr	-806(ra) # 80003474 <install_trans>
    log.lh.n = 0;
    800037a2:	00027797          	auipc	a5,0x27
    800037a6:	1607ad23          	sw	zero,378(a5) # 8002a91c <log+0x2c>
    write_head();    // Erase the transaction from the log
    800037aa:	00000097          	auipc	ra,0x0
    800037ae:	c50080e7          	jalr	-944(ra) # 800033fa <write_head>
    800037b2:	bdf5                	j	800036ae <end_op+0x52>

00000000800037b4 <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    800037b4:	1101                	addi	sp,sp,-32
    800037b6:	ec06                	sd	ra,24(sp)
    800037b8:	e822                	sd	s0,16(sp)
    800037ba:	e426                	sd	s1,8(sp)
    800037bc:	e04a                	sd	s2,0(sp)
    800037be:	1000                	addi	s0,sp,32
    800037c0:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    800037c2:	00027917          	auipc	s2,0x27
    800037c6:	12e90913          	addi	s2,s2,302 # 8002a8f0 <log>
    800037ca:	854a                	mv	a0,s2
    800037cc:	00003097          	auipc	ra,0x3
    800037d0:	d30080e7          	jalr	-720(ra) # 800064fc <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    800037d4:	02c92603          	lw	a2,44(s2)
    800037d8:	47f5                	li	a5,29
    800037da:	06c7c563          	blt	a5,a2,80003844 <log_write+0x90>
    800037de:	00027797          	auipc	a5,0x27
    800037e2:	12e7a783          	lw	a5,302(a5) # 8002a90c <log+0x1c>
    800037e6:	37fd                	addiw	a5,a5,-1
    800037e8:	04f65e63          	bge	a2,a5,80003844 <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    800037ec:	00027797          	auipc	a5,0x27
    800037f0:	1247a783          	lw	a5,292(a5) # 8002a910 <log+0x20>
    800037f4:	06f05063          	blez	a5,80003854 <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    800037f8:	4781                	li	a5,0
    800037fa:	06c05563          	blez	a2,80003864 <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    800037fe:	44cc                	lw	a1,12(s1)
    80003800:	00027717          	auipc	a4,0x27
    80003804:	12070713          	addi	a4,a4,288 # 8002a920 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003808:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    8000380a:	4314                	lw	a3,0(a4)
    8000380c:	04b68c63          	beq	a3,a1,80003864 <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80003810:	2785                	addiw	a5,a5,1
    80003812:	0711                	addi	a4,a4,4
    80003814:	fef61be3          	bne	a2,a5,8000380a <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003818:	0621                	addi	a2,a2,8
    8000381a:	060a                	slli	a2,a2,0x2
    8000381c:	00027797          	auipc	a5,0x27
    80003820:	0d478793          	addi	a5,a5,212 # 8002a8f0 <log>
    80003824:	963e                	add	a2,a2,a5
    80003826:	44dc                	lw	a5,12(s1)
    80003828:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    8000382a:	8526                	mv	a0,s1
    8000382c:	fffff097          	auipc	ra,0xfffff
    80003830:	da2080e7          	jalr	-606(ra) # 800025ce <bpin>
    log.lh.n++;
    80003834:	00027717          	auipc	a4,0x27
    80003838:	0bc70713          	addi	a4,a4,188 # 8002a8f0 <log>
    8000383c:	575c                	lw	a5,44(a4)
    8000383e:	2785                	addiw	a5,a5,1
    80003840:	d75c                	sw	a5,44(a4)
    80003842:	a835                	j	8000387e <log_write+0xca>
    panic("too big a transaction");
    80003844:	00005517          	auipc	a0,0x5
    80003848:	d7c50513          	addi	a0,a0,-644 # 800085c0 <syscalls+0x200>
    8000384c:	00002097          	auipc	ra,0x2
    80003850:	766080e7          	jalr	1894(ra) # 80005fb2 <panic>
    panic("log_write outside of trans");
    80003854:	00005517          	auipc	a0,0x5
    80003858:	d8450513          	addi	a0,a0,-636 # 800085d8 <syscalls+0x218>
    8000385c:	00002097          	auipc	ra,0x2
    80003860:	756080e7          	jalr	1878(ra) # 80005fb2 <panic>
  log.lh.block[i] = b->blockno;
    80003864:	00878713          	addi	a4,a5,8
    80003868:	00271693          	slli	a3,a4,0x2
    8000386c:	00027717          	auipc	a4,0x27
    80003870:	08470713          	addi	a4,a4,132 # 8002a8f0 <log>
    80003874:	9736                	add	a4,a4,a3
    80003876:	44d4                	lw	a3,12(s1)
    80003878:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    8000387a:	faf608e3          	beq	a2,a5,8000382a <log_write+0x76>
  }
  release(&log.lock);
    8000387e:	00027517          	auipc	a0,0x27
    80003882:	07250513          	addi	a0,a0,114 # 8002a8f0 <log>
    80003886:	00003097          	auipc	ra,0x3
    8000388a:	d2a080e7          	jalr	-726(ra) # 800065b0 <release>
}
    8000388e:	60e2                	ld	ra,24(sp)
    80003890:	6442                	ld	s0,16(sp)
    80003892:	64a2                	ld	s1,8(sp)
    80003894:	6902                	ld	s2,0(sp)
    80003896:	6105                	addi	sp,sp,32
    80003898:	8082                	ret

000000008000389a <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    8000389a:	1101                	addi	sp,sp,-32
    8000389c:	ec06                	sd	ra,24(sp)
    8000389e:	e822                	sd	s0,16(sp)
    800038a0:	e426                	sd	s1,8(sp)
    800038a2:	e04a                	sd	s2,0(sp)
    800038a4:	1000                	addi	s0,sp,32
    800038a6:	84aa                	mv	s1,a0
    800038a8:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    800038aa:	00005597          	auipc	a1,0x5
    800038ae:	d4e58593          	addi	a1,a1,-690 # 800085f8 <syscalls+0x238>
    800038b2:	0521                	addi	a0,a0,8
    800038b4:	00003097          	auipc	ra,0x3
    800038b8:	bb8080e7          	jalr	-1096(ra) # 8000646c <initlock>
  lk->name = name;
    800038bc:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    800038c0:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800038c4:	0204a423          	sw	zero,40(s1)
}
    800038c8:	60e2                	ld	ra,24(sp)
    800038ca:	6442                	ld	s0,16(sp)
    800038cc:	64a2                	ld	s1,8(sp)
    800038ce:	6902                	ld	s2,0(sp)
    800038d0:	6105                	addi	sp,sp,32
    800038d2:	8082                	ret

00000000800038d4 <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    800038d4:	1101                	addi	sp,sp,-32
    800038d6:	ec06                	sd	ra,24(sp)
    800038d8:	e822                	sd	s0,16(sp)
    800038da:	e426                	sd	s1,8(sp)
    800038dc:	e04a                	sd	s2,0(sp)
    800038de:	1000                	addi	s0,sp,32
    800038e0:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    800038e2:	00850913          	addi	s2,a0,8
    800038e6:	854a                	mv	a0,s2
    800038e8:	00003097          	auipc	ra,0x3
    800038ec:	c14080e7          	jalr	-1004(ra) # 800064fc <acquire>
  while (lk->locked) {
    800038f0:	409c                	lw	a5,0(s1)
    800038f2:	cb89                	beqz	a5,80003904 <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    800038f4:	85ca                	mv	a1,s2
    800038f6:	8526                	mv	a0,s1
    800038f8:	ffffe097          	auipc	ra,0xffffe
    800038fc:	c52080e7          	jalr	-942(ra) # 8000154a <sleep>
  while (lk->locked) {
    80003900:	409c                	lw	a5,0(s1)
    80003902:	fbed                	bnez	a5,800038f4 <acquiresleep+0x20>
  }
  lk->locked = 1;
    80003904:	4785                	li	a5,1
    80003906:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003908:	ffffd097          	auipc	ra,0xffffd
    8000390c:	536080e7          	jalr	1334(ra) # 80000e3e <myproc>
    80003910:	591c                	lw	a5,48(a0)
    80003912:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    80003914:	854a                	mv	a0,s2
    80003916:	00003097          	auipc	ra,0x3
    8000391a:	c9a080e7          	jalr	-870(ra) # 800065b0 <release>
}
    8000391e:	60e2                	ld	ra,24(sp)
    80003920:	6442                	ld	s0,16(sp)
    80003922:	64a2                	ld	s1,8(sp)
    80003924:	6902                	ld	s2,0(sp)
    80003926:	6105                	addi	sp,sp,32
    80003928:	8082                	ret

000000008000392a <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    8000392a:	1101                	addi	sp,sp,-32
    8000392c:	ec06                	sd	ra,24(sp)
    8000392e:	e822                	sd	s0,16(sp)
    80003930:	e426                	sd	s1,8(sp)
    80003932:	e04a                	sd	s2,0(sp)
    80003934:	1000                	addi	s0,sp,32
    80003936:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003938:	00850913          	addi	s2,a0,8
    8000393c:	854a                	mv	a0,s2
    8000393e:	00003097          	auipc	ra,0x3
    80003942:	bbe080e7          	jalr	-1090(ra) # 800064fc <acquire>
  lk->locked = 0;
    80003946:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000394a:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    8000394e:	8526                	mv	a0,s1
    80003950:	ffffe097          	auipc	ra,0xffffe
    80003954:	c5e080e7          	jalr	-930(ra) # 800015ae <wakeup>
  release(&lk->lk);
    80003958:	854a                	mv	a0,s2
    8000395a:	00003097          	auipc	ra,0x3
    8000395e:	c56080e7          	jalr	-938(ra) # 800065b0 <release>
}
    80003962:	60e2                	ld	ra,24(sp)
    80003964:	6442                	ld	s0,16(sp)
    80003966:	64a2                	ld	s1,8(sp)
    80003968:	6902                	ld	s2,0(sp)
    8000396a:	6105                	addi	sp,sp,32
    8000396c:	8082                	ret

000000008000396e <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    8000396e:	7179                	addi	sp,sp,-48
    80003970:	f406                	sd	ra,40(sp)
    80003972:	f022                	sd	s0,32(sp)
    80003974:	ec26                	sd	s1,24(sp)
    80003976:	e84a                	sd	s2,16(sp)
    80003978:	e44e                	sd	s3,8(sp)
    8000397a:	1800                	addi	s0,sp,48
    8000397c:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    8000397e:	00850913          	addi	s2,a0,8
    80003982:	854a                	mv	a0,s2
    80003984:	00003097          	auipc	ra,0x3
    80003988:	b78080e7          	jalr	-1160(ra) # 800064fc <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    8000398c:	409c                	lw	a5,0(s1)
    8000398e:	ef99                	bnez	a5,800039ac <holdingsleep+0x3e>
    80003990:	4481                	li	s1,0
  release(&lk->lk);
    80003992:	854a                	mv	a0,s2
    80003994:	00003097          	auipc	ra,0x3
    80003998:	c1c080e7          	jalr	-996(ra) # 800065b0 <release>
  return r;
}
    8000399c:	8526                	mv	a0,s1
    8000399e:	70a2                	ld	ra,40(sp)
    800039a0:	7402                	ld	s0,32(sp)
    800039a2:	64e2                	ld	s1,24(sp)
    800039a4:	6942                	ld	s2,16(sp)
    800039a6:	69a2                	ld	s3,8(sp)
    800039a8:	6145                	addi	sp,sp,48
    800039aa:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    800039ac:	0284a983          	lw	s3,40(s1)
    800039b0:	ffffd097          	auipc	ra,0xffffd
    800039b4:	48e080e7          	jalr	1166(ra) # 80000e3e <myproc>
    800039b8:	5904                	lw	s1,48(a0)
    800039ba:	413484b3          	sub	s1,s1,s3
    800039be:	0014b493          	seqz	s1,s1
    800039c2:	bfc1                	j	80003992 <holdingsleep+0x24>

00000000800039c4 <fileinit>:
    struct spinlock lock;
    struct file file[NFILE];
} ftable;

void fileinit(void)
{
    800039c4:	1141                	addi	sp,sp,-16
    800039c6:	e406                	sd	ra,8(sp)
    800039c8:	e022                	sd	s0,0(sp)
    800039ca:	0800                	addi	s0,sp,16
    initlock(&ftable.lock, "ftable");
    800039cc:	00005597          	auipc	a1,0x5
    800039d0:	c3c58593          	addi	a1,a1,-964 # 80008608 <syscalls+0x248>
    800039d4:	00027517          	auipc	a0,0x27
    800039d8:	06450513          	addi	a0,a0,100 # 8002aa38 <ftable>
    800039dc:	00003097          	auipc	ra,0x3
    800039e0:	a90080e7          	jalr	-1392(ra) # 8000646c <initlock>
}
    800039e4:	60a2                	ld	ra,8(sp)
    800039e6:	6402                	ld	s0,0(sp)
    800039e8:	0141                	addi	sp,sp,16
    800039ea:	8082                	ret

00000000800039ec <filealloc>:

// Allocate a file structure.
struct file *
filealloc(void)
{
    800039ec:	1101                	addi	sp,sp,-32
    800039ee:	ec06                	sd	ra,24(sp)
    800039f0:	e822                	sd	s0,16(sp)
    800039f2:	e426                	sd	s1,8(sp)
    800039f4:	1000                	addi	s0,sp,32
    struct file *f;

    acquire(&ftable.lock);
    800039f6:	00027517          	auipc	a0,0x27
    800039fa:	04250513          	addi	a0,a0,66 # 8002aa38 <ftable>
    800039fe:	00003097          	auipc	ra,0x3
    80003a02:	afe080e7          	jalr	-1282(ra) # 800064fc <acquire>
    for (f = ftable.file; f < ftable.file + NFILE; f++)
    80003a06:	00027497          	auipc	s1,0x27
    80003a0a:	04a48493          	addi	s1,s1,74 # 8002aa50 <ftable+0x18>
    80003a0e:	00028717          	auipc	a4,0x28
    80003a12:	fe270713          	addi	a4,a4,-30 # 8002b9f0 <disk>
    {
        if (f->ref == 0)
    80003a16:	40dc                	lw	a5,4(s1)
    80003a18:	cf99                	beqz	a5,80003a36 <filealloc+0x4a>
    for (f = ftable.file; f < ftable.file + NFILE; f++)
    80003a1a:	02848493          	addi	s1,s1,40
    80003a1e:	fee49ce3          	bne	s1,a4,80003a16 <filealloc+0x2a>
            f->ref = 1;
            release(&ftable.lock);
            return f;
        }
    }
    release(&ftable.lock);
    80003a22:	00027517          	auipc	a0,0x27
    80003a26:	01650513          	addi	a0,a0,22 # 8002aa38 <ftable>
    80003a2a:	00003097          	auipc	ra,0x3
    80003a2e:	b86080e7          	jalr	-1146(ra) # 800065b0 <release>
    return 0;
    80003a32:	4481                	li	s1,0
    80003a34:	a819                	j	80003a4a <filealloc+0x5e>
            f->ref = 1;
    80003a36:	4785                	li	a5,1
    80003a38:	c0dc                	sw	a5,4(s1)
            release(&ftable.lock);
    80003a3a:	00027517          	auipc	a0,0x27
    80003a3e:	ffe50513          	addi	a0,a0,-2 # 8002aa38 <ftable>
    80003a42:	00003097          	auipc	ra,0x3
    80003a46:	b6e080e7          	jalr	-1170(ra) # 800065b0 <release>
}
    80003a4a:	8526                	mv	a0,s1
    80003a4c:	60e2                	ld	ra,24(sp)
    80003a4e:	6442                	ld	s0,16(sp)
    80003a50:	64a2                	ld	s1,8(sp)
    80003a52:	6105                	addi	sp,sp,32
    80003a54:	8082                	ret

0000000080003a56 <filedup>:

// Increment ref count for file f.
struct file *
filedup(struct file *f)
{
    80003a56:	1101                	addi	sp,sp,-32
    80003a58:	ec06                	sd	ra,24(sp)
    80003a5a:	e822                	sd	s0,16(sp)
    80003a5c:	e426                	sd	s1,8(sp)
    80003a5e:	1000                	addi	s0,sp,32
    80003a60:	84aa                	mv	s1,a0
    acquire(&ftable.lock);
    80003a62:	00027517          	auipc	a0,0x27
    80003a66:	fd650513          	addi	a0,a0,-42 # 8002aa38 <ftable>
    80003a6a:	00003097          	auipc	ra,0x3
    80003a6e:	a92080e7          	jalr	-1390(ra) # 800064fc <acquire>
    if (f->ref < 1)
    80003a72:	40dc                	lw	a5,4(s1)
    80003a74:	02f05263          	blez	a5,80003a98 <filedup+0x42>
        panic("filedup");
    f->ref++;
    80003a78:	2785                	addiw	a5,a5,1
    80003a7a:	c0dc                	sw	a5,4(s1)
    release(&ftable.lock);
    80003a7c:	00027517          	auipc	a0,0x27
    80003a80:	fbc50513          	addi	a0,a0,-68 # 8002aa38 <ftable>
    80003a84:	00003097          	auipc	ra,0x3
    80003a88:	b2c080e7          	jalr	-1236(ra) # 800065b0 <release>
    return f;
}
    80003a8c:	8526                	mv	a0,s1
    80003a8e:	60e2                	ld	ra,24(sp)
    80003a90:	6442                	ld	s0,16(sp)
    80003a92:	64a2                	ld	s1,8(sp)
    80003a94:	6105                	addi	sp,sp,32
    80003a96:	8082                	ret
        panic("filedup");
    80003a98:	00005517          	auipc	a0,0x5
    80003a9c:	b7850513          	addi	a0,a0,-1160 # 80008610 <syscalls+0x250>
    80003aa0:	00002097          	auipc	ra,0x2
    80003aa4:	512080e7          	jalr	1298(ra) # 80005fb2 <panic>

0000000080003aa8 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void fileclose(struct file *f)
{
    80003aa8:	7139                	addi	sp,sp,-64
    80003aaa:	fc06                	sd	ra,56(sp)
    80003aac:	f822                	sd	s0,48(sp)
    80003aae:	f426                	sd	s1,40(sp)
    80003ab0:	f04a                	sd	s2,32(sp)
    80003ab2:	ec4e                	sd	s3,24(sp)
    80003ab4:	e852                	sd	s4,16(sp)
    80003ab6:	e456                	sd	s5,8(sp)
    80003ab8:	0080                	addi	s0,sp,64
    80003aba:	84aa                	mv	s1,a0
    struct file ff;

    acquire(&ftable.lock);
    80003abc:	00027517          	auipc	a0,0x27
    80003ac0:	f7c50513          	addi	a0,a0,-132 # 8002aa38 <ftable>
    80003ac4:	00003097          	auipc	ra,0x3
    80003ac8:	a38080e7          	jalr	-1480(ra) # 800064fc <acquire>
    if (f->ref < 1)
    80003acc:	40dc                	lw	a5,4(s1)
    80003ace:	06f05163          	blez	a5,80003b30 <fileclose+0x88>
        panic("fileclose");
    if (--f->ref > 0)
    80003ad2:	37fd                	addiw	a5,a5,-1
    80003ad4:	0007871b          	sext.w	a4,a5
    80003ad8:	c0dc                	sw	a5,4(s1)
    80003ada:	06e04363          	bgtz	a4,80003b40 <fileclose+0x98>
    {
        release(&ftable.lock);
        return;
    }
    ff = *f;
    80003ade:	0004a903          	lw	s2,0(s1)
    80003ae2:	0094ca83          	lbu	s5,9(s1)
    80003ae6:	0104ba03          	ld	s4,16(s1)
    80003aea:	0184b983          	ld	s3,24(s1)
    f->ref = 0;
    80003aee:	0004a223          	sw	zero,4(s1)
    f->type = FD_NONE;
    80003af2:	0004a023          	sw	zero,0(s1)
    release(&ftable.lock);
    80003af6:	00027517          	auipc	a0,0x27
    80003afa:	f4250513          	addi	a0,a0,-190 # 8002aa38 <ftable>
    80003afe:	00003097          	auipc	ra,0x3
    80003b02:	ab2080e7          	jalr	-1358(ra) # 800065b0 <release>

    if (ff.type == FD_PIPE)
    80003b06:	4785                	li	a5,1
    80003b08:	04f90d63          	beq	s2,a5,80003b62 <fileclose+0xba>
    {
        pipeclose(ff.pipe, ff.writable);
    }
    else if (ff.type == FD_INODE || ff.type == FD_DEVICE)
    80003b0c:	3979                	addiw	s2,s2,-2
    80003b0e:	4785                	li	a5,1
    80003b10:	0527e063          	bltu	a5,s2,80003b50 <fileclose+0xa8>
    {
        begin_op();
    80003b14:	00000097          	auipc	ra,0x0
    80003b18:	ac8080e7          	jalr	-1336(ra) # 800035dc <begin_op>
        iput(ff.ip);
    80003b1c:	854e                	mv	a0,s3
    80003b1e:	fffff097          	auipc	ra,0xfffff
    80003b22:	2b6080e7          	jalr	694(ra) # 80002dd4 <iput>
        end_op();
    80003b26:	00000097          	auipc	ra,0x0
    80003b2a:	b36080e7          	jalr	-1226(ra) # 8000365c <end_op>
    80003b2e:	a00d                	j	80003b50 <fileclose+0xa8>
        panic("fileclose");
    80003b30:	00005517          	auipc	a0,0x5
    80003b34:	ae850513          	addi	a0,a0,-1304 # 80008618 <syscalls+0x258>
    80003b38:	00002097          	auipc	ra,0x2
    80003b3c:	47a080e7          	jalr	1146(ra) # 80005fb2 <panic>
        release(&ftable.lock);
    80003b40:	00027517          	auipc	a0,0x27
    80003b44:	ef850513          	addi	a0,a0,-264 # 8002aa38 <ftable>
    80003b48:	00003097          	auipc	ra,0x3
    80003b4c:	a68080e7          	jalr	-1432(ra) # 800065b0 <release>
    }
}
    80003b50:	70e2                	ld	ra,56(sp)
    80003b52:	7442                	ld	s0,48(sp)
    80003b54:	74a2                	ld	s1,40(sp)
    80003b56:	7902                	ld	s2,32(sp)
    80003b58:	69e2                	ld	s3,24(sp)
    80003b5a:	6a42                	ld	s4,16(sp)
    80003b5c:	6aa2                	ld	s5,8(sp)
    80003b5e:	6121                	addi	sp,sp,64
    80003b60:	8082                	ret
        pipeclose(ff.pipe, ff.writable);
    80003b62:	85d6                	mv	a1,s5
    80003b64:	8552                	mv	a0,s4
    80003b66:	00000097          	auipc	ra,0x0
    80003b6a:	3a6080e7          	jalr	934(ra) # 80003f0c <pipeclose>
    80003b6e:	b7cd                	j	80003b50 <fileclose+0xa8>

0000000080003b70 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int filestat(struct file *f, uint64 addr)
{
    80003b70:	715d                	addi	sp,sp,-80
    80003b72:	e486                	sd	ra,72(sp)
    80003b74:	e0a2                	sd	s0,64(sp)
    80003b76:	fc26                	sd	s1,56(sp)
    80003b78:	f84a                	sd	s2,48(sp)
    80003b7a:	f44e                	sd	s3,40(sp)
    80003b7c:	0880                	addi	s0,sp,80
    80003b7e:	84aa                	mv	s1,a0
    80003b80:	89ae                	mv	s3,a1
    struct proc *p = myproc();
    80003b82:	ffffd097          	auipc	ra,0xffffd
    80003b86:	2bc080e7          	jalr	700(ra) # 80000e3e <myproc>
    struct stat st;

    if (f->type == FD_INODE || f->type == FD_DEVICE)
    80003b8a:	409c                	lw	a5,0(s1)
    80003b8c:	37f9                	addiw	a5,a5,-2
    80003b8e:	4705                	li	a4,1
    80003b90:	04f76763          	bltu	a4,a5,80003bde <filestat+0x6e>
    80003b94:	892a                	mv	s2,a0
    {
        ilock(f->ip);
    80003b96:	6c88                	ld	a0,24(s1)
    80003b98:	fffff097          	auipc	ra,0xfffff
    80003b9c:	082080e7          	jalr	130(ra) # 80002c1a <ilock>
        stati(f->ip, &st);
    80003ba0:	fb840593          	addi	a1,s0,-72
    80003ba4:	6c88                	ld	a0,24(s1)
    80003ba6:	fffff097          	auipc	ra,0xfffff
    80003baa:	2fe080e7          	jalr	766(ra) # 80002ea4 <stati>
        iunlock(f->ip);
    80003bae:	6c88                	ld	a0,24(s1)
    80003bb0:	fffff097          	auipc	ra,0xfffff
    80003bb4:	12c080e7          	jalr	300(ra) # 80002cdc <iunlock>
        if (copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003bb8:	46e1                	li	a3,24
    80003bba:	fb840613          	addi	a2,s0,-72
    80003bbe:	85ce                	mv	a1,s3
    80003bc0:	05093503          	ld	a0,80(s2)
    80003bc4:	ffffd097          	auipc	ra,0xffffd
    80003bc8:	f38080e7          	jalr	-200(ra) # 80000afc <copyout>
    80003bcc:	41f5551b          	sraiw	a0,a0,0x1f
            return -1;
        return 0;
    }
    return -1;
}
    80003bd0:	60a6                	ld	ra,72(sp)
    80003bd2:	6406                	ld	s0,64(sp)
    80003bd4:	74e2                	ld	s1,56(sp)
    80003bd6:	7942                	ld	s2,48(sp)
    80003bd8:	79a2                	ld	s3,40(sp)
    80003bda:	6161                	addi	sp,sp,80
    80003bdc:	8082                	ret
    return -1;
    80003bde:	557d                	li	a0,-1
    80003be0:	bfc5                	j	80003bd0 <filestat+0x60>

0000000080003be2 <mapfile>:

void mapfile(struct file *f, char *mem, int offset)
{
    80003be2:	7179                	addi	sp,sp,-48
    80003be4:	f406                	sd	ra,40(sp)
    80003be6:	f022                	sd	s0,32(sp)
    80003be8:	ec26                	sd	s1,24(sp)
    80003bea:	e84a                	sd	s2,16(sp)
    80003bec:	e44e                	sd	s3,8(sp)
    80003bee:	1800                	addi	s0,sp,48
    80003bf0:	84aa                	mv	s1,a0
    80003bf2:	89ae                	mv	s3,a1
    80003bf4:	8932                	mv	s2,a2
    printf("off %d\n", offset);
    80003bf6:	85b2                	mv	a1,a2
    80003bf8:	00005517          	auipc	a0,0x5
    80003bfc:	a3050513          	addi	a0,a0,-1488 # 80008628 <syscalls+0x268>
    80003c00:	00002097          	auipc	ra,0x2
    80003c04:	3fc080e7          	jalr	1020(ra) # 80005ffc <printf>
    ilock(f->ip);
    80003c08:	6c88                	ld	a0,24(s1)
    80003c0a:	fffff097          	auipc	ra,0xfffff
    80003c0e:	010080e7          	jalr	16(ra) # 80002c1a <ilock>
    readi(f->ip, 0, (uint64)mem, offset, PGSIZE);
    80003c12:	6705                	lui	a4,0x1
    80003c14:	86ca                	mv	a3,s2
    80003c16:	864e                	mv	a2,s3
    80003c18:	4581                	li	a1,0
    80003c1a:	6c88                	ld	a0,24(s1)
    80003c1c:	fffff097          	auipc	ra,0xfffff
    80003c20:	2b2080e7          	jalr	690(ra) # 80002ece <readi>
    iunlock(f->ip);
    80003c24:	6c88                	ld	a0,24(s1)
    80003c26:	fffff097          	auipc	ra,0xfffff
    80003c2a:	0b6080e7          	jalr	182(ra) # 80002cdc <iunlock>
}
    80003c2e:	70a2                	ld	ra,40(sp)
    80003c30:	7402                	ld	s0,32(sp)
    80003c32:	64e2                	ld	s1,24(sp)
    80003c34:	6942                	ld	s2,16(sp)
    80003c36:	69a2                	ld	s3,8(sp)
    80003c38:	6145                	addi	sp,sp,48
    80003c3a:	8082                	ret

0000000080003c3c <fileread>:

// Read from file f.
// addr is a user virtual address.
int fileread(struct file *f, uint64 addr, int n)
{
    80003c3c:	7179                	addi	sp,sp,-48
    80003c3e:	f406                	sd	ra,40(sp)
    80003c40:	f022                	sd	s0,32(sp)
    80003c42:	ec26                	sd	s1,24(sp)
    80003c44:	e84a                	sd	s2,16(sp)
    80003c46:	e44e                	sd	s3,8(sp)
    80003c48:	1800                	addi	s0,sp,48
    int r = 0;

    if (f->readable == 0)
    80003c4a:	00854783          	lbu	a5,8(a0)
    80003c4e:	c3d5                	beqz	a5,80003cf2 <fileread+0xb6>
    80003c50:	84aa                	mv	s1,a0
    80003c52:	89ae                	mv	s3,a1
    80003c54:	8932                	mv	s2,a2
        return -1;

    if (f->type == FD_PIPE)
    80003c56:	411c                	lw	a5,0(a0)
    80003c58:	4705                	li	a4,1
    80003c5a:	04e78963          	beq	a5,a4,80003cac <fileread+0x70>
    {
        r = piperead(f->pipe, addr, n);
    }
    else if (f->type == FD_DEVICE)
    80003c5e:	470d                	li	a4,3
    80003c60:	04e78d63          	beq	a5,a4,80003cba <fileread+0x7e>
    {
        if (f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
            return -1;
        r = devsw[f->major].read(1, addr, n);
    }
    else if (f->type == FD_INODE)
    80003c64:	4709                	li	a4,2
    80003c66:	06e79e63          	bne	a5,a4,80003ce2 <fileread+0xa6>
    {
        ilock(f->ip);
    80003c6a:	6d08                	ld	a0,24(a0)
    80003c6c:	fffff097          	auipc	ra,0xfffff
    80003c70:	fae080e7          	jalr	-82(ra) # 80002c1a <ilock>
        if ((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003c74:	874a                	mv	a4,s2
    80003c76:	5094                	lw	a3,32(s1)
    80003c78:	864e                	mv	a2,s3
    80003c7a:	4585                	li	a1,1
    80003c7c:	6c88                	ld	a0,24(s1)
    80003c7e:	fffff097          	auipc	ra,0xfffff
    80003c82:	250080e7          	jalr	592(ra) # 80002ece <readi>
    80003c86:	892a                	mv	s2,a0
    80003c88:	00a05563          	blez	a0,80003c92 <fileread+0x56>
            f->off += r;
    80003c8c:	509c                	lw	a5,32(s1)
    80003c8e:	9fa9                	addw	a5,a5,a0
    80003c90:	d09c                	sw	a5,32(s1)
        iunlock(f->ip);
    80003c92:	6c88                	ld	a0,24(s1)
    80003c94:	fffff097          	auipc	ra,0xfffff
    80003c98:	048080e7          	jalr	72(ra) # 80002cdc <iunlock>
    {
        panic("fileread");
    }

    return r;
}
    80003c9c:	854a                	mv	a0,s2
    80003c9e:	70a2                	ld	ra,40(sp)
    80003ca0:	7402                	ld	s0,32(sp)
    80003ca2:	64e2                	ld	s1,24(sp)
    80003ca4:	6942                	ld	s2,16(sp)
    80003ca6:	69a2                	ld	s3,8(sp)
    80003ca8:	6145                	addi	sp,sp,48
    80003caa:	8082                	ret
        r = piperead(f->pipe, addr, n);
    80003cac:	6908                	ld	a0,16(a0)
    80003cae:	00000097          	auipc	ra,0x0
    80003cb2:	3ce080e7          	jalr	974(ra) # 8000407c <piperead>
    80003cb6:	892a                	mv	s2,a0
    80003cb8:	b7d5                	j	80003c9c <fileread+0x60>
        if (f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003cba:	02451783          	lh	a5,36(a0)
    80003cbe:	03079693          	slli	a3,a5,0x30
    80003cc2:	92c1                	srli	a3,a3,0x30
    80003cc4:	4725                	li	a4,9
    80003cc6:	02d76863          	bltu	a4,a3,80003cf6 <fileread+0xba>
    80003cca:	0792                	slli	a5,a5,0x4
    80003ccc:	00027717          	auipc	a4,0x27
    80003cd0:	ccc70713          	addi	a4,a4,-820 # 8002a998 <devsw>
    80003cd4:	97ba                	add	a5,a5,a4
    80003cd6:	639c                	ld	a5,0(a5)
    80003cd8:	c38d                	beqz	a5,80003cfa <fileread+0xbe>
        r = devsw[f->major].read(1, addr, n);
    80003cda:	4505                	li	a0,1
    80003cdc:	9782                	jalr	a5
    80003cde:	892a                	mv	s2,a0
    80003ce0:	bf75                	j	80003c9c <fileread+0x60>
        panic("fileread");
    80003ce2:	00005517          	auipc	a0,0x5
    80003ce6:	94e50513          	addi	a0,a0,-1714 # 80008630 <syscalls+0x270>
    80003cea:	00002097          	auipc	ra,0x2
    80003cee:	2c8080e7          	jalr	712(ra) # 80005fb2 <panic>
        return -1;
    80003cf2:	597d                	li	s2,-1
    80003cf4:	b765                	j	80003c9c <fileread+0x60>
            return -1;
    80003cf6:	597d                	li	s2,-1
    80003cf8:	b755                	j	80003c9c <fileread+0x60>
    80003cfa:	597d                	li	s2,-1
    80003cfc:	b745                	j	80003c9c <fileread+0x60>

0000000080003cfe <filewrite>:

// Write to file f.
// addr is a user virtual address.
int filewrite(struct file *f, uint64 addr, int n)
{
    80003cfe:	715d                	addi	sp,sp,-80
    80003d00:	e486                	sd	ra,72(sp)
    80003d02:	e0a2                	sd	s0,64(sp)
    80003d04:	fc26                	sd	s1,56(sp)
    80003d06:	f84a                	sd	s2,48(sp)
    80003d08:	f44e                	sd	s3,40(sp)
    80003d0a:	f052                	sd	s4,32(sp)
    80003d0c:	ec56                	sd	s5,24(sp)
    80003d0e:	e85a                	sd	s6,16(sp)
    80003d10:	e45e                	sd	s7,8(sp)
    80003d12:	e062                	sd	s8,0(sp)
    80003d14:	0880                	addi	s0,sp,80
    int r, ret = 0;

    if (f->writable == 0)
    80003d16:	00954783          	lbu	a5,9(a0)
    80003d1a:	10078663          	beqz	a5,80003e26 <filewrite+0x128>
    80003d1e:	892a                	mv	s2,a0
    80003d20:	8aae                	mv	s5,a1
    80003d22:	8a32                	mv	s4,a2
        return -1;

    if (f->type == FD_PIPE)
    80003d24:	411c                	lw	a5,0(a0)
    80003d26:	4705                	li	a4,1
    80003d28:	02e78263          	beq	a5,a4,80003d4c <filewrite+0x4e>
    {
        ret = pipewrite(f->pipe, addr, n);
    }
    else if (f->type == FD_DEVICE)
    80003d2c:	470d                	li	a4,3
    80003d2e:	02e78663          	beq	a5,a4,80003d5a <filewrite+0x5c>
    {
        if (f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
            return -1;
        ret = devsw[f->major].write(1, addr, n);
    }
    else if (f->type == FD_INODE)
    80003d32:	4709                	li	a4,2
    80003d34:	0ee79163          	bne	a5,a4,80003e16 <filewrite+0x118>
        // and 2 blocks of slop for non-aligned writes.
        // this really belongs lower down, since writei()
        // might be writing a device like the console.
        int max = ((MAXOPBLOCKS - 1 - 1 - 2) / 2) * BSIZE;
        int i = 0;
        while (i < n)
    80003d38:	0ac05d63          	blez	a2,80003df2 <filewrite+0xf4>
        int i = 0;
    80003d3c:	4981                	li	s3,0
    80003d3e:	6b05                	lui	s6,0x1
    80003d40:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003d44:	6b85                	lui	s7,0x1
    80003d46:	c00b8b9b          	addiw	s7,s7,-1024
    80003d4a:	a861                	j	80003de2 <filewrite+0xe4>
        ret = pipewrite(f->pipe, addr, n);
    80003d4c:	6908                	ld	a0,16(a0)
    80003d4e:	00000097          	auipc	ra,0x0
    80003d52:	22e080e7          	jalr	558(ra) # 80003f7c <pipewrite>
    80003d56:	8a2a                	mv	s4,a0
    80003d58:	a045                	j	80003df8 <filewrite+0xfa>
        if (f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003d5a:	02451783          	lh	a5,36(a0)
    80003d5e:	03079693          	slli	a3,a5,0x30
    80003d62:	92c1                	srli	a3,a3,0x30
    80003d64:	4725                	li	a4,9
    80003d66:	0cd76263          	bltu	a4,a3,80003e2a <filewrite+0x12c>
    80003d6a:	0792                	slli	a5,a5,0x4
    80003d6c:	00027717          	auipc	a4,0x27
    80003d70:	c2c70713          	addi	a4,a4,-980 # 8002a998 <devsw>
    80003d74:	97ba                	add	a5,a5,a4
    80003d76:	679c                	ld	a5,8(a5)
    80003d78:	cbdd                	beqz	a5,80003e2e <filewrite+0x130>
        ret = devsw[f->major].write(1, addr, n);
    80003d7a:	4505                	li	a0,1
    80003d7c:	9782                	jalr	a5
    80003d7e:	8a2a                	mv	s4,a0
    80003d80:	a8a5                	j	80003df8 <filewrite+0xfa>
    80003d82:	00048c1b          	sext.w	s8,s1
        {
            int n1 = n - i;
            if (n1 > max)
                n1 = max;

            begin_op();
    80003d86:	00000097          	auipc	ra,0x0
    80003d8a:	856080e7          	jalr	-1962(ra) # 800035dc <begin_op>
            ilock(f->ip);
    80003d8e:	01893503          	ld	a0,24(s2)
    80003d92:	fffff097          	auipc	ra,0xfffff
    80003d96:	e88080e7          	jalr	-376(ra) # 80002c1a <ilock>
            if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003d9a:	8762                	mv	a4,s8
    80003d9c:	02092683          	lw	a3,32(s2)
    80003da0:	01598633          	add	a2,s3,s5
    80003da4:	4585                	li	a1,1
    80003da6:	01893503          	ld	a0,24(s2)
    80003daa:	fffff097          	auipc	ra,0xfffff
    80003dae:	21c080e7          	jalr	540(ra) # 80002fc6 <writei>
    80003db2:	84aa                	mv	s1,a0
    80003db4:	00a05763          	blez	a0,80003dc2 <filewrite+0xc4>
                f->off += r;
    80003db8:	02092783          	lw	a5,32(s2)
    80003dbc:	9fa9                	addw	a5,a5,a0
    80003dbe:	02f92023          	sw	a5,32(s2)
            iunlock(f->ip);
    80003dc2:	01893503          	ld	a0,24(s2)
    80003dc6:	fffff097          	auipc	ra,0xfffff
    80003dca:	f16080e7          	jalr	-234(ra) # 80002cdc <iunlock>
            end_op();
    80003dce:	00000097          	auipc	ra,0x0
    80003dd2:	88e080e7          	jalr	-1906(ra) # 8000365c <end_op>

            if (r != n1)
    80003dd6:	009c1f63          	bne	s8,s1,80003df4 <filewrite+0xf6>
            {
                // error from writei
                break;
            }
            i += r;
    80003dda:	013489bb          	addw	s3,s1,s3
        while (i < n)
    80003dde:	0149db63          	bge	s3,s4,80003df4 <filewrite+0xf6>
            int n1 = n - i;
    80003de2:	413a07bb          	subw	a5,s4,s3
            if (n1 > max)
    80003de6:	84be                	mv	s1,a5
    80003de8:	2781                	sext.w	a5,a5
    80003dea:	f8fb5ce3          	bge	s6,a5,80003d82 <filewrite+0x84>
    80003dee:	84de                	mv	s1,s7
    80003df0:	bf49                	j	80003d82 <filewrite+0x84>
        int i = 0;
    80003df2:	4981                	li	s3,0
        }
        ret = (i == n ? n : -1);
    80003df4:	013a1f63          	bne	s4,s3,80003e12 <filewrite+0x114>
    {
        panic("filewrite");
    }

    return ret;
}
    80003df8:	8552                	mv	a0,s4
    80003dfa:	60a6                	ld	ra,72(sp)
    80003dfc:	6406                	ld	s0,64(sp)
    80003dfe:	74e2                	ld	s1,56(sp)
    80003e00:	7942                	ld	s2,48(sp)
    80003e02:	79a2                	ld	s3,40(sp)
    80003e04:	7a02                	ld	s4,32(sp)
    80003e06:	6ae2                	ld	s5,24(sp)
    80003e08:	6b42                	ld	s6,16(sp)
    80003e0a:	6ba2                	ld	s7,8(sp)
    80003e0c:	6c02                	ld	s8,0(sp)
    80003e0e:	6161                	addi	sp,sp,80
    80003e10:	8082                	ret
        ret = (i == n ? n : -1);
    80003e12:	5a7d                	li	s4,-1
    80003e14:	b7d5                	j	80003df8 <filewrite+0xfa>
        panic("filewrite");
    80003e16:	00005517          	auipc	a0,0x5
    80003e1a:	82a50513          	addi	a0,a0,-2006 # 80008640 <syscalls+0x280>
    80003e1e:	00002097          	auipc	ra,0x2
    80003e22:	194080e7          	jalr	404(ra) # 80005fb2 <panic>
        return -1;
    80003e26:	5a7d                	li	s4,-1
    80003e28:	bfc1                	j	80003df8 <filewrite+0xfa>
            return -1;
    80003e2a:	5a7d                	li	s4,-1
    80003e2c:	b7f1                	j	80003df8 <filewrite+0xfa>
    80003e2e:	5a7d                	li	s4,-1
    80003e30:	b7e1                	j	80003df8 <filewrite+0xfa>

0000000080003e32 <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003e32:	7179                	addi	sp,sp,-48
    80003e34:	f406                	sd	ra,40(sp)
    80003e36:	f022                	sd	s0,32(sp)
    80003e38:	ec26                	sd	s1,24(sp)
    80003e3a:	e84a                	sd	s2,16(sp)
    80003e3c:	e44e                	sd	s3,8(sp)
    80003e3e:	e052                	sd	s4,0(sp)
    80003e40:	1800                	addi	s0,sp,48
    80003e42:	84aa                	mv	s1,a0
    80003e44:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003e46:	0005b023          	sd	zero,0(a1)
    80003e4a:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003e4e:	00000097          	auipc	ra,0x0
    80003e52:	b9e080e7          	jalr	-1122(ra) # 800039ec <filealloc>
    80003e56:	e088                	sd	a0,0(s1)
    80003e58:	c551                	beqz	a0,80003ee4 <pipealloc+0xb2>
    80003e5a:	00000097          	auipc	ra,0x0
    80003e5e:	b92080e7          	jalr	-1134(ra) # 800039ec <filealloc>
    80003e62:	00aa3023          	sd	a0,0(s4)
    80003e66:	c92d                	beqz	a0,80003ed8 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003e68:	ffffc097          	auipc	ra,0xffffc
    80003e6c:	2b0080e7          	jalr	688(ra) # 80000118 <kalloc>
    80003e70:	892a                	mv	s2,a0
    80003e72:	c125                	beqz	a0,80003ed2 <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003e74:	4985                	li	s3,1
    80003e76:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003e7a:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003e7e:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003e82:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003e86:	00004597          	auipc	a1,0x4
    80003e8a:	7ca58593          	addi	a1,a1,1994 # 80008650 <syscalls+0x290>
    80003e8e:	00002097          	auipc	ra,0x2
    80003e92:	5de080e7          	jalr	1502(ra) # 8000646c <initlock>
  (*f0)->type = FD_PIPE;
    80003e96:	609c                	ld	a5,0(s1)
    80003e98:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003e9c:	609c                	ld	a5,0(s1)
    80003e9e:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003ea2:	609c                	ld	a5,0(s1)
    80003ea4:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003ea8:	609c                	ld	a5,0(s1)
    80003eaa:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003eae:	000a3783          	ld	a5,0(s4)
    80003eb2:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003eb6:	000a3783          	ld	a5,0(s4)
    80003eba:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003ebe:	000a3783          	ld	a5,0(s4)
    80003ec2:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003ec6:	000a3783          	ld	a5,0(s4)
    80003eca:	0127b823          	sd	s2,16(a5)
  return 0;
    80003ece:	4501                	li	a0,0
    80003ed0:	a025                	j	80003ef8 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003ed2:	6088                	ld	a0,0(s1)
    80003ed4:	e501                	bnez	a0,80003edc <pipealloc+0xaa>
    80003ed6:	a039                	j	80003ee4 <pipealloc+0xb2>
    80003ed8:	6088                	ld	a0,0(s1)
    80003eda:	c51d                	beqz	a0,80003f08 <pipealloc+0xd6>
    fileclose(*f0);
    80003edc:	00000097          	auipc	ra,0x0
    80003ee0:	bcc080e7          	jalr	-1076(ra) # 80003aa8 <fileclose>
  if(*f1)
    80003ee4:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003ee8:	557d                	li	a0,-1
  if(*f1)
    80003eea:	c799                	beqz	a5,80003ef8 <pipealloc+0xc6>
    fileclose(*f1);
    80003eec:	853e                	mv	a0,a5
    80003eee:	00000097          	auipc	ra,0x0
    80003ef2:	bba080e7          	jalr	-1094(ra) # 80003aa8 <fileclose>
  return -1;
    80003ef6:	557d                	li	a0,-1
}
    80003ef8:	70a2                	ld	ra,40(sp)
    80003efa:	7402                	ld	s0,32(sp)
    80003efc:	64e2                	ld	s1,24(sp)
    80003efe:	6942                	ld	s2,16(sp)
    80003f00:	69a2                	ld	s3,8(sp)
    80003f02:	6a02                	ld	s4,0(sp)
    80003f04:	6145                	addi	sp,sp,48
    80003f06:	8082                	ret
  return -1;
    80003f08:	557d                	li	a0,-1
    80003f0a:	b7fd                	j	80003ef8 <pipealloc+0xc6>

0000000080003f0c <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003f0c:	1101                	addi	sp,sp,-32
    80003f0e:	ec06                	sd	ra,24(sp)
    80003f10:	e822                	sd	s0,16(sp)
    80003f12:	e426                	sd	s1,8(sp)
    80003f14:	e04a                	sd	s2,0(sp)
    80003f16:	1000                	addi	s0,sp,32
    80003f18:	84aa                	mv	s1,a0
    80003f1a:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003f1c:	00002097          	auipc	ra,0x2
    80003f20:	5e0080e7          	jalr	1504(ra) # 800064fc <acquire>
  if(writable){
    80003f24:	02090d63          	beqz	s2,80003f5e <pipeclose+0x52>
    pi->writeopen = 0;
    80003f28:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003f2c:	21848513          	addi	a0,s1,536
    80003f30:	ffffd097          	auipc	ra,0xffffd
    80003f34:	67e080e7          	jalr	1662(ra) # 800015ae <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003f38:	2204b783          	ld	a5,544(s1)
    80003f3c:	eb95                	bnez	a5,80003f70 <pipeclose+0x64>
    release(&pi->lock);
    80003f3e:	8526                	mv	a0,s1
    80003f40:	00002097          	auipc	ra,0x2
    80003f44:	670080e7          	jalr	1648(ra) # 800065b0 <release>
    kfree((char*)pi);
    80003f48:	8526                	mv	a0,s1
    80003f4a:	ffffc097          	auipc	ra,0xffffc
    80003f4e:	0d2080e7          	jalr	210(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003f52:	60e2                	ld	ra,24(sp)
    80003f54:	6442                	ld	s0,16(sp)
    80003f56:	64a2                	ld	s1,8(sp)
    80003f58:	6902                	ld	s2,0(sp)
    80003f5a:	6105                	addi	sp,sp,32
    80003f5c:	8082                	ret
    pi->readopen = 0;
    80003f5e:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003f62:	21c48513          	addi	a0,s1,540
    80003f66:	ffffd097          	auipc	ra,0xffffd
    80003f6a:	648080e7          	jalr	1608(ra) # 800015ae <wakeup>
    80003f6e:	b7e9                	j	80003f38 <pipeclose+0x2c>
    release(&pi->lock);
    80003f70:	8526                	mv	a0,s1
    80003f72:	00002097          	auipc	ra,0x2
    80003f76:	63e080e7          	jalr	1598(ra) # 800065b0 <release>
}
    80003f7a:	bfe1                	j	80003f52 <pipeclose+0x46>

0000000080003f7c <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003f7c:	7159                	addi	sp,sp,-112
    80003f7e:	f486                	sd	ra,104(sp)
    80003f80:	f0a2                	sd	s0,96(sp)
    80003f82:	eca6                	sd	s1,88(sp)
    80003f84:	e8ca                	sd	s2,80(sp)
    80003f86:	e4ce                	sd	s3,72(sp)
    80003f88:	e0d2                	sd	s4,64(sp)
    80003f8a:	fc56                	sd	s5,56(sp)
    80003f8c:	f85a                	sd	s6,48(sp)
    80003f8e:	f45e                	sd	s7,40(sp)
    80003f90:	f062                	sd	s8,32(sp)
    80003f92:	ec66                	sd	s9,24(sp)
    80003f94:	1880                	addi	s0,sp,112
    80003f96:	84aa                	mv	s1,a0
    80003f98:	8aae                	mv	s5,a1
    80003f9a:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003f9c:	ffffd097          	auipc	ra,0xffffd
    80003fa0:	ea2080e7          	jalr	-350(ra) # 80000e3e <myproc>
    80003fa4:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003fa6:	8526                	mv	a0,s1
    80003fa8:	00002097          	auipc	ra,0x2
    80003fac:	554080e7          	jalr	1364(ra) # 800064fc <acquire>
  while(i < n){
    80003fb0:	0d405463          	blez	s4,80004078 <pipewrite+0xfc>
    80003fb4:	8ba6                	mv	s7,s1
  int i = 0;
    80003fb6:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80003fb8:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80003fba:	21848c93          	addi	s9,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80003fbe:	21c48c13          	addi	s8,s1,540
    80003fc2:	a08d                	j	80004024 <pipewrite+0xa8>
      release(&pi->lock);
    80003fc4:	8526                	mv	a0,s1
    80003fc6:	00002097          	auipc	ra,0x2
    80003fca:	5ea080e7          	jalr	1514(ra) # 800065b0 <release>
      return -1;
    80003fce:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80003fd0:	854a                	mv	a0,s2
    80003fd2:	70a6                	ld	ra,104(sp)
    80003fd4:	7406                	ld	s0,96(sp)
    80003fd6:	64e6                	ld	s1,88(sp)
    80003fd8:	6946                	ld	s2,80(sp)
    80003fda:	69a6                	ld	s3,72(sp)
    80003fdc:	6a06                	ld	s4,64(sp)
    80003fde:	7ae2                	ld	s5,56(sp)
    80003fe0:	7b42                	ld	s6,48(sp)
    80003fe2:	7ba2                	ld	s7,40(sp)
    80003fe4:	7c02                	ld	s8,32(sp)
    80003fe6:	6ce2                	ld	s9,24(sp)
    80003fe8:	6165                	addi	sp,sp,112
    80003fea:	8082                	ret
      wakeup(&pi->nread);
    80003fec:	8566                	mv	a0,s9
    80003fee:	ffffd097          	auipc	ra,0xffffd
    80003ff2:	5c0080e7          	jalr	1472(ra) # 800015ae <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    80003ff6:	85de                	mv	a1,s7
    80003ff8:	8562                	mv	a0,s8
    80003ffa:	ffffd097          	auipc	ra,0xffffd
    80003ffe:	550080e7          	jalr	1360(ra) # 8000154a <sleep>
    80004002:	a839                	j	80004020 <pipewrite+0xa4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    80004004:	21c4a783          	lw	a5,540(s1)
    80004008:	0017871b          	addiw	a4,a5,1
    8000400c:	20e4ae23          	sw	a4,540(s1)
    80004010:	1ff7f793          	andi	a5,a5,511
    80004014:	97a6                	add	a5,a5,s1
    80004016:	f9f44703          	lbu	a4,-97(s0)
    8000401a:	00e78c23          	sb	a4,24(a5)
      i++;
    8000401e:	2905                	addiw	s2,s2,1
  while(i < n){
    80004020:	05495063          	bge	s2,s4,80004060 <pipewrite+0xe4>
    if(pi->readopen == 0 || killed(pr)){
    80004024:	2204a783          	lw	a5,544(s1)
    80004028:	dfd1                	beqz	a5,80003fc4 <pipewrite+0x48>
    8000402a:	854e                	mv	a0,s3
    8000402c:	ffffd097          	auipc	ra,0xffffd
    80004030:	7c6080e7          	jalr	1990(ra) # 800017f2 <killed>
    80004034:	f941                	bnez	a0,80003fc4 <pipewrite+0x48>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    80004036:	2184a783          	lw	a5,536(s1)
    8000403a:	21c4a703          	lw	a4,540(s1)
    8000403e:	2007879b          	addiw	a5,a5,512
    80004042:	faf705e3          	beq	a4,a5,80003fec <pipewrite+0x70>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004046:	4685                	li	a3,1
    80004048:	01590633          	add	a2,s2,s5
    8000404c:	f9f40593          	addi	a1,s0,-97
    80004050:	0509b503          	ld	a0,80(s3)
    80004054:	ffffd097          	auipc	ra,0xffffd
    80004058:	b34080e7          	jalr	-1228(ra) # 80000b88 <copyin>
    8000405c:	fb6514e3          	bne	a0,s6,80004004 <pipewrite+0x88>
  wakeup(&pi->nread);
    80004060:	21848513          	addi	a0,s1,536
    80004064:	ffffd097          	auipc	ra,0xffffd
    80004068:	54a080e7          	jalr	1354(ra) # 800015ae <wakeup>
  release(&pi->lock);
    8000406c:	8526                	mv	a0,s1
    8000406e:	00002097          	auipc	ra,0x2
    80004072:	542080e7          	jalr	1346(ra) # 800065b0 <release>
  return i;
    80004076:	bfa9                	j	80003fd0 <pipewrite+0x54>
  int i = 0;
    80004078:	4901                	li	s2,0
    8000407a:	b7dd                	j	80004060 <pipewrite+0xe4>

000000008000407c <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    8000407c:	715d                	addi	sp,sp,-80
    8000407e:	e486                	sd	ra,72(sp)
    80004080:	e0a2                	sd	s0,64(sp)
    80004082:	fc26                	sd	s1,56(sp)
    80004084:	f84a                	sd	s2,48(sp)
    80004086:	f44e                	sd	s3,40(sp)
    80004088:	f052                	sd	s4,32(sp)
    8000408a:	ec56                	sd	s5,24(sp)
    8000408c:	e85a                	sd	s6,16(sp)
    8000408e:	0880                	addi	s0,sp,80
    80004090:	84aa                	mv	s1,a0
    80004092:	892e                	mv	s2,a1
    80004094:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    80004096:	ffffd097          	auipc	ra,0xffffd
    8000409a:	da8080e7          	jalr	-600(ra) # 80000e3e <myproc>
    8000409e:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800040a0:	8b26                	mv	s6,s1
    800040a2:	8526                	mv	a0,s1
    800040a4:	00002097          	auipc	ra,0x2
    800040a8:	458080e7          	jalr	1112(ra) # 800064fc <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800040ac:	2184a703          	lw	a4,536(s1)
    800040b0:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800040b4:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800040b8:	02f71763          	bne	a4,a5,800040e6 <piperead+0x6a>
    800040bc:	2244a783          	lw	a5,548(s1)
    800040c0:	c39d                	beqz	a5,800040e6 <piperead+0x6a>
    if(killed(pr)){
    800040c2:	8552                	mv	a0,s4
    800040c4:	ffffd097          	auipc	ra,0xffffd
    800040c8:	72e080e7          	jalr	1838(ra) # 800017f2 <killed>
    800040cc:	e941                	bnez	a0,8000415c <piperead+0xe0>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    800040ce:	85da                	mv	a1,s6
    800040d0:	854e                	mv	a0,s3
    800040d2:	ffffd097          	auipc	ra,0xffffd
    800040d6:	478080e7          	jalr	1144(ra) # 8000154a <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    800040da:	2184a703          	lw	a4,536(s1)
    800040de:	21c4a783          	lw	a5,540(s1)
    800040e2:	fcf70de3          	beq	a4,a5,800040bc <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800040e6:	09505263          	blez	s5,8000416a <piperead+0xee>
    800040ea:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    800040ec:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    800040ee:	2184a783          	lw	a5,536(s1)
    800040f2:	21c4a703          	lw	a4,540(s1)
    800040f6:	02f70d63          	beq	a4,a5,80004130 <piperead+0xb4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    800040fa:	0017871b          	addiw	a4,a5,1
    800040fe:	20e4ac23          	sw	a4,536(s1)
    80004102:	1ff7f793          	andi	a5,a5,511
    80004106:	97a6                	add	a5,a5,s1
    80004108:	0187c783          	lbu	a5,24(a5)
    8000410c:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004110:	4685                	li	a3,1
    80004112:	fbf40613          	addi	a2,s0,-65
    80004116:	85ca                	mv	a1,s2
    80004118:	050a3503          	ld	a0,80(s4)
    8000411c:	ffffd097          	auipc	ra,0xffffd
    80004120:	9e0080e7          	jalr	-1568(ra) # 80000afc <copyout>
    80004124:	01650663          	beq	a0,s6,80004130 <piperead+0xb4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004128:	2985                	addiw	s3,s3,1
    8000412a:	0905                	addi	s2,s2,1
    8000412c:	fd3a91e3          	bne	s5,s3,800040ee <piperead+0x72>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004130:	21c48513          	addi	a0,s1,540
    80004134:	ffffd097          	auipc	ra,0xffffd
    80004138:	47a080e7          	jalr	1146(ra) # 800015ae <wakeup>
  release(&pi->lock);
    8000413c:	8526                	mv	a0,s1
    8000413e:	00002097          	auipc	ra,0x2
    80004142:	472080e7          	jalr	1138(ra) # 800065b0 <release>
  return i;
}
    80004146:	854e                	mv	a0,s3
    80004148:	60a6                	ld	ra,72(sp)
    8000414a:	6406                	ld	s0,64(sp)
    8000414c:	74e2                	ld	s1,56(sp)
    8000414e:	7942                	ld	s2,48(sp)
    80004150:	79a2                	ld	s3,40(sp)
    80004152:	7a02                	ld	s4,32(sp)
    80004154:	6ae2                	ld	s5,24(sp)
    80004156:	6b42                	ld	s6,16(sp)
    80004158:	6161                	addi	sp,sp,80
    8000415a:	8082                	ret
      release(&pi->lock);
    8000415c:	8526                	mv	a0,s1
    8000415e:	00002097          	auipc	ra,0x2
    80004162:	452080e7          	jalr	1106(ra) # 800065b0 <release>
      return -1;
    80004166:	59fd                	li	s3,-1
    80004168:	bff9                	j	80004146 <piperead+0xca>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000416a:	4981                	li	s3,0
    8000416c:	b7d1                	j	80004130 <piperead+0xb4>

000000008000416e <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    8000416e:	1141                	addi	sp,sp,-16
    80004170:	e422                	sd	s0,8(sp)
    80004172:	0800                	addi	s0,sp,16
    80004174:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    80004176:	8905                	andi	a0,a0,1
    80004178:	c111                	beqz	a0,8000417c <flags2perm+0xe>
      perm = PTE_X;
    8000417a:	4521                	li	a0,8
    if(flags & 0x2)
    8000417c:	8b89                	andi	a5,a5,2
    8000417e:	c399                	beqz	a5,80004184 <flags2perm+0x16>
      perm |= PTE_W;
    80004180:	00456513          	ori	a0,a0,4
    return perm;
}
    80004184:	6422                	ld	s0,8(sp)
    80004186:	0141                	addi	sp,sp,16
    80004188:	8082                	ret

000000008000418a <exec>:

int
exec(char *path, char **argv)
{
    8000418a:	df010113          	addi	sp,sp,-528
    8000418e:	20113423          	sd	ra,520(sp)
    80004192:	20813023          	sd	s0,512(sp)
    80004196:	ffa6                	sd	s1,504(sp)
    80004198:	fbca                	sd	s2,496(sp)
    8000419a:	f7ce                	sd	s3,488(sp)
    8000419c:	f3d2                	sd	s4,480(sp)
    8000419e:	efd6                	sd	s5,472(sp)
    800041a0:	ebda                	sd	s6,464(sp)
    800041a2:	e7de                	sd	s7,456(sp)
    800041a4:	e3e2                	sd	s8,448(sp)
    800041a6:	ff66                	sd	s9,440(sp)
    800041a8:	fb6a                	sd	s10,432(sp)
    800041aa:	f76e                	sd	s11,424(sp)
    800041ac:	0c00                	addi	s0,sp,528
    800041ae:	84aa                	mv	s1,a0
    800041b0:	dea43c23          	sd	a0,-520(s0)
    800041b4:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    800041b8:	ffffd097          	auipc	ra,0xffffd
    800041bc:	c86080e7          	jalr	-890(ra) # 80000e3e <myproc>
    800041c0:	892a                	mv	s2,a0

  begin_op();
    800041c2:	fffff097          	auipc	ra,0xfffff
    800041c6:	41a080e7          	jalr	1050(ra) # 800035dc <begin_op>

  if((ip = namei(path)) == 0){
    800041ca:	8526                	mv	a0,s1
    800041cc:	fffff097          	auipc	ra,0xfffff
    800041d0:	1f4080e7          	jalr	500(ra) # 800033c0 <namei>
    800041d4:	c92d                	beqz	a0,80004246 <exec+0xbc>
    800041d6:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    800041d8:	fffff097          	auipc	ra,0xfffff
    800041dc:	a42080e7          	jalr	-1470(ra) # 80002c1a <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    800041e0:	04000713          	li	a4,64
    800041e4:	4681                	li	a3,0
    800041e6:	e5040613          	addi	a2,s0,-432
    800041ea:	4581                	li	a1,0
    800041ec:	8526                	mv	a0,s1
    800041ee:	fffff097          	auipc	ra,0xfffff
    800041f2:	ce0080e7          	jalr	-800(ra) # 80002ece <readi>
    800041f6:	04000793          	li	a5,64
    800041fa:	00f51a63          	bne	a0,a5,8000420e <exec+0x84>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    800041fe:	e5042703          	lw	a4,-432(s0)
    80004202:	464c47b7          	lui	a5,0x464c4
    80004206:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    8000420a:	04f70463          	beq	a4,a5,80004252 <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    8000420e:	8526                	mv	a0,s1
    80004210:	fffff097          	auipc	ra,0xfffff
    80004214:	c6c080e7          	jalr	-916(ra) # 80002e7c <iunlockput>
    end_op();
    80004218:	fffff097          	auipc	ra,0xfffff
    8000421c:	444080e7          	jalr	1092(ra) # 8000365c <end_op>
  }
  return -1;
    80004220:	557d                	li	a0,-1
}
    80004222:	20813083          	ld	ra,520(sp)
    80004226:	20013403          	ld	s0,512(sp)
    8000422a:	74fe                	ld	s1,504(sp)
    8000422c:	795e                	ld	s2,496(sp)
    8000422e:	79be                	ld	s3,488(sp)
    80004230:	7a1e                	ld	s4,480(sp)
    80004232:	6afe                	ld	s5,472(sp)
    80004234:	6b5e                	ld	s6,464(sp)
    80004236:	6bbe                	ld	s7,456(sp)
    80004238:	6c1e                	ld	s8,448(sp)
    8000423a:	7cfa                	ld	s9,440(sp)
    8000423c:	7d5a                	ld	s10,432(sp)
    8000423e:	7dba                	ld	s11,424(sp)
    80004240:	21010113          	addi	sp,sp,528
    80004244:	8082                	ret
    end_op();
    80004246:	fffff097          	auipc	ra,0xfffff
    8000424a:	416080e7          	jalr	1046(ra) # 8000365c <end_op>
    return -1;
    8000424e:	557d                	li	a0,-1
    80004250:	bfc9                	j	80004222 <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    80004252:	854a                	mv	a0,s2
    80004254:	ffffd097          	auipc	ra,0xffffd
    80004258:	cae080e7          	jalr	-850(ra) # 80000f02 <proc_pagetable>
    8000425c:	8baa                	mv	s7,a0
    8000425e:	d945                	beqz	a0,8000420e <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    80004260:	e7042983          	lw	s3,-400(s0)
    80004264:	e8845783          	lhu	a5,-376(s0)
    80004268:	c7ad                	beqz	a5,800042d2 <exec+0x148>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000426a:	4a01                	li	s4,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000426c:	4b01                	li	s6,0
    if(ph.vaddr % PGSIZE != 0)
    8000426e:	6c85                	lui	s9,0x1
    80004270:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    80004274:	def43823          	sd	a5,-528(s0)
    80004278:	ac0d                	j	800044aa <exec+0x320>
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    8000427a:	00004517          	auipc	a0,0x4
    8000427e:	3de50513          	addi	a0,a0,990 # 80008658 <syscalls+0x298>
    80004282:	00002097          	auipc	ra,0x2
    80004286:	d30080e7          	jalr	-720(ra) # 80005fb2 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    8000428a:	8756                	mv	a4,s5
    8000428c:	012d86bb          	addw	a3,s11,s2
    80004290:	4581                	li	a1,0
    80004292:	8526                	mv	a0,s1
    80004294:	fffff097          	auipc	ra,0xfffff
    80004298:	c3a080e7          	jalr	-966(ra) # 80002ece <readi>
    8000429c:	2501                	sext.w	a0,a0
    8000429e:	1aaa9a63          	bne	s5,a0,80004452 <exec+0x2c8>
  for(i = 0; i < sz; i += PGSIZE){
    800042a2:	6785                	lui	a5,0x1
    800042a4:	0127893b          	addw	s2,a5,s2
    800042a8:	77fd                	lui	a5,0xfffff
    800042aa:	01478a3b          	addw	s4,a5,s4
    800042ae:	1f897563          	bgeu	s2,s8,80004498 <exec+0x30e>
    pa = walkaddr(pagetable, va + i);
    800042b2:	02091593          	slli	a1,s2,0x20
    800042b6:	9181                	srli	a1,a1,0x20
    800042b8:	95ea                	add	a1,a1,s10
    800042ba:	855e                	mv	a0,s7
    800042bc:	ffffc097          	auipc	ra,0xffffc
    800042c0:	24e080e7          	jalr	590(ra) # 8000050a <walkaddr>
    800042c4:	862a                	mv	a2,a0
    if(pa == 0)
    800042c6:	d955                	beqz	a0,8000427a <exec+0xf0>
      n = PGSIZE;
    800042c8:	8ae6                	mv	s5,s9
    if(sz - i < PGSIZE)
    800042ca:	fd9a70e3          	bgeu	s4,s9,8000428a <exec+0x100>
      n = sz - i;
    800042ce:	8ad2                	mv	s5,s4
    800042d0:	bf6d                	j	8000428a <exec+0x100>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800042d2:	4a01                	li	s4,0
  iunlockput(ip);
    800042d4:	8526                	mv	a0,s1
    800042d6:	fffff097          	auipc	ra,0xfffff
    800042da:	ba6080e7          	jalr	-1114(ra) # 80002e7c <iunlockput>
  end_op();
    800042de:	fffff097          	auipc	ra,0xfffff
    800042e2:	37e080e7          	jalr	894(ra) # 8000365c <end_op>
  p = myproc();
    800042e6:	ffffd097          	auipc	ra,0xffffd
    800042ea:	b58080e7          	jalr	-1192(ra) # 80000e3e <myproc>
    800042ee:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    800042f0:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    800042f4:	6785                	lui	a5,0x1
    800042f6:	17fd                	addi	a5,a5,-1
    800042f8:	9a3e                	add	s4,s4,a5
    800042fa:	757d                	lui	a0,0xfffff
    800042fc:	00aa77b3          	and	a5,s4,a0
    80004300:	e0f43423          	sd	a5,-504(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80004304:	4691                	li	a3,4
    80004306:	6609                	lui	a2,0x2
    80004308:	963e                	add	a2,a2,a5
    8000430a:	85be                	mv	a1,a5
    8000430c:	855e                	mv	a0,s7
    8000430e:	ffffc097          	auipc	ra,0xffffc
    80004312:	5a2080e7          	jalr	1442(ra) # 800008b0 <uvmalloc>
    80004316:	8b2a                	mv	s6,a0
  ip = 0;
    80004318:	4481                	li	s1,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    8000431a:	12050c63          	beqz	a0,80004452 <exec+0x2c8>
  uvmclear(pagetable, sz-2*PGSIZE);
    8000431e:	75f9                	lui	a1,0xffffe
    80004320:	95aa                	add	a1,a1,a0
    80004322:	855e                	mv	a0,s7
    80004324:	ffffc097          	auipc	ra,0xffffc
    80004328:	7a6080e7          	jalr	1958(ra) # 80000aca <uvmclear>
  stackbase = sp - PGSIZE;
    8000432c:	7c7d                	lui	s8,0xfffff
    8000432e:	9c5a                	add	s8,s8,s6
  for(argc = 0; argv[argc]; argc++) {
    80004330:	e0043783          	ld	a5,-512(s0)
    80004334:	6388                	ld	a0,0(a5)
    80004336:	c535                	beqz	a0,800043a2 <exec+0x218>
    80004338:	e9040993          	addi	s3,s0,-368
    8000433c:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    80004340:	895a                	mv	s2,s6
    sp -= strlen(argv[argc]) + 1;
    80004342:	ffffc097          	auipc	ra,0xffffc
    80004346:	fba080e7          	jalr	-70(ra) # 800002fc <strlen>
    8000434a:	2505                	addiw	a0,a0,1
    8000434c:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    80004350:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    80004354:	13896663          	bltu	s2,s8,80004480 <exec+0x2f6>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    80004358:	e0043d83          	ld	s11,-512(s0)
    8000435c:	000dba03          	ld	s4,0(s11)
    80004360:	8552                	mv	a0,s4
    80004362:	ffffc097          	auipc	ra,0xffffc
    80004366:	f9a080e7          	jalr	-102(ra) # 800002fc <strlen>
    8000436a:	0015069b          	addiw	a3,a0,1
    8000436e:	8652                	mv	a2,s4
    80004370:	85ca                	mv	a1,s2
    80004372:	855e                	mv	a0,s7
    80004374:	ffffc097          	auipc	ra,0xffffc
    80004378:	788080e7          	jalr	1928(ra) # 80000afc <copyout>
    8000437c:	10054663          	bltz	a0,80004488 <exec+0x2fe>
    ustack[argc] = sp;
    80004380:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    80004384:	0485                	addi	s1,s1,1
    80004386:	008d8793          	addi	a5,s11,8
    8000438a:	e0f43023          	sd	a5,-512(s0)
    8000438e:	008db503          	ld	a0,8(s11)
    80004392:	c911                	beqz	a0,800043a6 <exec+0x21c>
    if(argc >= MAXARG)
    80004394:	09a1                	addi	s3,s3,8
    80004396:	fb3c96e3          	bne	s9,s3,80004342 <exec+0x1b8>
  sz = sz1;
    8000439a:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    8000439e:	4481                	li	s1,0
    800043a0:	a84d                	j	80004452 <exec+0x2c8>
  sp = sz;
    800043a2:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    800043a4:	4481                	li	s1,0
  ustack[argc] = 0;
    800043a6:	00349793          	slli	a5,s1,0x3
    800043aa:	f9040713          	addi	a4,s0,-112
    800043ae:	97ba                	add	a5,a5,a4
    800043b0:	f007b023          	sd	zero,-256(a5) # f00 <_entry-0x7ffff100>
  sp -= (argc+1) * sizeof(uint64);
    800043b4:	00148693          	addi	a3,s1,1
    800043b8:	068e                	slli	a3,a3,0x3
    800043ba:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    800043be:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    800043c2:	01897663          	bgeu	s2,s8,800043ce <exec+0x244>
  sz = sz1;
    800043c6:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800043ca:	4481                	li	s1,0
    800043cc:	a059                	j	80004452 <exec+0x2c8>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    800043ce:	e9040613          	addi	a2,s0,-368
    800043d2:	85ca                	mv	a1,s2
    800043d4:	855e                	mv	a0,s7
    800043d6:	ffffc097          	auipc	ra,0xffffc
    800043da:	726080e7          	jalr	1830(ra) # 80000afc <copyout>
    800043de:	0a054963          	bltz	a0,80004490 <exec+0x306>
  p->trapframe->a1 = sp;
    800043e2:	058ab783          	ld	a5,88(s5)
    800043e6:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    800043ea:	df843783          	ld	a5,-520(s0)
    800043ee:	0007c703          	lbu	a4,0(a5)
    800043f2:	cf11                	beqz	a4,8000440e <exec+0x284>
    800043f4:	0785                	addi	a5,a5,1
    if(*s == '/')
    800043f6:	02f00693          	li	a3,47
    800043fa:	a039                	j	80004408 <exec+0x27e>
      last = s+1;
    800043fc:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80004400:	0785                	addi	a5,a5,1
    80004402:	fff7c703          	lbu	a4,-1(a5)
    80004406:	c701                	beqz	a4,8000440e <exec+0x284>
    if(*s == '/')
    80004408:	fed71ce3          	bne	a4,a3,80004400 <exec+0x276>
    8000440c:	bfc5                	j	800043fc <exec+0x272>
  safestrcpy(p->name, last, sizeof(p->name));
    8000440e:	4641                	li	a2,16
    80004410:	df843583          	ld	a1,-520(s0)
    80004414:	158a8513          	addi	a0,s5,344
    80004418:	ffffc097          	auipc	ra,0xffffc
    8000441c:	eb2080e7          	jalr	-334(ra) # 800002ca <safestrcpy>
  oldpagetable = p->pagetable;
    80004420:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    80004424:	057ab823          	sd	s7,80(s5)
  p->sz = sz;
    80004428:	056ab423          	sd	s6,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    8000442c:	058ab783          	ld	a5,88(s5)
    80004430:	e6843703          	ld	a4,-408(s0)
    80004434:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    80004436:	058ab783          	ld	a5,88(s5)
    8000443a:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    8000443e:	85ea                	mv	a1,s10
    80004440:	ffffd097          	auipc	ra,0xffffd
    80004444:	b5e080e7          	jalr	-1186(ra) # 80000f9e <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    80004448:	0004851b          	sext.w	a0,s1
    8000444c:	bbd9                	j	80004222 <exec+0x98>
    8000444e:	e1443423          	sd	s4,-504(s0)
    proc_freepagetable(pagetable, sz);
    80004452:	e0843583          	ld	a1,-504(s0)
    80004456:	855e                	mv	a0,s7
    80004458:	ffffd097          	auipc	ra,0xffffd
    8000445c:	b46080e7          	jalr	-1210(ra) # 80000f9e <proc_freepagetable>
  if(ip){
    80004460:	da0497e3          	bnez	s1,8000420e <exec+0x84>
  return -1;
    80004464:	557d                	li	a0,-1
    80004466:	bb75                	j	80004222 <exec+0x98>
    80004468:	e1443423          	sd	s4,-504(s0)
    8000446c:	b7dd                	j	80004452 <exec+0x2c8>
    8000446e:	e1443423          	sd	s4,-504(s0)
    80004472:	b7c5                	j	80004452 <exec+0x2c8>
    80004474:	e1443423          	sd	s4,-504(s0)
    80004478:	bfe9                	j	80004452 <exec+0x2c8>
    8000447a:	e1443423          	sd	s4,-504(s0)
    8000447e:	bfd1                	j	80004452 <exec+0x2c8>
  sz = sz1;
    80004480:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004484:	4481                	li	s1,0
    80004486:	b7f1                	j	80004452 <exec+0x2c8>
  sz = sz1;
    80004488:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    8000448c:	4481                	li	s1,0
    8000448e:	b7d1                	j	80004452 <exec+0x2c8>
  sz = sz1;
    80004490:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004494:	4481                	li	s1,0
    80004496:	bf75                	j	80004452 <exec+0x2c8>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    80004498:	e0843a03          	ld	s4,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    8000449c:	2b05                	addiw	s6,s6,1
    8000449e:	0389899b          	addiw	s3,s3,56
    800044a2:	e8845783          	lhu	a5,-376(s0)
    800044a6:	e2fb57e3          	bge	s6,a5,800042d4 <exec+0x14a>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    800044aa:	2981                	sext.w	s3,s3
    800044ac:	03800713          	li	a4,56
    800044b0:	86ce                	mv	a3,s3
    800044b2:	e1840613          	addi	a2,s0,-488
    800044b6:	4581                	li	a1,0
    800044b8:	8526                	mv	a0,s1
    800044ba:	fffff097          	auipc	ra,0xfffff
    800044be:	a14080e7          	jalr	-1516(ra) # 80002ece <readi>
    800044c2:	03800793          	li	a5,56
    800044c6:	f8f514e3          	bne	a0,a5,8000444e <exec+0x2c4>
    if(ph.type != ELF_PROG_LOAD)
    800044ca:	e1842783          	lw	a5,-488(s0)
    800044ce:	4705                	li	a4,1
    800044d0:	fce796e3          	bne	a5,a4,8000449c <exec+0x312>
    if(ph.memsz < ph.filesz)
    800044d4:	e4043903          	ld	s2,-448(s0)
    800044d8:	e3843783          	ld	a5,-456(s0)
    800044dc:	f8f966e3          	bltu	s2,a5,80004468 <exec+0x2de>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    800044e0:	e2843783          	ld	a5,-472(s0)
    800044e4:	993e                	add	s2,s2,a5
    800044e6:	f8f964e3          	bltu	s2,a5,8000446e <exec+0x2e4>
    if(ph.vaddr % PGSIZE != 0)
    800044ea:	df043703          	ld	a4,-528(s0)
    800044ee:	8ff9                	and	a5,a5,a4
    800044f0:	f3d1                	bnez	a5,80004474 <exec+0x2ea>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800044f2:	e1c42503          	lw	a0,-484(s0)
    800044f6:	00000097          	auipc	ra,0x0
    800044fa:	c78080e7          	jalr	-904(ra) # 8000416e <flags2perm>
    800044fe:	86aa                	mv	a3,a0
    80004500:	864a                	mv	a2,s2
    80004502:	85d2                	mv	a1,s4
    80004504:	855e                	mv	a0,s7
    80004506:	ffffc097          	auipc	ra,0xffffc
    8000450a:	3aa080e7          	jalr	938(ra) # 800008b0 <uvmalloc>
    8000450e:	e0a43423          	sd	a0,-504(s0)
    80004512:	d525                	beqz	a0,8000447a <exec+0x2f0>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    80004514:	e2843d03          	ld	s10,-472(s0)
    80004518:	e2042d83          	lw	s11,-480(s0)
    8000451c:	e3842c03          	lw	s8,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004520:	f60c0ce3          	beqz	s8,80004498 <exec+0x30e>
    80004524:	8a62                	mv	s4,s8
    80004526:	4901                	li	s2,0
    80004528:	b369                	j	800042b2 <exec+0x128>

000000008000452a <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    8000452a:	7179                	addi	sp,sp,-48
    8000452c:	f406                	sd	ra,40(sp)
    8000452e:	f022                	sd	s0,32(sp)
    80004530:	ec26                	sd	s1,24(sp)
    80004532:	e84a                	sd	s2,16(sp)
    80004534:	1800                	addi	s0,sp,48
    80004536:	892e                	mv	s2,a1
    80004538:	84b2                	mv	s1,a2
    int fd;
    struct file *f;

    argint(n, &fd);
    8000453a:	fdc40593          	addi	a1,s0,-36
    8000453e:	ffffe097          	auipc	ra,0xffffe
    80004542:	b62080e7          	jalr	-1182(ra) # 800020a0 <argint>
    if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0)
    80004546:	fdc42703          	lw	a4,-36(s0)
    8000454a:	47bd                	li	a5,15
    8000454c:	02e7eb63          	bltu	a5,a4,80004582 <argfd+0x58>
    80004550:	ffffd097          	auipc	ra,0xffffd
    80004554:	8ee080e7          	jalr	-1810(ra) # 80000e3e <myproc>
    80004558:	fdc42703          	lw	a4,-36(s0)
    8000455c:	01a70793          	addi	a5,a4,26
    80004560:	078e                	slli	a5,a5,0x3
    80004562:	953e                	add	a0,a0,a5
    80004564:	611c                	ld	a5,0(a0)
    80004566:	c385                	beqz	a5,80004586 <argfd+0x5c>
        return -1;
    if (pfd)
    80004568:	00090463          	beqz	s2,80004570 <argfd+0x46>
        *pfd = fd;
    8000456c:	00e92023          	sw	a4,0(s2)
    if (pf)
        *pf = f;
    return 0;
    80004570:	4501                	li	a0,0
    if (pf)
    80004572:	c091                	beqz	s1,80004576 <argfd+0x4c>
        *pf = f;
    80004574:	e09c                	sd	a5,0(s1)
}
    80004576:	70a2                	ld	ra,40(sp)
    80004578:	7402                	ld	s0,32(sp)
    8000457a:	64e2                	ld	s1,24(sp)
    8000457c:	6942                	ld	s2,16(sp)
    8000457e:	6145                	addi	sp,sp,48
    80004580:	8082                	ret
        return -1;
    80004582:	557d                	li	a0,-1
    80004584:	bfcd                	j	80004576 <argfd+0x4c>
    80004586:	557d                	li	a0,-1
    80004588:	b7fd                	j	80004576 <argfd+0x4c>

000000008000458a <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    8000458a:	1101                	addi	sp,sp,-32
    8000458c:	ec06                	sd	ra,24(sp)
    8000458e:	e822                	sd	s0,16(sp)
    80004590:	e426                	sd	s1,8(sp)
    80004592:	1000                	addi	s0,sp,32
    80004594:	84aa                	mv	s1,a0
    int fd;
    struct proc *p = myproc();
    80004596:	ffffd097          	auipc	ra,0xffffd
    8000459a:	8a8080e7          	jalr	-1880(ra) # 80000e3e <myproc>
    8000459e:	862a                	mv	a2,a0

    for (fd = 0; fd < NOFILE; fd++)
    800045a0:	0d050793          	addi	a5,a0,208 # fffffffffffff0d0 <end+0xffffffff7ffcb360>
    800045a4:	4501                	li	a0,0
    800045a6:	46c1                	li	a3,16
    {
        if (p->ofile[fd] == 0)
    800045a8:	6398                	ld	a4,0(a5)
    800045aa:	cb19                	beqz	a4,800045c0 <fdalloc+0x36>
    for (fd = 0; fd < NOFILE; fd++)
    800045ac:	2505                	addiw	a0,a0,1
    800045ae:	07a1                	addi	a5,a5,8
    800045b0:	fed51ce3          	bne	a0,a3,800045a8 <fdalloc+0x1e>
        {
            p->ofile[fd] = f;
            return fd;
        }
    }
    return -1;
    800045b4:	557d                	li	a0,-1
}
    800045b6:	60e2                	ld	ra,24(sp)
    800045b8:	6442                	ld	s0,16(sp)
    800045ba:	64a2                	ld	s1,8(sp)
    800045bc:	6105                	addi	sp,sp,32
    800045be:	8082                	ret
            p->ofile[fd] = f;
    800045c0:	01a50793          	addi	a5,a0,26
    800045c4:	078e                	slli	a5,a5,0x3
    800045c6:	963e                	add	a2,a2,a5
    800045c8:	e204                	sd	s1,0(a2)
            return fd;
    800045ca:	b7f5                	j	800045b6 <fdalloc+0x2c>

00000000800045cc <create>:
    }
}

static struct inode *
create(char *path, short type, short major, short minor)
{
    800045cc:	715d                	addi	sp,sp,-80
    800045ce:	e486                	sd	ra,72(sp)
    800045d0:	e0a2                	sd	s0,64(sp)
    800045d2:	fc26                	sd	s1,56(sp)
    800045d4:	f84a                	sd	s2,48(sp)
    800045d6:	f44e                	sd	s3,40(sp)
    800045d8:	f052                	sd	s4,32(sp)
    800045da:	ec56                	sd	s5,24(sp)
    800045dc:	e85a                	sd	s6,16(sp)
    800045de:	0880                	addi	s0,sp,80
    800045e0:	8b2e                	mv	s6,a1
    800045e2:	89b2                	mv	s3,a2
    800045e4:	8936                	mv	s2,a3
    struct inode *ip, *dp;
    char name[DIRSIZ];

    if ((dp = nameiparent(path, name)) == 0)
    800045e6:	fb040593          	addi	a1,s0,-80
    800045ea:	fffff097          	auipc	ra,0xfffff
    800045ee:	df4080e7          	jalr	-524(ra) # 800033de <nameiparent>
    800045f2:	84aa                	mv	s1,a0
    800045f4:	16050063          	beqz	a0,80004754 <create+0x188>
        return 0;

    ilock(dp);
    800045f8:	ffffe097          	auipc	ra,0xffffe
    800045fc:	622080e7          	jalr	1570(ra) # 80002c1a <ilock>

    if ((ip = dirlookup(dp, name, 0)) != 0)
    80004600:	4601                	li	a2,0
    80004602:	fb040593          	addi	a1,s0,-80
    80004606:	8526                	mv	a0,s1
    80004608:	fffff097          	auipc	ra,0xfffff
    8000460c:	af6080e7          	jalr	-1290(ra) # 800030fe <dirlookup>
    80004610:	8aaa                	mv	s5,a0
    80004612:	c931                	beqz	a0,80004666 <create+0x9a>
    {
        iunlockput(dp);
    80004614:	8526                	mv	a0,s1
    80004616:	fffff097          	auipc	ra,0xfffff
    8000461a:	866080e7          	jalr	-1946(ra) # 80002e7c <iunlockput>
        ilock(ip);
    8000461e:	8556                	mv	a0,s5
    80004620:	ffffe097          	auipc	ra,0xffffe
    80004624:	5fa080e7          	jalr	1530(ra) # 80002c1a <ilock>
        if (type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004628:	000b059b          	sext.w	a1,s6
    8000462c:	4789                	li	a5,2
    8000462e:	02f59563          	bne	a1,a5,80004658 <create+0x8c>
    80004632:	044ad783          	lhu	a5,68(s5)
    80004636:	37f9                	addiw	a5,a5,-2
    80004638:	17c2                	slli	a5,a5,0x30
    8000463a:	93c1                	srli	a5,a5,0x30
    8000463c:	4705                	li	a4,1
    8000463e:	00f76d63          	bltu	a4,a5,80004658 <create+0x8c>
    ip->nlink = 0;
    iupdate(ip);
    iunlockput(ip);
    iunlockput(dp);
    return 0;
}
    80004642:	8556                	mv	a0,s5
    80004644:	60a6                	ld	ra,72(sp)
    80004646:	6406                	ld	s0,64(sp)
    80004648:	74e2                	ld	s1,56(sp)
    8000464a:	7942                	ld	s2,48(sp)
    8000464c:	79a2                	ld	s3,40(sp)
    8000464e:	7a02                	ld	s4,32(sp)
    80004650:	6ae2                	ld	s5,24(sp)
    80004652:	6b42                	ld	s6,16(sp)
    80004654:	6161                	addi	sp,sp,80
    80004656:	8082                	ret
        iunlockput(ip);
    80004658:	8556                	mv	a0,s5
    8000465a:	fffff097          	auipc	ra,0xfffff
    8000465e:	822080e7          	jalr	-2014(ra) # 80002e7c <iunlockput>
        return 0;
    80004662:	4a81                	li	s5,0
    80004664:	bff9                	j	80004642 <create+0x76>
    if ((ip = ialloc(dp->dev, type)) == 0)
    80004666:	85da                	mv	a1,s6
    80004668:	4088                	lw	a0,0(s1)
    8000466a:	ffffe097          	auipc	ra,0xffffe
    8000466e:	414080e7          	jalr	1044(ra) # 80002a7e <ialloc>
    80004672:	8a2a                	mv	s4,a0
    80004674:	c921                	beqz	a0,800046c4 <create+0xf8>
    ilock(ip);
    80004676:	ffffe097          	auipc	ra,0xffffe
    8000467a:	5a4080e7          	jalr	1444(ra) # 80002c1a <ilock>
    ip->major = major;
    8000467e:	053a1323          	sh	s3,70(s4)
    ip->minor = minor;
    80004682:	052a1423          	sh	s2,72(s4)
    ip->nlink = 1;
    80004686:	4785                	li	a5,1
    80004688:	04fa1523          	sh	a5,74(s4)
    iupdate(ip);
    8000468c:	8552                	mv	a0,s4
    8000468e:	ffffe097          	auipc	ra,0xffffe
    80004692:	4c2080e7          	jalr	1218(ra) # 80002b50 <iupdate>
    if (type == T_DIR)
    80004696:	000b059b          	sext.w	a1,s6
    8000469a:	4785                	li	a5,1
    8000469c:	02f58b63          	beq	a1,a5,800046d2 <create+0x106>
    if (dirlink(dp, name, ip->inum) < 0)
    800046a0:	004a2603          	lw	a2,4(s4)
    800046a4:	fb040593          	addi	a1,s0,-80
    800046a8:	8526                	mv	a0,s1
    800046aa:	fffff097          	auipc	ra,0xfffff
    800046ae:	c64080e7          	jalr	-924(ra) # 8000330e <dirlink>
    800046b2:	06054f63          	bltz	a0,80004730 <create+0x164>
    iunlockput(dp);
    800046b6:	8526                	mv	a0,s1
    800046b8:	ffffe097          	auipc	ra,0xffffe
    800046bc:	7c4080e7          	jalr	1988(ra) # 80002e7c <iunlockput>
    return ip;
    800046c0:	8ad2                	mv	s5,s4
    800046c2:	b741                	j	80004642 <create+0x76>
        iunlockput(dp);
    800046c4:	8526                	mv	a0,s1
    800046c6:	ffffe097          	auipc	ra,0xffffe
    800046ca:	7b6080e7          	jalr	1974(ra) # 80002e7c <iunlockput>
        return 0;
    800046ce:	8ad2                	mv	s5,s4
    800046d0:	bf8d                	j	80004642 <create+0x76>
        if (dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    800046d2:	004a2603          	lw	a2,4(s4)
    800046d6:	00004597          	auipc	a1,0x4
    800046da:	fa258593          	addi	a1,a1,-94 # 80008678 <syscalls+0x2b8>
    800046de:	8552                	mv	a0,s4
    800046e0:	fffff097          	auipc	ra,0xfffff
    800046e4:	c2e080e7          	jalr	-978(ra) # 8000330e <dirlink>
    800046e8:	04054463          	bltz	a0,80004730 <create+0x164>
    800046ec:	40d0                	lw	a2,4(s1)
    800046ee:	00004597          	auipc	a1,0x4
    800046f2:	f9258593          	addi	a1,a1,-110 # 80008680 <syscalls+0x2c0>
    800046f6:	8552                	mv	a0,s4
    800046f8:	fffff097          	auipc	ra,0xfffff
    800046fc:	c16080e7          	jalr	-1002(ra) # 8000330e <dirlink>
    80004700:	02054863          	bltz	a0,80004730 <create+0x164>
    if (dirlink(dp, name, ip->inum) < 0)
    80004704:	004a2603          	lw	a2,4(s4)
    80004708:	fb040593          	addi	a1,s0,-80
    8000470c:	8526                	mv	a0,s1
    8000470e:	fffff097          	auipc	ra,0xfffff
    80004712:	c00080e7          	jalr	-1024(ra) # 8000330e <dirlink>
    80004716:	00054d63          	bltz	a0,80004730 <create+0x164>
        dp->nlink++; // for ".."
    8000471a:	04a4d783          	lhu	a5,74(s1)
    8000471e:	2785                	addiw	a5,a5,1
    80004720:	04f49523          	sh	a5,74(s1)
        iupdate(dp);
    80004724:	8526                	mv	a0,s1
    80004726:	ffffe097          	auipc	ra,0xffffe
    8000472a:	42a080e7          	jalr	1066(ra) # 80002b50 <iupdate>
    8000472e:	b761                	j	800046b6 <create+0xea>
    ip->nlink = 0;
    80004730:	040a1523          	sh	zero,74(s4)
    iupdate(ip);
    80004734:	8552                	mv	a0,s4
    80004736:	ffffe097          	auipc	ra,0xffffe
    8000473a:	41a080e7          	jalr	1050(ra) # 80002b50 <iupdate>
    iunlockput(ip);
    8000473e:	8552                	mv	a0,s4
    80004740:	ffffe097          	auipc	ra,0xffffe
    80004744:	73c080e7          	jalr	1852(ra) # 80002e7c <iunlockput>
    iunlockput(dp);
    80004748:	8526                	mv	a0,s1
    8000474a:	ffffe097          	auipc	ra,0xffffe
    8000474e:	732080e7          	jalr	1842(ra) # 80002e7c <iunlockput>
    return 0;
    80004752:	bdc5                	j	80004642 <create+0x76>
        return 0;
    80004754:	8aaa                	mv	s5,a0
    80004756:	b5f5                	j	80004642 <create+0x76>

0000000080004758 <sys_dup>:
{
    80004758:	7179                	addi	sp,sp,-48
    8000475a:	f406                	sd	ra,40(sp)
    8000475c:	f022                	sd	s0,32(sp)
    8000475e:	ec26                	sd	s1,24(sp)
    80004760:	1800                	addi	s0,sp,48
    if (argfd(0, 0, &f) < 0)
    80004762:	fd840613          	addi	a2,s0,-40
    80004766:	4581                	li	a1,0
    80004768:	4501                	li	a0,0
    8000476a:	00000097          	auipc	ra,0x0
    8000476e:	dc0080e7          	jalr	-576(ra) # 8000452a <argfd>
        return -1;
    80004772:	57fd                	li	a5,-1
    if (argfd(0, 0, &f) < 0)
    80004774:	02054363          	bltz	a0,8000479a <sys_dup+0x42>
    if ((fd = fdalloc(f)) < 0)
    80004778:	fd843503          	ld	a0,-40(s0)
    8000477c:	00000097          	auipc	ra,0x0
    80004780:	e0e080e7          	jalr	-498(ra) # 8000458a <fdalloc>
    80004784:	84aa                	mv	s1,a0
        return -1;
    80004786:	57fd                	li	a5,-1
    if ((fd = fdalloc(f)) < 0)
    80004788:	00054963          	bltz	a0,8000479a <sys_dup+0x42>
    filedup(f);
    8000478c:	fd843503          	ld	a0,-40(s0)
    80004790:	fffff097          	auipc	ra,0xfffff
    80004794:	2c6080e7          	jalr	710(ra) # 80003a56 <filedup>
    return fd;
    80004798:	87a6                	mv	a5,s1
}
    8000479a:	853e                	mv	a0,a5
    8000479c:	70a2                	ld	ra,40(sp)
    8000479e:	7402                	ld	s0,32(sp)
    800047a0:	64e2                	ld	s1,24(sp)
    800047a2:	6145                	addi	sp,sp,48
    800047a4:	8082                	ret

00000000800047a6 <sys_read>:
{
    800047a6:	7179                	addi	sp,sp,-48
    800047a8:	f406                	sd	ra,40(sp)
    800047aa:	f022                	sd	s0,32(sp)
    800047ac:	1800                	addi	s0,sp,48
    argaddr(1, &p);
    800047ae:	fd840593          	addi	a1,s0,-40
    800047b2:	4505                	li	a0,1
    800047b4:	ffffe097          	auipc	ra,0xffffe
    800047b8:	90c080e7          	jalr	-1780(ra) # 800020c0 <argaddr>
    argint(2, &n);
    800047bc:	fe440593          	addi	a1,s0,-28
    800047c0:	4509                	li	a0,2
    800047c2:	ffffe097          	auipc	ra,0xffffe
    800047c6:	8de080e7          	jalr	-1826(ra) # 800020a0 <argint>
    if (argfd(0, 0, &f) < 0)
    800047ca:	fe840613          	addi	a2,s0,-24
    800047ce:	4581                	li	a1,0
    800047d0:	4501                	li	a0,0
    800047d2:	00000097          	auipc	ra,0x0
    800047d6:	d58080e7          	jalr	-680(ra) # 8000452a <argfd>
    800047da:	87aa                	mv	a5,a0
        return -1;
    800047dc:	557d                	li	a0,-1
    if (argfd(0, 0, &f) < 0)
    800047de:	0007cc63          	bltz	a5,800047f6 <sys_read+0x50>
    return fileread(f, p, n);
    800047e2:	fe442603          	lw	a2,-28(s0)
    800047e6:	fd843583          	ld	a1,-40(s0)
    800047ea:	fe843503          	ld	a0,-24(s0)
    800047ee:	fffff097          	auipc	ra,0xfffff
    800047f2:	44e080e7          	jalr	1102(ra) # 80003c3c <fileread>
}
    800047f6:	70a2                	ld	ra,40(sp)
    800047f8:	7402                	ld	s0,32(sp)
    800047fa:	6145                	addi	sp,sp,48
    800047fc:	8082                	ret

00000000800047fe <sys_write>:
{
    800047fe:	7179                	addi	sp,sp,-48
    80004800:	f406                	sd	ra,40(sp)
    80004802:	f022                	sd	s0,32(sp)
    80004804:	1800                	addi	s0,sp,48
    argaddr(1, &p);
    80004806:	fd840593          	addi	a1,s0,-40
    8000480a:	4505                	li	a0,1
    8000480c:	ffffe097          	auipc	ra,0xffffe
    80004810:	8b4080e7          	jalr	-1868(ra) # 800020c0 <argaddr>
    argint(2, &n);
    80004814:	fe440593          	addi	a1,s0,-28
    80004818:	4509                	li	a0,2
    8000481a:	ffffe097          	auipc	ra,0xffffe
    8000481e:	886080e7          	jalr	-1914(ra) # 800020a0 <argint>
    if (argfd(0, 0, &f) < 0)
    80004822:	fe840613          	addi	a2,s0,-24
    80004826:	4581                	li	a1,0
    80004828:	4501                	li	a0,0
    8000482a:	00000097          	auipc	ra,0x0
    8000482e:	d00080e7          	jalr	-768(ra) # 8000452a <argfd>
    80004832:	87aa                	mv	a5,a0
        return -1;
    80004834:	557d                	li	a0,-1
    if (argfd(0, 0, &f) < 0)
    80004836:	0007cc63          	bltz	a5,8000484e <sys_write+0x50>
    return filewrite(f, p, n);
    8000483a:	fe442603          	lw	a2,-28(s0)
    8000483e:	fd843583          	ld	a1,-40(s0)
    80004842:	fe843503          	ld	a0,-24(s0)
    80004846:	fffff097          	auipc	ra,0xfffff
    8000484a:	4b8080e7          	jalr	1208(ra) # 80003cfe <filewrite>
}
    8000484e:	70a2                	ld	ra,40(sp)
    80004850:	7402                	ld	s0,32(sp)
    80004852:	6145                	addi	sp,sp,48
    80004854:	8082                	ret

0000000080004856 <sys_close>:
{
    80004856:	1101                	addi	sp,sp,-32
    80004858:	ec06                	sd	ra,24(sp)
    8000485a:	e822                	sd	s0,16(sp)
    8000485c:	1000                	addi	s0,sp,32
    if (argfd(0, &fd, &f) < 0)
    8000485e:	fe040613          	addi	a2,s0,-32
    80004862:	fec40593          	addi	a1,s0,-20
    80004866:	4501                	li	a0,0
    80004868:	00000097          	auipc	ra,0x0
    8000486c:	cc2080e7          	jalr	-830(ra) # 8000452a <argfd>
        return -1;
    80004870:	57fd                	li	a5,-1
    if (argfd(0, &fd, &f) < 0)
    80004872:	02054463          	bltz	a0,8000489a <sys_close+0x44>
    myproc()->ofile[fd] = 0;
    80004876:	ffffc097          	auipc	ra,0xffffc
    8000487a:	5c8080e7          	jalr	1480(ra) # 80000e3e <myproc>
    8000487e:	fec42783          	lw	a5,-20(s0)
    80004882:	07e9                	addi	a5,a5,26
    80004884:	078e                	slli	a5,a5,0x3
    80004886:	97aa                	add	a5,a5,a0
    80004888:	0007b023          	sd	zero,0(a5)
    fileclose(f);
    8000488c:	fe043503          	ld	a0,-32(s0)
    80004890:	fffff097          	auipc	ra,0xfffff
    80004894:	218080e7          	jalr	536(ra) # 80003aa8 <fileclose>
    return 0;
    80004898:	4781                	li	a5,0
}
    8000489a:	853e                	mv	a0,a5
    8000489c:	60e2                	ld	ra,24(sp)
    8000489e:	6442                	ld	s0,16(sp)
    800048a0:	6105                	addi	sp,sp,32
    800048a2:	8082                	ret

00000000800048a4 <sys_fstat>:
{
    800048a4:	1101                	addi	sp,sp,-32
    800048a6:	ec06                	sd	ra,24(sp)
    800048a8:	e822                	sd	s0,16(sp)
    800048aa:	1000                	addi	s0,sp,32
    argaddr(1, &st);
    800048ac:	fe040593          	addi	a1,s0,-32
    800048b0:	4505                	li	a0,1
    800048b2:	ffffe097          	auipc	ra,0xffffe
    800048b6:	80e080e7          	jalr	-2034(ra) # 800020c0 <argaddr>
    if (argfd(0, 0, &f) < 0)
    800048ba:	fe840613          	addi	a2,s0,-24
    800048be:	4581                	li	a1,0
    800048c0:	4501                	li	a0,0
    800048c2:	00000097          	auipc	ra,0x0
    800048c6:	c68080e7          	jalr	-920(ra) # 8000452a <argfd>
    800048ca:	87aa                	mv	a5,a0
        return -1;
    800048cc:	557d                	li	a0,-1
    if (argfd(0, 0, &f) < 0)
    800048ce:	0007ca63          	bltz	a5,800048e2 <sys_fstat+0x3e>
    return filestat(f, st);
    800048d2:	fe043583          	ld	a1,-32(s0)
    800048d6:	fe843503          	ld	a0,-24(s0)
    800048da:	fffff097          	auipc	ra,0xfffff
    800048de:	296080e7          	jalr	662(ra) # 80003b70 <filestat>
}
    800048e2:	60e2                	ld	ra,24(sp)
    800048e4:	6442                	ld	s0,16(sp)
    800048e6:	6105                	addi	sp,sp,32
    800048e8:	8082                	ret

00000000800048ea <sys_link>:
{
    800048ea:	7169                	addi	sp,sp,-304
    800048ec:	f606                	sd	ra,296(sp)
    800048ee:	f222                	sd	s0,288(sp)
    800048f0:	ee26                	sd	s1,280(sp)
    800048f2:	ea4a                	sd	s2,272(sp)
    800048f4:	1a00                	addi	s0,sp,304
    if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    800048f6:	08000613          	li	a2,128
    800048fa:	ed040593          	addi	a1,s0,-304
    800048fe:	4501                	li	a0,0
    80004900:	ffffd097          	auipc	ra,0xffffd
    80004904:	7e0080e7          	jalr	2016(ra) # 800020e0 <argstr>
        return -1;
    80004908:	57fd                	li	a5,-1
    if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000490a:	10054e63          	bltz	a0,80004a26 <sys_link+0x13c>
    8000490e:	08000613          	li	a2,128
    80004912:	f5040593          	addi	a1,s0,-176
    80004916:	4505                	li	a0,1
    80004918:	ffffd097          	auipc	ra,0xffffd
    8000491c:	7c8080e7          	jalr	1992(ra) # 800020e0 <argstr>
        return -1;
    80004920:	57fd                	li	a5,-1
    if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004922:	10054263          	bltz	a0,80004a26 <sys_link+0x13c>
    begin_op();
    80004926:	fffff097          	auipc	ra,0xfffff
    8000492a:	cb6080e7          	jalr	-842(ra) # 800035dc <begin_op>
    if ((ip = namei(old)) == 0)
    8000492e:	ed040513          	addi	a0,s0,-304
    80004932:	fffff097          	auipc	ra,0xfffff
    80004936:	a8e080e7          	jalr	-1394(ra) # 800033c0 <namei>
    8000493a:	84aa                	mv	s1,a0
    8000493c:	c551                	beqz	a0,800049c8 <sys_link+0xde>
    ilock(ip);
    8000493e:	ffffe097          	auipc	ra,0xffffe
    80004942:	2dc080e7          	jalr	732(ra) # 80002c1a <ilock>
    if (ip->type == T_DIR)
    80004946:	04449703          	lh	a4,68(s1)
    8000494a:	4785                	li	a5,1
    8000494c:	08f70463          	beq	a4,a5,800049d4 <sys_link+0xea>
    ip->nlink++;
    80004950:	04a4d783          	lhu	a5,74(s1)
    80004954:	2785                	addiw	a5,a5,1
    80004956:	04f49523          	sh	a5,74(s1)
    iupdate(ip);
    8000495a:	8526                	mv	a0,s1
    8000495c:	ffffe097          	auipc	ra,0xffffe
    80004960:	1f4080e7          	jalr	500(ra) # 80002b50 <iupdate>
    iunlock(ip);
    80004964:	8526                	mv	a0,s1
    80004966:	ffffe097          	auipc	ra,0xffffe
    8000496a:	376080e7          	jalr	886(ra) # 80002cdc <iunlock>
    if ((dp = nameiparent(new, name)) == 0)
    8000496e:	fd040593          	addi	a1,s0,-48
    80004972:	f5040513          	addi	a0,s0,-176
    80004976:	fffff097          	auipc	ra,0xfffff
    8000497a:	a68080e7          	jalr	-1432(ra) # 800033de <nameiparent>
    8000497e:	892a                	mv	s2,a0
    80004980:	c935                	beqz	a0,800049f4 <sys_link+0x10a>
    ilock(dp);
    80004982:	ffffe097          	auipc	ra,0xffffe
    80004986:	298080e7          	jalr	664(ra) # 80002c1a <ilock>
    if (dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0)
    8000498a:	00092703          	lw	a4,0(s2)
    8000498e:	409c                	lw	a5,0(s1)
    80004990:	04f71d63          	bne	a4,a5,800049ea <sys_link+0x100>
    80004994:	40d0                	lw	a2,4(s1)
    80004996:	fd040593          	addi	a1,s0,-48
    8000499a:	854a                	mv	a0,s2
    8000499c:	fffff097          	auipc	ra,0xfffff
    800049a0:	972080e7          	jalr	-1678(ra) # 8000330e <dirlink>
    800049a4:	04054363          	bltz	a0,800049ea <sys_link+0x100>
    iunlockput(dp);
    800049a8:	854a                	mv	a0,s2
    800049aa:	ffffe097          	auipc	ra,0xffffe
    800049ae:	4d2080e7          	jalr	1234(ra) # 80002e7c <iunlockput>
    iput(ip);
    800049b2:	8526                	mv	a0,s1
    800049b4:	ffffe097          	auipc	ra,0xffffe
    800049b8:	420080e7          	jalr	1056(ra) # 80002dd4 <iput>
    end_op();
    800049bc:	fffff097          	auipc	ra,0xfffff
    800049c0:	ca0080e7          	jalr	-864(ra) # 8000365c <end_op>
    return 0;
    800049c4:	4781                	li	a5,0
    800049c6:	a085                	j	80004a26 <sys_link+0x13c>
        end_op();
    800049c8:	fffff097          	auipc	ra,0xfffff
    800049cc:	c94080e7          	jalr	-876(ra) # 8000365c <end_op>
        return -1;
    800049d0:	57fd                	li	a5,-1
    800049d2:	a891                	j	80004a26 <sys_link+0x13c>
        iunlockput(ip);
    800049d4:	8526                	mv	a0,s1
    800049d6:	ffffe097          	auipc	ra,0xffffe
    800049da:	4a6080e7          	jalr	1190(ra) # 80002e7c <iunlockput>
        end_op();
    800049de:	fffff097          	auipc	ra,0xfffff
    800049e2:	c7e080e7          	jalr	-898(ra) # 8000365c <end_op>
        return -1;
    800049e6:	57fd                	li	a5,-1
    800049e8:	a83d                	j	80004a26 <sys_link+0x13c>
        iunlockput(dp);
    800049ea:	854a                	mv	a0,s2
    800049ec:	ffffe097          	auipc	ra,0xffffe
    800049f0:	490080e7          	jalr	1168(ra) # 80002e7c <iunlockput>
    ilock(ip);
    800049f4:	8526                	mv	a0,s1
    800049f6:	ffffe097          	auipc	ra,0xffffe
    800049fa:	224080e7          	jalr	548(ra) # 80002c1a <ilock>
    ip->nlink--;
    800049fe:	04a4d783          	lhu	a5,74(s1)
    80004a02:	37fd                	addiw	a5,a5,-1
    80004a04:	04f49523          	sh	a5,74(s1)
    iupdate(ip);
    80004a08:	8526                	mv	a0,s1
    80004a0a:	ffffe097          	auipc	ra,0xffffe
    80004a0e:	146080e7          	jalr	326(ra) # 80002b50 <iupdate>
    iunlockput(ip);
    80004a12:	8526                	mv	a0,s1
    80004a14:	ffffe097          	auipc	ra,0xffffe
    80004a18:	468080e7          	jalr	1128(ra) # 80002e7c <iunlockput>
    end_op();
    80004a1c:	fffff097          	auipc	ra,0xfffff
    80004a20:	c40080e7          	jalr	-960(ra) # 8000365c <end_op>
    return -1;
    80004a24:	57fd                	li	a5,-1
}
    80004a26:	853e                	mv	a0,a5
    80004a28:	70b2                	ld	ra,296(sp)
    80004a2a:	7412                	ld	s0,288(sp)
    80004a2c:	64f2                	ld	s1,280(sp)
    80004a2e:	6952                	ld	s2,272(sp)
    80004a30:	6155                	addi	sp,sp,304
    80004a32:	8082                	ret

0000000080004a34 <sys_unlink>:
{
    80004a34:	7151                	addi	sp,sp,-240
    80004a36:	f586                	sd	ra,232(sp)
    80004a38:	f1a2                	sd	s0,224(sp)
    80004a3a:	eda6                	sd	s1,216(sp)
    80004a3c:	e9ca                	sd	s2,208(sp)
    80004a3e:	e5ce                	sd	s3,200(sp)
    80004a40:	1980                	addi	s0,sp,240
    if (argstr(0, path, MAXPATH) < 0)
    80004a42:	08000613          	li	a2,128
    80004a46:	f3040593          	addi	a1,s0,-208
    80004a4a:	4501                	li	a0,0
    80004a4c:	ffffd097          	auipc	ra,0xffffd
    80004a50:	694080e7          	jalr	1684(ra) # 800020e0 <argstr>
    80004a54:	18054163          	bltz	a0,80004bd6 <sys_unlink+0x1a2>
    begin_op();
    80004a58:	fffff097          	auipc	ra,0xfffff
    80004a5c:	b84080e7          	jalr	-1148(ra) # 800035dc <begin_op>
    if ((dp = nameiparent(path, name)) == 0)
    80004a60:	fb040593          	addi	a1,s0,-80
    80004a64:	f3040513          	addi	a0,s0,-208
    80004a68:	fffff097          	auipc	ra,0xfffff
    80004a6c:	976080e7          	jalr	-1674(ra) # 800033de <nameiparent>
    80004a70:	84aa                	mv	s1,a0
    80004a72:	c979                	beqz	a0,80004b48 <sys_unlink+0x114>
    ilock(dp);
    80004a74:	ffffe097          	auipc	ra,0xffffe
    80004a78:	1a6080e7          	jalr	422(ra) # 80002c1a <ilock>
    if (namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004a7c:	00004597          	auipc	a1,0x4
    80004a80:	bfc58593          	addi	a1,a1,-1028 # 80008678 <syscalls+0x2b8>
    80004a84:	fb040513          	addi	a0,s0,-80
    80004a88:	ffffe097          	auipc	ra,0xffffe
    80004a8c:	65c080e7          	jalr	1628(ra) # 800030e4 <namecmp>
    80004a90:	14050a63          	beqz	a0,80004be4 <sys_unlink+0x1b0>
    80004a94:	00004597          	auipc	a1,0x4
    80004a98:	bec58593          	addi	a1,a1,-1044 # 80008680 <syscalls+0x2c0>
    80004a9c:	fb040513          	addi	a0,s0,-80
    80004aa0:	ffffe097          	auipc	ra,0xffffe
    80004aa4:	644080e7          	jalr	1604(ra) # 800030e4 <namecmp>
    80004aa8:	12050e63          	beqz	a0,80004be4 <sys_unlink+0x1b0>
    if ((ip = dirlookup(dp, name, &off)) == 0)
    80004aac:	f2c40613          	addi	a2,s0,-212
    80004ab0:	fb040593          	addi	a1,s0,-80
    80004ab4:	8526                	mv	a0,s1
    80004ab6:	ffffe097          	auipc	ra,0xffffe
    80004aba:	648080e7          	jalr	1608(ra) # 800030fe <dirlookup>
    80004abe:	892a                	mv	s2,a0
    80004ac0:	12050263          	beqz	a0,80004be4 <sys_unlink+0x1b0>
    ilock(ip);
    80004ac4:	ffffe097          	auipc	ra,0xffffe
    80004ac8:	156080e7          	jalr	342(ra) # 80002c1a <ilock>
    if (ip->nlink < 1)
    80004acc:	04a91783          	lh	a5,74(s2)
    80004ad0:	08f05263          	blez	a5,80004b54 <sys_unlink+0x120>
    if (ip->type == T_DIR && !isdirempty(ip))
    80004ad4:	04491703          	lh	a4,68(s2)
    80004ad8:	4785                	li	a5,1
    80004ada:	08f70563          	beq	a4,a5,80004b64 <sys_unlink+0x130>
    memset(&de, 0, sizeof(de));
    80004ade:	4641                	li	a2,16
    80004ae0:	4581                	li	a1,0
    80004ae2:	fc040513          	addi	a0,s0,-64
    80004ae6:	ffffb097          	auipc	ra,0xffffb
    80004aea:	692080e7          	jalr	1682(ra) # 80000178 <memset>
    if (writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004aee:	4741                	li	a4,16
    80004af0:	f2c42683          	lw	a3,-212(s0)
    80004af4:	fc040613          	addi	a2,s0,-64
    80004af8:	4581                	li	a1,0
    80004afa:	8526                	mv	a0,s1
    80004afc:	ffffe097          	auipc	ra,0xffffe
    80004b00:	4ca080e7          	jalr	1226(ra) # 80002fc6 <writei>
    80004b04:	47c1                	li	a5,16
    80004b06:	0af51563          	bne	a0,a5,80004bb0 <sys_unlink+0x17c>
    if (ip->type == T_DIR)
    80004b0a:	04491703          	lh	a4,68(s2)
    80004b0e:	4785                	li	a5,1
    80004b10:	0af70863          	beq	a4,a5,80004bc0 <sys_unlink+0x18c>
    iunlockput(dp);
    80004b14:	8526                	mv	a0,s1
    80004b16:	ffffe097          	auipc	ra,0xffffe
    80004b1a:	366080e7          	jalr	870(ra) # 80002e7c <iunlockput>
    ip->nlink--;
    80004b1e:	04a95783          	lhu	a5,74(s2)
    80004b22:	37fd                	addiw	a5,a5,-1
    80004b24:	04f91523          	sh	a5,74(s2)
    iupdate(ip);
    80004b28:	854a                	mv	a0,s2
    80004b2a:	ffffe097          	auipc	ra,0xffffe
    80004b2e:	026080e7          	jalr	38(ra) # 80002b50 <iupdate>
    iunlockput(ip);
    80004b32:	854a                	mv	a0,s2
    80004b34:	ffffe097          	auipc	ra,0xffffe
    80004b38:	348080e7          	jalr	840(ra) # 80002e7c <iunlockput>
    end_op();
    80004b3c:	fffff097          	auipc	ra,0xfffff
    80004b40:	b20080e7          	jalr	-1248(ra) # 8000365c <end_op>
    return 0;
    80004b44:	4501                	li	a0,0
    80004b46:	a84d                	j	80004bf8 <sys_unlink+0x1c4>
        end_op();
    80004b48:	fffff097          	auipc	ra,0xfffff
    80004b4c:	b14080e7          	jalr	-1260(ra) # 8000365c <end_op>
        return -1;
    80004b50:	557d                	li	a0,-1
    80004b52:	a05d                	j	80004bf8 <sys_unlink+0x1c4>
        panic("unlink: nlink < 1");
    80004b54:	00004517          	auipc	a0,0x4
    80004b58:	b3450513          	addi	a0,a0,-1228 # 80008688 <syscalls+0x2c8>
    80004b5c:	00001097          	auipc	ra,0x1
    80004b60:	456080e7          	jalr	1110(ra) # 80005fb2 <panic>
    for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de))
    80004b64:	04c92703          	lw	a4,76(s2)
    80004b68:	02000793          	li	a5,32
    80004b6c:	f6e7f9e3          	bgeu	a5,a4,80004ade <sys_unlink+0xaa>
    80004b70:	02000993          	li	s3,32
        if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004b74:	4741                	li	a4,16
    80004b76:	86ce                	mv	a3,s3
    80004b78:	f1840613          	addi	a2,s0,-232
    80004b7c:	4581                	li	a1,0
    80004b7e:	854a                	mv	a0,s2
    80004b80:	ffffe097          	auipc	ra,0xffffe
    80004b84:	34e080e7          	jalr	846(ra) # 80002ece <readi>
    80004b88:	47c1                	li	a5,16
    80004b8a:	00f51b63          	bne	a0,a5,80004ba0 <sys_unlink+0x16c>
        if (de.inum != 0)
    80004b8e:	f1845783          	lhu	a5,-232(s0)
    80004b92:	e7a1                	bnez	a5,80004bda <sys_unlink+0x1a6>
    for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de))
    80004b94:	29c1                	addiw	s3,s3,16
    80004b96:	04c92783          	lw	a5,76(s2)
    80004b9a:	fcf9ede3          	bltu	s3,a5,80004b74 <sys_unlink+0x140>
    80004b9e:	b781                	j	80004ade <sys_unlink+0xaa>
            panic("isdirempty: readi");
    80004ba0:	00004517          	auipc	a0,0x4
    80004ba4:	b0050513          	addi	a0,a0,-1280 # 800086a0 <syscalls+0x2e0>
    80004ba8:	00001097          	auipc	ra,0x1
    80004bac:	40a080e7          	jalr	1034(ra) # 80005fb2 <panic>
        panic("unlink: writei");
    80004bb0:	00004517          	auipc	a0,0x4
    80004bb4:	b0850513          	addi	a0,a0,-1272 # 800086b8 <syscalls+0x2f8>
    80004bb8:	00001097          	auipc	ra,0x1
    80004bbc:	3fa080e7          	jalr	1018(ra) # 80005fb2 <panic>
        dp->nlink--;
    80004bc0:	04a4d783          	lhu	a5,74(s1)
    80004bc4:	37fd                	addiw	a5,a5,-1
    80004bc6:	04f49523          	sh	a5,74(s1)
        iupdate(dp);
    80004bca:	8526                	mv	a0,s1
    80004bcc:	ffffe097          	auipc	ra,0xffffe
    80004bd0:	f84080e7          	jalr	-124(ra) # 80002b50 <iupdate>
    80004bd4:	b781                	j	80004b14 <sys_unlink+0xe0>
        return -1;
    80004bd6:	557d                	li	a0,-1
    80004bd8:	a005                	j	80004bf8 <sys_unlink+0x1c4>
        iunlockput(ip);
    80004bda:	854a                	mv	a0,s2
    80004bdc:	ffffe097          	auipc	ra,0xffffe
    80004be0:	2a0080e7          	jalr	672(ra) # 80002e7c <iunlockput>
    iunlockput(dp);
    80004be4:	8526                	mv	a0,s1
    80004be6:	ffffe097          	auipc	ra,0xffffe
    80004bea:	296080e7          	jalr	662(ra) # 80002e7c <iunlockput>
    end_op();
    80004bee:	fffff097          	auipc	ra,0xfffff
    80004bf2:	a6e080e7          	jalr	-1426(ra) # 8000365c <end_op>
    return -1;
    80004bf6:	557d                	li	a0,-1
}
    80004bf8:	70ae                	ld	ra,232(sp)
    80004bfa:	740e                	ld	s0,224(sp)
    80004bfc:	64ee                	ld	s1,216(sp)
    80004bfe:	694e                	ld	s2,208(sp)
    80004c00:	69ae                	ld	s3,200(sp)
    80004c02:	616d                	addi	sp,sp,240
    80004c04:	8082                	ret

0000000080004c06 <sys_mmap>:
{
    80004c06:	711d                	addi	sp,sp,-96
    80004c08:	ec86                	sd	ra,88(sp)
    80004c0a:	e8a2                	sd	s0,80(sp)
    80004c0c:	e4a6                	sd	s1,72(sp)
    80004c0e:	e0ca                	sd	s2,64(sp)
    80004c10:	fc4e                	sd	s3,56(sp)
    80004c12:	1080                	addi	s0,sp,96
    argaddr(0, &addr);
    80004c14:	fc840593          	addi	a1,s0,-56
    80004c18:	4501                	li	a0,0
    80004c1a:	ffffd097          	auipc	ra,0xffffd
    80004c1e:	4a6080e7          	jalr	1190(ra) # 800020c0 <argaddr>
    argaddr(1, &length);
    80004c22:	fc040593          	addi	a1,s0,-64
    80004c26:	4505                	li	a0,1
    80004c28:	ffffd097          	auipc	ra,0xffffd
    80004c2c:	498080e7          	jalr	1176(ra) # 800020c0 <argaddr>
    argint(2, &prot);
    80004c30:	fbc40593          	addi	a1,s0,-68
    80004c34:	4509                	li	a0,2
    80004c36:	ffffd097          	auipc	ra,0xffffd
    80004c3a:	46a080e7          	jalr	1130(ra) # 800020a0 <argint>
    argint(3, &flags);
    80004c3e:	fb840593          	addi	a1,s0,-72
    80004c42:	450d                	li	a0,3
    80004c44:	ffffd097          	auipc	ra,0xffffd
    80004c48:	45c080e7          	jalr	1116(ra) # 800020a0 <argint>
    argfd(4, &fd, &pf);
    80004c4c:	fa040613          	addi	a2,s0,-96
    80004c50:	fb440593          	addi	a1,s0,-76
    80004c54:	4511                	li	a0,4
    80004c56:	00000097          	auipc	ra,0x0
    80004c5a:	8d4080e7          	jalr	-1836(ra) # 8000452a <argfd>
    argaddr(5, &offset);
    80004c5e:	fa840593          	addi	a1,s0,-88
    80004c62:	4515                	li	a0,5
    80004c64:	ffffd097          	auipc	ra,0xffffd
    80004c68:	45c080e7          	jalr	1116(ra) # 800020c0 <argaddr>
    if ((prot & PROT_WRITE) && (flags & MAP_SHARED) && (!pf->writable))
    80004c6c:	fbc42783          	lw	a5,-68(s0)
    80004c70:	0027f713          	andi	a4,a5,2
    80004c74:	cb11                	beqz	a4,80004c88 <sys_mmap+0x82>
    80004c76:	fb842703          	lw	a4,-72(s0)
    80004c7a:	8b05                	andi	a4,a4,1
    80004c7c:	c711                	beqz	a4,80004c88 <sys_mmap+0x82>
    80004c7e:	fa043703          	ld	a4,-96(s0)
    80004c82:	00974703          	lbu	a4,9(a4)
    80004c86:	cb61                	beqz	a4,80004d56 <sys_mmap+0x150>
    if ((prot & PROT_READ) && (!pf->readable))
    80004c88:	8b85                	andi	a5,a5,1
    80004c8a:	c791                	beqz	a5,80004c96 <sys_mmap+0x90>
    80004c8c:	fa043783          	ld	a5,-96(s0)
    80004c90:	0087c783          	lbu	a5,8(a5)
    80004c94:	c3f9                	beqz	a5,80004d5a <sys_mmap+0x154>
    struct proc *p_proc = myproc(); // create a pt pointing to process struct
    80004c96:	ffffc097          	auipc	ra,0xffffc
    80004c9a:	1a8080e7          	jalr	424(ra) # 80000e3e <myproc>
    80004c9e:	892a                	mv	s2,a0
            if (p_proc->sz + length <= MAXVA) // still enough space in process
    80004ca0:	fc043503          	ld	a0,-64(s0)
    80004ca4:	16890793          	addi	a5,s2,360
    for (int i = 0; i <= VMASIZE - 1; i++)
    80004ca8:	4481                	li	s1,0
        if (p_proc->vma[i].occupied != 1) // not used
    80004caa:	4605                	li	a2,1
            if (p_proc->sz + length <= MAXVA) // still enough space in process
    80004cac:	02661813          	slli	a6,a2,0x26
    for (int i = 0; i <= VMASIZE - 1; i++)
    80004cb0:	45c1                	li	a1,16
    80004cb2:	a031                	j	80004cbe <sys_mmap+0xb8>
    80004cb4:	2485                	addiw	s1,s1,1
    80004cb6:	04878793          	addi	a5,a5,72
    80004cba:	08b48663          	beq	s1,a1,80004d46 <sys_mmap+0x140>
        if (p_proc->vma[i].occupied != 1) // not used
    80004cbe:	4398                	lw	a4,0(a5)
    80004cc0:	fec70ae3          	beq	a4,a2,80004cb4 <sys_mmap+0xae>
            if (p_proc->sz + length <= MAXVA) // still enough space in process
    80004cc4:	04893683          	ld	a3,72(s2)
    80004cc8:	00a68733          	add	a4,a3,a0
    80004ccc:	fee864e3          	bltu	a6,a4,80004cb4 <sys_mmap+0xae>
        p_vma->occupied = 1;                                 // denote it is occupied
    80004cd0:	00349993          	slli	s3,s1,0x3
    80004cd4:	009987b3          	add	a5,s3,s1
    80004cd8:	078e                	slli	a5,a5,0x3
    80004cda:	97ca                	add	a5,a5,s2
    80004cdc:	4605                	li	a2,1
    80004cde:	16c7a423          	sw	a2,360(a5)
        p_vma->start_addr = (uint64)(p_proc->sz);            // get start address
    80004ce2:	16d7b823          	sd	a3,368(a5)
        p_vma->end_addr = (uint64)(p_proc->sz + length - 1); // get end addrerss
    80004ce6:	fff70693          	addi	a3,a4,-1
    80004cea:	16d7bc23          	sd	a3,376(a5)
        p_proc->sz += (uint64)(length);                      // increase sz, for other vmas
    80004cee:	04e93423          	sd	a4,72(s2)
        p_vma->addr = (uint64)(addr);
    80004cf2:	fc843703          	ld	a4,-56(s0)
    80004cf6:	18e7b023          	sd	a4,384(a5)
        p_vma->length = (uint64)(length);
    80004cfa:	18a7b423          	sd	a0,392(a5)
        p_vma->prot = (int)(prot);
    80004cfe:	fbc42703          	lw	a4,-68(s0)
    80004d02:	18e7a823          	sw	a4,400(a5)
        p_vma->flags = (int)(flags);
    80004d06:	fb842703          	lw	a4,-72(s0)
    80004d0a:	18e7aa23          	sw	a4,404(a5)
        p_vma->fd = fd;
    80004d0e:	fb442703          	lw	a4,-76(s0)
    80004d12:	18e7ac23          	sw	a4,408(a5)
        p_vma->offset = (uint64)(offset);
    80004d16:	fa843703          	ld	a4,-88(s0)
    80004d1a:	1ae7b023          	sd	a4,416(a5)
        p_vma->pf = pf;
    80004d1e:	fa043503          	ld	a0,-96(s0)
    80004d22:	1aa7b423          	sd	a0,424(a5)
        filedup(p_vma->pf);
    80004d26:	fffff097          	auipc	ra,0xfffff
    80004d2a:	d30080e7          	jalr	-720(ra) # 80003a56 <filedup>
        return (uint64)(p_vma->start_addr);
    80004d2e:	94ce                	add	s1,s1,s3
    80004d30:	048e                	slli	s1,s1,0x3
    80004d32:	9926                	add	s2,s2,s1
    80004d34:	17093503          	ld	a0,368(s2)
}
    80004d38:	60e6                	ld	ra,88(sp)
    80004d3a:	6446                	ld	s0,80(sp)
    80004d3c:	64a6                	ld	s1,72(sp)
    80004d3e:	6906                	ld	s2,64(sp)
    80004d40:	79e2                	ld	s3,56(sp)
    80004d42:	6125                	addi	sp,sp,96
    80004d44:	8082                	ret
        panic("syscall mmap");
    80004d46:	00004517          	auipc	a0,0x4
    80004d4a:	98250513          	addi	a0,a0,-1662 # 800086c8 <syscalls+0x308>
    80004d4e:	00001097          	auipc	ra,0x1
    80004d52:	264080e7          	jalr	612(ra) # 80005fb2 <panic>
        return -1;
    80004d56:	557d                	li	a0,-1
    80004d58:	b7c5                	j	80004d38 <sys_mmap+0x132>
        return -1;
    80004d5a:	557d                	li	a0,-1
    80004d5c:	bff1                	j	80004d38 <sys_mmap+0x132>

0000000080004d5e <sys_munmap>:
{
    80004d5e:	7139                	addi	sp,sp,-64
    80004d60:	fc06                	sd	ra,56(sp)
    80004d62:	f822                	sd	s0,48(sp)
    80004d64:	f426                	sd	s1,40(sp)
    80004d66:	f04a                	sd	s2,32(sp)
    80004d68:	ec4e                	sd	s3,24(sp)
    80004d6a:	0080                	addi	s0,sp,64
    argaddr(0, &addr);
    80004d6c:	fc840593          	addi	a1,s0,-56
    80004d70:	4501                	li	a0,0
    80004d72:	ffffd097          	auipc	ra,0xffffd
    80004d76:	34e080e7          	jalr	846(ra) # 800020c0 <argaddr>
    argaddr(1, &length);
    80004d7a:	fc040593          	addi	a1,s0,-64
    80004d7e:	4505                	li	a0,1
    80004d80:	ffffd097          	auipc	ra,0xffffd
    80004d84:	340080e7          	jalr	832(ra) # 800020c0 <argaddr>
    struct proc *p_proc = myproc(); // create a pt pointing to process struct
    80004d88:	ffffc097          	auipc	ra,0xffffc
    80004d8c:	0b6080e7          	jalr	182(ra) # 80000e3e <myproc>
    80004d90:	892a                	mv	s2,a0
        if ((p_proc->vma[i].start_addr <= addr) && (addr <= p_proc->vma[i].end_addr))
    80004d92:	fc843703          	ld	a4,-56(s0)
    80004d96:	17050793          	addi	a5,a0,368
    for (int i = 0; i <= VMASIZE - 1; i++)
    80004d9a:	4481                	li	s1,0
    80004d9c:	46c1                	li	a3,16
    80004d9e:	a031                	j	80004daa <sys_munmap+0x4c>
    80004da0:	2485                	addiw	s1,s1,1
    80004da2:	04878793          	addi	a5,a5,72
    80004da6:	06d48863          	beq	s1,a3,80004e16 <sys_munmap+0xb8>
        if ((p_proc->vma[i].start_addr <= addr) && (addr <= p_proc->vma[i].end_addr))
    80004daa:	638c                	ld	a1,0(a5)
    80004dac:	feb76ae3          	bltu	a4,a1,80004da0 <sys_munmap+0x42>
    80004db0:	6790                	ld	a2,8(a5)
    80004db2:	fee667e3          	bltu	a2,a4,80004da0 <sys_munmap+0x42>
        if ((p_vma->flags & MAP_SHARED) != 0)
    80004db6:	00349793          	slli	a5,s1,0x3
    80004dba:	97a6                	add	a5,a5,s1
    80004dbc:	078e                	slli	a5,a5,0x3
    80004dbe:	97ca                	add	a5,a5,s2
    80004dc0:	1947a783          	lw	a5,404(a5)
    80004dc4:	8b85                	andi	a5,a5,1
    80004dc6:	e3a5                	bnez	a5,80004e26 <sys_munmap+0xc8>
        uvmunmap(p_proc->pagetable, p_vma->start_addr, length / PGSIZE, 1);
    80004dc8:	00349993          	slli	s3,s1,0x3
    80004dcc:	99a6                	add	s3,s3,s1
    80004dce:	098e                	slli	s3,s3,0x3
    80004dd0:	99ca                	add	s3,s3,s2
    80004dd2:	4685                	li	a3,1
    80004dd4:	fc043603          	ld	a2,-64(s0)
    80004dd8:	8231                	srli	a2,a2,0xc
    80004dda:	1709b583          	ld	a1,368(s3)
    80004dde:	05093503          	ld	a0,80(s2)
    80004de2:	ffffc097          	auipc	ra,0xffffc
    80004de6:	930080e7          	jalr	-1744(ra) # 80000712 <uvmunmap>
        p_vma->start_addr += length;
    80004dea:	1709b783          	ld	a5,368(s3)
    80004dee:	fc043703          	ld	a4,-64(s0)
    80004df2:	97ba                	add	a5,a5,a4
    80004df4:	16f9b823          	sd	a5,368(s3)
        if (p_vma->start_addr == p_vma->end_addr)
    80004df8:	1789b703          	ld	a4,376(s3)
        return 0;
    80004dfc:	4501                	li	a0,0
        if (p_vma->start_addr == p_vma->end_addr)
    80004dfe:	00e79d63          	bne	a5,a4,80004e18 <sys_munmap+0xba>
            p_vma->occupied = 0;  // denoting unused for further usage
    80004e02:	1609a423          	sw	zero,360(s3)
            fileclose(p_vma->pf); // close the file
    80004e06:	1a89b503          	ld	a0,424(s3)
    80004e0a:	fffff097          	auipc	ra,0xfffff
    80004e0e:	c9e080e7          	jalr	-866(ra) # 80003aa8 <fileclose>
            return 0;
    80004e12:	4501                	li	a0,0
    80004e14:	a011                	j	80004e18 <sys_munmap+0xba>
        return -1;
    80004e16:	557d                	li	a0,-1
}
    80004e18:	70e2                	ld	ra,56(sp)
    80004e1a:	7442                	ld	s0,48(sp)
    80004e1c:	74a2                	ld	s1,40(sp)
    80004e1e:	7902                	ld	s2,32(sp)
    80004e20:	69e2                	ld	s3,24(sp)
    80004e22:	6121                	addi	sp,sp,64
    80004e24:	8082                	ret
            filewrite(p_vma->pf, p_vma->start_addr, length);
    80004e26:	00349793          	slli	a5,s1,0x3
    80004e2a:	97a6                	add	a5,a5,s1
    80004e2c:	078e                	slli	a5,a5,0x3
    80004e2e:	97ca                	add	a5,a5,s2
    80004e30:	fc042603          	lw	a2,-64(s0)
    80004e34:	1a87b503          	ld	a0,424(a5)
    80004e38:	fffff097          	auipc	ra,0xfffff
    80004e3c:	ec6080e7          	jalr	-314(ra) # 80003cfe <filewrite>
    80004e40:	b761                	j	80004dc8 <sys_munmap+0x6a>

0000000080004e42 <sys_open>:

uint64
sys_open(void)
{
    80004e42:	7131                	addi	sp,sp,-192
    80004e44:	fd06                	sd	ra,184(sp)
    80004e46:	f922                	sd	s0,176(sp)
    80004e48:	f526                	sd	s1,168(sp)
    80004e4a:	f14a                	sd	s2,160(sp)
    80004e4c:	ed4e                	sd	s3,152(sp)
    80004e4e:	0180                	addi	s0,sp,192
    int fd, omode;
    struct file *f;
    struct inode *ip;
    int n;

    argint(1, &omode);
    80004e50:	f4c40593          	addi	a1,s0,-180
    80004e54:	4505                	li	a0,1
    80004e56:	ffffd097          	auipc	ra,0xffffd
    80004e5a:	24a080e7          	jalr	586(ra) # 800020a0 <argint>
    if ((n = argstr(0, path, MAXPATH)) < 0)
    80004e5e:	08000613          	li	a2,128
    80004e62:	f5040593          	addi	a1,s0,-176
    80004e66:	4501                	li	a0,0
    80004e68:	ffffd097          	auipc	ra,0xffffd
    80004e6c:	278080e7          	jalr	632(ra) # 800020e0 <argstr>
    80004e70:	87aa                	mv	a5,a0
        return -1;
    80004e72:	557d                	li	a0,-1
    if ((n = argstr(0, path, MAXPATH)) < 0)
    80004e74:	0a07c963          	bltz	a5,80004f26 <sys_open+0xe4>

    begin_op();
    80004e78:	ffffe097          	auipc	ra,0xffffe
    80004e7c:	764080e7          	jalr	1892(ra) # 800035dc <begin_op>

    if (omode & O_CREATE)
    80004e80:	f4c42783          	lw	a5,-180(s0)
    80004e84:	2007f793          	andi	a5,a5,512
    80004e88:	cfc5                	beqz	a5,80004f40 <sys_open+0xfe>
    {
        ip = create(path, T_FILE, 0, 0);
    80004e8a:	4681                	li	a3,0
    80004e8c:	4601                	li	a2,0
    80004e8e:	4589                	li	a1,2
    80004e90:	f5040513          	addi	a0,s0,-176
    80004e94:	fffff097          	auipc	ra,0xfffff
    80004e98:	738080e7          	jalr	1848(ra) # 800045cc <create>
    80004e9c:	84aa                	mv	s1,a0
        if (ip == 0)
    80004e9e:	c959                	beqz	a0,80004f34 <sys_open+0xf2>
            end_op();
            return -1;
        }
    }

    if (ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV))
    80004ea0:	04449703          	lh	a4,68(s1)
    80004ea4:	478d                	li	a5,3
    80004ea6:	00f71763          	bne	a4,a5,80004eb4 <sys_open+0x72>
    80004eaa:	0464d703          	lhu	a4,70(s1)
    80004eae:	47a5                	li	a5,9
    80004eb0:	0ce7ed63          	bltu	a5,a4,80004f8a <sys_open+0x148>
        iunlockput(ip);
        end_op();
        return -1;
    }

    if ((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0)
    80004eb4:	fffff097          	auipc	ra,0xfffff
    80004eb8:	b38080e7          	jalr	-1224(ra) # 800039ec <filealloc>
    80004ebc:	89aa                	mv	s3,a0
    80004ebe:	10050363          	beqz	a0,80004fc4 <sys_open+0x182>
    80004ec2:	fffff097          	auipc	ra,0xfffff
    80004ec6:	6c8080e7          	jalr	1736(ra) # 8000458a <fdalloc>
    80004eca:	892a                	mv	s2,a0
    80004ecc:	0e054763          	bltz	a0,80004fba <sys_open+0x178>
        iunlockput(ip);
        end_op();
        return -1;
    }

    if (ip->type == T_DEVICE)
    80004ed0:	04449703          	lh	a4,68(s1)
    80004ed4:	478d                	li	a5,3
    80004ed6:	0cf70563          	beq	a4,a5,80004fa0 <sys_open+0x15e>
        f->type = FD_DEVICE;
        f->major = ip->major;
    }
    else
    {
        f->type = FD_INODE;
    80004eda:	4789                	li	a5,2
    80004edc:	00f9a023          	sw	a5,0(s3)
        f->off = 0;
    80004ee0:	0209a023          	sw	zero,32(s3)
    }
    f->ip = ip;
    80004ee4:	0099bc23          	sd	s1,24(s3)
    f->readable = !(omode & O_WRONLY);
    80004ee8:	f4c42783          	lw	a5,-180(s0)
    80004eec:	0017c713          	xori	a4,a5,1
    80004ef0:	8b05                	andi	a4,a4,1
    80004ef2:	00e98423          	sb	a4,8(s3)
    f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80004ef6:	0037f713          	andi	a4,a5,3
    80004efa:	00e03733          	snez	a4,a4
    80004efe:	00e984a3          	sb	a4,9(s3)

    if ((omode & O_TRUNC) && ip->type == T_FILE)
    80004f02:	4007f793          	andi	a5,a5,1024
    80004f06:	c791                	beqz	a5,80004f12 <sys_open+0xd0>
    80004f08:	04449703          	lh	a4,68(s1)
    80004f0c:	4789                	li	a5,2
    80004f0e:	0af70063          	beq	a4,a5,80004fae <sys_open+0x16c>
    {
        itrunc(ip);
    }

    iunlock(ip);
    80004f12:	8526                	mv	a0,s1
    80004f14:	ffffe097          	auipc	ra,0xffffe
    80004f18:	dc8080e7          	jalr	-568(ra) # 80002cdc <iunlock>
    end_op();
    80004f1c:	ffffe097          	auipc	ra,0xffffe
    80004f20:	740080e7          	jalr	1856(ra) # 8000365c <end_op>

    return fd;
    80004f24:	854a                	mv	a0,s2
}
    80004f26:	70ea                	ld	ra,184(sp)
    80004f28:	744a                	ld	s0,176(sp)
    80004f2a:	74aa                	ld	s1,168(sp)
    80004f2c:	790a                	ld	s2,160(sp)
    80004f2e:	69ea                	ld	s3,152(sp)
    80004f30:	6129                	addi	sp,sp,192
    80004f32:	8082                	ret
            end_op();
    80004f34:	ffffe097          	auipc	ra,0xffffe
    80004f38:	728080e7          	jalr	1832(ra) # 8000365c <end_op>
            return -1;
    80004f3c:	557d                	li	a0,-1
    80004f3e:	b7e5                	j	80004f26 <sys_open+0xe4>
        if ((ip = namei(path)) == 0)
    80004f40:	f5040513          	addi	a0,s0,-176
    80004f44:	ffffe097          	auipc	ra,0xffffe
    80004f48:	47c080e7          	jalr	1148(ra) # 800033c0 <namei>
    80004f4c:	84aa                	mv	s1,a0
    80004f4e:	c905                	beqz	a0,80004f7e <sys_open+0x13c>
        ilock(ip);
    80004f50:	ffffe097          	auipc	ra,0xffffe
    80004f54:	cca080e7          	jalr	-822(ra) # 80002c1a <ilock>
        if (ip->type == T_DIR && omode != O_RDONLY)
    80004f58:	04449703          	lh	a4,68(s1)
    80004f5c:	4785                	li	a5,1
    80004f5e:	f4f711e3          	bne	a4,a5,80004ea0 <sys_open+0x5e>
    80004f62:	f4c42783          	lw	a5,-180(s0)
    80004f66:	d7b9                	beqz	a5,80004eb4 <sys_open+0x72>
            iunlockput(ip);
    80004f68:	8526                	mv	a0,s1
    80004f6a:	ffffe097          	auipc	ra,0xffffe
    80004f6e:	f12080e7          	jalr	-238(ra) # 80002e7c <iunlockput>
            end_op();
    80004f72:	ffffe097          	auipc	ra,0xffffe
    80004f76:	6ea080e7          	jalr	1770(ra) # 8000365c <end_op>
            return -1;
    80004f7a:	557d                	li	a0,-1
    80004f7c:	b76d                	j	80004f26 <sys_open+0xe4>
            end_op();
    80004f7e:	ffffe097          	auipc	ra,0xffffe
    80004f82:	6de080e7          	jalr	1758(ra) # 8000365c <end_op>
            return -1;
    80004f86:	557d                	li	a0,-1
    80004f88:	bf79                	j	80004f26 <sys_open+0xe4>
        iunlockput(ip);
    80004f8a:	8526                	mv	a0,s1
    80004f8c:	ffffe097          	auipc	ra,0xffffe
    80004f90:	ef0080e7          	jalr	-272(ra) # 80002e7c <iunlockput>
        end_op();
    80004f94:	ffffe097          	auipc	ra,0xffffe
    80004f98:	6c8080e7          	jalr	1736(ra) # 8000365c <end_op>
        return -1;
    80004f9c:	557d                	li	a0,-1
    80004f9e:	b761                	j	80004f26 <sys_open+0xe4>
        f->type = FD_DEVICE;
    80004fa0:	00f9a023          	sw	a5,0(s3)
        f->major = ip->major;
    80004fa4:	04649783          	lh	a5,70(s1)
    80004fa8:	02f99223          	sh	a5,36(s3)
    80004fac:	bf25                	j	80004ee4 <sys_open+0xa2>
        itrunc(ip);
    80004fae:	8526                	mv	a0,s1
    80004fb0:	ffffe097          	auipc	ra,0xffffe
    80004fb4:	d78080e7          	jalr	-648(ra) # 80002d28 <itrunc>
    80004fb8:	bfa9                	j	80004f12 <sys_open+0xd0>
            fileclose(f);
    80004fba:	854e                	mv	a0,s3
    80004fbc:	fffff097          	auipc	ra,0xfffff
    80004fc0:	aec080e7          	jalr	-1300(ra) # 80003aa8 <fileclose>
        iunlockput(ip);
    80004fc4:	8526                	mv	a0,s1
    80004fc6:	ffffe097          	auipc	ra,0xffffe
    80004fca:	eb6080e7          	jalr	-330(ra) # 80002e7c <iunlockput>
        end_op();
    80004fce:	ffffe097          	auipc	ra,0xffffe
    80004fd2:	68e080e7          	jalr	1678(ra) # 8000365c <end_op>
        return -1;
    80004fd6:	557d                	li	a0,-1
    80004fd8:	b7b9                	j	80004f26 <sys_open+0xe4>

0000000080004fda <sys_mkdir>:

uint64
sys_mkdir(void)
{
    80004fda:	7175                	addi	sp,sp,-144
    80004fdc:	e506                	sd	ra,136(sp)
    80004fde:	e122                	sd	s0,128(sp)
    80004fe0:	0900                	addi	s0,sp,144
    char path[MAXPATH];
    struct inode *ip;

    begin_op();
    80004fe2:	ffffe097          	auipc	ra,0xffffe
    80004fe6:	5fa080e7          	jalr	1530(ra) # 800035dc <begin_op>
    if (argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0)
    80004fea:	08000613          	li	a2,128
    80004fee:	f7040593          	addi	a1,s0,-144
    80004ff2:	4501                	li	a0,0
    80004ff4:	ffffd097          	auipc	ra,0xffffd
    80004ff8:	0ec080e7          	jalr	236(ra) # 800020e0 <argstr>
    80004ffc:	02054963          	bltz	a0,8000502e <sys_mkdir+0x54>
    80005000:	4681                	li	a3,0
    80005002:	4601                	li	a2,0
    80005004:	4585                	li	a1,1
    80005006:	f7040513          	addi	a0,s0,-144
    8000500a:	fffff097          	auipc	ra,0xfffff
    8000500e:	5c2080e7          	jalr	1474(ra) # 800045cc <create>
    80005012:	cd11                	beqz	a0,8000502e <sys_mkdir+0x54>
    {
        end_op();
        return -1;
    }
    iunlockput(ip);
    80005014:	ffffe097          	auipc	ra,0xffffe
    80005018:	e68080e7          	jalr	-408(ra) # 80002e7c <iunlockput>
    end_op();
    8000501c:	ffffe097          	auipc	ra,0xffffe
    80005020:	640080e7          	jalr	1600(ra) # 8000365c <end_op>
    return 0;
    80005024:	4501                	li	a0,0
}
    80005026:	60aa                	ld	ra,136(sp)
    80005028:	640a                	ld	s0,128(sp)
    8000502a:	6149                	addi	sp,sp,144
    8000502c:	8082                	ret
        end_op();
    8000502e:	ffffe097          	auipc	ra,0xffffe
    80005032:	62e080e7          	jalr	1582(ra) # 8000365c <end_op>
        return -1;
    80005036:	557d                	li	a0,-1
    80005038:	b7fd                	j	80005026 <sys_mkdir+0x4c>

000000008000503a <sys_mknod>:

uint64
sys_mknod(void)
{
    8000503a:	7135                	addi	sp,sp,-160
    8000503c:	ed06                	sd	ra,152(sp)
    8000503e:	e922                	sd	s0,144(sp)
    80005040:	1100                	addi	s0,sp,160
    struct inode *ip;
    char path[MAXPATH];
    int major, minor;

    begin_op();
    80005042:	ffffe097          	auipc	ra,0xffffe
    80005046:	59a080e7          	jalr	1434(ra) # 800035dc <begin_op>
    argint(1, &major);
    8000504a:	f6c40593          	addi	a1,s0,-148
    8000504e:	4505                	li	a0,1
    80005050:	ffffd097          	auipc	ra,0xffffd
    80005054:	050080e7          	jalr	80(ra) # 800020a0 <argint>
    argint(2, &minor);
    80005058:	f6840593          	addi	a1,s0,-152
    8000505c:	4509                	li	a0,2
    8000505e:	ffffd097          	auipc	ra,0xffffd
    80005062:	042080e7          	jalr	66(ra) # 800020a0 <argint>
    if ((argstr(0, path, MAXPATH)) < 0 ||
    80005066:	08000613          	li	a2,128
    8000506a:	f7040593          	addi	a1,s0,-144
    8000506e:	4501                	li	a0,0
    80005070:	ffffd097          	auipc	ra,0xffffd
    80005074:	070080e7          	jalr	112(ra) # 800020e0 <argstr>
    80005078:	02054b63          	bltz	a0,800050ae <sys_mknod+0x74>
        (ip = create(path, T_DEVICE, major, minor)) == 0)
    8000507c:	f6841683          	lh	a3,-152(s0)
    80005080:	f6c41603          	lh	a2,-148(s0)
    80005084:	458d                	li	a1,3
    80005086:	f7040513          	addi	a0,s0,-144
    8000508a:	fffff097          	auipc	ra,0xfffff
    8000508e:	542080e7          	jalr	1346(ra) # 800045cc <create>
    if ((argstr(0, path, MAXPATH)) < 0 ||
    80005092:	cd11                	beqz	a0,800050ae <sys_mknod+0x74>
    {
        end_op();
        return -1;
    }
    iunlockput(ip);
    80005094:	ffffe097          	auipc	ra,0xffffe
    80005098:	de8080e7          	jalr	-536(ra) # 80002e7c <iunlockput>
    end_op();
    8000509c:	ffffe097          	auipc	ra,0xffffe
    800050a0:	5c0080e7          	jalr	1472(ra) # 8000365c <end_op>
    return 0;
    800050a4:	4501                	li	a0,0
}
    800050a6:	60ea                	ld	ra,152(sp)
    800050a8:	644a                	ld	s0,144(sp)
    800050aa:	610d                	addi	sp,sp,160
    800050ac:	8082                	ret
        end_op();
    800050ae:	ffffe097          	auipc	ra,0xffffe
    800050b2:	5ae080e7          	jalr	1454(ra) # 8000365c <end_op>
        return -1;
    800050b6:	557d                	li	a0,-1
    800050b8:	b7fd                	j	800050a6 <sys_mknod+0x6c>

00000000800050ba <sys_chdir>:

uint64
sys_chdir(void)
{
    800050ba:	7135                	addi	sp,sp,-160
    800050bc:	ed06                	sd	ra,152(sp)
    800050be:	e922                	sd	s0,144(sp)
    800050c0:	e526                	sd	s1,136(sp)
    800050c2:	e14a                	sd	s2,128(sp)
    800050c4:	1100                	addi	s0,sp,160
    char path[MAXPATH];
    struct inode *ip;
    struct proc *p = myproc();
    800050c6:	ffffc097          	auipc	ra,0xffffc
    800050ca:	d78080e7          	jalr	-648(ra) # 80000e3e <myproc>
    800050ce:	892a                	mv	s2,a0

    begin_op();
    800050d0:	ffffe097          	auipc	ra,0xffffe
    800050d4:	50c080e7          	jalr	1292(ra) # 800035dc <begin_op>
    if (argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0)
    800050d8:	08000613          	li	a2,128
    800050dc:	f6040593          	addi	a1,s0,-160
    800050e0:	4501                	li	a0,0
    800050e2:	ffffd097          	auipc	ra,0xffffd
    800050e6:	ffe080e7          	jalr	-2(ra) # 800020e0 <argstr>
    800050ea:	04054b63          	bltz	a0,80005140 <sys_chdir+0x86>
    800050ee:	f6040513          	addi	a0,s0,-160
    800050f2:	ffffe097          	auipc	ra,0xffffe
    800050f6:	2ce080e7          	jalr	718(ra) # 800033c0 <namei>
    800050fa:	84aa                	mv	s1,a0
    800050fc:	c131                	beqz	a0,80005140 <sys_chdir+0x86>
    {
        end_op();
        return -1;
    }
    ilock(ip);
    800050fe:	ffffe097          	auipc	ra,0xffffe
    80005102:	b1c080e7          	jalr	-1252(ra) # 80002c1a <ilock>
    if (ip->type != T_DIR)
    80005106:	04449703          	lh	a4,68(s1)
    8000510a:	4785                	li	a5,1
    8000510c:	04f71063          	bne	a4,a5,8000514c <sys_chdir+0x92>
    {
        iunlockput(ip);
        end_op();
        return -1;
    }
    iunlock(ip);
    80005110:	8526                	mv	a0,s1
    80005112:	ffffe097          	auipc	ra,0xffffe
    80005116:	bca080e7          	jalr	-1078(ra) # 80002cdc <iunlock>
    iput(p->cwd);
    8000511a:	15093503          	ld	a0,336(s2)
    8000511e:	ffffe097          	auipc	ra,0xffffe
    80005122:	cb6080e7          	jalr	-842(ra) # 80002dd4 <iput>
    end_op();
    80005126:	ffffe097          	auipc	ra,0xffffe
    8000512a:	536080e7          	jalr	1334(ra) # 8000365c <end_op>
    p->cwd = ip;
    8000512e:	14993823          	sd	s1,336(s2)
    return 0;
    80005132:	4501                	li	a0,0
}
    80005134:	60ea                	ld	ra,152(sp)
    80005136:	644a                	ld	s0,144(sp)
    80005138:	64aa                	ld	s1,136(sp)
    8000513a:	690a                	ld	s2,128(sp)
    8000513c:	610d                	addi	sp,sp,160
    8000513e:	8082                	ret
        end_op();
    80005140:	ffffe097          	auipc	ra,0xffffe
    80005144:	51c080e7          	jalr	1308(ra) # 8000365c <end_op>
        return -1;
    80005148:	557d                	li	a0,-1
    8000514a:	b7ed                	j	80005134 <sys_chdir+0x7a>
        iunlockput(ip);
    8000514c:	8526                	mv	a0,s1
    8000514e:	ffffe097          	auipc	ra,0xffffe
    80005152:	d2e080e7          	jalr	-722(ra) # 80002e7c <iunlockput>
        end_op();
    80005156:	ffffe097          	auipc	ra,0xffffe
    8000515a:	506080e7          	jalr	1286(ra) # 8000365c <end_op>
        return -1;
    8000515e:	557d                	li	a0,-1
    80005160:	bfd1                	j	80005134 <sys_chdir+0x7a>

0000000080005162 <sys_exec>:

uint64
sys_exec(void)
{
    80005162:	7145                	addi	sp,sp,-464
    80005164:	e786                	sd	ra,456(sp)
    80005166:	e3a2                	sd	s0,448(sp)
    80005168:	ff26                	sd	s1,440(sp)
    8000516a:	fb4a                	sd	s2,432(sp)
    8000516c:	f74e                	sd	s3,424(sp)
    8000516e:	f352                	sd	s4,416(sp)
    80005170:	ef56                	sd	s5,408(sp)
    80005172:	0b80                	addi	s0,sp,464
    char path[MAXPATH], *argv[MAXARG];
    int i;
    uint64 uargv, uarg;

    argaddr(1, &uargv);
    80005174:	e3840593          	addi	a1,s0,-456
    80005178:	4505                	li	a0,1
    8000517a:	ffffd097          	auipc	ra,0xffffd
    8000517e:	f46080e7          	jalr	-186(ra) # 800020c0 <argaddr>
    if (argstr(0, path, MAXPATH) < 0)
    80005182:	08000613          	li	a2,128
    80005186:	f4040593          	addi	a1,s0,-192
    8000518a:	4501                	li	a0,0
    8000518c:	ffffd097          	auipc	ra,0xffffd
    80005190:	f54080e7          	jalr	-172(ra) # 800020e0 <argstr>
    80005194:	87aa                	mv	a5,a0
    {
        return -1;
    80005196:	557d                	li	a0,-1
    if (argstr(0, path, MAXPATH) < 0)
    80005198:	0c07c263          	bltz	a5,8000525c <sys_exec+0xfa>
    }
    memset(argv, 0, sizeof(argv));
    8000519c:	10000613          	li	a2,256
    800051a0:	4581                	li	a1,0
    800051a2:	e4040513          	addi	a0,s0,-448
    800051a6:	ffffb097          	auipc	ra,0xffffb
    800051aa:	fd2080e7          	jalr	-46(ra) # 80000178 <memset>
    for (i = 0;; i++)
    {
        if (i >= NELEM(argv))
    800051ae:	e4040493          	addi	s1,s0,-448
    memset(argv, 0, sizeof(argv));
    800051b2:	89a6                	mv	s3,s1
    800051b4:	4901                	li	s2,0
        if (i >= NELEM(argv))
    800051b6:	02000a13          	li	s4,32
    800051ba:	00090a9b          	sext.w	s5,s2
        {
            goto bad;
        }
        if (fetchaddr(uargv + sizeof(uint64) * i, (uint64 *)&uarg) < 0)
    800051be:	00391513          	slli	a0,s2,0x3
    800051c2:	e3040593          	addi	a1,s0,-464
    800051c6:	e3843783          	ld	a5,-456(s0)
    800051ca:	953e                	add	a0,a0,a5
    800051cc:	ffffd097          	auipc	ra,0xffffd
    800051d0:	e36080e7          	jalr	-458(ra) # 80002002 <fetchaddr>
    800051d4:	02054a63          	bltz	a0,80005208 <sys_exec+0xa6>
        {
            goto bad;
        }
        if (uarg == 0)
    800051d8:	e3043783          	ld	a5,-464(s0)
    800051dc:	c3b9                	beqz	a5,80005222 <sys_exec+0xc0>
        {
            argv[i] = 0;
            break;
        }
        argv[i] = kalloc();
    800051de:	ffffb097          	auipc	ra,0xffffb
    800051e2:	f3a080e7          	jalr	-198(ra) # 80000118 <kalloc>
    800051e6:	85aa                	mv	a1,a0
    800051e8:	00a9b023          	sd	a0,0(s3)
        if (argv[i] == 0)
    800051ec:	cd11                	beqz	a0,80005208 <sys_exec+0xa6>
            goto bad;
        if (fetchstr(uarg, argv[i], PGSIZE) < 0)
    800051ee:	6605                	lui	a2,0x1
    800051f0:	e3043503          	ld	a0,-464(s0)
    800051f4:	ffffd097          	auipc	ra,0xffffd
    800051f8:	e60080e7          	jalr	-416(ra) # 80002054 <fetchstr>
    800051fc:	00054663          	bltz	a0,80005208 <sys_exec+0xa6>
        if (i >= NELEM(argv))
    80005200:	0905                	addi	s2,s2,1
    80005202:	09a1                	addi	s3,s3,8
    80005204:	fb491be3          	bne	s2,s4,800051ba <sys_exec+0x58>
        kfree(argv[i]);

    return ret;

bad:
    for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005208:	10048913          	addi	s2,s1,256
    8000520c:	6088                	ld	a0,0(s1)
    8000520e:	c531                	beqz	a0,8000525a <sys_exec+0xf8>
        kfree(argv[i]);
    80005210:	ffffb097          	auipc	ra,0xffffb
    80005214:	e0c080e7          	jalr	-500(ra) # 8000001c <kfree>
    for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005218:	04a1                	addi	s1,s1,8
    8000521a:	ff2499e3          	bne	s1,s2,8000520c <sys_exec+0xaa>
    return -1;
    8000521e:	557d                	li	a0,-1
    80005220:	a835                	j	8000525c <sys_exec+0xfa>
            argv[i] = 0;
    80005222:	0a8e                	slli	s5,s5,0x3
    80005224:	fc040793          	addi	a5,s0,-64
    80005228:	9abe                	add	s5,s5,a5
    8000522a:	e80ab023          	sd	zero,-384(s5)
    int ret = exec(path, argv);
    8000522e:	e4040593          	addi	a1,s0,-448
    80005232:	f4040513          	addi	a0,s0,-192
    80005236:	fffff097          	auipc	ra,0xfffff
    8000523a:	f54080e7          	jalr	-172(ra) # 8000418a <exec>
    8000523e:	892a                	mv	s2,a0
    for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005240:	10048993          	addi	s3,s1,256
    80005244:	6088                	ld	a0,0(s1)
    80005246:	c901                	beqz	a0,80005256 <sys_exec+0xf4>
        kfree(argv[i]);
    80005248:	ffffb097          	auipc	ra,0xffffb
    8000524c:	dd4080e7          	jalr	-556(ra) # 8000001c <kfree>
    for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005250:	04a1                	addi	s1,s1,8
    80005252:	ff3499e3          	bne	s1,s3,80005244 <sys_exec+0xe2>
    return ret;
    80005256:	854a                	mv	a0,s2
    80005258:	a011                	j	8000525c <sys_exec+0xfa>
    return -1;
    8000525a:	557d                	li	a0,-1
}
    8000525c:	60be                	ld	ra,456(sp)
    8000525e:	641e                	ld	s0,448(sp)
    80005260:	74fa                	ld	s1,440(sp)
    80005262:	795a                	ld	s2,432(sp)
    80005264:	79ba                	ld	s3,424(sp)
    80005266:	7a1a                	ld	s4,416(sp)
    80005268:	6afa                	ld	s5,408(sp)
    8000526a:	6179                	addi	sp,sp,464
    8000526c:	8082                	ret

000000008000526e <sys_pipe>:

uint64
sys_pipe(void)
{
    8000526e:	7139                	addi	sp,sp,-64
    80005270:	fc06                	sd	ra,56(sp)
    80005272:	f822                	sd	s0,48(sp)
    80005274:	f426                	sd	s1,40(sp)
    80005276:	0080                	addi	s0,sp,64
    uint64 fdarray; // user pointer to array of two integers
    struct file *rf, *wf;
    int fd0, fd1;
    struct proc *p = myproc();
    80005278:	ffffc097          	auipc	ra,0xffffc
    8000527c:	bc6080e7          	jalr	-1082(ra) # 80000e3e <myproc>
    80005280:	84aa                	mv	s1,a0

    argaddr(0, &fdarray);
    80005282:	fd840593          	addi	a1,s0,-40
    80005286:	4501                	li	a0,0
    80005288:	ffffd097          	auipc	ra,0xffffd
    8000528c:	e38080e7          	jalr	-456(ra) # 800020c0 <argaddr>
    if (pipealloc(&rf, &wf) < 0)
    80005290:	fc840593          	addi	a1,s0,-56
    80005294:	fd040513          	addi	a0,s0,-48
    80005298:	fffff097          	auipc	ra,0xfffff
    8000529c:	b9a080e7          	jalr	-1126(ra) # 80003e32 <pipealloc>
        return -1;
    800052a0:	57fd                	li	a5,-1
    if (pipealloc(&rf, &wf) < 0)
    800052a2:	0c054463          	bltz	a0,8000536a <sys_pipe+0xfc>
    fd0 = -1;
    800052a6:	fcf42223          	sw	a5,-60(s0)
    if ((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0)
    800052aa:	fd043503          	ld	a0,-48(s0)
    800052ae:	fffff097          	auipc	ra,0xfffff
    800052b2:	2dc080e7          	jalr	732(ra) # 8000458a <fdalloc>
    800052b6:	fca42223          	sw	a0,-60(s0)
    800052ba:	08054b63          	bltz	a0,80005350 <sys_pipe+0xe2>
    800052be:	fc843503          	ld	a0,-56(s0)
    800052c2:	fffff097          	auipc	ra,0xfffff
    800052c6:	2c8080e7          	jalr	712(ra) # 8000458a <fdalloc>
    800052ca:	fca42023          	sw	a0,-64(s0)
    800052ce:	06054863          	bltz	a0,8000533e <sys_pipe+0xd0>
            p->ofile[fd0] = 0;
        fileclose(rf);
        fileclose(wf);
        return -1;
    }
    if (copyout(p->pagetable, fdarray, (char *)&fd0, sizeof(fd0)) < 0 ||
    800052d2:	4691                	li	a3,4
    800052d4:	fc440613          	addi	a2,s0,-60
    800052d8:	fd843583          	ld	a1,-40(s0)
    800052dc:	68a8                	ld	a0,80(s1)
    800052de:	ffffc097          	auipc	ra,0xffffc
    800052e2:	81e080e7          	jalr	-2018(ra) # 80000afc <copyout>
    800052e6:	02054063          	bltz	a0,80005306 <sys_pipe+0x98>
        copyout(p->pagetable, fdarray + sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0)
    800052ea:	4691                	li	a3,4
    800052ec:	fc040613          	addi	a2,s0,-64
    800052f0:	fd843583          	ld	a1,-40(s0)
    800052f4:	0591                	addi	a1,a1,4
    800052f6:	68a8                	ld	a0,80(s1)
    800052f8:	ffffc097          	auipc	ra,0xffffc
    800052fc:	804080e7          	jalr	-2044(ra) # 80000afc <copyout>
        p->ofile[fd1] = 0;
        fileclose(rf);
        fileclose(wf);
        return -1;
    }
    return 0;
    80005300:	4781                	li	a5,0
    if (copyout(p->pagetable, fdarray, (char *)&fd0, sizeof(fd0)) < 0 ||
    80005302:	06055463          	bgez	a0,8000536a <sys_pipe+0xfc>
        p->ofile[fd0] = 0;
    80005306:	fc442783          	lw	a5,-60(s0)
    8000530a:	07e9                	addi	a5,a5,26
    8000530c:	078e                	slli	a5,a5,0x3
    8000530e:	97a6                	add	a5,a5,s1
    80005310:	0007b023          	sd	zero,0(a5)
        p->ofile[fd1] = 0;
    80005314:	fc042503          	lw	a0,-64(s0)
    80005318:	0569                	addi	a0,a0,26
    8000531a:	050e                	slli	a0,a0,0x3
    8000531c:	94aa                	add	s1,s1,a0
    8000531e:	0004b023          	sd	zero,0(s1)
        fileclose(rf);
    80005322:	fd043503          	ld	a0,-48(s0)
    80005326:	ffffe097          	auipc	ra,0xffffe
    8000532a:	782080e7          	jalr	1922(ra) # 80003aa8 <fileclose>
        fileclose(wf);
    8000532e:	fc843503          	ld	a0,-56(s0)
    80005332:	ffffe097          	auipc	ra,0xffffe
    80005336:	776080e7          	jalr	1910(ra) # 80003aa8 <fileclose>
        return -1;
    8000533a:	57fd                	li	a5,-1
    8000533c:	a03d                	j	8000536a <sys_pipe+0xfc>
        if (fd0 >= 0)
    8000533e:	fc442783          	lw	a5,-60(s0)
    80005342:	0007c763          	bltz	a5,80005350 <sys_pipe+0xe2>
            p->ofile[fd0] = 0;
    80005346:	07e9                	addi	a5,a5,26
    80005348:	078e                	slli	a5,a5,0x3
    8000534a:	94be                	add	s1,s1,a5
    8000534c:	0004b023          	sd	zero,0(s1)
        fileclose(rf);
    80005350:	fd043503          	ld	a0,-48(s0)
    80005354:	ffffe097          	auipc	ra,0xffffe
    80005358:	754080e7          	jalr	1876(ra) # 80003aa8 <fileclose>
        fileclose(wf);
    8000535c:	fc843503          	ld	a0,-56(s0)
    80005360:	ffffe097          	auipc	ra,0xffffe
    80005364:	748080e7          	jalr	1864(ra) # 80003aa8 <fileclose>
        return -1;
    80005368:	57fd                	li	a5,-1
}
    8000536a:	853e                	mv	a0,a5
    8000536c:	70e2                	ld	ra,56(sp)
    8000536e:	7442                	ld	s0,48(sp)
    80005370:	74a2                	ld	s1,40(sp)
    80005372:	6121                	addi	sp,sp,64
    80005374:	8082                	ret
	...

0000000080005380 <kernelvec>:
    80005380:	7111                	addi	sp,sp,-256
    80005382:	e006                	sd	ra,0(sp)
    80005384:	e40a                	sd	sp,8(sp)
    80005386:	e80e                	sd	gp,16(sp)
    80005388:	ec12                	sd	tp,24(sp)
    8000538a:	f016                	sd	t0,32(sp)
    8000538c:	f41a                	sd	t1,40(sp)
    8000538e:	f81e                	sd	t2,48(sp)
    80005390:	fc22                	sd	s0,56(sp)
    80005392:	e0a6                	sd	s1,64(sp)
    80005394:	e4aa                	sd	a0,72(sp)
    80005396:	e8ae                	sd	a1,80(sp)
    80005398:	ecb2                	sd	a2,88(sp)
    8000539a:	f0b6                	sd	a3,96(sp)
    8000539c:	f4ba                	sd	a4,104(sp)
    8000539e:	f8be                	sd	a5,112(sp)
    800053a0:	fcc2                	sd	a6,120(sp)
    800053a2:	e146                	sd	a7,128(sp)
    800053a4:	e54a                	sd	s2,136(sp)
    800053a6:	e94e                	sd	s3,144(sp)
    800053a8:	ed52                	sd	s4,152(sp)
    800053aa:	f156                	sd	s5,160(sp)
    800053ac:	f55a                	sd	s6,168(sp)
    800053ae:	f95e                	sd	s7,176(sp)
    800053b0:	fd62                	sd	s8,184(sp)
    800053b2:	e1e6                	sd	s9,192(sp)
    800053b4:	e5ea                	sd	s10,200(sp)
    800053b6:	e9ee                	sd	s11,208(sp)
    800053b8:	edf2                	sd	t3,216(sp)
    800053ba:	f1f6                	sd	t4,224(sp)
    800053bc:	f5fa                	sd	t5,232(sp)
    800053be:	f9fe                	sd	t6,240(sp)
    800053c0:	b0ffc0ef          	jal	ra,80001ece <kerneltrap>
    800053c4:	6082                	ld	ra,0(sp)
    800053c6:	6122                	ld	sp,8(sp)
    800053c8:	61c2                	ld	gp,16(sp)
    800053ca:	7282                	ld	t0,32(sp)
    800053cc:	7322                	ld	t1,40(sp)
    800053ce:	73c2                	ld	t2,48(sp)
    800053d0:	7462                	ld	s0,56(sp)
    800053d2:	6486                	ld	s1,64(sp)
    800053d4:	6526                	ld	a0,72(sp)
    800053d6:	65c6                	ld	a1,80(sp)
    800053d8:	6666                	ld	a2,88(sp)
    800053da:	7686                	ld	a3,96(sp)
    800053dc:	7726                	ld	a4,104(sp)
    800053de:	77c6                	ld	a5,112(sp)
    800053e0:	7866                	ld	a6,120(sp)
    800053e2:	688a                	ld	a7,128(sp)
    800053e4:	692a                	ld	s2,136(sp)
    800053e6:	69ca                	ld	s3,144(sp)
    800053e8:	6a6a                	ld	s4,152(sp)
    800053ea:	7a8a                	ld	s5,160(sp)
    800053ec:	7b2a                	ld	s6,168(sp)
    800053ee:	7bca                	ld	s7,176(sp)
    800053f0:	7c6a                	ld	s8,184(sp)
    800053f2:	6c8e                	ld	s9,192(sp)
    800053f4:	6d2e                	ld	s10,200(sp)
    800053f6:	6dce                	ld	s11,208(sp)
    800053f8:	6e6e                	ld	t3,216(sp)
    800053fa:	7e8e                	ld	t4,224(sp)
    800053fc:	7f2e                	ld	t5,232(sp)
    800053fe:	7fce                	ld	t6,240(sp)
    80005400:	6111                	addi	sp,sp,256
    80005402:	10200073          	sret
    80005406:	00000013          	nop
    8000540a:	00000013          	nop
    8000540e:	0001                	nop

0000000080005410 <timervec>:
    80005410:	34051573          	csrrw	a0,mscratch,a0
    80005414:	e10c                	sd	a1,0(a0)
    80005416:	e510                	sd	a2,8(a0)
    80005418:	e914                	sd	a3,16(a0)
    8000541a:	6d0c                	ld	a1,24(a0)
    8000541c:	7110                	ld	a2,32(a0)
    8000541e:	6194                	ld	a3,0(a1)
    80005420:	96b2                	add	a3,a3,a2
    80005422:	e194                	sd	a3,0(a1)
    80005424:	4589                	li	a1,2
    80005426:	14459073          	csrw	sip,a1
    8000542a:	6914                	ld	a3,16(a0)
    8000542c:	6510                	ld	a2,8(a0)
    8000542e:	610c                	ld	a1,0(a0)
    80005430:	34051573          	csrrw	a0,mscratch,a0
    80005434:	30200073          	mret
	...

000000008000543a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000543a:	1141                	addi	sp,sp,-16
    8000543c:	e422                	sd	s0,8(sp)
    8000543e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005440:	0c0007b7          	lui	a5,0xc000
    80005444:	4705                	li	a4,1
    80005446:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005448:	c3d8                	sw	a4,4(a5)
}
    8000544a:	6422                	ld	s0,8(sp)
    8000544c:	0141                	addi	sp,sp,16
    8000544e:	8082                	ret

0000000080005450 <plicinithart>:

void
plicinithart(void)
{
    80005450:	1141                	addi	sp,sp,-16
    80005452:	e406                	sd	ra,8(sp)
    80005454:	e022                	sd	s0,0(sp)
    80005456:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005458:	ffffc097          	auipc	ra,0xffffc
    8000545c:	9ba080e7          	jalr	-1606(ra) # 80000e12 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005460:	0085171b          	slliw	a4,a0,0x8
    80005464:	0c0027b7          	lui	a5,0xc002
    80005468:	97ba                	add	a5,a5,a4
    8000546a:	40200713          	li	a4,1026
    8000546e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005472:	00d5151b          	slliw	a0,a0,0xd
    80005476:	0c2017b7          	lui	a5,0xc201
    8000547a:	953e                	add	a0,a0,a5
    8000547c:	00052023          	sw	zero,0(a0)
}
    80005480:	60a2                	ld	ra,8(sp)
    80005482:	6402                	ld	s0,0(sp)
    80005484:	0141                	addi	sp,sp,16
    80005486:	8082                	ret

0000000080005488 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    80005488:	1141                	addi	sp,sp,-16
    8000548a:	e406                	sd	ra,8(sp)
    8000548c:	e022                	sd	s0,0(sp)
    8000548e:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005490:	ffffc097          	auipc	ra,0xffffc
    80005494:	982080e7          	jalr	-1662(ra) # 80000e12 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    80005498:	00d5179b          	slliw	a5,a0,0xd
    8000549c:	0c201537          	lui	a0,0xc201
    800054a0:	953e                	add	a0,a0,a5
  return irq;
}
    800054a2:	4148                	lw	a0,4(a0)
    800054a4:	60a2                	ld	ra,8(sp)
    800054a6:	6402                	ld	s0,0(sp)
    800054a8:	0141                	addi	sp,sp,16
    800054aa:	8082                	ret

00000000800054ac <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800054ac:	1101                	addi	sp,sp,-32
    800054ae:	ec06                	sd	ra,24(sp)
    800054b0:	e822                	sd	s0,16(sp)
    800054b2:	e426                	sd	s1,8(sp)
    800054b4:	1000                	addi	s0,sp,32
    800054b6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800054b8:	ffffc097          	auipc	ra,0xffffc
    800054bc:	95a080e7          	jalr	-1702(ra) # 80000e12 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800054c0:	00d5151b          	slliw	a0,a0,0xd
    800054c4:	0c2017b7          	lui	a5,0xc201
    800054c8:	97aa                	add	a5,a5,a0
    800054ca:	c3c4                	sw	s1,4(a5)
}
    800054cc:	60e2                	ld	ra,24(sp)
    800054ce:	6442                	ld	s0,16(sp)
    800054d0:	64a2                	ld	s1,8(sp)
    800054d2:	6105                	addi	sp,sp,32
    800054d4:	8082                	ret

00000000800054d6 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800054d6:	1141                	addi	sp,sp,-16
    800054d8:	e406                	sd	ra,8(sp)
    800054da:	e022                	sd	s0,0(sp)
    800054dc:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800054de:	479d                	li	a5,7
    800054e0:	04a7cc63          	blt	a5,a0,80005538 <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    800054e4:	00026797          	auipc	a5,0x26
    800054e8:	50c78793          	addi	a5,a5,1292 # 8002b9f0 <disk>
    800054ec:	97aa                	add	a5,a5,a0
    800054ee:	0187c783          	lbu	a5,24(a5)
    800054f2:	ebb9                	bnez	a5,80005548 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    800054f4:	00451613          	slli	a2,a0,0x4
    800054f8:	00026797          	auipc	a5,0x26
    800054fc:	4f878793          	addi	a5,a5,1272 # 8002b9f0 <disk>
    80005500:	6394                	ld	a3,0(a5)
    80005502:	96b2                	add	a3,a3,a2
    80005504:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    80005508:	6398                	ld	a4,0(a5)
    8000550a:	9732                	add	a4,a4,a2
    8000550c:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80005510:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005514:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005518:	953e                	add	a0,a0,a5
    8000551a:	4785                	li	a5,1
    8000551c:	00f50c23          	sb	a5,24(a0) # c201018 <_entry-0x73dfefe8>
  wakeup(&disk.free[0]);
    80005520:	00026517          	auipc	a0,0x26
    80005524:	4e850513          	addi	a0,a0,1256 # 8002ba08 <disk+0x18>
    80005528:	ffffc097          	auipc	ra,0xffffc
    8000552c:	086080e7          	jalr	134(ra) # 800015ae <wakeup>
}
    80005530:	60a2                	ld	ra,8(sp)
    80005532:	6402                	ld	s0,0(sp)
    80005534:	0141                	addi	sp,sp,16
    80005536:	8082                	ret
    panic("free_desc 1");
    80005538:	00003517          	auipc	a0,0x3
    8000553c:	1a050513          	addi	a0,a0,416 # 800086d8 <syscalls+0x318>
    80005540:	00001097          	auipc	ra,0x1
    80005544:	a72080e7          	jalr	-1422(ra) # 80005fb2 <panic>
    panic("free_desc 2");
    80005548:	00003517          	auipc	a0,0x3
    8000554c:	1a050513          	addi	a0,a0,416 # 800086e8 <syscalls+0x328>
    80005550:	00001097          	auipc	ra,0x1
    80005554:	a62080e7          	jalr	-1438(ra) # 80005fb2 <panic>

0000000080005558 <virtio_disk_init>:
{
    80005558:	1101                	addi	sp,sp,-32
    8000555a:	ec06                	sd	ra,24(sp)
    8000555c:	e822                	sd	s0,16(sp)
    8000555e:	e426                	sd	s1,8(sp)
    80005560:	e04a                	sd	s2,0(sp)
    80005562:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005564:	00003597          	auipc	a1,0x3
    80005568:	19458593          	addi	a1,a1,404 # 800086f8 <syscalls+0x338>
    8000556c:	00026517          	auipc	a0,0x26
    80005570:	5ac50513          	addi	a0,a0,1452 # 8002bb18 <disk+0x128>
    80005574:	00001097          	auipc	ra,0x1
    80005578:	ef8080e7          	jalr	-264(ra) # 8000646c <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000557c:	100017b7          	lui	a5,0x10001
    80005580:	4398                	lw	a4,0(a5)
    80005582:	2701                	sext.w	a4,a4
    80005584:	747277b7          	lui	a5,0x74727
    80005588:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    8000558c:	14f71e63          	bne	a4,a5,800056e8 <virtio_disk_init+0x190>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    80005590:	100017b7          	lui	a5,0x10001
    80005594:	43dc                	lw	a5,4(a5)
    80005596:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    80005598:	4709                	li	a4,2
    8000559a:	14e79763          	bne	a5,a4,800056e8 <virtio_disk_init+0x190>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    8000559e:	100017b7          	lui	a5,0x10001
    800055a2:	479c                	lw	a5,8(a5)
    800055a4:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800055a6:	14e79163          	bne	a5,a4,800056e8 <virtio_disk_init+0x190>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800055aa:	100017b7          	lui	a5,0x10001
    800055ae:	47d8                	lw	a4,12(a5)
    800055b0:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800055b2:	554d47b7          	lui	a5,0x554d4
    800055b6:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800055ba:	12f71763          	bne	a4,a5,800056e8 <virtio_disk_init+0x190>
  *R(VIRTIO_MMIO_STATUS) = status;
    800055be:	100017b7          	lui	a5,0x10001
    800055c2:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    800055c6:	4705                	li	a4,1
    800055c8:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800055ca:	470d                	li	a4,3
    800055cc:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800055ce:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800055d0:	c7ffe737          	lui	a4,0xc7ffe
    800055d4:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fca9ef>
    800055d8:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800055da:	2701                	sext.w	a4,a4
    800055dc:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800055de:	472d                	li	a4,11
    800055e0:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    800055e2:	0707a903          	lw	s2,112(a5)
    800055e6:	2901                	sext.w	s2,s2
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    800055e8:	00897793          	andi	a5,s2,8
    800055ec:	10078663          	beqz	a5,800056f8 <virtio_disk_init+0x1a0>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    800055f0:	100017b7          	lui	a5,0x10001
    800055f4:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    800055f8:	43fc                	lw	a5,68(a5)
    800055fa:	2781                	sext.w	a5,a5
    800055fc:	10079663          	bnez	a5,80005708 <virtio_disk_init+0x1b0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005600:	100017b7          	lui	a5,0x10001
    80005604:	5bdc                	lw	a5,52(a5)
    80005606:	2781                	sext.w	a5,a5
  if(max == 0)
    80005608:	10078863          	beqz	a5,80005718 <virtio_disk_init+0x1c0>
  if(max < NUM)
    8000560c:	471d                	li	a4,7
    8000560e:	10f77d63          	bgeu	a4,a5,80005728 <virtio_disk_init+0x1d0>
  disk.desc = kalloc();
    80005612:	ffffb097          	auipc	ra,0xffffb
    80005616:	b06080e7          	jalr	-1274(ra) # 80000118 <kalloc>
    8000561a:	00026497          	auipc	s1,0x26
    8000561e:	3d648493          	addi	s1,s1,982 # 8002b9f0 <disk>
    80005622:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005624:	ffffb097          	auipc	ra,0xffffb
    80005628:	af4080e7          	jalr	-1292(ra) # 80000118 <kalloc>
    8000562c:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000562e:	ffffb097          	auipc	ra,0xffffb
    80005632:	aea080e7          	jalr	-1302(ra) # 80000118 <kalloc>
    80005636:	87aa                	mv	a5,a0
    80005638:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    8000563a:	6088                	ld	a0,0(s1)
    8000563c:	cd75                	beqz	a0,80005738 <virtio_disk_init+0x1e0>
    8000563e:	00026717          	auipc	a4,0x26
    80005642:	3ba73703          	ld	a4,954(a4) # 8002b9f8 <disk+0x8>
    80005646:	cb6d                	beqz	a4,80005738 <virtio_disk_init+0x1e0>
    80005648:	cbe5                	beqz	a5,80005738 <virtio_disk_init+0x1e0>
  memset(disk.desc, 0, PGSIZE);
    8000564a:	6605                	lui	a2,0x1
    8000564c:	4581                	li	a1,0
    8000564e:	ffffb097          	auipc	ra,0xffffb
    80005652:	b2a080e7          	jalr	-1238(ra) # 80000178 <memset>
  memset(disk.avail, 0, PGSIZE);
    80005656:	00026497          	auipc	s1,0x26
    8000565a:	39a48493          	addi	s1,s1,922 # 8002b9f0 <disk>
    8000565e:	6605                	lui	a2,0x1
    80005660:	4581                	li	a1,0
    80005662:	6488                	ld	a0,8(s1)
    80005664:	ffffb097          	auipc	ra,0xffffb
    80005668:	b14080e7          	jalr	-1260(ra) # 80000178 <memset>
  memset(disk.used, 0, PGSIZE);
    8000566c:	6605                	lui	a2,0x1
    8000566e:	4581                	li	a1,0
    80005670:	6888                	ld	a0,16(s1)
    80005672:	ffffb097          	auipc	ra,0xffffb
    80005676:	b06080e7          	jalr	-1274(ra) # 80000178 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    8000567a:	100017b7          	lui	a5,0x10001
    8000567e:	4721                	li	a4,8
    80005680:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    80005682:	4098                	lw	a4,0(s1)
    80005684:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    80005688:	40d8                	lw	a4,4(s1)
    8000568a:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    8000568e:	6498                	ld	a4,8(s1)
    80005690:	0007069b          	sext.w	a3,a4
    80005694:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    80005698:	9701                	srai	a4,a4,0x20
    8000569a:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    8000569e:	6898                	ld	a4,16(s1)
    800056a0:	0007069b          	sext.w	a3,a4
    800056a4:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    800056a8:	9701                	srai	a4,a4,0x20
    800056aa:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    800056ae:	4685                	li	a3,1
    800056b0:	c3f4                	sw	a3,68(a5)
    disk.free[i] = 1;
    800056b2:	4705                	li	a4,1
    800056b4:	00d48c23          	sb	a3,24(s1)
    800056b8:	00e48ca3          	sb	a4,25(s1)
    800056bc:	00e48d23          	sb	a4,26(s1)
    800056c0:	00e48da3          	sb	a4,27(s1)
    800056c4:	00e48e23          	sb	a4,28(s1)
    800056c8:	00e48ea3          	sb	a4,29(s1)
    800056cc:	00e48f23          	sb	a4,30(s1)
    800056d0:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    800056d4:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    800056d8:	0727a823          	sw	s2,112(a5)
}
    800056dc:	60e2                	ld	ra,24(sp)
    800056de:	6442                	ld	s0,16(sp)
    800056e0:	64a2                	ld	s1,8(sp)
    800056e2:	6902                	ld	s2,0(sp)
    800056e4:	6105                	addi	sp,sp,32
    800056e6:	8082                	ret
    panic("could not find virtio disk");
    800056e8:	00003517          	auipc	a0,0x3
    800056ec:	02050513          	addi	a0,a0,32 # 80008708 <syscalls+0x348>
    800056f0:	00001097          	auipc	ra,0x1
    800056f4:	8c2080e7          	jalr	-1854(ra) # 80005fb2 <panic>
    panic("virtio disk FEATURES_OK unset");
    800056f8:	00003517          	auipc	a0,0x3
    800056fc:	03050513          	addi	a0,a0,48 # 80008728 <syscalls+0x368>
    80005700:	00001097          	auipc	ra,0x1
    80005704:	8b2080e7          	jalr	-1870(ra) # 80005fb2 <panic>
    panic("virtio disk should not be ready");
    80005708:	00003517          	auipc	a0,0x3
    8000570c:	04050513          	addi	a0,a0,64 # 80008748 <syscalls+0x388>
    80005710:	00001097          	auipc	ra,0x1
    80005714:	8a2080e7          	jalr	-1886(ra) # 80005fb2 <panic>
    panic("virtio disk has no queue 0");
    80005718:	00003517          	auipc	a0,0x3
    8000571c:	05050513          	addi	a0,a0,80 # 80008768 <syscalls+0x3a8>
    80005720:	00001097          	auipc	ra,0x1
    80005724:	892080e7          	jalr	-1902(ra) # 80005fb2 <panic>
    panic("virtio disk max queue too short");
    80005728:	00003517          	auipc	a0,0x3
    8000572c:	06050513          	addi	a0,a0,96 # 80008788 <syscalls+0x3c8>
    80005730:	00001097          	auipc	ra,0x1
    80005734:	882080e7          	jalr	-1918(ra) # 80005fb2 <panic>
    panic("virtio disk kalloc");
    80005738:	00003517          	auipc	a0,0x3
    8000573c:	07050513          	addi	a0,a0,112 # 800087a8 <syscalls+0x3e8>
    80005740:	00001097          	auipc	ra,0x1
    80005744:	872080e7          	jalr	-1934(ra) # 80005fb2 <panic>

0000000080005748 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005748:	7159                	addi	sp,sp,-112
    8000574a:	f486                	sd	ra,104(sp)
    8000574c:	f0a2                	sd	s0,96(sp)
    8000574e:	eca6                	sd	s1,88(sp)
    80005750:	e8ca                	sd	s2,80(sp)
    80005752:	e4ce                	sd	s3,72(sp)
    80005754:	e0d2                	sd	s4,64(sp)
    80005756:	fc56                	sd	s5,56(sp)
    80005758:	f85a                	sd	s6,48(sp)
    8000575a:	f45e                	sd	s7,40(sp)
    8000575c:	f062                	sd	s8,32(sp)
    8000575e:	ec66                	sd	s9,24(sp)
    80005760:	e86a                	sd	s10,16(sp)
    80005762:	1880                	addi	s0,sp,112
    80005764:	892a                	mv	s2,a0
    80005766:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005768:	00c52c83          	lw	s9,12(a0)
    8000576c:	001c9c9b          	slliw	s9,s9,0x1
    80005770:	1c82                	slli	s9,s9,0x20
    80005772:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005776:	00026517          	auipc	a0,0x26
    8000577a:	3a250513          	addi	a0,a0,930 # 8002bb18 <disk+0x128>
    8000577e:	00001097          	auipc	ra,0x1
    80005782:	d7e080e7          	jalr	-642(ra) # 800064fc <acquire>
  for(int i = 0; i < 3; i++){
    80005786:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    80005788:	4ba1                	li	s7,8
      disk.free[i] = 0;
    8000578a:	00026b17          	auipc	s6,0x26
    8000578e:	266b0b13          	addi	s6,s6,614 # 8002b9f0 <disk>
  for(int i = 0; i < 3; i++){
    80005792:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    80005794:	8a4e                	mv	s4,s3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005796:	00026c17          	auipc	s8,0x26
    8000579a:	382c0c13          	addi	s8,s8,898 # 8002bb18 <disk+0x128>
    8000579e:	a8b5                	j	8000581a <virtio_disk_rw+0xd2>
      disk.free[i] = 0;
    800057a0:	00fb06b3          	add	a3,s6,a5
    800057a4:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    800057a8:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    800057aa:	0207c563          	bltz	a5,800057d4 <virtio_disk_rw+0x8c>
  for(int i = 0; i < 3; i++){
    800057ae:	2485                	addiw	s1,s1,1
    800057b0:	0711                	addi	a4,a4,4
    800057b2:	1f548a63          	beq	s1,s5,800059a6 <virtio_disk_rw+0x25e>
    idx[i] = alloc_desc();
    800057b6:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    800057b8:	00026697          	auipc	a3,0x26
    800057bc:	23868693          	addi	a3,a3,568 # 8002b9f0 <disk>
    800057c0:	87d2                	mv	a5,s4
    if(disk.free[i]){
    800057c2:	0186c583          	lbu	a1,24(a3)
    800057c6:	fde9                	bnez	a1,800057a0 <virtio_disk_rw+0x58>
  for(int i = 0; i < NUM; i++){
    800057c8:	2785                	addiw	a5,a5,1
    800057ca:	0685                	addi	a3,a3,1
    800057cc:	ff779be3          	bne	a5,s7,800057c2 <virtio_disk_rw+0x7a>
    idx[i] = alloc_desc();
    800057d0:	57fd                	li	a5,-1
    800057d2:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    800057d4:	02905a63          	blez	s1,80005808 <virtio_disk_rw+0xc0>
        free_desc(idx[j]);
    800057d8:	f9042503          	lw	a0,-112(s0)
    800057dc:	00000097          	auipc	ra,0x0
    800057e0:	cfa080e7          	jalr	-774(ra) # 800054d6 <free_desc>
      for(int j = 0; j < i; j++)
    800057e4:	4785                	li	a5,1
    800057e6:	0297d163          	bge	a5,s1,80005808 <virtio_disk_rw+0xc0>
        free_desc(idx[j]);
    800057ea:	f9442503          	lw	a0,-108(s0)
    800057ee:	00000097          	auipc	ra,0x0
    800057f2:	ce8080e7          	jalr	-792(ra) # 800054d6 <free_desc>
      for(int j = 0; j < i; j++)
    800057f6:	4789                	li	a5,2
    800057f8:	0097d863          	bge	a5,s1,80005808 <virtio_disk_rw+0xc0>
        free_desc(idx[j]);
    800057fc:	f9842503          	lw	a0,-104(s0)
    80005800:	00000097          	auipc	ra,0x0
    80005804:	cd6080e7          	jalr	-810(ra) # 800054d6 <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005808:	85e2                	mv	a1,s8
    8000580a:	00026517          	auipc	a0,0x26
    8000580e:	1fe50513          	addi	a0,a0,510 # 8002ba08 <disk+0x18>
    80005812:	ffffc097          	auipc	ra,0xffffc
    80005816:	d38080e7          	jalr	-712(ra) # 8000154a <sleep>
  for(int i = 0; i < 3; i++){
    8000581a:	f9040713          	addi	a4,s0,-112
    8000581e:	84ce                	mv	s1,s3
    80005820:	bf59                	j	800057b6 <virtio_disk_rw+0x6e>
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

  if(write)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    80005822:	00a60793          	addi	a5,a2,10 # 100a <_entry-0x7fffeff6>
    80005826:	00479693          	slli	a3,a5,0x4
    8000582a:	00026797          	auipc	a5,0x26
    8000582e:	1c678793          	addi	a5,a5,454 # 8002b9f0 <disk>
    80005832:	97b6                	add	a5,a5,a3
    80005834:	4685                	li	a3,1
    80005836:	c794                	sw	a3,8(a5)
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80005838:	00026597          	auipc	a1,0x26
    8000583c:	1b858593          	addi	a1,a1,440 # 8002b9f0 <disk>
    80005840:	00a60793          	addi	a5,a2,10
    80005844:	0792                	slli	a5,a5,0x4
    80005846:	97ae                	add	a5,a5,a1
    80005848:	0007a623          	sw	zero,12(a5)
  buf0->sector = sector;
    8000584c:	0197b823          	sd	s9,16(a5)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005850:	f6070693          	addi	a3,a4,-160
    80005854:	619c                	ld	a5,0(a1)
    80005856:	97b6                	add	a5,a5,a3
    80005858:	e388                	sd	a0,0(a5)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    8000585a:	6188                	ld	a0,0(a1)
    8000585c:	96aa                	add	a3,a3,a0
    8000585e:	47c1                	li	a5,16
    80005860:	c69c                	sw	a5,8(a3)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005862:	4785                	li	a5,1
    80005864:	00f69623          	sh	a5,12(a3)
  disk.desc[idx[0]].next = idx[1];
    80005868:	f9442783          	lw	a5,-108(s0)
    8000586c:	00f69723          	sh	a5,14(a3)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005870:	0792                	slli	a5,a5,0x4
    80005872:	953e                	add	a0,a0,a5
    80005874:	05890693          	addi	a3,s2,88
    80005878:	e114                	sd	a3,0(a0)
  disk.desc[idx[1]].len = BSIZE;
    8000587a:	6188                	ld	a0,0(a1)
    8000587c:	97aa                	add	a5,a5,a0
    8000587e:	40000693          	li	a3,1024
    80005882:	c794                	sw	a3,8(a5)
  if(write)
    80005884:	100d0d63          	beqz	s10,8000599e <virtio_disk_rw+0x256>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    80005888:	00079623          	sh	zero,12(a5)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    8000588c:	00c7d683          	lhu	a3,12(a5)
    80005890:	0016e693          	ori	a3,a3,1
    80005894:	00d79623          	sh	a3,12(a5)
  disk.desc[idx[1]].next = idx[2];
    80005898:	f9842583          	lw	a1,-104(s0)
    8000589c:	00b79723          	sh	a1,14(a5)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800058a0:	00026697          	auipc	a3,0x26
    800058a4:	15068693          	addi	a3,a3,336 # 8002b9f0 <disk>
    800058a8:	00260793          	addi	a5,a2,2
    800058ac:	0792                	slli	a5,a5,0x4
    800058ae:	97b6                	add	a5,a5,a3
    800058b0:	587d                	li	a6,-1
    800058b2:	01078823          	sb	a6,16(a5)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800058b6:	0592                	slli	a1,a1,0x4
    800058b8:	952e                	add	a0,a0,a1
    800058ba:	f9070713          	addi	a4,a4,-112
    800058be:	9736                	add	a4,a4,a3
    800058c0:	e118                	sd	a4,0(a0)
  disk.desc[idx[2]].len = 1;
    800058c2:	6298                	ld	a4,0(a3)
    800058c4:	972e                	add	a4,a4,a1
    800058c6:	4585                	li	a1,1
    800058c8:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800058ca:	4509                	li	a0,2
    800058cc:	00a71623          	sh	a0,12(a4)
  disk.desc[idx[2]].next = 0;
    800058d0:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800058d4:	00b92223          	sw	a1,4(s2)
  disk.info[idx[0]].b = b;
    800058d8:	0127b423          	sd	s2,8(a5)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800058dc:	6698                	ld	a4,8(a3)
    800058de:	00275783          	lhu	a5,2(a4)
    800058e2:	8b9d                	andi	a5,a5,7
    800058e4:	0786                	slli	a5,a5,0x1
    800058e6:	97ba                	add	a5,a5,a4
    800058e8:	00c79223          	sh	a2,4(a5)

  __sync_synchronize();
    800058ec:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    800058f0:	6698                	ld	a4,8(a3)
    800058f2:	00275783          	lhu	a5,2(a4)
    800058f6:	2785                	addiw	a5,a5,1
    800058f8:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    800058fc:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005900:	100017b7          	lui	a5,0x10001
    80005904:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005908:	00492703          	lw	a4,4(s2)
    8000590c:	4785                	li	a5,1
    8000590e:	02f71163          	bne	a4,a5,80005930 <virtio_disk_rw+0x1e8>
    sleep(b, &disk.vdisk_lock);
    80005912:	00026997          	auipc	s3,0x26
    80005916:	20698993          	addi	s3,s3,518 # 8002bb18 <disk+0x128>
  while(b->disk == 1) {
    8000591a:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    8000591c:	85ce                	mv	a1,s3
    8000591e:	854a                	mv	a0,s2
    80005920:	ffffc097          	auipc	ra,0xffffc
    80005924:	c2a080e7          	jalr	-982(ra) # 8000154a <sleep>
  while(b->disk == 1) {
    80005928:	00492783          	lw	a5,4(s2)
    8000592c:	fe9788e3          	beq	a5,s1,8000591c <virtio_disk_rw+0x1d4>
  }

  disk.info[idx[0]].b = 0;
    80005930:	f9042903          	lw	s2,-112(s0)
    80005934:	00290793          	addi	a5,s2,2
    80005938:	00479713          	slli	a4,a5,0x4
    8000593c:	00026797          	auipc	a5,0x26
    80005940:	0b478793          	addi	a5,a5,180 # 8002b9f0 <disk>
    80005944:	97ba                	add	a5,a5,a4
    80005946:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    8000594a:	00026997          	auipc	s3,0x26
    8000594e:	0a698993          	addi	s3,s3,166 # 8002b9f0 <disk>
    80005952:	00491713          	slli	a4,s2,0x4
    80005956:	0009b783          	ld	a5,0(s3)
    8000595a:	97ba                	add	a5,a5,a4
    8000595c:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005960:	854a                	mv	a0,s2
    80005962:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005966:	00000097          	auipc	ra,0x0
    8000596a:	b70080e7          	jalr	-1168(ra) # 800054d6 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    8000596e:	8885                	andi	s1,s1,1
    80005970:	f0ed                	bnez	s1,80005952 <virtio_disk_rw+0x20a>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005972:	00026517          	auipc	a0,0x26
    80005976:	1a650513          	addi	a0,a0,422 # 8002bb18 <disk+0x128>
    8000597a:	00001097          	auipc	ra,0x1
    8000597e:	c36080e7          	jalr	-970(ra) # 800065b0 <release>
}
    80005982:	70a6                	ld	ra,104(sp)
    80005984:	7406                	ld	s0,96(sp)
    80005986:	64e6                	ld	s1,88(sp)
    80005988:	6946                	ld	s2,80(sp)
    8000598a:	69a6                	ld	s3,72(sp)
    8000598c:	6a06                	ld	s4,64(sp)
    8000598e:	7ae2                	ld	s5,56(sp)
    80005990:	7b42                	ld	s6,48(sp)
    80005992:	7ba2                	ld	s7,40(sp)
    80005994:	7c02                	ld	s8,32(sp)
    80005996:	6ce2                	ld	s9,24(sp)
    80005998:	6d42                	ld	s10,16(sp)
    8000599a:	6165                	addi	sp,sp,112
    8000599c:	8082                	ret
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    8000599e:	4689                	li	a3,2
    800059a0:	00d79623          	sh	a3,12(a5)
    800059a4:	b5e5                	j	8000588c <virtio_disk_rw+0x144>
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    800059a6:	f9042603          	lw	a2,-112(s0)
    800059aa:	00a60713          	addi	a4,a2,10
    800059ae:	0712                	slli	a4,a4,0x4
    800059b0:	00026517          	auipc	a0,0x26
    800059b4:	04850513          	addi	a0,a0,72 # 8002b9f8 <disk+0x8>
    800059b8:	953a                	add	a0,a0,a4
  if(write)
    800059ba:	e60d14e3          	bnez	s10,80005822 <virtio_disk_rw+0xda>
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    800059be:	00a60793          	addi	a5,a2,10
    800059c2:	00479693          	slli	a3,a5,0x4
    800059c6:	00026797          	auipc	a5,0x26
    800059ca:	02a78793          	addi	a5,a5,42 # 8002b9f0 <disk>
    800059ce:	97b6                	add	a5,a5,a3
    800059d0:	0007a423          	sw	zero,8(a5)
    800059d4:	b595                	j	80005838 <virtio_disk_rw+0xf0>

00000000800059d6 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    800059d6:	1101                	addi	sp,sp,-32
    800059d8:	ec06                	sd	ra,24(sp)
    800059da:	e822                	sd	s0,16(sp)
    800059dc:	e426                	sd	s1,8(sp)
    800059de:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    800059e0:	00026497          	auipc	s1,0x26
    800059e4:	01048493          	addi	s1,s1,16 # 8002b9f0 <disk>
    800059e8:	00026517          	auipc	a0,0x26
    800059ec:	13050513          	addi	a0,a0,304 # 8002bb18 <disk+0x128>
    800059f0:	00001097          	auipc	ra,0x1
    800059f4:	b0c080e7          	jalr	-1268(ra) # 800064fc <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    800059f8:	10001737          	lui	a4,0x10001
    800059fc:	533c                	lw	a5,96(a4)
    800059fe:	8b8d                	andi	a5,a5,3
    80005a00:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80005a02:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005a06:	689c                	ld	a5,16(s1)
    80005a08:	0204d703          	lhu	a4,32(s1)
    80005a0c:	0027d783          	lhu	a5,2(a5)
    80005a10:	04f70863          	beq	a4,a5,80005a60 <virtio_disk_intr+0x8a>
    __sync_synchronize();
    80005a14:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005a18:	6898                	ld	a4,16(s1)
    80005a1a:	0204d783          	lhu	a5,32(s1)
    80005a1e:	8b9d                	andi	a5,a5,7
    80005a20:	078e                	slli	a5,a5,0x3
    80005a22:	97ba                	add	a5,a5,a4
    80005a24:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005a26:	00278713          	addi	a4,a5,2
    80005a2a:	0712                	slli	a4,a4,0x4
    80005a2c:	9726                	add	a4,a4,s1
    80005a2e:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    80005a32:	e721                	bnez	a4,80005a7a <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005a34:	0789                	addi	a5,a5,2
    80005a36:	0792                	slli	a5,a5,0x4
    80005a38:	97a6                	add	a5,a5,s1
    80005a3a:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80005a3c:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005a40:	ffffc097          	auipc	ra,0xffffc
    80005a44:	b6e080e7          	jalr	-1170(ra) # 800015ae <wakeup>

    disk.used_idx += 1;
    80005a48:	0204d783          	lhu	a5,32(s1)
    80005a4c:	2785                	addiw	a5,a5,1
    80005a4e:	17c2                	slli	a5,a5,0x30
    80005a50:	93c1                	srli	a5,a5,0x30
    80005a52:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005a56:	6898                	ld	a4,16(s1)
    80005a58:	00275703          	lhu	a4,2(a4)
    80005a5c:	faf71ce3          	bne	a4,a5,80005a14 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80005a60:	00026517          	auipc	a0,0x26
    80005a64:	0b850513          	addi	a0,a0,184 # 8002bb18 <disk+0x128>
    80005a68:	00001097          	auipc	ra,0x1
    80005a6c:	b48080e7          	jalr	-1208(ra) # 800065b0 <release>
}
    80005a70:	60e2                	ld	ra,24(sp)
    80005a72:	6442                	ld	s0,16(sp)
    80005a74:	64a2                	ld	s1,8(sp)
    80005a76:	6105                	addi	sp,sp,32
    80005a78:	8082                	ret
      panic("virtio_disk_intr status");
    80005a7a:	00003517          	auipc	a0,0x3
    80005a7e:	d4650513          	addi	a0,a0,-698 # 800087c0 <syscalls+0x400>
    80005a82:	00000097          	auipc	ra,0x0
    80005a86:	530080e7          	jalr	1328(ra) # 80005fb2 <panic>

0000000080005a8a <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005a8a:	1141                	addi	sp,sp,-16
    80005a8c:	e422                	sd	s0,8(sp)
    80005a8e:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005a90:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005a94:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005a98:	0037979b          	slliw	a5,a5,0x3
    80005a9c:	02004737          	lui	a4,0x2004
    80005aa0:	97ba                	add	a5,a5,a4
    80005aa2:	0200c737          	lui	a4,0x200c
    80005aa6:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005aaa:	000f4637          	lui	a2,0xf4
    80005aae:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005ab2:	95b2                	add	a1,a1,a2
    80005ab4:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005ab6:	00269713          	slli	a4,a3,0x2
    80005aba:	9736                	add	a4,a4,a3
    80005abc:	00371693          	slli	a3,a4,0x3
    80005ac0:	00026717          	auipc	a4,0x26
    80005ac4:	07070713          	addi	a4,a4,112 # 8002bb30 <timer_scratch>
    80005ac8:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005aca:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80005acc:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80005ace:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80005ad2:	00000797          	auipc	a5,0x0
    80005ad6:	93e78793          	addi	a5,a5,-1730 # 80005410 <timervec>
    80005ada:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005ade:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80005ae2:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005ae6:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005aea:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80005aee:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80005af2:	30479073          	csrw	mie,a5
}
    80005af6:	6422                	ld	s0,8(sp)
    80005af8:	0141                	addi	sp,sp,16
    80005afa:	8082                	ret

0000000080005afc <start>:
{
    80005afc:	1141                	addi	sp,sp,-16
    80005afe:	e406                	sd	ra,8(sp)
    80005b00:	e022                	sd	s0,0(sp)
    80005b02:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005b04:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005b08:	7779                	lui	a4,0xffffe
    80005b0a:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffcaa8f>
    80005b0e:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80005b10:	6705                	lui	a4,0x1
    80005b12:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005b16:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005b18:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005b1c:	ffffb797          	auipc	a5,0xffffb
    80005b20:	80a78793          	addi	a5,a5,-2038 # 80000326 <main>
    80005b24:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005b28:	4781                	li	a5,0
    80005b2a:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005b2e:	67c1                	lui	a5,0x10
    80005b30:	17fd                	addi	a5,a5,-1
    80005b32:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005b36:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005b3a:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005b3e:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005b42:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005b46:	57fd                	li	a5,-1
    80005b48:	83a9                	srli	a5,a5,0xa
    80005b4a:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005b4e:	47bd                	li	a5,15
    80005b50:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005b54:	00000097          	auipc	ra,0x0
    80005b58:	f36080e7          	jalr	-202(ra) # 80005a8a <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005b5c:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005b60:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005b62:	823e                	mv	tp,a5
  asm volatile("mret");
    80005b64:	30200073          	mret
}
    80005b68:	60a2                	ld	ra,8(sp)
    80005b6a:	6402                	ld	s0,0(sp)
    80005b6c:	0141                	addi	sp,sp,16
    80005b6e:	8082                	ret

0000000080005b70 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005b70:	715d                	addi	sp,sp,-80
    80005b72:	e486                	sd	ra,72(sp)
    80005b74:	e0a2                	sd	s0,64(sp)
    80005b76:	fc26                	sd	s1,56(sp)
    80005b78:	f84a                	sd	s2,48(sp)
    80005b7a:	f44e                	sd	s3,40(sp)
    80005b7c:	f052                	sd	s4,32(sp)
    80005b7e:	ec56                	sd	s5,24(sp)
    80005b80:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005b82:	04c05663          	blez	a2,80005bce <consolewrite+0x5e>
    80005b86:	8a2a                	mv	s4,a0
    80005b88:	84ae                	mv	s1,a1
    80005b8a:	89b2                	mv	s3,a2
    80005b8c:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005b8e:	5afd                	li	s5,-1
    80005b90:	4685                	li	a3,1
    80005b92:	8626                	mv	a2,s1
    80005b94:	85d2                	mv	a1,s4
    80005b96:	fbf40513          	addi	a0,s0,-65
    80005b9a:	ffffc097          	auipc	ra,0xffffc
    80005b9e:	e0e080e7          	jalr	-498(ra) # 800019a8 <either_copyin>
    80005ba2:	01550c63          	beq	a0,s5,80005bba <consolewrite+0x4a>
      break;
    uartputc(c);
    80005ba6:	fbf44503          	lbu	a0,-65(s0)
    80005baa:	00000097          	auipc	ra,0x0
    80005bae:	794080e7          	jalr	1940(ra) # 8000633e <uartputc>
  for(i = 0; i < n; i++){
    80005bb2:	2905                	addiw	s2,s2,1
    80005bb4:	0485                	addi	s1,s1,1
    80005bb6:	fd299de3          	bne	s3,s2,80005b90 <consolewrite+0x20>
  }

  return i;
}
    80005bba:	854a                	mv	a0,s2
    80005bbc:	60a6                	ld	ra,72(sp)
    80005bbe:	6406                	ld	s0,64(sp)
    80005bc0:	74e2                	ld	s1,56(sp)
    80005bc2:	7942                	ld	s2,48(sp)
    80005bc4:	79a2                	ld	s3,40(sp)
    80005bc6:	7a02                	ld	s4,32(sp)
    80005bc8:	6ae2                	ld	s5,24(sp)
    80005bca:	6161                	addi	sp,sp,80
    80005bcc:	8082                	ret
  for(i = 0; i < n; i++){
    80005bce:	4901                	li	s2,0
    80005bd0:	b7ed                	j	80005bba <consolewrite+0x4a>

0000000080005bd2 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005bd2:	7119                	addi	sp,sp,-128
    80005bd4:	fc86                	sd	ra,120(sp)
    80005bd6:	f8a2                	sd	s0,112(sp)
    80005bd8:	f4a6                	sd	s1,104(sp)
    80005bda:	f0ca                	sd	s2,96(sp)
    80005bdc:	ecce                	sd	s3,88(sp)
    80005bde:	e8d2                	sd	s4,80(sp)
    80005be0:	e4d6                	sd	s5,72(sp)
    80005be2:	e0da                	sd	s6,64(sp)
    80005be4:	fc5e                	sd	s7,56(sp)
    80005be6:	f862                	sd	s8,48(sp)
    80005be8:	f466                	sd	s9,40(sp)
    80005bea:	f06a                	sd	s10,32(sp)
    80005bec:	ec6e                	sd	s11,24(sp)
    80005bee:	0100                	addi	s0,sp,128
    80005bf0:	8b2a                	mv	s6,a0
    80005bf2:	8aae                	mv	s5,a1
    80005bf4:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005bf6:	00060b9b          	sext.w	s7,a2
  acquire(&cons.lock);
    80005bfa:	0002e517          	auipc	a0,0x2e
    80005bfe:	07650513          	addi	a0,a0,118 # 80033c70 <cons>
    80005c02:	00001097          	auipc	ra,0x1
    80005c06:	8fa080e7          	jalr	-1798(ra) # 800064fc <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005c0a:	0002e497          	auipc	s1,0x2e
    80005c0e:	06648493          	addi	s1,s1,102 # 80033c70 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005c12:	89a6                	mv	s3,s1
    80005c14:	0002e917          	auipc	s2,0x2e
    80005c18:	0f490913          	addi	s2,s2,244 # 80033d08 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];

    if(c == C('D')){  // end-of-file
    80005c1c:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005c1e:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    80005c20:	4da9                	li	s11,10
  while(n > 0){
    80005c22:	07405b63          	blez	s4,80005c98 <consoleread+0xc6>
    while(cons.r == cons.w){
    80005c26:	0984a783          	lw	a5,152(s1)
    80005c2a:	09c4a703          	lw	a4,156(s1)
    80005c2e:	02f71763          	bne	a4,a5,80005c5c <consoleread+0x8a>
      if(killed(myproc())){
    80005c32:	ffffb097          	auipc	ra,0xffffb
    80005c36:	20c080e7          	jalr	524(ra) # 80000e3e <myproc>
    80005c3a:	ffffc097          	auipc	ra,0xffffc
    80005c3e:	bb8080e7          	jalr	-1096(ra) # 800017f2 <killed>
    80005c42:	e535                	bnez	a0,80005cae <consoleread+0xdc>
      sleep(&cons.r, &cons.lock);
    80005c44:	85ce                	mv	a1,s3
    80005c46:	854a                	mv	a0,s2
    80005c48:	ffffc097          	auipc	ra,0xffffc
    80005c4c:	902080e7          	jalr	-1790(ra) # 8000154a <sleep>
    while(cons.r == cons.w){
    80005c50:	0984a783          	lw	a5,152(s1)
    80005c54:	09c4a703          	lw	a4,156(s1)
    80005c58:	fcf70de3          	beq	a4,a5,80005c32 <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80005c5c:	0017871b          	addiw	a4,a5,1
    80005c60:	08e4ac23          	sw	a4,152(s1)
    80005c64:	07f7f713          	andi	a4,a5,127
    80005c68:	9726                	add	a4,a4,s1
    80005c6a:	01874703          	lbu	a4,24(a4)
    80005c6e:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    80005c72:	079c0663          	beq	s8,s9,80005cde <consoleread+0x10c>
    cbuf = c;
    80005c76:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005c7a:	4685                	li	a3,1
    80005c7c:	f8f40613          	addi	a2,s0,-113
    80005c80:	85d6                	mv	a1,s5
    80005c82:	855a                	mv	a0,s6
    80005c84:	ffffc097          	auipc	ra,0xffffc
    80005c88:	cce080e7          	jalr	-818(ra) # 80001952 <either_copyout>
    80005c8c:	01a50663          	beq	a0,s10,80005c98 <consoleread+0xc6>
    dst++;
    80005c90:	0a85                	addi	s5,s5,1
    --n;
    80005c92:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    80005c94:	f9bc17e3          	bne	s8,s11,80005c22 <consoleread+0x50>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005c98:	0002e517          	auipc	a0,0x2e
    80005c9c:	fd850513          	addi	a0,a0,-40 # 80033c70 <cons>
    80005ca0:	00001097          	auipc	ra,0x1
    80005ca4:	910080e7          	jalr	-1776(ra) # 800065b0 <release>

  return target - n;
    80005ca8:	414b853b          	subw	a0,s7,s4
    80005cac:	a811                	j	80005cc0 <consoleread+0xee>
        release(&cons.lock);
    80005cae:	0002e517          	auipc	a0,0x2e
    80005cb2:	fc250513          	addi	a0,a0,-62 # 80033c70 <cons>
    80005cb6:	00001097          	auipc	ra,0x1
    80005cba:	8fa080e7          	jalr	-1798(ra) # 800065b0 <release>
        return -1;
    80005cbe:	557d                	li	a0,-1
}
    80005cc0:	70e6                	ld	ra,120(sp)
    80005cc2:	7446                	ld	s0,112(sp)
    80005cc4:	74a6                	ld	s1,104(sp)
    80005cc6:	7906                	ld	s2,96(sp)
    80005cc8:	69e6                	ld	s3,88(sp)
    80005cca:	6a46                	ld	s4,80(sp)
    80005ccc:	6aa6                	ld	s5,72(sp)
    80005cce:	6b06                	ld	s6,64(sp)
    80005cd0:	7be2                	ld	s7,56(sp)
    80005cd2:	7c42                	ld	s8,48(sp)
    80005cd4:	7ca2                	ld	s9,40(sp)
    80005cd6:	7d02                	ld	s10,32(sp)
    80005cd8:	6de2                	ld	s11,24(sp)
    80005cda:	6109                	addi	sp,sp,128
    80005cdc:	8082                	ret
      if(n < target){
    80005cde:	000a071b          	sext.w	a4,s4
    80005ce2:	fb777be3          	bgeu	a4,s7,80005c98 <consoleread+0xc6>
        cons.r--;
    80005ce6:	0002e717          	auipc	a4,0x2e
    80005cea:	02f72123          	sw	a5,34(a4) # 80033d08 <cons+0x98>
    80005cee:	b76d                	j	80005c98 <consoleread+0xc6>

0000000080005cf0 <consputc>:
{
    80005cf0:	1141                	addi	sp,sp,-16
    80005cf2:	e406                	sd	ra,8(sp)
    80005cf4:	e022                	sd	s0,0(sp)
    80005cf6:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005cf8:	10000793          	li	a5,256
    80005cfc:	00f50a63          	beq	a0,a5,80005d10 <consputc+0x20>
    uartputc_sync(c);
    80005d00:	00000097          	auipc	ra,0x0
    80005d04:	564080e7          	jalr	1380(ra) # 80006264 <uartputc_sync>
}
    80005d08:	60a2                	ld	ra,8(sp)
    80005d0a:	6402                	ld	s0,0(sp)
    80005d0c:	0141                	addi	sp,sp,16
    80005d0e:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005d10:	4521                	li	a0,8
    80005d12:	00000097          	auipc	ra,0x0
    80005d16:	552080e7          	jalr	1362(ra) # 80006264 <uartputc_sync>
    80005d1a:	02000513          	li	a0,32
    80005d1e:	00000097          	auipc	ra,0x0
    80005d22:	546080e7          	jalr	1350(ra) # 80006264 <uartputc_sync>
    80005d26:	4521                	li	a0,8
    80005d28:	00000097          	auipc	ra,0x0
    80005d2c:	53c080e7          	jalr	1340(ra) # 80006264 <uartputc_sync>
    80005d30:	bfe1                	j	80005d08 <consputc+0x18>

0000000080005d32 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005d32:	1101                	addi	sp,sp,-32
    80005d34:	ec06                	sd	ra,24(sp)
    80005d36:	e822                	sd	s0,16(sp)
    80005d38:	e426                	sd	s1,8(sp)
    80005d3a:	e04a                	sd	s2,0(sp)
    80005d3c:	1000                	addi	s0,sp,32
    80005d3e:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005d40:	0002e517          	auipc	a0,0x2e
    80005d44:	f3050513          	addi	a0,a0,-208 # 80033c70 <cons>
    80005d48:	00000097          	auipc	ra,0x0
    80005d4c:	7b4080e7          	jalr	1972(ra) # 800064fc <acquire>

  switch(c){
    80005d50:	47d5                	li	a5,21
    80005d52:	0af48663          	beq	s1,a5,80005dfe <consoleintr+0xcc>
    80005d56:	0297ca63          	blt	a5,s1,80005d8a <consoleintr+0x58>
    80005d5a:	47a1                	li	a5,8
    80005d5c:	0ef48763          	beq	s1,a5,80005e4a <consoleintr+0x118>
    80005d60:	47c1                	li	a5,16
    80005d62:	10f49a63          	bne	s1,a5,80005e76 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005d66:	ffffc097          	auipc	ra,0xffffc
    80005d6a:	c98080e7          	jalr	-872(ra) # 800019fe <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005d6e:	0002e517          	auipc	a0,0x2e
    80005d72:	f0250513          	addi	a0,a0,-254 # 80033c70 <cons>
    80005d76:	00001097          	auipc	ra,0x1
    80005d7a:	83a080e7          	jalr	-1990(ra) # 800065b0 <release>
}
    80005d7e:	60e2                	ld	ra,24(sp)
    80005d80:	6442                	ld	s0,16(sp)
    80005d82:	64a2                	ld	s1,8(sp)
    80005d84:	6902                	ld	s2,0(sp)
    80005d86:	6105                	addi	sp,sp,32
    80005d88:	8082                	ret
  switch(c){
    80005d8a:	07f00793          	li	a5,127
    80005d8e:	0af48e63          	beq	s1,a5,80005e4a <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005d92:	0002e717          	auipc	a4,0x2e
    80005d96:	ede70713          	addi	a4,a4,-290 # 80033c70 <cons>
    80005d9a:	0a072783          	lw	a5,160(a4)
    80005d9e:	09872703          	lw	a4,152(a4)
    80005da2:	9f99                	subw	a5,a5,a4
    80005da4:	07f00713          	li	a4,127
    80005da8:	fcf763e3          	bltu	a4,a5,80005d6e <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005dac:	47b5                	li	a5,13
    80005dae:	0cf48763          	beq	s1,a5,80005e7c <consoleintr+0x14a>
      consputc(c);
    80005db2:	8526                	mv	a0,s1
    80005db4:	00000097          	auipc	ra,0x0
    80005db8:	f3c080e7          	jalr	-196(ra) # 80005cf0 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005dbc:	0002e797          	auipc	a5,0x2e
    80005dc0:	eb478793          	addi	a5,a5,-332 # 80033c70 <cons>
    80005dc4:	0a07a683          	lw	a3,160(a5)
    80005dc8:	0016871b          	addiw	a4,a3,1
    80005dcc:	0007061b          	sext.w	a2,a4
    80005dd0:	0ae7a023          	sw	a4,160(a5)
    80005dd4:	07f6f693          	andi	a3,a3,127
    80005dd8:	97b6                	add	a5,a5,a3
    80005dda:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005dde:	47a9                	li	a5,10
    80005de0:	0cf48563          	beq	s1,a5,80005eaa <consoleintr+0x178>
    80005de4:	4791                	li	a5,4
    80005de6:	0cf48263          	beq	s1,a5,80005eaa <consoleintr+0x178>
    80005dea:	0002e797          	auipc	a5,0x2e
    80005dee:	f1e7a783          	lw	a5,-226(a5) # 80033d08 <cons+0x98>
    80005df2:	9f1d                	subw	a4,a4,a5
    80005df4:	08000793          	li	a5,128
    80005df8:	f6f71be3          	bne	a4,a5,80005d6e <consoleintr+0x3c>
    80005dfc:	a07d                	j	80005eaa <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005dfe:	0002e717          	auipc	a4,0x2e
    80005e02:	e7270713          	addi	a4,a4,-398 # 80033c70 <cons>
    80005e06:	0a072783          	lw	a5,160(a4)
    80005e0a:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005e0e:	0002e497          	auipc	s1,0x2e
    80005e12:	e6248493          	addi	s1,s1,-414 # 80033c70 <cons>
    while(cons.e != cons.w &&
    80005e16:	4929                	li	s2,10
    80005e18:	f4f70be3          	beq	a4,a5,80005d6e <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005e1c:	37fd                	addiw	a5,a5,-1
    80005e1e:	07f7f713          	andi	a4,a5,127
    80005e22:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005e24:	01874703          	lbu	a4,24(a4)
    80005e28:	f52703e3          	beq	a4,s2,80005d6e <consoleintr+0x3c>
      cons.e--;
    80005e2c:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005e30:	10000513          	li	a0,256
    80005e34:	00000097          	auipc	ra,0x0
    80005e38:	ebc080e7          	jalr	-324(ra) # 80005cf0 <consputc>
    while(cons.e != cons.w &&
    80005e3c:	0a04a783          	lw	a5,160(s1)
    80005e40:	09c4a703          	lw	a4,156(s1)
    80005e44:	fcf71ce3          	bne	a4,a5,80005e1c <consoleintr+0xea>
    80005e48:	b71d                	j	80005d6e <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005e4a:	0002e717          	auipc	a4,0x2e
    80005e4e:	e2670713          	addi	a4,a4,-474 # 80033c70 <cons>
    80005e52:	0a072783          	lw	a5,160(a4)
    80005e56:	09c72703          	lw	a4,156(a4)
    80005e5a:	f0f70ae3          	beq	a4,a5,80005d6e <consoleintr+0x3c>
      cons.e--;
    80005e5e:	37fd                	addiw	a5,a5,-1
    80005e60:	0002e717          	auipc	a4,0x2e
    80005e64:	eaf72823          	sw	a5,-336(a4) # 80033d10 <cons+0xa0>
      consputc(BACKSPACE);
    80005e68:	10000513          	li	a0,256
    80005e6c:	00000097          	auipc	ra,0x0
    80005e70:	e84080e7          	jalr	-380(ra) # 80005cf0 <consputc>
    80005e74:	bded                	j	80005d6e <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005e76:	ee048ce3          	beqz	s1,80005d6e <consoleintr+0x3c>
    80005e7a:	bf21                	j	80005d92 <consoleintr+0x60>
      consputc(c);
    80005e7c:	4529                	li	a0,10
    80005e7e:	00000097          	auipc	ra,0x0
    80005e82:	e72080e7          	jalr	-398(ra) # 80005cf0 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005e86:	0002e797          	auipc	a5,0x2e
    80005e8a:	dea78793          	addi	a5,a5,-534 # 80033c70 <cons>
    80005e8e:	0a07a703          	lw	a4,160(a5)
    80005e92:	0017069b          	addiw	a3,a4,1
    80005e96:	0006861b          	sext.w	a2,a3
    80005e9a:	0ad7a023          	sw	a3,160(a5)
    80005e9e:	07f77713          	andi	a4,a4,127
    80005ea2:	97ba                	add	a5,a5,a4
    80005ea4:	4729                	li	a4,10
    80005ea6:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005eaa:	0002e797          	auipc	a5,0x2e
    80005eae:	e6c7a123          	sw	a2,-414(a5) # 80033d0c <cons+0x9c>
        wakeup(&cons.r);
    80005eb2:	0002e517          	auipc	a0,0x2e
    80005eb6:	e5650513          	addi	a0,a0,-426 # 80033d08 <cons+0x98>
    80005eba:	ffffb097          	auipc	ra,0xffffb
    80005ebe:	6f4080e7          	jalr	1780(ra) # 800015ae <wakeup>
    80005ec2:	b575                	j	80005d6e <consoleintr+0x3c>

0000000080005ec4 <consoleinit>:

void
consoleinit(void)
{
    80005ec4:	1141                	addi	sp,sp,-16
    80005ec6:	e406                	sd	ra,8(sp)
    80005ec8:	e022                	sd	s0,0(sp)
    80005eca:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005ecc:	00003597          	auipc	a1,0x3
    80005ed0:	90c58593          	addi	a1,a1,-1780 # 800087d8 <syscalls+0x418>
    80005ed4:	0002e517          	auipc	a0,0x2e
    80005ed8:	d9c50513          	addi	a0,a0,-612 # 80033c70 <cons>
    80005edc:	00000097          	auipc	ra,0x0
    80005ee0:	590080e7          	jalr	1424(ra) # 8000646c <initlock>

  uartinit();
    80005ee4:	00000097          	auipc	ra,0x0
    80005ee8:	330080e7          	jalr	816(ra) # 80006214 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    80005eec:	00025797          	auipc	a5,0x25
    80005ef0:	aac78793          	addi	a5,a5,-1364 # 8002a998 <devsw>
    80005ef4:	00000717          	auipc	a4,0x0
    80005ef8:	cde70713          	addi	a4,a4,-802 # 80005bd2 <consoleread>
    80005efc:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    80005efe:	00000717          	auipc	a4,0x0
    80005f02:	c7270713          	addi	a4,a4,-910 # 80005b70 <consolewrite>
    80005f06:	ef98                	sd	a4,24(a5)
}
    80005f08:	60a2                	ld	ra,8(sp)
    80005f0a:	6402                	ld	s0,0(sp)
    80005f0c:	0141                	addi	sp,sp,16
    80005f0e:	8082                	ret

0000000080005f10 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80005f10:	7179                	addi	sp,sp,-48
    80005f12:	f406                	sd	ra,40(sp)
    80005f14:	f022                	sd	s0,32(sp)
    80005f16:	ec26                	sd	s1,24(sp)
    80005f18:	e84a                	sd	s2,16(sp)
    80005f1a:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    80005f1c:	c219                	beqz	a2,80005f22 <printint+0x12>
    80005f1e:	08054663          	bltz	a0,80005faa <printint+0x9a>
    x = -xx;
  else
    x = xx;
    80005f22:	2501                	sext.w	a0,a0
    80005f24:	4881                	li	a7,0
    80005f26:	fd040693          	addi	a3,s0,-48

  i = 0;
    80005f2a:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    80005f2c:	2581                	sext.w	a1,a1
    80005f2e:	00003617          	auipc	a2,0x3
    80005f32:	8da60613          	addi	a2,a2,-1830 # 80008808 <digits>
    80005f36:	883a                	mv	a6,a4
    80005f38:	2705                	addiw	a4,a4,1
    80005f3a:	02b577bb          	remuw	a5,a0,a1
    80005f3e:	1782                	slli	a5,a5,0x20
    80005f40:	9381                	srli	a5,a5,0x20
    80005f42:	97b2                	add	a5,a5,a2
    80005f44:	0007c783          	lbu	a5,0(a5)
    80005f48:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    80005f4c:	0005079b          	sext.w	a5,a0
    80005f50:	02b5553b          	divuw	a0,a0,a1
    80005f54:	0685                	addi	a3,a3,1
    80005f56:	feb7f0e3          	bgeu	a5,a1,80005f36 <printint+0x26>

  if(sign)
    80005f5a:	00088b63          	beqz	a7,80005f70 <printint+0x60>
    buf[i++] = '-';
    80005f5e:	fe040793          	addi	a5,s0,-32
    80005f62:	973e                	add	a4,a4,a5
    80005f64:	02d00793          	li	a5,45
    80005f68:	fef70823          	sb	a5,-16(a4)
    80005f6c:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80005f70:	02e05763          	blez	a4,80005f9e <printint+0x8e>
    80005f74:	fd040793          	addi	a5,s0,-48
    80005f78:	00e784b3          	add	s1,a5,a4
    80005f7c:	fff78913          	addi	s2,a5,-1
    80005f80:	993a                	add	s2,s2,a4
    80005f82:	377d                	addiw	a4,a4,-1
    80005f84:	1702                	slli	a4,a4,0x20
    80005f86:	9301                	srli	a4,a4,0x20
    80005f88:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    80005f8c:	fff4c503          	lbu	a0,-1(s1)
    80005f90:	00000097          	auipc	ra,0x0
    80005f94:	d60080e7          	jalr	-672(ra) # 80005cf0 <consputc>
  while(--i >= 0)
    80005f98:	14fd                	addi	s1,s1,-1
    80005f9a:	ff2499e3          	bne	s1,s2,80005f8c <printint+0x7c>
}
    80005f9e:	70a2                	ld	ra,40(sp)
    80005fa0:	7402                	ld	s0,32(sp)
    80005fa2:	64e2                	ld	s1,24(sp)
    80005fa4:	6942                	ld	s2,16(sp)
    80005fa6:	6145                	addi	sp,sp,48
    80005fa8:	8082                	ret
    x = -xx;
    80005faa:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    80005fae:	4885                	li	a7,1
    x = -xx;
    80005fb0:	bf9d                	j	80005f26 <printint+0x16>

0000000080005fb2 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    80005fb2:	1101                	addi	sp,sp,-32
    80005fb4:	ec06                	sd	ra,24(sp)
    80005fb6:	e822                	sd	s0,16(sp)
    80005fb8:	e426                	sd	s1,8(sp)
    80005fba:	1000                	addi	s0,sp,32
    80005fbc:	84aa                	mv	s1,a0
  pr.locking = 0;
    80005fbe:	0002e797          	auipc	a5,0x2e
    80005fc2:	d607a923          	sw	zero,-654(a5) # 80033d30 <pr+0x18>
  printf("panic: ");
    80005fc6:	00003517          	auipc	a0,0x3
    80005fca:	81a50513          	addi	a0,a0,-2022 # 800087e0 <syscalls+0x420>
    80005fce:	00000097          	auipc	ra,0x0
    80005fd2:	02e080e7          	jalr	46(ra) # 80005ffc <printf>
  printf(s);
    80005fd6:	8526                	mv	a0,s1
    80005fd8:	00000097          	auipc	ra,0x0
    80005fdc:	024080e7          	jalr	36(ra) # 80005ffc <printf>
  printf("\n");
    80005fe0:	00002517          	auipc	a0,0x2
    80005fe4:	06850513          	addi	a0,a0,104 # 80008048 <etext+0x48>
    80005fe8:	00000097          	auipc	ra,0x0
    80005fec:	014080e7          	jalr	20(ra) # 80005ffc <printf>
  panicked = 1; // freeze uart output from other CPUs
    80005ff0:	4785                	li	a5,1
    80005ff2:	00003717          	auipc	a4,0x3
    80005ff6:	8ef72d23          	sw	a5,-1798(a4) # 800088ec <panicked>
  for(;;)
    80005ffa:	a001                	j	80005ffa <panic+0x48>

0000000080005ffc <printf>:
{
    80005ffc:	7131                	addi	sp,sp,-192
    80005ffe:	fc86                	sd	ra,120(sp)
    80006000:	f8a2                	sd	s0,112(sp)
    80006002:	f4a6                	sd	s1,104(sp)
    80006004:	f0ca                	sd	s2,96(sp)
    80006006:	ecce                	sd	s3,88(sp)
    80006008:	e8d2                	sd	s4,80(sp)
    8000600a:	e4d6                	sd	s5,72(sp)
    8000600c:	e0da                	sd	s6,64(sp)
    8000600e:	fc5e                	sd	s7,56(sp)
    80006010:	f862                	sd	s8,48(sp)
    80006012:	f466                	sd	s9,40(sp)
    80006014:	f06a                	sd	s10,32(sp)
    80006016:	ec6e                	sd	s11,24(sp)
    80006018:	0100                	addi	s0,sp,128
    8000601a:	8a2a                	mv	s4,a0
    8000601c:	e40c                	sd	a1,8(s0)
    8000601e:	e810                	sd	a2,16(s0)
    80006020:	ec14                	sd	a3,24(s0)
    80006022:	f018                	sd	a4,32(s0)
    80006024:	f41c                	sd	a5,40(s0)
    80006026:	03043823          	sd	a6,48(s0)
    8000602a:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    8000602e:	0002ed97          	auipc	s11,0x2e
    80006032:	d02dad83          	lw	s11,-766(s11) # 80033d30 <pr+0x18>
  if(locking)
    80006036:	020d9b63          	bnez	s11,8000606c <printf+0x70>
  if (fmt == 0)
    8000603a:	040a0263          	beqz	s4,8000607e <printf+0x82>
  va_start(ap, fmt);
    8000603e:	00840793          	addi	a5,s0,8
    80006042:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80006046:	000a4503          	lbu	a0,0(s4)
    8000604a:	16050263          	beqz	a0,800061ae <printf+0x1b2>
    8000604e:	4481                	li	s1,0
    if(c != '%'){
    80006050:	02500a93          	li	s5,37
    switch(c){
    80006054:	07000b13          	li	s6,112
  consputc('x');
    80006058:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    8000605a:	00002b97          	auipc	s7,0x2
    8000605e:	7aeb8b93          	addi	s7,s7,1966 # 80008808 <digits>
    switch(c){
    80006062:	07300c93          	li	s9,115
    80006066:	06400c13          	li	s8,100
    8000606a:	a82d                	j	800060a4 <printf+0xa8>
    acquire(&pr.lock);
    8000606c:	0002e517          	auipc	a0,0x2e
    80006070:	cac50513          	addi	a0,a0,-852 # 80033d18 <pr>
    80006074:	00000097          	auipc	ra,0x0
    80006078:	488080e7          	jalr	1160(ra) # 800064fc <acquire>
    8000607c:	bf7d                	j	8000603a <printf+0x3e>
    panic("null fmt");
    8000607e:	00002517          	auipc	a0,0x2
    80006082:	77250513          	addi	a0,a0,1906 # 800087f0 <syscalls+0x430>
    80006086:	00000097          	auipc	ra,0x0
    8000608a:	f2c080e7          	jalr	-212(ra) # 80005fb2 <panic>
      consputc(c);
    8000608e:	00000097          	auipc	ra,0x0
    80006092:	c62080e7          	jalr	-926(ra) # 80005cf0 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80006096:	2485                	addiw	s1,s1,1
    80006098:	009a07b3          	add	a5,s4,s1
    8000609c:	0007c503          	lbu	a0,0(a5)
    800060a0:	10050763          	beqz	a0,800061ae <printf+0x1b2>
    if(c != '%'){
    800060a4:	ff5515e3          	bne	a0,s5,8000608e <printf+0x92>
    c = fmt[++i] & 0xff;
    800060a8:	2485                	addiw	s1,s1,1
    800060aa:	009a07b3          	add	a5,s4,s1
    800060ae:	0007c783          	lbu	a5,0(a5)
    800060b2:	0007891b          	sext.w	s2,a5
    if(c == 0)
    800060b6:	cfe5                	beqz	a5,800061ae <printf+0x1b2>
    switch(c){
    800060b8:	05678a63          	beq	a5,s6,8000610c <printf+0x110>
    800060bc:	02fb7663          	bgeu	s6,a5,800060e8 <printf+0xec>
    800060c0:	09978963          	beq	a5,s9,80006152 <printf+0x156>
    800060c4:	07800713          	li	a4,120
    800060c8:	0ce79863          	bne	a5,a4,80006198 <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    800060cc:	f8843783          	ld	a5,-120(s0)
    800060d0:	00878713          	addi	a4,a5,8
    800060d4:	f8e43423          	sd	a4,-120(s0)
    800060d8:	4605                	li	a2,1
    800060da:	85ea                	mv	a1,s10
    800060dc:	4388                	lw	a0,0(a5)
    800060de:	00000097          	auipc	ra,0x0
    800060e2:	e32080e7          	jalr	-462(ra) # 80005f10 <printint>
      break;
    800060e6:	bf45                	j	80006096 <printf+0x9a>
    switch(c){
    800060e8:	0b578263          	beq	a5,s5,8000618c <printf+0x190>
    800060ec:	0b879663          	bne	a5,s8,80006198 <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    800060f0:	f8843783          	ld	a5,-120(s0)
    800060f4:	00878713          	addi	a4,a5,8
    800060f8:	f8e43423          	sd	a4,-120(s0)
    800060fc:	4605                	li	a2,1
    800060fe:	45a9                	li	a1,10
    80006100:	4388                	lw	a0,0(a5)
    80006102:	00000097          	auipc	ra,0x0
    80006106:	e0e080e7          	jalr	-498(ra) # 80005f10 <printint>
      break;
    8000610a:	b771                	j	80006096 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    8000610c:	f8843783          	ld	a5,-120(s0)
    80006110:	00878713          	addi	a4,a5,8
    80006114:	f8e43423          	sd	a4,-120(s0)
    80006118:	0007b983          	ld	s3,0(a5)
  consputc('0');
    8000611c:	03000513          	li	a0,48
    80006120:	00000097          	auipc	ra,0x0
    80006124:	bd0080e7          	jalr	-1072(ra) # 80005cf0 <consputc>
  consputc('x');
    80006128:	07800513          	li	a0,120
    8000612c:	00000097          	auipc	ra,0x0
    80006130:	bc4080e7          	jalr	-1084(ra) # 80005cf0 <consputc>
    80006134:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80006136:	03c9d793          	srli	a5,s3,0x3c
    8000613a:	97de                	add	a5,a5,s7
    8000613c:	0007c503          	lbu	a0,0(a5)
    80006140:	00000097          	auipc	ra,0x0
    80006144:	bb0080e7          	jalr	-1104(ra) # 80005cf0 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80006148:	0992                	slli	s3,s3,0x4
    8000614a:	397d                	addiw	s2,s2,-1
    8000614c:	fe0915e3          	bnez	s2,80006136 <printf+0x13a>
    80006150:	b799                	j	80006096 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80006152:	f8843783          	ld	a5,-120(s0)
    80006156:	00878713          	addi	a4,a5,8
    8000615a:	f8e43423          	sd	a4,-120(s0)
    8000615e:	0007b903          	ld	s2,0(a5)
    80006162:	00090e63          	beqz	s2,8000617e <printf+0x182>
      for(; *s; s++)
    80006166:	00094503          	lbu	a0,0(s2)
    8000616a:	d515                	beqz	a0,80006096 <printf+0x9a>
        consputc(*s);
    8000616c:	00000097          	auipc	ra,0x0
    80006170:	b84080e7          	jalr	-1148(ra) # 80005cf0 <consputc>
      for(; *s; s++)
    80006174:	0905                	addi	s2,s2,1
    80006176:	00094503          	lbu	a0,0(s2)
    8000617a:	f96d                	bnez	a0,8000616c <printf+0x170>
    8000617c:	bf29                	j	80006096 <printf+0x9a>
        s = "(null)";
    8000617e:	00002917          	auipc	s2,0x2
    80006182:	66a90913          	addi	s2,s2,1642 # 800087e8 <syscalls+0x428>
      for(; *s; s++)
    80006186:	02800513          	li	a0,40
    8000618a:	b7cd                	j	8000616c <printf+0x170>
      consputc('%');
    8000618c:	8556                	mv	a0,s5
    8000618e:	00000097          	auipc	ra,0x0
    80006192:	b62080e7          	jalr	-1182(ra) # 80005cf0 <consputc>
      break;
    80006196:	b701                	j	80006096 <printf+0x9a>
      consputc('%');
    80006198:	8556                	mv	a0,s5
    8000619a:	00000097          	auipc	ra,0x0
    8000619e:	b56080e7          	jalr	-1194(ra) # 80005cf0 <consputc>
      consputc(c);
    800061a2:	854a                	mv	a0,s2
    800061a4:	00000097          	auipc	ra,0x0
    800061a8:	b4c080e7          	jalr	-1204(ra) # 80005cf0 <consputc>
      break;
    800061ac:	b5ed                	j	80006096 <printf+0x9a>
  if(locking)
    800061ae:	020d9163          	bnez	s11,800061d0 <printf+0x1d4>
}
    800061b2:	70e6                	ld	ra,120(sp)
    800061b4:	7446                	ld	s0,112(sp)
    800061b6:	74a6                	ld	s1,104(sp)
    800061b8:	7906                	ld	s2,96(sp)
    800061ba:	69e6                	ld	s3,88(sp)
    800061bc:	6a46                	ld	s4,80(sp)
    800061be:	6aa6                	ld	s5,72(sp)
    800061c0:	6b06                	ld	s6,64(sp)
    800061c2:	7be2                	ld	s7,56(sp)
    800061c4:	7c42                	ld	s8,48(sp)
    800061c6:	7ca2                	ld	s9,40(sp)
    800061c8:	7d02                	ld	s10,32(sp)
    800061ca:	6de2                	ld	s11,24(sp)
    800061cc:	6129                	addi	sp,sp,192
    800061ce:	8082                	ret
    release(&pr.lock);
    800061d0:	0002e517          	auipc	a0,0x2e
    800061d4:	b4850513          	addi	a0,a0,-1208 # 80033d18 <pr>
    800061d8:	00000097          	auipc	ra,0x0
    800061dc:	3d8080e7          	jalr	984(ra) # 800065b0 <release>
}
    800061e0:	bfc9                	j	800061b2 <printf+0x1b6>

00000000800061e2 <printfinit>:
    ;
}

void
printfinit(void)
{
    800061e2:	1101                	addi	sp,sp,-32
    800061e4:	ec06                	sd	ra,24(sp)
    800061e6:	e822                	sd	s0,16(sp)
    800061e8:	e426                	sd	s1,8(sp)
    800061ea:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    800061ec:	0002e497          	auipc	s1,0x2e
    800061f0:	b2c48493          	addi	s1,s1,-1236 # 80033d18 <pr>
    800061f4:	00002597          	auipc	a1,0x2
    800061f8:	60c58593          	addi	a1,a1,1548 # 80008800 <syscalls+0x440>
    800061fc:	8526                	mv	a0,s1
    800061fe:	00000097          	auipc	ra,0x0
    80006202:	26e080e7          	jalr	622(ra) # 8000646c <initlock>
  pr.locking = 1;
    80006206:	4785                	li	a5,1
    80006208:	cc9c                	sw	a5,24(s1)
}
    8000620a:	60e2                	ld	ra,24(sp)
    8000620c:	6442                	ld	s0,16(sp)
    8000620e:	64a2                	ld	s1,8(sp)
    80006210:	6105                	addi	sp,sp,32
    80006212:	8082                	ret

0000000080006214 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80006214:	1141                	addi	sp,sp,-16
    80006216:	e406                	sd	ra,8(sp)
    80006218:	e022                	sd	s0,0(sp)
    8000621a:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    8000621c:	100007b7          	lui	a5,0x10000
    80006220:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80006224:	f8000713          	li	a4,-128
    80006228:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    8000622c:	470d                	li	a4,3
    8000622e:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80006232:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80006236:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    8000623a:	469d                	li	a3,7
    8000623c:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80006240:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80006244:	00002597          	auipc	a1,0x2
    80006248:	5dc58593          	addi	a1,a1,1500 # 80008820 <digits+0x18>
    8000624c:	0002e517          	auipc	a0,0x2e
    80006250:	aec50513          	addi	a0,a0,-1300 # 80033d38 <uart_tx_lock>
    80006254:	00000097          	auipc	ra,0x0
    80006258:	218080e7          	jalr	536(ra) # 8000646c <initlock>
}
    8000625c:	60a2                	ld	ra,8(sp)
    8000625e:	6402                	ld	s0,0(sp)
    80006260:	0141                	addi	sp,sp,16
    80006262:	8082                	ret

0000000080006264 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80006264:	1101                	addi	sp,sp,-32
    80006266:	ec06                	sd	ra,24(sp)
    80006268:	e822                	sd	s0,16(sp)
    8000626a:	e426                	sd	s1,8(sp)
    8000626c:	1000                	addi	s0,sp,32
    8000626e:	84aa                	mv	s1,a0
  push_off();
    80006270:	00000097          	auipc	ra,0x0
    80006274:	240080e7          	jalr	576(ra) # 800064b0 <push_off>

  if(panicked){
    80006278:	00002797          	auipc	a5,0x2
    8000627c:	6747a783          	lw	a5,1652(a5) # 800088ec <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006280:	10000737          	lui	a4,0x10000
  if(panicked){
    80006284:	c391                	beqz	a5,80006288 <uartputc_sync+0x24>
    for(;;)
    80006286:	a001                	j	80006286 <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    80006288:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    8000628c:	0ff7f793          	andi	a5,a5,255
    80006290:	0207f793          	andi	a5,a5,32
    80006294:	dbf5                	beqz	a5,80006288 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    80006296:	0ff4f793          	andi	a5,s1,255
    8000629a:	10000737          	lui	a4,0x10000
    8000629e:	00f70023          	sb	a5,0(a4) # 10000000 <_entry-0x70000000>

  pop_off();
    800062a2:	00000097          	auipc	ra,0x0
    800062a6:	2ae080e7          	jalr	686(ra) # 80006550 <pop_off>
}
    800062aa:	60e2                	ld	ra,24(sp)
    800062ac:	6442                	ld	s0,16(sp)
    800062ae:	64a2                	ld	s1,8(sp)
    800062b0:	6105                	addi	sp,sp,32
    800062b2:	8082                	ret

00000000800062b4 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    800062b4:	00002717          	auipc	a4,0x2
    800062b8:	63c73703          	ld	a4,1596(a4) # 800088f0 <uart_tx_r>
    800062bc:	00002797          	auipc	a5,0x2
    800062c0:	63c7b783          	ld	a5,1596(a5) # 800088f8 <uart_tx_w>
    800062c4:	06e78c63          	beq	a5,a4,8000633c <uartstart+0x88>
{
    800062c8:	7139                	addi	sp,sp,-64
    800062ca:	fc06                	sd	ra,56(sp)
    800062cc:	f822                	sd	s0,48(sp)
    800062ce:	f426                	sd	s1,40(sp)
    800062d0:	f04a                	sd	s2,32(sp)
    800062d2:	ec4e                	sd	s3,24(sp)
    800062d4:	e852                	sd	s4,16(sp)
    800062d6:	e456                	sd	s5,8(sp)
    800062d8:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800062da:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800062de:	0002ea17          	auipc	s4,0x2e
    800062e2:	a5aa0a13          	addi	s4,s4,-1446 # 80033d38 <uart_tx_lock>
    uart_tx_r += 1;
    800062e6:	00002497          	auipc	s1,0x2
    800062ea:	60a48493          	addi	s1,s1,1546 # 800088f0 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    800062ee:	00002997          	auipc	s3,0x2
    800062f2:	60a98993          	addi	s3,s3,1546 # 800088f8 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800062f6:	00594783          	lbu	a5,5(s2) # 10000005 <_entry-0x6ffffffb>
    800062fa:	0ff7f793          	andi	a5,a5,255
    800062fe:	0207f793          	andi	a5,a5,32
    80006302:	c785                	beqz	a5,8000632a <uartstart+0x76>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006304:	01f77793          	andi	a5,a4,31
    80006308:	97d2                	add	a5,a5,s4
    8000630a:	0187ca83          	lbu	s5,24(a5)
    uart_tx_r += 1;
    8000630e:	0705                	addi	a4,a4,1
    80006310:	e098                	sd	a4,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80006312:	8526                	mv	a0,s1
    80006314:	ffffb097          	auipc	ra,0xffffb
    80006318:	29a080e7          	jalr	666(ra) # 800015ae <wakeup>
    
    WriteReg(THR, c);
    8000631c:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80006320:	6098                	ld	a4,0(s1)
    80006322:	0009b783          	ld	a5,0(s3)
    80006326:	fce798e3          	bne	a5,a4,800062f6 <uartstart+0x42>
  }
}
    8000632a:	70e2                	ld	ra,56(sp)
    8000632c:	7442                	ld	s0,48(sp)
    8000632e:	74a2                	ld	s1,40(sp)
    80006330:	7902                	ld	s2,32(sp)
    80006332:	69e2                	ld	s3,24(sp)
    80006334:	6a42                	ld	s4,16(sp)
    80006336:	6aa2                	ld	s5,8(sp)
    80006338:	6121                	addi	sp,sp,64
    8000633a:	8082                	ret
    8000633c:	8082                	ret

000000008000633e <uartputc>:
{
    8000633e:	7179                	addi	sp,sp,-48
    80006340:	f406                	sd	ra,40(sp)
    80006342:	f022                	sd	s0,32(sp)
    80006344:	ec26                	sd	s1,24(sp)
    80006346:	e84a                	sd	s2,16(sp)
    80006348:	e44e                	sd	s3,8(sp)
    8000634a:	e052                	sd	s4,0(sp)
    8000634c:	1800                	addi	s0,sp,48
    8000634e:	89aa                	mv	s3,a0
  acquire(&uart_tx_lock);
    80006350:	0002e517          	auipc	a0,0x2e
    80006354:	9e850513          	addi	a0,a0,-1560 # 80033d38 <uart_tx_lock>
    80006358:	00000097          	auipc	ra,0x0
    8000635c:	1a4080e7          	jalr	420(ra) # 800064fc <acquire>
  if(panicked){
    80006360:	00002797          	auipc	a5,0x2
    80006364:	58c7a783          	lw	a5,1420(a5) # 800088ec <panicked>
    80006368:	e7c9                	bnez	a5,800063f2 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000636a:	00002797          	auipc	a5,0x2
    8000636e:	58e7b783          	ld	a5,1422(a5) # 800088f8 <uart_tx_w>
    80006372:	00002717          	auipc	a4,0x2
    80006376:	57e73703          	ld	a4,1406(a4) # 800088f0 <uart_tx_r>
    8000637a:	02070713          	addi	a4,a4,32
    sleep(&uart_tx_r, &uart_tx_lock);
    8000637e:	0002ea17          	auipc	s4,0x2e
    80006382:	9baa0a13          	addi	s4,s4,-1606 # 80033d38 <uart_tx_lock>
    80006386:	00002497          	auipc	s1,0x2
    8000638a:	56a48493          	addi	s1,s1,1386 # 800088f0 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000638e:	00002917          	auipc	s2,0x2
    80006392:	56a90913          	addi	s2,s2,1386 # 800088f8 <uart_tx_w>
    80006396:	00f71f63          	bne	a4,a5,800063b4 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    8000639a:	85d2                	mv	a1,s4
    8000639c:	8526                	mv	a0,s1
    8000639e:	ffffb097          	auipc	ra,0xffffb
    800063a2:	1ac080e7          	jalr	428(ra) # 8000154a <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800063a6:	00093783          	ld	a5,0(s2)
    800063aa:	6098                	ld	a4,0(s1)
    800063ac:	02070713          	addi	a4,a4,32
    800063b0:	fef705e3          	beq	a4,a5,8000639a <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800063b4:	0002e497          	auipc	s1,0x2e
    800063b8:	98448493          	addi	s1,s1,-1660 # 80033d38 <uart_tx_lock>
    800063bc:	01f7f713          	andi	a4,a5,31
    800063c0:	9726                	add	a4,a4,s1
    800063c2:	01370c23          	sb	s3,24(a4)
  uart_tx_w += 1;
    800063c6:	0785                	addi	a5,a5,1
    800063c8:	00002717          	auipc	a4,0x2
    800063cc:	52f73823          	sd	a5,1328(a4) # 800088f8 <uart_tx_w>
  uartstart();
    800063d0:	00000097          	auipc	ra,0x0
    800063d4:	ee4080e7          	jalr	-284(ra) # 800062b4 <uartstart>
  release(&uart_tx_lock);
    800063d8:	8526                	mv	a0,s1
    800063da:	00000097          	auipc	ra,0x0
    800063de:	1d6080e7          	jalr	470(ra) # 800065b0 <release>
}
    800063e2:	70a2                	ld	ra,40(sp)
    800063e4:	7402                	ld	s0,32(sp)
    800063e6:	64e2                	ld	s1,24(sp)
    800063e8:	6942                	ld	s2,16(sp)
    800063ea:	69a2                	ld	s3,8(sp)
    800063ec:	6a02                	ld	s4,0(sp)
    800063ee:	6145                	addi	sp,sp,48
    800063f0:	8082                	ret
    for(;;)
    800063f2:	a001                	j	800063f2 <uartputc+0xb4>

00000000800063f4 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    800063f4:	1141                	addi	sp,sp,-16
    800063f6:	e422                	sd	s0,8(sp)
    800063f8:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    800063fa:	100007b7          	lui	a5,0x10000
    800063fe:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80006402:	8b85                	andi	a5,a5,1
    80006404:	cb91                	beqz	a5,80006418 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    80006406:	100007b7          	lui	a5,0x10000
    8000640a:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    8000640e:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    80006412:	6422                	ld	s0,8(sp)
    80006414:	0141                	addi	sp,sp,16
    80006416:	8082                	ret
    return -1;
    80006418:	557d                	li	a0,-1
    8000641a:	bfe5                	j	80006412 <uartgetc+0x1e>

000000008000641c <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    8000641c:	1101                	addi	sp,sp,-32
    8000641e:	ec06                	sd	ra,24(sp)
    80006420:	e822                	sd	s0,16(sp)
    80006422:	e426                	sd	s1,8(sp)
    80006424:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80006426:	54fd                	li	s1,-1
    int c = uartgetc();
    80006428:	00000097          	auipc	ra,0x0
    8000642c:	fcc080e7          	jalr	-52(ra) # 800063f4 <uartgetc>
    if(c == -1)
    80006430:	00950763          	beq	a0,s1,8000643e <uartintr+0x22>
      break;
    consoleintr(c);
    80006434:	00000097          	auipc	ra,0x0
    80006438:	8fe080e7          	jalr	-1794(ra) # 80005d32 <consoleintr>
  while(1){
    8000643c:	b7f5                	j	80006428 <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    8000643e:	0002e497          	auipc	s1,0x2e
    80006442:	8fa48493          	addi	s1,s1,-1798 # 80033d38 <uart_tx_lock>
    80006446:	8526                	mv	a0,s1
    80006448:	00000097          	auipc	ra,0x0
    8000644c:	0b4080e7          	jalr	180(ra) # 800064fc <acquire>
  uartstart();
    80006450:	00000097          	auipc	ra,0x0
    80006454:	e64080e7          	jalr	-412(ra) # 800062b4 <uartstart>
  release(&uart_tx_lock);
    80006458:	8526                	mv	a0,s1
    8000645a:	00000097          	auipc	ra,0x0
    8000645e:	156080e7          	jalr	342(ra) # 800065b0 <release>
}
    80006462:	60e2                	ld	ra,24(sp)
    80006464:	6442                	ld	s0,16(sp)
    80006466:	64a2                	ld	s1,8(sp)
    80006468:	6105                	addi	sp,sp,32
    8000646a:	8082                	ret

000000008000646c <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    8000646c:	1141                	addi	sp,sp,-16
    8000646e:	e422                	sd	s0,8(sp)
    80006470:	0800                	addi	s0,sp,16
  lk->name = name;
    80006472:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80006474:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80006478:	00053823          	sd	zero,16(a0)
}
    8000647c:	6422                	ld	s0,8(sp)
    8000647e:	0141                	addi	sp,sp,16
    80006480:	8082                	ret

0000000080006482 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    80006482:	411c                	lw	a5,0(a0)
    80006484:	e399                	bnez	a5,8000648a <holding+0x8>
    80006486:	4501                	li	a0,0
  return r;
}
    80006488:	8082                	ret
{
    8000648a:	1101                	addi	sp,sp,-32
    8000648c:	ec06                	sd	ra,24(sp)
    8000648e:	e822                	sd	s0,16(sp)
    80006490:	e426                	sd	s1,8(sp)
    80006492:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    80006494:	6904                	ld	s1,16(a0)
    80006496:	ffffb097          	auipc	ra,0xffffb
    8000649a:	98c080e7          	jalr	-1652(ra) # 80000e22 <mycpu>
    8000649e:	40a48533          	sub	a0,s1,a0
    800064a2:	00153513          	seqz	a0,a0
}
    800064a6:	60e2                	ld	ra,24(sp)
    800064a8:	6442                	ld	s0,16(sp)
    800064aa:	64a2                	ld	s1,8(sp)
    800064ac:	6105                	addi	sp,sp,32
    800064ae:	8082                	ret

00000000800064b0 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    800064b0:	1101                	addi	sp,sp,-32
    800064b2:	ec06                	sd	ra,24(sp)
    800064b4:	e822                	sd	s0,16(sp)
    800064b6:	e426                	sd	s1,8(sp)
    800064b8:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800064ba:	100024f3          	csrr	s1,sstatus
    800064be:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800064c2:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800064c4:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    800064c8:	ffffb097          	auipc	ra,0xffffb
    800064cc:	95a080e7          	jalr	-1702(ra) # 80000e22 <mycpu>
    800064d0:	5d3c                	lw	a5,120(a0)
    800064d2:	cf89                	beqz	a5,800064ec <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800064d4:	ffffb097          	auipc	ra,0xffffb
    800064d8:	94e080e7          	jalr	-1714(ra) # 80000e22 <mycpu>
    800064dc:	5d3c                	lw	a5,120(a0)
    800064de:	2785                	addiw	a5,a5,1
    800064e0:	dd3c                	sw	a5,120(a0)
}
    800064e2:	60e2                	ld	ra,24(sp)
    800064e4:	6442                	ld	s0,16(sp)
    800064e6:	64a2                	ld	s1,8(sp)
    800064e8:	6105                	addi	sp,sp,32
    800064ea:	8082                	ret
    mycpu()->intena = old;
    800064ec:	ffffb097          	auipc	ra,0xffffb
    800064f0:	936080e7          	jalr	-1738(ra) # 80000e22 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    800064f4:	8085                	srli	s1,s1,0x1
    800064f6:	8885                	andi	s1,s1,1
    800064f8:	dd64                	sw	s1,124(a0)
    800064fa:	bfe9                	j	800064d4 <push_off+0x24>

00000000800064fc <acquire>:
{
    800064fc:	1101                	addi	sp,sp,-32
    800064fe:	ec06                	sd	ra,24(sp)
    80006500:	e822                	sd	s0,16(sp)
    80006502:	e426                	sd	s1,8(sp)
    80006504:	1000                	addi	s0,sp,32
    80006506:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80006508:	00000097          	auipc	ra,0x0
    8000650c:	fa8080e7          	jalr	-88(ra) # 800064b0 <push_off>
  if(holding(lk))
    80006510:	8526                	mv	a0,s1
    80006512:	00000097          	auipc	ra,0x0
    80006516:	f70080e7          	jalr	-144(ra) # 80006482 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000651a:	4705                	li	a4,1
  if(holding(lk))
    8000651c:	e115                	bnez	a0,80006540 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000651e:	87ba                	mv	a5,a4
    80006520:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80006524:	2781                	sext.w	a5,a5
    80006526:	ffe5                	bnez	a5,8000651e <acquire+0x22>
  __sync_synchronize();
    80006528:	0ff0000f          	fence
  lk->cpu = mycpu();
    8000652c:	ffffb097          	auipc	ra,0xffffb
    80006530:	8f6080e7          	jalr	-1802(ra) # 80000e22 <mycpu>
    80006534:	e888                	sd	a0,16(s1)
}
    80006536:	60e2                	ld	ra,24(sp)
    80006538:	6442                	ld	s0,16(sp)
    8000653a:	64a2                	ld	s1,8(sp)
    8000653c:	6105                	addi	sp,sp,32
    8000653e:	8082                	ret
    panic("acquire");
    80006540:	00002517          	auipc	a0,0x2
    80006544:	2e850513          	addi	a0,a0,744 # 80008828 <digits+0x20>
    80006548:	00000097          	auipc	ra,0x0
    8000654c:	a6a080e7          	jalr	-1430(ra) # 80005fb2 <panic>

0000000080006550 <pop_off>:

void
pop_off(void)
{
    80006550:	1141                	addi	sp,sp,-16
    80006552:	e406                	sd	ra,8(sp)
    80006554:	e022                	sd	s0,0(sp)
    80006556:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80006558:	ffffb097          	auipc	ra,0xffffb
    8000655c:	8ca080e7          	jalr	-1846(ra) # 80000e22 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006560:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80006564:	8b89                	andi	a5,a5,2
  if(intr_get())
    80006566:	e78d                	bnez	a5,80006590 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80006568:	5d3c                	lw	a5,120(a0)
    8000656a:	02f05b63          	blez	a5,800065a0 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    8000656e:	37fd                	addiw	a5,a5,-1
    80006570:	0007871b          	sext.w	a4,a5
    80006574:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80006576:	eb09                	bnez	a4,80006588 <pop_off+0x38>
    80006578:	5d7c                	lw	a5,124(a0)
    8000657a:	c799                	beqz	a5,80006588 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000657c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80006580:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80006584:	10079073          	csrw	sstatus,a5
    intr_on();
}
    80006588:	60a2                	ld	ra,8(sp)
    8000658a:	6402                	ld	s0,0(sp)
    8000658c:	0141                	addi	sp,sp,16
    8000658e:	8082                	ret
    panic("pop_off - interruptible");
    80006590:	00002517          	auipc	a0,0x2
    80006594:	2a050513          	addi	a0,a0,672 # 80008830 <digits+0x28>
    80006598:	00000097          	auipc	ra,0x0
    8000659c:	a1a080e7          	jalr	-1510(ra) # 80005fb2 <panic>
    panic("pop_off");
    800065a0:	00002517          	auipc	a0,0x2
    800065a4:	2a850513          	addi	a0,a0,680 # 80008848 <digits+0x40>
    800065a8:	00000097          	auipc	ra,0x0
    800065ac:	a0a080e7          	jalr	-1526(ra) # 80005fb2 <panic>

00000000800065b0 <release>:
{
    800065b0:	1101                	addi	sp,sp,-32
    800065b2:	ec06                	sd	ra,24(sp)
    800065b4:	e822                	sd	s0,16(sp)
    800065b6:	e426                	sd	s1,8(sp)
    800065b8:	1000                	addi	s0,sp,32
    800065ba:	84aa                	mv	s1,a0
  if(!holding(lk))
    800065bc:	00000097          	auipc	ra,0x0
    800065c0:	ec6080e7          	jalr	-314(ra) # 80006482 <holding>
    800065c4:	c115                	beqz	a0,800065e8 <release+0x38>
  lk->cpu = 0;
    800065c6:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800065ca:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    800065ce:	0f50000f          	fence	iorw,ow
    800065d2:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    800065d6:	00000097          	auipc	ra,0x0
    800065da:	f7a080e7          	jalr	-134(ra) # 80006550 <pop_off>
}
    800065de:	60e2                	ld	ra,24(sp)
    800065e0:	6442                	ld	s0,16(sp)
    800065e2:	64a2                	ld	s1,8(sp)
    800065e4:	6105                	addi	sp,sp,32
    800065e6:	8082                	ret
    panic("release");
    800065e8:	00002517          	auipc	a0,0x2
    800065ec:	26850513          	addi	a0,a0,616 # 80008850 <digits+0x48>
    800065f0:	00000097          	auipc	ra,0x0
    800065f4:	9c2080e7          	jalr	-1598(ra) # 80005fb2 <panic>
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
