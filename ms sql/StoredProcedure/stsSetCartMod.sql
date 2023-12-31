--use Xenus
--exec stsSetCartMod 'mod', '1', '', '', ''
--exec stsSetCartMod 'del', '1'

Alter proc stsSetCartMod
	@kind				varchar(10),
	@cartIndex			varchar(10),
	
	@biddingPrice		varchar(10) = '',
	@phoneNumber		varchar(50) = '',
	@tradingPlace		varchar(100)= ''

as
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED	

	BEGIN TRY
		if (@kind = 'mod')
			begin
				update cart set	  biddingPrice = @biddingPrice
								, phoneNumber  = @phoneNumber
								, tradingPlace = @tradingPlace
								, modDate = getDate() 

						where	cartIndex = @cartIndex

				select 1 as code, '수정되었습니다.' as text
			end
			
		else if (@kind = 'del')
			begin
				delete from cart where cartIndex = @cartIndex

				select 1 as code, '삭제되었습니다.' as text
			end

		return 1;
	END TRY
	
	
	BEGIN CATCH
		select -1 as code, 'error' as text
		return -1;
	END CATCH

	--select * from member