unit MainFrm;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
  TForm3 = class(TForm)
    Button1: TButton;
    Edit1: TEdit;
    Button2: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  Form3: TForm3;

implementation

{$R *.dfm}

procedure TForm3.Button1Click(Sender: TObject);
begin
  ShowMessage('Test');
end;

procedure TForm3.Button2Click(Sender: TObject);
begin
  raise Exception.Create
    ('It is required to initialize the DelphiUIAutomation library with a call to "TUIAuto.CreateUIAuto. This can be done by adding a initialization section to one of your units:'
    + sLineBreak + sLineBreak + 'initialization' + sLineBreak + '   TUIAuto.CreateUIAuto;');
end;

end.
