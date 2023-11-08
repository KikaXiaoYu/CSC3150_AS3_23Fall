
kernel/kernel:     file format elf64-littleriscv


Disassembly of section .text:

0000000080000000 <_entry>:
    80000000:	00009117          	auipc	sp,0x9
    80000004:	b3013103          	ld	sp,-1232(sp) # 80008b30 <_GLOBAL_OFFSET_TABLE_+0x8>
    80000008:	6505                	lui	a0,0x1
    8000000a:	f14025f3          	csrr	a1,mhartid
    8000000e:	0585                	addi	a1,a1,1
    80000010:	02b50533          	mul	a0,a0,a1
    80000014:	912a                	add	sp,sp,a0
    80000016:	407050ef          	jal	ra,80005c1c <start>

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
    80000034:	fc078793          	addi	a5,a5,-64 # 80033ff0 <end>
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
    80000054:	b3090913          	addi	s2,s2,-1232 # 80008b80 <kmem>
    80000058:	854a                	mv	a0,s2
    8000005a:	00006097          	auipc	ra,0x6
    8000005e:	5c2080e7          	jalr	1474(ra) # 8000661c <acquire>
  r->next = kmem.freelist;
    80000062:	01893783          	ld	a5,24(s2)
    80000066:	e09c                	sd	a5,0(s1)
  kmem.freelist = r;
    80000068:	00993c23          	sd	s1,24(s2)
  release(&kmem.lock);
    8000006c:	854a                	mv	a0,s2
    8000006e:	00006097          	auipc	ra,0x6
    80000072:	662080e7          	jalr	1634(ra) # 800066d0 <release>
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
    8000008e:	048080e7          	jalr	72(ra) # 800060d2 <panic>

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
    800000f0:	a9450513          	addi	a0,a0,-1388 # 80008b80 <kmem>
    800000f4:	00006097          	auipc	ra,0x6
    800000f8:	498080e7          	jalr	1176(ra) # 8000658c <initlock>
  freerange(end, (void*)PHYSTOP);
    800000fc:	45c5                	li	a1,17
    800000fe:	05ee                	slli	a1,a1,0x1b
    80000100:	00034517          	auipc	a0,0x34
    80000104:	ef050513          	addi	a0,a0,-272 # 80033ff0 <end>
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
    80000126:	a5e48493          	addi	s1,s1,-1442 # 80008b80 <kmem>
    8000012a:	8526                	mv	a0,s1
    8000012c:	00006097          	auipc	ra,0x6
    80000130:	4f0080e7          	jalr	1264(ra) # 8000661c <acquire>
  r = kmem.freelist;
    80000134:	6c84                	ld	s1,24(s1)
  if(r)
    80000136:	c885                	beqz	s1,80000166 <kalloc+0x4e>
    kmem.freelist = r->next;
    80000138:	609c                	ld	a5,0(s1)
    8000013a:	00009517          	auipc	a0,0x9
    8000013e:	a4650513          	addi	a0,a0,-1466 # 80008b80 <kmem>
    80000142:	ed1c                	sd	a5,24(a0)
  release(&kmem.lock);
    80000144:	00006097          	auipc	ra,0x6
    80000148:	58c080e7          	jalr	1420(ra) # 800066d0 <release>

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
    8000016a:	a1a50513          	addi	a0,a0,-1510 # 80008b80 <kmem>
    8000016e:	00006097          	auipc	ra,0x6
    80000172:	562080e7          	jalr	1378(ra) # 800066d0 <release>
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
    80000336:	00009717          	auipc	a4,0x9
    8000033a:	81a70713          	addi	a4,a4,-2022 # 80008b50 <started>
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
    80000360:	dc0080e7          	jalr	-576(ra) # 8000611c <printf>
    kvminithart();    // turn on paging
    80000364:	00000097          	auipc	ra,0x0
    80000368:	0d8080e7          	jalr	216(ra) # 8000043c <kvminithart>
    trapinithart();   // install kernel trap vector
    8000036c:	00001097          	auipc	ra,0x1
    80000370:	7ce080e7          	jalr	1998(ra) # 80001b3a <trapinithart>
    plicinithart();   // ask PLIC for device interrupts
    80000374:	00005097          	auipc	ra,0x5
    80000378:	1fc080e7          	jalr	508(ra) # 80005570 <plicinithart>
  }

  scheduler();        
    8000037c:	00001097          	auipc	ra,0x1
    80000380:	018080e7          	jalr	24(ra) # 80001394 <scheduler>
    consoleinit();
    80000384:	00006097          	auipc	ra,0x6
    80000388:	c60080e7          	jalr	-928(ra) # 80005fe4 <consoleinit>
    printfinit();
    8000038c:	00006097          	auipc	ra,0x6
    80000390:	f76080e7          	jalr	-138(ra) # 80006302 <printfinit>
    printf("\n");
    80000394:	00008517          	auipc	a0,0x8
    80000398:	cb450513          	addi	a0,a0,-844 # 80008048 <etext+0x48>
    8000039c:	00006097          	auipc	ra,0x6
    800003a0:	d80080e7          	jalr	-640(ra) # 8000611c <printf>
    printf("xv6 kernel is booting\n");
    800003a4:	00008517          	auipc	a0,0x8
    800003a8:	c7c50513          	addi	a0,a0,-900 # 80008020 <etext+0x20>
    800003ac:	00006097          	auipc	ra,0x6
    800003b0:	d70080e7          	jalr	-656(ra) # 8000611c <printf>
    printf("\n");
    800003b4:	00008517          	auipc	a0,0x8
    800003b8:	c9450513          	addi	a0,a0,-876 # 80008048 <etext+0x48>
    800003bc:	00006097          	auipc	ra,0x6
    800003c0:	d60080e7          	jalr	-672(ra) # 8000611c <printf>
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
    800003e8:	72e080e7          	jalr	1838(ra) # 80001b12 <trapinit>
    trapinithart();  // install kernel trap vector
    800003ec:	00001097          	auipc	ra,0x1
    800003f0:	74e080e7          	jalr	1870(ra) # 80001b3a <trapinithart>
    plicinit();      // set up interrupt controller
    800003f4:	00005097          	auipc	ra,0x5
    800003f8:	166080e7          	jalr	358(ra) # 8000555a <plicinit>
    plicinithart();  // ask PLIC for device interrupts
    800003fc:	00005097          	auipc	ra,0x5
    80000400:	174080e7          	jalr	372(ra) # 80005570 <plicinithart>
    binit();         // buffer cache
    80000404:	00002097          	auipc	ra,0x2
    80000408:	fc6080e7          	jalr	-58(ra) # 800023ca <binit>
    iinit();         // inode table
    8000040c:	00002097          	auipc	ra,0x2
    80000410:	66a080e7          	jalr	1642(ra) # 80002a76 <iinit>
    fileinit();      // file table
    80000414:	00003097          	auipc	ra,0x3
    80000418:	608080e7          	jalr	1544(ra) # 80003a1c <fileinit>
    virtio_disk_init(); // emulated hard disk
    8000041c:	00005097          	auipc	ra,0x5
    80000420:	25c080e7          	jalr	604(ra) # 80005678 <virtio_disk_init>
    userinit();      // first user process
    80000424:	00001097          	auipc	ra,0x1
    80000428:	d16080e7          	jalr	-746(ra) # 8000113a <userinit>
    __sync_synchronize();
    8000042c:	0ff0000f          	fence
    started = 1;
    80000430:	4785                	li	a5,1
    80000432:	00008717          	auipc	a4,0x8
    80000436:	70f72f23          	sw	a5,1822(a4) # 80008b50 <started>
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
    8000044a:	7127b783          	ld	a5,1810(a5) # 80008b58 <kernel_pagetable>
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
    80000496:	c40080e7          	jalr	-960(ra) # 800060d2 <panic>
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
    8000058e:	b48080e7          	jalr	-1208(ra) # 800060d2 <panic>
            printf("[Testing] : pte: %d\n", pte);
    80000592:	85aa                	mv	a1,a0
    80000594:	00008517          	auipc	a0,0x8
    80000598:	ad450513          	addi	a0,a0,-1324 # 80008068 <etext+0x68>
    8000059c:	00006097          	auipc	ra,0x6
    800005a0:	b80080e7          	jalr	-1152(ra) # 8000611c <printf>
            printf("[Testing] : PTE_V: %d\n", PTE_V);
    800005a4:	4585                	li	a1,1
    800005a6:	00008517          	auipc	a0,0x8
    800005aa:	ada50513          	addi	a0,a0,-1318 # 80008080 <etext+0x80>
    800005ae:	00006097          	auipc	ra,0x6
    800005b2:	b6e080e7          	jalr	-1170(ra) # 8000611c <printf>
            panic("mappages: remap");
    800005b6:	00008517          	auipc	a0,0x8
    800005ba:	ae250513          	addi	a0,a0,-1310 # 80008098 <etext+0x98>
    800005be:	00006097          	auipc	ra,0x6
    800005c2:	b14080e7          	jalr	-1260(ra) # 800060d2 <panic>
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
    8000063c:	a9a080e7          	jalr	-1382(ra) # 800060d2 <panic>

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
    8000072a:	42a7b923          	sd	a0,1074(a5) # 80008b58 <kernel_pagetable>
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
    80000788:	94e080e7          	jalr	-1714(ra) # 800060d2 <panic>
            panic("uvmunmap: walk");
    8000078c:	00008517          	auipc	a0,0x8
    80000790:	93c50513          	addi	a0,a0,-1732 # 800080c8 <etext+0xc8>
    80000794:	00006097          	auipc	ra,0x6
    80000798:	93e080e7          	jalr	-1730(ra) # 800060d2 <panic>
            panic("uvmunmap: not a leaf");
    8000079c:	00008517          	auipc	a0,0x8
    800007a0:	93c50513          	addi	a0,a0,-1732 # 800080d8 <etext+0xd8>
    800007a4:	00006097          	auipc	ra,0x6
    800007a8:	92e080e7          	jalr	-1746(ra) # 800060d2 <panic>
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
    80000884:	00006097          	auipc	ra,0x6
    80000888:	84e080e7          	jalr	-1970(ra) # 800060d2 <panic>

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
    800009d2:	704080e7          	jalr	1796(ra) # 800060d2 <panic>
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
    80000a56:	680080e7          	jalr	1664(ra) # 800060d2 <panic>
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
    80000b1c:	5ba080e7          	jalr	1466(ra) # 800060d2 <panic>

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
    80000d06:	2ce48493          	addi	s1,s1,718 # 80008fd0 <proc>
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
    80000d20:	cb4a0a13          	addi	s4,s4,-844 # 800209d0 <tickslock>
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
    80000d7e:	358080e7          	jalr	856(ra) # 800060d2 <panic>

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
    80000da2:	e0250513          	addi	a0,a0,-510 # 80008ba0 <pid_lock>
    80000da6:	00005097          	auipc	ra,0x5
    80000daa:	7e6080e7          	jalr	2022(ra) # 8000658c <initlock>
    initlock(&wait_lock, "wait_lock");
    80000dae:	00007597          	auipc	a1,0x7
    80000db2:	3b258593          	addi	a1,a1,946 # 80008160 <etext+0x160>
    80000db6:	00008517          	auipc	a0,0x8
    80000dba:	e0250513          	addi	a0,a0,-510 # 80008bb8 <wait_lock>
    80000dbe:	00005097          	auipc	ra,0x5
    80000dc2:	7ce080e7          	jalr	1998(ra) # 8000658c <initlock>
    for (p = proc; p < &proc[NPROC]; p++)
    80000dc6:	00008497          	auipc	s1,0x8
    80000dca:	20a48493          	addi	s1,s1,522 # 80008fd0 <proc>
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
    80000dec:	be898993          	addi	s3,s3,-1048 # 800209d0 <tickslock>
        initlock(&p->lock, "proc");
    80000df0:	85da                	mv	a1,s6
    80000df2:	8526                	mv	a0,s1
    80000df4:	00005097          	auipc	ra,0x5
    80000df8:	798080e7          	jalr	1944(ra) # 8000658c <initlock>
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
    80000e56:	d7e50513          	addi	a0,a0,-642 # 80008bd0 <cpus>
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
    80000e70:	764080e7          	jalr	1892(ra) # 800065d0 <push_off>
    80000e74:	8792                	mv	a5,tp
    struct cpu *c = mycpu();
    struct proc *p = c->proc;
    80000e76:	2781                	sext.w	a5,a5
    80000e78:	079e                	slli	a5,a5,0x7
    80000e7a:	00008717          	auipc	a4,0x8
    80000e7e:	d2670713          	addi	a4,a4,-730 # 80008ba0 <pid_lock>
    80000e82:	97ba                	add	a5,a5,a4
    80000e84:	7b84                	ld	s1,48(a5)
    pop_off();
    80000e86:	00005097          	auipc	ra,0x5
    80000e8a:	7ea080e7          	jalr	2026(ra) # 80006670 <pop_off>
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
    80000eaa:	00006097          	auipc	ra,0x6
    80000eae:	826080e7          	jalr	-2010(ra) # 800066d0 <release>

    if (first)
    80000eb2:	00008797          	auipc	a5,0x8
    80000eb6:	c2e7a783          	lw	a5,-978(a5) # 80008ae0 <first.1700>
    80000eba:	eb89                	bnez	a5,80000ecc <forkret+0x32>
        // be run from main().
        first = 0;
        fsinit(ROOTDEV);
    }

    usertrapret();
    80000ebc:	00001097          	auipc	ra,0x1
    80000ec0:	c96080e7          	jalr	-874(ra) # 80001b52 <usertrapret>
}
    80000ec4:	60a2                	ld	ra,8(sp)
    80000ec6:	6402                	ld	s0,0(sp)
    80000ec8:	0141                	addi	sp,sp,16
    80000eca:	8082                	ret
        first = 0;
    80000ecc:	00008797          	auipc	a5,0x8
    80000ed0:	c007aa23          	sw	zero,-1004(a5) # 80008ae0 <first.1700>
        fsinit(ROOTDEV);
    80000ed4:	4505                	li	a0,1
    80000ed6:	00002097          	auipc	ra,0x2
    80000eda:	b20080e7          	jalr	-1248(ra) # 800029f6 <fsinit>
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
    80000ef0:	cb490913          	addi	s2,s2,-844 # 80008ba0 <pid_lock>
    80000ef4:	854a                	mv	a0,s2
    80000ef6:	00005097          	auipc	ra,0x5
    80000efa:	726080e7          	jalr	1830(ra) # 8000661c <acquire>
    pid = nextpid;
    80000efe:	00008797          	auipc	a5,0x8
    80000f02:	be678793          	addi	a5,a5,-1050 # 80008ae4 <nextpid>
    80000f06:	4384                	lw	s1,0(a5)
    nextpid = nextpid + 1;
    80000f08:	0014871b          	addiw	a4,s1,1
    80000f0c:	c398                	sw	a4,0(a5)
    release(&pid_lock);
    80000f0e:	854a                	mv	a0,s2
    80000f10:	00005097          	auipc	ra,0x5
    80000f14:	7c0080e7          	jalr	1984(ra) # 800066d0 <release>
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
    8000107c:	f5848493          	addi	s1,s1,-168 # 80008fd0 <proc>
    80001080:	00020917          	auipc	s2,0x20
    80001084:	95090913          	addi	s2,s2,-1712 # 800209d0 <tickslock>
        acquire(&p->lock);
    80001088:	8526                	mv	a0,s1
    8000108a:	00005097          	auipc	ra,0x5
    8000108e:	592080e7          	jalr	1426(ra) # 8000661c <acquire>
        if (p->state == UNUSED)
    80001092:	4c9c                	lw	a5,24(s1)
    80001094:	cf81                	beqz	a5,800010ac <allocproc+0x40>
            release(&p->lock);
    80001096:	8526                	mv	a0,s1
    80001098:	00005097          	auipc	ra,0x5
    8000109c:	638080e7          	jalr	1592(ra) # 800066d0 <release>
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
    8000111a:	5ba080e7          	jalr	1466(ra) # 800066d0 <release>
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
    80001132:	5a2080e7          	jalr	1442(ra) # 800066d0 <release>
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
    80001152:	a0a7b923          	sd	a0,-1518(a5) # 80008b60 <initproc>
    uvmfirst(p->pagetable, initcode, sizeof(initcode));
    80001156:	03400613          	li	a2,52
    8000115a:	00008597          	auipc	a1,0x8
    8000115e:	99658593          	addi	a1,a1,-1642 # 80008af0 <initcode>
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
    8000119c:	280080e7          	jalr	640(ra) # 80003418 <namei>
    800011a0:	14a4b823          	sd	a0,336(s1)
    p->state = RUNNABLE;
    800011a4:	478d                	li	a5,3
    800011a6:	cc9c                	sw	a5,24(s1)
    release(&p->lock);
    800011a8:	8526                	mv	a0,s1
    800011aa:	00005097          	auipc	ra,0x5
    800011ae:	526080e7          	jalr	1318(ra) # 800066d0 <release>
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
    8000123a:	14050b63          	beqz	a0,80001390 <fork+0x178>
    8000123e:	89aa                	mv	s3,a0
    if (uvmcopy(p->pagetable, np->pagetable, p->sz) < 0)
    80001240:	04893603          	ld	a2,72(s2)
    80001244:	692c                	ld	a1,80(a0)
    80001246:	05093503          	ld	a0,80(s2)
    8000124a:	fffff097          	auipc	ra,0xfffff
    8000124e:	7de080e7          	jalr	2014(ra) # 80000a28 <uvmcopy>
    80001252:	08054663          	bltz	a0,800012de <fork+0xc6>
    np->sz = p->sz;
    80001256:	04893783          	ld	a5,72(s2)
    8000125a:	04f9b423          	sd	a5,72(s3)
    for (int i = VMASIZE - 1; i >= 0; i--)
    8000125e:	5a090793          	addi	a5,s2,1440
    80001262:	5a098713          	addi	a4,s3,1440
    80001266:	12090613          	addi	a2,s2,288
        p_new_vma->occupied = p_odd_vma->occupied;
    8000126a:	4394                	lw	a3,0(a5)
    8000126c:	c314                	sw	a3,0(a4)
        p_new_vma->start_addr = p_odd_vma->start_addr;
    8000126e:	6794                	ld	a3,8(a5)
    80001270:	e714                	sd	a3,8(a4)
        p_new_vma->end_addr = p_odd_vma->end_addr;
    80001272:	6b94                	ld	a3,16(a5)
    80001274:	eb14                	sd	a3,16(a4)
        p_new_vma->addr = p_odd_vma->addr;
    80001276:	6f94                	ld	a3,24(a5)
    80001278:	ef14                	sd	a3,24(a4)
        p_new_vma->length = p_odd_vma->length;
    8000127a:	7394                	ld	a3,32(a5)
    8000127c:	f314                	sd	a3,32(a4)
        p_new_vma->prot = p_odd_vma->prot;
    8000127e:	5794                	lw	a3,40(a5)
    80001280:	d714                	sw	a3,40(a4)
        p_new_vma->flags = p_odd_vma->flags;
    80001282:	57d4                	lw	a3,44(a5)
    80001284:	d754                	sw	a3,44(a4)
        p_new_vma->fd = p_odd_vma->fd;
    80001286:	5b94                	lw	a3,48(a5)
    80001288:	db14                	sw	a3,48(a4)
        p_new_vma->offset = p_odd_vma->offset;
    8000128a:	7f94                	ld	a3,56(a5)
    8000128c:	ff14                	sd	a3,56(a4)
        p_new_vma->pf = p_odd_vma->pf;
    8000128e:	63b4                	ld	a3,64(a5)
    80001290:	e334                	sd	a3,64(a4)
    for (int i = VMASIZE - 1; i >= 0; i--)
    80001292:	fb878793          	addi	a5,a5,-72 # fb8 <_entry-0x7ffff048>
    80001296:	fb870713          	addi	a4,a4,-72
    8000129a:	fcc798e3          	bne	a5,a2,8000126a <fork+0x52>
    *(np->trapframe) = *(p->trapframe);
    8000129e:	05893683          	ld	a3,88(s2)
    800012a2:	87b6                	mv	a5,a3
    800012a4:	0589b703          	ld	a4,88(s3)
    800012a8:	12068693          	addi	a3,a3,288
    800012ac:	0007b803          	ld	a6,0(a5)
    800012b0:	6788                	ld	a0,8(a5)
    800012b2:	6b8c                	ld	a1,16(a5)
    800012b4:	6f90                	ld	a2,24(a5)
    800012b6:	01073023          	sd	a6,0(a4)
    800012ba:	e708                	sd	a0,8(a4)
    800012bc:	eb0c                	sd	a1,16(a4)
    800012be:	ef10                	sd	a2,24(a4)
    800012c0:	02078793          	addi	a5,a5,32
    800012c4:	02070713          	addi	a4,a4,32
    800012c8:	fed792e3          	bne	a5,a3,800012ac <fork+0x94>
    np->trapframe->a0 = 0;
    800012cc:	0589b783          	ld	a5,88(s3)
    800012d0:	0607b823          	sd	zero,112(a5)
    800012d4:	0d000493          	li	s1,208
    for (i = 0; i < NOFILE; i++)
    800012d8:	15000a13          	li	s4,336
    800012dc:	a03d                	j	8000130a <fork+0xf2>
        freeproc(np);
    800012de:	854e                	mv	a0,s3
    800012e0:	00000097          	auipc	ra,0x0
    800012e4:	d34080e7          	jalr	-716(ra) # 80001014 <freeproc>
        release(&np->lock);
    800012e8:	854e                	mv	a0,s3
    800012ea:	00005097          	auipc	ra,0x5
    800012ee:	3e6080e7          	jalr	998(ra) # 800066d0 <release>
        return -1;
    800012f2:	5a7d                	li	s4,-1
    800012f4:	a069                	j	8000137e <fork+0x166>
            np->ofile[i] = filedup(p->ofile[i]);
    800012f6:	00002097          	auipc	ra,0x2
    800012fa:	7b8080e7          	jalr	1976(ra) # 80003aae <filedup>
    800012fe:	009987b3          	add	a5,s3,s1
    80001302:	e388                	sd	a0,0(a5)
    for (i = 0; i < NOFILE; i++)
    80001304:	04a1                	addi	s1,s1,8
    80001306:	01448763          	beq	s1,s4,80001314 <fork+0xfc>
        if (p->ofile[i])
    8000130a:	009907b3          	add	a5,s2,s1
    8000130e:	6388                	ld	a0,0(a5)
    80001310:	f17d                	bnez	a0,800012f6 <fork+0xde>
    80001312:	bfcd                	j	80001304 <fork+0xec>
    np->cwd = idup(p->cwd);
    80001314:	15093503          	ld	a0,336(s2)
    80001318:	00002097          	auipc	ra,0x2
    8000131c:	91c080e7          	jalr	-1764(ra) # 80002c34 <idup>
    80001320:	14a9b823          	sd	a0,336(s3)
    safestrcpy(np->name, p->name, sizeof(p->name));
    80001324:	4641                	li	a2,16
    80001326:	15890593          	addi	a1,s2,344
    8000132a:	15898513          	addi	a0,s3,344
    8000132e:	fffff097          	auipc	ra,0xfffff
    80001332:	f9c080e7          	jalr	-100(ra) # 800002ca <safestrcpy>
    pid = np->pid;
    80001336:	0309aa03          	lw	s4,48(s3)
    release(&np->lock);
    8000133a:	854e                	mv	a0,s3
    8000133c:	00005097          	auipc	ra,0x5
    80001340:	394080e7          	jalr	916(ra) # 800066d0 <release>
    acquire(&wait_lock);
    80001344:	00008497          	auipc	s1,0x8
    80001348:	87448493          	addi	s1,s1,-1932 # 80008bb8 <wait_lock>
    8000134c:	8526                	mv	a0,s1
    8000134e:	00005097          	auipc	ra,0x5
    80001352:	2ce080e7          	jalr	718(ra) # 8000661c <acquire>
    np->parent = p;
    80001356:	0329bc23          	sd	s2,56(s3)
    release(&wait_lock);
    8000135a:	8526                	mv	a0,s1
    8000135c:	00005097          	auipc	ra,0x5
    80001360:	374080e7          	jalr	884(ra) # 800066d0 <release>
    acquire(&np->lock);
    80001364:	854e                	mv	a0,s3
    80001366:	00005097          	auipc	ra,0x5
    8000136a:	2b6080e7          	jalr	694(ra) # 8000661c <acquire>
    np->state = RUNNABLE;
    8000136e:	478d                	li	a5,3
    80001370:	00f9ac23          	sw	a5,24(s3)
    release(&np->lock);
    80001374:	854e                	mv	a0,s3
    80001376:	00005097          	auipc	ra,0x5
    8000137a:	35a080e7          	jalr	858(ra) # 800066d0 <release>
}
    8000137e:	8552                	mv	a0,s4
    80001380:	70a2                	ld	ra,40(sp)
    80001382:	7402                	ld	s0,32(sp)
    80001384:	64e2                	ld	s1,24(sp)
    80001386:	6942                	ld	s2,16(sp)
    80001388:	69a2                	ld	s3,8(sp)
    8000138a:	6a02                	ld	s4,0(sp)
    8000138c:	6145                	addi	sp,sp,48
    8000138e:	8082                	ret
        return -1;
    80001390:	5a7d                	li	s4,-1
    80001392:	b7f5                	j	8000137e <fork+0x166>

0000000080001394 <scheduler>:
{
    80001394:	7139                	addi	sp,sp,-64
    80001396:	fc06                	sd	ra,56(sp)
    80001398:	f822                	sd	s0,48(sp)
    8000139a:	f426                	sd	s1,40(sp)
    8000139c:	f04a                	sd	s2,32(sp)
    8000139e:	ec4e                	sd	s3,24(sp)
    800013a0:	e852                	sd	s4,16(sp)
    800013a2:	e456                	sd	s5,8(sp)
    800013a4:	e05a                	sd	s6,0(sp)
    800013a6:	0080                	addi	s0,sp,64
    800013a8:	8792                	mv	a5,tp
    int id = r_tp();
    800013aa:	2781                	sext.w	a5,a5
    c->proc = 0;
    800013ac:	00779a93          	slli	s5,a5,0x7
    800013b0:	00007717          	auipc	a4,0x7
    800013b4:	7f070713          	addi	a4,a4,2032 # 80008ba0 <pid_lock>
    800013b8:	9756                	add	a4,a4,s5
    800013ba:	02073823          	sd	zero,48(a4)
                swtch(&c->context, &p->context);
    800013be:	00008717          	auipc	a4,0x8
    800013c2:	81a70713          	addi	a4,a4,-2022 # 80008bd8 <cpus+0x8>
    800013c6:	9aba                	add	s5,s5,a4
            if (p->state == RUNNABLE)
    800013c8:	498d                	li	s3,3
                p->state = RUNNING;
    800013ca:	4b11                	li	s6,4
                c->proc = p;
    800013cc:	079e                	slli	a5,a5,0x7
    800013ce:	00007a17          	auipc	s4,0x7
    800013d2:	7d2a0a13          	addi	s4,s4,2002 # 80008ba0 <pid_lock>
    800013d6:	9a3e                	add	s4,s4,a5
        for (p = proc; p < &proc[NPROC]; p++)
    800013d8:	0001f917          	auipc	s2,0x1f
    800013dc:	5f890913          	addi	s2,s2,1528 # 800209d0 <tickslock>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800013e0:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800013e4:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800013e8:	10079073          	csrw	sstatus,a5
    800013ec:	00008497          	auipc	s1,0x8
    800013f0:	be448493          	addi	s1,s1,-1052 # 80008fd0 <proc>
    800013f4:	a03d                	j	80001422 <scheduler+0x8e>
                p->state = RUNNING;
    800013f6:	0164ac23          	sw	s6,24(s1)
                c->proc = p;
    800013fa:	029a3823          	sd	s1,48(s4)
                swtch(&c->context, &p->context);
    800013fe:	06048593          	addi	a1,s1,96
    80001402:	8556                	mv	a0,s5
    80001404:	00000097          	auipc	ra,0x0
    80001408:	6a4080e7          	jalr	1700(ra) # 80001aa8 <swtch>
                c->proc = 0;
    8000140c:	020a3823          	sd	zero,48(s4)
            release(&p->lock);
    80001410:	8526                	mv	a0,s1
    80001412:	00005097          	auipc	ra,0x5
    80001416:	2be080e7          	jalr	702(ra) # 800066d0 <release>
        for (p = proc; p < &proc[NPROC]; p++)
    8000141a:	5e848493          	addi	s1,s1,1512
    8000141e:	fd2481e3          	beq	s1,s2,800013e0 <scheduler+0x4c>
            acquire(&p->lock);
    80001422:	8526                	mv	a0,s1
    80001424:	00005097          	auipc	ra,0x5
    80001428:	1f8080e7          	jalr	504(ra) # 8000661c <acquire>
            if (p->state == RUNNABLE)
    8000142c:	4c9c                	lw	a5,24(s1)
    8000142e:	ff3791e3          	bne	a5,s3,80001410 <scheduler+0x7c>
    80001432:	b7d1                	j	800013f6 <scheduler+0x62>

0000000080001434 <sched>:
{
    80001434:	7179                	addi	sp,sp,-48
    80001436:	f406                	sd	ra,40(sp)
    80001438:	f022                	sd	s0,32(sp)
    8000143a:	ec26                	sd	s1,24(sp)
    8000143c:	e84a                	sd	s2,16(sp)
    8000143e:	e44e                	sd	s3,8(sp)
    80001440:	1800                	addi	s0,sp,48
    struct proc *p = myproc();
    80001442:	00000097          	auipc	ra,0x0
    80001446:	a20080e7          	jalr	-1504(ra) # 80000e62 <myproc>
    8000144a:	84aa                	mv	s1,a0
    if (!holding(&p->lock))
    8000144c:	00005097          	auipc	ra,0x5
    80001450:	156080e7          	jalr	342(ra) # 800065a2 <holding>
    80001454:	c93d                	beqz	a0,800014ca <sched+0x96>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001456:	8792                	mv	a5,tp
    if (mycpu()->noff != 1)
    80001458:	2781                	sext.w	a5,a5
    8000145a:	079e                	slli	a5,a5,0x7
    8000145c:	00007717          	auipc	a4,0x7
    80001460:	74470713          	addi	a4,a4,1860 # 80008ba0 <pid_lock>
    80001464:	97ba                	add	a5,a5,a4
    80001466:	0a87a703          	lw	a4,168(a5)
    8000146a:	4785                	li	a5,1
    8000146c:	06f71763          	bne	a4,a5,800014da <sched+0xa6>
    if (p->state == RUNNING)
    80001470:	4c98                	lw	a4,24(s1)
    80001472:	4791                	li	a5,4
    80001474:	06f70b63          	beq	a4,a5,800014ea <sched+0xb6>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001478:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    8000147c:	8b89                	andi	a5,a5,2
    if (intr_get())
    8000147e:	efb5                	bnez	a5,800014fa <sched+0xc6>
  asm volatile("mv %0, tp" : "=r" (x) );
    80001480:	8792                	mv	a5,tp
    intena = mycpu()->intena;
    80001482:	00007917          	auipc	s2,0x7
    80001486:	71e90913          	addi	s2,s2,1822 # 80008ba0 <pid_lock>
    8000148a:	2781                	sext.w	a5,a5
    8000148c:	079e                	slli	a5,a5,0x7
    8000148e:	97ca                	add	a5,a5,s2
    80001490:	0ac7a983          	lw	s3,172(a5)
    80001494:	8792                	mv	a5,tp
    swtch(&p->context, &mycpu()->context);
    80001496:	2781                	sext.w	a5,a5
    80001498:	079e                	slli	a5,a5,0x7
    8000149a:	00007597          	auipc	a1,0x7
    8000149e:	73e58593          	addi	a1,a1,1854 # 80008bd8 <cpus+0x8>
    800014a2:	95be                	add	a1,a1,a5
    800014a4:	06048513          	addi	a0,s1,96
    800014a8:	00000097          	auipc	ra,0x0
    800014ac:	600080e7          	jalr	1536(ra) # 80001aa8 <swtch>
    800014b0:	8792                	mv	a5,tp
    mycpu()->intena = intena;
    800014b2:	2781                	sext.w	a5,a5
    800014b4:	079e                	slli	a5,a5,0x7
    800014b6:	97ca                	add	a5,a5,s2
    800014b8:	0b37a623          	sw	s3,172(a5)
}
    800014bc:	70a2                	ld	ra,40(sp)
    800014be:	7402                	ld	s0,32(sp)
    800014c0:	64e2                	ld	s1,24(sp)
    800014c2:	6942                	ld	s2,16(sp)
    800014c4:	69a2                	ld	s3,8(sp)
    800014c6:	6145                	addi	sp,sp,48
    800014c8:	8082                	ret
        panic("sched p->lock");
    800014ca:	00007517          	auipc	a0,0x7
    800014ce:	cc650513          	addi	a0,a0,-826 # 80008190 <etext+0x190>
    800014d2:	00005097          	auipc	ra,0x5
    800014d6:	c00080e7          	jalr	-1024(ra) # 800060d2 <panic>
        panic("sched locks");
    800014da:	00007517          	auipc	a0,0x7
    800014de:	cc650513          	addi	a0,a0,-826 # 800081a0 <etext+0x1a0>
    800014e2:	00005097          	auipc	ra,0x5
    800014e6:	bf0080e7          	jalr	-1040(ra) # 800060d2 <panic>
        panic("sched running");
    800014ea:	00007517          	auipc	a0,0x7
    800014ee:	cc650513          	addi	a0,a0,-826 # 800081b0 <etext+0x1b0>
    800014f2:	00005097          	auipc	ra,0x5
    800014f6:	be0080e7          	jalr	-1056(ra) # 800060d2 <panic>
        panic("sched interruptible");
    800014fa:	00007517          	auipc	a0,0x7
    800014fe:	cc650513          	addi	a0,a0,-826 # 800081c0 <etext+0x1c0>
    80001502:	00005097          	auipc	ra,0x5
    80001506:	bd0080e7          	jalr	-1072(ra) # 800060d2 <panic>

000000008000150a <yield>:
{
    8000150a:	1101                	addi	sp,sp,-32
    8000150c:	ec06                	sd	ra,24(sp)
    8000150e:	e822                	sd	s0,16(sp)
    80001510:	e426                	sd	s1,8(sp)
    80001512:	1000                	addi	s0,sp,32
    struct proc *p = myproc();
    80001514:	00000097          	auipc	ra,0x0
    80001518:	94e080e7          	jalr	-1714(ra) # 80000e62 <myproc>
    8000151c:	84aa                	mv	s1,a0
    acquire(&p->lock);
    8000151e:	00005097          	auipc	ra,0x5
    80001522:	0fe080e7          	jalr	254(ra) # 8000661c <acquire>
    p->state = RUNNABLE;
    80001526:	478d                	li	a5,3
    80001528:	cc9c                	sw	a5,24(s1)
    sched();
    8000152a:	00000097          	auipc	ra,0x0
    8000152e:	f0a080e7          	jalr	-246(ra) # 80001434 <sched>
    release(&p->lock);
    80001532:	8526                	mv	a0,s1
    80001534:	00005097          	auipc	ra,0x5
    80001538:	19c080e7          	jalr	412(ra) # 800066d0 <release>
}
    8000153c:	60e2                	ld	ra,24(sp)
    8000153e:	6442                	ld	s0,16(sp)
    80001540:	64a2                	ld	s1,8(sp)
    80001542:	6105                	addi	sp,sp,32
    80001544:	8082                	ret

0000000080001546 <sleep>:

// Atomically release lock and sleep on chan.
// Reacquires lock when awakened.
void sleep(void *chan, struct spinlock *lk)
{
    80001546:	7179                	addi	sp,sp,-48
    80001548:	f406                	sd	ra,40(sp)
    8000154a:	f022                	sd	s0,32(sp)
    8000154c:	ec26                	sd	s1,24(sp)
    8000154e:	e84a                	sd	s2,16(sp)
    80001550:	e44e                	sd	s3,8(sp)
    80001552:	1800                	addi	s0,sp,48
    80001554:	89aa                	mv	s3,a0
    80001556:	892e                	mv	s2,a1
    struct proc *p = myproc();
    80001558:	00000097          	auipc	ra,0x0
    8000155c:	90a080e7          	jalr	-1782(ra) # 80000e62 <myproc>
    80001560:	84aa                	mv	s1,a0
    // Once we hold p->lock, we can be
    // guaranteed that we won't miss any wakeup
    // (wakeup locks p->lock),
    // so it's okay to release lk.

    acquire(&p->lock); // DOC: sleeplock1
    80001562:	00005097          	auipc	ra,0x5
    80001566:	0ba080e7          	jalr	186(ra) # 8000661c <acquire>
    release(lk);
    8000156a:	854a                	mv	a0,s2
    8000156c:	00005097          	auipc	ra,0x5
    80001570:	164080e7          	jalr	356(ra) # 800066d0 <release>

    // Go to sleep.
    p->chan = chan;
    80001574:	0334b023          	sd	s3,32(s1)
    p->state = SLEEPING;
    80001578:	4789                	li	a5,2
    8000157a:	cc9c                	sw	a5,24(s1)

    sched();
    8000157c:	00000097          	auipc	ra,0x0
    80001580:	eb8080e7          	jalr	-328(ra) # 80001434 <sched>

    // Tidy up.
    p->chan = 0;
    80001584:	0204b023          	sd	zero,32(s1)

    // Reacquire original lock.
    release(&p->lock);
    80001588:	8526                	mv	a0,s1
    8000158a:	00005097          	auipc	ra,0x5
    8000158e:	146080e7          	jalr	326(ra) # 800066d0 <release>
    acquire(lk);
    80001592:	854a                	mv	a0,s2
    80001594:	00005097          	auipc	ra,0x5
    80001598:	088080e7          	jalr	136(ra) # 8000661c <acquire>
}
    8000159c:	70a2                	ld	ra,40(sp)
    8000159e:	7402                	ld	s0,32(sp)
    800015a0:	64e2                	ld	s1,24(sp)
    800015a2:	6942                	ld	s2,16(sp)
    800015a4:	69a2                	ld	s3,8(sp)
    800015a6:	6145                	addi	sp,sp,48
    800015a8:	8082                	ret

00000000800015aa <wakeup>:

// Wake up all processes sleeping on chan.
// Must be called without any p->lock.
void wakeup(void *chan)
{
    800015aa:	7139                	addi	sp,sp,-64
    800015ac:	fc06                	sd	ra,56(sp)
    800015ae:	f822                	sd	s0,48(sp)
    800015b0:	f426                	sd	s1,40(sp)
    800015b2:	f04a                	sd	s2,32(sp)
    800015b4:	ec4e                	sd	s3,24(sp)
    800015b6:	e852                	sd	s4,16(sp)
    800015b8:	e456                	sd	s5,8(sp)
    800015ba:	0080                	addi	s0,sp,64
    800015bc:	8a2a                	mv	s4,a0
    struct proc *p;

    for (p = proc; p < &proc[NPROC]; p++)
    800015be:	00008497          	auipc	s1,0x8
    800015c2:	a1248493          	addi	s1,s1,-1518 # 80008fd0 <proc>
    {
        if (p != myproc())
        {
            acquire(&p->lock);
            if (p->state == SLEEPING && p->chan == chan)
    800015c6:	4989                	li	s3,2
            {
                p->state = RUNNABLE;
    800015c8:	4a8d                	li	s5,3
    for (p = proc; p < &proc[NPROC]; p++)
    800015ca:	0001f917          	auipc	s2,0x1f
    800015ce:	40690913          	addi	s2,s2,1030 # 800209d0 <tickslock>
    800015d2:	a821                	j	800015ea <wakeup+0x40>
                p->state = RUNNABLE;
    800015d4:	0154ac23          	sw	s5,24(s1)
            }
            release(&p->lock);
    800015d8:	8526                	mv	a0,s1
    800015da:	00005097          	auipc	ra,0x5
    800015de:	0f6080e7          	jalr	246(ra) # 800066d0 <release>
    for (p = proc; p < &proc[NPROC]; p++)
    800015e2:	5e848493          	addi	s1,s1,1512
    800015e6:	03248463          	beq	s1,s2,8000160e <wakeup+0x64>
        if (p != myproc())
    800015ea:	00000097          	auipc	ra,0x0
    800015ee:	878080e7          	jalr	-1928(ra) # 80000e62 <myproc>
    800015f2:	fea488e3          	beq	s1,a0,800015e2 <wakeup+0x38>
            acquire(&p->lock);
    800015f6:	8526                	mv	a0,s1
    800015f8:	00005097          	auipc	ra,0x5
    800015fc:	024080e7          	jalr	36(ra) # 8000661c <acquire>
            if (p->state == SLEEPING && p->chan == chan)
    80001600:	4c9c                	lw	a5,24(s1)
    80001602:	fd379be3          	bne	a5,s3,800015d8 <wakeup+0x2e>
    80001606:	709c                	ld	a5,32(s1)
    80001608:	fd4798e3          	bne	a5,s4,800015d8 <wakeup+0x2e>
    8000160c:	b7e1                	j	800015d4 <wakeup+0x2a>
        }
    }
}
    8000160e:	70e2                	ld	ra,56(sp)
    80001610:	7442                	ld	s0,48(sp)
    80001612:	74a2                	ld	s1,40(sp)
    80001614:	7902                	ld	s2,32(sp)
    80001616:	69e2                	ld	s3,24(sp)
    80001618:	6a42                	ld	s4,16(sp)
    8000161a:	6aa2                	ld	s5,8(sp)
    8000161c:	6121                	addi	sp,sp,64
    8000161e:	8082                	ret

0000000080001620 <reparent>:
{
    80001620:	7179                	addi	sp,sp,-48
    80001622:	f406                	sd	ra,40(sp)
    80001624:	f022                	sd	s0,32(sp)
    80001626:	ec26                	sd	s1,24(sp)
    80001628:	e84a                	sd	s2,16(sp)
    8000162a:	e44e                	sd	s3,8(sp)
    8000162c:	e052                	sd	s4,0(sp)
    8000162e:	1800                	addi	s0,sp,48
    80001630:	892a                	mv	s2,a0
    for (pp = proc; pp < &proc[NPROC]; pp++)
    80001632:	00008497          	auipc	s1,0x8
    80001636:	99e48493          	addi	s1,s1,-1634 # 80008fd0 <proc>
            pp->parent = initproc;
    8000163a:	00007a17          	auipc	s4,0x7
    8000163e:	526a0a13          	addi	s4,s4,1318 # 80008b60 <initproc>
    for (pp = proc; pp < &proc[NPROC]; pp++)
    80001642:	0001f997          	auipc	s3,0x1f
    80001646:	38e98993          	addi	s3,s3,910 # 800209d0 <tickslock>
    8000164a:	a029                	j	80001654 <reparent+0x34>
    8000164c:	5e848493          	addi	s1,s1,1512
    80001650:	01348d63          	beq	s1,s3,8000166a <reparent+0x4a>
        if (pp->parent == p)
    80001654:	7c9c                	ld	a5,56(s1)
    80001656:	ff279be3          	bne	a5,s2,8000164c <reparent+0x2c>
            pp->parent = initproc;
    8000165a:	000a3503          	ld	a0,0(s4)
    8000165e:	fc88                	sd	a0,56(s1)
            wakeup(initproc);
    80001660:	00000097          	auipc	ra,0x0
    80001664:	f4a080e7          	jalr	-182(ra) # 800015aa <wakeup>
    80001668:	b7d5                	j	8000164c <reparent+0x2c>
}
    8000166a:	70a2                	ld	ra,40(sp)
    8000166c:	7402                	ld	s0,32(sp)
    8000166e:	64e2                	ld	s1,24(sp)
    80001670:	6942                	ld	s2,16(sp)
    80001672:	69a2                	ld	s3,8(sp)
    80001674:	6a02                	ld	s4,0(sp)
    80001676:	6145                	addi	sp,sp,48
    80001678:	8082                	ret

000000008000167a <exit>:
{
    8000167a:	7179                	addi	sp,sp,-48
    8000167c:	f406                	sd	ra,40(sp)
    8000167e:	f022                	sd	s0,32(sp)
    80001680:	ec26                	sd	s1,24(sp)
    80001682:	e84a                	sd	s2,16(sp)
    80001684:	e44e                	sd	s3,8(sp)
    80001686:	e052                	sd	s4,0(sp)
    80001688:	1800                	addi	s0,sp,48
    8000168a:	8a2a                	mv	s4,a0
    struct proc *p = myproc();
    8000168c:	fffff097          	auipc	ra,0xfffff
    80001690:	7d6080e7          	jalr	2006(ra) # 80000e62 <myproc>
    80001694:	89aa                	mv	s3,a0
    if (p == initproc)
    80001696:	00007797          	auipc	a5,0x7
    8000169a:	4ca7b783          	ld	a5,1226(a5) # 80008b60 <initproc>
    8000169e:	0d050493          	addi	s1,a0,208
    800016a2:	15050913          	addi	s2,a0,336
    800016a6:	02a79363          	bne	a5,a0,800016cc <exit+0x52>
        panic("init exiting");
    800016aa:	00007517          	auipc	a0,0x7
    800016ae:	b2e50513          	addi	a0,a0,-1234 # 800081d8 <etext+0x1d8>
    800016b2:	00005097          	auipc	ra,0x5
    800016b6:	a20080e7          	jalr	-1504(ra) # 800060d2 <panic>
            fileclose(f);
    800016ba:	00002097          	auipc	ra,0x2
    800016be:	446080e7          	jalr	1094(ra) # 80003b00 <fileclose>
            p->ofile[fd] = 0;
    800016c2:	0004b023          	sd	zero,0(s1)
    for (int fd = 0; fd < NOFILE; fd++)
    800016c6:	04a1                	addi	s1,s1,8
    800016c8:	01248563          	beq	s1,s2,800016d2 <exit+0x58>
        if (p->ofile[fd])
    800016cc:	6088                	ld	a0,0(s1)
    800016ce:	f575                	bnez	a0,800016ba <exit+0x40>
    800016d0:	bfdd                	j	800016c6 <exit+0x4c>
    begin_op();
    800016d2:	00002097          	auipc	ra,0x2
    800016d6:	f62080e7          	jalr	-158(ra) # 80003634 <begin_op>
    iput(p->cwd);
    800016da:	1509b503          	ld	a0,336(s3)
    800016de:	00001097          	auipc	ra,0x1
    800016e2:	74e080e7          	jalr	1870(ra) # 80002e2c <iput>
    end_op();
    800016e6:	00002097          	auipc	ra,0x2
    800016ea:	fce080e7          	jalr	-50(ra) # 800036b4 <end_op>
    p->cwd = 0;
    800016ee:	1409b823          	sd	zero,336(s3)
    acquire(&wait_lock);
    800016f2:	00007497          	auipc	s1,0x7
    800016f6:	4c648493          	addi	s1,s1,1222 # 80008bb8 <wait_lock>
    800016fa:	8526                	mv	a0,s1
    800016fc:	00005097          	auipc	ra,0x5
    80001700:	f20080e7          	jalr	-224(ra) # 8000661c <acquire>
    reparent(p);
    80001704:	854e                	mv	a0,s3
    80001706:	00000097          	auipc	ra,0x0
    8000170a:	f1a080e7          	jalr	-230(ra) # 80001620 <reparent>
    wakeup(p->parent);
    8000170e:	0389b503          	ld	a0,56(s3)
    80001712:	00000097          	auipc	ra,0x0
    80001716:	e98080e7          	jalr	-360(ra) # 800015aa <wakeup>
    acquire(&p->lock);
    8000171a:	854e                	mv	a0,s3
    8000171c:	00005097          	auipc	ra,0x5
    80001720:	f00080e7          	jalr	-256(ra) # 8000661c <acquire>
    p->xstate = status;
    80001724:	0349a623          	sw	s4,44(s3)
    p->state = ZOMBIE;
    80001728:	4795                	li	a5,5
    8000172a:	00f9ac23          	sw	a5,24(s3)
    release(&wait_lock);
    8000172e:	8526                	mv	a0,s1
    80001730:	00005097          	auipc	ra,0x5
    80001734:	fa0080e7          	jalr	-96(ra) # 800066d0 <release>
    sched();
    80001738:	00000097          	auipc	ra,0x0
    8000173c:	cfc080e7          	jalr	-772(ra) # 80001434 <sched>
    panic("zombie exit");
    80001740:	00007517          	auipc	a0,0x7
    80001744:	aa850513          	addi	a0,a0,-1368 # 800081e8 <etext+0x1e8>
    80001748:	00005097          	auipc	ra,0x5
    8000174c:	98a080e7          	jalr	-1654(ra) # 800060d2 <panic>

0000000080001750 <kill>:

// Kill the process with the given pid.
// The victim won't exit until it tries to return
// to user space (see usertrap() in trap.c).
int kill(int pid)
{
    80001750:	7179                	addi	sp,sp,-48
    80001752:	f406                	sd	ra,40(sp)
    80001754:	f022                	sd	s0,32(sp)
    80001756:	ec26                	sd	s1,24(sp)
    80001758:	e84a                	sd	s2,16(sp)
    8000175a:	e44e                	sd	s3,8(sp)
    8000175c:	1800                	addi	s0,sp,48
    8000175e:	892a                	mv	s2,a0
    struct proc *p;

    for (p = proc; p < &proc[NPROC]; p++)
    80001760:	00008497          	auipc	s1,0x8
    80001764:	87048493          	addi	s1,s1,-1936 # 80008fd0 <proc>
    80001768:	0001f997          	auipc	s3,0x1f
    8000176c:	26898993          	addi	s3,s3,616 # 800209d0 <tickslock>
    {
        acquire(&p->lock);
    80001770:	8526                	mv	a0,s1
    80001772:	00005097          	auipc	ra,0x5
    80001776:	eaa080e7          	jalr	-342(ra) # 8000661c <acquire>
        if (p->pid == pid)
    8000177a:	589c                	lw	a5,48(s1)
    8000177c:	01278d63          	beq	a5,s2,80001796 <kill+0x46>
                p->state = RUNNABLE;
            }
            release(&p->lock);
            return 0;
        }
        release(&p->lock);
    80001780:	8526                	mv	a0,s1
    80001782:	00005097          	auipc	ra,0x5
    80001786:	f4e080e7          	jalr	-178(ra) # 800066d0 <release>
    for (p = proc; p < &proc[NPROC]; p++)
    8000178a:	5e848493          	addi	s1,s1,1512
    8000178e:	ff3491e3          	bne	s1,s3,80001770 <kill+0x20>
    }
    return -1;
    80001792:	557d                	li	a0,-1
    80001794:	a829                	j	800017ae <kill+0x5e>
            p->killed = 1;
    80001796:	4785                	li	a5,1
    80001798:	d49c                	sw	a5,40(s1)
            if (p->state == SLEEPING)
    8000179a:	4c98                	lw	a4,24(s1)
    8000179c:	4789                	li	a5,2
    8000179e:	00f70f63          	beq	a4,a5,800017bc <kill+0x6c>
            release(&p->lock);
    800017a2:	8526                	mv	a0,s1
    800017a4:	00005097          	auipc	ra,0x5
    800017a8:	f2c080e7          	jalr	-212(ra) # 800066d0 <release>
            return 0;
    800017ac:	4501                	li	a0,0
}
    800017ae:	70a2                	ld	ra,40(sp)
    800017b0:	7402                	ld	s0,32(sp)
    800017b2:	64e2                	ld	s1,24(sp)
    800017b4:	6942                	ld	s2,16(sp)
    800017b6:	69a2                	ld	s3,8(sp)
    800017b8:	6145                	addi	sp,sp,48
    800017ba:	8082                	ret
                p->state = RUNNABLE;
    800017bc:	478d                	li	a5,3
    800017be:	cc9c                	sw	a5,24(s1)
    800017c0:	b7cd                	j	800017a2 <kill+0x52>

00000000800017c2 <setkilled>:

void setkilled(struct proc *p)
{
    800017c2:	1101                	addi	sp,sp,-32
    800017c4:	ec06                	sd	ra,24(sp)
    800017c6:	e822                	sd	s0,16(sp)
    800017c8:	e426                	sd	s1,8(sp)
    800017ca:	1000                	addi	s0,sp,32
    800017cc:	84aa                	mv	s1,a0
    acquire(&p->lock);
    800017ce:	00005097          	auipc	ra,0x5
    800017d2:	e4e080e7          	jalr	-434(ra) # 8000661c <acquire>
    p->killed = 1;
    800017d6:	4785                	li	a5,1
    800017d8:	d49c                	sw	a5,40(s1)
    release(&p->lock);
    800017da:	8526                	mv	a0,s1
    800017dc:	00005097          	auipc	ra,0x5
    800017e0:	ef4080e7          	jalr	-268(ra) # 800066d0 <release>
}
    800017e4:	60e2                	ld	ra,24(sp)
    800017e6:	6442                	ld	s0,16(sp)
    800017e8:	64a2                	ld	s1,8(sp)
    800017ea:	6105                	addi	sp,sp,32
    800017ec:	8082                	ret

00000000800017ee <killed>:

int killed(struct proc *p)
{
    800017ee:	1101                	addi	sp,sp,-32
    800017f0:	ec06                	sd	ra,24(sp)
    800017f2:	e822                	sd	s0,16(sp)
    800017f4:	e426                	sd	s1,8(sp)
    800017f6:	e04a                	sd	s2,0(sp)
    800017f8:	1000                	addi	s0,sp,32
    800017fa:	84aa                	mv	s1,a0
    int k;

    acquire(&p->lock);
    800017fc:	00005097          	auipc	ra,0x5
    80001800:	e20080e7          	jalr	-480(ra) # 8000661c <acquire>
    k = p->killed;
    80001804:	0284a903          	lw	s2,40(s1)
    release(&p->lock);
    80001808:	8526                	mv	a0,s1
    8000180a:	00005097          	auipc	ra,0x5
    8000180e:	ec6080e7          	jalr	-314(ra) # 800066d0 <release>
    return k;
}
    80001812:	854a                	mv	a0,s2
    80001814:	60e2                	ld	ra,24(sp)
    80001816:	6442                	ld	s0,16(sp)
    80001818:	64a2                	ld	s1,8(sp)
    8000181a:	6902                	ld	s2,0(sp)
    8000181c:	6105                	addi	sp,sp,32
    8000181e:	8082                	ret

0000000080001820 <wait>:
{
    80001820:	715d                	addi	sp,sp,-80
    80001822:	e486                	sd	ra,72(sp)
    80001824:	e0a2                	sd	s0,64(sp)
    80001826:	fc26                	sd	s1,56(sp)
    80001828:	f84a                	sd	s2,48(sp)
    8000182a:	f44e                	sd	s3,40(sp)
    8000182c:	f052                	sd	s4,32(sp)
    8000182e:	ec56                	sd	s5,24(sp)
    80001830:	e85a                	sd	s6,16(sp)
    80001832:	e45e                	sd	s7,8(sp)
    80001834:	e062                	sd	s8,0(sp)
    80001836:	0880                	addi	s0,sp,80
    80001838:	8b2a                	mv	s6,a0
    struct proc *p = myproc();
    8000183a:	fffff097          	auipc	ra,0xfffff
    8000183e:	628080e7          	jalr	1576(ra) # 80000e62 <myproc>
    80001842:	892a                	mv	s2,a0
    acquire(&wait_lock);
    80001844:	00007517          	auipc	a0,0x7
    80001848:	37450513          	addi	a0,a0,884 # 80008bb8 <wait_lock>
    8000184c:	00005097          	auipc	ra,0x5
    80001850:	dd0080e7          	jalr	-560(ra) # 8000661c <acquire>
        havekids = 0;
    80001854:	4b81                	li	s7,0
                if (pp->state == ZOMBIE)
    80001856:	4a15                	li	s4,5
        for (pp = proc; pp < &proc[NPROC]; pp++)
    80001858:	0001f997          	auipc	s3,0x1f
    8000185c:	17898993          	addi	s3,s3,376 # 800209d0 <tickslock>
                havekids = 1;
    80001860:	4a85                	li	s5,1
        sleep(p, &wait_lock); // DOC: wait-sleep
    80001862:	00007c17          	auipc	s8,0x7
    80001866:	356c0c13          	addi	s8,s8,854 # 80008bb8 <wait_lock>
        havekids = 0;
    8000186a:	875e                	mv	a4,s7
        for (pp = proc; pp < &proc[NPROC]; pp++)
    8000186c:	00007497          	auipc	s1,0x7
    80001870:	76448493          	addi	s1,s1,1892 # 80008fd0 <proc>
    80001874:	a0bd                	j	800018e2 <wait+0xc2>
                    pid = pp->pid;
    80001876:	0304a983          	lw	s3,48(s1)
                    if (addr != 0 && copyout(p->pagetable, addr, (char *)&pp->xstate,
    8000187a:	000b0e63          	beqz	s6,80001896 <wait+0x76>
    8000187e:	4691                	li	a3,4
    80001880:	02c48613          	addi	a2,s1,44
    80001884:	85da                	mv	a1,s6
    80001886:	05093503          	ld	a0,80(s2)
    8000188a:	fffff097          	auipc	ra,0xfffff
    8000188e:	296080e7          	jalr	662(ra) # 80000b20 <copyout>
    80001892:	02054563          	bltz	a0,800018bc <wait+0x9c>
                    freeproc(pp);
    80001896:	8526                	mv	a0,s1
    80001898:	fffff097          	auipc	ra,0xfffff
    8000189c:	77c080e7          	jalr	1916(ra) # 80001014 <freeproc>
                    release(&pp->lock);
    800018a0:	8526                	mv	a0,s1
    800018a2:	00005097          	auipc	ra,0x5
    800018a6:	e2e080e7          	jalr	-466(ra) # 800066d0 <release>
                    release(&wait_lock);
    800018aa:	00007517          	auipc	a0,0x7
    800018ae:	30e50513          	addi	a0,a0,782 # 80008bb8 <wait_lock>
    800018b2:	00005097          	auipc	ra,0x5
    800018b6:	e1e080e7          	jalr	-482(ra) # 800066d0 <release>
                    return pid;
    800018ba:	a0b5                	j	80001926 <wait+0x106>
                        release(&pp->lock);
    800018bc:	8526                	mv	a0,s1
    800018be:	00005097          	auipc	ra,0x5
    800018c2:	e12080e7          	jalr	-494(ra) # 800066d0 <release>
                        release(&wait_lock);
    800018c6:	00007517          	auipc	a0,0x7
    800018ca:	2f250513          	addi	a0,a0,754 # 80008bb8 <wait_lock>
    800018ce:	00005097          	auipc	ra,0x5
    800018d2:	e02080e7          	jalr	-510(ra) # 800066d0 <release>
                        return -1;
    800018d6:	59fd                	li	s3,-1
    800018d8:	a0b9                	j	80001926 <wait+0x106>
        for (pp = proc; pp < &proc[NPROC]; pp++)
    800018da:	5e848493          	addi	s1,s1,1512
    800018de:	03348463          	beq	s1,s3,80001906 <wait+0xe6>
            if (pp->parent == p)
    800018e2:	7c9c                	ld	a5,56(s1)
    800018e4:	ff279be3          	bne	a5,s2,800018da <wait+0xba>
                acquire(&pp->lock);
    800018e8:	8526                	mv	a0,s1
    800018ea:	00005097          	auipc	ra,0x5
    800018ee:	d32080e7          	jalr	-718(ra) # 8000661c <acquire>
                if (pp->state == ZOMBIE)
    800018f2:	4c9c                	lw	a5,24(s1)
    800018f4:	f94781e3          	beq	a5,s4,80001876 <wait+0x56>
                release(&pp->lock);
    800018f8:	8526                	mv	a0,s1
    800018fa:	00005097          	auipc	ra,0x5
    800018fe:	dd6080e7          	jalr	-554(ra) # 800066d0 <release>
                havekids = 1;
    80001902:	8756                	mv	a4,s5
    80001904:	bfd9                	j	800018da <wait+0xba>
        if (!havekids || killed(p))
    80001906:	c719                	beqz	a4,80001914 <wait+0xf4>
    80001908:	854a                	mv	a0,s2
    8000190a:	00000097          	auipc	ra,0x0
    8000190e:	ee4080e7          	jalr	-284(ra) # 800017ee <killed>
    80001912:	c51d                	beqz	a0,80001940 <wait+0x120>
            release(&wait_lock);
    80001914:	00007517          	auipc	a0,0x7
    80001918:	2a450513          	addi	a0,a0,676 # 80008bb8 <wait_lock>
    8000191c:	00005097          	auipc	ra,0x5
    80001920:	db4080e7          	jalr	-588(ra) # 800066d0 <release>
            return -1;
    80001924:	59fd                	li	s3,-1
}
    80001926:	854e                	mv	a0,s3
    80001928:	60a6                	ld	ra,72(sp)
    8000192a:	6406                	ld	s0,64(sp)
    8000192c:	74e2                	ld	s1,56(sp)
    8000192e:	7942                	ld	s2,48(sp)
    80001930:	79a2                	ld	s3,40(sp)
    80001932:	7a02                	ld	s4,32(sp)
    80001934:	6ae2                	ld	s5,24(sp)
    80001936:	6b42                	ld	s6,16(sp)
    80001938:	6ba2                	ld	s7,8(sp)
    8000193a:	6c02                	ld	s8,0(sp)
    8000193c:	6161                	addi	sp,sp,80
    8000193e:	8082                	ret
        sleep(p, &wait_lock); // DOC: wait-sleep
    80001940:	85e2                	mv	a1,s8
    80001942:	854a                	mv	a0,s2
    80001944:	00000097          	auipc	ra,0x0
    80001948:	c02080e7          	jalr	-1022(ra) # 80001546 <sleep>
        havekids = 0;
    8000194c:	bf39                	j	8000186a <wait+0x4a>

000000008000194e <either_copyout>:

// Copy to either a user address, or kernel address,
// depending on usr_dst.
// Returns 0 on success, -1 on error.
int either_copyout(int user_dst, uint64 dst, void *src, uint64 len)
{
    8000194e:	7179                	addi	sp,sp,-48
    80001950:	f406                	sd	ra,40(sp)
    80001952:	f022                	sd	s0,32(sp)
    80001954:	ec26                	sd	s1,24(sp)
    80001956:	e84a                	sd	s2,16(sp)
    80001958:	e44e                	sd	s3,8(sp)
    8000195a:	e052                	sd	s4,0(sp)
    8000195c:	1800                	addi	s0,sp,48
    8000195e:	84aa                	mv	s1,a0
    80001960:	892e                	mv	s2,a1
    80001962:	89b2                	mv	s3,a2
    80001964:	8a36                	mv	s4,a3
    struct proc *p = myproc();
    80001966:	fffff097          	auipc	ra,0xfffff
    8000196a:	4fc080e7          	jalr	1276(ra) # 80000e62 <myproc>
    if (user_dst)
    8000196e:	c08d                	beqz	s1,80001990 <either_copyout+0x42>
    {
        return copyout(p->pagetable, dst, src, len);
    80001970:	86d2                	mv	a3,s4
    80001972:	864e                	mv	a2,s3
    80001974:	85ca                	mv	a1,s2
    80001976:	6928                	ld	a0,80(a0)
    80001978:	fffff097          	auipc	ra,0xfffff
    8000197c:	1a8080e7          	jalr	424(ra) # 80000b20 <copyout>
    else
    {
        memmove((char *)dst, src, len);
        return 0;
    }
}
    80001980:	70a2                	ld	ra,40(sp)
    80001982:	7402                	ld	s0,32(sp)
    80001984:	64e2                	ld	s1,24(sp)
    80001986:	6942                	ld	s2,16(sp)
    80001988:	69a2                	ld	s3,8(sp)
    8000198a:	6a02                	ld	s4,0(sp)
    8000198c:	6145                	addi	sp,sp,48
    8000198e:	8082                	ret
        memmove((char *)dst, src, len);
    80001990:	000a061b          	sext.w	a2,s4
    80001994:	85ce                	mv	a1,s3
    80001996:	854a                	mv	a0,s2
    80001998:	fffff097          	auipc	ra,0xfffff
    8000199c:	840080e7          	jalr	-1984(ra) # 800001d8 <memmove>
        return 0;
    800019a0:	8526                	mv	a0,s1
    800019a2:	bff9                	j	80001980 <either_copyout+0x32>

00000000800019a4 <either_copyin>:

// Copy from either a user address, or kernel address,
// depending on usr_src.
// Returns 0 on success, -1 on error.
int either_copyin(void *dst, int user_src, uint64 src, uint64 len)
{
    800019a4:	7179                	addi	sp,sp,-48
    800019a6:	f406                	sd	ra,40(sp)
    800019a8:	f022                	sd	s0,32(sp)
    800019aa:	ec26                	sd	s1,24(sp)
    800019ac:	e84a                	sd	s2,16(sp)
    800019ae:	e44e                	sd	s3,8(sp)
    800019b0:	e052                	sd	s4,0(sp)
    800019b2:	1800                	addi	s0,sp,48
    800019b4:	892a                	mv	s2,a0
    800019b6:	84ae                	mv	s1,a1
    800019b8:	89b2                	mv	s3,a2
    800019ba:	8a36                	mv	s4,a3
    struct proc *p = myproc();
    800019bc:	fffff097          	auipc	ra,0xfffff
    800019c0:	4a6080e7          	jalr	1190(ra) # 80000e62 <myproc>
    if (user_src)
    800019c4:	c08d                	beqz	s1,800019e6 <either_copyin+0x42>
    {
        return copyin(p->pagetable, dst, src, len);
    800019c6:	86d2                	mv	a3,s4
    800019c8:	864e                	mv	a2,s3
    800019ca:	85ca                	mv	a1,s2
    800019cc:	6928                	ld	a0,80(a0)
    800019ce:	fffff097          	auipc	ra,0xfffff
    800019d2:	1de080e7          	jalr	478(ra) # 80000bac <copyin>
    else
    {
        memmove(dst, (char *)src, len);
        return 0;
    }
}
    800019d6:	70a2                	ld	ra,40(sp)
    800019d8:	7402                	ld	s0,32(sp)
    800019da:	64e2                	ld	s1,24(sp)
    800019dc:	6942                	ld	s2,16(sp)
    800019de:	69a2                	ld	s3,8(sp)
    800019e0:	6a02                	ld	s4,0(sp)
    800019e2:	6145                	addi	sp,sp,48
    800019e4:	8082                	ret
        memmove(dst, (char *)src, len);
    800019e6:	000a061b          	sext.w	a2,s4
    800019ea:	85ce                	mv	a1,s3
    800019ec:	854a                	mv	a0,s2
    800019ee:	ffffe097          	auipc	ra,0xffffe
    800019f2:	7ea080e7          	jalr	2026(ra) # 800001d8 <memmove>
        return 0;
    800019f6:	8526                	mv	a0,s1
    800019f8:	bff9                	j	800019d6 <either_copyin+0x32>

00000000800019fa <procdump>:

// Print a process listing to console.  For debugging.
// Runs when user types ^P on console.
// No lock to avoid wedging a stuck machine further.
void procdump(void)
{
    800019fa:	715d                	addi	sp,sp,-80
    800019fc:	e486                	sd	ra,72(sp)
    800019fe:	e0a2                	sd	s0,64(sp)
    80001a00:	fc26                	sd	s1,56(sp)
    80001a02:	f84a                	sd	s2,48(sp)
    80001a04:	f44e                	sd	s3,40(sp)
    80001a06:	f052                	sd	s4,32(sp)
    80001a08:	ec56                	sd	s5,24(sp)
    80001a0a:	e85a                	sd	s6,16(sp)
    80001a0c:	e45e                	sd	s7,8(sp)
    80001a0e:	0880                	addi	s0,sp,80
        [RUNNING] "run   ",
        [ZOMBIE] "zombie"};
    struct proc *p;
    char *state;

    printf("\n");
    80001a10:	00006517          	auipc	a0,0x6
    80001a14:	63850513          	addi	a0,a0,1592 # 80008048 <etext+0x48>
    80001a18:	00004097          	auipc	ra,0x4
    80001a1c:	704080e7          	jalr	1796(ra) # 8000611c <printf>
    for (p = proc; p < &proc[NPROC]; p++)
    80001a20:	00007497          	auipc	s1,0x7
    80001a24:	70848493          	addi	s1,s1,1800 # 80009128 <proc+0x158>
    80001a28:	0001f917          	auipc	s2,0x1f
    80001a2c:	10090913          	addi	s2,s2,256 # 80020b28 <bcache+0x140>
    {
        if (p->state == UNUSED)
            continue;
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a30:	4b15                	li	s6,5
            state = states[p->state];
        else
            state = "???";
    80001a32:	00006997          	auipc	s3,0x6
    80001a36:	7c698993          	addi	s3,s3,1990 # 800081f8 <etext+0x1f8>
        printf("%d %s %s", p->pid, state, p->name);
    80001a3a:	00006a97          	auipc	s5,0x6
    80001a3e:	7c6a8a93          	addi	s5,s5,1990 # 80008200 <etext+0x200>
        printf("\n");
    80001a42:	00006a17          	auipc	s4,0x6
    80001a46:	606a0a13          	addi	s4,s4,1542 # 80008048 <etext+0x48>
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a4a:	00006b97          	auipc	s7,0x6
    80001a4e:	7f6b8b93          	addi	s7,s7,2038 # 80008240 <states.1744>
    80001a52:	a00d                	j	80001a74 <procdump+0x7a>
        printf("%d %s %s", p->pid, state, p->name);
    80001a54:	ed86a583          	lw	a1,-296(a3)
    80001a58:	8556                	mv	a0,s5
    80001a5a:	00004097          	auipc	ra,0x4
    80001a5e:	6c2080e7          	jalr	1730(ra) # 8000611c <printf>
        printf("\n");
    80001a62:	8552                	mv	a0,s4
    80001a64:	00004097          	auipc	ra,0x4
    80001a68:	6b8080e7          	jalr	1720(ra) # 8000611c <printf>
    for (p = proc; p < &proc[NPROC]; p++)
    80001a6c:	5e848493          	addi	s1,s1,1512
    80001a70:	03248163          	beq	s1,s2,80001a92 <procdump+0x98>
        if (p->state == UNUSED)
    80001a74:	86a6                	mv	a3,s1
    80001a76:	ec04a783          	lw	a5,-320(s1)
    80001a7a:	dbed                	beqz	a5,80001a6c <procdump+0x72>
            state = "???";
    80001a7c:	864e                	mv	a2,s3
        if (p->state >= 0 && p->state < NELEM(states) && states[p->state])
    80001a7e:	fcfb6be3          	bltu	s6,a5,80001a54 <procdump+0x5a>
    80001a82:	1782                	slli	a5,a5,0x20
    80001a84:	9381                	srli	a5,a5,0x20
    80001a86:	078e                	slli	a5,a5,0x3
    80001a88:	97de                	add	a5,a5,s7
    80001a8a:	6390                	ld	a2,0(a5)
    80001a8c:	f661                	bnez	a2,80001a54 <procdump+0x5a>
            state = "???";
    80001a8e:	864e                	mv	a2,s3
    80001a90:	b7d1                	j	80001a54 <procdump+0x5a>
    }
}
    80001a92:	60a6                	ld	ra,72(sp)
    80001a94:	6406                	ld	s0,64(sp)
    80001a96:	74e2                	ld	s1,56(sp)
    80001a98:	7942                	ld	s2,48(sp)
    80001a9a:	79a2                	ld	s3,40(sp)
    80001a9c:	7a02                	ld	s4,32(sp)
    80001a9e:	6ae2                	ld	s5,24(sp)
    80001aa0:	6b42                	ld	s6,16(sp)
    80001aa2:	6ba2                	ld	s7,8(sp)
    80001aa4:	6161                	addi	sp,sp,80
    80001aa6:	8082                	ret

0000000080001aa8 <swtch>:
    80001aa8:	00153023          	sd	ra,0(a0)
    80001aac:	00253423          	sd	sp,8(a0)
    80001ab0:	e900                	sd	s0,16(a0)
    80001ab2:	ed04                	sd	s1,24(a0)
    80001ab4:	03253023          	sd	s2,32(a0)
    80001ab8:	03353423          	sd	s3,40(a0)
    80001abc:	03453823          	sd	s4,48(a0)
    80001ac0:	03553c23          	sd	s5,56(a0)
    80001ac4:	05653023          	sd	s6,64(a0)
    80001ac8:	05753423          	sd	s7,72(a0)
    80001acc:	05853823          	sd	s8,80(a0)
    80001ad0:	05953c23          	sd	s9,88(a0)
    80001ad4:	07a53023          	sd	s10,96(a0)
    80001ad8:	07b53423          	sd	s11,104(a0)
    80001adc:	0005b083          	ld	ra,0(a1)
    80001ae0:	0085b103          	ld	sp,8(a1)
    80001ae4:	6980                	ld	s0,16(a1)
    80001ae6:	6d84                	ld	s1,24(a1)
    80001ae8:	0205b903          	ld	s2,32(a1)
    80001aec:	0285b983          	ld	s3,40(a1)
    80001af0:	0305ba03          	ld	s4,48(a1)
    80001af4:	0385ba83          	ld	s5,56(a1)
    80001af8:	0405bb03          	ld	s6,64(a1)
    80001afc:	0485bb83          	ld	s7,72(a1)
    80001b00:	0505bc03          	ld	s8,80(a1)
    80001b04:	0585bc83          	ld	s9,88(a1)
    80001b08:	0605bd03          	ld	s10,96(a1)
    80001b0c:	0685bd83          	ld	s11,104(a1)
    80001b10:	8082                	ret

0000000080001b12 <trapinit>:
void kernelvec();

extern int devintr();

void trapinit(void)
{
    80001b12:	1141                	addi	sp,sp,-16
    80001b14:	e406                	sd	ra,8(sp)
    80001b16:	e022                	sd	s0,0(sp)
    80001b18:	0800                	addi	s0,sp,16
    initlock(&tickslock, "time");
    80001b1a:	00006597          	auipc	a1,0x6
    80001b1e:	75658593          	addi	a1,a1,1878 # 80008270 <states.1744+0x30>
    80001b22:	0001f517          	auipc	a0,0x1f
    80001b26:	eae50513          	addi	a0,a0,-338 # 800209d0 <tickslock>
    80001b2a:	00005097          	auipc	ra,0x5
    80001b2e:	a62080e7          	jalr	-1438(ra) # 8000658c <initlock>
}
    80001b32:	60a2                	ld	ra,8(sp)
    80001b34:	6402                	ld	s0,0(sp)
    80001b36:	0141                	addi	sp,sp,16
    80001b38:	8082                	ret

0000000080001b3a <trapinithart>:

// set up to take exceptions and traps while in the kernel.
void trapinithart(void)
{
    80001b3a:	1141                	addi	sp,sp,-16
    80001b3c:	e422                	sd	s0,8(sp)
    80001b3e:	0800                	addi	s0,sp,16
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b40:	00004797          	auipc	a5,0x4
    80001b44:	96078793          	addi	a5,a5,-1696 # 800054a0 <kernelvec>
    80001b48:	10579073          	csrw	stvec,a5
    w_stvec((uint64)kernelvec);
}
    80001b4c:	6422                	ld	s0,8(sp)
    80001b4e:	0141                	addi	sp,sp,16
    80001b50:	8082                	ret

0000000080001b52 <usertrapret>:

//
// return to user space
//
void usertrapret(void)
{
    80001b52:	1141                	addi	sp,sp,-16
    80001b54:	e406                	sd	ra,8(sp)
    80001b56:	e022                	sd	s0,0(sp)
    80001b58:	0800                	addi	s0,sp,16
    struct proc *p = myproc();
    80001b5a:	fffff097          	auipc	ra,0xfffff
    80001b5e:	308080e7          	jalr	776(ra) # 80000e62 <myproc>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001b62:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    80001b66:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001b68:	10079073          	csrw	sstatus,a5
    // kerneltrap() to usertrap(), so turn off interrupts until
    // we're back in user space, where usertrap() is correct.
    intr_off();

    // send syscalls, interrupts, and exceptions to uservec in trampoline.S
    uint64 trampoline_uservec = TRAMPOLINE + (uservec - trampoline);
    80001b6c:	00005617          	auipc	a2,0x5
    80001b70:	49460613          	addi	a2,a2,1172 # 80007000 <_trampoline>
    80001b74:	00005697          	auipc	a3,0x5
    80001b78:	48c68693          	addi	a3,a3,1164 # 80007000 <_trampoline>
    80001b7c:	8e91                	sub	a3,a3,a2
    80001b7e:	040007b7          	lui	a5,0x4000
    80001b82:	17fd                	addi	a5,a5,-1
    80001b84:	07b2                	slli	a5,a5,0xc
    80001b86:	96be                	add	a3,a3,a5
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001b88:	10569073          	csrw	stvec,a3
    w_stvec(trampoline_uservec);

    // set up trapframe values that uservec will need when
    // the process next traps into the kernel.
    p->trapframe->kernel_satp = r_satp();         // kernel page table
    80001b8c:	6d38                	ld	a4,88(a0)
  asm volatile("csrr %0, satp" : "=r" (x) );
    80001b8e:	180026f3          	csrr	a3,satp
    80001b92:	e314                	sd	a3,0(a4)
    p->trapframe->kernel_sp = p->kstack + PGSIZE; // process's kernel stack
    80001b94:	6d38                	ld	a4,88(a0)
    80001b96:	6134                	ld	a3,64(a0)
    80001b98:	6585                	lui	a1,0x1
    80001b9a:	96ae                	add	a3,a3,a1
    80001b9c:	e714                	sd	a3,8(a4)
    p->trapframe->kernel_trap = (uint64)usertrap;
    80001b9e:	6d38                	ld	a4,88(a0)
    80001ba0:	00000697          	auipc	a3,0x0
    80001ba4:	13068693          	addi	a3,a3,304 # 80001cd0 <usertrap>
    80001ba8:	eb14                	sd	a3,16(a4)
    p->trapframe->kernel_hartid = r_tp(); // hartid for cpuid()
    80001baa:	6d38                	ld	a4,88(a0)
  asm volatile("mv %0, tp" : "=r" (x) );
    80001bac:	8692                	mv	a3,tp
    80001bae:	f314                	sd	a3,32(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001bb0:	100026f3          	csrr	a3,sstatus
    // set up the registers that trampoline.S's sret will use
    // to get to user space.

    // set S Previous Privilege mode to User.
    unsigned long x = r_sstatus();
    x &= ~SSTATUS_SPP; // clear SPP to 0 for user mode
    80001bb4:	eff6f693          	andi	a3,a3,-257
    x |= SSTATUS_SPIE; // enable interrupts in user mode
    80001bb8:	0206e693          	ori	a3,a3,32
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001bbc:	10069073          	csrw	sstatus,a3
    w_sstatus(x);

    // set S Exception Program Counter to the saved user pc.
    w_sepc(p->trapframe->epc);
    80001bc0:	6d38                	ld	a4,88(a0)
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001bc2:	6f18                	ld	a4,24(a4)
    80001bc4:	14171073          	csrw	sepc,a4

    // tell trampoline.S the user page table to switch to.
    uint64 satp = MAKE_SATP(p->pagetable);
    80001bc8:	6928                	ld	a0,80(a0)
    80001bca:	8131                	srli	a0,a0,0xc

    // jump to userret in trampoline.S at the top of memory, which
    // switches to the user page table, restores user registers,
    // and switches to user mode with sret.
    uint64 trampoline_userret = TRAMPOLINE + (userret - trampoline);
    80001bcc:	00005717          	auipc	a4,0x5
    80001bd0:	4d070713          	addi	a4,a4,1232 # 8000709c <userret>
    80001bd4:	8f11                	sub	a4,a4,a2
    80001bd6:	97ba                	add	a5,a5,a4
    ((void (*)(uint64))trampoline_userret)(satp);
    80001bd8:	577d                	li	a4,-1
    80001bda:	177e                	slli	a4,a4,0x3f
    80001bdc:	8d59                	or	a0,a0,a4
    80001bde:	9782                	jalr	a5
}
    80001be0:	60a2                	ld	ra,8(sp)
    80001be2:	6402                	ld	s0,0(sp)
    80001be4:	0141                	addi	sp,sp,16
    80001be6:	8082                	ret

0000000080001be8 <clockintr>:
    w_sepc(sepc);
    w_sstatus(sstatus);
}

void clockintr()
{
    80001be8:	1101                	addi	sp,sp,-32
    80001bea:	ec06                	sd	ra,24(sp)
    80001bec:	e822                	sd	s0,16(sp)
    80001bee:	e426                	sd	s1,8(sp)
    80001bf0:	1000                	addi	s0,sp,32
    acquire(&tickslock);
    80001bf2:	0001f497          	auipc	s1,0x1f
    80001bf6:	dde48493          	addi	s1,s1,-546 # 800209d0 <tickslock>
    80001bfa:	8526                	mv	a0,s1
    80001bfc:	00005097          	auipc	ra,0x5
    80001c00:	a20080e7          	jalr	-1504(ra) # 8000661c <acquire>
    ticks++;
    80001c04:	00007517          	auipc	a0,0x7
    80001c08:	f6450513          	addi	a0,a0,-156 # 80008b68 <ticks>
    80001c0c:	411c                	lw	a5,0(a0)
    80001c0e:	2785                	addiw	a5,a5,1
    80001c10:	c11c                	sw	a5,0(a0)
    wakeup(&ticks);
    80001c12:	00000097          	auipc	ra,0x0
    80001c16:	998080e7          	jalr	-1640(ra) # 800015aa <wakeup>
    release(&tickslock);
    80001c1a:	8526                	mv	a0,s1
    80001c1c:	00005097          	auipc	ra,0x5
    80001c20:	ab4080e7          	jalr	-1356(ra) # 800066d0 <release>
}
    80001c24:	60e2                	ld	ra,24(sp)
    80001c26:	6442                	ld	s0,16(sp)
    80001c28:	64a2                	ld	s1,8(sp)
    80001c2a:	6105                	addi	sp,sp,32
    80001c2c:	8082                	ret

0000000080001c2e <devintr>:
// and handle it.
// returns 2 if timer interrupt,
// 1 if other device,
// 0 if not recognized.
int devintr()
{
    80001c2e:	1101                	addi	sp,sp,-32
    80001c30:	ec06                	sd	ra,24(sp)
    80001c32:	e822                	sd	s0,16(sp)
    80001c34:	e426                	sd	s1,8(sp)
    80001c36:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001c38:	14202773          	csrr	a4,scause
    uint64 scause = r_scause();

    if ((scause & 0x8000000000000000L) &&
    80001c3c:	00074d63          	bltz	a4,80001c56 <devintr+0x28>
        if (irq)
            plic_complete(irq);

        return 1;
    }
    else if (scause == 0x8000000000000001L)
    80001c40:	57fd                	li	a5,-1
    80001c42:	17fe                	slli	a5,a5,0x3f
    80001c44:	0785                	addi	a5,a5,1

        return 2;
    }
    else
    {
        return 0;
    80001c46:	4501                	li	a0,0
    else if (scause == 0x8000000000000001L)
    80001c48:	06f70363          	beq	a4,a5,80001cae <devintr+0x80>
    }
}
    80001c4c:	60e2                	ld	ra,24(sp)
    80001c4e:	6442                	ld	s0,16(sp)
    80001c50:	64a2                	ld	s1,8(sp)
    80001c52:	6105                	addi	sp,sp,32
    80001c54:	8082                	ret
        (scause & 0xff) == 9)
    80001c56:	0ff77793          	andi	a5,a4,255
    if ((scause & 0x8000000000000000L) &&
    80001c5a:	46a5                	li	a3,9
    80001c5c:	fed792e3          	bne	a5,a3,80001c40 <devintr+0x12>
        int irq = plic_claim();
    80001c60:	00004097          	auipc	ra,0x4
    80001c64:	948080e7          	jalr	-1720(ra) # 800055a8 <plic_claim>
    80001c68:	84aa                	mv	s1,a0
        if (irq == UART0_IRQ)
    80001c6a:	47a9                	li	a5,10
    80001c6c:	02f50763          	beq	a0,a5,80001c9a <devintr+0x6c>
        else if (irq == VIRTIO0_IRQ)
    80001c70:	4785                	li	a5,1
    80001c72:	02f50963          	beq	a0,a5,80001ca4 <devintr+0x76>
        return 1;
    80001c76:	4505                	li	a0,1
        else if (irq)
    80001c78:	d8f1                	beqz	s1,80001c4c <devintr+0x1e>
            printf("unexpected interrupt irq=%d\n", irq);
    80001c7a:	85a6                	mv	a1,s1
    80001c7c:	00006517          	auipc	a0,0x6
    80001c80:	5fc50513          	addi	a0,a0,1532 # 80008278 <states.1744+0x38>
    80001c84:	00004097          	auipc	ra,0x4
    80001c88:	498080e7          	jalr	1176(ra) # 8000611c <printf>
            plic_complete(irq);
    80001c8c:	8526                	mv	a0,s1
    80001c8e:	00004097          	auipc	ra,0x4
    80001c92:	93e080e7          	jalr	-1730(ra) # 800055cc <plic_complete>
        return 1;
    80001c96:	4505                	li	a0,1
    80001c98:	bf55                	j	80001c4c <devintr+0x1e>
            uartintr();
    80001c9a:	00005097          	auipc	ra,0x5
    80001c9e:	8a2080e7          	jalr	-1886(ra) # 8000653c <uartintr>
    80001ca2:	b7ed                	j	80001c8c <devintr+0x5e>
            virtio_disk_intr();
    80001ca4:	00004097          	auipc	ra,0x4
    80001ca8:	e52080e7          	jalr	-430(ra) # 80005af6 <virtio_disk_intr>
    80001cac:	b7c5                	j	80001c8c <devintr+0x5e>
        if (cpuid() == 0)
    80001cae:	fffff097          	auipc	ra,0xfffff
    80001cb2:	188080e7          	jalr	392(ra) # 80000e36 <cpuid>
    80001cb6:	c901                	beqz	a0,80001cc6 <devintr+0x98>
  asm volatile("csrr %0, sip" : "=r" (x) );
    80001cb8:	144027f3          	csrr	a5,sip
        w_sip(r_sip() & ~2);
    80001cbc:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sip, %0" : : "r" (x));
    80001cbe:	14479073          	csrw	sip,a5
        return 2;
    80001cc2:	4509                	li	a0,2
    80001cc4:	b761                	j	80001c4c <devintr+0x1e>
            clockintr();
    80001cc6:	00000097          	auipc	ra,0x0
    80001cca:	f22080e7          	jalr	-222(ra) # 80001be8 <clockintr>
    80001cce:	b7ed                	j	80001cb8 <devintr+0x8a>

0000000080001cd0 <usertrap>:
{
    80001cd0:	715d                	addi	sp,sp,-80
    80001cd2:	e486                	sd	ra,72(sp)
    80001cd4:	e0a2                	sd	s0,64(sp)
    80001cd6:	fc26                	sd	s1,56(sp)
    80001cd8:	f84a                	sd	s2,48(sp)
    80001cda:	f44e                	sd	s3,40(sp)
    80001cdc:	f052                	sd	s4,32(sp)
    80001cde:	ec56                	sd	s5,24(sp)
    80001ce0:	e85a                	sd	s6,16(sp)
    80001ce2:	e45e                	sd	s7,8(sp)
    80001ce4:	0880                	addi	s0,sp,80
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001ce6:	100027f3          	csrr	a5,sstatus
    if ((r_sstatus() & SSTATUS_SPP) != 0)
    80001cea:	1007f793          	andi	a5,a5,256
    80001cee:	e7c1                	bnez	a5,80001d76 <usertrap+0xa6>
  asm volatile("csrw stvec, %0" : : "r" (x));
    80001cf0:	00003797          	auipc	a5,0x3
    80001cf4:	7b078793          	addi	a5,a5,1968 # 800054a0 <kernelvec>
    80001cf8:	10579073          	csrw	stvec,a5
    struct proc *p = myproc();
    80001cfc:	fffff097          	auipc	ra,0xfffff
    80001d00:	166080e7          	jalr	358(ra) # 80000e62 <myproc>
    80001d04:	892a                	mv	s2,a0
    p->trapframe->epc = r_sepc();
    80001d06:	6d3c                	ld	a5,88(a0)
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d08:	14102773          	csrr	a4,sepc
    80001d0c:	ef98                	sd	a4,24(a5)
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001d0e:	14202773          	csrr	a4,scause
    if (r_scause() == 8)
    80001d12:	47a1                	li	a5,8
    80001d14:	06f70963          	beq	a4,a5,80001d86 <usertrap+0xb6>
    else if ((which_dev = devintr()) != 0)
    80001d18:	00000097          	auipc	ra,0x0
    80001d1c:	f16080e7          	jalr	-234(ra) # 80001c2e <devintr>
    80001d20:	84aa                	mv	s1,a0
    80001d22:	1c051d63          	bnez	a0,80001efc <usertrap+0x22c>
    80001d26:	14202773          	csrr	a4,scause
    else if (r_scause() == 13 || r_scause() == 15)
    80001d2a:	47b5                	li	a5,13
    80001d2c:	0af70d63          	beq	a4,a5,80001de6 <usertrap+0x116>
    80001d30:	14202773          	csrr	a4,scause
    80001d34:	47bd                	li	a5,15
    80001d36:	0af70863          	beq	a4,a5,80001de6 <usertrap+0x116>
    80001d3a:	142025f3          	csrr	a1,scause
        printf("usertrap(): unexpected scause %p pid=%d\n", r_scause(), p->pid);
    80001d3e:	03092603          	lw	a2,48(s2)
    80001d42:	00006517          	auipc	a0,0x6
    80001d46:	62650513          	addi	a0,a0,1574 # 80008368 <states.1744+0x128>
    80001d4a:	00004097          	auipc	ra,0x4
    80001d4e:	3d2080e7          	jalr	978(ra) # 8000611c <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001d52:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001d56:	14302673          	csrr	a2,stval
        printf("            sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001d5a:	00006517          	auipc	a0,0x6
    80001d5e:	63e50513          	addi	a0,a0,1598 # 80008398 <states.1744+0x158>
    80001d62:	00004097          	auipc	ra,0x4
    80001d66:	3ba080e7          	jalr	954(ra) # 8000611c <printf>
        setkilled(p);
    80001d6a:	854a                	mv	a0,s2
    80001d6c:	00000097          	auipc	ra,0x0
    80001d70:	a56080e7          	jalr	-1450(ra) # 800017c2 <setkilled>
    80001d74:	a82d                	j	80001dae <usertrap+0xde>
        panic("usertrap: not from user mode");
    80001d76:	00006517          	auipc	a0,0x6
    80001d7a:	52250513          	addi	a0,a0,1314 # 80008298 <states.1744+0x58>
    80001d7e:	00004097          	auipc	ra,0x4
    80001d82:	354080e7          	jalr	852(ra) # 800060d2 <panic>
        if (killed(p))
    80001d86:	00000097          	auipc	ra,0x0
    80001d8a:	a68080e7          	jalr	-1432(ra) # 800017ee <killed>
    80001d8e:	e531                	bnez	a0,80001dda <usertrap+0x10a>
        p->trapframe->epc += 4;
    80001d90:	05893703          	ld	a4,88(s2)
    80001d94:	6f1c                	ld	a5,24(a4)
    80001d96:	0791                	addi	a5,a5,4
    80001d98:	ef1c                	sd	a5,24(a4)
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001d9a:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    80001d9e:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001da2:	10079073          	csrw	sstatus,a5
        syscall();
    80001da6:	00000097          	auipc	ra,0x0
    80001daa:	3ca080e7          	jalr	970(ra) # 80002170 <syscall>
    if (killed(p))
    80001dae:	854a                	mv	a0,s2
    80001db0:	00000097          	auipc	ra,0x0
    80001db4:	a3e080e7          	jalr	-1474(ra) # 800017ee <killed>
    80001db8:	14051963          	bnez	a0,80001f0a <usertrap+0x23a>
    usertrapret();
    80001dbc:	00000097          	auipc	ra,0x0
    80001dc0:	d96080e7          	jalr	-618(ra) # 80001b52 <usertrapret>
}
    80001dc4:	60a6                	ld	ra,72(sp)
    80001dc6:	6406                	ld	s0,64(sp)
    80001dc8:	74e2                	ld	s1,56(sp)
    80001dca:	7942                	ld	s2,48(sp)
    80001dcc:	79a2                	ld	s3,40(sp)
    80001dce:	7a02                	ld	s4,32(sp)
    80001dd0:	6ae2                	ld	s5,24(sp)
    80001dd2:	6b42                	ld	s6,16(sp)
    80001dd4:	6ba2                	ld	s7,8(sp)
    80001dd6:	6161                	addi	sp,sp,80
    80001dd8:	8082                	ret
            exit(-1);
    80001dda:	557d                	li	a0,-1
    80001ddc:	00000097          	auipc	ra,0x0
    80001de0:	89e080e7          	jalr	-1890(ra) # 8000167a <exit>
    80001de4:	b775                	j	80001d90 <usertrap+0xc0>
        struct proc *p_proc = myproc();
    80001de6:	fffff097          	auipc	ra,0xfffff
    80001dea:	07c080e7          	jalr	124(ra) # 80000e62 <myproc>
    80001dee:	8a2a                	mv	s4,a0
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001df0:	143029f3          	csrr	s3,stval
        printf("[Testing] (trap) : va: %d\n", va);
    80001df4:	85ce                	mv	a1,s3
    80001df6:	00006517          	auipc	a0,0x6
    80001dfa:	4c250513          	addi	a0,a0,1218 # 800082b8 <states.1744+0x78>
    80001dfe:	00004097          	auipc	ra,0x4
    80001e02:	31e080e7          	jalr	798(ra) # 8000611c <printf>
        for (int i = 0; i <= VMASIZE - 1; i++)
    80001e06:	168a0793          	addi	a5,s4,360
            if (p_proc->vma[i].occupied == 1)
    80001e0a:	4605                	li	a2,1
        for (int i = 0; i <= VMASIZE - 1; i++)
    80001e0c:	45c1                	li	a1,16
    80001e0e:	a031                	j	80001e1a <usertrap+0x14a>
    80001e10:	2485                	addiw	s1,s1,1
    80001e12:	04878793          	addi	a5,a5,72
    80001e16:	0cb48463          	beq	s1,a1,80001ede <usertrap+0x20e>
            if (p_proc->vma[i].occupied == 1)
    80001e1a:	4398                	lw	a4,0(a5)
    80001e1c:	fec71ae3          	bne	a4,a2,80001e10 <usertrap+0x140>
                if (p_proc->vma[i].start_addr <= va && va <= p_proc->vma[i].end_addr)
    80001e20:	6798                	ld	a4,8(a5)
    80001e22:	fee9e7e3          	bltu	s3,a4,80001e10 <usertrap+0x140>
    80001e26:	6b98                	ld	a4,16(a5)
    80001e28:	ff3764e3          	bltu	a4,s3,80001e10 <usertrap+0x140>
                    printf("[Testing] (trap) : Find it!\n");
    80001e2c:	00006517          	auipc	a0,0x6
    80001e30:	4ac50513          	addi	a0,a0,1196 # 800082d8 <states.1744+0x98>
    80001e34:	00004097          	auipc	ra,0x4
    80001e38:	2e8080e7          	jalr	744(ra) # 8000611c <printf>
                    printf("[Testing] (trap) : %d, %d -> %d\n", i, p_proc->vma[i].start_addr, p_proc->vma[i].end_addr);
    80001e3c:	00349793          	slli	a5,s1,0x3
    80001e40:	97a6                	add	a5,a5,s1
    80001e42:	078e                	slli	a5,a5,0x3
    80001e44:	97d2                	add	a5,a5,s4
    80001e46:	1787b683          	ld	a3,376(a5)
    80001e4a:	1707b603          	ld	a2,368(a5)
    80001e4e:	85a6                	mv	a1,s1
    80001e50:	00006517          	auipc	a0,0x6
    80001e54:	4a850513          	addi	a0,a0,1192 # 800082f8 <states.1744+0xb8>
    80001e58:	00004097          	auipc	ra,0x4
    80001e5c:	2c4080e7          	jalr	708(ra) # 8000611c <printf>
            char *mem = (char *)kalloc();
    80001e60:	ffffe097          	auipc	ra,0xffffe
    80001e64:	2b8080e7          	jalr	696(ra) # 80000118 <kalloc>
    80001e68:	8baa                	mv	s7,a0
            if (mem == 0)
    80001e6a:	c159                	beqz	a0,80001ef0 <usertrap+0x220>
                memset(mem, 0, PGSIZE);
    80001e6c:	6605                	lui	a2,0x1
    80001e6e:	4581                	li	a1,0
    80001e70:	ffffe097          	auipc	ra,0xffffe
    80001e74:	308080e7          	jalr	776(ra) # 80000178 <memset>
                printf("[Testing] (trap) : map off: %d\n", va - p_vma->start_addr);
    80001e78:	00349a93          	slli	s5,s1,0x3
    80001e7c:	009a8b33          	add	s6,s5,s1
    80001e80:	0b0e                	slli	s6,s6,0x3
    80001e82:	9b52                	add	s6,s6,s4
    80001e84:	170b3583          	ld	a1,368(s6)
    80001e88:	40b985b3          	sub	a1,s3,a1
    80001e8c:	00006517          	auipc	a0,0x6
    80001e90:	4bc50513          	addi	a0,a0,1212 # 80008348 <states.1744+0x108>
    80001e94:	00004097          	auipc	ra,0x4
    80001e98:	288080e7          	jalr	648(ra) # 8000611c <printf>
                mapfile(p_vma->pf, mem, va - p_vma->start_addr);
    80001e9c:	170b3603          	ld	a2,368(s6)
    80001ea0:	40c9863b          	subw	a2,s3,a2
    80001ea4:	85de                	mv	a1,s7
    80001ea6:	1a8b3503          	ld	a0,424(s6)
    80001eaa:	00002097          	auipc	ra,0x2
    80001eae:	d90080e7          	jalr	-624(ra) # 80003c3a <mapfile>
                if (mappages(p_proc->pagetable, va, PGSIZE, (uint64)mem, (p_vma->prot | PTE_R | PTE_X | PTE_W | PTE_U)) == -1)
    80001eb2:	190b2703          	lw	a4,400(s6)
    80001eb6:	01e76713          	ori	a4,a4,30
    80001eba:	86de                	mv	a3,s7
    80001ebc:	6605                	lui	a2,0x1
    80001ebe:	85ce                	mv	a1,s3
    80001ec0:	050a3503          	ld	a0,80(s4)
    80001ec4:	ffffe097          	auipc	ra,0xffffe
    80001ec8:	688080e7          	jalr	1672(ra) # 8000054c <mappages>
    80001ecc:	57fd                	li	a5,-1
    80001ece:	eef510e3          	bne	a0,a5,80001dae <usertrap+0xde>
                    setkilled(p_proc);
    80001ed2:	8552                	mv	a0,s4
    80001ed4:	00000097          	auipc	ra,0x0
    80001ed8:	8ee080e7          	jalr	-1810(ra) # 800017c2 <setkilled>
    80001edc:	bdc9                	j	80001dae <usertrap+0xde>
            printf("Now, after mmap, we get a page fault\n");
    80001ede:	00006517          	auipc	a0,0x6
    80001ee2:	44250513          	addi	a0,a0,1090 # 80008320 <states.1744+0xe0>
    80001ee6:	00004097          	auipc	ra,0x4
    80001eea:	236080e7          	jalr	566(ra) # 8000611c <printf>
            goto err;
    80001eee:	b5b1                	j	80001d3a <usertrap+0x6a>
                setkilled(p_proc);
    80001ef0:	8552                	mv	a0,s4
    80001ef2:	00000097          	auipc	ra,0x0
    80001ef6:	8d0080e7          	jalr	-1840(ra) # 800017c2 <setkilled>
                return;
    80001efa:	b5e9                	j	80001dc4 <usertrap+0xf4>
    if (killed(p))
    80001efc:	854a                	mv	a0,s2
    80001efe:	00000097          	auipc	ra,0x0
    80001f02:	8f0080e7          	jalr	-1808(ra) # 800017ee <killed>
    80001f06:	c901                	beqz	a0,80001f16 <usertrap+0x246>
    80001f08:	a011                	j	80001f0c <usertrap+0x23c>
    80001f0a:	4481                	li	s1,0
        exit(-1);
    80001f0c:	557d                	li	a0,-1
    80001f0e:	fffff097          	auipc	ra,0xfffff
    80001f12:	76c080e7          	jalr	1900(ra) # 8000167a <exit>
    if (which_dev == 2)
    80001f16:	4789                	li	a5,2
    80001f18:	eaf492e3          	bne	s1,a5,80001dbc <usertrap+0xec>
        yield();
    80001f1c:	fffff097          	auipc	ra,0xfffff
    80001f20:	5ee080e7          	jalr	1518(ra) # 8000150a <yield>
    80001f24:	bd61                	j	80001dbc <usertrap+0xec>

0000000080001f26 <kerneltrap>:
{
    80001f26:	7179                	addi	sp,sp,-48
    80001f28:	f406                	sd	ra,40(sp)
    80001f2a:	f022                	sd	s0,32(sp)
    80001f2c:	ec26                	sd	s1,24(sp)
    80001f2e:	e84a                	sd	s2,16(sp)
    80001f30:	e44e                	sd	s3,8(sp)
    80001f32:	1800                	addi	s0,sp,48
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001f34:	14102973          	csrr	s2,sepc
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f38:	100024f3          	csrr	s1,sstatus
  asm volatile("csrr %0, scause" : "=r" (x) );
    80001f3c:	142029f3          	csrr	s3,scause
    if ((sstatus & SSTATUS_SPP) == 0)
    80001f40:	1004f793          	andi	a5,s1,256
    80001f44:	cb85                	beqz	a5,80001f74 <kerneltrap+0x4e>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80001f46:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80001f4a:	8b89                	andi	a5,a5,2
    if (intr_get() != 0)
    80001f4c:	ef85                	bnez	a5,80001f84 <kerneltrap+0x5e>
    if ((which_dev = devintr()) == 0)
    80001f4e:	00000097          	auipc	ra,0x0
    80001f52:	ce0080e7          	jalr	-800(ra) # 80001c2e <devintr>
    80001f56:	cd1d                	beqz	a0,80001f94 <kerneltrap+0x6e>
    if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001f58:	4789                	li	a5,2
    80001f5a:	06f50a63          	beq	a0,a5,80001fce <kerneltrap+0xa8>
  asm volatile("csrw sepc, %0" : : "r" (x));
    80001f5e:	14191073          	csrw	sepc,s2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    80001f62:	10049073          	csrw	sstatus,s1
}
    80001f66:	70a2                	ld	ra,40(sp)
    80001f68:	7402                	ld	s0,32(sp)
    80001f6a:	64e2                	ld	s1,24(sp)
    80001f6c:	6942                	ld	s2,16(sp)
    80001f6e:	69a2                	ld	s3,8(sp)
    80001f70:	6145                	addi	sp,sp,48
    80001f72:	8082                	ret
        panic("kerneltrap: not from supervisor mode");
    80001f74:	00006517          	auipc	a0,0x6
    80001f78:	44450513          	addi	a0,a0,1092 # 800083b8 <states.1744+0x178>
    80001f7c:	00004097          	auipc	ra,0x4
    80001f80:	156080e7          	jalr	342(ra) # 800060d2 <panic>
        panic("kerneltrap: interrupts enabled");
    80001f84:	00006517          	auipc	a0,0x6
    80001f88:	45c50513          	addi	a0,a0,1116 # 800083e0 <states.1744+0x1a0>
    80001f8c:	00004097          	auipc	ra,0x4
    80001f90:	146080e7          	jalr	326(ra) # 800060d2 <panic>
        printf("scause %p\n", scause);
    80001f94:	85ce                	mv	a1,s3
    80001f96:	00006517          	auipc	a0,0x6
    80001f9a:	46a50513          	addi	a0,a0,1130 # 80008400 <states.1744+0x1c0>
    80001f9e:	00004097          	auipc	ra,0x4
    80001fa2:	17e080e7          	jalr	382(ra) # 8000611c <printf>
  asm volatile("csrr %0, sepc" : "=r" (x) );
    80001fa6:	141025f3          	csrr	a1,sepc
  asm volatile("csrr %0, stval" : "=r" (x) );
    80001faa:	14302673          	csrr	a2,stval
        printf("sepc=%p stval=%p\n", r_sepc(), r_stval());
    80001fae:	00006517          	auipc	a0,0x6
    80001fb2:	46250513          	addi	a0,a0,1122 # 80008410 <states.1744+0x1d0>
    80001fb6:	00004097          	auipc	ra,0x4
    80001fba:	166080e7          	jalr	358(ra) # 8000611c <printf>
        panic("kerneltrap");
    80001fbe:	00006517          	auipc	a0,0x6
    80001fc2:	46a50513          	addi	a0,a0,1130 # 80008428 <states.1744+0x1e8>
    80001fc6:	00004097          	auipc	ra,0x4
    80001fca:	10c080e7          	jalr	268(ra) # 800060d2 <panic>
    if (which_dev == 2 && myproc() != 0 && myproc()->state == RUNNING)
    80001fce:	fffff097          	auipc	ra,0xfffff
    80001fd2:	e94080e7          	jalr	-364(ra) # 80000e62 <myproc>
    80001fd6:	d541                	beqz	a0,80001f5e <kerneltrap+0x38>
    80001fd8:	fffff097          	auipc	ra,0xfffff
    80001fdc:	e8a080e7          	jalr	-374(ra) # 80000e62 <myproc>
    80001fe0:	4d18                	lw	a4,24(a0)
    80001fe2:	4791                	li	a5,4
    80001fe4:	f6f71de3          	bne	a4,a5,80001f5e <kerneltrap+0x38>
        yield();
    80001fe8:	fffff097          	auipc	ra,0xfffff
    80001fec:	522080e7          	jalr	1314(ra) # 8000150a <yield>
    80001ff0:	b7bd                	j	80001f5e <kerneltrap+0x38>

0000000080001ff2 <argraw>:
    return strlen(buf);
}

static uint64
argraw(int n)
{
    80001ff2:	1101                	addi	sp,sp,-32
    80001ff4:	ec06                	sd	ra,24(sp)
    80001ff6:	e822                	sd	s0,16(sp)
    80001ff8:	e426                	sd	s1,8(sp)
    80001ffa:	1000                	addi	s0,sp,32
    80001ffc:	84aa                	mv	s1,a0
    struct proc *p = myproc();
    80001ffe:	fffff097          	auipc	ra,0xfffff
    80002002:	e64080e7          	jalr	-412(ra) # 80000e62 <myproc>
    switch (n)
    80002006:	4795                	li	a5,5
    80002008:	0497e163          	bltu	a5,s1,8000204a <argraw+0x58>
    8000200c:	048a                	slli	s1,s1,0x2
    8000200e:	00006717          	auipc	a4,0x6
    80002012:	45270713          	addi	a4,a4,1106 # 80008460 <states.1744+0x220>
    80002016:	94ba                	add	s1,s1,a4
    80002018:	409c                	lw	a5,0(s1)
    8000201a:	97ba                	add	a5,a5,a4
    8000201c:	8782                	jr	a5
    {
    case 0:
        return p->trapframe->a0;
    8000201e:	6d3c                	ld	a5,88(a0)
    80002020:	7ba8                	ld	a0,112(a5)
    case 5:
        return p->trapframe->a5;
    }
    panic("argraw");
    return -1;
}
    80002022:	60e2                	ld	ra,24(sp)
    80002024:	6442                	ld	s0,16(sp)
    80002026:	64a2                	ld	s1,8(sp)
    80002028:	6105                	addi	sp,sp,32
    8000202a:	8082                	ret
        return p->trapframe->a1;
    8000202c:	6d3c                	ld	a5,88(a0)
    8000202e:	7fa8                	ld	a0,120(a5)
    80002030:	bfcd                	j	80002022 <argraw+0x30>
        return p->trapframe->a2;
    80002032:	6d3c                	ld	a5,88(a0)
    80002034:	63c8                	ld	a0,128(a5)
    80002036:	b7f5                	j	80002022 <argraw+0x30>
        return p->trapframe->a3;
    80002038:	6d3c                	ld	a5,88(a0)
    8000203a:	67c8                	ld	a0,136(a5)
    8000203c:	b7dd                	j	80002022 <argraw+0x30>
        return p->trapframe->a4;
    8000203e:	6d3c                	ld	a5,88(a0)
    80002040:	6bc8                	ld	a0,144(a5)
    80002042:	b7c5                	j	80002022 <argraw+0x30>
        return p->trapframe->a5;
    80002044:	6d3c                	ld	a5,88(a0)
    80002046:	6fc8                	ld	a0,152(a5)
    80002048:	bfe9                	j	80002022 <argraw+0x30>
    panic("argraw");
    8000204a:	00006517          	auipc	a0,0x6
    8000204e:	3ee50513          	addi	a0,a0,1006 # 80008438 <states.1744+0x1f8>
    80002052:	00004097          	auipc	ra,0x4
    80002056:	080080e7          	jalr	128(ra) # 800060d2 <panic>

000000008000205a <fetchaddr>:
{
    8000205a:	1101                	addi	sp,sp,-32
    8000205c:	ec06                	sd	ra,24(sp)
    8000205e:	e822                	sd	s0,16(sp)
    80002060:	e426                	sd	s1,8(sp)
    80002062:	e04a                	sd	s2,0(sp)
    80002064:	1000                	addi	s0,sp,32
    80002066:	84aa                	mv	s1,a0
    80002068:	892e                	mv	s2,a1
    struct proc *p = myproc();
    8000206a:	fffff097          	auipc	ra,0xfffff
    8000206e:	df8080e7          	jalr	-520(ra) # 80000e62 <myproc>
    if (addr >= p->sz || addr + sizeof(uint64) > p->sz) // both tests needed, in case of overflow
    80002072:	653c                	ld	a5,72(a0)
    80002074:	02f4f863          	bgeu	s1,a5,800020a4 <fetchaddr+0x4a>
    80002078:	00848713          	addi	a4,s1,8
    8000207c:	02e7e663          	bltu	a5,a4,800020a8 <fetchaddr+0x4e>
    if (copyin(p->pagetable, (char *)ip, addr, sizeof(*ip)) != 0)
    80002080:	46a1                	li	a3,8
    80002082:	8626                	mv	a2,s1
    80002084:	85ca                	mv	a1,s2
    80002086:	6928                	ld	a0,80(a0)
    80002088:	fffff097          	auipc	ra,0xfffff
    8000208c:	b24080e7          	jalr	-1244(ra) # 80000bac <copyin>
    80002090:	00a03533          	snez	a0,a0
    80002094:	40a00533          	neg	a0,a0
}
    80002098:	60e2                	ld	ra,24(sp)
    8000209a:	6442                	ld	s0,16(sp)
    8000209c:	64a2                	ld	s1,8(sp)
    8000209e:	6902                	ld	s2,0(sp)
    800020a0:	6105                	addi	sp,sp,32
    800020a2:	8082                	ret
        return -1;
    800020a4:	557d                	li	a0,-1
    800020a6:	bfcd                	j	80002098 <fetchaddr+0x3e>
    800020a8:	557d                	li	a0,-1
    800020aa:	b7fd                	j	80002098 <fetchaddr+0x3e>

00000000800020ac <fetchstr>:
{
    800020ac:	7179                	addi	sp,sp,-48
    800020ae:	f406                	sd	ra,40(sp)
    800020b0:	f022                	sd	s0,32(sp)
    800020b2:	ec26                	sd	s1,24(sp)
    800020b4:	e84a                	sd	s2,16(sp)
    800020b6:	e44e                	sd	s3,8(sp)
    800020b8:	1800                	addi	s0,sp,48
    800020ba:	892a                	mv	s2,a0
    800020bc:	84ae                	mv	s1,a1
    800020be:	89b2                	mv	s3,a2
    struct proc *p = myproc();
    800020c0:	fffff097          	auipc	ra,0xfffff
    800020c4:	da2080e7          	jalr	-606(ra) # 80000e62 <myproc>
    if (copyinstr(p->pagetable, buf, addr, max) < 0)
    800020c8:	86ce                	mv	a3,s3
    800020ca:	864a                	mv	a2,s2
    800020cc:	85a6                	mv	a1,s1
    800020ce:	6928                	ld	a0,80(a0)
    800020d0:	fffff097          	auipc	ra,0xfffff
    800020d4:	b68080e7          	jalr	-1176(ra) # 80000c38 <copyinstr>
    800020d8:	00054e63          	bltz	a0,800020f4 <fetchstr+0x48>
    return strlen(buf);
    800020dc:	8526                	mv	a0,s1
    800020de:	ffffe097          	auipc	ra,0xffffe
    800020e2:	21e080e7          	jalr	542(ra) # 800002fc <strlen>
}
    800020e6:	70a2                	ld	ra,40(sp)
    800020e8:	7402                	ld	s0,32(sp)
    800020ea:	64e2                	ld	s1,24(sp)
    800020ec:	6942                	ld	s2,16(sp)
    800020ee:	69a2                	ld	s3,8(sp)
    800020f0:	6145                	addi	sp,sp,48
    800020f2:	8082                	ret
        return -1;
    800020f4:	557d                	li	a0,-1
    800020f6:	bfc5                	j	800020e6 <fetchstr+0x3a>

00000000800020f8 <argint>:

// Fetch the nth 32-bit system call argument.
void argint(int n, int *ip)
{
    800020f8:	1101                	addi	sp,sp,-32
    800020fa:	ec06                	sd	ra,24(sp)
    800020fc:	e822                	sd	s0,16(sp)
    800020fe:	e426                	sd	s1,8(sp)
    80002100:	1000                	addi	s0,sp,32
    80002102:	84ae                	mv	s1,a1
    *ip = argraw(n);
    80002104:	00000097          	auipc	ra,0x0
    80002108:	eee080e7          	jalr	-274(ra) # 80001ff2 <argraw>
    8000210c:	c088                	sw	a0,0(s1)
}
    8000210e:	60e2                	ld	ra,24(sp)
    80002110:	6442                	ld	s0,16(sp)
    80002112:	64a2                	ld	s1,8(sp)
    80002114:	6105                	addi	sp,sp,32
    80002116:	8082                	ret

0000000080002118 <argaddr>:

// Retrieve an argument as a pointer.
// Doesn't check for legality, since
// copyin/copyout will do that.
void argaddr(int n, uint64 *ip)
{
    80002118:	1101                	addi	sp,sp,-32
    8000211a:	ec06                	sd	ra,24(sp)
    8000211c:	e822                	sd	s0,16(sp)
    8000211e:	e426                	sd	s1,8(sp)
    80002120:	1000                	addi	s0,sp,32
    80002122:	84ae                	mv	s1,a1
    *ip = argraw(n);
    80002124:	00000097          	auipc	ra,0x0
    80002128:	ece080e7          	jalr	-306(ra) # 80001ff2 <argraw>
    8000212c:	e088                	sd	a0,0(s1)
}
    8000212e:	60e2                	ld	ra,24(sp)
    80002130:	6442                	ld	s0,16(sp)
    80002132:	64a2                	ld	s1,8(sp)
    80002134:	6105                	addi	sp,sp,32
    80002136:	8082                	ret

0000000080002138 <argstr>:

// Fetch the nth word-sized system call argument as a null-terminated string.
// Copies into buf, at most max.
// Returns string length if OK (including nul), -1 if error.
int argstr(int n, char *buf, int max)
{
    80002138:	7179                	addi	sp,sp,-48
    8000213a:	f406                	sd	ra,40(sp)
    8000213c:	f022                	sd	s0,32(sp)
    8000213e:	ec26                	sd	s1,24(sp)
    80002140:	e84a                	sd	s2,16(sp)
    80002142:	1800                	addi	s0,sp,48
    80002144:	84ae                	mv	s1,a1
    80002146:	8932                	mv	s2,a2
    uint64 addr;
    argaddr(n, &addr);
    80002148:	fd840593          	addi	a1,s0,-40
    8000214c:	00000097          	auipc	ra,0x0
    80002150:	fcc080e7          	jalr	-52(ra) # 80002118 <argaddr>
    return fetchstr(addr, buf, max);
    80002154:	864a                	mv	a2,s2
    80002156:	85a6                	mv	a1,s1
    80002158:	fd843503          	ld	a0,-40(s0)
    8000215c:	00000097          	auipc	ra,0x0
    80002160:	f50080e7          	jalr	-176(ra) # 800020ac <fetchstr>
}
    80002164:	70a2                	ld	ra,40(sp)
    80002166:	7402                	ld	s0,32(sp)
    80002168:	64e2                	ld	s1,24(sp)
    8000216a:	6942                	ld	s2,16(sp)
    8000216c:	6145                	addi	sp,sp,48
    8000216e:	8082                	ret

0000000080002170 <syscall>:
    [SYS_mmap] sys_mmap,
    [SYS_munmap] sys_munmap,
};

void syscall(void)
{
    80002170:	1101                	addi	sp,sp,-32
    80002172:	ec06                	sd	ra,24(sp)
    80002174:	e822                	sd	s0,16(sp)
    80002176:	e426                	sd	s1,8(sp)
    80002178:	e04a                	sd	s2,0(sp)
    8000217a:	1000                	addi	s0,sp,32
    int num;
    struct proc *p = myproc();
    8000217c:	fffff097          	auipc	ra,0xfffff
    80002180:	ce6080e7          	jalr	-794(ra) # 80000e62 <myproc>
    80002184:	84aa                	mv	s1,a0

    num = p->trapframe->a7;
    80002186:	05853903          	ld	s2,88(a0)
    8000218a:	0a893783          	ld	a5,168(s2)
    8000218e:	0007869b          	sext.w	a3,a5
    if (num > 0 && num < NELEM(syscalls) && syscalls[num])
    80002192:	37fd                	addiw	a5,a5,-1
    80002194:	4759                	li	a4,22
    80002196:	00f76f63          	bltu	a4,a5,800021b4 <syscall+0x44>
    8000219a:	00369713          	slli	a4,a3,0x3
    8000219e:	00006797          	auipc	a5,0x6
    800021a2:	2da78793          	addi	a5,a5,730 # 80008478 <syscalls>
    800021a6:	97ba                	add	a5,a5,a4
    800021a8:	639c                	ld	a5,0(a5)
    800021aa:	c789                	beqz	a5,800021b4 <syscall+0x44>
    {
        // Use num to lookup the system call function for num, call it,
        // and store its return value in p->trapframe->a0
        p->trapframe->a0 = syscalls[num]();
    800021ac:	9782                	jalr	a5
    800021ae:	06a93823          	sd	a0,112(s2)
    800021b2:	a839                	j	800021d0 <syscall+0x60>
    }
    else
    {
        printf("%d %s: unknown sys call %d\n",
    800021b4:	15848613          	addi	a2,s1,344
    800021b8:	588c                	lw	a1,48(s1)
    800021ba:	00006517          	auipc	a0,0x6
    800021be:	28650513          	addi	a0,a0,646 # 80008440 <states.1744+0x200>
    800021c2:	00004097          	auipc	ra,0x4
    800021c6:	f5a080e7          	jalr	-166(ra) # 8000611c <printf>
               p->pid, p->name, num);
        p->trapframe->a0 = -1;
    800021ca:	6cbc                	ld	a5,88(s1)
    800021cc:	577d                	li	a4,-1
    800021ce:	fbb8                	sd	a4,112(a5)
    }
}
    800021d0:	60e2                	ld	ra,24(sp)
    800021d2:	6442                	ld	s0,16(sp)
    800021d4:	64a2                	ld	s1,8(sp)
    800021d6:	6902                	ld	s2,0(sp)
    800021d8:	6105                	addi	sp,sp,32
    800021da:	8082                	ret

00000000800021dc <sys_exit>:
#include "spinlock.h"
#include "proc.h"

uint64
sys_exit(void)
{
    800021dc:	1101                	addi	sp,sp,-32
    800021de:	ec06                	sd	ra,24(sp)
    800021e0:	e822                	sd	s0,16(sp)
    800021e2:	1000                	addi	s0,sp,32
  int n;
  argint(0, &n);
    800021e4:	fec40593          	addi	a1,s0,-20
    800021e8:	4501                	li	a0,0
    800021ea:	00000097          	auipc	ra,0x0
    800021ee:	f0e080e7          	jalr	-242(ra) # 800020f8 <argint>
  exit(n);
    800021f2:	fec42503          	lw	a0,-20(s0)
    800021f6:	fffff097          	auipc	ra,0xfffff
    800021fa:	484080e7          	jalr	1156(ra) # 8000167a <exit>
  return 0;  // not reached
}
    800021fe:	4501                	li	a0,0
    80002200:	60e2                	ld	ra,24(sp)
    80002202:	6442                	ld	s0,16(sp)
    80002204:	6105                	addi	sp,sp,32
    80002206:	8082                	ret

0000000080002208 <sys_getpid>:

uint64
sys_getpid(void)
{
    80002208:	1141                	addi	sp,sp,-16
    8000220a:	e406                	sd	ra,8(sp)
    8000220c:	e022                	sd	s0,0(sp)
    8000220e:	0800                	addi	s0,sp,16
  return myproc()->pid;
    80002210:	fffff097          	auipc	ra,0xfffff
    80002214:	c52080e7          	jalr	-942(ra) # 80000e62 <myproc>
}
    80002218:	5908                	lw	a0,48(a0)
    8000221a:	60a2                	ld	ra,8(sp)
    8000221c:	6402                	ld	s0,0(sp)
    8000221e:	0141                	addi	sp,sp,16
    80002220:	8082                	ret

0000000080002222 <sys_fork>:

uint64
sys_fork(void)
{
    80002222:	1141                	addi	sp,sp,-16
    80002224:	e406                	sd	ra,8(sp)
    80002226:	e022                	sd	s0,0(sp)
    80002228:	0800                	addi	s0,sp,16
  return fork();
    8000222a:	fffff097          	auipc	ra,0xfffff
    8000222e:	fee080e7          	jalr	-18(ra) # 80001218 <fork>
}
    80002232:	60a2                	ld	ra,8(sp)
    80002234:	6402                	ld	s0,0(sp)
    80002236:	0141                	addi	sp,sp,16
    80002238:	8082                	ret

000000008000223a <sys_wait>:

uint64
sys_wait(void)
{
    8000223a:	1101                	addi	sp,sp,-32
    8000223c:	ec06                	sd	ra,24(sp)
    8000223e:	e822                	sd	s0,16(sp)
    80002240:	1000                	addi	s0,sp,32
  uint64 p;
  argaddr(0, &p);
    80002242:	fe840593          	addi	a1,s0,-24
    80002246:	4501                	li	a0,0
    80002248:	00000097          	auipc	ra,0x0
    8000224c:	ed0080e7          	jalr	-304(ra) # 80002118 <argaddr>
  return wait(p);
    80002250:	fe843503          	ld	a0,-24(s0)
    80002254:	fffff097          	auipc	ra,0xfffff
    80002258:	5cc080e7          	jalr	1484(ra) # 80001820 <wait>
}
    8000225c:	60e2                	ld	ra,24(sp)
    8000225e:	6442                	ld	s0,16(sp)
    80002260:	6105                	addi	sp,sp,32
    80002262:	8082                	ret

0000000080002264 <sys_sbrk>:

uint64
sys_sbrk(void)
{
    80002264:	7179                	addi	sp,sp,-48
    80002266:	f406                	sd	ra,40(sp)
    80002268:	f022                	sd	s0,32(sp)
    8000226a:	ec26                	sd	s1,24(sp)
    8000226c:	1800                	addi	s0,sp,48
  uint64 addr;
  int n;

  argint(0, &n);
    8000226e:	fdc40593          	addi	a1,s0,-36
    80002272:	4501                	li	a0,0
    80002274:	00000097          	auipc	ra,0x0
    80002278:	e84080e7          	jalr	-380(ra) # 800020f8 <argint>
  addr = myproc()->sz;
    8000227c:	fffff097          	auipc	ra,0xfffff
    80002280:	be6080e7          	jalr	-1050(ra) # 80000e62 <myproc>
    80002284:	6524                	ld	s1,72(a0)
  if(growproc(n) < 0)
    80002286:	fdc42503          	lw	a0,-36(s0)
    8000228a:	fffff097          	auipc	ra,0xfffff
    8000228e:	f32080e7          	jalr	-206(ra) # 800011bc <growproc>
    80002292:	00054863          	bltz	a0,800022a2 <sys_sbrk+0x3e>
    return -1;
  return addr;
}
    80002296:	8526                	mv	a0,s1
    80002298:	70a2                	ld	ra,40(sp)
    8000229a:	7402                	ld	s0,32(sp)
    8000229c:	64e2                	ld	s1,24(sp)
    8000229e:	6145                	addi	sp,sp,48
    800022a0:	8082                	ret
    return -1;
    800022a2:	54fd                	li	s1,-1
    800022a4:	bfcd                	j	80002296 <sys_sbrk+0x32>

00000000800022a6 <sys_sleep>:

uint64
sys_sleep(void)
{
    800022a6:	7139                	addi	sp,sp,-64
    800022a8:	fc06                	sd	ra,56(sp)
    800022aa:	f822                	sd	s0,48(sp)
    800022ac:	f426                	sd	s1,40(sp)
    800022ae:	f04a                	sd	s2,32(sp)
    800022b0:	ec4e                	sd	s3,24(sp)
    800022b2:	0080                	addi	s0,sp,64
  int n;
  uint ticks0;

  argint(0, &n);
    800022b4:	fcc40593          	addi	a1,s0,-52
    800022b8:	4501                	li	a0,0
    800022ba:	00000097          	auipc	ra,0x0
    800022be:	e3e080e7          	jalr	-450(ra) # 800020f8 <argint>
  if(n < 0)
    800022c2:	fcc42783          	lw	a5,-52(s0)
    800022c6:	0607cf63          	bltz	a5,80002344 <sys_sleep+0x9e>
    n = 0;
  acquire(&tickslock);
    800022ca:	0001e517          	auipc	a0,0x1e
    800022ce:	70650513          	addi	a0,a0,1798 # 800209d0 <tickslock>
    800022d2:	00004097          	auipc	ra,0x4
    800022d6:	34a080e7          	jalr	842(ra) # 8000661c <acquire>
  ticks0 = ticks;
    800022da:	00007917          	auipc	s2,0x7
    800022de:	88e92903          	lw	s2,-1906(s2) # 80008b68 <ticks>
  while(ticks - ticks0 < n){
    800022e2:	fcc42783          	lw	a5,-52(s0)
    800022e6:	cf9d                	beqz	a5,80002324 <sys_sleep+0x7e>
    if(killed(myproc())){
      release(&tickslock);
      return -1;
    }
    sleep(&ticks, &tickslock);
    800022e8:	0001e997          	auipc	s3,0x1e
    800022ec:	6e898993          	addi	s3,s3,1768 # 800209d0 <tickslock>
    800022f0:	00007497          	auipc	s1,0x7
    800022f4:	87848493          	addi	s1,s1,-1928 # 80008b68 <ticks>
    if(killed(myproc())){
    800022f8:	fffff097          	auipc	ra,0xfffff
    800022fc:	b6a080e7          	jalr	-1174(ra) # 80000e62 <myproc>
    80002300:	fffff097          	auipc	ra,0xfffff
    80002304:	4ee080e7          	jalr	1262(ra) # 800017ee <killed>
    80002308:	e129                	bnez	a0,8000234a <sys_sleep+0xa4>
    sleep(&ticks, &tickslock);
    8000230a:	85ce                	mv	a1,s3
    8000230c:	8526                	mv	a0,s1
    8000230e:	fffff097          	auipc	ra,0xfffff
    80002312:	238080e7          	jalr	568(ra) # 80001546 <sleep>
  while(ticks - ticks0 < n){
    80002316:	409c                	lw	a5,0(s1)
    80002318:	412787bb          	subw	a5,a5,s2
    8000231c:	fcc42703          	lw	a4,-52(s0)
    80002320:	fce7ece3          	bltu	a5,a4,800022f8 <sys_sleep+0x52>
  }
  release(&tickslock);
    80002324:	0001e517          	auipc	a0,0x1e
    80002328:	6ac50513          	addi	a0,a0,1708 # 800209d0 <tickslock>
    8000232c:	00004097          	auipc	ra,0x4
    80002330:	3a4080e7          	jalr	932(ra) # 800066d0 <release>
  return 0;
    80002334:	4501                	li	a0,0
}
    80002336:	70e2                	ld	ra,56(sp)
    80002338:	7442                	ld	s0,48(sp)
    8000233a:	74a2                	ld	s1,40(sp)
    8000233c:	7902                	ld	s2,32(sp)
    8000233e:	69e2                	ld	s3,24(sp)
    80002340:	6121                	addi	sp,sp,64
    80002342:	8082                	ret
    n = 0;
    80002344:	fc042623          	sw	zero,-52(s0)
    80002348:	b749                	j	800022ca <sys_sleep+0x24>
      release(&tickslock);
    8000234a:	0001e517          	auipc	a0,0x1e
    8000234e:	68650513          	addi	a0,a0,1670 # 800209d0 <tickslock>
    80002352:	00004097          	auipc	ra,0x4
    80002356:	37e080e7          	jalr	894(ra) # 800066d0 <release>
      return -1;
    8000235a:	557d                	li	a0,-1
    8000235c:	bfe9                	j	80002336 <sys_sleep+0x90>

000000008000235e <sys_kill>:

uint64
sys_kill(void)
{
    8000235e:	1101                	addi	sp,sp,-32
    80002360:	ec06                	sd	ra,24(sp)
    80002362:	e822                	sd	s0,16(sp)
    80002364:	1000                	addi	s0,sp,32
  int pid;

  argint(0, &pid);
    80002366:	fec40593          	addi	a1,s0,-20
    8000236a:	4501                	li	a0,0
    8000236c:	00000097          	auipc	ra,0x0
    80002370:	d8c080e7          	jalr	-628(ra) # 800020f8 <argint>
  return kill(pid);
    80002374:	fec42503          	lw	a0,-20(s0)
    80002378:	fffff097          	auipc	ra,0xfffff
    8000237c:	3d8080e7          	jalr	984(ra) # 80001750 <kill>
}
    80002380:	60e2                	ld	ra,24(sp)
    80002382:	6442                	ld	s0,16(sp)
    80002384:	6105                	addi	sp,sp,32
    80002386:	8082                	ret

0000000080002388 <sys_uptime>:

// return how many clock tick interrupts have occurred
// since start.
uint64
sys_uptime(void)
{
    80002388:	1101                	addi	sp,sp,-32
    8000238a:	ec06                	sd	ra,24(sp)
    8000238c:	e822                	sd	s0,16(sp)
    8000238e:	e426                	sd	s1,8(sp)
    80002390:	1000                	addi	s0,sp,32
  uint xticks;

  acquire(&tickslock);
    80002392:	0001e517          	auipc	a0,0x1e
    80002396:	63e50513          	addi	a0,a0,1598 # 800209d0 <tickslock>
    8000239a:	00004097          	auipc	ra,0x4
    8000239e:	282080e7          	jalr	642(ra) # 8000661c <acquire>
  xticks = ticks;
    800023a2:	00006497          	auipc	s1,0x6
    800023a6:	7c64a483          	lw	s1,1990(s1) # 80008b68 <ticks>
  release(&tickslock);
    800023aa:	0001e517          	auipc	a0,0x1e
    800023ae:	62650513          	addi	a0,a0,1574 # 800209d0 <tickslock>
    800023b2:	00004097          	auipc	ra,0x4
    800023b6:	31e080e7          	jalr	798(ra) # 800066d0 <release>
  return xticks;
}
    800023ba:	02049513          	slli	a0,s1,0x20
    800023be:	9101                	srli	a0,a0,0x20
    800023c0:	60e2                	ld	ra,24(sp)
    800023c2:	6442                	ld	s0,16(sp)
    800023c4:	64a2                	ld	s1,8(sp)
    800023c6:	6105                	addi	sp,sp,32
    800023c8:	8082                	ret

00000000800023ca <binit>:
  struct buf head;
} bcache;

void
binit(void)
{
    800023ca:	7179                	addi	sp,sp,-48
    800023cc:	f406                	sd	ra,40(sp)
    800023ce:	f022                	sd	s0,32(sp)
    800023d0:	ec26                	sd	s1,24(sp)
    800023d2:	e84a                	sd	s2,16(sp)
    800023d4:	e44e                	sd	s3,8(sp)
    800023d6:	e052                	sd	s4,0(sp)
    800023d8:	1800                	addi	s0,sp,48
  struct buf *b;

  initlock(&bcache.lock, "bcache");
    800023da:	00006597          	auipc	a1,0x6
    800023de:	15e58593          	addi	a1,a1,350 # 80008538 <syscalls+0xc0>
    800023e2:	0001e517          	auipc	a0,0x1e
    800023e6:	60650513          	addi	a0,a0,1542 # 800209e8 <bcache>
    800023ea:	00004097          	auipc	ra,0x4
    800023ee:	1a2080e7          	jalr	418(ra) # 8000658c <initlock>

  // Create linked list of buffers
  bcache.head.prev = &bcache.head;
    800023f2:	00026797          	auipc	a5,0x26
    800023f6:	5f678793          	addi	a5,a5,1526 # 800289e8 <bcache+0x8000>
    800023fa:	00027717          	auipc	a4,0x27
    800023fe:	85670713          	addi	a4,a4,-1962 # 80028c50 <bcache+0x8268>
    80002402:	2ae7b823          	sd	a4,688(a5)
  bcache.head.next = &bcache.head;
    80002406:	2ae7bc23          	sd	a4,696(a5)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    8000240a:	0001e497          	auipc	s1,0x1e
    8000240e:	5f648493          	addi	s1,s1,1526 # 80020a00 <bcache+0x18>
    b->next = bcache.head.next;
    80002412:	893e                	mv	s2,a5
    b->prev = &bcache.head;
    80002414:	89ba                	mv	s3,a4
    initsleeplock(&b->lock, "buffer");
    80002416:	00006a17          	auipc	s4,0x6
    8000241a:	12aa0a13          	addi	s4,s4,298 # 80008540 <syscalls+0xc8>
    b->next = bcache.head.next;
    8000241e:	2b893783          	ld	a5,696(s2)
    80002422:	e8bc                	sd	a5,80(s1)
    b->prev = &bcache.head;
    80002424:	0534b423          	sd	s3,72(s1)
    initsleeplock(&b->lock, "buffer");
    80002428:	85d2                	mv	a1,s4
    8000242a:	01048513          	addi	a0,s1,16
    8000242e:	00001097          	auipc	ra,0x1
    80002432:	4c4080e7          	jalr	1220(ra) # 800038f2 <initsleeplock>
    bcache.head.next->prev = b;
    80002436:	2b893783          	ld	a5,696(s2)
    8000243a:	e7a4                	sd	s1,72(a5)
    bcache.head.next = b;
    8000243c:	2a993c23          	sd	s1,696(s2)
  for(b = bcache.buf; b < bcache.buf+NBUF; b++){
    80002440:	45848493          	addi	s1,s1,1112
    80002444:	fd349de3          	bne	s1,s3,8000241e <binit+0x54>
  }
}
    80002448:	70a2                	ld	ra,40(sp)
    8000244a:	7402                	ld	s0,32(sp)
    8000244c:	64e2                	ld	s1,24(sp)
    8000244e:	6942                	ld	s2,16(sp)
    80002450:	69a2                	ld	s3,8(sp)
    80002452:	6a02                	ld	s4,0(sp)
    80002454:	6145                	addi	sp,sp,48
    80002456:	8082                	ret

0000000080002458 <bread>:
}

// Return a locked buf with the contents of the indicated block.
struct buf*
bread(uint dev, uint blockno)
{
    80002458:	7179                	addi	sp,sp,-48
    8000245a:	f406                	sd	ra,40(sp)
    8000245c:	f022                	sd	s0,32(sp)
    8000245e:	ec26                	sd	s1,24(sp)
    80002460:	e84a                	sd	s2,16(sp)
    80002462:	e44e                	sd	s3,8(sp)
    80002464:	1800                	addi	s0,sp,48
    80002466:	89aa                	mv	s3,a0
    80002468:	892e                	mv	s2,a1
  acquire(&bcache.lock);
    8000246a:	0001e517          	auipc	a0,0x1e
    8000246e:	57e50513          	addi	a0,a0,1406 # 800209e8 <bcache>
    80002472:	00004097          	auipc	ra,0x4
    80002476:	1aa080e7          	jalr	426(ra) # 8000661c <acquire>
  for(b = bcache.head.next; b != &bcache.head; b = b->next){
    8000247a:	00027497          	auipc	s1,0x27
    8000247e:	8264b483          	ld	s1,-2010(s1) # 80028ca0 <bcache+0x82b8>
    80002482:	00026797          	auipc	a5,0x26
    80002486:	7ce78793          	addi	a5,a5,1998 # 80028c50 <bcache+0x8268>
    8000248a:	02f48f63          	beq	s1,a5,800024c8 <bread+0x70>
    8000248e:	873e                	mv	a4,a5
    80002490:	a021                	j	80002498 <bread+0x40>
    80002492:	68a4                	ld	s1,80(s1)
    80002494:	02e48a63          	beq	s1,a4,800024c8 <bread+0x70>
    if(b->dev == dev && b->blockno == blockno){
    80002498:	449c                	lw	a5,8(s1)
    8000249a:	ff379ce3          	bne	a5,s3,80002492 <bread+0x3a>
    8000249e:	44dc                	lw	a5,12(s1)
    800024a0:	ff2799e3          	bne	a5,s2,80002492 <bread+0x3a>
      b->refcnt++;
    800024a4:	40bc                	lw	a5,64(s1)
    800024a6:	2785                	addiw	a5,a5,1
    800024a8:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    800024aa:	0001e517          	auipc	a0,0x1e
    800024ae:	53e50513          	addi	a0,a0,1342 # 800209e8 <bcache>
    800024b2:	00004097          	auipc	ra,0x4
    800024b6:	21e080e7          	jalr	542(ra) # 800066d0 <release>
      acquiresleep(&b->lock);
    800024ba:	01048513          	addi	a0,s1,16
    800024be:	00001097          	auipc	ra,0x1
    800024c2:	46e080e7          	jalr	1134(ra) # 8000392c <acquiresleep>
      return b;
    800024c6:	a8b9                	j	80002524 <bread+0xcc>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800024c8:	00026497          	auipc	s1,0x26
    800024cc:	7d04b483          	ld	s1,2000(s1) # 80028c98 <bcache+0x82b0>
    800024d0:	00026797          	auipc	a5,0x26
    800024d4:	78078793          	addi	a5,a5,1920 # 80028c50 <bcache+0x8268>
    800024d8:	00f48863          	beq	s1,a5,800024e8 <bread+0x90>
    800024dc:	873e                	mv	a4,a5
    if(b->refcnt == 0) {
    800024de:	40bc                	lw	a5,64(s1)
    800024e0:	cf81                	beqz	a5,800024f8 <bread+0xa0>
  for(b = bcache.head.prev; b != &bcache.head; b = b->prev){
    800024e2:	64a4                	ld	s1,72(s1)
    800024e4:	fee49de3          	bne	s1,a4,800024de <bread+0x86>
  panic("bget: no buffers");
    800024e8:	00006517          	auipc	a0,0x6
    800024ec:	06050513          	addi	a0,a0,96 # 80008548 <syscalls+0xd0>
    800024f0:	00004097          	auipc	ra,0x4
    800024f4:	be2080e7          	jalr	-1054(ra) # 800060d2 <panic>
      b->dev = dev;
    800024f8:	0134a423          	sw	s3,8(s1)
      b->blockno = blockno;
    800024fc:	0124a623          	sw	s2,12(s1)
      b->valid = 0;
    80002500:	0004a023          	sw	zero,0(s1)
      b->refcnt = 1;
    80002504:	4785                	li	a5,1
    80002506:	c0bc                	sw	a5,64(s1)
      release(&bcache.lock);
    80002508:	0001e517          	auipc	a0,0x1e
    8000250c:	4e050513          	addi	a0,a0,1248 # 800209e8 <bcache>
    80002510:	00004097          	auipc	ra,0x4
    80002514:	1c0080e7          	jalr	448(ra) # 800066d0 <release>
      acquiresleep(&b->lock);
    80002518:	01048513          	addi	a0,s1,16
    8000251c:	00001097          	auipc	ra,0x1
    80002520:	410080e7          	jalr	1040(ra) # 8000392c <acquiresleep>
  struct buf *b;

  b = bget(dev, blockno);
  if(!b->valid) {
    80002524:	409c                	lw	a5,0(s1)
    80002526:	cb89                	beqz	a5,80002538 <bread+0xe0>
    virtio_disk_rw(b, 0);
    b->valid = 1;
  }
  return b;
}
    80002528:	8526                	mv	a0,s1
    8000252a:	70a2                	ld	ra,40(sp)
    8000252c:	7402                	ld	s0,32(sp)
    8000252e:	64e2                	ld	s1,24(sp)
    80002530:	6942                	ld	s2,16(sp)
    80002532:	69a2                	ld	s3,8(sp)
    80002534:	6145                	addi	sp,sp,48
    80002536:	8082                	ret
    virtio_disk_rw(b, 0);
    80002538:	4581                	li	a1,0
    8000253a:	8526                	mv	a0,s1
    8000253c:	00003097          	auipc	ra,0x3
    80002540:	32c080e7          	jalr	812(ra) # 80005868 <virtio_disk_rw>
    b->valid = 1;
    80002544:	4785                	li	a5,1
    80002546:	c09c                	sw	a5,0(s1)
  return b;
    80002548:	b7c5                	j	80002528 <bread+0xd0>

000000008000254a <bwrite>:

// Write b's contents to disk.  Must be locked.
void
bwrite(struct buf *b)
{
    8000254a:	1101                	addi	sp,sp,-32
    8000254c:	ec06                	sd	ra,24(sp)
    8000254e:	e822                	sd	s0,16(sp)
    80002550:	e426                	sd	s1,8(sp)
    80002552:	1000                	addi	s0,sp,32
    80002554:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002556:	0541                	addi	a0,a0,16
    80002558:	00001097          	auipc	ra,0x1
    8000255c:	46e080e7          	jalr	1134(ra) # 800039c6 <holdingsleep>
    80002560:	cd01                	beqz	a0,80002578 <bwrite+0x2e>
    panic("bwrite");
  virtio_disk_rw(b, 1);
    80002562:	4585                	li	a1,1
    80002564:	8526                	mv	a0,s1
    80002566:	00003097          	auipc	ra,0x3
    8000256a:	302080e7          	jalr	770(ra) # 80005868 <virtio_disk_rw>
}
    8000256e:	60e2                	ld	ra,24(sp)
    80002570:	6442                	ld	s0,16(sp)
    80002572:	64a2                	ld	s1,8(sp)
    80002574:	6105                	addi	sp,sp,32
    80002576:	8082                	ret
    panic("bwrite");
    80002578:	00006517          	auipc	a0,0x6
    8000257c:	fe850513          	addi	a0,a0,-24 # 80008560 <syscalls+0xe8>
    80002580:	00004097          	auipc	ra,0x4
    80002584:	b52080e7          	jalr	-1198(ra) # 800060d2 <panic>

0000000080002588 <brelse>:

// Release a locked buffer.
// Move to the head of the most-recently-used list.
void
brelse(struct buf *b)
{
    80002588:	1101                	addi	sp,sp,-32
    8000258a:	ec06                	sd	ra,24(sp)
    8000258c:	e822                	sd	s0,16(sp)
    8000258e:	e426                	sd	s1,8(sp)
    80002590:	e04a                	sd	s2,0(sp)
    80002592:	1000                	addi	s0,sp,32
    80002594:	84aa                	mv	s1,a0
  if(!holdingsleep(&b->lock))
    80002596:	01050913          	addi	s2,a0,16
    8000259a:	854a                	mv	a0,s2
    8000259c:	00001097          	auipc	ra,0x1
    800025a0:	42a080e7          	jalr	1066(ra) # 800039c6 <holdingsleep>
    800025a4:	c92d                	beqz	a0,80002616 <brelse+0x8e>
    panic("brelse");

  releasesleep(&b->lock);
    800025a6:	854a                	mv	a0,s2
    800025a8:	00001097          	auipc	ra,0x1
    800025ac:	3da080e7          	jalr	986(ra) # 80003982 <releasesleep>

  acquire(&bcache.lock);
    800025b0:	0001e517          	auipc	a0,0x1e
    800025b4:	43850513          	addi	a0,a0,1080 # 800209e8 <bcache>
    800025b8:	00004097          	auipc	ra,0x4
    800025bc:	064080e7          	jalr	100(ra) # 8000661c <acquire>
  b->refcnt--;
    800025c0:	40bc                	lw	a5,64(s1)
    800025c2:	37fd                	addiw	a5,a5,-1
    800025c4:	0007871b          	sext.w	a4,a5
    800025c8:	c0bc                	sw	a5,64(s1)
  if (b->refcnt == 0) {
    800025ca:	eb05                	bnez	a4,800025fa <brelse+0x72>
    // no one is waiting for it.
    b->next->prev = b->prev;
    800025cc:	68bc                	ld	a5,80(s1)
    800025ce:	64b8                	ld	a4,72(s1)
    800025d0:	e7b8                	sd	a4,72(a5)
    b->prev->next = b->next;
    800025d2:	64bc                	ld	a5,72(s1)
    800025d4:	68b8                	ld	a4,80(s1)
    800025d6:	ebb8                	sd	a4,80(a5)
    b->next = bcache.head.next;
    800025d8:	00026797          	auipc	a5,0x26
    800025dc:	41078793          	addi	a5,a5,1040 # 800289e8 <bcache+0x8000>
    800025e0:	2b87b703          	ld	a4,696(a5)
    800025e4:	e8b8                	sd	a4,80(s1)
    b->prev = &bcache.head;
    800025e6:	00026717          	auipc	a4,0x26
    800025ea:	66a70713          	addi	a4,a4,1642 # 80028c50 <bcache+0x8268>
    800025ee:	e4b8                	sd	a4,72(s1)
    bcache.head.next->prev = b;
    800025f0:	2b87b703          	ld	a4,696(a5)
    800025f4:	e724                	sd	s1,72(a4)
    bcache.head.next = b;
    800025f6:	2a97bc23          	sd	s1,696(a5)
  }
  
  release(&bcache.lock);
    800025fa:	0001e517          	auipc	a0,0x1e
    800025fe:	3ee50513          	addi	a0,a0,1006 # 800209e8 <bcache>
    80002602:	00004097          	auipc	ra,0x4
    80002606:	0ce080e7          	jalr	206(ra) # 800066d0 <release>
}
    8000260a:	60e2                	ld	ra,24(sp)
    8000260c:	6442                	ld	s0,16(sp)
    8000260e:	64a2                	ld	s1,8(sp)
    80002610:	6902                	ld	s2,0(sp)
    80002612:	6105                	addi	sp,sp,32
    80002614:	8082                	ret
    panic("brelse");
    80002616:	00006517          	auipc	a0,0x6
    8000261a:	f5250513          	addi	a0,a0,-174 # 80008568 <syscalls+0xf0>
    8000261e:	00004097          	auipc	ra,0x4
    80002622:	ab4080e7          	jalr	-1356(ra) # 800060d2 <panic>

0000000080002626 <bpin>:

void
bpin(struct buf *b) {
    80002626:	1101                	addi	sp,sp,-32
    80002628:	ec06                	sd	ra,24(sp)
    8000262a:	e822                	sd	s0,16(sp)
    8000262c:	e426                	sd	s1,8(sp)
    8000262e:	1000                	addi	s0,sp,32
    80002630:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    80002632:	0001e517          	auipc	a0,0x1e
    80002636:	3b650513          	addi	a0,a0,950 # 800209e8 <bcache>
    8000263a:	00004097          	auipc	ra,0x4
    8000263e:	fe2080e7          	jalr	-30(ra) # 8000661c <acquire>
  b->refcnt++;
    80002642:	40bc                	lw	a5,64(s1)
    80002644:	2785                	addiw	a5,a5,1
    80002646:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002648:	0001e517          	auipc	a0,0x1e
    8000264c:	3a050513          	addi	a0,a0,928 # 800209e8 <bcache>
    80002650:	00004097          	auipc	ra,0x4
    80002654:	080080e7          	jalr	128(ra) # 800066d0 <release>
}
    80002658:	60e2                	ld	ra,24(sp)
    8000265a:	6442                	ld	s0,16(sp)
    8000265c:	64a2                	ld	s1,8(sp)
    8000265e:	6105                	addi	sp,sp,32
    80002660:	8082                	ret

0000000080002662 <bunpin>:

void
bunpin(struct buf *b) {
    80002662:	1101                	addi	sp,sp,-32
    80002664:	ec06                	sd	ra,24(sp)
    80002666:	e822                	sd	s0,16(sp)
    80002668:	e426                	sd	s1,8(sp)
    8000266a:	1000                	addi	s0,sp,32
    8000266c:	84aa                	mv	s1,a0
  acquire(&bcache.lock);
    8000266e:	0001e517          	auipc	a0,0x1e
    80002672:	37a50513          	addi	a0,a0,890 # 800209e8 <bcache>
    80002676:	00004097          	auipc	ra,0x4
    8000267a:	fa6080e7          	jalr	-90(ra) # 8000661c <acquire>
  b->refcnt--;
    8000267e:	40bc                	lw	a5,64(s1)
    80002680:	37fd                	addiw	a5,a5,-1
    80002682:	c0bc                	sw	a5,64(s1)
  release(&bcache.lock);
    80002684:	0001e517          	auipc	a0,0x1e
    80002688:	36450513          	addi	a0,a0,868 # 800209e8 <bcache>
    8000268c:	00004097          	auipc	ra,0x4
    80002690:	044080e7          	jalr	68(ra) # 800066d0 <release>
}
    80002694:	60e2                	ld	ra,24(sp)
    80002696:	6442                	ld	s0,16(sp)
    80002698:	64a2                	ld	s1,8(sp)
    8000269a:	6105                	addi	sp,sp,32
    8000269c:	8082                	ret

000000008000269e <bfree>:
}

// Free a disk block.
static void
bfree(int dev, uint b)
{
    8000269e:	1101                	addi	sp,sp,-32
    800026a0:	ec06                	sd	ra,24(sp)
    800026a2:	e822                	sd	s0,16(sp)
    800026a4:	e426                	sd	s1,8(sp)
    800026a6:	e04a                	sd	s2,0(sp)
    800026a8:	1000                	addi	s0,sp,32
    800026aa:	84ae                	mv	s1,a1
    struct buf *bp;
    int bi, m;

    bp = bread(dev, BBLOCK(b, sb));
    800026ac:	00d5d59b          	srliw	a1,a1,0xd
    800026b0:	00027797          	auipc	a5,0x27
    800026b4:	a147a783          	lw	a5,-1516(a5) # 800290c4 <sb+0x1c>
    800026b8:	9dbd                	addw	a1,a1,a5
    800026ba:	00000097          	auipc	ra,0x0
    800026be:	d9e080e7          	jalr	-610(ra) # 80002458 <bread>
    bi = b % BPB;
    m = 1 << (bi % 8);
    800026c2:	0074f713          	andi	a4,s1,7
    800026c6:	4785                	li	a5,1
    800026c8:	00e797bb          	sllw	a5,a5,a4
    if ((bp->data[bi / 8] & m) == 0)
    800026cc:	14ce                	slli	s1,s1,0x33
    800026ce:	90d9                	srli	s1,s1,0x36
    800026d0:	00950733          	add	a4,a0,s1
    800026d4:	05874703          	lbu	a4,88(a4)
    800026d8:	00e7f6b3          	and	a3,a5,a4
    800026dc:	c69d                	beqz	a3,8000270a <bfree+0x6c>
    800026de:	892a                	mv	s2,a0
        panic("freeing free block");
    bp->data[bi / 8] &= ~m;
    800026e0:	94aa                	add	s1,s1,a0
    800026e2:	fff7c793          	not	a5,a5
    800026e6:	8ff9                	and	a5,a5,a4
    800026e8:	04f48c23          	sb	a5,88(s1)
    log_write(bp);
    800026ec:	00001097          	auipc	ra,0x1
    800026f0:	120080e7          	jalr	288(ra) # 8000380c <log_write>
    brelse(bp);
    800026f4:	854a                	mv	a0,s2
    800026f6:	00000097          	auipc	ra,0x0
    800026fa:	e92080e7          	jalr	-366(ra) # 80002588 <brelse>
}
    800026fe:	60e2                	ld	ra,24(sp)
    80002700:	6442                	ld	s0,16(sp)
    80002702:	64a2                	ld	s1,8(sp)
    80002704:	6902                	ld	s2,0(sp)
    80002706:	6105                	addi	sp,sp,32
    80002708:	8082                	ret
        panic("freeing free block");
    8000270a:	00006517          	auipc	a0,0x6
    8000270e:	e6650513          	addi	a0,a0,-410 # 80008570 <syscalls+0xf8>
    80002712:	00004097          	auipc	ra,0x4
    80002716:	9c0080e7          	jalr	-1600(ra) # 800060d2 <panic>

000000008000271a <balloc>:
{
    8000271a:	711d                	addi	sp,sp,-96
    8000271c:	ec86                	sd	ra,88(sp)
    8000271e:	e8a2                	sd	s0,80(sp)
    80002720:	e4a6                	sd	s1,72(sp)
    80002722:	e0ca                	sd	s2,64(sp)
    80002724:	fc4e                	sd	s3,56(sp)
    80002726:	f852                	sd	s4,48(sp)
    80002728:	f456                	sd	s5,40(sp)
    8000272a:	f05a                	sd	s6,32(sp)
    8000272c:	ec5e                	sd	s7,24(sp)
    8000272e:	e862                	sd	s8,16(sp)
    80002730:	e466                	sd	s9,8(sp)
    80002732:	1080                	addi	s0,sp,96
    for (b = 0; b < sb.size; b += BPB)
    80002734:	00027797          	auipc	a5,0x27
    80002738:	9787a783          	lw	a5,-1672(a5) # 800290ac <sb+0x4>
    8000273c:	10078163          	beqz	a5,8000283e <balloc+0x124>
    80002740:	8baa                	mv	s7,a0
    80002742:	4a81                	li	s5,0
        bp = bread(dev, BBLOCK(b, sb));
    80002744:	00027b17          	auipc	s6,0x27
    80002748:	964b0b13          	addi	s6,s6,-1692 # 800290a8 <sb>
        for (bi = 0; bi < BPB && b + bi < sb.size; bi++)
    8000274c:	4c01                	li	s8,0
            m = 1 << (bi % 8);
    8000274e:	4985                	li	s3,1
        for (bi = 0; bi < BPB && b + bi < sb.size; bi++)
    80002750:	6a09                	lui	s4,0x2
    for (b = 0; b < sb.size; b += BPB)
    80002752:	6c89                	lui	s9,0x2
    80002754:	a061                	j	800027dc <balloc+0xc2>
                bp->data[bi / 8] |= m; // Mark block in use.
    80002756:	974a                	add	a4,a4,s2
    80002758:	8fd5                	or	a5,a5,a3
    8000275a:	04f70c23          	sb	a5,88(a4)
                log_write(bp);
    8000275e:	854a                	mv	a0,s2
    80002760:	00001097          	auipc	ra,0x1
    80002764:	0ac080e7          	jalr	172(ra) # 8000380c <log_write>
                brelse(bp);
    80002768:	854a                	mv	a0,s2
    8000276a:	00000097          	auipc	ra,0x0
    8000276e:	e1e080e7          	jalr	-482(ra) # 80002588 <brelse>
    bp = bread(dev, bno);
    80002772:	85a6                	mv	a1,s1
    80002774:	855e                	mv	a0,s7
    80002776:	00000097          	auipc	ra,0x0
    8000277a:	ce2080e7          	jalr	-798(ra) # 80002458 <bread>
    8000277e:	892a                	mv	s2,a0
    memset(bp->data, 0, BSIZE);
    80002780:	40000613          	li	a2,1024
    80002784:	4581                	li	a1,0
    80002786:	05850513          	addi	a0,a0,88
    8000278a:	ffffe097          	auipc	ra,0xffffe
    8000278e:	9ee080e7          	jalr	-1554(ra) # 80000178 <memset>
    log_write(bp);
    80002792:	854a                	mv	a0,s2
    80002794:	00001097          	auipc	ra,0x1
    80002798:	078080e7          	jalr	120(ra) # 8000380c <log_write>
    brelse(bp);
    8000279c:	854a                	mv	a0,s2
    8000279e:	00000097          	auipc	ra,0x0
    800027a2:	dea080e7          	jalr	-534(ra) # 80002588 <brelse>
}
    800027a6:	8526                	mv	a0,s1
    800027a8:	60e6                	ld	ra,88(sp)
    800027aa:	6446                	ld	s0,80(sp)
    800027ac:	64a6                	ld	s1,72(sp)
    800027ae:	6906                	ld	s2,64(sp)
    800027b0:	79e2                	ld	s3,56(sp)
    800027b2:	7a42                	ld	s4,48(sp)
    800027b4:	7aa2                	ld	s5,40(sp)
    800027b6:	7b02                	ld	s6,32(sp)
    800027b8:	6be2                	ld	s7,24(sp)
    800027ba:	6c42                	ld	s8,16(sp)
    800027bc:	6ca2                	ld	s9,8(sp)
    800027be:	6125                	addi	sp,sp,96
    800027c0:	8082                	ret
        brelse(bp);
    800027c2:	854a                	mv	a0,s2
    800027c4:	00000097          	auipc	ra,0x0
    800027c8:	dc4080e7          	jalr	-572(ra) # 80002588 <brelse>
    for (b = 0; b < sb.size; b += BPB)
    800027cc:	015c87bb          	addw	a5,s9,s5
    800027d0:	00078a9b          	sext.w	s5,a5
    800027d4:	004b2703          	lw	a4,4(s6)
    800027d8:	06eaf363          	bgeu	s5,a4,8000283e <balloc+0x124>
        bp = bread(dev, BBLOCK(b, sb));
    800027dc:	41fad79b          	sraiw	a5,s5,0x1f
    800027e0:	0137d79b          	srliw	a5,a5,0x13
    800027e4:	015787bb          	addw	a5,a5,s5
    800027e8:	40d7d79b          	sraiw	a5,a5,0xd
    800027ec:	01cb2583          	lw	a1,28(s6)
    800027f0:	9dbd                	addw	a1,a1,a5
    800027f2:	855e                	mv	a0,s7
    800027f4:	00000097          	auipc	ra,0x0
    800027f8:	c64080e7          	jalr	-924(ra) # 80002458 <bread>
    800027fc:	892a                	mv	s2,a0
        for (bi = 0; bi < BPB && b + bi < sb.size; bi++)
    800027fe:	004b2503          	lw	a0,4(s6)
    80002802:	000a849b          	sext.w	s1,s5
    80002806:	8662                	mv	a2,s8
    80002808:	faa4fde3          	bgeu	s1,a0,800027c2 <balloc+0xa8>
            m = 1 << (bi % 8);
    8000280c:	41f6579b          	sraiw	a5,a2,0x1f
    80002810:	01d7d69b          	srliw	a3,a5,0x1d
    80002814:	00c6873b          	addw	a4,a3,a2
    80002818:	00777793          	andi	a5,a4,7
    8000281c:	9f95                	subw	a5,a5,a3
    8000281e:	00f997bb          	sllw	a5,s3,a5
            if ((bp->data[bi / 8] & m) == 0)
    80002822:	4037571b          	sraiw	a4,a4,0x3
    80002826:	00e906b3          	add	a3,s2,a4
    8000282a:	0586c683          	lbu	a3,88(a3)
    8000282e:	00d7f5b3          	and	a1,a5,a3
    80002832:	d195                	beqz	a1,80002756 <balloc+0x3c>
        for (bi = 0; bi < BPB && b + bi < sb.size; bi++)
    80002834:	2605                	addiw	a2,a2,1
    80002836:	2485                	addiw	s1,s1,1
    80002838:	fd4618e3          	bne	a2,s4,80002808 <balloc+0xee>
    8000283c:	b759                	j	800027c2 <balloc+0xa8>
    printf("balloc: out of blocks\n");
    8000283e:	00006517          	auipc	a0,0x6
    80002842:	d4a50513          	addi	a0,a0,-694 # 80008588 <syscalls+0x110>
    80002846:	00004097          	auipc	ra,0x4
    8000284a:	8d6080e7          	jalr	-1834(ra) # 8000611c <printf>
    return 0;
    8000284e:	4481                	li	s1,0
    80002850:	bf99                	j	800027a6 <balloc+0x8c>

0000000080002852 <bmap>:
// Return the disk block address of the nth block in inode ip.
// If there is no such block, bmap allocates one.
// returns 0 if out of disk space.
static uint
bmap(struct inode *ip, uint bn)
{
    80002852:	7179                	addi	sp,sp,-48
    80002854:	f406                	sd	ra,40(sp)
    80002856:	f022                	sd	s0,32(sp)
    80002858:	ec26                	sd	s1,24(sp)
    8000285a:	e84a                	sd	s2,16(sp)
    8000285c:	e44e                	sd	s3,8(sp)
    8000285e:	e052                	sd	s4,0(sp)
    80002860:	1800                	addi	s0,sp,48
    80002862:	89aa                	mv	s3,a0
    uint addr, *a;
    struct buf *bp;

    if (bn < NDIRECT)
    80002864:	47ad                	li	a5,11
    80002866:	02b7e763          	bltu	a5,a1,80002894 <bmap+0x42>
    {
        if ((addr = ip->addrs[bn]) == 0)
    8000286a:	02059493          	slli	s1,a1,0x20
    8000286e:	9081                	srli	s1,s1,0x20
    80002870:	048a                	slli	s1,s1,0x2
    80002872:	94aa                	add	s1,s1,a0
    80002874:	0504a903          	lw	s2,80(s1)
    80002878:	06091e63          	bnez	s2,800028f4 <bmap+0xa2>
        {
            addr = balloc(ip->dev);
    8000287c:	4108                	lw	a0,0(a0)
    8000287e:	00000097          	auipc	ra,0x0
    80002882:	e9c080e7          	jalr	-356(ra) # 8000271a <balloc>
    80002886:	0005091b          	sext.w	s2,a0
            if (addr == 0)
    8000288a:	06090563          	beqz	s2,800028f4 <bmap+0xa2>
                return 0;
            ip->addrs[bn] = addr;
    8000288e:	0524a823          	sw	s2,80(s1)
    80002892:	a08d                	j	800028f4 <bmap+0xa2>
        }
        return addr;
    }
    bn -= NDIRECT;
    80002894:	ff45849b          	addiw	s1,a1,-12
    80002898:	0004871b          	sext.w	a4,s1

    if (bn < NINDIRECT)
    8000289c:	0ff00793          	li	a5,255
    800028a0:	08e7e563          	bltu	a5,a4,8000292a <bmap+0xd8>
    {
        // Load indirect block, allocating if necessary.
        if ((addr = ip->addrs[NDIRECT]) == 0)
    800028a4:	08052903          	lw	s2,128(a0)
    800028a8:	00091d63          	bnez	s2,800028c2 <bmap+0x70>
        {
            addr = balloc(ip->dev);
    800028ac:	4108                	lw	a0,0(a0)
    800028ae:	00000097          	auipc	ra,0x0
    800028b2:	e6c080e7          	jalr	-404(ra) # 8000271a <balloc>
    800028b6:	0005091b          	sext.w	s2,a0
            if (addr == 0)
    800028ba:	02090d63          	beqz	s2,800028f4 <bmap+0xa2>
                return 0;
            ip->addrs[NDIRECT] = addr;
    800028be:	0929a023          	sw	s2,128(s3)
        }
        bp = bread(ip->dev, addr);
    800028c2:	85ca                	mv	a1,s2
    800028c4:	0009a503          	lw	a0,0(s3)
    800028c8:	00000097          	auipc	ra,0x0
    800028cc:	b90080e7          	jalr	-1136(ra) # 80002458 <bread>
    800028d0:	8a2a                	mv	s4,a0
        a = (uint *)bp->data;
    800028d2:	05850793          	addi	a5,a0,88
        if ((addr = a[bn]) == 0)
    800028d6:	02049593          	slli	a1,s1,0x20
    800028da:	9181                	srli	a1,a1,0x20
    800028dc:	058a                	slli	a1,a1,0x2
    800028de:	00b784b3          	add	s1,a5,a1
    800028e2:	0004a903          	lw	s2,0(s1)
    800028e6:	02090063          	beqz	s2,80002906 <bmap+0xb4>
            {
                a[bn] = addr;
                log_write(bp);
            }
        }
        brelse(bp);
    800028ea:	8552                	mv	a0,s4
    800028ec:	00000097          	auipc	ra,0x0
    800028f0:	c9c080e7          	jalr	-868(ra) # 80002588 <brelse>
        return addr;
    }

    panic("bmap: out of range");
}
    800028f4:	854a                	mv	a0,s2
    800028f6:	70a2                	ld	ra,40(sp)
    800028f8:	7402                	ld	s0,32(sp)
    800028fa:	64e2                	ld	s1,24(sp)
    800028fc:	6942                	ld	s2,16(sp)
    800028fe:	69a2                	ld	s3,8(sp)
    80002900:	6a02                	ld	s4,0(sp)
    80002902:	6145                	addi	sp,sp,48
    80002904:	8082                	ret
            addr = balloc(ip->dev);
    80002906:	0009a503          	lw	a0,0(s3)
    8000290a:	00000097          	auipc	ra,0x0
    8000290e:	e10080e7          	jalr	-496(ra) # 8000271a <balloc>
    80002912:	0005091b          	sext.w	s2,a0
            if (addr)
    80002916:	fc090ae3          	beqz	s2,800028ea <bmap+0x98>
                a[bn] = addr;
    8000291a:	0124a023          	sw	s2,0(s1)
                log_write(bp);
    8000291e:	8552                	mv	a0,s4
    80002920:	00001097          	auipc	ra,0x1
    80002924:	eec080e7          	jalr	-276(ra) # 8000380c <log_write>
    80002928:	b7c9                	j	800028ea <bmap+0x98>
    panic("bmap: out of range");
    8000292a:	00006517          	auipc	a0,0x6
    8000292e:	c7650513          	addi	a0,a0,-906 # 800085a0 <syscalls+0x128>
    80002932:	00003097          	auipc	ra,0x3
    80002936:	7a0080e7          	jalr	1952(ra) # 800060d2 <panic>

000000008000293a <iget>:
{
    8000293a:	7179                	addi	sp,sp,-48
    8000293c:	f406                	sd	ra,40(sp)
    8000293e:	f022                	sd	s0,32(sp)
    80002940:	ec26                	sd	s1,24(sp)
    80002942:	e84a                	sd	s2,16(sp)
    80002944:	e44e                	sd	s3,8(sp)
    80002946:	e052                	sd	s4,0(sp)
    80002948:	1800                	addi	s0,sp,48
    8000294a:	89aa                	mv	s3,a0
    8000294c:	8a2e                	mv	s4,a1
    acquire(&itable.lock);
    8000294e:	00026517          	auipc	a0,0x26
    80002952:	77a50513          	addi	a0,a0,1914 # 800290c8 <itable>
    80002956:	00004097          	auipc	ra,0x4
    8000295a:	cc6080e7          	jalr	-826(ra) # 8000661c <acquire>
    empty = 0;
    8000295e:	4901                	li	s2,0
    for (ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++)
    80002960:	00026497          	auipc	s1,0x26
    80002964:	78048493          	addi	s1,s1,1920 # 800290e0 <itable+0x18>
    80002968:	00028697          	auipc	a3,0x28
    8000296c:	20868693          	addi	a3,a3,520 # 8002ab70 <log>
    80002970:	a039                	j	8000297e <iget+0x44>
        if (empty == 0 && ip->ref == 0) // Remember empty slot.
    80002972:	02090b63          	beqz	s2,800029a8 <iget+0x6e>
    for (ip = &itable.inode[0]; ip < &itable.inode[NINODE]; ip++)
    80002976:	08848493          	addi	s1,s1,136
    8000297a:	02d48a63          	beq	s1,a3,800029ae <iget+0x74>
        if (ip->ref > 0 && ip->dev == dev && ip->inum == inum)
    8000297e:	449c                	lw	a5,8(s1)
    80002980:	fef059e3          	blez	a5,80002972 <iget+0x38>
    80002984:	4098                	lw	a4,0(s1)
    80002986:	ff3716e3          	bne	a4,s3,80002972 <iget+0x38>
    8000298a:	40d8                	lw	a4,4(s1)
    8000298c:	ff4713e3          	bne	a4,s4,80002972 <iget+0x38>
            ip->ref++;
    80002990:	2785                	addiw	a5,a5,1
    80002992:	c49c                	sw	a5,8(s1)
            release(&itable.lock);
    80002994:	00026517          	auipc	a0,0x26
    80002998:	73450513          	addi	a0,a0,1844 # 800290c8 <itable>
    8000299c:	00004097          	auipc	ra,0x4
    800029a0:	d34080e7          	jalr	-716(ra) # 800066d0 <release>
            return ip;
    800029a4:	8926                	mv	s2,s1
    800029a6:	a03d                	j	800029d4 <iget+0x9a>
        if (empty == 0 && ip->ref == 0) // Remember empty slot.
    800029a8:	f7f9                	bnez	a5,80002976 <iget+0x3c>
    800029aa:	8926                	mv	s2,s1
    800029ac:	b7e9                	j	80002976 <iget+0x3c>
    if (empty == 0)
    800029ae:	02090c63          	beqz	s2,800029e6 <iget+0xac>
    ip->dev = dev;
    800029b2:	01392023          	sw	s3,0(s2)
    ip->inum = inum;
    800029b6:	01492223          	sw	s4,4(s2)
    ip->ref = 1;
    800029ba:	4785                	li	a5,1
    800029bc:	00f92423          	sw	a5,8(s2)
    ip->valid = 0;
    800029c0:	04092023          	sw	zero,64(s2)
    release(&itable.lock);
    800029c4:	00026517          	auipc	a0,0x26
    800029c8:	70450513          	addi	a0,a0,1796 # 800290c8 <itable>
    800029cc:	00004097          	auipc	ra,0x4
    800029d0:	d04080e7          	jalr	-764(ra) # 800066d0 <release>
}
    800029d4:	854a                	mv	a0,s2
    800029d6:	70a2                	ld	ra,40(sp)
    800029d8:	7402                	ld	s0,32(sp)
    800029da:	64e2                	ld	s1,24(sp)
    800029dc:	6942                	ld	s2,16(sp)
    800029de:	69a2                	ld	s3,8(sp)
    800029e0:	6a02                	ld	s4,0(sp)
    800029e2:	6145                	addi	sp,sp,48
    800029e4:	8082                	ret
        panic("iget: no inodes");
    800029e6:	00006517          	auipc	a0,0x6
    800029ea:	bd250513          	addi	a0,a0,-1070 # 800085b8 <syscalls+0x140>
    800029ee:	00003097          	auipc	ra,0x3
    800029f2:	6e4080e7          	jalr	1764(ra) # 800060d2 <panic>

00000000800029f6 <fsinit>:
{
    800029f6:	7179                	addi	sp,sp,-48
    800029f8:	f406                	sd	ra,40(sp)
    800029fa:	f022                	sd	s0,32(sp)
    800029fc:	ec26                	sd	s1,24(sp)
    800029fe:	e84a                	sd	s2,16(sp)
    80002a00:	e44e                	sd	s3,8(sp)
    80002a02:	1800                	addi	s0,sp,48
    80002a04:	892a                	mv	s2,a0
    bp = bread(dev, 1);
    80002a06:	4585                	li	a1,1
    80002a08:	00000097          	auipc	ra,0x0
    80002a0c:	a50080e7          	jalr	-1456(ra) # 80002458 <bread>
    80002a10:	84aa                	mv	s1,a0
    memmove(sb, bp->data, sizeof(*sb));
    80002a12:	00026997          	auipc	s3,0x26
    80002a16:	69698993          	addi	s3,s3,1686 # 800290a8 <sb>
    80002a1a:	02000613          	li	a2,32
    80002a1e:	05850593          	addi	a1,a0,88
    80002a22:	854e                	mv	a0,s3
    80002a24:	ffffd097          	auipc	ra,0xffffd
    80002a28:	7b4080e7          	jalr	1972(ra) # 800001d8 <memmove>
    brelse(bp);
    80002a2c:	8526                	mv	a0,s1
    80002a2e:	00000097          	auipc	ra,0x0
    80002a32:	b5a080e7          	jalr	-1190(ra) # 80002588 <brelse>
    if (sb.magic != FSMAGIC)
    80002a36:	0009a703          	lw	a4,0(s3)
    80002a3a:	102037b7          	lui	a5,0x10203
    80002a3e:	04078793          	addi	a5,a5,64 # 10203040 <_entry-0x6fdfcfc0>
    80002a42:	02f71263          	bne	a4,a5,80002a66 <fsinit+0x70>
    initlog(dev, &sb);
    80002a46:	00026597          	auipc	a1,0x26
    80002a4a:	66258593          	addi	a1,a1,1634 # 800290a8 <sb>
    80002a4e:	854a                	mv	a0,s2
    80002a50:	00001097          	auipc	ra,0x1
    80002a54:	b40080e7          	jalr	-1216(ra) # 80003590 <initlog>
}
    80002a58:	70a2                	ld	ra,40(sp)
    80002a5a:	7402                	ld	s0,32(sp)
    80002a5c:	64e2                	ld	s1,24(sp)
    80002a5e:	6942                	ld	s2,16(sp)
    80002a60:	69a2                	ld	s3,8(sp)
    80002a62:	6145                	addi	sp,sp,48
    80002a64:	8082                	ret
        panic("invalid file system");
    80002a66:	00006517          	auipc	a0,0x6
    80002a6a:	b6250513          	addi	a0,a0,-1182 # 800085c8 <syscalls+0x150>
    80002a6e:	00003097          	auipc	ra,0x3
    80002a72:	664080e7          	jalr	1636(ra) # 800060d2 <panic>

0000000080002a76 <iinit>:
{
    80002a76:	7179                	addi	sp,sp,-48
    80002a78:	f406                	sd	ra,40(sp)
    80002a7a:	f022                	sd	s0,32(sp)
    80002a7c:	ec26                	sd	s1,24(sp)
    80002a7e:	e84a                	sd	s2,16(sp)
    80002a80:	e44e                	sd	s3,8(sp)
    80002a82:	1800                	addi	s0,sp,48
    initlock(&itable.lock, "itable");
    80002a84:	00006597          	auipc	a1,0x6
    80002a88:	b5c58593          	addi	a1,a1,-1188 # 800085e0 <syscalls+0x168>
    80002a8c:	00026517          	auipc	a0,0x26
    80002a90:	63c50513          	addi	a0,a0,1596 # 800290c8 <itable>
    80002a94:	00004097          	auipc	ra,0x4
    80002a98:	af8080e7          	jalr	-1288(ra) # 8000658c <initlock>
    for (i = 0; i < NINODE; i++)
    80002a9c:	00026497          	auipc	s1,0x26
    80002aa0:	65448493          	addi	s1,s1,1620 # 800290f0 <itable+0x28>
    80002aa4:	00028997          	auipc	s3,0x28
    80002aa8:	0dc98993          	addi	s3,s3,220 # 8002ab80 <log+0x10>
        initsleeplock(&itable.inode[i].lock, "inode");
    80002aac:	00006917          	auipc	s2,0x6
    80002ab0:	b3c90913          	addi	s2,s2,-1220 # 800085e8 <syscalls+0x170>
    80002ab4:	85ca                	mv	a1,s2
    80002ab6:	8526                	mv	a0,s1
    80002ab8:	00001097          	auipc	ra,0x1
    80002abc:	e3a080e7          	jalr	-454(ra) # 800038f2 <initsleeplock>
    for (i = 0; i < NINODE; i++)
    80002ac0:	08848493          	addi	s1,s1,136
    80002ac4:	ff3498e3          	bne	s1,s3,80002ab4 <iinit+0x3e>
}
    80002ac8:	70a2                	ld	ra,40(sp)
    80002aca:	7402                	ld	s0,32(sp)
    80002acc:	64e2                	ld	s1,24(sp)
    80002ace:	6942                	ld	s2,16(sp)
    80002ad0:	69a2                	ld	s3,8(sp)
    80002ad2:	6145                	addi	sp,sp,48
    80002ad4:	8082                	ret

0000000080002ad6 <ialloc>:
{
    80002ad6:	715d                	addi	sp,sp,-80
    80002ad8:	e486                	sd	ra,72(sp)
    80002ada:	e0a2                	sd	s0,64(sp)
    80002adc:	fc26                	sd	s1,56(sp)
    80002ade:	f84a                	sd	s2,48(sp)
    80002ae0:	f44e                	sd	s3,40(sp)
    80002ae2:	f052                	sd	s4,32(sp)
    80002ae4:	ec56                	sd	s5,24(sp)
    80002ae6:	e85a                	sd	s6,16(sp)
    80002ae8:	e45e                	sd	s7,8(sp)
    80002aea:	0880                	addi	s0,sp,80
    for (inum = 1; inum < sb.ninodes; inum++)
    80002aec:	00026717          	auipc	a4,0x26
    80002af0:	5c872703          	lw	a4,1480(a4) # 800290b4 <sb+0xc>
    80002af4:	4785                	li	a5,1
    80002af6:	04e7fa63          	bgeu	a5,a4,80002b4a <ialloc+0x74>
    80002afa:	8aaa                	mv	s5,a0
    80002afc:	8bae                	mv	s7,a1
    80002afe:	4485                	li	s1,1
        bp = bread(dev, IBLOCK(inum, sb));
    80002b00:	00026a17          	auipc	s4,0x26
    80002b04:	5a8a0a13          	addi	s4,s4,1448 # 800290a8 <sb>
    80002b08:	00048b1b          	sext.w	s6,s1
    80002b0c:	0044d593          	srli	a1,s1,0x4
    80002b10:	018a2783          	lw	a5,24(s4)
    80002b14:	9dbd                	addw	a1,a1,a5
    80002b16:	8556                	mv	a0,s5
    80002b18:	00000097          	auipc	ra,0x0
    80002b1c:	940080e7          	jalr	-1728(ra) # 80002458 <bread>
    80002b20:	892a                	mv	s2,a0
        dip = (struct dinode *)bp->data + inum % IPB;
    80002b22:	05850993          	addi	s3,a0,88
    80002b26:	00f4f793          	andi	a5,s1,15
    80002b2a:	079a                	slli	a5,a5,0x6
    80002b2c:	99be                	add	s3,s3,a5
        if (dip->type == 0)
    80002b2e:	00099783          	lh	a5,0(s3)
    80002b32:	c3a1                	beqz	a5,80002b72 <ialloc+0x9c>
        brelse(bp);
    80002b34:	00000097          	auipc	ra,0x0
    80002b38:	a54080e7          	jalr	-1452(ra) # 80002588 <brelse>
    for (inum = 1; inum < sb.ninodes; inum++)
    80002b3c:	0485                	addi	s1,s1,1
    80002b3e:	00ca2703          	lw	a4,12(s4)
    80002b42:	0004879b          	sext.w	a5,s1
    80002b46:	fce7e1e3          	bltu	a5,a4,80002b08 <ialloc+0x32>
    printf("ialloc: no inodes\n");
    80002b4a:	00006517          	auipc	a0,0x6
    80002b4e:	aa650513          	addi	a0,a0,-1370 # 800085f0 <syscalls+0x178>
    80002b52:	00003097          	auipc	ra,0x3
    80002b56:	5ca080e7          	jalr	1482(ra) # 8000611c <printf>
    return 0;
    80002b5a:	4501                	li	a0,0
}
    80002b5c:	60a6                	ld	ra,72(sp)
    80002b5e:	6406                	ld	s0,64(sp)
    80002b60:	74e2                	ld	s1,56(sp)
    80002b62:	7942                	ld	s2,48(sp)
    80002b64:	79a2                	ld	s3,40(sp)
    80002b66:	7a02                	ld	s4,32(sp)
    80002b68:	6ae2                	ld	s5,24(sp)
    80002b6a:	6b42                	ld	s6,16(sp)
    80002b6c:	6ba2                	ld	s7,8(sp)
    80002b6e:	6161                	addi	sp,sp,80
    80002b70:	8082                	ret
            memset(dip, 0, sizeof(*dip));
    80002b72:	04000613          	li	a2,64
    80002b76:	4581                	li	a1,0
    80002b78:	854e                	mv	a0,s3
    80002b7a:	ffffd097          	auipc	ra,0xffffd
    80002b7e:	5fe080e7          	jalr	1534(ra) # 80000178 <memset>
            dip->type = type;
    80002b82:	01799023          	sh	s7,0(s3)
            log_write(bp); // mark it allocated on the disk
    80002b86:	854a                	mv	a0,s2
    80002b88:	00001097          	auipc	ra,0x1
    80002b8c:	c84080e7          	jalr	-892(ra) # 8000380c <log_write>
            brelse(bp);
    80002b90:	854a                	mv	a0,s2
    80002b92:	00000097          	auipc	ra,0x0
    80002b96:	9f6080e7          	jalr	-1546(ra) # 80002588 <brelse>
            return iget(dev, inum);
    80002b9a:	85da                	mv	a1,s6
    80002b9c:	8556                	mv	a0,s5
    80002b9e:	00000097          	auipc	ra,0x0
    80002ba2:	d9c080e7          	jalr	-612(ra) # 8000293a <iget>
    80002ba6:	bf5d                	j	80002b5c <ialloc+0x86>

0000000080002ba8 <iupdate>:
{
    80002ba8:	1101                	addi	sp,sp,-32
    80002baa:	ec06                	sd	ra,24(sp)
    80002bac:	e822                	sd	s0,16(sp)
    80002bae:	e426                	sd	s1,8(sp)
    80002bb0:	e04a                	sd	s2,0(sp)
    80002bb2:	1000                	addi	s0,sp,32
    80002bb4:	84aa                	mv	s1,a0
    bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002bb6:	415c                	lw	a5,4(a0)
    80002bb8:	0047d79b          	srliw	a5,a5,0x4
    80002bbc:	00026597          	auipc	a1,0x26
    80002bc0:	5045a583          	lw	a1,1284(a1) # 800290c0 <sb+0x18>
    80002bc4:	9dbd                	addw	a1,a1,a5
    80002bc6:	4108                	lw	a0,0(a0)
    80002bc8:	00000097          	auipc	ra,0x0
    80002bcc:	890080e7          	jalr	-1904(ra) # 80002458 <bread>
    80002bd0:	892a                	mv	s2,a0
    dip = (struct dinode *)bp->data + ip->inum % IPB;
    80002bd2:	05850793          	addi	a5,a0,88
    80002bd6:	40c8                	lw	a0,4(s1)
    80002bd8:	893d                	andi	a0,a0,15
    80002bda:	051a                	slli	a0,a0,0x6
    80002bdc:	953e                	add	a0,a0,a5
    dip->type = ip->type;
    80002bde:	04449703          	lh	a4,68(s1)
    80002be2:	00e51023          	sh	a4,0(a0)
    dip->major = ip->major;
    80002be6:	04649703          	lh	a4,70(s1)
    80002bea:	00e51123          	sh	a4,2(a0)
    dip->minor = ip->minor;
    80002bee:	04849703          	lh	a4,72(s1)
    80002bf2:	00e51223          	sh	a4,4(a0)
    dip->nlink = ip->nlink;
    80002bf6:	04a49703          	lh	a4,74(s1)
    80002bfa:	00e51323          	sh	a4,6(a0)
    dip->size = ip->size;
    80002bfe:	44f8                	lw	a4,76(s1)
    80002c00:	c518                	sw	a4,8(a0)
    memmove(dip->addrs, ip->addrs, sizeof(ip->addrs));
    80002c02:	03400613          	li	a2,52
    80002c06:	05048593          	addi	a1,s1,80
    80002c0a:	0531                	addi	a0,a0,12
    80002c0c:	ffffd097          	auipc	ra,0xffffd
    80002c10:	5cc080e7          	jalr	1484(ra) # 800001d8 <memmove>
    log_write(bp);
    80002c14:	854a                	mv	a0,s2
    80002c16:	00001097          	auipc	ra,0x1
    80002c1a:	bf6080e7          	jalr	-1034(ra) # 8000380c <log_write>
    brelse(bp);
    80002c1e:	854a                	mv	a0,s2
    80002c20:	00000097          	auipc	ra,0x0
    80002c24:	968080e7          	jalr	-1688(ra) # 80002588 <brelse>
}
    80002c28:	60e2                	ld	ra,24(sp)
    80002c2a:	6442                	ld	s0,16(sp)
    80002c2c:	64a2                	ld	s1,8(sp)
    80002c2e:	6902                	ld	s2,0(sp)
    80002c30:	6105                	addi	sp,sp,32
    80002c32:	8082                	ret

0000000080002c34 <idup>:
{
    80002c34:	1101                	addi	sp,sp,-32
    80002c36:	ec06                	sd	ra,24(sp)
    80002c38:	e822                	sd	s0,16(sp)
    80002c3a:	e426                	sd	s1,8(sp)
    80002c3c:	1000                	addi	s0,sp,32
    80002c3e:	84aa                	mv	s1,a0
    acquire(&itable.lock);
    80002c40:	00026517          	auipc	a0,0x26
    80002c44:	48850513          	addi	a0,a0,1160 # 800290c8 <itable>
    80002c48:	00004097          	auipc	ra,0x4
    80002c4c:	9d4080e7          	jalr	-1580(ra) # 8000661c <acquire>
    ip->ref++;
    80002c50:	449c                	lw	a5,8(s1)
    80002c52:	2785                	addiw	a5,a5,1
    80002c54:	c49c                	sw	a5,8(s1)
    release(&itable.lock);
    80002c56:	00026517          	auipc	a0,0x26
    80002c5a:	47250513          	addi	a0,a0,1138 # 800290c8 <itable>
    80002c5e:	00004097          	auipc	ra,0x4
    80002c62:	a72080e7          	jalr	-1422(ra) # 800066d0 <release>
}
    80002c66:	8526                	mv	a0,s1
    80002c68:	60e2                	ld	ra,24(sp)
    80002c6a:	6442                	ld	s0,16(sp)
    80002c6c:	64a2                	ld	s1,8(sp)
    80002c6e:	6105                	addi	sp,sp,32
    80002c70:	8082                	ret

0000000080002c72 <ilock>:
{
    80002c72:	1101                	addi	sp,sp,-32
    80002c74:	ec06                	sd	ra,24(sp)
    80002c76:	e822                	sd	s0,16(sp)
    80002c78:	e426                	sd	s1,8(sp)
    80002c7a:	e04a                	sd	s2,0(sp)
    80002c7c:	1000                	addi	s0,sp,32
    if (ip == 0 || ip->ref < 1)
    80002c7e:	c115                	beqz	a0,80002ca2 <ilock+0x30>
    80002c80:	84aa                	mv	s1,a0
    80002c82:	451c                	lw	a5,8(a0)
    80002c84:	00f05f63          	blez	a5,80002ca2 <ilock+0x30>
    acquiresleep(&ip->lock);
    80002c88:	0541                	addi	a0,a0,16
    80002c8a:	00001097          	auipc	ra,0x1
    80002c8e:	ca2080e7          	jalr	-862(ra) # 8000392c <acquiresleep>
    if (ip->valid == 0)
    80002c92:	40bc                	lw	a5,64(s1)
    80002c94:	cf99                	beqz	a5,80002cb2 <ilock+0x40>
}
    80002c96:	60e2                	ld	ra,24(sp)
    80002c98:	6442                	ld	s0,16(sp)
    80002c9a:	64a2                	ld	s1,8(sp)
    80002c9c:	6902                	ld	s2,0(sp)
    80002c9e:	6105                	addi	sp,sp,32
    80002ca0:	8082                	ret
        panic("ilock");
    80002ca2:	00006517          	auipc	a0,0x6
    80002ca6:	96650513          	addi	a0,a0,-1690 # 80008608 <syscalls+0x190>
    80002caa:	00003097          	auipc	ra,0x3
    80002cae:	428080e7          	jalr	1064(ra) # 800060d2 <panic>
        bp = bread(ip->dev, IBLOCK(ip->inum, sb));
    80002cb2:	40dc                	lw	a5,4(s1)
    80002cb4:	0047d79b          	srliw	a5,a5,0x4
    80002cb8:	00026597          	auipc	a1,0x26
    80002cbc:	4085a583          	lw	a1,1032(a1) # 800290c0 <sb+0x18>
    80002cc0:	9dbd                	addw	a1,a1,a5
    80002cc2:	4088                	lw	a0,0(s1)
    80002cc4:	fffff097          	auipc	ra,0xfffff
    80002cc8:	794080e7          	jalr	1940(ra) # 80002458 <bread>
    80002ccc:	892a                	mv	s2,a0
        dip = (struct dinode *)bp->data + ip->inum % IPB;
    80002cce:	05850593          	addi	a1,a0,88
    80002cd2:	40dc                	lw	a5,4(s1)
    80002cd4:	8bbd                	andi	a5,a5,15
    80002cd6:	079a                	slli	a5,a5,0x6
    80002cd8:	95be                	add	a1,a1,a5
        ip->type = dip->type;
    80002cda:	00059783          	lh	a5,0(a1)
    80002cde:	04f49223          	sh	a5,68(s1)
        ip->major = dip->major;
    80002ce2:	00259783          	lh	a5,2(a1)
    80002ce6:	04f49323          	sh	a5,70(s1)
        ip->minor = dip->minor;
    80002cea:	00459783          	lh	a5,4(a1)
    80002cee:	04f49423          	sh	a5,72(s1)
        ip->nlink = dip->nlink;
    80002cf2:	00659783          	lh	a5,6(a1)
    80002cf6:	04f49523          	sh	a5,74(s1)
        ip->size = dip->size;
    80002cfa:	459c                	lw	a5,8(a1)
    80002cfc:	c4fc                	sw	a5,76(s1)
        memmove(ip->addrs, dip->addrs, sizeof(ip->addrs));
    80002cfe:	03400613          	li	a2,52
    80002d02:	05b1                	addi	a1,a1,12
    80002d04:	05048513          	addi	a0,s1,80
    80002d08:	ffffd097          	auipc	ra,0xffffd
    80002d0c:	4d0080e7          	jalr	1232(ra) # 800001d8 <memmove>
        brelse(bp);
    80002d10:	854a                	mv	a0,s2
    80002d12:	00000097          	auipc	ra,0x0
    80002d16:	876080e7          	jalr	-1930(ra) # 80002588 <brelse>
        ip->valid = 1;
    80002d1a:	4785                	li	a5,1
    80002d1c:	c0bc                	sw	a5,64(s1)
        if (ip->type == 0)
    80002d1e:	04449783          	lh	a5,68(s1)
    80002d22:	fbb5                	bnez	a5,80002c96 <ilock+0x24>
            panic("ilock: no type");
    80002d24:	00006517          	auipc	a0,0x6
    80002d28:	8ec50513          	addi	a0,a0,-1812 # 80008610 <syscalls+0x198>
    80002d2c:	00003097          	auipc	ra,0x3
    80002d30:	3a6080e7          	jalr	934(ra) # 800060d2 <panic>

0000000080002d34 <iunlock>:
{
    80002d34:	1101                	addi	sp,sp,-32
    80002d36:	ec06                	sd	ra,24(sp)
    80002d38:	e822                	sd	s0,16(sp)
    80002d3a:	e426                	sd	s1,8(sp)
    80002d3c:	e04a                	sd	s2,0(sp)
    80002d3e:	1000                	addi	s0,sp,32
    if (ip == 0 || !holdingsleep(&ip->lock) || ip->ref < 1)
    80002d40:	c905                	beqz	a0,80002d70 <iunlock+0x3c>
    80002d42:	84aa                	mv	s1,a0
    80002d44:	01050913          	addi	s2,a0,16
    80002d48:	854a                	mv	a0,s2
    80002d4a:	00001097          	auipc	ra,0x1
    80002d4e:	c7c080e7          	jalr	-900(ra) # 800039c6 <holdingsleep>
    80002d52:	cd19                	beqz	a0,80002d70 <iunlock+0x3c>
    80002d54:	449c                	lw	a5,8(s1)
    80002d56:	00f05d63          	blez	a5,80002d70 <iunlock+0x3c>
    releasesleep(&ip->lock);
    80002d5a:	854a                	mv	a0,s2
    80002d5c:	00001097          	auipc	ra,0x1
    80002d60:	c26080e7          	jalr	-986(ra) # 80003982 <releasesleep>
}
    80002d64:	60e2                	ld	ra,24(sp)
    80002d66:	6442                	ld	s0,16(sp)
    80002d68:	64a2                	ld	s1,8(sp)
    80002d6a:	6902                	ld	s2,0(sp)
    80002d6c:	6105                	addi	sp,sp,32
    80002d6e:	8082                	ret
        panic("iunlock");
    80002d70:	00006517          	auipc	a0,0x6
    80002d74:	8b050513          	addi	a0,a0,-1872 # 80008620 <syscalls+0x1a8>
    80002d78:	00003097          	auipc	ra,0x3
    80002d7c:	35a080e7          	jalr	858(ra) # 800060d2 <panic>

0000000080002d80 <itrunc>:

// Truncate inode (discard contents).
// Caller must hold ip->lock.
void itrunc(struct inode *ip)
{
    80002d80:	7179                	addi	sp,sp,-48
    80002d82:	f406                	sd	ra,40(sp)
    80002d84:	f022                	sd	s0,32(sp)
    80002d86:	ec26                	sd	s1,24(sp)
    80002d88:	e84a                	sd	s2,16(sp)
    80002d8a:	e44e                	sd	s3,8(sp)
    80002d8c:	e052                	sd	s4,0(sp)
    80002d8e:	1800                	addi	s0,sp,48
    80002d90:	89aa                	mv	s3,a0
    int i, j;
    struct buf *bp;
    uint *a;

    for (i = 0; i < NDIRECT; i++)
    80002d92:	05050493          	addi	s1,a0,80
    80002d96:	08050913          	addi	s2,a0,128
    80002d9a:	a021                	j	80002da2 <itrunc+0x22>
    80002d9c:	0491                	addi	s1,s1,4
    80002d9e:	01248d63          	beq	s1,s2,80002db8 <itrunc+0x38>
    {
        if (ip->addrs[i])
    80002da2:	408c                	lw	a1,0(s1)
    80002da4:	dde5                	beqz	a1,80002d9c <itrunc+0x1c>
        {
            bfree(ip->dev, ip->addrs[i]);
    80002da6:	0009a503          	lw	a0,0(s3)
    80002daa:	00000097          	auipc	ra,0x0
    80002dae:	8f4080e7          	jalr	-1804(ra) # 8000269e <bfree>
            ip->addrs[i] = 0;
    80002db2:	0004a023          	sw	zero,0(s1)
    80002db6:	b7dd                	j	80002d9c <itrunc+0x1c>
        }
    }

    if (ip->addrs[NDIRECT])
    80002db8:	0809a583          	lw	a1,128(s3)
    80002dbc:	e185                	bnez	a1,80002ddc <itrunc+0x5c>
        brelse(bp);
        bfree(ip->dev, ip->addrs[NDIRECT]);
        ip->addrs[NDIRECT] = 0;
    }

    ip->size = 0;
    80002dbe:	0409a623          	sw	zero,76(s3)
    iupdate(ip);
    80002dc2:	854e                	mv	a0,s3
    80002dc4:	00000097          	auipc	ra,0x0
    80002dc8:	de4080e7          	jalr	-540(ra) # 80002ba8 <iupdate>
}
    80002dcc:	70a2                	ld	ra,40(sp)
    80002dce:	7402                	ld	s0,32(sp)
    80002dd0:	64e2                	ld	s1,24(sp)
    80002dd2:	6942                	ld	s2,16(sp)
    80002dd4:	69a2                	ld	s3,8(sp)
    80002dd6:	6a02                	ld	s4,0(sp)
    80002dd8:	6145                	addi	sp,sp,48
    80002dda:	8082                	ret
        bp = bread(ip->dev, ip->addrs[NDIRECT]);
    80002ddc:	0009a503          	lw	a0,0(s3)
    80002de0:	fffff097          	auipc	ra,0xfffff
    80002de4:	678080e7          	jalr	1656(ra) # 80002458 <bread>
    80002de8:	8a2a                	mv	s4,a0
        for (j = 0; j < NINDIRECT; j++)
    80002dea:	05850493          	addi	s1,a0,88
    80002dee:	45850913          	addi	s2,a0,1112
    80002df2:	a811                	j	80002e06 <itrunc+0x86>
                bfree(ip->dev, a[j]);
    80002df4:	0009a503          	lw	a0,0(s3)
    80002df8:	00000097          	auipc	ra,0x0
    80002dfc:	8a6080e7          	jalr	-1882(ra) # 8000269e <bfree>
        for (j = 0; j < NINDIRECT; j++)
    80002e00:	0491                	addi	s1,s1,4
    80002e02:	01248563          	beq	s1,s2,80002e0c <itrunc+0x8c>
            if (a[j])
    80002e06:	408c                	lw	a1,0(s1)
    80002e08:	dde5                	beqz	a1,80002e00 <itrunc+0x80>
    80002e0a:	b7ed                	j	80002df4 <itrunc+0x74>
        brelse(bp);
    80002e0c:	8552                	mv	a0,s4
    80002e0e:	fffff097          	auipc	ra,0xfffff
    80002e12:	77a080e7          	jalr	1914(ra) # 80002588 <brelse>
        bfree(ip->dev, ip->addrs[NDIRECT]);
    80002e16:	0809a583          	lw	a1,128(s3)
    80002e1a:	0009a503          	lw	a0,0(s3)
    80002e1e:	00000097          	auipc	ra,0x0
    80002e22:	880080e7          	jalr	-1920(ra) # 8000269e <bfree>
        ip->addrs[NDIRECT] = 0;
    80002e26:	0809a023          	sw	zero,128(s3)
    80002e2a:	bf51                	j	80002dbe <itrunc+0x3e>

0000000080002e2c <iput>:
{
    80002e2c:	1101                	addi	sp,sp,-32
    80002e2e:	ec06                	sd	ra,24(sp)
    80002e30:	e822                	sd	s0,16(sp)
    80002e32:	e426                	sd	s1,8(sp)
    80002e34:	e04a                	sd	s2,0(sp)
    80002e36:	1000                	addi	s0,sp,32
    80002e38:	84aa                	mv	s1,a0
    acquire(&itable.lock);
    80002e3a:	00026517          	auipc	a0,0x26
    80002e3e:	28e50513          	addi	a0,a0,654 # 800290c8 <itable>
    80002e42:	00003097          	auipc	ra,0x3
    80002e46:	7da080e7          	jalr	2010(ra) # 8000661c <acquire>
    if (ip->ref == 1 && ip->valid && ip->nlink == 0)
    80002e4a:	4498                	lw	a4,8(s1)
    80002e4c:	4785                	li	a5,1
    80002e4e:	02f70363          	beq	a4,a5,80002e74 <iput+0x48>
    ip->ref--;
    80002e52:	449c                	lw	a5,8(s1)
    80002e54:	37fd                	addiw	a5,a5,-1
    80002e56:	c49c                	sw	a5,8(s1)
    release(&itable.lock);
    80002e58:	00026517          	auipc	a0,0x26
    80002e5c:	27050513          	addi	a0,a0,624 # 800290c8 <itable>
    80002e60:	00004097          	auipc	ra,0x4
    80002e64:	870080e7          	jalr	-1936(ra) # 800066d0 <release>
}
    80002e68:	60e2                	ld	ra,24(sp)
    80002e6a:	6442                	ld	s0,16(sp)
    80002e6c:	64a2                	ld	s1,8(sp)
    80002e6e:	6902                	ld	s2,0(sp)
    80002e70:	6105                	addi	sp,sp,32
    80002e72:	8082                	ret
    if (ip->ref == 1 && ip->valid && ip->nlink == 0)
    80002e74:	40bc                	lw	a5,64(s1)
    80002e76:	dff1                	beqz	a5,80002e52 <iput+0x26>
    80002e78:	04a49783          	lh	a5,74(s1)
    80002e7c:	fbf9                	bnez	a5,80002e52 <iput+0x26>
        acquiresleep(&ip->lock);
    80002e7e:	01048913          	addi	s2,s1,16
    80002e82:	854a                	mv	a0,s2
    80002e84:	00001097          	auipc	ra,0x1
    80002e88:	aa8080e7          	jalr	-1368(ra) # 8000392c <acquiresleep>
        release(&itable.lock);
    80002e8c:	00026517          	auipc	a0,0x26
    80002e90:	23c50513          	addi	a0,a0,572 # 800290c8 <itable>
    80002e94:	00004097          	auipc	ra,0x4
    80002e98:	83c080e7          	jalr	-1988(ra) # 800066d0 <release>
        itrunc(ip);
    80002e9c:	8526                	mv	a0,s1
    80002e9e:	00000097          	auipc	ra,0x0
    80002ea2:	ee2080e7          	jalr	-286(ra) # 80002d80 <itrunc>
        ip->type = 0;
    80002ea6:	04049223          	sh	zero,68(s1)
        iupdate(ip);
    80002eaa:	8526                	mv	a0,s1
    80002eac:	00000097          	auipc	ra,0x0
    80002eb0:	cfc080e7          	jalr	-772(ra) # 80002ba8 <iupdate>
        ip->valid = 0;
    80002eb4:	0404a023          	sw	zero,64(s1)
        releasesleep(&ip->lock);
    80002eb8:	854a                	mv	a0,s2
    80002eba:	00001097          	auipc	ra,0x1
    80002ebe:	ac8080e7          	jalr	-1336(ra) # 80003982 <releasesleep>
        acquire(&itable.lock);
    80002ec2:	00026517          	auipc	a0,0x26
    80002ec6:	20650513          	addi	a0,a0,518 # 800290c8 <itable>
    80002eca:	00003097          	auipc	ra,0x3
    80002ece:	752080e7          	jalr	1874(ra) # 8000661c <acquire>
    80002ed2:	b741                	j	80002e52 <iput+0x26>

0000000080002ed4 <iunlockput>:
{
    80002ed4:	1101                	addi	sp,sp,-32
    80002ed6:	ec06                	sd	ra,24(sp)
    80002ed8:	e822                	sd	s0,16(sp)
    80002eda:	e426                	sd	s1,8(sp)
    80002edc:	1000                	addi	s0,sp,32
    80002ede:	84aa                	mv	s1,a0
    iunlock(ip);
    80002ee0:	00000097          	auipc	ra,0x0
    80002ee4:	e54080e7          	jalr	-428(ra) # 80002d34 <iunlock>
    iput(ip);
    80002ee8:	8526                	mv	a0,s1
    80002eea:	00000097          	auipc	ra,0x0
    80002eee:	f42080e7          	jalr	-190(ra) # 80002e2c <iput>
}
    80002ef2:	60e2                	ld	ra,24(sp)
    80002ef4:	6442                	ld	s0,16(sp)
    80002ef6:	64a2                	ld	s1,8(sp)
    80002ef8:	6105                	addi	sp,sp,32
    80002efa:	8082                	ret

0000000080002efc <stati>:

// Copy stat information from inode.
// Caller must hold ip->lock.
void stati(struct inode *ip, struct stat *st)
{
    80002efc:	1141                	addi	sp,sp,-16
    80002efe:	e422                	sd	s0,8(sp)
    80002f00:	0800                	addi	s0,sp,16
    st->dev = ip->dev;
    80002f02:	411c                	lw	a5,0(a0)
    80002f04:	c19c                	sw	a5,0(a1)
    st->ino = ip->inum;
    80002f06:	415c                	lw	a5,4(a0)
    80002f08:	c1dc                	sw	a5,4(a1)
    st->type = ip->type;
    80002f0a:	04451783          	lh	a5,68(a0)
    80002f0e:	00f59423          	sh	a5,8(a1)
    st->nlink = ip->nlink;
    80002f12:	04a51783          	lh	a5,74(a0)
    80002f16:	00f59523          	sh	a5,10(a1)
    st->size = ip->size;
    80002f1a:	04c56783          	lwu	a5,76(a0)
    80002f1e:	e99c                	sd	a5,16(a1)
}
    80002f20:	6422                	ld	s0,8(sp)
    80002f22:	0141                	addi	sp,sp,16
    80002f24:	8082                	ret

0000000080002f26 <readi>:
int readi(struct inode *ip, int user_dst, uint64 dst, uint off, uint n)
{
    uint tot, m;
    struct buf *bp;

    if (off > ip->size || off + n < off)
    80002f26:	457c                	lw	a5,76(a0)
    80002f28:	0ed7e963          	bltu	a5,a3,8000301a <readi+0xf4>
{
    80002f2c:	7159                	addi	sp,sp,-112
    80002f2e:	f486                	sd	ra,104(sp)
    80002f30:	f0a2                	sd	s0,96(sp)
    80002f32:	eca6                	sd	s1,88(sp)
    80002f34:	e8ca                	sd	s2,80(sp)
    80002f36:	e4ce                	sd	s3,72(sp)
    80002f38:	e0d2                	sd	s4,64(sp)
    80002f3a:	fc56                	sd	s5,56(sp)
    80002f3c:	f85a                	sd	s6,48(sp)
    80002f3e:	f45e                	sd	s7,40(sp)
    80002f40:	f062                	sd	s8,32(sp)
    80002f42:	ec66                	sd	s9,24(sp)
    80002f44:	e86a                	sd	s10,16(sp)
    80002f46:	e46e                	sd	s11,8(sp)
    80002f48:	1880                	addi	s0,sp,112
    80002f4a:	8b2a                	mv	s6,a0
    80002f4c:	8bae                	mv	s7,a1
    80002f4e:	8a32                	mv	s4,a2
    80002f50:	84b6                	mv	s1,a3
    80002f52:	8aba                	mv	s5,a4
    if (off > ip->size || off + n < off)
    80002f54:	9f35                	addw	a4,a4,a3
        return 0;
    80002f56:	4501                	li	a0,0
    if (off > ip->size || off + n < off)
    80002f58:	0ad76063          	bltu	a4,a3,80002ff8 <readi+0xd2>
    if (off + n > ip->size)
    80002f5c:	00e7f463          	bgeu	a5,a4,80002f64 <readi+0x3e>
        n = ip->size - off;
    80002f60:	40d78abb          	subw	s5,a5,a3

    for (tot = 0; tot < n; tot += m, off += m, dst += m)
    80002f64:	0a0a8963          	beqz	s5,80003016 <readi+0xf0>
    80002f68:	4981                	li	s3,0
    {
        uint addr = bmap(ip, off / BSIZE);
        if (addr == 0)
            break;
        bp = bread(ip->dev, addr);
        m = min(n - tot, BSIZE - off % BSIZE);
    80002f6a:	40000c93          	li	s9,1024
        if (either_copyout(user_dst, dst, bp->data + (off % BSIZE), m) == -1)
    80002f6e:	5c7d                	li	s8,-1
    80002f70:	a82d                	j	80002faa <readi+0x84>
    80002f72:	020d1d93          	slli	s11,s10,0x20
    80002f76:	020ddd93          	srli	s11,s11,0x20
    80002f7a:	05890613          	addi	a2,s2,88
    80002f7e:	86ee                	mv	a3,s11
    80002f80:	963a                	add	a2,a2,a4
    80002f82:	85d2                	mv	a1,s4
    80002f84:	855e                	mv	a0,s7
    80002f86:	fffff097          	auipc	ra,0xfffff
    80002f8a:	9c8080e7          	jalr	-1592(ra) # 8000194e <either_copyout>
    80002f8e:	05850d63          	beq	a0,s8,80002fe8 <readi+0xc2>
        {
            brelse(bp);
            tot = -1;
            break;
        }
        brelse(bp);
    80002f92:	854a                	mv	a0,s2
    80002f94:	fffff097          	auipc	ra,0xfffff
    80002f98:	5f4080e7          	jalr	1524(ra) # 80002588 <brelse>
    for (tot = 0; tot < n; tot += m, off += m, dst += m)
    80002f9c:	013d09bb          	addw	s3,s10,s3
    80002fa0:	009d04bb          	addw	s1,s10,s1
    80002fa4:	9a6e                	add	s4,s4,s11
    80002fa6:	0559f763          	bgeu	s3,s5,80002ff4 <readi+0xce>
        uint addr = bmap(ip, off / BSIZE);
    80002faa:	00a4d59b          	srliw	a1,s1,0xa
    80002fae:	855a                	mv	a0,s6
    80002fb0:	00000097          	auipc	ra,0x0
    80002fb4:	8a2080e7          	jalr	-1886(ra) # 80002852 <bmap>
    80002fb8:	0005059b          	sext.w	a1,a0
        if (addr == 0)
    80002fbc:	cd85                	beqz	a1,80002ff4 <readi+0xce>
        bp = bread(ip->dev, addr);
    80002fbe:	000b2503          	lw	a0,0(s6)
    80002fc2:	fffff097          	auipc	ra,0xfffff
    80002fc6:	496080e7          	jalr	1174(ra) # 80002458 <bread>
    80002fca:	892a                	mv	s2,a0
        m = min(n - tot, BSIZE - off % BSIZE);
    80002fcc:	3ff4f713          	andi	a4,s1,1023
    80002fd0:	40ec87bb          	subw	a5,s9,a4
    80002fd4:	413a86bb          	subw	a3,s5,s3
    80002fd8:	8d3e                	mv	s10,a5
    80002fda:	2781                	sext.w	a5,a5
    80002fdc:	0006861b          	sext.w	a2,a3
    80002fe0:	f8f679e3          	bgeu	a2,a5,80002f72 <readi+0x4c>
    80002fe4:	8d36                	mv	s10,a3
    80002fe6:	b771                	j	80002f72 <readi+0x4c>
            brelse(bp);
    80002fe8:	854a                	mv	a0,s2
    80002fea:	fffff097          	auipc	ra,0xfffff
    80002fee:	59e080e7          	jalr	1438(ra) # 80002588 <brelse>
            tot = -1;
    80002ff2:	59fd                	li	s3,-1
    }
    return tot;
    80002ff4:	0009851b          	sext.w	a0,s3
}
    80002ff8:	70a6                	ld	ra,104(sp)
    80002ffa:	7406                	ld	s0,96(sp)
    80002ffc:	64e6                	ld	s1,88(sp)
    80002ffe:	6946                	ld	s2,80(sp)
    80003000:	69a6                	ld	s3,72(sp)
    80003002:	6a06                	ld	s4,64(sp)
    80003004:	7ae2                	ld	s5,56(sp)
    80003006:	7b42                	ld	s6,48(sp)
    80003008:	7ba2                	ld	s7,40(sp)
    8000300a:	7c02                	ld	s8,32(sp)
    8000300c:	6ce2                	ld	s9,24(sp)
    8000300e:	6d42                	ld	s10,16(sp)
    80003010:	6da2                	ld	s11,8(sp)
    80003012:	6165                	addi	sp,sp,112
    80003014:	8082                	ret
    for (tot = 0; tot < n; tot += m, off += m, dst += m)
    80003016:	89d6                	mv	s3,s5
    80003018:	bff1                	j	80002ff4 <readi+0xce>
        return 0;
    8000301a:	4501                	li	a0,0
}
    8000301c:	8082                	ret

000000008000301e <writei>:
int writei(struct inode *ip, int user_src, uint64 src, uint off, uint n)
{
    uint tot, m;
    struct buf *bp;

    if (off > ip->size || off + n < off)
    8000301e:	457c                	lw	a5,76(a0)
    80003020:	10d7e863          	bltu	a5,a3,80003130 <writei+0x112>
{
    80003024:	7159                	addi	sp,sp,-112
    80003026:	f486                	sd	ra,104(sp)
    80003028:	f0a2                	sd	s0,96(sp)
    8000302a:	eca6                	sd	s1,88(sp)
    8000302c:	e8ca                	sd	s2,80(sp)
    8000302e:	e4ce                	sd	s3,72(sp)
    80003030:	e0d2                	sd	s4,64(sp)
    80003032:	fc56                	sd	s5,56(sp)
    80003034:	f85a                	sd	s6,48(sp)
    80003036:	f45e                	sd	s7,40(sp)
    80003038:	f062                	sd	s8,32(sp)
    8000303a:	ec66                	sd	s9,24(sp)
    8000303c:	e86a                	sd	s10,16(sp)
    8000303e:	e46e                	sd	s11,8(sp)
    80003040:	1880                	addi	s0,sp,112
    80003042:	8aaa                	mv	s5,a0
    80003044:	8bae                	mv	s7,a1
    80003046:	8a32                	mv	s4,a2
    80003048:	8936                	mv	s2,a3
    8000304a:	8b3a                	mv	s6,a4
    if (off > ip->size || off + n < off)
    8000304c:	00e687bb          	addw	a5,a3,a4
    80003050:	0ed7e263          	bltu	a5,a3,80003134 <writei+0x116>
        return -1;
    if (off + n > MAXFILE * BSIZE)
    80003054:	00043737          	lui	a4,0x43
    80003058:	0ef76063          	bltu	a4,a5,80003138 <writei+0x11a>
        return -1;

    for (tot = 0; tot < n; tot += m, off += m, src += m)
    8000305c:	0c0b0863          	beqz	s6,8000312c <writei+0x10e>
    80003060:	4981                	li	s3,0
    {
        uint addr = bmap(ip, off / BSIZE);
        if (addr == 0)
            break;
        bp = bread(ip->dev, addr);
        m = min(n - tot, BSIZE - off % BSIZE);
    80003062:	40000c93          	li	s9,1024
        if (either_copyin(bp->data + (off % BSIZE), user_src, src, m) == -1)
    80003066:	5c7d                	li	s8,-1
    80003068:	a091                	j	800030ac <writei+0x8e>
    8000306a:	020d1d93          	slli	s11,s10,0x20
    8000306e:	020ddd93          	srli	s11,s11,0x20
    80003072:	05848513          	addi	a0,s1,88
    80003076:	86ee                	mv	a3,s11
    80003078:	8652                	mv	a2,s4
    8000307a:	85de                	mv	a1,s7
    8000307c:	953a                	add	a0,a0,a4
    8000307e:	fffff097          	auipc	ra,0xfffff
    80003082:	926080e7          	jalr	-1754(ra) # 800019a4 <either_copyin>
    80003086:	07850263          	beq	a0,s8,800030ea <writei+0xcc>
        {
            brelse(bp);
            break;
        }
        log_write(bp);
    8000308a:	8526                	mv	a0,s1
    8000308c:	00000097          	auipc	ra,0x0
    80003090:	780080e7          	jalr	1920(ra) # 8000380c <log_write>
        brelse(bp);
    80003094:	8526                	mv	a0,s1
    80003096:	fffff097          	auipc	ra,0xfffff
    8000309a:	4f2080e7          	jalr	1266(ra) # 80002588 <brelse>
    for (tot = 0; tot < n; tot += m, off += m, src += m)
    8000309e:	013d09bb          	addw	s3,s10,s3
    800030a2:	012d093b          	addw	s2,s10,s2
    800030a6:	9a6e                	add	s4,s4,s11
    800030a8:	0569f663          	bgeu	s3,s6,800030f4 <writei+0xd6>
        uint addr = bmap(ip, off / BSIZE);
    800030ac:	00a9559b          	srliw	a1,s2,0xa
    800030b0:	8556                	mv	a0,s5
    800030b2:	fffff097          	auipc	ra,0xfffff
    800030b6:	7a0080e7          	jalr	1952(ra) # 80002852 <bmap>
    800030ba:	0005059b          	sext.w	a1,a0
        if (addr == 0)
    800030be:	c99d                	beqz	a1,800030f4 <writei+0xd6>
        bp = bread(ip->dev, addr);
    800030c0:	000aa503          	lw	a0,0(s5)
    800030c4:	fffff097          	auipc	ra,0xfffff
    800030c8:	394080e7          	jalr	916(ra) # 80002458 <bread>
    800030cc:	84aa                	mv	s1,a0
        m = min(n - tot, BSIZE - off % BSIZE);
    800030ce:	3ff97713          	andi	a4,s2,1023
    800030d2:	40ec87bb          	subw	a5,s9,a4
    800030d6:	413b06bb          	subw	a3,s6,s3
    800030da:	8d3e                	mv	s10,a5
    800030dc:	2781                	sext.w	a5,a5
    800030de:	0006861b          	sext.w	a2,a3
    800030e2:	f8f674e3          	bgeu	a2,a5,8000306a <writei+0x4c>
    800030e6:	8d36                	mv	s10,a3
    800030e8:	b749                	j	8000306a <writei+0x4c>
            brelse(bp);
    800030ea:	8526                	mv	a0,s1
    800030ec:	fffff097          	auipc	ra,0xfffff
    800030f0:	49c080e7          	jalr	1180(ra) # 80002588 <brelse>
    }

    if (off > ip->size)
    800030f4:	04caa783          	lw	a5,76(s5)
    800030f8:	0127f463          	bgeu	a5,s2,80003100 <writei+0xe2>
        ip->size = off;
    800030fc:	052aa623          	sw	s2,76(s5)

    // write the i-node back to disk even if the size didn't change
    // because the loop above might have called bmap() and added a new
    // block to ip->addrs[].
    iupdate(ip);
    80003100:	8556                	mv	a0,s5
    80003102:	00000097          	auipc	ra,0x0
    80003106:	aa6080e7          	jalr	-1370(ra) # 80002ba8 <iupdate>

    return tot;
    8000310a:	0009851b          	sext.w	a0,s3
}
    8000310e:	70a6                	ld	ra,104(sp)
    80003110:	7406                	ld	s0,96(sp)
    80003112:	64e6                	ld	s1,88(sp)
    80003114:	6946                	ld	s2,80(sp)
    80003116:	69a6                	ld	s3,72(sp)
    80003118:	6a06                	ld	s4,64(sp)
    8000311a:	7ae2                	ld	s5,56(sp)
    8000311c:	7b42                	ld	s6,48(sp)
    8000311e:	7ba2                	ld	s7,40(sp)
    80003120:	7c02                	ld	s8,32(sp)
    80003122:	6ce2                	ld	s9,24(sp)
    80003124:	6d42                	ld	s10,16(sp)
    80003126:	6da2                	ld	s11,8(sp)
    80003128:	6165                	addi	sp,sp,112
    8000312a:	8082                	ret
    for (tot = 0; tot < n; tot += m, off += m, src += m)
    8000312c:	89da                	mv	s3,s6
    8000312e:	bfc9                	j	80003100 <writei+0xe2>
        return -1;
    80003130:	557d                	li	a0,-1
}
    80003132:	8082                	ret
        return -1;
    80003134:	557d                	li	a0,-1
    80003136:	bfe1                	j	8000310e <writei+0xf0>
        return -1;
    80003138:	557d                	li	a0,-1
    8000313a:	bfd1                	j	8000310e <writei+0xf0>

000000008000313c <namecmp>:

// Directories

int namecmp(const char *s, const char *t)
{
    8000313c:	1141                	addi	sp,sp,-16
    8000313e:	e406                	sd	ra,8(sp)
    80003140:	e022                	sd	s0,0(sp)
    80003142:	0800                	addi	s0,sp,16
    return strncmp(s, t, DIRSIZ);
    80003144:	4639                	li	a2,14
    80003146:	ffffd097          	auipc	ra,0xffffd
    8000314a:	10a080e7          	jalr	266(ra) # 80000250 <strncmp>
}
    8000314e:	60a2                	ld	ra,8(sp)
    80003150:	6402                	ld	s0,0(sp)
    80003152:	0141                	addi	sp,sp,16
    80003154:	8082                	ret

0000000080003156 <dirlookup>:

// Look for a directory entry in a directory.
// If found, set *poff to byte offset of entry.
struct inode *
dirlookup(struct inode *dp, char *name, uint *poff)
{
    80003156:	7139                	addi	sp,sp,-64
    80003158:	fc06                	sd	ra,56(sp)
    8000315a:	f822                	sd	s0,48(sp)
    8000315c:	f426                	sd	s1,40(sp)
    8000315e:	f04a                	sd	s2,32(sp)
    80003160:	ec4e                	sd	s3,24(sp)
    80003162:	e852                	sd	s4,16(sp)
    80003164:	0080                	addi	s0,sp,64
    uint off, inum;
    struct dirent de;

    if (dp->type != T_DIR)
    80003166:	04451703          	lh	a4,68(a0)
    8000316a:	4785                	li	a5,1
    8000316c:	00f71a63          	bne	a4,a5,80003180 <dirlookup+0x2a>
    80003170:	892a                	mv	s2,a0
    80003172:	89ae                	mv	s3,a1
    80003174:	8a32                	mv	s4,a2
        panic("dirlookup not DIR");

    for (off = 0; off < dp->size; off += sizeof(de))
    80003176:	457c                	lw	a5,76(a0)
    80003178:	4481                	li	s1,0
            inum = de.inum;
            return iget(dp->dev, inum);
        }
    }

    return 0;
    8000317a:	4501                	li	a0,0
    for (off = 0; off < dp->size; off += sizeof(de))
    8000317c:	e79d                	bnez	a5,800031aa <dirlookup+0x54>
    8000317e:	a8a5                	j	800031f6 <dirlookup+0xa0>
        panic("dirlookup not DIR");
    80003180:	00005517          	auipc	a0,0x5
    80003184:	4a850513          	addi	a0,a0,1192 # 80008628 <syscalls+0x1b0>
    80003188:	00003097          	auipc	ra,0x3
    8000318c:	f4a080e7          	jalr	-182(ra) # 800060d2 <panic>
            panic("dirlookup read");
    80003190:	00005517          	auipc	a0,0x5
    80003194:	4b050513          	addi	a0,a0,1200 # 80008640 <syscalls+0x1c8>
    80003198:	00003097          	auipc	ra,0x3
    8000319c:	f3a080e7          	jalr	-198(ra) # 800060d2 <panic>
    for (off = 0; off < dp->size; off += sizeof(de))
    800031a0:	24c1                	addiw	s1,s1,16
    800031a2:	04c92783          	lw	a5,76(s2)
    800031a6:	04f4f763          	bgeu	s1,a5,800031f4 <dirlookup+0x9e>
        if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800031aa:	4741                	li	a4,16
    800031ac:	86a6                	mv	a3,s1
    800031ae:	fc040613          	addi	a2,s0,-64
    800031b2:	4581                	li	a1,0
    800031b4:	854a                	mv	a0,s2
    800031b6:	00000097          	auipc	ra,0x0
    800031ba:	d70080e7          	jalr	-656(ra) # 80002f26 <readi>
    800031be:	47c1                	li	a5,16
    800031c0:	fcf518e3          	bne	a0,a5,80003190 <dirlookup+0x3a>
        if (de.inum == 0)
    800031c4:	fc045783          	lhu	a5,-64(s0)
    800031c8:	dfe1                	beqz	a5,800031a0 <dirlookup+0x4a>
        if (namecmp(name, de.name) == 0)
    800031ca:	fc240593          	addi	a1,s0,-62
    800031ce:	854e                	mv	a0,s3
    800031d0:	00000097          	auipc	ra,0x0
    800031d4:	f6c080e7          	jalr	-148(ra) # 8000313c <namecmp>
    800031d8:	f561                	bnez	a0,800031a0 <dirlookup+0x4a>
            if (poff)
    800031da:	000a0463          	beqz	s4,800031e2 <dirlookup+0x8c>
                *poff = off;
    800031de:	009a2023          	sw	s1,0(s4)
            return iget(dp->dev, inum);
    800031e2:	fc045583          	lhu	a1,-64(s0)
    800031e6:	00092503          	lw	a0,0(s2)
    800031ea:	fffff097          	auipc	ra,0xfffff
    800031ee:	750080e7          	jalr	1872(ra) # 8000293a <iget>
    800031f2:	a011                	j	800031f6 <dirlookup+0xa0>
    return 0;
    800031f4:	4501                	li	a0,0
}
    800031f6:	70e2                	ld	ra,56(sp)
    800031f8:	7442                	ld	s0,48(sp)
    800031fa:	74a2                	ld	s1,40(sp)
    800031fc:	7902                	ld	s2,32(sp)
    800031fe:	69e2                	ld	s3,24(sp)
    80003200:	6a42                	ld	s4,16(sp)
    80003202:	6121                	addi	sp,sp,64
    80003204:	8082                	ret

0000000080003206 <namex>:
// If parent != 0, return the inode for the parent and copy the final
// path element into name, which must have room for DIRSIZ bytes.
// Must be called inside a transaction since it calls iput().
static struct inode *
namex(char *path, int nameiparent, char *name)
{
    80003206:	711d                	addi	sp,sp,-96
    80003208:	ec86                	sd	ra,88(sp)
    8000320a:	e8a2                	sd	s0,80(sp)
    8000320c:	e4a6                	sd	s1,72(sp)
    8000320e:	e0ca                	sd	s2,64(sp)
    80003210:	fc4e                	sd	s3,56(sp)
    80003212:	f852                	sd	s4,48(sp)
    80003214:	f456                	sd	s5,40(sp)
    80003216:	f05a                	sd	s6,32(sp)
    80003218:	ec5e                	sd	s7,24(sp)
    8000321a:	e862                	sd	s8,16(sp)
    8000321c:	e466                	sd	s9,8(sp)
    8000321e:	1080                	addi	s0,sp,96
    80003220:	84aa                	mv	s1,a0
    80003222:	8b2e                	mv	s6,a1
    80003224:	8ab2                	mv	s5,a2
    struct inode *ip, *next;

    if (*path == '/')
    80003226:	00054703          	lbu	a4,0(a0)
    8000322a:	02f00793          	li	a5,47
    8000322e:	02f70363          	beq	a4,a5,80003254 <namex+0x4e>
        ip = iget(ROOTDEV, ROOTINO);
    else
        ip = idup(myproc()->cwd);
    80003232:	ffffe097          	auipc	ra,0xffffe
    80003236:	c30080e7          	jalr	-976(ra) # 80000e62 <myproc>
    8000323a:	15053503          	ld	a0,336(a0)
    8000323e:	00000097          	auipc	ra,0x0
    80003242:	9f6080e7          	jalr	-1546(ra) # 80002c34 <idup>
    80003246:	89aa                	mv	s3,a0
    while (*path == '/')
    80003248:	02f00913          	li	s2,47
    len = path - s;
    8000324c:	4b81                	li	s7,0
    if (len >= DIRSIZ)
    8000324e:	4cb5                	li	s9,13

    while ((path = skipelem(path, name)) != 0)
    {
        ilock(ip);
        if (ip->type != T_DIR)
    80003250:	4c05                	li	s8,1
    80003252:	a865                	j	8000330a <namex+0x104>
        ip = iget(ROOTDEV, ROOTINO);
    80003254:	4585                	li	a1,1
    80003256:	4505                	li	a0,1
    80003258:	fffff097          	auipc	ra,0xfffff
    8000325c:	6e2080e7          	jalr	1762(ra) # 8000293a <iget>
    80003260:	89aa                	mv	s3,a0
    80003262:	b7dd                	j	80003248 <namex+0x42>
        {
            iunlockput(ip);
    80003264:	854e                	mv	a0,s3
    80003266:	00000097          	auipc	ra,0x0
    8000326a:	c6e080e7          	jalr	-914(ra) # 80002ed4 <iunlockput>
            return 0;
    8000326e:	4981                	li	s3,0
    {
        iput(ip);
        return 0;
    }
    return ip;
}
    80003270:	854e                	mv	a0,s3
    80003272:	60e6                	ld	ra,88(sp)
    80003274:	6446                	ld	s0,80(sp)
    80003276:	64a6                	ld	s1,72(sp)
    80003278:	6906                	ld	s2,64(sp)
    8000327a:	79e2                	ld	s3,56(sp)
    8000327c:	7a42                	ld	s4,48(sp)
    8000327e:	7aa2                	ld	s5,40(sp)
    80003280:	7b02                	ld	s6,32(sp)
    80003282:	6be2                	ld	s7,24(sp)
    80003284:	6c42                	ld	s8,16(sp)
    80003286:	6ca2                	ld	s9,8(sp)
    80003288:	6125                	addi	sp,sp,96
    8000328a:	8082                	ret
            iunlock(ip);
    8000328c:	854e                	mv	a0,s3
    8000328e:	00000097          	auipc	ra,0x0
    80003292:	aa6080e7          	jalr	-1370(ra) # 80002d34 <iunlock>
            return ip;
    80003296:	bfe9                	j	80003270 <namex+0x6a>
            iunlockput(ip);
    80003298:	854e                	mv	a0,s3
    8000329a:	00000097          	auipc	ra,0x0
    8000329e:	c3a080e7          	jalr	-966(ra) # 80002ed4 <iunlockput>
            return 0;
    800032a2:	89d2                	mv	s3,s4
    800032a4:	b7f1                	j	80003270 <namex+0x6a>
    len = path - s;
    800032a6:	40b48633          	sub	a2,s1,a1
    800032aa:	00060a1b          	sext.w	s4,a2
    if (len >= DIRSIZ)
    800032ae:	094cd463          	bge	s9,s4,80003336 <namex+0x130>
        memmove(name, s, DIRSIZ);
    800032b2:	4639                	li	a2,14
    800032b4:	8556                	mv	a0,s5
    800032b6:	ffffd097          	auipc	ra,0xffffd
    800032ba:	f22080e7          	jalr	-222(ra) # 800001d8 <memmove>
    while (*path == '/')
    800032be:	0004c783          	lbu	a5,0(s1)
    800032c2:	01279763          	bne	a5,s2,800032d0 <namex+0xca>
        path++;
    800032c6:	0485                	addi	s1,s1,1
    while (*path == '/')
    800032c8:	0004c783          	lbu	a5,0(s1)
    800032cc:	ff278de3          	beq	a5,s2,800032c6 <namex+0xc0>
        ilock(ip);
    800032d0:	854e                	mv	a0,s3
    800032d2:	00000097          	auipc	ra,0x0
    800032d6:	9a0080e7          	jalr	-1632(ra) # 80002c72 <ilock>
        if (ip->type != T_DIR)
    800032da:	04499783          	lh	a5,68(s3)
    800032de:	f98793e3          	bne	a5,s8,80003264 <namex+0x5e>
        if (nameiparent && *path == '\0')
    800032e2:	000b0563          	beqz	s6,800032ec <namex+0xe6>
    800032e6:	0004c783          	lbu	a5,0(s1)
    800032ea:	d3cd                	beqz	a5,8000328c <namex+0x86>
        if ((next = dirlookup(ip, name, 0)) == 0)
    800032ec:	865e                	mv	a2,s7
    800032ee:	85d6                	mv	a1,s5
    800032f0:	854e                	mv	a0,s3
    800032f2:	00000097          	auipc	ra,0x0
    800032f6:	e64080e7          	jalr	-412(ra) # 80003156 <dirlookup>
    800032fa:	8a2a                	mv	s4,a0
    800032fc:	dd51                	beqz	a0,80003298 <namex+0x92>
        iunlockput(ip);
    800032fe:	854e                	mv	a0,s3
    80003300:	00000097          	auipc	ra,0x0
    80003304:	bd4080e7          	jalr	-1068(ra) # 80002ed4 <iunlockput>
        ip = next;
    80003308:	89d2                	mv	s3,s4
    while (*path == '/')
    8000330a:	0004c783          	lbu	a5,0(s1)
    8000330e:	05279763          	bne	a5,s2,8000335c <namex+0x156>
        path++;
    80003312:	0485                	addi	s1,s1,1
    while (*path == '/')
    80003314:	0004c783          	lbu	a5,0(s1)
    80003318:	ff278de3          	beq	a5,s2,80003312 <namex+0x10c>
    if (*path == 0)
    8000331c:	c79d                	beqz	a5,8000334a <namex+0x144>
        path++;
    8000331e:	85a6                	mv	a1,s1
    len = path - s;
    80003320:	8a5e                	mv	s4,s7
    80003322:	865e                	mv	a2,s7
    while (*path != '/' && *path != 0)
    80003324:	01278963          	beq	a5,s2,80003336 <namex+0x130>
    80003328:	dfbd                	beqz	a5,800032a6 <namex+0xa0>
        path++;
    8000332a:	0485                	addi	s1,s1,1
    while (*path != '/' && *path != 0)
    8000332c:	0004c783          	lbu	a5,0(s1)
    80003330:	ff279ce3          	bne	a5,s2,80003328 <namex+0x122>
    80003334:	bf8d                	j	800032a6 <namex+0xa0>
        memmove(name, s, len);
    80003336:	2601                	sext.w	a2,a2
    80003338:	8556                	mv	a0,s5
    8000333a:	ffffd097          	auipc	ra,0xffffd
    8000333e:	e9e080e7          	jalr	-354(ra) # 800001d8 <memmove>
        name[len] = 0;
    80003342:	9a56                	add	s4,s4,s5
    80003344:	000a0023          	sb	zero,0(s4)
    80003348:	bf9d                	j	800032be <namex+0xb8>
    if (nameiparent)
    8000334a:	f20b03e3          	beqz	s6,80003270 <namex+0x6a>
        iput(ip);
    8000334e:	854e                	mv	a0,s3
    80003350:	00000097          	auipc	ra,0x0
    80003354:	adc080e7          	jalr	-1316(ra) # 80002e2c <iput>
        return 0;
    80003358:	4981                	li	s3,0
    8000335a:	bf19                	j	80003270 <namex+0x6a>
    if (*path == 0)
    8000335c:	d7fd                	beqz	a5,8000334a <namex+0x144>
    while (*path != '/' && *path != 0)
    8000335e:	0004c783          	lbu	a5,0(s1)
    80003362:	85a6                	mv	a1,s1
    80003364:	b7d1                	j	80003328 <namex+0x122>

0000000080003366 <dirlink>:
{
    80003366:	7139                	addi	sp,sp,-64
    80003368:	fc06                	sd	ra,56(sp)
    8000336a:	f822                	sd	s0,48(sp)
    8000336c:	f426                	sd	s1,40(sp)
    8000336e:	f04a                	sd	s2,32(sp)
    80003370:	ec4e                	sd	s3,24(sp)
    80003372:	e852                	sd	s4,16(sp)
    80003374:	0080                	addi	s0,sp,64
    80003376:	892a                	mv	s2,a0
    80003378:	8a2e                	mv	s4,a1
    8000337a:	89b2                	mv	s3,a2
    if ((ip = dirlookup(dp, name, 0)) != 0)
    8000337c:	4601                	li	a2,0
    8000337e:	00000097          	auipc	ra,0x0
    80003382:	dd8080e7          	jalr	-552(ra) # 80003156 <dirlookup>
    80003386:	e93d                	bnez	a0,800033fc <dirlink+0x96>
    for (off = 0; off < dp->size; off += sizeof(de))
    80003388:	04c92483          	lw	s1,76(s2)
    8000338c:	c49d                	beqz	s1,800033ba <dirlink+0x54>
    8000338e:	4481                	li	s1,0
        if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80003390:	4741                	li	a4,16
    80003392:	86a6                	mv	a3,s1
    80003394:	fc040613          	addi	a2,s0,-64
    80003398:	4581                	li	a1,0
    8000339a:	854a                	mv	a0,s2
    8000339c:	00000097          	auipc	ra,0x0
    800033a0:	b8a080e7          	jalr	-1142(ra) # 80002f26 <readi>
    800033a4:	47c1                	li	a5,16
    800033a6:	06f51163          	bne	a0,a5,80003408 <dirlink+0xa2>
        if (de.inum == 0)
    800033aa:	fc045783          	lhu	a5,-64(s0)
    800033ae:	c791                	beqz	a5,800033ba <dirlink+0x54>
    for (off = 0; off < dp->size; off += sizeof(de))
    800033b0:	24c1                	addiw	s1,s1,16
    800033b2:	04c92783          	lw	a5,76(s2)
    800033b6:	fcf4ede3          	bltu	s1,a5,80003390 <dirlink+0x2a>
    strncpy(de.name, name, DIRSIZ);
    800033ba:	4639                	li	a2,14
    800033bc:	85d2                	mv	a1,s4
    800033be:	fc240513          	addi	a0,s0,-62
    800033c2:	ffffd097          	auipc	ra,0xffffd
    800033c6:	eca080e7          	jalr	-310(ra) # 8000028c <strncpy>
    de.inum = inum;
    800033ca:	fd341023          	sh	s3,-64(s0)
    if (writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    800033ce:	4741                	li	a4,16
    800033d0:	86a6                	mv	a3,s1
    800033d2:	fc040613          	addi	a2,s0,-64
    800033d6:	4581                	li	a1,0
    800033d8:	854a                	mv	a0,s2
    800033da:	00000097          	auipc	ra,0x0
    800033de:	c44080e7          	jalr	-956(ra) # 8000301e <writei>
    800033e2:	1541                	addi	a0,a0,-16
    800033e4:	00a03533          	snez	a0,a0
    800033e8:	40a00533          	neg	a0,a0
}
    800033ec:	70e2                	ld	ra,56(sp)
    800033ee:	7442                	ld	s0,48(sp)
    800033f0:	74a2                	ld	s1,40(sp)
    800033f2:	7902                	ld	s2,32(sp)
    800033f4:	69e2                	ld	s3,24(sp)
    800033f6:	6a42                	ld	s4,16(sp)
    800033f8:	6121                	addi	sp,sp,64
    800033fa:	8082                	ret
        iput(ip);
    800033fc:	00000097          	auipc	ra,0x0
    80003400:	a30080e7          	jalr	-1488(ra) # 80002e2c <iput>
        return -1;
    80003404:	557d                	li	a0,-1
    80003406:	b7dd                	j	800033ec <dirlink+0x86>
            panic("dirlink read");
    80003408:	00005517          	auipc	a0,0x5
    8000340c:	24850513          	addi	a0,a0,584 # 80008650 <syscalls+0x1d8>
    80003410:	00003097          	auipc	ra,0x3
    80003414:	cc2080e7          	jalr	-830(ra) # 800060d2 <panic>

0000000080003418 <namei>:

struct inode *
namei(char *path)
{
    80003418:	1101                	addi	sp,sp,-32
    8000341a:	ec06                	sd	ra,24(sp)
    8000341c:	e822                	sd	s0,16(sp)
    8000341e:	1000                	addi	s0,sp,32
    char name[DIRSIZ];
    return namex(path, 0, name);
    80003420:	fe040613          	addi	a2,s0,-32
    80003424:	4581                	li	a1,0
    80003426:	00000097          	auipc	ra,0x0
    8000342a:	de0080e7          	jalr	-544(ra) # 80003206 <namex>
}
    8000342e:	60e2                	ld	ra,24(sp)
    80003430:	6442                	ld	s0,16(sp)
    80003432:	6105                	addi	sp,sp,32
    80003434:	8082                	ret

0000000080003436 <nameiparent>:

struct inode *
nameiparent(char *path, char *name)
{
    80003436:	1141                	addi	sp,sp,-16
    80003438:	e406                	sd	ra,8(sp)
    8000343a:	e022                	sd	s0,0(sp)
    8000343c:	0800                	addi	s0,sp,16
    8000343e:	862e                	mv	a2,a1
    return namex(path, 1, name);
    80003440:	4585                	li	a1,1
    80003442:	00000097          	auipc	ra,0x0
    80003446:	dc4080e7          	jalr	-572(ra) # 80003206 <namex>
}
    8000344a:	60a2                	ld	ra,8(sp)
    8000344c:	6402                	ld	s0,0(sp)
    8000344e:	0141                	addi	sp,sp,16
    80003450:	8082                	ret

0000000080003452 <write_head>:
// Write in-memory log header to disk.
// This is the true point at which the
// current transaction commits.
static void
write_head(void)
{
    80003452:	1101                	addi	sp,sp,-32
    80003454:	ec06                	sd	ra,24(sp)
    80003456:	e822                	sd	s0,16(sp)
    80003458:	e426                	sd	s1,8(sp)
    8000345a:	e04a                	sd	s2,0(sp)
    8000345c:	1000                	addi	s0,sp,32
  struct buf *buf = bread(log.dev, log.start);
    8000345e:	00027917          	auipc	s2,0x27
    80003462:	71290913          	addi	s2,s2,1810 # 8002ab70 <log>
    80003466:	01892583          	lw	a1,24(s2)
    8000346a:	02892503          	lw	a0,40(s2)
    8000346e:	fffff097          	auipc	ra,0xfffff
    80003472:	fea080e7          	jalr	-22(ra) # 80002458 <bread>
    80003476:	84aa                	mv	s1,a0
  struct logheader *hb = (struct logheader *) (buf->data);
  int i;
  hb->n = log.lh.n;
    80003478:	02c92683          	lw	a3,44(s2)
    8000347c:	cd34                	sw	a3,88(a0)
  for (i = 0; i < log.lh.n; i++) {
    8000347e:	02d05763          	blez	a3,800034ac <write_head+0x5a>
    80003482:	00027797          	auipc	a5,0x27
    80003486:	71e78793          	addi	a5,a5,1822 # 8002aba0 <log+0x30>
    8000348a:	05c50713          	addi	a4,a0,92
    8000348e:	36fd                	addiw	a3,a3,-1
    80003490:	1682                	slli	a3,a3,0x20
    80003492:	9281                	srli	a3,a3,0x20
    80003494:	068a                	slli	a3,a3,0x2
    80003496:	00027617          	auipc	a2,0x27
    8000349a:	70e60613          	addi	a2,a2,1806 # 8002aba4 <log+0x34>
    8000349e:	96b2                	add	a3,a3,a2
    hb->block[i] = log.lh.block[i];
    800034a0:	4390                	lw	a2,0(a5)
    800034a2:	c310                	sw	a2,0(a4)
  for (i = 0; i < log.lh.n; i++) {
    800034a4:	0791                	addi	a5,a5,4
    800034a6:	0711                	addi	a4,a4,4
    800034a8:	fed79ce3          	bne	a5,a3,800034a0 <write_head+0x4e>
  }
  bwrite(buf);
    800034ac:	8526                	mv	a0,s1
    800034ae:	fffff097          	auipc	ra,0xfffff
    800034b2:	09c080e7          	jalr	156(ra) # 8000254a <bwrite>
  brelse(buf);
    800034b6:	8526                	mv	a0,s1
    800034b8:	fffff097          	auipc	ra,0xfffff
    800034bc:	0d0080e7          	jalr	208(ra) # 80002588 <brelse>
}
    800034c0:	60e2                	ld	ra,24(sp)
    800034c2:	6442                	ld	s0,16(sp)
    800034c4:	64a2                	ld	s1,8(sp)
    800034c6:	6902                	ld	s2,0(sp)
    800034c8:	6105                	addi	sp,sp,32
    800034ca:	8082                	ret

00000000800034cc <install_trans>:
  for (tail = 0; tail < log.lh.n; tail++) {
    800034cc:	00027797          	auipc	a5,0x27
    800034d0:	6d07a783          	lw	a5,1744(a5) # 8002ab9c <log+0x2c>
    800034d4:	0af05d63          	blez	a5,8000358e <install_trans+0xc2>
{
    800034d8:	7139                	addi	sp,sp,-64
    800034da:	fc06                	sd	ra,56(sp)
    800034dc:	f822                	sd	s0,48(sp)
    800034de:	f426                	sd	s1,40(sp)
    800034e0:	f04a                	sd	s2,32(sp)
    800034e2:	ec4e                	sd	s3,24(sp)
    800034e4:	e852                	sd	s4,16(sp)
    800034e6:	e456                	sd	s5,8(sp)
    800034e8:	e05a                	sd	s6,0(sp)
    800034ea:	0080                	addi	s0,sp,64
    800034ec:	8b2a                	mv	s6,a0
    800034ee:	00027a97          	auipc	s5,0x27
    800034f2:	6b2a8a93          	addi	s5,s5,1714 # 8002aba0 <log+0x30>
  for (tail = 0; tail < log.lh.n; tail++) {
    800034f6:	4a01                	li	s4,0
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    800034f8:	00027997          	auipc	s3,0x27
    800034fc:	67898993          	addi	s3,s3,1656 # 8002ab70 <log>
    80003500:	a035                	j	8000352c <install_trans+0x60>
      bunpin(dbuf);
    80003502:	8526                	mv	a0,s1
    80003504:	fffff097          	auipc	ra,0xfffff
    80003508:	15e080e7          	jalr	350(ra) # 80002662 <bunpin>
    brelse(lbuf);
    8000350c:	854a                	mv	a0,s2
    8000350e:	fffff097          	auipc	ra,0xfffff
    80003512:	07a080e7          	jalr	122(ra) # 80002588 <brelse>
    brelse(dbuf);
    80003516:	8526                	mv	a0,s1
    80003518:	fffff097          	auipc	ra,0xfffff
    8000351c:	070080e7          	jalr	112(ra) # 80002588 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003520:	2a05                	addiw	s4,s4,1
    80003522:	0a91                	addi	s5,s5,4
    80003524:	02c9a783          	lw	a5,44(s3)
    80003528:	04fa5963          	bge	s4,a5,8000357a <install_trans+0xae>
    struct buf *lbuf = bread(log.dev, log.start+tail+1); // read log block
    8000352c:	0189a583          	lw	a1,24(s3)
    80003530:	014585bb          	addw	a1,a1,s4
    80003534:	2585                	addiw	a1,a1,1
    80003536:	0289a503          	lw	a0,40(s3)
    8000353a:	fffff097          	auipc	ra,0xfffff
    8000353e:	f1e080e7          	jalr	-226(ra) # 80002458 <bread>
    80003542:	892a                	mv	s2,a0
    struct buf *dbuf = bread(log.dev, log.lh.block[tail]); // read dst
    80003544:	000aa583          	lw	a1,0(s5)
    80003548:	0289a503          	lw	a0,40(s3)
    8000354c:	fffff097          	auipc	ra,0xfffff
    80003550:	f0c080e7          	jalr	-244(ra) # 80002458 <bread>
    80003554:	84aa                	mv	s1,a0
    memmove(dbuf->data, lbuf->data, BSIZE);  // copy block to dst
    80003556:	40000613          	li	a2,1024
    8000355a:	05890593          	addi	a1,s2,88
    8000355e:	05850513          	addi	a0,a0,88
    80003562:	ffffd097          	auipc	ra,0xffffd
    80003566:	c76080e7          	jalr	-906(ra) # 800001d8 <memmove>
    bwrite(dbuf);  // write dst to disk
    8000356a:	8526                	mv	a0,s1
    8000356c:	fffff097          	auipc	ra,0xfffff
    80003570:	fde080e7          	jalr	-34(ra) # 8000254a <bwrite>
    if(recovering == 0)
    80003574:	f80b1ce3          	bnez	s6,8000350c <install_trans+0x40>
    80003578:	b769                	j	80003502 <install_trans+0x36>
}
    8000357a:	70e2                	ld	ra,56(sp)
    8000357c:	7442                	ld	s0,48(sp)
    8000357e:	74a2                	ld	s1,40(sp)
    80003580:	7902                	ld	s2,32(sp)
    80003582:	69e2                	ld	s3,24(sp)
    80003584:	6a42                	ld	s4,16(sp)
    80003586:	6aa2                	ld	s5,8(sp)
    80003588:	6b02                	ld	s6,0(sp)
    8000358a:	6121                	addi	sp,sp,64
    8000358c:	8082                	ret
    8000358e:	8082                	ret

0000000080003590 <initlog>:
{
    80003590:	7179                	addi	sp,sp,-48
    80003592:	f406                	sd	ra,40(sp)
    80003594:	f022                	sd	s0,32(sp)
    80003596:	ec26                	sd	s1,24(sp)
    80003598:	e84a                	sd	s2,16(sp)
    8000359a:	e44e                	sd	s3,8(sp)
    8000359c:	1800                	addi	s0,sp,48
    8000359e:	892a                	mv	s2,a0
    800035a0:	89ae                	mv	s3,a1
  initlock(&log.lock, "log");
    800035a2:	00027497          	auipc	s1,0x27
    800035a6:	5ce48493          	addi	s1,s1,1486 # 8002ab70 <log>
    800035aa:	00005597          	auipc	a1,0x5
    800035ae:	0b658593          	addi	a1,a1,182 # 80008660 <syscalls+0x1e8>
    800035b2:	8526                	mv	a0,s1
    800035b4:	00003097          	auipc	ra,0x3
    800035b8:	fd8080e7          	jalr	-40(ra) # 8000658c <initlock>
  log.start = sb->logstart;
    800035bc:	0149a583          	lw	a1,20(s3)
    800035c0:	cc8c                	sw	a1,24(s1)
  log.size = sb->nlog;
    800035c2:	0109a783          	lw	a5,16(s3)
    800035c6:	ccdc                	sw	a5,28(s1)
  log.dev = dev;
    800035c8:	0324a423          	sw	s2,40(s1)
  struct buf *buf = bread(log.dev, log.start);
    800035cc:	854a                	mv	a0,s2
    800035ce:	fffff097          	auipc	ra,0xfffff
    800035d2:	e8a080e7          	jalr	-374(ra) # 80002458 <bread>
  log.lh.n = lh->n;
    800035d6:	4d3c                	lw	a5,88(a0)
    800035d8:	d4dc                	sw	a5,44(s1)
  for (i = 0; i < log.lh.n; i++) {
    800035da:	02f05563          	blez	a5,80003604 <initlog+0x74>
    800035de:	05c50713          	addi	a4,a0,92
    800035e2:	00027697          	auipc	a3,0x27
    800035e6:	5be68693          	addi	a3,a3,1470 # 8002aba0 <log+0x30>
    800035ea:	37fd                	addiw	a5,a5,-1
    800035ec:	1782                	slli	a5,a5,0x20
    800035ee:	9381                	srli	a5,a5,0x20
    800035f0:	078a                	slli	a5,a5,0x2
    800035f2:	06050613          	addi	a2,a0,96
    800035f6:	97b2                	add	a5,a5,a2
    log.lh.block[i] = lh->block[i];
    800035f8:	4310                	lw	a2,0(a4)
    800035fa:	c290                	sw	a2,0(a3)
  for (i = 0; i < log.lh.n; i++) {
    800035fc:	0711                	addi	a4,a4,4
    800035fe:	0691                	addi	a3,a3,4
    80003600:	fef71ce3          	bne	a4,a5,800035f8 <initlog+0x68>
  brelse(buf);
    80003604:	fffff097          	auipc	ra,0xfffff
    80003608:	f84080e7          	jalr	-124(ra) # 80002588 <brelse>

static void
recover_from_log(void)
{
  read_head();
  install_trans(1); // if committed, copy from log to disk
    8000360c:	4505                	li	a0,1
    8000360e:	00000097          	auipc	ra,0x0
    80003612:	ebe080e7          	jalr	-322(ra) # 800034cc <install_trans>
  log.lh.n = 0;
    80003616:	00027797          	auipc	a5,0x27
    8000361a:	5807a323          	sw	zero,1414(a5) # 8002ab9c <log+0x2c>
  write_head(); // clear the log
    8000361e:	00000097          	auipc	ra,0x0
    80003622:	e34080e7          	jalr	-460(ra) # 80003452 <write_head>
}
    80003626:	70a2                	ld	ra,40(sp)
    80003628:	7402                	ld	s0,32(sp)
    8000362a:	64e2                	ld	s1,24(sp)
    8000362c:	6942                	ld	s2,16(sp)
    8000362e:	69a2                	ld	s3,8(sp)
    80003630:	6145                	addi	sp,sp,48
    80003632:	8082                	ret

0000000080003634 <begin_op>:
}

// called at the start of each FS system call.
void
begin_op(void)
{
    80003634:	1101                	addi	sp,sp,-32
    80003636:	ec06                	sd	ra,24(sp)
    80003638:	e822                	sd	s0,16(sp)
    8000363a:	e426                	sd	s1,8(sp)
    8000363c:	e04a                	sd	s2,0(sp)
    8000363e:	1000                	addi	s0,sp,32
  acquire(&log.lock);
    80003640:	00027517          	auipc	a0,0x27
    80003644:	53050513          	addi	a0,a0,1328 # 8002ab70 <log>
    80003648:	00003097          	auipc	ra,0x3
    8000364c:	fd4080e7          	jalr	-44(ra) # 8000661c <acquire>
  while(1){
    if(log.committing){
    80003650:	00027497          	auipc	s1,0x27
    80003654:	52048493          	addi	s1,s1,1312 # 8002ab70 <log>
      sleep(&log, &log.lock);
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    80003658:	4979                	li	s2,30
    8000365a:	a039                	j	80003668 <begin_op+0x34>
      sleep(&log, &log.lock);
    8000365c:	85a6                	mv	a1,s1
    8000365e:	8526                	mv	a0,s1
    80003660:	ffffe097          	auipc	ra,0xffffe
    80003664:	ee6080e7          	jalr	-282(ra) # 80001546 <sleep>
    if(log.committing){
    80003668:	50dc                	lw	a5,36(s1)
    8000366a:	fbed                	bnez	a5,8000365c <begin_op+0x28>
    } else if(log.lh.n + (log.outstanding+1)*MAXOPBLOCKS > LOGSIZE){
    8000366c:	509c                	lw	a5,32(s1)
    8000366e:	0017871b          	addiw	a4,a5,1
    80003672:	0007069b          	sext.w	a3,a4
    80003676:	0027179b          	slliw	a5,a4,0x2
    8000367a:	9fb9                	addw	a5,a5,a4
    8000367c:	0017979b          	slliw	a5,a5,0x1
    80003680:	54d8                	lw	a4,44(s1)
    80003682:	9fb9                	addw	a5,a5,a4
    80003684:	00f95963          	bge	s2,a5,80003696 <begin_op+0x62>
      // this op might exhaust log space; wait for commit.
      sleep(&log, &log.lock);
    80003688:	85a6                	mv	a1,s1
    8000368a:	8526                	mv	a0,s1
    8000368c:	ffffe097          	auipc	ra,0xffffe
    80003690:	eba080e7          	jalr	-326(ra) # 80001546 <sleep>
    80003694:	bfd1                	j	80003668 <begin_op+0x34>
    } else {
      log.outstanding += 1;
    80003696:	00027517          	auipc	a0,0x27
    8000369a:	4da50513          	addi	a0,a0,1242 # 8002ab70 <log>
    8000369e:	d114                	sw	a3,32(a0)
      release(&log.lock);
    800036a0:	00003097          	auipc	ra,0x3
    800036a4:	030080e7          	jalr	48(ra) # 800066d0 <release>
      break;
    }
  }
}
    800036a8:	60e2                	ld	ra,24(sp)
    800036aa:	6442                	ld	s0,16(sp)
    800036ac:	64a2                	ld	s1,8(sp)
    800036ae:	6902                	ld	s2,0(sp)
    800036b0:	6105                	addi	sp,sp,32
    800036b2:	8082                	ret

00000000800036b4 <end_op>:

// called at the end of each FS system call.
// commits if this was the last outstanding operation.
void
end_op(void)
{
    800036b4:	7139                	addi	sp,sp,-64
    800036b6:	fc06                	sd	ra,56(sp)
    800036b8:	f822                	sd	s0,48(sp)
    800036ba:	f426                	sd	s1,40(sp)
    800036bc:	f04a                	sd	s2,32(sp)
    800036be:	ec4e                	sd	s3,24(sp)
    800036c0:	e852                	sd	s4,16(sp)
    800036c2:	e456                	sd	s5,8(sp)
    800036c4:	0080                	addi	s0,sp,64
  int do_commit = 0;

  acquire(&log.lock);
    800036c6:	00027497          	auipc	s1,0x27
    800036ca:	4aa48493          	addi	s1,s1,1194 # 8002ab70 <log>
    800036ce:	8526                	mv	a0,s1
    800036d0:	00003097          	auipc	ra,0x3
    800036d4:	f4c080e7          	jalr	-180(ra) # 8000661c <acquire>
  log.outstanding -= 1;
    800036d8:	509c                	lw	a5,32(s1)
    800036da:	37fd                	addiw	a5,a5,-1
    800036dc:	0007891b          	sext.w	s2,a5
    800036e0:	d09c                	sw	a5,32(s1)
  if(log.committing)
    800036e2:	50dc                	lw	a5,36(s1)
    800036e4:	efb9                	bnez	a5,80003742 <end_op+0x8e>
    panic("log.committing");
  if(log.outstanding == 0){
    800036e6:	06091663          	bnez	s2,80003752 <end_op+0x9e>
    do_commit = 1;
    log.committing = 1;
    800036ea:	00027497          	auipc	s1,0x27
    800036ee:	48648493          	addi	s1,s1,1158 # 8002ab70 <log>
    800036f2:	4785                	li	a5,1
    800036f4:	d0dc                	sw	a5,36(s1)
    // begin_op() may be waiting for log space,
    // and decrementing log.outstanding has decreased
    // the amount of reserved space.
    wakeup(&log);
  }
  release(&log.lock);
    800036f6:	8526                	mv	a0,s1
    800036f8:	00003097          	auipc	ra,0x3
    800036fc:	fd8080e7          	jalr	-40(ra) # 800066d0 <release>
}

static void
commit()
{
  if (log.lh.n > 0) {
    80003700:	54dc                	lw	a5,44(s1)
    80003702:	06f04763          	bgtz	a5,80003770 <end_op+0xbc>
    acquire(&log.lock);
    80003706:	00027497          	auipc	s1,0x27
    8000370a:	46a48493          	addi	s1,s1,1130 # 8002ab70 <log>
    8000370e:	8526                	mv	a0,s1
    80003710:	00003097          	auipc	ra,0x3
    80003714:	f0c080e7          	jalr	-244(ra) # 8000661c <acquire>
    log.committing = 0;
    80003718:	0204a223          	sw	zero,36(s1)
    wakeup(&log);
    8000371c:	8526                	mv	a0,s1
    8000371e:	ffffe097          	auipc	ra,0xffffe
    80003722:	e8c080e7          	jalr	-372(ra) # 800015aa <wakeup>
    release(&log.lock);
    80003726:	8526                	mv	a0,s1
    80003728:	00003097          	auipc	ra,0x3
    8000372c:	fa8080e7          	jalr	-88(ra) # 800066d0 <release>
}
    80003730:	70e2                	ld	ra,56(sp)
    80003732:	7442                	ld	s0,48(sp)
    80003734:	74a2                	ld	s1,40(sp)
    80003736:	7902                	ld	s2,32(sp)
    80003738:	69e2                	ld	s3,24(sp)
    8000373a:	6a42                	ld	s4,16(sp)
    8000373c:	6aa2                	ld	s5,8(sp)
    8000373e:	6121                	addi	sp,sp,64
    80003740:	8082                	ret
    panic("log.committing");
    80003742:	00005517          	auipc	a0,0x5
    80003746:	f2650513          	addi	a0,a0,-218 # 80008668 <syscalls+0x1f0>
    8000374a:	00003097          	auipc	ra,0x3
    8000374e:	988080e7          	jalr	-1656(ra) # 800060d2 <panic>
    wakeup(&log);
    80003752:	00027497          	auipc	s1,0x27
    80003756:	41e48493          	addi	s1,s1,1054 # 8002ab70 <log>
    8000375a:	8526                	mv	a0,s1
    8000375c:	ffffe097          	auipc	ra,0xffffe
    80003760:	e4e080e7          	jalr	-434(ra) # 800015aa <wakeup>
  release(&log.lock);
    80003764:	8526                	mv	a0,s1
    80003766:	00003097          	auipc	ra,0x3
    8000376a:	f6a080e7          	jalr	-150(ra) # 800066d0 <release>
  if(do_commit){
    8000376e:	b7c9                	j	80003730 <end_op+0x7c>
  for (tail = 0; tail < log.lh.n; tail++) {
    80003770:	00027a97          	auipc	s5,0x27
    80003774:	430a8a93          	addi	s5,s5,1072 # 8002aba0 <log+0x30>
    struct buf *to = bread(log.dev, log.start+tail+1); // log block
    80003778:	00027a17          	auipc	s4,0x27
    8000377c:	3f8a0a13          	addi	s4,s4,1016 # 8002ab70 <log>
    80003780:	018a2583          	lw	a1,24(s4)
    80003784:	012585bb          	addw	a1,a1,s2
    80003788:	2585                	addiw	a1,a1,1
    8000378a:	028a2503          	lw	a0,40(s4)
    8000378e:	fffff097          	auipc	ra,0xfffff
    80003792:	cca080e7          	jalr	-822(ra) # 80002458 <bread>
    80003796:	84aa                	mv	s1,a0
    struct buf *from = bread(log.dev, log.lh.block[tail]); // cache block
    80003798:	000aa583          	lw	a1,0(s5)
    8000379c:	028a2503          	lw	a0,40(s4)
    800037a0:	fffff097          	auipc	ra,0xfffff
    800037a4:	cb8080e7          	jalr	-840(ra) # 80002458 <bread>
    800037a8:	89aa                	mv	s3,a0
    memmove(to->data, from->data, BSIZE);
    800037aa:	40000613          	li	a2,1024
    800037ae:	05850593          	addi	a1,a0,88
    800037b2:	05848513          	addi	a0,s1,88
    800037b6:	ffffd097          	auipc	ra,0xffffd
    800037ba:	a22080e7          	jalr	-1502(ra) # 800001d8 <memmove>
    bwrite(to);  // write the log
    800037be:	8526                	mv	a0,s1
    800037c0:	fffff097          	auipc	ra,0xfffff
    800037c4:	d8a080e7          	jalr	-630(ra) # 8000254a <bwrite>
    brelse(from);
    800037c8:	854e                	mv	a0,s3
    800037ca:	fffff097          	auipc	ra,0xfffff
    800037ce:	dbe080e7          	jalr	-578(ra) # 80002588 <brelse>
    brelse(to);
    800037d2:	8526                	mv	a0,s1
    800037d4:	fffff097          	auipc	ra,0xfffff
    800037d8:	db4080e7          	jalr	-588(ra) # 80002588 <brelse>
  for (tail = 0; tail < log.lh.n; tail++) {
    800037dc:	2905                	addiw	s2,s2,1
    800037de:	0a91                	addi	s5,s5,4
    800037e0:	02ca2783          	lw	a5,44(s4)
    800037e4:	f8f94ee3          	blt	s2,a5,80003780 <end_op+0xcc>
    write_log();     // Write modified blocks from cache to log
    write_head();    // Write header to disk -- the real commit
    800037e8:	00000097          	auipc	ra,0x0
    800037ec:	c6a080e7          	jalr	-918(ra) # 80003452 <write_head>
    install_trans(0); // Now install writes to home locations
    800037f0:	4501                	li	a0,0
    800037f2:	00000097          	auipc	ra,0x0
    800037f6:	cda080e7          	jalr	-806(ra) # 800034cc <install_trans>
    log.lh.n = 0;
    800037fa:	00027797          	auipc	a5,0x27
    800037fe:	3a07a123          	sw	zero,930(a5) # 8002ab9c <log+0x2c>
    write_head();    // Erase the transaction from the log
    80003802:	00000097          	auipc	ra,0x0
    80003806:	c50080e7          	jalr	-944(ra) # 80003452 <write_head>
    8000380a:	bdf5                	j	80003706 <end_op+0x52>

000000008000380c <log_write>:
//   modify bp->data[]
//   log_write(bp)
//   brelse(bp)
void
log_write(struct buf *b)
{
    8000380c:	1101                	addi	sp,sp,-32
    8000380e:	ec06                	sd	ra,24(sp)
    80003810:	e822                	sd	s0,16(sp)
    80003812:	e426                	sd	s1,8(sp)
    80003814:	e04a                	sd	s2,0(sp)
    80003816:	1000                	addi	s0,sp,32
    80003818:	84aa                	mv	s1,a0
  int i;

  acquire(&log.lock);
    8000381a:	00027917          	auipc	s2,0x27
    8000381e:	35690913          	addi	s2,s2,854 # 8002ab70 <log>
    80003822:	854a                	mv	a0,s2
    80003824:	00003097          	auipc	ra,0x3
    80003828:	df8080e7          	jalr	-520(ra) # 8000661c <acquire>
  if (log.lh.n >= LOGSIZE || log.lh.n >= log.size - 1)
    8000382c:	02c92603          	lw	a2,44(s2)
    80003830:	47f5                	li	a5,29
    80003832:	06c7c563          	blt	a5,a2,8000389c <log_write+0x90>
    80003836:	00027797          	auipc	a5,0x27
    8000383a:	3567a783          	lw	a5,854(a5) # 8002ab8c <log+0x1c>
    8000383e:	37fd                	addiw	a5,a5,-1
    80003840:	04f65e63          	bge	a2,a5,8000389c <log_write+0x90>
    panic("too big a transaction");
  if (log.outstanding < 1)
    80003844:	00027797          	auipc	a5,0x27
    80003848:	34c7a783          	lw	a5,844(a5) # 8002ab90 <log+0x20>
    8000384c:	06f05063          	blez	a5,800038ac <log_write+0xa0>
    panic("log_write outside of trans");

  for (i = 0; i < log.lh.n; i++) {
    80003850:	4781                	li	a5,0
    80003852:	06c05563          	blez	a2,800038bc <log_write+0xb0>
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003856:	44cc                	lw	a1,12(s1)
    80003858:	00027717          	auipc	a4,0x27
    8000385c:	34870713          	addi	a4,a4,840 # 8002aba0 <log+0x30>
  for (i = 0; i < log.lh.n; i++) {
    80003860:	4781                	li	a5,0
    if (log.lh.block[i] == b->blockno)   // log absorption
    80003862:	4314                	lw	a3,0(a4)
    80003864:	04b68c63          	beq	a3,a1,800038bc <log_write+0xb0>
  for (i = 0; i < log.lh.n; i++) {
    80003868:	2785                	addiw	a5,a5,1
    8000386a:	0711                	addi	a4,a4,4
    8000386c:	fef61be3          	bne	a2,a5,80003862 <log_write+0x56>
      break;
  }
  log.lh.block[i] = b->blockno;
    80003870:	0621                	addi	a2,a2,8
    80003872:	060a                	slli	a2,a2,0x2
    80003874:	00027797          	auipc	a5,0x27
    80003878:	2fc78793          	addi	a5,a5,764 # 8002ab70 <log>
    8000387c:	963e                	add	a2,a2,a5
    8000387e:	44dc                	lw	a5,12(s1)
    80003880:	ca1c                	sw	a5,16(a2)
  if (i == log.lh.n) {  // Add new block to log?
    bpin(b);
    80003882:	8526                	mv	a0,s1
    80003884:	fffff097          	auipc	ra,0xfffff
    80003888:	da2080e7          	jalr	-606(ra) # 80002626 <bpin>
    log.lh.n++;
    8000388c:	00027717          	auipc	a4,0x27
    80003890:	2e470713          	addi	a4,a4,740 # 8002ab70 <log>
    80003894:	575c                	lw	a5,44(a4)
    80003896:	2785                	addiw	a5,a5,1
    80003898:	d75c                	sw	a5,44(a4)
    8000389a:	a835                	j	800038d6 <log_write+0xca>
    panic("too big a transaction");
    8000389c:	00005517          	auipc	a0,0x5
    800038a0:	ddc50513          	addi	a0,a0,-548 # 80008678 <syscalls+0x200>
    800038a4:	00003097          	auipc	ra,0x3
    800038a8:	82e080e7          	jalr	-2002(ra) # 800060d2 <panic>
    panic("log_write outside of trans");
    800038ac:	00005517          	auipc	a0,0x5
    800038b0:	de450513          	addi	a0,a0,-540 # 80008690 <syscalls+0x218>
    800038b4:	00003097          	auipc	ra,0x3
    800038b8:	81e080e7          	jalr	-2018(ra) # 800060d2 <panic>
  log.lh.block[i] = b->blockno;
    800038bc:	00878713          	addi	a4,a5,8
    800038c0:	00271693          	slli	a3,a4,0x2
    800038c4:	00027717          	auipc	a4,0x27
    800038c8:	2ac70713          	addi	a4,a4,684 # 8002ab70 <log>
    800038cc:	9736                	add	a4,a4,a3
    800038ce:	44d4                	lw	a3,12(s1)
    800038d0:	cb14                	sw	a3,16(a4)
  if (i == log.lh.n) {  // Add new block to log?
    800038d2:	faf608e3          	beq	a2,a5,80003882 <log_write+0x76>
  }
  release(&log.lock);
    800038d6:	00027517          	auipc	a0,0x27
    800038da:	29a50513          	addi	a0,a0,666 # 8002ab70 <log>
    800038de:	00003097          	auipc	ra,0x3
    800038e2:	df2080e7          	jalr	-526(ra) # 800066d0 <release>
}
    800038e6:	60e2                	ld	ra,24(sp)
    800038e8:	6442                	ld	s0,16(sp)
    800038ea:	64a2                	ld	s1,8(sp)
    800038ec:	6902                	ld	s2,0(sp)
    800038ee:	6105                	addi	sp,sp,32
    800038f0:	8082                	ret

00000000800038f2 <initsleeplock>:
#include "proc.h"
#include "sleeplock.h"

void
initsleeplock(struct sleeplock *lk, char *name)
{
    800038f2:	1101                	addi	sp,sp,-32
    800038f4:	ec06                	sd	ra,24(sp)
    800038f6:	e822                	sd	s0,16(sp)
    800038f8:	e426                	sd	s1,8(sp)
    800038fa:	e04a                	sd	s2,0(sp)
    800038fc:	1000                	addi	s0,sp,32
    800038fe:	84aa                	mv	s1,a0
    80003900:	892e                	mv	s2,a1
  initlock(&lk->lk, "sleep lock");
    80003902:	00005597          	auipc	a1,0x5
    80003906:	dae58593          	addi	a1,a1,-594 # 800086b0 <syscalls+0x238>
    8000390a:	0521                	addi	a0,a0,8
    8000390c:	00003097          	auipc	ra,0x3
    80003910:	c80080e7          	jalr	-896(ra) # 8000658c <initlock>
  lk->name = name;
    80003914:	0324b023          	sd	s2,32(s1)
  lk->locked = 0;
    80003918:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    8000391c:	0204a423          	sw	zero,40(s1)
}
    80003920:	60e2                	ld	ra,24(sp)
    80003922:	6442                	ld	s0,16(sp)
    80003924:	64a2                	ld	s1,8(sp)
    80003926:	6902                	ld	s2,0(sp)
    80003928:	6105                	addi	sp,sp,32
    8000392a:	8082                	ret

000000008000392c <acquiresleep>:

void
acquiresleep(struct sleeplock *lk)
{
    8000392c:	1101                	addi	sp,sp,-32
    8000392e:	ec06                	sd	ra,24(sp)
    80003930:	e822                	sd	s0,16(sp)
    80003932:	e426                	sd	s1,8(sp)
    80003934:	e04a                	sd	s2,0(sp)
    80003936:	1000                	addi	s0,sp,32
    80003938:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    8000393a:	00850913          	addi	s2,a0,8
    8000393e:	854a                	mv	a0,s2
    80003940:	00003097          	auipc	ra,0x3
    80003944:	cdc080e7          	jalr	-804(ra) # 8000661c <acquire>
  while (lk->locked) {
    80003948:	409c                	lw	a5,0(s1)
    8000394a:	cb89                	beqz	a5,8000395c <acquiresleep+0x30>
    sleep(lk, &lk->lk);
    8000394c:	85ca                	mv	a1,s2
    8000394e:	8526                	mv	a0,s1
    80003950:	ffffe097          	auipc	ra,0xffffe
    80003954:	bf6080e7          	jalr	-1034(ra) # 80001546 <sleep>
  while (lk->locked) {
    80003958:	409c                	lw	a5,0(s1)
    8000395a:	fbed                	bnez	a5,8000394c <acquiresleep+0x20>
  }
  lk->locked = 1;
    8000395c:	4785                	li	a5,1
    8000395e:	c09c                	sw	a5,0(s1)
  lk->pid = myproc()->pid;
    80003960:	ffffd097          	auipc	ra,0xffffd
    80003964:	502080e7          	jalr	1282(ra) # 80000e62 <myproc>
    80003968:	591c                	lw	a5,48(a0)
    8000396a:	d49c                	sw	a5,40(s1)
  release(&lk->lk);
    8000396c:	854a                	mv	a0,s2
    8000396e:	00003097          	auipc	ra,0x3
    80003972:	d62080e7          	jalr	-670(ra) # 800066d0 <release>
}
    80003976:	60e2                	ld	ra,24(sp)
    80003978:	6442                	ld	s0,16(sp)
    8000397a:	64a2                	ld	s1,8(sp)
    8000397c:	6902                	ld	s2,0(sp)
    8000397e:	6105                	addi	sp,sp,32
    80003980:	8082                	ret

0000000080003982 <releasesleep>:

void
releasesleep(struct sleeplock *lk)
{
    80003982:	1101                	addi	sp,sp,-32
    80003984:	ec06                	sd	ra,24(sp)
    80003986:	e822                	sd	s0,16(sp)
    80003988:	e426                	sd	s1,8(sp)
    8000398a:	e04a                	sd	s2,0(sp)
    8000398c:	1000                	addi	s0,sp,32
    8000398e:	84aa                	mv	s1,a0
  acquire(&lk->lk);
    80003990:	00850913          	addi	s2,a0,8
    80003994:	854a                	mv	a0,s2
    80003996:	00003097          	auipc	ra,0x3
    8000399a:	c86080e7          	jalr	-890(ra) # 8000661c <acquire>
  lk->locked = 0;
    8000399e:	0004a023          	sw	zero,0(s1)
  lk->pid = 0;
    800039a2:	0204a423          	sw	zero,40(s1)
  wakeup(lk);
    800039a6:	8526                	mv	a0,s1
    800039a8:	ffffe097          	auipc	ra,0xffffe
    800039ac:	c02080e7          	jalr	-1022(ra) # 800015aa <wakeup>
  release(&lk->lk);
    800039b0:	854a                	mv	a0,s2
    800039b2:	00003097          	auipc	ra,0x3
    800039b6:	d1e080e7          	jalr	-738(ra) # 800066d0 <release>
}
    800039ba:	60e2                	ld	ra,24(sp)
    800039bc:	6442                	ld	s0,16(sp)
    800039be:	64a2                	ld	s1,8(sp)
    800039c0:	6902                	ld	s2,0(sp)
    800039c2:	6105                	addi	sp,sp,32
    800039c4:	8082                	ret

00000000800039c6 <holdingsleep>:

int
holdingsleep(struct sleeplock *lk)
{
    800039c6:	7179                	addi	sp,sp,-48
    800039c8:	f406                	sd	ra,40(sp)
    800039ca:	f022                	sd	s0,32(sp)
    800039cc:	ec26                	sd	s1,24(sp)
    800039ce:	e84a                	sd	s2,16(sp)
    800039d0:	e44e                	sd	s3,8(sp)
    800039d2:	1800                	addi	s0,sp,48
    800039d4:	84aa                	mv	s1,a0
  int r;
  
  acquire(&lk->lk);
    800039d6:	00850913          	addi	s2,a0,8
    800039da:	854a                	mv	a0,s2
    800039dc:	00003097          	auipc	ra,0x3
    800039e0:	c40080e7          	jalr	-960(ra) # 8000661c <acquire>
  r = lk->locked && (lk->pid == myproc()->pid);
    800039e4:	409c                	lw	a5,0(s1)
    800039e6:	ef99                	bnez	a5,80003a04 <holdingsleep+0x3e>
    800039e8:	4481                	li	s1,0
  release(&lk->lk);
    800039ea:	854a                	mv	a0,s2
    800039ec:	00003097          	auipc	ra,0x3
    800039f0:	ce4080e7          	jalr	-796(ra) # 800066d0 <release>
  return r;
}
    800039f4:	8526                	mv	a0,s1
    800039f6:	70a2                	ld	ra,40(sp)
    800039f8:	7402                	ld	s0,32(sp)
    800039fa:	64e2                	ld	s1,24(sp)
    800039fc:	6942                	ld	s2,16(sp)
    800039fe:	69a2                	ld	s3,8(sp)
    80003a00:	6145                	addi	sp,sp,48
    80003a02:	8082                	ret
  r = lk->locked && (lk->pid == myproc()->pid);
    80003a04:	0284a983          	lw	s3,40(s1)
    80003a08:	ffffd097          	auipc	ra,0xffffd
    80003a0c:	45a080e7          	jalr	1114(ra) # 80000e62 <myproc>
    80003a10:	5904                	lw	s1,48(a0)
    80003a12:	413484b3          	sub	s1,s1,s3
    80003a16:	0014b493          	seqz	s1,s1
    80003a1a:	bfc1                	j	800039ea <holdingsleep+0x24>

0000000080003a1c <fileinit>:
    struct spinlock lock;
    struct file file[NFILE];
} ftable;

void fileinit(void)
{
    80003a1c:	1141                	addi	sp,sp,-16
    80003a1e:	e406                	sd	ra,8(sp)
    80003a20:	e022                	sd	s0,0(sp)
    80003a22:	0800                	addi	s0,sp,16
    initlock(&ftable.lock, "ftable");
    80003a24:	00005597          	auipc	a1,0x5
    80003a28:	c9c58593          	addi	a1,a1,-868 # 800086c0 <syscalls+0x248>
    80003a2c:	00027517          	auipc	a0,0x27
    80003a30:	28c50513          	addi	a0,a0,652 # 8002acb8 <ftable>
    80003a34:	00003097          	auipc	ra,0x3
    80003a38:	b58080e7          	jalr	-1192(ra) # 8000658c <initlock>
}
    80003a3c:	60a2                	ld	ra,8(sp)
    80003a3e:	6402                	ld	s0,0(sp)
    80003a40:	0141                	addi	sp,sp,16
    80003a42:	8082                	ret

0000000080003a44 <filealloc>:

// Allocate a file structure.
struct file *
filealloc(void)
{
    80003a44:	1101                	addi	sp,sp,-32
    80003a46:	ec06                	sd	ra,24(sp)
    80003a48:	e822                	sd	s0,16(sp)
    80003a4a:	e426                	sd	s1,8(sp)
    80003a4c:	1000                	addi	s0,sp,32
    struct file *f;

    acquire(&ftable.lock);
    80003a4e:	00027517          	auipc	a0,0x27
    80003a52:	26a50513          	addi	a0,a0,618 # 8002acb8 <ftable>
    80003a56:	00003097          	auipc	ra,0x3
    80003a5a:	bc6080e7          	jalr	-1082(ra) # 8000661c <acquire>
    for (f = ftable.file; f < ftable.file + NFILE; f++)
    80003a5e:	00027497          	auipc	s1,0x27
    80003a62:	27248493          	addi	s1,s1,626 # 8002acd0 <ftable+0x18>
    80003a66:	00028717          	auipc	a4,0x28
    80003a6a:	20a70713          	addi	a4,a4,522 # 8002bc70 <disk>
    {
        if (f->ref == 0)
    80003a6e:	40dc                	lw	a5,4(s1)
    80003a70:	cf99                	beqz	a5,80003a8e <filealloc+0x4a>
    for (f = ftable.file; f < ftable.file + NFILE; f++)
    80003a72:	02848493          	addi	s1,s1,40
    80003a76:	fee49ce3          	bne	s1,a4,80003a6e <filealloc+0x2a>
            f->ref = 1;
            release(&ftable.lock);
            return f;
        }
    }
    release(&ftable.lock);
    80003a7a:	00027517          	auipc	a0,0x27
    80003a7e:	23e50513          	addi	a0,a0,574 # 8002acb8 <ftable>
    80003a82:	00003097          	auipc	ra,0x3
    80003a86:	c4e080e7          	jalr	-946(ra) # 800066d0 <release>
    return 0;
    80003a8a:	4481                	li	s1,0
    80003a8c:	a819                	j	80003aa2 <filealloc+0x5e>
            f->ref = 1;
    80003a8e:	4785                	li	a5,1
    80003a90:	c0dc                	sw	a5,4(s1)
            release(&ftable.lock);
    80003a92:	00027517          	auipc	a0,0x27
    80003a96:	22650513          	addi	a0,a0,550 # 8002acb8 <ftable>
    80003a9a:	00003097          	auipc	ra,0x3
    80003a9e:	c36080e7          	jalr	-970(ra) # 800066d0 <release>
}
    80003aa2:	8526                	mv	a0,s1
    80003aa4:	60e2                	ld	ra,24(sp)
    80003aa6:	6442                	ld	s0,16(sp)
    80003aa8:	64a2                	ld	s1,8(sp)
    80003aaa:	6105                	addi	sp,sp,32
    80003aac:	8082                	ret

0000000080003aae <filedup>:

// Increment ref count for file f.
struct file *
filedup(struct file *f)
{
    80003aae:	1101                	addi	sp,sp,-32
    80003ab0:	ec06                	sd	ra,24(sp)
    80003ab2:	e822                	sd	s0,16(sp)
    80003ab4:	e426                	sd	s1,8(sp)
    80003ab6:	1000                	addi	s0,sp,32
    80003ab8:	84aa                	mv	s1,a0
    acquire(&ftable.lock);
    80003aba:	00027517          	auipc	a0,0x27
    80003abe:	1fe50513          	addi	a0,a0,510 # 8002acb8 <ftable>
    80003ac2:	00003097          	auipc	ra,0x3
    80003ac6:	b5a080e7          	jalr	-1190(ra) # 8000661c <acquire>
    if (f->ref < 1)
    80003aca:	40dc                	lw	a5,4(s1)
    80003acc:	02f05263          	blez	a5,80003af0 <filedup+0x42>
        panic("filedup");
    f->ref++;
    80003ad0:	2785                	addiw	a5,a5,1
    80003ad2:	c0dc                	sw	a5,4(s1)
    release(&ftable.lock);
    80003ad4:	00027517          	auipc	a0,0x27
    80003ad8:	1e450513          	addi	a0,a0,484 # 8002acb8 <ftable>
    80003adc:	00003097          	auipc	ra,0x3
    80003ae0:	bf4080e7          	jalr	-1036(ra) # 800066d0 <release>
    return f;
}
    80003ae4:	8526                	mv	a0,s1
    80003ae6:	60e2                	ld	ra,24(sp)
    80003ae8:	6442                	ld	s0,16(sp)
    80003aea:	64a2                	ld	s1,8(sp)
    80003aec:	6105                	addi	sp,sp,32
    80003aee:	8082                	ret
        panic("filedup");
    80003af0:	00005517          	auipc	a0,0x5
    80003af4:	bd850513          	addi	a0,a0,-1064 # 800086c8 <syscalls+0x250>
    80003af8:	00002097          	auipc	ra,0x2
    80003afc:	5da080e7          	jalr	1498(ra) # 800060d2 <panic>

0000000080003b00 <fileclose>:

// Close file f.  (Decrement ref count, close when reaches 0.)
void fileclose(struct file *f)
{
    80003b00:	7139                	addi	sp,sp,-64
    80003b02:	fc06                	sd	ra,56(sp)
    80003b04:	f822                	sd	s0,48(sp)
    80003b06:	f426                	sd	s1,40(sp)
    80003b08:	f04a                	sd	s2,32(sp)
    80003b0a:	ec4e                	sd	s3,24(sp)
    80003b0c:	e852                	sd	s4,16(sp)
    80003b0e:	e456                	sd	s5,8(sp)
    80003b10:	0080                	addi	s0,sp,64
    80003b12:	84aa                	mv	s1,a0
    struct file ff;

    acquire(&ftable.lock);
    80003b14:	00027517          	auipc	a0,0x27
    80003b18:	1a450513          	addi	a0,a0,420 # 8002acb8 <ftable>
    80003b1c:	00003097          	auipc	ra,0x3
    80003b20:	b00080e7          	jalr	-1280(ra) # 8000661c <acquire>
    if (f->ref < 1)
    80003b24:	40dc                	lw	a5,4(s1)
    80003b26:	06f05163          	blez	a5,80003b88 <fileclose+0x88>
        panic("fileclose");
    if (--f->ref > 0)
    80003b2a:	37fd                	addiw	a5,a5,-1
    80003b2c:	0007871b          	sext.w	a4,a5
    80003b30:	c0dc                	sw	a5,4(s1)
    80003b32:	06e04363          	bgtz	a4,80003b98 <fileclose+0x98>
    {
        release(&ftable.lock);
        return;
    }
    ff = *f;
    80003b36:	0004a903          	lw	s2,0(s1)
    80003b3a:	0094ca83          	lbu	s5,9(s1)
    80003b3e:	0104ba03          	ld	s4,16(s1)
    80003b42:	0184b983          	ld	s3,24(s1)
    f->ref = 0;
    80003b46:	0004a223          	sw	zero,4(s1)
    f->type = FD_NONE;
    80003b4a:	0004a023          	sw	zero,0(s1)
    release(&ftable.lock);
    80003b4e:	00027517          	auipc	a0,0x27
    80003b52:	16a50513          	addi	a0,a0,362 # 8002acb8 <ftable>
    80003b56:	00003097          	auipc	ra,0x3
    80003b5a:	b7a080e7          	jalr	-1158(ra) # 800066d0 <release>

    if (ff.type == FD_PIPE)
    80003b5e:	4785                	li	a5,1
    80003b60:	04f90d63          	beq	s2,a5,80003bba <fileclose+0xba>
    {
        pipeclose(ff.pipe, ff.writable);
    }
    else if (ff.type == FD_INODE || ff.type == FD_DEVICE)
    80003b64:	3979                	addiw	s2,s2,-2
    80003b66:	4785                	li	a5,1
    80003b68:	0527e063          	bltu	a5,s2,80003ba8 <fileclose+0xa8>
    {
        begin_op();
    80003b6c:	00000097          	auipc	ra,0x0
    80003b70:	ac8080e7          	jalr	-1336(ra) # 80003634 <begin_op>
        iput(ff.ip);
    80003b74:	854e                	mv	a0,s3
    80003b76:	fffff097          	auipc	ra,0xfffff
    80003b7a:	2b6080e7          	jalr	694(ra) # 80002e2c <iput>
        end_op();
    80003b7e:	00000097          	auipc	ra,0x0
    80003b82:	b36080e7          	jalr	-1226(ra) # 800036b4 <end_op>
    80003b86:	a00d                	j	80003ba8 <fileclose+0xa8>
        panic("fileclose");
    80003b88:	00005517          	auipc	a0,0x5
    80003b8c:	b4850513          	addi	a0,a0,-1208 # 800086d0 <syscalls+0x258>
    80003b90:	00002097          	auipc	ra,0x2
    80003b94:	542080e7          	jalr	1346(ra) # 800060d2 <panic>
        release(&ftable.lock);
    80003b98:	00027517          	auipc	a0,0x27
    80003b9c:	12050513          	addi	a0,a0,288 # 8002acb8 <ftable>
    80003ba0:	00003097          	auipc	ra,0x3
    80003ba4:	b30080e7          	jalr	-1232(ra) # 800066d0 <release>
    }
}
    80003ba8:	70e2                	ld	ra,56(sp)
    80003baa:	7442                	ld	s0,48(sp)
    80003bac:	74a2                	ld	s1,40(sp)
    80003bae:	7902                	ld	s2,32(sp)
    80003bb0:	69e2                	ld	s3,24(sp)
    80003bb2:	6a42                	ld	s4,16(sp)
    80003bb4:	6aa2                	ld	s5,8(sp)
    80003bb6:	6121                	addi	sp,sp,64
    80003bb8:	8082                	ret
        pipeclose(ff.pipe, ff.writable);
    80003bba:	85d6                	mv	a1,s5
    80003bbc:	8552                	mv	a0,s4
    80003bbe:	00000097          	auipc	ra,0x0
    80003bc2:	3a6080e7          	jalr	934(ra) # 80003f64 <pipeclose>
    80003bc6:	b7cd                	j	80003ba8 <fileclose+0xa8>

0000000080003bc8 <filestat>:

// Get metadata about file f.
// addr is a user virtual address, pointing to a struct stat.
int filestat(struct file *f, uint64 addr)
{
    80003bc8:	715d                	addi	sp,sp,-80
    80003bca:	e486                	sd	ra,72(sp)
    80003bcc:	e0a2                	sd	s0,64(sp)
    80003bce:	fc26                	sd	s1,56(sp)
    80003bd0:	f84a                	sd	s2,48(sp)
    80003bd2:	f44e                	sd	s3,40(sp)
    80003bd4:	0880                	addi	s0,sp,80
    80003bd6:	84aa                	mv	s1,a0
    80003bd8:	89ae                	mv	s3,a1
    struct proc *p = myproc();
    80003bda:	ffffd097          	auipc	ra,0xffffd
    80003bde:	288080e7          	jalr	648(ra) # 80000e62 <myproc>
    struct stat st;

    if (f->type == FD_INODE || f->type == FD_DEVICE)
    80003be2:	409c                	lw	a5,0(s1)
    80003be4:	37f9                	addiw	a5,a5,-2
    80003be6:	4705                	li	a4,1
    80003be8:	04f76763          	bltu	a4,a5,80003c36 <filestat+0x6e>
    80003bec:	892a                	mv	s2,a0
    {
        ilock(f->ip);
    80003bee:	6c88                	ld	a0,24(s1)
    80003bf0:	fffff097          	auipc	ra,0xfffff
    80003bf4:	082080e7          	jalr	130(ra) # 80002c72 <ilock>
        stati(f->ip, &st);
    80003bf8:	fb840593          	addi	a1,s0,-72
    80003bfc:	6c88                	ld	a0,24(s1)
    80003bfe:	fffff097          	auipc	ra,0xfffff
    80003c02:	2fe080e7          	jalr	766(ra) # 80002efc <stati>
        iunlock(f->ip);
    80003c06:	6c88                	ld	a0,24(s1)
    80003c08:	fffff097          	auipc	ra,0xfffff
    80003c0c:	12c080e7          	jalr	300(ra) # 80002d34 <iunlock>
        if (copyout(p->pagetable, addr, (char *)&st, sizeof(st)) < 0)
    80003c10:	46e1                	li	a3,24
    80003c12:	fb840613          	addi	a2,s0,-72
    80003c16:	85ce                	mv	a1,s3
    80003c18:	05093503          	ld	a0,80(s2)
    80003c1c:	ffffd097          	auipc	ra,0xffffd
    80003c20:	f04080e7          	jalr	-252(ra) # 80000b20 <copyout>
    80003c24:	41f5551b          	sraiw	a0,a0,0x1f
            return -1;
        return 0;
    }
    return -1;
}
    80003c28:	60a6                	ld	ra,72(sp)
    80003c2a:	6406                	ld	s0,64(sp)
    80003c2c:	74e2                	ld	s1,56(sp)
    80003c2e:	7942                	ld	s2,48(sp)
    80003c30:	79a2                	ld	s3,40(sp)
    80003c32:	6161                	addi	sp,sp,80
    80003c34:	8082                	ret
    return -1;
    80003c36:	557d                	li	a0,-1
    80003c38:	bfc5                	j	80003c28 <filestat+0x60>

0000000080003c3a <mapfile>:

void mapfile(struct file *f, char *mem, int offset)
{
    80003c3a:	7179                	addi	sp,sp,-48
    80003c3c:	f406                	sd	ra,40(sp)
    80003c3e:	f022                	sd	s0,32(sp)
    80003c40:	ec26                	sd	s1,24(sp)
    80003c42:	e84a                	sd	s2,16(sp)
    80003c44:	e44e                	sd	s3,8(sp)
    80003c46:	1800                	addi	s0,sp,48
    80003c48:	84aa                	mv	s1,a0
    80003c4a:	89ae                	mv	s3,a1
    80003c4c:	8932                	mv	s2,a2
    printf("off %d\n", offset);
    80003c4e:	85b2                	mv	a1,a2
    80003c50:	00005517          	auipc	a0,0x5
    80003c54:	a9050513          	addi	a0,a0,-1392 # 800086e0 <syscalls+0x268>
    80003c58:	00002097          	auipc	ra,0x2
    80003c5c:	4c4080e7          	jalr	1220(ra) # 8000611c <printf>
    ilock(f->ip);
    80003c60:	6c88                	ld	a0,24(s1)
    80003c62:	fffff097          	auipc	ra,0xfffff
    80003c66:	010080e7          	jalr	16(ra) # 80002c72 <ilock>
    // printf("[Testing] (mapfile) : finish ilock\n");
    readi(f->ip, 0, (uint64)mem, offset, PGSIZE);
    80003c6a:	6705                	lui	a4,0x1
    80003c6c:	86ca                	mv	a3,s2
    80003c6e:	864e                	mv	a2,s3
    80003c70:	4581                	li	a1,0
    80003c72:	6c88                	ld	a0,24(s1)
    80003c74:	fffff097          	auipc	ra,0xfffff
    80003c78:	2b2080e7          	jalr	690(ra) # 80002f26 <readi>
    // printf("[Testing] (mapfile) : finish readi\n");
    iunlock(f->ip);
    80003c7c:	6c88                	ld	a0,24(s1)
    80003c7e:	fffff097          	auipc	ra,0xfffff
    80003c82:	0b6080e7          	jalr	182(ra) # 80002d34 <iunlock>
    // printf("[Testing] (mapfile) : finish iunlock\n");
}
    80003c86:	70a2                	ld	ra,40(sp)
    80003c88:	7402                	ld	s0,32(sp)
    80003c8a:	64e2                	ld	s1,24(sp)
    80003c8c:	6942                	ld	s2,16(sp)
    80003c8e:	69a2                	ld	s3,8(sp)
    80003c90:	6145                	addi	sp,sp,48
    80003c92:	8082                	ret

0000000080003c94 <fileread>:

// Read from file f.
// addr is a user virtual address.
int fileread(struct file *f, uint64 addr, int n)
{
    80003c94:	7179                	addi	sp,sp,-48
    80003c96:	f406                	sd	ra,40(sp)
    80003c98:	f022                	sd	s0,32(sp)
    80003c9a:	ec26                	sd	s1,24(sp)
    80003c9c:	e84a                	sd	s2,16(sp)
    80003c9e:	e44e                	sd	s3,8(sp)
    80003ca0:	1800                	addi	s0,sp,48
    int r = 0;

    if (f->readable == 0)
    80003ca2:	00854783          	lbu	a5,8(a0)
    80003ca6:	c3d5                	beqz	a5,80003d4a <fileread+0xb6>
    80003ca8:	84aa                	mv	s1,a0
    80003caa:	89ae                	mv	s3,a1
    80003cac:	8932                	mv	s2,a2
        return -1;

    if (f->type == FD_PIPE)
    80003cae:	411c                	lw	a5,0(a0)
    80003cb0:	4705                	li	a4,1
    80003cb2:	04e78963          	beq	a5,a4,80003d04 <fileread+0x70>
    {
        r = piperead(f->pipe, addr, n);
    }
    else if (f->type == FD_DEVICE)
    80003cb6:	470d                	li	a4,3
    80003cb8:	04e78d63          	beq	a5,a4,80003d12 <fileread+0x7e>
    {
        if (f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
            return -1;
        r = devsw[f->major].read(1, addr, n);
    }
    else if (f->type == FD_INODE)
    80003cbc:	4709                	li	a4,2
    80003cbe:	06e79e63          	bne	a5,a4,80003d3a <fileread+0xa6>
    {
        ilock(f->ip);
    80003cc2:	6d08                	ld	a0,24(a0)
    80003cc4:	fffff097          	auipc	ra,0xfffff
    80003cc8:	fae080e7          	jalr	-82(ra) # 80002c72 <ilock>
        if ((r = readi(f->ip, 1, addr, f->off, n)) > 0)
    80003ccc:	874a                	mv	a4,s2
    80003cce:	5094                	lw	a3,32(s1)
    80003cd0:	864e                	mv	a2,s3
    80003cd2:	4585                	li	a1,1
    80003cd4:	6c88                	ld	a0,24(s1)
    80003cd6:	fffff097          	auipc	ra,0xfffff
    80003cda:	250080e7          	jalr	592(ra) # 80002f26 <readi>
    80003cde:	892a                	mv	s2,a0
    80003ce0:	00a05563          	blez	a0,80003cea <fileread+0x56>
            f->off += r;
    80003ce4:	509c                	lw	a5,32(s1)
    80003ce6:	9fa9                	addw	a5,a5,a0
    80003ce8:	d09c                	sw	a5,32(s1)
        iunlock(f->ip);
    80003cea:	6c88                	ld	a0,24(s1)
    80003cec:	fffff097          	auipc	ra,0xfffff
    80003cf0:	048080e7          	jalr	72(ra) # 80002d34 <iunlock>
    {
        panic("fileread");
    }

    return r;
}
    80003cf4:	854a                	mv	a0,s2
    80003cf6:	70a2                	ld	ra,40(sp)
    80003cf8:	7402                	ld	s0,32(sp)
    80003cfa:	64e2                	ld	s1,24(sp)
    80003cfc:	6942                	ld	s2,16(sp)
    80003cfe:	69a2                	ld	s3,8(sp)
    80003d00:	6145                	addi	sp,sp,48
    80003d02:	8082                	ret
        r = piperead(f->pipe, addr, n);
    80003d04:	6908                	ld	a0,16(a0)
    80003d06:	00000097          	auipc	ra,0x0
    80003d0a:	3ce080e7          	jalr	974(ra) # 800040d4 <piperead>
    80003d0e:	892a                	mv	s2,a0
    80003d10:	b7d5                	j	80003cf4 <fileread+0x60>
        if (f->major < 0 || f->major >= NDEV || !devsw[f->major].read)
    80003d12:	02451783          	lh	a5,36(a0)
    80003d16:	03079693          	slli	a3,a5,0x30
    80003d1a:	92c1                	srli	a3,a3,0x30
    80003d1c:	4725                	li	a4,9
    80003d1e:	02d76863          	bltu	a4,a3,80003d4e <fileread+0xba>
    80003d22:	0792                	slli	a5,a5,0x4
    80003d24:	00027717          	auipc	a4,0x27
    80003d28:	ef470713          	addi	a4,a4,-268 # 8002ac18 <devsw>
    80003d2c:	97ba                	add	a5,a5,a4
    80003d2e:	639c                	ld	a5,0(a5)
    80003d30:	c38d                	beqz	a5,80003d52 <fileread+0xbe>
        r = devsw[f->major].read(1, addr, n);
    80003d32:	4505                	li	a0,1
    80003d34:	9782                	jalr	a5
    80003d36:	892a                	mv	s2,a0
    80003d38:	bf75                	j	80003cf4 <fileread+0x60>
        panic("fileread");
    80003d3a:	00005517          	auipc	a0,0x5
    80003d3e:	9ae50513          	addi	a0,a0,-1618 # 800086e8 <syscalls+0x270>
    80003d42:	00002097          	auipc	ra,0x2
    80003d46:	390080e7          	jalr	912(ra) # 800060d2 <panic>
        return -1;
    80003d4a:	597d                	li	s2,-1
    80003d4c:	b765                	j	80003cf4 <fileread+0x60>
            return -1;
    80003d4e:	597d                	li	s2,-1
    80003d50:	b755                	j	80003cf4 <fileread+0x60>
    80003d52:	597d                	li	s2,-1
    80003d54:	b745                	j	80003cf4 <fileread+0x60>

0000000080003d56 <filewrite>:

// Write to file f.
// addr is a user virtual address.
int filewrite(struct file *f, uint64 addr, int n)
{
    80003d56:	715d                	addi	sp,sp,-80
    80003d58:	e486                	sd	ra,72(sp)
    80003d5a:	e0a2                	sd	s0,64(sp)
    80003d5c:	fc26                	sd	s1,56(sp)
    80003d5e:	f84a                	sd	s2,48(sp)
    80003d60:	f44e                	sd	s3,40(sp)
    80003d62:	f052                	sd	s4,32(sp)
    80003d64:	ec56                	sd	s5,24(sp)
    80003d66:	e85a                	sd	s6,16(sp)
    80003d68:	e45e                	sd	s7,8(sp)
    80003d6a:	e062                	sd	s8,0(sp)
    80003d6c:	0880                	addi	s0,sp,80
    int r, ret = 0;

    if (f->writable == 0)
    80003d6e:	00954783          	lbu	a5,9(a0)
    80003d72:	10078663          	beqz	a5,80003e7e <filewrite+0x128>
    80003d76:	892a                	mv	s2,a0
    80003d78:	8aae                	mv	s5,a1
    80003d7a:	8a32                	mv	s4,a2
        return -1;

    if (f->type == FD_PIPE)
    80003d7c:	411c                	lw	a5,0(a0)
    80003d7e:	4705                	li	a4,1
    80003d80:	02e78263          	beq	a5,a4,80003da4 <filewrite+0x4e>
    {
        ret = pipewrite(f->pipe, addr, n);
    }
    else if (f->type == FD_DEVICE)
    80003d84:	470d                	li	a4,3
    80003d86:	02e78663          	beq	a5,a4,80003db2 <filewrite+0x5c>
    {
        if (f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
            return -1;
        ret = devsw[f->major].write(1, addr, n);
    }
    else if (f->type == FD_INODE)
    80003d8a:	4709                	li	a4,2
    80003d8c:	0ee79163          	bne	a5,a4,80003e6e <filewrite+0x118>
        // and 2 blocks of slop for non-aligned writes.
        // this really belongs lower down, since writei()
        // might be writing a device like the console.
        int max = ((MAXOPBLOCKS - 1 - 1 - 2) / 2) * BSIZE;
        int i = 0;
        while (i < n)
    80003d90:	0ac05d63          	blez	a2,80003e4a <filewrite+0xf4>
        int i = 0;
    80003d94:	4981                	li	s3,0
    80003d96:	6b05                	lui	s6,0x1
    80003d98:	c00b0b13          	addi	s6,s6,-1024 # c00 <_entry-0x7ffff400>
    80003d9c:	6b85                	lui	s7,0x1
    80003d9e:	c00b8b9b          	addiw	s7,s7,-1024
    80003da2:	a861                	j	80003e3a <filewrite+0xe4>
        ret = pipewrite(f->pipe, addr, n);
    80003da4:	6908                	ld	a0,16(a0)
    80003da6:	00000097          	auipc	ra,0x0
    80003daa:	22e080e7          	jalr	558(ra) # 80003fd4 <pipewrite>
    80003dae:	8a2a                	mv	s4,a0
    80003db0:	a045                	j	80003e50 <filewrite+0xfa>
        if (f->major < 0 || f->major >= NDEV || !devsw[f->major].write)
    80003db2:	02451783          	lh	a5,36(a0)
    80003db6:	03079693          	slli	a3,a5,0x30
    80003dba:	92c1                	srli	a3,a3,0x30
    80003dbc:	4725                	li	a4,9
    80003dbe:	0cd76263          	bltu	a4,a3,80003e82 <filewrite+0x12c>
    80003dc2:	0792                	slli	a5,a5,0x4
    80003dc4:	00027717          	auipc	a4,0x27
    80003dc8:	e5470713          	addi	a4,a4,-428 # 8002ac18 <devsw>
    80003dcc:	97ba                	add	a5,a5,a4
    80003dce:	679c                	ld	a5,8(a5)
    80003dd0:	cbdd                	beqz	a5,80003e86 <filewrite+0x130>
        ret = devsw[f->major].write(1, addr, n);
    80003dd2:	4505                	li	a0,1
    80003dd4:	9782                	jalr	a5
    80003dd6:	8a2a                	mv	s4,a0
    80003dd8:	a8a5                	j	80003e50 <filewrite+0xfa>
    80003dda:	00048c1b          	sext.w	s8,s1
        {
            int n1 = n - i;
            if (n1 > max)
                n1 = max;

            begin_op();
    80003dde:	00000097          	auipc	ra,0x0
    80003de2:	856080e7          	jalr	-1962(ra) # 80003634 <begin_op>
            ilock(f->ip);
    80003de6:	01893503          	ld	a0,24(s2)
    80003dea:	fffff097          	auipc	ra,0xfffff
    80003dee:	e88080e7          	jalr	-376(ra) # 80002c72 <ilock>
            if ((r = writei(f->ip, 1, addr + i, f->off, n1)) > 0)
    80003df2:	8762                	mv	a4,s8
    80003df4:	02092683          	lw	a3,32(s2)
    80003df8:	01598633          	add	a2,s3,s5
    80003dfc:	4585                	li	a1,1
    80003dfe:	01893503          	ld	a0,24(s2)
    80003e02:	fffff097          	auipc	ra,0xfffff
    80003e06:	21c080e7          	jalr	540(ra) # 8000301e <writei>
    80003e0a:	84aa                	mv	s1,a0
    80003e0c:	00a05763          	blez	a0,80003e1a <filewrite+0xc4>
                f->off += r;
    80003e10:	02092783          	lw	a5,32(s2)
    80003e14:	9fa9                	addw	a5,a5,a0
    80003e16:	02f92023          	sw	a5,32(s2)
            iunlock(f->ip);
    80003e1a:	01893503          	ld	a0,24(s2)
    80003e1e:	fffff097          	auipc	ra,0xfffff
    80003e22:	f16080e7          	jalr	-234(ra) # 80002d34 <iunlock>
            end_op();
    80003e26:	00000097          	auipc	ra,0x0
    80003e2a:	88e080e7          	jalr	-1906(ra) # 800036b4 <end_op>

            if (r != n1)
    80003e2e:	009c1f63          	bne	s8,s1,80003e4c <filewrite+0xf6>
            {
                // error from writei
                break;
            }
            i += r;
    80003e32:	013489bb          	addw	s3,s1,s3
        while (i < n)
    80003e36:	0149db63          	bge	s3,s4,80003e4c <filewrite+0xf6>
            int n1 = n - i;
    80003e3a:	413a07bb          	subw	a5,s4,s3
            if (n1 > max)
    80003e3e:	84be                	mv	s1,a5
    80003e40:	2781                	sext.w	a5,a5
    80003e42:	f8fb5ce3          	bge	s6,a5,80003dda <filewrite+0x84>
    80003e46:	84de                	mv	s1,s7
    80003e48:	bf49                	j	80003dda <filewrite+0x84>
        int i = 0;
    80003e4a:	4981                	li	s3,0
        }
        ret = (i == n ? n : -1);
    80003e4c:	013a1f63          	bne	s4,s3,80003e6a <filewrite+0x114>
    {
        panic("filewrite");
    }

    return ret;
}
    80003e50:	8552                	mv	a0,s4
    80003e52:	60a6                	ld	ra,72(sp)
    80003e54:	6406                	ld	s0,64(sp)
    80003e56:	74e2                	ld	s1,56(sp)
    80003e58:	7942                	ld	s2,48(sp)
    80003e5a:	79a2                	ld	s3,40(sp)
    80003e5c:	7a02                	ld	s4,32(sp)
    80003e5e:	6ae2                	ld	s5,24(sp)
    80003e60:	6b42                	ld	s6,16(sp)
    80003e62:	6ba2                	ld	s7,8(sp)
    80003e64:	6c02                	ld	s8,0(sp)
    80003e66:	6161                	addi	sp,sp,80
    80003e68:	8082                	ret
        ret = (i == n ? n : -1);
    80003e6a:	5a7d                	li	s4,-1
    80003e6c:	b7d5                	j	80003e50 <filewrite+0xfa>
        panic("filewrite");
    80003e6e:	00005517          	auipc	a0,0x5
    80003e72:	88a50513          	addi	a0,a0,-1910 # 800086f8 <syscalls+0x280>
    80003e76:	00002097          	auipc	ra,0x2
    80003e7a:	25c080e7          	jalr	604(ra) # 800060d2 <panic>
        return -1;
    80003e7e:	5a7d                	li	s4,-1
    80003e80:	bfc1                	j	80003e50 <filewrite+0xfa>
            return -1;
    80003e82:	5a7d                	li	s4,-1
    80003e84:	b7f1                	j	80003e50 <filewrite+0xfa>
    80003e86:	5a7d                	li	s4,-1
    80003e88:	b7e1                	j	80003e50 <filewrite+0xfa>

0000000080003e8a <pipealloc>:
  int writeopen;  // write fd is still open
};

int
pipealloc(struct file **f0, struct file **f1)
{
    80003e8a:	7179                	addi	sp,sp,-48
    80003e8c:	f406                	sd	ra,40(sp)
    80003e8e:	f022                	sd	s0,32(sp)
    80003e90:	ec26                	sd	s1,24(sp)
    80003e92:	e84a                	sd	s2,16(sp)
    80003e94:	e44e                	sd	s3,8(sp)
    80003e96:	e052                	sd	s4,0(sp)
    80003e98:	1800                	addi	s0,sp,48
    80003e9a:	84aa                	mv	s1,a0
    80003e9c:	8a2e                	mv	s4,a1
  struct pipe *pi;

  pi = 0;
  *f0 = *f1 = 0;
    80003e9e:	0005b023          	sd	zero,0(a1)
    80003ea2:	00053023          	sd	zero,0(a0)
  if((*f0 = filealloc()) == 0 || (*f1 = filealloc()) == 0)
    80003ea6:	00000097          	auipc	ra,0x0
    80003eaa:	b9e080e7          	jalr	-1122(ra) # 80003a44 <filealloc>
    80003eae:	e088                	sd	a0,0(s1)
    80003eb0:	c551                	beqz	a0,80003f3c <pipealloc+0xb2>
    80003eb2:	00000097          	auipc	ra,0x0
    80003eb6:	b92080e7          	jalr	-1134(ra) # 80003a44 <filealloc>
    80003eba:	00aa3023          	sd	a0,0(s4)
    80003ebe:	c92d                	beqz	a0,80003f30 <pipealloc+0xa6>
    goto bad;
  if((pi = (struct pipe*)kalloc()) == 0)
    80003ec0:	ffffc097          	auipc	ra,0xffffc
    80003ec4:	258080e7          	jalr	600(ra) # 80000118 <kalloc>
    80003ec8:	892a                	mv	s2,a0
    80003eca:	c125                	beqz	a0,80003f2a <pipealloc+0xa0>
    goto bad;
  pi->readopen = 1;
    80003ecc:	4985                	li	s3,1
    80003ece:	23352023          	sw	s3,544(a0)
  pi->writeopen = 1;
    80003ed2:	23352223          	sw	s3,548(a0)
  pi->nwrite = 0;
    80003ed6:	20052e23          	sw	zero,540(a0)
  pi->nread = 0;
    80003eda:	20052c23          	sw	zero,536(a0)
  initlock(&pi->lock, "pipe");
    80003ede:	00005597          	auipc	a1,0x5
    80003ee2:	82a58593          	addi	a1,a1,-2006 # 80008708 <syscalls+0x290>
    80003ee6:	00002097          	auipc	ra,0x2
    80003eea:	6a6080e7          	jalr	1702(ra) # 8000658c <initlock>
  (*f0)->type = FD_PIPE;
    80003eee:	609c                	ld	a5,0(s1)
    80003ef0:	0137a023          	sw	s3,0(a5)
  (*f0)->readable = 1;
    80003ef4:	609c                	ld	a5,0(s1)
    80003ef6:	01378423          	sb	s3,8(a5)
  (*f0)->writable = 0;
    80003efa:	609c                	ld	a5,0(s1)
    80003efc:	000784a3          	sb	zero,9(a5)
  (*f0)->pipe = pi;
    80003f00:	609c                	ld	a5,0(s1)
    80003f02:	0127b823          	sd	s2,16(a5)
  (*f1)->type = FD_PIPE;
    80003f06:	000a3783          	ld	a5,0(s4)
    80003f0a:	0137a023          	sw	s3,0(a5)
  (*f1)->readable = 0;
    80003f0e:	000a3783          	ld	a5,0(s4)
    80003f12:	00078423          	sb	zero,8(a5)
  (*f1)->writable = 1;
    80003f16:	000a3783          	ld	a5,0(s4)
    80003f1a:	013784a3          	sb	s3,9(a5)
  (*f1)->pipe = pi;
    80003f1e:	000a3783          	ld	a5,0(s4)
    80003f22:	0127b823          	sd	s2,16(a5)
  return 0;
    80003f26:	4501                	li	a0,0
    80003f28:	a025                	j	80003f50 <pipealloc+0xc6>

 bad:
  if(pi)
    kfree((char*)pi);
  if(*f0)
    80003f2a:	6088                	ld	a0,0(s1)
    80003f2c:	e501                	bnez	a0,80003f34 <pipealloc+0xaa>
    80003f2e:	a039                	j	80003f3c <pipealloc+0xb2>
    80003f30:	6088                	ld	a0,0(s1)
    80003f32:	c51d                	beqz	a0,80003f60 <pipealloc+0xd6>
    fileclose(*f0);
    80003f34:	00000097          	auipc	ra,0x0
    80003f38:	bcc080e7          	jalr	-1076(ra) # 80003b00 <fileclose>
  if(*f1)
    80003f3c:	000a3783          	ld	a5,0(s4)
    fileclose(*f1);
  return -1;
    80003f40:	557d                	li	a0,-1
  if(*f1)
    80003f42:	c799                	beqz	a5,80003f50 <pipealloc+0xc6>
    fileclose(*f1);
    80003f44:	853e                	mv	a0,a5
    80003f46:	00000097          	auipc	ra,0x0
    80003f4a:	bba080e7          	jalr	-1094(ra) # 80003b00 <fileclose>
  return -1;
    80003f4e:	557d                	li	a0,-1
}
    80003f50:	70a2                	ld	ra,40(sp)
    80003f52:	7402                	ld	s0,32(sp)
    80003f54:	64e2                	ld	s1,24(sp)
    80003f56:	6942                	ld	s2,16(sp)
    80003f58:	69a2                	ld	s3,8(sp)
    80003f5a:	6a02                	ld	s4,0(sp)
    80003f5c:	6145                	addi	sp,sp,48
    80003f5e:	8082                	ret
  return -1;
    80003f60:	557d                	li	a0,-1
    80003f62:	b7fd                	j	80003f50 <pipealloc+0xc6>

0000000080003f64 <pipeclose>:

void
pipeclose(struct pipe *pi, int writable)
{
    80003f64:	1101                	addi	sp,sp,-32
    80003f66:	ec06                	sd	ra,24(sp)
    80003f68:	e822                	sd	s0,16(sp)
    80003f6a:	e426                	sd	s1,8(sp)
    80003f6c:	e04a                	sd	s2,0(sp)
    80003f6e:	1000                	addi	s0,sp,32
    80003f70:	84aa                	mv	s1,a0
    80003f72:	892e                	mv	s2,a1
  acquire(&pi->lock);
    80003f74:	00002097          	auipc	ra,0x2
    80003f78:	6a8080e7          	jalr	1704(ra) # 8000661c <acquire>
  if(writable){
    80003f7c:	02090d63          	beqz	s2,80003fb6 <pipeclose+0x52>
    pi->writeopen = 0;
    80003f80:	2204a223          	sw	zero,548(s1)
    wakeup(&pi->nread);
    80003f84:	21848513          	addi	a0,s1,536
    80003f88:	ffffd097          	auipc	ra,0xffffd
    80003f8c:	622080e7          	jalr	1570(ra) # 800015aa <wakeup>
  } else {
    pi->readopen = 0;
    wakeup(&pi->nwrite);
  }
  if(pi->readopen == 0 && pi->writeopen == 0){
    80003f90:	2204b783          	ld	a5,544(s1)
    80003f94:	eb95                	bnez	a5,80003fc8 <pipeclose+0x64>
    release(&pi->lock);
    80003f96:	8526                	mv	a0,s1
    80003f98:	00002097          	auipc	ra,0x2
    80003f9c:	738080e7          	jalr	1848(ra) # 800066d0 <release>
    kfree((char*)pi);
    80003fa0:	8526                	mv	a0,s1
    80003fa2:	ffffc097          	auipc	ra,0xffffc
    80003fa6:	07a080e7          	jalr	122(ra) # 8000001c <kfree>
  } else
    release(&pi->lock);
}
    80003faa:	60e2                	ld	ra,24(sp)
    80003fac:	6442                	ld	s0,16(sp)
    80003fae:	64a2                	ld	s1,8(sp)
    80003fb0:	6902                	ld	s2,0(sp)
    80003fb2:	6105                	addi	sp,sp,32
    80003fb4:	8082                	ret
    pi->readopen = 0;
    80003fb6:	2204a023          	sw	zero,544(s1)
    wakeup(&pi->nwrite);
    80003fba:	21c48513          	addi	a0,s1,540
    80003fbe:	ffffd097          	auipc	ra,0xffffd
    80003fc2:	5ec080e7          	jalr	1516(ra) # 800015aa <wakeup>
    80003fc6:	b7e9                	j	80003f90 <pipeclose+0x2c>
    release(&pi->lock);
    80003fc8:	8526                	mv	a0,s1
    80003fca:	00002097          	auipc	ra,0x2
    80003fce:	706080e7          	jalr	1798(ra) # 800066d0 <release>
}
    80003fd2:	bfe1                	j	80003faa <pipeclose+0x46>

0000000080003fd4 <pipewrite>:

int
pipewrite(struct pipe *pi, uint64 addr, int n)
{
    80003fd4:	7159                	addi	sp,sp,-112
    80003fd6:	f486                	sd	ra,104(sp)
    80003fd8:	f0a2                	sd	s0,96(sp)
    80003fda:	eca6                	sd	s1,88(sp)
    80003fdc:	e8ca                	sd	s2,80(sp)
    80003fde:	e4ce                	sd	s3,72(sp)
    80003fe0:	e0d2                	sd	s4,64(sp)
    80003fe2:	fc56                	sd	s5,56(sp)
    80003fe4:	f85a                	sd	s6,48(sp)
    80003fe6:	f45e                	sd	s7,40(sp)
    80003fe8:	f062                	sd	s8,32(sp)
    80003fea:	ec66                	sd	s9,24(sp)
    80003fec:	1880                	addi	s0,sp,112
    80003fee:	84aa                	mv	s1,a0
    80003ff0:	8aae                	mv	s5,a1
    80003ff2:	8a32                	mv	s4,a2
  int i = 0;
  struct proc *pr = myproc();
    80003ff4:	ffffd097          	auipc	ra,0xffffd
    80003ff8:	e6e080e7          	jalr	-402(ra) # 80000e62 <myproc>
    80003ffc:	89aa                	mv	s3,a0

  acquire(&pi->lock);
    80003ffe:	8526                	mv	a0,s1
    80004000:	00002097          	auipc	ra,0x2
    80004004:	61c080e7          	jalr	1564(ra) # 8000661c <acquire>
  while(i < n){
    80004008:	0d405463          	blez	s4,800040d0 <pipewrite+0xfc>
    8000400c:	8ba6                	mv	s7,s1
  int i = 0;
    8000400e:	4901                	li	s2,0
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
      wakeup(&pi->nread);
      sleep(&pi->nwrite, &pi->lock);
    } else {
      char ch;
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    80004010:	5b7d                	li	s6,-1
      wakeup(&pi->nread);
    80004012:	21848c93          	addi	s9,s1,536
      sleep(&pi->nwrite, &pi->lock);
    80004016:	21c48c13          	addi	s8,s1,540
    8000401a:	a08d                	j	8000407c <pipewrite+0xa8>
      release(&pi->lock);
    8000401c:	8526                	mv	a0,s1
    8000401e:	00002097          	auipc	ra,0x2
    80004022:	6b2080e7          	jalr	1714(ra) # 800066d0 <release>
      return -1;
    80004026:	597d                	li	s2,-1
  }
  wakeup(&pi->nread);
  release(&pi->lock);

  return i;
}
    80004028:	854a                	mv	a0,s2
    8000402a:	70a6                	ld	ra,104(sp)
    8000402c:	7406                	ld	s0,96(sp)
    8000402e:	64e6                	ld	s1,88(sp)
    80004030:	6946                	ld	s2,80(sp)
    80004032:	69a6                	ld	s3,72(sp)
    80004034:	6a06                	ld	s4,64(sp)
    80004036:	7ae2                	ld	s5,56(sp)
    80004038:	7b42                	ld	s6,48(sp)
    8000403a:	7ba2                	ld	s7,40(sp)
    8000403c:	7c02                	ld	s8,32(sp)
    8000403e:	6ce2                	ld	s9,24(sp)
    80004040:	6165                	addi	sp,sp,112
    80004042:	8082                	ret
      wakeup(&pi->nread);
    80004044:	8566                	mv	a0,s9
    80004046:	ffffd097          	auipc	ra,0xffffd
    8000404a:	564080e7          	jalr	1380(ra) # 800015aa <wakeup>
      sleep(&pi->nwrite, &pi->lock);
    8000404e:	85de                	mv	a1,s7
    80004050:	8562                	mv	a0,s8
    80004052:	ffffd097          	auipc	ra,0xffffd
    80004056:	4f4080e7          	jalr	1268(ra) # 80001546 <sleep>
    8000405a:	a839                	j	80004078 <pipewrite+0xa4>
      pi->data[pi->nwrite++ % PIPESIZE] = ch;
    8000405c:	21c4a783          	lw	a5,540(s1)
    80004060:	0017871b          	addiw	a4,a5,1
    80004064:	20e4ae23          	sw	a4,540(s1)
    80004068:	1ff7f793          	andi	a5,a5,511
    8000406c:	97a6                	add	a5,a5,s1
    8000406e:	f9f44703          	lbu	a4,-97(s0)
    80004072:	00e78c23          	sb	a4,24(a5)
      i++;
    80004076:	2905                	addiw	s2,s2,1
  while(i < n){
    80004078:	05495063          	bge	s2,s4,800040b8 <pipewrite+0xe4>
    if(pi->readopen == 0 || killed(pr)){
    8000407c:	2204a783          	lw	a5,544(s1)
    80004080:	dfd1                	beqz	a5,8000401c <pipewrite+0x48>
    80004082:	854e                	mv	a0,s3
    80004084:	ffffd097          	auipc	ra,0xffffd
    80004088:	76a080e7          	jalr	1898(ra) # 800017ee <killed>
    8000408c:	f941                	bnez	a0,8000401c <pipewrite+0x48>
    if(pi->nwrite == pi->nread + PIPESIZE){ //DOC: pipewrite-full
    8000408e:	2184a783          	lw	a5,536(s1)
    80004092:	21c4a703          	lw	a4,540(s1)
    80004096:	2007879b          	addiw	a5,a5,512
    8000409a:	faf705e3          	beq	a4,a5,80004044 <pipewrite+0x70>
      if(copyin(pr->pagetable, &ch, addr + i, 1) == -1)
    8000409e:	4685                	li	a3,1
    800040a0:	01590633          	add	a2,s2,s5
    800040a4:	f9f40593          	addi	a1,s0,-97
    800040a8:	0509b503          	ld	a0,80(s3)
    800040ac:	ffffd097          	auipc	ra,0xffffd
    800040b0:	b00080e7          	jalr	-1280(ra) # 80000bac <copyin>
    800040b4:	fb6514e3          	bne	a0,s6,8000405c <pipewrite+0x88>
  wakeup(&pi->nread);
    800040b8:	21848513          	addi	a0,s1,536
    800040bc:	ffffd097          	auipc	ra,0xffffd
    800040c0:	4ee080e7          	jalr	1262(ra) # 800015aa <wakeup>
  release(&pi->lock);
    800040c4:	8526                	mv	a0,s1
    800040c6:	00002097          	auipc	ra,0x2
    800040ca:	60a080e7          	jalr	1546(ra) # 800066d0 <release>
  return i;
    800040ce:	bfa9                	j	80004028 <pipewrite+0x54>
  int i = 0;
    800040d0:	4901                	li	s2,0
    800040d2:	b7dd                	j	800040b8 <pipewrite+0xe4>

00000000800040d4 <piperead>:

int
piperead(struct pipe *pi, uint64 addr, int n)
{
    800040d4:	715d                	addi	sp,sp,-80
    800040d6:	e486                	sd	ra,72(sp)
    800040d8:	e0a2                	sd	s0,64(sp)
    800040da:	fc26                	sd	s1,56(sp)
    800040dc:	f84a                	sd	s2,48(sp)
    800040de:	f44e                	sd	s3,40(sp)
    800040e0:	f052                	sd	s4,32(sp)
    800040e2:	ec56                	sd	s5,24(sp)
    800040e4:	e85a                	sd	s6,16(sp)
    800040e6:	0880                	addi	s0,sp,80
    800040e8:	84aa                	mv	s1,a0
    800040ea:	892e                	mv	s2,a1
    800040ec:	8ab2                	mv	s5,a2
  int i;
  struct proc *pr = myproc();
    800040ee:	ffffd097          	auipc	ra,0xffffd
    800040f2:	d74080e7          	jalr	-652(ra) # 80000e62 <myproc>
    800040f6:	8a2a                	mv	s4,a0
  char ch;

  acquire(&pi->lock);
    800040f8:	8b26                	mv	s6,s1
    800040fa:	8526                	mv	a0,s1
    800040fc:	00002097          	auipc	ra,0x2
    80004100:	520080e7          	jalr	1312(ra) # 8000661c <acquire>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004104:	2184a703          	lw	a4,536(s1)
    80004108:	21c4a783          	lw	a5,540(s1)
    if(killed(pr)){
      release(&pi->lock);
      return -1;
    }
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    8000410c:	21848993          	addi	s3,s1,536
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004110:	02f71763          	bne	a4,a5,8000413e <piperead+0x6a>
    80004114:	2244a783          	lw	a5,548(s1)
    80004118:	c39d                	beqz	a5,8000413e <piperead+0x6a>
    if(killed(pr)){
    8000411a:	8552                	mv	a0,s4
    8000411c:	ffffd097          	auipc	ra,0xffffd
    80004120:	6d2080e7          	jalr	1746(ra) # 800017ee <killed>
    80004124:	e941                	bnez	a0,800041b4 <piperead+0xe0>
    sleep(&pi->nread, &pi->lock); //DOC: piperead-sleep
    80004126:	85da                	mv	a1,s6
    80004128:	854e                	mv	a0,s3
    8000412a:	ffffd097          	auipc	ra,0xffffd
    8000412e:	41c080e7          	jalr	1052(ra) # 80001546 <sleep>
  while(pi->nread == pi->nwrite && pi->writeopen){  //DOC: pipe-empty
    80004132:	2184a703          	lw	a4,536(s1)
    80004136:	21c4a783          	lw	a5,540(s1)
    8000413a:	fcf70de3          	beq	a4,a5,80004114 <piperead+0x40>
  }
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    8000413e:	09505263          	blez	s5,800041c2 <piperead+0xee>
    80004142:	4981                	li	s3,0
    if(pi->nread == pi->nwrite)
      break;
    ch = pi->data[pi->nread++ % PIPESIZE];
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004144:	5b7d                	li	s6,-1
    if(pi->nread == pi->nwrite)
    80004146:	2184a783          	lw	a5,536(s1)
    8000414a:	21c4a703          	lw	a4,540(s1)
    8000414e:	02f70d63          	beq	a4,a5,80004188 <piperead+0xb4>
    ch = pi->data[pi->nread++ % PIPESIZE];
    80004152:	0017871b          	addiw	a4,a5,1
    80004156:	20e4ac23          	sw	a4,536(s1)
    8000415a:	1ff7f793          	andi	a5,a5,511
    8000415e:	97a6                	add	a5,a5,s1
    80004160:	0187c783          	lbu	a5,24(a5)
    80004164:	faf40fa3          	sb	a5,-65(s0)
    if(copyout(pr->pagetable, addr + i, &ch, 1) == -1)
    80004168:	4685                	li	a3,1
    8000416a:	fbf40613          	addi	a2,s0,-65
    8000416e:	85ca                	mv	a1,s2
    80004170:	050a3503          	ld	a0,80(s4)
    80004174:	ffffd097          	auipc	ra,0xffffd
    80004178:	9ac080e7          	jalr	-1620(ra) # 80000b20 <copyout>
    8000417c:	01650663          	beq	a0,s6,80004188 <piperead+0xb4>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    80004180:	2985                	addiw	s3,s3,1
    80004182:	0905                	addi	s2,s2,1
    80004184:	fd3a91e3          	bne	s5,s3,80004146 <piperead+0x72>
      break;
  }
  wakeup(&pi->nwrite);  //DOC: piperead-wakeup
    80004188:	21c48513          	addi	a0,s1,540
    8000418c:	ffffd097          	auipc	ra,0xffffd
    80004190:	41e080e7          	jalr	1054(ra) # 800015aa <wakeup>
  release(&pi->lock);
    80004194:	8526                	mv	a0,s1
    80004196:	00002097          	auipc	ra,0x2
    8000419a:	53a080e7          	jalr	1338(ra) # 800066d0 <release>
  return i;
}
    8000419e:	854e                	mv	a0,s3
    800041a0:	60a6                	ld	ra,72(sp)
    800041a2:	6406                	ld	s0,64(sp)
    800041a4:	74e2                	ld	s1,56(sp)
    800041a6:	7942                	ld	s2,48(sp)
    800041a8:	79a2                	ld	s3,40(sp)
    800041aa:	7a02                	ld	s4,32(sp)
    800041ac:	6ae2                	ld	s5,24(sp)
    800041ae:	6b42                	ld	s6,16(sp)
    800041b0:	6161                	addi	sp,sp,80
    800041b2:	8082                	ret
      release(&pi->lock);
    800041b4:	8526                	mv	a0,s1
    800041b6:	00002097          	auipc	ra,0x2
    800041ba:	51a080e7          	jalr	1306(ra) # 800066d0 <release>
      return -1;
    800041be:	59fd                	li	s3,-1
    800041c0:	bff9                	j	8000419e <piperead+0xca>
  for(i = 0; i < n; i++){  //DOC: piperead-copy
    800041c2:	4981                	li	s3,0
    800041c4:	b7d1                	j	80004188 <piperead+0xb4>

00000000800041c6 <flags2perm>:
#include "elf.h"

static int loadseg(pde_t *, uint64, struct inode *, uint, uint);

int flags2perm(int flags)
{
    800041c6:	1141                	addi	sp,sp,-16
    800041c8:	e422                	sd	s0,8(sp)
    800041ca:	0800                	addi	s0,sp,16
    800041cc:	87aa                	mv	a5,a0
    int perm = 0;
    if(flags & 0x1)
    800041ce:	8905                	andi	a0,a0,1
    800041d0:	c111                	beqz	a0,800041d4 <flags2perm+0xe>
      perm = PTE_X;
    800041d2:	4521                	li	a0,8
    if(flags & 0x2)
    800041d4:	8b89                	andi	a5,a5,2
    800041d6:	c399                	beqz	a5,800041dc <flags2perm+0x16>
      perm |= PTE_W;
    800041d8:	00456513          	ori	a0,a0,4
    return perm;
}
    800041dc:	6422                	ld	s0,8(sp)
    800041de:	0141                	addi	sp,sp,16
    800041e0:	8082                	ret

00000000800041e2 <exec>:

int
exec(char *path, char **argv)
{
    800041e2:	df010113          	addi	sp,sp,-528
    800041e6:	20113423          	sd	ra,520(sp)
    800041ea:	20813023          	sd	s0,512(sp)
    800041ee:	ffa6                	sd	s1,504(sp)
    800041f0:	fbca                	sd	s2,496(sp)
    800041f2:	f7ce                	sd	s3,488(sp)
    800041f4:	f3d2                	sd	s4,480(sp)
    800041f6:	efd6                	sd	s5,472(sp)
    800041f8:	ebda                	sd	s6,464(sp)
    800041fa:	e7de                	sd	s7,456(sp)
    800041fc:	e3e2                	sd	s8,448(sp)
    800041fe:	ff66                	sd	s9,440(sp)
    80004200:	fb6a                	sd	s10,432(sp)
    80004202:	f76e                	sd	s11,424(sp)
    80004204:	0c00                	addi	s0,sp,528
    80004206:	84aa                	mv	s1,a0
    80004208:	dea43c23          	sd	a0,-520(s0)
    8000420c:	e0b43023          	sd	a1,-512(s0)
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
  struct elfhdr elf;
  struct inode *ip;
  struct proghdr ph;
  pagetable_t pagetable = 0, oldpagetable;
  struct proc *p = myproc();
    80004210:	ffffd097          	auipc	ra,0xffffd
    80004214:	c52080e7          	jalr	-942(ra) # 80000e62 <myproc>
    80004218:	892a                	mv	s2,a0

  begin_op();
    8000421a:	fffff097          	auipc	ra,0xfffff
    8000421e:	41a080e7          	jalr	1050(ra) # 80003634 <begin_op>

  if((ip = namei(path)) == 0){
    80004222:	8526                	mv	a0,s1
    80004224:	fffff097          	auipc	ra,0xfffff
    80004228:	1f4080e7          	jalr	500(ra) # 80003418 <namei>
    8000422c:	c92d                	beqz	a0,8000429e <exec+0xbc>
    8000422e:	84aa                	mv	s1,a0
    end_op();
    return -1;
  }
  ilock(ip);
    80004230:	fffff097          	auipc	ra,0xfffff
    80004234:	a42080e7          	jalr	-1470(ra) # 80002c72 <ilock>

  // Check ELF header
  if(readi(ip, 0, (uint64)&elf, 0, sizeof(elf)) != sizeof(elf))
    80004238:	04000713          	li	a4,64
    8000423c:	4681                	li	a3,0
    8000423e:	e5040613          	addi	a2,s0,-432
    80004242:	4581                	li	a1,0
    80004244:	8526                	mv	a0,s1
    80004246:	fffff097          	auipc	ra,0xfffff
    8000424a:	ce0080e7          	jalr	-800(ra) # 80002f26 <readi>
    8000424e:	04000793          	li	a5,64
    80004252:	00f51a63          	bne	a0,a5,80004266 <exec+0x84>
    goto bad;

  if(elf.magic != ELF_MAGIC)
    80004256:	e5042703          	lw	a4,-432(s0)
    8000425a:	464c47b7          	lui	a5,0x464c4
    8000425e:	57f78793          	addi	a5,a5,1407 # 464c457f <_entry-0x39b3ba81>
    80004262:	04f70463          	beq	a4,a5,800042aa <exec+0xc8>

 bad:
  if(pagetable)
    proc_freepagetable(pagetable, sz);
  if(ip){
    iunlockput(ip);
    80004266:	8526                	mv	a0,s1
    80004268:	fffff097          	auipc	ra,0xfffff
    8000426c:	c6c080e7          	jalr	-916(ra) # 80002ed4 <iunlockput>
    end_op();
    80004270:	fffff097          	auipc	ra,0xfffff
    80004274:	444080e7          	jalr	1092(ra) # 800036b4 <end_op>
  }
  return -1;
    80004278:	557d                	li	a0,-1
}
    8000427a:	20813083          	ld	ra,520(sp)
    8000427e:	20013403          	ld	s0,512(sp)
    80004282:	74fe                	ld	s1,504(sp)
    80004284:	795e                	ld	s2,496(sp)
    80004286:	79be                	ld	s3,488(sp)
    80004288:	7a1e                	ld	s4,480(sp)
    8000428a:	6afe                	ld	s5,472(sp)
    8000428c:	6b5e                	ld	s6,464(sp)
    8000428e:	6bbe                	ld	s7,456(sp)
    80004290:	6c1e                	ld	s8,448(sp)
    80004292:	7cfa                	ld	s9,440(sp)
    80004294:	7d5a                	ld	s10,432(sp)
    80004296:	7dba                	ld	s11,424(sp)
    80004298:	21010113          	addi	sp,sp,528
    8000429c:	8082                	ret
    end_op();
    8000429e:	fffff097          	auipc	ra,0xfffff
    800042a2:	416080e7          	jalr	1046(ra) # 800036b4 <end_op>
    return -1;
    800042a6:	557d                	li	a0,-1
    800042a8:	bfc9                	j	8000427a <exec+0x98>
  if((pagetable = proc_pagetable(p)) == 0)
    800042aa:	854a                	mv	a0,s2
    800042ac:	ffffd097          	auipc	ra,0xffffd
    800042b0:	c7a080e7          	jalr	-902(ra) # 80000f26 <proc_pagetable>
    800042b4:	8baa                	mv	s7,a0
    800042b6:	d945                	beqz	a0,80004266 <exec+0x84>
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800042b8:	e7042983          	lw	s3,-400(s0)
    800042bc:	e8845783          	lhu	a5,-376(s0)
    800042c0:	c7ad                	beqz	a5,8000432a <exec+0x148>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    800042c2:	4a01                	li	s4,0
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800042c4:	4b01                	li	s6,0
    if(ph.vaddr % PGSIZE != 0)
    800042c6:	6c85                	lui	s9,0x1
    800042c8:	fffc8793          	addi	a5,s9,-1 # fff <_entry-0x7ffff001>
    800042cc:	def43823          	sd	a5,-528(s0)
    800042d0:	ac0d                	j	80004502 <exec+0x320>
  uint64 pa;

  for(i = 0; i < sz; i += PGSIZE){
    pa = walkaddr(pagetable, va + i);
    if(pa == 0)
      panic("loadseg: address should exist");
    800042d2:	00004517          	auipc	a0,0x4
    800042d6:	43e50513          	addi	a0,a0,1086 # 80008710 <syscalls+0x298>
    800042da:	00002097          	auipc	ra,0x2
    800042de:	df8080e7          	jalr	-520(ra) # 800060d2 <panic>
    if(sz - i < PGSIZE)
      n = sz - i;
    else
      n = PGSIZE;
    if(readi(ip, 0, (uint64)pa, offset+i, n) != n)
    800042e2:	8756                	mv	a4,s5
    800042e4:	012d86bb          	addw	a3,s11,s2
    800042e8:	4581                	li	a1,0
    800042ea:	8526                	mv	a0,s1
    800042ec:	fffff097          	auipc	ra,0xfffff
    800042f0:	c3a080e7          	jalr	-966(ra) # 80002f26 <readi>
    800042f4:	2501                	sext.w	a0,a0
    800042f6:	1aaa9a63          	bne	s5,a0,800044aa <exec+0x2c8>
  for(i = 0; i < sz; i += PGSIZE){
    800042fa:	6785                	lui	a5,0x1
    800042fc:	0127893b          	addw	s2,a5,s2
    80004300:	77fd                	lui	a5,0xfffff
    80004302:	01478a3b          	addw	s4,a5,s4
    80004306:	1f897563          	bgeu	s2,s8,800044f0 <exec+0x30e>
    pa = walkaddr(pagetable, va + i);
    8000430a:	02091593          	slli	a1,s2,0x20
    8000430e:	9181                	srli	a1,a1,0x20
    80004310:	95ea                	add	a1,a1,s10
    80004312:	855e                	mv	a0,s7
    80004314:	ffffc097          	auipc	ra,0xffffc
    80004318:	1f6080e7          	jalr	502(ra) # 8000050a <walkaddr>
    8000431c:	862a                	mv	a2,a0
    if(pa == 0)
    8000431e:	d955                	beqz	a0,800042d2 <exec+0xf0>
      n = PGSIZE;
    80004320:	8ae6                	mv	s5,s9
    if(sz - i < PGSIZE)
    80004322:	fd9a70e3          	bgeu	s4,s9,800042e2 <exec+0x100>
      n = sz - i;
    80004326:	8ad2                	mv	s5,s4
    80004328:	bf6d                	j	800042e2 <exec+0x100>
  uint64 argc, sz = 0, sp, ustack[MAXARG], stackbase;
    8000432a:	4a01                	li	s4,0
  iunlockput(ip);
    8000432c:	8526                	mv	a0,s1
    8000432e:	fffff097          	auipc	ra,0xfffff
    80004332:	ba6080e7          	jalr	-1114(ra) # 80002ed4 <iunlockput>
  end_op();
    80004336:	fffff097          	auipc	ra,0xfffff
    8000433a:	37e080e7          	jalr	894(ra) # 800036b4 <end_op>
  p = myproc();
    8000433e:	ffffd097          	auipc	ra,0xffffd
    80004342:	b24080e7          	jalr	-1244(ra) # 80000e62 <myproc>
    80004346:	8aaa                	mv	s5,a0
  uint64 oldsz = p->sz;
    80004348:	04853d03          	ld	s10,72(a0)
  sz = PGROUNDUP(sz);
    8000434c:	6785                	lui	a5,0x1
    8000434e:	17fd                	addi	a5,a5,-1
    80004350:	9a3e                	add	s4,s4,a5
    80004352:	757d                	lui	a0,0xfffff
    80004354:	00aa77b3          	and	a5,s4,a0
    80004358:	e0f43423          	sd	a5,-504(s0)
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    8000435c:	4691                	li	a3,4
    8000435e:	6609                	lui	a2,0x2
    80004360:	963e                	add	a2,a2,a5
    80004362:	85be                	mv	a1,a5
    80004364:	855e                	mv	a0,s7
    80004366:	ffffc097          	auipc	ra,0xffffc
    8000436a:	56e080e7          	jalr	1390(ra) # 800008d4 <uvmalloc>
    8000436e:	8b2a                	mv	s6,a0
  ip = 0;
    80004370:	4481                	li	s1,0
  if((sz1 = uvmalloc(pagetable, sz, sz + 2*PGSIZE, PTE_W)) == 0)
    80004372:	12050c63          	beqz	a0,800044aa <exec+0x2c8>
  uvmclear(pagetable, sz-2*PGSIZE);
    80004376:	75f9                	lui	a1,0xffffe
    80004378:	95aa                	add	a1,a1,a0
    8000437a:	855e                	mv	a0,s7
    8000437c:	ffffc097          	auipc	ra,0xffffc
    80004380:	772080e7          	jalr	1906(ra) # 80000aee <uvmclear>
  stackbase = sp - PGSIZE;
    80004384:	7c7d                	lui	s8,0xfffff
    80004386:	9c5a                	add	s8,s8,s6
  for(argc = 0; argv[argc]; argc++) {
    80004388:	e0043783          	ld	a5,-512(s0)
    8000438c:	6388                	ld	a0,0(a5)
    8000438e:	c535                	beqz	a0,800043fa <exec+0x218>
    80004390:	e9040993          	addi	s3,s0,-368
    80004394:	f9040c93          	addi	s9,s0,-112
  sp = sz;
    80004398:	895a                	mv	s2,s6
    sp -= strlen(argv[argc]) + 1;
    8000439a:	ffffc097          	auipc	ra,0xffffc
    8000439e:	f62080e7          	jalr	-158(ra) # 800002fc <strlen>
    800043a2:	2505                	addiw	a0,a0,1
    800043a4:	40a90933          	sub	s2,s2,a0
    sp -= sp % 16; // riscv sp must be 16-byte aligned
    800043a8:	ff097913          	andi	s2,s2,-16
    if(sp < stackbase)
    800043ac:	13896663          	bltu	s2,s8,800044d8 <exec+0x2f6>
    if(copyout(pagetable, sp, argv[argc], strlen(argv[argc]) + 1) < 0)
    800043b0:	e0043d83          	ld	s11,-512(s0)
    800043b4:	000dba03          	ld	s4,0(s11)
    800043b8:	8552                	mv	a0,s4
    800043ba:	ffffc097          	auipc	ra,0xffffc
    800043be:	f42080e7          	jalr	-190(ra) # 800002fc <strlen>
    800043c2:	0015069b          	addiw	a3,a0,1
    800043c6:	8652                	mv	a2,s4
    800043c8:	85ca                	mv	a1,s2
    800043ca:	855e                	mv	a0,s7
    800043cc:	ffffc097          	auipc	ra,0xffffc
    800043d0:	754080e7          	jalr	1876(ra) # 80000b20 <copyout>
    800043d4:	10054663          	bltz	a0,800044e0 <exec+0x2fe>
    ustack[argc] = sp;
    800043d8:	0129b023          	sd	s2,0(s3)
  for(argc = 0; argv[argc]; argc++) {
    800043dc:	0485                	addi	s1,s1,1
    800043de:	008d8793          	addi	a5,s11,8
    800043e2:	e0f43023          	sd	a5,-512(s0)
    800043e6:	008db503          	ld	a0,8(s11)
    800043ea:	c911                	beqz	a0,800043fe <exec+0x21c>
    if(argc >= MAXARG)
    800043ec:	09a1                	addi	s3,s3,8
    800043ee:	fb3c96e3          	bne	s9,s3,8000439a <exec+0x1b8>
  sz = sz1;
    800043f2:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800043f6:	4481                	li	s1,0
    800043f8:	a84d                	j	800044aa <exec+0x2c8>
  sp = sz;
    800043fa:	895a                	mv	s2,s6
  for(argc = 0; argv[argc]; argc++) {
    800043fc:	4481                	li	s1,0
  ustack[argc] = 0;
    800043fe:	00349793          	slli	a5,s1,0x3
    80004402:	f9040713          	addi	a4,s0,-112
    80004406:	97ba                	add	a5,a5,a4
    80004408:	f007b023          	sd	zero,-256(a5) # f00 <_entry-0x7ffff100>
  sp -= (argc+1) * sizeof(uint64);
    8000440c:	00148693          	addi	a3,s1,1
    80004410:	068e                	slli	a3,a3,0x3
    80004412:	40d90933          	sub	s2,s2,a3
  sp -= sp % 16;
    80004416:	ff097913          	andi	s2,s2,-16
  if(sp < stackbase)
    8000441a:	01897663          	bgeu	s2,s8,80004426 <exec+0x244>
  sz = sz1;
    8000441e:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    80004422:	4481                	li	s1,0
    80004424:	a059                	j	800044aa <exec+0x2c8>
  if(copyout(pagetable, sp, (char *)ustack, (argc+1)*sizeof(uint64)) < 0)
    80004426:	e9040613          	addi	a2,s0,-368
    8000442a:	85ca                	mv	a1,s2
    8000442c:	855e                	mv	a0,s7
    8000442e:	ffffc097          	auipc	ra,0xffffc
    80004432:	6f2080e7          	jalr	1778(ra) # 80000b20 <copyout>
    80004436:	0a054963          	bltz	a0,800044e8 <exec+0x306>
  p->trapframe->a1 = sp;
    8000443a:	058ab783          	ld	a5,88(s5)
    8000443e:	0727bc23          	sd	s2,120(a5)
  for(last=s=path; *s; s++)
    80004442:	df843783          	ld	a5,-520(s0)
    80004446:	0007c703          	lbu	a4,0(a5)
    8000444a:	cf11                	beqz	a4,80004466 <exec+0x284>
    8000444c:	0785                	addi	a5,a5,1
    if(*s == '/')
    8000444e:	02f00693          	li	a3,47
    80004452:	a039                	j	80004460 <exec+0x27e>
      last = s+1;
    80004454:	def43c23          	sd	a5,-520(s0)
  for(last=s=path; *s; s++)
    80004458:	0785                	addi	a5,a5,1
    8000445a:	fff7c703          	lbu	a4,-1(a5)
    8000445e:	c701                	beqz	a4,80004466 <exec+0x284>
    if(*s == '/')
    80004460:	fed71ce3          	bne	a4,a3,80004458 <exec+0x276>
    80004464:	bfc5                	j	80004454 <exec+0x272>
  safestrcpy(p->name, last, sizeof(p->name));
    80004466:	4641                	li	a2,16
    80004468:	df843583          	ld	a1,-520(s0)
    8000446c:	158a8513          	addi	a0,s5,344
    80004470:	ffffc097          	auipc	ra,0xffffc
    80004474:	e5a080e7          	jalr	-422(ra) # 800002ca <safestrcpy>
  oldpagetable = p->pagetable;
    80004478:	050ab503          	ld	a0,80(s5)
  p->pagetable = pagetable;
    8000447c:	057ab823          	sd	s7,80(s5)
  p->sz = sz;
    80004480:	056ab423          	sd	s6,72(s5)
  p->trapframe->epc = elf.entry;  // initial program counter = main
    80004484:	058ab783          	ld	a5,88(s5)
    80004488:	e6843703          	ld	a4,-408(s0)
    8000448c:	ef98                	sd	a4,24(a5)
  p->trapframe->sp = sp; // initial stack pointer
    8000448e:	058ab783          	ld	a5,88(s5)
    80004492:	0327b823          	sd	s2,48(a5)
  proc_freepagetable(oldpagetable, oldsz);
    80004496:	85ea                	mv	a1,s10
    80004498:	ffffd097          	auipc	ra,0xffffd
    8000449c:	b2a080e7          	jalr	-1238(ra) # 80000fc2 <proc_freepagetable>
  return argc; // this ends up in a0, the first argument to main(argc, argv)
    800044a0:	0004851b          	sext.w	a0,s1
    800044a4:	bbd9                	j	8000427a <exec+0x98>
    800044a6:	e1443423          	sd	s4,-504(s0)
    proc_freepagetable(pagetable, sz);
    800044aa:	e0843583          	ld	a1,-504(s0)
    800044ae:	855e                	mv	a0,s7
    800044b0:	ffffd097          	auipc	ra,0xffffd
    800044b4:	b12080e7          	jalr	-1262(ra) # 80000fc2 <proc_freepagetable>
  if(ip){
    800044b8:	da0497e3          	bnez	s1,80004266 <exec+0x84>
  return -1;
    800044bc:	557d                	li	a0,-1
    800044be:	bb75                	j	8000427a <exec+0x98>
    800044c0:	e1443423          	sd	s4,-504(s0)
    800044c4:	b7dd                	j	800044aa <exec+0x2c8>
    800044c6:	e1443423          	sd	s4,-504(s0)
    800044ca:	b7c5                	j	800044aa <exec+0x2c8>
    800044cc:	e1443423          	sd	s4,-504(s0)
    800044d0:	bfe9                	j	800044aa <exec+0x2c8>
    800044d2:	e1443423          	sd	s4,-504(s0)
    800044d6:	bfd1                	j	800044aa <exec+0x2c8>
  sz = sz1;
    800044d8:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800044dc:	4481                	li	s1,0
    800044de:	b7f1                	j	800044aa <exec+0x2c8>
  sz = sz1;
    800044e0:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800044e4:	4481                	li	s1,0
    800044e6:	b7d1                	j	800044aa <exec+0x2c8>
  sz = sz1;
    800044e8:	e1643423          	sd	s6,-504(s0)
  ip = 0;
    800044ec:	4481                	li	s1,0
    800044ee:	bf75                	j	800044aa <exec+0x2c8>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    800044f0:	e0843a03          	ld	s4,-504(s0)
  for(i=0, off=elf.phoff; i<elf.phnum; i++, off+=sizeof(ph)){
    800044f4:	2b05                	addiw	s6,s6,1
    800044f6:	0389899b          	addiw	s3,s3,56
    800044fa:	e8845783          	lhu	a5,-376(s0)
    800044fe:	e2fb57e3          	bge	s6,a5,8000432c <exec+0x14a>
    if(readi(ip, 0, (uint64)&ph, off, sizeof(ph)) != sizeof(ph))
    80004502:	2981                	sext.w	s3,s3
    80004504:	03800713          	li	a4,56
    80004508:	86ce                	mv	a3,s3
    8000450a:	e1840613          	addi	a2,s0,-488
    8000450e:	4581                	li	a1,0
    80004510:	8526                	mv	a0,s1
    80004512:	fffff097          	auipc	ra,0xfffff
    80004516:	a14080e7          	jalr	-1516(ra) # 80002f26 <readi>
    8000451a:	03800793          	li	a5,56
    8000451e:	f8f514e3          	bne	a0,a5,800044a6 <exec+0x2c4>
    if(ph.type != ELF_PROG_LOAD)
    80004522:	e1842783          	lw	a5,-488(s0)
    80004526:	4705                	li	a4,1
    80004528:	fce796e3          	bne	a5,a4,800044f4 <exec+0x312>
    if(ph.memsz < ph.filesz)
    8000452c:	e4043903          	ld	s2,-448(s0)
    80004530:	e3843783          	ld	a5,-456(s0)
    80004534:	f8f966e3          	bltu	s2,a5,800044c0 <exec+0x2de>
    if(ph.vaddr + ph.memsz < ph.vaddr)
    80004538:	e2843783          	ld	a5,-472(s0)
    8000453c:	993e                	add	s2,s2,a5
    8000453e:	f8f964e3          	bltu	s2,a5,800044c6 <exec+0x2e4>
    if(ph.vaddr % PGSIZE != 0)
    80004542:	df043703          	ld	a4,-528(s0)
    80004546:	8ff9                	and	a5,a5,a4
    80004548:	f3d1                	bnez	a5,800044cc <exec+0x2ea>
    if((sz1 = uvmalloc(pagetable, sz, ph.vaddr + ph.memsz, flags2perm(ph.flags))) == 0)
    8000454a:	e1c42503          	lw	a0,-484(s0)
    8000454e:	00000097          	auipc	ra,0x0
    80004552:	c78080e7          	jalr	-904(ra) # 800041c6 <flags2perm>
    80004556:	86aa                	mv	a3,a0
    80004558:	864a                	mv	a2,s2
    8000455a:	85d2                	mv	a1,s4
    8000455c:	855e                	mv	a0,s7
    8000455e:	ffffc097          	auipc	ra,0xffffc
    80004562:	376080e7          	jalr	886(ra) # 800008d4 <uvmalloc>
    80004566:	e0a43423          	sd	a0,-504(s0)
    8000456a:	d525                	beqz	a0,800044d2 <exec+0x2f0>
    if(loadseg(pagetable, ph.vaddr, ip, ph.off, ph.filesz) < 0)
    8000456c:	e2843d03          	ld	s10,-472(s0)
    80004570:	e2042d83          	lw	s11,-480(s0)
    80004574:	e3842c03          	lw	s8,-456(s0)
  for(i = 0; i < sz; i += PGSIZE){
    80004578:	f60c0ce3          	beqz	s8,800044f0 <exec+0x30e>
    8000457c:	8a62                	mv	s4,s8
    8000457e:	4901                	li	s2,0
    80004580:	b369                	j	8000430a <exec+0x128>

0000000080004582 <argfd>:

// Fetch the nth word-sized system call argument as a file descriptor
// and return both the descriptor and the corresponding struct file.
static int
argfd(int n, int *pfd, struct file **pf)
{
    80004582:	7179                	addi	sp,sp,-48
    80004584:	f406                	sd	ra,40(sp)
    80004586:	f022                	sd	s0,32(sp)
    80004588:	ec26                	sd	s1,24(sp)
    8000458a:	e84a                	sd	s2,16(sp)
    8000458c:	1800                	addi	s0,sp,48
    8000458e:	892e                	mv	s2,a1
    80004590:	84b2                	mv	s1,a2
    int fd;
    struct file *f;

    argint(n, &fd);
    80004592:	fdc40593          	addi	a1,s0,-36
    80004596:	ffffe097          	auipc	ra,0xffffe
    8000459a:	b62080e7          	jalr	-1182(ra) # 800020f8 <argint>
    if (fd < 0 || fd >= NOFILE || (f = myproc()->ofile[fd]) == 0)
    8000459e:	fdc42703          	lw	a4,-36(s0)
    800045a2:	47bd                	li	a5,15
    800045a4:	02e7eb63          	bltu	a5,a4,800045da <argfd+0x58>
    800045a8:	ffffd097          	auipc	ra,0xffffd
    800045ac:	8ba080e7          	jalr	-1862(ra) # 80000e62 <myproc>
    800045b0:	fdc42703          	lw	a4,-36(s0)
    800045b4:	01a70793          	addi	a5,a4,26
    800045b8:	078e                	slli	a5,a5,0x3
    800045ba:	953e                	add	a0,a0,a5
    800045bc:	611c                	ld	a5,0(a0)
    800045be:	c385                	beqz	a5,800045de <argfd+0x5c>
        return -1;
    if (pfd)
    800045c0:	00090463          	beqz	s2,800045c8 <argfd+0x46>
        *pfd = fd;
    800045c4:	00e92023          	sw	a4,0(s2)
    if (pf)
        *pf = f;
    return 0;
    800045c8:	4501                	li	a0,0
    if (pf)
    800045ca:	c091                	beqz	s1,800045ce <argfd+0x4c>
        *pf = f;
    800045cc:	e09c                	sd	a5,0(s1)
}
    800045ce:	70a2                	ld	ra,40(sp)
    800045d0:	7402                	ld	s0,32(sp)
    800045d2:	64e2                	ld	s1,24(sp)
    800045d4:	6942                	ld	s2,16(sp)
    800045d6:	6145                	addi	sp,sp,48
    800045d8:	8082                	ret
        return -1;
    800045da:	557d                	li	a0,-1
    800045dc:	bfcd                	j	800045ce <argfd+0x4c>
    800045de:	557d                	li	a0,-1
    800045e0:	b7fd                	j	800045ce <argfd+0x4c>

00000000800045e2 <fdalloc>:

// Allocate a file descriptor for the given file.
// Takes over file reference from caller on success.
static int
fdalloc(struct file *f)
{
    800045e2:	1101                	addi	sp,sp,-32
    800045e4:	ec06                	sd	ra,24(sp)
    800045e6:	e822                	sd	s0,16(sp)
    800045e8:	e426                	sd	s1,8(sp)
    800045ea:	1000                	addi	s0,sp,32
    800045ec:	84aa                	mv	s1,a0
    int fd;
    struct proc *p = myproc();
    800045ee:	ffffd097          	auipc	ra,0xffffd
    800045f2:	874080e7          	jalr	-1932(ra) # 80000e62 <myproc>
    800045f6:	862a                	mv	a2,a0

    for (fd = 0; fd < NOFILE; fd++)
    800045f8:	0d050793          	addi	a5,a0,208 # fffffffffffff0d0 <end+0xffffffff7ffcb0e0>
    800045fc:	4501                	li	a0,0
    800045fe:	46c1                	li	a3,16
    {
        if (p->ofile[fd] == 0)
    80004600:	6398                	ld	a4,0(a5)
    80004602:	cb19                	beqz	a4,80004618 <fdalloc+0x36>
    for (fd = 0; fd < NOFILE; fd++)
    80004604:	2505                	addiw	a0,a0,1
    80004606:	07a1                	addi	a5,a5,8
    80004608:	fed51ce3          	bne	a0,a3,80004600 <fdalloc+0x1e>
        {
            p->ofile[fd] = f;
            return fd;
        }
    }
    return -1;
    8000460c:	557d                	li	a0,-1
}
    8000460e:	60e2                	ld	ra,24(sp)
    80004610:	6442                	ld	s0,16(sp)
    80004612:	64a2                	ld	s1,8(sp)
    80004614:	6105                	addi	sp,sp,32
    80004616:	8082                	ret
            p->ofile[fd] = f;
    80004618:	01a50793          	addi	a5,a0,26
    8000461c:	078e                	slli	a5,a5,0x3
    8000461e:	963e                	add	a2,a2,a5
    80004620:	e204                	sd	s1,0(a2)
            return fd;
    80004622:	b7f5                	j	8000460e <fdalloc+0x2c>

0000000080004624 <create>:
    }
}

static struct inode *
create(char *path, short type, short major, short minor)
{
    80004624:	715d                	addi	sp,sp,-80
    80004626:	e486                	sd	ra,72(sp)
    80004628:	e0a2                	sd	s0,64(sp)
    8000462a:	fc26                	sd	s1,56(sp)
    8000462c:	f84a                	sd	s2,48(sp)
    8000462e:	f44e                	sd	s3,40(sp)
    80004630:	f052                	sd	s4,32(sp)
    80004632:	ec56                	sd	s5,24(sp)
    80004634:	e85a                	sd	s6,16(sp)
    80004636:	0880                	addi	s0,sp,80
    80004638:	8b2e                	mv	s6,a1
    8000463a:	89b2                	mv	s3,a2
    8000463c:	8936                	mv	s2,a3
    struct inode *ip, *dp;
    char name[DIRSIZ];

    if ((dp = nameiparent(path, name)) == 0)
    8000463e:	fb040593          	addi	a1,s0,-80
    80004642:	fffff097          	auipc	ra,0xfffff
    80004646:	df4080e7          	jalr	-524(ra) # 80003436 <nameiparent>
    8000464a:	84aa                	mv	s1,a0
    8000464c:	16050063          	beqz	a0,800047ac <create+0x188>
        return 0;

    ilock(dp);
    80004650:	ffffe097          	auipc	ra,0xffffe
    80004654:	622080e7          	jalr	1570(ra) # 80002c72 <ilock>

    if ((ip = dirlookup(dp, name, 0)) != 0)
    80004658:	4601                	li	a2,0
    8000465a:	fb040593          	addi	a1,s0,-80
    8000465e:	8526                	mv	a0,s1
    80004660:	fffff097          	auipc	ra,0xfffff
    80004664:	af6080e7          	jalr	-1290(ra) # 80003156 <dirlookup>
    80004668:	8aaa                	mv	s5,a0
    8000466a:	c931                	beqz	a0,800046be <create+0x9a>
    {
        iunlockput(dp);
    8000466c:	8526                	mv	a0,s1
    8000466e:	fffff097          	auipc	ra,0xfffff
    80004672:	866080e7          	jalr	-1946(ra) # 80002ed4 <iunlockput>
        ilock(ip);
    80004676:	8556                	mv	a0,s5
    80004678:	ffffe097          	auipc	ra,0xffffe
    8000467c:	5fa080e7          	jalr	1530(ra) # 80002c72 <ilock>
        if (type == T_FILE && (ip->type == T_FILE || ip->type == T_DEVICE))
    80004680:	000b059b          	sext.w	a1,s6
    80004684:	4789                	li	a5,2
    80004686:	02f59563          	bne	a1,a5,800046b0 <create+0x8c>
    8000468a:	044ad783          	lhu	a5,68(s5)
    8000468e:	37f9                	addiw	a5,a5,-2
    80004690:	17c2                	slli	a5,a5,0x30
    80004692:	93c1                	srli	a5,a5,0x30
    80004694:	4705                	li	a4,1
    80004696:	00f76d63          	bltu	a4,a5,800046b0 <create+0x8c>
    ip->nlink = 0;
    iupdate(ip);
    iunlockput(ip);
    iunlockput(dp);
    return 0;
}
    8000469a:	8556                	mv	a0,s5
    8000469c:	60a6                	ld	ra,72(sp)
    8000469e:	6406                	ld	s0,64(sp)
    800046a0:	74e2                	ld	s1,56(sp)
    800046a2:	7942                	ld	s2,48(sp)
    800046a4:	79a2                	ld	s3,40(sp)
    800046a6:	7a02                	ld	s4,32(sp)
    800046a8:	6ae2                	ld	s5,24(sp)
    800046aa:	6b42                	ld	s6,16(sp)
    800046ac:	6161                	addi	sp,sp,80
    800046ae:	8082                	ret
        iunlockput(ip);
    800046b0:	8556                	mv	a0,s5
    800046b2:	fffff097          	auipc	ra,0xfffff
    800046b6:	822080e7          	jalr	-2014(ra) # 80002ed4 <iunlockput>
        return 0;
    800046ba:	4a81                	li	s5,0
    800046bc:	bff9                	j	8000469a <create+0x76>
    if ((ip = ialloc(dp->dev, type)) == 0)
    800046be:	85da                	mv	a1,s6
    800046c0:	4088                	lw	a0,0(s1)
    800046c2:	ffffe097          	auipc	ra,0xffffe
    800046c6:	414080e7          	jalr	1044(ra) # 80002ad6 <ialloc>
    800046ca:	8a2a                	mv	s4,a0
    800046cc:	c921                	beqz	a0,8000471c <create+0xf8>
    ilock(ip);
    800046ce:	ffffe097          	auipc	ra,0xffffe
    800046d2:	5a4080e7          	jalr	1444(ra) # 80002c72 <ilock>
    ip->major = major;
    800046d6:	053a1323          	sh	s3,70(s4)
    ip->minor = minor;
    800046da:	052a1423          	sh	s2,72(s4)
    ip->nlink = 1;
    800046de:	4785                	li	a5,1
    800046e0:	04fa1523          	sh	a5,74(s4)
    iupdate(ip);
    800046e4:	8552                	mv	a0,s4
    800046e6:	ffffe097          	auipc	ra,0xffffe
    800046ea:	4c2080e7          	jalr	1218(ra) # 80002ba8 <iupdate>
    if (type == T_DIR)
    800046ee:	000b059b          	sext.w	a1,s6
    800046f2:	4785                	li	a5,1
    800046f4:	02f58b63          	beq	a1,a5,8000472a <create+0x106>
    if (dirlink(dp, name, ip->inum) < 0)
    800046f8:	004a2603          	lw	a2,4(s4)
    800046fc:	fb040593          	addi	a1,s0,-80
    80004700:	8526                	mv	a0,s1
    80004702:	fffff097          	auipc	ra,0xfffff
    80004706:	c64080e7          	jalr	-924(ra) # 80003366 <dirlink>
    8000470a:	06054f63          	bltz	a0,80004788 <create+0x164>
    iunlockput(dp);
    8000470e:	8526                	mv	a0,s1
    80004710:	ffffe097          	auipc	ra,0xffffe
    80004714:	7c4080e7          	jalr	1988(ra) # 80002ed4 <iunlockput>
    return ip;
    80004718:	8ad2                	mv	s5,s4
    8000471a:	b741                	j	8000469a <create+0x76>
        iunlockput(dp);
    8000471c:	8526                	mv	a0,s1
    8000471e:	ffffe097          	auipc	ra,0xffffe
    80004722:	7b6080e7          	jalr	1974(ra) # 80002ed4 <iunlockput>
        return 0;
    80004726:	8ad2                	mv	s5,s4
    80004728:	bf8d                	j	8000469a <create+0x76>
        if (dirlink(ip, ".", ip->inum) < 0 || dirlink(ip, "..", dp->inum) < 0)
    8000472a:	004a2603          	lw	a2,4(s4)
    8000472e:	00004597          	auipc	a1,0x4
    80004732:	00258593          	addi	a1,a1,2 # 80008730 <syscalls+0x2b8>
    80004736:	8552                	mv	a0,s4
    80004738:	fffff097          	auipc	ra,0xfffff
    8000473c:	c2e080e7          	jalr	-978(ra) # 80003366 <dirlink>
    80004740:	04054463          	bltz	a0,80004788 <create+0x164>
    80004744:	40d0                	lw	a2,4(s1)
    80004746:	00004597          	auipc	a1,0x4
    8000474a:	ff258593          	addi	a1,a1,-14 # 80008738 <syscalls+0x2c0>
    8000474e:	8552                	mv	a0,s4
    80004750:	fffff097          	auipc	ra,0xfffff
    80004754:	c16080e7          	jalr	-1002(ra) # 80003366 <dirlink>
    80004758:	02054863          	bltz	a0,80004788 <create+0x164>
    if (dirlink(dp, name, ip->inum) < 0)
    8000475c:	004a2603          	lw	a2,4(s4)
    80004760:	fb040593          	addi	a1,s0,-80
    80004764:	8526                	mv	a0,s1
    80004766:	fffff097          	auipc	ra,0xfffff
    8000476a:	c00080e7          	jalr	-1024(ra) # 80003366 <dirlink>
    8000476e:	00054d63          	bltz	a0,80004788 <create+0x164>
        dp->nlink++; // for ".."
    80004772:	04a4d783          	lhu	a5,74(s1)
    80004776:	2785                	addiw	a5,a5,1
    80004778:	04f49523          	sh	a5,74(s1)
        iupdate(dp);
    8000477c:	8526                	mv	a0,s1
    8000477e:	ffffe097          	auipc	ra,0xffffe
    80004782:	42a080e7          	jalr	1066(ra) # 80002ba8 <iupdate>
    80004786:	b761                	j	8000470e <create+0xea>
    ip->nlink = 0;
    80004788:	040a1523          	sh	zero,74(s4)
    iupdate(ip);
    8000478c:	8552                	mv	a0,s4
    8000478e:	ffffe097          	auipc	ra,0xffffe
    80004792:	41a080e7          	jalr	1050(ra) # 80002ba8 <iupdate>
    iunlockput(ip);
    80004796:	8552                	mv	a0,s4
    80004798:	ffffe097          	auipc	ra,0xffffe
    8000479c:	73c080e7          	jalr	1852(ra) # 80002ed4 <iunlockput>
    iunlockput(dp);
    800047a0:	8526                	mv	a0,s1
    800047a2:	ffffe097          	auipc	ra,0xffffe
    800047a6:	732080e7          	jalr	1842(ra) # 80002ed4 <iunlockput>
    return 0;
    800047aa:	bdc5                	j	8000469a <create+0x76>
        return 0;
    800047ac:	8aaa                	mv	s5,a0
    800047ae:	b5f5                	j	8000469a <create+0x76>

00000000800047b0 <sys_dup>:
{
    800047b0:	7179                	addi	sp,sp,-48
    800047b2:	f406                	sd	ra,40(sp)
    800047b4:	f022                	sd	s0,32(sp)
    800047b6:	ec26                	sd	s1,24(sp)
    800047b8:	1800                	addi	s0,sp,48
    if (argfd(0, 0, &f) < 0)
    800047ba:	fd840613          	addi	a2,s0,-40
    800047be:	4581                	li	a1,0
    800047c0:	4501                	li	a0,0
    800047c2:	00000097          	auipc	ra,0x0
    800047c6:	dc0080e7          	jalr	-576(ra) # 80004582 <argfd>
        return -1;
    800047ca:	57fd                	li	a5,-1
    if (argfd(0, 0, &f) < 0)
    800047cc:	02054363          	bltz	a0,800047f2 <sys_dup+0x42>
    if ((fd = fdalloc(f)) < 0)
    800047d0:	fd843503          	ld	a0,-40(s0)
    800047d4:	00000097          	auipc	ra,0x0
    800047d8:	e0e080e7          	jalr	-498(ra) # 800045e2 <fdalloc>
    800047dc:	84aa                	mv	s1,a0
        return -1;
    800047de:	57fd                	li	a5,-1
    if ((fd = fdalloc(f)) < 0)
    800047e0:	00054963          	bltz	a0,800047f2 <sys_dup+0x42>
    filedup(f);
    800047e4:	fd843503          	ld	a0,-40(s0)
    800047e8:	fffff097          	auipc	ra,0xfffff
    800047ec:	2c6080e7          	jalr	710(ra) # 80003aae <filedup>
    return fd;
    800047f0:	87a6                	mv	a5,s1
}
    800047f2:	853e                	mv	a0,a5
    800047f4:	70a2                	ld	ra,40(sp)
    800047f6:	7402                	ld	s0,32(sp)
    800047f8:	64e2                	ld	s1,24(sp)
    800047fa:	6145                	addi	sp,sp,48
    800047fc:	8082                	ret

00000000800047fe <sys_read>:
{
    800047fe:	7179                	addi	sp,sp,-48
    80004800:	f406                	sd	ra,40(sp)
    80004802:	f022                	sd	s0,32(sp)
    80004804:	1800                	addi	s0,sp,48
    argaddr(1, &p);
    80004806:	fd840593          	addi	a1,s0,-40
    8000480a:	4505                	li	a0,1
    8000480c:	ffffe097          	auipc	ra,0xffffe
    80004810:	90c080e7          	jalr	-1780(ra) # 80002118 <argaddr>
    argint(2, &n);
    80004814:	fe440593          	addi	a1,s0,-28
    80004818:	4509                	li	a0,2
    8000481a:	ffffe097          	auipc	ra,0xffffe
    8000481e:	8de080e7          	jalr	-1826(ra) # 800020f8 <argint>
    if (argfd(0, 0, &f) < 0)
    80004822:	fe840613          	addi	a2,s0,-24
    80004826:	4581                	li	a1,0
    80004828:	4501                	li	a0,0
    8000482a:	00000097          	auipc	ra,0x0
    8000482e:	d58080e7          	jalr	-680(ra) # 80004582 <argfd>
    80004832:	87aa                	mv	a5,a0
        return -1;
    80004834:	557d                	li	a0,-1
    if (argfd(0, 0, &f) < 0)
    80004836:	0007cc63          	bltz	a5,8000484e <sys_read+0x50>
    return fileread(f, p, n);
    8000483a:	fe442603          	lw	a2,-28(s0)
    8000483e:	fd843583          	ld	a1,-40(s0)
    80004842:	fe843503          	ld	a0,-24(s0)
    80004846:	fffff097          	auipc	ra,0xfffff
    8000484a:	44e080e7          	jalr	1102(ra) # 80003c94 <fileread>
}
    8000484e:	70a2                	ld	ra,40(sp)
    80004850:	7402                	ld	s0,32(sp)
    80004852:	6145                	addi	sp,sp,48
    80004854:	8082                	ret

0000000080004856 <sys_write>:
{
    80004856:	7179                	addi	sp,sp,-48
    80004858:	f406                	sd	ra,40(sp)
    8000485a:	f022                	sd	s0,32(sp)
    8000485c:	1800                	addi	s0,sp,48
    argaddr(1, &p);
    8000485e:	fd840593          	addi	a1,s0,-40
    80004862:	4505                	li	a0,1
    80004864:	ffffe097          	auipc	ra,0xffffe
    80004868:	8b4080e7          	jalr	-1868(ra) # 80002118 <argaddr>
    argint(2, &n);
    8000486c:	fe440593          	addi	a1,s0,-28
    80004870:	4509                	li	a0,2
    80004872:	ffffe097          	auipc	ra,0xffffe
    80004876:	886080e7          	jalr	-1914(ra) # 800020f8 <argint>
    if (argfd(0, 0, &f) < 0)
    8000487a:	fe840613          	addi	a2,s0,-24
    8000487e:	4581                	li	a1,0
    80004880:	4501                	li	a0,0
    80004882:	00000097          	auipc	ra,0x0
    80004886:	d00080e7          	jalr	-768(ra) # 80004582 <argfd>
    8000488a:	87aa                	mv	a5,a0
        return -1;
    8000488c:	557d                	li	a0,-1
    if (argfd(0, 0, &f) < 0)
    8000488e:	0007cc63          	bltz	a5,800048a6 <sys_write+0x50>
    return filewrite(f, p, n);
    80004892:	fe442603          	lw	a2,-28(s0)
    80004896:	fd843583          	ld	a1,-40(s0)
    8000489a:	fe843503          	ld	a0,-24(s0)
    8000489e:	fffff097          	auipc	ra,0xfffff
    800048a2:	4b8080e7          	jalr	1208(ra) # 80003d56 <filewrite>
}
    800048a6:	70a2                	ld	ra,40(sp)
    800048a8:	7402                	ld	s0,32(sp)
    800048aa:	6145                	addi	sp,sp,48
    800048ac:	8082                	ret

00000000800048ae <sys_close>:
{
    800048ae:	1101                	addi	sp,sp,-32
    800048b0:	ec06                	sd	ra,24(sp)
    800048b2:	e822                	sd	s0,16(sp)
    800048b4:	1000                	addi	s0,sp,32
    if (argfd(0, &fd, &f) < 0)
    800048b6:	fe040613          	addi	a2,s0,-32
    800048ba:	fec40593          	addi	a1,s0,-20
    800048be:	4501                	li	a0,0
    800048c0:	00000097          	auipc	ra,0x0
    800048c4:	cc2080e7          	jalr	-830(ra) # 80004582 <argfd>
        return -1;
    800048c8:	57fd                	li	a5,-1
    if (argfd(0, &fd, &f) < 0)
    800048ca:	02054463          	bltz	a0,800048f2 <sys_close+0x44>
    myproc()->ofile[fd] = 0;
    800048ce:	ffffc097          	auipc	ra,0xffffc
    800048d2:	594080e7          	jalr	1428(ra) # 80000e62 <myproc>
    800048d6:	fec42783          	lw	a5,-20(s0)
    800048da:	07e9                	addi	a5,a5,26
    800048dc:	078e                	slli	a5,a5,0x3
    800048de:	97aa                	add	a5,a5,a0
    800048e0:	0007b023          	sd	zero,0(a5)
    fileclose(f);
    800048e4:	fe043503          	ld	a0,-32(s0)
    800048e8:	fffff097          	auipc	ra,0xfffff
    800048ec:	218080e7          	jalr	536(ra) # 80003b00 <fileclose>
    return 0;
    800048f0:	4781                	li	a5,0
}
    800048f2:	853e                	mv	a0,a5
    800048f4:	60e2                	ld	ra,24(sp)
    800048f6:	6442                	ld	s0,16(sp)
    800048f8:	6105                	addi	sp,sp,32
    800048fa:	8082                	ret

00000000800048fc <sys_fstat>:
{
    800048fc:	1101                	addi	sp,sp,-32
    800048fe:	ec06                	sd	ra,24(sp)
    80004900:	e822                	sd	s0,16(sp)
    80004902:	1000                	addi	s0,sp,32
    argaddr(1, &st);
    80004904:	fe040593          	addi	a1,s0,-32
    80004908:	4505                	li	a0,1
    8000490a:	ffffe097          	auipc	ra,0xffffe
    8000490e:	80e080e7          	jalr	-2034(ra) # 80002118 <argaddr>
    if (argfd(0, 0, &f) < 0)
    80004912:	fe840613          	addi	a2,s0,-24
    80004916:	4581                	li	a1,0
    80004918:	4501                	li	a0,0
    8000491a:	00000097          	auipc	ra,0x0
    8000491e:	c68080e7          	jalr	-920(ra) # 80004582 <argfd>
    80004922:	87aa                	mv	a5,a0
        return -1;
    80004924:	557d                	li	a0,-1
    if (argfd(0, 0, &f) < 0)
    80004926:	0007ca63          	bltz	a5,8000493a <sys_fstat+0x3e>
    return filestat(f, st);
    8000492a:	fe043583          	ld	a1,-32(s0)
    8000492e:	fe843503          	ld	a0,-24(s0)
    80004932:	fffff097          	auipc	ra,0xfffff
    80004936:	296080e7          	jalr	662(ra) # 80003bc8 <filestat>
}
    8000493a:	60e2                	ld	ra,24(sp)
    8000493c:	6442                	ld	s0,16(sp)
    8000493e:	6105                	addi	sp,sp,32
    80004940:	8082                	ret

0000000080004942 <sys_link>:
{
    80004942:	7169                	addi	sp,sp,-304
    80004944:	f606                	sd	ra,296(sp)
    80004946:	f222                	sd	s0,288(sp)
    80004948:	ee26                	sd	s1,280(sp)
    8000494a:	ea4a                	sd	s2,272(sp)
    8000494c:	1a00                	addi	s0,sp,304
    if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000494e:	08000613          	li	a2,128
    80004952:	ed040593          	addi	a1,s0,-304
    80004956:	4501                	li	a0,0
    80004958:	ffffd097          	auipc	ra,0xffffd
    8000495c:	7e0080e7          	jalr	2016(ra) # 80002138 <argstr>
        return -1;
    80004960:	57fd                	li	a5,-1
    if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    80004962:	10054e63          	bltz	a0,80004a7e <sys_link+0x13c>
    80004966:	08000613          	li	a2,128
    8000496a:	f5040593          	addi	a1,s0,-176
    8000496e:	4505                	li	a0,1
    80004970:	ffffd097          	auipc	ra,0xffffd
    80004974:	7c8080e7          	jalr	1992(ra) # 80002138 <argstr>
        return -1;
    80004978:	57fd                	li	a5,-1
    if (argstr(0, old, MAXPATH) < 0 || argstr(1, new, MAXPATH) < 0)
    8000497a:	10054263          	bltz	a0,80004a7e <sys_link+0x13c>
    begin_op();
    8000497e:	fffff097          	auipc	ra,0xfffff
    80004982:	cb6080e7          	jalr	-842(ra) # 80003634 <begin_op>
    if ((ip = namei(old)) == 0)
    80004986:	ed040513          	addi	a0,s0,-304
    8000498a:	fffff097          	auipc	ra,0xfffff
    8000498e:	a8e080e7          	jalr	-1394(ra) # 80003418 <namei>
    80004992:	84aa                	mv	s1,a0
    80004994:	c551                	beqz	a0,80004a20 <sys_link+0xde>
    ilock(ip);
    80004996:	ffffe097          	auipc	ra,0xffffe
    8000499a:	2dc080e7          	jalr	732(ra) # 80002c72 <ilock>
    if (ip->type == T_DIR)
    8000499e:	04449703          	lh	a4,68(s1)
    800049a2:	4785                	li	a5,1
    800049a4:	08f70463          	beq	a4,a5,80004a2c <sys_link+0xea>
    ip->nlink++;
    800049a8:	04a4d783          	lhu	a5,74(s1)
    800049ac:	2785                	addiw	a5,a5,1
    800049ae:	04f49523          	sh	a5,74(s1)
    iupdate(ip);
    800049b2:	8526                	mv	a0,s1
    800049b4:	ffffe097          	auipc	ra,0xffffe
    800049b8:	1f4080e7          	jalr	500(ra) # 80002ba8 <iupdate>
    iunlock(ip);
    800049bc:	8526                	mv	a0,s1
    800049be:	ffffe097          	auipc	ra,0xffffe
    800049c2:	376080e7          	jalr	886(ra) # 80002d34 <iunlock>
    if ((dp = nameiparent(new, name)) == 0)
    800049c6:	fd040593          	addi	a1,s0,-48
    800049ca:	f5040513          	addi	a0,s0,-176
    800049ce:	fffff097          	auipc	ra,0xfffff
    800049d2:	a68080e7          	jalr	-1432(ra) # 80003436 <nameiparent>
    800049d6:	892a                	mv	s2,a0
    800049d8:	c935                	beqz	a0,80004a4c <sys_link+0x10a>
    ilock(dp);
    800049da:	ffffe097          	auipc	ra,0xffffe
    800049de:	298080e7          	jalr	664(ra) # 80002c72 <ilock>
    if (dp->dev != ip->dev || dirlink(dp, name, ip->inum) < 0)
    800049e2:	00092703          	lw	a4,0(s2)
    800049e6:	409c                	lw	a5,0(s1)
    800049e8:	04f71d63          	bne	a4,a5,80004a42 <sys_link+0x100>
    800049ec:	40d0                	lw	a2,4(s1)
    800049ee:	fd040593          	addi	a1,s0,-48
    800049f2:	854a                	mv	a0,s2
    800049f4:	fffff097          	auipc	ra,0xfffff
    800049f8:	972080e7          	jalr	-1678(ra) # 80003366 <dirlink>
    800049fc:	04054363          	bltz	a0,80004a42 <sys_link+0x100>
    iunlockput(dp);
    80004a00:	854a                	mv	a0,s2
    80004a02:	ffffe097          	auipc	ra,0xffffe
    80004a06:	4d2080e7          	jalr	1234(ra) # 80002ed4 <iunlockput>
    iput(ip);
    80004a0a:	8526                	mv	a0,s1
    80004a0c:	ffffe097          	auipc	ra,0xffffe
    80004a10:	420080e7          	jalr	1056(ra) # 80002e2c <iput>
    end_op();
    80004a14:	fffff097          	auipc	ra,0xfffff
    80004a18:	ca0080e7          	jalr	-864(ra) # 800036b4 <end_op>
    return 0;
    80004a1c:	4781                	li	a5,0
    80004a1e:	a085                	j	80004a7e <sys_link+0x13c>
        end_op();
    80004a20:	fffff097          	auipc	ra,0xfffff
    80004a24:	c94080e7          	jalr	-876(ra) # 800036b4 <end_op>
        return -1;
    80004a28:	57fd                	li	a5,-1
    80004a2a:	a891                	j	80004a7e <sys_link+0x13c>
        iunlockput(ip);
    80004a2c:	8526                	mv	a0,s1
    80004a2e:	ffffe097          	auipc	ra,0xffffe
    80004a32:	4a6080e7          	jalr	1190(ra) # 80002ed4 <iunlockput>
        end_op();
    80004a36:	fffff097          	auipc	ra,0xfffff
    80004a3a:	c7e080e7          	jalr	-898(ra) # 800036b4 <end_op>
        return -1;
    80004a3e:	57fd                	li	a5,-1
    80004a40:	a83d                	j	80004a7e <sys_link+0x13c>
        iunlockput(dp);
    80004a42:	854a                	mv	a0,s2
    80004a44:	ffffe097          	auipc	ra,0xffffe
    80004a48:	490080e7          	jalr	1168(ra) # 80002ed4 <iunlockput>
    ilock(ip);
    80004a4c:	8526                	mv	a0,s1
    80004a4e:	ffffe097          	auipc	ra,0xffffe
    80004a52:	224080e7          	jalr	548(ra) # 80002c72 <ilock>
    ip->nlink--;
    80004a56:	04a4d783          	lhu	a5,74(s1)
    80004a5a:	37fd                	addiw	a5,a5,-1
    80004a5c:	04f49523          	sh	a5,74(s1)
    iupdate(ip);
    80004a60:	8526                	mv	a0,s1
    80004a62:	ffffe097          	auipc	ra,0xffffe
    80004a66:	146080e7          	jalr	326(ra) # 80002ba8 <iupdate>
    iunlockput(ip);
    80004a6a:	8526                	mv	a0,s1
    80004a6c:	ffffe097          	auipc	ra,0xffffe
    80004a70:	468080e7          	jalr	1128(ra) # 80002ed4 <iunlockput>
    end_op();
    80004a74:	fffff097          	auipc	ra,0xfffff
    80004a78:	c40080e7          	jalr	-960(ra) # 800036b4 <end_op>
    return -1;
    80004a7c:	57fd                	li	a5,-1
}
    80004a7e:	853e                	mv	a0,a5
    80004a80:	70b2                	ld	ra,296(sp)
    80004a82:	7412                	ld	s0,288(sp)
    80004a84:	64f2                	ld	s1,280(sp)
    80004a86:	6952                	ld	s2,272(sp)
    80004a88:	6155                	addi	sp,sp,304
    80004a8a:	8082                	ret

0000000080004a8c <sys_unlink>:
{
    80004a8c:	7151                	addi	sp,sp,-240
    80004a8e:	f586                	sd	ra,232(sp)
    80004a90:	f1a2                	sd	s0,224(sp)
    80004a92:	eda6                	sd	s1,216(sp)
    80004a94:	e9ca                	sd	s2,208(sp)
    80004a96:	e5ce                	sd	s3,200(sp)
    80004a98:	1980                	addi	s0,sp,240
    if (argstr(0, path, MAXPATH) < 0)
    80004a9a:	08000613          	li	a2,128
    80004a9e:	f3040593          	addi	a1,s0,-208
    80004aa2:	4501                	li	a0,0
    80004aa4:	ffffd097          	auipc	ra,0xffffd
    80004aa8:	694080e7          	jalr	1684(ra) # 80002138 <argstr>
    80004aac:	18054163          	bltz	a0,80004c2e <sys_unlink+0x1a2>
    begin_op();
    80004ab0:	fffff097          	auipc	ra,0xfffff
    80004ab4:	b84080e7          	jalr	-1148(ra) # 80003634 <begin_op>
    if ((dp = nameiparent(path, name)) == 0)
    80004ab8:	fb040593          	addi	a1,s0,-80
    80004abc:	f3040513          	addi	a0,s0,-208
    80004ac0:	fffff097          	auipc	ra,0xfffff
    80004ac4:	976080e7          	jalr	-1674(ra) # 80003436 <nameiparent>
    80004ac8:	84aa                	mv	s1,a0
    80004aca:	c979                	beqz	a0,80004ba0 <sys_unlink+0x114>
    ilock(dp);
    80004acc:	ffffe097          	auipc	ra,0xffffe
    80004ad0:	1a6080e7          	jalr	422(ra) # 80002c72 <ilock>
    if (namecmp(name, ".") == 0 || namecmp(name, "..") == 0)
    80004ad4:	00004597          	auipc	a1,0x4
    80004ad8:	c5c58593          	addi	a1,a1,-932 # 80008730 <syscalls+0x2b8>
    80004adc:	fb040513          	addi	a0,s0,-80
    80004ae0:	ffffe097          	auipc	ra,0xffffe
    80004ae4:	65c080e7          	jalr	1628(ra) # 8000313c <namecmp>
    80004ae8:	14050a63          	beqz	a0,80004c3c <sys_unlink+0x1b0>
    80004aec:	00004597          	auipc	a1,0x4
    80004af0:	c4c58593          	addi	a1,a1,-948 # 80008738 <syscalls+0x2c0>
    80004af4:	fb040513          	addi	a0,s0,-80
    80004af8:	ffffe097          	auipc	ra,0xffffe
    80004afc:	644080e7          	jalr	1604(ra) # 8000313c <namecmp>
    80004b00:	12050e63          	beqz	a0,80004c3c <sys_unlink+0x1b0>
    if ((ip = dirlookup(dp, name, &off)) == 0)
    80004b04:	f2c40613          	addi	a2,s0,-212
    80004b08:	fb040593          	addi	a1,s0,-80
    80004b0c:	8526                	mv	a0,s1
    80004b0e:	ffffe097          	auipc	ra,0xffffe
    80004b12:	648080e7          	jalr	1608(ra) # 80003156 <dirlookup>
    80004b16:	892a                	mv	s2,a0
    80004b18:	12050263          	beqz	a0,80004c3c <sys_unlink+0x1b0>
    ilock(ip);
    80004b1c:	ffffe097          	auipc	ra,0xffffe
    80004b20:	156080e7          	jalr	342(ra) # 80002c72 <ilock>
    if (ip->nlink < 1)
    80004b24:	04a91783          	lh	a5,74(s2)
    80004b28:	08f05263          	blez	a5,80004bac <sys_unlink+0x120>
    if (ip->type == T_DIR && !isdirempty(ip))
    80004b2c:	04491703          	lh	a4,68(s2)
    80004b30:	4785                	li	a5,1
    80004b32:	08f70563          	beq	a4,a5,80004bbc <sys_unlink+0x130>
    memset(&de, 0, sizeof(de));
    80004b36:	4641                	li	a2,16
    80004b38:	4581                	li	a1,0
    80004b3a:	fc040513          	addi	a0,s0,-64
    80004b3e:	ffffb097          	auipc	ra,0xffffb
    80004b42:	63a080e7          	jalr	1594(ra) # 80000178 <memset>
    if (writei(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004b46:	4741                	li	a4,16
    80004b48:	f2c42683          	lw	a3,-212(s0)
    80004b4c:	fc040613          	addi	a2,s0,-64
    80004b50:	4581                	li	a1,0
    80004b52:	8526                	mv	a0,s1
    80004b54:	ffffe097          	auipc	ra,0xffffe
    80004b58:	4ca080e7          	jalr	1226(ra) # 8000301e <writei>
    80004b5c:	47c1                	li	a5,16
    80004b5e:	0af51563          	bne	a0,a5,80004c08 <sys_unlink+0x17c>
    if (ip->type == T_DIR)
    80004b62:	04491703          	lh	a4,68(s2)
    80004b66:	4785                	li	a5,1
    80004b68:	0af70863          	beq	a4,a5,80004c18 <sys_unlink+0x18c>
    iunlockput(dp);
    80004b6c:	8526                	mv	a0,s1
    80004b6e:	ffffe097          	auipc	ra,0xffffe
    80004b72:	366080e7          	jalr	870(ra) # 80002ed4 <iunlockput>
    ip->nlink--;
    80004b76:	04a95783          	lhu	a5,74(s2)
    80004b7a:	37fd                	addiw	a5,a5,-1
    80004b7c:	04f91523          	sh	a5,74(s2)
    iupdate(ip);
    80004b80:	854a                	mv	a0,s2
    80004b82:	ffffe097          	auipc	ra,0xffffe
    80004b86:	026080e7          	jalr	38(ra) # 80002ba8 <iupdate>
    iunlockput(ip);
    80004b8a:	854a                	mv	a0,s2
    80004b8c:	ffffe097          	auipc	ra,0xffffe
    80004b90:	348080e7          	jalr	840(ra) # 80002ed4 <iunlockput>
    end_op();
    80004b94:	fffff097          	auipc	ra,0xfffff
    80004b98:	b20080e7          	jalr	-1248(ra) # 800036b4 <end_op>
    return 0;
    80004b9c:	4501                	li	a0,0
    80004b9e:	a84d                	j	80004c50 <sys_unlink+0x1c4>
        end_op();
    80004ba0:	fffff097          	auipc	ra,0xfffff
    80004ba4:	b14080e7          	jalr	-1260(ra) # 800036b4 <end_op>
        return -1;
    80004ba8:	557d                	li	a0,-1
    80004baa:	a05d                	j	80004c50 <sys_unlink+0x1c4>
        panic("unlink: nlink < 1");
    80004bac:	00004517          	auipc	a0,0x4
    80004bb0:	b9450513          	addi	a0,a0,-1132 # 80008740 <syscalls+0x2c8>
    80004bb4:	00001097          	auipc	ra,0x1
    80004bb8:	51e080e7          	jalr	1310(ra) # 800060d2 <panic>
    for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de))
    80004bbc:	04c92703          	lw	a4,76(s2)
    80004bc0:	02000793          	li	a5,32
    80004bc4:	f6e7f9e3          	bgeu	a5,a4,80004b36 <sys_unlink+0xaa>
    80004bc8:	02000993          	li	s3,32
        if (readi(dp, 0, (uint64)&de, off, sizeof(de)) != sizeof(de))
    80004bcc:	4741                	li	a4,16
    80004bce:	86ce                	mv	a3,s3
    80004bd0:	f1840613          	addi	a2,s0,-232
    80004bd4:	4581                	li	a1,0
    80004bd6:	854a                	mv	a0,s2
    80004bd8:	ffffe097          	auipc	ra,0xffffe
    80004bdc:	34e080e7          	jalr	846(ra) # 80002f26 <readi>
    80004be0:	47c1                	li	a5,16
    80004be2:	00f51b63          	bne	a0,a5,80004bf8 <sys_unlink+0x16c>
        if (de.inum != 0)
    80004be6:	f1845783          	lhu	a5,-232(s0)
    80004bea:	e7a1                	bnez	a5,80004c32 <sys_unlink+0x1a6>
    for (off = 2 * sizeof(de); off < dp->size; off += sizeof(de))
    80004bec:	29c1                	addiw	s3,s3,16
    80004bee:	04c92783          	lw	a5,76(s2)
    80004bf2:	fcf9ede3          	bltu	s3,a5,80004bcc <sys_unlink+0x140>
    80004bf6:	b781                	j	80004b36 <sys_unlink+0xaa>
            panic("isdirempty: readi");
    80004bf8:	00004517          	auipc	a0,0x4
    80004bfc:	b6050513          	addi	a0,a0,-1184 # 80008758 <syscalls+0x2e0>
    80004c00:	00001097          	auipc	ra,0x1
    80004c04:	4d2080e7          	jalr	1234(ra) # 800060d2 <panic>
        panic("unlink: writei");
    80004c08:	00004517          	auipc	a0,0x4
    80004c0c:	b6850513          	addi	a0,a0,-1176 # 80008770 <syscalls+0x2f8>
    80004c10:	00001097          	auipc	ra,0x1
    80004c14:	4c2080e7          	jalr	1218(ra) # 800060d2 <panic>
        dp->nlink--;
    80004c18:	04a4d783          	lhu	a5,74(s1)
    80004c1c:	37fd                	addiw	a5,a5,-1
    80004c1e:	04f49523          	sh	a5,74(s1)
        iupdate(dp);
    80004c22:	8526                	mv	a0,s1
    80004c24:	ffffe097          	auipc	ra,0xffffe
    80004c28:	f84080e7          	jalr	-124(ra) # 80002ba8 <iupdate>
    80004c2c:	b781                	j	80004b6c <sys_unlink+0xe0>
        return -1;
    80004c2e:	557d                	li	a0,-1
    80004c30:	a005                	j	80004c50 <sys_unlink+0x1c4>
        iunlockput(ip);
    80004c32:	854a                	mv	a0,s2
    80004c34:	ffffe097          	auipc	ra,0xffffe
    80004c38:	2a0080e7          	jalr	672(ra) # 80002ed4 <iunlockput>
    iunlockput(dp);
    80004c3c:	8526                	mv	a0,s1
    80004c3e:	ffffe097          	auipc	ra,0xffffe
    80004c42:	296080e7          	jalr	662(ra) # 80002ed4 <iunlockput>
    end_op();
    80004c46:	fffff097          	auipc	ra,0xfffff
    80004c4a:	a6e080e7          	jalr	-1426(ra) # 800036b4 <end_op>
    return -1;
    80004c4e:	557d                	li	a0,-1
}
    80004c50:	70ae                	ld	ra,232(sp)
    80004c52:	740e                	ld	s0,224(sp)
    80004c54:	64ee                	ld	s1,216(sp)
    80004c56:	694e                	ld	s2,208(sp)
    80004c58:	69ae                	ld	s3,200(sp)
    80004c5a:	616d                	addi	sp,sp,240
    80004c5c:	8082                	ret

0000000080004c5e <sys_mmap>:
{
    80004c5e:	711d                	addi	sp,sp,-96
    80004c60:	ec86                	sd	ra,88(sp)
    80004c62:	e8a2                	sd	s0,80(sp)
    80004c64:	e4a6                	sd	s1,72(sp)
    80004c66:	e0ca                	sd	s2,64(sp)
    80004c68:	fc4e                	sd	s3,56(sp)
    80004c6a:	f852                	sd	s4,48(sp)
    80004c6c:	1080                	addi	s0,sp,96
    argaddr(0, &addr);
    80004c6e:	fc840593          	addi	a1,s0,-56
    80004c72:	4501                	li	a0,0
    80004c74:	ffffd097          	auipc	ra,0xffffd
    80004c78:	4a4080e7          	jalr	1188(ra) # 80002118 <argaddr>
    argaddr(1, &length);
    80004c7c:	fc040593          	addi	a1,s0,-64
    80004c80:	4505                	li	a0,1
    80004c82:	ffffd097          	auipc	ra,0xffffd
    80004c86:	496080e7          	jalr	1174(ra) # 80002118 <argaddr>
    argint(2, &prot);
    80004c8a:	fbc40593          	addi	a1,s0,-68
    80004c8e:	4509                	li	a0,2
    80004c90:	ffffd097          	auipc	ra,0xffffd
    80004c94:	468080e7          	jalr	1128(ra) # 800020f8 <argint>
    argint(3, &flags);
    80004c98:	fb840593          	addi	a1,s0,-72
    80004c9c:	450d                	li	a0,3
    80004c9e:	ffffd097          	auipc	ra,0xffffd
    80004ca2:	45a080e7          	jalr	1114(ra) # 800020f8 <argint>
    argfd(4, &fd, &pf);
    80004ca6:	fa040613          	addi	a2,s0,-96
    80004caa:	fb440593          	addi	a1,s0,-76
    80004cae:	4511                	li	a0,4
    80004cb0:	00000097          	auipc	ra,0x0
    80004cb4:	8d2080e7          	jalr	-1838(ra) # 80004582 <argfd>
    argaddr(5, &offset);
    80004cb8:	fa840593          	addi	a1,s0,-88
    80004cbc:	4515                	li	a0,5
    80004cbe:	ffffd097          	auipc	ra,0xffffd
    80004cc2:	45a080e7          	jalr	1114(ra) # 80002118 <argaddr>
    if ((prot & PROT_WRITE) && (flags & MAP_SHARED) && (!pf->writable))
    80004cc6:	fbc42783          	lw	a5,-68(s0)
    80004cca:	0027f713          	andi	a4,a5,2
    80004cce:	cb11                	beqz	a4,80004ce2 <sys_mmap+0x84>
    80004cd0:	fb842703          	lw	a4,-72(s0)
    80004cd4:	8b05                	andi	a4,a4,1
    80004cd6:	c711                	beqz	a4,80004ce2 <sys_mmap+0x84>
    80004cd8:	fa043703          	ld	a4,-96(s0)
    80004cdc:	00974703          	lbu	a4,9(a4)
    80004ce0:	c71d                	beqz	a4,80004d0e <sys_mmap+0xb0>
    if ((prot & PROT_READ) && (!pf->readable))
    80004ce2:	8b85                	andi	a5,a5,1
    80004ce4:	c791                	beqz	a5,80004cf0 <sys_mmap+0x92>
    80004ce6:	fa043783          	ld	a5,-96(s0)
    80004cea:	0087c783          	lbu	a5,8(a5)
    80004cee:	cb95                	beqz	a5,80004d22 <sys_mmap+0xc4>
    struct proc *p_proc = myproc(); // create a pointer to process struct
    80004cf0:	ffffc097          	auipc	ra,0xffffc
    80004cf4:	172080e7          	jalr	370(ra) # 80000e62 <myproc>
    80004cf8:	892a                	mv	s2,a0
            if (p_proc->sz + length <= MAXVA)
    80004cfa:	fc043503          	ld	a0,-64(s0)
    80004cfe:	16890793          	addi	a5,s2,360
    for (int i = 0; i <= VMASIZE - 1; i++)
    80004d02:	4481                	li	s1,0
        if (p_proc->vma[i].occupied != 1)
    80004d04:	4685                	li	a3,1
            if (p_proc->sz + length <= MAXVA)
    80004d06:	02669593          	slli	a1,a3,0x26
    for (int i = 0; i <= VMASIZE - 1; i++)
    80004d0a:	4641                	li	a2,16
    80004d0c:	a815                	j	80004d40 <sys_mmap+0xe2>
        printf("[Testing] (sys_mmap) : not writable but write and map shared\n");
    80004d0e:	00004517          	auipc	a0,0x4
    80004d12:	a7250513          	addi	a0,a0,-1422 # 80008780 <syscalls+0x308>
    80004d16:	00001097          	auipc	ra,0x1
    80004d1a:	406080e7          	jalr	1030(ra) # 8000611c <printf>
        return -1;
    80004d1e:	557d                	li	a0,-1
    80004d20:	a8e9                	j	80004dfa <sys_mmap+0x19c>
        printf("[Testing] (sys_mmap) : not readable but read\n");
    80004d22:	00004517          	auipc	a0,0x4
    80004d26:	a9e50513          	addi	a0,a0,-1378 # 800087c0 <syscalls+0x348>
    80004d2a:	00001097          	auipc	ra,0x1
    80004d2e:	3f2080e7          	jalr	1010(ra) # 8000611c <printf>
        return -1;
    80004d32:	557d                	li	a0,-1
    80004d34:	a0d9                	j	80004dfa <sys_mmap+0x19c>
    for (int i = 0; i <= VMASIZE - 1; i++)
    80004d36:	2485                	addiw	s1,s1,1
    80004d38:	04878793          	addi	a5,a5,72
    80004d3c:	0cc48763          	beq	s1,a2,80004e0a <sys_mmap+0x1ac>
        if (p_proc->vma[i].occupied != 1)
    80004d40:	4398                	lw	a4,0(a5)
    80004d42:	fed70ae3          	beq	a4,a3,80004d36 <sys_mmap+0xd8>
            if (p_proc->sz + length <= MAXVA)
    80004d46:	04893703          	ld	a4,72(s2)
    80004d4a:	972a                	add	a4,a4,a0
    80004d4c:	fee5e5e3          	bltu	a1,a4,80004d36 <sys_mmap+0xd8>
                printf("[Testing] (sys_mmap) : find vma : %d \n", i);
    80004d50:	85a6                	mv	a1,s1
    80004d52:	00004517          	auipc	a0,0x4
    80004d56:	a9e50513          	addi	a0,a0,-1378 # 800087f0 <syscalls+0x378>
    80004d5a:	00001097          	auipc	ra,0x1
    80004d5e:	3c2080e7          	jalr	962(ra) # 8000611c <printf>
        p_vma->occupied = 1; // denote it is occupied
    80004d62:	00349a13          	slli	s4,s1,0x3
    80004d66:	009a09b3          	add	s3,s4,s1
    80004d6a:	098e                	slli	s3,s3,0x3
    80004d6c:	99ca                	add	s3,s3,s2
    80004d6e:	4785                	li	a5,1
    80004d70:	16f9a423          	sw	a5,360(s3)
        p_vma->start_addr = (uint64)(p_proc->sz);
    80004d74:	04893583          	ld	a1,72(s2)
    80004d78:	16b9b823          	sd	a1,368(s3)
        printf("[Testing] (sys_mmap) : find vma : start : %d \n", p_vma->start_addr);
    80004d7c:	00004517          	auipc	a0,0x4
    80004d80:	a9c50513          	addi	a0,a0,-1380 # 80008818 <syscalls+0x3a0>
    80004d84:	00001097          	auipc	ra,0x1
    80004d88:	398080e7          	jalr	920(ra) # 8000611c <printf>
        p_vma->end_addr = (uint64)(p_proc->sz + length - 1);
    80004d8c:	fc043583          	ld	a1,-64(s0)
    80004d90:	15fd                	addi	a1,a1,-1
    80004d92:	04893783          	ld	a5,72(s2)
    80004d96:	95be                	add	a1,a1,a5
    80004d98:	16b9bc23          	sd	a1,376(s3)
        printf("[Testing] (sys_mmap) : find vma : end : %d\n", p_vma->end_addr);
    80004d9c:	00004517          	auipc	a0,0x4
    80004da0:	aac50513          	addi	a0,a0,-1364 # 80008848 <syscalls+0x3d0>
    80004da4:	00001097          	auipc	ra,0x1
    80004da8:	378080e7          	jalr	888(ra) # 8000611c <printf>
        p_proc->sz += length;
    80004dac:	fc043703          	ld	a4,-64(s0)
    80004db0:	04893783          	ld	a5,72(s2)
    80004db4:	97ba                	add	a5,a5,a4
    80004db6:	04f93423          	sd	a5,72(s2)
        p_vma->addr = (uint64)addr;
    80004dba:	fc843783          	ld	a5,-56(s0)
    80004dbe:	18f9b023          	sd	a5,384(s3)
        p_vma->length = length;
    80004dc2:	18e9b423          	sd	a4,392(s3)
        p_vma->prot = prot;
    80004dc6:	fbc42783          	lw	a5,-68(s0)
    80004dca:	18f9a823          	sw	a5,400(s3)
        p_vma->flags = flags;
    80004dce:	fb842783          	lw	a5,-72(s0)
    80004dd2:	18f9aa23          	sw	a5,404(s3)
        p_vma->fd = fd;
    80004dd6:	fb442783          	lw	a5,-76(s0)
    80004dda:	18f9ac23          	sw	a5,408(s3)
        p_vma->offset = offset;
    80004dde:	fa843783          	ld	a5,-88(s0)
    80004de2:	1af9b023          	sd	a5,416(s3)
        p_vma->pf = pf;
    80004de6:	fa043503          	ld	a0,-96(s0)
    80004dea:	1aa9b423          	sd	a0,424(s3)
        filedup(p_vma->pf);
    80004dee:	fffff097          	auipc	ra,0xfffff
    80004df2:	cc0080e7          	jalr	-832(ra) # 80003aae <filedup>
        return (p_vma->start_addr);
    80004df6:	1709b503          	ld	a0,368(s3)
}
    80004dfa:	60e6                	ld	ra,88(sp)
    80004dfc:	6446                	ld	s0,80(sp)
    80004dfe:	64a6                	ld	s1,72(sp)
    80004e00:	6906                	ld	s2,64(sp)
    80004e02:	79e2                	ld	s3,56(sp)
    80004e04:	7a42                	ld	s4,48(sp)
    80004e06:	6125                	addi	sp,sp,96
    80004e08:	8082                	ret
        panic("syscall mmap");
    80004e0a:	00004517          	auipc	a0,0x4
    80004e0e:	a6e50513          	addi	a0,a0,-1426 # 80008878 <syscalls+0x400>
    80004e12:	00001097          	auipc	ra,0x1
    80004e16:	2c0080e7          	jalr	704(ra) # 800060d2 <panic>

0000000080004e1a <sys_munmap>:
{
    80004e1a:	7139                	addi	sp,sp,-64
    80004e1c:	fc06                	sd	ra,56(sp)
    80004e1e:	f822                	sd	s0,48(sp)
    80004e20:	f426                	sd	s1,40(sp)
    80004e22:	f04a                	sd	s2,32(sp)
    80004e24:	ec4e                	sd	s3,24(sp)
    80004e26:	0080                	addi	s0,sp,64
    argaddr(0, &addr);
    80004e28:	fc840593          	addi	a1,s0,-56
    80004e2c:	4501                	li	a0,0
    80004e2e:	ffffd097          	auipc	ra,0xffffd
    80004e32:	2ea080e7          	jalr	746(ra) # 80002118 <argaddr>
    argaddr(1, &length);
    80004e36:	fc040593          	addi	a1,s0,-64
    80004e3a:	4505                	li	a0,1
    80004e3c:	ffffd097          	auipc	ra,0xffffd
    80004e40:	2dc080e7          	jalr	732(ra) # 80002118 <argaddr>
    struct proc *p_proc = myproc(); // create a pointer to process struct
    80004e44:	ffffc097          	auipc	ra,0xffffc
    80004e48:	01e080e7          	jalr	30(ra) # 80000e62 <myproc>
    80004e4c:	892a                	mv	s2,a0
        if ((p_proc->vma[i].start_addr <= addr) && (addr <= p_proc->vma[i].end_addr))
    80004e4e:	fc843683          	ld	a3,-56(s0)
    80004e52:	17050793          	addi	a5,a0,368
    for (int i = 0; i <= VMASIZE - 1; i++)
    80004e56:	4481                	li	s1,0
    80004e58:	4641                	li	a2,16
    80004e5a:	a031                	j	80004e66 <sys_munmap+0x4c>
    80004e5c:	2485                	addiw	s1,s1,1
    80004e5e:	04878793          	addi	a5,a5,72
    80004e62:	0cc48763          	beq	s1,a2,80004f30 <sys_munmap+0x116>
        if ((p_proc->vma[i].start_addr <= addr) && (addr <= p_proc->vma[i].end_addr))
    80004e66:	6398                	ld	a4,0(a5)
    80004e68:	fee6eae3          	bltu	a3,a4,80004e5c <sys_munmap+0x42>
    80004e6c:	6798                	ld	a4,8(a5)
    80004e6e:	fed767e3          	bltu	a4,a3,80004e5c <sys_munmap+0x42>
            printf("[Testing] (sys_munmap): find vma %d\n", i);
    80004e72:	85a6                	mv	a1,s1
    80004e74:	00004517          	auipc	a0,0x4
    80004e78:	a1450513          	addi	a0,a0,-1516 # 80008888 <syscalls+0x410>
    80004e7c:	00001097          	auipc	ra,0x1
    80004e80:	2a0080e7          	jalr	672(ra) # 8000611c <printf>
            printf("[Testing] (sys_munmap): vma start address %d\n", p_proc->vma[i].start_addr);
    80004e84:	00349993          	slli	s3,s1,0x3
    80004e88:	99a6                	add	s3,s3,s1
    80004e8a:	098e                	slli	s3,s3,0x3
    80004e8c:	99ca                	add	s3,s3,s2
    80004e8e:	1709b583          	ld	a1,368(s3)
    80004e92:	00004517          	auipc	a0,0x4
    80004e96:	a1e50513          	addi	a0,a0,-1506 # 800088b0 <syscalls+0x438>
    80004e9a:	00001097          	auipc	ra,0x1
    80004e9e:	282080e7          	jalr	642(ra) # 8000611c <printf>
        if ((p_vma->flags & MAP_SHARED) != 0)
    80004ea2:	1949a783          	lw	a5,404(s3)
    80004ea6:	8b85                	andi	a5,a5,1
    80004ea8:	efc1                	bnez	a5,80004f40 <sys_munmap+0x126>
        printf("[Testing] (sys_munmap) : start: %d\n", p_vma->start_addr);
    80004eaa:	00349993          	slli	s3,s1,0x3
    80004eae:	99a6                	add	s3,s3,s1
    80004eb0:	098e                	slli	s3,s3,0x3
    80004eb2:	99ca                	add	s3,s3,s2
    80004eb4:	1709b583          	ld	a1,368(s3)
    80004eb8:	00004517          	auipc	a0,0x4
    80004ebc:	a2850513          	addi	a0,a0,-1496 # 800088e0 <syscalls+0x468>
    80004ec0:	00001097          	auipc	ra,0x1
    80004ec4:	25c080e7          	jalr	604(ra) # 8000611c <printf>
        printf("[Testing] (sys_munmap) : length: %d\n", length);
    80004ec8:	fc043583          	ld	a1,-64(s0)
    80004ecc:	00004517          	auipc	a0,0x4
    80004ed0:	a3c50513          	addi	a0,a0,-1476 # 80008908 <syscalls+0x490>
    80004ed4:	00001097          	auipc	ra,0x1
    80004ed8:	248080e7          	jalr	584(ra) # 8000611c <printf>
        uvmunmap(p_proc->pagetable, p_vma->start_addr, length / PGSIZE, 1);
    80004edc:	4685                	li	a3,1
    80004ede:	fc043603          	ld	a2,-64(s0)
    80004ee2:	8231                	srli	a2,a2,0xc
    80004ee4:	1709b583          	ld	a1,368(s3)
    80004ee8:	05093503          	ld	a0,80(s2)
    80004eec:	ffffc097          	auipc	ra,0xffffc
    80004ef0:	84a080e7          	jalr	-1974(ra) # 80000736 <uvmunmap>
        p_vma->start_addr += length;
    80004ef4:	1709b783          	ld	a5,368(s3)
    80004ef8:	fc043703          	ld	a4,-64(s0)
    80004efc:	97ba                	add	a5,a5,a4
    80004efe:	16f9b823          	sd	a5,368(s3)
        if (p_vma->start_addr == p_vma->end_addr)
    80004f02:	1789b703          	ld	a4,376(s3)
        return 0;
    80004f06:	4501                	li	a0,0
        if (p_vma->start_addr == p_vma->end_addr)
    80004f08:	02e79563          	bne	a5,a4,80004f32 <sys_munmap+0x118>
            printf("[Testing] (sys_munmap) : whole vma closed\n");
    80004f0c:	00004517          	auipc	a0,0x4
    80004f10:	a2450513          	addi	a0,a0,-1500 # 80008930 <syscalls+0x4b8>
    80004f14:	00001097          	auipc	ra,0x1
    80004f18:	208080e7          	jalr	520(ra) # 8000611c <printf>
            p_vma->occupied = 0;
    80004f1c:	1609a423          	sw	zero,360(s3)
            fileclose(p_vma->pf);
    80004f20:	1a89b503          	ld	a0,424(s3)
    80004f24:	fffff097          	auipc	ra,0xfffff
    80004f28:	bdc080e7          	jalr	-1060(ra) # 80003b00 <fileclose>
            return 0;
    80004f2c:	4501                	li	a0,0
    80004f2e:	a011                	j	80004f32 <sys_munmap+0x118>
        return -1;
    80004f30:	557d                	li	a0,-1
}
    80004f32:	70e2                	ld	ra,56(sp)
    80004f34:	7442                	ld	s0,48(sp)
    80004f36:	74a2                	ld	s1,40(sp)
    80004f38:	7902                	ld	s2,32(sp)
    80004f3a:	69e2                	ld	s3,24(sp)
    80004f3c:	6121                	addi	sp,sp,64
    80004f3e:	8082                	ret
            filewrite(p_vma->pf, p_vma->start_addr, length);
    80004f40:	00349793          	slli	a5,s1,0x3
    80004f44:	97a6                	add	a5,a5,s1
    80004f46:	078e                	slli	a5,a5,0x3
    80004f48:	97ca                	add	a5,a5,s2
    80004f4a:	fc042603          	lw	a2,-64(s0)
    80004f4e:	1707b583          	ld	a1,368(a5)
    80004f52:	1a87b503          	ld	a0,424(a5)
    80004f56:	fffff097          	auipc	ra,0xfffff
    80004f5a:	e00080e7          	jalr	-512(ra) # 80003d56 <filewrite>
    80004f5e:	b7b1                	j	80004eaa <sys_munmap+0x90>

0000000080004f60 <sys_open>:

uint64
sys_open(void)
{
    80004f60:	7131                	addi	sp,sp,-192
    80004f62:	fd06                	sd	ra,184(sp)
    80004f64:	f922                	sd	s0,176(sp)
    80004f66:	f526                	sd	s1,168(sp)
    80004f68:	f14a                	sd	s2,160(sp)
    80004f6a:	ed4e                	sd	s3,152(sp)
    80004f6c:	0180                	addi	s0,sp,192
    int fd, omode;
    struct file *f;
    struct inode *ip;
    int n;

    argint(1, &omode);
    80004f6e:	f4c40593          	addi	a1,s0,-180
    80004f72:	4505                	li	a0,1
    80004f74:	ffffd097          	auipc	ra,0xffffd
    80004f78:	184080e7          	jalr	388(ra) # 800020f8 <argint>
    if ((n = argstr(0, path, MAXPATH)) < 0)
    80004f7c:	08000613          	li	a2,128
    80004f80:	f5040593          	addi	a1,s0,-176
    80004f84:	4501                	li	a0,0
    80004f86:	ffffd097          	auipc	ra,0xffffd
    80004f8a:	1b2080e7          	jalr	434(ra) # 80002138 <argstr>
    80004f8e:	87aa                	mv	a5,a0
        return -1;
    80004f90:	557d                	li	a0,-1
    if ((n = argstr(0, path, MAXPATH)) < 0)
    80004f92:	0a07c963          	bltz	a5,80005044 <sys_open+0xe4>

    begin_op();
    80004f96:	ffffe097          	auipc	ra,0xffffe
    80004f9a:	69e080e7          	jalr	1694(ra) # 80003634 <begin_op>

    if (omode & O_CREATE)
    80004f9e:	f4c42783          	lw	a5,-180(s0)
    80004fa2:	2007f793          	andi	a5,a5,512
    80004fa6:	cfc5                	beqz	a5,8000505e <sys_open+0xfe>
    {
        ip = create(path, T_FILE, 0, 0);
    80004fa8:	4681                	li	a3,0
    80004faa:	4601                	li	a2,0
    80004fac:	4589                	li	a1,2
    80004fae:	f5040513          	addi	a0,s0,-176
    80004fb2:	fffff097          	auipc	ra,0xfffff
    80004fb6:	672080e7          	jalr	1650(ra) # 80004624 <create>
    80004fba:	84aa                	mv	s1,a0
        if (ip == 0)
    80004fbc:	c959                	beqz	a0,80005052 <sys_open+0xf2>
            end_op();
            return -1;
        }
    }

    if (ip->type == T_DEVICE && (ip->major < 0 || ip->major >= NDEV))
    80004fbe:	04449703          	lh	a4,68(s1)
    80004fc2:	478d                	li	a5,3
    80004fc4:	00f71763          	bne	a4,a5,80004fd2 <sys_open+0x72>
    80004fc8:	0464d703          	lhu	a4,70(s1)
    80004fcc:	47a5                	li	a5,9
    80004fce:	0ce7ed63          	bltu	a5,a4,800050a8 <sys_open+0x148>
        iunlockput(ip);
        end_op();
        return -1;
    }

    if ((f = filealloc()) == 0 || (fd = fdalloc(f)) < 0)
    80004fd2:	fffff097          	auipc	ra,0xfffff
    80004fd6:	a72080e7          	jalr	-1422(ra) # 80003a44 <filealloc>
    80004fda:	89aa                	mv	s3,a0
    80004fdc:	10050363          	beqz	a0,800050e2 <sys_open+0x182>
    80004fe0:	fffff097          	auipc	ra,0xfffff
    80004fe4:	602080e7          	jalr	1538(ra) # 800045e2 <fdalloc>
    80004fe8:	892a                	mv	s2,a0
    80004fea:	0e054763          	bltz	a0,800050d8 <sys_open+0x178>
        iunlockput(ip);
        end_op();
        return -1;
    }

    if (ip->type == T_DEVICE)
    80004fee:	04449703          	lh	a4,68(s1)
    80004ff2:	478d                	li	a5,3
    80004ff4:	0cf70563          	beq	a4,a5,800050be <sys_open+0x15e>
        f->type = FD_DEVICE;
        f->major = ip->major;
    }
    else
    {
        f->type = FD_INODE;
    80004ff8:	4789                	li	a5,2
    80004ffa:	00f9a023          	sw	a5,0(s3)
        f->off = 0;
    80004ffe:	0209a023          	sw	zero,32(s3)
    }
    f->ip = ip;
    80005002:	0099bc23          	sd	s1,24(s3)
    f->readable = !(omode & O_WRONLY);
    80005006:	f4c42783          	lw	a5,-180(s0)
    8000500a:	0017c713          	xori	a4,a5,1
    8000500e:	8b05                	andi	a4,a4,1
    80005010:	00e98423          	sb	a4,8(s3)
    f->writable = (omode & O_WRONLY) || (omode & O_RDWR);
    80005014:	0037f713          	andi	a4,a5,3
    80005018:	00e03733          	snez	a4,a4
    8000501c:	00e984a3          	sb	a4,9(s3)

    if ((omode & O_TRUNC) && ip->type == T_FILE)
    80005020:	4007f793          	andi	a5,a5,1024
    80005024:	c791                	beqz	a5,80005030 <sys_open+0xd0>
    80005026:	04449703          	lh	a4,68(s1)
    8000502a:	4789                	li	a5,2
    8000502c:	0af70063          	beq	a4,a5,800050cc <sys_open+0x16c>
    {
        itrunc(ip);
    }

    iunlock(ip);
    80005030:	8526                	mv	a0,s1
    80005032:	ffffe097          	auipc	ra,0xffffe
    80005036:	d02080e7          	jalr	-766(ra) # 80002d34 <iunlock>
    end_op();
    8000503a:	ffffe097          	auipc	ra,0xffffe
    8000503e:	67a080e7          	jalr	1658(ra) # 800036b4 <end_op>

    return fd;
    80005042:	854a                	mv	a0,s2
}
    80005044:	70ea                	ld	ra,184(sp)
    80005046:	744a                	ld	s0,176(sp)
    80005048:	74aa                	ld	s1,168(sp)
    8000504a:	790a                	ld	s2,160(sp)
    8000504c:	69ea                	ld	s3,152(sp)
    8000504e:	6129                	addi	sp,sp,192
    80005050:	8082                	ret
            end_op();
    80005052:	ffffe097          	auipc	ra,0xffffe
    80005056:	662080e7          	jalr	1634(ra) # 800036b4 <end_op>
            return -1;
    8000505a:	557d                	li	a0,-1
    8000505c:	b7e5                	j	80005044 <sys_open+0xe4>
        if ((ip = namei(path)) == 0)
    8000505e:	f5040513          	addi	a0,s0,-176
    80005062:	ffffe097          	auipc	ra,0xffffe
    80005066:	3b6080e7          	jalr	950(ra) # 80003418 <namei>
    8000506a:	84aa                	mv	s1,a0
    8000506c:	c905                	beqz	a0,8000509c <sys_open+0x13c>
        ilock(ip);
    8000506e:	ffffe097          	auipc	ra,0xffffe
    80005072:	c04080e7          	jalr	-1020(ra) # 80002c72 <ilock>
        if (ip->type == T_DIR && omode != O_RDONLY)
    80005076:	04449703          	lh	a4,68(s1)
    8000507a:	4785                	li	a5,1
    8000507c:	f4f711e3          	bne	a4,a5,80004fbe <sys_open+0x5e>
    80005080:	f4c42783          	lw	a5,-180(s0)
    80005084:	d7b9                	beqz	a5,80004fd2 <sys_open+0x72>
            iunlockput(ip);
    80005086:	8526                	mv	a0,s1
    80005088:	ffffe097          	auipc	ra,0xffffe
    8000508c:	e4c080e7          	jalr	-436(ra) # 80002ed4 <iunlockput>
            end_op();
    80005090:	ffffe097          	auipc	ra,0xffffe
    80005094:	624080e7          	jalr	1572(ra) # 800036b4 <end_op>
            return -1;
    80005098:	557d                	li	a0,-1
    8000509a:	b76d                	j	80005044 <sys_open+0xe4>
            end_op();
    8000509c:	ffffe097          	auipc	ra,0xffffe
    800050a0:	618080e7          	jalr	1560(ra) # 800036b4 <end_op>
            return -1;
    800050a4:	557d                	li	a0,-1
    800050a6:	bf79                	j	80005044 <sys_open+0xe4>
        iunlockput(ip);
    800050a8:	8526                	mv	a0,s1
    800050aa:	ffffe097          	auipc	ra,0xffffe
    800050ae:	e2a080e7          	jalr	-470(ra) # 80002ed4 <iunlockput>
        end_op();
    800050b2:	ffffe097          	auipc	ra,0xffffe
    800050b6:	602080e7          	jalr	1538(ra) # 800036b4 <end_op>
        return -1;
    800050ba:	557d                	li	a0,-1
    800050bc:	b761                	j	80005044 <sys_open+0xe4>
        f->type = FD_DEVICE;
    800050be:	00f9a023          	sw	a5,0(s3)
        f->major = ip->major;
    800050c2:	04649783          	lh	a5,70(s1)
    800050c6:	02f99223          	sh	a5,36(s3)
    800050ca:	bf25                	j	80005002 <sys_open+0xa2>
        itrunc(ip);
    800050cc:	8526                	mv	a0,s1
    800050ce:	ffffe097          	auipc	ra,0xffffe
    800050d2:	cb2080e7          	jalr	-846(ra) # 80002d80 <itrunc>
    800050d6:	bfa9                	j	80005030 <sys_open+0xd0>
            fileclose(f);
    800050d8:	854e                	mv	a0,s3
    800050da:	fffff097          	auipc	ra,0xfffff
    800050de:	a26080e7          	jalr	-1498(ra) # 80003b00 <fileclose>
        iunlockput(ip);
    800050e2:	8526                	mv	a0,s1
    800050e4:	ffffe097          	auipc	ra,0xffffe
    800050e8:	df0080e7          	jalr	-528(ra) # 80002ed4 <iunlockput>
        end_op();
    800050ec:	ffffe097          	auipc	ra,0xffffe
    800050f0:	5c8080e7          	jalr	1480(ra) # 800036b4 <end_op>
        return -1;
    800050f4:	557d                	li	a0,-1
    800050f6:	b7b9                	j	80005044 <sys_open+0xe4>

00000000800050f8 <sys_mkdir>:

uint64
sys_mkdir(void)
{
    800050f8:	7175                	addi	sp,sp,-144
    800050fa:	e506                	sd	ra,136(sp)
    800050fc:	e122                	sd	s0,128(sp)
    800050fe:	0900                	addi	s0,sp,144
    char path[MAXPATH];
    struct inode *ip;

    begin_op();
    80005100:	ffffe097          	auipc	ra,0xffffe
    80005104:	534080e7          	jalr	1332(ra) # 80003634 <begin_op>
    if (argstr(0, path, MAXPATH) < 0 || (ip = create(path, T_DIR, 0, 0)) == 0)
    80005108:	08000613          	li	a2,128
    8000510c:	f7040593          	addi	a1,s0,-144
    80005110:	4501                	li	a0,0
    80005112:	ffffd097          	auipc	ra,0xffffd
    80005116:	026080e7          	jalr	38(ra) # 80002138 <argstr>
    8000511a:	02054963          	bltz	a0,8000514c <sys_mkdir+0x54>
    8000511e:	4681                	li	a3,0
    80005120:	4601                	li	a2,0
    80005122:	4585                	li	a1,1
    80005124:	f7040513          	addi	a0,s0,-144
    80005128:	fffff097          	auipc	ra,0xfffff
    8000512c:	4fc080e7          	jalr	1276(ra) # 80004624 <create>
    80005130:	cd11                	beqz	a0,8000514c <sys_mkdir+0x54>
    {
        end_op();
        return -1;
    }
    iunlockput(ip);
    80005132:	ffffe097          	auipc	ra,0xffffe
    80005136:	da2080e7          	jalr	-606(ra) # 80002ed4 <iunlockput>
    end_op();
    8000513a:	ffffe097          	auipc	ra,0xffffe
    8000513e:	57a080e7          	jalr	1402(ra) # 800036b4 <end_op>
    return 0;
    80005142:	4501                	li	a0,0
}
    80005144:	60aa                	ld	ra,136(sp)
    80005146:	640a                	ld	s0,128(sp)
    80005148:	6149                	addi	sp,sp,144
    8000514a:	8082                	ret
        end_op();
    8000514c:	ffffe097          	auipc	ra,0xffffe
    80005150:	568080e7          	jalr	1384(ra) # 800036b4 <end_op>
        return -1;
    80005154:	557d                	li	a0,-1
    80005156:	b7fd                	j	80005144 <sys_mkdir+0x4c>

0000000080005158 <sys_mknod>:

uint64
sys_mknod(void)
{
    80005158:	7135                	addi	sp,sp,-160
    8000515a:	ed06                	sd	ra,152(sp)
    8000515c:	e922                	sd	s0,144(sp)
    8000515e:	1100                	addi	s0,sp,160
    struct inode *ip;
    char path[MAXPATH];
    int major, minor;

    begin_op();
    80005160:	ffffe097          	auipc	ra,0xffffe
    80005164:	4d4080e7          	jalr	1236(ra) # 80003634 <begin_op>
    argint(1, &major);
    80005168:	f6c40593          	addi	a1,s0,-148
    8000516c:	4505                	li	a0,1
    8000516e:	ffffd097          	auipc	ra,0xffffd
    80005172:	f8a080e7          	jalr	-118(ra) # 800020f8 <argint>
    argint(2, &minor);
    80005176:	f6840593          	addi	a1,s0,-152
    8000517a:	4509                	li	a0,2
    8000517c:	ffffd097          	auipc	ra,0xffffd
    80005180:	f7c080e7          	jalr	-132(ra) # 800020f8 <argint>
    if ((argstr(0, path, MAXPATH)) < 0 ||
    80005184:	08000613          	li	a2,128
    80005188:	f7040593          	addi	a1,s0,-144
    8000518c:	4501                	li	a0,0
    8000518e:	ffffd097          	auipc	ra,0xffffd
    80005192:	faa080e7          	jalr	-86(ra) # 80002138 <argstr>
    80005196:	02054b63          	bltz	a0,800051cc <sys_mknod+0x74>
        (ip = create(path, T_DEVICE, major, minor)) == 0)
    8000519a:	f6841683          	lh	a3,-152(s0)
    8000519e:	f6c41603          	lh	a2,-148(s0)
    800051a2:	458d                	li	a1,3
    800051a4:	f7040513          	addi	a0,s0,-144
    800051a8:	fffff097          	auipc	ra,0xfffff
    800051ac:	47c080e7          	jalr	1148(ra) # 80004624 <create>
    if ((argstr(0, path, MAXPATH)) < 0 ||
    800051b0:	cd11                	beqz	a0,800051cc <sys_mknod+0x74>
    {
        end_op();
        return -1;
    }
    iunlockput(ip);
    800051b2:	ffffe097          	auipc	ra,0xffffe
    800051b6:	d22080e7          	jalr	-734(ra) # 80002ed4 <iunlockput>
    end_op();
    800051ba:	ffffe097          	auipc	ra,0xffffe
    800051be:	4fa080e7          	jalr	1274(ra) # 800036b4 <end_op>
    return 0;
    800051c2:	4501                	li	a0,0
}
    800051c4:	60ea                	ld	ra,152(sp)
    800051c6:	644a                	ld	s0,144(sp)
    800051c8:	610d                	addi	sp,sp,160
    800051ca:	8082                	ret
        end_op();
    800051cc:	ffffe097          	auipc	ra,0xffffe
    800051d0:	4e8080e7          	jalr	1256(ra) # 800036b4 <end_op>
        return -1;
    800051d4:	557d                	li	a0,-1
    800051d6:	b7fd                	j	800051c4 <sys_mknod+0x6c>

00000000800051d8 <sys_chdir>:

uint64
sys_chdir(void)
{
    800051d8:	7135                	addi	sp,sp,-160
    800051da:	ed06                	sd	ra,152(sp)
    800051dc:	e922                	sd	s0,144(sp)
    800051de:	e526                	sd	s1,136(sp)
    800051e0:	e14a                	sd	s2,128(sp)
    800051e2:	1100                	addi	s0,sp,160
    char path[MAXPATH];
    struct inode *ip;
    struct proc *p = myproc();
    800051e4:	ffffc097          	auipc	ra,0xffffc
    800051e8:	c7e080e7          	jalr	-898(ra) # 80000e62 <myproc>
    800051ec:	892a                	mv	s2,a0

    begin_op();
    800051ee:	ffffe097          	auipc	ra,0xffffe
    800051f2:	446080e7          	jalr	1094(ra) # 80003634 <begin_op>
    if (argstr(0, path, MAXPATH) < 0 || (ip = namei(path)) == 0)
    800051f6:	08000613          	li	a2,128
    800051fa:	f6040593          	addi	a1,s0,-160
    800051fe:	4501                	li	a0,0
    80005200:	ffffd097          	auipc	ra,0xffffd
    80005204:	f38080e7          	jalr	-200(ra) # 80002138 <argstr>
    80005208:	04054b63          	bltz	a0,8000525e <sys_chdir+0x86>
    8000520c:	f6040513          	addi	a0,s0,-160
    80005210:	ffffe097          	auipc	ra,0xffffe
    80005214:	208080e7          	jalr	520(ra) # 80003418 <namei>
    80005218:	84aa                	mv	s1,a0
    8000521a:	c131                	beqz	a0,8000525e <sys_chdir+0x86>
    {
        end_op();
        return -1;
    }
    ilock(ip);
    8000521c:	ffffe097          	auipc	ra,0xffffe
    80005220:	a56080e7          	jalr	-1450(ra) # 80002c72 <ilock>
    if (ip->type != T_DIR)
    80005224:	04449703          	lh	a4,68(s1)
    80005228:	4785                	li	a5,1
    8000522a:	04f71063          	bne	a4,a5,8000526a <sys_chdir+0x92>
    {
        iunlockput(ip);
        end_op();
        return -1;
    }
    iunlock(ip);
    8000522e:	8526                	mv	a0,s1
    80005230:	ffffe097          	auipc	ra,0xffffe
    80005234:	b04080e7          	jalr	-1276(ra) # 80002d34 <iunlock>
    iput(p->cwd);
    80005238:	15093503          	ld	a0,336(s2)
    8000523c:	ffffe097          	auipc	ra,0xffffe
    80005240:	bf0080e7          	jalr	-1040(ra) # 80002e2c <iput>
    end_op();
    80005244:	ffffe097          	auipc	ra,0xffffe
    80005248:	470080e7          	jalr	1136(ra) # 800036b4 <end_op>
    p->cwd = ip;
    8000524c:	14993823          	sd	s1,336(s2)
    return 0;
    80005250:	4501                	li	a0,0
}
    80005252:	60ea                	ld	ra,152(sp)
    80005254:	644a                	ld	s0,144(sp)
    80005256:	64aa                	ld	s1,136(sp)
    80005258:	690a                	ld	s2,128(sp)
    8000525a:	610d                	addi	sp,sp,160
    8000525c:	8082                	ret
        end_op();
    8000525e:	ffffe097          	auipc	ra,0xffffe
    80005262:	456080e7          	jalr	1110(ra) # 800036b4 <end_op>
        return -1;
    80005266:	557d                	li	a0,-1
    80005268:	b7ed                	j	80005252 <sys_chdir+0x7a>
        iunlockput(ip);
    8000526a:	8526                	mv	a0,s1
    8000526c:	ffffe097          	auipc	ra,0xffffe
    80005270:	c68080e7          	jalr	-920(ra) # 80002ed4 <iunlockput>
        end_op();
    80005274:	ffffe097          	auipc	ra,0xffffe
    80005278:	440080e7          	jalr	1088(ra) # 800036b4 <end_op>
        return -1;
    8000527c:	557d                	li	a0,-1
    8000527e:	bfd1                	j	80005252 <sys_chdir+0x7a>

0000000080005280 <sys_exec>:

uint64
sys_exec(void)
{
    80005280:	7145                	addi	sp,sp,-464
    80005282:	e786                	sd	ra,456(sp)
    80005284:	e3a2                	sd	s0,448(sp)
    80005286:	ff26                	sd	s1,440(sp)
    80005288:	fb4a                	sd	s2,432(sp)
    8000528a:	f74e                	sd	s3,424(sp)
    8000528c:	f352                	sd	s4,416(sp)
    8000528e:	ef56                	sd	s5,408(sp)
    80005290:	0b80                	addi	s0,sp,464
    char path[MAXPATH], *argv[MAXARG];
    int i;
    uint64 uargv, uarg;

    argaddr(1, &uargv);
    80005292:	e3840593          	addi	a1,s0,-456
    80005296:	4505                	li	a0,1
    80005298:	ffffd097          	auipc	ra,0xffffd
    8000529c:	e80080e7          	jalr	-384(ra) # 80002118 <argaddr>
    if (argstr(0, path, MAXPATH) < 0)
    800052a0:	08000613          	li	a2,128
    800052a4:	f4040593          	addi	a1,s0,-192
    800052a8:	4501                	li	a0,0
    800052aa:	ffffd097          	auipc	ra,0xffffd
    800052ae:	e8e080e7          	jalr	-370(ra) # 80002138 <argstr>
    800052b2:	87aa                	mv	a5,a0
    {
        return -1;
    800052b4:	557d                	li	a0,-1
    if (argstr(0, path, MAXPATH) < 0)
    800052b6:	0c07c263          	bltz	a5,8000537a <sys_exec+0xfa>
    }
    memset(argv, 0, sizeof(argv));
    800052ba:	10000613          	li	a2,256
    800052be:	4581                	li	a1,0
    800052c0:	e4040513          	addi	a0,s0,-448
    800052c4:	ffffb097          	auipc	ra,0xffffb
    800052c8:	eb4080e7          	jalr	-332(ra) # 80000178 <memset>
    for (i = 0;; i++)
    {
        if (i >= NELEM(argv))
    800052cc:	e4040493          	addi	s1,s0,-448
    memset(argv, 0, sizeof(argv));
    800052d0:	89a6                	mv	s3,s1
    800052d2:	4901                	li	s2,0
        if (i >= NELEM(argv))
    800052d4:	02000a13          	li	s4,32
    800052d8:	00090a9b          	sext.w	s5,s2
        {
            goto bad;
        }
        if (fetchaddr(uargv + sizeof(uint64) * i, (uint64 *)&uarg) < 0)
    800052dc:	00391513          	slli	a0,s2,0x3
    800052e0:	e3040593          	addi	a1,s0,-464
    800052e4:	e3843783          	ld	a5,-456(s0)
    800052e8:	953e                	add	a0,a0,a5
    800052ea:	ffffd097          	auipc	ra,0xffffd
    800052ee:	d70080e7          	jalr	-656(ra) # 8000205a <fetchaddr>
    800052f2:	02054a63          	bltz	a0,80005326 <sys_exec+0xa6>
        {
            goto bad;
        }
        if (uarg == 0)
    800052f6:	e3043783          	ld	a5,-464(s0)
    800052fa:	c3b9                	beqz	a5,80005340 <sys_exec+0xc0>
        {
            argv[i] = 0;
            break;
        }
        argv[i] = kalloc();
    800052fc:	ffffb097          	auipc	ra,0xffffb
    80005300:	e1c080e7          	jalr	-484(ra) # 80000118 <kalloc>
    80005304:	85aa                	mv	a1,a0
    80005306:	00a9b023          	sd	a0,0(s3)
        if (argv[i] == 0)
    8000530a:	cd11                	beqz	a0,80005326 <sys_exec+0xa6>
            goto bad;
        if (fetchstr(uarg, argv[i], PGSIZE) < 0)
    8000530c:	6605                	lui	a2,0x1
    8000530e:	e3043503          	ld	a0,-464(s0)
    80005312:	ffffd097          	auipc	ra,0xffffd
    80005316:	d9a080e7          	jalr	-614(ra) # 800020ac <fetchstr>
    8000531a:	00054663          	bltz	a0,80005326 <sys_exec+0xa6>
        if (i >= NELEM(argv))
    8000531e:	0905                	addi	s2,s2,1
    80005320:	09a1                	addi	s3,s3,8
    80005322:	fb491be3          	bne	s2,s4,800052d8 <sys_exec+0x58>
        kfree(argv[i]);

    return ret;

bad:
    for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005326:	10048913          	addi	s2,s1,256
    8000532a:	6088                	ld	a0,0(s1)
    8000532c:	c531                	beqz	a0,80005378 <sys_exec+0xf8>
        kfree(argv[i]);
    8000532e:	ffffb097          	auipc	ra,0xffffb
    80005332:	cee080e7          	jalr	-786(ra) # 8000001c <kfree>
    for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    80005336:	04a1                	addi	s1,s1,8
    80005338:	ff2499e3          	bne	s1,s2,8000532a <sys_exec+0xaa>
    return -1;
    8000533c:	557d                	li	a0,-1
    8000533e:	a835                	j	8000537a <sys_exec+0xfa>
            argv[i] = 0;
    80005340:	0a8e                	slli	s5,s5,0x3
    80005342:	fc040793          	addi	a5,s0,-64
    80005346:	9abe                	add	s5,s5,a5
    80005348:	e80ab023          	sd	zero,-384(s5)
    int ret = exec(path, argv);
    8000534c:	e4040593          	addi	a1,s0,-448
    80005350:	f4040513          	addi	a0,s0,-192
    80005354:	fffff097          	auipc	ra,0xfffff
    80005358:	e8e080e7          	jalr	-370(ra) # 800041e2 <exec>
    8000535c:	892a                	mv	s2,a0
    for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000535e:	10048993          	addi	s3,s1,256
    80005362:	6088                	ld	a0,0(s1)
    80005364:	c901                	beqz	a0,80005374 <sys_exec+0xf4>
        kfree(argv[i]);
    80005366:	ffffb097          	auipc	ra,0xffffb
    8000536a:	cb6080e7          	jalr	-842(ra) # 8000001c <kfree>
    for (i = 0; i < NELEM(argv) && argv[i] != 0; i++)
    8000536e:	04a1                	addi	s1,s1,8
    80005370:	ff3499e3          	bne	s1,s3,80005362 <sys_exec+0xe2>
    return ret;
    80005374:	854a                	mv	a0,s2
    80005376:	a011                	j	8000537a <sys_exec+0xfa>
    return -1;
    80005378:	557d                	li	a0,-1
}
    8000537a:	60be                	ld	ra,456(sp)
    8000537c:	641e                	ld	s0,448(sp)
    8000537e:	74fa                	ld	s1,440(sp)
    80005380:	795a                	ld	s2,432(sp)
    80005382:	79ba                	ld	s3,424(sp)
    80005384:	7a1a                	ld	s4,416(sp)
    80005386:	6afa                	ld	s5,408(sp)
    80005388:	6179                	addi	sp,sp,464
    8000538a:	8082                	ret

000000008000538c <sys_pipe>:

uint64
sys_pipe(void)
{
    8000538c:	7139                	addi	sp,sp,-64
    8000538e:	fc06                	sd	ra,56(sp)
    80005390:	f822                	sd	s0,48(sp)
    80005392:	f426                	sd	s1,40(sp)
    80005394:	0080                	addi	s0,sp,64
    uint64 fdarray; // user pointer to array of two integers
    struct file *rf, *wf;
    int fd0, fd1;
    struct proc *p = myproc();
    80005396:	ffffc097          	auipc	ra,0xffffc
    8000539a:	acc080e7          	jalr	-1332(ra) # 80000e62 <myproc>
    8000539e:	84aa                	mv	s1,a0

    argaddr(0, &fdarray);
    800053a0:	fd840593          	addi	a1,s0,-40
    800053a4:	4501                	li	a0,0
    800053a6:	ffffd097          	auipc	ra,0xffffd
    800053aa:	d72080e7          	jalr	-654(ra) # 80002118 <argaddr>
    if (pipealloc(&rf, &wf) < 0)
    800053ae:	fc840593          	addi	a1,s0,-56
    800053b2:	fd040513          	addi	a0,s0,-48
    800053b6:	fffff097          	auipc	ra,0xfffff
    800053ba:	ad4080e7          	jalr	-1324(ra) # 80003e8a <pipealloc>
        return -1;
    800053be:	57fd                	li	a5,-1
    if (pipealloc(&rf, &wf) < 0)
    800053c0:	0c054463          	bltz	a0,80005488 <sys_pipe+0xfc>
    fd0 = -1;
    800053c4:	fcf42223          	sw	a5,-60(s0)
    if ((fd0 = fdalloc(rf)) < 0 || (fd1 = fdalloc(wf)) < 0)
    800053c8:	fd043503          	ld	a0,-48(s0)
    800053cc:	fffff097          	auipc	ra,0xfffff
    800053d0:	216080e7          	jalr	534(ra) # 800045e2 <fdalloc>
    800053d4:	fca42223          	sw	a0,-60(s0)
    800053d8:	08054b63          	bltz	a0,8000546e <sys_pipe+0xe2>
    800053dc:	fc843503          	ld	a0,-56(s0)
    800053e0:	fffff097          	auipc	ra,0xfffff
    800053e4:	202080e7          	jalr	514(ra) # 800045e2 <fdalloc>
    800053e8:	fca42023          	sw	a0,-64(s0)
    800053ec:	06054863          	bltz	a0,8000545c <sys_pipe+0xd0>
            p->ofile[fd0] = 0;
        fileclose(rf);
        fileclose(wf);
        return -1;
    }
    if (copyout(p->pagetable, fdarray, (char *)&fd0, sizeof(fd0)) < 0 ||
    800053f0:	4691                	li	a3,4
    800053f2:	fc440613          	addi	a2,s0,-60
    800053f6:	fd843583          	ld	a1,-40(s0)
    800053fa:	68a8                	ld	a0,80(s1)
    800053fc:	ffffb097          	auipc	ra,0xffffb
    80005400:	724080e7          	jalr	1828(ra) # 80000b20 <copyout>
    80005404:	02054063          	bltz	a0,80005424 <sys_pipe+0x98>
        copyout(p->pagetable, fdarray + sizeof(fd0), (char *)&fd1, sizeof(fd1)) < 0)
    80005408:	4691                	li	a3,4
    8000540a:	fc040613          	addi	a2,s0,-64
    8000540e:	fd843583          	ld	a1,-40(s0)
    80005412:	0591                	addi	a1,a1,4
    80005414:	68a8                	ld	a0,80(s1)
    80005416:	ffffb097          	auipc	ra,0xffffb
    8000541a:	70a080e7          	jalr	1802(ra) # 80000b20 <copyout>
        p->ofile[fd1] = 0;
        fileclose(rf);
        fileclose(wf);
        return -1;
    }
    return 0;
    8000541e:	4781                	li	a5,0
    if (copyout(p->pagetable, fdarray, (char *)&fd0, sizeof(fd0)) < 0 ||
    80005420:	06055463          	bgez	a0,80005488 <sys_pipe+0xfc>
        p->ofile[fd0] = 0;
    80005424:	fc442783          	lw	a5,-60(s0)
    80005428:	07e9                	addi	a5,a5,26
    8000542a:	078e                	slli	a5,a5,0x3
    8000542c:	97a6                	add	a5,a5,s1
    8000542e:	0007b023          	sd	zero,0(a5)
        p->ofile[fd1] = 0;
    80005432:	fc042503          	lw	a0,-64(s0)
    80005436:	0569                	addi	a0,a0,26
    80005438:	050e                	slli	a0,a0,0x3
    8000543a:	94aa                	add	s1,s1,a0
    8000543c:	0004b023          	sd	zero,0(s1)
        fileclose(rf);
    80005440:	fd043503          	ld	a0,-48(s0)
    80005444:	ffffe097          	auipc	ra,0xffffe
    80005448:	6bc080e7          	jalr	1724(ra) # 80003b00 <fileclose>
        fileclose(wf);
    8000544c:	fc843503          	ld	a0,-56(s0)
    80005450:	ffffe097          	auipc	ra,0xffffe
    80005454:	6b0080e7          	jalr	1712(ra) # 80003b00 <fileclose>
        return -1;
    80005458:	57fd                	li	a5,-1
    8000545a:	a03d                	j	80005488 <sys_pipe+0xfc>
        if (fd0 >= 0)
    8000545c:	fc442783          	lw	a5,-60(s0)
    80005460:	0007c763          	bltz	a5,8000546e <sys_pipe+0xe2>
            p->ofile[fd0] = 0;
    80005464:	07e9                	addi	a5,a5,26
    80005466:	078e                	slli	a5,a5,0x3
    80005468:	94be                	add	s1,s1,a5
    8000546a:	0004b023          	sd	zero,0(s1)
        fileclose(rf);
    8000546e:	fd043503          	ld	a0,-48(s0)
    80005472:	ffffe097          	auipc	ra,0xffffe
    80005476:	68e080e7          	jalr	1678(ra) # 80003b00 <fileclose>
        fileclose(wf);
    8000547a:	fc843503          	ld	a0,-56(s0)
    8000547e:	ffffe097          	auipc	ra,0xffffe
    80005482:	682080e7          	jalr	1666(ra) # 80003b00 <fileclose>
        return -1;
    80005486:	57fd                	li	a5,-1
}
    80005488:	853e                	mv	a0,a5
    8000548a:	70e2                	ld	ra,56(sp)
    8000548c:	7442                	ld	s0,48(sp)
    8000548e:	74a2                	ld	s1,40(sp)
    80005490:	6121                	addi	sp,sp,64
    80005492:	8082                	ret
	...

00000000800054a0 <kernelvec>:
    800054a0:	7111                	addi	sp,sp,-256
    800054a2:	e006                	sd	ra,0(sp)
    800054a4:	e40a                	sd	sp,8(sp)
    800054a6:	e80e                	sd	gp,16(sp)
    800054a8:	ec12                	sd	tp,24(sp)
    800054aa:	f016                	sd	t0,32(sp)
    800054ac:	f41a                	sd	t1,40(sp)
    800054ae:	f81e                	sd	t2,48(sp)
    800054b0:	fc22                	sd	s0,56(sp)
    800054b2:	e0a6                	sd	s1,64(sp)
    800054b4:	e4aa                	sd	a0,72(sp)
    800054b6:	e8ae                	sd	a1,80(sp)
    800054b8:	ecb2                	sd	a2,88(sp)
    800054ba:	f0b6                	sd	a3,96(sp)
    800054bc:	f4ba                	sd	a4,104(sp)
    800054be:	f8be                	sd	a5,112(sp)
    800054c0:	fcc2                	sd	a6,120(sp)
    800054c2:	e146                	sd	a7,128(sp)
    800054c4:	e54a                	sd	s2,136(sp)
    800054c6:	e94e                	sd	s3,144(sp)
    800054c8:	ed52                	sd	s4,152(sp)
    800054ca:	f156                	sd	s5,160(sp)
    800054cc:	f55a                	sd	s6,168(sp)
    800054ce:	f95e                	sd	s7,176(sp)
    800054d0:	fd62                	sd	s8,184(sp)
    800054d2:	e1e6                	sd	s9,192(sp)
    800054d4:	e5ea                	sd	s10,200(sp)
    800054d6:	e9ee                	sd	s11,208(sp)
    800054d8:	edf2                	sd	t3,216(sp)
    800054da:	f1f6                	sd	t4,224(sp)
    800054dc:	f5fa                	sd	t5,232(sp)
    800054de:	f9fe                	sd	t6,240(sp)
    800054e0:	a47fc0ef          	jal	ra,80001f26 <kerneltrap>
    800054e4:	6082                	ld	ra,0(sp)
    800054e6:	6122                	ld	sp,8(sp)
    800054e8:	61c2                	ld	gp,16(sp)
    800054ea:	7282                	ld	t0,32(sp)
    800054ec:	7322                	ld	t1,40(sp)
    800054ee:	73c2                	ld	t2,48(sp)
    800054f0:	7462                	ld	s0,56(sp)
    800054f2:	6486                	ld	s1,64(sp)
    800054f4:	6526                	ld	a0,72(sp)
    800054f6:	65c6                	ld	a1,80(sp)
    800054f8:	6666                	ld	a2,88(sp)
    800054fa:	7686                	ld	a3,96(sp)
    800054fc:	7726                	ld	a4,104(sp)
    800054fe:	77c6                	ld	a5,112(sp)
    80005500:	7866                	ld	a6,120(sp)
    80005502:	688a                	ld	a7,128(sp)
    80005504:	692a                	ld	s2,136(sp)
    80005506:	69ca                	ld	s3,144(sp)
    80005508:	6a6a                	ld	s4,152(sp)
    8000550a:	7a8a                	ld	s5,160(sp)
    8000550c:	7b2a                	ld	s6,168(sp)
    8000550e:	7bca                	ld	s7,176(sp)
    80005510:	7c6a                	ld	s8,184(sp)
    80005512:	6c8e                	ld	s9,192(sp)
    80005514:	6d2e                	ld	s10,200(sp)
    80005516:	6dce                	ld	s11,208(sp)
    80005518:	6e6e                	ld	t3,216(sp)
    8000551a:	7e8e                	ld	t4,224(sp)
    8000551c:	7f2e                	ld	t5,232(sp)
    8000551e:	7fce                	ld	t6,240(sp)
    80005520:	6111                	addi	sp,sp,256
    80005522:	10200073          	sret
    80005526:	00000013          	nop
    8000552a:	00000013          	nop
    8000552e:	0001                	nop

0000000080005530 <timervec>:
    80005530:	34051573          	csrrw	a0,mscratch,a0
    80005534:	e10c                	sd	a1,0(a0)
    80005536:	e510                	sd	a2,8(a0)
    80005538:	e914                	sd	a3,16(a0)
    8000553a:	6d0c                	ld	a1,24(a0)
    8000553c:	7110                	ld	a2,32(a0)
    8000553e:	6194                	ld	a3,0(a1)
    80005540:	96b2                	add	a3,a3,a2
    80005542:	e194                	sd	a3,0(a1)
    80005544:	4589                	li	a1,2
    80005546:	14459073          	csrw	sip,a1
    8000554a:	6914                	ld	a3,16(a0)
    8000554c:	6510                	ld	a2,8(a0)
    8000554e:	610c                	ld	a1,0(a0)
    80005550:	34051573          	csrrw	a0,mscratch,a0
    80005554:	30200073          	mret
	...

000000008000555a <plicinit>:
// the riscv Platform Level Interrupt Controller (PLIC).
//

void
plicinit(void)
{
    8000555a:	1141                	addi	sp,sp,-16
    8000555c:	e422                	sd	s0,8(sp)
    8000555e:	0800                	addi	s0,sp,16
  // set desired IRQ priorities non-zero (otherwise disabled).
  *(uint32*)(PLIC + UART0_IRQ*4) = 1;
    80005560:	0c0007b7          	lui	a5,0xc000
    80005564:	4705                	li	a4,1
    80005566:	d798                	sw	a4,40(a5)
  *(uint32*)(PLIC + VIRTIO0_IRQ*4) = 1;
    80005568:	c3d8                	sw	a4,4(a5)
}
    8000556a:	6422                	ld	s0,8(sp)
    8000556c:	0141                	addi	sp,sp,16
    8000556e:	8082                	ret

0000000080005570 <plicinithart>:

void
plicinithart(void)
{
    80005570:	1141                	addi	sp,sp,-16
    80005572:	e406                	sd	ra,8(sp)
    80005574:	e022                	sd	s0,0(sp)
    80005576:	0800                	addi	s0,sp,16
  int hart = cpuid();
    80005578:	ffffc097          	auipc	ra,0xffffc
    8000557c:	8be080e7          	jalr	-1858(ra) # 80000e36 <cpuid>
  
  // set enable bits for this hart's S-mode
  // for the uart and virtio disk.
  *(uint32*)PLIC_SENABLE(hart) = (1 << UART0_IRQ) | (1 << VIRTIO0_IRQ);
    80005580:	0085171b          	slliw	a4,a0,0x8
    80005584:	0c0027b7          	lui	a5,0xc002
    80005588:	97ba                	add	a5,a5,a4
    8000558a:	40200713          	li	a4,1026
    8000558e:	08e7a023          	sw	a4,128(a5) # c002080 <_entry-0x73ffdf80>

  // set this hart's S-mode priority threshold to 0.
  *(uint32*)PLIC_SPRIORITY(hart) = 0;
    80005592:	00d5151b          	slliw	a0,a0,0xd
    80005596:	0c2017b7          	lui	a5,0xc201
    8000559a:	953e                	add	a0,a0,a5
    8000559c:	00052023          	sw	zero,0(a0)
}
    800055a0:	60a2                	ld	ra,8(sp)
    800055a2:	6402                	ld	s0,0(sp)
    800055a4:	0141                	addi	sp,sp,16
    800055a6:	8082                	ret

00000000800055a8 <plic_claim>:

// ask the PLIC what interrupt we should serve.
int
plic_claim(void)
{
    800055a8:	1141                	addi	sp,sp,-16
    800055aa:	e406                	sd	ra,8(sp)
    800055ac:	e022                	sd	s0,0(sp)
    800055ae:	0800                	addi	s0,sp,16
  int hart = cpuid();
    800055b0:	ffffc097          	auipc	ra,0xffffc
    800055b4:	886080e7          	jalr	-1914(ra) # 80000e36 <cpuid>
  int irq = *(uint32*)PLIC_SCLAIM(hart);
    800055b8:	00d5179b          	slliw	a5,a0,0xd
    800055bc:	0c201537          	lui	a0,0xc201
    800055c0:	953e                	add	a0,a0,a5
  return irq;
}
    800055c2:	4148                	lw	a0,4(a0)
    800055c4:	60a2                	ld	ra,8(sp)
    800055c6:	6402                	ld	s0,0(sp)
    800055c8:	0141                	addi	sp,sp,16
    800055ca:	8082                	ret

00000000800055cc <plic_complete>:

// tell the PLIC we've served this IRQ.
void
plic_complete(int irq)
{
    800055cc:	1101                	addi	sp,sp,-32
    800055ce:	ec06                	sd	ra,24(sp)
    800055d0:	e822                	sd	s0,16(sp)
    800055d2:	e426                	sd	s1,8(sp)
    800055d4:	1000                	addi	s0,sp,32
    800055d6:	84aa                	mv	s1,a0
  int hart = cpuid();
    800055d8:	ffffc097          	auipc	ra,0xffffc
    800055dc:	85e080e7          	jalr	-1954(ra) # 80000e36 <cpuid>
  *(uint32*)PLIC_SCLAIM(hart) = irq;
    800055e0:	00d5151b          	slliw	a0,a0,0xd
    800055e4:	0c2017b7          	lui	a5,0xc201
    800055e8:	97aa                	add	a5,a5,a0
    800055ea:	c3c4                	sw	s1,4(a5)
}
    800055ec:	60e2                	ld	ra,24(sp)
    800055ee:	6442                	ld	s0,16(sp)
    800055f0:	64a2                	ld	s1,8(sp)
    800055f2:	6105                	addi	sp,sp,32
    800055f4:	8082                	ret

00000000800055f6 <free_desc>:
}

// mark a descriptor as free.
static void
free_desc(int i)
{
    800055f6:	1141                	addi	sp,sp,-16
    800055f8:	e406                	sd	ra,8(sp)
    800055fa:	e022                	sd	s0,0(sp)
    800055fc:	0800                	addi	s0,sp,16
  if(i >= NUM)
    800055fe:	479d                	li	a5,7
    80005600:	04a7cc63          	blt	a5,a0,80005658 <free_desc+0x62>
    panic("free_desc 1");
  if(disk.free[i])
    80005604:	00026797          	auipc	a5,0x26
    80005608:	66c78793          	addi	a5,a5,1644 # 8002bc70 <disk>
    8000560c:	97aa                	add	a5,a5,a0
    8000560e:	0187c783          	lbu	a5,24(a5)
    80005612:	ebb9                	bnez	a5,80005668 <free_desc+0x72>
    panic("free_desc 2");
  disk.desc[i].addr = 0;
    80005614:	00451613          	slli	a2,a0,0x4
    80005618:	00026797          	auipc	a5,0x26
    8000561c:	65878793          	addi	a5,a5,1624 # 8002bc70 <disk>
    80005620:	6394                	ld	a3,0(a5)
    80005622:	96b2                	add	a3,a3,a2
    80005624:	0006b023          	sd	zero,0(a3)
  disk.desc[i].len = 0;
    80005628:	6398                	ld	a4,0(a5)
    8000562a:	9732                	add	a4,a4,a2
    8000562c:	00072423          	sw	zero,8(a4)
  disk.desc[i].flags = 0;
    80005630:	00071623          	sh	zero,12(a4)
  disk.desc[i].next = 0;
    80005634:	00071723          	sh	zero,14(a4)
  disk.free[i] = 1;
    80005638:	953e                	add	a0,a0,a5
    8000563a:	4785                	li	a5,1
    8000563c:	00f50c23          	sb	a5,24(a0) # c201018 <_entry-0x73dfefe8>
  wakeup(&disk.free[0]);
    80005640:	00026517          	auipc	a0,0x26
    80005644:	64850513          	addi	a0,a0,1608 # 8002bc88 <disk+0x18>
    80005648:	ffffc097          	auipc	ra,0xffffc
    8000564c:	f62080e7          	jalr	-158(ra) # 800015aa <wakeup>
}
    80005650:	60a2                	ld	ra,8(sp)
    80005652:	6402                	ld	s0,0(sp)
    80005654:	0141                	addi	sp,sp,16
    80005656:	8082                	ret
    panic("free_desc 1");
    80005658:	00003517          	auipc	a0,0x3
    8000565c:	30850513          	addi	a0,a0,776 # 80008960 <syscalls+0x4e8>
    80005660:	00001097          	auipc	ra,0x1
    80005664:	a72080e7          	jalr	-1422(ra) # 800060d2 <panic>
    panic("free_desc 2");
    80005668:	00003517          	auipc	a0,0x3
    8000566c:	30850513          	addi	a0,a0,776 # 80008970 <syscalls+0x4f8>
    80005670:	00001097          	auipc	ra,0x1
    80005674:	a62080e7          	jalr	-1438(ra) # 800060d2 <panic>

0000000080005678 <virtio_disk_init>:
{
    80005678:	1101                	addi	sp,sp,-32
    8000567a:	ec06                	sd	ra,24(sp)
    8000567c:	e822                	sd	s0,16(sp)
    8000567e:	e426                	sd	s1,8(sp)
    80005680:	e04a                	sd	s2,0(sp)
    80005682:	1000                	addi	s0,sp,32
  initlock(&disk.vdisk_lock, "virtio_disk");
    80005684:	00003597          	auipc	a1,0x3
    80005688:	2fc58593          	addi	a1,a1,764 # 80008980 <syscalls+0x508>
    8000568c:	00026517          	auipc	a0,0x26
    80005690:	70c50513          	addi	a0,a0,1804 # 8002bd98 <disk+0x128>
    80005694:	00001097          	auipc	ra,0x1
    80005698:	ef8080e7          	jalr	-264(ra) # 8000658c <initlock>
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    8000569c:	100017b7          	lui	a5,0x10001
    800056a0:	4398                	lw	a4,0(a5)
    800056a2:	2701                	sext.w	a4,a4
    800056a4:	747277b7          	lui	a5,0x74727
    800056a8:	97678793          	addi	a5,a5,-1674 # 74726976 <_entry-0xb8d968a>
    800056ac:	14f71e63          	bne	a4,a5,80005808 <virtio_disk_init+0x190>
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800056b0:	100017b7          	lui	a5,0x10001
    800056b4:	43dc                	lw	a5,4(a5)
    800056b6:	2781                	sext.w	a5,a5
  if(*R(VIRTIO_MMIO_MAGIC_VALUE) != 0x74726976 ||
    800056b8:	4709                	li	a4,2
    800056ba:	14e79763          	bne	a5,a4,80005808 <virtio_disk_init+0x190>
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800056be:	100017b7          	lui	a5,0x10001
    800056c2:	479c                	lw	a5,8(a5)
    800056c4:	2781                	sext.w	a5,a5
     *R(VIRTIO_MMIO_VERSION) != 2 ||
    800056c6:	14e79163          	bne	a5,a4,80005808 <virtio_disk_init+0x190>
     *R(VIRTIO_MMIO_VENDOR_ID) != 0x554d4551){
    800056ca:	100017b7          	lui	a5,0x10001
    800056ce:	47d8                	lw	a4,12(a5)
    800056d0:	2701                	sext.w	a4,a4
     *R(VIRTIO_MMIO_DEVICE_ID) != 2 ||
    800056d2:	554d47b7          	lui	a5,0x554d4
    800056d6:	55178793          	addi	a5,a5,1361 # 554d4551 <_entry-0x2ab2baaf>
    800056da:	12f71763          	bne	a4,a5,80005808 <virtio_disk_init+0x190>
  *R(VIRTIO_MMIO_STATUS) = status;
    800056de:	100017b7          	lui	a5,0x10001
    800056e2:	0607a823          	sw	zero,112(a5) # 10001070 <_entry-0x6fffef90>
  *R(VIRTIO_MMIO_STATUS) = status;
    800056e6:	4705                	li	a4,1
    800056e8:	dbb8                	sw	a4,112(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800056ea:	470d                	li	a4,3
    800056ec:	dbb8                	sw	a4,112(a5)
  uint64 features = *R(VIRTIO_MMIO_DEVICE_FEATURES);
    800056ee:	4b94                	lw	a3,16(a5)
  features &= ~(1 << VIRTIO_RING_F_INDIRECT_DESC);
    800056f0:	c7ffe737          	lui	a4,0xc7ffe
    800056f4:	75f70713          	addi	a4,a4,1887 # ffffffffc7ffe75f <end+0xffffffff47fca76f>
    800056f8:	8f75                	and	a4,a4,a3
  *R(VIRTIO_MMIO_DRIVER_FEATURES) = features;
    800056fa:	2701                	sext.w	a4,a4
    800056fc:	d398                	sw	a4,32(a5)
  *R(VIRTIO_MMIO_STATUS) = status;
    800056fe:	472d                	li	a4,11
    80005700:	dbb8                	sw	a4,112(a5)
  status = *R(VIRTIO_MMIO_STATUS);
    80005702:	0707a903          	lw	s2,112(a5)
    80005706:	2901                	sext.w	s2,s2
  if(!(status & VIRTIO_CONFIG_S_FEATURES_OK))
    80005708:	00897793          	andi	a5,s2,8
    8000570c:	10078663          	beqz	a5,80005818 <virtio_disk_init+0x1a0>
  *R(VIRTIO_MMIO_QUEUE_SEL) = 0;
    80005710:	100017b7          	lui	a5,0x10001
    80005714:	0207a823          	sw	zero,48(a5) # 10001030 <_entry-0x6fffefd0>
  if(*R(VIRTIO_MMIO_QUEUE_READY))
    80005718:	43fc                	lw	a5,68(a5)
    8000571a:	2781                	sext.w	a5,a5
    8000571c:	10079663          	bnez	a5,80005828 <virtio_disk_init+0x1b0>
  uint32 max = *R(VIRTIO_MMIO_QUEUE_NUM_MAX);
    80005720:	100017b7          	lui	a5,0x10001
    80005724:	5bdc                	lw	a5,52(a5)
    80005726:	2781                	sext.w	a5,a5
  if(max == 0)
    80005728:	10078863          	beqz	a5,80005838 <virtio_disk_init+0x1c0>
  if(max < NUM)
    8000572c:	471d                	li	a4,7
    8000572e:	10f77d63          	bgeu	a4,a5,80005848 <virtio_disk_init+0x1d0>
  disk.desc = kalloc();
    80005732:	ffffb097          	auipc	ra,0xffffb
    80005736:	9e6080e7          	jalr	-1562(ra) # 80000118 <kalloc>
    8000573a:	00026497          	auipc	s1,0x26
    8000573e:	53648493          	addi	s1,s1,1334 # 8002bc70 <disk>
    80005742:	e088                	sd	a0,0(s1)
  disk.avail = kalloc();
    80005744:	ffffb097          	auipc	ra,0xffffb
    80005748:	9d4080e7          	jalr	-1580(ra) # 80000118 <kalloc>
    8000574c:	e488                	sd	a0,8(s1)
  disk.used = kalloc();
    8000574e:	ffffb097          	auipc	ra,0xffffb
    80005752:	9ca080e7          	jalr	-1590(ra) # 80000118 <kalloc>
    80005756:	87aa                	mv	a5,a0
    80005758:	e888                	sd	a0,16(s1)
  if(!disk.desc || !disk.avail || !disk.used)
    8000575a:	6088                	ld	a0,0(s1)
    8000575c:	cd75                	beqz	a0,80005858 <virtio_disk_init+0x1e0>
    8000575e:	00026717          	auipc	a4,0x26
    80005762:	51a73703          	ld	a4,1306(a4) # 8002bc78 <disk+0x8>
    80005766:	cb6d                	beqz	a4,80005858 <virtio_disk_init+0x1e0>
    80005768:	cbe5                	beqz	a5,80005858 <virtio_disk_init+0x1e0>
  memset(disk.desc, 0, PGSIZE);
    8000576a:	6605                	lui	a2,0x1
    8000576c:	4581                	li	a1,0
    8000576e:	ffffb097          	auipc	ra,0xffffb
    80005772:	a0a080e7          	jalr	-1526(ra) # 80000178 <memset>
  memset(disk.avail, 0, PGSIZE);
    80005776:	00026497          	auipc	s1,0x26
    8000577a:	4fa48493          	addi	s1,s1,1274 # 8002bc70 <disk>
    8000577e:	6605                	lui	a2,0x1
    80005780:	4581                	li	a1,0
    80005782:	6488                	ld	a0,8(s1)
    80005784:	ffffb097          	auipc	ra,0xffffb
    80005788:	9f4080e7          	jalr	-1548(ra) # 80000178 <memset>
  memset(disk.used, 0, PGSIZE);
    8000578c:	6605                	lui	a2,0x1
    8000578e:	4581                	li	a1,0
    80005790:	6888                	ld	a0,16(s1)
    80005792:	ffffb097          	auipc	ra,0xffffb
    80005796:	9e6080e7          	jalr	-1562(ra) # 80000178 <memset>
  *R(VIRTIO_MMIO_QUEUE_NUM) = NUM;
    8000579a:	100017b7          	lui	a5,0x10001
    8000579e:	4721                	li	a4,8
    800057a0:	df98                	sw	a4,56(a5)
  *R(VIRTIO_MMIO_QUEUE_DESC_LOW) = (uint64)disk.desc;
    800057a2:	4098                	lw	a4,0(s1)
    800057a4:	08e7a023          	sw	a4,128(a5) # 10001080 <_entry-0x6fffef80>
  *R(VIRTIO_MMIO_QUEUE_DESC_HIGH) = (uint64)disk.desc >> 32;
    800057a8:	40d8                	lw	a4,4(s1)
    800057aa:	08e7a223          	sw	a4,132(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_LOW) = (uint64)disk.avail;
    800057ae:	6498                	ld	a4,8(s1)
    800057b0:	0007069b          	sext.w	a3,a4
    800057b4:	08d7a823          	sw	a3,144(a5)
  *R(VIRTIO_MMIO_DRIVER_DESC_HIGH) = (uint64)disk.avail >> 32;
    800057b8:	9701                	srai	a4,a4,0x20
    800057ba:	08e7aa23          	sw	a4,148(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_LOW) = (uint64)disk.used;
    800057be:	6898                	ld	a4,16(s1)
    800057c0:	0007069b          	sext.w	a3,a4
    800057c4:	0ad7a023          	sw	a3,160(a5)
  *R(VIRTIO_MMIO_DEVICE_DESC_HIGH) = (uint64)disk.used >> 32;
    800057c8:	9701                	srai	a4,a4,0x20
    800057ca:	0ae7a223          	sw	a4,164(a5)
  *R(VIRTIO_MMIO_QUEUE_READY) = 0x1;
    800057ce:	4685                	li	a3,1
    800057d0:	c3f4                	sw	a3,68(a5)
    disk.free[i] = 1;
    800057d2:	4705                	li	a4,1
    800057d4:	00d48c23          	sb	a3,24(s1)
    800057d8:	00e48ca3          	sb	a4,25(s1)
    800057dc:	00e48d23          	sb	a4,26(s1)
    800057e0:	00e48da3          	sb	a4,27(s1)
    800057e4:	00e48e23          	sb	a4,28(s1)
    800057e8:	00e48ea3          	sb	a4,29(s1)
    800057ec:	00e48f23          	sb	a4,30(s1)
    800057f0:	00e48fa3          	sb	a4,31(s1)
  status |= VIRTIO_CONFIG_S_DRIVER_OK;
    800057f4:	00496913          	ori	s2,s2,4
  *R(VIRTIO_MMIO_STATUS) = status;
    800057f8:	0727a823          	sw	s2,112(a5)
}
    800057fc:	60e2                	ld	ra,24(sp)
    800057fe:	6442                	ld	s0,16(sp)
    80005800:	64a2                	ld	s1,8(sp)
    80005802:	6902                	ld	s2,0(sp)
    80005804:	6105                	addi	sp,sp,32
    80005806:	8082                	ret
    panic("could not find virtio disk");
    80005808:	00003517          	auipc	a0,0x3
    8000580c:	18850513          	addi	a0,a0,392 # 80008990 <syscalls+0x518>
    80005810:	00001097          	auipc	ra,0x1
    80005814:	8c2080e7          	jalr	-1854(ra) # 800060d2 <panic>
    panic("virtio disk FEATURES_OK unset");
    80005818:	00003517          	auipc	a0,0x3
    8000581c:	19850513          	addi	a0,a0,408 # 800089b0 <syscalls+0x538>
    80005820:	00001097          	auipc	ra,0x1
    80005824:	8b2080e7          	jalr	-1870(ra) # 800060d2 <panic>
    panic("virtio disk should not be ready");
    80005828:	00003517          	auipc	a0,0x3
    8000582c:	1a850513          	addi	a0,a0,424 # 800089d0 <syscalls+0x558>
    80005830:	00001097          	auipc	ra,0x1
    80005834:	8a2080e7          	jalr	-1886(ra) # 800060d2 <panic>
    panic("virtio disk has no queue 0");
    80005838:	00003517          	auipc	a0,0x3
    8000583c:	1b850513          	addi	a0,a0,440 # 800089f0 <syscalls+0x578>
    80005840:	00001097          	auipc	ra,0x1
    80005844:	892080e7          	jalr	-1902(ra) # 800060d2 <panic>
    panic("virtio disk max queue too short");
    80005848:	00003517          	auipc	a0,0x3
    8000584c:	1c850513          	addi	a0,a0,456 # 80008a10 <syscalls+0x598>
    80005850:	00001097          	auipc	ra,0x1
    80005854:	882080e7          	jalr	-1918(ra) # 800060d2 <panic>
    panic("virtio disk kalloc");
    80005858:	00003517          	auipc	a0,0x3
    8000585c:	1d850513          	addi	a0,a0,472 # 80008a30 <syscalls+0x5b8>
    80005860:	00001097          	auipc	ra,0x1
    80005864:	872080e7          	jalr	-1934(ra) # 800060d2 <panic>

0000000080005868 <virtio_disk_rw>:
  return 0;
}

void
virtio_disk_rw(struct buf *b, int write)
{
    80005868:	7159                	addi	sp,sp,-112
    8000586a:	f486                	sd	ra,104(sp)
    8000586c:	f0a2                	sd	s0,96(sp)
    8000586e:	eca6                	sd	s1,88(sp)
    80005870:	e8ca                	sd	s2,80(sp)
    80005872:	e4ce                	sd	s3,72(sp)
    80005874:	e0d2                	sd	s4,64(sp)
    80005876:	fc56                	sd	s5,56(sp)
    80005878:	f85a                	sd	s6,48(sp)
    8000587a:	f45e                	sd	s7,40(sp)
    8000587c:	f062                	sd	s8,32(sp)
    8000587e:	ec66                	sd	s9,24(sp)
    80005880:	e86a                	sd	s10,16(sp)
    80005882:	1880                	addi	s0,sp,112
    80005884:	892a                	mv	s2,a0
    80005886:	8d2e                	mv	s10,a1
  uint64 sector = b->blockno * (BSIZE / 512);
    80005888:	00c52c83          	lw	s9,12(a0)
    8000588c:	001c9c9b          	slliw	s9,s9,0x1
    80005890:	1c82                	slli	s9,s9,0x20
    80005892:	020cdc93          	srli	s9,s9,0x20

  acquire(&disk.vdisk_lock);
    80005896:	00026517          	auipc	a0,0x26
    8000589a:	50250513          	addi	a0,a0,1282 # 8002bd98 <disk+0x128>
    8000589e:	00001097          	auipc	ra,0x1
    800058a2:	d7e080e7          	jalr	-642(ra) # 8000661c <acquire>
  for(int i = 0; i < 3; i++){
    800058a6:	4981                	li	s3,0
  for(int i = 0; i < NUM; i++){
    800058a8:	4ba1                	li	s7,8
      disk.free[i] = 0;
    800058aa:	00026b17          	auipc	s6,0x26
    800058ae:	3c6b0b13          	addi	s6,s6,966 # 8002bc70 <disk>
  for(int i = 0; i < 3; i++){
    800058b2:	4a8d                	li	s5,3
  for(int i = 0; i < NUM; i++){
    800058b4:	8a4e                	mv	s4,s3
  int idx[3];
  while(1){
    if(alloc3_desc(idx) == 0) {
      break;
    }
    sleep(&disk.free[0], &disk.vdisk_lock);
    800058b6:	00026c17          	auipc	s8,0x26
    800058ba:	4e2c0c13          	addi	s8,s8,1250 # 8002bd98 <disk+0x128>
    800058be:	a8b5                	j	8000593a <virtio_disk_rw+0xd2>
      disk.free[i] = 0;
    800058c0:	00fb06b3          	add	a3,s6,a5
    800058c4:	00068c23          	sb	zero,24(a3)
    idx[i] = alloc_desc();
    800058c8:	c21c                	sw	a5,0(a2)
    if(idx[i] < 0){
    800058ca:	0207c563          	bltz	a5,800058f4 <virtio_disk_rw+0x8c>
  for(int i = 0; i < 3; i++){
    800058ce:	2485                	addiw	s1,s1,1
    800058d0:	0711                	addi	a4,a4,4
    800058d2:	1f548a63          	beq	s1,s5,80005ac6 <virtio_disk_rw+0x25e>
    idx[i] = alloc_desc();
    800058d6:	863a                	mv	a2,a4
  for(int i = 0; i < NUM; i++){
    800058d8:	00026697          	auipc	a3,0x26
    800058dc:	39868693          	addi	a3,a3,920 # 8002bc70 <disk>
    800058e0:	87d2                	mv	a5,s4
    if(disk.free[i]){
    800058e2:	0186c583          	lbu	a1,24(a3)
    800058e6:	fde9                	bnez	a1,800058c0 <virtio_disk_rw+0x58>
  for(int i = 0; i < NUM; i++){
    800058e8:	2785                	addiw	a5,a5,1
    800058ea:	0685                	addi	a3,a3,1
    800058ec:	ff779be3          	bne	a5,s7,800058e2 <virtio_disk_rw+0x7a>
    idx[i] = alloc_desc();
    800058f0:	57fd                	li	a5,-1
    800058f2:	c21c                	sw	a5,0(a2)
      for(int j = 0; j < i; j++)
    800058f4:	02905a63          	blez	s1,80005928 <virtio_disk_rw+0xc0>
        free_desc(idx[j]);
    800058f8:	f9042503          	lw	a0,-112(s0)
    800058fc:	00000097          	auipc	ra,0x0
    80005900:	cfa080e7          	jalr	-774(ra) # 800055f6 <free_desc>
      for(int j = 0; j < i; j++)
    80005904:	4785                	li	a5,1
    80005906:	0297d163          	bge	a5,s1,80005928 <virtio_disk_rw+0xc0>
        free_desc(idx[j]);
    8000590a:	f9442503          	lw	a0,-108(s0)
    8000590e:	00000097          	auipc	ra,0x0
    80005912:	ce8080e7          	jalr	-792(ra) # 800055f6 <free_desc>
      for(int j = 0; j < i; j++)
    80005916:	4789                	li	a5,2
    80005918:	0097d863          	bge	a5,s1,80005928 <virtio_disk_rw+0xc0>
        free_desc(idx[j]);
    8000591c:	f9842503          	lw	a0,-104(s0)
    80005920:	00000097          	auipc	ra,0x0
    80005924:	cd6080e7          	jalr	-810(ra) # 800055f6 <free_desc>
    sleep(&disk.free[0], &disk.vdisk_lock);
    80005928:	85e2                	mv	a1,s8
    8000592a:	00026517          	auipc	a0,0x26
    8000592e:	35e50513          	addi	a0,a0,862 # 8002bc88 <disk+0x18>
    80005932:	ffffc097          	auipc	ra,0xffffc
    80005936:	c14080e7          	jalr	-1004(ra) # 80001546 <sleep>
  for(int i = 0; i < 3; i++){
    8000593a:	f9040713          	addi	a4,s0,-112
    8000593e:	84ce                	mv	s1,s3
    80005940:	bf59                	j	800058d6 <virtio_disk_rw+0x6e>
  // qemu's virtio-blk.c reads them.

  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];

  if(write)
    buf0->type = VIRTIO_BLK_T_OUT; // write the disk
    80005942:	00a60793          	addi	a5,a2,10 # 100a <_entry-0x7fffeff6>
    80005946:	00479693          	slli	a3,a5,0x4
    8000594a:	00026797          	auipc	a5,0x26
    8000594e:	32678793          	addi	a5,a5,806 # 8002bc70 <disk>
    80005952:	97b6                	add	a5,a5,a3
    80005954:	4685                	li	a3,1
    80005956:	c794                	sw	a3,8(a5)
  else
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
  buf0->reserved = 0;
    80005958:	00026597          	auipc	a1,0x26
    8000595c:	31858593          	addi	a1,a1,792 # 8002bc70 <disk>
    80005960:	00a60793          	addi	a5,a2,10
    80005964:	0792                	slli	a5,a5,0x4
    80005966:	97ae                	add	a5,a5,a1
    80005968:	0007a623          	sw	zero,12(a5)
  buf0->sector = sector;
    8000596c:	0197b823          	sd	s9,16(a5)

  disk.desc[idx[0]].addr = (uint64) buf0;
    80005970:	f6070693          	addi	a3,a4,-160
    80005974:	619c                	ld	a5,0(a1)
    80005976:	97b6                	add	a5,a5,a3
    80005978:	e388                	sd	a0,0(a5)
  disk.desc[idx[0]].len = sizeof(struct virtio_blk_req);
    8000597a:	6188                	ld	a0,0(a1)
    8000597c:	96aa                	add	a3,a3,a0
    8000597e:	47c1                	li	a5,16
    80005980:	c69c                	sw	a5,8(a3)
  disk.desc[idx[0]].flags = VRING_DESC_F_NEXT;
    80005982:	4785                	li	a5,1
    80005984:	00f69623          	sh	a5,12(a3)
  disk.desc[idx[0]].next = idx[1];
    80005988:	f9442783          	lw	a5,-108(s0)
    8000598c:	00f69723          	sh	a5,14(a3)

  disk.desc[idx[1]].addr = (uint64) b->data;
    80005990:	0792                	slli	a5,a5,0x4
    80005992:	953e                	add	a0,a0,a5
    80005994:	05890693          	addi	a3,s2,88
    80005998:	e114                	sd	a3,0(a0)
  disk.desc[idx[1]].len = BSIZE;
    8000599a:	6188                	ld	a0,0(a1)
    8000599c:	97aa                	add	a5,a5,a0
    8000599e:	40000693          	li	a3,1024
    800059a2:	c794                	sw	a3,8(a5)
  if(write)
    800059a4:	100d0d63          	beqz	s10,80005abe <virtio_disk_rw+0x256>
    disk.desc[idx[1]].flags = 0; // device reads b->data
    800059a8:	00079623          	sh	zero,12(a5)
  else
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
  disk.desc[idx[1]].flags |= VRING_DESC_F_NEXT;
    800059ac:	00c7d683          	lhu	a3,12(a5)
    800059b0:	0016e693          	ori	a3,a3,1
    800059b4:	00d79623          	sh	a3,12(a5)
  disk.desc[idx[1]].next = idx[2];
    800059b8:	f9842583          	lw	a1,-104(s0)
    800059bc:	00b79723          	sh	a1,14(a5)

  disk.info[idx[0]].status = 0xff; // device writes 0 on success
    800059c0:	00026697          	auipc	a3,0x26
    800059c4:	2b068693          	addi	a3,a3,688 # 8002bc70 <disk>
    800059c8:	00260793          	addi	a5,a2,2
    800059cc:	0792                	slli	a5,a5,0x4
    800059ce:	97b6                	add	a5,a5,a3
    800059d0:	587d                	li	a6,-1
    800059d2:	01078823          	sb	a6,16(a5)
  disk.desc[idx[2]].addr = (uint64) &disk.info[idx[0]].status;
    800059d6:	0592                	slli	a1,a1,0x4
    800059d8:	952e                	add	a0,a0,a1
    800059da:	f9070713          	addi	a4,a4,-112
    800059de:	9736                	add	a4,a4,a3
    800059e0:	e118                	sd	a4,0(a0)
  disk.desc[idx[2]].len = 1;
    800059e2:	6298                	ld	a4,0(a3)
    800059e4:	972e                	add	a4,a4,a1
    800059e6:	4585                	li	a1,1
    800059e8:	c70c                	sw	a1,8(a4)
  disk.desc[idx[2]].flags = VRING_DESC_F_WRITE; // device writes the status
    800059ea:	4509                	li	a0,2
    800059ec:	00a71623          	sh	a0,12(a4)
  disk.desc[idx[2]].next = 0;
    800059f0:	00071723          	sh	zero,14(a4)

  // record struct buf for virtio_disk_intr().
  b->disk = 1;
    800059f4:	00b92223          	sw	a1,4(s2)
  disk.info[idx[0]].b = b;
    800059f8:	0127b423          	sd	s2,8(a5)

  // tell the device the first index in our chain of descriptors.
  disk.avail->ring[disk.avail->idx % NUM] = idx[0];
    800059fc:	6698                	ld	a4,8(a3)
    800059fe:	00275783          	lhu	a5,2(a4)
    80005a02:	8b9d                	andi	a5,a5,7
    80005a04:	0786                	slli	a5,a5,0x1
    80005a06:	97ba                	add	a5,a5,a4
    80005a08:	00c79223          	sh	a2,4(a5)

  __sync_synchronize();
    80005a0c:	0ff0000f          	fence

  // tell the device another avail ring entry is available.
  disk.avail->idx += 1; // not % NUM ...
    80005a10:	6698                	ld	a4,8(a3)
    80005a12:	00275783          	lhu	a5,2(a4)
    80005a16:	2785                	addiw	a5,a5,1
    80005a18:	00f71123          	sh	a5,2(a4)

  __sync_synchronize();
    80005a1c:	0ff0000f          	fence

  *R(VIRTIO_MMIO_QUEUE_NOTIFY) = 0; // value is queue number
    80005a20:	100017b7          	lui	a5,0x10001
    80005a24:	0407a823          	sw	zero,80(a5) # 10001050 <_entry-0x6fffefb0>

  // Wait for virtio_disk_intr() to say request has finished.
  while(b->disk == 1) {
    80005a28:	00492703          	lw	a4,4(s2)
    80005a2c:	4785                	li	a5,1
    80005a2e:	02f71163          	bne	a4,a5,80005a50 <virtio_disk_rw+0x1e8>
    sleep(b, &disk.vdisk_lock);
    80005a32:	00026997          	auipc	s3,0x26
    80005a36:	36698993          	addi	s3,s3,870 # 8002bd98 <disk+0x128>
  while(b->disk == 1) {
    80005a3a:	4485                	li	s1,1
    sleep(b, &disk.vdisk_lock);
    80005a3c:	85ce                	mv	a1,s3
    80005a3e:	854a                	mv	a0,s2
    80005a40:	ffffc097          	auipc	ra,0xffffc
    80005a44:	b06080e7          	jalr	-1274(ra) # 80001546 <sleep>
  while(b->disk == 1) {
    80005a48:	00492783          	lw	a5,4(s2)
    80005a4c:	fe9788e3          	beq	a5,s1,80005a3c <virtio_disk_rw+0x1d4>
  }

  disk.info[idx[0]].b = 0;
    80005a50:	f9042903          	lw	s2,-112(s0)
    80005a54:	00290793          	addi	a5,s2,2
    80005a58:	00479713          	slli	a4,a5,0x4
    80005a5c:	00026797          	auipc	a5,0x26
    80005a60:	21478793          	addi	a5,a5,532 # 8002bc70 <disk>
    80005a64:	97ba                	add	a5,a5,a4
    80005a66:	0007b423          	sd	zero,8(a5)
    int flag = disk.desc[i].flags;
    80005a6a:	00026997          	auipc	s3,0x26
    80005a6e:	20698993          	addi	s3,s3,518 # 8002bc70 <disk>
    80005a72:	00491713          	slli	a4,s2,0x4
    80005a76:	0009b783          	ld	a5,0(s3)
    80005a7a:	97ba                	add	a5,a5,a4
    80005a7c:	00c7d483          	lhu	s1,12(a5)
    int nxt = disk.desc[i].next;
    80005a80:	854a                	mv	a0,s2
    80005a82:	00e7d903          	lhu	s2,14(a5)
    free_desc(i);
    80005a86:	00000097          	auipc	ra,0x0
    80005a8a:	b70080e7          	jalr	-1168(ra) # 800055f6 <free_desc>
    if(flag & VRING_DESC_F_NEXT)
    80005a8e:	8885                	andi	s1,s1,1
    80005a90:	f0ed                	bnez	s1,80005a72 <virtio_disk_rw+0x20a>
  free_chain(idx[0]);

  release(&disk.vdisk_lock);
    80005a92:	00026517          	auipc	a0,0x26
    80005a96:	30650513          	addi	a0,a0,774 # 8002bd98 <disk+0x128>
    80005a9a:	00001097          	auipc	ra,0x1
    80005a9e:	c36080e7          	jalr	-970(ra) # 800066d0 <release>
}
    80005aa2:	70a6                	ld	ra,104(sp)
    80005aa4:	7406                	ld	s0,96(sp)
    80005aa6:	64e6                	ld	s1,88(sp)
    80005aa8:	6946                	ld	s2,80(sp)
    80005aaa:	69a6                	ld	s3,72(sp)
    80005aac:	6a06                	ld	s4,64(sp)
    80005aae:	7ae2                	ld	s5,56(sp)
    80005ab0:	7b42                	ld	s6,48(sp)
    80005ab2:	7ba2                	ld	s7,40(sp)
    80005ab4:	7c02                	ld	s8,32(sp)
    80005ab6:	6ce2                	ld	s9,24(sp)
    80005ab8:	6d42                	ld	s10,16(sp)
    80005aba:	6165                	addi	sp,sp,112
    80005abc:	8082                	ret
    disk.desc[idx[1]].flags = VRING_DESC_F_WRITE; // device writes b->data
    80005abe:	4689                	li	a3,2
    80005ac0:	00d79623          	sh	a3,12(a5)
    80005ac4:	b5e5                	j	800059ac <virtio_disk_rw+0x144>
  struct virtio_blk_req *buf0 = &disk.ops[idx[0]];
    80005ac6:	f9042603          	lw	a2,-112(s0)
    80005aca:	00a60713          	addi	a4,a2,10
    80005ace:	0712                	slli	a4,a4,0x4
    80005ad0:	00026517          	auipc	a0,0x26
    80005ad4:	1a850513          	addi	a0,a0,424 # 8002bc78 <disk+0x8>
    80005ad8:	953a                	add	a0,a0,a4
  if(write)
    80005ada:	e60d14e3          	bnez	s10,80005942 <virtio_disk_rw+0xda>
    buf0->type = VIRTIO_BLK_T_IN; // read the disk
    80005ade:	00a60793          	addi	a5,a2,10
    80005ae2:	00479693          	slli	a3,a5,0x4
    80005ae6:	00026797          	auipc	a5,0x26
    80005aea:	18a78793          	addi	a5,a5,394 # 8002bc70 <disk>
    80005aee:	97b6                	add	a5,a5,a3
    80005af0:	0007a423          	sw	zero,8(a5)
    80005af4:	b595                	j	80005958 <virtio_disk_rw+0xf0>

0000000080005af6 <virtio_disk_intr>:

void
virtio_disk_intr()
{
    80005af6:	1101                	addi	sp,sp,-32
    80005af8:	ec06                	sd	ra,24(sp)
    80005afa:	e822                	sd	s0,16(sp)
    80005afc:	e426                	sd	s1,8(sp)
    80005afe:	1000                	addi	s0,sp,32
  acquire(&disk.vdisk_lock);
    80005b00:	00026497          	auipc	s1,0x26
    80005b04:	17048493          	addi	s1,s1,368 # 8002bc70 <disk>
    80005b08:	00026517          	auipc	a0,0x26
    80005b0c:	29050513          	addi	a0,a0,656 # 8002bd98 <disk+0x128>
    80005b10:	00001097          	auipc	ra,0x1
    80005b14:	b0c080e7          	jalr	-1268(ra) # 8000661c <acquire>
  // we've seen this interrupt, which the following line does.
  // this may race with the device writing new entries to
  // the "used" ring, in which case we may process the new
  // completion entries in this interrupt, and have nothing to do
  // in the next interrupt, which is harmless.
  *R(VIRTIO_MMIO_INTERRUPT_ACK) = *R(VIRTIO_MMIO_INTERRUPT_STATUS) & 0x3;
    80005b18:	10001737          	lui	a4,0x10001
    80005b1c:	533c                	lw	a5,96(a4)
    80005b1e:	8b8d                	andi	a5,a5,3
    80005b20:	d37c                	sw	a5,100(a4)

  __sync_synchronize();
    80005b22:	0ff0000f          	fence

  // the device increments disk.used->idx when it
  // adds an entry to the used ring.

  while(disk.used_idx != disk.used->idx){
    80005b26:	689c                	ld	a5,16(s1)
    80005b28:	0204d703          	lhu	a4,32(s1)
    80005b2c:	0027d783          	lhu	a5,2(a5)
    80005b30:	04f70863          	beq	a4,a5,80005b80 <virtio_disk_intr+0x8a>
    __sync_synchronize();
    80005b34:	0ff0000f          	fence
    int id = disk.used->ring[disk.used_idx % NUM].id;
    80005b38:	6898                	ld	a4,16(s1)
    80005b3a:	0204d783          	lhu	a5,32(s1)
    80005b3e:	8b9d                	andi	a5,a5,7
    80005b40:	078e                	slli	a5,a5,0x3
    80005b42:	97ba                	add	a5,a5,a4
    80005b44:	43dc                	lw	a5,4(a5)

    if(disk.info[id].status != 0)
    80005b46:	00278713          	addi	a4,a5,2
    80005b4a:	0712                	slli	a4,a4,0x4
    80005b4c:	9726                	add	a4,a4,s1
    80005b4e:	01074703          	lbu	a4,16(a4) # 10001010 <_entry-0x6fffeff0>
    80005b52:	e721                	bnez	a4,80005b9a <virtio_disk_intr+0xa4>
      panic("virtio_disk_intr status");

    struct buf *b = disk.info[id].b;
    80005b54:	0789                	addi	a5,a5,2
    80005b56:	0792                	slli	a5,a5,0x4
    80005b58:	97a6                	add	a5,a5,s1
    80005b5a:	6788                	ld	a0,8(a5)
    b->disk = 0;   // disk is done with buf
    80005b5c:	00052223          	sw	zero,4(a0)
    wakeup(b);
    80005b60:	ffffc097          	auipc	ra,0xffffc
    80005b64:	a4a080e7          	jalr	-1462(ra) # 800015aa <wakeup>

    disk.used_idx += 1;
    80005b68:	0204d783          	lhu	a5,32(s1)
    80005b6c:	2785                	addiw	a5,a5,1
    80005b6e:	17c2                	slli	a5,a5,0x30
    80005b70:	93c1                	srli	a5,a5,0x30
    80005b72:	02f49023          	sh	a5,32(s1)
  while(disk.used_idx != disk.used->idx){
    80005b76:	6898                	ld	a4,16(s1)
    80005b78:	00275703          	lhu	a4,2(a4)
    80005b7c:	faf71ce3          	bne	a4,a5,80005b34 <virtio_disk_intr+0x3e>
  }

  release(&disk.vdisk_lock);
    80005b80:	00026517          	auipc	a0,0x26
    80005b84:	21850513          	addi	a0,a0,536 # 8002bd98 <disk+0x128>
    80005b88:	00001097          	auipc	ra,0x1
    80005b8c:	b48080e7          	jalr	-1208(ra) # 800066d0 <release>
}
    80005b90:	60e2                	ld	ra,24(sp)
    80005b92:	6442                	ld	s0,16(sp)
    80005b94:	64a2                	ld	s1,8(sp)
    80005b96:	6105                	addi	sp,sp,32
    80005b98:	8082                	ret
      panic("virtio_disk_intr status");
    80005b9a:	00003517          	auipc	a0,0x3
    80005b9e:	eae50513          	addi	a0,a0,-338 # 80008a48 <syscalls+0x5d0>
    80005ba2:	00000097          	auipc	ra,0x0
    80005ba6:	530080e7          	jalr	1328(ra) # 800060d2 <panic>

0000000080005baa <timerinit>:
// at timervec in kernelvec.S,
// which turns them into software interrupts for
// devintr() in trap.c.
void
timerinit()
{
    80005baa:	1141                	addi	sp,sp,-16
    80005bac:	e422                	sd	s0,8(sp)
    80005bae:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005bb0:	f14027f3          	csrr	a5,mhartid
  // each CPU has a separate source of timer interrupts.
  int id = r_mhartid();
    80005bb4:	0007869b          	sext.w	a3,a5

  // ask the CLINT for a timer interrupt.
  int interval = 1000000; // cycles; about 1/10th second in qemu.
  *(uint64*)CLINT_MTIMECMP(id) = *(uint64*)CLINT_MTIME + interval;
    80005bb8:	0037979b          	slliw	a5,a5,0x3
    80005bbc:	02004737          	lui	a4,0x2004
    80005bc0:	97ba                	add	a5,a5,a4
    80005bc2:	0200c737          	lui	a4,0x200c
    80005bc6:	ff873583          	ld	a1,-8(a4) # 200bff8 <_entry-0x7dff4008>
    80005bca:	000f4637          	lui	a2,0xf4
    80005bce:	24060613          	addi	a2,a2,576 # f4240 <_entry-0x7ff0bdc0>
    80005bd2:	95b2                	add	a1,a1,a2
    80005bd4:	e38c                	sd	a1,0(a5)

  // prepare information in scratch[] for timervec.
  // scratch[0..2] : space for timervec to save registers.
  // scratch[3] : address of CLINT MTIMECMP register.
  // scratch[4] : desired interval (in cycles) between timer interrupts.
  uint64 *scratch = &timer_scratch[id][0];
    80005bd6:	00269713          	slli	a4,a3,0x2
    80005bda:	9736                	add	a4,a4,a3
    80005bdc:	00371693          	slli	a3,a4,0x3
    80005be0:	00026717          	auipc	a4,0x26
    80005be4:	1d070713          	addi	a4,a4,464 # 8002bdb0 <timer_scratch>
    80005be8:	9736                	add	a4,a4,a3
  scratch[3] = CLINT_MTIMECMP(id);
    80005bea:	ef1c                	sd	a5,24(a4)
  scratch[4] = interval;
    80005bec:	f310                	sd	a2,32(a4)
  asm volatile("csrw mscratch, %0" : : "r" (x));
    80005bee:	34071073          	csrw	mscratch,a4
  asm volatile("csrw mtvec, %0" : : "r" (x));
    80005bf2:	00000797          	auipc	a5,0x0
    80005bf6:	93e78793          	addi	a5,a5,-1730 # 80005530 <timervec>
    80005bfa:	30579073          	csrw	mtvec,a5
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005bfe:	300027f3          	csrr	a5,mstatus

  // set the machine-mode trap handler.
  w_mtvec((uint64)timervec);

  // enable machine-mode interrupts.
  w_mstatus(r_mstatus() | MSTATUS_MIE);
    80005c02:	0087e793          	ori	a5,a5,8
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005c06:	30079073          	csrw	mstatus,a5
  asm volatile("csrr %0, mie" : "=r" (x) );
    80005c0a:	304027f3          	csrr	a5,mie

  // enable machine-mode timer interrupts.
  w_mie(r_mie() | MIE_MTIE);
    80005c0e:	0807e793          	ori	a5,a5,128
  asm volatile("csrw mie, %0" : : "r" (x));
    80005c12:	30479073          	csrw	mie,a5
}
    80005c16:	6422                	ld	s0,8(sp)
    80005c18:	0141                	addi	sp,sp,16
    80005c1a:	8082                	ret

0000000080005c1c <start>:
{
    80005c1c:	1141                	addi	sp,sp,-16
    80005c1e:	e406                	sd	ra,8(sp)
    80005c20:	e022                	sd	s0,0(sp)
    80005c22:	0800                	addi	s0,sp,16
  asm volatile("csrr %0, mstatus" : "=r" (x) );
    80005c24:	300027f3          	csrr	a5,mstatus
  x &= ~MSTATUS_MPP_MASK;
    80005c28:	7779                	lui	a4,0xffffe
    80005c2a:	7ff70713          	addi	a4,a4,2047 # ffffffffffffe7ff <end+0xffffffff7ffca80f>
    80005c2e:	8ff9                	and	a5,a5,a4
  x |= MSTATUS_MPP_S;
    80005c30:	6705                	lui	a4,0x1
    80005c32:	80070713          	addi	a4,a4,-2048 # 800 <_entry-0x7ffff800>
    80005c36:	8fd9                	or	a5,a5,a4
  asm volatile("csrw mstatus, %0" : : "r" (x));
    80005c38:	30079073          	csrw	mstatus,a5
  asm volatile("csrw mepc, %0" : : "r" (x));
    80005c3c:	ffffa797          	auipc	a5,0xffffa
    80005c40:	6ea78793          	addi	a5,a5,1770 # 80000326 <main>
    80005c44:	34179073          	csrw	mepc,a5
  asm volatile("csrw satp, %0" : : "r" (x));
    80005c48:	4781                	li	a5,0
    80005c4a:	18079073          	csrw	satp,a5
  asm volatile("csrw medeleg, %0" : : "r" (x));
    80005c4e:	67c1                	lui	a5,0x10
    80005c50:	17fd                	addi	a5,a5,-1
    80005c52:	30279073          	csrw	medeleg,a5
  asm volatile("csrw mideleg, %0" : : "r" (x));
    80005c56:	30379073          	csrw	mideleg,a5
  asm volatile("csrr %0, sie" : "=r" (x) );
    80005c5a:	104027f3          	csrr	a5,sie
  w_sie(r_sie() | SIE_SEIE | SIE_STIE | SIE_SSIE);
    80005c5e:	2227e793          	ori	a5,a5,546
  asm volatile("csrw sie, %0" : : "r" (x));
    80005c62:	10479073          	csrw	sie,a5
  asm volatile("csrw pmpaddr0, %0" : : "r" (x));
    80005c66:	57fd                	li	a5,-1
    80005c68:	83a9                	srli	a5,a5,0xa
    80005c6a:	3b079073          	csrw	pmpaddr0,a5
  asm volatile("csrw pmpcfg0, %0" : : "r" (x));
    80005c6e:	47bd                	li	a5,15
    80005c70:	3a079073          	csrw	pmpcfg0,a5
  timerinit();
    80005c74:	00000097          	auipc	ra,0x0
    80005c78:	f36080e7          	jalr	-202(ra) # 80005baa <timerinit>
  asm volatile("csrr %0, mhartid" : "=r" (x) );
    80005c7c:	f14027f3          	csrr	a5,mhartid
  w_tp(id);
    80005c80:	2781                	sext.w	a5,a5
  asm volatile("mv tp, %0" : : "r" (x));
    80005c82:	823e                	mv	tp,a5
  asm volatile("mret");
    80005c84:	30200073          	mret
}
    80005c88:	60a2                	ld	ra,8(sp)
    80005c8a:	6402                	ld	s0,0(sp)
    80005c8c:	0141                	addi	sp,sp,16
    80005c8e:	8082                	ret

0000000080005c90 <consolewrite>:
//
// user write()s to the console go here.
//
int
consolewrite(int user_src, uint64 src, int n)
{
    80005c90:	715d                	addi	sp,sp,-80
    80005c92:	e486                	sd	ra,72(sp)
    80005c94:	e0a2                	sd	s0,64(sp)
    80005c96:	fc26                	sd	s1,56(sp)
    80005c98:	f84a                	sd	s2,48(sp)
    80005c9a:	f44e                	sd	s3,40(sp)
    80005c9c:	f052                	sd	s4,32(sp)
    80005c9e:	ec56                	sd	s5,24(sp)
    80005ca0:	0880                	addi	s0,sp,80
  int i;

  for(i = 0; i < n; i++){
    80005ca2:	04c05663          	blez	a2,80005cee <consolewrite+0x5e>
    80005ca6:	8a2a                	mv	s4,a0
    80005ca8:	84ae                	mv	s1,a1
    80005caa:	89b2                	mv	s3,a2
    80005cac:	4901                	li	s2,0
    char c;
    if(either_copyin(&c, user_src, src+i, 1) == -1)
    80005cae:	5afd                	li	s5,-1
    80005cb0:	4685                	li	a3,1
    80005cb2:	8626                	mv	a2,s1
    80005cb4:	85d2                	mv	a1,s4
    80005cb6:	fbf40513          	addi	a0,s0,-65
    80005cba:	ffffc097          	auipc	ra,0xffffc
    80005cbe:	cea080e7          	jalr	-790(ra) # 800019a4 <either_copyin>
    80005cc2:	01550c63          	beq	a0,s5,80005cda <consolewrite+0x4a>
      break;
    uartputc(c);
    80005cc6:	fbf44503          	lbu	a0,-65(s0)
    80005cca:	00000097          	auipc	ra,0x0
    80005cce:	794080e7          	jalr	1940(ra) # 8000645e <uartputc>
  for(i = 0; i < n; i++){
    80005cd2:	2905                	addiw	s2,s2,1
    80005cd4:	0485                	addi	s1,s1,1
    80005cd6:	fd299de3          	bne	s3,s2,80005cb0 <consolewrite+0x20>
  }

  return i;
}
    80005cda:	854a                	mv	a0,s2
    80005cdc:	60a6                	ld	ra,72(sp)
    80005cde:	6406                	ld	s0,64(sp)
    80005ce0:	74e2                	ld	s1,56(sp)
    80005ce2:	7942                	ld	s2,48(sp)
    80005ce4:	79a2                	ld	s3,40(sp)
    80005ce6:	7a02                	ld	s4,32(sp)
    80005ce8:	6ae2                	ld	s5,24(sp)
    80005cea:	6161                	addi	sp,sp,80
    80005cec:	8082                	ret
  for(i = 0; i < n; i++){
    80005cee:	4901                	li	s2,0
    80005cf0:	b7ed                	j	80005cda <consolewrite+0x4a>

0000000080005cf2 <consoleread>:
// user_dist indicates whether dst is a user
// or kernel address.
//
int
consoleread(int user_dst, uint64 dst, int n)
{
    80005cf2:	7119                	addi	sp,sp,-128
    80005cf4:	fc86                	sd	ra,120(sp)
    80005cf6:	f8a2                	sd	s0,112(sp)
    80005cf8:	f4a6                	sd	s1,104(sp)
    80005cfa:	f0ca                	sd	s2,96(sp)
    80005cfc:	ecce                	sd	s3,88(sp)
    80005cfe:	e8d2                	sd	s4,80(sp)
    80005d00:	e4d6                	sd	s5,72(sp)
    80005d02:	e0da                	sd	s6,64(sp)
    80005d04:	fc5e                	sd	s7,56(sp)
    80005d06:	f862                	sd	s8,48(sp)
    80005d08:	f466                	sd	s9,40(sp)
    80005d0a:	f06a                	sd	s10,32(sp)
    80005d0c:	ec6e                	sd	s11,24(sp)
    80005d0e:	0100                	addi	s0,sp,128
    80005d10:	8b2a                	mv	s6,a0
    80005d12:	8aae                	mv	s5,a1
    80005d14:	8a32                	mv	s4,a2
  uint target;
  int c;
  char cbuf;

  target = n;
    80005d16:	00060b9b          	sext.w	s7,a2
  acquire(&cons.lock);
    80005d1a:	0002e517          	auipc	a0,0x2e
    80005d1e:	1d650513          	addi	a0,a0,470 # 80033ef0 <cons>
    80005d22:	00001097          	auipc	ra,0x1
    80005d26:	8fa080e7          	jalr	-1798(ra) # 8000661c <acquire>
  while(n > 0){
    // wait until interrupt handler has put some
    // input into cons.buffer.
    while(cons.r == cons.w){
    80005d2a:	0002e497          	auipc	s1,0x2e
    80005d2e:	1c648493          	addi	s1,s1,454 # 80033ef0 <cons>
      if(killed(myproc())){
        release(&cons.lock);
        return -1;
      }
      sleep(&cons.r, &cons.lock);
    80005d32:	89a6                	mv	s3,s1
    80005d34:	0002e917          	auipc	s2,0x2e
    80005d38:	25490913          	addi	s2,s2,596 # 80033f88 <cons+0x98>
    }

    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];

    if(c == C('D')){  // end-of-file
    80005d3c:	4c91                	li	s9,4
      break;
    }

    // copy the input byte to the user-space buffer.
    cbuf = c;
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005d3e:	5d7d                	li	s10,-1
      break;

    dst++;
    --n;

    if(c == '\n'){
    80005d40:	4da9                	li	s11,10
  while(n > 0){
    80005d42:	07405b63          	blez	s4,80005db8 <consoleread+0xc6>
    while(cons.r == cons.w){
    80005d46:	0984a783          	lw	a5,152(s1)
    80005d4a:	09c4a703          	lw	a4,156(s1)
    80005d4e:	02f71763          	bne	a4,a5,80005d7c <consoleread+0x8a>
      if(killed(myproc())){
    80005d52:	ffffb097          	auipc	ra,0xffffb
    80005d56:	110080e7          	jalr	272(ra) # 80000e62 <myproc>
    80005d5a:	ffffc097          	auipc	ra,0xffffc
    80005d5e:	a94080e7          	jalr	-1388(ra) # 800017ee <killed>
    80005d62:	e535                	bnez	a0,80005dce <consoleread+0xdc>
      sleep(&cons.r, &cons.lock);
    80005d64:	85ce                	mv	a1,s3
    80005d66:	854a                	mv	a0,s2
    80005d68:	ffffb097          	auipc	ra,0xffffb
    80005d6c:	7de080e7          	jalr	2014(ra) # 80001546 <sleep>
    while(cons.r == cons.w){
    80005d70:	0984a783          	lw	a5,152(s1)
    80005d74:	09c4a703          	lw	a4,156(s1)
    80005d78:	fcf70de3          	beq	a4,a5,80005d52 <consoleread+0x60>
    c = cons.buf[cons.r++ % INPUT_BUF_SIZE];
    80005d7c:	0017871b          	addiw	a4,a5,1
    80005d80:	08e4ac23          	sw	a4,152(s1)
    80005d84:	07f7f713          	andi	a4,a5,127
    80005d88:	9726                	add	a4,a4,s1
    80005d8a:	01874703          	lbu	a4,24(a4)
    80005d8e:	00070c1b          	sext.w	s8,a4
    if(c == C('D')){  // end-of-file
    80005d92:	079c0663          	beq	s8,s9,80005dfe <consoleread+0x10c>
    cbuf = c;
    80005d96:	f8e407a3          	sb	a4,-113(s0)
    if(either_copyout(user_dst, dst, &cbuf, 1) == -1)
    80005d9a:	4685                	li	a3,1
    80005d9c:	f8f40613          	addi	a2,s0,-113
    80005da0:	85d6                	mv	a1,s5
    80005da2:	855a                	mv	a0,s6
    80005da4:	ffffc097          	auipc	ra,0xffffc
    80005da8:	baa080e7          	jalr	-1110(ra) # 8000194e <either_copyout>
    80005dac:	01a50663          	beq	a0,s10,80005db8 <consoleread+0xc6>
    dst++;
    80005db0:	0a85                	addi	s5,s5,1
    --n;
    80005db2:	3a7d                	addiw	s4,s4,-1
    if(c == '\n'){
    80005db4:	f9bc17e3          	bne	s8,s11,80005d42 <consoleread+0x50>
      // a whole line has arrived, return to
      // the user-level read().
      break;
    }
  }
  release(&cons.lock);
    80005db8:	0002e517          	auipc	a0,0x2e
    80005dbc:	13850513          	addi	a0,a0,312 # 80033ef0 <cons>
    80005dc0:	00001097          	auipc	ra,0x1
    80005dc4:	910080e7          	jalr	-1776(ra) # 800066d0 <release>

  return target - n;
    80005dc8:	414b853b          	subw	a0,s7,s4
    80005dcc:	a811                	j	80005de0 <consoleread+0xee>
        release(&cons.lock);
    80005dce:	0002e517          	auipc	a0,0x2e
    80005dd2:	12250513          	addi	a0,a0,290 # 80033ef0 <cons>
    80005dd6:	00001097          	auipc	ra,0x1
    80005dda:	8fa080e7          	jalr	-1798(ra) # 800066d0 <release>
        return -1;
    80005dde:	557d                	li	a0,-1
}
    80005de0:	70e6                	ld	ra,120(sp)
    80005de2:	7446                	ld	s0,112(sp)
    80005de4:	74a6                	ld	s1,104(sp)
    80005de6:	7906                	ld	s2,96(sp)
    80005de8:	69e6                	ld	s3,88(sp)
    80005dea:	6a46                	ld	s4,80(sp)
    80005dec:	6aa6                	ld	s5,72(sp)
    80005dee:	6b06                	ld	s6,64(sp)
    80005df0:	7be2                	ld	s7,56(sp)
    80005df2:	7c42                	ld	s8,48(sp)
    80005df4:	7ca2                	ld	s9,40(sp)
    80005df6:	7d02                	ld	s10,32(sp)
    80005df8:	6de2                	ld	s11,24(sp)
    80005dfa:	6109                	addi	sp,sp,128
    80005dfc:	8082                	ret
      if(n < target){
    80005dfe:	000a071b          	sext.w	a4,s4
    80005e02:	fb777be3          	bgeu	a4,s7,80005db8 <consoleread+0xc6>
        cons.r--;
    80005e06:	0002e717          	auipc	a4,0x2e
    80005e0a:	18f72123          	sw	a5,386(a4) # 80033f88 <cons+0x98>
    80005e0e:	b76d                	j	80005db8 <consoleread+0xc6>

0000000080005e10 <consputc>:
{
    80005e10:	1141                	addi	sp,sp,-16
    80005e12:	e406                	sd	ra,8(sp)
    80005e14:	e022                	sd	s0,0(sp)
    80005e16:	0800                	addi	s0,sp,16
  if(c == BACKSPACE){
    80005e18:	10000793          	li	a5,256
    80005e1c:	00f50a63          	beq	a0,a5,80005e30 <consputc+0x20>
    uartputc_sync(c);
    80005e20:	00000097          	auipc	ra,0x0
    80005e24:	564080e7          	jalr	1380(ra) # 80006384 <uartputc_sync>
}
    80005e28:	60a2                	ld	ra,8(sp)
    80005e2a:	6402                	ld	s0,0(sp)
    80005e2c:	0141                	addi	sp,sp,16
    80005e2e:	8082                	ret
    uartputc_sync('\b'); uartputc_sync(' '); uartputc_sync('\b');
    80005e30:	4521                	li	a0,8
    80005e32:	00000097          	auipc	ra,0x0
    80005e36:	552080e7          	jalr	1362(ra) # 80006384 <uartputc_sync>
    80005e3a:	02000513          	li	a0,32
    80005e3e:	00000097          	auipc	ra,0x0
    80005e42:	546080e7          	jalr	1350(ra) # 80006384 <uartputc_sync>
    80005e46:	4521                	li	a0,8
    80005e48:	00000097          	auipc	ra,0x0
    80005e4c:	53c080e7          	jalr	1340(ra) # 80006384 <uartputc_sync>
    80005e50:	bfe1                	j	80005e28 <consputc+0x18>

0000000080005e52 <consoleintr>:
// do erase/kill processing, append to cons.buf,
// wake up consoleread() if a whole line has arrived.
//
void
consoleintr(int c)
{
    80005e52:	1101                	addi	sp,sp,-32
    80005e54:	ec06                	sd	ra,24(sp)
    80005e56:	e822                	sd	s0,16(sp)
    80005e58:	e426                	sd	s1,8(sp)
    80005e5a:	e04a                	sd	s2,0(sp)
    80005e5c:	1000                	addi	s0,sp,32
    80005e5e:	84aa                	mv	s1,a0
  acquire(&cons.lock);
    80005e60:	0002e517          	auipc	a0,0x2e
    80005e64:	09050513          	addi	a0,a0,144 # 80033ef0 <cons>
    80005e68:	00000097          	auipc	ra,0x0
    80005e6c:	7b4080e7          	jalr	1972(ra) # 8000661c <acquire>

  switch(c){
    80005e70:	47d5                	li	a5,21
    80005e72:	0af48663          	beq	s1,a5,80005f1e <consoleintr+0xcc>
    80005e76:	0297ca63          	blt	a5,s1,80005eaa <consoleintr+0x58>
    80005e7a:	47a1                	li	a5,8
    80005e7c:	0ef48763          	beq	s1,a5,80005f6a <consoleintr+0x118>
    80005e80:	47c1                	li	a5,16
    80005e82:	10f49a63          	bne	s1,a5,80005f96 <consoleintr+0x144>
  case C('P'):  // Print process list.
    procdump();
    80005e86:	ffffc097          	auipc	ra,0xffffc
    80005e8a:	b74080e7          	jalr	-1164(ra) # 800019fa <procdump>
      }
    }
    break;
  }
  
  release(&cons.lock);
    80005e8e:	0002e517          	auipc	a0,0x2e
    80005e92:	06250513          	addi	a0,a0,98 # 80033ef0 <cons>
    80005e96:	00001097          	auipc	ra,0x1
    80005e9a:	83a080e7          	jalr	-1990(ra) # 800066d0 <release>
}
    80005e9e:	60e2                	ld	ra,24(sp)
    80005ea0:	6442                	ld	s0,16(sp)
    80005ea2:	64a2                	ld	s1,8(sp)
    80005ea4:	6902                	ld	s2,0(sp)
    80005ea6:	6105                	addi	sp,sp,32
    80005ea8:	8082                	ret
  switch(c){
    80005eaa:	07f00793          	li	a5,127
    80005eae:	0af48e63          	beq	s1,a5,80005f6a <consoleintr+0x118>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005eb2:	0002e717          	auipc	a4,0x2e
    80005eb6:	03e70713          	addi	a4,a4,62 # 80033ef0 <cons>
    80005eba:	0a072783          	lw	a5,160(a4)
    80005ebe:	09872703          	lw	a4,152(a4)
    80005ec2:	9f99                	subw	a5,a5,a4
    80005ec4:	07f00713          	li	a4,127
    80005ec8:	fcf763e3          	bltu	a4,a5,80005e8e <consoleintr+0x3c>
      c = (c == '\r') ? '\n' : c;
    80005ecc:	47b5                	li	a5,13
    80005ece:	0cf48763          	beq	s1,a5,80005f9c <consoleintr+0x14a>
      consputc(c);
    80005ed2:	8526                	mv	a0,s1
    80005ed4:	00000097          	auipc	ra,0x0
    80005ed8:	f3c080e7          	jalr	-196(ra) # 80005e10 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005edc:	0002e797          	auipc	a5,0x2e
    80005ee0:	01478793          	addi	a5,a5,20 # 80033ef0 <cons>
    80005ee4:	0a07a683          	lw	a3,160(a5)
    80005ee8:	0016871b          	addiw	a4,a3,1
    80005eec:	0007061b          	sext.w	a2,a4
    80005ef0:	0ae7a023          	sw	a4,160(a5)
    80005ef4:	07f6f693          	andi	a3,a3,127
    80005ef8:	97b6                	add	a5,a5,a3
    80005efa:	00978c23          	sb	s1,24(a5)
      if(c == '\n' || c == C('D') || cons.e-cons.r == INPUT_BUF_SIZE){
    80005efe:	47a9                	li	a5,10
    80005f00:	0cf48563          	beq	s1,a5,80005fca <consoleintr+0x178>
    80005f04:	4791                	li	a5,4
    80005f06:	0cf48263          	beq	s1,a5,80005fca <consoleintr+0x178>
    80005f0a:	0002e797          	auipc	a5,0x2e
    80005f0e:	07e7a783          	lw	a5,126(a5) # 80033f88 <cons+0x98>
    80005f12:	9f1d                	subw	a4,a4,a5
    80005f14:	08000793          	li	a5,128
    80005f18:	f6f71be3          	bne	a4,a5,80005e8e <consoleintr+0x3c>
    80005f1c:	a07d                	j	80005fca <consoleintr+0x178>
    while(cons.e != cons.w &&
    80005f1e:	0002e717          	auipc	a4,0x2e
    80005f22:	fd270713          	addi	a4,a4,-46 # 80033ef0 <cons>
    80005f26:	0a072783          	lw	a5,160(a4)
    80005f2a:	09c72703          	lw	a4,156(a4)
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005f2e:	0002e497          	auipc	s1,0x2e
    80005f32:	fc248493          	addi	s1,s1,-62 # 80033ef0 <cons>
    while(cons.e != cons.w &&
    80005f36:	4929                	li	s2,10
    80005f38:	f4f70be3          	beq	a4,a5,80005e8e <consoleintr+0x3c>
          cons.buf[(cons.e-1) % INPUT_BUF_SIZE] != '\n'){
    80005f3c:	37fd                	addiw	a5,a5,-1
    80005f3e:	07f7f713          	andi	a4,a5,127
    80005f42:	9726                	add	a4,a4,s1
    while(cons.e != cons.w &&
    80005f44:	01874703          	lbu	a4,24(a4)
    80005f48:	f52703e3          	beq	a4,s2,80005e8e <consoleintr+0x3c>
      cons.e--;
    80005f4c:	0af4a023          	sw	a5,160(s1)
      consputc(BACKSPACE);
    80005f50:	10000513          	li	a0,256
    80005f54:	00000097          	auipc	ra,0x0
    80005f58:	ebc080e7          	jalr	-324(ra) # 80005e10 <consputc>
    while(cons.e != cons.w &&
    80005f5c:	0a04a783          	lw	a5,160(s1)
    80005f60:	09c4a703          	lw	a4,156(s1)
    80005f64:	fcf71ce3          	bne	a4,a5,80005f3c <consoleintr+0xea>
    80005f68:	b71d                	j	80005e8e <consoleintr+0x3c>
    if(cons.e != cons.w){
    80005f6a:	0002e717          	auipc	a4,0x2e
    80005f6e:	f8670713          	addi	a4,a4,-122 # 80033ef0 <cons>
    80005f72:	0a072783          	lw	a5,160(a4)
    80005f76:	09c72703          	lw	a4,156(a4)
    80005f7a:	f0f70ae3          	beq	a4,a5,80005e8e <consoleintr+0x3c>
      cons.e--;
    80005f7e:	37fd                	addiw	a5,a5,-1
    80005f80:	0002e717          	auipc	a4,0x2e
    80005f84:	00f72823          	sw	a5,16(a4) # 80033f90 <cons+0xa0>
      consputc(BACKSPACE);
    80005f88:	10000513          	li	a0,256
    80005f8c:	00000097          	auipc	ra,0x0
    80005f90:	e84080e7          	jalr	-380(ra) # 80005e10 <consputc>
    80005f94:	bded                	j	80005e8e <consoleintr+0x3c>
    if(c != 0 && cons.e-cons.r < INPUT_BUF_SIZE){
    80005f96:	ee048ce3          	beqz	s1,80005e8e <consoleintr+0x3c>
    80005f9a:	bf21                	j	80005eb2 <consoleintr+0x60>
      consputc(c);
    80005f9c:	4529                	li	a0,10
    80005f9e:	00000097          	auipc	ra,0x0
    80005fa2:	e72080e7          	jalr	-398(ra) # 80005e10 <consputc>
      cons.buf[cons.e++ % INPUT_BUF_SIZE] = c;
    80005fa6:	0002e797          	auipc	a5,0x2e
    80005faa:	f4a78793          	addi	a5,a5,-182 # 80033ef0 <cons>
    80005fae:	0a07a703          	lw	a4,160(a5)
    80005fb2:	0017069b          	addiw	a3,a4,1
    80005fb6:	0006861b          	sext.w	a2,a3
    80005fba:	0ad7a023          	sw	a3,160(a5)
    80005fbe:	07f77713          	andi	a4,a4,127
    80005fc2:	97ba                	add	a5,a5,a4
    80005fc4:	4729                	li	a4,10
    80005fc6:	00e78c23          	sb	a4,24(a5)
        cons.w = cons.e;
    80005fca:	0002e797          	auipc	a5,0x2e
    80005fce:	fcc7a123          	sw	a2,-62(a5) # 80033f8c <cons+0x9c>
        wakeup(&cons.r);
    80005fd2:	0002e517          	auipc	a0,0x2e
    80005fd6:	fb650513          	addi	a0,a0,-74 # 80033f88 <cons+0x98>
    80005fda:	ffffb097          	auipc	ra,0xffffb
    80005fde:	5d0080e7          	jalr	1488(ra) # 800015aa <wakeup>
    80005fe2:	b575                	j	80005e8e <consoleintr+0x3c>

0000000080005fe4 <consoleinit>:

void
consoleinit(void)
{
    80005fe4:	1141                	addi	sp,sp,-16
    80005fe6:	e406                	sd	ra,8(sp)
    80005fe8:	e022                	sd	s0,0(sp)
    80005fea:	0800                	addi	s0,sp,16
  initlock(&cons.lock, "cons");
    80005fec:	00003597          	auipc	a1,0x3
    80005ff0:	a7458593          	addi	a1,a1,-1420 # 80008a60 <syscalls+0x5e8>
    80005ff4:	0002e517          	auipc	a0,0x2e
    80005ff8:	efc50513          	addi	a0,a0,-260 # 80033ef0 <cons>
    80005ffc:	00000097          	auipc	ra,0x0
    80006000:	590080e7          	jalr	1424(ra) # 8000658c <initlock>

  uartinit();
    80006004:	00000097          	auipc	ra,0x0
    80006008:	330080e7          	jalr	816(ra) # 80006334 <uartinit>

  // connect read and write system calls
  // to consoleread and consolewrite.
  devsw[CONSOLE].read = consoleread;
    8000600c:	00025797          	auipc	a5,0x25
    80006010:	c0c78793          	addi	a5,a5,-1012 # 8002ac18 <devsw>
    80006014:	00000717          	auipc	a4,0x0
    80006018:	cde70713          	addi	a4,a4,-802 # 80005cf2 <consoleread>
    8000601c:	eb98                	sd	a4,16(a5)
  devsw[CONSOLE].write = consolewrite;
    8000601e:	00000717          	auipc	a4,0x0
    80006022:	c7270713          	addi	a4,a4,-910 # 80005c90 <consolewrite>
    80006026:	ef98                	sd	a4,24(a5)
}
    80006028:	60a2                	ld	ra,8(sp)
    8000602a:	6402                	ld	s0,0(sp)
    8000602c:	0141                	addi	sp,sp,16
    8000602e:	8082                	ret

0000000080006030 <printint>:

static char digits[] = "0123456789abcdef";

static void
printint(int xx, int base, int sign)
{
    80006030:	7179                	addi	sp,sp,-48
    80006032:	f406                	sd	ra,40(sp)
    80006034:	f022                	sd	s0,32(sp)
    80006036:	ec26                	sd	s1,24(sp)
    80006038:	e84a                	sd	s2,16(sp)
    8000603a:	1800                	addi	s0,sp,48
  char buf[16];
  int i;
  uint x;

  if(sign && (sign = xx < 0))
    8000603c:	c219                	beqz	a2,80006042 <printint+0x12>
    8000603e:	08054663          	bltz	a0,800060ca <printint+0x9a>
    x = -xx;
  else
    x = xx;
    80006042:	2501                	sext.w	a0,a0
    80006044:	4881                	li	a7,0
    80006046:	fd040693          	addi	a3,s0,-48

  i = 0;
    8000604a:	4701                	li	a4,0
  do {
    buf[i++] = digits[x % base];
    8000604c:	2581                	sext.w	a1,a1
    8000604e:	00003617          	auipc	a2,0x3
    80006052:	a4260613          	addi	a2,a2,-1470 # 80008a90 <digits>
    80006056:	883a                	mv	a6,a4
    80006058:	2705                	addiw	a4,a4,1
    8000605a:	02b577bb          	remuw	a5,a0,a1
    8000605e:	1782                	slli	a5,a5,0x20
    80006060:	9381                	srli	a5,a5,0x20
    80006062:	97b2                	add	a5,a5,a2
    80006064:	0007c783          	lbu	a5,0(a5)
    80006068:	00f68023          	sb	a5,0(a3)
  } while((x /= base) != 0);
    8000606c:	0005079b          	sext.w	a5,a0
    80006070:	02b5553b          	divuw	a0,a0,a1
    80006074:	0685                	addi	a3,a3,1
    80006076:	feb7f0e3          	bgeu	a5,a1,80006056 <printint+0x26>

  if(sign)
    8000607a:	00088b63          	beqz	a7,80006090 <printint+0x60>
    buf[i++] = '-';
    8000607e:	fe040793          	addi	a5,s0,-32
    80006082:	973e                	add	a4,a4,a5
    80006084:	02d00793          	li	a5,45
    80006088:	fef70823          	sb	a5,-16(a4)
    8000608c:	0028071b          	addiw	a4,a6,2

  while(--i >= 0)
    80006090:	02e05763          	blez	a4,800060be <printint+0x8e>
    80006094:	fd040793          	addi	a5,s0,-48
    80006098:	00e784b3          	add	s1,a5,a4
    8000609c:	fff78913          	addi	s2,a5,-1
    800060a0:	993a                	add	s2,s2,a4
    800060a2:	377d                	addiw	a4,a4,-1
    800060a4:	1702                	slli	a4,a4,0x20
    800060a6:	9301                	srli	a4,a4,0x20
    800060a8:	40e90933          	sub	s2,s2,a4
    consputc(buf[i]);
    800060ac:	fff4c503          	lbu	a0,-1(s1)
    800060b0:	00000097          	auipc	ra,0x0
    800060b4:	d60080e7          	jalr	-672(ra) # 80005e10 <consputc>
  while(--i >= 0)
    800060b8:	14fd                	addi	s1,s1,-1
    800060ba:	ff2499e3          	bne	s1,s2,800060ac <printint+0x7c>
}
    800060be:	70a2                	ld	ra,40(sp)
    800060c0:	7402                	ld	s0,32(sp)
    800060c2:	64e2                	ld	s1,24(sp)
    800060c4:	6942                	ld	s2,16(sp)
    800060c6:	6145                	addi	sp,sp,48
    800060c8:	8082                	ret
    x = -xx;
    800060ca:	40a0053b          	negw	a0,a0
  if(sign && (sign = xx < 0))
    800060ce:	4885                	li	a7,1
    x = -xx;
    800060d0:	bf9d                	j	80006046 <printint+0x16>

00000000800060d2 <panic>:
    release(&pr.lock);
}

void
panic(char *s)
{
    800060d2:	1101                	addi	sp,sp,-32
    800060d4:	ec06                	sd	ra,24(sp)
    800060d6:	e822                	sd	s0,16(sp)
    800060d8:	e426                	sd	s1,8(sp)
    800060da:	1000                	addi	s0,sp,32
    800060dc:	84aa                	mv	s1,a0
  pr.locking = 0;
    800060de:	0002e797          	auipc	a5,0x2e
    800060e2:	ec07a923          	sw	zero,-302(a5) # 80033fb0 <pr+0x18>
  printf("panic: ");
    800060e6:	00003517          	auipc	a0,0x3
    800060ea:	98250513          	addi	a0,a0,-1662 # 80008a68 <syscalls+0x5f0>
    800060ee:	00000097          	auipc	ra,0x0
    800060f2:	02e080e7          	jalr	46(ra) # 8000611c <printf>
  printf(s);
    800060f6:	8526                	mv	a0,s1
    800060f8:	00000097          	auipc	ra,0x0
    800060fc:	024080e7          	jalr	36(ra) # 8000611c <printf>
  printf("\n");
    80006100:	00002517          	auipc	a0,0x2
    80006104:	f4850513          	addi	a0,a0,-184 # 80008048 <etext+0x48>
    80006108:	00000097          	auipc	ra,0x0
    8000610c:	014080e7          	jalr	20(ra) # 8000611c <printf>
  panicked = 1; // freeze uart output from other CPUs
    80006110:	4785                	li	a5,1
    80006112:	00003717          	auipc	a4,0x3
    80006116:	a4f72d23          	sw	a5,-1446(a4) # 80008b6c <panicked>
  for(;;)
    8000611a:	a001                	j	8000611a <panic+0x48>

000000008000611c <printf>:
{
    8000611c:	7131                	addi	sp,sp,-192
    8000611e:	fc86                	sd	ra,120(sp)
    80006120:	f8a2                	sd	s0,112(sp)
    80006122:	f4a6                	sd	s1,104(sp)
    80006124:	f0ca                	sd	s2,96(sp)
    80006126:	ecce                	sd	s3,88(sp)
    80006128:	e8d2                	sd	s4,80(sp)
    8000612a:	e4d6                	sd	s5,72(sp)
    8000612c:	e0da                	sd	s6,64(sp)
    8000612e:	fc5e                	sd	s7,56(sp)
    80006130:	f862                	sd	s8,48(sp)
    80006132:	f466                	sd	s9,40(sp)
    80006134:	f06a                	sd	s10,32(sp)
    80006136:	ec6e                	sd	s11,24(sp)
    80006138:	0100                	addi	s0,sp,128
    8000613a:	8a2a                	mv	s4,a0
    8000613c:	e40c                	sd	a1,8(s0)
    8000613e:	e810                	sd	a2,16(s0)
    80006140:	ec14                	sd	a3,24(s0)
    80006142:	f018                	sd	a4,32(s0)
    80006144:	f41c                	sd	a5,40(s0)
    80006146:	03043823          	sd	a6,48(s0)
    8000614a:	03143c23          	sd	a7,56(s0)
  locking = pr.locking;
    8000614e:	0002ed97          	auipc	s11,0x2e
    80006152:	e62dad83          	lw	s11,-414(s11) # 80033fb0 <pr+0x18>
  if(locking)
    80006156:	020d9b63          	bnez	s11,8000618c <printf+0x70>
  if (fmt == 0)
    8000615a:	040a0263          	beqz	s4,8000619e <printf+0x82>
  va_start(ap, fmt);
    8000615e:	00840793          	addi	a5,s0,8
    80006162:	f8f43423          	sd	a5,-120(s0)
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    80006166:	000a4503          	lbu	a0,0(s4)
    8000616a:	16050263          	beqz	a0,800062ce <printf+0x1b2>
    8000616e:	4481                	li	s1,0
    if(c != '%'){
    80006170:	02500a93          	li	s5,37
    switch(c){
    80006174:	07000b13          	li	s6,112
  consputc('x');
    80006178:	4d41                	li	s10,16
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    8000617a:	00003b97          	auipc	s7,0x3
    8000617e:	916b8b93          	addi	s7,s7,-1770 # 80008a90 <digits>
    switch(c){
    80006182:	07300c93          	li	s9,115
    80006186:	06400c13          	li	s8,100
    8000618a:	a82d                	j	800061c4 <printf+0xa8>
    acquire(&pr.lock);
    8000618c:	0002e517          	auipc	a0,0x2e
    80006190:	e0c50513          	addi	a0,a0,-500 # 80033f98 <pr>
    80006194:	00000097          	auipc	ra,0x0
    80006198:	488080e7          	jalr	1160(ra) # 8000661c <acquire>
    8000619c:	bf7d                	j	8000615a <printf+0x3e>
    panic("null fmt");
    8000619e:	00003517          	auipc	a0,0x3
    800061a2:	8da50513          	addi	a0,a0,-1830 # 80008a78 <syscalls+0x600>
    800061a6:	00000097          	auipc	ra,0x0
    800061aa:	f2c080e7          	jalr	-212(ra) # 800060d2 <panic>
      consputc(c);
    800061ae:	00000097          	auipc	ra,0x0
    800061b2:	c62080e7          	jalr	-926(ra) # 80005e10 <consputc>
  for(i = 0; (c = fmt[i] & 0xff) != 0; i++){
    800061b6:	2485                	addiw	s1,s1,1
    800061b8:	009a07b3          	add	a5,s4,s1
    800061bc:	0007c503          	lbu	a0,0(a5)
    800061c0:	10050763          	beqz	a0,800062ce <printf+0x1b2>
    if(c != '%'){
    800061c4:	ff5515e3          	bne	a0,s5,800061ae <printf+0x92>
    c = fmt[++i] & 0xff;
    800061c8:	2485                	addiw	s1,s1,1
    800061ca:	009a07b3          	add	a5,s4,s1
    800061ce:	0007c783          	lbu	a5,0(a5)
    800061d2:	0007891b          	sext.w	s2,a5
    if(c == 0)
    800061d6:	cfe5                	beqz	a5,800062ce <printf+0x1b2>
    switch(c){
    800061d8:	05678a63          	beq	a5,s6,8000622c <printf+0x110>
    800061dc:	02fb7663          	bgeu	s6,a5,80006208 <printf+0xec>
    800061e0:	09978963          	beq	a5,s9,80006272 <printf+0x156>
    800061e4:	07800713          	li	a4,120
    800061e8:	0ce79863          	bne	a5,a4,800062b8 <printf+0x19c>
      printint(va_arg(ap, int), 16, 1);
    800061ec:	f8843783          	ld	a5,-120(s0)
    800061f0:	00878713          	addi	a4,a5,8
    800061f4:	f8e43423          	sd	a4,-120(s0)
    800061f8:	4605                	li	a2,1
    800061fa:	85ea                	mv	a1,s10
    800061fc:	4388                	lw	a0,0(a5)
    800061fe:	00000097          	auipc	ra,0x0
    80006202:	e32080e7          	jalr	-462(ra) # 80006030 <printint>
      break;
    80006206:	bf45                	j	800061b6 <printf+0x9a>
    switch(c){
    80006208:	0b578263          	beq	a5,s5,800062ac <printf+0x190>
    8000620c:	0b879663          	bne	a5,s8,800062b8 <printf+0x19c>
      printint(va_arg(ap, int), 10, 1);
    80006210:	f8843783          	ld	a5,-120(s0)
    80006214:	00878713          	addi	a4,a5,8
    80006218:	f8e43423          	sd	a4,-120(s0)
    8000621c:	4605                	li	a2,1
    8000621e:	45a9                	li	a1,10
    80006220:	4388                	lw	a0,0(a5)
    80006222:	00000097          	auipc	ra,0x0
    80006226:	e0e080e7          	jalr	-498(ra) # 80006030 <printint>
      break;
    8000622a:	b771                	j	800061b6 <printf+0x9a>
      printptr(va_arg(ap, uint64));
    8000622c:	f8843783          	ld	a5,-120(s0)
    80006230:	00878713          	addi	a4,a5,8
    80006234:	f8e43423          	sd	a4,-120(s0)
    80006238:	0007b983          	ld	s3,0(a5)
  consputc('0');
    8000623c:	03000513          	li	a0,48
    80006240:	00000097          	auipc	ra,0x0
    80006244:	bd0080e7          	jalr	-1072(ra) # 80005e10 <consputc>
  consputc('x');
    80006248:	07800513          	li	a0,120
    8000624c:	00000097          	auipc	ra,0x0
    80006250:	bc4080e7          	jalr	-1084(ra) # 80005e10 <consputc>
    80006254:	896a                	mv	s2,s10
    consputc(digits[x >> (sizeof(uint64) * 8 - 4)]);
    80006256:	03c9d793          	srli	a5,s3,0x3c
    8000625a:	97de                	add	a5,a5,s7
    8000625c:	0007c503          	lbu	a0,0(a5)
    80006260:	00000097          	auipc	ra,0x0
    80006264:	bb0080e7          	jalr	-1104(ra) # 80005e10 <consputc>
  for (i = 0; i < (sizeof(uint64) * 2); i++, x <<= 4)
    80006268:	0992                	slli	s3,s3,0x4
    8000626a:	397d                	addiw	s2,s2,-1
    8000626c:	fe0915e3          	bnez	s2,80006256 <printf+0x13a>
    80006270:	b799                	j	800061b6 <printf+0x9a>
      if((s = va_arg(ap, char*)) == 0)
    80006272:	f8843783          	ld	a5,-120(s0)
    80006276:	00878713          	addi	a4,a5,8
    8000627a:	f8e43423          	sd	a4,-120(s0)
    8000627e:	0007b903          	ld	s2,0(a5)
    80006282:	00090e63          	beqz	s2,8000629e <printf+0x182>
      for(; *s; s++)
    80006286:	00094503          	lbu	a0,0(s2)
    8000628a:	d515                	beqz	a0,800061b6 <printf+0x9a>
        consputc(*s);
    8000628c:	00000097          	auipc	ra,0x0
    80006290:	b84080e7          	jalr	-1148(ra) # 80005e10 <consputc>
      for(; *s; s++)
    80006294:	0905                	addi	s2,s2,1
    80006296:	00094503          	lbu	a0,0(s2)
    8000629a:	f96d                	bnez	a0,8000628c <printf+0x170>
    8000629c:	bf29                	j	800061b6 <printf+0x9a>
        s = "(null)";
    8000629e:	00002917          	auipc	s2,0x2
    800062a2:	7d290913          	addi	s2,s2,2002 # 80008a70 <syscalls+0x5f8>
      for(; *s; s++)
    800062a6:	02800513          	li	a0,40
    800062aa:	b7cd                	j	8000628c <printf+0x170>
      consputc('%');
    800062ac:	8556                	mv	a0,s5
    800062ae:	00000097          	auipc	ra,0x0
    800062b2:	b62080e7          	jalr	-1182(ra) # 80005e10 <consputc>
      break;
    800062b6:	b701                	j	800061b6 <printf+0x9a>
      consputc('%');
    800062b8:	8556                	mv	a0,s5
    800062ba:	00000097          	auipc	ra,0x0
    800062be:	b56080e7          	jalr	-1194(ra) # 80005e10 <consputc>
      consputc(c);
    800062c2:	854a                	mv	a0,s2
    800062c4:	00000097          	auipc	ra,0x0
    800062c8:	b4c080e7          	jalr	-1204(ra) # 80005e10 <consputc>
      break;
    800062cc:	b5ed                	j	800061b6 <printf+0x9a>
  if(locking)
    800062ce:	020d9163          	bnez	s11,800062f0 <printf+0x1d4>
}
    800062d2:	70e6                	ld	ra,120(sp)
    800062d4:	7446                	ld	s0,112(sp)
    800062d6:	74a6                	ld	s1,104(sp)
    800062d8:	7906                	ld	s2,96(sp)
    800062da:	69e6                	ld	s3,88(sp)
    800062dc:	6a46                	ld	s4,80(sp)
    800062de:	6aa6                	ld	s5,72(sp)
    800062e0:	6b06                	ld	s6,64(sp)
    800062e2:	7be2                	ld	s7,56(sp)
    800062e4:	7c42                	ld	s8,48(sp)
    800062e6:	7ca2                	ld	s9,40(sp)
    800062e8:	7d02                	ld	s10,32(sp)
    800062ea:	6de2                	ld	s11,24(sp)
    800062ec:	6129                	addi	sp,sp,192
    800062ee:	8082                	ret
    release(&pr.lock);
    800062f0:	0002e517          	auipc	a0,0x2e
    800062f4:	ca850513          	addi	a0,a0,-856 # 80033f98 <pr>
    800062f8:	00000097          	auipc	ra,0x0
    800062fc:	3d8080e7          	jalr	984(ra) # 800066d0 <release>
}
    80006300:	bfc9                	j	800062d2 <printf+0x1b6>

0000000080006302 <printfinit>:
    ;
}

void
printfinit(void)
{
    80006302:	1101                	addi	sp,sp,-32
    80006304:	ec06                	sd	ra,24(sp)
    80006306:	e822                	sd	s0,16(sp)
    80006308:	e426                	sd	s1,8(sp)
    8000630a:	1000                	addi	s0,sp,32
  initlock(&pr.lock, "pr");
    8000630c:	0002e497          	auipc	s1,0x2e
    80006310:	c8c48493          	addi	s1,s1,-884 # 80033f98 <pr>
    80006314:	00002597          	auipc	a1,0x2
    80006318:	77458593          	addi	a1,a1,1908 # 80008a88 <syscalls+0x610>
    8000631c:	8526                	mv	a0,s1
    8000631e:	00000097          	auipc	ra,0x0
    80006322:	26e080e7          	jalr	622(ra) # 8000658c <initlock>
  pr.locking = 1;
    80006326:	4785                	li	a5,1
    80006328:	cc9c                	sw	a5,24(s1)
}
    8000632a:	60e2                	ld	ra,24(sp)
    8000632c:	6442                	ld	s0,16(sp)
    8000632e:	64a2                	ld	s1,8(sp)
    80006330:	6105                	addi	sp,sp,32
    80006332:	8082                	ret

0000000080006334 <uartinit>:

void uartstart();

void
uartinit(void)
{
    80006334:	1141                	addi	sp,sp,-16
    80006336:	e406                	sd	ra,8(sp)
    80006338:	e022                	sd	s0,0(sp)
    8000633a:	0800                	addi	s0,sp,16
  // disable interrupts.
  WriteReg(IER, 0x00);
    8000633c:	100007b7          	lui	a5,0x10000
    80006340:	000780a3          	sb	zero,1(a5) # 10000001 <_entry-0x6fffffff>

  // special mode to set baud rate.
  WriteReg(LCR, LCR_BAUD_LATCH);
    80006344:	f8000713          	li	a4,-128
    80006348:	00e781a3          	sb	a4,3(a5)

  // LSB for baud rate of 38.4K.
  WriteReg(0, 0x03);
    8000634c:	470d                	li	a4,3
    8000634e:	00e78023          	sb	a4,0(a5)

  // MSB for baud rate of 38.4K.
  WriteReg(1, 0x00);
    80006352:	000780a3          	sb	zero,1(a5)

  // leave set-baud mode,
  // and set word length to 8 bits, no parity.
  WriteReg(LCR, LCR_EIGHT_BITS);
    80006356:	00e781a3          	sb	a4,3(a5)

  // reset and enable FIFOs.
  WriteReg(FCR, FCR_FIFO_ENABLE | FCR_FIFO_CLEAR);
    8000635a:	469d                	li	a3,7
    8000635c:	00d78123          	sb	a3,2(a5)

  // enable transmit and receive interrupts.
  WriteReg(IER, IER_TX_ENABLE | IER_RX_ENABLE);
    80006360:	00e780a3          	sb	a4,1(a5)

  initlock(&uart_tx_lock, "uart");
    80006364:	00002597          	auipc	a1,0x2
    80006368:	74458593          	addi	a1,a1,1860 # 80008aa8 <digits+0x18>
    8000636c:	0002e517          	auipc	a0,0x2e
    80006370:	c4c50513          	addi	a0,a0,-948 # 80033fb8 <uart_tx_lock>
    80006374:	00000097          	auipc	ra,0x0
    80006378:	218080e7          	jalr	536(ra) # 8000658c <initlock>
}
    8000637c:	60a2                	ld	ra,8(sp)
    8000637e:	6402                	ld	s0,0(sp)
    80006380:	0141                	addi	sp,sp,16
    80006382:	8082                	ret

0000000080006384 <uartputc_sync>:
// use interrupts, for use by kernel printf() and
// to echo characters. it spins waiting for the uart's
// output register to be empty.
void
uartputc_sync(int c)
{
    80006384:	1101                	addi	sp,sp,-32
    80006386:	ec06                	sd	ra,24(sp)
    80006388:	e822                	sd	s0,16(sp)
    8000638a:	e426                	sd	s1,8(sp)
    8000638c:	1000                	addi	s0,sp,32
    8000638e:	84aa                	mv	s1,a0
  push_off();
    80006390:	00000097          	auipc	ra,0x0
    80006394:	240080e7          	jalr	576(ra) # 800065d0 <push_off>

  if(panicked){
    80006398:	00002797          	auipc	a5,0x2
    8000639c:	7d47a783          	lw	a5,2004(a5) # 80008b6c <panicked>
    for(;;)
      ;
  }

  // wait for Transmit Holding Empty to be set in LSR.
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800063a0:	10000737          	lui	a4,0x10000
  if(panicked){
    800063a4:	c391                	beqz	a5,800063a8 <uartputc_sync+0x24>
    for(;;)
    800063a6:	a001                	j	800063a6 <uartputc_sync+0x22>
  while((ReadReg(LSR) & LSR_TX_IDLE) == 0)
    800063a8:	00574783          	lbu	a5,5(a4) # 10000005 <_entry-0x6ffffffb>
    800063ac:	0ff7f793          	andi	a5,a5,255
    800063b0:	0207f793          	andi	a5,a5,32
    800063b4:	dbf5                	beqz	a5,800063a8 <uartputc_sync+0x24>
    ;
  WriteReg(THR, c);
    800063b6:	0ff4f793          	andi	a5,s1,255
    800063ba:	10000737          	lui	a4,0x10000
    800063be:	00f70023          	sb	a5,0(a4) # 10000000 <_entry-0x70000000>

  pop_off();
    800063c2:	00000097          	auipc	ra,0x0
    800063c6:	2ae080e7          	jalr	686(ra) # 80006670 <pop_off>
}
    800063ca:	60e2                	ld	ra,24(sp)
    800063cc:	6442                	ld	s0,16(sp)
    800063ce:	64a2                	ld	s1,8(sp)
    800063d0:	6105                	addi	sp,sp,32
    800063d2:	8082                	ret

00000000800063d4 <uartstart>:
// called from both the top- and bottom-half.
void
uartstart()
{
  while(1){
    if(uart_tx_w == uart_tx_r){
    800063d4:	00002717          	auipc	a4,0x2
    800063d8:	79c73703          	ld	a4,1948(a4) # 80008b70 <uart_tx_r>
    800063dc:	00002797          	auipc	a5,0x2
    800063e0:	79c7b783          	ld	a5,1948(a5) # 80008b78 <uart_tx_w>
    800063e4:	06e78c63          	beq	a5,a4,8000645c <uartstart+0x88>
{
    800063e8:	7139                	addi	sp,sp,-64
    800063ea:	fc06                	sd	ra,56(sp)
    800063ec:	f822                	sd	s0,48(sp)
    800063ee:	f426                	sd	s1,40(sp)
    800063f0:	f04a                	sd	s2,32(sp)
    800063f2:	ec4e                	sd	s3,24(sp)
    800063f4:	e852                	sd	s4,16(sp)
    800063f6:	e456                	sd	s5,8(sp)
    800063f8:	0080                	addi	s0,sp,64
      // transmit buffer is empty.
      return;
    }
    
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    800063fa:	10000937          	lui	s2,0x10000
      // so we cannot give it another byte.
      // it will interrupt when it's ready for a new byte.
      return;
    }
    
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    800063fe:	0002ea17          	auipc	s4,0x2e
    80006402:	bbaa0a13          	addi	s4,s4,-1094 # 80033fb8 <uart_tx_lock>
    uart_tx_r += 1;
    80006406:	00002497          	auipc	s1,0x2
    8000640a:	76a48493          	addi	s1,s1,1898 # 80008b70 <uart_tx_r>
    if(uart_tx_w == uart_tx_r){
    8000640e:	00002997          	auipc	s3,0x2
    80006412:	76a98993          	addi	s3,s3,1898 # 80008b78 <uart_tx_w>
    if((ReadReg(LSR) & LSR_TX_IDLE) == 0){
    80006416:	00594783          	lbu	a5,5(s2) # 10000005 <_entry-0x6ffffffb>
    8000641a:	0ff7f793          	andi	a5,a5,255
    8000641e:	0207f793          	andi	a5,a5,32
    80006422:	c785                	beqz	a5,8000644a <uartstart+0x76>
    int c = uart_tx_buf[uart_tx_r % UART_TX_BUF_SIZE];
    80006424:	01f77793          	andi	a5,a4,31
    80006428:	97d2                	add	a5,a5,s4
    8000642a:	0187ca83          	lbu	s5,24(a5)
    uart_tx_r += 1;
    8000642e:	0705                	addi	a4,a4,1
    80006430:	e098                	sd	a4,0(s1)
    
    // maybe uartputc() is waiting for space in the buffer.
    wakeup(&uart_tx_r);
    80006432:	8526                	mv	a0,s1
    80006434:	ffffb097          	auipc	ra,0xffffb
    80006438:	176080e7          	jalr	374(ra) # 800015aa <wakeup>
    
    WriteReg(THR, c);
    8000643c:	01590023          	sb	s5,0(s2)
    if(uart_tx_w == uart_tx_r){
    80006440:	6098                	ld	a4,0(s1)
    80006442:	0009b783          	ld	a5,0(s3)
    80006446:	fce798e3          	bne	a5,a4,80006416 <uartstart+0x42>
  }
}
    8000644a:	70e2                	ld	ra,56(sp)
    8000644c:	7442                	ld	s0,48(sp)
    8000644e:	74a2                	ld	s1,40(sp)
    80006450:	7902                	ld	s2,32(sp)
    80006452:	69e2                	ld	s3,24(sp)
    80006454:	6a42                	ld	s4,16(sp)
    80006456:	6aa2                	ld	s5,8(sp)
    80006458:	6121                	addi	sp,sp,64
    8000645a:	8082                	ret
    8000645c:	8082                	ret

000000008000645e <uartputc>:
{
    8000645e:	7179                	addi	sp,sp,-48
    80006460:	f406                	sd	ra,40(sp)
    80006462:	f022                	sd	s0,32(sp)
    80006464:	ec26                	sd	s1,24(sp)
    80006466:	e84a                	sd	s2,16(sp)
    80006468:	e44e                	sd	s3,8(sp)
    8000646a:	e052                	sd	s4,0(sp)
    8000646c:	1800                	addi	s0,sp,48
    8000646e:	89aa                	mv	s3,a0
  acquire(&uart_tx_lock);
    80006470:	0002e517          	auipc	a0,0x2e
    80006474:	b4850513          	addi	a0,a0,-1208 # 80033fb8 <uart_tx_lock>
    80006478:	00000097          	auipc	ra,0x0
    8000647c:	1a4080e7          	jalr	420(ra) # 8000661c <acquire>
  if(panicked){
    80006480:	00002797          	auipc	a5,0x2
    80006484:	6ec7a783          	lw	a5,1772(a5) # 80008b6c <panicked>
    80006488:	e7c9                	bnez	a5,80006512 <uartputc+0xb4>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    8000648a:	00002797          	auipc	a5,0x2
    8000648e:	6ee7b783          	ld	a5,1774(a5) # 80008b78 <uart_tx_w>
    80006492:	00002717          	auipc	a4,0x2
    80006496:	6de73703          	ld	a4,1758(a4) # 80008b70 <uart_tx_r>
    8000649a:	02070713          	addi	a4,a4,32
    sleep(&uart_tx_r, &uart_tx_lock);
    8000649e:	0002ea17          	auipc	s4,0x2e
    800064a2:	b1aa0a13          	addi	s4,s4,-1254 # 80033fb8 <uart_tx_lock>
    800064a6:	00002497          	auipc	s1,0x2
    800064aa:	6ca48493          	addi	s1,s1,1738 # 80008b70 <uart_tx_r>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800064ae:	00002917          	auipc	s2,0x2
    800064b2:	6ca90913          	addi	s2,s2,1738 # 80008b78 <uart_tx_w>
    800064b6:	00f71f63          	bne	a4,a5,800064d4 <uartputc+0x76>
    sleep(&uart_tx_r, &uart_tx_lock);
    800064ba:	85d2                	mv	a1,s4
    800064bc:	8526                	mv	a0,s1
    800064be:	ffffb097          	auipc	ra,0xffffb
    800064c2:	088080e7          	jalr	136(ra) # 80001546 <sleep>
  while(uart_tx_w == uart_tx_r + UART_TX_BUF_SIZE){
    800064c6:	00093783          	ld	a5,0(s2)
    800064ca:	6098                	ld	a4,0(s1)
    800064cc:	02070713          	addi	a4,a4,32
    800064d0:	fef705e3          	beq	a4,a5,800064ba <uartputc+0x5c>
  uart_tx_buf[uart_tx_w % UART_TX_BUF_SIZE] = c;
    800064d4:	0002e497          	auipc	s1,0x2e
    800064d8:	ae448493          	addi	s1,s1,-1308 # 80033fb8 <uart_tx_lock>
    800064dc:	01f7f713          	andi	a4,a5,31
    800064e0:	9726                	add	a4,a4,s1
    800064e2:	01370c23          	sb	s3,24(a4)
  uart_tx_w += 1;
    800064e6:	0785                	addi	a5,a5,1
    800064e8:	00002717          	auipc	a4,0x2
    800064ec:	68f73823          	sd	a5,1680(a4) # 80008b78 <uart_tx_w>
  uartstart();
    800064f0:	00000097          	auipc	ra,0x0
    800064f4:	ee4080e7          	jalr	-284(ra) # 800063d4 <uartstart>
  release(&uart_tx_lock);
    800064f8:	8526                	mv	a0,s1
    800064fa:	00000097          	auipc	ra,0x0
    800064fe:	1d6080e7          	jalr	470(ra) # 800066d0 <release>
}
    80006502:	70a2                	ld	ra,40(sp)
    80006504:	7402                	ld	s0,32(sp)
    80006506:	64e2                	ld	s1,24(sp)
    80006508:	6942                	ld	s2,16(sp)
    8000650a:	69a2                	ld	s3,8(sp)
    8000650c:	6a02                	ld	s4,0(sp)
    8000650e:	6145                	addi	sp,sp,48
    80006510:	8082                	ret
    for(;;)
    80006512:	a001                	j	80006512 <uartputc+0xb4>

0000000080006514 <uartgetc>:

// read one input character from the UART.
// return -1 if none is waiting.
int
uartgetc(void)
{
    80006514:	1141                	addi	sp,sp,-16
    80006516:	e422                	sd	s0,8(sp)
    80006518:	0800                	addi	s0,sp,16
  if(ReadReg(LSR) & 0x01){
    8000651a:	100007b7          	lui	a5,0x10000
    8000651e:	0057c783          	lbu	a5,5(a5) # 10000005 <_entry-0x6ffffffb>
    80006522:	8b85                	andi	a5,a5,1
    80006524:	cb91                	beqz	a5,80006538 <uartgetc+0x24>
    // input data is ready.
    return ReadReg(RHR);
    80006526:	100007b7          	lui	a5,0x10000
    8000652a:	0007c503          	lbu	a0,0(a5) # 10000000 <_entry-0x70000000>
    8000652e:	0ff57513          	andi	a0,a0,255
  } else {
    return -1;
  }
}
    80006532:	6422                	ld	s0,8(sp)
    80006534:	0141                	addi	sp,sp,16
    80006536:	8082                	ret
    return -1;
    80006538:	557d                	li	a0,-1
    8000653a:	bfe5                	j	80006532 <uartgetc+0x1e>

000000008000653c <uartintr>:
// handle a uart interrupt, raised because input has
// arrived, or the uart is ready for more output, or
// both. called from devintr().
void
uartintr(void)
{
    8000653c:	1101                	addi	sp,sp,-32
    8000653e:	ec06                	sd	ra,24(sp)
    80006540:	e822                	sd	s0,16(sp)
    80006542:	e426                	sd	s1,8(sp)
    80006544:	1000                	addi	s0,sp,32
  // read and process incoming characters.
  while(1){
    int c = uartgetc();
    if(c == -1)
    80006546:	54fd                	li	s1,-1
    int c = uartgetc();
    80006548:	00000097          	auipc	ra,0x0
    8000654c:	fcc080e7          	jalr	-52(ra) # 80006514 <uartgetc>
    if(c == -1)
    80006550:	00950763          	beq	a0,s1,8000655e <uartintr+0x22>
      break;
    consoleintr(c);
    80006554:	00000097          	auipc	ra,0x0
    80006558:	8fe080e7          	jalr	-1794(ra) # 80005e52 <consoleintr>
  while(1){
    8000655c:	b7f5                	j	80006548 <uartintr+0xc>
  }

  // send buffered characters.
  acquire(&uart_tx_lock);
    8000655e:	0002e497          	auipc	s1,0x2e
    80006562:	a5a48493          	addi	s1,s1,-1446 # 80033fb8 <uart_tx_lock>
    80006566:	8526                	mv	a0,s1
    80006568:	00000097          	auipc	ra,0x0
    8000656c:	0b4080e7          	jalr	180(ra) # 8000661c <acquire>
  uartstart();
    80006570:	00000097          	auipc	ra,0x0
    80006574:	e64080e7          	jalr	-412(ra) # 800063d4 <uartstart>
  release(&uart_tx_lock);
    80006578:	8526                	mv	a0,s1
    8000657a:	00000097          	auipc	ra,0x0
    8000657e:	156080e7          	jalr	342(ra) # 800066d0 <release>
}
    80006582:	60e2                	ld	ra,24(sp)
    80006584:	6442                	ld	s0,16(sp)
    80006586:	64a2                	ld	s1,8(sp)
    80006588:	6105                	addi	sp,sp,32
    8000658a:	8082                	ret

000000008000658c <initlock>:
#include "proc.h"
#include "defs.h"

void
initlock(struct spinlock *lk, char *name)
{
    8000658c:	1141                	addi	sp,sp,-16
    8000658e:	e422                	sd	s0,8(sp)
    80006590:	0800                	addi	s0,sp,16
  lk->name = name;
    80006592:	e50c                	sd	a1,8(a0)
  lk->locked = 0;
    80006594:	00052023          	sw	zero,0(a0)
  lk->cpu = 0;
    80006598:	00053823          	sd	zero,16(a0)
}
    8000659c:	6422                	ld	s0,8(sp)
    8000659e:	0141                	addi	sp,sp,16
    800065a0:	8082                	ret

00000000800065a2 <holding>:
// Interrupts must be off.
int
holding(struct spinlock *lk)
{
  int r;
  r = (lk->locked && lk->cpu == mycpu());
    800065a2:	411c                	lw	a5,0(a0)
    800065a4:	e399                	bnez	a5,800065aa <holding+0x8>
    800065a6:	4501                	li	a0,0
  return r;
}
    800065a8:	8082                	ret
{
    800065aa:	1101                	addi	sp,sp,-32
    800065ac:	ec06                	sd	ra,24(sp)
    800065ae:	e822                	sd	s0,16(sp)
    800065b0:	e426                	sd	s1,8(sp)
    800065b2:	1000                	addi	s0,sp,32
  r = (lk->locked && lk->cpu == mycpu());
    800065b4:	6904                	ld	s1,16(a0)
    800065b6:	ffffb097          	auipc	ra,0xffffb
    800065ba:	890080e7          	jalr	-1904(ra) # 80000e46 <mycpu>
    800065be:	40a48533          	sub	a0,s1,a0
    800065c2:	00153513          	seqz	a0,a0
}
    800065c6:	60e2                	ld	ra,24(sp)
    800065c8:	6442                	ld	s0,16(sp)
    800065ca:	64a2                	ld	s1,8(sp)
    800065cc:	6105                	addi	sp,sp,32
    800065ce:	8082                	ret

00000000800065d0 <push_off>:
// it takes two pop_off()s to undo two push_off()s.  Also, if interrupts
// are initially off, then push_off, pop_off leaves them off.

void
push_off(void)
{
    800065d0:	1101                	addi	sp,sp,-32
    800065d2:	ec06                	sd	ra,24(sp)
    800065d4:	e822                	sd	s0,16(sp)
    800065d6:	e426                	sd	s1,8(sp)
    800065d8:	1000                	addi	s0,sp,32
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    800065da:	100024f3          	csrr	s1,sstatus
    800065de:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() & ~SSTATUS_SIE);
    800065e2:	9bf5                	andi	a5,a5,-3
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800065e4:	10079073          	csrw	sstatus,a5
  int old = intr_get();

  intr_off();
  if(mycpu()->noff == 0)
    800065e8:	ffffb097          	auipc	ra,0xffffb
    800065ec:	85e080e7          	jalr	-1954(ra) # 80000e46 <mycpu>
    800065f0:	5d3c                	lw	a5,120(a0)
    800065f2:	cf89                	beqz	a5,8000660c <push_off+0x3c>
    mycpu()->intena = old;
  mycpu()->noff += 1;
    800065f4:	ffffb097          	auipc	ra,0xffffb
    800065f8:	852080e7          	jalr	-1966(ra) # 80000e46 <mycpu>
    800065fc:	5d3c                	lw	a5,120(a0)
    800065fe:	2785                	addiw	a5,a5,1
    80006600:	dd3c                	sw	a5,120(a0)
}
    80006602:	60e2                	ld	ra,24(sp)
    80006604:	6442                	ld	s0,16(sp)
    80006606:	64a2                	ld	s1,8(sp)
    80006608:	6105                	addi	sp,sp,32
    8000660a:	8082                	ret
    mycpu()->intena = old;
    8000660c:	ffffb097          	auipc	ra,0xffffb
    80006610:	83a080e7          	jalr	-1990(ra) # 80000e46 <mycpu>
  return (x & SSTATUS_SIE) != 0;
    80006614:	8085                	srli	s1,s1,0x1
    80006616:	8885                	andi	s1,s1,1
    80006618:	dd64                	sw	s1,124(a0)
    8000661a:	bfe9                	j	800065f4 <push_off+0x24>

000000008000661c <acquire>:
{
    8000661c:	1101                	addi	sp,sp,-32
    8000661e:	ec06                	sd	ra,24(sp)
    80006620:	e822                	sd	s0,16(sp)
    80006622:	e426                	sd	s1,8(sp)
    80006624:	1000                	addi	s0,sp,32
    80006626:	84aa                	mv	s1,a0
  push_off(); // disable interrupts to avoid deadlock.
    80006628:	00000097          	auipc	ra,0x0
    8000662c:	fa8080e7          	jalr	-88(ra) # 800065d0 <push_off>
  if(holding(lk))
    80006630:	8526                	mv	a0,s1
    80006632:	00000097          	auipc	ra,0x0
    80006636:	f70080e7          	jalr	-144(ra) # 800065a2 <holding>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000663a:	4705                	li	a4,1
  if(holding(lk))
    8000663c:	e115                	bnez	a0,80006660 <acquire+0x44>
  while(__sync_lock_test_and_set(&lk->locked, 1) != 0)
    8000663e:	87ba                	mv	a5,a4
    80006640:	0cf4a7af          	amoswap.w.aq	a5,a5,(s1)
    80006644:	2781                	sext.w	a5,a5
    80006646:	ffe5                	bnez	a5,8000663e <acquire+0x22>
  __sync_synchronize();
    80006648:	0ff0000f          	fence
  lk->cpu = mycpu();
    8000664c:	ffffa097          	auipc	ra,0xffffa
    80006650:	7fa080e7          	jalr	2042(ra) # 80000e46 <mycpu>
    80006654:	e888                	sd	a0,16(s1)
}
    80006656:	60e2                	ld	ra,24(sp)
    80006658:	6442                	ld	s0,16(sp)
    8000665a:	64a2                	ld	s1,8(sp)
    8000665c:	6105                	addi	sp,sp,32
    8000665e:	8082                	ret
    panic("acquire");
    80006660:	00002517          	auipc	a0,0x2
    80006664:	45050513          	addi	a0,a0,1104 # 80008ab0 <digits+0x20>
    80006668:	00000097          	auipc	ra,0x0
    8000666c:	a6a080e7          	jalr	-1430(ra) # 800060d2 <panic>

0000000080006670 <pop_off>:

void
pop_off(void)
{
    80006670:	1141                	addi	sp,sp,-16
    80006672:	e406                	sd	ra,8(sp)
    80006674:	e022                	sd	s0,0(sp)
    80006676:	0800                	addi	s0,sp,16
  struct cpu *c = mycpu();
    80006678:	ffffa097          	auipc	ra,0xffffa
    8000667c:	7ce080e7          	jalr	1998(ra) # 80000e46 <mycpu>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    80006680:	100027f3          	csrr	a5,sstatus
  return (x & SSTATUS_SIE) != 0;
    80006684:	8b89                	andi	a5,a5,2
  if(intr_get())
    80006686:	e78d                	bnez	a5,800066b0 <pop_off+0x40>
    panic("pop_off - interruptible");
  if(c->noff < 1)
    80006688:	5d3c                	lw	a5,120(a0)
    8000668a:	02f05b63          	blez	a5,800066c0 <pop_off+0x50>
    panic("pop_off");
  c->noff -= 1;
    8000668e:	37fd                	addiw	a5,a5,-1
    80006690:	0007871b          	sext.w	a4,a5
    80006694:	dd3c                	sw	a5,120(a0)
  if(c->noff == 0 && c->intena)
    80006696:	eb09                	bnez	a4,800066a8 <pop_off+0x38>
    80006698:	5d7c                	lw	a5,124(a0)
    8000669a:	c799                	beqz	a5,800066a8 <pop_off+0x38>
  asm volatile("csrr %0, sstatus" : "=r" (x) );
    8000669c:	100027f3          	csrr	a5,sstatus
  w_sstatus(r_sstatus() | SSTATUS_SIE);
    800066a0:	0027e793          	ori	a5,a5,2
  asm volatile("csrw sstatus, %0" : : "r" (x));
    800066a4:	10079073          	csrw	sstatus,a5
    intr_on();
}
    800066a8:	60a2                	ld	ra,8(sp)
    800066aa:	6402                	ld	s0,0(sp)
    800066ac:	0141                	addi	sp,sp,16
    800066ae:	8082                	ret
    panic("pop_off - interruptible");
    800066b0:	00002517          	auipc	a0,0x2
    800066b4:	40850513          	addi	a0,a0,1032 # 80008ab8 <digits+0x28>
    800066b8:	00000097          	auipc	ra,0x0
    800066bc:	a1a080e7          	jalr	-1510(ra) # 800060d2 <panic>
    panic("pop_off");
    800066c0:	00002517          	auipc	a0,0x2
    800066c4:	41050513          	addi	a0,a0,1040 # 80008ad0 <digits+0x40>
    800066c8:	00000097          	auipc	ra,0x0
    800066cc:	a0a080e7          	jalr	-1526(ra) # 800060d2 <panic>

00000000800066d0 <release>:
{
    800066d0:	1101                	addi	sp,sp,-32
    800066d2:	ec06                	sd	ra,24(sp)
    800066d4:	e822                	sd	s0,16(sp)
    800066d6:	e426                	sd	s1,8(sp)
    800066d8:	1000                	addi	s0,sp,32
    800066da:	84aa                	mv	s1,a0
  if(!holding(lk))
    800066dc:	00000097          	auipc	ra,0x0
    800066e0:	ec6080e7          	jalr	-314(ra) # 800065a2 <holding>
    800066e4:	c115                	beqz	a0,80006708 <release+0x38>
  lk->cpu = 0;
    800066e6:	0004b823          	sd	zero,16(s1)
  __sync_synchronize();
    800066ea:	0ff0000f          	fence
  __sync_lock_release(&lk->locked);
    800066ee:	0f50000f          	fence	iorw,ow
    800066f2:	0804a02f          	amoswap.w	zero,zero,(s1)
  pop_off();
    800066f6:	00000097          	auipc	ra,0x0
    800066fa:	f7a080e7          	jalr	-134(ra) # 80006670 <pop_off>
}
    800066fe:	60e2                	ld	ra,24(sp)
    80006700:	6442                	ld	s0,16(sp)
    80006702:	64a2                	ld	s1,8(sp)
    80006704:	6105                	addi	sp,sp,32
    80006706:	8082                	ret
    panic("release");
    80006708:	00002517          	auipc	a0,0x2
    8000670c:	3d050513          	addi	a0,a0,976 # 80008ad8 <digits+0x48>
    80006710:	00000097          	auipc	ra,0x0
    80006714:	9c2080e7          	jalr	-1598(ra) # 800060d2 <panic>
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
