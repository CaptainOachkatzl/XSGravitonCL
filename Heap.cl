struct Heap
{
    uchar * start;
    uint next;
};

struct Heap Heap_ctor(uchar * heapStart)
{
    struct Heap heap;
    heap.start = heapStart;
    heap.next = 0;

    return heap;
}

void * malloc (struct Heap * heap, size_t size)
{
    uint oldNext = heap->next;
    heap->next += size;
    //uint index = atomic_add(heap->next, size); // memory is private -> no need for threadsafety
    return heap->start + oldNext;
}