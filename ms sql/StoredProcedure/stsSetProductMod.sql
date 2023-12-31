--use Xenus
--exec stsSetProductMod '1','mod', 'name', '101', '101', 'image1', 'keywords1','010-222-2222','sell'
--exec stsSetProductMod '1','del'
--exec stsSetProductMod '1','recover'

Alter proc stsSetProductMod
	@productIndex		varchar(10),
	@kind				varchar(10),

	@name				varchar(100) = '',
	@price				varchar(10)  = '',
	@tradingPrice		varchar(10)  = '',
	@image				varchar(200) = '',
	@keywords			varchar(100) = '',
	@description		varchar(max) = '',
	@phoneNumber		varchar(20)  = ''

as
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED	

	declare @cr char(1) = 0xa

	BEGIN TRY
		--init
		set @price			= replace(@price, ',', '')
		set @tradingPrice	= replace(@tradingPrice, ',', '')
		set @description	= replace(@description, @cr, '<br/>')


		if (@kind = 'mod')
			begin
				update product set	  name			= @name
									, price			= @price
									, tradingPrice	= @tradingPrice
									, image			= @image
									, keywords		= @keywords
									, description	= @description
									, phoneNumber	= @phoneNumber
									, modDate		= getDate()

							where	productIndex    = @productIndex

				select 1 as code, '수정되었습니다.' as text
			end
			
		else if (@kind = 'del')
			begin
				update product  set useYN = 'N' where productIndex = @productIndex

				select 1 as code, '삭제되었습니다.' as text
			end
			
		else if (@kind = 'recover')
			begin
				update product  set useYN = 'Y' where productIndex = @productIndex

				select 1 as code, '복구되었습니다.' as text
			end

		return 1;
	END TRY
	
	
	BEGIN CATCH
		print '[Error Number = ' +  convert(varchar(50), error_number()) + '],[Error Text = ' + error_message() + ']';

		select -1 as code, 'error' as text, @productIndex as keyCode
		return -1;
	END CATCH

	--select * from product