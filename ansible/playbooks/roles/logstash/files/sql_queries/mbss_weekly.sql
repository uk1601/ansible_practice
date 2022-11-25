select "HOSTNAME","SCAN_DATE","IP Address","Server Status","Host Status",case WHEN COMPLIANT_STATUS LIKE '%NCCOMPLIANT%' THEN 'PARTIAL' WHEN COMPLIANT_STATUS LIKE '%COMPLIANTNC%' THEN 'PARTIAL' WHEN COMPLIANT_STATUS LIKE '%COMPLIANT%' THEN 'COMPLIANT' WHEN COMPLIANT_STATUS LIKE '%NC%' THEN 'NON_COMPLIANT' END as COMPLIANT_STATUS from (SELECT m."HOSTNAME","SCAN_DATE",i."IP Address","Server Status","Host Status", string_agg("STATUS", '') AS COMPLIANT_STATUS FROM public.mbss_output m, public.inventory_status i, public.host_inventory h WHERE "STATUS" != 'NOT_APPLICABLE' AND m."HOSTNAME"=i."HOSTNAME" AND m."HOSTNAME"=h."HOSTNAME" AND i."Server Status"='SUCCESS'  GROUP BY m."HOSTNAME","SCAN_DATE",i."IP Address","Server Status","Host Status") a ORDER BY "SCAN_DATE" DESC NULLS LAST;