--use Xenus
--exec stsSetProductIns 'name2', '100', '100', 'image', 'keywords','010-1111-2222','xenus','ready'

Alter proc stsSetProductIns
	@name				varchar(100),
	@price				varchar(10),
	@tradingPrice		varchar(10), 
	@image				varchar(200),
	@keywords			varchar(100),
	@description		varchar(max),
	@phoneNumber		varchar(20),
	@regId				varchar(50)

as
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	declare @cr char(1) = 0xa	

	BEGIN TRY
		--init
		set @description = replace(@description, @cr, '<br/>')

		insert into	product(name, price, tradingPrice, image, keywords, description, phoneNumber, regId, status, useYN, regDate, modDate)
					values(@name, @price, @tradingPrice, @image, @keywords, @description, @phoneNumber, @regId, 'ready', 'Y', getdate(), null)
	
		select 1 as code, '입력되었습니다.' as text
		return 1;
	END TRY
	
	
	BEGIN CATCH
		select -1 as code, 'error' as text
		return -1;
	END CATCH

	--select * from product

	