    wc = 0.5 * pi;
    N1 = 21        
    n1 = 0:1:N1-1;
    h1 = fir1(N1-1, wc/pi, boxcar(N1));
    [H1, w1] = freqz(h1);
    f1 = figure(1);
    set(gcf,'outerposition',get(0,'screensize'));
    plot(w1/2/pi, 20*log10(abs(H1)), 'Linewidth', 1.2);
    grid on;
    xlabel('\omega / 2 \pi', 'Fontsize', 16);
    set(gca,'FontSize',15);
    title('20lg|H(e^{j\omega})|', 'Fontsize', 16);
    saveas(f1,'0001','png');
    h=fir1(54,[0.31875*pi/pi,0.68125*pi/pi],'stop');
    [H,W]=freqz(h); 
    f2 = figure(2);
    set(gcf,'outerposition',get(0,'screensize'));
    plot(W/2/pi,20*log10(abs(H)), 'Linewidth', 1.2);
    grid on;
    xlabel('\omega / 2 \pi', 'Fontsize', 16);
    set(gca,'FontSize',15);
    title('20lg|H(e^{j\omega})|', 'Fontsize', 16);
    saveas(f2,'0002','png');