WITH date_lags AS (
    SELECT
        dts.as_of_date,
        (dts.as_of_date::DATE - '{compare_interval}'::INTERVAL)::DATE AS as_of_date_lag
    FROM (
        SELECT DISTINCT preds.as_of_date
        FROM predictions preds
        INNER JOIN models mods
        ON mods.model_id = preds.model_id
        WHERE  preds.as_of_date <= '{end_date}'
        AND preds.as_of_date >= '{start_date}'
        AND ({no_model_group_subset} OR mods.model_group_id IN
            (SELECT(UNNEST(ARRAY{model_group_ids}::INTEGER[]))))
        AND ({no_model_id_subset} OR mods.model_id IN
            (SELECT(UNNEST(ARRAY{model_ids}::INTEGER[]))))
    ) dts
), valid_date_lags AS (
    SELECT
        dl1.as_of_date,
        dl1.as_of_date_lag
    FROM date_lags dl1
    INNER JOIN date_lags dl2
    ON dl1.as_of_date_lag = dl2.as_of_date
), prediction_lags AS (
    SELECT
        preds.as_of_date AS as_of_date_lag,
        preds.model_id,
        mods.model_group_id,
        preds.entity_id,
        preds.score AS score_lag,
        preds.label_value AS label_value_lag,
        preds.rank_abs AS rank_abs_lag,
        preds.rank_pct AS rank_pct_lag
    FROM predictions preds
    INNER JOIN valid_date_lags vgl
    ON vgl.as_of_date_lag = preds.as_of_date
    INNER JOIN models mods
    ON preds.model_id = mods.model_id
    WHERE ({no_model_group_subset} OR mods.model_group_id IN
        (SELECT(UNNEST(ARRAY{model_group_ids}::INTEGER[]))))
    AND ({no_model_id_subset} OR mods.model_id IN
        (SELECT(UNNEST(ARRAY{model_ids}::INTEGER[]))))
)
SELECT
    vdl.as_of_date::DATE AS as_of_date,
    vdl.as_of_date_lag::DATE AS as_of_date_lag,
    preds.model_id,
    mods.model_group_id,
    preds.entity_id,
    preds.score,
    preds.label_value,
    preds.rank_abs,
    preds.rank_pct,
    plag.score_lag,
    plag.label_value_lag,
    plag.rank_abs_lag,
    plag.rank_pct_lag
FROM predictions preds
INNER JOIN valid_date_lags vdl
ON vdl.as_of_date = preds.as_of_date
INNER JOIN models mods
ON mods.model_id = preds.model_id
INNER JOIN prediction_lags plag
ON plag.as_of_date_lag = vdl.as_of_date_lag
AND plag.entity_id = preds.entity_id
AND mods.model_group_id = plag.model_group_id
WHERE ({no_model_group_subset} OR mods.model_group_id IN
    (SELECT(UNNEST(ARRAY{model_group_ids}::INTEGER[]))))
AND ({no_model_id_subset} OR mods.model_id IN
    (SELECT(UNNEST(ARRAY{model_ids}::INTEGER[]))))