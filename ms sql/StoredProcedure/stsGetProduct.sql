--use Xenus
--exec stsGetProduct 'list'
--exec stsGetProduct 'list','seller1'
--exec stsGetProduct 'list','','buyer1'

--exec stsGetProduct 'one', '','buyer1','2'
--exec stsGetProduct 'one', '','','23'

--exec stsGetProduct 'list', @findSel='',		 @findStr='옷'
--exec stsGetProduct 'list', @findSel='seller',	 @findStr='옷 판매'
--exec stsGetProduct 'list', @findSel='product', @findStr='가성비'
--exec stsGetProduct 'list', @findSel='price',   @findStr='110000'


Alter proc stsGetProduct
	@kind			varchar(10),

	@sellerId		varchar(50) = '',
	@buyerId		varchar(50) = '',
	@productIndex	varchar(10) = '',

	@findSel		varchar(20) = '',
	@findStr		varchar(50) = ''

as
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED

	declare @cr char(1) = 0xa

	BEGIN TRY

		--init
		set @sellerId		= isnull(@sellerId, '')
		set @buyerId		= isnull(@buyerId, '')
		set @productIndex	= isnull(@productIndex, '')

		set @findSel		= isnull(@findSel, '')
		set @findStr		= isnull(@findStr, '')

		--list
		if (@kind = 'list') 
			begin 
				select	  row_number() over(order by a.status, a.regDate desc) as no
						, a.productIndex

						, a.name
						, replace(convert(varchar, convert(money, a.price), 1), '.00', '')			as price
						, replace(convert(varchar, convert(money, a.tradingPrice), 1), '.00', '')	as tradingPrice
						, a.image
						, a.keywords
						
						, a.phoneNumber
						, a.regId

						, a.status
						, case  when a.status = 'ready' and c.cartIndex is null		then '판매중'
								when a.status = 'ready' and c.cartIndex is not null then '구매중'
								when a.status = 'sold'  then '판매완료'
								else a.status
								end as statusName

						, a.useYN
						, isnull(e.bidderCount,0)		   as bidderCount

						, convert(varchar, a.regDate, 112) as regDate
						, convert(varchar, a.modDate, 112) as modDate

				from	product a with (nolock)
						inner join member b with (nolock) on b.id = a.regId
						left  join cart   c with (nolock) on c.productIndex = a.productIndex and c.buyerId = @buyerId

						left  join (
										select productIndex, count(*) as bidderCount from cart
										group by productIndex
						           ) e on e.productIndex = a.productIndex

				where	a.useYN = 'Y'

				and		1 = case when @sellerId = ''      then 1
								 when @sellerId = a.regId then 1
								 else 0 end

				and		1 = case when @findSel = ''		   and  @findStr = ''						then 1
								 when @findSel = 'seller'  and  charindex(@findStr, b.name) > 0		then 1
								 when @findSel = 'product' and  charindex(@findStr, a.name) > 0		then 1
								 when @findSel = 'price'   and  @findStr between a.tradingPrice - 10000 and  a.tradingPrice + 10000 then 1
								 
								 when charindex(@findStr, b.name) > 0		then 1
								 when charindex(@findStr, a.name) > 0		then 1
								 when charIndex(@findStr, a.keywords) > 0	then 1
								 else 0 end

				order by no

			end

		else if (@kind = 'one') 
			begin 
				select	  a.productIndex

						, a.name
						, replace(convert(varchar, convert(money, a.price), 1), '.00', '')			as price
						, replace(convert(varchar, convert(money, a.tradingPrice), 1), '.00', '')	as tradingPrice
						, a.image
						, a.keywords

						, replace(a.description,'"','''')		as description
						, replace(a.description,'<br/>',@cr)	as descriptionText
						, a.phoneNumber	
						, a.status
						, a.useYN
						, a.regId

						, convert(varchar, a.regDate, 112) as regDate
						, convert(varchar, a.modDate, 112) as modDate

						--구매관련
						, a.regId					as sellerId
						, b.name					as sellerName
						, a.name					as productName
						, isnull(v.memberType,'')	as memberType

						, case	when a.status = 'sold'   then 'N'
								when c.cartIndex is null then 'Y'
								else 'N'
								end					as canBuy

						, isnull(c.cartIndex,'')	as cartIndex
						, isnull(c.biddingPrice,'')	as biddingPrice
						, isnull(c.phoneNumber,'')	as buyerPhoneNumber
						, isnull(c.tradingPlace,'')	as tradingPlace

						--찜관련
						, case	when a.status = 'sold'   then 'N'
								when d.wishIndex is null then 'Y'
								else 'N'
								end					as canWish

						, replace(convert(varchar, convert(money, e.maxPrice), 1), '.00', '')	as maxPrice

				from	product			  a with (nolock)
						inner join member b with (nolock) on b.id = a.regId

						left  join member v with (nolock) on v.id = @buyerId
						left  join cart   c with (nolock) on c.productIndex = a.productIndex and c.buyerId = @buyerId
						left  join wish   d with (nolock) on d.productIndex = a.productIndex and d.memberIndex = v.memIndex

						left  join (
										select max(biddingPrice) as maxPrice from cart where productIndex = @productIndex
						           ) e on 1=1

				where	a.productIndex = @productIndex
			end

		return 1;
	END TRY
	
	
	BEGIN CATCH
		select -1 as code, 'error' as text
		return -1;
	END CATCH
	
	--select * from product
	--select * from member where id = 'buyer'
	--select * from cart
	--select * from wish
	