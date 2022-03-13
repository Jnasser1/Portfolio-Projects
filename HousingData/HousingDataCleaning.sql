


/*
Cleaning Data in SQL Queries
*/


Select *
From HousingProject.dbo.Housing



--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format



Select saleDate from HousingProject.dbo.Housing


ALTER TABLE Housing
Add SaleDateConverted Date;


Select saleDateConverted, CONVERT(Date,SaleDate)
From HousingProject.dbo.Housing


Update Housing
SET SaleDate = CONVERT(Date,SaleDate)


Update Housing
SET SaleDateConverted = CONVERT(Date,SaleDate)






 --------------------------------------------------------------------------------------------------------------------------
 
-- Populate Property Address data



Select *
From HousingProject.dbo.Housing
 Where PropertyAddress is null
order by ParcelID



Select *
From HousingProject.dbo.Housing
--Where PropertyAddress is null
order by ParcelID



/*
if parcelidX has address and parcelY doesnt have 
an address lets use X address for Y missing vals.
*/






-- Should show zero results, assigning b.PropertyAddress to null value in a.PropertyAddress
Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, 
ISNULL(a.PropertyAddress,b.PropertyAddress)
From HousingProject.dbo.Housing a
JOIN HousingProject.dbo.Housing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From HousingProject.dbo.Housing a
JOIN HousingProject.dbo.Housing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null




--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)


Select PropertyAddress
From HousingProject.dbo.Housing
--Where PropertyAddress is null
--order by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address

From HousingProject.dbo.Housing


ALTER TABLE Housing
Add PropertySplitAddress Nvarchar(255);


Update Housing
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


ALTER TABLE Housing
Add PropertySplitCity Nvarchar(255);

Update Housing
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))




Select *
From HousingProject.dbo.Housing


 -- Owner Address


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From HousingProject.dbo.Housing


ALTER TABLE Housing
Add OwnerSplitAddress Nvarchar(255);

ALTER TABLE Housing
Add OwnerSplitCity Nvarchar(255);


ALTER TABLE Housing
Add OwnerSplitState Nvarchar(255);


Update Housing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)

Update Housing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)


Update Housing
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



Select OwnerAddress
From HousingProject.dbo.Housing





--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field






-- When SoldAsVacant is 'Y' we want 'Yes'
select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
		When SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
		End
from HousingProject.dbo.Housing



Update Housing
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END


-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates

-- Using common table expressions to remove duplicate values
-- How to say data entries in the table are the same data, partition by


WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From HousingProject.dbo.Housing
---order by ParcelID
)

 -- Delete 104 duplicate values
/*
DELETE
From RowNumCTE
Where row_num > 1
-- Order by PropertyAddress
*/



-- Re-running CTE to show duplicates, zero results.
SELECT *
From RowNumCTE
Where row_num > 1
 Order by PropertyAddress







select * from HousingProject.dbo.Housing;






---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns



Select *
From HousingProject.dbo.Housing


-- Drop the un-needed columnns we split into multiple ones.
ALTER TABLE HousingProject.dbo.Housing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate





















