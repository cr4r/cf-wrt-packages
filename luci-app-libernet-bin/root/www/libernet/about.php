<?php
    include('auth.php');
    check_session();
?>
<!doctype html>
<html lang="en">
<head>
    <?php
        $title = "About";
        include("head.php");
    ?>
</head>
<body>
<div id="app">
    <?php include('navbar.php'); ?>
    <div class="container">
        <div class="row">
            <div class="col-lg-8 col-md-12 mx-auto mt-4 mb-2">
                <div class="card">
                    <div class="card-header">
                        <div class="text-center">
                            <h3><i class="fa fa-info"></i> Tentang Libernet</h3>
                        </div>
                    </div>
                    <div class="card-body">
                        <div>
                            <p>
                                Libernet adalah aplikasi web open source untuk tunneling internet di OpenWRT dengan mudah.
                            </p>
                            <span>Fitur yang bekerja:</span>
                            <ul class="m-2">
                                <li>SSH with proxy</li>
                                <li>SSH-SSL</li>
                                <li>V2Ray VMess</li>
                                <li>V2Ray VLESS</li>
                                <li>V2Ray Trojan</li>
                                <li>Trojan</li>
                                <li>Shadowsocks</li>
                                <li>OpenVPN</li>
                            </ul>
                            <p>
                                Beberapa fitur masih dalam pengembangan!
                            </p>
                            <p class="text-right m-0"><a href="https://facebook.com/lutfailham">Laporkan bug</a></p>
                            <p class="text-right m-0">Author: <a href="https://github.com/cr4r"><i>Github</i></a></p>
                        </div>
                        <div class="text-center">
                            <p v-if="status === 3" class="text-danger mt-0 mb-1">Update gagal!</p>
                            <p v-else-if="status === 2" class="text-success mt-0 mb-1">Diperbarui ke versi terbaru!</p>
                            <p v-else-if="status === 1" class="text-secondary mt-0 mb-1">Memperbarui ...</p>
                            <button class="btn btn-primary" :disabled="status === 1" @click="updateLibernet">Perbarui</button>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <?php include('footer.php'); ?>
    </div>
</div>
<?php include("javascript.php"); ?>
<script src="js/about.js"></script>
</body>
</html>