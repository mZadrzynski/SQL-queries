INSERT INTO CompSpare(CompSpareID,COMPTYPEID,PartTypeID,ItemStatus,DeptID,ExportMarker,UpdateSite)  
VALUES (999000047720,999000002685,999000049484,2,90001,1,900);

INSERT INTO CompSpare(CompSpareID,COMPTYPEID,PartTypeID,ItemStatus,DeptID,ExportMarker,UpdateSite)  
VALUES (999000047721,999000002686,999000023638,2,90001,1,900);

INSERT INTO CompSpare(CompSpareID,COMPTYPEID,PartTypeID,ItemStatus,DeptID,ExportMarker,UpdateSite)  
VALUES (999000047722,999000002686,999000023312,2,90001,1,900);

INSERT INTO CompSpare(CompSpareID,COMPTYPEID,PartTypeID,ItemStatus,DeptID,ExportMarker,UpdateSite)  
VALUES (999000047723,999000002686,999000022710,2,90001,1,900);

INSERT INTO CompSpare(CompSpareID,COMPTYPEID,PartTypeID,ItemStatus,DeptID,ExportMarker,UpdateSite)  
VALUES (999000047724,999000002686,999000022708,2,90001,1,900);



INSERT INTO amos.RequiredPart (
ReqPartID, WorkOrderID,PartTypeID,CompJobID,BudgetCodeDefID,Quantity,NoReserved,SpareBookingWindow,SpareBookingDynamic,CurrencyCode,PriceToUse,DeptID,
--ExportMarker	LastUpdated	LastUpdatedUTC	IncludeInSpec	LastTouchedUTC	LastImportedUTC	
UpdateSite)
select --* ,
rps.ReqPartID OldReqPartID,
--999000000000 + Row_number () over (ORDER BY rps.ReqPartID /*,SpareUnit_DeptID*/asc)  NewReqPartID,
(select ReqPartID 
FROM amos.RequiredPart WHERE PartTypeID = STM.NewPartTypeID and CompJobID = cjm.NewCompJobID AND DeptID = 72001) NewReqPartID,
CAST(RPS.PartTypeID AS NVARCHAR) OldPartTypeID,
STM.NewPartTypeID NewPartTypeID,
CAST(rps.CompJobID AS NVARCHAR) OldCompJobID,	
CJM.NewCompJobID NewCompJobID,
'PCL' Brand, 'Crown Princess' Vessel,
'SuperGrand' Class,
'24' VesselOldInstID,
720 VesselNewInstID,
CAST(rps.DeptID AS NVARCHAR) OldDeptID,
72001 NewDeptID,
'MZ' STPL_Creator,	
5 STPL_Status,
case 
when CJM.NewCompJobID is null and STM.NewPartTypeID is not null then 'RequiredPart not transferred because CompJob is not transferred.'  
when CJM.NewCompJobID is not null and STM.NewPartTypeID is null then 'RequiredPart not transferred because SpareType is not transferred.' 
when CJM.NewCompJobID is null and STM.NewPartTypeID is null then 'RequiredPart not transferred because neither CompJob, nor SpareType are transferred.' 
else null
end Comments
------------------------------
--,CJM.OldCompJobID,CJM.Vessel, STM.OldPartTypeID,stm.vessel,CJM.Comments CompJobMap_Comments, STM.Comments SpareTypeMap_Comments
--,SpareUnit_DeptID
from  (select RP.*--, su.DeptID SpareUnit_DeptID
from MAST_SRC_PCL.amos.RequiredPart rp 
inner join (SELECT * FROM MAST_SRC_PCL.amos.CompJob WHERE DeptID = 2401)  cj on rp.COMPJOBID = cj.CompJobID 
inner join (SELECT * FROM MAST_SRC_PCL.amos.ComponentUnit WHERE DeptID = 2401) cu on cu.CompID = cj.CompID
--left join amos.SpareUnit su on rp.PartTypeID  = su.PartTypeID
where cu.DeptID = 2401) RPS 
left join (SELECT * FROM amos.MAST_CompJob_Map WHERE VESSEL = 'Crown Princess') cjm on rps.compjobid = cjm.OldCompJobID 
left join (SELECT * FROM amos.MAST_SpareType_Map WHERE VESSEL = 'Crown Princess') stm on rps.PartTypeID = stm.oldPartTypeID 
--where CJM.OldCompJobID is not null and STM.OldPartTypeID is not null
--where STM.OldPartTypeID is null
--order by rps.ReqPartID,
order by STM.NewPartTypeID, CJM.NewCompJobID



INSERT INTO amos.CompTypeRequiredPart(
CompTypeReqPartID,CompTypeJobID,PartTypeID,Quantity,NoReserved,SpareBookingWindow,SpareBookingDynamic,DeptID--,ExportMarker,LastUpdated,LastUpdatedUTC,LastTouchedUTC,LastImportedUTC
,UpdateSite)
SELECT --* ,
ISNULL((select MAX(CompTypeReqPartID) FROM amos.CompTypeRequiredPart WHERE CompTypeReqPartID BETWEEN  999000000000 AND 999001000000),999000000000)
+ ROW_NUMBER () OVER (ORDER BY ctrp.CompTypeJobID, ctrp.PartTypeID)  CompTypeReqPartID,
ctrp.CompTypeJobID CompTypeJobID,
ctrp.PartTypeID PartTypeID,
ctrp.Quantity Quantity,
ctrp.NoReserved NoReserved,
0 SpareBookingWindow,
0 SpareBookingDynamic,
90001 DeptID,
900 UpdateSite
FROM 
(SELECT ctj.CompTypeJobID, rp.PartTypeID, MAX(rp.Quantity) Quantity, MAX(rp.NoReserved) NoReserved
	FROM amos.RequiredPart rp
		INNER JOIN amos.CompJob cj ON rp.CompJobID = cj.CompJobID
		INNER JOIN amos.ComponentUnit cu ON cu.CompID = cj.CompID
		INNER JOIN amos.CompTypeJob ctj ON ctj.CompTypeID = cu.CompTypeID AND cj.JobDescID = ctj.JobDescID
	WHERE rp.DeptID = 72001
	GROUP BY ctj.CompTypeJobID, rp.PartTypeID) ctrp
LEFT JOIN amos.CompTypeRequiredPart ctrpe ON ctrp.CompTypeJobID = ctrpe.CompTypeJobID AND ctrp.PartTypeID = ctrpe.PartTypeID
WHERE ctrpe.CompTypeReqPartID IS NULL
ORDER BY ctrp.CompTypeJobID, ctrp.PartTypeID 


insert into amos.MAST_CompTypeRequiredPart_Map(
OldCompTypeReqPartID, NewCompTypeReqPartID, OldPartTypeID, NewPartTypeID, OldCompTypeJobID, NewCompTypeJobID, OldReqPartID, OldCompJobID, Brand, Vessel
, Class, VesselOldInstID, VesselNewInstID, OldDeptID, NewDeptID, CreatedDate, UpdatedDate, DeletedDate, Comments, STPL_Creator, STPL_Remarks, STPL_Status
, STPL_Source_CompTypeReqPart, STPL_Source_RequiredPart, STPL_Source_Manual, STPL_UpdatedDate)
select 
CAST(ctrps.CompTypeReqPartID AS NVARCHAR) OldCompTypeReqPartID,
(select DISTINCT CompTypeReqPartID from amos.CompTypeRequiredPart ctrp 
inner join amos.MAST_SpareType_Map stm on ctrp.PartTypeID = stm.NewPartTypeID  
inner join amos.Mast_CompTypeJob_Map ctjm on ctrp.CompTypeJobID = ctjm.NewCompTypeJobID
where OldPartTypeID = CAST(ctrps.PartTypeID AS NVARCHAR) and OldCompTypeJobID = CAST(ctrps.CompTypeJobID AS NVARCHAR)
and ctjm.vessel = 'Crown Princess' and stm.vessel = 'Crown Princess'
AND ctrp.CompTypeReqPartID IN (SELECT NewCompTypeReqPartID FROM AMOS.MAST_CompTypeRequiredPart_Map)
	--BETWEEN 999000000276 AND 999000000316 -- SPECIAL
) NewCompTypeReqPartID,
CAST(ctrps.PartTypeID AS NVARCHAR) OldPartTypeID,
(select NewPartTypeID from amos.MAST_SpareType_Map where OldPartTypeID = CAST(ctrps.PartTypeID AS NVARCHAR) and vessel = 'Crown Princess') NewPartTypeID,
CAST(ctrps.CompTypeJobID AS NVARCHAR) OldCompTypeJobID, 
(select  DISTINCT CAST(NewCompTypeJobID AS NVARCHAR)  from amos.MAST_CompTypeJob_Map where OldCompTypeJobID = CAST(ctrps.CompTypeJobID AS NVARCHAR) and vessel = 'Crown Princess') OldCompTypeJobID,
CAST(ctrps.ReqPartID AS NVARCHAR) OldReqPartID,
CAST(ctrps.CompJobID AS NVARCHAR) OldCompJobID,
'PCL' Brand,
'Crown Princess' Vessel,
'SuperGrand' Class,
 '24' VesselOldInstID, 
 720 VesselNewInstID, 
 '1' OldDeptID, 
 90001 NewDeptID, 
 getdate() CreatedDate,
 getdate() UpdatedDate, 
 null DeletedDate, 
 null Comments, 
 'MZ' STPL_Creator, 
 null STPL_Remarks, 
 5 STPL_Status,
 CASE WHEN ctrps.CompTypeReqPartID IS NOT NULL THEN 1 ELSE 0 END STPL_Source_CompTypeReqPart, 
 CASE WHEN ctrps.ReqPartID IS NOT NULL THEN 1 ELSE 0 END  STPL_Source_RequiredPart, 
 0 STPL_Source_Manual, 
 getdate() STPL_UpdatedDate
--select distinct ctrps.*
from (
	select distinct ctrp.CompTypeReqPartID, ctrp.CompTypeJobID, ctrp.Quantity, ctrp.NoReserved,rp.ReqPartID,rp.CompJobID,rp.PartTypeID ,ctrp.DEPTID
	--, cu.CompTypeID, cu.CompID, cj.JobDescID, cj.CompJobID 
	from MAST_SRC_PCL.amos.RequiredPart rp 
		INNER JOIN MAST_SRC_PCL.amos.CompJob cj on rp.CompJobID = cj.CompJobID 
		INNER JOIN MAST_SRC_PCL.amos.ComponentUnit cu on cj.CompID = cu.CompID 
		LEFT JOIN MAST_SRC_PCL.amos.CompTypeJob ctj on cj.JOBDESCID = ctj.JobdescID AND cu.CompTypeID = ctj.CompTypeID
		LEFT JOIN MAST_SRC_PCL.amos.CompTypeRequiredPart ctrp on ctrp.COMPTYPEJOBID = ctj.COMPTYPEJOBID AND rp.PartTypeID = ctrp.PartTypeID
	WHERE cu.deptid in (select deptid from MAST_SRC_PCL.amos.Department where InstID = 24) ) ctrps
ORDER BY ctrps.ReqPartID