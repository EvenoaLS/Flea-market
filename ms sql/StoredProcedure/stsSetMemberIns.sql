--use Xenus
--exec stsSetMemberIns 'id', 'password', 'Seller', 'sell', 'sell@gmail.com'

Alter proc stsSetMemberIns
	@id					varchar(50),
	@password			varchar(100),
	@memberType			varchar(20), 
	@name				varchar(50),
	@email				varchar(100)

as
	declare @Acnt	int = 0

	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED	

	BEGIN TRY
		select @Acnt = count(*) from member where id = @id

		if (@Acnt > 0)
			begin
				select 0 as code, '아이디 중복입니다.' as text
				return 0;
			end

		insert into	member(id, password, name, memberType, email, lastLogin, regDate, modDate)
					values(@id, @password, @name, @memberType, @email, getdate(), getdate(), getdate())
	
		select 1 as code, 'ok' as text, '' as keyCode, '' as keyStr
		return 1;
	END TRY
	
	
	BEGIN CATCH
		select -1 as code, 'error' as text
		return -1;
	END CATCH

	--select * from member where memindex in (2,3) and id = 'id'

	