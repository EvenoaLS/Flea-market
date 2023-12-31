--use Xenus
--exec stsSetWishMod 'del', '1'

Alter proc stsSetWishMod
	@kind		varchar(10),
	@wishIndex	varchar(10)

as
	SET NOCOUNT ON
	SET TRANSACTION ISOLATION LEVEL READ UNCOMMITTED	

	BEGIN TRY
		if (@kind = 'del')
			begin
				delete from wish where wishIndex = @wishIndex

				select 1 as code, '삭제되었습니다.' as text
			end

		return 1;
	END TRY
	
	
	BEGIN CATCH
		select -1 as code, 'error' as text
		return -1;
	END CATCH

	--select * from wish