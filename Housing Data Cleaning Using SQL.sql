/*

Cleaning Data in SQL Queries

*/


Select *
From nhousings;

--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format


SELECT 
    SaleDate,
    FORMAT(CAST(SaleDate AS Date), 'dd-MM-yyyy') AS SaleDateFormatted
FROM 
    nhousings;


Update nhousings
SET SaleDate =  SaleDateFormatted;

-- If it doesn't Update properly

ALTER TABLE nhousings
Add SaleDateConverted Date;



 --------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data

Select *
From nhousings
Where PropertyAddress is null
order by ParcelID



SELECT 
    a.ParcelID, 
    a.PropertyAddress, 
    b.ParcelID, 
    b.PropertyAddress
FROM 
    nhousings a 
JOIN 
    nhousings b
    ON a.ParcelID = b.ParcelID
  


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From nhousings a
JOIN nhousings b
	on a.ParcelID = b.ParcelID
Where a.PropertyAddress is null




--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)


Select PropertyAddress
From nhousings;
-- Where PropertyAddress is null
-- order by ParcelID

SELECT
  TRIM(SUBSTRING_INDEX(PropertyAddress, ',', 1)) AS Address,
  TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(PropertyAddress, ',', 2), ',', -1)) AS City,
  TRIM(SUBSTRING_INDEX(PropertyAddress, ',', -1)) AS State
FROM nhousings;

ALTER TABLE nhousings
Add PropertySplitAddress varchar(255);

UPDATE nhousings
SET PropertySplitAddress = TRIM(SUBSTRING_INDEX(PropertyAddress, ',', 1));


ALTER TABLE nhousings
Add PropertySplitCity varchar(255);

UPDATE nhousings
SET PropertySplitCity = TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(PropertyAddress, ',', 2), ',', -1));





Select *
From nhousings;





Select OwnerAddress
From nhousings;


SELECT
  TRIM(SUBSTRING_INDEX(OwnerAddress, ',', 1)) AS Street,
  TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', 2), ',', -1)) AS City,
  TRIM(SUBSTRING_INDEX(OwnerAddress, ',', -1)) AS State
FROM nhousings;



ALTER TABLE nhousings
Add OwnerSplitAddress varchar(255);

Update NHOUSINGS
SET OwnerSplitAddress = TRIM(substring_index(OwnerAddress, ',', '.'));


ALTER TABLE nhousings
Add OwnerSplitCity varchar(255);

UPDATE nhousings
SET OwnerSplitCity = TRIM(SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', 2), ',', -1));




ALTER TABLE Nhousings
Add OwnerSplitState varchar(255);

UPDATE nhousings
SET OwnerSplitState = TRIM(SUBSTRING_INDEX(OwnerAddress, ',', -1));



Select *
From 
nhousings;




--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From nhousings
Group by SoldAsVacant
order by 2;




Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From nhousings;


Update nhousings
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END;






-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates

WITH RowNumCTE AS (
    SELECT *,
           ROW_NUMBER() OVER (
               PARTITION BY ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference
               ORDER BY ParcelID
           ) AS row_num
    FROM nhousings
)
SELECT *
FROM RowNumCTE
WHERE row_num > 1;




Select *
From nhousings;




---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns



Select *
From nhousings;


ALTER TABLE nhousings
DROP COLUMN OwnerAddress,
DROP COLUMN PropertyAddress,
DROP COLUMN SaleDate;

