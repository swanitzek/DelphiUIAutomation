unit TestMainFormU;

interface

uses
  TestFramework,
  DelphiUIAutomation.Automation,
  DelphiUIAutomation.Window,
  DelphiUIAutomation.Client,
  DelphiUIAutomation.Desktop;

type
  TestMainForm = class(TTestCase)
  strict private
    FApplication: IAutomationApplication;
  public
    procedure SetUp; override;
    procedure TearDown; override;
  published
    procedure Example;
  end;

implementation

{ TestIAutomationBase }

procedure TestMainForm.Example;
var
  MainWindow: IAutomationWindow;
begin
  MainWindow := TAutomationDesktop.GetDesktopWindow('DemoApp');

  MainWindow.GetButton('OK').Click;
end;

procedure TestMainForm.SetUp;
begin
  inherited;

  FApplication := TAutomationApplication.LaunchOrAttach('..\Binary\DemoApp.exe', '');

  FApplication.WaitWhileBusy;
end;

procedure TestMainForm.TearDown;
begin
  inherited;

  FApplication.Kill;
end;

initialization

TUIAuto.CreateUIAuto; // Initialise the library

RegisterTest(TestMainForm.Suite);

end.
