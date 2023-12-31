--use Xenus
--exec stsSetWishIns '1', '1'

Alter proc stsSetWishIns
	@memberIndex		varchar(10),
	@productIndex		varchar(10)

as
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED	

	BEGIN TRY
		insert into	wish(memberIndex, productIndex, productName, price, useYN, regDate)
					select    @memberIndex
							, productIndex
							, name				as productName
							, tradingPrice		as price
							, 'Y'				as useYN
							, getDate()

					from	product with (nolock)
					where	productIndex = @productIndex
	
		select 1 as code, '찜했습니다.' as text
		return 1;
	END TRY
	
	
	BEGIN CATCH
		select -1 as code, 'error' as text
		return -1;
	END CATCH

	--select * from cart

	