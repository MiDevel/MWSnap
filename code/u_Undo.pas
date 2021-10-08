unit u_Undo;

interface

uses
  Graphics;

type
  TUndoStack = class
  private { Private declarations }
    m_ary: array of TBitmap;
    m_Count: Integer; // count of stored steps, 0..m_MaxSteps - 1
    m_CurrentIndex: Integer; // undo stack pointer
    m_LastWasUndo: Boolean; // was last Add() invoked from Undo?

    function  GetMaxSteps: Integer;
    procedure SetMaxSteps(iMax: Integer);

  published { Published declarations }
    property MaxSteps    : Integer read GetMaxSteps write SetMaxSteps; // size of the undo array
    property Count       : Integer read m_Count; // count of stored steps, 0..m_MaxSteps - 1
    property CurrentIndex: Integer read m_CurrentIndex; // undo stack pointer
    property LastWasUndo : Boolean read m_LastWasUndo; // was last Add() invoked from Undo?

  public { Public declarations }
    constructor Create;
    procedure   Clear;
    procedure   Add(bmp: TBitmap; fromUndo: Boolean);
    function    Undo(bmp: TBitmap): TBitmap;
    function    Redo: TBitmap;
    function    UndoPossible: Boolean;
    function    RedoPossible: Boolean;
  end;

var
  GlbUndo: TUndoStack;

implementation


//------------------------------------------------------------------------------
// Initialize the Undo stack
constructor TUndoStack.Create;
begin
  m_LastWasUndo := False;
  SetLength(m_Ary, 0);
  MaxSteps := 5;
end;
//------------------------------------------------------------------------------
// Is undo possible?
function TUndoStack.UndoPossible: Boolean;
begin
  UndoPossible := (    (m_Count > 1) and (m_CurrentIndex > 0)
                    or (m_Count = 1) and (m_CurrentIndex >= 0)
                  );

{
  Result := False;
  if (MaxSteps > 0) and (m_CntSteps > 0) and (m_CrrStep >= 0) then // must conditions
  begin
    if (m_CrrStep > 0) then // not the first element
      Result := True // always
    else // the first element
    begin
      if (m_CrrStep = m_CntSteps - 1) then // it's the top item, must store current for redo
      begin
        Result := True // always
      end;
    end;
  end;
}
end;
//------------------------------------------------------------------------------
// Is redo possible?
function TUndoStack.RedoPossible: Boolean;
begin
  Result := (MaxSteps > 0) and (m_Count > 0) and (m_CurrentIndex < m_Count - 1);
end;
//------------------------------------------------------------------------------
// Clear the Undo array
procedure TUndoStack.Clear;
begin
  m_Count := 0; // count of stored steps, 0..ArraySize - 1
  m_CurrentIndex := -1; // undo stack pointer
  m_LastWasUndo := False;
end;
//------------------------------------------------------------------------------
// Retrieve the size of the Undo array
function TUndoStack.GetMaxSteps: Integer;
begin
  Result := Length(m_Ary);
end;
//------------------------------------------------------------------------------
// Size the Undo array
procedure TUndoStack.SetMaxSteps(iMax: Integer);
var
  i: Integer;
begin
  if iMax = 1 then // 1 makes no sense
    iMax := 2;

  if (iMax >= 0) and (iMax <> Length(m_Ary)) then
  begin
    // free existing elements..
    for i := 0 to Length(m_Ary) - 1 do
    begin
      m_Ary[i].Free;
    end;

    //..create new ones..
    SetLength(m_Ary, iMax);
    for i := 0 to Length(m_Ary) - 1 do
    begin
      m_Ary[i] := TBitmap.Create;
    end;

    //.. and initialize pointers
    Clear;
  end;
end;
//------------------------------------------------------------------------------
// Put a new bitmap on the undo stack
procedure TUndoStack.Add(bmp: TBitmap; fromUndo: Boolean);
var
  i: Integer;
begin
  if (m_CurrentIndex = m_Count - 1) and
      ((not fromUndo) and m_LastWasUndo) then // it already exists
  begin
    ; // nothing
  end
  else // a new item
  begin
    if (MaxSteps > 0) then // undo enabled
    begin
      if (bmp <> nil) and (bmp.Width > 0) then
      begin
        if (m_CurrentIndex >= Length(m_Ary) - 1) then // reached the max count of elements
        begin
          for i := 0 to Length(m_Ary) - 2 do
          begin
            m_Ary[i].Assign(m_Ary[i+1]);
          end;
          m_CurrentIndex := Length(m_Ary) - 2;
        end;
        Inc(m_CurrentIndex);
        m_Ary[m_CurrentIndex].Assign(bmp);
        m_Count := m_CurrentIndex + 1;
      end;
    end;
  end;
  m_LastWasUndo := fromUndo;
end;
//------------------------------------------------------------------------------
// Perform Undo
function TUndoStack.Undo(bmp: TBitmap): TBitmap;
begin
  if UndoPossible then
  begin
    if (m_CurrentIndex = m_Count - 1) then // it's the top item, must store current for redo
      if not m_LastWasUndo then
        Add(bmp, True);

    if m_CurrentIndex > 0 then
      Dec(m_CurrentIndex);
  end;

  if m_CurrentIndex in [0..m_Count-1] then
    Result := m_Ary[m_CurrentIndex]
  else
    Result := bmp;
end;
//------------------------------------------------------------------------------
// Perform Redo
function TUndoStack.Redo: TBitmap;
begin
  if RedoPossible then
  begin
    Inc(m_CurrentIndex);
    Result := m_Ary[m_CurrentIndex];
  end
  else
    Result := nil;
end;
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------
//------------------------------------------------------------------------------

end.
