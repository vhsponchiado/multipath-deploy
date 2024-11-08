unit UnitMain;
// Vin�cius H. Sponchiado 30.08.2024
interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, System.IOUtils, System.IniFiles, ShellAPI ;

type
  TForm1 = class(TForm)
    edtFilePath: TEdit;
    btnSearchPath: TButton;
    OpenDialog: TOpenDialog;
    btnTransfer: TButton;
    lblFilePath: TLabel;
    btnExecute: TButton;
    lblConfigIni: TLabel;
    edtConfigPath: TEdit;
    btnSearchConfig: TButton;
    OpenDialogConfig: TOpenDialog;
    procedure btnSearchPathClick(Sender: TObject);
    procedure btnTransferClick(Sender: TObject);
    procedure btnExecuteClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure edtFilePathChange(Sender: TObject);
    procedure btnSearchConfigClick(Sender: TObject);
    procedure edtConfigPathChange(Sender: TObject);
  private
    { Private declarations }
    FTransferredFiles: TStringList;
    function ReadDestinationFoldersFromIni(const IniFileName: string): TStringList;
  public
    { Public declarations }
  end;

var
  Form1: TForm1;

implementation

{$R *.dfm}

procedure TForm1.btnSearchConfigClick(Sender: TObject);
begin
  if OpenDialogConfig.Execute then
  begin
    // Verifica se o arquivo selecionado � um arquivo .ini
    if LowerCase(ExtractFileExt(OpenDialogConfig.FileName)) = '.ini' then
    begin
      // Salva o caminho do arquivo selecionado no componente edtFilePath
      edtConfigPath.Text := OpenDialogConfig.FileName;
    end
    else
    begin
      ShowMessage('Por favor, selecione um arquivo .ini.');
    end;
  end;
end;


procedure TForm1.btnSearchPathClick(Sender: TObject);
begin
  if OpenDialog.Execute then
  begin
    // Salva o caminho do arquivo selecionado no componente edtFilePath
    edtFilePath.Text := OpenDialog.FileName;
  end;
end;

function TForm1.ReadDestinationFoldersFromIni(const IniFileName: string): TStringList;
var
  IniFile: TIniFile;
  Sections: TStringList;
  i: Integer;
begin
   // Cria uma nova TStringList para armazenar os caminhos das pastas de destino
  Result := TStringList.Create;
  // Cria uma inst�ncia de TIniFile para manipular o arquivo INI especificado
  IniFile := TIniFile.Create(IniFileName);
  // Cria uma TStringList para armazenar os nomes das se��es do arquivo INI
  Sections := TStringList.Create;
  try
    // L� todos os nomes das se��es do arquivo INI e os armazena na lista Sections
    IniFile.ReadSections(Sections);
    // Itera sobre cada se��o na lista Sections
    for i := 0 to Sections.Count - 1 do
      // Adiciona o valor da chave 'Path' de cada se��o � lista Result
      Result.Add(IniFile.ReadString(Sections[i], 'Path', ''));
  finally
    // Libera a mem�ria usada pela lista Sections
    Sections.Free;
    // Libera a mem�ria usada pelo objeto IniFile
    IniFile.Free;
  end;
end;

procedure TForm1.btnTransferClick(Sender: TObject);
var
  SourceFilePath: string;
  DestinationFolders: TStringList;
  DestinationFilePath: string;
  RenamedFilePath: string;
  i: Integer;
  IniFileName: string;
  DateTimeSuffix: string;
begin
  SourceFilePath := edtFilePath.Text;

  // Caminho do arquivo .ini contendo os caminhos de destino
  IniFileName := edtConfigPath.Text;

  // Cria e inicializa a TStringList para os destinos
  DestinationFolders := ReadDestinationFoldersFromIni(IniFileName);
  try
    // Verifica se o caminho do arquivo de origem n�o est� vazio
    if SourceFilePath = '' then
    begin
      ShowMessage('Selecione um arquivo para transferir.');
      Exit;
    end;

    // Cria e inicializa a TStringList para os arquivos transferidos
    FTransferredFiles := TStringList.Create;
    try
      // Itera sobre a lista de pastas de destino
      for i := 0 to DestinationFolders.Count - 1 do
      begin
        // Define o caminho do arquivo de destino
        DestinationFilePath := TPath.Combine(DestinationFolders[i], TPath.GetFileName(SourceFilePath));

        // Verifica se a pasta de destino existe
        if not TDirectory.Exists(DestinationFolders[i]) then
        begin
          ShowMessage('A pasta de destino "' + DestinationFolders[i] + '" n�o existe.');
          Continue; // Continua para o pr�ximo destino
        end;

        // Verifica se o arquivo de destino j� existe
        if TFile.Exists(DestinationFilePath) then
        begin
          // Cria um sufixo com a data e hora atual
          DateTimeSuffix := FormatDateTime('_yyyymmdd_hhnnss', Now);

          // Renomeia o arquivo existente adicionando o sufixo de data e hora
          RenamedFilePath := TPath.Combine(DestinationFolders[i],
            TPath.GetFileNameWithoutExtension(DestinationFilePath) + DateTimeSuffix + TPath.GetExtension(DestinationFilePath));

          try
            // Renomeia o arquivo existente
            TFile.Move(DestinationFilePath, RenamedFilePath);
          except
            on E: Exception do
            begin
              ShowMessage('Erro ao renomear o arquivo existente: ' + E.Message);
              Continue;
            end;
          end;
        end;

        try
          // Copia o arquivo para o destino, mantendo o nome original
          TFile.Copy(SourceFilePath, DestinationFilePath, False); // False, pois n�o vamos substituir
          FTransferredFiles.Add(DestinationFilePath); // Adiciona o caminho do arquivo transferido � lista
        except
          on E: Exception do
            ShowMessage('Erro ao copiar o arquivo para ' + DestinationFilePath + ': ' + E.Message);
        end;
      end;

      ShowMessage('Arquivo transferido com sucesso para o(s) caminho(s)');
      btnExecute.Enabled := true;

    finally
      DestinationFolders.Free; // Libera a mem�ria usada pela TStringList
    end;
  except
    on E: Exception do
      ShowMessage('Erro ao transferir arquivos: ' + E.Message);
  end;
end;

procedure TForm1.edtConfigPathChange(Sender: TObject);
begin
  if (Length(edtConfigPath.Text) > 0) then
 begin
   edtFilePath.Enabled := true;
   btnSearchPath.Enabled := true;
 end
 else
 begin
  btnSearchPath.Enabled := false;
  edtFilePath.Enabled := false;
 end;
end;

procedure TForm1.edtFilePathChange(Sender: TObject);
begin
 if(Length(edtFilePath.Text) > 0) then
 begin
   btnTransfer.Enabled := true;
 end
 else
 begin
  btnTransfer.Enabled := false;
  btnExecute.Enabled := false;
 end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  btnExecute.Enabled := false;
  btnTransfer.Enabled := false;
  btnSearchPath.Enabled := false;
  edtFilePath.Enabled := false;
end;

procedure TForm1.btnExecuteClick(Sender: TObject);
var
  i: Integer;
begin
  // Verifica se a lista de arquivos transferidos est� vazia.
  // Se n�o houver arquivos, exibe uma mensagem e encerra o procedimento.
  if FTransferredFiles.Count = 0 then
  begin
    ShowMessage('Nenhum arquivo transferido para executar.');
    Exit;
  end;

  // Itera sobre cada arquivo na lista de arquivos transferidos.
  for i := 0 to FTransferredFiles.Count - 1 do
  begin
    try
      // Tenta abrir o arquivo usando a fun��o ShellExecute.
      // 'open' indica que o arquivo deve ser aberto com o aplicativo padr�o associado.
      // PChar converte o nome do arquivo para um tipo de caractere apropriado para ShellExecute.
      // SW_SHOWNORMAL faz com que a janela do aplicativo seja mostrada normalmente.
      ShellExecute(0, 'open', PChar(FTransferredFiles[i]), nil, nil, SW_SHOWNORMAL);
    except
      on E: Exception do
        // Se ocorrer uma exce��o, exibe uma mensagem de erro indicando qual arquivo causou o problema
        // e a mensagem de exce��o associada.
        ShowMessage('Erro ao executar o arquivo ' + FTransferredFiles[i] + ': ' + E.Message);
    end;
  end;
end;

end.

