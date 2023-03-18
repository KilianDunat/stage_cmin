Select cd.ComputerModel as Modèle, cd.BiosVersion, c.FullDomainName as Nom, c.LastReportedStatusTime
From tbComputerTargetDetail as cd
Inner Join tbComputerTarget as c
on cd.TargetID = c.TargetID
order By cd.ComputerModel, cd.BiosVersion