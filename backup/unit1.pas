unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, process, Forms, Controls, Graphics, Dialogs, Menus,
  ComCtrls, StdCtrls, UITypes;

type

  { TForm1 }

  TForm1 = class(TForm)
    FontDialog1: TFontDialog;
    MainMenu1: TMainMenu;
    Memo1: TMemo;
    Memo2: TMemo;
    MenuItem1: TMenuItem;
    MenuItem10: TMenuItem;
    MenuItem11: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    MenuItem6: TMenuItem;
    MenuItem7: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    OpenDialog1: TOpenDialog;
    PageControl1: TPageControl;
    Process1: TProcess;
    SelectDirectoryDialog1: TSelectDirectoryDialog;
    StatusBar1: TStatusBar;
    TabSheet1: TTabSheet;
    TabSheet2: TTabSheet;
    procedure MenuItem11Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure MenuItem5Click(Sender: TObject);
    procedure MenuItem7Click(Sender: TObject);
    procedure MenuItem8Click(Sender: TObject);
    procedure MenuItem9Click(Sender: TObject);
  private
    function get_path(): string;
    procedure set_path(value: string);
    function get_project(): string;
    procedure set_project(value: string);
    function get_source(): string;
    procedure set_source(value: string);
  public
    property path: string read get_path write set_path;
    property project: string read get_project write set_project;
    property source: string read get_source write set_source;
  end;

var
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.MenuItem2Click(Sender: TObject);
var s: string;
begin
  if self.SelectDirectoryDialog1.Execute then
    begin
      self.path:=self.SelectDirectoryDialog1.FileName+'/';
      s:=self.SelectDirectoryDialog1.FileName;
      Delete(s,1,length(self.SelectDirectoryDialog1.InitialDir));
      self.project:=s;
      self.source:=self.project+'.FOR';
      self.Memo1.Lines.Clear;
      self.Memo2.Lines.Clear;
      self.Memo1.lines.Add('      PROGRAM '+self.project);
      self.Memo1.lines.Add('      ');
      self.Memo1.lines.Add('      END');
      self.MenuItem4Click(Sender);
      self.PageControl1.ActivePageIndex:=0;
    end;
end;

procedure TForm1.MenuItem11Click(Sender: TObject);
begin
  if self.FontDialog1.Execute then
    self.Memo1.Font:=self.FontDialog1.Font;
end;

procedure TForm1.MenuItem3Click(Sender: TObject);
var s: string;
begin
  if  self.OpenDialog1.Execute then
    begin
      self.path:=self.OpenDialog1.InitialDir;
      s:=self.OpenDialog1.FileName;
      Delete(s,1,length(self.OpenDialog1.InitialDir));
      self.source:=s;
      self.project:=copy(s,1,length(s)-4);
      self.Memo1.Lines.Clear;
      self.Memo2.Lines.Clear;
      self.Memo1.Lines.LoadFromFile(self.path+self.source);
      self.PageControl1.ActivePageIndex:=0;
    end;

end;

procedure TForm1.MenuItem4Click(Sender: TObject);
begin
  if self.source<>'' then
    self.Memo1.Lines.SaveToFile(self.path+self.source)
end;

procedure TForm1.MenuItem5Click(Sender: TObject);
begin
  self.path:='';
  self.project:='';
  self.source:='';
  self.Memo1.Lines.Clear;
  self.Memo2.Lines.Clear;
  self.PageControl1.ActivePageIndex:=0;
end;

procedure TForm1.MenuItem7Click(Sender: TObject);
begin
  self.Memo2.Lines.Clear;
  self.PageControl1.ActivePageIndex:=1;
  self.Process1.CommandLine:= 'gfortran '+self.source+' -o '+
    self.project+'.out';
  self.Process1.Options:=[poStderrtoOutPut,poUsePipes];
  self.Process1.Execute;
  self.Memo2.Lines.LoadFromStream(Process1.Output);
end;

procedure TForm1.MenuItem8Click(Sender: TObject);
begin
  self.MenuItem7Click(Sender);
  self.MenuItem9Click(Sender);
end;

procedure TForm1.MenuItem9Click(Sender: TObject);
var mes: string;
begin
  if FileExists(self.path+self.project+'.out') then
    begin
      self.Process1.CommandLine:= './'+self.project+'.out';
      self.Memo2.Lines.Add(self.Process1.CommandLine);
      self.Process1.Options:=[poNewConsole,poStderrtoOutPut,poUsePipes];
      self.Process1.Execute;
    end;
end;

function TForm1.get_path(): string;
begin
  result:=self.StatusBar1.SimpleText
end;

procedure TForm1.set_path(value: string);
begin
  self.StatusBar1.SimpleText:=value;
  self.Process1.CurrentDirectory:=value
end;

function TForm1.get_project(): string;
var l: integer;
begin
  l:=length(self.Caption);
  if l>9 then
    result:=copy(self.Caption,9,l)
  else
    result:=''
end;

procedure TForm1.set_project(value: string);
begin
  self.Caption:='FTIDE1: '+value
end;

function TForm1.get_source(): string;
var l: integer;
begin
  l:=length(self.TabSheet1.Caption);
  if l>14 then
    result:=copy(self.TabSheet1.Caption,14,l)
  else
    result:=''
end;

procedure TForm1.set_source(value: string);
begin
  self.TabSheet1.Caption:='Code editor: '+value
end;

end.



