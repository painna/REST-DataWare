Unit uDWJSONObject;

{$I uRESTDW.inc}

Interface

Uses
 {$IFDEF FPC}
 SysUtils,            Classes, uDWJSONTools,    IdGlobal, DB, uDWJSON,   uDWConsts,
 uDWConstsData,       memds,   Variants,        LConvEncoding;
 {$ELSE}
 {$IF CompilerVersion > 21} // Delphi 2010 pra cima
 System.SysUtils,     System.Classes, Variants, uDWJSONTools, uDWConsts, uDWJSON,
 uDWConstsData,       IdGlobal, System.Rtti,    Data.DB,      Soap.EncdDecd,
 Datasnap.DbClient
 {$IFDEF POSIX} //ANDROID}
 {$IF Defined(ANDROID) or Defined(IOS)} //Alteardo para IOS Brito
   ,system.json, FMX.Types
 {$IFEND}
 {$IF (NOT Defined(FPC) AND Defined(LINUX))} //Alteardo para Lazarus LINUX Brito
 ,system.json
 {$ENDIF}
 {$ENDIF}
 {$IFDEF RESJEDI}
  ,JvMemoryDataset
 {$ENDIF}
 {$IFDEF RESTKBMMEMTABLE}
  ,kbmmemtable
 {$ENDIF}
 {$IFDEF RESTFDMEMTABLE}
  ,FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client
 {$ENDIF};
 {$ELSE}
 SysUtils, Classes,   Variants, uDWJSONTools,   uDWJSON, IdGlobal, DB,   EncdDecd,
 DbClient, uDWConsts, uDWConstsData
 {$IFDEF RESJEDI}
  ,JvMemoryDataset
 {$ENDIF}
 {$IFDEF RESTKBMMEMTABLE}
  ,kbmmemtable
 {$ENDIF};
 {$IFEND}
 {$ENDIF}

Type
 TJSONBufferObject = Class
End;

Type
 TJSONValue = Class
Private
 vNullValue,
 vBinary: Boolean;
 vtagName: String;
 vTypeObject: TTypeObject;
 vObjectDirection: TObjectDirection;
 vObjectValue: TObjectValue;
 aValue: TIdBytes;
 vEncoded: Boolean;
 {$IFNDEF FPC}
 {$IF CompilerVersion > 21}
 vEncoding: TEncoding;
 {$IFEND}
 {$ENDIF}
 {$IFDEF FPC}
 vDatabaseCharSet   : TDatabaseCharSet;
 {$ENDIF}
 Function  GetValue : String;
 Procedure WriteValue   (bValue      : String);
 Function  FormatValue  (bValue      : String)       : String;
 Function  GetValueJSON (bValue      : String)       : String;
 Function  DatasetValues(bValue      : TDataset;
                         DTSeparator : String = '/';
                         TMSeparator : String = ':';
                         DCSeparator : String = ',') : String;
 Function EncodedString : String;
Public
 Procedure ToStream(Var    bValue       : TMemoryStream);
 Procedure LoadFromDataset(TableName    : String;
                           bValue       : TDataset;
                           EncodedValue : Boolean = True;
                           DTSeparator  : String = '/';
                           TMSeparator  : String = ':';
                           DCSeparator  : String = ','{$IFDEF FPC};
                           CharSet      : TDatabaseCharSet = csUndefined{$ENDIF});
 // alterado por fabricio  passa o nome da tabela
 Procedure WriteToDataset (DatasetType  : TDatasetType;
                           JSONValue    : String;
                           DestDS       : TDataset;
                           DTSeparator  : String = '/';
                           TMSeparator  : String = ':';
                           DCSeparator  : String = ','{$IFDEF FPC};
                           CharSet      : TDatabaseCharSet = csUndefined{$ENDIF});
 Procedure LoadFromJSON   (bValue       : String);
 Procedure LoadFromStream (Stream       : TMemoryStream;
                           Encode       : Boolean = True);
 Procedure SaveToStream   (Stream       : TMemoryStream);
 Function  ToJSON  : String;
 Procedure SetValue       (Value        : String;
                           Encode       : Boolean = True);
 Function  Value   : String;
 Constructor Create;
 Destructor  Destroy; Override;
 Function    IsNull          : Boolean;
 Property    TypeObject      : TTypeObject      Read vTypeObject      Write vTypeObject;
 Property    ObjectDirection : TObjectDirection Read vObjectDirection Write vObjectDirection;
 Property    ObjectValue     : TObjectValue     Read vObjectValue     Write vObjectValue;
 {$IFNDEF FPC}
 {$IF CompilerVersion > 21}
 Property    Encoding        : TEncoding        Read vEncoding        Write vEncoding;
 {$IFEND}
 {$ENDIF}
 Property    Tagname         : String           Read vtagName         Write vtagName;
 Property    Encoded         : Boolean          Read vEncoded         Write vEncoded;
 {$IFDEF FPC}
 Property DatabaseCharSet    : TDatabaseCharSet Read vDatabaseCharSet Write vDatabaseCharSet;
 {$ENDIF}
End;

Type
 PJSONParam = ^TJSONParam;
 TJSONParam = Class(TObject)
Private
 vJSONValue       : TJSONValue;
 {$IFNDEF FPC}
 {$IF CompilerVersion > 21}
  vEncoding       : TEncoding;
 {$IFEND}
 {$ENDIF}
 vTypeObject      : TTypeObject;
 vObjectDirection : TObjectDirection;
 vObjectValue     : TObjectValue;
 vParamName       : String;
 vBinary,
 vEncoded         : Boolean;
 Procedure WriteValue  (bValue     : String);
 Procedure SetParamName(bValue     : String);
Public
 Constructor Create{$IFNDEF FPC}{$IF CompilerVersion > 21}(Encoding: TEncoding){$IFEND}{$ENDIF};
 Destructor  Destroy; Override;
 Procedure   FromJSON(JSON         : String);
 Function    ToJSON                : String;
 Procedure   CopyFrom(JSONParam    : TJSONParam);
 Function    Value                 : String;
 Procedure   SetValue(aValue       : String;
                      Encode       : Boolean = True);
 Procedure   LoadFromStream(Stream : TMemoryStream;
                            Encode : Boolean = True);
 Procedure   SaveToStream  (Stream : TMemoryStream);
 Procedure   LoadFromParam (Param  : TParam);
 Property    ObjectDirection       : TObjectDirection Read vObjectDirection Write vObjectDirection;
 Property    ObjectValue           : TObjectValue     Read vObjectValue     Write vObjectValue;
 Property    ParamName             : String           Read vParamName       Write SetParamName;
 Property    Encoded               : Boolean          Read vEncoded         Write vEncoded;
End;

Type
 PStringStream     = ^TStringStream;
 TStringStreamList = Class(TList)
Private
 Function  GetRec(Index   : Integer) : TStringStream;       Overload;
 Procedure PutRec(Index   : Integer;
                  Item    : TStringStream);                 Overload;
 Procedure ClearList;
Public
 Constructor Create;
 Destructor  Destroy; Override;
 Procedure   Delete(Index : Integer); Overload;
 Function    Add   (Item  : TStringStream) : Integer;       Overload;
 Property    Items[Index  : Integer]       : TStringStream  Read GetRec Write PutRec; Default;
End;

Type
 TDWParams = Class(TList)
Private
 {$IFNDEF FPC}
 {$IF CompilerVersion > 21}
 vEncoding : TEncoding;
 {$IFEND}
 {$ENDIF}
 Function    GetRec    (Index     : Integer) : TJSONParam;  Overload;
 Procedure   PutRec    (Index     : Integer;
                        Item      : TJSONParam);            Overload;
 Function    GetRecName(Index     : String)  : TJSONParam;  Overload;
 Procedure   PutRecName(Index     : String;
                        Item      : TJSONParam);            Overload;
 Procedure   ClearList;
Public
 Constructor Create;
 Destructor  Destroy; Override;
 Function    ParamsReturn         : Boolean;
 Function    ToJSON               : String;
 Procedure   FromJSON   (JSON     : String);
 Procedure   CopyFrom   (DWParams : TDWParams);
 Procedure   Delete     (Index    : Integer);               Overload;
 Function    Add        (Item     : TJSONParam): Integer;   Overload;
 Property    Items      [Index    : Integer]   : TJSONParam Read GetRec     Write PutRec; Default;
 Property    ItemsString[Index    : String]    : TJSONParam Read GetRecName Write PutRecName;
 {$IFNDEF FPC}
 {$IF CompilerVersion > 21}
 Property   Encoding : TEncoding Read vEncoding Write vEncoding;
 {$IFEND}
 {$ENDIF}
End;

Type
 TDWDatalist = Class
End;

implementation

Uses uRESTDWPoolerDB;

Function removestr(Astr: string; Asubstr: string):string;
Begin
 result:= stringreplace(Astr,Asubstr,'',[rfReplaceAll, rfIgnoreCase]);
End;

{$IF Defined(ANDROID) or Defined(IOS)} //Alterado para IOS Brito
Function CopyValue(Var bValue : String) : String;
Var
 vOldString,
 vStringBase,
 vTempString      : String;
 A, vLengthString : Integer;



 //string for debug only
 deb1, deb2: string;
Begin


 vOldString := bValue;
 vStringBase := '"ValueType":"';
 vLengthString := Length(vStringBase)-1;
 vTempString := Copy(bValue, Pos(vStringBase, bValue) + vLengthString, Length(bValue)-1);
 A := Pos(':', vTempString);
 vTempString := Copy(vTempString, A, Length(vTempString)-1);
 If vTempString[InitStrPos] = ':' Then
  vTempString:=vTempString.Remove(InitStrPos,1);// [InitStrPos]:=char(''); //Delete(vTempString, InitStrPos, 1);
 If vTempString[InitStrPos] = '"' Then
  vTempString:=vTempString.Remove(InitStrPos,1);//vTempString[InitStrPos]:='';//Delete(vTempString, InitStrPos, 1);
 If vTempString = '}' Then
  vTempString := '';
 If vTempString <> '' Then
  Begin
   For A := Length(vTempString)-1 Downto InitStrPos Do
    Begin
     If vTempString[Length(vTempString)-1] <> '}' Then
      vTempString:=vTempString.Remove(Length(vTempString)-1,1) // vTempString[Length(vTempString)-1]:='' //Delete(vTempString, Length(vTempString), 1)
     Else
      Begin
       vTempString:=vTempString.Remove(Length(vTempString)-1,1); //vTempString[Length(vTempString)-1]:='';//Delete(vTempString, Length(vTempString), 1);
       Break;
      End;
    End;
   If vTempString[Length(vTempString)-1] = '"' Then
    vTempString:=vTempString.Remove(Length(vTempString)-1,1); // vTempString[Length(vTempString)-1]:='';//Delete(vTempString, Length(vTempString), 1);
  End;
 Result := vTempString;
 deb1:= copy(result,length(result)-50,length(result)-1);
 bValue := StringReplace(bValue, Result, '', [rfReplaceAll]);
 deb1:= copy(bValue,length(bValue)-50,length(bValue)-1);
End;

{$ELSE}

Function CopyValue(Var bValue : String) : String;
Var
 vOldString,
 vStringBase,
 vTempString      : String;
 A, vLengthString : Integer;
Begin


 vOldString := bValue;
 vStringBase := '"ValueType":"';
 vLengthString := Length(vStringBase);
 vTempString := Copy(bValue, Pos(vStringBase, bValue) + vLengthString, Length(bValue));
 A := Pos(':', vTempString);
 vTempString := Copy(vTempString, A, Length(vTempString));
 If vTempString[InitStrPos] = ':' Then
  Delete(vTempString, InitStrPos, 1);
 If vTempString[InitStrPos] = '"' Then
  Delete(vTempString, InitStrPos, 1);
 If vTempString = '}' Then
  vTempString := '';
 If vTempString <> '' Then
  Begin
   For A := Length(vTempString) Downto InitStrPos Do
    Begin
     If vTempString[Length(vTempString)] <> '}' Then
      Delete(vTempString, Length(vTempString), 1)
     Else
      Begin
       Delete(vTempString, Length(vTempString), 1);
       Break;
      End;
    End;
   If vTempString[Length(vTempString)] = '"' Then
    Delete(vTempString, Length(vTempString), 1);
  End;
 Result := vTempString;
 bValue := StringReplace(bValue, Result, '', [rfReplaceAll]);
End;
{$IFEND}

Function TDWParams.Add(Item : TJSONParam): Integer;
Var
 vItem : ^TJSONParam;
Begin
 New(vItem);
 vItem^ := Item;
 {$IFNDEF FPC}
 {$IF CompilerVersion > 21}
  vItem^.vEncoding := vEncoding;
 {$IFEND}
 {$ENDIF}
 Result := TList(Self).Add(vItem);
End;

Constructor TDWParams.Create;
Begin
 Inherited;
 {$IFNDEF FPC}
 {$IF CompilerVersion > 21}
 {$IF Defined(ANDROID) OR Defined(IOS)} //Alterado para IOS Brito
  vEncoding := TEncoding.UTF8;
 {$ELSE}
  vEncoding := TEncoding.ASCII;
  {$IFEND}
 {$IFEND}
 {$ENDIF}
End;

Function TDWParams.ToJSON: String;
Var
 I : Integer;
Begin
 For I := 0 To Self.Count - 1 Do
  Begin
   If I = 0 Then
    Result := TJSONParam(TList(Self).Items[I]^).ToJSON
   Else
    Result := Result + ', ' + TJSONParam(TList(Self).Items[I]^).ToJSON;
  End;
End;

{$IFDEF POSIX}
{$IF (NOT Defined(FPC) AND Defined(LINUX))} //Alteardo para Lazarus LINUX Brito
Procedure TDWParams.FromJSON(JSON: String);
Var
 bJsonOBJ,
 bJsonValue : system.json.TJsonObject;
 bJsonArray : system.json.TJsonArray;
 JSONParam  : TJSONParam;
 I          : Integer;
Begin
 bJsonValue := TJSONObject.ParseJSONValue(Format('{"PARAMS":[%s]}', [JSON])) as TJSONObject; // udwjson.TJsonObject.Create(Format('{"PARAMS":[%s]}', [JSON]));
 Try
  bJsonArray  :=   bJsonValue.pairs[0].jsonvalue as TJsonArray; //  bJsonValue.optJSONArray(bJsonValue.names.get(0).ToString);
  For I := 0 To bJsonArray.count - 1 Do
   Begin
    {$IFNDEF FPC}
    {$IF CompilerVersion > 21}
    JSONParam := TJSONParam.Create(GetEncoding(TEncodeSelect(vEncoding)));
    {$ELSE}
    JSONParam := TJSONParam.Create;
    {$IFEND}
    {$ELSE}
    JSONParam := TJSONParam.Create;
    {$ENDIF}
    bJsonOBJ  :=  bJsonArray.items[0] as TJSONObject;  //udwjson.TJsonObject.Create(bJsonArray.get(I).ToString);
    Try
     JSONParam.ParamName       := Lowercase  (removestr(bJsonOBJ.pairs[4].jsonstring.tostring,'"')); //         (bJsonOBJ.names.get(4).ToString);
     JSONParam.ObjectDirection := GetDirectionName (removestr(bJsonOBJ.pairs[1].jsonvalue.tostring,'"')); //   (bJsonOBJ.opt(bJsonOBJ.names.get(1).ToString).ToString);
     JSONParam.ObjectValue     := GetValueType (removestr(bJsonOBJ.pairs[3].jsonvalue.tostring,'"'));    //       (bJsonOBJ.opt(bJsonOBJ.names.get(3).ToString).ToString);
     JSONParam.Encoded         := GetBooleanFromString(removestr(bJsonOBJ.pairs[2].jsonvalue.tostring,'"')); //(bJsonOBJ.opt(bJsonOBJ.names.get(2).ToString).ToString);
     JSONParam.SetValue(removestr(bJsonOBJ.pairs[4].jsonvalue.tostring,'"')); //bJsonOBJ.opt(bJsonOBJ.names.get(4).ToString).ToString);
     Add(JSONParam);
    Finally
     //bJsonOBJ.Clean;
     FreeAndNil(bJsonOBJ);
    End;
   End;
 Finally
  bJsonValue.Free;
 End;
End;
 {$ELSE}
 Procedure TDWParams.FromJSON(JSON: String);
 Begin

    raise Exception.Create('Nao Usado no android)');//N�o usado no android ainda

 End;
{$ENDIF}
{$ELSE}
Procedure TDWParams.FromJSON(JSON: String);
Var
 bJsonOBJ,
 bJsonValue : udwjson.TJsonObject;
 bJsonArray : udwjson.TJsonArray;
 JSONParam  : TJSONParam;
 I          : Integer;
Begin
 bJsonValue := udwjson.TJsonObject.Create(Format('{"PARAMS":[%s]}', [JSON]));
 Try
  bJsonArray  := bJsonValue.optJSONArray(bJsonValue.names.get(0).ToString);
  For I := 0 To bJsonArray.Length - 1 Do
   Begin
    {$IFNDEF FPC}
    {$IF CompilerVersion > 21}
    JSONParam := TJSONParam.Create(GetEncoding(TEncodeSelect(vEncoding)));
    {$ELSE}
    JSONParam := TJSONParam.Create;
    {$IFEND}
    {$ELSE}
    JSONParam := TJSONParam.Create;
    {$ENDIF}
    bJsonOBJ  := udwjson.TJsonObject.Create(bJsonArray.get(I).ToString);
    Try
     JSONParam.ParamName       := Lowercase           (bJsonOBJ.names.get(4).ToString);
     JSONParam.ObjectDirection := GetDirectionName    (bJsonOBJ.opt(bJsonOBJ.names.get(1).ToString).ToString);
     JSONParam.ObjectValue     := GetValueType        (bJsonOBJ.opt(bJsonOBJ.names.get(3).ToString).ToString);
     JSONParam.Encoded         := GetBooleanFromString(bJsonOBJ.opt(bJsonOBJ.names.get(2).ToString).ToString);
     If (JSONParam.ObjectValue in [ovString, ovWideString]) And (JSONParam.Encoded) Then
      JSONParam.SetValue(DecodeStrings(bJsonOBJ.opt(bJsonOBJ.names.get(4).ToString).ToString{$IFDEF FPC}, csUndefined{$ENDIF}))
     Else
      JSONParam.SetValue(bJsonOBJ.opt(bJsonOBJ.names.get(4).ToString).ToString);
     Add(JSONParam);
    Finally
     bJsonOBJ.Clean;
     FreeAndNil(bJsonOBJ);
    End;
   End;
 Finally
  bJsonValue.Free;
 End;
End;

{$ENDIF}

Procedure TDWParams.CopyFrom(DWParams : TDWParams);
Var
 I         : Integer;
 p,
 JSONParam : TJSONParam;
Begin
 Clear;
 For I := 0 To DWParams.Count -1 Do
  Begin
   p := DWParams.Items[I];
   JSONParam := TJSONParam.Create{$IFNDEF FPC}{$IF CompilerVersion > 21} (DWParams.Encoding){$IFEND}{$ENDIF};
   JSONParam.CopyFrom(p);
   Add(JSONParam);
  End;
End;

Procedure TDWParams.Delete(Index : Integer);
Begin
 If (Index < Self.Count) And (Index > -1) Then
  Begin
   If Assigned(TList(Self).Items[Index]) Then
    Begin
     FreeAndNil(TList(Self).Items[Index]^);
     {$IFDEF FPC}
      Dispose(PJSONParam(TList(Self).Items[Index]));
     {$ELSE}
      Dispose(TList(Self).Items[Index]);
     {$ENDIF}
    End;
   TList(Self).Delete(Index);
  End;
End;

Procedure TDWParams.ClearList;
Var
 I : Integer;
Begin
 For I := Count - 1 Downto 0 Do
  Delete(I);
 Self.Clear;
End;

Destructor TDWParams.Destroy;
Begin
 ClearList;
 Inherited;
End;

Function TDWParams.GetRec(Index: Integer): TJSONParam;
Begin
 Result := Nil;
 If (Index < Self.Count) And (Index > -1) Then
  Result := TJSONParam(TList(Self).Items[Index]^);
End;

Function TDWParams.GetRecName(Index: String): TJSONParam;
Var
 I : Integer;
Begin
 Result := Nil;
 For I := 0 To Self.Count - 1 Do
  Begin
   If (Uppercase(Index) = Uppercase(TJSONParam(TList(Self).Items[I]^).vParamName)) Then
    Begin
     Result := TJSONParam(TList(Self).Items[I]^);
     Break;
    End;
  End;
End;

Function TDWParams.ParamsReturn: Boolean;
Var
 I : Integer;
Begin
 Result := False;
 For I := 0 To Self.Count - 1 Do
  Begin
   Result := Items[I].vObjectDirection In [odOUT, odINOUT];
   If Result Then
    Break;
  End;
End;

Procedure TDWParams.PutRec(Index: Integer; Item: TJSONParam);
Begin
 If (Index < Self.Count) And (Index > -1) Then
  TJSONParam(TList(Self).Items[Index]^) := Item;
End;

Procedure TDWParams.PutRecName(Index: String; Item: TJSONParam);
Var
 I : Integer;
Begin
 For I := 0 To Self.Count - 1 Do
  Begin
   If (Uppercase(Index) = Uppercase(TJSONParam(TList(Self).Items[I]^).vParamName)) Then
    Begin
     TJSONParam(TList(Self).Items[I]^) := Item;
     Break;
    End;
  End;
End;

Function EscapeQuotes(Const S: String): String;
Begin
 // Easy but not best performance
 Result := StringReplace(S,      '\', TSepValueMemString,    [rfReplaceAll]);
 Result := StringReplace(Result, '"', TQuotedValueMemString, [rfReplaceAll]);
End;

Function RevertQuotes(Const S: String): String;
Begin
 // Easy but not best performance
 Result := StringReplace(S,      TSepValueMemString,    '\', [rfReplaceAll]);
 Result := StringReplace(Result, TQuotedValueMemString, '"', [rfReplaceAll]);
End;

Constructor TJSONValue.Create;
Begin
 Inherited;
 {$IFNDEF FPC}
 {$IF CompilerVersion > 21}
 vEncoding       := TEncoding.ASCII;
 {$IFEND}
 {$ENDIF}
 {$IFDEF FPC}
 vDatabaseCharSet := csUndefined;
 {$ENDIF}
 vTypeObject     := toObject;
 ObjectDirection := odINOUT;
 vObjectValue    := ovString;
 vtagName        := 'TAGJSON';
 vBinary         := True;
 vNullValue      := True;
End;

Destructor TJSONValue.Destroy;
Begin
 SetLength(aValue, 0);
 Inherited;
End;

Function TJSONValue.GetValueJSON(bValue: String): String;
Begin
 Result := bValue;
 If vObjectValue In [ovString,        ovFixedChar,    ovWideString,
                     ovFixedWideChar, ovDate, ovTime, ovDateTime] Then
  Result := bValue;
End;

Function TJSONValue.IsNull: Boolean;
Begin
 Result := vNullValue;
End;

Function TJSONValue.FormatValue(bValue: String): String;
Var
 aResult : String;
Begin
 aResult := Stringreplace(bValue, #000, '', [rfReplaceAll]);
 If vTypeObject = toDataset Then
  Result := Format(TValueFormatJSON,      ['ObjectType', GetObjectName(vTypeObject),         'Direction',
                                                         GetDirectionName(vObjectDirection), 'Encoded',
                                                         EncodedString,                      'ValueType',
                                                         GetValueType(vObjectValue),         vtagName,
                                                         GetValueJSON(aResult)])
 Else
  Result := Format(TValueFormatJSONValue, ['ObjectType', GetObjectName(vTypeObject),         'Direction',
                                                         GetDirectionName(vObjectDirection), 'Encoded',
                                                         EncodedString,                      'ValueType',
                                                         GetValueType(vObjectValue),         vtagName,
                                                         GetValueJSON(aResult)]);
End;

Function TJSONValue.GetValue: String;
Var
 vTempString : String;
Begin
 Result := '';
 If Length(aValue) = 0 Then
  Exit;
 vTempString := BytesArrToString(aValue);
{$IF Defined(ANDROID) or defined(IOS)} //Alterado para IOS Brito
If Length(vTempString) > 0 Then
 Begin
  If vTempString[InitStrPos]          = '"' Then
    vTempString:=vTempString.Substring(1, Length(vTempString)-1);
    //vTempString:= copy(vTempString,1,Length(vTempString)-1);
   //Delete(vTempString, InitStrPos, 1);
  If vTempString[Length(vTempString)-1] = '"' Then
    vTempString:= copy(vTempString,InitStrPos,Length(vTempString)-1);
   //Delete(vTempString, Length(vTempString)-1, 1);
  vTempString := Trim(vTempString);
 End;
If vEncoded Then
 Begin
  If (vObjectValue In [ovBytes, ovVarBytes, ovBlob,
                       ovGraphic, ovOraBlob, ovOraClob]) And (vBinary) Then
   vTempString := vTempString
  Else
   Begin
    If Length(vTempString) > 0 Then
     vTempString := DecodeStrings(vTempString);
   End;
 End
Else
 vTempString := BytesArrToString(aValue);
If vObjectValue = ovString Then
 Begin
  If vTempString <> '' Then
   If vTempString[InitStrPos] = '"' Then
    Begin
     Delete(vTempString, 1, 1);
     If vTempString[Length(vTempString)] = '"' Then
      Delete(vTempString, Length(vTempString), 1);
    End;
  Result := vTempString;
 End
Else
 Result := vTempString;

{$ELSE}
 If Length(vTempString) > 0 Then
  Begin
   If vTempString[InitStrPos]          = '"' Then
    Delete(vTempString, InitStrPos, 1);
   If vTempString[Length(vTempString)] = '"' Then
    Delete(vTempString, Length(vTempString), 1);
   vTempString := Trim(vTempString);
  End;
 If vEncoded Then
  Begin
   If (vObjectValue In [ovBytes, ovVarBytes, ovBlob,
                        ovGraphic, ovOraBlob, ovOraClob]) And (vBinary) Then
    vTempString := vTempString
   Else
    Begin
     If Length(vTempString) > 0 Then
      vTempString := DecodeStrings(vTempString{$IFDEF FPC}, vDatabaseCharSet{$ENDIF});
    End;
  End
 Else
  vTempString := BytesArrToString(aValue);
 If vObjectValue = ovString Then
  Begin
   If vTempString <> '' Then
    If vTempString[InitStrPos] = '"' Then
     Begin
      Delete(vTempString, 1, 1);
      If vTempString[Length(vTempString)] = '"' Then
       Delete(vTempString, Length(vTempString), 1);
     End;
   Result := vTempString;
  End
 Else
  Result := vTempString;
 {$IFEND}
End;

Function TJSONValue.DatasetValues(bValue      : TDataset;
                                  DTSeparator : String = '/';
                                  TMSeparator : String = ':';
                                  DCSeparator : String = ',') : String;
Var
 vLines : String;
 A      : Integer;
 Function GenerateHeader: String;
 Var
  I              : Integer;
  vPrimary,
  vRequired,
  vReadOnly,
  vGenerateLine,
  vAutoinc       : string;
 Begin
  For I := 0 To bValue.Fields.Count - 1 Do
   Begin
    vPrimary  := 'N';
    vAutoinc  := 'N';
    vReadOnly := 'N';
    If pfInKey in bValue.Fields[I].ProviderFlags Then
     vPrimary := 'S';
    vRequired := 'N';
    If bValue.Fields[I].Required Then
     vRequired := 'S';
    If Not (bValue.Fields[I].CanModify) Then
     vReadOnly := 'S';
    {$IFNDEF FPC}{$IF CompilerVersion > 21}
     If bValue.Fields[I].AutoGenerateValue = arAutoInc Then
      vAutoinc := 'S';
    {$ELSE}
     vAutoinc := 'N';
    {$IFEND}
    {$ENDIF}
    If bValue.Fields[I].DataType In [{$IFNDEF FPC}{$IF CompilerVersion > 21}ftExtended,
                                     {$IFEND}{$ENDIF}ftFloat, ftCurrency, ftFMTBcd, ftBCD] Then
     vGenerateLine := Format(TJsonDatasetHeader, [bValue.Fields[I].FieldName,
                                                  GetFieldType(bValue.Fields[I].DataType),
                                                  vPrimary, vRequired, TFloatField(bValue.Fields[I]).Size,
                                                  TFloatField(bValue.Fields[I]).Precision, vReadOnly, vAutoinc])
    Else
     vGenerateLine := Format(TJsonDatasetHeader, [bValue.Fields[I].FieldName,
                                                  GetFieldType(bValue.Fields[I].DataType),
                                                  vPrimary, vRequired, bValue.Fields[I].Size, 0, vReadOnly, vAutoinc]);
    If I = 0 Then
     Result := vGenerateLine
    Else
     Result := Result + ', ' + vGenerateLine;
   End;
 End;
 Function GenerateLine: String;
 Var
  I             : Integer;
  vTempValue    : String;
  bStream       : TStream;
  vStringStream : TStringStream;
 Begin
  For I := 0 To bValue.Fields.Count - 1 Do
   Begin
    If Not bValue.Fields[I].IsNull then
     Begin
      If bValue.Fields[I].DataType In [{$IFNDEF FPC}{$IF CompilerVersion > 21}ftExtended,
                                       {$IFEND}{$ENDIF}ftFloat, ftCurrency, ftFMTBcd, ftBCD] Then
       vTempValue := Format('"%s"', [StringReplace(FormatFloat('########0.0000', bValue.Fields[I].AsFloat), ',', 'dc', [rfReplaceAll])])
      Else If bValue.Fields[I].DataType in [ftBytes, ftVarBytes, ftBlob, ftGraphic, ftOraBlob, ftOraClob] Then
       Begin
        vStringStream := TStringStream.Create('');
        Try
         bStream := bValue.CreateBlobStream(TBlobField(bValue.Fields[I]), bmRead);
         bStream.Position := 0;
         {$IFDEF FPC}
         vStringStream.CopyFrom(bStream, bStream.Size);
         {$ELSE}
         {$IF CompilerVersion > 21}
         vStringStream.LoadFromStream   (bStream);
         {$ELSE}
         vStringStream.CopyFrom(bStream, bStream.Size);
         {$IFEND}
         {$ENDIF}
         If vEncoded Then
          vTempValue := Format('%s',   [StreamToHex(vStringStream)])
         Else
          vTempValue := Format('"%s"', [vStringStream.DataString])
        Finally
         vStringStream.Free;
        End;
       End
      Else
       Begin
        If bValue.Fields[I].DataType in      [ftString,  ftWideString, ftMemo,
                                              {$IFNDEF FPC}{$IF CompilerVersion > 21}ftWideMemo,
                                              {$IFEND}{$ENDIF}
                                              ftFmtMemo, ftFixedChar] Then
         Begin
          If vEncoded Then
           Begin
            {$IFDEF FPC}
             vTempValue := Format('"%s"',      [EncodeStrings(bValue.Fields[I].AsString, vDatabaseCharSet)]);
            {$ELSE}
             vTempValue := Format('"%s"',      [EncodeStrings(bValue.Fields[I].AsString)]);
            {$ENDIF}
           End
          Else
           Begin
            {$IFDEF FPC}
             vTempValue := Format('"%s"',      [CP1252ToUTF8(bValue.Fields[I].AsString)])
            {$ELSE}
             vTempValue := Format('"%s"',      [bValue.Fields[I].AsString])
            {$ENDIF}
           End;
         End
        Else If bValue.Fields[I].DataType in [ftDate, ftTime, ftDateTime, ftTimeStamp] Then
         Begin
          If bValue.Fields[I].DataType      = ftDate Then
           vTempValue := Format ('"%s"',       [StringReplace(FormatDateTime('dd/mm/yyyy', bValue.Fields[I].AsDateTime), '/', 'dt', [rfReplaceAll])])
          Else If bValue.Fields[I].DataType = ftTime Then
           vTempValue := Format ('"%s"',       [StringReplace(FormatDateTime('hh:mm:ss',   bValue.Fields[I].AsDateTime), ':', 'ts', [rfReplaceAll])])
          Else If bValue.Fields[I].DataType In [ftDateTime, ftTimeStamp] Then
           Begin
            vTempValue := StringReplace  (FormatDateTime('dd/mm/yyyy', bValue.Fields[I].AsDateTime), '/', 'dt', [rfReplaceAll]);
            vTempValue := Format('"%s"', [vTempValue + ' ' + StringReplace(FormatDateTime('hh:mm:ss', bValue.Fields[I].AsDateTime), ':', 'ts', [rfReplaceAll])]);
           End;
         End
        Else
         vTempValue    := Format('"%s"', [bValue.Fields[I].AsString]);    //asstring
       End;
     End
    Else
     vTempValue := Format('"%s"', ['null']);
    If I = 0 Then
     Result := vTempValue
    Else
     Result := Result + ', ' + vTempValue;
   End;
 End;
Begin
 bValue.DisableControls;
 Try
  If Not bValue.Active Then
   bValue.Open;
  bValue.First;
  Result    := '{"fields":[' + GenerateHeader + ']}, {"lines":[%s]}';
  A := 0;
  While Not bValue.Eof Do
   Begin
    If bValue.RecNo = 1 Then
     vLines := Format('{"line%d":[%s]}', [A, GenerateLine])
    Else
     vLines := vLines + Format(', {"line%d":[%s]}', [A, GenerateLine]);
    bValue.Next;
    Inc(A);
   End;
  Result    := Format(Result, [vLines]);
  bValue.First;
 Finally
  bValue.EnableControls;
 End;
End;

Function TJSONValue.EncodedString: String;
Begin
 If vEncoded Then
  Result := 'true'
 Else
  Result := 'false';
End;

Procedure TJSONValue.LoadFromDataset(TableName    : String;
                                     bValue       : TDataset;
                                     EncodedValue : Boolean = True;
                                     DTSeparator  : String = '/';
                                     TMSeparator  : String = ':';
                                     DCSeparator  : String = ','{$IFDEF FPC};
                                     CharSet      : TDatabaseCharSet = csUndefined{$ENDIF});
Var
 vTagGeral        : String;
Begin
 vTypeObject      := toDataset;
 vObjectDirection := odINOUT;
 vObjectValue     := ovDataSet;
 vtagName         := Lowercase(TableName);
 vEncoded         := EncodedValue;
 vTagGeral        := DatasetValues(bValue, DTSeparator, TMSeparator, DCSeparator);
 aValue           := ToBytes(vTagGeral);
End;

Function TJSONValue.ToJSON: String;
Var
 vTempValue : String;
Begin
 If vEncoded Then
  {$IFNDEF FPC}
  vTempValue := FormatValue({$IF CompilerVersion > 21}TEncoding.UTF8.GetString(TBytes(aValue))
                            {$ELSE}BytesToString(aValue){$IFEND})
  {$ELSE}
  vTempValue := FormatValue(BytesToString(TBytes(aValue)))
  {$ENDIF}
 Else
  vTempValue  := FormatValue(BytesArrToString(aValue));
 If Not(Pos('"TAGJSON":}', vTempValue) > 0) Then
  Result := vTempValue;
End;

Procedure TJSONValue.ToStream(Var bValue: TMemoryStream);
Begin
 If Length(aValue) > 0 Then
  Begin
   bValue := TMemoryStream.Create;
   bValue.Write(aValue[0], -1);
  End
 Else
  bValue := Nil;
End;

Function TJSONValue.Value: String;
Begin
 Result := GetValue;
End;

{$IF Defined(ANDROID) or Defined(IOS)} //Alterado para IOS Brito
Procedure TJSONValue.WriteToDataset(DatasetType : TDatasetType;
                                    JSONValue   : String;
                                    DestDS      : TDataset;
                                    DTSeparator : String = '/';
                                    TMSeparator : String = ':';
                                    DCSeparator : String = ',');
Var
 bJsonOBJ,
 bJsonArraySub,
 bJsonValue     : system.json.TJsonObject;
 bJsonOBJTemp,
 bJsonArray     : system.json.TJsonArray;
 A, J, I        : Integer;
 FieldDef       : TFieldDef;
 Field          : TField;
 vFindFlag      : Boolean;
 vBlobStream    : TStringStream;
 ListFields     : TStringList;
 //debug strings
 deb1, deb2     : String;
 Procedure SetValueA(Field : TField;
                     Value : String);
 Var
  vTempValue    : String;
 Begin
  Case Field.DataType Of
   ftUnknown,
   ftString,
   ftFixedChar,
   ftWideString : Begin
                   Field.AsString := Value;
                  End;
   ftAutoInc,
   ftSmallint,
   ftInteger,
   ftLargeint,
   ftWord,
   {$IFNDEF FPC}
    {$IF CompilerVersion > 21} // Delphi 2010 pra cima
    ftLongWord,
    {$IFEND}
   {$ENDIF}
   ftBoolean    : Begin
                   If Value <> '' Then
                    Begin
                     If Field.DataType = ftBoolean Then
                      Begin
                       If (Value = '0') Or (Value = '1') Then
                        Field.AsBoolean := StrToInt(Value) = 1
                       Else
                        Field.AsBoolean := lowercase(Value) = 'true';
                      End
                     Else
                      Field.AsInteger := StrToInt(Value);
                    End;
                  End;
   ftFloat,
   ftCurrency,
   ftBCD,
   ftFMTBcd     : Begin
                   vTempValue  := Value;
                   If (Pos('dc', vTempValue) > 0) or (Pos('.', vTempValue) > 0) or (Pos(',', vTempValue) > 0) Then
                   Begin
                    vTempValue := StringReplace(vTempValue, 'dc', DCSeparator, [rfReplaceAll]);
                    vTempValue := StringReplace(vTempValue, '.', DCSeparator, [rfReplaceAll]);
                    vTempValue := StringReplace(vTempValue, ',', DCSeparator, [rfReplaceAll]);
                   End;
                   If vTempValue <> '' Then
                    Begin
                     Case Field.DataType Of
                      ftFloat  : Field.AsFloat    := StrToFloat(vTempValue);
                      ftCurrency,
                      ftBCD,
                      ftFMTBcd : Field.AsCurrency := StrToFloat(vTempValue);
                      End;
                    End;
                  End;
   ftDate,
   ftTime,
   ftDateTime,
   ftTimeStamp  : Begin
                   vTempValue        := Value;
                   If (Pos('dt', vTempValue) > 0) or (Pos('-', vTempValue) > 0) or (Pos('/', vTempValue) > 0)Then
                   Begin
                    vTempValue       := StringReplace(vTempValue, 'dt', DTSeparator, [rfReplaceAll]);
                    vTempValue       := StringReplace(vTempValue, '-', DTSeparator, [rfReplaceAll]);
                    vTempValue       := StringReplace(vTempValue, '/', DTSeparator, [rfReplaceAll]);
                   End;
                   If Pos('ts', vTempValue) > 0 Then
                    vTempValue       := StringReplace(vTempValue, 'ts', TMSeparator, [rfReplaceAll]);
                   If vTempValue <> '' Then
                    Field.AsDateTime := StrToDateTime(vTempValue);
                  End;
  End;
 End;

 Function FieldIndex(FieldName: String): Integer;
 Var
  I : Integer;
 Begin
  Result := -1;
  For I := 0 To ListFields.Count - 1 Do
   Begin
    If Uppercase(ListFields[I]) = Uppercase(FieldName) Then
     Begin
      Result := I;
      Break;
     End;
   End;
 End;
Begin
 If JSONValue = '' Then
  Exit;
 ListFields := TStringList.Create;
 Try
  If Pos('[', JSONValue) = 0 Then
   Begin
    FreeAndNil(ListFields);
    Exit;
   End;

   deb1 := copy(jsonvalue, length(jsonvalue)-250, length(jsonvalue)-1);
   deb2 := copy(jsonvalue, 0, length(jsonvalue)-250);

  bJsonValue := TJsonObject.ParseJSONValue(JSONValue) as system.json.TJsonObject;
  If bJsonValue.count > 0 Then
   Begin
    vTypeObject      := GetObjectName(removestr(bJsonvalue.Pairs[0].JsonValue.tostring,'"') );       // GetObjectName       (bJsonValue.opt(bJsonValue.names.get(0).ToString).ToString);
    vObjectDirection := GetDirectionName(removestr(bjsonvalue.Pairs[1].JsonValue.tostring,'"'));      //GetDirectionName    (bJsonValue.opt(bJsonValue.names.get(1).ToString).ToString);
    vEncoded         := GetBooleanFromString( removestr(bJsonvalue.Pairs[2].JsonValue.tostring,'"')); //GetBooleanFromString(bJsonValue.opt(bJsonValue.names.get(2).ToString).ToString);
    vObjectValue     := GetValueType( removestr(bJsonvalue.Pairs[3].JsonValue.tostring,'"'));         //GetValueType        (bJsonValue.opt(bJsonValue.names.get(3).ToString).ToString);
    vtagName         := Lowercase ( removestr(bJsonvalue.Pairs[4].JsonString.tostring,'"'));           //   (bJsonValue.names.get(4).ToString);
    // Add Field Defs
    DestDS.DisableControls;
    If DestDS.Active Then
     DestDS.Close;
    If DestDS.FieldDefs.Count = 0 Then
     Begin
      bJsonArray    :=  bJsonValue.Pairs[4].JsonValue as tjsonarray; //  bJsonValue.optJSONArray   (bJsonValue.names.get(4).ToString);
      bJsonArraySub := bJsonArray.Items[0] as Tjsonobject; //  bJsonArray.optJSONObject  (0);
      bJsonArray    := bJsonArraySub.Pairs[0].JsonValue as Tjsonarray; // optJSONArray(bJsonArraySub.names.get(0).ToString);
      For J := 0 To bJsonArray.Count - 1 Do
       Begin
        bJsonOBJ := bJsonarray.Items[J] as Tjsonobject ; // Create(bJsonArray.get(J).ToString);
        Try
         If Trim(removestr(bJsonOBJ.Pairs[0].JsonValue.tostring,'"')) <> '' then // opt(bJsonOBJ.names.get(0).ToString).ToString) <> '' Then
          Begin
           If TRESTDWClientSQL(DestDS).FieldDefExist(removestr(bJsonOBJ.Pairs[0].JsonValue.tostring,'""')) = nil then // opt(bJsonOBJ.names.get(0).ToString).ToString) = Nil Then
            Begin
             FieldDef := TFieldDef.Create(DestDS.FieldDefs, removestr(bJsonOBJ.Pairs[0].JsonValue.tostring,'""'),
                                                            GetFieldType(removestr(bJsonOBJ.Pairs[1].JsonValue.tostring,'""')), //bJsonOBJ.opt(bJsonOBJ.names.get(1).ToString).ToString),
                                                            StrToInt(removestr(bJsonOBJ.Pairs[4].JsonValue.tostring,'""')), //bJsonOBJ.opt(bJsonOBJ.names.get(4).ToString).ToString),
                                                            Uppercase(removestr(bJsonOBJ.Pairs[3].JsonValue.tostring,'""'))='S', //bJsonOBJ.opt(bJsonOBJ.names.get(3).ToString).ToString) = 'S',
                                                            DestDS.FieldDefs.Count);
             If Not(FieldDef.DataType In [ftSmallint, ftInteger, ftFloat,
                                          ftCurrency, ftBCD,     ftFMTBcd]) Then
              Begin
               FieldDef.Size      := StrToInt(removestr(bJsonOBJ.Pairs[4].JsonValue.tostring,'""')); // bJsonOBJ.opt(bJsonOBJ.names.get(4).ToString).ToString);
               FieldDef.Precision := StrToInt(removestr(bJsonOBJ.Pairs[5].JsonValue.tostring,'""')); //bJsonOBJ.opt(bJsonOBJ.names.get(5).ToString).ToString);
              End;
            End;
          End;
        Finally
        // bJsonOBJ.Clean;
         FreeAndNil(bJsonOBJ);
        End;
       End;
     End
   {$IFDEF FPC}
    Else
     DestDS.FieldDefs.Update
   {$ENDIF};
    Try
     {$IFNDEF FPC}
     If DestDS Is TClientDataset Then
      TClientDataset(DestDS).CreateDataSet
     Else If DestDS Is TRESTDWClientSQL Then
      Begin
       TRESTDWClientSQL(DestDS).Inactive := True;
       DestDS.Open;
       TRESTDWClientSQL(DestDS).Active   := True;
       TRESTDWClientSQL(DestDS).Inactive := False;
      End
     Else
      DestDS.Open;
     {$ELSE}
     TRESTDWClientSQL(DestDS).Inactive   := True;
     If DestDS is TMemDataset Then
      TMemDataset(DestDS).CreateTable;
     DestDS.Open;
     TRESTDWClientSQL(DestDS).Active     := True;
     TRESTDWClientSQL(DestDS).Inactive   := False;
     {$ENDIF}
    Except
    End;
    //Add Set PK Fields
    bJsonArray    := bJsonValue.Pairs[4].JsonValue as Tjsonarray; //   bJsonValue.optJSONArray   (bJsonValue.names.get(4).ToString);
    bJsonArraySub := bJsonArray.Items[0] as Tjsonobject; //optJSONObject  (0);
    bJsonArray    := bJsonArraySub.Pairs[0].JsonValue as tjsonarray; // bJsonArraySub.optJSONArray(bJsonArraySub.names.get(0).ToString);
    For J := 0 To bJsonArray.Count - 1 Do
     Begin
      bJsonOBJ    := bJsonarray.Items[j] as Tjsonobject;; // Create(bJsonArray.get(J).ToString);
      Try
       If Uppercase(Trim(removestr(bJsonOBJ.Pairs[2].JsonValue.tostring,'"'))) = 'S' then //    bJsonOBJ.opt(bJsonOBJ.names.get(2).ToString).ToString)) = 'S' Then
        Begin
        // {$IFDEF RESJEDI}
         //  Field := TJvMemoryData(DestDS).FindField(bJsonOBJ.opt(bJsonOBJ.names.get(0).ToString).ToString);
         //{$ENDIF}
         {$IFDEF RESTKBMMEMTABLE}
           Field := Tkbmmemtable(DestDS).FindField(removestr(bJsonOBJ.Pairs[0].JsonValue.tostring,'"'));
         {$ENDIF}
         {$IFDEF RESTFDMEMTABLE}
           Field := TFDmemtable(DestDS).FindField(removestr(bJsonOBJ.Pairs[0].JsonValue.tostring,'"'));
         {$ENDIF}
         If Field <> Nil Then
          Begin
           If Field.FieldKind = fkData Then
            Field.ProviderFlags := [pfInUpdate, pfInWhere, pfInKey]
           Else
            Field.ProviderFlags := [];
          End;
         {$IFNDEF FPC}{$IF CompilerVersion > 21}
         If bJsonOBJ.Count > 6 then // names.Length > 6 Then
          Begin
           If (Uppercase(Trim( removestr(bJsonOBJ.Pairs[6].JsonValue.tostring,'"' ))) = 'S') then //  bJsonOBJ.opt(bJsonOBJ.names.get(6).ToString).ToString)) = 'S') Then
            Field.AutoGenerateValue := arAutoInc;
          End;
         {$IFEND}
         {$ENDIF}
        End;
      Finally
       //bJsonOBJ.Clean;
       FreeAndNil(bJsonOBJ);
      End;
     End;
    For A := 0 To DestDS.Fields.Count - 1 Do
     Begin
      vFindFlag := False;
      If DestDS.Fields[A].FieldKind = fkData Then
       Begin
        For J := 0 To bJsonArray.count - 1 Do
         Begin
          bJsonOBJ := bJsonArray.Items[J] as Tjsonobject;  //uDWJSON.TJsonObject.Create(bJsonArray.get(J).ToString);
          If Trim(removestr(bJsonOBJ.Pairs[0].JsonValue.tostring,'"' )) <> '' then //    bJsonOBJ.opt(bJsonOBJ.names.get(0).ToString).ToString) <> '' Then
           Begin
            vFindFlag := Uppercase(Trim(removestr(bJsonOBJ.Pairs[0].JsonValue.tostring,'"' ))) = Uppercase(DestDS.Fields[A].FieldName); // bJsonOBJ.opt(bJsonOBJ.names.get(0).ToString).ToString)) = Uppercase(DestDS.Fields[A].FieldName);
            If vFindFlag Then
             Begin
              // If bJsonOBJ.names.Length > 6 Then
             //  If Not (DestDS.Fields[A].ReadOnly) Then
             //   DestDS.Fields[A].ReadOnly := (Uppercase(Trim(removestr(bJsonOBJ.opt(bJsonOBJ.Pairs[0].JsonValue.ToString,'"'))) = 'S');
              ListFields.Add(IntToStr(J));
              Break;
             End;
           End;
          //bJsonOBJ.Clean;
          FreeAndNil(bJsonOBJ);
         End;
       End;
      If Assigned(bJsonOBJ) Then
       Begin
        //bJsonOBJ.Clean;
        FreeAndNil(bJsonOBJ);
       End;
      If Not vFindFlag Then
       ListFields.Add('-1');
     End;
    bJsonArray    := bJsonValue.Pairs[4].JsonValue as Tjsonarray;  // bJsonValue.optJSONArray(bJsonValue.names.get(4).ToString);
    bJsonArraySub := bJsonarray.Items[1] as Tjsonobject; //    bJsonArray.optJSONObject(1);
    bJsonArray    := bJsonArraySub.Pairs[0].JsonValue as Tjsonarray; //   bJsonArraySub.optJSONArray(bJsonArraySub.names.get(0).ToString);
    If DestDS Is TRESTDWClientSQL Then
     TRESTDWClientSQL(DestDS).InBlockEvents := True;
    For J := 0 To bJsonArray.count - 1 Do
     Begin
      bJsonOBJ     := bJsonArray.Items[J] as Tjsonobject; //  uDWJSON.TJsonObject.Create(bJsonArray.get(J).ToString);
      bJsonOBJTemp := bJsonOBJ.Pairs[0].JsonValue as tJsonarray; //   bJsonOBJ.optJSONArray(bJsonOBJ.names.get(0).ToString);
      DestDS.Append;
      Try
       For I := 0 To DestDS.Fields.Count - 1 Do
        Begin
         If (StrToInt(ListFields[I]) = -1) Or Not(DestDS.Fields[I].FieldKind = fkData) Then
          Continue;
         If DestDS.Fields[I].DataType In [ftGraphic,     ftParadoxOle, ftDBaseOle,
                                          ftTypedBinary, ftCursor,     ftDataSet,
                                          ftBlob,        ftOraBlob,    ftOraClob
                                          {$IFNDEF FPC}{$IF CompilerVersion > 21},
                                          ftParams, ftStream{$IFEND}{$ENDIF}] Then
          Begin
           If vEncoded Then
            HexStringToStream(bJsonOBJTemp.get(StrToInt(ListFields[I])).ToString, vBlobStream)
           Else
            vBlobStream := TStringStream.Create(bJsonOBJTemp.get(StrToInt(ListFields[I])).ToString);
           Try
            vBlobStream.Position := 0;
            TBlobField(DestDS.Fields[I]).LoadFromStream(vBlobStream);
           Finally
            {$IFNDEF FPC}
            {$IF CompilerVersion > 21}
             vBlobStream.Clear;
            {$IFEND}
            {$ENDIF}
            FreeAndNil(vBlobStream);
           End;
          End
         Else
          Begin
           If (Lowercase(removestr(bJsonOBJTemp.Items[StrToInt(ListFields[I])].Value,'"')) <> 'null') then // get(StrToInt(ListFields[I])).ToString) <> 'null') Then
            Begin
             If DestDS.Fields[I].DataType in [ftString, ftWideString,
                                              {$IFNDEF FPC}{$IF CompilerVersion > 21}ftWideMemo, {$IFEND}{$ENDIF}
                                              ftMemo, ftFmtMemo, ftFixedChar] Then
              Begin
               If removestr(bJsonOBJTemp.Items[StrToInt(ListFields[I])].Value,'"') = '' then // bJsonOBJTemp.get(StrToInt(ListFields[I])).ToString = '' Then
                DestDS.Fields[I].Value := ''
               Else
                Begin
                 If vEncoded Then
                  DestDS.Fields[I].AsString := DecodeStrings(removestr(bJsonOBJTemp.Items[StrToInt(ListFields[I])].Value,'"')) //bJsonOBJTemp.get(StrToInt(ListFields[I])).ToString)
                 Else
                  DestDS.Fields[I].AsString := removestr(bJsonOBJTemp.Items[StrToInt(ListFields[I])].Value,'"'); // bJsonOBJTemp.get(StrToInt(ListFields[I])).ToString;
                End;
              End
             Else if removestr(bJsonOBJTemp.Items[StrToInt(ListFields[I])].Value,'"') <> '' then // (bJsonOBJTemp.get(StrToInt(ListFields[I])).ToString <> '') then
              Begin
               {$IFNDEF FPC}
               SetValueA(DestDS.Fields[I], removestr(bJsonOBJTemp.Items[StrToInt(ListFields[I])].Value,'"')); //bJsonOBJTemp.get(StrToInt(ListFields[I])).ToString);
               {$ELSE}
               SetValueA(DestDS.Fields[I], removestr(bJsonOBJTemp.Items[StrToInt(ListFields[I])].Value,'"')); // bJsonOBJTemp.get(StrToInt(ListFields[I])).ToString);
               {$ENDIF}
              End;
            End;
          End;
        End;
      Finally
       If Assigned(bJsonOBJ) Then
        Begin
         //bJsonOBJ.Clean;
         FreeAndNil(bJsonOBJ);
        End;
      End;
      DestDS.Post;
     End;
   End
  Else
   Begin
    DestDS.Close;
    Raise Exception.Create('Invalid JSON Data...');
   End;
 Finally
  If DestDS Is TRESTDWClientSQL Then
   TRESTDWClientSQL(DestDS).InBlockEvents := False;
  //bJsonValue.Clean;
  FreeAndNil(bJsonValue);
  ListFields.Free;
  If DestDS.Active Then
   DestDS.First;
  DestDS.EnableControls;
 End;
End;
{$ELSE}

Procedure TJSONValue.WriteToDataset(DatasetType : TDatasetType;
                                    JSONValue   : String;
                                    DestDS      : TDataset;
                                    DTSeparator : String = '/';
                                    TMSeparator : String = ':';
                                    DCSeparator : String = ','{$IFDEF FPC};
                                    CharSet     : TDatabaseCharSet = csUndefined{$ENDIF});
Var
 bJsonOBJ,
 bJsonArraySub,
 bJsonValue     : udwjson.TJsonObject;
 bJsonOBJTemp,
 bJsonArray     : udwjson.TJsonArray;
 A, J, I        : Integer;
 FieldDef       : TFieldDef;
 Field          : TField;
 vOldReadOnly,
 vFindFlag      : Boolean;
 vBlobStream    : TStringStream;
 ListFields     : TStringList;
 Procedure SetValueA(Field : TField;
                     Value : String);
 Var
  vTempValue    : String;
 Begin
  Case Field.DataType Of
   ftUnknown,
   ftString,
   ftFixedChar,
   ftWideString : Begin
                   Field.AsString := Value;
                  End;
   ftAutoInc,
   ftSmallint,
   ftInteger,
   ftLargeint,
   ftWord,
   {$IFNDEF FPC}
    {$IF CompilerVersion > 21} // Delphi 2010 pra cima
    ftLongWord,
    {$IFEND}
   {$ENDIF}
   ftBoolean    : Begin
                   If Value <> '' Then
                    Begin
                     If Field.DataType = ftBoolean Then
                      Begin
                       If (Value = '0') Or (Value = '1') Then
                        Field.AsBoolean := StrToInt(Value) = 1
                       Else
                        Field.AsBoolean := lowercase(Value) = 'true';
                      End
                     Else
                      Field.AsInteger := StrToInt(Value);
                    End;
                  End;
                  ftFloat,
                  ftCurrency,
                  ftBCD,
                  ftFMTBcd     : Begin
                                  vTempValue  := Value;
                                  If (Pos('dc', vTempValue) > 0) or (Pos('.', vTempValue) > 0) or (Pos(',', vTempValue) > 0) Then
                                  Begin
                                   vTempValue := StringReplace(vTempValue, 'dc', DCSeparator, [rfReplaceAll]);
                                   vTempValue := StringReplace(vTempValue, '.', DCSeparator, [rfReplaceAll]);
                                   vTempValue := StringReplace(vTempValue, ',', DCSeparator, [rfReplaceAll]);
                                  End;
                                  If vTempValue <> '' Then
                                   Begin
                                    Case Field.DataType Of
                                     ftFloat  : Field.AsFloat    := StrToFloat(vTempValue);
                                     ftCurrency,
                                     ftBCD,
                                     ftFMTBcd : Field.AsCurrency := StrToFloat(vTempValue);
                                     End;
                                   End;
                                 End;
                  ftDate,
                  ftTime,
                  ftDateTime,
                  ftTimeStamp  : Begin
                                  vTempValue        := Value;
                                  If (Pos('dt', vTempValue) > 0) or (Pos('-', vTempValue) > 0) or (Pos('/', vTempValue) > 0)Then
                                  Begin
                                   vTempValue       := StringReplace(vTempValue, 'dt', DTSeparator, [rfReplaceAll]);
                                   vTempValue       := StringReplace(vTempValue, '-', DTSeparator, [rfReplaceAll]);
                                   vTempValue       := StringReplace(vTempValue, '/', DTSeparator, [rfReplaceAll]);
                                  End;
                                  If Pos('ts', vTempValue) > 0 Then
                                   vTempValue       := StringReplace(vTempValue, 'ts', TMSeparator, [rfReplaceAll]);
                                  If vTempValue <> '' Then
                                   Field.AsDateTime := StrToDateTime(vTempValue);
                                 End;
  End;
 End;
 Function FieldIndex(FieldName: String): Integer;
 Var
  I : Integer;
 Begin
  Result := -1;
  For I := 0 To ListFields.Count - 1 Do
   Begin
    If Uppercase(ListFields[I]) = Uppercase(FieldName) Then
     Begin
      Result := I;
      Break;
     End;
   End;
 End;
Begin
 If JSONValue = '' Then
  Exit;
 ListFields := TStringList.Create;
 Try
  If Pos('[', JSONValue) = 0 Then
   Begin
    FreeAndNil(ListFields);
    Exit;
   End;
  bJsonValue := udwjson.TJsonObject.Create(JSONValue);
  If bJsonValue.names.Length > 0 Then
   Begin
    vTypeObject      := GetObjectName       (bJsonValue.opt(bJsonValue.names.get(0).ToString).ToString);
    vObjectDirection := GetDirectionName    (bJsonValue.opt(bJsonValue.names.get(1).ToString).ToString);
    vEncoded         := GetBooleanFromString(bJsonValue.opt(bJsonValue.names.get(2).ToString).ToString);
    vObjectValue     := GetValueType        (bJsonValue.opt(bJsonValue.names.get(3).ToString).ToString);
    vtagName         := Lowercase           (bJsonValue.names.get(4).ToString);
    // Add Field Defs
    DestDS.DisableControls;
    If DestDS.Active Then
     DestDS.Close;
    {$IFNDEF FPC}
     DestDS.FieldDefs.Clear;
    {$ENDIF}
    If DestDS.FieldDefs.Count = 0 Then
     Begin
      bJsonArray    := bJsonValue.optJSONArray   (bJsonValue.names.get(4).ToString);
      bJsonArraySub := bJsonArray.optJSONObject  (0);
      bJsonArray    := bJsonArraySub.optJSONArray(bJsonArraySub.names.get(0).ToString);
      For J := 0 To bJsonArray.Length - 1 Do
       Begin
        bJsonOBJ := udwjson.TJsonObject.Create(bJsonArray.get(J).ToString);
        Try
         If Trim(bJsonOBJ.opt(bJsonOBJ.names.get(0).ToString).ToString) <> '' Then
          Begin
           If TRESTDWClientSQL(DestDS).FieldDefExist(bJsonOBJ.opt(bJsonOBJ.names.get(0).ToString).ToString) = Nil Then
            Begin
             FieldDef := TFieldDef.Create(DestDS.FieldDefs, bJsonOBJ.opt(bJsonOBJ.names.get(0).ToString).ToString,
                                                            GetFieldType(bJsonOBJ.opt(bJsonOBJ.names.get(1).ToString).ToString),
                                                            StrToInt(bJsonOBJ.opt(bJsonOBJ.names.get(4).ToString).ToString),
                                                            Uppercase(bJsonOBJ.opt(bJsonOBJ.names.get(3).ToString).ToString) = 'S',
                                                            DestDS.FieldDefs.Count);
             If Not(FieldDef.DataType In [ftSmallint, ftInteger, ftFloat,
                                          ftCurrency, ftBCD,     ftFMTBcd]) Then
              Begin
               FieldDef.Size      := StrToInt(bJsonOBJ.opt(bJsonOBJ.names.get(4).ToString).ToString);
               FieldDef.Precision := StrToInt(bJsonOBJ.opt(bJsonOBJ.names.get(5).ToString).ToString);
              End;
            End;
          End;
        Finally
         bJsonOBJ.Clean;
         FreeAndNil(bJsonOBJ);
        End;
       End;
     End
   {$IFDEF FPC}
    Else
     DestDS.FieldDefs.Update
   {$ENDIF};
    Try
     {$IFNDEF FPC}
     If DestDS Is TClientDataset Then
      TClientDataset(DestDS).CreateDataSet
     Else If DestDS Is TRESTDWClientSQL Then
      Begin
       TRESTDWClientSQL(DestDS).Inactive := True;
       DestDS.Open;
       TRESTDWClientSQL(DestDS).Active   := True;
       TRESTDWClientSQL(DestDS).Inactive := False;
      End
     Else
      DestDS.Open;
     {$ELSE}
     TRESTDWClientSQL(DestDS).Inactive   := True;
     If DestDS is TMemDataset Then
      TMemDataset(DestDS).CreateTable;
     DestDS.Open;
     TRESTDWClientSQL(DestDS).Active     := True;
     TRESTDWClientSQL(DestDS).Inactive   := False;
     {$ENDIF}
    Except
    End;
   {$IFNDEF FPC}
    //Clean Invalid Fields
    bJsonArray    := bJsonArraySub.optJSONArray(bJsonArraySub.names.get(0).ToString);
    For A := TRESTDWClientSQL(DestDS).Fields.Count -1 DownTo 0 Do
     Begin
      If TRESTDWClientSQL(DestDS).Fields[A].FieldKind = fkData Then
       Begin
        vFindFlag := False;
        For J := 0 To bJsonArray.Length - 1 Do
         Begin
          bJsonOBJ := udwjson.TJsonObject.Create(bJsonArray.get(J).ToString);
          Try
           If Trim(bJsonOBJ.opt(bJsonOBJ.names.get(0).ToString).ToString) <> '' Then
            Begin
             vFindFlag := Lowercase(bJsonOBJ.opt(bJsonOBJ.names.get(0).ToString).ToString) =
                          Lowercase(TRESTDWClientSQL(DestDS).Fields[A].FieldName);
             If vFindFlag Then
              Break;
            End;
          Finally
           bJsonOBJ.Clean;
           FreeAndNil(bJsonOBJ);
          End;
         End;
        If Not vFindFlag Then
         TRESTDWClientSQL(DestDS).Fields.Remove(TRESTDWClientSQL(DestDS).Fields[A]);
       End;
     End;
    {$ENDIF}
    //Add Set PK Fields
    bJsonArray    := bJsonValue.optJSONArray   (bJsonValue.names.get(4).ToString);
    bJsonArraySub := bJsonArray.optJSONObject  (0);
    bJsonArray    := bJsonArraySub.optJSONArray(bJsonArraySub.names.get(0).ToString);
    For J := 0 To bJsonArray.Length - 1 Do
     Begin
      bJsonOBJ    := udwjson.TJsonObject.Create(bJsonArray.get(J).ToString);
      Try
       If Uppercase(Trim(bJsonOBJ.opt(bJsonOBJ.names.get(2).ToString).ToString)) = 'S' Then
        Begin
         {$IFDEF FPC}
         Field := TMemDataset(DestDS).FindField  (bJsonOBJ.opt(bJsonOBJ.names.get(0).ToString).ToString);
         {$ELSE}
         {$IFDEF RESJEDI}
           Field := TJvMemoryData(DestDS).FindField(bJsonOBJ.opt(bJsonOBJ.names.get(0).ToString).ToString);
         {$ENDIF}
         {$IFDEF RESTKBMMEMTABLE}
           Field := Tkbmmemtable(DestDS).FindField(bJsonOBJ.opt(bJsonOBJ.names.get(0).ToString).ToString);
         {$ENDIF}
         {$IFDEF RESTFDMEMTABLE}
           Field := TFDmemtable(DestDS).FindField(bJsonOBJ.opt(bJsonOBJ.names.get(0).ToString).ToString);
         {$ENDIF}
         {$ENDIF}
         If Field <> Nil Then
          Begin
           If Field.FieldKind = fkData Then
            Field.ProviderFlags := [pfInUpdate, pfInWhere, pfInKey]
           Else
            Field.ProviderFlags := [];
           {$IFNDEF FPC}{$IF CompilerVersion > 21}
           If bJsonOBJ.names.Length > 6 Then
            Begin
             //Set ReadOnlyProp
             If (Uppercase(Trim(bJsonOBJ.opt(bJsonOBJ.names.get(7).ToString).ToString)) = 'S') Then
              Field.AutoGenerateValue := arAutoInc;
            End;
           {$IFEND}
           {$ENDIF}
          End;
        End;
      Finally
       bJsonOBJ.Clean;
       FreeAndNil(bJsonOBJ);
      End;
     End;
    For A := 0 To DestDS.Fields.Count - 1 Do
     Begin
      vFindFlag := False;
      If DestDS.Fields[A].FieldKind = fkData Then
       Begin
        For J := 0 To bJsonArray.Length - 1 Do
         Begin
          bJsonOBJ := uDWJSON.TJsonObject.Create(bJsonArray.get(J).ToString);
          If Trim(bJsonOBJ.opt(bJsonOBJ.names.get(0).ToString).ToString) <> '' Then
           Begin
            vFindFlag := Uppercase(Trim(bJsonOBJ.opt(bJsonOBJ.names.get(0).ToString).ToString)) = Uppercase(DestDS.Fields[A].FieldName);
            If vFindFlag Then
             Begin
             // If bJsonOBJ.names.Length > 6 Then
             //  If Not (DestDS.Fields[A].ReadOnly) Then
             //   DestDS.Fields[A].ReadOnly := (Uppercase(Trim(bJsonOBJ.opt(bJsonOBJ.names.get(6).ToString).ToString)) = 'S');
              ListFields.Add(IntToStr(J));
              Break;
             End;
           End;
          bJsonOBJ.Clean;
          FreeAndNil(bJsonOBJ);
         End;
       End;
      If Assigned(bJsonOBJ) Then
       Begin
        bJsonOBJ.Clean;
        FreeAndNil(bJsonOBJ);
       End;
      If Not vFindFlag Then
       ListFields.Add('-1');
     End;
    bJsonArray    := bJsonValue.optJSONArray(bJsonValue.names.get(4).ToString);
    bJsonArraySub := bJsonArray.optJSONObject(1);
    bJsonArray    := bJsonArraySub.optJSONArray(bJsonArraySub.names.get(0).ToString);
    If DestDS Is TRESTDWClientSQL Then
     TRESTDWClientSQL(DestDS).InBlockEvents := True;
    For J := 0 To bJsonArray.Length - 1 Do
     Begin
      bJsonOBJ     := uDWJSON.TJsonObject.Create(bJsonArray.get(J).ToString);
      bJsonOBJTemp := bJsonOBJ.optJSONArray(bJsonOBJ.names.get(0).ToString);
      DestDS.Append;
      Try
       For I := 0 To DestDS.Fields.Count - 1 Do
        Begin
         vOldReadOnly := DestDS.Fields[I].ReadOnly;
         DestDS.Fields[I].ReadOnly := False;
         If (StrToInt(ListFields[I]) = -1) Or Not(DestDS.Fields[I].FieldKind = fkData) Then
          Begin
           DestDS.Fields[I].ReadOnly := vOldReadOnly;
           Continue;
          End;
         If DestDS.Fields[I].DataType In [ftGraphic,     ftParadoxOle, ftDBaseOle,
                                          ftTypedBinary, ftCursor,     ftDataSet,
                                          ftBlob,        ftOraBlob,    ftOraClob
                                          {$IFNDEF FPC}{$IF CompilerVersion > 21},
                                          ftParams, ftStream{$IFEND}{$ENDIF}] Then
          Begin
           If vEncoded Then
            HexStringToStream(bJsonOBJTemp.get(StrToInt(ListFields[I])).ToString, vBlobStream)
           Else
            vBlobStream := TStringStream.Create(bJsonOBJTemp.get(StrToInt(ListFields[I])).ToString);
           Try
            vBlobStream.Position := 0;
            TBlobField(DestDS.Fields[I]).LoadFromStream(vBlobStream);
           Finally
            {$IFNDEF FPC}
            {$IF CompilerVersion > 21}
             vBlobStream.Clear;
            {$IFEND}
            {$ENDIF}
            FreeAndNil(vBlobStream);
           End;
          End
         Else
          Begin
           If (Lowercase(bJsonOBJTemp.get(StrToInt(ListFields[I])).ToString) <> 'null') Then
            Begin
             If DestDS.Fields[I].DataType in [ftString, ftWideString,
                                              {$IFNDEF FPC}{$IF CompilerVersion > 21}ftWideMemo, {$IFEND}{$ENDIF}
                                              ftMemo, ftFmtMemo, ftFixedChar] Then
              Begin
               If bJsonOBJTemp.get(StrToInt(ListFields[I])).ToString = '' Then
                DestDS.Fields[I].Value := ''
               Else
                Begin
                 If vEncoded Then
                  DestDS.Fields[I].AsString := DecodeStrings(bJsonOBJTemp.get(StrToInt(ListFields[I])).ToString{$IFDEF FPC}, vDatabaseCharSet{$ENDIF})
                 Else
                  DestDS.Fields[I].AsString := bJsonOBJTemp.get(StrToInt(ListFields[I])).ToString;
                End;
              End
             Else if (bJsonOBJTemp.get(StrToInt(ListFields[I])).ToString <> '') then
              Begin
               {$IFNDEF FPC}
               SetValueA(DestDS.Fields[I], bJsonOBJTemp.get(StrToInt(ListFields[I])).ToString);
               {$ELSE}
               SetValueA(DestDS.Fields[I], bJsonOBJTemp.get(StrToInt(ListFields[I])).ToString);
               {$ENDIF}
              End;
            End;
          End;
         DestDS.Fields[I].ReadOnly := vOldReadOnly;
        End;
      Finally
       If Assigned(bJsonOBJ) Then
        Begin
         bJsonOBJ.Clean;
         FreeAndNil(bJsonOBJ);
        End;
      End;
      DestDS.Post;
     End;
   End
  Else
   Begin
    DestDS.Close;
    Raise Exception.Create('Invalid JSON Data...');
   End;
 Finally
  If DestDS Is TRESTDWClientSQL Then
   TRESTDWClientSQL(DestDS).InBlockEvents := False;
  bJsonValue.Clean;
  FreeAndNil(bJsonValue);
  ListFields.Free;
  If DestDS.Active Then
   DestDS.First;
  DestDS.EnableControls;
 End;
End;
{$IFEND}

Procedure TJSONValue.SaveToStream(Stream: TMemoryStream);
Begin
 Try
  Stream.Write(aValue[0], Length(aValue));
 Finally
  Stream.Position := 0;
 End;
End;


{$IF Defined(ANDROID) OR Defined(IOS)} //Alterado para IOS Brito
Procedure TJSONValue.LoadFromJSON(bValue: String);
Var
 bJsonValue    : system.json.TJsonObject;
 vTempValue    : String;
 vStringStream : TMemoryStream;
Begin
 bJsonValue := TJsonObject.ParseJSONValue(bValue) as system.json.TJsonObject;
 Try
  If bJsonValue.count > 0 Then
   Begin
    vTempValue       := CopyValue(bValue);
    vTypeObject      := GetObjectName(removestr(bJsonvalue.Pairs[0].Jsonvalue.tostring,'"') ); //bJsonValue.opt(bJsonValue.names.get(0).ToString).ToString);
    vObjectDirection := GetDirectionName(removestr(bjsonvalue.Pairs[1].JsonValue.tostring,'"')); // bJsonValue.opt(bJsonValue.names.get(1).ToString).ToString);
    vObjectValue     := GetValueType( removestr(bJsonvalue.Pairs[3].JsonValue.tostring,'"')); //bJsonValue.opt(bJsonValue.names.get(3).ToString).ToString);
    vtagName         := Lowercase(removestr(bJsonvalue.Pairs[4].Jsonstring.tostring,'"')); // bJsonValue.names.get(4).ToString);
    If vTypeObject = toDataset Then
     Begin
      If vTempValue[InitStrPos] = '[' Then
       vTempValue:= vTempValue.Remove(Initstrpos,1); // Delete(vTempValue, InitStrPos, 1);
      If vTempValue[Length(vTempValue)-1] = ']' Then
       vTempValue:= vTempValue.Remove(Length(vTempValue)-1,1); //Delete(vTempValue, Length(vTempValue), 1);
     End;
    If vEncoded Then
     Begin
      If vObjectValue In [ovBytes, ovVarBytes, ovBlob, ovGraphic, ovOraBlob, ovOraClob] Then
       Begin
        vStringStream := TMemoryStream.Create;
        Try
         HexToStream(vTempValue, vStringStream);
         aValue := TIdBytes(StreamToBytes(vStringStream));
        Finally
         vStringStream.Free;
        End;
       End
      Else
       vTempValue := DecodeStrings(vTempValue);
     End;
    If Not(vObjectValue In [ovBytes,   ovVarBytes, ovBlob,
                            ovGraphic, ovOraBlob,  ovOraClob]) Then
     SetValue(vTempValue, vEncoded)
    Else
     Begin
      vStringStream := TMemoryStream.Create;
      Try
       HexToStream(vTempValue, vStringStream);
       aValue := TIdBytes(StreamToBytes(vStringStream));
      Finally
       FreeAndNil(vStringStream);
      End;
     End;
   End;
 Finally
  bJsonValue.Free;
 End;
End;

{$ELSE}
Procedure TJSONValue.LoadFromJSON(bValue: String);
Var
 bJsonValue    : udwjson.TJsonObject;
 vTempValue    : String;
 vStringStream : TMemoryStream;
Begin
 bJsonValue := udwjson.TJsonObject.Create(bValue);
 Try
  If bJsonValue.names.Length > 0 Then
   Begin
    vNullValue       := False;
    vTempValue       := CopyValue(bValue);
    vTypeObject      := GetObjectName(bJsonValue.opt(bJsonValue.names.get(0).ToString).ToString);
    vObjectDirection := GetDirectionName(bJsonValue.opt(bJsonValue.names.get(1).ToString).ToString);
    vObjectValue     := GetValueType(bJsonValue.opt(bJsonValue.names.get(3).ToString).ToString);
    vtagName         := Lowercase(bJsonValue.names.get(4).ToString);
    If vTypeObject = toDataset Then
     Begin
      If vTempValue[InitStrPos] = '[' Then
       Delete(vTempValue, InitStrPos, 1);
      If vTempValue[Length(vTempValue)] = ']' Then
       Delete(vTempValue, Length(vTempValue), 1);
     End;
    If vEncoded Then
     Begin
      If vObjectValue In [ovBytes, ovVarBytes, ovBlob, ovGraphic, ovOraBlob, ovOraClob] Then
       Begin
        vStringStream := TMemoryStream.Create;
        Try
         HexToStream(vTempValue, vStringStream);
         aValue := TIdBytes(StreamToBytes(vStringStream));
        Finally
         vStringStream.Free;
        End;
       End
      Else
       vTempValue := DecodeStrings(vTempValue{$IFDEF FPC}, vDatabaseCharSet{$ENDIF});
     End;
    If Not(vObjectValue In [ovBytes,   ovVarBytes, ovBlob,
                            ovGraphic, ovOraBlob,  ovOraClob]) Then
     SetValue(vTempValue, vEncoded)
    Else
     Begin
      vStringStream := TMemoryStream.Create;
      Try
       HexToStream(vTempValue, vStringStream);
       aValue := TIdBytes(StreamToBytes(vStringStream));
      Finally
       FreeAndNil(vStringStream);
      End;
     End;
   End;
 Finally
  bJsonValue.Free;
 End;
End;
{$IFEND}

Procedure TJSONValue.LoadFromStream(Stream : TMemoryStream;
                                    Encode : Boolean = True);
Begin
 ObjectValue := ovBlob;
 SetValue(StreamToHex(Stream), Encode);
End;

Procedure TJSONValue.SetValue      (Value  : String;
                                    Encode : Boolean);
Begin
 vBinary := False;
 vEncoded := Encode;
 vNullValue := False;
 If Encode Then
  Begin
   If vObjectValue in [ovBytes,   ovVarBytes, ovBlob,
                       ovGraphic, ovOraBlob,  ovOraClob] Then
    WriteValue(Value)
   Else
    WriteValue(EncodeStrings(Value{$IFDEF FPC}, vDatabaseCharSet{$ENDIF}))
  End
 Else
  WriteValue(Value);
End;

Procedure TJSONValue.WriteValue(bValue: String);
Begin
 SetLength(aValue, 0);
 If vObjectValue in [ovString, ovMemo, ovWideMemo, ovFmtMemo] Then
  Begin
   If vEncoded Then
    Begin
     {$IFDEF FPC}
     aValue := ToBytes(Format(TJsonStringValue, [bValue]));
     {$ELSE}
     {$IF CompilerVersion > 21}
     aValue := ToBytes(Format(TJsonStringValue, [bValue])); //TIdBytes(vEncoding.GetBytes(Format(TJsonStringValue, [bValue])));
     {$ELSE}
     aValue := ToBytes(Format(TJsonStringValue, [bValue]));
     {$IFEND}
     {$ENDIF}
    End
   Else
    aValue := ToBytes(Format(TJsonStringValue, [bValue]));
  End
 Else
  Begin
   {$IFNDEF FPC}
   {$IF CompilerVersion > 21}
   aValue := ToBytes(Format(TJsonValueFormat, [bValue])); //ToBytes(bValue); // tIdBytes(vEncoding.GetBytes(bValue));
   {$ELSE}
   aValue := ToBytes(bValue);
   {$IFEND}
   {$ELSE}
   aValue := ToBytes(bValue);
   {$ENDIF}
  End;
End;

Constructor TJSONParam.Create{$IFNDEF FPC}{$IF CompilerVersion > 21}(Encoding: TEncoding){$IFEND}{$ENDIF};
Begin
 vJSONValue := TJSONValue.Create;
 {$IFNDEF FPC}
 {$IF CompilerVersion > 21}
  vEncoding := Encoding;
 {$IFEND}
 {$ENDIF}
 vTypeObject := toParam;
 ObjectDirection := odINOUT;
 vObjectValue := ovString;
 vBinary := False;
 vJSONValue.vBinary := vBinary;
End;

Destructor TJSONParam.Destroy;
Begin
 FreeAndNil(vJSONValue);
 Inherited;
End;

Procedure TJSONParam.LoadFromParam(Param: TParam);
Var
 MemoryStream : TMemoryStream;
Begin
 If Param.DataType      in [ftString, ftWideString, ftMemo,
                            {$IFNDEF FPC}{$IF CompilerVersion > 21}ftWideMemo,
                            {$IFEND}{$ENDIF}
                            ftFmtMemo, ftFixedChar] Then
  Begin
   vEncoded := true;
   SetValue(Param.AsString, vEncoded);
  End
 Else If Param.DataType in [{$IFNDEF FPC}{$IF CompilerVersion > 21}ftExtended,
                            {$IFEND}{$ENDIF}ftInteger, ftSmallint, ftFloat,
                            ftCurrency, ftFMTBcd, ftBCD] Then
  SetValue(Param.AsString, False)
 Else If Param.DataType In [ftBytes, ftVarBytes, ftBlob, ftGraphic, ftOraBlob, ftOraClob] Then
  Begin
   MemoryStream := TMemoryStream.Create;
   Try
    {$IFDEF FPC}
    Param.SetData(MemoryStream);
    {$ELSE}
    {$IF CompilerVersion > 21}
    MemoryStream.CopyFrom(Param.AsStream, Param.AsStream.Size);
    {$ELSE}
    Param.SetData(MemoryStream);
    {$IFEND}
    {$ENDIF}
    LoadFromStream(MemoryStream);
   Finally
    MemoryStream.Free;
   End;
  End
 Else If Param.DataType in [ftDate, ftTime, ftDateTime, ftTimeStamp] Then
  SetValue(Param.AsString, False);
 vObjectValue            := FieldTypeToObjectValue(Param.DataType);
 vJSONValue.vObjectValue := vObjectValue;
End;

Procedure TJSONParam.LoadFromStream(Stream: TMemoryStream; Encode: Boolean);
Begin
 ObjectValue := ovBlob;
 vBinary := False;
 SetValue(StreamToHex(Stream), False);
End;

{$IF (NOT Defined(FPC) AND Defined(LINUX))} //Alteardo para Lazarus LINUX Brito
Procedure TJSONParam.FromJSON(JSON: String);
Var
 bJsonValue : system.json.TJsonObject;
 vValue     : String;
Begin
 bJsonValue := TJSONObject.ParseJSONValue(JSON) as TJSONObject;
 Try
  vValue := CopyValue(JSON);
  If bJsonValue.count > 0 Then
   Begin
    vTypeObject      := GetObjectName(removestr(bJsonValue.pairs[0].jsonvalue.tostring,'"'));        //  GetObjectName(bJsonValue.opt(bJsonValue.names.get(0).ToString).ToString);
    vObjectDirection := GetDirectionName(removestr(bJsonValue.pairs[1].jsonvalue.tostring,'"'));     //bJsonValue.opt(bJsonValue.names.get(1).ToString).ToString);
    vEncoded         := GetBooleanFromString(removestr(bJsonValue.pairs[2].jsonvalue.tostring,'"')); //bJsonValue.opt(bJsonValue.names.get(2).ToString).ToString);
    vObjectValue     := GetValueType(removestr(bJsonValue.pairs[3].jsonvalue.tostring,'"')); //bJsonValue.opt(bJsonValue.names.get(3).ToString).ToString);
    vParamName       := Lowercase(removestr(bJsonValue.pairs[4].jsonstring.tostring,'"')); //bJsonValue.names.get(4).ToString);
    WriteValue(vValue);
   End;
 Finally
  bJsonValue.Free;
 End;
End;
{$ELSE}
Procedure TJSONParam.FromJSON(JSON: String);
Var
 bJsonValue : udwjson.TJsonObject;
 vValue     : String;
Begin
 bJsonValue := uDWJSON.TJsonObject.Create(JSON);
 Try
  vValue := CopyValue(JSON);
  If bJsonValue.names.Length > 0 Then
   Begin
    vTypeObject      := GetObjectName(bJsonValue.opt(bJsonValue.names.get(0).ToString).ToString);
    vObjectDirection := GetDirectionName(bJsonValue.opt(bJsonValue.names.get(1).ToString).ToString);
    vEncoded         := GetBooleanFromString(bJsonValue.opt(bJsonValue.names.get(2).ToString).ToString);
    vObjectValue     := GetValueType(bJsonValue.opt(bJsonValue.names.get(3).ToString).ToString);
    vParamName       := Lowercase(bJsonValue.names.get(4).ToString);
    WriteValue(vValue);
   End;
 Finally
  bJsonValue.Free;
 End;
End;
{$ENDIF}

Procedure TJSONParam.CopyFrom(JSONParam: TJSONParam);
Var
 vValue : String;
Begin
 Try
  vValue                := JSONParam.Value;
  Self.vTypeObject      := JSONParam.vTypeObject;
  Self.vObjectDirection := JSONParam.vObjectDirection;
  Self.vEncoded         := JSONParam.vEncoded;
  Self.vObjectValue     := JSONParam.vObjectValue;
  Self.vParamName       := JSONParam.vParamName;
  Self.SetValue(vValue);
 Finally
 End;
End;

Procedure TJSONParam.SaveToStream(Stream: TMemoryStream);
Begin
 HexToStream(Value, Stream);
End;

Procedure TJSONParam.SetParamName(bValue: String);
Begin
 vParamName := Uppercase(bValue);
End;

Procedure TJSONParam.SetValue(aValue: String; Encode: Boolean);
Begin
 vEncoded := Encode;
 vJSONValue.vEncoded := vEncoded;
 If Encode Then
  WriteValue(EncodeStrings(aValue{$IFDEF FPC}, csUndefined{$ENDIF}))
 Else
  WriteValue(aValue);
 vBinary := False;
 vJSONValue.vBinary := vBinary;
End;

Function TJSONParam.ToJSON: String;
Begin
 Result := vJSONValue.ToJSON;
End;

Function TJSONParam.Value: String;
Begin
 Result := vJSONValue.Value;
End;

Procedure TJSONParam.WriteValue(bValue: String);
Begin
 {$IFNDEF FPC}
 {$IF CompilerVersion > 21}
  vJSONValue.Encoding        := vEncoding;
 {$IFEND}
 {$ENDIF}
 vJSONValue.vtagName         := vParamName;
 vJSONValue.vTypeObject      := vTypeObject;
 vJSONValue.vObjectDirection := vObjectDirection;
 vJSONValue.vObjectValue     := vObjectValue;
 vJSONValue.vEncoded         := vEncoded;
 vJSONValue.WriteValue(bValue);
End;

{ TStringStreamList }

Function TStringStreamList.Add(Item : TStringStream): Integer;
Var
 vItem : ^TStringStream;
Begin
 New(vItem);
 vItem^ := Item;
 Result := TList(Self).Add(vItem);
End;

Procedure TStringStreamList.ClearList;
Var
 I : Integer;
Begin
 For I := Count - 1 Downto 0 Do
  Delete(I);
 Self.Clear;
End;

Constructor TStringStreamList.Create;
Begin
 Inherited;
End;

Procedure TStringStreamList.Delete(Index: Integer);
Begin
 If (Index < Self.Count) And (Index > -1) Then
  Begin
   If Assigned(TList(Self).Items[Index]) Then
    Begin
     FreeAndNil(TList(Self).Items[Index]^);
     {$IFDEF FPC}
     Dispose(PStringStream(TList(Self).Items[Index]));
     {$ELSE}
     Dispose(TList(Self).Items[Index]);
     {$ENDIF}
    End;
   TList(Self).Delete(Index);
  End;
End;

Destructor TStringStreamList.Destroy;
Begin
 ClearList;
 Inherited;
End;

Function TStringStreamList.GetRec(Index : Integer): TStringStream;
Begin
 Result := Nil;
 If (Index < Self.Count) And (Index > -1) Then
  Result := TStringStream(TList(Self).Items[Index]^);
End;

Procedure TStringStreamList.PutRec(Index: Integer; Item: TStringStream);
Begin
 If (Index < Self.Count) And (Index > -1) Then
  TStringStream(TList(Self).Items[Index]^) := Item;
End;

End.
