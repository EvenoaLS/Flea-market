--use Xenus
--exec stsSetCartIns 'xenus', 'xenus', '1', 'product1', '1000','101','buyerId','buyerName','010-1111-1111','105'

Alter proc stsSetCartIns
	@sellerId			varchar(50),
	@sellerName			varchar(50),

	@productIndex		varchar(10), 
	@productName		varchar(100),

	@price				varchar(10),
	@tradingPlace		varchar(100),

	@buyerId			varchar(50),
	@buyerName			varchar(50),

	@phoneNumber		varchar(50),
	@biddingPrice		varchar(10)

as
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED	

	BEGIN TRY
		--init
		set @price			= replace(@price,',','')
		set @tradingPlace	= replace(@tradingPlace,',','')
		set @biddingPrice	= replace(@biddingPrice,',','')

		--ins
		insert into	cart(sellerId, sellerName, productIndex, productName, price, tradingPlace, buyerId, buyerName, phoneNumber, biddingPrice, status, regDate, modDate)
				 values(@sellerId, @sellerName, @productIndex, @productName, @price, @tradingPlace, @buyerId, @buyerName, @phoneNumber, @biddingPrice, 'buy', getdate(), null)
	
		select 1 as code, '구매가 완료되었습니다.' as text
		return 1;
	END TRY
	
	
	BEGIN CATCH
		select -1 as code, 'error' as text
		return -1;
	END CATCH

	--select * from cart

	