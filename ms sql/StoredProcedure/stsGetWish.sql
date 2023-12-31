--use Xenus
--exec stsGetWish 'list','buyer1'

Alter proc stsGetWish
	@kind			varchar(10),
	@buyerId		varchar(50)

as
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED	

	BEGIN TRY

		--init
		set @buyerId	  = isnull(@buyerId, '')

		if (@kind = 'list') 
			begin 
				select	  row_number() over(order by a.regDate desc) as no
						, a.wishIndex

						, a.memberIndex
						, a.productIndex
						, a.productName
						, replace(convert(varchar, convert(money, a.price), 1), '.00', '')		  as price						

						, convert(varchar(19), a.regDate, 121) as regDate
						, convert(varchar(19), a.modDate, 121) as modDate

						, c.image
						, replace(convert(varchar, convert(money, c.tradingPrice), 1), '.00', '') as tradingPrice	

				from	wish a with (nolock)
						inner join member  b with (nolock) on b.memIndex = a.memberIndex
						inner join product c with (nolock) on c.productIndex = a.productIndex

				where	b.id = @buyerId
				and		a.useYN = 'Y'

				order by no
			end

		return 1;
	END TRY
	
	
	BEGIN CATCH
		select -1 as code, 'error' as text
		return -1;
	END CATCH

	--select * from wish
	