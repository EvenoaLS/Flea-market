--use Xenus
--exec stsGetSold 'list'
--exec stsGetSold 'list','seller1'
--exec stsGetSold 'list','','buyer1'

Alter proc stsGetSold
	@kind			varchar(10),

	@sellerId		varchar(50) = '',
	@buyerId		varchar(50) = ''

as
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED	

	BEGIN TRY

		--init
		set @sellerId	  = isnull(@sellerId, '')
		set @buyerId	  = isnull(@buyerId, '')

		if (@kind = 'list') 
			begin 
				select	  row_number() over(order by regDate desc) as no
						, soldIndex

						, sellerId
						, sellerName
						, productIndex
						, productName
						, replace(convert(varchar, convert(money, price), 1), '.00', '') as price
						
						, tradingPlace
						, buyerId
						, buyerName
						, phoneNumber
						, replace(convert(varchar, convert(money, biddingPrice), 1), '.00', '') as biddingPrice

						, status
						, substring(convert(varchar, regDate, 112),1,4) + '.' + substring(convert(varchar, regDate, 112),5,2) + '.' + substring(convert(varchar, regDate, 112),7,2) as regDate
						, (select image from product with (nolock) where productIndex = a.productIndex) as image

				from	sold a with (nolock)

				where	1 = case when @sellerId = ''		then 1
								 when @sellerId = sellerId	then 1
								 else 0 end

				and		1 = case when @buyerId = ''			then 1
								 when @buyerId = buyerId	then 1
								 else 0 end

				order by no

			end

		return 1;
	END TRY
	
	
	BEGIN CATCH
		select -1 as code, 'error' as text
		return -1;
	END CATCH

	--select * from sold

	