unit tbbMemoryManager;

interface

implementation

uses
  tbbmalloc,
  ippdefs,ipps
  ;

function GetMem(Size: NativeInt): Pointer;
begin
  Result:=nil;
  if Size>0 then
    Result:=scalable_malloc(Size);
end;

function FreeMem(P: Pointer): Integer;
begin
  scalable_free(P);
  Result:=0;
end;

function ReallocMem(P: Pointer; Size: NativeInt): Pointer;
begin
  Result:=nil;
  if Size>0 then
    Result:=scalable_realloc(P,Size);
end;

{Extended (optional) functionality.}

//platform aware funcion for ippsZero ASize>MaxInt
function ippsZero_8u_L(P: Pointer;ASize:NativeUInt):IppStatus;inline;
begin
  {$ifdef CPUX64}
  while ASize>MaxInt do
  begin
    Result:=ippsZero_8u(P,MaxInt);
    if Result<>IppStatus.ippStsNoErr then
      exit;

    Inc(PByte(P),MaxInt);
    Dec(ASize,MaxInt);
  end;

  if ASize>0 then
  {$endif}
    Result:=ippsZero_8u(P,ASize);
end;

function AllocMem(Size: NativeInt): Pointer;
begin
  Result:=GetMem(Size);

  if Result=nil then
    exit;

  ippsZero_8u_L(Result,Size);
(* Return values are
    ippStsNoErr Indicates no error.
    ippStsNullPtrErr Indicates an error when the pDst pointer is NULL.
    ippStsSizeErr Indicates an error when len is less than or equal to zero.

    ippStsNullPtrErr and ippStsSizeErr are not posible GetMem() would return nil
*)
end;

function RegisterExpectedMemoryLeak(P: Pointer): Boolean;
begin
  Result:=False;
end;

function UnregisterExpectedMemoryLeak(P: Pointer): Boolean;
begin
  Result:=False;
end;

procedure InitMemoryManager;
var
  MemoryManager: TMemoryManagerEx;
begin
  MemoryManager.GetMem:=GetMem;
  MemoryManager.FreeMem:=FreeMem;
  MemoryManager.ReallocMem:=ReallocMem;

  MemoryManager.AllocMem:=AllocMem;
  MemoryManager.RegisterExpectedMemoryLeak:=RegisterExpectedMemoryLeak;
  MemoryManager.UnregisterExpectedMemoryLeak:=UnregisterExpectedMemoryLeak;

  SetMemoryManager(MemoryManager);
end;

initialization
  InitMemoryManager;
finalization

end.
