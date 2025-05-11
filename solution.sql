DROP TABLE IF EXISTS #TargetBills;
DROP TABLE IF EXISTS #Answer;
CREATE TABLE #Answer (
  Name    nvarchar(500) collate Cyrillic_General_CI_AS null,
  Inn     nvarchar(12)  collate Cyrillic_General_CI_AS not null,
  Num     nvarchar(50)  collate Cyrillic_General_CI_AS null,
  BDate   date          null,
  PayDate date          null,
  BillSum money         null,
  BillPay money         null
);

WITH SuitableBills AS (
  SELECT b.bID bID,
         ROW_NUMBER() OVER w N
    FROM Bills b
    JOIN BillContent bc
      ON b.bID = bc.bID
     AND bc.Product = N'Контур-Экстерн'
    LEFT JOIN RetailPacks rp
      ON bc.bcID = rp.bcID
     AND UpTo >= '2021-01-01'
   WHERE UpTo IS NOT NULL
      OR TypeID IN (1, 2) AND PayDate IS NOT NULL
   GROUP BY b.bID, cID
  WINDOW w AS (PARTITION BY cID ORDER BY MAX(UpTo) DESC, MAX(PayDate) DESC)
)
SELECT bID INTO #TargetBills FROM SuitableBills WHERE N = 1;
INSERT #Answer ([Name], [Inn], [Num], [Bdate], [PayDate], [BillSum], [BillPay])
SELECT Name, Inn, Num, BDate, PayDate, BillSum, BillPay
  FROM #TargetBills tb
  JOIN Bills b ON tb.bID = b.bID
  JOIN Clients c ON b.cID = c.cID
  JOIN (SELECT tb.bID bID, SUM(Cost) BillSum, SUM(Paid) BillPay
          FROM #TargetBills tb
          JOIN BillContent bc ON tb.bID = bc.bID
         GROUP BY tb.bID) ms ON tb.bID = ms.bID;

SELECT * FROM #Answer;
