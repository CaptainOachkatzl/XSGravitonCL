struct Heap
{
    uchar * start;
    __local uint * next;
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
    uint index = atomic_add(heap->next, size);
    return heap->start + index; 
}