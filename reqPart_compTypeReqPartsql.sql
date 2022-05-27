select cj.CompJobID, 999000049484 PartTypeid, 999000004089 CompTypeJobID from amos.comptypejob ctj 
inner join amos.componentunit cu on ctj.comptypeid = cu.comptypeid inner join amos.CompJob cj on ctj.jobdescid = cj.JobDescID and cj.CompID = cu.CompId
where ctj.comptypejobid = 999000004089 and cu.deptid = 72001 union
select cj.CompJobID, 999000035433 PartTypeid, 999000003892 CompTypeJobID from amos.comptypejob ctj 
inner join amos.componentunit cu on ctj.comptypeid = cu.comptypeid inner join amos.CompJob cj on ctj.jobdescid = cj.JobDescID and cj.CompID = cu.CompId
where ctj.comptypejobid = 999000003892 and cu.deptid = 72001 union
select cj.CompJobID, 999000023638 PartTypeid, 999000003917 CompTypeJobID from amos.comptypejob ctj 
inner join amos.componentunit cu on ctj.comptypeid = cu.comptypeid inner join amos.CompJob cj on ctj.jobdescid = cj.JobDescID and cj.CompID = cu.CompId
where ctj.comptypejobid = 999000003917 and cu.deptid = 72001 union
select cj.CompJobID, 999000023312 PartTypeid, 999000003917 CompTypeJobID from amos.comptypejob ctj 
inner join amos.componentunit cu on ctj.comptypeid = cu.comptypeid inner join amos.CompJob cj on ctj.jobdescid = cj.JobDescID and cj.CompID = cu.CompId
where ctj.comptypejobid = 999000003917 and cu.deptid = 72001 union
select cj.CompJobID, 999000022711 PartTypeid, 999000003749 CompTypeJobID from amos.comptypejob ctj 
inner join amos.componentunit cu on ctj.comptypeid = cu.comptypeid inner join amos.CompJob cj on ctj.jobdescid = cj.JobDescID and cj.CompID = cu.CompId
where ctj.comptypejobid = 999000003749 and cu.deptid = 72001 union
select cj.CompJobID, 999000022710 PartTypeid, 999000003749 CompTypeJobID from amos.comptypejob ctj 
inner join amos.componentunit cu on ctj.comptypeid = cu.comptypeid inner join amos.CompJob cj on ctj.jobdescid = cj.JobDescID and cj.CompID = cu.CompId
where ctj.comptypejobid = 999000003749 and cu.deptid = 72001 union
select cj.CompJobID, 999000022708 PartTypeid, 999000004140 CompTypeJobID from amos.comptypejob ctj 
inner join amos.componentunit cu on ctj.comptypeid = cu.comptypeid inner join amos.CompJob cj on ctj.jobdescid = cj.JobDescID and cj.CompID = cu.CompId
where ctj.comptypejobid = 999000004140 and cu.deptid = 72001 