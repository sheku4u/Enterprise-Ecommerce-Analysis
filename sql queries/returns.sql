SELECT * from returns LIMIT 5;

-- Q18. Count returns by return reason.
SELECT return_reason, count(return_id) as returns_count FROM returns
GROUP BY return_reason ORDER BY returns_count DESC;

-- Q19. Find total refund amount.
create or replace view total_returns_amt as 
SELECT round(sum(refund_amount),2) as total_returns_amount from returns;

SELECT * from total_returns_amt;

