{***************************************************************************}
{                                                                           }
{           DelphiUIAutomation                                              }
{                                                                           }
{           Copyright 2015 JHC Systems Limited                              }
{                                                                           }
{***************************************************************************}
{                                                                           }
{  Licensed under the Apache License, Version 2.0 (the "License");          }
{  you may not use this file except in compliance with the License.         }
{  You may obtain a copy of the License at                                  }
{                                                                           }
{      http://www.apache.org/licenses/LICENSE-2.0                           }
{                                                                           }
{  Unless required by applicable law or agreed to in writing, software      }
{  distributed under the License is distributed on an "AS IS" BASIS,        }
{  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. }
{  See the License for the specific language governing permissions and      }
{  limitations under the License.                                           }
{                                                                           }
{***************************************************************************}
unit DelphiUIAutomation.MenuItem;

interface

uses
  DelphiUIAutomation.Base,
  generics.collections,
  UIAutomationClient_TLB;

type
  /// <summary>
  ///  Represents a menu item
  /// </summary>
  /// <remarks>
  ///  Models Menu items (root or leaf).
  ///  SubMenus are themselves are Menu(s).
  /// </remarks>
  TAutomationMenuItem = class (TAutomationBase)
  strict private
    FItems : TObjectList<TAutomationMenuItem>;
    FInvokePattern : IUIAutomationInvokePattern;
    FExpandCollapsePattern : IUIAutomationExpandCollapsePattern;

    function getItems: TObjectList<TAutomationMenuItem>;
  private
    procedure GetInvokePattern;
    procedure GetExpandCollapsePattern;
    procedure InitialiseList;
  public
    /// <summary>
    ///  Constructor for menu items.
    /// </summary>
    constructor Create(element : IUIAutomationElement); override;

    /// <summary>
    ///  Destructor.
    /// </summary>
    destructor Destroy; override;

    /// <summary>
    ///  Call the expand property
    /// </summary>
    function Expand : HRESULT;

    /// <summary>
    ///  Call the collapse property
    /// </summary>
    function Collapse : HRESULT;

    /// <summary>
    ///  Clicks the menuitem
    /// </summary>
    function Click: HResult;

    /// <summary>
    ///  Clicks the sub-menuitem
    /// </summary>
    function ClickSubItem(const name : string) : HResult;

    ///<summary>
    ///  Gets the list of items associated with this menu
    ///</summary>
    property Items : TObjectList<TAutomationMenuItem> read getItems;
  end;

implementation

uses
  Winapi.Windows,
  Winapi.ActiveX,
  DelphiUIAutomation.PropertyIDs,
  DelphiUIAutomation.Exception,
  DelphiUIAutomation.ControlTypeIDs,
  DelphiUIAutomation.PatternIDs,
  DelphiUIAutomation.Automation;

procedure TAutomationMenuItem.GetExpandCollapsePattern;
var
  inter: IInterface;

begin
  self.fElement.GetCurrentPattern(UIA_ExpandCollapsePatternId, inter);

  if (inter <> nil) then
  begin
    if inter.QueryInterface(IID_IUIAutomationExpandCollapsePattern, self.FExpandCollapsePattern) <> S_OK then
    begin
      raise EDelphiAutomationException.Create('Unable to initialise control pattern');
    end;
  end;
end;

constructor TAutomationMenuItem.Create(element: IUIAutomationElement);
var
  name : widestring;

begin
  inherited create(element);

  FElement.Get_CurrentName(name);

  GetExpandCollapsePattern;
  GetInvokePattern;

  // This doesn't work as expected
//  InitialiseList;
end;

destructor TAutomationMenuItem.Destroy;
begin
  FItems.free;
  inherited;
end;

procedure TAutomationMenuItem.InitialiseList;
var
  collection : IUIAutomationElementArray;
  itemElement : IUIAutomationElement;
  count : integer;
  length : integer;
  retVal : integer;
  condition : IUIAutomationCondition;
  item : TAutomationMenuItem;

begin
  self.Expand;
  sleep(750);

  UIAuto.CreateTrueCondition(condition);

  FItems := TObjectList<TAutomationMenuItem>.create;

  // Find the elements
  self.FElement.FindAll(TreeScope_Descendants, condition, collection);

  collection.Get_Length(length);

  for count := 0 to length -1 do
  begin
    collection.GetElement(count, itemElement);
    itemElement.Get_CurrentControlType(retVal);

    if (retVal = UIA_MenuItemControlTypeId) then
    begin
      item := TAutomationMenuItem.Create(itemElement);
      FItems.Add(item);
    end;
  end;
end;

function TAutomationMenuItem.Expand: HRESULT;
begin
  result := -1;
  if FExpandCollapsePattern <> nil then
    result := self.FExpandCollapsePattern.Expand;
end;

function TAutomationMenuItem.ClickSubItem(const name : string): HResult;
var
  item : IUIAutomationElement;
  condition : IUIAutomationCondition;
  varProp : OleVariant;

begin
  TVariantArg(varProp).vt := VT_BSTR;
  TVariantArg(varProp).bstrVal := pchar(name);

  UIAuto.CreatePropertyCondition(UIA_NamePropertyId, name, condition);

  self.Expand;
  sleep(3000);

  self.FElement.FindFirst(TreeScope_Children, condition, item);

  if (item <> nil) then
  begin

  end;

end;

function TAutomationMenuItem.Collapse: HRESULT;
begin
  result := -1;
  if FExpandCollapsePattern <> nil then
    result := self.FExpandCollapsePattern.Collapse;
end;

procedure TAutomationMenuItem.GetInvokePattern;
var
  inter: IInterface;

begin
  fElement.GetCurrentPattern(UIA_InvokePatternId, inter);

  if (inter <> nil) then
  begin
    if Inter.QueryInterface(IUIAutomationInvokePattern, FInvokePattern) <> S_OK then
    begin
      raise EDelphiAutomationException.Create('Unable to initialise control pattern');
    end;
  end;
end;

function TAutomationMenuItem.getItems: TObjectList<TAutomationMenuItem>;
begin
  result := self.FItems;
end;

function TAutomationMenuItem.Click : HResult;
begin
  result := -1;

  if (Assigned (FInvokePattern)) then
  begin
    result := FInvokePattern.Invoke;
  end;
end;

end.
