--1o

--------1
with recursive 
job_net (userA, userB) as
(select email,connectedWith_email
  from connects
  union
 sELECT p.userA, f.connectedWith_email
  FROM job_net as p join connects as f
   on (p.userB=f.email))
   
select distinct e1.email,e2.email
from education as e1,education as e2
where  e1.school=e2.school and e1.email<e2.email and ( (extract (year from e1.toYear))>=(extract (year from e2.fromYear)))--epikalyptomena diathmata
except
 (select *
 from job_net)
 
 --1o
   create function funcq1(userp varchar )
 RETURNS table(user1 varchar,user2 varchar) AS $$
 BEGIN

 RETURN QUERY

 with recursive 
 job_net (userA, userB) as
 (select email,connectedWith_email
  from connects
  union
 sELECT p.userA, f.connectedWith_email
  FROM job_net as p join connects as f
   on (p.userB=f.email))
   
select distinct e1.email,e2.email
from education as e1,education as e2
where  e1.school=e2.school and e1.email=userp and e1.email<e2.email and ( (extract (year from e1.toYear))>=(extract (year from e2.fromYear)))--epikalyptomena diathmata
except
 (select *
 from job_net);

 END;
 $$Language plpgsql;

 select funcq1('akarageorgiadis@isc.tuc.gr')

--2o


--3o xrhstes me perissotera apo 2 arthra
select email
from article
group by email
having count(*) >=2


--4o
---4
--DROP FUNCTION userGlobalComm(character varying)

create or replace function userGlobalComm(userp varchar)

RETURNS table(user1 varchar) AS $$
BEGIN


RETURN QUERY

SELECT email
from member
where not exists (select ar.email
from article as ar, article_comment as arc
where ar.articleId=arc.articleID
and ar.email=userp 
and not exists 
(select email
from article_comment as c
where c.articleId=ar.articleId and
c.email=member.email));


END;
$$Language plpgsql;

select userGlobalComm('eva.waters@gmail.com')--xrhsths pu exei apo 2 kai panw arthra


--5o
--1.5
SELECT a.articleId, title,categoryId,theText,a.datePosted,a.email, count(distinct commentId)  as Comments_per_article
FROM  article as a, article_comment as ac
where a.articleId=ac.articleId
group by a.articleId




--6o
--vres to epipedo ekpaideyshs
select eduLevel
from education as e
where e.email=
--epele3e ton xrhsth pou ta xei gra4ei
(select email
from article as ar
where ar.articleId=
--epele3e ayta ta arthra
(select articleId
From 
--eyresh arthrwn me ari8mo sxoliwn megalytero apo to meso oro
(SELECT articleID, count(distinct commentId)  as Com_per_article
FROM   article_comment as ac
group by articleId
having count(distinct commentId) >
 
(select avg(Com_per_article)
 from (SELECT articleID, count(distinct commentId)  as Com_per_article
        FROM   article_comment as ac
         group by articleId) as n))as k))


--7o
--1.7

SELECT js.advertisementId, jo.advertisementId
FROM
job_seek as js, advertisement as a1, advertisement as a2,  job_offer as jo
WHERE
 (js.advertisementId = a1.advertisementId AND a2.advertisementId = jo.advertisementId) 
      and (a1.jobType=a2.jobType) and (a1.industry=a2.industry) and (a1.country=a2.country) 
	  and ( (a1.salary=a2.salary-a2.salary*0.1) or (a1.salary=a2.salary+a2.salary*0.1) )


--8o
----88
--DROP FUNCTION job_netf(character varying)

create or replace function job_netF (userF varchar)
RETURNS table(user1 varchar,user2 varchar) AS $$
BEGIN
RETURN QUERY

with recursive 
job_net (userA, userB) as
(select email,connectedWith_email
  from connects
  union
 sELECT p.userA, f.connectedWith_email
  FROM job_net as p join connects as f
   on (p.userB=f.email))

   SELECT userA,userB
      FROM job_net
      where userA=userF;

      

END;
$$Language plpgsql; 

select job_netF('akarageorgiadis@isc.tuc.gr')

--B meros----------Ypologismoi
--1o
--2.1

select email, count(*) 
from article_comment
group by email

--2o
--2.2
select avg(salary)
from job_seek as js, advertisement as a
where js.advertisementId=a.advertisementId and a.specialworkcapability='remoted_work'

--3o
select extract(month  from dateSent) as monthh,extract(year from dateSent) as yearS,count(*)
from msg
group by monthh ,yearS
--4o
--2.4
--SEE dateSent of each table
--select r.dateSent, rr.dateSent
--from recommendation_msg as r,recommendation_request as rr
--where r.requestId=rr.requestId


select avg( (extract(day from rm.dateSent))-(extract(day from rr.dateSent)))
from recommendation_msg as rm, recommendation_request as rr
--5o
--2.5
SELECT for_email,count(*) as num
FROM recommendation_request
GROUP BY for_email
HAVING count(*) = (
SELECT max(num)
FROM ( SELECT for_email,count(*) as num
FROM recommendation_request
GROUP BY for_email ) as k )