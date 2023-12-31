--use Xenus
--exec stsSetMemberMod 'mod', '12', 'id', 'name', 'buyer', 'sell@gmail.com'
--exec stsSetMemberMod 'del', '12', 'id', 'name', 'buyer', 'sell@gmail.com'

Alter proc stsSetMemberMod
	@kind				varchar(10),
	@memIndex			varchar(10),

	@id					varchar(50),
	@name				varchar(50),
	@memberType			varchar(20),
	@email				varchar(100)

as
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED	

	BEGIN TRY
		if (@kind = 'mod')
			begin
				update member set	  id		 = @id
									, name		 = @name
									, memberType = @memberType
									, email		 = @email
									, modDate	 = getDate()

							where	memIndex	 = @memIndex

				select 1 as code, '수정되었습니다.' as text
			end
			
		else if (@kind = 'del')
			begin
				delete from member where memIndex = @memIndex

				select 1 as code, '삭제되었습니다.' as text
			end

		return 1;
	END TRY
	
	
	BEGIN CATCH
		select -1 as code, 'error' as text, @memIndex as keyCode
		return -1;
	END CATCH

	--select * from member