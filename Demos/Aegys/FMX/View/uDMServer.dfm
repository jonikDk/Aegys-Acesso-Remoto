object DMServer: TDMServer
  OldCreateOrder = False
  OnCreate = DataModuleCreate
  OnDestroy = DataModuleDestroy
  Height = 150
  Width = 215
  object tLatencia: TTimer
    Enabled = False
    Interval = 5000
    OnTimer = tLatenciaTimer
    Left = 80
    Top = 62
  end
end