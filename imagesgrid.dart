Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'ผลการดำเนินงาน',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[Text('บันทึกข้อมูลสำเร็จ')],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('กลีบ'),
              onPressed: () async {
                  Navigator.pushReplacementNamed(
                    context,
                    '/homepage',
                    arguments: ApiService.pmdata,
                  );
              },
            ),
          ],
        );
      },
    );
  }
