/* Requête SQL pour récupérer les clé et mot de passe BitLocker */

Select cd.ComputerModel as Mod�le, cd.BiosVersion, c.FullDomainName as Nom, c.LastReportedStatusTime
From tbComputerTargetDetail as cd
Inner Join tbComputerTarget as c
on cd.TargetID = c.TargetID
order By cd.ComputerModel, cd.BiosVersion