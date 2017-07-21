unit tbbmalloc;

interface

(** The "malloc" analogue to allocate block of memory of size bytes.
  * @ingroup memory_allocation *)
function scalable_malloc (size:NativeUInt):Pointer cdecl;

(** The "free" analogue to discard a previously allocated piece of memory.
    @ingroup memory_allocation *)
procedure scalable_free (ptr: Pointer) cdecl;

(** The "realloc" analogue complementing scalable_malloc.
    @ingroup memory_allocation *)
function scalable_realloc (ptr: Pointer; size:NativeUInt):Pointer cdecl;

implementation

const
  ippmalloc='tbbmalloc.dll';

function scalable_malloc;external ippmalloc;
procedure scalable_free (ptr: Pointer) cdecl;external ippmalloc;
function scalable_realloc (ptr: Pointer; size:NativeUInt):Pointer cdecl;external ippmalloc;

end.
