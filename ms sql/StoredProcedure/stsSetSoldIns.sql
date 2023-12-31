--use Xenus
--exec stsSetSoldIns '1'

Alter proc stsSetSoldIns
	@cartIndex	varchar(10)

as
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED	

	BEGIN TRY
		declare @ProductIndex int = (select productIndex from cart where cartIndex = @cartIndex);

		--mod
		update product set status = 'sold' where productIndex = @ProductIndex;

		--ins
		insert into	sold(sellerId, sellerName, productIndex, productName, price, tradingPlace, buyerId, buyerName, phoneNumber, biddingPrice, status, cartIndex, regDate, modDate)
				  select sellerId, sellerName, productIndex, productName, price, tradingPlace, buyerId, buyerName, phoneNumber, biddingPrice, status, cartIndex, getdate(), null
				  from   cart with (nolock)
				  where  cartIndex = @cartIndex

		--del
		delete from cart where productIndex = @ProductIndex;
		delete from wish where productIndex = @ProductIndex;

	
		select 1 as code, 'ok' as text
		return 1;
	END TRY
	
	
	BEGIN CATCH
		select -1 as code, 'error' as text
		return -1;
	END CATCH

	--select * from cart
	--select * from sold

	