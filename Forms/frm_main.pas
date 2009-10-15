
{******************************************************************************}
{                                                                              }
{                                 MyHomeLib                                    }
{                                                                              }
{                                Version 0.9                                   }
{                                20.08.2008                                    }
{                    Copyright (c) Aleksey Penkov  alex.penkov@gmail.com       }
{                                                                              }
{******************************************************************************}

unit frm_main;

interface

uses
  Windows,
  Messages,
  SysUtils,
  Variants,
  Classes,
  Graphics,
  Controls,
  Forms,
  Dialogs,
  VirtualTrees,
  StdCtrls,
  ComCtrls,
  RzSplit,
  RzLabel,
  RzDBLbl,
  Mask,
  RzEdit,
  RzTabs,
  ExtCtrls,
  RzPanel,
  ToolWin,
  ImgList,
  Menus,
  ABSMain,
  DB,
  ShellAPI,
  inifiles,
  RzButton,
  unit_Globals,
  XPMan,
  RzCommon,
  RzSelDir,
  RzStatus,
  RzTray,
  idComponent,
  IdBaseComponent,
  IdTCPConnection,
  IdTCPClient,
  IdHTTP,
  xmldom,
  XMLIntf,
  msxmldom,
  XMLDoc,
  IdAntiFreezeBase,
  IdAntiFreeze,
  pngimage,
  jpeg,
  IdCookieManager,
  unit_database,
 // oxmldom,
  DBTables,
  Clipbrd,
  RzCmboBx,
  RzBHints,
  unit_CoverPanel,
  unit_InfoPanel,
  unit_Columns,
  ZipForge,
  RzPrgres,
  unit_DownloadManagerThread,
  unit_Messages,
  RzBtnEdt,
  files_list,
  ActiveX,
  htmlhlp,
  IdCustomTransparentProxy,
  IdConnectThroughHttpProxy;

type

  TfrmMain = class(TForm)
    MainMenu: TMainMenu;
    miBook: TMenuItem;
    miQuitApp: TMenuItem;
    rpLang: TRzPanel;
    RusBar: TToolBar;
    tbtnStar: TToolButton;
    EngBar: TToolBar;
    ToolButton2: TToolButton;
    pmMain: TPopupMenu;
    pmiReadBook: TMenuItem;
    pmiSendToDevice: TMenuItem;
    N19: TMenuItem;
    miAddFavorites: TMenuItem;
    miDelFavorites: TMenuItem;
    miRate: TMenuItem;
    miSetRate: TMenuItem;
    miSetRate2: TMenuItem;
    miSetRate3: TMenuItem;
    miSetRate4: TMenuItem;
    miSetRate5: TMenuItem;
    N11: TMenuItem;
    miClearRate: TMenuItem;
    N20: TMenuItem;
    pmiCheckAll: TMenuItem;
    pmiDeselectAll: TMenuItem;
    N23: TMenuItem;
    miCopyClBrd: TMenuItem;
    pmiBookInfo: TMenuItem;
    N2: TMenuItem;
    miTools: TMenuItem;
    miSettings: TMenuItem;
    N5: TMenuItem;
    N9: TMenuItem;
    miCollSelect: TMenuItem;
    miDeleteCol: TMenuItem;
    N18: TMenuItem;
    miStat: TMenuItem;
    miRead: TMenuItem;
    miDevice: TMenuItem;
    miEditBook: TMenuItem;
    N7: TMenuItem;
    StatusBar: TRzStatusBar;
    RzVersionInfoStatus1: TRzVersionInfoStatus;
    spStatus: TRzStatusPane;
    VersionInfo: TRzVersionInfo;
    spProgress: TRzProgressStatus;
    miCollsettings: TMenuItem;
    N16: TMenuItem;
    miCopyToCollection: TMenuItem;
    CopyToCollection: TMenuItem;
    miDeleteBook: TMenuItem;
    miImport: TMenuItem;
    miFb2ZipImport: TMenuItem;
    miFb2Import: TMenuItem;
    miAbout: TMenuItem;
    miCheckUpdates: TMenuItem;
    N30: TMenuItem;
    miShowHelp: TMenuItem;
    RzStatusPane1: TRzStatusPane;
    IdAntiFreeze1: TIdAntiFreeze;
    N17: TMenuItem;
    pmAuthor: TPopupMenu;
    miCopyAuthor: TMenuItem;
    miPdfdjvu: TMenuItem;
    miCollectionExport: TMenuItem;
    miCollectionImport: TMenuItem;
    miBookEdit: TMenuItem;
    N24: TMenuItem;
    miRefreshGenres: TMenuItem;
    miDownloadBooks: TMenuItem;
    pmiDownloadBooks: TMenuItem;
    miEdit: TMenuItem;
    miEditAuthor: TMenuItem;
    miEditSeries: TMenuItem;
    miEditGenres: TMenuItem;
    ilToolBar: TImageList;
    ilMainMenu: TImageList;
    MenuController: TRzMenuController;
    pmCollection: TPopupMenu;
    miUpdate: TMenuItem;
    miGoToAuthor: TMenuItem;
    tlbrMain: TToolBar;
    tbtnRead: TToolButton;
    tbSendToDevice: TToolButton;
    tbtnRus: TToolButton;
    tbtnEng: TToolButton;
    tbSelectAll: TToolButton;
    tbCollapse: TToolButton;
    btnRefreshCollection: TToolButton;
    tbtnShowCover: TToolButton;
    tbtnShowDeleted: TToolButton;
    ToolButton12: TToolButton;
    ToolButton13: TToolButton;
    ToolButton1: TToolButton;
    ToolButton3: TToolButton;
    BtnFav_add: TToolButton;
    ToolButton5: TToolButton;
    tbtnSettings: TToolButton;
    tbtnSelect: TToolButton;
    pmScripts: TPopupMenu;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    MenuItem3: TMenuItem;
    pmiScripts: TMenuItem;
    mmiScripts: TMenuItem;
    miSyncOnline: TMenuItem;
    btnSwitchTreeMode: TToolButton;
    tbtnWizard: TToolButton;
    tbtnShowLocalOnly: TToolButton;
    tbtnDownloadList_Add: TToolButton;
    N1: TMenuItem;
    miGoSite: TMenuItem;
    miGoForum: TMenuItem;
    pgControl: TRzPageControl;
    TabSheet4: TRzTabSheet;
    tvBooksF: TVirtualStringTree;
    TabSheet5: TRzTabSheet;
    cpCoverF: TMHLCoverPanel;
    ilFileTypes: TImageList;
    TabSheet1: TRzTabSheet;
    rzsSplitterA: TRzSplitter;
    RzPanel13: TRzPanel;
    tvAuthors: TVirtualStringTree;
    RzPanel16: TRzPanel;
    Label19: TLabel;
    tbClearEdAuthor: TRzToolButton;
    edLocateAuthor: TRzEdit;
    RzPanel15: TRzPanel;
    RzPanel17: TRzPanel;
    RzPanel18: TRzPanel;
    lblBooksTotalA: TRzLabel;
    RzPanel23: TRzPanel;
    tvBooksA: TVirtualStringTree;
    ipnlAuthors: TMHLInfoPanel;
    pmHeaders: TPopupMenu;
    N3: TMenuItem;
    N4: TMenuItem;
    N8: TMenuItem;
    N10: TMenuItem;
    N12: TMenuItem;
    N13: TMenuItem;
    N15: TMenuItem;
    N21: TMenuItem;
    N22: TMenuItem;
    N25: TMenuItem;
    N27: TMenuItem;
    TabSheet2: TRzTabSheet;
    rzsSplitterS: TRzSplitter;
    RzPanel1: TRzPanel;
    tvSeries: TVirtualStringTree;
    RzPanel19: TRzPanel;
    Label11: TLabel;
    btnClearEdSeries: TRzToolButton;
    edLocateSeries: TRzEdit;
    RzPanel3: TRzPanel;
    RzPanel4: TRzPanel;
    RzPanel5: TRzPanel;
    lblBooksTotalS: TRzLabel;
    tvBooksS: TVirtualStringTree;
    RichEdit1: TRichEdit;
    ipnlSeries: TMHLInfoPanel;
    cpCoverS: TMHLCoverPanel;
    TabSheet3: TRzTabSheet;
    rzsSplitterG: TRzSplitter;
    RzPanel25: TRzPanel;
    tvGenres: TVirtualStringTree;
    RzPanel27: TRzPanel;
    RzPanel28: TRzPanel;
    tvBooksG: TVirtualStringTree;
    RichEdit4: TRichEdit;
    RzPanel26: TRzPanel;
    lblBooksTotalG: TRzLabel;
    lblGenreTitle: TRzLabel;
    ipnlGenres: TMHLInfoPanel;
    cpCoverG: TMHLCoverPanel;
    ToolButton4: TToolButton;
    ToolButton6: TToolButton;
    TrayIcon: TTrayIcon;
    pmTray: TPopupMenu;
    N29: TMenuItem;
    N32: TMenuItem;
    N33: TMenuItem;
    TabSheet7: TRzTabSheet;
    pmDownloadList: TPopupMenu;
    mi_dwnl_LocateAuthor: TMenuItem;
    N35: TMenuItem;
    mi_dwnl_Delete: TMenuItem;
    ilToolBar_Disabled: TImageList;
    N26: TMenuItem;
    N34: TMenuItem;
    N36: TMenuItem;
    tlbrDownloadList: TRzToolbar;
    RzSpacer1: TRzSpacer;
    ilDownloadToolBar: TImageList;
    BtnDwnldUp: TRzToolButton;
    BtnDwnldDown: TRzToolButton;
    BtnDelete: TRzToolButton;
    BtnFirstRecord: TRzToolButton;
    BtnLastRecord: TRzToolButton;
    RzSpacer2: TRzSpacer;
    ToolButton7: TToolButton;
    lblAuthor: TRzLabel;
    lblSeries: TRzLabel;
    btnStartDownload: TRzToolButton;
    btnPauseDownload: TRzToolButton;
    Panel1: TPanel;
    RzPanel2: TRzPanel;
    lblDownloadState: TLabel;
    lblDnldAuthor: TLabel;
    lblDnldTitle: TLabel;
    lblDownloadCount: TRzLabel;
    btnClearDownload: TRzBitBtn;
    tvDownloadList: TVirtualStringTree;
    BtnSave: TRzToolButton;
    RzSpacer3: TRzSpacer;
    IdCookieManager: TIdCookieManager;
    N28: TMenuItem;
    N37: TMenuItem;
    miAddToSearch: TMenuItem;
    miINPXCollectionExport: TMenuItem;
    N38: TMenuItem;
    rzsSplitterF: TRzSplitter;
    RzPanel7: TRzPanel;
    tvGroups: TVirtualStringTree;
    RzPanel8: TRzPanel;
    RzToolButton2: TRzToolButton;
    RzPanel20: TRzPanel;
    RzPanel21: TRzPanel;
    ipnlFavorites: TMHLInfoPanel;
    lblTotalBooksF: TRzLabel;
    btnClearFavorites: TRzBitBtn;
    pmGroups: TPopupMenu;
    GroupMenuItem: TMenuItem;
    btnAddGroup: TRzBitBtn;
    btnDeleteGroup: TRzBitBtn;
    btnClearGroup: TRzBitBtn;
    pmiGroups: TMenuItem;
    RzPanel6: TRzPanel;
    lblBooksTotalF: TRzLabel;
    lblGroups: TRzLabel;
    N39: TMenuItem;
    N40: TMenuItem;
    N41: TMenuItem;
    N14: TMenuItem;
    miImportUserData: TMenuItem;
    miExportUserData: TMenuItem;
    miReaded: TMenuItem;
    N44: TMenuItem;
    N42: TMenuItem;
    N45: TMenuItem;
    rzsSplitterSR: TRzSplitter;
    CategoryPanelGroup1: TCategoryPanelGroup;
    ctpOther: TCategoryPanel;
    Label30: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    Label4: TLabel;
    cbDate: TRzComboBox;
    cbLang: TRzComboBox;
    cbDownloaded: TRzComboBox;
    edFKeyWords: TRzButtonEdit;
    cbDeleted: TCheckBox;
    ctpFile: TCategoryPanel;
    Label27: TLabel;
    Label29: TLabel;
    Label28: TLabel;
    edFFile: TRzButtonEdit;
    edFFolder: TRzButtonEdit;
    edFExt: TRzButtonEdit;
    cpCoverSR: TMHLCoverPanel;
    RzPanel9: TRzPanel;
    RzPanel10: TRzPanel;
    tvBooksSR: TVirtualStringTree;
    RichEdit2: TRichEdit;
    ipnlSearch: TMHLInfoPanel;
    pnlFullSearch: TPanel;
    RzGroupBox2: TRzGroupBox;
    lblTotalBooksFL: TRzLabel;
    Label1: TLabel;
    cbPresetName: TRzComboBox;
    btnDeletePreset: TRzBitBtn;
    btnSavePreset: TRzBitBtn;
    RzGroupBox5: TRzGroupBox;
    btnClearFilterEdits: TRzBitBtn;
    btnApplyFilter: TRzBitBtn;
    BalloonHint1: TBalloonHint;
    miRepairDataBase: TMenuItem;
    N6: TMenuItem;
    miCompactDataBase: TMenuItem;
    ctpBook: TCategoryPanel;
    Label5: TLabel;
    edFFullName: TRzButtonEdit;
    Label24: TLabel;
    edFTitle: TRzButtonEdit;
    Label26: TLabel;
    edFSeries: TRzButtonEdit;
    edFGenre: TRzButtonEdit;
    Label6: TLabel;
    N31: TMenuItem;
    miDeleteFiles: TMenuItem;
    miFastBookSearch: TMenuItem;
    pmiSelectAll: TMenuItem;
    pbDownloadProgress: TRzProgressBar;
    cpCoverA: TMHLCoverPanel;
    miFBDImport: TMenuItem;
    miConverToFBD: TMenuItem;
    miEditToolbarVisible: TMenuItem;
    tlbrEdit: TToolBar;
    tbtnEditAuthor: TToolButton;
    tbtnEditSeries: TToolButton;
    tbtnEditGenre: TToolButton;
    tbtnEditBook: TToolButton;
    ToolButton14: TToolButton;
    tbtnFBD: TToolButton;
    N43: TMenuItem;
    ToolButton16: TToolButton;
    tbtnDeleteBook: TToolButton;
    tbtnAutoFBD: TToolButton;
    FilesList: TFilesList;

    //
    // ������� �����
    //
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);

    //
    //
    //
    procedure tvAuthorsGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: String);
    procedure tvBooksAGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: String);
    procedure tvBooksGGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: String);
    procedure tvBooksSGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: String);
    procedure tvBooksFGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: String);
    procedure tvBooksSRGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: String);
    procedure tvGenresGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: String);

    //
    //
    //
    procedure tvAuthorsChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure tvSeriesChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure tvGenresChange(Sender: TBaseVirtualTree; Node: PVirtualNode);

    //
    // ��� ��������� 4-� ������� ��������� � ��������� �� �������� ��������
    // ��! ������ �������������� ������ ������ ���������
    //
    procedure tvAuthorsPaintText(Sender: TBaseVirtualTree;
      const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      TextType: TVSTTextType);

    //
    //
    //
    procedure tvBooksTreeBeforeCellPaint(Sender: TBaseVirtualTree;
      TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      CellPaintMode: TVTCellPaintMode; CellRect: TRect; var ContentRect: TRect);
    procedure tvBooksTreeAfterCellPaint(Sender: TBaseVirtualTree;
      TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      CellRect: TRect);

    //
    //
    //
    procedure tvBooksAGetNodeDataSize(Sender: TBaseVirtualTree;
      var NodeDataSize: Integer);
    procedure tvAuthorsGetNodeDataSize(Sender: TBaseVirtualTree;
      var NodeDataSize: Integer);
    procedure tvBooksGGetNodeDataSize(Sender: TBaseVirtualTree;
      var NodeDataSize: Integer);

    //
    //
    //
    procedure miQuitAppClick(Sender: TObject);
    procedure tbtnStarClick(Sender: TObject);
    procedure tbtbnReadClick(Sender: TObject);
    procedure miSettingsClick(Sender: TObject);
    procedure miAddFavoritesClick(Sender: TObject);
    procedure btnClearFavoritesClick(Sender: TObject);
    procedure tbtnRusClick(Sender: TObject);
    procedure tbtnEngClick(Sender: TObject);
    procedure tbSelectAllClick(Sender: TObject);
    procedure tbSendToDeviceClick(Sender: TObject);
    procedure pmiCheckAllClick(Sender: TObject);
    procedure pmiDeselectAllClick(Sender: TObject);
    procedure miCopyClBrdClick(Sender: TObject);


    procedure miDelFavoritesClick(Sender: TObject);
    procedure miSetRateClick(Sender: TObject);
    procedure miClearRateClick(Sender: TObject);
    procedure tbCollapseClick(Sender: TObject);
    procedure edLocateAuthorChange(Sender: TObject);
    procedure edLocateSeriesChange(Sender: TObject);
    procedure miStatClick(Sender: TObject);
    procedure miCollsettingsClick(Sender: TObject);
    procedure miActiveCollectionClick(Sender: TObject);
    procedure miDeleteColClick(Sender: TObject);
    procedure CopyToCollectionClick(Sender: TObject);
    procedure miDeleteBookClick(Sender: TObject);
    procedure miFb2ZipImportClick(Sender: TObject);
    procedure miAboutClick(Sender: TObject);
    procedure miCheckUpdatesClick(Sender: TObject);
    procedure miGoForumClick(Sender: TObject);
    procedure miGoSiteClick(Sender: TObject);
    procedure miShowHelpClick(Sender: TObject);
    procedure miGoToAuthorClick(Sender: TObject);
    procedure miFb2ImportClick(Sender: TObject);
    procedure pmiBookInfoClick(Sender: TObject);
    procedure tbtnShowCoverClick(Sender: TObject);
    procedure miCopyAuthorClick(Sender: TObject);
    procedure tbtnShowDeletedClick(Sender: TObject);
    procedure pgControlChange(Sender: TObject);
    procedure miPdfdjvuClick(Sender: TObject);
    procedure miCollectionExportClick(Sender: TObject);
    procedure miCollectionImportClick(Sender: TObject);
    procedure miEditBookClick(Sender: TObject);
    procedure miRefreshClick(Sender: TObject);

    procedure miRefreshGenresClick(Sender: TObject);
    procedure miDownloadBooksClick(Sender: TObject);
    procedure miEditAuthorClick(Sender: TObject);
    procedure miEditSeriesClick(Sender: TObject);
    procedure miEditGenresClick(Sender: TObject);
    procedure miUpdateClick(Sender: TObject);
    procedure miSyncOnlineClick(Sender: TObject);
    procedure btnSwitchTreeModeClick(Sender: TObject);
    //
    //
    //
    procedure tvBooksTreeHeaderClick(Sender: TVTHeader;
  HitInfo: TVTHeaderHitInfo);
    procedure tvBooksTreeCompareNodes(Sender: TBaseVirtualTree; Node1,
      Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
    procedure tvBooksTreePaintText(Sender: TBaseVirtualTree;
      const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      TextType: TVSTTextType);
    procedure tbtnShowLocalOnlyClick(Sender: TObject);
    procedure ShowNewCollectionWizard(Sender: TObject);
    procedure HTTPWorkEnd(ASender: TObject; AWorkMode: TWorkMode);
    procedure btnApplyFilterClick(Sender: TObject);
    procedure btnClearFilterEditsClick(Sender: TObject);
    procedure FormMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure tvBooksTreeMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure tvBooksTreeKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure edFFullNameKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure tbClearEdAuthorClick(Sender: TObject);
    procedure btnClearEdSeriesClick(Sender: TObject);
    procedure tvBooksTreeChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure tvBooksTreeInitNode(Sender: TBaseVirtualTree; ParentNode,
      Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
    procedure HeaderPopupItemClick(Sender: TObject);
    procedure N27Click(Sender: TObject);
    procedure CoverPanelResize(Sender: TObject);
    procedure TrayIconDblClick(Sender: TObject);
    procedure N33Click(Sender: TObject);
    procedure btnStartDownloadClick(Sender: TObject);
    procedure btnPauseDownloadClick(Sender: TObject);
    procedure tvDownloadListGetText(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
      var CellText: string);
    procedure btnDeleteDownloadClick(Sender: TObject);
    procedure mi_dwnl_LocateAuthorClick(Sender: TObject);
    procedure btnClearDownloadClick(Sender: TObject);
    procedure tvDownloadListSaveNode(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Stream: TStream);
    procedure tvDownloadListLoadNode(Sender: TBaseVirtualTree;
      Node: PVirtualNode; Stream: TStream);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure N34Click(Sender: TObject);
    procedure MoveDwnldListNodes(Sender: TObject);
    procedure BtnFav_addClick(Sender: TObject);
    procedure tvDownloadListPaintText(Sender: TBaseVirtualTree;
      const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
      TextType: TVSTTextType);
    procedure BtnSaveClick(Sender: TObject);
    procedure edLocateAuthorKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure btnSavePresetClick(Sender: TObject);
    procedure edFFullNameButtonClick(Sender: TObject);
    procedure cbPresetNameChange(Sender: TObject);
    procedure cbPresetNameSelect(Sender: TObject);
    procedure FilesListFile(Sender: TObject; const F: TSearchRec);
    procedure btnDeletePresetClick(Sender: TObject);
    procedure miAddToSearchClick(Sender: TObject);
    procedure miINPXCollectionExportClick(Sender: TObject);
    procedure pmAuthorPopup(Sender: TObject);
    procedure tvGroupsGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
      Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
    procedure tvGroupsGetNodeDataSize(Sender: TBaseVirtualTree;
      var NodeDataSize: Integer);
    procedure tvGroupsChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
    procedure GroupMenuItemClick(Sender: TObject);
    procedure btnAddGroupClick(Sender: TObject);
    procedure btnDeleteGroupClick(Sender: TObject);
    procedure tvGroupsDragOver(Sender: TBaseVirtualTree; Source: TObject;
      Shift: TShiftState; State: TDragState; Pt: TPoint; Mode: TDropMode;
      var Effect: Integer; var Accept: Boolean);
    procedure tvGroupsDragDrop(Sender: TBaseVirtualTree; Source: TObject;
      DataObject: IDataObject; Formats: TFormatArray; Shift: TShiftState;
      Pt: TPoint; var Effect: Integer; Mode: TDropMode);
    procedure miImportUserDataClick(Sender: TObject);
    procedure miReadedClick(Sender: TObject);
    procedure miExportUserDataClick(Sender: TObject);
    procedure miRepairDataBaseClick(Sender: TObject);
    procedure miCompactDataBaseClick(Sender: TObject);
    procedure edFGenreButtonClick(Sender: TObject);
    procedure edFGenreKeyPress(Sender: TObject; var Key: Char);
    procedure miDeleteFilesClick(Sender: TObject);
    procedure miFastBookSearchClick(Sender: TObject);
    procedure pmiSelectAllClick(Sender: TObject);
    procedure miFBDImportClick(Sender: TObject);
    procedure miConverToFBDClick(Sender: TObject);
    procedure miEditToolbarVisibleClick(Sender: TObject);
    procedure tbtnAutoFBDClick(Sender: TObject);

  protected
    procedure OnBookDownloadComplete(var Message: TDownloadCompleteMessage); message WM_MHL_DOWNLOAD_COMPLETE;

  private
    type
      TView = (ByAuthorView, BySeriesView, ByGenreView, SearchView, FavoritesView, DownloadView);

  private
    FDMThread: TDownloadManagerThread;

    FLastActiveBookID: integer;


    // ����� ������, �����
    FIgnoreChange : boolean;

    //
    // ���������� ��������
    //
    procedure FillSeriesTree;
    procedure FillBooksTree(
      const ParentID: Integer;
      const Tree: TVirtualStringTree;
      const Master: TDataset;
      const Detail: TDataSet;
      ShowAuth: Boolean;
      ShowSer: Boolean
      );

    procedure FillGroupsList;


    //
    // TODO -oNickR -cRefactoring : ������� ��� ������ � ��������������� ����������
    //

    procedure ReadINIData;

    function GetViewTree(view: TView): TVirtualStringTree;
    procedure GetActiveTree(var Tree: TVirtualStringTree);
    procedure Selection(SelState: boolean);
    procedure LocateAuthor(text: String; Tree: TVirtualStringTree);
    procedure InitCollection(ApplyAuthorFilter: Boolean);

    procedure CreateCollectionMenu;
    procedure CreateScriptMenu;
    procedure SetColors;
    procedure CreateAlphabet;

    procedure GetBookRecord(const ID: integer; var R: TBookRecord);

    function IsLibRusecEdit(ID: integer): boolean;

    procedure WMGetSysCommand(var Message :TMessage); message WM_SYSCOMMAND;

  public
    FCancelled : boolean;

    procedure FillAuthorTree(Tree: TVirtualStringTree; FullMode: boolean = False);

    procedure FillGenresTree(Tree: TVirtualStringTree);
    procedure DisableControls(State: boolean);

    function HH(Command: Word; Data: Integer; var CallHelp: Boolean): Boolean;
    procedure LocateBook(text: String; Next : boolean);

    procedure SelectNextBook(Changed, Frwrd: boolean);
    procedure Click;

    property LastActiveBookID: integer read FLastActiveBookID;

  private
    FSelectionState: boolean;
    FCollectionRoot: string;

    FAutoCheck: boolean;
    FFormBusy: boolean;

    FFileOpMode: (fmFb2Zip, fmFb2);
    FDoNotLocate: Boolean;

    FLastLetterA: TToolButton;
    FLastLetterS: TToolButton;

    ALetter: TToolButton;
    BookTreeStatus: (bsFree, bsBusy);

    FSortSettings: array [0..5] of record
      Column: TColumnIndex;
      Direction: TSortDirection;
    end;

    FStarImage: TPngImage;
    FEmptyStarImage: TPngImage;

    FLastFoundBook: PVirtualNode;
    FFirstFoundBook: PvirtualNode;
    FLastBookRecord: TBookRecord;

    //
    function GetBookNode(const Tree: TVirtualStringTree; bookID: Integer): PVirtualNode;

    procedure FillBookIdList(const Tree: TVirtualStringTree; var BookIDList: TBookIdList);
    function GetActiveBookTable(tag: integer): TAbsTable;
    procedure ClearLabels(Tag: integer; Full: boolean);
    procedure SetAuthorsShowLocalOnly;
    procedure SetSeriesShowLocalOnly;
    procedure SetBooksFilter;
    procedure FillAllBooksTree;
    procedure ChangeLetterButton(S: string);
    function CheckLibUpdates(Auto: boolean): Boolean;
    procedure GetActiveViewComponents(var Tree: TVirtualStringTree; var Panel: TMHLInfoPanel; var Cover: TMHLCoverPanel);
    procedure SetCoversVisible(State: boolean);
    procedure RefreshBooksState(Tree: TVirtualStringTree; BookIDList: TBookIdList);
    procedure SetColumns;
    procedure SaveColumns;
    function GetTreeTag(const Sender: TBaseVirtualTree; const Column: integer): integer;
    function GetText(Tag: integer; Data: PBookData): string;
    procedure SetHeaderPopUp;
    procedure RestorePositions;
    procedure DownloadBooks;
    function CheckActiveDownloads:boolean;
    procedure SetLangBarSize;
    procedure TheFirstRun;

    function GetActiveView: TView;
    procedure StartLibUpdate;
    procedure LoadSearchPreset(FN: string);
    procedure CreateGroupsMenu;
    procedure SaveMainFormSettings;
    procedure SavePositions;
    procedure PrepareFb2EditData(Data: PBookData; var R: TBookRecord);
    procedure SaveFb2DataAfterEdit(R: TBookRecord);
    function ShowNCWizard: boolean;
    property ActiveView: TView read GetActiveView;
  end;

var
  frmMain: TfrmMain;

  IsPrivate: Boolean;
  IsOnline: Boolean;
  IsLocal: Boolean;
  IsFB2: Boolean;
  IsNonFB2: Boolean;


const CHECK_FILE = 'TheFirstRun.check';

implementation

uses
  dm_collection,
  dm_user,
  frm_statistic,
  frm_splash,
  frm_settings,
  frm_genre_tree,
  frm_edit_reader,
  frm_edit_book_info,
  frm_edit_author,
  frm_book_info,
  frm_bases,
  frm_add_nonfb2,
  frm_about,
  fictionbook_21,
  unit_MHLHelpers,
  unit_TreeUtils,
  unit_MHL_xml,
  unit_MHL_strings,
  StrUtils,
  unit_Settings,
  unit_Import,
  unit_Consts,
  unit_Export,
  unit_Utils,
  unit_ExportToDevice,
  unit_ExportToDeviceThread,
  unit_Helpers,
  frm_NCWizard,
  DateUtils,
  idStack,
  idException, frm_editor, unit_SearchUtils, frm_search, unit_WriteFb2Info,
  frm_ConverToFBD;

resourcestring
  rstrFileNotFoundMsg = '���� %s �� ������!'#13'��������� ��������� ���������!';

{$R *.dfm}
//
// Helpers
//

const
  TreeIcons : array [0 .. 1] of integer = (10,11);
  TreeHints : array [0 .. 1] of string =(
                                    '������������ � ����� "�������"',
                                    '������������ � ����� "������"'
                                    );


function TfrmMain.CheckActiveDownloads:boolean;
var
  Data : PDownloadData;
  Node : PVirtualNode;
begin
  Result := False;
  Node := tvDownloadList.GetFirst;
  while Node <> nil do
  begin
    Data := tvDownloadList.GetNodeData(Node);
    if Data.State = dsRun then
    begin
      Result := True;
      Break;
    end;
    Node := tvDownloadList.GetNext(Node);
  end;
end;


procedure TfrmMain.WMGetSysCommand(var Message : TMessage) ;
begin
  if Message.Msg = WM_Destroy then
  begin
    ShowMessage('�����������');
    inherited;
  end;

  if (Message.wParam = SC_MINIMIZE) and Settings.MinimizeToTray then
  begin
    TrayIcon.Visible := True;
    Hide;
  end
  else inherited;
end;

procedure TfrmMain.RestorePositions;
var
  APage: integer;
begin
  APage := Settings.ActivePage;

  pgControl.ActivePageIndex := PAGE_AUTHORS;
  edLocateAuthor.Text := Settings.LastAuthor;
  SelectBookById(tvBooksA,Settings.LastBookInAuthors);

  pgControl.ActivePageIndex := PAGE_SERIES;
  edLocateSeries.Text := Settings.LastSeries;
  SelectBookById(tvBooksS,Settings.LastBookInSeries);


  SelectBookById(tvBooksF,Settings.LastBookInFavorites);


  FIgnoreChange := True;
  edLocateAuthor.Text := '';
  edLocateSeries.Text := '';

  FIgnoreChange := False;

  pgControl.ActivePageIndex := APage;

end;


procedure TfrmMain.SetColumns;
var
  Columns : TColumns;

begin
  Columns := TColumns.Create(Settings.WorkPath + 'columns.ini');
  try

    if Settings.TreeModes[PAGE_AUTHORS] = tmTree then
      Columns.Load(SECTION_A_TREE,tmTree)
    else
      Columns.Load(SECTION_A_FLAT,tmFlat);
    Columns.SetColumns(tvBooksA.Header.Columns);


    if Settings.TreeModes[PAGE_SERIES] = tmTree then
      Columns.Load(SECTION_S_TREE,tmTree)
    else
      Columns.Load(SECTION_S_FLAT,tmFlat);
    Columns.SetColumns(tvBooksS.Header.Columns);


    if Settings.TreeModes[PAGE_GENRES] = tmTree then
      Columns.Load(SECTION_G_TREE,tmTree)
    else
      Columns.Load(SECTION_G_FLAT,tmFlat);
    Columns.SetColumns(tvBooksG.Header.Columns);


    if Settings.TreeModes[PAGE_FAVORITES] = tmTree then
      Columns.Load(SECTION_F_TREE,tmTree)
    else
      Columns.Load(SECTION_F_FLAT,tmFlat);
    Columns.SetColumns(tvBooksF.Header.Columns);


    if Settings.TreeModes[PAGE_SEARCH] = tmTree then
      Columns.Load(SECTION_SR_TREE,tmTree)
    else
      Columns.Load(SECTION_SR_FLAT,tmFlat);
    Columns.SetColumns(tvBooksSR.Header.Columns);


    if Settings.TreeModes[PAGE_FILTER] = tmTree then
      Columns.Load(SECTION_FL_TREE,tmTree)
    else
      Columns.Load(SECTION_FL_FLAT,tmFlat);

    //-------------------------------------------------------------------------
    tvBooksA.Header.MainColumn := 1;
    tvBooksS.Header.MainColumn := 1;
    tvBooksG.Header.MainColumn := 1;
    tvBooksF.Header.MainColumn := 1;
    tvBooksSR.Header.MainColumn := 1;

  finally
    Columns.Free;
  end;
end;

procedure TfrmMain.SaveColumns;
var
  Columns: TColumns;

begin
  Columns := TColumns.Create(Settings.WorkPath + 'columns.ini');
  try

    Columns.GetColumns(tvBooksA.Header.Columns);
    if Settings.TreeModes[PAGE_AUTHORS] = tmTree then
      Columns.Save(SECTION_A_TREE)
    else
      Columns.Save(SECTION_A_FLAT);

    Columns.GetColumns(tvBooksS.Header.Columns);
    if Settings.TreeModes[PAGE_SERIES] = tmTree then
      Columns.Save(SECTION_S_TREE)
    else
      Columns.Save(SECTION_S_FLAT);

    Columns.GetColumns(tvBooksG.Header.Columns);
    if Settings.TreeModes[PAGE_Genres] = tmTree then
      Columns.Save(SECTION_G_TREE)
    else
      Columns.Save(SECTION_G_FLAT);

    Columns.GetColumns(tvBooksF.Header.Columns);
    if Settings.TreeModes[PAGE_FAVORITES] = tmTree then
      Columns.Save(SECTION_F_TREE)
    else
      Columns.Save(SECTION_F_FLAT);

    if Settings.TreeModes[PAGE_FILTER] = tmTree then
      Columns.Save(SECTION_FL_TREE)
    else
      Columns.Save(SECTION_FL_FLAT);

    Columns.GetColumns(tvBooksSR.Header.Columns);
    if Settings.TreeModes[PAGE_SEARCH] = tmTree then
      Columns.Save(SECTION_SR_TREE)
    else
      Columns.Save(SECTION_SR_FLAT);

  finally
    Columns.Free;
  end;
end;

procedure TfrmMain.ChangeLetterButton(S: string);
var
  i: integer;
begin
  for I := 0 to RusBar.ControlCount - 1 do
    if RusBar.Controls[i] is TToolButton then
      if (RusBar.Controls[i] as TToolButton).Caption = S then
      begin
        tbtnStarClick(RusBar.Controls[i] as TToolButton);
        Exit;
      end;
  for I := 0 to EngBar.ControlCount - 1 do
    if EngBar.Controls[i] is TToolButton then
      if (EngBar.Controls[i] as TToolButton).Caption = S then
      begin
        tbtnStarClick(EngBar.Controls[i] as TToolButton);
        Exit;
      end;
end;

procedure TfrmMain.SetColors;
var
  BGColor: TColor;
  TreeFontSize: Integer;
  FontColor: TColor;

  procedure SetTreeViewColor(AControl: TVirtualStringTree);
  begin
    AControl.Color := BGColor;
    AControl.Font.Size := TreeFontSize;
    AControl.Font.Color := FontColor;
  end;

  procedure SetEditColor(AControl: TRzEdit);
  begin
    AControl.Color := BGColor;
    AControl.Font.Color := FontColor;
  end;

  procedure SetCBColor(AControl: TRzComboBox);
  begin
    AControl.Color := BGColor;
    AControl.Font.Color := FontColor;
  end;


begin
  BGColor := Settings.BGColor;
  TreeFontSize := Settings.TreeFontSize;
  FontColor := Settings.FontColor;

  cpCoverA.FontSize := Settings.ShortFontSize;
  cpCoverA.AnnotationColor := BGColor;

  cpCoverS.FontSize := Settings.ShortFontSize;
  cpCoverS.AnnotationColor := BGColor;

  cpCoverG.FontSize := Settings.ShortFontSize;
  cpCoverG.AnnotationColor := BGColor;

  cpCoverF.FontSize := Settings.ShortFontSize;
  cpCoverF.AnnotationColor := BGColor;

  cpCoverSR.FontSize := Settings.ShortFontSize;
  cpCoverSR.AnnotationColor := BGColor;


  SetTreeViewColor(tvAuthors);
  SetTreeViewColor(tvBooksA);
  SetTreeViewColor(tvBooksS);
  SetTreeViewColor(tvBooksG);
  SetTreeViewColor(tvBooksSR);
  SetTreeViewColor(tvBooksF);
  SetTreeViewColor(tvSeries);
  SetTreeViewColor(tvGenres);
  SetTreeViewColor(tvGroups);
  SetTreeViewColor(tvDownloadList);

  SetEditColor(edLocateAuthor);
  SetEditColor(edLocateSeries);

  SetEditColor(edFFullName);
  SetEditColor(edFTitle);
  SetEditColor(edFSeries);
  SetEditColor(edFGenre);
  SetEditColor(edFFile);
  SetEditColor(edFFolder);
  SetEditColor(edFExt);
  SetEditColor(edFKeyWords);

  SetCBColor(cbDownloaded);
  SetCBColor(cbDate);
  SetCBColor(cbLang);

end;

procedure TfrmMain.ReadINIData;
const CHECK_FILE = 'TheFirstRun.check';
     ROOT = 'HKEY_CURRENT_USER';
     Key  = '\Software\Microsoft\Windows\CurrentVersion\Internet Settings';
var
 regini : TRzRegIniFile;
 IETempStr, IEProxy, IEPort : String;
 i, colonpos : integer;

begin

  CreateSettings;
  Settings.LoadSettings;

  WindowState := Settings.WindowState;

  if WindowState = wsNormal then
  begin
    Width := Settings.FormWidth;
    Height := Settings.FormHeight;
  end;

  SetColors;

  tlbrEdit.Visible := Settings.EditToolbarVisible;
  miEditToolbarVisible.Checked := tlbrEdit.Visible;

  RusBar.Visible := Settings.ShowRusBar;
  EngBar.Visible := Settings.ShowEngBar;

  tbtnShowDeleted.Down := Settings.DoNotShowDeleted ;
  tbtnShowLocalOnly.Down := Settings.ShowLocalOnly ;

  cbDeleted.Checked := Settings.DoNotShowDeleted;

  CreateScriptMenu;
  if Settings.DefaultScript <> 0 then
  begin
    tbSendToDevice.Tag := 900 + Settings.DefaultScript;
    pmiSendToDevice.Tag := 900 + Settings.DefaultScript;
    miDevice.Tag := 900 + Settings.DefaultScript;
  end
  else
  begin
    tbSendToDevice.Tag := 0;
    pmiSendToDevice.Tag := 0;
    miDevice.Tag := 0;
  end;

  cpCoverA.TmpFolder := Settings.TempPath;
  cpCoverS.TmpFolder := Settings.TempPath;
  cpCoverG.TmpFolder := Settings.TempPath;
  cpCoverF.TmpFolder := Settings.TempPath;
  cpCoverSR.TmpFolder := Settings.TempPath;

  cpCoverA.Fb2InfoVisible := Settings.ShowFb2Info;
  cpCoverS.Fb2InfoVisible := Settings.ShowFb2Info;
  cpCoverG.Fb2InfoVisible := Settings.ShowFb2Info;
  cpCoverF.Fb2InfoVisible := Settings.ShowFb2Info;
  cpCoverSR.Fb2InfoVisible := Settings.ShowFb2Info;

  rzsSplitterA.Position := Settings.Splitters[0];
  rzsSplitterS.Position := Settings.Splitters[1];
  rzsSplitterG.Position := Settings.Splitters[2];
  rzsSplitterSR.Position := Settings.Splitters[3];

  ctpBook.Collapsed := Settings.BookSRCollapsed;
  ctpFile.Collapsed := Settings.FileSRCollapsed;
  ctpOther.Collapsed := Settings.OtherSRCollapsed;

  cpCoverA.Width := Settings.CoverWidth;


   // Check IE Proxy settings   (by Goblin)
  if Settings.UseIESettings then
  try
    regini := TRzRegIniFile.Create(self);
    regini.PathType := ptRegistry;
    regini.Path := ROOT;
    if regini.ReadInteger(Key, 'ProxyEnable', 0) = 1 then
    begin
      IETempStr := regini.ReadString(Key, 'ProxyServer', '');
      if IETempStr <> '' then
        for i := 1 to Length(IETempStr) do
          if IETempStr[i] = ':' then colonpos := i;
      IEProxy := ANSILeftStr(IETempStr, colonpos-1);
      IEPort := ANSIRightStr(IETempStr, Length(IETempStr)-colonpos);

      Settings.IEProxyServer := IEProxy;
      Settings.IEProxyPort := StrToInt(IEPort);
    end;
  except
    //  ���-�� ����� �� ��� ...
  end;
  // End check IE Proxy settings
end;

procedure TfrmMain.btnApplyFilterClick(Sender: TObject);
var FilterString: String;
    SeriesFilter: String;
    OldFilter: String;
    Filtered: boolean;

const

//  SQLStartStr = 'select distinct ' +
//                'b.Id, b.Title, b.SerID, b.FullName, b.FileName, b.Folder, b.Ext, ' +
//                'b.DatabaseID, b.DiscID, b.LibID, b.InsideNo, b.URI, b.KeyWords, b.Code, ' +
//                'b.SeqNumber, b.Size, b.Date, b.Local, b.Lang, b.LibRate, b.Deleted ';
  SQLStartStr = 'SELECT distinct b.*'  ;
begin
  Screen.Cursor := crSQLWAit;
  spStatus.Caption := '���������� ������� ...'; spStatus.Repaint;
  tvBooksSR.Clear;
  lblTotalBooksFL.Caption := '(0)';
  FilterString := '';
  ClearLabels(tvBooksSR.Tag, True);

  dmCollection.sqlBooks.SQL.Clear;

  try
    try

      OldFilter := dmCollection.tblBooks.Filter;
      Filtered :=  dmCollection.tblBooks.Filtered;


      //------------------------ ����� -----------------------------------------

      FilterString := '';
      AddToFilter('`S_Title`', PrepareQuery(edFSeries.Text, True), True, FilterString);

      if FilterString <> '' then
           FilterString := SQLStartStr + #13#10 +
                           'FROM Series s ' + #13#10 +
                           'JOIN books b on b.SerID = s.S_Id ' + #13#10 +
                           'WHERE ' + FilterString + '';

      if FilterString <> '' then
           dmCollection.sqlBooks.SQL.Add(FilterString);

      FilterString := '';

      //-------------------------- ���� ----------------------------------------

      if (edFGenre.Hint <> '') then
           FilterString := SQLStartStr + #13#10 +
                           'FROM Genre_List g ' + #13#10 +
                           'JOIN books b on b.id = g.gl_bookid ' + #13#10 +
                           'WHERE (' + edFGenre.Hint + ')';


      if (dmCollection.sqlBooks.SQL.Count = 0) and (FilterString <> '') then
        dmCollection.sqlBooks.SQL.Add(FilterString)
      else
        if FilterString <> '' then
        begin
          dmCollection.sqlBooks.SQL.Add('INTERSECT');
          dmCollection.sqlBooks.SQL.Add(FilterString);
        end;

      FilterString := '';

      //-------------------  ��� ���������   -----------------------------------
      AddToFilter('`FullName`', PrepareQuery(edFFullName.Text, True), True, FilterString);
      AddToFilter('`Title`', PrepareQuery(edFTitle.Text, True), True, FilterString);
      AddToFilter('`FileName`', PrepareQuery(edFFile.Text, False),False, FilterString);
      AddToFilter('`Folder`', PrepareQuery(edFFolder.Text, False), False, FilterString);
      AddToFilter('`ext`', PrepareQuery(edFExt.Text, False), False, FilterString);
      AddToFilter('`Lang`', PrepareQuery(AnsiUpperCase(cbLang.Text), True, False), True, FilterString);
      AddToFilter('`KeyWords`', PrepareQuery(edFKeyWords.Text, True), True, FilterString);
//
      if cbDate.ItemIndex = -1 then
        AddToFilter('`Date`',PrepareQuery(cbDate.Text,False),False, FilterString)
      else
        case cbDate.ItemIndex of
          0:AddToFilter('`Date`',Format('> "%s"',[DateToStr(IncDay(Now,- 1))]),False, FilterString);
          1:AddToFilter('`Date`',Format('> "%s"',[DateToStr(IncDay(Now,- 3))]),False, FilterString);
          2:AddToFilter('`Date`',Format('> "%s"',[DateToStr(IncDay(Now,- 7))]),False, FilterString);
          3:AddToFilter('`Date`',Format('> "%s"',[DateToStr(IncDay(Now,- 14))]),False, FilterString);
          4:AddToFilter('`Date`',Format('> "%s"',[DateToStr(IncDay(Now,- 30))]),False, FilterString);
          5:AddToFilter('`Date`',Format('> "%s"',[DateToStr(IncDay(Now,- 90))]),False, FilterString);
        end;

      case cbDownloaded.ItemIndex of
        1:if (FilterString = '') then
            FilterString := '(`Local` = True)'
          else
            FilterString := FilterString + ' AND (`Local` = True)';
        2:if (FilterString = '') then
            FilterString := '(`Local` = False)'
          else
            FilterString := FilterString + ' AND (`Local` = False)';
      end;

      if cbDeleted.Checked then
        if (FilterString = '') then
          FilterString := '(`Deleted` = False)'
      else
          FilterString := FilterString + ' AND (`Deleted`= False)';

      // ������ ������
      spStatus.Caption := '��������� ������ ...'; spStatus.Repaint;

      if (dmCollection.sqlBooks.SQL.Count > 0) and (FilterString <> '') then
        dmCollection.sqlBooks.SQL.Add('AND ' + FilterString)
      else
      if FilterString <> '' then
           dmCollection.sqlBooks.SQL.Add('SELECT * FROM Books WHERE ' + FilterString);

      if (dmCollection.sqlBooks.SQL.Count)=0 then
            raise Exception.Create('��������� ��������� �������');

      {$IFDEF DEBUG}
      dmCollection.sqlBooks.SQL.SaveToFile(Settings.AppPath + 'Last.sql');
      {$ENDIF}

      dmCollection.sqlBooks.Active := False;
      dmCollection.sqlBooks.ExecSQL;
      dmCollection.sqlBooks.Active := True;

      FillBooksTree(0, tvBooksSR, nil, dmCollection.sqlBooks, True, True);
    except
      on E: Exception do
        ShowMessage('�������������� ������. ��������� ��������� �������');
    end;
  finally
    dmCollection.tblBooks.Filtered := False;
    dmCollection.tblBooks.Filter := OldFilter;
    dmCollection.tblBooks.Filtered := Filtered;

    Screen.Cursor := crDefault;
    spStatus.Caption := '������.';
    ClearLabels(PAGE_FILTER, True);
  end;
end;

procedure TfrmMain.btnClearFilterEditsClick(Sender: TObject);
begin
  edFFullName.Text  :='';
  edFSeries.Text    :='';
  edFTitle.Text     := '';
  edFGenre.Text     := '';
  edFGenre.Hint     := '';
  edFFile.Text      := '';
  edFFolder.Text    := '';
  edFExt.Text       := '';

  cbDate.Text       := '';
  cbDate.ItemIndex  := -1;

  cbPresetName.Text := '';
  cbDeleted.Checked := False;
  cbLang.Text       := '';
  edFKeyWords.Text  := '';
  cbDownloaded.ItemIndex := 0;
  tvBooksSR.Clear;
  ClearLabels(PAGE_SEARCH, True);
end;

procedure TfrmMain.LoadSearchPreset(FN: string);
var
  SL : TStringList;
  HL : TStringList;
begin
  SL := TStringList.Create;
  HL := TStringList.Create;
  try
    HL.Delimiter := ';';
    HL.QuoteChar := '~';

    SL.LoadFromFile(Settings.PresetPath + FN + '.mhlf');
    HL.DelimitedText := SL.Text;

    edFFullName.Text := HL[0];
    edFTitle.Text := HL[1];
    edFSeries.Text := HL[2];
    edFGenre.Text  := HL[3];
    edFGenre.Hint  := HL[4];
    edFFile.Text := HL[5];
    edFFolder.Text := HL[6];
    edFExt.Text := HL[7];
    cbDate.Text := HL[8];
    cbDownloaded.Text := HL[9];
    cbDeleted.Checked := StrToBool(HL[10]);
    cbLang.Text := HL[11];
    edFKeyWords.Text := HL[12];
  finally
    HL.Free;
    SL.Free;
  end;
end;

function TfrmMain.GetActiveView: TView;
const
  //
  // ��������!!! ������� � ���������� ��������� ������� views ������ ��������� � �������� � ����������� ��������
  //
  views: array[0..5] of TView = (
    ByAuthorView,
    BySeriesView,
    ByGenreView,
    SearchView,
    FavoritesView,
    DownloadView
    );

begin
  Result := views[pgControl.ActivePageIndex];
end;

procedure TfrmMain.DisableControls(State: boolean);
begin
  frmMain.Enabled := State;
end;

procedure TfrmMain.InitCollection(ApplyAuthorFilter: Boolean);
var
  CollectionType: Integer;
begin
  FDoNotLocate := True;
  Screen.Cursor := crHourGlass;

  ClearLabels(PAGE_ALL, True);
  dmCollection.SetTableState(False);
  tvGenres.Clear;
  tvbooksG.Clear;
  dmCollection.DBCollection.Connected := False;

  edLocateAuthor.Text := '';
  edLocateSeries.Text := '';

  if DMUser.tblBases.IsEmpty then
  begin
    frmMain.Caption := 'MyHomeLib';
    tvAuthors.Clear;
    tvSeries.Clear;
    tvBooksA.Clear;
    tvBooksS.Clear;
    tvBooksG.Clear;
    tvBooksSR.Clear;
    tvBooksF.Clear;
    Screen.Cursor := crDefault;

    if not ShowNCWizard then Application.Terminate;

    DeleteFile(Settings.WorkPath + CHECK_FILE);
    Exit;
  end;

  dmCollection.DBCollection.DatabaseFileName := DMUser.ActiveCollection.DBFileName;
  dmCollection.DBCollection.Connected := True;
  frmMain.Caption := 'MyHomeLib - ' + DMUser.ActiveCollection.Name;

  { TODO -oNickR -cRefactoring : ��������� ������������� }
  FCollectionRoot := IncludeTrailingPathDelimiter(DMUser.ActiveCollection.RootFolder);

  // ���������� ���� ���������
  CollectionType := DMUser.ActiveCollection.CollectionType;
  IsPrivate := isPrivateCollection(CollectionType);
  IsOnline := isOnlineCollection(CollectionType);
  IsLocal := isLocalCollection(CollectionType);
  IsFB2 := isFB2Collection(CollectionType);
  IsNonFB2 := isNonFB2Collection(CollectionType);

  //----------------------------------------------------------------------------
  // ��������� ��������� ������� ���� � ����������� �� ���� ���������
  //----------------------------------------------------------------------------

  //------    ������� ����   ---------------------------------------------------

  // �����

  miFb2ZipImport.Visible := (IsPrivate and IsFB2) or (IsPrivate and IsNonFB2 and Settings.AllowMixed);
  miFb2Import.Visible := (IsPrivate and IsFB2) or (IsPrivate and IsNonFB2 and Settings.AllowMixed);
  miPdfdjvu.Visible := IsPrivate and IsNonFB2;
  miFBDImport.Visible := IsPrivate and IsNonFB2;
  miConverToFBD.Visible := False;

  miImport.Visible := IsPrivate;
  miEditAuthor.Visible := IsPrivate;
  miEditGenres.Visible := IsPrivate;
  miEditSeries.Visible := IsPrivate;
  miBookEdit.Visible := IsPrivate;
  miConverToFBD.Visible := IsPrivate  and not IsFB2;
  miDeleteBook.Visible := IsPrivate; // DMUser.ActiveCollection.AllowDelete;
  miDeleteFiles.Visible := isOnline and (ActiveView <> FavoritesView);

  miDownloadBooks.Visible := IsOnline;

  // ���������

  // �����������

  miSyncOnline.Visible := IsOnline or IsNonFb2;

  //-------- ����������� ���� --------------------------------------------------

  pmiBookInfo.Visible := IsFB2;
  pmiDownloadBooks.Visible := IsOnline;

  //--------- ������ ������������ ----------------------------------------------
  tbtnShowLocalOnly.Visible := IsOnline;
  tbtnDownloadList_Add.Visible := IsOnline;
  tbtnShowDeleted.Visible := not IsPrivate;

  tbtnFBD.Visible := IsPrivate and not IsFB2;
  tbtnAutoFBD.Visible := IsPrivate and not IsFB2;

  tbtnDeleteBook.Visible := IsPrivate;
  tbtnEditSeries.Visible := IsPrivate;
  tbtnEditGenre.Visible := IsPrivate;
  tbtnEditAuthor.Visible := IsPrivate;

  //--------- �������, ������  -------------------------------------------------

  TabSheet7.TabVisible := IsOnline;

  //----------------------------------------------------------------------------

  CreateCollectionMenu;
  dmCollection.SetTableState(True);

  if Assigned(FLastLetterA) then
    FLastLetterA.Down := False;

  dmCollection.tblAuthors.Filtered := False;
  if ApplyAuthorFilter then
    if dmCollection.tblAuthors.RecordCount > 500 then
    begin
      dmCollection.tblAuthors.Filter := 'A_Family="�*"';
      dmCollection.tblAuthors.Filtered := True;
      ALetter.Down := True;
      FLastLetterA := ALetter;
      edLocateAuthor.Text := '�';
    end
    else
    begin
      dmCollection.tblAuthors.Filtered := False;
      tbtnStar.Down := True;
      FLastLetterA := tbtnStar;
      edLocateAuthor.Text := '';
    end;

//  SetCoversVisible((not IsNonFB2 and Settings.ShowInfoPanel)
//                   or (Settings.AllowMixed and Settings.ShowInfoPanel));

  if IsNonFB2 and not IsPrivate then SetCoversVisible(false)
    else SetCoversVisible(Settings.ShowInfoPanel);

  SetAuthorsShowLocalOnly;
  SetSeriesShowLocalOnly;
  SetBooksFilter;

  FillAuthorTree(tvAuthors);
  FillSeriesTree;
  FillGenresTree(tvGenres);

  FillAllBooksTree;

  tvBooksSR.Clear;

  Screen.Cursor := crDefault;
  DMUser.ActivateCollection(Settings.ActiveCollection);
  FDoNotLocate := False;
  CreateScriptMenu;
  FIgnoreChange := False;

  if not IsOnline and (ActiveView = DownloadView) then
    pgControl.ActivePageIndex := PAGE_AUTHORS;

end;

procedure TfrmMain.GetBookRecord(const ID: integer; var R: TBookRecord);
begin
  dmCollection.tblBooks.Locate('ID', ID, []);

  dmCollection.GetCurrentBook(R);
end;

procedure TfrmMain.CreateAlphabet;
const
  E : string = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  R : string = '�����Ũ�����������������������';
var
  i: integer;
  B: TToolButton;
begin
  for I := 1 to Length(E) do
  begin
    B := TToolButton.Create(EngBar);
    B.Caption := E[i];
    B.Left := 100 + i * 27;
    B.Width := 25;
    B.Height := 25;
    B.Style := tbsTextButton;
    B.OnClick := tbtnStarClick;
    EngBar.InsertControl(B);
  end;

  for I := 1 to Length(R) do
  begin
    B := TToolButton.Create(RusBar);
    B.Caption := R[i];
    B.Left := 100 + i * 27;
    B.Width := 25;
    B.Height := 25;
    B.Style := tbsTextButton;
    B.OnClick := tbtnStarClick;
    RusBar.InsertControl(B);
    if R[i] = '�' then
      ALetter := B;
  end;
end;

procedure TfrmMain.CreateCollectionMenu;
var
  ItemL, ItemC, ItemP: TMenuItem;
  i, j, k: integer;
  CollectionType: COLLECTION_TYPE;
  Active: integer;

  function GetCollectionTypeImageIndex: Integer;
  begin
    case DMUser.ActiveCollection.CollectionType of
      CT_PRIVATE_FB: Result := 18;
      CT_PRIVATE_NONFB: Result := 8;
      CT_LIBRUSEC_LOCAL_FB: Result := 14;
      CT_LIBRUSEC_ONLINE_FB: Result := 4;
      CT_GENESIS_LOCAL_NONFB: Result := 8;    { TODO -oNickR -cUsability : ���������� ������ }
      CT_GENESIS_ONLINE_NONFB: Result := 8;   { TODO -oNickR -cUsability : ���������� ������ }
      CT_LIBRUSEC_USR: Result := 8;
    else
//      Assert(False);
      Result := 8;                             { TODO -oNickR -cUsability : ���������� ������ }
    end;
  end;

begin
  CollectionType := DMUser.ActiveCollection.CollectionType;
  Active := DMUser.ActiveCollection.ID;
  miCollSelect.Clear;
  miCopyToCollection.Clear;
  pmCollection.Items.Clear;
  DMUser.tblBases.First;
  i := 0; j := 0; k := 0;
  while not DMUser.tblBases.Eof do
  begin
    //----------------------------
    ItemL := TMenuItem.Create(miCollSelect);
    ItemL.Caption := DMUser.ActiveCollection.Name;
    ItemL.Tag := DMUser.ActiveCollection.ID;
    ItemL.OnClick := miActiveCollectionClick;
    ItemL.ImageIndex := GetCollectionTypeImageIndex;

    if ItemL.Tag <> Active then
    begin
      miCollSelect.Insert(i, ItemL);
      inc(i);
    end;

    //----------------------------
    ItemP := TMenuItem.Create(pmCollection);
    ItemP.Caption := DMUser.ActiveCollection.Name;
    ItemP.Tag := DMUser.ActiveCollection.ID;
    ItemP.OnClick := miActiveCollectionClick;
    ItemP.ImageIndex := GetCollectionTypeImageIndex;

    if ItemP.Tag <> Active then
    begin
      pmCollection.Items.Insert(k, ItemP);
      Inc(k);
    end;

    //----------------------------------
    ItemC := TMenuItem.Create(miCopyToCollection);
    ItemC.Caption := DMUser.ActiveCollection.Name;
    ItemC.Tag := DMUser.ActiveCollection.ID;
    ItemC.OnClick := CopyToCollectionClick;
    ItemC.ImageIndex := GetCollectionTypeImageIndex;

    if (ItemC.Tag <> Active) and
      isPrivateCollection(DMUser.ActiveCollection.CollectionType) and
      (isFB2Collection(DMUser.ActiveCollection.CollectionType) and IsFB2 )
    then
    begin
      miCopyToCollection.Insert(j, ItemC);
      Inc(j);
    end;

    //----------------------------------------------------------------------
    DMUser.tblBases.Next;
  end;

  miCopyToCollection.Enabled := (j > 0);
  miCollSelect.Enabled := (i > 0);

  DMUser.ActivateCollection(Active);
end;

procedure TfrmMain.CreateGroupsMenu;
var
  Item, ItemP : TMenuItem;
  i: integer;
begin
  pmGroups.Items.Clear;
  pmiGroups.Clear;

  i := 0;
  DMUser.tblGroupList.First;
  DMUser.tblGroupList.Next; // ���������� "���������"
  while not DMUser.tblGroupList.Eof do
  begin
    // ���� ��� ������
    Item := TMenuItem.Create(pmGroups);
    Item.Caption := DMUser.tblGroupListName.Value;
    Item.Tag := DMUser.tblGroupListID.Value;
    Item.OnClick := GroupMenuItemClick;
    pmGroups.Items.Insert(i, Item);

    // ������� ��� ������������
    ItemP := TMenuItem.Create(pmMain);
    ItemP.Caption := DMUser.tblGroupListName.Value;
    ItemP.Tag := DMUser.tblGroupListID.Value;
    ItemP.OnClick := GroupMenuItemClick;
    pmiGroups.Insert(i, ItemP);
    inc(i);
    DMUser.tblGroupList.Next;
  end;
end;

procedure TfrmMain.CreateScriptMenu;
const
    ExpTypes : array [0..3] of string = ('  fb2','  fb2.zip','  LRF','  txt');
    Icons: array [0..3] of integer = (18,19,20,21);
var
  Item, ItemP, ItemM: TMenuItem;
  F:integer;
  i: Integer;
begin
  pmScripts.Items.Clear;
  pmiScripts.Clear;
  mmiScripts.Clear;


  if isFB2Collection(DMUser.ActiveCollection.CollectionType) then
  begin
    for I := 0 to 3 do
    begin
      Item := TMenuItem.Create(pmScripts);
      Item.Caption := ExpTypes[i];
      Item.Tag := 850 + i;
      Item.OnClick := tbSendToDeviceClick;
      Item.ImageIndex := i;
      pmScripts.Items.Insert(i, Item);
    end;

    if Settings.Scripts.Count > 0 then
    begin
      Item := TMenuItem.Create(pmScripts);
      Item.Caption := '-';
      Item.Tag := 0;
      pmScripts.Items.Insert(4, Item);
    end;

    tbSendToDevice.ImageIndex := Icons[ord(Settings.ExportMode)];
//    pmScripts.Items[i].Caption := '>> ' + ExpTypes[i] + ' <<';
    F := 5;
  end
  else
  begin
    F := 0;
    tbSendToDevice.ImageIndex := 1;
  end;
  

  { TODO 1 -oNickR -cRefactoring :�������� ���� ��� �� �������� TFileRun}
  for i := 0 to Settings.Scripts.Count - 1 do
  begin
    //----  dropdown ----------------
    Item := TMenuItem.Create(pmScripts);
    Item.Caption := Settings.Scripts[i].Title;
    Item.Tag := 901 + i;
    Item.OnClick := tbSendToDeviceClick;
    Item.ImageIndex := 4;
    pmScripts.Items.Insert(i + F, Item);

    //------ context -----------------
    ItemP := TMenuItem.Create(pmMain);
    ItemP.Caption := Settings.Scripts[i].Title;
    ItemP.Tag := 901 + i;
    ItemP.OnClick := tbSendToDeviceClick;
    pmiScripts.Insert(i, ItemP);

    //------ main -----------------
    ItemM := TMenuItem.Create(MainMenu);
    ItemM.Caption := Settings.Scripts[i].Title;
    ItemM.Tag := 901 + i;
    ItemM.OnClick := tbSendToDeviceClick;
    mmiScripts.Insert(i, ItemM);
  end;

  if pmiScripts.Count > 0 then
  begin
    mmiScripts.Visible := True;
    pmiScripts.Visible := True;
  end
  else
  begin
    mmiScripts.Visible := False;
    pmiScripts.Visible := False;
  end
end;

function TfrmMain.ShowNCWizard:boolean;
var
  frmNCWizard: TfrmNCWizard;
begin
  frmNCWizard := TfrmNCWizard.Create(Application);
  try
    if frmNCWizard.ShowModal = mrOk then
    begin
      Settings.ActiveCollection := DMUser.ActiveCollection.ID;
      CreateCollectionMenu;
      InitCollection(True);
      Result := True;
    end
    else
      Result := False;
  finally
    frmNCWizard.Free;
  end;
end;

procedure TfrmMain.ShowNewCollectionWizard(Sender: TObject);
begin
  ShowNCWizard;
end;


procedure TfrmMain.btnSwitchTreeModeClick(Sender: TObject);
var
  Page: integer;
begin
  SaveColumns;

  Page := pgControl.ActivePageIndex;

  if Settings.TreeModes[Page] = tmFlat then
    Settings.TreeModes[Page] := tmTree
  else
    Settings.TreeModes[Page] := tmFlat;

  btnSwitchTreeMode.ImageIndex := TreeIcons[ord(Settings.TreeModes[pgControl.ActivePageIndex])];
  btnSwitchTreeMode.Hint := TreeHints[ord(Settings.TreeModes[pgControl.ActivePageIndex])];
  
  SetColumns;

  case Page of
    0: FillBooksTree(0, tvBooksA, dmCollection.tblAuthor_List, dmCollection.tblBooksA,    False, True); // ������
    1: FillBooksTree(0, tvBooksS,                   nil, dmCollection.tblBooksS,    False, False); // �����
    2: FillBooksTree(0, tvBooksG,  dmCollection.tblGenre_List, dmCollection.tblBooksG,    True,  True); // �����
    3: FillBooksTree(0, tvBooksSR, nil, dmCollection.sqlBooks, True, True);
    4: FillBooksTree(0, tvBooksF,                   nil, DMUser.tblGrouppedBooks, True,  True); // ���������
    5: btnApplyFilterClick(Self);
  end;

  SetHeaderPopUp;
end;


procedure TfrmMain.ClearLabels(Tag: integer; Full: boolean);
begin
  case Tag of
    PAGE_AUTHORS:
    begin
      ipnlAuthors.Clear;
      cpCoverA.Clear;
      if Full then lblAuthor.Caption := '';
    end;

    PAGE_SERIES:
    begin
      ipnlSeries.Clear;
      cpCoverS.Clear;
      lblSeries.Caption := '';
    end;

    PAGE_GENRES:
    begin
      ipnlGenres.Clear;
      cpCoverG.Clear;
    end;

    PAGE_FAVORITES:
    begin
      ipnlFAVORITES.Clear;
      cpCoverF.Clear;
    end;

    PAGE_SEARCH:
    begin
      ipnlSearch.Clear;
      cpCoverSR.Clear;
      lblTotalBooksFL.Caption := '()';
    end;

    PAGE_ALL:
    begin
      ClearLabels(PAGE_AUTHORS, True);
      ClearLabels(PAGE_SERIES, True);
      ClearLabels(PAGE_GENRES, True);
      ClearLabels(PAGE_FAVORITES, True);
      ClearLabels(PAGE_FILTER, True);
      ClearLabels(PAGE_SEARCH, True);
    end;
  end;
end;

procedure TfrmMain.Click;
var
  Tree: TVirtualStringTree;
begin
  GetActiveTree(Tree);
  Tree.Perform(WM_LBUTTONDOWN, 0, 0);
  Tree.Perform(WM_LBUTTONUP, 0, 0);
end;

procedure  TfrmMain.SetAuthorsShowLocalOnly;
begin
  if isOnlineCollection(DMUser.ActiveCollection.CollectionType) then
    begin
      if Settings.ShowLocalOnly then
        dmCollection.tblAuthors.ParamByName('All').AsInteger := 1
      else
        dmCollection.tblAuthors.ParamByName('All').AsInteger := 0;
      dmCollection.tblAuthors.Close;
      Screen.Cursor := crHourGlass;
      dmCollection.tblAuthors.Open;
      Screen.Cursor := crDefault;
    end
  else
    begin
      dmCollection.tblAuthors.ParamByName('All').AsInteger := 0;
      dmCollection.tblAuthors.Close;
      Screen.Cursor := crHourGlass;
      dmCollection.tblAuthors.Open;
      Screen.Cursor := crDefault;
    end;
end;

procedure  TfrmMain.SetSeriesShowLocalOnly;
begin
  if isOnlineCollection(DMUser.ActiveCollection.CollectionType) then
    begin
      if Settings.ShowLocalOnly then
        dmCollection.tblSeries.ParamByName('All').AsInteger := 1
      else
        dmCollection.tblSeries.ParamByName('All').AsInteger := 0;
      dmCollection.tblSeries.Close;
      Screen.Cursor := crHourGlass;
      dmCollection.tblSeries.Open;
      Screen.Cursor := crDefault;
    end
  else
    begin
      dmCollection.tblSeries.ParamByName('All').AsInteger := 0;
      dmCollection.tblSeries.Close;
      Screen.Cursor := crHourGlass;
      dmCollection.tblSeries.Open;
      Screen.Cursor := crDefault;
    end;
end;

procedure  TfrmMain.SetBooksFilter;
const
   flLocal = '`Local` = True';
   flNotShowDeleted = '`Deleted` <> True';


      procedure SwitchFilter(Filter: string);
      var
        State : boolean;
      begin
        State := (Filter <> '');

        dmCollection.tblBooksA.Filter := Filter;
        dmCollection.tblBooksG.Filter := Filter;
        dmCollection.tblBooksS.Filter := Filter;
        DMUser.tblGrouppedBooks.Filter := Filter;

        dmCollection.tblBooksA.Filtered := State;
        dmCollection.tblBooksG.Filtered := State;
        dmCollection.tblBooksS.Filtered := State;
        DMUser.tblGrouppedBooks.Filtered := State;
      end;

begin
  if isOnlineCollection(DMUser.ActiveCollection.CollectionType) then
  begin
    if Settings.DoNotShowDeleted and Settings.ShowLocalOnly then
      SwitchFilter(flLocal + ' and ' + flNotShowDeleted)
    else if Settings.DoNotShowDeleted and not Settings.ShowLocalOnly then
      SwitchFilter(flNotShowDeleted)
    else if not Settings.DoNotShowDeleted and Settings.ShowLocalOnly then
      SwitchFilter(flLocal)
    else if not Settings.DoNotShowDeleted and not Settings.ShowLocalOnly then
      SwitchFilter('') ;
  end
  else
    if Settings.DoNotShowDeleted then
      SwitchFilter(flNotShowDeleted)
    else
      SwitchFilter('');
end;

procedure TfrmMain.FilesListFile(Sender: TObject; const F: TSearchRec);
var
  S: string;
begin
  if ExtractFileExt(F.Name) = '.mhlf' then
  begin
    S := ExtractFileName(F.Name);
    Delete(S, Length(S) - 4 , 5);
    cbPresetName.Items.Add(S);
  end;
end;

procedure  TfrmMain.FillAllBooksTree;
begin
  FillBooksTree(0, tvBooksA, dmCollection.tblAuthor_List, dmCollection.tblBooksA,    False, True); // ������
  FillBooksTree(0, tvBooksS,                   nil, dmCollection.tblBooksS,    False, False); // �����
  FillBooksTree(0, tvBooksG,  dmCollection.tblGenre_List, dmCollection.tblBooksG,    True,  True); // �����
  FillBooksTree(0, tvBooksF,                   nil, DMUser.tblGrouppedBooks, True,  True); // ���������

//  if DMCollection.sqlBooks.Active then
//    FillBooksTree(0, tvBooksSR, nil, dmCollection.sqlBooks, True, True);

end;

function TfrmMain.CheckLibUpdates(Auto: boolean): Boolean;
var
  Active: Integer;
  i: integer;
begin

  if not Auto then ShowPopup('�������� ���������� ...');

  Result := False;

  Active := DMUser.ActiveCollection.ID;

  Settings.Updates.CheckVersions;

  DMUser.FindFirstCollection;
  repeat
    for I := 0 to Settings.Updates.Count - 1 do
      if Settings.Updates.Items[i].CheckCodes(DMUser.ActiveCollection.Name,
                                              DMUser.ActiveCollection.CollectionType,
                                              DMUser.ActiveCollection.ID)
      then
        if Settings.Updates.Items[i].CheckVersion(Settings.WorkPath, DMUser.ActiveCollection.Version) then
        begin
          Result := True;
          Break;
        end;
  until not DMUser.FindNextCollection;
  DMUser.ActivateCollection(Active);

  if not Auto then
  begin
    HidePopup;
    if not Result then ShowMessage('��� ��������� ����������');
  end;
end;

procedure TfrmMain.SetLangBarSize;
begin
    // ���������� ����� � ����������� ��������
  rpLang.Visible := rusBar.Visible or engBar.Visible;
  if (rusBar.Visible and not engBar.Visible) or
     (not rusBar.Visible and engBar.Visible)
  then
    rpLang.Height := rusBar.Height + 5
  else
    rpLang.Height := 2 * rusBar.Height + 10;
end;

procedure TfrmMain.TheFirstRun;
begin
  if  DMUser.tblBases.IsEmpty then
    DeleteFile(Settings.WorkPath + CHECK_FILE)
  else
  if FileExists(Settings.WorkPath + CHECK_FILE) and
     (Application.MessageBox('�� ������� �������� ���������. ��� ���������� ������ ����������' + #13 +
                '�������� ��������� ������ ��. ������� ��� ����� ������?',
                'MyHomeLib - ������ ������',mb_YesNo) = mrYes) then
  begin
    RenameFile(Settings.SystemFileName[sfLibRusEcinpx],Settings.SystemFileName[sfLibRusEcUpdate]);
    DeleteFile(Settings.WorkPath + CHECK_FILE);
    if unit_utils.LibrusecUpdate then
      InitCollection(True);
  end;
end;

procedure TfrmMain.tbtnAutoFBDClick(Sender: TObject);
begin
  if (ActiveView = FavoritesView) or (ActiveView = DownloadView) then
  begin
    MessageDlg('��� ����������� ����� ��������� ' + #13 + '� ��������������� ���������', mtWarning, [mbOk], 0);
    Exit;
  end;

  DisableControls(False);
  try
    frmConvertToFBD.AutoMode;
  finally
    DisableControls(True);
    Show;
  end;
end;

//
// ������� �����
//

procedure TfrmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  CanClose := True;
  if CheckActiveDownloads then
    if MessageDlg('� ������ ���� ������������� �������!' + #13 +
                  '�� ��� ��� ������ ����� �� ���������?', mtWarning, mbYesNo, 0) = mrYes then
      begin
        if Assigned(FDMThread) then FDMThread.TerminateNow;
      end
    else
      CanClose := False;
end;

procedure TfrmMain.StartLibUpdate;
begin
  if unit_utils.LibrusecUpdate then
    InitCollection(True);
end;


procedure TfrmMain.FormCreate(Sender: TObject);
begin
  Application.OnHelp := HH;
  UseLatestCommonDialogs := True;

  // ������� OnGetNodeDataSize ������-�� �� ��������������, �������������� �������

  tvBooksA.NodeDataSize := SizeOf(TBookData);
  tvBooksG.NodeDataSize := SizeOf(TBookData);
  tvBooksF.NodeDataSize := SizeOf(TBookData);
  tvBooksS.NodeDataSize := SizeOf(TBookData);
  tvBooksSR.NodeDataSize := SizeOf(TBookData);

  tvDownloadList.NodeDataSize := SizeOf(TDownloadData);

//-----------------------------

  FSelectionState := False;
  FAutoCheck := False;
  FFormBusy := False;

  FFileOpMode := fmFb2Zip;
  
  FLastLetterA := tbtnStar;
  FLastLetterS := tbtnStar;

  CreateAlphabet;

  ReadINIData;

  CreateDir(Settings.TempDir);
  CreateDir(Settings.DataDir);

  //------------------------ ������ ����� ���� ���� ����� ----------------------
  if (ParamCount > 0) and (ParamStr(1) = '/clear') then
    ClearDir(Settings.DataDir);

  frmSplash.lblState.Caption := main_connecttodb;

  DMUser.DBUser.DatabaseFileName := Settings.SystemFileName[sfSystemDB];
  if not FileExists(DMUser.DBUser.DatabaseFileName) then
    TMHLLibrary.CreateSystemTables(DMUser.DBUser.DatabaseFileName);


  DMUser.DBUser.Connected := True;
  DMUser.SetUserTableState(True);

 //------------------------------------------------------------------------------
 //  �������� ����������
 //------------------------------------------------------------------------------

  frmSplash.lblState.Caption := main_check_updates;
  if Settings.CheckUpdate then
  begin
    FAutoCheck := True;
    frmMain.miCheckUpdatesClick(nil);
  end
  else
    FAutoCheck := False;

  if Settings.CheckExternalLibUpdate then
    if CheckLibUpdates(True) then
      if Settings.AutoRunUpdate then
          StartLibUpdate
      else
        if MessageDlg('�������� ���������� ��� ��������� "lib.rus.ec".' + #13 + ' ������ ���������� ?', mtWarning, [mbYes, mbNo], 0) = mrYes then
           StartLibUpdate;

//------------------------------------------------------------------------------

  DMUser.ActivateCollection(Settings.ActiveCollection);

  FillGroupsList;
  CreateGroupsMenu;

  SetColumns;
  SetHeaderPopUp;

  frmSplash.lblState.Caption := main_loading_collection;

  InitCollection(False);
  dmCollection.SetActiveTable(pgControl.ActivePageIndex);


  TheFirstRun;

  if not DMUser.tblBases.IsEmpty then
    RestorePositions;

  if FileExists(Settings.WorkPath + 'downloads.sav') then
  begin
    tvDownloadList.LoadFromfile(Settings.WorkPath + 'downloads.sav');
    lblDownloadCount.Caption := Format('(%d)',[tvDownloadList.ChildCount[Nil]]);
  end;

//------------------------------------------------------------------------------

  SetLangBarSize;

  frmSplash.lblState.Caption := '����� ...';

  //
  // Create & Load "star" images from resources
  //
  FStarImage := CreateImageFromResource(TPngImage, 'smallStar') as TPngImage;
  FEmptyStarImage := CreateImageFromResource(TPngImage, 'smallStarEmpty') as TPngImage;

  // �������
  frmMain.Visible := True;

  if frmMain.WindowState = wsMinimized then
     frmMain.WindowState := wsNormal;
  // ����� �������


  // �������� ������ �������� ��� ������
  CreateDir(Settings.PresetDir);
  FilesList.TargetPath := Settings.PresetPath;
  FilesList.Process;

  if Settings.AutoStartDwnld then
    btnStartDownloadClick(Sender);

end;

procedure TfrmMain.SavePositions;
begin
  Settings.LastAuthor := lblAuthor.Caption;
  Settings.LastSeries := lblSeries.Caption;
  Settings.LastBookInAuthors := GetSelectedBookData(tvBooksA).ID;
  Settings.LastBookInSeries := GetSelectedBookData(tvBooksS).ID;
  Settings.LastBookInFavorites := GetSelectedBookData(tvBooksF).ID;
end;


procedure TfrmMain.SaveMainFormSettings;
begin
  SaveColumns;

  SavePositions;

  Settings.Splitters[0] := rzsSplitterA.Position;
  Settings.Splitters[1] := rzsSplitterS.Position;
  Settings.Splitters[2] := rzsSplitterG.Position;
  Settings.Splitters[3] := rzsSplitterSR.Position;

  Settings.BookSRCollapsed := ctpBook.Collapsed;
  Settings.FileSRCollapsed := ctpFile.Collapsed;
  Settings.OtherSRCollapsed := ctpOther.Collapsed;

  Settings.CoverWidth := cpCoverA.Width;

  Settings.WindowState := WindowState;

  if WindowState = wsNormal then
  begin
    Settings.FormWidth := Width;
    Settings.FormHeight := Height;
  end;
end;

procedure TfrmMain.FormDestroy(Sender: TObject);
begin
  FreeAndNil(FStarImage);
  FreeAndNil(FEmptyStarImage);


  tvDownloadList.SaveToFile(Settings.WorkPath + 'downloads.sav');

  if DirectoryExists(Settings.TempDir) then ClearDir(Settings.TempDir);

  SaveMainFormSettings;


  Settings.SaveSettings;
  FreeSettings;

end;

procedure TfrmMain.FormMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  
end;

//
// ������ ����
//
function TfrmMain.GetText(Tag: integer; Data: PBookData):string;
begin
    case Tag  of
      COL_AUTHOR : Result := Data.FullName;
      COL_TITLE  : Result := Data.Title;
      COL_SERIES : Result := Data.Series;
      COL_NO     : if Data.No <> 0 then
                      Result := IntToStr(Data.No);
      COL_SIZE   : Result := IntToStr(Data.Size);
      COL_DATE   : Result := DateToStr(Data.Date);
      COL_GENRE  : Result := Data.Genre;
      COL_TYPE   : Result := Data.FileType;
      COL_LANG   : Result := Data.Lang;
      COL_LIBRATE   : Result := IntToStr(Data.LibRate);
      COL_COLLECTION: Result := Data.ColName;
    end;
end;

procedure TfrmMain.tvAuthorsGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: String);
var
  Data: PAuthorData;
begin
  Data := Sender.GetNodeData(Node);
  Assert(Assigned(Data));

  CellText := Data.Text;
end;

procedure TfrmMain.tvBooksAGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
  Column: TColumnIndex; TextType: TVSTTextType; var CellText: String);
var
  Data: PBookData;
begin
  Data := Sender.GetNodeData(Node);
  if SizeOf(TBookData) = 0 then
    Exit;

  CellText := ' ';
  if Settings.TreeModes[PAGE_AUTHORS] = tmTree then
  begin
    if Node.ChildCount > 0 then
      case GetTreeTag(Sender, Column)  of
        COL_TITLE: CellText := Data.Series;
      end
    else
      CellText := GetText(GetTreeTag(Sender, Column), Data);
  end
  else
    CellText := GetText(GetTreeTag(Sender, Column), Data);
end;

procedure TfrmMain.tvBooksTreeInitNode(Sender: TBaseVirtualTree; ParentNode,
  Node: PVirtualNode; var InitialStates: TVirtualNodeInitStates);
begin
  Node.CheckType := ctTriStateCheckBox;
  Sender.CheckState[Node] := csUncheckedNormal;
end;

procedure TfrmMain.tvBooksTreeHeaderClick(Sender: TVTHeader;
  HitInfo: TVTHeaderHitInfo);
var
  Tree:TVirtualStringTree;
begin
  if (HitInfo.Button = mbLeft) then
  begin
    GetActiveTree(Tree);
    if (Settings.TreeModes[Tree.Tag] = tmTree) then Exit;
    // ������ ������ ����������� ������� �� ������ �������,
    // ������� ���� ������.
    Tree.Header.SortColumn := HitInfo.Column;
    // ��������� �� ������ ������������ ���� �������
    // � �������� ������� ���������� �� ��������������
    if Tree.Header.SortDirection = sdAscending then
    begin
      Tree.Header.SortDirection := sdDescending;
      Tree.SortTree(HitInfo.Column, Tree.Header.SortDirection);
    end
    else begin
      Tree.Header.SortDirection := sdAscending;
      Tree.SortTree(HitInfo.Column, Tree.Header.SortDirection);
    end;

    // ���������� ��������� ��� ��������� ������
    FSortSettings[Tree.Tag].Column := HitInfo.Column;
    FSortSettings[Tree.Tag].Direction := Tree.Header.SortDirection;
  end;
end;

procedure TfrmMain.tvBooksGGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
  Column: TColumnIndex; TextType: TVSTTextType; var CellText: String);
var
  Data: PBookData;
  Tag: integer;
begin
  Data := Sender.GetNodeData(Node);
  CellText := ' ';
  Tag := GetTreeTag(Sender, Column);
  if Settings.TreeModes[PAGE_GENRES] = tmTree then
  case Data.nodeType of
    ntAuthorInfo: if Tag = COL_TITLE then
                     CellText := Data.FullName;
    ntSeriesInfo: if Tag = COL_TITLE then
                     CellText := '�����: ' + Data.Series;
    ntBookInfo:
      case Tag of
        COL_TITLE : CellText := Data.Title;
        COL_NO    : if Data.No <> 0 then
                        CellText := IntToStr(Data.No);
        COL_SIZE  : CellText := IntToStr(Data.Size);
        COL_GENRE : CellText := Data.Genre;
      end;
  end
  else
    CellText := GetText(GetTreeTag(Sender, Column), Data);
end;

procedure TfrmMain.tvBooksSGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
  Column: TColumnIndex; TextType: TVSTTextType; var CellText: String);
var
  Data: PBookData;
begin
  Data := Sender.GetNodeData(Node);
  Assert(Assigned(Data));

  CellText := ' ';
  CellText := GetText(GetTreeTag(Sender, Column), Data);
end;

procedure TfrmMain.tvBooksFGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
  Column: TColumnIndex; TextType: TVSTTextType; var CellText: String);
var
  Data: PBookData;
  Page: integer;

begin
  Page := Sender.Tag;
  Data := Sender.GetNodeData(Node);
  Assert(Assigned(Data));

  CellText := ' ';
  if Settings.TreeModes[Page] = tmTree then
  case Data.nodeType of
    ntAuthorInfo:
      begin
        case GetTreeTag(Sender, Column)  of
          COL_TITLE : CellText := Data.FullName;
          COL_COLLECTION : CellText := Data.ColName;
        end;
      end;

    ntSeriesInfo:
      begin
        if GetTreeTag(Sender, Column)  = COL_TITLE then
          CellText := '�����: ' + Data.Series;
      end;

    ntBookInfo: if GetTreeTag(Sender, Column)  <> COL_COLLECTION
     then CellText := GetText(GetTreeTag(Sender, Column), Data);

  end
  else
    CellText := GetText(GetTreeTag(Sender, Column), Data);
end;

procedure TfrmMain.tvBooksSRGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: String);
var
  Data: PBookData;
begin
  Data := Sender.GetNodeData(Node);
  Assert(Assigned(Data));

  CellText := ' ';
  case Column of
    0: CellText := Data.FullName;
    1: CellText := Data.Title;
    2: CellText := Data.Series;
    3: if Data.No <> 0 then
        CellText := IntToStr(Data.No);
    4: CellText := IntToStr(Data.Size);
    6: CellText := Data.Genre;
    7: CellText := DateToStr(Data.Date);
  end;
end;

procedure TfrmMain.tvGenresGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
  Column: TColumnIndex; TextType: TVSTTextType; var CellText: String);
var
  Data: PGenreData;
begin
  Data := Sender.GetNodeData(Node);
  Assert(Assigned(Data));

  CellText := Data.Text;
end;

procedure TfrmMain.tvGroupsChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
var
  Data: PGroupData;

begin
  Data := tvGroups.GetNodeData(Node);
  if Data = Nil then Exit;

  DMUser.ActivateGroup(Data.ID);

  lblGroups.Caption := DMUser.tblGroupListName.Value;

  FillBooksTree(0,tvBooksF,Nil,DMUser.tblGrouppedBooks,true, true);

end;

procedure TfrmMain.tvGroupsDragDrop(Sender: TBaseVirtualTree; Source: TObject;
  DataObject: IDataObject; Formats: TFormatArray; Shift: TShiftState;
  Pt: TPoint; var Effect: Integer; Mode: TDropMode);

var
  Nodes: TNodeArray;
  i: Integer;
  Node, LastNode : PvirtualNode;
  Data: PGenreData;
  BookData: PBookData;

          procedure SelectChildNodes(ParentNode: PVirtualNode);
          var
            Node: PVirtualNode;
          begin
            if ParentNode.ChildCount = 0 then Exit;
            Node := ParentNode.FirstChild;
            while Node <> Nil do
            begin
              SelectChildNodes(Node);
              tvBooksF.Selected[Node] := True;
              Node := tvBooksF.GetNextSibling(Node);
            end;
          end;

begin
  Nodes := nil;
  Data := tvGroups.GetNodeData(tvGroups.DropTargetNode);
  Nodes := tvBooksF.GetSortedSelection(False);

  // ��������� ���������� ����.
  // ���� ���� �������, �������� �� ����
  for i := 0 to High(Nodes) do
    SelectChildNodes(Nodes[i]);

  // ���������� ����� ������ ����������
  Nodes := tvBooksF.GetSortedSelection(False);

  // ��������� ������
  for i := 0 to High(Nodes) do
  begin
    BookData := tvBooksF.GetNodeData(Nodes[i]);
    if (BookData.nodeType = ntBookInfo) and
       (DMUser.tblGrouppedBooks.Locate('ID',BookData.ID,[])) then
    begin
      DMUser.tblGrouppedBooks.Edit;
      DMUser.tblGrouppedBooksGroupID.Value := Data.ID;
      DMUser.tblGrouppedBooks.Post;
    end;
  end;
  FillBooksTree(0,tvBooksF,Nil,DMUser.tblGrouppedBooks,true, true);
end;

procedure TfrmMain.tvGroupsDragOver(Sender: TBaseVirtualTree; Source: TObject;
  Shift: TShiftState; State: TDragState; Pt: TPoint; Mode: TDropMode;
  var Effect: Integer; var Accept: Boolean);
var
  Data : PGroupData;
begin
  Data := tvGroups.GetNodeData(tvGroups.DropTargetNode);
  if Data <> nil then
    if Data.ID <> DMUser.tblGroupListID.Value then
      Accept := True;
end;

procedure TfrmMain.tvGroupsGetNodeDataSize(Sender: TBaseVirtualTree;
  var NodeDataSize: Integer);
begin
  NodeDataSize := sizeof(TGroupData);
end;

procedure TfrmMain.tvGroupsGetText(Sender: TBaseVirtualTree; Node: PVirtualNode;
  Column: TColumnIndex; TextType: TVSTTextType; var CellText: string);
var
  Data: PGroupData;
begin
  Data := Sender.GetNodeData(Node);
  Assert(Assigned(Data));
  CellText := Data.Text;
end;

procedure TfrmMain.tvAuthorsChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
var
  Data: PAuthorData;
  ID: integer;
begin
  Data := tvAuthors.GetNodeData(Node);
  if not Assigned(Data) then
    Exit;
  ClearLabels(PAGE_AUTHORS, True);
  ID := Data^.ID;
  dmCollection.tblAuthors.Locate('A_ID', ID, []);
  lblAuthor.Caption := Data.Text;
  FillBooksTree(ID, tvBooksA, dmCollection.tblAuthor_List, dmCollection.tblBooksA, False, True); // ������
end;

procedure TfrmMain.tvSeriesChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
var
  Data: PAuthorData;
  ID: integer;
begin
  Data := tvSeries.GetNodeData(Node);
  if not Assigned(Data) then
    Exit;
  ClearLabels(PAGE_SERIES, True);
  ID := Data^.ID;
  dmCollection.tblSeries.Locate('S_ID', ID, []);
  lblSeries.Caption := Data.Text;
  FillBooksTree(ID, tvBooksS, nil, dmCollection.tblBooksS, False, False); // ������
end;

procedure TfrmMain.tvGenresChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
var
  Data: PGenreData;
  ID: string;
begin
  Data := tvGenres.GetNodeData(Node);
  if not Assigned(Data) then
    Exit;
  ClearLabels(PAGE_GENRES, True);
  ID := Data^.Code;
  if IsFB2Collection(DMUser.ActiveCollection.CollectionType) or
     not Settings.ShowSubGenreBooks
  then
  begin
    dmCollection.tblGenres.Locate('G_Code', ID, []);
    FillBooksTree(0, tvBooksG, dmCollection.tblGenre_List, dmCollection.tblBooksG, True, True); // �����
  end
  else
  begin
    dmCollection.tblGenre_List.MasterSource := nil;
    dmCollection.tblGenre_List.Filter := '`GL_Code` Like ' + QuotedStr(ID + '%');
    dmCollection.tblGenre_List.Filtered := True;
    FillBooksTree(0, tvBooksG, dmCollection.tblGenre_List, dmCollection.tblBooksG, True, True); // �����
    dmCollection.tblGenre_List.Filtered := False;
    dmCollection.tblGenre_List.MasterSource := dmCollection.dsGenres;
  end;
  lblGenreTitle.Caption := Data.Text;
end;

procedure TfrmMain.GetActiveViewComponents(var Tree : TVirtualStringTree;
                        var Panel: TMHLInfoPanel;
                        var Cover: TMHLCoverPanel);
begin
  case ActiveView of
    ByAuthorView:begin
                   Tree := tvBooksA;
                   Panel:= ipnlAuthors;
                   Cover:= cpCoverA;
                 end;
    BySeriesView: begin
                   Tree := tvBooksS;
                   Panel:= ipnlSeries;
                   Cover:= cpCoverS;
                 end;
    ByGenreView: begin
                   Tree := tvBooksG;
                   Panel:= ipnlGenres;
                   Cover:= cpCoverG;
                 end;
    SearchView: begin
                   Tree := tvBooksSR;
                   Panel:= ipnlSearch;
                   Cover:= cpCoverSR;
                 end;
    FavoritesView: begin
                   Tree := tvBooksF;
                   Panel:= ipnlFavorites;
                   Cover:= cpCoverF;
                 end;
  end;
end;

procedure TfrmMain.tvBooksTreeChange(Sender: TBaseVirtualTree; Node: PVirtualNode);
var
  Data: PBookData;
  Tree: TVirtualStringTree;
  InfoPanel: TMHLInfoPanel;
  Cover: TMHLCoverPanel;
  Folder: string;
  FileName: string;
  Ext: string;

  No: integer;
begin
  if BookTreeStatus = bsBusy then
    Exit;

  GetActiveViewComponents(Tree,InfoPanel,Cover);

  Data := Tree.GetNodeData(Tree.GetFirstSelected);
  if not Assigned(Data) then
    Exit;

  if Data.nodeType <> ntBookInfo then
  begin
    ClearLabels(Tree.Tag, False);
    Exit;
  end;

  dmCollection.GetBookFileName(Data.ID, FileName, Folder, Ext, No);


  InfoPanel.Title := Data.Title;
  InfoPanel.Author := Data.FullName;
  InfoPanel.Genre := Data.Genre;
  InfoPanel.FileName := FileName;

  InfoPanel.HideFileInfo := not (isOnlineCollection(DMUser.ActiveCollection.CollectionType) and not Data.Locale);


  if ActiveView <> FavoritesView then
    if (Folder = '') then
       InfoPanel.Folder := FCollectionRoot
     else
       InfoPanel.Folder := FCollectionRoot + Folder
    else
      InfoPanel.Folder := Folder;

  pmiBookInfo.Visible := Cover.Show(InfoPanel.Folder,InfoPanel.FileName,No);

  if pmiBookInfo.Visible and IsPrivate and IsNonFB2 then
  begin
    miConverToFBD.Visible := true;
    miConverToFBD.Tag := 999;
    miConverToFBD.Caption := '������������� FBD';
    if frmConvertToFBD <> nil then
    begin
      frmConvertToFBD.EditorMode := true;
      frmConvertToFBD.Caption := '�������������� FBD';
    end;
  end
    else
      if not pmiBookInfo.Visible and IsPrivate and IsNonFB2 then
      begin
        miConverToFBD.Visible := true;
        miConverToFBD.Tag := 0;
        miConverToFBD.Caption := '������������� FBD';
        if frmConvertToFBD <> nil then
        begin
          frmConvertToFBD.EditorMode := false;
          frmConvertToFBD.Caption := '�������������� � FBD';
        end;
      end;


  Application.ProcessMessages;
end;

procedure TfrmMain.tvBooksTreeCompareNodes(Sender: TBaseVirtualTree; Node1,
  Node2: PVirtualNode; Column: TColumnIndex; var Result: Integer);
var
  Data1, Data2: PBookData;
begin
  Data1 := Sender.GetNodeData(Node1);
  Data2 := Sender.GetNodeData(Node2);
  case (Sender as TVirtualStringTree).Header.Columns[Column].Tag of
    COL_AUTHOR : Result := CompareStr(Data1.FullName, Data2.FullName);
    COL_TITLE  : Result := CompareStr(Data1.Title, Data2.Title);
    COL_SERIES : Result := CompareStr(Data1.Series, Data2.Series);
    COL_NO     : Result := CompareInt(Data1.No, Data2.No);
    COL_SIZE   : Result := CompareInt(Data1.Size, Data2.Size);
    COL_RATE   : Result := CompareInt(Data1.Rate, Data2.Rate);
    COL_GENRE  : Result := CompareStr(Data1.Genre, Data2.Genre);
    COL_DATE   : Result := CompareDate(Data1.Date, Data2.Date);
    COL_LANG   : Result := CompareSTR(Data1.Lang, Data2.Lang);
    COL_LibRate: Result := CompareInt(Data1.LibRate, Data2.LibRate);
  end;
end;

procedure TfrmMain.tvAuthorsPaintText(Sender: TBaseVirtualTree;
  const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType);
begin
  if Sender.Selected[Node] then
    TargetCanvas.Font.Color := clWhite;
end;

procedure TfrmMain.tvBooksTreeBeforeCellPaint(Sender: TBaseVirtualTree;
  TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  CellPaintMode: TVTCellPaintMode; CellRect: TRect; var ContentRect: TRect);
var
  Data: PBookData;
  Color: TColor;
begin
  Data := Sender.GetNodeData(Node);
  Assert(Assigned(Data));

  Color := Settings.BGColor;
  case Data.nodeType of
    ntAuthorInfo: Color := Settings.AuthorColor;
    ntSeriesInfo: Color := Settings.SeriesColor;
    ntBookInfo:begin
                 if Data.Series <> '' then
                   Color := Settings.SeriesBookColor
                 else
                   Color := Settings.BookColor;
               end;
  end;



  TargetCanvas.Brush.Color := Color;
  TargetCanvas.FillRect(CellRect);
end;

function TfrmMain.GetTreeTag(const Sender: TBaseVirtualTree; const Column: integer):integer;
begin
  if Column < 0 then Result := -1
    else
      Result := (Sender as TVirtualStringTree).Header.Columns[Column].Tag;
end;


procedure TfrmMain.tvBooksTreeAfterCellPaint(Sender: TBaseVirtualTree;
  TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  CellRect: TRect);
var
  Data: PBookData;
  Tag : integer;
  i: integer;
  x, y: integer;
  w, h: integer;
begin
  Data := Sender.GetNodeData(Node);
  Assert(Assigned(Data));

  if Data.nodeType <> ntBookInfo then
    Exit;

  Tag := GetTreeTag(Sender, Column);

  X := (Sender as TvirtualStringTree).Header.Columns.Items[Column].Left;

  if (Tag = COL_STATE) then
  begin
    if isOnlineCollection(DMUser.ActiveCollection.CollectionType)
        and (Data.Locale)
    then
      ilFileTypes.Draw(TargetCanvas, X, CellRect.Top + 1, 5);
    if Data.Progress = 100 then
      ilFileTypes.Draw(TargetCanvas, X + 10, CellRect.Top, 6);

    if Data.Code = 1 then
      ilFileTypes.Draw(TargetCanvas, X + 25, CellRect.Top + 1, 7);

  end;


  { DONE -oNickR :�������� �� ��������� }
  if (Tag = COL_RATE) then
  begin
    w := FStarImage.Width;
    h := FStarImage.Height;
    x := CellRect.Left (*+ (CellRect.Right - CellRect.Left - 10 {w} * 5) div 2*);
    y := CellRect.Top + (CellRect.Bottom - CellRect.Top - h) div 2;

    for i := 0 to 4 do
    begin
      if Data.Rate > i then
        FStarImage.Draw(TargetCanvas, Rect(x, y, x + w, y + h))
      else
        FEmptyStarImage.Draw(TargetCanvas, Rect(x, y, x + w, y + h));

      Inc(x, {w} 10);
    end;
  end;
end;

procedure TfrmMain.tvBooksTreeKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
var
  Node : PVirtualNode;
  Tree, Left : TVirtualStringTree;
  Data : PBookData;
begin
  if Key = vk_Insert then
  begin
    Tree := (Sender as TVirtualStringTree);
    Node := Tree.FocusedNode;
    if Node <> nil then
    begin
      BookTreeStatus := bsBusy ;
      Data := Tree.GetNodeData(Node);
      if Data.nodeType = ntBookInfo then
        if Tree.CheckState[Node] = csCheckedNormal then
          Tree.CheckState[Node] := csUnCheckedNormal
        else
          Tree.CheckState[Node] := csCheckedNormal;

      Tree.Selected[Node] := False;
      Node := Tree.GetNext(Node);
      BookTreeStatus := bsFree ;
      if Node <> nil then Tree.Selected[Node] := True;
    end;
  end;
  if ((Key = vk_Right) or  (Key = vk_Left))and (ssCtrl in Shift) then
  begin
    Tree := (Sender as TVirtualStringTree);
    case ActiveView of
      ByAuthorView: Left := tvAuthors;
      BySeriesView: Left := tvSeries;
      ByGenreView: Left := tvGenres;
      FavoritesView: Left := tvGroups;
      SearchView: Exit;
    end;

    Node := Left.FocusedNode;
    Left.Selected[Node] := False;

    if (Key = vk_Right) then
           Node := Left.GetNext(Node)
     else
           Node := Left.GetPrevious(Node);

    if Node <> Nil then
    begin
      Left.Selected[Node] := True;
      Left.FocusedNode := Node;
    end;

    Node := Tree.GetFirst;
    if Node <> Nil then
         Tree.Selected[Node] := True;
  end;


end;

procedure TfrmMain.tvBooksAGetNodeDataSize(Sender: TBaseVirtualTree; var NodeDataSize: Integer);
begin
  NodeDataSize := SizeOf(TBookData);
end;

procedure TfrmMain.tvAuthorsGetNodeDataSize(Sender: TBaseVirtualTree; var NodeDataSize: Integer);
begin
  NodeDataSize := SizeOf(TAuthorData);
end;

procedure TfrmMain.tvBooksGGetNodeDataSize(Sender: TBaseVirtualTree; var NodeDataSize: Integer);
begin
  NodeDataSize := SizeOf(TBookData);
end;

procedure TfrmMain.tvBooksTreeMouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var
  Node: PVirtualNode;
  Data: PBookData;
  Tree: TVirtualStringTree;
  Selected: PVirtualNode;
begin
  if (Button = mbLeft) and (ssShift in Shift) then
  begin
    BookTreeStatus := bsBusy ;
    try
      Tree := Sender as TVirtualStringTree;
      ClearLabels(Tree.Tag, True);
      Node := Tree.GetFirstSelected;
      Selected := Node;
      while Node <> nil do
      begin
        Data := Tree.GetNodeData(Node);
        if Data.nodeType = ntBookInfo  then
        begin
          if Tree.CheckState[Node] = csCheckedNormal then
             Tree.CheckState[Node] := csUnCheckedNormal
          else
            Tree.CheckState[Node] := csCheckedNormal;
          Tree.Selected[Node] := False;
        end;
        Node := Tree.GetNextSelected(Node);
      end; //while
    finally
      BookTreeStatus := bsFree ;
      Tree.Selected[Selected] := True;
    end;
  end; // if
end;

procedure TfrmMain.tvBooksTreePaintText(Sender: TBaseVirtualTree;
  const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType);
var
  Data: PBookData;
begin
  Data := Sender.GetNodeData(Node);
  if Data.nodeType <> ntBookInfo then
      TargetCanvas.Font.Style := [fsBold]
    else
      if not Sender.Selected[Node] then
      begin
        if Data.Locale then TargetCanvas.Font.Color := Settings.LocalColor;
        if Data.Deleted then TargetCanvas.Font.Color := Settings.DeletedColor;
      end;
end;

procedure TfrmMain.tvDownloadListGetText(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Column: TColumnIndex; TextType: TVSTTextType;
  var CellText: string);
const
  States : array [0..3] of string = ('��������','�������','������','������');
var
  Data : PDownloadData;
begin
  Data := tvDownloadList.GetNodeData(Node);
  case Column of
    0: CellText := Data.Author;
    1: CellText := Data.Title;
    2: CellText := IntToStr(Data.Size);
    3: CellText := States[ord(Data.State)];
  end;
end;

procedure TfrmMain.tvDownloadListLoadNode(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Stream: TStream);
var
  Data: PDownloadData;
  size: Integer;
  StrBuffer: PChar;

    function GetString:string;
    begin
      Stream.Read(Size, SizeOf(Size));
      StrBuffer := AllocMem(Size);
      Stream.Read(StrBuffer^, Size);
      Result := (StrBuffer);
      FreeMem(StrBuffer);
    end;

begin
  Data := Sender.GetNodeData(Node);
  // ID
  Stream.Read(Data.ID, SizeOf(Data.ID));

  Data.Title := GetString;
  Data.Author := GetString;

  // Size
  Stream.Read(Data.Size, SizeOf(Data.Size));

  Data.FileName := GetString;
  Data.URL := GetString;

  // State
  Stream.Read(Data.State, SizeOf(Data.State));
end;

procedure TfrmMain.tvDownloadListPaintText(Sender: TBaseVirtualTree;
  const TargetCanvas: TCanvas; Node: PVirtualNode; Column: TColumnIndex;
  TextType: TVSTTextType);
var
  Data : PDownloadData;
begin
  Data := Sender.GetNodeData(Node);
  if (Data <> nil) and not Sender.Selected[Node] then
    case Data.State of
      dsRun  : TargetCanvas.Font.Color := clGreen;
      dsError: TargetCanvas.Font.Color := clRed;
    end;
end;

procedure TfrmMain.tvDownloadListSaveNode(Sender: TBaseVirtualTree;
  Node: PVirtualNode; Stream: TStream);
var
  Data: PDownloadData;
  size: Integer;

  procedure WriteString(const S: string);
  begin
    Size := ByteLength(S) + 1;
    Stream.Write(Size, SizeOf(Size));
    Stream.Write(PChar(S)^, Size);
  end;

begin
  Data := Sender.GetNodeData(Node);

  if Data = Nil then Exit;

  //  ID
  Stream.Write(Data.ID, SizeOf(Data.ID));

  WriteString(Data.Title);
  WriteString(Data.Author);

  // Size
  Stream.Write(Data.Size, SizeOf(Data.Size));

  WriteString(Data.FileName);
  WriteString(Data.URL);

  // State
  Stream.Write(Data.State, SizeOf(Data.State));
end;

//
// Menu handlers
//
procedure TfrmMain.btnClearDownloadClick(Sender: TObject);
begin
  tvDownloadList.Clear;
  lblDownloadCount.Caption := '(0)';
end;

procedure TfrmMain.btnClearEdSeriesClick(Sender: TObject);
begin
  edLocateSeries.Clear;
  frmMain.ActiveControl := edLocateSeries;
end;

procedure TfrmMain.btnClearFavoritesClick(Sender: TObject);
begin
  Screen.Cursor := crHourGlass;
  try
    ClearLabels(PAGE_FAVORITES, True);
    DMUser.tblGrouppedBooks.First;
    while not DMUser.tblGrouppedBooks.Eof do
    begin
      if DMUser.tblExtra.RecordCount <> 0 then
       DMUser.tblExtra.Delete;
      DMUser.tblGrouppedBooks.Delete;
    end;
    FillBooksTree(0, tvBooksF, nil, DMUser.tblGrouppedBooks, True, True); // ���������
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TfrmMain.MoveDwnldListNodes(Sender: TObject);
var
  i: integer;
  List: TSelectionList;
begin
  GetSeelections(tvDownloadList,List);
  for I := 0 to tvDownloadList.SelectedCount - 1 do
    case (Sender as TrzToolButton).Tag of
      20: tvDownloadList.MoveTo(List[tvDownloadList.SelectedCount - i - 1],tvDownloadList.GetFirst,amInsertBefore,False);
      21: tvDownloadList.MoveTo(List[i],tvDownloadList.GetPrevious(List[i]),amInsertBefore,False);
      22: tvDownloadList.MoveTo(List[tvDownloadList.SelectedCount - i - 1],tvDownloadList.GetNext(List[tvDownloadList.SelectedCount - i - 1]),amInsertAfter,False);
      23: tvDownloadList.MoveTo(List[i],tvDownloadList.GetLast,amInsertAfter,False);
    end;
end;

procedure TfrmMain.CopyToCollectionClick(Sender: TObject);
var
  R: TbookRecord;
  ID: integer;
  Tree: TVirtualStringTree;
  Data: PBookData;
  Node: PVirtualNode;
  ALibrary: TMHLLibrary;
begin
  Screen.Cursor := crHourGlass;

  if ActiveView = FavoritesView then
  begin
    MessageDlg(main_unable_to_copy, mtWarning, [mbOk], 0);
    Exit;
  end;

  GetActiveTree(Tree);
  ID := (Sender as TMenuItem).Tag;
  if not DMUser.ActivateCollection(ID) then
    Exit;
  ALibrary := TMHLLibrary.Create(nil);
  try
    ALibrary.DatabaseFileName := DMUser.ActiveCollection.DBFileName;
    ALibrary.Active := True;

    Node := Tree.GetFirst;
    while Assigned(Node) do
    begin
      Data := Tree.GetNodeData(Node);
      if (Data.nodeType = ntBookInfo) and ((Tree.CheckState[Node] = csCheckedNormal) or (Tree.Selected[Node])) then
      begin
        Data := Tree.GetNodeData(Node);
        GetBookRecord(Data.ID, R);
        ALibrary.InsertBook(R, True, True);
      end;

      Node := Tree.GetNext(Node);
    end;
  finally
    ALibrary.Free;
  end;
  Screen.Cursor := crDefault;
end;

procedure TfrmMain.CoverPanelResize(Sender: TObject);
var
  NewSize: integer;
begin
  NewSize := (Sender as TWinControl).Width;
  if NewSize < 150 then NewSize := 150;
  
  cpCoverA.Width := NewSize;
  cpCoverS.Width := NewSize;
  cpCoverG.Width := NewSize;
  cpCoverF.Width := NewSize;
  cpCoverSR.Width := NewSize;
end;

procedure TfrmMain.FillBookIdList(const Tree: TVirtualStringTree; var BookIDList: TBookIdList );
var
  i: integer;
  Data: PBookData;
  Node: PVirtualNode;
begin
  Node := Tree.GetFirst;
  i := 0;
  while Assigned(Node) do
  begin
    Data := Tree.GetNodeData(Node);
    Assert(Assigned(Data));
    if (Data.nodeType = ntBookInfo) and ((Tree.CheckState[Node] = csCheckedNormal) or (Tree.Selected[Node])) then
    begin
      SetLength(BookIdList, i + 1);
      BookIdList[i].ID := Data.ID;
      Inc(i);
      Tree.CheckState[Node] := csUnCheckedNormal;
    end;
    Node := Tree.GetNext(Node);
  end;
end;

procedure TfrmMain.tbSendToDeviceClick(Sender: TObject);
var
  AFolder: string;
  SaveDeviceDir: string;
  SaveFolderTemplate: string;
  TMPParams: String;
  ScriptID: Integer;
  BookIDList: TBookIdList;
  Files : string;
  p:integer;
  S: string;
  Tree: TVirtualStringTree;
  ExportMode: TExportMode;
begin
  FCancelled := false;
  GetActiveTree(Tree);
  FillBookIdList(Tree, BookIDList);

  if Length(BookIDList) = 0 then
  begin
    ShowMessage('�� ����� ����� �� �������!');
    Exit;
  end;

  SaveDeviceDir := Settings.DeviceDir;
  SaveFolderTemplate := Settings.FolderTemplate;
  //  dlgFolder.Directory := Settings.DeviceDir;
  ScriptID := (Sender as TComponent).Tag;


  if isFB2Collection(DMUser.ActiveCollection.CollectionType) then
  case ScriptID of
    850: ExportMode := emFb2;
    851: ExportMode := emFb2Zip;
    852: ExportMode := emLrf;
    853: ExportMode := emTxt;
    else ExportMode := Settings.ExportMode;
  end
  else
    ExportMode := emFb2;

  Dec(ScriptID, 901);

  if (ScriptID < 1 ) and (Settings.PromptDevicePath) then
    //if not dlgFolder.Execute then
    if not GetFolderName(Handle, '������� ����', AFolder) then
      Exit
    else
      { TODO -oNickR -cRefactoring : ��� ��������� ��������� � ���������� � ��� �� ������ ����������� ��� �������� ���������
                             ��� ��������� ����� ������ ��� ������ ������� ZipToDevice/FileToDevice � ��������
                             ����������� ���� �������
      }
      Settings.DeviceDir := AFolder;

  if ScriptID >= 0 then
  begin
    TMPParams := Settings.Scripts[ScriptID].Params;
    if Pos('%NFT%', Settings.Scripts[ScriptID].Params) <> 0 then
    begin
      Settings.FolderTemplate := '';
      StrReplace('%NFT%', '', TMPParams);
    end;

    if Pos('%TMP%', Settings.Scripts[ScriptID].Params) <> 0 then
      StrReplace('%TMP%',Settings.TempPath, TMPParams);

    if Pos('%DEST%', Settings.Scripts[ScriptID].Params) <> 0 then
      StrReplace('%DEST%',Settings.DeviceDir, TMPParams);

    if Pos('%FOLDER ', Settings.Scripts[ScriptID].Params) <> 0 then
    begin
      StrReplace('%FOLDER ','', TMPParams);
      p := pos('%',TMPParams);
      S := copy(TMPParams,1,p-1);
      Settings.DeviceDir := S;
      Delete(TMPParams,1,p);
    end;

    if (Settings.Scripts[ScriptID].Path = '%COPY%') and
       (trim(TMPParams) <> '') then Settings.DeviceDir := trim(TMPParams);

    Settings.Scripts[ScriptID].TmpParams := TMPParams;
  end;

  if isOnlineCollection(DMUser.ActiveCollection.CollectionType) then
  begin
    unit_ExportToDevice.DownloadBooks(dmCollection.ActiveTable, BookIdList);
    RefreshBooksState(Tree, BookIDList);
    if FCancelled then Exit;

  end;

  if ActiveView <> FavoritesView then
       unit_ExportToDevice.ExportToDevice(dmCollection.ActiveTable, BookIdList, ExportMode, Files)
  else
       unit_ExportToDevice.ExportToDevice(dmUser.tblGrouppedBooks, BookIdList, ExportMode, Files);

  if (ScriptID >= 0 ) and (Settings.Scripts[ScriptID].Path <> '%COPY%') then
  begin
    if Pos('%FILENAME%', Settings.Scripts[ScriptID].Params) <> 0 then
    begin
      StrReplace('%FILENAME%', Files, TMPParams);
      Settings.Scripts[ScriptID].TmpParams := TMPParams;
    end;
    Settings.Scripts[ScriptID].Run;
  end;

  Settings.DeviceDir := SaveDeviceDir;
  Settings.FolderTemplate := SaveFolderTemplate;

end;


procedure TfrmMain.HTTPWorkEnd(ASender: TObject; AWorkMode: TWorkMode);
begin
  spStatus.Caption := '������';
  spProgress.Percent := 100;
end;

procedure TfrmMain.DownloadBooks;
var
  BookIDList: TBookIdList;
  Tree: TVirtualStringTree;
begin
  GetActiveTree(Tree);

  FillBookIdList(Tree, BookIDList);
  unit_ExportToDevice.DownloadBooks(dmCollection.ActiveTable, BookIdList );

  RefreshBooksState(Tree, BookIDList);
end;

procedure TfrmMain.tbtbnReadClick(Sender: TObject);
var
  WorkFile: String;
  Tree: TVirtualStringTree;
  Cover: TMHLCoverPanel;
  Panel: TMHLInfoPanel;
  No: integer;
  Data: PBookData;

  fs: TMemoryStream;
  Zip: TZipForge;
  Id,I: integer;

  FileName,Folder,Ext: string;

begin
  GetActiveViewComponents(Tree,Panel,Cover);
  Data := Tree.GetNodeData(Tree.GetFirstSelected);
  if (not Assigned(Data)) then
    Exit;

  if Data.nodeType <> ntBookInfo then
  begin
    ClearLabels(Tree.Tag, True);
    Exit;
  end;

  Screen.Cursor := crHourGlass;
  try
    if ExtractFileExt(Panel.Folder) = ZIP_EXTENSION then
    begin
      //
      if ActiveView = FavoritesView then
      begin
        I := DMUser.tblGrouppedBooksDatabaseID.Value;
        DMUser.tblBases.Locate('ID',I,[]);
        if isOnlineCollection(DMUser.tblBasesCode.Value) then
        begin
          DownloadBooks;
          if not FileExists(Panel.Folder) then
            Exit;
        end;
        Id := DMUser.tblGrouppedBooksOuterId.Value;
      end   // if ActiveView
      else
      begin
        if isOnlineCollection(DMUser.ActiveCollection.CollectionType) then
        begin
          DownloadBooks;
          if not FileExists(Panel.Folder) then
              Exit; // ���� ����� ���, ������ ������� �� �������, � ���� ��  ���� ��� �����

        end;
        Id := Data.ID;
      end;  // if .. else

      if not FileExists(Panel.Folder) then
          raise EInvalidOp.Create('����� ' + Panel.Folder + ' �� ������!');

      dmCollection.GetBookFileName(Data.ID, FileName, Folder, Ext, No);

      WorkFile := Settings.ReadPath + Format('%s - %s.%d%s',
                                              [CheckSymbols(Panel.Author),
                                               CheckSymbols(Panel.Title),Id,Ext]);

      if not FileExists(WorkFile) then
      begin
        Zip := TZipForge.Create(nil);
        FS := TMemoryStream.Create;
        try
          Zip.FileName := Panel.Folder;
          Zip.BaseDir := Settings.ReadPath;
          Zip.OpenArchive;
          Zip.ExtractToStream(GetFileNameZip(Zip,No),FS);
          fs.SaveToFile(WorkFile);
        finally
          FS.Free;
          Zip.Free;
        end;
      end; // if Exists
    end
    else
      if ExtractFileExt(Panel.FileName) = ZIP_EXTENSION then
      begin
        dmCollection.GetBookFileName(Data.ID, FileName, Folder, Ext, No);

        WorkFile := Settings.ReadPath + Format('%s - %s.%d%s',
                                              [CheckSymbols(Panel.Author),
                                               CheckSymbols(Panel.Title),Id,Ext]);

        if not FileExists(WorkFile) then
        begin
          Zip := TZipForge.Create(nil);
          FS := TMemoryStream.Create;
          try
            Zip.FileName := Panel.Folder + Panel.FileName;
            Zip.BaseDir := Settings.ReadPath;
            Zip.OpenArchive;
            WorkFile := GetFileNameZip(Zip,No);
            Zip.ExtractToStream(WorkFile,FS);
            WorkFile := Settings.ReadPath + WorkFile;
            fs.SaveToFile(WorkFile);
          finally
            FS.Free;
            Zip.Free;
          end;
        end; // if Exists

      end
      else
        WorkFile := Panel.Folder + Panel.FileName;

    if Ext = '.fb2' then WriteFb2InfoToFile(WorkFile);

    Settings.Readers.RunReader(WorkFile);
    Tree.RepaintNode(Tree.GetFirstSelected);
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TfrmMain.tbtnEngClick(Sender: TObject);
begin
  Settings.ShowEngBar := not Settings.ShowEngBar;
  EngBar.Visible := Settings.ShowEngBar;

  SetLangBarSize;
end;

procedure TfrmMain.tbtnRusClick(Sender: TObject);
begin
  Settings.ShowRusBar := not Settings.ShowRusBar;
  RusBar.Visible := Settings.ShowRusBar;

  SetLangBarSize;
end;


procedure TfrmMain.tbtnShowDeletedClick(Sender: TObject);
begin
  SavePositions;

  Settings.DoNotShowDeleted := not Settings.DoNotShowDeleted;
  tbtnShowDeleted.Down := Settings.DoNotShowDeleted;

  cbDeleted.Checked := Settings.DoNotShowDeleted;

  SetBooksFilter;
  FillAllBooksTree;

  RestorePositions;
end;

procedure TfrmMain.tbtnStarClick(Sender: TObject);

begin

  if (pgControl.ActivePageIndex <> PAGE_AUTHORS) and
     (pgControl.ActivePageIndex <> PAGE_SERIES)
  then Exit;

  Screen.Cursor := crHourGlass;
  case ActiveView of
    ByAuthorView:
      begin

        ClearLabels(PAGE_AUTHORS, True);
        if Assigned(FLastLetterA) then
            FLastLetterA.Down := False;

        FLastLetterA := (Sender as TToolButton);
        (Sender as TToolButton).Down := True;
        if (Sender as TToolButton).Tag >= 90 then
        case (Sender as TToolButton).Tag of
          91: dmCollection.tblAuthors.Filter := 'UPPER(A_Family) >= "�*"';
          92: dmCollection.tblAuthors.Filter := 'UPPER(A_Family) < "�*"';
        end
        else
        begin
          edLocateAuthor.Text := (Sender as TToolButton).Caption;
          dmCollection.tblAuthors.Filter := '(A_Family=' + QuotedStr((Sender as TToolButton).Caption + '*') +
               ') OR (A_Family=' + QuotedStr(AnsiLowercase((Sender as TToolButton).Caption) + '*') + ')';
        end;
        dmCollection.tblAuthors.Filtered := (Sender as TToolButton).Tag <> 90;
        FillAuthorTree(tvAuthors);

        //tvAuthors.Selected[tvAuthors.GetFirst] := True;
        edLocateAuthor.Perform(WM_KEYDOWN, VK_RIGHT, 0);
      end;
    BySeriesView:
      begin
        ClearLabels(PAGE_SERIES, True);
        if Assigned(FLastLetterS) then
          FLastLetterS.Down := False;
        FLastLetterS := (Sender as TToolButton);
        (Sender as TToolButton).Down := True;

        if (Sender as TToolButton).Tag >= 90 then
        case (Sender as TToolButton).Tag of
          90: dmCollection.tblSeries.Filter := 'S_Title <>' + QuotedStr(NO_SERIES_TITLE);
          91: dmCollection.tblSeries.Filter := 'UPPER(S_Title) >= "�*"';
          92: dmCollection.tblSeries.Filter := 'UPPER(S_Title) < "A*" and S_Title <>' + QuotedStr(NO_SERIES_TITLE);
        end
        else
        begin
          edLocateSeries.Text := (Sender as TToolButton).Caption;
          dmCollection.tblSeries.Filter := '(S_Title=' + QuotedStr((Sender as TToolButton).Caption + '*') +
               ') OR (S_Title=' + QuotedStr(AnsiLowercase((Sender as TToolButton).Caption) + '*') + ')';
        end;
        dmCollection.tblSeries.Filtered := true;
        FillSeriesTree;
        tvSeries.Selected[tvSeries.GetFirst] := True;
        edLocateSeries.Perform(WM_KEYDOWN, VK_RIGHT, 0);
      end;
  end;
  Screen.Cursor := crDefault;
end;

procedure TfrmMain.TrayIconDblClick(Sender: TObject);
begin
  Visible := not Visible;
  TrayIcon.Visible := not Visible;
end;

procedure TfrmMain.tbtnShowLocalOnlyClick(Sender: TObject);
begin

  SavePositions;

  Settings.ShowLocalOnly := not Settings.ShowLocalOnly;
  tbtnShowLocalOnly.Down := Settings.ShowLocalOnly ;

  SetAuthorsShowLocalOnly;
  SetSeriesShowLocalOnly;
  SetBooksFilter;

  FillAuthorTree(tvAuthors);
  FillSeriesTree;
  FillAllBooksTree;

  RestorePositions;
end;

procedure TfrmMain.SetCoversVisible(State: boolean);
begin
  cpCoverA.Visible := State;
  cpCoverS.Visible := State;
  cpCoverG.Visible := State;
  cpCoverF.Visible := State;
  cpCoverSR.Visible := State;
end;

procedure TfrmMain.tbtnShowCoverClick(Sender: TObject);
var
  Visible: boolean;
begin
  Settings.ShowInfoPanel := not Settings.ShowInfoPanel;

//  Visible := (Settings.ShowInfoPanel and not isNonFb2Collection(DMUser.ActiveCollection.CollectionType)
//             or (Settings.ShowInfoPanel and isNonFB2Collection(DMUser.ActiveCollection.CollectionType)
//                 and Settings.AllowMixed));

  Visible :=  Settings.ShowInfoPanel;

  SetCoversVisible(Visible);
  if Visible then
        tvBooksTreeChange(Nil,Nil);
end;

procedure TfrmMain.tbClearEdAuthorClick(Sender: TObject);
begin
  edLocateAuthor.Clear;
  frmMain.ActiveControl := edLocateAuthor;
end;

procedure TfrmMain.tbCollapseClick(Sender: TObject);
var
  Tree: TVirtualStringTree;
begin
  GetActiveTree(Tree);
  if Tree.Expanded[Tree.GetFirst] then
    Tree.FullCollapse(nil)
  else
    Tree.FullExpand(nil);
end;

function TfrmMain.GetViewTree(view: TView): TVirtualStringTree;
begin
  case view of
    ByAuthorView: Result := tvBooksA;
    BySeriesView: Result := tvBooksS;
    ByGenreView: Result := tvBooksG;
    SearchView: Result := tvBooksSR;
    FavoritesView: Result := tvBooksF;
  else
    begin
      Assert(False, '��������� �������������, �������� ������');
      Result := nil;
    end;
  end;
end;

procedure TfrmMain.GroupMenuItemClick(Sender: TObject);
begin
  if DMUser.ActivateGroup((Sender as TMenuItem).Tag) then
        miAddFavoritesClick(Sender);
end;

procedure TfrmMain.GetActiveTree(var Tree: TVirtualStringTree);
begin
  Tree := GetViewTree(ActiveView);
end;

procedure TfrmMain.Selection(SelState: boolean);
var
  Node: PVirtualNode;
  tree: TVirtualStringTree;
begin
  GetActiveTree(Tree);
  Tree.BeginUpdate;
  Node := Tree.GetFirst;
  while Assigned(Node) do
  begin
    if SelState then
      Node.CheckState := csCheckedNormal
    else
      Node.CheckState := csUnCheckedNormal;
    Node := Tree.GetNext(Node);
  end;
  Tree.EndUpdate;
end;

procedure TfrmMain.SelectNextBook(Changed, Frwrd: boolean);
var
  Tree : TVirtualstringTree;
  NewNode, OldNode : PVirtualNode;
  Data : PBookData;
begin
  if Changed then SaveFb2DataAfterEdit(FLastBookRecord);
  GetActiveTree(Tree);
  repeat
    OldNode := Tree.GetFirstSelected;
    if Frwrd then
    begin
      NewNode := Tree.GetNext(OldNode);
      if NewNode = Nil then NewNode := Tree.GetFirst;
    end
    else
    begin
      NewNode := Tree.GetPrevious(OldNode);
      if NewNode = Nil then NewNode := Tree.GetLast;
    end;
    Tree.Selected[OldNode] := False;
    Tree.Selected[NewNode] := True;
    Data := Tree.GetNodeData(NewNode);
    FLastActiveBookID := Data.ID;
  until Data.nodeType = ntBookInfo;
  PrepareFb2EditData(Data, FLastBookRecord);
end;

procedure TfrmMain.tbSelectAllClick(Sender: TObject);
begin
  FSelectionState := not FSelectionState;
  Selection(FSelectionState);
end;

//- - - - - - ������ ���� ��� ������, ����� � ���������� - - - - - - - - - - - -

procedure TfrmMain.FillBooksTree(
  const ParentID: Integer;
  const Tree: TVirtualStringTree;
  const Master: TDataset;
  const Detail: TDataset;
  ShowAuth: Boolean;
  ShowSer: Boolean
  );
var
  Data: PBookData;
  authorNode: PVirtualNode;
  seriesNode: PVirtualNode;
  bookNode: PVirtualNode;
  LastSeries: PVirtualNode;
  Max, i: Integer;
  DBCode: COLLECTION_TYPE;
  TableA: TDataSet;
  TableB: TDataSet;
  Auth, LastAuth: String;
  CollectionName: String;
  Columns: TColumnSet;

      function GetColumns: TColumnSet;
      var
        i: integer;
      begin
        Result := [];
        for I := 0 to Tree.Header.Columns.Count - 1 do
          Include(Result,Tree.Header.Columns[i].Tag);
      end;


begin
  if Assigned(Master) then
    TableA := Master
  else
    TableA := Detail;

  Columns := GetColumns;
  spProgress.Visible := True;  
  TableB := Detail;

  // ���� ������� "�������" ����� �����������, ������������� ���������� �����
  // ����������
  if Settings.TreeModes[Tree.Tag] = tmFlat then
  begin
    ShowAuth := False;
    ShowSer  := False;
  end;

  DBCode := DMUser.ActiveCollection.CollectionType;
  LastAuth := '';
  LastSeries := nil;

  BookTreeStatus := bsBusy;
  try
    Tree.BeginUpdate;
    try
      Tree.Clear;
      Tree.NodeDataSize := SizeOf(TBookData);
      Screen.Cursor := crHourGlass;
      try
        spStatus.Caption := '���������� ������ ...';

        i := 0;
        try
          TableB.DisableControls;
          try
            Max := TableA.RecordCount;

            TableA.First;
            while not TableA.Eof do
            begin
              //
              // ��� ���� ������ � ������� ��� ����, ��������� � ��������� ������
              //
              if TableB.IsEmpty then
              begin
                TableA.Next;
                Continue;
              end;

              // �������������� ������ �� ����������� ��������� �� �������� �������!
              // ��� ��������� �� ���� ����������� ���������
              if Tree.Tag = 4 then
              begin
                if DMUser.ActivateCollection(TableB.FieldByName('DatabaseId').AsInteger) then
                  CollectionName := DMUser.ActiveCollection.Name
                else
                  CollectionName := '����������� ���������';
              end;

              if Tree.Tag <> 4 then
                  Auth := dmCollection.FullName(TableB.FieldByName('Id').AsInteger)
              else
                  Auth := TableB.FieldByName('FullName').AsString;

              if ShowAuth then
              begin
                if LastAuth <> Auth then
                begin
                  authorNode := Tree.AddChild(nil);
                  Data := Tree.GetNodeData(authorNode);
                  Data.nodeType := ntAuthorInfo;
                  Data.FullName := Auth;
                  LastAuth := Auth;
                  LastSeries := nil;
                  if Tree.Tag = 4 then Data.ColName := CollectionName;
                 end;
              end
              else
                authorNode := nil;

              if ShowSer then
              begin
                if TableB.FieldByName('SerID').AsInteger = 1 then
                  seriesNode := authorNode
                else
                begin
                  seriesNode := FindSeriesInTree(Tree, authorNode, TableB.FieldByName('SerID').AsInteger);

                  if not Assigned(seriesNode) then
                  begin
                    if ShowAuth then
                    begin
                      if Assigned(LastSeries) then
                        seriesNode := Tree.InsertNode(LastSeries, amInsertAfter)
                      else
                        seriesNode := Tree.InsertNode(authorNode, amAddChildFirst);
                    end
                    else if not Assigned(LastSeries) then
                      seriesNode := Tree.InsertNode(Tree.GetFirst, amInsertBefore)
                    else
                      seriesNode := Tree.InsertNode(LastSeries, amInsertAfter);

                    Data := Tree.GetNodeData(seriesNode);
                    Data.nodeType := ntSeriesInfo;
                    Data.Series := TableB.FieldByName('Series').AsString;
                    Data.SeriesID := TableB.FieldByName('SerID').AsInteger;

                    LastSeries := seriesNode;
                  end;
                end;
              end
              else
                seriesNode := authorNode;

              bookNode := Tree.AddChild(seriesNode);
              Data := Tree.GetNodeData(bookNode);
              Data.ID := TableB.FieldByName('ID').AsInteger;
              Data.Title := TableB.FieldByName('Title').AsString;
              Data.Series := TableB.FieldByName('Series').AsString;

              Data.FullName := Auth;
              Data.Progress := TableB.FieldByName('Progress').AsInteger;
              Data.Code := TableB.FieldByName('Code').AsInteger;

              if (COL_NO) in Columns then Data.No := TableB.FieldByName('SeqNumber').AsInteger;

              if (COL_SIZE in Columns) then Data.Size := TableB.FieldByName('Size').AsInteger;

              if (COL_DATE in Columns) then Data.Date := TableB.FieldByName('Date').AsDateTime;

              if (COL_TYPE in Columns) then
              begin
                Data.FileType := TableB.FieldByName('Ext').AsString;
                Delete(Data.FileType,1,1);
              end;

              if (COL_COLLECTION in Columns) then Data.ColName := CollectionName;

              if Tree.Tag <> 4 then
                  Data.Genre := dmCollection.GetBookGenres(TableB.FieldByName('ID').AsInteger,False)
                else
                  Data.Genre := TableB.FieldByName('Genres').AsString;

              if (COL_SERIES in Columns) and (TableB.FieldByName('SerID').AsInteger <> 1) then
                Data.Series := TableB.FieldByName('Series').AsString;

              if isOnlineCollection(DBCode) and not TableB.FieldByName('Local').IsNull then
                Data.Locale := TableB.FieldByName('Local').AsBoolean;

              if (COL_RATE in Columns) and (not TableB.FieldByName('Rate').IsNull) then
                Data.Rate := TableB.FieldByName('Rate').AsInteger;

              if (COL_LANG in Columns) and (not TableB.FieldByName('Lang').IsNull) then
                Data.Lang := TableB.FieldByName('Lang').AsString;

              if (COL_LIBRATE in Columns) and (not TableB.FieldByName('LibRate').IsNull) then
                Data.LibRate := TableB.FieldByName('LibRate').AsInteger;

              Data.Deleted := TableB.FieldByName('Deleted').Value;

              Data.nodeType := ntBookInfo;

              Inc(i);
              spProgress.Percent := i * 100 div Max;

              TableA.Next;
            end; //while

            Tree.FullExpand();

            if ShowSer then
            begin
              authorNode := Tree.GetFirst;
              while Assigned(authorNode) do
              begin
                Data := Tree.GetNodeData(authorNode);
                if Data.nodeType = ntSeriesInfo then
                  SortChild(Tree, authorNode);

                if (Data.nodeType = ntAuthorInfo) and (authorNode.ChildCount = 0) then
                  Tree.DeleteNode(authorNode, True); { TODO -oNickR -cBug : ��� �������� ���� ��������� GetNext ���������� }

                authorNode := Tree.GetNext(authorNode);
              end;
            end;

            case Tree.Tag of
              0: lblBooksTotalA.Caption := Format('(%d)', [i]);
              1: lblBooksTotalS.Caption := Format('(%d)', [i]);
              2: lblBooksTotalG.Caption := Format('(%d)', [i]);
              4: lblBooksTotalF.Caption := Format('(%d)', [i]);
              3: lblTotalBooksFL.Caption := Format('(%d)', [i]);
            end;

          finally
            spProgress.Percent := 100;
            spProgress.Visible := False;
            spStatus.Caption := '������';
            DMUser.ActivateCollection(Settings.ActiveCollection);

            if (Settings.TreeModes[Tree.Tag] = tmFlat) then
                  Tree.SortTree(FSortSettings[Tree.Tag].Column, FSortSettings[Tree.Tag].Direction);
          end;
        finally
          TableB.EnableControls;
        end;
      finally
        Screen.Cursor := crDefault;
      end;
    finally
      Tree.EndUpdate;
    end;
  finally
    BookTreeStatus := bsFree;
  end;
end;

procedure TfrmMain.miCopyAuthorClick(Sender: TObject);
var
  treeView: TVirtualStringTree;

  Data: PAuthorData;
  DataG: PGenreData;
  strText: String;

  Node: PVirtualNode;

begin
  case ActiveView of
    ByAuthorView: treeView := tvAuthors;
    BySeriesView: treeView := tvSeries;
    ByGenreView: treeView := tvGenres;
  else
    Assert(False);
  end;

  strText := '';

  case ActiveView of
    ByAuthorView, BySeriesView:
      begin
        Node := treeView.GetFirstSelected;
        while Node <> nil do
        begin
          Data := treeView.GetNodeData(Node);
          if strText = '' then
            strText := Data.Text
          else
            strText := strText + #13#10+ Data.Text;
          Node := treeView.GetNextSelected(Node);
        end;
      end;

    ByGenreView:
      begin
        Node := treeView.GetFirstSelected;
        while Node <> nil do
        begin
          DataG := treeView.GetNodeData(Node);
          if strText = '' then
            strText := DataG.Text
          else
            strText := strText + #13#10+ DataG.Text;
          Node := treeView.GetNextSelected(Node);
        end;
      end;
  end;


  Clipboard.AsText := trim(strText);
end;

procedure TfrmMain.miCopyClBrdClick(Sender: TObject);
var
  Tree: TVirtualStringTree;
  S,R: String;
  Data: PBookData;
  Node: PVirtualNode;

begin
  GetActiveTree(Tree);

  S := ''; R := '';

  Node := Tree.GetFirstSelected;
  while Node <> Nil do
  begin
    Data := Tree.GetNodeData(Node);

    case Data.nodeType of
      ntSeriesInfo:
        S := Data.FullName + '. �����: ' + Data.Series;

      ntBookInfo:
        if (Data.Series = '---') or (Data.Series = '') then
          S := Data.FullName + '. ' + Data.Title
        else
          S := Data.FullName + '. �����: ' + Data.Series + '. ' + Data.Title;
    end;
    if S = '' then
        R := S
      else
        R := R + #13#10 + S;

    Node := Tree.GetNextSelected(Node);
  end;
  Clipboard.AsText := trim(R);
end;

procedure TfrmMain.miDeleteBookClick(Sender: TObject);
var
  Tree: TVirtualStringTree;
  Node, OldNode: PvirtualNode;
  Data: PBookData;
  ALibrary: TMHLLibrary;
  FUpdateFavorites: Boolean;

  FileName,Folder, Ext: string;
  No: integer;


begin
  FUpdateFavorites := False;

  if ActiveView = FavoritesView then
  begin
    MessageDlg('��� �������� ����� ��������� ' + #13 + '� ��������������� ���������', mtWarning, [mbOk], 0);
    Exit;
  end;

  if MessageDlg('������� ���������� �����?', mtConfirmation, [mbYes, mbNo], 0) = mrNo then
    Exit;

  GetActiveTree(Tree);

  ALibrary := TMHLLibrary.Create(nil);
  try
    ALibrary.DatabaseFileName := DMUser.ActiveCollection.DBFileName;
    ALibrary.Active := True;

    Node := Tree.GetFirst;
    while Assigned(Node) do
    begin
      Data := Tree.GetNodeData(Node);
      Assert(Assigned(Data));

      if (Data.nodeType = ntBookInfo) and ((Tree.CheckState[Node] = csCheckedNormal) or (Tree.Selected[Node])) then
      begin
        if isOnlineCollection(DMUser.ActiveCollection.CollectionType) and Data.Locale then
        begin
          dmCollection.GetBookFileName(Data.ID, FileName, Folder, Ext, No);
          if DeleteFile(FCollectionRoot + Folder) then
            dmCollection.SetLocalStatus(Data.ID,False);
        end
        else
        begin

          ALibrary.BeginBulkOperation;
          try
            ALibrary.DeleteBook(Data.ID);
            ALibrary.EndBulkOperation(True);
          except
            ALibrary.EndBulkOperation(False);
          end;

          if DMUser.tblGrouppedBooks.Locate('DatabaseID;OuterID', VarArrayOf([Settings.ActiveCollection, Data.ID]), []) then
          begin
            DMUser.tblGrouppedBooks.Delete;
            FUpdateFavorites := True;
          end;
        end;
        OldNode := Node;
        Node := Tree.GetNext(Node);
        Tree.DeleteNode(OldNode);
        ClearLabels(Tree.Tag, False);
      end
      else
        Node := Tree.GetNext(Node);
    end;
  finally
    ALibrary.Free;
  end;
end;

procedure TfrmMain.miDeleteColClick(Sender: TObject);
begin
  DMUser.ActivateCollection(Settings.ActiveCollection);

  { TODO -oNickR -cUsability : �����, ����� ������� ����������� ������ ��� ����� ������. ����� �� ������ ��������, ������� ���� ��������� ��� ���. }
  if MessageDlg('������� �������� "' + DMUser.ActiveCollection.Name + '"?', mtConfirmation, [mbYes, mbNo], 0) = mrNo then
    Exit;

  DMUser.tblBases.Delete;
  DMUser.tblBases.First;
  Settings.ActiveCollection := DMUser.ActiveCollection.ID;
  InitCollection(True);
end;

procedure TfrmMain.miDeleteFilesClick(Sender: TObject);
var
  Node: PvirtualNode;
  Data: PBookData;
  Tree: TVirtualStringTree;
begin
  GetActiveTree(Tree);
  Node := Tree.GetFirst;
  while Assigned(Node) do
  begin
    Data := Tree.GetNodeData(Node);

    if (Data.nodeType = ntBookInfo) and
       ((tvBooksG.CheckState[Node] = csCheckedNormal) or (tvBooksG.Selected[Node]))
       and Data.Locale then
    begin
      if dmCollection.tblBooks.Locate('ID',Data.ID,[]) then
      begin

        // ������ ��� online-���������. ������� �������� ���� � ����� �� ���������� �����
        try
          DeleteFile(FCollectionRoot + dmCollection.tblBooksFolder.Value);
        except

        end;

        dmCollection.tblBooks.Edit;
        dmCollection.tblBooksLocal.Value := False;
        dmCollection.tblBooks.Post;

        Data.Locale := False;
        tvBooksG.CheckState[Node] := csUnCheckedNormal;
        Tree.RepaintNode(Node);

          // ������������� � ���������
        DMUser.SetLocal(Data.ID, False);
      end;
    end;
    Node := Tree.GetNext(Node);
  end;
end;

procedure TfrmMain.miDelFavoritesClick(Sender: TObject);
var
  Node: PvirtualNode;
  Data: PBookData;
begin
  Node := tvBooksF.GetFirst;
  while Assigned(Node) do
  begin
    Data := tvBooksF.GetNodeData(Node);
    Assert(Assigned(Data));
    if (Data.nodeType = ntBookInfo) and ((tvBooksG.CheckState[Node] = csCheckedNormal) or (tvBooksG.Selected[Node])) then
    begin
      DMUser.tblGrouppedBooks.Locate('ID', Data.ID, []);
      DMUser.tblGrouppedBooks.Delete;
    end;
    Node := tvBooksF.GetNext(Node);
  end;
  FillBooksTree(0, tvBooksF, nil, DMUser.tblGrouppedBooks, True, True);
  ClearLabels(PAGE_FAVORITES, True);
end;

function TfrmMain.GetActiveBookTable(tag:integer):TAbsTable;
begin
  if Tag = 4 then
    Result := DMUser.tblGrouppedBooks
  else
    Result := dmCollection.tblBooks;
end;

procedure  TfrmMain.RefreshBooksState(Tree: TVirtualStringTree; BookIDList: TBookIdList );
var
  i: integer;
  Data: PBookData;
  Node: PVirtualNode;
  Max : integer;
begin
  //
  // NickR - �������, ������ �� �����
  // { TODO -oNickR -cunused code : ������� }
  //
  Node := Tree.GetFirst;
  i := 0; Max := High(BookIDList);
  while Assigned(Node) do
  begin
    Data := Tree.GetNodeData(Node);
    if Data.ID = BookIDList[i].ID then
    begin
      Data.Locale := BookIDList[i].Res;
      Tree.RepaintNode(Node);
      Inc(i);
      if i > Max then Break;
    end;
    Node := Tree.GetNext(Node);
  end;
end;

procedure TfrmMain.miDownloadBooksClick(Sender: TObject);
var
  BookIDList: TBookIdList;
  Tree: TVirtualStringTree;

  i: integer;
  Folder: string;

  LibID : integer;

  Node: PVirtualNode;
  Data: PDownloadData;

  Local: boolean;

    function CheckID(ID: integer):boolean;
    var
      Node: PVirtualNode;
      Data: PDownloadData;
    begin
      Result := False;
      Node := tvDownloadList.GetFirst;
      while Node <> nil do
      begin
        Data := tvDownloadList.GetNodeData(Node);
        if Data.ID = ID then
        begin
          Result := True;
          Break;
        end;

        Node := tvDownloadList.GetNext(Node);
      end;
    end;

begin
  if ActiveView = DownloadView then
  begin
    btnDeleteDownloadClick(Sender);
    Exit;
  end;

  GetActiveTree(Tree);

  FillBookIdList(Tree, BookIDList);

  for I := 0 to High(BookIDList) do
  begin

    dmCollection.FieldByName(BookIDList[i].ID, 'Local', Local);
    if Local then Continue;

    if ActiveView = FavoritesView then
    begin
      DMUser.tblGrouppedBooks.Locate('OuterID', BookIDList[i].ID, []);
      if DMUser.tblGrouppedBooksDataBaseId.Value <> DMUser.ActiveCollection.ID then
         Continue;
    end;

    if CheckID(BookIDList[i].ID) then
      Continue;

    dmCollection.GetBookFolder(BookIDList[i].ID,Folder);

    Node := tvDownloadList.AddChild(nil);
    Data := tvDownloadList.GetNodeData(Node);

    if ActiveView = FavoritesView  then
      Data.Author := DMUser.tblGrouppedBooksFullName.Value
    else
      Data.Author := dmCollection.FullName(BookIDList[i].ID);

    dmCollection.FieldByName(BookIDList[i].ID, 'Title', Data.Title);
    dmCollection.FieldByName(BookIDList[i].ID, 'Size', Data.Size);
    dmCollection.FieldByName(BookIDList[i].ID, 'LibID', LibID);
    Data.ID := BookIDList[i].ID;
    Data.State := dsWait;
    Data.FileName := Folder;
    Data.URL := Format(Settings.DownloadURL + 'b/%d/download', [LibID]);
  end; // for

  lblDownloadCount.Caption := Format('(%d)',[tvDownloadList.ChildCount[Nil]]);

  if Settings.AutoStartDwnld then
    btnStartDownloadClick(Sender);
end;

procedure TfrmMain.miEditAuthorClick(Sender: TObject);
var
  Tree: TVirtualStringTree;
  Node: PVirtualNode;
  Data: PBookData;
  Res: boolean;
  S: string;

  old_AiD: integer;
  new_AiD: integer;

begin
  if ActiveView = FavoritesView then
  begin
    MessageDlg('�������������� ���� �� ���������� ����������.', mtWarning, [mbOk], 0);
    Exit;
  end;

  if IsLibRusecEdit(0) then
    Exit;
    
  GetActiveTree(Tree);

  Node := Tree.GetFirstSelected;
  Data := Tree.GetNodeData(Node);
  if not Assigned(Data) then
    Exit;

  dmCollection.tblAuthor_List.Locate('AL_BookId', Data.ID, []);
  dmCollection.tblAuthors.Locate('A_ID', dmCollection.tblAuthor_List['AL_AuthID'], []);
  old_AiD := dmCollection.tblAuthor_List['AL_AuthID'];

  frmEditAuthor.edFamily.Text := dmCollection.tblAuthors.FieldByName('A_Family').AsString;
  frmEditAuthor.edName.Text := dmCollection.tblAuthors.FieldByName('A_Name').AsString;
  frmEditAuthor.edMiddle.Text := dmCollection.tblAuthors.FieldByName('A_Middle').AsString;

  frmEditAuthor.ShowCheckBoxes := True;

  if frmEditAuthor.ShowModal = mrOk then
  begin

    S := trim(AnsiUpperCase(frmEditAuthor.edFamily.Text + ' ' +
                                 frmEditAuthor.edName.Text + ' ' +
                                 frmEditAuthor.edMiddle.Text));

    if (not frmEditAuthor.AddNew) and (not frmEditAuthor.SaveLinks) then
    begin    // ������ ������ ������ �� ������, ��� ������ �������� �� �����

      if dmCollection.tblAuthors.Locate('A_Family;A_Name;A_Middle',
                            VarArrayOf([frmEditAuthor.edFamily.Text,
                                        frmEditAuthor.edName.Text,
                                        frmEditAuthor.edMiddle.Text]),
                                        [loCaseInsensitive]) then
      begin  // ���� ����� ����� ��� ����, ������ ������ �� ����  (�����������)
        new_AiD := dmCollection.tblAuthorsID.Value;
        repeat
          // ������ ������ Id �� �����
          { TODO -oNickR -cRefactoring : ����� �������� �� ���� UPDATE }
          dmCollection.tblAuthor_List.MasterSource := nil;

          Res := dmCollection.tblAuthor_List.Locate('AL_AuthID',old_Aid,[]);
          if Res then
          begin
            dmCollection.tblAuthor_List.Edit;
            dmCollection.tblAuthor_ListAL_AuthID.Value := new_AiD;
            dmCollection.tblAuthor_List.Post;
          end;
        until not Res;

        // ��������� ��������� ����
        { TODO -oNickR -cRefactoring : ����� �������� �� ���� UPDATE }
        repeat
          Res := dmCollection.tblBooks.Locate('FullName', AnsiUpperCase(Data.FullName), [loCaseInsensitive]);
          if Res then
          begin
            dmCollection.tblBooks.Edit;
            dmCollection.tblBooksFullName.Value := S;
            dmCollection.tblBooks.Post;
          end;
        until not Res;

        if dmCollection.tblAuthors.Locate('A_ID', old_Aid,[]) then
           dmCollection.tblAuthors.Delete;   // ������� ������ �������
        dmCollection.tblAuthor_List.MasterSource := dmCollection.dsAuthors;
      end // if Locate
      else  // ���� ��� - ������ ����������� ���
      begin
        dmCollection.tblAuthors.Edit;
        dmCollection.tblAuthorsFamily.Value := frmEditAuthor.edFamily.Text;
        dmCollection.tblAuthorsName.Value := frmEditAuthor.edName.Text;
        dmCollection.tblAuthorsMiddle.Value := frmEditAuthor.edMiddle.Text;
        dmCollection.tblAuthors.Post;
      end;

      repeat
        { TODO -oNickR -cRefactoring : ����� �������� �� ���� UPDATE }
        Res := dmCollection.tblBooks.Locate('FullName', AnsiUpperCase(Data.FullName), [loCaseInsensitive]);
        if Res then
        begin
          dmCollection.tblBooks.Edit;
          dmCollection.tblBooksFullName.Value := S;
          dmCollection.tblBooks.Post;
        end;
      until not Res;
    end;

    if (frmEditAuthor.AddNew) then
    begin    // �������� ������ �� ������

      // ��������� ������ ������
      if not dmCollection.tblAuthors.Locate('A_Family;A_Name;A_Middle',
                            VarArrayOf([frmEditAuthor.edFamily.Text,
                                        frmEditAuthor.edName.Text,
                                        frmEditAuthor.edMiddle.Text]),
                                        [loCaseInsensitive]) then
      begin
        dmCollection.tblAuthors.Insert;
        dmCollection.tblAuthorsFamily.Value := frmEditAuthor.edFamily.Text;
        dmCollection.tblAuthorsName.Value := frmEditAuthor.edName.Text;
        dmCollection.tblAuthorsMiddle.Value := frmEditAuthor.edMiddle.Text;
        dmCollection.tblAuthors.Post;
      end;

      // ������ ������
      dmCollection.tblAuthor_List.MasterSource := nil;

      Node := Tree.GetFirst;
      while Node <> Nil do
      begin
        Data := Tree.GetNodeData(Node);
        if (Data.nodeType = ntBookInfo) and
            ((Tree.CheckState[Node] = csCheckedNormal) or
            (Tree.Selected[Node])) then
        begin
          if not frmEditAuthor.SaveLinks then   // �������� ������
          begin
            if dmCollection.tblAuthor_List.Locate('AL_BookID',Data.ID,[]) then
            begin
              dmCollection.tblAuthor_List.Edit;
              dmCollection.tblAuthor_ListAL_AuthID.Value := dmCollection.tblAuthorsID.Value;
              dmCollection.tblAuthor_List.Post;
            end
          end
          else
          begin // ��������� ������� ������
            dmCollection.tblAuthor_List.Insert;
            dmCollection.tblAuthor_ListAL_AuthID.Value := dmCollection.tblAuthorsID.Value;
            dmCollection.tblAuthor_ListAL_BookID.Value := Data.ID;

            dmCollection.tblAuthor_ListAL_Series.Value := Copy(Data.Series, 1, IndexSize);
            dmCollection.tblAuthor_ListAL_Title.Value := Copy(Data.Title, 1, IndexSize);

            dmCollection.tblAuthor_List.Post;
          end;
          dmCollection.tblBooks.Locate('ID', Data.ID, []);
          dmCollection.tblBooks.Edit;
          dmCollection.tblBooksFullName.Value:= S;
          dmCollection.tblBooks.Post;
        end;
        Node := Tree.GetNext(Node,False);
      end;
      dmCollection.tblAuthor_List.MasterSource := dmCollection.dsAuthors;
    end;
    InitCollection(True);
  end;
end;

function TfrmMain.IsLibRusecEdit(ID: integer): boolean;
begin
  if isExternalCollection(DMUser.ActiveCollection.CollectionType) then
  begin
    if MessageDlg('��������� ���������� � ������ � ���������� "lib.rus.ec" �������� ������ �� �����.' + #13 +
      '������� �� ���� "����������� ���������� lib.rus.ec"?',
      mtWarning, [mbYes, mbNo], 0) = mrYes then
    begin
      dmCollection.tblBooks.Locate('ID', ID, []);
      ShellExecute(handle, 'open', PChar('http://lib.rus.ec/b/' + IntToStr(dmCollection.tblBooks['LibID']) + '/edit'), nil, nil, SW_SHOW);
    end;
    Result := True;
  end
  else
    Result := False;
end;

procedure TfrmMain.PrepareFb2EditData(Data: PBookData; var R: TBookRecord);
var
  Family: TListItem;

  Author: TAuthorRecord;
  Genre: TGenreRecord;

begin

  GetBookRecord(Data.ID, R);
  frmEditBookInfo.lvAuthors.Items.Clear;
  for Author in R.Authors do
  begin
    Family := frmEditBookInfo.lvAuthors.Items.Add;
    Family.Caption := Author.LastName;
    Family.SubItems.Add(Author.FirstName);
    Family.SubItems.Add(Author.MiddleName);
  end;
  frmEditBookInfo.lblGenre.Caption := '';
  FillGenresTree(frmGenreTree.tvGenresTree);
  for Genre in R.Genres do
  begin
    frmGenreTree.SelectGenres(Genre.GenreCode);
    frmEditBookInfo.lblGenre.Caption := frmEditBookInfo.lblGenre.Caption + Genre.Alias + ';';
  end;
  frmEditBookInfo.edT.Text := R.Title;

  if R.Series = NO_SERIES_TITLE then
    frmEditBookInfo.cbSeries.Text := ''
  else
    frmEditBookInfo.cbSeries.Text := R.Series;

  frmEditBookInfo.edSN.Text := IntToStr(R.SeqNumber);
  frmEditBookInfo.edKeyWords.Text := R.KeyWords;
  frmEditBookInfo.cbLang.Text := R.Lang;

end;

procedure TfrmMain.SaveFb2DataAfterEdit(R: TBookRecord);
var
  Tree: TVirtualStringTree;
  Data: PBookData;
  Node: PVirtualNode;
  i: integer;
  ALibrary : TMHLLibrary;
begin

  GetActiveTree(Tree);
  Node := Tree.GetFirstSelected;

  Data := Tree.GetNodeData(Node);
  if not Assigned(Data) or (Data.nodeType <> ntBookInfo) then
    Exit;

  R.ClearAuthors;

  for I := 0 to frmEditBookInfo.lvAuthors.Items.Count - 1 do
      R.AddAuthor(
        frmEditBookInfo.lvAuthors.Items[i].Caption,
        frmEditBookInfo.lvAuthors.Items[i].SubItems[0],
        frmEditBookInfo.lvAuthors.Items[i].SubItems[1]
        );

  frmGenreTree.GetSelectedGenres(R);
  R.Title := frmEditBookInfo.edT.Text;
  R.Series := frmEditBookInfo.cbSeries.Text;

  R.SeqNumber := Round(frmEditBookInfo.edSN.Value);
  R.KeyWords := frmEditBookInfo.edKeyWords.Text;
  R.Lang := frmEditBookInfo.cbLang.Text;

  ALibrary := TMHLLibrary.Create(nil);
  try
    ALibrary.DatabaseFileName := DMUser.ActiveCollection.DBFileName;
    ALibrary.Active := True;

    ALibrary.BeginBulkOperation;
    try
      ALibrary.DeleteBook(Data.ID);
      Data.ID := ALibrary.InsertBook(R, False, False);
      ALibrary.EndBulkOperation(True);
    except
      ALibrary.EndBulkOperation(False);
    end;

    Data.Title := frmEditBookInfo.edT.Text;
    Data.Genre := frmEditBookInfo.lblGenre.Caption;
    Data.No := Round(frmEditBookInfo.edSN.Value);
    Data.Lang := frmEditBookInfo.cbLang.Text;
    Tree.RepaintNode(Node);
  finally
    ALibrary.Free;
  end;
end;


procedure TfrmMain.miEditBookClick(Sender: TObject);
var
  Tree: TVirtualStringTree;
  Data: PBookData;
  Node: PVirtualNode;
begin
  if (ActiveView = FavoritesView) or (ActiveView = DownloadView) then
  begin
    MessageDlg('�������������� ���� �� ���������� ��� ������ ������� ����������.', mtWarning, [mbOk], 0);
    Exit;
  end;

  GetActiveTree(Tree);
  Node := Tree.GetFirstSelected;
  Data := Tree.GetNodeData(Node);
  if not Assigned(Data) or (Data.nodeType <> ntBookInfo) then
    Exit;

  if IsLibRusecEdit(Data.Id) then
    Exit;

  PrepareFb2EditData(Data, FLastBookRecord);

  if frmEditBookInfo.ShowModal = mrOk then
  begin
    SaveFb2DataAfterEdit(FLastBookRecord);
    SavePositions;
    InitCollection(True);
    RestorePositions;
  end;
end;

procedure TfrmMain.miEditGenresClick(Sender: TObject);
var
  NodeB, NodeG: PvirtualNode;
  DataG: PGenreData;
  DataB: PBookData;
  Tree: TVirtualStringTree;
  ALibrary: TMHLLibrary;
begin
  if ActiveView = FavoritesView then
  begin
    MessageDlg('�������������� ���� �� ���������� ����������.', mtWarning, [mbOk], 0);
    Exit;
  end;

  if IsLibRusecEdit(0) then
    Exit;

  GetActiveTree(Tree);

  FillGenresTree(frmGenreTree.tvGenresTree);

  if frmGenreTree.ShowModal = mrOk then
  begin
    ALibrary := TMHLLibrary.Create(nil);
    try
      ALibrary.DatabaseFileName := DMUser.ActiveCollection.DBFileName;
      ALibrary.Active := True;

      NodeB := Tree.GetFirst;
      while Assigned(NodeB) do
      begin
        DataB := Tree.GetNodeData(NodeB);
        if (DataB.nodeType = ntBookInfo) and ((Tree.CheckState[NodeB] = csCheckedNormal) or (Tree.Selected[NodeB])) then
        begin
          ALibrary.CleanBookGenres(DataB.ID);

          DataB.Genre := '';
          NodeG := frmGenreTree.tvGenresTree.GetFirstSelected;
          while Assigned(NodeG) do
          begin
            DataG := frmGenreTree.tvGenresTree.GetNodeData(NodeG);

            ALibrary.AddBookGenre(DataB.ID, DataG.Code);

            DataB.Genre := DataB.Genre + DataG.Text + ' / ';
            NodeG := frmGenreTree.tvGenresTree.GetNextSelected(NodeG);
          end;

          Delete(DataB.Genre, length(DataB.Genre) - 2, 3);
        end;
        Tree.RepaintNode(NodeB);
        NodeB := Tree.GetNext(NodeB);
      end;
    finally
      ALibrary.Free;
    end;
  end;
end;

procedure TfrmMain.miEditSeriesClick(Sender: TObject);
var
  Tree: TVirtualStringTree;
  Data: PBookData;
  Node: PVirtualNode;
  AuthID: integer;
  S: string;
begin
  if ActiveView = FavoritesView then
  begin
    MessageDlg('�������������� ���� �� ���������� ����������.', mtWarning, [mbOk], 0);
    Exit;
  end;

  GetActiveTree(Tree);
  Node := Tree.GetFirstSelected;
  Data := Tree.GetNodeData(Node);
  if not Assigned(Data) then
    Exit;

  if IsLibRusecEdit(Data.ID) then
    Exit;

  S := Data.Series;

  if Data.nodeType = ntBookInfo then // ��������� ����� �����
  begin
    AuthID := dmCollection.AuthorID(Data.ID);

    if InputQuery('�������� �����/ ������ � �����', '��������:', S) then
    begin
      if S = '' then S:= NO_SERIES_TITLE;

      if not dmCollection.tblSeriesB.Locate('S_Title;S_AuthID', VarArrayOf([S,AuthID]), []) then
      begin
        dmCollection.tblSeriesB.Insert;
        dmCollection.tblSeriesBS_Title.Value := S;
        dmCollection.tblSeriesBS_AuthID.Value := AuthID;
        dmCollection.tblSeriesBS_GenreCode.Value := dmCollection.GetGenreCode(Data.ID);
        dmCollection.tblSeriesB.Post;
      end;
      Node := Tree.GetFirst;
      while Node <> nil do
      begin
        Data := Tree.GetNodeData(Node);
        if ((Tree.CheckState[Node] = csCheckedNormal) or
           (Tree.Selected[Node])) then
        begin
          dmCollection.tblBooks.Locate('ID', Data.ID, []);
          dmCollection.tblBooks.Edit;
          dmCollection.tblBooksSerID.Value:= dmCollection.tblSeriesBS_ID.Value;
          dmCollection.tblBooks.Post;
        end;
        Node := Tree.GetNext(Node);
      end;
      FillAllBooksTree;
    end;
  end
  else     // ����������� �������� ������������
    if InputQuery('�������������� �����', '��������:', S) then
    begin
      if S = '' then    { TODO : �������� �� ���� update }
      begin
        while dmCollection.tblBooks.Locate('SerID', Data.SeriesID, []) do
        begin
          dmCollection.tblBooks.Edit;
          dmCollection.tblBooksSerID.Value:= 1;
          dmCollection.tblBooks.Post;
        end;
        FillAllBooksTree;
      end
      else
      begin
        dmCollection.tblSeriesB.Locate('S_ID', Data.SeriesID, []);
        dmCollection.tblSeriesB.Edit;
        dmCollection.tblSeriesBS_Title.Value := S;
        dmCollection.tblSeriesB.Post;
        Data.Series := S;
        Tree.RepaintNode(Node);
      end;
    end;

end;

procedure TfrmMain.miAddFavoritesClick(Sender: TObject);
var
  Tree: TVirtualStringTree;
  i, Max: integer;
  Data: PBookData;
  GroupData: PGroupData;

  Node: PVirtualNode;
begin
  GetActiveTree(Tree);
  Max := Tree.TotalCount;

  if Max = 0 then Exit;

  if Sender is TMenuItem then
       DMUser.ActivateGroup((Sender as TMenuItem).Tag)
  else
       DMUser.ActivateGroup(1);

  spProgress.Visible := True;
  spStatus.Caption := '��������� � ���������...';
  Screen.Cursor := crHourglass;
  dmCollection.tblBooks.DisableControls;
  DMUser.tblGrouppedBooks.DisableControls;


  Node := Tree.GetFirst;
  i := 0;
  while Assigned(Node) do
  begin
    Data := Tree.GetNodeData(Node);
    if (Data.nodeType = ntBookInfo) and ((Tree.CheckState[Node] = csCheckedNormal) or (Tree.Selected[Node])) then
      DMUser.InsertToGroupTable(Data.ID, Data.Genre);

    // Tree.CheckState[Node]:=csUnCheckedNormal;
    Inc(i);
    spProgress.Percent := i * 100 div Max;
    spProgress.Repaint;

    Node := Tree.GetNext(Node);
  end;
  spProgress.Visible := False;
  Selection(False);
  dmCollection.tblBooks.EnableControls;
  DMUser.tblGrouppedBooks.EnableControls;
  Screen.Cursor := crDefault;

  // ���� ���������� ������ ��������� � ���, ���� ��������� �����, ����� ������������ ������
  if (tvGroups.SelectedCount > 0) then
  begin
    GroupData := tvGroups.GetNodeData(tvGroups.GetFirstSelected);
    if GroupData.ID = DMUser.tblGroupListID.Value then
      FillBooksTree(0, tvBooksF, nil, DMUser.tblGrouppedBooks, True, True); // �����
  end;
 end;

procedure TfrmMain.miAddToSearchClick(Sender: TObject);
var
  Edit: TRzButtonEdit;
  treeView: TVirtualStringTree;
  Node: PVirtualNode;
  Data: PAuthorData;
begin
  case ActiveView of
    ByAuthorView: begin
                    treeView := tvAuthors;
                    Edit := edFFullName;
                  end;
    BySeriesView: begin
                    treeView := tvSeries;
                    Edit := edFSeries;
                  end
  else
    Assert(False);
  end;

  Node := treeView.GetFirstSelected;
  while Node <> nil do
  begin
    Data := treeView.GetNodeData(Node);
    if Edit.Text = '' then
         Edit.Text := Format('="%s"',[Data.Text])
    else
         Edit.Text := Format('%s OR%s="%s"',[Edit.Text,#13#10,Data.Text]);
    Node := treeView.GetNextSelected(Node);
  end;

end;

procedure TfrmMain.miFastBookSearchClick(Sender: TObject);
begin
  unit_Utils.LocateBook;
end;

procedure TfrmMain.miFb2ImportClick(Sender: TObject);
begin
  DMUser.ActivateCollection(Settings.ActiveCollection);
  dmCollection.DBCollection.Connected := False;

  unit_Import.ImportFB2(DMUser.ActiveCollection);

  InitCollection(True);
end;

procedure TfrmMain.miFb2ZipImportClick(Sender: TObject);
begin
  DMUser.ActivateCollection(Settings.ActiveCollection);
  dmCollection.DBCollection.Connected := False;

  unit_Import.ImportFB2ZIP(DMUser.ActiveCollection);

  InitCollection(True);
end;

procedure TfrmMain.miFBDImportClick(Sender: TObject);
begin
  DMUser.ActivateCollection(Settings.ActiveCollection);
  dmCollection.DBCollection.Connected := False;

  unit_Import.ImportFBD(DMUser.ActiveCollection);

  InitCollection(True);
end;

procedure TfrmMain.miSetRateClick(Sender: TObject);
var
  Tree: TVirtualStringTree;
  Data: PBookData;
  Node: PVirtualNode;
begin
  GetActiveTree(Tree);
  Node := Tree.GetFirstSelected;
  Data := Tree.GetNodeData(Node);
  if not Assigned(Data) or (Data.nodeType <> ntBookInfo) then
    exit;
  Data.Rate := (Sender as TMenuItem).Tag;
  BookTreeStatus := bsBusy;
  if GetActiveView <> FavoritesView then
  begin

    DMUser.SetRate(Data.ID, Data.Rate);

    //
    //  ������������� � ���������
    //
    if (DMUser.tblGrouppedBooks.Locate('DataBaseID;OuterID',
                                  VarArrayOf([DMUser.ActiveCollection.ID,Data.ID]),[]))
    then
    begin
      DMUser.tblGrouppedBooks.Edit;
      DMUser.tblGrouppedBooksRate.Value := Data.Rate;
      DMUser.tblGrouppedBooks.Post;
      FillBooksTree(0, tvBooksF, nil, DMUser.tblGrouppedBooks, True, True); // ���������
    end;
  end
  else // �������� ������� - ���������
  begin
    DMUser.tblGrouppedBooks.Locate('DataBaseID;OuterID;',
                                    VarArrayOf([DMUser.ActiveCollection.ID,Data.ID]),[]);
    DMUser.tblGrouppedBooks.Edit;
    DMUser.tblGrouppedBooksRate.Value := Data.Rate;
    DMUser.tblGrouppedBooks.Post;

    //
    //  ������������� � �������� ���������
    //

    DMUser.SetRate(DMUser.tblGrouppedBooksOuterID.Value, Data.Rate);

    FillBooksTree(0, tvBooksA, dmCollection.tblAuthor_List, dmCollection.tblBooksA, False, True); // ������
    FillBooksTree(0, tvBooksS, nil, dmCollection.tblBooksS, False, False); // �����
  end;

  Tree.RepaintNode(Node);
  BookTreeStatus := bsFree;
end;

procedure TfrmMain.btnSavePresetClick(Sender: TObject);
const d='~;~';
var
  SL : TStringList;
  S  : String;
  FN: string;

begin
  if cbPresetName.Text = '' then Exit;

  FN := cbPresetName.Text + '.mhlf';

  if not FileExists(Settings.PresetPath + FN) then
    cbPresetName.Items.Add(cbPresetName.Text);

  SL := TStringList.Create;
  try
    S := '~' + edFFullName.Text + d +
         edFTitle.Text + d +
         edFSeries.Text + d +
         edFGenre.Text + d +
         edFGenre.Hint + d +
         edFFile.Text + d +
         edFFolder.Text + d +
         edFExt.Text + d +
         cbDate.Text + d +
         cbDownloaded.Text + d +
         BoolToStr(cbDeleted.Checked) + d +
         cbLang.Text + d +
         edFKeyWords.Text + '~';

    SL.Add(S);
    SL.SaveToFile(Settings.PresetPath + FN,TEncoding.UTF8);

    btnDeletePreset.Enabled := True;
  finally
    SL.Free;
  end;
end;

procedure TfrmMain.LocateAuthor(text: String; Tree: TVirtualStringTree);
var
  Node: PVirtualNode;
  Data: PAuthorData;
  L : integer;
begin
  Tree.ClearSelection;
  Node := Tree.GetFirst;

  L := Length(text);
  text := AnsiUpperCase(text);

  while Assigned(Node) do
  begin
    Data := Tree.GetNodeData(Node);
    Assert(Assigned(Data));
    if text = Copy(AnsiUpperCase(Data.Text),1,L) then
    begin
      Tree.Selected[Node] := True;
      Tree.FocusedNode := Node;
      Exit;
    end;
    Node := Tree.GetNext(Node);
  end;
end;

procedure TfrmMain.LocateBook(text: String; Next: boolean );
var
  Node: PVirtualNode;
  Data: PBookData;
  L : integer;
  Tree: TVirtualStringTree;
begin
  GetActiveTree(Tree);

  Tree.ClearSelection;

  if not Next then FLastFoundBook := Nil;


  if Next and (FLastFoundBook <> Nil) then
    Node := Tree.GetNext(FLastFoundBook)
  else
    Node := Tree.GetFirst;

  L := Length(text);
  text := AnsiUpperCase(text);

  while Assigned(Node) do
  begin
    Data := Tree.GetNodeData(Node);
    Assert(Assigned(Data));
    if text = Copy(AnsiUpperCase(Data.Title),1,L) then
    begin
      Tree.Selected[Node] := True;
      Tree.FocusedNode := Node;

      if not next then
           FFirstFoundBook := Node;

      FLastFoundBook := Node;

      Exit;
    end;
    Node := Tree.GetNext(Node);
  end;

  if FFirstFoundBook <> nil then
  begin
    FLastFoundBook := FFirstFoundBook;

    Tree.FocusedNode := FLastFoundBook;
    Tree.Selected[FLastFoundBook] := True;
  end;

end;

procedure TfrmMain.edLocateAuthorChange(Sender: TObject);
var
  S : string;
  OldText:string;
begin
  if FIgnoreChange then Exit;
  S := AnsiUpperCase(copy(edLocateAuthor.Text,1,1));
  if S <> FLastLetterA.Caption then
  begin
    OldText := edLocateAuthor.Text;
    ChangeLetterButton(S);
    edLocateAuthor.Text := OldText;
    edLocateAuthor.Perform(WM_KEYDOWN, VK_RIGHT, 0);
  end;
  if not FDoNotLocate then
    LocateAuthor(edLocateAuthor.Text, tvAuthors);
end;

procedure TfrmMain.edLocateAuthorKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);

begin
  if ActiveView = ByAuthorView then
    if Key = VK_UP then
      tvAuthors.Perform(WM_KEYDOWN, VK_UP, 0);
    if Key = VK_DOWN  then
      tvAuthors.Perform(WM_KEYDOWN, VK_DOWN, 0);

  if ActiveView = BySeriesView then
    if Key = VK_UP then
      tvSeries.Perform(WM_KEYDOWN, VK_UP, 0);
    if Key = VK_DOWN  then
      tvSeries.Perform(WM_KEYDOWN, VK_DOWN, 0);
end;

procedure TfrmMain.edFFullNameButtonClick(Sender: TObject);
begin
  frmEditor.Text := (Sender as TrzButtonEdit).Text;
  frmEditor.ShowModal;
  (Sender as TrzButtonEdit).Text := frmEditor.Text;
end;

procedure TfrmMain.edFFullNameKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if Key = VK_RETURN then
    btnApplyFilterClick(Sender);
end;

procedure TfrmMain.edFGenreButtonClick(Sender: TObject);
var
  Data : PGenreData;
  Node : PVirtualNode;
begin
  FillGenresTree(frmGenreTree.tvGenresTree);
  if frmGenreTree.ShowModal=mrOk then
  begin
    edFGenre.Text := '';
    edFGenre.Hint:= '';
    with frmGenreTree.tvGenresTree do
    begin
      Node := GetFirstSelected;
      while Node <> Nil do
      begin
        Data :=GetNodeData(Node);
        if edFGenre.Text = '' then
        begin
          edFGenre.Text := Data.Text;
          edFGenre.Hint := Format('(g.GL_Code = "%s")',[Data.Code]);
        end
        else begin
          edFGenre.Text := edFGenre.Text + '/' + Data.Text;
          edFGenre.Hint := Format('%s OR (g.GL_Code = "%s")',[edFGenre.Hint, Data.Code]);
        end;
        Node := GetNextSelected(Node,False);
      end;
    end;
  end;
end;

procedure TfrmMain.edFGenreKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = chr(8) then
  begin
    edFGenre.Text := '';
    edFGenre.Hint := '';
  end;
  Key := chr(0);
end;

procedure TfrmMain.edLocateSeriesChange(Sender: TObject);
var
  S : string;
  OldText:string;
begin
  if FIgnoreChange or (Length(edLocateSeries.Text)=0) then Exit;
  S := AnsiUpperCase(copy(edLocateSeries.Text,1,1));
  if S <> FLastLetterS.Caption then
  begin
    OldText := edLocateSeries.Text;
    ChangeLetterButton(S);
    edLocateSeries.Text := OldText;
    edLocateSeries.Perform(WM_KEYDOWN, VK_RIGHT, 0);
  end;
  if not FDoNotLocate then
    LocateAuthor(edLocateSeries.Text, tvSeries);
end;

procedure TfrmMain.FillAuthorTree(Tree: TVirtualStringTree; FullMode: boolean);
var
  Node: PVirtualNode;
  NodeData: PAuthorData;
begin
  Tree.NodeDataSize := Sizeof(TAuthorData);

  Tree.BeginUpdate;
  try
    Tree.Clear;
    dmCollection.tblAuthors.DisableControls;

    if FullMode then dmCollection.tblAuthors.Filtered := False;

    try
      dmCollection.tblAuthors.First;

      if dmCollection.tblAuthorsFamily.IsNull then
        tvBooksA.Clear;

      while not dmCollection.tblAuthors.Eof do
      begin
        Node := Tree.AddChild(nil);
        NodeData := Tree.GetNodeData(Node);
        NodeData.ID := dmCollection.tblAuthorsID.Value;

        if FullMode then
        begin
          NodeData.First := dmCollection.tblAuthorsName.Value;
          NodeData.Last := dmCollection.tblAuthorsFamily.Value;
          NodeData.Middle := dmCollection.tblAuthorsMiddle.Value;
          NodeData.Text := NodeData.Last + ' ' + NodeData.First + ' ' + NodeData.Middle;
        end
        else
          NodeData.Text := trim(dmCollection.tblAuthorsFamily.Value + ' ' +
                                dmCollection.tblAuthorsName.Value +  ' ' +
                                dmCollection.tblAuthorsMiddle.Value);

        dmCollection.tblAuthors.Next;
      end;
    finally
      dmCollection.tblAuthors.EnableControls;
    end;
    ///dmCollection.tblAuthors.First;

    Tree.Selected[Tree.GetFirst] := True;
  finally
    Tree.EndUpdate;
    if FullMode then dmCollection.tblAuthors.Filtered := True;
  end;
end;

procedure TfrmMain.FillSeriesTree;
var
  Node: PVirtualNode;
  NodeData: PAuthorData;
begin
  tvSeries.NodeDataSize := Sizeof(TAuthorData);

  tvSeries.BeginUpdate;
  try
    tvSeries.Clear;

    dmCollection.tblSeries.DisableControls;
    try
      dmCollection.tblSeries.First;

      if dmCollection.tblSeriesTitle.IsNull then
        tvBooksS.Clear;

      while not dmCollection.tblSeries.Eof do
      begin
        Node := tvSeries.AddChild(nil);
        NodeData := tvSeries.GetNodeData(Node);
        NodeData.ID := dmCollection.tblSeriesID.AsInteger;
        NodeData.Text := dmCollection.tblSeriesTitle.AsString;
        dmCollection.tblSeries.Next;
      end;
    finally
      dmCollection.tblSeries.EnableControls;
    end;
    ///dmCollection.tblSeries.First;
  finally
    tvSeries.EndUpdate;
  end;
end;

procedure TfrmMain.FillGenresTree(Tree: TVirtualStringTree);
var
  genreNode: PVirtualNode;
  genreData: PGenreData;
  Nodes: TStringList;
  strParentCode: string;
  nParentIndex: Integer;
  ParentNode: PVirtualNode;
begin
  Nodes := TStringList.Create;
  Nodes.Sorted := True;
  try
    Tree.NodeDataSize := SizeOf(TGenreData);

    Tree.BeginUpdate;
    try
      Tree.Clear;

      dmCollection.tblGenres.First;
      while not dmCollection.tblGenres.Eof do
      begin
        strParentCode := dmCollection.tblGenresG_ParentCode.Value;

        ParentNode := nil;
        if (strParentCode <> '0') and Nodes.Find(strParentCode, nParentIndex) then
          ParentNode := PVirtualNode(Nodes.Objects[nParentIndex]);

        genreNode := Tree.AddChild(ParentNode);

        genreData := Tree.GetNodeData(genreNode);
        genreData.id := dmCollection.tblGenresG_ID.Value;
        genreData.Text := dmCollection.tblGenresG_Alias.Value;
        genreData.Code := dmCollection.tblGenresG_Code.Value;
        genreData.ParentCode := strParentCode;

        Nodes.AddObject(genreData.Code, TObject(genreNode));

        dmCollection.tblGenres.Next;
      end;
    finally
      Tree.EndUpdate;
    end;
  finally
    Nodes.Free;
  end;
end;

procedure TfrmMain.FillGroupsList;
var
  Node : PVirtualNode;
  Data : PGenreData;
begin
  tvGroups.Clear;

  DMUser.tblGroupList.First;
  while not DMUser.tblGroupList.Eof do
  begin
    Node := tvGroups.AddChild(Nil);
    Data := tvGroups.GetNodeData(Node);

    Data.Text := DMUser.tblGroupListName.Value;
    Data.ID := DMUser.tblGroupListID.Value;

    DMUser.tblGroupList.Next;
  end;

  // ���������� ��������� ������ � ������
  tvGroups.Selected[tvGroups.GetLast] := True;
end;

procedure TfrmMain.miAboutClick(Sender: TObject);
var
  frmAbout: TfrmAbout;
begin
  frmAbout := TfrmAbout.Create(Application);
  try
    frmAbout.ShowModal;
  finally
    frmAbout.Free;
  end;
end;

procedure TfrmMain.miActiveCollectionClick(Sender: TObject);
var
  I: integer;
begin
  I := (Sender as TMenuItem).Tag;
  if DMUser.ActivateCollection(I) then
  begin
    (Sender as TMenuItem).Checked := True;
    Settings.ActiveCollection := I;
    InitCollection(True);
  end;
end;

procedure TfrmMain.pmiBookInfoClick(Sender: TObject);
var
  Tree: TVirtualStringTree;
  CR, s: string;
  Data: PBookData;
  Table, Extra: TAbsTable;
  frmBookDetails: TfrmBookDetails;

  Zip: TZipForge;
  FS : TMemoryStream;

  ReviewEditable: boolean;

  NoFb2Info: boolean;
  F: TZFArchiveItem;
begin
//  if not isFb2 then Exit;

  NoFb2Info := False;
  GetActiveTree(Tree);

  if Tree.FocusedNode= nil then
      Exit;

  Table := GetActiveBookTable(Tree.Tag);
  Data := Tree.GetNodeData(Tree.FocusedNode);

  if not Assigned(Data) or (Data.nodeType <> ntBookInfo) or Table.IsEmpty then
    Exit;

  Table.Locate('ID', Data.ID, []);
  FFormBusy := True;

  frmBookDetails := TfrmBookDetails.Create(Application);

  ReviewEditable := true;

  if ActiveView = FavoritesView then
  begin
    Extra := dmUser.tblExtra;
    CR := GetFullBookPath(Table,'');

    ReviewEditable := (Table['DatabaseID'] =  DMUser.ActiveCollection.ID);
    frmBookDetails.mmReview.ReadOnly := not ReviewEditable;

  end
  else  begin
    Extra := dmCollection.tblExtra;
    CR := GetFullBookPath(Table,FCollectionRoot);
  end;



  FS := TMemoryStream.Create;
  try
    if ExtractFileExt(CR) = ZIP_EXTENSION then
    begin
      if not FileExists(CR) then
      if IsLocal then
      begin
         ShowMessage('����� ' + CR + ' �� ������!');
         Exit;
       end
       else
         NoFb2Info := True;

      if not NoFb2Info then
      begin
        Zip := TZipForge.Create(Self);
        try
          Zip.FileName := CR;
          Zip.OpenArchive;
          Zip.ExtractToStream(GetFileNameZip(Zip,Table['InsideNo']),FS);
          Zip.CloseArchive;
        finally
          Zip.Free;
        end;
      end;
    end
    else  // ���� �� ������ ����
      if ExtractFileExt(Table['FileName']) = ZIP_EXTENSION then  // fbd
      begin
        if not NoFb2Info then
        begin
          Zip := TZipForge.Create(Self);
          try
            Zip.FileName := CR + Table['FileName'];
            Zip.OpenArchive;
            zip.FindFirst('*.fbd',F);
            Zip.ExtractToStream(F.FileName,FS);
            Zip.CloseArchive;
          finally
            Zip.Free;
          end;
        end;
      end
      else
        if not NoFb2Info then  // ������ ����
            FS.LoadFromFile(CR + Table['FileName'] + Table['Ext']);

      if not NoFb2Info then
      begin
        frmBookDetails.TabSheet1.TabVisible := True;
        frmBookDetails.RzPageControl1.ActivePageIndex := 0;
      end
      else
      begin
        frmBookDetails.TabSheet1.TabVisible := False;
        frmBookDetails.RzPageControl1.ActivePageIndex := 1;
      end;


      try
        frmBookDetails.ShowBookInfo(FS);
        frmBookDetails.mmInfo.Lines.Add('���������: ' + Table.FieldByName('Date').AsString);

        if not isPrivate and ReviewEditable  then
            frmBookDetails.AllowOnlineReview(Table['LibID']);

        if Table['Code'] = 1 then
          frmBookDetails.Review := Extra.FieldByName('Review').AsWideString
        else
          if not isPrivate and Settings.AutoLoadReview then
            DownloadReview(frmBookDetails);

        frmBookDetails.ShowModal;
        // ������������ ��������

        if frmBookDetails.ReviewChanged then
        begin
          case Table['Code'] of     // ������� - �������� �������
            0:  if (frmBookDetails.Review <> '') then
                begin
                  Table.Edit;
                  Table['Code'] := Table['Code'] or 1;
                  Table.Post;

                  Extra.Insert;
                  Extra.FieldByName('Review').AsWideString := frmBookDetails.Review;
                  Extra.Post;

                  Data.Code := 1;
                  Tree.RepaintNode(Tree.FocusedNode);
                end;
            1: if frmBookDetails.Review <> '' then
               begin
                  Extra.Edit;
                  Extra.FieldByName('Review').AsWideString := frmBookDetails.Review;
                  Extra.Post;
                end
                else
                begin // �������� ����, � ������ �� ���
                  Table.Edit;
                  Table['Code'] := 0;
                  Table.Post;
                  Extra.Delete;
                end;
          end; // case

          // ����� �������������

          if ActiveView <> FavoritesView then
          begin
            if DMUser.tblGrouppedBooks.Locate('DataBaseID;OuterID;',
                            VarArrayOf([DMUser.ActiveCollection.ID,Data.ID]),[])
            then       // ���� ����� ���� � ��������� - ��������������
            begin
              DMUser.tblGrouppedBooks.Edit;
              DMUser.tblGrouppedBooksCode.Value := Table['Code'];
              DMUser.tblGrouppedBooks.Post;

              if dmUser.tblExtra.Locate('ID',DMUser.tblGrouppedBooksID.Value,[]) then
              case Table['Code'] of
                0: if DMUser.tblExtra.RecordCount <> 0 then
                      DMUser.tblExtra.Delete;
                1: begin
                   dmUser.tblExtra.Edit;
                   dmUser.tblExtraReview.Value := frmBookDetails.Review;
                   dmUser.tblExtra.Post;
                 end;
              end
              else
                if Table['Code'] = 1 then
                begin
                  dmUser.tblExtra.Insert;
                  dmUser.tblExtraReview.Value := frmBookDetails.Review;
                  dmUser.tblExtra.Post;
                end;
              FillBooksTree(0,tvBooksF,Nil,DMUser.tblGrouppedBooks,true, true);
            end
          end
          else   // ���� �������� ������� - ������, ������ ��������� � ���������
          begin
            DMCollection.tblBooks.Locate('Id', Table['OuterID'], []);
            DMCollection.tblBooks.Edit;
            DMCollection.tblBooksCode.Value := Table['Code'];
            DMCollection.tblBooks.Post;

            if DMCollection.tblExtraReview <> Nil then
            case Table['Code'] of
              0: if DMCollection.tblExtra.RecordCount <> 0 then
                        DMCollection.tblExtra.Delete;
              1: begin
                   DMCollection.tblExtra.Edit;
                   DMCollection.tblExtraReview.Value := frmBookDetails.Review;
                   DMCollection.tblExtra.Post;
               end;
            end
            else
              if Table['Code'] = 1 then
              begin
                DMCollection.tblExtra.Insert;
                DMCollection.tblExtraReview.Value := frmBookDetails.Review;
                DMCollection.tblExtra.Post;
              end;
            FillAllBooksTree;
          end;


          Data.Code := Table['Code'];
          Tree.RepaintNode(Tree.FocusedNode);
        end;
      finally
        FreeAndNil(frmBookDetails);
      end;
  finally
    FS.Free;
    FFormBusy := False;
  end;
end;

procedure TfrmMain.miClearRateClick(Sender: TObject);
var
  Tree: TVirtualstringTree;
  Data: PbookData;
  Node: PVirtualNode;
begin
  GetactiveTree(Tree);
  Node := Tree.FocusedNode;
  Data := Tree.GetNodeData(Node);
  if not Assigned(Data) or (Data.nodeType <> ntBookInfo) then
    Exit;
  Data.Rate := 0;
  BookTreeStatus := bsBusy;
  if GetActiveView <> FavoritesView then
  begin

    DMUser.DeleteRate(Data.ID);

    if DMUser.tblGrouppedBooks.Locate('DataBaseID;OuterID',
                                  VarArrayOf([DMUser.ActiveCollection.ID,Data.ID]),[]) then
    begin
      DMUser.tblGrouppedBooks.Edit;
      DMUser.tblGrouppedBooksRate.Value := 0;
      DMUser.tblGrouppedBooks.Post;

      FillBooksTree(0, tvBooksF, nil, DMUser.tblGrouppedBooks, True, True); // ���������
    end;
  end
  else if DMUser.tblGrouppedBooks.Locate('ID',Data.ID,[]) then
    begin
      DMUser.tblGrouppedBooks.Edit;
      DMUser.tblGrouppedBooksRate.Value := 0;
      DMUser.tblGrouppedBooks.Post;

      DMUser.DeleteRate(DMUser.tblGrouppedBooksOuterID.Value, DMUser.tblGrouppedBooksDatabaseID.Value);

      FillBooksTree(0, tvBooksA, dmCollection.tblAuthor_List, dmCollection.tblBooksA, False, True); // ������
      FillBooksTree(0, tvBooksS, nil, dmCollection.tblBooksS, False, False); // �����
    end;

  Tree.RepaintNode(Node);
  BookTreeStatus := bsFree;
end;

procedure TfrmMain.miQuitAppClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.pmiCheckAllClick(Sender: TObject);
begin
  Selection(True);
end;

procedure TfrmMain.pmAuthorPopup(Sender: TObject);
begin
  miAddToSearch.Visible := (ActiveView <>  ByGenreView);
end;

procedure TfrmMain.pmiDeselectAllClick(Sender: TObject);
begin
  Selection(False);
end;

procedure TfrmMain.pmiSelectAllClick(Sender: TObject);
var
  tree: TVirtualStringTree;
begin
  GetActiveTree(Tree);
  Tree.SelectAll(False);
end;

procedure TfrmMain.miGoForumClick(Sender: TObject);
begin
  ShellExecute(handle, 'open', '"http://myhomelib.org/"', nil, nil, SW_SHOW);
end;

procedure TfrmMain.miGoSiteClick(Sender: TObject);
begin
  ShellExecute(handle, 'open', 'http://home-lib.net/', nil, nil, SW_SHOW);
end;

procedure TfrmMain.miGoToAuthorClick(Sender: TObject);
var
  I: integer;
  Data: PBookData;
  Node: PvirtualNode;
  Tree: TVirtualstringTree;
  FN: string;
begin
  GetActiveTree(Tree);

  Node := Tree.FocusedNode;
  Assert(Assigned(Node));

  Data := Tree.GetNodeData(Node);

  if not Assigned(Data) then Exit;

  if (Data.nodeType <> ntBookInfo) then
  begin
    if not Tree.HasChildren[Node] then Exit;
    repeat
      Node := Tree.GetFirstChild(Node);
      Data := Tree.GetNodeData(Node);
    until (Data.nodeType = ntBookInfo);
  end;

  Screen.Cursor := crHourGlass;
  try
    if ActiveView = FavoritesView then
    begin
      I := DMUser.tblGrouppedBooksDatabaseID.Value;
      if I <> Settings.ActiveCollection then
      begin
        if DMUser.ActivateCollection(I) then
        begin
          Settings.ActiveCollection := I;
          InitCollection(True);
          CreateCollectionMenu;
        end
        else
        begin
          Screen.Cursor := crDefault;
          ShowMessage('��������� �� ���������������� !');
          Exit;
        end;
      end;
      DMUser.tblGrouppedBooks.Locate('ID', Data.ID, []);
      FN := DMUser.tblGrouppedBooksFullName.Value;
    end
    else
      FN := dmCollection.FullName(Data.ID);
    pgControl.ActivePageIndex := 0;
    edLocateAuthor.Text := FN;
    LocateBook(Data.Title, False);
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TfrmMain.miCheckUpdatesClick(Sender: TObject);
var
  SL: TStringList;
  LF: TMemoryStream;
  i: integer;
  S: string;
  HTTP: TidHTTP;
begin
  LF := TMemoryStream.Create;
  try
    SL := TStringList.Create;
    try
      HTTP := TidHTTP.Create;
      SetProxySettings(HTTP);
      try
        Http.Get(InclideUrlSlash(Settings.UpdateURL)+PROGRAM_VERINFO_FILENAME, LF);
      except
          on E: EIdSocketError do
            if E.LastError = 11001 then
              ShowMessage('�������� ���������� �� �������! ������ �� ������.'+
                           #13+'��� ������: '+IntToStr(E.LastError))
            else
              ShowMessage('�������� ���������� �� �������! ������ �����������.'+
                           #13+'��� ������: '+IntToStr(E.LastError));
           on E: Exception do
             ShowMessage('�������� ���������� �� �������! ������ �������� �� ������ '+
                          #13+'��� ������: '+IntToStr(HTTP.ResponseCode));
      end;
      { TODO -oNickR -cRefactoring : ��������� ������������� ����� last_version.info. �������� �� ������ ����� �� ����� � ����� �� ��������� ��� �� ���� }
      LF.SaveToFile(Settings.SystemFileName[sfAppVerInfo]);
      SL.LoadFromFile(Settings.SystemFileName[sfAppVerInfo]);
      if SL.Count > 0 then
        if CompareStr(VersionInfo.FileVersion, SL[0]) < 0 then
        begin
          S := #13;
          for I := 1 to SL.Count - 1 do
            S := S + '  ' + SL[i] + #13;

          ShowMessage('�������� ����� ������ - ' + SL[0] + #13 + S + #13 +
            '�������� ���� ��������� ��� �������� ����������.');
        end
        else if not FAutoCheck then
          ShowMessage('� ��� ����� ������ ������.');
      FAutoCheck := False;
    finally
      HTTP.Free;
      SL.Free;
    end;
  finally
    LF.Free;
  end;
end;

procedure TfrmMain.miStatClick(Sender: TObject);
var
  frmStat: TfrmStat;
begin
  DMUser.ActivateCollection(Settings.ActiveCollection);

  frmStat := TfrmStat.Create(Application);
  try
    frmStat.ShowInfo;
    frmStat.ShowModal;
  finally
    frmStat.Free;
  end;
end;

procedure TfrmMain.miSyncOnlineClick(Sender: TObject);
begin
  SavePositions;

  if isOnlineCollection(DMUser.ActiveCollection.CollectionType) then
      unit_Utils.SyncOnLineFiles
    else
      unit_Utils.SyncFolders;
  InitCollection(True);

  RestorePositions;
end;

procedure TfrmMain.miUpdateClick(Sender: TObject);
var
  ActiveColIndex:  integer;
begin
  if CheckLibUpdates(False) then
  begin
    SavePositions;

    ActiveColIndex := DMUser.ActiveCollection.ID;
    StartLibUpdate;
    Settings.ActiveCollection := ActiveColIndex;
    DMUser.ActivateCollection(ActiveColIndex);
    InitCollection(True);

    RestorePositions;
  end;
end;

procedure TfrmMain.mi_dwnl_LocateAuthorClick(Sender: TObject);
var
  Data: PDownloadData;
begin
  Data := tvDownloadList.GetNodeData(tvDownloadList.FocusedNode);
  if Data <> nil then
  begin
    pgControl.ActivePageIndex := 0;
    edLocateAuthor.Text := Data.Author;
    LocateBook(Data.Title, False);
  end;
end;

procedure TfrmMain.N27Click(Sender: TObject);
begin
  DeleteFile(Settings.WorkPath + 'columns.ini');
  SetColumns;
  SetHeaderPopUp;
end;

procedure TfrmMain.miCompactDataBaseClick(Sender: TObject);
begin
  try
    dmCollection.DBCollection.Close;
    dmCollection.DBCollection.CompactDatabase;
  except

  end;
  dmCollection.DBCollection.Open;
  dmUser.SetTableState(True);
  dmCollection.SetTableState(True);
end;

procedure TfrmMain.miConverToFBDClick(Sender: TObject);
begin
  if (ActiveView = FavoritesView) or (ActiveView = DownloadView) then
  begin
    MessageDlg('��� ����������� ����� ��������� ' + #13 + '� ��������������� ���������', mtWarning, [mbOk], 0);
    Exit;
  end;

  frmConvertToFBD.EditorMode := miConverToFBD.Tag <> 0;
  frmConvertToFBD.ShowModal;
end;

procedure TfrmMain.N33Click(Sender: TObject);
begin
  Close;
end;

procedure TfrmMain.N34Click(Sender: TObject);
begin
  if DirectoryExists(Settings.ReadDir) then ClearDir(Settings.ReadDir);
end;

procedure TfrmMain.miEditToolbarVisibleClick(Sender: TObject);
begin
  tlbrEdit.Visible := miEditToolbarVisible.Checked;
  Settings.EditToolbarVisible := tlbrEdit.Visible;
end;

procedure TfrmMain.miExportUserDataClick(Sender: TObject);
var
  SL: TStringList;
  FN: string;

  S: String;

begin
  SL := TStringList.Create;
  try

    // ������
    SL.Add('# ������');
    DMUser.tblGroupList.First;
    while not DMUser.tblGroupList.Eof do
    begin
      SL.Add(Format('%s',[DMUser.tblGroupListName.Value]));
      DMUser.tblGroupList.Next;
    end;

    //  ��������

    SL.Add('# ��������');
    DMUser.tblRates.Filter := 'DataBaseID =' + QuotedStr(IntToStr(DMUser.ActiveCollection.ID));
    DMUser.tblRates.Filtered := True;
    DMUser.tblRates.First;
    while not DMUser.tblRates.Eof do
    begin
      SL.Add(Format('%d %d',[DMUser.tblRatesBookID.Value, DMUser.tblRatesRate.Value]));
      DMUser.tblRates.Next;
    end;
    DMUser.tblRates.Filtered := False;

    //  �����������

    SL.Add('# �����������');
    DMUser.tblFinished.Filter := 'DataBaseID =' + QuotedStr(IntToStr(DMUser.ActiveCollection.ID));
    DMUser.tblFinished.Filtered := True;
    DMUser.tblFinished.First;
    while not DMUser.tblFinished.Eof do
    begin
      SL.Add(Format('%d %d',[DMUser.tblFinishedBookID.Value, DMUser.tblFinishedProgress.Value]));
      DMUser.tblFinished.Next;
    end;
    DMUser.tblFinished.Filtered := False;


    //  ���������

    SL.Add('# ���������');

    DMUser.tblGroupList.First;
    while not DMUser.tblGroupList.Eof do
    begin
      DMUser.tblGrouppedBooks.Filter := 'DataBaseID =' + QuotedStr(IntToStr(DMUser.ActiveCollection.ID));
      DMUser.tblGrouppedBooks.Filtered := True;
      DMUser.tblGrouppedBooks.First;
      while not DMUser.tblGrouppedBooks.Eof do
      begin
        SL.Add(Format('%d %d',[DMUser.tblGrouppedBooksOuterID.Value, DMUser.tblGroupList.RecNo]));
        DMUser.tblGrouppedBooks.Next;
      end;
      DMUser.tblGroupList.Next;
    end;

    DMUser.tblGrouppedBooks.MasterSource := DMUser.dsGroupList;

    //  ���������

    SL.Add('# ��������');

    DMCollection.tblExtra.MasterSource := nil;
    DMCollection.tblExtra.First;
    while not DMCollection.tblExtra.Eof do
    begin
      S := DMCollection.tblExtraReview.Value;
      StrReplace(#13#10,'~',S);
      SL.Add(Format('%d %s',[DMCollection.tblExtraID.Value, S]));
      DMCollection.tblExtra.Next;
    end;
    DMCollection.tblExtra.MasterSource := DMCollection.dsBooks;

    if GetFileName(fnSaveUserData,FN) = true then   //�����
          SL.SaveToFile(FN, TEncoding.UTF8);

  finally
    SL.Free;
  end;
end;

procedure TfrmMain.HeaderPopupItemClick(Sender: TObject);
var
  i: integer;
  Tree : TVirtualstringTree;
  Tag: integer;
  Column: TVirtualTreeColumn;

  S: string;
  MinWidth, MaxWidth : integer;
  Options: TVTColumnOptions;
  Alignment: TAlignment;

begin
  GetActiveTree(Tree);

  Tag := (Sender as TMenuItem).Tag;

  if (Sender as TMenuItem).Checked then
  begin           // �������
    for I := 0 to Tree.Header.Columns.Count - 1 do
      if Tree.Header.Columns[i].Tag = Tag then
      begin
        Tree.Header.Columns.Delete(i);
        (Sender as TMenuItem).Checked := False;
        Break;
      end;
  end
  else
  begin           // ���������
    Column := TVirtualTreeColumn.Create(Tree.Header.Columns);

    GetDefaultColumnProperties(Settings.TreeModes[Tree.Tag],Tag,
                         S,
                         MinWidth,
                         MaxWidth,
                         Alignment,
                         Options
                         );
    Column.Tag := Tag;
    Column.Text := S;
    Column.MinWidth := MinWidth;
    Column.MaxWidth := MaxWidth;
    Column.Alignment:= Alignment;
    Column.Options  := Options;
    (Sender as TMenuItem).Checked := True;
  end;
  SaveColumns;
end;

function TfrmMain.HH(Command: Word; Data: Integer;
  var CallHelp: Boolean): Boolean;
begin
  if Data = 0 then
      HtmlHelp(Application.Handle,
        PChar(Settings.SystemFileName[sfAppHelp]),
        HH_DISPLAY_TOC, 0)
  else
      HtmlHelp(Application.Handle,
        PChar(Settings.SystemFileName[sfAppHelp]),
        HH_HELP_CONTEXT, Data);

  CallHelp := False;
end;

procedure TfrmMain.miCollectionExportClick(Sender: TObject);
begin
  if MessageDlg('������� � xml �������� � ������ ������������� �� ������� ��������.'+#10#13 +
                '�� ��� ������ ����� ���������. ������������� ������������ ������� � inpx.'+#10#13 +
                '����������?'
                ,mtWarning,[mbYes,mbNo],0)=mrNo then Exit;

  DMUser.ActivateCollection(Settings.ActiveCollection);
  unit_Export.Export2XML;
end;

procedure TfrmMain.miCollectionImportClick(Sender: TObject);
begin
  DMUser.ActivateCollection(Settings.ActiveCollection);
  dmCollection.DBCollection.Connected := False;

  unit_Import.ImportXML(DMUser.ActiveCollection);

  InitCollection(True);
end;

procedure TfrmMain.miCollsettingsClick(Sender: TObject);
var
  frmBases: TfrmBases;
begin
  DMUser.ActivateCollection(Settings.ActiveCollection);

  frmBases := TfrmBases.Create(Application);
  try
    if frmBases.ShowModal = mrOk then
    begin
      Assert(Settings.ActiveCollection = DMUser.ActiveCollection.ID);
      CreateCollectionMenu;
      InitCollection(True);
    end;
  finally
    frmBases.Free;
  end;
end;

procedure TfrmMain.miReadedClick(Sender: TObject);
var
  Tree: TVirtualStringTree;
  Data: PBookData;
  Node: PVirtualNode;
begin
  GetActiveTree(Tree);
  Node := Tree.GetFirstSelected;
  while Node <> nil do
  begin
    Data := Tree.GetNodeData(Node);
    if not Assigned(Data) or (Data.nodeType <> ntBookInfo) then
    begin
      Node := Tree.GetNextSelected(Node);
      Continue;
    end;

    //  ��������
    if Data.Progress = 100 then
        Data.Progress := 0
    else
        Data.Progress := 100;

    BookTreeStatus := bsBusy;
    if GetActiveView <> FavoritesView then
    begin

      if Data.Progress <> 0 then
          DMUser.SetFinished(Data.ID, Data.Progress)
        else
          DMUser.DeleteFinished(Data.ID);
      //
      //  ������������� � ���������
      //
      if (DMUser.tblGrouppedBooks.Locate('DataBaseID;OuterID;',
                                  VarArrayOf([DMUser.ActiveCollection.ID,Data.ID]),[]))
      then
      begin
        DMUser.tblGrouppedBooks.Edit;
        DMUser.tblGrouppedBooksProgress.Value := Data.Progress;
        DMUser.tblGrouppedBooks.Post;
        FillBooksTree(0, tvBooksF, nil, DMUser.tblGrouppedBooks, True, True); // ���������
      end;
    end
    else // �������� ������� - ���������
    begin
      DMUser.tblGrouppedBooks.Locate('DataBaseID;OuterID;',
                                    VarArrayOf([DMUser.ActiveCollection.ID,Data.ID]),[]);
      DMUser.tblGrouppedBooks.Edit;
      DMUser.tblGrouppedBooksProgress.Value := Data.Progress;
      DMUser.tblGrouppedBooks.Post;

      //
      //  ������������� � �������� ���������
      //

      if Data.Progress <> 0 then
          DMUser.SetFinished(DMUser.tblGrouppedBooksOuterID.Value, Data.Progress, DMUser.tblGrouppedBooksDatabaseID.Value)
        else
          DMUser.DeleteFinished(DMUser.tblGrouppedBooksOuterID.Value, DMUser.tblGrouppedBooksDatabaseID.Value);

      FillBooksTree(0, tvBooksA, dmCollection.tblAuthor_List, dmCollection.tblBooksA, False, True); // ������
      FillBooksTree(0, tvBooksS, nil, dmCollection.tblBooksS, False, False); // �����
    end;
    Tree.RepaintNode(Node);

    Node := Tree.GetNextSelected(Node);
  end;

  BookTreeStatus := bsFree;
end;

procedure TfrmMain.miRefreshClick(Sender: TObject);
begin
  InitCollection(True);
end;

procedure TfrmMain.miRefreshGenresClick(Sender: TObject);
var
  ALibrary: TMHLLibrary;
  AFileName: string;
begin
  dmCollection.DBCollection.Connected := False;
  ALibrary := TMHLLibrary.Create(nil);
  try
    ALibrary.DatabaseFileName := DMUser.ActiveCollection.DBFileName;
    ALibrary.Active := True;

    if isFB2Collection(DMUser.ActiveCollection.CollectionType) then
      ALibrary.ReloadDefaultGenres(Settings.SystemFileName[sfGenresFB2])
    else if unit_Helpers.GetFileName(fnGenreList, AFileName) then
      ALibrary.ReloadDefaultGenres(AFileName);
  finally
    ALibrary.Free;
  end;
  InitCollection(True);
end;

procedure TfrmMain.miRepairDataBaseClick(Sender: TObject);
begin
  dmCollection.DBCollection.Close;
  dmCollection.DBCollection.RepairDatabase;
  dmCollection.DBCollection.Open;

  dmUser.SetTableState(True);
  dmCollection.SetTableState(True);
end;

procedure TfrmMain.miSettingsClick(Sender: TObject);
var
  frmSettings: TfrmSettings;
begin
  SaveMainFormSettings;

  frmSettings := TfrmSettings.Create(Application);
  try
    frmSettings.LoadSetting;
    frmSettings.ShowModal;

    Settings.SaveSettings;
    FreeSettings;
  finally
    frmSettings.Free;
  end;
  ReadINIData;
end;

procedure TfrmMain.SetHeaderPopUp;
var
  Tree: TVirtualStringTree;
  i: integer;
begin
  if ActiveView = DownloadView then Exit;

  GetActiveTree(Tree);

  for I := 0 to pmHeaders.Items.Count - 1 do
  begin
    pmHeaders.Items[i].Checked := False;
    pmHeaders.Items[i].Tag := ColumnTags[i];
  end;

  for I := 0 to Tree.Header.Columns.Count - 1 do
  begin
    case Tree.Header.Columns[i].Tag of
      COL_AUTHOR:      pmHeaders.Items[0].Checked := True;
      COL_TITLE:       pmHeaders.Items[1].Checked := True;
      COL_SERIES:      pmHeaders.Items[2].Checked := True;
      COL_NO:          pmHeaders.Items[3].Checked := True;
      COL_GENRE:       pmHeaders.Items[4].Checked := True;
      COL_SIZE :       pmHeaders.Items[5].Checked := True;
      COL_RATE :       pmHeaders.Items[6].Checked := True;
      COL_DATE :       pmHeaders.Items[7].Checked := True;
      COL_TYPE :       pmHeaders.Items[8].Checked := True;
      COL_COLLECTION:  pmHeaders.Items[9].Checked := True;
      COL_LANG :       pmHeaders.Items[10].Checked := True;
      COL_LIBRATE:     pmHeaders.Items[11].Checked := True;
    end;
  end;
  pmHeaders.Items[9].Visible := (Tree.Tag = PAGE_FAVORITES);
end;

procedure TfrmMain.pgControlChange(Sender: TObject);
var
  ToolBuutonVisible: boolean;
begin
  // ���������� �������� �������� ������
  FLastFoundBook := Nil;
  FFirstFoundBook := Nil;

 // tbtnDownloadList_Add.Enabled := (ActiveView <> FavoritesView);
  ToolBuutonVisible := (ActiveView <> DownloadView);

  btnFav_add.Enabled := ToolBuutonVisible;
  tbSelectAll.Enabled := ToolBuutonVisible;
  tbCollapse.Enabled := ToolBuutonVisible;
  tbtnShowCover.Enabled := ToolBuutonVisible;
  tbtnRead.Enabled := ToolBuutonVisible;
  tbtnRus.Enabled := ToolBuutonVisible;
  tbtnEng.Enabled := ToolBuutonVisible;
  btnRefreshCollection.Enabled := ToolBuutonVisible;
  tbtnShowDeleted.Enabled := ToolBuutonVisible;
  tbtnShowLocalOnly.Enabled := ToolBuutonVisible;

  tbSendToDevice.Enabled := ToolBuutonVisible;
  btnSwitchTreeMode.Enabled :=  not ((ActiveView = BySeriesView) or
                                     (ActiveView = DownloadView));

  case ActiveView  of
    ByAuthorView:begin
                   FLastLetterA.Down := True;
                   if FLastLetterA = FLastLetterS then
                     FLastLetterS.Down := True
                   else
                     FLastLetterS.Down := False;
                 end;
    BySeriesView :begin
                   FLastLetterS.Down := True;
                   if FLastLetterA = FLastLetterS then
                     FLastLetterA.Down := True
                   else
                     FLastLetterA.Down := False;
                 end;
    else begin
                   FLastLetterA.Down := False;
                   FLastLetterS.Down := False;
                 end;
  end;




  case ActiveView of
    FavoritesView:begin
                    miGotoAuthor.Visible := True;
                    miDelFavorites.Visible := True;
                    miAddFavorites.Visible := False;
                    btnFav_add.Hint := '������� �� ������';
                    btnFav_add.DropdownMenu := Nil;
                    btnFav_add.ImageIndex := 16;
                    pmiGroups.Visible := False;
                    miDeleteFiles.Visible := False;
                  end;
    DownloadView: begin
                    tbtnDownloadList_Add.ImageIndex := 23;
                    tbtnDownloadList_Add.Hint := '������� �� ������'+#13+'�������';
                    btnSwitchTreeMode.Enabled := False;
                    Exit;
                  end;
    else
                 begin
                    miGotoAuthor.Visible := False;
                    miDelFavorites.Visible := False;
                    miAddFavorites.Visible := True;
                    btnFav_add.Hint := '�������� � ���������';
                    btnFav_add.DropdownMenu := pmGroups;
                    btnFav_add.ImageIndex := 15;
                    pmiGroups.Visible := True;
                    miDeleteFiles.Visible := isOnlineCollection(dmUser.ActiveCollection.CollectionType);
                  end;

  end;

  tbtnDownloadList_Add.ImageIndex := 2;
  tbtnDownloadList_Add.Hint := '�������� � ������'+#13+'�������';

  dmCollection.SetActiveTable(ord(ActiveView));


  miGotoAuthor.Visible := (ActiveView <> ByAuthorView);

  SetHeaderPopUp;

  tvBooksTreeChange(Nil,Nil);

  btnSwitchTreeMode.ImageIndex := TreeIcons[ord(Settings.TreeModes[pgControl.ActivePageIndex])];
  btnSwitchTreeMode.Hint := TreeHints[ord(Settings.TreeModes[pgControl.ActivePageIndex])];

  Settings.ActivePage := pgControl.ActivePageIndex;
end;

procedure TfrmMain.miShowHelpClick(Sender: TObject);
var
  dummy : boolean;
begin
  HH(0,0, dummy);
end;

procedure TfrmMain.miPdfdjvuClick(Sender: TObject);
begin
  DMUser.ActivateCollection(Settings.ActiveCollection);
  frmAddNonFb2.ShowModal;
  InitCollection(True);
end;

procedure TfrmMain.OnBookDownloadComplete(var Message: TDownloadCompleteMessage);
var
  Tree: TVirtualStringTree;
  Node: PVirtualNode;
  Data: PBookData;
  i: TView;
begin
  if Message.Downloaded then
  begin
    for i := ByAuthorView to FavoritesView do
    begin
      Tree := GetViewTree(i);
      Assert(Assigned(Tree));

      Node := GetBookNode(Tree, Message.BookID);
      if Assigned(Node) then
      begin
        Data := Tree.GetNodeData(Node);
        Assert(Assigned(Data));
        if Assigned(Data) then
        begin
          Data^.Locale := True;
          Tree.RepaintNode(Node);
        end;
      end;
    end;
  end;
end;

function TfrmMain.GetBookNode(const Tree: TVirtualStringTree; bookID: Integer): PVirtualNode;
var
  Data: PBookData;
  Node: PVirtualNode;
begin
  Assert(Assigned(Tree));

  Result := nil;

  Node := Tree.GetFirst;
  while Assigned(Node) do
  begin
    Data := Tree.GetNodeData(Node);
    Assert(Assigned(Data));
    if (Data.nodeType = ntBookInfo) and (Data.ID = bookID) then
    begin
      Result := Node;
      Exit;
    end;
    Node := Tree.GetNext(Node);
  end;
end;

procedure TfrmMain.miImportUserDataClick(Sender: TObject);
var
  SL: TStringList;
  FN: string;
   I: integer;
   p: integer;


begin
  if not GetFileName(fnOpenUserData, FN) then Exit;

  try
    SL := TStringList.Create;
    SL.LoadFromFile(FN);
    i:= 0;
    while (i < SL.Count) do
    begin
      if pos('#',SL[i]) <> 0 then
      begin
        if SL[i] = '# ������' then DMUser.LoadGroups(SL,i)
        else
          if SL[i] = '# ��������' then DMUser.LoadRates(SL,i)
          else
            if SL[i] = '# �����������' then DMUser.LoadFinished(SL,i)
            else
              if SL[i] = '# ��������' then DMUser.LoadReviews(SL,i)
              else
                if SL[i] = '# ���������' then DMUser.LoadGroupedBooks(SL,i)
                else
                  inc(i);
      end;
    end;
    FillGroupsList;
  finally
    SL.Free;
  end;
end;

procedure TfrmMain.miINPXCollectionExportClick(Sender: TObject);
begin
  DMUser.ActivateCollection(Settings.ActiveCollection);
  unit_Export.Export2INPX;
  InitCollection(True);
end;

procedure TfrmMain.btnAddGroupClick(Sender: TObject);
var
  Name : string;
begin
  Name := InputBox('���������� ������','�������� ������','');
  if Name <> '' then
  begin
    DMUser.AddGroup(Name);

    FillGroupsList;
    CreateGroupsMenu;
    FillBooksTree(0,tvBooksF,Nil,DMUser.tblGrouppedBooks,true, true);
  end;
end;

procedure TfrmMain.btnDeleteGroupClick(Sender: TObject);
var
  Data: PGroupData;
begin
  Data := tvGroups.GetNodeData(tvGroups.FocusedNode);
  if Data = Nil then Exit;
  if DMUser.ActivateGroup(Data.ID) and
     DMUser.tblGroupListAllowDelete.Value then
  begin
    btnClearFavoritesClick(Sender);
    DMUser.tblGroupList.Delete;

    FillGroupsList;
    CreateGroupsMenu;
    FillBooksTree(0,tvBooksF,Nil,DMUser.tblGrouppedBooks,true, true);
  end
  else
    ShowMessage('������ ������� ���������� ������!');
end;

procedure TfrmMain.cbPresetNameChange(Sender: TObject);
begin
  btnSavePreset.Enabled  := ( cbPresetName.Text <> '' );
end;

procedure TfrmMain.cbPresetNameSelect(Sender: TObject);
begin
  btnDeletePreset.Enabled := cbPresetName.ItemIndex >= 0;
  btnSavePreset.Enabled := True;
  LoadSearchPreset(cbPresetName.Text);
end;

procedure TfrmMain.btnStartDownloadClick(Sender: TObject);
begin
  if tvDownloadList.GetFirst = nil then Exit;

  btnPauseDownload.Enabled := True;
  btnStartDownload.Enabled := False;

  FDMThread := TDownloadManagerThread.Create(False);
end;

procedure TfrmMain.btnPauseDownloadClick(Sender: TObject);
begin
  btnPauseDownload.Enabled := False;
  btnStartDownload.Enabled := True;
  if Assigned(FDMThread) then FDMThread.Stop;
end;

procedure TfrmMain.BtnSaveClick(Sender: TObject);
begin
  tvDownloadList.SaveToFile(Settings.WorkPath + 'downloads.sav');
end;

procedure TfrmMain.btnDeleteDownloadClick(Sender: TObject);
var
  Data: PDownloadData;
  i: integer;
  List: TSelectionList;
begin
  GetSeelections(tvDownloadList,List);
  for I := 0 to tvDownloadList.SelectedCount - 1 do
  begin
    Data := tvDownloadList.GetNodeData(List[i]);
    if Data.State <> dsRun then
      tvDownloadList.DeleteNode(List[i],True);
  end;
end;

procedure TfrmMain.btnDeletePresetClick(Sender: TObject);
begin
  with cbPresetName do
  begin
    if Text = Items[ItemIndex] then
    begin
      DeleteFile(Settings.PresetPath + Text + '.mhlf');
      Delete(ItemIndex);
      Text := '';
    end;
  end;
  btnDeletePreset.Enabled := cbPresetName.ItemIndex >= 0;
  btnSavePreset.Enabled := cbPresetName.ItemIndex >= 0;
end;

procedure TfrmMain.BtnFav_addClick(Sender: TObject);
begin
 if ActiveView = FavoritesView then
    miDelFavoritesClick(Sender)
  else
    begin
      if DMUser.ActivateGroup(1) then
          miAddFavoritesClick(Sender);
    end;
end;



end.

