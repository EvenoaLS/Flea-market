--use Xenus
--exec stsGetMember 'list'
--exec stsGetMember 'one', 12

Alter proc stsGetMember
	@kind		varchar(10),

	@memIndex	varchar(10) = ''

as
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED	

	BEGIN TRY
		if (@kind = 'list') 
			begin 
				select	row_number() over(order by regDate desc) as no, memIndex, id, password, name
						
						, case	when memberType = 'admin'  then '관리자'
								when memberType = 'seller' then '판매자'
								when memberType = 'buyer'  then '구매자' 
								end as memberType

						, email
						, convert(varchar(19),lastLogin,121) as lastLogin
						, convert(varchar(19),regDate,  121) as regDate
						, convert(varchar(19),modDate,  121) as modDate

				from	member a
				order by a.memberType, a.id 
			end

		else if (@kind = 'one') 
			begin 
				select	memIndex, id, password, name, memberType, email, lastLogin, regDate, modDate
				from	member
				where	memIndex = @memIndex
			end

		return 1;
	END TRY
	
	
	BEGIN CATCH
		select -1 as code, 'error' as text
		return -1;
	END CATCH

	--select * from member where memindex in (2,3) and id = 'id'

	