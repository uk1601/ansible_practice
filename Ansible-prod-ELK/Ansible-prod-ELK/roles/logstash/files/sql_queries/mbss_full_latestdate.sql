SELECT m.id, m."HOSTNAME", m."CHECK NO.", m."STATUS", m."SCAN_DATE", h."IP Address", h."OS Platform", h."OS Version", h."Application", h."Host Status", h."Type", i."Server Status", cn."CATEGORY", m."SCAN_COMMAND", m."REMEDIATE_COMMAND", h."OS Platform", "OS Version", COMPLIANT_STATUS
FROM mbss_output m, host_inventory h, inventory_status i, check_no cn,
(select "HOSTNAME","SCAN_DATE","IP Address","Server Status","Host Status",case WHEN COMPLIANT_STATUS LIKE '%NCCOMPLIANT%' THEN 'PARTIAL' WHEN COMPLIANT_STATUS LIKE '%COMPLIANTNC%' THEN 'PARTIAL' WHEN COMPLIANT_STATUS LIKE '%COMPLIANT%' THEN 'COMPLIANT' WHEN COMPLIANT_STATUS LIKE '%NC%' THEN 'NON_COMPLIANT' END as COMPLIANT_STATUS from (SELECT m."HOSTNAME","SCAN_DATE",i."IP Address","Server Status","Host Status", string_agg("STATUS", '') AS COMPLIANT_STATUS FROM public.mbss_output m, public.inventory_status i, public.host_inventory h WHERE "STATUS" != 'NOT_APPLICABLE' AND m."HOSTNAME"=i."HOSTNAME" AND m."HOSTNAME"=h."HOSTNAME" GROUP BY m."HOSTNAME","SCAN_DATE",i."IP Address","Server Status","Host Status") a WHERE "SCAN_DATE" IN (SELECT MAX("SCAN_DATE") FROM mbss_output GROUP BY "HOSTNAME")) as y
WHERE y."HOSTNAME" = m."HOSTNAME" AND
y."HOSTNAME" = i."HOSTNAME" AND
y."HOSTNAME" = h."HOSTNAME" AND
m."CHECK NO." = cn."CHECK NO.";